/**
 * @module pkce
 *
 * PKCE (Proof Key for Code Exchange) utilities for OAuth 2.0 authorization flows.
 *
 * PKCE prevents authorization code interception attacks in public clients
 * (single-page apps without a client secret). The flow generates a random
 * `code_verifier`, derives a `code_challenge` via SHA-256, and sends the
 * challenge with the authorization request. The verifier is submitted when
 * exchanging the authorization code for tokens — the server verifies the match.
 *
 * All cryptographic operations use the browser-native Web Crypto API,
 * so no external dependencies are required.
 *
 * RFC reference: https://datatracker.ietf.org/doc/html/rfc7636
 */

// ============================================================
// PKCE (Proof Key for Code Exchange) helpers for OAuth2
// Uses browser-native Web Crypto API — no external dependencies.
// ============================================================

/**
 * Generates a cryptographically random code verifier string.
 *
 * The verifier is URL-safe base64-encoded (RFC 7636, section 4.1),
 * typically 86 characters for the default length of 64 bytes.
 *
 * @param length - Number of random bytes to generate (default: 64, resulting in ~86 chars)
 * @returns A random URL-safe base64 string suitable as an OAuth code verifier
 */
export function generateCodeVerifier(length = 64): string {
  const bytes = new Uint8Array(length);
  crypto.getRandomValues(bytes);
  return base64UrlEncode(bytes);
}

/**
 * Derive the code challenge from a code verifier using SHA-256.
 */
export async function generateCodeChallenge(verifier: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(verifier);
  const digest = await crypto.subtle.digest('SHA-256', data);
  return base64UrlEncode(new Uint8Array(digest));
}

/**
 * Generate a random state string for CSRF protection.
 */
export function generateState(): string {
  const bytes = new Uint8Array(32);
  crypto.getRandomValues(bytes);
  return base64UrlEncode(bytes);
}

/**
 * Base64url encode (RFC 7636) — no padding, URL-safe alphabet.
 */
function base64UrlEncode(bytes: Uint8Array): string {
  let binary = '';
  for (const b of bytes) {
    binary += String.fromCharCode(b);
  }
  return btoa(binary)
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=+$/, '');
}
