/**
 * @vitest-environment node
 */
import { describe, expect, it } from 'vitest';
import type { DataImportFieldMapping, DataImportItSettings } from '../types/dataImport';
import {
  buildImportItFieldHeader,
  buildImportItRows,
  computeImportItOptionCode,
  formatImportItDatabaseRef,
  resolveImportItOptionCode,
  DEFAULT_IMPORT_IT_SETTINGS,
} from './importItExport';

function mappingFor(column: string, field: string | null, overrides: Partial<DataImportFieldMapping> = {}): DataImportFieldMapping {
  return {
    column,
    field,
    source: 'manual',
    confidence: null,
    confidencePercent: null,
    dataType: null,
    fieldDataType: null,
    mapped: !!field,
    ...overrides,
  };
}

describe('formatImportItDatabaseRef', () => {
  it('pads the group to two digits', () => {
    expect(formatImportItDatabaseRef('33:3')).toBe('33:03');
    expect(formatImportItDatabaseRef('2:1')).toBe('2:01');
    expect(formatImportItDatabaseRef('12:08')).toBe('12:08');
  });

  it('keeps typing commands unchanged', () => {
    expect(formatImportItDatabaseRef('lbuchung')).toBe('lbuchung');
  });
});

describe('computeImportItOptionCode', () => {
  it('sums the bits of the selected options', () => {
    expect(computeImportItOptionCode([])).toBe(0);
    expect(computeImportItOptionCode(['disableFop'])).toBe(2);
    expect(computeImportItOptionCode(['createNew', 'clearTable'])).toBe(5);
  });

  it('prefers a manual override', () => {
    const settings: DataImportItSettings = { ...DEFAULT_IMPORT_IT_SETTINGS, options: ['createNew'], optionCodeOverride: 42 };
    expect(resolveImportItOptionCode(settings)).toBe(42);
  });
});

describe('buildImportItFieldHeader', () => {
  it('appends field options to the technical field name', () => {
    expect(buildImportItFieldHeader(mappingFor('Identnummer', 'nummer'))).toBe('nummer');
    expect(buildImportItFieldHeader(mappingFor('Identnummer', 'nummer', { importItOptions: ['notempty', 'modifiable'] })))
      .toBe('nummer@notempty@modifiable');
  });
});

describe('buildImportItRows', () => {
  const sheet = {
    name: 'Tabelle1',
    columns: ['Identnummer', 'Suchwort', 'Notiz'],
    rows: [
      { Identnummer: 300000, Suchwort: 'TEST.01', Notiz: null },
      { Identnummer: 300001, Suchwort: 'TEST.02', Notiz: 'x' },
    ],
  };

  it('writes the ImportIT header, field row and text data in mapping order', () => {
    const rows = buildImportItRows(
      sheet,
      [
        mappingFor('Suchwort', 'such'),
        mappingFor('Identnummer', 'nummer', { importItOptions: ['notempty'] }),
        mappingFor('Notiz', null),
      ],
      { ...DEFAULT_IMPORT_IT_SETTINGS, tableStartColumn: 2, options: ['disableFop'], smlNumber: '7' },
      '33:3',
    );

    expect(rows[0]).toEqual(['33:03', '2', '2', '7']);
    expect(rows[1]).toEqual(['such', 'nummer@notempty']);
    expect(rows[2]).toEqual(['TEST.01', '300000']);
    expect(rows[3]).toEqual(['TEST.02', '300001']);
  });

  it('renders empty cells for missing values', () => {
    const rows = buildImportItRows(sheet, [mappingFor('Notiz', 'bem')], DEFAULT_IMPORT_IT_SETTINGS, '2:1');
    expect(rows[0]).toEqual(['2:01', '0', '0', '']);
    expect(rows[2]).toEqual(['']);
    expect(rows[3]).toEqual(['x']);
  });
});
