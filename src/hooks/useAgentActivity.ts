/**
 * @module useAgentActivity
 * Hook for tracking the live status and conversation history of AI agent runs.
 *
 * Three agent types are supported: the Cucumber generator, the FOP content
 * analyst, and the FOP guidelines checker. Each type has an independent run
 * slot so that multiple agents can be active simultaneously.
 *
 * Completed runs are persisted as {@link SavedConversation} entries. Storage
 * uses the open project directory (`.agent-history.json`) when available,
 * falling back to `localStorage` otherwise.
 */

import { useState, useCallback, useRef } from 'react';
import type { AgentRun, AgentRunHistoryItem } from '../types/fop';

/** Identifies which AI agent a run belongs to. */
export type AgentType = 'cucumber' | 'fop-analyst' | 'fop-guidelines';

const AGENT_LABELS: Record<AgentType, { de: string; en: string }> = {
  'cucumber':        { de: 'Cucumber Agent',        en: 'Cucumber Agent' },
  'fop-analyst':     { de: 'FOP Inhaltsanalyst',    en: 'FOP Content Analyst' },
  'fop-guidelines':  { de: 'FOP Richtlinienprüfer', en: 'FOP Guidelines Checker' },
};

// ── Saved conversation type ────────────────────────────────────

/**
 * A completed agent run serialized for persistence.
 * Title is derived from the last processed item or the run timestamp.
 */
export interface SavedConversation {
  /** UUID — primary key used for deletion. */
  id: string;
  agentType: AgentType;
  /** Localized display name of the agent. */
  agentLabel: string;
  /** Unix timestamp (ms) when the conversation was saved. */
  savedAt: number;
  /** Human-readable title derived from `currentItem` or the first history entry. */
  title: string;
  /** Snapshot of the input text sent to the AI (for display in history). */
  inputSnapshot?: string;
  /** Last AI response text (for display in history). */
  outputSoFar?: string;
  history: AgentRunHistoryItem[];
  /** Wall-clock duration of the run in milliseconds. */
  durationMs?: number;
}

const HISTORY_FILENAME = '.agent-history.json';
const MAX_SAVED = 500; // generous limit for file storage

/** Load conversations from a directory handle (.agent-history.json) */
export async function loadConversationsFromDir(
  dir: FileSystemDirectoryHandle,
): Promise<SavedConversation[]> {
  try {
    const fh = await dir.getFileHandle(HISTORY_FILENAME);
    const file = await fh.getFile();
    const text = await file.text();
    const parsed = JSON.parse(text);
    return Array.isArray(parsed) ? parsed : [];
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
    return Array.isArray(parsed) ? parsed : [];
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
  updateProgress: (type: AgentType, current: number, currentItem: string, inputSnapshot?: string, outputSoFar?: string) => void;
  /** Add a completed exchange (request+response) to the chat history */
  addExchange: (type: AgentType, label: string, input: string, output?: string) => void;
  /** Update the last exchange's output (e.g. when KI response arrives) */
  updateLastExchange: (type: AgentType, output: string) => void;
  /** Clear exchanges for the current item (called when a new AP starts) */
  clearExchanges: (type: AgentType) => void;
  completeItem: (type: AgentType, item: string, success: boolean) => void;
  finishRun: (type: AgentType, status: 'done' | 'error') => void;
  clearRun: (type: AgentType) => void;
  deleteSaved: (id: string) => void;
  /** Replace all saved conversations (called when loading from file) */
  initConversations: (convs: SavedConversation[]) => void;
  getActiveRuns: () => AgentRun[];
  lang: 'de' | 'en';
}

/**
 * Hook for tracking AI agent run status and conversation history.
 *
 * Each agent type has its own independent run slot in the `runs` map.
 * Completed runs are automatically persisted via `saveToLocalStorage` (or the
 * project directory file when available via `saveConversationsToDir`).
 * Start times are tracked in a ref (not state) to keep duration calculation
 * out of the render cycle.
 *
 * @param lang - UI language; controls agent label localisation.
 * @returns {@link UseAgentActivityReturn}
 */
export function useAgentActivity(lang: 'de' | 'en' = 'de'): UseAgentActivityReturn {
  const [runs, setRuns] = useState<Map<AgentType, AgentRun>>(new Map());
  const [savedConversations, setSavedConversations] = useState<SavedConversation[]>(loadFromLocalStorage);
  const startTimesRef = useRef<Map<AgentType, number>>(new Map());

  const startRun = useCallback((type: AgentType, total?: number) => {
    startTimesRef.current.set(type, Date.now());
    setRuns(prev => {
      const next = new Map(prev);
      next.set(type, {
        agentType: type,
        agentLabel: AGENT_LABELS[type][lang],
        status: 'running',
        progress: total ? { current: 0, total } : undefined,
        exchanges: [],
        history: [],
        startedAt: Date.now(),
      });
      return next;
    });
  }, [lang]);

  const updateProgress = useCallback((type: AgentType, current: number, currentItem: string, inputSnapshot?: string, outputSoFar?: string) => {
    setRuns(prev => {
      const run = prev.get(type);
      if (!run) return prev;
      const next = new Map(prev);
      next.set(type, {
        ...run,
        progress: run.progress ? { ...run.progress, current } : { current, total: current },
        currentItem,
        inputSnapshot: inputSnapshot ?? run.inputSnapshot,
        outputSoFar: outputSoFar ?? run.outputSoFar,
      });
      return next;
    });
  }, []);

  const addExchange = useCallback((type: AgentType, label: string, input: string, output?: string) => {
    setRuns(prev => {
      const run = prev.get(type);
      if (!run) return prev;
      const next = new Map(prev);
      next.set(type, {
        ...run,
        exchanges: [...(run.exchanges || []), { label, input, output }],
      });
      return next;
    });
  }, []);

  const updateLastExchange = useCallback((type: AgentType, output: string) => {
    setRuns(prev => {
      const run = prev.get(type);
      if (!run || !run.exchanges || run.exchanges.length === 0) return prev;
      const next = new Map(prev);
      const exchanges = [...run.exchanges];
      exchanges[exchanges.length - 1] = { ...exchanges[exchanges.length - 1], output };
      next.set(type, { ...run, exchanges });
      return next;
    });
  }, []);

  const clearExchanges = useCallback((type: AgentType) => {
    setRuns(prev => {
      const run = prev.get(type);
      if (!run) return prev;
      const next = new Map(prev);
      next.set(type, { ...run, exchanges: [] });
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

      // Save completed run to localStorage
      if (finished.inputSnapshot || finished.outputSoFar || finished.history.length > 0) {
        const conv: SavedConversation = {
          id: crypto.randomUUID(),
          agentType: type,
          agentLabel: AGENT_LABELS[type][lang],
          savedAt: Date.now(),
          title: buildTitle(finished),
          inputSnapshot: finished.inputSnapshot,
          outputSoFar: finished.outputSoFar,
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

  return { runs, savedConversations, startRun, updateProgress, addExchange, updateLastExchange, clearExchanges, completeItem, finishRun, clearRun, deleteSaved, initConversations, getActiveRuns, lang };
}
