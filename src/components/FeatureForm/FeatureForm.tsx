import { useMemo, useState, useEffect, useRef } from 'react';
import type { FeatureInput, Scenario, TableDef } from '../../types/gherkin';
import type { GenerationStep } from '../../hooks/useAiGeneration';
import { useTranslation } from '../../i18n';
import { ratePrompt, ratingColor } from '../../lib/promptRating';
import type { AiPromptRating } from '../../lib/aiPrompt';
import { extractCreatedRecords, collectExistingSearchWords } from '../../lib/recordTracker';
import { getScenarioTemplates, createScenarioFromTemplate, saveCustomTemplate, removeCustomTemplate, exportCustomTemplates, importCustomTemplates } from '../../lib/templates';
import type { ScenarioTemplate } from '../../lib/templates';
import { ScenarioBuilder } from '../ScenarioBuilder/ScenarioBuilder';
import styles from './FeatureForm.module.css';

function useElapsed(running: boolean) {
  const [elapsed, setElapsed] = useState(0);
  const start = useRef(0);
  useEffect(() => {
    if (!running) { setElapsed(0); return; }
    start.current = Date.now();
    const id = setInterval(() => setElapsed(Math.floor((Date.now() - start.current) / 1000)), 1000);
    return () => clearInterval(id);
  }, [running]);
  return elapsed;
}

interface FeatureFormProps {
  feature: FeatureInput;
  onChange: (updated: FeatureInput) => void;
  showGenerate?: boolean;
  onGenerate?: () => void;
  generating?: boolean;
  generationStep?: GenerationStep;
  generateError?: string | null;
  tables?: TableDef[];
  aiRating?: AiPromptRating | null;
  standaloneAiRating?: AiPromptRating | null;
  onRequestRating?: () => void;
  ratingLoading?: boolean;
  ratingError?: string | null;
}

export function FeatureForm({
  feature,
  onChange,
  showGenerate = false,
  onGenerate,
  generating = false,
  generationStep = 'idle',
  generateError = null,
  tables = [],
  aiRating = null,
  standaloneAiRating = null,
  onRequestRating,
  ratingLoading = false,
  ratingError = null,
}: FeatureFormProps) {
  const { t, lang } = useTranslation();
  const elapsed = useElapsed(generating);
  const [activeScenarioIdx, setActiveScenarioIdx] = useState(0);
  const [templates, setTemplates] = useState<ScenarioTemplate[]>(() => getScenarioTemplates());

  // Clamp active index when scenarios change (e.g. AI replaces all scenarios)
  useEffect(() => {
    if (feature.scenarios.length === 0) {
      setActiveScenarioIdx(0);
    } else if (activeScenarioIdx >= feature.scenarios.length) {
      setActiveScenarioIdx(feature.scenarios.length - 1);
    }
  }, [feature.scenarios.length, activeScenarioIdx]);

  const createdRecords = useMemo(
    () => extractCreatedRecords(feature.scenarios),
    [feature.scenarios],
  );
  const existingSearchWords = useMemo(
    () => collectExistingSearchWords(feature.scenarios),
    [feature.scenarios],
  );

  const addScenario = () => {
    const scenario: Scenario = {
      id: crypto.randomUUID(),
      name: '',
      steps: [],
    };
    onChange({ ...feature, scenarios: [...feature.scenarios, scenario] });
    setActiveScenarioIdx(feature.scenarios.length);
  };

  const addFromTemplate = (templateId: string) => {
    const template = templates.find((t) => t.id === templateId);
    if (!template) return;
    const scenario = createScenarioFromTemplate(template);
    onChange({ ...feature, scenarios: [...feature.scenarios, scenario] });
    setActiveScenarioIdx(feature.scenarios.length);
  };

  const handleSaveAsTemplate = () => {
    if (!activeScenario || activeScenario.steps.length === 0) return;
    saveCustomTemplate(activeScenario);
    setTemplates(getScenarioTemplates());
  };

  const handleRemoveTemplate = (id: string) => {
    removeCustomTemplate(id);
    setTemplates(getScenarioTemplates());
  };

  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleExportTemplates = () => {
    exportCustomTemplates();
  };

  const handleImportTemplates = () => {
    fileInputRef.current?.click();
  };

  const handleImportFile = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = () => {
      const text = reader.result as string;
      importCustomTemplates(text);
      setTemplates(getScenarioTemplates());
    };
    reader.readAsText(file);
    e.target.value = '';
  };

  const hasCustomTemplates = templates.some((t) => t.custom);

  const updateScenario = (index: number, updated: Scenario) => {
    const scenarios = [...feature.scenarios];
    scenarios[index] = updated;
    onChange({ ...feature, scenarios });
  };

  const removeScenario = (index: number) => {
    onChange({ ...feature, scenarios: feature.scenarios.filter((_, i) => i !== index) });
    setActiveScenarioIdx((prev) => {
      if (prev > index) return prev - 1;
      if (prev === index) return Math.min(prev, feature.scenarios.length - 2);
      return prev;
    });
  };

  const duplicateScenario = (index: number) => {
    const original = feature.scenarios[index];
    const cloned: Scenario = {
      ...JSON.parse(JSON.stringify(original)),
      id: crypto.randomUUID(),
      name: original.name ? `${original.name} (${t('app.copy')})` : '',
    };
    // Give each step a new ID
    cloned.steps = cloned.steps.map((s: typeof cloned.steps[0]) => ({
      ...s,
      id: crypto.randomUUID(),
    }));
    const scenarios = [...feature.scenarios];
    scenarios.splice(index + 1, 0, cloned);
    onChange({ ...feature, scenarios });
    setActiveScenarioIdx(index + 1);
  };

  const handleTagsChange = (value: string) => {
    const tags = value
      .split(/[\s,]+/)
      .filter(Boolean)
      .map((t) => (t.startsWith('@') ? t : `@${t}`));
    onChange({ ...feature, tags });
  };

  const activeScenario = feature.scenarios[activeScenarioIdx];

  return (
    <div className={styles.form}>
      <div className={styles.fieldRow}>
        <div className={styles.field}>
          <label className={styles.label} htmlFor="feature-name">
            {t('form.featureName')}
            <span className={styles.helpIcon} title={t('form.featureNameHelp')}>?</span>
          </label>
          <input
            id="feature-name"
            className={styles.input}
            type="text"
            value={feature.name}
            onChange={(e) => onChange({ ...feature, name: e.target.value })}
            placeholder={t('form.featureNamePlaceholder')}
          />
        </div>

        <div className={styles.field}>
          <label className={styles.label} htmlFor="test-user">
            {t('form.testUser')}
            <span className={styles.helpIcon} title={t('form.testUserHelp')}>?</span>
          </label>
          <input
            id="test-user"
            className={styles.input}
            type="text"
            value={feature.testUser}
            onChange={(e) => onChange({ ...feature, testUser: e.target.value })}
            placeholder={t('form.testUserPlaceholder')}
          />
        </div>
      </div>

      <div className={styles.field}>
        <label className={styles.label} htmlFor="feature-desc">
          {showGenerate ? t('form.requirementText') : t('form.description')}
          <span className={styles.helpIcon} title={showGenerate ? t('form.requirementHelp') : t('form.descriptionHelp')}>?</span>
        </label>
        <textarea
          id="feature-desc"
          className={styles.textarea}
          value={feature.description}
          onChange={(e) => onChange({ ...feature, description: e.target.value })}
          placeholder={
            showGenerate
              ? t('form.requirementPlaceholder')
              : t('form.descriptionPlaceholder')
          }
          rows={showGenerate ? 6 : 3}
        />
        {showGenerate && (
          <>
            {feature.description.trim() && (() => {
              const rating = ratePrompt(feature.description, tables.length > 0, lang);
              const color = ratingColor(rating.score);
              return (
                <div className={styles.ratingSection}>
                  <div className={styles.ratingRow}>
                    <div className={styles.ratingColumn}>
                      <span className={styles.ratingLabel}>{t('form.preRating')}</span>
                      <div className={styles.ratingHeader}>
                        <span className={styles.ratingBadge} style={{ background: color }}>
                          {rating.score}%
                        </span>
                        <div className={styles.ratingBar}>
                          <div
                            className={styles.ratingBarFill}
                            style={{ width: `${rating.score}%`, background: color }}
                          />
                        </div>
                      </div>
                    </div>
                    {(() => {
                      const effectiveAiRating = standaloneAiRating || aiRating;
                      if (!effectiveAiRating) return null;
                      return (
                        <div className={styles.ratingColumn}>
                          <span className={styles.ratingLabel}>
                            {standaloneAiRating ? t('form.requestRating') : t('form.aiRating')}
                          </span>
                          <div className={styles.ratingHeader}>
                            <span className={styles.ratingBadge} style={{ background: ratingColor(effectiveAiRating.score) }}>
                              {effectiveAiRating.score}%
                            </span>
                            <div className={styles.ratingBar}>
                              <div
                                className={styles.ratingBarFill}
                                style={{ width: `${effectiveAiRating.score}%`, background: ratingColor(effectiveAiRating.score) }}
                              />
                            </div>
                          </div>
                          {effectiveAiRating.reason && (
                            <span className={styles.ratingReason}>{effectiveAiRating.reason}</span>
                          )}
                        </div>
                      );
                    })()}
                  </div>
                  {(() => {
                    const effectiveAiRating = standaloneAiRating || aiRating;
                    const hasPreSuggestions = rating.suggestions.length > 0;
                    const hasAiSuggestions = effectiveAiRating && effectiveAiRating.suggestions.length > 0;
                    const hasInconsistencies = effectiveAiRating?.inconsistencies && effectiveAiRating.inconsistencies.length > 0;
                    if (!hasPreSuggestions && !hasAiSuggestions && !hasInconsistencies) return null;
                    return (
                      <>
                        {(hasPreSuggestions || hasAiSuggestions) && (
                          <div className={styles.suggestionsRow}>
                            {hasPreSuggestions && (
                              <div className={styles.suggestionsColumn}>
                                <span className={styles.suggestionsLabel}>{t('form.preRatingSuggestions')}</span>
                                <ul className={styles.ratingSuggestions}>
                                  {rating.suggestions.map((s, i) => (
                                    <li key={i} className={styles.suggestionItem}>
                                      <span>{s.text}</span>
                                      <div className={styles.suggestionTooltip}>
                                        <div className={styles.tooltipBad}>
                                          <span className={styles.tooltipIcon}>&#x2717;</span>
                                          <span>{s.exampleBad}</span>
                                        </div>
                                        <div className={styles.tooltipGood}>
                                          <span className={styles.tooltipIcon}>&#x2713;</span>
                                          <span>{s.exampleGood}</span>
                                        </div>
                                      </div>
                                    </li>
                                  ))}
                                </ul>
                              </div>
                            )}
                            {hasAiSuggestions && (
                              <div className={styles.suggestionsColumn}>
                                <span className={styles.suggestionsLabel}>{t('form.aiRatingSuggestions')}</span>
                                <ul className={styles.ratingSuggestions}>
                                  {effectiveAiRating!.suggestions.map((s, i) => (
                                    <li key={`ai-${i}`}>{s}</li>
                                  ))}
                                </ul>
                              </div>
                            )}
                          </div>
                        )}
                        {hasInconsistencies && (
                          <div className={styles.inconsistenciesBlock}>
                            <span className={styles.inconsistenciesLabel}>{t('form.inconsistencies')}</span>
                            <ul className={styles.inconsistenciesList}>
                              {effectiveAiRating!.inconsistencies!.map((item, i) => (
                                <li key={`inc-${i}`}>{item}</li>
                              ))}
                            </ul>
                          </div>
                        )}
                      </>
                    );
                  })()}
                </div>
              );
            })()}
            <div className={styles.generateRow}>
              <button
                className={styles.generateBtn}
                onClick={() => {
                  if (!feature.database && !confirm(t('form.generateNoDbConfirm'))) return;
                  onGenerate?.();
                }}
                disabled={generating || !feature.description.trim()}
                type="button"
              >
                {generating ? (
                  <>
                    <span className={styles.spinner} />
                    {generationStep === 'identifying-tables'
                      ? `${t('form.analyzingTables')} (${elapsed}s)`
                      : `${t('form.generatingScenarios')} (${elapsed}s)`}
                  </>
                ) : (
                  t('form.generateScenarios')
                )}
              </button>
              {onRequestRating && (
                <button
                  className={styles.ratingBtn}
                  onClick={onRequestRating}
                  disabled={ratingLoading || !feature.description.trim()}
                  type="button"
                >
                  {ratingLoading ? (
                    <>
                      <span className={styles.spinner} />
                      {t('form.requestingRating')}
                    </>
                  ) : (
                    t('form.requestRating')
                  )}
                </button>
              )}
              {generateError && (
                <span className={styles.generateError}>{generateError}</span>
              )}
              {ratingError && (
                <span className={styles.generateError}>{ratingError}</span>
              )}
            </div>
          </>
        )}
      </div>

      <div className={styles.field}>
        <label className={styles.label} htmlFor="feature-tags">
          {t('form.tags')}
          <span className={styles.helpIcon} title={t('form.tagsHelp')}>?</span>
        </label>
        <input
          id="feature-tags"
          className={styles.input}
          type="text"
          value={feature.tags.join(' ')}
          onChange={(e) => handleTagsChange(e.target.value)}
          placeholder={t('form.tagsPlaceholder')}
        />
      </div>

      <div className={styles.scenarios}>
        <h3 className={styles.sectionTitle}>
          {t('form.scenarios')}
          <span className={styles.helpIcon} title={t('form.scenariosHelp')}>?</span>
        </h3>

        {/* Scenario tab bar */}
        {feature.scenarios.length > 0 && (
          <div className={styles.scenarioTabs}>
            {feature.scenarios.map((scenario, i) => (
              <div
                key={scenario.id}
                className={i === activeScenarioIdx ? styles.scenarioTabActive : styles.scenarioTab}
                onClick={() => setActiveScenarioIdx(i)}
              >
                <span className={styles.scenarioTabLabel}>
                  {scenario.name || `${t('form.scenario')} ${i + 1}`}
                </span>
                <button
                  className={styles.scenarioTabDuplicate}
                  onClick={(e) => { e.stopPropagation(); duplicateScenario(i); }}
                  type="button"
                  title={t('form.duplicateScenario')}
                >
                  &#x2398;
                </button>
                <button
                  className={styles.scenarioTabClose}
                  onClick={(e) => { e.stopPropagation(); removeScenario(i); }}
                  type="button"
                >
                  &times;
                </button>
              </div>
            ))}
            <button
              className={styles.scenarioTabAdd}
              onClick={addScenario}
              type="button"
            >
              +
            </button>
          </div>
        )}

        {/* Active scenario content */}
        {activeScenario && (
          <ScenarioBuilder
            key={activeScenario.id}
            scenario={activeScenario}
            onChange={(updated) => updateScenario(activeScenarioIdx, updated)}
            onRemove={() => removeScenario(activeScenarioIdx)}
            tables={tables}
            createdRecords={createdRecords}
            existingSearchWords={existingSearchWords}
          />
        )}

        {/* Template buttons */}
        <div className={styles.templateRow}>
          <span className={styles.templateLabel}>{t('form.template')}</span>
          {templates.map((tmpl) => (
            <span key={tmpl.id} className={styles.templatePill}>
              <button
                className={styles.templateBtn}
                onClick={() => addFromTemplate(tmpl.id)}
                type="button"
              >
                {tmpl.label}
              </button>
              {tmpl.custom && (
                <button
                  className={styles.templateRemove}
                  onClick={() => handleRemoveTemplate(tmpl.id)}
                  type="button"
                  title={t('form.removeTemplate')}
                >
                  &times;
                </button>
              )}
            </span>
          ))}
          {activeScenario && activeScenario.steps.length > 0 && (
            <button
              className={styles.templateSaveBtn}
              onClick={handleSaveAsTemplate}
              type="button"
              title={t('form.saveAsTemplateTitle')}
            >
              {t('form.saveAsTemplate')}
            </button>
          )}
          <span className={styles.templateDivider} />
          <button
            className={styles.templateImportBtn}
            onClick={handleImportTemplates}
            type="button"
            title={t('form.importTemplatesTitle')}
          >
            {t('form.import')}
          </button>
          <button
            className={styles.templateExportBtn}
            onClick={handleExportTemplates}
            disabled={!hasCustomTemplates}
            type="button"
            title={hasCustomTemplates ? t('form.exportTemplatesTitle') : t('form.noTemplates')}
          >
            {t('form.export')}
          </button>
          <input
            ref={fileInputRef}
            type="file"
            accept=".json"
            onChange={handleImportFile}
            style={{ display: 'none' }}
          />
        </div>

        {/* Empty state */}
        {feature.scenarios.length === 0 && (
          <button className={styles.addScenario} onClick={addScenario} type="button">
            {t('form.addEmptyScenario')}
          </button>
        )}
      </div>
    </div>
  );
}
