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
import { useState, useMemo } from 'react';
import type { TableDef, FieldDef } from '../../types/gherkin';
import type { FopBinding } from '../../types/fop';
import type { IsBinding } from '../../lib/fopTxtParser';
import type { KBDocument } from '../../types/knowledgeBase';
import { CsvUpload } from '../CsvUpload/CsvUpload';
import { EventChip } from '../EventChip/EventChip';
import KnowledgeBaseTab from './KnowledgeBaseTab';
import { isKnowledgeBaseEnabled } from '../../lib/settings';
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
  lang: 'de' | 'en';
}

type Tab = 'variablen' | 'infosysteme' | 'fop' | 'is' | 'wissensdatenbank';

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
  lang: 'de' | 'en';
  onClick: () => void;
}

function TableListItem({ table, isSelected, searchQuery, lang, onClick }: TableListItemProps) {
  const displayName = lang === 'de' ? (table.nameDe ?? table.name) : (table.nameEn ?? table.name);
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
        {table.assumeExists && <span className={styles.assumeExistsBadge} title={lang === 'de' ? 'Daten vorhanden' : 'Data exists'}>E</span>}
        {highlight(label, searchQuery)}
      </span>
      <span className={styles.listItemBadge}>{table.fields.length}</span>
    </button>
  );
}

interface FieldsDetailProps {
  table: TableDef;
  lang: 'de' | 'en';
  onToggleAssumeExists?: (tableRef: string) => void;
}

function FieldsDetail({ table, lang, onToggleAssumeExists }: FieldsDetailProps) {
  const displayName = lang === 'de' ? (table.nameDe ?? table.name) : (table.nameEn ?? table.name);
  return (
    <div className={styles.detailPanel}>
      <div className={styles.detailHeader}>
        <span className={styles.detailTitle}>{table.tableRef} — {displayName}</span>
        <span className={styles.detailMeta}>{table.fields.length} {lang === 'de' ? 'Felder' : 'fields'}</span>
        <label className={styles.assumeExistsToggle} title={lang === 'de'
          ? 'Wenn aktiv: KI verwendet vorhandene Datensätze statt neue anzulegen (STORE/NEW)'
          : 'When active: AI uses existing records instead of creating new ones (STORE/NEW)'}>
          <input
            type="checkbox"
            checked={!!table.assumeExists}
            onChange={() => onToggleAssumeExists?.(table.tableRef)}
          />
          <span>{lang === 'de' ? 'Daten vorhanden' : 'Data exists'}</span>
        </label>
      </div>
      <div className={styles.detailTable}>
        <table>
          <thead>
            <tr>
              <th>{lang === 'de' ? 'Feldname' : 'Field Name'}</th>
              <th>{lang === 'de' ? 'Beschreibung' : 'Description'}</th>
              <th>{lang === 'de' ? 'Typ' : 'Type'}</th>
            </tr>
          </thead>
          <tbody>
            {table.fields.map((field: FieldDef, idx: number) => (
              <tr key={idx}>
                <td className={styles.monoCell}>{field.name}</td>
                <td title={`desc="${field.description}" de="${field.descriptionDe}" en="${field.descriptionEn}"`}>
                  {lang === 'de'
                    ? (field.descriptionDe ?? field.description)
                    : (field.descriptionEn ?? field.description)}
                </td>
                <td className={styles.monoCell}>
                  <span className={field.isTableField ? styles.tagTable : styles.tagHead}>
                    {field.isTableField
                      ? (lang === 'de' ? 'Tabelle' : 'Table')
                      : (lang === 'de' ? 'Kopf' : 'Header')}
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
  if (scope === 'K') return <span className={styles.tagK}>{lang === 'de' ? 'Kopf' : 'Header'}</span>;
  if (scope === 'T') return <span className={styles.tagT}>{lang === 'de' ? 'Tabelle' : 'Table'}</span>;
  return null;
}

function FopMaskDetail({ mask, bindings, lang }: FopMaskDetailProps) {
  const maskLabel = mask === '*'
    ? (lang === 'de' ? 'Alle Masken' : 'All Masks')
    : `${lang === 'de' ? 'Maske' : 'Mask'} ${mask}`;
  return (
    <div className={styles.detailPanel}>
      <div className={styles.detailHeader}>
        <span className={styles.detailTitle}>{maskLabel}</span>
        <span className={styles.detailMeta}>{bindings.length} {lang === 'de' ? 'Bindungen' : 'bindings'}</span>
      </div>
      <div className={styles.detailTable}>
        <table>
          <thead>
            <tr>
              <th>{lang === 'de' ? 'Ereignis' : 'Event'}</th>
              <th>{lang === 'de' ? 'K/T' : 'H/T'}</th>
              <th>{lang === 'de' ? 'Feld' : 'Field'}</th>
              <th>{lang === 'de' ? 'Befehl' : 'Command'}</th>
              <th>{lang === 'de' ? 'FOP-Pfad' : 'FOP Path'}</th>
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
        <span className={styles.detailMeta}>{bindings.length} {lang === 'de' ? 'Programme' : 'programs'}</span>
      </div>
      <div className={styles.detailTable}>
        <table>
          <thead>
            <tr>
              <th>{lang === 'de' ? 'Ereignis' : 'Event'}</th>
              <th>{lang === 'de' ? 'K/T' : 'H/T'}</th>
              <th>{lang === 'de' ? 'Feld' : 'Field'}</th>
              <th>{lang === 'de' ? 'FOP-Pfad' : 'FOP Path'}</th>
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
  lang,
}: StammdatenViewProps) {
  const [activeTab, setActiveTab] = useState<Tab>('variablen');
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
          const name = lang === 'de' ? (t.nameDe ?? t.name) : (t.nameEn ?? t.name);
          if (`${t.tableRef} ${name} ${t.maskNr ?? ''}`.toLowerCase().includes(q)) return true;
          return t.fields.some(
            (f) =>
              f.name.toLowerCase().includes(q) ||
              (f.descriptionDe ?? f.description).toLowerCase().includes(q)
          );
        })
        .sort((a, b) => {
          const [aDb, aGrp] = a.tableRef.split(':').map(Number);
          const [bDb, bGrp] = b.tableRef.split(':').map(Number);
          return aDb !== bDb ? aDb - bDb : aGrp - bGrp;
        }),
    [tableDefs, q, lang]
  );

  const isTables = useMemo(
    () =>
      tableDefs
        .filter((t) => t.kind === 'infosystem')
        .filter((t) => {
          if (!q) return true;
          const name = lang === 'de' ? (t.nameDe ?? t.name) : (t.nameEn ?? t.name);
          if (`${t.tableRef} ${name}`.toLowerCase().includes(q)) return true;
          return t.fields.some(
            (f) =>
              f.name.toLowerCase().includes(q) ||
              (f.descriptionDe ?? f.description).toLowerCase().includes(q)
          );
        })
        .sort((a, b) => a.tableRef.localeCompare(b.tableRef)),
    [tableDefs, q, lang]
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
    { id: 'variablen', label: lang === 'de' ? 'Variablen' : 'Variables' },
    { id: 'infosysteme', label: lang === 'de' ? 'Infosysteme' : 'Infosystems' },
    { id: 'fop', label: 'FOP.txt' },
    { id: 'is', label: lang === 'de' ? 'IS-Anbindung' : 'IS Binding' },
    ...(isKnowledgeBaseEnabled() ? [{ id: 'wissensdatenbank' as Tab, label: lang === 'de' ? 'Wissensdatenbank' : 'Knowledge Base' }] : []),
  ];

  const searchPlaceholder =
    lang === 'de'
      ? 'Tabelle, Feld, Maske, Programm…'
      : 'Table, field, mask, program…';

  // ── Empty state messages ───────────────────────────────────────
  const emptyMessages: Record<Tab, string> = {
    variablen: lang === 'de' ? 'Keine Datenbanken geladen' : 'No databases loaded',
    infosysteme: lang === 'de' ? 'Keine Infosysteme geladen' : 'No infosystems loaded',
    fop: lang === 'de' ? 'Keine FOP.txt geladen' : 'No FOP.txt loaded',
    is: lang === 'de' ? 'Keine IS-Anbindungen geladen' : 'No IS bindings loaded',
    wissensdatenbank: '',
  };

  const noSelectionMessages: Record<Tab, string> = {
    variablen: lang === 'de' ? 'Datenbank auswählen' : 'Select a database',
    infosysteme: lang === 'de' ? 'Infosystem auswählen' : 'Select an infosystem',
    fop: lang === 'de' ? 'Maske auswählen' : 'Select a mask',
    is: lang === 'de' ? 'Infosystem auswählen' : 'Select an infosystem',
    wissensdatenbank: '',
  };

  function handleTabChange(tab: Tab) {
    setActiveTab(tab);
    setSearchQuery('');
    setSelectedTableRef(null);
    setSelectedFopMask(null);
    setSelectedIsWord(null);
  }

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
          lang={lang}
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
          lang={lang}
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
            ? (lang === 'de' ? 'Alle Masken (*)' : 'All Masks (*)')
            : `${lang === 'de' ? 'Maske' : 'Mask'} ${mask}`;
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
      return <FieldsDetail table={selectedTable} lang={lang} onToggleAssumeExists={handleToggleAssumeExists} />;
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

      {/* Search */}
      <div className={styles.searchRow}>
        <input
          type="search"
          className={styles.searchInput}
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          placeholder={searchPlaceholder}
        />
      </div>

      {/* Wissensdatenbank tab has its own layout */}
      {activeTab === 'wissensdatenbank' ? (
        <KnowledgeBaseTab
          documents={kbDocuments}
          onDocumentsChange={onKBDocumentsChange}
          lang={lang}
          tableDefs={tableDefs}
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
