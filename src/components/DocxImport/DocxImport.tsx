/**
 * @module DocxImport
 * Document import panel for parsing .docx / Confluence source files into feature packages.
 *
 * Key responsibilities:
 * - Parses uploaded .docx files (or Confluence HTML) into ParsedFeaturePackage objects,
                            onClick={() => setDescriptionModal({
                              title: `${chNum} ${entry.text}`.trim(),
                              text: pkg?.sourceText || '',
                            })}
 * - Drives per-package AI Gherkin generation via the myforterro agent API, including
 *   table identification (local or KI) and prompt assembly.
 * - Reports live generation progress (current package, token counts, table-ID path) to the
 *   parent via onBulkActivityChange for the AgentStatusBar and ProcessDiagram.
 * - Supports loading a single feature into the editor or triggering a full folder creation
 *   with all generated .feature files via onCreateWithAgent.
 * @prop {(feature: FeatureInput) => void} onLoadToEditor - Loads a single feature into the main editor.
 * @prop {string} model - AI model identifier used for generation calls.
 * @prop {TableDef[]} tables - Available table definitions for context-aware table identification.
 */
import { useState, useRef, useMemo, useEffect } from 'react';
import type { FeatureInput, ParsedFeaturePackage, SkippedChapter, TableDef, TocEntry } from '../../types/gherkin';

export interface TocInfo {
  toc: TocEntry[];
  tocNumbers: string[];
}
import { parseDocx, downloadDocxTemplate } from '../../lib/docxParser';
import { parseConfluenceDoc } from '../../lib/confluenceParser';
import { hasErrors } from '../../lib/featureValidation';
import { validateFeature } from '../../lib/featureValidation';
import { getAllProfiles, getActiveProfileId, setActiveProfileId } from '../../lib/parseProfile';
import { useTranslation, type TranslationFn } from '../../i18n';
import { parseRatingResponse, DEFAULT_RATING_PROMPT, estimateTokens } from '../../lib/aiPrompt';
import type { AiPromptRating } from '../../lib/aiPrompt';
import { chatWithAgentSync, runWithAgentSync, isLoggedIn, getValidToken, getStoredTenantId, uploadMftFile, TokenLimitError, RateLimitError } from '../../lib/myforterroApi';
import type { MessageAttachment } from '../../lib/myforterroApi';
import { ensureWorkspaceFileUpload } from '../../lib/fileUpload';
import { updateLastResponseSummary } from '../../lib/tokenHistory';
import { generatePackage } from '../../lib/generatePackage';
import type { WorkflowEmitter } from '../../lib/workflowEmitter';
import { NULL_EMITTER } from '../../lib/workflowEmitter';
import { getPhaseLabel } from '../../lib/workflowLabels';
import { mergeFeatureGroup } from '../../lib/mergeFeatureGroup';
import { makeFeatureGuid } from '../../lib/featureGuid';
import { getForceKiTableId } from '../../lib/settings';
import { ConfirmDialog } from '../ConfirmDialog/ConfirmDialog';
import styles from './DocxImport.module.css';

/** Realisierung value that indicates the customer handles this package (no tests needed from us). */
const KUNDE_REALISIERUNG = /^kunde$/i;

/** A feature counts as "already generated" only if it has scenarios with actual steps.
 *  Scenarios parsed from the source text (e.g. headings containing "Szenario") may be empty shells. */
function hasGeneratedScenarios(feature: FeatureInput): boolean {
  return feature.scenarios.some((s) => s.steps.length > 0);
}

/** localStorage key for „user has already seen or dismissed the token-limit banner today" */
const TOKEN_LIMIT_BANNER_HANDLED_KEY = 'cucumbergnerator_token_limit_banner_handled';

function todayIso(): string {
  return new Date().toISOString().slice(0, 10);
}

function wasTokenLimitBannerHandledToday(): boolean {
  try {
    return localStorage.getItem(TOKEN_LIMIT_BANNER_HANDLED_KEY) === todayIso();
  } catch {
    return false;
  }
}

function markTokenLimitBannerHandledToday(): void {
  try {
    localStorage.setItem(TOKEN_LIMIT_BANNER_HANDLED_KEY, todayIso());
  } catch {
    // localStorage unavailable — ignore
  }
}

interface ConceptPackageInput {
  id: string;
  chapter: string;
  heading: string;
  sourceText: string;
}

interface ConceptChunkResult {
  packageSummaries: Array<{
    id: string;
    process: string;
    objects: string[];
    keywords: string[];
  }>;
  relations: Array<{
    from: string;
    to: string;
    relation: string;
    confidence?: number;
    evidence?: string;
  }>;
  clusters: Array<{
    id: string;
    name: string;
    members: string[];
    reason?: string;
  }>;
  gaps: Array<{
    severity: 'low' | 'medium' | 'high';
    message: string;
    related?: string[];
  }>;
}

interface ConceptRelationGap {
  severity: 'low' | 'medium' | 'high';
  message: string;
  related?: string[];
}

interface ChapterRelationLink {
  fromId: string;
  toId: string;
  fromLabel: string;
  toLabel: string;
  relation: string;
  confidence?: number;
  evidence?: string;
  source: 'ai' | 'manual';
}

function normalizeRelationLabel(value: string, t: TranslationFn): string {
  const key = value.trim().toLowerCase();
  if (key === 'depends_on') return t('docx.relationDependsOn');
  if (key === 'same_data') return t('docx.relationSameData');
  if (key === 'same_process') return t('docx.relationSameProcess');
  if (key === 'precondition_for') return t('docx.relationPreconditionFor');
  if (key === 'cluster') return t('docx.relationBelongsTo');
  if (key === 'belongs_to') return t('docx.relationBelongsTo');
  if (key === 'manual-link') return t('docx.relationBelongsTo');
  return value;
}

function getRelationTypeKey(value: string): 'belongs' | 'depends' | 'precondition' | 'other' {
  const key = value.trim().toLowerCase();
  if (key.includes('gehoert zu') || key.includes('belongs to') || key.includes('cluster')) return 'belongs';
  if (key.includes('haengt ab') || key.includes('depends on') || key.includes('depends_on')) return 'depends';
  if (key.includes('voraussetzung') || key.includes('precondition')) return 'precondition';
  return 'other';
}

function relationKey(a: string, b: string): string {
  return a < b ? `${a}::${b}` : `${b}::${a}`;
}

function parseJsonLoose<T>(raw: string): T | null {
  const trimmed = raw.trim();
  const fenced = trimmed.match(/^```(?:json)?\s*([\s\S]*?)\s*```$/i)?.[1]?.trim();
  const source = fenced || trimmed;
  try {
    return JSON.parse(source) as T;
  } catch {
    const start = source.indexOf('{');
    const end = source.lastIndexOf('}');
    if (start >= 0 && end > start) {
      try {
        return JSON.parse(source.slice(start, end + 1)) as T;
      } catch {
        return null;
      }
    }
    return null;
  }
}

function chunkConceptPackages(input: ConceptPackageInput[], maxChars = 18000, maxItems = 6): ConceptPackageInput[][] {
  const chunks: ConceptPackageInput[][] = [];
  let current: ConceptPackageInput[] = [];
  let charCount = 0;
  for (const pkg of input) {
    const len = pkg.sourceText.length;
    const overItemCount = current.length >= maxItems;
    const overCharCount = current.length > 0 && charCount + len > maxChars;
    if (overItemCount || overCharCount) {
      chunks.push(current);
      current = [];
      charCount = 0;
    }
    current.push(pkg);
    charCount += len;
  }
  if (current.length > 0) chunks.push(current);
  return chunks;
}

function normalizeConceptChunkResult(raw: unknown): ConceptChunkResult | null {
  if (!raw || typeof raw !== 'object') return null;
  const src = raw as Partial<ConceptChunkResult>;

  const packageSummaries = Array.isArray(src.packageSummaries)
    ? src.packageSummaries
      .filter((s): s is NonNullable<ConceptChunkResult['packageSummaries']>[number] => !!s && typeof s === 'object')
      .map((s) => ({
        id: typeof s.id === 'string' ? s.id : '',
        process: typeof s.process === 'string' ? s.process : '',
        objects: Array.isArray(s.objects) ? s.objects.filter((v): v is string => typeof v === 'string') : [],
        keywords: Array.isArray(s.keywords) ? s.keywords.filter((v): v is string => typeof v === 'string') : [],
      }))
      .filter((s) => s.id.length > 0)
    : [];

  const relations = Array.isArray(src.relations)
    ? src.relations
      .filter((r): r is NonNullable<ConceptChunkResult['relations']>[number] => !!r && typeof r === 'object')
      .map((r) => ({
        from: typeof r.from === 'string' ? r.from : '',
        to: typeof r.to === 'string' ? r.to : '',
        relation: typeof r.relation === 'string' ? r.relation : '',
        confidence: typeof r.confidence === 'number' ? r.confidence : undefined,
        evidence: typeof r.evidence === 'string' ? r.evidence : undefined,
      }))
      .filter((r) => r.from.length > 0 && r.to.length > 0 && r.relation.length > 0)
    : [];

  const clusters = Array.isArray(src.clusters)
    ? src.clusters
      .filter((c): c is NonNullable<ConceptChunkResult['clusters']>[number] => !!c && typeof c === 'object')
      .map((c) => ({
        id: typeof c.id === 'string' ? c.id : '',
        name: typeof c.name === 'string' ? c.name : '',
        members: Array.isArray(c.members) ? c.members.filter((v): v is string => typeof v === 'string') : [],
        reason: typeof c.reason === 'string' ? c.reason : undefined,
      }))
      .filter((c) => c.id.length > 0 || c.members.length > 0)
    : [];

  const gaps = Array.isArray(src.gaps)
    ? src.gaps
      .filter((g): g is NonNullable<ConceptChunkResult['gaps']>[number] => !!g && typeof g === 'object')
      .map((g) => ({
        severity: g.severity === 'low' || g.severity === 'medium' || g.severity === 'high' ? g.severity : 'medium',
        message: typeof g.message === 'string' ? g.message : '',
        related: Array.isArray(g.related) ? g.related.filter((v): v is string => typeof v === 'string') : undefined,
      }))
      .filter((g) => g.message.length > 0)
    : [];

  return { packageSummaries, relations, clusters, gaps };
}

function combineConceptChunkResults(parts: ConceptChunkResult[]): ConceptChunkResult {
  return {
    packageSummaries: parts.flatMap((p) => p.packageSummaries || []),
    relations: parts.flatMap((p) => p.relations || []),
    clusters: parts.flatMap((p) => p.clusters || []),
    gaps: parts.flatMap((p) => p.gaps || []),
  };
}

interface DocxImportProps {
  onLoadToEditor: (feature: FeatureInput) => void;
  model: string;
  learningHints?: string;
  tables: TableDef[];
  onTablesChange: (tables: TableDef[]) => void;
  showAi: boolean;
  /** Called after AI generation is done — creates folder + agent + saves .feature files */
  onCreateWithAgent?: (packages: ParsedFeaturePackage[], fileName: string, tocInfo?: TocInfo) => Promise<void>;
  /** API agent ID for AI calls (from Standard-Agent or folder agent) */
  agentApiId?: string | null;
  /** Current project workspace, used for uploaded-file caching and the Uploaded folder. */
  rootHandle?: FileSystemDirectoryHandle | null;
  /** GUIDs of feature files that already exist on disk */
  existingFeatureGuids?: Set<string>;
  /** Workflow timeline emitter for the bulk run (from useAgentActivity.getEmitter('bulk')). */
  getBulkEmitter?: () => WorkflowEmitter;
  /** UI language. */
  lang?: 'de' | 'en';
  /** Called when bulk AI generation starts/progresses/finishes — for AgentStatusBar */
  onBulkActivityChange?: (info: {
    isRunning: boolean;
    current: number;
    total: number;
    currentItem: string;
    inputSnapshot?: string;
    outputSoFar?: string;
    tableIdPath?: 'local' | 'ki' | 'none';
    identifiedTables?: string[];
    fieldCount?: number;
    tableIdRequest?: string;
    tableIdRawResponse?: string;
    /** The full prompt sent to KI (table contexts + generation request) */
    gherkinRequest?: string;
    /** Formatted table field lists included in the prompt */
    tableContext?: string;
    /** When true, only update the Agent Modal inputSnapshot — no process flow changes */
    promptUpdate?: boolean;
    /** When true, tables were just identified — update diagram immediately (before Gherkin gen) */
    tablesIdentified?: boolean;
    /** When true, table ID request was just sent — show in Agent Modal before response */
    tableIdStarted?: boolean;
    /** Pre-detected tables to use directly in next generation (skips re-detection) */
    forcedRelevantTables?: import('../../types/gherkin').TableDef[];
  }) => void;
}

export function DocxImport({
  onLoadToEditor,
  model,
  learningHints,
  tables,
  onTablesChange: _onTablesChange,
  showAi,
  onCreateWithAgent,
  agentApiId,
  rootHandle,
  existingFeatureGuids,
  onBulkActivityChange,
  getBulkEmitter,
}: DocxImportProps) {
  const { t, lang } = useTranslation();

  // Check if a package already exists on disk via GUID match
  const pkgExistsOnDisk = (pkg: ParsedFeaturePackage, chapterNum?: string): boolean => {
    if (!existingFeatureGuids || existingFeatureGuids.size === 0) return false;
    const name = pkg.feature.name || pkg.sourceHeading || '';
    const guid = makeFeatureGuid(chapterNum || '', name);
    return existingFeatureGuids.has(guid);
  };
  const [packages, setPackages] = useState<ParsedFeaturePackage[]>([]);
  const [skipped, setSkipped] = useState<SkippedChapter[]>([]);
  const [toc, setToc] = useState<TocEntry[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [activeProfileId, setProfileId] = useState(() => getActiveProfileId());
  const fileRef = useRef<HTMLInputElement>(null);
  const [docxFileName, setDocxFileName] = useState('');
  const [sourceFile, setSourceFile] = useState<File | null>(null);
  const sourceAttachmentsRef = useRef<{ file: File; tenantId: string; attachments: MessageAttachment[] } | null>(null);

  const ensureSourceAttachments = async (): Promise<MessageAttachment[]> => {
    if (!sourceFile) return [];
    const tenantId = getStoredTenantId();
    if (!tenantId) throw new Error('Kein Tenant ausgewählt. Bitte zuerst einen Tenant wählen.');
    const cached = sourceAttachmentsRef.current;
    if (cached?.file === sourceFile && cached.tenantId === tenantId) return cached.attachments;
    const attachments = await ensureWorkspaceFileUpload(sourceFile, {
      rootHandle,
      tenantId,
      upload: uploadMftFile,
    });
    sourceAttachmentsRef.current = { file: sourceFile, tenantId, attachments };
    return attachments;
  };

  // Checked package headings (for TOC view)
  const [checkedHeadings, setCheckedHeadings] = useState<Set<string>>(new Set());

  // Description modal for TOC package details
  const [descriptionModal, setDescriptionModal] = useState<{ title: string; text: string } | null>(null);

  // Relation model rendered directly in the TOC tree (instead of graph canvas)
  const [chapterLinks, setChapterLinks] = useState<ChapterRelationLink[]>([]);
  const [relationGaps, setRelationGaps] = useState<ConceptRelationGap[]>([]);
  const [relationSummaryOpen, setRelationSummaryOpen] = useState(true);
  const [warningPanelOpen, setWarningPanelOpen] = useState(false);
  const [warningFocusId, setWarningFocusId] = useState<string | null>(null);
  const [dragLinkFromId, setDragLinkFromId] = useState<string | null>(null);
  const [lastRemovedLink, setLastRemovedLink] = useState<ChapterRelationLink | null>(null);
  const undoDeleteTimerRef = useRef<number | null>(null);
  const dragInteractionBlockUntilRef = useRef(0);
  const postDropShieldTimerRef = useRef<number | null>(null);
  const [postDropShieldActive, setPostDropShieldActive] = useState(false);

  // AI generation state
  const [aiError] = useState<string | null>(null);
  const [aiProgress, setAiProgress] = useState({ current: 0, total: 0 });
  const cancelRef = useRef(false);

  // Token-limit recovery state: when the daily MyForterro quota is hit, show a
  // one-time info banner so the user knows generation stopped and why.
  const [tokenLimitHit, setTokenLimitHit] = useState(false);

  // Listen for `token-limit-reached` events so the user is informed when the
  // daily MyForterro limit is hit. Day-suppression ensures this only fires once.
  useEffect(() => {
    const handler = () => {
      if (wasTokenLimitBannerHandledToday()) return;
      setError(t('docx.tokenLimitReached'));
      setTokenLimitHit(true);
      markTokenLimitBannerHandledToday();
    };
    window.addEventListener('token-limit-reached', handler);
    return () => window.removeEventListener('token-limit-reached', handler);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [t]);

  // Raw AI responses per package heading (for debugging)
  const [rawResponses, setRawResponses] = useState<Record<string, string>>({});
  const [expandedRaw, setExpandedRaw] = useState<Set<string>>(new Set());

  // Per-card AI rating state
  const [ratings, setRatings] = useState<Record<string, AiPromptRating>>({});
  const [ratingError, setRatingError] = useState<string | null>(null);
  const [isSendingToAgent] = useState(false);
  // Agent API ID comes from the Standard-Agent (passed as prop)

  const profiles = getAllProfiles();
  const activeProfile = profiles.find((p) => p.id === activeProfileId) ?? profiles[0];

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setSourceFile(file);
    sourceAttachmentsRef.current = null;
    setLoading(true);
    setError('');
    setDocxFileName(file.name.replace(/\.(docx|dotm|doc)$/i, ''));

    try {
      const isConfluenceProfile = activeProfile.id === 'confluence-testdaten';
      const isDocFile = /\.doc$/i.test(file.name) && !/\.docx$/i.test(file.name);
      const result = (isConfluenceProfile || isDocFile)
        ? await parseConfluenceDoc(file)
        : await parseDocx(file, activeProfile);
      setPackages(result.features);
      setSkipped(result.skippedChapters);
      setToc(result.toc);
      setChapterLinks([]);
      setRelationGaps([]);
      setRelationError(null);
      setWarningFocusId(null);
      setWarningPanelOpen(false);
      setRatings({});
      setRatingError(null);
      // Pre-select packages where WE (abas/Berater) do the work — not the customer.
      // Exclude: very short sourceText (< 80 chars), Realisierung = "Kunde", or already exists on disk.
      const autoKeys: string[] = [];
      const usedPkgs = new Set<number>();
      // Compute chapter numbers inline for existence check
      const chCounters: number[] = [];
      const chNums = result.toc.map((e) => {
        while (chCounters.length < e.level) chCounters.push(0);
        chCounters[e.level - 1]++;
        chCounters.splice(e.level);
        return chCounters.join('.');
      });
      result.toc.forEach((entry, tocIdx) => {
        if (entry.kind !== 'package') return;
        const pkgIdx = result.features.findIndex((p, pi) => p.sourceHeading === entry.text && !usedPkgs.has(pi));
        if (pkgIdx < 0) return;
        usedPkgs.add(pkgIdx);
        const pkg = result.features[pkgIdx];
        if (pkg.sourceText.trim().length >= 80
          && !KUNDE_REALISIERUNG.test(pkg.kundeField ?? '')
          && !pkgExistsOnDisk(pkg, chNums[tocIdx])) {
          autoKeys.push(`toc#${tocIdx}`);
        }
      });
      setCheckedHeadings(new Set(autoKeys));
      if (result.features.length === 0 && result.skippedChapters.length === 0) {
        setError(t('docx.noFeatures'));
      } else if (result.features.length > 1) {
        setAutoAnalyzePrompt({ open: true, packages: result.features });
      }
    } catch (err) {
      setError(t('docx.readError', { error: err instanceof Error ? err.message : 'Unknown' }));
      setPackages([]);
      setSkipped([]);
      setToc([]);
    } finally {
      setLoading(false);
      if (fileRef.current) fileRef.current.value = '';
    }
  };

  const handleProfileChange = async (newId: string) => {
    setProfileId(newId);
    setActiveProfileId(newId);
    if (packages.length > 0 || skipped.length > 0) {
      setPackages([]);
      setSkipped([]);
      setToc([]);
      setError(t('docx.profileChanged'));
    }
  };

  const handleClear = () => {
    setPackages([]);
    setSkipped([]);
    setToc([]);
    setError('');
    setRatings({});
    setRatingError(null);
    setCheckedHeadings(new Set());
    setChapterLinks([]);
    setRelationGaps([]);
    setRelationError(null);
    setWarningFocusId(null);
    setWarningPanelOpen(false);
    setAutoAnalyzePrompt({ open: false, packages: [] });
  };

  const closeAutoAnalyzePrompt = () => {
    setAutoAnalyzePrompt({ open: false, packages: [] });
  };

  const handleAutoAnalyzeYes = () => {
    const pkgs = autoAnalyzePrompt.packages;
    closeAutoAnalyzePrompt();
    void analyzeRelations(pkgs);
  };

  const handleAutoAnalyzeWithout = () => {
    closeAutoAnalyzePrompt();
  };

  const handleAutoAnalyzeAbort = () => {
    closeAutoAnalyzePrompt();
  };

  /** Compute chapter numbers (e.g. "1.", "1.1", "2.3.1") for each TOC entry based on heading level. */
  const tocNumbers = useMemo(() => {
    const counters: number[] = [];
    return toc.map((entry) => {
      const lvl = entry.level;
      while (counters.length < lvl) counters.push(0);
      counters[lvl - 1]++;
      counters.splice(lvl); // reset deeper levels
      return counters.join('.');
    });
  }, [toc]);

  const selectAllPackages = () => {
    const allPkgKeys = toc.map((e, i) => ({ kind: e.kind, key: `toc#${i}` })).filter((e) => e.kind === 'package').map((e) => e.key);
    setCheckedHeadings(new Set(allPkgKeys));
  };

  const deselectAllPackages = () => {
    setCheckedHeadings(new Set());
  };

  // Central mapping: TOC index → package array index (by sourceHeading text match with consumed-set)
  const tocToPkgIdx = useMemo(() => {
    const map = new Map<number, number>();
    const usedPkgs = new Set<number>();
    toc.forEach((entry, tocIdx) => {
      if (entry.kind !== 'package') return;
      const pkgIdx = packages.findIndex((p, pi) => p.sourceHeading === entry.text && !usedPkgs.has(pi));
      if (pkgIdx >= 0) {
        usedPkgs.add(pkgIdx);
        map.set(tocIdx, pkgIdx);
      }
    });
    return map;
  }, [toc, packages, tocNumbers]);

  const abasPackageKeys = useMemo(() => {
    const keys: string[] = [];
    for (const [tocIdx, pkgIdx] of tocToPkgIdx) {
      const pkg = packages[pkgIdx];
      const isKunde = KUNDE_REALISIERUNG.test(pkg?.kundeField ?? '');
      if (!isKunde) keys.push(`toc#${tocIdx}`);
    }
    return keys;
  }, [tocToPkgIdx, packages]);

  const kundePackageKeys = useMemo(() => {
    const keys: string[] = [];
    for (const [tocIdx, pkgIdx] of tocToPkgIdx) {
      const pkg = packages[pkgIdx];
      const isKunde = KUNDE_REALISIERUNG.test(pkg?.kundeField ?? '');
      if (isKunde) keys.push(`toc#${tocIdx}`);
    }
    return keys;
  }, [tocToPkgIdx, packages]);

  const toggleSubsetSelection = (keys: string[]) => {
    if (keys.length === 0) return;
    setCheckedHeadings((prev) => {
      const allSelected = keys.every((key) => prev.has(key));
      const next = new Set(prev);
      if (allSelected) {
        for (const key of keys) next.delete(key);
      } else {
        for (const key of keys) next.add(key);
      }
      return next;
    });
  };

  const packageInfoById = useMemo(() => {
    const map = new Map<string, { pkg: ParsedFeaturePackage; tocIdx: number; chapterNum: string; heading: string }>();
    for (const [tocIdx, pkgIdx] of tocToPkgIdx) {
      const pkg = packages[pkgIdx];
      if (!pkg) continue;
      const chapterNum = tocNumbers[tocIdx] || '';
      const heading = toc[tocIdx]?.text || pkg.sourceHeading;
      const id = `${chapterNum}#${heading}`;
      map.set(id, { pkg, tocIdx, chapterNum, heading });
    }
    return map;
  }, [tocToPkgIdx, packages, tocNumbers, toc]);

  const checkKeyToRelationId = useMemo(() => {
    const map = new Map<string, string>();
    for (const [tocIdx] of tocToPkgIdx) {
      const chapterNum = tocNumbers[tocIdx] || '';
      const heading = toc[tocIdx]?.text || '';
      map.set(`toc#${tocIdx}`, `${chapterNum}#${heading}`);
    }
    return map;
  }, [tocToPkgIdx, tocNumbers, toc]);

  const relationIdToCheckKey = useMemo(() => {
    const map = new Map<string, string>();
    for (const [k, v] of checkKeyToRelationId) map.set(v, k);
    return map;
  }, [checkKeyToRelationId]);

  const linkedComponents = useMemo(() => {
    const selectedIds = new Set<string>();
    for (const checkKey of checkedHeadings) {
      const relationId = checkKeyToRelationId.get(checkKey);
      if (relationId) selectedIds.add(relationId);
    }

    const adjacency = new Map<string, Set<string>>();
    for (const id of selectedIds) adjacency.set(id, new Set());
    for (const link of chapterLinks) {
      if (!selectedIds.has(link.fromId) || !selectedIds.has(link.toId)) continue;
      adjacency.get(link.fromId)?.add(link.toId);
      adjacency.get(link.toId)?.add(link.fromId);
    }

    const visited = new Set<string>();
    const components: string[][] = [];
    for (const id of selectedIds) {
      if (visited.has(id)) continue;
      const stack = [id];
      const group: string[] = [];
      visited.add(id);
      while (stack.length > 0) {
        const current = stack.pop()!;
        group.push(current);
        const neighbors = adjacency.get(current);
        if (!neighbors) continue;
        for (const n of neighbors) {
          if (visited.has(n)) continue;
          visited.add(n);
          stack.push(n);
        }
      }
      components.push(group);
    }
    return components;
  }, [checkedHeadings, checkKeyToRelationId, chapterLinks]);

  const relationComponentsById = useMemo(() => {
    const packageIds = new Set<string>(Array.from(packageInfoById.keys()));
    const adjacency = new Map<string, Set<string>>();
    for (const id of packageIds) adjacency.set(id, new Set());
    for (const link of chapterLinks) {
      if (!packageIds.has(link.fromId) || !packageIds.has(link.toId)) continue;
      adjacency.get(link.fromId)?.add(link.toId);
      adjacency.get(link.toId)?.add(link.fromId);
    }

    const visited = new Set<string>();
    const componentById = new Map<string, string[]>();
    for (const id of packageIds) {
      if (visited.has(id)) continue;
      const stack = [id];
      const component: string[] = [];
      visited.add(id);
      while (stack.length > 0) {
        const current = stack.pop()!;
        component.push(current);
        const neighbors = adjacency.get(current);
        if (!neighbors) continue;
        for (const next of neighbors) {
          if (visited.has(next)) continue;
          visited.add(next);
          stack.push(next);
        }
      }
      const sortedComponent = component.sort((a, b) => {
        const aInfo = packageInfoById.get(a);
        const bInfo = packageInfoById.get(b);
        return (aInfo?.tocIdx ?? 0) - (bInfo?.tocIdx ?? 0);
      });
      for (const member of sortedComponent) componentById.set(member, sortedComponent);
    }
    return componentById;
  }, [chapterLinks, packageInfoById]);

  const orderedRelationComponents = useMemo(() => {
    const seenAnchors = new Set<string>();
    const components: string[][] = [];
    for (const component of relationComponentsById.values()) {
      const anchor = component[0];
      if (seenAnchors.has(anchor)) continue;
      seenAnchors.add(anchor);
      if (component.length > 1) components.push(component);
    }
    return components;
  }, [relationComponentsById]);

  const orderRelationComponent = (component: string[]): string[] => {
    if (component.length <= 1) return component;

    const memberSet = new Set(component);
    const adjacency = new Map<string, string[]>();
    for (const member of component) adjacency.set(member, []);
    for (const link of chapterLinks) {
      if (!memberSet.has(link.fromId) || !memberSet.has(link.toId)) continue;
      adjacency.get(link.fromId)?.push(link.toId);
      adjacency.get(link.toId)?.push(link.fromId);
    }

    const sortedByIndex = [...component].sort((a, b) => {
      const aInfo = packageInfoById.get(a);
      const bInfo = packageInfoById.get(b);
      return (aInfo?.tocIdx ?? 0) - (bInfo?.tocIdx ?? 0);
    });

    const endpoints = sortedByIndex.filter((id) => (adjacency.get(id)?.length ?? 0) <= 1);
    const startId = endpoints[0] ?? sortedByIndex[0];
    const ordered = [startId];
    const visited = new Set([startId]);

    while (ordered.length < component.length) {
      const currentId = ordered[ordered.length - 1];
      const nextId = (adjacency.get(currentId) ?? [])
        .filter((candidate) => !visited.has(candidate))
        .sort((a, b) => {
          const aInfo = packageInfoById.get(a);
          const bInfo = packageInfoById.get(b);
          return (aInfo?.tocIdx ?? 0) - (bInfo?.tocIdx ?? 0);
        })[0];

      if (!nextId) {
        const remaining = sortedByIndex.find((id) => !visited.has(id));
        if (!remaining) break;
        ordered.push(remaining);
        visited.add(remaining);
        continue;
      }

      ordered.push(nextId);
      visited.add(nextId);
    }

    return ordered;
  };

  const relationGroupSummaryById = useMemo(() => {
    const map = new Map<string, string>();
    for (const [id, component] of relationComponentsById) {
      if (component.length <= 1) continue;
      const labels = orderRelationComponent(component)
        .map((memberId) => packageInfoById.get(memberId))
        .filter((v): v is NonNullable<typeof v> => !!v)
        .map((m) => m.chapterNum)
        .filter(Boolean);
      map.set(id, labels.join(' → '));
    }
    return map;
  }, [relationComponentsById, packageInfoById, chapterLinks]);

  const getRelationCheckKeysForComponent = (relationId: string): string[] => {
    const component = relationComponentsById.get(relationId) ?? [relationId];
    return component
      .map((id) => relationIdToCheckKey.get(id))
      .filter((key): key is string => !!key);
  };

  // All checked packages — linked components are merged to one feature automatically.
  const checkedPackages = useMemo(() => {
    const result: ParsedFeaturePackage[] = [];

    for (const component of linkedComponents) {
      const members = component
        .map((id) => packageInfoById.get(id))
        .filter((v): v is NonNullable<typeof v> => !!v)
        .sort((a, b) => a.tocIdx - b.tocIdx);

      if (members.length === 0) continue;
      if (members.length === 1) {
        result.push(members[0].pkg);
        continue;
      }

      const chapterList = members.map((m) => m.chapterNum).filter(Boolean).join(' + ');
      const heading = chapterList
        ? `${t('docx.linkedChapters')}: ${chapterList}`
        : t('docx.linkedChapters');
      result.push(mergeFeatureGroup(heading, members.map((m) => m.pkg)));
    }

    return result;
  }, [linkedComponents, packageInfoById, t]);

  // Map package array index → unique TOC key (chapter number makes it unique)
  const pkgIdxToUniqueKey = useMemo(() => {
    const map = new Map<number, string>();
    for (const [tocIdx, pkgIdx] of tocToPkgIdx) {
      map.set(pkgIdx, `${tocNumbers[tocIdx]}#${toc[tocIdx].text}`);
    }
    return map;
  }, [toc, tocToPkgIdx, tocNumbers]);

  // Resolve unique key for a package (by finding its index in the packages array)
  const getUniqueKeyForPkg = (pkg: ParsedFeaturePackage): string => {
    const idx = packages.indexOf(pkg);
    const mappedKey = idx >= 0 ? pkgIdxToUniqueKey.get(idx) : undefined;
    return mappedKey || pkg.sourceHeading;
  };

  // Token estimate for all checked packages
  const checkedApCount = useMemo(() =>
    linkedComponents.reduce((sum, c) => sum + c.length, 0),
    [linkedComponents],
  );

  const checkedTokenEstimate = useMemo(() =>
    checkedPackages.reduce((sum, pkg) => sum + estimateTokens(pkg.sourceText.length), 0),
    [checkedPackages],
  );

  // ── Agent-based generation helper ────────────────────────────

  /** Generate a single package's tests via the shared generation function. Throws on error. */
  const generateViaAgent = async (
    agentId: string,
    text: string,
    testUser?: string,
    featureName?: string,
    forcedRelevantTables?: import('../../types/gherkin').TableDef[],
    onPromptBuilt?: (gherkinRequest: string) => void,
    onTablesIdentified?: (info: { path: 'local' | 'ki'; tables: string[]; fieldCount: number; tableIdRequest?: string; tableIdRawResponse?: string }) => void,
    onTableIdStarted?: (request: string) => void,
    emitter?: WorkflowEmitter,
    attachments?: MessageAttachment[],
  ): Promise<{
    feature: FeatureInput; rawResponse: string;
    tableIdPath: 'local'|'ki'|'none'; identifiedTables: string[];
    fieldCount: number; tableIdRequest?: string; tableIdRawResponse?: string;
    gherkinRequest?: string; tableContext?: string;
  }> => {
    const { getTestDepth } = await import('../../lib/settings');
    const result = await generatePackage({
      text, learningHints, model, tables, testUser, agentId, featureName,
      forcedRelevantTables, onPromptBuilt, onTablesIdentified, onTableIdStarted,
      attachments,
      testDepth: getTestDepth(),
      emitter,
      lang: lang as 'de' | 'en',
      itemKey: featureName,
    });
    if (!result.feature || result.feature.scenarios.length === 0) {
      throw new Error('Keine Szenarien in der KI-Antwort.');
    }
    return {
      feature: result.feature,
      rawResponse: result.rawResponse ?? '',
      tableIdPath: result.tableIdPath,
      identifiedTables: result.identifiedTables,
      fieldCount: result.fieldCount,
      tableIdRequest: result.tableIdRequest,
      tableIdRawResponse: result.tableIdRawResponse,
      gherkinRequest: result.gherkinRequest,
      tableContext: result.tableContext,
    };
    console.log('[generateViaAgent] return:', { hasGherkinRequest: !!result.gherkinRequest, gherkinRequestLen: result.gherkinRequest?.length, hasTableContext: !!result.tableContext });
  };

  /** Rate a single package via the EFK agent chat.
   *  Uses null conversationId to avoid sending the full generation history — saves thousands of tokens. */
  const rateViaAgent = async (
    agentId: string,
    text: string,
    _convId: string | null,
  ): Promise<{ rating: AiPromptRating | null; conversationId: string }> => {
    // No table info needed for rating — it's about the quality of the requirements text, not field accuracy.
    // No conversationId — rating is independent, no need to carry generation context.
    const userMessage = `AUFGABE: Bewerte den folgenden Anforderungstext. Generiere KEIN Gherkin, sondern antworte NUR mit JSON.\n\n${DEFAULT_RATING_PROMPT}\n\nAnforderungstext:\n\n${text}`;
    const ratingDetails = `Bewertung | Modus: Agent | Nur Beschreibungstext (${text.length} Zeichen), keine Tabellen | Rating-Prompt: ${DEFAULT_RATING_PROMPT.length} Zeichen`;
    const result = await chatWithAgentSync(agentId, userMessage, 'rating', model, ratingDetails, undefined, await ensureSourceAttachments());
    const parsed = parseRatingResponse(result.response);
    updateLastResponseSummary(
      parsed
        ? `Antwort: Score ${parsed.score}% | ${parsed.reason} | ${parsed.suggestions.length} Vorschläge`
        : `Antwort: Konnte nicht geparst werden | Rohantwort: ${result.response.slice(0, 200)}`
    );
    return { rating: parsed, conversationId: result.conversationId };
  };

  // ── AI: shared generation loop ──────────────────────────────

  const runGenerationLoop = async (pkgsToGenerate: ParsedFeaturePackage[]): Promise<ParsedFeaturePackage[]> => {
    cancelRef.current = false;
    setAiProgress({ current: 0, total: pkgsToGenerate.length });
    onBulkActivityChange?.({ isRunning: true, current: 0, total: pkgsToGenerate.length, currentItem: '' });
    setError('');
    setTokenLimitHit(false);
    const enhanced: ParsedFeaturePackage[] = [];
    const errorDetails: string[] = [];
    const emitter = getBulkEmitter?.() ?? NULL_EMITTER;
    const sourceAttachments = await ensureSourceAttachments();

    emitter.emitLocal({
      phase: 'bulk-package-start',
      label: getPhaseLabel('bulk-package-start', lang as 'de' | 'en'),
      summary: `${pkgsToGenerate.length} ${t('docx.packages')}`,
    });

    for (let i = 0; i < pkgsToGenerate.length; i++) {
      if (cancelRef.current) break;
      setAiProgress({ current: i + 1, total: pkgsToGenerate.length });
      const pkg = pkgsToGenerate[i];
      const currentItem = pkg.feature.name || pkg.sourceHeading || '';
      onBulkActivityChange?.({
        isRunning: true, current: i + 1, total: pkgsToGenerate.length,
        currentItem,
        inputSnapshot: `**${currentItem}**\n\n${pkg.sourceText || ''}`,
      });
      try {
        // Build feature name with chapter number for GUID
        const responseKey = getUniqueKeyForPkg(pkg);
        const chapterNum = responseKey.includes('#') ? responseKey.split('#')[0] : '';
        const rawName = pkg.feature.name || pkg.sourceHeading;
        const featureNameForKi = chapterNum ? `${chapterNum} ${rawName}` : rawName;
        const guid = makeFeatureGuid(chapterNum, rawName);
        console.log(`[KI-Gen] ${i + 1}/${pkgsToGenerate.length}: "${featureNameForKi}" → GUID @guid-${guid}`);

        // Pre-detect tables locally before calling generateViaAgent (same logic as generatePackage)
        // so the tables are used directly in the prompt without a redundant KI call
        // SKIP when "Immer KI" is active — let generatePackage handle detection via AI
        let forcedTables: TableDef[] | undefined;
        if (!getForceKiTableId()) {
          const apSearchText = `${featureNameForKi}\n${pkg.sourceText || ''}`;
          const apRefMatches = Array.from(apSearchText.matchAll(/(?:V-?(\d+)-(\d+)|P(\d+:\d+))\b/gi));
          const apLocalRefs = new Set<string>();
          for (const m of apRefMatches) {
            if (m[1] && m[2]) apLocalRefs.add(`${parseInt(m[1], 10)}:${parseInt(m[2], 10)}`);
            else if (m[3]) apLocalRefs.add(m[3]);
          }
          const apMatchedTables = apLocalRefs.size > 0
            ? tables.filter(t => apLocalRefs.has(t.tableRef))
            : [];
          forcedTables = apMatchedTables.length > 0 ? apMatchedTables : undefined;
        }

        const genResult = await generateViaAgent(
          agentApiId!, pkg.sourceText, pkg.feature.testUser || undefined,
          featureNameForKi, forcedTables,
          // Update Agent Modal with real prompt immediately before API call
          (prompt) => onBulkActivityChange?.({
            isRunning: true, current: i + 1, total: pkgsToGenerate.length,
            currentItem,
            inputSnapshot: prompt,
            promptUpdate: true,
          }),
          // Update diagram immediately when tables are identified (before Gherkin generation)
          (tableInfo: { path: 'local' | 'ki'; tables: string[]; fieldCount: number; tableIdRequest?: string; tableIdRawResponse?: string }) => onBulkActivityChange?.({
            isRunning: true, current: i + 1, total: pkgsToGenerate.length,
            currentItem,
            tableIdPath: tableInfo.path,
            identifiedTables: tableInfo.tables,
            fieldCount: tableInfo.fieldCount,
            tableIdRequest: tableInfo.tableIdRequest,
            tableIdRawResponse: tableInfo.tableIdRawResponse,
            tablesIdentified: true,
          }),
          // Show table ID request in Agent Modal immediately BEFORE KI responds
          (request) => onBulkActivityChange?.({
            isRunning: true, current: i + 1, total: pkgsToGenerate.length,
            currentItem,
            tableIdRequest: request,
            tableIdStarted: true,
          }),
          emitter,
          sourceAttachments,
        );
        // Show the raw response + table ID info in activity modal
        onBulkActivityChange?.({
          isRunning: true, current: i + 1, total: pkgsToGenerate.length,
          currentItem,
          inputSnapshot: `**${currentItem}**\n\n${pkg.sourceText || ''}`,
          outputSoFar: genResult.rawResponse || '',
          tableIdPath: genResult.tableIdPath,
          identifiedTables: genResult.identifiedTables,
          fieldCount: genResult.fieldCount,
          tableIdRequest: genResult.tableIdRequest,
          tableIdRawResponse: genResult.tableIdRawResponse,
          gherkinRequest: genResult.gherkinRequest,
          tableContext: genResult.tableContext,
        });
        setRawResponses((prev) => ({ ...prev, [responseKey]: genResult.rawResponse }));
        // Feature name is OURS (document heading), not the AI's.
        // GUID tag must match our computed GUID, not whatever the AI invented.
        const GUID_RE = /^@(?:guid-)?[0-9a-f]{16}$/;
        const aiTags = genResult.feature.tags.filter((t: string) => !GUID_RE.test(t));
        const tags = [`@guid-${guid}`, ...aiTags];

        const enhancedFeature = {
          ...genResult.feature,
          name: rawName,
          tags,
          description: pkg.feature.description || genResult.feature.description || pkg.sourceText,
        };
        enhanced.push({
          ...pkg,
          feature: enhancedFeature,
          validation: validateFeature(enhancedFeature),
        });
      } catch (err) {
        if (err instanceof TokenLimitError) {
          // Only show the banner the first time today. On repeat hits within the
          // same session, the event listener has already shown the info once.
          if (!wasTokenLimitBannerHandledToday()) {
            setError(t('docx.tokenLimitReached'));
            setTokenLimitHit(true);
            // Mark as handled immediately so subsequent TokenLimit hits do not
            // re-show the banner — even if the user does nothing with it and
            // just restarts generation.
            markTokenLimitBannerHandledToday();
          }
          break;
        }
        if (err instanceof RateLimitError) {
          setError(t('docx.rateLimitReached'));
          break;
        }
        const reason = err instanceof Error ? err.message : String(err);
        errorDetails.push(`\u201E${pkg.sourceHeading}\u201C: ${reason}`);
        console.warn(`[DocxImport] Fehler bei "${pkg.sourceHeading}":`, err);
        enhanced.push(pkg);
      }
      if (i < pkgsToGenerate.length - 1 && !cancelRef.current) {
        await new Promise((resolve) => setTimeout(resolve, 1000));
      }
    }

    setAiProgress({ current: 0, total: 0 });
    // Always signal done — even on cancel/error — so the status chip clears
    onBulkActivityChange?.({ isRunning: false, current: pkgsToGenerate.length, total: pkgsToGenerate.length, currentItem: '' });
    cancelRef.current = false;
    emitter.emitLocal({
      phase: 'bulk-package-end',
      label: getPhaseLabel('bulk-package-end', lang as 'de' | 'en'),
      summary: `${enhanced.length} ${t('docx.done')} · ${errorDetails.length} ${t('docx.errors')}`,
    });
    if (errorDetails.length > 0 && !error) {
      setError(
        t('docx.aiEnhanceError', { errorCount: errorDetails.length, total: pkgsToGenerate.length })
        + '\n' + errorDetails.join('\n'),
      );
    }
    return enhanced;
  };

  // Pre-check before generation: validate token + tables
  const preCheckGeneration = async (): Promise<boolean> => {
    if (!agentApiId) return false;
    try {
      await getValidToken();
    } catch {
      setError(t('docx.sessionExpired'));
      return false;
    }
    if (tables.length === 0) {
      const ok = await new Promise<boolean>((resolve) => {
        noTablesConfirmResolverRef.current = resolve;
        setShowNoTablesConfirm(true);
      });
      if (!ok) return false;
    }
    return true;
  };

  // ── AI: generate tests for checked packages ──────────────────

  const startAiGenerate = async (pkgs: ParsedFeaturePackage[]) => {
    if (!(await preCheckGeneration())) return;
    const enhanced = await runGenerationLoop(pkgs);
    // Match enhanced results back to original packages by reference identity
    const originalToEnhanced = new Map<ParsedFeaturePackage, ParsedFeaturePackage>();
    pkgs.forEach((orig, idx) => { if (enhanced[idx]) originalToEnhanced.set(orig, enhanced[idx]); });
    setPackages((prev) =>
      prev.map((p) => originalToEnhanced.get(p) ?? p)
    );
    return enhanced;
  };

  const handleAiGenerate = async () => {
    if (checkedPackages.length === 0 || !agentApiId) return;
    await startAiGenerate(checkedPackages);
  };

  // ── AI: generate tests + create folder + agent ───────────────

  const startCreateWithAgent = async (pkgs: ParsedFeaturePackage[]) => {
    if (!onCreateWithAgent) return;
    if (!(await preCheckGeneration())) return;
    const enhanced = await runGenerationLoop(pkgs);
    if (enhanced.length > 0 && !cancelRef.current) {
      await onCreateWithAgent(enhanced, docxFileName, toc.length > 0 ? { toc, tocNumbers } : undefined);
    }
  };

  const handleCreateWithAgent = async () => {
    if (!onCreateWithAgent || checkedPackages.length === 0 || !agentApiId) return;
    await startCreateWithAgent(checkedPackages);
  };

  const handleCancelAi = () => { cancelRef.current = true; };

  const handleDismissTokenLimit = () => {
    setTokenLimitHit(false);
    setError('');
    markTokenLimitBannerHandledToday();
  };

  const analyzeRelations = async (sourcePackages?: ParsedFeaturePackage[]) => {
    if (!agentApiId) {
      setRelationError(t('docx.noAgentAvailable'));
      return;
    }
    const relationPackages = sourcePackages ?? (checkedPackages.length > 1 ? checkedPackages : packages);
    if (relationPackages.length < 2) {
      setRelationError(t('docx.selectAtLeastTwoPackages'));
      return;
    }

    setRelationBusy(true);
    setRelationError(null);

    try {
      const emitter = getBulkEmitter?.() ?? NULL_EMITTER;
      const sourceAttachments = await ensureSourceAttachments();
      const inputs: ConceptPackageInput[] = relationPackages.map((pkg) => {
        const key = getUniqueKeyForPkg(pkg);
        const hash = key.indexOf('#');
        const chapter = hash >= 0 ? key.slice(0, hash) : key;
        const heading = hash >= 0 ? key.slice(hash + 1) : pkg.sourceHeading;
        return {
          id: key,
          chapter,
          heading,
          sourceText: (pkg.sourceText || '').slice(0, 3500),
        };
      });

      const chunks = chunkConceptPackages(inputs);
      const partials: ConceptChunkResult[] = [];

      emitter.emitLocal({
        phase: 'bulk-package-start',
        label: t('docx.relationAnalysisStarted'),
        summary: `${chunks.length} ${t('docx.chunks')} · ${relationPackages.length} ${t('docx.packages')}`,
        itemKey: t('docx.chapterRelations'),
      });

      for (let i = 0; i < chunks.length; i++) {
        const chunk = chunks[i];
        const chunkLabel = `${t('docx.analysisChunk')} ${i + 1}/${chunks.length}`;
        const chunkIds = chunk.map((p) => p.id);
        const payload = chunk.map((p) => (
          `ID=${p.id}\nKapitel=${p.chapter}\nTitel=${p.heading}\nText:\n${p.sourceText}`
        )).join('\n\n---\n\n');

        const prompt = [
          'Du analysierst abas ERP Konzepte fuer zusammenhaengende Arbeitspakete.',
          'Gib NUR valides JSON zurueck, ohne Markdown.',
          'Analysiere nur Beziehungen zwischen den gelieferten IDs.',
          'Rueckgabe-Schema:',
          '{',
          '  "packageSummaries": [{"id":"...","process":"...","objects":["..."],"keywords":["..."]}],',
          '  "relations": [{"from":"ID","to":"ID","relation":"depends_on|same_data|same_process|precondition_for","confidence":0.0,"evidence":"..."}],',
          '  "clusters": [{"id":"cluster-1","name":"...","members":["ID"],"reason":"..."}],',
          '  "gaps": [{"severity":"low|medium|high","message":"...","related":["ID"]}]',
          '}',
          'Regeln:',
          '- confidence zwischen 0 und 1.',
          '- Nur IDs verwenden, die in der Eingabe enthalten sind.',
          '- Kein Fliesstext ausserhalb des JSON.',
          '',
          `Chunk ${i + 1}/${chunks.length}`,
          payload,
        ].join('\n');

        emitter.emitLocal({
          phase: 'cuc-build-prompt',
          label: t('docx.prepareChunk'),
          summary: `${chunk.length} ${t('docx.packagesInChunk')}`,
          inputText: chunkIds.join('\n'),
          itemKey: chunkLabel,
        });

        const response = await emitter.emitAiCall({
          phase: 'cuc-generate',
          label: t('docx.analyzeRelationsAi'),
          agent: 'concept-relations',
          systemPrompt: '',
          userPrompt: prompt,
          model,
          itemKey: chunkLabel,
        }, async () => {
          const run = await runWithAgentSync(
            agentApiId,
            prompt,
            sourceAttachments,
            undefined,
            model,
            `concept-relations chunk ${i + 1}/${chunks.length}`,
          );
          return run.response;
        });

        let parsed = normalizeConceptChunkResult(parseJsonLoose<ConceptChunkResult>(response));

        if (!parsed) {
          emitter.emitLocal({
            phase: 'cuc-parse',
            label: t('docx.jsonRepair'),
            summary: t('docx.invalidResponseTryingRepair'),
            itemKey: chunkLabel,
          });

          const repairPrompt = [
            'Formatiere die folgende KI-Antwort in STRICT VALID JSON um.',
            'Gib NUR JSON zurueck, ohne Markdown, ohne Erklaerung.',
            'Behalte ausschliesslich dieses Schema:',
            '{',
            '  "packageSummaries": [{"id":"...","process":"...","objects":["..."],"keywords":["..."]}],',
            '  "relations": [{"from":"ID","to":"ID","relation":"depends_on|same_data|same_process|precondition_for","confidence":0.0,"evidence":"..."}],',
            '  "clusters": [{"id":"cluster-1","name":"...","members":["ID"],"reason":"..."}],',
            '  "gaps": [{"severity":"low|medium|high","message":"...","related":["ID"]}]',
            '}',
            'Falls Informationen fehlen, gib leere Arrays zurueck.',
            '',
            'Urspruengliche Antwort:',
            response,
          ].join('\n');

          const repairedResponse = await emitter.emitAiCall({
            phase: 'cuc-parse',
            label: t('docx.repairResponseJsonAi'),
            agent: 'concept-relations-json-repair',
            systemPrompt: '',
            userPrompt: repairPrompt,
            model,
            itemKey: chunkLabel,
          }, async () => {
            const repairedRun = await runWithAgentSync(
              agentApiId,
              repairPrompt,
              sourceAttachments,
              undefined,
              model,
              `concept-relations repair ${i + 1}/${chunks.length}`,
            );
            return repairedRun.response;
          });

          parsed = normalizeConceptChunkResult(parseJsonLoose<ConceptChunkResult>(repairedResponse));
        }

        if (!parsed) {
          partials.push({
            packageSummaries: chunk.map((p) => ({
              id: p.id,
              process: '',
              objects: [],
              keywords: [],
            })),
            relations: [],
            clusters: [],
            gaps: [{
              severity: 'high',
              message: `Chunk ${i + 1} konnte nicht als JSON gelesen werden und wurde uebersprungen.`,
              related: chunkIds,
            }],
          });
          emitter.emitLocal({
            phase: 'cuc-parse',
            label: t('docx.chunkSkipped'),
            summary: t('docx.jsonStillInvalidAfterRepair'),
            itemKey: chunkLabel,
          });
          continue;
        }

        partials.push(parsed);

        emitter.emitLocal({
          phase: 'cuc-parse',
          label: t('docx.chunkParsed'),
          summary: `${parsed.relations.length} ${t('docx.relationsLabel')} · ${parsed.clusters.length} ${t('docx.clustersLabel')}`,
          itemKey: chunkLabel,
        });
      }

      let merged: ConceptChunkResult;
      if (partials.length === 1) {
        merged = partials[0];
      } else {
        const mergePrompt = [
          'Fuehre die folgenden Teilergebnisse zu einem konsistenten Gesamtbild zusammen.',
          'Gib NUR valides JSON im identischen Schema zurueck.',
          'Ergaenze kapiteluebergreifende Relationen nur bei klarer Evidenz.',
          'Vermeide Duplikate in relations und clusters.',
          '',
          JSON.stringify({
            packages: inputs.map((p) => ({ id: p.id, chapter: p.chapter, heading: p.heading })),
            partials,
          }),
        ].join('\n');

        const mergeResponse = await emitter.emitAiCall({
          phase: 'cuc-feature-assemble',
          label: t('docx.mergeChunkResultsAi'),
          agent: 'concept-relations-merge',
          systemPrompt: '',
          userPrompt: mergePrompt,
          model,
          itemKey: t('docx.mergeLabel'),
        }, async () => {
          const mergedRun = await runWithAgentSync(
            agentApiId,
            mergePrompt,
            sourceAttachments,
            undefined,
            model,
            'concept-relations merge',
          );
          return mergedRun.response;
        });

        merged = normalizeConceptChunkResult(parseJsonLoose<ConceptChunkResult>(mergeResponse))
          ?? combineConceptChunkResults(partials);
      }

      const packageIds = new Set(inputs.map((p) => p.id));
      const idToDisplay = new Map(inputs.map((p) => [p.id, `${p.chapter ? `${p.chapter} ` : ''}${p.heading}`]));

      const aiLinks: ChapterRelationLink[] = (merged.relations || [])
        .filter((r) => packageIds.has(r.from) && packageIds.has(r.to) && r.from !== r.to)
        .map((r) => ({
          fromId: r.from,
          toId: r.to,
          fromLabel: idToDisplay.get(r.from) || r.from,
          toLabel: idToDisplay.get(r.to) || r.to,
          relation: normalizeRelationLabel(r.relation, t),
          confidence: typeof r.confidence === 'number' ? r.confidence : 0.6,
          evidence: r.evidence,
          source: 'ai',
        }));

      const clusterLinks: ChapterRelationLink[] = [];
      (merged.clusters || []).forEach((c) => {
        const members = (c.members || []).filter((id) => packageIds.has(id));
        if (members.length < 2) return;
        for (let i = 0; i < members.length; i++) {
          for (let j = i + 1; j < members.length; j++) {
            const fromId = members[i];
            const toId = members[j];
            clusterLinks.push({
              fromId,
              toId,
              fromLabel: idToDisplay.get(fromId) || fromId,
              toLabel: idToDisplay.get(toId) || toId,
              relation: normalizeRelationLabel('cluster', t),
              confidence: 0.9,
              evidence: c.reason,
              source: 'ai',
            });
          }
        }
      });

      const dedup = new Set<string>();
      const links = [...aiLinks, ...clusterLinks].filter((l) => {
        const key = `${relationKey(l.fromId, l.toId)}::${l.relation}`;
        if (dedup.has(key)) return false;
        dedup.add(key);
        return true;
      });

      setChapterLinks((prev) => {
        const manual = prev.filter((l) => l.source === 'manual');
        const combined = [...manual, ...links];
        const seen = new Set<string>();
        return combined.filter((l) => {
          const key = `${relationKey(l.fromId, l.toId)}::${l.relation}`;
          if (seen.has(key)) return false;
          seen.add(key);
          return true;
        });
      });
      setRelationGaps((merged.gaps || []).slice(0, 20));
      setRelationSummaryOpen(true);
      if ((merged.gaps || []).length > 0) {
        setWarningPanelOpen(true);
      }

      emitter.emitLocal({
        phase: 'bulk-package-end',
        label: t('docx.relationAnalysisFinished'),
        summary: `${links.length} ${t('docx.linksLabel')} · ${(merged.gaps || []).length} ${t('docx.warningsLabel')}`,
        itemKey: t('docx.chapterRelations'),
      });
    } catch (err) {
      setRelationError(err instanceof Error ? err.message : t('docx.relationAnalysisFailed'));
    } finally {
      setRelationBusy(false);
    }
  };

  const selectRelationPackage = (relationId: string) => {
    const checkKey = relationIdToCheckKey.get(relationId);
    if (!checkKey) return;
    setCheckedHeadings((prev) => {
      if (prev.has(checkKey)) return prev;
      const next = new Set(prev);
      next.add(checkKey);
      return next;
    });
  };

  const addManualLink = (fromId: string, toId: string) => {
    if (fromId === toId) return;
    const fromInfo = packageInfoById.get(fromId);
    const toInfo = packageInfoById.get(toId);
    if (!fromInfo || !toInfo) return;

    const nextRelation = normalizeRelationLabel('belongs_to', t);

    const buildConnectedComponent = (): string[] => {
      const selectedIds = new Set<string>();
      for (const checkKey of checkedHeadings) {
        const relationId = checkKeyToRelationId.get(checkKey);
        if (relationId) selectedIds.add(relationId);
      }
      selectedIds.add(fromId);
      selectedIds.add(toId);

      const nextLinks = [
        ...chapterLinks,
        {
          fromId,
          toId,
          fromLabel: `${fromInfo.chapterNum} ${fromInfo.heading}`.trim(),
          toLabel: `${toInfo.chapterNum} ${toInfo.heading}`.trim(),
          relation: nextRelation,
          confidence: 1,
          source: 'manual' as const,
        },
      ];

      const adjacency = new Map<string, Set<string>>();
      for (const id of selectedIds) adjacency.set(id, new Set());
      for (const link of nextLinks) {
        if (!selectedIds.has(link.fromId) || !selectedIds.has(link.toId)) continue;
        adjacency.get(link.fromId)?.add(link.toId);
        adjacency.get(link.toId)?.add(link.fromId);
      }

      const stack = [fromId];
      const visited = new Set<string>([fromId]);
      while (stack.length > 0) {
        const current = stack.pop()!;
        const neighbors = adjacency.get(current);
        if (!neighbors) continue;
        for (const n of neighbors) {
          if (visited.has(n)) continue;
          visited.add(n);
          stack.push(n);
        }
      }
      return Array.from(visited);
    };

    setChapterLinks((prev) => {
      const duplicate = prev.some((l) => relationKey(l.fromId, l.toId) === relationKey(fromId, toId) && l.relation === nextRelation);
      if (duplicate) return prev;
      return [
        ...prev,
        {
          fromId,
          toId,
          fromLabel: `${fromInfo.chapterNum} ${fromInfo.heading}`.trim(),
          toLabel: `${toInfo.chapterNum} ${toInfo.heading}`.trim(),
          relation: nextRelation,
          confidence: 1,
          source: 'manual',
        },
      ];
    });

    selectRelationPackage(fromId);
    selectRelationPackage(toId);

  };

  const getStructureChainRelationIds = (startIndex: number): string[] => {
    const startLevel = toc[startIndex]?.level ?? 0;
    const relationIds: string[] = [];

    for (let idx = startIndex + 1; idx < toc.length; idx++) {
      const entry = toc[idx];
      if (entry.level <= startLevel) break;
      if (entry.kind !== 'package') continue;
      const relationId = checkKeyToRelationId.get(`toc#${idx}`);
      if (relationId) relationIds.push(relationId);
    }

    return relationIds;
  };

  const connectStructureChain = (startIndex: number) => {
    if (isBusy) return;
    const relationIds = getStructureChainRelationIds(startIndex);
    if (relationIds.length < 2) return;

    const relation = normalizeRelationLabel('belongs_to', t);
    const expectedPairs = relationIds.slice(0, -1).map((fromId, idx) => ({
      fromId,
      toId: relationIds[idx + 1],
    }));
    const allChainLinksPresent = expectedPairs.every(({ fromId, toId }) => (
      chapterLinks.some((link) => (
        link.source === 'manual'
        && link.relation === relation
        && relationKey(link.fromId, link.toId) === relationKey(fromId, toId)
      ))
    ));

    if (allChainLinksPresent) {
      setChapterLinks((prev) => prev.filter((link) => {
        if (link.source !== 'manual' || link.relation !== relation) return true;
        return !expectedPairs.some(({ fromId, toId }) => relationKey(link.fromId, link.toId) === relationKey(fromId, toId));
      }));
      return;
    }

    setRelationSummaryOpen(true);
    for (const { fromId, toId } of expectedPairs) {
      addManualLink(fromId, toId);
    }
  };

  const removeLink = (fromId: string, toId: string, relation: string) => {
    setChapterLinks((prev) => {
      const removed = prev.find((l) => relationKey(l.fromId, l.toId) === relationKey(fromId, toId) && l.relation === relation);
      const next = prev.filter((l) => !(relationKey(l.fromId, l.toId) === relationKey(fromId, toId) && l.relation === relation));
      if (removed) {
        if (undoDeleteTimerRef.current !== null) {
          window.clearTimeout(undoDeleteTimerRef.current);
          undoDeleteTimerRef.current = null;
        }
        setLastRemovedLink(removed);
        undoDeleteTimerRef.current = window.setTimeout(() => {
          setLastRemovedLink(null);
          undoDeleteTimerRef.current = null;
        }, 5000);
      }
      return next;
    });
  };

  const removeComponent = (component: string[]) => {
    const memberSet = new Set(component);
    setChapterLinks((prev) => prev.filter((l) => !(memberSet.has(l.fromId) && memberSet.has(l.toId))));
  };

  const handleTogglePackage = (checkKey: string) => {
    if (Date.now() < dragInteractionBlockUntilRef.current) return;
    const relationId = checkKeyToRelationId.get(checkKey);
    if (!relationId) return;
    const componentCheckKeys = getRelationCheckKeysForComponent(relationId);
    if (componentCheckKeys.length === 0) return;

    setCheckedHeadings((prev) => {
      const allSelected = componentCheckKeys.every((key) => prev.has(key));
      const next = new Set(prev);
      if (allSelected) {
        for (const key of componentCheckKeys) next.delete(key);
      } else {
        for (const key of componentCheckKeys) next.add(key);
      }
      return next;
    });
  };

  const suppressPostDropInteraction = () => {
    dragInteractionBlockUntilRef.current = Date.now() + 4000;
  };

  const armPostDropShield = () => {
    if (postDropShieldTimerRef.current !== null) {
      window.clearTimeout(postDropShieldTimerRef.current);
      postDropShieldTimerRef.current = null;
    }
    setPostDropShieldActive(true);
    postDropShieldTimerRef.current = window.setTimeout(() => {
      setPostDropShieldActive(false);
      postDropShieldTimerRef.current = null;
    }, 700);
  };

  const undoRemoveLink = () => {
    if (!lastRemovedLink) return;
    const link = lastRemovedLink;
    setChapterLinks((prev) => {
      const exists = prev.some((l) => relationKey(l.fromId, l.toId) === relationKey(link.fromId, link.toId) && l.relation === link.relation);
      if (exists) return prev;
      return [...prev, link];
    });
    setLastRemovedLink(null);
    if (undoDeleteTimerRef.current !== null) {
      window.clearTimeout(undoDeleteTimerRef.current);
      undoDeleteTimerRef.current = null;
    }
  };

  useEffect(() => {
    return () => {
      if (undoDeleteTimerRef.current !== null) {
        window.clearTimeout(undoDeleteTimerRef.current);
      }
      if (postDropShieldTimerRef.current !== null) {
        window.clearTimeout(postDropShieldTimerRef.current);
      }
    };
  }, []);

  // ── Rating ────────────────────────────────────────────────────

  const [bulkRatingProgress, setBulkRatingProgress] = useState({ current: 0, total: 0 });
  const isBulkRating = bulkRatingProgress.total > 0;

  const [relationBusy, setRelationBusy] = useState(false);
  const [relationError, setRelationError] = useState<string | null>(null);
  const [autoAnalyzePrompt, setAutoAnalyzePrompt] = useState<{
    open: boolean;
    packages: ParsedFeaturePackage[];
  }>({ open: false, packages: [] });
  const [showNoTablesConfirm, setShowNoTablesConfirm] = useState(false);
  const noTablesConfirmResolverRef = useRef<((value: boolean) => void) | null>(null);

  const handleBulkRating = async () => {
    if (!isLoggedIn()) { setRatingError(t('docx.notLoggedIn')); return; }
    if (!agentApiId) { setRatingError(t('docx.agentRequired')); return; }
    const toRate = checkedPackages.length > 0 ? checkedPackages : packages.filter((pkg) => !hasErrors(pkg.validation));
    if (toRate.length === 0) return;
    cancelRef.current = false;
    setBulkRatingProgress({ current: 0, total: toRate.length });
    setRatingError(null);
    let errorCount = 0;
    for (let i = 0; i < toRate.length; i++) {
      if (cancelRef.current) break;
      setBulkRatingProgress({ current: i + 1, total: toRate.length });
      const pkg = toRate[i];
      const text = pkg.sourceText || pkg.feature.description;
      if (!text.trim()) { errorCount++; continue; }
      try {
        const agentResult = await rateViaAgent(agentApiId!, text, null);
        const parsed = agentResult.rating;

        if (parsed) {
          const ratingKey = getUniqueKeyForPkg(pkg);
          setRatings((prev) => ({ ...prev, [ratingKey]: parsed! }));
        }
        else errorCount++;
      } catch (err) {
        if (err instanceof TokenLimitError) {
          setRatingError(t('docx.tokenLimitReached'));
          break;
        }
        if (err instanceof RateLimitError) {
          setRatingError(t('docx.rateLimitReached'));
          break;
        }
        errorCount++;
      }
      if (i < toRate.length - 1 && !cancelRef.current) {
        await new Promise((resolve) => setTimeout(resolve, 1000));
      }
    }
    setBulkRatingProgress({ current: 0, total: 0 });
    if (errorCount > 0) setRatingError(t('docx.ratingError', { errorCount, total: toRate.length }));
  };

  const importableCount = packages.filter((pkg) => !hasErrors(pkg.validation)).length;
  const isEnhancing = aiProgress.total > 0;
  const isBusy = isEnhancing || isBulkRating || isSendingToAgent || relationBusy;

  const linksByPackageId = useMemo(() => {
    const map = new Map<string, ChapterRelationLink[]>();
    for (const link of chapterLinks) {
      if (!map.has(link.fromId)) map.set(link.fromId, []);
      if (!map.has(link.toId)) map.set(link.toId, []);
      map.get(link.fromId)!.push(link);
      map.get(link.toId)!.push(link);
    }
    return map;
  }, [chapterLinks]);

  const gapCountByPackageId = useMemo(() => {
    const map = new Map<string, number>();
    for (const gap of relationGaps) {
      for (const id of gap.related || []) {
        map.set(id, (map.get(id) || 0) + 1);
      }
    }
    return map;
  }, [relationGaps]);

  const relationSummaryText = useMemo(() => {
    const total = chapterLinks.length;
    const manual = chapterLinks.filter((l) => l.source === 'manual').length;
    const ai = total - manual;
    return t('docx.relationSummary', {
      total,
      ai,
      manual,
      warnings: relationGaps.length,
    });
  }, [chapterLinks, relationGaps.length, t]);

  // ── TOC view ──────────────────────────────────────────────────

  const useTocView = toc.length > 0;

  const hasChatPanel = false; // Chat panel removed — using Standard-Agent directly

  return (
    <div className={hasChatPanel ? styles.containerWithChat : styles.container}>
      <div className={hasChatPanel ? styles.mainColumn : undefined}>
      {/* Toolbar */}
      <div className={styles.toolbar}>
        <button className={styles.uploadBtn} onClick={() => fileRef.current?.click()} disabled={isBusy} type="button">
          {t('docx.upload')}
        </button>
        <input ref={fileRef} className={styles.fileInput} type="file" accept=".docx,.dotm,.doc" onChange={handleFileChange} />
        <button className={styles.templateBtn} onClick={() => downloadDocxTemplate(activeProfile, lang)} type="button">
          {t('docx.downloadTemplate')}
        </button>

        {profiles.length > 1 && (
          <>
            <span className={styles.profileLabel}>{t('docx.profile')}</span>
            <select
              className={styles.profileSelect}
              value={activeProfileId}
              onChange={(e) => handleProfileChange(e.target.value)}
              disabled={isBusy}
            >
              {profiles.map((p) => (
                <option key={p.id} value={p.id}>{p.name}</option>
              ))}
            </select>
          </>
        )}

        {(packages.length > 0 || skipped.length > 0) && (
          <>
            <span className={styles.info}>
              {t('docx.featuresDetected', { count: packages.length })}
              {skipped.length > 0 && t('docx.skipped', { count: skipped.length })}
            </span>
            <button className={styles.clearBtn} onClick={handleClear} disabled={isBusy} type="button">&times;</button>
          </>
        )}
      </div>

      {/* Variablentabelle — wird global über Stammdaten-Tab verwaltet */}

      {/* Error/AI messages */}
      {(error || aiError || ratingError || relationError) && (
        <div style={{ color: 'var(--color-danger)', fontSize: '0.85rem', marginBottom: 'var(--spacing)', whiteSpace: 'pre-line' }}>
          {error || aiError || ratingError || relationError}
          {tokenLimitHit && (
            <div
              style={{
                marginTop: '0.75rem',
                padding: '0.75rem',
                border: '1px solid var(--color-border)',
                borderRadius: '4px',
                color: 'var(--color-text)',
                background: 'var(--color-surface-alt, rgba(0,0,0,0.03))',
              }}
            >
              <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
                <button
                  type="button"
                  onClick={handleDismissTokenLimit}
                  style={{ padding: '0.35rem 0.75rem', fontSize: '0.85rem', whiteSpace: 'nowrap' }}
                >
                  {t('docx.dismiss')}
                </button>
              </div>
            </div>
          )}
        </div>
      )}
      {loading && <div className={styles.loading}>{t('docx.loading')}</div>}
      {isEnhancing && (
        <div className={styles.aiProgress}>
          <span>
            {t('docx.aiProgress', { current: aiProgress.current, total: aiProgress.total })}
          </span>
          <button className={styles.clearBtn} onClick={handleCancelAi} type="button">{t('docx.cancel')}</button>
        </div>
      )}
      {isBulkRating && (
        <div className={styles.aiProgress}>
          <span>{t('docx.ratingProgress', { current: bulkRatingProgress.current, total: bulkRatingProgress.total })}</span>
          <button className={styles.clearBtn} onClick={handleCancelAi} type="button">{t('docx.cancel')}</button>
        </div>
      )}
      {relationBusy && (
        <div className={styles.aiProgress}>
          <span>{t('docx.relationAnalyzing')}</span>
        </div>
      )}

      {/* Empty state */}
      {!loading && packages.length === 0 && skipped.length === 0 && !error && (
        <div className={styles.emptyState}>
          <div className={styles.emptyTitle}>{t('docx.emptyTitle')}</div>
          <div className={styles.emptyText}>
            {t('docx.emptyDesc1')}<br />{t('docx.emptyDesc2')}<br />{t('docx.emptyDesc3')}
          </div>
          <button className={styles.templateBtn} onClick={() => downloadDocxTemplate(activeProfile, lang)} type="button">
            {t('docx.downloadTemplate')}
          </button>
        </div>
      )}

      {/* TOC view (when document has heading structure) */}
      {useTocView && (packages.length > 0 || skipped.length > 0) && (
        <>
          <div className={styles.tocActions}>
            {/* Primary: KI-Tests generieren with agent */}
            {onCreateWithAgent && checkedPackages.length > 0 && showAi && (
              <button
                className={styles.aiBtn}
                onClick={isEnhancing ? handleCancelAi : handleCreateWithAgent}
                disabled={(isBusy && !isEnhancing) || !agentApiId}
                type="button"
                title={!agentApiId ? t('docx.agentRequired') : undefined}
              >
                {isEnhancing
                  ? t('docx.cancel')
                  : `🤖 ${checkedApCount !== checkedPackages.length
                      ? t('docx.generateTestsForApsMerged', { count: checkedApCount, tests: checkedPackages.length, tokens: `${(checkedTokenEstimate / 1000).toFixed(1)}k` })
                      : t('docx.generateTestsForAps', { count: checkedApCount, tokens: `${(checkedTokenEstimate / 1000).toFixed(1)}k` })}`}
              </button>
            )}

            {/* Rating */}
            {showAi && checkedPackages.length > 0 && (
              <button
                className={styles.ratingBulkBtn}
                onClick={isBulkRating ? handleCancelAi : handleBulkRating}
                disabled={(isBusy && !isBulkRating) || !agentApiId}
                type="button"
                title={!agentApiId ? t('docx.agentRequired') : undefined}
              >
                {isBulkRating ? t('docx.cancel') : t('docx.ratingBulk', { count: checkedPackages.length })}
              </button>
            )}

            {showAi && (checkedPackages.length > 1 || packages.length > 1) && (
              <button
                className={styles.relationAnalyzeBtn}
                onClick={() => analyzeRelations(packages)}
                disabled={isBusy || !agentApiId}
                type="button"
                title={!agentApiId ? t('docx.agentRequired') : undefined}
              >
                {relationBusy ? t('docx.relationAnalyzingShort') : t('docx.relationAnalyzeAll', { count: packages.length })}
              </button>
            )}

          </div>

          {(chapterLinks.length > 0 || relationGaps.length > 0) && (
            <div className={styles.relationSummaryBox}>
              <button
                type="button"
                className={styles.relationSummaryHeader}
                onClick={() => setRelationSummaryOpen((prev) => !prev)}
              >
                  <span>{relationSummaryOpen ? '▾' : '▸'} {t('docx.relationsTitle')}</span>
                <span className={styles.relationSummaryMeta}>{relationSummaryText}</span>
              </button>
              {relationSummaryOpen && (
                <div className={styles.relationSummaryBody}>
                  {orderedRelationComponents.length > 0 && (
                    <ul className={styles.relationSummaryList}>
                      {orderedRelationComponents.map((component, idx) => {
                        const orderedComponent = orderRelationComponent(component);
                        const chainLabels = orderedComponent
                          .map((memberId) => packageInfoById.get(memberId))
                          .filter((v): v is NonNullable<typeof v> => !!v)
                          .map((member) => member.chapterNum)
                          .filter(Boolean);
                        const chainText = chainLabels.join(' → ');
                        const sourceId = orderedComponent[0];
                        return (
                      <li
                        key={`${sourceId}-${idx}`}
                        className={`${styles.relationSummaryItem} ${styles.relationSummaryChainItem}`}
                      >
                        <button
                          type="button"
                          className={styles.relationJumpBtn}
                          onClick={() => selectRelationPackage(sourceId)}
                        >
                          {chainText}
                        </button>
                        <span className={styles.relationSummaryMeta}>
                          {orderedComponent.length} {t('docx.partsLabel')}
                        </span>
                        <button
                          type="button"
                          className={styles.relationDeleteBtn}
                          title={t('docx.deleteRelationGroup')}
                          onClick={() => removeComponent(component)}
                        >
                          ×
                        </button>
                      </li>
                        );
                      })}
                    </ul>
                  )}
                  {relationGaps.length > 0 && (
                    <button
                      type="button"
                      className={styles.relationWarningToggle}
                      onClick={() => setWarningPanelOpen((prev) => !prev)}
                    >
                      {warningPanelOpen
                        ? t('docx.hideWarnings')
                        : t('docx.showWarnings', { count: relationGaps.length })}
                    </button>
                  )}
                </div>
              )}
            </div>
          )}

          <div className={styles.tocContainer}>
            <div className={styles.tocHeader}>
              <span className={styles.tocTitle}>{t('docx.tocTitle', { fileName: docxFileName })}</span>
              <span className={styles.tocSelectBtns}>
                <button type="button" className={styles.tocSelectBtn} onClick={selectAllPackages}>{t('docx.selectAll')}</button>
                <button type="button" className={styles.tocSelectBtn} onClick={deselectAllPackages}>{t('docx.deselectAll')}</button>
                <button type="button" className={styles.tocSelectBtn} onClick={() => toggleSubsetSelection(abasPackageKeys)}>
                  {t('docx.onlyAbas', { count: abasPackageKeys.length })}
                </button>
                <button type="button" className={styles.tocSelectBtn} onClick={() => toggleSubsetSelection(kundePackageKeys)}>
                  {t('docx.onlyCustomer', { count: kundePackageKeys.length })}
                </button>
              </span>
              <span className={styles.tocLegend}>
                <span className={styles.legendPkg}>{t('docx.legendPackage')}</span>
                <span className={styles.legendSkipped}>{t('docx.legendSkipped')}</span>
              </span>
            </div>
            <ul className={styles.tocList}>
              {(() => {
                return toc.map((entry, i) => {
                let pkg: ParsedFeaturePackage | null = null;
                if (entry.kind === 'package') {
                  const pkgIdx = tocToPkgIdx.get(i);
                  if (pkgIdx !== undefined) {
                    pkg = packages[pkgIdx];
                  }
                }
                // Use TOC index as unique key — handles duplicate headings and orphaned TOC entries
                const checkKey = `toc#${i}`;
                const uniqueKey = `${tocNumbers[i]}#${entry.text}`;
                const isChecked = checkedHeadings.has(checkKey);
                const rating = ratings[uniqueKey] ?? null;
                const hasScenarios = pkg && hasGeneratedScenarios(pkg.feature);
                const chNum = tocNumbers[i];
                const relationComponent = relationComponentsById.get(uniqueKey);
                const relationGroupSummary = relationGroupSummaryById.get(uniqueKey) ?? '';
                return (
                  <li
                    key={i}
                    className={[
                      styles.tocEntry,
                      entry.kind === 'package' ? styles.tocPackage : '',
                      entry.kind === 'skipped' ? styles.tocSkipped : '',
                      entry.kind === 'structure' ? styles.tocStructure : '',
                    ].filter(Boolean).join(' ')}
                    style={{ paddingLeft: `${(entry.level - 1) * 20 + 12}px` }}
                  >
                    {entry.kind === 'package' ? (
                      <div className={`${styles.tocPackageBlock} ${postDropShieldActive ? styles.tocPackageBlockShielded : ''}`}>
                        <div
                          className={styles.tocPackageDropZone}
                          draggable={!isBusy}
                          onDragStart={() => {
                            suppressPostDropInteraction();
                            setDragLinkFromId(uniqueKey);
                          }}
                          onDragEnd={() => {
                            suppressPostDropInteraction();
                            armPostDropShield();
                            setDragLinkFromId(null);
                          }}
                          onDragOver={(ev) => {
                            ev.preventDefault();
                            ev.stopPropagation();
                          }}
                          onDrop={(ev) => {
                            ev.preventDefault();
                            ev.stopPropagation();
                            suppressPostDropInteraction();
                            armPostDropShield();
                            if (!dragLinkFromId || dragLinkFromId === uniqueKey) return;
                            addManualLink(dragLinkFromId, uniqueKey);
                            setDragLinkFromId(null);
                          }}
                          onClickCapture={(ev) => {
                            if (Date.now() < dragInteractionBlockUntilRef.current) {
                              ev.preventDefault();
                              ev.stopPropagation();
                            }
                          }}
                          onMouseUpCapture={(ev) => {
                            if (Date.now() < dragInteractionBlockUntilRef.current) {
                              ev.preventDefault();
                              ev.stopPropagation();
                            }
                          }}
                        >
                        <div className={styles.tocCheckLabel}>
                          <button
                            type="button"
                            className={styles.tocExpandBtn}
                            onClick={() => setDescriptionModal({
                              title: `${chNum} ${entry.text}`.trim(),
                              text: pkg?.sourceText || '',
                            })}
                            title={t('docx.toggleDescription')}
                          >
                            <span className={styles.eyeIcon} aria-hidden>👁</span>
                          </button>
                          <input
                            type="checkbox"
                            checked={isChecked}
                            onChange={() => handleTogglePackage(checkKey)}
                            disabled={isBusy}
                            className={styles.tocCheckbox}
                          />
                          <span className={styles.tocChapterNum}>{chNum}</span>
                          {pkg && pkgExistsOnDisk(pkg, chNum) && (
                            <span className={styles.tocFileExistsBadge} title={t('docx.fileExistsTitle')}>{t('docx.fileExists')}</span>
                          )}
                          {hasScenarios && (
                            <span className={styles.tocHasScenariosBadge} title={t('docx.scenariosAvailableTitle')}>✓</span>
                          )}
                          {rating && (
                            <span className={styles.tocRatingBadge} style={{ background: ratingBgColor(rating.score) }}>
                              {rating.score}%
                            </span>
                          )}
                          <span
                            className={styles.tocEntryText}
                            onClick={() => !isBusy && handleTogglePackage(checkKey)}
                            style={{ cursor: isBusy ? 'default' : 'pointer' }}
                          >{entry.text}</span>
                          {(gapCountByPackageId.get(uniqueKey) || 0) > 0 && (
                            <button
                              type="button"
                              className={styles.tocWarningBtn}
                              onClick={() => {
                                setWarningPanelOpen(true);
                                setWarningFocusId(uniqueKey);
                              }}
                              title={t('docx.showWarningsTitle')}
                            >
                              ⚠ {gapCountByPackageId.get(uniqueKey)}
                            </button>
                          )}
                        </div>
                        </div>
                        {(relationGroupSummary || (relationComponent?.length ?? 0) > 1) && (
                          <div className={styles.tocGroupRow}>
                            <span className={styles.tocGroupBadge}>
                              {t('docx.linkedLabel')}: {relationGroupSummary}
                            </span>
                            {(relationComponent?.length ?? 0) > 1 && relationComponent && (
                              <span className={styles.tocGroupCount}>
                                {relationComponent.length} {t('docx.partsLabel')}
                              </span>
                            )}
                          </div>
                        )}
                        {rawResponses[uniqueKey] && (
                          <>
                            <button
                              type="button"
                              onClick={() => setExpandedRaw((prev) => {
                                const next = new Set(prev);
                                next.has(uniqueKey) ? next.delete(uniqueKey) : next.add(uniqueKey);
                                return next;
                              })}
                              style={{
                                background: 'none', border: 'none', cursor: 'pointer',
                                fontSize: '0.7rem', color: 'var(--color-text-muted)', padding: '2px 4px',
                              }}
                            >
                              {expandedRaw.has(uniqueKey) ? '▼' : '▶'} {t('docx.aiRawResponse')}
                            </button>
                            {expandedRaw.has(uniqueKey) && (
                              <pre style={{
                                fontSize: '0.7rem', background: 'var(--color-bg-subtle, #f6f8fa)',
                                padding: '8px', borderRadius: '4px', overflow: 'auto',
                                maxHeight: '300px', whiteSpace: 'pre-wrap', margin: '4px 0',
                              }}>
                                {rawResponses[uniqueKey]}
                              </pre>
                            )}
                          </>
                        )}
                        {(pkg?.kundeField || pkg?.aufwandField) && (
                          <div className={styles.tocMetaRow}>
                            {pkg?.kundeField && (
                              <span className={styles.tocMetaBadge} title={t('docx.realization', { value: pkg.kundeField })}>
                                {pkg.kundeField}
                              </span>
                            )}
                            {pkg?.aufwandField && (
                              <span className={styles.tocMetaBadge} title={t('docx.effort', { value: pkg.aufwandField })}>
                                ({pkg.aufwandField})
                              </span>
                            )}
                          </div>
                        )}
                        {(() => {
                          const links = linksByPackageId.get(uniqueKey) || [];
                          if (links.length === 0) return null;
                          return (
                            <div className={styles.tocLinksRow}>
                              {links.map((link, li) => {
                                const otherId = link.fromId === uniqueKey ? link.toId : link.fromId;
                                const otherLabel = link.fromId === uniqueKey ? link.toLabel : link.fromLabel;
                                return (
                                  <span
                                    key={`${relationKey(link.fromId, link.toId)}-${link.relation}-${li}`}
                                    className={`${styles.tocLinkBadge} ${styles[`relationType_${getRelationTypeKey(link.relation)}`]}`}
                                  >
                                    <button
                                      type="button"
                                      className={styles.tocLinkJump}
                                      onClick={() => selectRelationPackage(otherId)}
                                      title={t('docx.selectLinkedChapter')}
                                    >
                                      {link.relation}: {otherLabel}
                                    </button>
                                    <button
                                      type="button"
                                      className={styles.tocLinkDelete}
                                      onClick={() => removeLink(link.fromId, link.toId, link.relation)}
                                      title={t('docx.deleteLink')}
                                    >
                                      ✕
                                    </button>
                                  </span>
                                );
                              })}
                            </div>
                          );
                        })()}
                        {rating && (
                          <div className={styles.tocRatingDetail}>
                            <div className={styles.tocRatingHeader}>
                              <span className={styles.ratingBadge} style={{ background: ratingBgColor(rating.score) }}>
                                {rating.score}%
                              </span>
                              <div className={styles.ratingBar}>
                                <div
                                  className={styles.ratingBarFill}
                                  style={{ width: `${rating.score}%`, background: ratingBgColor(rating.score) }}
                                />
                              </div>
                              {rating.reason && (
                                <span className={styles.tocRatingReason}>{rating.reason}</span>
                              )}
                            </div>
                            {rating.suggestions && rating.suggestions.length > 0 && (
                              <ul className={styles.ratingSuggestions}>
                                {rating.suggestions.map((s, si) => <li key={si}>{s}</li>)}
                              </ul>
                            )}
                            {rating.inconsistencies && rating.inconsistencies.length > 0 && (
                              <div className={styles.inconsistenciesBlock}>
                                <span className={styles.inconsistenciesLabel}>{t('docx.inconsistenciesLabel')}</span>
                                <ul className={styles.inconsistenciesList}>
                                  {rating.inconsistencies.map((inc, ii) => <li key={ii}>{inc}</li>)}
                                </ul>
                              </div>
                            )}
                          </div>
                        )}
                      </div>
                    ) : (
                      <span className={styles.tocEntryRow}>
                        {entry.kind === 'structure' && (
                          <button
                            type="button"
                            className={styles.tocChainBtn}
                            onClick={() => connectStructureChain(i)}
                            disabled={isBusy || getStructureChainRelationIds(i).length < 2}
                            title={t('docx.connectChaptersChain')}
                          >
                            🔗
                          </button>
                        )}
                        <span className={styles.tocChapterNum}>{chNum}</span>
                        {entry.kind === 'skipped' && <span className={styles.tocSkippedMark}>—</span>}
                        <span className={styles.tocEntryText}>{entry.text}</span>
                      </span>
                    )}
                  </li>
                );
              });
              })()}
            </ul>
          </div>

          {relationGaps.length > 0 && (
            <div className={styles.warningRail}>
              <button
                type="button"
                className={styles.warningRailBtn}
                onClick={() => setWarningPanelOpen((prev) => !prev)}
                title={t('docx.showWarningsTitle')}
              >
                ⚠ {relationGaps.length}
              </button>
            </div>
          )}

          {warningPanelOpen && relationGaps.length > 0 && (
            <div className={styles.warningPanel}>
              <div className={styles.warningPanelHeader}>
                <span>{t('docx.warningsAndUncertainties')}</span>
                <button
                  type="button"
                  className={styles.warningPanelClose}
                  onClick={() => {
                    setWarningPanelOpen(false);
                    setWarningFocusId(null);
                  }}
                >
                  ✕
                </button>
              </div>
              <ul className={styles.warningList}>
                {relationGaps
                  .filter((gap) => !warningFocusId || (gap.related || []).includes(warningFocusId))
                  .map((gap, gi) => (
                    <li key={`${gap.message}-${gi}`} className={styles[`warning_${gap.severity}`]}>
                      <span className={styles.warningSeverity}>{gap.severity.toUpperCase()}</span>
                      <span>{gap.message}</span>
                      {(gap.related || []).length > 0 && (
                        <span className={styles.warningRelated}>
                          {(gap.related || []).join(' · ')}
                        </span>
                      )}
                    </li>
                  ))}
              </ul>

            </div>
          )}

          {lastRemovedLink && (
            <div className={styles.undoToast}>
              <span>
                {t('docx.linkDeleted')} {lastRemovedLink.fromLabel} → {lastRemovedLink.toLabel}
              </span>
              <button type="button" className={styles.undoToastBtn} onClick={undoRemoveLink}>
                {t('docx.undo')}
              </button>
            </div>
          )}

          {descriptionModal && (
            <div className={styles.descriptionModalOverlay} onClick={() => setDescriptionModal(null)}>
              <div className={styles.descriptionModal} onClick={(ev) => ev.stopPropagation()}>
                <div className={styles.descriptionModalHeader}>
                  <span className={styles.descriptionModalTitle}>{descriptionModal.title}</span>
                  <button type="button" className={styles.descriptionModalClose} onClick={() => setDescriptionModal(null)}>
                    ✕
                  </button>
                </div>
                <div className={styles.descriptionModalBody}>
                  <pre className={styles.descriptionModalText}>{descriptionModal.text || t('docx.noDescriptionAvailable')}</pre>
                </div>
              </div>
            </div>
          )}

          {/* Footer intentionally removed — buttons are now above the TOC */}
        </>
      )}

      {/* Legacy flat card view (no TOC available) */}
      {!useTocView && (packages.length > 0 || skipped.length > 0) && (
        <>
          <div className={styles.featureList}>
            {packages.map((pkg, index) => (
              <LegacyFeatureCard
                key={index}
                pkg={pkg}
                onEdit={() => onLoadToEditor(pkg.feature)}
                onRemove={() => setPackages((prev) => prev.filter((_, i) => i !== index))}
                disabled={isBusy}
                showRating={showAi}
                rating={ratings[pkg.sourceHeading] ?? null}
                t={t}
              />
            ))}
            {skipped.length > 0 && (
              <>
                {packages.length > 0 && <div className={styles.skippedDivider}>{t('docx.skippedChapters')}</div>}
                {skipped.map((ch, index) => (
                  <div key={`skipped-${index}`} className={styles.featureCardSkipped}>
                    <div className={styles.featureHeader}>
                      <span className={styles.statusSkipped}>&mdash;</span>
                      <span className={styles.featureName}>{ch.sourceHeading}</span>
                      <span className={styles.featureStats}>{ch.reason}</span>
                    </div>
                  </div>
                ))}
              </>
            )}
          </div>
          <div className={styles.footer}>
            {showAi && importableCount > 0 && (
              <>
                <button
                  className={styles.ratingBulkBtn}
                  onClick={isBulkRating ? handleCancelAi : handleBulkRating}
                  disabled={isBusy && !isBulkRating}
                  type="button"
                >
                  {isBulkRating ? t('docx.cancel') : t('docx.rateAll', { count: importableCount })}
                </button>
                <button
                  className={styles.aiBtn}
                  onClick={isEnhancing ? handleCancelAi : handleAiGenerate}
                  disabled={isBusy && !isEnhancing}
                  type="button"
                >
                  {isEnhancing ? t('docx.cancel') : t('docx.aiGenerate', { count: importableCount })}
                </button>
              </>
            )}
          </div>
        </>
      )}
      </div>{/* end mainColumn */}

      {autoAnalyzePrompt.open && (
        <ConfirmDialog
          title={t('docx.autoAnalyzeTitle')}
          message={t('docx.autoAnalyzeMessage')}
          confirmLabel={t('docx.yes')}
          secondaryLabel={t('docx.skipAnalysis')}
          cancelLabel={t('bulk.cancel')}
          onConfirm={handleAutoAnalyzeYes}
          onSecondary={handleAutoAnalyzeWithout}
          onCancel={handleAutoAnalyzeAbort}
        />
      )}

      {showNoTablesConfirm && (
        <ConfirmDialog
          title={t('docx.continueWithoutTablesTitle')}
          message={t('docx.noTablesWarning')}
          confirmLabel={t('docx.yes')}
          cancelLabel={t('bulk.cancel')}
          onConfirm={() => {
            setShowNoTablesConfirm(false);
            const resolve = noTablesConfirmResolverRef.current;
            noTablesConfirmResolverRef.current = null;
            resolve?.(true);
          }}
          onCancel={() => {
            setShowNoTablesConfirm(false);
            const resolve = noTablesConfirmResolverRef.current;
            noTablesConfirmResolverRef.current = null;
            resolve?.(false);
          }}
        />
      )}

    </div>
  );
}

function ratingBgColor(score: number) {
  if (score >= 80) return '#388e3c';
  if (score >= 50) return '#f57c00';
  return '#d32f2f';
}

// ── Minimal legacy card for no-TOC fallback ───────────────────

function LegacyFeatureCard({
  pkg,
  onEdit,
  onRemove,
  disabled,
  showRating,
  rating,
  t,
}: {
  pkg: ParsedFeaturePackage;
  onEdit: () => void;
  onRemove: () => void;
  disabled?: boolean;
  showRating?: boolean;
  rating: AiPromptRating | null;
  t: TranslationFn;
}) {
  const { feature, validation } = pkg;
  const errors = hasErrors(validation);
  const cardClass = errors ? styles.featureCardError : styles.featureCardOk;
  const statusClass = errors ? styles.statusError : styles.statusOk;

  return (
    <div className={cardClass}>
      <div className={styles.featureHeader}>
        <span className={statusClass}>{errors ? '✗' : '✓'}</span>
        <span className={styles.featureName}>{feature.name || pkg.sourceHeading || t('docx.noName')}</span>
        <div className={styles.featureActions}>
          {!errors && (
            <button className={styles.actionBtn} onClick={onEdit} disabled={disabled} type="button">
              {t('docx.edit')}
            </button>
          )}
          <button className={styles.removeBtn} onClick={onRemove} disabled={disabled} type="button">
            {t('docx.remove')}
          </button>
        </div>
      </div>
      {showRating && rating && (
        <div className={styles.ratingBlock}>
          <span className={styles.ratingBadge} style={{ background: ratingBgColor(rating.score) }}>{rating.score}%</span>
          {rating.reason && <div className={styles.ratingReason}>{rating.reason}</div>}
        </div>
      )}
    </div>
  );
}
