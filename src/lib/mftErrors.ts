/** Thrown when the daily token limit is exceeded. Callers can use `instanceof` to detect this. */
export class TokenLimitError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'TokenLimitError';
  }
}

/** Error patterns that indicate the MFT tenant is missing, invalid, or unauthorized. */
const TENANT_ERROR_PATTERNS = [
  'kein tenant',
  'keine berechtigung',
  'tenant',
  'token abgelaufen',
  'erneut einloggen',
  'nicht eingeloggt',
];

/**
 * Check whether an error is caused by a missing/broken MFT tenant or auth.
 * Used to decide whether to fall back to OpenRouter.
 */
export function isMftTenantOrAuthError(err: unknown): boolean {
  if (err instanceof TokenLimitError) return true;
  if (!(err instanceof Error)) return false;
  const msg = err.message.toLowerCase();
  return TENANT_ERROR_PATTERNS.some(p => msg.includes(p));
}
