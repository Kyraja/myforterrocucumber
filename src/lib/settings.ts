// ── Model storage ────────────────────────────────────────────

const MODEL_STORAGE = 'cucumbergnerator_model';

export function getModel(): string | null {
  return localStorage.getItem(MODEL_STORAGE);
}

export function setModel(model: string): void {
  localStorage.setItem(MODEL_STORAGE, model);
}

// ── Custom system prompt ──────────────────────────────────────

const SYSTEM_PROMPT_STORAGE = 'cucumbergnerator_system_prompt';

export function getCustomSystemPrompt(): string | null {
  return localStorage.getItem(SYSTEM_PROMPT_STORAGE);
}

export function setCustomSystemPrompt(prompt: string): void {
  localStorage.setItem(SYSTEM_PROMPT_STORAGE, prompt);
}

export function clearCustomSystemPrompt(): void {
  localStorage.removeItem(SYSTEM_PROMPT_STORAGE);
}

// ── Custom table-identification prompt ────────────────────────

const TABLE_ID_PROMPT_STORAGE = 'cucumbergnerator_tableid_prompt';

export function getCustomTableIdPrompt(): string | null {
  return localStorage.getItem(TABLE_ID_PROMPT_STORAGE);
}

export function setCustomTableIdPrompt(prompt: string): void {
  localStorage.setItem(TABLE_ID_PROMPT_STORAGE, prompt);
}

export function clearCustomTableIdPrompt(): void {
  localStorage.removeItem(TABLE_ID_PROMPT_STORAGE);
}

// ── Custom rating prompt ──────────────────────────────────────

const RATING_PROMPT_STORAGE = 'cucumbergnerator_rating_prompt';

export function getCustomRatingPrompt(): string | null {
  return localStorage.getItem(RATING_PROMPT_STORAGE);
}

export function setCustomRatingPrompt(prompt: string): void {
  localStorage.setItem(RATING_PROMPT_STORAGE, prompt);
}

export function clearCustomRatingPrompt(): void {
  localStorage.removeItem(RATING_PROMPT_STORAGE);
}

// ── Temperature ──────────────────────────────────────────────

const TEMPERATURE_STORAGE = 'cucumbergnerator_temperature';
const DEFAULT_TEMPERATURE = 0.5;

export function getTemperature(): number {
  const val = localStorage.getItem(TEMPERATURE_STORAGE);
  if (val === null) return DEFAULT_TEMPERATURE;
  const parsed = parseFloat(val);
  return isNaN(parsed) ? DEFAULT_TEMPERATURE : parsed;
}

export function setTemperature(value: number): void {
  localStorage.setItem(TEMPERATURE_STORAGE, String(value));
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

// ── OpenRouter (DEV fallback) ────────────────────────────────

const OR_KEY_STORAGE = 'cucumbergnerator_openrouter_key';
const OR_MODEL_STORAGE = 'cucumbergnerator_openrouter_model';
const OR_ENABLED_STORAGE = 'cucumbergnerator_openrouter_enabled';

export function getOpenRouterKey(): string | null {
  return localStorage.getItem(OR_KEY_STORAGE);
}

export function setOpenRouterKey(key: string): void {
  localStorage.setItem(OR_KEY_STORAGE, key);
}

export function getOpenRouterModel(): string {
  return localStorage.getItem(OR_MODEL_STORAGE) || '';
}

export function setOpenRouterModel(model: string): void {
  localStorage.setItem(OR_MODEL_STORAGE, model);
}

export function isOpenRouterEnabled(): boolean {
  return localStorage.getItem(OR_ENABLED_STORAGE) === 'true';
}

export function setOpenRouterEnabled(enabled: boolean): void {
  localStorage.setItem(OR_ENABLED_STORAGE, String(enabled));
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
  return val === 'deep' ? 'deep' : 'quick';
}

export function setTestDepth(depth: TestDepth): void {
  localStorage.setItem(TEST_DEPTH_STORAGE, depth);
}

export function getDeepTestMaxRounds(): number {
  const val = localStorage.getItem(DEEP_TEST_ROUNDS_STORAGE);
  return val ? parseInt(val, 10) || 5 : 5;
}

export function setDeepTestMaxRounds(rounds: number): void {
  localStorage.setItem(DEEP_TEST_ROUNDS_STORAGE, String(Math.max(1, Math.min(10, rounds))));
}

// ── Generation prompt overrides ──────────────────────────────

// Stored per language: key_de / key_en
function langKey(base: string, lang: 'de' | 'en'): string { return `${base}_${lang}`; }

const FIELD_RULES_STORAGE = 'cucumbergnerator_field_rules_prompt';
const QUICK_TEST_STORAGE = 'cucumbergnerator_quick_test_prompt';
const DEEP_TEST_STORAGE = 'cucumbergnerator_deep_test_prompt';

export function getCustomFieldRules(lang: 'de' | 'en'): string | null { return localStorage.getItem(langKey(FIELD_RULES_STORAGE, lang)); }
export function setCustomFieldRules(lang: 'de' | 'en', v: string): void { localStorage.setItem(langKey(FIELD_RULES_STORAGE, lang), v); }
export function clearCustomFieldRules(lang: 'de' | 'en'): void { localStorage.removeItem(langKey(FIELD_RULES_STORAGE, lang)); }

export function getCustomQuickTestPrompt(lang: 'de' | 'en'): string | null { return localStorage.getItem(langKey(QUICK_TEST_STORAGE, lang)); }
export function setCustomQuickTestPrompt(lang: 'de' | 'en', v: string): void { localStorage.setItem(langKey(QUICK_TEST_STORAGE, lang), v); }
export function clearCustomQuickTestPrompt(lang: 'de' | 'en'): void { localStorage.removeItem(langKey(QUICK_TEST_STORAGE, lang)); }

export function getCustomDeepTestPrompt(lang: 'de' | 'en'): string | null { return localStorage.getItem(langKey(DEEP_TEST_STORAGE, lang)); }
export function setCustomDeepTestPrompt(lang: 'de' | 'en', v: string): void { localStorage.setItem(langKey(DEEP_TEST_STORAGE, lang), v); }
export function clearCustomDeepTestPrompt(lang: 'de' | 'en'): void { localStorage.removeItem(langKey(DEEP_TEST_STORAGE, lang)); }

// ── Knowledge Base (PDF RAG) ─────────────────────────────────

const KB_ENABLED_STORAGE = 'cucumbergnerator_kb_enabled';
const KB_MAX_CHUNKS_STORAGE = 'cucumbergnerator_kb_max_chunks';
const KB_CHAINS_ENABLED_STORAGE = 'cucumbergnerator_kb_chains';
const KB_ACTIONS_ENABLED_STORAGE = 'cucumbergnerator_kb_actions';
const KB_EVENTS_ENABLED_STORAGE = 'cucumbergnerator_kb_events';

export function isKnowledgeBaseEnabled(): boolean {
  return localStorage.getItem(KB_ENABLED_STORAGE) === 'true';
}
export function setKnowledgeBaseEnabled(enabled: boolean): void {
  localStorage.setItem(KB_ENABLED_STORAGE, String(enabled));
}

export function getKBMaxChunks(): number {
  const val = localStorage.getItem(KB_MAX_CHUNKS_STORAGE);
  return val ? parseInt(val, 10) || 3 : 3;
}
export function setKBMaxChunks(count: number): void {
  localStorage.setItem(KB_MAX_CHUNKS_STORAGE, String(Math.max(1, Math.min(10, count))));
}

export function isKBChainsEnabled(): boolean {
  return localStorage.getItem(KB_CHAINS_ENABLED_STORAGE) !== 'false';
}
export function setKBChainsEnabled(enabled: boolean): void {
  localStorage.setItem(KB_CHAINS_ENABLED_STORAGE, String(enabled));
}

export function isKBActionsEnabled(): boolean {
  return localStorage.getItem(KB_ACTIONS_ENABLED_STORAGE) !== 'false';
}
export function setKBActionsEnabled(enabled: boolean): void {
  localStorage.setItem(KB_ACTIONS_ENABLED_STORAGE, String(enabled));
}

export function isKBEventsEnabled(): boolean {
  return localStorage.getItem(KB_EVENTS_ENABLED_STORAGE) !== 'false';
}
export function setKBEventsEnabled(enabled: boolean): void {
  localStorage.setItem(KB_EVENTS_ENABLED_STORAGE, String(enabled));
}

// ── Experimental features ──────────────────────────────────

const EXPERIMENTAL_STORAGE = 'cucumbergnerator_experimental_features';

export function getExperimentalFeatures(): boolean {
  return localStorage.getItem(EXPERIMENTAL_STORAGE) === 'true';
}

export function setExperimentalFeatures(enabled: boolean): void {
  localStorage.setItem(EXPERIMENTAL_STORAGE, String(enabled));
}

// ── FOP Agent Prompts ──────────────────────────────────────

const FOP_ANALYST_PROMPT_STORAGE = 'cucumbergnerator_fop_analyst_prompt';
const FOP_GUIDELINES_PROMPT_STORAGE = 'cucumbergnerator_fop_guidelines_prompt';

export function getCustomFopAnalystPrompt(): string | null {
  return localStorage.getItem(FOP_ANALYST_PROMPT_STORAGE);
}
export function setCustomFopAnalystPrompt(prompt: string): void {
  localStorage.setItem(FOP_ANALYST_PROMPT_STORAGE, prompt);
}
export function clearCustomFopAnalystPrompt(): void {
  localStorage.removeItem(FOP_ANALYST_PROMPT_STORAGE);
}

export function getCustomFopGuidelinesPrompt(): string | null {
  return localStorage.getItem(FOP_GUIDELINES_PROMPT_STORAGE);
}
export function setCustomFopGuidelinesPrompt(prompt: string): void {
  localStorage.setItem(FOP_GUIDELINES_PROMPT_STORAGE, prompt);
}
export function clearCustomFopGuidelinesPrompt(): void {
  localStorage.removeItem(FOP_GUIDELINES_PROMPT_STORAGE);
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
