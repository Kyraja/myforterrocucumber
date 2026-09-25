/**
 * @module App
 * Root component and central state owner for the cucumbergnerator application.
 *
 * Manages four main views (Editor, DOCX Import, Stammdaten, Reverse Engineering)
 * and owns the top-level state: feature list with undo/redo, table definitions,
 * FOP bindings, AI agent configuration, file explorer session, and OAuth login.
 *
 * The two-column layout renders the editing/import form on the left and the
 * Gherkin preview (with toolbox, text, diagram, or agent chat modes) on the right.
 */
import { useState, useRef, useCallback, useEffect, useMemo } from 'react';
import logoUrl from './assets/logo.png';
import JSZip from 'jszip';
import type { FeatureInput, TableDef, ParsedFeaturePackage, Scenario } from './types/gherkin';
import type { TocInfo } from './components/DocxImport/DocxImport';
import type { Agent, AgentContext } from './types/agent';
import type { LearningEntry } from './types/learning';
import { useGherkinGenerator } from './hooks/useGherkinGenerator';
import { generateGherkin } from './lib/generator';
import { useAiGeneration } from './hooks/useAiGeneration';
import { useAiRating } from './hooks/useAiRating';
import type { AiPromptRating } from './lib/aiPrompt';
import { useUndoRedo } from './hooks/useUndoRedo';
import { getModel, saveFeatures, getExperimentalFeatures, isDevMode, isAiEnabled, saveFopBindings, loadFopBindings, saveIsBindings, loadIsBindings, getForceKiTableId, getLearningCrosscheckMode, importAppSettingsJson, getTaskModel, getStoredAgentId } from './lib/settings';
import { formatSingleTableContext } from './lib/aiPrompt';
import { useAgentActivity, loadConversationsFromDir, saveConversationsToDir } from './hooks/useAgentActivity';
import { useFopAnalysis } from './hooks/useFopAnalysis';
import AgentStatusBar from './components/AgentStatusBar';
import { WorkflowSidePanel } from './components/WorkflowTimeline/WorkflowSidePanel';
import { WorkflowDiagram } from './components/WorkflowTimeline/WorkflowDiagram';
import { useProcessFlow } from './hooks/useProcessFlow';
import { FopTree, AnalysisPanel } from './components/ReverseEngineering';
import { DataStatusBar } from './components/DataStatusBar/DataStatusBar';
import { StammdatenView } from './components/StammdatenView/StammdatenView';
import { isLoggedIn, hasAuthCallback, handleAuthCallback, initiateLogin, getStoredClientId, getStoredApplicationId, getStoredClientSecret, getStoredTenantId, chatWithAgentSync } from './lib/myforterroApi';
import { loadTableDefs, saveTableDefs, migrateTableDefsFromLocalStorage, loadTableDefsFromWorkspace, saveTableDefsToWorkspace, loadFopBindingsFromWorkspace, saveFopBindingsToWorkspace, loadIsBindingsFromWorkspace, saveIsBindingsToWorkspace, saveKBToWorkspace, loadKBFromWorkspace } from './lib/csvTableParser';
import { featureHasStepErrors, scenarioHasErrors } from './lib/featureValidation';
import { loadAgents, saveAgent } from './lib/agentStore';
import { parseGherkin } from './lib/gherkinParser';
import { buildFeatureEditMessage, extractEditedFeatureGherkin } from './lib/featureEditPrompt';
import { checkDailyLimitExceededFromHistory, syncServerConsumption, syncTenantLimit } from './lib/tokenHistory';
import { getPhaseLabel } from './lib/workflowLabels';
import { useTranslation } from './i18n';
import { FeatureForm } from './components/FeatureForm/FeatureForm';
import { GherkinPreview } from './components/GherkinPreview/GherkinPreview';
import { ActionBar } from './components/ActionBar/ActionBar';
import { SettingsPanel } from './components/SettingsPanel/SettingsPanel';
import { DocxImport } from './components/DocxImport/DocxImport';
import { DataImportTab } from './components/DataImport/DataImportTab';
import { FlowDiagram } from './components/FlowDiagram/FlowDiagram';
import { StepToolbox } from './components/StepToolbox/StepToolbox';
import { FileExplorer } from './components/FileExplorer/FileExplorer';
import { ConfirmDialog } from './components/ConfirmDialog/ConfirmDialog';
import { WorkspaceSwitchModal, type WorkspaceSwitchPayload } from './components/WorkspaceSwitchModal/WorkspaceSwitchModal';
import { useFileExplorer } from './hooks/useFileExplorer';
import { collectExistingGuids, makeFeatureGuid } from './lib/featureGuid';
import {
  sanitizeName,
  loadSharedSettingsDirectoryHandle,
  saveSharedSettingsDirectoryHandle,
  pickDirectory,
  verifyPermission,
} from './lib/fileSystemAccess';
import { buildLearningPromptHints, loadSharedLearnings, loadSharedSettingsJson, saveSharedSettingsJson, loadWorkspaceLearnings } from './lib/learningStore';
import styles from './App.module.css';

const ENTRY_GATE_DONE_SESSION_KEY = 'cucumbergnerator_entry_gate_done';

const INITIAL_FEATURE: FeatureInput = {
  name: '',
  description: '',
  tags: [],
  database: null,
  testUser: '',
  scenarios: [],
};

export default function App() {
  const { t, lang } = useTranslation();
  const currentLang = lang as 'de' | 'en';
  const devMode = isDevMode();
  // AI mode gate (?ai=true). When OFF the app is a pure Baukasten:
  // no login, no settings, no agent UI — every loggedIn-gated AI feature
  // falls away because we force loggedIn=false below.
  const aiEnabled = isAiEnabled();
  // Experimental features (Reverse Engineering tab, FOP agents) require BOTH
  // the dev=true URL gate AND the explicit user toggle in settings.
  // Also requires AI mode — Reverse Engineering depends on FOP agents.
  const experimentalFeatures = aiEnabled && devMode && getExperimentalFeatures();
  const [view, setView] = useState<'editor' | 'docx' | 'dataimport' | 'stammdaten' | 'reverse'>('editor');
  const [stammdatenInitialTab, setStammdatenInitialTab] = useState<'variablen' | 'learning'>('variablen');
  const [appLoading, setAppLoading] = useState(true);
  const [sharedSettingsReady, setSharedSettingsReady] = useState(false);
  const [sharedSettingsChecking, setSharedSettingsChecking] = useState(true);
  const [sharedSettingsError, setSharedSettingsError] = useState<string | null>(null);
  const [entryGateDone, setEntryGateDone] = useState(() => {
    if (typeof window === 'undefined') return true;
    try {
      return sessionStorage.getItem(ENTRY_GATE_DONE_SESSION_KEY) === 'true';
    } catch {
      return true;
    }
  });

  // Core state — declared first so downstream hooks can reference
  const initialFeatures = [INITIAL_FEATURE];
  const { value: features, set: setFeatures, undo, redo, canUndo, canRedo } = useUndoRedo(initialFeatures);
  const [activeFeatureIdx, setActiveFeatureIdx] = useState(0);
  const [templateDraft, setTemplateDraft] = useState<FeatureInput | null>(null);
  const [templateDraftInitial, setTemplateDraftInitial] = useState<FeatureInput | null>(null);
  const [templateEditingName, setTemplateEditingName] = useState<string | null>(null);
  const [templateEditingId, setTemplateEditingId] = useState<string | null>(null);
  const [templateSaveTick, setTemplateSaveTick] = useState(0);
  const [tableDefs, setTableDefs] = useState<TableDef[]>([]);
  const [fopBindings, setFopBindings] = useState<import('./types/fop').FopBinding[]>(
    () => loadFopBindings() as import('./types/fop').FopBinding[],
  );

  // Persist FOP bindings to localStorage (workspace saving is handled after fileExplorer init)
  useEffect(() => { saveFopBindings(fopBindings); }, [fopBindings]);

  const [isBindings, setIsBindings] = useState<import('./lib/isBindingsParser').IsBinding[]>(
    () => loadIsBindings() as import('./lib/isBindingsParser').IsBinding[],
  );
  // Persist IS bindings to localStorage (workspace saving is handled after fileExplorer init)
  useEffect(() => { saveIsBindings(isBindings); }, [isBindings]);

  // Knowledge Base documents
  const [kbDocuments, setKbDocuments] = useState<import('./types/knowledgeBase').KBDocument[]>([]);
  const [pendingWorkspaceImport, setPendingWorkspaceImport] = useState<WorkspaceSwitchPayload | null>(null);
  const [workspaceLearnings, setWorkspaceLearnings] = useState<LearningEntry[]>([]);
  const [sharedLearnings, setSharedLearnings] = useState<LearningEntry[]>([]);
  const [workspaceLearningHints, setWorkspaceLearningHints] = useState('');
  const [workspaceConceptLearningHints, setWorkspaceConceptLearningHints] = useState('');
  const [sharedSettingsRevision, setSharedSettingsRevision] = useState(0);

  // Global app gate: a shared settings folder is mandatory for all modes.
  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        const handle = await loadSharedSettingsDirectoryHandle();
        if (!handle) {
          if (!cancelled) setSharedSettingsReady(false);
          return;
        }
        const hasPermission = await verifyPermission(handle);
        if (!cancelled) setSharedSettingsReady(hasPermission);
      } catch {
        if (!cancelled) setSharedSettingsReady(false);
      } finally {
        if (!cancelled) setSharedSettingsChecking(false);
      }
    })();
    return () => { cancelled = true; };
  }, []);

  const handleChooseSharedSettingsFolderAtStartup = useCallback(async () => {
    setSharedSettingsError(null);
    try {
      const handle = await pickDirectory();
      const hasPermission = await verifyPermission(handle);
      if (!hasPermission) return;
      await saveSharedSettingsDirectoryHandle(handle);

      const existingJson = await loadSharedSettingsJson();
      if (existingJson && existingJson.trim()) {
        const imported = importAppSettingsJson(existingJson);
        setModel(imported.model ?? '');
      } else {
        try {
          const presetRes = await fetch('/presets/recommended-settings.json', { cache: 'no-store' });
          if (presetRes.ok) {
            const presetJson = await presetRes.text();
            const imported = importAppSettingsJson(presetJson);
            setModel(imported.model ?? '');
          }
        } catch {
          // Ignore preset loading failures and proceed with current in-memory defaults.
        }
        await saveSharedSettingsJson();
      }

      setSharedSettingsReady(true);
      setSharedSettingsRevision((v) => v + 1);
    } catch (err) {
      if ((err as Error).name !== 'AbortError') {
        setSharedSettingsError((err as Error).message || t('settings.sharedChooseFolderError'));
      }
    }
  }, [t]);

  // Force loggedIn=false when AI mode is off — this single line cascades
  // through every `loggedIn`-gated AI feature (generate button, rating,
  // DOCX AI, agent chat, etc.) so they all disappear without per-site edits.
  const [loggedIn, setLoggedIn] = useState(() => aiEnabled && isLoggedIn());
  const [model, setModel] = useState(() => getModel() || '');
  const displayModel = model;

  // Agent activity tracking (Cucumber + FOP agents)
  const agentActivity = useAgentActivity(lang as 'de' | 'en');

  // Process flow visualisation
  const processFlow = useProcessFlow();       // FOP analysis OR Cucumber (non-reverse tabs)
  const cucumberFlow = useProcessFlow();      // Cucumber generation from FOP analysis (reverse tab only)

  // FOP agent IDs (set after auto-creation in startup effect below)
  const [fopAnalystAgentId, setFopAnalystAgentId] = useState<string | null>(null);
  const [fopGuidelinesAgentId, setFopGuidelinesAgentId] = useState<string | null>(null);

  const [fopTreeViewMode, setFopTreeViewMode] = useState<'tree' | 'bindings'>('bindings');
  const [fopMidWidth, setFopMidWidth] = useState(Math.round(window.innerWidth / 3));

  // FOP Reverse Engineering workspace — opts use refs internally so model/varTables/lang are always current
  const fopAnalysis = useFopAnalysis({
    model,
    lang: lang as 'de' | 'en',
    varTables: tableDefs,
    initialBindings: fopBindings.length > 0 ? fopBindings : undefined,
    analystAgentId: fopAnalystAgentId ?? undefined,
    guidelinesAgentId: fopGuidelinesAgentId ?? undefined,
    experimentalFeatures,
    getEmitter: (type) => agentActivity.getEmitter(type),
    onActivityStart: (type, total) => {
      agentActivity.startRun(type, total);
    },
    onActivityProgress: (type, current, item, input, output) => {
      if (type === 'fop-guidelines') {
        // Start guidelines run if not yet started, and finish analyst
        const guidelinesRun = agentActivity.runs.get('fop-guidelines');
        if (!guidelinesRun || guidelinesRun.status !== 'running') {
          // Finish analyst first
          const analystRun = agentActivity.runs.get('fop-analyst');
          if (analystRun?.status === 'running') {
            agentActivity.finishRun('fop-analyst', 'done');
          }
          agentActivity.startRun('fop-guidelines', 1);
        }
      }
      if (input && !output) {
        agentActivity.addExchange(type, item, input);
        agentActivity.updateProgress(type, current, item, input, undefined);
      } else if (input && output) {
        agentActivity.updateLastExchange(type, output);
        agentActivity.updateProgress(type, current, item, undefined, output);
        // Finish the respective agent when response arrives
        if (type === 'fop-analyst') {
          agentActivity.completeItem('fop-analyst', item, true);
        } else if (type === 'fop-guidelines') {
          agentActivity.completeItem('fop-guidelines', item, true);
          agentActivity.finishRun('fop-guidelines', 'done');
        }
      } else {
        agentActivity.updateProgress(type, current, item, input, output);
      }
    },
    onActivityComplete: (type, item, success) => {
      agentActivity.completeItem(type, item, success);
      agentActivity.clearExchanges(type);
    },
    onActivityFinish: (type, status) => {
      agentActivity.finishRun(type, status);
      // Also finish guidelines if it was started
      if (type === 'fop-analyst' && agentActivity.runs.get('fop-guidelines')?.status === 'running') {
        agentActivity.finishRun('fop-guidelines', status);
      }
      // Complete any remaining steps
      processFlow.completeStep('fop-analyst');
      processFlow.completeStep('fop-guidelines');
      processFlow.completeStep('fop-save');
    },
    onStepUpdate: (stepId, item, input, output) => {
      const stepOrder = ['fop-parse', 'fop-buffers', 'fop-fields', 'fop-local-chk', 'fop-analyst', 'fop-guidelines', 'fop-save'];
      const isKiStep = stepId === 'fop-analyst' || stepId === 'fop-guidelines';

      if (isKiStep) {
        if (input && !output) {
          // KI request sent — activate step, add item (no output yet)
          const idx = stepOrder.indexOf(stepId);
          if (idx > 0) processFlow.completeStep(stepOrder[idx - 1]);
          processFlow.activateStep(stepId);
          processFlow.addItemsToStep(stepId, [{
            name: item, path: 'ki',
            input, inputLabel: 'Kontext an KI',
          }]);
        } else if (output) {
          // KI response received — update existing item with output, complete step
          processFlow.updateLastItem(stepId, {
            output, outputLabel: 'KI-Antwort',
          });
          processFlow.completeStep(stepId);
        }
      } else {
        // Local step — activate, add item, complete immediately
        const idx = stepOrder.indexOf(stepId);
        if (idx > 0) processFlow.completeStep(stepOrder[idx - 1]);
        processFlow.activateStep(stepId);
        processFlow.addItemsToStep(stepId, [{
          name: item, path: 'local',
          input, inputLabel: 'Eingabe',
          output, outputLabel: 'Ergebnis',
        }]);
        processFlow.completeStep(stepId);
      }
    },
  });
  const [authError, setAuthError] = useState<string | null>(null);
  const [tenantReady, setTenantReady] = useState(() => !!getStoredTenantId());

  // Poll for tenant availability after login (tenant is loaded async in SettingsPanel)
  useEffect(() => {
    if (!loggedIn || tenantReady) return;
    const id = setInterval(() => {
      if (getStoredTenantId()) {
        setTenantReady(true);
        clearInterval(id);
      }
    }, 500);
    return () => clearInterval(id);
  }, [loggedIn, tenantReady]);

  // Once tenant is ready, pull the authoritative server-side consumption total
  // and the tenant's configured daily token limit (both no-op without permissions).
  useEffect(() => {
    if (!tenantReady) return;
    void syncTenantLimit();
    void syncServerConsumption();
  }, [tenantReady]);

  // Re-sync when the active tenant changes mid-session (user picks a different
  // tenant in SettingsPanel without logging out).
  useEffect(() => {
    const handler = () => {
      void syncTenantLimit();
      void syncServerConsumption();
    };
    window.addEventListener('tenant-changed', handler);
    return () => window.removeEventListener('tenant-changed', handler);
  }, []);

  // Agents
  const [agents, setAgents] = useState<Agent[]>([]);
  const [, setSelectedFolderPath] = useState<string | null>(null);
  // EFK agents removed — Standard-Agent is used for all AI calls

  // Auto-logout when session expires (e.g. refresh token invalid)
  useEffect(() => {
    const handler = () => {
      setLoggedIn(false);
      setTenantReady(false);
    };
    window.addEventListener('session-expired', handler);
    return () => window.removeEventListener('session-expired', handler);
  }, []);

  // Whenever the login flag drops (manual logout from SettingsPanel, session
  // expiry, etc.), reset tenantReady so the post-login sync effect re-fires
  // the next time a tenant becomes available.
  useEffect(() => {
    if (!loggedIn) setTenantReady(false);
  }, [loggedIn]);

  // Pre-emptive daily-limit check on app startup: if today's locally-recorded
  // token usage already exceeds DAILY_LIMIT, set the session flag now so the
  // first AI call short-circuits with the daily-limit error instead of wasting
  // a doomed round-trip to MyForterro. The event listener in DocxImport will
  // show the one-time info banner.
  useEffect(() => {
    const hit = checkDailyLimitExceededFromHistory();
    if (hit) {
      console.log('[App] Startup check: local token history shows daily limit exceeded → session flag set, requests will short-circuit with the daily-limit error');
    }
    // Also reconcile with the server's authoritative count (requires admin
    // rights on the tenant — silently no-ops if the user lacks them).
    void syncServerConsumption();
  }, []);

  // Handle OAuth callback (code + state in URL after redirect from MyForterro)
  // Use ref to prevent StrictMode double-execution from clearing sessionStorage
  const authCallbackHandled = useRef(false);
  useEffect(() => {
    if (authCallbackHandled.current) return;
    // AI mode off → ignore any stray OAuth callback in the URL.
    if (!aiEnabled) return;
    if (!hasAuthCallback()) return;
    authCallbackHandled.current = true;
    (async () => {
      console.log('[OAuth] Callback erkannt, starte Token-Austausch...');
      const result = await handleAuthCallback();
      console.log('[OAuth] Ergebnis:', result);
      if (result.success) {
        setLoggedIn(true);
      } else {
        setAuthError(result.error || null);
      }
    })();
  }, []);
  const [previewMode, setPreviewMode] = useState<'toolbox' | 'text' | 'diagram'>('toolbox');

  // File Explorer
  const fileExplorer = useFileExplorer();
  // Ref so save effects can read the current handle without it being a dep that triggers them on workspace switch
  const activeRootHandleRef = useRef<FileSystemDirectoryHandle | null>(null);
  activeRootHandleRef.current = fileExplorer.rootHandle;

  // Persist FOP/IS bindings only when data changes (ref ensures correct workspace, no switch-triggered saves)
  useEffect(() => {
    if (activeRootHandleRef.current) saveFopBindingsToWorkspace(activeRootHandleRef.current, fopBindings).catch(() => {});
  }, [fopBindings]); // eslint-disable-line react-hooks/exhaustive-deps

  useEffect(() => {
    if (activeRootHandleRef.current) saveIsBindingsToWorkspace(activeRootHandleRef.current, isBindings).catch(() => {});
  }, [isBindings]); // eslint-disable-line react-hooks/exhaustive-deps

  // Sync conversation history with .agent-history.json in the open directory
  useEffect(() => {
    const handle = fileExplorer.rootHandle;
    if (!handle) return;
    loadConversationsFromDir(handle).then(convs => {
      if (convs.length > 0) agentActivity.initConversations(convs);
    }).catch(() => {});
  }, [fileExplorer.rootHandle]); // eslint-disable-line react-hooks/exhaustive-deps

  useEffect(() => {
    const handle = fileExplorer.rootHandle;
    if (!handle || agentActivity.savedConversations.length === 0) return;
    saveConversationsToDir(handle, agentActivity.savedConversations).catch(() => {});
  }, [agentActivity.savedConversations]); // eslint-disable-line react-hooks/exhaustive-deps

  // When the workspace folder changes, load all per-workspace data.
  const prevRootHandleRef = useRef<FileSystemDirectoryHandle | null>(null);
  useEffect(() => {
    const handle = fileExplorer.rootHandle;
    const isSwitch = prevRootHandleRef.current !== null;
    prevRootHandleRef.current = handle;
    if (!handle) return;
    let cancelled = false;
    (async () => {
      const [workspaceTables, workspaceFop, workspaceIs, workspaceKB] = await Promise.all([
        loadTableDefsFromWorkspace(handle),
        loadFopBindingsFromWorkspace(handle),
        loadIsBindingsFromWorkspace(handle),
        loadKBFromWorkspace(handle),
      ]);
      if (cancelled) return;

      const isNewWorkspace = workspaceTables === null && workspaceFop === null && workspaceIs === null && workspaceKB === null;

      if (isSwitch && isNewWorkspace) {
        // Switching to a brand-new workspace: offer to carry data over or start fresh
        const hasCurrent = tableDefs.length > 0 || fopBindings.length > 0 || isBindings.length > 0 || kbDocuments.length > 0 || workspaceLearnings.length > 0;
        if (hasCurrent) {
          setPendingWorkspaceImport({
            fromName: prevRootHandleRef.current?.name ?? '—',
            toName: handle.name,
            tables: tableDefs,
            fopBindings,
            isBindings,
            kbDocuments,
            learnings: workspaceLearnings.length,
            hasSettings: true,
          });
          return; // wait for modal decision before updating state
        }
        // No existing data — just clear and continue
        setTableDefs([]);
        setFopBindings([]);
        setIsBindings([]);
        return;
      }

      // Load saved workspace data; clear any type that has no saved cache
      setTableDefs(workspaceTables ?? []);
      setFopBindings((workspaceFop ?? []) as import('./types/fop').FopBinding[]);
      setIsBindings((workspaceIs ?? []) as import('./lib/isBindingsParser').IsBinding[]);
      if (workspaceKB !== null) {
        const { clearAllKBDocuments, saveKBDocument, saveKBChunks } = await import('./lib/kbStore');
        await clearAllKBDocuments();
        for (const doc of workspaceKB.docs) await saveKBDocument(doc as import('./types/knowledgeBase').KBDocument);
        if (workspaceKB.chunks.length > 0) await saveKBChunks(workspaceKB.chunks as import('./types/knowledgeBase').KBChunk[]);
        if (!cancelled) setKbDocuments(workspaceKB.docs as import('./types/knowledgeBase').KBDocument[]);
      } else if (isSwitch) {
        const { clearAllKBDocuments } = await import('./lib/kbStore');
        await clearAllKBDocuments();
        if (!cancelled) setKbDocuments([]);
      }
    })();
    return () => { cancelled = true; };
  }, [fileExplorer.rootHandle]); // eslint-disable-line react-hooks/exhaustive-deps

  // Persist tableDefs — only when data changes, NOT on workspace switch (ref prevents race condition)
  useEffect(() => {
    if (!activeRootHandleRef.current) return;
    saveTableDefsToWorkspace(activeRootHandleRef.current, tableDefs).catch(() => {});
  }, [tableDefs]); // eslint-disable-line react-hooks/exhaustive-deps

  // Persist KB documents+chunks — only when data changes
  useEffect(() => {
    if (!activeRootHandleRef.current) return;
    const handle = activeRootHandleRef.current;
    if (kbDocuments.length === 0) {
      saveKBToWorkspace(handle, [], []).catch(() => {});
      return;
    }
    import('./lib/kbStore').then(({ loadAllKBChunks }) => loadAllKBChunks()).then((chunks) => {
      saveKBToWorkspace(handle, kbDocuments, chunks).catch(() => {});
    }).catch(() => {});
  }, [kbDocuments]); // eslint-disable-line react-hooks/exhaustive-deps

  // Load workspace learnings and shared learnings from the shared settings folder
  // and keep compact hints ready for new agent conversations (token-efficient memory injection).
  useEffect(() => {
    let cancelled = false;
    const handle = fileExplorer.rootHandle;

    (async () => {
      try {
        const [workspaceEntries, sharedEntries] = await Promise.all([
          handle ? loadWorkspaceLearnings(handle) : Promise.resolve([]),
          loadSharedLearnings(),
        ]);
        if (cancelled) return;
        setWorkspaceLearnings(workspaceEntries);
        setSharedLearnings(sharedEntries);
      } catch {
        if (cancelled) return;
        setWorkspaceLearnings([]);
        setSharedLearnings([]);
        setWorkspaceLearningHints('');
        setWorkspaceConceptLearningHints('');
      }
    })();

    return () => { cancelled = true; };
  }, [fileExplorer.rootHandle, sharedSettingsRevision]);

  // Recompute compact hints when learnings change in-memory.
  useEffect(() => {
    const mergedLearnings = [...sharedLearnings, ...workspaceLearnings];
    setWorkspaceLearningHints(buildLearningPromptHints(mergedLearnings, 2400, getLearningCrosscheckMode(), 'tests'));
    setWorkspaceConceptLearningHints(buildLearningPromptHints(mergedLearnings, 2400, getLearningCrosscheckMode(), 'programs'));
  }, [sharedLearnings, workspaceLearnings]);

  const [explorerWidth, setExplorerWidth] = useState(() => {
    const saved = localStorage.getItem('cucumbergnerator_explorer_width');
    return saved ? Number(saved) : 320;
  });
  const explorerWidthRef = useRef(explorerWidth);
  explorerWidthRef.current = explorerWidth;

  const [sidePanelCollapsed, setSidePanelCollapsedRaw] = useState<boolean>(() => {
    return localStorage.getItem('cucumbergnerator_side_panel_collapsed') === '1';
  });
  const setSidePanelCollapsed = useCallback((next: boolean) => {
    setSidePanelCollapsedRaw(next);
    localStorage.setItem('cucumbergnerator_side_panel_collapsed', next ? '1' : '0');
  }, []);
  const [workflowDiagramExpanded, setWorkflowDiagramExpanded] = useState<boolean>(() => {
    return localStorage.getItem('cucumbergnerator_workflow_diagram_expanded') === '1';
  });
  useEffect(() => {
    localStorage.setItem('cucumbergnerator_workflow_diagram_expanded', workflowDiagramExpanded ? '1' : '0');
  }, [workflowDiagramExpanded]);
  const [sidePanelWidth, setSidePanelWidth] = useState<number>(() => {
    const saved = localStorage.getItem('cucumbergnerator_side_panel_width');
    return saved ? Number(saved) : 420;
  });
  const sidePanelWidthRef = useRef(sidePanelWidth);
  sidePanelWidthRef.current = sidePanelWidth;
  const appRef = useRef<HTMLDivElement>(null);

  const existingFeatureGuids = useMemo(() => collectExistingGuids(fileExplorer.tree), [fileExplorer.tree]);

  // Load tableDefs from IndexedDB on mount (async)
  useEffect(() => {
    let cancelled = false;
    (async () => {
      // If a shared settings folder is configured, always pull settings.json first
      // so manual file edits are applied on every app start.
      try {
        const sharedJson = await loadSharedSettingsJson();
        if (sharedJson && sharedJson.trim()) {
          const imported = importAppSettingsJson(sharedJson);
          if (!cancelled) setModel(imported.model ?? '');
        }
      } catch (err) {
        console.warn('[App] Failed to load shared settings.json at startup:', err);
      }

      // Try migration from localStorage first (one-time)
      const migrated = await migrateTableDefsFromLocalStorage();
      if (cancelled) return;
      if (migrated) {
        setTableDefs(migrated);
      } else {
        const saved = await loadTableDefs();
        if (!cancelled) setTableDefs(saved);
      }
      if (!cancelled) setAppLoading(false);
      // Also load KB documents
      import('./lib/kbStore').then(({ loadKBDocuments }) => loadKBDocuments()).then(docs => {
        if (!cancelled) setKbDocuments(docs);
      });
    })();
    return () => { cancelled = true; };
  }, []);

  // Load agents from IndexedDB on mount
  useEffect(() => {
    let cancelled = false;
    loadAgents().then((loaded) => {
      if (!cancelled) setAgents(loaded);
    }).catch(console.error);
    return () => { cancelled = true; };
  }, []);

  // Auto-save features to localStorage
  useEffect(() => {
    saveFeatures(features);
  }, [features]);

  // Resizable splitter
  const [splitPercent, setSplitPercent] = useState(() => {
    const saved = localStorage.getItem('cucumbergnerator_split');
    return saved ? Number(saved) : 50;
  });
  const splitRef = useRef(splitPercent);
  splitRef.current = splitPercent;
  const mainRef = useRef<HTMLElement>(null);

  const handleDividerMouseDown = useCallback((e: React.MouseEvent) => {
    e.preventDefault();
    const onMouseMove = (ev: MouseEvent) => {
      if (!mainRef.current) return;
      const rect = mainRef.current.getBoundingClientRect();
      const pct = ((ev.clientX - rect.left) / rect.width) * 100;
      const clamped = Math.min(Math.max(pct, 25), 80);
      setSplitPercent(clamped);
      splitRef.current = clamped;
    };
    const onMouseUp = () => {
      document.body.style.cursor = '';
      document.body.style.userSelect = '';
      localStorage.setItem('cucumbergnerator_split', String(splitRef.current));
      document.removeEventListener('mousemove', onMouseMove);
      document.removeEventListener('mouseup', onMouseUp);
    };
    document.body.style.cursor = 'col-resize';
    document.body.style.userSelect = 'none';
    document.addEventListener('mousemove', onMouseMove);
    document.addEventListener('mouseup', onMouseUp);
  }, []);

  // Explorer divider resize
  const handleExplorerDividerMouseDown = useCallback((e: React.MouseEvent) => {
    e.preventDefault();
    const onMouseMove = (ev: MouseEvent) => {
      if (!mainRef.current) return;
      const rect = mainRef.current.getBoundingClientRect();
      const px = ev.clientX - rect.left;
      const clamped = Math.min(Math.max(px, 180), 400);
      setExplorerWidth(clamped);
      explorerWidthRef.current = clamped;
    };
    const onMouseUp = () => {
      document.body.style.cursor = '';
      document.body.style.userSelect = '';
      localStorage.setItem('cucumbergnerator_explorer_width', String(explorerWidthRef.current));
      document.removeEventListener('mousemove', onMouseMove);
      document.removeEventListener('mouseup', onMouseUp);
    };
    document.body.style.cursor = 'col-resize';
    document.body.style.userSelect = 'none';
    document.addEventListener('mousemove', onMouseMove);
    document.addEventListener('mouseup', onMouseUp);
  }, []);

  // Side panel divider resize — drag leftward to widen the panel.
  const handleSidePanelDividerMouseDown = useCallback((e: React.MouseEvent) => {
    e.preventDefault();
    const onMouseMove = (ev: MouseEvent) => {
      if (!appRef.current) return;
      const rect = appRef.current.getBoundingClientRect();
      // Distance from cursor to the right edge of the app container = new panel width.
      const px = rect.right - ev.clientX;
      const clamped = Math.min(Math.max(px, 260), 900);
      setSidePanelWidth(clamped);
      sidePanelWidthRef.current = clamped;
    };
    const onMouseUp = () => {
      document.body.style.cursor = '';
      document.body.style.userSelect = '';
      localStorage.setItem('cucumbergnerator_side_panel_width', String(sidePanelWidthRef.current));
      document.removeEventListener('mousemove', onMouseMove);
      document.removeEventListener('mouseup', onMouseUp);
    };
    document.body.style.cursor = 'col-resize';
    document.body.style.userSelect = 'none';
    document.addEventListener('mousemove', onMouseMove);
    document.addEventListener('mouseup', onMouseUp);
  }, []);

  // Compute paths with validation errors for file explorer red markers
  const errorPaths = useMemo(() => {
    const paths = new Set<string>();
    function walk(node: { path: string; type: string; children: typeof fileExplorer.tree; featureInput?: FeatureInput; scenarioId?: string }) {
      if (node.type === 'file' && node.featureInput) {
        if (featureHasStepErrors(node.featureInput)) paths.add(node.path);
        // Also mark individual scenario nodes
        for (const sc of node.featureInput.scenarios) {
          if (scenarioHasErrors(sc)) paths.add(`${node.path}#${sc.id}`);
        }
      }
      for (const child of node.children) walk(child);
    }
    for (const node of fileExplorer.tree) walk(node);
    return paths;
  }, [fileExplorer.tree]);

  // Single agent mode — always use the first (and only) agent regardless of folder
  // Agent chat UI removed; agents are only used for: editorAgentApiId (generation) and FOP analysis
  const effectivePreviewMode = previewMode;

  // Agent IDs are configured by the user in Settings (like AI credentials) — the
  // tool never creates agents on the API. This supports both global agents shared
  // across tenants and customer-specific agents someone else created and handed over.
  const [agentsLoaded, setAgentsLoaded] = useState(false);
  useEffect(() => {
    loadAgents().then(() => setAgentsLoaded(true)).catch(() => setAgentsLoaded(true));
  }, []);

  // Sync the local Cucumber-Agent record to whatever ID is configured in Settings.
  // No creation/discovery, and no remote instructions push — the agent's instructions
  // are managed externally on the agent itself. A missing/invalid ID simply means AI
  // calls run in "Direct" mode (no agentId, see generatePackage.ts).
  useEffect(() => {
    if (!loggedIn || !agentsLoaded || !tenantReady) return;
    const configuredId = getStoredAgentId('cucumber').trim() || null;

    (async () => {
      const existing = agents.length > 0 ? agents[0] : null;
      if (!existing) {
        if (!configuredId) return; // nothing configured yet — stay in Direct mode
        const newAgent: Agent = {
          id: crypto.randomUUID(),
          name: 'Cucumber Agent',
          folderPath: '',
          apiAgentId: configuredId,
          conversationId: null,
          messages: [],
          context: [],
          createdAt: Date.now(),
          updatedAt: Date.now(),
        };
        await saveAgent(newAgent);
        setAgents((prev) => [...prev, newAgent]);
      } else if (existing.apiAgentId !== configuredId) {
        // The configured ID changed (or was cleared) — reset the conversation.
        const updated: Agent = { ...existing, apiAgentId: configuredId, conversationId: null, updatedAt: Date.now() };
        await saveAgent(updated);
        setAgents((prev) => prev.map((a) => (a.id === updated.id ? updated : a)));
      }
    })();
  }, [loggedIn, agentsLoaded, tenantReady, agents]);

  // Track FOP-agent IDs configured in Settings (experimentalFeatures only) — no
  // creation/discovery and no remote instructions push (managed externally).
  useEffect(() => {
    if (!loggedIn || !tenantReady || !experimentalFeatures) return;
    setFopAnalystAgentId(getStoredAgentId('fop-analyst').trim() || null);
    setFopGuidelinesAgentId(getStoredAgentId('fop-guidelines').trim() || null);
  }, [loggedIn, tenantReady, experimentalFeatures]);

  // ~15 000 Tokens pro Datei — hält den Request unter dem gpt-4 TPM-Limit
  const MAX_CONTEXT_CHARS_PER_FILE = 60_000;

  // Build the message to send: prepend context docs when starting a new conversation.
  // Type-aware: vartab and efk summaries are included as structured preamble; oversized docs are truncated.
  // (Currently not used, kept for future multi-agent messaging support)
  useCallback((text: string, context: AgentContext[], isNewConversation: boolean): string => {
    if (!isNewConversation) return text;
    const parts: string[] = [];

    if (workspaceLearningHints.trim()) {
      parts.push(`## Workspace Learning-Hints\n${workspaceLearningHints}`);
    }

    for (const c of context) {
      const type = c.type ?? 'doc';
      if (type === 'efk-anchor') {
        parts.push(`## EFK-Übersicht (alle Pakete)\n${c.content}`);
      } else if (type === 'vartab') {
        parts.push(`## Variablentabelle: ${c.fileName}\n${c.content}`);
      } else if (type === 'efk') {
        parts.push(`## Einzelfunktionskonzept: ${c.fileName}\n${c.content}`);
      } else {
        const content = c.content.length > MAX_CONTEXT_CHARS_PER_FILE
          ? c.content.slice(0, MAX_CONTEXT_CHARS_PER_FILE) + `\n[... auf ${MAX_CONTEXT_CHARS_PER_FILE.toLocaleString()} Zeichen gekürzt]`
          : c.content;
        parts.push(`## Dokument: ${c.fileName}\n${content}`);
      }
    }

    if (parts.length === 0) return text;

    return `${parts.join('\n\n')}\n\n---\n\n${text}`;
  }, [workspaceLearningHints]);


  // Helper: handle errors from agent API calls
  // (Currently not used, kept for future error-handling support)
  useCallback((err: unknown) => {
    const raw = (err as Error).message ?? '';
    // Error handling for agent API calls would be placed here
  }, []);

  // Create folder — no agent creation needed (Standard-Agent is used)
  const handleCreateFolder = useCallback(async (parentPath: string, folderName?: string): Promise<string | null> => {
    return fileExplorer.createFolder(parentPath, folderName);
  }, [fileExplorer]);

  // Agent chat handlers removed — no longer needed





  // Agent: reset (delete + recreate, with confirmation modal)

  // Model change — agent instructions/model are no longer pushed to the remote
  // agent; it's managed externally, and per-call model overrides already apply
  // (see getTaskModel / generatePackage.ts).
  const handleModelChange = useCallback((newModel: string) => {
    setModel(newModel);
  }, []);

  // Session retry (general)
  const retryAfterSessionExpiry = useCallback(async () => {
    const clientId = getStoredClientId();
    const applicationId = getStoredApplicationId();
    const clientSecret = getStoredClientSecret();
    if (clientId && applicationId) {
      await initiateLogin(clientId, applicationId, clientSecret || undefined);
    }
  }, []);

  // File explorer: handle file creation → auto-open in editor
  const handleExplorerCreateFile = useCallback(async (parentPath: string, fileName?: string) => {
    const newPath = await fileExplorer.createFile(parentPath, fileName);
    if (newPath) {
      // createFile already sets activeFilePath and reads the file handle;
      // we just need to load the (empty) feature into the editor state
      const featureName = newPath.split('/').pop()?.replace(/\.feature$/, '') || '';
      const featureInput = { ...INITIAL_FEATURE, name: featureName, tags: [`@guid-${makeFeatureGuid('', featureName)}`] };
      setFeatures([featureInput]);
      setActiveFeatureIdx(0);
    }
  }, [fileExplorer, setFeatures]);

  // File explorer: handle file delete → reset editor state
  const handleDeleteFile = useCallback(async (path: string) => {
    const wasActive = fileExplorer.activeFilePath === path;
    await fileExplorer.deleteFile(path);
    if (wasActive) {
      setFeatures([{ ...INITIAL_FEATURE }]);
      setActiveFeatureIdx(0);
    }
  }, [fileExplorer, setFeatures]);

  // File explorer: handle bulk file delete (multi-select)
  const handleDeleteFiles = useCallback(async (paths: string[]) => {
    if (paths.length === 0) return;
    const wasActive = !!(fileExplorer.activeFilePath && paths.includes(fileExplorer.activeFilePath));
    await fileExplorer.deleteFiles(paths);
    if (wasActive) {
      setFeatures([{ ...INITIAL_FEATURE }]);
      setActiveFeatureIdx(0);
    }
  }, [fileExplorer, setFeatures]);

  // File explorer: duplicate file and load duplicate in editor
  const handleDuplicateFile = useCallback(async (path: string) => {
    const newPath = await fileExplorer.duplicateFile(path);
    if (!newPath) return;
    const featureInput = await fileExplorer.selectFile(newPath);
    if (featureInput) {
      setFeatures([featureInput]);
      setActiveFeatureIdx(0);
      fileExplorer.expandNode(newPath);
    }
  }, [fileExplorer, setFeatures]);

  // File explorer: handle folder delete → reset editor if active file was inside
  const handleDeleteFolder = useCallback(async (path: string) => {
    const wasInside = fileExplorer.activeFilePath?.startsWith(path + '/') || fileExplorer.activeFilePath === path;
    await fileExplorer.deleteFolder(path);
    if (wasInside) {
      setFeatures([{ ...INITIAL_FEATURE }]);
      setActiveFeatureIdx(0);
    }
  }, [fileExplorer, setFeatures]);

  // File explorer: handle file selection
  const handleExplorerSelectFile = useCallback(async (path: string) => {
    const featureInput = await fileExplorer.selectFile(path);
    if (featureInput) {
      setFeatures([featureInput]);
      setActiveFeatureIdx(0);
      // Expand the file node so scenarios are visible
      fileExplorer.expandNode(path);
    }
  }, [fileExplorer, setFeatures]);

  // File explorer: handle scenario selection
  const [focusScenario, setFocusScenario] = useState<{ id: string; ts: number } | null>(null);

  const handleExplorerSelectScenario = useCallback(async (filePath: string, scenarioId: string) => {
    // Find the scenario name from the tree node (IDs are unstable across parses)
    let scenarioName = '';
    const findInTree = (nodes: typeof fileExplorer.tree): void => {
      for (const n of nodes) {
        if (n.type === 'scenario' && n.scenarioId === scenarioId) {
          scenarioName = n.displayName;
          return;
        }
        if (n.children.length > 0) findInTree(n.children);
      }
    };
    findInTree(fileExplorer.tree);

    // If the file is not already open, load it first
    if (filePath !== fileExplorer.activeFilePath) {
      const featureInput = await fileExplorer.selectScenario(filePath, scenarioId);
      if (featureInput) {
        setFeatures([featureInput]);
        setActiveFeatureIdx(0);
      }
    }

    // Find scenario by name in the editor's feature (IDs differ between tree and editor)
    const editorFeature = features[activeFeatureIdx] ?? features[0];
    const matchIdx = editorFeature?.scenarios.findIndex((s) => s.name === scenarioName) ?? -1;
    const matchId = matchIdx >= 0 ? editorFeature!.scenarios[matchIdx].id : scenarioId;
    setFocusScenario({ id: matchId, ts: Date.now() });
  }, [fileExplorer, setFeatures, features, activeFeatureIdx]);

  const feature = features[activeFeatureIdx] ?? INITIAL_FEATURE;
  const isTemplateEditing = templateDraft !== null;
  const editorFeature = templateDraft ?? feature;

  const stripIds = (value: unknown): unknown => {
    if (Array.isArray(value)) return value.map((entry) => stripIds(entry));
    if (value && typeof value === 'object') {
      const result: Record<string, unknown> = {};
      for (const [key, entry] of Object.entries(value as Record<string, unknown>)) {
        if (key === 'id') continue;
        result[key] = stripIds(entry);
      }
      return result;
    }
    return value;
  };

  const isTemplateDirty = isTemplateEditing
    && templateDraftInitial !== null
    && JSON.stringify(stripIds(templateDraft)) !== JSON.stringify(stripIds(templateDraftInitial));

  const templateDiscardConfirmActionRef = useRef<(() => void) | null>(null);
  const [showTemplateDiscardConfirm, setShowTemplateDiscardConfirm] = useState(false);
  const [showResetConfirm, setShowResetConfirm] = useState(false);

  const deriveTemplateName = (draft: FeatureInput): string => (
    draft.name?.trim()
    || draft.scenarios[0]?.name?.trim()
    || ''
  );

  const startTemplateEditor = (draft: FeatureInput, templateName: string, templateId: string | null) => {
    const run = () => {
      const clonedDraft = JSON.parse(JSON.stringify(draft)) as FeatureInput;
      setTemplateDraft(clonedDraft);
      setTemplateDraftInitial(JSON.parse(JSON.stringify(clonedDraft)) as FeatureInput);
      setTemplateEditingName(templateName || deriveTemplateName(clonedDraft));
      setTemplateEditingId(templateId);
    };
    if (isTemplateDirty) {
      templateDiscardConfirmActionRef.current = run;
      setShowTemplateDiscardConfirm(true);
      return;
    }
    run();
  };

  const closeTemplateEditor = () => {
    const run = () => {
      setTemplateDraft(null);
      setTemplateDraftInitial(null);
      setTemplateEditingName(null);
      setTemplateEditingId(null);
    };
    if (isTemplateDirty) {
      templateDiscardConfirmActionRef.current = run;
      setShowTemplateDiscardConfirm(true);
      return;
    }
    run();
  };

  const updateFeature = (updated: FeatureInput) => {
    setFeatures((prev) => prev.map((f, i) => (i === activeFeatureIdx ? updated : f)));
    // Auto-save to disk in directory mode
    if (fileExplorer.isDirectoryMode && fileExplorer.activeFilePath) {
      fileExplorer.saveActiveFile(updated);
      fileExplorer.updateTreeForFeature(fileExplorer.activeFilePath, updated);
    }
  };

  const updateEditorFeature = (updated: FeatureInput) => {
    if (isTemplateEditing) {
      setTemplateDraft(updated);
      setTemplateEditingName(deriveTemplateName(updated));
      return;
    }
    updateFeature(updated);
  };

  const handleTemplateSaved = useCallback((savedTemplateId: string, savedTemplateName: string) => {
    if (!templateDraft) return;
    const clonedDraft = JSON.parse(JSON.stringify(templateDraft)) as FeatureInput;
    setTemplateDraftInitial(clonedDraft);
    setTemplateEditingId(savedTemplateId);
    setTemplateEditingName(savedTemplateName || deriveTemplateName(clonedDraft));
    setTemplateSaveTick((value) => value + 1);
  }, [templateDraft]);

  const handleTablesChange = (tables: TableDef[]) => {
    setTableDefs(tables);
    saveTableDefs(tables); // global IDB fallback; workspace save handled by effect
  };
  const { gherkin, lineMapping } = useGherkinGenerator(editorFeature);
  const { loading, generationStep, error, generate } = useAiGeneration();
  const [aiRating, setAiRating] = useState<AiPromptRating | null>(null);
  const [aiEditLoading, setAiEditLoading] = useState(false);
  const [aiEditError, setAiEditError] = useState<string | null>(null);
  const [aiEditReview, setAiEditReview] = useState<{
    updated: FeatureInput;
    title: string;
    message: string;
    allowApply: boolean;
  } | null>(null);
  const { loading: ratingLoading, error: ratingError, rating: standaloneAiRating, requestRating } = useAiRating();

  const normalizeScenarioName = useCallback((name: string) => name.trim().toLowerCase().replace(/\s+/g, ' '), []);

  const hasExplicitDestructiveIntent = useCallback((request: string) => {
    // Require explicit destructive verbs; generic "anpassen" should not allow removals.
    return /\b(loesch|lösch|entfern|streich|remove|delete|drop|merge|zusammenfassen|combine|rename|umbenenn|ersetz\w* komplett|rewrite|neu aufbauen)\b/i.test(request);
  }, []);

  const buildAiEditSafetySummary = useCallback((before: FeatureInput, after: FeatureInput) => {
    const beforeByName = new Map(before.scenarios.map((s) => [normalizeScenarioName(s.name), s] as const).filter(([k]) => !!k));
    const afterByName = new Map(after.scenarios.map((s) => [normalizeScenarioName(s.name), s] as const).filter(([k]) => !!k));

    const removedKeys = Array.from(beforeByName.keys()).filter((k) => !afterByName.has(k));
    const addedKeys = Array.from(afterByName.keys()).filter((k) => !beforeByName.has(k));

    const changed = Array.from(beforeByName.keys())
      .filter((k) => afterByName.has(k))
      .map((k) => {
        const b = beforeByName.get(k)!;
        const a = afterByName.get(k)!;
        const bSig = JSON.stringify(b.steps.map((st) => ({ kw: st.keyword, tx: st.text, ac: st.action })));
        const aSig = JSON.stringify(a.steps.map((st) => ({ kw: st.keyword, tx: st.text, ac: st.action })));
        return {
          key: k,
          name: b.name || a.name || k,
          changed: bSig !== aSig,
          beforeSteps: b.steps.length,
          afterSteps: a.steps.length,
        };
      })
      .filter((entry) => entry.changed);

    return {
      removedKeys,
      addedKeys,
      changed,
      hasDestructiveDelta: removedKeys.length > 0,
      beforeCount: before.scenarios.length,
      afterCount: after.scenarios.length,
    };
  }, [normalizeScenarioName]);

  const parseScenarioPatchResponse = useCallback((rawResponse: string): { scenarios: Scenario[]; hasEndMarker: boolean } => {
    const START_MARKER = '# BEGIN-SCENARIO-PATCH';
    const END_MARKER = '# END-SCENARIO-PATCH';
    const text = (rawResponse || '').replace(/\r\n/g, '\n').trim();
    const hasEndMarker = text.includes(END_MARKER);
    let body = text;
    const startRegex = new RegExp(`(^|\\n)\\s*${START_MARKER.replace(/[.*+?^${}()|[\\]\\]/g, '\\$&')}\\s*(\\n|$)`);
    const endRegex = new RegExp(`(^|\\n)\\s*${END_MARKER.replace(/[.*+?^${}()|[\\]\\]/g, '\\$&')}\\s*$`);
    const startMatch = body.match(startRegex);
    if (startMatch && typeof startMatch.index === 'number') {
      body = body.slice(startMatch.index + startMatch[0].length).trim();
    }
    body = body.replace(endRegex, '').trim();
    if (!body) return { scenarios: [], hasEndMarker };

    const lines = body.split('\n');
    const headerIdx: number[] = [];
    for (let i = 0; i < lines.length; i += 1) {
      if (/^\s*Scenario:\s+/.test(lines[i])) headerIdx.push(i);
    }
    if (headerIdx.length === 0) return { scenarios: [], hasEndMarker };

    const scenarios: Scenario[] = [];
    for (let i = 0; i < headerIdx.length; i += 1) {
      let start = headerIdx[i];
      while (start > 0 && /^\s*@/.test(lines[start - 1])) start -= 1;
      const end = i + 1 < headerIdx.length ? headerIdx[i + 1] : lines.length;
      const block = lines.slice(start, end).join('\n').trim();
      if (!block) continue;
      const parsedPatch = parseGherkin(`Feature: PATCH\n\n${block}\n`);
      if (parsedPatch.scenarios.length > 0) scenarios.push(parsedPatch.scenarios[0]);
    }

    return { scenarios, hasEndMarker };
  }, []);

  // Report single-feature generation to AgentStatusBar
  useEffect(() => {
    if (loading) {
      agentActivity.startRun('cucumber', 1);
      agentActivity.updateProgress(
        'cucumber', 0, feature.name || '…',
        // inputSnapshot: what we're sending to the KI
        feature.description
          ? `Feature: ${feature.name || '(unnamed)'}\n\n${feature.description}`
          : undefined,
      );
    } else {
      agentActivity.finishRun('cucumber', 'done');
    }
  }, [loading]); // eslint-disable-line react-hooks/exhaustive-deps

  // Agent for editor: use first agent with apiAgentId
  const editorAgentApiId = agents.find((a) => a.apiAgentId)?.apiAgentId ?? null;

  const handleRequestRating = useCallback(() => {
    if (!feature.description.trim()) return;
    if (!editorAgentApiId) return;
    agentActivity.startRun('rating', 1);
    requestRating(feature.description, model, editorAgentApiId, agentActivity.getEmitter('rating'), lang as 'de' | 'en')
      .finally(() => agentActivity.finishRun('rating', 'done'));
  }, [feature.description, model, editorAgentApiId, requestRating, agentActivity, lang]);

  const handleStepClick = useCallback((stepId: string) => {
    const el = document.getElementById(`step-${stepId}`);
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'center' });
      el.classList.remove('step-highlight');
      // Force reflow so re-adding the class restarts the animation
      void el.offsetWidth;
      el.classList.add('step-highlight');
      setTimeout(() => el.classList.remove('step-highlight'), 3000);
    }
  }, []);

  const handleGenerate = async () => {
    if (!feature.description.trim() || !editorAgentApiId) return;
    setAiRating(null);

    // ── Start process flow ─────────────────────────────────────
    processFlow.startFlow('cucumber');

    // AP lesen
    processFlow.activateStep('read-ap');
    processFlow.completeStep('read-ap', [{
      name: feature.name || '(unnamed)', path: 'local',
      detail: feature.description.slice(0, 120),
    }]);

    // Pre-detect tables locally (same logic as generatePackage) — use result directly in prompt
    const featureSearchText = `${feature.name || ''}\n${feature.description}`;
    const hasVNotation = tableDefs.length > 0 &&
      /(?:V-?\d+-\d+|P\d+:\d+)\b/i.test(featureSearchText);
    const preTablePath = tableDefs.length === 0 ? 'local' : hasVNotation ? 'local' : 'ki';
    const tableStepId = preTablePath === 'local' ? 'local-tables' : 'ki-tables';

    // For local detection: compute matched tables right here so we can pass them to generate()
    let preDetectedTables: typeof tableDefs | undefined;
    if (hasVNotation && !getForceKiTableId()) {
      const refMatches = Array.from(featureSearchText.matchAll(/(?:V-?(\d+)-(\d+)|P(\d+:\d+))\b/gi));
      const localRefs = new Set<string>();
      for (const m of refMatches) {
        if (m[1] && m[2]) localRefs.add(`${parseInt(m[1], 10)}:${parseInt(m[2], 10)}`);
        else if (m[3]) localRefs.add(m[3]);
      }
      const matched = tableDefs.filter(t => localRefs.has(t.tableRef));
      if (matched.length > 0) preDetectedTables = matched;
    }

    processFlow.activateStep('branch-tables');

    // Immediately mark the table-ID branch + prompt as active
    // (table ID happens synchronously before streaming starts)
    processFlow.activateStep(tableStepId);
    processFlow.completeStep(tableStepId, []); // items filled after completion
    processFlow.activateStep('build-prompt');
    processFlow.completeStep('build-prompt', []); // items filled after completion
    processFlow.activateStep('gen-gherkin');

    // Add feature name so status text shows correct item
    processFlow.addItemsToStep('gen-gherkin', [{
      name: feature.name || '(unnamed)', path: 'ki',
    }]);

    let streamedSoFar = '';
    const result = await generate(
      feature.description, model, editorAgentApiId, feature.testUser, tableDefs, feature.name,
      workspaceConceptLearningHints,
      (chunk) => {
        streamedSoFar += chunk;
      },
      undefined, // onTablesIdentified handled separately
      preDetectedTables, // pass pre-detected tables → skips re-detection in generatePackage
      undefined,
      agentActivity.getEmitter('cucumber'),
      lang as 'de' | 'en',
      fileExplorer.rootHandle,
    );

    if (result) {
      console.log('[ProcessFlow-Single] Generation complete:', {
        tableIdPath: result.tableIdPath,
        identifiedTables: result.identifiedTables,
        fieldCount: result.fieldCount,
        hasGherkinRequest: !!result.gherkinRequest,
        gherkinRequestLen: result.gherkinRequest?.length,
        gherkinRequestPreview: result.gherkinRequest?.slice(0, 200),
        hasRawResponse: !!result.rawResponse,
        scenarios: result.feature.scenarios.length,
      });
      setAiRating(result.aiRating);

      const actualTableStepId = result.tableIdPath === 'local' ? 'local-tables' : 'ki-tables';
      const idPath = result.tableIdPath === 'local' ? 'local' as const : 'ki' as const;

      if (actualTableStepId !== tableStepId) {
        processFlow.resetStep(tableStepId);
        processFlow.completeStep(actualTableStepId);
      }

      const singleTableOutput = result.tableIdPath === 'ki'
        ? [result.tableIdRawResponse || '(keine Ergebnisse)', result.tableContext ? `\n\n── Tabellenfelder ──\n${result.tableContext}` : ''].join('')
        : result.tableContext || result.tableIdRawResponse || '(keine Ergebnisse)';
      processFlow.addItemsToStep(actualTableStepId, [{
        name: feature.name || '(unnamed)',
        path: idPath,
        detail: result.identifiedTables.length > 0
          ? `${result.identifiedTables.length} Tabellen, ${result.fieldCount} Felder`
          : '(keine Treffer)',
        subItems: result.identifiedTables,
        input: result.tableIdRequest || '(kein Suchtext erfasst)',
        inputLabel: result.tableIdPath === 'ki' ? 'KI-Anfrage' : 'Erkennung',
        output: singleTableOutput,
        outputLabel: result.tableIdPath === 'ki' ? 'KI-Antwort + Felder' : 'Tabellenfelder',
      }]);

      // Prompt aufbauen — nur Anforderungstext + Tabellen-Überblick (voller Prompt im Live-Monitor)
      processFlow.addItemsToStep('build-prompt', [{
        name: feature.name || '(unnamed)',
        path: 'local',
        detail: `${result.identifiedTables.length} Tabellen · ${result.fieldCount} Felder`,
        subItems: result.identifiedTables,
        input: feature.description || '(kein Anforderungstext)',
        inputLabel: 'Anforderungstext',
      }]);

      // Gherkin generieren — full prompt (same as "Prompt aufbauen") + response
      processFlow.completeStep('gen-gherkin', [{
        name: result.feature.name || feature.name || '(unnamed)',
        path: 'ki',
        detail: `${result.feature.scenarios.length} Szenario(s)`,
        input: result.gherkinRequest || '(kein Prompt erfasst)',
        inputLabel: 'Prompt an KI',
        output: result.rawResponse,
        outputLabel: 'KI-Antwort',
      }]);

      // Erfolgreich
      processFlow.completeStep('result-ok', [{
        name: result.feature.name || feature.name || '(unnamed)',
        path: 'local',
        detail: `${result.feature.scenarios.length} Szenario(s) generiert`,
        output: result.rawResponse,
      }]);

      const { generateGherkin: genGherkin } = await import('./lib/generator');
      const gherkinOutput = genGherkin(result.feature);
      agentActivity.updateProgress('cucumber', 1, result.feature.name || feature.name || '…',
        result.gherkinRequest || feature.description || '(kein Prompt)',
        gherkinOutput,
      );
      agentActivity.completeItem('cucumber', result.feature.name || feature.name || '…', true);
      const base = features[activeFeatureIdx] ?? feature;
      const updated: FeatureInput = {
        ...base,
        name: result.feature.name || base.name,
        tags: result.feature.tags.length > 0 ? result.feature.tags : base.tags,
        scenarios: result.feature.scenarios,
      };
      updateFeature(updated);
      // Make sure the user sees the inserted result even if they switched tabs during generation.
      setView('editor');
    }
  };

  const handleApplyAiEdit = useCallback(async (request: string) => {
    const trimmed = request.trim();
    if (!trimmed) return;
    if (!editorAgentApiId) {
      setAiEditError(t('app.noAgentAvailable'));
      return;
    }

    setAiEditError(null);
    setAiEditLoading(true);
    const itemKey = editorFeature.name.trim() || t('app.currentFile');
    const emitter = agentActivity.getEmitter('cucumber');
    const allowDestructive = hasExplicitDestructiveIntent(trimmed);
    const phaseLang: 'de' | 'en' = lang === 'de' ? 'de' : 'en';
    const promptLang = ((['de', 'en', 'es', 'fr'] as const).includes(lang as 'de' | 'en' | 'es' | 'fr')
      ? lang
      : 'en') as 'de' | 'en' | 'es' | 'fr';
    try {
      const currentGherkin = generateGherkin(editorFeature);
      const safetyAppendix = [
        '',
        t('app.aiEditPromptHardRulesTitle'),
        `- ${t('app.aiEditPromptRuleNoDelete')}`,
        `- ${t('app.aiEditPromptRuleKeepNames')}`,
        `- ${t('app.aiEditPromptRuleConservative')}`,
        `- ${t('app.aiEditPromptRuleSelfCheck')}`,
        ...(!allowDestructive ? [
          '',
          t('app.aiEditPromptOutputTitle'),
          `- ${t('app.aiEditPromptOutputRuleChangedOnly')}`,
          `- ${t('app.aiEditPromptOutputRuleKeepNamesExact')}`,
          `- ${t('app.aiEditPromptOutputRuleNoFeature')}`,
          `- ${t('app.aiEditPromptOutputRuleEndMarker')}`,
        ] : []),
        '',
        t('app.aiEditPromptExistingNamesTitle'),
        ...editorFeature.scenarios.map((s) => `- ${s.name || t('app.aiEditPromptUnnamedScenario')}`),
      ].join('\n');
      const patchPrompt = [
        t('app.aiEditPatchPromptIntro'),
        '',
        t('app.aiEditPatchPromptChangeTitle'),
        trimmed,
        '',
        (phaseLang === 'de'
          ? 'Ausgabeformat (streng):\n# BEGIN-SCENARIO-PATCH\n[nur geaenderte Scenario-Bloecke mit optionalen @tags]\n# END-SCENARIO-PATCH\nKeine Erklaerung, kein JSON, kein Feature:-Header.'
          : 'Output format (strict):\n# BEGIN-SCENARIO-PATCH\n[only changed Scenario blocks with optional @tags]\n# END-SCENARIO-PATCH\nNo explanation, no JSON, no Feature: header.'),
        '',
        t('app.aiEditPatchPromptCurrentFileTitle'),
        currentGherkin,
        safetyAppendix,
      ].join('\n');
      const prompt = allowDestructive
        ? `${buildFeatureEditMessage(currentGherkin, trimmed, promptLang)}\n${safetyAppendix}`
        : patchPrompt;
      const systemPrompt = t('app.aiEditSystemPromptDisplay');

      agentActivity.startRun('cucumber', 1);
      agentActivity.updateProgress('cucumber', 0, itemKey, prompt, undefined);

      emitter.emitLocal({
        phase: 'cuc-build-prompt',
        label: getPhaseLabel('cuc-build-prompt', phaseLang),
        summary: t('app.aiEditPreparedSummary', { count: trimmed.length }),
        inputText: prompt,
        itemKey,
      });

      const response = await emitter.emitAiCall(
        {
          phase: 'agent-chat-response',
          label: getPhaseLabel('agent-chat-response', phaseLang),
          agent: 'agent-chat',
          systemPrompt,
          userPrompt: prompt,
          model,
          itemKey,
        },
        async () => {
          const result = await chatWithAgentSync(
            editorAgentApiId,
            prompt,
            'gherkin-generation',
            model,
            'feature-edit',
          );
          return result.response;
        },
      );

      let updated: FeatureInput;
      let editedGherkin: string;
      let appliedScenarioCount: number;

      if (!allowDestructive) {
        const patch = parseScenarioPatchResponse(response);
        const markerMissing = !patch.hasEndMarker;

        // Compatibility fallback: if the model returned a full .feature instead of a patch,
        // accept it only when it is non-destructive.
        if (markerMissing && patch.scenarios.length === 0) {
          const fullCandidate = extractEditedFeatureGherkin(response);
          const parsedFull = parseGherkin(fullCandidate);
          if (parsedFull.scenarios.length > 0) {
            const fullUpdated: FeatureInput = {
              ...editorFeature,
              name: parsedFull.name || editorFeature.name,
              tags: parsedFull.tags.length > 0 ? parsedFull.tags : editorFeature.tags,
              scenarios: parsedFull.scenarios,
            };
            const fullDelta = buildAiEditSafetySummary(editorFeature, fullUpdated);
            if (!fullDelta.hasDestructiveDelta) {
              updated = fullUpdated;
              editedGherkin = generateGherkin(updated);
              appliedScenarioCount = fullDelta.changed.length;
              emitter.emitLocal({
                phase: 'cuc-parse',
                label: getPhaseLabel('cuc-parse', phaseLang),
                summary: t('app.aiEditPatchFallbackSummary'),
                outputText: editedGherkin,
                itemKey,
              });
            } else {
              throw new Error(t('app.aiEditErrorTruncated'));
            }
          } else {
            throw new Error(t('app.aiEditErrorNoValidBlocks'));
          }
        } else {
          if (markerMissing) {
            throw new Error(t('app.aiEditErrorTruncated'));
          }
          if (patch.scenarios.length === 0) {
            throw new Error(t('app.aiEditErrorNoValidBlocks'));
          }

          const patchByName = new Map<string, Scenario>();
          for (const scenario of patch.scenarios) {
            const key = normalizeScenarioName(scenario.name || '');
            if (key) patchByName.set(key, scenario);
          }
          if (patchByName.size === 0) {
            throw new Error(t('app.aiEditErrorNoRecognizableNames'));
          }

          const existingKeys = new Set(editorFeature.scenarios.map((s) => normalizeScenarioName(s.name || '')).filter(Boolean));
          const unknownPatchedNames = Array.from(patchByName.keys()).filter((k) => !existingKeys.has(k));
          if (unknownPatchedNames.length > 0) {
            throw new Error(t('app.aiEditErrorUnknownRenamed', { names: unknownPatchedNames.slice(0, 5).join(', ') }));
          }

          let replaced = 0;
          const mergedScenarios = editorFeature.scenarios.map((scenario) => {
            const key = normalizeScenarioName(scenario.name || '');
            const replacement = patchByName.get(key);
            if (!replacement) return scenario;
            replaced += 1;
            return replacement;
          });

          updated = {
            ...editorFeature,
            scenarios: mergedScenarios,
          };
          editedGherkin = generateGherkin(updated);
          appliedScenarioCount = replaced;
        }
      } else {
        editedGherkin = extractEditedFeatureGherkin(response);
        const parsed = parseGherkin(editedGherkin);
        if (parsed.scenarios.length === 0) {
          throw new Error(t('app.aiEditErrorNoScenarios'));
        }

        updated = {
          ...editorFeature,
          name: parsed.name || editorFeature.name,
          tags: parsed.tags.length > 0 ? parsed.tags : editorFeature.tags,
          scenarios: parsed.scenarios,
        };
        appliedScenarioCount = parsed.scenarios.length;
      }

      const delta = buildAiEditSafetySummary(editorFeature, updated);
      if (!allowDestructive && delta.hasDestructiveDelta) {
        const removedPreview = delta.removedKeys.slice(0, 6).join(', ');
        const changedPreview = delta.changed.slice(0, 6)
          .map((entry) => `${entry.name} (${entry.beforeSteps}→${entry.afterSteps} Steps)`)
          .join(', ');
        const message = [
          t('app.aiEditSafetyContainsDestructive'),
          t('app.aiEditSafetyBeforeAfter', { before: delta.beforeCount, after: delta.afterCount }),
          t('app.aiEditSafetyRemovedRenamed', { count: delta.removedKeys.length, details: removedPreview ? ` (${removedPreview})` : '' }),
          t('app.aiEditSafetyContentChanged', { count: delta.changed.length, details: changedPreview ? ` (${changedPreview})` : '' }),
          '',
          t('app.aiEditSafetyBlocked'),
          t('app.aiEditSafetyRefineHint'),
        ].join('\n');

        setAiEditReview({
          updated,
          title: t('app.aiEditSafetyTitle'),
          message,
          allowApply: false,
        });

        emitter.emitLocal({
          phase: 'cuc-parse',
          label: getPhaseLabel('cuc-parse', phaseLang),
          summary: t('app.aiEditSafetyStopSummary', { count: delta.removedKeys.length }),
          outputText: editedGherkin,
          itemKey,
        });
        agentActivity.completeItem('cucumber', itemKey, false);
        agentActivity.finishRun('cucumber', 'error');
        setAiEditError(t('app.aiEditSafetyStopError'));
        return;
      }

      emitter.emitLocal({
        phase: 'cuc-parse',
        label: getPhaseLabel('cuc-parse', phaseLang),
        summary: t('app.aiEditAppliedSummary', { count: appliedScenarioCount }),
        outputText: editedGherkin,
        itemKey,
      });

      updateEditorFeature(updated);
      setView('editor');
      agentActivity.updateProgress('cucumber', 1, itemKey, prompt, editedGherkin);
      agentActivity.completeItem('cucumber', itemKey, true);
      agentActivity.finishRun('cucumber', 'done');
    } catch (err) {
      agentActivity.completeItem('cucumber', itemKey, false);
      agentActivity.finishRun('cucumber', 'error');
      setAiEditError(err instanceof Error ? err.message : t('app.aiEditUnknownError'));
    } finally {
      setAiEditLoading(false);
    }
  }, [editorAgentApiId, lang, editorFeature, model, updateEditorFeature, agentActivity, hasExplicitDestructiveIntent, buildAiEditSafetySummary, parseScenarioPatchResponse, normalizeScenarioName]);

  // DocxImport "Bearbeiten" → load feature into editor, create file in directory mode
  const handleLoadToEditor = useCallback(async (f: FeatureInput) => {
    if (fileExplorer.isDirectoryMode) {
      // Create a new .feature file in the root and open it
      const fileName = (f.name || t('app.newFeatureFallback')).replace(/[^a-zA-Z0-9äöüÄÖÜß_\- ]/g, '_');
      const newPath = await fileExplorer.createFileWithName('', fileName);
      if (newPath) {
        setFeatures([f]);
        setActiveFeatureIdx(0);
        fileExplorer.saveActiveFile(f);
        fileExplorer.updateTreeForFeature(newPath, f);
        // Expand the file node so scenarios are visible
        fileExplorer.expandNode(newPath);
      }
    } else {
      setFeatures([f]);
      setActiveFeatureIdx(0);
    }
    setView('editor');
  }, [fileExplorer, setFeatures]);

  // Resolve target folder name. Always merges into an existing folder of the same
  // name (GUID-based dedup in writeFeaturePkg overwrites matching files).
  const resolveImportFolder = async (fileName: string): Promise<string | null> => {
    return sanitizeName(fileName);
  };

  // ── EFK Agent management ─────────────────────────────────────

  // EFK agent management removed — Standard-Agent is used for all AI calls

  // DocxImport "KI-Tests generieren" — create top-level folder + agent + import AI-generated tests
  const handleDocxCreateWithAgent = useCallback(async (pkgs: ParsedFeaturePackage[], docxFileName: string, tocInfo?: TocInfo) => {
    const folderName = await resolveImportFolder(docxFileName);
    if (!folderName) return;

    // Import into folder structure — no separate agent needed (Standard-Agent is used)
    const firstPath = await fileExplorer.importPackages(pkgs, '', folderName, tocInfo);

    if (firstPath) {
      // Use the first package's feature directly — selectFile would fail because
      // the tree state hasn't re-rendered yet after importPackages/refreshTree.
      const firstFeature = pkgs[0]?.feature;
      if (firstFeature) {
        setFeatures([firstFeature]);
        setActiveFeatureIdx(0);
      }
      setSelectedFolderPath(folderName);
    }
    setView('editor');
    setPreviewMode('toolbox');
  }, [fileExplorer, model, setFeatures]);

  // Upload .feature files or ZIP
  const featureFileRef = useRef<HTMLInputElement>(null);
  const handleFeatureFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || files.length === 0) return;

    const parsed: FeatureInput[] = [];

    for (const file of Array.from(files)) {
      if (file.name.endsWith('.zip')) {
        const zip = await JSZip.loadAsync(await file.arrayBuffer());
        for (const [name, entry] of Object.entries(zip.files)) {
          if (name.endsWith('.feature') && !entry.dir) {
            const text = await entry.async('string');
            parsed.push(parseGherkin(text));
          }
        }
      } else {
        const text = await file.text();
        parsed.push(parseGherkin(text));
      }
    }

    if (parsed.length > 0) {
      setFeatures(parsed);
      setActiveFeatureIdx(0);
    }

    if (featureFileRef.current) featureFileRef.current.value = '';
  };

  // Download all features as ZIP
  const handleDownloadAllZip = async () => {
    const zip = new JSZip();
    const usedNames = new Set<string>();

    for (const f of features) {
      if (!f.name && f.scenarios.length === 0) continue;

      const text = generateGherkin(f);

      const name = f.name || 'feature';
      let filename = name.toLowerCase().replace(/[^a-z0-9äöü]+/g, '_').replace(/^_|_$/g, '') + '.feature';
      if (usedNames.has(filename)) {
        let counter = 2;
        while (usedNames.has(filename.replace('.feature', `_${counter}.feature`))) counter++;
        filename = filename.replace('.feature', `_${counter}.feature`);
      }
      usedNames.add(filename);
      zip.file(filename, text);
    }

    const blob = await zip.generateAsync({ type: 'blob' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'features.zip';
    a.click();
    URL.revokeObjectURL(url);
  };

  const handleEntryModeSelect = (nextAiEnabled: boolean) => {
    try {
      sessionStorage.setItem(ENTRY_GATE_DONE_SESSION_KEY, 'true');
    } catch {
      // Ignore blocked sessionStorage.
    }

    if (nextAiEnabled === aiEnabled) {
      setEntryGateDone(true);
      return;
    }

    const url = new URL(window.location.href);
    url.searchParams.set('ai', nextAiEnabled ? 'true' : 'false');
    window.location.assign(url.toString());
  };

  // ── Entry gateway (mode selection before any page is shown) ──
  if (!entryGateDone) {
    return (
      <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', background: 'var(--color-bg)', padding: '2rem' }}>
        <div style={{ textAlign: 'center', marginBottom: '2rem' }}>
          <img src={logoUrl} alt="abas Forterro" style={{ height: 48, marginBottom: 12 }} />
          <h1 style={{ fontSize: '1.4rem', fontWeight: 600, margin: 0 }}>{t('app.title')}</h1>
          <p style={{ fontSize: '0.9rem', color: 'var(--color-text-muted)', margin: '8px 0 0' }}>{t('app.entryModeTitle')}</p>
          <p style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)', margin: '4px 0 0' }}>{t('app.entryModeSubtitle')}</p>
        </div>

        <div style={{ width: '100%', maxWidth: 620, display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))', gap: 12 }}>
          <button
            type="button"
            onClick={() => handleEntryModeSelect(true)}
            style={{ textAlign: 'left', border: '1px solid var(--color-border)', borderRadius: 10, background: 'var(--color-surface)', padding: '14px 16px', cursor: 'pointer' }}
          >
            <div style={{ fontWeight: 600, fontSize: '0.95rem' }}>{t('app.entryModeAiTitle')}</div>
            <div style={{ marginTop: 6, fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>{t('app.entryModeAiDesc')}</div>
          </button>

          <button
            type="button"
            onClick={() => handleEntryModeSelect(false)}
            style={{ textAlign: 'left', border: '1px solid var(--color-border)', borderRadius: 10, background: 'var(--color-surface)', padding: '14px 16px', cursor: 'pointer' }}
          >
            <div style={{ fontWeight: 600, fontSize: '0.95rem' }}>{t('app.entryModeLocalTitle')}</div>
            <div style={{ marginTop: 6, fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>{t('app.entryModeLocalDesc')}</div>
          </button>
        </div>
      </div>
    );
  }

  // ── Mandatory shared-settings gate (all modes) ───────────────
  if (sharedSettingsChecking) {
    return (
      <div style={{
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
        height: '100vh', gap: 16, color: 'var(--color-text-muted)',
        fontFamily: 'var(--font-sans)', fontSize: '0.9rem',
      }}>
        <div style={{
          width: 28, height: 28, border: '3px solid var(--color-border)',
          borderTopColor: 'var(--color-primary)', borderRadius: '50%',
          animation: 'spin 0.8s linear infinite',
        }} />
        <div style={{ textAlign: 'center' }}>
          <div>{t('app.sharedSettingsChecking')}</div>
        </div>
        <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
      </div>
    );
  }

  if (!sharedSettingsReady) {
    return (
      <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', background: 'var(--color-bg)', padding: '2rem' }}>
        <div style={{ textAlign: 'center', marginBottom: '2rem' }}>
          <img src={logoUrl} alt="abas Forterro" style={{ height: 48, marginBottom: 12 }} />
          <h1 style={{ fontSize: '1.4rem', fontWeight: 600, margin: 0 }}>{t('app.title')}</h1>
          <p style={{ fontSize: '0.9rem', color: 'var(--color-danger)', margin: '8px 0 0', fontWeight: 600 }}>
            {t('app.sharedSettingsRequiredTitle')}
          </p>
          <p style={{ fontSize: '0.82rem', color: 'var(--color-text-muted)', margin: '8px 0 0', maxWidth: 560 }}>
            {t('app.sharedSettingsRequiredDesc')}
          </p>
        </div>

        {sharedSettingsError && (
          <div style={{ background: 'var(--color-danger)', color: 'white', padding: '8px 16px', fontSize: '0.85rem', borderRadius: 'var(--radius)', marginBottom: '1rem', maxWidth: 560, textAlign: 'center' }}>
            {sharedSettingsError}
          </div>
        )}

        <button
          type="button"
          onClick={() => { void handleChooseSharedSettingsFolderAtStartup(); }}
          style={{
            padding: '10px 18px',
            border: 'none',
            borderRadius: 999,
            background: 'var(--color-accent)',
            color: 'var(--color-text)',
            fontWeight: 700,
            cursor: 'pointer',
          }}
        >
          📁 {t('app.sharedSettingsChooseFolder')}
        </button>
      </div>
    );
  }

  // ── Login screen when not authenticated ──────────────────────
  // Only shown in AI mode — without `?ai=true` the app boots straight
  // into the Baukasten view with no auth prompt.
  if (!loggedIn && aiEnabled) {
    return (
      <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', background: 'var(--color-bg)', padding: '2rem' }}>
        <div style={{ textAlign: 'center', marginBottom: '2rem' }}>
          <img src={logoUrl} alt="abas Forterro" style={{ height: 48, marginBottom: 12 }} />
          <h1 style={{ fontSize: '1.4rem', fontWeight: 600, margin: 0 }}>{t('app.title')}</h1>
          <p style={{ fontSize: '0.85rem', color: 'var(--color-text-muted)', margin: '4px 0 0' }}>{t('app.subtitle')}</p>
        </div>
        {authError && (
          <div style={{ background: 'var(--color-danger)', color: 'white', padding: '8px 16px', fontSize: '0.85rem', borderRadius: 'var(--radius)', marginBottom: '1rem', maxWidth: 480, textAlign: 'center' }}>
            {authError}
          </div>
        )}
        <div style={{ width: '100%', maxWidth: 480 }}>
          <SettingsPanel
            loggedIn={false}
            onLoginChange={setLoggedIn}
            model={model}
            onModelChange={handleModelChange}
            onSharedSettingsChange={() => setSharedSettingsRevision((value) => value + 1)}
            alwaysOpen
          />
        </div>
      </div>
    );
  }

  // ── Main app (authenticated) ────────────────────────────────
  if (appLoading || fopAnalysis.isRestoring) {
    return (
      <div style={{
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
        height: '100vh', gap: 16, color: 'var(--color-text-muted)',
        fontFamily: 'var(--font-sans)', fontSize: '0.9rem',
      }}>
        <div style={{
          width: 28, height: 28, border: '3px solid var(--color-border)',
          borderTopColor: 'var(--color-primary)', borderRadius: '50%',
          animation: 'spin 0.8s linear infinite',
        }} />
        <div style={{ textAlign: 'center' }}>
          <div>{t('app.loadingData')}</div>
          <div style={{ fontSize: '0.75rem', marginTop: 6, opacity: 0.7 }}>
            {appLoading && t('app.loadingVariablesInfosystems')}
            {!appLoading && fopAnalysis.isRestoring && t('app.loadingRestoreFop')}
          </div>
        </div>
        <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
      </div>
    );
  }

  return (
    <>
      <header className={styles.header}>
        <div className={styles.headerInner}>
          <div className={styles.brand}>
            <img src={logoUrl} alt="abas Forterro" className={styles.logo} />
            <div className={styles.titleGroup}>
              <h1 className={styles.title}>{t('app.title')}</h1>
              <p className={styles.subtitle}>{t('app.subtitle')}</p>
            </div>
          </div>
          <nav className={styles.nav}>
            <button
              className={view === 'editor' ? styles.navItemActive : styles.navItem}
              onClick={() => setView('editor')}
              type="button"
            >
              {t('app.editor')}
            </button>
            {aiEnabled && fileExplorer.isDirectoryMode && (
              <button
                className={view === 'docx' ? styles.navItemActive : styles.navItem}
                onClick={() => setView('docx')}
                type="button"
              >
                {t('app.docxImport')}
              </button>
            )}
            {aiEnabled && fileExplorer.isDirectoryMode && (
              <button
                className={view === 'dataimport' ? styles.navItemActive : styles.navItem}
                onClick={() => setView('dataimport')}
                type="button"
              >
                {lang === 'de' ? 'Datenimport' : 'Data Import'}
              </button>
            )}
            <button
              className={view === 'stammdaten' ? styles.navItemActive : styles.navItem}
              onClick={() => { setStammdatenInitialTab('variablen'); setView('stammdaten'); }}
              type="button"
            >
              {t('app.masterData')}
            </button>
            {experimentalFeatures && (
              <button
                className={view === 'reverse' ? styles.navItemActive : styles.navItem}
                onClick={() => setView('reverse')}
                type="button"
                title={`⚗ ${t('app.experimental')}`}
              >
                {t('app.reverseEngineering')} ⚗
              </button>
            )}
          </nav>
          <div className={styles.headerActions}>
            <button
              type="button"
              className={`${styles.modeToggleBtn} ${aiEnabled ? styles.modeToggleBtnOn : styles.modeToggleBtnOff}`}
              onClick={() => handleEntryModeSelect(!aiEnabled)}
              title={t('app.modeToggleTitle')}
              aria-label={aiEnabled ? t('app.modeAiOn') : t('app.modeAiOff')}
            >
              <span className={styles.modeToggleText}>AI</span>
              <span className={styles.modeToggleTrack} aria-hidden="true">
                <span className={styles.modeToggleKnob} />
              </span>
            </button>
            {aiEnabled && (
              <SettingsPanel
                loggedIn={loggedIn}
                onLoginChange={setLoggedIn}
                model={model}
                onModelChange={handleModelChange}
                onSharedSettingsChange={() => setSharedSettingsRevision((value) => value + 1)}
              />
            )}
          </div>
        </div>
      </header>

      {authError && (
        <div style={{ background: 'var(--color-danger)', color: 'white', padding: '8px 16px', fontSize: '0.85rem', textAlign: 'center' }}>
          {authError}
          <button
            onClick={() => setAuthError(null)}
            type="button"
            style={{ marginLeft: '12px', background: 'none', border: '1px solid white', color: 'white', borderRadius: '4px', padding: '2px 8px', cursor: 'pointer' }}
          >
            OK
          </button>
        </div>
      )}

      {/* Agent Status Bar — visible on all tabs. Clicking a chip expands the side panel. */}
      {aiEnabled && (
        <AgentStatusBar
          runs={agentActivity.runs}
          experimentalFeatures={experimentalFeatures}
          lang={lang as 'de' | 'en'}
          onChipClick={() => setSidePanelCollapsed(false)}
        />
      )}

      {/* Workflow diagram — 1:1 mirror of the timeline, collapsible. */}
      {aiEnabled && view !== 'reverse' && (
        <div style={{ borderBottom: '1px solid var(--color-border)', background: 'var(--color-bg)' }}>
          <button
            type="button"
            onClick={() => setWorkflowDiagramExpanded(v => !v)}
            style={{
              display: 'flex', alignItems: 'center', gap: 8,
              width: '100%', padding: '5px 16px',
              background: 'none', border: 'none', cursor: 'pointer',
              fontSize: '0.78rem', color: 'var(--color-text-muted)',
              borderBottom: workflowDiagramExpanded ? '1px solid var(--color-border)' : 'none',
              textAlign: 'left',
            }}
          >
            <span>{workflowDiagramExpanded ? '▾' : '▸'}</span>
            <span style={{ fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.04em', flexShrink: 0 }}>
              {t('app.workflowDiagram')}
            </span>
            <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
              — {(() => {
                let total = 0;
                for (const run of agentActivity.runs.values()) total += run.steps.length;
                return t('app.stepsCount', { count: total });
              })()}
            </span>
          </button>
          {workflowDiagramExpanded && (
            <WorkflowDiagram
              runs={agentActivity.runs as Map<string, import('./types/fop').AgentRun>}
              lang={lang as 'de' | 'en'}
              onStepClick={() => setSidePanelCollapsed(false)}
            />
          )}
        </div>
      )}
      {/* AgentActivityModal removed — timeline is now rendered in the always-visible
          WorkflowSidePanel on the right side of the main layout. */}

      {/* Data status bar — shows what reference data is loaded (all tabs) */}
      <DataStatusBar
        tableDefs={tableDefs}
        fopBindings={fopBindings}
        isBindings={isBindings}
        kbDocumentCount={kbDocuments.length}
        kbChunkCount={kbDocuments.reduce((s, d) => s + d.chunkCount, 0)}
        lang={lang as 'de' | 'en'}
      />

      <div className={styles.app} ref={appRef}>
      <div className={styles.mainsWrapper}>
      {/* Editor view */}
      <main ref={mainRef} className={styles.main} style={{ display: view === 'editor' ? undefined : 'none' }}>
        {/* File Explorer sidebar */}
        {fileExplorer.isVisible && (
          <>
            <aside className={styles.explorerPane} style={{ width: explorerWidth }}>
              <FileExplorer
                tree={fileExplorer.tree}
                activeFilePath={fileExplorer.activeFilePath}
                isLoading={fileExplorer.isLoading}
                isDirectoryMode={fileExplorer.isDirectoryMode}
                isSupported={fileExplorer.isSupported}
                error={fileExplorer.error}
                rootFolderName={fileExplorer.rootFolderName}
                dragOverPath={fileExplorer.dragOverPath}
                onSelectFile={handleExplorerSelectFile}
                onSelectScenario={handleExplorerSelectScenario}
                onToggleNode={fileExplorer.toggleNode}
                onOpenDirectory={fileExplorer.openDirectory}
                onCloseDirectory={() => { fileExplorer.closeDirectory(); setView('editor'); }}
                onRefreshTree={fileExplorer.refreshTree}
                onCreateFolder={handleCreateFolder}
                onDeleteFolder={handleDeleteFolder}
                onCreateFile={handleExplorerCreateFile}
                onDeleteFile={handleDeleteFile}
                onDuplicateFile={handleDuplicateFile}
                onDeleteFiles={handleDeleteFiles}
                onMoveFile={fileExplorer.moveEntry}
                onRenameEntry={fileExplorer.renameEntry}
                onSetDragOverPath={fileExplorer.setDragOverPath}
                onDeselectFile={fileExplorer.deselectFile}
                onFolderSelect={setSelectedFolderPath}
                errorPaths={errorPaths}
                activeScenarioPath={focusScenario && fileExplorer.activeFilePath ? `${fileExplorer.activeFilePath}#${focusScenario.id}` : null}
                recentWorkspaces={fileExplorer.recentWorkspaces}
                onSwitchWorkspace={fileExplorer.switchWorkspace}
              />
            </aside>
            <div className={styles.explorerDivider} onMouseDown={handleExplorerDividerMouseDown} />
          </>
        )}

        <section className={styles.formPane} style={{ width: `${splitPercent}%` }}>
          <div className={styles.formToolbar}>
            {fileExplorer.isSupported && (
              <button
                className={fileExplorer.isVisible ? styles.explorerToggleBtnActive : styles.explorerToggleBtn}
                onClick={fileExplorer.toggleExplorer}
                type="button"
                title="Explorer (Ctrl+B)"
              >
                📁
              </button>
            )}
            {isTemplateEditing && (
              <div className={styles.templateModeBadge}>
                <span className={styles.templateModeLabel}>{t('action.templateEditorLabel')}</span>
                <span className={styles.templateModeName}>{templateEditingName || t('action.templateNew')}</span>
                <button
                  className={styles.templateModeClose}
                  onClick={closeTemplateEditor}
                  type="button"
                >
                  {t('action.templateCloseEditor')}
                </button>
              </div>
            )}
            {/* Undo/Redo and reset only when a file is open */}
            {fileExplorer.activeFilePath && !isTemplateEditing && (
              <>
                <div className={styles.undoRedo}>
                  <button
                    className={styles.undoBtn}
                    onClick={undo}
                    disabled={!canUndo}
                    type="button"
                    title={t('app.undo')}
                  >
                    &#x21A9;
                  </button>
                  <button
                    className={styles.undoBtn}
                    onClick={redo}
                    disabled={!canRedo}
                    type="button"
                    title={t('app.redo')}
                  >
                    &#x21AA;
                  </button>
                  <button
                    className={styles.resetBtn}
                    onClick={() => {
                      setShowResetConfirm(true);
                    }}
                    type="button"
                    title={t('app.resetAll')}
                  >
                    {t('app.resetAll')}
                  </button>
                </div>
              </>
            )}
            <input
              ref={featureFileRef}
              type="file"
              accept=".feature,.zip"
              multiple
              onChange={handleFeatureFileChange}
              style={{ display: 'none' }}
            />
          </div>

          {/* No folder or no file selected: show placeholder */}
          {!fileExplorer.activeFilePath && !isTemplateEditing ? (
            <div className={styles.editorPlaceholder}>
              <div className={styles.editorPlaceholderIcon}>{fileExplorer.isDirectoryMode ? '📄' : '📂'}</div>
              <div className={styles.editorPlaceholderText}>
                {!fileExplorer.isDirectoryMode
                  ? t('app.editorPlaceholderOpenFolder')
                  : fileExplorer.isVisible
                    ? t('app.editorPlaceholderSelectFile')
                    : t('app.editorPlaceholderShowExplorer')}
              </div>
            </div>
          ) : (
            <>
              <FeatureForm
                feature={editorFeature}
                onChange={updateEditorFeature}
                showGenerate={!isTemplateEditing && loggedIn && !!editorAgentApiId}
                onGenerate={handleGenerate}
                generating={loading}
                generationStep={generationStep}
                generateError={!editorAgentApiId && loggedIn ? t('app.noAgentAvailableExplain') : error}
                tables={tableDefs}
                aiRating={aiRating}
                standaloneAiRating={standaloneAiRating}
                onRequestRating={editorAgentApiId ? handleRequestRating : undefined}
                ratingLoading={ratingLoading}
                ratingError={ratingError}
                onApplyAiEdit={!isTemplateEditing && loggedIn && !!editorAgentApiId ? handleApplyAiEdit : undefined}
                aiEditLoading={aiEditLoading}
                aiEditError={aiEditError}
                focusScenarioId={focusScenario ? `${focusScenario.id}::${focusScenario.ts}` : null}
              />
            </>
          )}
        </section>

        <div className={styles.divider} onMouseDown={handleDividerMouseDown} />

        <section className={styles.previewPane}>
          <div className={styles.previewHeader}>
            <div className={styles.previewToggle}>
              <button
                className={previewMode === 'toolbox' ? styles.previewToggleActive : styles.previewToggleBtn}
                onClick={() => setPreviewMode('toolbox')}
                type="button"
              >
                {t('app.toolbox')}
              </button>
              <button
                className={previewMode === 'text' ? styles.previewToggleActive : styles.previewToggleBtn}
                onClick={() => setPreviewMode('text')}
                type="button"
              >
                {t('app.text')}
              </button>
              <button
                className={previewMode === 'diagram' ? styles.previewToggleActive : styles.previewToggleBtn}
                onClick={() => setPreviewMode('diagram')}
                type="button"
              >
                {t('app.diagram')}
              </button>

            </div>
            {features.length > 1 && (
              <ActionBar
                showZip={features.length > 1}
                onDownloadZip={handleDownloadAllZip}
              />
            )}
          </div>
          {effectivePreviewMode === 'toolbox' && (
            <StepToolbox
              feature={editorFeature}
              onStartTemplateEdit={startTemplateEditor}
              onTemplateSaved={handleTemplateSaved}
              onCloseTemplateEditor={closeTemplateEditor}
              templateEditingName={templateEditingName}
              templateEditingId={templateEditingId}
              isTemplateDirty={isTemplateDirty}
              templateSaveTick={templateSaveTick}
            />
          )}
          {effectivePreviewMode === 'text' && (
            <GherkinPreview gherkin={gherkin} lineMapping={lineMapping} onStepClick={handleStepClick} />
          )}
          {effectivePreviewMode === 'diagram' && (
            <FlowDiagram scenarios={feature.scenarios} onStepClick={handleStepClick} />
          )}
        </section>
      </main>

      {/* Reverse Engineering view — experimental, full viewport width */}
      {experimentalFeatures && view === 'reverse' && (
        <main style={{
          display: 'flex',
          flexDirection: 'column',
          height: 'calc(100vh - 56px - 36px)',
          overflow: 'hidden',
          width: '100%',
          maxWidth: '100%',
          margin: 0,
          padding: 0,
          boxSizing: 'border-box',
        }}>
          {/* Workflow diagram — single unified view driven by the timeline. */}
          <div style={{ borderBottom: '1px solid var(--color-border)', flexShrink: 0 }}>
            <button
              type="button"
              onClick={() => setWorkflowDiagramExpanded(v => !v)}
              style={{
                display: 'flex', alignItems: 'center', gap: 8,
                width: '100%', padding: '5px 16px',
                background: 'none', border: 'none', cursor: 'pointer',
                fontSize: '0.78rem', color: 'var(--color-text-muted)',
                borderBottom: workflowDiagramExpanded ? '1px solid var(--color-border)' : 'none',
                textAlign: 'left',
              }}
            >
              <span>{workflowDiagramExpanded ? '▾' : '▸'}</span>
              <span style={{ fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.04em' }}>
                {t('app.workflowDiagram')}
              </span>
              <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                — {(() => {
                  let total = 0;
                  for (const run of agentActivity.runs.values()) total += run.steps.length;
                  return t('app.stepsCount', { count: total });
                })()}
              </span>
            </button>
            {workflowDiagramExpanded && (
              <WorkflowDiagram
                runs={agentActivity.runs as Map<string, import('./types/fop').AgentRun>}
                lang={lang as 'de' | 'en'}
                onStepClick={() => setSidePanelCollapsed(false)}
              />
            )}
          </div>
          {/* FOP folder header bar */}
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '6px 12px', borderBottom: '1px solid var(--color-border)', flexShrink: 0, fontSize: '0.8rem' }}>
            {fopAnalysis.rootDir ? (
              <>
                <span>📁 {fopAnalysis.rootDir.name}</span>
                <span style={{ color: 'var(--color-text-muted)', fontSize: '0.72rem' }}>{fopAnalysis.fopFiles.length} FOPs</span>
                <button type="button" onClick={() => fopAnalysis.loadDirectory(fopAnalysis.rootDir!)} style={{ background: 'none', border: '1px solid var(--color-border)', borderRadius: 4, padding: '1px 6px', cursor: 'pointer', fontSize: '0.72rem' }} title={t('app.reload')}>⟳</button>
                <button type="button" onClick={fopAnalysis.closeDirectory} style={{ background: 'none', border: '1px solid var(--color-border)', borderRadius: 4, padding: '1px 6px', cursor: 'pointer', fontSize: '0.72rem' }} title={t('app.removeFolder')}>✕</button>
                <span style={{ flex: 1 }} />
              </>
            ) : (
              <>
                <button
                  type="button"
                  onClick={async () => {
                    if (!window.showDirectoryPicker) return;
                    try {
                      const dirHandle = await window.showDirectoryPicker({ mode: 'readwrite' });
                      fopAnalysis.loadDirectory(dirHandle);
                    } catch { /* cancelled */ }
                  }}
                  style={{ padding: '4px 12px', border: '1.5px solid var(--color-primary)', borderRadius: 6, background: 'none', color: 'var(--color-primary)', cursor: 'pointer', fontWeight: 500 }}
                >
                  📁 {t('app.openFopFolder')}
                </button>
                {fileExplorer.rootHandle && (
                  <button
                    type="button"
                    onClick={() => fopAnalysis.loadDirectory(fileExplorer.rootHandle!)}
                    style={{ padding: '4px 12px', border: '1px solid var(--color-border)', borderRadius: 6, background: 'none', cursor: 'pointer', fontSize: '0.75rem' }}
                  >
                    ← {t('app.fromExplorer')}
                  </button>
                )}
              </>
            )}
            <button
              type="button"
              onClick={() => { setStammdatenInitialTab('learning'); setView('stammdaten'); }}
              style={{ marginLeft: 'auto', padding: '4px 10px', border: '1px solid var(--color-border)', borderRadius: 6, background: 'none', cursor: 'pointer', fontSize: '0.75rem' }}
              title={t('app.openLearningDashboard')}
            >
              🧠 {t('app.learnings')}
            </button>
          </div>
          {/* Loading bar */}
          {fopAnalysis.isLoading && (
            <div style={{ height: 3, background: 'var(--color-bg)', overflow: 'hidden', flexShrink: 0 }}>
              <div style={{ height: '100%', width: '40%', background: 'var(--color-primary)', borderRadius: 2, animation: 'fopLoadSlide 1s ease-in-out infinite' }} />
              <style>{`@keyframes fopLoadSlide { 0% { transform: translateX(-100%); } 100% { transform: translateX(350%); } }`}</style>
            </div>
          )}
          {/* Two panels: 1/3 FopTree + 2/3 AnalysisPanel */}
          <div style={{ display: 'flex', flex: 1, overflow: 'hidden' }}>
          <div style={{ width: fopMidWidth, flexShrink: 0, overflow: 'hidden' }}>
          <FopTree
            roots={fopAnalysis.treeRoots}
            usageIndex={fopAnalysis.usageIndex}
            selectedPath={fopAnalysis.selectedFopPath}
            onSelectFop={fopAnalysis.selectFop}
            viewMode={fopTreeViewMode}
            onViewModeChange={setFopTreeViewMode}
            bindings={fopAnalysis.bindings}
            isBindings={isBindings}
            allFopPaths={fopAnalysis.fopFiles.map(f => f.relativePath)}
            existingGuids={existingFeatureGuids}
            analyzedPaths={new Set(Array.from(fopAnalysis.analyses?.keys?.() ?? []))}
            varTables={tableDefs}
            lang={lang as 'de' | 'en'}
          />
          </div>
          <div
            className={styles.resizeHandle}
            onMouseDown={(e) => {
              e.preventDefault();
              const startX = e.clientX;
              const startW = fopMidWidth;
              const onMove = (ev: MouseEvent) => setFopMidWidth(Math.max(250, Math.min(Math.round(window.innerWidth * 0.6), startW + ev.clientX - startX)));
              const onUp = () => { document.removeEventListener('mousemove', onMove); document.removeEventListener('mouseup', onUp); };
              document.addEventListener('mousemove', onMove);
              document.addEventListener('mouseup', onUp);
            }}
          />
          <div style={{ flex: 1, overflow: 'hidden' }}>
          <AnalysisPanel
            analysis={fopAnalysis.getSelectedAnalysis()}
            usage={fopAnalysis.getSelectedUsage()}
            selectedPath={fopAnalysis.selectedFopPath}
            isAnalyzing={fopAnalysis.isAnalyzing}
            onAnalyze={fopAnalysis.selectedFopPath ? (forceRefresh?: boolean) => {
              // Reset everything and start fresh
              processFlow.startFlow('fop');
              processFlow.activateStep('fop-parse');
              agentActivity.clearRun('fop-analyst');
              agentActivity.clearRun('fop-guidelines');
              fopAnalysis.analyzeSelection([fopAnalysis.selectedFopPath!], forceRefresh);
            } : undefined}
            fopFile={fopAnalysis.selectedFopPath
              ? fopAnalysis.fopFiles.find(f => f.relativePath === fopAnalysis.selectedFopPath)
                ?? fopAnalysis.fopFiles.find(f => {
                  // Fallback: match by filename (binding paths differ from file system paths)
                  const selName = fopAnalysis.selectedFopPath!.split('/').pop()?.toLowerCase();
                  const fName = f.relativePath.split('/').pop()?.toLowerCase();
                  return selName && fName && (fName === selName || fName.includes(selName) || selName.includes(fName));
                })
                ?? null
              : null}
            onGenerateCucumber={async () => {
              const { getTestDepth } = await import('./lib/settings');
              const testDepth = getTestDepth();
              console.log('[GenerateTests] testDepth:', testDepth);
              const analysis = fopAnalysis.getSelectedAnalysis();
              if (!analysis) return;

              // If tests already exist, write them to file
              if (analysis.cucumberTests?.length && fopAnalysis.rootDir) {
                const { writeFeatureTest } = await import('./lib/fopCache');
                const gherkin = analysis.cucumberTests.map(f => generateGherkin(f)).join('\n\n');
                if (gherkin) {
                  const safeName = (analysis.fopPath.split('/').pop() ?? 'test').replace(/[^a-zA-Z0-9_-]/g, '_');
                  await writeFeatureTest(fopAnalysis.rootDir, safeName, gherkin);
                }
                return;
              }

              // No tests yet — generate via Cucumber flow (same pipeline as Konzept-Import)
              const fopName = analysis.fopPath.split('/').pop() ?? 'FOP';
              try {
                // Start agent activity + cucumber flow
                agentActivity.startRun('cucumber', 1);
                cucumberFlow.startFlow('cucumber');
                cucumberFlow.activateStep('read-ap');
                cucumberFlow.addItemsToStep('read-ap', [{
                  name: fopName,
                  path: 'local',
                  input: analysis.humanDescription.summary,
                  inputLabel: 'Beschreibung',
                }]);
                cucumberFlow.completeStep('read-ap');

                const { generateCucumberFromFopAnalysis } = await import('./lib/fopOrchestrator');
                const fopFile = fopAnalysis.fopFiles.find(f => f.relativePath === analysis.fopPath);
                if (!fopFile) return;

                // Build the description as input for Agent Monitor
                const descForAgent = [
                  analysis.humanDescription.summary,
                  analysis.technicalDescription.summary,
                  analysis.technicalDescription.dataFlow,
                ].filter(Boolean).join('\n\n');
                agentActivity.updateProgress('cucumber', 0, fopName, descForAgent, undefined);

                // Mark branch as active (will stay active — we don't complete it so only the correct edge turns green)

                const tests = await generateCucumberFromFopAnalysis(
                  fopFile, analysis, fopAnalysis.bindings, tableDefs, model, lang as 'de' | 'en',
                  { testDepth,
                    emitter: agentActivity.getEmitter('fop-cucumber'),
                    onTablesIdentified: (info) => {
                      // Step: Tables identified → complete branch + table step
                      const tableStep = info.path === 'local' ? 'local-tables' : 'ki-tables';
                      cucumberFlow.activateStep(tableStep);
                      cucumberFlow.addItemsToStep(tableStep, [{
                        name: fopName, path: info.path,
                        detail: `${info.tables.length} Tabellen, ${info.fieldCount} Felder`,
                        subItems: info.tables,
                      }]);
                      cucumberFlow.completeStep(tableStep);
                    },
                    onPromptBuilt: (_prompt) => {
                      cucumberFlow.activateStep('build-prompt');
                      cucumberFlow.completeStep('build-prompt');
                      cucumberFlow.activateStep('gen-gherkin');
                    },
                    maxRounds: (await import('./lib/settings')).getDeepTestMaxRounds(),
                  },
                  isBindings,
                );

                if (tests.length > 0) {
                  const updated = { ...analysis, cucumberTests: tests };
                  fopAnalysis.updateAnalysis(analysis.fopPath, updated);
                  const { generateGherkin: genGherkin } = await import('./lib/generator');
                  const gherkinOutput = tests.map(f => genGherkin(f)).join('\n\n');
                  agentActivity.updateProgress('cucumber', 1, fopName, descForAgent, gherkinOutput);
                  agentActivity.completeItem('cucumber', fopName, true);
                  agentActivity.finishRun('cucumber', 'done');
                  cucumberFlow.completeStep('gen-gherkin');
                  cucumberFlow.completeStep('result-ok');
                } else {
                  agentActivity.finishRun('cucumber', 'error');
                  cucumberFlow.completeStep('gen-gherkin');
                  cucumberFlow.completeStep('result-err');
                }
              } catch (err) {
                console.error('[GenerateCucumber] failed:', err);
                agentActivity.finishRun('cucumber', 'error');
                cucumberFlow.completeStep('result-err');
              }
            }}
            onExportToEditor={async () => {
              const analysis = fopAnalysis.getSelectedAnalysis();
              console.log('[ExportToEditor]', { hasAnalysis: !!analysis, tests: analysis?.cucumberTests?.length ?? 0, scenarios: analysis?.cucumberTests?.[0]?.scenarios?.length });
              if (!analysis?.cucumberTests?.length) return;
              // Build description from analysis results (fachlich + technisch)
              const descParts: string[] = [];
              descParts.push(analysis.humanDescription.summary);
              if (analysis.humanDescription.useCases.length > 0) {
                descParts.push('');
                descParts.push(...analysis.humanDescription.useCases.map(u => `- ${u}`));
              }
              if (analysis.technicalDescription.summary) {
                descParts.push('');
                descParts.push(`Technisch: ${analysis.technicalDescription.summary}`);
              }
              if (analysis.technicalDescription.dataFlow) {
                descParts.push('');
                descParts.push(`Datenfluss: ${analysis.technicalDescription.dataFlow}`);
              }
              if (analysis.technicalDescription.eventDescriptions) {
                const events = Object.entries(analysis.technicalDescription.eventDescriptions);
                if (events.length > 0) {
                  descParts.push('');
                  descParts.push('Events:');
                  events.forEach(([evt, desc]) => descParts.push(`- ${evt}: ${desc}`));
                }
              }
              if (analysis.technicalDescription.sideEffects?.length) {
                descParts.push('');
                descParts.push(`Seiteneffekte: ${analysis.technicalDescription.sideEffects.join('; ')}`);
              }
              const description = descParts.join('\n');
              // Load tests into the Editor tab — replace existing with same GUID
              const { makeFopGuid } = await import('./lib/featureGuid');
              const fopGuid = makeFopGuid(analysis.fopPath);
              const guidTag = `@guid-${fopGuid}`;

              const newFeatures = analysis.cucumberTests!.map(f => ({
                ...f,
                name: f.name || analysis.fopPath.split('/').pop() || 'FOP Test',
                description: f.description || description,
                tags: f.tags.includes(guidTag) ? f.tags : [guidTag, ...f.tags],
              }));
              console.log('[ExportToEditor] setting features:', newFeatures.length, 'with', newFeatures[0]?.scenarios?.length, 'scenarios', '| directoryMode:', fileExplorer.isDirectoryMode);

              if (fileExplorer.isDirectoryMode && fileExplorer.rootHandle) {
                // Directory mode: write .feature file to disk, refresh explorer, select file
                const { generateGherkin: genGherkin } = await import('./lib/generator');
                const gherkin = newFeatures.map(f => genGherkin(f)).join('\n\n');
                const safeName = (analysis.fopPath.split('/').pop() ?? 'test').replace(/[^a-zA-Z0-9_-]/g, '_');
                const fileName = `${safeName}.feature`;
                try {
                  const fileHandle = await fileExplorer.rootHandle.getFileHandle(fileName, { create: true });
                  const writable = await fileHandle.createWritable();
                  await writable.write(gherkin);
                  await writable.close();
                  console.log('[ExportToEditor] wrote file:', fileName);
                  // Refresh tree to show the new file, then select it
                  await fileExplorer.refreshTree();
                  setView('editor');
                  // Wait for React to render the new tree, then select the file
                  setTimeout(() => {
                    fileExplorer.selectFile(fileName).catch(() => {});
                  }, 200);
                  return; // skip setView below
                } catch (err) {
                  console.error('[ExportToEditor] write failed:', err);
                }
              } else {
                // No directory: set in-memory features
                setFeatures(prev => {
                  if (prev.length === 1 && prev[0].scenarios.length === 0) return newFeatures;
                  const existingGuids = new Set(newFeatures.flatMap(f => f.tags).filter(t => /^@[0-9a-f]{16}$/.test(t)));
                  const kept = prev.filter(f => !f.tags.some(t => existingGuids.has(t)));
                  return [...kept, ...newFeatures];
                });
              }
              setActiveFeatureIdx(0);
              setView('editor');
            }}
            onExportDocs={async () => {
              const analysis = fopAnalysis.getSelectedAnalysis();
              if (!analysis || !fopAnalysis.rootDir) return;
              const { writeKonzeptDoc } = await import('./lib/fopCache');
              const lines = [
                `# ${analysis.fopPath}`,
                '',
                `## ${t('app.exportBusinessHeading')}`,
                analysis.humanDescription.summary,
                '',
                ...(analysis.humanDescription.useCases.length > 0 ? [
                  `### ${t('app.exportUseCasesHeading')}`,
                  ...analysis.humanDescription.useCases.map(u => `- ${u}`),
                  '',
                ] : []),
                `## ${t('app.exportTechnicalHeading')}`,
                analysis.technicalDescription.summary,
                '',
                `## ${t('app.exportGuidelinesHeading')}: ${analysis.guidelines.score}`,
                ...analysis.guidelines.findings.map(f => `- [${f.severity.toUpperCase()}] Z.${f.line}: ${f.message}`),
              ];
              const safeName = (analysis.fopPath.split('/').pop() ?? 'analyse').replace(/[^a-zA-Z0-9_-]/g, '_');
              await writeKonzeptDoc(fopAnalysis.rootDir, safeName, lines.join('\n'));
            }}
            lang={lang as 'de' | 'en'}
          />
          </div>
          </div>
        </main>
      )}

      {/* Stammdaten view */}
      {view === 'stammdaten' && (
        <main style={{ height: 'calc(100vh - 56px - 36px - 28px)', overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>
          <StammdatenView
            tableDefs={tableDefs}
            onTablesChange={handleTablesChange}
            fopBindings={fopBindings}
            onFopBindingsChange={setFopBindings}
            isBindings={isBindings}
            onIsBindingsChange={setIsBindings}
            kbDocuments={kbDocuments}
            onKBDocumentsChange={setKbDocuments}
            rootHandle={fileExplorer.rootHandle}
            onLearningsChanged={(entries) => {
              setWorkspaceLearnings(entries);
            }}
            learningAgentApiId={editorAgentApiId}
            learningModel={model}
            initialTab={stammdatenInitialTab}
            lang={lang as 'de' | 'en'}
          />
        </main>
      )}

      {/* Docx Import view */}
      <main style={{ display: view === 'docx' ? undefined : 'none' }}>
        <DocxImport
          onLoadToEditor={handleLoadToEditor}
          model={model}
          learningHints={workspaceConceptLearningHints}
          tables={tableDefs}
          onTablesChange={handleTablesChange}
          showAi={aiEnabled}
          agentApiId={editorAgentApiId}
          rootHandle={fileExplorer.rootHandle}
          onCreateWithAgent={aiEnabled ? handleDocxCreateWithAgent : undefined}
          existingFeatureGuids={existingFeatureGuids}
          getBulkEmitter={() => agentActivity.getEmitter('cucumber')}
          onBulkActivityChange={(info) => {
            console.log('[ProcessFlow-Bulk]', {
              phase: info.current === 0 ? 'FLOW_START' : info.identifiedTables !== undefined ? 'AP_COMPLETED' : !info.outputSoFar ? 'AP_STARTING' : 'AP_STREAMING',
              current: info.current, total: info.total, item: info.currentItem,
              tableIdPath: info.tableIdPath,
              identifiedTables: info.identifiedTables,
              fieldCount: info.fieldCount,
              hasGherkinRequest: !!info.gherkinRequest,
              gherkinRequestLen: info.gherkinRequest?.length,
              gherkinRequestPreview: info.gherkinRequest?.slice(0, 200),
              hasOutput: !!info.outputSoFar,
              outputLen: info.outputSoFar?.length,
            });
            if (info.isRunning) {
              if ((info as { promptUpdate?: boolean }).promptUpdate) {
                // Prompt built — update Agent Modal with real gherkinRequest before API call
                console.log('[ProcessFlow-Bulk] → promptUpdate:', info.currentItem, '| len:', info.inputSnapshot?.length);
                agentActivity.updateProgress('cucumber', info.current, info.currentItem, info.inputSnapshot, undefined);
              } else if ((info as { tableIdStarted?: boolean }).tableIdStarted) {
                // Table ID request just sent — show in Agent Modal immediately (before KI responds)
                console.log('[ProcessFlow-Bulk] → tableIdStarted:', info.currentItem);
                agentActivity.addExchange(
                  'cucumber',
                  t('app.tableIdentification'),
                  info.tableIdRequest || '(Anfrage)',
                );
              } else if ((info as { tablesIdentified?: boolean }).tablesIdentified) {
                // Tables just identified (before Gherkin generation) — update diagram + agent modal immediately
                const tPath = info.tableIdPath === 'local' ? 'local-tables' : 'ki-tables';
                console.log('[ProcessFlow-Bulk] → tablesIdentified:', info.currentItem, '| path:', tPath, '| tables:', info.identifiedTables);
                processFlow.updateLastItem(tPath, {
                  path: info.tableIdPath === 'local' ? 'local' : 'ki',
                  detail: `${info.identifiedTables?.length ?? 0} Tabellen, ${info.fieldCount ?? 0} Felder`,
                  subItems: info.identifiedTables,
                  input: info.tableIdRequest,
                  inputLabel: info.tableIdPath === 'ki' ? 'KI-Anfrage' : 'Erkennung',
                  output: info.tableIdRawResponse,
                  outputLabel: info.tableIdPath === 'ki' ? 'KI-Antwort' : 'Ergebnis',
                });
                processFlow.completeStep(tPath);
                processFlow.completeStep('build-prompt');
                processFlow.activateStep('gen-gherkin');
                // Update the pending table ID exchange with the KI response
                if (info.tableIdPath === 'ki' && info.tableIdRawResponse) {
                  agentActivity.updateLastExchange('cucumber', info.tableIdRawResponse);
                }
              } else if (info.current === 0) {
                // Flow start
                console.log('[ProcessFlow-Bulk] → startFlow("cucumber")');
                agentActivity.startRun('cucumber', info.total);
                processFlow.startFlow('cucumber');
              } else if (info.identifiedTables !== undefined) {
                // AP completed — update with actual table detection results
                console.log('[ProcessFlow-Bulk] → AP completed:', info.currentItem, '| tables:', info.identifiedTables, '| gherkinRequest:', info.gherkinRequest?.slice(0, 150) + '...');
                // Build readable combined prompt: requirements + table fields
                const reqText = (info.inputSnapshot || info.currentItem).replace(/^\*\*[^*]+\*\*\n\n/, '');
                const combinedPrompt = info.tableContext
                  ? `── Anforderungstext ──\n${reqText}\n\n── Tabellenfelder (${info.identifiedTables.length} Tabellen, ${info.fieldCount ?? 0} Felder) ──\n${info.tableContext}`
                  : reqText;
                console.log('[Agent-Input-Update]', {
                  item: info.currentItem,
                  hasTableContext: !!info.tableContext,
                  tableContextLen: info.tableContext?.length,
                  combinedLen: combinedPrompt.length,
                });
                agentActivity.updateProgress('cucumber', info.current, info.currentItem, info.gherkinRequest || combinedPrompt, info.outputSoFar);
                if (info.outputSoFar) agentActivity.completeItem('cucumber', info.currentItem, true);
                {
                  const actualApTableStep = (info.tableIdPath === 'local') ? 'local-tables' : 'ki-tables';
                  const actualApPath = (info.tableIdPath === 'local') ? 'local' as const : 'ki' as const;
                  const apText2 = info.inputSnapshot ?? info.currentItem;
                  const wasPremarkedLocal = tableDefs.length > 0 && /(?:V-?\d+-\d+|P\d+:\d+)\b/i.test(apText2);

                  if (actualApTableStep !== (wasPremarkedLocal ? 'local-tables' : 'ki-tables')) {
                    // Wrong step was pre-marked: reset and switch
                    processFlow.resetStep(wasPremarkedLocal ? 'local-tables' : 'ki-tables');
                    processFlow.addItemsToStep(actualApTableStep, [{ name: info.currentItem, path: actualApPath }]);
                  }

                  if (actualApTableStep === 'ki-tables') {
                    // KI path: update with actual results (local was already completed immediately)
                    // Build combined output: KI raw response + formatted table fields
                    const kiTableOutput = [
                      info.tableIdRawResponse || '(keine Ergebnisse)',
                      info.tableContext ? `\n\n── Tabellenfelder ──\n${info.tableContext}` : '',
                    ].join('');
                    processFlow.updateLastItem('ki-tables', {
                      path: actualApPath,
                      detail: `${info.identifiedTables.length} Tabellen, ${info.fieldCount ?? 0} Felder`,
                      subItems: info.identifiedTables,
                      input: info.tableIdRequest || '(KI-Anfrage)',
                      inputLabel: 'KI-Anfrage',
                      output: kiTableOutput,
                      outputLabel: 'Tabellenfelder',
                    });
                    processFlow.completeStep('ki-tables');
                  }
                  // local-tables is already completed from the AP-start block
                }

                // Update build-prompt with actual gherkinRequest (table contexts + generation request)
                processFlow.updateLastItem('build-prompt', {
                  detail: `${info.identifiedTables.length} Tabellen, ${info.fieldCount ?? 0} Felder`,
                  subItems: info.identifiedTables,
                });
                processFlow.completeStep('build-prompt');

                // Update gen-gherkin with full prompt (same as "Prompt aufbauen") + response
                processFlow.updateLastItem('gen-gherkin', {
                  input: info.gherkinRequest || combinedPrompt,
                  inputLabel: 'Prompt an KI',
                  output: info.outputSoFar,
                  outputLabel: 'KI-Antwort',
                  detail: info.outputSoFar ? `${info.outputSoFar.length} Zeichen` : undefined,
                });
                processFlow.completeStep('gen-gherkin');

                processFlow.addItemsToStep('result-ok', [{ name: info.currentItem, path: 'local' }]);
              } else if (!info.outputSoFar) {
                // New AP starting — detect local vs KI from the input text
                const apText = info.inputSnapshot ?? info.currentItem;
                const rawReqText = apText.replace(/^\*\*[^*]+\*\*\n\n/, '');
                const forceKi = getForceKiTableId();
                const apHasVNotation = !forceKi && tableDefs.length > 0 &&
                  /(?:V-?\d+-\d+|P\d+:\d+)\b/i.test(apText);
                const apTableStep = apHasVNotation ? 'local-tables' : 'ki-tables';
                console.log('[ProcessFlow-Bulk] AP_STARTING table detection:', { forceKi, apHasVNotation, apTableStep });

                // Build combined prompt for Agent Modal right away (not just after AP completion)
                let earlyAgentInput = rawReqText;

                processFlow.activateStep('read-ap');
                processFlow.addItemsToStep('read-ap', [{ name: info.currentItem, path: 'local' }]);
                processFlow.activateStep('branch-tables');
                processFlow.activateStep(apTableStep);

                if (apHasVNotation) {
                  // LOCAL detection — compute result immediately (same logic as generatePackage)
                  const refMatches = Array.from(apText.matchAll(/(?:V-?(\d+)-(\d+)|P(\d+:\d+))\b/gi));
                  const localRefs = new Set<string>();
                  for (const m of refMatches) {
                    if (m[1] && m[2]) localRefs.add(`${parseInt(m[1], 10)}:${parseInt(m[2], 10)}`);
                    else if (m[3]) localRefs.add(m[3]);
                  }
                  const matchedTables = tableDefs.filter(t => localRefs.has(t.tableRef));
                  const apFieldCount = matchedTables.reduce((s, t) => s + t.fields.length, 0);
                  const matchLines = Array.from(localRefs).map(ref => {
                    const m = matchedTables.find(t => t.tableRef === ref);
                    return m ? `${ref} → ${m.name || m.tableRef} (${ref})` : `${ref} → (nicht in Variablentabellen)`;
                  });
                  const localTableContext = matchedTables.length > 0
                    ? matchedTables.map(t => formatSingleTableContext(t, apText)).join('\n\n')
                    : '(keine Treffer in Variablentabellen)';

                  // Set combined prompt with table fields IMMEDIATELY for Agent Modal
                  if (matchedTables.length > 0) {
                    earlyAgentInput = `── Anforderungstext ──\n${rawReqText}\n\n── Tabellenfelder (${matchedTables.length} Tabellen, ${apFieldCount} Felder) ──\n${localTableContext}`;
                  }

                  processFlow.addItemsToStep('local-tables', [{
                    name: info.currentItem,
                    path: 'local',
                    detail: `${matchedTables.length} Tabellen, ${apFieldCount} Felder`,
                    subItems: matchedTables.map(t => `${t.name || t.tableRef} (${t.tableRef})`),
                    input: `Im Text erkannte V/P-Notation:\n${matchLines.join('\n')}`,
                    inputLabel: 'Erkennung',
                    output: localTableContext,
                    outputLabel: 'Tabellenfelder',
                  }]);
                  processFlow.completeStep('local-tables'); // Done immediately — no KI needed
                } else {
                  // KI path — placeholder, updated after generateViaAgent completes
                  processFlow.addItemsToStep('ki-tables', [{
                    name: info.currentItem,
                    path: 'ki',
                    input: '(KI identifiziert Tabellen aus Anforderungstext)',
                  }]);
                }
                processFlow.activateStep('build-prompt');
                // Build-prompt: AP-Text als Input vormerken
                processFlow.addItemsToStep('build-prompt', [{
                  name: info.currentItem, path: 'local',
                  input: (info.inputSnapshot || info.currentItem).replace(/^\*\*[^*]+\*\*\n\n/, ''),
                  inputLabel: 'Anforderungstext',
                  outputLabel: 'Prompt an KI',
                }]);
                processFlow.activateStep('gen-gherkin');
                processFlow.addItemsToStep('gen-gherkin', [{ name: info.currentItem, path: 'ki' }]);

                // Clear exchanges from previous AP + set combined prompt in Agent Modal
                agentActivity.clearExchanges('cucumber');
                agentActivity.updateProgress('cucumber', info.current, info.currentItem, earlyAgentInput, undefined);
              } else {
                // AP streaming (partial output) — update output only, keep inputSnapshot unchanged
                agentActivity.updateProgress('cucumber', info.current, info.currentItem, undefined, info.outputSoFar);
              }
            } else {
              agentActivity.finishRun('cucumber', 'done');
              processFlow.completeStep('read-ap');
              processFlow.completeStep('ki-tables');
              processFlow.completeStep('build-prompt');
              processFlow.completeStep('gen-gherkin');
              processFlow.completeStep('result-ok');
            }
          }}
        />
      </main>

      {/* Data Import view (Excel/CSV) */}
      <main style={{ display: view === 'dataimport' ? undefined : 'none' }}>
        <DataImportTab
          rootHandle={fileExplorer.rootHandle}
          tableDefs={tableDefs}
          onFeatureGenerated={(feature) => {
            setFeatures((previous) => [...previous, feature]);
            setActiveFeatureIdx(features.length);
            setView('editor');
          }}
        />
      </main>
      </div>
      {aiEnabled && !sidePanelCollapsed && (
        <div className={styles.sidePanelDivider} onMouseDown={handleSidePanelDividerMouseDown} />
      )}
      {aiEnabled && (
        <WorkflowSidePanel
          runs={agentActivity.runs as Map<string, import('./types/fop').AgentRun>}
          lang={lang as 'de' | 'en'}
          collapsed={sidePanelCollapsed}
          onToggleCollapsed={() => setSidePanelCollapsed(!sidePanelCollapsed)}
          width={sidePanelWidth}
          onClear={agentActivity.clearAllRuns}
        />
      )}

      {showTemplateDiscardConfirm && (
        <ConfirmDialog
          title={t('app.unsavedChanges')}
          message={t('action.templateDiscardConfirm')}
          confirmLabel={t('app.discard')}
          cancelLabel={t('bulk.cancel')}
          onConfirm={() => {
            const action = templateDiscardConfirmActionRef.current;
            templateDiscardConfirmActionRef.current = null;
            setShowTemplateDiscardConfirm(false);
            action?.();
          }}
          onCancel={() => {
            templateDiscardConfirmActionRef.current = null;
            setShowTemplateDiscardConfirm(false);
          }}
        />
      )}

      {showResetConfirm && (
        <ConfirmDialog
          title={t('app.resetEverything')}
          message={t('app.resetConfirm')}
          confirmLabel={t('app.reset')}
          cancelLabel={t('bulk.cancel')}
          onConfirm={() => {
            setFeatures([{ ...INITIAL_FEATURE }]);
            setActiveFeatureIdx(0);
            setShowResetConfirm(false);
          }}
          onCancel={() => setShowResetConfirm(false)}
        />
      )}

      {aiEditReview && (
        <ConfirmDialog
          title={aiEditReview.title}
          message={aiEditReview.message}
          confirmLabel={aiEditReview.allowApply
            ? t('app.aiEditApplyAnyway')
            : t('app.close')}
          cancelLabel={t('app.cancel')}
          onConfirm={() => {
            if (aiEditReview.allowApply) {
              updateEditorFeature(aiEditReview.updated);
              setView('editor');
            }
            setAiEditReview(null);
            setAiEditError(null);
          }}
          onCancel={() => setAiEditReview(null)}
        />
      )}

      {pendingWorkspaceImport && (
        <WorkspaceSwitchModal
          payload={pendingWorkspaceImport}
          onConfirm={(sel) => {
            const handle = fileExplorer.rootHandle;
            if (!sel.tables) setTableDefs([]);
            if (!sel.fopBindings) setFopBindings([]);
            if (!sel.isBindings) setIsBindings([]);
            if (!sel.kbDocuments) {
              import('./lib/kbStore').then(({ clearAllKBDocuments }) => clearAllKBDocuments()).catch(() => {});
              setKbDocuments([]);
            }
            // Save selected data into new workspace
            if (handle) {
              if (sel.tables) saveTableDefsToWorkspace(handle, pendingWorkspaceImport.tables).catch(() => {});
              if (sel.fopBindings) saveFopBindingsToWorkspace(handle, pendingWorkspaceImport.fopBindings).catch(() => {});
              if (sel.isBindings) saveIsBindingsToWorkspace(handle, pendingWorkspaceImport.isBindings).catch(() => {});
              if (sel.kbDocuments) {
                import('./lib/kbStore').then(({ loadAllKBChunks }) => loadAllKBChunks()).then((chunks) => {
                  saveKBToWorkspace(handle, pendingWorkspaceImport.kbDocuments, chunks).catch(() => {});
                }).catch(() => {});
              }
              if (sel.learnings) {
                import('./lib/learningStore').then(({ saveWorkspaceLearnings }) =>
                  saveWorkspaceLearnings(handle, workspaceLearnings)
                ).catch(() => {});
              }
              if (sel.settings) {
                import('./lib/learningStore').then(({ saveSharedSettingsJson }) =>
                  saveSharedSettingsJson()
                ).catch(() => {});
              }
            }
            setPendingWorkspaceImport(null);
          }}
          onClear={() => {
            setTableDefs([]);
            setFopBindings([]);
            setIsBindings([]);
            import('./lib/kbStore').then(({ clearAllKBDocuments }) => clearAllKBDocuments()).catch(() => {});
            setKbDocuments([]);
            setPendingWorkspaceImport(null);
          }}
        />
      )}
      </div>
    </>
  );
}
