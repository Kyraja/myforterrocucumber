import { describe, it, expect } from 'vitest';
import { parseConsultantTemplate, parseActionFromText, TEMPLATE_TEXT, levenshtein } from './consultantTemplate';

// ── parseActionFromText unit tests ──────────────────────────

describe('parseActionFromText', () => {
  // Parameterless
  it('parses Editor speichern', () => {
    expect(parseActionFromText('Editor speichern')).toMatchObject({ type: 'editorSpeichern' });
  });

  it('parses Editor schliessen', () => {
    expect(parseActionFromText('Editor schliessen')).toMatchObject({ type: 'editorSchliessen' });
  });

  it('parses Zeile anlegen', () => {
    expect(parseActionFromText('Zeile anlegen')).toMatchObject({ type: 'zeileAnlegen' });
  });

  // Single-param
  it('parses Editor wechseln', () => {
    expect(parseActionFromText('Editor wechseln: Kundenstamm')).toMatchObject({
      type: 'editorWechseln', editorName: 'Kundenstamm',
    });
  });

  it('parses Button druecken', () => {
    expect(parseActionFromText('Button druecken: freig')).toMatchObject({
      type: 'buttonDruecken', buttonName: 'freig',
    });
  });

  it('parses Infosystem oeffnen with Suchwort in both fields', () => {
    expect(parseActionFromText('Infosystem oeffnen: UMSATZAUSWERTUNG')).toMatchObject({
      type: 'infosystemOeffnen', infosystemName: 'UMSATZAUSWERTUNG', infosystemRef: 'UMSATZAUSWERTUNG',
    });
  });

  it('parses Tabelle hat N Zeilen', () => {
    expect(parseActionFromText('Tabelle hat 5 Zeilen')).toMatchObject({
      type: 'tabelleZeilen', rowCount: '5',
    });
  });

  it('parses Exception beim Speichern', () => {
    expect(parseActionFromText('Exception beim Speichern: EX-001')).toMatchObject({
      type: 'exceptionSpeichern', exceptionId: 'EX-001',
    });
  });

  // Field operations
  it('parses Feld setzen with quoted value', () => {
    expect(parseActionFromText('Feld setzen: ykat = "A-Kunde"')).toMatchObject({
      type: 'feldSetzen', fieldName: 'ykat', value: 'A-Kunde', row: '',
    });
  });

  it('parses Feld setzen with row', () => {
    expect(parseActionFromText('Feld setzen: ykat = "Wert", Zeile 3')).toMatchObject({
      type: 'feldSetzen', fieldName: 'ykat', value: 'Wert', row: '3',
    });
  });

  it('parses Feld setzen with unquoted value', () => {
    expect(parseActionFromText('Feld setzen: ykat = Test')).toMatchObject({
      type: 'feldSetzen', fieldName: 'ykat', value: 'Test', row: '',
    });
  });

  it('parses Feld pruefen', () => {
    expect(parseActionFromText('Feld pruefen: ykat = "A-Kunde"')).toMatchObject({
      type: 'feldPruefen', fieldName: 'ykat', expectedValue: 'A-Kunde', row: '',
    });
  });

  it('parses Feld pruefen with row', () => {
    expect(parseActionFromText('Feld pruefen: ykat = "A-Kunde", Zeile 2')).toMatchObject({
      type: 'feldPruefen', fieldName: 'ykat', expectedValue: 'A-Kunde', row: '2',
    });
  });

  it('parses Feld leer', () => {
    expect(parseActionFromText('Feld leer: ykat')).toMatchObject({
      type: 'feldLeer', fieldName: 'ykat', isEmpty: true, row: '',
    });
  });

  it('parses Feld nicht leer', () => {
    expect(parseActionFromText('Feld nicht leer: ykat')).toMatchObject({
      type: 'feldLeer', fieldName: 'ykat', isEmpty: false, row: '',
    });
  });

  it('parses Feld leer with row', () => {
    expect(parseActionFromText('Feld leer: ykat, Zeile 1')).toMatchObject({
      type: 'feldLeer', fieldName: 'ykat', isEmpty: true, row: '1',
    });
  });

  it('parses Feld aenderbar', () => {
    expect(parseActionFromText('Feld aenderbar: ykat')).toMatchObject({
      type: 'feldAenderbar', fieldName: 'ykat', modifiable: true, row: '',
    });
  });

  it('parses Feld gesperrt', () => {
    expect(parseActionFromText('Feld gesperrt: ykat')).toMatchObject({
      type: 'feldAenderbar', fieldName: 'ykat', modifiable: false, row: '',
    });
  });

  // Editor oeffnen variants
  it('parses Editor oeffnen (basic)', () => {
    expect(parseActionFromText('Editor oeffnen: Kundenstamm, 0:1, NEW')).toMatchObject({
      type: 'editorOeffnen', editorName: 'Kundenstamm', tableRef: '0:1', command: 'NEW', record: '',
    });
  });

  it('parses Editor oeffnen with record', () => {
    expect(parseActionFromText('Editor oeffnen: Kundenstamm, 0:1, UPDATE, Datensatz 12345')).toMatchObject({
      type: 'editorOeffnen', editorName: 'Kundenstamm', tableRef: '0:1', command: 'UPDATE', record: '12345',
    });
  });

  it('parses Editor oeffnen with record without Datensatz prefix', () => {
    expect(parseActionFromText('Editor oeffnen: Kundenstamm, 0:1, UPDATE, 12345')).toMatchObject({
      type: 'editorOeffnen', editorName: 'Kundenstamm', tableRef: '0:1', command: 'UPDATE', record: '12345',
    });
  });

  it('parses Editor oeffnen with Suche', () => {
    expect(parseActionFromText('Editor oeffnen: Kundenstamm, 0:1, VIEW, Suche swd=TESTCUST')).toMatchObject({
      type: 'editorOeffnenSuche', editorName: 'Kundenstamm', tableRef: '0:1', command: 'VIEW', searchCriteria: 'swd=TESTCUST',
    });
  });

  it('parses Editor oeffnen with Menue', () => {
    expect(parseActionFromText('Editor oeffnen: Kundenstamm, 0:1, NEW, Datensatz 123, Menue Spezial')).toMatchObject({
      type: 'editorOeffnenMenue', editorName: 'Kundenstamm', tableRef: '0:1', command: 'NEW', record: '123', menuChoice: 'Spezial',
    });
  });

  // Subeditor
  it('parses Subeditor oeffnen', () => {
    expect(parseActionFromText('Subeditor oeffnen: positionen, Positionen')).toMatchObject({
      type: 'subeditorOeffnen', buttonName: 'positionen', subeditorName: 'Positionen', row: '',
    });
  });

  it('parses Subeditor oeffnen with row', () => {
    expect(parseActionFromText('Subeditor oeffnen: positionen, Positionen, Zeile 2')).toMatchObject({
      type: 'subeditorOeffnen', buttonName: 'positionen', subeditorName: 'Positionen', row: '2',
    });
  });

  // Exception bei Feld
  it('parses Exception bei Feld', () => {
    expect(parseActionFromText('Exception bei Feld: ykat = "UNGUELTIG", Exception EX-002')).toMatchObject({
      type: 'exceptionFeld', fieldName: 'ykat', value: 'UNGUELTIG', exceptionId: 'EX-002',
    });
  });

  // Dialog
  it('parses Dialog beantworten', () => {
    expect(parseActionFromText('Dialog beantworten: DLG-001, Antwort Ja')).toMatchObject({
      type: 'dialogBeantworten', dialogId: 'DLG-001', answer: 'Ja',
    });
  });

  // Umlaut variants (real German umlauts instead of ASCII equivalents)
  it('parses Editor schließen (ß)', () => {
    expect(parseActionFromText('Editor schließen')).toMatchObject({ type: 'editorSchliessen' });
  });

  it('parses Editor öffnen (ö)', () => {
    expect(parseActionFromText('Editor öffnen: Kundenstamm, P0:1, NEW')).toMatchObject({
      type: 'editorOeffnen', editorName: 'Kundenstamm',
    });
  });

  it('parses Button drücken (ü)', () => {
    expect(parseActionFromText('Button drücken: freig')).toMatchObject({
      type: 'buttonDruecken', buttonName: 'freig',
    });
  });

  it('parses Infosystem öffnen (ö)', () => {
    expect(parseActionFromText('Infosystem öffnen: TESTINFO')).toMatchObject({
      type: 'infosystemOeffnen', infosystemName: 'TESTINFO',
    });
  });

  it('parses Feld prüfen (ü)', () => {
    expect(parseActionFromText('Feld prüfen: name = "Test"')).toMatchObject({
      type: 'feldPruefen', fieldName: 'name', expectedValue: 'Test',
    });
  });

  it('parses Feld änderbar (ä)', () => {
    expect(parseActionFromText('Feld änderbar: name')).toMatchObject({
      type: 'feldAenderbar', fieldName: 'name', modifiable: true,
    });
  });

  it('parses Subeditor öffnen (ö)', () => {
    expect(parseActionFromText('Subeditor öffnen: details, Artikeldetails')).toMatchObject({
      type: 'subeditorOeffnen', buttonName: 'details', subeditorName: 'Artikeldetails',
    });
  });

  it('parses Editor öffnen with Menü (ü)', () => {
    expect(parseActionFromText('Editor öffnen: Kundenstamm, P0:1, NEW, Datensatz 70000, Menü Kopie')).toMatchObject({
      type: 'editorOeffnenMenue', editorName: 'Kundenstamm', menuChoice: 'Kopie',
    });
  });

  // Natural language variants
  it('parses "Feld X auf Y setzen"', () => {
    expect(parseActionFromText('Feld ykundenkategorie auf "A-Kunde" setzen')).toMatchObject({
      type: 'feldSetzen', fieldName: 'ykundenkategorie', value: 'A-Kunde',
    });
  });

  it('parses "Feld X auf Y setzen, Zeile Z"', () => {
    expect(parseActionFromText('Feld mge auf "5" setzen, Zeile 1')).toMatchObject({
      type: 'feldSetzen', fieldName: 'mge', value: '5', row: '1',
    });
  });

  it('parses "Feld X zeigt Y an"', () => {
    expect(parseActionFromText('Feld ykundenkategorie zeigt "A-Kunde" an')).toMatchObject({
      type: 'feldPruefen', fieldName: 'ykundenkategorie', expectedValue: 'A-Kunde',
    });
  });

  it('parses "Feld X zeigt Y" (without an)', () => {
    expect(parseActionFromText('Feld status zeigt "aktiv"')).toMatchObject({
      type: 'feldPruefen', fieldName: 'status', expectedValue: 'aktiv',
    });
  });

  it('parses "Feld X hat Wert Y"', () => {
    expect(parseActionFromText('Feld name hat Wert "Test"')).toMatchObject({
      type: 'feldPruefen', fieldName: 'name', expectedValue: 'Test',
    });
  });

  it('parses "Feld X hat den Wert Y"', () => {
    expect(parseActionFromText('Feld name hat den Wert "Test"')).toMatchObject({
      type: 'feldPruefen', fieldName: 'name', expectedValue: 'Test',
    });
  });

  it('parses "Feld X ist leer"', () => {
    expect(parseActionFromText('Feld bemerkung ist leer')).toMatchObject({
      type: 'feldLeer', fieldName: 'bemerkung', isEmpty: true,
    });
  });

  it('parses "Feld X ist nicht leer"', () => {
    expect(parseActionFromText('Feld name ist nicht leer')).toMatchObject({
      type: 'feldLeer', fieldName: 'name', isEmpty: false,
    });
  });

  it('parses "Feld X ist änderbar"', () => {
    expect(parseActionFromText('Feld name ist änderbar')).toMatchObject({
      type: 'feldAenderbar', fieldName: 'name', modifiable: true,
    });
  });

  it('parses "Feld X ist gesperrt"', () => {
    expect(parseActionFromText('Feld name ist gesperrt')).toMatchObject({
      type: 'feldAenderbar', fieldName: 'name', modifiable: false,
    });
  });

  it('parses standalone "Speichern"', () => {
    expect(parseActionFromText('Speichern')).toMatchObject({ type: 'editorSpeichern' });
  });

  it('parses standalone "Schließen"', () => {
    expect(parseActionFromText('Schließen')).toMatchObject({ type: 'editorSchliessen' });
  });

  it('parses "Fehlermeldung X erscheint"', () => {
    expect(parseActionFromText('Fehlermeldung EX-KATEGORIE erscheint')).toMatchObject({
      type: 'exceptionSpeichern', exceptionId: 'EX-KATEGORIE',
    });
  });

  it('parses "Exception X"', () => {
    expect(parseActionFromText('Exception EX-TEST')).toMatchObject({
      type: 'exceptionSpeichern', exceptionId: 'EX-TEST',
    });
  });

  // Freetext fallback
  it('falls back to freetext for unrecognized text', () => {
    expect(parseActionFromText('Die Maske ist geoeffnet')).toMatchObject({ type: 'freetext' });
  });

  it('falls back to freetext for empty text', () => {
    expect(parseActionFromText('')).toMatchObject({ type: 'freetext' });
  });
});

// ── parseConsultantTemplate integration tests ───────────────

describe('parseConsultantTemplate', () => {
  it('parses feature name', () => {
    const result = parseConsultantTemplate('Feature: Kundenklassifizierung erweitern');
    expect(result.name).toBe('Kundenklassifizierung erweitern');
  });

  it('recognizes database line without generating tag', () => {
    const result = parseConsultantTemplate('Feature: Test\nDatenbank: V-00-01');
    expect(result.tags).not.toContain('@DB-1000');
    expect(result.tags).toHaveLength(0);
  });

  it('parses test user', () => {
    const result = parseConsultantTemplate('Feature: Test\nTestbenutzer: sy');
    expect(result.testUser).toBe('sy');
  });

  it('parses tags (comma-separated)', () => {
    const result = parseConsultantTemplate('Feature: Test\nTags: @smoke, @vertrieb');
    expect(result.tags).toContain('@smoke');
    expect(result.tags).toContain('@vertrieb');
  });

  it('adds @ prefix to tags without it', () => {
    const result = parseConsultantTemplate('Feature: Test\nTags: smoke, regression');
    expect(result.tags).toContain('@smoke');
    expect(result.tags).toContain('@regression');
  });

  it('parses description', () => {
    const result = parseConsultantTemplate('Feature: Test\nBeschreibung: Neues Feld anlegen');
    expect(result.description).toBe('Neues Feld anlegen');
  });

  it('parses a scenario with freetext steps', () => {
    const text = `Feature: Test
Szenario: Freitext
Vorbedingung: Die Maske ist geoeffnet
Aktion: Das Feld wird gesetzt
Ergebnis: Der Wert ist korrekt`;

    const result = parseConsultantTemplate(text);
    const steps = result.scenarios[0].steps;
    expect(steps).toHaveLength(3);
    expect(steps[0]).toMatchObject({ keyword: 'Given', text: 'Die Maske ist geoeffnet' });
    expect(steps[0].action).toMatchObject({ type: 'freetext' });
    expect(steps[1]).toMatchObject({ keyword: 'When', text: 'Das Feld wird gesetzt' });
    expect(steps[2]).toMatchObject({ keyword: 'Then', text: 'Der Wert ist korrekt' });
  });

  it('parses structured actions and generates English step text', () => {
    const text = `Feature: Test
Szenario: Strukturiert
Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, NEW
Aktion: Feld setzen: ykat = "A-Kunde"
Aktion: Editor speichern
Ergebnis: Feld pruefen: ykat = "A-Kunde"`;

    const result = parseConsultantTemplate(text);
    const steps = result.scenarios[0].steps;
    expect(steps).toHaveLength(4);

    // Editor oeffnen → English text + structured action
    expect(steps[0].keyword).toBe('Given');
    expect(steps[0].text).toContain('I open an editor "Kundenstamm"');
    expect(steps[0].action).toMatchObject({ type: 'editorOeffnen', editorName: 'Kundenstamm', command: 'NEW' });

    // Feld setzen → English text + structured action
    expect(steps[1].keyword).toBe('When');
    expect(steps[1].text).toContain('I set field "ykat" to "A-Kunde"');
    expect(steps[1].action).toMatchObject({ type: 'feldSetzen', fieldName: 'ykat', value: 'A-Kunde' });

    // Editor speichern → English text + structured action
    expect(steps[2].keyword).toBe('And');
    expect(steps[2].text).toBe('I save the current editor');
    expect(steps[2].action).toMatchObject({ type: 'editorSpeichern' });

    // Feld pruefen → English text + structured action
    expect(steps[3].keyword).toBe('Then');
    expect(steps[3].text).toContain('field "ykat" has value "A-Kunde"');
    expect(steps[3].action).toMatchObject({ type: 'feldPruefen', fieldName: 'ykat', expectedValue: 'A-Kunde' });
  });

  it('maps consecutive same-type steps to And', () => {
    const text = `Feature: Test
Szenario: Mehrere
Vorbedingung: Maske ist offen
Vorbedingung: Datensatz ist angelegt
Aktion: Editor speichern
Aktion: Editor schliessen
Ergebnis: Feld leer: ykat
Ergebnis: Feld gesperrt: ykat`;

    const result = parseConsultantTemplate(text);
    const steps = result.scenarios[0].steps;
    expect(steps).toHaveLength(6);
    expect(steps[0].keyword).toBe('Given');
    expect(steps[1].keyword).toBe('And');
    expect(steps[2].keyword).toBe('When');
    expect(steps[3].keyword).toBe('And');
    expect(steps[4].keyword).toBe('Then');
    expect(steps[5].keyword).toBe('And');
  });

  it('handles explicit Und and Aber keywords', () => {
    const text = `Feature: Test
Szenario: Explizit
Vorbedingung: Maske ist offen
Und: Benutzer ist eingeloggt
Aktion: Editor speichern
Aber: Eine Warnung erscheint
Ergebnis: Feld leer: ykat`;

    const result = parseConsultantTemplate(text);
    const steps = result.scenarios[0].steps;
    expect(steps[0].keyword).toBe('Given');
    expect(steps[1].keyword).toBe('And');
    expect(steps[2].keyword).toBe('When');
    expect(steps[3].keyword).toBe('But');
    expect(steps[4].keyword).toBe('Then');
  });

  it('parses multiple scenarios', () => {
    const text = `Feature: Multi
Szenario: Erstes
Vorbedingung: A
Ergebnis: B

Szenario: Zweites
Vorbedingung: C
Ergebnis: D`;

    const result = parseConsultantTemplate(text);
    expect(result.scenarios).toHaveLength(2);
    expect(result.scenarios[0].name).toBe('Erstes');
    expect(result.scenarios[1].name).toBe('Zweites');
  });

  it('parses scenario comments', () => {
    const text = `Feature: Test
Szenario: Mit Kommentar
Kommentar: Dies ist ein Testkommentar
Vorbedingung: Etwas
Ergebnis: Etwas anderes`;

    const result = parseConsultantTemplate(text);
    expect(result.scenarios[0].comment).toBe('Dies ist ein Testkommentar');
  });

  it('ignores placeholder values in brackets', () => {
    const result = parseConsultantTemplate(TEMPLATE_TEXT);
    expect(result.name).toBe('');
    expect(result.testUser).toBe('');
    expect(result.description).toBe('');
    expect(result.tags).toHaveLength(0);
    expect(result.scenarios.every(s => s.steps.length === 0)).toBe(true);
  });

  it('ignores template markers (=== and ---)', () => {
    const text = `=== Testvorlage ===
Feature: Test
---
Szenario: Eins
Vorbedingung: X
Ergebnis: Y
=== Ende ===`;

    const result = parseConsultantTemplate(text);
    expect(result.name).toBe('Test');
    expect(result.scenarios).toHaveLength(1);
  });

  it('does not generate DB tag but keeps other tags', () => {
    const text = `Feature: Test
Datenbank: P2:1
Tags: @smoke`;

    const result = parseConsultantTemplate(text);
    expect(result.tags).not.toContain('@DB-P2:1');
    expect(result.tags).toContain('@smoke');
  });

  it('returns empty feature for empty input', () => {
    const result = parseConsultantTemplate('');
    expect(result.name).toBe('');
    expect(result.scenarios).toHaveLength(0);
  });

  it('handles full realistic example with structured actions', () => {
    const text = `Feature: Kundenklassifizierung erweitern
Datenbank: V-00-01
Testbenutzer: cucumber
Tags: @smoke, @vertrieb
Beschreibung: Neues Feld ykundenkategorie im Kundenstamm

Szenario: Feld setzen und speichern
Kommentar: Grundfunktion testen
Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, NEW
Aktion: Feld setzen: ykundenkategorie = "A-Kunde"
Aktion: Editor speichern
Ergebnis: Feld pruefen: ykundenkategorie = "A-Kunde"

Szenario: Ungueltige Kategorie abfangen
Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, NEW
Aktion: Feld setzen: ykundenkategorie = ""
Ergebnis: Exception beim Speichern: EX-KATEGORIE`;

    const result = parseConsultantTemplate(text);
    expect(result.name).toBe('Kundenklassifizierung erweitern');
    expect(result.testUser).toBe('cucumber');
    expect(result.description).toBe('Neues Feld ykundenkategorie im Kundenstamm');
    expect(result.tags).toEqual(['@smoke', '@vertrieb']);

    expect(result.scenarios).toHaveLength(2);

    const s1 = result.scenarios[0];
    expect(s1.name).toBe('Feld setzen und speichern');
    expect(s1.comment).toBe('Grundfunktion testen');
    expect(s1.steps).toHaveLength(4);
    expect(s1.steps[0].action.type).toBe('editorOeffnen');
    expect(s1.steps[1].action.type).toBe('feldSetzen');
    expect(s1.steps[2].action.type).toBe('editorSpeichern');
    expect(s1.steps[3].action.type).toBe('feldPruefen');

    const s2 = result.scenarios[1];
    expect(s2.steps).toHaveLength(3);
    expect(s2.steps[2].action.type).toBe('exceptionSpeichern');
  });

  it('mixes freetext and structured actions in same scenario', () => {
    const text = `Feature: Test
Szenario: Gemischt
Vorbedingung: Der Benutzer ist im System eingeloggt
Aktion: Feld setzen: ykat = "Test"
Ergebnis: Die Aenderung ist sichtbar`;

    const result = parseConsultantTemplate(text);
    const steps = result.scenarios[0].steps;
    expect(steps[0].action.type).toBe('freetext');
    expect(steps[0].text).toBe('Der Benutzer ist im System eingeloggt');
    expect(steps[1].action.type).toBe('feldSetzen');
    expect(steps[1].text).toContain('I set field');
    expect(steps[2].action.type).toBe('freetext');
    expect(steps[2].text).toBe('Die Aenderung ist sichtbar');
  });
});

// ── Levenshtein distance ─────────────────────────────────────

describe('levenshtein', () => {
  it('returns 0 for identical strings', () => {
    expect(levenshtein('abc', 'abc')).toBe(0);
  });

  it('counts single character substitution', () => {
    expect(levenshtein('cat', 'car')).toBe(1);
  });

  it('counts insertion and deletion', () => {
    expect(levenshtein('abc', 'ab')).toBe(1);
    expect(levenshtein('ab', 'abc')).toBe(1);
  });

  it('handles typical typos in keywords', () => {
    expect(levenshtein('szenaroi', 'szenario')).toBe(2);
    expect(levenshtein('vorbedinugng', 'vorbedingung')).toBe(2);
    expect(levenshtein('aktoin', 'aktion')).toBe(2);
    expect(levenshtein('ergebnsi', 'ergebnis')).toBe(2);
  });

  it('handles empty strings', () => {
    expect(levenshtein('', 'abc')).toBe(3);
    expect(levenshtein('abc', '')).toBe(3);
    expect(levenshtein('', '')).toBe(0);
  });
});

// ── Case-insensitive keyword matching ────────────────────────

describe('parseConsultantTemplate — case-insensitive matching', () => {
  it('matches lowercase keywords', () => {
    const text = `feature: Mein Feature
szenario: Test
vorbedingung: Etwas
aktion: Noch was
ergebnis: Resultat`;

    const result = parseConsultantTemplate(text);
    expect(result.name).toBe('Mein Feature');
    expect(result.scenarios).toHaveLength(1);
    expect(result.scenarios[0].name).toBe('Test');
    expect(result.scenarios[0].steps).toHaveLength(3);
    expect(result.scenarios[0].steps[0].keyword).toBe('Given');
    expect(result.scenarios[0].steps[1].keyword).toBe('When');
    expect(result.scenarios[0].steps[2].keyword).toBe('Then');
  });

  it('matches mixed case keywords', () => {
    const text = `FEATURE: Uppercase
SZENARIO: Test
VORBEDINGUNG: X
ERGEBNIS: Y`;

    const result = parseConsultantTemplate(text);
    expect(result.name).toBe('Uppercase');
    expect(result.scenarios).toHaveLength(1);
  });

  it('matches lowercase und/aber', () => {
    const text = `Feature: Test
Szenario: Multi
Vorbedingung: A
und: B
Ergebnis: C
aber: D`;

    const result = parseConsultantTemplate(text);
    expect(result.scenarios[0].steps).toHaveLength(4);
    expect(result.scenarios[0].steps[1].keyword).toBe('And');
    expect(result.scenarios[0].steps[3].keyword).toBe('But');
  });
});

// ── Fuzzy keyword matching (Levenshtein) ─────────────────────

describe('parseConsultantTemplate — fuzzy keyword matching', () => {
  it('matches "Szenaroi" as typo for "Szenario" (dist 2)', () => {
    const text = `Feature: Test
Szenaroi: Vertippt
Vorbedingung: X
Ergebnis: Y`;

    const result = parseConsultantTemplate(text);
    expect(result.scenarios).toHaveLength(1);
    expect(result.scenarios[0].name).toBe('Vertippt');
  });

  it('matches "Vorbedinugng" as typo for "Vorbedingung" (dist 2)', () => {
    const text = `Feature: Test
Szenario: Typo-Step
Vorbedinugng: Etwas vertippt
Ergebnis: OK`;

    const result = parseConsultantTemplate(text);
    expect(result.scenarios[0].steps).toHaveLength(2);
    expect(result.scenarios[0].steps[0].keyword).toBe('Given');
    expect(result.scenarios[0].steps[0].text).toBe('Etwas vertippt');
  });

  it('matches "Ergebnsi" as typo for "Ergebnis" (dist 2)', () => {
    const text = `Feature: Test
Szenario: Test
Vorbedingung: X
Ergebnsi: Auch vertippt`;

    const result = parseConsultantTemplate(text);
    expect(result.scenarios[0].steps).toHaveLength(2);
    expect(result.scenarios[0].steps[1].keyword).toBe('Then');
  });

  it('does NOT fuzzy-match short keywords like "Und" (too risky)', () => {
    const text = `Feature: Test
Szenario: Test
Vorbedingung: X
Uma: Sollte nicht matchen`;

    const result = parseConsultantTemplate(text);
    // "Uma:" should not match "Und:" (too short for fuzzy)
    expect(result.scenarios[0].steps).toHaveLength(1);
  });
});

// ── English keyword matching ─────────────────────────────────

describe('parseConsultantTemplate — English keywords', () => {
  it('parses a fully English document', () => {
    const text = `Feature: Customer Classification
Database: V-00-01
Test User: sy
Tags: @sales
Description: New field for customer categories

Scenario: Set category and save
Precondition: Editor oeffnen: Kundenstamm, P0:1, NEW
Action: Feld setzen: ykat = "A"
Result: Feld pruefen: ykat = "A"

Scenario: Invalid category
Precondition: Editor oeffnen: Kundenstamm, P0:1, NEW
Action: Feld setzen: ykat = ""
Result: Exception beim Speichern: EX-KAT`;

    const result = parseConsultantTemplate(text);
    expect(result.name).toBe('Customer Classification');
    expect(result.testUser).toBe('sy');
    expect(result.description).toBe('New field for customer categories');
    expect(result.tags).toEqual(['@sales']);
    expect(result.scenarios).toHaveLength(2);
    expect(result.scenarios[0].name).toBe('Set category and save');
    expect(result.scenarios[0].steps).toHaveLength(3);
    expect(result.scenarios[0].steps[0].keyword).toBe('Given');
    expect(result.scenarios[0].steps[1].keyword).toBe('When');
    expect(result.scenarios[0].steps[2].keyword).toBe('Then');
  });

  it('handles mixed German/English keywords', () => {
    const text = `Feature: Mischung
Datenbank: V-00-01
Scenario: English scenario name
Precondition: Editor oeffnen: Artikel, P2:1, NEW
Aktion: Editor speichern
Result: Feld nicht leer: such`;

    const result = parseConsultantTemplate(text);
    expect(result.scenarios).toHaveLength(1);
    expect(result.scenarios[0].name).toBe('English scenario name');
    expect(result.scenarios[0].steps).toHaveLength(3);
  });

  it('handles English And/But keywords', () => {
    const text = `Feature: Test
Scenario: Multi
Given: First step
And: Second step
Then: Check result
But: Exception case`;

    const result = parseConsultantTemplate(text);
    const steps = result.scenarios[0].steps;
    expect(steps).toHaveLength(4);
    expect(steps[0].keyword).toBe('Given');
    expect(steps[1].keyword).toBe('And');
    expect(steps[2].keyword).toBe('Then');
    expect(steps[3].keyword).toBe('But');
  });
});
