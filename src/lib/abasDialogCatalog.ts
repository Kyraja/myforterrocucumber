/**
 * @module abasDialogCatalog
 *
 * Katalog bekannter abas-Standard-Dialog-IDs.
 *
 * In abas gibt es zwei Arten von Dialog-Boxen, die vom Cucumber-Step
 * `And I respond with answer "<Antwort>" to the dialog with id "<id>"` adressiert werden:
 *
 * 1. STANDARD-Meldungen — System-Dialoge aus der abas-Meldungstexte-Datenbank.
 *    Sie haben eine **numerische** ID (z.B. "4841" bei INVOICE-Bestaetigung).
 *    Diese Datei liefert einen Default-Katalog der haeufigsten Standard-IDs als Hilfe
 *    fuer die KI-Generierung.
 *
 * 2. Individuelle Customizing-Dialoge — FOP-Boxen aus Y-Code.
 *    Sie werden ueber den **Titel-/erste-Zeile-Text** adressiert, NICHT ueber eine ID.
 *    Diese Dialoge kann man nicht katalogisieren — der Prompt muss dem Modell
 *    beibringen, den Text direkt aus dem Anforderungsdokument zu uebernehmen.
 *
 * Der Katalog wird per `getEffectiveDialogCatalog()` aus `settings.ts` geladen und
 * im User-Prompt (nicht im System-Prompt — wegen Prompt-Caching) mit eingebettet.
 * Nutzer koennen den Katalog ueber die Einstellungen mit projektspezifischen IDs
 * aus der Meldungstexte-DB ihres Kunden erweitern.
 */

export type DialogAntwort = 'ja' | 'nein' | 'Ja' | 'Nein' | 'yes' | 'no' | '1' | '2';

export interface DialogEntry {
  /** Kurzer Kontext, in dem dieser Dialog typischerweise erscheint */
  kontext: string;
  /** Typischer Meldungstext (DE, zur Orientierung des Modells) */
  text: string;
  /** Uebliche Antwort im Happy-Path */
  standardAntwort: DialogAntwort;
  /** Kommando oder Operation, bei dem dieser Dialog aufkommt (optional) */
  triggerCommand?: string;
}

/**
 * Ausgelieferte Defaults — extrahiert aus den Gold-Standard-Features in docs/cucumber.
 * Die IDs sind belegt; die Meldungstexte sind sinngemaess und dienen nur der Orientierung.
 * Erweiterbar ueber die Einstellungen (User-Overlay in localStorage).
 */
export const DEFAULT_STANDARD_DIALOG_CATALOG: Record<string, DialogEntry> = {
  '4841': {
    kontext: 'Rechnung buchen (INVOICE-Bestaetigung)',
    text: 'Rechnung buchen?',
    standardAntwort: 'ja',
    triggerCommand: 'INVOICE',
  },
  '4181': {
    kontext: 'AfA-Modell speichern',
    text: 'AfA-Modell speichern?',
    standardAntwort: 'Ja',
  },
  '4477': {
    kontext: 'AfA-Vorschlag verbuchen',
    text: 'Vorschlag verbuchen?',
    standardAntwort: 'Ja',
  },
  '4479': {
    kontext: 'Anlage waehrend Vorgang geaendert',
    text: 'Anlage wurde geaendert — trotzdem fortfahren?',
    standardAntwort: 'Nein',
  },
  '826': {
    kontext: 'Planperioden / Absatzplanung — Bestaetigung',
    text: 'Bestaetigen?',
    standardAntwort: 'ja',
  },
  '4958': {
    kontext: 'Absatzplanung — Planzeitaenderung bestaetigen',
    text: 'Planzeit aendern?',
    standardAntwort: 'ja',
  },
};
