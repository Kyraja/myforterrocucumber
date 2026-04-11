/**
 * @module SettingsPanel
 * Slide-in settings panel for configuring AI credentials, models, parse profiles, and prompts.
 *
 * Key responsibilities:
 * - Handles myforterro OAuth login/logout and tenant selection via the myforterroApi library.
 * - Exposes model selection for both native and OpenRouter models.
 * - Manages parse profiles (create, import, export, activate) and per-profile custom action patterns.
 * - Provides overrideable system prompts for Gherkin generation, table identification, rating,
 *   quick/deep tests, and FOP agent calls; shows defaults as placeholders.
 * - Can run in always-open mode (alwaysOpen prop) for the initial login screen.
 * @prop {boolean} loggedIn - Whether the user is currently authenticated.
 * @prop {(loggedIn: boolean) => void} onLoginChange - Callback fired on login state change.
 * @prop {string} model - Currently selected AI model identifier.
 * @prop {(model: string) => void} onModelChange - Callback fired when the model selection changes.
 */
import { useState, useRef, useEffect } from 'react';
import type { ParseProfile, CustomActionPattern } from '../../types/gherkin';
import {
  setModel as saveModel,
  getCustomSystemPrompt, setCustomSystemPrompt, clearCustomSystemPrompt,
  getCustomTableIdPrompt, setCustomTableIdPrompt, clearCustomTableIdPrompt,
  getCustomRatingPrompt, setCustomRatingPrompt, clearCustomRatingPrompt,
  getTemperature, setTemperature as saveTemperature,
  isOpenRouterEnabled, setOpenRouterEnabled,
  getOpenRouterKey, setOpenRouterKey,
  getOpenRouterModel, setOpenRouterModel,
  getExperimentalFeatures, setExperimentalFeatures,
  getForceKiTableId, setForceKiTableId,
  getTestDepth, setTestDepth, type TestDepth,
  getDeepTestMaxRounds, setDeepTestMaxRounds as setDeepTestMaxRoundsSetting,
  isKnowledgeBaseEnabled, setKnowledgeBaseEnabled,
  getKBMaxChunks, setKBMaxChunks as setKBMaxChunksSetting,
  isKBChainsEnabled, setKBChainsEnabled,
  isKBActionsEnabled, setKBActionsEnabled,
  isKBEventsEnabled, setKBEventsEnabled,
  getCustomFieldRules, setCustomFieldRules as setCustomFieldRulesSetting, clearCustomFieldRules as clearCustomFieldRulesSetting,
  getCustomQuickTestPrompt, setCustomQuickTestPrompt as setCustomQuickTestSetting, clearCustomQuickTestPrompt as clearCustomQuickTestSetting,
  getCustomDeepTestPrompt, setCustomDeepTestPrompt as setCustomDeepTestSetting, clearCustomDeepTestPrompt as clearCustomDeepTestSetting,
  getCustomFopAnalystPrompt, setCustomFopAnalystPrompt, clearCustomFopAnalystPrompt,
  getCustomFopGuidelinesPrompt, setCustomFopGuidelinesPrompt, clearCustomFopGuidelinesPrompt,
} from '../../lib/settings';
import { DEFAULT_SYSTEM_PROMPT, DEFAULT_TABLE_ID_PROMPT, DEFAULT_RATING_PROMPT, getDefaultFieldRules, getDefaultQuickTestPrompt, getDefaultDeepTestPrompt } from '../../lib/aiPrompt';
import { buildFopAnalystPrompt, buildFopGuidelinesPrompt } from '../../lib/fopAgentPrompt';
import {
  initiateLogin,
  logout,
  getStoredUserDisplay,
  getStoredClientId,
  getStoredApplicationId,
  listModels,
  getStoredTenantId,
  setStoredTenantId,
  getStoredTenants,
  setStoredTenants,
  setTokenUrl,
  setApiBase,
  getAuthorizeUrl,
  setAuthorizeUrl,
  listTenants,
  getStoredClientSecret,
} from '../../lib/myforterroApi';
import type { MftTenant, MftModel } from '../../lib/myforterroApi';
import {
  DEFAULT_PARSE_PROFILE,
  loadProfiles,
  saveProfiles,
  getActiveProfileId,
  setActiveProfileId,
  exportProfileAsJson,
  parseProfileFromJson,
  createNewProfile,
} from '../../lib/parseProfile';
import { listOpenRouterModels, type OpenRouterModel } from '../../lib/openrouter';
import { useTranslation, type TranslationFn } from '../../i18n';
import styles from './SettingsPanel.module.css';

interface SettingsPanelProps {
  loggedIn: boolean;
  onLoginChange: (loggedIn: boolean) => void;
  model: string;
  onModelChange: (model: string) => void;
  onSystemPromptChange?: () => void;
  /** When true, the panel is always visible without a toggle button (login screen). */
  alwaysOpen?: boolean;
}

export function SettingsPanel({ loggedIn, onLoginChange, model, onModelChange, onSystemPromptChange, alwaysOpen = false }: SettingsPanelProps) {
  const { t, lang } = useTranslation();
  const [open, setOpen] = useState(false);
  const [settingsTab, setSettingsTab] = useState<'model' | 'general' | 'prompts'>('model');

  const [clientId, setClientId] = useState(() => getStoredClientId());
  const [clientSecret, setClientSecret] = useState(() => getStoredClientSecret());
  const [applicationId, setApplicationId] = useState(() => getStoredApplicationId());
  const [loginError, setLoginError] = useState<string | null>(null);
  const [loginLoading, setLoginLoading] = useState(false);

  // Tenant state
  const [tenants, setTenants] = useState<MftTenant[]>(() => getStoredTenants());
  const [selectedTenantId, setSelectedTenantId] = useState(() => getStoredTenantId() || '');
  const [manualTenantId, setManualTenantId] = useState('');

  // Model state
  const [models, setModels] = useState<MftModel[]>([]);
  const [modelsLoading, setModelsLoading] = useState(false);
  const [modelsError, setModelsError] = useState<string | null>(null);

  // Temperature
  const [temperature, setTemperatureState] = useState(() => getTemperature());

  // OpenRouter (DEV fallback)
  const [orEnabled, setOrEnabled] = useState(() => isOpenRouterEnabled());
  const [orKey, setOrKey] = useState(() => getOpenRouterKey() || '');
  const [orModel, setOrModel] = useState(() => getOpenRouterModel());
  const [orModels, setOrModels] = useState<OpenRouterModel[]>([]);
  const [orModelsLoading, setOrModelsLoading] = useState(false);
  const [orModelsError, setOrModelsError] = useState<string | null>(null);

  // Advanced settings
  const [advancedOpen, setAdvancedOpen] = useState(false);
  const [authorizeUrlInput, setAuthorizeUrlInput] = useState('');
  const [tokenUrlInput, setTokenUrlInput] = useState('');
  const [apiBaseInput, setApiBaseInput] = useState('');

  // Prompt state — Generation
  const [promptOpen, setPromptOpen] = useState(false);
  const [promptText, setPromptText] = useState(() => getCustomSystemPrompt() || DEFAULT_SYSTEM_PROMPT);
  const [promptCustomized, setPromptCustomized] = useState(() => !!getCustomSystemPrompt());

  // Prompt state — Table identification
  const [tableIdPromptOpen, setTableIdPromptOpen] = useState(false);
  const [tableIdPromptText, setTableIdPromptText] = useState(() => getCustomTableIdPrompt() || DEFAULT_TABLE_ID_PROMPT);
  const [tableIdPromptCustomized, setTableIdPromptCustomized] = useState(() => !!getCustomTableIdPrompt());

  // Prompt state — Rating
  const [ratingPromptOpen, setRatingPromptOpen] = useState(false);
  const [ratingPromptText, setRatingPromptText] = useState(() => getCustomRatingPrompt() || DEFAULT_RATING_PROMPT);
  const [ratingPromptCustomized, setRatingPromptCustomized] = useState(() => !!getCustomRatingPrompt());

  // Force KI table identification
  const [forceKiTableId, setForceKiTableIdState] = useState(() => getForceKiTableId());
  const [testDepthState, setTestDepthState] = useState<TestDepth>(() => getTestDepth());
  const [deepTestRounds, setDeepTestRoundsState] = useState(() => getDeepTestMaxRounds());

  // Knowledge Base
  const [kbEnabled, setKbEnabledState] = useState(() => isKnowledgeBaseEnabled());
  const [kbMaxChunks, setKbMaxChunksState] = useState(() => getKBMaxChunks());
  const [kbChains, setKbChainsState] = useState(() => isKBChainsEnabled());
  const [kbActions, setKbActionsState] = useState(() => isKBActionsEnabled());
  const [kbEvents, setKbEventsState] = useState(() => isKBEventsEnabled());

  const currentLang = lang as 'de' | 'en';

  const [fieldRulesOpen, setFieldRulesOpen] = useState(false);
  const [fieldRulesText, setFieldRulesText] = useState(() => getCustomFieldRules(currentLang) || getDefaultFieldRules(currentLang));
  const [fieldRulesCustomized, setFieldRulesCustomized] = useState(() => !!getCustomFieldRules(currentLang));

  const [quickTestOpen, setQuickTestOpen] = useState(false);
  const [quickTestText, setQuickTestText] = useState(() => getCustomQuickTestPrompt(currentLang) || getDefaultQuickTestPrompt(currentLang));
  const [quickTestCustomized, setQuickTestCustomized] = useState(() => !!getCustomQuickTestPrompt(currentLang));

  const [deepTestOpen, setDeepTestOpen] = useState(false);
  const [deepTestText, setDeepTestText] = useState(() => getCustomDeepTestPrompt(currentLang) || getDefaultDeepTestPrompt(currentLang));
  const [deepTestCustomized, setDeepTestCustomized] = useState(() => !!getCustomDeepTestPrompt(currentLang));

  // Reload prompt texts when language changes
  useEffect(() => {
    setFieldRulesText(getCustomFieldRules(currentLang) || getDefaultFieldRules(currentLang));
    setFieldRulesCustomized(!!getCustomFieldRules(currentLang));
    setQuickTestText(getCustomQuickTestPrompt(currentLang) || getDefaultQuickTestPrompt(currentLang));
    setQuickTestCustomized(!!getCustomQuickTestPrompt(currentLang));
    setDeepTestText(getCustomDeepTestPrompt(currentLang) || getDefaultDeepTestPrompt(currentLang));
    setDeepTestCustomized(!!getCustomDeepTestPrompt(currentLang));
  }, [currentLang]);
  const handleForceKiToggle = () => {
    const next = !forceKiTableId;
    setForceKiTableIdState(next);
    setForceKiTableId(next);
  };

  // Experimental features
  const [experimentalFeatures, setExperimentalFeaturesState] = useState(() => getExperimentalFeatures());

  // FOP agent prompts (only relevant when experimentalFeatures=true)
  const [fopAnalystOpen, setFopAnalystOpen] = useState(false);
  const [fopAnalystText, setFopAnalystText] = useState(
    () => getCustomFopAnalystPrompt() || buildFopAnalystPrompt(lang as 'de' | 'en'),
  );
  const [fopAnalystCustomized, setFopAnalystCustomized] = useState(() => !!getCustomFopAnalystPrompt());

  const [fopGuidelinesOpen, setFopGuidelinesOpen] = useState(false);
  const [fopGuidelinesText, setFopGuidelinesText] = useState(
    () => getCustomFopGuidelinesPrompt() || buildFopGuidelinesPrompt(lang as 'de' | 'en'),
  );
  const [fopGuidelinesCustomized, setFopGuidelinesCustomized] = useState(() => !!getCustomFopGuidelinesPrompt());

  const handleFopAnalystSave = () => {
    const trimmed = fopAnalystText.trim();
    if (trimmed === buildFopAnalystPrompt(lang as 'de' | 'en').trim()) {
      clearCustomFopAnalystPrompt();
      setFopAnalystCustomized(false);
    } else {
      setCustomFopAnalystPrompt(trimmed);
      setFopAnalystCustomized(true);
    }
  };
  const handleFopAnalystReset = () => {
    clearCustomFopAnalystPrompt();
    setFopAnalystText(buildFopAnalystPrompt(lang as 'de' | 'en'));
    setFopAnalystCustomized(false);
  };

  const handleFopGuidelinesSave = () => {
    const trimmed = fopGuidelinesText.trim();
    if (trimmed === buildFopGuidelinesPrompt(lang as 'de' | 'en').trim()) {
      clearCustomFopGuidelinesPrompt();
      setFopGuidelinesCustomized(false);
    } else {
      setCustomFopGuidelinesPrompt(trimmed);
      setFopGuidelinesCustomized(true);
    }
  };
  const handleFopGuidelinesReset = () => {
    clearCustomFopGuidelinesPrompt();
    setFopGuidelinesText(buildFopGuidelinesPrompt(lang as 'de' | 'en'));
    setFopGuidelinesCustomized(false);
  };

  const handleExperimentalToggle = () => {
    const next = !experimentalFeatures;
    setExperimentalFeaturesState(next);
    setExperimentalFeatures(next);
    // Reload page so the new tab appears / disappears
    window.location.reload();
  };

  // Profile state
  const [profileOpen, setProfileOpen] = useState(false);
  const [profiles, setProfiles] = useState(() => loadProfiles());
  const [activeId, setActiveId] = useState(() => getActiveProfileId());
  const [editProfile, setEditProfile] = useState<ParseProfile | null>(null);
  const profileFileRef = useRef<HTMLInputElement>(null);

  const allProfiles = [DEFAULT_PARSE_PROFILE, ...profiles];
  const selectedProfile = allProfiles.find((p) => p.id === activeId) ?? DEFAULT_PARSE_PROFILE;

  // When login state changes (e.g. after OAuth callback), try to load tenants
  useEffect(() => {
    if (loggedIn && tenants.length === 0) {
      (async () => {
        try {
          const t = await listTenants();
          if (t.length > 0) {
            setTenants(t);
            setStoredTenants(t);
            if (!selectedTenantId) {
              const firstTenant = t[0].tenantId;
              setSelectedTenantId(firstTenant);
              setStoredTenantId(firstTenant);
            }
          }
        } catch {
          // Tenant listing not available — user can enter tenant ID manually
        }
      })();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [loggedIn]);

  // Load models when tenant changes
  useEffect(() => {
    if (loggedIn && selectedTenantId) {
      loadModels();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [loggedIn, selectedTenantId]);

  async function loadModels() {
    setModelsLoading(true);
    setModelsError(null);
    try {
      const m = await listModels();
      setModels(m);
      // If current model is not in list, select first available
      if (m.length > 0 && !m.find((mod) => mod.id === model)) {
        const firstId = m[0].id;
        saveModel(firstId);
        onModelChange(firstId);
      }
    } catch (err) {
      setModelsError(err instanceof Error ? err.message : t('settings.loadModelsError'));
    } finally {
      setModelsLoading(false);
    }
  }

  const handleLogin = async () => {
    if (!clientId.trim()) return;
    setLoginLoading(true);
    setLoginError(null);

    try {
      // Save advanced settings before login
      if (authorizeUrlInput.trim()) setAuthorizeUrl(authorizeUrlInput.trim());
      if (tokenUrlInput.trim()) setTokenUrl(tokenUrlInput.trim());
      if (apiBaseInput.trim()) setApiBase(apiBaseInput.trim());

      // Initiate OAuth Authorization Code flow — will redirect the browser
      await initiateLogin(clientId.trim(), applicationId.trim(), clientSecret.trim() || undefined);
      // (browser redirects — code below won't execute)
    } catch (err) {
      setLoginError(err instanceof Error ? err.message : t('settings.loginError'));
      setLoginLoading(false);
    }
  };

  const handleLogout = () => {
    logout();
    setTenants([]);
    setModels([]);
    setSelectedTenantId('');
    // clientId, clientSecret, applicationId are intentionally kept
    // so the login form is pre-filled on next login.
    onLoginChange(false);
  };

  const handleTenantChange = (tenantId: string) => {
    setSelectedTenantId(tenantId);
    setStoredTenantId(tenantId);
    // Models will reload via useEffect
  };

  const handleManualTenant = () => {
    if (manualTenantId.trim()) {
      handleTenantChange(manualTenantId.trim());
      setManualTenantId('');
    }
  };

  const handleModelChange = (id: string) => {
    saveModel(id);
    onModelChange(id);
    // OpenAI models only support temperature 1
    const selected = models.find((m) => m.id === id);
    if (selected?.owned_by === 'openai') {
      setTemperatureState(1);
      saveTemperature(1);
    }
  };

  const handlePromptSave = () => {
    const trimmed = promptText.trim();
    if (trimmed === DEFAULT_SYSTEM_PROMPT.trim()) {
      clearCustomSystemPrompt();
      setPromptCustomized(false);
    } else {
      setCustomSystemPrompt(trimmed);
      setPromptCustomized(true);
    }
    onSystemPromptChange?.();
  };

  const handlePromptReset = () => {
    setPromptText(DEFAULT_SYSTEM_PROMPT);
    clearCustomSystemPrompt();
    setPromptCustomized(false);
    onSystemPromptChange?.();
  };

  // Table-identification prompt handlers
  const handleTableIdPromptSave = () => {
    const trimmed = tableIdPromptText.trim();
    if (trimmed === DEFAULT_TABLE_ID_PROMPT.trim()) {
      clearCustomTableIdPrompt();
      setTableIdPromptCustomized(false);
    } else {
      setCustomTableIdPrompt(trimmed);
      setTableIdPromptCustomized(true);
    }
  };

  const handleTableIdPromptReset = () => {
    setTableIdPromptText(DEFAULT_TABLE_ID_PROMPT);
    clearCustomTableIdPrompt();
    setTableIdPromptCustomized(false);
  };

  // Rating prompt handlers
  const handleRatingPromptSave = () => {
    const trimmed = ratingPromptText.trim();
    if (trimmed === DEFAULT_RATING_PROMPT.trim()) {
      clearCustomRatingPrompt();
      setRatingPromptCustomized(false);
    } else {
      setCustomRatingPrompt(trimmed);
      setRatingPromptCustomized(true);
    }
  };

  const handleRatingPromptReset = () => {
    setRatingPromptText(DEFAULT_RATING_PROMPT);
    clearCustomRatingPrompt();
    setRatingPromptCustomized(false);
  };

  // ── Profile handlers ───────────────────────────────────────

  const handleProfileSelect = (id: string) => {
    setActiveId(id);
    setActiveProfileId(id);
    setEditProfile(null);
  };

  const handleNewProfile = () => {
    const name = prompt(t('settings.profileNewName'), t('settings.profileNewDefault'));
    if (!name?.trim()) return;
    const newP = createNewProfile(name.trim());
    const updated = [...profiles, newP];
    setProfiles(updated);
    saveProfiles(updated);
    setActiveId(newP.id);
    setActiveProfileId(newP.id);
    setEditProfile(newP);
  };

  const handleImportProfile = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const text = await file.text();
    const imported = parseProfileFromJson(text);
    if (!imported) {
      alert(t('settings.profileInvalid'));
      return;
    }
    const updated = [...profiles, imported];
    setProfiles(updated);
    saveProfiles(updated);
    setActiveId(imported.id);
    setActiveProfileId(imported.id);
    if (profileFileRef.current) profileFileRef.current.value = '';
  };

  const handleExportProfile = () => {
    exportProfileAsJson(selectedProfile);
  };

  const handleDeleteProfile = () => {
    if (activeId === 'default') return;
    const updated = profiles.filter((p) => p.id !== activeId);
    setProfiles(updated);
    saveProfiles(updated);
    setActiveId('default');
    setActiveProfileId('default');
    setEditProfile(null);
  };

  const handleEditToggle = () => {
    if (editProfile) {
      setEditProfile(null);
    } else {
      setEditProfile(structuredClone(selectedProfile));
    }
  };

  const handleSaveProfile = () => {
    if (!editProfile || editProfile.id === 'default') return;
    const updated = profiles.map((p) => (p.id === editProfile.id ? editProfile : p));
    setProfiles(updated);
    saveProfiles(updated);
    setEditProfile(null);
  };

  const storedUserDisplay = getStoredUserDisplay();
  const currentModelLabel = models.find((m) => m.id === model)?.id ?? model;
  const toggleLabel = loggedIn
    ? (currentModelLabel ? `${currentModelLabel} \u2713` : t('settings.aiSettings'))
    : t('settings.notLoggedIn');

  return (
    <div className={alwaysOpen ? undefined : styles.container}>
      {!alwaysOpen && (
        <button
          className={`${styles.toggle} ${loggedIn ? styles.toggleActive : ''}`}
          onClick={() => setOpen(!open)}
          type="button"
        >
          {toggleLabel}
        </button>
      )}

      {(alwaysOpen || open) && (
        <div className={alwaysOpen ? undefined : styles.panel}>
          {/* ── Login / Logout Section ─────────────────────── */}
          <div className={styles.section}>
            <span className={styles.sectionLabel}>{t('settings.aiSettings')}</span>

            {loggedIn ? (
              <div className={styles.savedState}>
                <span className={styles.savedText}>
                  {storedUserDisplay ? `${t('settings.loggedInAs')} ${storedUserDisplay}` : t('settings.loggedInAs')}
                </span>
                <button className={styles.clearBtn} onClick={handleLogout} type="button">
                  {t('settings.logout')}
                </button>
              </div>
            ) : (
              <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                {/* ── MyForterro Login (Authorization Code + PKCE) ── */}
                <>
                    <label style={{ fontSize: '0.7rem', color: 'var(--color-text-muted)', display: 'flex', alignItems: 'center', gap: '4px' }}>
                      {t('settings.clientIdLabel')}
                      <span
                        title={t('settings.clientIdHint')}
                        style={{ cursor: 'help', fontSize: '0.65rem', color: 'var(--color-primary)', fontWeight: 700, border: '1px solid var(--color-primary)', borderRadius: '50%', width: '14px', height: '14px', display: 'inline-flex', alignItems: 'center', justifyContent: 'center' }}
                      >?</span>
                    </label>
                    <input
                      className={styles.input}
                      type="text"
                      value={clientId}
                      onChange={(e) => setClientId(e.target.value)}
                      onKeyDown={(e) => e.key === 'Enter' && handleLogin()}
                      placeholder={t('settings.clientIdLabel')}
                      aria-label={t('settings.clientIdLabel')}
                    />
                    <label style={{ fontSize: '0.7rem', color: 'var(--color-text-muted)', display: 'flex', alignItems: 'center', gap: '4px' }}>
                      {t('settings.applicationId')}
                      <span
                        title={t('settings.applicationIdHint')}
                        style={{ cursor: 'help', fontSize: '0.65rem', color: 'var(--color-primary)', fontWeight: 700, border: '1px solid var(--color-primary)', borderRadius: '50%', width: '14px', height: '14px', display: 'inline-flex', alignItems: 'center', justifyContent: 'center' }}
                      >?</span>
                    </label>
                    <input
                      className={styles.input}
                      type="text"
                      value={applicationId}
                      onChange={(e) => setApplicationId(e.target.value)}
                      onKeyDown={(e) => e.key === 'Enter' && handleLogin()}
                      placeholder={t('settings.applicationIdHint')}
                      aria-label={t('settings.applicationId')}
                    />

                    <button
                      className={styles.saveBtn}
                      onClick={handleLogin}
                      type="button"
                      disabled={loginLoading || !clientId.trim()}
                    >
                      {loginLoading ? t('settings.redirecting') : t('settings.authorize')}
                    </button>

                    {loginError && (
                      <span style={{ fontSize: '0.8rem', color: 'var(--color-danger)' }}>{loginError}</span>
                    )}

                    {/* Advanced settings */}
                    <button
                      className={styles.promptToggle}
                      onClick={() => setAdvancedOpen(!advancedOpen)}
                      type="button"
                      style={{ marginTop: '4px' }}
                    >
                      <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                        {t('settings.advanced')}
                      </span>
                      <span className={styles.promptArrow}>{advancedOpen ? '\u25B2' : '\u25BC'}</span>
                    </button>

                    {advancedOpen && (
                      <div style={{ display: 'flex', flexDirection: 'column', gap: '4px', fontSize: '0.8rem' }}>
                        <label style={{ fontSize: '0.7rem', color: 'var(--color-text-muted)' }}>
                          {t('settings.clientSecret')}
                        </label>
                        <input
                          className={styles.input}
                          type="password"
                          value={clientSecret}
                          onChange={(e) => setClientSecret(e.target.value)}
                          placeholder={t('settings.clientSecretHint')}
                          style={{ fontSize: '0.75rem' }}
                        />
                        <label style={{ fontSize: '0.7rem', color: 'var(--color-text-muted)', marginTop: '4px' }}>
                          {t('settings.authorizeUrl')}
                        </label>
                        <input
                          className={styles.input}
                          type="text"
                          value={authorizeUrlInput}
                          onChange={(e) => setAuthorizeUrlInput(e.target.value)}
                          placeholder={getAuthorizeUrl()}
                          style={{ fontSize: '0.75rem' }}
                        />
                        <label style={{ fontSize: '0.7rem', color: 'var(--color-text-muted)', marginTop: '4px' }}>
                          {t('settings.tokenUrl')}
                        </label>
                        <input
                          className={styles.input}
                          type="text"
                          value={tokenUrlInput}
                          onChange={(e) => setTokenUrlInput(e.target.value)}
                          placeholder="/mft-auth/connect/token"
                          style={{ fontSize: '0.75rem' }}
                        />
                        <label style={{ fontSize: '0.7rem', color: 'var(--color-text-muted)', marginTop: '4px' }}>
                          {t('settings.apiBaseUrl')}
                        </label>
                        <input
                          className={styles.input}
                          type="text"
                          value={apiBaseInput}
                          onChange={(e) => setApiBaseInput(e.target.value)}
                          placeholder="/mft-api"
                          style={{ fontSize: '0.75rem' }}
                        />
                      </div>
                    )}
                  </>
              </div>
            )}
          </div>

          {/* ── Settings Tabs ─────────────────────────────────── */}
          <div className={styles.settingsTabs}>
            {(['model', 'general', 'prompts'] as const).map(tab => (
              <button
                key={tab}
                type="button"
                className={`${styles.settingsTab} ${settingsTab === tab ? styles.settingsTabActive : ''}`}
                onClick={() => setSettingsTab(tab)}
              >
                {tab === 'model' ? (lang === 'de' ? 'Modell & Login' : 'Model & Login')
                  : tab === 'general' ? (lang === 'de' ? 'Einstellungen' : 'Settings')
                  : (lang === 'de' ? 'Prompts' : 'Prompts')}
              </button>
            ))}
          </div>

          {/* ── TAB: Model & Login ──────────────────────────────── */}
          {settingsTab === 'model' && <>
          {/* ── Tenant Section ──────────────────────────────────── */}
          {loggedIn && (
            <>
              <div className={styles.divider} />
              <div className={styles.section}>
                <span className={styles.sectionLabel}>{t('settings.tenant')}</span>
                {tenants.length > 0 ? (
                  <select
                    style={{
                      padding: '6px 10px',
                      border: '1px solid var(--color-border)',
                      borderRadius: 'var(--radius)',
                      fontSize: '0.85rem',
                      background: 'var(--color-surface)',
                    }}
                    value={selectedTenantId}
                    onChange={(e) => handleTenantChange(e.target.value)}
                  >
                    <option value="">-- {t('settings.tenant')} --</option>
                    {tenants.map((ten) => (
                      <option key={ten.tenantId} value={ten.tenantId}>
                        {ten.slug || ten.tenantId}
                      </option>
                    ))}
                  </select>
                ) : (
                  <div className={styles.inputState}>
                    <input
                      className={styles.input}
                      type="text"
                      value={manualTenantId}
                      onChange={(e) => setManualTenantId(e.target.value)}
                      onKeyDown={(e) => e.key === 'Enter' && handleManualTenant()}
                      placeholder={t('settings.tenantIdManual')}
                    />
                    <button className={styles.saveBtn} onClick={handleManualTenant} type="button">
                      OK
                    </button>
                  </div>
                )}
                {selectedTenantId && tenants.length === 0 && (
                  <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                    {t('settings.tenantDisplay', { tenantId: selectedTenantId })}
                  </span>
                )}
              </div>
            </>
          )}

          {/* ── Model Section ── */}
          {loggedIn && selectedTenantId && (
            <>
              <div className={styles.divider} />
              <div className={styles.section}>
                <span className={styles.sectionLabel}>{t('settings.model')}</span>
                {modelsLoading ? (
                  <span style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>
                    {t('settings.loadingModels')}
                  </span>
                ) : modelsError ? (
                  <span style={{ fontSize: '0.8rem', color: 'var(--color-danger)' }}>{modelsError}</span>
                ) : models.length > 0 ? (
                  <div className={styles.modelList}>
                    {models.map((m) => (
                      <label key={m.id} className={`${styles.modelOption} ${m.id === model ? styles.modelOptionActive : ''}`}>
                        <input
                          type="radio"
                          name="model"
                          value={m.id}
                          checked={m.id === model}
                          onChange={() => handleModelChange(m.id)}
                          className={styles.modelRadio}
                        />
                        <span className={styles.modelLabel}>{m.id}</span>
                        <span className={styles.modelDesc}>{m.owned_by}</span>
                      </label>
                    ))}
                  </div>
                ) : (
                  <span style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>
                    {t('settings.noModels')}
                  </span>
                )}
              </div>

              {/* ── Temperature ─────────────────────────────── */}
              {(() => {
                const selectedModel = models.find((m) => m.id === model);
                const isOpenAI = selectedModel?.owned_by === 'openai';
                return (
                  <div className={styles.section}>
                    <label className={styles.sectionLabel}>
                      Temperature: {temperature.toFixed(1)}
                    </label>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                      <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>0</span>
                      <input
                        type="range"
                        min="0"
                        max="2"
                        step="0.1"
                        value={temperature}
                        disabled={isOpenAI}
                        onChange={(e) => {
                          const val = parseFloat(e.target.value);
                          setTemperatureState(val);
                          saveTemperature(val);
                        }}
                        style={{ flex: 1, opacity: isOpenAI ? 0.5 : 1 }}
                      />
                      <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>2</span>
                    </div>
                    <span style={{ fontSize: '0.7rem', color: 'var(--color-text-muted)' }}>
                      {isOpenAI
                        ? (lang === 'de' ? 'OpenAI-Modelle unterstützen nur Temperature 1' : 'OpenAI models only support temperature 1')
                        : (lang === 'de' ? 'Niedrig = präziser, Hoch = kreativer' : 'Low = more precise, High = more creative')}
                    </span>
                  </div>
                );
              })()}
            </>
          )}

          {/* ── OpenRouter Fallback ───────────────────── */}
          <div className={styles.section} style={{ border: '1px dashed var(--color-primary)', padding: '8px', borderRadius: '6px' }}>
            <label className={styles.sectionLabel} style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
              <input
                type="checkbox"
                checked={orEnabled}
                onChange={(e) => {
                  setOrEnabled(e.target.checked);
                  setOpenRouterEnabled(e.target.checked);
                }}
              />
              OpenRouter Fallback
            </label>
            <span style={{ fontSize: '0.7rem', color: 'var(--color-text-muted)' }}>
              {lang === 'de'
                ? 'Fallback wenn MyForterro nicht verfuegbar ist (kein Tenant, Token abgelaufen, Limit erreicht). Nutzt deinen persoenlichen API Key.'
                : 'Fallback when MyForterro is unavailable (no tenant, token expired, limit reached). Uses your personal API key.'}
            </span>
            {orEnabled && (
              <div style={{ display: 'flex', flexDirection: 'column', gap: '4px', marginTop: '4px' }}>
                <input
                  className={styles.input}
                  type="password"
                  placeholder="OpenRouter API Key (sk-or-...)"
                  value={orKey}
                  onChange={(e) => {
                    setOrKey(e.target.value);
                    setOpenRouterKey(e.target.value);
                  }}
                />
                <div style={{ display: 'flex', gap: '4px', alignItems: 'center' }}>
                  <select
                    className={styles.input}
                    value={orModel}
                    onChange={(e) => {
                      setOrModel(e.target.value);
                      setOpenRouterModel(e.target.value);
                    }}
                    style={{ flex: 1 }}
                  >
                    <option value="">-- {lang === 'de' ? 'Modell waehlen' : 'Select model'} --</option>
                    <optgroup label={lang === 'de' ? 'Empfohlen' : 'Recommended'}>
                      <option value="anthropic/claude-sonnet-4.6">Claude Sonnet 4.6 (1M ctx)</option>
                      <option value="anthropic/claude-opus-4.6">Claude Opus 4.6 (1M ctx)</option>
                      <option value="google/gemini-3-flash-preview">Gemini 3 Flash Preview (1M ctx)</option>
                      <option value="google/gemini-3.1-flash-lite-preview">Gemini 3.1 Flash Lite Preview (1M ctx)</option>
                      <option value="moonshotai/kimi-k2.5">Kimi K2.5 (262K ctx)</option>
                    </optgroup>
                    {orModels.length > 0 && (
                      <optgroup label={lang === 'de' ? 'Alle Modelle' : 'All models'}>
                        {orModels.map((m) => (
                          <option key={m.id} value={m.id}>
                            {m.name} ({m.id})
                          </option>
                        ))}
                      </optgroup>
                    )}
                  </select>
                  <button
                    type="button"
                    className={styles.clearBtn}
                    disabled={!orKey || orModelsLoading}
                    onClick={async () => {
                      setOrModelsLoading(true);
                      setOrModelsError(null);
                      try {
                        const list = await listOpenRouterModels(orKey);
                        setOrModels(list);
                      } catch (err) {
                        setOrModelsError(err instanceof Error ? err.message : 'Fehler');
                      } finally {
                        setOrModelsLoading(false);
                      }
                    }}
                  >
                    {orModelsLoading ? '...' : (lang === 'de' ? 'Laden' : 'Load')}
                  </button>
                </div>
                {orModelsError && (
                  <span style={{ fontSize: '0.7rem', color: 'var(--color-error, red)' }}>{orModelsError}</span>
                )}
                {!orModel && orModels.length > 0 && (
                  <span style={{ fontSize: '0.7rem', color: 'var(--color-warning, orange)' }}>
                    {lang === 'de' ? 'Bitte ein Modell auswaehlen' : 'Please select a model'}
                  </span>
                )}
              </div>
            )}
          </div>

          </>}

          {/* ── TAB: General Settings ──────────────────────────── */}
          {settingsTab === 'general' && <>

          {/* ── Force KI Table Identification ────────────── */}
          <div className={styles.section}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 0' }}>
              <div>
                <span className={styles.sectionLabel} style={{ fontSize: '0.8rem' }}>
                  🤖 {lang === 'de' ? 'Immer KI für Tabellenerkennung' : 'Always use AI for table detection'}
                </span>
                <p style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', margin: '2px 0 0' }}>
                  {lang === 'de'
                    ? 'Überspringt lokale V/P-Notation-Erkennung — KI identifiziert Tabellen immer selbst'
                    : 'Skips local V/P-notation detection — AI always identifies tables'}
                </p>
              </div>
              <button
                onClick={handleForceKiToggle}
                type="button"
                style={{
                  padding: '2px 10px',
                  fontSize: '0.75rem',
                  borderRadius: 'var(--radius)',
                  border: '1px solid var(--color-border)',
                  background: forceKiTableId ? 'var(--color-primary)' : 'var(--color-surface)',
                  color: forceKiTableId ? 'white' : 'var(--color-text-muted)',
                  cursor: 'pointer',
                  flexShrink: 0,
                  marginLeft: 12,
                }}
              >
                {forceKiTableId
                  ? (lang === 'de' ? 'AN' : 'ON')
                  : (lang === 'de' ? 'AUS' : 'OFF')}
              </button>
            </div>
          </div>

          <div className={styles.divider} />

          {/* ── Test Depth ─────────────── */}
          <div className={styles.section}>
            <span className={styles.sectionLabel} style={{ fontSize: '0.8rem', textTransform: 'uppercase', letterSpacing: '0.03em' }}>
              🧪 {lang === 'de' ? 'Testtiefe' : 'Test Depth'}
            </span>
            <div style={{ display: 'flex', gap: 0, marginTop: 6 }}>
              <button
                type="button"
                onClick={() => { setTestDepthState('quick'); setTestDepth('quick'); }}
                style={{
                  flex: 1, padding: '6px 12px', fontSize: '0.75rem', cursor: 'pointer',
                  border: '1.5px solid var(--color-border)', borderRight: 'none',
                  borderRadius: '6px 0 0 6px',
                  background: testDepthState === 'quick' ? 'var(--color-primary)' : 'none',
                  color: testDepthState === 'quick' ? 'white' : 'var(--color-text-muted)',
                  fontWeight: testDepthState === 'quick' ? 600 : 400,
                }}
              >
                {lang === 'de' ? 'Schnelltest' : 'Quick Test'}
              </button>
              <button
                type="button"
                onClick={() => { setTestDepthState('deep'); setTestDepth('deep'); }}
                style={{
                  flex: 1, padding: '6px 12px', fontSize: '0.75rem', cursor: 'pointer',
                  border: '1.5px solid var(--color-border)',
                  borderRadius: '0 6px 6px 0',
                  background: testDepthState === 'deep' ? 'var(--color-primary)' : 'none',
                  color: testDepthState === 'deep' ? 'white' : 'var(--color-text-muted)',
                  fontWeight: testDepthState === 'deep' ? 600 : 400,
                }}
              >
                {lang === 'de' ? 'Tiefentest' : 'Deep Test'}
              </button>
            </div>
            <p style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', margin: '2px 0 0' }}>
              {testDepthState === 'quick'
                ? (lang === 'de'
                  ? 'Nur Feldprüfungen und direkt testbare Funktionen — keine Vorkette'
                  : 'Only field checks and directly testable functions — no prerequisite chain')
                : (lang === 'de'
                  ? 'KI baut komplette Vorkette auf (Stammdaten → Belege → Test) — interaktiv mit Rückfragen'
                  : 'AI builds complete prerequisite chain (master data → documents → test) — interactive with follow-ups')}
            </p>
            {testDepthState === 'deep' && (
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 0', marginTop: 4 }}>
                <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                  {lang === 'de' ? 'Max. Runden:' : 'Max rounds:'}
                </span>
                <select
                  value={deepTestRounds}
                  onChange={e => { const v = parseInt(e.target.value, 10); setDeepTestRoundsState(v); setDeepTestMaxRoundsSetting(v); }}
                  style={{ padding: '2px 8px', fontSize: '0.75rem', borderRadius: 'var(--radius)', border: '1px solid var(--color-border)' }}
                >
                  {[1, 2, 3, 4, 5, 7, 10].map(n => <option key={n} value={n}>{n}</option>)}
                </select>
              </div>
            )}
          </div>

          <div className={styles.divider} />

          {/* ── Knowledge Base ─────────────── */}
          <div className={styles.section}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 0' }}>
              <span className={styles.sectionLabel} style={{ fontSize: '0.8rem' }}>
                📚 {lang === 'de' ? 'Wissensdatenbank' : 'Knowledge Base'}
              </span>
              <button
                onClick={() => { const next = !kbEnabled; setKbEnabledState(next); setKnowledgeBaseEnabled(next); }}
                type="button"
                style={{
                  padding: '2px 10px', fontSize: '0.75rem',
                  borderRadius: 'var(--radius)', border: '1px solid var(--color-border)',
                  background: kbEnabled ? 'var(--color-primary)' : 'var(--color-surface)',
                  color: kbEnabled ? 'white' : 'var(--color-text-muted)', cursor: 'pointer',
                }}
              >
                {kbEnabled ? (lang === 'de' ? 'AN' : 'ON') : (lang === 'de' ? 'AUS' : 'OFF')}
              </button>
            </div>
            <p style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', margin: '2px 0 0' }}>
              {lang === 'de'
                ? 'Durchsucht PDF-Dokumentation nach relevanten Abschnitten für die Testgenerierung'
                : 'Searches PDF documentation for relevant sections during test generation'}
            </p>

            {kbEnabled && (
              <div style={{ marginTop: 8, display: 'flex', flexDirection: 'column', gap: 6 }}>
                {/* Max Chunks */}
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                    {lang === 'de' ? 'Max. Chunks pro Generierung:' : 'Max chunks per generation:'}
                  </span>
                  <select
                    value={kbMaxChunks}
                    onChange={e => { const v = parseInt(e.target.value, 10); setKbMaxChunksState(v); setKBMaxChunksSetting(v); }}
                    style={{ padding: '2px 8px', fontSize: '0.75rem', borderRadius: 'var(--radius)', border: '1px solid var(--color-border)' }}
                  >
                    {[1, 2, 3, 5, 7, 10].map(n => <option key={n} value={n}>{n}</option>)}
                  </select>
                </div>

                {/* Process Chains */}
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                    {lang === 'de' ? 'Prozessketten berücksichtigen:' : 'Consider process chains:'}
                  </span>
                  <button
                    onClick={() => { const next = !kbChains; setKbChainsState(next); setKBChainsEnabled(next); }}
                    type="button"
                    style={{
                      padding: '1px 8px', fontSize: '0.7rem',
                      borderRadius: 'var(--radius)', border: '1px solid var(--color-border)',
                      background: kbChains ? 'var(--color-primary)' : 'var(--color-surface)',
                      color: kbChains ? 'white' : 'var(--color-text-muted)', cursor: 'pointer',
                    }}
                  >
                    {kbChains ? (lang === 'de' ? 'AN' : 'ON') : (lang === 'de' ? 'AUS' : 'OFF')}
                  </button>
                </div>

                {/* Action Recognition */}
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                    {lang === 'de' ? 'Aktions-Erkennung (Neu/Bearbeiten/...):' : 'Action recognition (New/Edit/...):'}
                  </span>
                  <button
                    onClick={() => { const next = !kbActions; setKbActionsState(next); setKBActionsEnabled(next); }}
                    type="button"
                    style={{
                      padding: '1px 8px', fontSize: '0.7rem',
                      borderRadius: 'var(--radius)', border: '1px solid var(--color-border)',
                      background: kbActions ? 'var(--color-primary)' : 'var(--color-surface)',
                      color: kbActions ? 'white' : 'var(--color-text-muted)', cursor: 'pointer',
                    }}
                  >
                    {kbActions ? (lang === 'de' ? 'AN' : 'ON') : (lang === 'de' ? 'AUS' : 'OFF')}
                  </button>
                </div>

                {/* Event Context */}
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                    {lang === 'de' ? 'Event-Kontext (Reverse Eng.):' : 'Event context (Reverse Eng.):'}
                  </span>
                  <button
                    onClick={() => { const next = !kbEvents; setKbEventsState(next); setKBEventsEnabled(next); }}
                    type="button"
                    style={{
                      padding: '1px 8px', fontSize: '0.7rem',
                      borderRadius: 'var(--radius)', border: '1px solid var(--color-border)',
                      background: kbEvents ? 'var(--color-primary)' : 'var(--color-surface)',
                      color: kbEvents ? 'white' : 'var(--color-text-muted)', cursor: 'pointer',
                    }}
                  >
                    {kbEvents ? (lang === 'de' ? 'AN' : 'ON') : (lang === 'de' ? 'AUS' : 'OFF')}
                  </button>
                </div>
              </div>
            )}
          </div>

          <div className={styles.divider} />

          {/* ── Experimental Features Toggle ─────────────── */}
          <div className={styles.section}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 0' }}>
              <span className={styles.sectionLabel} style={{ fontSize: '0.8rem' }}>
                ⚗ {lang === 'de' ? 'Experimentelle Features' : 'Experimental Features'}
              </span>
              <button
                onClick={handleExperimentalToggle}
                type="button"
                style={{
                  padding: '2px 10px',
                  fontSize: '0.75rem',
                  borderRadius: 'var(--radius)',
                  border: '1px solid var(--color-border)',
                  background: experimentalFeatures ? 'var(--color-primary)' : 'var(--color-surface)',
                  color: experimentalFeatures ? 'white' : 'var(--color-text-muted)',
                  cursor: 'pointer',
                }}
              >
                {experimentalFeatures
                  ? (lang === 'de' ? 'AN' : 'ON')
                  : (lang === 'de' ? 'AUS' : 'OFF')}
              </button>
            </div>
            {experimentalFeatures && (
              <p style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', margin: '2px 0 0' }}>
                {lang === 'de'
                  ? 'Reverse Engineering Tab + FOP-Agents aktiv. Seite wird neu geladen beim Umschalten.'
                  : 'Reverse Engineering tab + FOP agents active. Page reloads on toggle.'}
              </p>
            )}
          </div>

          </>}

          {/* ── TAB: Prompts ───────────────────────────────────── */}
          {settingsTab === 'prompts' && <>

          {/* ── System Prompt — Cucumber Agent ───────────── */}
          <div className={styles.section}>
            <button
              className={styles.promptToggle}
              onClick={() => setPromptOpen(!promptOpen)}
              type="button"
            >
              <span className={styles.sectionLabel}>
                {promptCustomized ? t('settings.systemPromptCustomized') : t('settings.systemPrompt')}
                {' '}— Cucumber Agent
              </span>
              <span className={styles.promptArrow}>{promptOpen ? '\u25B2' : '\u25BC'}</span>
            </button>

            {promptOpen && (
              <div className={styles.promptEditor}>
                <textarea
                  className={styles.promptTextarea}
                  value={promptText}
                  onChange={(e) => setPromptText(e.target.value)}
                  rows={16}
                  spellCheck={false}
                />
                <div className={styles.promptActions}>
                  <button className={styles.saveBtn} onClick={handlePromptSave} type="button">
                    {t('settings.save')}
                  </button>
                  <button className={styles.clearBtn} onClick={handlePromptReset} type="button">
                    {t('settings.reset')}
                  </button>
                </div>
              </div>
            )}
          </div>

          {/* ── Table-Identification Prompt — Cucumber Agent ─── */}
          <div className={styles.section}>
            <button
              className={styles.promptToggle}
              onClick={() => setTableIdPromptOpen(!tableIdPromptOpen)}
              type="button"
            >
              <span className={styles.sectionLabel}>
                {tableIdPromptCustomized ? t('settings.tableIdPromptCustomized') : t('settings.tableIdPrompt')}
                {' '}— Cucumber Agent
              </span>
              <span className={styles.promptArrow}>{tableIdPromptOpen ? '\u25B2' : '\u25BC'}</span>
            </button>

            {tableIdPromptOpen && (
              <div className={styles.promptEditor}>
                <textarea
                  className={styles.promptTextarea}
                  value={tableIdPromptText}
                  onChange={(e) => setTableIdPromptText(e.target.value)}
                  rows={12}
                  spellCheck={false}
                />
                <div className={styles.promptActions}>
                  <button className={styles.saveBtn} onClick={handleTableIdPromptSave} type="button">
                    {t('settings.save')}
                  </button>
                  <button className={styles.clearBtn} onClick={handleTableIdPromptReset} type="button">
                    {t('settings.reset')}
                  </button>
                </div>
              </div>
            )}
          </div>

          {/* ── Rating Prompt — Cucumber Agent ──────────────── */}
          <div className={styles.section}>
            <button
              className={styles.promptToggle}
              onClick={() => setRatingPromptOpen(!ratingPromptOpen)}
              type="button"
            >
              <span className={styles.sectionLabel}>
                {ratingPromptCustomized ? t('settings.ratingPromptCustomized') : t('settings.ratingPrompt')}
                {' '}— Cucumber Agent
              </span>
              <span className={styles.promptArrow}>{ratingPromptOpen ? '\u25B2' : '\u25BC'}</span>
            </button>

            {ratingPromptOpen && (
              <div className={styles.promptEditor}>
                <textarea
                  className={styles.promptTextarea}
                  value={ratingPromptText}
                  onChange={(e) => setRatingPromptText(e.target.value)}
                  rows={12}
                  spellCheck={false}
                />
                <div className={styles.promptActions}>
                  <button className={styles.saveBtn} onClick={handleRatingPromptSave} type="button">
                    {t('settings.save')}
                  </button>
                  <button className={styles.clearBtn} onClick={handleRatingPromptReset} type="button">
                    {t('settings.reset')}
                  </button>
                </div>
              </div>
            )}
          </div>

          {/* ── FOP Agent Prompts (only when experimental features enabled) ── */}
          {experimentalFeatures && (
            <>
              <div className={styles.divider} />

              <div className={styles.section}>
                <button
                  className={styles.promptToggle}
                  onClick={() => setFopAnalystOpen(!fopAnalystOpen)}
                  type="button"
                >
                  <span className={styles.sectionLabel}>
                    {fopAnalystCustomized
                      ? `⚗ System-Prompt — FOP Inhaltsanalyst ★`
                      : `⚗ System-Prompt — FOP Inhaltsanalyst`}
                  </span>
                  <span className={styles.promptArrow}>{fopAnalystOpen ? '\u25B2' : '\u25BC'}</span>
                </button>
                {fopAnalystOpen && (
                  <div className={styles.promptEditor}>
                    <textarea
                      className={styles.promptTextarea}
                      value={fopAnalystText}
                      onChange={(e) => setFopAnalystText(e.target.value)}
                      rows={14}
                      spellCheck={false}
                    />
                    <div className={styles.promptActions}>
                      <button className={styles.saveBtn} onClick={handleFopAnalystSave} type="button">
                        {t('settings.save')}
                      </button>
                      <button className={styles.clearBtn} onClick={handleFopAnalystReset} type="button">
                        {t('settings.reset')}
                      </button>
                    </div>
                  </div>
                )}
              </div>

              <div className={styles.section}>
                <button
                  className={styles.promptToggle}
                  onClick={() => setFopGuidelinesOpen(!fopGuidelinesOpen)}
                  type="button"
                >
                  <span className={styles.sectionLabel}>
                    {fopGuidelinesCustomized
                      ? `⚗ System-Prompt — FOP Richtlinienprüfer ★`
                      : `⚗ System-Prompt — FOP Richtlinienprüfer`}
                  </span>
                  <span className={styles.promptArrow}>{fopGuidelinesOpen ? '\u25B2' : '\u25BC'}</span>
                </button>
                {fopGuidelinesOpen && (
                  <div className={styles.promptEditor}>
                    <textarea
                      className={styles.promptTextarea}
                      value={fopGuidelinesText}
                      onChange={(e) => setFopGuidelinesText(e.target.value)}
                      rows={12}
                      spellCheck={false}
                    />
                    <div className={styles.promptActions}>
                      <button className={styles.saveBtn} onClick={handleFopGuidelinesSave} type="button">
                        {t('settings.save')}
                      </button>
                      <button className={styles.clearBtn} onClick={handleFopGuidelinesReset} type="button">
                        {t('settings.reset')}
                      </button>
                    </div>
                  </div>
                )}
              </div>

            </>
          )}

          <div className={styles.divider} />

          {/* ── Field Usage Rules Prompt ───────────── */}
          <div className={styles.section}>
            <button
              className={styles.promptToggle}
              onClick={() => setFieldRulesOpen(v => !v)}
              type="button"
            >
              <span className={styles.promptTitle}>
                {fieldRulesCustomized ? '★ ' : ''}
                {lang === 'de' ? 'Feldregeln-Prompt' : 'Field Rules Prompt'}
              </span>
              <span className={styles.promptArrow}>{fieldRulesOpen ? '▴' : '▾'}</span>
            </button>
            {fieldRulesOpen && (
              <div className={styles.promptEditor}>
                <textarea
                  className={styles.promptTextarea}
                  rows={6}
                  value={fieldRulesText}
                  onChange={e => setFieldRulesText(e.target.value)}
                />
                <div className={styles.promptActions}>
                  <button className={styles.saveBtn} onClick={() => { const v = fieldRulesText.trim(); if (v === getDefaultFieldRules(currentLang).trim()) { clearCustomFieldRulesSetting(currentLang); setFieldRulesCustomized(false); } else { setCustomFieldRulesSetting(currentLang, v); setFieldRulesCustomized(true); } }} type="button">{t('settings.save')}</button>
                  <button className={styles.clearBtn} onClick={() => { clearCustomFieldRulesSetting(currentLang); setFieldRulesText(getDefaultFieldRules(currentLang)); setFieldRulesCustomized(false); }} type="button">{t('settings.reset')}</button>
                </div>
              </div>
            )}
          </div>

          {/* ── Quick Test Prompt ───────────── */}
          <div className={styles.section}>
            <button
              className={styles.promptToggle}
              onClick={() => setQuickTestOpen(v => !v)}
              type="button"
            >
              <span className={styles.promptTitle}>
                {quickTestCustomized ? '★ ' : ''}
                {lang === 'de' ? 'Schnelltest-Prompt' : 'Quick Test Prompt'}
              </span>
              <span className={styles.promptArrow}>{quickTestOpen ? '▴' : '▾'}</span>
            </button>
            {quickTestOpen && (
              <div className={styles.promptEditor}>
                <textarea
                  className={styles.promptTextarea}
                  rows={4}
                  value={quickTestText}
                  onChange={e => setQuickTestText(e.target.value)}
                />
                <div className={styles.promptActions}>
                  <button className={styles.saveBtn} onClick={() => { const v = quickTestText.trim(); if (v === getDefaultQuickTestPrompt(currentLang).trim()) { clearCustomQuickTestSetting(currentLang); setQuickTestCustomized(false); } else { setCustomQuickTestSetting(currentLang, v); setQuickTestCustomized(true); } }} type="button">{t('settings.save')}</button>
                  <button className={styles.clearBtn} onClick={() => { clearCustomQuickTestSetting(currentLang); setQuickTestText(getDefaultQuickTestPrompt(currentLang)); setQuickTestCustomized(false); }} type="button">{t('settings.reset')}</button>
                </div>
              </div>
            )}
          </div>

          {/* ── Deep Test Prompt ───────────── */}
          <div className={styles.section}>
            <button
              className={styles.promptToggle}
              onClick={() => setDeepTestOpen(v => !v)}
              type="button"
            >
              <span className={styles.promptTitle}>
                {deepTestCustomized ? '★ ' : ''}
                {lang === 'de' ? 'Tiefentest-Prompt' : 'Deep Test Prompt'}
              </span>
              <span className={styles.promptArrow}>{deepTestOpen ? '▴' : '▾'}</span>
            </button>
            {deepTestOpen && (
              <div className={styles.promptEditor}>
                <textarea
                  className={styles.promptTextarea}
                  rows={5}
                  value={deepTestText}
                  onChange={e => setDeepTestText(e.target.value)}
                />
                <div className={styles.promptActions}>
                  <button className={styles.saveBtn} onClick={() => { const v = deepTestText.trim(); if (v === getDefaultDeepTestPrompt(currentLang).trim()) { clearCustomDeepTestSetting(currentLang); setDeepTestCustomized(false); } else { setCustomDeepTestSetting(currentLang, v); setDeepTestCustomized(true); } }} type="button">{t('settings.save')}</button>
                  <button className={styles.clearBtn} onClick={() => { clearCustomDeepTestSetting(currentLang); setDeepTestText(getDefaultDeepTestPrompt(currentLang)); setDeepTestCustomized(false); }} type="button">{t('settings.reset')}</button>
                </div>
              </div>
            )}
          </div>

          </>}

          {/* ── Import-Profile Section (shown in General tab) ─────────── */}
          {settingsTab === 'general' && <>
          <div className={styles.section}>
            <button
              className={styles.promptToggle}
              onClick={() => setProfileOpen(!profileOpen)}
              type="button"
            >
              <span className={styles.sectionLabel}>
                {t('settings.importProfiles', { name: selectedProfile.name })}
              </span>
              <span className={styles.promptArrow}>{profileOpen ? '\u25B2' : '\u25BC'}</span>
            </button>

            {profileOpen && (
              <div className={styles.promptEditor}>
                {/* Profile selector */}
                <div style={{ display: 'flex', gap: '8px', alignItems: 'center', flexWrap: 'wrap' }}>
                  <select
                    style={{
                      flex: 1,
                      padding: '6px 10px',
                      border: '1px solid var(--color-border)',
                      borderRadius: 'var(--radius)',
                      fontSize: '0.85rem',
                      background: 'var(--color-surface)',
                    }}
                    value={activeId}
                    onChange={(e) => handleProfileSelect(e.target.value)}
                  >
                    {allProfiles.map((p) => (
                      <option key={p.id} value={p.id}>
                        {p.name}{p.id === 'default' ? ` ${t('settings.profileDefault')}` : ''}
                      </option>
                    ))}
                  </select>
                </div>

                {/* Profile actions */}
                <div className={styles.promptActions}>
                  <button className={styles.saveBtn} onClick={handleNewProfile} type="button" style={{ fontSize: '0.75rem', padding: '4px 12px' }}>
                    {t('settings.profileNew')}
                  </button>
                  <button className={styles.clearBtn} onClick={() => profileFileRef.current?.click()} type="button" style={{ borderColor: 'var(--color-border)', color: 'var(--color-text-muted)' }}>
                    {t('settings.profileImport')}
                  </button>
                  <input
                    ref={profileFileRef}
                    type="file"
                    accept=".json"
                    onChange={handleImportProfile}
                    style={{ display: 'none' }}
                  />
                  <button className={styles.clearBtn} onClick={handleExportProfile} type="button" style={{ borderColor: 'var(--color-border)', color: 'var(--color-text-muted)' }}>
                    {t('settings.profileExport')}
                  </button>
                  {activeId !== 'default' && (
                    <button className={styles.clearBtn} onClick={handleDeleteProfile} type="button">
                      {t('settings.profileDelete')}
                    </button>
                  )}
                </div>

                {/* Edit toggle */}
                {activeId !== 'default' && (
                  <button
                    className={styles.promptToggle}
                    onClick={handleEditToggle}
                    type="button"
                    style={{ marginTop: '4px' }}
                  >
                    <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                      {editProfile ? t('settings.profileEditClose') : t('settings.profileEditOpen')}
                    </span>
                    <span className={styles.promptArrow}>{editProfile ? '\u25B2' : '\u25BC'}</span>
                  </button>
                )}

                {/* Profile editor */}
                {editProfile && activeId !== 'default' && (
                  <ProfileEditor
                    profile={editProfile}
                    onChange={setEditProfile}
                    onSave={handleSaveProfile}
                    t={t}
                  />
                )}
              </div>
            )}
          </div>
          </>}
        </div>
      )}
    </div>
  );
}

// ── Profile Editor sub-component ─────────────────────────────

function ProfileEditor({
  profile,
  onChange,
  onSave,
  t,
}: {
  profile: ParseProfile;
  onChange: (p: ParseProfile) => void;
  onSave: () => void;
  t: TranslationFn;
}) {
  const keywordFields: { key: keyof ParseProfile['keywords']; label: string }[] = [
    { key: 'feature', label: t('settings.kwFeature') },
    { key: 'database', label: t('settings.kwDatabase') },
    { key: 'testUser', label: t('settings.kwTestUser') },
    { key: 'tags', label: t('settings.kwTags') },
    { key: 'description', label: t('settings.kwDescription') },
    { key: 'scenario', label: t('settings.kwScenario') },
    { key: 'comment', label: t('settings.kwComment') },
  ];

  const stepFields: { key: keyof ParseProfile['stepKeywords']; label: string }[] = [
    { key: 'precondition', label: t('settings.skPrecondition') },
    { key: 'action', label: t('settings.skAction') },
    { key: 'result', label: t('settings.skResult') },
    { key: 'and', label: t('settings.skAnd') },
    { key: 'but', label: t('settings.skBut') },
  ];

  const updateKeyword = (key: keyof ParseProfile['keywords'], value: string) => {
    const aliases = value.split(',').map((s) => s.trim()).filter(Boolean);
    onChange({ ...profile, keywords: { ...profile.keywords, [key]: aliases } });
  };

  const updateStepKeyword = (key: keyof ParseProfile['stepKeywords'], value: string) => {
    const aliases = value.split(',').map((s) => s.trim()).filter(Boolean);
    onChange({ ...profile, stepKeywords: { ...profile.stepKeywords, [key]: aliases } });
  };

  const updateHeadingLevels = (value: string) => {
    const levels = value.split(',').map((s) => parseInt(s.trim(), 10)).filter((n) => !isNaN(n) && n >= 1 && n <= 6);
    onChange({ ...profile, splitting: { ...profile.splitting, headingLevels: levels } });
  };

  const updateTechKeywords = (value: string) => {
    const keywords = value.split(',').map((s) => s.trim()).filter(Boolean);
    onChange({ ...profile, splitting: { ...profile.splitting, technicalSectionKeywords: keywords } });
  };

  const addCustomAction = () => {
    const newAction: CustomActionPattern = {
      id: crypto.randomUUID(),
      label: '',
      pattern: '',
      stepText: '',
    };
    onChange({ ...profile, customActions: [...profile.customActions, newAction] });
  };

  const updateCustomAction = (id: string, field: keyof CustomActionPattern, value: string) => {
    onChange({
      ...profile,
      customActions: profile.customActions.map((ca) =>
        ca.id === id ? { ...ca, [field]: value } : ca
      ),
    });
  };

  const removeCustomAction = (id: string) => {
    onChange({
      ...profile,
      customActions: profile.customActions.filter((ca) => ca.id !== id),
    });
  };

  const inputStyle: React.CSSProperties = {
    width: '100%',
    padding: '4px 8px',
    border: '1px solid var(--color-border)',
    borderRadius: 'var(--radius)',
    fontSize: '0.8rem',
    fontFamily: 'var(--font-mono)',
  };

  const labelStyle: React.CSSProperties = {
    fontSize: '0.75rem',
    color: 'var(--color-text-muted)',
    minWidth: '90px',
    textAlign: 'right',
    paddingRight: '8px',
  };

  const rowStyle: React.CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    gap: '4px',
    marginBottom: '4px',
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
      {/* Keywords */}
      <div>
        <div style={{ fontSize: '0.7rem', fontWeight: 600, color: 'var(--color-text-muted)', textTransform: 'uppercase', marginBottom: '6px' }}>
          {t('settings.featureKeywords')}
        </div>
        {keywordFields.map(({ key, label }) => (
          <div key={key} style={rowStyle}>
            <span style={labelStyle}>{label}:</span>
            <input
              style={inputStyle}
              value={profile.keywords[key].join(', ')}
              onChange={(e) => updateKeyword(key, e.target.value)}
              placeholder={`${t('settings.placeholderEg')} ${label}`}
            />
          </div>
        ))}
      </div>

      {/* Step Keywords */}
      <div>
        <div style={{ fontSize: '0.7rem', fontWeight: 600, color: 'var(--color-text-muted)', textTransform: 'uppercase', marginBottom: '6px' }}>
          {t('settings.stepKeywords')}
        </div>
        {stepFields.map(({ key, label }) => (
          <div key={key} style={rowStyle}>
            <span style={labelStyle}>{label}:</span>
            <input
              style={inputStyle}
              value={profile.stepKeywords[key].join(', ')}
              onChange={(e) => updateStepKeyword(key, e.target.value)}
              placeholder={`${t('settings.placeholderEg')} ${label}`}
            />
          </div>
        ))}
      </div>

      {/* Heading Levels */}
      <div>
        <div style={{ fontSize: '0.7rem', fontWeight: 600, color: 'var(--color-text-muted)', textTransform: 'uppercase', marginBottom: '6px' }}>
          {t('settings.headingLevels')}
        </div>
        <div style={rowStyle}>
          <span style={labelStyle}>{t('settings.levels')}</span>
          <input
            style={inputStyle}
            value={profile.splitting.headingLevels.join(', ')}
            onChange={(e) => updateHeadingLevels(e.target.value)}
            placeholder={t('settings.placeholderLevels')}
          />
        </div>
        <div style={rowStyle}>
          <span style={{ ...labelStyle, minWidth: '120px' }}>{t('settings.techSection')}</span>
          <input
            style={inputStyle}
            value={(profile.splitting.technicalSectionKeywords ?? []).join(', ')}
            onChange={(e) => updateTechKeywords(e.target.value)}
            placeholder={t('settings.placeholderTechSection')}
          />
        </div>
      </div>

      {/* Custom Actions */}
      <div>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
          <span style={{ fontSize: '0.7rem', fontWeight: 600, color: 'var(--color-text-muted)', textTransform: 'uppercase' }}>
            {t('settings.customActions', { count: profile.customActions.length })}
          </span>
          <button
            onClick={addCustomAction}
            type="button"
            style={{
              padding: '2px 8px',
              fontSize: '0.75rem',
              border: '1px solid var(--color-border)',
              borderRadius: 'var(--radius)',
              background: 'none',
              cursor: 'pointer',
              color: 'var(--color-text-muted)',
            }}
          >
            {t('settings.addPattern')}
          </button>
        </div>
        {profile.customActions.map((ca) => (
          <div key={ca.id} style={{ border: '1px solid var(--color-border)', borderRadius: 'var(--radius)', padding: '8px', marginBottom: '6px', fontSize: '0.8rem' }}>
            <div style={rowStyle}>
              <span style={{ ...labelStyle, minWidth: '60px' }}>Label:</span>
              <input style={inputStyle} value={ca.label} onChange={(e) => updateCustomAction(ca.id, 'label', e.target.value)} placeholder={t('settings.placeholderCustomLabel')} />
            </div>
            <div style={rowStyle}>
              <span style={{ ...labelStyle, minWidth: '60px' }}>Regex:</span>
              <input style={inputStyle} value={ca.pattern} onChange={(e) => updateCustomAction(ca.id, 'pattern', e.target.value)} placeholder="^Workflow starten:\s*(.+)$" />
            </div>
            <div style={rowStyle}>
              <span style={{ ...labelStyle, minWidth: '60px' }}>Text:</span>
              <input style={inputStyle} value={ca.stepText} onChange={(e) => updateCustomAction(ca.id, 'stepText', e.target.value)} placeholder='I start workflow "{1}"' />
            </div>
            <button
              onClick={() => removeCustomAction(ca.id)}
              type="button"
              style={{ padding: '2px 6px', fontSize: '0.7rem', border: '1px solid var(--color-danger)', borderRadius: 'var(--radius)', background: 'none', color: 'var(--color-danger)', cursor: 'pointer', marginTop: '4px' }}
            >
              {t('settings.removePattern')}
            </button>
          </div>
        ))}
      </div>

      {/* Save */}
      <button
        onClick={onSave}
        type="button"
        style={{
          padding: '6px 18px',
          background: 'var(--color-accent)',
          color: 'var(--color-text)',
          border: 'none',
          borderRadius: '300px',
          fontSize: '0.85rem',
          fontWeight: 600,
          cursor: 'pointer',
          alignSelf: 'flex-start',
        }}
      >
        {t('settings.profileSave')}
      </button>
    </div>
  );
}
