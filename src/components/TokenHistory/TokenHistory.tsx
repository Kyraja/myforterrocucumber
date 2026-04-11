/**
 * @module TokenHistory
 * Modal panel that tracks and displays AI token consumption for the current day.
 *
 * Key responsibilities:
 * - Shows a daily usage summary (prompt / completion / total) with a progress bar against DAILY_LIMIT.
 * - Lists all token entries in reverse chronological order; rows with details are expandable.
 * - Listens for the global 'token-limit-reached' event and shows a toast notification.
 * - Allows clearing the history and supports i18n (de/en) via useTranslation.
 */
import React, { useState, useEffect, useCallback } from 'react';
import { getTokenHistory, getDailyTotal, clearTokenHistory, DAILY_LIMIT } from '../../lib/tokenHistory';
import type { TokenUsageEntry, TokenPurpose } from '../../lib/tokenHistory';
import { useTranslation } from '../../i18n';
import styles from './TokenHistory.module.css';

function formatTime(iso: string): string {
  return new Date(iso).toLocaleTimeString('de-DE', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
}

function formatNumber(n: number): string {
  return n.toLocaleString('de-DE');
}

function getPurposeLabels(lang: string): Record<TokenPurpose, string> {
  if (lang === 'de') {
    return {
      'table-identification': 'Tabellen',
      'gherkin-generation': 'Gherkin',
      'rating': 'Bewertung',
      'agent-chat': 'Agent',
      'unknown': '—',
    };
  }
  return {
    'table-identification': 'Tables',
    'gherkin-generation': 'Gherkin',
    'rating': 'Rating',
    'agent-chat': 'Agent',
    'unknown': '—',
  };
}

export function TokenHistory() {
  const { lang } = useTranslation();
  const [open, setOpen] = useState(false);
  const [entries, setEntries] = useState<TokenUsageEntry[]>([]);
  const [daily, setDaily] = useState({ prompt: 0, completion: 0, total: 0 });
  const [toast, setToast] = useState(false);
  const [expandedId, setExpandedId] = useState<string | null>(null);

  const refresh = useCallback(() => {
    setEntries(getTokenHistory());
    setDaily(getDailyTotal());
  }, []);

  const handleOpen = () => {
    refresh();
    setOpen(true);
  };

  const handleClear = () => {
    clearTokenHistory();
    setEntries([]);
    setDaily({ prompt: 0, completion: 0, total: 0 });
    setExpandedId(null);
  };

  // Listen for token-limit-reached event
  useEffect(() => {
    const handler = () => {
      setDaily({ prompt: 0, completion: 0, total: DAILY_LIMIT });
      setToast(true);
    };
    window.addEventListener('token-limit-reached', handler);
    return () => window.removeEventListener('token-limit-reached', handler);
  }, []);

  // Auto-dismiss toast after 5 seconds
  useEffect(() => {
    if (!toast) return;
    const timer = setTimeout(() => setToast(false), 5000);
    return () => clearTimeout(timer);
  }, [toast]);

  const pct = Math.min(100, (daily.total / DAILY_LIMIT) * 100);
  const purposeLabels = getPurposeLabels(lang);

  return (
    <>
      <button
        className={styles.trigger}
        onClick={handleOpen}
        type="button"
        title={lang === 'de' ? 'Token-Verlauf' : 'Token History'}
      >
        T
      </button>

      {/* Toast notification */}
      {toast && (
        <div className={styles.toast} onClick={() => setToast(false)}>
          <span className={styles.toastIcon}>!</span>
          <span>Tageslimit fuer KI-Anfragen erreicht. Bitte morgen erneut versuchen.</span>
        </div>
      )}

      {open && (
        <div className={styles.overlay} onClick={() => setOpen(false)}>
          <div className={styles.modal} onClick={(e) => e.stopPropagation()}>
            <div className={styles.modalHeader}>
              <span className={styles.modalTitle}>
                {lang === 'de' ? 'Token-Verlauf (heute)' : 'Token History (today)'}
              </span>
              <button
                className={styles.closeBtn}
                onClick={() => setOpen(false)}
                type="button"
              >
                &times;
              </button>
            </div>

            <div className={styles.content}>
              {/* Daily summary */}
              <div className={styles.summary}>
                <div className={styles.summaryRow}>
                  <span>
                    {lang === 'de' ? 'Verbraucht: ' : 'Used: '}
                    <strong>{formatNumber(daily.total)}</strong> / {formatNumber(DAILY_LIMIT)} Tokens
                  </span>
                  <span className={styles.summaryDetail}>
                    Prompt: {formatNumber(daily.prompt)} | Completion: {formatNumber(daily.completion)}
                  </span>
                </div>
                <div className={styles.progressBar}>
                  <div
                    className={pct > 90 ? styles.progressFillDanger : styles.progressFill}
                    style={{ width: `${pct}%` }}
                  />
                </div>
              </div>

              {/* History table */}
              {entries.length === 0 ? (
                <p className={styles.empty}>
                  {lang === 'de' ? 'Noch keine Anfragen heute.' : 'No requests today.'}
                </p>
              ) : (
                <div className={styles.tableWrap}>
                  <table className={styles.table}>
                    <thead>
                      <tr>
                        <th>{lang === 'de' ? 'Zeit' : 'Time'}</th>
                        <th>{lang === 'de' ? 'Zweck' : 'Purpose'}</th>
                        <th>{lang === 'de' ? 'Modell' : 'Model'}</th>
                        <th className={styles.numCol}>Prompt</th>
                        <th className={styles.numCol}>Completion</th>
                        <th className={styles.numCol}>{lang === 'de' ? 'Gesamt' : 'Total'}</th>
                      </tr>
                    </thead>
                    <tbody>
                      {[...entries].reverse().map((e) => {
                        const hasDetails = !!(e.details || e.responseSummary);
                        const isExpanded = expandedId === e.id;
                        return (
                        <React.Fragment key={e.id}>
                          <tr
                            onClick={hasDetails ? () => setExpandedId((prev) => prev === e.id ? null : e.id) : undefined}
                            style={hasDetails ? { cursor: 'pointer' } : undefined}
                            className={isExpanded ? styles.expandedRow : undefined}
                          >
                            <td>
                              {hasDetails && <span style={{ marginRight: 4, fontSize: '0.7em' }}>{isExpanded ? '\u25BC' : '\u25B6'}</span>}
                              {formatTime(e.timestamp)}
                            </td>
                            <td>{purposeLabels[e.purpose] ?? e.purpose ?? '—'}</td>
                            <td className={styles.modelCell}>{e.model}</td>
                            <td className={styles.numCol}>{formatNumber(e.promptTokens)}</td>
                            <td className={styles.numCol}>{formatNumber(e.completionTokens)}</td>
                            <td className={styles.numCol}>{formatNumber(e.totalTokens)}</td>
                          </tr>
                          {isExpanded && hasDetails && (
                            <tr key={`${e.id}-details`}>
                              <td colSpan={6} className={styles.detailsCell}>
                                {e.details && (
                                  <>
                                    <div className={styles.detailSection}>
                                      {lang === 'de' ? 'Anfrage:' : 'Request:'}
                                    </div>
                                    {e.details.split(' | ').map((part, i) => (
                                      <div key={i} className={styles.detailLine}>{part}</div>
                                    ))}
                                  </>
                                )}
                                {e.responseSummary && (
                                  <>
                                    <div className={styles.detailSection}>
                                      {lang === 'de' ? 'Antwort:' : 'Response:'}
                                    </div>
                                    {e.responseSummary.split(' | ').map((part, i) => (
                                      <div key={`r-${i}`} className={styles.detailLine}>{part}</div>
                                    ))}
                                  </>
                                )}
                              </td>
                            </tr>
                          )}
                        </React.Fragment>
                        );
                      })}
                    </tbody>
                  </table>
                </div>
              )}

              <div className={styles.footer}>
                <span className={styles.entryCount}>
                  {lang === 'de' ? `${entries.length} Anfragen heute` : `${entries.length} requests today`}
                </span>
                <button
                  className={styles.clearBtn}
                  onClick={handleClear}
                  type="button"
                  disabled={entries.length === 0}
                >
                  {lang === 'de' ? 'Verlauf leeren' : 'Clear history'}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
