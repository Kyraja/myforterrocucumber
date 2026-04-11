/**
 * Type definitions for AI agents that are linked to FOP folders or standalone
 * EFK (EFOP) files.  Each agent maintains its own conversation history and a
 * set of uploaded context documents (variable tables, anchor documents, etc.)
 * which are injected into the chat preamble on every API call.
 */

/** A single message in an agent conversation (user turn or assistant reply). */
export interface AgentMessage {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: number;
}

/**
 * Distinguishes agents linked to a top-level folder (watching all FOPs in the
 * folder) from standalone agents tied to a single EFK file.
 */
export type AgentKind = 'folder' | 'efk';

/**
 * How an uploaded context document is processed before being injected into
 * the chat preamble.
 * - `vartab` — variable table CSV; parsed into structured field lists
 * - `efk` — EFK/FOP source file; included as raw code
 * - `efk-anchor` — anchor document that scopes the agent to specific FOPs
 * - `doc` — free-form documentation or requirements text
 */
export type AgentContextType = 'vartab' | 'efk' | 'efk-anchor' | 'doc';

/** A single uploaded context document attached to an agent. */
export interface AgentContext {
  id: string;
  fileName: string;
  content: string;
  /** Distinguishes how this context is processed and included in chat preamble */
  type: AgentContextType;
  uploadedAt: number;
}

/**
 * Persistent agent configuration stored in app state.
 * An agent wraps a MyForterro API agent with local metadata, a message
 * history, and multiple context documents.  `apiAgentId` and `conversationId`
 * are populated on first sync with the remote API and remain null until then.
 */
export interface Agent {
  id: string;
  name: string;
  /** Distinguishes folder-linked agents from standalone EFK agents. Defaults to 'folder'. */
  agentKind?: AgentKind;
  /** Path of the linked top-level folder. null for standalone agents. */
  folderPath: string | null;
  /** Real agent ID from the MyForterro API. null until first sync. */
  apiAgentId: string | null;
  /** Active conversation ID from the MyForterro API. null = new conversation on next chat. */
  conversationId: string | null;
  messages: AgentMessage[];
  /** Multiple context documents (e.g. Variablentabelle, Begleitdokumente) */
  context: AgentContext[];
  createdAt: number;
  updatedAt: number;
}
