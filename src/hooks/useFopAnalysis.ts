/**
 * @module useFopAnalysis
 * Hook that orchestrates FOP (abas Form Program) directory scanning,
 * parsing, call-tree construction, and AI-assisted analysis.
 *
 * Workflow:
 * 1. `loadDirectory` — scan all FOP source files, parse them, build the call
 *    tree from `FOP.txt` bindings, and initialize the file-hash cache.
 * 2. `analyzeSelection` — run the multi-phase analysis pipeline (buffer tracking,
 *    field resolution, local checks, AI analyst, AI guidelines checker) on a
 *    subset of entry-point FOPs selected by the user.
 * 3. Results are cached on disk by file hash so unchanged FOPs are not re-analyzed.
 *
 * The directory handle is persisted between sessions so the workspace reopens
 * automatically on the next page load (subject to browser permission).
 */

import { useState, useCallback, useRef, useEffect } from 'react';
import type { FopFile, FopBinding, FopTreeNode, FopAnalysis, FopUsage } from '../types/fop';
import type { TableDef } from '../types/gherkin';
import type { AgentType } from './useAgentActivity';
import type { WorkflowEmitter } from '../lib/workflowEmitter';
import { parseFopSource, computeFileHash } from '../lib/fopParser';
import { parseFopTxt } from '../lib/fopTxtParser';
import { buildFopTree, getAllFopPaths } from '../lib/fopTreeResolver';
import { buildUsageIndex } from '../lib/fopUsageIndex';
import { FopCache, ensureOutputDirectories } from '../lib/fopCache';
import { runFopAnalysis } from '../lib/fopOrchestrator';
import { saveFopDirectoryHandle, loadFopDirectoryHandle, clearFopDirectoryHandle, verifyPermission } from '../lib/fileSystemAccess';
import { getFopAutoRefreshIntervalSeconds, isFopAutoRefreshEnabled } from '../lib/settings';

/** Full reactive state of the FOP workspace exposed by the hook. */
export interface FopWorkspaceState {
  /** Root directory handle opened by the user. */
  rootDir: FileSystemDirectoryHandle | null;
  /** Parsed FOP.txt binding entries that map entry-point IDs to FOP file paths. */
  bindings: FopBinding[];
  /** All parsed FOP source files found in the directory. */
  fopFiles: FopFile[];
  /**
   * Case-insensitive filename → relative path index.
   * Used to resolve binding paths that may differ in case or use the `ow` prefix.
   */
  fileNameIndex: Map<string, string>;
  /** Root nodes of the FOP call tree (one per binding entry point). */
  treeRoots: FopTreeNode[];
  /** Maps each FOP path to aggregated usage statistics (called-by, called-from). */
  usageIndex: Map<string, FopUsage>;
  /** AI analysis results keyed by relative FOP file path. */
  analyses: Map<string, FopAnalysis>;
  /** Disk-based analysis cache keyed by file hash. */
  cache: FopCache | null;
  /** Relative path of the FOP currently selected for detail display. */
  selectedFopPath: string | null;
  /** True while the initial directory scan and parse is in progress. */
  isLoading: boolean;
  /** True while the AI analysis pipeline is running. */
  isAnalyzing: boolean;
  /** Error message from `loadDirectory`, or `null`. */
  loadError: string | null;
  /** Summary of cache freshness across all known FOP paths. */
  cacheStats: { cached: number; stale: number; total: number } | null;
  /** abas database numbers referenced by variable types across all FOP files. */
  requiredDatabases: number[];
}

/** Options passed to {@link useFopAnalysis}. */
interface UseFopAnalysisOptions {
  /** AI model identifier forwarded to the analysis orchestrator. */
  model: string;
  /** UI language for localized labels and cache keys. */
  lang: 'de' | 'en';
  /** Variable/field tables available for field-resolution during analysis. */
  varTables: TableDef[];
  /** FOP bindings pre-loaded from a FOP.txt paste; bypasses directory-based FOP.txt lookup. */
  initialBindings?: FopBinding[];
  /** myForterro agent ID for the FOP content analyst. */
  analystAgentId?: string;
  /** myForterro agent ID for the FOP guidelines checker. */
  guidelinesAgentId?: string;
  experimentalFeatures: boolean;
  /** Called once when analysis starts; `total` is the number of unique FOP nodes. */
  onActivityStart?: (type: AgentType, total: number) => void;
  /** Called for each analyzed FOP to update progress UI. */
  onActivityProgress?: (type: AgentType, current: number, item: string, input?: string, output?: string) => void;
  onActivityComplete?: (type: AgentType, item: string, success: boolean) => void;
  onActivityFinish?: (type: AgentType, status: 'done' | 'error') => void;
  /** Update a specific process-diagram step with live data (buffers, fields, etc.). */
  onStepUpdate?: (stepId: string, item: string, input?: string, output?: string) => void;
  /** Unified workflow-timeline emitter supplied by the outer app. */
  getEmitter?: (type: AgentType) => WorkflowEmitter;
}

const INITIAL_STATE: FopWorkspaceState = {
  rootDir: null,
  bindings: [],
  fopFiles: [],
  fileNameIndex: new Map(),
  treeRoots: [],
  usageIndex: new Map(),
  analyses: new Map(),
  cache: null,
  selectedFopPath: null,
  isLoading: false,
  isAnalyzing: false,
  loadError: null,
  cacheStats: null,
  requiredDatabases: [],
};

/**
 * Hook for FOP directory scanning and AI analysis orchestration.
 *
 * The `optsRef` pattern is used throughout callbacks so that async operations
 * always read the latest options (model, agents, lang) without needing to be
 * re-created when those options change.
 *
 * @param opts - Configuration for the model, agents, and progress callbacks.
 * @returns The full {@link FopWorkspaceState} plus action methods.
 */
export function useFopAnalysis(opts: UseFopAnalysisOptions) {
  const [state, setState] = useState<FopWorkspaceState>(INITIAL_STATE);
  const abortRef = useRef(false);
  // Always keep latest opts in a ref so callbacks use current values without re-creating
  const optsRef = useRef(opts);
  optsRef.current = opts;

  // Rebuild tree when initialBindings change (e.g. FOP.txt uploaded via CsvUpload after directory loaded)
  const prevBindingsRef = useRef<FopBinding[] | undefined>(opts.initialBindings);
  useEffect(() => {
    const newBindings = opts.initialBindings;
    const prev = prevBindingsRef.current;
    const changed = newBindings?.length !== prev?.length;
    prevBindingsRef.current = newBindings;
    if (!changed || !state.fopFiles.length || !newBindings?.length) return;

    // Rebuild tree with new bindings
    const treeRoots = buildFopTree(newBindings, state.fopFiles);
    const usageIndex = buildUsageIndex(treeRoots, newBindings, opts.lang as 'de' | 'en');
    setState(prev => ({ ...prev, bindings: newBindings, treeRoots, usageIndex }));
  }, [opts.initialBindings?.length]); // eslint-disable-line react-hooks/exhaustive-deps

  /** Load a root directory: scan all FOPs, parse them, build tree */
  const loadDirectory = useCallback(async (rootDir: FileSystemDirectoryHandle) => {
    setState(prev => ({ ...prev, isLoading: true, loadError: null, rootDir }));
    // Persist handle for reload on next session
    saveFopDirectoryHandle(rootDir).catch(() => {});

    try {
      // Ensure output directories exist
      await ensureOutputDirectories(rootDir);

      // Initialize cache
      const cache = new FopCache(rootDir);
      await cache.init();

      // Scan all FOP files recursively
      const fopContents: { relativePath: string; content: string }[] = [];
      await scanDirectory(rootDir, '', fopContents);

      // Use pre-loaded bindings from CsvUpload if available, otherwise parse FOP.txt from directory
      let bindings: FopBinding[] = optsRef.current.initialBindings ?? [];
      if (bindings.length === 0) {
        try {
          const fopTxtHandle = await rootDir.getFileHandle('FOP.txt');
          const fopTxtFile = await fopTxtHandle.getFile();
          const fopTxtContent = await fopTxtFile.text();
          bindings = parseFopTxt(fopTxtContent);
        } catch {
          // FOP.txt not found or not parseable — continue without bindings
        }
      }

      // Parse all FOP source files
      const fopFiles: FopFile[] = await Promise.all(
        fopContents.map(async ({ relativePath, content }) => {
          const hash = await computeFileHash(content);
          return parseFopSource(content, relativePath, hash);
        })
      );

      // Build filename → path index for resolving binding paths
      const fileNameIndex = new Map<string, string>();
      for (const f of fopFiles) {
        // Index by filename (lowercase)
        const name = f.relativePath.split('/').pop()?.toLowerCase() ?? '';
        if (name && !fileNameIndex.has(name)) fileNameIndex.set(name, f.relativePath);
        // Also index by full relative path (lowercase)
        fileNameIndex.set(f.relativePath.toLowerCase(), f.relativePath);
      }
      console.log('[loadDirectory] fileNameIndex:', fileNameIndex.size, 'entries from', fopFiles.length, 'files');

      // Build call tree
      const treeRoots = buildFopTree(bindings, fopFiles);

      // Build usage index
      const usageIndex = buildUsageIndex(treeRoots, bindings, opts.lang);

      // Collect required databases from variable types
      const requiredDatabases = collectRequiredDatabases(fopFiles);

      // Update cache status for nodes
      const allPaths = getAllFopPaths(treeRoots);
      const cacheStats = cache.getStats(allPaths, opts.lang);

      setState(prev => ({
        ...prev,
        rootDir,
        bindings,
        fopFiles,
        fileNameIndex,
        treeRoots,
        usageIndex,
        cache,
        isLoading: false,
        requiredDatabases,
        cacheStats,
      }));

    } catch (err) {
      setState(prev => ({
        ...prev,
        isLoading: false,
        loadError: String(err),
      }));
    }
  }, [opts.lang]);

  /** Analyze selected entry points */
  const analyzeSelection = useCallback(async (
    selectedPaths: string[],
    forceRefresh = false,
  ) => {
    const { treeRoots, fopFiles, cache, analyses } = state;
    console.log('[analyzeSelection] start:', {
      selectedPaths,
      hasCache: !!cache,
      fopFilesCount: fopFiles.length,
      treeRootsCount: treeRoots.length,
      treeRootPaths: treeRoots.map(r => r.fopFile.relativePath).slice(0, 5),
    });
    if (!cache || fopFiles.length === 0) {
      console.warn('[analyzeSelection] aborted: no cache or no files');
      return;
    }

    abortRef.current = false;
    setState(prev => ({ ...prev, isAnalyzing: true }));

    // Filter to only the selected roots — try multiple matching strategies
    const selectedLower = new Set(selectedPaths.map(p => p.toLowerCase()));
    const selectedNames = new Set(selectedPaths.map(p => p.split('/').pop()?.toLowerCase()));

    let selectedRoots = treeRoots.filter(r => {
      const rPath = r.fopFile.relativePath;
      const rName = r.fopFile.filename.toLowerCase();
      // 1. Exact path match
      if (selectedPaths.includes(rPath)) return true;
      // 2. Case-insensitive path match
      if (selectedLower.has(rPath.toLowerCase())) return true;
      // 3. Filename match
      if (selectedNames.has(rName)) return true;
      // 4. ow-prefix: owfop/X → fop/X or vice versa
      for (const sp of selectedPaths) {
        const spLower = sp.toLowerCase();
        const rLower = rPath.toLowerCase();
        // owfop/X matches fop/X
        if (spLower.startsWith('ow') && rLower === spLower.slice(2)) return true;
        // fop/X matches owfop/X
        if (rLower.startsWith('ow') && spLower === rLower.slice(2)) return true;
      }
      return false;
    });

    // Fallback: if no tree roots matched, the FOP might not be an entry point.
    // Create ad-hoc root nodes from the fopFiles directly.
    if (selectedRoots.length === 0) {
      const selectedNames = new Set(selectedPaths.map(p => p.split('/').pop()?.toLowerCase()));
      for (const sp of selectedPaths) {
        const spLower = sp.toLowerCase();
        const spName = sp.split('/').pop()?.toLowerCase() ?? '';
        const fop = fopFiles.find(f =>
          f.relativePath === sp ||
          f.relativePath.toLowerCase() === spLower ||
          f.filename.toLowerCase() === spName ||
          (spLower.startsWith('ow') && f.relativePath.toLowerCase() === spLower.slice(2)) ||
          (f.relativePath.toLowerCase().startsWith('ow') && spLower === f.relativePath.toLowerCase().slice(2))
        );
        if (fop) {
          console.log('[analyzeSelection] creating ad-hoc root for:', fop.relativePath);
          selectedRoots.push({
            fopFile: fop,
            children: [],
            unresolvedCalls: [],
            missingCalls: [],
            depth: 0,
            cacheStatus: 'unanalyzed',
            usageCount: 0,
          });
        }
      }
    }

    const total = countUniqueNodes(selectedRoots);
    console.log('[analyzeSelection] selectedRoots:', selectedRoots.length, '| total nodes:', total, '| analystAgentId:', optsRef.current.analystAgentId);
    if (selectedRoots.length === 0) {
      console.warn('[analyzeSelection] no matching roots found!');
      setState(prev => ({ ...prev, isAnalyzing: false }));
      return;
    }
    optsRef.current.onActivityStart?.('fop-analyst', total);

    try {
      const currentOpts = optsRef.current;
      const emitter = currentOpts.getEmitter?.('fop-analyst');
      const result = await runFopAnalysis({
        fopFiles,
        roots: selectedRoots,
        varTables: currentOpts.varTables,
        usageIndex: state.usageIndex,  // pass usage index for binding context
        lang: currentOpts.lang,
        model: currentOpts.model,
        cache,
        forceRefresh,
        analystAgentId: currentOpts.analystAgentId,
        guidelinesAgentId: currentOpts.guidelinesAgentId,
        emitter,
        onProgress: ({ current, currentFop, phase, input, output }) => {
          const agentType = phase === 'guidelines' ? 'fop-guidelines' as const : 'fop-analyst' as const;
          // For KI phases, use activity callbacks
          if (phase === 'analyzing' || phase === 'guidelines') {
            optsRef.current.onActivityProgress?.(agentType, current, currentFop, input, output);
          }
          // For all phases, update diagram steps
          const phaseToStep: Record<string, string> = {
            'parsing': 'fop-parse', 'buffers': 'fop-buffers', 'fields': 'fop-fields',
            'local-check': 'fop-local-chk', 'analyzing': 'fop-analyst',
            'guidelines': 'fop-guidelines', 'cucumber': 'fop-cucumber',
          };
          const stepId = phaseToStep[phase];
          if (stepId && optsRef.current.onStepUpdate) {
            optsRef.current.onStepUpdate(stepId, currentFop, input, output);
          }
        },
        onAbort: () => abortRef.current,
      });

      const newAnalyses = new Map(analyses);
      for (const [path, analysis] of result.analyses.entries()) {
        newAnalyses.set(path, analysis);
      }

      optsRef.current.onActivityFinish?.('fop-analyst', result.errors.size > 0 ? 'error' : 'done');

      const allPaths = getAllFopPaths(treeRoots);
      const cacheStats = cache.getStats(allPaths, optsRef.current.lang);

      setState(prev => ({
        ...prev,
        analyses: newAnalyses,
        isAnalyzing: false,
        cacheStats,
      }));

    } catch (err) {
      opts.onActivityFinish?.('fop-analyst', 'error');
      setState(prev => ({ ...prev, isAnalyzing: false }));
    }
  }, [state, opts]);

  const selectFop = useCallback((path: string | null) => {
    if (!path) { setState(prev => ({ ...prev, selectedFopPath: null })); return; }
    const idx = state.fileNameIndex;
    // 1. Exact path or case-insensitive path
    const byPath = idx.get(path) || idx.get(path.toLowerCase());
    if (byPath) {
      setState(prev => ({ ...prev, selectedFopPath: byPath }));
      return;
    }
    // 2. By filename only (last segment)
    const fileName = path.split('/').pop()?.toLowerCase() ?? '';
    const byName = idx.get(fileName);
    if (byName) {
      console.log('[selectFop] by filename:', path, '→', byName);
      setState(prev => ({ ...prev, selectedFopPath: byName }));
      return;
    }
    // 3. Try ow-prefix: fb/X → owfb/X
    const parts = path.split('/');
    if (parts.length >= 2) {
      const owPath = ('ow' + parts[0] + '/' + parts.slice(1).join('/')).toLowerCase();
      const byOw = idx.get(owPath);
      if (byOw) {
        console.log('[selectFop] by ow-prefix:', path, '→', byOw);
        setState(prev => ({ ...prev, selectedFopPath: byOw }));
        return;
      }
    }
    console.log('[selectFop] not found:', path, '| fileName:', fileName, '| index size:', idx.size);
    setState(prev => ({ ...prev, selectedFopPath: path }));
  }, [state.fileNameIndex]);

  const clearCache = useCallback(async () => {
    const { cache, treeRoots } = state;
    if (!cache) return;
    await cache.clearAll();
    const allPaths = getAllFopPaths(treeRoots);
    const cacheStats = cache.getStats(allPaths, opts.lang);
    setState(prev => ({ ...prev, analyses: new Map(), cacheStats }));
  }, [state, opts.lang]);

  const abortAnalysis = useCallback(() => {
    abortRef.current = true;
  }, []);

  const updateAnalysis = useCallback((path: string, analysis: FopAnalysis) => {
    setState(prev => {
      const newAnalyses = new Map(prev.analyses);
      newAnalyses.set(path, analysis);
      return { ...prev, analyses: newAnalyses };
    });
  }, []);

  const getSelectedAnalysis = useCallback((): FopAnalysis | null => {
    if (!state.selectedFopPath) return null;
    return state.analyses.get(state.selectedFopPath) ?? null;
  }, [state.selectedFopPath, state.analyses]);

  const getSelectedUsage = useCallback((): FopUsage | null => {
    if (!state.selectedFopPath) return null;
    return state.usageIndex.get(state.selectedFopPath) ?? null;
  }, [state.selectedFopPath, state.usageIndex]);

  /** Remove saved FOP directory */
  const closeDirectory = useCallback(async () => {
    await clearFopDirectoryHandle();
    setState(INITIAL_STATE);
  }, []);

  const [restoring, setRestoring] = useState(true);
  const pollFingerprintRef = useRef<string>('');

  // Auto-restore saved FOP directory on mount
  useEffect(() => {
    let cancelled = false;
    loadFopDirectoryHandle().then(async (handle) => {
      if (!handle || cancelled) { if (!cancelled) setRestoring(false); return; }
      const ok = await verifyPermission(handle).catch(() => false);
      if (ok && !cancelled) {
        await loadDirectory(handle);
      }
      if (!cancelled) setRestoring(false);
    }).catch(() => { if (!cancelled) setRestoring(false); });
    return () => { cancelled = true; };
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // Auto-refresh changed FOP folders (polling + metadata fingerprint).
  useEffect(() => {
    if (!state.rootDir) return;
    if (!isFopAutoRefreshEnabled()) return;

    let cancelled = false;
    let running = false;
    const intervalMs = getFopAutoRefreshIntervalSeconds() * 1000;

    const tick = async () => {
      if (cancelled || running) return;
      if (state.isLoading || state.isAnalyzing) return;
      running = true;
      try {
        const fp = await scanDirectoryFingerprint(state.rootDir, '');
        if (!pollFingerprintRef.current) {
          pollFingerprintRef.current = fp;
          return;
        }
        if (fp !== pollFingerprintRef.current) {
          pollFingerprintRef.current = fp;
          await loadDirectory(state.rootDir);
        }
      } catch {
        // Ignore transient read errors (permission race, file lock)
      } finally {
        running = false;
      }
    };

    void tick();
    const id = window.setInterval(() => { void tick(); }, intervalMs);
    return () => {
      cancelled = true;
      window.clearInterval(id);
    };
  }, [state.rootDir, state.isLoading, state.isAnalyzing, loadDirectory]);

  return {
    ...state,
    isRestoring: restoring,
    loadDirectory,
    closeDirectory,
    analyzeSelection,
    selectFop,
    updateAnalysis,
    clearCache,
    abortAnalysis,
    getSelectedAnalysis,
    getSelectedUsage,
  };
}

// ── Helpers ───────────────────────────────────────────────────

async function scanDirectory(
  dir: FileSystemDirectoryHandle,
  prefix: string,
  results: { relativePath: string; content: string }[],
): Promise<void> {
  for await (const [name, handle] of dir.entries()) {
    // Skip hidden directories (like .fopanalyzer) and output directories
    if (name.startsWith('.') || name === 'Konzept') continue;

    if (handle.kind === 'directory') {
      const subDir = await dir.getDirectoryHandle(name);
      const newPrefix = prefix ? `${prefix}/${name}` : name;
      await scanDirectory(subDir, newPrefix, results);
    } else {
      const certainlyFop = isCertainFopFile(name);
      const certainlyNotFop = isCertainlyNotFop(name);
      if (certainlyNotFop) continue;

      const file = await (handle as FileSystemFileHandle).getFile();

      // If not certain by name, check first line for ..!interpreter marker
      if (!certainlyFop) {
        // Read only first 200 chars — cheap peek to detect FOP header
        const slice = file.slice(0, 200);
        const peek = await slice.text();
        if (!peek.includes('!interpreter')) continue;
      }

      const content = await file.text();
      const relativePath = prefix ? `${prefix}/${name}` : name;
      results.push({ relativePath, content });
    }
  }
}

async function scanDirectoryFingerprint(
  dir: FileSystemDirectoryHandle,
  prefix: string,
): Promise<string> {
  const rows: string[] = [];
  for await (const [name, handle] of dir.entries()) {
    if (name.startsWith('.') || name === 'Konzept') continue;
    if (handle.kind === 'directory') {
      const subDir = await dir.getDirectoryHandle(name);
      const newPrefix = prefix ? `${prefix}/${name}` : name;
      rows.push(await scanDirectoryFingerprint(subDir, newPrefix));
      continue;
    }

    const certainlyFop = isCertainFopFile(name);
    const certainlyNotFop = isCertainlyNotFop(name);
    if (certainlyNotFop) continue;

    const file = await (handle as FileSystemFileHandle).getFile();
    if (!certainlyFop) {
      const peek = await file.slice(0, 200).text();
      if (!peek.includes('!interpreter')) continue;
    }
    const relativePath = prefix ? `${prefix}/${name}` : name;
    rows.push(`${relativePath}|${file.size}|${file.lastModified}`);
  }
  rows.sort();
  return rows.join('\n');
}

/** Files that are certainly FOP by their extension — no need to peek content */
function isCertainFopFile(name: string): boolean {
  // No extension at all → FO1 source (e.g. "TABLEEREN", "DBCHOOSER")
  if (!name.includes('.')) return true;
  // Explicit FOP extensions
  const CERTAIN_FOP_EXTS = ['.FO2', '.FO1', '.FO', '.EV', '.TAB', '.ME', '.BKOPF', '.BFUSS'];
  const ext = '.' + name.split('.').pop()!.toUpperCase();
  return CERTAIN_FOP_EXTS.includes(ext);
}

/** Files that are certainly NOT FOP — skip without reading */
function isCertainlyNotFop(name: string): boolean {
  if (name.toUpperCase() === 'FOP.TXT') return true;  // config file, not a program
  if (!name.includes('.')) return false; // no extension → might be FO1

  const ext = '.' + name.split('.').pop()!.toUpperCase();
  const NON_FOP = [
    '.JSON', '.XML', '.HTML', '.CSS', '.JS', '.TS', '.MD', '.PDF',
    '.XLSX', '.XLS', '.CSV', '.ZIP', '.PNG', '.JPG', '.JPEG', '.GIF',
    '.JAVA', '.CLASS', '.JAR', '.GROOVY', '.SH', '.BAT', '.EXE',
    '.DEF', '.INI', '.CFG', '.LOG', '.AUS', '.ERR', '.INDEX',
    '.LANGUAGE', '.PROPERTIES', '.FOPANALYZER',
  ];
  return NON_FOP.includes(ext);
}

function collectRequiredDatabases(fopFiles: FopFile[]): number[] {
  const dbs = new Set<number>();
  for (const f of fopFiles) {
    for (const v of f.variables) {
      if (v.referencedDatabase) dbs.add(v.referencedDatabase);
    }
  }
  return Array.from(dbs).sort((a, b) => a - b);
}

function countUniqueNodes(roots: FopTreeNode[]): number {
  const seen = new Set<string>();
  function count(node: FopTreeNode): void {
    seen.add(node.fopFile.relativePath);
    for (const child of node.children) count(child);
  }
  for (const root of roots) count(root);
  return seen.size;
}
