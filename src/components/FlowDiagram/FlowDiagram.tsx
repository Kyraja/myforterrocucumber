import type { Scenario, Step, StepKeyword } from '../../types/gherkin';
import type { Translations } from '../../i18n/translations';
import { useTranslation } from '../../i18n';
import { ACTION_LABELS } from '../../lib/actionText';
import styles from './FlowDiagram.module.css';

interface FlowDiagramProps {
  scenarios: Scenario[];
  onStepClick?: (stepId: string) => void;
}

type Phase = 'setup' | 'action' | 'check';

function resolvePhase(keyword: StepKeyword, prev: Phase): Phase {
  if (keyword === 'Given') return 'setup';
  if (keyword === 'When') return 'action';
  if (keyword === 'Then') return 'check';
  return prev;
}

const PHASE_COLORS: Record<Phase, string> = {
  setup: '#89b4fa',
  action: '#fab387',
  check: '#a6e3a1',
};

interface ActionDisplay { label: string; detail: string }

type TFunc = (key: keyof Translations, params?: Record<string, string | number>) => string;

function getActionDisplay(step: Step, t: TFunc): ActionDisplay {
  const action = step.action;
  if (action.type === 'freetext') return { label: step.text || t('flow.freetext'), detail: '' };

  const label = ACTION_LABELS[action.type];
  switch (action.type) {
    case 'editorOeffnen':
      return { label, detail: `${action.editorName || '\u2026'} [${action.command}]${action.record ? ` "${action.record}"` : ''}` };
    case 'editorOeffnenSuche':
      return { label, detail: `${action.editorName || '\u2026'} [${action.command}]${action.searchCriteria ? ` "${action.searchCriteria}"` : ''}` };
    case 'editorOeffnenMenue':
      return { label, detail: `${action.editorName || '\u2026'} [${action.command}] ${action.menuChoice || ''}`.trim() };
    case 'feldSetzen':
      return { label, detail: `${action.fieldName || '\u2026'} = "${action.value || '\u2026'}"${action.row ? ` (${t('flow.row')}${action.row})` : ''}` };
    case 'feldPruefen':
      return { label, detail: `${action.fieldName || '\u2026'} == "${action.expectedValue || '\u2026'}"${action.row ? ` (${t('flow.row')}${action.row})` : ''}` };
    case 'feldLeer':
      return { label, detail: `${action.fieldName || '\u2026'} ${action.isEmpty ? t('flow.empty') : t('flow.notEmpty')}${action.row ? ` (${t('flow.row')}${action.row})` : ''}` };
    case 'feldAenderbar':
      return { label, detail: `${action.fieldName || '\u2026'} ${action.modifiable ? t('flow.editable') : t('flow.notEditable')}${action.row ? ` (${t('flow.row')}${action.row})` : ''}` };
    case 'editorSpeichern':
    case 'editorSchliessen':
    case 'zeileAnlegen':
    case 'zeilenAnfuegen':
      return { label, detail: '' };
    case 'editorWechseln':
      return { label, detail: action.editorName || '\u2026' };
    case 'buttonDruecken':
      return { label, detail: `"${action.buttonName || '\u2026'}"` };
    case 'subeditorOeffnen':
      return { label, detail: `${action.subeditorName || '\u2026'} via "${action.buttonName || '\u2026'}"${action.row ? ` (${t('flow.row')}${action.row})` : ''}` };
    case 'infosystemOeffnen':
      return { label, detail: action.infosystemName || '\u2026' };
    case 'tabelleZeilen':
      return { label, detail: `${action.rowCount || '0'} Zeilen` };
    case 'exceptionSpeichern':
      return { label, detail: `"${action.exceptionId || '\u2026'}"` };
    case 'exceptionFeld':
      return { label, detail: `${action.fieldName || '\u2026'} \u2192 "${action.exceptionId || '\u2026'}"` };
    case 'dialogBeantworten':
      return { label, detail: `"${action.answer || '\u2026'}" (${action.dialogId || '\u2026'})` };
  }
}

// --- SVG layout constants ---
const BOX_W = 280;
const BOX_H = 48;
const BOX_H_DETAIL = 64;
const ARROW_H = 32;
const EVENT_R = 14;
const PAD_X = 30;
const PAD_Y = 20;
const ARROW_HEAD = 5;
const FONT = 'system-ui, -apple-system, sans-serif';

function truncate(text: string, max: number): string {
  return text.length > max ? text.slice(0, max - 1) + '\u2026' : text;
}

function ScenarioDiagram({ scenario, onStepClick }: { scenario: Scenario; onStepClick?: (stepId: string) => void }) {
  const { t } = useTranslation();
  const cx = PAD_X + BOX_W / 2;

  // Resolve phases + compute display info
  let phase: Phase = 'setup';
  const stepData = scenario.steps.map((step) => {
    phase = resolvePhase(step.keyword, phase);
    const display = getActionDisplay(step, t);
    const h = display.detail ? BOX_H_DETAIL : BOX_H;
    return { step, phase, display, h };
  });

  // --- Build y layout with a running cursor ---
  let y = PAD_Y;

  // Start event
  const startCy = y + EVENT_R;
  y += EVENT_R * 2;

  // Arrow from start event
  const firstArrowY1 = y;
  y += ARROW_H;

  // Task boxes + inter-task arrows
  const boxes: { y: number; h: number }[] = [];
  const interArrows: { y1: number; color: string }[] = [];

  for (let i = 0; i < stepData.length; i++) {
    boxes.push({ y, h: stepData[i].h });
    y += stepData[i].h;
    interArrows.push({ y1: y, color: PHASE_COLORS[stepData[i].phase] });
    y += ARROW_H;
  }

  // End event
  const endCy = y + EVENT_R;
  y += EVENT_R * 2;
  const totalH = y + PAD_Y;
  const totalW = PAD_X * 2 + BOX_W;

  // First arrow target: top of first box or top of end event
  const firstArrowY2 = stepData.length > 0 ? boxes[0].y : endCy - EVENT_R;

  return (
    <div className={styles.scenarioBlock}>
      <div className={styles.scenarioName}>Scenario: {scenario.name || t('flow.unnamed')}</div>
      <svg
        width="100%"
        height={totalH}
        viewBox={`0 0 ${totalW} ${totalH}`}
        style={{ maxWidth: totalW }}
      >
        {/* ── Start Event (green circle + play triangle) ── */}
        <circle cx={cx} cy={startCy} r={EVENT_R} fill="#16a34a" fillOpacity={0.15} stroke="#16a34a" strokeWidth={2} />
        <polygon
          points={`${cx - 4},${startCy - 6} ${cx - 4},${startCy + 6} ${cx + 6},${startCy}`}
          fill="#16a34a" fillOpacity={0.7}
        />

        {/* ── Arrow: start → first task (or end) ── */}
        <line x1={cx} y1={firstArrowY1} x2={cx} y2={firstArrowY2} stroke="#6c7086" strokeWidth={1.5} />
        <polygon
          points={`${cx},${firstArrowY2} ${cx - ARROW_HEAD},${firstArrowY2 - ARROW_HEAD * 1.6} ${cx + ARROW_HEAD},${firstArrowY2 - ARROW_HEAD * 1.6}`}
          fill="#6c7086"
        />

        {/* ── Task boxes ── */}
        {stepData.map((d, i) => {
          const by = boxes[i].y;
          const bh = boxes[i].h;
          const color = PHASE_COLORS[d.phase];
          return (
            <g
              key={d.step.id + '-' + i}
              style={onStepClick ? { cursor: 'pointer' } : undefined}
              onClick={onStepClick ? () => onStepClick(d.step.id) : undefined}
            >
              {/* Rounded task box */}
              <rect
                x={PAD_X} y={by} width={BOX_W} height={bh}
                rx={8} ry={8}
                fill="#1e1e2e" stroke={color} strokeWidth={1.5}
                className={onStepClick ? styles.taskBox : undefined}
              />
              {/* Left accent bar */}
              <rect x={PAD_X} y={by + 4} width={4} height={bh - 8} rx={2} fill={color} />
              {/* Keyword */}
              <text x={PAD_X + 16} y={by + (d.display.detail ? 18 : 20)} fontSize={10} fontWeight={700} fill={color} fontFamily={FONT}>
                {d.step.keyword}
              </text>
              {/* Label */}
              <text x={PAD_X + 16} y={by + (d.display.detail ? 34 : 36)} fontSize={13} fontWeight={600} fill="#cdd6f4" fontFamily={FONT}>
                {truncate(d.display.label, 38)}
              </text>
              {/* Detail line */}
              {d.display.detail && (
                <text x={PAD_X + 16} y={by + 52} fontSize={11} fill="#a6adc8" fontFamily={FONT}>
                  {truncate(d.display.detail, 42)}
                </text>
              )}
            </g>
          );
        })}

        {/* ── Arrows between tasks (and last task → end) ── */}
        {interArrows.map((a, i) => {
          const isLast = i === interArrows.length - 1;
          const tipY = isLast ? endCy - EVENT_R : boxes[i + 1].y;
          return (
            <g key={'arr-' + i}>
              <line x1={cx} y1={a.y1} x2={cx} y2={tipY} stroke={a.color} strokeWidth={1.5} />
              <polygon
                points={`${cx},${tipY} ${cx - ARROW_HEAD},${tipY - ARROW_HEAD * 1.6} ${cx + ARROW_HEAD},${tipY - ARROW_HEAD * 1.6}`}
                fill={a.color}
              />
            </g>
          );
        })}

        {/* ── End Event (thick red circle + inner dot) ── */}
        <circle cx={cx} cy={endCy} r={EVENT_R} fill="none" stroke="#dc2626" strokeWidth={3} />
        <circle cx={cx} cy={endCy} r={EVENT_R - 5} fill="#dc2626" fillOpacity={0.6} />
      </svg>
    </div>
  );
}

export function FlowDiagram({ scenarios, onStepClick }: FlowDiagramProps) {
  const { t } = useTranslation();
  const nonEmpty = scenarios.filter((s) => s.steps.length > 0);

  if (nonEmpty.length === 0) {
    return (
      <div className={styles.empty}>
        <p>{t('flow.emptyState')}</p>
      </div>
    );
  }

  return (
    <div className={styles.container}>
      {nonEmpty.map((scenario) => (
        <ScenarioDiagram key={scenario.id} scenario={scenario} onStepClick={onStepClick} />
      ))}
    </div>
  );
}
