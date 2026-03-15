import { useState, useCallback, useRef, useEffect } from 'react';
import type { FeatureInput, ParsedFeaturePackage } from '../types/gherkin';
import type { FileTreeNode } from '../types/fileExplorer';
import { generateGherkin } from '../lib/generator';
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
  moveFile as fsMoveFile,
  moveDirectory as fsMoveDirectory,
  renameEntry as fsRenameEntry,
  getParentHandle,
  getNameFromPath,
  sanitizeName,
} from '../lib/fileSystemAccess';

export interface UseFileExplorerReturn {
  // State
  tree: FileTreeNode[];
  activeFilePath: string | null;
  isVisible: boolean;
  isLoading: boolean;
  error: string | null;
  isDirectoryMode: boolean;
  isSupported: boolean;
  rootFolderName: string | null;
  dragOverPath: string | null;

  // Actions
  openDirectory: () => Promise<void>;
  closeDirectory: () => void;
  refreshTree: () => Promise<void>;
  toggleNode: (path: string) => void;
  selectFile: (path: string) => Promise<FeatureInput | null>;
  selectScenario: (filePath: string, scenarioId: string) => Promise<FeatureInput | null>;
  saveActiveFile: (feature: FeatureInput) => void;
  flushSave: () => Promise<void>;
  createFolder: (parentPath: string) => Promise<string | null>;
  deleteFolder: (path: string) => Promise<void>;
  createFile: (parentPath: string) => Promise<string | null>;
  deleteFile: (path: string) => Promise<void>;
  moveEntry: (sourcePath: string, targetFolderPath: string) => Promise<void>;
  renameEntry: (path: string, newName: string) => Promise<void>;
  deselectFile: () => void;
  importPackages: (packages: ParsedFeaturePackage[], targetFolderPath: string, groupFolderName: string) => Promise<string | null>;
  toggleExplorer: () => void;
  setDragOverPath: (path: string | null) => void;
  updateTreeForFeature: (path: string, feature: FeatureInput) => void;
}

export function useFileExplorer(): UseFileExplorerReturn {
  const [rootHandle, setRootHandle] = useState<FileSystemDirectoryHandle | null>(null);
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

  // Try to restore saved handle on mount
  useEffect(() => {
    if (!isSupported) return;
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
  const createFolderAction = useCallback(async (parentPath: string): Promise<string | null> => {
    if (!rootHandleRef.current) return null;
    const name = window.prompt('Ordnername:');
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
  const deleteFolderAction = useCallback(async (path: string) => {
    if (!rootHandleRef.current) return;
    const name = getNameFromPath(path);
    if (!window.confirm(`"${name}" löschen?`)) return;
    try {
      const parentHandle = await getParentHandle(rootHandleRef.current, path);
      await fsDeleteFolder(parentHandle, name);
      await refreshTree();
    } catch (err) {
      setError(`Failed to delete folder: ${(err as Error).message}`);
    }
  }, [refreshTree]);

  // Create a file
  const createFileAction = useCallback(async (parentPath: string): Promise<string | null> => {
    if (!rootHandleRef.current) return null;
    const name = window.prompt('Dateiname:');
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
  const deleteFileAction = useCallback(async (path: string) => {
    if (!rootHandleRef.current) return;
    const name = getNameFromPath(path);
    if (!window.confirm(`"${name}" löschen?`)) return;
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

  // Import parsed DOCX packages into folder structure
  const importPackages = useCallback(async (
    packages: ParsedFeaturePackage[],
    targetFolderPath: string,
    groupFolderName: string,
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

      // Create main group folder
      const mainName = sanitizeName(groupFolderName);
      const mainDir = await targetHandle.getDirectoryHandle(mainName, { create: true });
      const mainPath = targetFolderPath ? `${targetFolderPath}/${mainName}` : mainName;
      expandedPathsRef.current.add(mainPath);

      // Group packages by sourceHeading
      const groups = new Map<string, ParsedFeaturePackage[]>();
      for (const pkg of packages) {
        const heading = pkg.sourceHeading || 'Allgemein';
        if (!groups.has(heading)) groups.set(heading, []);
        groups.get(heading)!.push(pkg);
      }

      let firstFilePath: string | null = null;
      let firstFileHandle: FileSystemFileHandle | null = null;

      for (const [heading, pkgs] of groups) {
        // Create subfolder per chapter
        const folderName = sanitizeName(heading);
        const subDir = await mainDir.getDirectoryHandle(folderName, { create: true });
        const subPath = `${mainPath}/${folderName}`;
        expandedPathsRef.current.add(subPath);

        // Track used filenames to avoid duplicates
        const usedNames = new Set<string>();

        for (const pkg of pkgs) {
          // Generate unique filename
          let baseName = sanitizeName(pkg.feature.name || heading);
          let fileName = `${baseName}.feature`;
          let counter = 2;
          while (usedNames.has(fileName)) {
            fileName = `${baseName} (${counter}).feature`;
            counter++;
          }
          usedNames.add(fileName);

          // Write file content
          const text = generateGherkin(pkg.feature);
          const fileHandle = await subDir.getFileHandle(fileName, { create: true });
          const writable = await fileHandle.createWritable();
          await writable.write(text);
          await writable.close();

          // Track first file for auto-open
          if (!firstFilePath) {
            firstFilePath = `${subPath}/${fileName}`;
            firstFileHandle = fileHandle;
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
    dragOverPath,
    openDirectory,
    closeDirectory,
    refreshTree,
    toggleNode,
    selectFile,
    selectScenario,
    saveActiveFile,
    flushSave,
    createFolder: createFolderAction,
    deleteFolder: deleteFolderAction,
    createFile: createFileAction,
    deleteFile: deleteFileAction,
    moveEntry: moveEntryAction,
    renameEntry: renameEntryAction,
    deselectFile,
    importPackages,
    toggleExplorer,
    setDragOverPath,
    updateTreeForFeature,
  };
}
