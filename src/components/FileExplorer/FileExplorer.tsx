/**
 * @module FileExplorer
 * Sidebar component that renders the project directory tree and provides
 * toolbar actions for folder/file management.
 *
 * The component is a pure presentation layer — all file-system state lives in
 * `useFileExplorer` and is passed in as props. Drag-and-drop across tree nodes
 * (and from external sources) is coordinated via `onMoveFile` and
 * `onSetDragOverPath`.
 */

import { useState, useCallback, useRef, useMemo, useEffect } from 'react';
import type { FileTreeNode } from '../../types/fileExplorer';
import type { RecentWorkspace } from '../../lib/fileSystemAccess';
import { FileTreeItem } from './FileTreeItem';
import { ContextMenu } from './ContextMenu';
import { getNameFromPath } from '../../lib/fileSystemAccess';
import { ConfirmDialog } from '../ConfirmDialog/ConfirmDialog';
import { PromptDialog } from '../ConfirmDialog/PromptDialog';
import styles from './FileExplorer.module.css';

/** Props for {@link FileExplorer}. */
interface FileExplorerProps {
  /** Reactive tree snapshot from `useFileExplorer`. */
  tree: FileTreeNode[];
  /** Currently open file path, highlighted in the tree. */
  activeFilePath: string | null;
  /** When true, shows a loading spinner instead of the tree. */
  isLoading: boolean;
  /** When false, shows the "open directory" empty state. */
  isDirectoryMode: boolean;
  /** When false, renders a "not supported" message (non-Chromium browsers). */
  isSupported: boolean;
  /** File-system error to display below the toolbar. */
  error: string | null;
  /** Display name of the root folder shown in the toolbar. */
  rootFolderName: string | null;
  /** Path currently highlighted as a drag-over target. */
  dragOverPath: string | null;
  onSelectFile: (path: string) => Promise<void>;
  onSelectScenario: (filePath: string, scenarioId: string) => Promise<void>;
  onToggleNode: (path: string) => void;
  onOpenDirectory: () => Promise<void>;
  onCloseDirectory: () => void;
  onRefreshTree: () => Promise<void>;
  onCreateFolder: (parentPath: string, folderName?: string) => Promise<string | null>;
  onDeleteFolder: (path: string, confirmed?: boolean) => Promise<void>;
  onCreateFile: (parentPath: string, fileName?: string) => Promise<string | null | void>;
  onDeleteFile: (path: string, confirmed?: boolean) => Promise<void>;
  onDuplicateFile: (path: string) => Promise<void>;
  /** Delete multiple files in one operation (used by multi-select + Delete key). */
  onDeleteFiles?: (paths: string[]) => Promise<void>;
  onMoveFile: (sourcePath: string, targetFolderPath: string) => Promise<void>;
  onRenameEntry: (path: string, newName: string) => Promise<void>;
  onSetDragOverPath: (path: string | null) => void;
  onDeselectFile: () => void;
  /** Optional callback when the user clicks a folder (e.g. to set import target). */
  onFolderSelect?: (path: string) => void;
  /** Paths (file or scenario) with validation errors — rendered in red in the tree. */
  errorPaths?: Set<string>;
  /** Active scenario path (`filePath#scenarioId`) for sub-scenario highlighting. */
  activeScenarioPath?: string | null;
  /** List of recently opened workspaces for quick switching. */
  recentWorkspaces?: RecentWorkspace[];
  /** Called when the user picks a recent workspace to switch to. */
  onSwitchWorkspace?: (handle: FileSystemDirectoryHandle) => Promise<void>;
}

/**
 * File tree sidebar with toolbar, drag-and-drop support, and context menu.
 *
 * Folder selection is tracked locally so the toolbar buttons (new file,
 * new folder, delete) always target the most recently focused folder.
 * Drop events on the root area (below all tree nodes) move entries to the
 * root of the project directory.
 */
export function FileExplorer({
  tree,
  activeFilePath,
  isLoading,
  isDirectoryMode,
  isSupported,
  error,
  rootFolderName,
  dragOverPath,
  onSelectFile,
  onSelectScenario,
  onToggleNode,
  onOpenDirectory,
  onCloseDirectory,
  onRefreshTree,
  onCreateFolder,
  onDeleteFolder,
  onCreateFile,
  onDeleteFile,
  onDuplicateFile,
  onDeleteFiles,
  onMoveFile,
  onRenameEntry,
  onSetDragOverPath,
  onDeselectFile,
  onFolderSelect,
  errorPaths = new Set<string>(),
  activeScenarioPath = null,
  recentWorkspaces = [],
  onSwitchWorkspace,
}: FileExplorerProps) {
  const [showWorkspacePicker, setShowWorkspacePicker] = useState(false);
  const workspacePickerRef = useRef<HTMLDivElement>(null);

  // Close dropdown on outside click
  useEffect(() => {
    if (!showWorkspacePicker) return;
    const handler = (e: MouseEvent) => {
      if (workspacePickerRef.current && !workspacePickerRef.current.contains(e.target as Node)) {
        setShowWorkspacePicker(false);
      }
    };
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, [showWorkspacePicker]);
  const [contextMenu, setContextMenu] = useState<{ x: number; y: number; node: FileTreeNode } | null>(null);
  const [selectedFolderPath, setSelectedFolderPath] = useState<string | null>(null);
  const [selectedFilePaths, setSelectedFilePaths] = useState<Set<string>>(new Set());
  const [selectionAnchorPath, setSelectionAnchorPath] = useState<string | null>(null);
  const [createFolderTarget, setCreateFolderTarget] = useState<string | null>(null);
  const [createFileTarget, setCreateFileTarget] = useState<string | null>(null);
  const [renameTarget, setRenameTarget] = useState<{ path: string; defaultName: string } | null>(null);
  const [confirmDeletePaths, setConfirmDeletePaths] = useState<string[] | null>(null);
  const [confirmDeleteFolder, setConfirmDeleteFolder] = useState<string | null>(null);
  const [confirmDeleteFile, setConfirmDeleteFile] = useState<string | null>(null);
  const dragSourceRef = useRef<string | null>(null);

  const visibleFilePaths = useMemo(() => {
    const paths: string[] = [];
    const walk = (nodes: FileTreeNode[]) => {
      for (const node of nodes) {
        if (node.type === 'file') {
          paths.push(node.path);
        }
        if (node.expanded && node.children.length > 0) {
          walk(node.children);
        }
      }
    };
    walk(tree);
    return paths;
  }, [tree]);

  const selectFolder = useCallback((path: string) => {
    setSelectedFolderPath(path);
    onFolderSelect?.(path);
  }, [onFolderSelect]);

  // Wrap onCreateFolder to auto-select new folder
  const handleCreateFolder = useCallback(async (parentPath: string) => {
    setCreateFolderTarget(parentPath);
  }, []);

  const submitCreateFolder = useCallback(async (name: string) => {
    if (createFolderTarget === null) return;
    const newPath = await onCreateFolder(createFolderTarget, name);
    if (newPath) {
      selectFolder(newPath);
    }
    setCreateFolderTarget(null);
  }, [createFolderTarget, onCreateFolder, selectFolder]);

  const handleContextMenu = useCallback((e: React.MouseEvent, node: FileTreeNode) => {
    setContextMenu({ x: e.clientX, y: e.clientY, node });
  }, []);

  const handleDragStart = useCallback((e: React.DragEvent, path: string) => {
    const selectedPaths = selectedFilePaths.has(path) ? Array.from(selectedFilePaths) : [path];
    dragSourceRef.current = path;
    e.dataTransfer.setData('application/x-cucumber-paths', JSON.stringify(selectedPaths));
    e.dataTransfer.setData('text/plain', path);
    e.dataTransfer.effectAllowed = 'move';
  }, [selectedFilePaths]);

  const handleDragOver = useCallback((_e: React.DragEvent, path: string) => {
    onSetDragOverPath(path);
  }, [onSetDragOverPath]);

  const handleDragLeave = useCallback(() => {
    onSetDragOverPath(null);
  }, [onSetDragOverPath]);

  const handleDrop = useCallback((e: React.DragEvent, targetPath: string) => {
    onSetDragOverPath(null);
    const rawPaths = e.dataTransfer.getData('application/x-cucumber-paths');
    const parsedPaths = rawPaths ? (JSON.parse(rawPaths) as string[]) : null;
    const sourcePath = e.dataTransfer.getData('text/plain') || dragSourceRef.current;
    dragSourceRef.current = null;
    const sourcePaths = parsedPaths && parsedPaths.length > 0
      ? parsedPaths
      : (sourcePath ? [sourcePath] : []);
    if (sourcePaths.length === 0) return;

    void (async () => {
      for (const oneSource of sourcePaths) {
        if (!oneSource || oneSource === targetPath) continue;
        const sourceParent = oneSource.includes('/') ? oneSource.substring(0, oneSource.lastIndexOf('/')) : '';
        if (sourceParent === targetPath) continue;
        if (targetPath.startsWith(oneSource + '/')) continue;
        await onMoveFile(oneSource, targetPath);
      }
      setSelectedFilePaths(new Set());
      setSelectionAnchorPath(null);
    })();
  }, [onMoveFile, onSetDragOverPath]);

  const handleRename = useCallback((path: string) => {
    const oldName = getNameFromPath(path);
    const displayName = oldName.replace(/\.feature$/, '');
    setRenameTarget({ path, defaultName: displayName });
  }, [onRenameEntry]);

  // Allow dropping on root (empty tree area)
  const handleRootDragOver = useCallback((e: React.DragEvent) => {
    e.preventDefault();
    onSetDragOverPath('');
  }, [onSetDragOverPath]);

  const handleRootDrop = useCallback((e: React.DragEvent) => {
    e.preventDefault();
    onSetDragOverPath(null);
    const rawPaths = e.dataTransfer.getData('application/x-cucumber-paths');
    const parsedPaths = rawPaths ? (JSON.parse(rawPaths) as string[]) : null;
    const sourcePath = e.dataTransfer.getData('text/plain') || dragSourceRef.current;
    dragSourceRef.current = null;
    const sourcePaths = parsedPaths && parsedPaths.length > 0
      ? parsedPaths
      : (sourcePath ? [sourcePath] : []);
    if (sourcePaths.length === 0) return;

    void (async () => {
      for (const oneSource of sourcePaths) {
        const sourceParent = oneSource.includes('/') ? oneSource.substring(0, oneSource.lastIndexOf('/')) : '';
        if (sourceParent === '') continue;
        await onMoveFile(oneSource, '');
      }
      setSelectedFilePaths(new Set());
      setSelectionAnchorPath(null);
    })();
  }, [onMoveFile, onSetDragOverPath]);

  const handleDeleteSelectedFiles = useCallback(async () => {
    if (selectedFilePaths.size === 0) return;
    setConfirmDeletePaths(Array.from(selectedFilePaths));
  }, [selectedFilePaths, onDeleteFiles, onDeleteFile]);

  const confirmDeleteSelectedFiles = useCallback(async () => {
    const selected = confirmDeletePaths ?? [];
    if (selected.length === 0) return;
    if (onDeleteFiles) {
      await onDeleteFiles(selected);
    } else {
      for (const path of selected) {
        await onDeleteFile(path, true);
      }
    }
    setSelectedFilePaths(new Set());
    setSelectionAnchorPath(null);
    setConfirmDeletePaths(null);
  }, [confirmDeletePaths, onDeleteFiles, onDeleteFile]);

  const submitCreateFile = useCallback(async (name: string) => {
    if (createFileTarget === null) return;
    await onCreateFile(createFileTarget, name);
    setCreateFileTarget(null);
  }, [createFileTarget, onCreateFile]);

  const submitRename = useCallback(async (newName: string) => {
    if (!renameTarget) return;
    if (newName && newName !== renameTarget.defaultName) {
      await onRenameEntry(renameTarget.path, newName);
    }
    setRenameTarget(null);
  }, [renameTarget, onRenameEntry]);

  const confirmDeleteFolderAction = useCallback(async () => {
    if (!confirmDeleteFolder) return;
    await onDeleteFolder(confirmDeleteFolder, true);
    setConfirmDeleteFolder(null);
  }, [confirmDeleteFolder, onDeleteFolder]);

  const confirmDeleteFileAction = useCallback(async () => {
    if (!confirmDeleteFile) return;
    await onDeleteFile(confirmDeleteFile, true);
    setConfirmDeleteFile(null);
  }, [confirmDeleteFile, onDeleteFile]);

  const handleFileClick = useCallback((path: string, event: React.MouseEvent) => {
    const isToggle = event.ctrlKey || event.metaKey;
    const isRange = event.shiftKey;

    if (isRange && selectionAnchorPath && visibleFilePaths.includes(selectionAnchorPath)) {
      const a = visibleFilePaths.indexOf(selectionAnchorPath);
      const b = visibleFilePaths.indexOf(path);
      if (a >= 0 && b >= 0) {
        const start = Math.min(a, b);
        const end = Math.max(a, b);
        const range = visibleFilePaths.slice(start, end + 1);
        setSelectedFilePaths(new Set(range));
      } else {
        setSelectedFilePaths(new Set([path]));
      }
    } else if (isToggle) {
      setSelectedFilePaths((prev) => {
        const next = new Set(prev);
        if (next.has(path)) next.delete(path);
        else next.add(path);
        return next;
      });
      setSelectionAnchorPath(path);
    } else {
      setSelectedFilePaths(new Set([path]));
      setSelectionAnchorPath(path);
    }

    setSelectedFolderPath(null);
    onSelectFile(path);
  }, [onSelectFile, selectionAnchorPath, visibleFilePaths]);

  const handleScenarioClick = useCallback((filePath: string, scenarioId: string) => {
    setSelectedFilePaths(new Set([filePath]));
    setSelectionAnchorPath(filePath);
    setSelectedFolderPath(null);
    onSelectScenario(filePath, scenarioId);
  }, [onSelectScenario]);

  useEffect(() => {
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key !== 'Delete') return;

      const target = e.target as HTMLElement | null;
      if (target) {
        const tag = target.tagName.toLowerCase();
        if (tag === 'input' || tag === 'textarea' || tag === 'select' || target.isContentEditable) {
          return;
        }
      }

      e.preventDefault();

      if (selectedFilePaths.size > 0) {
        void handleDeleteSelectedFiles();
        return;
      }

      if (selectedFolderPath && selectedFolderPath !== '') {
        setConfirmDeleteFolder(selectedFolderPath);
        setSelectedFolderPath(null);
        return;
      }

      if (activeFilePath) {
        setConfirmDeleteFile(activeFilePath);
      }
    };

    document.addEventListener('keydown', onKeyDown);
    return () => document.removeEventListener('keydown', onKeyDown);
  }, [selectedFilePaths, selectedFolderPath, activeFilePath, handleDeleteSelectedFiles, onDeleteFolder, onDeleteFile]);

  if (!isSupported) {
    return (
      <div className={styles.sidebar}>
        <div className={styles.notSupported}>
          File System Access API wird nur in Chrome und Edge unterstützt.
        </div>
      </div>
    );
  }

  return (
    <div className={styles.sidebar}>
      {/* Toolbar */}
      <div className={styles.toolbar}>
        <div className={styles.workspaceSwitcher} ref={workspacePickerRef}>
          <button
            className={styles.workspaceNameBtn}
            onClick={() => setShowWorkspacePicker((v) => !v)}
            type="button"
            title={recentWorkspaces.length > 0 ? 'Workspace wechseln' : rootFolderName ?? 'Explorer'}
          >
            <span className={styles.workspaceNameLabel}>{rootFolderName || 'Explorer'}</span>
            {recentWorkspaces.length > 0 && <span className={styles.workspaceChevron}>▾</span>}
          </button>
          {showWorkspacePicker && (
            <div className={styles.workspaceDropdown}>
              {recentWorkspaces.map((ws) => (
                <button
                  key={ws.name}
                  className={ws.name === rootFolderName ? styles.workspaceItemActive : styles.workspaceItem}
                  type="button"
                  onClick={() => {
                    setShowWorkspacePicker(false);
                    void onSwitchWorkspace?.(ws.handle);
                  }}
                >
                  📂 {ws.name}
                </button>
              ))}
              <div className={styles.workspaceDivider} />
              <button
                className={styles.workspaceItem}
                type="button"
                onClick={() => {
                  setShowWorkspacePicker(false);
                  void onOpenDirectory();
                }}
              >
                📁+ Ordner öffnen...
              </button>
            </div>
          )}
        </div>
        {selectedFilePaths.size > 0 && (
          <span className={styles.selectionBadge} title={`${selectedFilePaths.size} Datei(en) markiert`}>
            {selectedFilePaths.size} ausgew.
          </span>
        )}
        {isDirectoryMode && (
          <>
            <button
              className={styles.toolbarBtn}
              onClick={() => handleCreateFolder(selectedFolderPath || '')}
              type="button"
              title={selectedFolderPath ? `Neuer Ordner in "${selectedFolderPath}"` : 'Neuer Ordner'}
            >
              📁+
            </button>
            <button
              className={styles.toolbarBtn}
              onClick={() => {
                setCreateFileTarget(selectedFolderPath ?? '');
              }}
              type="button"
              title={selectedFolderPath ? `Neue Feature-Datei in "${selectedFolderPath}"` : `Neue Feature-Datei in "${rootFolderName}"`}
            >
              📄+
            </button>
            <button
              className={styles.toolbarBtn}
              onClick={() => {
                if (selectedFilePaths.size > 0) {
                  void handleDeleteSelectedFiles();
                } else if (selectedFolderPath && selectedFolderPath !== '') {
                  setConfirmDeleteFolder(selectedFolderPath);
                } else if (activeFilePath) {
                  setConfirmDeleteFile(activeFilePath);
                }
              }}
              type="button"
              title={
                selectedFilePaths.size > 0
                  ? `${selectedFilePaths.size} Datei(en) loeschen`
                  : selectedFolderPath && selectedFolderPath !== ''
                  ? `"${selectedFolderPath}" löschen`
                  : activeFilePath
                    ? `"${activeFilePath}" löschen`
                    : 'Löschen'
              }
              disabled={selectedFilePaths.size === 0 && !(selectedFolderPath && selectedFolderPath !== '') && !activeFilePath}
            >
              🗑️
            </button>
            <button
              className={styles.toolbarBtn}
              onClick={onRefreshTree}
              type="button"
              title="Aktualisieren"
            >
              ↻
            </button>
            <button
              className={styles.toolbarBtn}
              onClick={onCloseDirectory}
              type="button"
              title="Ordner schließen"
            >
              ✕
            </button>
          </>
        )}
      </div>

      {/* Error */}
      {error && (
        <div className={styles.error}>{error}</div>
      )}

      {/* Loading */}
      {isLoading && (
        <div className={styles.loading}>
          <div className={styles.spinner} />
          Ordner wird gelesen...
        </div>
      )}

      {/* Tree or Empty State */}
      {!isLoading && isDirectoryMode && (
        <div
          className={styles.treeContainer}
          onDragOver={handleRootDragOver}
          onDrop={handleRootDrop}
        >
          {/* Root folder node */}
          <div
            className={selectedFolderPath === '' ? styles.treeItemActive : styles.treeItem}
            style={{ paddingLeft: '8px' }}
            onClick={() => {
              selectFolder('');
              onDeselectFile();
              setSelectedFilePaths(new Set());
              setSelectionAnchorPath(null);
            }}
          >
            <span className={styles.chevronExpanded}>▶</span>
            <span className={styles.nodeIcon}>📂</span>
            <span className={styles.nodeLabel}>{rootFolderName}</span>
          </div>
          {tree.map((node) => (
            <FileTreeItem
              key={node.path}
              node={node}
              depth={1}
              activeFilePath={activeFilePath}
              activeScenarioPath={activeScenarioPath}
              selectedFolderPath={selectedFolderPath}
              selectedFilePaths={selectedFilePaths}
              dragOverPath={dragOverPath}
              onSelect={handleFileClick}
              onToggle={onToggleNode}
              onSelectFolder={(path) => {
                selectFolder(path);
                onDeselectFile();
                setSelectedFilePaths(new Set());
                setSelectionAnchorPath(null);
              }}
              onSelectScenario={handleScenarioClick}
              onContextMenu={handleContextMenu}
              onDragStart={handleDragStart}
              onDragOver={handleDragOver}
              onDragLeave={handleDragLeave}
              onDrop={handleDrop}
              errorPaths={errorPaths}
            />
          ))}
        </div>
      )}

      {!isLoading && !isDirectoryMode && (
        <div className={styles.emptyState}>
          <div className={styles.emptyIcon}>📂</div>
          <div className={styles.emptyText}>
            Ordner öffnen, um .feature-Dateien direkt auf der Festplatte zu bearbeiten.
          </div>
          <button className={styles.openBtn} onClick={onOpenDirectory} type="button">
            Ordner öffnen
          </button>
          {recentWorkspaces.length > 0 && (
            <div className={styles.recentWorkspaces}>
              <div className={styles.recentWorkspacesLabel}>Zuletzt geöffnet</div>
              {recentWorkspaces.map((ws) => (
                <button
                  key={ws.name}
                  className={styles.recentWorkspaceItem}
                  type="button"
                  onClick={() => void onSwitchWorkspace?.(ws.handle)}
                >
                  📂 {ws.name}
                </button>
              ))}
            </div>
          )}
        </div>
      )}

      {/* Context Menu */}
      {contextMenu && (
        <ContextMenu
          x={contextMenu.x}
          y={contextMenu.y}
          node={contextMenu.node}
          onClose={() => setContextMenu(null)}
          onCreateFolder={handleCreateFolder}
          onCreateFile={(parentPath) => setCreateFileTarget(parentPath)}
          onDeleteFolder={(path) => setConfirmDeleteFolder(path)}
          onDuplicateFile={(path) => { void onDuplicateFile(path); }}
          onDeleteFile={async (path) => {
            setConfirmDeleteFile(path);
            setSelectedFilePaths((prev) => {
              if (!prev.has(path)) return prev;
              const next = new Set(prev);
              next.delete(path);
              return next;
            });
            if (selectionAnchorPath === path) setSelectionAnchorPath(null);
          }}
          onRename={handleRename}
        />
      )}

      {createFolderTarget !== null && (
        <PromptDialog
          title="Neuer Ordner"
          message="Bitte den Namen fuer den neuen Ordner eingeben."
          placeholder="Ordnername"
          confirmLabel="Erstellen"
          cancelLabel="Abbrechen"
          onConfirm={submitCreateFolder}
          onCancel={() => setCreateFolderTarget(null)}
        />
      )}

      {createFileTarget !== null && (
        <PromptDialog
          title="Neue Feature-Datei"
          message="Bitte den Dateinamen eingeben (.feature wird bei Bedarf ergänzt)."
          placeholder="Dateiname"
          confirmLabel="Erstellen"
          cancelLabel="Abbrechen"
          onConfirm={submitCreateFile}
          onCancel={() => setCreateFileTarget(null)}
        />
      )}

      {renameTarget && (
        <PromptDialog
          title="Umbenennen"
          message="Bitte den neuen Namen eingeben."
          placeholder="Neuer Name"
          defaultValue={renameTarget.defaultName}
          confirmLabel="Umbenennen"
          cancelLabel="Abbrechen"
          onConfirm={submitRename}
          onCancel={() => setRenameTarget(null)}
        />
      )}

      {confirmDeletePaths && (
        <ConfirmDialog
          title="Loeschen bestaetigen"
          message={`${confirmDeletePaths.length} ${confirmDeletePaths.length === 1 ? 'Datei' : 'Dateien'} jetzt loeschen?`}
          confirmLabel="Loeschen"
          cancelLabel="Abbrechen"
          onConfirm={confirmDeleteSelectedFiles}
          onCancel={() => setConfirmDeletePaths(null)}
        />
      )}

      {confirmDeleteFolder && (
        <ConfirmDialog
          title="Loeschen bestaetigen"
          message={`Ordner "${getNameFromPath(confirmDeleteFolder)}" jetzt loeschen?`}
          confirmLabel="Loeschen"
          cancelLabel="Abbrechen"
          onConfirm={confirmDeleteFolderAction}
          onCancel={() => setConfirmDeleteFolder(null)}
        />
      )}

      {confirmDeleteFile && (
        <ConfirmDialog
          title="Loeschen bestaetigen"
          message={`Datei "${getNameFromPath(confirmDeleteFile)}" jetzt loeschen?`}
          confirmLabel="Loeschen"
          cancelLabel="Abbrechen"
          onConfirm={confirmDeleteFileAction}
          onCancel={() => setConfirmDeleteFile(null)}
        />
      )}
    </div>
  );
}
