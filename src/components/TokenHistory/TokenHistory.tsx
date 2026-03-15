import { useState, useEffect, useCallback } from 'react';
import { getTokenHistory, getDailyTotal, clearTokenHistory, DAILY_LIMIT } from '../../lib/tokenHistory';
import type { TokenUsageEntry } from '../../lib/tokenHistory';
import styles from './TokenHistory.module.css';

function formatTime(iso: string): string {
  return new Date(iso).toLocaleTimeString('de-DE', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
}

function formatNumber(n: number): string {
  return n.toLocaleString('de-DE');
}

export function TokenHistory() {
  const [open, setOpen] = useState(false);
  const [entries, setEntries] = useState<TokenUsageEntry[]>([]);
  const [daily, setDaily] = useState({ prompt: 0, completion: 0, total: 0 });
  const [toast, setToast] = useState(false);

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

  return (
    <>
      <button
        className={styles.trigger}
        onClick={handleOpen}
        type="button"
        title="Token-Verlauf"
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
              <span className={styles.modalTitle}>Token-Verlauf (heute)</span>
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
                  <span>Verbraucht: <strong>{formatNumber(daily.total)}</strong> / {formatNumber(DAILY_LIMIT)} Tokens</span>
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
                <p className={styles.empty}>Noch keine Anfragen heute.</p>
              ) : (
                <div className={styles.tableWrap}>
                  <table className={styles.table}>
                    <thead>
                      <tr>
                        <th>Zeit</th>
                        <th>Modell</th>
                        <th className={styles.numCol}>Prompt</th>
                        <th className={styles.numCol}>Completion</th>
                        <th className={styles.numCol}>Gesamt</th>
                      </tr>
                    </thead>
                    <tbody>
                      {[...entries].reverse().map((e) => (
                        <tr key={e.id}>
                          <td>{formatTime(e.timestamp)}</td>
                          <td className={styles.modelCell}>{e.model}</td>
                          <td className={styles.numCol}>{formatNumber(e.promptTokens)}</td>
                          <td className={styles.numCol}>{formatNumber(e.completionTokens)}</td>
                          <td className={styles.numCol}>{formatNumber(e.totalTokens)}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}

              <div className={styles.footer}>
                <span className={styles.entryCount}>{entries.length} Anfragen heute</span>
                <button
                  className={styles.clearBtn}
                  onClick={handleClear}
                  type="button"
                  disabled={entries.length === 0}
                >
                  Verlauf leeren
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
