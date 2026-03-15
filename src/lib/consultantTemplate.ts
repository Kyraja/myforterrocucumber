import type { FeatureInput, Step, StepKeyword, StepAction, EditorCommand, ParseProfile, CustomActionPattern } from '../types/gherkin';
import { stepTextFromAction } from './actionText';
import { DEFAULT_PARSE_PROFILE } from './parseProfile';

// ── Blank template for download / insertion ───────────────────

export const TEMPLATE_TEXT = `Feature: [Feature-Name]
Datenbank: [Verweisart, z.B. V-00-01 oder Infosystem-Suchwort]
Testbenutzer: [Login-Benutzer, z.B. sy]
Tags: [z.B. @smoke, @regression]
Beschreibung: [Kurzbeschreibung der Anforderung]

Szenario: [Szenario-Name]
Vorbedingung: [z.B. Editor oeffnen: Maskenname, Verweisart, Kommando]
Aktion: [z.B. Feld setzen: feldname = "Wert"]
Aktion: [z.B. Editor speichern]
Ergebnis: [z.B. Feld pruefen: feldname = "Erwarteter Wert"]

Szenario: [Weiteres Szenario]
Vorbedingung: [...]
Aktion: [...]
Ergebnis: [...]`;

// ── Format description document (for .txt download) ──────────

const FORMAT_DESCRIPTION = `Testformat fuer cucumbergnerator — Regelkatalog
==================================================

Wenn Sie dieses Format in Ihrem Einfuehrungskonzept einhalten,
kann der cucumbergnerator daraus automatisch Gherkin-Testszenarien
erzeugen — ohne KI. Kopieren Sie den relevanten Abschnitt aus
Ihrem Konzept und fuegen Sie ihn im cucumbergnerator ein.


1. Aufbau
---------

Kopfbereich (alles optional ausser Feature):

  Feature:       Name des Features (Pflicht)
  Datenbank:     Verweisart (z.B. V-00-01) oder Infosystem-Suchwort (z.B. TESTINFO)
  Testbenutzer:  Login-Benutzer fuer den Test (z.B. sy)
  Tags:          Kommaseparierte Tags (z.B. @smoke, @vertrieb)
  Beschreibung:  Kurze Beschreibung der Anforderung

Pro Testszenario:

  Szenario:       Name des Szenarios
  Kommentar:      Optionaler Kommentar (wird als # im Test)
  Vorbedingung:   Was gegeben sein muss (mehrere erlaubt)
  Aktion:         Was getan wird (mehrere erlaubt)
  Ergebnis:       Was erwartet wird (mehrere erlaubt)
  Und:            Zusaetzlicher Schritt (optional)
  Aber:           Ausnahme / Gegenprobe (optional)

Szenarien werden durch Leerzeilen getrennt.
Zeilen die nicht mit einem Schluesselwort beginnen werden ignoriert.


HINWEIS: Mehrere Features im gleichen Dokument
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Wenn Sie ein Word-Dokument (.docx) mit mehreren Features importieren,
verwenden Sie Ueberschriften (Heading 1 oder 2) als Trennung zwischen
den einzelnen Features. Der Text der Ueberschrift wird automatisch als
Feature-Name verwendet, falls kein "Feature:" Schluesselwort vorhanden ist.


2. Regelkatalog — Strukturierte Aktionen
-----------------------------------------

Nach Vorbedingung/Aktion/Ergebnis koennen Sie entweder Freitext
oder eine der folgenden strukturierten Aktionen verwenden.
Strukturierte Aktionen werden automatisch in korrekte Cucumber-
Steps umgewandelt. Werte mit Leerzeichen in "Anfuehrungszeichen".


EDITOR-AKTIONEN
~~~~~~~~~~~~~~~

  Editor oeffnen: Name, Verweisart, Kommando
  Editor oeffnen: Name, Verweisart, Kommando, Datensatz ID
  Editor oeffnen: Name, Verweisart, Kommando, Suche Suchkriterium
  Editor oeffnen: Name, Verweisart, Kommando, Datensatz ID, Menue Auswahl

    Kommandos: NEW, UPDATE, STORE, VIEW, DELETE, COPY,
               DELIVERY, INVOICE, REVERSAL, RELEASE, PAYMENT,
               CALCULATE, TRANSFER, DONE

  Editor speichern
  Editor schliessen
  Editor wechseln: Name


FELD-AKTIONEN
~~~~~~~~~~~~~

  Feld setzen: feldname = "Wert"
  Feld setzen: feldname = "Wert", Zeile 3

  Feld pruefen: feldname = "Erwarteter Wert"
  Feld pruefen: feldname = "Erwarteter Wert", Zeile 3

  Feld leer: feldname
  Feld leer: feldname, Zeile 3

  Feld nicht leer: feldname
  Feld nicht leer: feldname, Zeile 3

  Feld aenderbar: feldname
  Feld aenderbar: feldname, Zeile 3

  Feld gesperrt: feldname
  Feld gesperrt: feldname, Zeile 3


TABELLEN-AKTIONEN
~~~~~~~~~~~~~~~~~

  Zeile anlegen
  Tabelle hat 5 Zeilen


BUTTON / SUBEDITOR
~~~~~~~~~~~~~~~~~~

  Button druecken: buttonname
  Subeditor oeffnen: buttonname, subeditorname
  Subeditor oeffnen: buttonname, subeditorname, Zeile 3


INFOSYSTEM
~~~~~~~~~~

  Infosystem oeffnen: infosystemname


EXCEPTIONS / DIALOGE
~~~~~~~~~~~~~~~~~~~~

  Exception beim Speichern: EXCEPTION-ID
  Exception bei Feld: feldname = "Wert", Exception EXCEPTION-ID
  Dialog beantworten: DIALOG-ID, Antwort Ja


FREITEXT
~~~~~~~~

  Alles was keinem Muster entspricht wird als Freitext uebernommen.


3. Beispiel
------------

Feature: Kundenklassifizierung erweitern
Datenbank: V-00-01
Testbenutzer: sy
Tags: @smoke, @vertrieb
Beschreibung: Neues Feld ykundenkategorie im Kundenstamm anlegen und validieren

Szenario: Neues Feld anlegen und speichern
Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, NEW
Aktion: Feld setzen: ykundenkategorie = "A-Kunde"
Aktion: Editor speichern
Ergebnis: Feld pruefen: ykundenkategorie = "A-Kunde"
Ergebnis: Feld nicht leer: ykundenkategorie

Szenario: Feld ist aenderbar
Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, VIEW, Datensatz 70000
Ergebnis: Feld aenderbar: ykundenkategorie
Ergebnis: Feld gesperrt: such

Szenario: Bestehenden Kunden per Suche oeffnen
Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, VIEW, Suche ykundenkategorie=A*
Ergebnis: Feld pruefen: ykundenkategorie = "A-Kunde"

Szenario: Datensatz aendern und schliessen
Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, UPDATE, Datensatz 70000
Aktion: Feld setzen: ykundenkategorie = "B-Kunde"
Aktion: Editor speichern
Aktion: Editor schliessen

Szenario: Ungueltige Kategorie abfangen
Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, NEW
Aktion: Feld setzen: ykundenkategorie = ""
Ergebnis: Exception beim Speichern: EX-KATEGORIE

Szenario: Ungueltige Eingabe im Feld abfangen
Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, NEW
Ergebnis: Exception bei Feld: ykundenkategorie = "UNGUELTIG", Exception EX-KATEGORIE-WERT

Szenario: Tabellenzeilen mit Positionen
Vorbedingung: Editor oeffnen: Verkaufsauftrag, P2:1, NEW
Aktion: Feld setzen: such = "TEST-VA"
Aktion: Zeile anlegen
Aktion: Feld setzen: artikel = "10001", Zeile 1
Aktion: Feld setzen: mge = "5", Zeile 1
Aktion: Editor speichern
Ergebnis: Tabelle hat 1 Zeilen
Ergebnis: Feld pruefen: artikel = "10001", Zeile 1

Szenario: Button druecken und Dialog beantworten
Vorbedingung: Editor oeffnen: Verkaufsauftrag, P2:1, UPDATE, Datensatz 70000
Aktion: Button druecken: freig
Aktion: Dialog beantworten: DLG-FREIGABE, Antwort Ja
Ergebnis: Feld pruefen: status = "freigegeben"

Szenario: Subeditor oeffnen
Vorbedingung: Editor oeffnen: Verkaufsauftrag, P2:1, UPDATE, Datensatz 70000
Aktion: Subeditor oeffnen: details, Artikeldetails, Zeile 1
Ergebnis: Feld pruefen: lagerort = "HAUPT"
Aktion: Editor schliessen

Szenario: Editor wechseln
Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, VIEW, Datensatz 70000
Aktion: Editor wechseln: Ansprechpartner
Ergebnis: Feld nicht leer: name

Szenario: Editor mit Menueauswahl
Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, NEW, Datensatz 70000, Menue Kopie-Standard
Aktion: Feld setzen: such = "KOPIE-TEST"
Aktion: Editor speichern

Szenario: Klassifizierung in Infosystem pruefen
Vorbedingung: Infosystem oeffnen: KUNDENUEBERSICHT
Ergebnis: Tabelle hat 1 Zeilen
Ergebnis: Feld pruefen: ykundenkategorie = "A-Kunde", Zeile 1
Ergebnis: Feld leer: ybemerkung, Zeile 1
`;

// ── Fuzzy matching helpers ───────────────────────────────────

/**
 * Standard Levenshtein distance between two strings.
 * Used for fuzzy keyword matching to handle typos in on-site notes.
 */
export function levenshtein(a: string, b: string): number {
  const m = a.length;
  const n = b.length;
  const dp: number[][] = Array.from({ length: m + 1 }, () => Array(n + 1).fill(0));

  for (let i = 0; i <= m; i++) dp[i][0] = i;
  for (let j = 0; j <= n; j++) dp[0][j] = j;

  for (let i = 1; i <= m; i++) {
    for (let j = 1; j <= n; j++) {
      dp[i][j] = a[i - 1] === b[j - 1]
        ? dp[i - 1][j - 1]
        : 1 + Math.min(dp[i - 1][j - 1], dp[i - 1][j], dp[i][j - 1]);
    }
  }

  return dp[m][n];
}

/**
 * Maximum allowed Levenshtein distance for a keyword of given length.
 * Short keywords (≤4 chars like "Und", "Tags") → exact only (0).
 * Longer keywords → up to 2 edits to catch typos.
 */
function fuzzyMaxDistance(length: number): number {
  return length <= 4 ? 0 : 2;
}

// ── Keyword matching helpers ─────────────────────────────────

/**
 * Checks if a line starts with any of the given keyword aliases followed by ":".
 * Returns the value after the colon (trimmed), or null if no match.
 *
 * Matching order:
 * 1. Case-insensitive exact prefix match (fast path)
 * 2. Fuzzy match (Levenshtein) on the text before the first colon
 */
function matchKeyword(line: string, aliases: string[]): string | null {
  const lineLower = line.toLowerCase();

  // 1. Case-insensitive exact match
  for (const alias of aliases) {
    const prefix = alias.toLowerCase() + ':';
    if (lineLower.startsWith(prefix)) {
      return line.slice(prefix.length).trim();
    }
  }

  // 2. Fuzzy match on prefix before first colon
  const colonIdx = line.indexOf(':');
  if (colonIdx <= 0) return null;

  const linePrefix = line.slice(0, colonIdx).trim().toLowerCase();
  let bestDist = Infinity;

  for (const alias of aliases) {
    const aliasLower = alias.toLowerCase();
    const maxDist = fuzzyMaxDistance(aliasLower.length);
    if (maxDist === 0) continue;

    const dist = levenshtein(linePrefix, aliasLower);
    if (dist <= maxDist && dist < bestDist) {
      bestDist = dist;
    }
  }

  if (bestDist < Infinity) {
    return line.slice(colonIdx + 1).trim();
  }

  return null;
}

// ── Step type mapping ─────────────────────────────────────────

type StepCategory = 'precondition' | 'action' | 'result';

const CATEGORY_TO_KEYWORD: Record<StepCategory, StepKeyword> = {
  precondition: 'Given',
  action: 'When',
  result: 'Then',
};

/**
 * Builds a lookup: for each alias string → { category, keyword }.
 * Used for dynamic step keyword matching from profile.
 */
function buildStepAliasMap(profile: ParseProfile): Map<string, { category: StepCategory; keyword: StepKeyword }> {
  const map = new Map<string, { category: StepCategory; keyword: StepKeyword }>();
  for (const [category, keyword] of Object.entries(CATEGORY_TO_KEYWORD) as [StepCategory, StepKeyword][]) {
    const aliases = profile.stepKeywords[category];
    for (const alias of aliases) {
      map.set(alias, { category, keyword });
    }
  }
  return map;
}

/**
 * Tries to match a line against step keyword aliases (Vorbedingung, Aktion, Ergebnis, etc.).
 * Uses case-insensitive matching first, then fuzzy (Levenshtein) for longer keywords.
 */
function matchStepAlias(
  line: string,
  stepAliasMap: Map<string, { category: StepCategory; keyword: StepKeyword }>,
): { value: string; category: StepCategory; keyword: StepKeyword } | null {
  const lineLower = line.toLowerCase();

  // 1. Case-insensitive exact match
  for (const [alias, info] of stepAliasMap) {
    const prefix = alias.toLowerCase() + ':';
    if (lineLower.startsWith(prefix)) {
      return { value: line.slice(prefix.length).trim(), ...info };
    }
  }

  // 2. Fuzzy match on prefix before first colon
  const colonIdx = line.indexOf(':');
  if (colonIdx <= 0) return null;

  const linePrefix = line.slice(0, colonIdx).trim().toLowerCase();
  let bestMatch: { value: string; category: StepCategory; keyword: StepKeyword } | null = null;
  let bestDist = Infinity;

  for (const [alias, info] of stepAliasMap) {
    const aliasLower = alias.toLowerCase();
    const maxDist = fuzzyMaxDistance(aliasLower.length);
    if (maxDist === 0) continue;

    const dist = levenshtein(linePrefix, aliasLower);
    if (dist <= maxDist && dist < bestDist) {
      bestDist = dist;
      bestMatch = { value: line.slice(colonIdx + 1).trim(), ...info };
    }
  }

  return bestMatch;
}

const VALID_COMMANDS = new Set([
  'NEW', 'UPDATE', 'STORE', 'VIEW', 'DELETE', 'COPY',
  'DELIVERY', 'INVOICE', 'REVERSAL', 'RELEASE', 'PAYMENT',
  'CALCULATE', 'TRANSFER', 'DONE',
]);

function isPlaceholder(value: string): boolean {
  return !value || value.startsWith('[') || value === '...';
}

function unquote(s: string): string {
  const trimmed = s.trim();
  if (trimmed.startsWith('"') && trimmed.endsWith('"') && trimmed.length >= 2) {
    return trimmed.slice(1, -1);
  }
  return trimmed;
}

// ── Action pattern parser ─────────────────────────────────────

export function parseActionFromText(text: string, customActions?: CustomActionPattern[]): StepAction {
  const t = text.trim();
  let m: RegExpMatchArray | null;

  // === Parameterless actions ===
  if (/^Editor speichern$/i.test(t)) return { type: 'editorSpeichern' };
  if (/^Editor schlie(?:ss|ß)en$/i.test(t)) return { type: 'editorSchliessen' };
  if (/^Zeile anlegen$/i.test(t)) return { type: 'zeileAnlegen' };

  // === Simple single-param actions ===
  m = t.match(/^Editor wechseln:\s*(.+)$/i);
  if (m) return { type: 'editorWechseln', editorName: unquote(m[1]) };

  m = t.match(/^Button dr(?:ue|ü)cken:\s*(.+)$/i);
  if (m) return { type: 'buttonDruecken', buttonName: unquote(m[1]), row: '' };

  m = t.match(/^Infosystem (?:oeffnen|öffnen):\s*(.+)$/i);
  if (m) {
    const isName = unquote(m[1]);
    return { type: 'infosystemOeffnen', infosystemName: isName, infosystemRef: isName };
  }

  m = t.match(/^Tabelle hat\s+(\d+)\s+Zeilen$/i);
  if (m) return { type: 'tabelleZeilen', rowCount: m[1] };

  m = t.match(/^Exception beim Speichern:\s*(.+)$/i);
  if (m) return { type: 'exceptionSpeichern', exceptionId: unquote(m[1]) };

  // === Field operations ===

  // Feld setzen: FIELD = VALUE[, Zeile ROW]
  m = t.match(/^Feld setzen:\s*(\S+)\s*=\s*(.+?)(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'feldSetzen', fieldName: m[1], value: unquote(m[2]), row: m[3]?.trim() || '' };

  // Feld pruefen/prüfen: FIELD = VALUE[, Zeile ROW]
  m = t.match(/^Feld pr(?:ue|ü)fen:\s*(\S+)\s*=\s*(.+?)(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'feldPruefen', fieldName: m[1], expectedValue: unquote(m[2]), row: m[3]?.trim() || '' };

  // Feld leer / nicht leer
  m = t.match(/^Feld leer:\s*(\S+)(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'feldLeer', fieldName: m[1], isEmpty: true, row: m[2]?.trim() || '' };

  m = t.match(/^Feld nicht leer:\s*(\S+)(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'feldLeer', fieldName: m[1], isEmpty: false, row: m[2]?.trim() || '' };

  // Feld aenderbar/änderbar / gesperrt
  m = t.match(/^Feld (?:ae|ä)nderbar:\s*(\S+)(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'feldAenderbar', fieldName: m[1], modifiable: true, row: m[2]?.trim() || '' };

  m = t.match(/^Feld gesperrt:\s*(\S+)(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'feldAenderbar', fieldName: m[1], modifiable: false, row: m[2]?.trim() || '' };

  // === Editor oeffnen/öffnen (3 variants) ===
  if (/^Editor (?:oeffnen|öffnen):/i.test(t)) {
    const parsed = parseEditorOeffnen(t);
    if (parsed) return parsed;
  }

  // === Subeditor ===
  m = t.match(/^Subeditor (?:oeffnen|öffnen):\s*(.+?)\s*,\s*(.+?)(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'subeditorOeffnen', buttonName: unquote(m[1]), subeditorName: unquote(m[2]), row: m[3]?.trim() || '' };

  // === Exception bei Feld ===
  m = t.match(/^Exception bei Feld:\s*(\S+)\s*=\s*(.+?)\s*,\s*Exception\s+(.+)$/i);
  if (m) return { type: 'exceptionFeld', fieldName: m[1], value: unquote(m[2]), exceptionId: unquote(m[3]) };

  // === Dialog ===
  m = t.match(/^Dialog beantworten:\s*(.+?)\s*,\s*Antwort\s+(.+)$/i);
  if (m) return { type: 'dialogBeantworten', dialogId: unquote(m[1]), answer: unquote(m[2]) };

  // === Natural language variants (common consultant phrasings) ===

  // "Feld X auf Y setzen" / "Feld X auf Y setzen, Zeile Z"
  m = t.match(/^Feld\s+(\S+)\s+auf\s+(.+?)\s+setzen(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'feldSetzen', fieldName: m[1], value: unquote(m[2]), row: m[3]?.trim() || '' };

  // "Feld X zeigt Y [an]" / "Feld X zeigt Y, Zeile Z"
  m = t.match(/^Feld\s+(\S+)\s+zeigt\s+(.+?)(?:\s+an)?(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'feldPruefen', fieldName: m[1], expectedValue: unquote(m[2]), row: m[3]?.trim() || '' };

  // "Feld X hat Wert Y"
  m = t.match(/^Feld\s+(\S+)\s+hat\s+(?:den\s+)?Wert\s+(.+?)(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'feldPruefen', fieldName: m[1], expectedValue: unquote(m[2]), row: m[3]?.trim() || '' };

  // "Feld X ist leer" / "Feld X ist nicht leer"
  m = t.match(/^Feld\s+(\S+)\s+ist\s+nicht\s+leer(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'feldLeer', fieldName: m[1], isEmpty: false, row: m[2]?.trim() || '' };

  m = t.match(/^Feld\s+(\S+)\s+ist\s+leer(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'feldLeer', fieldName: m[1], isEmpty: true, row: m[2]?.trim() || '' };

  // "Feld X ist aenderbar/änderbar" / "Feld X ist gesperrt"
  m = t.match(/^Feld\s+(\S+)\s+ist\s+(?:ae|ä)nderbar(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'feldAenderbar', fieldName: m[1], modifiable: true, row: m[2]?.trim() || '' };

  m = t.match(/^Feld\s+(\S+)\s+ist\s+gesperrt(?:\s*,\s*Zeile\s+(.+))?$/i);
  if (m) return { type: 'feldAenderbar', fieldName: m[1], modifiable: false, row: m[2]?.trim() || '' };

  // "Speichern" (standalone)
  if (/^Speichern$/i.test(t)) return { type: 'editorSpeichern' };

  // "Schliessen/Schließen" (standalone)
  if (/^Schlie(?:ss|ß)en$/i.test(t)) return { type: 'editorSchliessen' };

  // "Fehlermeldung X erscheint" / "Exception X"
  m = t.match(/^(?:Fehlermeldung|Exception)\s+(.+?)(?:\s+erscheint)?$/i);
  if (m) return { type: 'exceptionSpeichern', exceptionId: unquote(m[1]) };

  // === Custom action patterns from profile ===
  if (customActions && customActions.length > 0) {
    for (const ca of customActions) {
      try {
        const re = new RegExp(ca.pattern, 'i');
        const match = t.match(re);
        if (match) {
          // Build step text from template, replacing {1}, {2}, etc. with capture groups
          let stepText = ca.stepText;
          for (let i = 1; i < match.length; i++) {
            stepText = stepText.replace(`{${i}}`, match[i] ?? '');
          }
          // Custom actions produce freetext with generated text
          return { type: 'freetext' };
        }
      } catch {
        // Invalid regex — skip silently
      }
    }
  }

  // === Fallback: freetext ===
  return { type: 'freetext' };
}

function parseEditorOeffnen(t: string): StepAction | null {
  const prefixMatch = t.match(/^Editor (?:oeffnen|öffnen):\s*/i);
  if (!prefixMatch) return null;
  const rest = t.slice(prefixMatch[0].length).trim();
  const parts = rest.split(',').map(s => s.trim());

  if (parts.length < 3) return null;

  const editorName = unquote(parts[0]);
  const tableRef = unquote(parts[1]);
  const rawCommand = parts[2].toUpperCase();
  const command = (VALID_COMMANDS.has(rawCommand) ? rawCommand : 'NEW') as EditorCommand;

  if (parts.length === 3) {
    return { type: 'editorOeffnen', editorName, tableRef, command, record: '' };
  }

  // Rejoin remaining parts (values might contain commas)
  const remaining = parts.slice(3).join(', ').trim();

  // Suche variant
  if (/^Suche\b/i.test(remaining)) {
    const criteria = remaining.replace(/^Suche\s*/i, '');
    return { type: 'editorOeffnenSuche', editorName, tableRef, command, searchCriteria: unquote(criteria) };
  }

  // Menue/Menü variant (possibly with Datensatz before it)
  const menuMatch = remaining.match(/^(.+?)\s*,\s*Men(?:ue|ü)\s+(.+)$/i);
  if (menuMatch) {
    const record = menuMatch[1].replace(/^Datensatz\s*/i, '').trim();
    return { type: 'editorOeffnenMenue', editorName, tableRef, command, record: unquote(record), menuChoice: unquote(menuMatch[2]) };
  }

  // Just a record (optionally prefixed with "Datensatz")
  const record = remaining.replace(/^Datensatz\s*/i, '').trim();
  return { type: 'editorOeffnen', editorName, tableRef, command, record: unquote(record) };
}

// ── Main parser ───────────────────────────────────────────────

export function parseConsultantTemplate(text: string, profile?: ParseProfile): FeatureInput {
  const p = profile ?? DEFAULT_PARSE_PROFILE;
  const stepAliasMap = buildStepAliasMap(p);

  const result: FeatureInput = {
    name: '',
    description: '',
    tags: [],
    database: null,
    testUser: '',
    scenarios: [],
  };

  const lines = text.split('\n');
  let currentScenario: { name: string; comment: string; steps: Step[] } | null = null;
  let lastStepCategory: StepCategory | null = null;

  for (const rawLine of lines) {
    const line = rawLine.trim();

    // Skip empty lines, template markers, dividers
    if (line === '' || line.startsWith('===') || line.startsWith('---')) {
      continue;
    }

    // ── Feature-level fields ────────────────────────────────

    const featureVal = matchKeyword(line, p.keywords.feature);
    if (featureVal !== null) {
      if (!isPlaceholder(featureVal)) result.name = featureVal;
      continue;
    }

    const dbVal = matchKeyword(line, p.keywords.database);
    if (dbVal !== null) {
      continue;
    }

    const testUserVal = matchKeyword(line, p.keywords.testUser);
    if (testUserVal !== null) {
      if (!isPlaceholder(testUserVal)) result.testUser = testUserVal;
      continue;
    }

    const tagsVal = matchKeyword(line, p.keywords.tags);
    if (tagsVal !== null) {
      if (!isPlaceholder(tagsVal)) {
        const tags = tagsVal.split(/[,\s]+/).filter(t => t.length > 0);
        result.tags.push(...tags.map(t => (t.startsWith('@') ? t : `@${t}`)));
      }
      continue;
    }

    const descVal = matchKeyword(line, p.keywords.description);
    if (descVal !== null) {
      if (!isPlaceholder(descVal)) result.description = descVal;
      continue;
    }

    // ── Scenario detection ──────────────────────────────────

    const scenarioVal = matchKeyword(line, p.keywords.scenario);
    if (scenarioVal !== null) {
      if (currentScenario) {
        pushScenario(result, currentScenario);
      }
      currentScenario = { name: isPlaceholder(scenarioVal) ? '' : scenarioVal, comment: '', steps: [] };
      lastStepCategory = null;
      continue;
    }

    // ── Scenario comment ────────────────────────────────────

    const commentVal = matchKeyword(line, p.keywords.comment);
    if (currentScenario && commentVal !== null) {
      if (!isPlaceholder(commentVal)) {
        currentScenario.comment = currentScenario.comment
          ? currentScenario.comment + '\n' + commentVal
          : commentVal;
      }
      continue;
    }

    // ── Steps ───────────────────────────────────────────────

    if (!currentScenario) continue;

    // Explicit And/But keywords
    const andVal = matchKeyword(line, p.stepKeywords.and);
    if (andVal !== null) {
      if (!isPlaceholder(andVal)) {
        currentScenario.steps.push(makeStep('And', andVal, p.customActions));
      }
      continue;
    }

    const butVal = matchKeyword(line, p.stepKeywords.but);
    if (butVal !== null) {
      if (!isPlaceholder(butVal)) {
        currentScenario.steps.push(makeStep('But', butVal, p.customActions));
      }
      continue;
    }

    // Primary step types (precondition / action / result)
    const stepMatch = matchStepAlias(line, stepAliasMap);
    if (stepMatch) {
      if (!isPlaceholder(stepMatch.value)) {
        const actualKeyword = lastStepCategory === stepMatch.category ? 'And' : stepMatch.keyword;
        currentScenario.steps.push(makeStep(actualKeyword, stepMatch.value, p.customActions));
        lastStepCategory = stepMatch.category;
      }
      continue;
    }
  }

  // Save last scenario
  if (currentScenario) {
    pushScenario(result, currentScenario);
  }

  return result;
}

// ── Step factory ──────────────────────────────────────────────

function makeStep(keyword: StepKeyword, text: string, customActions?: CustomActionPattern[]): Step {
  const action = parseActionFromText(text, customActions);

  // For custom actions: use template-generated text
  // For structured actions: generate English Gherkin step text
  // For freetext: keep the original consultant text
  let stepText = text;
  if (action.type !== 'freetext') {
    stepText = stepTextFromAction(action).text;
  } else if (customActions && customActions.length > 0) {
    // Check if this matches a custom action for text generation
    const customText = tryCustomActionText(text, customActions);
    if (customText !== null) {
      stepText = customText;
    }
  }

  return {
    id: crypto.randomUUID(),
    keyword,
    text: stepText,
    action,
  };
}

/**
 * Tries to match text against custom action patterns and returns
 * the generated step text, or null if no match.
 */
function tryCustomActionText(text: string, customActions: CustomActionPattern[]): string | null {
  const t = text.trim();
  for (const ca of customActions) {
    try {
      const re = new RegExp(ca.pattern, 'i');
      const match = t.match(re);
      if (match) {
        let stepText = ca.stepText;
        for (let i = 1; i < match.length; i++) {
          stepText = stepText.replace(`{${i}}`, match[i] ?? '');
        }
        return stepText;
      }
    } catch {
      // Invalid regex — skip
    }
  }
  return null;
}

function pushScenario(result: FeatureInput, s: { name: string; comment: string; steps: Step[] }) {
  result.scenarios.push({
    id: crypto.randomUUID(),
    name: s.name,
    ...(s.comment ? { comment: s.comment } : {}),
    steps: s.steps,
  });
}

// ── Download format description ───────────────────────────────

export function downloadFormatDescription(): void {
  const blob = new Blob([FORMAT_DESCRIPTION], { type: 'text/plain;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'testformat-cucumbergnerator.txt';
  a.click();
  URL.revokeObjectURL(url);
}
