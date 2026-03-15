import { useEffect, useRef } from 'react';
import type { FileTreeNode } from '../../types/fileExplorer';
import styles from './FileExplorer.module.css';

interface ContextMenuProps {
  x: number;
  y: number;
  node: FileTreeNode;
  agentFolderPaths: Set<string>;
  isLoggedIn: boolean;
  onClose: () => void;
  onCreateFolder: (parentPath: string) => void;
  onCreateFile: (parentPath: string) => void;
  onDeleteFolder: (path: string) => void;
  onDeleteFile: (path: string) => void;
  onRename: (path: string) => void;
  onAddAgent: (path: string) => void;
}

export function ContextMenu({
  x,
  y,
  node,
  agentFolderPaths,
  isLoggedIn,
  onClose,
  onCreateFolder,
  onCreateFile,
  onDeleteFolder,
  onDeleteFile,
  onRename,
  onAddAgent,
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

  const isTopLevelFolder = node.type === 'folder' && !node.path.includes('/');
  const hasAgent = agentFolderPaths.has(node.path);

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
          {isTopLevelFolder && isLoggedIn && !hasAgent && (
            <>
              <div className={styles.contextMenuDivider} />
              <button
                className={styles.contextMenuItem}
                onClick={() => { onAddAgent(node.path); onClose(); }}
                type="button"
              >
                🤖 Agent hinzufügen
              </button>
            </>
          )}
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
