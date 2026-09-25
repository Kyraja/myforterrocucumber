/**
 * @module CsvUpload
 * Upload toolbar that imports abas ERP reference data into the app. Accepts
 * variable-table exports (CSV/XLSX/text dump) for databases and infosystems,
 * and a FOP.txt event-binding configuration file – each via file picker or
 * paste-in textarea. Parsed results are merged into existing table definitions
 * and passed up via `onTablesChange`, `onFopBindingsChange`, and
 * `onIsBindingsChange`. Shows a live preview of how many tables/fields/bindings
 * would be added before the user confirms.
 */
import { useRef, useState, useCallback } from 'react';
import type { TableDef } from '../../types/gherkin';
import type { FopBinding } from '../../types/fop';
import { parseTableCsv, parseTextDump, parseXlsx, mergeTableDefs } from '../../lib/csvTableParser';
import { parseFopTxt } from '../../lib/fopTxtParser';
import { parseIsExportBindings, parseIsExportBindingsFromXlsx, type IsBinding } from '../../lib/isBindingsParser';
import { useTranslation } from '../../i18n';
import { IconUpload, IconInfo, IconClipboard, IconClose } from '../icons';
import styles from './CsvUpload.module.css';

/**
 * Reads a text file and decides the encoding automatically:
 *   1. UTF-8 BOM present → strip and decode as UTF-8
 *   2. Strict UTF-8 decode succeeds → use UTF-8 (covers modern abas exports)
 *   3. Otherwise → fall back to Windows-1252 (legacy abas exports)
 */
async function readFileSmart(file: File): Promise<string> {
  const buffer = await file.arrayBuffer();
  const bytes = new Uint8Array(buffer);
  if (bytes.length >= 3 && bytes[0] === 0xEF && bytes[1] === 0xBB && bytes[2] === 0xBF) {
    return new TextDecoder('utf-8').decode(bytes.subarray(3));
  }
  try {
    return new TextDecoder('utf-8', { fatal: true }).decode(bytes);
  } catch {
    return new TextDecoder('windows-1252').decode(bytes);
  }
}

const ABAS_QUERY_DB = '<(Company)> %,0:vmnr1==;0:nummer=;0:such=;0:name1=;1:vbed=;1:vitefff=;1:vms==;1:vname=;1:vnname=;1:vskip==;1:vkt==;@gruppe=26;@ablageart=(Active);@zeilen=(Yes) <(View)>';
const ABAS_QUERY_IS = '<(Infosystem)> %,0:nummer=;0:such=;0:name1=;1:vbed=;1:vitefff=;1:vms==;1:vname=;1:vkt==;0:zwechsel=;0:zreinvo=;0:zreinna=;0:zrausvo=;0:zrausna=;0:zmark=;0:zbewvo=;0:zbewpruef=;0:zbewna=;0:maskabbr=;0:maskaus=;0:maskein=;0:maskende=;0:maskennr=;0:maskpruef=;0:bfuss=;1:buttonnach=;1:buttonvor=;1:feldaus=;1:feldfuell=;1:feldpruef=;@gruppe=1;@filingmode=(Active);@rows=(Yes) <(View)>';

interface CsvUploadProps {
  tables: TableDef[];
  onTablesChange: (tables: TableDef[]) => void;
  /** Currently loaded FOP bindings (from FOP.txt) */
  fopBindings?: FopBinding[];
  /** Called when FOP.txt is uploaded or pasted */
  onFopBindingsChange?: (bindings: FopBinding[]) => void;
  /** Currently loaded IS bindings (from Infosystem export) */
  isBindings?: IsBinding[];
  /** Called when IS bindings are extracted from IS upload/paste */
  onIsBindingsChange?: (bindings: IsBinding[]) => void;
}

export function CsvUpload({ tables, onTablesChange, fopBindings, onFopBindingsChange, isBindings, onIsBindingsChange }: CsvUploadProps) {
  const { t } = useTranslation();
  const dbInputRef = useRef<HTMLInputElement>(null);
  const isInputRef = useRef<HTMLInputElement>(null);
  const fopTxtInputRef = useRef<HTMLInputElement>(null);
  const [loading, setLoading] = useState(false);
  const [pasteOpen, setPasteOpen] = useState(false);
  const [helpOpen, setHelpOpen] = useState(false);
  const [dbText, setDbText] = useState('');
  const [isText, setIsText] = useState('');
  const [fopTxtText, setFopTxtText] = useState('');

  const handleFile = async (file: File) => {
    const isXlsx = file.name.endsWith('.xlsx') || file.name.endsWith('.xls');
    setLoading(true);
    try {
      if (isXlsx) {
        const buffer = await file.arrayBuffer();
        const parsed = parseXlsx(buffer);
        if (parsed.length > 0) {
          onTablesChange(mergeTableDefs(tables, parsed));
        }
      } else {
        const csv = await readFileSmart(file);
        const parsed = parseTableCsv(csv);
        if (parsed.length > 0) {
          onTablesChange(mergeTableDefs(tables, parsed));
        }
      }
    } finally {
      setLoading(false);
    }
  };

  const handleFopTxtFile = async (file: File) => {
    setLoading(true);
    try {
      const text = await readFileSmart(file);
      const bindings = parseFopTxt(text);
      onFopBindingsChange?.(bindings);
      setFopTxtText(text);
    } finally {
      setLoading(false);
    }
  };

  const handleDbChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) handleFile(file);
    e.target.value = '';
  };

  const handleIsChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    e.target.value = '';
    if (!file) return;
    // Parse IS tables AND extract IS EFOP bindings from the same file
    const isXlsx = file.name.endsWith('.xlsx') || file.name.endsWith('.xls');
    setLoading(true);
    try {
      if (isXlsx) {
        const buffer = await file.arrayBuffer();
        const parsed = parseXlsx(buffer);
        if (parsed.length > 0) onTablesChange(mergeTableDefs(tables, parsed));
        const isBindingsExtracted = parseIsExportBindingsFromXlsx(buffer);
        if (isBindingsExtracted.length > 0) onIsBindingsChange?.(isBindingsExtracted);
      } else {
        const text = await readFileSmart(file);
        const parsed = parseTableCsv(text);
        if (parsed.length > 0) onTablesChange(mergeTableDefs(tables, parsed));
        const isBindingsExtracted = parseIsExportBindings(text);
        if (isBindingsExtracted.length > 0) onIsBindingsChange?.(isBindingsExtracted);
      }
    } finally {
      setLoading(false);
    }
  };

  const handleFopTxtChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) handleFopTxtFile(file);
    e.target.value = '';
  };

  const handleClear = () => {
    onTablesChange([]);
    onFopBindingsChange?.([]);
    onIsBindingsChange?.([]);
    setDbText('');
    setIsText('');
    setFopTxtText('');
  };

  const handleApplyText = useCallback(() => {
    // Apply variable tables (DB + IS)
    const dbTables = dbText.trim() ? parseTextDump(dbText) : [];
    const isTables = isText.trim() ? parseTextDump(isText) : [];
    const parsed = mergeTableDefs(dbTables, isTables);
    if (parsed.length > 0) {
      const merged = mergeTableDefs(tables, parsed);
      onTablesChange(merged);
    }
    // Apply FOP.txt
    if (fopTxtText.trim()) {
      const bindings = parseFopTxt(fopTxtText);
      onFopBindingsChange?.(bindings);
    }
    // Extract IS bindings from IS text (same paste area)
    if (isText.trim()) {
      const isBindingsExtracted = parseIsExportBindings(isText);
      if (isBindingsExtracted.length > 0) onIsBindingsChange?.(isBindingsExtracted);
    }
    setPasteOpen(false);
  }, [dbText, isText, fopTxtText, tables, onTablesChange, onFopBindingsChange]);

  const bindingsCount = fopBindings?.length ?? 0;
  const isBindingsCount = isBindings?.length ?? 0;

  // Preview what the paste would produce
  const previewDbTables = dbText.trim() ? parseTextDump(dbText) : [];
  const previewIsTables = isText.trim() ? parseTextDump(isText) : [];
  const previewAll = mergeTableDefs(previewDbTables, previewIsTables);
  const previewFieldCount = previewAll.reduce((sum, t) => sum + t.fields.length, 0);
  const previewBindings = fopTxtText.trim() ? parseFopTxt(fopTxtText) : [];

  const fopTxtLabel = t('csv.uploadFopTxt');
  const fopTxtPasteLabel = 'FOP.txt';
  const fopTxtPlaceholder = t('csv.pasteFopPlaceholder');

  return (
    <div className={styles.container}>
      <input
        ref={dbInputRef}
        type="file"
        accept=".txt,.csv,.xlsx,.xls,*"
        onChange={handleDbChange}
        className={styles.hidden}
      />
      <input
        ref={isInputRef}
        type="file"
        accept=".txt,.csv,.xlsx,.xls,*"
        onChange={handleIsChange}
        className={styles.hidden}
      />
      <input
        ref={fopTxtInputRef}
        type="file"
        accept=".txt"
        onChange={handleFopTxtChange}
        className={styles.hidden}
      />
      <div className={styles.row}>
        <button
          className={helpOpen ? styles.pasteToggleActive : styles.pasteToggle}
          onClick={() => setHelpOpen((p) => !p)}
          type="button"
          title={t('csv.exportHelpTitle')}
        >
          <IconInfo />
        </button>
        <button
          className={styles.uploadBtn}
          onClick={() => dbInputRef.current?.click()}
          disabled={loading}
          type="button"
        >
          <IconUpload />{loading ? t('csv.loading') : t('csv.uploadDb')}
        </button>
        <button
          className={styles.uploadBtn}
          onClick={() => isInputRef.current?.click()}
          disabled={loading}
          type="button"
        >
          <IconUpload />{loading ? t('csv.loading') : t('csv.uploadIs')}
        </button>
        <button
          className={styles.uploadBtn}
          onClick={() => fopTxtInputRef.current?.click()}
          disabled={loading}
          type="button"
          title={t('csv.uploadFopEventConfig')}
        >
          <IconUpload />{fopTxtLabel}
        </button>
        <button
          className={pasteOpen ? styles.pasteToggleActive : styles.pasteToggle}
          onClick={() => setPasteOpen((p) => !p)}
          type="button"
        >
          <IconClipboard />{t('csv.pasteText')}
        </button>
        <span style={{ flex: 1 }} />
        {(tables.length > 0 || bindingsCount > 0 || isBindingsCount > 0) && (
          <button
            className={styles.clearBtn}
            onClick={handleClear}
            type="button"
            title={t('csv.clearAllData')}
          >
            <IconClose />{t('csv.clear')}
          </button>
        )}
      </div>

      {loading && (
        <div className={styles.loadingBar}>
          <div className={styles.loadingBarInner} />
        </div>
      )}

      {pasteOpen && (
        <div className={styles.pasteSection}>
          <div className={styles.pasteGroup}>
            <label className={styles.pasteLabel}>{t('csv.variablentabelle')}</label>
            <textarea
              className={styles.pasteArea}
              value={dbText}
              onChange={(e) => setDbText(e.target.value)}
              placeholder={t('csv.pasteDbPlaceholder')}
              rows={4}
            />
          </div>
          <div className={styles.pasteGroup}>
            <label className={styles.pasteLabel}>{t('csv.infosystem')}</label>
            <textarea
              className={styles.pasteArea}
              value={isText}
              onChange={(e) => setIsText(e.target.value)}
              placeholder={t('csv.pasteIsPlaceholder')}
              rows={4}
            />
          </div>
          <div className={styles.pasteGroup}>
            <label className={styles.pasteLabel}>{fopTxtPasteLabel}</label>
            <textarea
              className={styles.pasteArea}
              value={fopTxtText}
              onChange={(e) => setFopTxtText(e.target.value)}
              placeholder={fopTxtPlaceholder}
              rows={4}
            />
          </div>
          <div className={styles.pasteFooter}>
            <button
              className={styles.applyBtn}
              onClick={handleApplyText}
              disabled={!dbText.trim() && !isText.trim() && !fopTxtText.trim()}
              type="button"
            >
              {t('csv.apply')}
            </button>
            {(previewAll.length > 0 || previewBindings.length > 0) && (
              <span className={styles.previewInfo}>
                {previewAll.length > 0 && t('csv.parsedInfo', { tables: previewAll.length, fields: previewFieldCount })}
                {previewAll.length > 0 && previewBindings.length > 0 && ' · '}
                {previewBindings.length > 0 && t('csv.bindingsCount', { count: previewBindings.length })}
              </span>
            )}
          </div>
        </div>
      )}

      {helpOpen && (
        <div className={styles.helpSection}>
          <div className={styles.helpNote}>{t('csv.exportNote')}</div>
          <div className={styles.helpGroup}>
            <span className={styles.helpLabel}>{t('csv.variablentabelle')}</span>
            <code className={styles.helpQuery}>{ABAS_QUERY_DB}</code>
          </div>
          <div className={styles.helpGroup}>
            <span className={styles.helpLabel}>{t('csv.infosystem')}</span>
            <code className={styles.helpQuery}>{ABAS_QUERY_IS}</code>
          </div>
          <div className={styles.helpNote} style={{ marginTop: '8px' }}>
            {t('csv.fopHelpNote')}
          </div>
        </div>
      )}
    </div>
  );
}
