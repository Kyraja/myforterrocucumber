/**
 * @module ProcessFlowBar
 * Horizontal step-progress bar visualising a multi-step AI-assisted workflow
 * (e.g. CUCUMBER_FLOW or FOP_FLOW). Each step is shown as a node with status
 * indicators (pending / active / done / error). KI-type steps are clickable
 * and open the corresponding agent modal via `onKiStepClick`.
 *
 * Key responsibilities: render ordered flow steps, reflect live agent-run
 * progress, differentiate local vs. AI steps visually, pulse when an agent
 * is actively running.
 */
import styles from './ProcessFlowBar.module.css';
import type { AgentRun } from '../../types/fop';

// ── Step definition ────────────────────────────────────────────

export interface FlowStep {
  id: string;
  labelDe: string;
  labelEn: string;
  type: 'local' | 'ki';
  /** Agent type — if ki step, clicking opens the agent modal */
  agentType?: 'cucumber' | 'fop-analyst' | 'fop-guidelines';
  descriptionDe?: string;
  descriptionEn?: string;
}

export type StepStatus = 'pending' | 'active' | 'done' | 'error' | 'skipped';

// ── Predefined flows ───────────────────────────────────────────

export const CUCUMBER_FLOW: FlowStep[] = [
  {
    id: 'identify-tables',
    labelDe: 'Tabellen ermitteln',
    labelEn: 'Identify Tables',
    type: 'local',
    descriptionDe: 'Relevante Datenbanken und Felder aus dem Text erkennen',
    descriptionEn: 'Detect relevant databases and fields from the text',
  },
  {
    id: 'build-prompt',
    labelDe: 'Prompt aufbauen',
    labelEn: 'Build Prompt',
    type: 'local',
    descriptionDe: 'Anforderungstext mit Felddefinitionen anreichern',
    descriptionEn: 'Enrich requirements text with field definitions',
  },
  {
    id: 'generate-gherkin',
    labelDe: 'Gherkin generieren',
    labelEn: 'Generate Gherkin',
    type: 'ki',
    agentType: 'cucumber',
    descriptionDe: 'Cucumber-Tests per KI generieren',
    descriptionEn: 'Generate Cucumber tests via AI',
  },
  {
    id: 'process-result',
    labelDe: 'Tests übernehmen',
    labelEn: 'Apply Tests',
    type: 'local',
    descriptionDe: 'Generierte Szenarien in den Editor laden',
    descriptionEn: 'Load generated scenarios into the editor',
  },
];

export const FOP_FLOW: FlowStep[] = [
  {
    id: 'parse-fops',
    labelDe: 'FOPs parsen',
    labelEn: 'Parse FOPs',
    type: 'local',
    descriptionDe: 'FOP-Quellcode einlesen und Struktur erkennen',
    descriptionEn: 'Read FOP source code and detect structure',
  },
  {
    id: 'resolve-fields',
    labelDe: 'Felder auflösen',
    labelEn: 'Resolve Fields',
    type: 'local',
    descriptionDe: 'Maskenfelder aus Variablentabellen zuordnen',
    descriptionEn: 'Map mask fields from variable tables',
  },
  {
    id: 'analyse-content',
    labelDe: 'Inhaltsanalyse',
    labelEn: 'Content Analysis',
    type: 'ki',
    agentType: 'fop-analyst',
    descriptionDe: 'FOP fachlich und technisch beschreiben',
    descriptionEn: 'Describe FOP technically and in business terms',
  },
  {
    id: 'check-guidelines',
    labelDe: 'Richtlinien prüfen',
    labelEn: 'Check Guidelines',
    type: 'ki',
    agentType: 'fop-guidelines',
    descriptionDe: 'Code-Qualität gegen Programmierrichtlinien prüfen',
    descriptionEn: 'Check code quality against programming guidelines',
  },
  {
    id: 'generate-tests',
    labelDe: 'Tests generieren',
    labelEn: 'Generate Tests',
    type: 'ki',
    agentType: 'cucumber',
    descriptionDe: 'Cucumber-Tests aus der Analyse ableiten',
    descriptionEn: 'Derive Cucumber tests from the analysis',
  },
  {
    id: 'save-result',
    labelDe: 'Ergebnis speichern',
    labelEn: 'Save Result',
    type: 'local',
    descriptionDe: 'Analyse und Tests in Konzept/ ablegen',
    descriptionEn: 'Save analysis and tests to Konzept/',
  },
];

// ── Component ──────────────────────────────────────────────────

interface ProcessFlowBarProps {
  /** Which flow to show. null = hide the bar */
  flow: FlowStep[] | null;
  /** ID of the currently active step */
  activeStepId: string | null;
  /** IDs of completed steps */
  completedStepIds: string[];
  /** IDs of failed steps */
  failedStepIds?: string[];
  /** Current agent runs — passed to show agent activity on click */
  runs: Map<string, AgentRun>;
  /** Called when a KI step node is clicked */
  onKiStepClick?: (agentType: string) => void;
  lang: 'de' | 'en';
}

function stepIcon(type: FlowStep['type'], status: StepStatus): string {
  if (status === 'done') return '✓';
  if (status === 'error') return '✗';
  if (status === 'active') return type === 'ki' ? '🤖' : '⟳';
  return type === 'ki' ? '🤖' : '○';
}

export default function ProcessFlowBar({
  flow,
  activeStepId,
  completedStepIds,
  failedStepIds = [],
  runs,
  onKiStepClick,
  lang,
}: ProcessFlowBarProps) {
  if (!flow) return null;

  return (
    <div className={styles.bar}>
      <div className={styles.flow}>
        {flow.map((step, i) => {
          const isActive = step.id === activeStepId;
          const isDone = completedStepIds.includes(step.id);
          const isFailed = failedStepIds.includes(step.id);
          const status: StepStatus = isFailed ? 'error' : isDone ? 'done' : isActive ? 'active' : 'pending';

          // For KI steps: check if agent is running
          const agentRun = step.agentType ? runs.get(step.agentType) : undefined;
          const agentRunning = agentRun?.status === 'running';

          const label = lang === 'de' ? step.labelDe : step.labelEn;
          const description = lang === 'de' ? step.descriptionDe : step.descriptionEn;

          return (
            <div key={step.id} className={styles.stepWrapper}>
              {/* Arrow between steps */}
              {i > 0 && (
                <div className={`${styles.arrow} ${isDone || isActive ? styles.arrowActive : ''}`}>
                  ›
                </div>
              )}

              {/* Step node */}
              <button
                type="button"
                className={[
                  styles.step,
                  styles[`step_${status}`],
                  step.type === 'ki' ? styles.stepKi : styles.stepLocal,
                  (isActive && agentRunning) ? styles.stepPulsing : '',
                  step.type === 'ki' && onKiStepClick ? styles.stepClickable : '',
                ].filter(Boolean).join(' ')}
                onClick={step.type === 'ki' && onKiStepClick && step.agentType
                  ? () => onKiStepClick(step.agentType!)
                  : undefined}
                title={description}
                disabled={step.type !== 'ki' || !onKiStepClick}
              >
                <span className={styles.stepIcon}>{stepIcon(step.type, status)}</span>
                <span className={styles.stepLabel}>{label}</span>
                {isActive && agentRunning && agentRun?.progress && (
                  <span className={styles.stepProgress}>
                    {agentRun.progress.current}/{agentRun.progress.total}
                  </span>
                )}
              </button>
            </div>
          );
        })}
      </div>
    </div>
  );
}
