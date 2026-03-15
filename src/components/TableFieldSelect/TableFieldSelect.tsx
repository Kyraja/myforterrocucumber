import { useState, useRef, useEffect, useMemo } from 'react';
import type { TableDef, FieldDef } from '../../types/gherkin';
import type { Language } from '../../i18n';
import { useTranslation } from '../../i18n';
import styles from './TableFieldSelect.module.css';

/** Resolve localized table name based on current language */
function tableName(tbl: TableDef, lang: Language): string {
  if (lang === 'de' && tbl.nameDe) return tbl.nameDe;
  if (lang === 'en' && tbl.nameEn) return tbl.nameEn;
  return tbl.name;
}

/** Resolve localized field description based on current language */
function fieldDesc(f: FieldDef, lang: Language): string {
  if (lang === 'de' && f.descriptionDe) return f.descriptionDe;
  if (lang === 'en' && f.descriptionEn) return f.descriptionEn;
  return f.description;
}

// ── Table Select ──────────────────────────────────────────────

interface TableSelectProps {
  tables: TableDef[];
  onSelect: (table: TableDef) => void;
  placeholder?: string;
}

export function TableSelect({ tables, onSelect, placeholder }: TableSelectProps) {
  const { t, lang } = useTranslation();
  const [query, setQuery] = useState('');
  const [open, setOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  const filtered = useMemo(() => {
    if (!query.trim()) return tables.slice(0, 100);
    const q = query.toLowerCase();
    return tables
      .filter(
        (tbl) =>
          tbl.tableRef.includes(q) ||
          tableName(tbl, lang).toLowerCase().includes(q) ||
          tbl.database.includes(q),
      )
      .slice(0, 100);
  }, [query, tables, lang]);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  if (tables.length === 0) return null;

  return (
    <div className={styles.container} ref={containerRef}>
      <input
        className={styles.input}
        type="text"
        value={query}
        onChange={(e) => { setQuery(e.target.value); setOpen(true); }}
        onFocus={() => setOpen(true)}
        placeholder={placeholder ?? t('tableField.searchTable')}
      />
      {open && (
        <ul className={styles.dropdown}>
          {filtered.length === 0 ? (
            <li className={styles.empty}>{t('tableField.noResults')}</li>
          ) : (
            filtered.map((tbl) => (
              <li
                key={tbl.tableRef}
                className={styles.option}
                onClick={() => { onSelect(tbl); setQuery(''); setOpen(false); }}
              >
                <span className={styles.optionRef}>{tbl.tableRef}</span>
                <span className={styles.optionName}>{tableName(tbl, lang)}</span>
                <span className={styles.optionCount}>{t('tableField.fields', { count: tbl.fields.length })}</span>
              </li>
            ))
          )}
        </ul>
      )}
    </div>
  );
}

// ── Field Select (standalone search) ─────────────────────────

interface FieldSelectProps {
  fields: FieldDef[];
  onSelect: (field: FieldDef) => void;
  placeholder?: string;
}

export function FieldSelect({ fields, onSelect, placeholder }: FieldSelectProps) {
  const { t, lang } = useTranslation();
  const [query, setQuery] = useState('');
  const [open, setOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  const filtered = useMemo(() => {
    if (!query.trim()) return fields.slice(0, 100);
    const q = query.toLowerCase();
    return fields
      .filter(
        (f) =>
          f.name.toLowerCase().includes(q) ||
          fieldDesc(f, lang).toLowerCase().includes(q),
      )
      .slice(0, 100);
  }, [query, fields, lang]);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  if (fields.length === 0) return null;

  return (
    <div className={styles.container} ref={containerRef}>
      <input
        className={styles.input}
        type="text"
        value={query}
        onChange={(e) => { setQuery(e.target.value); setOpen(true); }}
        onFocus={() => setOpen(true)}
        placeholder={placeholder ?? t('tableField.searchField')}
      />
      {open && (
        <ul className={styles.dropdown}>
          {filtered.length === 0 ? (
            <li className={styles.empty}>{t('tableField.noResults')}</li>
          ) : (
            filtered.map((f) => (
              <li
                key={f.name}
                className={styles.option}
                onClick={() => { onSelect(f); setQuery(''); setOpen(false); }}
              >
                <span className={styles.optionRef}>{f.name}</span>
                <span className={styles.optionName}>{fieldDesc(f, lang)}</span>
              </li>
            ))
          )}
        </ul>
      )}
    </div>
  );
}

// ── Field Combobox (inline search in the field input) ────────

interface FieldComboboxProps {
  value: string;
  onChange: (value: string) => void;
  fields: FieldDef[];
  placeholder?: string;
  required?: boolean;
  className?: string;
}

export function FieldCombobox({ value, onChange, fields, placeholder, required = true, className }: FieldComboboxProps) {
  const { t, lang } = useTranslation();
  const [open, setOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  const filtered = useMemo(() => {
    if (!value.trim()) return fields.slice(0, 100);
    const q = value.toLowerCase();
    return fields
      .filter(
        (f) =>
          f.name.toLowerCase().includes(q) ||
          fieldDesc(f, lang).toLowerCase().includes(q),
      )
      .slice(0, 100);
  }, [value, fields, lang]);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const resolvedPlaceholder = placeholder ?? t('step.fieldName');
  const inputClass = className ?? styles.input;
  const requiredClass = required && !value.trim() ? styles.comboboxRequired : '';

  return (
    <div className={styles.combobox} ref={containerRef}>
      <input
        className={`${inputClass} ${requiredClass}`}
        type="text"
        value={value}
        onChange={(e) => { onChange(e.target.value); setOpen(true); }}
        onFocus={() => { if (fields.length > 0) setOpen(true); }}
        placeholder={resolvedPlaceholder}
      />
      {open && fields.length > 0 && (
        <ul className={styles.comboboxDropdown}>
          {filtered.length === 0 ? (
            <li className={styles.empty}>{t('tableField.noResults')}</li>
          ) : (
            filtered.map((f) => (
              <li
                key={f.name}
                className={styles.option}
                onClick={() => { onChange(f.name); setOpen(false); }}
              >
                <span className={styles.optionRef}>{f.name}</span>
                <span className={styles.optionName}>{fieldDesc(f, lang)}</span>
              </li>
            ))
          )}
        </ul>
      )}
    </div>
  );
}

// ── Table Combobox (inline search in the table input) ────────

interface TableComboboxProps {
  value: string;
  onChange: (value: string) => void;
  onSelect: (table: TableDef) => void;
  tables: TableDef[];
  placeholder?: string;
  required?: boolean;
  className?: string;
}

export function TableCombobox({ value, onChange, onSelect, tables, placeholder, required = true, className }: TableComboboxProps) {
  const { t, lang } = useTranslation();
  const [open, setOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  const filtered = useMemo(() => {
    if (!value.trim()) return tables.slice(0, 100);
    const q = value.toLowerCase();
    return tables
      .filter(
        (tbl) =>
          tbl.tableRef.includes(q) ||
          tableName(tbl, lang).toLowerCase().includes(q) ||
          tbl.database.includes(q),
      )
      .slice(0, 100);
  }, [value, tables, lang]);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const inputClass = className ?? styles.input;
  const requiredClass = required && !value.trim() ? styles.comboboxRequired : '';

  return (
    <div className={styles.combobox} ref={containerRef}>
      <input
        className={`${inputClass} ${requiredClass}`}
        type="text"
        value={value}
        onChange={(e) => { onChange(e.target.value); setOpen(true); }}
        onFocus={() => { if (tables.length > 0) setOpen(true); }}
        placeholder={placeholder}
      />
      {open && tables.length > 0 && (
        <ul className={styles.comboboxDropdown}>
          {filtered.length === 0 ? (
            <li className={styles.empty}>{t('tableField.noResults')}</li>
          ) : (
            filtered.map((tbl) => (
              <li
                key={tbl.tableRef}
                className={styles.option}
                onClick={() => { onSelect(tbl); setOpen(false); }}
              >
                <span className={styles.optionRef}>{tbl.tableRef}</span>
                <span className={styles.optionName}>{tableName(tbl, lang)}</span>
                <span className={styles.optionCount}>{t('tableField.fields', { count: tbl.fields.length })}</span>
              </li>
            ))
          )}
        </ul>
      )}
    </div>
  );
}
