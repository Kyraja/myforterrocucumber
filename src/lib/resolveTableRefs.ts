/**
 * @module resolveTableRefs
 *
 * Resolves human-readable abas ERP table and infosystem names in AI-generated
 * steps to their canonical numeric references ("D:G" format, e.g. "0:1").
 *
 * The AI is instructed to use descriptive names like "Kundenstamm" or
 * "Verkaufsauftrag" instead of numeric refs. This module looks up those
 * names against the consultant's loaded Variablentabelle (table definitions)
 * and replaces them with the correct refs so the Gherkin output is valid.
 *
 * Matching priority: exact tableRef → exact name → synonym → substring.
 * V-Notation (V-12-03) and P-Notation (P12:3) are normalised to D:G format
 * before lookup, so consultants can paste refs from any abas screen.
 *
 * Entry point: {@link resolveTableRefs}
 */

import type { FeatureInput, TableDef, StepAction } from '../types/gherkin';

// Common abas ERP synonyms for fuzzy matching (AI name → possible table names)
const ABAS_SYNONYMS: Record<string, string[]> = {
  'artikelstamm': ['artikel', 'teile', 'teilestamm'],
  'teilestamm': ['teile', 'artikel'],
  'produkt': ['artikel', 'teile'],
  'kundenstamm': ['kunde', 'kunden'],
  'debitor': ['kunde', 'kunden'],
  'lieferantenstamm': ['lieferant', 'lieferanten'],
  'kreditor': ['lieferant', 'lieferanten'],
  'verkaufsauftrag': ['verkaufsauftrag', 'auftrag'],
  'auftrag': ['verkaufsauftrag', 'auftrag'],
  'lieferschein': ['lieferschein', 'lieferung'],
  'rechnung': ['rechnung', 'ausgangsrechnung'],
  'einkaufsbestellung': ['einkaufsbestellung', 'bestellung'],
  'bestellung': ['einkaufsbestellung', 'bestellung'],
  'bestellvorschlag': ['bestellvorschlag'],
  'eingangsrechnung': ['eingangsrechnung', 'einkaufsrechnung'],
  'fertigungsauftrag': ['fertigungsauftrag', 'betriebsauftrag'],
};

interface TableEntry {
  name: string;
  names: string[];  // all name variants for matching
  tableRef: string;
}

/**
 * Build lookup structures from table definitions.
 */
function buildLookups(tables: TableDef[]) {
  const databases: TableEntry[] = [];
  const infosystems: TableEntry[] = [];

  for (const t of tables) {
    const names = [t.name, t.nameDe, t.nameEn].filter((n): n is string => !!n?.trim());
    const entry: TableEntry = { name: t.name, names, tableRef: t.tableRef };
    if (t.kind === 'database') {
      databases.push(entry);
    } else {
      infosystems.push(entry);
    }
  }

  return { databases, infosystems };
}

/**
 * Fuzzy-match a name against table entries.
 * Tries: exact → synonym → substring containment.
 */
function findMatch(search: string, entries: TableEntry[]): string | undefined {
  const s = search.toLowerCase().trim();

  // 0. Exact tableRef match (e.g. search is already the Suchwort like "BESTAND")
  const refMatch = entries.find((e) => e.tableRef.toLowerCase() === s);
  if (refMatch) return refMatch.tableRef;

  // 1. Exact name match (checks name, nameDe, nameEn)
  const exact = entries.find((e) => e.names.some((n) => n.toLowerCase() === s));
  if (exact) return exact.tableRef;

  // 2. Synonym lookup
  const synonyms = ABAS_SYNONYMS[s];
  if (synonyms) {
    for (const syn of synonyms) {
      const synMatch = entries.find((e) => e.names.some((n) => n.toLowerCase() === syn));
      if (synMatch) return synMatch.tableRef;
    }
  }

  // 3. Substring: search term contains table name or vice versa
  const substringMatch = entries.find((e) => {
    return e.names.some((n) => {
      const eName = n.toLowerCase();
      return s.includes(eName) || eName.includes(s);
    });
  });
  if (substringMatch) return substringMatch.tableRef;

  return undefined;
}

/**
 * Checks if a value looks like a numeric table reference (e.g. "0:1", "2:5").
 * If it does, it's already resolved and should not be overwritten.
 */
function isNumericRef(ref: string): boolean {
  return /^\d+:\d+$/.test(ref);
}

/**
 * Normalize V-Notation (e.g. "V-12-03") or P-Notation (e.g. "P12:3") to "D:G" format.
 * Returns the normalized ref or null if the input is not a recognized notation.
 */
function normalizeVNotation(ref: string): string | null {
  // V-Notation: V-02-01 → 2:1, V-12-03 → 12:3
  const vMatch = ref.match(/^V-?(\d+)-(\d+)$/i);
  if (vMatch) {
    return `${parseInt(vMatch[1], 10)}:${parseInt(vMatch[2], 10)}`;
  }
  // P-Notation: P2:1 → 2:1
  const pMatch = ref.match(/^P(\d+:\d+)$/i);
  if (pMatch) {
    return pMatch[1];
  }
  return null;
}

/**
 * Resolves name-based table/infosystem references in AI-generated steps
 * to actual numeric references from the loaded Variablentabelle.
 *
 * The AI is instructed to use names (e.g. "Kundenstamm", "Verkaufsauftrag")
 * instead of numeric refs (e.g. "0:1", "2:5"). This function looks up
 * those names in the loaded table definitions and replaces them.
 *
 * Steps that already have numeric refs or whose names can't be found
 * are left unchanged.
 */
export function resolveTableRefs(feature: FeatureInput, tables: TableDef[]): FeatureInput {
  if (tables.length === 0) return feature;

  const { databases, infosystems } = buildLookups(tables);

  const scenarios = feature.scenarios.map((scenario) => ({
    ...scenario,
    steps: scenario.steps.map((step) => {
      const resolved = resolveAction(step.action, databases, infosystems);
      if (resolved === step.action) return step;

      // Also update the step text to reflect the resolved ref
      return { ...step, action: resolved, text: stepTextFromResolvedAction(resolved, step.text) };
    }),
  }));

  return { ...feature, scenarios };
}

function resolveAction(
  action: StepAction,
  databases: TableEntry[],
  infosystems: TableEntry[],
): StepAction {
  switch (action.type) {
    case 'editorOeffnen':
    case 'editorOeffnenSuche':
    case 'editorOeffnenMenue': {
      if (isNumericRef(action.tableRef)) return action;
      // Try V-Notation / P-Notation first (e.g. V-12-03 → 12:3)
      const normalized = normalizeVNotation(action.tableRef);
      if (normalized) return { ...action, tableRef: normalized };
      // Otherwise fuzzy-match by name
      const resolved = findMatch(action.tableRef, databases);
      if (!resolved) return action;
      return { ...action, tableRef: resolved };
    }

    case 'infosystemOeffnen': {
      // For infosystems, the AI might use the display name — resolve to Suchwort (tableRef).
      // If infosystemRef already matches a known tableRef, it's already the Suchwort — keep it.
      const alreadyResolved = infosystems.some((e) => e.tableRef.toLowerCase() === action.infosystemRef.toLowerCase());
      if (alreadyResolved) {
        // Ensure correct casing
        const exact = infosystems.find((e) => e.tableRef.toLowerCase() === action.infosystemRef.toLowerCase());
        if (exact && exact.tableRef !== action.infosystemRef) {
          return { ...action, infosystemRef: exact.tableRef };
        }
        return action;
      }
      // Try to resolve the name to a Suchwort
      const resolved = findMatch(action.infosystemName, infosystems);
      if (resolved) {
        return { ...action, infosystemRef: resolved };
      }
      return action;
    }

    default:
      return action;
  }
}

/**
 * Updates the step text to replace the name-based table ref with the numeric ref.
 * Only replaces in known patterns to avoid false matches.
 */
function stepTextFromResolvedAction(action: StepAction, originalText: string): string {
  switch (action.type) {
    case 'editorOeffnen':
      return `I open an editor "${action.editorName}" from table "${action.tableRef}" with command "${action.command}" for record "${action.record}"`;
    case 'editorOeffnenSuche':
      return `I open an editor "${action.editorName}" from table "${action.tableRef}" with command "${action.command}" for search criteria "${action.searchCriteria}"`;
    case 'editorOeffnenMenue':
      return `I open an editor "${action.editorName}" from table "${action.tableRef}" with command "${action.command}" for record "${action.record}" and menu choice "${action.menuChoice}"`;
    case 'infosystemOeffnen':
      return `I open the infosystem "${action.infosystemRef}"`;
    default:
      return originalText;
  }
}
