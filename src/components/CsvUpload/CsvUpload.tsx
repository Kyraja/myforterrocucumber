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
import { parseTableCsv, parseTextDump, parseXlsx, mergeTableDefs, tablesNeedReimport } from '../../lib/csvTableParser';
import { parseFopTxt, parseIsExportBindings, type IsBinding } from '../../lib/fopTxtParser';
import { useTranslation } from '../../i18n';
import styles from './CsvUpload.module.css';

const ABAS_QUERY_DB = '<(Company)> %,0:vmnr1==;0:nummer=;0:such=;0:name1=;0:name2=;1:vbed=;1:vbeds=;1:vitefff=;1:vms==;1:vname=;1:vnname=;1:vskip==;@gruppe=26;@ablageart=(Active);@zeilen=(Yes) <(View)>';
const ABAS_QUERY_IS = '<(Infosystem)> %,0:nummer=;0:such=;0:name1=;0:name2=;1:vbed=;1:vbeds=;1:vitefff=;1:vms==;1:vname=;0:zwechsel=;0:zreinvo=;0:zreinna=;0:zrausvo=;0:zrausna=;0:zmark=;0:zbewvo=;0:zbewpruef=;0:zbewna=;0:maskabbr=;0:maskaus=;0:maskein=;0:maskende=;0:maskennr=;0:maskpruef=;0:bfuss=;1:buttonnach=;1:buttonvor=;1:feldaus=;1:feldfuell=;1:feldpruef=;@gruppe=1;@filingmode=(Active);@rows=(Yes) <(View)>';

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
  const { t, lang } = useTranslation();
  const dbInputRef = useRef<HTMLInputElement>(null);
  const isInputRef = useRef<HTMLInputElement>(null);
  const fopTxtInputRef = useRef<HTMLInputElement>(null);
  const [loading, setLoading] = useState(false);
  const [pasteOpen, setPasteOpen] = useState(false);
  const [helpOpen, setHelpOpen] = useState(false);
  const [dbText, setDbText] = useState('');
  const [isText, setIsText] = useState('');
  const [fopTxtText, setFopTxtText] = useState('');

  const handleFile = (file: File) => {
    const isXlsx = file.name.endsWith('.xlsx') || file.name.endsWith('.xls');
    setLoading(true);

    if (isXlsx) {
      const reader = new FileReader();
      reader.onload = (e) => {
        const buffer = e.target?.result as ArrayBuffer;
        const parsed = parseXlsx(buffer);
        if (parsed.length > 0) {
          onTablesChange(mergeTableDefs(tables, parsed));
        }
        setLoading(false);
      };
      reader.readAsArrayBuffer(file);
    } else {
      const reader = new FileReader();
      reader.onload = (e) => {
        const csv = e.target?.result as string;
        const parsed = parseTableCsv(csv);
        if (parsed.length > 0) {
          onTablesChange(mergeTableDefs(tables, parsed));
        }
        setLoading(false);
      };
      reader.readAsText(file, 'windows-1252');
    }
  };

  const handleFopTxtFile = (file: File) => {
    setLoading(true);
    const reader = new FileReader();
    reader.onload = (e) => {
      const text = e.target?.result as string;
      const bindings = parseFopTxt(text);
      onFopBindingsChange?.(bindings);
      setFopTxtText(text);
      setLoading(false);
    };
    reader.readAsText(file, 'windows-1252');
  };

  const handleDbChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) handleFile(file);
    e.target.value = '';
  };

  const handleIsChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) { e.target.value = ''; return; }
    // Parse IS tables AND extract IS EFOP bindings from the same file
    const isXlsx = file.name.endsWith('.xlsx') || file.name.endsWith('.xls');
    if (isXlsx) {
      handleFile(file);
    } else {
      setLoading(true);
      const reader = new FileReader();
      reader.onload = (ev) => {
        const text = ev.target?.result as string;
        const parsed = parseTableCsv(text);
        if (parsed.length > 0) onTablesChange(mergeTableDefs(tables, parsed));
        const isBindingsExtracted = parseIsExportBindings(text);
        if (isBindingsExtracted.length > 0) onIsBindingsChange?.(isBindingsExtracted);
        setLoading(false);
      };
      reader.readAsText(file, 'windows-1252');
    }
    e.target.value = '';
  };

  const handleFopTxtChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) handleFopTxtFile(file);
    e.target.value = '';
  };

  const handleClear = () => {
    onTablesChange([]);
    onFopBindingsChange?.([]);
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

  const fieldCount = tables.reduce((sum, t) => sum + t.fields.length, 0);
  const bindingsCount = fopBindings?.length ?? 0;
  const isBindingsCount = isBindings?.length ?? 0;

  // Preview what the paste would produce
  const previewDbTables = dbText.trim() ? parseTextDump(dbText) : [];
  const previewIsTables = isText.trim() ? parseTextDump(isText) : [];
  const previewAll = mergeTableDefs(previewDbTables, previewIsTables);
  const previewFieldCount = previewAll.reduce((sum, t) => sum + t.fields.length, 0);
  const previewBindings = fopTxtText.trim() ? parseFopTxt(fopTxtText) : [];

  const fopTxtLabel = lang === 'de' ? 'FOP.txt hochladen' : 'Upload FOP.txt';
  const fopTxtPasteLabel = 'FOP.txt';
  const fopTxtPlaceholder = lang === 'de'
    ? 'Inhalt von FOP.txt hier einfügen...'
    : 'Paste FOP.txt content here...';

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
          ⓘ
        </button>
        <button
          className={styles.uploadBtn}
          onClick={() => dbInputRef.current?.click()}
          disabled={loading}
          type="button"
        >
          {loading ? t('csv.loading') : t('csv.uploadDb')}
        </button>
        <button
          className={styles.uploadBtn}
          onClick={() => isInputRef.current?.click()}
          disabled={loading}
          type="button"
        >
          {loading ? t('csv.loading') : t('csv.uploadIs')}
        </button>
        <button
          className={styles.uploadBtn}
          onClick={() => fopTxtInputRef.current?.click()}
          disabled={loading}
          type="button"
          title={lang === 'de' ? 'FOP.txt Ereigniskonfiguration hochladen' : 'Upload FOP.txt event configuration'}
        >
          {fopTxtLabel}
        </button>
        <button
          className={pasteOpen ? styles.pasteToggleActive : styles.pasteToggle}
          onClick={() => setPasteOpen((p) => !p)}
          type="button"
        >
          {t('csv.pasteText')}
        </button>
        {tablesNeedReimport(tables) && (
          <span className={styles.reimportHint} title={t('csv.reimportHint')}>
            ⓘ
          </span>
        )}
        <span style={{ flex: 1 }} />
        {(tables.length > 0 || bindingsCount > 0 || isBindingsCount > 0) && (
          <button
            className={styles.clearBtn}
            onClick={handleClear}
            type="button"
            title={lang === 'de' ? 'Alle Stammdaten löschen' : 'Clear all data'}
          >
            {lang === 'de' ? 'Löschen' : 'Clear'}
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
                {previewBindings.length > 0 && (lang === 'de'
                  ? `${previewBindings.length} Bindungen`
                  : `${previewBindings.length} bindings`)}
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
            {lang === 'de'
              ? 'FOP.txt: Eventbindungs-Konfigurationsdatei der abas flexiblen Oberfläche.'
              : 'FOP.txt: Event binding configuration file of the abas flexible surface.'}
          </div>
        </div>
      )}
    </div>
  );
}
