// ============================================================
// MyForterro API — Auth (Authorization Code + PKCE) + Inference + Models + Tenants
// ============================================================

import { generateCodeVerifier, generateCodeChallenge, generateState } from './pkce';
import { recordTokenUsage, notifyTokenLimitReached } from './tokenHistory';

/** Thrown when the daily token limit is exceeded. Callers can use `instanceof` to detect this. */
export class TokenLimitError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'TokenLimitError';
  }
}

const STORAGE_PREFIX = 'cucumbergnerator_mft_';
// Session storage prefix for PKCE flow (ephemeral, cleared after callback)
const SESSION_PREFIX = 'cucumbergnerator_pkce_';

// Proxy paths configured in vite.config.ts — avoids CORS issues in dev.
// In production, configure your web server to proxy these paths accordingly.
const DEFAULT_TOKEN_URL = '/mft-auth/connect/token';
const DEFAULT_API_BASE = '/mft-api';
// Authorize URL is a full URL (browser redirect, not proxied)
const DEFAULT_AUTHORIZE_URL = 'https://integration-myforterro-core.fcs-dev.eks.forterro.com/connect/authorize';
const TIMEOUT_MS = 180_000;

// Token safety margin: refresh 60s before actual expiry
const TOKEN_EXPIRY_MARGIN_MS = 60_000;

// OAuth scopes for OpenID Connect
const OAUTH_SCOPES = 'openid profile email';

// ── Types ─────────────────────────────────────────────────────

interface Message {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

export interface MftTenant {
  tenantId: string;
  slug: string;
}

export interface MftModel {
  id: string;
  object: string;
  created: number;
  owned_by: string;
}

interface AuthCodeTokenResponse {
  access_token: string;
  id_token?: string;
  refresh_token?: string;
  expires_in: number;
  token_type: string;
}

interface ChatCompletionResponse {
  choices?: { message: { content: string } }[];
  error?: { message: string; code?: number };
  usage?: {
    prompt_tokens: number;
    completion_tokens: number;
    total_tokens: number;
  };
}

// ── localStorage helpers ──────────────────────────────────────

function getStored(key: string): string | null {
  return localStorage.getItem(STORAGE_PREFIX + key);
}

function setStored(key: string, value: string): void {
  localStorage.setItem(STORAGE_PREFIX + key, value);
}

function removeStored(key: string): void {
  localStorage.removeItem(STORAGE_PREFIX + key);
}

// ── URL configuration ────────────────────────────────────────

function getTokenUrl(): string {
  return getStored('token_url') || DEFAULT_TOKEN_URL;
}

export function setTokenUrl(url: string): void {
  if (url.trim() && url.trim() !== DEFAULT_TOKEN_URL) {
    setStored('token_url', url.trim());
  } else {
    removeStored('token_url');
  }
}

export function getApiBase(): string {
  return getStored('api_base') || DEFAULT_API_BASE;
}

export function setApiBase(url: string): void {
  if (url.trim() && url.trim() !== DEFAULT_API_BASE) {
    setStored('api_base', url.trim());
  } else {
    removeStored('api_base');
  }
}

export function getAuthorizeUrl(): string {
  return getStored('authorize_url') || DEFAULT_AUTHORIZE_URL;
}

export function setAuthorizeUrl(url: string): void {
  if (url.trim() && url.trim() !== DEFAULT_AUTHORIZE_URL) {
    setStored('authorize_url', url.trim());
  } else {
    removeStored('authorize_url');
  }
}

/**
 * Auto-detect the redirect URI from the current page URL.
 */
function getRedirectUri(): string {
  return window.location.origin + window.location.pathname;
}

// ── Token management ──────────────────────────────────────────

function getStoredToken(): string | null {
  return getStored('token');
}

function getTokenExpiry(): number {
  const v = getStored('token_expiry');
  return v ? parseInt(v, 10) : 0;
}

function isTokenExpired(): boolean {
  const expiry = getTokenExpiry();
  return Date.now() >= expiry - TOKEN_EXPIRY_MARGIN_MS;
}

function storeTokens(response: AuthCodeTokenResponse): void {
  setStored('token', response.access_token);
  setStored('token_expiry', String(Date.now() + response.expires_in * 1000));
  if (response.refresh_token) {
    setStored('refresh_token', response.refresh_token);
  }
  if (response.id_token) {
    setStored('id_token', response.id_token);
    // Extract user info from id_token for display
    const claims = parseJwtClaims(response.id_token);
    if (claims) {
      const displayName = claims.name || claims.email || claims.sub || '';
      if (displayName) setStored('user_display', displayName);
      if (claims.email) setStored('user_email', claims.email);
    }
  }
}

/**
 * Parse JWT payload (no signature verification — that's the server's job).
 */
function parseJwtClaims(jwt: string): Record<string, string> | null {
  try {
    const parts = jwt.split('.');
    if (parts.length !== 3) return null;
    const payload = parts[1];
    // Base64url → Base64 → decode
    const base64 = payload.replace(/-/g, '+').replace(/_/g, '/');
    const json = atob(base64);
    return JSON.parse(json);
  } catch {
    return null;
  }
}

// ── Login mode: redirect vs manual ────────────────────────────

export type LoginMode = 'redirect' | 'manual';

export function getLoginMode(): LoginMode {
  return (getStored('login_mode') as LoginMode) || 'redirect';
}

export function setLoginMode(mode: LoginMode): void {
  setStored('login_mode', mode);
}

// ── OAuth Authorization Code Flow + PKCE ─────────────────────

/**
 * Build the authorize URL for manual flow (open in new tab, no redirect_uri).
 * No PKCE since the user copies the code manually.
 */
export function getManualAuthorizeUrl(clientId: string, applicationId: string): string {
  // Persist for later use
  setStored('client_id', clientId);
  if (applicationId) setStored('application', applicationId);

  const authorizeUrl = getAuthorizeUrl();
  const params = new URLSearchParams({
    response_type: 'code',
    client_id: clientId,
  });
  if (applicationId) {
    params.set('application', applicationId);
  }
  return `${authorizeUrl}?${params.toString()}`;
}

/**
 * Exchange a manually pasted authorization code for tokens.
 * Accepts the full callback URL or just the code.
 */
export async function exchangeManualCode(
  codeOrUrl: string,
  clientId: string,
  applicationId: string,
  clientSecret?: string,
): Promise<{ success: boolean; error?: string }> {
  // Extract code from a full URL or use directly
  let code = codeOrUrl.trim();
  try {
    const url = new URL(code);
    const codeParam = url.searchParams.get('code');
    if (codeParam) code = codeParam;
  } catch {
    // Not a URL — treat as raw code
  }

  if (!code) {
    return { success: false, error: 'Kein Code angegeben.' };
  }

  const tokenUrl = getTokenUrl();

  const body: Record<string, string> = {
    grant_type: 'authorization_code',
    code,
    client_id: clientId,
  };
  if (clientSecret) {
    body.client_secret = clientSecret;
  }
  if (applicationId) {
    body.application = applicationId;
  }

  try {
    const res = await fetch(tokenUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams(body).toString(),
      credentials: 'omit',
    });

    const responseText = await res.text();

    if (!res.ok) {
      return {
        success: false,
        error: `Token-Austausch fehlgeschlagen (${res.status}): ${responseText.slice(0, 300)}`,
      };
    }

    const tokenResponse: AuthCodeTokenResponse = JSON.parse(responseText);
    storeTokens(tokenResponse);
    setStored('client_id', clientId);
    if (clientSecret) setStored('client_secret', clientSecret);
    if (applicationId) setStored('application', applicationId);

    return { success: true };
  } catch (err) {
    return {
      success: false,
      error: `Netzwerkfehler beim Token-Austausch: ${err instanceof Error ? err.message : 'Unbekannter Fehler'}`,
    };
  }
}

export function getStoredClientSecret(): string {
  return getStored('client_secret') || '';
}

/**
 * Initiate the OAuth2 Authorization Code flow.
 * Generates PKCE codes, stores them in sessionStorage, and redirects the browser.
 */
export async function initiateLogin(clientId: string, applicationId: string, clientSecret?: string): Promise<void> {
  const codeVerifier = generateCodeVerifier();
  const codeChallenge = await generateCodeChallenge(codeVerifier);
  const state = generateState();

  // Store PKCE data in sessionStorage (ephemeral — survives the redirect but not tab close)
  sessionStorage.setItem(SESSION_PREFIX + 'code_verifier', codeVerifier);
  sessionStorage.setItem(SESSION_PREFIX + 'state', state);
  sessionStorage.setItem(SESSION_PREFIX + 'client_id', clientId);
  if (clientSecret) sessionStorage.setItem(SESSION_PREFIX + 'client_secret', clientSecret);
  sessionStorage.setItem(SESSION_PREFIX + 'application', applicationId);

  // Also persist client_id and application in localStorage for later use
  setStored('client_id', clientId);
  if (clientSecret) setStored('client_secret', clientSecret);
  if (applicationId) {
    setStored('application', applicationId);
  }

  const authorizeUrl = getAuthorizeUrl();
  const redirectUri = getRedirectUri();

  const params = new URLSearchParams({
    response_type: 'code',
    client_id: clientId,
    redirect_uri: redirectUri,
    scope: OAUTH_SCOPES,
    code_challenge: codeChallenge,
    code_challenge_method: 'S256',
    state,
  });
  if (applicationId) {
    params.set('application', applicationId);
  }

  // Redirect browser to MyForterro login
  window.location.href = `${authorizeUrl}?${params.toString()}`;
}

/**
 * Check if the current URL contains an OAuth callback (code + state params).
 */
export function hasAuthCallback(): boolean {
  const params = new URLSearchParams(window.location.search);
  return params.has('code') && params.has('state');
}

/**
 * Handle the OAuth callback: exchange authorization code for tokens.
 * Returns true if login succeeded, false otherwise.
 * Cleans up URL query params.
 */
export async function handleAuthCallback(): Promise<{ success: boolean; error?: string }> {
  const params = new URLSearchParams(window.location.search);
  const code = params.get('code');
  const state = params.get('state');

  console.log('[OAuth] URL params:', { code: code?.slice(0, 20) + '...', state });

  if (!code || !state) {
    return { success: false, error: 'Fehlende OAuth-Parameter (code/state).' };
  }

  // Retrieve PKCE data from sessionStorage
  const expectedState = sessionStorage.getItem(SESSION_PREFIX + 'state');
  const codeVerifier = sessionStorage.getItem(SESSION_PREFIX + 'code_verifier');
  const clientId = sessionStorage.getItem(SESSION_PREFIX + 'client_id');
  const clientSecret = sessionStorage.getItem(SESSION_PREFIX + 'client_secret');
  const application = sessionStorage.getItem(SESSION_PREFIX + 'application');

  console.log('[OAuth] SessionStorage:', {
    hasState: !!expectedState,
    hasVerifier: !!codeVerifier,
    hasClientId: !!clientId,
    hasSecret: !!clientSecret,
    application,
  });

  // Clean up sessionStorage immediately
  sessionStorage.removeItem(SESSION_PREFIX + 'code_verifier');
  sessionStorage.removeItem(SESSION_PREFIX + 'state');
  sessionStorage.removeItem(SESSION_PREFIX + 'client_id');
  sessionStorage.removeItem(SESSION_PREFIX + 'client_secret');
  sessionStorage.removeItem(SESSION_PREFIX + 'application');

  if (!expectedState || !codeVerifier || !clientId) {
    return { success: false, error: 'PKCE-Daten nicht gefunden. Bitte erneut anmelden.' };
  }

  // CSRF check
  if (state !== expectedState) {
    console.log('[OAuth] State mismatch:', { expected: expectedState, got: state });
    return { success: false, error: 'Ungültiger State-Parameter (CSRF-Schutz). Bitte erneut anmelden.' };
  }

  // Clean URL (remove code/state from address bar)
  const cleanUrl = getRedirectUri();
  window.history.replaceState({}, '', cleanUrl);

  // Exchange code for tokens
  const tokenUrl = getTokenUrl();
  const redirectUri = getRedirectUri();

  const body: Record<string, string> = {
    grant_type: 'authorization_code',
    code,
    redirect_uri: redirectUri,
    client_id: clientId,
    code_verifier: codeVerifier,
  };
  if (clientSecret) {
    body.client_secret = clientSecret;
    setStored('client_secret', clientSecret);
  }
  if (application) {
    body.application = application;
  }

  console.log('[OAuth] Token-Request an:', tokenUrl, 'mit redirect_uri:', redirectUri);

  try {
    const res = await fetch(tokenUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams(body).toString(),
      credentials: 'omit',
    });

    const responseText = await res.text();
    console.log('[OAuth] Token-Response:', res.status, responseText.slice(0, 500));

    if (!res.ok) {
      return {
        success: false,
        error: `Token-Austausch fehlgeschlagen (${res.status}): ${responseText.slice(0, 300)}`,
      };
    }

    const tokenResponse: AuthCodeTokenResponse = JSON.parse(responseText);
    storeTokens(tokenResponse);
    setStored('client_id', clientId);
    if (application) setStored('application', application);

    console.log('[OAuth] Login erfolgreich! Token gespeichert.');
    return { success: true };
  } catch (err) {
    console.error('[OAuth] Netzwerkfehler:', err);
    return {
      success: false,
      error: `Netzwerkfehler beim Token-Austausch: ${err instanceof Error ? err.message : 'Unbekannter Fehler'}`,
    };
  }
}

/**
 * Refresh the access token using the stored refresh token.
 */
async function refreshAccessToken(): Promise<string> {
  const refreshToken = getStored('refresh_token');
  const clientId = getStored('client_id');
  const clientSecret = getStored('client_secret');
  const application = getStored('application');

  if (!refreshToken || !clientId) {
    clearSessionAndNotify();
    throw new Error('Sitzung abgelaufen. Bitte erneut anmelden.');
  }

  const tokenUrl = getTokenUrl();

  const body: Record<string, string> = {
    grant_type: 'refresh_token',
    refresh_token: refreshToken,
    client_id: clientId,
  };
  if (clientSecret) {
    body.client_secret = clientSecret;
  }
  if (application) {
    body.application = application;
  }

  const res = await fetch(tokenUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams(body).toString(),
    credentials: 'omit',
  });

  if (!res.ok) {
    // Refresh token expired — clear session and notify UI immediately
    clearSessionAndNotify();
    throw new Error('Sitzung abgelaufen. Bitte erneut anmelden.');
  }

  const tokenResponse: AuthCodeTokenResponse = await res.json();
  storeTokens(tokenResponse);
  return tokenResponse.access_token;
}

/**
 * Get a valid token, refreshing via refresh_token if necessary.
 * Throws if no token available or refresh fails.
 */
async function getValidToken(): Promise<string> {
  const existing = getStoredToken();
  if (existing && !isTokenExpired()) {
    return existing;
  }

  // Try to refresh using refresh_token
  return refreshAccessToken();
}

// ── Public API ────────────────────────────────────────────────

/**
 * Called internally when the session expires (refresh token invalid/missing).
 * Clears local credentials and notifies the UI so it can update without
 * requiring the user to manually click "Ausloggen" first.
 */
function clearSessionAndNotify(): void {
  logout();
  window.dispatchEvent(new CustomEvent('session-expired'));
}

/**
 * Logout: clear all stored credentials and tokens.
 */
export function logout(): void {
  removeStored('token');
  removeStored('token_expiry');
  removeStored('refresh_token');
  removeStored('id_token');
  removeStored('user_display');
  removeStored('user_email');
  removeStored('tenant_id');
  removeStored('tenants');
  // client_id, application, client_secret are intentionally kept
  // so the login form is pre-filled on next login.
}

/**
 * Check if user is authenticated via MyForterro login.
 */
export function isLoggedIn(): boolean {
  return getStoredToken() !== null;
}

/**
 * Get the stored user display name (from id_token claims).
 */
export function getStoredUserDisplay(): string | null {
  return getStored('user_display');
}

/**
 * Get stored client ID (for pre-filling the login form).
 */
export function getStoredClientId(): string {
  return getStored('client_id') || '';
}

/**
 * Get stored application ID (for pre-filling the login form).
 */
export function getStoredApplicationId(): string {
  return getStored('application') || '';
}

// ── Tenant management ─────────────────────────────────────────

export function getStoredTenantId(): string | null {
  return getStored('tenant_id');
}

export function setStoredTenantId(id: string): void {
  setStored('tenant_id', id);
}

export function getStoredTenants(): MftTenant[] {
  const json = getStored('tenants');
  if (!json) return [];
  try {
    return JSON.parse(json);
  } catch {
    return [];
  }
}

export function setStoredTenants(tenants: MftTenant[]): void {
  setStored('tenants', JSON.stringify(tenants));
}

/**
 * Fetch tenant list from API.
 */
export async function listTenants(token?: string): Promise<MftTenant[]> {
  const t = token ?? await getValidToken();
  const apiBase = getApiBase();

  const res = await fetch(`${apiBase}/v1/admin/tenants`, {
    headers: {
      Authorization: `Bearer ${t}`,
    },
  });

  if (!res.ok) {
    if (res.status === 403) {
      throw new Error('Keine Berechtigung fuer Tenant-Liste. Tenant-ID manuell eingeben.');
    }
    throw new Error(`Tenant-Abfrage fehlgeschlagen (${res.status})`);
  }

  const data: MftTenant[] = await res.json();
  return data;
}

// ── Model management ──────────────────────────────────────────

/**
 * Fetch available AI models for the current tenant.
 */
export async function listModels(): Promise<MftModel[]> {
  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) {
    throw new Error('Kein Tenant ausgewaehlt. Bitte zuerst einen Tenant waehlen.');
  }

  const apiBase = getApiBase();
  const res = await fetch(`${apiBase}/v1/ai/inference/openai/models`, {
    headers: {
      Authorization: `Bearer ${token}`,
      'MFT-Tenant-Id': tenantId,
    },
  });

  if (!res.ok) {
    const text = await res.text().catch(() => '');
    throw new Error(`Modell-Abfrage fehlgeschlagen (${res.status}): ${text.slice(0, 200)}`);
  }

  const data: { data: MftModel[] } = await res.json();
  return data.data ?? [];
}

// ── MFT Agent Management ──────────────────────────────────────

export interface MftAgentDto {
  agentId: string;
  name: string;
  model: string;
  systemPrompt: string;
}

interface ChatResponseChunkDto {
  ConversationId: string;
  MessageId: string;
  AnsweringTo: string;
  Type: 'Delta' | 'Complete';
  Message: string;
  Thinking: string | null;
  CreatedAt: string;
  CompletedAt: string | null;
}

export interface ChatWithAgentResult {
  conversationId: string;
  messageId: string;
  fullMessage: string;
}

/**
 * Create a new agent in the MyForterro API.
 */
export async function createMftAgent(
  name: string,
  model: string,
  instructions: string,
  description?: string,
): Promise<MftAgentDto> {
  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) throw new Error('Kein Tenant ausgewählt. Bitte zuerst einen Tenant wählen.');

  const apiBase = getApiBase();
  const res = await fetch(`${apiBase}/v1/ai/agents`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
      'MFT-Tenant-Id': tenantId,
      'api-version': '1.0',
    },
    body: JSON.stringify({ name, model, instructions, description: description ?? null }),
  });

  if (!res.ok) {
    const body = await res.text().catch(() => '');
    if (res.status === 401) { removeStored('token'); removeStored('token_expiry'); throw new Error('Token abgelaufen. Bitte erneut einloggen.'); }
    if (res.status === 403) throw new Error('Keine Berechtigung zum Erstellen von Agenten.');
    throw new Error(`Agent-Erstellung fehlgeschlagen (${res.status}): ${body.slice(0, 200)}`);
  }

  return res.json();
}

/**
 * Update an existing agent (e.g. when context files change).
 */
export async function updateMftAgent(
  agentId: string,
  name: string,
  model: string,
  instructions: string,
): Promise<void> {
  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) throw new Error('Kein Tenant ausgewählt.');

  const apiBase = getApiBase();
  const res = await fetch(`${apiBase}/v1/ai/agents/${agentId}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
      'MFT-Tenant-Id': tenantId,
      'api-version': '1.0',
    },
    body: JSON.stringify({ name, model, instructions }),
  });

  if (!res.ok) {
    const body = await res.text().catch(() => '');
    if (res.status === 401) { removeStored('token'); removeStored('token_expiry'); throw new Error('Token abgelaufen. Bitte erneut einloggen.'); }
    throw new Error(`Agent-Aktualisierung fehlgeschlagen (${res.status}): ${body.slice(0, 200)}`);
  }
}

/**
 * Delete an agent from the MyForterro API.
 */
export async function deleteMftAgent(agentId: string): Promise<void> {
  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) throw new Error('Kein Tenant ausgewählt.');

  const apiBase = getApiBase();
  const res = await fetch(`${apiBase}/v1/ai/agents/${agentId}`, {
    method: 'DELETE',
    headers: {
      Authorization: `Bearer ${token}`,
      'MFT-Tenant-Id': tenantId,
      'api-version': '1.0',
    },
  });

  // 404 = already gone, treat as success
  if (!res.ok && res.status !== 404) {
    const body = await res.text().catch(() => '');
    if (res.status === 401) { removeStored('token'); removeStored('token_expiry'); throw new Error('Token abgelaufen. Bitte erneut einloggen.'); }
    throw new Error(`Agent-Löschung fehlgeschlagen (${res.status}): ${body.slice(0, 200)}`);
  }
}

/**
 * Chat with a MyForterro agent via SSE streaming.
 * Calls onDelta with each incremental text chunk.
 * Returns the full assembled message + conversationId once complete.
 */
export async function chatWithAgent(
  agentId: string,
  message: string,
  conversationId: string | null,
  onDelta: (text: string) => void,
): Promise<ChatWithAgentResult> {
  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) throw new Error('Kein Tenant ausgewählt. Bitte zuerst einen Tenant wählen.');

  const apiBase = getApiBase();
  const qp = conversationId ? `?conversationId=${encodeURIComponent(conversationId)}` : '';
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), TIMEOUT_MS);

  let res: Response;
  try {
    res = await fetch(`${apiBase}/v1/ai/agents/${agentId}/chat${qp}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
        'MFT-Tenant-Id': tenantId,
        'api-version': '1.0',
        Accept: 'text/event-stream',
      },
      body: JSON.stringify({ message }),
      signal: controller.signal,
    });
  } catch (err) {
    clearTimeout(timer);
    if (err instanceof DOMException && err.name === 'AbortError') {
      throw new Error(`Timeout nach ${TIMEOUT_MS / 1000}s — der Agent antwortet nicht.`);
    }
    throw new Error(`Netzwerkfehler: ${err instanceof Error ? err.message : 'Verbindung fehlgeschlagen'}`);
  }

  clearTimeout(timer);

  if (!res.ok) {
    const body = await res.text().catch(() => '');
    if (res.status === 401) { removeStored('token'); removeStored('token_expiry'); throw new Error('Token abgelaufen. Bitte erneut einloggen.'); }
    if (res.status === 403) throw new Error('Keine Berechtigung für KI-Anfragen. Prüfe Tenant und Berechtigungen.');
    if (res.status === 404) throw new Error('Agent nicht gefunden. Bitte Agent neu erstellen.');
    if (res.status === 429 || body.includes('token limit') || body.includes('daily') || body.includes('exceeded')) {
      notifyTokenLimitReached();
      throw new TokenLimitError('Tageslimit fuer KI-Anfragen erreicht. Bitte morgen erneut versuchen.');
    }
    if (res.status === 503) throw new Error('KI-Service nicht verfügbar. Bitte später erneut versuchen.');
    throw new Error(`MyForterro API Fehler ${res.status}: ${body.slice(0, 200)}`);
  }

  // Check if the response is a JSON error instead of an SSE stream
  const contentType = res.headers.get('content-type') ?? '';
  if (contentType.includes('application/json')) {
    const body = await res.text().catch(() => '');
    if (body.includes('token limit') || body.includes('daily') || body.includes('exceeded')) {
      notifyTokenLimitReached();
      throw new TokenLimitError('Tageslimit fuer KI-Anfragen erreicht. Bitte morgen erneut versuchen.');
    }
    // Try to parse as JSON error
    try {
      const data = JSON.parse(body);
      if (data.error) {
        const errMsg = typeof data.error === 'string' ? data.error : data.error.message ?? JSON.stringify(data.error);
        throw new Error(`MyForterro Agent Fehler: ${errMsg}`);
      }
    } catch (e) {
      if (e instanceof TokenLimitError) throw e;
      if (e instanceof Error && e.message.startsWith('MyForterro')) throw e;
    }
    throw new Error(`Unerwartete Antwort vom Agent: ${body.slice(0, 200)}`);
  }

  if (!res.body) throw new Error('Keine Antwort vom Server.');

  const reader = res.body.getReader();
  const decoder = new TextDecoder();
  let buffer = '';
  let resultConversationId = '';
  let resultMessageId = '';
  let fullMessage = '';
  let hasComplete = false;

  try {
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      buffer += decoder.decode(value, { stream: true });
      const lines = buffer.split('\n');
      buffer = lines.pop() ?? '';

      for (const line of lines) {
        const trimmed = line.trim();
        if (!trimmed.startsWith('data:')) continue;
        const json = trimmed.slice(5).trim();
        if (!json || json === '[DONE]') continue;
        try {
          const chunk = JSON.parse(json);
          // Check for error objects in SSE data (token limit, etc.)
          if (chunk.error) {
            const errMsg = typeof chunk.error === 'string' ? chunk.error : chunk.error.message ?? JSON.stringify(chunk.error);
            if (errMsg.includes('token limit') || errMsg.includes('daily') || errMsg.includes('exceeded')) {
              notifyTokenLimitReached();
              throw new TokenLimitError('Tageslimit fuer KI-Anfragen erreicht. Bitte morgen erneut versuchen.');
            }
            throw new Error(`MyForterro Agent Fehler: ${errMsg}`);
          }
          // Check for Error-type chunks (not in typed DTO but may come from API)
          if (chunk.Type === 'Error') {
            const msg = chunk.Message ?? '';
            if (msg.includes('token limit') || msg.includes('daily') || msg.includes('exceeded')) {
              notifyTokenLimitReached();
              throw new TokenLimitError('Tageslimit fuer KI-Anfragen erreicht. Bitte morgen erneut versuchen.');
            }
            throw new Error(`Agent-Fehler: ${msg}`);
          }
          const typed = chunk as ChatResponseChunkDto;
          resultConversationId = typed.ConversationId;
          resultMessageId = typed.MessageId;
          if (typed.Type === 'Delta') {
            fullMessage += typed.Message;
            onDelta(typed.Message);
          } else if (typed.Type === 'Complete') {
            // Complete chunk signals end of stream; message may be empty — use assembled Delta text.
            if (typed.Message) fullMessage = typed.Message;
            hasComplete = true;
          }
        } catch (parseErr) {
          // Re-throw TokenLimitError and explicit errors
          if (parseErr instanceof TokenLimitError) throw parseErr;
          if (parseErr instanceof Error && parseErr.message.startsWith('MyForterro')) throw parseErr;
          if (parseErr instanceof Error && parseErr.message.startsWith('Agent-Fehler')) throw parseErr;
          // Skip malformed SSE lines
        }
      }
    }
  } finally {
    reader.releaseLock();
  }

  if (!hasComplete || !fullMessage) {
    throw new Error('Leere Antwort vom Agenten. Bitte erneut versuchen.');
  }

  return { conversationId: resultConversationId, messageId: resultMessageId, fullMessage };
}

/**
 * Synchronous wrapper around chatWithAgent — collects the full streamed response
 * and returns it as a plain string + conversationId.  Drop-in replacement for
 * chatCompletion() when routing through an agent.
 */
export async function chatWithAgentSync(
  agentId: string,
  message: string,
  conversationId: string | null,
): Promise<{ response: string; conversationId: string }> {
  const result = await chatWithAgent(agentId, message, conversationId, () => {});
  return { response: result.fullMessage, conversationId: result.conversationId };
}

// ── Chat Completion ───────────────────────────────────────────

/**
 * Send a chat completion request via MyForterro API.
 */
export async function chatCompletion(
  messages: Message[],
  model: string,
): Promise<string> {
  if (!model || !model.trim()) {
    throw new Error('Kein Modell ausgewählt. Bitte zuerst ein Modell in den Einstellungen wählen.');
  }

  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) {
    throw new Error('Kein Tenant ausgewaehlt. Bitte zuerst einen Tenant waehlen.');
  }

  const apiBase = getApiBase();
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), TIMEOUT_MS);

  let res: Response;
  try {
    res = await fetch(`${apiBase}/v1/ai/inference/openai/chat/completions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
        'MFT-Tenant-Id': tenantId,
        'api-version': '1.0',
      },
      body: JSON.stringify({ model, messages, stream: false }),
      signal: controller.signal,
    });
  } catch (err) {
    clearTimeout(timer);
    if (err instanceof DOMException && err.name === 'AbortError') {
      throw new Error(`Timeout nach ${TIMEOUT_MS / 1000}s — das Modell "${model}" antwortet nicht.`);
    }
    throw new Error(`Netzwerkfehler: ${err instanceof Error ? err.message : 'Verbindung fehlgeschlagen'}`);
  } finally {
    clearTimeout(timer);
  }

  if (!res.ok) {
    const body = await res.text().catch(() => '');
    if (res.status === 401) {
      // Token expired mid-request — clear and inform
      removeStored('token');
      removeStored('token_expiry');
      throw new Error('Token abgelaufen. Bitte erneut einloggen.');
    }
    if (res.status === 403) {
      throw new Error('Keine Berechtigung fuer KI-Anfragen. Pruefe Tenant und Berechtigungen.');
    }
    if (res.status === 429 || body.includes('token limit')) {
      notifyTokenLimitReached();
      throw new TokenLimitError('Tageslimit fuer KI-Anfragen erreicht. Bitte morgen erneut versuchen.');
    }
    if (res.status === 503) {
      throw new Error('KI-Service nicht verfuegbar. Bitte spaeter erneut versuchen.');
    }
    throw new Error(`MyForterro API Fehler ${res.status}: ${body.slice(0, 200)}`);
  }

  const data: ChatCompletionResponse = await res.json();

  if (data.error) {
    if (data.error.message?.includes('token limit') || data.error.message?.includes('daily') ) {
      notifyTokenLimitReached();
      throw new TokenLimitError('Tageslimit fuer KI-Anfragen erreicht. Bitte morgen erneut versuchen.');
    }
    throw new Error(`MyForterro: ${data.error.message}`);
  }

  if (data.usage) {
    recordTokenUsage({
      model,
      promptTokens: data.usage.prompt_tokens,
      completionTokens: data.usage.completion_tokens,
      totalTokens: data.usage.total_tokens,
    });
  }

  const content = data.choices?.[0]?.message?.content;
  if (!content) {
    throw new Error('Leere Antwort vom Modell. Bitte erneut versuchen.');
  }
  return content;
}
