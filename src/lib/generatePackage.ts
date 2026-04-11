/**
 * Shared Gherkin generation logic used by both BulkImport and DocxImport flows.
 *
 * Orchestrates the full two-step generation pipeline for a single work package:
 * 1. **Table identification** — extract V/P-notation DB references from the text
 *    (fast, local) or ask the AI to identify relevant tables (slower fallback).
 * 2. **Gherkin generation** — build a prompt with the identified table field
 *    definitions and call the AI (direct chatCompletion, OpenRouter, or via a
 *    MyForterro agent), then parse the response into a `FeatureInput`.
 *
 * Deep-test mode (`testDepth: 'deep'`) runs multiple AI conversation rounds,
 * each adding more scenarios until the AI signals completion or `maxRounds` is
 * reached.
 *
 * Knowledge base integration: when enabled, relevant KB chunks and chains are
 * appended to the prompt so the AI can reference project-specific patterns.
 */

import type { FeatureInput, TableDef } from '../types/gherkin';
import { chatCompletion, chatWithAgentSync, isLoggedIn, isMftTenantOrAuthError } from './myforterroApi';
import { openRouterChatCompletion } from './openrouter';
import { isOpenRouterEnabled, getOpenRouterKey, getForceKiTableId } from './settings';
import { updateLastResponseSummary } from './tokenHistory';
import {
  buildMessages,
  buildTableIdentificationMessages,
  parseTableIdentificationResponse,
  lookupRelevantTables,
  buildMessagesWithFields,
  getLastPromptBuildInfo,
  tableDisplayName,
  extractGherkin,
  formatSingleTableContext,
  buildChunkedContextMessage,
  getGenPrefix,
  getFieldUsageRules,
  getTestDepthInstruction,
  CHARS_PER_TOKEN,
} from './aiPrompt';
import { parseGherkin } from './gherkinParser';
import { resolveTableRefs } from './resolveTableRefs';
import { makeFeatureGuid } from './featureGuid';
import { isKnowledgeBaseEnabled, getKBMaxChunks, isKBChainsEnabled } from './settings';
import { searchKnowledgeBase, getCachedChunks, findRelevantChains } from './kbSearch';
import type { KBSearchResult } from '../types/knowledgeBase';

/**
 * Input options for a single package generation run.
 * All optional callbacks allow callers to stream progress updates to the UI
 * without coupling the generator to any specific component.
 */
export interface GeneratePackageOptions {
  /** The requirements/description text to generate tests from */
  text: string;
  /** AI model ID (required when no agentId) */
  model: string;
  /** Available table/field definitions */
  tables: TableDef[];
  /** Test user for Background step */
  testUser?: string;
  /** MFT Agent ID — if set, uses agent chat instead of direct chatCompletion */
  agentId?: string;
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
  const openRouterAvailable = isOpenRouterEnabled() && !!getOpenRouterKey();
  if (!isLoggedIn() && !openRouterAvailable) throw new Error('Nicht eingeloggt. Bitte zuerst anmelden.');

  const { text, model, tables, testUser, featureName, onDelta, onTablesIdentified, onTableIdStarted, forcedRelevantTables, onPromptBuilt } = opts;
  const agentId = opts.agentId;
  const featureGuid = featureName ? makeFeatureGuid('', featureName) : null;
  const tablesWithFields = tables.filter((t) => t.fields.length > 0);
  const mode = agentId ? 'Agent' : 'Direct';

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
    onTablesIdentified?.({
      path: 'local',
      tables: relevantTables.map(t => `${tableDisplayName(t)} (${t.tableRef})`),
      fieldCount: relevantTables.reduce((s, t) => s + t.fields.length, 0),
    });
  } else if (tablesWithFields.length === 0) {
    onTablesIdentified?.({ path: 'local', tables: [], fieldCount: 0 });
  } else {
    // Local: extract V/P-Notation references from text and featureName
    // (skipped when "Immer KI" setting is active)
    const searchText = (featureName || '') + '\n' + text;
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
        onTablesIdentified?.({
          path: 'local',
          tables: relevantTables.map(t => `${tableDisplayName(t)} (${t.tableRef})`),
          fieldCount: relevantTables.reduce((s, t) => s + t.fields.length, 0),
        });
      }
    }

    // AI fallback: if local extraction found nothing, ask the AI
    if (relevantTables.length === 0) try {
      const step1Messages = buildTableIdentificationMessages(text);
      const tableListChars = step1Messages.reduce((s, m) => s + m.content.length, 0);
      const step1Details = `Schritt 1: Tabellen-Identifikation | Modus: ${mode} | Nur Beschreibungstext (keine Tabellennamen) | ${tableListChars.toLocaleString('de-DE')} Zeichen (~${Math.ceil(tableListChars / CHARS_PER_TOKEN).toLocaleString('de-DE')} Tokens)`;
      console.log('[generatePackage]', step1Details);

      let step1Response: string;
      if (agentId) {
        const systemContent = step1Messages.find((m) => m.role === 'system')?.content ?? '';
        const userContent = step1Messages.find((m) => m.role === 'user')?.content ?? '';
        const combined = `AUFGABE: Identifiziere die relevanten Datenbanken und Infosysteme. Generiere KEIN Gherkin, antworte NUR mit JSON.\n\n${systemContent}\n\n${userContent}`;
        tableIdRequest = combined;
        onTableIdStarted?.(combined);
        try {
          const result = await chatWithAgentSync(agentId, combined, null, 'table-identification', model, step1Details);
          step1Response = result.response;
        } catch (agentErr) {
          if (isMftTenantOrAuthError(agentErr) && openRouterAvailable) {
            console.log(`[generatePackage] Agent Tabellen-ID fehlgeschlagen (${(agentErr as Error).message?.slice(0, 60)}) → Fallback auf OpenRouter`);
            step1Response = await openRouterChatCompletion(step1Messages, 'table-identification', step1Details);
          } else if (isMftTenantOrAuthError(agentErr)) {
            // No OpenRouter available either — try direct chatCompletion as last resort
            console.log(`[generatePackage] Agent Tabellen-ID fehlgeschlagen → Fallback auf chatCompletion`);
            step1Response = await chatCompletion(step1Messages, model, 'table-identification', step1Details);
          } else {
            throw agentErr;
          }
        }
      } else {
        tableIdRequest = step1Messages.map(m => `[${m.role.toUpperCase()}]\n${m.content}`).join('\n\n---\n\n');
        onTableIdStarted?.(tableIdRequest);
        try {
          step1Response = await chatCompletion(step1Messages, model, 'table-identification', step1Details);
        } catch (err) {
          if (isMftTenantOrAuthError(err) && openRouterAvailable) {
            console.log(`[generatePackage] MFT-Fehler (${(err as Error).message?.slice(0, 60)}) → Fallback auf OpenRouter (Tabellen-ID)`);
            step1Response = await openRouterChatCompletion(step1Messages, 'table-identification', step1Details);
          } else {
            throw err;
          }
        }
      }
      tableIdRawResponse = step1Response;
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
      onTablesIdentified?.({ path: 'ki', tables: [`Fehler: ${(err as Error).message?.slice(0, 60)}`], fieldCount: 0 });
    }
  }

  void tableIdPath; // used implicitly via onTablesIdentified path

  // ── Knowledge Base: search for relevant documentation ──
  let kbResults: KBSearchResult[] = [];
  if (isKnowledgeBaseEnabled() && relevantTables.length > 0) {
    try {
      const chunks = await getCachedChunks();
      if (chunks.length > 0) {
        const processChains = isKBChainsEnabled() ? findRelevantChains(relevantTables) : [];
        kbResults = searchKnowledgeBase(chunks, {
          tables: relevantTables,
          processChains,
          requirementsText: text,
        }, getKBMaxChunks());
        if (kbResults.length > 0) {
          console.log(`[generatePackage] 📚 Wissensdatenbank: ${kbResults.length} relevante Hilfe-Einträge gefunden`);
          for (const r of kbResults) {
            console.log(`  → ${r.chunk.heading} (Score: ${r.score.toFixed(1)}, Keywords: ${r.chunk.keywords?.join(', ') ?? '-'}, Matched: ${r.matchedTerms.join(', ')})`);
          }
        } else {
          console.log('[generatePackage] 📚 Wissensdatenbank: Keine passenden Einträge gefunden');
        }
      } else {
        console.log('[generatePackage] 📚 Wissensdatenbank: Aktiviert aber keine Chunks geladen');
      }
    } catch (err) {
      console.warn('[generatePackage] 📚 Wissensdatenbank-Suche fehlgeschlagen:', err);
    }
  }

  // Build table context preview (field lists per table) for diagnostics
  if (relevantTables.length > 0) {
    tableContext = relevantTables.map(t => formatSingleTableContext(t, text)).join('\n\n');
  }

  // Step 2+3: Build prompt and call AI
  let responseText = '';
  let promptDetails = '';

  if (agentId && relevantTables.length > 0 && opts.testDepth !== 'deep') {
    // ── Chunked agent mode: send tables individually, then generate ──
    // Each message stays small → avoids server-side 100s timeout.
    let convId: string | null = null;

    // Collect all context messages for display in gherkinRequest
    const contextParts: string[] = [];

    // Send each table as a context message
    for (let i = 0; i < relevantTables.length; i++) {
      const table = relevantTables[i];
      const tableContext = formatSingleTableContext(table, text);
      const contextMsg = `${buildChunkedContextMessage(tableDisplayName(table), i + 1, relevantTables.length)}

${tableContext}`;

      contextParts.push(`[KONTEXT ${i + 1}/${relevantTables.length}: ${tableDisplayName(table)}]\n${tableContext}`);

      const ctxDetails = `Kontext ${i + 1}/${relevantTables.length}: ${tableDisplayName(table)} | ${tableContext.length} Zeichen`;
      console.log('[generatePackage] chunked context:', ctxDetails);

      const ctxResult = await chatWithAgentSync(agentId, contextMsg, convId, 'agent-chat', model, ctxDetails);
      convId = ctxResult.conversationId;
    }

    // Send KB documentation context if available
    if (kbResults.length > 0) {
      const { formatKBContextForPrompt } = await import('./aiPrompt');
      const kbContext = formatKBContextForPrompt(kbResults);
      const kbMsg = `Hier ist Referenz-Dokumentation aus der abas ERP Onlinehilfe. Merke dir diese Informationen fuer die Testgenerierung. Antworte kurz mit "OK".\n${kbContext}`;
      contextParts.push(`[WISSENSDATENBANK: ${kbResults.length} Einträge]\n${kbContext}`);
      console.log(`[generatePackage] chunked KB context: ${kbContext.length} Zeichen, ${kbResults.length} Einträge`);
      const kbCtxResult = await chatWithAgentSync(agentId, kbMsg, convId, 'agent-chat', model, `KB-Kontext: ${kbResults.length} Einträge`);
      convId = kbCtxResult.conversationId;
    }

    // Send the final generation request in the same conversation
    let userMessage = `Erstelle Gherkin-Test-Szenarien aus folgendem Anforderungstext:\n\n${text}`;
    if (testUser) {
      userMessage += `\n\nHinweis: Der Testbenutzer "${testUser}" wird automatisch als Background eingefuegt — schreibe KEINEN Login-Schritt in die Szenarien.`;
    }
    if (featureGuid) {
      userMessage += `\n\nFeature-GUID: ${featureGuid}\nVerwende diese GUID als @-Tag und fuer die guid-Feld-Logik gemaess den Regeln im System-Prompt.`;
    }
    // Add "assume exists" block for tables flagged as pre-existing
    const { buildAssumeExistsBlock } = await import('./aiPrompt');
    const assumeBlock = buildAssumeExistsBlock(relevantTables);
    if (assumeBlock) userMessage += assumeBlock;

    userMessage += getFieldUsageRules(true);
    userMessage += getTestDepthInstruction(opts.testDepth ?? 'quick');
    const genPrefix = getGenPrefix();

    const totalChars = userMessage.length;
    promptDetails = `Schritt 2: Gherkin-Generierung (chunked) | Modus: Agent | Tabellen: ${relevantTables.length} (einzeln gesendet) | Final: ${totalChars} Zeichen (~${Math.ceil(totalChars / CHARS_PER_TOKEN).toLocaleString('de-DE')} Tokens)`;
    console.log('[generatePackage]', promptDetails);

    // Full prompt for display: all table contexts + final generation request
    gherkinRequest = contextParts.join('\n\n') + '\n\n[FINALE ANFRAGE]\n' + genPrefix + userMessage;
    onPromptBuilt?.(gherkinRequest);
    try {
      const result = await chatWithAgentSync(agentId, genPrefix + userMessage, convId, 'gherkin-generation', model, promptDetails, onDelta);
      responseText = result.response;
    } catch (err) {
      if (isMftTenantOrAuthError(err) && openRouterAvailable) {
        console.log(`[generatePackage] MFT-Fehler (${(err as Error).message?.slice(0, 60)}) → Fallback auf OpenRouter (chunked→direct)`);
        const fallbackMessages = buildMessagesWithFields(text, relevantTables, testUser, kbResults.length > 0 ? kbResults : undefined);
        responseText = await openRouterChatCompletion(fallbackMessages, 'gherkin-generation', promptDetails);
      } else {
        throw err;
      }
    }
  } else {
    // ── Single-message mode (no agent or no tables) ──
    let messages: { role: 'system' | 'user'; content: string }[];
    let promptMode: string;
    if (relevantTables.length > 0) {
      messages = buildMessagesWithFields(text, relevantTables, testUser, kbResults.length > 0 ? kbResults : undefined);
      promptMode = 'mit-Feldern';
    } else {
      messages = buildMessages(text, testUser, tables);
      promptMode = 'nur-Tabellennamen';
    }

    // Inject feature GUID into the user message
    if (featureGuid) {
      const userMsg = messages.find((m) => m.role === 'user');
      if (userMsg) {
        userMsg.content += `\n\nFeature-GUID: ${featureGuid}\nVerwende diese GUID als @-Tag und fuer die guid-Feld-Logik gemaess den Regeln im System-Prompt.`;
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
      const userMessage = messages.find((m) => m.role === 'user')?.content ?? text;
      const prefixed = 'Generiere Gherkin-Testszenarien fuer folgendes Arbeitspaket:\n\n' + userMessage;
      gherkinRequest = prefixed;
      console.log('[generatePackage] ▶ SENDE AN KI (Agent):', { len: prefixed.length, hatFelder: prefixed.includes('Felder:'), preview: prefixed.slice(0, 300) });
      onPromptBuilt?.(gherkinRequest!);
      try {
        const result = await chatWithAgentSync(agentId, prefixed, null, 'gherkin-generation', model, promptDetails, onDelta);
        responseText = result.response;
      } catch (err) {
        if (isMftTenantOrAuthError(err) && openRouterAvailable) {
          console.log(`[generatePackage] MFT-Fehler (${(err as Error).message?.slice(0, 60)}) → Fallback auf OpenRouter (Agent→Direct)`);
          responseText = await openRouterChatCompletion(messages, 'gherkin-generation', promptDetails);
        } else {
          throw err;
        }
      }
    } else {
      gherkinRequest = messages.map(m => `[${m.role.toUpperCase()}]\n${m.content}`).join('\n\n---\n\n');
      onPromptBuilt?.(gherkinRequest);

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

          let response: string;
          try {
            response = await chatCompletion(messages, model, 'gherkin-generation', `Deep R${round}/${maxRounds}`);
          } catch (err) {
            if (isMftTenantOrAuthError(err) && openRouterAvailable) {
              response = await openRouterChatCompletion(messages, 'gherkin-generation', `Deep R${round}`);
            } else { throw err; }
          }

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
                const newContext = newTables.map(t => formatSingleTableContext(t, text)).join('\n\n');
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
                        requirementsText: text,
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
                        requirementsText: text,
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
                const noMatch = `Fuer die Tabellen (${requestedNames.join(', ')}) sind keine Felddefinitionen verfuegbar. Verwende die gaengigen Standardfelder (such, guid, name, name2 fuer Stammdaten) und die im Anforderungstext genannten Felder.${kbFallback}\n\nGeneriere jetzt den Gherkin-Test oder frage nach weiteren Tabellen.`;
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
          try {
            responseText = await chatCompletion(messages, model, 'gherkin-generation', 'Deep FINAL');
          } catch (err) {
            if (isMftTenantOrAuthError(err) && openRouterAvailable) {
              responseText = await openRouterChatCompletion(messages, 'gherkin-generation', 'Deep FINAL');
            } else { throw err; }
          }
          opts.onRound?.(maxRounds + 1, maxRounds, forceMsg, responseText);
        }
      } else {
        // ── Single-shot quick test ──
        console.log('[generatePackage] ▶ SENDE AN KI (Direct, quick)');
        try {
          responseText = await chatCompletion(messages, model, 'gherkin-generation', promptDetails);
        } catch (err) {
          if (isMftTenantOrAuthError(err) && openRouterAvailable) {
            console.log(`[generatePackage] MFT-Fehler (${(err as Error).message?.slice(0, 60)}) → Fallback auf OpenRouter (Gherkin)`);
            responseText = await openRouterChatCompletion(messages, 'gherkin-generation', promptDetails);
          } else {
            throw err;
          }
        }
      }
    }
  }

  // Step 4: Parse response
  console.log('[generatePackage] KI-Rohantwort:', responseText);
  const gherkin = extractGherkin(responseText);
  console.log('[generatePackage] Extrahiertes Gherkin:', gherkin);
  let parsed = parseGherkin(gherkin, { fromAI: true });
  console.log('[generatePackage] Geparst:', parsed.scenarios.length, 'Szenarien', parsed.scenarios.map((s) => s.name));

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
