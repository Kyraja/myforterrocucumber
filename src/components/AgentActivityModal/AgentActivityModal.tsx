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
import { useEffect, useState } from 'react';
import type { AgentRun } from '../../types/fop';
import { useTranslation } from '../../i18n';
import styles from './AgentActivityModal.module.css';
import { WorkflowTimeline } from '../WorkflowTimeline/WorkflowTimeline';

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

export default function AgentActivityModal({ run, agentLabel, description, savedConversations, onDeleteSaved, onClose, onStop, lang }: AgentActivityModalProps) {
  const { t } = useTranslation();
  const statusLabelMap: Record<AgentRun['status'], string> = {
    running: t('agentActivity.status.running'),
    done: t('agentActivity.status.done'),
    error: t('agentActivity.status.error'),
    idle: t('agentActivity.status.idle'),
    paused: t('agentActivity.status.paused'),
  };
  const [activeTab, setActiveTab] = useState<'activity' | 'history' | 'description'>('activity');
  const [selectedSaved, setSelectedSaved] = useState<SavedConversation | null>(null);

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
              {statusLabelMap[status]}
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
            {t('agentActivity.activity')}
          </button>
          {savedConversations && savedConversations.length > 0 && (
            <button
              type="button"
              className={`${styles.tab} ${activeTab === 'history' ? styles.tabActive : ''}`}
              onClick={() => { setActiveTab('history'); setSelectedSaved(null); }}
            >
              {t('agentActivity.historyCount', { count: savedConversations.length })}
            </button>
          )}
          {description && (
            <button
              type="button"
              className={`${styles.tab} ${activeTab === 'description' ? styles.tabActive : ''}`}
              onClick={() => setActiveTab('description')}
            >
              {t('agentActivity.systemPrompt')}
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
              // Detail view of a saved conversation — uses Timeline
              <div className={styles.savedDetail}>
                <div className={styles.savedDetailHeader}>
                  <button type="button" className={styles.backBtn} onClick={() => setSelectedSaved(null)}>
                    ← {t('agentActivity.back')}
                  </button>
                  <span className={styles.savedDetailTitle}>{selectedSaved.title}</span>
                  <span className={styles.savedDetailMeta}>
                    {new Date(selectedSaved.savedAt).toLocaleString()}
                    {selectedSaved.durationMs && ` · ${(selectedSaved.durationMs / 1000).toFixed(1)}s`}
                  </span>
                </div>
                <WorkflowTimeline steps={selectedSaved.steps ?? []} lang={lang} autoScroll={false} />
              </div>
            ) : (
              // List of saved conversations (newest first)
              <div className={styles.savedList}>
                {[...(savedConversations ?? [])].reverse().map(conv => (
                  <div key={conv.id} className={styles.savedItem}>
                    <button
                      type="button"
                      className={styles.savedItemMain}
                      onClick={() => { setSelectedSaved(conv); }}
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
                        title={t('agentActivity.delete')}
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
              {t('agentActivity.promptHint')}
            </p>
            <pre className={styles.descriptionPre}>{description}</pre>
          </div>
        )}

        {/* ── Activity body — Workflow Timeline ── */}
        {activeTab === 'activity' && (
          <div className={styles.chatBody}>
            <WorkflowTimeline steps={run?.steps ?? []} lang={lang} />
          </div>
        )}

        {/* ── Footer ── */}
        <div className={styles.footer}>
          <span className={styles.readonlyNote}>
            {t('agentActivity.readOnly')}
          </span>
          <div className={styles.footerActions}>
            {onStop && isRunning && (
              <button className={styles.stopBtn} onClick={onStop} type="button">
                ⏹ {t('agentActivity.stop')}
              </button>
            )}
            <button className={styles.closeFooterBtn} onClick={onClose} type="button">
              {t('agentActivity.close')}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
