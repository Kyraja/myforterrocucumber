/**
 * @vitest-environment node
 */
import { describe, expect, it } from 'vitest';
import * as XLSX from 'xlsx';
import { parseTextDump, parseXlsx } from './csvTableParser';

function parseWorkbook(rows: unknown[][]) {
  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, XLSX.utils.aoa_to_sheet(rows), 'Variablen');
  return parseXlsx(XLSX.write(workbook, { type: 'array', bookType: 'xlsx' }));
}

describe('parseTextDump', () => {
  it('keeps the effective type from technical abas selection-list headers', () => {
    const text = [
      'vmnr1\tnummer\tsuch\tname1\tvbed\tvitefff\tvms\tvname\tvnname\tvskip\tvkt',
      '2\t1013\tV-02-01\tArtikel\tIdentnummer\tNK2\teditable\titnummer\t\tNo\tNo',
    ].join('\n');

    const table = parseTextDump(text).find((entry) => entry.tableRef === '2:1');

    expect(table?.fields).toContainEqual(expect.objectContaining({
      name: 'nummer',
      description: 'Identnummer',
      dataType: 'NK2',
    }));
  });

  it('keeps the effective type for infosystems from the same headers', () => {
    const text = [
      'nummer\tsuch\tname1\tvbed\tvitefff\tvms\tvname\tvkt',
      '10002\tLBEVOR\tBestellvorschlaege\tGruppe\tI9\talways read-only\titgrust\tNo',
    ].join('\n');

    const table = parseTextDump(text).find((entry) => entry.tableRef === 'LBEVOR');

    expect(table?.kind).toBe('infosystem');
    expect(table?.fields).toContainEqual(expect.objectContaining({
      name: 'grust',
      dataType: 'I9',
    }));
  });

  it('uses column 6 as the effective type fallback for variable-table XLSX exports', () => {
    const tables = parseWorkbook([
      ['Feld 1', 'Feld 2', 'Feld 3', 'Feld 4', 'Feld 5', 'Feld 6', 'Feld 7', 'Feld 8', 'Feld 9', 'Feld 10', 'Feld 11'],
      [2, 1013, 'V-02-01', 'Artikel', 'Identnummer', 'NK2', 'editable', 'itnummer', '', 'No', 'No'],
    ]);

    expect(tables.find((table) => table.tableRef === '2:1')?.fields).toContainEqual(expect.objectContaining({
      name: 'nummer',
      dataType: 'NK2',
    }));
  });

  it('uses column 5 as the effective type fallback for infosystem XLSX exports', () => {
    const tables = parseWorkbook([
      ['Feld 1', 'Feld 2', 'Feld 3', 'Feld 4', 'Feld 5', 'Feld 6', 'Feld 7', 'Feld 8'],
      [10002, 'LBEVOR', 'Bestellvorschlaege', 'Gruppe', 'I9', 'always read-only', 'itgrust', 'No'],
    ]);

    expect(tables.find((table) => table.tableRef === 'LBEVOR')?.fields).toContainEqual(expect.objectContaining({
      name: 'grust',
      dataType: 'I9',
    }));
  });
});
