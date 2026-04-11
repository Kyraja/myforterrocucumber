/**
 * @module AgentStatusBar
 * Persistent status bar that displays a chip for each registered AI agent and
 * opens the AgentActivityModal on click.
 *
 * Key responsibilities: maps agent run states (idle / running / done / error) to
 * coloured status chips with a live progress counter, conditionally shows
 * experimental FOP agents behind a feature flag, and resolves the active system
 * prompt for each agent type to pass into the detail modal.
 *
 * @exports AgentStatusBar (default)
 */
import { useState } from 'react';
import type { AgentRun, AgentRunStatus } from '../../types/fop';
import AgentActivityModal from '../AgentActivityModal';
import {
  getCustomSystemPrompt, getCustomFopAnalystPrompt,
  getCustomFopGuidelinesPrompt,
} from '../../lib/settings';
import { DEFAULT_SYSTEM_PROMPT } from '../../lib/aiPrompt';
import { buildFopAnalystPrompt, buildFopGuidelinesPrompt } from '../../lib/fopAgentPrompt';
import styles from './AgentStatusBar.module.css';

import type { SavedConversation } from '../../hooks/useAgentActivity';

interface AgentStatusBarProps {
  runs: Map<string, AgentRun>;
  savedConversations: SavedConversation[];
  onDeleteSaved: (id: string) => void;
  experimentalFeatures: boolean;
  lang: 'de' | 'en';
}

// All defined agent types — always shown so user sees they exist
const ALWAYS_VISIBLE: Array<{ type: string; labelDe: string; labelEn: string }> = [
  { type: 'cucumber', labelDe: 'Cucumber Agent', labelEn: 'Cucumber Agent' },
];

const FOP_AGENTS: Array<{ type: string; labelDe: string; labelEn: string }> = [
  { type: 'fop-analyst',     labelDe: 'FOP Inhaltsanalyst',    labelEn: 'FOP Content Analyst' },
  { type: 'fop-guidelines',  labelDe: 'FOP Richtlinienprüfer', labelEn: 'FOP Guidelines' },
];

function getAgentDescription(type: string, lang: 'de' | 'en'): string {
  switch (type) {
    case 'cucumber':
      return getCustomSystemPrompt() ?? DEFAULT_SYSTEM_PROMPT;
    case 'fop-analyst':
      return getCustomFopAnalystPrompt() ?? buildFopAnalystPrompt(lang);
    case 'fop-guidelines':
      return getCustomFopGuidelinesPrompt() ?? buildFopGuidelinesPrompt(lang);
    default:
      return '';
  }
}

function StatusIcon({ status }: { status: AgentRunStatus }) {
  if (status === 'running') return <span className={styles.spinnerIcon} aria-label="running" />;
  if (status === 'done')    return <span className={styles.doneIcon}>✓</span>;
  if (status === 'error')   return <span className={styles.errorIcon}>✗</span>;
  return <span className={styles.idleIcon}>○</span>;
}

export default function AgentStatusBar({ runs, savedConversations, onDeleteSaved, experimentalFeatures, lang }: AgentStatusBarProps) {
  const [openModal, setOpenModal] = useState<string | null>(null);

  const agentDefs = [
    ...ALWAYS_VISIBLE,
    ...(experimentalFeatures ? FOP_AGENTS : []),
  ];

  return (
    <>
      <div className={styles.bar} role="status" aria-label="Agent activity">
        <span className={styles.barLabel}>
          {lang === 'de' ? 'Agents:' : 'Agents:'}
        </span>

        {agentDefs.map(({ type, labelDe, labelEn }) => {
          const run = runs.get(type);
          const label = lang === 'de' ? labelDe : labelEn;
          const status: AgentRunStatus = run?.status ?? 'idle';

          return (
            <button
              key={type}
              className={`${styles.chip} ${styles[`chip_${status}`]}`}
              onClick={() => setOpenModal(type)}
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

      {openModal !== null && (
        <AgentActivityModal
          run={runs.get(openModal) ?? null}
          agentLabel={agentDefs.find(a => a.type === openModal)?.[lang === 'de' ? 'labelDe' : 'labelEn'] ?? openModal}
          description={getAgentDescription(openModal, lang)}
          savedConversations={savedConversations.filter(c => c.agentType === openModal)}
          onDeleteSaved={onDeleteSaved}
          onClose={() => setOpenModal(null)}
          lang={lang}
        />
      )}
    </>
  );
}
