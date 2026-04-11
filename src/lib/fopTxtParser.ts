/**
 * Parsers for the two abas FOP binding configuration formats.
 *
 * 1. **FOP.txt** (`parseFopTxt`): The traditional space-delimited configuration
 *    that wires mask+command+event+field combinations to FOP program paths.
 *    Supports both the 7-token format (no bracket) and the 8-token `[C]`/`[S]`
 *    format.
 *
 * 2. **Infosystem export** (`parseIsExportBindings`): The tab- or semicolon-
 *    separated export from the abas infosystem administration, which lists EFOP
 *    columns per infosystem row.  Converts the column headers to event short
 *    codes and deduplicates mask-level vs. field-level bindings.
 *
 * Helper exports provide mask filtering, sorted unique mask lists, and
 * human-readable binding labels used by the usage index.
 */
import type { FopBinding } from '../types/fop';

const EVENT_MAP: Record<string, string> = {
  'maskein': 'SE', 'maskpruef': 'SV', 'maskaus': 'SX',
  'maskabbr': 'SC', 'maskende': 'SEE',
  'feldfuell': 'FF', 'feldpruef': 'FV', 'feldaus': 'FX',
  'feldein': 'FE',
  'buttonvor': 'BB', 'buttonnach': 'BA',
  'zeileeinvor': 'RIB', 'zeileeinnach': 'RIA',
  'zeileausvor': 'RDB', 'zeileausnach': 'RDA',
  'zeilebewvor': 'RMB', 'zeilebewnach': 'RMA',
  'zeilemarkiert': 'RH',
};

// IS export EFOP column name → event short code
const IS_EFOP_COL_MAP: Record<string, string> = {
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
};

// ── FOP.txt ────────────────────────────────────────────────

/**
 * Parse the contents of an abas `FOP.txt` configuration file into structured
 * `FopBinding` records.
 *
 * Each non-comment, non-empty line is expected to have the form:
 * ```
 * maskNr  command  event  key  field  scope  [C|S]  fopPath
 * ```
 * The `[C]`/`[S]` bracket token is optional — lines without it are treated as
 * `[S]` (stop search).
 *
 * @param content - Raw file content of `FOP.txt`
 * @returns Array of parsed bindings; malformed lines are silently skipped
 */
export function parseFopTxt(content: string): FopBinding[] {
  const bindings: FopBinding[] = [];

  for (const rawLine of content.split('\n')) {
    const line = rawLine.trim();
    // Skip empty lines and comment lines (.. or # are both used)
    if (!line || line.startsWith('..') || line.startsWith('#')) continue;

    const tokens = line.split(/\s+/).filter(Boolean);
    // Minimum: maskNr cmd event key field scope fopPath (7 without bracket, 8 with)
    if (tokens.length < 7) continue;

    let maskStr: string, command: string, event: string, key: string, field: string, scope: string;
    let bracket: string, fopPath: string;

    // Detect if token[6] is a bracket [C]/[S] or already the FOP path
    const tok6 = tokens[6] ?? '';
    if (tok6.startsWith('[') && (tok6.includes('C') || tok6.includes('S'))) {
      // 8-token format: mask cmd event key field scope [C/S] fopPath...
      [maskStr, command, event, key, field, scope, bracket] = tokens;
      fopPath = tokens.slice(7).join(' ').trim();
    } else if (tokens.length >= 7) {
      // 7-token format without bracket: mask cmd event key field scope fopPath...
      [maskStr, command, event, key, field, scope] = tokens;
      bracket = '[S]';
      fopPath = tokens.slice(6).join(' ').trim();
    } else {
      continue;
    }

    if (!fopPath) continue;

    const mask = maskStr === '*' ? '*' as const : parseInt(maskStr, 10);
    if (typeof mask === 'number' && isNaN(mask)) continue;

    const continueSearch = bracket.toUpperCase().includes('C');
    const eventLower = event.toLowerCase();
    const eventShort = EVENT_MAP[eventLower] ?? event.toUpperCase();

    bindings.push({
      mask,
      command: command.toUpperCase(),
      event: eventLower,
      eventShort,
      key,
      field,
      scope: (scope.toUpperCase() as 'K' | 'T' | '*'),
      continueSearch,
      fopPath,
    });
  }

  return bindings;
}

// ── Infosystem export → IS program bindings ────────────────

// Which events are field-level (need field name) vs mask-level
const FIELD_LEVEL_EVENTS = new Set(['FV', 'FX', 'FF', 'BB', 'BA']);
// Which events are always table-level (Tabelle)
const TABLE_LEVEL_EVENTS = new Set(['RIB', 'RIA', 'RDB', 'RDA', 'RH', 'RMB', 'RMA']);
// Which events are always header-level (Kopf)
const HEADER_LEVEL_EVENTS = new Set(['SE', 'SEE', 'SV', 'SC', 'SX', 'BFUSS']);

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
 * Parses the abas Infosystem export (tab-separated) and extracts
 * EFOP program bindings (Maskeneintritts-EFOP, Feldprüfungs-EFOP etc.)
 */
export function parseIsExportBindings(content: string): IsBinding[] {
  const lines = content.split('\n').map(l => l.trimEnd()).filter(Boolean);
  if (lines.length < 2) return [];

  const sep = lines[0].includes('\t') ? '\t' : ';';
  const headerCols = lines[0].split(sep).map(c => c.trim().toLowerCase());

  // Find EFOP columns by matching against IS_EFOP_COL_MAP keys
  const efopColumns: Array<{ colIdx: number; eventShort: string; eventLong: string }> = [];
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

// ── Helpers ───────────────────────────────────────────────

/**
 * Extract a sorted list of unique numeric mask numbers from a set of bindings.
 * Wildcard (`*`) bindings are excluded.
 *
 * @param bindings - All parsed FOP.txt bindings
 */
export function getUniqueMasks(bindings: FopBinding[]): number[] {
  const masks = new Set<number>();
  for (const b of bindings) {
    if (typeof b.mask === 'number') masks.add(b.mask);
  }
  return Array.from(masks).sort((a, b) => a - b);
}

/**
 * Filter bindings to those applicable to a specific mask number.
 * Includes both exact-match and wildcard (`*`) bindings.
 *
 * @param bindings - All parsed FOP.txt bindings
 * @param mask - Numeric mask number to filter for
 */
export function getBindingsForMask(bindings: FopBinding[], mask: number): FopBinding[] {
  return bindings.filter(b => b.mask === mask || b.mask === '*');
}

/**
 * Generate a short human-readable label for a FOP binding (e.g. `"Maske 32 — FV:kart"`).
 * Used in the usage index chain labels and in the UI binding list.
 *
 * @param binding - The FOP.txt binding to label
 * @param lang - Output language
 */
export function getBindingLabel(binding: FopBinding, lang: 'de' | 'en' = 'de'): string {
  const maskPart = typeof binding.mask === 'number'
    ? `${lang === 'de' ? 'Maske' : 'Mask'} ${binding.mask}`
    : lang === 'de' ? 'Alle Masken' : 'All Masks';
  const eventPart = binding.field !== '*' && binding.field !== '-'
    ? `${binding.eventShort}:${binding.field}`
    : binding.eventShort;
  return `${maskPart} — ${eventPart}`;
}
