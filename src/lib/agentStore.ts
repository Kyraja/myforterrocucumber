/**
 * @module agentStore
 *
 * IndexedDB persistence layer for AI agent configurations.
 *
 * Agents represent named AI assistants with specific system prompts, model
 * settings, and attached context documents. They are stored in IndexedDB so
 * they persist across page reloads without a backend.
 *
 * The {@link normalize} function handles schema migrations: older records may
 * have `context` as a single object or null instead of the current array
 * format, and may be missing newer fields like `agentKind`.
 */

import { openDb, IDB_AGENTS_STORE } from './idb';
import type { Agent, AgentContext } from '../types/agent';

/** Migrate agents stored with old formats to the current schema. */
function normalize(raw: unknown): Agent {
  const a = raw as Agent & { context: AgentContext | AgentContext[] | null | undefined };
  let context: AgentContext[];
  if (!a.context) {
    context = [];
  } else if (Array.isArray(a.context)) {
    // Ensure each item has an id (in case very old entries lack one)
    context = (a.context as AgentContext[]).map((c) => ({
      ...c,
      id: c.id ?? crypto.randomUUID(),
      type: c.type ?? 'doc',
    }));
  } else {
    // Single object — wrap in array
    const single = a.context as AgentContext;
    context = [{ ...single, id: single.id ?? crypto.randomUUID(), type: single.type ?? 'doc' }];
  }
  return {
    ...a,
    context,
    agentKind: a.agentKind ?? 'folder',
    apiAgentId: a.apiAgentId ?? null,
    conversationId: a.conversationId ?? null,
  };
}

/**
 * Loads all agents from IndexedDB, applying schema normalization to each entry.
 *
 * @returns All stored agents in insertion order
 */
export async function loadAgents(): Promise<Agent[]> {
  const db = await openDb();
  return new Promise((resolve, reject) => {
    const tx = db.transaction(IDB_AGENTS_STORE, 'readonly');
    const req = tx.objectStore(IDB_AGENTS_STORE).getAll();
    req.onsuccess = () => resolve((req.result as unknown[]).map(normalize));
    req.onerror = () => reject(req.error);
  });
}

/**
 * Persists an agent to IndexedDB, creating or overwriting the entry with the same id.
 *
 * @param agent - The agent to save; `agent.id` is used as the object store key
 */
export async function saveAgent(agent: Agent): Promise<void> {
  const db = await openDb();
  return new Promise((resolve, reject) => {
    const tx = db.transaction(IDB_AGENTS_STORE, 'readwrite');
    tx.objectStore(IDB_AGENTS_STORE).put(agent, agent.id);
    tx.oncomplete = () => resolve();
    tx.onerror = () => reject(tx.error);
  });
}

/**
 * Removes an agent from IndexedDB by its id.
 * Resolves silently if the id does not exist.
 *
 * @param id - The agent's unique identifier
 */
export async function deleteAgent(id: string): Promise<void> {
  const db = await openDb();
  return new Promise((resolve, reject) => {
    const tx = db.transaction(IDB_AGENTS_STORE, 'readwrite');
    tx.objectStore(IDB_AGENTS_STORE).delete(id);
    tx.oncomplete = () => resolve();
    tx.onerror = () => reject(tx.error);
  });
}
