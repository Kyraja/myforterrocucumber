import { useState, useRef, useEffect } from 'react';
import type { ParseProfile, CustomActionPattern } from '../../types/gherkin';
import {
  setModel as saveModel,
  getCustomSystemPrompt, setCustomSystemPrompt, clearCustomSystemPrompt,
  getCustomTableIdPrompt, setCustomTableIdPrompt, clearCustomTableIdPrompt,
  getCustomRatingPrompt, setCustomRatingPrompt, clearCustomRatingPrompt,
} from '../../lib/settings';
import { DEFAULT_SYSTEM_PROMPT, DEFAULT_TABLE_ID_PROMPT, DEFAULT_RATING_PROMPT } from '../../lib/aiPrompt';
import {
  initiateLogin,
  logout,
  isLoggedIn,
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
import { useTranslation, type TranslationFn } from '../../i18n';
import styles from './SettingsPanel.module.css';

interface SettingsPanelProps {
  loggedIn: boolean;
  onLoginChange: (loggedIn: boolean) => void;
  model: string;
  onModelChange: (model: string) => void;
  onSystemPromptChange?: () => void;
}

export function SettingsPanel({ loggedIn, onLoginChange, model, onModelChange, onSystemPromptChange }: SettingsPanelProps) {
  const { t } = useTranslation();
  const [open, setOpen] = useState(false);

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
    <div className={styles.container}>
      <button
        className={`${styles.toggle} ${loggedIn ? styles.toggleActive : ''}`}
        onClick={() => setOpen(!open)}
        type="button"
      >
        {toggleLabel}
      </button>

      {open && (
        <div className={styles.panel}>
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
            </>
          )}

          <div className={styles.divider} />

          {/* ── System Prompt (unchanged) ─────────────────── */}
          <div className={styles.section}>
            <button
              className={styles.promptToggle}
              onClick={() => setPromptOpen(!promptOpen)}
              type="button"
            >
              <span className={styles.sectionLabel}>
                {promptCustomized ? t('settings.systemPromptCustomized') : t('settings.systemPrompt')}
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

          {/* ── Table-Identification Prompt ─────────────────── */}
          <div className={styles.section}>
            <button
              className={styles.promptToggle}
              onClick={() => setTableIdPromptOpen(!tableIdPromptOpen)}
              type="button"
            >
              <span className={styles.sectionLabel}>
                {tableIdPromptCustomized ? t('settings.tableIdPromptCustomized') : t('settings.tableIdPrompt')}
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

          {/* ── Rating Prompt ───────────────────────────────── */}
          <div className={styles.section}>
            <button
              className={styles.promptToggle}
              onClick={() => setRatingPromptOpen(!ratingPromptOpen)}
              type="button"
            >
              <span className={styles.sectionLabel}>
                {ratingPromptCustomized ? t('settings.ratingPromptCustomized') : t('settings.ratingPrompt')}
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

          <div className={styles.divider} />

          {/* ── Import-Profile Section (unchanged) ─────────── */}
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
