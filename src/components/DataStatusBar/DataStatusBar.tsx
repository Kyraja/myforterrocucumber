/**
 * @module DataStatusBar
 * Read-only status strip displayed at the top of the workspace that summarises
 * all loaded reference data at a glance: variable tables (DB count + field
 * count), infosystem tables, FOP mask bindings, IS bindings, and optionally
 * Knowledge Base document/chunk counts. Items that have not been uploaded are
 * shown in a muted "missing" style. Renders nothing when no data is loaded.
 */
import type { TableDef } from '../../types/gherkin';
import type { FopBinding } from '../../types/fop';
import type { IsBinding } from '../../lib/fopTxtParser';
import styles from './DataStatusBar.module.css';

interface DataStatusBarProps {
  tableDefs: TableDef[];
  fopBindings: FopBinding[];
  isBindings: IsBinding[];
  kbDocumentCount?: number;
  kbChunkCount?: number;
  lang: 'de' | 'en';
}

export function DataStatusBar({ tableDefs, fopBindings, isBindings, kbDocumentCount, kbChunkCount, lang }: DataStatusBarProps) {
  const dbTables = tableDefs.filter(t => t.kind === 'database');
  const isTables = tableDefs.filter(t => t.kind === 'infosystem');
  const dbFields = dbTables.reduce((s, t) => s + t.fields.length, 0);
  const isFields = isTables.reduce((s, t) => s + t.fields.length, 0);
  const uniqueFopMasks = new Set(fopBindings.map(b => b.mask)).size;
  const uniqueIsNames = new Set(isBindings.map(b => b.isSearchWord)).size;

  if (tableDefs.length === 0 && fopBindings.length === 0 && isBindings.length === 0) return null;

  const ok = (label: string, value: string) => (
    <span className={styles.item}>
      <span className={styles.dot} style={{ background: 'var(--color-success)' }} />
      <span className={styles.label}>{label}:</span>
      <span className={styles.val}>{value}</span>
    </span>
  );

  const missing = (label: string) => (
    <span className={styles.item} title={lang === 'de' ? 'Nicht hochgeladen' : 'Not uploaded'}>
      <span className={styles.dot} style={{ background: 'var(--color-text-muted)' }} />
      <span className={styles.labelMuted}>{label}:</span>
      <span className={styles.valMuted}>—</span>
    </span>
  );

  return (
    <div className={styles.bar}>
      {/* Left group: field data */}
      <span className={styles.group}>
        {dbTables.length > 0
          ? ok(lang === 'de' ? 'Variablen' : 'Variables',
              `${dbTables.length} DB · ${dbFields.toLocaleString()} ${lang === 'de' ? 'Felder' : 'fields'}`)
          : missing(lang === 'de' ? 'Variablen' : 'Variables')}

        <span className={styles.sep} />

        {isTables.length > 0
          ? ok('Infosysteme', `${isTables.length} IS · ${isFields.toLocaleString()} ${lang === 'de' ? 'Felder' : 'fields'}`)
          : missing('Infosysteme')}
      </span>

      {/* Right group: program bindings */}
      <span className={styles.groupRight}>
        {fopBindings.length > 0
          ? ok(lang === 'de' ? 'Masken-Anbindung' : 'Mask bindings',
              `${fopBindings.length} ${lang === 'de' ? 'Bindungen' : 'bindings'} · ${uniqueFopMasks} ${lang === 'de' ? 'Masken' : 'masks'}`)
          : missing(lang === 'de' ? 'Masken-Anbindung (FOP.txt)' : 'Mask bindings (FOP.txt)')}

        <span className={styles.sep} />

        {isBindings.length > 0
          ? ok(lang === 'de' ? 'IS-Anbindung' : 'IS bindings',
              `${isBindings.length} ${lang === 'de' ? 'Programme' : 'programs'} · ${uniqueIsNames} IS`)
          : missing(lang === 'de' ? 'IS-Anbindung' : 'IS bindings')}

        {(kbDocumentCount ?? 0) > 0 && (
          <>
            <span className={styles.sep} />
            {ok('📚 KB', `${kbDocumentCount} ${lang === 'de' ? 'Docs' : 'docs'} · ${kbChunkCount ?? 0} Chunks`)}
          </>
        )}
      </span>
    </div>
  );
}
