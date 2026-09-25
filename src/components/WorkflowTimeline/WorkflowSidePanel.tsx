/**
 * @module WorkflowSidePanel
 * Always-on right-side chat panel showing the live workflow timeline.
 *
 * Merges steps from every active {@link AgentRun} into one chronological
 * stream so the user sees everything the tool is doing — local logic and AI
 * calls — without having to open a modal or click through per-agent tabs.
 *
 * The panel is collapsible: when collapsed, only a thin vertical strip with
 * an "unfold" button stays visible so the main editor has more space.
 */

import type { AgentRun, WorkflowStep } from '../../types/fop';
import { useTranslation } from '../../i18n';
import { WorkflowTimeline } from './WorkflowTimeline';
import styles from './WorkflowSidePanel.module.css';

interface WorkflowSidePanelProps {
  runs: Map<string, AgentRun>;
  lang: 'de' | 'en';
  collapsed: boolean;
  onToggleCollapsed: () => void;
  width: number;
  onClear?: () => void;
}

/** Merge every run's steps into one chronological list and tag with agent label. */
function mergeSteps(runs: Map<string, AgentRun>): WorkflowStep[] {
  const all: WorkflowStep[] = [];
  for (const run of runs.values()) {
    for (const step of run.steps) {
      all.push(step);
    }
  }
  all.sort((a, b) => a.timestamp - b.timestamp);
  return all;
}

function activeAgentCount(runs: Map<string, AgentRun>): number {
  let n = 0;
  for (const run of runs.values()) if (run.status === 'running') n++;
  return n;
}

function totalStepCount(runs: Map<string, AgentRun>): number {
  let n = 0;
  for (const run of runs.values()) n += run.steps.length;
  return n;
}

export function WorkflowSidePanel({ runs, lang, collapsed, onToggleCollapsed, width, onClear }: WorkflowSidePanelProps) {
  const { t } = useTranslation();
  const merged = mergeSteps(runs);
  const activeCount = activeAgentCount(runs);
  const stepCount = totalStepCount(runs);

  if (collapsed) {
    return (
      <aside className={styles.collapsedStrip} aria-label={t('workflow.historyAria')}>
        <button
          type="button"
          className={styles.expandBtn}
          onClick={onToggleCollapsed}
          title={t('workflow.openTimeline')}
        >
          <span className={styles.expandIcon}>◀</span>
          <span className={styles.verticalLabel}>
            {t('workflow.timeline')}
            {stepCount > 0 && ` · ${stepCount}`}
          </span>
          {activeCount > 0 && <span className={styles.activeDot} />}
        </button>
      </aside>
    );
  }

  return (
    <aside className={styles.panel} style={{ width }} aria-label={t('workflow.historyAria')}>
      <div className={styles.header}>
        <div className={styles.headerLeft}>
          <span className={styles.title}>
            {t('workflow.aiTimeline')}
          </span>
          <span className={styles.meta}>
            {activeCount > 0 && (
              <>
                <span className={styles.activeDot} />
                {t('workflow.activeCount', { count: activeCount })} ·{' '}
              </>
            )}
            {t('workflow.stepsCount', { count: stepCount })}
          </span>
        </div>
        <div className={styles.headerRight}>
          {onClear && stepCount > 0 && activeCount === 0 && (
            <button
              type="button"
              className={styles.clearBtn}
              onClick={onClear}
              title={t('workflow.clearTimeline')}
            >
              {t('workflow.clear')}
            </button>
          )}
          <button
            type="button"
            className={styles.collapseBtn}
            onClick={onToggleCollapsed}
            title={t('workflow.collapse')}
          >
            ▶
          </button>
        </div>
      </div>
      <div className={styles.body}>
        <WorkflowTimeline steps={merged} lang={lang} autoScroll />
      </div>
    </aside>
  );
}

export default WorkflowSidePanel;
