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
  | 'kb-keywords'
  | 'gherkin-generation'
  | 'rating'
  | 'agent-chat'
  | 'excel-transform'
  | 'excel-mapping'
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
  /**
   * Tenant that was active when the entry was recorded. Used to scope the
   * history to the currently-selected tenant so switching tenants hides
   * unrelated entries. Optional because legacy entries (pre-v?) were written
   * without it; those are filtered out on read.
   */
  tenantId?: string;
}

const STORAGE_KEY = 'cucumbergnerator_mft_token_history';
const TENANT_ID_STORAGE_KEY = 'cucumbergnerator_mft_tenant_id';

function todayStr(): string {
  return new Date().toISOString().slice(0, 10);
}

/**
 * Current MyForterro tenant id as stored by myforterroApi. Duplicated here
 * (rather than imported) to avoid a circular dependency — this module is
 * imported by myforterroApi, so we read the raw localStorage key directly.
 */
function currentTenantId(): string | null {
  try {
    return localStorage.getItem(TENANT_ID_STORAGE_KEY);
  } catch {
    return null;
  }
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
 * Returns this session's token usage entries (today only, current tenant only).
 *
 * As a side effect, prunes any entries from previous days from localStorage
 * so storage usage stays bounded without requiring an explicit cleanup step.
 * Legacy entries without a `tenantId` (written before tenant-scoping was
 * introduced) are hidden — they cannot be attributed to a specific tenant
 * and would pollute the view.
 *
 * @returns Array of today's token usage entries for the current tenant,
 *          ordered by insertion time
 */
export function getTokenHistory(): TokenUsageEntry[] {
  const all = loadRaw();
  const today = todayStr();
  const sameDay = all.filter((e) => e.timestamp.startsWith(today));
  if (sameDay.length !== all.length) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(sameDay));
  }
  const tenant = currentTenantId();
  if (!tenant) return [];
  return sameDay.filter((e) => e.tenantId === tenant);
}

/**
 * Returns ALL today's entries (all tenants). Used internally by
 * {@link recordTokenUsage} so writes append to the same store without
 * clobbering other tenants' rows.
 */
function getTokenHistoryAllTenants(): TokenUsageEntry[] {
  const all = loadRaw();
  const today = todayStr();
  return all.filter((e) => e.timestamp.startsWith(today));
}

/**
 * Records a new token usage entry with a generated id and current timestamp.
 *
 * Called immediately after each successful AI API response.
 *
 * @param entry - Usage data without the auto-generated `id` and `timestamp` fields
 */
export function recordTokenUsage(entry: Omit<TokenUsageEntry, 'id' | 'timestamp'>): void {
  // Append to the cross-tenant store so other tenants' same-day entries stay
  // intact; the read path filters by current tenant.
  const entries = getTokenHistoryAllTenants();
  const tenant = entry.tenantId ?? currentTenantId() ?? undefined;
  entries.push({
    ...entry,
    id: crypto.randomUUID(),
    timestamp: new Date().toISOString(),
    ...(tenant && { tenantId: tenant }),
  });
  localStorage.setItem(STORAGE_KEY, JSON.stringify(entries));
  // Schedule a server-side reconciliation; no-op if the endpoint isn't reachable.
  scheduleServerConsumptionSync();
  // Let UI components (TokenHistory panel) refresh without a full poll.
  try {
    window.dispatchEvent(new CustomEvent('token-usage-updated'));
  } catch {
    // non-browser env (tests) — ignore
  }
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
/**
 * Overwrite the token counts (prompt/completion/total) on the most recently
 * recorded entry belonging to the current tenant. Used by the server-side
 * reconciliation path in myforterroApi to replace the client-side estimate
 * with the real delta taken from the consumption report.
 *
 * Silently no-ops if there is no matching entry.
 */
export function updateLastEntryTokens(tokens: { promptTokens: number; completionTokens: number; totalTokens: number }): void {
  const entries = getTokenHistoryAllTenants();
  const tenant = currentTenantId();
  if (entries.length === 0) return;
  for (let i = entries.length - 1; i >= 0; i--) {
    if (!tenant || entries[i].tenantId === tenant) {
      entries[i].promptTokens = tokens.promptTokens;
      entries[i].completionTokens = tokens.completionTokens;
      entries[i].totalTokens = tokens.totalTokens;
      localStorage.setItem(STORAGE_KEY, JSON.stringify(entries));
      try {
        window.dispatchEvent(new CustomEvent('token-usage-updated'));
      } catch {
        // ignore
      }
      return;
    }
  }
}

export function updateLastResponseSummary(summary: string): void {
  // Operate on the full cross-tenant store so other tenants' entries survive
  // the write-back. Find the most recent entry belonging to the current tenant.
  const entries = getTokenHistoryAllTenants();
  const tenant = currentTenantId();
  if (entries.length === 0) return;
  for (let i = entries.length - 1; i >= 0; i--) {
    if (!tenant || entries[i].tenantId === tenant) {
      entries[i].responseSummary = summary;
      localStorage.setItem(STORAGE_KEY, JSON.stringify(entries));
      return;
    }
  }
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

// ── Server-Verified Daily Total ───────────────────────────────

/**
 * Cached authoritative consumption totals pulled from the MyForterro admin
 * consumption endpoint. Populated by {@link syncServerConsumption} and read
 * by the UI to show "verified" numbers alongside the locally-estimated history.
 *
 * null means "not yet synced or user lacks admin rights — fall back to local totals".
 */
export interface ServerDailyTotal {
  date: string; // YYYY-MM-DD
  promptTokens: number;
  completionTokens: number;
  totalTokens: number;
  fetchedAt: string; // ISO timestamp
}

const SERVER_TOTAL_KEY = 'cucumbergnerator_mft_server_daily_total';
const SERVER_AVAILABLE_KEY = 'cucumbergnerator_mft_server_consumption_available';

/** Read the last-known server-side total (today only, stale entries dropped). */
export function getServerDailyTotal(): ServerDailyTotal | null {
  try {
    const raw = sessionStorage.getItem(SERVER_TOTAL_KEY);
    if (!raw) return null;
    const parsed = JSON.parse(raw) as ServerDailyTotal;
    if (parsed.date !== todayStr()) return null;
    return parsed;
  } catch {
    return null;
  }
}

function setServerDailyTotal(t: ServerDailyTotal | null): void {
  try {
    if (t === null) {
      sessionStorage.removeItem(SERVER_TOTAL_KEY);
    } else {
      sessionStorage.setItem(SERVER_TOTAL_KEY, JSON.stringify(t));
    }
  } catch {
    // ignore
  }
}

/** Whether the consumption endpoint is known to be reachable in this session. */
export function isServerConsumptionAvailable(): boolean {
  try {
    return sessionStorage.getItem(SERVER_AVAILABLE_KEY) === '1';
  } catch {
    return false;
  }
}

function setServerConsumptionAvailable(v: boolean): void {
  try {
    sessionStorage.setItem(SERVER_AVAILABLE_KEY, v ? '1' : '0');
  } catch {
    // ignore
  }
}

/**
 * Schedule a server-consumption sync for ~2s from now, coalescing multiple
 * rapid calls (e.g. a batch of agent requests) into a single HTTP fetch.
 * Fire-and-forget — UI listens to storage events / polls `getServerDailyTotal`.
 */
let pendingSyncTimer: ReturnType<typeof setTimeout> | null = null;
export function scheduleServerConsumptionSync(delayMs = 2000): void {
  if (pendingSyncTimer !== null) return;
  pendingSyncTimer = setTimeout(() => {
    pendingSyncTimer = null;
    void syncServerConsumption();
  }, delayMs);
}

/**
 * Pull today's authoritative consumption from the server and cache it.
 *
 * Safe to call repeatedly (after each AI call and on app start). If the user
 * lacks admin rights or the network fails, silently returns null and leaves
 * the local history as the source of truth.
 *
 * Imports {@link fetchTodaysConsumption} lazily to avoid a circular dep with
 * myforterroApi (which imports from this module).
 *
 * @returns The fetched server total, or null if unavailable
 */
export async function syncServerConsumption(): Promise<ServerDailyTotal | null> {
  try {
    const { fetchTodaysConsumption } = await import('./myforterroApi');
    const report = await fetchTodaysConsumption();
    if (!report) {
      setServerConsumptionAvailable(false);
      return null;
    }
    const entry: ServerDailyTotal = {
      date: todayStr(),
      promptTokens: report.total.promptTokens,
      completionTokens: report.total.completionTokens,
      totalTokens: report.total.totalTokens,
      fetchedAt: new Date().toISOString(),
    };
    setServerDailyTotal(entry);
    setServerConsumptionAvailable(true);
    // Server reports are authoritative — if we were above the tenant's limit,
    // fire the same daily-limit event that local checks dispatch.
    if (entry.totalTokens >= getDailyLimit()) {
      notifyTokenLimitReached();
    }
    try {
      window.dispatchEvent(new CustomEvent('token-usage-updated'));
    } catch {
      // non-browser env — ignore
    }
    return entry;
  } catch (err) {
    console.warn('[syncServerConsumption] failed:', err);
    return null;
  }
}

/**
 * Clear today's history for the current tenant only. Other tenants' entries
 * (same or different day) are kept. Also drops the cached server-verified
 * total and the session "limit hit" flag so the UI reflects a fresh state.
 */
export function clearTokenHistory(): void {
  const tenant = currentTenantId();
  if (!tenant) {
    // No tenant → nothing to scope to; safest behaviour is a full wipe (matches
    // old semantics for unauthenticated / legacy callers).
    localStorage.removeItem(STORAGE_KEY);
  } else {
    const all = loadRaw();
    const remaining = all.filter((e) => e.tenantId !== tenant);
    if (remaining.length === 0) {
      localStorage.removeItem(STORAGE_KEY);
    } else {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(remaining));
    }
  }
  try {
    sessionStorage.removeItem(SERVER_TOTAL_KEY);
    sessionStorage.removeItem(DAILY_LIMIT_HIT_KEY);
    window.dispatchEvent(new CustomEvent('token-usage-updated'));
  } catch {
    // ignore
  }
}

/**
 * Session-level flag: has the MyForterro daily token limit been hit during this
 * browser session? When true, AI calls short-circuit and throw the daily-limit
 * error immediately — no point wasting round-trips on requests that are
 * guaranteed to fail.
 *
 * Stored in sessionStorage (not localStorage) because we want to retry the agent
 * flow after a page reload — the daily limit may have reset between the old and
 * new session.
 */
const DAILY_LIMIT_HIT_KEY = 'cucumbergnerator_mft_daily_limit_hit_session';

/** True if MyForterro signalled "daily limit reached" earlier in this browser session. */
export function isMftDailyLimitHitThisSession(): boolean {
  try {
    return sessionStorage.getItem(DAILY_LIMIT_HIT_KEY) === '1';
  } catch {
    return false;
  }
}

/** Clear the session-level daily-limit flag (e.g. after a manual retry via banner). */
export function clearMftDailyLimitHitThisSession(): void {
  try {
    sessionStorage.removeItem(DAILY_LIMIT_HIT_KEY);
  } catch {
    // ignore
  }
}

/** Signal that the daily limit was reached. */
export function notifyTokenLimitReached(): void {
  try {
    sessionStorage.setItem(DAILY_LIMIT_HIT_KEY, '1');
  } catch {
    // sessionStorage unavailable — ignore, the error still surfaces via the catch path
  }
  window.dispatchEvent(new CustomEvent('token-limit-reached'));
}

/**
 * Platform-wide fallback daily token limit, used when the tenant has no
 * custom override (`maxDailyTokens` is null from /v1/ai/configuration) or
 * when the config call fails. The real tenant limit is cached in
 * sessionStorage via {@link syncTenantLimit} and returned by {@link getDailyLimit}.
 */
export const DEFAULT_DAILY_LIMIT = 2_000_000;

/** @deprecated Prefer {@link getDailyLimit} so tenant-specific overrides apply. */
export const DAILY_LIMIT = DEFAULT_DAILY_LIMIT;

const TENANT_LIMIT_KEY = 'cucumbergnerator_mft_tenant_daily_limit';

/**
 * Returns the effective daily token limit for the current tenant.
 * - Tenant's custom `maxDailyTokens` if set and positive
 * - `Number.POSITIVE_INFINITY` if the tenant has unlimited usage (-1)
 * - {@link DEFAULT_DAILY_LIMIT} if nothing is cached yet
 *
 * Callers should treat `Number.POSITIVE_INFINITY` specially in UI contexts
 * (show "∞" instead of a number).
 */
export function getDailyLimit(): number {
  try {
    const raw = sessionStorage.getItem(TENANT_LIMIT_KEY);
    if (raw === null) return DEFAULT_DAILY_LIMIT;
    if (raw === 'unlimited') return Number.POSITIVE_INFINITY;
    const n = Number(raw);
    return Number.isFinite(n) && n > 0 ? n : DEFAULT_DAILY_LIMIT;
  } catch {
    return DEFAULT_DAILY_LIMIT;
  }
}

/** True if {@link getDailyLimit} currently reports no ceiling. */
export function isDailyLimitUnlimited(): boolean {
  return getDailyLimit() === Number.POSITIVE_INFINITY;
}

/**
 * Pull the tenant's `maxDailyTokens` from /v1/ai/configuration and cache it
 * in sessionStorage so {@link getDailyLimit} returns it. No-ops silently on
 * network errors or when the user lacks permission.
 */
export async function syncTenantLimit(): Promise<number | null> {
  try {
    const { fetchTenantAiConfiguration } = await import('./myforterroApi');
    const cfg = await fetchTenantAiConfiguration();
    if (!cfg) return null;
    if (cfg.maxDailyTokens === -1) {
      sessionStorage.setItem(TENANT_LIMIT_KEY, 'unlimited');
      return Number.POSITIVE_INFINITY;
    }
    if (typeof cfg.maxDailyTokens === 'number' && cfg.maxDailyTokens > 0) {
      sessionStorage.setItem(TENANT_LIMIT_KEY, String(cfg.maxDailyTokens));
      return cfg.maxDailyTokens;
    }
    // null → global default applies; don't overwrite cache with a concrete number.
    sessionStorage.removeItem(TENANT_LIMIT_KEY);
    return DEFAULT_DAILY_LIMIT;
  } catch (err) {
    console.warn('[syncTenantLimit] failed:', err);
    return null;
  }
}

/**
 * Pre-emptively check today's locally-recorded token usage against
 * {@link DAILY_LIMIT}. If the threshold is exceeded, trigger
 * {@link notifyTokenLimitReached} so the session flag + event fire before
 * any actual AI call is sent — this avoids a wasted first round-trip on every
 * session startup when the user already burned through today's budget earlier.
 *
 * MyForterro does not expose a quota query endpoint, so this relies on the
 * locally-recorded history (which is authoritative for this browser / device).
 * Tenants with a lower custom limit will not be caught by this check — their
 * first call will fail as before and set the flag reactively.
 *
 * @returns true if the daily limit is already exceeded based on local history
 */
export function checkDailyLimitExceededFromHistory(): boolean {
  try {
    const total = getDailyTotal().total;
    const limit = getDailyLimit();
    if (total >= limit) {
      notifyTokenLimitReached();
      return true;
    }
    // Auto-clear stale flag: if today's recorded usage is below the limit but
    // the session flag is still set (e.g. the flag was set yesterday and the
    // tab stayed open across midnight, or the user opened a new tab but left
    // localStorage intact), drop the flag so the next call retries MyForterro
    // instead of short-circuiting.
    if (isMftDailyLimitHitThisSession()) {
      console.log('[tokenHistory] Stale daily-limit flag cleared — today total is', total, '/ limit', limit);
      clearMftDailyLimitHitThisSession();
    }
  } catch {
    // localStorage unavailable / malformed — ignore, fallback works reactively
  }
  return false;
}
