import { useState, useCallback, useRef } from 'react';
import type { FileTreeNode } from '../../types/fileExplorer';
import { FileTreeItem } from './FileTreeItem';
import { ContextMenu } from './ContextMenu';
import { getNameFromPath } from '../../lib/fileSystemAccess';
import styles from './FileExplorer.module.css';

interface FileExplorerProps {
  tree: FileTreeNode[];
  activeFilePath: string | null;
  isLoading: boolean;
  isDirectoryMode: boolean;
  isSupported: boolean;
  error: string | null;
  rootFolderName: string | null;
  dragOverPath: string | null;
  agentFolderPaths: Set<string>;
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
  onFolderSelect?: (path: string) => void;
  onAddAgent?: (folderPath: string) => void;
  isLoggedIn?: boolean;
}

export function FileExplorer({
  tree,
  activeFilePath,
  isLoading,
  isDirectoryMode,
  isSupported,
  error,
  rootFolderName,
  dragOverPath,
  agentFolderPaths,
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
  onAddAgent,
  isLoggedIn = false,
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
              selectedFolderPath={selectedFolderPath}
              dragOverPath={dragOverPath}
              agentFolderPaths={agentFolderPaths}
              onSelect={(path) => onSelectFile(path)}
              onToggle={onToggleNode}
              onSelectFolder={(path) => { selectFolder(path); onDeselectFile(); }}
              onSelectScenario={(filePath, scenarioId) => onSelectScenario(filePath, scenarioId)}
              onContextMenu={handleContextMenu}
              onDragStart={handleDragStart}
              onDragOver={handleDragOver}
              onDragLeave={handleDragLeave}
              onDrop={handleDrop}
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
          agentFolderPaths={agentFolderPaths}
          isLoggedIn={isLoggedIn}
          onClose={() => setContextMenu(null)}
          onCreateFolder={handleCreateFolder}
          onCreateFile={onCreateFile}
          onDeleteFolder={onDeleteFolder}
          onDeleteFile={onDeleteFile}
          onRename={handleRename}
          onAddAgent={(path) => { onAddAgent?.(path); }}
        />
      )}
    </div>
  );
}
