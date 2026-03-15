import * as XLSX from 'xlsx';
import type { TableDef } from '../types/gherkin';

const IS_SKIP_VALUES = new Set(['x', 'ja', 'yes', '1', 'true']);

/**
 * Parses an xlsx ArrayBuffer (abas Variablentabelle format) into TableDef[].
 *
 * ## CSV/XLSX Column Structure (abas Variablentabelle export)
 *
 * Supports two column layouts from abas Variablentabelle export:
 *
 * ### New format (English export, 11 columns for databases, 9 for infosystems):
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
export function parseXlsx(buffer: ArrayBuffer): TableDef[] {
  const workbook = XLSX.read(buffer, { type: 'array' });
  const sheet = workbook.Sheets[workbook.SheetNames[0]];
  if (!sheet) return [];

  const rows = XLSX.utils.sheet_to_json<Record<string, string | number>>(sheet);
  const tableMap = new Map<string, TableDef>();

  // Detect new English export format (has "Text in German"/"Text in English" columns)
  // In old format: infosystem "Variable name" = type code, "Meaning" = technical name
  // In new format: "Variable name" = technical name for all, "Meaning" = description
  const firstRow = rows[0];
  const isNewFormat = firstRow && ('Text in German' in firstRow || 'Text in English' in firstRow);
  const hasBothLangs = firstRow && 'Text in German' in firstRow && 'Text in English' in firstRow;

  for (const row of rows) {
    const identityRaw = row['Identity number'] ?? row['Identity'] ?? '';
    const identity = parseInt(String(identityRaw), 10);
    const searchWord = String(row['Search word'] ?? '').trim();
    // Support both old headers ("Description in operating language" / "Description")
    // and new headers ("Text in German" / "Text in English")
    const descOperating = String(row['Text in German'] ?? row['Description in operating language'] ?? '');
    const descGeneral = String(row['Text in English'] ?? row['Description'] ?? '');
    const variableName = String(row['Variable name'] ?? '');
    const meaning = String(row['Meaning'] ?? '');
    const displayedMeaning = String(row['Displayed meaning'] ?? '');
    const skipRaw = String(row['Skip field?'] ?? row['Skip'] ?? '').trim().toLowerCase();
    const isSkip = IS_SKIP_VALUES.has(skipRaw);

    if (!searchWord) continue;

    // Identity number determines type: <= 9999 = database, > 9999 = infosystem
    const isInfosystem = !isNaN(identity) && identity > 9999;
    const tableRef = parseSearchWord(searchWord);

    // For infosystems: column C has the Suchwort (e.g. "TESTINFO"), column B has the name
    // For databases: column B has V-DD-GG search word, column C/D has the name
    const key = isInfosystem ? (descOperating || searchWord) : (tableRef ?? searchWord);

    if (!tableMap.has(key)) {
      const stripPrefix = (s: string) => s.replace(/^(Variablentabelle|Table of variables):\s*/i, '');
      if (isInfosystem) {
        // Suchwort from column C, name from column B
        const suchwort = descOperating || searchWord;
        tableMap.set(key, {
          database: '',
          group: '',
          tableRef: suchwort,
          name: searchWord,
          fields: [],
          kind: 'infosystem',
        });
      } else if (tableRef) {
        const name = stripPrefix(descGeneral || descOperating);
        tableMap.set(key, {
          database: tableRef.split(':')[0],
          group: tableRef.split(':')[1],
          tableRef,
          name,
          ...(hasBothLangs && {
            nameDe: stripPrefix(descOperating),
            nameEn: stripPrefix(descGeneral),
          }),
          fields: [],
          kind: 'database',
        });
      } else {
        // No V-DD-GG pattern and identity <= 9999 — treat as database with raw search word
        const name = stripPrefix(descGeneral || descOperating);
        tableMap.set(key, {
          database: '',
          group: '',
          tableRef: searchWord,
          name,
          ...(hasBothLangs && {
            nameDe: stripPrefix(descOperating),
            nameEn: stripPrefix(descGeneral),
          }),
          fields: [],
          kind: 'database',
        });
      }
    }

    if (variableName) {
      if (isInfosystem && !isNewFormat) {
        // Old format: "Variable name" = type code (e.g. "I9"), "Meaning" = technical name with IS prefix
        const rawName = meaning || variableName;
        const fieldName = rawName.length > 2 ? rawName.slice(2) : rawName;
        tableMap.get(key)!.fields.push({
          name: fieldName,
          description: displayedMeaning || variableName,
          ...(isSkip && { skip: true }),
        });
      } else {
        // New format (all) + old format (databases): "Variable name" = technical name with 2-char prefix
        const fieldName = variableName.length > 2 ? variableName.slice(2) : variableName;
        const desc = meaning || displayedMeaning;
        tableMap.get(key)!.fields.push({
          name: fieldName,
          description: desc,
          // Store both when available: meaning = primary, displayedMeaning = alternative
          ...(hasBothLangs && meaning && displayedMeaning && meaning !== displayedMeaning && {
            descriptionDe: displayedMeaning,
            descriptionEn: meaning,
          }),
          ...(isSkip && { skip: true }),
        });
      }
    }
  }

  const databases = Array.from(tableMap.values())
    .filter((t) => t.kind === 'database')
    .sort((a, b) => compareTableRef(a.tableRef, b.tableRef));
  const infosystems = Array.from(tableMap.values())
    .filter((t) => t.kind === 'infosystem')
    .sort((a, b) => a.name.localeCompare(b.name));

  return [...databases, ...infosystems];
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
 * Parses a CSV string into TableDef array.
 * Supports two formats:
 * 1. Simple format: database;group;name;fieldName;fieldDescription;skip
 * 2. abas export format (;-separated): Identity number;Search word;Text in German;...
 */
export function parseTableCsv(csv: string): TableDef[] {
  const lines = csv.split('\n').map((l) => l.trim()).filter(Boolean);
  if (lines.length === 0) return [];

  const firstLine = lines[0].toLowerCase();

  // Detect abas export format by checking for known headers
  const isAbasFormat =
    firstLine.includes('identity') ||
    firstLine.includes('search word') ||
    firstLine.includes('suchwort') ||
    firstLine.includes('variable name') ||
    firstLine.includes('variablenname');

  if (isAbasFormat) {
    // Delegate to parseTextDump which handles header-based column detection
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

// ── IndexedDB persistence (no size limit, unlike localStorage's ~5MB) ──

import { openDb, IDB_TABLES_STORE } from './idb';

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
        // Auto-migrate: old data has name (English) but no nameDe/nameEn
        let needsSave = false;
        for (const t of tables) {
          if (t.name && !t.nameEn && !t.nameDe) {
            t.nameEn = t.name;
            needsSave = true;
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

/** Check if tables need re-import for bilingual support */
export function tablesNeedReimport(tables: TableDef[]): boolean {
  return tables.length > 0 && tables.some((t) => t.kind === 'database' && !t.nameDe);
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
  // Also clean up old localStorage keys
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
      // Clean up localStorage after successful migration
      localStorage.removeItem(LS_KEY);
      localStorage.removeItem('cucumbergnerator_tables');
      localStorage.removeItem('cucumbergnerator_tables_v2');
      return tables;
    }
  } catch { /* ignore, will just start fresh */ }
  return null;
}

/**
 * Parses pasted text output from abas Variablentabelle command.
 *
 * Supports both tab-separated and semicolon-separated input.
 * Detects column positions from header row (new 11-column English export
 * or legacy 9-column format). Falls back to legacy positional mapping.
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
    firstCols.some((c) => c.includes('variable name') || c.includes('variablenname'));

  // Build column index mapping from header (or use positional defaults)
  const colMap = detectColumnMapping(hasHeader ? firstCols : []);
  const startIndex = hasHeader ? 1 : 0;

  // Detect new format: "Text in German" header present → Variable name is always the technical name
  const isNewFormat = hasHeader && firstCols.some((c) => c.includes('text in german') || c.includes('text in deutsch'));
  const hasBothLangs = isNewFormat && firstCols.some((c) => c.includes('text in english') || c.includes('text in englisch'));

  const tableMap = new Map<string, TableDef>();
  const stripPrefix = (s: string) => s.replace(/^(Variablentabelle|Table of variables):\s*/i, '');

  for (let i = startIndex; i < lines.length; i++) {
    const cols = lines[i].split(sep).map((c) => c.trim());
    if (cols.length < 3) continue;

    const identityRaw = cols[colMap.identity] ?? '';
    const searchWord = cols[colMap.searchWord] ?? '';
    const descOperating = cols[colMap.textGerman] ?? '';
    const descGeneral = cols[colMap.textEnglish] ?? '';
    const meaning = cols[colMap.meaning] ?? '';
    const displayedMeaning = cols[colMap.displayedMeaning] ?? '';
    const variableName = cols[colMap.variableName] ?? '';
    const skipRaw = colMap.skip >= 0 ? (cols[colMap.skip] ?? '') : '';

    if (!searchWord) continue;

    const identity = parseInt(identityRaw, 10);
    const isInfosystem = !isNaN(identity) && identity > 9999;
    const isSkip = IS_SKIP_VALUES.has(skipRaw.trim().toLowerCase());

    const tableRef = parseSearchWord(searchWord);
    const key = isInfosystem ? (descOperating || searchWord) : (tableRef ?? searchWord);

    if (!tableMap.has(key)) {
      if (isInfosystem) {
        const suchwort = descOperating || searchWord;
        tableMap.set(key, {
          database: '',
          group: '',
          tableRef: suchwort,
          name: searchWord,
          fields: [],
          kind: 'infosystem',
        });
      } else if (tableRef) {
        const name = stripPrefix(descGeneral || descOperating || '');
        tableMap.set(key, {
          database: tableRef.split(':')[0],
          group: tableRef.split(':')[1],
          tableRef,
          name,
          ...(hasBothLangs && {
            nameDe: stripPrefix(descOperating),
            nameEn: stripPrefix(descGeneral),
          }),
          fields: [],
          kind: 'database',
        });
      } else {
        const name = stripPrefix(descGeneral || descOperating || '');
        tableMap.set(key, {
          database: '',
          group: '',
          tableRef: searchWord,
          name,
          ...(hasBothLangs && {
            nameDe: stripPrefix(descOperating),
            nameEn: stripPrefix(descGeneral),
          }),
          fields: [],
          kind: 'database',
        });
      }
    }

    if (variableName) {
      if (isInfosystem && !isNewFormat) {
        // Old format: "Variable name" = type code, "Meaning" = technical name with IS prefix
        const rawName = meaning || variableName;
        const fieldName = rawName.length > 2 ? rawName.slice(2) : rawName;
        tableMap.get(key)!.fields.push({
          name: fieldName,
          description: displayedMeaning || variableName,
          ...(isSkip && { skip: true }),
        });
      } else {
        // New format (all) + old format (databases): strip 2-char prefix from variable name
        const fieldName = variableName.length > 2 ? variableName.slice(2) : variableName;
        const desc = meaning || displayedMeaning || '';
        tableMap.get(key)!.fields.push({
          name: fieldName,
          description: desc,
          ...(hasBothLangs && meaning && displayedMeaning && meaning !== displayedMeaning && {
            descriptionDe: displayedMeaning,
            descriptionEn: meaning,
          }),
          ...(isSkip && { skip: true }),
        });
      }
    }
  }

  const databases = Array.from(tableMap.values())
    .filter((t) => t.kind === 'database')
    .sort((a, b) => compareTableRef(a.tableRef, b.tableRef));
  const infosystems = Array.from(tableMap.values())
    .filter((t) => t.kind === 'infosystem')
    .sort((a, b) => a.name.localeCompare(b.name));

  return [...databases, ...infosystems];
}

/** Column index mapping for text/CSV parsing. */
interface ColumnMapping {
  identity: number;
  searchWord: number;
  textGerman: number;
  textEnglish: number;
  meaning: number;
  displayedMeaning: number;
  variableName: number;
  skip: number; // -1 if not present (e.g. infosystem exports)
}

/**
 * Detect column indices from header names.
 * Supports both the new 11-column English export and the legacy 9-column format.
 * Falls back to legacy positional mapping if no headers given.
 */
function detectColumnMapping(headerCols: string[]): ColumnMapping {
  if (headerCols.length === 0) {
    // Legacy 9-column positional: identity, searchWord, descOp, descGen, type, skip, varName, meaning, dispMeaning
    return { identity: 0, searchWord: 1, textGerman: 2, textEnglish: 3, meaning: 7, displayedMeaning: 8, variableName: 6, skip: 5 };
  }

  const find = (needles: string[]): number =>
    headerCols.findIndex((h) => needles.some((n) => h.includes(n)));

  const identityIdx = find(['identity']);
  const searchWordIdx = find(['search word', 'suchwort']);
  const meaningIdx = find(['meaning']);
  // "Displayed meaning" must be found AFTER "Meaning" to avoid matching the same column
  const displayedIdx = headerCols.findIndex((h, i) => i !== meaningIdx && h.includes('meaning') && h.includes('displayed'));
  const varNameIdx = find(['variable name', 'variablenname']);
  const skipIdx = find(['skip']);

  // Detect new format: "Text in German" / "Text in English" headers
  const textGermanIdx = find(['text in german', 'text in deutsch']);
  const textEnglishIdx = find(['text in english', 'text in englisch']);

  // Legacy format: "Description in operating language" / "Description"
  const descOpIdx = find(['description in operating', 'beschreibung in betrieb']);
  const descIdx = headerCols.findIndex((h, i) =>
    i !== descOpIdx && (h === 'description' || h === 'beschreibung')
  );

  return {
    identity: identityIdx >= 0 ? identityIdx : 0,
    searchWord: searchWordIdx >= 0 ? searchWordIdx : 1,
    textGerman: textGermanIdx >= 0 ? textGermanIdx : (descOpIdx >= 0 ? descOpIdx : 2),
    textEnglish: textEnglishIdx >= 0 ? textEnglishIdx : (descIdx >= 0 ? descIdx : 3),
    meaning: meaningIdx >= 0 ? meaningIdx : 4,
    displayedMeaning: displayedIdx >= 0 ? displayedIdx : (meaningIdx >= 0 ? meaningIdx + 1 : 5),
    variableName: varNameIdx >= 0 ? varNameIdx : 6,
    skip: skipIdx >= 0 ? skipIdx : -1,
  };
}

/**
 * Merges two TableDef arrays. Tables with the same tableRef+kind are combined
 * (fields from source B appended to A, deduplicating by field name).
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
      // Update bilingual metadata from newer import
      if (t.nameDe) existing.nameDe = t.nameDe;
      if (t.nameEn) existing.nameEn = t.nameEn;
      if (t.name) existing.name = t.name;

      const existingByName = new Map(existing.fields.map((f) => [f.name, f]));
      for (const f of t.fields) {
        const ef = existingByName.get(f.name);
        if (ef) {
          // Update bilingual metadata on existing fields
          if (f.descriptionDe) ef.descriptionDe = f.descriptionDe;
          if (f.descriptionEn) ef.descriptionEn = f.descriptionEn;
          if (f.description) ef.description = f.description;
        } else {
          existing.fields.push(f);
          existingByName.set(f.name, f);
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
