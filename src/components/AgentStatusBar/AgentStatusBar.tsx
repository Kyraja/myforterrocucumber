/**
 * @module AgentStatusBar
 * Persistent status bar that displays a chip for each registered AI agent.
 *
 * The bar is pure status: clicking a chip no longer opens a modal — the full
 * workflow timeline lives in the always-visible {@link WorkflowSidePanel} on
 * the right side of the main layout. The bar keeps its at-a-glance function
 * (running / done / error, progress counter, live spinner).
 *
 * @exports AgentStatusBar (default)
 */
import type { AgentRun, AgentRunStatus } from '../../types/fop';
import { useTranslation } from '../../i18n';
import styles from './AgentStatusBar.module.css';

import type { SavedConversation } from '../../hooks/useAgentActivity';

interface AgentStatusBarProps {
  runs: Map<string, AgentRun>;
  /** Retained for backwards-compatible prop signature; no longer rendered here. */
  savedConversations?: SavedConversation[];
  /** Retained for backwards-compatible prop signature; no longer used. */
  onDeleteSaved?: (id: string) => void;
  experimentalFeatures: boolean;
  lang: 'de' | 'en';
  /** Called when the user clicks a chip — typically to expand the side panel. */
  onChipClick?: (agentType: string) => void;
}

const ALWAYS_VISIBLE: Array<{ type: string; labelDe: string; labelEn: string }> = [
  { type: 'cucumber', labelDe: 'Cucumber Agent', labelEn: 'Cucumber Agent' },
];

const FOP_AGENTS: Array<{ type: string; labelDe: string; labelEn: string }> = [
  { type: 'fop-analyst',     labelDe: 'FOP Inhaltsanalyst',    labelEn: 'FOP Content Analyst' },
  { type: 'fop-guidelines',  labelDe: 'FOP Richtlinienprüfer', labelEn: 'FOP Guidelines' },
];

function StatusIcon({ status }: { status: AgentRunStatus }) {
  if (status === 'running') return <span className={styles.spinnerIcon} aria-label="running" />;
  if (status === 'done')    return <span className={styles.doneIcon}>✓</span>;
  if (status === 'error')   return <span className={styles.errorIcon}>✗</span>;
  return <span className={styles.idleIcon}>○</span>;
}

export default function AgentStatusBar({ runs, experimentalFeatures, lang, onChipClick }: AgentStatusBarProps) {
  const { t } = useTranslation();
  const agentDefs = [
    ...ALWAYS_VISIBLE,
    ...(experimentalFeatures ? FOP_AGENTS : []),
  ];

  return (
    <div className={styles.bar} role="status" aria-label="Agent activity">
      <span className={styles.barLabel}>
        {t('agentStatus.agents')}
      </span>

      {agentDefs.map(({ type, labelDe, labelEn }) => {
        const run = runs.get(type);
        const label = lang === 'de' ? labelDe : labelEn;
        const status: AgentRunStatus = run?.status ?? 'idle';

        return (
          <button
            key={type}
            className={`${styles.chip} ${styles[`chip_${status}`]}`}
            onClick={() => onChipClick?.(type)}
            type="button"
            title={`${label} — ${status}`}
          >
            <StatusIcon status={status} />
            <span className={styles.chipLabel}>{label}</span>
            {status === 'running' && run?.progress && (
              <span className={styles.chipProgress}>
                {run.progress.current}/{run.progress.total}
              </span>
            )}
          </button>
        );
      })}
    </div>
  );
}
