/**
 * @module AgentActivityModal
 * Full-screen modal for monitoring live and historical AI agent activity.
 *
 * Key responsibilities: streams the agent's current input/output in a chat-bubble
 * layout with a typing indicator, shows a progress bar for batch runs, provides
 * tabs for live activity / conversation history / system-prompt inspection, and
 * includes an elapsed-time timer while the agent is running.
 *
 * @exports AgentActivityModal (default)
 */
import { useEffect, useRef, useState } from 'react';
import type { AgentRun } from '../../types/fop';
import styles from './AgentActivityModal.module.css';

import type { SavedConversation } from '../../hooks/useAgentActivity';

interface AgentActivityModalProps {
  run: AgentRun | null;
  agentLabel: string;
  description?: string;
  savedConversations?: SavedConversation[];
  onDeleteSaved?: (id: string) => void;
  onClose: () => void;
  onStop?: () => void;
  lang: 'de' | 'en';
}

function ElapsedTimer({ startedAt }: { startedAt: number }) {
  const [elapsed, setElapsed] = useState(Date.now() - startedAt);
  useEffect(() => {
    const id = setInterval(() => setElapsed(Date.now() - startedAt), 1000);
    return () => clearInterval(id);
  }, [startedAt]);
  const s = Math.floor(elapsed / 1000);
  const m = Math.floor(s / 60);
  return <span>{m > 0 ? `${m}m ${s % 60}s` : `${s}s`}</span>;
}

function statusLabel(status: AgentRun['status'], lang: 'de' | 'en'): string {
  const map: Record<AgentRun['status'], [string, string]> = {
    running: ['Läuft', 'Running'],
    done:    ['Abgeschlossen', 'Done'],
    error:   ['Fehler', 'Error'],
    idle:    ['Inaktiv', 'Idle'],
    paused:  ['Pausiert', 'Paused'],
  };
  return map[status][lang === 'de' ? 0 : 1];
}

export default function AgentActivityModal({ run, agentLabel, description, savedConversations, onDeleteSaved, onClose, onStop, lang }: AgentActivityModalProps) {
  const chatEndRef = useRef<HTMLDivElement>(null);
  const [showRawInput, setShowRawInput] = useState(false);
  const [activeTab, setActiveTab] = useState<'activity' | 'history' | 'description'>('activity');
  const [selectedSaved, setSelectedSaved] = useState<SavedConversation | null>(null);
  const [showSavedInput, setShowSavedInput] = useState(false);

  // Auto-scroll chat to bottom on new output
  useEffect(() => {
    chatEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [run?.outputSoFar, run?.history.length]);

  const handleOverlay = (e: React.MouseEvent<HTMLDivElement>) => {
    if (e.target === e.currentTarget) onClose();
  };

  const status = run?.status ?? 'idle';
  const isRunning = status === 'running';

  const progressPct = run?.progress
    ? Math.round((run.progress.current / Math.max(run.progress.total, 1)) * 100)
    : null;

  return (
    <div className={styles.overlay} onClick={handleOverlay}>
      <div className={styles.modal} role="dialog" aria-modal="true">

        {/* ── Header ── */}
        <div className={styles.header}>
          <div className={styles.headerLeft}>
            <span className={styles.agentName}>{agentLabel}</span>
            <span className={`${styles.statusBadge} ${styles[`status_${status}`]}`}>
              {isRunning && <span className={styles.spinner} />}
              {status === 'done' && '✓ '}
              {status === 'error' && '✗ '}
              {statusLabel(status, lang)}
            </span>
          </div>
          <div className={styles.headerRight}>
            {run?.startedAt && isRunning && (
              <span className={styles.elapsed}>
                <ElapsedTimer startedAt={run.startedAt} />
              </span>
            )}
            <button className={styles.closeBtn} onClick={onClose} type="button" aria-label="close">✕</button>
          </div>
        </div>

        {/* ── Tabs ── */}
        <div className={styles.tabs}>
          <button
            type="button"
            className={`${styles.tab} ${activeTab === 'activity' ? styles.tabActive : ''}`}
            onClick={() => setActiveTab('activity')}
          >
            {lang === 'de' ? 'Aktivität' : 'Activity'}
          </button>
          {savedConversations && savedConversations.length > 0 && (
            <button
              type="button"
              className={`${styles.tab} ${activeTab === 'history' ? styles.tabActive : ''}`}
              onClick={() => { setActiveTab('history'); setSelectedSaved(null); }}
            >
              {lang === 'de' ? `Verlauf (${savedConversations.length})` : `History (${savedConversations.length})`}
            </button>
          )}
          {description && (
            <button
              type="button"
              className={`${styles.tab} ${activeTab === 'description' ? styles.tabActive : ''}`}
              onClick={() => setActiveTab('description')}
            >
              {lang === 'de' ? 'System-Prompt' : 'System Prompt'}
            </button>
          )}
        </div>

        {/* ── Progress bar ── */}
        {run?.progress && (
          <div className={styles.progressSection}>
            <div className={styles.progressRow}>
              <span className={styles.progressText}>
                {run.progress.current}/{run.progress.total} ({progressPct}%)
              </span>
              {run.currentItem && (
                <span className={styles.currentItem} title={run.currentItem}>
                  {run.currentItem}
                </span>
              )}
            </div>
            <div className={styles.progressTrack}>
              <div className={`${styles.progressFill} ${status === 'done' ? styles.progressDone : ''}`}
                   style={{ width: `${progressPct}%` }} />
            </div>
          </div>
        )}

        {/* ── History tab ── */}
        {activeTab === 'history' && (
          <div className={styles.historyTab}>
            {selectedSaved ? (
              // Detail view of a saved conversation
              <div className={styles.savedDetail}>
                <div className={styles.savedDetailHeader}>
                  <button type="button" className={styles.backBtn} onClick={() => setSelectedSaved(null)}>
                    ← {lang === 'de' ? 'Zurück' : 'Back'}
                  </button>
                  <span className={styles.savedDetailTitle}>{selectedSaved.title}</span>
                  <span className={styles.savedDetailMeta}>
                    {new Date(selectedSaved.savedAt).toLocaleString()}
                    {selectedSaved.durationMs && ` · ${(selectedSaved.durationMs / 1000).toFixed(1)}s`}
                  </span>
                </div>
                <div className={styles.chatBody}>
                  {selectedSaved.inputSnapshot && (
                    <div className={styles.msgSent}>
                      <div className={styles.msgBubbleSent}>
                        <div className={styles.msgMeta}>
                          {lang === 'de' ? 'Gesendet' : 'Sent'} · <button type="button" className={styles.toggleRaw} onClick={() => setShowSavedInput(v => !v)}>
                            {showSavedInput ? (lang === 'de' ? 'Einklappen' : 'Collapse') : (lang === 'de' ? 'Anzeigen' : 'Show')}
                          </button>
                        </div>
                        {showSavedInput && <pre className={styles.msgPre}>{selectedSaved.inputSnapshot}</pre>}
                        {!showSavedInput && <p className={styles.msgSummary}>{selectedSaved.title}</p>}
                      </div>
                    </div>
                  )}
                  {selectedSaved.outputSoFar && (
                    <div className={styles.msgReceived}>
                      <div className={styles.msgAvatar}>🤖</div>
                      <div className={styles.msgBubbleReceived}>
                        <div className={styles.msgMeta}>{lang === 'de' ? 'Antwort' : 'Response'}</div>
                        <pre className={styles.msgPre}>{selectedSaved.outputSoFar}</pre>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            ) : (
              // List of saved conversations (newest first)
              <div className={styles.savedList}>
                {[...(savedConversations ?? [])].reverse().map(conv => (
                  <div key={conv.id} className={styles.savedItem}>
                    <button
                      type="button"
                      className={styles.savedItemMain}
                      onClick={() => { setSelectedSaved(conv); setShowSavedInput(false); }}
                    >
                      <span className={styles.savedItemTitle}>{conv.title}</span>
                      <span className={styles.savedItemMeta}>
                        {new Date(conv.savedAt).toLocaleString(lang === 'de' ? 'de-DE' : 'en-US', { dateStyle: 'short', timeStyle: 'short' })}
                        {conv.durationMs && ` · ${(conv.durationMs / 1000).toFixed(1)}s`}
                      </span>
                    </button>
                    {onDeleteSaved && (
                      <button
                        type="button"
                        className={styles.savedItemDelete}
                        onClick={() => onDeleteSaved(conv.id)}
                        title={lang === 'de' ? 'Löschen' : 'Delete'}
                      >×</button>
                    )}
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* ── Description tab ── */}
        {activeTab === 'description' && description && (
          <div className={styles.descriptionBody}>
            <p className={styles.descriptionHint}>
              {lang === 'de'
                ? 'Aktuell aktiver System-Prompt dieses Agents. Änderbar in den Einstellungen.'
                : 'Currently active system prompt of this agent. Editable in settings.'}
            </p>
            <pre className={styles.descriptionPre}>{description}</pre>
          </div>
        )}

        {/* ── Chat body ── */}
        {activeTab === 'activity' && <div className={styles.chatBody}>

          {/* No activity yet */}
          {!run && (
            <div className={styles.emptyChat}>
              <span className={styles.emptyChatIcon}>🤖</span>
              <p>{lang === 'de'
                ? 'Noch keine Aktivität. Der Agent wurde noch nicht gestartet.'
                : 'No activity yet. The agent has not been started.'}</p>
            </div>
          )}

          {/* Completed exchanges (table identification, etc.) */}
          {run?.exchanges?.map((ex, idx) => (
            <div key={idx} className={styles.exchange}>
              <div className={styles.msgSent}>
                <div className={styles.msgBubbleSent}>
                  <div className={styles.msgMeta}>{ex.label}</div>
                  <pre className={styles.msgPre}>{ex.input}</pre>
                </div>
              </div>
              {ex.output && (
                <div className={styles.msgReceived}>
                  <div className={styles.msgAvatar}>🤖</div>
                  <div className={styles.msgBubbleReceived}>
                    <div className={styles.msgMeta}>{lang === 'de' ? 'Antwort' : 'Response'}</div>
                    <pre className={styles.msgPre}>{ex.output}</pre>
                  </div>
                </div>
              )}
            </div>
          ))}

          {/* Current active exchange (input + streaming output) */}
          {run && (run.inputSnapshot || run.outputSoFar) && (
            <div className={styles.exchange}>
              {/* Sent message — right side */}
              {run.inputSnapshot && (
                <div className={styles.msgSent}>
                  <div className={styles.msgBubbleSent}>
                    <div className={styles.msgMeta}>
                      {lang === 'de' ? 'Gesendet' : 'Sent'}
                      {' · '}
                      <button
                        type="button"
                        className={styles.toggleRaw}
                        onClick={() => setShowRawInput(v => !v)}
                      >
                        {showRawInput
                          ? (lang === 'de' ? 'Einklappen' : 'Collapse')
                          : (lang === 'de' ? 'Prompt anzeigen' : 'Show prompt')}
                      </button>
                    </div>
                    {showRawInput && (
                      <pre className={styles.msgPre}>{run.inputSnapshot}</pre>
                    )}
                    {!showRawInput && (
                      <p className={styles.msgSummary}>
                        {run.currentItem
                          ? (lang === 'de' ? `Feature: ${run.currentItem}` : `Feature: ${run.currentItem}`)
                          : (lang === 'de' ? '(Kontext eingeklappt)' : '(Context collapsed)')}
                      </p>
                    )}
                  </div>
                </div>
              )}

              {/* Typing indicator — shown when running but no output yet */}
              {isRunning && !run.outputSoFar && (
                <div className={styles.msgReceived}>
                  <div className={styles.msgAvatar}>🤖</div>
                  <div className={styles.msgBubbleReceived}>
                    <div className={styles.msgMeta}>
                      {run.currentItem
                        ? (lang === 'de' ? `Verarbeite: ${run.currentItem}` : `Processing: ${run.currentItem}`)
                        : (lang === 'de' ? 'KI arbeitet…' : 'AI working…')}
                    </div>
                    <div className={styles.typingIndicator}>
                      <span className={styles.typingDot1} />
                      <span className={styles.typingDot2} />
                      <span className={styles.typingDot3} />
                    </div>
                  </div>
                </div>
              )}

              {/* Received message — left side */}
              {run.outputSoFar && (
                <div className={styles.msgReceived}>
                  <div className={styles.msgAvatar}>🤖</div>
                  <div className={styles.msgBubbleReceived}>
                    <div className={styles.msgMeta}>
                      {lang === 'de' ? 'Antwort' : 'Response'}
                      {isRunning && (
                        <span className={styles.streamingIndicator}>
                          {lang === 'de' ? ' · schreibt…' : ' · writing…'}
                        </span>
                      )}
                    </div>
                    <pre className={styles.msgPre}>{run.outputSoFar}</pre>
                  </div>
                </div>
              )}
            </div>
          )}

          {/* History — past exchanges */}
          {run && run.history.length > 0 && (
            <div className={styles.historySection}>
              <div className={styles.historySeparator}>
                {lang === 'de' ? `${run.history.length} abgeschlossene Aufgaben` : `${run.history.length} completed tasks`}
              </div>
              {[...run.history].reverse().map((item, idx) => (
                <div key={idx} className={`${styles.historyItem} ${item.status === 'error' ? styles.historyError : styles.historyDone}`}>
                  <span className={styles.historyIcon}>{item.status === 'done' ? '✓' : '✗'}</span>
                  <span className={styles.historyName}>{item.item}</span>
                  <span className={styles.historyDuration}>
                    {(item.durationMs / 1000).toFixed(1)}s
                  </span>
                </div>
              ))}
            </div>
          )}

          <div ref={chatEndRef} />
        </div>}

        {/* ── Footer ── */}
        <div className={styles.footer}>
          <span className={styles.readonlyNote}>
            {lang === 'de' ? 'Nur-Lesen' : 'Read-only'}
          </span>
          <div className={styles.footerActions}>
            {onStop && isRunning && (
              <button className={styles.stopBtn} onClick={onStop} type="button">
                {lang === 'de' ? '⏹ Stoppen' : '⏹ Stop'}
              </button>
            )}
            <button className={styles.closeFooterBtn} onClick={onClose} type="button">
              {lang === 'de' ? 'Schließen' : 'Close'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
