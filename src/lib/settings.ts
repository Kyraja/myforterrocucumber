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
