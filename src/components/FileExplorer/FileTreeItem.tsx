/**
 * @module FileTreeItem
 * Recursive tree node component for the FileExplorer sidebar.
 *
 * Key responsibilities:
 * - Renders a single folder, feature file, or scenario node with appropriate icon and indentation.
 * - Handles click (select/toggle/navigate), right-click (context menu), and drag-and-drop events.
 * - Highlights the active file, active scenario, selected folder, and drag-over target.
 * - Recursively renders child nodes when the node is expanded.
 * @prop {FileTreeNode} node - The tree node to render.
 * @prop {number} depth - Nesting depth used to compute left padding.
 */
import { useCallback } from 'react';
import type { FileTreeNode } from '../../types/fileExplorer';
import styles from './FileExplorer.module.css';

interface FileTreeItemProps {
  node: FileTreeNode;
  depth: number;
  activeFilePath: string | null;
  activeScenarioPath: string | null;
  selectedFolderPath: string | null;
  selectedFilePaths: Set<string>;
  dragOverPath: string | null;
  onSelect: (path: string, event: React.MouseEvent) => void;
  onToggle: (path: string) => void;
  onSelectFolder: (path: string) => void;
  onSelectScenario: (filePath: string, scenarioId: string) => void;
  onContextMenu: (e: React.MouseEvent, node: FileTreeNode) => void;
  onDragStart: (e: React.DragEvent, path: string) => void;
  onDragOver: (e: React.DragEvent, path: string) => void;
  onDragLeave: (e: React.DragEvent) => void;
  onDrop: (e: React.DragEvent, targetPath: string) => void;
  errorPaths: Set<string>;
}

export function FileTreeItem({
  node,
  depth,
  activeFilePath,
  activeScenarioPath,
  selectedFolderPath,
  selectedFilePaths,
  dragOverPath,
  onSelect,
  onToggle,
  onSelectFolder,
  onSelectScenario,
  onContextMenu,
  onDragStart,
  onDragOver,
  onDragLeave,
  onDrop,
  errorPaths,
}: FileTreeItemProps) {
  const hasChildren = node.children.length > 0;
  const isActive = (node.type === 'file' && node.path === activeFilePath)
    || (node.type === 'scenario' && node.path === activeScenarioPath);
  const isFileSelected = node.type === 'file' && selectedFilePaths.has(node.path);
  const isFolderSelected = node.type === 'folder' && node.path === selectedFolderPath;
  const isDragOver = node.type === 'folder' && node.path === dragOverPath;
  const hasError = errorPaths.has(node.path);

  const handleClick = useCallback((event: React.MouseEvent) => {
    if (node.type === 'folder') {
      onSelectFolder(node.path);
      onToggle(node.path);
    } else if (node.type === 'file') {
      const isActiveFile = node.path === activeFilePath;
      const hasModifier = event.shiftKey || event.ctrlKey || event.metaKey;
      if (isActiveFile && node.expanded && hasChildren && !hasModifier) {
        onToggle(node.path);
      } else {
        onSelect(node.path, event);
      }
    } else if (node.type === 'scenario') {
      const filePath = node.path.split('#')[0];
      onSelectScenario(filePath, node.scenarioId ?? '');
    }
  }, [node, onSelect, onSelectFolder, onToggle, onSelectScenario, hasChildren, activeFilePath]);

  const handleContextMenu = useCallback((e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    onContextMenu(e, node);
  }, [node, onContextMenu]);

  const handleDragStart = useCallback((e: React.DragEvent) => {
    if (node.type === 'file' || node.type === 'folder') {
      onDragStart(e, node.path);
    }
  }, [node, onDragStart]);

  const handleDragOver = useCallback((e: React.DragEvent) => {
    if (node.type === 'folder') {
      e.preventDefault();
      e.stopPropagation();
      onDragOver(e, node.path);
    }
  }, [node, onDragOver]);

  const handleDragLeave = useCallback((e: React.DragEvent) => {
    e.stopPropagation();
    onDragLeave(e);
  }, [onDragLeave]);

  const handleDrop = useCallback((e: React.DragEvent) => {
    if (node.type === 'folder') {
      e.preventDefault();
      e.stopPropagation();
      onDrop(e, node.path);
    }
  }, [node, onDrop]);

  // Icon
  let icon: string;
  if (node.type === 'folder') {
    icon = node.expanded ? '📂' : '📁';
  } else if (node.type === 'file') {
    icon = '🥒';
  } else {
    icon = '📋';
  }

  // Chevron
  let chevronClass: string;
  if (!hasChildren && node.type !== 'folder') {
    chevronClass = styles.chevronHidden;
  } else if (node.expanded) {
    chevronClass = styles.chevronExpanded;
  } else {
    chevronClass = styles.chevron;
  }

  // Item class
  let itemClass = isActive || isFolderSelected ? styles.treeItemActive : styles.treeItem;
  if (!isActive && isFileSelected) {
    itemClass = `${styles.treeItem} ${styles.treeItemSelected}`;
  }
  if (isDragOver) {
    itemClass = `${itemClass} ${styles.treeItemDragOver}`;
  }

  return (
    <>
      <div
        className={itemClass}
        style={{ paddingLeft: `${8 + depth * 16}px` }}
        onClick={handleClick}
        onContextMenu={handleContextMenu}
        draggable={node.type !== 'scenario'}
        onDragStart={handleDragStart}
        onDragOver={handleDragOver}
        onDragLeave={handleDragLeave}
        onDrop={handleDrop}
        title={node.type === 'file' ? node.path : undefined}
      >
        <span className={chevronClass}>▶</span>
        <span className={styles.nodeIcon}>{icon}</span>
        <span className={`${node.type === 'scenario' ? styles.scenarioLabel : styles.nodeLabel}${hasError ? ` ${styles.errorLabel}` : ''}`}>
          {node.displayName}
        </span>
      </div>
      {node.expanded && hasChildren && node.children.map((child) => (
        <FileTreeItem
          key={child.path}
          node={child}
          depth={depth + 1}
          activeFilePath={activeFilePath}
          activeScenarioPath={activeScenarioPath}
          selectedFolderPath={selectedFolderPath}
          selectedFilePaths={selectedFilePaths}
          dragOverPath={dragOverPath}
          onSelect={onSelect}
          onToggle={onToggle}
          onSelectFolder={onSelectFolder}
          onSelectScenario={onSelectScenario}
          onContextMenu={onContextMenu}
          onDragStart={onDragStart}
          onDragOver={onDragOver}
          onDragLeave={onDragLeave}
          onDrop={onDrop}
          errorPaths={errorPaths}
        />
      ))}
    </>
  );
}
