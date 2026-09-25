/**
 * @module csvTableParser
 * Parses abas ERP variable-table exports (XLSX, tab-separated text, or simple CSV)
 * into the application's internal `TableDef` data model.
 *
 * Key responsibilities: handles both the legacy 9-column and current 11-column abas
 * export formats, normalises database and infosystem rows into
 * `TableDef[]`, deduplicates fields, merges multiple imports, and persists/loads
 * the result via IndexedDB (with a one-time localStorage migration).
 *
 * @exports parseXlsx, parseTextDump, parseTableCsv, mergeTableDefs,
 *          saveTableDefs, loadTableDefs, clearTableDefs,
 *          migrateTableDefsFromLocalStorage
 */
import * as XLSX from 'xlsx';
import type { TableDef } from '../types/gherkin';
import type { KBChunk, KBDocument } from '../types/knowledgeBase';

const IS_SKIP_VALUES = new Set(['x', 'ja', 'yes', '1', 'true']);

/** Matches values of the abas "Header or table section?" (vkt) column that mean "table". */
function isTableSectionValue(v: string): boolean {
  const s = v.trim().toLowerCase();
  if (!s) return false;
  if (IS_SKIP_VALUES.has(s)) return true;
  if (s === 't') return true;
  return s.includes('table') || s.includes('tabelle');
}

/**
 * ## CSV/XLSX Column Structure (abas Variablentabelle export)
 *
 * ### New format (11 columns for databases, 9 for infosystems):
 * Identity number | Search word | Text in German | Text in English | Meaning | Displayed meaning |
 * Effective type | Write-protect entry for screens | Variable name | New variable name | Skip field?
 *
 * ### Legacy format (9 columns):
 * Identity number | Search word | Desc operating | Description | Type | Skip | Variable name | Meaning | Displayed meaning
 *
 * ### Einfaches CSV-Format (Semikolon-getrennt)
 * ```
 * database;group;name;fieldName;fieldDescription;skip
 * ```
 */

// ── Shared row processing (used by both parseXlsx and parseTextDump) ────

/** Normalized row data — common interface for XLSX and text input. */
interface RawRow {
  identity: string;
  screenNr: string;
  searchWord: string;
  effectiveType: string;
  textGerman: string;
  textEnglish: string;
  meaning: string;
  displayedMeaning: string;
  variableName: string;
  skip: string;
  writeProtect: string;
  /** "Yes"/"No" — explicit column for table/header field distinction */
  inTableSection: string;
}

const STRIP_PREFIX_RE = /^(Variablentabelle|Table of variables):\s*/i;
function stripPrefix(s: string): string {
  return s.replace(STRIP_PREFIX_RE, '');
}

/** Returns true if the string is a table-level description, not a field meaning */
function isTableLevelDesc(s: string): boolean {
  return STRIP_PREFIX_RE.test(s);
}

/** Parse "V-DD-GG" search word to "D:G" tableRef (strips leading zeros) */
function parseSearchWord(sw: string): string | null {
  const match = sw.match(/^V-(\d+)-(\d+)$/);
  if (!match) return null;
  const db = parseInt(match[1], 10);
  const grp = parseInt(match[2], 10);
  return `${db}:${grp}`;
}

/** Numeric sort for "D:G" tableRef strings */
function compareTableRef(a: string, b: string): number {
  const [aDb, aGrp] = a.split(':').map(Number);
  const [bDb, bGrp] = b.split(':').map(Number);
  return aDb !== bDb ? aDb - bDb : aGrp - bGrp;
}

/**
 * Core processing logic shared by parseXlsx and parseTextDump.
 * Converts normalized rows into TableDef[].
 */
function processRows(
  rows: RawRow[],
  isNewFormat: boolean,
): TableDef[] {
  const tableMap = new Map<string, TableDef>();

  for (const row of rows) {
    const identity = parseInt(row.identity, 10);
    const searchWord = row.searchWord.trim();
    const effectiveType = row.effectiveType.trim();
    const descOperating = row.textGerman.trim();
    const descGeneral = row.textEnglish.trim();
    const meaning = row.meaning.trim();
    const displayedMeaning = row.displayedMeaning.trim();
    const variableName = row.variableName.trim();
    const isSkip = IS_SKIP_VALUES.has(row.skip.trim().toLowerCase());
    const isReadonly = IS_SKIP_VALUES.has(row.writeProtect.trim().toLowerCase());
    const explicitTableSection = row.inTableSection.trim().toLowerCase();

    const screenNr = parseInt(row.screenNr, 10);

    if (!searchWord) continue;

    // Identity number determines type: <= 9999 = database, > 9999 = infosystem
    const isInfosystem = !isNaN(identity) && identity > 9999;
    const tableRef = parseSearchWord(searchWord);
    const key = isInfosystem ? searchWord : (tableRef ?? searchWord);

    const cleanGerman = stripPrefix(descOperating);
    const cleanEnglish = stripPrefix(descGeneral);
    const uploadedName = cleanGerman || cleanEnglish || '';

    if (!tableMap.has(key)) {
      if (isInfosystem) {
        // For infosystems: use identity number as maskNr (screenNr is usually empty)
        const isMaskNr = !isNaN(screenNr) && row.screenNr.trim() ? screenNr : (!isNaN(identity) ? identity : undefined);
        tableMap.set(key, {
          database: '',
          group: '',
          tableRef: searchWord,
          name: uploadedName || searchWord,
          fields: [],
          kind: 'infosystem',
          ...(isMaskNr !== undefined && { maskNr: isMaskNr }),
        });
      } else if (tableRef) {
        tableMap.set(key, {
          database: tableRef.split(':')[0],
          group: tableRef.split(':')[1],
          tableRef,
          name: uploadedName || searchWord,
          ...(!isNaN(screenNr) && { maskNr: screenNr }),
          fields: [],
          kind: 'database',
        });
      } else {
        tableMap.set(key, {
          database: '',
          group: '',
          tableRef: searchWord,
          name: uploadedName || searchWord,
          fields: [],
          kind: 'database',
        });
      }
    } else {
      // Backfill table name from later rows that carry table-level descriptions
      // (abas often leaves these cells empty on subsequent rows).
      const existing = tableMap.get(key)!;
      if (!existing.name && uploadedName) existing.name = uploadedName;
    }

    if (variableName) {
      if (isInfosystem && !isNewFormat) {
        // Old format: "Variable name" = type code (e.g. "I9"), "Meaning" = technical name with IS prefix
        const rawName = meaning || variableName;
        const fieldName = rawName.length > 2 ? rawName.slice(2) : rawName;
        if (fieldName) {
          tableMap.get(key)!.fields.push({
            name: fieldName,
            description: displayedMeaning || variableName,
            ...(effectiveType && { dataType: effectiveType }),
            ...(isSkip && { skip: true }),
            ...(isReadonly && { readonly: true }),
          });
        }
      } else {
        // New format (all) + old format (databases): strip 2-char prefix from variable name
        // Prefix first char: K = header/Kopf field, T = table/row field
        const prefix = variableName.length > 2 ? variableName[0].toUpperCase() : '';
        // Explicit "Header or table section?" (vkt) column has priority over variable name prefix
        const isTableField = explicitTableSection
          ? isTableSectionValue(explicitTableSection)
          : prefix === 'T';
        const fieldName = variableName.length > 2 ? variableName.slice(2) : variableName;
        if (fieldName) {
          // Filter out table-level descriptions ("Table of variables: X" / "Variablentabelle: X")
          // — these describe the TABLE, not the FIELD, and waste prompt tokens
          const cleanMeaning = isTableLevelDesc(meaning) ? '' : meaning;
          const cleanDisplayed = isTableLevelDesc(displayedMeaning) ? '' : displayedMeaning;
          // Single-language import: keep only one effective description string.
          // Prefer "Meaning" and fall back to "Displayed meaning".
          const desc = cleanMeaning || cleanDisplayed || '';
          tableMap.get(key)!.fields.push({
            name: fieldName,
            description: desc,
            ...(effectiveType && { dataType: effectiveType }),
            ...(isSkip && { skip: true }),
            ...(isReadonly && { readonly: true }),
            isTableField,
          });
        }
      }
    }
  }

  // Deduplicate fields within each table (same field name can appear in multiple groups)
  for (const table of tableMap.values()) {
    const seen = new Map<string, number>();
    table.fields = table.fields.filter((f) => {
      if (seen.has(f.name)) return false;
      seen.set(f.name, 1);
      return true;
    });
  }

  const databases = Array.from(tableMap.values())
    .filter((t) => t.kind === 'database')
    .sort((a, b) => compareTableRef(a.tableRef, b.tableRef));
  const infosystems = Array.from(tableMap.values())
    .filter((t) => t.kind === 'infosystem')
    .sort((a, b) => a.name.localeCompare(b.name));

  return [...databases, ...infosystems];
}

// ── XLSX parser ─────────────────────────────────────────────────

function readXlsxCell(row: Record<string, string | number>, keys: string[]): string {
  const keySet = new Set(keys.map((key) => key.toLocaleLowerCase()));
  const entry = Object.entries(row).find(([key]) => keySet.has(key.trim().toLocaleLowerCase()));
  return entry ? String(entry[1]) : '';
}

function readXlsxCellAt(row: Record<string, string | number>, column: number): string {
  const value = Object.values(row)[column - 1];
  return value === undefined ? '' : String(value);
}

export function parseXlsx(buffer: ArrayBuffer): TableDef[] {
  const workbook = XLSX.read(buffer, { type: 'array' });
  const sheet = workbook.Sheets[workbook.SheetNames[0]];
  if (!sheet) return [];

  const xlsxRows = XLSX.utils.sheet_to_json<Record<string, string | number>>(sheet, { defval: '' });
  if (xlsxRows.length === 0) return [];

  const firstRow = xlsxRows[0];
  const firstValues = Object.values(firstRow ?? {}).map(String);
  const usesVariableLayout = /^V-\d+-\d+$/i.test(firstValues[2] ?? '');
  const usesInfosystemLayout = Number(firstValues[0]) > 9999 && !!firstValues[1];
  const isNewFormat = !!firstRow && (
    !!readXlsxCell(firstRow, ['Text in German', 'Text in English', 'name1'])
    || usesVariableLayout
    || usesInfosystemLayout
  );
  // Map XLSX rows to normalized RawRow[]
  const rows: RawRow[] = xlsxRows.map((row, rowIndex) => {
    const values = Object.values(row).map(String);
    const isVariableRow = /^V-\d+-\d+$/i.test(values[2] ?? '');
    const hasTechnicalLayout = isVariableRow || (Number(values[0]) > 9999 && !!values[1]);
    const identity = readXlsxCell(row, ['Identity number', 'Identity', 'nummer']) || (hasTechnicalLayout ? values[isVariableRow ? 1 : 0] ?? '' : '');
    const searchWord = readXlsxCell(row, ['Search word', 'such']) || (hasTechnicalLayout ? values[isVariableRow ? 2 : 1] ?? '' : '');
    const headerType = readXlsxCell(row, ['Effective type', 'Type', 'vitefff']);
    const isInfosystem = Number(identity) > 9999;
    const typeColumn = isInfosystem ? 5 : 6;
    const positionalType = readXlsxCellAt(row, typeColumn);
    const effectiveType = headerType || positionalType;
    const offset = isVariableRow ? 0 : -1;
    return {
      identity,
      screenNr: readXlsxCell(row, ['Number of 1st screen', 'Nummer des 1. Bildschirms', 'vmnr1']) || (isVariableRow ? values[0] ?? '' : ''),
      searchWord,
      // abas export layout: vitefff is column 6 for variables, column 5 for infosystems.
      effectiveType,
      textGerman: readXlsxCell(row, ['Text in German', 'Description in operating language', 'name1']) || (hasTechnicalLayout ? values[3 + offset] ?? '' : ''),
      textEnglish: readXlsxCell(row, ['Text in English', 'Description']),
      meaning: readXlsxCell(row, ['Meaning', 'vbed']) || (hasTechnicalLayout ? values[4 + offset] ?? '' : ''),
      displayedMeaning: readXlsxCell(row, ['Displayed meaning']),
      variableName: readXlsxCell(row, ['Variable name', 'vname']) || (hasTechnicalLayout ? values[7 + offset] ?? '' : ''),
      skip: readXlsxCell(row, ['Skip field?', 'Skip', 'vskip']) || (isVariableRow ? values[9] ?? '' : ''),
      writeProtect: readXlsxCell(row, ['Write-protect entry for screens', 'Schreibschutz', 'vms']) || (hasTechnicalLayout ? values[6 + offset] ?? '' : ''),
      inTableSection: readXlsxCell(row, ['Header or table section?', 'Variable in table section?', 'Kopf- oder Tabellenteil?', 'Kopf oder Tabellenteil?', 'vkt']) || (hasTechnicalLayout ? values[isVariableRow ? 10 : 7] ?? '' : ''),
    };
  });

  return processRows(rows, isNewFormat);
}

// ── Text dump parser (paste) ────────────────────────────────────

/**
 * Parses pasted text output from abas Variablentabelle command.
 * Supports both tab-separated and semicolon-separated input.
 */
export function parseTextDump(text: string): TableDef[] {
  const lines = text.split('\n').map((l) => l.trimEnd()).filter(Boolean);
  if (lines.length === 0) return [];

  // Detect separator: tab or semicolon
  const sep = lines[0].includes('\t') ? '\t' : ';';

  // Detect header row
  const firstCols = lines[0].split(sep).map((c) => c.trim().toLowerCase());
  const hasHeader =
    firstCols.some((c) => c.includes('identity')) ||
    firstCols.some((c) => c.includes('search word') || c.includes('suchwort')) ||
    firstCols.some((c) => c.includes('variable name') || c.includes('variablenname') || c === 'vname');

  const colMap = detectColumnMapping(hasHeader ? firstCols : []);
  const startIndex = hasHeader ? 1 : 0;

  const isNewFormat = hasHeader && firstCols.some((c) => c.includes('text in german') || c.includes('text in deutsch') || c === 'name1');

  // Map text lines to normalized RawRow[]
  const rows: RawRow[] = [];
  for (let i = startIndex; i < lines.length; i++) {
    const cols = lines[i].split(sep).map((c) => c.trim());
    if (cols.length < 3) continue;
    rows.push({
      identity: cols[colMap.identity] ?? '',
      screenNr: colMap.screenNr >= 0 ? (cols[colMap.screenNr] ?? '') : '',
      searchWord: cols[colMap.searchWord] ?? '',
      effectiveType: colMap.effectiveType >= 0 ? (cols[colMap.effectiveType] ?? '') : '',
      textGerman: cols[colMap.textGerman] ?? '',
      textEnglish: cols[colMap.textEnglish] ?? '',
      meaning: cols[colMap.meaning] ?? '',
      displayedMeaning: cols[colMap.displayedMeaning] ?? '',
      variableName: cols[colMap.variableName] ?? '',
      skip: colMap.skip >= 0 ? (cols[colMap.skip] ?? '') : '',
      writeProtect: colMap.writeProtect >= 0 ? (cols[colMap.writeProtect] ?? '') : '',
      inTableSection: colMap.inTableSection >= 0 ? (cols[colMap.inTableSection] ?? '') : '',
    });
  }

  return processRows(rows, isNewFormat);
}

/** Column index mapping for text/CSV parsing. */
interface ColumnMapping {
  identity: number;
  screenNr: number; // -1 if not present
  searchWord: number;
  effectiveType: number; // -1 if not present
  textGerman: number;
  textEnglish: number;
  meaning: number;
  displayedMeaning: number;
  variableName: number;
  skip: number; // -1 if not present
  writeProtect: number; // -1 if not present
  inTableSection: number; // -1 if not present
}

/**
 * Detect column indices from header names.
 * Supports both the new 11-column English export and the legacy 9-column format.
 */
function detectColumnMapping(headerCols: string[]): ColumnMapping {
  if (headerCols.length === 0) {
    // Legacy 9-column positional
    return { identity: 0, screenNr: -1, searchWord: 1, effectiveType: 4, textGerman: 2, textEnglish: 3, meaning: 7, displayedMeaning: 8, variableName: 6, skip: 5, writeProtect: -1, inTableSection: -1 };
  }

  const find = (needles: string[]): number =>
    headerCols.findIndex((h) => needles.some((n) => h.includes(n)));

  const identityIdx = find(['identity', 'nummer']);
  const searchWordIdx = find(['search word', 'suchwort', 'such']);
  const effectiveTypeIdx = find(['effective type', 'vitefff', 'type', 'typ']);
  const meaningIdx = find(['meaning', 'vbed']);
  const displayedIdx = headerCols.findIndex((h, i) => i !== meaningIdx && h.includes('meaning') && h.includes('displayed'));
  const varNameIdx = find(['variable name', 'variablenname', 'vname']);
  const skipIdx = find(['skip', 'vskip']);
  const textGermanIdx = find(['text in german', 'text in deutsch', 'name1']);
  const textEnglishIdx = find(['text in english', 'text in englisch']);
  const descOpIdx = find(['description in operating', 'beschreibung in betrieb']);
  const descIdx = headerCols.findIndex((h, i) =>
    i !== descOpIdx && (h === 'description' || h === 'beschreibung')
  );
  const writeProtectIdx = find(['write-protect', 'write protect', 'schreibschutz', 'vms']);
  const inTableSectionIdx = find([
    'header or table section',
    'kopf- oder tabellenteil',
    'kopf oder tabellenteil',
    'variable in table section',
    'variable im tabellenteil',
    'vkt',
  ]);
  const screenNrIdx = find(['number of 1st screen', 'nummer des 1. bildschirms', 'bildschirm', 'vmnr1']);

  return {
    identity: identityIdx >= 0 ? identityIdx : 0,
    screenNr: screenNrIdx >= 0 ? screenNrIdx : -1,
    searchWord: searchWordIdx >= 0 ? searchWordIdx : 1,
    effectiveType: effectiveTypeIdx >= 0 ? effectiveTypeIdx : -1,
    textGerman: textGermanIdx >= 0 ? textGermanIdx : (descOpIdx >= 0 ? descOpIdx : 2),
    textEnglish: textEnglishIdx >= 0 ? textEnglishIdx : (descIdx >= 0 ? descIdx : 3),
    meaning: meaningIdx >= 0 ? meaningIdx : 4,
    displayedMeaning: displayedIdx >= 0 ? displayedIdx : (meaningIdx >= 0 ? meaningIdx + 1 : 5),
    variableName: varNameIdx >= 0 ? varNameIdx : 6,
    skip: skipIdx >= 0 ? skipIdx : -1,
    writeProtect: writeProtectIdx >= 0 ? writeProtectIdx : -1,
    inTableSection: inTableSectionIdx >= 0 ? inTableSectionIdx : -1,
  };
}

// ── Simple CSV parser ───────────────────────────────────────────

/**
 * Parses a CSV string into TableDef array.
 * Supports simple format (database;group;name;...) and abas export format.
 */
export function parseTableCsv(csv: string): TableDef[] {
  const lines = csv.split('\n').map((l) => l.trim()).filter(Boolean);
  if (lines.length === 0) return [];

  const firstLine = lines[0].toLowerCase();

  // Detect abas export format by checking for known headers OR tab-separated content
  // Tab-separated = abas copy/paste format → always use parseTextDump
  const isAbasFormat =
    firstLine.includes('identity') ||
    firstLine.includes('search word') ||
    firstLine.includes('suchwort') ||
    firstLine.includes('variable name') ||
    firstLine.includes('variablenname') ||
    firstLine.includes('\t');

  if (isAbasFormat) {
    return parseTextDump(csv);
  }

  // Simple CSV format: database;group;name;fieldName;fieldDescription;skip
  const startIndex =
    firstLine.includes('database') || firstLine.includes('datenbank') || firstLine.includes('gruppe')
      ? 1
      : 0;

  const tableMap = new Map<string, TableDef>();

  for (let i = startIndex; i < lines.length; i++) {
    const parts = lines[i].split(';').map((p) => p.trim());
    if (parts.length < 3) continue;

    const [database, group, name, fieldName, fieldDescription, skipCol] = parts;
    const key = `${database}:${group}`;

    if (!tableMap.has(key)) {
      tableMap.set(key, {
        database,
        group,
        tableRef: key,
        name,
        fields: [],
        kind: 'database',
      });
    }

    const table = tableMap.get(key)!;
    if (fieldName) {
      const skip = IS_SKIP_VALUES.has((skipCol ?? '').trim().toLowerCase());
      table.fields.push({
        name: fieldName,
        description: fieldDescription || '',
        ...(skip && { skip: true }),
      });
    }
  }

  return Array.from(tableMap.values()).sort((a, b) => a.tableRef.localeCompare(b.tableRef));
}

// ── IndexedDB persistence ───────────────────────────────────────

import { openDb, IDB_TABLES_STORE } from './idb';

// ── Workspace-scoped persistence ───────────────────────────────

const WORKSPACE_TABLES_FILE = 'variablentabelle-cache.json';
const WORKSPACE_SETTINGS_DIR = '.cucumbergnerator-settings';

export async function saveTableDefsToWorkspace(
  rootHandle: FileSystemDirectoryHandle,
  tables: TableDef[],
): Promise<void> {
  try {
    const settingsDir = await rootHandle.getDirectoryHandle(WORKSPACE_SETTINGS_DIR, { create: true });
    const fileHandle = await settingsDir.getFileHandle(WORKSPACE_TABLES_FILE, { create: true });
    const writable = await fileHandle.createWritable();
    await writable.write(JSON.stringify(tables, null, 2));
    await writable.close();
  } catch {
    // ignore — workspace may be read-only
  }
}

export async function loadTableDefsFromWorkspace(
  rootHandle: FileSystemDirectoryHandle,
): Promise<TableDef[] | null> {
  try {
    const settingsDir = await rootHandle.getDirectoryHandle(WORKSPACE_SETTINGS_DIR);
    const fileHandle = await settingsDir.getFileHandle(WORKSPACE_TABLES_FILE);
    const file = await fileHandle.getFile();
    const parsed = JSON.parse(await file.text());
    return Array.isArray(parsed) ? parsed as TableDef[] : null;
  } catch {
    return null;
  }
}

async function writeWorkspaceJson(rootHandle: FileSystemDirectoryHandle, fileName: string, data: unknown): Promise<void> {
  try {
    const settingsDir = await rootHandle.getDirectoryHandle(WORKSPACE_SETTINGS_DIR, { create: true });
    const fileHandle = await settingsDir.getFileHandle(fileName, { create: true });
    const writable = await fileHandle.createWritable();
    await writable.write(JSON.stringify(data, null, 2));
    await writable.close();
  } catch { /* read-only workspace */ }
}

async function readWorkspaceJson(rootHandle: FileSystemDirectoryHandle, fileName: string): Promise<unknown[] | null> {
  try {
    const settingsDir = await rootHandle.getDirectoryHandle(WORKSPACE_SETTINGS_DIR);
    const fileHandle = await settingsDir.getFileHandle(fileName);
    const file = await fileHandle.getFile();
    const parsed = JSON.parse(await file.text());
    return Array.isArray(parsed) ? parsed : null;
  } catch {
    return null;
  }
}

export const saveFopBindingsToWorkspace = (h: FileSystemDirectoryHandle, b: unknown[]) =>
  writeWorkspaceJson(h, 'fop-bindings-cache.json', b);
export const loadFopBindingsFromWorkspace = (h: FileSystemDirectoryHandle) =>
  readWorkspaceJson(h, 'fop-bindings-cache.json');

export const saveIsBindingsToWorkspace = (h: FileSystemDirectoryHandle, b: unknown[]) =>
  writeWorkspaceJson(h, 'is-bindings-cache.json', b);
export const loadIsBindingsFromWorkspace = (h: FileSystemDirectoryHandle) =>
  readWorkspaceJson(h, 'is-bindings-cache.json');

// ── Knowledge Base workspace cache ─────────────────────────────

async function readWorkspaceJsonObject(rootHandle: FileSystemDirectoryHandle, fileName: string): Promise<unknown | null> {
  try {
    const settingsDir = await rootHandle.getDirectoryHandle(WORKSPACE_SETTINGS_DIR);
    const fileHandle = await settingsDir.getFileHandle(fileName);
    const file = await fileHandle.getFile();
    return JSON.parse(await file.text());
  } catch {
    return null;
  }
}

export async function saveKBToWorkspace(
  rootHandle: FileSystemDirectoryHandle,
  docs: KBDocument[],
  // Strip htmlContent from chunks to keep the file manageable; search still works via `text`.
  chunks: KBChunk[],
): Promise<void> {
  const lean = chunks.map(({ htmlContent: _html, ...rest }) => rest);
  await writeWorkspaceJson(rootHandle, 'kb-cache.json', { docs, chunks: lean });
}

export async function loadKBFromWorkspace(
  rootHandle: FileSystemDirectoryHandle,
): Promise<{ docs: unknown[]; chunks: unknown[] } | null> {
  const data = await readWorkspaceJsonObject(rootHandle, 'kb-cache.json');
  if (!data || typeof data !== 'object') return null;
  const d = data as { docs?: unknown; chunks?: unknown };
  if (!Array.isArray(d.docs) || !Array.isArray(d.chunks)) return null;
  return { docs: d.docs, chunks: d.chunks };
}

const IDB_STORE = IDB_TABLES_STORE;
const IDB_KEY = 'tableDefs';

export async function saveTableDefs(tables: TableDef[]): Promise<boolean> {
  try {
    const db = await openDb();
    return new Promise((resolve) => {
      const tx = db.transaction(IDB_STORE, 'readwrite');
      tx.objectStore(IDB_STORE).put(tables, IDB_KEY);
      tx.oncomplete = () => { db.close(); resolve(true); };
      tx.onerror = () => {
        console.warn('[cucumbergnerator] Failed to save table defs:', tx.error);
        db.close();
        resolve(false);
      };
    });
  } catch (err) {
    console.warn('[cucumbergnerator] Failed to save table defs:', err);
    return false;
  }
}

export async function loadTableDefs(): Promise<TableDef[]> {
  try {
    const db = await openDb();
    return new Promise((resolve) => {
      const tx = db.transaction(IDB_STORE, 'readonly');
      const req = tx.objectStore(IDB_STORE).get(IDB_KEY);
      req.onsuccess = () => {
        db.close();
        const data = req.result;
        const tables = Array.isArray(data) ? data : [];
        let needsSave = false;
        for (const t of tables) {
          // Sanitize: tables with empty names get a fallback
          if (!t.name?.trim()) {
            t.name = t.nameDe || t.nameEn || t.tableRef || 'Unbenannt';
            needsSave = true;
          }
          // Auto-migrate: old data has name but no nameDe/nameEn
          if (t.name && !t.nameEn && !t.nameDe) {
            t.nameEn = t.name;
            t.nameDe = t.name;
            needsSave = true;
          }
          // Deduplicate fields (old imports may have duplicates)
          if (t.fields) {
            const seen = new Set<string>();
            const before = t.fields.length;
            t.fields = t.fields.filter((f: { name: string }) => {
              if (seen.has(f.name)) return false;
              seen.add(f.name);
              return true;
            });
            if (t.fields.length !== before) needsSave = true;
          }
        }
        if (needsSave) {
          saveTableDefs(tables);
        }
        resolve(tables);
      };
      req.onerror = () => {
        console.warn('[cucumbergnerator] Failed to load table defs:', req.error);
        db.close();
        resolve([]);
      };
    });
  } catch (err) {
    console.warn('[cucumbergnerator] Failed to load table defs:', err);
    return [];
  }
}

export async function clearTableDefs(): Promise<void> {
  try {
    const db = await openDb();
    const tx = db.transaction(IDB_STORE, 'readwrite');
    tx.objectStore(IDB_STORE).delete(IDB_KEY);
    tx.oncomplete = () => db.close();
  } catch {
    // ignore
  }
  for (const k of ['cucumbergnerator_tables', 'cucumbergnerator_tables_v2', 'cucumbergnerator_tables_v3']) {
    localStorage.removeItem(k);
  }
}

/** Migrate from localStorage to IndexedDB (called once on app start) */
export async function migrateTableDefsFromLocalStorage(): Promise<TableDef[] | null> {
  const LS_KEY = 'cucumbergnerator_tables_v3';
  const data = localStorage.getItem(LS_KEY);
  if (!data) return null;
  try {
    const tables: TableDef[] = JSON.parse(data);
    if (Array.isArray(tables) && tables.length > 0) {
      await saveTableDefs(tables);
      localStorage.removeItem(LS_KEY);
      localStorage.removeItem('cucumbergnerator_tables');
      localStorage.removeItem('cucumbergnerator_tables_v2');
      return tables;
    }
  } catch { /* ignore */ }
  return null;
}

/**
 * Merges two TableDef arrays. Tables with the same tableRef+kind are combined.
 */
export function mergeTableDefs(a: TableDef[], b: TableDef[]): TableDef[] {
  const map = new Map<string, TableDef>();
  for (const t of a) {
    map.set(`${t.kind}:${t.tableRef}`, { ...t, fields: [...t.fields] });
  }
  for (const t of b) {
    const key = `${t.kind}:${t.tableRef}`;
    const existing = map.get(key);
    if (existing) {
      if (t.nameDe) existing.nameDe = t.nameDe;
      if (t.nameEn) existing.nameEn = t.nameEn;
      if (t.name) existing.name = t.name;
      if (t.maskNr !== undefined) existing.maskNr = t.maskNr;

      const existingByName = new Map(existing.fields.map((f) => [f.name.trim().toLowerCase(), f]));
      for (const f of t.fields) {
        const fieldKey = f.name.trim().toLowerCase();
        const ef = existingByName.get(fieldKey);
        if (ef) {
          if (f.descriptionDe) ef.descriptionDe = f.descriptionDe;
          if (f.descriptionEn) ef.descriptionEn = f.descriptionEn;
          if (f.description) ef.description = f.description;
          if (f.dataType) ef.dataType = f.dataType;
          // Always update structural flags from new import
          ef.isTableField = f.isTableField;
          ef.skip = f.skip;
          ef.readonly = f.readonly;
        } else {
          existing.fields.push(f);
          existingByName.set(fieldKey, f);
        }
      }
    } else {
      map.set(key, { ...t, fields: [...t.fields] });
    }
  }

  const all = Array.from(map.values());
  const databases = all.filter((t) => t.kind === 'database').sort((a, b) => compareTableRef(a.tableRef, b.tableRef));
  const infosystems = all.filter((t) => t.kind === 'infosystem').sort((a, b) => a.name.localeCompare(b.name));
  return [...databases, ...infosystems];
}
