/**
 * @module WorkflowTimeline
 * Chat-history-style timeline that renders the complete sequence of
 * {@link WorkflowStep}s produced by an AI workflow run. Groups consecutive
 * steps that share the same `itemKey` under a collapsible header so batch
 * runs (e.g. multi-FOP analysis) stay navigable.
 */

import { useEffect, useRef, useState } from 'react';
import type { WorkflowStep } from '../../types/fop';
import { useTranslation } from '../../i18n';
import { StepBubble } from './StepBubble';
import styles from './WorkflowTimeline.module.css';

interface WorkflowTimelineProps {
  steps: WorkflowStep[];
  lang: 'de' | 'en';
  /** Auto-scroll to the newest step when steps are appended. */
  autoScroll?: boolean;
}

interface StepGroup {
  itemKey: string | undefined;
  steps: WorkflowStep[];
}

function groupByItem(steps: WorkflowStep[]): StepGroup[] {
  const groups: StepGroup[] = [];
  for (const step of steps) {
    const last = groups[groups.length - 1];
    if (last && last.itemKey === step.itemKey) {
      last.steps.push(step);
    } else {
      groups.push({ itemKey: step.itemKey, steps: [step] });
    }
  }
  return groups;
}

export function WorkflowTimeline({ steps, lang, autoScroll = true }: WorkflowTimelineProps) {
  const { t } = useTranslation();
  const endRef = useRef<HTMLDivElement>(null);
  const [collapsed, setCollapsed] = useState<Set<string>>(new Set());

  useEffect(() => {
    if (autoScroll) endRef.current?.scrollIntoView({ behavior: 'smooth', block: 'end' });
  }, [steps.length, autoScroll]);

  if (steps.length === 0) {
    return (
      <div className={styles.empty}>
        <span className={styles.emptyIcon}>🤖</span>
        <p>{t('workflow.noStepsYet')}</p>
      </div>
    );
  }

  const groups = groupByItem(steps);

  const toggleGroup = (key: string) => {
    setCollapsed(prev => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  };

  return (
    <div className={styles.timeline}>
      {groups.map((group, idx) => {
        const groupKey = group.itemKey ?? `__group_${idx}`;
        const isCollapsed = collapsed.has(groupKey);
        const showHeader = !!group.itemKey;
        const runningCount = group.steps.filter(s => s.status === 'running').length;
        return (
          <div key={groupKey} className={styles.group}>
            {showHeader && (
              <button
                type="button"
                className={styles.groupHeader}
                onClick={() => toggleGroup(groupKey)}
                aria-expanded={!isCollapsed}
              >
                <span className={styles.groupArrow}>{isCollapsed ? '▸' : '▾'}</span>
                <span className={styles.groupTitle}>{group.itemKey}</span>
                <span className={styles.groupMeta}>
                  {t('workflow.stepsCount', { count: group.steps.length })}
                  {runningCount > 0 && ` · ${t('workflow.activeCount', { count: runningCount })}`}
                </span>
              </button>
            )}
            {!isCollapsed && (
              <div className={styles.groupBody}>
                {group.steps.map(step => (
                  <StepBubble
                    key={step.id}
                    step={step}
                    lang={lang}
                    nested={!!step.parentId}
                  />
                ))}
              </div>
            )}
          </div>
        );
      })}
      <div ref={endRef} />
    </div>
  );
}

export default WorkflowTimeline;
