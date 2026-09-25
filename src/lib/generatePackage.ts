/**
 * Shared Gherkin generation logic used by both BulkImport and DocxImport flows.
 *
 * Orchestrates the full two-step generation pipeline for a single work package:
 * 1. **Table identification** — extract V/P-notation DB references from the text
 *    (fast, local) or ask the AI to identify relevant tables (slower fallback).
 * 2. **Gherkin generation** — build a prompt with the identified table field
 *    definitions and call the AI (direct chatCompletion or via a MyForterro
 *    agent), then parse the response into a `FeatureInput`.
 *
 * Deep-test mode (`testDepth: 'deep'`) runs multiple AI conversation rounds,
 * each adding more scenarios until the AI signals completion or `maxRounds` is
 * reached.
 *
 * Knowledge base integration: when enabled, relevant KB chunks and chains are
 * appended to the prompt so the AI can reference project-specific patterns.
 */

import type { FeatureInput, TableDef } from '../types/gherkin';
import { chatCompletion, chatWithAgentSync, isLoggedIn } from './myforterroApi';
import type { MessageAttachment } from './myforterroApi';
import { getForceKiTableId, getIncludeFieldCheckScenarios, getTaskModel } from './settings';
import { updateLastResponseSummary } from './tokenHistory';
import {
  buildMessages,
  buildTableIdentificationMessages,
  parseTableIdentificationResponse,
  buildKeywordExtractionMessages,
  parseKeywordExtractionResponse,
  lookupRelevantTables,
  buildMessagesWithFields,
  getLastPromptBuildInfo,
  tableDisplayName,
  extractGherkin,
  formatSingleTableContext,
  CHARS_PER_TOKEN,
  buildFullFeatureInstruction,
  buildFeatureContinuationRequest,
  hasFeatureEndMarker,
  stripFeatureEndMarker,
} from './aiPrompt';
import { parseGherkin } from './gherkinParser';
import { resolveTableRefs } from './resolveTableRefs';
import { makeFeatureGuid } from './featureGuid';
import {
  isSchedulingOnlyRequirement,
  makeSchedulingOnlyFeature,
  cleanSchedulingArtifacts,
} from './schedulingShortcut';
import {
  isKnowledgeBaseEnabled,
  getKBMaxChunks,
  isKBChainsEnabled,
  isKBKeywordExtractionEnabled,
  getKBKeywordCount,
} from './settings';
import { searchKnowledgeBase, getCachedChunks, findRelevantChains } from './kbSearch';
import type { KBSearchResult } from '../types/knowledgeBase';
import type { WorkflowEmitter } from './workflowEmitter';
import { NULL_EMITTER } from './workflowEmitter';
import { getPhaseLabel } from './workflowLabels';
import { appendAiPromptLog, extractKeywordsFromHints } from './learningStore';

/**
 * Input options for a single package generation run.
 * All optional callbacks allow callers to stream progress updates to the UI
 * without coupling the generator to any specific component.
 */
export interface GeneratePackageOptions {
  /** The requirements/description text to generate tests from */
  text: string;
  /** Optional workspace learning hints appended to generation context */
  learningHints?: string;
  /** AI model ID (required when no agentId) */
  model: string;
  /** Available table/field definitions */
  tables: TableDef[];
  /** Test user for Background step */
  testUser?: string;
  /** MFT Agent ID — if set, uses agent chat instead of direct chatCompletion */
  agentId?: string;
  /** Reusable file references sent with each agent request for this package. */
  attachments?: MessageAttachment[];
  /** Feature name (incl. chapter number) — used to generate a deterministic GUID */
  featureName?: string;
  /** Streaming callback — called with each text delta as it arrives from the agent */
  onDelta?: (text: string) => void;
  /** Pre-detected relevant tables — skip Step 1 (table identification) entirely if provided */
  forcedRelevantTables?: import('../types/gherkin').TableDef[];
  /** Called after table identification — reports which tables were found and via which path */
  onTablesIdentified?: (info: {
    path: 'local' | 'ki';
    tables: string[];   // identified table names
    fieldCount: number; // total fields in prompt
    /** The request sent for table identification */
    tableIdRequest?: string;
    /** The raw KI response for table identification */
    tableIdRawResponse?: string;
  }) => void;
  /** Called right before the table identification API call — use to show the request in the chat */
  onTableIdStarted?: (request: string) => void;
  /** Called right before the API call with the final assembled prompt */
  onPromptBuilt?: (gherkinRequest: string) => void;
  /** Test depth hint — 'quick' (default) or 'deep' */
  testDepth?: 'quick' | 'deep';
  /** Max rounds for deep test multi-round conversation (default: 5) */
  maxRounds?: number;
  /** Called for each round of deep test conversation */
  onRound?: (round: number, maxRounds: number, sent: string, received: string) => void;
  /** Language for localized workflow timeline labels. */
  lang?: 'de' | 'en';
  /** Workflow timeline emitter (defaults to no-op). */
  emitter?: WorkflowEmitter;
  /** Optional item key to group all steps of this package in the timeline. */
  itemKey?: string;
  /**
   * When provided, each AI prompt (including learning hints) is logged to
   * `.cucumbergnerator-settings/ai-prompt-log.jsonl` for later inspection.
   */
  rootHandle?: FileSystemDirectoryHandle | null;
}

/**
 * The result of a single package generation run.
 * In addition to the parsed `FeatureInput`, carries diagnostics (raw AI
 * responses, prompt details, table identification metadata) for the token
 * history panel and error reporting.
 */
export interface GeneratePackageResult {
  feature: FeatureInput;
  /** Details about what was sent — for token history */
  promptDetails?: string;
  /** Raw AI response text before parsing */
  rawResponse?: string;
  /** How tables were identified */
  tableIdPath: 'local' | 'ki' | 'none';
  /** Identified table names */
  identifiedTables: string[];
  /** Total fields in prompt */
  fieldCount: number;
  /** What was sent for table identification (KI path) */
  tableIdRequest?: string;
  /** What KI responded for table identification */
  tableIdRawResponse?: string;
  /** The actual prompt sent for Gherkin generation (user message) */
  gherkinRequest?: string;
  /** Formatted table context that was included in the prompt (field lists per table) */
  tableContext?: string;
}

/**
 * Generate Gherkin test scenarios for a single package.
 *
 * Flow:
 * 1. Identify relevant tables (local keyword match, AI fallback)
 * 2. Build prompt with field data (progressive reduction if too long)
 * 3. Call AI (via agent or direct chatCompletion)
 * 4. Parse response into FeatureInput
 */
export async function generatePackage(opts: GeneratePackageOptions): Promise<GeneratePackageResult> {
  if (!isLoggedIn()) throw new Error('Nicht eingeloggt. Bitte zuerst anmelden.');

  const { text, learningHints, model, tables, testUser, featureName, onDelta, onTablesIdentified, onTableIdStarted, forcedRelevantTables, onPromptBuilt, attachments } = opts;
  const effectiveText = learningHints && learningHints.trim()
    ? `${text}\n\n${'═'.repeat(67)}\nPROJEKT-KONVENTIONEN (VERBINDLICH — VOR DEM GENERIEREN PRUEFEN!)\n${'═'.repeat(67)}\nDie folgenden Regeln gelten ZUSAETZLICH zum System-Prompt und haben\nfuer dieses Projekt spezifische Prioritaet. Pruefe JEDEN generierten\nStep gegen diese Konventionen und passe ihn an, falls er abweicht.\nKeywords sind projektspezifische Muster, Feldnamen und Konventionen\ndie EXAKT in dieser Form verwendet werden muessen.\n\n${learningHints.trim()}\n${'═'.repeat(67)}`
    : text;
  const logHandle = opts.rootHandle ?? null;
  const agentId = opts.agentId;
  const featureGuid = featureName ? makeFeatureGuid('', featureName) : null;
  const tablesWithFields = tables.filter((t) => t.fields.length > 0);
  const mode = agentId ? 'Agent' : 'Direct';
  const emitter = opts.emitter ?? NULL_EMITTER;
  const lang: 'de' | 'en' = opts.lang ?? 'de';
  const itemKey = opts.itemKey ?? featureName ?? '(package)';
  const displayModel = model;

  // Pure scheduling/disposition requirements always produce exactly one step:
  // "And I run Scheduling". The AI hallucinates editors, articles, and infosystems
  // for this case — bypass it and return the deterministic result directly.
  if (isSchedulingOnlyRequirement(effectiveText)) {
    const feature = makeSchedulingOnlyFeature(featureName);
    emitter.emitLocal({
      phase: 'cuc-table-id-local',
      label: getPhaseLabel('cuc-table-id-local', lang),
      summary: lang === 'de'
        ? 'Tippkommando erkannt — "And I run Scheduling" erzeugt'
        : 'Typed command detected — generated "And I run Scheduling"',
      itemKey,
    });
    onTablesIdentified?.({ path: 'local', tables: [], fieldCount: 0 });
    return {
      feature,
      tableIdPath: 'none',
      identifiedTables: [],
      fieldCount: 0,
    };
  }


  // Track request/response for diagnostics
  let tableIdRequest: string | undefined;
  let tableIdRawResponse: string | undefined;
  let gherkinRequest: string | undefined;
  let tableContext: string | undefined;

  // Step 1: Identify relevant tables.
  // If forcedRelevantTables is provided, skip detection entirely — caller already knows which tables to use.
  // First try local extraction of V-Notation (V-12-03) or P-Notation (P12:3) from the text.
  // These are reliable DB references embedded in Confluence headings. Only fall back to AI if none found.
  let relevantTables: TableDef[] = [];
  let tableIdMethod = 'keine Variablentabelle';
  let tableIdPath: 'local' | 'ki' = 'local';

  const forceKi = getForceKiTableId();

  if (forcedRelevantTables) {
    // Step 1 skipped — use pre-detected tables directly
    relevantTables = forcedRelevantTables;
    tableIdPath = 'local';
    tableIdMethod = `Vorermittelt → ${relevantTables.map(t => tableDisplayName(t)).join(', ')}`;
    tableIdRequest = `(Tabellen bereits lokal ermittelt: ${relevantTables.map(t => `${tableDisplayName(t)} (${t.tableRef})`).join(', ')})`;
    tableIdRawResponse = relevantTables.map(t => `✓ ${tableDisplayName(t)} (${t.tableRef}) — ${t.fields.length} Felder`).join('\n');
    emitter.emitLocal({
      phase: 'cuc-table-id-local',
      label: getPhaseLabel('cuc-table-id-local', lang),
      summary: `${relevantTables.length} ${lang === 'de' ? 'Tabellen vorermittelt' : 'tables pre-detected'}`,
      itemKey,
      outputText: tableIdRawResponse,
    });
    onTablesIdentified?.({
      path: 'local',
      tables: relevantTables.map(t => `${tableDisplayName(t)} (${t.tableRef})`),
      fieldCount: relevantTables.reduce((s, t) => s + t.fields.length, 0),
    });
  } else if (tablesWithFields.length === 0) {
    emitter.emitLocal({
      phase: 'cuc-table-id-local',
      label: getPhaseLabel('cuc-table-id-local', lang),
      summary: lang === 'de' ? '(keine Variablentabellen geladen)' : '(no variable tables loaded)',
      itemKey,
    });
    onTablesIdentified?.({ path: 'local', tables: [], fieldCount: 0 });
  } else {
    // Local: extract V/P-Notation references from text and featureName
    // (skipped when "Immer KI" setting is active)
    const searchText = (featureName || '') + '\n' + effectiveText;
    const refMatches = forceKi ? ''.matchAll(/x/g) : searchText.matchAll(/(?:V-?(\d+)-(\d+)|P(\d+:\d+))\b/gi);
    const localRefs = new Set<string>();
    for (const m of refMatches) {
      if (m[1] && m[2]) {
        localRefs.add(`${parseInt(m[1], 10)}:${parseInt(m[2], 10)}`);
      } else if (m[3]) {
        localRefs.add(m[3]);
      }
    }
    if (localRefs.size > 0) {
      relevantTables = tablesWithFields.filter((t) => localRefs.has(t.tableRef));
      if (relevantTables.length > 0) {
        tableIdMethod = `Lokal (V/P-Notation) → ${relevantTables.map((t) => `${tableDisplayName(t)} (${t.tableRef})`).join(', ')}`;
        tableIdPath = 'local';
        console.log('[generatePackage] Tabellen lokal erkannt:', tableIdMethod);
        // For local detection: show exactly what V/P-notation was found → which table matched
        const matchLines = Array.from(localRefs).map(ref => {
          const matched = relevantTables.find(t => t.tableRef === ref);
          return matched
            ? `${ref} → ${tableDisplayName(matched)} (${matched.tableRef})`
            : `${ref} → (kein Treffer in Variablentabelle)`;
        });
        tableIdRequest = `Im Text erkannte V/P-Notation-Referenzen:\n${matchLines.join('\n') || '(keine)'}`;
        tableIdRawResponse = relevantTables.map(t =>
          `✓ ${tableDisplayName(t)} (${t.tableRef}) — ${t.fields.length} Felder`
        ).join('\n');
        emitter.emitLocal({
          phase: 'cuc-table-id-local',
          label: getPhaseLabel('cuc-table-id-local', lang),
          summary: `${relevantTables.length} ${lang === 'de' ? 'Tabellen über V/P-Notation erkannt' : 'tables via V/P notation'}`,
          itemKey,
          inputText: tableIdRequest,
          outputText: tableIdRawResponse,
        });
        onTablesIdentified?.({
          path: 'local',
          tables: relevantTables.map(t => `${tableDisplayName(t)} (${t.tableRef})`),
          fieldCount: relevantTables.reduce((s, t) => s + t.fields.length, 0),
        });
      }
    }

    // AI fallback: if local extraction found nothing, ask the AI
    if (relevantTables.length === 0) try {
      const step1Messages = buildTableIdentificationMessages(effectiveText);
      const tableListChars = step1Messages.reduce((s, m) => s + m.content.length, 0);
      const step1Details = `Schritt 1: Tabellen-Identifikation | Modus: ${mode} | Nur Beschreibungstext (keine Tabellennamen) | ${tableListChars.toLocaleString('de-DE')} Zeichen (~${Math.ceil(tableListChars / CHARS_PER_TOKEN).toLocaleString('de-DE')} Tokens)`;
      console.log('[generatePackage]', step1Details);

      const sysPromptTableId = step1Messages.find(m => m.role === 'system')?.content ?? '';
      const userPromptTableId = step1Messages.find(m => m.role === 'user')?.content ?? '';
      const tableIdStepId = emitter.startStep({
        kind: 'ai',
        phase: 'cuc-table-id-ai',
        label: getPhaseLabel('cuc-table-id-ai', lang),
        agent: 'cucumber-table-id',
        systemPrompt: sysPromptTableId,
        userPrompt: userPromptTableId,
        model: displayModel,
        itemKey,
      });

      let step1Response: string;
      if (agentId) {
        const systemContent = step1Messages.find((m) => m.role === 'system')?.content ?? '';
        const userContent = step1Messages.find((m) => m.role === 'user')?.content ?? '';
        const combined = `AUFGABE: Identifiziere die relevanten Datenbanken und Infosysteme. Generiere KEIN Gherkin, antworte NUR mit JSON.\n\n${systemContent}\n\n${userContent}`;
        tableIdRequest = combined;
        onTableIdStarted?.(combined);
        const result = await chatWithAgentSync(agentId, combined, 'table-identification', getTaskModel('table-identification'), step1Details, undefined, attachments);
        step1Response = result.response;
      } else {
        tableIdRequest = step1Messages.map(m => `[${m.role.toUpperCase()}]\n${m.content}`).join('\n\n---\n\n');
        onTableIdStarted?.(tableIdRequest);
        step1Response = await chatCompletion(step1Messages, getTaskModel('table-identification'), 'table-identification', step1Details);
      }
      tableIdRawResponse = step1Response;
      emitter.completeStep(tableIdStepId, { rawResponse: step1Response });
      const identified = parseTableIdentificationResponse(step1Response);
      console.log('[generatePackage] Tabellen-ID Rohantwort:', step1Response);
      console.log('[generatePackage] Tabellen-ID geparst:', identified);
      relevantTables = lookupRelevantTables(identified, tablesWithFields);
      console.log('[generatePackage] Gematchte Tabellen:', relevantTables.map((t) => `${tableDisplayName(t)} (${t.tableRef})`));
      const idSummary = relevantTables.length > 0
        ? `Antwort: ${relevantTables.map((t) => `${tableDisplayName(t)} (${t.tableRef})`).join(', ')} | KI-Rohantwort: ${step1Response.slice(0, 200)}`
        : `Antwort: Keine Treffer | KI-Rohantwort: ${step1Response.slice(0, 200)}`;
      updateLastResponseSummary(idSummary);
      tableIdMethod = relevantTables.length > 0
        ? `KI → ${relevantTables.map((t) => tableDisplayName(t)).join(', ')}`
        : 'KI-keine-Treffer';
      tableIdPath = 'ki';
      // Build clean KI output: matched tables + reason from KI
      const kiOutput = [
        relevantTables.length > 0
          ? relevantTables.map(t => `✓ ${tableDisplayName(t)} (${t.tableRef}) — ${t.fields.length} Felder`).join('\n')
          : '(keine Treffer)',
        identified.grund ? `\nGrund: ${identified.grund}` : '',
      ].join('');
      tableIdRawResponse = kiOutput;
      onTablesIdentified?.({
        path: 'ki',
        tables: relevantTables.map(t => `${tableDisplayName(t)} (${t.tableRef})`),
        fieldCount: relevantTables.reduce((s, t) => s + t.fields.length, 0),
        tableIdRequest,
        tableIdRawResponse,
      });
    } catch (err) {
      // Table identification failed — still report KI path with empty result
      console.warn('[generatePackage] Tabellen-Identifikation fehlgeschlagen, generiere ohne Felder:', err);
      tableIdMethod = 'Identifikation-fehlgeschlagen';
      emitter.emitLocal({
        phase: 'cuc-table-id-ai',
        label: (lang === 'de' ? 'Tabellen-ID fehlgeschlagen' : 'Table ID failed'),
        summary: (err as Error).message?.slice(0, 120) ?? String(err),
        itemKey,
      });
      onTablesIdentified?.({ path: 'ki', tables: [`Fehler: ${(err as Error).message?.slice(0, 60)}`], fieldCount: 0 });
    }
  }

  void tableIdPath; // used implicitly via onTablesIdentified path

  // ── Agent-Stichpunkte für erweiterte KB-Suche ──
  // Wenn KB und Stichpunkt-Extraktion aktiv sind, fragen wir den Agent einmalig
  // nach thematischen Schlagwörtern, die über die identifizierten Tabellen hinausgehen.
  // Das erlaubt der KB-Suche, Chunks zu finden, deren Überschriften zu Themen wie
  // "Chargenpflicht" oder "Sperrkennzeichen" passen, ohne dass eine Tabelle dies explizit abbildet.
  let agentKeywords: string[] = [];
  let aiFieldHints: string[] = [];
  if (isKnowledgeBaseEnabled() && isKBKeywordExtractionEnabled()) {
    const kwCount = getKBKeywordCount();
    const kwLang: 'de' | 'en' = 'de';
    const knownNames = relevantTables.map(t => tableDisplayName(t));
    const kwMessages = buildKeywordExtractionMessages(effectiveText, knownNames, kwCount, kwLang);
    const kwDetails = `Stichpunkt-Extraktion (KB) | Anzahl: ${kwCount} | Bekannte Tabellen: ${knownNames.length}`;
    const kwSystem = kwMessages.find(m => m.role === 'system')?.content ?? '';
    const kwUser = kwMessages.find(m => m.role === 'user')?.content ?? '';
    const kwStepId = emitter.startStep({
      kind: 'ai',
      phase: 'cuc-kb-extract',
      label: getPhaseLabel('cuc-kb-extract', lang),
      agent: 'cucumber-kb-keywords',
      systemPrompt: kwSystem,
      userPrompt: kwUser,
      model: displayModel,
      itemKey,
    });
    try {
      let kwResponse = '';
      if (agentId) {
        const combined = `AUFGABE: Nenne thematische Stichpunkte fuer die Wissensdatenbank-Suche. Antworte NUR mit JSON.\n\n${kwSystem}\n\n${kwUser}`;
        const result = await chatWithAgentSync(agentId, combined, 'kb-keywords', getTaskModel('kb-keywords'), kwDetails, undefined, attachments);
        kwResponse = result.response;
      } else {
        kwResponse = await chatCompletion(kwMessages, getTaskModel('kb-keywords'), 'kb-keywords', kwDetails);
      }
      emitter.completeStep(kwStepId, { rawResponse: kwResponse });
      const kwResult = parseKeywordExtractionResponse(kwResponse, kwCount);
      agentKeywords = kwResult.keywords;
      aiFieldHints = kwResult.fieldHints;
      if (agentKeywords.length > 0) {
        console.log(`[generatePackage] 🔑 Agent-Stichpunkte (${agentKeywords.length}): ${agentKeywords.join(', ')}`);
      } else {
        console.log('[generatePackage] 🔑 Agent-Stichpunkte: Keine geliefert / nicht parsebar');
      }
      if (aiFieldHints.length > 0) {
        console.log(`[generatePackage] 🔑 Feld-Hinweise (${aiFieldHints.length}): ${aiFieldHints.join(', ')}`);
      }
    } catch (err) {
      emitter.failStep(kwStepId, err instanceof Error ? err.message : String(err));
      console.warn('[generatePackage] 🔑 Stichpunkt-Extraktion fehlgeschlagen:', err);
    }
  }

  // ── Knowledge Base: search for relevant documentation ──
  let kbResults: KBSearchResult[] = [];
  if (isKnowledgeBaseEnabled() && (relevantTables.length > 0 || agentKeywords.length > 0)) {
    try {
      const chunks = await getCachedChunks();
      if (chunks.length > 0) {
        const processChains = isKBChainsEnabled() ? findRelevantChains(relevantTables) : [];
        kbResults = searchKnowledgeBase(chunks, {
          tables: relevantTables,
          processChains,
          requirementsText: effectiveText,
          keywords: agentKeywords,
        }, getKBMaxChunks());
        if (kbResults.length > 0) {
          console.log(`[generatePackage] 📚 Wissensdatenbank: ${kbResults.length} relevante Hilfe-Einträge gefunden`);
          for (const r of kbResults) {
            console.log(`  → ${r.chunk.heading} (Score: ${r.score.toFixed(1)}, Keywords: ${r.chunk.keywords?.join(', ') ?? '-'}, Matched: ${r.matchedTerms.join(', ')})`);
          }
        } else {
          console.log('[generatePackage] 📚 Wissensdatenbank: Keine passenden Einträge gefunden');
        }
        emitter.emitLocal({
          phase: 'cuc-kb-search',
          label: getPhaseLabel('cuc-kb-search', lang),
          summary: `${kbResults.length} ${lang === 'de' ? 'Einträge · ' : 'entries · '}${chunks.length} ${lang === 'de' ? 'Chunks durchsucht' : 'chunks searched'}`,
          itemKey,
          outputText: kbResults.length > 0
            ? kbResults.map(r => `[${r.score.toFixed(1)}] ${r.chunk.heading} · matched: ${r.matchedTerms.join(', ')}`).join('\n')
            : (lang === 'de' ? '(keine Treffer)' : '(no matches)'),
        });
      } else {
        console.log('[generatePackage] 📚 Wissensdatenbank: Aktiviert aber keine Chunks geladen');
      }
    } catch (err) {
      console.warn('[generatePackage] 📚 Wissensdatenbank-Suche fehlgeschlagen:', err);
    }
  }

  // Build table context preview (field lists per table) for diagnostics
  if (relevantTables.length > 0) {
    tableContext = relevantTables.map(t => formatSingleTableContext(t, effectiveText)).join('\n\n');
  }

  // Step 2+3: Build prompt and call AI
  //
  // Single-message mode ONLY. Chunked/batched sends were removed because they
  // hit Bedrock per-minute rate-limits for any run with more than a couple of
  // tables — one prompt with everything is the more reliable strategy and the
  // user sees one clean AI exchange in the timeline instead of many scattered
  // context sends.
  let responseText = '';
  let promptDetails = '';

  {
    let messages: { role: 'system' | 'user'; content: string }[];
    let promptMode: string;
    // Append AI field hints to the text so isFieldRelevant can match them
    const textWithFieldHints = aiFieldHints.length > 0
      ? `${effectiveText}\n${aiFieldHints.join(' ')}`
      : effectiveText;
    if (relevantTables.length > 0) {
      messages = buildMessagesWithFields(textWithFieldHints, relevantTables, testUser, kbResults.length > 0 ? kbResults : undefined, lang);
      promptMode = 'mit-Feldern';
    } else {
      messages = buildMessages(effectiveText, testUser, tables, lang);
      promptMode = 'nur-Tabellennamen';
    }

    // Inject feature GUID into the user message
    if (featureGuid) {
      const userMsg = messages.find((m) => m.role === 'user');
      if (userMsg) {
        userMsg.content += lang === 'en'
          ? `\n\nFeature GUID: ${featureGuid}\nUse this GUID as the @-tag and for the guid-field logic according to the rules in the system prompt.`
          : `\n\nFeature-GUID: ${featureGuid}\nVerwende diese GUID als @-Tag und fuer die guid-Feld-Logik gemaess den Regeln im System-Prompt.`;
      }
    }

    const buildInfo = getLastPromptBuildInfo();
    const detailParts: string[] = [];
    detailParts.push(`Schritt 2: Gherkin-Generierung`);
    detailParts.push(`Modus: ${mode}`);
    detailParts.push(`Tabellen-ID: ${tableIdMethod}`);
    detailParts.push(`Prompt: ${promptMode}`);
    if (buildInfo) {
      detailParts.push(`${buildInfo.tableCount} Tabellen, ${buildInfo.fieldCount} Felder (nach Filter)`);
      detailParts.push(`Reduktion: Level ${buildInfo.reductionLevel}`);
      detailParts.push(`System: ${buildInfo.systemChars} Zeichen, User: ${buildInfo.userChars} Zeichen`);
      detailParts.push(`Geschätzt: ~${buildInfo.estimatedTokens.toLocaleString('de-DE')} Tokens`);
    } else {
      const totalChars = messages.reduce((sum, m) => sum + m.content.length, 0);
      detailParts.push(`Message: ${totalChars.toLocaleString('de-DE')} Zeichen (~${Math.ceil(totalChars / CHARS_PER_TOKEN).toLocaleString('de-DE')} Tokens)`);
    }
    promptDetails = detailParts.join(' | ');
    console.log('[generatePackage]', promptDetails);

    if (agentId && opts.testDepth !== 'deep') {
      // ── Single-shot generation with automatic continuation on truncation ──
      // The AI writes the WHOLE feature in one response. If the output-token
      // ceiling truncates it (missing `# FEATURE_END` marker), we send a
      // continuation request in the SAME agent conversation so the server
      // already holds the partial output as context.
      //
      // Keeping everything in one semantic context means the AI does not
      // re-setup master data or invent steps that duplicate an earlier
      // scenario — a problem the previous per-scenario split produced.
      const fullUserMessage = messages.find((m) => m.role === 'user')?.content ?? effectiveText;
      const fullSystemPrompt = messages.find((m) => m.role === 'system')?.content ?? '(agent system prompt on server)';
      const skipFieldChecks = !getIncludeFieldCheckScenarios();
      const fullFeatureInstruction = buildFullFeatureInstruction(lang, { skipFieldChecks });
      const initialRequest = `${fullUserMessage}\n\n${fullFeatureInstruction}`;

      gherkinRequest = initialRequest;
      onPromptBuilt?.(gherkinRequest);
      // Log prompt to settings dir for later inspection
      if (logHandle) {
        void appendAiPromptLog(logHandle, {
          ts: new Date().toISOString(),
          phase: 'gherkin-generation-agent',
          item: featureName,
          effectiveTextSnippet: effectiveText.slice(0, 400),
          learningHints: learningHints?.slice(0, 2000),
          learningKeywords: learningHints ? extractKeywordsFromHints(learningHints) : undefined,
          promptSnippet: initialRequest.slice(0, 800),
          promptLength: initialRequest.length,
          relevantTables: relevantTables.map((t) => t.tableRef),
        });
      }
      emitter.emitLocal({
        phase: 'cuc-build-prompt',
        label: getPhaseLabel('cuc-build-prompt', lang),
        summary: `${initialRequest.length} ${lang === 'de' ? 'Zeichen · Single-Shot mit Fortsetzung' : 'chars · single-shot with continuation'}`,
        itemKey,
        outputText: gherkinRequest,
      });

      const MAX_CONTINUATIONS = 5;

      const initialResponse = await emitter.emitAiCall(
        {
          phase: 'cuc-generate',
          label: getPhaseLabel('cuc-generate', lang),
          agent: 'cucumber-gherkin',
          systemPrompt: fullSystemPrompt,
          userPrompt: initialRequest,
          model: displayModel,
          itemKey,
        },
        async () => {
          const r = await chatWithAgentSync(agentId, initialRequest, 'gherkin-generation', model, promptDetails, onDelta, attachments);
          return r.response;
        },
      );

      let accumulatedResponse = initialResponse;
      let round = 0;

      while (!hasFeatureEndMarker(accumulatedResponse) && round < MAX_CONTINUATIONS) {
        round++;
        console.warn(`[generatePackage] Feature-Antwort abgeschnitten — Fortsetzung ${round}/${MAX_CONTINUATIONS}`);
        const continuationRequest = buildFeatureContinuationRequest(lang);

        let continuation: string;
        try {
          continuation = await emitter.emitAiCall(
            {
              phase: 'cuc-scenario-continue',
              label: `${getPhaseLabel('cuc-scenario-continue', lang)} (${round}/${MAX_CONTINUATIONS})`,
              agent: 'cucumber-gherkin',
              systemPrompt: fullSystemPrompt,
              userPrompt: continuationRequest,
              model: displayModel,
              itemKey,
            },
            async () => {
              const r = await chatWithAgentSync(agentId, continuationRequest, 'gherkin-generation', model, `Continuation ${round}`, onDelta, attachments);
              return r.response;
            },
          );
        } catch (err) {
          console.warn(`[generatePackage] Fortsetzung ${round} fehlgeschlagen (${err instanceof Error ? err.message?.slice(0, 80) : String(err)}) — breche Continuation-Loop ab, versuche Parse mit bisherigem Text.`);
          break;
        }
        accumulatedResponse = accumulatedResponse + continuation;
      }

      if (!hasFeatureEndMarker(accumulatedResponse) && round >= MAX_CONTINUATIONS) {
        console.warn(`[generatePackage] Feature nach ${MAX_CONTINUATIONS} Fortsetzungen immer noch ohne # FEATURE_END — parse trotzdem, Ergebnis kann unvollstaendig sein.`);
      }

      responseText = stripFeatureEndMarker(accumulatedResponse);
    } else {
      gherkinRequest = messages.map(m => `[${m.role.toUpperCase()}]\n${m.content}`).join('\n\n---\n\n');
      onPromptBuilt?.(gherkinRequest);
      // Log prompt to settings dir for later inspection
      if (logHandle) {
        void appendAiPromptLog(logHandle, {
          ts: new Date().toISOString(),
          phase: 'gherkin-generation-direct',
          item: featureName,
          effectiveTextSnippet: effectiveText.slice(0, 400),
          learningHints: learningHints?.slice(0, 2000),
          learningKeywords: learningHints ? extractKeywordsFromHints(learningHints) : undefined,
          promptSnippet: gherkinRequest.slice(0, 800),
          promptLength: gherkinRequest.length,
          relevantTables: relevantTables.map((t) => t.tableRef),
        });
      }
      emitter.emitLocal({
        phase: 'cuc-build-prompt',
        label: getPhaseLabel('cuc-build-prompt', lang),
        summary: `${messages.reduce((s, m) => s + m.content.length, 0)} ${lang === 'de' ? 'Zeichen' : 'chars'} · ${messages.length} ${lang === 'de' ? 'Nachrichten' : 'messages'}`,
        itemKey,
        outputText: gherkinRequest,
      });

      if (opts.testDepth === 'deep') {
        // ── Multi-round deep test conversation ──
        const maxRounds = opts.maxRounds ?? 5;
        const deepInstruction = `\n\nWICHTIG — INTERAKTIVER MODUS:\nDu kannst in mehreren Runden arbeiten. Analysiere den Anforderungstext VOLLSTAENDIG und fordere ALLE benoetigten Datenbanken/Infosysteme AUF EINMAL an — nicht einzeln!\nBeachte: Wenn im Text Aufzaehlungen, Stammdaten, Belege oder andere Tabellen erwaehnt werden, fordere diese ALLE in einer Anfrage an.\nAntwortformat fuer Tabellenanforderung: NUR JSON: {"needTables": ["Datenbankname1", "Datenbankname2"], "reason": "Warum?"}\nSobald du alle Felder hast, generiere den Gherkin-Test (beginnend mit "Feature:").`;

        // Append deep instruction to user message
        const userMsg = messages.find(m => m.role === 'user');
        if (userMsg) userMsg.content += deepInstruction;

        const sentTableRefs = new Set(relevantTables.map(t => t.tableRef));
        console.log(`[generatePackage] ▶ Deep test: starting ${maxRounds} rounds`);

        for (let round = 1; round <= maxRounds; round++) {
          const lastMsg = messages[messages.length - 1].content;
          console.log(`[generatePackage-Deep] Round ${round}/${maxRounds} | ${messages.length} messages`);

          const sysPrompt = messages.find(m => m.role === 'system')?.content ?? '';
          const roundStepId = emitter.startStep({
            kind: 'ai',
            phase: 'cuc-deep-round',
            label: `${getPhaseLabel('cuc-deep-round', lang)} ${round}/${maxRounds}`,
            agent: 'cucumber-deep',
            systemPrompt: sysPrompt,
            userPrompt: lastMsg,
            model: displayModel,
            itemKey,
          });

          let response: string;
          try {
            response = await chatCompletion(messages, model, 'gherkin-generation', `Deep R${round}/${maxRounds}`);
          } catch (err) {
            emitter.failStep(roundStepId, (err as Error).message ?? String(err));
            throw err;
          }
          emitter.completeStep(roundStepId, { rawResponse: response });

          console.log(`[generatePackage-Deep] Round ${round} response: ${response.slice(0, 150)}...`);
          opts.onRound?.(round, maxRounds, lastMsg, response);

          // Got Gherkin? → done
          if (response.match(/Feature:[\s\S]*/i)) {
            console.log(`[generatePackage-Deep] Got Gherkin in round ${round}`);
            responseText = response;
            break;
          }

          // AI asks for more tables?
          const jsonMatch = response.match(/\{[\s\S]*"needTables"[\s\S]*\}/);
          if (jsonMatch) {
            try {
              const parsed = JSON.parse(jsonMatch[0]);
              const requestedNames: string[] = parsed.needTables ?? [];
              console.log(`[generatePackage-Deep] AI requests tables:`, requestedNames);

              const newTables = requestedNames
                .map(name => lookupRelevantTables(
                  parseTableIdentificationResponse(JSON.stringify({ tables: [name], infosystems: [] })),
                  tablesWithFields
                ))
                .flat()
                .filter(t => !sentTableRefs.has(t.tableRef));

              if (newTables.length > 0) {
                const newContext = newTables.map(t => formatSingleTableContext(t, effectiveText)).join('\n\n');
                for (const t of newTables) sentTableRefs.add(t.tableRef);
                const fieldCount = newTables.reduce((s, t) => s + t.fields.length, 0);

                // KB search for newly requested tables
                let kbPart = '';
                if (isKnowledgeBaseEnabled()) {
                  try {
                    const chunks = await getCachedChunks();
                    if (chunks.length > 0) {
                      const newChains = isKBChainsEnabled() ? findRelevantChains(newTables) : [];
                      const newKbResults = searchKnowledgeBase(chunks, {
                        tables: newTables,
                        processChains: newChains,
                        requirementsText: effectiveText,
                        keywords: agentKeywords,
                      }, getKBMaxChunks());
                      if (newKbResults.length > 0) {
                        const { formatKBContextForPrompt } = await import('./aiPrompt');
                        kbPart = `\n\nHier ist Referenz-Dokumentation zu den neuen Tabellen:\n${formatKBContextForPrompt(newKbResults)}`;
                        console.log(`[generatePackage-Deep] 📚 KB für nachgeforderte Tabellen: ${newKbResults.length} Einträge`);
                        for (const r of newKbResults) {
                          console.log(`  → ${r.chunk.heading} (Score: ${r.score.toFixed(1)}, Matched: ${r.matchedTerms.join(', ')})`);
                        }
                      }
                    }
                  } catch (err) {
                    console.warn('[generatePackage-Deep] 📚 KB-Suche für neue Tabellen fehlgeschlagen:', err);
                  }
                }

                const followUp = `Hier sind die angeforderten Felder (${newTables.length} Tabellen, ${fieldCount} Felder):\n\n${newContext}${kbPart}\n\nGeneriere jetzt den Gherkin-Test oder frage nach weiteren Tabellen.`;
                messages.push({ role: 'user', content: followUp });
              } else {
                // No field data available, but still search KB for documentation
                let kbFallback = '';
                if (isKnowledgeBaseEnabled()) {
                  try {
                    const chunks = await getCachedChunks();
                    if (chunks.length > 0) {
                      // Build lightweight TableDef stubs for KB search
                      const stubs: TableDef[] = requestedNames.map(n => ({
                        name: n, nameDe: n, tableRef: '', kind: 'database' as const, fields: [], database: '', group: '',
                      }));
                      const stubKbResults = searchKnowledgeBase(chunks, {
                        tables: stubs,
                        requirementsText: effectiveText,
                        keywords: agentKeywords,
                      }, getKBMaxChunks());
                      if (stubKbResults.length > 0) {
                        const { formatKBContextForPrompt } = await import('./aiPrompt');
                        kbFallback = `\n\nAuch wenn keine Felddaten verfuegbar sind, hier ist Referenz-Dokumentation:\n${formatKBContextForPrompt(stubKbResults)}`;
                        console.log(`[generatePackage-Deep] 📚 KB für nicht-verfügbare Tabellen (${requestedNames.join(', ')}): ${stubKbResults.length} Einträge`);
                      }
                    }
                  } catch (err) {
                    console.warn('[generatePackage-Deep] 📚 KB-Fallback-Suche fehlgeschlagen:', err);
                  }
                }
                const noMatch = `Fuer die Tabellen (${requestedNames.join(', ')}) sind keine Felddefinitionen verfuegbar. Verwende die gaengigen Standardfelder (such, guid, name fuer Stammdaten) und die im Anforderungstext genannten Felder.${kbFallback}\n\nGeneriere jetzt den Gherkin-Test oder frage nach weiteren Tabellen.`;
                messages.push({ role: 'user', content: noMatch });
              }
              continue;
            } catch { break; }
          }

          // Neither Gherkin nor table request → unexpected, break
          console.log(`[generatePackage-Deep] Unexpected response, breaking`);
          responseText = response;
          break;
        }

        // If no responseText yet, force final
        if (!responseText) {
          const forceMsg = 'Max. Runden erreicht. Generiere JETZT den Gherkin-Test. Antworte NUR mit dem Feature.';
          messages.push({ role: 'user', content: forceMsg });
          const forceStepId = emitter.startStep({
            kind: 'ai',
            phase: 'cuc-deep-round',
            label: lang === 'de' ? 'Deep-Test Force Final' : 'Deep test force final',
            agent: 'cucumber-deep',
            systemPrompt: messages.find(m => m.role === 'system')?.content ?? '',
            userPrompt: forceMsg,
            model: displayModel,
            itemKey,
          });
          try {
            responseText = await chatCompletion(messages, model, 'gherkin-generation', 'Deep FINAL');
          } catch (err) {
            emitter.failStep(forceStepId, (err as Error).message ?? String(err));
            throw err;
          }
          emitter.completeStep(forceStepId, { rawResponse: responseText });
          opts.onRound?.(maxRounds + 1, maxRounds, forceMsg, responseText);
        }
      } else {
        // ── Single-shot quick test ──
        console.log('[generatePackage] ▶ SENDE AN KI (Direct, quick)');
        responseText = await emitter.emitAiCall(
          {
            phase: 'cuc-generate',
            label: getPhaseLabel('cuc-generate', lang),
            agent: 'cucumber-gherkin',
            systemPrompt: messages.find(m => m.role === 'system')?.content ?? '',
            userPrompt: messages.find(m => m.role === 'user')?.content ?? '',
            model: displayModel,
            itemKey,
          },
          async () => {
            return await chatCompletion(messages, model, 'gherkin-generation', promptDetails);
          },
        );
      }
    }
  }

  // Step 4: Parse response
  console.log('[generatePackage] KI-Rohantwort:', responseText);
  const gherkin = extractGherkin(responseText);
  console.log('[generatePackage] Extrahiertes Gherkin:', gherkin);
  let parsed = parseGherkin(gherkin, { fromAI: true });
  // Rewrite any remaining `for tip command "Scheduling"` artifacts the AI might
  // have produced despite the prompt rules — collapse such scenarios to a
  // single canonical `And I run Scheduling` step.
  parsed = cleanSchedulingArtifacts(parsed);
  console.log('[generatePackage] Geparst:', parsed.scenarios.length, 'Szenarien', parsed.scenarios.map((s) => s.name));
  emitter.emitLocal({
    phase: 'cuc-parse',
    label: getPhaseLabel('cuc-parse', lang),
    summary: `${parsed.scenarios.length} ${lang === 'de' ? 'Szenarien' : 'scenarios'} · ${parsed.scenarios.reduce((s, sc) => s + sc.steps.length, 0)} ${lang === 'de' ? 'Steps' : 'steps'}`,
    itemKey,
    outputText: gherkin,
  });

  if (tables.length > 0) {
    parsed = resolveTableRefs(parsed, tables);
  }

  // Log generation response summary
  const totalSteps = parsed.scenarios.reduce((s, sc) => s + sc.steps.length, 0);
  const scenarioNames = parsed.scenarios.map((sc) => sc.name).join(', ');
  updateLastResponseSummary(
    `Antwort: ${parsed.scenarios.length} Szenarien, ${totalSteps} Steps | ${scenarioNames} | Antwort-Länge: ${responseText.length} Zeichen`
  );

  if (parsed.scenarios.length === 0) {
    throw new Error('Keine Szenarien in der KI-Antwort.');
  }

  const identifiedTables = relevantTables.map(t => `${tableDisplayName(t)} (${t.tableRef})`);
  const fieldCount = relevantTables.reduce((s, t) => s + t.fields.length, 0);
  return {
    feature: parsed, promptDetails, rawResponse: responseText,
    tableIdPath: tableIdPath as 'local' | 'ki' | 'none',
    identifiedTables,
    fieldCount,
    tableIdRequest,
    tableIdRawResponse,
    gherkinRequest,
    tableContext,
  };
}
