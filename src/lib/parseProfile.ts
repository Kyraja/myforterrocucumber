/**
 * @module parseProfile
 *
 * Parse profile management for document import customization.
 *
 * A {@link ParseProfile} controls how the consultant template parser interprets
 * keyword prefixes ("Feature:", "Szenario:", "Aktion:", etc.), which heading
 * levels to split documents on, and any custom action regex patterns.
 *
 * Three built-in profiles are provided:
 * - {@link DEFAULT_PARSE_PROFILE} — standard German keywords
 * - {@link EINFUEHRUNGSKONZEPT_PROFILE} — Forterro introduction-concept format
 * - {@link CONFLUENCE_TESTDATEN_PROFILE} — Confluence test data tables (h4 level)
 *
 * User-created profiles are persisted in localStorage and can be exported/
 * imported as JSON files for sharing between consultants.
 */

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

export const CONFLUENCE_TESTDATEN_PROFILE: ParseProfile = {
  id: 'confluence-testdaten',
  name: 'Confluence Testdaten',

  keywords: { ...DEFAULT_PARSE_PROFILE.keywords },
  stepKeywords: { ...DEFAULT_PARSE_PROFILE.stepKeywords },

  splitting: {
    headingLevels: [4],
    technicalSectionKeywords: [],
  },

  customActions: [],
};

// ── localStorage persistence ─────────────────────────────────

const PROFILES_STORAGE = 'cucumbergnerator_parse_profiles';
const ACTIVE_PROFILE_STORAGE = 'cucumbergnerator_active_profile';

/**
 * Loads all user-created profiles from localStorage.
 * Returns an empty array if none exist or the stored JSON is invalid.
 */
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

/**
 * Persists the full list of user-created profiles to localStorage,
 * replacing any previously stored profiles.
 *
 * @param profiles - The complete array of profiles to persist
 */
export function saveProfiles(profiles: ParseProfile[]): void {
  localStorage.setItem(PROFILES_STORAGE, JSON.stringify(profiles));
}

/**
 * Returns the id of the currently active profile as stored in localStorage.
 * Defaults to `"default"` if nothing has been set.
 */
export function getActiveProfileId(): string {
  return localStorage.getItem(ACTIVE_PROFILE_STORAGE) || 'default';
}

/**
 * Persists the active profile id to localStorage.
 *
 * @param id - The profile id to activate
 */
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
  return [DEFAULT_PARSE_PROFILE, EINFUEHRUNGSKONZEPT_PROFILE, CONFLUENCE_TESTDATEN_PROFILE, ...loadProfiles()];
}

// ── Export / Import (JSON file sharing) ──────────────────────

/**
 * Triggers a browser download of the given profile as a JSON file.
 * Used to share custom profiles between consultants.
 *
 * @param profile - The profile to export
 */
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

/**
 * Parses a JSON string into a ParseProfile, assigning a fresh UUID to avoid
 * id collisions when importing profiles created on another machine.
 *
 * @param json - Raw JSON string, typically from a previously exported profile file
 * @returns The parsed profile, or null if the JSON is invalid or missing required fields
 */
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
