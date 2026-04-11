/**
 * @module KnowledgeBaseTab
 * Tab panel for managing and inspecting the local abas ERP online-help
 * knowledge base. Allows consultants to import HTML help folders, browse the
 * resulting chunks with expand/collapse, rate individual entries (thumbs up /
 * down), add free-text notes and custom keywords, and run a search simulator
 * that mirrors the relevance ranking used during AI prompt construction.
 *
 * Key responsibilities: folder ingestion via parseHtmlFolder, persistence via
 * kbStore, chunk browsing/filtering, and KB search simulation against loaded
 * TableDef context.
 */
import { useState, useRef, useCallback } from 'react';
import type { KBDocument, KBChunk, KBSearchResult } from '../../types/knowledgeBase';
import type { TableDef } from '../../types/gherkin';
import { parseHtmlFolder, filterHtmlFiles } from '../../lib/htmlHelpParser';
import { saveKBDocument, saveKBChunks, deleteKBDocument, loadKBChunksByDocId, updateKBChunk } from '../../lib/kbStore';
import { invalidateChunkCache, searchKnowledgeBase, getCachedChunks, findRelevantChains } from '../../lib/kbSearch';
import { isKBChainsEnabled } from '../../lib/settings';
import styles from './KnowledgeBaseTab.module.css';

interface KnowledgeBaseTabProps {
  documents: KBDocument[];
  onDocumentsChange: (docs: KBDocument[]) => void;
  lang: 'de' | 'en';
  tableDefs?: TableDef[];
}

export default function KnowledgeBaseTab({ documents, onDocumentsChange, lang, tableDefs = [] }: KnowledgeBaseTabProps) {
  const folderInputRef = useRef<HTMLInputElement>(null);
  const [uploading, setUploading] = useState(false);

  // ── KB Search Simulator state ──
  const [simQuery, setSimQuery] = useState('');
  const [simTableRef, setSimTableRef] = useState('');
  const [simResults, setSimResults] = useState<KBSearchResult[] | null>(null);
  const [simRunning, setSimRunning] = useState(false);
  const [progress, setProgress] = useState<{ phase: string; current: number; total: number; detail?: string } | null>(null);
  const [selectedDocId, setSelectedDocId] = useState<string | null>(null);
  const [chunks, setChunks] = useState<KBChunk[]>([]);
  const [expandedChunks, setExpandedChunks] = useState<Set<string>>(new Set());
  const [editingNote, setEditingNote] = useState<string | null>(null);
  const [noteText, setNoteText] = useState('');
  const [editingKeywords, setEditingKeywords] = useState<string | null>(null);
  const [keywordsText, setKeywordsText] = useState('');
  const [searchFilter, setSearchFilter] = useState('');
  const [showHtml, setShowHtml] = useState<Set<string>>(new Set());

  const handleFolderSelect = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || files.length === 0) return;

    // Copy files to array BEFORE resetting input (some browsers clear FileList on reset)
    const fileArray = Array.from(files);
    e.target.value = '';

    console.log('[KB] Total files in folder:', fileArray.length);
    console.log('[KB] Sample names:', fileArray.slice(0, 5).map(f => f.name));

    const htmlFiles = filterHtmlFiles(fileArray);
    if (htmlFiles.length === 0) {
      alert(lang === 'de'
        ? 'Keine .html-Dateien im Ordner gefunden.'
        : 'No .html files found in folder.');
      return;
    }

    setUploading(true);
    setProgress({ phase: lang === 'de' ? 'HTML-Dateien lesen...' : 'Reading HTML files...', current: 0, total: htmlFiles.length });

    try {
      const docId = crypto.randomUUID();

      // Detect folder name from file paths
      const firstPath = (htmlFiles[0] as { webkitRelativePath?: string }).webkitRelativePath ?? htmlFiles[0].name;
      const folderName = firstPath.includes('/') ? firstPath.split('/')[0] : 'HTML-Hilfe';

      const docChunks = await parseHtmlFolder(htmlFiles, docId, (info) => {
        setProgress({
          phase: info.phase === 'parsing'
            ? (lang === 'de' ? `Datei ${info.current}/${info.total}` : `File ${info.current}/${info.total}`)
            : (lang === 'de' ? 'Index erstellen...' : 'Building index...'),
          current: info.current,
          total: info.total,
          detail: info.currentFile,
        });
      });

      if (docChunks.length === 0) {
        alert(lang === 'de'
          ? 'Keine Feld-Hilfen in den HTML-Dateien gefunden. Nur abas ERP Onlinehilfe-HTML wird unterstützt.'
          : 'No field help entries found in the HTML files. Only abas ERP online help HTML is supported.');
        return;
      }

      setProgress({ phase: lang === 'de' ? 'Speichern...' : 'Saving...', current: 0, total: 0 });
      const doc: KBDocument = {
        id: docId,
        fileName: folderName,
        uploadedAt: Date.now(),
        fileCount: htmlFiles.length,
        chunkCount: docChunks.length,
        totalChars: docChunks.reduce((s, c) => s + c.charCount, 0),
      };
      await saveKBDocument(doc);
      await saveKBChunks(docChunks);
      invalidateChunkCache();

      onDocumentsChange([...documents, doc]);
      setSelectedDocId(docId);
      setChunks(docChunks);
    } catch (err) {
      console.error('[KnowledgeBase] Import failed:', err);
      alert(`${lang === 'de' ? 'Fehler beim Verarbeiten' : 'Processing error'}: ${(err as Error).message}`);
    } finally {
      setUploading(false);
      setProgress(null);
    }
  };

  const handleSelectDoc = async (docId: string) => {
    setSelectedDocId(docId);
    const loaded = await loadKBChunksByDocId(docId);
    setChunks(loaded.sort((a, b) => a.index - b.index));
    setExpandedChunks(new Set());
    setSearchFilter('');
  };

  const handleDeleteDoc = async (docId: string) => {
    const doc = documents.find(d => d.id === docId);
    if (!confirm(lang === 'de'
      ? `"${doc?.fileName}" wirklich löschen?`
      : `Delete "${doc?.fileName}"?`)) return;

    await deleteKBDocument(docId);
    invalidateChunkCache();
    onDocumentsChange(documents.filter(d => d.id !== docId));
    if (selectedDocId === docId) {
      setSelectedDocId(null);
      setChunks([]);
    }
  };

  const handleRate = async (chunk: KBChunk, rating: number) => {
    const updated = { ...chunk, rating: chunk.rating === rating ? 0 : rating };
    await updateKBChunk(updated);
    invalidateChunkCache();
    setChunks(prev => prev.map(c => c.id === chunk.id ? updated : c));
  };

  const handleSaveNote = async (chunk: KBChunk) => {
    const updated = { ...chunk, note: noteText.trim() || undefined };
    await updateKBChunk(updated);
    invalidateChunkCache();
    setChunks(prev => prev.map(c => c.id === chunk.id ? updated : c));
    setEditingNote(null);
    setNoteText('');
  };

  const handleSaveKeywords = async (chunk: KBChunk) => {
    const newKeywords = keywordsText
      .split(',')
      .map(k => k.trim())
      .filter(k => k.length > 0);
    const updated = { ...chunk, keywords: newKeywords.length > 0 ? newKeywords : undefined };
    await updateKBChunk(updated);
    invalidateChunkCache();
    setChunks(prev => prev.map(c => c.id === chunk.id ? updated : c));
    setEditingKeywords(null);
    setKeywordsText('');
  };

  const toggleExpanded = useCallback((chunkId: string) => {
    setExpandedChunks(prev => {
      const next = new Set(prev);
      if (next.has(chunkId)) next.delete(chunkId); else next.add(chunkId);
      return next;
    });
  }, []);

  const toggleHtml = useCallback((chunkId: string) => {
    setShowHtml(prev => {
      const next = new Set(prev);
      if (next.has(chunkId)) next.delete(chunkId); else next.add(chunkId);
      return next;
    });
  }, []);

  const handleSimSearch = useCallback(async () => {
    if (!simQuery.trim() && !simTableRef.trim()) return;
    setSimRunning(true);
    try {
      const allChunks = await getCachedChunks();
      // Build tables from simTableRef input (comma-separated refs like "0:1, 2:1")
      const refs = simTableRef.split(',').map(r => r.trim()).filter(Boolean);
      const tables: TableDef[] = refs.map(ref => {
        const found = tableDefs.find(t => t.tableRef === ref);
        return found ?? { name: ref, tableRef: ref, kind: 'database' as const, fields: [] };
      });
      const processChains = isKBChainsEnabled() ? findRelevantChains(tables) : [];
      // Return ALL results (high limit), not just top 3
      const results = searchKnowledgeBase(allChunks, {
        tables,
        processChains,
        requirementsText: simQuery,
      }, 50);
      setSimResults(results);
    } catch (err) {
      console.error('[KB Simulator] Search failed:', err);
      setSimResults([]);
    } finally {
      setSimRunning(false);
    }
  }, [simQuery, simTableRef, tableDefs]);

  const selectedDoc = documents.find(d => d.id === selectedDocId);

  // Filter chunks by search term (matches keywords, heading, anchor)
  const filteredChunks = searchFilter.trim()
    ? chunks.filter(c => {
        const q = searchFilter.toLowerCase();
        return (
          c.heading.toLowerCase().includes(q) ||
          c.anchorName?.toLowerCase().includes(q) ||
          c.keywords?.some(k => k.toLowerCase().includes(q)) ||
          c.text.toLowerCase().includes(q)
        );
      })
    : chunks;

  return (
    <div className={styles.root}>
      {/* Left: Document list */}
      <div className={styles.leftPanel}>
        <input
          ref={folderInputRef}
          type="file"
          /* @ts-expect-error webkitdirectory is not in standard typings */
          webkitdirectory=""
          multiple
          onChange={handleFolderSelect}
          className={styles.hidden}
        />
        <button
          type="button"
          className={styles.uploadBtn}
          onClick={() => folderInputRef.current?.click()}
          disabled={uploading}
        >
          {uploading
            ? (lang === 'de' ? '⟳ Verarbeite...' : '⟳ Processing...')
            : (lang === 'de' ? '📁 HTML-Ordner importieren' : '📁 Import HTML folder')}
        </button>

        {/* Progress */}
        {progress && (
          <div className={styles.progressSection}>
            <div className={styles.progressBar}>
              <div className={styles.progressFill} style={{ width: progress.total > 0 ? `${(progress.current / progress.total) * 100}%` : '0%' }} />
            </div>
            <span className={styles.progressText}>{progress.phase}</span>
            {progress.detail && <span className={styles.progressHeading}>{progress.detail}</span>}
          </div>
        )}

        {/* Document list */}
        <div className={styles.docList}>
          {documents.length === 0 && !uploading && (
            <p className={styles.empty}>
              {lang === 'de'
                ? 'Keine Hilfe-Ordner importiert. Wähle einen Ordner mit abas-Onlinehilfe .html-Dateien.'
                : 'No help folders imported. Select a folder with abas online help .html files.'}
            </p>
          )}
          {documents.map(doc => (
            <div
              key={doc.id}
              className={`${styles.docItem} ${selectedDocId === doc.id ? styles.docItemActive : ''}`}
              onClick={() => handleSelectDoc(doc.id)}
            >
              <div className={styles.docInfo}>
                <span className={styles.docName}>📁 {doc.fileName}</span>
                <span className={styles.docMeta}>
                  {doc.fileCount} {lang === 'de' ? 'Dateien' : 'files'} · {doc.chunkCount} {lang === 'de' ? 'Hilfen' : 'entries'}
                </span>
              </div>
              <button
                type="button"
                className={styles.docDeleteBtn}
                onClick={(e) => { e.stopPropagation(); handleDeleteDoc(doc.id); }}
                title={lang === 'de' ? 'Löschen' : 'Delete'}
              >
                ✕
              </button>
            </div>
          ))}
        </div>
      </div>

      {/* Right: Chunk viewer OR Search simulator */}
      <div className={styles.rightPanel}>
        {/* Simulator toggle */}
        <div className={styles.simToggleBar}>
          <button
            type="button"
            className={`${styles.simToggleBtn} ${simResults !== null ? styles.simToggleActive : ''}`}
            onClick={() => setSimResults(simResults !== null ? null : [])}
          >
            {lang === 'de' ? '🔍 KB-Suche simulieren' : '🔍 Simulate KB search'}
          </button>
        </div>

        {simResults !== null ? (
          /* ── Search Simulator ── */
          <div className={styles.simPanel}>
            <div className={styles.simInputRow}>
              <textarea
                className={styles.simTextarea}
                placeholder={lang === 'de'
                  ? 'Anforderungstext eingeben (wie bei der KI-Generierung)...'
                  : 'Enter requirements text (as used for AI generation)...'}
                value={simQuery}
                onChange={e => setSimQuery(e.target.value)}
                rows={4}
              />
            </div>
            <div className={styles.simInputRow}>
              <label className={styles.simLabel}>
                {lang === 'de' ? 'Tabellen-Refs (kommagetrennt):' : 'Table refs (comma-separated):'}
              </label>
              <input
                type="text"
                className={styles.simRefInput}
                placeholder="0:1, 2:1, 7:1..."
                value={simTableRef}
                onChange={e => setSimTableRef(e.target.value)}
              />
              <button
                type="button"
                className={styles.uploadBtn}
                onClick={handleSimSearch}
                disabled={simRunning || (!simQuery.trim() && !simTableRef.trim())}
              >
                {simRunning
                  ? (lang === 'de' ? '⟳ Suche...' : '⟳ Searching...')
                  : (lang === 'de' ? 'Suche starten' : 'Run search')}
              </button>
            </div>

            {simResults.length > 0 && (
              <div className={styles.simResultList}>
                <div className={styles.simResultHeader}>
                  {simResults.length} {lang === 'de' ? 'Ergebnisse' : 'results'}
                </div>
                {simResults.map((r, i) => (
                  <div key={r.chunk.id} className={`${styles.simResultItem} ${i < 3 ? styles.simResultTop : ''}`}>
                    <div className={styles.simResultTitle}>
                      <span className={styles.simResultRank}>#{i + 1}</span>
                      <strong>{r.chunk.heading || '(kein Titel)'}</strong>
                      <span className={styles.simResultScore}>Score: {r.score.toFixed(1)}</span>
                      {i < 3 && <span className={styles.simResultBadge}>TOP 3</span>}
                    </div>
                    <div className={styles.simResultMeta}>
                      <span>Matched: {r.matchedTerms.join(', ')}</span>
                    </div>
                    {r.chunk.keywords && r.chunk.keywords.length > 0 && (
                      <div className={styles.simResultMeta}>
                        Keywords: {r.chunk.keywords.join(', ')}
                      </div>
                    )}
                    <div className={styles.simResultText}>
                      {r.chunk.text.slice(0, 200)}{r.chunk.text.length > 200 ? '...' : ''}
                    </div>
                  </div>
                ))}
              </div>
            )}

            {simResults.length === 0 && !simRunning && simQuery.trim() && (
              <p className={styles.empty}>
                {lang === 'de' ? 'Keine Treffer gefunden.' : 'No matches found.'}
              </p>
            )}
          </div>
        ) : !selectedDoc ? (
          <p className={styles.empty}>
            {lang === 'de' ? 'Ordner auswählen um Feld-Hilfen zu sehen' : 'Select a folder to view field help entries'}
          </p>
        ) : (
          <>
            <div className={styles.chunkHeader}>
              <span className={styles.chunkTitle}>{selectedDoc.fileName}</span>
              <span className={styles.chunkMeta}>
                {filteredChunks.length}{searchFilter ? `/${chunks.length}` : ''} {lang === 'de' ? 'Hilfe-Einträge' : 'help entries'}
                {' · '}{(selectedDoc.totalChars / 1000).toFixed(0)}k {lang === 'de' ? 'Zeichen' : 'chars'}
              </span>
              <input
                type="text"
                className={styles.searchInput}
                placeholder={lang === 'de' ? 'Suchen (Keyword, Feldname...)' : 'Search (keyword, field name...)'}
                value={searchFilter}
                onChange={e => setSearchFilter(e.target.value)}
              />
            </div>
            <div className={styles.chunkList}>
              {filteredChunks.map(chunk => {
                const isExpanded = expandedChunks.has(chunk.id);
                const isShowHtml = showHtml.has(chunk.id);
                return (
                  <div key={chunk.id} className={styles.chunkItem}>
                    <div className={styles.chunkItemHeader} onClick={() => toggleExpanded(chunk.id)}>
                      <span className={styles.chunkToggle}>{isExpanded ? '▾' : '▸'}</span>
                      {chunk.anchorName && <span className={styles.chunkAnchor}>{chunk.anchorName}</span>}
                      <span className={styles.chunkHeading}>{chunk.heading || `(${lang === 'de' ? 'Abschnitt' : 'Section'} ${chunk.index + 1})`}</span>
                      <span className={styles.chunkChars}>{chunk.charCount}</span>
                      {chunk.sourceFile && <span className={styles.chunkSource}>{chunk.sourceFile}</span>}
                      {chunk.note && <span className={styles.chunkNoteIcon}>📝</span>}
                      {chunk.rating === 1 && <span className={styles.ratingGood}>👍</span>}
                      {chunk.rating === -1 && <span className={styles.ratingBad}>👎</span>}
                    </div>

                    {isExpanded && (
                      <div className={styles.chunkBody}>
                        {/* Keywords */}
                        {chunk.keywords && chunk.keywords.length > 0 && (
                          <div className={styles.keywordBar}>
                            <span className={styles.keywordLabel}>{lang === 'de' ? 'Keywords:' : 'Keywords:'}</span>
                            {chunk.keywords.map((kw, i) => (
                              <span key={i} className={styles.keywordTag}>{kw}</span>
                            ))}
                          </div>
                        )}

                        {/* Hierarchy breadcrumb */}
                        {chunk.headingHierarchy.length > 0 && (
                          <div className={styles.chunkBreadcrumb}>
                            {chunk.headingHierarchy.join(' › ')}
                          </div>
                        )}

                        {/* Content: plain text or HTML toggle */}
                        <div className={styles.contentToggle}>
                          <button
                            type="button"
                            className={!isShowHtml ? styles.toggleBtnActive : styles.toggleBtn}
                            onClick={() => { if (isShowHtml) toggleHtml(chunk.id); }}
                          >Text</button>
                          {chunk.htmlContent && (
                            <button
                              type="button"
                              className={isShowHtml ? styles.toggleBtnActive : styles.toggleBtn}
                              onClick={() => { if (!isShowHtml) toggleHtml(chunk.id); }}
                            >HTML</button>
                          )}
                        </div>

                        {isShowHtml && chunk.htmlContent ? (
                          <div
                            className={styles.chunkHtml}
                            dangerouslySetInnerHTML={{ __html: chunk.htmlContent }}
                          />
                        ) : (
                          <pre className={styles.chunkText}>{chunk.text}</pre>
                        )}

                        {/* Actions: Rating + Note + Keywords */}
                        <div className={styles.chunkActions}>
                          <button
                            type="button"
                            className={chunk.rating === 1 ? styles.ratingBtnActive : styles.ratingBtn}
                            onClick={() => handleRate(chunk, 1)}
                            title={lang === 'de' ? 'Hilfreich' : 'Helpful'}
                          >👍</button>
                          <button
                            type="button"
                            className={chunk.rating === -1 ? styles.ratingBtnActive : styles.ratingBtn}
                            onClick={() => handleRate(chunk, -1)}
                            title={lang === 'de' ? 'Nicht hilfreich' : 'Not helpful'}
                          >👎</button>
                          <button
                            type="button"
                            className={styles.noteBtn}
                            onClick={() => { setEditingNote(chunk.id); setNoteText(chunk.note ?? ''); }}
                          >
                            📝 {lang === 'de' ? 'Notiz' : 'Note'}
                          </button>
                          <button
                            type="button"
                            className={styles.noteBtn}
                            onClick={() => {
                              setEditingKeywords(chunk.id);
                              setKeywordsText(chunk.keywords?.join(', ') ?? '');
                            }}
                          >
                            🏷️ Keywords
                          </button>
                        </div>

                        {/* Note editor */}
                        {editingNote === chunk.id && (
                          <div className={styles.noteEditor}>
                            <textarea
                              className={styles.noteTextarea}
                              value={noteText}
                              onChange={e => setNoteText(e.target.value)}
                              placeholder={lang === 'de' ? 'Notiz zum Abschnitt...' : 'Note for this section...'}
                              rows={3}
                            />
                            <div className={styles.noteActions}>
                              <button type="button" className={styles.noteSaveBtn} onClick={() => handleSaveNote(chunk)}>
                                {lang === 'de' ? 'Speichern' : 'Save'}
                              </button>
                              <button type="button" className={styles.noteCancelBtn} onClick={() => setEditingNote(null)}>
                                {lang === 'de' ? 'Abbrechen' : 'Cancel'}
                              </button>
                            </div>
                          </div>
                        )}

                        {/* Keywords editor */}
                        {editingKeywords === chunk.id && (
                          <div className={styles.noteEditor}>
                            <label className={styles.editorLabel}>
                              {lang === 'de' ? 'Keywords (kommagetrennt):' : 'Keywords (comma-separated):'}
                            </label>
                            <input
                              type="text"
                              className={styles.keywordInput}
                              value={keywordsText}
                              onChange={e => setKeywordsText(e.target.value)}
                              placeholder="KUNDE, Warenempfänger, Rechnungsempfänger..."
                            />
                            <div className={styles.noteActions}>
                              <button type="button" className={styles.noteSaveBtn} onClick={() => handleSaveKeywords(chunk)}>
                                {lang === 'de' ? 'Speichern' : 'Save'}
                              </button>
                              <button type="button" className={styles.noteCancelBtn} onClick={() => setEditingKeywords(null)}>
                                {lang === 'de' ? 'Abbrechen' : 'Cancel'}
                              </button>
                            </div>
                          </div>
                        )}

                        {/* Display saved note */}
                        {chunk.note && editingNote !== chunk.id && (
                          <div className={styles.noteDisplay}>
                            📝 {chunk.note}
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          </>
        )}
      </div>
    </div>
  );
}
