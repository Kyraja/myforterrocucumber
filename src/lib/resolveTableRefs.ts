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
  tableRef: string;
}

/**
 * Build lookup structures from table definitions.
 */
function buildLookups(tables: TableDef[]) {
  const databases: TableEntry[] = [];
  const infosystems: TableEntry[] = [];

  for (const t of tables) {
    if (t.kind === 'database') {
      databases.push({ name: t.name, tableRef: t.tableRef });
    } else {
      infosystems.push({ name: t.name, tableRef: t.tableRef });
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

  // 1. Exact name match
  const exact = entries.find((e) => e.name.toLowerCase() === s);
  if (exact) return exact.tableRef;

  // 2. Synonym lookup
  const synonyms = ABAS_SYNONYMS[s];
  if (synonyms) {
    for (const syn of synonyms) {
      const synMatch = entries.find((e) => e.name.toLowerCase() === syn);
      if (synMatch) return synMatch.tableRef;
    }
  }

  // 3. Substring: search term contains table name or vice versa
  const substringMatch = entries.find((e) => {
    const eName = e.name.toLowerCase();
    return s.includes(eName) || eName.includes(s);
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
      const resolved = findMatch(action.tableRef, databases);
      if (!resolved) return action;
      return { ...action, tableRef: resolved };
    }

    case 'infosystemOeffnen': {
      // For infosystems, the AI might use the display name — resolve to Suchwort
      if (isNumericRef(action.infosystemRef)) return action;
      const resolved = findMatch(action.infosystemName, infosystems);
      if (resolved && resolved !== action.infosystemRef) {
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
