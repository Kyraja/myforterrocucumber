import type { FeatureInput } from '../types/gherkin';
import type { FileTreeNode } from '../types/fileExplorer';
import { parseGherkin } from './gherkinParser';
import { generateGherkin } from './generator';
import { openDb, IDB_FILE_HANDLES_STORE } from './idb';

const IDB_HANDLE_KEY = 'rootDirectoryHandle';

/** Check if the File System Access API is available (Chrome/Edge only) */
export function isFileSystemAccessSupported(): boolean {
  return 'showDirectoryPicker' in window;
}

/** Open a directory picker dialog */
export async function pickDirectory(): Promise<FileSystemDirectoryHandle> {
  return window.showDirectoryPicker({ mode: 'readwrite' });
}

/** Verify read/write permission on a handle, requesting if needed */
export async function verifyPermission(
  handle: FileSystemDirectoryHandle,
): Promise<boolean> {
  const opts = { mode: 'readwrite' as const };
  if ((await handle.queryPermission(opts)) === 'granted') return true;
  if ((await handle.requestPermission(opts)) === 'granted') return true;
  return false;
}

/** Save the directory handle to IndexedDB for session persistence */
export async function saveDirectoryHandle(
  handle: FileSystemDirectoryHandle,
): Promise<void> {
  const db = await openDb();
  return new Promise((resolve, reject) => {
    const tx = db.transaction(IDB_FILE_HANDLES_STORE, 'readwrite');
    tx.objectStore(IDB_FILE_HANDLES_STORE).put(handle, IDB_HANDLE_KEY);
    tx.oncomplete = () => { db.close(); resolve(); };
    tx.onerror = () => { db.close(); reject(tx.error); };
  });
}

/** Load a previously saved directory handle from IndexedDB */
export async function loadDirectoryHandle(): Promise<FileSystemDirectoryHandle | null> {
  try {
    const db = await openDb();
    return new Promise((resolve) => {
      const tx = db.transaction(IDB_FILE_HANDLES_STORE, 'readonly');
      const req = tx.objectStore(IDB_FILE_HANDLES_STORE).get(IDB_HANDLE_KEY);
      req.onsuccess = () => { db.close(); resolve(req.result ?? null); };
      req.onerror = () => { db.close(); resolve(null); };
    });
  } catch {
    return null;
  }
}

/** Clear the saved directory handle from IndexedDB */
export async function clearDirectoryHandle(): Promise<void> {
  try {
    const db = await openDb();
    const tx = db.transaction(IDB_FILE_HANDLES_STORE, 'readwrite');
    tx.objectStore(IDB_FILE_HANDLES_STORE).delete(IDB_HANDLE_KEY);
    tx.oncomplete = () => db.close();
  } catch {
    // ignore
  }
}

/** Read a .feature file and parse it into FeatureInput */
export async function readFeatureFile(
  fileHandle: FileSystemFileHandle,
): Promise<FeatureInput> {
  const file = await fileHandle.getFile();
  const text = await file.text();
  return parseGherkin(text);
}

/** Write a FeatureInput to a .feature file */
export async function writeFeatureFile(
  fileHandle: FileSystemFileHandle,
  feature: FeatureInput,
): Promise<void> {
  const text = generateGherkin(feature);
  const writable = await fileHandle.createWritable();
  await writable.write(text);
  await writable.close();
}

/** Create a new subfolder */
export async function createFolder(
  parentHandle: FileSystemDirectoryHandle,
  name: string,
): Promise<FileSystemDirectoryHandle> {
  return parentHandle.getDirectoryHandle(name, { create: true });
}

/** Delete a folder recursively */
export async function deleteFolder(
  parentHandle: FileSystemDirectoryHandle,
  name: string,
): Promise<void> {
  await parentHandle.removeEntry(name, { recursive: true });
}

/** Create a new .feature file with empty template */
export async function createFeatureFile(
  parentHandle: FileSystemDirectoryHandle,
  name: string,
): Promise<FileSystemFileHandle> {
  const filename = name.endsWith('.feature') ? name : `${name}.feature`;
  const fileHandle = await parentHandle.getFileHandle(filename, { create: true });
  const writable = await fileHandle.createWritable();
  const featureName = name.replace(/\.feature$/, '');
  await writable.write(`Feature: ${featureName}\n`);
  await writable.close();
  return fileHandle;
}

/** Delete a file */
export async function deleteFile(
  parentHandle: FileSystemDirectoryHandle,
  name: string,
): Promise<void> {
  await parentHandle.removeEntry(name);
}

/** Move a file from one directory to another (read-write-delete, no native move) */
export async function moveFile(
  sourceParentHandle: FileSystemDirectoryHandle,
  targetParentHandle: FileSystemDirectoryHandle,
  fileName: string,
): Promise<FileSystemFileHandle> {
  // Read source
  const sourceFileHandle = await sourceParentHandle.getFileHandle(fileName);
  const file = await sourceFileHandle.getFile();
  const content = await file.text();

  // Write to target
  const targetFileHandle = await targetParentHandle.getFileHandle(fileName, { create: true });
  const writable = await targetFileHandle.createWritable();
  await writable.write(content);
  await writable.close();

  // Delete original
  await sourceParentHandle.removeEntry(fileName);

  return targetFileHandle;
}

/** Move a directory from one parent to another (copy contents recursively, then delete original) */
export async function moveDirectory(
  sourceParentHandle: FileSystemDirectoryHandle,
  targetParentHandle: FileSystemDirectoryHandle,
  dirName: string,
): Promise<void> {
  const sourceDir = await sourceParentHandle.getDirectoryHandle(dirName);
  const targetDir = await targetParentHandle.getDirectoryHandle(dirName, { create: true });
  await copyDirectoryContents(sourceDir, targetDir);
  await sourceParentHandle.removeEntry(dirName, { recursive: true });
}

/** Rename a file or folder */
export async function renameEntry(
  parentHandle: FileSystemDirectoryHandle,
  oldName: string,
  newName: string,
  isDirectory: boolean,
): Promise<void> {
  if (isDirectory) {
    // For directories: create new, copy contents recursively, delete old
    const oldDir = await parentHandle.getDirectoryHandle(oldName);
    const newDir = await parentHandle.getDirectoryHandle(newName, { create: true });
    await copyDirectoryContents(oldDir, newDir);
    await parentHandle.removeEntry(oldName, { recursive: true });
  } else {
    // For files: read, create new, write, delete old
    const oldFile = await parentHandle.getFileHandle(oldName);
    const file = await oldFile.getFile();
    const content = await file.text();
    const targetName = newName.endsWith('.feature') ? newName : `${newName}.feature`;
    const newFile = await parentHandle.getFileHandle(targetName, { create: true });
    const writable = await newFile.createWritable();
    await writable.write(content);
    await writable.close();
    await parentHandle.removeEntry(oldName);
  }
}

async function copyDirectoryContents(
  source: FileSystemDirectoryHandle,
  target: FileSystemDirectoryHandle,
): Promise<void> {
  for await (const [name, handle] of source.entries()) {
    if (handle.kind === 'file') {
      const file = await (handle as FileSystemFileHandle).getFile();
      const content = await file.arrayBuffer();
      const newFile = await target.getFileHandle(name, { create: true });
      const writable = await newFile.createWritable();
      await writable.write(content);
      await writable.close();
    } else {
      const subSource = await source.getDirectoryHandle(name);
      const subTarget = await target.getDirectoryHandle(name, { create: true });
      await copyDirectoryContents(subSource, subTarget);
    }
  }
}

/**
 * Recursively read a directory into a FileTreeNode tree.
 * Only includes .feature files and subdirectories.
 */
export async function readDirectoryTree(
  dirHandle: FileSystemDirectoryHandle,
  parentPath: string,
): Promise<FileTreeNode[]> {
  const folders: FileTreeNode[] = [];
  const files: FileTreeNode[] = [];

  for await (const [name, handle] of dirHandle.entries()) {
    if (handle.kind === 'directory') {
      const path = parentPath ? `${parentPath}/${name}` : name;
      const subDirHandle = await dirHandle.getDirectoryHandle(name);
      const children = await readDirectoryTree(subDirHandle, path);
      // Show all folders (including empty ones, so users can add files to them)
      folders.push({
        path,
        displayName: name,
        type: 'folder',
        children,
        expanded: false,
        dirHandle: subDirHandle,
      });
    } else if (name.endsWith('.feature')) {
      const path = parentPath ? `${parentPath}/${name}` : name;
      const fileHandle = await dirHandle.getFileHandle(name);
      let featureInput: FeatureInput;
      let displayName: string;
      let scenarioChildren: FileTreeNode[] = [];

      try {
        featureInput = await readFeatureFile(fileHandle);
        displayName = featureInput.name || name.replace(/\.feature$/, '');
        scenarioChildren = featureInput.scenarios.map((s) => ({
          path: `${path}#${s.id}`,
          displayName: s.name || '(unnamed scenario)',
          type: 'scenario' as const,
          children: [],
          expanded: false,
          scenarioId: s.id,
        }));
      } catch {
        // Corrupted file - show with filename as fallback
        featureInput = { name: name.replace(/\.feature$/, ''), description: '', tags: [], database: null, testUser: '', scenarios: [] };
        displayName = name.replace(/\.feature$/, '');
      }

      files.push({
        path,
        displayName,
        type: 'file',
        children: scenarioChildren,
        expanded: false,
        fileHandle,
        featureInput,
      });
    }
  }

  // Sort: folders first (alphabetical), then files (alphabetical)
  folders.sort((a, b) => a.displayName.localeCompare(b.displayName));
  files.sort((a, b) => a.displayName.localeCompare(b.displayName));
  return [...folders, ...files];
}


/**
 * Find the parent directory handle for a given path in the tree.
 * Returns the root handle if path has no parent (top-level item).
 */
export async function getParentHandle(
  rootHandle: FileSystemDirectoryHandle,
  path: string,
): Promise<FileSystemDirectoryHandle> {
  const parts = path.split('/');
  parts.pop(); // Remove the item itself
  let current = rootHandle;
  for (const part of parts) {
    current = await current.getDirectoryHandle(part);
  }
  return current;
}

/** Get the filename from a path */
export function getNameFromPath(path: string): string {
  return path.split('/').pop() || path;
}

/** Sanitize a string for use as a file/folder name */
export function sanitizeName(name: string): string {
  return name
    .replace(/[/\\:*?"<>|]/g, '')
    .replace(/\s+/g, ' ')
    .trim()
    .slice(0, 100) || 'Unnamed';
}
