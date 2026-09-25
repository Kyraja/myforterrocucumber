/**
 * @module WorkflowDiagram
 * Data-driven horizontal flow diagram that mirrors the {@link WorkflowTimeline}
 * 1:1 — every emitted {@link WorkflowStep} becomes a node, connected by arrows,
 * in the exact chronological order in which the workflow executed.
 *
 * Steps sharing an `itemKey` (e.g. all steps of one FOP, one feature, one bulk
 * package) are rendered as a swimlane row with a small header so batch runs
 * stay navigable. Clicking a node expands the timeline side panel.
 */

import type { AgentRun, WorkflowStep } from '../../types/fop';
import { useTranslation } from '../../i18n';
import styles from './WorkflowDiagram.module.css';

interface WorkflowDiagramProps {
  runs: Map<string, AgentRun>;
  lang: 'de' | 'en';
  /** Invoked when a node is clicked — typically expands the timeline side panel. */
  onStepClick?: (step: WorkflowStep) => void;
}

interface StepGroup {
  itemKey: string | undefined;
  steps: WorkflowStep[];
}

function mergeSteps(runs: Map<string, AgentRun>): WorkflowStep[] {
  const all: WorkflowStep[] = [];
  for (const run of runs.values()) {
    for (const step of run.steps) all.push(step);
  }
  all.sort((a, b) => a.timestamp - b.timestamp);
  return all;
}

function groupByItem(steps: WorkflowStep[]): StepGroup[] {
  const groups: StepGroup[] = [];
  for (const step of steps) {
    const last = groups[groups.length - 1];
    if (last && last.itemKey === step.itemKey) last.steps.push(step);
    else groups.push({ itemKey: step.itemKey, steps: [step] });
  }
  return groups;
}

function StepCard({ step, lang, onClick }: { step: WorkflowStep; lang: 'de' | 'en'; onClick?: (s: WorkflowStep) => void }) {
  const { t } = useTranslation();
  const isAi = step.kind === 'ai';
  const icon = isAi ? '🤖' : '⚙';
  const statusChar = step.status === 'done' ? '✓' : step.status === 'error' ? '✗' : step.status === 'running' ? '⟳' : '○';
  const tagLabel = isAi ? t('workflow.ai') : t('workflow.local');
  return (
    <button
      type="button"
      className={`${styles.card} ${isAi ? styles.cardAi : styles.cardLocal} ${styles[`status_${step.status}`]}`}
      onClick={() => onClick?.(step)}
      title={step.label}
    >
      <span className={styles.cardStatus}>{statusChar}</span>
      <span className={styles.cardIcon}>{icon}</span>
      <span className={styles.cardLabel}>{step.label}</span>
      <span className={styles.cardTag}>{tagLabel}</span>
    </button>
  );
}

export function WorkflowDiagram({ runs, lang, onStepClick }: WorkflowDiagramProps) {
  const { t } = useTranslation();
  void lang;
  const merged = mergeSteps(runs);

  if (merged.length === 0) {
    return (
      <div className={styles.empty}>
        {t('workflow.diagramEmpty')}
      </div>
    );
  }

  const groups = groupByItem(merged);

  return (
    <div className={styles.diagram}>
      {groups.map((group, gi) => (
        <div key={gi} className={styles.group}>
          {group.itemKey && (
            <div className={styles.groupHeader}>
              <span className={styles.groupIcon}>▸</span>
              <span className={styles.groupTitle}>{group.itemKey}</span>
              <span className={styles.groupMeta}>
                {t('workflow.stepsCount', { count: group.steps.length })}
              </span>
            </div>
          )}
          <div className={styles.groupRow}>
            {group.steps.map((step, si) => (
              <div key={step.id} className={styles.nodeWrap}>
                <StepCard step={step} lang={lang} onClick={onStepClick} />
                {si < group.steps.length - 1 && <div className={styles.arrow} aria-hidden />}
              </div>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
}

export default WorkflowDiagram;
