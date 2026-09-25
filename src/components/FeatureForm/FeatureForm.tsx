/**
 * @module FeatureForm
 * The main editing form for a single Gherkin feature file.
 *
 * Responsibilities:
 * - Feature name, test user, description / requirements text, and tags.
 * - Scenario tab bar with add, duplicate, and remove.
 * - Inline prompt quality rating (local static + optional AI-powered).
 * - GUID management: auto-generates a 16-hex-char GUID tag when the feature
 *   name is first set, and propagates GUID changes into step text / data tables
 *   when the feature is renamed.
 * - AI generation trigger button with elapsed-time counter.
 */

import { useMemo, useState, useEffect, useRef } from 'react';
import type { FeatureInput, Scenario, TableDef } from '../../types/gherkin';
import type { GenerationStep } from '../../hooks/useAiGeneration';
import { useTranslation } from '../../i18n';
import { ratePrompt, ratingColor } from '../../lib/promptRating';
import type { AiPromptRating } from '../../lib/aiPrompt';
import { extractCreatedRecords, collectExistingSearchWords } from '../../lib/recordTracker';
import { ScenarioBuilder } from '../ScenarioBuilder/ScenarioBuilder';
import { scenarioHasErrors } from '../../lib/featureValidation';
import { makeFeatureGuid, findGuidInTags, replaceFeatureGuid } from '../../lib/featureGuid';
import styles from './FeatureForm.module.css';

/**
 * Returns the number of whole seconds elapsed since `running` became true.
 * Resets to 0 whenever `running` is false. Used to display a live elapsed-time
 * counter next to the "Generating…" spinner.
 */
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

/** Props for {@link FeatureForm}. */
interface FeatureFormProps {
  /** The feature currently being edited. */
  feature: FeatureInput;
  /** Called with the updated feature on every change. */
  onChange: (updated: FeatureInput) => void;
  /** When true, shows the requirements textarea and AI generation controls. */
  showGenerate?: boolean;
  /** Trigger AI generation; guarded internally against missing table confirmation. */
  onGenerate?: () => void;
  /** True while an AI generation call is in progress. */
  generating?: boolean;
  /** Current generation phase (used to differentiate "Analysing tables" vs "Generating"). */
  generationStep?: GenerationStep;
  /** Error message from the last failed generation attempt. */
  generateError?: string | null;
  /** Available database/infosystem tables for context-aware field suggestions and AI generation. */
  tables?: TableDef[];
  /** AI quality rating returned as a side-effect of the generation call. */
  aiRating?: AiPromptRating | null;
  /** AI quality rating from a standalone "Rate prompt" button press. */
  standaloneAiRating?: AiPromptRating | null;
  /** Called when the user requests a standalone AI rating. */
  onRequestRating?: () => void;
  /** True while a standalone rating request is in flight. */
  ratingLoading?: boolean;
  /** Error message from the last failed rating request. */
  ratingError?: string | null;
  /** Called when the user wants to transform the current feature via AI. */
  onApplyAiEdit?: (request: string) => Promise<void>;
  /** True while AI applies a requested change to the current feature. */
  aiEditLoading?: boolean;
  /** Error message from the last failed AI edit request. */
  aiEditError?: string | null;
  /**
   * When set, the form jumps to the matching scenario tab.
   * Format: `"<scenarioId>::<timestamp>"` — the timestamp suffix forces
   * React to re-trigger the effect even when the same scenario is clicked twice.
   */
  focusScenarioId?: string | null;
}

/**
 * Main feature editing form.
 *
 * The active scenario index is clamped on every render cycle so it stays valid
 * when the AI replaces all scenarios at once. `createdRecords` and
 * `existingSearchWords` are memoized across the full scenario list and passed
 * down to {@link ScenarioBuilder} so search-word generation is globally aware.
 */
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
  onApplyAiEdit,
  aiEditLoading = false,
  aiEditError = null,
  focusScenarioId = null,
}: FeatureFormProps) {
  const { t, lang } = useTranslation();
  const elapsed = useElapsed(generating);
  const [activeScenarioIdx, setActiveScenarioIdx] = useState(0);
  const [aiEditRequest, setAiEditRequest] = useState('');
  // Clamp active index when scenarios change (e.g. AI replaces all scenarios)
  useEffect(() => {
    if (feature.scenarios.length === 0) {
      setActiveScenarioIdx(0);
    } else if (activeScenarioIdx >= feature.scenarios.length) {
      setActiveScenarioIdx(feature.scenarios.length - 1);
    }
  }, [feature.scenarios.length, activeScenarioIdx]);

  // Jump to scenario tab when focusScenarioId changes (e.g. from explorer click)
  // Format: "scenarioId::timestamp" — double-colon separator, timestamp ensures re-trigger
  useEffect(() => {
    if (!focusScenarioId) return;
    const id = focusScenarioId.split('::')[0];
    const idx = feature.scenarios.findIndex((s) => s.id === id);
    console.log('[FeatureForm] focusScenario:', id, 'found at index:', idx, 'activeScenarioIdx before:', activeScenarioIdx, 'scenarios:', feature.scenarios.map((s) => `${s.id}=${s.name}`));
    if (idx >= 0) {
      setActiveScenarioIdx(idx);
      // Scroll the tab into view after React re-renders
      setTimeout(() => {
        const tab = document.querySelector(`[data-scenario-idx="${idx}"]`);
        tab?.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'nearest' });
      }, 50);
    }
  }, [focusScenarioId, feature.scenarios]);

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
            onChange={(e) => {
              const newName = e.target.value;
              const oldGuid = findGuidInTags(feature.tags);
              const newGuid = makeFeatureGuid('', newName);
              if (oldGuid && oldGuid !== newGuid) {
                // Replace old GUID everywhere (tags, steps, data tables)
                onChange(replaceFeatureGuid({ ...feature, name: newName }, oldGuid, newGuid));
              } else if (!oldGuid && newName.trim()) {
                // No GUID tag yet — add one
                onChange({ ...feature, name: newName, tags: [`@guid-${newGuid}`, ...feature.tags] });
              } else {
                onChange({ ...feature, name: newName });
              }
            }}
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
                  if (tables.length === 0 && !confirm(t('form.generateNoDbConfirm'))) return;
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
            {onApplyAiEdit && (
              <div className={styles.aiEditBox}>
                <label className={styles.aiEditLabel} htmlFor="feature-ai-edit-request">
                  {t('form.aiEditLabel')}
                </label>
                <textarea
                  id="feature-ai-edit-request"
                  className={styles.aiEditTextarea}
                  value={aiEditRequest}
                  onChange={(e) => setAiEditRequest(e.target.value)}
                  placeholder={t('form.aiEditPlaceholder')}
                  rows={3}
                />
                <div className={styles.aiEditActions}>
                  <button
                    className={styles.aiEditBtn}
                    onClick={async () => {
                      const request = aiEditRequest.trim();
                      if (!request) return;
                      await onApplyAiEdit(request);
                      setAiEditRequest('');
                    }}
                    disabled={aiEditLoading || !aiEditRequest.trim() || generating}
                    type="button"
                  >
                    {aiEditLoading ? (
                      <>
                        <span className={styles.spinner} />
                        {t('form.aiEditApplying')}
                      </>
                    ) : (
                      t('form.aiEditApply')
                    )}
                  </button>
                  <span className={styles.aiEditHint}>{t('form.aiEditHint')}</span>
                </div>
                {aiEditError && (
                  <span className={styles.generateError}>{aiEditError}</span>
                )}
              </div>
            )}
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
            {feature.scenarios.map((scenario, i) => {
              const hasErrors = scenarioHasErrors(scenario);
              const tabClass = i === activeScenarioIdx
                ? (hasErrors ? `${styles.scenarioTabActive} ${styles.scenarioTabError}` : styles.scenarioTabActive)
                : (hasErrors ? `${styles.scenarioTab} ${styles.scenarioTabError}` : styles.scenarioTab);
              return (
              <div
                key={scenario.id}
                className={tabClass}
                data-scenario-idx={i}
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
              );
            })}
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

        {/* Template buttons removed — use StepToolbox (right panel) instead */}

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
