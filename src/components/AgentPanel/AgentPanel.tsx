import { useState, useRef, useEffect } from 'react';
import type { Agent, AgentContextType } from '../../types/agent';
import styles from './AgentPanel.module.css';

interface AgentPanelProps {
  agent: Agent;
  model: string;
  isSending: boolean;
  streamingText: string | null;
  error: string | null;
  onSendMessage: (text: string) => Promise<void>;
  onUploadContext: (files: File[]) => Promise<void>;
  onRemoveContext: (contextId: string) => void;
  onDeleteAgent: () => void;
  onRetryLogin: () => void;
  onRetry: () => void;
  onNewConversation: () => void;
}

export function AgentPanel({
  agent,
  model,
  isSending,
  streamingText,
  error,
  onSendMessage,
  onUploadContext,
  onRemoveContext,
  onDeleteAgent,
  onRetryLogin,
  onRetry,
  onNewConversation,
}: AgentPanelProps) {
  const [tab, setTab] = useState<'chat' | 'context'>('chat');
  const [inputText, setInputText] = useState('');
  const [isUploading, setIsUploading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

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

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files ?? []);
    if (files.length === 0) return;
    setIsUploading(true);
    try {
      await onUploadContext(files);
    } finally {
      setIsUploading(false);
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  const contextTypeIcon: Record<AgentContextType, string> = {
    vartab: '📊',
    efk: '📄',
    'efk-anchor': '🗂️',
    doc: '📎',
  };
  const contextTypeLabel: Record<AgentContextType, string> = {
    vartab: 'Variablentabelle',
    efk: 'EFK',
    'efk-anchor': 'EFK-Übersicht',
    doc: 'Dokument',
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
          title="Agenten löschen"
        >
          🗑️
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
        <button
          className={tab === 'context' ? styles.tabActive : styles.tab}
          onClick={() => setTab('context')}
          type="button"
        >
          Kontext
          {contextCount > 0 && (
            <span className={styles.contextBadge}>{contextCount}</span>
          )}
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

      {tab === 'context' && (
        <div className={styles.contextTab}>
          {contextCount === 0 && (
            <div className={styles.noContext}>
              Noch keine Dokumente hochgeladen. Du kannst mehrere Dateien gleichzeitig auswählen.
            </div>
          )}

          {agent.context.length > 0 && (
            <ul className={styles.contextList}>
              {agent.context.map((ctx) => {
                const type = ctx.type ?? 'doc';
                const isAnchor = type === 'efk-anchor';
                return (
                  <li key={ctx.id} className={`${styles.contextItem} ${isAnchor ? styles.contextItemAnchor : ''}`}>
                    <span className={styles.contextItemIcon}>{contextTypeIcon[type]}</span>
                    <div className={styles.contextItemInfo}>
                      <span className={styles.contextItemName}>{ctx.fileName}</span>
                      <span className={styles.contextItemMeta}>
                        {contextTypeLabel[type]} · {new Date(ctx.uploadedAt).toLocaleString('de-DE')}
                      </span>
                    </div>
                    {!isAnchor && (
                      <button
                        className={styles.removeContextBtn}
                        onClick={() => onRemoveContext(ctx.id)}
                        type="button"
                        title="Dokument entfernen"
                      >
                        ✕
                      </button>
                    )}
                  </li>
                );
              })}
            </ul>
          )}

          <input
            ref={fileInputRef}
            type="file"
            accept=".xlsx,.xls,.csv,.dotm,.docx"
            multiple
            onChange={handleFileChange}
            style={{ display: 'none' }}
          />
          <button
            className={styles.uploadBtn}
            onClick={() => fileInputRef.current?.click()}
            disabled={isUploading}
            type="button"
          >
            {isUploading ? 'Wird analysiert…' : '📎 Dokumente hinzufügen (VarTab: .xlsx · EFK: .dotm/.docx · CSV)'}
          </button>
        </div>
      )}
    </div>
  );
}
