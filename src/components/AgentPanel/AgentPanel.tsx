/**
 * @module AgentPanel
 * Chat UI panel for interacting with a configured myForterro AI agent.
 *
 * Renders the conversation history, a streaming response placeholder (typing
 * indicator → streamed text), and an input area that submits on Enter
 * (Shift+Enter inserts a line break). Error states distinguish session
 * expiry (shows a "Log in" button) from retryable API errors.
 */

import { useState, useRef, useEffect } from 'react';
import type { Agent } from '../../types/agent';
import styles from './AgentPanel.module.css';

/** Props for {@link AgentPanel}. */
interface AgentPanelProps {
  /** The agent configuration including conversation history and context documents. */
  agent: Agent;
  /** AI model identifier displayed in the header badge. */
  model: string;
  /** True while a message is being sent or a response is streaming. */
  isSending: boolean;
  /** Partial response text arriving via streaming; `null` before first token. */
  streamingText: string | null;
  /** Last error message, or `null` when clean. */
  error: string | null;
  /** Called when the user submits a message. */
  onSendMessage: (text: string) => Promise<void>;
  /** Reset the agent (clears prompt and conversation). */
  onDeleteAgent: () => void;
  /** Trigger re-authentication (shown for session-expiry errors). */
  onRetryLogin: () => void;
  /** Retry the last user message (shown for non-session errors when last message is from user). */
  onRetry: () => void;
  /** Start a new conversation (clears chat history, keeps agent config). */
  onNewConversation: () => void;
}

/**
 * Chat panel for a single AI agent.
 *
 * The message list auto-scrolls to the bottom on each new message.
 * The "efk-anchor" context type is excluded from the context count badge
 * because it is injected automatically and not visible to the user.
 */
export function AgentPanel({
  agent,
  model,
  isSending,
  streamingText,
  error,
  onSendMessage,
  onDeleteAgent,
  onRetryLogin,
  onRetry,
  onNewConversation,
}: AgentPanelProps) {
  const [tab, setTab] = useState<'chat' | 'context'>('chat');
  const [inputText, setInputText] = useState('');
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [agent.messages.length]);

  const handleSend = async () => {
    const text = inputText.trim();
    if (!text || isSending) return;
    setInputText('');
    await onSendMessage(text);
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  // Visible count: don't count the auto-generated anchor toward the badge
  const contextCount = agent.context.filter((c) => c.type !== 'efk-anchor').length;

  return (
    <div className={styles.panel}>
      <div className={styles.header}>
        <span className={styles.agentIcon}>🤖</span>
        <span className={styles.agentName}>{agent.name}</span>
        {model && <span className={styles.modelBadge}>{model}</span>}
        {agent.messages.length > 0 && (
          <button
            className={styles.newConversationBtn}
            onClick={onNewConversation}
            type="button"
            title="Neues Gespräch starten (löscht Chatverlauf)"
          >
            ✚ Neu
          </button>
        )}
        <button
          className={styles.deleteBtn}
          onClick={onDeleteAgent}
          type="button"
          title="Agent zurücksetzen (Prompt & Konversation neu)"
        >
          🔄
        </button>
      </div>

      <div className={styles.tabs}>
        <button
          className={tab === 'chat' ? styles.tabActive : styles.tab}
          onClick={() => setTab('chat')}
          type="button"
        >
          Chat
        </button>
      </div>

      {tab === 'chat' && (
        <>
          <div className={styles.messages}>
            {agent.messages.length === 0 && (
              <div className={styles.emptyChat}>
                <div>Stelle dem Agenten eine Frage zu diesem Ordner.</div>
                {contextCount > 0 ? (
                  <div className={styles.contextHint}>
                    📎 {contextCount} Dokument{contextCount !== 1 ? 'e' : ''} als Kontext geladen
                  </div>
                ) : (
                  <div className={styles.contextHint}>
                    Tipp: Lade unter „Kontext" Dokumente hoch (Variablentabelle, Begleitdokumente),
                    damit der Agent mehr Informationen hat.
                  </div>
                )}
              </div>
            )}
            {agent.messages.map((msg) => (
              <div
                key={msg.id}
                className={msg.role === 'user' ? styles.msgUser : styles.msgAssistant}
              >
                <div className={styles.msgBubble}>
                  <pre className={styles.msgContent}>{msg.content}</pre>
                </div>
              </div>
            ))}
            {isSending && (
              <div className={styles.msgAssistant}>
                <div className={styles.msgBubble}>
                  {streamingText ? (
                    <pre className={styles.msgContent}>{streamingText}</pre>
                  ) : (
                    <span className={styles.typing}>
                      <span />
                      <span />
                      <span />
                    </span>
                  )}
                </div>
              </div>
            )}
            <div ref={messagesEndRef} />
          </div>

          {error && (() => {
            const isSessionError = error.toLowerCase().includes('sitzung')
              || error.toLowerCase().includes('abgelaufen')
              || error.toLowerCase().includes('anmelden');
            const lastMsgIsUser = agent.messages.length > 0
              && agent.messages[agent.messages.length - 1].role === 'user';
            return (
              <div className={styles.errorBanner}>
                <span className={styles.errorIcon}>⚠️</span>
                <span className={styles.errorText}>{error}</span>
                <div className={styles.errorActions}>
                  {isSessionError && (
                    <button className={styles.retryLoginBtn} onClick={onRetryLogin} type="button">
                      Anmelden
                    </button>
                  )}
                  {!isSessionError && lastMsgIsUser && (
                    <button className={styles.retryBtn} onClick={onRetry} disabled={isSending} type="button">
                      ↻ Wiederholen
                    </button>
                  )}
                </div>
              </div>
            );
          })()}

          {!model && (
            <div className={styles.noModelWarning}>
              ⚠️ Kein Modell ausgewählt. Bitte in den Einstellungen ein Modell wählen.
            </div>
          )}
          <div className={styles.inputRow}>
            <textarea
              className={styles.input}
              value={inputText}
              onChange={(e) => setInputText(e.target.value)}
              onKeyDown={handleKeyDown}
              placeholder="Nachricht eingeben… (Enter = Senden, Shift+Enter = Zeilenumbruch)"
              rows={2}
              disabled={isSending || !model}
            />
            <button
              className={styles.sendBtn}
              onClick={handleSend}
              disabled={!inputText.trim() || isSending || !model}
              type="button"
              title="Senden"
            >
              ▶
            </button>
          </div>
        </>
      )}

    </div>
  );
}
