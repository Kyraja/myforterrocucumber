// ── Token Usage History (localStorage, daily) ─────────────────

export interface TokenUsageEntry {
  id: string;
  timestamp: string; // ISO 8601
  model: string;
  promptTokens: number;
  completionTokens: number;
  totalTokens: number;
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

/** Returns today's entries, pruning older ones from storage. */
export function getTokenHistory(): TokenUsageEntry[] {
  const all = loadRaw();
  const today = todayStr();
  const filtered = all.filter((e) => e.timestamp.startsWith(today));
  if (filtered.length !== all.length) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(filtered));
  }
  return filtered;
}

/** Record a new token usage entry. */
export function recordTokenUsage(entry: Omit<TokenUsageEntry, 'id' | 'timestamp'>): void {
  const entries = getTokenHistory();
  entries.push({
    ...entry,
    id: crypto.randomUUID(),
    timestamp: new Date().toISOString(),
  });
  localStorage.setItem(STORAGE_KEY, JSON.stringify(entries));
}

/** Sum of today's token usage. */
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
