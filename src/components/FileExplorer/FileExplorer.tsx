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

import { useState, useCallback, useRef } from 'react';
import type { FileTreeNode } from '../../types/fileExplorer';
import { FileTreeItem } from './FileTreeItem';
import { ContextMenu } from './ContextMenu';
import { getNameFromPath } from '../../lib/fileSystemAccess';
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
  onCreateFolder: (parentPath: string) => Promise<string | null>;
  onDeleteFolder: (path: string) => Promise<void>;
  onCreateFile: (parentPath: string) => Promise<string | null | void>;
  onDeleteFile: (path: string) => Promise<void>;
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
  onMoveFile,
  onRenameEntry,
  onSetDragOverPath,
  onDeselectFile,
  onFolderSelect,
  errorPaths = new Set<string>(),
  activeScenarioPath = null,
}: FileExplorerProps) {
  const [contextMenu, setContextMenu] = useState<{ x: number; y: number; node: FileTreeNode } | null>(null);
  const [selectedFolderPath, setSelectedFolderPath] = useState<string | null>(null);
  const dragSourceRef = useRef<string | null>(null);

  const selectFolder = useCallback((path: string) => {
    setSelectedFolderPath(path);
    onFolderSelect?.(path);
  }, [onFolderSelect]);

  // Wrap onCreateFolder to auto-select new folder
  const handleCreateFolder = useCallback(async (parentPath: string) => {
    const newPath = await onCreateFolder(parentPath);
    if (newPath) {
      selectFolder(newPath);
    }
  }, [onCreateFolder, selectFolder]);

  const handleContextMenu = useCallback((e: React.MouseEvent, node: FileTreeNode) => {
    setContextMenu({ x: e.clientX, y: e.clientY, node });
  }, []);

  const handleDragStart = useCallback((e: React.DragEvent, path: string) => {
    dragSourceRef.current = path;
    e.dataTransfer.setData('text/plain', path);
    e.dataTransfer.effectAllowed = 'move';
  }, []);

  const handleDragOver = useCallback((_e: React.DragEvent, path: string) => {
    onSetDragOverPath(path);
  }, [onSetDragOverPath]);

  const handleDragLeave = useCallback(() => {
    onSetDragOverPath(null);
  }, [onSetDragOverPath]);

  const handleDrop = useCallback((e: React.DragEvent, targetPath: string) => {
    onSetDragOverPath(null);
    const sourcePath = e.dataTransfer.getData('text/plain') || dragSourceRef.current;
    dragSourceRef.current = null;
    if (!sourcePath || sourcePath === targetPath) return;
    // Don't allow dropping into the same parent folder
    const sourceParent = sourcePath.includes('/') ? sourcePath.substring(0, sourcePath.lastIndexOf('/')) : '';
    if (sourceParent === targetPath) return;
    // Don't allow dropping a folder into itself or its children
    if (targetPath.startsWith(sourcePath + '/')) return;
    onMoveFile(sourcePath, targetPath);
  }, [onMoveFile, onSetDragOverPath]);

  const handleRename = useCallback((path: string) => {
    const oldName = getNameFromPath(path);
    const displayName = oldName.replace(/\.feature$/, '');
    const newName = window.prompt('Neuer Name:', displayName);
    if (newName && newName !== displayName) {
      onRenameEntry(path, newName);
    }
  }, [onRenameEntry]);

  // Allow dropping on root (empty tree area)
  const handleRootDragOver = useCallback((e: React.DragEvent) => {
    e.preventDefault();
    onSetDragOverPath('');
  }, [onSetDragOverPath]);

  const handleRootDrop = useCallback((e: React.DragEvent) => {
    e.preventDefault();
    onSetDragOverPath(null);
    const sourcePath = e.dataTransfer.getData('text/plain') || dragSourceRef.current;
    dragSourceRef.current = null;
    if (!sourcePath) return;
    // Move to root
    const sourceParent = sourcePath.includes('/') ? sourcePath.substring(0, sourcePath.lastIndexOf('/')) : '';
    if (sourceParent === '') return; // Already in root
    onMoveFile(sourcePath, '');
  }, [onMoveFile, onSetDragOverPath]);

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
        <span className={styles.toolbarTitle}>
          {rootFolderName || 'Explorer'}
        </span>
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
                onCreateFile(selectedFolderPath ?? '');
              }}
              type="button"
              title={selectedFolderPath ? `Neue Feature-Datei in "${selectedFolderPath}"` : `Neue Feature-Datei in "${rootFolderName}"`}
            >
              📄+
            </button>
            <button
              className={styles.toolbarBtn}
              onClick={() => {
                if (selectedFolderPath && selectedFolderPath !== '') {
                  onDeleteFolder(selectedFolderPath);
                } else if (activeFilePath) {
                  onDeleteFile(activeFilePath);
                }
              }}
              type="button"
              title={
                selectedFolderPath && selectedFolderPath !== ''
                  ? `"${selectedFolderPath}" löschen`
                  : activeFilePath
                    ? `"${activeFilePath}" löschen`
                    : 'Löschen'
              }
              disabled={!(selectedFolderPath && selectedFolderPath !== '') && !activeFilePath}
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
            onClick={() => { selectFolder(''); onDeselectFile(); }}
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
              dragOverPath={dragOverPath}
              onSelect={(path) => onSelectFile(path)}
              onToggle={onToggleNode}
              onSelectFolder={(path) => { selectFolder(path); onDeselectFile(); }}
              onSelectScenario={(filePath, scenarioId) => onSelectScenario(filePath, scenarioId)}
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
          <button
            className={styles.openBtn}
            onClick={onOpenDirectory}
            type="button"
          >
            Ordner öffnen
          </button>
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
          onCreateFile={onCreateFile}
          onDeleteFolder={onDeleteFolder}
          onDeleteFile={onDeleteFile}
          onRename={handleRename}
        />
      )}
    </div>
  );
}
