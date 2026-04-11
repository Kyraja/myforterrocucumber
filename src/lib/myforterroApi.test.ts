import { describe, it, expect } from 'vitest';
import { isMftTenantOrAuthError, TokenLimitError } from './mftErrors';

describe('isMftTenantOrAuthError', () => {
  it('returns true for TokenLimitError', () => {
    expect(isMftTenantOrAuthError(new TokenLimitError('limit reached'))).toBe(true);
  });

  it('returns true for missing tenant error', () => {
    expect(isMftTenantOrAuthError(new Error('Kein Tenant ausgewaehlt. Bitte zuerst einen Tenant waehlen.'))).toBe(true);
  });

  it('returns true for tenant permission error', () => {
    expect(isMftTenantOrAuthError(new Error('Keine Berechtigung fuer KI-Anfragen. Pruefe Tenant und Berechtigungen.'))).toBe(true);
  });

  it('returns true for expired token error', () => {
    expect(isMftTenantOrAuthError(new Error('Token abgelaufen. Bitte erneut einloggen.'))).toBe(true);
  });

  it('returns true for not-logged-in error', () => {
    expect(isMftTenantOrAuthError(new Error('Nicht eingeloggt. Bitte zuerst anmelden.'))).toBe(true);
  });

  it('returns false for unrelated errors', () => {
    expect(isMftTenantOrAuthError(new Error('Netzwerkfehler: fetch failed'))).toBe(false);
  });

  it('returns false for non-Error values', () => {
    expect(isMftTenantOrAuthError('string error')).toBe(false);
    expect(isMftTenantOrAuthError(null)).toBe(false);
    expect(isMftTenantOrAuthError(undefined)).toBe(false);
  });
});
