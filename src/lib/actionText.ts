/**
 * Converts a {@link StepAction} discriminated union into the canonical Gherkin
 * step text and the appropriate keyword (`Given` / `When` / `Then` / `And`).
 *
 * This is the single source of truth for how each action type is serialized to
 * human-readable Gherkin. Both the generator and the step-row preview use this
 * module so that display and output are always in sync.
 *
 * Also exports:
 *  - {@link ACTION_LABELS} — short German display names for the action-type dropdown.
 *  - {@link ACTION_HELP}   — longer German tooltips explaining each action type.
 *  - {@link EDITOR_COMMANDS} — all valid abas editor command strings.
 *  - {@link createDefaultAction} — factory that produces a blank action for a given type.
 */
import type { StepAction, StepKeyword, ActionType } from '../types/gherkin';

/** The keyword and step text pair produced by {@link stepTextFromAction}. */
export interface ActionTextResult {
  keyword: StepKeyword;
  text: string;
}

/**
 * Format the "record" portion of an editor-open step. Supports two variants:
 * - Chained from a previously opened editor (`recordFromEditor` set) →
 *   `for record from editor "<name>"`.
 * - Direct record number / search word (`record` set, may be empty) →
 *   `for record "<value>"`.
 * `recordFromEditor` wins when both are set.
 */
function formatRecordPart(action: { record: string; recordFromEditor?: string }): string {
  if (action.recordFromEditor && action.recordFromEditor.trim()) {
    return `for record from editor "${action.recordFromEditor}"`;
  }
  return `for record "${action.record}"`;
}

/**
 * Derive the Gherkin step keyword and text for a given {@link StepAction}.
 *
 * Placeholder `'...'` is used for any field that is still empty, ensuring the
 * result is always syntactically valid Gherkin even during editing.
 *
 * @param action - The structured step action to serialize.
 * @returns The corresponding Gherkin keyword and step text.
 */
export function stepTextFromAction(action: StepAction): ActionTextResult {
  switch (action.type) {
    case 'editorOeffnen': {
      const editor = action.editorName || '...';
      const table = action.tableRef || '...';
      const recordPart = formatRecordPart(action);
      return {
        keyword: 'Given',
        text: `I open an editor "${editor}" from table "${table}" with command "${action.command}" ${recordPart}`,
      };
    }

    case 'editorOeffnenSuche': {
      const editor = action.editorName || '...';
      const table = action.tableRef || '...';
      const criteria = action.searchCriteria || '...';
      return {
        keyword: 'Given',
        text: `I open an editor "${editor}" from table "${table}" with command "${action.command}" for search criteria "${criteria}"`,
      };
    }

    case 'editorOeffnenMenue': {
      const editor = action.editorName || '...';
      const table = action.tableRef || '...';
      const recordPart = formatRecordPart(action);
      return {
        keyword: 'Given',
        text: `I open an editor "${editor}" from table "${table}" with command "${action.command}" ${recordPart} and menu choice "${action.menuChoice}"`,
      };
    }

    case 'feldSetzen': {
      if (action.multi) {
        if (action.row) {
          return { keyword: 'And', text: `I set fields in row ${action.row}` };
        }
        return { keyword: 'And', text: 'I set fields' };
      }
      const field = action.fieldName || '...';
      const val = action.value || '...';
      if (action.row) {
        return { keyword: 'And', text: `I set field "${field}" to "${val}" in row ${action.row}` };
      }
      return { keyword: 'And', text: `I set field "${field}" to "${val}"` };
    }

    case 'feldPruefen': {
      const field = action.fieldName || '...';
      const val = action.expectedValue || '...';
      if (action.row) {
        return { keyword: 'Then', text: `field "${field}" has value "${val}" in row ${action.row}` };
      }
      return { keyword: 'Then', text: `field "${field}" has value "${val}"` };
    }

    case 'feldLeer': {
      const field = action.fieldName || '...';
      const state = action.isEmpty ? 'is empty' : 'is not empty';
      if (action.row) {
        return { keyword: 'Then', text: `field "${field}" ${state} in row ${action.row}` };
      }
      return { keyword: 'Then', text: `field "${field}" ${state}` };
    }

    case 'feldAenderbar': {
      const field = action.fieldName || '...';
      const mod = action.modifiable ? 'is modifiable' : 'is not modifiable';
      if (action.row) {
        return { keyword: 'Then', text: `field "${field}" ${mod} in row ${action.row}` };
      }
      return { keyword: 'Then', text: `field "${field}" ${mod}` };
    }

    case 'editorSpeichern':
      return { keyword: 'And', text: 'I save the current editor' };

    case 'editorSchliessen':
      return { keyword: 'And', text: 'I close the current editor' };

    case 'subeditorSchliessen':
      return { keyword: 'And', text: 'I close the current subeditor to switch back to the parent editor' };

    case 'subeditorSpeichern':
      return { keyword: 'And', text: 'I save the current subeditor to switch back to the parent editor' };

    case 'editorWechseln': {
      const name = action.editorName || '...';
      return { keyword: 'And', text: `I switch the current editor to editor "${name}"` };
    }

    case 'zeileAnlegen':
      return { keyword: 'And', text: 'I create a new row at the end of the table' };

    case 'buttonDruecken': {
      const btn = action.buttonName || '...';
      if (action.row) {
        return { keyword: 'And', text: `I press button "${btn}" in row ${action.row}` };
      }
      return { keyword: 'And', text: `I press button "${btn}"` };
    }

    case 'subeditorOeffnen': {
      const btn = action.buttonName || '...';
      const name = action.subeditorName || '...';
      if (action.row) {
        return { keyword: 'And', text: `I press button "${btn}" to open a subeditor for "${name}" in row ${action.row}` };
      }
      return { keyword: 'And', text: `I press button "${btn}" to open a subeditor for "${name}"` };
    }

    case 'infosystemOeffnen': {
      const name = action.infosystemRef || action.infosystemName || '...';
      return { keyword: 'Given', text: `I open the infosystem "${name}"` };
    }

    case 'tabelleZeilen': {
      const count = action.rowCount || '0';
      return { keyword: 'Then', text: `the table has ${count} rows` };
    }

    case 'exceptionSpeichern': {
      const exc = action.exceptionId || '...';
      return { keyword: 'Then', text: `saving the current editor throws the exception "${exc}"` };
    }

    case 'exceptionFeld': {
      const field = action.fieldName || '...';
      const val = action.value || '...';
      const exc = action.exceptionId || '...';
      return { keyword: 'Then', text: `setting field "${field}" to "${val}" throws the exception "${exc}"` };
    }

    case 'dialogBeantworten': {
      const answer = action.answer || '...';
      const id = action.dialogId || '...';
      return { keyword: 'And', text: `I respond with answer "${answer}" to the dialog with id "${id}"` };
    }

    case 'zeilenAnfuegen':
      return { keyword: 'And', text: 'I append rows' };

    case 'boxMeldung': {
      const msg = action.messageText || '...';
      return { keyword: 'Then', text: `message "${msg}" was displayed` };
    }

    case 'editorOeffnenTipp': {
      const editor = action.editorName || '...';
      const cmd = action.tipCommand || '...';
      const args = action.arguments ?? '';
      return { keyword: 'Given', text: `I open an editor "${editor}" for tip command "${cmd}" and arguments "${args}"` };
    }

    case 'freetext':
      return { keyword: 'Given', text: '' };
  }
}

/** Labels shown in the action type dropdown (German) */
export const ACTION_LABELS: Record<ActionType, string> = {
  freetext: 'Freitext',
  editorOeffnen: 'Editor oeffnen',
  editorOeffnenSuche: 'Editor oeffnen (Suche)',
  editorOeffnenMenue: 'Editor oeffnen (Menue)',
  feldSetzen: 'Feld setzen',
  feldPruefen: 'Feld pruefen',
  feldLeer: 'Feld leer/nicht leer',
  feldAenderbar: 'Feld aenderbar',
  editorSpeichern: 'Editor speichern',
  editorSchliessen: 'Editor schliessen',
  subeditorSchliessen: 'Subeditor schliessen',
  subeditorSpeichern: 'Subeditor speichern',
  editorWechseln: 'Editor wechseln',
  zeileAnlegen: 'Neue Zeile',
  buttonDruecken: 'Button druecken',
  subeditorOeffnen: 'Subeditor oeffnen',
  infosystemOeffnen: 'Infosystem oeffnen',
  tabelleZeilen: 'Tabelle Zeilenanzahl',
  exceptionSpeichern: 'Exception (Speichern)',
  exceptionFeld: 'Exception (Feld)',
  dialogBeantworten: 'Dialog beantworten',
  zeilenAnfuegen: 'Zeilen anfuegen',
  boxMeldung: 'Box-Meldung pruefen',
  editorOeffnenTipp: 'Tippkommando ausfuehren',
};

/** Labels shown in the action type dropdown (English) */
export const ACTION_LABELS_EN: Record<ActionType, string> = {
  freetext: 'Free text',
  editorOeffnen: 'Open editor',
  editorOeffnenSuche: 'Open editor (search)',
  editorOeffnenMenue: 'Open editor (menu)',
  feldSetzen: 'Set field',
  feldPruefen: 'Check field',
  feldLeer: 'Field empty/not empty',
  feldAenderbar: 'Field editable',
  editorSpeichern: 'Save editor',
  editorSchliessen: 'Close editor',
  subeditorSchliessen: 'Close subeditor',
  subeditorSpeichern: 'Save subeditor',
  editorWechseln: 'Switch editor',
  zeileAnlegen: 'New row',
  buttonDruecken: 'Press button',
  subeditorOeffnen: 'Open subeditor',
  infosystemOeffnen: 'Open infosystem',
  tabelleZeilen: 'Table row count',
  exceptionSpeichern: 'Exception (save)',
  exceptionFeld: 'Exception (field)',
  dialogBeantworten: 'Answer dialog',
  zeilenAnfuegen: 'Append rows',
  boxMeldung: 'Check box message',
  editorOeffnenTipp: 'Run tip command',
};

/** Help texts explaining each action type for consultants */
export const ACTION_HELP: Record<ActionType, string> = {
  freetext: 'Beliebigen Step-Text frei eingeben',
  editorOeffnen: 'Einen abas-Editor (Maske) oeffnen mit Datenbank, Kommando und optionalem Datensatz',
  editorOeffnenSuche: 'Editor oeffnen und Datensatz per Suchkriterium finden',
  editorOeffnenMenue: 'Editor oeffnen und Menuauswahl treffen',
  feldSetzen: 'Ein Feld im aktuellen Editor auf einen bestimmten Wert setzen',
  feldPruefen: 'Pruefen ob ein Feld den erwarteten Wert hat',
  feldLeer: 'Pruefen ob ein Feld leer oder nicht leer ist',
  feldAenderbar: 'Pruefen ob ein Feld aenderbar (editierbar) oder gesperrt ist',
  editorSpeichern: 'Den aktuellen Editor speichern (Ctrl+S)',
  editorSchliessen: 'Den aktuellen Editor schliessen',
  editorWechseln: 'Zu einem anderen geoeffneten Editor wechseln',
  zeileAnlegen: 'Eine neue Zeile am Ende der Tabelle anlegen',
  buttonDruecken: 'Einen Button im Editor druecken (z.B. freig, buchen)',
  subeditorOeffnen: 'Einen Subeditor ueber einen Button oeffnen (z.B. Positionen)',
  infosystemOeffnen: 'Ein abas-Infosystem oeffnen und ausfuehren',
  tabelleZeilen: 'Pruefen wie viele Zeilen die Tabelle hat',
  exceptionSpeichern: 'Pruefen dass beim Speichern eine bestimmte Exception auftritt',
  exceptionFeld: 'Pruefen dass beim Setzen eines Feldwertes eine Exception auftritt',
  dialogBeantworten: 'Einen abas-Dialog mit einer bestimmten Antwort beantworten',
  zeilenAnfuegen: 'Mehrere Tabellenzeilen kompakt anfuegen (Feldnamen als Kopfzeile, Werte als Datenzeilen)',
  boxMeldung: 'Pruefen dass eine Hinweis-/Info-Box mit dem angegebenen Meldungstext angezeigt wurde',
  editorOeffnenTipp: 'Einen Editor ueber ein abas-Tippkommando oeffnen (z.B. Fbuchung, (Stockadjustment), (Scheduling))',
};

/** Help texts (English) */
export const ACTION_HELP_EN: Record<ActionType, string> = {
  freetext: 'Enter any step text freely',
  editorOeffnen: 'Open an abas editor (screen) with database, command and optional record',
  editorOeffnenSuche: 'Open editor and find record via search criterion',
  editorOeffnenMenue: 'Open editor and pick a menu entry',
  feldSetzen: 'Set a field in the current editor to a specific value',
  feldPruefen: 'Check that a field has the expected value',
  feldLeer: 'Check whether a field is empty or not empty',
  feldAenderbar: 'Check whether a field is editable or locked',
  editorSpeichern: 'Save the current editor (Ctrl+S)',
  editorSchliessen: 'Close the current editor',
  editorWechseln: 'Switch to another open editor',
  zeileAnlegen: 'Create a new row at the end of the table',
  buttonDruecken: 'Press a button in the editor (e.g. freig, buchen)',
  subeditorOeffnen: 'Open a subeditor via a button (e.g. Positions)',
  infosystemOeffnen: 'Open and run an abas infosystem',
  tabelleZeilen: 'Check how many rows the table has',
  exceptionSpeichern: 'Check that a specific exception occurs on save',
  exceptionFeld: 'Check that an exception occurs when setting a field value',
  dialogBeantworten: 'Answer an abas dialog with a specific answer',
  zeilenAnfuegen: 'Append multiple table rows compactly (field names as header, values as data rows)',
  boxMeldung: 'Check that an info/notice box with the given message text was displayed',
  editorOeffnenTipp: 'Open an editor via an abas tip command (e.g. Fbuchung, (Stockadjustment), (Scheduling))',
};

/** Returns the localized action label for the dropdown. */
export function getActionLabel(type: ActionType, lang: 'de' | 'en'): string {
  return lang === 'en' ? ACTION_LABELS_EN[type] : ACTION_LABELS[type];
}

/** Returns the localized action help text for tooltips. */
export function getActionHelp(type: ActionType, lang: 'de' | 'en'): string {
  return lang === 'en' ? ACTION_HELP_EN[type] : ACTION_HELP[type];
}

export const EDITOR_COMMANDS = [
  'NEW', 'UPDATE', 'STORE', 'VIEW', 'DELETE', 'COPY',
  'DELIVERY', 'INVOICE', 'REVERSAL', 'RELEASE', 'PAYMENT',
  'CALCULATE', 'TRANSFER', 'DONE',
] as const;

/**
 * Create a blank {@link StepAction} with all required fields set to empty
 * strings (or sensible defaults) for the given action type.
 *
 * Used by the editor when the user selects a new action type from the dropdown,
 * so the form always starts in a defined state.
 *
 * @param type - The action type to create a default for.
 * @returns A minimal valid action object of the requested type.
 */
export function createDefaultAction(type: ActionType): StepAction {
  switch (type) {
    case 'freetext':
      return { type: 'freetext' };
    case 'editorOeffnen':
      return { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'STORE', record: '', recordFromEditor: '' };
    case 'editorOeffnenSuche':
      return { type: 'editorOeffnenSuche', editorName: '', tableRef: '', command: 'VIEW', searchCriteria: '' };
    case 'editorOeffnenMenue':
      return { type: 'editorOeffnenMenue', editorName: '', tableRef: '', command: 'STORE', record: '', recordFromEditor: '', menuChoice: '' };
    case 'feldSetzen':
      return { type: 'feldSetzen', fieldName: '', value: '', row: '' };
    case 'feldPruefen':
      return { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' };
    case 'feldLeer':
      return { type: 'feldLeer', fieldName: '', isEmpty: true, row: '' };
    case 'feldAenderbar':
      return { type: 'feldAenderbar', fieldName: '', modifiable: true, row: '' };
    case 'editorSpeichern':
      return { type: 'editorSpeichern' };
    case 'editorSchliessen':
      return { type: 'editorSchliessen' };
    case 'editorWechseln':
      return { type: 'editorWechseln', editorName: '' };
    case 'zeileAnlegen':
      return { type: 'zeileAnlegen' };
    case 'buttonDruecken':
      return { type: 'buttonDruecken', buttonName: '', row: '' };
    case 'subeditorOeffnen':
      return { type: 'subeditorOeffnen', buttonName: '', subeditorName: '', row: '' };
    case 'infosystemOeffnen':
      return { type: 'infosystemOeffnen', infosystemName: '', infosystemRef: '' };
    case 'tabelleZeilen':
      return { type: 'tabelleZeilen', rowCount: '' };
    case 'exceptionSpeichern':
      return { type: 'exceptionSpeichern', exceptionId: '' };
    case 'exceptionFeld':
      return { type: 'exceptionFeld', fieldName: '', value: '', exceptionId: '' };
    case 'dialogBeantworten':
      return { type: 'dialogBeantworten', dialogId: '', answer: '' };
    case 'zeilenAnfuegen':
      return { type: 'zeilenAnfuegen' };
    case 'boxMeldung':
      return { type: 'boxMeldung', messageText: '' };
    case 'editorOeffnenTipp':
      return { type: 'editorOeffnenTipp', editorName: '', tipCommand: '', arguments: '' };
  }
}
