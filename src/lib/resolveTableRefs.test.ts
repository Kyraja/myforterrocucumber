import { describe, it, expect } from 'vitest';
import { resolveTableRefs } from './resolveTableRefs';
import type { FeatureInput, TableDef } from '../types/gherkin';

const tables: TableDef[] = [
  { database: '0', group: '1', tableRef: '0:1', name: 'Kundenstamm', fields: [], kind: 'database' },
  { database: '2', group: '1', tableRef: '2:1', name: 'Verkaufsauftrag', fields: [], kind: 'database' },
  { database: '0', group: '6', tableRef: '0:6', name: 'Artikelstamm', fields: [], kind: 'database' },
  { database: '', group: '', tableRef: 'UMSATZINFO', name: 'Umsatzauswertung', fields: [], kind: 'infosystem' },
];

function makeFeature(steps: FeatureInput['scenarios'][0]['steps']): FeatureInput {
  return {
    name: 'Test',
    description: '',
    tags: [],
    database: null,
    testUser: '',
    scenarios: [{ id: '1', name: 'S1', steps }],
  };
}

describe('resolveTableRefs', () => {
  it('resolves editor name to numeric tableRef', () => {
    const feature = makeFeature([{
      id: 's1',
      keyword: 'Given',
      text: 'I open an editor "Kundenstamm" from table "Kundenstamm" with command "STORE" for record ""',
      action: { type: 'editorOeffnen', editorName: 'Kundenstamm', tableRef: 'Kundenstamm', command: 'STORE', record: '' },
    }]);

    const resolved = resolveTableRefs(feature, tables);
    const action = resolved.scenarios[0].steps[0].action;
    expect(action.type).toBe('editorOeffnen');
    if (action.type === 'editorOeffnen') {
      expect(action.tableRef).toBe('0:1');
    }
    expect(resolved.scenarios[0].steps[0].text).toContain('from table "0:1"');
  });

  it('leaves already-numeric refs unchanged', () => {
    const feature = makeFeature([{
      id: 's1',
      keyword: 'Given',
      text: 'I open an editor "Kunde" from table "0:1" with command "NEW" for record ""',
      action: { type: 'editorOeffnen', editorName: 'Kunde', tableRef: '0:1', command: 'NEW', record: '' },
    }]);

    const resolved = resolveTableRefs(feature, tables);
    const action = resolved.scenarios[0].steps[0].action;
    if (action.type === 'editorOeffnen') {
      expect(action.tableRef).toBe('0:1');
    }
  });

  it('is case-insensitive when matching names', () => {
    const feature = makeFeature([{
      id: 's1',
      keyword: 'Given',
      text: 'I open an editor "verkaufsauftrag" from table "verkaufsauftrag" with command "NEW" for record ""',
      action: { type: 'editorOeffnen', editorName: 'verkaufsauftrag', tableRef: 'verkaufsauftrag', command: 'NEW', record: '' },
    }]);

    const resolved = resolveTableRefs(feature, tables);
    const action = resolved.scenarios[0].steps[0].action;
    if (action.type === 'editorOeffnen') {
      expect(action.tableRef).toBe('2:1');
    }
  });

  it('leaves unrecognized names unchanged', () => {
    const feature = makeFeature([{
      id: 's1',
      keyword: 'Given',
      text: 'I open an editor "Unbekannt" from table "Unbekannt" with command "NEW" for record ""',
      action: { type: 'editorOeffnen', editorName: 'Unbekannt', tableRef: 'Unbekannt', command: 'NEW', record: '' },
    }]);

    const resolved = resolveTableRefs(feature, tables);
    const action = resolved.scenarios[0].steps[0].action;
    if (action.type === 'editorOeffnen') {
      expect(action.tableRef).toBe('Unbekannt');
    }
  });

  it('resolves editorOeffnenSuche', () => {
    const feature = makeFeature([{
      id: 's1',
      keyword: 'Given',
      text: 'I open an editor "Artikelstamm" from table "Artikelstamm" with command "UPDATE" for search criteria "A*"',
      action: { type: 'editorOeffnenSuche', editorName: 'Artikelstamm', tableRef: 'Artikelstamm', command: 'UPDATE', searchCriteria: 'A*' },
    }]);

    const resolved = resolveTableRefs(feature, tables);
    const action = resolved.scenarios[0].steps[0].action;
    if (action.type === 'editorOeffnenSuche') {
      expect(action.tableRef).toBe('0:6');
    }
    expect(resolved.scenarios[0].steps[0].text).toContain('from table "0:6"');
  });

  it('does nothing when tables are empty', () => {
    const feature = makeFeature([{
      id: 's1',
      keyword: 'Given',
      text: 'I open an editor "Kunde" from table "Kunde" with command "NEW" for record ""',
      action: { type: 'editorOeffnen', editorName: 'Kunde', tableRef: 'Kunde', command: 'NEW', record: '' },
    }]);

    const resolved = resolveTableRefs(feature, []);
    expect(resolved).toBe(feature); // Same reference — no changes
  });

  it('does not modify non-editor steps', () => {
    const feature = makeFeature([{
      id: 's1',
      keyword: 'And',
      text: 'I set field "name" to "Test"',
      action: { type: 'feldSetzen', fieldName: 'name', value: 'Test', row: '' },
    }]);

    const resolved = resolveTableRefs(feature, tables);
    expect(resolved.scenarios[0].steps[0].action).toEqual(feature.scenarios[0].steps[0].action);
  });

  it('resolves via substring when AI name contains the table name', () => {
    // Table loaded as "Kunden" but AI generates "Kundenstamm"
    const shortNameTables: TableDef[] = [
      { database: '0', group: '1', tableRef: '0:1', name: 'Kunden', fields: [], kind: 'database' },
    ];
    const feature = makeFeature([{
      id: 's1',
      keyword: 'Given',
      text: 'I open an editor "Kundenstamm" from table "Kundenstamm" with command "STORE" for record ""',
      action: { type: 'editorOeffnen', editorName: 'Kundenstamm', tableRef: 'Kundenstamm', command: 'STORE', record: '' },
    }]);

    const resolved = resolveTableRefs(feature, shortNameTables);
    const action = resolved.scenarios[0].steps[0].action;
    if (action.type === 'editorOeffnen') {
      expect(action.tableRef).toBe('0:1');
    }
  });

  it('resolves via synonym when AI uses a different term', () => {
    // Table loaded as "Kunde" but AI generates "Kundenstamm"
    const synonymTables: TableDef[] = [
      { database: '0', group: '1', tableRef: '0:1', name: 'Kunde', fields: [], kind: 'database' },
    ];
    const feature = makeFeature([{
      id: 's1',
      keyword: 'Given',
      text: 'I open an editor "Kundenstamm" from table "Kundenstamm" with command "STORE" for record ""',
      action: { type: 'editorOeffnen', editorName: 'Kundenstamm', tableRef: 'Kundenstamm', command: 'STORE', record: '' },
    }]);

    const resolved = resolveTableRefs(feature, synonymTables);
    const action = resolved.scenarios[0].steps[0].action;
    if (action.type === 'editorOeffnen') {
      expect(action.tableRef).toBe('0:1');
    }
  });

  it('resolves via substring when table name contains the AI name', () => {
    // Table loaded as "Artikelstamm" but AI generates "Artikel"
    const feature = makeFeature([{
      id: 's1',
      keyword: 'Given',
      text: 'I open an editor "Artikel" from table "Artikel" with command "STORE" for record ""',
      action: { type: 'editorOeffnen', editorName: 'Artikel', tableRef: 'Artikel', command: 'STORE', record: '' },
    }]);

    const resolved = resolveTableRefs(feature, tables);
    const action = resolved.scenarios[0].steps[0].action;
    if (action.type === 'editorOeffnen') {
      expect(action.tableRef).toBe('0:6');
    }
  });
});
