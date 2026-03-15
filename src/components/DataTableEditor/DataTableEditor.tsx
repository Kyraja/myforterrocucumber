import { useId } from 'react';
import type { Language } from '../../i18n';
import { useTranslation } from '../../i18n';
import styles from './DataTableEditor.module.css';

function fieldDesc(f: { name: string; description: string; descriptionDe?: string; descriptionEn?: string }, lang: Language): string {
  if (lang === 'de' && f.descriptionDe) return f.descriptionDe;
  if (lang === 'en' && f.descriptionEn) return f.descriptionEn;
  return f.description;
}

interface DataTableEditorProps {
  table: string[][];
  onChange: (table: string[][]) => void;
  /** Optional column headers displayed above the table */
  columnHeaders?: string[];
  /** When true, hide add/remove column buttons (fixed number of columns) */
  fixedColumns?: boolean;
  /** Field suggestions for autocomplete (applied to first column by default, or first row when fieldSuggestionsMode='row') */
  fields?: { name: string; description: string }[];
  /** 'column' = suggestions on first column (default), 'row' = suggestions on first row (header row) */
  fieldSuggestionsMode?: 'column' | 'row';
}

export function DataTableEditor({ table, onChange, columnHeaders, fixedColumns, fields, fieldSuggestionsMode = 'column' }: DataTableEditorProps) {
  const { t, lang } = useTranslation();
  const listId = useId();

  const updateCell = (rowIdx: number, colIdx: number, value: string) => {
    const newTable = table.map((row, r) =>
      r === rowIdx ? row.map((cell, c) => (c === colIdx ? value : cell)) : [...row],
    );
    onChange(newTable);
  };

  const addRow = () => {
    const colCount = table.length > 0 ? table[0].length : 2;
    onChange([...table, Array(colCount).fill('')]);
  };

  const removeRow = (rowIdx: number) => {
    if (table.length <= 1) return;
    onChange(table.filter((_, i) => i !== rowIdx));
  };

  const addColumn = () => {
    onChange(table.map((row) => [...row, '']));
  };

  const removeColumn = () => {
    if (table.length > 0 && table[0].length <= 1) return;
    onChange(table.map((row) => row.slice(0, -1)));
  };

  return (
    <div className={styles.wrapper}>
      <table className={styles.table}>
        {columnHeaders && (
          <thead>
            <tr>
              {columnHeaders.map((h, i) => (
                <th key={i} className={styles.headerCell}>{h}</th>
              ))}
              <th className={styles.rowActions} />
            </tr>
          </thead>
        )}
        <tbody>
          {table.map((row, r) => (
            <tr key={r}>
              {row.map((cell, c) => (
                <td key={c} className={styles.cell}>
                  <input
                    className={fieldSuggestionsMode === 'row' && r === 0 ? styles.cellInputHeader : styles.cellInput}
                    type="text"
                    value={cell}
                    onChange={(e) => updateCell(r, c, e.target.value)}
                    placeholder={fieldSuggestionsMode === 'row' && r === 0 ? t('dataTable.fieldPlaceholder') : t('dataTable.cellPlaceholder')}
                    list={fields && (fieldSuggestionsMode === 'column' ? c === 0 : r === 0) ? listId : undefined}
                  />
                </td>
              ))}
              <td className={styles.rowActions}>
                <button
                  className={styles.removeBtn}
                  onClick={() => removeRow(r)}
                  type="button"
                  title={t('dataTable.removeRow')}
                  disabled={table.length <= 1}
                >
                  &times;
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {fields && fields.length > 0 && (
        <datalist id={listId}>
          {fields.map((f) => (
            <option key={f.name} value={f.name}>{fieldDesc(f, lang)}</option>
          ))}
        </datalist>
      )}
      <div className={styles.actions}>
        <button className={styles.addBtn} onClick={addRow} type="button">
          {t('dataTable.addRow')}
        </button>
        {!fixedColumns && (
          <>
            <button className={styles.addBtn} onClick={addColumn} type="button">
              {t('dataTable.addColumn')}
            </button>
            {table.length > 0 && table[0].length > 1 && (
              <button className={styles.addBtn} onClick={removeColumn} type="button">
                {t('dataTable.removeColumn')}
              </button>
            )}
          </>
        )}
      </div>
    </div>
  );
}
