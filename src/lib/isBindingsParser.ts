/**
 * @module isBindingsParser
 *
 * Parser for the EFOP program bindings that come as **additional columns**
 * inside an abas Infosystem variable-table export (CSV / XLSX). Unlike the
 * mask bindings in `FOP.txt` (handled in `fopTxtParser.ts`), infosystem EFOP
 * bindings are not a separate file — they live in the same export that also
 * carries the field definitions.
 *
 * The parser recognises both German and English column headers (substring
 * match, lower-case). Output is a flat list of `IsBinding` records; scope is
 * derived from the event type (Maskeneintritt/Feldprüfung/... → Kopf,
 * Zeile-einfügen/-löschen/... → Tabelle, field-level events → unbekannt).
 */
import * as XLSX from 'xlsx';

// Which events are field-level (need field name) vs mask-level
const FIELD_LEVEL_EVENTS = new Set(['FV', 'FX', 'FF', 'BB', 'BA']);
// Which events are always table-level (Tabelle)
const TABLE_LEVEL_EVENTS = new Set(['RIB', 'RIA', 'RDB', 'RDA', 'RH', 'RMB', 'RMA']);
// Which events are always header-level (Kopf)
const HEADER_LEVEL_EVENTS = new Set(['SE', 'SEE', 'SV', 'SC', 'SX', 'BFUSS']);

// IS export EFOP column name → event short code.
// Matched via substring (col.includes(key)), so list longer/more specific keys
// when a shorter one could falsely match. Lower-case only.
const IS_EFOP_COL_MAP: Record<string, string> = {
  // ── German column headers ─────────────────────────────────
  'maskeneintritts': 'SE',
  'maskenende': 'SEE',
  'maskenprüfungs': 'SV',
  'maskenpruefungs': 'SV',
  'maskenabbruch': 'SC',
  'maskenaustritts': 'SX',
  'feldprüfungs': 'FV',
  'feldpruefungs': 'FV',
  'feldaustritts': 'FX',
  'feld-ausgefüllt': 'FF',
  'feld-ausgefuellt': 'FF',
  'button-vor': 'BB',
  'button-nach': 'BA',
  'zeile-einfügen-vor': 'RIB',
  'zeile-einfuegen-vor': 'RIB',
  'zeile-einfügen-nach': 'RIA',
  'zeile-einfuegen-nach': 'RIA',
  'zeile-löschen-vor': 'RDB',
  'zeile-loeschen-vor': 'RDB',
  'zeile-löschen-nach': 'RDA',
  'zeile-loeschen-nach': 'RDA',
  'zeile-markieren': 'RH',
  'zeilen-verschieben-vor': 'RMB',
  'zeilen-verschieben-prüf': 'RMB',
  'zeilen-verschieben-nach': 'RMA',
  'berichtsfuß': 'BFUSS',
  'berichtsfuss': 'BFUSS',
  // ── English column headers ────────────────────────────────
  'enter screen': 'SE',
  'end of screen': 'SEE',
  'screen validation': 'SV',
  'cancel screen': 'SC',
  'exit screen': 'SX',
  'field validation': 'FV',
  'exit field': 'FX',
  'field filled': 'FF',
  'button (before)': 'BB',
  'button (after)': 'BA',
  'insert-row-before': 'RIB',
  'insert-row-after': 'RIA',
  'delete-row-before': 'RDB',
  'delete-row-after': 'RDA',
  'select-row': 'RH',
  'move-rows-before': 'RMB',
  'move-rows-to': 'RMA',
  'footer': 'BFUSS',
};

const EVENT_LONG_MAP: Record<string, string> = {
  'SE': 'maskein', 'SEE': 'maskende', 'SV': 'maskpruef',
  'SC': 'maskabbr', 'SX': 'maskaus',
  'FV': 'feldpruef', 'FX': 'feldaus', 'FF': 'feldfuell',
  'BB': 'buttonvor', 'BA': 'buttonnach',
  'RIB': 'zeileeinvor', 'RIA': 'zeileeinnach',
  'RDB': 'zeileausvor', 'RDA': 'zeileausnach',
  'RH': 'zeilemarkiert',
  'RMB': 'zeilebewvor', 'RMA': 'zeilebewnach',
  'BFUSS': 'berichtsfuss',
};

/**
 * A single EFOP binding extracted from an abas infosystem export.
 * Equivalent to `FopBinding` for standard EFOPs, but carries the infosystem
 * search word and name instead of a mask number.
 */
export interface IsBinding {
  isName: string;
  isSearchWord: string;
  event: string;            // Short event code (SE, FV, etc.)
  eventLong: string;        // Long event name (maskein, feldpruef, etc.)
  fopPath: string;
  field?: string;           // Variable name for field-level events (FV, FX, FF, BB, BA)
  scope: 'K' | 'T' | '*';  // Kopf / Tabelle / unbekannt (derived from event type)
}

/**
 * Reads an abas Infosystem export as XLSX buffer and extracts IS bindings.
 * Internally converts the first sheet to a tab-separated string and delegates
 * to `parseIsExportBindings`.
 */
export function parseIsExportBindingsFromXlsx(buffer: ArrayBuffer): IsBinding[] {
  const workbook = XLSX.read(buffer, { type: 'array' });
  const sheet = workbook.Sheets[workbook.SheetNames[0]];
  if (!sheet) return [];
  const tsv = XLSX.utils.sheet_to_csv(sheet, { FS: '\t' });
  return parseIsExportBindings(tsv);
}

/**
 * Parses the abas Infosystem export (tab- or semicolon-separated) and extracts
 * EFOP program bindings (Maskeneintritts-EFOP, Feldprüfungs-EFOP etc.) from
 * the EFOP columns embedded in the variable-table export.
 */
export function parseIsExportBindings(content: string): IsBinding[] {
  const lines = content.split('\n').map(l => l.trimEnd()).filter(Boolean);
  if (lines.length < 2) return [];

  const sep = lines[0].includes('\t') ? '\t' : ';';
  const headerCols = lines[0].split(sep).map(c => c.trim().toLowerCase());

  // Find EFOP columns by matching against IS_EFOP_COL_MAP keys
  const efopColumns: Array<{ colIdx: number; eventShort: string; eventLong: string }> = [];

  for (let i = 0; i < headerCols.length; i++) {
    const col = headerCols[i]
      .replace(/-efop$/, '')   // strip "-efop" suffix
      .replace(/\s+efop$/, '') // strip " efop" suffix
      .trim();

    for (const [key, eventShort] of Object.entries(IS_EFOP_COL_MAP)) {
      if (col.includes(key) || col === key) {
        efopColumns.push({
          colIdx: i,
          eventShort,
          eventLong: EVENT_LONG_MAP[eventShort] ?? eventShort.toLowerCase(),
        });
        break;
      }
    }
  }

  if (efopColumns.length === 0) return [];

  // Find search word, name and variable name columns
  const swIdx = headerCols.findIndex(h => h.includes('suchwort') || h.includes('search word'));
  const nameIdx = headerCols.findIndex(h => h.includes('text in deutsch') || h.includes('text in german') || (h.includes('name') && !h.includes('variable')));
  const varNameIdx = headerCols.findIndex(h => h.includes('variablenname') || h.includes('variable name'));

  const results: IsBinding[] = [];
  // For mask-level events: deduplicate by IS+event (same value across all rows)
  // For field-level events: deduplicate by IS+event+field (per-row)
  const seen = new Set<string>();

  for (let i = 1; i < lines.length; i++) {
    const cols = lines[i].split(sep);
    const isSearchWord = (swIdx >= 0 ? cols[swIdx] : cols[1] ?? '').trim();
    const isName = (nameIdx >= 0 ? cols[nameIdx] : cols[2] ?? '').trim();
    const varName = varNameIdx >= 0 ? (cols[varNameIdx] ?? '').trim() : '';

    if (!isSearchWord) continue;

    for (const efopCol of efopColumns) {
      const fopPath = (cols[efopCol.colIdx] ?? '').trim();
      if (!fopPath) continue;

      const isFieldLevel = FIELD_LEVEL_EVENTS.has(efopCol.eventShort);
      const field = isFieldLevel ? varName || undefined : undefined;
      const scope: 'K' | 'T' | '*' = HEADER_LEVEL_EVENTS.has(efopCol.eventShort)
        ? 'K'
        : TABLE_LEVEL_EVENTS.has(efopCol.eventShort)
          ? 'T'
          : '*'; // field-level events: K/T depends on field itself

      // Deduplication key differs: mask-level by IS+event, field-level by IS+event+field
      const key = isFieldLevel
        ? `${isSearchWord}|${efopCol.eventShort}|${varName}|${fopPath}`
        : `${isSearchWord}|${efopCol.eventShort}|${fopPath}`;
      if (seen.has(key)) continue;
      seen.add(key);

      results.push({
        isName: isName || isSearchWord,
        isSearchWord,
        event: efopCol.eventShort,
        eventLong: efopCol.eventLong,
        field,
        scope,
        fopPath,
      });
    }
  }

  return results;
}
