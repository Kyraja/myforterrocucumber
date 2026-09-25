/**
 * @module FopTree
 * Browsable tree/bindings panel listing abas FOP programs and their event bindings.
 *
 * Key responsibilities: renders FOP bindings grouped by database mask or infosystem,
 * supports inline search and a "custom only" filter, shows expandable call-chain
 * children for each binding row, displays analysis/test-exists badges, and emits
 * selection events so the parent can load the selected FOP in the analysis panel.
 *
 * @exports FopTree (default)
 */
import { useState, useMemo } from 'react';
import type { FopTreeNode, FopUsage, FopBinding } from '../../types/fop';
import type { IsBinding } from '../../lib/isBindingsParser';
import type { TableDef } from '../../types/gherkin';
import { makeFopGuid } from '../../lib/featureGuid';
import { resolveMaskName } from '../../lib/fopOrchestrator';
import { EventChip } from '../EventChip/EventChip';
import styles from './FopTree.module.css';

interface FopTreeProps {
  roots: FopTreeNode[];
  usageIndex: Map<string, FopUsage>;
  selectedPath: string | null;
  onSelectFop: (path: string) => void;
  viewMode: 'tree' | 'bindings';
  onViewModeChange: (mode: 'tree' | 'bindings') => void;
  bindings: FopBinding[];
  isBindings?: IsBinding[];
  allFopPaths?: string[];
  /** GUIDs of existing tests (from file explorer) — used to show test-exists indicator */
  existingGuids?: Set<string>;
  /** Paths of FOPs that have been analyzed — used to show analysis indicator */
  analyzedPaths?: Set<string>;
  /** Variable tables for resolving mask numbers to database names */
  varTables?: TableDef[];
  lang: 'de' | 'en';
}

/** Check if a FOP path is from a custom/ow directory (not standard) */
function isCustomFop(fopPath: string): boolean {
  const folder = fopPath.split('/')[0]?.toLowerCase() ?? '';
  return folder.startsWith('ow');
}

// Build a flat map of all tree nodes by path (for finding children of any FOP)
function buildNodeIndex(roots: FopTreeNode[]): Map<string, FopTreeNode> {
  const map = new Map<string, FopTreeNode>();
  function walk(node: FopTreeNode) {
    const path = node.fopFile.relativePath.toLowerCase();
    if (!map.has(path)) map.set(path, node);
    // Also index by filename only
    const name = node.fopFile.filename.toLowerCase();
    if (!map.has(name)) map.set(name, node);
    for (const child of node.children) walk(child);
  }
  for (const root of roots) walk(root);
  return map;
}

// Find children for a given FOP path using the node index
function getChildren(nodeIndex: Map<string, FopTreeNode>, fopPath: string): FopTreeNode[] {
  const name = fopPath.split('/').pop()?.toLowerCase() ?? '';
  const node = nodeIndex.get(fopPath.toLowerCase()) || nodeIndex.get(name);
  return node?.children ?? [];
}

// Recursive child list for expanded FOP entries
function ChildList({ children, nodeIndex, selectedPath, onSelectFop, expandedFops, setExpandedFops, allFopPaths, selectedRowKey, setSelectedRowKey, depth }: {
  children: FopTreeNode[];
  nodeIndex: Map<string, FopTreeNode>;
  selectedPath: string | null;
  onSelectFop: (path: string) => void;
  expandedFops: Set<string>;
  setExpandedFops: React.Dispatch<React.SetStateAction<Set<string>>>;
  allFopPaths?: string[];
  selectedRowKey: string | null;
  setSelectedRowKey: React.Dispatch<React.SetStateAction<string | null>>;
  depth: number;
}) {
  // Build set with both full paths and filenames for fast lookup
  const loadedNames = useMemo(() => {
    if (!allFopPaths) return null;
    const set = new Set<string>();
    for (const p of allFopPaths) {
      set.add(p.toLowerCase());
      const name = p.split('/').pop()?.toLowerCase();
      if (name) set.add(name);
    }
    return set;
  }, [allFopPaths]);

  return (
    <div className={styles.childList} style={{ paddingLeft: `${depth * 16}px` }}>
      {children.map((child) => {
        const childPath = child.fopFile.relativePath;
        const childKey = `child:${childPath}:${depth}`;
        const grandChildren = child.children;
        const hasGrand = grandChildren.length > 0;
        const isExp = expandedFops.has(childKey);
        const childNameLower = childPath.split('/').pop()?.toLowerCase() ?? '';
        const isFound = !loadedNames || loadedNames.has(childPath.toLowerCase()) || loadedNames.has(childNameLower);
        return (
          <div key={childKey}>
            <button
              type="button"
              className={`${styles.childRow} ${selectedRowKey === childKey ? styles.bindingRowSelected : ''} ${!isFound ? styles.childNotFound : ''}`}
              onClick={() => {
                setSelectedRowKey(childKey);
                onSelectFop(childPath);
                if (hasGrand && !isExp) setExpandedFops(prev => new Set(prev).add(childKey));
              }}
              title={isFound ? childPath : `${childPath} — Datei nicht im geladenen Ordner`}
            >
              <span
                className={styles.expandToggle}
                onClick={hasGrand ? (e: React.MouseEvent) => {
                  e.stopPropagation();
                  setExpandedFops(prev => { const next = new Set(prev); if (isExp) next.delete(childKey); else next.add(childKey); return next; });
                } : undefined}
              >
                {hasGrand ? (isExp ? '▾' : '▸') : ''}
              </span>
              <span className={styles.childIcon}>↳</span>
              <span className={styles.bindingPath}>{child.fopFile.filename}</span>
              {hasGrand && <span className={styles.childCount}>{grandChildren.length}</span>}
            </button>
            {isExp && hasGrand && (
              <ChildList children={grandChildren} nodeIndex={nodeIndex} selectedPath={selectedPath} onSelectFop={onSelectFop} expandedFops={expandedFops} setExpandedFops={setExpandedFops} allFopPaths={allFopPaths} selectedRowKey={selectedRowKey} setSelectedRowKey={setSelectedRowKey} depth={depth + 1} />
            )}
          </div>
        );
      })}
    </div>
  );
}

// Build compact tags for a FOP from its usage chains
function buildUsageTags(usage: FopUsage | undefined): string[] {
  if (!usage || usage.usageChains.length === 0) return [];
  // Deduplicate by mask+event
  const seen = new Set<string>();
  const tags: string[] = [];
  for (const chain of usage.usageChains) {
    const b = chain.binding;
    const key = `${b.mask}·${b.eventShort}${b.field !== '*' && b.field !== '-' ? '·' + b.field : ''}`;
    if (!seen.has(key)) {
      seen.add(key);
      const maskPart = b.mask === '*' ? '*' : `M${b.mask}`;
      const fieldPart = b.field !== '*' && b.field !== '-' ? `:${b.field}` : '';
      tags.push(`${maskPart} ${b.eventShort}${fieldPart}`);
    }
    if (tags.length >= 3) break; // max 3 tags in row
  }
  const extra = usage.usageChains.length - tags.length;
  if (extra > 0 && new Set(usage.usageChains.map(c => `${c.binding.mask}·${c.binding.eventShort}`)).size > tags.length) {
    tags.push(`+${extra}`);
  }
  return tags;
}

function statusIcon(node: FopTreeNode): string {
  if (node.missingCalls.length > 0) return '🔴';
  if (node.unresolvedCalls.length > 0) return '🟡';
  switch (node.cacheStatus) {
    case 'stale': return '⟳';
    case 'cached': return '✓';
    case 'missing': return '🔴';
    default: return '○';
  }
}

function groupByFolder(paths: string[]): Map<string, string[]> {
  const map = new Map<string, string[]>();
  for (const p of paths) {
    const parts = p.split('/');
    const folder = parts.length > 1 ? parts[0] : '—';
    if (!map.has(folder)) map.set(folder, []);
    map.get(folder)!.push(p);
  }
  return new Map([...map.entries()].sort((a, b) => a[0].localeCompare(b[0])));
}

function groupIsBindingsByName(bindings: IsBinding[]): Map<string, IsBinding[]> {
  const map = new Map<string, IsBinding[]>();
  for (const b of bindings) {
    const key = b.isSearchWord || b.isName;
    if (!map.has(key)) map.set(key, []);
    map.get(key)!.push(b);
  }
  return new Map([...map.entries()].sort((a, b) => a[0].localeCompare(b[0])));
}

function groupBindingsByMask(bindings: FopBinding[]): Map<number | '*', FopBinding[]> {
  const map = new Map<number | '*', FopBinding[]>();
  for (const b of bindings) {
    if (!map.has(b.mask)) map.set(b.mask, []);
    map.get(b.mask)!.push(b);
  }
  return new Map([...map.entries()].sort((a, b) => {
    if (a[0] === '*') return 1;
    if (b[0] === '*') return -1;
    return (a[0] as number) - (b[0] as number);
  }));
}

// ── Tree node row ──────────────────────────────────────────

interface TreeNodeRowProps {
  node: FopTreeNode;
  usageIndex: Map<string, FopUsage>;
  selectedPath: string | null;
  onSelectFop: (path: string) => void;
  depth: number;
  searchLower: string;
}

function TreeNodeRow({ node, usageIndex, selectedPath, onSelectFop, depth, searchLower }: TreeNodeRowProps) {
  const path = node.fopFile.relativePath;
  const filename = node.fopFile.filename;
  const matches = !searchLower || path.toLowerCase().includes(searchLower) || filename.toLowerCase().includes(searchLower);
  const [expanded, setExpanded] = useState(true);
  const isSelected = selectedPath === path;
  const hasChildren = node.children.length > 0;
  const usage = usageIndex.get(path);
  const usageTags = buildUsageTags(usage);

  const anyChildVisible = node.children.some(c =>
    !searchLower ||
    c.fopFile.relativePath.toLowerCase().includes(searchLower) ||
    c.fopFile.filename.toLowerCase().includes(searchLower)
  );

  if (!matches && !anyChildVisible) return null;

  return (
    <li className={styles.treeItem}>
      <div
        className={`${styles.nodeRow} ${isSelected ? styles.nodeRowSelected : ''}`}
        style={{ paddingLeft: `${8 + depth * 16}px` }}
        onClick={() => onSelectFop(path)}
      >
        <span
          className={hasChildren
            ? (expanded ? `${styles.chevron} ${styles.chevronExpanded}` : styles.chevron)
            : `${styles.chevron} ${styles.chevronHidden}`}
          onClick={(e) => { e.stopPropagation(); setExpanded(v => !v); }}
        >
          ▸
        </span>
        <span className={styles.statusIcon} title={node.cacheStatus}>
          {statusIcon(node)}
        </span>
        <span className={styles.pathBtn} title={path}>
          {filename}
        </span>
        {/* Usage tags — where is this FOP bound? */}
        {usageTags.map((tag, i) => (
          <span key={i} className={styles.usageTag} title={usage?.usageChains.map(c => c.bindingLabel).join('\n')}>
            {tag}
          </span>
        ))}
        {node.usageCount > 1 && (
          <span className={styles.sharedBadge} title={`Shared in ${node.usageCount} entry points`}>
            {node.usageCount}×
          </span>
        )}
      </div>
      {hasChildren && expanded && (
        <ul className={styles.childList}>
          {node.children.map((child) => (
            <TreeNodeRow
              key={child.fopFile.relativePath}
              node={child}
              usageIndex={usageIndex}
              selectedPath={selectedPath}
              onSelectFop={onSelectFop}
              depth={depth + 1}
              searchLower={searchLower}
            />
          ))}
        </ul>
      )}
    </li>
  );
}

// ── Flat file row (no bindings — shows usage tags from index) ──

interface FlatFileRowProps {
  fopPath: string;
  usageIndex: Map<string, FopUsage>;
  selectedPath: string | null;
  onSelectFop: (path: string) => void;
}

function FlatFileRow({ fopPath, usageIndex, selectedPath, onSelectFop }: FlatFileRowProps) {
  const usage = usageIndex.get(fopPath);
  const usageTags = buildUsageTags(usage);
  const isSelected = selectedPath === fopPath;
  const name = fopPath.split('/').pop() ?? fopPath;

  return (
    <li>
      <div
        className={`${styles.flatRow} ${isSelected ? styles.flatRowSelected : ''}`}
        onClick={() => onSelectFop(fopPath)}
        title={fopPath}
      >
        <span className={styles.flatIcon}>○</span>
        <span className={styles.flatName}>{name}</span>
        {usageTags.map((tag, i) => (
          <span key={i} className={styles.usageTag} title={usage?.usageChains.map(c => c.bindingLabel).join('\n')}>
            {tag}
          </span>
        ))}
      </div>
    </li>
  );
}

// ── Main component ─────────────────────────────────────────

export default function FopTree({
  roots,
  usageIndex,
  selectedPath,
  onSelectFop,
  viewMode,
  onViewModeChange,
  bindings,
  isBindings,
  allFopPaths,
  existingGuids,
  analyzedPaths,
  varTables,
  lang,
}: FopTreeProps) {
  const [search, setSearch] = useState('');
  const [expandedFops, setExpandedFops] = useState<Set<string>>(new Set());
  const [expandedGroups, setExpandedGroups] = useState<Set<string>>(new Set());
  const [selectedRowKey, setSelectedRowKey] = useState<string | null>(null);
  const [onlyCustom, setOnlyCustom] = useState(true);

  const searchLower = search.toLowerCase().trim();

  // Set of loaded file names (lowercase) for "not found" detection
  const loadedNames = useMemo(() => {
    if (!allFopPaths || allFopPaths.length === 0) return null;
    const set = new Set<string>();
    for (const p of allFopPaths) {
      set.add(p.toLowerCase());
      const name = p.split('/').pop()?.toLowerCase();
      if (name) set.add(name);
    }
    return set;
  }, [allFopPaths]);

  // Index for looking up children of any FOP
  const nodeIndex = useMemo(() => buildNodeIndex(roots), [roots]);

  const filteredPaths = useMemo(() =>
    allFopPaths?.filter(p => !searchLower || p.toLowerCase().includes(searchLower)) ?? [],
    [allFopPaths, searchLower],
  );

  const filteredBindings = useMemo(() =>
    bindings.filter(b => {
      if (onlyCustom && !isCustomFop(b.fopPath)) return false;
      if (!searchLower) return true;
      return String(b.mask).includes(searchLower) ||
        b.field.toLowerCase().includes(searchLower) ||
        b.fopPath.toLowerCase().includes(searchLower) ||
        b.event.toLowerCase().includes(searchLower) ||
        b.eventShort.toLowerCase().includes(searchLower);
    }),
    [bindings, searchLower, onlyCustom],
  );

  const filteredIsBindings = useMemo(() =>
    (isBindings ?? []).filter(b => {
      if (onlyCustom && !isCustomFop(b.fopPath)) return false;
      if (!searchLower) return true;
      return b.isName.toLowerCase().includes(searchLower) ||
      b.isSearchWord.toLowerCase().includes(searchLower) ||
      (b.field ?? '').toLowerCase().includes(searchLower) ||
      b.fopPath.toLowerCase().includes(searchLower) ||
      b.event.toLowerCase().includes(searchLower);
    }),
    [isBindings, searchLower, onlyCustom],
  );

  const grouped = groupByFolder(filteredPaths);
  const groupedBindings = groupBindingsByMask(filteredBindings);
  const groupedIsBindings = groupIsBindingsByName(filteredIsBindings);

  // Collect all bound FOP paths to find unbound ones
  const boundPaths = useMemo(() => {
    const set = new Set<string>();
    for (const b of bindings) set.add(b.fopPath);
    for (const b of (isBindings ?? [])) set.add(b.fopPath);
    return set;
  }, [bindings, isBindings]);

  const unboundPaths = useMemo(() =>
    (allFopPaths ?? []).filter(p => !boundPaths.has(p)),
    [allFopPaths, boundPaths],
  );

  const searchPlaceholder = lang === 'de'
    ? 'Maske, Feld, FOP-Name…'
    : 'Mask, field, FOP name…';

  const totalBindings = bindings.length + (isBindings ?? []).length;

  return (
    <div className={styles.panel}>
      {/* Header */}
      <div className={styles.header}>
        <input
          type="search"
          className={styles.searchInput}
          placeholder={searchPlaceholder}
          value={search}
          onChange={e => setSearch(e.target.value)}
        />
        <button
          type="button"
          className={onlyCustom ? styles.filterBtnActive : styles.filterBtn}
          onClick={() => setOnlyCustom(v => !v)}
          title={lang === 'de' ? 'Nur Custom-Programme (ow-Verzeichnisse) anzeigen' : 'Show only custom programs (ow directories)'}
        >
          {lang === 'de' ? 'Nur Custom' : 'Custom only'}
        </button>
        {totalBindings > 0 && (
          <span className={styles.tabCount}>
            {filteredBindings.length + filteredIsBindings.length}
            {onlyCustom ? ` / ${totalBindings}` : ''}
          </span>
        )}
      </div>

      {/* Content */}
      <div className={styles.content}>
        {(
          (allFopPaths?.length ?? 0) === 0 ? (
            <p className={styles.empty}>
              {lang === 'de'
                ? 'Bitte zuerst einen FOP-Ordner öffnen.'
                : 'Please open a FOP folder first.'}
            </p>
          ) : bindings.length === 0 && (isBindings ?? []).length === 0 ? (
            <p className={styles.empty}>
              {lang === 'de'
                ? 'FOP.txt und IS-Export im Stammdaten-Tab hochladen.'
                : 'Upload FOP.txt and IS export in master data tab.'}
            </p>
          ) : (
            <div className={styles.bindingsView}>
              {/* Datenbank-Masken */}
              {Array.from(groupedBindings.entries()).map(([mask, maskBindings]) => {
                const groupKey = `mask-${mask}`;
                const isGroupOpen = searchLower || expandedGroups.has(groupKey);
                return (
                <div key={String(mask)} className={styles.maskGroup}>
                  <button
                    type="button"
                    className={styles.maskGroupHeader}
                    onClick={() => setExpandedGroups(prev => { const next = new Set(prev); if (prev.has(groupKey)) next.delete(groupKey); else next.add(groupKey); return next; })}
                  >
                    <span>{isGroupOpen ? '▾' : '▸'}</span>
                    <span>🎭</span>
                    <span>{varTables ? resolveMaskName(mask, varTables, lang) : String(mask)}</span>
                    <span className={styles.folderCount}>{maskBindings.length}</span>
                  </button>
                  {isGroupOpen && maskBindings.map((b, idx) => {
                    const rowKey = `db-${mask}-${b.fopPath}-${b.event}-${b.field}-${idx}`;
                    const children = getChildren(nodeIndex, b.fopPath);
                    const hasChildren = children.length > 0;
                    const isExpanded = expandedFops.has(rowKey);
                    const fopName = b.fopPath.split('/').pop()?.toLowerCase() ?? '';
                    const isFound = !loadedNames || loadedNames.has(b.fopPath.toLowerCase()) || loadedNames.has(fopName);
                    return (
                      <div key={rowKey}>
                        <button
                          type="button"
                          className={`${styles.bindingRow} ${selectedRowKey === rowKey ? styles.bindingRowSelected : ''} ${!isFound ? styles.childNotFound : ''}`}
                          onClick={() => {
                            setSelectedRowKey(rowKey);
                            onSelectFop(b.fopPath);
                            // Open if closed, keep open if already open (clicking parent again just selects it)
                            if (hasChildren && !isExpanded) setExpandedFops(prev => new Set(prev).add(rowKey));
                          }}
                          title={`${b.event}${b.field !== '*' ? ` · ${b.field}` : ''} — ${b.fopPath}`}
                        >
                          <span
                            className={styles.expandToggle}
                            onClick={hasChildren ? (e: React.MouseEvent) => {
                              e.stopPropagation();
                              setExpandedFops(prev => { const next = new Set(prev); if (isExpanded) next.delete(rowKey); else next.add(rowKey); return next; });
                            } : undefined}
                          >
                            {hasChildren ? (isExpanded ? '▾' : '▸') : ''}
                          </span>
                          <EventChip event={b.eventShort} lang={lang} />
                          {b.field !== '*' && b.field !== '-' && (
                            <span className={styles.bindingCmd}>{b.field}</span>
                          )}
                          {b.scope !== '*' && (
                            <span className={styles.bindingScope}>{b.scope === 'K' ? (lang === 'de' ? 'Kopf' : 'Head') : (lang === 'de' ? 'Tab.' : 'Tab.')}</span>
                          )}
                          <span className={styles.bindingPath}>
                            {b.fopPath}
                          </span>
                          {analyzedPaths?.has(b.fopPath) && (
                            <span className={styles.analyzedBadge} title={lang === 'de' ? 'Analysiert' : 'Analyzed'}>A</span>
                          )}
                          {existingGuids?.has(makeFopGuid(b.fopPath)) && (
                            <span className={styles.testExists} title={lang === 'de' ? 'Test vorhanden' : 'Test exists'}>✓</span>
                          )}
                          {hasChildren && <span className={styles.childCount}>{children.length}</span>}
                        </button>
                        {isExpanded && children.length > 0 && (
                          <ChildList children={children} nodeIndex={nodeIndex} selectedPath={selectedPath} onSelectFop={onSelectFop} expandedFops={expandedFops} setExpandedFops={setExpandedFops} allFopPaths={allFopPaths} selectedRowKey={selectedRowKey} setSelectedRowKey={setSelectedRowKey} depth={1} />
                        )}
                      </div>
                    );
                  })}
                </div>
                );
              })}

              {/* Infosysteme */}
              {Array.from(groupedIsBindings.entries()).map(([isKey, isBindingGroup]) => {
                const groupKey = `is-${isKey}`;
                const isGroupOpen = searchLower || expandedGroups.has(groupKey);
                return (
                <div key={isKey} className={styles.maskGroup}>
                  <button
                    type="button"
                    className={styles.maskGroupHeader}
                    onClick={() => setExpandedGroups(prev => { const next = new Set(prev); if (prev.has(groupKey)) next.delete(groupKey); else next.add(groupKey); return next; })}
                  >
                    <span>{isGroupOpen ? '▾' : '▸'}</span>
                    <span className={styles.isIcon}>ℹ</span>
                    <span>{(() => {
                      const sw = isBindingGroup[0]?.isSearchWord || isKey;
                      const name = isBindingGroup[0]?.isName || isKey;
                      const isDef = varTables?.find(t => t.kind === 'infosystem' && t.tableRef === sw);
                      const nr = isDef?.maskNr;
                      return nr !== undefined ? `${name} (${nr} - ${sw})` : `${name} (${sw})`;
                    })()}</span>
                    <span className={styles.folderCount}>{isBindingGroup.length}</span>
                  </button>
                  {isGroupOpen && isBindingGroup.map((b, idx) => {
                    const rowKey = `is-${isKey}-${b.fopPath}-${b.event}-${b.field ?? ''}-${idx}`;
                    const children = getChildren(nodeIndex, b.fopPath);
                    const hasChildren = children.length > 0;
                    const isExpanded = expandedFops.has(rowKey);
                    const fopName = b.fopPath.split('/').pop()?.toLowerCase() ?? '';
                    const isFound = !loadedNames || loadedNames.has(b.fopPath.toLowerCase()) || loadedNames.has(fopName);
                    return (
                      <div key={rowKey}>
                        <button
                          type="button"
                          className={`${styles.bindingRow} ${selectedRowKey === rowKey ? styles.bindingRowSelected : ''} ${!isFound ? styles.childNotFound : ''}`}
                          onClick={() => {
                            setSelectedRowKey(rowKey);
                            onSelectFop(b.fopPath);
                            if (hasChildren && !isExpanded) setExpandedFops(prev => new Set(prev).add(rowKey));
                          }}
                          title={`${b.eventLong}${b.field ? ` · ${b.field}` : ''} — ${b.fopPath}`}
                        >
                          <span
                            className={styles.expandToggle}
                            onClick={hasChildren ? (e: React.MouseEvent) => {
                              e.stopPropagation();
                              setExpandedFops(prev => { const next = new Set(prev); if (isExpanded) next.delete(rowKey); else next.add(rowKey); return next; });
                            } : undefined}
                          >
                            {hasChildren ? (isExpanded ? '▾' : '▸') : ''}
                          </span>
                          <EventChip event={b.event} lang={lang} />
                          {b.field && (
                            <span className={styles.bindingCmd}>{b.field}</span>
                          )}
                          {b.scope !== '*' && (
                            <span className={styles.bindingScope}>{b.scope === 'K' ? (lang === 'de' ? 'Kopf' : 'Head') : (lang === 'de' ? 'Tab.' : 'Tab.')}</span>
                          )}
                          <span className={styles.bindingPath}>
                            {b.fopPath}
                          </span>
                          {analyzedPaths?.has(b.fopPath) && (
                            <span className={styles.analyzedBadge} title={lang === 'de' ? 'Analysiert' : 'Analyzed'}>A</span>
                          )}
                          {existingGuids?.has(makeFopGuid(b.fopPath)) && (
                            <span className={styles.testExists} title={lang === 'de' ? 'Test vorhanden' : 'Test exists'}>✓</span>
                          )}
                          {hasChildren && <span className={styles.childCount}>{children.length}</span>}
                        </button>
                        {isExpanded && children.length > 0 && (
                          <ChildList children={children} nodeIndex={nodeIndex} selectedPath={selectedPath} onSelectFop={onSelectFop} expandedFops={expandedFops} setExpandedFops={setExpandedFops} allFopPaths={allFopPaths} selectedRowKey={selectedRowKey} setSelectedRowKey={setSelectedRowKey} depth={1} />
                        )}
                      </div>
                    );
                  })}
                </div>
                );
              })}

              {/* Ungebundene Programme — nur bei Suche anzeigen */}
              {searchLower && unboundPaths.filter(p => p.toLowerCase().includes(searchLower)).length > 0 && (
                <div className={styles.maskGroup}>
                  <div className={styles.maskGroupHeader}>
                    <span>📄</span>
                    <span>{lang === 'de' ? 'Ohne Zuordnung' : 'Unbound'}</span>
                    <span className={styles.folderCount}>{unboundPaths.filter(p => p.toLowerCase().includes(searchLower)).length}</span>
                  </div>
                  {unboundPaths.filter(p => p.toLowerCase().includes(searchLower)).map(p => (
                    <FlatFileRow
                      key={p}
                      fopPath={p}
                      usageIndex={usageIndex}
                      selectedPath={selectedPath}
                      onSelectFop={onSelectFop}
                    />
                  ))}
                </div>
              )}

              {filteredBindings.length === 0 && filteredIsBindings.length === 0 && searchLower && (
                <p className={styles.empty}>{lang === 'de' ? 'Keine Treffer.' : 'No results.'}</p>
              )}
            </div>
          )
        )}
      </div>
    </div>
  );
}
