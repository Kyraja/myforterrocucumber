import type { ParseProfile } from '../types/gherkin';

// ── Default profile (matches current hardcoded behavior) ─────

export const DEFAULT_PARSE_PROFILE: ParseProfile = {
  id: 'default',
  name: 'Standard',

  keywords: {
    feature: ['Feature'],
    database: ['Datenbank', 'DB', 'Database'],
    testUser: ['Testbenutzer', 'Benutzer', 'Login', 'Test User', 'User'],
    tags: ['Tags'],
    description: ['Beschreibung', 'Description'],
    scenario: ['Szenario', 'Testfall', 'Scenario', 'Test Case'],
    comment: ['Kommentar', 'Comment'],
  },

  stepKeywords: {
    precondition: ['Vorbedingung', 'Voraussetzung', 'Gegeben', 'Precondition', 'Given'],
    action: ['Aktion', 'Wenn', 'Action', 'When'],
    result: ['Ergebnis', 'Dann', 'Erwartung', 'Pruefung', 'Result', 'Expected', 'Then'],
    and: ['Und', 'And'],
    but: ['Aber', 'But'],
  },

  splitting: {
    headingLevels: [1, 2],
    technicalSectionKeywords: ['Technische Umsetzung', 'Technical Implementation'],
  },

  customActions: [],
};

export const EINFUEHRUNGSKONZEPT_PROFILE: ParseProfile = {
  id: 'einfuehrungskonzept',
  name: 'Einführungskonzept (Forterro)',

  keywords: { ...DEFAULT_PARSE_PROFILE.keywords },
  stepKeywords: { ...DEFAULT_PARSE_PROFILE.stepKeywords },

  splitting: {
    headingLevels: [2, 3],
    technicalSectionKeywords: [],
    contentEndKeywords: [
      'Auswirkungen der Customization/Extension',
      'Auswirkungen der Customization',
      'Auswirkungen der Extension',
    ],
  },

  customActions: [],
};

// ── localStorage persistence ─────────────────────────────────

const PROFILES_STORAGE = 'cucumbergnerator_parse_profiles';
const ACTIVE_PROFILE_STORAGE = 'cucumbergnerator_active_profile';

export function loadProfiles(): ParseProfile[] {
  const json = localStorage.getItem(PROFILES_STORAGE);
  if (!json) return [];
  try {
    const data = JSON.parse(json);
    return Array.isArray(data) ? data : [];
  } catch {
    return [];
  }
}

export function saveProfiles(profiles: ParseProfile[]): void {
  localStorage.setItem(PROFILES_STORAGE, JSON.stringify(profiles));
}

export function getActiveProfileId(): string {
  return localStorage.getItem(ACTIVE_PROFILE_STORAGE) || 'default';
}

export function setActiveProfileId(id: string): void {
  localStorage.setItem(ACTIVE_PROFILE_STORAGE, id);
}

/**
 * Returns the active profile. Falls back to DEFAULT if the stored ID
 * doesn't match any saved profile.
 */
export function getActiveProfile(): ParseProfile {
  const id = getActiveProfileId();
  if (id === 'default') return DEFAULT_PARSE_PROFILE;
  const profiles = loadProfiles();
  return profiles.find((p) => p.id === id) ?? DEFAULT_PARSE_PROFILE;
}

/**
 * Returns all available profiles: default + user-created.
 */
export function getAllProfiles(): ParseProfile[] {
  return [DEFAULT_PARSE_PROFILE, EINFUEHRUNGSKONZEPT_PROFILE, ...loadProfiles()];
}

// ── Export / Import (JSON file sharing) ──────────────────────

export function exportProfileAsJson(profile: ParseProfile): void {
  const json = JSON.stringify(profile, null, 2);
  const blob = new Blob([json], { type: 'application/json;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `parse-profile-${profile.name.toLowerCase().replace(/\s+/g, '-')}.json`;
  a.click();
  URL.revokeObjectURL(url);
}

export function parseProfileFromJson(json: string): ParseProfile | null {
  try {
    const data = JSON.parse(json);
    if (!data || typeof data.name !== 'string' || !data.keywords || !data.stepKeywords) {
      return null;
    }
    // Assign new ID to avoid collisions
    return { ...data, id: crypto.randomUUID() } as ParseProfile;
  } catch {
    return null;
  }
}

/**
 * Creates a new empty profile based on the default, with a given name.
 */
export function createNewProfile(name: string): ParseProfile {
  return {
    ...structuredClone(DEFAULT_PARSE_PROFILE),
    id: crypto.randomUUID(),
    name,
  };
}
