import type { MessageAttachment, MftFileInfo } from './myforterroApi';

const SETTINGS_DIR = '.cucumbergnerator-settings';
const UPLOAD_DIR = 'Uploaded';
const MANIFEST_FILE = 'uploaded-files.json';
const MANIFEST_VERSION = 1;
const TEXT_CHUNK_SIZE = 4_000_000;

interface UploadedFileRecord {
  sha256: string;
  fileName: string;
  workspacePath: string;
  size: number;
  lastModified: number;
  tenantId: string;
  uploadedAt: string;
  attachments: MessageAttachment[];
}

interface UploadedFilesManifest {
  version: number;
  files: UploadedFileRecord[];
}

function isTextFile(file: File): boolean {
  return /\.(txt|md|csv|json|xml|html?|feature|java|ts|tsx|js|jsx|log|yaml|yml|sql)$/i.test(file.name)
    || file.type.startsWith('text/');
}

function baseName(fileName: string): { stem: string; extension: string } {
  const dot = fileName.lastIndexOf('.');
  return dot > 0
    ? { stem: fileName.slice(0, dot), extension: fileName.slice(dot) }
    : { stem: fileName, extension: '' };
}

async function sha256(file: File): Promise<string> {
  const digest = await crypto.subtle.digest('SHA-256', await file.arrayBuffer());
  return Array.from(new Uint8Array(digest), (byte) => byte.toString(16).padStart(2, '0')).join('');
}

async function readManifest(rootHandle: FileSystemDirectoryHandle): Promise<UploadedFilesManifest> {
  try {
    const settings = await rootHandle.getDirectoryHandle(SETTINGS_DIR);
    const handle = await settings.getFileHandle(MANIFEST_FILE);
    const parsed = JSON.parse(await (await handle.getFile()).text()) as Partial<UploadedFilesManifest>;
    if (Array.isArray(parsed.files)) return { version: MANIFEST_VERSION, files: parsed.files as UploadedFileRecord[] };
  } catch {
    // A workspace without a manifest is expected on first use.
  }
  return { version: MANIFEST_VERSION, files: [] };
}

async function writeManifest(rootHandle: FileSystemDirectoryHandle, manifest: UploadedFilesManifest): Promise<void> {
  const settings = await rootHandle.getDirectoryHandle(SETTINGS_DIR, { create: true });
  const handle = await settings.getFileHandle(MANIFEST_FILE, { create: true });
  const writable = await handle.createWritable();
  await writable.write(JSON.stringify(manifest, null, 2));
  await writable.close();
}

async function writeWorkspaceCopy(
  rootHandle: FileSystemDirectoryHandle,
  file: File,
  hash: string,
): Promise<string> {
  const uploadDir = await rootHandle.getDirectoryHandle(UPLOAD_DIR, { create: true });
  const { stem, extension } = baseName(file.name);
  let name = file.name;

  try {
    const existing = await uploadDir.getFileHandle(name);
    const existingFile = await existing.getFile();
    if (existingFile.size !== file.size || await sha256(existingFile) !== hash) {
      name = `${stem}-${hash.slice(0, 8)}${extension}`;
    }
  } catch {
    // The target name is available.
  }

  const target = await uploadDir.getFileHandle(name, { create: true });
  const writable = await target.createWritable();
  await writable.write(file);
  await writable.close();
  return `${UPLOAD_DIR}/${name}`;
}

function chunkFile(file: File): File[] {
  const chunks: File[] = [];
  for (let offset = 0, index = 1; offset < file.size; offset += TEXT_CHUNK_SIZE, index++) {
    chunks.push(new File(
      [file.slice(offset, Math.min(offset + TEXT_CHUNK_SIZE, file.size), file.type)],
      `${file.name}.part-${String(index).padStart(3, '0')}`,
      { type: file.type },
    ));
  }
  return chunks;
}

export interface WorkspaceUploadOptions {
  rootHandle?: FileSystemDirectoryHandle | null;
  tenantId: string;
  upload: (file: File) => Promise<MftFileInfo>;
}

/** Uploads a source file once per workspace/tenant and returns reusable API references. */
export async function ensureWorkspaceFileUpload(
  file: File,
  options: WorkspaceUploadOptions,
): Promise<MessageAttachment[]> {
  const hash = await sha256(file);
  const manifest = options.rootHandle ? await readManifest(options.rootHandle) : { version: MANIFEST_VERSION, files: [] };
  const cached = manifest.files.find((entry) =>
    entry.sha256 === hash && entry.size === file.size && entry.tenantId === options.tenantId,
  );
  if (cached) return cached.attachments;

  const workspacePath = options.rootHandle
    ? await writeWorkspaceCopy(options.rootHandle, file, hash)
    : file.name;
  let attachments: MessageAttachment[];

  try {
    const uploaded = await options.upload(file);
    attachments = [{ fileId: uploaded.fileId, fileName: uploaded.fileName ?? file.name }];
  } catch (error) {
    const status = error instanceof Error && 'status' in error ? (error as Error & { status?: number }).status : undefined;
    if (status !== 413 || !isTextFile(file)) throw error;
    attachments = [];
    for (const chunk of chunkFile(file)) {
      const uploaded = await options.upload(chunk);
      attachments.push({ fileId: uploaded.fileId, fileName: uploaded.fileName ?? chunk.name });
    }
  }

  const record: UploadedFileRecord = {
    sha256: hash,
    fileName: file.name,
    workspacePath,
    size: file.size,
    lastModified: file.lastModified,
    tenantId: options.tenantId,
    uploadedAt: new Date().toISOString(),
    attachments,
  };
  manifest.files = [...manifest.files.filter((entry) => !(entry.sha256 === hash && entry.tenantId === options.tenantId)), record];
  if (options.rootHandle) await writeManifest(options.rootHandle, manifest);
  return attachments;
}

export async function loadUploadedFiles(rootHandle: FileSystemDirectoryHandle): Promise<ReadonlyArray<UploadedFileRecord>> {
  return (await readManifest(rootHandle)).files;
}
