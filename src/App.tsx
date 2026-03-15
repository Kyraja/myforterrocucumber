import { useState, useRef, useCallback, useEffect, useMemo } from 'react';
import logoUrl from './assets/logo.png';
import JSZip from 'jszip';
import type { FeatureInput, TableDef, ParsedFeaturePackage } from './types/gherkin';
import type { Agent, AgentMessage, AgentContext } from './types/agent';
import { useGherkinGenerator } from './hooks/useGherkinGenerator';
import { generateGherkin } from './lib/generator';
import { useAiGeneration } from './hooks/useAiGeneration';
import { useAiRating } from './hooks/useAiRating';
import type { AiPromptRating } from './lib/aiPrompt';
import { useUndoRedo } from './hooks/useUndoRedo';
import { getModel, loadFeatures, saveFeatures, getCustomSystemPrompt } from './lib/settings';
import { DEFAULT_SYSTEM_PROMPT } from './lib/aiPrompt';
import { isLoggedIn, hasAuthCallback, handleAuthCallback, initiateLogin, getStoredClientId, getStoredApplicationId, getStoredClientSecret, createMftAgent, updateMftAgent, deleteMftAgent, chatWithAgent, chatCompletion } from './lib/myforterroApi';
import { loadTableDefs, saveTableDefs, migrateTableDefsFromLocalStorage, parseXlsx } from './lib/csvTableParser';
import { loadAgents, saveAgent, deleteAgent as deleteAgentFromDb } from './lib/agentStore';
import { parseGherkin } from './lib/gherkinParser';
import { useTranslation } from './i18n';
import { FeatureForm } from './components/FeatureForm/FeatureForm';
import { GherkinPreview } from './components/GherkinPreview/GherkinPreview';
import { ActionBar } from './components/ActionBar/ActionBar';
import { SettingsPanel } from './components/SettingsPanel/SettingsPanel';
import { HelpGuide } from './components/HelpGuide/HelpGuide';
import { TokenHistory } from './components/TokenHistory/TokenHistory';
import { CsvUpload } from './components/CsvUpload/CsvUpload';
import { BulkImport } from './components/BulkImport/BulkImport';
import { DocxImport } from './components/DocxImport/DocxImport';
import { FlowDiagram } from './components/FlowDiagram/FlowDiagram';
import { StepToolbox } from './components/StepToolbox/StepToolbox';
import { FileExplorer } from './components/FileExplorer/FileExplorer';
import { AgentPanel } from './components/AgentPanel/AgentPanel';
import { ConfirmDialog } from './components/ConfirmDialog/ConfirmDialog';
import { useFileExplorer } from './hooks/useFileExplorer';
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
  const [view, setView] = useState<'editor' | 'bulk' | 'docx'>('editor');
  const initialFeatures = (() => {
    const saved = loadFeatures() as FeatureInput[] | null;
    return saved && saved.length > 0 ? saved : [INITIAL_FEATURE];
  })();
  const { value: features, set: setFeatures, undo, redo, canUndo, canRedo } = useUndoRedo(initialFeatures);
  const [activeFeatureIdx, setActiveFeatureIdx] = useState(0);
  const [tableDefs, setTableDefs] = useState<TableDef[]>([]);
  const [loggedIn, setLoggedIn] = useState(() => isLoggedIn());
  const [model, setModel] = useState(() => getModel() || '');
  const [authError, setAuthError] = useState<string | null>(null);

  // Agents
  const [agents, setAgents] = useState<Agent[]>([]);
  const [selectedFolderPath, setSelectedFolderPath] = useState<string | null>(null);
  const [selectedEfkAgentId, setSelectedEfkAgentId] = useState<string | null>(null);
  const [agentSending, setAgentSending] = useState(false);
  const [agentStreamingText, setAgentStreamingText] = useState<string | null>(null);
  const [agentConfirm, setAgentConfirm] = useState<{ folderPath: string; resolve: (v: boolean) => void } | null>(null);
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
  const [explorerWidth, setExplorerWidth] = useState(() => {
    const saved = localStorage.getItem('cucumbergnerator_explorer_width');
    return saved ? Number(saved) : 240;
  });
  const explorerWidthRef = useRef(explorerWidth);
  explorerWidthRef.current = explorerWidth;

  // Load tableDefs from IndexedDB on mount (async)
  useEffect(() => {
    let cancelled = false;
    (async () => {
      // Try migration from localStorage first (one-time)
      const migrated = await migrateTableDefsFromLocalStorage();
      if (cancelled) return;
      if (migrated) {
        setTableDefs(migrated);
        return;
      }
      const saved = await loadTableDefs();
      if (!cancelled) setTableDefs(saved);
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

  // Agent folder paths (Set for O(1) lookup in tree rendering)
  const agentFolderPaths = useMemo(
    () => new Set(agents.filter((a) => a.folderPath !== null).map((a) => a.folderPath!)),
    [agents],
  );

  // Determine current context folder (from active file path or selected folder)
  const currentFolder = fileExplorer.activeFilePath
    ? fileExplorer.activeFilePath.includes('/')
      ? fileExplorer.activeFilePath.substring(0, fileExplorer.activeFilePath.lastIndexOf('/'))
      : ''
    : selectedFolderPath;

  const activeAgent = currentFolder !== null
    ? (agents.find((a) => a.folderPath === currentFolder) ?? null)
    : null;

  // EFK agents — standalone agents created from DOCX uploads
  const efkAgents = useMemo(() => agents.filter((a) => a.agentKind === 'efk'), [agents]);
  const selectedEfkAgent = useMemo(() => efkAgents.find((a) => a.id === selectedEfkAgentId) ?? null, [efkAgents, selectedEfkAgentId]);

  // If previewMode is 'agent' but there's no active agent, fall back to toolbox
  const effectivePreviewMode = previewMode === 'agent' && !activeAgent ? 'toolbox' : previewMode;

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

  // Show custom confirm dialog for agent creation (returns a Promise)
  const showAgentConfirm = useCallback((folderPath: string): Promise<boolean> => {
    return new Promise((resolve) => {
      setAgentConfirm({ folderPath, resolve });
    });
  }, []);

  // Helper: handle errors from agent API calls
  const handleAgentError = useCallback((err: unknown) => {
    const raw = (err as Error).message ?? '';
    setAgentError(raw || 'Unbekannter Fehler');
  }, []);

  // Wrap createFolder to optionally create an agent for root-level folders
  const handleCreateFolder = useCallback(async (parentPath: string): Promise<string | null> => {
    const newPath = await fileExplorer.createFolder(parentPath);
    if (newPath && loggedIn && !newPath.includes('/')) {
      const createAgentChoice = await showAgentConfirm(newPath);
      if (createAgentChoice) {
        let apiAgentId: string | null = null;
        if (model) {
          try {
            const dto = await createMftAgent(newPath, model, buildAgentInstructions());
            apiAgentId = dto.agentId;
          } catch {
            // API agent creation failed — still create locally, will auto-migrate on first chat
          }
        }
        const newAgent: Agent = {
          id: crypto.randomUUID(),
          name: newPath,
          folderPath: newPath,
          apiAgentId,
          conversationId: null,
          messages: [],
          context: [],
          createdAt: Date.now(),
          updatedAt: Date.now(),
        };
        await saveAgent(newAgent);
        setAgents((prev) => [...prev, newAgent]);
      }
    }
    return newPath;
  }, [fileExplorer, loggedIn, showAgentConfirm, model, buildAgentInstructions]);

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

  // Extract plain text from a .dotm/.docx (Office Open XML) buffer
  const extractDocxText = useCallback(async (buffer: ArrayBuffer): Promise<string> => {
    const zip = await JSZip.loadAsync(buffer);
    const xml = await zip.file('word/document.xml')?.async('string');
    if (!xml) return '';
    return xml
      .replace(/<w:p[ >][^>]*>/gi, '\n')
      .replace(/<[^>]+>/g, '')
      .replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&apos;/g, "'")
      .replace(/[ \t]+/g, ' ')
      .replace(/\n{3,}/g, '\n\n')
      .trim();
  }, []);

  // Format parsed TableDef[] into a compact human+AI-readable context block
  const formatVartabContent = useCallback((tables: TableDef[]): string => {
    const lines: string[] = ['Verfügbare Datenbanken und Felder:'];
    for (const t of tables) {
      const header = t.kind === 'infosystem'
        ? `\n### Infosystem ${t.tableRef} — ${t.name}`
        : `\n### Datenbank ${t.tableRef} — ${t.name}`;
      lines.push(header);
      const fields = t.fields.filter((f) => !f.skip).map((f) => `- ${f.name}${f.description ? ` (${f.description})` : ''}`);
      lines.push(...fields);
    }
    return lines.join('\n');
  }, []);

  // AI-compress a document into a ~4000-char summary
  const summariseDoc = useCallback(async (fileName: string, text: string): Promise<string> => {
    if (!model) return text.slice(0, MAX_CONTEXT_CHARS_PER_FILE);
    const prompt = `Du bist ein Assistent für abas ERP-Berater. Fasse die wichtigsten Informationen aus diesem Dokument zusammen auf Deutsch:\n- Hauptanforderungen und Ziele\n- Alle erwähnten Feldnamen, Datenbanken, Masken\n- Prozessabläufe und Abweichungen vom Standard\n- Maximal 4000 Zeichen.\n\nDateiname: ${fileName}\n\n${text.slice(0, 80_000)}`;
    try {
      const summary = await chatCompletion([{ role: 'user', content: prompt }], model);
      return `[KI-Zusammenfassung]\n${summary}`;
    } catch {
      return text.slice(0, MAX_CONTEXT_CHARS_PER_FILE) + `\n[... auf ${MAX_CONTEXT_CHARS_PER_FILE.toLocaleString()} Zeichen gekürzt]`;
    }
  }, [model]);

  // Regenerate the EFK anchor from all efk entries after upload
  const buildEfkAnchor = useCallback(async (efkItems: AgentContext[]): Promise<AgentContext | null> => {
    if (!model || efkItems.length === 0) return null;
    const combined = efkItems.map((e, i) => `### Paket ${i + 1}: ${e.fileName}\n${e.content}`).join('\n\n');
    const prompt = `Erstelle eine kompakte Übersicht aller folgenden Einzelfunktionskonzepte (EFKs) für einen abas ERP Berater.\nFür jedes Paket: Name, Hauptzweck, wichtigste Datenbanken/Masken/Felder. Max. 3000 Zeichen gesamt.\n\n${combined.slice(0, 40_000)}`;
    try {
      const anchorText = await chatCompletion([{ role: 'user', content: prompt }], model);
      return { id: 'efk-anchor', fileName: '[EFK-Übersicht]', content: anchorText, type: 'efk-anchor', uploadedAt: Date.now() };
    } catch {
      return null;
    }
  }, [model]);

  // Agent: upload context files — type-aware processing
  const handleAgentUploadContext = useCallback(async (agentId: string, files: File[]) => {
    const agent = agents.find((a) => a.id === agentId);
    if (!agent) return;
    setAgentSending(true);
    setAgentStreamingText('Dateien werden analysiert...');
    try {
      const newItems: AgentContext[] = await Promise.all(
        files.map(async (file): Promise<AgentContext> => {
          const name = file.name.toLowerCase();
          const id = crypto.randomUUID();
          const uploadedAt = Date.now();

          if (name.endsWith('.xlsx') || name.endsWith('.xls')) {
            // VarTab — parse with existing logic, format as compact structured text
            const buffer = await file.arrayBuffer();
            const tables = parseXlsx(buffer);
            const content = formatVartabContent(tables);
            return { id, fileName: file.name, content, type: 'vartab', uploadedAt };
          }

          if (name.endsWith('.dotm') || name.endsWith('.docx')) {
            // EFK — extract Word XML text, then AI-summarise
            const buffer = await file.arrayBuffer();
            const rawText = await extractDocxText(buffer);
            const content = await summariseDoc(file.name, rawText);
            return { id, fileName: file.name, content, type: 'efk', uploadedAt };
          }

          // Generic document (CSV, txt, etc.) — include as-is or AI-compress if large
          const raw = await file.text();
          const content = raw.length > 15_000 ? await summariseDoc(file.name, raw) : raw;
          return { id, fileName: file.name, content, type: 'doc', uploadedAt };
        }),
      );

      // Rebuild EFK anchor if any EFKs were uploaded
      const allEfks = [...agent.context.filter((c) => c.type === 'efk'), ...newItems.filter((c) => c.type === 'efk')];
      const anchor = allEfks.length > 0 ? await buildEfkAnchor(allEfks) : null;

      // Replace old anchor + append new items
      const withoutOldAnchor = agent.context.filter((c) => c.type !== 'efk-anchor');
      const contextItems = anchor ? [...withoutOldAnchor, ...newItems, anchor] : [...withoutOldAnchor, ...newItems];

      const updated: Agent = { ...agent, context: contextItems, conversationId: null, updatedAt: Date.now() };
      setAgents((prev) => prev.map((a) => (a.id === agentId ? updated : a)));
      await saveAgent(updated);
    } catch (err) {
      handleAgentError(err);
    } finally {
      setAgentSending(false);
      setAgentStreamingText(null);
    }
  }, [agents, extractDocxText, formatVartabContent, summariseDoc, buildEfkAnchor, handleAgentError]);

  // Agent: remove a single context document and sync instructions to API
  const handleAgentRemoveContext = useCallback(async (agentId: string, contextId: string) => {
    const agent = agents.find((a) => a.id === agentId);
    if (!agent) return;
    // Reset conversationId so next message starts a new conversation with the updated context as preamble
    const updated: Agent = { ...agent, context: agent.context.filter((c) => c.id !== contextId), conversationId: null, updatedAt: Date.now() };
    setAgents((prev) => prev.map((a) => (a.id === agentId ? updated : a)));
    await saveAgent(updated);
  }, [agents]);

  // Agent: add agent to an existing folder (via context menu)
  const handleAddAgentToFolder = useCallback(async (folderPath: string) => {
    if (agents.some((a) => a.folderPath === folderPath)) return;
    const folderName = folderPath.split('/').pop() || folderPath;
    let apiAgentId: string | null = null;
    if (model) {
      try {
        const dto = await createMftAgent(folderName, model, buildAgentInstructions());
        apiAgentId = dto.agentId;
      } catch {
        // API creation failed — still create locally
      }
    }
    const newAgent: Agent = {
      id: crypto.randomUUID(),
      name: folderName,
      folderPath,
      apiAgentId,
      conversationId: null,
      messages: [],
      context: [],
      createdAt: Date.now(),
      updatedAt: Date.now(),
    };
    await saveAgent(newAgent);
    setAgents((prev) => [...prev, newAgent]);
  }, [agents, model, buildAgentInstructions]);

  // Agent: delete (with confirmation modal)
  const [deleteAgentConfirm, setDeleteAgentConfirm] = useState<{ agentId: string; resolve: (v: boolean) => void } | null>(null);

  const handleDeleteAgent = useCallback((agentId: string) => {
    new Promise<boolean>((resolve) => {
      setDeleteAgentConfirm({ agentId, resolve });
    }).then(async (confirmed) => {
      if (confirmed) {
        const agent = agents.find((a) => a.id === agentId);
        if (agent?.apiAgentId) {
          try { await deleteMftAgent(agent.apiAgentId); } catch { /* ignore */ }
        }
        await deleteAgentFromDb(agentId);
        setAgents((prev) => prev.filter((a) => a.id !== agentId));
      }
    });
  }, [agents]);

  // System prompt change: sync all existing API agents with new instructions
  const handleSystemPromptChange = useCallback(async () => {
    if (!model) return;
    agents.forEach(async (agent) => {
      if (agent.apiAgentId) {
        try {
          await updateMftAgent(agent.apiAgentId, agent.name, model, buildAgentInstructions());
        } catch { /* Non-fatal */ }
      }
    });
  }, [agents, model, buildAgentInstructions]);

  // Model change: sync all existing API agents to the new model
  const handleModelChange = useCallback(async (newModel: string) => {
    setModel(newModel);
    if (!newModel) return;
    agents.forEach(async (agent) => {
      if (agent.apiAgentId) {
        try {
          await updateMftAgent(agent.apiAgentId, agent.name, newModel, buildAgentInstructions());
        } catch { /* Non-fatal */ }
      }
    });
  }, [agents, buildAgentInstructions]);

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
      const featureInput = { ...INITIAL_FEATURE, name: newPath.split('/').pop()?.replace(/\.feature$/, '') || '' };
      setFeatures([featureInput]);
      setActiveFeatureIdx(0);
    }
  }, [fileExplorer, setFeatures]);

  // File explorer: handle file selection
  const handleExplorerSelectFile = useCallback(async (path: string) => {
    const featureInput = await fileExplorer.selectFile(path);
    if (featureInput) {
      setFeatures([featureInput]);
      setActiveFeatureIdx(0);
    }
  }, [fileExplorer, setFeatures]);

  // File explorer: handle scenario selection
  const handleExplorerSelectScenario = useCallback(async (filePath: string, scenarioId: string) => {
    const featureInput = await fileExplorer.selectScenario(filePath, scenarioId);
    if (featureInput) {
      setFeatures([featureInput]);
      setActiveFeatureIdx(0);
      // Scroll to scenario after a brief delay for render
      setTimeout(() => {
        const el = document.getElementById(`scenario-${scenarioId}`);
        if (el) {
          el.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      }, 100);
    }
  }, [fileExplorer, setFeatures]);

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

  const handleRequestRating = useCallback(() => {
    if (!feature.description.trim()) return;
    requestRating(feature.description, model, tableDefs);
  }, [feature.description, model, tableDefs, requestRating]);

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
    if (!feature.description.trim()) return;
    setAiRating(null);
    const result = await generate(feature.description, model, feature.testUser, tableDefs);
    if (result) {
      setAiRating(result.aiRating);
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

  // BulkImport / DocxImport "Bearbeiten" → add feature as new tab, switch to editor
  const handleLoadToEditor = (f: FeatureInput) => {
    setFeatures((prev) => [...prev, f]);
    setActiveFeatureIdx(features.length);
    setView('editor');
  };

  // DocxImport "Alle importieren" → replace all features with imported ones
  const handleImportAll = (imported: FeatureInput[]) => {
    if (imported.length === 0) return;
    setFeatures(imported);
    setActiveFeatureIdx(0);
    setView('editor');
  };

  // DocxImport "In Ordner importieren" → create folder structure on disk
  const handleImportToExplorer = useCallback(async (packages: ParsedFeaturePackage[], fileName: string) => {
    const folderName = window.prompt('Ordnername für den Import:', fileName);
    if (!folderName) return;

    const firstPath = await fileExplorer.importPackages(packages, '', folderName);
    if (firstPath) {
      // Load the first feature into the editor
      const featureInput = await fileExplorer.selectFile(firstPath);
      if (featureInput) {
        setFeatures([featureInput]);
        setActiveFeatureIdx(0);
      }
      setView('editor');
    }
  }, [fileExplorer, setFeatures]);

  // ── EFK Agent management ─────────────────────────────────────

  const handleCreateEfkAgent = useCallback(async (name: string, packages: ParsedFeaturePackage[]) => {
    if (!model) {
      setAgentError('Kein Modell ausgewählt. Bitte zuerst ein Modell in den Einstellungen wählen.');
      return;
    }
    setAgentSending(true);
    setAgentStreamingText('EFK-Agent wird erstellt...');
    try {
      // 1. Create API agent with system prompt as instructions
      let apiAgentId: string | null = null;
      try {
        const dto = await createMftAgent(name, model, buildAgentInstructions());
        apiAgentId = dto.agentId;
      } catch {
        // API agent creation failed — still create locally (auto-migrates on first chat)
      }

      // 2. Build context from EFK packages
      const efkItems: AgentContext[] = await Promise.all(
        packages.map(async (pkg): Promise<AgentContext> => {
          const heading = pkg.feature.name || pkg.sourceHeading || 'Unbenanntes Paket';
          const text = pkg.sourceText || pkg.feature.description || '';
          const content = await summariseDoc(heading, text);
          return { id: crypto.randomUUID(), fileName: heading, content, type: 'efk', uploadedAt: Date.now() };
        }),
      );

      // 3. Add vartab context if tables are loaded
      const contextItems: AgentContext[] = [...efkItems];
      if (tableDefs.length > 0) {
        const vartabContent = formatVartabContent(tableDefs);
        contextItems.push({ id: crypto.randomUUID(), fileName: 'Variablentabelle', content: vartabContent, type: 'vartab', uploadedAt: Date.now() });
      }

      // 4. Build EFK anchor (overview of all packages)
      const anchor = await buildEfkAnchor(efkItems);
      if (anchor) contextItems.push(anchor);

      // 5. Save agent
      const newAgent: Agent = {
        id: crypto.randomUUID(),
        name,
        agentKind: 'efk',
        folderPath: null,
        apiAgentId,
        conversationId: null,
        messages: [],
        context: contextItems,
        createdAt: Date.now(),
        updatedAt: Date.now(),
      };
      await saveAgent(newAgent);
      setAgents((prev) => [...prev, newAgent]);
      setSelectedEfkAgentId(newAgent.id);
    } catch (err) {
      handleAgentError(err);
    } finally {
      setAgentSending(false);
      setAgentStreamingText(null);
    }
  }, [model, tableDefs, buildAgentInstructions, summariseDoc, formatVartabContent, buildEfkAnchor, handleAgentError]);

  const handleDeleteEfkAgent = useCallback(async (agentId: string) => {
    const agent = agents.find((a) => a.id === agentId);
    if (agent?.apiAgentId) {
      try { await deleteMftAgent(agent.apiAgentId); } catch { /* ignore */ }
    }
    await deleteAgentFromDb(agentId);
    setAgents((prev) => prev.filter((a) => a.id !== agentId));
    if (selectedEfkAgentId === agentId) setSelectedEfkAgentId(null);
  }, [agents, selectedEfkAgentId]);

  // Sync vartab context when tableDefs change and an EFK agent is selected
  useEffect(() => {
    if (!selectedEfkAgent || tableDefs.length === 0) return;
    const withoutOldVartab = selectedEfkAgent.context.filter((c) => c.type !== 'vartab');
    const vartabContent = formatVartabContent(tableDefs);
    const vartabItem: AgentContext = { id: crypto.randomUUID(), fileName: 'Variablentabelle', content: vartabContent, type: 'vartab', uploadedAt: Date.now() };
    const updated: Agent = { ...selectedEfkAgent, context: [...withoutOldVartab, vartabItem], conversationId: null, updatedAt: Date.now() };
    setAgents((prev) => prev.map((a) => (a.id === updated.id ? updated : a)));
    saveAgent(updated);
  // Only trigger when tableDefs change, not on every agent re-render
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tableDefs]);

  // DocxImport "Mit Agent verarbeiten" — summarise EFK packages and add to active agent context
  const handleDocxSendToAgent = useCallback(async (packages: ParsedFeaturePackage[]) => {
    if (!activeAgent) {
      setAgentError('Kein Agent aktiv. Bitte zuerst einen Ordner mit Agent auswählen.');
      return;
    }
    if (packages.length === 0) return;

    setAgentSending(true);
    setAgentStreamingText('EFK-Pakete werden analysiert...');
    try {
      const newItems: AgentContext[] = await Promise.all(
        packages.map(async (pkg): Promise<AgentContext> => {
          const name = pkg.feature.name || pkg.sourceHeading || 'Unbenanntes Paket';
          const text = pkg.sourceText || pkg.feature.description || '';
          const content = await summariseDoc(name, text);
          return { id: crypto.randomUUID(), fileName: name, content, type: 'efk', uploadedAt: Date.now() };
        }),
      );

      const allEfks = [...activeAgent.context.filter((c) => c.type === 'efk'), ...newItems];
      const anchor = await buildEfkAnchor(allEfks);

      const withoutOldAnchor = activeAgent.context.filter((c) => c.type !== 'efk-anchor');
      const contextItems = anchor ? [...withoutOldAnchor, ...newItems, anchor] : [...withoutOldAnchor, ...newItems];

      const updated: Agent = { ...activeAgent, context: contextItems, conversationId: null, updatedAt: Date.now() };
      setAgents((prev) => prev.map((a) => (a.id === activeAgent.id ? updated : a)));
      await saveAgent(updated);

      // Switch to editor + agent panel so user can start chatting
      setView('editor');
      setPreviewMode('agent');
    } catch (err) {
      handleAgentError(err);
    } finally {
      setAgentSending(false);
      setAgentStreamingText(null);
    }
  }, [activeAgent, summariseDoc, buildEfkAnchor, handleAgentError]);

  // DocxImport "KI-Tests generieren" — create top-level folder + agent + import AI-generated tests
  const handleDocxCreateWithAgent = useCallback(async (pkgs: ParsedFeaturePackage[], docxFileName: string) => {
    const folderName = window.prompt('Ordnername für den Import (= Stamm-Ordner des Agenten):', docxFileName);
    if (!folderName) return;

    // Import into folder structure
    const firstPath = await fileExplorer.importPackages(pkgs, '', folderName);

    // Create agent on the top-level folder (not subfolders)
    let apiAgentId: string | null = null;
    if (model) {
      try {
        const dto = await createMftAgent(folderName, model, buildAgentInstructions());
        apiAgentId = dto.agentId;
      } catch {
        // API agent creation failed — still create locally
      }
    }
    const newAgent: Agent = {
      id: crypto.randomUUID(),
      name: folderName,
      folderPath: folderName,
      apiAgentId,
      conversationId: null,
      messages: [],
      context: [],
      createdAt: Date.now(),
      updatedAt: Date.now(),
    };
    setAgents((prev) => {
      // Don't add a duplicate if a local agent for this folder already exists
      if (prev.some((a) => a.folderPath === folderName)) return prev;
      return [...prev, newAgent];
    });
    await saveAgent(newAgent);

    if (firstPath) {
      const featureInput = await fileExplorer.selectFile(firstPath);
      if (featureInput) {
        setFeatures([featureInput]);
        setActiveFeatureIdx(0);
      }
      setSelectedFolderPath(folderName);
    }
    setView('editor');
    setPreviewMode('agent');
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
            {/* Bulk-Import: temporarily hidden
            <button
              className={view === 'bulk' ? styles.navItemActive : styles.navItem}
              onClick={() => setView('bulk')}
              type="button"
            >
              {t('app.bulkImport')}
            </button>
            */}
            <button
              className={view === 'docx' ? styles.navItemActive : styles.navItem}
              onClick={() => setView('docx')}
              type="button"
            >
              {t('app.docxImport')}
            </button>
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

      <div className={styles.app}>
      {/* Editor view — hidden (not unmounted) when bulk is active */}
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
                onCloseDirectory={fileExplorer.closeDirectory}
                onRefreshTree={fileExplorer.refreshTree}
                onCreateFolder={handleCreateFolder}
                onDeleteFolder={fileExplorer.deleteFolder}
                onCreateFile={handleExplorerCreateFile}
                onDeleteFile={fileExplorer.deleteFile}
                onMoveFile={fileExplorer.moveEntry}
                onRenameEntry={fileExplorer.renameEntry}
                onSetDragOverPath={fileExplorer.setDragOverPath}
                onDeselectFile={fileExplorer.deselectFile}
                agentFolderPaths={agentFolderPaths}
                onFolderSelect={setSelectedFolderPath}
                onAddAgent={handleAddAgentToFolder}
                isLoggedIn={loggedIn}
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
            {/* Show toolbar actions only when a file is open */}
            {fileExplorer.activeFilePath && (
              <>
                <CsvUpload tables={tableDefs} onTablesChange={handleTablesChange} />
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
                  ? 'Öffne einen Ordner im Explorer, um Feature-Dateien zu bearbeiten.'
                  : fileExplorer.isVisible
                    ? 'Wähle eine Feature-Datei aus dem Explorer, um sie zu bearbeiten.'
                    : 'Explorer einblenden (📁 oder Ctrl+B), um eine Feature-Datei auszuwählen.'}
              </div>
            </div>
          ) : (
            <>
              <FeatureForm
                feature={feature}
                onChange={updateFeature}
                showGenerate={loggedIn}
                onGenerate={handleGenerate}
                generating={loading}
                generationStep={generationStep}
                generateError={error}
                tables={tableDefs}
                aiRating={aiRating}
                standaloneAiRating={standaloneAiRating}
                onRequestRating={handleRequestRating}
                ratingLoading={ratingLoading}
                ratingError={ratingError}
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
                Baukasten
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
              onUploadContext={(files) => handleAgentUploadContext(activeAgent.id, files)}
              onRemoveContext={(contextId) => handleAgentRemoveContext(activeAgent.id, contextId)}
              onDeleteAgent={() => handleDeleteAgent(activeAgent.id)}
              error={agentError}
              onRetryLogin={handleAgentRetryLogin}
              onRetry={() => handleAgentRetry(activeAgent.id)}
              onNewConversation={() => handleAgentNewConversation(activeAgent.id)}
            />
          )}
        </section>
      </main>

      {/* Bulk Import view — hidden (not unmounted) when editor is active */}
      <main style={{ display: view === 'bulk' ? undefined : 'none' }}>
        <BulkImport
          model={model}
          testUser={feature.testUser}
          tables={tableDefs}
          onLoadToEditor={handleLoadToEditor}
        />
      </main>

      {/* Docx Import view — hidden (not unmounted) when other views are active */}
      <main style={{ display: view === 'docx' ? undefined : 'none' }}>
        <DocxImport
          onLoadToEditor={handleLoadToEditor}
          onImportAll={handleImportAll}
          onImportToExplorer={handleImportToExplorer}
          isDirectoryMode={fileExplorer.isDirectoryMode}
          model={model}
          tables={tableDefs}
          onTablesChange={handleTablesChange}
          showAi={loggedIn}
          onSendToAgent={loggedIn && activeAgent ? handleDocxSendToAgent : undefined}
          activeAgentName={activeAgent?.name ?? null}
          onCreateWithAgent={loggedIn ? handleDocxCreateWithAgent : undefined}
          efkAgents={efkAgents}
          selectedEfkAgentId={selectedEfkAgentId}
          onSelectEfkAgent={setSelectedEfkAgentId}
          onCreateEfkAgent={handleCreateEfkAgent}
          onDeleteEfkAgent={handleDeleteEfkAgent}
        />
      </main>
      </div>

      {/* Agent creation confirm dialog */}
      {agentConfirm && (
        <ConfirmDialog
          title="Agenten erstellen?"
          message={`Möchtest du für den Ordner „${agentConfirm.folderPath}" einen Agenten erstellen?\n\nMit einem Agenten kannst du KI-Hilfe direkt im Kontext dieses Ordners nutzen und z.\u202fB. eine Variablentabelle als Kontext hinterlegen.`}
          confirmLabel="Ja, Agent erstellen"
          cancelLabel="Nein, danke"
          onConfirm={() => { agentConfirm.resolve(true); setAgentConfirm(null); }}
          onCancel={() => { agentConfirm.resolve(false); setAgentConfirm(null); }}
        />
      )}

      {/* Agent delete confirm dialog */}
      {deleteAgentConfirm && (
        <ConfirmDialog
          title="Agenten löschen?"
          message="Der gesamte Chatverlauf und der hochgeladene Kontext werden unwiderruflich gelöscht."
          confirmLabel="Ja, löschen"
          cancelLabel="Abbrechen"
          onConfirm={() => { deleteAgentConfirm.resolve(true); setDeleteAgentConfirm(null); }}
          onCancel={() => { deleteAgentConfirm.resolve(false); setDeleteAgentConfirm(null); }}
        />
      )}
    </>
  );
}
