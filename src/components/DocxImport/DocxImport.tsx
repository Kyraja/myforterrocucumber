/**
 * @module DocxImport
 * Document import panel for parsing .docx / Confluence source files into feature packages.
 *
 * Key responsibilities:
 * - Parses uploaded .docx files (or Confluence HTML) into ParsedFeaturePackage objects,
 *   mapping headings / work-package chapters to FeatureInput structures.
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
import { useState, useRef, useMemo } from 'react';
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
import { chatWithAgentSync, isLoggedIn, getValidToken, TokenLimitError } from '../../lib/myforterroApi';
import { updateLastResponseSummary } from '../../lib/tokenHistory';
import { generatePackage } from '../../lib/generatePackage';
import { mergeFeatureGroup } from '../../lib/mergeFeatureGroup';
import { makeFeatureGuid } from '../../lib/featureGuid';
import { getForceKiTableId } from '../../lib/settings';
import styles from './DocxImport.module.css';

/** Realisierung value that indicates the customer handles this package (no tests needed from us). */
const KUNDE_REALISIERUNG = /^kunde$/i;

/** A feature counts as "already generated" only if it has scenarios with actual steps.
 *  Scenarios parsed from the source text (e.g. headings containing "Szenario") may be empty shells. */
function hasGeneratedScenarios(feature: FeatureInput): boolean {
  return feature.scenarios.some((s) => s.steps.length > 0);
}

interface DocxImportProps {
  onLoadToEditor: (feature: FeatureInput) => void;
  model: string;
  tables: TableDef[];
  onTablesChange: (tables: TableDef[]) => void;
  showAi: boolean;
  /** Called after AI generation is done — creates folder + agent + saves .feature files */
  onCreateWithAgent?: (packages: ParsedFeaturePackage[], fileName: string, tocInfo?: TocInfo) => Promise<void>;
  /** API agent ID for AI calls (from Standard-Agent or folder agent) */
  agentApiId?: string | null;
  /** GUIDs of feature files that already exist on disk */
  existingFeatureGuids?: Set<string>;
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
  tables,
  onTablesChange,
  showAi,
  onCreateWithAgent,
  agentApiId,
  existingFeatureGuids,
  onBulkActivityChange,
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

  // Checked package headings (for TOC view)
  const [checkedHeadings, setCheckedHeadings] = useState<Set<string>>(new Set());

  // Feature groups: structure headings marked to merge children into one .feature file
  const [featureGroups, setFeatureGroups] = useState<Set<string>>(new Set());

  // Expanded descriptions in TOC
  const [expandedHeadings, setExpandedHeadings] = useState<Set<string>>(new Set());

  // AI generation state
  const [aiError] = useState<string | null>(null);
  const [aiProgress, setAiProgress] = useState({ current: 0, total: 0 });
  const cancelRef = useRef(false);

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
    setExpandedHeadings(new Set());
  };

  // Toggle a checkbox in the TOC
  const toggleHeading = (key: string) => {
    console.log('[DocxImport] toggleHeading:', key, 'current:', [...checkedHeadings]);
    setCheckedHeadings((prev) => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  };

  // Toggle expanded description in TOC
  const toggleExpanded = (heading: string) => {
    setExpandedHeadings((prev) => {
      const next = new Set(prev);
      if (next.has(heading)) next.delete(heading);
      else next.add(heading);
      return next;
    });
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

  // Toggle a structure heading as feature group (merge children into one .feature)
  const toggleFeatureGroup = (tocIdx: number) => {
    const key = `toc#${tocIdx}`;
    setFeatureGroups((prev) => {
      const next = new Set(prev);
      if (next.has(key)) {
        next.delete(key);
      } else {
        next.add(key);
        // Auto-check all descendant packages
        const groupLevel = toc[tocIdx].level;
        const childKeys: string[] = [];
        for (let j = tocIdx + 1; j < toc.length; j++) {
          if (toc[j].level <= groupLevel) break;
          if (toc[j].kind === 'package') childKeys.push(`toc#${j}`);
        }
        if (childKeys.length > 0) {
          setCheckedHeadings((prev2) => {
            const next2 = new Set(prev2);
            for (const ck of childKeys) next2.add(ck);
            return next2;
          });
        }
      }
      return next;
    });
  };

  // Compute which TOC package indices are claimed by a feature group
  const featureGroupChildren = useMemo(() => {
    const map = new Map<string, number[]>();
    for (const key of featureGroups) {
      const gIdx = parseInt(key.replace('toc#', ''), 10);
      if (isNaN(gIdx) || gIdx >= toc.length) continue;
      const groupLevel = toc[gIdx].level;
      const children: number[] = [];
      for (let j = gIdx + 1; j < toc.length; j++) {
        if (toc[j].level <= groupLevel) break;
        if (toc[j].kind === 'package') children.push(j);
      }
      map.set(key, children);
    }
    return map;
  }, [featureGroups, toc]);

  // Set of TOC indices that belong to a feature group (for rendering)
  const groupedPackageIndices = useMemo(() => {
    const set = new Set<number>();
    for (const children of featureGroupChildren.values()) {
      for (const idx of children) set.add(idx);
    }
    return set;
  }, [featureGroupChildren]);

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

  // All checked packages — including those without scenarios yet (AI will generate them)
  // Feature groups produce merged packages; ungrouped packages pass through individually.
  const checkedPackages = useMemo(() => {
    const result: ParsedFeaturePackage[] = [];
    const claimedTocIndices = new Set<number>();

    // 1. Process feature groups first
    for (const [groupKey, childTocIndices] of featureGroupChildren) {
      const gIdx = parseInt(groupKey.replace('toc#', ''), 10);
      const childPkgs: ParsedFeaturePackage[] = [];
      for (const tocIdx of childTocIndices) {
        if (!checkedHeadings.has(`toc#${tocIdx}`)) continue;
        claimedTocIndices.add(tocIdx);
        const pkgIdx = tocToPkgIdx.get(tocIdx);
        if (pkgIdx !== undefined) {
          childPkgs.push(packages[pkgIdx]);
        }
      }
      if (childPkgs.length > 0) {
        const chNum = tocNumbers[gIdx] || '';
        const heading = chNum ? `${chNum} ${toc[gIdx].text}` : toc[gIdx].text;
        result.push(mergeFeatureGroup(heading, childPkgs));
      }
    }

    // 2. Process remaining (ungrouped) checked packages
    toc.forEach((entry, tocIdx) => {
      if (entry.kind !== 'package' || claimedTocIndices.has(tocIdx) || !checkedHeadings.has(`toc#${tocIdx}`)) return;
      const pkgIdx = tocToPkgIdx.get(tocIdx);
      if (pkgIdx !== undefined) {
        result.push(packages[pkgIdx]);
      }
    });
    return result;
  }, [toc, packages, checkedHeadings, featureGroupChildren, tocNumbers, tocToPkgIdx]);

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
  ): Promise<{
    feature: FeatureInput; rawResponse: string;
    tableIdPath: 'local'|'ki'|'none'; identifiedTables: string[];
    fieldCount: number; tableIdRequest?: string; tableIdRawResponse?: string;
    gherkinRequest?: string; tableContext?: string;
  }> => {
    const { getTestDepth } = await import('../../lib/settings');
    const result = await generatePackage({
      text, model, tables, testUser, agentId, featureName,
      forcedRelevantTables, onPromptBuilt, onTablesIdentified, onTableIdStarted,
      testDepth: getTestDepth(),
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
    const result = await chatWithAgentSync(agentId, userMessage, null, 'rating', model, ratingDetails);
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
    const enhanced: ParsedFeaturePackage[] = [];
    const errorDetails: string[] = [];

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
        console.log(`[KI-Gen] ${i + 1}/${pkgsToGenerate.length}: "${featureNameForKi}" → GUID @${guid}`);

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
        const GUID_RE = /^@[0-9a-f]{16}$/;
        const aiTags = genResult.feature.tags.filter((t: string) => !GUID_RE.test(t));
        const tags = [`@${guid}`, ...aiTags];

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
          setError(t('docx.tokenLimitReached'));
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
      setError('Sitzung abgelaufen. Bitte erneut anmelden.');
      return false;
    }
    if (tables.length === 0 && !window.confirm(t('docx.noTablesWarning'))) return false;
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

  // ── Rating ────────────────────────────────────────────────────

  const [bulkRatingProgress, setBulkRatingProgress] = useState({ current: 0, total: 0 });
  const isBulkRating = bulkRatingProgress.total > 0;

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
  const isBusy = isEnhancing || isBulkRating || isSendingToAgent;

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
      {(error || aiError || ratingError) && (
        <div style={{ color: 'var(--color-danger)', fontSize: '0.85rem', marginBottom: 'var(--spacing)', whiteSpace: 'pre-line' }}>
          {error || aiError || ratingError}
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
                {isEnhancing ? t('docx.cancel') : `🤖 KI-Tests generieren (${checkedPackages.length} APs, ~${(checkedTokenEstimate / 1000).toFixed(1)}k Tokens)`}
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
                {isBulkRating ? t('docx.cancel') : `Bewertung (${checkedPackages.length} APs)`}
              </button>
            )}

          </div>

          <div className={styles.tocContainer}>
            <div className={styles.tocHeader}>
              <span className={styles.tocTitle}>Inhaltsverzeichnis — {docxFileName}</span>
              <span className={styles.tocSelectBtns}>
                <button type="button" className={styles.tocSelectBtn} onClick={selectAllPackages}>Alles auswählen</button>
                <button type="button" className={styles.tocSelectBtn} onClick={deselectAllPackages}>Alles abwählen</button>
              </span>
              <span className={styles.tocLegend}>
                <span className={styles.legendPkg}>☑ Arbeitspaket (für KI-Generierung)</span>
                <span className={styles.legendSkipped}>— Kein Customizing (übersprungen)</span>
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
                return (
                  <li
                    key={i}
                    className={[
                      styles.tocEntry,
                      entry.kind === 'package' ? styles.tocPackage : '',
                      entry.kind === 'skipped' ? styles.tocSkipped : '',
                      entry.kind === 'structure' ? styles.tocStructure : '',
                      groupedPackageIndices.has(i) ? styles.tocGrouped : '',
                    ].filter(Boolean).join(' ')}
                    style={{ paddingLeft: `${(entry.level - 1) * 20 + 12}px` }}
                  >
                    {entry.kind === 'package' ? (
                      <div className={styles.tocPackageBlock}>
                        <div className={styles.tocCheckLabel}>
                          <input
                            type="checkbox"
                            checked={isChecked}
                            onChange={() => toggleHeading(checkKey)}
                            disabled={isBusy}
                            className={styles.tocCheckbox}
                          />
                          <span className={styles.tocChapterNum}>{chNum}</span>
                          <button
                            type="button"
                            className={styles.tocExpandBtn}
                            onClick={() => toggleExpanded(uniqueKey)}
                            title="Beschreibung ein-/ausklappen"
                          >
                            <span className={expandedHeadings.has(uniqueKey) ? styles.expandArrowOpen : styles.expandArrow}>
                              ▶
                            </span>
                          </button>
                          {pkg && pkgExistsOnDisk(pkg, chNum) && (
                            <span className={styles.tocFileExistsBadge} title="Feature-Datei existiert bereits im Ordner">existiert</span>
                          )}
                          {hasScenarios && (
                            <span className={styles.tocHasScenariosBadge} title="Szenarien vorhanden">✓</span>
                          )}
                          {rating && (
                            <span className={styles.tocRatingBadge} style={{ background: ratingBgColor(rating.score) }}>
                              {rating.score}%
                            </span>
                          )}
                          <span
                            className={styles.tocEntryText}
                            onClick={() => !isBusy && toggleHeading(checkKey)}
                            style={{ cursor: isBusy ? 'default' : 'pointer' }}
                          >{entry.text}</span>
                        </div>
                        {expandedHeadings.has(uniqueKey) && pkg?.sourceText && (
                          <div className={styles.tocDescription}>
                            {pkg.sourceText}
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
                              {expandedRaw.has(uniqueKey) ? '▼' : '▶'} KI-Rohantwort
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
                              <span className={styles.tocMetaBadge} title={`Realisierung: ${pkg.kundeField}`}>
                                {pkg.kundeField}
                              </span>
                            )}
                            {pkg?.aufwandField && (
                              <span className={styles.tocMetaBadge} title={`Aufwand: ${pkg.aufwandField}`}>
                                ({pkg.aufwandField})
                              </span>
                            )}
                          </div>
                        )}
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
                                <span className={styles.inconsistenciesLabel}>Widersprüche</span>
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
                        <span className={styles.tocChapterNum}>{chNum}</span>
                        {entry.kind === 'skipped' && <span className={styles.tocSkippedMark}>—</span>}
                        {entry.kind === 'structure' && (
                          <button
                            type="button"
                            className={featureGroups.has(checkKey) ? styles.featureGroupActive : styles.featureGroupBtn}
                            onClick={() => toggleFeatureGroup(i)}
                            title={featureGroups.has(checkKey)
                              ? 'Feature-Gruppe aufheben (jedes Paket wird eigene .feature-Datei)'
                              : 'Als Feature-Gruppe markieren (alle Kinder werden Szenarien in einer .feature-Datei)'}
                            disabled={isBusy}
                          >
                            {featureGroups.has(checkKey) ? 'Feature' : 'Feature'}
                          </button>
                        )}
                        <span className={styles.tocEntryText}>{entry.text}</span>
                      </span>
                    )}
                  </li>
                );
              });
              })()}
            </ul>
          </div>

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
