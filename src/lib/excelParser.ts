/**
 * @module excelParser
 * Generic Excel/CSV parsing for the data-import feature — unlike
 * `csvTableParser.ts` (which parses abas variable-table exports into
 * `TableDef[]`), this handles arbitrary customer spreadsheets with unknown
 * columns (master/transactional data to be mapped onto abas databases).
 */
import * as XLSX from 'xlsx';

export interface ExcelSheet {
  name: string;
  columns: string[];
  rows: Record<string, string | number | boolean | null>[];
}

function isCsvFile(file: File): boolean {
  return /\.csv$/i.test(file.name) || file.type === 'text/csv';
}

/** Parses an uploaded .xlsx/.xls/.csv file into one entry per sheet. */
export async function parseExcelFile(file: File): Promise<ExcelSheet[]> {
  const buffer = await file.arrayBuffer();
  const workbook = isCsvFile(file)
    ? XLSX.read(new TextDecoder('utf-8').decode(buffer), { type: 'string' })
    : XLSX.read(buffer, { type: 'array' });

  return workbook.SheetNames.map((name) => {
    const sheet = workbook.Sheets[name];
    const rows = XLSX.utils.sheet_to_json<Record<string, string | number | boolean | null>>(sheet, { defval: '' });
    const headerRow = XLSX.utils.sheet_to_json<string[]>(sheet, { header: 1 })[0] as string[] | undefined;
    const columns = rows.length > 0 ? Object.keys(rows[0]) : (headerRow ?? []);
    return { name, columns, rows };
  });
}

/** Re-serializes sheets (e.g. after an AI transformation) back into an .xlsx ArrayBuffer. */
export function buildWorkbookFromSheets(sheets: ExcelSheet[]): ArrayBuffer {
  const workbook = XLSX.utils.book_new();
  for (const sheet of sheets) {
    const worksheet = XLSX.utils.json_to_sheet(sheet.rows, { header: sheet.columns });
    XLSX.utils.book_append_sheet(workbook, worksheet, sheet.name.slice(0, 31) || 'Sheet1');
  }
  return XLSX.write(workbook, { type: 'array', bookType: 'xlsx' }) as ArrayBuffer;
}

/** Splits rows into batches so large sheets can be sent to the AI in chunks. */
export function chunkRows<T>(rows: T[], batchSize = 300): T[][] {
  if (rows.length === 0) return [[]];
  const batches: T[][] = [];
  for (let i = 0; i < rows.length; i += batchSize) batches.push(rows.slice(i, i + batchSize));
  return batches;
}
