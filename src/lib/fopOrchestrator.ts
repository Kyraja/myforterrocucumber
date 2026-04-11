import type { FopFile, FopTreeNode, FopAnalysis, GuidelineFinding, FieldInteraction, HumanDescription, TechnicalDescription, FopBinding, FopUsage } from '../types/fop';
import type { TableDef, FeatureInput } from '../types/gherkin';
import { trackBuffers } from './fopBufferTracker';
import { resolveAllFields } from './fopFieldResolver';
import { checkGuidelinesLocal } from './fopGuidelines';
import { buildFopAnalystPrompt, buildFopGuidelinesPrompt, buildLanguageInstruction } from './fopAgentPrompt';
import { traverseBottomUpLevels } from './fopTreeResolver';
import { FopCache } from './fopCache';

export type AnalysisProgressCallback = (info: {
  current: number;
  total: number;
  currentFop: string;
  phase: 'parsing' | 'buffers' | 'fields' | 'local-check' | 'analyzing' | 'guidelines' | 'cucumber';
  /** The prompt/context sent to the AI */
  input?: string;
  /** The AI response */
  output?: string;
}) => void;

export interface OrchestratorOptions {
  fopFiles: FopFile[];
  roots: FopTreeNode[];
  varTables: TableDef[];
  /** Usage index — provides binding info (which mask/event) for each FOP */
  usageIndex?: Map<string, FopUsage>;
  lang: 'de' | 'en';
  model: string;
  cache: FopCache;
  forceRefresh?: boolean;
  analystAgentId?: string;
  guidelinesAgentId?: string;
  onProgress?: AnalysisProgressCallback;
  onAbort?: () => boolean;
}

// Known mask → DB:Group mapping (from FOP reference)
export const MASK_TO_DB: Record<number, string> = {
  0: '0:1',   // Kunde
  1: '1:1',   // Lieferant
  2: '2:1',   // Artikel
  3: '3:1',   // Auftragskopf (allg.)
  5: '2:5',   // Verkaufspreise
  6: '6:1',   // Konten
  7: '7:1',   // Fertigungsvorschlag
  8: '8:1',   // Abteilung
  9: '9:18',  // Arbeitsschein
  10: '10:1', // Arbeitsplan
  12: '12:1', // Einkaufspreise
  14: '14:1', // Lagerplatz
  20: '20:1', // Aufzählung
  31: '3:22', // Einkaufsauftrag
  32: '3:23', // Verkaufsauftrag
  33: '3:25', // Einkaufslieferschein
  34: '3:24', // Einkaufsrechnung
  35: '3:25', // Verkaufslieferschein
  36: '3:24', // Verkaufsrechnung
  37: '3:27', // Einkaufsgutschrift
  38: '38:1', // Lagerplatz (Versand)
  42: '3:42', // Fertigungsauftrag
  45: '3:45', // Rahmenauftrag
  46: '3:46', // Blankett
  50: '50:1', // Stückliste
};

/** Resolve a mask number to a human-readable name via varTables.
 *  Format: "Verkaufsauftrag (32 - 3:23)" or just "812" if unknown */
export function resolveMaskName(maskNr: number | '*', varTables: TableDef[], lang: 'de' | 'en'): string {
  if (maskNr === '*') return lang === 'de' ? 'Alle Masken' : 'All Masks';
  // 1. Try to find by maskNr from CSV export (most reliable)
  const byMaskNr = varTables.find(t => t.maskNr === maskNr);
  if (byMaskNr) {
    const name = lang === 'de' ? (byMaskNr.nameDe ?? byMaskNr.name) : (byMaskNr.nameEn ?? byMaskNr.name);
    return `${name} (${maskNr} - ${byMaskNr.tableRef})`;
  }
  // 2. Fallback: hardcoded MASK_TO_DB map
  const dbRef = MASK_TO_DB[maskNr as number];
  if (dbRef) {
    const table = varTables.find(t => t.tableRef === dbRef);
    if (table) {
      const name = lang === 'de' ? (table.nameDe ?? table.name) : (table.nameEn ?? table.name);
      return `${name} (${maskNr} - ${dbRef})`;
    }
    return `${dbRef} (${maskNr})`;
  }
  return String(maskNr);
}

export interface OrchestratorResult {
  analyses: Map<string, FopAnalysis>;
  errors: Map<string, string>;
  totalAnalyzed: number;
  fromCache: number;
}

export async function runFopAnalysis(opts: OrchestratorOptions): Promise<OrchestratorResult> {
  console.log('[runFopAnalysis] start:', {
    rootCount: opts.roots.length,
    rootPaths: opts.roots.map(r => r.fopFile.relativePath),
    varTablesCount: opts.varTables.length,
    model: opts.model,
    analystAgentId: opts.analystAgentId,
    guidelinesAgentId: opts.guidelinesAgentId,
    forceRefresh: opts.forceRefresh,
  });
  const { roots, varTables, lang, model, cache, forceRefresh = false } = opts;
  const analysisCache = new Map<string, FopAnalysis>();
  const errors = new Map<string, string>();
  let totalAnalyzed = 0;
  let fromCache = 0;

  // Collect all unique FOPs to analyze (bottom-up order)
  const levels = traverseBottomUpLevels(roots);
  const allNodes: FopTreeNode[] = levels.flat();
  const total = allNodes.length;

  let current = 0;

  for (const level of levels) {
    // Check for abort
    if (opts.onAbort?.()) break;

    // Analyze all nodes at this level in parallel
    const levelPromises = level.map(async (node) => {
      if (opts.onAbort?.()) return;

      const fopPath = node.fopFile.relativePath;
      current++;

      opts.onProgress?.({ current, total, currentFop: fopPath, phase: 'parsing' });

      try {
        // Check cache first
        const hash = node.fopFile.fileHash;
        if (!forceRefresh && await cache.isCached(fopPath, hash, lang)) {
          const cached = await cache.readCache(fopPath, lang);
          if (cached) {
            console.log(`[runFopAnalysis] ${fopPath}: from cache`);
            analysisCache.set(fopPath, cached);
            fromCache++;
            // Still report steps so the diagram shows data
            opts.onProgress?.({ current, total, currentFop: fopPath, phase: 'buffers',
              input: `${node.fopFile.bufferOperations.length} Buffer-Operationen (Cache)`,
              output: node.fopFile.bufferOperations.map(b => `${b.buffer}| ← ${b.sourceExpression} → DB ${b.resolvedDatabase ?? '?'}`).join('\n') || '(keine)',
            });
            const cachedResolved = cached.fieldResolutions?.filter((f: { confidence: string }) => f.confidence !== 'unknown').length ?? 0;
            opts.onProgress?.({ current, total, currentFop: fopPath, phase: 'fields',
              input: `${cached.fieldResolutions?.length ?? 0} Felder (Cache)`,
              output: `${cachedResolved} aufgelöst\n` + (cached.fieldResolutions?.slice(0, 15).map((f: { buffer: string; fieldName: string; resolvedName: string; confidence: string }) => `${f.buffer}|${f.fieldName} → ${f.resolvedName} [${f.confidence}]`).join('\n') ?? ''),
            });
            opts.onProgress?.({ current, total, currentFop: fopPath, phase: 'local-check',
              input: `${cached.guidelines?.findings?.length ?? 0} Findings (Cache)`,
              output: cached.guidelines?.findings?.map((f: { severity: string; rule?: string; message: string }) => `[${f.severity}] ${f.rule ?? ''}: ${f.message}`).join('\n') || '(keine)',
            });
            opts.onProgress?.({ current, total, currentFop: fopPath, phase: 'analyzing',
              input: cached.technicalDescription?.summary ?? '(Cache)',
              output: JSON.stringify({ technicalDescription: cached.technicalDescription, humanDescription: cached.humanDescription }, null, 2),
            });
            if (cached.guidelines) {
              opts.onProgress?.({ current, total, currentFop: fopPath, phase: 'guidelines',
                input: `Score: ${cached.guidelines.score}`,
                output: cached.guidelines.findings?.map((f: { severity: string; message: string }) => `[${f.severity}] ${f.message}`).join('\n') || '(keine Findings)',
              });
            }
            return;
          }
        }
        console.log(`[runFopAnalysis] ${fopPath}: analyzing (analystAgentId=${opts.analystAgentId})`);

        // Run local analysis
        const tracker = trackBuffers(node.fopFile);
        const bufferSummary = node.fopFile.bufferOperations.map(b => `${b.buffer}| ← ${b.sourceExpression} → DB ${b.resolvedDatabase ?? '?'}`).join('\n');
        opts.onProgress?.({ current, total, currentFop: fopPath, phase: 'buffers',
          input: `${node.fopFile.bufferOperations.length} Buffer-Operationen`,
          output: bufferSummary || '(keine Buffer-Operationen)',
        });

        const fieldResolutions = resolveAllFields(node.fopFile, varTables, tracker);
        const resolvedCount = fieldResolutions.filter(f => f.confidence !== 'unknown').length;
        opts.onProgress?.({ current, total, currentFop: fopPath, phase: 'fields',
          input: `${fieldResolutions.length} Felder analysiert`,
          output: `${resolvedCount} aufgelöst, ${fieldResolutions.length - resolvedCount} unbekannt\n` +
            fieldResolutions.slice(0, 20).map(f => `${f.buffer}|${f.fieldName} → ${f.resolvedName} [${f.confidence}]`).join('\n'),
        });

        const localGuidelines = checkGuidelinesLocal(node.fopFile);
        opts.onProgress?.({ current, total, currentFop: fopPath, phase: 'local-check',
          input: `${node.fopFile.rawLines.length} Zeilen geprüft`,
          output: localGuidelines.findings.length > 0
            ? localGuidelines.findings.map(f => `[${f.severity}] ${f.rule}: ${f.message}`).join('\n')
            : '(keine Findings)',
        });

        // Collect ALL bindings for this FOP (from entry point + usage index)
        const fopBindings: FopBinding[] = [];
        if (node.entryPoint) fopBindings.push(node.entryPoint);
        const usage = opts.usageIndex?.get(fopPath);
        if (usage) {
          for (const chain of usage.usageChains) {
            if (!fopBindings.some(b => b.event === chain.binding.event && b.mask === chain.binding.mask && b.field === chain.binding.field && b.scope === chain.binding.scope)) {
              fopBindings.push(chain.binding);
            }
          }
        }

        // Build sub-program descriptions from already-analyzed children
        const subDescriptions = node.children
          .map(child => {
            const analysis = analysisCache.get(child.fopFile.relativePath);
            if (!analysis) return null;
            return `- ${child.fopFile.relativePath}: "${analysis.humanDescription.summary}"`;
          })
          .filter(Boolean)
          .join('\n');

        // Build context for KI — including binding info
        const context = buildAnalystContext(node.fopFile, fieldResolutions, subDescriptions, fopBindings, varTables, lang);

        // Call KI analyst (stateless chatCompletion)
        let technicalDescription = fallbackTechnicalDescription(node.fopFile, lang);
        let humanDescription = fallbackHumanDescription(node.fopFile, lang);
        let fieldInteractions: import('../types/fop').FieldInteraction[] = [];

        if (opts.analystAgentId !== undefined) {
          opts.onProgress?.({ current, total, currentFop: fopPath, phase: 'analyzing', input: context });
          try {
            const { chatCompletion } = await import('./myforterroApi');
            const systemPrompt = buildFopAnalystPrompt(lang) + buildLanguageInstruction(lang);
            const messages = [
              { role: 'system' as const, content: systemPrompt },
              { role: 'user' as const, content: context },
            ];
            const response = await chatCompletion(messages, model);
            opts.onProgress?.({ current, total, currentFop: fopPath, phase: 'analyzing', input: context, output: response });
            const parsed = extractJson(response);
            if (parsed) {
              technicalDescription = (parsed.technicalDescription as import('../types/fop').TechnicalDescription) ?? technicalDescription;
              humanDescription = (parsed.humanDescription as import('../types/fop').HumanDescription) ?? humanDescription;
              fieldInteractions = (parsed.fieldInteractions as import('../types/fop').FieldInteraction[]) ?? [];
            }
          } catch (e) {
            errors.set(`${fopPath}_analyst`, String(e));
          }
        }

        // AI guidelines check (optional)
        let aiFindings: GuidelineFinding[] = [];
        if (opts.guidelinesAgentId !== undefined) {
          const guidelinesInput = node.fopFile.rawLines.join('\n');
          opts.onProgress?.({ current, total, currentFop: fopPath, phase: 'guidelines', input: guidelinesInput });
          try {
            const { chatCompletion } = await import('./myforterroApi');
            const systemPrompt = buildFopGuidelinesPrompt(lang);
            const messages = [
              { role: 'system' as const, content: systemPrompt },
              { role: 'user' as const, content: guidelinesInput },
            ];
            const response = await chatCompletion(messages, model);
            opts.onProgress?.({ current, total, currentFop: fopPath, phase: 'guidelines', input: guidelinesInput, output: response });
            const parsed = extractJson(response);
            if (parsed?.aiFindings) {
              aiFindings = (parsed.aiFindings as GuidelineFinding[]).map((f) => ({ ...f, source: 'ai' as const }));
            }
          } catch {
            // Ignore AI guidelines failure
          }
        }

        const allFindings = [...localGuidelines.findings, ...aiFindings];
        const score = computeScore(allFindings);

        // Cucumber tests are generated separately via "Tests generieren" button
        const cucumberTests: FeatureInput[] | undefined = undefined;

        const analysis: FopAnalysis = {
          fopPath,
          fileHash: hash,
          language: lang,
          analyzedAt: new Date().toISOString(),
          parsedStructure: node.fopFile,
          fieldResolutions,
          technicalDescription,
          humanDescription,
          fieldInteractions,
          guidelines: { score, findings: allFindings },
          cucumberTests,
        };

        analysisCache.set(fopPath, analysis);
        await cache.writeCache(analysis, model);
        totalAnalyzed++;

      } catch (e) {
        errors.set(fopPath, String(e));
      }
    });

    await Promise.all(levelPromises);
  }

  return { analyses: analysisCache, errors, totalAnalyzed, fromCache };
}

function buildAnalystContext(
  fop: FopFile,
  fieldResolutions: import('../types/fop').FieldResolution[],
  subDescriptions: string,
  bindings: FopBinding[],
  varTables: TableDef[],
  lang: 'de' | 'en',
): string {
  const de = lang === 'de';

  // ── Binding context — WHERE is this FOP used?
  const bindingLines = bindings.map(b => {
    const maskName = resolveMaskName(b.mask, varTables, lang);
    const fieldPart = b.field !== '*' && b.field !== '-' ? ` | ${de ? 'Feld' : 'Field'}: ${b.field}` : '';
    const scopePart = b.scope !== '*' ? ` | ${b.scope === 'K' ? (de ? 'Kopf' : 'Header') : (de ? 'Tabelle' : 'Table')}` : '';
    const cmdPart = b.command !== '*' ? ` | ${de ? 'Kommando' : 'Command'}: ${b.command}` : '';
    return `  ${b.eventShort} (${b.event}) @ ${maskName}${fieldPart}${scopePart}${cmdPart}`;
  }).join('\n');

  // ── Variables: all with type + DB reference
  const vars = fop.variables
    .map(v => {
      const db = v.referencedDatabase ? ` → DB ${v.referencedDatabase}` : '';
      const convention = v.followsNamingConvention ? '' : ' ⚠ naming';
      return `  ${v.name} (${v.declaredType})${db}${convention}`;
    })
    .join('\n');

  // ── Event routing
  const events = fop.eventHandlers
    .map(e => `  ${e.event}${e.field ? `:${e.field}` : ''} → ${e.labelOrFunction} (Z.${e.line})`)
    .join('\n');

  // ── Field accesses: split reads vs writes, with resolution
  const writeAccesses = fop.maskReferences
    .filter(r => r.accessType === 'write' || r.accessType === 'attribute')
    .map(r => {
      const resolved = fieldResolutions.find(f => f.fieldName === r.field && f.buffer === r.buffer);
      const name = resolved ? ` = "${resolved.resolvedName}"` : '';
      const attr = r.attribute ? `^${r.attribute}` : '';
      return `  Z.${r.line}: ${r.buffer}|${r.field}${attr}${name} [${r.accessType}]`;
    })
    .join('\n');

  const readAccesses = fop.maskReferences
    .filter(r => r.accessType === 'read')
    .slice(0, 40) // reads can be many — limit
    .map(r => {
      const resolved = fieldResolutions.find(f => f.fieldName === r.field && f.buffer === r.buffer);
      const name = resolved ? ` = "${resolved.resolvedName}"` : '';
      return `  Z.${r.line}: ${r.buffer}|${r.field}${name}`;
    })
    .join('\n');

  // ── Subprogram calls
  const subCalls = fop.subprogramCalls
    .map(c => {
      const dyn = c.isDynamic ? ' [dynamisch]' : '';
      const cond = c.condition ? ` wenn: ${c.condition}` : '';
      return `  Z.${c.line}: ${c.callType} "${c.target}"${dyn}${cond}`;
    })
    .join('\n');

  // ── EDP calls
  const edpCalls = fop.edpCalls
    .map(e => `  Z.${e.line}: ${e.type.toUpperCase()} DB=${e.database ?? '?'} Aktion=${e.action ?? '?'}`)
    .join('\n');

  // ── Error statements
  const errors = fop.errorStatements
    .map(e => {
      if (e.type === 'end-1') return `  Z.${e.line}: .end 1 → ${de ? 'Systembehandlung verhindern' : 'prevent system action'}`;
      const field = e.field ? ` an Feld "${e.field}"` : '';
      const msg = e.message ? `: "${e.message}"` : '';
      return `  Z.${e.line}: .error${field}${msg}`;
    })
    .join('\n');

  // ── Buffer operations — include raw selection strings for DB identification
  const bufOps = fop.bufferOperations
    .map(b => {
      const db = b.resolvedDatabase
        ? b.resolvedDatabase < 0
          ? ` → Gruppe ${Math.abs(b.resolvedDatabase)} (DB unbekannt — bitte identifizieren!)`
          : ` → DB ${b.resolvedDatabase}`
        : ` → (${de ? 'Datenbank unbekannt' : 'database unknown'} — ${de ? 'bitte aus Kontext identifizieren' : 'please identify from context'})`;
      return `  Z.${b.line}: ${b.operation.toUpperCase()} ${b.buffer}| ← "${b.sourceExpression}"${db} [${b.confidence}]`;
    })
    .join('\n');

  // ── Already-analyzed subprograms (bottom-up)
  const subSection = subDescriptions
    ? `\n${de ? 'BEREITS ANALYSIERTE SUBPROGRAMME' : 'ALREADY ANALYZED SUBPROGRAMS'}:\n${subDescriptions}\n`
    : '';

  return `=== ${de ? 'ANALYSE' : 'ANALYSIS'}: ${fop.relativePath} ===
${de ? 'Programm' : 'Program'}: ${fop.filename} | ${fop.isFo2 ? 'FO2' : 'FO1'} | ${fop.interpreterMode}

${de ? 'ANBINDUNG (FOP.txt — wo wird dieses Programm ausgelöst?)' : 'BINDING (FOP.txt — where is this program triggered?)'}:
${bindingLines || `  (${de ? 'kein Einstiegspunkt bekannt — Unterprogramm' : 'no entry point — subroutine'})`}

${de ? 'EVENT-ROUTING' : 'EVENT ROUTING'}:
${events || '  (none)'}

${de ? 'SCHREIBZUGRIFFE AUF MASKENFELDER' : 'WRITE ACCESSES TO MASK FIELDS'}:
${writeAccesses || `  (${de ? 'keine' : 'none'})`}

${de ? 'LESE-ZUGRIFFE (Auswahl)' : 'READ ACCESSES (selection)'}:
${readAccesses || `  (${de ? 'keine' : 'none'})`}

${de ? 'PUFFER-OPERATIONEN' : 'BUFFER OPERATIONS'}:
${bufOps || `  (${de ? 'keine' : 'none'})`}

${de ? 'SUBPROGRAMM-AUFRUFE' : 'SUBPROGRAM CALLS'}:
${subCalls || `  (${de ? 'keine' : 'none'})`}

${de ? 'FEHLERBEHANDLUNG / ABBRÜCHE' : 'ERROR HANDLING / ABORTS'}:
${errors || `  (${de ? 'keine' : 'none'})`}

${edpCalls ? `${de ? 'EDP-AUFRUFE' : 'EDP CALLS'}:\n${edpCalls}\n` : ''}
${de ? 'VARIABLEN' : 'VARIABLES'}:
${vars || `  (${de ? 'keine' : 'none'})`}
${subSection}
=== ${de ? 'QUELLCODE' : 'SOURCE CODE'} (${fop.rawLines.length} ${de ? 'Zeilen' : 'lines'}) ===
${fop.rawLines.join('\n')}`;
}

/**
 * Generates Cucumber tests from a FOP analysis using the SAME pipeline as Konzept-Import.
 *
 * Flow:
 * 1. Build a synthetic "Anforderungstext" from the AI analysis results
 * 2. Find the relevant TableDefs from varTables (by database numbers from field resolutions)
 * 3. Call buildMessagesWithFields() — same function used in the forward path
 * 4. Parse the KI response as FeatureInput
 */
async function generateCucumberFromAnalysis(
  testDepth: 'quick' | 'deep',
  callbacks: {
    onTablesIdentified?: (info: { path: 'local' | 'ki'; tables: string[]; fieldCount: number; tableIdRequest?: string; tableIdRawResponse?: string }) => void;
    onTableIdStarted?: (request: string) => void;
    onPromptBuilt?: (gherkinRequest: string) => void;
    onDelta?: (text: string) => void;
  } | undefined,
  isBindingsForFop: import('../lib/fopTxtParser').IsBinding[],
  fop: FopFile,
  human: HumanDescription,
  technical: TechnicalDescription,
  fieldInteractions: FieldInteraction[],
  bindings: FopBinding[],
  varTables: TableDef[],
  model: string,
  lang: 'de' | 'en',
): Promise<FeatureInput[]> {
  const de = lang === 'de';
  const { makeFopGuid } = await import('./featureGuid');
  const fopGuid = makeFopGuid(fop.relativePath);

  // ── Mask/binding context ───────────────────────────────────────
  // Event short code → full name (DE/EN)
  const eventFullName = (short: string): string => {
    const map: Record<string, [string, string]> = {
      SE: ['Maskeneintritt', 'Screen Entry'], SV: ['Maskenprüfung', 'Screen Validation'],
      SX: ['Maskenausstieg', 'Screen Exit'], SC: ['Maskenwechsel', 'Screen Change'],
      FV: ['Feldprüfung', 'Field Validation'], FX: ['Feldausstieg', 'Field Exit'],
      FF: ['Feldfüllung', 'Field Fill'], BA: ['Button-Nach', 'Button After'],
      BB: ['Button-Vor', 'Button Before'], RIB: ['Zeile-Vor-Einfügen', 'Row Insert Before'],
      RIA: ['Zeile-Nach-Einfügen', 'Row Insert After'], RDB: ['Zeile-Vor-Löschen', 'Row Delete Before'],
      RDA: ['Zeile-Nach-Löschen', 'Row Delete After'],
    };
    const upper = short.split(':')[0].toUpperCase();
    const names = map[upper];
    if (!names) return short;
    return de ? `${names[0]} (${upper})` : `${names[1]} (${upper})`;
  };

  // Mask bindings
  const maskBindingLines = bindings.map(b => {
    const maskName = resolveMaskName(b.mask, varTables, lang);
    const fieldPart = b.field !== '*' && b.field !== '-' ? `, ${de ? 'Feld' : 'field'} "${b.field}"` : '';
    const scopePart = b.scope !== '*' ? ` (${b.scope === 'K' ? (de ? 'Kopfteil' : 'header') : (de ? 'Tabellenteil' : 'table')})` : '';
    const cmdPart = b.command !== '*' ? `, ${de ? 'Kommando' : 'command'} ${b.command}` : '';
    return `${de ? 'Maske' : 'Mask'}: ${maskName}${fieldPart}${scopePart}${cmdPart} — Event: ${eventFullName(b.eventShort)}`;
  });
  // IS bindings
  const isBindingLines = isBindingsForFop.map(b => {
    const fieldPart = b.field ? `, ${de ? 'Feld' : 'field'} "${b.field}"` : '';
    const scopePart = b.scope !== '*' ? ` (${b.scope === 'K' ? (de ? 'Kopf' : 'Header') : (de ? 'Tabelle' : 'Table')})` : '';
    return `${de ? 'Infosystem' : 'Infosystem'}: ${b.isName} (${b.isSearchWord})${fieldPart}${scopePart} — Event: ${eventFullName(b.event)}`;
  });
  const bindingContext = [...maskBindingLines, ...isBindingLines].join('\n');

  // ── Build synthetic Anforderungstext ──────────────────────────
  const eventLines = Object.entries(technical.eventDescriptions ?? {})
    .map(([evt, desc]) => `- ${eventFullName(evt)}: ${desc}`)
    .join('\n');

  const fieldLines = fieldInteractions
    .map(f => {
      const scope = f.maskNr ? ` in ${resolveMaskName(f.maskNr, varTables, lang)}` : '';
      return `- ${de ? 'Feld' : 'Field'} "${f.resolvedName}" (${f.field})${scope}: ${f.purposeHuman}`;
    })
    .join('\n');

  const sideEffects = (technical.sideEffects ?? []).join('; ');

  const anforderungstext = de
    ? `# FOP-Programm: ${fop.filename}

## Anbindung
Dieses Programm wird in folgenden Masken/Infosystemen ausgeloest:
${bindingContext || 'Unterprogramm (kein direkter Einstiegspunkt)'}

## Fachliche Beschreibung
${human.summary}

## Technische Beschreibung
${technical.summary || ''}

## Datenfluss
${technical.dataFlow || ''}

## Events und Aktionen
${eventLines || '(keine Events dokumentiert)'}

## Verwendete Felder
${fieldLines || '(keine Felder dokumentiert)'}

## Anwendungsfaelle
${human.useCases.map(u => `- ${u}`).join('\n') || ''}
${sideEffects ? `\n## Seiteneffekte\n${sideEffects}` : ''}

--- HINWEIS NUR FUER DIE TESTGENERIERUNG (NICHT in Feature-Beschreibung uebernehmen!) ---
Ziel: Oeffne die oben genannte Maske oder das Infosystem und loese das Event aus (Feld setzen, Button druecken, Maskeneintritt). Pruefe dann ob die erwarteten Feldaenderungen eingetreten sind.
Bei Infosystemen: Verwende "Given I open the infosystem" mit dem Suchwort. Setze Filterfelder, druecke Start, pruefe Ergebnisse.
Bei Masken: Oeffne den Editor der jeweiligen Datenbank, setze das ausloesende Feld und pruefe die Ergebnisse.
WICHTIG: Buffer-Referenzen wie M|feldname, T|variable, H|variable, D|variable, 0|variable usw. sind INTERNE Programm-Referenzen und KEINE Werte die in Testfelder eingetragen werden! Verwende stattdessen sinnvolle Testwerte (z.B. "EUR" statt "T|inland", "PCE" statt "M|kartle"). Buffer-Notation NIEMALS in Gherkin-Steps verwenden!
${testDepth === 'deep'
? `TESTTIEFE: TIEFENTEST — Erstelle die KOMPLETTE Vorkette aller benoetigten Testdaten!
Wenn der Test einen Arbeitsschein benoetigt: Erst Artikel (STORE), Stueckliste, Arbeitsplan anlegen, dann Fertigungsvorschlag erstellen und freigeben.
Wenn der Test einen Lieferschein benoetigt: Erst Kunde + Artikel anlegen, dann Auftrag (NEW), dann Lieferschein (DELIVERY).
JEDER referenzierte Datensatz MUSS in einem vorherigen Szenario angelegt werden. Keine Annahmen ueber existierende Daten!
Reihenfolge: 1. Stammdaten (Artikel, Kunde, etc.) 2. Belege (Auftrag, Fertigungsvorschlag) 3. Folgeprozesse (Freigabe, Lieferschein) 4. Eigentlicher Test`
: `TESTTIEFE: SCHNELLTEST — Beschraenke dich auf direkt testbare Funktionen:
- Infosystem oeffnen und Feldpruefung (is modifiable, is not modifiable)
- Maskeneintritt und pruefen ob Felder korrekt initialisiert werden
- Feldvalidierung: Wert setzen und Ergebnis pruefen
KEINE komplexe Vorkette anlegen. Wenn Testdaten benoetigt werden die nicht einfach angelegt werden koennen (z.B. Arbeitsscheine, Fertigungsauftraege), beschraenke den Test auf Feldpruefungen.`
}`
    : `# FOP Program: ${fop.filename}

## Binding
This program is triggered in the following masks/infosystems:
${bindingContext || 'Subroutine (no direct entry point)'}

## Business Description
${human.summary}

## Technical Description
${technical.summary || ''}

## Data Flow
${technical.dataFlow || ''}

## Events and Actions
${eventLines || '(no events documented)'}

## Fields Used
${fieldLines || '(no fields documented)'}

## Use Cases
${human.useCases.map(u => `- ${u}`).join('\n') || ''}
${sideEffects ? `\n## Side Effects\n${sideEffects}` : ''}

--- NOTE FOR TEST GENERATION ONLY (do NOT include in Feature description!) ---
Goal: Open the mask or infosystem listed above and trigger the event (set field, press button, mask entry). Then verify the expected field changes occurred.
For infosystems: Use "Given I open the infosystem" with the search word. Set filter fields, press start, check results.
For masks: Open the editor of the respective database, set the triggering field and check results.
IMPORTANT: Buffer references like M|fieldname, T|variable, H|variable, D|variable, 0|variable etc. are INTERNAL program references and NOT values to be used in test fields! Use meaningful test values instead (e.g. "EUR" instead of "T|inland", "PCE" instead of "M|kartle"). NEVER use buffer notation in Gherkin steps!
${testDepth === 'deep'
? `TEST DEPTH: DEEP TEST — Create the COMPLETE prerequisite chain of all required test data!
If the test needs a work slip: First create article (STORE), BOM, routing, then create production proposal and release it.
If the test needs a delivery note: First create customer + article, then sales order (NEW), then delivery note (DELIVERY).
EVERY referenced record MUST be created in a prior scenario. No assumptions about existing data!
Order: 1. Master data (article, customer, etc.) 2. Documents (order, production proposal) 3. Follow-up processes (release, delivery) 4. Actual test`
: `TEST DEPTH: QUICK TEST — Limit to directly testable functions:
- Open infosystem and check fields (is modifiable, is not modifiable)
- Mask entry and verify fields are correctly initialized
- Field validation: set value and check result
Do NOT create complex prerequisite chains. If test data is needed that cannot be easily created (e.g. work slips, production orders), limit the test to field checks.`
}`;

  if (testDepth === 'deep') {
    // ── Multi-round deep test: agent conversation with table back-and-forth ──
    return await generateDeepTest(anforderungstext, fopGuid, fop, varTables, model, lang, callbacks);
  }

  // ── Quick test: single-shot via generatePackage ──
  const { generatePackage } = await import('./generatePackage');

  const result = await generatePackage({
    text: anforderungstext,
    model,
    tables: varTables,
    featureName: fop.filename,
    onTablesIdentified: callbacks?.onTablesIdentified,
    onTableIdStarted: callbacks?.onTableIdStarted,
    onPromptBuilt: callbacks?.onPromptBuilt,
    onDelta: callbacks?.onDelta,
  });

  if (!result.feature || result.feature.scenarios.length === 0) return [];

  if (!result.feature.tags.some(t => t === `@${fopGuid}`)) {
    result.feature.tags = [`@${fopGuid}`, ...result.feature.tags];
  }
  result.feature.name = result.feature.name || fop.filename.replace(/\.[^.]+$/, '');

  return [result.feature];
}

/**
 * Multi-round deep test generation.
 * The AI can request additional tables — the frontend resolves them and sends them back.
 * Max rounds configurable to limit token usage.
 */
async function generateDeepTest(
  anforderungstext: string,
  fopGuid: string,
  fop: FopFile,
  varTables: TableDef[],
  model: string,
  lang: 'de' | 'en',
  callbacks?: {
    onTablesIdentified?: (info: { path: 'local' | 'ki'; tables: string[]; fieldCount: number; tableIdRequest?: string; tableIdRawResponse?: string }) => void;
    onTableIdStarted?: (request: string) => void;
    onPromptBuilt?: (gherkinRequest: string) => void;
    onDelta?: (text: string) => void;
    /** Called for each round of the conversation (for Agent Monitor display) */
    onRound?: (round: number, maxRounds: number, sent: string, received: string) => void;
    /** Max conversation rounds before forcing final output (default: 5) */
    maxRounds?: number;
  },
): Promise<FeatureInput[]> {
  const { chatCompletion } = await import('./myforterroApi');
  const { DEFAULT_SYSTEM_PROMPT, lookupRelevantTables, formatSingleTableContext, parseTableIdentificationResponse, tableDisplayName } = await import('./aiPrompt');
  const { parseGherkin } = await import('./gherkinParser');

  const de = lang === 'de';
  const maxRounds = callbacks?.maxRounds ?? 5;
  const systemPrompt = DEFAULT_SYSTEM_PROMPT;

  // Track which tables have been sent to avoid duplicates
  const sentTableRefs = new Set<string>();

  // Build initial prompt with deep-test instructions
  const deepInstruction = de
    ? `\n\nWICHTIG — INTERAKTIVER MODUS:
Du kannst in mehreren Runden arbeiten. Wenn du zusaetzliche Datenbanken/Infosysteme benoetigst um die komplette Vorkette aufzubauen:
Antworte NUR mit JSON: {"needTables": ["Datenbankname1", "Datenbankname2"], "reason": "Warum brauchst du diese Tabellen?"}
Sobald du alle benoetigten Felder hast, generiere den kompletten Gherkin-Test (beginnend mit "Feature:").
Feature-GUID: ${fopGuid}`
    : `\n\nIMPORTANT — INTERACTIVE MODE:
You can work in multiple rounds. If you need additional databases/infosystems to build the complete prerequisite chain:
Reply ONLY with JSON: {"needTables": ["DatabaseName1", "DatabaseName2"], "reason": "Why do you need these tables?"}
Once you have all required fields, generate the complete Gherkin test (starting with "Feature:").
Feature-GUID: ${fopGuid}`;

  // First round: send the anforderungstext + any already-known tables
  // Do initial table identification
  const { buildTableIdentificationMessages } = await import('./aiPrompt');
  let initialTables: TableDef[] = [];
  try {
    callbacks?.onTableIdStarted?.(anforderungstext);
    const step1Messages = buildTableIdentificationMessages(anforderungstext);
    const step1Response = await chatCompletion(step1Messages, model);
    const identified = parseTableIdentificationResponse(step1Response);
    initialTables = lookupRelevantTables(identified, varTables.filter(t => t.fields.length > 0));
    const tableNames = initialTables.map(t => `${tableDisplayName(t)} (${t.tableRef})`);
    const fieldCount = initialTables.reduce((s, t) => s + t.fields.length, 0);
    callbacks?.onTablesIdentified?.({
      path: 'ki', tables: tableNames, fieldCount,
      tableIdRequest: anforderungstext, tableIdRawResponse: step1Response,
    });
    for (const t of initialTables) sentTableRefs.add(t.tableRef);
  } catch { /* continue without initial tables */ }

  // Build the first user message with table context
  const tableContext = initialTables.map(t => formatSingleTableContext(t, anforderungstext)).join('\n\n');
  const firstMessage = tableContext
    ? `${anforderungstext}\n\n${de ? 'Verfuegbare Felder' : 'Available Fields'}:\n${tableContext}${deepInstruction}`
    : `${anforderungstext}${deepInstruction}`;

  callbacks?.onPromptBuilt?.(firstMessage);

  // Conversation loop
  const messages: { role: 'system' | 'user'; content: string }[] = [
    { role: 'system', content: systemPrompt },
    { role: 'user', content: firstMessage },
  ];

  console.log(`[DeepTest] Starting conversation loop. maxRounds=${maxRounds}, messages=${messages.length}, initialTables=${initialTables.length}`);

  for (let round = 1; round <= maxRounds; round++) {
    const lastUserMsg = messages[messages.length - 1].content;
    console.log(`[DeepTest] Round ${round}/${maxRounds} | sending ${messages.length} messages | last user msg: ${lastUserMsg.slice(0, 150)}...`);

    const response = await chatCompletion(messages, model);
    console.log(`[DeepTest] Round ${round} response (${response.length} chars): ${response.slice(0, 200)}...`);
    callbacks?.onRound?.(round, maxRounds, lastUserMsg, response);

    // Check if the response contains Gherkin (= final answer)
    const gherkinMatch = response.match(/Feature:[\s\S]*/i);
    if (gherkinMatch) {
      console.log(`[DeepTest] Got Gherkin in round ${round} (${gherkinMatch[0].length} chars)`);
      try {
        const feature = parseGherkin(gherkinMatch[0]);
        feature.name = feature.name || fop.filename.replace(/\.[^.]+$/, '');
        if (!feature.tags.some(t => t === `@${fopGuid}`)) {
          feature.tags = [`@${fopGuid}`, ...feature.tags];
        }
        return [feature];
      } catch {
        return [];
      }
    }

    // Check if the AI asks for more tables
    const jsonMatch = response.match(/\{[\s\S]*"needTables"[\s\S]*\}/);
    console.log(`[DeepTest] Round ${round}: hasGherkin=${!!gherkinMatch}, hasNeedTables=${!!jsonMatch}`);
    if (jsonMatch) {
      try {
        const parsed = JSON.parse(jsonMatch[0]);
        const requestedNames: string[] = parsed.needTables ?? [];
        const reason: string = parsed.reason ?? '';
        console.log(`[DeepTest] AI requests tables:`, requestedNames, '| reason:', reason);

        // Resolve requested tables
        const newTables = requestedNames
          .map(name => {
            const identified = parseTableIdentificationResponse(JSON.stringify({ tables: [name], infosystems: [] }));
            return lookupRelevantTables(identified, varTables.filter(t => t.fields.length > 0));
          })
          .flat()
          .filter(t => !sentTableRefs.has(t.tableRef));

        if (newTables.length === 0 && round < maxRounds) {
          // AI asked for tables we don't have — tell it to work with what it has
          const noTablesMsg = de
            ? `Die angeforderten Tabellen (${requestedNames.join(', ')}) sind nicht in den geladenen Variablentabellen vorhanden. Bitte generiere den Test mit den verfuegbaren Feldern oder beschraenke den Test auf das was testbar ist.`
            : `The requested tables (${requestedNames.join(', ')}) are not available in the loaded variable tables. Please generate the test with the available fields or limit the test to what is testable.`;
          messages.push({ role: 'user', content: noTablesMsg });
          continue;
        }

        // Send the new table fields back
        const newContext = newTables.map(t => formatSingleTableContext(t, anforderungstext)).join('\n\n');
        for (const t of newTables) sentTableRefs.add(t.tableRef);

        const tableNames = newTables.map(t => `${tableDisplayName(t)} (${t.tableRef})`);
        const fieldCount = newTables.reduce((s, t) => s + t.fields.length, 0);
        callbacks?.onTablesIdentified?.({
          path: 'ki', tables: tableNames, fieldCount,
          tableIdRequest: reason, tableIdRawResponse: newContext.slice(0, 500),
        });

        const followUp = de
          ? `Hier sind die angeforderten Felder (${newTables.length} Tabellen, ${fieldCount} Felder):\n\n${newContext}\n\nBitte generiere jetzt den kompletten Gherkin-Test mit allen Szenarien. Wenn du noch weitere Tabellen brauchst, frage nochmal — sonst antworte mit dem Gherkin-Test.`
          : `Here are the requested fields (${newTables.length} tables, ${fieldCount} fields):\n\n${newContext}\n\nPlease generate the complete Gherkin test with all scenarios now. If you need more tables, ask again — otherwise respond with the Gherkin test.`;
        messages.push({ role: 'user', content: followUp });
      } catch {
        // JSON parse failed — force final output
        break;
      }
    } else {
      // Response is neither Gherkin nor a table request — force final round
      console.log(`[DeepTest] Unexpected response in round ${round}, forcing final`);
      break;
    }
  }

  // Force final output if max rounds exceeded
  console.log('[DeepTest] Max rounds reached, forcing final output');
  const forceMsg = de
    ? 'Maximale Anzahl Runden erreicht. Generiere JETZT den Gherkin-Test mit den verfuegbaren Feldern. Antworte NUR mit dem Gherkin-Feature.'
    : 'Maximum rounds reached. Generate the Gherkin test NOW with the available fields. Reply ONLY with the Gherkin feature.';
  messages.push({ role: 'user', content: forceMsg });

  const finalResponse = await chatCompletion(messages, model);
  callbacks?.onRound?.(maxRounds + 1, maxRounds, forceMsg, finalResponse);

  const finalMatch = finalResponse.match(/Feature:[\s\S]*/i);
  if (!finalMatch) return [];

  try {
    const feature = parseGherkin(finalMatch[0]);
    feature.name = feature.name || fop.filename.replace(/\.[^.]+$/, '');
    if (!feature.tags.some(t => t === `@${fopGuid}`)) {
      feature.tags = [`@${fopGuid}`, ...feature.tags];
    }
    return [feature];
  } catch {
    return [];
  }
}

/**
 * Public wrapper: generate Cucumber tests from an existing FopAnalysis.
 * Used when the user clicks "Tests generieren" separately after analysis.
 */
export async function generateCucumberFromFopAnalysis(
  fopFile: FopFile,
  analysis: FopAnalysis,
  bindings: FopBinding[],
  varTables: TableDef[],
  model: string,
  lang: 'de' | 'en',
  callbacks?: {
    testDepth?: 'quick' | 'deep';
    onTablesIdentified?: (info: { path: 'local' | 'ki'; tables: string[]; fieldCount: number; tableIdRequest?: string; tableIdRawResponse?: string }) => void;
    onTableIdStarted?: (request: string) => void;
    onPromptBuilt?: (gherkinRequest: string) => void;
    onDelta?: (text: string) => void;
  },
  isBindings?: import('../lib/fopTxtParser').IsBinding[],
): Promise<FeatureInput[]> {
  // Collect FOP.txt bindings for this FOP
  const fopBindings = bindings.filter(b => {
    const bName = b.fopPath.split('/').pop()?.toLowerCase() ?? '';
    const fName = fopFile.filename.toLowerCase();
    return bName === fName || b.fopPath.toLowerCase() === fopFile.relativePath.toLowerCase();
  });
  // Collect IS bindings for this FOP
  const fopIsBindings = (isBindings ?? []).filter(b => {
    const bName = b.fopPath.split('/').pop()?.toLowerCase() ?? '';
    const fName = fopFile.filename.toLowerCase();
    return bName === fName || b.fopPath.toLowerCase() === fopFile.relativePath.toLowerCase();
  });
  return generateCucumberFromAnalysis(callbacks?.testDepth ?? 'quick', callbacks, fopIsBindings,
    fopFile, analysis.humanDescription, analysis.technicalDescription,
    analysis.fieldInteractions ?? [], fopBindings, varTables, model, lang,
  );
}

function extractJson(text: string): Record<string, unknown> | null {
  try {
    const match = text.match(/\{[\s\S]*\}/);
    if (match) return JSON.parse(match[0]);
    return JSON.parse(text);
  } catch {
    return null;
  }
}

function fallbackTechnicalDescription(fop: FopFile, lang: 'de' | 'en'): import('../types/fop').TechnicalDescription {
  const events = Object.fromEntries(fop.eventHandlers.map(e => [`${e.event}${e.field ? `:${e.field}` : ''}`, e.labelOrFunction]));
  return {
    summary: lang === 'de'
      ? `FOP ${fop.filename} — KI-Analyse nicht verfügbar`
      : `FOP ${fop.filename} — KI analysis not available`,
    eventDescriptions: events,
    dataFlow: '',
    sideEffects: fop.edpCalls.map(e => `EDP ${e.type}: ${e.commandLine.slice(0, 60)}`),
  };
}

function fallbackHumanDescription(fop: FopFile, lang: 'de' | 'en'): import('../types/fop').HumanDescription {
  return {
    summary: lang === 'de'
      ? `Programm ${fop.filename} — Beschreibung wird generiert.`
      : `Program ${fop.filename} — description pending generation.`,
    useCases: [],
  };
}

function computeScore(findings: GuidelineFinding[]): import('../types/fop').GuidelinesResult['score'] {
  const errors = findings.filter(f => f.severity === 'error').length;
  const warnings = findings.filter(f => f.severity === 'warning').length;
  const infos = findings.filter(f => f.severity === 'info').length;
  if (errors > 0) return 'F';
  if (warnings >= 5 || infos >= 10) return 'D';
  if (warnings >= 3 || infos >= 7) return 'C';
  if (warnings >= 2 || infos >= 4) return 'B';
  return 'A';
}
