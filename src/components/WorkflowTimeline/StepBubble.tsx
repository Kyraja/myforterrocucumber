/**
 * @module StepBubble
 * Renders a single {@link WorkflowStep} in the timeline — either a local-logic
 * step or an AI call. Each kind uses a distinct layout so the user can tell at
 * a glance what is happening locally and what is an AI round-trip.
 */

import { useState } from 'react';
import type { WorkflowStep, LocalStep, AiStep } from '../../types/fop';
import { useTranslation } from '../../i18n';
import styles from './WorkflowTimeline.module.css';

interface StepBubbleProps {
  step: WorkflowStep;
  lang: 'de' | 'en';
  nested?: boolean;
}

function formatDuration(ms?: number): string {
  if (ms === undefined || ms === null) return '';
  if (ms < 1000) return `${ms}ms`;
  const s = (ms / 1000).toFixed(1);
  return `${s}s`;
}

function StatusDot({ status }: { status: WorkflowStep['status'] }) {
  return <span className={`${styles.statusDot} ${styles[`status_${status}`]}`} aria-label={status} />;
}

function CollapseBlock({
  title,
  text,
  defaultOpen = false,
  empty,
}: {
  title: string;
  text?: string;
  defaultOpen?: boolean;
  empty?: string;
}) {
  const [open, setOpen] = useState(defaultOpen);
  const hasContent = text !== undefined && text !== null && text.length > 0;
  return (
    <div className={styles.collapseBlock}>
      <button
        type="button"
        className={styles.collapseHeader}
        onClick={() => setOpen(v => !v)}
        aria-expanded={open}
      >
        <span className={styles.collapseArrow}>{open ? '▾' : '▸'}</span>
        <span className={styles.collapseTitle}>{title}</span>
        {hasContent && <span className={styles.collapseMeta}>{text!.length} chars</span>}
      </button>
      {open && (
        <pre className={styles.collapseBody}>{hasContent ? text : (empty ?? '(empty)')}</pre>
      )}
    </div>
  );
}

function LocalStepBubble({ step, nested }: { step: LocalStep; nested?: boolean }) {
  const { t } = useTranslation();
  return (
    <div className={`${styles.bubble} ${styles.bubbleLocal} ${nested ? styles.bubbleNested : ''}`}>
      <div className={styles.bubbleIcon} aria-hidden>⚙</div>
      <div className={styles.bubbleBody}>
        <div className={styles.bubbleHeader}>
          <span className={styles.bubbleLabel}>{step.label}</span>
          <span className={styles.bubbleTag}>{t('workflow.local')}</span>
          <StatusDot status={step.status} />
          {step.durationMs !== undefined && (
            <span className={styles.bubbleDuration}>{formatDuration(step.durationMs)}</span>
          )}
        </div>
        <div className={styles.bubbleSummary}>{step.summary}</div>
        {(step.inputText || step.outputText) && (
          <div className={styles.bubbleDetails}>
            {step.inputText && (
              <CollapseBlock
                title={t('workflow.input')}
                text={step.inputText}
              />
            )}
            {step.outputText && (
              <CollapseBlock
                title={t('workflow.output')}
                text={step.outputText}
              />
            )}
          </div>
        )}
        {step.status === 'error' && step.errorMessage && (
          <div className={styles.errorLine}>⚠ {step.errorMessage}</div>
        )}
      </div>
    </div>
  );
}

function AiStepBubble({ step, nested }: { step: AiStep; nested?: boolean }) {
  const { t } = useTranslation();
  const isRunning = step.status === 'running';
  return (
    <div className={`${styles.bubble} ${styles.bubbleAi} ${nested ? styles.bubbleNested : ''}`}>
      <div className={styles.bubbleIcon} aria-hidden>🤖</div>
      <div className={styles.bubbleBody}>
        <div className={styles.bubbleHeader}>
          <span className={styles.bubbleLabel}>{step.label}</span>
          <span className={styles.bubbleTag}>{t('workflow.ai')}</span>
          <span className={styles.bubbleAgent}>{step.agent}</span>
          {step.model && <span className={styles.bubbleModel}>{step.model}</span>}
          <StatusDot status={step.status} />
          {step.durationMs !== undefined && (
            <span className={styles.bubbleDuration}>{formatDuration(step.durationMs)}</span>
          )}
        </div>
        <div className={styles.bubbleDetails}>
          <CollapseBlock
            title={t('workflow.systemPrompt')}
            text={step.systemPrompt}
            empty={t('workflow.noSystemPrompt')}
          />
          <CollapseBlock
            title={t('workflow.userContext')}
            text={step.userPrompt}
            empty={t('workflow.noUserContext')}
          />
          <CollapseBlock
            title={t('workflow.response')}
            text={step.rawResponse}
            defaultOpen={!isRunning}
            empty={isRunning
              ? t('workflow.waitingResponse')
              : t('workflow.noResponse')}
          />
        </div>
        {isRunning && (
          <div className={styles.typingRow} aria-label={t('workflow.waiting')}>
            <span className={styles.typingDot} />
            <span className={styles.typingDot} />
            <span className={styles.typingDot} />
          </div>
        )}
        {step.status === 'error' && step.errorMessage && (
          <div className={styles.errorLine}>⚠ {step.errorMessage}</div>
        )}
      </div>
    </div>
  );
}

export function StepBubble({ step, lang, nested }: StepBubbleProps) {
  void lang;
  if (step.kind === 'ai') return <AiStepBubble step={step} nested={nested} />;
  return <LocalStepBubble step={step} nested={nested} />;
}
