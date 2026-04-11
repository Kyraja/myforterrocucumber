/**
 * @module ContextMenu
 * Right-click context menu for FileExplorer tree nodes (folders and files).
 *
 * Key responsibilities:
 * - Renders context-sensitive actions depending on node type: folders get create/rename/delete,
 *   files get rename/delete; scenario nodes are ignored (returns null).
 * - Positions itself within the viewport bounds to avoid clipping at screen edges.
 * - Closes automatically when a click outside the menu is detected.
 * @prop {number} x - Screen X coordinate for placement.
 * @prop {number} y - Screen Y coordinate for placement.
 * @prop {FileTreeNode} node - The tree node that was right-clicked.
 * @prop {() => void} onClose - Callback to dismiss the menu.
 */
import { useEffect, useRef } from 'react';
import type { FileTreeNode } from '../../types/fileExplorer';
import styles from './FileExplorer.module.css';

interface ContextMenuProps {
  x: number;
  y: number;
  node: FileTreeNode;
  onClose: () => void;
  onCreateFolder: (parentPath: string) => void;
  onCreateFile: (parentPath: string) => void;
  onDeleteFolder: (path: string) => void;
  onDeleteFile: (path: string) => void;
  onRename: (path: string) => void;
}

export function ContextMenu({
  x,
  y,
  node,
  onClose,
  onCreateFolder,
  onCreateFile,
  onDeleteFolder,
  onDeleteFile,
  onRename,
}: ContextMenuProps) {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) {
        onClose();
      }
    };
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, [onClose]);

  // Adjust position to stay within viewport
  const style: React.CSSProperties = {
    left: Math.min(x, window.innerWidth - 180),
    top: Math.min(y, window.innerHeight - 220),
  };

  if (node.type === 'scenario') return null;

  return (
    <div ref={ref} className={styles.contextMenu} style={style}>
      {node.type === 'folder' && (
        <>
          <button
            className={styles.contextMenuItem}
            onClick={() => { onCreateFolder(node.path); onClose(); }}
            type="button"
          >
            📁 Neuer Ordner
          </button>
          <button
            className={styles.contextMenuItem}
            onClick={() => { onCreateFile(node.path); onClose(); }}
            type="button"
          >
            📄 Neue Feature-Datei
          </button>
          <div className={styles.contextMenuDivider} />
          <button
            className={styles.contextMenuItem}
            onClick={() => { onRename(node.path); onClose(); }}
            type="button"
          >
            ✏️ Umbenennen
          </button>
          <button
            className={styles.contextMenuDanger}
            onClick={() => { onDeleteFolder(node.path); onClose(); }}
            type="button"
          >
            🗑️ Ordner löschen
          </button>
        </>
      )}
      {node.type === 'file' && (
        <>
          <button
            className={styles.contextMenuItem}
            onClick={() => { onRename(node.path); onClose(); }}
            type="button"
          >
            ✏️ Umbenennen
          </button>
          <button
            className={styles.contextMenuDanger}
            onClick={() => { onDeleteFile(node.path); onClose(); }}
            type="button"
          >
            🗑️ Datei löschen
          </button>
        </>
      )}
    </div>
  );
}
