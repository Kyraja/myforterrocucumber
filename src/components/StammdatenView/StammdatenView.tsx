/**
 * @module StammdatenView
 * Full-panel reference-data browser with tabbed navigation across five data
 * sources: Variables (DB tables), Infosystems, FOP.txt mask bindings, IS
 * bindings, and an optional Knowledge Base tab. Each tab presents a
 * resizable split-pane list/detail view with search/highlight support.
 *
 * Key responsibilities: host the CsvUpload toolbar for importing data, manage
 * tab state and search filtering, delegate detail rendering to sub-components
 * (FieldsDetail, FopMaskDetail, IsDetail), and expose the "assume exists"
 * toggle that influences AI prompt generation.
 */
import { useState, useMemo, useEffect } from 'react';
import type { TableDef, FieldDef } from '../../types/gherkin';
import type { FopBinding } from '../../types/fop';
import type { IsBinding } from '../../lib/isBindingsParser';
import type { KBDocument } from '../../types/knowledgeBase';
import type { LearningEntry } from '../../types/learning';
import { CsvUpload } from '../CsvUpload/CsvUpload';
import { EventChip } from '../EventChip/EventChip';
import { useTranslation } from '../../i18n';
import KnowledgeBaseTab from './KnowledgeBaseTab';
import LearningTab from './LearningTab';
import { isAiEnabled, isKnowledgeBaseEnabled } from '../../lib/settings';
import styles from './StammdatenView.module.css';

// ── Types ──────────────────────────────────────────────────────

interface StammdatenViewProps {
  tableDefs: TableDef[];
  onTablesChange: (tables: TableDef[]) => void;
  fopBindings: FopBinding[];
  onFopBindingsChange: (bindings: FopBinding[]) => void;
  isBindings: IsBinding[];
  onIsBindingsChange: (bindings: IsBinding[]) => void;
  kbDocuments: KBDocument[];
  onKBDocumentsChange: (docs: KBDocument[]) => void;
  rootHandle: FileSystemDirectoryHandle | null;
  onLearningsChanged?: (entries: LearningEntry[]) => void;
  learningAgentApiId?: string | null;
  learningModel?: string;
  initialTab?: StammdatenTab;
  lang: 'de' | 'en';
}

export type StammdatenTab = 'variablen' | 'infosysteme' | 'fop' | 'is' | 'wissensdatenbank' | 'learning';
type Tab = StammdatenTab;

function getUploadedTableName(table: TableDef): string {
  return table.name || table.nameDe || table.nameEn || table.tableRef;
}

function getUploadedFieldDescription(field: FieldDef): string {
  return field.description || field.descriptionDe || field.descriptionEn || '';
}

// ── Highlight helper ────────────────────────────────────────────

function highlight(text: string, query: string): React.ReactNode {
  if (!query) return text;
  const idx = text.toLowerCase().indexOf(query.toLowerCase());
  if (idx === -1) return text;
  return (
    <>
      {text.slice(0, idx)}
      <mark className={styles.highlight}>{text.slice(idx, idx + query.length)}</mark>
      {text.slice(idx + query.length)}
    </>
  );
}

// ── Sub-components ──────────────────────────────────────────────

interface TableListItemProps {
  table: TableDef;
  isSelected: boolean;
  searchQuery: string;
  onClick: () => void;
}

function TableListItem({ table, isSelected, searchQuery, onClick }: TableListItemProps) {
  const { t } = useTranslation();
  const displayName = getUploadedTableName(table);
  const label = table.maskNr !== undefined
    ? `${displayName} (${table.maskNr} - ${table.tableRef})`
    : `${displayName} (${table.tableRef})`;
  return (
    <button
      type="button"
      className={isSelected ? styles.listItemActive : styles.listItem}
      onClick={onClick}
    >
      <span className={styles.listItemLabel}>
        {table.assumeExists && <span className={styles.assumeExistsBadge} title={t('data.exists')}>E</span>}
        {highlight(label, searchQuery)}
      </span>
      <span className={styles.listItemBadge}>{table.fields.length}</span>
    </button>
  );
}

interface FieldsDetailProps {
  table: TableDef;
  onToggleAssumeExists?: (tableRef: string) => void;
}

function FieldsDetail({ table, onToggleAssumeExists }: FieldsDetailProps) {
  const { t } = useTranslation();
  const displayName = getUploadedTableName(table);
  return (
    <div className={styles.detailPanel}>
      <div className={styles.detailHeader}>
        <span className={styles.detailTitle}>{table.tableRef} — {displayName}</span>
        <span className={styles.detailMeta}>{table.fields.length} {t('data.fields')}</span>
        <label className={styles.assumeExistsToggle} title={t('stammdaten.assumeExistsHint')}>
          <input
            type="checkbox"
            checked={!!table.assumeExists}
            onChange={() => onToggleAssumeExists?.(table.tableRef)}
          />
          <span>{t('data.exists')}</span>
        </label>
      </div>
      <div className={styles.detailTable}>
        <table>
          <thead>
            <tr>
              <th>{t('stammdaten.fieldName')}</th>
              <th>{t('stammdaten.description')}</th>
              <th>{t('stammdaten.abasType')}</th>
              <th>{t('stammdaten.type')}</th>
            </tr>
          </thead>
          <tbody>
            {table.fields.map((field: FieldDef, idx: number) => (
              <tr key={idx}>
                <td className={styles.monoCell}>{field.name}</td>
                <td title={`desc="${field.description}" de="${field.descriptionDe}" en="${field.descriptionEn}"`}>
                  {getUploadedFieldDescription(field)}
                </td>
                <td className={styles.monoCell}>{field.dataType ?? '—'}</td>
                <td className={styles.monoCell}>
                  <span className={field.isTableField ? styles.tagTable : styles.tagHead}>
                    {field.isTableField
                      ? t('stammdaten.table')
                      : t('stammdaten.header')}
                  </span>
                  {field.skip && <span className={styles.tagSkip}>Skip</span>}
                  {field.readonly && <span className={styles.tagReadonly}>RO</span>}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

interface FopMaskDetailProps {
  mask: number | '*';
  bindings: FopBinding[];
  lang: 'de' | 'en';
}

function scopeLabel(scope: 'K' | 'T' | '*', lang: 'de' | 'en'): React.ReactNode {
  void lang;
  if (scope === 'K') return <span className={styles.tagK}>K</span>;
  if (scope === 'T') return <span className={styles.tagT}>T</span>;
  return null;
}

function FopMaskDetail({ mask, bindings, lang }: FopMaskDetailProps) {
  const { t } = useTranslation();
  const maskLabel = mask === '*'
    ? t('stammdaten.allMasks')
    : `${t('stammdaten.mask')} ${mask}`;
  return (
    <div className={styles.detailPanel}>
      <div className={styles.detailHeader}>
        <span className={styles.detailTitle}>{maskLabel}</span>
        <span className={styles.detailMeta}>{bindings.length} {t('data.bindings')}</span>
      </div>
      <div className={styles.detailTable}>
        <table>
          <thead>
            <tr>
              <th>{t('stammdaten.event')}</th>
              <th>{t('stammdaten.kt')}</th>
              <th>{t('stammdaten.field')}</th>
              <th>{t('stammdaten.command')}</th>
              <th>{t('stammdaten.fopPath')}</th>
            </tr>
          </thead>
          <tbody>
            {bindings.map((b, idx) => (
              <tr key={idx}>
                <td><EventChip event={b.eventShort} lang={lang} showCode /></td>
                <td>{scopeLabel(b.scope, lang)}</td>
                <td className={styles.monoCell}>
                  {b.field !== '*' && b.field !== '-' && b.field ? b.field : '—'}
                </td>
                <td className={styles.monoCell}>{b.command}</td>
                <td className={styles.monoCell}>{b.fopPath}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

interface IsDetailProps {
  isSearchWord: string;
  bindings: IsBinding[];
  tableDefs: TableDef[];
  lang: 'de' | 'en';
}

function IsDetail({ isSearchWord, bindings, tableDefs, lang }: IsDetailProps) {
  const { t } = useTranslation();
  const isName = bindings[0]?.isName ?? isSearchWord;

  // Lookup K/T for field-level events where scope='*'
  const getScope = (b: IsBinding): 'K' | 'T' | '*' => {
    if (b.scope !== '*') return b.scope;
    if (!b.field) return '*';
    // Find the IS table and look up isTableField
    const isTable = tableDefs.find(t =>
      t.kind === 'infosystem' &&
      (t.name.toLowerCase().includes(isSearchWord.toLowerCase()) ||
       t.tableRef === isSearchWord)
    );
    if (!isTable) return '*';
    const fieldDef = isTable.fields.find(f => f.name === b.field);
    if (!fieldDef) return '*';
    return fieldDef.isTableField ? 'T' : 'K';
  };

  return (
    <div className={styles.detailPanel}>
      <div className={styles.detailHeader}>
        <span className={styles.detailTitle}>{isSearchWord} — {isName}</span>
        <span className={styles.detailMeta}>{bindings.length} {t('data.programs')}</span>
      </div>
      <div className={styles.detailTable}>
        <table>
          <thead>
            <tr>
              <th>{t('stammdaten.event')}</th>
              <th>{t('stammdaten.kt')}</th>
              <th>{t('stammdaten.field')}</th>
              <th>{t('stammdaten.fopPath')}</th>
            </tr>
          </thead>
          <tbody>
            {bindings.map((b, idx) => (
              <tr key={idx}>
                <td><EventChip event={b.event} lang={lang} showCode /></td>
                <td>{scopeLabel(getScope(b), lang)}</td>
                <td className={styles.monoCell}>{b.field ?? '—'}</td>
                <td className={styles.monoCell}>{b.fopPath}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

// ── Main component ──────────────────────────────────────────────

export function StammdatenView({
  tableDefs,
  onTablesChange,
  fopBindings,
  onFopBindingsChange,
  isBindings,
  onIsBindingsChange,
  kbDocuments,
  onKBDocumentsChange,
  rootHandle,
  onLearningsChanged,
  initialTab,
  learningAgentApiId,
  learningModel,
  lang,
}: StammdatenViewProps) {
  const { t } = useTranslation();
  const [activeTab, setActiveTab] = useState<Tab>(initialTab ?? 'variablen');
  const [searchQuery, setSearchQuery] = useState('');
  const [stammdatenLeftWidth, setStammdatenLeftWidth] = useState(380);
  const [selectedTableRef, setSelectedTableRef] = useState<string | null>(null);
  const [selectedFopMask, setSelectedFopMask] = useState<number | '*' | null>(null);
  const [selectedIsWord, setSelectedIsWord] = useState<string | null>(null);

  const q = searchQuery.trim().toLowerCase();

  // ── Variablen / Infosysteme lists ──────────────────────────────
  const dbTables = useMemo(
    () =>
      tableDefs
        .filter((t) => t.kind === 'database')
        .filter((t) => {
          if (!q) return true;
          const displayName = getUploadedTableName(t);
          if (`${t.tableRef} ${displayName} ${t.maskNr ?? ''}`.toLowerCase().includes(q)) return true;
          return t.fields.some(
            (f) =>
              f.name.toLowerCase().includes(q) ||
              getUploadedFieldDescription(f).toLowerCase().includes(q)
          );
        })
        .sort((a, b) => {
          const [aDb, aGrp] = a.tableRef.split(':').map(Number);
          const [bDb, bGrp] = b.tableRef.split(':').map(Number);
          return aDb !== bDb ? aDb - bDb : aGrp - bGrp;
        }),
    [tableDefs, q]
  );

  const isTables = useMemo(
    () =>
      tableDefs
        .filter((t) => t.kind === 'infosystem')
        .filter((t) => {
          if (!q) return true;
          const displayName = getUploadedTableName(t);
          if (`${t.tableRef} ${displayName}`.toLowerCase().includes(q)) return true;
          return t.fields.some(
            (f) =>
              f.name.toLowerCase().includes(q) ||
              getUploadedFieldDescription(f).toLowerCase().includes(q)
          );
        })
        .sort((a, b) => a.tableRef.localeCompare(b.tableRef)),
    [tableDefs, q]
  );

  // ── FOP.txt mask list ──────────────────────────────────────────
  const fopMasks = useMemo(() => {
    const maskSet = new Map<number | '*', number>();
    for (const b of fopBindings) {
      const count = maskSet.get(b.mask) ?? 0;
      maskSet.set(b.mask, count + 1);
    }
    return Array.from(maskSet.entries())
      .filter(([mask]) => {
        if (!q) return true;
        const maskStr = mask === '*' ? '*' : String(mask);
        if (maskStr.includes(q)) return true;
        return fopBindings
          .filter((b) => b.mask === mask)
          .some(
            (b) =>
              b.field.toLowerCase().includes(q) ||
              b.event.toLowerCase().includes(q) ||
              b.fopPath.toLowerCase().includes(q)
          );
      })
      .sort(([a], [b]) => {
        if (a === '*') return 1;
        if (b === '*') return -1;
        return (a as number) - (b as number);
      });
  }, [fopBindings, q]);

  // ── IS binding list ────────────────────────────────────────────
  const isGroups = useMemo(() => {
    const groups = new Map<string, IsBinding[]>();
    for (const b of isBindings) {
      const arr = groups.get(b.isSearchWord) ?? [];
      arr.push(b);
      groups.set(b.isSearchWord, arr);
    }
    return Array.from(groups.entries())
      .filter(([sw, bindings]) => {
        if (!q) return true;
        const name = bindings[0]?.isName ?? '';
        if (`${sw} ${name}`.toLowerCase().includes(q)) return true;
        return bindings.some(
          (b) =>
            b.event.toLowerCase().includes(q) ||
            b.fopPath.toLowerCase().includes(q)
        );
      })
      .sort(([a], [b]) => a.localeCompare(b));
  }, [isBindings, q]);

  // ── Selected detail data ───────────────────────────────────────
  const selectedTable =
    (activeTab === 'variablen' || activeTab === 'infosysteme') && selectedTableRef
      ? tableDefs.find((t) => t.tableRef === selectedTableRef) ?? null
      : null;

  const selectedFopBindings =
    activeTab === 'fop' && selectedFopMask !== null
      ? fopBindings.filter((b) => b.mask === selectedFopMask)
      : [];

  const selectedIsBindings =
    activeTab === 'is' && selectedIsWord !== null
      ? isBindings.filter((b) => b.isSearchWord === selectedIsWord)
      : [];

  // ── Tab labels ─────────────────────────────────────────────────
  const tabs: Array<{ id: Tab; label: string }> = [
    { id: 'variablen', label: t('data.variables') },
    { id: 'infosysteme', label: t('csv.infosystem') },
    { id: 'fop', label: 'FOP.txt' },
    { id: 'is', label: t('data.isBindings') },
    ...(isKnowledgeBaseEnabled() ? [{ id: 'wissensdatenbank' as Tab, label: t('stammdaten.knowledgeBase') }] : []),
    ...(isAiEnabled() ? [{ id: 'learning' as Tab, label: t('stammdaten.learning') }] : []),
  ];

  const searchPlaceholder = t('stammdaten.searchPlaceholder');

  // ── Empty state messages ───────────────────────────────────────
  const emptyMessages: Record<Tab, string> = {
    variablen: t('stammdaten.noDatabases'),
    infosysteme: t('stammdaten.noInfosystems'),
    fop: t('stammdaten.noFop'),
    is: t('stammdaten.noIsBindings'),
    wissensdatenbank: '',
    learning: '',
  };

  const noSelectionMessages: Record<Tab, string> = {
    variablen: t('stammdaten.selectDatabase'),
    infosysteme: t('stammdaten.selectInfosystem'),
    fop: t('stammdaten.selectMask'),
    is: t('stammdaten.selectInfosystem'),
    wissensdatenbank: '',
    learning: '',
  };

  function handleTabChange(tab: Tab) {
    setActiveTab(tab);
    setSearchQuery('');
    setSelectedTableRef(null);
    setSelectedFopMask(null);
    setSelectedIsWord(null);
  }

  useEffect(() => {
    if (!initialTab) return;
    setActiveTab(initialTab);
  }, [initialTab]);

  // ── Left list content by tab ───────────────────────────────────
  function renderLeftList() {
    if (activeTab === 'variablen') {
      if (dbTables.length === 0) {
        return <p className={styles.emptyHint}>{emptyMessages.variablen}</p>;
      }
      return dbTables.map((t) => (
        <TableListItem
          key={t.tableRef}
          table={t}
          isSelected={selectedTableRef === t.tableRef}
          searchQuery={searchQuery}
          onClick={() => setSelectedTableRef(t.tableRef)}
        />
      ));
    }

    if (activeTab === 'infosysteme') {
      if (isTables.length === 0) {
        return <p className={styles.emptyHint}>{emptyMessages.infosysteme}</p>;
      }
      return isTables.map((t) => (
        <TableListItem
          key={t.tableRef}
          table={t}
          isSelected={selectedTableRef === t.tableRef}
          searchQuery={searchQuery}
          onClick={() => setSelectedTableRef(t.tableRef)}
        />
      ));
    }

    if (activeTab === 'fop') {
      if (fopMasks.length === 0) {
        return <p className={styles.emptyHint}>{emptyMessages.fop}</p>;
      }
      return fopMasks.map(([mask, count]) => {
        const maskLabel =
          mask === '*'
            ? t('stammdaten.allMasksWithStar')
            : `${t('stammdaten.mask')} ${mask}`;
        const isSelected = selectedFopMask === mask;
        return (
          <button
            key={String(mask)}
            type="button"
            className={isSelected ? styles.listItemActive : styles.listItem}
            onClick={() => setSelectedFopMask(mask)}
          >
            <span className={styles.listItemLabel}>
              {highlight(maskLabel, searchQuery)}
            </span>
            <span className={styles.listItemBadge}>{count}</span>
          </button>
        );
      });
    }

    if (activeTab === 'is') {
      if (isGroups.length === 0) {
        return <p className={styles.emptyHint}>{emptyMessages.is}</p>;
      }
      return isGroups.map(([sw, bindings]) => {
        const isName = bindings[0]?.isName ?? sw;
        const label = sw === isName ? sw : `${sw} — ${isName}`;
        const isSelected = selectedIsWord === sw;
        return (
          <button
            key={sw}
            type="button"
            className={isSelected ? styles.listItemActive : styles.listItem}
            onClick={() => setSelectedIsWord(sw)}
          >
            <span className={styles.listItemLabel}>
              {highlight(label, searchQuery)}
            </span>
            <span className={styles.listItemBadge}>{bindings.length}</span>
          </button>
        );
      });
    }

    return null;
  }

  // ── Toggle "assume exists" flag ─────────────────────────────────
  function handleToggleAssumeExists(tableRef: string) {
    const updated = tableDefs.map(t =>
      t.tableRef === tableRef ? { ...t, assumeExists: !t.assumeExists } : t
    );
    onTablesChange(updated);
  }

  // ── Right panel content ────────────────────────────────────────
  function renderDetail() {
    if (activeTab === 'variablen' || activeTab === 'infosysteme') {
      if (!selectedTable) {
        return <p className={styles.noSelectionHint}>{noSelectionMessages[activeTab]}</p>;
      }
      return <FieldsDetail table={selectedTable} onToggleAssumeExists={handleToggleAssumeExists} />;
    }

    if (activeTab === 'fop') {
      if (selectedFopMask === null) {
        return <p className={styles.noSelectionHint}>{noSelectionMessages.fop}</p>;
      }
      return (
        <FopMaskDetail
          mask={selectedFopMask}
          bindings={selectedFopBindings}
          lang={lang}
        />
      );
    }

    if (activeTab === 'is') {
      if (!selectedIsWord) {
        return <p className={styles.noSelectionHint}>{noSelectionMessages.is}</p>;
      }
      return (
        <IsDetail
          isSearchWord={selectedIsWord}
          bindings={selectedIsBindings}
          tableDefs={tableDefs}
          lang={lang}
        />
      );
    }

    return null;
  }

  return (
    <div className={styles.root}>
      {/* Upload area */}
      <div className={styles.uploadSection}>
        <CsvUpload
          tables={tableDefs}
          onTablesChange={onTablesChange}
          fopBindings={fopBindings}
          onFopBindingsChange={onFopBindingsChange}
          isBindings={isBindings}
          onIsBindingsChange={onIsBindingsChange}
        />
      </div>

      {/* Tabs */}
      <div className={styles.tabBar}>
        {tabs.map((tab) => (
          <button
            key={tab.id}
            type="button"
            className={activeTab === tab.id ? styles.tabActive : styles.tab}
            onClick={() => handleTabChange(tab.id)}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Search - only for variablen and infosysteme tabs */}
      {(activeTab === 'variablen' || activeTab === 'infosysteme') && (
        <div className={styles.searchRow}>
          <input
            type="search"
            className={styles.searchInput}
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder={searchPlaceholder}
          />
        </div>
      )}

      {/* Wissensdatenbank tab has its own layout */}
      {activeTab === 'wissensdatenbank' ? (
        <KnowledgeBaseTab
          documents={kbDocuments}
          onDocumentsChange={onKBDocumentsChange}
          lang={lang}
          tableDefs={tableDefs}
        />
      ) : activeTab === 'learning' ? (
        <LearningTab
          rootHandle={rootHandle}
          lang={lang}
          onLearningsChanged={onLearningsChanged}
          agentApiId={learningAgentApiId}
          model={learningModel}
        />
      ) : (
      /* Split pane with resizable divider */
      <div className={styles.splitPane}>
        <div className={styles.leftList} style={{ width: stammdatenLeftWidth }}>
          {renderLeftList()}
        </div>
        <div
          className={styles.resizeHandle}
          onMouseDown={(e) => {
            e.preventDefault();
            const startX = e.clientX;
            const startW = stammdatenLeftWidth;
            const onMove = (ev: MouseEvent) => setStammdatenLeftWidth(Math.max(200, Math.min(600, startW + ev.clientX - startX)));
            const onUp = () => { document.removeEventListener('mousemove', onMove); document.removeEventListener('mouseup', onUp); };
            document.addEventListener('mousemove', onMove);
            document.addEventListener('mouseup', onUp);
          }}
        />
        <div className={styles.rightPanel}>{renderDetail()}</div>
      </div>
      )}
    </div>
  );
}
