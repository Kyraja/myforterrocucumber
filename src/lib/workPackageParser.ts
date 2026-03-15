import * as XLSX from 'xlsx';
import type { WorkPackage } from '../types/gherkin';

type WpField = keyof Omit<WorkPackage, 'id'>;

/** Maps normalized column headers to WorkPackage fields */
const COLUMN_MAP: Record<string, WpField> = {
  'ueberschrift': 'title',
  'überschrift': 'title',
  'titel': 'title',
  'title': 'title',
  'beschreibung': 'description',
  'description': 'description',
  'anforderung': 'description',
  'umsetzungszeit': 'implementationTime',
  'umsetzung': 'implementationTime',
  'implementation time': 'implementationTime',
  'qs-zeit': 'qaTime',
  'qs zeit': 'qaTime',
  'qa time': 'qaTime',
  'qualitätssicherung': 'qaTime',
  'qualitaetssicherung': 'qaTime',
  'prioritaet': 'priority',
  'priorität': 'priority',
  'priority': 'priority',
  'prio': 'priority',
  'bereich': 'area',
  'area': 'area',
  'section': 'area',
  'modul': 'area',
};

export function parseWorkPackageXlsx(buffer: ArrayBuffer): WorkPackage[] {
  const workbook = XLSX.read(buffer, { type: 'array' });
  const sheet = workbook.Sheets[workbook.SheetNames[0]];
  if (!sheet) return [];

  const rows = XLSX.utils.sheet_to_json<Record<string, string | number>>(sheet);
  const packages: WorkPackage[] = [];

  for (const row of rows) {
    const mapped: Partial<Omit<WorkPackage, 'id'>> = {};

    for (const [key, value] of Object.entries(row)) {
      const normalized = key.toLowerCase().trim();
      const field = COLUMN_MAP[normalized];
      if (field) {
        mapped[field] = String(value ?? '').trim();
      }
    }

    // Skip rows without title AND description
    if (!mapped.title && !mapped.description) continue;

    packages.push({
      id: crypto.randomUUID(),
      title: mapped.title ?? '',
      description: mapped.description ?? '',
      implementationTime: mapped.implementationTime ?? '',
      qaTime: mapped.qaTime ?? '',
      priority: mapped.priority ?? '',
      area: mapped.area ?? '',
    });
  }

  return packages;
}
