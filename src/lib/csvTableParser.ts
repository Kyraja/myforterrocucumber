/**
 * @module csvTableParser
 * Parses abas ERP variable-table exports (XLSX, tab-separated text, or simple CSV)
 * into the application's internal `TableDef` data model.
 *
 * Key responsibilities: handles both the legacy 9-column and current 11-column abas
 * export formats (English/German), normalises database and infosystem rows into
 * `TableDef[]`, deduplicates fields, merges multiple imports, and persists/loads
 * the result via IndexedDB (with a one-time localStorage migration).
 *
 * @exports parseXlsx, parseTextDump, parseTableCsv, mergeTableDefs,
 *          saveTableDefs, loadTableDefs, clearTableDefs,
 *          migrateTableDefsFromLocalStorage, tablesNeedReimport
 */
import * as XLSX from 'xlsx';
import type { TableDef } from '../types/gherkin';

const IS_SKIP_VALUES = new Set(['x', 'ja', 'yes', '1', 'true']);

/**
 * ## CSV/XLSX Column Structure (abas Variablentabelle export)
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

// ── Shared row processing (used by both parseXlsx and parseTextDump) ────

/** Normalized row data — common interface for XLSX and text input. */
interface RawRow {
  identity: string;
  screenNr: string;
  searchWord: string;
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
  hasBothLangs: boolean,
): TableDef[] {
  const tableMap = new Map<string, TableDef>();

  for (const row of rows) {
    const identity = parseInt(row.identity, 10);
    const searchWord = row.searchWord.trim();
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

    if (!tableMap.has(key)) {
      if (isInfosystem) {
        // For infosystems: use identity number as maskNr (screenNr is usually empty)
        const isMaskNr = !isNaN(screenNr) && row.screenNr.trim() ? screenNr : (!isNaN(identity) ? identity : undefined);
        console.log(`[csvParser-IS] ${key} name="${descOperating}" identity=${identity} screenNr=${screenNr} → maskNr=${isMaskNr}`);
        tableMap.set(key, {
          database: '',
          group: '',
          tableRef: searchWord,
          name: descOperating || searchWord,
          nameDe: descOperating || undefined,
          nameEn: descGeneral || undefined,
          fields: [],
          kind: 'infosystem',
          ...(isMaskNr !== undefined && { maskNr: isMaskNr }),
        });
      } else if (tableRef) {
        const name = stripPrefix(descGeneral || descOperating || '');
        tableMap.set(key, {
          database: tableRef.split(':')[0],
          group: tableRef.split(':')[1],
          tableRef,
          name: name || searchWord,
          ...(!isNaN(screenNr) && { maskNr: screenNr }),
          ...(hasBothLangs && {
            nameDe: stripPrefix(descOperating) || undefined,
            nameEn: stripPrefix(descGeneral) || undefined,
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
          name: name || searchWord,
          ...(hasBothLangs && {
            nameDe: stripPrefix(descOperating) || undefined,
            nameEn: stripPrefix(descGeneral) || undefined,
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
        if (fieldName) {
          tableMap.get(key)!.fields.push({
            name: fieldName,
            description: displayedMeaning || variableName,
            ...(isSkip && { skip: true }),
            ...(isReadonly && { readonly: true }),
          });
        }
      } else {
        // New format (all) + old format (databases): strip 2-char prefix from variable name
        // Prefix first char: K = header/Kopf field, T = table/row field
        const prefix = variableName.length > 2 ? variableName[0].toUpperCase() : '';
        // Explicit "Variable in table section?" column has priority over variable name prefix
        const isTableField = explicitTableSection
          ? IS_SKIP_VALUES.has(explicitTableSection)
          : prefix === 'T';
        const fieldName = variableName.length > 2 ? variableName.slice(2) : variableName;
        if (fieldName) {
          // Filter out table-level descriptions ("Table of variables: X" / "Variablentabelle: X")
          // — these describe the TABLE, not the FIELD, and waste prompt tokens
          const cleanMeaning = isTableLevelDesc(meaning) ? '' : meaning;
          const cleanDisplayed = isTableLevelDesc(displayedMeaning) ? '' : displayedMeaning;
          // Debug: log first 3 fields per table to check column mapping
          if (tableMap.get(key)!.fields.length < 1) {
            const tbl = tableMap.get(key)!;
            console.log(`[csvParser] ${key} kind=${tbl.kind} maskNr=${tbl.maskNr} screenNr=${screenNr} raw="${row.screenNr}" identity=${identity}`);
          }
          // description = best available (prefer English for prompt compatibility)
          const desc = cleanMeaning || cleanDisplayed || '';
          // Always set descriptionDe/En when we have content — even if only one language
          const descDe = cleanDisplayed || cleanMeaning || undefined;
          const descEn = cleanMeaning || undefined;
          tableMap.get(key)!.fields.push({
            name: fieldName,
            description: desc,
            ...(descDe && { descriptionDe: descDe }),
            ...(descEn && descEn !== descDe && { descriptionEn: descEn }),
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

export function parseXlsx(buffer: ArrayBuffer): TableDef[] {
  const workbook = XLSX.read(buffer, { type: 'array' });
  const sheet = workbook.Sheets[workbook.SheetNames[0]];
  if (!sheet) return [];

  const xlsxRows = XLSX.utils.sheet_to_json<Record<string, string | number>>(sheet);
  if (xlsxRows.length === 0) return [];

  const firstRow = xlsxRows[0];
  const isNewFormat = !!(firstRow && ('Text in German' in firstRow || 'Text in English' in firstRow));
  const hasBothLangs = !!(firstRow && 'Text in German' in firstRow && 'Text in English' in firstRow);

  // Map XLSX rows to normalized RawRow[]
  const rows: RawRow[] = xlsxRows.map((row) => ({
    identity: String(row['Identity number'] ?? row['Identity'] ?? ''),
    screenNr: String(row['Number of 1st screen'] ?? row['Nummer des 1. Bildschirms'] ?? ''),
    searchWord: String(row['Search word'] ?? ''),
    textGerman: String(row['Text in German'] ?? row['Description in operating language'] ?? ''),
    textEnglish: String(row['Text in English'] ?? row['Description'] ?? ''),
    meaning: String(row['Meaning'] ?? ''),
    displayedMeaning: String(row['Displayed meaning'] ?? ''),
    variableName: String(row['Variable name'] ?? ''),
    skip: String(row['Skip field?'] ?? row['Skip'] ?? ''),
    writeProtect: String(row['Write-protect entry for screens'] ?? row['Schreibschutz'] ?? ''),
    inTableSection: String(row['Variable in table section?'] ?? ''),
  }));

  return processRows(rows, isNewFormat, hasBothLangs);
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
    firstCols.some((c) => c.includes('variable name') || c.includes('variablenname'));

  const colMap = detectColumnMapping(hasHeader ? firstCols : []);
  const startIndex = hasHeader ? 1 : 0;

  const isNewFormat = hasHeader && firstCols.some((c) => c.includes('text in german') || c.includes('text in deutsch'));
  const hasBothLangs = isNewFormat && firstCols.some((c) => c.includes('text in english') || c.includes('text in englisch'));

  // Map text lines to normalized RawRow[]
  const rows: RawRow[] = [];
  for (let i = startIndex; i < lines.length; i++) {
    const cols = lines[i].split(sep).map((c) => c.trim());
    if (cols.length < 3) continue;
    rows.push({
      identity: cols[colMap.identity] ?? '',
      screenNr: colMap.screenNr >= 0 ? (cols[colMap.screenNr] ?? '') : '',
      searchWord: cols[colMap.searchWord] ?? '',
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

  return processRows(rows, isNewFormat, hasBothLangs);
}

/** Column index mapping for text/CSV parsing. */
interface ColumnMapping {
  identity: number;
  screenNr: number; // -1 if not present
  searchWord: number;
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
    return { identity: 0, screenNr: -1, searchWord: 1, textGerman: 2, textEnglish: 3, meaning: 7, displayedMeaning: 8, variableName: 6, skip: 5, writeProtect: -1, inTableSection: -1 };
  }

  const find = (needles: string[]): number =>
    headerCols.findIndex((h) => needles.some((n) => h.includes(n)));

  const identityIdx = find(['identity']);
  const searchWordIdx = find(['search word', 'suchwort']);
  const meaningIdx = find(['meaning']);
  const displayedIdx = headerCols.findIndex((h, i) => i !== meaningIdx && h.includes('meaning') && h.includes('displayed'));
  const varNameIdx = find(['variable name', 'variablenname']);
  const skipIdx = find(['skip']);
  const textGermanIdx = find(['text in german', 'text in deutsch']);
  const textEnglishIdx = find(['text in english', 'text in englisch']);
  const descOpIdx = find(['description in operating', 'beschreibung in betrieb']);
  const descIdx = headerCols.findIndex((h, i) =>
    i !== descOpIdx && (h === 'description' || h === 'beschreibung')
  );
  const writeProtectIdx = find(['write-protect', 'write protect', 'schreibschutz']);
  const inTableSectionIdx = find(['variable in table section', 'variable im tabellenteil']);
  const screenNrIdx = find(['number of 1st screen', 'nummer des 1. bildschirms', 'bildschirm']);

  return {
    identity: identityIdx >= 0 ? identityIdx : 0,
    screenNr: screenNrIdx >= 0 ? screenNrIdx : -1,
    searchWord: searchWordIdx >= 0 ? searchWordIdx : 1,
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

/** Check if tables need re-import for bilingual support.
 *  Only warns if the majority of database tables lack nameDe. */
export function tablesNeedReimport(tables: TableDef[]): boolean {
  const dbs = tables.filter((t) => t.kind === 'database');
  if (dbs.length === 0) return false;
  const missingCount = dbs.filter((t) => !t.nameDe).length;
  return missingCount > dbs.length / 2;
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

      const existingByName = new Map(existing.fields.map((f) => [f.name, f]));
      for (const f of t.fields) {
        const ef = existingByName.get(f.name);
        if (ef) {
          if (f.descriptionDe) ef.descriptionDe = f.descriptionDe;
          if (f.descriptionEn) ef.descriptionEn = f.descriptionEn;
          if (f.description) ef.description = f.description;
          // Always update structural flags from new import
          ef.isTableField = f.isTableField;
          ef.skip = f.skip;
          ef.readonly = f.readonly;
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
