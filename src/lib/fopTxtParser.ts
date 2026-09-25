/**
 * Parser for the abas `FOP.txt` mask binding configuration.
 *
 * `FOP.txt` is the traditional space-delimited configuration that wires
 * mask+command+event+field combinations to FOP program paths. Supports both
 * the 7-token format (no bracket) and the 8-token `[C]`/`[S]` format.
 *
 * Helper exports provide mask filtering, sorted unique mask lists, and
 * human-readable binding labels used by the usage index.
 *
 * Infosystem EFOP bindings live in the variable-table CSV/XLSX export and are
 * parsed separately by `isBindingsParser.ts`.
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
