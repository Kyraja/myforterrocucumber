/**
 * Scheduling shortcut: detects requirement texts that ask ONLY for the abas
 * "Scheduling" typed command (Disposition starten / Tippkommando Scheduling)
 * and bypasses the AI to emit the canonical single-step feature directly.
 *
 * Also rewrites AI artifacts where the model wrapped a Scheduling request into
 * an editor-open with `for tip command "Scheduling"` (a wrong syntax for this
 * use case — see aiPrompt.ts) back into the canonical tip-command pattern.
 */
import type { FeatureInput, Scenario, Step, StepKeyword } from '../types/gherkin';

/** Words that — even appearing once — disqualify a "Scheduling-only" classification. */
const FORBIDDEN_TOKENS: ReadonlySet<string> = new Set([
  // German verbs that imply concrete data work
  'anlegen', 'anlege', 'anzulegen',
  'erstellen', 'erstelle', 'zu erstellen',
  'kopieren', 'kopiere',
  'aendern', 'ändern', 'aendere', 'ändere', 'geaendert', 'geändert',
  'pruefen', 'prüfen', 'pruefe', 'prüfe', 'geprueft', 'geprüft',
  'anhaken', 'anhake',
  'druecken', 'drücken', 'drücke', 'druecke',
  'setzen', 'setze', 'gesetzt',
  'klicken', 'klicke',
  'waehlen', 'wählen', 'waehle', 'wähle', 'auswaehlen', 'auswählen',
  'oeffnen', 'öffnen', 'oeffne', 'öffne',
  'speichern', 'speichere',
  'schliessen', 'schließen',
  'loeschen', 'löschen', 'loesche', 'lösche',
  'eintragen', 'eintrage',
  'buchen', 'buche', 'verbuchen',
  'freigeben', 'freigegeben',
  'stornieren', 'storniere',
  // German concrete entities
  'auftrag', 'aufträge', 'auftraege',
  'bestellung', 'bestellungen',
  'lieferschein', 'lieferscheine',
  'rechnung', 'rechnungen',
  'artikel', 'artikels',
  'kunde', 'kunden', 'kundennummer',
  'lieferant', 'lieferanten',
  'stueckliste', 'stückliste', 'stuecklisten', 'stücklisten',
  'fertigung', 'fertigungsauftrag',
  'einkauf', 'verkauf', 'lager', 'bestand', 'mengen',
  'datensatz', 'datensätze', 'datensaetze',
  'maske', 'feld', 'felder', 'editor',
  // English equivalents
  'create', 'created', 'modify', 'modified',
  'check', 'checked', 'verify', 'verified',
  'press', 'pressed', 'click', 'clicked',
  'select', 'selected', 'save', 'saved',
  'close', 'closed', 'open', 'opened',
  'order', 'orders', 'invoice', 'invoices',
  'customer', 'customers', 'supplier', 'suppliers',
  'article', 'articles', 'item', 'items',
  'record', 'records', 'field', 'fields', 'mask', 'editor',
]);

/**
 * Returns true when the requirement text is *purely* about triggering the abas
 * Disposition / Scheduling typed command and does not describe any other data
 * manipulation. Such texts should bypass the AI and produce a one-step feature.
 *
 * Examples that match:
 *   - "Dispo starten. (Tippkommando - (Scheduling))"
 *   - "Disposition starten"
 *   - "Tippkommando Scheduling ausführen"
 *
 * Examples that do NOT match (because they mix Scheduling with other actions):
 *   - "Auftrag anlegen, dann Disposition starten und Bestand prüfen"
 *   - "Im Editor X auf Y klicken und dann Scheduling triggern"
 */
export function isSchedulingOnlyRequirement(text: string): boolean {
  const lower = text.toLowerCase();
  if (!lower.trim()) return false;
  // Conservative length cap — anything longer than this is almost certainly mixed.
  if (lower.length > 250) return false;
  if (!/\b(scheduling|dispo(?:sition)?)\b/.test(lower)) return false;

  const tokens = new Set(
    lower
      .replace(/[.,;:!?()\[\]{}\-—–\/\\"'`*<>=]/g, ' ')
      .split(/\s+/)
      .filter(Boolean)
  );
  for (const t of tokens) {
    if (FORBIDDEN_TOKENS.has(t)) return false;
  }
  return true;
}

/** Build the canonical two-step Scheduling feature shown in the editor. */
export function makeSchedulingOnlyFeature(featureName?: string): FeatureInput {
  const name = featureName?.trim() || 'Disposition starten';
  return {
    name,
    description: '',
    tags: [],
    database: null,
    testUser: '',
    scenarios: [
      {
        id: crypto.randomUUID(),
        name: 'Disposition starten per Tippkommando (Scheduling)',
        steps: [
          {
            id: crypto.randomUUID(),
            keyword: 'Given',
            text: 'I open an editor "dispo" for tip command "(Scheduling)" and arguments ""',
            action: { type: 'editorOeffnenTipp', editorName: 'dispo', tipCommand: '(Scheduling)', arguments: '' },
          },
          {
            id: crypto.randomUUID(),
            keyword: 'And',
            text: 'I close the current editor',
            action: { type: 'editorSchliessen' },
          },
        ],
      },
    ],
  };
}

/**
 * Rewrite AI artifacts where the model mixed "from table"/"with command" with
 * "for tip command" for Scheduling. Replaces such scenarios with the canonical
 * two-step pattern: open via tip command + close.
 */
export function cleanSchedulingArtifacts(feature: FeatureInput): FeatureInput {
  let changed = false;
  const scenarios: Scenario[] = feature.scenarios.map((scen) => {
    // Detect wrong pattern: "from table ... for tip command ... Scheduling"
    const hasBadScheduling = scen.steps.some((s) =>
      /from table.*for tip command\s+.*scheduling/i.test(s.text) ||
      /with command.*for tip command\s+.*scheduling/i.test(s.text),
    );
    if (!hasBadScheduling) return scen;
    changed = true;
    const openStep: Step = {
      id: crypto.randomUUID(),
      keyword: 'Given',
      text: 'I open an editor "dispo" for tip command "(Scheduling)" and arguments ""',
      action: { type: 'editorOeffnenTipp', editorName: 'dispo', tipCommand: '(Scheduling)', arguments: '' },
    };
    const closeStep: Step = {
      id: crypto.randomUUID(),
      keyword: 'And',
      text: 'I close the current editor',
      action: { type: 'editorSchliessen' },
    };
    return { ...scen, steps: [openStep, closeStep] };
  });
  return changed ? { ...feature, scenarios } : feature;
}
