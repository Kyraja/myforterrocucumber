import { useState } from 'react';
import type { Scenario, Step, TableDef, ActionType } from '../../types/gherkin';
import { useTranslation } from '../../i18n';
import { stepTextFromAction, createDefaultAction } from '../../lib/actionText';
import { generateSearchWord } from '../../lib/recordTracker';
import type { CreatedRecord } from '../../lib/recordTracker';
import { getAllTemplates, createScenarioFromTemplate } from '../../lib/templates';
import { StepRow } from '../StepRow/StepRow';
import styles from './ScenarioBuilder.module.css';

interface ScenarioBuilderProps {
  scenario: Scenario;
  onChange: (updated: Scenario) => void;
  onRemove: () => void;
  tables: TableDef[];
  createdRecords: CreatedRecord[];
  existingSearchWords: string[];
}

/** Find the tableRef from the most recent editorOeffnen/infosystemOeffnen step before the given index */
function currentTableRefAt(steps: Step[], index: number): string | undefined {
  for (let i = index - 1; i >= 0; i--) {
    const a = steps[i].action;
    if (a.type === 'editorOeffnen' || a.type === 'editorOeffnenSuche' || a.type === 'editorOeffnenMenue') {
      return a.tableRef || undefined;
    }
    if (a.type === 'infosystemOeffnen') {
      return a.infosystemRef || a.infosystemName || undefined;
    }
  }
  return undefined;
}

export function ScenarioBuilder({
  scenario, onChange, onRemove, tables, createdRecords, existingSearchWords,
}: ScenarioBuilderProps) {
  const { t } = useTranslation();
  const [dragIdx, setDragIdx] = useState<number | null>(null);
  const [dragOverIdx, setDragOverIdx] = useState<number | null>(null);

  const addStep = () => {
    const action = createDefaultAction('feldSetzen');
    const { keyword, text } = stepTextFromAction(action);
    const step: Step = {
      id: crypto.randomUUID(),
      keyword,
      text,
      action,
    };
    onChange({ ...scenario, steps: [...scenario.steps, step] });
  };

  const updateStep = (index: number, updated: Step) => {
    const steps = [...scenario.steps];
    steps[index] = updated;

    // Auto-fill search word: when editorOeffnen NEW gets an editorName,
    // fill the next feldSetzen "such" step with a generated search word
    const a = updated.action;
    if (a.type === 'editorOeffnen' && a.command === 'NEW' && a.editorName) {
      const next = steps[index + 1];
      if (
        next?.action.type === 'feldSetzen' &&
        next.action.fieldName === 'such' &&
        (!next.action.value || next.action.autoSearchWord)
      ) {
        const word = generateSearchWord(a.editorName, existingSearchWords);
        if (word) {
          const updatedAction = { ...next.action, value: word, autoSearchWord: true };
          const { keyword, text } = stepTextFromAction(updatedAction);
          steps[index + 1] = { ...next, action: updatedAction, keyword, text };
        }
      }
    }

    onChange({ ...scenario, steps });
  };

  const removeStep = (index: number) => {
    onChange({ ...scenario, steps: scenario.steps.filter((_, i) => i !== index) });
  };

  const duplicateStep = (index: number) => {
    const original = scenario.steps[index];
    const cloned: Step = {
      ...JSON.parse(JSON.stringify(original)),
      id: crypto.randomUUID(),
    };
    const steps = [...scenario.steps];
    steps.splice(index + 1, 0, cloned);
    onChange({ ...scenario, steps });
  };

  // Check if a drag event comes from the toolbox
  const isToolboxDrag = (e: React.DragEvent) =>
    e.dataTransfer.types.includes('application/x-toolbox');

  // Parse toolbox drag data and create steps
  const createStepsFromToolbox = (data: string): Step[] => {
    try {
      const parsed = JSON.parse(data);
      if (parsed.source !== 'toolbox') return [];

      if (parsed.type === 'template') {
        const templates = getAllTemplates();
        const tmpl = templates.find((t) => t.id === parsed.templateId);
        if (!tmpl) return [];
        const scenario = createScenarioFromTemplate(tmpl);
        return scenario.steps;
      }

      if (parsed.type === 'step') {
        const actionType = parsed.actionType as ActionType;
        const action = createDefaultAction(actionType);
        const { keyword, text } = stepTextFromAction(action);
        return [{
          id: crypto.randomUUID(),
          keyword,
          text,
          action,
        }];
      }
    } catch { /* ignore */ }
    return [];
  };

  // Drag & drop handlers
  const handleDragStart = (e: React.DragEvent, index: number) => {
    e.dataTransfer.effectAllowed = 'move';
    e.dataTransfer.setData('text/plain', String(index));
    setDragIdx(index);
  };

  const handleDragOver = (e: React.DragEvent, index: number) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = isToolboxDrag(e) ? 'copy' : 'move';
    if (dragOverIdx !== index) setDragOverIdx(index);
  };

  const handleDrop = (e: React.DragEvent, targetIdx: number) => {
    e.preventDefault();

    // Handle toolbox drops (external)
    const toolboxData = e.dataTransfer.getData('application/x-toolbox');
    if (toolboxData) {
      const newSteps = createStepsFromToolbox(toolboxData);
      if (newSteps.length > 0) {
        const steps = [...scenario.steps];
        steps.splice(targetIdx, 0, ...newSteps);
        onChange({ ...scenario, steps });
      }
      setDragIdx(null);
      setDragOverIdx(null);
      return;
    }

    // Handle internal reorder
    if (dragIdx === null || dragIdx === targetIdx) {
      setDragIdx(null);
      setDragOverIdx(null);
      return;
    }
    const steps = [...scenario.steps];
    const [moved] = steps.splice(dragIdx, 1);
    steps.splice(targetIdx, 0, moved);
    onChange({ ...scenario, steps });
    setDragIdx(null);
    setDragOverIdx(null);
  };

  const handleDragEnd = () => {
    setDragIdx(null);
    setDragOverIdx(null);
  };

  return (
    <div className={styles.scenario}>
      <div className={styles.header}>
        <input
          className={styles.name}
          type="text"
          value={scenario.name}
          onChange={(e) => onChange({ ...scenario, name: e.target.value })}
          placeholder={t('scenario.namePlaceholder')}
          aria-label={t('scenario.nameLabel')}
        />
        <button
          className={styles.remove}
          onClick={onRemove}
          type="button"
          aria-label={t('scenario.remove')}
        >
          &times;
        </button>
      </div>

      <textarea
        className={styles.comment}
        value={scenario.comment || ''}
        onChange={(e) => onChange({ ...scenario, comment: e.target.value })}
        placeholder={t('scenario.commentPlaceholder')}
        rows={1}
      />

      <div className={styles.steps}>
        {scenario.steps.map((step, i) => (
          <div
            key={step.id}
            className={`${styles.stepWrapper}${dragIdx === i ? ` ${styles.stepDragging}` : ''}${dragOverIdx === i && dragIdx !== i ? ` ${styles.stepDragOver}` : ''}`}
            draggable
            onDragStart={(e) => handleDragStart(e, i)}
            onDragOver={(e) => handleDragOver(e, i)}
            onDrop={(e) => handleDrop(e, i)}
            onDragEnd={handleDragEnd}
          >
            <div className={styles.dragHandle} title={t('scenario.move')}>&#x2807;</div>
            <StepRow
              step={step}
              onChange={(updated) => updateStep(i, updated)}
              onRemove={() => removeStep(i)}
              onDuplicate={() => duplicateStep(i)}
              tables={tables}
              currentTableRef={currentTableRefAt(scenario.steps, i)}
              createdRecords={createdRecords}
            />
          </div>
        ))}
        {/* Drop zone at the end for appending */}
        <div
          className={`${styles.dropZoneEnd}${dragOverIdx === scenario.steps.length ? ` ${styles.dropZoneEndActive}` : ''}`}
          onDragOver={(e) => handleDragOver(e, scenario.steps.length)}
          onDrop={(e) => handleDrop(e, scenario.steps.length)}
          onDragLeave={handleDragEnd}
        >
          Step hierhin ziehen
        </div>
      </div>

      <button className={styles.addStep} onClick={addStep} type="button">
        {t('scenario.addStep')}
      </button>
    </div>
  );
}
