/**
 * @module useAgentActivity
 * Hook for tracking the live status and conversation history of AI agent runs.
 *
 * Each agent type (Cucumber, FOP analyst, guidelines, rating, bulk, ...) has
 * its own independent run slot in the `runs` map so multiple agents can run
 * simultaneously. Every run contains a {@link WorkflowStep} array that drives
 * the `WorkflowTimeline` UI component.
 *
 * Completed runs are persisted as {@link SavedConversation} entries. Storage
 * uses the open project directory (`.agent-history.json`) when available,
 * falling back to `localStorage` otherwise.
 */

import { useState, useCallback, useRef, useMemo } from 'react';
import type { AgentRun, AgentRunHistoryItem, WorkflowStep, AgentType } from '../types/fop';
import { createEmitter, type WorkflowEmitter } from '../lib/workflowEmitter';

export type { AgentType } from '../types/fop';

const AGENT_LABELS: Record<AgentType, { de: string; en: string }> = {
  'cucumber':        { de: 'Cucumber Agent',        en: 'Cucumber Agent' },
  'fop-analyst':     { de: 'FOP Inhaltsanalyst',    en: 'FOP Content Analyst' },
  'fop-guidelines':  { de: 'FOP Richtlinienprüfer', en: 'FOP Guidelines Checker' },
  'rating':          { de: 'Bewertungs-Agent',      en: 'Rating Agent' },
  'bulk':            { de: 'Bulk-Generierung',      en: 'Bulk Generation' },
  'fop-cucumber':    { de: 'FOP→Cucumber Agent',    en: 'FOP→Cucumber Agent' },
  'agent-chat':      { de: 'Chat-Agent',            en: 'Chat Agent' },
};

// ── Saved conversation type ────────────────────────────────────

/**
 * A completed agent run serialized for persistence.
 * Version 2 stores the full workflow timeline instead of a single input/output
 * snapshot.
 */
export interface SavedConversation {
  /** Schema version. Entries without a version are treated as legacy and skipped. */
  version?: 2;
  /** UUID — primary key used for deletion. */
  id: string;
  agentType: AgentType;
  /** Localized display name of the agent. */
  agentLabel: string;
  /** Unix timestamp (ms) when the conversation was saved. */
  savedAt: number;
  /** Human-readable title derived from `currentItem` or the first history entry. */
  title: string;
  /** Full timeline captured during the run. */
  steps: WorkflowStep[];
  history: AgentRunHistoryItem[];
  /** Wall-clock duration of the run in milliseconds. */
  durationMs?: number;
}

const HISTORY_FILENAME = '.agent-history.json';
const MAX_SAVED = 500;

/** Strip pre-v2 records — we no longer migrate them (user wipes the file). */
function filterV2(entries: unknown[]): SavedConversation[] {
  return entries.filter((e): e is SavedConversation => {
    if (!e || typeof e !== 'object') return false;
    const rec = e as { version?: unknown; steps?: unknown };
    return rec.version === 2 && Array.isArray(rec.steps);
  });
}

/** Load conversations from a directory handle (.agent-history.json) */
export async function loadConversationsFromDir(
  dir: FileSystemDirectoryHandle,
): Promise<SavedConversation[]> {
  try {
    const fh = await dir.getFileHandle(HISTORY_FILENAME);
    const file = await fh.getFile();
    const text = await file.text();
    const parsed = JSON.parse(text);
    return Array.isArray(parsed) ? filterV2(parsed) : [];
  } catch {
    return [];
  }
}

/** Save conversations to a directory handle (.agent-history.json) */
export async function saveConversationsToDir(
  dir: FileSystemDirectoryHandle,
  conversations: SavedConversation[],
): Promise<void> {
  try {
    const trimmed = conversations.slice(-MAX_SAVED);
    const fh = await dir.getFileHandle(HISTORY_FILENAME, { create: true });
    const writable = await fh.createWritable();
    await writable.write(JSON.stringify(trimmed, null, 2));
    await writable.close();
  } catch {
    // Permission denied or dir not writable — ignore
  }
}

// Fallback: localStorage for when no directory is open
const LS_KEY = 'cucumbergnerator_agent_conversations';

function loadFromLocalStorage(): SavedConversation[] {
  try {
    const raw = localStorage.getItem(LS_KEY);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? filterV2(parsed) : [];
  } catch { return []; }
}

function saveToLocalStorage(conversations: SavedConversation[]): void {
  try {
    localStorage.setItem(LS_KEY, JSON.stringify(conversations.slice(-MAX_SAVED)));
  } catch { /* storage full */ }
}

function buildTitle(run: AgentRun): string {
  if (run.currentItem) return run.currentItem;
  if (run.history.length > 0) return run.history[run.history.length - 1].item;
  return new Date().toLocaleString();
}

// ── Hook ───────────────────────────────────────────────────────

/** Return type of {@link useAgentActivity}. */
export interface UseAgentActivityReturn {
  runs: Map<AgentType, AgentRun>;
  savedConversations: SavedConversation[];
  startRun: (type: AgentType, total?: number) => void;
  setCurrentItem: (type: AgentType, current: number, currentItem: string) => void;
  /** Append a step to the run's timeline. */
  pushStep: (type: AgentType, step: WorkflowStep) => void;
  /** Patch an existing step (looked up by id) in the run's timeline. */
  updateStep: (type: AgentType, id: string, patch: Partial<WorkflowStep>) => void;
  /** Obtain a {@link WorkflowEmitter} bound to a specific run slot. */
  getEmitter: (type: AgentType) => WorkflowEmitter;
  completeItem: (type: AgentType, item: string, success: boolean) => void;
  finishRun: (type: AgentType, status: 'done' | 'error') => void;
  clearRun: (type: AgentType) => void;
  /** Remove every run from the live map (used to clear the side-panel timeline). */
  clearAllRuns: () => void;
  deleteSaved: (id: string) => void;
  initConversations: (convs: SavedConversation[]) => void;
  getActiveRuns: () => AgentRun[];
  lang: 'de' | 'en';
  // ── Legacy shims — used by not-yet-migrated call sites. Forward to the
  //    new timeline so everything still shows up in WorkflowTimeline. These
  //    will be removed once App.tsx / DocxImport are migrated to emitters.
  /** @deprecated use `getEmitter(type).emitAiCall(...)` instead. */
  updateProgress: (type: AgentType, current: number, currentItem: string, inputSnapshot?: string, outputSoFar?: string) => void;
  /** @deprecated use `getEmitter(type).emitAiCall(...)` instead. */
  addExchange: (type: AgentType, label: string, input: string, output?: string) => void;
  /** @deprecated use `getEmitter(type).emitAiCall(...)` instead. */
  updateLastExchange: (type: AgentType, output: string) => void;
  /** @deprecated use `getEmitter(type).emitAiCall(...)` instead. */
  clearExchanges: (type: AgentType) => void;
}

/**
 * Hook for tracking AI agent run status and conversation history.
 */
export function useAgentActivity(lang: 'de' | 'en' = 'de'): UseAgentActivityReturn {
  const [runs, setRuns] = useState<Map<AgentType, AgentRun>>(new Map());
  const [savedConversations, setSavedConversations] = useState<SavedConversation[]>(loadFromLocalStorage);
  const startTimesRef = useRef<Map<AgentType, number>>(new Map());

  const startRun = useCallback((type: AgentType, total?: number) => {
    startTimesRef.current.set(type, Date.now());
    setRuns(prev => {
      const existing = prev.get(type);
      // Preserve steps from a stub that was lazy-created via pushStep before
      // startRun fired (a common React batching race: emitter runs sync inside
      // an async handler while startRun is queued from a useEffect). A run
      // that already finished (done/error) is a fresh start and is replaced.
      const preserveSteps = existing?.status === 'running';
      const next = new Map(prev);
      next.set(type, {
        agentType: type,
        agentLabel: AGENT_LABELS[type][lang],
        status: 'running',
        progress: total ? { current: 0, total } : undefined,
        steps: preserveSteps ? existing.steps : [],
        exchanges: [],
        history: [],
        startedAt: preserveSteps ? (existing.startedAt ?? Date.now()) : Date.now(),
      });
      return next;
    });
  }, [lang]);

  const setCurrentItem = useCallback((type: AgentType, current: number, currentItem: string) => {
    setRuns(prev => {
      const run = prev.get(type);
      if (!run) return prev;
      const next = new Map(prev);
      next.set(type, {
        ...run,
        progress: run.progress ? { ...run.progress, current } : { current, total: current },
        currentItem,
      });
      return next;
    });
  }, []);

  /** Build a fresh empty run for lazy-creation when an emitter fires before startRun. */
  const createStubRun = useCallback((type: AgentType): AgentRun => ({
    agentType: type,
    agentLabel: AGENT_LABELS[type][lang],
    status: 'running',
    steps: [],
    exchanges: [],
    history: [],
    startedAt: Date.now(),
  }), [lang]);

  const pushStep = useCallback((type: AgentType, step: WorkflowStep) => {
    setRuns(prev => {
      const run = prev.get(type) ?? createStubRun(type);
      // Register start time so finishRun can compute duration.
      if (!startTimesRef.current.has(type)) startTimesRef.current.set(type, Date.now());
      const next = new Map(prev);
      next.set(type, { ...run, steps: [...run.steps, step] });
      return next;
    });
  }, [createStubRun]);

  const updateStep = useCallback((type: AgentType, id: string, patch: Partial<WorkflowStep>) => {
    setRuns(prev => {
      const run = prev.get(type);
      if (!run) return prev;
      const idx = run.steps.findIndex(s => s.id === id);
      if (idx < 0) return prev;
      const nextSteps = [...run.steps];
      // Cast via unknown because patching a union member preserves its discriminant.
      nextSteps[idx] = { ...nextSteps[idx], ...patch } as WorkflowStep;
      const next = new Map(prev);
      next.set(type, { ...run, steps: nextSteps });
      return next;
    });
  }, []);

  const completeItem = useCallback((type: AgentType, item: string, success: boolean) => {
    const startTime = startTimesRef.current.get(type) ?? Date.now();
    const historyItem: AgentRunHistoryItem = {
      item,
      status: success ? 'done' : 'error',
      completedAt: Date.now(),
      durationMs: Date.now() - startTime,
    };
    setRuns(prev => {
      const run = prev.get(type);
      if (!run) return prev;
      const next = new Map(prev);
      const history = [historyItem, ...run.history].slice(0, 10);
      next.set(type, { ...run, history });
      return next;
    });
  }, []);

  const finishRun = useCallback((type: AgentType, status: 'done' | 'error') => {
    setRuns(prev => {
      const run = prev.get(type);
      if (!run) return prev;
      const finished = { ...run, status };
      const next = new Map(prev);
      next.set(type, finished);

      if (finished.steps.length > 0 || finished.history.length > 0) {
        const conv: SavedConversation = {
          version: 2,
          id: crypto.randomUUID(),
          agentType: type,
          agentLabel: AGENT_LABELS[type][lang],
          savedAt: Date.now(),
          title: buildTitle(finished),
          steps: finished.steps,
          history: finished.history,
          durationMs: finished.startedAt ? Date.now() - finished.startedAt : undefined,
        };
        setSavedConversations(prev => {
          const updated = [...prev, conv];
          saveToLocalStorage(updated);
          return updated;
        });
      }

      return next;
    });
  }, [lang]);

  const clearRun = useCallback((type: AgentType) => {
    setRuns(prev => {
      const next = new Map(prev);
      next.delete(type);
      return next;
    });
  }, []);

  const clearAllRuns = useCallback(() => {
    setRuns(new Map());
  }, []);

  const deleteSaved = useCallback((id: string) => {
    setSavedConversations(prev => {
      const updated = prev.filter(c => c.id !== id);
      saveToLocalStorage(updated);
      return updated;
    });
  }, []);

  const initConversations = useCallback((convs: SavedConversation[]) => {
    setSavedConversations(convs);
  }, []);

  const getActiveRuns = useCallback((): AgentRun[] => {
    return Array.from(runs.values()).filter(r => r.status !== 'idle');
  }, [runs]);

  // Stable emitter factory: reads and writes through the current hook setters.
  // Each call returns a fresh emitter bound to `type`; we memoize per-type so
  // referential identity is stable across renders.
  const emitterCache = useRef<Map<AgentType, WorkflowEmitter>>(new Map());
  const getEmitter = useCallback((type: AgentType): WorkflowEmitter => {
    const cached = emitterCache.current.get(type);
    if (cached) return cached;
    const emitter = createEmitter({
      pushStep: (step) => pushStep(type, step),
      updateStep: (id, patch) => updateStep(type, id, patch),
    });
    emitterCache.current.set(type, emitter);
    return emitter;
  }, [pushStep, updateStep]);

  // ── Legacy shims forwarding to the timeline ───────────────────
  // These preserve the old call-site semantics by synthesising AI steps.
  // Migrated workflows should call getEmitter(...).emitAiCall(...) directly
  // instead of going through these shims.

  const updateProgress = useCallback((type: AgentType, current: number, currentItem: string, _inputSnapshot?: string, _outputSoFar?: string) => {
    setCurrentItem(type, current, currentItem);
  }, [setCurrentItem]);

  // Legacy no-ops: call sites that still use these now emit nothing. Workflows
  // that want timeline visibility must call getEmitter(...).emitAiCall(...).
  const addExchange = useCallback((_type: AgentType, _label: string, _input: string, _output?: string) => {
    /* no-op — workflow timeline is driven by emitters */
  }, []);

  const updateLastExchange = useCallback((_type: AgentType, _output: string) => {
    /* no-op — workflow timeline is driven by emitters */
  }, []);

  const clearExchanges = useCallback((_type: AgentType) => {
    // No-op: timeline keeps a full history; old call sites used this to reset
    // the current-item chat area. Not meaningful in the new model.
  }, []);

  return useMemo(() => ({
    runs, savedConversations, startRun, setCurrentItem,
    pushStep, updateStep, getEmitter,
    completeItem, finishRun, clearRun, clearAllRuns,
    deleteSaved, initConversations, getActiveRuns, lang,
    // legacy
    updateProgress, addExchange, updateLastExchange, clearExchanges,
  }), [
    runs, savedConversations, startRun, setCurrentItem,
    pushStep, updateStep, getEmitter,
    completeItem, finishRun, clearRun, clearAllRuns,
    deleteSaved, initConversations, getActiveRuns, lang,
    updateProgress, addExchange, updateLastExchange, clearExchanges,
  ]);
}
