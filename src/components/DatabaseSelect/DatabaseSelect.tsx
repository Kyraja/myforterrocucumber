import { useState, useRef, useEffect, useMemo } from 'react';
import type { AbasDatabase } from '../../types/gherkin';
import databases from '../../data/databases.json';
import { useTranslation } from '../../i18n';
import styles from './DatabaseSelect.module.css';

interface DatabaseSelectProps {
  value: AbasDatabase | null;
  onChange: (db: AbasDatabase | null) => void;
}

export function DatabaseSelect({ value, onChange }: DatabaseSelectProps) {
  const { t } = useTranslation();
  const [query, setQuery] = useState('');
  const [open, setOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  const filtered = useMemo(() => {
    if (!query.trim()) return (databases as AbasDatabase[]).slice(0, 50);
    const q = query.toLowerCase();
    return (databases as AbasDatabase[])
      .filter(
        (db) =>
          String(db.id).includes(q) ||
          db.sw.toLowerCase().includes(q) ||
          db.de.toLowerCase().includes(q) ||
          db.en.toLowerCase().includes(q),
      )
      .slice(0, 50);
  }, [query]);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleSelect = (db: AbasDatabase) => {
    onChange(db);
    setQuery('');
    setOpen(false);
  };

  const handleClear = () => {
    onChange(null);
    setQuery('');
    inputRef.current?.focus();
  };

  return (
    <div className={styles.container} ref={containerRef}>
      {value ? (
        <div className={styles.selected}>
          <span className={styles.selectedId}>{value.id}</span>
          <span className={styles.selectedName}>{value.de}</span>
          <button
            className={styles.clear}
            onClick={handleClear}
            type="button"
            aria-label={t('db.removeLabel')}
          >
            &times;
          </button>
        </div>
      ) : (
        <input
          ref={inputRef}
          className={styles.input}
          type="text"
          value={query}
          onChange={(e) => {
            setQuery(e.target.value);
            setOpen(true);
          }}
          onFocus={() => setOpen(true)}
          placeholder={t('db.searchPlaceholder')}
          aria-label={t('db.searchLabel')}
        />
      )}

      {open && !value && (
        <ul className={styles.dropdown} role="listbox">
          {filtered.length === 0 ? (
            <li className={styles.empty}>{t('db.noResults')}</li>
          ) : (
            filtered.map((db) => (
              <li
                key={db.id}
                className={styles.option}
                role="option"
                onClick={() => handleSelect(db)}
              >
                <span className={styles.optionId}>{db.id}</span>
                <span className={styles.optionName}>{db.de}</span>
                <span className={styles.optionFields}>{t('db.fields', { count: db.fc })}</span>
              </li>
            ))
          )}
        </ul>
      )}
    </div>
  );
}
