/**
 * @module StepToolbox
 * Sidebar panel that provides draggable step building blocks and custom scenario templates.
 *
 * Key responsibilities:
 * - Renders built-in step building blocks (STEP_BUILDING_BLOCKS) as draggable cards.
 * - Manages user-defined custom templates stored via the templates library (load/remove).
 * - Supports JSON import and export of custom templates via file picker.
 * - Cards are dragged onto a ScenarioBuilder to append steps ('application/x-toolbox' drag data).
 */
import { useState, useCallback, useRef } from 'react';
import { useTranslation } from '../../i18n';
import {
  STEP_BUILDING_BLOCKS,
  loadCustomTemplates,
  exportCustomTemplates,
  importCustomTemplates,
  removeCustomTemplate,
  type ScenarioTemplate,
} from '../../lib/templates';
import styles from './StepToolbox.module.css';


export function StepToolbox() {
  const { lang } = useTranslation();
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
          <h3 className={styles.sectionTitle}>{lang === 'de' ? 'Bausteine' : 'Building Blocks'}</h3>
        </div>
        <div className={styles.templateGrid}>
          {STEP_BUILDING_BLOCKS.map((block) => (
            <div
              key={block.id}
              className={styles.templateCard}
              draggable
              onDragStart={(e) => handleTemplateDragStart(e, block)}
              title={lang === 'de' ? `${block.steps.length} Steps — auf Szenario ziehen` : `${block.steps.length} steps — drag onto scenario`}
            >
              <span className={styles.templateIcon}>🧩</span>
              <span className={styles.templateLabel}>{lang === 'en' && block.labelEn ? block.labelEn : block.label}</span>
              <span className={styles.templateCount}>{block.steps.length}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Custom templates section */}
      <div className={styles.section}>
        <div className={styles.sectionHeader}>
          <h3 className={styles.sectionTitle}>{lang === 'de' ? 'Eigene Vorlagen' : 'Custom Templates'}</h3>
          <div className={styles.sectionActions}>
            <button
              className={styles.actionBtn}
              onClick={handleImportClick}
              type="button"
              title={lang === 'de' ? 'Vorlagen aus JSON-Datei importieren' : 'Import templates from JSON file'}
            >
              {lang === 'de' ? 'Importieren' : 'Import'}
            </button>
            <button
              className={styles.actionBtn}
              onClick={handleExport}
              disabled={customTemplates.length === 0}
              type="button"
              title={customTemplates.length > 0 ? (lang === 'de' ? 'Eigene Vorlagen als JSON exportieren' : 'Export custom templates as JSON') : (lang === 'de' ? 'Keine eigenen Vorlagen vorhanden' : 'No custom templates available')}
            >
              {lang === 'de' ? 'Exportieren' : 'Export'}
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
                title={lang === 'de' ? `${tmpl.steps.length} Steps — auf Szenario ziehen` : `${tmpl.steps.length} steps — drag onto scenario`}
              >
                <span className={styles.templateIcon}>🔧</span>
                <span className={styles.templateLabel}>{lang === 'en' && tmpl.labelEn ? tmpl.labelEn : tmpl.label}</span>
                <span className={styles.templateCount}>{tmpl.steps.length}</span>
                <button
                  className={styles.templateRemove}
                  onClick={(e) => { e.stopPropagation(); handleRemoveTemplate(tmpl.id); }}
                  type="button"
                  title={lang === 'de' ? 'Vorlage entfernen' : 'Remove template'}
                >
                  &times;
                </button>
              </div>
            ))}
          </div>
        ) : (
          <p className={styles.emptyHint}>
            {lang === 'de' ? 'Szenario als Vorlage speichern oder JSON importieren' : 'Save scenario as template or import JSON'}
          </p>
        )}
      </div>

    </div>
  );
}
