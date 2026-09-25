/**
 * @module SettingsPanel
 * Slide-in settings panel for configuring AI credentials, models, parse profiles, and prompts.
 *
 * Key responsibilities:
 * - Handles myforterro OAuth login/logout and tenant selection via the myforterroApi library.
 * - Exposes model selection for the myforterro inference models.
 * - Manages parse profiles (create, import, export, activate) and per-profile custom action patterns.
 * - Provides overrideable system prompts for Gherkin generation, table identification, rating,
 *   quick/deep tests, and FOP agent calls; shows defaults as placeholders.
 * - Can run in always-open mode (alwaysOpen prop) for the initial login screen.
 * @prop {boolean} loggedIn - Whether the user is currently authenticated.
 * @prop {(loggedIn: boolean) => void} onLoginChange - Callback fired on login state change.
 * @prop {string} model - Currently selected AI model identifier.
 * @prop {(model: string) => void} onModelChange - Callback fired when the model selection changes.
 */
import { useState, useRef, useEffect, useCallback } from 'react';
import type { ParseProfile, CustomActionPattern } from '../../types/gherkin';
import {
  setModel as saveModel,
  getCustomTableIdPrompt, setCustomTableIdPrompt, clearCustomTableIdPrompt,
  getCustomRatingPrompt, setCustomRatingPrompt, clearCustomRatingPrompt,
  getCustomLearningSuggestionPrompt, setCustomLearningSuggestionPrompt, clearCustomLearningSuggestionPrompt,
  getCustomFeatureEditPrompt, setCustomFeatureEditPrompt, clearCustomFeatureEditPrompt,
  getAgentMaxTokens, setAgentMaxTokens,
  getExperimentalFeatures, setExperimentalFeatures,
  isDevMode,
  getForceKiTableId, setForceKiTableId,
  getAiRequestTimeoutSeconds, setAiRequestTimeoutSeconds,
  getIncludeFieldCheckScenarios, setIncludeFieldCheckScenarios,
  getTestDepth, setTestDepth, type TestDepth,
  getDeepTestMaxRounds, setDeepTestMaxRounds as setDeepTestMaxRoundsSetting,
  isKnowledgeBaseEnabled, setKnowledgeBaseEnabled,
  getKBMaxChunks, setKBMaxChunks as setKBMaxChunksSetting,
  isKBChainsEnabled, setKBChainsEnabled,
  isKBKeywordExtractionEnabled, setKBKeywordExtractionEnabled,
  getKBKeywordCount, setKBKeywordCount as setKBKeywordCountSetting,
  getCustomFieldRules, setCustomFieldRules as setCustomFieldRulesSetting, clearCustomFieldRules as clearCustomFieldRulesSetting,
  getCustomQuickTestPrompt, setCustomQuickTestPrompt as setCustomQuickTestSetting, clearCustomQuickTestPrompt as clearCustomQuickTestSetting,
  getCustomDeepTestPrompt, setCustomDeepTestPrompt as setCustomDeepTestSetting, clearCustomDeepTestPrompt as clearCustomDeepTestSetting,
  getCustomFopAnalystPrompt, setCustomFopAnalystPrompt, clearCustomFopAnalystPrompt,
  getCustomFopGuidelinesPrompt, setCustomFopGuidelinesPrompt, clearCustomFopGuidelinesPrompt,
  getUserDialogCatalogJson, setUserDialogCatalogJson, clearUserDialogCatalog,
  exportAppSettingsJson, importAppSettingsJson,
  getTaskModel, type AiTaskKey,
  getStoredAgentId, setStoredAgentId, type AgentIdKey,
} from '../../lib/settings';
import { DEFAULT_STANDARD_DIALOG_CATALOG } from '../../lib/abasDialogCatalog';
import { DEFAULT_TABLE_ID_PROMPT, getRatingPromptForLang, getDefaultFieldRules, getDefaultQuickTestPrompt, getDefaultDeepTestPrompt } from '../../lib/aiPrompt';
import { getDefaultFeatureEditPrompt } from '../../lib/featureEditPrompt';
import { buildDefaultLearningSuggestionPrompt } from '../../lib/learningSuggestionPrompt';
import { isMftDailyLimitHitThisSession, clearMftDailyLimitHitThisSession } from '../../lib/tokenHistory';
import { buildFopAnalystPrompt, buildFopGuidelinesPrompt } from '../../lib/fopAgentPrompt';
import {
  pickDirectory,
  verifyPermission,
  saveSharedSettingsDirectoryHandle,
  loadSharedSettingsDirectoryHandle,
  clearSharedSettingsDirectoryHandle,
} from '../../lib/fileSystemAccess';
import { loadSharedSettingsJson, saveSharedSettingsJson } from '../../lib/learningStore';
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
  discoverMftAgents,
} from '../../lib/myforterroApi';
import type { MftTenant, MftModel, MftAgentDescriptor } from '../../lib/myforterroApi';
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
import { useTranslation, type TranslationFn } from '../../i18n';
import { IconGear } from '../icons';
import { getDailyTotal, getServerDailyTotal, isServerConsumptionAvailable, syncServerConsumption, getDailyLimit, isDailyLimitUnlimited } from '../../lib/tokenHistory';
import styles from './SettingsPanel.module.css';

interface SettingsPanelProps {
  loggedIn: boolean;
  onLoginChange: (loggedIn: boolean) => void;
  model: string;
  onModelChange: (model: string) => void;
  onSharedSettingsChange?: () => void;
  onSharedSettingsRemoved?: () => void;
  /** When true, the panel is always visible without a toggle button (login screen). */
  alwaysOpen?: boolean;
}

export function SettingsPanel({ loggedIn, onLoginChange, model, onModelChange, onSharedSettingsChange, onSharedSettingsRemoved, alwaysOpen = false }: SettingsPanelProps) {
  const { t, lang } = useTranslation();
  const [open, setOpen] = useState(false);
  const [settingsTab, setSettingsTab] = useState<'model' | 'general' | 'prompts'>('model');

  const [clientId, setClientId] = useState(() => getStoredClientId());
  const [clientSecret, setClientSecret] = useState(() => getStoredClientSecret());
  const [applicationId, setApplicationId] = useState(() => getStoredApplicationId());
  const [cucumberAgentId, setCucumberAgentId] = useState(() => getStoredAgentId('cucumber'));
  const [fopAnalystAgentIdInput, setFopAnalystAgentIdInput] = useState(() => getStoredAgentId('fop-analyst'));
  const [fopGuidelinesAgentIdInput, setFopGuidelinesAgentIdInput] = useState(() => getStoredAgentId('fop-guidelines'));
  const [excelTransformAgentId, setExcelTransformAgentId] = useState(() => getStoredAgentId('excel-transform'));
  const [excelMappingAgentId, setExcelMappingAgentId] = useState(() => getStoredAgentId('excel-mapping'));
  const [experimentalFeatures, setExperimentalFeaturesState] = useState(() => getExperimentalFeatures());

  const handleAgentIdChange = (key: AgentIdKey, value: string, setLocal: (v: string) => void) => {
    setLocal(value);
    setStoredAgentId(key, value);
  };

  // Authorization is blocked until the required agent IDs are configured — agents are
  // never auto-created, so without an ID the app would have nothing to talk to.
  const requiredAgentIdsMissing = !cucumberAgentId.trim() || !excelTransformAgentId.trim() || !excelMappingAgentId.trim()
    || (experimentalFeatures && (!fopAnalystAgentIdInput.trim() || !fopGuidelinesAgentIdInput.trim()));
  const [loginError, setLoginError] = useState<string | null>(null);
  const [loginLoading, setLoginLoading] = useState(false);

  // Tenant state
  const [tenants, setTenants] = useState<MftTenant[]>(() => getStoredTenants());
  const [selectedTenantId, setSelectedTenantId] = useState(() => getStoredTenantId() || '');
  const [manualTenantId, setManualTenantId] = useState('');

  // Model state
  const [models, setModels] = useState<MftModel[]>([]);
  const [discoveredAgents, setDiscoveredAgents] = useState<MftAgentDescriptor[] | null>(null);
  const [agentsCheckLoading, setAgentsCheckLoading] = useState(false);
  const [agentsCheckError, setAgentsCheckError] = useState<string | null>(null);

  // Agent max tokens
  const [agentMaxTokens, setAgentMaxTokensState] = useState(() => getAgentMaxTokens());

  // Token consumption (today) — replaces the old standalone "T" trigger/modal.
  const [dailyTokenTotal, setDailyTokenTotal] = useState(() => getDailyTotal().total);
  const [serverTokenTotal, setServerTokenTotal] = useState(() => getServerDailyTotal());
  const [dailyLimit, setDailyLimit] = useState(() => getDailyLimit());
  const [limitUnlimited, setLimitUnlimited] = useState(() => isDailyLimitUnlimited());

  useEffect(() => {
    if (!open) return;
    setDailyTokenTotal(getDailyTotal().total);
    setServerTokenTotal(getServerDailyTotal());
    setDailyLimit(getDailyLimit());
    setLimitUnlimited(isDailyLimitUnlimited());
    if (isServerConsumptionAvailable()) {
      void syncServerConsumption().then((result) => {
        if (result) setServerTokenTotal(result);
      });
    }
  }, [open]);

  // Advanced settings
  const [advancedOpen, setAdvancedOpen] = useState(false);
  const [authorizeUrlInput, setAuthorizeUrlInput] = useState('');
  const [tokenUrlInput, setTokenUrlInput] = useState('');
  const [apiBaseInput, setApiBaseInput] = useState('');

  // Prompt state — Table identification
  const [tableIdPromptOpen, setTableIdPromptOpen] = useState(false);
  const [tableIdPromptText, setTableIdPromptText] = useState(() => getCustomTableIdPrompt(lang as 'de' | 'en') || DEFAULT_TABLE_ID_PROMPT);
  const [tableIdPromptCustomized, setTableIdPromptCustomized] = useState(() => !!getCustomTableIdPrompt(lang as 'de' | 'en'));

  // Prompt state — Rating
  const [ratingPromptOpen, setRatingPromptOpen] = useState(false);
  const [ratingPromptText, setRatingPromptText] = useState(() => getCustomRatingPrompt(lang as 'de' | 'en') || getRatingPromptForLang(lang as 'de' | 'en'));
  const [ratingPromptCustomized, setRatingPromptCustomized] = useState(() => !!getCustomRatingPrompt(lang as 'de' | 'en'));

  // Prompt state — Learning suggestion helper
  const [learningSuggestionPromptOpen, setLearningSuggestionPromptOpen] = useState(false);
  const [learningSuggestionPromptText, setLearningSuggestionPromptText] = useState(
    () => getCustomLearningSuggestionPrompt(lang as 'de' | 'en') || buildDefaultLearningSuggestionPrompt(lang as 'de' | 'en'),
  );
  const [learningSuggestionPromptCustomized, setLearningSuggestionPromptCustomized] = useState(() => !!getCustomLearningSuggestionPrompt(lang as 'de' | 'en'));

  const [featureEditPromptOpen, setFeatureEditPromptOpen] = useState(false);
  const [featureEditPromptText, setFeatureEditPromptText] = useState(
    () => getCustomFeatureEditPrompt(lang as 'de' | 'en') || getDefaultFeatureEditPrompt(lang as 'de' | 'en'),
  );
  const [featureEditPromptCustomized, setFeatureEditPromptCustomized] = useState(() => !!getCustomFeatureEditPrompt(lang as 'de' | 'en'));

  // Dialog catalog state — numeric abas standard message IDs
  const dialogCatalogDefault = JSON.stringify(DEFAULT_STANDARD_DIALOG_CATALOG, null, 2);
  const [dialogCatalogOpen, setDialogCatalogOpen] = useState(false);
  const [dialogCatalogText, setDialogCatalogText] = useState(() => getUserDialogCatalogJson() || dialogCatalogDefault);
  const [dialogCatalogCustomized, setDialogCatalogCustomized] = useState(() => !!getUserDialogCatalogJson());
  const [dialogCatalogError, setDialogCatalogError] = useState<string | null>(null);

  const sharedSettingsFileRef = useRef<HTMLInputElement>(null);
  const [sharedSettingsFolderName, setSharedSettingsFolderName] = useState<string | null>(null);
  const [sharedSettingsLoading, setSharedSettingsLoading] = useState(true);
  const [sharedSettingsError, setSharedSettingsError] = useState<string | null>(null);
  const sharedSettingsConfigured = !!sharedSettingsFolderName;

  const persistSharedSettingsIfConfigured = useCallback(async () => {
    if (!sharedSettingsConfigured) return;
    try {
      await saveSharedSettingsJson();
    } catch (err) {
      setSharedSettingsError(err instanceof Error ? err.message : t('settings.sharedSaveError'));
    }
  }, [sharedSettingsConfigured, t]);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        const handle = await loadSharedSettingsDirectoryHandle();
        if (!handle) return;
        const hasPermission = await verifyPermission(handle);
        if (!hasPermission) return;
        if (!cancelled) {
          setSharedSettingsFolderName(handle.name);
        }
      } finally {
        if (!cancelled) setSharedSettingsLoading(false);
      }
    })();
    return () => { cancelled = true; };
  }, []);

  // Force KI table identification
  const [forceKiTableId, setForceKiTableIdState] = useState(() => getForceKiTableId());
  const [aiTimeoutSeconds, setAiTimeoutSecondsState] = useState(() => getAiRequestTimeoutSeconds());
  const [testDepthState, setTestDepthState] = useState<TestDepth>(() => getTestDepth());
  const [deepTestRounds, setDeepTestRoundsState] = useState(() => getDeepTestMaxRounds());
  const [includeFieldChecks, setIncludeFieldChecksState] = useState(() => getIncludeFieldCheckScenarios());

  // MFT daily-limit flag — sessionStorage-backed, so we mirror into React state
  // and listen to the `token-limit-reached` custom event to auto-refresh the UI
  // when the flag is set elsewhere (e.g. by an AI call that just failed).
  const [mftDailyLimitHit, setMftDailyLimitHitState] = useState(() => isMftDailyLimitHitThisSession());
  useEffect(() => {
    const sync = () => setMftDailyLimitHitState(isMftDailyLimitHitThisSession());
    window.addEventListener('token-limit-reached', sync);
    // Also re-check on focus (covers the case where another tab changed the flag)
    window.addEventListener('focus', sync);
    return () => {
      window.removeEventListener('token-limit-reached', sync);
      window.removeEventListener('focus', sync);
    };
  }, []);
  const handleResetDailyLimit = () => {
    clearMftDailyLimitHitThisSession();
    setMftDailyLimitHitState(false);
  };

  // Knowledge Base
  const [kbEnabled, setKbEnabledState] = useState(() => isKnowledgeBaseEnabled());
  const [kbMaxChunks, setKbMaxChunksState] = useState(() => getKBMaxChunks());
  const [kbChains, setKbChainsState] = useState(() => isKBChainsEnabled());
  const [kbKwExtract, setKbKwExtractState] = useState(() => isKBKeywordExtractionEnabled());
  const [kbKwCount, setKbKwCountState] = useState(() => getKBKeywordCount());

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
    setTableIdPromptText(getCustomTableIdPrompt(currentLang) || DEFAULT_TABLE_ID_PROMPT);
    setTableIdPromptCustomized(!!getCustomTableIdPrompt(currentLang));
    setRatingPromptText(getCustomRatingPrompt(currentLang) || getRatingPromptForLang(currentLang));
    setRatingPromptCustomized(!!getCustomRatingPrompt(currentLang));
    setLearningSuggestionPromptText(getCustomLearningSuggestionPrompt(currentLang) || buildDefaultLearningSuggestionPrompt(currentLang));
    setLearningSuggestionPromptCustomized(!!getCustomLearningSuggestionPrompt(currentLang));
    setFieldRulesText(getCustomFieldRules(currentLang) || getDefaultFieldRules(currentLang));
    setFieldRulesCustomized(!!getCustomFieldRules(currentLang));
    setQuickTestText(getCustomQuickTestPrompt(currentLang) || getDefaultQuickTestPrompt(currentLang));
    setQuickTestCustomized(!!getCustomQuickTestPrompt(currentLang));
    setDeepTestText(getCustomDeepTestPrompt(currentLang) || getDefaultDeepTestPrompt(currentLang));
    setDeepTestCustomized(!!getCustomDeepTestPrompt(currentLang));
    setFeatureEditPromptText(getCustomFeatureEditPrompt(currentLang) || getDefaultFeatureEditPrompt(currentLang));
    setFeatureEditPromptCustomized(!!getCustomFeatureEditPrompt(currentLang));
  }, [currentLang]);
  const handleAiTimeoutChange = (value: string) => {
    const parsed = parseInt(value, 10);
    if (Number.isNaN(parsed)) return;
    const clamped = Math.max(60, Math.min(1800, parsed));
    setAiTimeoutSecondsState(clamped);
    setAiRequestTimeoutSeconds(clamped);
  };

  const handleAgentMaxTokensChange = (value: string) => {
    const parsed = parseInt(value, 10);
    if (Number.isNaN(parsed)) return;
    const clamped = Math.max(256, Math.min(200000, parsed));
    setAgentMaxTokensState(clamped);
    setAgentMaxTokens(clamped);
    void persistSharedSettingsIfConfigured();
  };

  const handleForceKiToggle = () => {
    const next = !forceKiTableId;
    setForceKiTableIdState(next);
    setForceKiTableId(next);
    void persistSharedSettingsIfConfigured();
  };
  const handleIncludeFieldChecksToggle = () => {
    const next = !includeFieldChecks;
    setIncludeFieldChecksState(next);
    setIncludeFieldCheckScenarios(next);
    void persistSharedSettingsIfConfigured();
  };

  // Dev mode (URL gate ?dev=true). Hides experimental routing UI.
  const devMode = isDevMode();

  // FOP agent prompts (only relevant when experimentalFeatures=true)
  const [fopAnalystOpen, setFopAnalystOpen] = useState(false);
  const [fopAnalystText, setFopAnalystText] = useState(
    () => getCustomFopAnalystPrompt(lang as 'de' | 'en') || buildFopAnalystPrompt(lang as 'de' | 'en'),
  );
  const [fopAnalystCustomized, setFopAnalystCustomized] = useState(() => !!getCustomFopAnalystPrompt(lang as 'de' | 'en'));

  const [fopGuidelinesOpen, setFopGuidelinesOpen] = useState(false);
  const [fopGuidelinesText, setFopGuidelinesText] = useState(
    () => getCustomFopGuidelinesPrompt(lang as 'de' | 'en') || buildFopGuidelinesPrompt(lang as 'de' | 'en'),
  );
  const [fopGuidelinesCustomized, setFopGuidelinesCustomized] = useState(() => !!getCustomFopGuidelinesPrompt(lang as 'de' | 'en'));

  const handleFopAnalystSave = () => {
    const trimmed = fopAnalystText.trim();
    if (trimmed === buildFopAnalystPrompt(lang as 'de' | 'en').trim()) {
      clearCustomFopAnalystPrompt(currentLang);
      setFopAnalystCustomized(false);
    } else {
      setCustomFopAnalystPrompt(currentLang, trimmed);
      setFopAnalystCustomized(true);
    }
  };
  const handleFopAnalystReset = () => {
    clearCustomFopAnalystPrompt(currentLang);
    setFopAnalystText(buildFopAnalystPrompt(lang as 'de' | 'en'));
    setFopAnalystCustomized(false);
  };

  const handleFopGuidelinesSave = () => {
    const trimmed = fopGuidelinesText.trim();
    if (trimmed === buildFopGuidelinesPrompt(lang as 'de' | 'en').trim()) {
      clearCustomFopGuidelinesPrompt(currentLang);
      setFopGuidelinesCustomized(false);
    } else {
      setCustomFopGuidelinesPrompt(currentLang, trimmed);
      setFopGuidelinesCustomized(true);
    }
  };
  const handleFopGuidelinesReset = () => {
    clearCustomFopGuidelinesPrompt(currentLang);
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
      loadAgentsList();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [loggedIn, selectedTenantId]);

  async function loadModels() {
    try {
      const m = await listModels();
      setModels(m);
      // If current model is not in list, select first available
      if (m.length > 0 && !m.find((mod) => mod.id === model)) {
        const firstId = m[0].id;
        saveModel(firstId);
        onModelChange(firstId);
        void persistSharedSettingsIfConfigured();
      }
    } catch {
      // Model list unavailable — task-model display falls back to the stored/default values.
    }
  }

  // Verifies that the user-provided agent IDs actually exist for this tenant.
  async function loadAgentsList() {
    setAgentsCheckLoading(true);
    setAgentsCheckError(null);
    try {
      setDiscoveredAgents(await discoverMftAgents());
    } catch (err) {
      setAgentsCheckError(err instanceof Error ? err.message : String(err));
      setDiscoveredAgents(null);
    } finally {
      setAgentsCheckLoading(false);
    }
  }

  /** 'empty' | 'checking' | 'ok' | 'missing' — used to render inline status next to each Agent-ID input. */
  function getAgentIdStatus(id: string): 'empty' | 'checking' | 'ok' | 'missing' {
    if (!id.trim()) return 'empty';
    if (agentsCheckLoading || discoveredAgents === null) return 'checking';
    return discoveredAgents.some((a) => a.agentId === id.trim()) ? 'ok' : 'missing';
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

  // Table-identification prompt handlers
  const handleTableIdPromptSave = () => {
    const trimmed = tableIdPromptText.trim();
    if (trimmed === DEFAULT_TABLE_ID_PROMPT.trim()) {
      clearCustomTableIdPrompt(currentLang);
      setTableIdPromptCustomized(false);
    } else {
      setCustomTableIdPrompt(currentLang, trimmed);
      setTableIdPromptCustomized(true);
    }
    void persistSharedSettingsIfConfigured();
  };

  const handleTableIdPromptReset = () => {
    setTableIdPromptText(DEFAULT_TABLE_ID_PROMPT);
    clearCustomTableIdPrompt(currentLang);
    setTableIdPromptCustomized(false);
    void persistSharedSettingsIfConfigured();
  };

  // Rating prompt handlers
  const handleRatingPromptSave = () => {
    const trimmed = ratingPromptText.trim();
    if (trimmed === getRatingPromptForLang(currentLang).trim()) {
      clearCustomRatingPrompt(currentLang);
      setRatingPromptCustomized(false);
    } else {
      setCustomRatingPrompt(currentLang, trimmed);
      setRatingPromptCustomized(true);
    }
    void persistSharedSettingsIfConfigured();
  };

  const handleRatingPromptReset = () => {
    setRatingPromptText(getRatingPromptForLang(currentLang));
    clearCustomRatingPrompt(currentLang);
    setRatingPromptCustomized(false);
    void persistSharedSettingsIfConfigured();
  };

  const handleLearningSuggestionPromptSave = () => {
    const defaultPrompt = buildDefaultLearningSuggestionPrompt(currentLang).trim();
    const trimmed = learningSuggestionPromptText.trim();
    if (trimmed === defaultPrompt) {
      clearCustomLearningSuggestionPrompt(currentLang);
      setLearningSuggestionPromptCustomized(false);
    } else {
      setCustomLearningSuggestionPrompt(currentLang, trimmed);
      setLearningSuggestionPromptCustomized(true);
    }
    void persistSharedSettingsIfConfigured();
  };

  const handleLearningSuggestionPromptReset = () => {
    const fallback = buildDefaultLearningSuggestionPrompt(currentLang);
    setLearningSuggestionPromptText(fallback);
    clearCustomLearningSuggestionPrompt(currentLang);
    setLearningSuggestionPromptCustomized(false);
    void persistSharedSettingsIfConfigured();
  };

  const handleFeatureEditPromptSave = () => {
    const trimmed = featureEditPromptText.trim();
    if (trimmed === getDefaultFeatureEditPrompt(currentLang).trim()) {
      clearCustomFeatureEditPrompt(currentLang);
      setFeatureEditPromptCustomized(false);
    } else {
      setCustomFeatureEditPrompt(currentLang, trimmed);
      setFeatureEditPromptCustomized(true);
    }
    void persistSharedSettingsIfConfigured();
  };

  const handleFeatureEditPromptReset = () => {
    clearCustomFeatureEditPrompt(currentLang);
    setFeatureEditPromptText(getDefaultFeatureEditPrompt(currentLang));
    setFeatureEditPromptCustomized(false);
    void persistSharedSettingsIfConfigured();
  };

  // Dialog catalog handlers
  const handleDialogCatalogSave = () => {
    setDialogCatalogError(null);
    const trimmed = dialogCatalogText.trim();
    if (!trimmed || trimmed === dialogCatalogDefault.trim()) {
      clearUserDialogCatalog();
      setDialogCatalogText(dialogCatalogDefault);
      setDialogCatalogCustomized(false);
      void persistSharedSettingsIfConfigured();
      return;
    }
    try {
      setUserDialogCatalogJson(trimmed);
      setDialogCatalogCustomized(true);
      void persistSharedSettingsIfConfigured();
    } catch (err) {
      setDialogCatalogError(err instanceof Error ? err.message : 'Ungueltiges JSON');
    }
  };

  const handleDialogCatalogReset = () => {
    clearUserDialogCatalog();
    setDialogCatalogText(dialogCatalogDefault);
    setDialogCatalogCustomized(false);
    setDialogCatalogError(null);
    void persistSharedSettingsIfConfigured();
  };

  const handleChooseSharedSettingsFolder = async () => {
    setSharedSettingsError(null);
    try {
      const handle = await pickDirectory();
      const hasPermission = await verifyPermission(handle);
      if (!hasPermission) return;
      await saveSharedSettingsDirectoryHandle(handle);
      setSharedSettingsFolderName(handle.name);
      const existingJson = await loadSharedSettingsJson();
      if (existingJson && existingJson.trim()) {
        importAppSettingsJson(existingJson);
      } else {
        // First-time setup: seed from the recommended preset instead of ad-hoc current state.
        try {
          const presetRes = await fetch('/presets/recommended-settings.json', { cache: 'no-store' });
          if (presetRes.ok) {
            const presetJson = await presetRes.text();
            importAppSettingsJson(presetJson);
          }
        } catch {
          // If preset loading fails, keep current runtime values.
        }
        await saveSharedSettingsJson();
      }
      onSharedSettingsChange?.();
      window.location.reload();
    } catch (err) {
      if ((err as Error).name !== 'AbortError') {
        setSharedSettingsError(err instanceof Error ? err.message : t('settings.sharedChooseFolderError'));
      }
    }
  };

  const handleClearSharedSettingsFolder = async () => {
    await clearSharedSettingsDirectoryHandle();
    setSharedSettingsFolderName(null);
    setSharedSettingsError(null);
    onSharedSettingsChange?.();
    onSharedSettingsRemoved?.();
  };

  const handleExportSettingsJson = () => {
    if (!sharedSettingsConfigured) {
      setSharedSettingsError(t('settings.sharedFolderRequiredError'));
      return;
    }
    const json = exportAppSettingsJson();
    const blob = new Blob([json], { type: 'application/json;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = 'cucumbergnerator-settings.json';
    anchor.click();
    URL.revokeObjectURL(url);
  };

  const handleImportSettingsJson = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;
    setSharedSettingsError(null);
    if (!sharedSettingsConfigured) {
      setSharedSettingsError(t('settings.sharedFolderRequiredError'));
      if (sharedSettingsFileRef.current) sharedSettingsFileRef.current.value = '';
      return;
    }
    try {
      const text = await file.text();
      importAppSettingsJson(text);
      await saveSharedSettingsJson();
      window.location.reload();
    } catch (err) {
      setSharedSettingsError(err instanceof Error ? err.message : t('settings.sharedInvalidJsonError'));
    } finally {
      if (sharedSettingsFileRef.current) sharedSettingsFileRef.current.value = '';
    }
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
          title={toggleLabel}
          aria-label={toggleLabel}
        >
          <IconGear />
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
            ) : (              <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
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
                  disabled={loginLoading || !clientId.trim() || requiredAgentIdsMissing}
                >
                  {loginLoading ? t('settings.redirecting') : t('settings.authorize')}
                </button>

                {requiredAgentIdsMissing && (
                  <span style={{ fontSize: '0.75rem', color: 'var(--color-danger)' }}>
                    {lang === 'de'
                      ? 'Bitte zuerst die Agent-IDs im Tab "Agenten" eintragen.'
                      : 'Please enter the Agent IDs in the "Agents" tab first.'}
                  </span>
                )}

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
              </div>
            )}
          </div>

          {/* ── Token consumption (today) — replaces the old "T" trigger ─── */}
          {loggedIn && (() => {
            const consumed = serverTokenTotal?.totalTokens ?? dailyTokenTotal;
            const locale = lang === 'de' ? 'de-DE' : 'en-US';
            const pct = limitUnlimited ? 0 : Math.min(100, (consumed / Math.max(1, dailyLimit)) * 100);
            return (
              <div className={styles.section}>
                <span className={styles.sectionLabel}>
                  {lang === 'de' ? 'Token-Verbrauch heute' : 'Token usage today'}
                </span>
                <span style={{ fontSize: '0.8rem', fontFamily: 'monospace' }}>
                  {consumed.toLocaleString(locale)}
                  {!limitUnlimited && ` / ${dailyLimit.toLocaleString(locale)}`}
                </span>
                {!limitUnlimited && (
                  <div style={{ width: '100%', height: '6px', background: 'var(--color-border)', borderRadius: '3px', overflow: 'hidden', marginTop: '4px' }}>
                    <div
                      style={{
                        width: `${pct}%`,
                        height: '100%',
                        background: pct >= 90 ? 'var(--color-danger)' : 'var(--color-primary)',
                        transition: 'width 0.2s ease',
                      }}
                    />
                  </div>
                )}
              </div>
            );
          })()}

          {/* ── Settings Tabs ─────────────────────────────────── */}
          <div className={styles.settingsTabs}>
            {(['model', 'general', 'prompts'] as const).map(tab => (
              <button
                key={tab}
                type="button"
                className={`${styles.settingsTab} ${settingsTab === tab ? styles.settingsTabActive : ''}`}
                onClick={() => setSettingsTab(tab)}
              >
                {tab === 'model' ? (lang === 'de' ? 'Agenten' : 'Agents')
                  : tab === 'general' ? (lang === 'de' ? 'Einstellungen' : 'Settings')
                  : (lang === 'de' ? 'Prompts' : 'Prompts')}
              </button>
            ))}
          </div>

          {/* ── TAB: Agents ──────────────────────────────────────── */}
          {settingsTab === 'model' && <>
          {/* ── Agent IDs (user-provided, no auto-creation) ─────── */}
          <div className={styles.section}>
            <span className={styles.sectionLabel}>
              {lang === 'de' ? 'Agent-IDs' : 'Agent IDs'}
            </span>
            <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
              {lang === 'de'
                ? 'Agents werden nicht mehr automatisch angelegt. Trage hier die ID eines global geteilten oder kundenspezifisch angelegten Agents ein.'
                : 'Agents are no longer created automatically. Enter the ID of a globally shared or customer-specific agent here.'}
            </span>
            {([
              ['cucumber', lang === 'de' ? 'Cucumber Agent' : 'Cucumber Agent', cucumberAgentId, setCucumberAgentId],
              ['excel-transform', lang === 'de' ? 'Excel-Transform-Agent' : 'Excel transform agent', excelTransformAgentId, setExcelTransformAgentId],
              ['excel-mapping', lang === 'de' ? 'Excel-Mapping-Agent' : 'Excel mapping agent', excelMappingAgentId, setExcelMappingAgentId],
              ...(experimentalFeatures ? ([
                ['fop-analyst', lang === 'de' ? 'FOP Inhaltsanalyst' : 'FOP content analyst', fopAnalystAgentIdInput, setFopAnalystAgentIdInput],
                ['fop-guidelines', lang === 'de' ? 'FOP Richtlinienprüfer' : 'FOP guidelines checker', fopGuidelinesAgentIdInput, setFopGuidelinesAgentIdInput],
              ] as [AgentIdKey, string, string, (v: string) => void][]) : []),
            ] as [AgentIdKey, string, string, (v: string) => void][]).map(([key, label, value, setLocal]) => {
              const status = getAgentIdStatus(value);
              return (
                <div key={key} style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 4 }}>
                  <span style={{ fontSize: '0.8rem', minWidth: 160 }}>{label}</span>
                  <input
                    className={styles.input}
                    style={{ flex: 1 }}
                    type="text"
                    value={value}
                    onChange={(e) => handleAgentIdChange(key, e.target.value, setLocal)}
                    placeholder={lang === 'de' ? 'Agent-ID einfügen…' : 'Paste agent ID…'}
                  />
                  {status === 'ok' && (
                    <span style={{ fontSize: '0.75rem', color: 'var(--color-success, #2e7d32)' }} title={lang === 'de' ? 'Agent gefunden' : 'Agent found'}>✓</span>
                  )}
                  {status === 'missing' && (
                    <span style={{ fontSize: '0.75rem', color: 'var(--color-danger)' }} title={lang === 'de' ? 'Agent nicht gefunden' : 'Agent not found'}>
                      {lang === 'de' ? 'nicht gefunden' : 'not found'}
                    </span>
                  )}
                  {status === 'checking' && (
                    <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>…</span>
                  )}
                </div>
              );
            })}
            {agentsCheckError && (
              <span style={{ fontSize: '0.75rem', color: 'var(--color-danger)' }}>{agentsCheckError}</span>
            )}
          </div>

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
              {/* ── Model per task (read-only display) ────── */}
              <div className={styles.divider} />
              <div className={styles.section}>
                <span className={styles.sectionLabel}>
                  {lang === 'de' ? 'Modell pro Aufgabe' : 'Model per task'}
                </span>
                <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                  {lang === 'de'
                    ? 'Fest hinterlegt je Aufgabe \u2014 einfache Klassifikationsaufgaben nutzen ein g\u00fcnstigeres/schnelleres Modell als die Gherkin-Generierung.'
                    : 'Fixed per task \u2014 simple classification tasks use a cheaper/faster model than Gherkin generation.'}
                </span>
                {([
                  ['gherkin-generation', lang === 'de' ? 'Gherkin-Generierung' : 'Gherkin generation'],
                  ['rating', lang === 'de' ? 'Bewertung' : 'Rating'],
                  ['table-identification', lang === 'de' ? 'Tabellen-Identifikation' : 'Table identification'],
                  ['kb-keywords', lang === 'de' ? 'KB-Stichpunkte' : 'KB keywords'],
                  ['excel-transform', lang === 'de' ? 'Excel-Transform-Agent' : 'Excel transform agent'],
                  ['excel-mapping', lang === 'de' ? 'Excel-Mapping-Agent' : 'Excel mapping agent'],
                  ...(experimentalFeatures ? ([
                    ['fop-analyst', lang === 'de' ? 'FOP Inhaltsanalyst' : 'FOP content analyst'],
                    ['fop-guidelines', lang === 'de' ? 'FOP Richtlinienprüfer' : 'FOP guidelines checker'],
                  ] as [string, string][]) : []),
                ] as [string, string][]).map(([task, label]) => (
                  <div key={task} style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 4 }}>
                    <span style={{ fontSize: '0.8rem', minWidth: 160 }}>{label}</span>
                    <span style={{ fontSize: '0.8rem', fontFamily: 'monospace', color: 'var(--color-text-muted)' }}>
                      {task === 'gherkin-generation' || task === 'rating' ? model : getTaskModel(task as AiTaskKey)}
                    </span>
                  </div>
                ))}
              </div>
            </>
          )}

          </>}

          {/* ── TAB: General Settings ──────────────────────────── */}
          {settingsTab === 'general' && <>

          {/* ── Shared Settings Folder ────────────── */}
          <div className={styles.section}>
            <span className={styles.sectionLabel}>{t('settings.sharedTitle')}</span>
            <p style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', margin: '2px 0 0' }}>
              {t('settings.sharedDesc')}
            </p>
            <div className={styles.sharedSettingsRow}>
              <span className={sharedSettingsConfigured ? styles.sharedSettingsValueOk : styles.sharedSettingsValueMissing}>
                {sharedSettingsLoading
                  ? t('settings.loading')
                  : sharedSettingsFolderName || t('settings.sharedFolderMissing')}
              </span>
              <div className={styles.sharedSettingsActions}>
                <button className={styles.saveBtn} onClick={handleChooseSharedSettingsFolder} type="button">
                  📁 {t('settings.sharedChooseFolder')}
                </button>
                <button className={styles.clearBtn} onClick={handleClearSharedSettingsFolder} type="button" disabled={!sharedSettingsConfigured}>
                  {t('settings.clear')}
                </button>
                <button className={styles.saveBtn} onClick={handleExportSettingsJson} type="button" disabled={!sharedSettingsConfigured}>
                  {t('settings.export')}
                </button>
                <label
                  className={`${styles.saveBtn} ${!sharedSettingsConfigured ? styles.sharedSettingsDisabled : ''}`}
                  style={{ display: 'inline-flex', alignItems: 'center', cursor: sharedSettingsConfigured ? 'pointer' : 'not-allowed' }}
                >
                  {t('settings.import')}
                  <input
                    ref={sharedSettingsFileRef}
                    type="file"
                    accept="application/json,.json"
                    onChange={handleImportSettingsJson}
                    style={{ display: 'none' }}
                    disabled={!sharedSettingsConfigured}
                  />
                </label>
              </div>
            </div>
            {!sharedSettingsConfigured && !sharedSettingsLoading && (
              <span style={{ fontSize: '0.76rem', color: 'var(--color-danger)' }}>
                {t('settings.sharedRequiredHint')}
              </span>
            )}
            {sharedSettingsError && (
              <span style={{ fontSize: '0.8rem', color: 'var(--color-danger)' }}>{sharedSettingsError}</span>
            )}
          </div>

          <div className={styles.divider} />

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
                className={forceKiTableId ? styles.toggleSwitchActive : styles.toggleSwitch}
              >
                {forceKiTableId
                  ? (lang === 'de' ? 'AN' : 'ON')
                  : (lang === 'de' ? 'AUS' : 'OFF')}
              </button>
            </div>
          </div>

          <div className={styles.divider} />

          {/* ── Agent max output tokens ────────────── */}
          <div className={styles.section}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 0' }}>
              <div>
                <span className={styles.sectionLabel} style={{ fontSize: '0.8rem' }}>
                  🧠 {lang === 'de' ? 'Agent Max-Output-Tokens' : 'Agent max output tokens'}
                </span>
                <p style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', margin: '2px 0 0' }}>
                  {lang === 'de'
                    ? 'Wird beim Erstellen/Aktualisieren des Agents als maxTokens gesetzt. Hilft gegen abgeschnittene Antworten.'
                    : 'Applied as maxTokens when creating/updating agents. Helps prevent truncated answers.'}
                </p>
              </div>
              <div style={{ display: 'inline-flex', alignItems: 'center', gap: 6, flexShrink: 0, marginLeft: 12 }}>
                <input
                  type="number"
                  min={256}
                  max={200000}
                  step={256}
                  value={agentMaxTokens}
                  onChange={(e) => handleAgentMaxTokensChange(e.target.value)}
                  aria-label={lang === 'de' ? 'Agent Max-Output-Tokens' : 'Agent max output tokens'}
                  style={{
                    width: 110,
                    padding: '4px 8px',
                    border: '1px solid var(--color-border)',
                    borderRadius: 'var(--radius)',
                    fontSize: '0.85rem',
                    background: 'var(--color-surface)',
                    color: 'var(--color-text)',
                  }}
                />
              </div>
            </div>
          </div>

          <div className={styles.divider} />

          {/* ── KI-Timeout ────────────── */}
          <div className={styles.section}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 0' }}>
              <div>
                <span className={styles.sectionLabel} style={{ fontSize: '0.8rem' }}>
                  ⏳ {t('docx.aiTimeout')}
                </span>
                <p style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', margin: '2px 0 0' }}>
                  {t('docx.aiTimeoutHint')}
                </p>
              </div>
              <div style={{ display: 'inline-flex', alignItems: 'center', gap: 6, flexShrink: 0, marginLeft: 12 }}>
                <input
                  type="number"
                  min={60}
                  max={1800}
                  step={30}
                  value={aiTimeoutSeconds}
                  onChange={(e) => handleAiTimeoutChange(e.target.value)}
                  aria-label={t('docx.aiTimeoutAria')}
                  style={{
                    width: 80,
                    padding: '4px 8px',
                    border: '1px solid var(--color-border)',
                    borderRadius: 'var(--radius)',
                    fontSize: '0.85rem',
                    background: 'var(--color-surface)',
                    color: 'var(--color-text)',
                  }}
                />
                <span style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>{t('docx.aiTimeoutUnit')}</span>
              </div>
            </div>
          </div>

          <div className={styles.divider} />

          {/* ── Feldprüfungs-Szenarien ────────────── */}
          <div className={styles.section}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 0' }}>
              <div>
                <span className={styles.sectionLabel} style={{ fontSize: '0.8rem' }}>
                  🔍 {lang === 'de' ? 'Feldprüfungs-Szenarien generieren' : 'Generate field-check scenarios'}
                </span>
                <p style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', margin: '2px 0 0' }}>
                  {lang === 'de'
                    ? 'AUS: Keine reinen "Then field X is modifiable"-Szenarien — nur funktionale Tests. Sinnvoll wenn die Testgrundlage die Feldexistenz bereits garantiert.'
                    : 'OFF: No pure "Then field X is modifiable" scenarios — only functional tests. Useful when the test basis already guarantees field existence.'}
                </p>
              </div>
              <button
                onClick={handleIncludeFieldChecksToggle}
                type="button"
                className={includeFieldChecks ? styles.toggleSwitchActive : styles.toggleSwitch}
              >
                {includeFieldChecks
                  ? (lang === 'de' ? 'AN' : 'ON')
                  : (lang === 'de' ? 'AUS' : 'OFF')}
              </button>
            </div>
          </div>

          <div className={styles.divider} />

          {/* ── MFT Tageslimit ────────────── */}
          <div className={styles.section}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 0' }}>
              <div>
                <span className={styles.sectionLabel} style={{ fontSize: '0.8rem' }}>
                  ⏱ {lang === 'de' ? 'MFT-Tageslimit' : 'MFT daily limit'}
                </span>
                <p style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', margin: '2px 0 0' }}>
                  {mftDailyLimitHit
                    ? (lang === 'de'
                      ? 'Aktuell: Tageslimit erreicht — KI-Anfragen werden blockiert. Wird bei Tageswechsel automatisch freigegeben.'
                      : 'Currently: daily limit hit — AI requests are blocked. Auto-releases at midnight.')
                    : (lang === 'de'
                      ? 'Aktuell: keine Token-Sperre aktiv. Falls die Sperre fälschlich gesetzt sein sollte, kannst du sie hier manuell zurücksetzen.'
                      : 'Currently: no token limit active. If the flag is stuck, you can manually reset it here.')}
                </p>
              </div>
              <button
                onClick={handleResetDailyLimit}
                disabled={!mftDailyLimitHit}
                type="button"
                className={mftDailyLimitHit ? styles.toggleSwitchDanger : styles.toggleSwitch}
              >
                {lang === 'de' ? 'Zurücksetzen' : 'Reset'}
              </button>
            </div>
          </div>

          <div className={styles.divider} />

          {/* ── Test Depth ─────────────── */}
          <div className={styles.section}>
            <span className={styles.sectionLabel} style={{ fontSize: '0.8rem', textTransform: 'uppercase', letterSpacing: '0.03em' }}>
              🧪 {lang === 'de' ? 'Testtiefe' : 'Test Depth'}
            </span>
            <div className={styles.segmentGroup}>
              <button
                type="button"
                onClick={() => { setTestDepthState('quick'); setTestDepth('quick'); void persistSharedSettingsIfConfigured(); }}
                className={testDepthState === 'quick' ? styles.segmentBtnActive : styles.segmentBtn}
              >
                {lang === 'de' ? 'Schnelltest' : 'Quick Test'}
              </button>
              <button
                type="button"
                onClick={() => { setTestDepthState('deep'); setTestDepth('deep'); void persistSharedSettingsIfConfigured(); }}
                className={testDepthState === 'deep' ? styles.segmentBtnActive : styles.segmentBtn}
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
                onClick={() => { const next = !kbEnabled; setKbEnabledState(next); setKnowledgeBaseEnabled(next); void persistSharedSettingsIfConfigured(); }}
                type="button"
                className={kbEnabled ? styles.toggleSwitchActive : styles.toggleSwitch}
              >
                {kbEnabled ? (lang === 'de' ? 'AN' : 'ON') : (lang === 'de' ? 'AUS' : 'OFF')}
              </button>
            </div>
            <p style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', margin: '2px 0 0' }}>
              {lang === 'de'
                ? 'Durchsucht HTML-Dokumentation nach relevanten Abschnitten für die Testgenerierung'
                : 'Searches HTML documentation for relevant sections during test generation'}
            </p>

            {kbEnabled && (
              <div style={{ marginTop: 8, display: 'flex', flexDirection: 'column', gap: 6 }}>
                {/* Max Chunks */}
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                    {lang === 'de' ? 'Max. Hilfe-Einträge pro Stichpunkt:' : 'Max help entries per keyword:'}
                  </span>
                  <select
                    value={kbMaxChunks}
                    onChange={e => { const v = parseInt(e.target.value, 10); setKbMaxChunksState(v); setKBMaxChunksSetting(v); void persistSharedSettingsIfConfigured(); }}
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
                    onClick={() => { const next = !kbChains; setKbChainsState(next); setKBChainsEnabled(next); void persistSharedSettingsIfConfigured(); }}
                    type="button"
                    className={kbChains ? styles.toggleSwitchActive : styles.toggleSwitch}
                  >
                    {kbChains ? (lang === 'de' ? 'AN' : 'ON') : (lang === 'de' ? 'AUS' : 'OFF')}
                  </button>
                </div>

                {/* Keyword Extraction (Agent) */}
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                    {lang === 'de' ? 'Stichpunkt-Extraktion durch Agent:' : 'Agent keyword extraction:'}
                  </span>
                  <button
                    onClick={() => { const next = !kbKwExtract; setKbKwExtractState(next); setKBKeywordExtractionEnabled(next); void persistSharedSettingsIfConfigured(); }}
                    type="button"
                    className={kbKwExtract ? styles.toggleSwitchActive : styles.toggleSwitch}
                  >
                    {kbKwExtract ? (lang === 'de' ? 'AN' : 'ON') : (lang === 'de' ? 'AUS' : 'OFF')}
                  </button>
                </div>

                {kbKwExtract && (
                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                    <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                      {lang === 'de' ? 'Anzahl Stichpunkte:' : 'Number of keywords:'}
                    </span>
                    <select
                      value={kbKwCount}
                      onChange={e => { const v = parseInt(e.target.value, 10); setKbKwCountState(v); setKBKeywordCountSetting(v); void persistSharedSettingsIfConfigured(); }}
                      style={{ padding: '2px 8px', fontSize: '0.75rem', borderRadius: 'var(--radius)', border: '1px solid var(--color-border)' }}
                    >
                      {[3, 5, 7, 10, 15].map(n => <option key={n} value={n}>{n}</option>)}
                    </select>
                  </div>
                )}

                {kbKwExtract && (
                  <p style={{ fontSize: '0.68rem', color: 'var(--color-text-muted)', margin: '0 0 0 2px' }}>
                    {lang === 'de'
                      ? 'Der Agent nennt thematische Fachbegriffe zum Arbeitspaket (z. B. „Chargenpflicht"), die zusätzlich zur Tabellen-Suche die KB durchsuchen. Kostet einen extra AI-Call pro Generierung.'
                      : 'The agent names thematic terms for the work package (e.g. "batch requirement") which are additionally matched against the KB. Costs one extra AI call per generation.'}
                  </p>
                )}

              </div>
            )}
          </div>

          {devMode && <div className={styles.divider} />}

          {/* ── Experimental Features Toggle (dev-only, gated by ?dev=true) ─── */}
          {devMode && (
          <div className={styles.section}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 0' }}>
              <span className={styles.sectionLabel} style={{ fontSize: '0.8rem' }}>
                ⚗ {lang === 'de' ? 'Experimentelle Features' : 'Experimental Features'}
              </span>
              <button
                onClick={handleExperimentalToggle}
                type="button"
                className={experimentalFeatures ? styles.toggleSwitchActive : styles.toggleSwitch}
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
          )}

          </>}

          {/* ── TAB: Prompts ───────────────────────────────────── */}
          {settingsTab === 'prompts' && <>

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

          {/* ── Learning Suggestion Prompt — Cucumber Agent ───── */}
          <div className={styles.section}>
            <button
              className={styles.promptToggle}
              onClick={() => setLearningSuggestionPromptOpen(!learningSuggestionPromptOpen)}
              type="button"
            >
              <span className={styles.sectionLabel}>
                {learningSuggestionPromptCustomized ? 'Learning-Vorschlag Prompt ★' : 'Learning-Vorschlag Prompt'}
                {' '}— Cucumber Agent
              </span>
              <span className={styles.promptArrow}>{learningSuggestionPromptOpen ? '\u25B2' : '\u25BC'}</span>
            </button>

            {learningSuggestionPromptOpen && (
              <div className={styles.promptEditor}>
                <textarea
                  className={styles.promptTextarea}
                  value={learningSuggestionPromptText}
                  onChange={(e) => setLearningSuggestionPromptText(e.target.value)}
                  rows={14}
                  spellCheck={false}
                />
                <div className={styles.promptActions}>
                  <button className={styles.saveBtn} onClick={handleLearningSuggestionPromptSave} type="button">
                    {t('settings.save')}
                  </button>
                  <button className={styles.clearBtn} onClick={handleLearningSuggestionPromptReset} type="button">
                    {t('settings.reset')}
                  </button>
                </div>
                <p style={{ marginTop: 6, fontSize: '0.72rem', color: 'var(--color-text-muted)' }}>
                  {lang === 'de'
                    ? 'Hinweis: Verwende {{USER_TEXT}} als Platzhalter fuer die freie Eingabe aus dem Learning-Tab.'
                    : 'Note: Use {{USER_TEXT}} as placeholder for the free-text input from the Learning tab.'}
                </p>
              </div>
            )}
          </div>

          {/* ── Feature Edit Prompt — Cucumber Agent ───── */}
          <div className={styles.section}>
            <button
              className={styles.promptToggle}
              onClick={() => setFeatureEditPromptOpen(!featureEditPromptOpen)}
              type="button"
            >
              <span className={styles.sectionLabel}>
                {featureEditPromptCustomized ? (lang === 'de' ? 'Feature-Edit Prompt ★' : 'Feature Edit Prompt ★') : (lang === 'de' ? 'Feature-Edit Prompt' : 'Feature Edit Prompt')}
                {' '}— Cucumber Agent
              </span>
              <span className={styles.promptArrow}>{featureEditPromptOpen ? '\u25B2' : '\u25BC'}</span>
            </button>

            {featureEditPromptOpen && (
              <div className={styles.promptEditor}>
                <textarea
                  className={styles.promptTextarea}
                  value={featureEditPromptText}
                  onChange={(e) => setFeatureEditPromptText(e.target.value)}
                  rows={16}
                  spellCheck={false}
                />
                <div className={styles.promptActions}>
                  <button className={styles.saveBtn} onClick={handleFeatureEditPromptSave} type="button">
                    {t('settings.save')}
                  </button>
                  <button className={styles.clearBtn} onClick={handleFeatureEditPromptReset} type="button">
                    {t('settings.reset')}
                  </button>
                </div>
                <p style={{ marginTop: 6, fontSize: '0.72rem', color: 'var(--color-text-muted)' }}>
                  {lang === 'de'
                    ? 'Platzhalter: {{CHANGE_REQUEST}} und {{CURRENT_FILE}} werden beim Editieren ersetzt.'
                    : 'Placeholders: {{CHANGE_REQUEST}} and {{CURRENT_FILE}} are replaced during editing.'}
                </p>
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
                  <button className={styles.saveBtn} onClick={() => { const v = fieldRulesText.trim(); if (v === getDefaultFieldRules(currentLang).trim()) { clearCustomFieldRulesSetting(currentLang); setFieldRulesCustomized(false); } else { setCustomFieldRulesSetting(currentLang, v); setFieldRulesCustomized(true); } void persistSharedSettingsIfConfigured(); }} type="button">{t('settings.save')}</button>
                  <button className={styles.clearBtn} onClick={() => { clearCustomFieldRulesSetting(currentLang); setFieldRulesText(getDefaultFieldRules(currentLang)); setFieldRulesCustomized(false); void persistSharedSettingsIfConfigured(); }} type="button">{t('settings.reset')}</button>
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
                  <button className={styles.saveBtn} onClick={() => { const v = quickTestText.trim(); if (v === getDefaultQuickTestPrompt(currentLang).trim()) { clearCustomQuickTestSetting(currentLang); setQuickTestCustomized(false); } else { setCustomQuickTestSetting(currentLang, v); setQuickTestCustomized(true); } void persistSharedSettingsIfConfigured(); }} type="button">{t('settings.save')}</button>
                  <button className={styles.clearBtn} onClick={() => { clearCustomQuickTestSetting(currentLang); setQuickTestText(getDefaultQuickTestPrompt(currentLang)); setQuickTestCustomized(false); void persistSharedSettingsIfConfigured(); }} type="button">{t('settings.reset')}</button>
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
                  <button className={styles.saveBtn} onClick={() => { const v = deepTestText.trim(); if (v === getDefaultDeepTestPrompt(currentLang).trim()) { clearCustomDeepTestSetting(currentLang); setDeepTestCustomized(false); } else { setCustomDeepTestSetting(currentLang, v); setDeepTestCustomized(true); } void persistSharedSettingsIfConfigured(); }} type="button">{t('settings.save')}</button>
                  <button className={styles.clearBtn} onClick={() => { clearCustomDeepTestSetting(currentLang); setDeepTestText(getDefaultDeepTestPrompt(currentLang)); setDeepTestCustomized(false); void persistSharedSettingsIfConfigured(); }} type="button">{t('settings.reset')}</button>
                </div>
              </div>
            )}
          </div>

          {/* ── Dialog-Katalog (Standard-abas-Meldungs-IDs) ───────────── */}
          <div className={styles.section}>
            <button
              className={styles.promptToggle}
              onClick={() => setDialogCatalogOpen(v => !v)}
              type="button"
            >
              <span className={styles.promptTitle}>
                {dialogCatalogCustomized ? '★ ' : ''}
                {lang === 'de' ? 'Dialog-Katalog (Standard-IDs)' : 'Dialog Catalog (Standard IDs)'}
              </span>
              <span className={styles.promptArrow}>{dialogCatalogOpen ? '▴' : '▾'}</span>
            </button>
            {dialogCatalogOpen && (
              <div className={styles.promptEditor}>
                <div style={{ fontSize: '0.85em', opacity: 0.8, marginBottom: '0.5em' }}>
                  {lang === 'de'
                    ? 'Bekannte numerische abas-Standard-Dialog-IDs (z.B. "4841" bei Rechnungsbuchung). Werden beim Generieren in den User-Prompt injiziert — die KI kann die passende ID dann direkt verwenden. Individuelle Customizing-Dialoge (FOP-Boxen) laufen uebers Titel-Text, NICHT ueber diesen Katalog. JSON-Format: { "id": { "kontext": "...", "text": "...", "standardAntwort": "ja", "triggerCommand": "INVOICE" } }'
                    : 'Known numeric abas standard dialog IDs (e.g. "4841" for invoice posting). Injected into the user prompt during generation — the AI can then use the right ID directly. Individual customizing dialogs (FOP boxes) are referenced by title text, NOT via this catalog. JSON format: { "id": { "kontext": "...", "text": "...", "standardAntwort": "ja", "triggerCommand": "INVOICE" } }'}
                </div>
                <textarea
                  className={styles.promptTextarea}
                  rows={12}
                  value={dialogCatalogText}
                  onChange={e => { setDialogCatalogText(e.target.value); setDialogCatalogError(null); }}
                  spellCheck={false}
                />
                {dialogCatalogError && (
                  <div style={{ color: 'var(--error, #c33)', fontSize: '0.85em', marginTop: '0.25em' }}>
                    {lang === 'de' ? 'JSON-Fehler: ' : 'JSON error: '}{dialogCatalogError}
                  </div>
                )}
                <div className={styles.promptActions}>
                  <button className={styles.saveBtn} onClick={handleDialogCatalogSave} type="button">
                    {t('settings.save')}
                  </button>
                  <button className={styles.clearBtn} onClick={handleDialogCatalogReset} type="button">
                    {t('settings.reset')}
                  </button>
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
