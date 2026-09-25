// ============================================================
// MyForterro API — Auth (Authorization Code + PKCE) + Inference + Models + Tenants
// ============================================================

import { generateCodeVerifier, generateCodeChallenge, generateState } from './pkce';
import { recordTokenUsage, notifyTokenLimitReached, isMftDailyLimitHitThisSession } from './tokenHistory';
import type { TokenPurpose } from './tokenHistory';
import { countTokens } from './tokenCounter';
import { getAiRequestTimeoutMs, getAgentMaxTokens } from './settings';

// Re-export error classes and helpers from mftErrors (used by generatePackage etc.)
export { TokenLimitError, RateLimitError } from './mftErrors';
import { TokenLimitError, RateLimitError, isRateLimitMessage } from './mftErrors';

const STORAGE_PREFIX = 'cucumbergnerator_mft_';
// Session storage prefix for PKCE flow (ephemeral, cleared after callback)
const SESSION_PREFIX = 'cucumbergnerator_pkce_';
const SESSION_RETURN_QUERY = SESSION_PREFIX + 'return_query';

// Proxy paths configured in vite.config.ts — avoids CORS issues in dev.
// In production, configure your web server to proxy these paths accordingly.
const DEFAULT_TOKEN_URL = '/mft-auth/connect/token';
const DEFAULT_API_BASE = '/mft-api';
// Authorize URL is a full URL (browser redirect, not proxied)
const DEFAULT_AUTHORIZE_URL = 'https://integration-myforterro-core.fcs-dev.eks.forterro.com/connect/authorize';
const DEFAULT_AI_API_VERSION: 'v1' | 'v2' = 'v2';

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

type AiApiVersion = 'v1' | 'v2';

function getAiApiVersion(): AiApiVersion {
  const v = getStored('ai_api_version');
  return v === 'v1' || v === 'v2' ? v : DEFAULT_AI_API_VERSION;
}

function getAiApiVersionOrder(): AiApiVersion[] {
  const preferred = getAiApiVersion();
  return preferred === 'v2' ? ['v2', 'v1'] : ['v1', 'v2'];
}

function buildAiUrl(apiBase: string, version: AiApiVersion, path: string): string {
  return `${apiBase}/${version}/ai${path}`;
}

async function fetchAiWithFallback(path: string, init: RequestInit): Promise<Response> {
  const apiBase = getApiBase();
  let lastResponse: Response | null = null;
  for (const version of getAiApiVersionOrder()) {
    const headers = {
      ...(init.headers as Record<string, string> | undefined),
      'api-version': version === 'v2' ? '2.0' : '1.0',
    };
    const res = await fetch(buildAiUrl(apiBase, version, path), {
      ...init,
      headers,
    });
    if (res.status !== 404 && res.status !== 400) return res;
    lastResponse = res;
  }
  if (lastResponse) return lastResponse;
  throw new Error('AI API endpoint not reachable.');
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
      logout();
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

  // Preserve URL feature flags across OAuth redirects so the app returns
  // with the same dev/ai mode after callback URL cleanup.
  const currentParams = new URLSearchParams(window.location.search);
  const returnParams = new URLSearchParams();
  const aiParam = currentParams.get('ai');
  const devParam = currentParams.get('dev');
  if (aiParam === 'true' || aiParam === 'false') returnParams.set('ai', aiParam);
  if (devParam === 'true' || devParam === 'false') returnParams.set('dev', devParam);
  // Fallback to session-gated values when query params are currently absent.
  if (!returnParams.has('ai') && sessionStorage.getItem('cucumbergnerator_ai_enabled') === 'true') {
    returnParams.set('ai', 'true');
  }
  if (!returnParams.has('dev') && sessionStorage.getItem('cucumbergnerator_dev_mode') === 'true') {
    returnParams.set('dev', 'true');
  }
  const returnQuery = returnParams.toString();
  if (returnQuery) sessionStorage.setItem(SESSION_RETURN_QUERY, returnQuery);
  else sessionStorage.removeItem(SESSION_RETURN_QUERY);

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
  const returnQuery = sessionStorage.getItem(SESSION_RETURN_QUERY) || '';

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
  sessionStorage.removeItem(SESSION_RETURN_QUERY);

  if (!expectedState || !codeVerifier || !clientId) {
    return { success: false, error: 'PKCE-Daten nicht gefunden. Bitte erneut anmelden.' };
  }

  // CSRF check
  if (state !== expectedState) {
    console.log('[OAuth] State mismatch:', { expected: expectedState, got: state });
    return { success: false, error: 'Ungültiger State-Parameter (CSRF-Schutz). Bitte erneut anmelden.' };
  }

  // Clean URL (remove code/state from address bar)
  const cleanUrl = returnQuery ? `${getRedirectUri()}?${returnQuery}` : getRedirectUri();
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
      // Token exchange failed — clear stale auth data so next login starts fresh
      logout();
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
export async function getValidToken(): Promise<string> {
  const existing = getStoredToken();
  if (existing && !isTokenExpired()) {
    return existing;
  }

  // PKCE flow: refresh the access token via the stored refresh_token.
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
  // Tenant-scoped caches — must be cleared so the next user/tenant does not
  // inherit stale limits or consumption data.
  try {
    sessionStorage.removeItem('cucumbergnerator_mft_tenant_daily_limit');
    sessionStorage.removeItem('cucumbergnerator_mft_server_daily_total');
    sessionStorage.removeItem('cucumbergnerator_mft_server_consumption_available');
    sessionStorage.removeItem('cucumbergnerator_mft_daily_limit_hit_session');
  } catch {
    // sessionStorage unavailable — safe to ignore
  }
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
  const previous = getStored('tenant_id');
  setStored('tenant_id', id);
  // If the tenant actually changed, invalidate tenant-scoped caches so the
  // UI does not show the previous tenant's limit/consumption until the next
  // sync completes.
  if (previous && previous !== id) {
    try {
      sessionStorage.removeItem('cucumbergnerator_mft_tenant_daily_limit');
      sessionStorage.removeItem('cucumbergnerator_mft_server_daily_total');
      sessionStorage.removeItem('cucumbergnerator_mft_server_consumption_available');
      sessionStorage.removeItem('cucumbergnerator_mft_daily_limit_hit_session');
      window.dispatchEvent(new CustomEvent('tenant-changed'));
    } catch {
      // ignore
    }
  }
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
    const body = await res.text().catch(() => '');
    const wwwAuth = res.headers.get('www-authenticate') || '';
    console.warn('[listTenants] Failed', res.status, 'www-authenticate:', wwwAuth, 'body:', body.slice(0, 400));
    if (res.status === 403) {
      throw new Error('Keine Berechtigung fuer Tenant-Liste. Tenant-ID manuell eingeben.');
    }
    throw new Error(`Tenant-Abfrage fehlgeschlagen (${res.status})${wwwAuth ? ' | ' + wwwAuth : ''}`);
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

  const res = await fetchAiWithFallback('/inference/openai/models', {
    headers: {
      Authorization: `Bearer ${token}`,
      'MFT-Tenant-Id': tenantId,
    },
  });

  if (!res.ok) {
    const text = await res.text().catch(() => '');
    const wwwAuth = res.headers.get('www-authenticate') || '';
    console.warn('[listModels] Failed', res.status, 'tenantId:', tenantId, 'www-authenticate:', wwwAuth, 'body:', text.slice(0, 400));
    throw new Error(`Modell-Abfrage fehlgeschlagen (${res.status})${wwwAuth ? ' | ' + wwwAuth : ''}: ${text.slice(0, 200)}`);
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

export interface MftAgentDescriptor {
  agentId: string;
  name: string;
  description: string | null;
  publicationStatus: string;
}

export interface MftFileInfo {
  fileId: string;
  fileName?: string;
  size: number;
  mimeType?: string | null;
}

export interface MessageAttachment {
  fileName?: string;
  content?: string;
  fileId?: string;
}

export interface RunWithAgentResult {
  response: string;
  conversationId: string | null;
}

const AGENT_FIELD_LIMITS = {
  name: 200,
  description: 10_240,
  model: 128,
  instructions: 100_000,
} as const;

function validateAgentFields(name: string, model: string, instructions: string, description?: string): void {
  const fields: Array<[string, string, number]> = [
    ['Agent-Name', name, AGENT_FIELD_LIMITS.name],
    ['Modell', model, AGENT_FIELD_LIMITS.model],
    ['Instructions', instructions, AGENT_FIELD_LIMITS.instructions],
  ];
  if (description != null) fields.push(['Beschreibung', description, AGENT_FIELD_LIMITS.description]);
  const invalid = fields.find(([, value, max]) => value.length > max);
  if (invalid) throw new Error(`${invalid[0]} darf höchstens ${invalid[2].toLocaleString('de-DE')} Zeichen enthalten.`);
}

export interface ConversationAttachmentContent {
  attachmentId: string;
  fileName: string;
  size: number;
  mimeType: string;
  base64?: string;
  url?: string;
}

/**
 * Discover all agents accessible for the current user/tenant.
 */
export async function discoverMftAgents(): Promise<MftAgentDescriptor[]> {
  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) throw new Error('Kein Tenant ausgewählt.');

  const res = await fetchAiWithFallback('/agents/discover', {
    headers: {
      Authorization: `Bearer ${token}`,
      'MFT-Tenant-Id': tenantId,
    },
  });

  if (!res.ok) return [];
  return res.json();
}

/**
 * Create a new agent in the MyForterro API.
 * If an agent with the same name already exists, updates it instead and returns its data.
 */
export async function createMftAgent(
  name: string,
  model: string,
  instructions: string,
  description?: string,
): Promise<MftAgentDto> {
  validateAgentFields(name, model, instructions, description);
  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) throw new Error('Kein Tenant ausgewählt. Bitte zuerst einen Tenant wählen.');

  const res = await fetchAiWithFallback('/agents', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
      'MFT-Tenant-Id': tenantId,
    },
    body: JSON.stringify({
      name,
      model,
      instructions,
      description: description ?? null,
      maxTokens: getAgentMaxTokens(),
      ignoreUserMcpServers: true,
    }),
  });

  if (!res.ok) {
    const body = await res.text().catch(() => '');
    if (res.status === 401) { removeStored('token'); removeStored('token_expiry'); throw new Error('Token abgelaufen. Bitte erneut einloggen.'); }
    if (res.status === 403) throw new Error('Keine Berechtigung zum Erstellen von Agenten.');

    // Agent with same name already exists — find it and update instead
    if (res.status === 409 || body.includes('already exists') || body.includes('Conflict')) {
      const existing = await discoverMftAgents();
      const match = existing.find((a) => a.name === name);
      if (match) {
        await updateMftAgent(match.agentId, name, model, instructions);
        return { agentId: match.agentId, name, model, systemPrompt: instructions };
      }
    }

    throw new Error(`Agent-Erstellung fehlgeschlagen (${res.status}): ${body.slice(0, 200)}`);
  }

  return res.json();
}

/** Upload a file for reuse in later agent messages. */
export async function uploadMftFile(file: File): Promise<MftFileInfo> {
  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) throw new Error('Kein Tenant ausgewählt. Bitte zuerst einen Tenant wählen.');

  const form = new FormData();
  form.append('file', file, file.name);
  const res = await fetchAiWithFallback('/files', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${token}`,
      'MFT-Tenant-Id': tenantId,
    },
    body: form,
  });

  if (!res.ok) {
    const body = await res.text().catch(() => '');
    const error = new Error(`Datei-Upload fehlgeschlagen (${res.status}): ${body.slice(0, 200)}`) as Error & { status?: number };
    error.status = res.status;
    throw error;
  }
  return res.json() as Promise<MftFileInfo>;
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
  validateAgentFields(name, model, instructions);
  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) throw new Error('Kein Tenant ausgewählt.');

  const res = await fetchAiWithFallback(`/agents/${agentId}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
      'MFT-Tenant-Id': tenantId,
    },
    body: JSON.stringify({
      name,
      model,
      instructions,
      maxTokens: getAgentMaxTokens(),
      ignoreUserMcpServers: true,
    }),
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

  const res = await fetchAiWithFallback(`/agents/${agentId}`, {
    method: 'DELETE',
    headers: {
      Authorization: `Bearer ${token}`,
      'MFT-Tenant-Id': tenantId,
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
 * Synchronous agent call wrapper — delegates to the SSE streaming endpoint.
 */
export async function chatWithAgentSync(
  agentId: string,
  message: string,
  purpose?: TokenPurpose,
  modelName?: string,
  details?: string,
  /** Optional callback — receives the final full response text once available */
  onDelta?: (text: string) => void,
  attachments?: MessageAttachment[],
): Promise<{ response: string; conversationId: string }> {
  const run = await runWithAgentSync(
    agentId,
    message,
    attachments,
    purpose,
    modelName,
    details,
  );
  if (onDelta) onDelta(run.response);
  return {
    response: run.response,
    conversationId: run.conversationId ?? '',
  };
}

/**
 * Executes an agent call via the SSE /chat streaming endpoint.
 * Streaming keeps the connection alive, avoiding gateway 100s timeouts.
 * Falls back to the blocking /run endpoint if streaming is unavailable.
 */
export async function runWithAgentSync(
  agentId: string,
  message: string,
  attachments?: MessageAttachment[],
  purpose?: TokenPurpose,
  modelName?: string,
  details?: string,
): Promise<RunWithAgentResult> {
  if (isMftDailyLimitHitThisSession()) {
    throw new TokenLimitError('Tageslimit fuer KI-Anfragen erreicht. Bitte morgen erneut versuchen.');
  }

  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) throw new Error('Kein Tenant ausgewählt. Bitte zuerst einen Tenant wählen.');

  const timeoutMs = getAiRequestTimeoutMs();
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);

  let res: Response;
  try {
    res = await fetchAiWithFallback(`/agents/${agentId}/chat`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
        'MFT-Tenant-Id': tenantId,
        Accept: 'text/event-stream',
      },
      body: JSON.stringify({
        message,
        ...(attachments && attachments.length > 0 ? { attachments } : {}),
      }),
      signal: controller.signal,
    });
  } catch (err) {
    clearTimeout(timer);
    if (err instanceof DOMException && err.name === 'AbortError') {
      throw new Error(`Timeout nach ${timeoutMs / 1000}s — der Agent antwortet nicht.`);
    }
    throw new Error(`Netzwerkfehler: ${err instanceof Error ? err.message : 'Verbindung fehlgeschlagen'}`);
  }
  clearTimeout(timer);

  if (!res.ok) {
    const body = await res.text().catch(() => '');
    if (res.status === 401) { removeStored('token'); removeStored('token_expiry'); throw new Error('Token abgelaufen. Bitte erneut einloggen.'); }
    if (res.status === 403) throw new Error('Keine Berechtigung für KI-Anfragen. Prüfe Tenant und Berechtigungen.');
    if (res.status === 404) throw new Error('Agent nicht gefunden. Bitte Agent neu erstellen.');
    if (body.includes('token limit') || body.includes('daily') || body.includes('exceeded')) {
      notifyTokenLimitReached();
      throw new TokenLimitError('Tageslimit fuer KI-Anfragen erreicht. Bitte morgen erneut versuchen.');
    }
    if (res.status === 429 || isRateLimitMessage(body)) {
      throw new RateLimitError(body || 'Zu viele Anfragen in kurzer Zeit — bitte kurz warten und erneut versuchen.');
    }
    if (res.status === 503) throw new Error('KI-Service nicht verfügbar. Bitte später erneut versuchen.');
    throw new Error(`MyForterro API Fehler ${res.status}: ${body.slice(0, 300)}`);
  }

  let responseText = '';
  let resultConversationId: string | null = null;
  const contentType = res.headers.get('content-type') ?? '';

  if (contentType.includes('text/event-stream') && res.body) {
    // Parse SSE stream: accumulate Delta chunks, stop on Complete
    const reader = res.body.getReader();
    const decoder = new TextDecoder();
    let buffer = '';
    let streamDone = false;

    try {
      while (!streamDone) {
        const { value, done } = await reader.read();
        if (done) break;

        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split('\n');
        buffer = lines.pop() ?? '';

        for (const line of lines) {
          if (!line.startsWith('data:')) continue;
          const jsonStr = line.slice(5).trim();
          if (!jsonStr || jsonStr === '[DONE]') continue;
          try {
            const event = JSON.parse(jsonStr) as {
                type?: string; $type?: string;
                message?: string; Message?: string;
                thinking?: string; Thinking?: string;
                conversationId?: string; ConversationId?: string;
                completedAt?: string | null; CompletedAt?: string | null;
                code?: string; Code?: string;
            };
              if (event.conversationId ?? event.ConversationId) {
                resultConversationId = event.conversationId ?? event.ConversationId ?? null;
              }
              const errorCode = event.code ?? event.Code;
              if (errorCode) throw new Error(`Agent-Fehler: ${event.message ?? event.Message ?? errorCode}`);
              responseText += event.message ?? event.Message ?? '';
              if (event.type === 'Complete' || event.$type === 'turn-end' || event.completedAt != null || event.CompletedAt != null) {
              streamDone = true;
              break;
            }
          } catch (parseErr) {
            if (parseErr instanceof Error && parseErr.message.startsWith('Agent-Fehler')) throw parseErr;
            // skip malformed SSE lines
          }
        }
      }
    } finally {
      reader.cancel().catch(() => undefined);
    }
  } else {
    // Fallback: non-streaming response (e.g. plain JSON from /run)
    const text = await res.text();
    const candidate = text.trim();
    if (candidate.startsWith('{') && candidate.endsWith('}')) {
      try {
        const data = JSON.parse(candidate) as { message?: string; conversationId?: string; result?: string };
        responseText = data.message ?? data.result ?? text;
        resultConversationId = data.conversationId ?? null;
      } catch {
        responseText = text;
      }
    } else {
      responseText = text;
    }
  }

  if (!responseText.trim()) {
    throw new Error('Leere Antwort vom Agenten. Bitte erneut versuchen.');
  }

  const promptTokens = countTokens(message);
  const completionTokens = countTokens(responseText);
  recordTokenUsage({
    model: modelName || 'agent',
    promptTokens,
    completionTokens,
    totalTokens: promptTokens + completionTokens,
    purpose: purpose ?? 'unknown',
    ...(details && { details }),
  });

  return { response: responseText.trim(), conversationId: resultConversationId };
}

/**
 * Fetches message attachment content through the AI API attachment endpoint.
 * V2 can return inline base64 payloads or URL references.
 */
export async function fetchConversationAttachment(
  attachmentId: string,
): Promise<ConversationAttachmentContent> {
  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) throw new Error('Kein Tenant ausgewählt. Bitte zuerst einen Tenant wählen.');

  const res = await fetchAiWithFallback(`/attachments/${encodeURIComponent(attachmentId)}`, {
    method: 'GET',
    headers: {
      Authorization: `Bearer ${token}`,
      'MFT-Tenant-Id': tenantId,
    },
  });

  if (!res.ok) {
    const body = await res.text().catch(() => '');
    throw new Error(`Attachment-Abruf fehlgeschlagen (${res.status}): ${body.slice(0, 200)}`);
  }

  return res.json() as Promise<ConversationAttachmentContent>;
}

// ── Chat Completion ───────────────────────────────────────────

/**
 * Send a chat completion request via MyForterro API.
 */
export async function chatCompletion(
  messages: Message[],
  model: string,
  purpose?: TokenPurpose,
  details?: string,
): Promise<string> {
  // Short-circuit on known daily-limit state (see chatWithAgent for rationale)
  if (isMftDailyLimitHitThisSession()) {
    throw new TokenLimitError('Tageslimit fuer KI-Anfragen erreicht. Bitte morgen erneut versuchen.');
  }

  if (!model || !model.trim()) {
    throw new Error('Kein Modell ausgewählt. Bitte zuerst ein Modell in den Einstellungen wählen.');
  }

  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) {
    throw new Error('Kein Tenant ausgewaehlt. Bitte zuerst einen Tenant waehlen.');
  }

  const timeoutMs = getAiRequestTimeoutMs();
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);

  let res: Response;
  try {
    res = await fetchAiWithFallback('/inference/openai/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
        'MFT-Tenant-Id': tenantId,
      },
      body: JSON.stringify({ model, messages, stream: false }),
      signal: controller.signal,
    });
  } catch (err) {
    clearTimeout(timer);
    if (err instanceof DOMException && err.name === 'AbortError') {
      throw new Error(`Timeout nach ${timeoutMs / 1000}s — das Modell "${model}" antwortet nicht.`);
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
    if (body.includes('token limit') || body.includes('daily') || body.includes('exceeded')) {
      notifyTokenLimitReached();
      throw new TokenLimitError('Tageslimit fuer KI-Anfragen erreicht. Bitte morgen erneut versuchen.');
    }
    if (res.status === 429 || isRateLimitMessage(body)) {
      throw new RateLimitError(body || 'Zu viele Anfragen in kurzer Zeit — bitte kurz warten und erneut versuchen.');
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
    if (data.error.message && isRateLimitMessage(data.error.message)) {
      throw new RateLimitError(data.error.message);
    }
    throw new Error(`MyForterro: ${data.error.message}`);
  }

  if (data.usage) {
    recordTokenUsage({
      model,
      promptTokens: data.usage.prompt_tokens,
      completionTokens: data.usage.completion_tokens,
      totalTokens: data.usage.total_tokens,
      purpose: purpose ?? 'unknown',
      ...(details && { details }),
    });
  }

  const content = data.choices?.[0]?.message?.content;
  if (!content) {
    throw new Error('Leere Antwort vom Modell. Bitte erneut versuchen.');
  }
  return content;
}

// ── Server-based per-call reconciliation ──────────────────────

// ── Consumption Report ────────────────────────────────────────

export interface ConsumptionTotals {
  promptTokens: number;
  completionTokens: number;
  totalTokens: number;
}

export interface DailyConsumption extends ConsumptionTotals {
  /** ISO date string (YYYY-MM-DD) */
  date: string;
}

export interface TenantConsumptionReport {
  tenantId: string;
  from: string;
  until: string;
  total: ConsumptionTotals;
  dailyConsumptions: DailyConsumption[];
}

/** Raw DTO shape returned by /v1/admin/tenants/{tenantId}/consumption. */
interface RawConsumptionResponse {
  tenantId: string;
  filters: { from: string; until: string };
  moduleConsumptionReports: Array<{
    moduleName?: string;
    chatCompletionConsumptionReportDto?: {
      total?: ConsumptionTotals;
      dailyConsumptions?: DailyConsumption[];
    };
  }>;
}

const CONSUMPTION_UNAVAILABLE_UNTIL_KEY = `${STORAGE_PREFIX}consumption_unavailable_until`;
const CONSUMPTION_RETRY_COOLDOWN_MS = 5 * 60 * 1000;

function getConsumptionUnavailableUntil(): number {
  try {
    const raw = sessionStorage.getItem(CONSUMPTION_UNAVAILABLE_UNTIL_KEY);
    const parsed = raw ? parseInt(raw, 10) : 0;
    return Number.isFinite(parsed) ? parsed : 0;
  } catch {
    return 0;
  }
}

function markConsumptionUnavailableNow(): void {
  try {
    sessionStorage.setItem(
      CONSUMPTION_UNAVAILABLE_UNTIL_KEY,
      String(Date.now() + CONSUMPTION_RETRY_COOLDOWN_MS),
    );
  } catch {
    // ignore
  }
}

function clearConsumptionUnavailableFlag(): void {
  try {
    sessionStorage.removeItem(CONSUMPTION_UNAVAILABLE_UNTIL_KEY);
  } catch {
    // ignore
  }
}

/**
 * Fetch the server-side token consumption report for the current tenant.
 *
 * Requires tenant-admin privileges. Used to reconcile locally estimated token
 * counts (recorded via {@link recordTokenUsage}) with authoritative server totals.
 *
 * @param from - ISO-8601 start datetime (inclusive)
 * @param until - ISO-8601 end datetime (exclusive)
 * @returns Flattened consumption report for the AI module, or `null` if the
 *          user is not permitted (403) or no AI consumption exists in the range.
 */
export async function fetchTenantConsumption(
  from: string,
  until: string,
): Promise<TenantConsumptionReport | null> {
  if (Date.now() < getConsumptionUnavailableUntil()) {
    return null;
  }

  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) return null;

  const toConsumptionDate = (value: string): string => {
    const parsed = new Date(value);
    if (Number.isNaN(parsed.getTime())) return value;
    return parsed.toISOString().slice(0, 10);
  };
  const fromDate = toConsumptionDate(from);
  const untilDate = toConsumptionDate(until);

  // V2-first consumption report.
  try {
    const resV2 = await fetchAiWithFallback(`/consumption?From=${encodeURIComponent(fromDate)}&Until=${encodeURIComponent(untilDate)}`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${token}`,
        'MFT-Tenant-Id': tenantId,
      },
    });
    if (resV2.ok) {
      clearConsumptionUnavailableFlag();
      const data = await resV2.json() as {
        inferenceConsumptionReport?: {
          total?: ConsumptionTotals;
          dailyConsumptions?: DailyConsumption[];
        };
      };
      const report = data.inferenceConsumptionReport;
      if (report) {
        return {
          tenantId,
          from,
          until,
          total: report.total ?? { promptTokens: 0, completionTokens: 0, totalTokens: 0 },
          dailyConsumptions: report.dailyConsumptions ?? [],
        };
      }
    }
  } catch (err) {
    console.warn('[fetchTenantConsumption] V2 consumption failed:', err);
  }

  // Legacy fallback for deployments that still expose admin consumption.
  const apiBase = getApiBase();
  const legacyUrl = `${apiBase}/v1/admin/tenants/${tenantId}/consumption?From=${encodeURIComponent(fromDate)}&Until=${encodeURIComponent(untilDate)}`;
  let legacyRes: Response;
  try {
    legacyRes = await fetch(legacyUrl, {
      headers: {
        Authorization: `Bearer ${token}`,
        'MFT-Tenant-Id': tenantId,
        'api-version': '1.0',
      },
    });
  } catch (err) {
    console.warn('[fetchTenantConsumption] Legacy consumption failed:', err);
    return null;
  }

  if (legacyRes.status === 403 || legacyRes.status === 401) {
    markConsumptionUnavailableNow();
    return null;
  }
  if (!legacyRes.ok) {
    markConsumptionUnavailableNow();
    return null;
  }

  const data: RawConsumptionResponse = await legacyRes.json();
  const aiModule = data.moduleConsumptionReports?.find((m) => m.chatCompletionConsumptionReportDto);
  const ai = aiModule?.chatCompletionConsumptionReportDto;
  if (!ai) {
    markConsumptionUnavailableNow();
    return null;
  }

  clearConsumptionUnavailableFlag();

  return {
    tenantId: data.tenantId,
    from: data.filters.from,
    until: data.filters.until,
    total: ai.total ?? { promptTokens: 0, completionTokens: 0, totalTokens: 0 },
    dailyConsumptions: ai.dailyConsumptions ?? [],
  };
}

// ── Tenant AI Configuration (daily limit) ─────────────────────

export interface TenantAiConfiguration {
  tenantId: string;
  /**
   * Tenant-specific daily token limit.
   * - A positive integer → tenant has a custom limit
   * - `-1` → tenant has no limit (unlimited)
   * - `null` → no tenant override; the platform-wide default applies (not
   *   exposed by the API, so callers fall back to a hardcoded value).
   */
  maxDailyTokens: number | null;
}

/**
 * Fetch the current tenant's AI configuration, primarily to learn its
 * daily token limit (`maxDailyTokens`). Returns null on network / 403 /
 * malformed-response errors so callers can fall back to the hardcoded default.
 */
export async function fetchTenantAiConfiguration(): Promise<TenantAiConfiguration | null> {
  const token = await getValidToken();
  const tenantId = getStoredTenantId();
  if (!tenantId) return null;

  let res: Response;
  try {
    res = await fetchAiWithFallback('/configuration', {
      headers: {
        Authorization: `Bearer ${token}`,
        'MFT-Tenant-Id': tenantId,
      },
    });
  } catch (err) {
    console.warn('[fetchTenantAiConfiguration] Netzwerkfehler:', err);
    return null;
  }

  if (!res.ok) return null;
  try {
    const data = await res.json() as { tenantId: string; maxDailyTokens?: number | null };
    return {
      tenantId: data.tenantId,
      maxDailyTokens: data.maxDailyTokens ?? null,
    };
  } catch {
    return null;
  }
}

/**
 * Convenience wrapper: fetch today's consumption (UTC midnight → tomorrow UTC midnight).
 */
export async function fetchTodaysConsumption(): Promise<TenantConsumptionReport | null> {
  const now = new Date();
  const start = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
  const end = new Date(start.getTime() + 24 * 60 * 60 * 1000);
  return fetchTenantConsumption(start.toISOString(), end.toISOString());
}
