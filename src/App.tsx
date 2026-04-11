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
import type { FeatureInput, TableDef, ParsedFeaturePackage } from './types/gherkin';
import type { TocInfo } from './components/DocxImport/DocxImport';
import type { Agent, AgentMessage, AgentContext } from './types/agent';
import { useGherkinGenerator } from './hooks/useGherkinGenerator';
import { generateGherkin } from './lib/generator';
import { useAiGeneration } from './hooks/useAiGeneration';
import { useAiRating } from './hooks/useAiRating';
import type { AiPromptRating } from './lib/aiPrompt';
import { useUndoRedo } from './hooks/useUndoRedo';
import { getModel, saveFeatures, getCustomSystemPrompt, getExperimentalFeatures, saveFopBindings, loadFopBindings, saveIsBindings, loadIsBindings, getForceKiTableId } from './lib/settings';
import { DEFAULT_SYSTEM_PROMPT, DEFAULT_SYSTEM_PROMPT_EN, formatSingleTableContext } from './lib/aiPrompt';
import { useAgentActivity, loadConversationsFromDir, saveConversationsToDir } from './hooks/useAgentActivity';
import { useFopAnalysis } from './hooks/useFopAnalysis';
import AgentStatusBar from './components/AgentStatusBar';
import AgentActivityModal from './components/AgentActivityModal';
import ProcessDiagram from './components/ProcessDiagram/ProcessDiagram';
import { useProcessFlow, CUCUMBER_STEPS, FOP_STEPS } from './hooks/useProcessFlow';
import { UploadPanel, FopTree, AnalysisPanel } from './components/ReverseEngineering';
import { DataStatusBar } from './components/DataStatusBar/DataStatusBar';
import { StammdatenView } from './components/StammdatenView/StammdatenView';
import { isLoggedIn, hasAuthCallback, handleAuthCallback, initiateLogin, getStoredClientId, getStoredApplicationId, getStoredClientSecret, getStoredTenantId, createMftAgent, updateMftAgent, deleteMftAgent, discoverMftAgents, chatWithAgent } from './lib/myforterroApi';
import { loadTableDefs, saveTableDefs, migrateTableDefsFromLocalStorage } from './lib/csvTableParser';
import { featureHasStepErrors, scenarioHasErrors } from './lib/featureValidation';
import { loadAgents, saveAgent, deleteAgent as deleteAgentFromDb } from './lib/agentStore';
import { parseGherkin } from './lib/gherkinParser';
import { useTranslation } from './i18n';
import { FeatureForm } from './components/FeatureForm/FeatureForm';
import { GherkinPreview } from './components/GherkinPreview/GherkinPreview';
import { ActionBar } from './components/ActionBar/ActionBar';
import { SettingsPanel } from './components/SettingsPanel/SettingsPanel';
import { HelpGuide } from './components/HelpGuide/HelpGuide';
import { TokenHistory } from './components/TokenHistory/TokenHistory';
import { DocxImport } from './components/DocxImport/DocxImport';
import { FlowDiagram } from './components/FlowDiagram/FlowDiagram';
import { StepToolbox } from './components/StepToolbox/StepToolbox';
import { FileExplorer } from './components/FileExplorer/FileExplorer';
import { AgentPanel } from './components/AgentPanel/AgentPanel';
import { ConfirmDialog } from './components/ConfirmDialog/ConfirmDialog';
import { useFileExplorer } from './hooks/useFileExplorer';
import { collectExistingGuids, makeFeatureGuid } from './lib/featureGuid';
import { sanitizeName } from './lib/fileSystemAccess';
import styles from './App.module.css';

const INITIAL_FEATURE: FeatureInput = {
  name: '',
  description: '',
  tags: [],
  database: null,
  testUser: '',
  scenarios: [],
};

export default function App() {
  const { t, lang, setLang } = useTranslation();
  const experimentalFeatures = getExperimentalFeatures();
  const [view, setView] = useState<'editor' | 'docx' | 'stammdaten' | 'reverse'>('editor');
  const [appLoading, setAppLoading] = useState(true);

  // Core state — declared first so downstream hooks can reference
  const initialFeatures = [INITIAL_FEATURE];
  const { value: features, set: setFeatures, undo, redo, canUndo, canRedo } = useUndoRedo(initialFeatures);
  const [activeFeatureIdx, setActiveFeatureIdx] = useState(0);
  const [tableDefs, setTableDefs] = useState<TableDef[]>([]);
  const [fopBindings, setFopBindings] = useState<import('./types/fop').FopBinding[]>(
    () => loadFopBindings() as import('./types/fop').FopBinding[],
  );

  // Persist FOP bindings whenever they change
  useEffect(() => { saveFopBindings(fopBindings); }, [fopBindings]);

  const [isBindings, setIsBindings] = useState<import('./lib/fopTxtParser').IsBinding[]>(
    () => loadIsBindings() as import('./lib/fopTxtParser').IsBinding[],
  );
  // Persist IS bindings whenever they change
  useEffect(() => { saveIsBindings(isBindings); }, [isBindings]);

  // Knowledge Base documents
  const [kbDocuments, setKbDocuments] = useState<import('./types/knowledgeBase').KBDocument[]>([]);

  const [loggedIn, setLoggedIn] = useState(() => isLoggedIn());
  const [model, setModel] = useState(() => getModel() || '');

  // Agent activity tracking (Cucumber + FOP agents)
  const agentActivity = useAgentActivity(lang as 'de' | 'en');

  // Process flow visualisation
  const processFlow = useProcessFlow();       // FOP analysis OR Cucumber (non-reverse tabs)
  const cucumberFlow = useProcessFlow();      // Cucumber generation from FOP analysis (reverse tab only)
  const [openProcessAgent, setOpenProcessAgent] = useState<string | null>(null);

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

  // Agents
  const [agents, setAgents] = useState<Agent[]>([]);
  const [, setSelectedFolderPath] = useState<string | null>(null);
  // EFK agents removed — Standard-Agent is used for all AI calls
  const [agentSending, setAgentSending] = useState(false);
  const [agentStreamingText, setAgentStreamingText] = useState<string | null>(null);
  const [agentError, setAgentError] = useState<string | null>(null);

  // Auto-logout when session expires (e.g. refresh token invalid)
  useEffect(() => {
    const handler = () => setLoggedIn(false);
    window.addEventListener('session-expired', handler);
    return () => window.removeEventListener('session-expired', handler);
  }, []);

  // Handle OAuth callback (code + state in URL after redirect from MyForterro)
  // Use ref to prevent StrictMode double-execution from clearing sessionStorage
  const authCallbackHandled = useRef(false);
  useEffect(() => {
    if (authCallbackHandled.current) return;
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
  const [previewMode, setPreviewMode] = useState<'toolbox' | 'text' | 'diagram' | 'agent'>('toolbox');

  // File Explorer
  const fileExplorer = useFileExplorer();

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

  const [explorerWidth, setExplorerWidth] = useState(() => {
    const saved = localStorage.getItem('cucumbergnerator_explorer_width');
    return saved ? Number(saved) : 320;
  });
  const explorerWidthRef = useRef(explorerWidth);
  explorerWidthRef.current = explorerWidth;

  const existingFeatureGuids = useMemo(() => collectExistingGuids(fileExplorer.tree), [fileExplorer.tree]);

  // Load tableDefs from IndexedDB on mount (async)
  useEffect(() => {
    let cancelled = false;
    (async () => {
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
  const activeAgent = agents.length > 0 ? agents[0] : null;


  // If previewMode is 'agent' but there's no active agent, fall back to toolbox
  const effectivePreviewMode = previewMode === 'agent' && !activeAgent ? 'toolbox' : previewMode;

  // Auto-create a default agent when logged in but no agents exist.
  // Waits until agents are loaded from IndexedDB (agentsLoaded flag).
  const [agentsLoaded, setAgentsLoaded] = useState(false);
  const autoAgentCreated = useRef(false);
  // Mark agents as loaded after initial IndexedDB load
  useEffect(() => {
    loadAgents().then(() => setAgentsLoaded(true)).catch(() => setAgentsLoaded(true));
  }, []);

  useEffect(() => {
    if (!loggedIn || !model || !agentsLoaded || !tenantReady || autoAgentCreated.current) return;
    autoAgentCreated.current = true;

    const currentPrompt = getCustomSystemPrompt() ?? DEFAULT_SYSTEM_PROMPT;

    if (agents.length > 0) {
      // Agent exists locally — sync only the Standard-Agent (first agent) so prompt changes take effect.
      // Other agents on MyForterro are not touched to avoid overwriting user-specific prompts.
      const standardAgent = agents[0];
      if (standardAgent?.apiAgentId) {
        const apiId = standardAgent.apiAgentId;
        (async () => {
          try {
            await updateMftAgent(apiId, standardAgent.name, model, currentPrompt);
            console.log(`[App] Agent "${standardAgent.name}" Prompt synchronisiert`);
          } catch (err) {
            console.warn(`[App] Agent "${standardAgent.name}" Prompt-Sync fehlgeschlagen:`, err);
          }
        })();
      }
      return;
    }

    // No agents yet — find existing or create Standard-Agent
    (async () => {
      try {
        let apiAgentId: string | null = null;
        const existing = await discoverMftAgents();
        const found = existing.find(a => a.name === 'Cucumber Agent');
        if (found) {
          apiAgentId = found.agentId;
          updateMftAgent(found.agentId, 'Cucumber Agent', model, currentPrompt).catch(() => {});
        } else {
          try {
            const dto = await createMftAgent('Cucumber Agent', model, currentPrompt);
            apiAgentId = dto.agentId;
          } catch { /* fallback */ }
        }
        const newAgent: Agent = {
          id: crypto.randomUUID(),
          name: 'Cucumber Agent',
          folderPath: '',
          apiAgentId,
          conversationId: null,
          messages: [],
          context: [],
          createdAt: Date.now(),
          updatedAt: Date.now(),
        };
        await saveAgent(newAgent);
        setAgents((prev) => [...prev, newAgent]);
        console.log('[App] Standard-Agent automatisch erstellt');
      } catch (err) {
        console.warn('[App] Auto-Agent-Erstellung fehlgeschlagen:', err);
      }
    })();
  }, [loggedIn, model, agentsLoaded, agents.length, tenantReady]);

  // Auto-create FOP agents (experimentalFeatures only) — find existing first, create only if needed
  const fopAgentsCreated = useRef(false);
  useEffect(() => {
    if (!loggedIn || !model || !tenantReady || !experimentalFeatures || fopAgentsCreated.current) return;
    fopAgentsCreated.current = true;
    (async () => {
      try {
        // First: check if agents already exist
        const existing = await discoverMftAgents();
        const existingAnalyst = existing.find(a => a.name === 'FOP Inhaltsanalyst');
        const existingGuidelines = existing.find(a => a.name === 'FOP Richtlinienprüfer');

        const { buildFopAnalystPrompt, buildFopGuidelinesPrompt } = await import('./lib/fopAgentPrompt');
        const currentLang = lang as 'de' | 'en';

        if (existingAnalyst) {
          console.log('[App] FOP Analyst gefunden:', existingAnalyst.agentId);
          setFopAnalystAgentId(existingAnalyst.agentId);
          // Update prompt silently
          updateMftAgent(existingAnalyst.agentId, 'FOP Inhaltsanalyst', model, buildFopAnalystPrompt(currentLang)).catch(() => {});
        } else {
          const dto = await createMftAgent('FOP Inhaltsanalyst', model, buildFopAnalystPrompt(currentLang));
          console.log('[App] FOP Analyst erstellt:', dto.agentId);
          setFopAnalystAgentId(dto.agentId);
        }

        if (existingGuidelines) {
          console.log('[App] FOP Guidelines gefunden:', existingGuidelines.agentId);
          setFopGuidelinesAgentId(existingGuidelines.agentId);
          updateMftAgent(existingGuidelines.agentId, 'FOP Richtlinienprüfer', model, buildFopGuidelinesPrompt(currentLang)).catch(() => {});
        } else {
          const dto = await createMftAgent('FOP Richtlinienprüfer', model, buildFopGuidelinesPrompt(currentLang));
          console.log('[App] FOP Guidelines erstellt:', dto.agentId);
          setFopGuidelinesAgentId(dto.agentId);
        }

        console.log('[App] FOP-Agents bereit');
      } catch (err) {
        console.warn('[App] FOP-Agent-Setup fehlgeschlagen:', err);
      }
    })();
  }, [loggedIn, model, tenantReady, experimentalFeatures]); // eslint-disable-line react-hooks/exhaustive-deps

  // Build agent instructions — only the system prompt, NO context files.
  // Context is sent as a preamble in the first chat message to avoid OOM on the instructions endpoint.
  const buildAgentInstructions = useCallback((): string => {
    return getCustomSystemPrompt() ?? DEFAULT_SYSTEM_PROMPT;
  }, []);

  // ~15 000 Tokens pro Datei — hält den Request unter dem gpt-4 TPM-Limit
  const MAX_CONTEXT_CHARS_PER_FILE = 60_000;

  // Build the message to send: prepend context docs when starting a new conversation.
  // Type-aware: vartab and efk summaries are included as structured preamble; oversized docs are truncated.
  const buildChatMessage = useCallback((text: string, context: AgentContext[], isNewConversation: boolean): string => {
    if (!isNewConversation || context.length === 0) return text;
    const parts: string[] = [];

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

    return `${parts.join('\n\n')}\n\n---\n\n${text}`;
  }, []);


  // Helper: handle errors from agent API calls
  const handleAgentError = useCallback((err: unknown) => {
    const raw = (err as Error).message ?? '';
    setAgentError(raw || 'Unbekannter Fehler');
  }, []);

  // Create folder — no agent creation needed (Standard-Agent is used)
  const handleCreateFolder = useCallback(async (parentPath: string): Promise<string | null> => {
    return fileExplorer.createFolder(parentPath);
  }, [fileExplorer]);

  // Agent: send message via real API (SSE streaming)
  const handleAgentSendMessage = useCallback(async (agentId: string, text: string) => {
    let agent = agents.find((a) => a.id === agentId);
    if (!agent) return;

    // Auto-create API agent if missing (e.g. migrating old local-only agents)
    if (!agent.apiAgentId) {
      if (!model) {
        setAgentError('Kein Modell ausgewählt. Bitte zuerst ein Modell in den Einstellungen wählen.');
        return;
      }
      try {
        const dto = await createMftAgent(agent.name, model, buildAgentInstructions());
        const migrated: Agent = { ...agent, apiAgentId: dto.agentId, updatedAt: Date.now() };
        await saveAgent(migrated);
        setAgents((prev) => prev.map((a) => (a.id === agentId ? migrated : a)));
        agent = migrated;
      } catch (err) {
        handleAgentError(err);
        return;
      }
    }

    const userMsg: AgentMessage = {
      id: crypto.randomUUID(),
      role: 'user',
      content: text,
      timestamp: Date.now(),
    };
    const withUser: Agent = { ...agent, messages: [...agent.messages, userMsg], updatedAt: Date.now() };
    setAgents((prev) => prev.map((a) => (a.id === agentId ? withUser : a)));
    await saveAgent(withUser);

    setAgentError(null);
    setAgentSending(true);
    setAgentStreamingText('');
    try {
      const isNewConversation = agent.conversationId === null;
      const apiMessage = buildChatMessage(text, agent.context, isNewConversation);
      const result = await chatWithAgent(
        agent.apiAgentId!,
        apiMessage,
        agent.conversationId,
        (delta) => setAgentStreamingText((prev) => (prev ?? '') + delta),
      );
      const assistantMsg: AgentMessage = {
        id: crypto.randomUUID(),
        role: 'assistant',
        content: result.fullMessage,
        timestamp: Date.now(),
      };
      const final: Agent = {
        ...withUser,
        messages: [...withUser.messages, assistantMsg],
        conversationId: result.conversationId,
        updatedAt: Date.now(),
      };
      setAgents((prev) => prev.map((a) => (a.id === agentId ? final : a)));
      await saveAgent(final);
    } catch (err) {
      handleAgentError(err);
    } finally {
      setAgentSending(false);
      setAgentStreamingText(null);
    }
  }, [agents, model, buildAgentInstructions, buildChatMessage, handleAgentError]);

  // Agent: retry — re-sends the last user message using the same conversationId
  const handleAgentRetry = useCallback(async (agentId: string) => {
    const agent = agents.find((a) => a.id === agentId);
    if (!agent || !agent.apiAgentId) return;
    const lastMsg = agent.messages[agent.messages.length - 1];
    if (!lastMsg || lastMsg.role !== 'user') return;

    setAgentError(null);
    setAgentSending(true);
    setAgentStreamingText('');
    try {
      const isNewConversation = agent.conversationId === null;
      const apiMessage = buildChatMessage(lastMsg.content, agent.context, isNewConversation);
      const result = await chatWithAgent(
        agent.apiAgentId,
        apiMessage,
        agent.conversationId,
        (delta) => setAgentStreamingText((prev) => (prev ?? '') + delta),
      );
      const assistantMsg: AgentMessage = {
        id: crypto.randomUUID(),
        role: 'assistant',
        content: result.fullMessage,
        timestamp: Date.now(),
      };
      const final: Agent = {
        ...agent,
        messages: [...agent.messages, assistantMsg],
        conversationId: result.conversationId,
        updatedAt: Date.now(),
      };
      setAgents((prev) => prev.map((a) => (a.id === agentId ? final : a)));
      await saveAgent(final);
    } catch (err) {
      handleAgentError(err);
    } finally {
      setAgentSending(false);
      setAgentStreamingText(null);
    }
  }, [agents, buildChatMessage, handleAgentError]);





  // Agent: reset (delete + recreate, with confirmation modal)
  const [deleteAgentConfirm, setDeleteAgentConfirm] = useState<{ agentId: string; resolve: (v: boolean) => void } | null>(null);

  const handleDeleteAgent = useCallback((agentId: string) => {
    new Promise<boolean>((resolve) => {
      setDeleteAgentConfirm({ agentId, resolve });
    }).then(async (confirmed) => {
      if (confirmed) {
        const agent = agents.find((a) => a.id === agentId);
        // 1. Delete old agent on API
        if (agent?.apiAgentId) {
          try { await deleteMftAgent(agent.apiAgentId); } catch { /* ignore */ }
        }
        // 2. Delete locally
        await deleteAgentFromDb(agentId);

        // 3. Immediately create a fresh agent
        const currentPrompt = getCustomSystemPrompt() ?? DEFAULT_SYSTEM_PROMPT;
        let newApiAgentId: string | null = null;
        if (model) {
          try {
            const dto = await createMftAgent('Cucumber Agent', model, currentPrompt);
            newApiAgentId = dto.agentId;
          } catch { /* ignore — will retry on next login */ }
        }
        const freshAgent: Agent = {
          id: crypto.randomUUID(),
          name: 'Cucumber Agent',
          folderPath: '',
          apiAgentId: newApiAgentId,
          conversationId: null,
          messages: [],
          context: [],
          createdAt: Date.now(),
          updatedAt: Date.now(),
        };
        await saveAgent(freshAgent);
        setAgents([freshAgent]);
        console.log('[App] Agent zurückgesetzt — neuer Standard-Agent erstellt');
      }
    });
  }, [agents, model, buildAgentInstructions]);

  // System prompt change: sync only the active agent's instructions (not other user agents)
  const handleSystemPromptChange = useCallback(async () => {
    if (!model || !activeAgent?.apiAgentId) return;
    try {
      await updateMftAgent(activeAgent.apiAgentId, activeAgent.name, model, buildAgentInstructions());
      console.log(`[App] Agent "${activeAgent.name}" Prompt synchronisiert`);
    } catch { /* Non-fatal */ }
  }, [activeAgent, model, buildAgentInstructions]);

  // Sync ALL agent prompts on language change (Cucumber Agent + FOP agents)
  useEffect(() => {
    if (!model || !loggedIn) return;
    const currentLang = lang as 'de' | 'en';
    // Cucumber Agent
    if (activeAgent?.apiAgentId) {
      const prompt = getCustomSystemPrompt() ?? (currentLang === 'de' ? DEFAULT_SYSTEM_PROMPT : DEFAULT_SYSTEM_PROMPT_EN);
      updateMftAgent(activeAgent.apiAgentId, activeAgent.name, model, prompt).catch(() => {});
    }
    // FOP Agents (only if experimental features enabled)
    if (experimentalFeatures) {
      (async () => {
        try {
          const { buildFopAnalystPrompt, buildFopGuidelinesPrompt } = await import('./lib/fopAgentPrompt');
          if (fopAnalystAgentId) {
            await updateMftAgent(fopAnalystAgentId, 'FOP Inhaltsanalyst', model, buildFopAnalystPrompt(currentLang)).catch(() => {});
          }
          if (fopGuidelinesAgentId) {
            await updateMftAgent(fopGuidelinesAgentId, 'FOP Richtlinienprüfer', model, buildFopGuidelinesPrompt(currentLang)).catch(() => {});
          }
        } catch { /* Non-fatal */ }
      })();
    }
  }, [lang]); // eslint-disable-line react-hooks/exhaustive-deps

  // Model change: sync only the active agent to the new model
  const handleModelChange = useCallback(async (newModel: string) => {
    setModel(newModel);
    if (!newModel || !activeAgent?.apiAgentId) return;
    try {
      await updateMftAgent(activeAgent.apiAgentId, activeAgent.name, newModel, buildAgentInstructions());
    } catch { /* Non-fatal */ }
  }, [activeAgent, buildAgentInstructions]);

  // Agent: start a new conversation (clears messages + conversationId)
  const handleAgentNewConversation = useCallback(async (agentId: string) => {
    const agent = agents.find((a) => a.id === agentId);
    if (!agent) return;
    const reset: Agent = { ...agent, messages: [], conversationId: null, updatedAt: Date.now() };
    setAgents((prev) => prev.map((a) => (a.id === agentId ? reset : a)));
    await saveAgent(reset);
    setAgentError(null);
  }, [agents]);

  // Agent: retry login after session expiry
  const handleAgentRetryLogin = useCallback(async () => {
    const clientId = getStoredClientId();
    const applicationId = getStoredApplicationId();
    const clientSecret = getStoredClientSecret();
    if (clientId && applicationId) {
      await initiateLogin(clientId, applicationId, clientSecret || undefined);
    }
  }, []);

  // File explorer: handle file creation → auto-open in editor
  const handleExplorerCreateFile = useCallback(async (parentPath: string) => {
    const newPath = await fileExplorer.createFile(parentPath);
    if (newPath) {
      // createFile already sets activeFilePath and reads the file handle;
      // we just need to load the (empty) feature into the editor state
      const featureName = newPath.split('/').pop()?.replace(/\.feature$/, '') || '';
      const featureInput = { ...INITIAL_FEATURE, name: featureName, tags: [`@${makeFeatureGuid('', featureName)}`] };
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

  const updateFeature = (updated: FeatureInput) => {
    setFeatures((prev) => prev.map((f, i) => (i === activeFeatureIdx ? updated : f)));
    // Auto-save to disk in directory mode
    if (fileExplorer.isDirectoryMode && fileExplorer.activeFilePath) {
      fileExplorer.saveActiveFile(updated);
      fileExplorer.updateTreeForFeature(fileExplorer.activeFilePath, updated);
    }
  };

  const handleTablesChange = (tables: TableDef[]) => {
    setTableDefs(tables);
    saveTableDefs(tables);
  };
  const { gherkin, lineMapping } = useGherkinGenerator(feature);
  const { loading, generationStep, error, generate } = useAiGeneration();
  const [aiRating, setAiRating] = useState<AiPromptRating | null>(null);
  const { loading: ratingLoading, error: ratingError, rating: standaloneAiRating, requestRating } = useAiRating();

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

  // Agent for editor: prefer activeAgent (folder), then any agent with apiAgentId
  const editorAgentApiId = activeAgent?.apiAgentId ?? agents.find((a) => a.apiAgentId)?.apiAgentId ?? null;

  const handleRequestRating = useCallback(() => {
    if (!feature.description.trim()) return;
    if (!editorAgentApiId) return;
    requestRating(feature.description, model, editorAgentApiId);
  }, [feature.description, model, editorAgentApiId, requestRating]);

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
      (chunk) => {
        streamedSoFar += chunk;
        agentActivity.updateProgress(
          'cucumber', 0, feature.name || '…',
          `Feature: ${feature.name || '(unnamed)'}\n\n${feature.description}`,
          streamedSoFar,
        );
      },
      undefined, // onTablesIdentified handled separately
      preDetectedTables, // pass pre-detected tables → skips re-detection in generatePackage
      (round, maxRounds, sent, received) => {
        // Deep test: show each round in Agent Monitor
        const label = `${lang === 'de' ? 'Runde' : 'Round'} ${round}/${maxRounds}`;
        agentActivity.addExchange('cucumber', label, sent, received);
      },
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
      setFeatures((prev) =>
        prev.map((f, i) => {
          if (i !== activeFeatureIdx) return f;
          return {
            ...f,
            name: result.feature.name || f.name,
            tags: result.feature.tags.length > 0 ? result.feature.tags : f.tags,
            scenarios: result.feature.scenarios,
          };
        }),
      );
    }
  };

  // DocxImport "Bearbeiten" → load feature into editor, create file in directory mode
  const handleLoadToEditor = useCallback(async (f: FeatureInput) => {
    if (fileExplorer.isDirectoryMode) {
      // Create a new .feature file in the root and open it
      const fileName = (f.name || 'Neues Feature').replace(/[^a-zA-Z0-9äöüÄÖÜß_\- ]/g, '_');
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

  // Resolve target folder name: auto-detect existing folder or prompt
  const resolveImportFolder = async (fileName: string): Promise<string | null> => {
    const defaultName = sanitizeName(fileName);
    // Check if a folder with the sanitized name already exists in the tree root
    const existingFolder = fileExplorer.tree.find(
      (n) => n.type === 'folder' && n.displayName === defaultName,
    );
    if (existingFolder) {
      const mergeInto = window.confirm(
        `Ordner "${defaultName}" existiert bereits.\n\nIn bestehenden Ordner importieren?`,
      );
      if (mergeInto) return defaultName;
      // User declined merge — prompt for a different name
      const altName = window.prompt('Neuen Ordnernamen eingeben:', `${defaultName} (neu)`);
      return altName || null;
    }
    // First import: use the document name directly
    return defaultName;
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
  }, [fileExplorer, model, buildAgentInstructions, setFeatures]);

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

  // ── Login screen when not authenticated ──────────────────────
  if (!loggedIn) {
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
          <SettingsPanel loggedIn={false} onLoginChange={setLoggedIn} model={model} onModelChange={handleModelChange} onSystemPromptChange={handleSystemPromptChange} alwaysOpen />
        </div>
        <div style={{ marginTop: '1rem' }}>
          <div className={styles.langSwitch}>
            <button className={lang === 'de' ? styles.langBtnActive : styles.langBtn} onClick={() => setLang('de')} type="button">DE</button>
            <button className={lang === 'en' ? styles.langBtnActive : styles.langBtn} onClick={() => setLang('en')} type="button">EN</button>
          </div>
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
          <div>{lang === 'de' ? 'Daten werden geladen…' : 'Loading data…'}</div>
          <div style={{ fontSize: '0.75rem', marginTop: 6, opacity: 0.7 }}>
            {appLoading && (lang === 'de' ? 'Variablentabellen & Infosysteme' : 'Variable tables & infosystems')}
            {!appLoading && fopAnalysis.isRestoring && (lang === 'de' ? 'FOP-Ordner wird wiederhergestellt…' : 'Restoring FOP folder…')}
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
            {fileExplorer.isDirectoryMode && (
              <button
                className={view === 'docx' ? styles.navItemActive : styles.navItem}
                onClick={() => setView('docx')}
                type="button"
              >
                {t('app.docxImport')}
              </button>
            )}
            <button
              className={view === 'stammdaten' ? styles.navItemActive : styles.navItem}
              onClick={() => setView('stammdaten')}
              type="button"
            >
              {lang === 'de' ? 'Stammdaten' : 'Master Data'}
            </button>
            {experimentalFeatures && (
              <button
                className={view === 'reverse' ? styles.navItemActive : styles.navItem}
                onClick={() => setView('reverse')}
                type="button"
                title="⚗ Experimentell"
              >
                {lang === 'de' ? 'Reverse Engineering' : 'Reverse Engineering'} ⚗
              </button>
            )}
          </nav>
          <div className={styles.headerActions}>
            <div className={styles.langSwitch}>
              <button
                className={lang === 'de' ? styles.langBtnActive : styles.langBtn}
                onClick={() => setLang('de')}
                type="button"
              >
                DE
              </button>
              <button
                className={lang === 'en' ? styles.langBtnActive : styles.langBtn}
                onClick={() => setLang('en')}
                type="button"
              >
                EN
              </button>
            </div>
            <TokenHistory />
            <HelpGuide />
            <SettingsPanel loggedIn={loggedIn} onLoginChange={setLoggedIn} model={model} onModelChange={handleModelChange} onSystemPromptChange={handleSystemPromptChange} />
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

      {/* Agent Status Bar — visible on all tabs */}
      <AgentStatusBar
        runs={agentActivity.runs}
        savedConversations={agentActivity.savedConversations}
        onDeleteSaved={agentActivity.deleteSaved}
        experimentalFeatures={experimentalFeatures}
        lang={lang as 'de' | 'en'}
      />

      {/* AgentActivityModal is rendered inside AgentStatusBar on chip click */}

      {/* Process diagram — only Cucumber generation flow on Editor/Konzept/Stammdaten tabs */}
      {view !== 'reverse' && [
        { flow: processFlow, label: lang === 'de' ? 'Generierungs-Ablauf' : 'Generation Flow', defaultType: 'cucumber' as const },
      ].map(({ flow, label, defaultType }) => {
        const activeFlow = flow;
        return (
        <div key={defaultType} style={{ borderBottom: '1px solid var(--color-border)', background: 'var(--color-bg)' }}>
          <button
            type="button"
            onClick={activeFlow.toggleExpanded}
            style={{
              display: 'flex', alignItems: 'center', gap: 8,
              width: '100%', padding: '5px 16px',
              background: 'none', border: 'none', cursor: 'pointer',
              fontSize: '0.78rem', color: 'var(--color-text-muted)',
              borderBottom: activeFlow.expanded ? '1px solid var(--color-border)' : 'none',
              textAlign: 'left',
            }}
          >
            <span>{activeFlow.expanded ? '▾' : '▸'}</span>
            <span style={{ fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.04em', flexShrink: 0 }}>
              {label}
            </span>
            {activeFlow.statusText && (
              <span style={{ fontSize: '0.78rem', color: 'var(--color-primary)', fontWeight: 500, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                — {activeFlow.statusText}
              </span>
            )}
          </button>
          {activeFlow.expanded && (
            <ProcessDiagram
              flow={activeFlow.diagramFlow ?? { type: defaultType, steps: (defaultType === 'fop' ? FOP_STEPS : CUCUMBER_STEPS).map(s => ({ ...s })) }}
              onAgentClick={(agentType: string) => setOpenProcessAgent(agentType)}
              lang={lang as 'de' | 'en'}
            />
          )}
        </div>
        );
      })}
      {openProcessAgent && (
        <AgentActivityModal
          run={agentActivity.runs.get(openProcessAgent as Parameters<typeof agentActivity.runs.get>[0]) ?? null}
          agentLabel={openProcessAgent}
          savedConversations={agentActivity.savedConversations.filter(c => c.agentType === openProcessAgent)}
          onDeleteSaved={agentActivity.deleteSaved}
          onClose={() => setOpenProcessAgent(null)}
          lang={lang as 'de' | 'en'}
        />
      )}

      {/* Data status bar — shows what reference data is loaded (all tabs) */}
      <DataStatusBar
        tableDefs={tableDefs}
        fopBindings={fopBindings}
        isBindings={isBindings}
        kbDocumentCount={kbDocuments.length}
        kbChunkCount={kbDocuments.reduce((s, d) => s + d.chunkCount, 0)}
        lang={lang as 'de' | 'en'}
      />

      <div className={styles.app}>
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
                onMoveFile={fileExplorer.moveEntry}
                onRenameEntry={fileExplorer.renameEntry}
                onSetDragOverPath={fileExplorer.setDragOverPath}
                onDeselectFile={fileExplorer.deselectFile}
                onFolderSelect={setSelectedFolderPath}
                errorPaths={errorPaths}
                activeScenarioPath={focusScenario && fileExplorer.activeFilePath ? `${fileExplorer.activeFilePath}#${focusScenario.id}` : null}
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
            {/* Undo/Redo and reset only when a file is open */}
            {fileExplorer.activeFilePath && (
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
                      if (window.confirm(t('app.resetConfirm'))) {
                        setFeatures([{ ...INITIAL_FEATURE }]);
                        setActiveFeatureIdx(0);
                      }
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
          {!fileExplorer.activeFilePath ? (
            <div className={styles.editorPlaceholder}>
              <div className={styles.editorPlaceholderIcon}>{fileExplorer.isDirectoryMode ? '📄' : '📂'}</div>
              <div className={styles.editorPlaceholderText}>
                {!fileExplorer.isDirectoryMode
                  ? (lang === 'de' ? 'Öffne einen Ordner im Explorer, um Feature-Dateien zu bearbeiten.' : 'Open a folder in the explorer to edit feature files.')
                  : fileExplorer.isVisible
                    ? (lang === 'de' ? 'Wähle eine Feature-Datei aus dem Explorer, um sie zu bearbeiten.' : 'Select a feature file from the explorer to edit.')
                    : (lang === 'de' ? 'Explorer einblenden (📁 oder Ctrl+B), um eine Feature-Datei auszuwählen.' : 'Show explorer (📁 or Ctrl+B) to select a feature file.')}
              </div>
            </div>
          ) : (
            <>
              <FeatureForm
                feature={feature}
                onChange={updateFeature}
                showGenerate={loggedIn && !!editorAgentApiId}
                onGenerate={handleGenerate}
                generating={loading}
                generationStep={generationStep}
                generateError={!editorAgentApiId && loggedIn ? (lang === 'de' ? 'Kein Agent verfügbar. Bitte zuerst einen Agent erstellen (Konzept-Import oder Ordner-Agent).' : 'No agent available. Please create an agent first (concept import or folder agent).') : error}
                tables={tableDefs}
                aiRating={aiRating}
                standaloneAiRating={standaloneAiRating}
                onRequestRating={editorAgentApiId ? handleRequestRating : undefined}
                ratingLoading={ratingLoading}
                ratingError={ratingError}
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
                {lang === 'de' ? 'Baukasten' : 'Toolbox'}
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
              {activeAgent && (
                <button
                  className={previewMode === 'agent' ? styles.previewToggleActive : styles.previewToggleBtn}
                  onClick={() => setPreviewMode('agent')}
                  type="button"
                >
                  🤖 Agent
                </button>
              )}
            </div>
            {(effectivePreviewMode === 'text' || effectivePreviewMode === 'diagram') && (
              <ActionBar
                gherkin={gherkin}
                featureName={feature.name}
                showZip={features.length > 1}
                onDownloadZip={handleDownloadAllZip}
              />
            )}
          </div>
          {effectivePreviewMode === 'toolbox' && (
            <StepToolbox />
          )}
          {effectivePreviewMode === 'text' && (
            <GherkinPreview gherkin={gherkin} lineMapping={lineMapping} onStepClick={handleStepClick} />
          )}
          {effectivePreviewMode === 'diagram' && (
            <FlowDiagram scenarios={feature.scenarios} onStepClick={handleStepClick} />
          )}
          {effectivePreviewMode === 'agent' && activeAgent && (
            <AgentPanel
              agent={activeAgent}
              model={model}
              isSending={agentSending}
              streamingText={agentStreamingText}
              onSendMessage={(text) => handleAgentSendMessage(activeAgent.id, text)}
              onDeleteAgent={() => handleDeleteAgent(activeAgent.id)}
              error={agentError}
              onRetryLogin={handleAgentRetryLogin}
              onRetry={() => handleAgentRetry(activeAgent.id)}
              onNewConversation={() => handleAgentNewConversation(activeAgent.id)}
            />
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
          {/* Flow diagrams — inline in reverse tab */}
          {[
            { flow: processFlow, label: lang === 'de' ? 'Analyse-Ablauf' : 'Analysis Flow', defaultType: 'fop' as const },
            { flow: cucumberFlow, label: lang === 'de' ? 'Generierungs-Ablauf' : 'Generation Flow', defaultType: 'cucumber' as const },
          ].map(({ flow, label, defaultType }) => (
            <div key={defaultType} style={{ borderBottom: '1px solid var(--color-border)', flexShrink: 0 }}>
              <button
                type="button"
                onClick={flow.toggleExpanded}
                style={{
                  display: 'flex', alignItems: 'center', gap: 8,
                  width: '100%', padding: '5px 16px',
                  background: 'none', border: 'none', cursor: 'pointer',
                  fontSize: '0.78rem', color: 'var(--color-text-muted)',
                  borderBottom: flow.expanded ? '1px solid var(--color-border)' : 'none',
                  textAlign: 'left',
                }}
              >
                <span>{flow.expanded ? '▾' : '▸'}</span>
                <span style={{ fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.04em' }}>
                  {label}
                </span>
                {flow.statusText && (
                  <span style={{ fontSize: '0.78rem', color: 'var(--color-primary)', fontWeight: 500 }}>
                    — {flow.statusText}
                  </span>
                )}
              </button>
              {flow.expanded && (
                <ProcessDiagram
                  flow={flow.diagramFlow ?? (defaultType === 'fop'
                    ? { type: 'fop' as const, steps: FOP_STEPS.map(s => ({ ...s })) }
                    : { type: 'cucumber' as const, steps: CUCUMBER_STEPS.map(s => ({ ...s })) })}
                  onAgentClick={(agentType: string) => setOpenProcessAgent(agentType)}
                  lang={lang as 'de' | 'en'}
                />
              )}
            </div>
          ))}
          {/* FOP folder header bar */}
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '6px 12px', borderBottom: '1px solid var(--color-border)', flexShrink: 0, fontSize: '0.8rem' }}>
            {fopAnalysis.rootDir ? (
              <>
                <span>📁 {fopAnalysis.rootDir.name}</span>
                <span style={{ color: 'var(--color-text-muted)', fontSize: '0.72rem' }}>{fopAnalysis.fopFiles.length} FOPs</span>
                <button type="button" onClick={() => fopAnalysis.loadDirectory(fopAnalysis.rootDir!)} style={{ background: 'none', border: '1px solid var(--color-border)', borderRadius: 4, padding: '1px 6px', cursor: 'pointer', fontSize: '0.72rem' }} title={lang === 'de' ? 'Neu laden' : 'Reload'}>⟳</button>
                <button type="button" onClick={fopAnalysis.closeDirectory} style={{ background: 'none', border: '1px solid var(--color-border)', borderRadius: 4, padding: '1px 6px', cursor: 'pointer', fontSize: '0.72rem' }} title={lang === 'de' ? 'Ordner entfernen' : 'Remove folder'}>✕</button>
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
                  {lang === 'de' ? '📁 FOP-Ordner öffnen' : '📁 Open FOP folder'}
                </button>
                {fileExplorer.rootHandle && (
                  <button
                    type="button"
                    onClick={() => fopAnalysis.loadDirectory(fileExplorer.rootHandle!)}
                    style={{ padding: '4px 12px', border: '1px solid var(--color-border)', borderRadius: 6, background: 'none', cursor: 'pointer', fontSize: '0.75rem' }}
                  >
                    {lang === 'de' ? '← Aus Explorer' : '← From Explorer'}
                  </button>
                )}
              </>
            )}
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
                    onTableIdStarted: (req) => {
                      agentActivity.addExchange('cucumber', lang === 'de' ? 'Tabellen-Identifikation' : 'Table Identification', req);
                    },
                    onTablesIdentified: (info) => {
                      if (info.tableIdRawResponse) agentActivity.updateLastExchange('cucumber', info.tableIdRawResponse);
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
                    onPromptBuilt: (prompt) => {
                      cucumberFlow.activateStep('build-prompt');
                      cucumberFlow.completeStep('build-prompt');
                      cucumberFlow.activateStep('gen-gherkin');
                      agentActivity.addExchange('cucumber', lang === 'de' ? 'Gherkin-Generierung' : 'Gherkin Generation', prompt);
                      agentActivity.updateProgress('cucumber', 0, fopName, prompt, undefined);
                    },
                    onRound: (round, maxRounds, sent, received) => {
                      console.log(`[DeepTest-UI] Round ${round}/${maxRounds} | sent: ${sent.slice(0, 100)}... | received: ${received.slice(0, 100)}...`);
                      const label = `${lang === 'de' ? 'Runde' : 'Round'} ${round}/${maxRounds}`;
                      agentActivity.addExchange('cucumber', label, sent, received);
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
              const guidTag = `@${fopGuid}`;

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
              const currentLang = lang as 'de' | 'en';
              const lines = [
                `# ${analysis.fopPath}`,
                '',
                `## ${currentLang === 'de' ? 'Fachliche Beschreibung' : 'Business Description'}`,
                analysis.humanDescription.summary,
                '',
                ...(analysis.humanDescription.useCases.length > 0 ? [
                  `### ${currentLang === 'de' ? 'Anwendungsfälle' : 'Use Cases'}`,
                  ...analysis.humanDescription.useCases.map(u => `- ${u}`),
                  '',
                ] : []),
                `## ${currentLang === 'de' ? 'Technische Beschreibung' : 'Technical Description'}`,
                analysis.technicalDescription.summary,
                '',
                `## ${currentLang === 'de' ? 'Richtlinien' : 'Guidelines'}: ${analysis.guidelines.score}`,
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
            lang={lang as 'de' | 'en'}
          />
        </main>
      )}

      {/* Docx Import view */}
      <main style={{ display: view === 'docx' ? undefined : 'none' }}>
        <DocxImport
          onLoadToEditor={handleLoadToEditor}
          model={model}
          tables={tableDefs}
          onTablesChange={handleTablesChange}
          showAi={loggedIn}
          agentApiId={editorAgentApiId}
          onCreateWithAgent={loggedIn ? handleDocxCreateWithAgent : undefined}
          existingFeatureGuids={existingFeatureGuids}
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
                  lang === 'de' ? 'Tabellen-Identifikation' : 'Table Identification',
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
      </div>

      {/* Agent reset confirm dialog */}
      {deleteAgentConfirm && (
        <ConfirmDialog
          title="Agenten zurücksetzen?"
          message="Der Chatverlauf und Kontext werden gelöscht. Ein neuer Agent mit dem aktuellen System-Prompt wird sofort erstellt."
          confirmLabel="Ja, zurücksetzen"
          cancelLabel="Abbrechen"
          onConfirm={() => { deleteAgentConfirm.resolve(true); setDeleteAgentConfirm(null); }}
          onCancel={() => { deleteAgentConfirm.resolve(false); setDeleteAgentConfirm(null); }}
        />
      )}
    </>
  );
}
