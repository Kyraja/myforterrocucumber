import { useCallback } from 'react';
import type { FileTreeNode } from '../../types/fileExplorer';
import styles from './FileExplorer.module.css';

interface FileTreeItemProps {
  node: FileTreeNode;
  depth: number;
  activeFilePath: string | null;
  selectedFolderPath: string | null;
  dragOverPath: string | null;
  agentFolderPaths: Set<string>;
  onSelect: (path: string) => void;
  onToggle: (path: string) => void;
  onSelectFolder: (path: string) => void;
  onSelectScenario: (filePath: string, scenarioId: string) => void;
  onContextMenu: (e: React.MouseEvent, node: FileTreeNode) => void;
  onDragStart: (e: React.DragEvent, path: string) => void;
  onDragOver: (e: React.DragEvent, path: string) => void;
  onDragLeave: (e: React.DragEvent) => void;
  onDrop: (e: React.DragEvent, targetPath: string) => void;
}

export function FileTreeItem({
  node,
  depth,
  activeFilePath,
  selectedFolderPath,
  dragOverPath,
  agentFolderPaths,
  onSelect,
  onToggle,
  onSelectFolder,
  onSelectScenario,
  onContextMenu,
  onDragStart,
  onDragOver,
  onDragLeave,
  onDrop,
}: FileTreeItemProps) {
  const hasChildren = node.children.length > 0;
  const isActive = node.type === 'file' && node.path === activeFilePath;
  const isFolderSelected = node.type === 'folder' && node.path === selectedFolderPath;
  const isDragOver = node.type === 'folder' && node.path === dragOverPath;
  const isAgentFolder = node.type === 'folder' && agentFolderPaths.has(node.path);

  const handleClick = useCallback(() => {
    if (node.type === 'folder') {
      onSelectFolder(node.path);
      onToggle(node.path);
    } else if (node.type === 'file') {
      onSelect(node.path);
      // Also expand to show scenarios
      if (!node.expanded && hasChildren) {
        onToggle(node.path);
      }
    } else if (node.type === 'scenario' && node.scenarioId) {
      // Extract parent file path
      const filePath = node.path.split('#')[0];
      onSelectScenario(filePath, node.scenarioId);
    }
  }, [node, onSelect, onToggle, onSelectScenario, hasChildren]);

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
    if (isAgentFolder) {
      icon = '🤖';
    } else {
      icon = node.expanded ? '📂' : '📁';
    }
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
        <span className={node.type === 'scenario' ? styles.scenarioLabel : styles.nodeLabel}>
          {node.displayName}
        </span>
      </div>
      {node.expanded && hasChildren && node.children.map((child) => (
        <FileTreeItem
          key={child.path}
          node={child}
          depth={depth + 1}
          activeFilePath={activeFilePath}
          selectedFolderPath={selectedFolderPath}
          dragOverPath={dragOverPath}
          agentFolderPaths={agentFolderPaths}
          onSelect={onSelect}
          onToggle={onToggle}
          onSelectFolder={onSelectFolder}
          onSelectScenario={onSelectScenario}
          onContextMenu={onContextMenu}
          onDragStart={onDragStart}
          onDragOver={onDragOver}
          onDragLeave={onDragLeave}
          onDrop={onDrop}
        />
      ))}
    </>
  );
}
