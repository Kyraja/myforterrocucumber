import { getCustomSystemPrompt, getCustomTableIdPrompt, getCustomRatingPrompt } from './settings';
import type { KBSearchResult } from '../types/knowledgeBase';

/**
 * Average characters per token for German text with structured content (JSON, field names, etc.).
 * English averages ~4 chars/token, but German words are longer and abas field/table references
 * tokenize less efficiently → ~3 chars/token is more realistic.
 */
export const CHARS_PER_TOKEN = 3;

export const DEFAULT_SYSTEM_PROMPT = `Du bist ein Experte fuer abas ERP und Cucumber/Gherkin BDD-Tests.
Erstelle aus Anforderungstexten (Customizing-Konzepte, KEINE Testschritte) vollstaendige Gherkin-Szenarien mit abas Cucumber Standard-Steps.
Ein Geschaeftsprozess (z.B. Auftrag → Lieferschein → Rechnung) gehoert in EIN Szenario.

## abas Cucumber Standard-Steps (ENGLISCH!)
WICHTIG: Steps sind auf Englisch. Verwende EXAKT diese Muster.

### Editor oeffnen
Given I open an editor "<EditorName>" from table "<Tabelle>" with command "<Cmd>" for record "<Datensatz>"
# Varianten: (mit Menue) and menue choice "<Auswahl>" | (mit Editor-Ref) for record from editor "<Editor>" | (mit Tipp) for tip command "<Tipp>" and arguments "<Args>"
Commands: STORE (Stammdaten + Aufzaehlungen + Konfiguration!), NEW (NUR Belege wie Auftrag/Lieferschein/Rechnung!), UPDATE, VIEW, DELETE, RELEASE, DELIVERY, INVOICE, REVERSAL, PAYMENT (+ menue choice), DONE, COPY, TRANSFER (+ menue choice)
WICHTIG: STORE fuer ALLES ausser Belege. Aufzaehlungen, Stammdaten, Konfigurationen → IMMER STORE, NIEMALS NEW!
Bei NEW/STORE: for record "" — AUSNAHME: Wenn im Anforderungstext eine konkrete Nummer fuer die Anlage angegeben ist (z.B. "Artikel 10100", "Nummer K-500"), dann diese als record verwenden: for record "10100". Das Suchwort ("such") wird UNABHAENGIG davon immer als T-Muster generiert.
WICHTIG: Bei "from table" die Datenbank-Referenznummer im Format "D:G" verwenden (z.B. "2:1", "0:1", "12:5"), NICHT den Klartextnamen und NICHT die V-Notation (V-02-01)! Die Referenz steht in Klammern hinter dem Tabellennamen in der Feldliste. Beispiel: Kundenstamm (2:1) → from table "2:1".

### Felder setzen
And I set field "<Feld>" to "<Wert>"
And I set field "<Feld>" to "<Wert>" in row <Zeile>
And I set field "<Feld>" to id from editor "<Editor>"
And I set fields
  | feld1 | wert1 |
  | feld2 | wert2 |
WICHTIG: "And I set fields" (mit Datentabelle) funktioniert NUR fuer Kopffelder — NICHT fuer Tabellenzeilen!
Fuer Tabellenfelder IMMER einzelne "And I set field ... in row <Zeile>" Steps verwenden.

### Tabellenzeilen
And I delete all rows
And I delete row at position <Zeile>
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

## Datumsformat
Datumsfelder muessen im Format der Systemsprache angegeben werden:
- Deutsch: "TT.MM.JJJJ" (z.B. "15.03.2026")
- Englisch: "MM/DD/YYYY" (z.B. "03/15/2026")
Relative Datumsangaben: "+14" = heutiges Datum + 14 Arbeitstage, "-7" = 7 Arbeitstage zurueck.
Fuer ein festes Testdatum: And I set fake date to "15.03.2026" (vor dem Step der das Datum braucht).

## Suchwort-Muster
Bei STORE/NEW Feld "such" setzen. Suchwort NUR ins Feld "such", NICHT in EditorName.
WICHTIG: Das Feld "such" ist ein PFLICHTFELD bei Stammdaten. Wenn die Datenbank ein Feld "such" hat, MUSS dieses bei STORE/NEW immer gesetzt werden.

### Suchwort-Wahl (Prioritaet!):
1. Wenn der Anwender im Anforderungstext oder in einer Tabelle ein KONKRETES Suchwort vorgibt (z.B. "Suchwort: MEINKUNDE", "such: AB-001", Spalte "such" mit Wert), dann dieses EXAKT uebernehmen — NICHT durch ein T-Muster ersetzen!
2. Nur wenn KEIN Suchwort vorgegeben ist: Automatisch ein T-Muster generieren: "T" + 3-stelliger Index + Kurzname (max 4 Zeichen). Gleiche Tabelle → Index hochzaehlen.
WICHTIG: Das Suchwort darf MAXIMAL 8 Zeichen lang sein! Beispiele: T001KUND, T002ARTI, T001LIEF, T003AUFT.
NIEMALS generische Werte wie "MUSTER", "TEST", "BEISPIEL" oder andere Platzhalter als Suchwort verwenden!

### Nummer im for record:
Wenn im Anforderungstext eine konkrete Nummer vorgegeben ist (z.B. "Artikel 10100", "Nummer XY-001"), dann diese NUR im for record verwenden: for record "10100". Das Suchwort bleibt trotzdem das T-Muster.

KONSISTENZ des Suchworts: Das Suchwort (ob vom Anwender vorgegeben oder als T-Muster generiert) MUSS ueberall IDENTISCH verwendet werden:
- Im Feld "such": And I set field "such" to "T001KUND"
- Im Then-Step zur Pruefung: Then field "such" has value "T001KUND"
- Beim Wiederoeffnen per UPDATE (wenn KEINE GUID): for record "T001KUND"

WICHTIG — Referenzfelder bei Datensaetzen MIT GUID:
Wenn der referenzierte Datensatz eine GUID hat, wird fuer Referenzfelder IMMER die GUID verwendet — NIEMALS das Suchwort!
- Setzen: And I set field "artikel" to "$,,guid==<guid>" (NICHT "T001ARTI"!)
- Pruefen: Then field "artikel^guid" has value "<guid>" (NICHT field "artikel" has value "T001ARTI"!)
Nur wenn der Datensatz KEINE GUID hat (z.B. weil eine Nummer vorgegeben wurde), wird das Suchwort fuer Referenzen verwendet:
- Setzen: And I set field "artikel" to "T001ARTI"
- Pruefen: Then field "artikel" has value "T001ARTI"

## GUID-basierte Datensatz-Identifikation
Jedes Feature erhaelt eine deterministische Feature-GUID (wird dir im User-Prompt mitgeteilt).
Die GUID dient zur eindeutigen Identifikation von Testdaten, unabhaengig von Suchwort oder Nummer.

### GUID-Regel (WICHTIG — strikt einhalten!):
Pruefe fuer JEDEN Datensatz EINZELN ob eine Nummer vorgegeben ist. Wenn JA → KEINE GUID. Wenn NEIN → GUID verwenden.

GUID verwenden = NEIN (Nummer hat Vorrang!):
- Im Anforderungstext steht eine Nummer (z.B. "Artikel 10100", "Nummer K-500", "nummer: 51")
- In einer mitgelieferten Tabelle (z.B. Confluence) hat der Datensatz einen Wert in der Spalte "nummer"
- AUCH wenn die Nummer als Feld "nummer" im set fields gesetzt wird (z.B. | nummer | 51 |)
→ In diesen Faellen: for record "<Nummer>" verwenden (z.B. for record "51"), Feld "guid" NICHT setzen, NICHT for search criteria mit guid verwenden. Die Nummer ist der eindeutige Identifikator.

GUID verwenden = JA (nur wenn KEINE Nummer vorhanden):
- Der Datensatz hat KEINE vorgegebene Nummer — weder im Text, noch in einer Tabelle, noch als Feld
→ In diesem Fall: for search criteria "$,,guid==<guid>" verwenden UND Feld "guid" mitsetzen
WICHTIG — Vom Anwender vorgegebene GUID hat Vorrang:
- Wenn im Anforderungstext oder in einer Tabelle eine KONKRETE GUID vorgegeben ist (z.B. "guid: DEFAULT-2:1-00001", Spalte "guid" mit Wert), dann diese EXAKT uebernehmen — NICHT eine eigene GUID generieren!
- Die vorgegebene GUID wird dann ueberall konsistent verwendet: im Feld "guid", in for search criteria "$,,guid==<guid>" und bei Referenzierungen "$,,guid==<guid>".

### GUID-Format:
- Feature-Tag: @<featureGuid> (die GUID die dir mitgeteilt wird)
- Feld "guid" im Datensatz: <featureGuid>-<DB>-<LfdNr>
  - DB = Datenbank-Referenz (z.B. "2:1" fuer Artikel)
  - LfdNr = laufende Nummer pro Datenbank innerhalb des Features (1, 2, 3...)
- Beispiel: Feature-GUID "a1b2c3d4e5f6a7b8" → erster Artikel: "a1b2c3d4e5f6a7b8-2:1-1", zweiter Artikel: "a1b2c3d4e5f6a7b8-2:1-2", erster Kunde: "a1b2c3d4e5f6a7b8-0:1-1"

### GUID in Steps — IMMER mit for search criteria:
WICHTIG: Die Syntax "$,,guid==..." funktioniert NICHT im for record Parameter!
Verwende IMMER den Step "for search criteria" um Datensaetze per GUID zu oeffnen.
Der Step "for search criteria" sucht den Datensatz anhand der Bedingung und oeffnet ihn direkt.

### STORE mit GUID (Erstanlage UND Wiederholung):
AUCH bei der Erstanlage IMMER for search criteria verwenden! So wird bei wiederholtem Testlauf der bestehende Datensatz aktualisiert statt doppelt angelegt:
  Given I open an editor "Kundenstamm" from table "0:1" with command "STORE" for search criteria "$,,guid==a1b2c3d4e5f6a7b8-0:1-1"
  And I set fields
    | such | T001KUND |
    | guid | a1b2c3d4e5f6a7b8-0:1-1 |
    | name | Testkunde DE |
Wenn der Datensatz mit dieser GUID bereits existiert, wird er geoeffnet und aktualisiert. Wenn nicht, wird ein neuer angelegt.

### Tabellenzeilen bei STORE loeschen (Wiederholbarkeit!):
Wenn bei STORE (Stammdaten-Anlage) Tabellenzeilen angelegt werden, MUSS vorher "And I delete all rows" ausgefuehrt werden.
Grund: Bei wiederholtem Testlauf existiert der Datensatz bereits und hat alte Tabellenzeilen. Ohne Loeschen wuerden die neuen Zeilen an die alten angehaengt.
Reihenfolge:
1. Editor oeffnen mit STORE + search criteria
2. Kopffelder setzen (such, guid, name, name2, y-Felder etc.)
3. And I delete all rows
4. Tabellenzeilen anlegen (And I create a new row / And I append rows)
5. Speichern
Beispiel:
  Given I open an editor "Artikel" from table "2:1" with command "STORE" for search criteria "$,,guid==a1b2c3d4e5f6a7b8-2:1-1"
  And I set fields
    | such | T001ARTI |
    | guid | a1b2c3d4e5f6a7b8-2:1-1 |
    | name | Testartikel DE |
    | name2 | Testartikel EN |
  # Alte Tabellenzeilen loeschen fuer Wiederholbarkeit
  And I delete all rows
  And I create a new row at the end of the table
  And I set field "yfeld1" to "Wert1" in row 1
  And I set field "yfeld2" to "Wert2" in row 1
  And I save the current editor
HINWEIS: Wenn der Datensatz KEINE Tabellenzeilen benoetigt, ist "I delete all rows" NICHT noetig.

### UPDATE/VIEW mit GUID:
Auch beim Wiederoeffnen for search criteria verwenden:
  Given I open an editor "Kundenstamm" from table "0:1" with command "UPDATE" for search criteria "$,,guid==a1b2c3d4e5f6a7b8-0:1-1"

### Referenzierung ueber GUID in anderen Editoren:
Wenn ein per GUID angelegter Datensatz in einem anderen Editor referenziert werden soll (z.B. Artikel in Verkaufsauftrag-Zeile, Abteilung, Zu-/Ab-Platz), verwende die GUID mit der "$,,guid==" Notation — NICHT das Suchwort:
  And I set field "artikel" to "$,,guid==a1b2c3d4e5f6a7b8-2:1-1"
  And I set field "abtlg" to "$,,guid==a1b2c3d4e5f6a7b8-8:1-1"
  And I set field "zuplatz" to "$,,guid==a1b2c3d4e5f6a7b8-38:1-1"
WICHTIG: Beim Setzen von Referenzfeldern IMMER "$,,guid==<guid>" verwenden, NIEMALS das Suchwort (z.B. "T001ARTI"), wenn der referenzierte Datensatz eine GUID hat!

### Referenzfelder per GUID pruefen:
Zum Pruefen eines Referenzfeldes die "^guid" Notation verwenden, um die GUID des referenzierten Datensatzes abzufragen:
  Then field "artikel^guid" has value "a1b2c3d4e5f6a7b8-2:1-1"
  Then field "abtlg^guid" has value "a1b2c3d4e5f6a7b8-8:1-1"
NICHT den Klartextnamen oder das Suchwort pruefen, sondern die GUID ueber die ^guid Notation.

## Textfelder und Zeilenumbruch
In abas ERP wird ein Zeilenumbruch in Textfeldern durch ein Semikolon ";" dargestellt. Wenn ein Textwert mehrere Zeilen enthalten soll, diese mit ";" trennen (z.B. "Zeile 1;Zeile 2;Zeile 3").

## EditorName = Datenbankname (z.B. "Kundenstamm"). Bei mehreren: "Kunde Inland"/"Kunde Ausland" oder nummerieren.

## Beispiel (Stammdaten + Folgeprozess, mit GUID)
# Feature-GUID: a1b2c3d4e5f6a7b8
@a1b2c3d4e5f6a7b8
Feature: 3.2 Kundenklassifizierung erweitern

Scenario: Stammdaten anlegen
# STORE mit search criteria: findet bestehenden GUID-Datensatz oder legt neu an
Given I open an editor "Kundenstamm" from table "0:1" with command "STORE" for search criteria "$,,guid==a1b2c3d4e5f6a7b8-0:1-1"
And I set fields
  | such | T001KUND |
  | guid | a1b2c3d4e5f6a7b8-0:1-1 |
  | name | Testkunde DE |
  | name2 | Testkunde EN |
And I save the current editor
Then fields have values
  | such | T001KUND |
  | guid | a1b2c3d4e5f6a7b8-0:1-1 |
And I close the current editor

Scenario: Kundenkategorie setzen
Given I open an editor "Kundenstamm" from table "0:1" with command "UPDATE" for search criteria "$,,guid==a1b2c3d4e5f6a7b8-0:1-1"
And I set field "ykundenkategorie" to "A-Kunde"
And I save the current editor
Then field "ykundenkategorie" has value "A-Kunde"
And I close the current editor

Scenario: Verkaufsauftrag mit Kundenreferenz
# Referenzfelder per GUID setzen — NICHT per Suchwort!
Given I open an editor "Verkaufsauftrag" from table "3:1" with command "NEW" for search criteria "$,,guid==a1b2c3d4e5f6a7b8-3:1-1"
And I set fields
  | such | T001AUFT |
  | guid | a1b2c3d4e5f6a7b8-3:1-1 |
  | kunde | $,,guid==a1b2c3d4e5f6a7b8-0:1-1 |
And I save the current editor
# Referenzfelder per ^guid pruefen
Then field "kunde^guid" has value "a1b2c3d4e5f6a7b8-0:1-1"
And I close the current editor

## Erstes Szenario: Feldpruefung
IMMER als ERSTES Szenario ein "Feldpruefung"-Szenario generieren, das prueft ob alle relevanten y-Felder (Customizing-Felder) auf der Maske bzw. im Infosystem vorhanden sind.
Ablauf: Editor mit STORE oder NEW oeffnen (NICHT VIEW, da Felder dort nicht aenderbar sind und noch kein Datensatz existiert) → fuer jedes relevante y-Feld pruefen:
  - Kopffelder (in der Feldliste OHNE "[Tabelle]" markiert): Direkt pruefen mit Then field "<yFeld>" is modifiable / is not modifiable
  - Tabellenfelder (in der Feldliste mit "[Tabelle]" markiert): Zuerst eine Zeile anlegen (And I create a new row at the end of the table), dann in der Zeile pruefen: Then field "<yFeld>" is modifiable in row 1 / Then field "<yFeld>" is not modifiable in row 1
  - Felder die beschrieben/gesetzt werden sollen: is modifiable
  - Felder die nur zur Anzeige dienen (readonly, berechnet, Ausgabefelder): is not modifiable
  - Bei Infosystemen: Infosystem oeffnen und Felder pruefen
Entscheide anhand des Kontexts (Anforderungstext, Feldbeschreibung) ob ein Feld editierbar sein muss oder nur angezeigt wird.
Das Szenario heisst z.B. "Feldpruefung Kundenstamm" und verwendet STORE (Stammdaten) bzw. NEW (Belege). Den Editor danach OHNE Speichern schliessen (And I close the current editor).
Dieses Szenario stellt sicher, dass alle benoetigten Felder im System vorhanden sind bevor die eigentlichen Tests laufen.

## Vorschlagsmasken (Fertigungs-/Bestell-/Umlagerungsvorschlaege)
WICHTIG: Vorschlagsmasken funktionieren ANDERS als normale Stammdaten/Belege!
- KEIN STORE oder NEW! Die Maske wird mit command "UPDATE" geoeffnet (z.B. from table "7:1" fuer Fertigungsvorschlaege)
- Vorschlaege werden in der TABELLE der Maske angelegt: Zeile anlegen → Artikel + Menge setzen → Speichern
- Freigabe: Zeile markieren (Feld "markiert" auf "1" setzen) → Button "Freigeben" im Kopf druecken

Ablauf fuer Fertigungsvorschlaege (DB 7:1):
1. Editor oeffnen: from table "7:1" with command "UPDATE"
2. Neue Zeile: And I create a new row at the end of the table
3. Artikel + Menge setzen: And I set field "artikel" to "..." in row 1 / And I set field "menge" to "100" in row 1
4. Speichern: And I save the current editor
5. Zeile markieren: And I set field "markiert" to "1" in row 1
6. Freigeben: And I press button "Freigeben"
7. Speichern: And I save the current editor → erzeugt Betriebsauftrag + Arbeitsscheine
8. Editor schliessen

Ablauf fuer Bestellvorschlaege (DB 12:22):
1. Editor oeffnen: from table "12:22" with command "UPDATE"
2. Zeile anlegen, Artikel + Menge + Lieferant setzen
3. Zeile markieren → Button "Bestellen" oder "Anfrage" druecken → Speichern

Ablauf fuer Umlagerungsvorschlaege (DB 12:22 mit Typ Umlagerung):
1. Wie Bestellvorschlaege, aber Typ auf Umlagerung setzen

NIEMALS Vorschlaege mit STORE/NEW anlegen! NIEMALS "such" oder "guid" in Vorschlaegen setzen!
Vorschlaege haben KEIN Suchwort und KEINE GUID — sie werden ueber Tabellenzeilen verwaltet.

## Regeln
- Valides Gherkin (Feature, Scenario, Given/And/Then). Steps ENGLISCH, Szenarionamen DEUTSCH
- And fuer Folgeschritte (nicht When). NUR Gherkin ausgeben, direkt mit "Feature:" beginnen
- KEIN Background, KEIN Cleanup-Szenario. Kommentare (#) fuer Abschnitte
- STORE fuer Stammdaten, Aufzaehlungen, Konfigurationen — NEW ausschliesslich fuer Belege (Auftrag, Lieferschein, Rechnung etc.). Bei STORE/NEW immer "such" setzen
- Bei "from table" IMMER die Datenbank-Referenznummer im Format "D:G" verwenden (z.B. "2:1", "0:1"), NIEMALS den Klartextnamen (z.B. "Kundenstamm") und NIEMALS die V-Notation (z.B. "V-02-01"). Die Referenz steht in Klammern hinter dem Tabellennamen
- ALLE Stammdaten im ERSTEN Szenario buendeln, Folge-Szenarien NUR UPDATE
- Bei STORE/NEW von Stammdaten IMMER setzen: "such" (Suchwort), "name" (Bezeichnung DE) UND "name2" (Bezeichnung EN). Beide Sprachfelder sind Pflicht damit der Datensatz in beiden Sprachen korrekt benannt ist. y-Felder kommen ZUSAETZLICH dazu, NICHT stattdessen.
- Nach jedem Speichern: Then-Steps zur Wertpruefung, danach Editor schliessen (And I close the current editor)!
- JEDER geoeffnete Editor MUSS am Ende geschlossen werden (And I close the current editor). Kein Szenario darf mit offenem Editor enden
- Bevorzuge "I set fields"-Tabelle statt einzelner "I set field"-Zeilen fuer KOPFFELDER. Fuer TABELLENFELDER: IMMER einzelne "I set field ... in row <Zeile>" Steps verwenden (NICHT "I set fields in row" — dieser Step existiert NICHT!)
- y-Felder IMMER testen: Pflichtfeld, Aenderbarkeit, Wertpruefung
- "Pflichtfeld"/"gesperrt" im Text → passende Validierungs-Steps generieren
- Deutsche Begriffe erkennen: "Variablentabelle Artikel"=Artikelstamm, "Aufzaehlung"=Enum, "Referenz"=Reference, "Kennzeichen"=Boolean, etc.
- KEINE Feldnamen erfinden! Bevorzuge exakt die Felder aus der Feldliste. ABER: Wenn der Anforderungstext ein konkretes Feld benennt (z.B. ein y-Feld wie "ykundenkategorie"), verwende GENAU dieses Feld — auch wenn es nicht in der Feldliste steht. Solche Felder werden erst noch angelegt. NIEMALS ein anderes, vorhandenes Feld als Ersatz nehmen das inhaltlich nichts damit zu tun hat!
- Bei mehreren aehnlichen Feldern (z.B. verschiedene Mengen-/Wertfelder): Beachte die Feldbeschreibung in Klammern und waehle das Feld das zum Kontext passt (Bestellung→Bestellmenge, Lieferung→Liefermenge, Rechnung→Rechnungsmenge).

## Formatierung
WICHTIG: Verwende KEINE literalen Escape-Sequenzen wie \\n im Text. Nutze echte Zeilenumbrueche fuer die Formatierung.`;

/** English version of the default system prompt for language switching */
export const DEFAULT_SYSTEM_PROMPT_EN = `You generate Cucumber/Gherkin BDD test scenarios for abas ERP customizations.

## AVAILABLE STEPS

### Open / Navigate
- Given I open database "<DatabaseName>" with command UPDATE record "<RecordID>"
- Given I open database "<DatabaseName>" with command NEW
- Given I open database "<DatabaseName>" via menu with command UPDATE record "<RecordID>"
- Given I search in database "<DatabaseName>" with command UPDATE criteria "<Criteria>"

### Field Operations
- When I set field "<FieldName>" to "<Value>"
- When I set field "<FieldName>" to "<Value>" in row <N>
- Then field "<FieldName>" should contain "<Value>"
- Then field "<FieldName>" should be empty
- Then field "<FieldName>" should be editable
- Then field "<FieldName>" should not be editable

### Table / Row Operations
- When I add a new row
- Then table should have <N> rows

### Editor Actions
- When I save
- When I close
- When I switch to editor "<EditorName>"
- When I press button "<ButtonName>"
- When I open sub-editor "<SubEditorName>"
- When I open infosystem "<InfosystemName>"

### Dialogs & Exceptions
- When I answer dialog "<Question>" with "<Answer>"
- Then save should fail with exception on field "<FieldName>"
- Then save should fail with general exception

## RULES
1. Always use exact field names from the variable table
2. Use table row operations for table fields: in row <N>
3. NEW = create record, UPDATE = edit record, VIEW = view only
4. Generate Given/When/Then structure
5. One scenario per test case
6. Add @tag before Feature for categorization
`;

function getSystemPrompt(): string {
  return getCustomSystemPrompt() || DEFAULT_SYSTEM_PROMPT;
}

/**
 * Estimate token cost for generating tests from a source text.
 * Includes system prompt + table-identification call + chunked table context + generation call + responses.
 * Returns an approximate total token count (input + output).
 */
export function estimateTokens(sourceTextLength: number): number {
  const systemPromptTokens = Math.ceil(getSystemPrompt().length / CHARS_PER_TOKEN);
  // Step 1: table identification (~small request + small response)
  const tableIdInput = Math.ceil(sourceTextLength / CHARS_PER_TOKEN) + 200;
  const tableIdOutput = 150;
  // Chunked table context: ~3 tables avg, each ~200 tokens input + 20 tokens "OK" response
  const chunkedContextTokens = 3 * (200 + 20);
  // Final generation (system prompt + source text + response)
  const generationInput = systemPromptTokens + Math.ceil(sourceTextLength / CHARS_PER_TOKEN) + 300;
  const generationOutput = Math.max(500, Math.ceil(sourceTextLength / CHARS_PER_TOKEN));
  return tableIdInput + tableIdOutput + chunkedContextTokens + generationInput + generationOutput;
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
Bestimme aus dem Anforderungstext, welche abas Datenbanken und Infosysteme fuer die Umsetzung relevant sind.

WICHTIG — Datenbank-Referenzen im Text erkennen:
Wenn im Text V-Notation (z.B. "V-12-03") oder P-Notation (z.B. "P12:3") vorkommt, sind das DIREKTE Datenbank-Referenzen!
- V-Notation: V-DD-GG → Datenbank DD:GG (fuehrende Nullen entfernen). Beispiel: V-12-03 = Datenbank 12:3, V-02-04 = Datenbank 2:4
- P-Notation: PDD:GG → Datenbank DD:GG. Beispiel: P12:3 = Datenbank 12:3
Diese Referenzen sind zuverlaessiger als Klartextnamen! Wenn "Kurztext | V-12-03 | P12:3" im Text steht, ist die Datenbank "Kurztext" mit Referenz 12:3 gemeint — NICHT "Anrede" oder ein anderer abgeleiteter Name.
Gib in der JSON-Antwort den DATENBANKNAMEN an (z.B. "Kurztext"), nicht die V/P-Notation.

Ordne deutsche Begriffe den korrekten abas-Datenbanknamen zu:
- "Artikelmaske"/"Variablentabelle Artikel" → Datenbank "Artikel"
- "Auftrag" → "Verkaufsauftrag"
- "Debitor" → "Kunde"
- "Kreditor" → "Lieferant"
- "Wareneingang" → "Einkaufslieferschein"
Bei Prozessen (z.B. Auftrag→Lieferschein→Rechnung) ALLE beteiligten Datenbanken nennen.
Infosysteme NUR wenn explizit im Text erwaehnt (z.B. "Bestandsanzeige", "Infosystem XY").

Im "grund" Feld: Erkläre in 1-2 Sätzen welche konkreten Begriffe, Felder oder Prozesse im Anforderungstext auf diese Datenbanken hinweisen. Beispiel: "Der Text erwähnt 'Kundenstamm' und 'Auftragsnummer', daher wurden Kunde (0:1) und Verkaufsauftrag (3:23) gewählt."

Antworte NUR mit JSON:
{"tables":["Datenbankname1","Datenbankname2"],"infosystems":["Suchwort1"],"grund":"Begründung anhand konkreter Begriffe aus dem Text"}`;

export function buildTableIdentificationMessages(
  requirementsText: string,
): { role: 'system' | 'user'; content: string }[] {
  return [
    { role: 'system', content: getTableIdPrompt() },
    { role: 'user', content: `Anforderungstext:\n\n${requirementsText}` },
  ];
}

// ── Step 1 response parsing ─────────────────────────────────────

export interface TableIdentificationResult {
  tables: string[];
  infosystems: string[];
  /** Short explanation why these tables were identified (from KI) */
  grund?: string;
}

export function parseTableIdentificationResponse(response: string): TableIdentificationResult {
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
      grund: typeof parsed.grund === 'string' ? parsed.grund : undefined,
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
 * Normalize a reference string from the AI to the internal "D:G" format.
 * Handles: "V-02-01" → "2:1", "P2:1" → "2:1", "2:1" → "2:1"
 */
function normalizeRef(ref: string): string | null {
  const trimmed = ref.trim();
  // V-notation: V-DD-GG
  const vMatch = trimmed.match(/^V-(\d+)-(\d+)$/i);
  if (vMatch) return `${parseInt(vMatch[1], 10)}:${parseInt(vMatch[2], 10)}`;
  // P-notation: P2:1 or PDD:GG
  const pMatch = trimmed.match(/^P(\d+):(\d+)$/i);
  if (pMatch) return `${parseInt(pMatch[1], 10)}:${parseInt(pMatch[2], 10)}`;
  // Already D:G format
  const dMatch = trimmed.match(/^(\d+):(\d+)$/);
  if (dMatch) return `${parseInt(dMatch[1], 10)}:${parseInt(dMatch[2], 10)}`;
  return null;
}

/**
 * Match a name/ref from the AI against actual table definitions.
 * Tries: ref match (V/P/D:G notation) → exact name (de/en) → synonym → substring → Levenshtein.
 */
function findTableMatch(
  searchName: string,
  tables: TableDef[],
  kind: 'database' | 'infosystem',
): TableDef | undefined {
  const search = searchName.toLowerCase().trim();
  const candidates = tables.filter((t) => t.kind === kind);

  // 1. Reference match (V-02-01, P2:1, 2:1)
  const normalizedRef = normalizeRef(searchName);
  if (normalizedRef) {
    const refMatch = candidates.find((t) => t.tableRef === normalizedRef);
    if (refMatch) return refMatch;
  }

  // 2. Exact name match (check name, nameDe, nameEn)
  const exactMatch = candidates.find((t) =>
    t.name.toLowerCase() === search ||
    t.nameDe?.toLowerCase() === search ||
    t.nameEn?.toLowerCase() === search
  );
  if (exactMatch) return exactMatch;

  // 3. Synonym lookup
  const synonyms = ABAS_SYNONYMS[search];
  if (synonyms) {
    for (const syn of synonyms) {
      const synMatch = candidates.find((t) =>
        t.name.toLowerCase() === syn ||
        t.nameDe?.toLowerCase() === syn ||
        t.nameEn?.toLowerCase() === syn
      );
      if (synMatch) return synMatch;
    }
  }

  // 4. Substring: search term contains table name or vice versa (min 4 chars)
  if (search.length >= 4) {
    const substringMatch = candidates.find((t) => {
      const names = [t.name, t.nameDe, t.nameEn].filter(Boolean).map((n) => n!.toLowerCase());
      return names.some((n) => n.length >= 4 && (search.includes(n) || n.includes(search)));
    });
    if (substringMatch) return substringMatch;
  }

  // 5. Levenshtein fuzzy match (for typos in AI response)
  if (search.length >= 4) {
    let bestMatch: TableDef | undefined;
    let bestSim = FUZZY_THRESHOLD;
    for (const t of candidates) {
      const names = [t.name, t.nameDe, t.nameEn].filter(Boolean).map((n) => n!.toLowerCase());
      for (const n of names) {
        const sim = similarity(search, n);
        if (sim > bestSim) {
          bestSim = sim;
          bestMatch = t;
        }
      }
    }
    if (bestMatch) return bestMatch;
  }

  // 6. Raw tableRef match (e.g. AI returned "2:1" as string)
  const rawRefMatch = candidates.find((t) => t.tableRef === search);
  if (rawRefMatch) return rawRefMatch;

  return undefined;
}

export function lookupRelevantTables(
  identified: TableIdentificationResult,
  tables: TableDef[],
): TableDef[] {
  const result: TableDef[] = [];
  const seen = new Set<string>();

  for (const name of identified.tables) {
    // Try database first, then infosystem (AI might put infosystems in tables list)
    const match = findTableMatch(name, tables, 'database') ?? findTableMatch(name, tables, 'infosystem');
    if (match && !seen.has(match.tableRef)) {
      result.push(match);
      seen.add(match.tableRef);
    }
  }

  for (const name of identified.infosystems) {
    const match = findTableMatch(name, tables, 'infosystem') ?? findTableMatch(name, tables, 'database');
    if (match && !seen.has(match.tableRef)) {
      result.push(match);
      seen.add(match.tableRef);
    }
  }

  return result;
}

/** Get current UI language from localStorage. */
function getUiLang(): 'de' | 'en' {
  const saved = localStorage.getItem('cucumbergnerator_lang');
  if (saved === 'de' || saved === 'en') return saved;
  return typeof navigator !== 'undefined' && navigator.language?.startsWith('de') ? 'de' : 'de';
}

/** Display name for a table — respects the UI language setting. */
export function tableDisplayName(t: TableDef): string {
  const lang = getUiLang();
  if (lang === 'de') return t.nameDe || t.name || t.nameEn || t.tableRef;
  return t.nameEn || t.name || t.nameDe || t.tableRef;
}

// ── Local table identification (replaces Step 1 AI call) ─────

/** Levenshtein distance between two strings. */
function levenshtein(a: string, b: string): number {
  const m = a.length, n = b.length;
  if (m === 0) return n;
  if (n === 0) return m;
  let prev = Array.from({ length: n + 1 }, (_, i) => i);
  for (let i = 1; i <= m; i++) {
    const curr = [i];
    for (let j = 1; j <= n; j++) {
      curr[j] = a[i - 1] === b[j - 1]
        ? prev[j - 1]
        : 1 + Math.min(prev[j - 1], prev[j], curr[j - 1]);
    }
    prev = curr;
  }
  return prev[n];
}

/** Normalized similarity score (0..1) based on Levenshtein distance. */
function similarity(a: string, b: string): number {
  const maxLen = Math.max(a.length, b.length);
  if (maxLen === 0) return 0;
  return 1 - levenshtein(a, b) / maxLen;
}

/** Extract meaningful words (4+ chars) from text, including compound terms. */
function extractWords(text: string): string[] {
  // Split on whitespace, punctuation, etc. Keep words >= 4 chars.
  return text.toLowerCase()
    .replace(/[^\p{L}\p{N}\s-]/gu, ' ')
    .split(/\s+/)
    .filter((w) => w.length >= 4);
}

/** Maximum number of tables from local identification. */
const MAX_LOCAL_TABLES = 10;
/** Minimum Levenshtein similarity for fuzzy matching. */
const FUZZY_THRESHOLD = 0.75;

interface TableMatch {
  table: TableDef;
  score: number;
}

/**
 * Identifies relevant tables from the requirements text using multi-level matching:
 * 1. Exact name match (score 100)
 * 2. Synonym match (score 90)
 * 3. Levenshtein fuzzy match (score based on similarity)
 * 4. Word-part match — table name contained in a text word or vice versa (score 70)
 *
 * Returns top matches sorted by relevance, max MAX_LOCAL_TABLES.
 */
export function identifyTablesLocally(
  requirementsText: string,
  tables: TableDef[],
): TableDef[] {
  const lower = requirementsText.toLowerCase();
  const words = extractWords(requirementsText);
  const matches: TableMatch[] = [];
  const seen = new Set<string>();

  for (const table of tables) {
    if (seen.has(table.tableRef)) continue;

    // Collect all name variants for this table — prefer German, then English
    const names: string[] = [];
    if (table.nameDe?.trim()) names.push(table.nameDe.toLowerCase().trim());
    if (table.name?.trim()) names.push(table.name.toLowerCase().trim());
    if (table.nameEn?.trim()) names.push(table.nameEn.toLowerCase().trim());
    // Deduplicate
    const uniqueNames = [...new Set(names)].filter((n) => n.length >= 3);

    if (uniqueNames.length === 0) continue;

    // Infosystems: only exact match (their names are search codes like "MASKE", not natural words)
    const isInfosystem = table.kind === 'infosystem';

    let bestScore = 0;

    for (const name of uniqueNames) {
      // 1. Exact substring match in full text
      if (lower.includes(name)) {
        bestScore = Math.max(bestScore, 100);
        break;
      }

      // Infosystems: skip fuzzy/synonym/part matching — too many false positives
      if (isInfosystem) continue;

      // 2. Synonym match
      const synonyms = ABAS_SYNONYMS[name];
      if (synonyms?.some((syn) => syn.length >= 3 && lower.includes(syn))) {
        bestScore = Math.max(bestScore, 90);
        continue;
      }

      // Reverse synonym
      for (const [key, values] of Object.entries(ABAS_SYNONYMS)) {
        if (key.length >= 3 && values.some((v) => v === name) && lower.includes(key)) {
          bestScore = Math.max(bestScore, 90);
          break;
        }
      }
      if (bestScore >= 90) continue;

      // 3. Levenshtein fuzzy match against words in text
      for (const word of words) {
        const sim = similarity(name, word);
        if (sim >= FUZZY_THRESHOLD) {
          bestScore = Math.max(bestScore, Math.round(sim * 85));
        }
      }

      // 4. Word-part match: "Kunde" in "Kundenstamm" or "Artikelstamm" contains "Artikel"
      // Only for names >= 5 chars to avoid false positives with short words
      if (bestScore < 70 && name.length >= 5) {
        for (const word of words) {
          if (word.length >= 5 && (word.includes(name) || name.includes(word))) {
            bestScore = Math.max(bestScore, 70);
            break;
          }
        }
      }
    }

    if (bestScore > 0) {
      matches.push({ table, score: bestScore });
      seen.add(table.tableRef);
    }
  }

  // Sort by score descending, take top N
  matches.sort((a, b) => b.score - a.score);
  const top = matches.slice(0, MAX_LOCAL_TABLES);

  if (top.length > 0) {
    console.log(
      `[identifyTablesLocally] ${top.length} Tabellen gefunden:`,
      top.map((m) => `${tableDisplayName(m.table)} (${m.table.tableRef}) Score=${m.score}`),
    );
  }

  return top.map((m) => m.table);
}

// ── Step 2: Generation prompt with field data ───────────────────

/** Maximum message length (chars) before progressive reduction kicks in. */
const MAX_MESSAGE_CHARS = 160_000;

/** Reduction levels for progressive field trimming. */
interface ReductionConfig {
  yFieldsWithDesc: boolean;
  maxStdFields: number;
}

const REDUCTION_LEVELS: ReductionConfig[] = [
  { yFieldsWithDesc: true, maxStdFields: 30 },   // Level 0: default
  { yFieldsWithDesc: false, maxStdFields: 10 },   // Level 1: y-fields name-only, fewer std
  { yFieldsWithDesc: false, maxStdFields: 0 },    // Level 2: y-fields name-only, no std
  // Level 3: only table names (no fields at all) — handled separately
];

/**
 * Check if a field name or its description is mentioned in the requirements text.
 */
/** Returns " [Tabelle]" suffix if the field is a table/row field, empty string otherwise. */
function tableFieldTag(f: { isTableField?: boolean; skip?: boolean }): string {
  const parts: string[] = [];
  parts.push(f.isTableField ? 'Tabelle' : 'Kopf');
  if (f.skip) parts.push('Skip');
  return ` [${parts.join(', ')}]`;
}

function isFieldMentioned(f: { name: string; description: string; descriptionDe?: string; descriptionEn?: string }, lower: string): boolean {
  if (lower.includes(f.name.toLowerCase())) return true;
  if (f.description && lower.includes(f.description.toLowerCase())) return true;
  if (f.descriptionDe && lower.includes(f.descriptionDe.toLowerCase())) return true;
  if (f.descriptionEn && lower.includes(f.descriptionEn.toLowerCase())) return true;
  return false;
}

/**
 * Collapse consecutive numbered field series.
 * e.g. ["yvausst01", "yvausst02", ..., "yvausst20"] → ["yvausst01..20"]
 */
function collapseNumberSeries(names: string[]): string[] {
  if (names.length <= 2) return names;

  const result: string[] = [];
  let i = 0;

  while (i < names.length) {
    // Try to find a numbered suffix
    const match = names[i].match(/^(.+?)(\d+)$/);
    if (!match) {
      result.push(names[i]);
      i++;
      continue;
    }

    const prefix = match[1];
    const startNum = parseInt(match[2], 10);
    const numWidth = match[2].length;
    let endNum = startNum;
    let j = i + 1;

    // Find consecutive numbers with same prefix and digit width
    while (j < names.length) {
      const nextMatch = names[j].match(/^(.+?)(\d+)$/);
      if (!nextMatch || nextMatch[1] !== prefix || nextMatch[2].length !== numWidth) break;
      const nextNum = parseInt(nextMatch[2], 10);
      if (nextNum !== endNum + 1) break;
      endNum = nextNum;
      j++;
    }

    if (j - i >= 3) {
      // Collapse series of 3+ consecutive fields
      const endStr = String(endNum).padStart(numWidth, '0');
      result.push(`${names[i]}..${endStr}`);
    } else {
      // Not enough consecutive — keep individually
      for (let k = i; k < j; k++) result.push(names[k]);
    }
    i = j;
  }

  return result;
}

/** Get the best field description based on UI language */
function fieldDescription(f: FieldDef): string {
  const lang = getUiLang();
  if (lang === 'de') return f.descriptionDe || f.description || f.descriptionEn || '';
  return f.descriptionEn || f.description || f.descriptionDe || '';
}

/** Format a single field line for the prompt */
function formatFieldLine(f: FieldDef, lower: string): string {
  const star = isFieldMentioned(f, lower) ? '*' : '';
  const tag = tableFieldTag(f);
  const desc = fieldDescription(f);
  return desc ? `- ${star}${f.name} (${desc})${tag}` : `- ${star}${f.name}${tag}`;
}

/**
 * Format a single table's fields as a context message for chunked sending.
 * Uses reduction level 0 (full detail) since each table is sent individually.
 *
 * Output structure:
 * ```
 * === Tabelle: Product (2:1) ===
 * Kopf-Felder:
 * - such (Suchbegriff) [K]
 * - *ykundenkategorie (Kundenkategorie) [K]
 * Tabellen-Felder:
 * - menge (Bestellmenge) [T]
 * Custom-Felder (y-Felder):
 * - ykonfmerkm [K]
 * ===
 * ```
 */
export function formatSingleTableContext(table: TableDef, requirementsText?: string): string {
  const lower = requirementsText?.toLowerCase() ?? '';
  const isDb = table.kind === 'database';
  const label = table.kind === 'infosystem'
    ? `${tableDisplayName(table)} (Infosystem: ${table.tableRef})`
    : `${tableDisplayName(table)} (${table.tableRef})`;

  // Include skip fields but mark them — only filter readonly
  const allFields = table.fields.filter((f) => !f.readonly);
  if (allFields.length === 0) return `=== Tabelle: ${label} ===\n(keine editierbaren Felder)\n===`;

  let result = `=== Tabelle: ${label} ===`;

  // Flag: data already exists — AI should only reference, not create with STORE/NEW
  if (table.assumeExists) {
    result += '\nHINWEIS: Datensaetze in dieser Tabelle sind BEREITS VORHANDEN. NICHT mit STORE/NEW anlegen! Nur vorhandene Eintraege per UPDATE referenzieren oder in anderen Szenarien verwenden (z.B. als Wert in Feldern anderer Tabellen eintragen).';
  }

  // Both databases and infosystems have K/T distinction
  // Only databases have Skip (infosystems don't have skip fields)
  const kopfFields = allFields.filter((f) => !f.isTableField);
  const tabellenFields = allFields.filter((f) => f.isTableField);
  const yKopf = kopfFields.filter((f) => f.name.startsWith('y'));
  const stdKopf = kopfFields.filter((f) => !f.name.startsWith('y'));
  const yTabelle = tabellenFields.filter((f) => f.name.startsWith('y'));
  const stdTabelle = tabellenFields.filter((f) => !f.name.startsWith('y'));

  if (stdKopf.length > 0 || yKopf.length > 0) {
    result += '\nKopf-Felder:';
    for (const f of stdKopf) result += `\n${formatFieldLine(f, lower)}`;
    if (yKopf.length > 0) {
      result += '\nKopf Custom-Felder (y-Felder):';
      for (const f of yKopf) result += `\n${formatFieldLine(f, lower)}`;
    }
  }
  if (stdTabelle.length > 0 || yTabelle.length > 0) {
    result += '\nTabellen-Felder:';
    for (const f of stdTabelle) result += `\n${formatFieldLine(f, lower)}`;
    if (yTabelle.length > 0) {
      result += '\nTabellen Custom-Felder (y-Felder):';
      for (const f of yTabelle) result += `\n${formatFieldLine(f, lower)}`;
    }
  }

  result += '\n===';
  return result;
}

/**
 * Formats field data for the prompt at a given reduction level.
 * Returns null at level 3+ (only table names, no fields).
 */
function formatFieldsForPrompt(
  tables: TableDef[],
  requirementsText: string | undefined,
  level: number,
): string {
  const lower = requirementsText?.toLowerCase() ?? '';
  let result = '\n\nVerfuegbare Felder:';

  if (level >= REDUCTION_LEVELS.length) {
    // Level 3+: only table names, no fields
    result = '\n\nVerfuegbare Tabellen:';
    for (const table of tables) {
      const label = table.kind === 'infosystem'
        ? `${tableDisplayName(table)} (Infosystem: ${table.tableRef})`
        : `${tableDisplayName(table)} (${table.tableRef})`;
      result += `\n- ${label}`;
    }
    return result;
  }

  const config = REDUCTION_LEVELS[level];

  for (const table of tables) {
    const label = table.kind === 'infosystem'
      ? `\n\n### ${tableDisplayName(table)} (Infosystem: ${table.tableRef})`
      : `\n\n### ${tableDisplayName(table)} (${table.tableRef})`;
    result += label;

    if (table.assumeExists) {
      result += '\nHINWEIS: Datensaetze BEREITS VORHANDEN — NICHT mit STORE/NEW anlegen, nur referenzieren!';
    }

    // Filter out skipped and readonly fields
    const relevantFields = table.fields.filter((f) => !f.skip && !f.readonly);

    // Separate y-fields (custom) from standard fields
    const yFields = relevantFields.filter((f) => f.name.startsWith('y'));
    const stdFields = relevantFields.filter((f) => !f.name.startsWith('y'));

    // For standard fields: prioritize mentioned ones, then fill up to limit
    const mentionedStd = stdFields.filter((f) => isFieldMentioned(f, lower));
    const remainingStd = stdFields.filter((f) => !isFieldMentioned(f, lower));
    const selectedStd = [
      ...mentionedStd,
      ...remainingStd.slice(0, Math.max(0, config.maxStdFields - mentionedStd.length)),
    ];

    const isDb = table.kind === 'database';

    // Format y-fields: with or without description depending on level
    const yFormatted = yFields.map((f) => {
      const star = isFieldMentioned(f, lower) ? '*' : '';
      const tag = tableFieldTag(f);
      const desc = fieldDescription(f);
      if (config.yFieldsWithDesc && desc) {
        return `${star}${f.name} (${desc})${tag}`;
      }
      return `${star}${f.name}${tag}`;
    });

    // Format standard fields: with description at level 0, name-only at higher levels
    const stdFormatted = selectedStd.map((f) => {
      const star = isFieldMentioned(f, lower) ? '*' : '';
      const tag = tableFieldTag(f);
      const desc = fieldDescription(f);
      if (config.yFieldsWithDesc && desc) {
        return `${star}${f.name} (${desc})${tag}`;
      }
      return `${star}${f.name}${tag}`;
    });

    // Collapse number series for cleaner output
    const yCollapsed = collapseNumberSeries(yFormatted);
    const stdCollapsed = collapseNumberSeries(stdFormatted);

    if (yCollapsed.length > 0) {
      result += `\ny-Felder: ${yCollapsed.join(', ')}`;
    }
    if (stdCollapsed.length > 0) {
      result += `\nStandardfelder: ${stdCollapsed.join(', ')}`;
    }
  }

  return result;
}

/** Metadata about how the prompt was built — for logging and token history. */
export interface PromptBuildInfo {
  /** How many tables were included */
  tableCount: number;
  /** Table names included */
  tableNames: string[];
  /** Total field count across all tables (after filtering) */
  fieldCount: number;
  /** Reduction level used (0 = full, 1-2 = reduced, 3 = names only) */
  reductionLevel: number;
  /** System prompt size in chars */
  systemChars: number;
  /** User message size in chars */
  userChars: number;
  /** Estimated total tokens (~3 chars/token for German/structured content) */
  estimatedTokens: number;
}

/** Last prompt build info — read by generatePackage for logging. */
let _lastBuildInfo: PromptBuildInfo | null = null;
export function getLastPromptBuildInfo(): PromptBuildInfo | null { return _lastBuildInfo; }

/**
 * Format KB search results as a documentation section for the AI prompt.
 * Provides abas ERP field documentation so the AI understands field semantics.
 */
export function formatKBContextForPrompt(kbResults: KBSearchResult[]): string {
  if (kbResults.length === 0) return '';

  let section = '\n\n=== REFERENZ-DOKUMENTATION (abas ERP Onlinehilfe) ===\n';
  section += 'Die folgenden Abschnitte aus der abas ERP Dokumentation beschreiben die relevanten Felder und deren Verhalten.\n';
  section += 'Nutze diese Informationen, um die Testszenarien korrekt zu erstellen (z.B. welche Felder Pflichtfelder sind, welche Vorbelegungen existieren, welche Abhaengigkeiten bestehen).\n\n';

  for (let i = 0; i < kbResults.length; i++) {
    const r = kbResults[i];
    const anchor = r.chunk.anchorName ? ` [${r.chunk.anchorName}]` : '';
    const keywords = r.chunk.keywords?.length ? ` (Keywords: ${r.chunk.keywords.join(', ')})` : '';
    section += `--- Hilfe ${i + 1}/${kbResults.length}: ${r.chunk.heading}${anchor}${keywords} ---\n`;
    // Truncate very long chunks to avoid prompt bloat
    const maxChunkLen = 3000;
    if (r.chunk.text.length > maxChunkLen) {
      section += r.chunk.text.slice(0, maxChunkLen) + '\n[...gekuerzt...]\n';
    } else {
      section += r.chunk.text + '\n';
    }
    section += '\n';
  }

  return section;
}

/**
 * Build a prominent instruction block for tables flagged as "assume exists".
 * This tells the AI to NOT create records in these tables (no STORE/NEW).
 */
export function buildAssumeExistsBlock(tables: TableDef[]): string {
  const existing = tables.filter(t => t.assumeExists);
  if (existing.length === 0) return '';

  const tableList = existing.map(t =>
    `- ${tableDisplayName(t)} (${t.tableRef})`
  ).join('\n');

  return `\n\n## VORHANDENE DATEN — NICHT ANLEGEN!\nFuer folgende Tabellen sind die Datensaetze BEREITS IM SYSTEM VORHANDEN.\nFuer diese Tabellen KEIN STORE und KEIN NEW verwenden! Die Eintraege existieren schon und werden nur REFERENZIERT.\nWenn Werte aus diesen Tabellen benoetigt werden (z.B. Aufzaehlungswerte), verwende sie direkt als Feldwert — lege KEIN eigenes Anlage-Szenario dafuer an.\n${tableList}`;
}

export function buildMessagesWithFields(
  requirementsText: string,
  relevantTables: TableDef[],
  testUser?: string,
  kbResults?: KBSearchResult[],
): { role: 'system' | 'user'; content: string }[] {
  const systemContent = getSystemPrompt();
  let baseContent = `Erstelle Gherkin-Test-Szenarien aus folgendem Anforderungstext:\n\n${requirementsText}`;

  if (testUser) {
    baseContent += `\n\nHinweis: Der Testbenutzer "${testUser}" wird automatisch als Background eingefuegt — schreibe KEINEN Login-Schritt in die Szenarien.`;
  }

  // Add KB documentation context if available
  const kbSection = kbResults ? formatKBContextForPrompt(kbResults) : '';

  // Prominent block for "assume exists" tables
  const assumeExistsBlock = buildAssumeExistsBlock(relevantTables);

  const suffix = getFieldUsageRules(true)
    + '\n- Bei mehreren aehnlichen Feldern (z.B. menge, menge2, mengelie): Waehle anhand der Beschreibung in Klammern das semantisch passende Feld fuer den jeweiligen Kontext (z.B. "Bestellmenge" fuer Bestellungen, "Liefermenge" fuer Lieferscheine).';

  // Count fields for logging
  const totalFields = relevantTables.reduce((sum, t) => sum + t.fields.filter((f) => !f.skip && !f.readonly).length, 0);

  // Progressive reduction: try increasing levels until message fits
  for (let level = 0; level <= REDUCTION_LEVELS.length; level++) {
    const fieldSection = formatFieldsForPrompt(relevantTables, requirementsText, level);
    const userContent = baseContent + fieldSection + kbSection + assumeExistsBlock + suffix;
    const totalLength = systemContent.length + userContent.length;

    if (totalLength <= MAX_MESSAGE_CHARS || level >= REDUCTION_LEVELS.length) {
      // Emergency truncation if still too long even at highest level
      const finalContent = totalLength > MAX_MESSAGE_CHARS
        ? userContent.slice(0, MAX_MESSAGE_CHARS - systemContent.length)
        : userContent;

      _lastBuildInfo = {
        tableCount: relevantTables.length,
        tableNames: relevantTables.map((t) => `${tableDisplayName(t)} (${t.tableRef})`),
        fieldCount: totalFields,
        reductionLevel: level,
        systemChars: systemContent.length,
        userChars: finalContent.length,
        estimatedTokens: Math.ceil((systemContent.length + finalContent.length) / CHARS_PER_TOKEN),
      };

      return [
        { role: 'system', content: systemContent },
        { role: 'user', content: finalContent },
      ];
    }
  }

  _lastBuildInfo = {
    tableCount: relevantTables.length,
    tableNames: relevantTables.map((t) => `${tableDisplayName(t)} (${t.tableRef})`),
    fieldCount: totalFields,
    reductionLevel: -1,
    systemChars: systemContent.length,
    userChars: baseContent.length,
    estimatedTokens: Math.ceil((systemContent.length + baseContent.length) / CHARS_PER_TOKEN),
  };

  // Should not reach here, but safety fallback
  return [
    { role: 'system', content: systemContent },
    { role: 'user', content: baseContent },
  ];
}

// ── Generation prompt fragments (used by generatePackage) ─────

/** Context message for chunked table sending */
export function buildChunkedContextMessage(tableName: string, index: number, total: number): string {
  return `Hier sind die verfuegbaren Felder fuer ${tableName} (${index}/${total}). Merke dir diese Felder fuer die spaetere Testgenerierung. Antworte kurz mit "OK".`;
}

/** Prefix before the final generation request in chunked mode */
export function getGenPrefix(): string {
  return 'Generiere jetzt die Gherkin-Testszenarien basierend auf den zuvor gesendeten Feldinformationen:\n\n';
}

/** Default WICHTIG block (DE) */
export const DEFAULT_FIELD_RULES = `WICHTIG:
- Bevorzuge Feldnamen aus den zuvor gesendeten Tabellen, exakt wie aufgelistet. ABER: Wenn der Anforderungstext ein konkretes Feld benennt (z.B. y-Felder), verwende GENAU dieses Feld — auch wenn es nicht in der Feldliste steht (es wird noch angelegt). NIEMALS vorhandene Felder als Ersatz nehmen die inhaltlich nichts damit zu tun haben!
- Bei "from table" IMMER die Referenznummer im Format "D:G" aus den Klammern verwenden (z.B. from table "2:1"), NIEMALS den Klartextnamen und NIEMALS die V-Notation (V-02-01).
- STORE fuer Stammdaten/Aufzaehlungen/Konfigurationen, NEW nur fuer Belege!`;

/** Default WICHTIG block (EN) */
export const DEFAULT_FIELD_RULES_EN = `IMPORTANT:
- Prefer field names from the tables sent above, exactly as listed. BUT: If the requirements text names a specific field (e.g. y-fields), use EXACTLY that field — even if it is not in the field list (it will be created). NEVER substitute an unrelated existing field!
- For "from table" ALWAYS use the reference number in D:G format (e.g. from table "2:1"), NEVER the plain text name and NEVER the V-notation (V-02-01).
- STORE for master data/enumerations/configurations, NEW only for documents!`;

/** Default quick test instruction (DE) */
export const DEFAULT_QUICK_TEST_PROMPT = 'TESTTIEFE: SCHNELLTEST — Fokussiere auf die im Anforderungstext beschriebenen Szenarien. Lege nur die direkt benoetigten Stammdaten an.';

/** Default quick test instruction (EN) */
export const DEFAULT_QUICK_TEST_PROMPT_EN = 'TEST DEPTH: QUICK TEST — Focus on the scenarios described in the requirements text. Only create the directly needed master data.';

/** Default deep test instruction (DE) */
export const DEFAULT_DEEP_TEST_PROMPT = 'TESTTIEFE: TIEFENTEST — Erstelle die KOMPLETTE Vorkette aller benoetigten Testdaten! JEDER referenzierte Datensatz MUSS in einem vorherigen Szenario angelegt werden (STORE/NEW + GUID). Reihenfolge: 1. Stammdaten 2. Belege 3. Folgeprozesse 4. Eigentlicher Test.';

/** Default deep test instruction (EN) */
export const DEFAULT_DEEP_TEST_PROMPT_EN = 'TEST DEPTH: DEEP TEST — Create the COMPLETE prerequisite chain of all required test data! EVERY referenced record MUST be created in a prior scenario (STORE/NEW + GUID). Order: 1. Master data 2. Documents 3. Follow-up processes 4. Actual test.';

/** Get default for a given lang */
export function getDefaultFieldRules(lang: 'de' | 'en'): string { return lang === 'de' ? DEFAULT_FIELD_RULES : DEFAULT_FIELD_RULES_EN; }
export function getDefaultQuickTestPrompt(lang: 'de' | 'en'): string { return lang === 'de' ? DEFAULT_QUICK_TEST_PROMPT : DEFAULT_QUICK_TEST_PROMPT_EN; }
export function getDefaultDeepTestPrompt(lang: 'de' | 'en'): string { return lang === 'de' ? DEFAULT_DEEP_TEST_PROMPT : DEFAULT_DEEP_TEST_PROMPT_EN; }

/** The WICHTIG block appended to the user message (always German — KI instructions) */
export function getFieldUsageRules(hasStarHint: boolean): string {
  const custom = localStorage.getItem('cucumbergnerator_field_rules_prompt_de');
  const base = custom || DEFAULT_FIELD_RULES;
  const starPart = hasStarHint
    ? ' Mit * markierte Felder sind im Anforderungstext erwaehnt und besonders relevant — der Stern ist NUR ein Hinweis fuer dich, uebernimm das * NICHT in die Feldnamen im Gherkin-Output!'
    : '';
  return `\n\n${base}${starPart}`;
}

/** Test depth instruction appended to the prompt (always German — KI instructions) */
export function getTestDepthInstruction(depth: 'quick' | 'deep'): string {
  if (depth === 'deep') {
    const custom = localStorage.getItem('cucumbergnerator_deep_test_prompt_de');
    return '\n\n' + (custom || DEFAULT_DEEP_TEST_PROMPT);
  }
  const custom = localStorage.getItem('cucumbergnerator_quick_test_prompt_de');
  return '\n\n' + (custom || DEFAULT_QUICK_TEST_PROMPT);
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
