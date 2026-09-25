/**
 * @module useFileExplorer
 * Hook that manages a File System Access API directory session for the project explorer.
 *
 * Responsibilities:
 * - Open / close a root directory handle and persist it across page reloads via IndexedDB.
 * - Read and maintain a reactive file tree, preserving folder-expansion state across refreshes.
 * - Auto-save the active `.feature` file with a 1.5 s debounce (flush on file switch or unmount).
 * - Create, delete, rename, and move files and folders.
 * - Import parsed DOCX packages into a structured folder hierarchy, deduplicating by GUID tag.
 *
 * Falls back gracefully when the File System Access API is unavailable (e.g. Firefox).
 */

import { useState, useCallback, useRef, useEffect } from 'react';
import type { FeatureInput, ParsedFeaturePackage, TocEntry } from '../types/gherkin';
import type { FileTreeNode } from '../types/fileExplorer';
import { generateGherkin } from '../lib/generator';
import { makeFeatureGuid } from '../lib/featureGuid';
import { parseGherkin } from '../lib/gherkinParser';
import {
  isFileSystemAccessSupported,
  pickDirectory,
  verifyPermission,
  saveDirectoryHandle,
  loadDirectoryHandle,
  clearDirectoryHandle,
  readDirectoryTree,
  readFeatureFile,
  writeFeatureFile,
  createFolder as fsCreateFolder,
  deleteFolder as fsDeleteFolder,
  createFeatureFile as fsCreateFile,
  deleteFile as fsDeleteFile,
  duplicateFile as fsDuplicateFile,
  moveFile as fsMoveFile,
  moveDirectory as fsMoveDirectory,
  renameEntry as fsRenameEntry,
  getParentHandle,
  getNameFromPath,
  sanitizeName,
  loadRecentWorkspaces,
  saveRecentWorkspace,
  type RecentWorkspace,
} from '../lib/fileSystemAccess';

/** Complete return type of {@link useFileExplorer}. */
export interface UseFileExplorerReturn {
  // ── State ────────────────────────────────────────────────────

  /** Reactive snapshot of the directory tree. Folder expansion is restored on refresh. */
  tree: FileTreeNode[];
  /** Relative path of the file currently open in the editor, or `null`. */
  activeFilePath: string | null;
  /** Whether the sidebar panel is visible (persisted in localStorage). */
  isVisible: boolean;
  /** True while the tree is being read from disk. */
  isLoading: boolean;
  /** Last file-system error message, or `null`. */
  error: string | null;
  /** True when a root directory handle is open. False in standalone (no directory) mode. */
  isDirectoryMode: boolean;
  /** False when the File System Access API is not supported by the current browser. */
  isSupported: boolean;
  /** Display name of the open root folder, or `null` when no directory is open. */
  rootFolderName: string | null;
  /** The raw directory handle — exposed so consumers can pass it to other APIs (e.g. agent history). */
  rootHandle: FileSystemDirectoryHandle | null;
  /** Path currently highlighted as a drag-over target during drag-and-drop, or `null`. */
  dragOverPath: string | null;
  /** Recently used workspace handles for quick switching. */
  recentWorkspaces: RecentWorkspace[];

  // ── Actions ────────────────────────────────────────────

  /** Show the OS directory picker, then load the selected folder. */
  openDirectory: () => Promise<void>;
  /** Create a new workspace below a user-selected parent folder. */
  createWorkspace: (name: string) => Promise<void>;
  /** Switch to an already-known workspace handle (from recent workspaces list). */
  switchWorkspace: (handle: FileSystemDirectoryHandle) => Promise<void>;
  /** Release the current directory handle and return to standalone mode. */
  closeDirectory: () => void;
  /** Re-read the directory tree from disk, preserving expansion state. */
  refreshTree: () => Promise<void>;
  /** Toggle expanded/collapsed state of a folder node. */
  toggleNode: (path: string) => void;
  /** Expand a folder node (no-op if already expanded). */
  expandNode: (path: string) => void;
  /**
   * Open a `.feature` file by path, parse it, and set it as the active file.
   * Flushes any pending auto-save for the previously active file first.
   * @returns Parsed {@link FeatureInput}, or `null` on error.
   */
  selectFile: (path: string) => Promise<FeatureInput | null>;
  /**
   * Open the file that contains the given scenario (strips `#scenarioId` suffix).
   * @returns Same as {@link UseFileExplorerReturn.selectFile}.
   */
  selectScenario: (filePath: string, scenarioId: string) => Promise<FeatureInput | null>;
  /** Schedule a debounced auto-save (1.5 s) for the currently active file. */
  saveActiveFile: (feature: FeatureInput) => void;
  /** Write any pending debounced save immediately (called before switching files). */
  flushSave: () => Promise<void>;
  /** Create a folder under `parentPath`; the name is supplied by the caller. */
  createFolder: (parentPath: string, folderName?: string) => Promise<string | null>;
  /** Confirm and delete a folder by path. */
  deleteFolder: (path: string) => Promise<void>;
  /** Prompt the user for a file name and create a new `.feature` file under `parentPath`. */
  createFile: (parentPath: string) => Promise<string | null>;
  /** Create a `.feature` file with the given name without showing a prompt dialog. */
  createFileWithName: (parentPath: string, fileName: string) => Promise<string | null>;
  /** Confirm and delete a file by path. */
  deleteFile: (path: string) => Promise<void>;
  /** Duplicate a file in the same folder and select the duplicate. */
  duplicateFile: (path: string) => Promise<string | null>;
  /** Delete multiple files in one operation (no per-file confirm dialog). */
  deleteFiles: (paths: string[]) => Promise<void>;
  /** Move a file or folder from `sourcePath` into `targetFolderPath`. */
  moveEntry: (sourcePath: string, targetFolderPath: string) => Promise<void>;
  /** Rename a file or folder in-place. */
  renameEntry: (path: string, newName: string) => Promise<void>;
  /** Clear the active file selection (e.g. when the user clicks a folder). */
  deselectFile: () => void;
  /**
   * Import a set of parsed DOCX packages into the directory, optionally using
   * TOC hierarchy to create nested folders. Deduplicates by GUID tag — existing
   * files with a matching GUID are overwritten rather than duplicated.
   * @returns Path of the first written file (auto-opened in the editor), or `null`.
   */
  importPackages: (packages: ParsedFeaturePackage[], targetFolderPath: string, groupFolderName: string, tocInfo?: { toc: TocEntry[]; tocNumbers: string[] }) => Promise<string | null>;
  /** Toggle explorer panel visibility and persist the preference. */
  toggleExplorer: () => void;
  /** Set the path currently highlighted as a drag-over target. */
  setDragOverPath: (path: string | null) => void;
  /**
   * Update the in-memory tree node for `path` with the latest feature name
   * and scenario list (avoids a full disk refresh on every keystroke).
   */
  updateTreeForFeature: (path: string, feature: FeatureInput) => void;
}

/**
 * Hook for File System Access API directory management with auto-save.
 *
 * @returns {@link UseFileExplorerReturn}
 */
export function useFileExplorer(): UseFileExplorerReturn {
  const [rootHandle, setRootHandle] = useState<FileSystemDirectoryHandle | null>(null);
  const [recentWorkspaces, setRecentWorkspaces] = useState<RecentWorkspace[]>([]);
  const [tree, setTree] = useState<FileTreeNode[]>([]);
  const [activeFilePath, setActiveFilePath] = useState<string | null>(null);
  const [isVisible, setIsVisible] = useState(() => {
    const saved = localStorage.getItem('cucumbergnerator_explorer_visible');
    return saved !== 'false';
  });
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [dragOverPath, setDragOverPath] = useState<string | null>(null);

  const rootHandleRef = useRef(rootHandle);
  rootHandleRef.current = rootHandle;

  const activeFileHandleRef = useRef<FileSystemFileHandle | null>(null);
  const saveTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const pendingSaveRef = useRef<{ handle: FileSystemFileHandle; feature: FeatureInput } | null>(null);
  const expandedPathsRef = useRef<Set<string>>(new Set());

  const isSupported = isFileSystemAccessSupported();
  const isDirectoryMode = rootHandle !== null;
  const rootFolderName = rootHandle?.name ?? null;

  // Build tree preserving expansion state
  const buildTree = useCallback(async (handle: FileSystemDirectoryHandle): Promise<FileTreeNode[]> => {
    const newTree = await readDirectoryTree(handle, '');
    // Restore expansion state
    const restoreExpanded = (nodes: FileTreeNode[]): FileTreeNode[] =>
      nodes.map((n) => ({
        ...n,
        expanded: expandedPathsRef.current.has(n.path),
        children: restoreExpanded(n.children),
      }));
    return restoreExpanded(newTree);
  }, []);

  // Refresh the tree from disk
  const refreshTree = useCallback(async () => {
    if (!rootHandleRef.current) return;
    setIsLoading(true);
    setError(null);
    try {
      const newTree = await buildTree(rootHandleRef.current);
      setTree(newTree);
    } catch (err) {
      setError(`Failed to read directory: ${(err as Error).message}`);
    } finally {
      setIsLoading(false);
    }
  }, [buildTree]);

  // Try to restore saved handle on mount; also load recent workspaces
  useEffect(() => {
    if (!isSupported) return;
    void loadRecentWorkspaces().then(setRecentWorkspaces);
    let cancelled = false;
    (async () => {
      const savedHandle = await loadDirectoryHandle();
      if (!savedHandle || cancelled) return;
      const hasPermission = await verifyPermission(savedHandle);
      if (!hasPermission || cancelled) return;
      setRootHandle(savedHandle);
      rootHandleRef.current = savedHandle;
      setIsLoading(true);
      try {
        const newTree = await buildTree(savedHandle);
        if (!cancelled) setTree(newTree);
      } catch {
        // Permission may have been revoked
      } finally {
        if (!cancelled) setIsLoading(false);
      }
    })();
    return () => { cancelled = true; };
  }, [isSupported, buildTree]);

  // Open a directory picker
  const openDirectory = useCallback(async () => {
    try {
      const handle = await pickDirectory();
      setRootHandle(handle);
      rootHandleRef.current = handle;
      await saveDirectoryHandle(handle);
      const updated = await saveRecentWorkspace(handle);
      setRecentWorkspaces(updated);
      setIsLoading(true);
      setError(null);
      const newTree = await buildTree(handle);
      setTree(newTree);
      setActiveFilePath(null);
      activeFileHandleRef.current = null;
      setIsVisible(true);
      localStorage.setItem('cucumbergnerator_explorer_visible', 'true');
    } catch (err) {
      // User cancelled the picker - not an error
      if ((err as Error).name !== 'AbortError') {
        setError(`Failed to open directory: ${(err as Error).message}`);
      }
    } finally {
      setIsLoading(false);
    }
  }, [buildTree]);

  // Create a child workspace below a user-selected parent directory.
  const createWorkspace = useCallback(async (name: string) => {
    const normalizedName = name.trim();
    if (!normalizedName) return;
    try {
      const parentHandle = await pickDirectory();
      const handle = await parentHandle.getDirectoryHandle(normalizedName, { create: true });
      setRootHandle(handle);
      rootHandleRef.current = handle;
      await saveDirectoryHandle(handle);
      const updated = await saveRecentWorkspace(handle);
      setRecentWorkspaces(updated);
      setIsLoading(true);
      setError(null);
      setTree(await buildTree(handle));
      setActiveFilePath(null);
      activeFileHandleRef.current = null;
      setIsVisible(true);
      localStorage.setItem('cucumbergnerator_explorer_visible', 'true');
    } catch (err) {
      if ((err as Error).name !== 'AbortError') {
        setError(`Failed to create workspace: ${(err as Error).message}`);
      }
    } finally {
      setIsLoading(false);
    }
  }, [buildTree]);

  // Close the directory (return to standalone mode)
  const closeDirectory = useCallback(() => {
    setRootHandle(null);
    rootHandleRef.current = null;
    setTree([]);
    setActiveFilePath(null);
    activeFileHandleRef.current = null;
    clearDirectoryHandle();
  }, []);

  // Toggle a node's expanded state
  const toggleNode = useCallback((path: string) => {
    if (expandedPathsRef.current.has(path)) {
      expandedPathsRef.current.delete(path);
    } else {
      expandedPathsRef.current.add(path);
    }
    setTree((prev) => {
      const toggle = (nodes: FileTreeNode[]): FileTreeNode[] =>
        nodes.map((n) => {
          if (n.path === path) {
            return { ...n, expanded: !n.expanded, children: toggle(n.children) };
          }
          return { ...n, children: toggle(n.children) };
        });
      return toggle(prev);
    });
  }, []);

  // Expand a node (idempotent — does nothing if already expanded)
  const expandNode = useCallback((path: string) => {
    if (expandedPathsRef.current.has(path)) return;
    expandedPathsRef.current.add(path);
    setTree((prev) => {
      const expand = (nodes: FileTreeNode[]): FileTreeNode[] =>
        nodes.map((n) => {
          if (n.path === path) {
            return { ...n, expanded: true, children: expand(n.children) };
          }
          return { ...n, children: expand(n.children) };
        });
      return expand(prev);
    });
  }, []);

  // Flush any pending save immediately
  const flushSave = useCallback(async () => {
    if (saveTimerRef.current) {
      clearTimeout(saveTimerRef.current);
      saveTimerRef.current = null;
    }
    const pending = pendingSaveRef.current;
    if (!pending) return;
    pendingSaveRef.current = null;
    try {
      await writeFeatureFile(pending.handle, pending.feature);
    } catch (err) {
      console.warn('[FileExplorer] Auto-save failed:', err);
    }
  }, []);

  // Switch to an existing workspace handle (from recent workspaces list)
  const switchWorkspace = useCallback(async (handle: FileSystemDirectoryHandle) => {
    await flushSave();
    try {
      const hasPermission = await verifyPermission(handle);
      if (!hasPermission) return;
      setRootHandle(handle);
      rootHandleRef.current = handle;
      await saveDirectoryHandle(handle);
      const updated = await saveRecentWorkspace(handle);
      setRecentWorkspaces(updated);
      setIsLoading(true);
      setError(null);
      const newTree = await buildTree(handle);
      setTree(newTree);
      setActiveFilePath(null);
      activeFileHandleRef.current = null;
    } catch (err) {
      setError(`Failed to switch workspace: ${(err as Error).message}`);
    } finally {
      setIsLoading(false);
    }
  }, [buildTree, flushSave]);

  // Select (open) a file in the editor
  const selectFile = useCallback(async (path: string): Promise<FeatureInput | null> => {
    // Flush pending saves for the previously active file
    await flushSave();

    // Find the node in the tree
    const findNode = (nodes: FileTreeNode[]): FileTreeNode | null => {
      for (const n of nodes) {
        if (n.path === path && n.type === 'file') return n;
        const found = findNode(n.children);
        if (found) return found;
      }
      return null;
    };
    const node = findNode(tree);
    if (!node?.fileHandle) return null;

    try {
      const featureInput = await readFeatureFile(node.fileHandle);
      setActiveFilePath(path);
      activeFileHandleRef.current = node.fileHandle;
      return featureInput;
    } catch (err) {
      setError(`Failed to read file: ${(err as Error).message}`);
      return null;
    }
  }, [tree, flushSave]);

  // Select a scenario (opens the parent file, returns its FeatureInput)
  const selectScenario = useCallback(async (filePath: string, _scenarioId: string): Promise<FeatureInput | null> => {
    // Extract the actual file path (remove #scenarioId if present)
    const actualPath = filePath.includes('#') ? filePath.split('#')[0] : filePath;
    return selectFile(actualPath);
  }, [selectFile]);

  // Debounced save for auto-save
  const saveActiveFile = useCallback((feature: FeatureInput) => {
    if (!activeFileHandleRef.current) return;
    pendingSaveRef.current = { handle: activeFileHandleRef.current, feature };
    if (saveTimerRef.current) clearTimeout(saveTimerRef.current);
    saveTimerRef.current = setTimeout(async () => {
      saveTimerRef.current = null;
      const pending = pendingSaveRef.current;
      if (!pending) return;
      pendingSaveRef.current = null;
      try {
        await writeFeatureFile(pending.handle, pending.feature);
      } catch (err) {
        console.warn('[FileExplorer] Auto-save failed:', err);
      }
    }, 1500);
  }, []);

  // Update tree node titles when feature content changes
  const updateTreeForFeature = useCallback((path: string, feature: FeatureInput) => {
    setTree((prev) => {
      const update = (nodes: FileTreeNode[]): FileTreeNode[] =>
        nodes.map((n) => {
          if (n.path === path && n.type === 'file') {
            const scenarioChildren: FileTreeNode[] = feature.scenarios.map((s) => ({
              path: `${path}#${s.id}`,
              displayName: s.name || '(unnamed scenario)',
              type: 'scenario' as const,
              children: [],
              expanded: false,
              scenarioId: s.id,
            }));
            return {
              ...n,
              displayName: feature.name || n.displayName,
              featureInput: feature,
              children: scenarioChildren,
            };
          }
          return { ...n, children: update(n.children) };
        });
      return update(prev);
    });
  }, []);

  // Create a folder
  const createFolderAction = useCallback(async (parentPath: string, folderName?: string): Promise<string | null> => {
    if (!rootHandleRef.current) return null;
    const name = folderName?.trim();
    if (!name) return null;
    try {
      let parentHandle: FileSystemDirectoryHandle;
      if (parentPath) {
        // Navigate to the target folder
        parentHandle = rootHandleRef.current;
        for (const part of parentPath.split('/')) {
          parentHandle = await parentHandle.getDirectoryHandle(part);
        }
      } else {
        parentHandle = rootHandleRef.current;
      }
      await fsCreateFolder(parentHandle, name);
      // Expand parent folder so the new folder is visible
      if (parentPath) {
        expandedPathsRef.current.add(parentPath);
      }
      await refreshTree();
      return parentPath ? `${parentPath}/${name}` : name;
    } catch (err) {
      setError(`Failed to create folder: ${(err as Error).message}`);
      return null;
    }
  }, [refreshTree]);

  // Delete a folder
  const deleteFolderAction = useCallback(async (path: string, confirmed = false) => {
    if (!rootHandleRef.current) return;
    const name = getNameFromPath(path);
    if (!confirmed) return;
    try {
      const parentHandle = await getParentHandle(rootHandleRef.current, path);
      await fsDeleteFolder(parentHandle, name);
      await refreshTree();
    } catch (err) {
      setError(`Failed to delete folder: ${(err as Error).message}`);
    }
  }, [refreshTree]);

  // Create a file with a given name (no prompt dialog)
  const createFileWithName = useCallback(async (parentPath: string, fileName: string): Promise<string | null> => {
    if (!rootHandleRef.current || !fileName) return null;
    try {
      await flushSave();
      let parentHandle: FileSystemDirectoryHandle;
      if (parentPath) {
        parentHandle = rootHandleRef.current;
        for (const part of parentPath.split('/')) {
          parentHandle = await parentHandle.getDirectoryHandle(part);
        }
      } else {
        parentHandle = rootHandleRef.current;
      }
      const fileHandle = await fsCreateFile(parentHandle, fileName);
      const filename = fileName.endsWith('.feature') ? fileName : `${fileName}.feature`;
      const newPath = parentPath ? `${parentPath}/${filename}` : filename;
      if (parentPath) expandedPathsRef.current.add(parentPath);
      await refreshTree();
      setActiveFilePath(newPath);
      activeFileHandleRef.current = fileHandle;
      return newPath;
    } catch (err) {
      setError(`Failed to create file: ${(err as Error).message}`);
      return null;
    }
  }, [refreshTree, flushSave]);

  // Create a file (with prompt dialog)
  const createFileAction = useCallback(async (parentPath: string, fileName?: string): Promise<string | null> => {
    if (!rootHandleRef.current) return null;
    const name = fileName?.trim();
    if (!name) return null;
    try {
      // Flush any pending save before switching files
      await flushSave();

      let parentHandle: FileSystemDirectoryHandle;
      if (parentPath) {
        parentHandle = rootHandleRef.current;
        for (const part of parentPath.split('/')) {
          parentHandle = await parentHandle.getDirectoryHandle(part);
        }
      } else {
        parentHandle = rootHandleRef.current;
      }
      const fileHandle = await fsCreateFile(parentHandle, name);
      const filename = name.endsWith('.feature') ? name : `${name}.feature`;
      const newPath = parentPath ? `${parentPath}/${filename}` : filename;

      // Expand parent folder so the new file is visible
      if (parentPath) {
        expandedPathsRef.current.add(parentPath);
      }

      // Refresh tree to include the new file
      await refreshTree();

      // Set as active file directly (bypass selectFile's tree lookup since tree state may be stale)
      setActiveFilePath(newPath);
      activeFileHandleRef.current = fileHandle;

      return newPath;
    } catch (err) {
      setError(`Failed to create file: ${(err as Error).message}`);
      return null;
    }
  }, [refreshTree, flushSave]);

  // Delete a file
  const deleteFileAction = useCallback(async (path: string, confirmed = false) => {
    if (!rootHandleRef.current) return;
    const name = getNameFromPath(path);
    if (!confirmed) return;
    try {
      const parentHandle = await getParentHandle(rootHandleRef.current, path);
      await fsDeleteFile(parentHandle, name);
      if (activeFilePath === path) {
        setActiveFilePath(null);
        activeFileHandleRef.current = null;
      }
      await refreshTree();
    } catch (err) {
      setError(`Failed to delete file: ${(err as Error).message}`);
    }
  }, [refreshTree, activeFilePath]);

  // Duplicate a file in-place (same folder) and select the new copy
  const duplicateFileAction = useCallback(async (path: string): Promise<string | null> => {
    if (!rootHandleRef.current) return null;

    try {
      await flushSave();
      const parentHandle = await getParentHandle(rootHandleRef.current, path);
      const sourceName = getNameFromPath(path);
      const { fileHandle, fileName } = await fsDuplicateFile(parentHandle, sourceName);

      const parentPath = path.includes('/') ? path.slice(0, path.lastIndexOf('/')) : '';
      const newPath = parentPath ? `${parentPath}/${fileName}` : fileName;

      setActiveFilePath(newPath);
      activeFileHandleRef.current = fileHandle;
      await refreshTree();
      return newPath;
    } catch (err) {
      setError(`Failed to duplicate file: ${(err as Error).message}`);
      return null;
    }
  }, [flushSave, refreshTree]);

  // Delete multiple files in one run (used by multi-select in the sidebar)
  const deleteFilesAction = useCallback(async (paths: string[]) => {
    if (!rootHandleRef.current || paths.length === 0) return;

    const uniquePaths = Array.from(new Set(paths));
    const errors: string[] = [];

    for (const path of uniquePaths) {
      try {
        const name = getNameFromPath(path);
        const parentHandle = await getParentHandle(rootHandleRef.current, path);
        await fsDeleteFile(parentHandle, name);
      } catch (err) {
        errors.push(`${path}: ${(err as Error).message}`);
      }
    }

    if (activeFilePath && uniquePaths.includes(activeFilePath)) {
      setActiveFilePath(null);
      activeFileHandleRef.current = null;
    }

    await refreshTree();

    if (errors.length > 0) {
      setError(`Failed to delete some files:\n${errors.join('\n')}`);
    }
  }, [refreshTree, activeFilePath]);

  // Find node type in tree
  const findNodeType = useCallback((path: string): 'file' | 'folder' | null => {
    const search = (nodes: FileTreeNode[]): 'file' | 'folder' | null => {
      for (const n of nodes) {
        if (n.path === path) return n.type === 'folder' ? 'folder' : 'file';
        const found = search(n.children);
        if (found) return found;
      }
      return null;
    };
    return search(tree);
  }, [tree]);

  // Move a file or folder to a different folder
  const moveEntryAction = useCallback(async (sourcePath: string, targetFolderPath: string) => {
    if (!rootHandleRef.current) return;

    // Prevent dropping a folder into itself or its children
    if (sourcePath === targetFolderPath) return;
    if (targetFolderPath.startsWith(sourcePath + '/')) return;

    const nodeType = findNodeType(sourcePath);
    if (!nodeType) return;

    try {
      const sourceParent = await getParentHandle(rootHandleRef.current, sourcePath);
      let targetParent: FileSystemDirectoryHandle;
      if (targetFolderPath) {
        targetParent = rootHandleRef.current;
        for (const part of targetFolderPath.split('/')) {
          targetParent = await targetParent.getDirectoryHandle(part);
        }
      } else {
        targetParent = rootHandleRef.current;
      }
      const entryName = getNameFromPath(sourcePath);

      if (nodeType === 'folder') {
        await fsMoveDirectory(sourceParent, targetParent, entryName);
        // If active file was inside the moved folder, update its path
        if (activeFilePath?.startsWith(sourcePath + '/')) {
          const newBase = targetFolderPath ? `${targetFolderPath}/${entryName}` : entryName;
          const relativePart = activeFilePath.slice(sourcePath.length);
          setActiveFilePath(newBase + relativePart);
        }
      } else {
        const newHandle = await fsMoveFile(sourceParent, targetParent, entryName);
        if (activeFilePath === sourcePath) {
          const newPath = targetFolderPath ? `${targetFolderPath}/${entryName}` : entryName;
          setActiveFilePath(newPath);
          activeFileHandleRef.current = newHandle;
        }
      }

      await refreshTree();
    } catch (err) {
      setError(`Failed to move: ${(err as Error).message}`);
    }
  }, [refreshTree, activeFilePath, findNodeType]);

  // Rename a file or folder
  const renameEntryAction = useCallback(async (path: string, newName: string) => {
    if (!rootHandleRef.current) return;
    try {
      const parentHandle = await getParentHandle(rootHandleRef.current, path);
      const oldName = getNameFromPath(path);
      const findNode = (nodes: FileTreeNode[]): FileTreeNode | null => {
        for (const n of nodes) {
          if (n.path === path) return n;
          const found = findNode(n.children);
          if (found) return found;
        }
        return null;
      };
      const node = findNode(tree);
      const isDirectory = node?.type === 'folder';
      await fsRenameEntry(parentHandle, oldName, newName, isDirectory);
      await refreshTree();
    } catch (err) {
      setError(`Failed to rename: ${(err as Error).message}`);
    }
  }, [refreshTree, tree]);

  // Deselect active file (when user clicks a folder)
  const deselectFile = useCallback(() => {
    flushSave();
    setActiveFilePath(null);
    activeFileHandleRef.current = null;
  }, [flushSave]);

  /**
   * Recursively scan a directory for `.feature` files and extract their GUID tags.
   * The resulting map is used during import to detect existing files and overwrite
   * them in-place instead of creating duplicates.
   *
   * GUIDs are stored as `@<16 hex chars>` tags on the Feature line.
   */
  const scanExistingFeatureGuids = async (
    dirHandle: FileSystemDirectoryHandle,
    basePath: string,
  ): Promise<Map<string, { handle: FileSystemFileHandle; path: string }>> => {
    const guidMap = new Map<string, { handle: FileSystemFileHandle; path: string }>();
    const GUID_TAG_RE = /^@([0-9a-f]{16})$/;
    const walk = async (dh: FileSystemDirectoryHandle, currentPath: string) => {
      for await (const [name, entry] of (dh as any).entries()) {
        if (entry.kind === 'directory') {
          const subHandle = await dh.getDirectoryHandle(name);
          await walk(subHandle, `${currentPath}/${name}`);
        } else if (entry.kind === 'file' && name.endsWith('.feature')) {
          try {
            const fh = await dh.getFileHandle(name);
            const file = await fh.getFile();
            const text = await file.text();
            const feature = parseGherkin(text);
            // Collect GUID from tags (single source of truth)
            for (const tag of feature.tags) {
              const m = GUID_TAG_RE.exec(tag);
              if (m) guidMap.set(m[1], { handle: fh, path: `${currentPath}/${name}` });
            }
          } catch {
            // skip unparseable files
          }
        }
      }
    };
    await walk(dirHandle, basePath);
    return guidMap;
  };

  /**
   * Write a single parsed feature package to disk under the given directory.
   * Handles GUID generation, tag replacement, old-GUID propagation into step text,
   * and collision-safe file naming. If the GUID already exists on disk the existing
   * file is overwritten; otherwise a new file is created with a sanitized name.
   */
  const writeFeaturePkg = async (
    dir: FileSystemDirectoryHandle,
    dirPath: string,
    pkg: ParsedFeaturePackage,
    namePrefix: string,
    usedNames: Set<string>,
    existingGuids?: Map<string, { handle: FileSystemFileHandle; path: string }>,
  ): Promise<{ path: string; handle: FileSystemFileHandle }> => {
    const rawName = pkg.feature.name || pkg.sourceHeading || 'Test';
    const featureName = namePrefix ? `${namePrefix} ${rawName}` : rawName;

    // THE canonical GUID: chapterNum + name, no spaces, lowercased
    const guid = makeFeatureGuid(namePrefix, rawName);

    // Build tags: replace or insert GUID tag
    const GUID_RE = /^@(?:guid-)?([0-9a-f]{16})$/;
    const tags = [...pkg.feature.tags];
    const oldGuidIdx = tags.findIndex((t) => GUID_RE.test(t));
    const oldGuid = oldGuidIdx >= 0 ? tags[oldGuidIdx].match(GUID_RE)?.[1] ?? null : null;
    if (oldGuidIdx >= 0) {
      tags[oldGuidIdx] = `@guid-${guid}`;
    } else {
      tags.unshift(`@guid-${guid}`);
    }

    // Replace old GUID in steps if changed
    let scenarios = pkg.feature.scenarios;
    if (oldGuid && oldGuid !== guid) {
      scenarios = scenarios.map((sc) => ({
        ...sc,
        steps: sc.steps.map((step) => ({
          ...step,
          text: step.text.replaceAll(oldGuid, guid),
          dataTable: step.dataTable?.map((row) => row.map((cell) => cell.replaceAll(oldGuid, guid))),
        })),
      }));
    }

    const featureForWrite = {
      ...pkg.feature,
      name: featureName,
      tags,
      scenarios,
      description: pkg.feature.description || pkg.sourceText || '',
    };
    const text = generateGherkin(featureForWrite);

    // Check if file with same GUID exists → overwrite
    const existingByGuid = existingGuids?.get(guid) || (oldGuid ? existingGuids?.get(oldGuid) : undefined);
    if (existingByGuid) {
      const writable = await existingByGuid.handle.createWritable();
      await writable.write(text);
      await writable.close();
      return { path: existingByGuid.path, handle: existingByGuid.handle };
    }

    // New file
    let baseName = sanitizeName(featureName);
    let fileName = `${baseName}.feature`;
    let counter = 2;
    while (usedNames.has(fileName)) {
      fileName = `${baseName} (${counter}).feature`;
      counter++;
    }
    usedNames.add(fileName);

    const fileHandle = await dir.getFileHandle(fileName, { create: true });
    const writable = await fileHandle.createWritable();
    await writable.write(text);
    await writable.close();
    return { path: `${dirPath}/${fileName}`, handle: fileHandle };
  };

  // Import parsed DOCX packages into folder structure
  const importPackages = useCallback(async (
    packages: ParsedFeaturePackage[],
    targetFolderPath: string,
    groupFolderName: string,
    tocInfo?: { toc: TocEntry[]; tocNumbers: string[] },
  ): Promise<string | null> => {
    if (!rootHandleRef.current || packages.length === 0) return null;
    try {
      // Navigate to target folder
      let targetHandle: FileSystemDirectoryHandle = rootHandleRef.current;
      if (targetFolderPath) {
        for (const part of targetFolderPath.split('/')) {
          targetHandle = await targetHandle.getDirectoryHandle(part);
        }
      }

      // Create main group folder (idempotent — reuses existing)
      const mainName = sanitizeName(groupFolderName);
      const mainDir = await targetHandle.getDirectoryHandle(mainName, { create: true });
      const mainPath = targetFolderPath ? `${targetFolderPath}/${mainName}` : mainName;
      expandedPathsRef.current.add(mainPath);

      // Scan existing feature files for GUID-based deduplication
      const existingGuids = await scanExistingFeatureGuids(mainDir, mainPath);

      let firstFilePath: string | null = null;
      let firstFileHandle: FileSystemFileHandle | null = null;

      if (tocInfo && tocInfo.toc.length > 0) {
        // ── Hierarchical import based on full TOC structure ──

        // Step 1: Map each selected package to its exact TOC index.
        // This avoids false matches when multiple TOC entries share the same heading text.
        const selectedTocIndices = new Set<number>();
        const usedPkgIndices = new Set<number>();
        for (let i = 0; i < tocInfo.toc.length; i++) {
          if (tocInfo.toc[i].kind !== 'package') continue;
          const pkgIdx = packages.findIndex((p, pi) => p.sourceHeading === tocInfo.toc[i].text && !usedPkgIndices.has(pi));
          if (pkgIdx >= 0) {
            usedPkgIndices.add(pkgIdx);
            selectedTocIndices.add(i);
          }
        }

        // Step 2: For each selected TOC package, walk backwards to find ancestor folders.
        const allAncestorFolders = new Set<number>();
        for (const i of selectedTocIndices) {
          let targetLevel = tocInfo.toc[i].level;
          for (let j = i - 1; j >= 0; j--) {
            if (tocInfo.toc[j].level < targetLevel) {
              allAncestorFolders.add(j);
              targetLevel = tocInfo.toc[j].level;
              if (targetLevel <= 1) break;
            }
          }
        }

        // Walk the TOC and build a folder hierarchy.
        // Only structure entries with package descendants become folders.
        const dirStack: { level: number; handle: FileSystemDirectoryHandle; path: string }[] = [
          { level: 0, handle: mainDir, path: mainPath },
        ];

        const usedNamesPerDir = new Map<string, Set<string>>();
        usedNamesPerDir.set(mainPath, new Set());
        const consumedPkgs = new Set<number>(); // track consumed package indices

        for (let i = 0; i < tocInfo.toc.length; i++) {
          const entry = tocInfo.toc[i];
          const chNum = tocInfo.tocNumbers[i];

          // Pop stack to find parent: go back to the last entry with a lower level
          while (dirStack.length > 1 && dirStack[dirStack.length - 1].level >= entry.level) {
            dirStack.pop();
          }
          const parent = dirStack[dirStack.length - 1];

          if (allAncestorFolders.has(i)) {
            // Create a subfolder for any ancestor heading that contains tests below it
            const folderName = sanitizeName(`${chNum} ${entry.text}`);
            const subDir = await parent.handle.getDirectoryHandle(folderName, { create: true });
            const subPath = `${parent.path}/${folderName}`;
            expandedPathsRef.current.add(subPath);
            dirStack.push({ level: entry.level, handle: subDir, path: subPath });
            usedNamesPerDir.set(subPath, new Set());
          }
          if (selectedTocIndices.has(i)) {
            // Find next unconsumed matching package
            const pkgParent = dirStack[dirStack.length - 1];
            const pkgIdx = packages.findIndex((p, pi) => p.sourceHeading === entry.text && !consumedPkgs.has(pi));
            if (pkgIdx >= 0) {
              consumedPkgs.add(pkgIdx);
              const pkg = packages[pkgIdx];
              const usedNames = usedNamesPerDir.get(pkgParent.path) ?? new Set();
              usedNamesPerDir.set(pkgParent.path, usedNames);
              const result = await writeFeaturePkg(pkgParent.handle, pkgParent.path, pkg, chNum, usedNames, existingGuids);
              if (!firstFilePath) {
                firstFilePath = result.path;
                firstFileHandle = result.handle;
              }
            }
          }
        }

        // Write any remaining packages that weren't matched by TOC
        // (e.g. merged Feature Group packages whose sourceHeading is a structure heading)
        const unmatchedUsedNames = usedNamesPerDir.get(mainPath) ?? new Set();
        for (let pi = 0; pi < packages.length; pi++) {
          if (consumedPkgs.has(pi)) continue;
          const pkg = packages[pi];
          const result = await writeFeaturePkg(mainDir, mainPath, pkg, '', unmatchedUsedNames, existingGuids);
          if (!firstFilePath) {
            firstFilePath = result.path;
            firstFileHandle = result.handle;
          }
        }
      } else {
        // ── Flat import (no TOC): group by sourceHeading ──
        const groups = new Map<string, ParsedFeaturePackage[]>();
        for (const pkg of packages) {
          const heading = pkg.sourceHeading || 'Allgemein';
          if (!groups.has(heading)) groups.set(heading, []);
          groups.get(heading)!.push(pkg);
        }

        for (const [heading, pkgs] of groups) {
          const folderName = sanitizeName(heading);
          const subDir = await mainDir.getDirectoryHandle(folderName, { create: true });
          const subPath = `${mainPath}/${folderName}`;
          expandedPathsRef.current.add(subPath);

          const usedNames = new Set<string>();
          for (const pkg of pkgs) {
            const result = await writeFeaturePkg(subDir, subPath, pkg, '', usedNames, existingGuids);
            if (!firstFilePath) {
              firstFilePath = result.path;
              firstFileHandle = result.handle;
            }
          }
        }
      }

      // Refresh tree and open the first file
      await refreshTree();
      if (firstFilePath && firstFileHandle) {
        setActiveFilePath(firstFilePath);
        activeFileHandleRef.current = firstFileHandle;
      }

      return firstFilePath;
    } catch (err) {
      setError(`Import fehlgeschlagen: ${(err as Error).message}`);
      return null;
    }
  }, [refreshTree]);

  // Toggle explorer visibility
  const toggleExplorer = useCallback(() => {
    setIsVisible((prev) => {
      const next = !prev;
      localStorage.setItem('cucumbergnerator_explorer_visible', String(next));
      return next;
    });
  }, []);

  // Flush save on unmount
  useEffect(() => {
    return () => {
      if (saveTimerRef.current) {
        clearTimeout(saveTimerRef.current);
      }
    };
  }, []);

  // Ctrl+B shortcut to toggle explorer
  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if ((e.ctrlKey || e.metaKey) && e.key === 'b') {
        e.preventDefault();
        toggleExplorer();
      }
    };
    document.addEventListener('keydown', handler);
    return () => document.removeEventListener('keydown', handler);
  }, [toggleExplorer]);

  return {
    tree,
    activeFilePath,
    isVisible,
    isLoading,
    error,
    isDirectoryMode,
    isSupported,
    rootFolderName,
    rootHandle,
    dragOverPath,
    recentWorkspaces,
    openDirectory,
    createWorkspace,
    switchWorkspace,
    closeDirectory,
    refreshTree,
    toggleNode,
    expandNode,
    selectFile,
    selectScenario,
    saveActiveFile,
    flushSave,
    createFolder: createFolderAction,
    deleteFolder: deleteFolderAction,
    createFile: createFileAction,
    createFileWithName,
    deleteFile: deleteFileAction,
    duplicateFile: duplicateFileAction,
    deleteFiles: deleteFilesAction,
    moveEntry: moveEntryAction,
    renameEntry: renameEntryAction,
    deselectFile,
    importPackages,
    toggleExplorer,
    setDragOverPath,
    updateTreeForFeature,
  };
}
