import { useState, useCallback, useRef } from 'react';
import type { ActionType } from '../../types/gherkin';
import { ACTION_LABELS, ACTION_HELP } from '../../lib/actionText';
import {
  STEP_BUILDING_BLOCKS,
  loadCustomTemplates,
  exportCustomTemplates,
  importCustomTemplates,
  removeCustomTemplate,
  type ScenarioTemplate,
} from '../../lib/templates';
import styles from './StepToolbox.module.css';

const ACTION_TYPES: ActionType[] = [
  'editorOeffnen', 'editorOeffnenSuche', 'editorOeffnenMenue',
  'feldSetzen', 'feldPruefen', 'feldLeer', 'feldAenderbar',
  'editorSpeichern', 'editorSchliessen', 'editorWechseln',
  'zeileAnlegen', 'zeilenAnfuegen', 'buttonDruecken', 'subeditorOeffnen',
  'infosystemOeffnen', 'tabelleZeilen',
  'exceptionSpeichern', 'exceptionFeld', 'dialogBeantworten',
  'freetext',
];

export function StepToolbox() {
  const [customTemplates, setCustomTemplates] = useState(() => loadCustomTemplates());
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleTemplateDragStart = useCallback((e: React.DragEvent, template: ScenarioTemplate) => {
    e.dataTransfer.effectAllowed = 'copy';
    e.dataTransfer.setData('application/x-toolbox', JSON.stringify({
      source: 'toolbox',
      type: 'template',
      templateId: template.id,
    }));
  }, []);

  const handleStepDragStart = useCallback((e: React.DragEvent, actionType: ActionType) => {
    e.dataTransfer.effectAllowed = 'copy';
    e.dataTransfer.setData('application/x-toolbox', JSON.stringify({
      source: 'toolbox',
      type: 'step',
      actionType,
    }));
  }, []);

  const handleRemoveTemplate = useCallback((id: string) => {
    removeCustomTemplate(id);
    setCustomTemplates(loadCustomTemplates());
  }, []);

  const handleExport = useCallback(() => {
    exportCustomTemplates();
  }, []);

  const handleImportClick = useCallback(() => {
    fileInputRef.current?.click();
  }, []);

  const handleImportFile = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = () => {
      importCustomTemplates(reader.result as string);
      setCustomTemplates(loadCustomTemplates());
    };
    reader.readAsText(file);
    e.target.value = '';
  }, []);

  return (
    <div className={styles.toolbox}>
      {/* Building blocks section */}
      <div className={styles.section}>
        <div className={styles.sectionHeader}>
          <h3 className={styles.sectionTitle}>Bausteine</h3>
        </div>
        <div className={styles.templateGrid}>
          {STEP_BUILDING_BLOCKS.map((block) => (
            <div
              key={block.id}
              className={styles.templateCard}
              draggable
              onDragStart={(e) => handleTemplateDragStart(e, block)}
              title={`${block.steps.length} Steps — auf Szenario ziehen`}
            >
              <span className={styles.templateIcon}>🧩</span>
              <span className={styles.templateLabel}>{block.label}</span>
              <span className={styles.templateCount}>{block.steps.length}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Custom templates section */}
      <div className={styles.section}>
        <div className={styles.sectionHeader}>
          <h3 className={styles.sectionTitle}>Eigene Vorlagen</h3>
          <div className={styles.sectionActions}>
            <button
              className={styles.actionBtn}
              onClick={handleImportClick}
              type="button"
              title="Vorlagen aus JSON-Datei importieren"
            >
              Importieren
            </button>
            <button
              className={styles.actionBtn}
              onClick={handleExport}
              disabled={customTemplates.length === 0}
              type="button"
              title={customTemplates.length > 0 ? 'Eigene Vorlagen als JSON exportieren' : 'Keine eigenen Vorlagen vorhanden'}
            >
              Exportieren
            </button>
            <input
              ref={fileInputRef}
              type="file"
              accept=".json"
              onChange={handleImportFile}
              style={{ display: 'none' }}
            />
          </div>
        </div>
        {customTemplates.length > 0 ? (
          <div className={styles.templateGrid}>
            {customTemplates.map((tmpl) => (
              <div
                key={tmpl.id}
                className={styles.templateCard}
                draggable
                onDragStart={(e) => handleTemplateDragStart(e, tmpl)}
                title={`${tmpl.steps.length} Steps — auf Szenario ziehen`}
              >
                <span className={styles.templateIcon}>🔧</span>
                <span className={styles.templateLabel}>{tmpl.label}</span>
                <span className={styles.templateCount}>{tmpl.steps.length}</span>
                <button
                  className={styles.templateRemove}
                  onClick={(e) => { e.stopPropagation(); handleRemoveTemplate(tmpl.id); }}
                  type="button"
                  title="Vorlage entfernen"
                >
                  &times;
                </button>
              </div>
            ))}
          </div>
        ) : (
          <p className={styles.emptyHint}>
            Szenario als Vorlage speichern oder JSON importieren
          </p>
        )}
      </div>

      {/* Standard steps section */}
      <div className={styles.section}>
        <h3 className={styles.sectionTitle}>Einzelne Steps</h3>
        <div className={styles.stepGrid}>
          {ACTION_TYPES.map((type) => (
            <div
              key={type}
              className={styles.stepCard}
              draggable
              onDragStart={(e) => handleStepDragStart(e, type)}
              title={ACTION_HELP[type]}
            >
              <span className={styles.stepLabel}>{ACTION_LABELS[type]}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
