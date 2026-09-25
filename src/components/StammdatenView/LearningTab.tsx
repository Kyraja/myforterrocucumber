import { useEffect, useMemo, useRef, useState } from 'react';
import type { LearningCategory, LearningEntry, LearningUsage } from '../../types/learning';
import { chatWithAgentSync, discoverMftAgents } from '../../lib/myforterroApi';
import { getCustomLearningSuggestionPrompt } from '../../lib/settings';
import { buildDefaultLearningSuggestionPrompt } from '../../lib/learningSuggestionPrompt';
import {
  buildLearningPromptHints,
  createDefaultLearnings,
  importReferenceExamplesFromDirectoryHandle,
  importReferenceExamplesFromFileList,
  importWorkspaceDataLearnings,
  loadWorkspaceLearnings,
  mergeLearnings,
  parseLearningsMarkdown,
  saveSharedLearnings,
  saveWorkspaceLearnings,
  serializeLearningsMarkdown,
} from '../../lib/learningStore';
import {
  getLearningCrosscheckMode,
  isFopAutoRefreshEnabled,
  setFopAutoRefreshEnabled,
  setFopAutoRefreshIntervalSeconds,
  setLearningCrosscheckMode,
  type LearningCrosscheckMode,
} from '../../lib/settings';
import styles from './LearningTab.module.css';

const PROGRAMS_USAGE_MIGRATION_KEY = 'cucumbergnerator_learning_usage_programs_migration_v1';
const PROMPT_RULES_MIGRATION_KEY = 'cucumbergnerator_prompt_rules_to_learnings_migration_v1';

interface LearningTabProps {
  rootHandle: FileSystemDirectoryHandle | null;
  lang: 'de' | 'en';
  onLearningsChanged?: (entries: LearningEntry[]) => void;
  agentApiId?: string | null;
  model?: string;
  viewMode?: 'combined' | 'learnings-only' | 'sources-only';
}

interface AiLearningSuggestion {
  title: string;
  summary: string;
  comment?: string;
  keywords?: string[];
  category?: LearningCategory;
  scope?: 'customer' | 'general';
  usage?: LearningUsage;
  confirmed?: boolean;
}

function parseAiLearningSuggestion(raw: string): AiLearningSuggestion | null {
  const fence = raw.match(/```(?:json)?\s*([\s\S]*?)```/i);
  const payload = (fence ? fence[1] : raw).trim();
  try {
    const parsed = JSON.parse(payload) as Partial<AiLearningSuggestion>;
    if (!parsed || typeof parsed !== 'object') return null;
    if (typeof parsed.title !== 'string' || typeof parsed.summary !== 'string') return null;
    const rawUsage = (parsed as { usage?: string }).usage;
    const normalizedUsage: LearningUsage | undefined = rawUsage === 'concept'
      ? 'programs'
      : rawUsage === 'tests' || rawUsage === 'programs' || rawUsage === 'both' || rawUsage === 'tests-global'
        ? rawUsage
        : undefined;
    return {
      title: parsed.title.trim(),
      summary: parsed.summary.trim(),
      comment: typeof parsed.comment === 'string' ? parsed.comment.trim() : undefined,
      keywords: Array.isArray(parsed.keywords) ? parsed.keywords.map((k) => String(k).trim()).filter(Boolean) : [],
      category: parsed.category,
      scope: parsed.scope,
      usage: normalizedUsage,
      confirmed: typeof parsed.confirmed === 'boolean' ? parsed.confirmed : true,
    };
  } catch {
    return null;
  }
}

const CATEGORY_LABELS: Record<LearningCategory, { de: string; en: string }> = {
  rule: { de: 'Regel', en: 'Rule' },
  pattern: { de: 'Pattern', en: 'Pattern' },
  warning: { de: 'Warnung', en: 'Warning' },
  example: { de: 'Beispiel', en: 'Example' },
};

function getImportSourceLabel(
  source: 'fop' | 'infosysteme' | 'variablentabelle' | 'customsteps' | 'features' | 'fopsdocs' | 'extracted' | 'pdfs',
  lang: 'de' | 'en',
): string {
  if (lang === 'de') {
    if (source === 'fop') return 'FOP/FOP-Befehle';
    if (source === 'infosysteme') return 'Infosysteme';
    if (source === 'variablentabelle') return 'Variablentabelle';
    if (source === 'customsteps') return 'CustomSteps';
    if (source === 'fopsdocs') return 'FOP-Dokumente';
    if (source === 'extracted') return 'PDF-/Text-Extrakte';
    if (source === 'pdfs') return 'PDF-Direktextraktion';
    return 'Feature-Bestand';
  }
  if (source === 'fop') return 'FOP/FOP commands';
  if (source === 'infosysteme') return 'Infosystems';
  if (source === 'variablentabelle') return 'Variable table';
  if (source === 'customsteps') return 'Custom steps';
  if (source === 'fopsdocs') return 'FOP documents';
  if (source === 'extracted') return 'PDF/text extracts';
  if (source === 'pdfs') return 'Direct PDF extraction';
  return 'Feature corpus';
}

function createPromptExtractedGlobalRules(now: string): LearningEntry[] {
  return [
    {
      id: 'std-bdd-transactions-cleanup-contextual',
      title: 'Globalregel Tests: Bewegungsdaten kontextbezogen bereinigen',
      summary: 'Wenn ein erzeugter Bewegungsbeleg im selben Szenario nicht weiterverwendet wird, muss ein fachlicher Bereinigungsschritt enthalten sein (final weiterverarbeiten, REVERSAL oder passender Abschluss). Keine offenen Prozessbelege stehen lassen.',
      comment: 'Betrifft fachliche Testsauberkeit in EK/VK-Prozessketten.',
      keywords: ['bewegungsdaten', 'cleanup', 'reversal', 'prozessbeleg', 'offen'],
      category: 'rule',
      scope: 'general',
      usage: 'tests-global',
      confirmed: true,
      acceptedCount: 1,
      rejectedCount: 0,
      sourcePath: 'domain/bdd-cleanup',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-bdd-transactions-delete-or-position-storno',
      title: 'Globalregel Tests: Positions-Storno bzw. DELETE nach Prozesskontext',
      summary: 'Offene EK/VK-Restmengen ueber Positions-Storno/Abschlusskennzeichen bereinigen; sonstige offene Prozessbelege koennen bei passendem Kontext ueber command "DELETE" entfernt werden.',
      comment: 'Nur anwenden, wenn der Prozesskontext diese Art der Bereinigung fachlich erlaubt.',
      keywords: ['positions-storno', 'delete', 'ek', 'vk', 'restmenge'],
      category: 'rule',
      scope: 'general',
      usage: 'tests-global',
      confirmed: true,
      acceptedCount: 1,
      rejectedCount: 0,
      sourcePath: 'domain/bdd-cleanup',
      createdAt: now,
      updatedAt: now,
    },
    {
      id: 'std-bdd-wiedervorlage-offer-framework-only',
      title: 'Globalregel Tests: Wiedervorlage nur bei Angebot/Rahmenauftrag',
      summary: 'Wiedervorlage-bezogene Bereinigung (z. B. Wiedervorlage-Datum entfernen) nur dann einplanen, wenn der Vorgangstyp Angebot oder Rahmenauftrag ist und das Konzept dies verlangt.',
      comment: 'Nicht pauschal auf alle Belegarten anwenden.',
      keywords: ['wiedervorlage', 'angebot', 'rahmenauftrag', 'datum'],
      category: 'rule',
      scope: 'general',
      usage: 'tests-global',
      confirmed: true,
      acceptedCount: 1,
      rejectedCount: 0,
      sourcePath: 'domain/bdd-cleanup',
      createdAt: now,
      updatedAt: now,
    },
  ];
}

export default function LearningTab({ rootHandle, lang, onLearningsChanged, agentApiId, model, viewMode = 'combined' }: LearningTabProps) {
  // ── Data state ─────────────────────────────────────────────────
  const [entries, setEntries] = useState<LearningEntry[]>([]);
  const [selectedLearningId, setSelectedLearningId] = useState<string | null>(null);
  const [quickFilter, setQuickFilter] = useState('');
  const [globalOnly, setGlobalOnly] = useState(false);

  // ── Form state (for new/edit) ──────────────────────────────────
  const [title, setTitle] = useState('');
  const [summary, setSummary] = useState('');
  const [comment, setComment] = useState('');
  const [sourcePath, setSourcePath] = useState('');
  const [keywords, setKeywords] = useState('');
  const [category, setCategory] = useState<LearningCategory>('pattern');
  const [scope, setScope] = useState<'customer' | 'general'>('customer');
  const [usage, setUsage] = useState<LearningUsage>('both');
  const [confirmed, setConfirmed] = useState(true);

  // ── UI state ───────────────────────────────────────────────────
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [lastImportInfo, setLastImportInfo] = useState<string | null>(null);
  const [lastImportAt, setLastImportAt] = useState<number | null>(null);

  // ── AI state ───────────────────────────────────────────────────
  const [aiPrompt, setAiPrompt] = useState('');
  const [aiLoading, setAiLoading] = useState(false);
  const [aiError, setAiError] = useState<string | null>(null);
  const [resolvedAgentApiId, setResolvedAgentApiId] = useState<string | null>(null);

  // ── Reference folder state ─────────────────────────────────────
  const [selectedReferenceFolder, setSelectedReferenceFolder] = useState<FileSystemDirectoryHandle | null>(null);
  const [selectedReferenceFolderLabel, setSelectedReferenceFolderLabel] = useState('');
  const [workspaceImportOnlyNew, setWorkspaceImportOnlyNew] = useState(true);
  const [rightPaneView, setRightPaneView] = useState<'learnings' | 'sources'>(viewMode === 'sources-only' ? 'sources' : 'learnings');

  // ── Refs ───────────────────────────────────────────────────────
  const importRef = useRef<HTMLInputElement>(null);
  const refFolderRef = useRef<HTMLInputElement>(null);

  // ── Computed state ─────────────────────────────────────────────
  const selectedEntry = selectedLearningId
    ? entries.find((e) => e.id === selectedLearningId) ?? null
    : null;

  useEffect(() => {
    if (viewMode === 'learnings-only') {
      setRightPaneView('learnings');
      return;
    }
    if (viewMode === 'sources-only') {
      setRightPaneView('sources');
    }
  }, [viewMode]);

  const activeRightPaneView: 'learnings' | 'sources' = viewMode === 'learnings-only'
    ? 'learnings'
    : viewMode === 'sources-only'
      ? 'sources'
      : rightPaneView;

  const filteredEntries = useMemo(() => {
    const q = quickFilter.trim().toLowerCase();
    return entries.filter((entry) => {
      if (globalOnly && entry.usage !== 'tests-global') return false;
      if (!q) return true;
      const haystack = `${entry.title}\n${entry.summary}\n${entry.comment ?? ''}\n${entry.sourcePath ?? ''}\n${entry.keywords.join(' ')}`.toLowerCase();
      return haystack.includes(q);
    });
  }, [entries, quickFilter, globalOnly]);

  const stats = useMemo(() => {
    const total = entries.length;
    const customer = entries.filter((e) => e.scope === 'customer').length;
    const general = entries.filter((e) => e.scope === 'general').length;
    const global = entries.filter((e) => e.usage === 'tests-global').length;
    const confirmedCount = entries.filter((e) => e.confirmed).length;
    return { total, customer, general, global, confirmedCount };
  }, [entries]);

  // ── Persistence ───────────────────────────────────────────────
  const persist = async (next: LearningEntry[]) => {
    if (!rootHandle) return;
    await saveWorkspaceLearnings(rootHandle, next);
    await saveSharedLearnings(next.filter((entry) => entry.usage === 'tests-global'));
    setEntries(next);
    onLearningsChanged?.(next);
  };

  // ── Load from workspace ────────────────────────────────────────
  const load = async () => {
    if (!rootHandle) return;
    setLoading(true);
    setError(null);
    setLastImportInfo(null);
    try {
      const loaded = await loadWorkspaceLearnings(rootHandle);
      let nextEntries = loaded;
      let migratedFromLegacy = false;
      let migrationDetailLines: string[] = [];
      let promptRulesAdded = 0;

      // Single-source mode: learnings.md is authoritative.
      // If no persisted file content exists yet, perform a one-time bootstrap
      // from legacy defaults/seeds and persist it into learnings.md.
      if (loaded.length === 0) {
        const bootstrapBase = createDefaultLearnings();
        const seeded = await importWorkspaceDataLearnings(rootHandle, bootstrapBase, { importOnlyNew: false });
        nextEntries = seeded.entries;
        migratedFromLegacy = nextEntries.length > 0;
        migrationDetailLines = seeded.sourceStats.map(
          (s) => `${getImportSourceLabel(s.source, lang)}: ${lang === 'de' ? 'gescannt' : 'scanned'}=${s.scanned}, ${lang === 'de' ? 'generiert' : 'generated'}=${s.generated}`,
        );
      }

      const alreadyMigratedPromptRules = localStorage.getItem(PROMPT_RULES_MIGRATION_KEY) === '1';
      if (!alreadyMigratedPromptRules) {
        const now = new Date().toISOString();
        const promptRules = createPromptExtractedGlobalRules(now);
        const promptRuleIds = new Set(promptRules.map((r) => r.id));
        const beforeIds = new Set(nextEntries.map((e) => e.id));
        nextEntries = mergeLearnings(nextEntries, promptRules);

        // Enforce explicit global marker semantics for migrated prompt rules.
        nextEntries = nextEntries.map((entry) => (
          promptRuleIds.has(entry.id)
            ? {
              ...entry,
              category: 'rule',
              scope: 'general',
              usage: 'tests-global',
              confirmed: true,
              updatedAt: now,
            }
            : entry
        ));

        promptRulesAdded = promptRules.filter((rule) => !beforeIds.has(rule.id)).length;
        localStorage.setItem(PROMPT_RULES_MIGRATION_KEY, '1');
      }

      const alreadyMigrated = localStorage.getItem(PROGRAMS_USAGE_MIGRATION_KEY) === '1';
      if (!alreadyMigrated && nextEntries.length > 0) {
        const now = new Date().toISOString();
        nextEntries = nextEntries.map((entry) => ({
          ...entry,
          // Legacy migration: only normalize genuinely missing/legacy values.
          // Never overwrite explicit modern usage tags.
          usage: entry.usage === 'tests' || entry.usage === 'programs' || entry.usage === 'both' || entry.usage === 'tests-global'
            ? entry.usage
            : 'programs',
          updatedAt: now,
        }));
        localStorage.setItem(PROGRAMS_USAGE_MIGRATION_KEY, '1');
      }

      const loadedSignature = serializeLearningsMarkdown(loaded);
      const nextSignature = serializeLearningsMarkdown(nextEntries);
      const changed = loadedSignature !== nextSignature;

      if (changed) {
        await saveWorkspaceLearnings(rootHandle, nextEntries);
      }

      setEntries(nextEntries);
      onLearningsChanged?.(nextEntries);

      setLastImportAt(Date.now());
      setLastImportInfo(
        migratedFromLegacy
          ? [
            lang === 'de'
              ? `Einmalige Migration auf eine Quelle abgeschlossen: ${nextEntries.length} Eintraege in .cucumbergnerator-settings/learnings.md gespeichert.`
              : `One-time migration to a single source complete: ${nextEntries.length} entries persisted in .cucumbergnerator-settings/learnings.md.`,
            ...(promptRulesAdded > 0
              ? [
                lang === 'de'
                  ? `Prompt-Regeln in Learnings ueberfuehrt: ${promptRulesAdded} hinzugefuegt.`
                  : `Prompt rules migrated into learnings: ${promptRulesAdded} added.`,
              ]
              : []),
            ...migrationDetailLines,
          ].join('\n')
          : changed
            ? [
              lang === 'de'
                ? `Learning-Datei aktualisiert: ${nextEntries.length} Eintraege aus .cucumbergnerator-settings/learnings.md.`
                : `Learning file updated: ${nextEntries.length} entries from .cucumbergnerator-settings/learnings.md.`,
              ...(promptRulesAdded > 0
                ? [
                  lang === 'de'
                    ? `Prompt-Regeln in Learnings ueberfuehrt: ${promptRulesAdded} hinzugefuegt.`
                    : `Prompt rules migrated into learnings: ${promptRulesAdded} added.`,
                ]
                : []),
            ].join('\n')
            : (lang === 'de'
              ? `Geladen aus .cucumbergnerator-settings/learnings.md: ${nextEntries.length} Eintraege.`
              : `Loaded from .cucumbergnerator-settings/learnings.md: ${nextEntries.length} entries.`),
      );
    } catch (e) {
      setError((e as Error).message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (!rootHandle) return;
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rootHandle]);

  // ── Form handlers ──────────────────────────────────────────────
  const handleSelectLearning = (id: string) => {
    const entry = entries.find((e) => e.id === id);
    if (!entry) return;
    setSelectedLearningId(id);
    setTitle(entry.title);
    setSummary(entry.summary);
    setComment(entry.comment ?? '');
    setSourcePath(entry.sourcePath ?? '');
    setKeywords(entry.keywords.join(', '));
    setCategory(entry.category);
    setScope(entry.scope);
    setUsage(entry.usage ?? 'both');
    setConfirmed(entry.confirmed);
  };

  const handleNewLearning = () => {
    setSelectedLearningId(null);
    setTitle('');
    setSummary('');
    setComment('');
    setSourcePath('');
    setKeywords('');
    setCategory('pattern');
    setScope('customer');
    setUsage('both');
    setConfirmed(true);
  };

  const handleSaveLearning = async () => {
    const cleanTitle = title.trim();
    const cleanSummary = summary.trim();
    if (!cleanTitle || !cleanSummary) return;
    if (!rootHandle) return;

    const now = new Date().toISOString();

    if (selectedLearningId) {
      // Update existing
      const next = entries.map((entry) => {
        if (entry.id !== selectedLearningId) return entry;
        const effectiveUsage = usage;
        const effectiveScope = effectiveUsage === 'tests-global' ? 'general' : scope;
        const effectiveCategory = effectiveUsage === 'tests-global' ? 'rule' : category;
        return {
          ...entry,
          title: cleanTitle,
          summary: cleanSummary,
          comment: comment.trim() || undefined,
          sourcePath: sourcePath.trim() || undefined,
          keywords: keywords.split(',').map((k) => k.trim()).filter(Boolean),
          category: effectiveCategory,
          scope: effectiveScope,
          usage: effectiveUsage,
          confirmed,
          updatedAt: now,
        };
      });
      await persist(next);
    } else {
      // Add new
      const effectiveUsage = usage;
      const effectiveScope = effectiveUsage === 'tests-global' ? 'general' : scope;
      const effectiveCategory = effectiveUsage === 'tests-global' ? 'rule' : category;
      const entry: LearningEntry = {
        id: crypto.randomUUID(),
        title: cleanTitle,
        summary: cleanSummary,
        comment: comment.trim() || undefined,
        sourcePath: sourcePath.trim() || undefined,
        keywords: keywords.split(',').map((k) => k.trim()).filter(Boolean),
        category: effectiveCategory,
        scope: effectiveScope,
        usage: effectiveUsage,
        confirmed,
        createdAt: now,
        updatedAt: now,
      };
      const next = [entry, ...entries];
      await persist(next);
      setSelectedLearningId(entry.id);
    }
  };

  const handleDeleteLearning = async () => {
    if (!selectedLearningId || !rootHandle) return;
    const next = entries.filter((e) => e.id !== selectedLearningId);
    await persist(next);
    setSelectedLearningId(null);
    handleNewLearning();
  };

  const handleUpdateEntryUsage = async (id: string, nextUsage: LearningUsage) => {
    if (!rootHandle) return;
    const now = new Date().toISOString();
    const next = entries.map((entry) => {
      if (entry.id !== id) return entry;
      return {
        ...entry,
        usage: nextUsage,
        updatedAt: now,
      };
    });
    await persist(next);
  };

  const handleImportFile = async (e: import('react').ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || files.length === 0 || !rootHandle) return;
    const text = await files[0].text();
    const imported = parseLearningsMarkdown(text);
    const merged = mergeLearnings(entries, imported);
    await persist(merged);
    e.target.value = '';
  };

  const handleReferenceFolderPick = async () => {
    if (!window.showDirectoryPicker) {
      setError(lang === 'de' ? 'Ordnerauswahl wird in diesem Browser nicht unterstuetzt.' : 'Folder selection is not supported in this browser.');
      return;
    }
    if (!rootHandle) return;
    setError(null);
    try {
      const picked = await window.showDirectoryPicker({ mode: 'read' });
      const rel = await rootHandle.resolve(picked);
      const label = rel && rel.length > 0 ? rel.join('/') : picked.name;
      setSelectedReferenceFolder(picked);
      setSelectedReferenceFolderLabel(label);
    } catch (e) {
      const err = e as Error;
      if (err.name === 'AbortError') return;
      setError(err.message);
    }
  };

  const handleReferenceFolderIndex = async () => {
    if (!rootHandle) return;
    if (!selectedReferenceFolder) return;
    setError(null);
    setLastImportInfo(null);
    try {
      const result = await importReferenceExamplesFromDirectoryHandle(
        selectedReferenceFolder,
        selectedReferenceFolderLabel || selectedReferenceFolder.name,
        entries,
      );
      await persist(result.entries);
      setLastImportAt(Date.now());
      setLastImportInfo(
        lang === 'de'
          ? `${result.imported} Referenzbeispiele aus ausgewaehltem Ordner importiert.`
          : `${result.imported} reference examples imported from selected folder.`,
      );
    } catch (e) {
      setError((e as Error).message);
    }
  };

  const handleReferenceFolderUpload = async (e: import('react').ChangeEvent<HTMLInputElement>) => {
    if (!rootHandle) return;
    const files = Array.from(e.target.files ?? []);
    if (files.length === 0) return;
    setError(null);
    setLastImportInfo(null);
    try {
      const result = await importReferenceExamplesFromFileList(files, entries);
      await persist(result.entries);
      setLastImportAt(Date.now());
      setLastImportInfo(
        lang === 'de'
          ? `${result.imported} Referenzbeispiele aus Upload importiert.`
          : `${result.imported} reference examples imported from upload.`,
      );
    } catch (err) {
      setError((err as Error).message);
    } finally {
      e.target.value = '';
    }
  };

  const handleWorkspaceDataLearningExpansion = async () => {
    if (!rootHandle) return;
    setError(null);
    setLastImportInfo(null);
    try {
      const result = await importWorkspaceDataLearnings(rootHandle, entries, { importOnlyNew: workspaceImportOnlyNew });
      await persist(result.entries);
      setLastImportAt(Date.now());
      const detailLines = result.sourceStats.map(
        (s) => `${getImportSourceLabel(s.source, lang)}: ${lang === 'de' ? 'gescannt' : 'scanned'}=${s.scanned}, ${lang === 'de' ? 'erzeugte Learnings' : 'generated learnings'}=${s.generated}`,
      );
      setLastImportInfo(
        lang === 'de'
          ? [
            `Workspace-Learning-Import abgeschlossen: ${result.imported} uebernommen (neu: ${result.added}, aktualisiert: ${result.updated}).`,
            ...detailLines,
          ].join('\n')
          : [
            `Workspace learning import complete: ${result.imported} applied (new: ${result.added}, updated: ${result.updated}).`,
            ...detailLines,
          ].join('\n'),
      );
    } catch (e) {
      setError((e as Error).message);
    }
  };

  const handleAiSuggestLearning = async () => {
    const promptText = aiPrompt.trim();
    if (!promptText) return;

    setAiLoading(true);
    setAiError(null);
    try {
      let activeAgentId = agentApiId ?? resolvedAgentApiId;
      if (!activeAgentId) {
        const discovered = await discoverMftAgents();
        const preferred = discovered.find((a) => a.name === 'Cucumber Agent') ?? discovered[0];
        if (preferred?.agentId) {
          activeAgentId = preferred.agentId;
          setResolvedAgentApiId(preferred.agentId);
        }
      }
      if (!activeAgentId) {
        setAiError(lang === 'de' ? 'Kein bestehender Agent gefunden. Bitte zuerst einen Agent erstellen/aktivieren.' : 'No existing agent found. Please create/activate an agent first.');
        return;
      }
      const basePrompt = getCustomLearningSuggestionPrompt(lang) || buildDefaultLearningSuggestionPrompt(lang);
      const instruction = basePrompt.includes('{{USER_TEXT}}')
        ? basePrompt.replace('{{USER_TEXT}}', promptText)
        : `${basePrompt}\n\n${lang === 'de' ? 'Nutzertext' : 'User text'}:\n${promptText}`;

      const res = await chatWithAgentSync(activeAgentId, instruction, 'unknown', model, 'learning-suggestion');
      const rawResponse = res.response;

      const parsed = parseAiLearningSuggestion(rawResponse);
      if (!parsed) {
        setAiError(lang === 'de' ? 'KI-Antwort konnte nicht als Learning-JSON gelesen werden.' : 'AI response could not be parsed as learning JSON.');
        return;
      }

      setTitle(parsed.title || '');
      setSummary(parsed.summary || '');
      setComment(parsed.comment || '');
      setKeywords((parsed.keywords ?? []).join(', '));
      setCategory(parsed.category ?? 'pattern');
      setScope(parsed.scope ?? 'customer');
      setUsage(parsed.usage ?? 'both');
      setConfirmed(parsed.confirmed ?? true);
    } catch (e) {
      setAiError((e as Error).message);
    } finally {
      setAiLoading(false);
    }
  };

  const exportMarkdown = () => {
    const content = serializeLearningsMarkdown(entries);
    const blob = new Blob([content], { type: 'text/markdown;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'learnings.md';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  if (!rootHandle) {
    return <div className={styles.hint}>{lang === 'de' ? 'Bitte zuerst einen Workspace-Ordner im Explorer öffnen. Danach kann die lokale Learning-Datenbank im Projektordner gespeichert werden.' : 'Please open a workspace folder in the explorer first. Then the local learning database can be stored inside the project folder.'}</div>;
  }

  return (
    <div className={styles.root}>
      {/* LEFT: Learning List */}
      <div className={styles.panel}>
        <div className={styles.toolbar}>
          <button type="button" className={styles.btn} onClick={handleNewLearning}>
            {lang === 'de' ? '+ Neu' : '+ New'}
          </button>
          <input
            className={styles.input}
            placeholder={lang === 'de' ? 'Filter...' : 'Filter...'}
            value={quickFilter}
            onChange={(e) => setQuickFilter(e.target.value)}
            style={{ flex: 1, maxWidth: 'none' }}
          />
          <button
            type="button"
            className={styles.btn}
            onClick={() => setGlobalOnly((v) => !v)}
            style={globalOnly ? { background: 'var(--color-primary)', color: 'white', borderColor: 'var(--color-primary)' } : undefined}
            title={lang === 'de' ? 'Nur globale Standardlearnigs anzeigen' : 'Show global standard learnings only'}
          >
            {lang === 'de' ? `Nur global (${stats.global})` : `Global only (${stats.global})`}
          </button>
        </div>

        <div className={styles.statsGrid}>
          <div className={styles.statCard}><span>{lang === 'de' ? 'Gesamt' : 'Total'}</span><strong>{stats.total}</strong></div>
          <div className={styles.statCard}><span>{lang === 'de' ? 'Kunde' : 'Customer'}</span><strong>{stats.customer}</strong></div>
          <div className={styles.statCard}><span>{lang === 'de' ? 'Allgemein' : 'General'}</span><strong>{stats.general}</strong></div>
          <div className={styles.statCard}><span>{lang === 'de' ? 'Global' : 'Global'}</span><strong>{stats.global}</strong></div>
        </div>

        <div className={styles.list}>
          {filteredEntries.map((entry) => (
            <button
              key={entry.id}
              type="button"
              className={selectedLearningId === entry.id ? styles.itemActive : styles.item}
              onClick={() => handleSelectLearning(entry.id)}
              style={{ textAlign: 'left', border: 'none', padding: '8px', cursor: 'pointer', backgroundColor: 'transparent' }}
            >
              <div className={styles.meta}>
                <span className={styles.tag}>{CATEGORY_LABELS[entry.category][lang]}</span>
                <span className={styles.tag}>{entry.scope === 'customer' ? (lang === 'de' ? 'kunde' : 'customer') : (lang === 'de' ? 'allgemein' : 'general')}</span>
                {entry.usage === 'tests-global' && (
                  <span className={styles.tag}>{lang === 'de' ? 'global' : 'global'}</span>
                )}
                <span className={styles.tag}>{entry.confirmed ? (lang === 'de' ? 'ok' : 'confirmed') : 'draft'}</span>
              </div>
              <div className={styles.itemTitle}>{entry.title}</div>
              <div className={styles.itemSummary}>{entry.summary.substring(0, 80)}...</div>
            </button>
          ))}
          {filteredEntries.length === 0 && <div className={styles.hint}>{lang === 'de' ? 'Keine Eintraege fuer den aktuellen Filter.' : 'No entries for current filter.'}</div>}
        </div>
      </div>

      {/* RIGHT: Editor */}
      <div className={styles.panel}>
        <div className={styles.toolbar}>
          <button type="button" className={styles.btn} onClick={load} disabled={loading}>
            {loading ? (lang === 'de' ? 'Lade...' : 'Loading...') : (lang === 'de' ? 'Laden' : 'Load')}
          </button>
          <button type="button" className={styles.btn} onClick={exportMarkdown} disabled={entries.length === 0}>
            {lang === 'de' ? 'Export .md' : 'Export .md'}
          </button>
          <button type="button" className={styles.btn} onClick={() => importRef.current?.click()}>
            {lang === 'de' ? 'Import .md' : 'Import .md'}
          </button>
          {selectedLearningId && (
            <button type="button" className={styles.btn} onClick={handleDeleteLearning} style={{ marginLeft: 'auto', color: 'var(--color-error, #d32f2f)' }}>
              {lang === 'de' ? 'Löschen' : 'Delete'}
            </button>
          )}
          <input ref={importRef} type="file" accept=".md,.json,.txt" style={{ display: 'none' }} onChange={handleImportFile} />
        </div>

        {viewMode === 'combined' && (
          <div className={styles.subtabs}>
            <button
              type="button"
              className={rightPaneView === 'learnings' ? styles.subtabActive : styles.subtab}
              onClick={() => setRightPaneView('learnings')}
            >
              {lang === 'de' ? 'Learnings' : 'Learnings'}
            </button>
            <button
              type="button"
              className={rightPaneView === 'sources' ? styles.subtabActive : styles.subtab}
              onClick={() => setRightPaneView('sources')}
            >
              {lang === 'de' ? 'Datenquellen' : 'Data sources'}
            </button>
          </div>
        )}

        <div className={styles.form}>
          {activeRightPaneView === 'sources' ? (
            <>
              <div style={{ borderBottom: '1px solid var(--color-border)', paddingBottom: '12px', marginBottom: '12px' }}>
                <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 600, marginBottom: '6px' }}>
                  {lang === 'de' ? 'Referenzordner' : 'Reference Folder'}
                </label>
                <div style={{ display: 'flex', gap: '6px', marginBottom: '6px', flexWrap: 'wrap' }}>
                  <button type="button" className={styles.btn} onClick={handleReferenceFolderPick}>
                    {lang === 'de' ? 'Waehlen' : 'Choose'}
                  </button>
                  <button
                    type="button"
                    className={styles.btn}
                    onClick={handleReferenceFolderIndex}
                    disabled={!selectedReferenceFolder}
                  >
                    {lang === 'de' ? 'Indexieren' : 'Index'}
                  </button>
                  <button type="button" className={styles.btn} onClick={() => refFolderRef.current?.click()}>
                    {lang === 'de' ? 'Upload' : 'Upload'}
                  </button>
                </div>
                <input
                  ref={refFolderRef}
                  type="file"
                  multiple
                  /* @ts-expect-error webkitdirectory is non-standard but supported in Chromium */
                  webkitdirectory=""
                  style={{ display: 'none' }}
                  onChange={handleReferenceFolderUpload}
                />
                <small style={{ display: 'block', color: 'var(--color-text-muted)', marginTop: '4px' }}>
                  {selectedReferenceFolderLabel || (lang === 'de' ? 'Kein Ordner ausgewaehlt' : 'No folder selected')}
                </small>

                <label style={{ display: 'block', marginTop: '8px', fontSize: '0.85rem' }}>
                  <input type="checkbox" checked={workspaceImportOnlyNew} onChange={(e) => setWorkspaceImportOnlyNew(e.target.checked)} />
                  {lang === 'de' ? 'Nur neue Learnings' : 'Only new learnings'}
                </label>
                <button type="button" className={styles.btn} onClick={handleWorkspaceDataLearningExpansion} style={{ marginTop: '6px', width: '100%' }}>
                  {lang === 'de' ? 'Workspace-Daten lernen' : 'Learn from workspace data'}
                </button>
              </div>
              <div className={styles.hint} style={{ padding: 0 }}>
                {lang === 'de'
                  ? 'Dieser Bereich dient nur zum Einlesen von Beispieldaten und Quellenmaterial. Regeln bearbeitest du im Tab "Learnings".'
                  : 'This section is only for ingesting example data and source material. Edit rules in the "Learnings" tab.'}
              </div>
            </>
          ) : (
            <>
              <div style={{ borderBottom: '1px solid var(--color-border)', paddingBottom: '12px', marginBottom: '12px' }}>
                <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 600, marginBottom: '6px' }}>
                  {lang === 'de' ? 'KI-Vorschlag' : 'AI Suggestion'}
                </label>
                <textarea
                  className={styles.textarea}
                  placeholder={lang === 'de' ? 'Beschreibe in Alltagssprache, was als Regel/Erkenntnis gespeichert werden soll...' : 'Describe in plain language what should be saved as a rule/insight...'}
                  value={aiPrompt}
                  onChange={(e) => setAiPrompt(e.target.value)}
                  style={{ minHeight: '60px' }}
                />
                <button
                  type="button"
                  className={`${styles.btn} ${styles.btnPrimary}`}
                  onClick={handleAiSuggestLearning}
                  disabled={!aiPrompt.trim() || aiLoading}
                  style={{ marginTop: '6px' }}
                >
                  {aiLoading
                    ? (lang === 'de' ? 'KI erstellt...' : 'AI creating...')
                    : (lang === 'de' ? 'Von KI generieren' : 'Generate from AI')}
                </button>
                {aiError && <div className={styles.hint} style={{ color: 'var(--color-error, #d32f2f)', marginTop: '6px' }}>AI: {aiError}</div>}
              </div>

              <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 600, marginBottom: '6px' }}>
                {lang === 'de' ? 'Learning bearbeiten' : 'Edit learning'}
              </label>
              <input
                className={styles.input}
                placeholder={lang === 'de' ? 'Titel' : 'Title'}
                value={title}
                onChange={(e) => setTitle(e.target.value)}
              />
              <textarea
                className={styles.textarea}
                placeholder={lang === 'de' ? 'Learning / Regel / Erkenntnis' : 'Learning / rule / insight'}
                value={summary}
                onChange={(e) => setSummary(e.target.value)}
              />
              <textarea
                className={styles.textarea}
                placeholder={lang === 'de' ? 'Kommentar (optional)' : 'Comment (optional)'}
                value={comment}
                onChange={(e) => setComment(e.target.value)}
                style={{ minHeight: '60px' }}
              />
              <input
                className={styles.input}
                placeholder={lang === 'de' ? 'Quelle/Pfad (optional)' : 'Source/path (optional)'}
                value={sourcePath}
                onChange={(e) => setSourcePath(e.target.value)}
              />
              <input
                className={styles.input}
                placeholder={lang === 'de' ? 'Keywords, komma-getrennt' : 'Keywords, comma separated'}
                value={keywords}
                onChange={(e) => setKeywords(e.target.value)}
              />
              <select className={styles.select} value={category} onChange={(e) => setCategory(e.target.value as LearningCategory)}>
                <option value="rule">{CATEGORY_LABELS.rule[lang]}</option>
                <option value="pattern">{CATEGORY_LABELS.pattern[lang]}</option>
                <option value="warning">{CATEGORY_LABELS.warning[lang]}</option>
                <option value="example">{CATEGORY_LABELS.example[lang]}</option>
              </select>
              <select className={styles.select} value={scope} onChange={(e) => setScope(e.target.value as 'customer' | 'general')}>
                <option value="customer">{lang === 'de' ? 'Scope: Kunde' : 'Scope: Customer'}</option>
                <option value="general">{lang === 'de' ? 'Scope: Allgemein' : 'Scope: General'}</option>
              </select>
              <select className={styles.select} value={usage} onChange={(e) => setUsage(e.target.value as LearningUsage)}>
                <option value="both">{lang === 'de' ? 'Relevanz: Tests + Programme' : 'Relevance: Tests + Programs'}</option>
                <option value="tests">{lang === 'de' ? 'Relevanz: Nur Tests' : 'Relevance: Tests only'}</option>
                <option value="programs">{lang === 'de' ? 'Relevanz: Nur Programme' : 'Relevance: Programs only'}</option>
                <option value="tests-global">{lang === 'de' ? 'Relevanz: Fuer Tests (global)' : 'Relevance: Tests (global)'}</option>
              </select>
              <small style={{ display: 'block', color: 'var(--color-text-muted)', marginTop: '-2px', marginBottom: '4px' }}>
                {lang === 'de'
                  ? 'Hinweis: Fuer immer mitgesendete Standardregeln "Relevanz: Fuer Tests (global)" waehlen. Beim Speichern wird dies als allgemeine Regel behandelt.'
                  : 'Note: For always-sent standard rules choose "Relevance: Tests (global)". On save this is treated as a general rule.'}
              </small>
              <label className={styles.meta}>
                <input type="checkbox" checked={confirmed} onChange={(e) => setConfirmed(e.target.checked)} />
                {lang === 'de' ? 'Bestaetigt' : 'Confirmed'}
              </label>
              <button
                type="button"
                className={`${styles.btn} ${styles.btnPrimary}`}
                onClick={handleSaveLearning}
                disabled={!title.trim() || !summary.trim()}
                style={{ width: '100%' }}
              >
                {lang === 'de' ? 'Speichern' : 'Save'}
              </button>
            </>
          )}
          {lastImportInfo && <div className={styles.hint}>{lastImportInfo}</div>}
          {error && <div className={styles.hint} style={{ color: 'var(--color-error, #d32f2f)' }}>Error: {error}</div>}
        </div>
      </div>
    </div>
  );
}
