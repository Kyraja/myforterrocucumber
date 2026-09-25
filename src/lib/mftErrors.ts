/** Thrown when the daily token limit is exceeded. Callers can use `instanceof` to detect this. */
export class TokenLimitError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'TokenLimitError';
  }
}

/**
 * Thrown when the upstream model or gateway applies a per-minute rate limit.
 * Distinct from `TokenLimitError` (daily quota) — callers should tell the user to
 * wait a short moment and retry, rather than suggest coming back tomorrow.
 */
export class RateLimitError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'RateLimitError';
  }
}

/** Patterns that indicate a temporary rate limit (not a daily quota). */
const RATE_LIMIT_PATTERNS = [
  'too many tokens',
  'too many connections',
  'too many requests',
  'please wait before trying again',
  'throttled',
  'throttling',
];

/** Returns true if the error message matches a known temporary rate-limit pattern. */
export function isRateLimitMessage(msg: string): boolean {
  const lower = msg.toLowerCase();
  return RATE_LIMIT_PATTERNS.some(p => lower.includes(p));
}
