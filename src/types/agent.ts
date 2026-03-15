export interface AgentMessage {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: number;
}

export type AgentKind = 'folder' | 'efk';

export type AgentContextType = 'vartab' | 'efk' | 'efk-anchor' | 'doc';

export interface AgentContext {
  id: string;
  fileName: string;
  content: string;
  /** Distinguishes how this context is processed and included in chat preamble */
  type: AgentContextType;
  uploadedAt: number;
}

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
