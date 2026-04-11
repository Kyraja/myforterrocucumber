import { describe, it, expect } from 'vitest';
import * as XLSX from 'xlsx';
import { parseWorkPackageXlsx } from './workPackageParser';

function makeXlsx(rows: Record<string, string>[]): ArrayBuffer {
  const ws = XLSX.utils.json_to_sheet(rows);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');
  const out = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });
  return out;
}

describe('parseWorkPackageXlsx', () => {
  it('parses standard German columns', () => {
    const buf = makeXlsx([
      { Ueberschrift: 'Feld erweitern', Beschreibung: 'Neues Feld im Kundenstamm', Prioritaet: 'Hoch', Bereich: 'Vertrieb', Umsetzungszeit: '4h', 'QS-Zeit': '1h' },
    ]);
    const result = parseWorkPackageXlsx(buf);
    expect(result).toHaveLength(1);
    expect(result[0].title).toBe('Feld erweitern');
    expect(result[0].description).toBe('Neues Feld im Kundenstamm');
    expect(result[0].priority).toBe('Hoch');
    expect(result[0].area).toBe('Vertrieb');
    expect(result[0].implementationTime).toBe('4h');
    expect(result[0].qaTime).toBe('1h');
  });

  it('parses columns with umlauts', () => {
    const buf = makeXlsx([
      { 'Überschrift': 'Test', Beschreibung: 'Desc', 'Priorität': 'Mittel' },
    ]);
    const result = parseWorkPackageXlsx(buf);
    expect(result).toHaveLength(1);
    expect(result[0].title).toBe('Test');
    expect(result[0].priority).toBe('Mittel');
  });

  it('parses English column names', () => {
    const buf = makeXlsx([
      { Title: 'Field check', Description: 'Test desc', Priority: 'High', Area: 'Sales' },
    ]);
    const result = parseWorkPackageXlsx(buf);
    expect(result).toHaveLength(1);
    expect(result[0].title).toBe('Field check');
    expect(result[0].area).toBe('Sales');
  });

  it('skips rows without title and description', () => {
    const buf = makeXlsx([
      { Ueberschrift: 'Valid', Beschreibung: 'Has desc' },
      { Ueberschrift: '', Beschreibung: '' },
      { Prioritaet: 'Hoch' },
    ]);
    const result = parseWorkPackageXlsx(buf);
    expect(result).toHaveLength(1);
  });

  it('keeps rows with only title or only description', () => {
    const buf = makeXlsx([
      { Ueberschrift: 'Title only', Beschreibung: '' },
      { Ueberschrift: '', Beschreibung: 'Description only' },
    ]);
    const result = parseWorkPackageXlsx(buf);
    expect(result).toHaveLength(2);
  });

  it('handles multiple rows', () => {
    const buf = makeXlsx([
      { Ueberschrift: 'A', Beschreibung: 'Desc A' },
      { Ueberschrift: 'B', Beschreibung: 'Desc B' },
      { Ueberschrift: 'C', Beschreibung: 'Desc C' },
    ]);
    const result = parseWorkPackageXlsx(buf);
    expect(result).toHaveLength(3);
    expect(result.map((r) => r.title)).toEqual(['A', 'B', 'C']);
  });

  it('assigns unique ids', () => {
    const buf = makeXlsx([
      { Ueberschrift: 'A', Beschreibung: 'X' },
      { Ueberschrift: 'B', Beschreibung: 'Y' },
    ]);
    const result = parseWorkPackageXlsx(buf);
    expect(result[0].id).not.toBe(result[1].id);
  });

  it('defaults missing optional fields to empty string', () => {
    const buf = makeXlsx([
      { Ueberschrift: 'Minimal', Beschreibung: 'Only required' },
    ]);
    const result = parseWorkPackageXlsx(buf);
    expect(result[0].implementationTime).toBe('');
    expect(result[0].qaTime).toBe('');
    expect(result[0].priority).toBe('');
    expect(result[0].area).toBe('');
  });

  it('returns empty array for empty buffer', () => {
    const ws = XLSX.utils.json_to_sheet([]);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');
    const buf = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });
    const result = parseWorkPackageXlsx(buf);
    expect(result).toHaveLength(0);
  });
});
