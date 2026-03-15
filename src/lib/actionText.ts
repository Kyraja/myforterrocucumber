import type { StepAction, StepKeyword, ActionType } from '../types/gherkin';

export interface ActionTextResult {
  keyword: StepKeyword;
  text: string;
}

export function stepTextFromAction(action: StepAction): ActionTextResult {
  switch (action.type) {
    case 'editorOeffnen': {
      const editor = action.editorName || '...';
      const table = action.tableRef || '...';
      return {
        keyword: 'Given',
        text: `I open an editor "${editor}" from table "${table}" with command "${action.command}" for record "${action.record}"`,
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
      return {
        keyword: 'Given',
        text: `I open an editor "${editor}" from table "${table}" with command "${action.command}" for record "${action.record}" and menu choice "${action.menuChoice}"`,
      };
    }

    case 'feldSetzen': {
      if (action.multi) {
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
};

export const EDITOR_COMMANDS = [
  'NEW', 'UPDATE', 'STORE', 'VIEW', 'DELETE', 'COPY',
  'DELIVERY', 'INVOICE', 'REVERSAL', 'RELEASE', 'PAYMENT',
  'CALCULATE', 'TRANSFER', 'DONE',
] as const;

export function createDefaultAction(type: ActionType): StepAction {
  switch (type) {
    case 'freetext':
      return { type: 'freetext' };
    case 'editorOeffnen':
      return { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'STORE', record: '' };
    case 'editorOeffnenSuche':
      return { type: 'editorOeffnenSuche', editorName: '', tableRef: '', command: 'VIEW', searchCriteria: '' };
    case 'editorOeffnenMenue':
      return { type: 'editorOeffnenMenue', editorName: '', tableRef: '', command: 'STORE', record: '', menuChoice: '' };
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
  }
}
