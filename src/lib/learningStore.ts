import type { LearningEntry } from '../types/learning';
import type { LearningCrosscheckMode } from './settings';
import { exportAppSettingsJson } from './settings';
import defaultLearningsJson from '../resources/learning/default-learnings.json';
import { extractTextFromPdf } from './pdfParser';
import { chunkDocument } from './kbChunker';
import { loadSharedSettingsDirectoryHandle, verifyPermission } from './fileSystemAccess';

export const SETTINGS_DIR_NAME = '.cucumbergnerator-settings';
export const LEARNINGS_FILE_NAME = 'learnings.md';
export const DEFAULT_LEARNINGS_JSON_FILE = 'default-learnings.json';
export const SHARED_LEARNINGS_FILE_NAME = 'global-learnings.md';
export const SHARED_SETTINGS_JSON_FILE = 'user-settings.json';
/** Legacy filename kept for one-time migration only. */
const LEGACY_SETTINGS_JSON_FILE = 'settings.json';

const GENERATED_LEARNING_ID_PREFIXES = [
  'std-fop-',
  'std-bdd-',
  'fops-curated-',
  'fops-doc-',
  'data-',
  'fop-command-ref-',
  'fop-pattern-ref-',
  'fop-command-rule-',
  'edp-ref-',
  'langdoc-event-',
  'doc-',
];

export interface WorkspaceImportSourceStat {
  source: 'fop' | 'infosysteme' | 'variablentabelle' | 'customsteps' | 'features' | 'fopsdocs' | 'extracted' | 'pdfs';
  scanned: number;
  generated: number;
}

export interface WorkspaceDataImportResult {
  entries: LearningEntry[];
  imported: number;
  added: number;
  updated: number;
  sourceStats: WorkspaceImportSourceStat[];
}

export function isGeneratedLearningId(id: string): boolean {
  return GENERATED_LEARNING_ID_PREFIXES.some((prefix) => id.startsWith(prefix));
}

export function stripGeneratedLearnings(entries: LearningEntry[]): LearningEntry[] {
  // Keep explicit global test standards even if their IDs use generated prefixes.
  return entries.filter((entry) => entry.usage === 'tests-global' || !isGeneratedLearningId(entry.id));
}

const JSON_BLOCK_RE = /```json\s*([\s\S]*?)```/i;
const REFERENCE_MAX_TEXT_CHARS = 2200;
const REFERENCE_ALLOWED_EXTS = new Set([
  '.fo', '.fo1', '.fo2', '.ev', '.tab', '.me', '.bkopf', '.bfuss',
  '.txt', '.md', '.feature', '.java', '.js', '.ts', '.json', '.xml', '.sql',
]);

function isAllowedReferenceFile(name: string): boolean {
  const lower = name.toLowerCase();
  const idx = lower.lastIndexOf('.');
  if (idx < 0) return true;
  return REFERENCE_ALLOWED_EXTS.has(lower.slice(idx));
}

function isLikelyTextFopCorpusFile(name: string): boolean {
  const lower = name.toLowerCase();
  const blockedExts = [
    '.pdf', '.doc', '.docx', '.ppt', '.pptx', '.zip', '.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp', '.exe', '.dll', '.bin', '.ipynb',
  ];
  return !blockedExts.some((ext) => lower.endsWith(ext));
}

function extractReferenceKeywords(pathOrName: string, content: string): string[] {
  const tokens = new Set<string>();
  for (const part of pathOrName.toLowerCase().split(/[\\/._\-\s]+/)) {
    if (part.length >= 3) tokens.add(part);
  }

  const matches = content.match(/\b(?:G\|success|G\|mehr|\.select|\.load|\.assign|\.copy|\.formula|\.end\s+1|\.error|G\|evtkommd|@group|@filingmode)\b/gi) ?? [];
  for (const m of matches.slice(0, 8)) {
    tokens.add(m.toLowerCase().replace(/\s+/g, ' '));
  }
  return Array.from(tokens).slice(0, 10);
}

function sanitizeReferenceSnippet(content: string): string {
  const trimmed = content.replace(/\r\n/g, '\n').trim();
  if (trimmed.length <= REFERENCE_MAX_TEXT_CHARS) return trimmed;
  return `${trimmed.slice(0, REFERENCE_MAX_TEXT_CHARS)}\n[...]`;
}

function inferLearningScopeFromSourcePath(sourcePath: string): LearningEntry['scope'] {
  const normalized = sourcePath.replace(/\\/g, '/').toLowerCase();
  if (normalized.startsWith('docs/') || normalized.startsWith('src/lib/')) {
    return 'general';
  }
  return 'customer';
}

function createReferenceLearning(relativePath: string, content: string, now: string): LearningEntry {
  const normalized = relativePath.replace(/\\/g, '/');
  const name = normalized.split('/').pop() || normalized;
  const id = `ref-${normalized.toLowerCase().replace(/[^a-z0-9/_\-.]/g, '-')}`;
  return {
    id,
    title: `Referenz: ${name}`,
    summary: sanitizeReferenceSnippet(content),
    comment: 'Automatisch aus Referenzbeispiel importiert.',
    keywords: extractReferenceKeywords(normalized, content),
    category: 'example',
    scope: inferLearningScopeFromSourcePath(normalized),
    confirmed: true,
    acceptedCount: 1,
    rejectedCount: 0,
    sourcePath: normalized,
    createdAt: now,
    updatedAt: now,
  };
}

async function tryReadRelativeFile(rootHandle: FileSystemDirectoryHandle, relativePath: string): Promise<string | null> {
  const clean = relativePath.trim().replace(/\\/g, '/').replace(/^\/+|\/+$/g, '');
  if (!clean) return null;
  const parts = clean.split('/');
  const fileName = parts.pop();
  if (!fileName) return null;
  try {
    let cursor = rootHandle;
    for (const part of parts) {
      if (!part) continue;
      cursor = await cursor.getDirectoryHandle(part);
    }
    const fileHandle = await cursor.getFileHandle(fileName);
    const file = await fileHandle.getFile();
    return file.text();
  } catch {
    return null;
  }
}

async function tryGetRelativeDirectory(
  rootHandle: FileSystemDirectoryHandle,
  relativePath: string,
): Promise<FileSystemDirectoryHandle | null> {
  const clean = relativePath.trim().replace(/\\/g, '/').replace(/^\/+|\/+$/g, '');
  if (!clean) return rootHandle;
  try {
    let cursor = rootHandle;
    for (const part of clean.split('/')) {
      if (!part) continue;
      cursor = await cursor.getDirectoryHandle(part);
    }
    return cursor;
  } catch {
    return null;
  }
}

async function collectFilesRecursive(
  dir: FileSystemDirectoryHandle,
  prefix: string,
  maxFiles: number,
  allowFile: (name: string) => boolean,
  out: Array<{ path: string; content: string }>,
): Promise<void> {
  if (out.length >= maxFiles) return;
  for await (const [name, handle] of dir.entries()) {
    if (out.length >= maxFiles) return;
    const rel = prefix ? `${prefix}/${name}` : name;
    if (handle.kind === 'directory') {
      if (name.startsWith('.') || name.toLowerCase() === 'node_modules') continue;
      await collectFilesRecursive(await dir.getDirectoryHandle(name), rel, maxFiles, allowFile, out);
      continue;
    }
    if (!allowFile(name)) continue;
    const file = await (handle as FileSystemFileHandle).getFile();
    const text = await file.text();
    if (!text.trim()) continue;
    out.push({ path: rel, content: text });
  }
}

async function collectPdfFilesRecursive(
  dir: FileSystemDirectoryHandle,
  prefix: string,
  maxFiles: number,
  out: Array<{ path: string; file: File }>,
): Promise<void> {
  if (out.length >= maxFiles) return;
  for await (const [name, handle] of dir.entries()) {
    if (out.length >= maxFiles) return;
    const rel = prefix ? `${prefix}/${name}` : name;
    if (handle.kind === 'directory') {
      if (name.startsWith('.') || name.toLowerCase() === 'node_modules') continue;
      await collectPdfFilesRecursive(await dir.getDirectoryHandle(name), rel, maxFiles, out);
      continue;
    }
    if (!name.toLowerCase().endsWith('.pdf')) continue;
    const file = await (handle as FileSystemFileHandle).getFile();
    out.push({ path: rel, file });
  }
}

function createWorkspaceInsightEntry(
  id: string,
  title: string,
  summary: string,
  sourcePath: string,
  keywords: string[],
  now: string,
): LearningEntry {
  return {
    id,
    title,
    summary,
    comment: 'Automatisch aus Workspace-Referenzdaten abgeleitet.',
    keywords,
    category: 'pattern',
    scope: inferLearningScopeFromSourcePath(sourcePath),
    confirmed: true,
    acceptedCount: 1,
    rejectedCount: 0,
    sourcePath,
    createdAt: now,
    updatedAt: now,
  };
}

function deriveFopConfigInsight(content: string, now: string): LearningEntry | null {
  const lines = content.split(/\r?\n/).map((line) => line.trim()).filter((line) => line && !line.startsWith('#'));
  if (lines.length === 0) return null;

  const events = new Set<string>();
  const commands = new Set<string>();
  let hasContinueMarker = 0;
  let wildcardHeavy = 0;

  for (const line of lines.slice(0, 1200)) {
    const tokens = line.split(/\s+/).filter(Boolean);
    if (tokens.length < 6) continue;
    commands.add(tokens[1].toLowerCase());
    events.add(tokens[2].toLowerCase());
    if (line.includes('[C]')) hasContinueMarker += 1;
    if ((line.match(/\*/g) ?? []).length >= 3) wildcardHeavy += 1;
  }

  const summary = [
    `fop.txt zeigt ${lines.length} aktive EFOP-Zuordnungen mit ${events.size} Events und ${commands.size} Kommandotypen.`,
    hasContinueMarker > 0
      ? `${hasContinueMarker} Zuordnungen nutzen [C] Continue: dafuer sollten BDD-Szenarien Mehrfachausfuehrung/Abfolge absichern.`
      : 'Keine [C]-Marker gefunden: Fokus auf Einzel-Trigger-Verhalten.',
    wildcardHeavy > 0
      ? `${wildcardHeavy} Zeilen enthalten viele Wildcards (*): dafuer stets Positiv-/Negativfall in den Szenarien abdecken.`
      : 'Wildcards sind begrenzt genutzt.',
  ].join(' ');

  return createWorkspaceInsightEntry(
    'data-fop-config-coverage',
    'EFOP-Mapping aus fop.txt als Testtreiber nutzen',
    summary,
    'docs/CucumberDaten/fop.txt',
    ['fop', 'efop', 'events', 'continue', 'wildcard', 'bdd'],
    now,
  );
}

function deriveFopConfigDetailInsights(content: string, now: string): LearningEntry[] {
  const lines = content.split(/\r?\n/).map((line) => line.trim()).filter((line) => line && !line.startsWith('#'));
  const eventCounts = new Map<string, number>();
  const commandCounts = new Map<string, number>();

  for (const line of lines.slice(0, 2000)) {
    const tokens = line.split(/\s+/).filter(Boolean);
    if (tokens.length < 6) continue;
    const command = tokens[1].toLowerCase();
    const event = tokens[2].toLowerCase();
    commandCounts.set(command, (commandCounts.get(command) ?? 0) + 1);
    eventCounts.set(event, (eventCounts.get(event) ?? 0) + 1);
  }

  const out: LearningEntry[] = [];
  const topEvents = Array.from(eventCounts.entries()).sort((a, b) => b[1] - a[1]).slice(0, 12);
  for (const [event, count] of topEvents) {
    out.push(createWorkspaceInsightEntry(
      `data-fop-event-${event.replace(/[^a-z0-9]+/g, '-')}`,
      `EFOP-Event Referenz: ${event}`,
      `Das Event ${event} kommt ${count} Mal in fop.txt vor und ist damit ein relevanter Trigger im Bestand. Fuer diesen Trigger explizite Szenarien fuer Ausloesung, Nicht-Ausloesung und Ergebniswirkung modellieren.`,
      'docs/CucumberDaten/fop.txt',
      ['fop', 'efop', 'event', event],
      now,
    ));
  }

  const topCommands = Array.from(commandCounts.entries()).sort((a, b) => b[1] - a[1]).slice(0, 10);
  for (const [command, count] of topCommands) {
    out.push(createWorkspaceInsightEntry(
      `data-fop-command-${command.replace(/[^a-z0-9]+/g, '-')}`,
      `EFOP-Kommando Referenz: ${command}`,
      `Das Kommando ${command} ist ${count} Mal in fop.txt hinterlegt. Unterschiede zwischen Neu-, Aendern-, Zeigen- und Sonderpfaden im Testdesign separat behandeln.`,
      'docs/CucumberDaten/fop.txt',
      ['fop', 'command', command, 'efop'],
      now,
    ));
  }

  return out;
}

function deriveInfosystemInsight(content: string, now: string): LearningEntry | null {
  const lines = content.split(/\r?\n/).filter(Boolean);
  if (lines.length < 2) return null;
  const headers = lines[0].split('\t').map((h) => h.trim());
  const efopColumns = headers.filter((h) => /efop/i.test(h));
  if (efopColumns.length === 0) return null;

  const summary = `infosysteme.txt enthaelt ${headers.length} Spalten, davon ${efopColumns.length} EFOP-bezogene Trigger-Spalten (${efopColumns.slice(0, 5).join(', ')}). Beim Szenarioaufbau Trigger gezielt als Given/When aufnehmen und Ergebnisfelder in Then validieren.`;
  return createWorkspaceInsightEntry(
    'data-infosystem-efop-columns',
    'Infosystem-Trigger aus Tabellenspalten in Szenarien spiegeln',
    summary,
    'docs/CucumberDaten/infosysteme.txt',
    ['infosystem', 'efop', 'field validation', 'button', 'trigger'],
    now,
  );
}

function deriveInfosystemColumnInsights(content: string, now: string): LearningEntry[] {
  const lines = content.split(/\r?\n/).filter(Boolean);
  if (lines.length < 2) return [];
  const headers = lines[0].split('\t').map((h) => h.trim());
  const efopColumns = headers.filter((h) => /efop/i.test(h));
  return efopColumns.map((header) => createWorkspaceInsightEntry(
    `data-infosystem-column-${header.toLowerCase().replace(/[^a-z0-9]+/g, '-')}`,
    `Infosystem-EFOP Referenz: ${header}`,
    `Die Spalte ${header} ist in infosysteme.txt als Trigger-/Hook-Punkt vorhanden. Beim Ableiten von Szenarien fuer Infosysteme diesen Einstiegspunkt gezielt mit Vorbedingung und Ergebnisfeld verknuepfen.`,
    'docs/CucumberDaten/infosysteme.txt',
    ['infosystem', 'efop', 'column', header.toLowerCase()],
    now,
  ));
}

function deriveVariableTableInsight(content: string, now: string): LearningEntry | null {
  const lines = content.split(/\r?\n/).filter(Boolean);
  if (lines.length < 2) return null;
  const header = lines[0].split('\t').map((h) => h.trim().toLowerCase());
  const variableNameIndex = header.findIndex((h) => h === 'variable name');
  const writeProtectIndex = header.findIndex((h) => h.includes('write-protect'));
  if (variableNameIndex < 0) return null;

  const prefixes = new Map<string, number>();
  let readonlyHints = 0;

  for (const line of lines.slice(1, 1800)) {
    const cols = line.split('\t');
    const variable = (cols[variableNameIndex] ?? '').trim().toLowerCase();
    if (!variable) continue;
    const prefix = (variable.match(/^[a-z]{2,4}/)?.[0] ?? variable.slice(0, 2));
    prefixes.set(prefix, (prefixes.get(prefix) ?? 0) + 1);
    const writeProtect = (cols[writeProtectIndex] ?? '').toLowerCase();
    if (writeProtect.includes('read-only') || writeProtect.includes('always')) readonlyHints += 1;
  }

  const topPrefixes = Array.from(prefixes.entries())
    .sort((a, b) => b[1] - a[1])
    .slice(0, 6)
    .map(([p, n]) => `${p}(${n})`)
    .join(', ');

  const summary = `variablentabelle.txt liefert starke Feldpraefix-Muster (${topPrefixes || 'n/a'}). ${readonlyHints} Felder sind als read-only/always markiert und sollten in Tests nur verifiziert, nicht bearbeitet werden.`;
  return createWorkspaceInsightEntry(
    'data-variable-table-prefixes',
    'Variablentabelle fuer Editierregeln und Feldpraefixe nutzen',
    summary,
    'docs/CucumberDaten/variablentabelle.txt',
    ['variablentabelle', 'readonly', 'prefix', 'field'],
    now,
  );
}

function deriveVariablePrefixInsights(content: string, now: string): LearningEntry[] {
  const lines = content.split(/\r?\n/).filter(Boolean);
  if (lines.length < 2) return [];
  const header = lines[0].split('\t').map((h) => h.trim().toLowerCase());
  const variableNameIndex = header.findIndex((h) => h === 'variable name');
  if (variableNameIndex < 0) return [];

  const prefixes = new Map<string, number>();
  for (const line of lines.slice(1, 2500)) {
    const cols = line.split('\t');
    const variable = (cols[variableNameIndex] ?? '').trim().toLowerCase();
    if (!variable) continue;
    const prefix = (variable.match(/^[a-z]{2,5}/)?.[0] ?? '').trim();
    if (!prefix) continue;
    prefixes.set(prefix, (prefixes.get(prefix) ?? 0) + 1);
  }

  return Array.from(prefixes.entries())
    .sort((a, b) => b[1] - a[1])
    .slice(0, 15)
    .map(([prefix, count]) => createWorkspaceInsightEntry(
      `data-variable-prefix-${prefix}`,
      `Variablenpraefix Referenz: ${prefix}`,
      `Das Praefix ${prefix} kommt ${count} Mal in der Variablentabelle vor. Dieses Namensmuster als bestehende Konvention respektieren und neue Ableitungen daran orientieren.`,
      'docs/CucumberDaten/variablentabelle.txt',
      ['variablentabelle', 'prefix', prefix, 'naming'],
      now,
    ));
}

function deriveCustomStepsInsight(files: Array<{ path: string; content: string }>, now: string): LearningEntry | null {
  if (files.length === 0) return null;
  let given = 0;
  let when = 0;
  let then = 0;
  let and = 0;
  const sampleSteps: string[] = [];

  for (const file of files) {
    given += (file.content.match(/@Given\(/g) ?? []).length;
    when += (file.content.match(/@When\(/g) ?? []).length;
    then += (file.content.match(/@Then\(/g) ?? []).length;
    and += (file.content.match(/@And\(/g) ?? []).length;

    const matches = file.content.matchAll(/@(Given|When|Then|And)\(("[^"]+"|\^"[^"]+"\$)\)/g);
    for (const m of matches) {
      if (sampleSteps.length >= 8) break;
      const expr = m[2].replace(/^\^"|"\$$/g, '').replace(/^"|"$/g, '');
      sampleSteps.push(expr);
    }
    if (sampleSteps.length >= 8) break;
  }

  const summary = `CustomSteps enthalten ${files.length} Java-Dateien mit Given=${given}, When=${when}, Then=${then}, And=${and}. Wiederverwendbare Steps priorisieren statt neue Formulierungen zu erfinden. Beispiele: ${sampleSteps.slice(0, 4).join(' | ') || 'n/a'}.`;
  return createWorkspaceInsightEntry(
    'data-customsteps-step-catalog',
    'Vorhandene CustomSteps als Formulierungsquelle verwenden',
    summary,
    'docs/CustomSteps',
    ['customsteps', 'given', 'when', 'then', 'reuse'],
    now,
  );
}

function deriveFeatureCorpusInsight(files: Array<{ path: string; content: string }>, now: string): LearningEntry | null {
  if (files.length === 0) return null;
  let scenarioCount = 0;
  const tagCounts = new Map<string, number>();

  for (const file of files) {
    for (const line of file.content.split(/\r?\n/)) {
      const trimmed = line.trim();
      if (/^scenario(?: outline)?:/i.test(trimmed)) scenarioCount += 1;
      if (trimmed.startsWith('@')) {
        for (const token of trimmed.split(/\s+/)) {
          if (!token.startsWith('@')) continue;
          const key = token.toLowerCase();
          tagCounts.set(key, (tagCounts.get(key) ?? 0) + 1);
        }
      }
    }
  }

  const topTags = Array.from(tagCounts.entries())
    .sort((a, b) => b[1] - a[1])
    .slice(0, 5)
    .map(([tag, n]) => `${tag}(${n})`)
    .join(', ');

  const summary = `Feature-Bestand unter docs/cucumber umfasst ${files.length} Dateien mit ca. ${scenarioCount} Szenarien. Haeufige Tags: ${topTags || 'keine'}. Neue Arbeitspakete sollten diese Tag-Struktur fuer Filterbarkeit und Regressionstrefferquote uebernehmen.`;
  return createWorkspaceInsightEntry(
    'data-feature-corpus-tagging',
    'Bestehende Feature-Struktur als Blueprint nutzen',
    summary,
    'docs/cucumber',
    ['feature', 'scenario', 'tags', 'regression'],
    now,
  );
}

function createFopsDocLearning(
  id: string,
  title: string,
  summary: string,
  sourcePath: string,
  keywords: string[],
  now: string,
): LearningEntry {
  return {
    id,
    title,
    summary,
    comment: 'Automatisch aus docs/FOPs Dateibestand abgeleitet.',
    keywords,
    category: 'rule',
    scope: 'general',
    confirmed: true,
    acceptedCount: 1,
    rejectedCount: 0,
    sourcePath,
    createdAt: now,
    updatedAt: now,
  };
}

function extractFirstMatchingLine(content: string, token: string): string | null {
  const line = content.split(/\r?\n/).find((entry) => entry.includes(token));
  return line ? line.trim() : null;
}

function createReferenceExampleLearning(
  id: string,
  title: string,
  summary: string,
  sourcePath: string,
  keywords: string[],
  now: string,
): LearningEntry {
  return {
    id,
    title,
    summary,
    comment: 'Automatisch aus internen Referenzbeispielen abgeleitet.',
    keywords,
    category: 'example',
    scope: 'general',
    confirmed: true,
    acceptedCount: 1,
    rejectedCount: 0,
    sourcePath,
    createdAt: now,
    updatedAt: now,
  };
}

function createReferenceRuleLearning(
  id: string,
  title: string,
  summary: string,
  sourcePath: string,
  keywords: string[],
  now: string,
): LearningEntry {
  return {
    id,
    title,
    summary,
    comment: 'Automatisch aus internen FOP-Referenzen als Regel abgeleitet.',
    keywords,
    category: 'rule',
    scope: 'general',
    confirmed: true,
    acceptedCount: 1,
    rejectedCount: 0,
    sourcePath,
    createdAt: now,
    updatedAt: now,
  };
}

function createExtractedDocLearning(
  id: string,
  title: string,
  summary: string,
  sourcePath: string,
  keywords: string[],
  now: string,
  category: LearningEntry['category'] = 'pattern',
): LearningEntry {
  return {
    id,
    title,
    summary,
    comment: 'Automatisch aus PDF-/Doku-Textauszuegen abgeleitet.',
    keywords,
    category,
    scope: 'general',
    confirmed: true,
    acceptedCount: 1,
    rejectedCount: 0,
    sourcePath,
    createdAt: now,
    updatedAt: now,
  };
}

function sanitizeExtractedLine(line: string): string {
  return line
    .replace(/--- Page \d+ ---/g, '')
    .replace(/\s+/g, ' ')
    .trim();
}

function deriveExtractedDocInsights(files: Array<{ path: string; content: string }>, now: string): LearningEntry[] {
  const out: LearningEntry[] = [];

  for (const file of files) {
    const lines = file.content.split(/\r?\n/).map(sanitizeExtractedLine).filter(Boolean);
    const lowerPath = file.path.toLowerCase();

    if (lowerPath.includes('standardsteps')) {
      for (let i = 0; i < lines.length; i += 1) {
        const line = lines[i];
        if (!line.startsWith('^')) continue;
        const description = lines.slice(i + 1, i + 4).find((entry) => !entry.startsWith('^') && !entry.startsWith('(') && entry.length > 10) ?? 'Vorhandener Standardstep aus der internen Step-Dokumentation.';
        const compact = line.length > 90 ? `${line.slice(0, 90)}...` : line;
        const id = `extracted-step-${compact.toLowerCase().replace(/[^a-z0-9]+/g, '-')}`;
        out.push(createExtractedDocLearning(
          id,
          `Standardstep Referenz: ${compact}`,
          `${description} Diesen vorhandenen Step bevorzugt wiederverwenden, statt einen neuen Spezialstep zu erfinden.`,
          file.path,
          ['cucumber', 'standardstep', 'reuse', 'step-catalog'],
          now,
        ));
      }
    }

    for (const line of lines) {
      if (/^scenario(?: outline)?:/i.test(line)) {
        const title = line.replace(/^scenario(?: outline)?:/i, '').trim();
        const id = `extracted-scenario-${file.path.toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${title.toLowerCase().replace(/[^a-z0-9]+/g, '-')}`;
        out.push(createExtractedDocLearning(
          id,
          `Szenario-Referenz: ${title}`,
          `Dieses dokumentierte Szenario liegt bereits im internen Beispielbestand vor. Aehnliche Arbeitspakete sollten sich an diesem fachlichen Ablauf und der Granularitaet orientieren.`,
          file.path,
          ['cucumber', 'scenario', 'reference', 'example'],
          now,
          'example',
        ));
      }
    }

    if (lowerPath.includes('cucumber als prim') || lowerPath.includes('prim') || lowerPath.includes('testtool')) {
      const guideTopics = lines.filter((line) => /infosysteme|tippkommandos|fops ausf|referenzausgaben|debuggen|subeditor|dialoge|scenario outline|basis-steps|junit|edp/i.test(line)).slice(0, 40);
      for (const topic of guideTopics) {
        const id = `extracted-guide-${topic.toLowerCase().replace(/[^a-z0-9]+/g, '-')}`;
        out.push(createExtractedDocLearning(
          id,
          `Guide-Thema: ${topic}`,
          'Dieses Thema ist im internen Cucumber-Handbuch explizit beschrieben und sollte als bestehende Vorgehensweise bzw. Referenz in neue Tests und Learnings einfliessen.',
          file.path,
          ['cucumber', 'guide', 'best-practice'],
          now,
        ));
      }
    }
  }

  return out;
}

async function derivePdfInsights(
  files: Array<{ path: string; file: File }>,
  now: string,
): Promise<LearningEntry[]> {
  const out: LearningEntry[] = [];

  for (const item of files) {
    try {
      const parsed = await extractTextFromPdf(item.file);
      const chunks = chunkDocument(item.path, parsed.pages);
      const chunkLearnings = chunks.slice(0, 24).map((chunk, index) => createExtractedDocLearning(
        `pdf-chunk-${item.path.toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${index + 1}`,
        `PDF-Abschnitt: ${chunk.heading || item.file.name}`,
        `Aus dem PDF ${item.file.name} wurde ein Abschnitt extrahiert. Dieses Thema als bestehende interne Referenz fuer Regeln, Testfaelle oder Formulierungen verwenden.`,
        item.path,
        ['pdf', 'section', 'reference'],
        now,
      ));
      out.push(...chunkLearnings);

      const lines = parsed.pages.flatMap((page) => page.text.split('\n')).map(sanitizeExtractedLine).filter(Boolean);

      for (const line of lines) {
        if (/^scenario(?: outline)?:/i.test(line)) {
          const title = line.replace(/^scenario(?: outline)?:/i, '').trim();
          if (!title) continue;
          out.push(createExtractedDocLearning(
            `pdf-scenario-${item.path.toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${title.toLowerCase().replace(/[^a-z0-9]+/g, '-')}`,
            `PDF-Szenario: ${title}`,
            `Dieses Szenario wurde direkt aus einem PDF extrahiert und kann als vorhandenes fachliches Beispiel fuer neue Arbeitspakete dienen.`,
            item.path,
            ['pdf', 'scenario', 'example'],
            now,
            'example',
          ));
        }
        if (line.startsWith('^')) {
          const compact = line.length > 90 ? `${line.slice(0, 90)}...` : line;
          out.push(createExtractedDocLearning(
            `pdf-step-${item.path.toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${compact.toLowerCase().replace(/[^a-z0-9]+/g, '-')}`,
            `PDF-Step Referenz: ${compact}`,
            'Dieses Step-Muster wurde direkt aus einem PDF extrahiert und sollte vor neuen Spezialsteps als vorhandene Referenz geprueft werden.',
            item.path,
            ['pdf', 'step', 'reuse'],
            now,
          ));
        }
      }
    } catch {
      // Ignore individual PDF parse failures so other files still contribute.
    }
  }

  return out;
}

function getFopCommandRuleNote(command: string): string {
  const notes: Record<string, string> = {
    '.select': 'Selektionsaufbau und Trefferverhalten immer zusammen mit G|mehr/G|success absichern.',
    '.assign': 'Fehlertolerante oder vorbereitende Zuweisungen danach fachlich auf Wirkung pruefen.',
    '.copy': 'Direkte Uebernahmen nur bei kompatiblen Typen einsetzen und implizite Konvertierungen vermeiden.',
    '.formula': 'Berechnungen und bedingte Ableitungen mit Null-, Leer- und Alternativpfaden pruefen.',
    '.load': 'Nachgeladene Gruppen/Objekte immer auf Leer- und Mehrfachtreffer absichern.',
    '.continue': 'Continue-Spruenge nur mit klarer Ruecksprung- und Abbruchlogik verwenden.',
    '.error': 'Fehlerausgaben an fachlich erkennbare Situationen binden und moeglichst feldnah verorten.',
    '.box': 'Dialoge stets mit Benutzerentscheidung und Folgepfad als eigene Szenarien abbilden.',
    '.system': 'Systemaufrufe als Betriebs-/Sicherheitsgrenze behandeln und Ein-/Ausgabekontext absichern.',
    '.rewrite': 'Persistenzschritte mit Vorher-/Nachher-Zustand und Seiteneffekten pruefen.',
    '.call': 'Externe Aufrufe nur mit dokumentiertem Ein-/Ausgabevertrag und Fehlerpfad verwenden.',
    '.if': 'Bedingungszweige als eigene Entscheidungslogik mit Positiv- und Negativpfad behandeln.',
    '.endif': 'Verschachtelte Kontrollpfade lesbar halten und indirekte Seiteneffekte vermeiden.',
    '.return': 'Rueckgaben aus SUB-/Service-Logik mit eindeutigem Zustand und Aufrufererwartung modellieren.',
    '.end': 'Abbruch-/Endpunkte fachlich begruenden und in Szenarien explizit sichtbar machen.',
  };
  return notes[command] ?? 'Diesen Befehl mit Vorbedingung, Ergebnispfad und moeglichen Seiteneffekten explizit dokumentieren und testen.';
}

function extractFopCommands(files: Array<{ path: string; content: string }>): Array<{ command: string; path: string; line: string }> {
  const found = new Map<string, { command: string; path: string; line: string }>();
  const re = /(^|\s)(\.[a-z][a-z0-9-]*)\b/gim;

  for (const file of files) {
    for (const line of file.content.split(/\r?\n/)) {
      for (const match of line.matchAll(re)) {
        const command = match[2].toLowerCase();
        if (!found.has(command)) {
          found.set(command, { command, path: file.path, line: line.trim() });
        }
      }
    }
  }

  return Array.from(found.values()).sort((a, b) => a.command.localeCompare(b.command));
}

function deriveFopCommandReferenceInsights(files: Array<{ path: string; content: string }>, now: string): LearningEntry[] {
  const specs: Array<{ token: string; title: string; note: string; keywords: string[] }> = [
    { token: '.select', title: 'FOP-Befehl Referenz: .select', note: 'Selektionsaufbau und Ergebnispruefung mit G|mehr/G|success immer im Paar betrachten.', keywords: ['fop', '.select', 'selection', 'g|mehr', 'g|success'] },
    { token: '.assign', title: 'FOP-Befehl Referenz: .assign', note: 'Fuer fehlertolerante oder vorbereitende Zuweisungen nutzen und Fachauswirkung danach pruefen.', keywords: ['fop', '.assign', 'assignment'] },
    { token: '.copy', title: 'FOP-Befehl Referenz: .copy', note: 'Bei kompatiblen Typen als direkte Uebernahme verwenden und auf implizite Konvertierungen verzichten.', keywords: ['fop', '.copy', 'types'] },
    { token: '.formula', title: 'FOP-Befehl Referenz: .formula', note: 'Berechnungen und bedingte Ableitungen explizit absichern, besonders bei Null-/Leerfaellen.', keywords: ['fop', '.formula', 'calculation'] },
    { token: '.load', title: 'FOP-Befehl Referenz: .load', note: 'Nachgeladenen Kontext immer auf Mehrfachtreffer und Leertreffer pruefen.', keywords: ['fop', '.load', 'group-load', 'g|mehr'] },
    { token: '.continue', title: 'FOP-Befehl Referenz: .continue', note: 'Continue-Ketten nur mit klaren Abbruch- und Ruecksprungpfaden modellieren.', keywords: ['fop', '.continue', 'flow-control'] },
    { token: '.error', title: 'FOP-Befehl Referenz: .error', note: 'Fehlerausgaben an fachlich erkennbare Situationen koppeln und nach Moeglichkeit feldnah verorten.', keywords: ['fop', '.error', 'validation'] },
    { token: '.box', title: 'FOP-Befehl Referenz: .box', note: 'Dialoge immer mit Benutzerentscheidung und Folgepfad als getrennte Szenarien abdecken.', keywords: ['fop', '.box', 'dialog'] },
  ];

  const out: LearningEntry[] = [];

  const discoveredCommands = extractFopCommands(files);
  for (const item of discoveredCommands) {
    out.push(createReferenceRuleLearning(
      `fop-command-rule-${item.command.replace(/[^a-z0-9]+/g, '-')}`,
      `FOP-Befehl Regel: ${item.command}`,
      `${getFopCommandRuleNote(item.command)} Referenz aus ${item.path}: ${item.line || item.command}`,
      item.path,
      ['fop', 'command', item.command],
      now,
    ));
  }

  for (const spec of specs) {
    const match = files.find((file) => file.content.includes(spec.token));
    if (!match) continue;
    const line = extractFirstMatchingLine(match.content, spec.token);
    out.push(createReferenceExampleLearning(
      `fop-command-ref-${spec.token.replace(/[^a-z]+/gi, '')}`,
      spec.title,
      `${spec.note} Beispiel aus ${match.path}: ${line ?? spec.token}`,
      match.path,
      spec.keywords,
      now,
    ));
  }

  const patternSpecs: Array<{ token: string; title: string; note: string; keywords: string[] }> = [
    { token: '.select screen header', title: 'FOP-Muster Referenz: .select screen header', note: 'Header-Selektion eignet sich fuer Kopfkontext und globale Anzeigen; Folgefelder danach explizit pruefen.', keywords: ['fop', 'screen-header', 'header-context'] },
    { token: '.select screen line', title: 'FOP-Muster Referenz: .select screen line', note: 'Zeilenselektion in Tabellenbereichen immer mit Zeilenkontext und Mehrfachtreffern testen.', keywords: ['fop', 'screen-line', 'table-context'] },
    { token: '.load 0 group', title: 'FOP-Muster Referenz: .load group', note: 'Group-Loads nur mit Nachweis der geladenen Zielgruppe und Leertreffer-Verhalten einsetzen.', keywords: ['fop', 'load-group', 'group'] },
    { token: 'G|mehr', title: 'FOP-Status Referenz: G|mehr', note: 'G|mehr steht im Bestand regelmaessig fuer Treffer-/Fortsetzungslogik und muss im Test als eigener Statuspfad behandelt werden.', keywords: ['fop', 'g|mehr', 'status'] },
    { token: 'G|evtkommd', title: 'FOP-Status Referenz: G|evtkommd', note: 'Eventkommandos werden im Bestand aktiv abgefragt; Triggerlogik daher nie nur ueber UI-Beschriftungen modellieren.', keywords: ['fop', 'g|evtkommd', 'event-command'] },
  ];

  for (const spec of patternSpecs) {
    const match = files.find((file) => file.content.includes(spec.token));
    if (!match) continue;
    const line = extractFirstMatchingLine(match.content, spec.token);
    out.push(createReferenceExampleLearning(
      `fop-pattern-ref-${spec.token.replace(/[^a-z0-9]+/gi, '-')}`,
      spec.title,
      `${spec.note} Beispiel aus ${match.path}: ${line ?? spec.token}`,
      match.path,
      spec.keywords,
      now,
    ));
  }

  return out;
}

function deriveEdpReferenceInsights(files: Array<{ path: string; content: string }>, now: string): LearningEntry[] {
  const out: LearningEntry[] = [];

  const shellFeature = files.find((file) => /edpimport\.sh/i.test(file.content));
  if (shellFeature) {
    const line = extractFirstMatchingLine(shellFeature.content, 'edpimport.sh');
    out.push(createReferenceExampleLearning(
      'edp-ref-import-shell',
      'EDP-Referenz: Import ueber edpimport.sh',
      `Wenn Cucumber-Daten fuer vorbereitende Stammdaten oder technische Setups benoetigt werden, kann ein EDP-Import als Testvorbereitung dienen. Beispiel: ${line ?? 'edpimport.sh ...'}`,
      shellFeature.path,
      ['edp', 'edpimport.sh', 'test-setup', 'stammdaten'],
      now,
    ));
  }

  const secondSessionFeature = files.find((file) => /zweite edp-session|cloned edp-session/i.test(file.content));
  if (secondSessionFeature) {
    out.push(createReferenceExampleLearning(
      'edp-ref-second-session',
      'EDP-Referenz: zweite Session fuer Nebenlaeufigkeit',
      'Wenn Testlogik parallele oder entkoppelte technische Aktionen braucht, kann eine zweite EDP-Session gezielt fuer Status- oder Seiteneffekte genutzt werden.',
      secondSessionFeature.path,
      ['edp', 'second-session', 'parallelism', 'status'],
      now,
    ));
  }

  const fallbackFeature = files.find((file) => /per edp abgebildet|ueber edp getestet|wird edp nicht ausgefuehrt|ack statt nak im edp/i.test(file.content));
  if (fallbackFeature) {
    out.push(createReferenceExampleLearning(
      'edp-ref-gap-fallback',
      'EDP-Referenz: Fallback wenn Cucumber-Step oder UI-Pruefung fehlt',
      'Mehrere Feature-Dateien zeigen EDP als Fallback, wenn Standardsteps oder UI-Rueckmeldungen fuer die Pruefung nicht ausreichen. Das als technische Ausnahme dokumentieren, nicht als Default-Ansatz.',
      fallbackFeature.path,
      ['edp', 'fallback', 'test-gap', 'exception'],
      now,
    ));
  }

  return out;
}

function normalizeFopsDocToken(name: string): string {
  return name
    .replace(/\+/g, ' ')
    .replace(/%20/g, ' ')
    .replace(/_/g, ' ')
    .replace(/\.[^.]+$/, '')
    .trim();
}

function decodeHtmlEntities(text: string): string {
  return text
    .replace(/=C3=A4/gi, 'ae')
    .replace(/=C3=B6/gi, 'oe')
    .replace(/=C3=BC/gi, 'ue')
    .replace(/=C3=9F/gi, 'ss')
    .replace(/&uuml;/gi, 'ue')
    .replace(/&ouml;/gi, 'oe')
    .replace(/&auml;/gi, 'ae')
    .replace(/&szlig;/gi, 'ss')
    .replace(/&#39;/g, "'")
    .replace(/&quot;/g, '"')
    .replace(/&amp;/g, '&');
}

function extractFopsTopics(content: string): string[] {
  const out = new Set<string>();
  const normalized = decodeHtmlEntities(content).replace(/=\r?\n/g, '');

  for (const m of normalized.matchAll(/<h[1-3][^>]*>([^<]{4,200})<\/h[1-3]>/gi)) {
    out.add(m[1].trim());
  }
  for (const m of normalized.matchAll(/<li>\s*<a[^>]*>([^<]{4,200})<\/a>\s*<\/li>/gi)) {
    out.add(m[1].trim());
  }

  return Array.from(out)
    .map((t) => t.replace(/\s+/g, ' ').trim())
    .filter((t) => t.length >= 5)
    .filter((t) => !/^date:|^message-id:|^subject:/i.test(t));
}

function isRelevantFopsTopic(topic: string): boolean {
  const t = topic.toLowerCase();
  return /(fop|fo2|infosystem|event|datenbank|cron|formular|review|qualitaet|richtlinie|struktur|einrichtung|coding|programming|debug|policy|trigger|interpreter|sprachunabhaeng)/.test(t);
}

function buildFopsDocKeywords(filePath: string, content: string): string[] {
  const bag = `${filePath} ${decodeHtmlEntities(content).slice(0, 2000)}`.toLowerCase();
  const out: string[] = [];
  const pairs: Array<[string, RegExp]> = [
    ['fop', /\bfop\b/],
    ['fo2', /\bfo2\b/],
    ['codereview', /codereview|code review/],
    ['qualitaet', /qualitaet|quality/],
    ['sprachunabhaengig', /sprachunabh|language-independent/],
    ['formular', /formular|form/],
    ['infosystem', /infosystem/],
    ['cronjob', /cron/],
    ['richtlinie', /richtlinie|policy|guideline/],
    ['eventmodell', /event|evt/],
  ];
  for (const [k, re] of pairs) {
    if (re.test(bag)) out.push(k);
  }
  return out.length > 0 ? out : ['fops', 'dokumentation'];
}

function deriveFopsDocLearnings(files: Array<{ path: string; content: string }>, now: string): LearningEntry[] {
  if (files.length === 0) return [];
  const out: LearningEntry[] = [];
  const names = files.map((f) => f.path.split('/').pop() ?? f.path);
  const normalized = names.map((n) => normalizeFopsDocToken(n).toLowerCase());

  const has = (needle: string) => normalized.some((n) => n.includes(needle));

  if (has('codereview') || has('qualit')) {
    out.push(createFopsDocLearning(
      'fops-doc-codereview-checklist',
      'FOP/Cucu-Aenderungen gegen Qualitaetscheckliste pruefen',
      'Im docs/FOPs-Bestand liegt eine Codereview-/Qualitaetscheckliste vor. Fuer jedes erzeugte Szenario und jede FOP-Anpassung einen Review-Checkpoint fuer Naming, Fehlerpfad, und Seiteneffekte einplanen.',
      'docs/FOPs/Dev+_+Codereview+_+Qualitätscheckliste+für+Programmierung.doc',
      ['codereview', 'qualitaet', 'checkliste', 'fop', 'bdd'],
      now,
    ));
  }

  if (has('sprachunabh')) {
    out.push(createFopsDocLearning(
      'fops-doc-language-independent',
      'Sprachunabhaengige Programmierung als Testkriterium aufnehmen',
      'Die FOP-Dokumente adressieren sprachunabhaengige Programmierung. Szenarien sollten keine sprachabhaengigen Labels voraussetzen und stattdessen technische Felder/IDs pruefen.',
      'docs/FOPs/Dev+_+Programmierrichtlinien+erweitern+(sprachunabhängige+Programmierung).doc',
      ['sprachunabhaengig', 'richtlinie', 'selector', 'ids'],
      now,
    ));
  }

  if (has('formular')) {
    out.push(createFopsDocLearning(
      'fops-doc-form-development',
      'Formularentwicklung als eigener Teststrang modellieren',
      'FOPs enthalten dedizierte Unterlagen fuer Formularentwicklung. Fuer betroffene Arbeitspakete eigene Feature-Szenarien fuer Layout, Pflichtfelder und Druck-/Ausgabeverhalten vorsehen.',
      'docs/FOPs/Dev+_+Programmierrichtlinien+erweitern+(Formularentwicklung).doc',
      ['formular', 'druck', 'ausgabe', 'pflichtfeld'],
      now,
    ));
  }

  if (has('infosystem')) {
    out.push(createFopsDocLearning(
      'fops-doc-infosystem-customizing',
      'Infosystem-Individualisierung mit Trigger-Matrix absichern',
      'In docs/FOPs liegt eine Strukturunterlage zur Individualisierung von Infosystemen. Tests sollten Trigger (button/feldpruef/maskpruef) und Ergebnisfelder in einer Matrix abdecken.',
      'docs/FOPs/3.+Individualisierung+von+Infosystemen.doc',
      ['infosystem', 'individualisierung', 'trigger', 'matrix'],
      now,
    ));
  }

  if (has('cronjob')) {
    out.push(createFopsDocLearning(
      'fops-doc-cronjob-observability',
      'Cronjob-FOPs mit Zeitbezug und Wiederholbarkeit testen',
      'Cronjob-Unterlagen deuten auf zeitgesteuerte Verarbeitung hin. Szenarien sollten idempotente Wiederholung, Laufprotokoll und Fehlerbehandlung bei Folgeausfuehrungen pruefen.',
      'docs/FOPs/4.+Cronjobs.doc',
      ['cronjob', 'idempotenz', 'zeitsteuerung', 'logging'],
      now,
    ));
  }

  if (has('struktur') || has('einrichtung')) {
    out.push(createFopsDocLearning(
      'fops-doc-setup-structure',
      'Projektstruktur und Setup als Vorbedingung standardisieren',
      'Die Doku zu Einrichtung und Struktur in docs/FOPs sollte als feste Given-Basis genutzt werden, damit Generierung und Review in allen Arbeitspaketen auf demselben Fundament laufen.',
      'docs/FOPs/2.+Struktur.doc',
      ['setup', 'struktur', 'given', 'standardisierung'],
      now,
    ));
  }

  const pdfPolicies = files.filter((f) => /policies|richtlinien/i.test(f.path));
  if (pdfPolicies.length > 0) {
    out.push(createFopsDocLearning(
      'fops-doc-policy-bundle',
      'Policy-Dokumente als Gate vor Merge nutzen',
      `Es wurden ${pdfPolicies.length} Policy-Dokumente im FOPs-Ordner gefunden. Vor Freigabe sollte jedes Learning und jede FOP-Generierung gegen diese Policies gegengeprueft werden.`,
      'docs/FOPs',
      ['policy', 'review-gate', 'compliance'],
      now,
    ));
  }

  const topicLearnings = files.map((file, idx) => {
    const base = normalizeFopsDocToken(file.path.split('/').pop() ?? file.path);
    return createFopsDocLearning(
      `fops-doc-topic-${idx + 1}-${base.toLowerCase().replace(/[^a-z0-9]+/g, '-')}`,
      `FOP-Thema aktiv nutzen: ${base}`,
      `Dokument ${base} liegt unter docs/FOPs vor. Fuer neue Cucumber-Szenarien dieses Thema explizit als fachlichen Kontext und Akzeptanzkriterien referenzieren.`,
      file.path,
      ['fops', 'thema', 'arbeitspaket', 'akzeptanzkriterien', ...buildFopsDocKeywords(file.path, file.content)],
      now,
    );
  });

  const perTopicLearnings: LearningEntry[] = [];
  for (const file of files) {
    const base = normalizeFopsDocToken(file.path.split('/').pop() ?? file.path);
    const topics = extractFopsTopics(file.content).filter(isRelevantFopsTopic);
    for (const topic of topics) {
      const key = `${base} ${topic}`.toLowerCase().replace(/[^a-z0-9]+/g, '-');
      perTopicLearnings.push(createFopsDocLearning(
        `fops-doc-detail-${key}`,
        `FOP-Detailregel: ${topic}`,
        `Aus ${base} wurde das Thema "${topic}" erkannt. Dieses Thema als konkrete Regel/Pruefpunkt in Szenarien und Review uebernehmen.`,
        file.path,
        ['fops', 'detailregel', ...buildFopsDocKeywords(file.path, file.content)],
        now,
      ));
    }
  }

  return [...out, ...topicLearnings, ...perTopicLearnings];
}

function createGeneralRuleLearning(
  id: string,
  title: string,
  summary: string,
  sourcePath: string,
  keywords: string[],
  now: string,
  category: LearningEntry['category'] = 'rule',
): LearningEntry {
  return {
    id,
    title,
    summary,
    comment: 'Automatisch aus interner Projektdokumentation abgeleitet.',
    keywords,
    category,
    scope: 'general',
    confirmed: true,
    acceptedCount: 1,
    rejectedCount: 0,
    sourcePath,
    createdAt: now,
    updatedAt: now,
  };
}

function deriveLanguageGuidelineEventInsights(now: string): LearningEntry[] {
  const sourcePath = 'docs/FOPs/Dev+_+Programmierrichtlinien+erweitern+(sprachunabhängige+Programmierung).doc';
  const events = [
    ['maskein', 'Maskeneintritt', 'SCREEN_ENTER', 'SE'],
    ['maskpruef', 'Maskenpruefung', 'SCREEN_VALIDATION', 'SV'],
    ['maskaus', 'Maskenaustritt', 'SCREEN_EXIT', 'SX'],
    ['maskabbr', 'Maskenabbruch', 'SCREEN_CANCEL', 'SC'],
    ['maskende', 'Maskenende', 'SCREEN_END', 'SEE'],
    ['feldfuell', 'Feld ausgefuellt', 'FIELD_FILL', 'FF'],
    ['feldpruef', 'Feldpruefung', 'FIELD_VALIDATION', 'FV'],
    ['feldaus', 'Feldaustritt', 'FIELD_EXIT', 'FX'],
    ['buttonvor', 'Button vor', 'BUTTON_BEFORE', 'BB'],
    ['buttonnach', 'Button nach', 'BUTTON_AFTER', 'BA'],
    ['zeileloevor', 'Zeile loeschen vor', 'ROW_DELETION_BEFORE', 'RDB'],
    ['zeileloenach', 'Zeile loeschen nach', 'ROW_DELETION_AFTER', 'RDA'],
    ['zeileeinvor', 'Zeile einfuegen vor', 'ROW_INSERTION_BEFORE', 'RIB'],
    ['zeileeinnach', 'Zeile einfuegen nach', 'ROW_INSERTION_AFTER', 'RIA'],
    ['zeilebewvor', 'Zeile verschieben vor', 'ROW_MOVED_BEFORE', 'RMB'],
    ['zeilebewnach', 'Zeile verschieben nach', 'ROW_MOVED_AFTER', 'RMA'],
  ] as const;

  return events.map(([token, deLabel, enLabel, shortCode]) => createGeneralRuleLearning(
    `langdoc-event-${token}`,
    `Event-Referenz: ${token} / ${shortCode}`,
    `Das Event ${token} ist in der Sprachunabhaengigkeits-Doku als ${deLabel} (${enLabel}) dokumentiert. Fachlogik fuer diesen Trigger gezielt im passenden Event halten und nicht auf benachbarte Events ausweichen.`,
    sourcePath,
    ['event', token, shortCode.toLowerCase(), 'language-independent'],
    now,
  ));
}

function deriveProjectSectionInsights(now: string): LearningEntry[] {
  const specs: Array<{
    id: string;
    title: string;
    summary: string;
    sourcePath: string;
    keywords: string[];
    category?: LearningEntry['category'];
  }> = [
    {
      id: 'doc-infosystem-section-31',
      title: 'Infosysteme korrekt individualisieren',
      summary: 'Infosystem-Anpassungen nicht nur technisch anbinden, sondern mit sauberer Trigger-/Feld-/Ergebnislogik modellieren und als wiederholbares Vorgehen dokumentieren.',
      sourcePath: 'docs/FOPs/3.+Individualisierung+von+Infosystemen.doc',
      keywords: ['infosystem', 'customizing', 'trigger', 'result'],
    },
    {
      id: 'doc-infosystem-section-32',
      title: 'Infosystem-Besonderheiten separat absichern',
      summary: 'Sonderlogik in Infosystemen als eigene Risiko-Stelle betrachten und nicht in generischen Standardtests verschwinden lassen.',
      sourcePath: 'docs/FOPs/3.+Individualisierung+von+Infosystemen.doc',
      keywords: ['infosystem', 'special-cases', 'risk'],
      category: 'warning',
    },
    {
      id: 'doc-infosystem-obligos',
      title: 'Obligos in Infosystemen mit Spezialtests abdecken',
      summary: 'Obligo-bezogene Infosystem-Logik als Sonderfall behandeln und mit eigenen Negativ-/Grenztests absichern.',
      sourcePath: 'docs/FOPs/3.+Individualisierung+von+Infosystemen.doc',
      keywords: ['infosystem', 'obligos', 'edge-case'],
      category: 'example',
    },
    {
      id: 'doc-cronjob-bind',
      title: 'Cronjob-Einbindung als Liefergegenstand behandeln',
      summary: 'Die Einbindung eines Cronjobs umfasst nicht nur FOP-Logik, sondern auch Betriebseintrag und Ausfuehrungskontext. Das als Gesamtpaket dokumentieren und pruefen.',
      sourcePath: 'docs/FOPs/4.+Cronjobs.doc',
      keywords: ['cronjob', 'binding', 'operations'],
    },
    {
      id: 'doc-cronjob-crontab',
      title: 'Crontab-Eintrag explizit validieren',
      summary: 'Zeitfenster, Benutzerkontext und Pfad im Crontab-Eintrag gehoeren in die Abnahme und duerfen nicht als Betriebsdetail implizit bleiben.',
      sourcePath: 'docs/FOPs/4.+Cronjobs.doc',
      keywords: ['cronjob', 'crontab', 'schedule'],
      category: 'pattern',
    },
    {
      id: 'doc-cronjob-shellscript',
      title: 'Cronjob-Shellscript mit Fehler- und Pfadpruefung absichern',
      summary: 'Shellscripts fuer Cronjobs muessen Pfade, Exitcodes und Logging sauber behandeln, sonst sind Folgefehler schwer reproduzierbar.',
      sourcePath: 'docs/FOPs/4.+Cronjobs.doc',
      keywords: ['cronjob', 'shellscript', 'logging', 'exitcode'],
      category: 'warning',
    },
    {
      id: 'doc-cronjob-testing-section',
      title: 'Cronjobs mit eigenem Testvorgehen pruefen',
      summary: 'Cronjobs brauchen ein explizites Testvorgehen fuer Zeitsteuerung, Wiederholung und Protokollierung statt nur fachlicher Ergebnispruefung.',
      sourcePath: 'docs/FOPs/4.+Cronjobs.doc',
      keywords: ['cronjob', 'testing', 'repeatability'],
      category: 'example',
    },
    {
      id: 'doc-form-correct-customization',
      title: 'Formulare korrekt und getrennt von Fachlogik anpassen',
      summary: 'Formularanpassungen als eigene Disziplin behandeln und Layout-/Ausgabelogik nicht still in Fachlogiktests verstecken.',
      sourcePath: 'docs/FOPs/5.+Formulare.doc',
      keywords: ['forms', 'layout', 'separation'],
    },
    {
      id: 'doc-form-jasper-expressions',
      title: 'Jasper-Expressions gesondert absichern',
      summary: 'Expressions in Jasper-Layouts koennen implizite Berechnungs- und Nullfallfehler erzeugen und brauchen deshalb eigene Tests.',
      sourcePath: 'docs/FOPs/5.+Formulare.doc',
      keywords: ['jasper', 'expressions', 'null-cases'],
      category: 'warning',
    },
    {
      id: 'doc-form-resources',
      title: 'Formular-Ressourcen als deploybare Abhaengigkeit behandeln',
      summary: 'Ressourcenreferenzen in Formularen muessen ueber Umgebungen stabil bleiben und in Deploy-/Abnahmeszenarien vorkommen.',
      sourcePath: 'docs/FOPs/5.+Formulare.doc',
      keywords: ['forms', 'resources', 'deploy'],
      category: 'pattern',
    },
    {
      id: 'doc-project-multisite',
      title: 'Multisite als feste Testdimension aufnehmen',
      summary: 'Multisite-relevante Anpassungen nicht nur im Standardmandanten denken, sondern Site-/Mandantenkontext aktiv pruefen.',
      sourcePath: 'docs/FOPs/6.+Besonderheiten+im+Projekt.doc',
      keywords: ['multisite', 'tenant', 'site'],
      category: 'example',
    },
    {
      id: 'doc-project-product',
      title: 'PRODUCT-Besonderheiten explizit dokumentieren',
      summary: 'Produktbezogene Projektspezifika gehoeren als explizite Annahmen in Learnings und Tests, nicht nur in stilles Teamwissen.',
      sourcePath: 'docs/FOPs/6.+Besonderheiten+im+Projekt.doc',
      keywords: ['product', 'project-specific', 'assumptions'],
    },
    {
      id: 'doc-project-esdk',
      title: 'eSDK Apps als eigene Integrationsschicht behandeln',
      summary: 'Bei eSDK Apps die Integrationsgrenze aktiv pruefen: Datenfluss, Trigger, Rueckgaben und Fehlersituationen separat absichern.',
      sourcePath: 'docs/FOPs/6.+Besonderheiten+im+Projekt.doc',
      keywords: ['esdk', 'integration', 'apps'],
      category: 'warning',
    },
    {
      id: 'doc-project-webapps',
      title: 'Webanwendungen nicht mit klassischer FOP-Logik vermischen',
      summary: 'Webanwendungen haben eigene Interaktions- und Fehlerbilder und brauchen deshalb separate Lern- und Testregeln.',
      sourcePath: 'docs/FOPs/6.+Besonderheiten+im+Projekt.doc',
      keywords: ['webapps', 'integration', 'frontend'],
      category: 'warning',
    },
  ];

  return specs.map((spec) => createGeneralRuleLearning(
    spec.id,
    spec.title,
    spec.summary,
    spec.sourcePath,
    spec.keywords,
    now,
    spec.category,
  ));
}

function createFopsCuratedDefaultLearnings(now: string): LearningEntry[] {
  const mk = (
    id: string,
    title: string,
    summary: string,
    sourcePath: string,
    keywords: string[],
    category: LearningEntry['category'] = 'rule',
  ): LearningEntry => ({
    id,
    title,
    summary,
    comment: 'Kuratiert aus vorhandener FOP-Projektdokumentation.',
    keywords,
    category,
    scope: 'general',
    confirmed: true,
    acceptedCount: 1,
    rejectedCount: 0,
    sourcePath,
    createdAt: now,
    updatedAt: now,
  });

  return [
    mk(
      'fops-curated-env-prerequisites',
      'Vor Umsetzungsstart technische Voraussetzungen vollstaendig herstellen',
      'Vor Implementierung sicherstellen: abas Tools, Frameworks/eSDK Apps, Infosysteme, INI-Dateien, Druckindividualisierung, mandantdir.env und Samba-Freigaben sind vorbereitet und ausgerollt.',
      'docs/FOPs/1.+Einrichtung+Entwicklungsumgebung+im+Projekt.doc',
      ['setup', 'tools', 'esdk', 'ini', 'rollout'],
    ),
    mk(
      'fops-curated-mandant-rollout-chain',
      'Mandantenstruktur entlang erp->demo->entw reproduzierbar ausrollen',
      'Ein konsistenter Rolloutpfad reduziert Umgebungsabweichungen zwischen Entwicklung, Demo und Produktivnaehe und verhindert nicht reproduzierbare Testresultate.',
      'docs/FOPs/1.+Einrichtung+Entwicklungsumgebung+im+Projekt.doc',
      ['mandant', 'erp', 'demo', 'entw', 'reproducible'],
      'pattern',
    ),
    mk(
      'fops-curated-program-naming',
      'Programmbenennung als feste Coding-Policy behandeln',
      'Programmbenennung standardisieren und bei jeder neuen Erweiterung gegen die Strukturvorgaben pruefen, damit Pflege und Suche ueber Arbeitspakete hinweg stabil bleiben.',
      'docs/FOPs/2.+Struktur.doc',
      ['naming', 'struktur', 'policy', 'maintenance'],
    ),
    mk(
      'fops-curated-variable-naming',
      'Variablenbenennung konsequent nach Strukturvorgaben durchziehen',
      'Variablennamen mit klaren Typ-/Bedeutungsmustern anlegen und bei Review-Abnahmen als Pflichtkriterium fuehren.',
      'docs/FOPs/2.+Struktur.doc',
      ['variables', 'naming', 'review', 'readability'],
    ),
    mk(
      'fops-curated-event-model',
      'Eventwahl (SE/SV/SX/SC/SEE/FV/FX/BB/BA) als fachliche Entscheidung dokumentieren',
      'Bei jeder Logik klar begruenden, in welchem Event sie liegt. Falsche Eventwahl erzeugt Seiteneffekte, die in BDD nur schwer aufloesbar sind.',
      'docs/FOPs/2.+Struktur.doc',
      ['event-model', 'se', 'sv', 'fv', 'bb', 'ba'],
      'warning',
    ),
    mk(
      'fops-curated-program-header',
      'Programmkopf als Pflichtmetadatenblock pflegen',
      'Programmkopf mit nachvollziehbaren Angaben (Kontext, Verantwortlichkeit, Zweck) pflegen, damit Reverse Engineering und Review schneller und sauberer funktionieren.',
      'docs/FOPs/2.+Struktur.doc',
      ['programmkopf', 'metadata', 'traceability'],
      'pattern',
    ),
    mk(
      'fops-curated-efop-binding',
      'EFOP-Einbindung bewusst kapseln und dokumentieren',
      'EFOP-Logik so anbinden, dass Trigger, Scope und Abbruchverhalten explizit nachvollziehbar bleiben; inklusive Testfall fuer Trigger und Nicht-Trigger.',
      'docs/FOPs/2.+Struktur.doc',
      ['efop', 'trigger', 'scope', 'documentation'],
    ),
    mk(
      'fops-curated-subprogram-boundaries',
      'Unterprogramme (SUB) fuer klare Verantwortungsgrenzen nutzen',
      'Groessere FOP-Logik in SUBs zerlegen, damit Seiteneffekte lokalisiert bleiben und einzelne Verhaltensbausteine separat getestet werden koennen.',
      'docs/FOPs/2.+Struktur.doc',
      ['sub', 'modularity', 'testability'],
      'pattern',
    ),
    mk(
      'fops-curated-service-fop',
      'Service-FOPs (SER) als wiederverwendbare Dienste modellieren',
      'Service-Logik von UI-Triggern entkoppeln und als stabile Service-FOP bereitstellen, damit Szenarien fachlichen statt technischen Fokus behalten.',
      'docs/FOPs/2.+Struktur.doc',
      ['service-fop', 'ser', 'reuse', 'architecture'],
      'pattern',
    ),
    mk(
      'fops-curated-extend-existing',
      'Bestehende Anpassungen nur erweiternd und regressionssicher anfassen',
      'Beim Erweitern bestehender Anpassungen immer Altverhalten absichern (vorher/nachher) und Konflikte mit Bestandslogik aktiv gegenpruefen.',
      'docs/FOPs/2.+Struktur.doc',
      ['existing', 'regression', 'compatibility'],
      'warning',
    ),
    mk(
      'fops-curated-fo2-structured-programming',
      'FO2 strukturiert und ohne Seiteneffekt-Kaskaden implementieren',
      'In FO2 strukturierte Programmierung mit klaren Kontrollpfaden erzwingen; verschachtelte Seiteneffekte vermeiden.',
      'docs/FOPs/2.+Struktur.doc',
      ['fo2', 'structured', 'control-flow'],
    ),
    mk(
      'fops-curated-language-independent',
      'Sprachunabhaengige Programmierung als Pflicht fuer Selektoren und Trigger',
      'Technische Bezeichner statt sprachabhaengiger Beschriftungen verwenden; insbesondere bei Eventkommandos, Datenbankbezug und Loader-Aktionen.',
      'docs/FOPs/Dev+_+Programmierrichtlinien+erweitern+(sprachunabhängige+Programmierung).doc',
      ['language-independent', 'selectors', 'events', 'databases'],
    ),
    mk(
      'fops-curated-interpreter-line',
      'Interpreterzeile und Konfigurationssprache konsistent halten',
      'Interpreter- und Konfigurationssprache in FOP-Dateien einheitlich halten, damit Batch/Runtime-Ausfuehrung in allen Umgebungen gleich reagiert.',
      'docs/FOPs/Dev+_+Programmierrichtlinien+erweitern+(sprachunabhängige+Programmierung).doc',
      ['interpreter', 'runtime', 'configuration'],
    ),
    mk(
      'fops-curated-batch-user-security',
      'Batch-User/PASSWORT-Handling als Security- und Betriebsregel verankern',
      'EDP/EPI-Ausfuehrungen sollen den vorgesehenen Batch-User-Mechanismus nutzen, damit Rechteprobleme und verdeckte Sicherheitsluecken vermieden werden.',
      'docs/FOPs/2.+Struktur.doc',
      ['batch-user', 'security', 'edp', 'epi'],
      'warning',
    ),
    mk(
      'fops-curated-adjustment-docs',
      'Anpassungen verpflichtend dokumentieren',
      'Jede FOP-Anpassung mit Zweck, Trigger, Datenobjekt und Abnahmekriterien dokumentieren, damit Folgeprojekte und neue Kollegen schnell einsteigen koennen.',
      'docs/FOPs/2.+Struktur.doc',
      ['documentation', 'handover', 'traceability'],
    ),
    mk(
      'fops-curated-infosystem-customization',
      'Infosystem-Individualisierung mit Regelset statt Einzelfix umsetzen',
      'Infosystem-Anpassungen als wiederholbare Regelmatrix aufbauen (Trigger, Feldwirkung, Ergebniskontrolle) statt ad-hoc Korrekturen pro Fall.',
      'docs/FOPs/3.+Individualisierung+von+Infosystemen.doc',
      ['infosystem', 'customization', 'matrix', 'validation'],
    ),
    mk(
      'fops-curated-infosystem-obligos',
      'Obligo-bezogene Infosysteme mit Negativpfaden absichern',
      'Bei Infosystemen mit Obligo-Besonderheiten immer Negativ-/Grenzfaelle testen (fehlende Daten, gesperrte Konstellationen, ungueltige Kombinationen).',
      'docs/FOPs/3.+Individualisierung+von+Infosystemen.doc',
      ['obligo', 'negative-path', 'edge-cases'],
      'warning',
    ),
    mk(
      'fops-curated-cronjob-binding',
      'Cronjob-Einbindung in Crontab und Shellscript gemeinsam reviewen',
      'Cronjobs nur als Gesamtartefakt abnehmen: Crontab-Eintrag, Shellscript, Pfade und Ausfuehrungsrechte muessen zusammenpassen.',
      'docs/FOPs/4.+Cronjobs.doc',
      ['cronjob', 'crontab', 'shellscript', 'operations'],
    ),
    mk(
      'fops-curated-cronjob-testing',
      'Cronjobs mit zeitbezogenen Regressionstests verifizieren',
      'Bei Cronjobs Testfaelle fuer korrekte Zeitsteuerung, Wiederanlauf und Protokollierung definieren; Zeitfenster explizit dokumentieren.',
      'docs/FOPs/4.+Cronjobs.doc',
      ['cronjob', 'testing', 'schedule', 'logging'],
      'example',
    ),
    mk(
      'fops-curated-form-expressions',
      'Jasper-Expressions in Formularen als Risikozone testen',
      'Formularanpassungen mit Fokus auf Expressions testen (Berechnungen, Nullfaelle, Formatierungen), da dort haeufig Laufzeitfehler entstehen.',
      'docs/FOPs/5.+Formulare.doc',
      ['formulare', 'jasper', 'expressions', 'runtime'],
      'warning',
    ),
    mk(
      'fops-curated-form-resources',
      'Formular-Ressourcen zentral und versionssicher verwalten',
      'Ressourcen (Texte, Bilder, Assets) in Formularprojekten konsistent referenzieren, damit Deployments ueber Mandanten stabil funktionieren.',
      'docs/FOPs/5.+Formulare.doc',
      ['formulare', 'resources', 'deployment', 'versioning'],
      'pattern',
    ),
    mk(
      'fops-curated-multisite-awareness',
      'Multisite-Kontext als Pflichtdimension in Tests aufnehmen',
      'Bei Multisite-relevanten Anpassungen mindestens ein Szenario mit Mandanten-/Site-Unterschieden modellieren, um versteckte Dateneffekte zu erkennen.',
      'docs/FOPs/6.+Besonderheiten+im+Projekt.doc',
      ['multisite', 'tenant', 'data-consistency'],
      'example',
    ),
    mk(
      'fops-curated-product-esdk-web',
      'PRODUCT/eSDK/Webanwendungen als Integrationsgrenze behandeln',
      'Wenn FOP-Logik mit PRODUCT, eSDK Apps oder Webanwendungen interagiert, Integrations- und Rueckfallpfade explizit testen.',
      'docs/FOPs/6.+Besonderheiten+im+Projekt.doc',
      ['product', 'esdk', 'webapp', 'integration'],
      'warning',
    ),
    mk(
      'fops-curated-codereview-baseline',
      'Code Reviews als verpflichtender Qualitaets-Gate',
      'Jede relevante FOP-/Cucumber-Aenderung durch Peer-Review mit dokumentierter Bewertung fuehren, inklusive Lernuebernahme in die Wissensbasis.',
      'docs/FOPs/Dev+_+Codereview+_+Qualitätscheckliste+für+Programmierung.doc',
      ['codereview', 'quality-gate', 'peer-review'],
    ),
    mk(
      'fops-curated-codereview-methods',
      'Review-Methode passend zum Aenderungstyp auswaehlen',
      'Je nach Aenderungstyp (Bugfix, Erweiterung, Refactoring) geeignete Review-Methode anwenden, damit Aufwand und Wirksamkeit im Gleichgewicht bleiben.',
      'docs/FOPs/Dev+_+Codereview+_+Qualitätscheckliste+für+Programmierung.doc',
      ['review-method', 'bugfix', 'refactoring', 'efficiency'],
      'pattern',
    ),
    mk(
      'fops-curated-tooling-docs',
      'Umsetzungstools und Tool-Doku als Pflichtreferenz vor Coding nutzen',
      'Vor FOP-/Cucumber-Umsetzung die projektspezifische Dokumentation fuer Tools und Hilfsmittel sichten, damit keine impliziten Betriebsannahmen im Code landen.',
      'docs/FOPs/1.+Einrichtung+Entwicklungsumgebung+im+Projekt.doc',
      ['tooling', 'documentation', 'setup', 'implementation'],
      'pattern',
    ),
    mk(
      'fops-curated-event-commands-language',
      'Eventkommandos nur in definierter Sprachform verwenden',
      'Eventkommandos muessen in der vorgesehenen technischen Schreibweise genutzt werden, damit Mapping in Konfiguration und Laufzeit deckungsgleich bleibt.',
      'docs/FOPs/Dev+_+Programmierrichtlinien+erweitern+(sprachunabhängige+Programmierung).doc',
      ['eventcommands', 'language', 'mapping', 'runtime'],
    ),
    mk(
      'fops-curated-database-addressing',
      'Datenbanken technisch statt sprachlich adressieren',
      'Datenbankbezug ueber stabile technische Kennungen modellieren, nicht ueber sprachabhaengige Lesebezeichner oder UI-Texte.',
      'docs/FOPs/Dev+_+Programmierrichtlinien+erweitern+(sprachunabhängige+Programmierung).doc',
      ['database', 'technical-id', 'language-independent'],
    ),
    mk(
      'fops-curated-file-actions-loader',
      'Dateiaktionen und Loader-Kommandos als Integrationspunkt gesondert testen',
      'Bei Dateiaktionen, Tippkommandos und Loader-Kommandos immer Integrationsszenarien fuer Pfade, Berechtigungen und Fehlerfaelle modellieren.',
      'docs/FOPs/Dev+_+Programmierrichtlinien+erweitern+(sprachunabhängige+Programmierung).doc',
      ['file-actions', 'loader', 'integration', 'permissions'],
      'warning',
    ),
    mk(
      'fops-curated-enumerations',
      'Aufzaehlungen und feste Werte zentral halten',
      'Enumerationen nicht frei im Code verteilen, sondern nachvollziehbar und konsistent verwenden, damit Tests stabile Sollwerte pruefen koennen.',
      'docs/FOPs/Dev+_+Programmierrichtlinien+erweitern+(sprachunabhängige+Programmierung).doc',
      ['enumerations', 'constants', 'consistency'],
      'pattern',
    ),
    mk(
      'fops-curated-units',
      'Einheitenumgang explizit pruefen',
      'Bei Einheiten (Menge, Gewicht, Zeit etc.) Konvertierung, Anzeige und Verarbeitung explizit in Szenarien absichern.',
      'docs/FOPs/Dev+_+Programmierrichtlinien+erweitern+(sprachunabhängige+Programmierung).doc',
      ['units', 'conversion', 'validation'],
      'example',
    ),
    mk(
      'fops-curated-smarttrans',
      'Uebersetzungen ueber SMARTTRANS als Systemgrenze behandeln',
      'Wenn Texte ueber Infosystem SMARTTRANS gepflegt oder gelesen werden, dafuer eigene Szenarien fuer Fallback, Sprache und Konsistenz modellieren.',
      'docs/FOPs/Dev+_+Programmierrichtlinien+erweitern+(sprachunabhängige+Programmierung).doc',
      ['translations', 'smarttrans', 'fallback', 'consistency'],
    ),
    mk(
      'fops-curated-form-print-customizing',
      'Druckindividualisierung getrennt von Fachlogik bewerten',
      'Druck-/Formularanpassungen als eigene Lieferfaehigkeit behandeln und nicht unbemerkt mit fachlicher FOP-Logik vermischen.',
      'docs/FOPs/1.+Einrichtung+Entwicklungsumgebung+im+Projekt.doc',
      ['print', 'customizing', 'separation-of-concerns'],
      'pattern',
    ),
    mk(
      'fops-curated-samba-dependencies',
      'Samba-Freigaben und externe Pfade als Betriebsabhaengigkeit dokumentieren',
      'Externe Shares und Pfade muessen als Deploy-/Testvoraussetzung dokumentiert und vor Ausfuehrung validiert werden.',
      'docs/FOPs/1.+Einrichtung+Entwicklungsumgebung+im+Projekt.doc',
      ['samba', 'paths', 'deployment', 'ops'],
      'warning',
    ),
    mk(
      'fops-curated-advantages-review',
      'Code-Review nicht nur fuer Fehler, sondern fuer Wissensaufbau nutzen',
      'Review-Ergebnisse explizit in Learnings ueberfuehren, damit Teamwissen nicht in einzelnen Diskussionen stecken bleibt.',
      'docs/FOPs/Dev+_+Codereview+_+Qualitätscheckliste+für+Programmierung.doc',
      ['review', 'knowledge-transfer', 'team-learning'],
      'pattern',
    ),
    mk(
      'fops-curated-review-best-practices',
      'Best Practices aus Reviews als wiederkehrende Checkliste verwenden',
      'Wiederkehrende Review-Kriterien in eine feste Checkliste uebernehmen und bei neuen Arbeitspaketen standardmaessig anwenden.',
      'docs/FOPs/Dev+_+Codereview+_+Qualitätscheckliste+für+Programmierung.doc',
      ['best-practices', 'checklist', 'review'],
    ),
    mk(
      'fops-curated-cronjob-comment-contract',
      'Cronjob-Kommentare mit Entwickler, Datum und Arbeitspaket standardisieren',
      'Cronjob-Eintraege so kommentieren, dass Herkunft, Zeitpunkt und Arbeitspaket direkt lesbar sind; das ist fuer Betrieb und Fehlersuche relevant.',
      'docs/FOPs/4.+Cronjobs.doc',
      ['cronjob', 'comment', 'traceability', 'operations'],
      'pattern',
    ),
    mk(
      'fops-curated-webapp-boundaries',
      'Webanwendungen als eigenstaendige Integrationsflaeche testen',
      'Wenn Anpassungen Webanwendungen beruehren, Browser-/Frontend-Verhalten nicht aus FOP-Annahmen ableiten, sondern separat absichern.',
      'docs/FOPs/6.+Besonderheiten+im+Projekt.doc',
      ['webapps', 'integration', 'frontend', 'separation'],
      'warning',
    ),
  ];
}

export function createDefaultLearnings(): LearningEntry[] {
  const now = new Date().toISOString();
  const defaults: LearningEntry[] = [
    {
      id: 'std-fop-english-commands',
      title: 'FOP Richtlinie: Englische Kommandos verwenden',
      summary: 'Verwende .select/.continue/.formula statt lokalisierter Varianten, damit Quelltext konsistent und guideline-konform bleibt.',
      comment: 'Ableitung aus FOP-Richtlinienprompt und bestehenden Reviews.',
      keywords: ['fop', 'guideline', 'english', 'select', 'continue'],
      category: 'rule',
      scope: 'general',
      confirmed: true,
      acceptedCount: 6,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-buffer-prefix',
      title: 'FOP Richtlinie: Buffer-Praefixe erzwingen',
      summary: 'Variablen und Felder stets mit Buffer-Praefix verwenden (U|, M|, H|, D|), keine unpraefixierten Namen.',
      keywords: ['buffer', 'prefix', 'u|', 'm|', 'h|', 'd|'],
      category: 'rule',
      scope: 'general',
      confirmed: true,
      acceptedCount: 8,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-select-success-check',
      title: 'Nach .select immer G|success pruefen',
      summary: 'Nach Datenbankzugriffen muss ein Erfolgspfad und ein Negativpfad vorhanden sein. Das reduziert Laufzeitfehler und verbessert Testabdeckung.',
      keywords: ['select', 'g|success', 'error-path', 'bdd'],
      category: 'warning',
      scope: 'general',
      confirmed: true,
      acceptedCount: 9,
      rejectedCount: 1,
      sourcePath: 'src/lib/fopOrchestrator.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-copy-vs-formula',
      title: '.copy statt .formula bei kompatiblen Typen',
      summary: 'Wenn Quell- und Zieltyp kompatibel sind, .copy verwenden. Das ist performanter und guideline-konform.',
      keywords: ['copy', 'formula', 'performance', 'types'],
      category: 'pattern',
      scope: 'general',
      confirmed: true,
      acceptedCount: 7,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-assign-fault-tolerance',
      title: '.assign fuer fehlertolerante Zuweisungen',
      summary: 'Falls Zuweisungsfehler den Ablauf nicht hart abbrechen sollen, .assign statt .formula einsetzen.',
      keywords: ['assign', 'formula', 'fault-tolerance', 'g|mehr'],
      category: 'pattern',
      scope: 'general',
      confirmed: true,
      acceptedCount: 5,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-efop-bind-star',
      title: 'EFOP auf * binden und nach G|evtkommd filtern',
      summary: 'Anbindung breit halten (*), aber Logik im Code ueber Event- und Kommandofilter eingrenzen.',
      keywords: ['efop', 'binding', 'evtkommd', 'event'],
      category: 'rule',
      scope: 'general',
      confirmed: true,
      acceptedCount: 6,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-language-independent-selectors',
      title: 'Selektoren sprachunabhaengig halten',
      summary: 'In Selektionsstrings und Parametern auf sprachunabhaengige Tokens achten (z. B. filingmode Active).',
      keywords: ['selector', 'filingmode', 'active', 'language-independent'],
      category: 'rule',
      scope: 'general',
      confirmed: true,
      acceptedCount: 4,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-bdd-branch-coverage',
      title: 'BDD Crosscheck: pro Branch ein Szenario',
      summary: 'if/else, Dialogentscheidungen und .end 1-Pfade jeweils separat testen, damit Fachlogik reproduzierbar dokumentiert ist.',
      keywords: ['bdd', 'scenario', 'if/else', 'end 1', 'dialog'],
      category: 'example',
      scope: 'general',
      confirmed: true,
      acceptedCount: 8,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-noabbrev-interpreter',
      title: 'Interpreterzeile mit noabbrev verpflichtend',
      summary: 'FOP-Quellen sollen in der ersten Zeile den Interpreter inkl. noabbrev tragen, um Kurzformen und Mehrdeutigkeiten zu vermeiden.',
      keywords: ['interpreter', 'noabbrev', 'fo2'],
      category: 'rule',
      scope: 'general',
      confirmed: true,
      acceptedCount: 6,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-complete-selection',
      title: 'Selektionsstrings vollstaendig halten',
      summary: 'Bei .select sollten @group/@filingmode/@rows explizit enthalten sein, damit Verhalten stabil und reproduzierbar bleibt.',
      keywords: ['select', '@group', '@filingmode', '@rows'],
      category: 'rule',
      scope: 'general',
      confirmed: true,
      acceptedCount: 7,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-end1-semantic',
      title: '.end 1 immer als Abbruchpfad dokumentieren',
      summary: 'Wenn .end 1 verwendet wird, muss der fachliche Grund und der Ausloese-Kontext klar beschrieben und getestet sein.',
      keywords: ['.end 1', 'validation', 'abort', 'event'],
      category: 'warning',
      scope: 'general',
      confirmed: true,
      acceptedCount: 7,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-error-field',
      title: 'Feldfehler ueber .error -field verorten',
      summary: 'Validierungsfehler sollten feldbezogen ausgegeben werden, damit Anwender unmittelbares Feedback auf den Eingabekontext bekommen.',
      keywords: ['.error', 'field', 'validation'],
      category: 'pattern',
      scope: 'general',
      confirmed: true,
      acceptedCount: 5,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-edp-mode',
      title: 'EDP-Aufrufe nur mit FOPMODE=1',
      summary: 'Bei EDP-Import/Export muss FOPMODE=1 gesetzt sein, damit EFOP-Logik aktiv bleibt und Business-Regeln nicht umgangen werden.',
      keywords: ['edp', 'fopmode=1', 'import', 'export'],
      category: 'rule',
      scope: 'general',
      confirmed: true,
      acceptedCount: 6,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-event-semantics',
      title: 'SE/SV/FV/FX semantisch sauber trennen',
      summary: 'SE fuer Vorbelegung, SV fuer Speichervalidierung, FV fuer Feldpruefung, FX fuer Folgebelegung. Keine Vermischung der Verantwortlichkeiten.',
      keywords: ['se', 'sv', 'fv', 'fx', 'event-model'],
      category: 'rule',
      scope: 'general',
      confirmed: true,
      acceptedCount: 9,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-box-yes-no-tests',
      title: 'Dialogentscheidungen doppelt testen',
      summary: 'Wenn .box mit Yes/No genutzt wird, immer beide Entscheidungen als separate Szenarien modellieren.',
      keywords: ['.box', 'yes/no', 'bdd', 'scenario'],
      category: 'example',
      scope: 'general',
      confirmed: true,
      acceptedCount: 5,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-logging-scope',
      title: 'Protokolle nur in tmp/rmtmp',
      summary: 'Logging-Ausgaben nur in temporaeren Verzeichnissen halten, keine persistenten Mandantenpfade nutzen.',
      keywords: ['logging', 'tmp', 'rmtmp', 'guideline'],
      category: 'rule',
      scope: 'general',
      confirmed: true,
      acceptedCount: 4,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-variable-naming',
      title: 'Variablen-Praefixe nach Typ verwenden',
      summary: 'xt/xi/xr/xb/xd/xv/xp konsistent einsetzen, damit Typ und Verwendungsabsicht im Code sofort erkennbar sind.',
      keywords: ['naming', 'xt', 'xi', 'xr', 'xb', 'xd', 'xv', 'xp'],
      category: 'pattern',
      scope: 'general',
      confirmed: true,
      acceptedCount: 6,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-fop-bdd-rewrite-screen',
      title: '.rewrite screen als Persistenzschritt testen',
      summary: 'Bei .rewrite screen sollte mindestens ein End-to-End-Szenario den Schreibvorgang und den Ergebniseffekt validieren.',
      keywords: ['rewrite screen', 'persist', 'bdd'],
      category: 'example',
      scope: 'general',
      confirmed: true,
      acceptedCount: 4,
      rejectedCount: 0,
      sourcePath: 'src/lib/fopAgentPrompt.ts',
      createdAt: now,
      updatedAt: now,
    },
    ...createFopsCuratedDefaultLearnings(now),
  ];

  // Merge entries from the editable default-learnings.json (deduped by id).
  const existingIds = new Set(defaults.map((e) => e.id));
  const fromJson = (defaultLearningsJson as Array<Partial<LearningEntry>>)
    .flatMap((raw) => {
      const e = normalizeEntry(raw);
      if (!e || existingIds.has(e.id)) return [];
      return [{ ...e, createdAt: e.createdAt || now, updatedAt: e.updatedAt || now }];
    });

  return [...defaults, ...fromJson];
}

async function scanReferencePath(
  dir: FileSystemDirectoryHandle,
  prefix: string,
  out: Array<{ path: string; content: string }>,
): Promise<void> {
  for await (const [name, handle] of dir.entries()) {
    const rel = prefix ? `${prefix}/${name}` : name;
    if (handle.kind === 'directory') {
      if (name.startsWith('.') || name.toLowerCase() === 'node_modules') continue;
      await scanReferencePath(await dir.getDirectoryHandle(name), rel, out);
      continue;
    }
    if (!isAllowedReferenceFile(name)) continue;
    const file = await (handle as FileSystemFileHandle).getFile();
    const text = await file.text();
    if (!text.trim()) continue;
    out.push({ path: rel, content: text });
  }
}

export async function importReferenceExamplesFromWorkspacePath(
  rootHandle: FileSystemDirectoryHandle,
  relativePath: string,
  existingEntries: LearningEntry[],
): Promise<{ entries: LearningEntry[]; imported: number }> {
  const clean = relativePath.trim().replace(/\\/g, '/').replace(/^\/+|\/+$/g, '');
  if (!clean) return { entries: existingEntries, imported: 0 };

  let cursor: FileSystemDirectoryHandle = rootHandle;
  for (const part of clean.split('/')) {
    if (!part) continue;
    cursor = await cursor.getDirectoryHandle(part);
  }

  const files: Array<{ path: string; content: string }> = [];
  await scanReferencePath(cursor, clean, files);

  const now = new Date().toISOString();
  const imported = files.map((f) => createReferenceLearning(f.path, f.content, now));
  return { entries: mergeLearnings(existingEntries, imported), imported: imported.length };
}

export async function importReferenceExamplesFromDirectoryHandle(
  directoryHandle: FileSystemDirectoryHandle,
  sourceLabel: string,
  existingEntries: LearningEntry[],
): Promise<{ entries: LearningEntry[]; imported: number }> {
  const cleanLabel = sourceLabel.trim().replace(/\\/g, '/').replace(/^\/+|\/+$/g, '') || directoryHandle.name;
  const files: Array<{ path: string; content: string }> = [];
  await scanReferencePath(directoryHandle, cleanLabel, files);
  const now = new Date().toISOString();
  const imported = files.map((f) => createReferenceLearning(f.path, f.content, now));
  return { entries: mergeLearnings(existingEntries, imported), imported: imported.length };
}

export async function importWorkspaceDataLearnings(
  rootHandle: FileSystemDirectoryHandle,
  existingEntries: LearningEntry[],
  options?: { importOnlyNew?: boolean },
): Promise<WorkspaceDataImportResult> {
  const now = new Date().toISOString();
  const generated: LearningEntry[] = [
    ...deriveLanguageGuidelineEventInsights(now),
    ...deriveProjectSectionInsights(now),
  ];
  const sourceStats: WorkspaceImportSourceStat[] = [];
  const importOnlyNew = options?.importOnlyNew ?? false;

  const fopText = await tryReadRelativeFile(rootHandle, 'docs/CucumberDaten/fop.txt');
  let fopScanned = 0;
  let fopGenerated = 0;
  if (fopText) {
    fopScanned = fopText.split(/\r?\n/).filter((line) => {
      const clean = line.trim();
      return clean.length > 0 && !clean.startsWith('#');
    }).length;
    const entry = deriveFopConfigInsight(fopText, now);
    if (entry) generated.push(entry);
    const detailEntries = deriveFopConfigDetailInsights(fopText, now);
    generated.push(...detailEntries);
    fopGenerated = (entry ? 1 : 0) + detailEntries.length;
  }
  sourceStats.push({ source: 'fop', scanned: fopScanned, generated: fopGenerated });

  const infosystemText = await tryReadRelativeFile(rootHandle, 'docs/CucumberDaten/infosysteme.txt');
  let infosystemRows = 0;
  let infosystemGenerated = 0;
  if (infosystemText) {
    infosystemRows = Math.max(0, infosystemText.split(/\r?\n/).filter(Boolean).length - 1);
    const entry = deriveInfosystemInsight(infosystemText, now);
    if (entry) generated.push(entry);
    const detailEntries = deriveInfosystemColumnInsights(infosystemText, now);
    generated.push(...detailEntries);
    infosystemGenerated = (entry ? 1 : 0) + detailEntries.length;
  }
  sourceStats.push({ source: 'infosysteme', scanned: infosystemRows, generated: infosystemGenerated });

  const variableTableText = await tryReadRelativeFile(rootHandle, 'docs/CucumberDaten/variablentabelle.txt');
  let variableRows = 0;
  let variableGenerated = 0;
  if (variableTableText) {
    variableRows = Math.max(0, variableTableText.split(/\r?\n/).filter(Boolean).length - 1);
    const entry = deriveVariableTableInsight(variableTableText, now);
    if (entry) generated.push(entry);
    const detailEntries = deriveVariablePrefixInsights(variableTableText, now);
    generated.push(...detailEntries);
    variableGenerated = (entry ? 1 : 0) + detailEntries.length;
  }
  sourceStats.push({ source: 'variablentabelle', scanned: variableRows, generated: variableGenerated });

  const customStepsDir = await tryGetRelativeDirectory(rootHandle, 'docs/CustomSteps');
  let customStepScanned = 0;
  if (customStepsDir) {
    const customStepFiles: Array<{ path: string; content: string }> = [];
    await collectFilesRecursive(customStepsDir, 'docs/CustomSteps', 20, (name) => name.toLowerCase().endsWith('.java'), customStepFiles);
    customStepScanned = customStepFiles.length;
    const entry = deriveCustomStepsInsight(customStepFiles, now);
    if (entry) generated.push(entry);
  }
  sourceStats.push({ source: 'customsteps', scanned: customStepScanned, generated: customStepScanned > 0 ? 1 : 0 });

  const fopExamplesDir = await tryGetRelativeDirectory(rootHandle, 'docs/CucumberDaten/fops');
  let fopExampleScanned = 0;
  let fopExampleGenerated = 0;
  if (fopExamplesDir) {
    const fopExampleFiles: Array<{ path: string; content: string }> = [];
    await collectFilesRecursive(fopExamplesDir, 'docs/CucumberDaten/fops', 2000, (name) => isLikelyTextFopCorpusFile(name), fopExampleFiles);
    fopExampleScanned = fopExampleFiles.length;
    const commandLearnings = deriveFopCommandReferenceInsights(fopExampleFiles, now);
    fopExampleGenerated = commandLearnings.length;
    generated.push(...commandLearnings);
  }

  const cucumberDir = await tryGetRelativeDirectory(rootHandle, 'docs/cucumber');
  let featureScanned = 0;
  let featureGenerated = 0;
  if (cucumberDir) {
    const featureFiles: Array<{ path: string; content: string }> = [];
    await collectFilesRecursive(cucumberDir, 'docs/cucumber', 30, (name) => name.toLowerCase().endsWith('.feature'), featureFiles);
    featureScanned = featureFiles.length;
    const entry = deriveFeatureCorpusInsight(featureFiles, now);
    if (entry) generated.push(entry);
    const edpLearnings = deriveEdpReferenceInsights(featureFiles, now);
    featureGenerated = (entry ? 1 : 0) + edpLearnings.length;
    generated.push(...edpLearnings);
  }
  sourceStats.push({ source: 'features', scanned: featureScanned, generated: featureGenerated });

  const extractedDir = await tryGetRelativeDirectory(rootHandle, 'docs/extracted');
  let extractedScanned = 0;
  let extractedGenerated = 0;
  if (extractedDir) {
    const extractedFiles: Array<{ path: string; content: string }> = [];
    await collectFilesRecursive(extractedDir, 'docs/extracted', 200, (name) => name.toLowerCase().endsWith('.txt'), extractedFiles);
    extractedScanned = extractedFiles.length;
    const extractedLearnings = deriveExtractedDocInsights(extractedFiles, now);
    extractedGenerated = extractedLearnings.length;
    generated.push(...extractedLearnings);
  }
  sourceStats.push({ source: 'extracted', scanned: extractedScanned, generated: extractedGenerated });

  const pdfSources: Array<{ basePath: string; handle: FileSystemDirectoryHandle | null }> = [
    { basePath: 'docs', handle: await tryGetRelativeDirectory(rootHandle, 'docs') },
    { basePath: 'docs/FOPs', handle: await tryGetRelativeDirectory(rootHandle, 'docs/FOPs') },
  ];
  let pdfScanned = 0;
  let pdfGenerated = 0;
  const pdfFiles: Array<{ path: string; file: File }> = [];
  for (const source of pdfSources) {
    if (!source.handle) continue;
    await collectPdfFilesRecursive(source.handle, source.basePath, 40, pdfFiles);
  }
  if (pdfFiles.length > 0) {
    const uniquePdfFiles = Array.from(new Map(pdfFiles.map((file) => [file.path, file])).values());
    pdfScanned = uniquePdfFiles.length;
    const pdfLearnings = await derivePdfInsights(uniquePdfFiles, now);
    pdfGenerated = pdfLearnings.length;
    generated.push(...pdfLearnings);
  }
  sourceStats.push({ source: 'pdfs', scanned: pdfScanned, generated: pdfGenerated });

  const fopsDir = await tryGetRelativeDirectory(rootHandle, 'docs/FOPs');
  let fopsDocsScanned = 0;
  let fopsDocsGenerated = 0;
  if (fopsDir) {
    const fopsDocs: Array<{ path: string; content: string }> = [];
    await collectFilesRecursive(
      fopsDir,
      'docs/FOPs',
      500,
      (name) => /\.(doc|pdf|txt|md)$/i.test(name),
      fopsDocs,
    );
    fopsDocsScanned = fopsDocs.length;
    const fopsLearnings = deriveFopsDocLearnings(fopsDocs, now);
    fopsDocsGenerated = fopsLearnings.length;
    generated.push(...fopsLearnings);
  }
  sourceStats.push({ source: 'fopsdocs', scanned: fopsDocsScanned, generated: fopsDocsGenerated });

  const fopStat = sourceStats.find((entry) => entry.source === 'fop');
  if (fopStat) {
    fopStat.scanned += fopExampleScanned;
    fopStat.generated += fopExampleGenerated;
  }

  const existingIds = new Set(existingEntries.map((e) => e.id));
  const added = generated.filter((e) => !existingIds.has(e.id)).length;
  const updated = generated.length - added;

  const incoming = importOnlyNew ? generated.filter((e) => !existingIds.has(e.id)) : generated;
  const merged = mergeLearnings(existingEntries, incoming);

  return {
    entries: merged,
    imported: incoming.length,
    added,
    updated: importOnlyNew ? 0 : updated,
    sourceStats,
  };
}

export async function importReferenceExamplesFromFileList(
  files: File[],
  existingEntries: LearningEntry[],
): Promise<{ entries: LearningEntry[]; imported: number }> {
  const now = new Date().toISOString();
  const imported: LearningEntry[] = [];
  for (const file of files) {
    if (!isAllowedReferenceFile(file.name)) continue;
    const text = await file.text();
    if (!text.trim()) continue;
    const relative = (file as File & { webkitRelativePath?: string }).webkitRelativePath || file.name;
    imported.push(createReferenceLearning(relative, text, now));
  }
  return { entries: mergeLearnings(existingEntries, imported), imported: imported.length };
}

function normalizeEntry(input: Partial<LearningEntry>): LearningEntry | null {
  if (!input.title || !input.summary) return null;
  const now = new Date().toISOString();
  const id = (input.id && input.id.trim()) || crypto.randomUUID();
  const inferUsage = (): NonNullable<LearningEntry['usage']> => {
    if (input.usage === 'tests' || input.usage === 'programs' || input.usage === 'both' || input.usage === 'tests-global') return input.usage;
    if ((input as { usage?: string }).usage === 'concept') return 'programs';
    return 'programs';
  };

  return {
    id,
    title: input.title.trim(),
    summary: input.summary.trim(),
    comment: input.comment?.trim() || undefined,
    keywords: Array.isArray(input.keywords)
      ? input.keywords.map((k) => k.trim()).filter(Boolean)
      : [],
    category: input.category ?? 'pattern',
    scope: input.scope ?? 'customer',
    usage: inferUsage(),
    confirmed: input.confirmed ?? true,
    acceptedCount: Math.max(0, input.acceptedCount ?? 0),
    rejectedCount: Math.max(0, input.rejectedCount ?? 0),
    sourcePath: input.sourcePath?.trim() || undefined,
    createdAt: input.createdAt ?? now,
    updatedAt: input.updatedAt ?? now,
  };
}

function rankLearning(entry: LearningEntry): number {
  const now = Date.now();
  const updatedAt = Date.parse(entry.updatedAt);
  const ageDays = Number.isNaN(updatedAt) ? 365 : Math.max(0, (now - updatedAt) / (1000 * 60 * 60 * 24));
  const freshness = Math.max(0, 18 - Math.min(18, ageDays / 3));
  const categoryWeight = entry.category === 'rule' ? 8 : entry.category === 'warning' ? 6 : entry.category === 'pattern' ? 4 : 3;
  const confirmationWeight = entry.confirmed ? 10 : 1;
  const keywordWeight = Math.min(5, entry.keywords.length);
  const feedbackWeight = Math.max(0, (entry.acceptedCount ?? 0) * 2 - (entry.rejectedCount ?? 0));
  const sourceWeight = entry.scope === 'customer' ? 4 : 2;
  return confirmationWeight + categoryWeight + keywordWeight + freshness + feedbackWeight + sourceWeight;
}

function anonymizeText(text: string): string {
  return text
    .replace(/"[^"\n]{2,}"/g, '"<text>"')
    .replace(/\b\d{4,}\b/g, '<num>')
    .replace(/[A-Za-z]:\\[^\s]+/g, '<path>')
    .replace(/\b(ow)?[a-z]{2,}\/[^\s,;]+/gi, '<artifact>');
}

function buildKeywordIndex(entries: LearningEntry[], maxKeywords = 14): string {
  const counts = new Map<string, number>();
  for (const entry of entries) {
    for (const raw of entry.keywords) {
      const k = raw.trim().toLowerCase();
      if (!k) continue;
      counts.set(k, (counts.get(k) ?? 0) + 1);
    }
  }
  const top = Array.from(counts.entries())
    .sort((a, b) => b[1] - a[1])
    .slice(0, maxKeywords)
    .map(([k, n]) => `${k}(${n})`);
  return top.join(', ');
}

function sortByPriority(entries: LearningEntry[]): LearningEntry[] {
  return [...entries].sort((a, b) => {
    const diff = rankLearning(b) - rankLearning(a);
    if (diff !== 0) return diff;
    return a.updatedAt < b.updatedAt ? 1 : -1;
  });
}

export function parseLearningsMarkdown(markdown: string): LearningEntry[] {
  const match = JSON_BLOCK_RE.exec(markdown);
  if (!match) return [];
  try {
    const parsed = JSON.parse(match[1]);
    if (!Array.isArray(parsed)) return [];
    const out: LearningEntry[] = [];
    for (const item of parsed) {
      if (!item || typeof item !== 'object') continue;
      const normalized = normalizeEntry(item as Partial<LearningEntry>);
      if (normalized) out.push(normalized);
    }
    return out;
  } catch {
    return [];
  }
}

export function serializeLearningsMarkdown(entries: LearningEntry[]): string {
  const sorted = sortByPriority(entries);
  const preview = sorted.slice(0, 20);
  const lines: string[] = [
    '# Cucumbergenerator Learnings',
    '',
    'Lokale Wissensbasis fuer bestaetigte KI-Learnings pro Workspace.',
    `Stand: ${new Date().toISOString()}`,
    '',
    '## Kurzuebersicht',
    ...preview.map((e) => `- [${e.category}] ${e.title} (${e.confirmed ? 'confirmed' : 'draft'})`),
    '',
    '## Daten (maschinell)',
    '```json',
    JSON.stringify(sorted, null, 2),
    '```',
    '',
  ];
  return lines.join('\n');
}

async function getSettingsDir(rootHandle: FileSystemDirectoryHandle): Promise<FileSystemDirectoryHandle> {
  return rootHandle.getDirectoryHandle(SETTINGS_DIR_NAME, { create: true });
}

async function getSharedSettingsDir(): Promise<FileSystemDirectoryHandle | null> {
  const handle = await loadSharedSettingsDirectoryHandle();
  if (!handle) return null;
  try {
    const hasPermission = await verifyPermission(handle);
    if (!hasPermission) return null;
    return handle;
  } catch {
    return null;
  }
}

export async function loadWorkspaceLearnings(rootHandle: FileSystemDirectoryHandle): Promise<LearningEntry[]> {
  try {
    const settingsDir = await getSettingsDir(rootHandle);
    const fileHandle = await settingsDir.getFileHandle(LEARNINGS_FILE_NAME);
    const file = await fileHandle.getFile();
    return parseLearningsMarkdown(await file.text());
  } catch {
    return [];
  }
}

export async function loadWorkspaceDefaultLearnings(rootHandle: FileSystemDirectoryHandle): Promise<LearningEntry[]> {
  try {
    const settingsDir = await getSettingsDir(rootHandle);
    const fileHandle = await settingsDir.getFileHandle(DEFAULT_LEARNINGS_JSON_FILE);
    const file = await fileHandle.getFile();
    const text = await file.text();
    const parsed = JSON.parse(text);
    if (!Array.isArray(parsed)) return [];

    const out: LearningEntry[] = [];
    for (const item of parsed) {
      if (!item || typeof item !== 'object') continue;
      const normalized = normalizeEntry(item as Partial<LearningEntry>);
      if (normalized) out.push(normalized);
    }
    return sortByPriority(out);
  } catch {
    return [];
  }
}

export async function saveWorkspaceLearnings(rootHandle: FileSystemDirectoryHandle, entries: LearningEntry[]): Promise<void> {
  const settingsDir = await getSettingsDir(rootHandle);
  const fileHandle = await settingsDir.getFileHandle(LEARNINGS_FILE_NAME, { create: true });
  const writable = await fileHandle.createWritable();
  await writable.write(serializeLearningsMarkdown(entries));
  await writable.close();
}

export async function loadSharedLearnings(): Promise<LearningEntry[]> {
  try {
    const settingsDir = await getSharedSettingsDir();
    if (!settingsDir) return [];
    const fileHandle = await settingsDir.getFileHandle(SHARED_LEARNINGS_FILE_NAME);
    const file = await fileHandle.getFile();
    return parseLearningsMarkdown(await file.text());
  } catch {
    return [];
  }
}

export async function saveSharedLearnings(entries: LearningEntry[]): Promise<void> {
  const settingsDir = await getSharedSettingsDir();
  if (!settingsDir) return;
  const fileHandle = await settingsDir.getFileHandle(SHARED_LEARNINGS_FILE_NAME, { create: true });
  const writable = await fileHandle.createWritable();
  await writable.write(serializeLearningsMarkdown(entries));
  await writable.close();
}

export async function loadSharedSettingsJson(): Promise<string | null> {
  try {
    const settingsDir = await getSharedSettingsDir();
    if (!settingsDir) return null;
    // Try current name first, fall back to legacy name for existing folders.
    for (const name of [SHARED_SETTINGS_JSON_FILE, LEGACY_SETTINGS_JSON_FILE]) {
      try {
        const fileHandle = await settingsDir.getFileHandle(name);
        const file = await fileHandle.getFile();
        return await file.text();
      } catch {
        // try next
      }
    }
    return null;
  } catch {
    return null;
  }
}

export async function saveSharedSettingsJson(): Promise<void> {
  const settingsDir = await getSharedSettingsDir();
  if (!settingsDir) return;
  const fileHandle = await settingsDir.getFileHandle(SHARED_SETTINGS_JSON_FILE, { create: true });
  const writable = await fileHandle.createWritable();
  await writable.write(exportAppSettingsJson());
  await writable.close();
}

// ── AI Prompt Log ──────────────────────────────────────────────

export const AI_PROMPT_LOG_FILE = 'ai-prompt-log.jsonl';
const MAX_LOG_LINES = 200;

export interface AiPromptLogEntry {
  /** ISO timestamp */
  ts: string;
  /** Workflow phase / purpose (e.g. 'gherkin-generation', 'table-identification') */
  phase: string;
  /** Feature/item name */
  item?: string;
  /** The full effective text passed to the prompt (may include learningHints appended) */
  effectiveTextSnippet: string;
  /** The raw learning hints block as passed to generatePackage */
  learningHints?: string;
  /** Keywords extracted from learningHints for quick inspection */
  learningKeywords?: string[];
  /** The final assembled user prompt sent to the AI */
  promptSnippet: string;
  /** Length of the prompt in characters */
  promptLength: number;
  /** Tables identified as relevant */
  relevantTables?: string[];
  /** AI response snippet (first 500 chars) */
  responseSnippet?: string;
}

/**
 * Append a single log entry to ai-prompt-log.jsonl in the settings directory.
 * Silently ignores any filesystem errors.
 */
export async function appendAiPromptLog(
  rootHandle: FileSystemDirectoryHandle,
  entry: AiPromptLogEntry,
): Promise<void> {
  try {
    const settingsDir = await getSettingsDir(rootHandle);
    const fileHandle = await settingsDir.getFileHandle(AI_PROMPT_LOG_FILE, { create: true });

    // Read existing content to enforce line limit
    let existingLines: string[] = [];
    try {
      const file = await fileHandle.getFile();
      const text = await file.text();
      existingLines = text.split('\n').filter((l) => l.trim().length > 0);
    } catch {
      // File empty or not yet readable — start fresh
    }

    const newLine = JSON.stringify(entry);
    const allLines = [...existingLines, newLine];
    const trimmed = allLines.slice(-MAX_LOG_LINES);

    const writable = await fileHandle.createWritable();
    await writable.write(trimmed.join('\n') + '\n');
    await writable.close();
  } catch {
    // Fire-and-forget: never block the main flow on logging errors
  }
}

/**
 * Extract keywords array from a learningHints string.
 * Looks for the "Index-Schlagwoerter:" line produced by buildLearningPromptHints.
 */
export function extractKeywordsFromHints(hints: string): string[] {
  const match = hints.match(/Index-Schlagwoerter:\s*(.+)/i);
  if (!match) return [];
  return match[1].split(',').map((k) => k.trim()).filter(Boolean);
}

export function mergeLearnings(existing: LearningEntry[], incoming: LearningEntry[]): LearningEntry[] {
  const merged = new Map<string, LearningEntry>();
  for (const e of existing) merged.set(e.id, e);
  for (const item of incoming) {
    const normalized = normalizeEntry(item);
    if (!normalized) continue;
    const prev = merged.get(normalized.id);
    if (!prev) {
      merged.set(normalized.id, normalized);
      continue;
    }
    merged.set(normalized.id, (prev.updatedAt > normalized.updatedAt ? prev : normalized));
  }
  return sortByPriority(Array.from(merged.values()));
}

export function buildLearningPromptHints(
  entries: LearningEntry[],
  maxChars = 2400,
  mode: LearningCrosscheckMode = 'customer-plus-general',
  target: 'tests' | 'programs' | 'both' = 'both',
): string {
  if (entries.length === 0) return '';

  const clip = (text: string, max = 320): string => {
    const clean = text.trim();
    if (clean.length <= max) return clean;
    return `${clean.slice(0, Math.max(40, max - 4))} ...`;
  };

  const appliesToTarget = (entry: LearningEntry): boolean => {
    const usage = entry.usage ?? 'both';
    if (target === 'both') return true;
    if (target === 'tests') return usage === 'both' || usage === 'tests' || usage === 'tests-global';
    return usage === 'both' || usage === target;
  };

  // Global rules are explicitly marked via usage=tests-global.
  // They are always included for test generation independent of crosscheck routing.
  const globalRules = target !== 'programs'
    ? sortByPriority(entries.filter((e) => e.usage === 'tests-global' && e.confirmed))
    : [];

  const scopedEntries = entries.filter(appliesToTarget);
  if (scopedEntries.length === 0 && globalRules.length === 0) return '';
  const confirmed = scopedEntries.filter((e) => e.confirmed);
  const base = confirmed.length > 0 ? confirmed : scopedEntries;
  const customer = sortByPriority(base.filter((e) => e.scope !== 'general'));
  const general = sortByPriority(base.filter((e) => e.scope === 'general'));

  const contextSelected = mode === 'customer-only'
    ? customer
    : [...customer.slice(0, 10), ...general.slice(0, 5)];

  // De-duplicate context learnings against always-sent global rules.
  const globalIds = new Set(globalRules.map((r) => r.id));
  const selected = contextSelected.filter((entry) => !globalIds.has(entry.id));

  const lines: string[] = [
    `Workspace-Learnings (${mode === 'customer-only' ? 'customer-only' : 'customer-plus-general'} | target=${target}):`,
  ];

  const keywordIndex = buildKeywordIndex([...globalRules, ...selected]);
  if (keywordIndex) {
    lines.push(`Index-Schlagwoerter: ${keywordIndex}`);
  }

  if (globalRules.length > 0) {
    lines.push('Globale Regeln (immer anwenden):');
    for (const e of globalRules) {
      const kw = e.keywords.length ? ` | kw: ${e.keywords.slice(0, 4).join(', ')}` : '';
      const usage = e.usage ?? 'both';
      const summary = clip(anonymizeText(e.summary), 420);
      const title = clip(anonymizeText(e.title), 120);
      lines.push(`- [${e.category}/${e.scope}/${usage}] ${title}: ${summary}${kw}`);
      if (lines.join('\n').length > maxChars) {
        lines.pop();
        break;
      }
    }
  }

  lines.push('Priorisierte Kontext-Regeln/Patterns:');

  for (const e of selected) {
    const kw = e.keywords.length ? ` | kw: ${e.keywords.slice(0, 4).join(', ')}` : '';
    const src = e.scope === 'customer' && e.sourcePath ? ` | source: ${e.sourcePath}` : '';
    const usage = e.usage ?? 'both';
    const summary = e.scope === 'general' ? clip(anonymizeText(e.summary), 320) : clip(e.summary, 320);
    const title = e.scope === 'general' ? clip(anonymizeText(e.title), 110) : clip(e.title, 110);
    lines.push(`- [${e.category}/${e.scope}/${usage}] ${title}: ${summary}${kw}${src}`);
    if (e.comment) {
      const c = e.scope === 'general' ? anonymizeText(e.comment) : e.comment;
      lines.push(`  Kommentar: ${clip(c, 220)}`);
    }

    if (lines.join('\n').length > maxChars) {
      lines.pop();
      break;
    }
  }

  return lines.join('\n');
}
