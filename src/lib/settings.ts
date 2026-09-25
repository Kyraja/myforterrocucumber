import type { FeatureInput } from '../types/gherkin';
import defaultSettings from '../resources/settings/default-settings.json';

type UiLanguage = 'de' | 'en' | 'es' | 'fr';

// ── Model storage ────────────────────────────────────────────

const MODEL_STORAGE = 'cucumbergnerator_model';

export function getModel(): string | null {
  return localStorage.getItem(MODEL_STORAGE);
}

export function setModel(model: string): void {
  localStorage.setItem(MODEL_STORAGE, model);
}

export function clearModel(): void {
  localStorage.removeItem(MODEL_STORAGE);
}

function langKey(base: string, lang: UiLanguage): string { return `${base}_${lang}`; }

function normalizeStoredText(value: string | null): string | null {
  if (typeof value !== 'string') return null;
  const trimmed = value.trim();
  return trimmed || null;
}

function migrateLegacyPromptStorage(base: string): void {
  const legacyValue = normalizeStoredText(localStorage.getItem(base));
  if (!legacyValue) {
    localStorage.removeItem(base);
    return;
  }

  const deKey = langKey(base, 'de');
  const enKey = langKey(base, 'en');
  const esKey = langKey(base, 'es');
  const frKey = langKey(base, 'fr');
  const currentDe = normalizeStoredText(localStorage.getItem(deKey));
  const currentEn = normalizeStoredText(localStorage.getItem(enKey));
  const currentEs = normalizeStoredText(localStorage.getItem(esKey));
  const currentFr = normalizeStoredText(localStorage.getItem(frKey));

  // Legacy prompts had no language. Copy into missing language slots.
  if (!currentDe) localStorage.setItem(deKey, legacyValue);
  if (!currentEn) localStorage.setItem(enKey, legacyValue);
  if (!currentEs) localStorage.setItem(esKey, legacyValue);
  if (!currentFr) localStorage.setItem(frKey, legacyValue);
  localStorage.removeItem(base);
}

function getLocalizedPrompt(base: string, lang: UiLanguage, fallback = true): string | null {
  migrateLegacyPromptStorage(base);
  const preferred = normalizeStoredText(localStorage.getItem(langKey(base, lang)));
  if (preferred) return preferred;
  if (!fallback) return null;
  const fallbackOrder: UiLanguage[] =
    lang === 'de' ? ['en', 'fr', 'es'] :
    lang === 'en' ? ['de', 'fr', 'es'] :
    lang === 'es' ? ['en', 'de', 'fr'] :
    ['en', 'de', 'es'];
  for (const candidate of fallbackOrder) {
    const value = normalizeStoredText(localStorage.getItem(langKey(base, candidate)));
    if (value) return value;
  }
  return null;
}

function getLocalizedPromptRaw(base: string, lang: UiLanguage): string | null {
  return getLocalizedPrompt(base, lang, false);
}

function setLocalizedPrompt(base: string, lang: UiLanguage, prompt: string): void {
  migrateLegacyPromptStorage(base);
  const trimmed = prompt.trim();
  if (!trimmed) {
    localStorage.removeItem(langKey(base, lang));
    return;
  }
  localStorage.setItem(langKey(base, lang), trimmed);
}

function clearLocalizedPrompt(base: string, lang: UiLanguage): void {
  migrateLegacyPromptStorage(base);
  localStorage.removeItem(langKey(base, lang));
}

function clearLocalizedPromptAll(base: string): void {
  localStorage.removeItem(base);
  localStorage.removeItem(langKey(base, 'de'));
  localStorage.removeItem(langKey(base, 'en'));
  localStorage.removeItem(langKey(base, 'es'));
  localStorage.removeItem(langKey(base, 'fr'));
}

function getLocalizedPromptRecord(base: string): Record<UiLanguage, string | null> {
  return {
    de: getLocalizedPromptRaw(base, 'de'),
    en: getLocalizedPromptRaw(base, 'en'),
    es: getLocalizedPromptRaw(base, 'es'),
    fr: getLocalizedPromptRaw(base, 'fr'),
  };
}

// ── Custom table-identification prompt ────────────────────────

const TABLE_ID_PROMPT_STORAGE = 'cucumbergnerator_tableid_prompt';

export function getCustomTableIdPrompt(lang: UiLanguage = 'de', fallback = true): string | null {
  return getLocalizedPrompt(TABLE_ID_PROMPT_STORAGE, lang, fallback);
}

export function setCustomTableIdPrompt(lang: UiLanguage, prompt: string): void {
  setLocalizedPrompt(TABLE_ID_PROMPT_STORAGE, lang, prompt);
}

export function clearCustomTableIdPrompt(lang: UiLanguage): void {
  clearLocalizedPrompt(TABLE_ID_PROMPT_STORAGE, lang);
}

// ── Custom rating prompt ──────────────────────────────────────

const RATING_PROMPT_STORAGE = 'cucumbergnerator_rating_prompt';
const LEARNING_SUGGESTION_PROMPT_STORAGE = 'cucumbergnerator_learning_suggestion_prompt';
const FEATURE_EDIT_PROMPT_STORAGE = 'cucumbergnerator_feature_edit_prompt';

export function getCustomRatingPrompt(lang: UiLanguage = 'de', fallback = true): string | null {
  return getLocalizedPrompt(RATING_PROMPT_STORAGE, lang, fallback);
}

export function setCustomRatingPrompt(lang: UiLanguage, prompt: string): void {
  setLocalizedPrompt(RATING_PROMPT_STORAGE, lang, prompt);
}

export function clearCustomRatingPrompt(lang: UiLanguage): void {
  clearLocalizedPrompt(RATING_PROMPT_STORAGE, lang);
}

// ── Custom learning-suggestion prompt ─────────────────────────

export function getCustomLearningSuggestionPrompt(lang: UiLanguage = 'de', fallback = true): string | null {
  return getLocalizedPrompt(LEARNING_SUGGESTION_PROMPT_STORAGE, lang, fallback);
}

export function setCustomLearningSuggestionPrompt(lang: UiLanguage, prompt: string): void {
  setLocalizedPrompt(LEARNING_SUGGESTION_PROMPT_STORAGE, lang, prompt);
}

export function clearCustomLearningSuggestionPrompt(lang: UiLanguage): void {
  clearLocalizedPrompt(LEARNING_SUGGESTION_PROMPT_STORAGE, lang);
}

// ── Custom feature-edit prompt ────────────────────────────────

export function getCustomFeatureEditPrompt(lang: UiLanguage = 'de', fallback = true): string | null {
  return getLocalizedPrompt(FEATURE_EDIT_PROMPT_STORAGE, lang, fallback);
}

export function setCustomFeatureEditPrompt(lang: UiLanguage, prompt: string): void {
  setLocalizedPrompt(FEATURE_EDIT_PROMPT_STORAGE, lang, prompt);
}

export function clearCustomFeatureEditPrompt(lang: UiLanguage): void {
  clearLocalizedPrompt(FEATURE_EDIT_PROMPT_STORAGE, lang);
}

// ── Agent max tokens ─────────────────────────────────────────

const AGENT_MAX_TOKENS_STORAGE = 'cucumbergnerator_agent_max_tokens';
const MIN_AGENT_MAX_TOKENS = 256;
const MAX_AGENT_MAX_TOKENS = 200000;

// ── AI request timeout (seconds) ─────────────────────────────

const AI_TIMEOUT_SECONDS_STORAGE = 'cucumbergnerator_ai_timeout_seconds';
const MIN_AI_TIMEOUT_SECONDS = 60;
const MAX_AI_TIMEOUT_SECONDS = 1800;

export function getAiRequestTimeoutMs(): number {
  const raw = localStorage.getItem(AI_TIMEOUT_SECONDS_STORAGE);
  if (!raw) return defaultSettings.aiRequestTimeoutSeconds * 1000;
  const parsed = parseInt(raw, 10);
  if (Number.isNaN(parsed)) return defaultSettings.aiRequestTimeoutSeconds * 1000;
  const clamped = Math.max(MIN_AI_TIMEOUT_SECONDS, Math.min(MAX_AI_TIMEOUT_SECONDS, parsed));
  return clamped * 1000;
}

export function setAiRequestTimeoutSeconds(seconds: number): void {
  const clamped = Math.max(MIN_AI_TIMEOUT_SECONDS, Math.min(MAX_AI_TIMEOUT_SECONDS, Math.floor(seconds)));
  localStorage.setItem(AI_TIMEOUT_SECONDS_STORAGE, String(clamped));
}

export function getAiRequestTimeoutSeconds(): number {
  return Math.floor(getAiRequestTimeoutMs() / 1000);
}

export function getAgentMaxTokens(): number {
  const raw = localStorage.getItem(AGENT_MAX_TOKENS_STORAGE);
  if (raw === null) return defaultSettings.agentMaxTokens;
  const parsed = parseInt(raw, 10);
  if (Number.isNaN(parsed)) return defaultSettings.agentMaxTokens;
  return Math.max(MIN_AGENT_MAX_TOKENS, Math.min(MAX_AGENT_MAX_TOKENS, parsed));
}

export function setAgentMaxTokens(value: number): void {
  const clamped = Math.max(MIN_AGENT_MAX_TOKENS, Math.min(MAX_AGENT_MAX_TOKENS, Math.floor(value)));
  localStorage.setItem(AGENT_MAX_TOKENS_STORAGE, String(clamped));
}

// ── Per-task model overrides ───────────────────────────────────
// Cheap/fast classification tasks (table-identification, kb-keywords) and the
// two FOP agents can use a different model than the main Gherkin-generation
// model. This avoids paying flagship-model prices for simple lookups.

/** Tasks that support a dedicated model, independent of the main generation model. */
export type AiTaskKey = 'table-identification' | 'kb-keywords' | 'fop-analyst' | 'fop-guidelines' | 'excel-transform' | 'excel-mapping';

const TASK_MODEL_STORAGE = 'cucumbergnerator_task_model_overrides';

/** Sensible defaults based on task complexity (classification vs. deliverable reasoning). */
export const TASK_MODEL_DEFAULTS: Record<AiTaskKey, string> = {
  'table-identification': 'amazon-nova-lite',
  'kb-keywords': 'amazon-nova-lite',
  'fop-analyst': 'claude-4.8-opus',
  'fop-guidelines': 'claude-4.6-sonnet',
  'excel-transform': 'claude-4.7-opus',
  'excel-mapping': 'claude-4.8-opus',
};

function readTaskModelOverrides(): Partial<Record<AiTaskKey, string>> {
  try {
    const raw = localStorage.getItem(TASK_MODEL_STORAGE);
    return raw ? (JSON.parse(raw) as Partial<Record<AiTaskKey, string>>) : {};
  } catch {
    return {};
  }
}

/** Resolves the model to use for a task: user override → built-in default. */
export function getTaskModel(task: AiTaskKey): string {
  const overrides = readTaskModelOverrides();
  return overrides[task] ?? TASK_MODEL_DEFAULTS[task];
}

export function setTaskModel(task: AiTaskKey, model: string): void {
  const overrides = readTaskModelOverrides();
  overrides[task] = model;
  localStorage.setItem(TASK_MODEL_STORAGE, JSON.stringify(overrides));
}

// ── Agent IDs (user-provided, like AI credentials — the tool never creates ──
// agents on the API). Supports global agents shared across tenants, or
// customer-specific agents someone else created and handed the ID over for.

export type AgentIdKey = 'cucumber' | 'fop-analyst' | 'fop-guidelines' | 'excel-transform' | 'excel-mapping';

const AGENT_ID_STORAGE = 'cucumbergnerator_agent_ids';

/** Default (global) agent IDs, pre-created for this project — used unless the user overrides them. */
export const AGENT_ID_DEFAULTS: Record<AgentIdKey, string> = {
  'cucumber': 'f1186a51-9f65-44a0-91ff-123b6d0900c4',
  'excel-mapping': 'cdf5d177-99d7-4976-afea-067a57a62297',
  'excel-transform': '3c4da985-1e85-4372-9df7-0699717778f4',
  'fop-analyst': 'e0c0082b-ef6a-4ad3-8168-0bd1b50d53a2',
  'fop-guidelines': 'e5095a4e-1b74-4c0e-adef-e19aa889f52f',
};

function readAgentIds(): Partial<Record<AgentIdKey, string>> {
  try {
    const raw = localStorage.getItem(AGENT_ID_STORAGE);
    return raw ? (JSON.parse(raw) as Partial<Record<AgentIdKey, string>>) : {};
  } catch {
    return {};
  }
}

export function getStoredAgentId(key: AgentIdKey): string {
  return readAgentIds()[key] ?? AGENT_ID_DEFAULTS[key];
}

export function setStoredAgentId(key: AgentIdKey, id: string): void {
  const ids = readAgentIds();
  if (id.trim()) ids[key] = id.trim();
  else delete ids[key];
  localStorage.setItem(AGENT_ID_STORAGE, JSON.stringify(ids));
}

// ── Feature auto-save ─────────────────────────────────────────

const FEATURES_STORAGE = 'cucumbergnerator_features';

export function loadFeatures(): unknown[] | null {
  const json = localStorage.getItem(FEATURES_STORAGE);
  if (!json) return null;
  try {
    const data = JSON.parse(json);
    return Array.isArray(data) ? data : null;
  } catch {
    return null;
  }
}

export function saveFeatures(features: unknown[]): void {
  localStorage.setItem(FEATURES_STORAGE, JSON.stringify(features));
}

// ── Feature templates ────────────────────────────────────────

const FEATURE_TEMPLATES_STORAGE = 'cucumbergnerator_feature_templates';

export interface FeatureTemplate {
  name: string;
  feature: FeatureInput;
  updatedAt: string;
}

function isFeatureTemplate(value: unknown): value is FeatureTemplate {
  if (!value || typeof value !== 'object') return false;
  const candidate = value as Record<string, unknown>;
  return typeof candidate.name === 'string'
    && typeof candidate.updatedAt === 'string'
    && !!candidate.feature
    && typeof candidate.feature === 'object';
}

function cloneFeatureTemplate(feature: FeatureInput): FeatureInput {
  return JSON.parse(JSON.stringify(feature)) as FeatureInput;
}

export function loadFeatureTemplates(): FeatureTemplate[] {
  const json = localStorage.getItem(FEATURE_TEMPLATES_STORAGE);
  if (!json) return [];
  try {
    const data = JSON.parse(json);
    if (!Array.isArray(data)) return [];
    return data.filter(isFeatureTemplate).sort((a, b) => b.updatedAt.localeCompare(a.updatedAt));
  } catch {
    return [];
  }
}

export function saveFeatureTemplate(name: string, feature: FeatureInput): FeatureTemplate[] {
  const normalizedName = name.trim();
  if (!normalizedName) return loadFeatureTemplates();
  const existing = loadFeatureTemplates().filter((template) => template.name !== normalizedName);
  const next: FeatureTemplate = {
    name: normalizedName,
    feature: cloneFeatureTemplate(feature),
    updatedAt: new Date().toISOString(),
  };
  const templates = [next, ...existing].sort((a, b) => b.updatedAt.localeCompare(a.updatedAt));
  localStorage.setItem(FEATURE_TEMPLATES_STORAGE, JSON.stringify(templates));
  return templates;
}

export function deleteFeatureTemplate(name: string): FeatureTemplate[] {
  const templates = loadFeatureTemplates().filter((template) => template.name !== name);
  localStorage.setItem(FEATURE_TEMPLATES_STORAGE, JSON.stringify(templates));
  return templates;
}

export function clearFeatureTemplates(): void {
  localStorage.removeItem(FEATURE_TEMPLATES_STORAGE);
}

export function getFeatureTemplate(name: string): FeatureInput | null {
  const template = loadFeatureTemplates().find((entry) => entry.name === name);
  return template ? cloneFeatureTemplate(template.feature) : null;
}

export function exportFeatureTemplatesJson(): string {
  return JSON.stringify(loadFeatureTemplates(), null, 2);
}

export function importFeatureTemplates(json: string): FeatureTemplate[] {
  try {
    const data = JSON.parse(json);
    if (!Array.isArray(data)) return loadFeatureTemplates();
    const existing = new Map(loadFeatureTemplates().map((template) => [template.name, template]));
    for (const entry of data) {
      if (!entry || typeof entry !== 'object') continue;
      const candidate = entry as Record<string, unknown>;
      if (typeof candidate.name !== 'string' || !candidate.feature || typeof candidate.feature !== 'object') continue;
      existing.set(candidate.name.trim(), {
        name: candidate.name.trim(),
        feature: cloneFeatureTemplate(candidate.feature as FeatureInput),
        updatedAt: typeof candidate.updatedAt === 'string' ? candidate.updatedAt : new Date().toISOString(),
      });
    }
    const templates = Array.from(existing.values())
      .filter((template) => template.name)
      .sort((a, b) => b.updatedAt.localeCompare(a.updatedAt));
    localStorage.setItem(FEATURE_TEMPLATES_STORAGE, JSON.stringify(templates));
    return templates;
  } catch {
    return loadFeatureTemplates();
  }
}

interface AppSettingsPromptExport {
  tableIdPrompt: Record<UiLanguage, string | null>;
  ratingPrompt: Record<UiLanguage, string | null>;
  learningSuggestionPrompt: Record<UiLanguage, string | null>;
  featureEditPrompt: Record<UiLanguage, string | null>;
  fieldRules: Record<UiLanguage, string | null>;
  quickTest: Record<UiLanguage, string | null>;
  deepTest: Record<UiLanguage, string | null>;
  fopAnalystPrompt: Record<UiLanguage, string | null>;
  fopGuidelinesPrompt: Record<UiLanguage, string | null>;
  dialogCatalogJson: string | null;
}

export interface AppSettingsExport {
  version: 1 | 2;
  model: string | null;
  agentMaxTokens: number;
  aiRequestTimeoutSeconds: number;
  forceKiTableId: boolean;
  testDepth: TestDepth;
  deepTestMaxRounds: number;
  includeFieldChecks: boolean;
  experimentalFeatures: boolean;
  knowledgeBase: {
    enabled: boolean;
    maxChunks: number;
    chainsEnabled: boolean;
    keywordExtractionEnabled: boolean;
    keywordCount: number;
  };
  learningCrosscheckMode: LearningCrosscheckMode;
  prompts: AppSettingsPromptExport;
  featureTemplates: FeatureTemplate[];
}

export function exportAppSettingsJson(): string {
  const snapshot: AppSettingsExport = {
    version: 2,
    model: getModel(),
    agentMaxTokens: getAgentMaxTokens(),
    aiRequestTimeoutSeconds: getAiRequestTimeoutSeconds(),
    forceKiTableId: getForceKiTableId(),
    testDepth: getTestDepth(),
    deepTestMaxRounds: getDeepTestMaxRounds(),
    includeFieldChecks: getIncludeFieldCheckScenarios(),
    experimentalFeatures: getExperimentalFeatures(),
    knowledgeBase: {
      enabled: isKnowledgeBaseEnabled(),
      maxChunks: getKBMaxChunks(),
      chainsEnabled: isKBChainsEnabled(),
      keywordExtractionEnabled: isKBKeywordExtractionEnabled(),
      keywordCount: getKBKeywordCount(),
    },
    learningCrosscheckMode: getLearningCrosscheckMode(),
    prompts: {
      tableIdPrompt: getLocalizedPromptRecord(TABLE_ID_PROMPT_STORAGE),
      ratingPrompt: getLocalizedPromptRecord(RATING_PROMPT_STORAGE),
      learningSuggestionPrompt: getLocalizedPromptRecord(LEARNING_SUGGESTION_PROMPT_STORAGE),
      featureEditPrompt: getLocalizedPromptRecord(FEATURE_EDIT_PROMPT_STORAGE),
      fieldRules: {
        de: getCustomFieldRules('de'),
        en: getCustomFieldRules('en'),
        es: getCustomFieldRules('es'),
        fr: getCustomFieldRules('fr'),
      },
      quickTest: {
        de: getCustomQuickTestPrompt('de'),
        en: getCustomQuickTestPrompt('en'),
        es: getCustomQuickTestPrompt('es'),
        fr: getCustomQuickTestPrompt('fr'),
      },
      deepTest: {
        de: getCustomDeepTestPrompt('de'),
        en: getCustomDeepTestPrompt('en'),
        es: getCustomDeepTestPrompt('es'),
        fr: getCustomDeepTestPrompt('fr'),
      },
      fopAnalystPrompt: getLocalizedPromptRecord(FOP_ANALYST_PROMPT_STORAGE),
      fopGuidelinesPrompt: getLocalizedPromptRecord(FOP_GUIDELINES_PROMPT_STORAGE),
      dialogCatalogJson: getUserDialogCatalogJson() || null,
    },
    featureTemplates: loadFeatureTemplates(),
  };
  return JSON.stringify(snapshot, null, 2);
}

function applyOptionalString(value: unknown, setter: (value: string) => void, clearer: () => void): void {
  if (typeof value === 'string') {
    const trimmed = value.trim();
    if (trimmed) {
      setter(trimmed);
      return;
    }
  }
  clearer();
}

function applyOptionalBoolean(value: unknown, setter: (value: boolean) => void): void {
  if (typeof value === 'boolean') setter(value);
}

function applyOptionalNumber(value: unknown, setter: (value: number) => void): void {
  if (typeof value === 'number' && Number.isFinite(value)) setter(value);
}

function applyOptionalLocalizedPrompt(
  value: unknown,
  setter: (lang: UiLanguage, value: string) => void,
  clearer: (lang: UiLanguage) => void,
  clearAll: () => void,
): void {
  if (typeof value === 'string') {
    const trimmed = value.trim();
    if (trimmed) {
      setter('de', trimmed);
      setter('en', trimmed);
      setter('es', trimmed);
      setter('fr', trimmed);
    } else {
      clearAll();
    }
    return;
  }

  if (!value || typeof value !== 'object') {
    if (value === null) clearAll();
    return;
  }

  const localized = value as Partial<Record<UiLanguage, unknown>>;
  if ('de' in localized) {
    applyOptionalString(localized.de, (next) => setter('de', next), () => clearer('de'));
  }
  if ('en' in localized) {
    applyOptionalString(localized.en, (next) => setter('en', next), () => clearer('en'));
  }
  if ('es' in localized) {
    applyOptionalString(localized.es, (next) => setter('es', next), () => clearer('es'));
  }
  if ('fr' in localized) {
    applyOptionalString(localized.fr, (next) => setter('fr', next), () => clearer('fr'));
  }
}

export function importAppSettingsJson(json: string): AppSettingsExport {
  const parsed = JSON.parse(json) as Partial<AppSettingsExport> | null;
  if (!parsed || typeof parsed !== 'object' || (parsed.version !== 1 && parsed.version !== 2)) {
    throw new Error('Unsupported settings JSON');
  }

  if ('model' in parsed) {
    if (typeof parsed.model === 'string' && parsed.model.trim()) setModel(parsed.model.trim());
    else clearModel();
  }

  applyOptionalNumber(parsed.agentMaxTokens, setAgentMaxTokens);
  applyOptionalNumber(parsed.aiRequestTimeoutSeconds, setAiRequestTimeoutSeconds);
  applyOptionalBoolean(parsed.forceKiTableId, setForceKiTableId);
  if (parsed.testDepth === 'quick' || parsed.testDepth === 'deep') setTestDepth(parsed.testDepth);
  applyOptionalNumber(parsed.deepTestMaxRounds, setDeepTestMaxRounds);
  applyOptionalBoolean(parsed.includeFieldChecks, setIncludeFieldCheckScenarios);
  applyOptionalBoolean(parsed.experimentalFeatures, setExperimentalFeatures);

  if (parsed.knowledgeBase && typeof parsed.knowledgeBase === 'object') {
    const kb = parsed.knowledgeBase as AppSettingsExport['knowledgeBase'];
    applyOptionalBoolean(kb.enabled, setKnowledgeBaseEnabled);
    applyOptionalNumber(kb.maxChunks, setKBMaxChunks);
    applyOptionalBoolean(kb.chainsEnabled, setKBChainsEnabled);
    applyOptionalBoolean(kb.keywordExtractionEnabled, setKBKeywordExtractionEnabled);
    applyOptionalNumber(kb.keywordCount, setKBKeywordCount);
  }

  if (parsed.learningCrosscheckMode === 'customer-only' || parsed.learningCrosscheckMode === 'customer-plus-general') {
    setLearningCrosscheckMode(parsed.learningCrosscheckMode);
  }

  if (parsed.prompts && typeof parsed.prompts === 'object') {
    const prompts = parsed.prompts as Partial<AppSettingsPromptExport> & Record<string, unknown>;

    applyOptionalLocalizedPrompt(
      prompts.tableIdPrompt,
      setCustomTableIdPrompt,
      clearCustomTableIdPrompt,
      () => clearLocalizedPromptAll(TABLE_ID_PROMPT_STORAGE),
    );
    applyOptionalLocalizedPrompt(
      prompts.ratingPrompt,
      setCustomRatingPrompt,
      clearCustomRatingPrompt,
      () => clearLocalizedPromptAll(RATING_PROMPT_STORAGE),
    );
    applyOptionalLocalizedPrompt(
      prompts.learningSuggestionPrompt,
      setCustomLearningSuggestionPrompt,
      clearCustomLearningSuggestionPrompt,
      () => clearLocalizedPromptAll(LEARNING_SUGGESTION_PROMPT_STORAGE),
    );
    applyOptionalLocalizedPrompt(
      prompts.featureEditPrompt,
      setCustomFeatureEditPrompt,
      clearCustomFeatureEditPrompt,
      () => clearLocalizedPromptAll(FEATURE_EDIT_PROMPT_STORAGE),
    );

    if (prompts.fieldRules && typeof prompts.fieldRules === 'object') {
      applyOptionalString(prompts.fieldRules.de, (value) => setCustomFieldRules('de', value), () => clearCustomFieldRules('de'));
      applyOptionalString(prompts.fieldRules.en, (value) => setCustomFieldRules('en', value), () => clearCustomFieldRules('en'));
      applyOptionalString(prompts.fieldRules.es, (value) => setCustomFieldRules('es', value), () => clearCustomFieldRules('es'));
      applyOptionalString(prompts.fieldRules.fr, (value) => setCustomFieldRules('fr', value), () => clearCustomFieldRules('fr'));
    }
    if (prompts.quickTest && typeof prompts.quickTest === 'object') {
      applyOptionalString(prompts.quickTest.de, (value) => setCustomQuickTestPrompt('de', value), () => clearCustomQuickTestPrompt('de'));
      applyOptionalString(prompts.quickTest.en, (value) => setCustomQuickTestPrompt('en', value), () => clearCustomQuickTestPrompt('en'));
      applyOptionalString(prompts.quickTest.es, (value) => setCustomQuickTestPrompt('es', value), () => clearCustomQuickTestPrompt('es'));
      applyOptionalString(prompts.quickTest.fr, (value) => setCustomQuickTestPrompt('fr', value), () => clearCustomQuickTestPrompt('fr'));
    }
    if (prompts.deepTest && typeof prompts.deepTest === 'object') {
      applyOptionalString(prompts.deepTest.de, (value) => setCustomDeepTestPrompt('de', value), () => clearCustomDeepTestPrompt('de'));
      applyOptionalString(prompts.deepTest.en, (value) => setCustomDeepTestPrompt('en', value), () => clearCustomDeepTestPrompt('en'));
      applyOptionalString(prompts.deepTest.es, (value) => setCustomDeepTestPrompt('es', value), () => clearCustomDeepTestPrompt('es'));
      applyOptionalString(prompts.deepTest.fr, (value) => setCustomDeepTestPrompt('fr', value), () => clearCustomDeepTestPrompt('fr'));
    }

    applyOptionalLocalizedPrompt(
      prompts.fopAnalystPrompt,
      setCustomFopAnalystPrompt,
      clearCustomFopAnalystPrompt,
      () => clearLocalizedPromptAll(FOP_ANALYST_PROMPT_STORAGE),
    );
    applyOptionalLocalizedPrompt(
      prompts.fopGuidelinesPrompt,
      setCustomFopGuidelinesPrompt,
      clearCustomFopGuidelinesPrompt,
      () => clearLocalizedPromptAll(FOP_GUIDELINES_PROMPT_STORAGE),
    );

    if ('dialogCatalogJson' in prompts) {
      const dialogJson = prompts.dialogCatalogJson;
      if (typeof dialogJson === 'string' && dialogJson.trim()) {
        setUserDialogCatalogJson(dialogJson.trim());
      } else {
        clearUserDialogCatalog();
      }
    }
  }

  if (Array.isArray(parsed.featureTemplates)) {
    clearFeatureTemplates();
    importFeatureTemplates(JSON.stringify(parsed.featureTemplates));
  }

  return parsed as AppSettingsExport;
}

// ── Force KI table identification (skip local V/P-notation detection) ──

const FORCE_KI_TABLE_ID_STORAGE = 'cucumbergnerator_force_ki_table_id';

export function getForceKiTableId(): boolean {
  return localStorage.getItem(FORCE_KI_TABLE_ID_STORAGE) === 'true';
}

export function setForceKiTableId(enabled: boolean): void {
  localStorage.setItem(FORCE_KI_TABLE_ID_STORAGE, String(enabled));
}

// ── Test depth (global setting for all test generation) ──────

const TEST_DEPTH_STORAGE = 'cucumbergnerator_test_depth';
const DEEP_TEST_ROUNDS_STORAGE = 'cucumbergnerator_deep_test_max_rounds';

export type TestDepth = 'quick' | 'deep';

export function getTestDepth(): TestDepth {
  const val = localStorage.getItem(TEST_DEPTH_STORAGE);
  if (val === 'deep' || val === 'quick') return val;
  return defaultSettings.testDepth as TestDepth;
}

export function setTestDepth(depth: TestDepth): void {
  localStorage.setItem(TEST_DEPTH_STORAGE, depth);
}

export function getDeepTestMaxRounds(): number {
  const val = localStorage.getItem(DEEP_TEST_ROUNDS_STORAGE);
  return val ? parseInt(val, 10) || defaultSettings.deepTestMaxRounds : defaultSettings.deepTestMaxRounds;
}

export function setDeepTestMaxRounds(rounds: number): void {
  localStorage.setItem(DEEP_TEST_ROUNDS_STORAGE, String(Math.max(1, Math.min(10, rounds))));
}

// ── Include field-check scenarios in generated tests ──────────
//
// When ON (default): the AI is allowed to produce "Feldpruefung X"-style
// scenarios that only verify `Then field "x" is modifiable`. When OFF: the AI
// is instructed to skip those and write only functional end-to-end steps.
// Useful when the test basis already guarantees field existence and the user
// wants a leaner feature file.

const INCLUDE_FIELD_CHECKS_STORAGE = 'cucumbergnerator_include_field_checks';

export function getIncludeFieldCheckScenarios(): boolean {
  const val = localStorage.getItem(INCLUDE_FIELD_CHECKS_STORAGE);
  return val === null ? defaultSettings.includeFieldChecks : val === 'true';
}

export function setIncludeFieldCheckScenarios(enabled: boolean): void {
  localStorage.setItem(INCLUDE_FIELD_CHECKS_STORAGE, String(enabled));
}

// ── Generation prompt overrides ──────────────────────────────

const FIELD_RULES_STORAGE = 'cucumbergnerator_field_rules_prompt';
const QUICK_TEST_STORAGE = 'cucumbergnerator_quick_test_prompt';
const DEEP_TEST_STORAGE = 'cucumbergnerator_deep_test_prompt';

export function getCustomFieldRules(lang: UiLanguage): string | null { return localStorage.getItem(langKey(FIELD_RULES_STORAGE, lang)); }
export function setCustomFieldRules(lang: UiLanguage, v: string): void { localStorage.setItem(langKey(FIELD_RULES_STORAGE, lang), v); }
export function clearCustomFieldRules(lang: UiLanguage): void { localStorage.removeItem(langKey(FIELD_RULES_STORAGE, lang)); }

export function getCustomQuickTestPrompt(lang: UiLanguage): string | null { return localStorage.getItem(langKey(QUICK_TEST_STORAGE, lang)); }
export function setCustomQuickTestPrompt(lang: UiLanguage, v: string): void { localStorage.setItem(langKey(QUICK_TEST_STORAGE, lang), v); }
export function clearCustomQuickTestPrompt(lang: UiLanguage): void { localStorage.removeItem(langKey(QUICK_TEST_STORAGE, lang)); }

export function getCustomDeepTestPrompt(lang: UiLanguage): string | null { return localStorage.getItem(langKey(DEEP_TEST_STORAGE, lang)); }
export function setCustomDeepTestPrompt(lang: UiLanguage, v: string): void { localStorage.setItem(langKey(DEEP_TEST_STORAGE, lang), v); }
export function clearCustomDeepTestPrompt(lang: UiLanguage): void { localStorage.removeItem(langKey(DEEP_TEST_STORAGE, lang)); }

// ── Knowledge Base (HTML RAG) ────────────────────────────────

const KB_ENABLED_STORAGE = 'cucumbergnerator_kb_enabled';
const KB_MAX_CHUNKS_STORAGE = 'cucumbergnerator_kb_max_chunks';
const KB_CHAINS_ENABLED_STORAGE = 'cucumbergnerator_kb_chains';

export function isKnowledgeBaseEnabled(): boolean {
  if (!isAiEnabled()) return false;
  const val = localStorage.getItem(KB_ENABLED_STORAGE);
  return val === null ? defaultSettings.knowledgeBase.enabled : val === 'true';
}
export function setKnowledgeBaseEnabled(enabled: boolean): void {
  localStorage.setItem(KB_ENABLED_STORAGE, String(enabled));
}

export function getKBMaxChunks(): number {
  const val = localStorage.getItem(KB_MAX_CHUNKS_STORAGE);
  return val ? parseInt(val, 10) || defaultSettings.knowledgeBase.maxChunks : defaultSettings.knowledgeBase.maxChunks;
}
export function setKBMaxChunks(count: number): void {
  localStorage.setItem(KB_MAX_CHUNKS_STORAGE, String(Math.max(1, Math.min(10, count))));
}

export function isKBChainsEnabled(): boolean {
  const val = localStorage.getItem(KB_CHAINS_ENABLED_STORAGE);
  return val === null ? defaultSettings.knowledgeBase.chainsEnabled : val !== 'false';
}
export function setKBChainsEnabled(enabled: boolean): void {
  localStorage.setItem(KB_CHAINS_ENABLED_STORAGE, String(enabled));
}

const KB_KEYWORD_EXTRACTION_STORAGE = 'cucumbergnerator_kb_keyword_extraction';
const KB_KEYWORD_COUNT_STORAGE = 'cucumbergnerator_kb_keyword_count';

export function isKBKeywordExtractionEnabled(): boolean {
  const val = localStorage.getItem(KB_KEYWORD_EXTRACTION_STORAGE);
  return val === null ? defaultSettings.knowledgeBase.keywordExtractionEnabled : val === 'true';
}
export function setKBKeywordExtractionEnabled(enabled: boolean): void {
  localStorage.setItem(KB_KEYWORD_EXTRACTION_STORAGE, String(enabled));
}

export function getKBKeywordCount(): number {
  const val = localStorage.getItem(KB_KEYWORD_COUNT_STORAGE);
  return val ? parseInt(val, 10) || defaultSettings.knowledgeBase.keywordCount : defaultSettings.knowledgeBase.keywordCount;
}
export function setKBKeywordCount(count: number): void {
  localStorage.setItem(KB_KEYWORD_COUNT_STORAGE, String(Math.max(1, Math.min(15, count))));
}

// ── Experimental features ──────────────────────────────────

const EXPERIMENTAL_STORAGE = 'cucumbergnerator_experimental_features';

export function getExperimentalFeatures(): boolean {
  if (!isDevMode()) return false;
  return localStorage.getItem(EXPERIMENTAL_STORAGE) === 'true';
}

export function setExperimentalFeatures(enabled: boolean): void {
  localStorage.setItem(EXPERIMENTAL_STORAGE, String(enabled));
}

// ── Dev mode (URL gate for experimental UI) ─────
//
// Activated by appending `?dev=true` to the URL. Sticky for the tab session
// via sessionStorage, so navigation/OAuth redirects don't drop the flag.
// When OFF, the experimental-features toggle is hidden from the UI entirely.

const DEV_MODE_SESSION_KEY = 'cucumbergnerator_dev_mode';

let devModeCache: boolean | null = null;

export function isDevMode(): boolean {
  if (devModeCache !== null) return devModeCache;
  if (typeof window === 'undefined') return false;
  try {
    const params = new URLSearchParams(window.location.search);
    if (params.get('dev') === 'true') {
      sessionStorage.setItem(DEV_MODE_SESSION_KEY, 'true');
      devModeCache = true;
      return true;
    }
    devModeCache = sessionStorage.getItem(DEV_MODE_SESSION_KEY) === 'true';
    return devModeCache;
  } catch {
    return false;
  }
}

// ── AI mode (URL gate to hide all KI functionality) ────────────────
//
// Activated by appending `?ai=true` to the URL. Sticky for the tab session
// via sessionStorage so internal navigation does not drop the flag.
// When OFF (default), the app starts directly as a pure building-block
// (Baukasten) tool: no login screen, no settings panel, no agent UI, no
// token history, no rating, no DOCX-AI options, no FOP reverse engineering.
// All `loggedIn`-gated UI naturally disappears because we force loggedIn=false.
// Toggle via `?ai=true` (enable) or `?ai=false` (disable, clears the flag).

const AI_MODE_SESSION_KEY = 'cucumbergnerator_ai_enabled';

let aiEnabledCache: boolean | null = null;

export function isAiEnabled(): boolean {
  if (aiEnabledCache !== null) return aiEnabledCache;
  if (typeof window === 'undefined') return false;
  try {
    const params = new URLSearchParams(window.location.search);
    const param = params.get('ai');
    if (param === 'true') {
      sessionStorage.setItem(AI_MODE_SESSION_KEY, 'true');
      aiEnabledCache = true;
      return true;
    }
    if (param === 'false') {
      sessionStorage.removeItem(AI_MODE_SESSION_KEY);
      aiEnabledCache = false;
      return false;
    }
    aiEnabledCache = sessionStorage.getItem(AI_MODE_SESSION_KEY) === 'true';
    return aiEnabledCache;
  } catch {
    return false;
  }
}

// ── FOP Agent Prompts ──────────────────────────────────────

const FOP_ANALYST_PROMPT_STORAGE = 'cucumbergnerator_fop_analyst_prompt';
const FOP_GUIDELINES_PROMPT_STORAGE = 'cucumbergnerator_fop_guidelines_prompt';

export function getCustomFopAnalystPrompt(lang: UiLanguage = 'de', fallback = true): string | null {
  return getLocalizedPrompt(FOP_ANALYST_PROMPT_STORAGE, lang, fallback);
}
export function setCustomFopAnalystPrompt(lang: UiLanguage, prompt: string): void {
  setLocalizedPrompt(FOP_ANALYST_PROMPT_STORAGE, lang, prompt);
}
export function clearCustomFopAnalystPrompt(lang: UiLanguage): void {
  clearLocalizedPrompt(FOP_ANALYST_PROMPT_STORAGE, lang);
}

export function getCustomFopGuidelinesPrompt(lang: UiLanguage = 'de', fallback = true): string | null {
  return getLocalizedPrompt(FOP_GUIDELINES_PROMPT_STORAGE, lang, fallback);
}
export function setCustomFopGuidelinesPrompt(lang: UiLanguage, prompt: string): void {
  setLocalizedPrompt(FOP_GUIDELINES_PROMPT_STORAGE, lang, prompt);
}
export function clearCustomFopGuidelinesPrompt(lang: UiLanguage): void {
  clearLocalizedPrompt(FOP_GUIDELINES_PROMPT_STORAGE, lang);
}

// ── FOP Bindings (FOP.txt) ─────────────────────────────────
// Persisted in localStorage so they survive page reload

const FOP_BINDINGS_STORAGE = 'cucumbergnerator_fop_bindings';
const IS_BINDINGS_STORAGE = 'cucumbergnerator_is_bindings';

export function saveFopBindings(bindings: unknown[]): void {
  try {
    localStorage.setItem(FOP_BINDINGS_STORAGE, JSON.stringify(bindings));
  } catch {
    // Storage full or unavailable — ignore silently
  }
}

export function loadFopBindings(): unknown[] {
  try {
    const raw = localStorage.getItem(FOP_BINDINGS_STORAGE);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}

export function clearFopBindings(): void {
  localStorage.removeItem(FOP_BINDINGS_STORAGE);
}

export function saveIsBindings(bindings: unknown[]): void {
  try {
    localStorage.setItem(IS_BINDINGS_STORAGE, JSON.stringify(bindings));
  } catch {
    // Storage full — ignore
  }
}

export function loadIsBindings(): unknown[] {
  try {
    const raw = localStorage.getItem(IS_BINDINGS_STORAGE);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}

export function clearIsBindings(): void {
  localStorage.removeItem(IS_BINDINGS_STORAGE);
}

// ── Dialog catalog (standard abas message IDs) ──────────────
import { DEFAULT_STANDARD_DIALOG_CATALOG, type DialogEntry } from './abasDialogCatalog';

const DIALOG_CATALOG_STORAGE = 'cucumbergnerator_dialog_catalog';

/**
 * Effective dialog catalog = defaults merged with the user's overlay from localStorage.
 * User entries take precedence over defaults with the same ID, so users can both add
 * new IDs and override existing ones (e.g., change the standard answer for their project).
 */
export function getEffectiveDialogCatalog(): Record<string, DialogEntry> {
  try {
    const raw = localStorage.getItem(DIALOG_CATALOG_STORAGE);
    if (!raw) return DEFAULT_STANDARD_DIALOG_CATALOG;
    const userOverlay = JSON.parse(raw);
    if (!userOverlay || typeof userOverlay !== 'object' || Array.isArray(userOverlay)) {
      return DEFAULT_STANDARD_DIALOG_CATALOG;
    }
    return { ...DEFAULT_STANDARD_DIALOG_CATALOG, ...(userOverlay as Record<string, DialogEntry>) };
  } catch {
    return DEFAULT_STANDARD_DIALOG_CATALOG;
  }
}

/** Returns only the user-managed overlay portion (for editing in the UI). */
export function getUserDialogCatalogJson(): string {
  const raw = localStorage.getItem(DIALOG_CATALOG_STORAGE);
  return raw ?? '';
}

/** Persists the user overlay. Empty/whitespace input clears the overlay. */
export function setUserDialogCatalogJson(json: string): void {
  const trimmed = json.trim();
  if (!trimmed) {
    localStorage.removeItem(DIALOG_CATALOG_STORAGE);
    return;
  }
  // Validate JSON before saving so bad input doesn't silently persist.
  JSON.parse(trimmed);
  localStorage.setItem(DIALOG_CATALOG_STORAGE, trimmed);
}

export function clearUserDialogCatalog(): void {
  localStorage.removeItem(DIALOG_CATALOG_STORAGE);
}

// ── FOP Auto-Refresh (folder polling) ───────────────────────

const FOP_AUTO_REFRESH_ENABLED_STORAGE = 'cucumbergnerator_fop_auto_refresh_enabled';
const FOP_AUTO_REFRESH_INTERVAL_STORAGE = 'cucumbergnerator_fop_auto_refresh_interval_seconds';

export function isFopAutoRefreshEnabled(): boolean {
  const val = localStorage.getItem(FOP_AUTO_REFRESH_ENABLED_STORAGE);
  return val === null ? true : val === 'true';
}

export function setFopAutoRefreshEnabled(enabled: boolean): void {
  localStorage.setItem(FOP_AUTO_REFRESH_ENABLED_STORAGE, String(enabled));
}

export function getFopAutoRefreshIntervalSeconds(): number {
  const raw = localStorage.getItem(FOP_AUTO_REFRESH_INTERVAL_STORAGE);
  const parsed = raw ? parseInt(raw, 10) : 20;
  if (Number.isNaN(parsed)) return 20;
  return Math.max(5, Math.min(120, parsed));
}

export function setFopAutoRefreshIntervalSeconds(seconds: number): void {
  const clamped = Math.max(5, Math.min(120, Math.floor(seconds)));
  localStorage.setItem(FOP_AUTO_REFRESH_INTERVAL_STORAGE, String(clamped));
}

// ── Learning Crosscheck Mode ────────────────────────────────

export type LearningCrosscheckMode = 'customer-only' | 'customer-plus-general';

const LEARNING_CROSSCHECK_MODE_STORAGE = 'cucumbergnerator_learning_crosscheck_mode';

export function getLearningCrosscheckMode(): LearningCrosscheckMode {
  const raw = localStorage.getItem(LEARNING_CROSSCHECK_MODE_STORAGE);
  if (raw === 'customer-only' || raw === 'customer-plus-general') return raw;
  return defaultSettings.learningCrosscheckMode as LearningCrosscheckMode;
}

export function setLearningCrosscheckMode(mode: LearningCrosscheckMode): void {
  localStorage.setItem(LEARNING_CROSSCHECK_MODE_STORAGE, mode);
}
