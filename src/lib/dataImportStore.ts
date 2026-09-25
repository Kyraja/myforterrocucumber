/**
 * @module dataImportStore
 * Workspace persistence for the Excel/CSV data-import feature.
 *
 * Layout inside the workspace:
 *   .cucumbergnerator-settings/DataImports/imports.json         (manifest)
 *   .cucumbergnerator-settings/DataImports/{id}/v{n}/original.xlsx
 *   .cucumbergnerator-settings/DataImports/{id}/v{n}/transformed.xlsx  (optional)
 *   .cucumbergnerator-settings/DataImports/{id}/v{n}/mapping.json      (optional)
 *
 * Versioning is intentionally minimal: only the CURRENT version and at most
 * ONE backup are kept on disk. `current`/`backup` in the manifest are just
 * pointers to existing v{n} folders — restoring a backup swaps the pointers
 * (no file I/O), and a new update deletes the old backup folder before the
 * previous current becomes the new backup.
 */
import type { DataImportManifest, DataImportRecord, DataImportVersionMeta, DataImportMappingResult } from '../types/dataImport';
import { parseExcelFile, buildWorkbookFromSheets, type ExcelSheet } from './excelParser';

const SETTINGS_DIR = '.cucumbergnerator-settings';
const ROOT_DIR = 'DataImports';
const MANIFEST_FILE = 'imports.json';
const MANIFEST_VERSION = 1;
const ORIGINAL_FILE = 'original.xlsx';
const TRANSFORMED_FILE = 'transformed.xlsx';
const MAPPING_FILE = 'mapping.json';

function normalizeMapping(mapping: Partial<DataImportMappingResult>): DataImportMappingResult {
  const database = mapping.database
    ? { ...mapping.database, confidencePercent: mapping.database.confidencePercent ?? null }
    : null;
  return {
    mode: mapping.mode ?? 'ai',
    database,
    databaseCandidates: (mapping.databaseCandidates ?? (database ? [database] : [])).map((candidate) => ({
      ...candidate,
      confidencePercent: candidate.confidencePercent ?? null,
    })),
    fieldMapping: (mapping.fieldMapping ?? []).map((fieldMapping) => ({
      ...fieldMapping,
      source: fieldMapping.source ?? (fieldMapping.confidence ? 'ai' : 'manual'),
      aiField: fieldMapping.aiField ?? (fieldMapping.source === 'ai' ? fieldMapping.field : null),
      aiConfidence: fieldMapping.aiConfidence ?? (fieldMapping.source === 'ai' ? fieldMapping.confidence : null),
      aiConfidencePercent: fieldMapping.aiConfidencePercent ?? (fieldMapping.source === 'ai' ? fieldMapping.confidencePercent : null),
      aiAlternativeField: fieldMapping.aiAlternativeField ?? fieldMapping.alternativeField ?? null,
      confidence: fieldMapping.confidence ?? null,
      confidencePercent: fieldMapping.confidencePercent ?? null,
      fieldDataType: fieldMapping.fieldDataType ?? null,
    })),
    unmapped: mapping.unmapped ?? [],
    relationships: mapping.relationships ?? [],
    testData: mapping.testData ?? [],
    warnings: mapping.warnings ?? [],
  };
}

async function getRootDir(rootHandle: FileSystemDirectoryHandle, create: boolean): Promise<FileSystemDirectoryHandle> {
  const settings = await rootHandle.getDirectoryHandle(SETTINGS_DIR, { create });
  return settings.getDirectoryHandle(ROOT_DIR, { create });
}

export async function readManifest(rootHandle: FileSystemDirectoryHandle): Promise<DataImportManifest> {
  try {
    const dir = await getRootDir(rootHandle, false);
    const handle = await dir.getFileHandle(MANIFEST_FILE);
    const parsed = JSON.parse(await (await handle.getFile()).text()) as Partial<DataImportManifest>;
    if (Array.isArray(parsed.imports)) return { version: MANIFEST_VERSION, imports: parsed.imports as DataImportRecord[] };
  } catch {
    // No manifest yet — expected on first use.
  }
  return { version: MANIFEST_VERSION, imports: [] };
}

async function writeManifest(rootHandle: FileSystemDirectoryHandle, manifest: DataImportManifest): Promise<void> {
  const dir = await getRootDir(rootHandle, true);
  const handle = await dir.getFileHandle(MANIFEST_FILE, { create: true });
  const writable = await handle.createWritable();
  await writable.write(JSON.stringify(manifest, null, 2));
  await writable.close();
}

async function getVersionDir(
  rootHandle: FileSystemDirectoryHandle,
  importId: string,
  version: number,
  create: boolean,
): Promise<FileSystemDirectoryHandle> {
  const root = await getRootDir(rootHandle, create);
  const importDir = await root.getDirectoryHandle(importId, { create });
  return importDir.getDirectoryHandle(`v${version}`, { create });
}

async function deleteVersionDir(rootHandle: FileSystemDirectoryHandle, importId: string, version: number): Promise<void> {
  try {
    const root = await getRootDir(rootHandle, false);
    const importDir = await root.getDirectoryHandle(importId);
    await importDir.removeEntry(`v${version}`, { recursive: true });
  } catch {
    // Already gone — fine.
  }
}

async function writeFileInDir(dir: FileSystemDirectoryHandle, name: string, data: ArrayBuffer | string): Promise<void> {
  const handle = await dir.getFileHandle(name, { create: true });
  const writable = await handle.createWritable();
  await writable.write(data);
  await writable.close();
}

async function readFileInDir(dir: FileSystemDirectoryHandle, name: string): Promise<File | null> {
  try {
    const handle = await dir.getFileHandle(name);
    return await handle.getFile();
  } catch {
    return null;
  }
}

function buildSchemaFromSheets(sheets: ExcelSheet[]): { columns: string[]; rowCount: number } {
  const first = sheets[0];
  return { columns: first?.columns ?? [], rowCount: first?.rows.length ?? 0 };
}

/** Imports a new spreadsheet as v1 of a brand-new record. */
export async function createDataImport(
  rootHandle: FileSystemDirectoryHandle,
  file: File,
  name: string,
): Promise<{ record: DataImportRecord; sheets: ExcelSheet[] }> {
  const sheets = await parseExcelFile(file);
  const id = crypto.randomUUID();
  const version = 1;
  const dir = await getVersionDir(rootHandle, id, version, true);
  await writeFileInDir(dir, ORIGINAL_FILE, await file.arrayBuffer());

  const meta: DataImportVersionMeta = {
    version,
    createdAt: new Date().toISOString(),
    fileName: file.name,
    schema: buildSchemaFromSheets(sheets),
    hasTransformed: false,
    hasMapping: false,
  };
  const record: DataImportRecord = {
    id,
    name: name.trim() || file.name,
    createdAt: meta.createdAt,
    updatedAt: meta.createdAt,
    current: meta,
  };

  const manifest = await readManifest(rootHandle);
  manifest.imports = [record, ...manifest.imports];
  await writeManifest(rootHandle, manifest);
  return { record, sheets };
}

/** Replaces the original file of an existing import with a new upload (creates a new version). */
export async function updateDataImportOriginal(
  rootHandle: FileSystemDirectoryHandle,
  importId: string,
  file: File,
): Promise<{ record: DataImportRecord; sheets: ExcelSheet[] }> {
  const manifest = await readManifest(rootHandle);
  const existing = manifest.imports.find((entry) => entry.id === importId);
  if (!existing) throw new Error(`Data import ${importId} not found`);

  if (existing.backup) await deleteVersionDir(rootHandle, importId, existing.backup.version);
  const newVersion = existing.current.version + 1;
  const sheets = await parseExcelFile(file);
  const dir = await getVersionDir(rootHandle, importId, newVersion, true);
  await writeFileInDir(dir, ORIGINAL_FILE, await file.arrayBuffer());

  const meta: DataImportVersionMeta = {
    version: newVersion,
    createdAt: new Date().toISOString(),
    fileName: file.name,
    schema: buildSchemaFromSheets(sheets),
    hasTransformed: false,
    hasMapping: false,
  };
  existing.backup = existing.current;
  existing.current = meta;
  existing.updatedAt = meta.createdAt;
  await writeManifest(rootHandle, manifest);
  return { record: existing, sheets };
}

/** Swaps current ↔ backup — instant, since both versions already exist on disk. */
export async function restoreDataImportBackup(
  rootHandle: FileSystemDirectoryHandle,
  importId: string,
): Promise<DataImportRecord> {
  const manifest = await readManifest(rootHandle);
  const existing = manifest.imports.find((entry) => entry.id === importId);
  if (!existing || !existing.backup) throw new Error('No backup available to restore');
  [existing.current, existing.backup] = [existing.backup, existing.current];
  existing.updatedAt = new Date().toISOString();
  await writeManifest(rootHandle, manifest);
  return existing;
}

export async function deleteDataImport(rootHandle: FileSystemDirectoryHandle, importId: string): Promise<void> {
  const manifest = await readManifest(rootHandle);
  const existing = manifest.imports.find((entry) => entry.id === importId);
  if (existing) {
    await deleteVersionDir(rootHandle, importId, existing.current.version);
    if (existing.backup) await deleteVersionDir(rootHandle, importId, existing.backup.version);
  }
  manifest.imports = manifest.imports.filter((entry) => entry.id !== importId);
  await writeManifest(rootHandle, manifest);
}

export async function readOriginalSheets(
  rootHandle: FileSystemDirectoryHandle,
  importId: string,
  version: number,
): Promise<ExcelSheet[]> {
  const dir = await getVersionDir(rootHandle, importId, version, false);
  const file = await readFileInDir(dir, ORIGINAL_FILE);
  if (!file) return [];
  return parseExcelFile(file);
}

export async function readTransformedSheets(
  rootHandle: FileSystemDirectoryHandle,
  importId: string,
  version: number,
): Promise<ExcelSheet[] | null> {
  const dir = await getVersionDir(rootHandle, importId, version, false);
  const file = await readFileInDir(dir, TRANSFORMED_FILE);
  if (!file) return null;
  return parseExcelFile(file);
}

/** Persists an (AI- or manually) transformed sheet set for a version, and records the instruction used. */
export async function saveTransformedSheets(
  rootHandle: FileSystemDirectoryHandle,
  importId: string,
  version: number,
  sheets: ExcelSheet[],
  instruction: string,
): Promise<void> {
  const dir = await getVersionDir(rootHandle, importId, version, true);
  await writeFileInDir(dir, TRANSFORMED_FILE, buildWorkbookFromSheets(sheets));

  const manifest = await readManifest(rootHandle);
  const existing = manifest.imports.find((entry) => entry.id === importId);
  if (existing) {
    const meta = existing.current.version === version ? existing.current : existing.backup;
    if (meta) {
      meta.hasTransformed = true;
      meta.transformInstruction = instruction;
      meta.schema = buildSchemaFromSheets(sheets);
    }
    existing.updatedAt = new Date().toISOString();
    await writeManifest(rootHandle, manifest);
  }
}

export async function readMapping(
  rootHandle: FileSystemDirectoryHandle,
  importId: string,
  version: number,
  sheetName: string,
): Promise<DataImportMappingResult | null> {
  const dir = await getVersionDir(rootHandle, importId, version, false);
  const file = await readFileInDir(dir, MAPPING_FILE);
  if (!file) return null;
  try {
    const stored = JSON.parse(await file.text()) as { sheets?: Record<string, Partial<DataImportMappingResult>> };
    const mapping = stored.sheets?.[sheetName];
    return mapping ? normalizeMapping(mapping) : null;
  } catch {
    return null;
  }
}

export async function saveMapping(
  rootHandle: FileSystemDirectoryHandle,
  importId: string,
  version: number,
  sheetName: string,
  mapping: DataImportMappingResult,
): Promise<void> {
  const dir = await getVersionDir(rootHandle, importId, version, true);
  const existingFile = await readFileInDir(dir, MAPPING_FILE);
  let sheets: Record<string, DataImportMappingResult> = {};
  if (existingFile) {
    try {
      const stored = JSON.parse(await existingFile.text()) as { sheets?: Record<string, DataImportMappingResult> };
      sheets = stored.sheets ?? {};
    } catch {
      // Replace unreadable or legacy mapping data with the current sheet's mapping.
    }
  }
  sheets[sheetName] = mapping;
  await writeFileInDir(dir, MAPPING_FILE, JSON.stringify({ version: 2, sheets }, null, 2));

  const manifest = await readManifest(rootHandle);
  const existing = manifest.imports.find((entry) => entry.id === importId);
  if (existing) {
    const meta = existing.current.version === version ? existing.current : existing.backup;
    if (meta) meta.hasMapping = true;
    existing.updatedAt = new Date().toISOString();
    await writeManifest(rootHandle, manifest);
  }
}
