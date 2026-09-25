import { useState, useCallback, useEffect, useMemo, useRef } from 'react';
import { useTranslation } from '../../i18n';
import type { FeatureInput, Scenario } from '../../types/gherkin';
import {
  STEP_BUILDING_BLOCKS,
  createScenarioFromTemplate,
  loadCustomTemplates,
  exportCustomTemplates,
  importCustomTemplates,
  removeCustomTemplate,
  reorderCustomTemplates,
  saveOrUpdateCustomTemplate,
  type ScenarioTemplate,
} from '../../lib/templates';
import { ConfirmDialog } from '../ConfirmDialog/ConfirmDialog';
import { IconPlus, IconCopy, IconImport, IconExport, IconTrash, IconLoad, IconSave } from '../icons';
import styles from './StepToolbox.module.css';

interface StepToolboxProps {
  feature?: FeatureInput;
  onStartTemplateEdit?: (draft: FeatureInput, templateName: string, templateId: string | null) => void;
  onTemplateSaved?: (templateId: string, templateName: string) => void;
  onCloseTemplateEditor?: () => void;
  templateEditingName?: string | null;
  templateEditingId?: string | null;
  isTemplateDirty?: boolean;
  templateSaveTick?: number;
}

function getTemplateLabel(template: ScenarioTemplate, lang: 'de' | 'en'): string {
  const de = template.label?.trim();
  const en = template.labelEn?.trim();
  if (lang === 'en') return en || de || '';
  return de || en || '';
}

function emptyFeatureFromName(name = ''): FeatureInput {
  return {
    name,
    description: '',
    tags: [],
    database: null,
    testUser: '',
    scenarios: [{ id: crypto.randomUUID(), name, steps: [] }],
  };
}

function featureFromTemplate(template: ScenarioTemplate, lang: 'de' | 'en'): FeatureInput {
  const label = getTemplateLabel(template, lang);
  const scenario = createScenarioFromTemplate(template);
  scenario.name = label;
  return {
    name: label,
    description: '',
    tags: [],
    database: null,
    testUser: '',
    scenarios: [scenario],
  };
}

export function StepToolbox({
  feature,
  onStartTemplateEdit,
  onTemplateSaved,
  onCloseTemplateEditor,
  templateEditingName,
  templateEditingId,
  isTemplateDirty = false,
  templateSaveTick,
}: StepToolboxProps) {
  const { lang, t } = useTranslation();
  const [customTemplates, setCustomTemplates] = useState<ScenarioTemplate[]>(() => loadCustomTemplates());
  const [selectedTemplateId, setSelectedTemplateId] = useState('');
  const [selectedExportIds, setSelectedExportIds] = useState<Set<string>>(new Set());
  const [searchTerm, setSearchTerm] = useState('');
  const [saveFlashActive, setSaveFlashActive] = useState(false);
  const [showDeleteTemplateConfirm, setShowDeleteTemplateConfirm] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const dragTemplateIdRef = useRef<string | null>(null);

  const allTemplates = useMemo(
    () => [...STEP_BUILDING_BLOCKS, ...customTemplates],
    [customTemplates],
  );

  useEffect(() => {
    if (allTemplates.some((tmpl) => tmpl.id === selectedTemplateId)) return;
    setSelectedTemplateId('');
  }, [allTemplates, selectedTemplateId]);

  useEffect(() => {
    // Keep export selection in sync with current custom template ids.
    setSelectedExportIds((prev) => {
      const validIds = new Set(customTemplates.map((t) => t.id));
      const next = new Set<string>();
      for (const id of prev) {
        if (validIds.has(id)) next.add(id);
      }
      return next;
    });
  }, [customTemplates]);

  useEffect(() => {
    if (templateEditingId) setSelectedTemplateId(templateEditingId);
  }, [templateEditingName, templateEditingId]);

  useEffect(() => {
    if (templateSaveTick === undefined) return;
    setSaveFlashActive(true);
    const timer = window.setTimeout(() => setSaveFlashActive(false), 1400);
    return () => window.clearTimeout(timer);
  }, [templateSaveTick]);

  const selectedTemplate = allTemplates.find((tmpl) => tmpl.id === selectedTemplateId) ?? null;
  const selectedIsCustom = !!selectedTemplate?.custom;
  const isEditingExistingCustom = Boolean(templateEditingId);

  const normalizedSearch = searchTerm.trim().toLocaleLowerCase();
  const matchesSearch = useCallback((template: ScenarioTemplate) => {
    if (!normalizedSearch) return true;
    return (
      template.label.toLocaleLowerCase().includes(normalizedSearch)
      || template.labelEn?.toLocaleLowerCase().includes(normalizedSearch)
    );
  }, [normalizedSearch]);

  const filteredCustomTemplates = useMemo(
    () => customTemplates.filter(matchesSearch),
    [customTemplates, matchesSearch],
  );
  const filteredSuggestedTemplates = useMemo(
    () => STEP_BUILDING_BLOCKS.filter(matchesSearch),
    [matchesSearch],
  );
  const handleTemplateDragStart = useCallback((e: React.DragEvent, template: ScenarioTemplate) => {
    dragTemplateIdRef.current = template.custom ? template.id : null;
    e.dataTransfer.effectAllowed = template.custom ? 'copyMove' : 'copy';
    e.dataTransfer.setData('application/x-toolbox', JSON.stringify({
      source: 'toolbox',
      type: 'template',
      templateId: template.id,
    }));
    if (template.custom) {
      e.dataTransfer.setData('application/x-template-reorder', template.id);
    }
  }, []);

  const handleTemplateDragEnd = useCallback(() => {
    dragTemplateIdRef.current = null;
  }, []);

  const moveCustomTemplate = useCallback((draggedId: string, targetId: string) => {
    if (!draggedId || !targetId || draggedId === targetId) return;
    const ids = customTemplates.map((t) => t.id);
    const from = ids.indexOf(draggedId);
    const to = ids.indexOf(targetId);
    if (from < 0 || to < 0) return;

    const nextIds = [...ids];
    const [moved] = nextIds.splice(from, 1);
    nextIds.splice(to, 0, moved);
    const next = reorderCustomTemplates(nextIds);
    setCustomTemplates(next);
  }, [customTemplates]);

  const handleTemplateDrop = useCallback((e: React.DragEvent, targetId: string) => {
    e.preventDefault();
    e.stopPropagation();
    const draggedId = e.dataTransfer.getData('application/x-template-reorder') || dragTemplateIdRef.current;
    if (!draggedId) return;
    moveCustomTemplate(draggedId, targetId);
  }, [moveCustomTemplate]);

  const toggleExportSelection = useCallback((id: string) => {
    setSelectedExportIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }, []);

  const handleSelectAllExport = useCallback(() => {
    setSelectedExportIds(new Set(customTemplates.map((t) => t.id)));
  }, [customTemplates]);

  const handleClearExportSelection = useCallback(() => {
    setSelectedExportIds(new Set());
  }, []);

  const handleNewTemplate = useCallback(() => {
    const draft = emptyFeatureFromName('');
    setSelectedTemplateId('');
    onStartTemplateEdit?.(draft, '', null);
  }, [onStartTemplateEdit]);

  const handleOpenTemplate = useCallback((template: ScenarioTemplate) => {
    const draft = featureFromTemplate(template, lang as 'de' | 'en');
    setSelectedTemplateId(template.id);
    onStartTemplateEdit?.(draft, getTemplateLabel(template, lang as 'de' | 'en'), template.custom ? template.id : null);
  }, [lang, onStartTemplateEdit]);

  const handleLoadTemplate = useCallback((template?: ScenarioTemplate) => {
    const source = template ?? selectedTemplate;
    if (!source) return;
    const draft = featureFromTemplate(source, lang as 'de' | 'en');
    setSelectedTemplateId(source.id);
    onStartTemplateEdit?.(draft, getTemplateLabel(source, lang as 'de' | 'en'), source.custom ? source.id : null);
  }, [lang, onStartTemplateEdit, selectedTemplate]);

  const handleSaveTemplate = useCallback(() => {
    if (!feature) return;
    const sourceScenario: Scenario = feature.scenarios[0] ?? { id: crypto.randomUUID(), name: '', steps: [] };
    const label = (
      templateEditingName?.trim()
      || feature.name?.trim()
      || sourceScenario.name?.trim()
      || (selectedTemplate ? getTemplateLabel(selectedTemplate, lang as 'de' | 'en') : '')
      || 'Eigene Vorlage'
    ).trim();
    const saved = saveOrUpdateCustomTemplate(sourceScenario, {
      templateId: templateEditingId ?? undefined,
      label,
      lang: lang as 'de' | 'en',
    });
    const nextCustom = loadCustomTemplates();
    setCustomTemplates(nextCustom);
    setSelectedTemplateId(saved.id);
    onTemplateSaved?.(saved.id, getTemplateLabel(saved, lang as 'de' | 'en'));
  }, [feature, lang, onTemplateSaved, selectedTemplate, templateEditingId, templateEditingName]);

  const handleSaveTemplateAs = useCallback(() => {
    if (!feature) return;
    const sourceScenario: Scenario = feature.scenarios[0] ?? { id: crypto.randomUUID(), name: '', steps: [] };
    const label = (
      templateEditingName?.trim()
      || feature.name?.trim()
      || sourceScenario.name?.trim()
      || (selectedTemplate ? getTemplateLabel(selectedTemplate, lang as 'de' | 'en') : '')
      || 'Eigene Vorlage'
    ).trim();
    const saved = saveOrUpdateCustomTemplate(sourceScenario, {
      label,
      lang: lang as 'de' | 'en',
    });
    const nextCustom = loadCustomTemplates();
    setCustomTemplates(nextCustom);
    setSelectedTemplateId(saved.id);
    onTemplateSaved?.(saved.id, getTemplateLabel(saved, lang as 'de' | 'en'));
  }, [feature, lang, onTemplateSaved, selectedTemplate, templateEditingName]);

  const handleDeleteTemplate = useCallback(() => {
    if (!selectedTemplate || !selectedTemplate.custom) return;
    setShowDeleteTemplateConfirm(true);
  }, [selectedTemplate]);

  const confirmDeleteTemplate = useCallback(() => {
    if (!selectedTemplate || !selectedTemplate.custom) return;
    removeCustomTemplate(selectedTemplate.id);
    const nextCustom = loadCustomTemplates();
    setCustomTemplates(nextCustom);
    setSelectedTemplateId('');
    setShowDeleteTemplateConfirm(false);
    if (templateEditingId === selectedTemplate.id) {
      onCloseTemplateEditor?.();
    }
  }, [onCloseTemplateEditor, selectedTemplate, templateEditingId]);

  const handleDuplicateTemplate = useCallback(() => {
    if (!selectedTemplate) return;
    const duplicated = featureFromTemplate(selectedTemplate);
    const duplicateName = `${getTemplateLabel(selectedTemplate, lang as 'de' | 'en')} ${t('app.copy')}`;
    duplicated.name = duplicateName;
    if (duplicated.scenarios[0]) duplicated.scenarios[0].name = duplicateName;
    setSelectedTemplateId('');
    onStartTemplateEdit?.(duplicated, duplicateName, null);
  }, [lang, onStartTemplateEdit, selectedTemplate, t]);

  const handleExportAll = useCallback(() => {
    exportCustomTemplates();
  }, []);

  const handleExportSelected = useCallback(() => {
    if (selectedExportIds.size === 0) return;
    exportCustomTemplates(Array.from(selectedExportIds));
  }, [selectedExportIds]);

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
      <div className={styles.section}>
        <div className={styles.sectionHeader}>
          <h3 className={styles.sectionTitle}>{t('action.templateTitle')}</h3>
        </div>
        <div className={styles.templateToolbar}>
          <button className={styles.actionBtn} onClick={handleNewTemplate} type="button">
            <IconPlus />{t('action.templateNew')}
          </button>
          <button
            className={styles.actionBtn}
            onClick={handleDuplicateTemplate}
            disabled={!selectedTemplate}
            type="button"
          >
            <IconCopy />{t('action.templateDuplicate')}
          </button>
          {templateEditingId && onCloseTemplateEditor && (
            <button className={styles.actionBtn} onClick={onCloseTemplateEditor} type="button">
              {t('action.templateCloseEditor')}
            </button>
          )}
          <button className={styles.actionBtn} onClick={handleImportClick} type="button">
            <IconImport />{t('form.import')}
          </button>
          <button
            className={`${styles.actionBtn} ${styles.actionBtnExport}`}
            onClick={handleExportAll}
            disabled={customTemplates.length === 0}
            type="button"
          >
            <IconExport />{t('toolbox.exportAll')}
          </button>
          <button
            className={`${styles.actionBtn} ${styles.actionBtnExport}`}
            onClick={handleExportSelected}
            disabled={selectedExportIds.size === 0}
            type="button"
          >
            <IconExport />{t('toolbox.exportSelected', { count: selectedExportIds.size })}
          </button>
        </div>
        {templateEditingName !== null && (
          <div className={isTemplateDirty ? styles.statusWarn : saveFlashActive ? styles.statusFlash : styles.statusOk}>
            {isTemplateDirty ? t('action.templateUnsaved') : t('action.templateSavedState')}
          </div>
        )}
        <div className={styles.searchRow}>
          <input
            className={styles.searchInput}
            type="search"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            placeholder={t('action.templateSearchPlaceholder')}
            aria-label={t('action.templateSearchPlaceholder')}
          />
        </div>
        <div className={styles.featureTemplateControls}>
          <button
            className={styles.actionBtn}
            onClick={() => handleLoadTemplate()}
            disabled={!selectedTemplate}
            type="button"
          >
            <IconLoad />{t('action.templateUse')}
          </button>
          <button
            className={styles.actionBtn}
            onClick={handleSaveTemplate}
            disabled={!feature || !isEditingExistingCustom}
            type="button"
          >
            <IconSave />{t('action.templateSave')}
          </button>
          <button
            className={styles.actionBtn}
            onClick={handleSaveTemplateAs}
            disabled={!feature}
            type="button"
          >
            <IconSave />{t('action.templateSaveAs')}
          </button>
          <div className={styles.featureTemplateControlsSpacer} />
          <button
            className={`${styles.actionBtn} ${styles.actionBtnDanger}`}
            onClick={handleDeleteTemplate}
            disabled={!selectedTemplate || !selectedIsCustom}
            type="button"
          >
            <IconTrash />{t('action.templateDelete')}
          </button>
          <input
            ref={fileInputRef}
            type="file"
            accept=".json"
            onChange={handleImportFile}
            style={{ display: 'none' }}
          />
        </div>
        <p className={styles.saveHint}>{t('action.templateSaveHint')}</p>
        <p className={styles.emptyHint}>
          {t('toolbox.clickOrDragHint')}
        </p>
        {customTemplates.length > 0 && (
          <div className={styles.customTemplateRowActions}>
            <button className={styles.actionBtn} type="button" onClick={handleSelectAllExport}>
              {t('toolbox.selectionAll')}
            </button>
            <button className={styles.actionBtn} type="button" onClick={handleClearExportSelection}>
              {t('toolbox.selectionClear')}
            </button>
            <span className={styles.selectionHint}>
              {t('toolbox.reorderHint')}
            </span>
          </div>
        )}
        {(filteredCustomTemplates.length > 0 || filteredSuggestedTemplates.length > 0) ? (
          <div className={styles.templateGroups}>
            <div className={styles.templateGroup}>
              <div className={styles.groupTitle}>{t('action.templateGroupCustom')}</div>
              {filteredCustomTemplates.length > 0 ? (
                <div className={styles.templateGrid}>
                  {filteredCustomTemplates.map((template) => (
                    <div
                      key={template.id}
                      className={template.id === templateEditingId ? styles.featureTemplateCardActive : styles.featureTemplateCard}
                      draggable
                      onDragStart={(e) => handleTemplateDragStart(e, template)}
                      onDragEnd={handleTemplateDragEnd}
                      onDragOver={(e) => {
                        e.preventDefault();
                        e.dataTransfer.dropEffect = 'move';
                      }}
                      onDrop={(e) => handleTemplateDrop(e, template.id)}
                      title={t('toolbox.stepsClickOrDrag', { count: template.steps.length })}
                    >
                      <label className={styles.templateExportSelect} title={t('toolbox.selectForExport')}>
                        <input
                          type="checkbox"
                          checked={selectedExportIds.has(template.id)}
                          onChange={() => toggleExportSelection(template.id)}
                        />
                      </label>
                      <button
                        className={styles.templateCardMain}
                        onClick={() => {
                          handleOpenTemplate(template);
                        }}
                        type="button"
                      >
                        <span className={styles.templateLabel}>{getTemplateLabel(template, lang as 'de' | 'en')}</span>
                        <span className={styles.templateMeta}>
                          {t('toolbox.customTemplate')}
                        </span>
                      </button>
                      <button
                        className={styles.templateCardAction}
                        onClick={() => handleLoadTemplate(template)}
                        type="button"
                      >
                        {t('action.templateUse')}
                      </button>
                    </div>
                  ))}
                </div>
              ) : (
                <p className={styles.emptyHint}>{t('action.templateEmpty')}</p>
              )}
            </div>

            <div className={styles.templateGroup}>
              <div className={styles.groupTitle}>{t('action.templateGroupSuggested')}</div>
              {filteredSuggestedTemplates.length > 0 ? (
                <div className={styles.templateGrid}>
                  {filteredSuggestedTemplates.map((template) => (
                    <div
                      key={template.id}
                      className={template.id === templateEditingId ? styles.featureTemplateCardActive : styles.featureTemplateCard}
                      draggable
                      onDragStart={(e) => handleTemplateDragStart(e, template)}
                      title={t('toolbox.stepsClickOrDrag', { count: template.steps.length })}
                    >
                      <button
                        className={styles.templateCardMain}
                        onClick={() => {
                          handleOpenTemplate(template);
                        }}
                        type="button"
                      >
                        <span className={styles.templateLabel}>{getTemplateLabel(template, lang as 'de' | 'en')}</span>
                        <span className={styles.templateMeta}>
                          {t('toolbox.suggested')}
                        </span>
                      </button>
                      <button
                        className={styles.templateCardAction}
                        onClick={() => handleLoadTemplate(template)}
                        type="button"
                      >
                        {t('action.templateUse')}
                      </button>
                    </div>
                  ))}
                </div>
              ) : (
                <p className={styles.emptyHint}>{t('action.templateEmpty')}</p>
              )}
            </div>
          </div>
        ) : (
          <p className={styles.emptyHint}>
            {t('action.templateEmpty')}
          </p>
        )}
      </div>

      {showDeleteTemplateConfirm && selectedTemplate && (
        <ConfirmDialog
          title={t('toolbox.deleteTemplateTitle')}
          message={t('action.templateDeleteConfirm', { name: getTemplateLabel(selectedTemplate, lang as 'de' | 'en') })}
          confirmLabel={t('toolbox.delete')}
          cancelLabel={t('bulk.cancel')}
          onConfirm={confirmDeleteTemplate}
          onCancel={() => setShowDeleteTemplateConfirm(false)}
        />
      )}
    </div>
  );
}
