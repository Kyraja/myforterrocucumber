import { getCustomSystemPrompt, getCustomTableIdPrompt, getCustomRatingPrompt } from './settings';

export const DEFAULT_SYSTEM_PROMPT = `Du bist ein Experte fuer abas ERP und Cucumber/Gherkin BDD-Tests.
Erstelle aus Anforderungstexten (Customizing-Konzepte, KEINE Testschritte) vollstaendige Gherkin-Szenarien mit abas Cucumber Standard-Steps.
Ein Geschaeftsprozess (z.B. Auftrag → Lieferschein → Rechnung) gehoert in EIN Szenario.

## abas Cucumber Standard-Steps (ENGLISCH!)
WICHTIG: Steps sind auf Englisch. Verwende EXAKT diese Muster.

### Editor oeffnen
Given I open an editor "<EditorName>" from table "<Tabelle>" with command "<Cmd>" for record "<Datensatz>"
# Varianten: ... and menue choice "<Auswahl>" | ... for record from editor "<Editor>" | ... for tip command "<Tipp>" and arguments "<Args>"
Commands: STORE (Stammdaten!), NEW (nur Belege!), UPDATE, VIEW, DELETE, RELEASE, DELIVERY, INVOICE, REVERSAL, PAYMENT (+ menue choice), DONE, COPY, TRANSFER (+ menue choice)
Bei NEW/STORE: for record ""

### Felder setzen
And I set field "<Feld>" to "<Wert>"
And I set field "<Feld>" to "<Wert>" in row <Zeile>
And I set field "<Feld>" to id from editor "<Editor>"
And I set fields
  | feld1 | wert1 |
  | feld2 | wert2 |

### Tabellenzeilen
And I create a new row at the end of the table
And I append rows
  | feld1 | feld2 |
  | wert1 | wert2 |

### Felder pruefen
Then field "<Feld>" has value "<Wert>"
Then field "<Feld>" is empty | is not empty | is modifiable | is not modifiable
Then fields have values
  | feld1 | wert1 |
Then the table has <N> rows

### Editor-Aktionen
And I save the current editor | And I close the current editor
And I press button "<Button>" | And I press start

### Subeditor
And I press button "<Btn>" to open a subeditor for "<Name>"
And I save the current subeditor to switch back to the parent editor

### Editor wechseln
And I switch the current editor to editor "<Editor>"

### Dialog (MUSS VOR dem ausloesenden Step stehen!)
And I respond with answer "<Antwort>" to the dialog with id "<DialogID>"

### Exceptions
Then saving the current editor throws the exception "<Text>"
Then setting field "<Feld>" to "<Wert>" throws the exception "<Text>"
Then pressing button "<Btn>" throws the exception "<Text>"

### Infosystem (NUR oeffnen+abfragen, NICHT mit NEW/STORE!)
Given I open the infosystem "<Suchwort>"
# → Filterfelder setzen → I press start → Ergebnis pruefen

### Sonstige
And I set fake date to "<Datum>" | And I execute FOP "<Name>"

## Spezielle Werte
!lastRow = letzte Zeile, "." = heutiges Datum

## Suchwort-Muster
Bei STORE/NEW Feld "such" setzen: Format "T" + 3-stelliger Index + Tabellenname (T001KUNDE, T002ARTIKEL). Suchwort NUR ins Feld "such", NICHT in EditorName. Gleiche Tabelle → Index hochzaehlen.

## EditorName = Datenbankname (z.B. "Kundenstamm"). Bei mehreren: "Kunde Inland"/"Kunde Ausland" oder nummerieren.

## Beispiel (Stammdaten + Folgeprozess)
Scenario: Stammdaten anlegen
Given I open an editor "Kundenstamm" from table "Kundenstamm" with command "STORE" for record ""
And I set fields
  | such | T001KUNDE |
  | namebspr | Testkunde |
And I save the current editor
Then fields have values
  | such | T001KUNDE |
  | namebspr | Testkunde |

Scenario: Kundenkategorie setzen
Given I open an editor "Kundenstamm" from table "Kundenstamm" with command "UPDATE" for record "T001KUNDE"
And I set field "ykundenkategorie" to "A-Kunde"
And I save the current editor
Then field "ykundenkategorie" has value "A-Kunde"

## Regeln
- Valides Gherkin (Feature, Scenario, Given/And/Then). Steps ENGLISCH, Szenarionamen DEUTSCH
- And fuer Folgeschritte (nicht When). NUR Gherkin ausgeben, direkt mit "Feature:" beginnen
- KEIN Background, KEIN Cleanup-Szenario. Kommentare (#) fuer Abschnitte
- STORE fuer Stammdaten, NEW nur fuer Belege. Bei STORE/NEW immer "such" setzen
- ALLE Stammdaten im ERSTEN Szenario buendeln, Folge-Szenarien NUR UPDATE
- Nach jedem Speichern: Then-Steps zur Wertpruefung!
- Bevorzuge "I set fields"-Tabelle statt einzelner "I set field"-Zeilen
- y-Felder IMMER testen: Pflichtfeld, Aenderbarkeit, Wertpruefung
- "Pflichtfeld"/"gesperrt" im Text → passende Validierungs-Steps generieren
- Deutsche Begriffe erkennen: "Variablentabelle Artikel"=Artikelstamm, "Aufzaehlung"=Enum, "Referenz"=Reference, "Kennzeichen"=Boolean, etc.

## Prompt-Bewertung (am ENDE nach dem letzten Szenario)
Format:
PROMPT_RATING:<score>
<1 Satz Begruendung>
EMPFEHLUNG:<Vorschlag>

Score: WO(Pflicht)+WAS(Pflicht)+WIE+VERHALTEN+WERTE+ABLAUF → 90-100 alles da, 70-89 WO+WAS da, 50-69 WO/WAS fehlt, 30-49 vage, 0-29 unbrauchbar.
1-4 EMPFEHLUNG-Zeilen zu fehlenden Punkten. Bei >=90 positive EMPFEHLUNG genuegt.`;

function getSystemPrompt(): string {
  return getCustomSystemPrompt() || DEFAULT_SYSTEM_PROMPT;
}

function getTableIdPrompt(): string {
  return getCustomTableIdPrompt() || DEFAULT_TABLE_ID_PROMPT;
}

function getRatingPrompt(): string {
  return getCustomRatingPrompt() || DEFAULT_RATING_PROMPT;
}

import type { TableDef } from '../types/gherkin';

interface TableInfo {
  name: string;
  tableRef: string;
  kind: 'database' | 'infosystem';
}

// ── Existing single-step prompt (fallback when no field data) ───

export function buildMessages(
  requirementsText: string,
  testUser?: string,
  tables?: TableInfo[],
): { role: 'system' | 'user'; content: string }[] {
  let userContent = `Erstelle Gherkin-Test-Szenarien aus folgendem Anforderungstext:\n\n${requirementsText}`;
  if (testUser) {
    userContent += `\n\nHinweis: Der Testbenutzer "${testUser}" wird automatisch als Background eingefuegt — schreibe KEINEN Login-Schritt in die Szenarien.`;
  }

  // Provide available table/infosystem names so the AI uses the correct names
  if (tables && tables.length > 0) {
    const databases = tables.filter((t) => t.kind === 'database');
    const infosystems = tables.filter((t) => t.kind === 'infosystem');

    let tableContext = '\n\nVerfuegbare Datenbanken/Masken (verwende den Namen als Tabelle):';
    for (const db of databases) {
      tableContext += `\n- "${db.name}"`;
    }
    if (infosystems.length > 0) {
      tableContext += '\n\nVerfuegbare Infosysteme (verwende das Suchwort):';
      for (const is of infosystems) {
        tableContext += `\n- "${is.tableRef}" (${is.name})`;
      }
    }
    userContent += tableContext;
  }

  return [
    { role: 'system', content: getSystemPrompt() },
    { role: 'user', content: userContent },
  ];
}

// ── Step 1: Table identification prompt ─────────────────────────

export const DEFAULT_TABLE_ID_PROMPT = `Du bist ein abas ERP Experte.
Bestimme aus dem Anforderungstext, welche Datenbanken und Infosysteme relevant sind.
Ordne deutsche Begriffe den korrekten Namen aus der Liste zu (z.B. "Auftrag"→"Verkaufsauftrag", "Debitor"→"Kunde").
Bei Prozessen ALLE beteiligten Datenbanken hinzufuegen.
Antworte NUR mit JSON: {"tables":["Name1","Name2"],"infosystems":["Name1"]}
Nur Namen aus der bereitgestellten Liste verwenden.`;

export function buildTableIdentificationMessages(
  requirementsText: string,
  tables: TableInfo[],
): { role: 'system' | 'user'; content: string }[] {
  const databases = tables.filter((t) => t.kind === 'database');
  const infosystems = tables.filter((t) => t.kind === 'infosystem');

  let userContent = `Anforderungstext:\n\n${requirementsText}`;

  userContent += '\n\nVerfuegbare Datenbanken (Name → Referenz):';
  for (const db of databases) {
    userContent += `\n- "${db.name}" (${db.tableRef})`;
  }
  if (infosystems.length > 0) {
    userContent += '\n\nVerfuegbare Infosysteme (Name → Referenz):';
    for (const is of infosystems) {
      userContent += `\n- "${is.name}" (${is.tableRef})`;
    }
  }

  return [
    { role: 'system', content: getTableIdPrompt() },
    { role: 'user', content: userContent },
  ];
}

// ── Step 1 response parsing ─────────────────────────────────────

export interface TableIdentificationResult {
  tables: string[];
  infosystems: string[];
}

export function parseTableIdentificationResponse(response: string): TableIdentificationResult {
  // Strip markdown code fences if present
  const cleaned = response.replace(/```(?:json)?\s*\n?([\s\S]*?)```/, '$1').trim();

  try {
    const parsed = JSON.parse(cleaned);
    return {
      tables: Array.isArray(parsed.tables)
        ? parsed.tables.filter((t: unknown): t is string => typeof t === 'string')
        : [],
      infosystems: Array.isArray(parsed.infosystems)
        ? parsed.infosystems.filter((t: unknown): t is string => typeof t === 'string')
        : [],
    };
  } catch {
    return { tables: [], infosystems: [] };
  }
}

// ── Table lookup helper ─────────────────────────────────────────

// Common abas ERP synonyms: concept term → possible table names
const ABAS_SYNONYMS: Record<string, string[]> = {
  // Stammdaten
  'artikelstamm': ['artikel', 'teile'],
  'teilestamm': ['teile', 'artikel'],
  'produkt': ['artikel', 'teile'],
  'kundenstamm': ['kunde', 'kunden'],
  'debitor': ['kunde', 'kunden'],
  'lieferantenstamm': ['lieferant', 'lieferanten'],
  'kreditor': ['lieferant', 'lieferanten'],
  'waehrungskurs': ['waehrung'],
  'wechselkurs': ['waehrung'],
  // Verkauf (DB 3)
  'verkaufsauftrag': ['verkaufsauftrag', 'auftrag', 'va'],
  'auftrag': ['verkaufsauftrag', 'auftrag'],
  'va': ['verkaufsauftrag', 'auftrag'],
  'verkaufsangebot': ['angebot', 'verkaufsangebot'],
  'angebot': ['angebot', 'verkaufsangebot'],
  'lieferschein': ['lieferschein', 'lieferung'],
  'lieferung': ['lieferschein', 'lieferung'],
  'rechnung': ['rechnung', 'ausgangsrechnung'],
  'ausgangsrechnung': ['rechnung', 'ausgangsrechnung'],
  // Einkauf (DB 4)
  'einkaufsbestellung': ['einkaufsbestellung', 'bestellung'],
  'bestellung': ['einkaufsbestellung', 'bestellung'],
  'einkaufsanfrage': ['anfrage', 'einkaufsanfrage'],
  'anfrage': ['anfrage', 'einkaufsanfrage'],
  'bestellvorschlag': ['bestellvorschlag'],
  'einkaufslieferschein': ['einkaufslieferschein', 'wareneingang'],
  'wareneingang': ['einkaufslieferschein', 'wareneingang'],
  'eingangsrechnung': ['eingangsrechnung', 'einkaufsrechnung', 'lieferantenrechnung'],
  'einkaufsrechnung': ['eingangsrechnung', 'einkaufsrechnung'],
  // Fertigung (DB 9)
  'fertigungsauftrag': ['fertigungsauftrag', 'betriebsauftrag', 'fa'],
  'fa': ['fertigungsauftrag', 'betriebsauftrag'],
  'betriebsauftrag': ['betriebsauftrag', 'fertigungsauftrag'],
  'fertigungsvorschlag': ['fertigungsvorschlag'],
  'stueckliste': ['stueckliste'],
  'bom': ['stueckliste'],
  'arbeitsplan': ['arbeitsplan'],
  'arbeitsgang': ['arbeitsgang'],
  'maschinengruppe': ['maschinengruppe'],
  // Materialwirtschaft
  'lager': ['lager', 'lagerstamm'],
  'inventur': ['inventur', 'zahlliste'],
  'zahlliste': ['zahlliste', 'inventur'],
  'disposition': ['disposition', 'dispo'],
  'dispo': ['disposition', 'dispo'],
  'packanweisung': ['packanweisung'],
  // Fibu
  'offene posten': ['offene posten', 'op'],
  'op': ['offene posten', 'op'],
  // Sonstige
  'kontakt': ['kontakt', 'kontakte'],
  'projekt': ['projekt', 'projekte'],
  'konfiguration': ['konfiguration'],
};

/**
 * Fuzzy-match a name from the AI against actual table names.
 * Tries: exact → synonym lookup → substring containment.
 */
function findTableMatch(
  searchName: string,
  tables: TableDef[],
  kind: 'database' | 'infosystem',
): TableDef | undefined {
  const search = searchName.toLowerCase().trim();
  const candidates = tables.filter((t) => t.kind === kind);

  // 1. Exact match
  const exact = candidates.find((t) => t.name.toLowerCase() === search);
  if (exact) return exact;

  // 2. Synonym lookup
  const synonyms = ABAS_SYNONYMS[search];
  if (synonyms) {
    for (const syn of synonyms) {
      const synMatch = candidates.find((t) => t.name.toLowerCase() === syn);
      if (synMatch) return synMatch;
    }
  }

  // 3. Substring: search term contains table name or vice versa
  const substringMatch = candidates.find((t) => {
    const tName = t.name.toLowerCase();
    return search.includes(tName) || tName.includes(search);
  });
  if (substringMatch) return substringMatch;

  // 4. Table ref match (e.g. AI returned "2:1" directly)
  const refMatch = candidates.find((t) => t.tableRef === searchName.trim());
  if (refMatch) return refMatch;

  return undefined;
}

export function lookupRelevantTables(
  identified: TableIdentificationResult,
  tables: TableDef[],
): TableDef[] {
  const result: TableDef[] = [];
  const seen = new Set<string>();

  for (const name of identified.tables) {
    const match = findTableMatch(name, tables, 'database');
    if (match && !seen.has(match.tableRef)) {
      result.push(match);
      seen.add(match.tableRef);
    }
  }

  for (const name of identified.infosystems) {
    const match = findTableMatch(name, tables, 'infosystem');
    if (match && !seen.has(match.tableRef)) {
      result.push(match);
      seen.add(match.tableRef);
    }
  }

  return result;
}

// ── Local table identification (replaces Step 1 AI call) ─────

/**
 * Identifies relevant tables from the requirements text using local keyword matching.
 * This replaces the previous AI-based table identification step, saving an entire API call.
 */
export function identifyTablesLocally(
  requirementsText: string,
  tables: TableDef[],
): TableDef[] {
  const lower = requirementsText.toLowerCase();
  const result: TableDef[] = [];
  const seen = new Set<string>();

  for (const table of tables) {
    if (seen.has(table.tableRef)) continue;

    const tableLower = table.name.toLowerCase();

    // 1. Direct name match (e.g. "Kundenstamm" in text)
    if (lower.includes(tableLower)) {
      result.push(table);
      seen.add(table.tableRef);
      continue;
    }

    // 2. Synonym match — check if any known synonym for this table appears in text
    const synonyms = ABAS_SYNONYMS[tableLower];
    if (synonyms?.some((syn) => lower.includes(syn))) {
      result.push(table);
      seen.add(table.tableRef);
      continue;
    }

    // 3. Reverse synonym match — check if any synonym key that maps to this table name appears
    for (const [key, values] of Object.entries(ABAS_SYNONYMS)) {
      if (values.some((v) => v === tableLower) && lower.includes(key)) {
        result.push(table);
        seen.add(table.tableRef);
        break;
      }
    }
  }

  return result;
}

// ── Step 2: Generation prompt with field data ───────────────────

const MAX_STANDARD_FIELDS = 30;

/**
 * Formats field data for the prompt. Prioritizes y-fields (custom) and well-known
 * standard fields. Descriptions are only included for y-fields to save tokens.
 */
function formatFieldsForPrompt(tables: TableDef[], requirementsText?: string): string {
  const lower = requirementsText?.toLowerCase() ?? '';
  let result = '\n\nVerfuegbare Felder:';

  for (const table of tables) {
    const label = table.kind === 'infosystem'
      ? `\n\n### ${table.name} (Infosystem: ${table.tableRef})`
      : `\n\n### ${table.name} (${table.tableRef})`;
    result += label;

    const relevantFields = table.fields.filter((f) => !f.skip);

    // Separate y-fields (always include with description) from standard fields
    const yFields = relevantFields.filter((f) => f.name.startsWith('y'));
    const stdFields = relevantFields.filter((f) => !f.name.startsWith('y'));

    // For standard fields: include those mentioned in requirements text, then fill up to limit
    const mentionedStd = stdFields.filter((f) => lower.includes(f.name.toLowerCase()));
    const remainingStd = stdFields.filter((f) => !lower.includes(f.name.toLowerCase()));
    const selectedStd = [...mentionedStd, ...remainingStd.slice(0, Math.max(0, MAX_STANDARD_FIELDS - mentionedStd.length))];

    // y-fields with description, standard fields name-only
    const yList = yFields.map((f) => (f.description ? `${f.name} (${f.description})` : f.name)).join(', ');
    const stdList = selectedStd.map((f) => f.name).join(', ');

    if (yFields.length > 0) {
      result += `\ny-Felder: ${yList}`;
    }
    if (selectedStd.length > 0) {
      result += `\nStandardfelder: ${stdList}`;
    }
  }

  return result;
}

export function buildMessagesWithFields(
  requirementsText: string,
  relevantTables: TableDef[],
  testUser?: string,
): { role: 'system' | 'user'; content: string }[] {
  let userContent = `Erstelle Gherkin-Test-Szenarien aus folgendem Anforderungstext:\n\n${requirementsText}`;

  if (testUser) {
    userContent += `\n\nHinweis: Der Testbenutzer "${testUser}" wird automatisch als Background eingefuegt — schreibe KEINEN Login-Schritt in die Szenarien.`;
  }

  userContent += formatFieldsForPrompt(relevantTables, requirementsText);
  userContent += '\n\nWICHTIG: Verwende NUR Feldnamen aus der obigen Liste, exakt wie aufgelistet.';

  return [
    { role: 'system', content: getSystemPrompt() },
    { role: 'user', content: userContent },
  ];
}

// ── Shared helper ───────────────────────────────────────────────

export interface AiPromptRating {
  score: number;
  reason: string;
  suggestions: string[];
  inconsistencies?: string[];
}

/** Extracts PROMPT_RATING:<score> + EMPFEHLUNG: lines from AI response and removes them from the text */
export function extractPromptRating(text: string): { cleaned: string; rating: AiPromptRating | null } {
  const match = text.match(/PROMPT_RATING\s*:\s*(\d+)/);
  if (!match) return { cleaned: text, rating: null };

  const score = Math.min(100, Math.max(0, parseInt(match[1], 10)));

  // Everything from PROMPT_RATING onward is the rating block
  const ratingBlock = text.slice(match.index!);
  const cleaned = text.slice(0, match.index).trimEnd();

  // First non-empty line after PROMPT_RATING:<score> is the reason
  const blockLines = ratingBlock.split('\n').map((l) => l.trim()).filter(Boolean);
  const reason = blockLines.length > 1 ? blockLines[1].replace(/^EMPFEHLUNG\s*:\s*/i, '') : '';

  // Extract all EMPFEHLUNG: lines
  const suggestions: string[] = [];
  for (const line of blockLines) {
    const empfMatch = line.match(/^EMPFEHLUNG\s*:\s*(.+)/i);
    if (empfMatch) {
      suggestions.push(empfMatch[1].trim());
    }
  }

  // If reason line was actually an EMPFEHLUNG, use first non-EMPFEHLUNG line or first suggestion
  const actualReason = blockLines.find((l, i) => i > 0 && !/^EMPFEHLUNG\s*:/i.test(l))
    || (suggestions.length > 0 ? '' : reason);

  return { cleaned, rating: { score, reason: actualReason || reason, suggestions } };
}

/** Strips markdown code fences if present */
export function extractGherkin(text: string): string {
  const fenceMatch = text.match(/```(?:gherkin)?\s*\n([\s\S]*?)```/);
  return fenceMatch ? fenceMatch[1].trim() : text.trim();
}

// ── Standalone AI Rating ─────────────────────────────────────────

export const DEFAULT_RATING_PROMPT = `Du bist ein Experte fuer abas ERP Anpassungsprozesse und Testautomatisierung.
Bewerte den Anforderungstext (Customizing-Konzept, KEINE Testschritte) aus Sicht der Cucumber-Testgenerierung.

Deutsche Fachbegriffe zaehlen als gueltige Angaben — NICHT als fehlend monieren!
Ortsangaben: "Variablentabelle X", "Im Kundenstamm", "Auf der Maske Y", abas-Objekte (Auftrag, Lieferschein etc.)
Feldtypen: Aufzaehlung, Referenz/Verweis, Freitext, Ganzzahl, Dezimalzahl, Datum, Ja/Nein/Kennzeichen, Memo
Feldverhalten: Pflichtfeld, gesperrt/readonly, sichtbar/ausgeblendet, Standardwert/Default

Checkliste (je mehr, desto hoeher der Score):
1. WO (Pflicht): Datenbank/Maske/Variablentabelle
2. WAS (Pflicht): Konkrete Feldnamen (y-Praefix)
3. WIE: Feldtyp
4. VERHALTEN: Pflichtfeld, gesperrt, sichtbar, Standardwert
5. WERTE: Konkrete Optionen
6. ABLAUF: Folgeprozess
7. PRUEFUNG: Erwartetes Ergebnis, Fehlerfaelle

Antworte NUR mit JSON:
{"score":<0-100>,"reason":"<1-2 Saetze>","suggestions":["<Vorschlag>",...],"inconsistencies":["<Widerspruch>",...]"}

Score: 90-100 alles da, 70-89 WO+WAS da, 50-69 WO/WAS fehlt, 30-49 vage, 0-29 unbrauchbar.
1-5 konkrete Vorschlaege zu fehlenden Checklisten-Punkten. inconsistencies nur bei echten Widerspruechen.`;

export function buildRatingMessages(
  descriptionText: string,
  tables?: TableInfo[],
): { role: 'system' | 'user'; content: string }[] {
  let userContent = `Anforderungstext:\n\n${descriptionText}`;

  if (tables && tables.length > 0) {
    const databases = tables.filter((t) => t.kind === 'database');
    const infosystems = tables.filter((t) => t.kind === 'infosystem');

    userContent += '\n\nVerfuegbare Datenbanken/Masken:';
    for (const db of databases) {
      userContent += `\n- "${db.name}" (${db.tableRef})`;
    }
    if (infosystems.length > 0) {
      userContent += '\n\nVerfuegbare Infosysteme:';
      for (const is of infosystems) {
        userContent += `\n- "${is.name}" (${is.tableRef})`;
      }
    }
  }

  return [
    { role: 'system', content: getRatingPrompt() },
    { role: 'user', content: userContent },
  ];
}

export function parseRatingResponse(response: string): AiPromptRating | null {
  // Strip markdown code fences if present
  let cleaned = response.replace(/```(?:json)?\s*\n?([\s\S]*?)```/, '$1').trim();

  // Fallback: try to extract JSON object from within larger text
  if (!cleaned.startsWith('{')) {
    const jsonMatch = cleaned.match(/\{[\s\S]*\}/);
    if (jsonMatch) cleaned = jsonMatch[0];
  }

  try {
    const parsed = JSON.parse(cleaned);

    if (typeof parsed.score !== 'number' || typeof parsed.reason !== 'string') {
      return null;
    }

    return {
      score: Math.min(100, Math.max(0, Math.round(parsed.score))),
      reason: parsed.reason,
      suggestions: Array.isArray(parsed.suggestions)
        ? parsed.suggestions.filter((s: unknown): s is string => typeof s === 'string')
        : [],
      inconsistencies: Array.isArray(parsed.inconsistencies)
        ? parsed.inconsistencies.filter((s: unknown): s is string => typeof s === 'string')
        : [],
    };
  } catch {
    return null;
  }
}
