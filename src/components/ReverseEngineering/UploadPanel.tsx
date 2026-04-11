/**
 * @module UploadPanel
 * Sidebar panel for the Reverse Engineering view that manages FOP folder selection
 * and triggers analysis runs.
 *
 * Key responsibilities: opens a directory via the File System Access API, recursively
 * collects FOP files, displays the currently loaded directory with reload/close controls,
 * shows binding counts grouped by mask, and exposes "Analyze selection" / "Analyze all"
 * action buttons with a live token-cost estimate.
 *
 * @exports UploadPanel (default)
 */
import { useState } from 'react';
import { useTranslation } from '../../i18n';
import type { FopBinding } from '../../types/fop';
import styles from './UploadPanel.module.css';

interface UploadPanelProps {
  onFopsLoaded: (files: { relativePath: string; content: string }[]) => void;
  onDirectorySelected?: (dirHandle: FileSystemDirectoryHandle) => void;
  /** Use the currently open file-explorer directory for FOP analysis */
  onUseExplorerDir?: () => void;
  cacheStats: { cached: number; stale: number; total: number } | null;
  requiredDatabases: number[];
  missingDatabases: number[];
  onAnalyzeSelection: (selectedPaths: string[]) => void;
  onAnalyzeAll: () => void;
  onClearCache: () => void;
  isAnalyzing: boolean;
  isLoading: boolean;
  selectedBindings: string[];
  onSelectionChange: (paths: string[]) => void;
  bindings: FopBinding[];
  fopFilesCount: number;
  /** Name of the currently selected FOP root directory */
  selectedDirName?: string | null;
  /** Reload the current directory */
  onReloadDirectory?: () => void;
  /** Close/remove the saved directory */
  onCloseDirectory?: () => void;
  lang: 'de' | 'en';
}

// Recursively collect all files from a directory handle
async function collectFiles(
  dirHandle: FileSystemDirectoryHandle,
  prefix = '',
): Promise<{ relativePath: string; content: string }[]> {
  const results: { relativePath: string; content: string }[] = [];

  for await (const [name, handle] of dirHandle) {
    const relPath = prefix ? `${prefix}/${name}` : name;

    if (handle.kind === 'directory') {
      if (name.startsWith('.') || name === 'Konzept') continue;
      const sub = await collectFiles(handle as FileSystemDirectoryHandle, relPath);
      results.push(...sub);
    } else {
      if (name.endsWith('.fopanalyzer')) continue;
      try {
        const file = await (handle as FileSystemFileHandle).getFile();
        const content = await file.text();
        results.push({ relativePath: relPath, content });
      } catch {
        // Skip unreadable files
      }
    }
  }

  return results;
}

// Group bindings by mask number
function groupByMask(bindings: FopBinding[]): Map<number | '*', FopBinding[]> {
  const map = new Map<number | '*', FopBinding[]>();
  for (const b of bindings) {
    const key = b.mask;
    if (!map.has(key)) map.set(key, []);
    map.get(key)!.push(b);
  }
  return map;
}

export default function UploadPanel({
  onFopsLoaded,
  onDirectorySelected,
  onUseExplorerDir,
  cacheStats,
  requiredDatabases,
  missingDatabases,
  onAnalyzeSelection,
  onAnalyzeAll,
  onClearCache,
  isAnalyzing,
  isLoading,
  selectedBindings,
  onSelectionChange,
  bindings,
  fopFilesCount,
  selectedDirName,
  onReloadDirectory,
  onCloseDirectory,
}: UploadPanelProps) {
  const { lang } = useTranslation();
  const [dirOpening, setDirOpening] = useState(false);

  const handleOpenDirectory = async () => {
    if (!window.showDirectoryPicker) {
      alert(
        lang === 'de'
          ? 'Ihr Browser unterstützt die Directory Picker API nicht.'
          : 'Your browser does not support the Directory Picker API.',
      );
      return;
    }
    try {
      setDirOpening(true);
      const dirHandle = await window.showDirectoryPicker({ mode: 'readwrite' });
      if (onDirectorySelected) {
        onDirectorySelected(dirHandle);
      } else {
        const files = await collectFiles(dirHandle);
        onFopsLoaded(files);
      }
    } catch (err) {
      if ((err as DOMException).name !== 'AbortError') {
        console.error('Directory picker error:', err);
      }
    } finally {
      setDirOpening(false);
    }
  };

  const handleBindingToggle = (fopPath: string) => {
    if (selectedBindings.includes(fopPath)) {
      onSelectionChange(selectedBindings.filter((p) => p !== fopPath));
    } else {
      onSelectionChange([...selectedBindings, fopPath]);
    }
  };

  const handleMaskToggle = (maskBindings: FopBinding[]) => {
    const paths = maskBindings.map((b) => b.fopPath);
    const allSelected = paths.every((p) => selectedBindings.includes(p));
    if (allSelected) {
      onSelectionChange(selectedBindings.filter((p) => !paths.includes(p)));
    } else {
      const newPaths = paths.filter((p) => !selectedBindings.includes(p));
      onSelectionChange([...selectedBindings, ...newPaths]);
    }
  };

  const grouped = groupByMask(bindings);
  const selectionTokenEstimate = Math.ceil(selectedBindings.length * 1.5);

  const busy = isAnalyzing || isLoading || dirOpening;

  return (
    <aside className={styles.panel}>
      {/* Upload actions */}
      <section className={styles.section}>
        <h3 className={styles.sectionTitle}>{lang === 'de' ? 'FOP-Ordner' : 'FOP Folder'}</h3>

        {/* Status: currently selected directory */}
        {selectedDirName ? (
          <div className={styles.statusRow}>
            <span className={styles.statusIcon}>📁</span>
            <span className={styles.statusText} title={selectedDirName}>{selectedDirName}</span>
            {fopFilesCount > 0 && (
              <span className={styles.statusCount}>
                {fopFilesCount} FOPs
              </span>
            )}
            {onReloadDirectory && (
              <button type="button" className={styles.iconBtn} onClick={onReloadDirectory} disabled={busy} title={lang === 'de' ? 'Ordner neu laden' : 'Reload folder'}>
                ⟳
              </button>
            )}
            {onCloseDirectory && (
              <button type="button" className={styles.iconBtn} onClick={onCloseDirectory} disabled={busy} title={lang === 'de' ? 'Ordner entfernen' : 'Remove folder'}>
                ✕
              </button>
            )}
          </div>
        ) : (
          <p className={styles.hint}>
            {lang === 'de' ? 'Kein Ordner ausgewählt' : 'No folder selected'}
          </p>
        )}

        {isLoading && (
          <p className={styles.loadingHint}>
            ⟳ {lang === 'de' ? 'FOPs werden geladen…' : 'Loading FOPs…'}
          </p>
        )}

        <button
          type="button"
          className={styles.uploadBtn}
          onClick={handleOpenDirectory}
          disabled={busy}
        >
          {dirOpening
            ? (lang === 'de' ? 'Öffne…' : 'Opening…')
            : (lang === 'de' ? 'FOP-Ordner öffnen' : 'Open FOP folder')}
        </button>

        {/* Shortcut: use the already-open file explorer directory */}
        {onUseExplorerDir && (
          <button
            type="button"
            className={styles.uploadBtnSecondary}
            onClick={onUseExplorerDir}
            disabled={busy}
            title={lang === 'de'
              ? 'Aktuell geöffneten Explorer-Ordner verwenden'
              : 'Use currently open explorer folder'}
          >
            {lang === 'de' ? '← Aus Explorer übernehmen' : '← Use from explorer'}
          </button>
        )}
      </section>

      {/* Bindings info (from FOP.txt uploaded in main editor) */}
      {bindings.length > 0 && (
        <section className={styles.section}>
          <div className={styles.statusRow}>
            <span className={styles.statusIcon}>✓</span>
            <span className={styles.statusText}>
              {bindings.length} {lang === 'de' ? 'FOP-Bindungen geladen' : 'FOP bindings loaded'}
            </span>
          </div>
        </section>
      )}


      {/* Analyze buttons */}
      <section className={styles.analyzeSection}>
        <button
          type="button"
          className={styles.analyzeBtn}
          onClick={() => onAnalyzeSelection(selectedBindings)}
          disabled={busy || selectedBindings.length === 0}
        >
          {busy ? '⟳ …' : `${lang === 'de' ? 'Auswahl analysieren' : 'Analyze selection'} (~${selectionTokenEstimate}k T)`}
        </button>
        <button
          type="button"
          className={styles.analyzeAllBtn}
          onClick={onAnalyzeAll}
          disabled={busy || bindings.length === 0}
        >
          {busy ? '⟳ …' : (lang === 'de' ? 'Alle analysieren' : 'Analyze all')}
        </button>
      </section>
    </aside>
  );
}
