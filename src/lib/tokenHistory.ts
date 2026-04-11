/**
 * @module tokenHistory
 *
 * Token usage tracking and daily limit management for AI API calls.
 *
 * Every AI completion (Gherkin generation, table identification, agent chat,
 * etc.) records its token counts here. Entries are stored in localStorage
 * keyed by today's date; entries from previous days are pruned automatically
 * to keep storage lean.
 *
 * The daily limit ({@link DAILY_LIMIT}) is enforced by the UI; when reached,
 * a `"token-limit-reached"` CustomEvent is dispatched on `window` so any
 * listening component can block further AI calls.
 *
 * All write operations are synchronous localStorage calls — suitable for
 * the single-tab, no-backend architecture of this app.
 */

// ── Token Usage History (localStorage, daily) ─────────────────

/** Describes what the tokens were used for, so the user can see at a glance. */
export type TokenPurpose =
  | 'table-identification'
  | 'gherkin-generation'
  | 'rating'
  | 'agent-chat'
  | 'unknown';

export interface TokenUsageEntry {
  id: string;
  timestamp: string; // ISO 8601
  model: string;
  promptTokens: number;
  completionTokens: number;
  totalTokens: number;
  purpose: TokenPurpose;
  /** Human-readable details about what was sent (tables, fields, reduction level, etc.) */
  details?: string;
  /** Short summary of the AI response (e.g. identified tables, scenario count, rating score) */
  responseSummary?: string;
}

const STORAGE_KEY = 'cucumbergnerator_mft_token_history';

function todayStr(): string {
  return new Date().toISOString().slice(0, 10);
}

function loadRaw(): TokenUsageEntry[] {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : [];
  } catch {
    return [];
  }
}

/**
 * Returns this session's token usage entries (today only).
 *
 * As a side effect, prunes any entries from previous days from localStorage
 * so storage usage stays bounded without requiring an explicit cleanup step.
 *
 * @returns Array of today's token usage entries, ordered by insertion time
 */
export function getTokenHistory(): TokenUsageEntry[] {
  const all = loadRaw();
  const today = todayStr();
  const filtered = all.filter((e) => e.timestamp.startsWith(today));
  if (filtered.length !== all.length) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(filtered));
  }
  return filtered;
}

/**
 * Records a new token usage entry with a generated id and current timestamp.
 *
 * Called immediately after each successful AI API response.
 *
 * @param entry - Usage data without the auto-generated `id` and `timestamp` fields
 */
export function recordTokenUsage(entry: Omit<TokenUsageEntry, 'id' | 'timestamp'>): void {
  const entries = getTokenHistory();
  entries.push({
    ...entry,
    id: crypto.randomUUID(),
    timestamp: new Date().toISOString(),
  });
  localStorage.setItem(STORAGE_KEY, JSON.stringify(entries));
}

/**
 * Updates the `responseSummary` of the most recently recorded entry.
 *
 * Intended to be called after the AI response has been parsed, so the
 * summary can reflect what was actually returned (e.g. "3 scenarios generated").
 * Separated from {@link recordTokenUsage} because parsing happens after the
 * token count is already known.
 *
 * @param summary - A short human-readable description of the AI response content
 */
export function updateLastResponseSummary(summary: string): void {
  const entries = getTokenHistory();
  if (entries.length === 0) return;
  entries[entries.length - 1].responseSummary = summary;
  localStorage.setItem(STORAGE_KEY, JSON.stringify(entries));
}

/**
 * Returns the sum of all token counts recorded today.
 *
 * Used to check whether the daily limit has been reached and to display
 * the current usage in the settings UI.
 *
 * @returns Aggregated prompt, completion, and total token counts for today
 */
export function getDailyTotal(): { prompt: number; completion: number; total: number } {
  const entries = getTokenHistory();
  return entries.reduce(
    (acc, e) => ({
      prompt: acc.prompt + e.promptTokens,
      completion: acc.completion + e.completionTokens,
      total: acc.total + e.totalTokens,
    }),
    { prompt: 0, completion: 0, total: 0 },
  );
}

/** Clear all history. */
export function clearTokenHistory(): void {
  localStorage.removeItem(STORAGE_KEY);
}

/** Signal that the daily limit was reached. */
export function notifyTokenLimitReached(): void {
  window.dispatchEvent(new CustomEvent('token-limit-reached'));
}

export const DAILY_LIMIT = 2_000_000;
