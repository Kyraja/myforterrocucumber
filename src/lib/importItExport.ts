/**
 * @module importItExport
 * Builds import files for the abas "Data Import Toolkit" (infosystem IMPORTIT).
 *
 * Layout of the generated worksheet (only the first sheet is evaluated by ImportIT):
 *   Row 1: A = `Datenbank:Gruppe`, B = table-fields-start column (0 = none),
 *          C = option code, D = Sachmerkmalsleiste number
 *   Row 2: technical abas field names, optionally suffixed with `@fieldOption`
 *   Row 3+: one record per row
 *
 * All cells are written as text because ImportIT expects string content.
 */
import * as XLSX from 'xlsx';
import type {
  DataImportFieldMapping,
  DataImportItSettings,
  ImportItFieldOption,
  ImportItImportOption,
} from '../types/dataImport';
import type { ExcelSheet } from './excelParser';

export const IMPORT_IT_FIELD_OPTIONS: readonly ImportItFieldOption[] = [
  'notempty',
  'modifiable',
  'skip',
  'dontChangeIfEqual',
];

/**
 * Import options in the order documented by ImportIT. The option code written to
 * cell C1 is the sum of the bits of all selected options.
 */
export const IMPORT_IT_IMPORT_OPTIONS: readonly { key: ImportItImportOption; bit: number }[] = [
  { key: 'createNew', bit: 1 },
  { key: 'disableFop', bit: 2 },
  { key: 'clearTable', bit: 4 },
  { key: 'checkModifiable', bit: 8 },
  { key: 'englishVariables', bit: 16 },
  { key: 'dontChangeIfEqual', bit: 32 },
  { key: 'checkForbiddenChars', bit: 64 },
];

export const DEFAULT_IMPORT_IT_SETTINGS: DataImportItSettings = {
  tableStartColumn: 0,
  options: [],
  optionCodeOverride: null,
  smlNumber: '',
};

/** Normalizes a tableRef to the ImportIT convention with a two-digit group, e.g. `33:3` to `33:03`. */
export function formatImportItDatabaseRef(tableRef: string): string {
  const trimmed = tableRef.trim();
  const match = trimmed.match(/^(\d+)\s*:\s*(\d+)$/);
  if (!match) return trimmed;
  return `${match[1]}:${match[2].padStart(2, '0')}`;
}

export function computeImportItOptionCode(options: readonly ImportItImportOption[]): number {
  return IMPORT_IT_IMPORT_OPTIONS.reduce(
    (code, option) => (options.includes(option.key) ? code + option.bit : code),
    0,
  );
}

/** Resolves the effective option code, preferring a manual override from the consultant. */
export function resolveImportItOptionCode(settings: DataImportItSettings): number {
  return settings.optionCodeOverride ?? computeImportItOptionCode(settings.options);
}

/** Builds the row-2 header cell for a field, e.g. `nummer@notempty`. */
export function buildImportItFieldHeader(mapping: DataImportFieldMapping): string {
  const options = mapping.importItOptions ?? [];
  return `${mapping.field ?? ''}${options.map((option) => `@${option}`).join('')}`;
}

/** Returns the mappings exported to ImportIT, in their current (drag-and-drop) order. */
export function getExportableMappings(mappings: readonly DataImportFieldMapping[]): DataImportFieldMapping[] {
  return mappings.filter((mapping) => !!mapping.field?.trim());
}

function toText(value: string | number | boolean | null | undefined): string {
  if (value === null || value === undefined) return '';
  return String(value);
}

/** Builds the full worksheet contents as rows of text cells. */
export function buildImportItRows(
  sheet: ExcelSheet,
  mappings: readonly DataImportFieldMapping[],
  settings: DataImportItSettings,
  databaseRef: string,
): string[][] {
  const exportable = getExportableMappings(mappings);
  const header = [
    formatImportItDatabaseRef(databaseRef),
    String(settings.tableStartColumn),
    String(resolveImportItOptionCode(settings)),
    settings.smlNumber.trim(),
  ];
  const fieldRow = exportable.map(buildImportItFieldHeader);
  const dataRows = sheet.rows.map((row) => exportable.map((mapping) => toText(row[mapping.column])));
  return [header, fieldRow, ...dataRows];
}

/** Serializes the ImportIT worksheet into an .xlsx ArrayBuffer. */
export function buildImportItWorkbook(
  sheet: ExcelSheet,
  mappings: readonly DataImportFieldMapping[],
  settings: DataImportItSettings,
  databaseRef: string,
): ArrayBuffer {
  const rows = buildImportItRows(sheet, mappings, settings, databaseRef);
  const worksheet = XLSX.utils.aoa_to_sheet(rows);
  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, 'Tabelle1');
  return XLSX.write(workbook, { type: 'array', bookType: 'xlsx' }) as ArrayBuffer;
}

/** Triggers a browser download for a generated ImportIT workbook. */
export function downloadImportItWorkbook(buffer: ArrayBuffer, fileName: string): void {
  const blob = new Blob([buffer], {
    type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement('a');
  anchor.href = url;
  anchor.download = fileName.endsWith('.xlsx') ? fileName : `${fileName}.xlsx`;
  anchor.click();
  URL.revokeObjectURL(url);
}
