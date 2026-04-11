import { describe, it, expect } from 'vitest';
import { stepTextFromAction, createDefaultAction } from './actionText';

describe('stepTextFromAction', () => {
  it('editorOeffnen with all params', () => {
    const result = stepTextFromAction({
      type: 'editorOeffnen',
      editorName: 'Kunde',
      tableRef: '0:1',
      command: 'NEW',
      record: '',
    });
    expect(result.keyword).toBe('Given');
    expect(result.text).toBe('I open an editor "Kunde" from table "0:1" with command "NEW" for record ""');
  });

  it('editorOeffnen with record', () => {
    const result = stepTextFromAction({
      type: 'editorOeffnen',
      editorName: 'Auftrag',
      tableRef: '2:1',
      command: 'UPDATE',
      record: 'TestAuftrag001',
    });
    expect(result.text).toContain('command "UPDATE" for record "TestAuftrag001"');
  });

  it('editorOeffnen with empty params uses placeholder', () => {
    const result = stepTextFromAction({
      type: 'editorOeffnen',
      editorName: '',
      tableRef: '',
      command: 'VIEW',
      record: '',
    });
    expect(result.text).toContain('"..."');
  });

  it('editorOeffnenSuche', () => {
    const result = stepTextFromAction({
      type: 'editorOeffnenSuche',
      editorName: 'Kunde',
      tableRef: '0:1',
      command: 'VIEW',
      searchCriteria: 'such==Test*',
    });
    expect(result.keyword).toBe('Given');
    expect(result.text).toBe('I open an editor "Kunde" from table "0:1" with command "VIEW" for search criteria "such==Test*"');
  });

  it('editorOeffnenMenue', () => {
    const result = stepTextFromAction({
      type: 'editorOeffnenMenue',
      editorName: 'Auftrag',
      tableRef: '2:1',
      command: 'NEW',
      record: 'TestRecord',
      menuChoice: 'Kopieren',
    });
    expect(result.keyword).toBe('Given');
    expect(result.text).toContain('for record "TestRecord" and menu choice "Kopieren"');
  });

  it('feldSetzen header field', () => {
    const result = stepTextFromAction({
      type: 'feldSetzen',
      fieldName: 'such',
      value: 'TestKunde001',
      row: '',
    });
    expect(result.keyword).toBe('And');
    expect(result.text).toBe('I set field "such" to "TestKunde001"');
  });

  it('feldSetzen with row', () => {
    const result = stepTextFromAction({
      type: 'feldSetzen',
      fieldName: 'artikel',
      value: 'V1',
      row: '1',
    });
    expect(result.text).toBe('I set field "artikel" to "V1" in row 1');
  });

  it('feldPruefen header field', () => {
    const result = stepTextFromAction({
      type: 'feldPruefen',
      fieldName: 'namebspr',
      expectedValue: 'Testfirma GmbH',
      row: '',
    });
    expect(result.keyword).toBe('Then');
    expect(result.text).toBe('field "namebspr" has value "Testfirma GmbH"');
  });

  it('feldPruefen with row', () => {
    const result = stepTextFromAction({
      type: 'feldPruefen',
      fieldName: 'mge',
      expectedValue: '50',
      row: '!lastRow',
    });
    expect(result.text).toBe('field "mge" has value "50" in row !lastRow');
  });

  it('feldLeer isEmpty=true without row', () => {
    const result = stepTextFromAction({
      type: 'feldLeer',
      fieldName: 'name',
      isEmpty: true,
      row: '',
    });
    expect(result.keyword).toBe('Then');
    expect(result.text).toBe('field "name" is empty');
  });

  it('feldLeer isEmpty=false', () => {
    const result = stepTextFromAction({
      type: 'feldLeer',
      fieldName: 'name',
      isEmpty: false,
      row: '',
    });
    expect(result.text).toBe('field "name" is not empty');
  });

  it('feldLeer with row', () => {
    const result = stepTextFromAction({
      type: 'feldLeer',
      fieldName: 'mge',
      isEmpty: true,
      row: '3',
    });
    expect(result.text).toBe('field "mge" is empty in row 3');
  });

  it('feldAenderbar modifiable', () => {
    const result = stepTextFromAction({
      type: 'feldAenderbar',
      fieldName: 'status',
      modifiable: true,
      row: '',
    });
    expect(result.keyword).toBe('Then');
    expect(result.text).toBe('field "status" is modifiable');
  });

  it('feldAenderbar not modifiable with row', () => {
    const result = stepTextFromAction({
      type: 'feldAenderbar',
      fieldName: 'id',
      modifiable: false,
      row: '2',
    });
    expect(result.text).toBe('field "id" is not modifiable in row 2');
  });

  it('editorSpeichern', () => {
    const result = stepTextFromAction({ type: 'editorSpeichern' });
    expect(result.keyword).toBe('And');
    expect(result.text).toBe('I save the current editor');
  });

  it('editorSchliessen', () => {
    const result = stepTextFromAction({ type: 'editorSchliessen' });
    expect(result.keyword).toBe('And');
    expect(result.text).toBe('I close the current editor');
  });

  it('editorWechseln', () => {
    const result = stepTextFromAction({
      type: 'editorWechseln',
      editorName: 'Lieferschein',
    });
    expect(result.keyword).toBe('And');
    expect(result.text).toBe('I switch the current editor to editor "Lieferschein"');
  });

  it('zeileAnlegen', () => {
    const result = stepTextFromAction({ type: 'zeileAnlegen' });
    expect(result.keyword).toBe('And');
    expect(result.text).toBe('I create a new row at the end of the table');
  });

  it('buttonDruecken', () => {
    const result = stepTextFromAction({
      type: 'buttonDruecken',
      buttonName: 'freig',
      row: '',
    });
    expect(result.keyword).toBe('And');
    expect(result.text).toBe('I press button "freig"');
  });

  it('buttonDruecken with row', () => {
    const result = stepTextFromAction({
      type: 'buttonDruecken',
      buttonName: 'freig',
      row: '3',
    });
    expect(result.keyword).toBe('And');
    expect(result.text).toBe('I press button "freig" in row 3');
  });

  it('subeditorOeffnen without row', () => {
    const result = stepTextFromAction({
      type: 'subeditorOeffnen',
      buttonName: 'details',
      subeditorName: 'Artikeldetails',
      row: '',
    });
    expect(result.keyword).toBe('And');
    expect(result.text).toBe('I press button "details" to open a subeditor for "Artikeldetails"');
  });

  it('subeditorOeffnen with row', () => {
    const result = stepTextFromAction({
      type: 'subeditorOeffnen',
      buttonName: 'details',
      subeditorName: 'Artikeldetails',
      row: '2',
    });
    expect(result.text).toBe('I press button "details" to open a subeditor for "Artikeldetails" in row 2');
  });

  it('infosystemOeffnen uses Suchwort (infosystemRef) in output', () => {
    const result = stepTextFromAction({
      type: 'infosystemOeffnen',
      infosystemName: 'Kundenuebersicht',
      infosystemRef: 'TESTINFO',
    });
    expect(result.keyword).toBe('Given');
    expect(result.text).toBe('I open the infosystem "TESTINFO"');
  });

  it('infosystemOeffnen falls back to infosystemName when ref is empty', () => {
    const result = stepTextFromAction({
      type: 'infosystemOeffnen',
      infosystemName: 'Testinfosystem',
      infosystemRef: '',
    });
    expect(result.keyword).toBe('Given');
    expect(result.text).toBe('I open the infosystem "Testinfosystem"');
  });

  it('tabelleZeilen', () => {
    const result = stepTextFromAction({
      type: 'tabelleZeilen',
      rowCount: '5',
    });
    expect(result.keyword).toBe('Then');
    expect(result.text).toBe('the table has 5 rows');
  });

  it('exceptionSpeichern', () => {
    const result = stepTextFromAction({
      type: 'exceptionSpeichern',
      exceptionId: 'EX-001',
    });
    expect(result.keyword).toBe('Then');
    expect(result.text).toBe('saving the current editor throws the exception "EX-001"');
  });

  it('exceptionFeld', () => {
    const result = stepTextFromAction({
      type: 'exceptionFeld',
      fieldName: 'mge',
      value: '-1',
      exceptionId: 'EX-NEG',
    });
    expect(result.keyword).toBe('Then');
    expect(result.text).toBe('setting field "mge" to "-1" throws the exception "EX-NEG"');
  });

  it('dialogBeantworten', () => {
    const result = stepTextFromAction({
      type: 'dialogBeantworten',
      answer: 'Ja',
      dialogId: 'CONFIRM_DELETE',
    });
    expect(result.keyword).toBe('And');
    expect(result.text).toBe('I respond with answer "Ja" to the dialog with id "CONFIRM_DELETE"');
  });

  it('freetext returns empty', () => {
    const result = stepTextFromAction({ type: 'freetext' });
    expect(result.text).toBe('');
  });
});

describe('createDefaultAction', () => {
  it('creates freetext action', () => {
    expect(createDefaultAction('freetext')).toEqual({ type: 'freetext' });
  });

  it('creates editorOeffnen with STORE command', () => {
    expect(createDefaultAction('editorOeffnen')).toEqual({
      type: 'editorOeffnen',
      editorName: '',
      tableRef: '',
      command: 'STORE',
      record: '',
    });
  });

  it('creates feldSetzen with empty fields', () => {
    expect(createDefaultAction('feldSetzen')).toEqual({
      type: 'feldSetzen',
      fieldName: '',
      value: '',
      row: '',
    });
  });

  it('creates editorSpeichern', () => {
    expect(createDefaultAction('editorSpeichern')).toEqual({ type: 'editorSpeichern' });
  });

  it('creates subeditorOeffnen', () => {
    expect(createDefaultAction('subeditorOeffnen')).toEqual({
      type: 'subeditorOeffnen',
      buttonName: '',
      subeditorName: '',
      row: '',
    });
  });

  it('creates dialogBeantworten', () => {
    expect(createDefaultAction('dialogBeantworten')).toEqual({
      type: 'dialogBeantworten',
      dialogId: '',
      answer: '',
    });
  });
});
