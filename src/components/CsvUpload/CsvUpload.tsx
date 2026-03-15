import { useRef, useState, useCallback } from 'react';
import type { TableDef } from '../../types/gherkin';
import { parseTableCsv, parseTextDump, parseXlsx, mergeTableDefs, tablesNeedReimport } from '../../lib/csvTableParser';
import { useTranslation } from '../../i18n';
import styles from './CsvUpload.module.css';

const ABAS_QUERY_DB = '<(Company)> %,0:nummer=;0:such=;0:name1=;0:name2=;1:vbed=;1:vbeds=;1:vitefff=;1:vms==;1:vname=;1:vnname=;1:vskip==;@gruppe=26;@ablageart=(Active);@zeilen=(Yes) <(View)>';
const ABAS_QUERY_IS = '<(Infosystem)> %,0:nummer=;0:such=;0:name1=;0:name2=;1:vbed=;1:vbeds=;1:vitefff=;1:vms==;1:vname=;@gruppe=1;@filingmode=(Active);@rows=(Yes) <(View)>';

interface CsvUploadProps {
  tables: TableDef[];
  onTablesChange: (tables: TableDef[]) => void;
}

export function CsvUpload({ tables, onTablesChange }: CsvUploadProps) {
  const { t } = useTranslation();
  const dbInputRef = useRef<HTMLInputElement>(null);
  const isInputRef = useRef<HTMLInputElement>(null);
  const [loading, setLoading] = useState(false);
  const [pasteOpen, setPasteOpen] = useState(false);
  const [helpOpen, setHelpOpen] = useState(false);
  const [dbText, setDbText] = useState('');
  const [isText, setIsText] = useState('');

  const handleFile = (file: File) => {
    const isXlsx = file.name.endsWith('.xlsx') || file.name.endsWith('.xls');

    if (isXlsx) {
      setLoading(true);
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
      };
      reader.readAsText(file);
    }
  };

  const handleDbChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) handleFile(file);
    e.target.value = '';
  };

  const handleIsChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) handleFile(file);
    e.target.value = '';
  };

  const handleClear = () => {
    onTablesChange([]);
    setDbText('');
    setIsText('');
  };

  const handleApplyText = useCallback(() => {
    const dbTables = dbText.trim() ? parseTextDump(dbText) : [];
    const isTables = isText.trim() ? parseTextDump(isText) : [];
    const parsed = mergeTableDefs(dbTables, isTables);
    if (parsed.length > 0) {
      // Merge with existing tables (from file upload)
      const merged = mergeTableDefs(tables, parsed);
      onTablesChange(merged);
    }
    setPasteOpen(false);
  }, [dbText, isText, tables, onTablesChange]);

  const fieldCount = tables.reduce((sum, t) => sum + t.fields.length, 0);

  // Preview what the paste would produce
  const previewDbTables = dbText.trim() ? parseTextDump(dbText) : [];
  const previewIsTables = isText.trim() ? parseTextDump(isText) : [];
  const previewAll = mergeTableDefs(previewDbTables, previewIsTables);
  const previewFieldCount = previewAll.reduce((sum, t) => sum + t.fields.length, 0);

  return (
    <div className={styles.container}>
      <input
        ref={dbInputRef}
        type="file"
        accept=".csv,.txt,.xlsx,.xls"
        onChange={handleDbChange}
        className={styles.hidden}
      />
      <input
        ref={isInputRef}
        type="file"
        accept=".csv,.txt,.xlsx,.xls"
        onChange={handleIsChange}
        className={styles.hidden}
      />
      <div className={styles.row}>
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
          className={pasteOpen ? styles.pasteToggleActive : styles.pasteToggle}
          onClick={() => setPasteOpen((p) => !p)}
          type="button"
        >
          {t('csv.pasteText')}
        </button>
        <button
          className={helpOpen ? styles.pasteToggleActive : styles.pasteToggle}
          onClick={() => setHelpOpen((p) => !p)}
          type="button"
          title={t('csv.exportHelpTitle')}
        >
          ?
        </button>
        {tables.length > 0 && (
          <>
            <span className={styles.info}>
              {t('csv.tablesFields', { tables: tables.length, fields: fieldCount })}
            </span>
            {tablesNeedReimport(tables) && (
              <span className={styles.reimportHint} title={t('csv.reimportHint')}>
                ⓘ
              </span>
            )}
            <button
              className={styles.clearBtn}
              onClick={handleClear}
              type="button"
            >
              &times;
            </button>
          </>
        )}
      </div>

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
          <div className={styles.pasteFooter}>
            <button
              className={styles.applyBtn}
              onClick={handleApplyText}
              disabled={!dbText.trim() && !isText.trim()}
              type="button"
            >
              {t('csv.apply')}
            </button>
            {previewAll.length > 0 && (
              <span className={styles.previewInfo}>
                {t('csv.parsedInfo', { tables: previewAll.length, fields: previewFieldCount })}
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
        </div>
      )}
    </div>
  );
}
