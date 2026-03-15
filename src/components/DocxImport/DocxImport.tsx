import { useState, useRef, useMemo, useEffect, useCallback } from 'react';
import type { FeatureInput, ParsedFeaturePackage, SkippedChapter, TableDef, TocEntry } from '../../types/gherkin';
import type { Agent } from '../../types/agent';
import { parseDocx, downloadDocxTemplate } from '../../lib/docxParser';
import { hasErrors } from '../../lib/featureValidation';
import { validateFeature } from '../../lib/featureValidation';
import { getAllProfiles, getActiveProfileId, setActiveProfileId } from '../../lib/parseProfile';
import { useAiGeneration } from '../../hooks/useAiGeneration';
import { useTranslation } from '../../i18n';
import { buildRatingMessages, parseRatingResponse, extractGherkin, buildMessages, buildMessagesWithFields } from '../../lib/aiPrompt';
import type { AiPromptRating } from '../../lib/aiPrompt';
import { chatWithAgentSync, isLoggedIn, TokenLimitError } from '../../lib/myforterroApi';
import { parseGherkin } from '../../lib/gherkinParser';
import { resolveTableRefs } from '../../lib/resolveTableRefs';
import { CsvUpload } from '../CsvUpload/CsvUpload';
import styles from './DocxImport.module.css';

/** Realisierung value that indicates the customer handles this package (no tests needed from us). */
const KUNDE_REALISIERUNG = /^kunde$/i;

interface DocxImportProps {
  onLoadToEditor: (feature: FeatureInput) => void;
  onImportAll: (features: FeatureInput[]) => void;
  onImportToExplorer?: (packages: ParsedFeaturePackage[], fileName: string) => Promise<void>;
  isDirectoryMode?: boolean;
  model: string;
  tables: TableDef[];
  onTablesChange: (tables: TableDef[]) => void;
  showAi: boolean;
  onSendToAgent?: (packages: ParsedFeaturePackage[]) => Promise<void>;
  activeAgentName?: string | null;
  /** Called after AI generation is done — creates folder + agent + saves .feature files */
  onCreateWithAgent?: (packages: ParsedFeaturePackage[], fileName: string) => Promise<void>;
  // EFK Agent props
  efkAgents: Agent[];
  selectedEfkAgentId: string | null;
  onSelectEfkAgent: (agentId: string | null) => void;
  onCreateEfkAgent: (name: string, packages: ParsedFeaturePackage[]) => Promise<void>;
  onDeleteEfkAgent: (agentId: string) => Promise<void>;
}

export function DocxImport({
  onLoadToEditor,
  onImportAll,
  onImportToExplorer,
  isDirectoryMode,
  model,
  tables,
  onTablesChange,
  showAi,
  onSendToAgent,
  activeAgentName,
  onCreateWithAgent,
  efkAgents,
  selectedEfkAgentId,
  onSelectEfkAgent,
  onCreateEfkAgent,
  onDeleteEfkAgent,
}: DocxImportProps) {
  const { t, lang } = useTranslation();
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

  // Expanded descriptions in TOC
  const [expandedHeadings, setExpandedHeadings] = useState<Set<string>>(new Set());

  // AI generation state
  const { generate, generationStep, error: aiError } = useAiGeneration();
  const [aiProgress, setAiProgress] = useState({ current: 0, total: 0 });
  const cancelRef = useRef(false);

  // Per-card AI rating state
  const [ratings, setRatings] = useState<Record<string, AiPromptRating>>({});
  const [ratingError, setRatingError] = useState<string | null>(null);
  const [isSendingToAgent, setIsSendingToAgent] = useState(false);

  // EFK Agent dialog state
  const [showAgentDialog, setShowAgentDialog] = useState(false);
  const [agentDialogMode, setAgentDialogMode] = useState<'create' | 'choose' | null>(null);
  const [agentNameInput, setAgentNameInput] = useState('');
  const [agentCreating, setAgentCreating] = useState(false);

  const selectedEfkAgent = efkAgents.find((a) => a.id === selectedEfkAgentId) ?? null;

  // EFK Agent chat state
  const [chatMessages, setChatMessages] = useState<{ id: string; role: 'user' | 'assistant'; content: string }[]>([]);
  const [chatInput, setChatInput] = useState('');
  const [chatSending, setChatSending] = useState(false);
  const [chatStreamText, setChatStreamText] = useState<string | null>(null);
  const [chatError, setChatError] = useState<string | null>(null);
  const chatEndRef = useRef<HTMLDivElement>(null);
  const chatConvIdRef = useRef<string | null>(null);

  // Keep chat conversationId in sync with agent's conversationId
  useEffect(() => {
    chatConvIdRef.current = selectedEfkAgent?.conversationId ?? null;
  }, [selectedEfkAgent?.conversationId]);

  // Clear chat when agent changes
  useEffect(() => {
    setChatMessages([]);
    setChatError(null);
    setChatStreamText(null);
    chatConvIdRef.current = selectedEfkAgent?.conversationId ?? null;
  }, [selectedEfkAgentId]); // eslint-disable-line react-hooks/exhaustive-deps

  // Scroll chat to bottom on new messages
  useEffect(() => {
    chatEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [chatMessages.length, chatStreamText]);

  const handleChatSend = useCallback(async () => {
    const text = chatInput.trim();
    if (!text || chatSending || !selectedEfkAgent?.apiAgentId) return;
    setChatInput('');
    setChatError(null);
    const userMsg = { id: crypto.randomUUID(), role: 'user' as const, content: text };
    setChatMessages((prev) => [...prev, userMsg]);
    setChatSending(true);
    setChatStreamText(null);
    try {
      const result = await chatWithAgentSync(selectedEfkAgent.apiAgentId, text, chatConvIdRef.current);
      chatConvIdRef.current = result.conversationId;
      const assistantMsg = { id: crypto.randomUUID(), role: 'assistant' as const, content: result.response };
      setChatMessages((prev) => [...prev, assistantMsg]);
    } catch (err) {
      setChatError(err instanceof Error ? err.message : 'Unbekannter Fehler');
    } finally {
      setChatSending(false);
      setChatStreamText(null);
    }
  }, [chatInput, chatSending, selectedEfkAgent?.apiAgentId]);

  const profiles = getAllProfiles();
  const activeProfile = profiles.find((p) => p.id === activeProfileId) ?? profiles[0];

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setLoading(true);
    setError('');
    setDocxFileName(file.name.replace(/\.(docx|dotm)$/i, ''));

    try {
      const result = await parseDocx(file, activeProfile);
      setPackages(result.features);
      setSkipped(result.skippedChapters);
      setToc(result.toc);
      setRatings({});
      setRatingError(null);
      // Pre-select packages where WE (abas/Berater) do the work — not the customer.
      // Exclude: very short sourceText (< 80 chars) or Realisierung = "Kunde".
      const autoChecked = result.features.filter(
        (pkg) => pkg.sourceText.trim().length >= 80 && !KUNDE_REALISIERUNG.test(pkg.kundeField ?? ''),
      );
      setCheckedHeadings(new Set(autoChecked.map((p) => p.sourceHeading)));
      if (result.features.length === 0 && result.skippedChapters.length === 0) {
        setError(t('docx.noFeatures'));
      } else if (showAi && result.features.length > 0) {
        // Show agent dialog — mandatory
        setAgentNameInput(file.name.replace(/\.(docx|dotm)$/i, ''));
        // If agents exist, let user choose; otherwise go straight to create
        setAgentDialogMode(efkAgents.length > 0 ? 'choose' : 'create');
        setShowAgentDialog(true);
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

  const handleImportAll = () => {
    const importable = packages.filter((pkg) => !hasErrors(pkg.validation)).map((pkg) => pkg.feature);
    if (importable.length > 0) onImportAll(importable);
  };

  const handleImportToExplorer = async () => {
    if (!onImportToExplorer) return;
    const importable = packages.filter((pkg) => !hasErrors(pkg.validation));
    if (importable.length > 0) await onImportToExplorer(importable, docxFileName);
  };

  // Toggle a checkbox in the TOC
  const toggleHeading = (heading: string) => {
    setCheckedHeadings((prev) => {
      const next = new Set(prev);
      if (next.has(heading)) next.delete(heading);
      else next.add(heading);
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

  const selectAllPackages = () => {
    const allPkgHeadings = toc.filter((e) => e.kind === 'package').map((e) => e.text);
    setCheckedHeadings(new Set(allPkgHeadings));
  };

  const deselectAllPackages = () => {
    setCheckedHeadings(new Set());
  };

  // All checked packages — including those without scenarios yet (AI will generate them)
  const checkedPackages = packages.filter((p) => checkedHeadings.has(p.sourceHeading));

  // ── EFK Agent: create agent from dialog ───────────────────────

  const handleAgentDialogCreate = async () => {
    if (!agentNameInput.trim()) return;
    setAgentCreating(true);
    try {
      await onCreateEfkAgent(agentNameInput.trim(), packages);
      setShowAgentDialog(false);
    } finally {
      setAgentCreating(false);
    }
  };

  // ── Agent-based generation helper ────────────────────────────

  /** Generate a single package's tests via the EFK agent chat. Returns parsed FeatureInput or null. */
  const generateViaAgent = async (
    agentId: string,
    text: string,
    convId: string | null,
    testUser?: string,
  ): Promise<{ feature: FeatureInput; conversationId: string } | null> => {
    // Build the user message — include field context if available
    const tablesWithFields = tables.filter((t) => t.fields.length > 0);
    let userMessage: string;
    if (tablesWithFields.length > 0) {
      const msgs = buildMessagesWithFields(text, tablesWithFields, testUser);
      userMessage = msgs.find((m) => m.role === 'user')?.content ?? text;
    } else {
      const msgs = buildMessages(text, testUser, tables);
      userMessage = msgs.find((m) => m.role === 'user')?.content ?? text;
    }
    userMessage = 'Generiere Gherkin-Testszenarien fuer folgendes Arbeitspaket:\n\n' + userMessage;

    const result = await chatWithAgentSync(agentId, userMessage, convId);
    const gherkin = extractGherkin(result.response);
    let parsed = parseGherkin(gherkin);
    if (tables.length > 0) parsed = resolveTableRefs(parsed, tables);
    if (parsed.scenarios.length === 0) return null;
    return { feature: parsed, conversationId: result.conversationId };
  };

  /** Rate a single package via the EFK agent chat. */
  const rateViaAgent = async (
    agentId: string,
    text: string,
    convId: string | null,
  ): Promise<{ rating: AiPromptRating | null; conversationId: string }> => {
    const tableInfo = tables.map((ti) => ({ name: ti.name, tableRef: ti.tableRef, kind: ti.kind }));
    const msgs = buildRatingMessages(text, tableInfo.length > 0 ? tableInfo : undefined);
    const userMessage = 'Bewerte die folgende Anforderungsbeschreibung:\n\n' + (msgs.find((m) => m.role === 'user')?.content ?? text);
    const result = await chatWithAgentSync(agentId, userMessage, convId);
    return { rating: parseRatingResponse(result.response), conversationId: result.conversationId };
  };

  // ── AI: generate tests for checked packages ──────────────────

  const handleAiGenerate = async () => {
    if (checkedPackages.length === 0) return;
    if (!selectedEfkAgent?.apiAgentId) return;
    if (tables.length === 0 && !window.confirm(t('docx.noTablesWarning'))) return;
    cancelRef.current = false;
    setAiProgress({ current: 0, total: checkedPackages.length });
    setError('');
    let errorCount = 0;

    const enhanced: ParsedFeaturePackage[] = [];
    let agentConvId = selectedEfkAgent?.conversationId ?? null;

    for (let i = 0; i < checkedPackages.length; i++) {
      if (cancelRef.current) break;
      setAiProgress({ current: i + 1, total: checkedPackages.length });
      const pkg = checkedPackages[i];
      try {
        let feature: FeatureInput | null = null;

        const agentResult = await generateViaAgent(
          selectedEfkAgent!.apiAgentId!, pkg.sourceText, agentConvId, pkg.feature.testUser || undefined,
        );
        if (agentResult) {
          feature = agentResult.feature;
          agentConvId = agentResult.conversationId;
        }

        if (feature && feature.scenarios.length > 0) {
          enhanced.push({
            ...pkg,
            feature: {
              ...feature,
              name: feature.name || pkg.feature.name,
              description: pkg.feature.description || feature.description,
            },
            validation: validateFeature(feature),
          });
        } else {
          enhanced.push(pkg);
          errorCount++;
        }
      } catch (err) {
        if (err instanceof TokenLimitError) {
          setError(t('docx.tokenLimitReached'));
          break;
        }
        enhanced.push(pkg);
        errorCount++;
      }
      if (i < checkedPackages.length - 1 && !cancelRef.current) {
        await new Promise((resolve) => setTimeout(resolve, 1000));
      }
    }

    setAiProgress({ current: 0, total: 0 });
    if (errorCount > 0 && !error) {
      setError(t('docx.aiEnhanceError', { errorCount, total: checkedPackages.length }));
    }
    // Update packages state for the legacy flat-card view
    setPackages((prev) =>
      prev.map((p) => enhanced.find((e) => e.sourceHeading === p.sourceHeading) ?? p)
    );
    return enhanced;
  };

  // ── AI: generate tests + create folder + agent ───────────────

  const handleCreateWithAgent = async () => {
    if (!onCreateWithAgent || checkedPackages.length === 0) return;
    if (!selectedEfkAgent?.apiAgentId) return;
    if (tables.length === 0 && !window.confirm(t('docx.noTablesWarning'))) return;
    cancelRef.current = false;
    setAiProgress({ current: 0, total: checkedPackages.length });
    setError('');
    const enhanced: ParsedFeaturePackage[] = [];
    let errorCount = 0;

    let agentConvId = selectedEfkAgent.conversationId ?? null;

    for (let i = 0; i < checkedPackages.length; i++) {
      if (cancelRef.current) break;
      setAiProgress({ current: i + 1, total: checkedPackages.length });
      const pkg = checkedPackages[i];
      try {
        let feature: FeatureInput | null = null;

        const agentResult = await generateViaAgent(
          selectedEfkAgent.apiAgentId, pkg.sourceText, agentConvId, pkg.feature.testUser || undefined,
        );
        if (agentResult) {
          feature = agentResult.feature;
          agentConvId = agentResult.conversationId;
        }

        if (feature && feature.scenarios.length > 0) {
          enhanced.push({
            ...pkg,
            feature: {
              ...feature,
              name: feature.name || pkg.feature.name,
              description: pkg.feature.description || feature.description,
            },
            validation: validateFeature(feature),
          });
        } else {
          enhanced.push(pkg);
          errorCount++;
        }
      } catch (err) {
        if (err instanceof TokenLimitError) {
          setError(t('docx.tokenLimitReached'));
          break;
        }
        enhanced.push(pkg);
        errorCount++;
      }
      if (i < checkedPackages.length - 1 && !cancelRef.current) {
        await new Promise((resolve) => setTimeout(resolve, 1000));
      }
    }

    setAiProgress({ current: 0, total: 0 });
    if (errorCount > 0 && !error) {
      setError(t('docx.aiEnhanceError', { errorCount, total: checkedPackages.length }));
    }

    if (enhanced.length > 0 && !cancelRef.current) {
      await onCreateWithAgent(enhanced, docxFileName);
    }
  };

  const handleCancelAi = () => { cancelRef.current = true; };

  // ── Rating ────────────────────────────────────────────────────

  const [bulkRatingProgress, setBulkRatingProgress] = useState({ current: 0, total: 0 });
  const isBulkRating = bulkRatingProgress.total > 0;

  const handleBulkRating = async () => {
    if (!isLoggedIn()) { setRatingError(t('docx.notLoggedIn')); return; }
    if (!selectedEfkAgent?.apiAgentId) { setRatingError(t('docx.agentRequired')); return; }
    const toRate = checkedPackages.length > 0 ? checkedPackages : packages.filter((pkg) => !hasErrors(pkg.validation));
    if (toRate.length === 0) return;
    cancelRef.current = false;
    setBulkRatingProgress({ current: 0, total: toRate.length });
    setRatingError(null);
    let errorCount = 0;
    let agentConvId = selectedEfkAgent?.conversationId ?? null;
    for (let i = 0; i < toRate.length; i++) {
      if (cancelRef.current) break;
      setBulkRatingProgress({ current: i + 1, total: toRate.length });
      const pkg = toRate[i];
      const text = pkg.sourceText || pkg.feature.description;
      if (!text.trim()) { errorCount++; continue; }
      try {
        const agentResult = await rateViaAgent(selectedEfkAgent!.apiAgentId!, text, agentConvId);
        const parsed = agentResult.rating;
        agentConvId = agentResult.conversationId;

        if (parsed) setRatings((prev) => ({ ...prev, [pkg.sourceHeading]: parsed! }));
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

  // ── Send to agent ─────────────────────────────────────────────

  const handleSendToAgent = async () => {
    if (!onSendToAgent) return;
    const importable = packages.filter((pkg) => !hasErrors(pkg.validation));
    if (importable.length === 0) return;
    setIsSendingToAgent(true);
    try { await onSendToAgent(importable); }
    finally { setIsSendingToAgent(false); }
  };

  const importableCount = packages.filter((pkg) => !hasErrors(pkg.validation)).length;
  const isEnhancing = aiProgress.total > 0;
  const isBusy = isEnhancing || isBulkRating || isSendingToAgent;

  // ── TOC view ──────────────────────────────────────────────────

  const useTocView = toc.length > 0;

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

  const hasChatPanel = showAi && !!selectedEfkAgent;

  return (
    <div className={hasChatPanel ? styles.containerWithChat : styles.container}>
      <div className={hasChatPanel ? styles.mainColumn : undefined}>
      {/* Toolbar */}
      <div className={styles.toolbar}>
        <button className={styles.uploadBtn} onClick={() => fileRef.current?.click()} disabled={isBusy} type="button">
          {t('docx.upload')}
        </button>
        <input ref={fileRef} className={styles.fileInput} type="file" accept=".docx,.dotm" onChange={handleFileChange} />
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

      {/* Variablentabelle upload */}
      <div className={styles.tableUploadSection}>
        <div className={styles.tableUploadTitle}>{t('docx.contextFiles')}</div>
        <CsvUpload tables={tables} onTablesChange={onTablesChange} />
      </div>

      {/* EFK Agent selector */}
      {showAi && efkAgents.length > 0 && (
        <div className={styles.efkAgentSection}>
          <span className={styles.efkAgentLabel}>{t('docx.efkAgent')}:</span>
          <select
            className={styles.efkAgentSelect}
            value={selectedEfkAgentId ?? ''}
            onChange={(e) => onSelectEfkAgent(e.target.value || null)}
          >
            {!selectedEfkAgentId && (
              <option value="">{t('docx.noAgentSelected')}</option>
            )}
            {efkAgents.map((a) => (
              <option key={a.id} value={a.id}>
                {a.name} ({new Date(a.createdAt).toLocaleDateString('de-DE')})
              </option>
            ))}
          </select>
          {selectedEfkAgent && (
            <button
              className={styles.efkAgentDeleteBtn}
              onClick={() => { if (window.confirm(t('docx.deleteEfkAgent') + '?')) onDeleteEfkAgent(selectedEfkAgent.id); }}
              type="button"
              title={t('docx.deleteEfkAgent')}
            >
              &times;
            </button>
          )}
          <button
            className={styles.efkAgentDialogBtn}
            onClick={() => { setAgentNameInput(docxFileName || 'EFK'); setAgentDialogMode('create'); setShowAgentDialog(true); }}
            type="button"
            disabled={isBusy}
          >
            + {t('docx.newAgent')}
          </button>
        </div>
      )}

      {/* Agent creation/selection dialog (mandatory) */}
      {showAgentDialog && (
        <div className={styles.efkAgentDialog}>
          {agentDialogMode === 'choose' ? (
            <>
              <span className={styles.efkAgentDialogLabel}>{t('docx.agentRequired')}</span>
              <div className={styles.efkAgentDialogRow}>
                <button
                  className={styles.efkAgentDialogBtn}
                  onClick={() => setAgentDialogMode('create')}
                  type="button"
                >
                  {t('docx.newAgent')}
                </button>
                <select
                  className={styles.efkAgentSelect}
                  value=""
                  onChange={(e) => {
                    if (e.target.value) {
                      onSelectEfkAgent(e.target.value);
                      setShowAgentDialog(false);
                    }
                  }}
                >
                  <option value="">{t('docx.selectExistingAgent')}...</option>
                  {efkAgents.map((a) => (
                    <option key={a.id} value={a.id}>
                      {a.name} ({new Date(a.createdAt).toLocaleDateString('de-DE')})
                    </option>
                  ))}
                </select>
              </div>
            </>
          ) : (
            <>
              <span className={styles.efkAgentDialogLabel}>{t('docx.efkAgentName')}</span>
              <div className={styles.efkAgentDialogRow}>
                <input
                  className={styles.efkAgentDialogInput}
                  value={agentNameInput}
                  onChange={(e) => setAgentNameInput(e.target.value)}
                  disabled={agentCreating}
                  autoFocus
                  onKeyDown={(e) => { if (e.key === 'Enter') handleAgentDialogCreate(); }}
                />
                <button
                  className={styles.efkAgentDialogBtn}
                  onClick={handleAgentDialogCreate}
                  disabled={agentCreating || !agentNameInput.trim()}
                  type="button"
                >
                  {agentCreating ? t('docx.agentCreating') : t('docx.createEfkAgent')}
                </button>
                {efkAgents.length > 0 && (
                  <button
                    className={styles.efkAgentDialogSkip}
                    onClick={() => setAgentDialogMode('choose')}
                    disabled={agentCreating}
                    type="button"
                  >
                    {t('docx.selectExistingAgent')}
                  </button>
                )}
              </div>
            </>
          )}
        </div>
      )}

      {/* Error/AI messages */}
      {(error || aiError || ratingError) && (
        <div style={{ color: 'var(--color-danger)', fontSize: '0.85rem', marginBottom: 'var(--spacing)' }}>
          {error || aiError || ratingError}
        </div>
      )}
      {loading && <div className={styles.loading}>{t('docx.loading')}</div>}
      {isEnhancing && (
        <div className={styles.aiProgress}>
          <span>
            {t('docx.aiProgress', { current: aiProgress.current, total: aiProgress.total })}
            {generationStep === 'identifying-tables' && ` ${t('docx.aiStepTables')}`}
            {generationStep === 'generating-gherkin' && ` ${t('docx.aiStepScenarios')}`}
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
                disabled={(isBusy && !isEnhancing) || !selectedEfkAgent}
                type="button"
                title={!selectedEfkAgent ? t('docx.agentRequired') : undefined}
              >
                {isEnhancing ? t('docx.cancel') : `🤖 KI-Tests generieren (${checkedPackages.length} APs)`}
              </button>
            )}

            {/* Rating */}
            {showAi && checkedPackages.length > 0 && (
              <button
                className={styles.ratingBulkBtn}
                onClick={isBulkRating ? handleCancelAi : handleBulkRating}
                disabled={(isBusy && !isBulkRating) || !selectedEfkAgent}
                type="button"
                title={!selectedEfkAgent ? t('docx.agentRequired') : undefined}
              >
                {isBulkRating ? t('docx.cancel') : `Bewertung (${checkedPackages.length} APs)`}
              </button>
            )}

            {/* Secondary: import to explorer without agent */}
            {importableCount > 0 && isDirectoryMode && onImportToExplorer && (
              <button className={styles.importAllBtn} onClick={handleImportToExplorer} disabled={isBusy} type="button">
                📂 In Ordner importieren ({importableCount})
              </button>
            )}
            {importableCount > 0 && !isDirectoryMode && (
              <button className={styles.importAllBtn} onClick={handleImportAll} disabled={isBusy} type="button">
                {t('docx.importAll', { importable: importableCount, total: packages.length })}
              </button>
            )}

            {/* Send to existing agent */}
            {onSendToAgent && importableCount > 0 && (
              <button
                className={styles.agentBtn}
                onClick={handleSendToAgent}
                disabled={isBusy}
                type="button"
                title={activeAgentName ? `An Agent „${activeAgentName}" senden` : 'An aktiven Agent senden'}
              >
                {isSendingToAgent ? 'Wird analysiert…' : `📎 An Agent${activeAgentName ? ` (${activeAgentName})` : ''}`}
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
              {toc.map((entry, i) => {
                const pkg = entry.kind === 'package' ? packages.find((p) => p.sourceHeading === entry.text) : null;
                const isChecked = checkedHeadings.has(entry.text);
                const rating = ratings[entry.text] ?? null;
                const hasScenarios = pkg && pkg.feature.scenarios.length > 0;
                const chNum = tocNumbers[i];
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
                      <div className={styles.tocPackageBlock}>
                        <div className={styles.tocCheckLabel}>
                          <input
                            type="checkbox"
                            checked={isChecked}
                            onChange={() => toggleHeading(entry.text)}
                            disabled={isBusy}
                            className={styles.tocCheckbox}
                          />
                          <span className={styles.tocChapterNum}>{chNum}</span>
                          <button
                            type="button"
                            className={styles.tocExpandBtn}
                            onClick={() => toggleExpanded(entry.text)}
                            title="Beschreibung ein-/ausklappen"
                          >
                            <span className={expandedHeadings.has(entry.text) ? styles.expandArrowOpen : styles.expandArrow}>
                              ▶
                            </span>
                          </button>
                          <span className={styles.tocEntryText}>{entry.text}</span>
                          {hasScenarios && (
                            <span className={styles.tocHasScenariosBadge} title="Szenarien vorhanden">✓</span>
                          )}
                          {rating && (
                            <span className={styles.tocRatingBadge} style={{ background: ratingBgColor(rating.score) }}>
                              {rating.score}%
                            </span>
                          )}
                        </div>
                        {expandedHeadings.has(entry.text) && pkg?.sourceText && (
                          <div className={styles.tocDescription}>
                            {pkg.sourceText}
                          </div>
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
                        <span className={styles.tocEntryText}>{entry.text}</span>
                      </span>
                    )}
                  </li>
                );
              })}
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
            {importableCount > 0 && isDirectoryMode && onImportToExplorer && (
              <button className={styles.importAllBtn} onClick={handleImportToExplorer} disabled={isBusy} type="button">
                📂 In Ordner importieren ({importableCount})
              </button>
            )}
            {importableCount > 0 && !isDirectoryMode && (
              <button className={styles.importAllBtn} onClick={handleImportAll} disabled={isBusy} type="button">
                {t('docx.importAll', { importable: importableCount, total: packages.length })}
              </button>
            )}
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

      {/* Right chat panel */}
      {hasChatPanel && selectedEfkAgent && (
        <div className={styles.chatColumn}>
          <div className={styles.efkChatHeader}>
            <span className={styles.efkChatHeaderIcon}>&#129302;</span>
            <span className={styles.efkChatHeaderName}>{selectedEfkAgent.name}</span>
          </div>
          <div className={styles.efkChatHint}>{t('docx.efkChatHint')}</div>
          <div className={styles.efkChatMessages}>
            {chatMessages.length === 0 && !chatSending && (
              <div className={styles.efkChatEmpty}>{t('docx.efkChatEmpty')}</div>
            )}
            {chatMessages.map((msg) => (
              <div
                key={msg.id}
                className={msg.role === 'user' ? styles.efkChatMsgUser : styles.efkChatMsgAssistant}
              >
                <div className={styles.efkChatBubble}>
                  <pre className={styles.efkChatContent}>{msg.content}</pre>
                </div>
              </div>
            ))}
            {chatSending && (
              <div className={styles.efkChatMsgAssistant}>
                <div className={styles.efkChatBubble}>
                  {chatStreamText ? (
                    <pre className={styles.efkChatContent}>{chatStreamText}</pre>
                  ) : (
                    <span className={styles.efkChatTyping}>
                      <span /><span /><span />
                    </span>
                  )}
                </div>
              </div>
            )}
            <div ref={chatEndRef} />
          </div>
          {chatError && <div className={styles.efkChatError}>{chatError}</div>}
          <div className={styles.efkChatInputRow}>
            <textarea
              className={styles.efkChatInput}
              value={chatInput}
              onChange={(e) => setChatInput(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); handleChatSend(); }
              }}
              placeholder={t('docx.efkChatPlaceholder')}
              rows={2}
              disabled={chatSending}
            />
            <button
              className={styles.efkChatSendBtn}
              onClick={handleChatSend}
              disabled={!chatInput.trim() || chatSending}
              type="button"
              title="Senden"
            >
              &#9654;
            </button>
          </div>
        </div>
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
  t: (key: string, vars?: Record<string, unknown>) => string;
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
