import { describe, it, expect, beforeEach } from 'vitest';
import {
  DEFAULT_PARSE_PROFILE,
  loadProfiles,
  saveProfiles,
  getActiveProfileId,
  setActiveProfileId,
  getActiveProfile,
  getAllProfiles,
  parseProfileFromJson,
  createNewProfile,
} from './parseProfile';

beforeEach(() => {
  localStorage.clear();
});

describe('DEFAULT_PARSE_PROFILE', () => {
  it('has all required keyword arrays', () => {
    expect(DEFAULT_PARSE_PROFILE.keywords.feature).toContain('Feature');
    expect(DEFAULT_PARSE_PROFILE.keywords.scenario).toContain('Szenario');
    expect(DEFAULT_PARSE_PROFILE.stepKeywords.precondition).toContain('Vorbedingung');
    expect(DEFAULT_PARSE_PROFILE.stepKeywords.action).toContain('Aktion');
    expect(DEFAULT_PARSE_PROFILE.stepKeywords.result).toContain('Ergebnis');
  });

  it('has default splitting levels', () => {
    expect(DEFAULT_PARSE_PROFILE.splitting.headingLevels).toEqual([1, 2]);
    expect(DEFAULT_PARSE_PROFILE.splitting.technicalSectionKeywords).toEqual(['Technische Umsetzung', 'Technical Implementation']);
  });

  it('has empty custom actions', () => {
    expect(DEFAULT_PARSE_PROFILE.customActions).toEqual([]);
  });
});

describe('loadProfiles / saveProfiles', () => {
  it('returns empty array when nothing stored', () => {
    expect(loadProfiles()).toEqual([]);
  });

  it('round-trips profiles through localStorage', () => {
    const profile = createNewProfile('Test');
    saveProfiles([profile]);
    const loaded = loadProfiles();
    expect(loaded).toHaveLength(1);
    expect(loaded[0].name).toBe('Test');
  });
});

describe('getActiveProfileId / setActiveProfileId', () => {
  it('defaults to "default"', () => {
    expect(getActiveProfileId()).toBe('default');
  });

  it('returns saved profile ID', () => {
    setActiveProfileId('custom-123');
    expect(getActiveProfileId()).toBe('custom-123');
  });
});

describe('getActiveProfile', () => {
  it('returns DEFAULT when no custom profile active', () => {
    const profile = getActiveProfile();
    expect(profile.id).toBe('default');
  });

  it('returns saved profile when its ID is active', () => {
    const custom = createNewProfile('Custom');
    saveProfiles([custom]);
    setActiveProfileId(custom.id);
    const active = getActiveProfile();
    expect(active.name).toBe('Custom');
  });

  it('falls back to DEFAULT when active ID not found', () => {
    setActiveProfileId('nonexistent');
    expect(getActiveProfile().id).toBe('default');
  });
});

describe('getAllProfiles', () => {
  it('always includes DEFAULT as first entry', () => {
    const all = getAllProfiles();
    expect(all[0].id).toBe('default');
    expect(all).toHaveLength(1);
  });

  it('includes saved profiles after DEFAULT', () => {
    saveProfiles([createNewProfile('A'), createNewProfile('B')]);
    const all = getAllProfiles();
    expect(all).toHaveLength(3);
    expect(all[0].id).toBe('default');
    expect(all[1].name).toBe('A');
    expect(all[2].name).toBe('B');
  });
});

describe('parseProfileFromJson', () => {
  it('parses valid JSON into a profile with new ID', () => {
    const json = JSON.stringify({
      id: 'old-id',
      name: 'Imported',
      keywords: DEFAULT_PARSE_PROFILE.keywords,
      stepKeywords: DEFAULT_PARSE_PROFILE.stepKeywords,
      splitting: DEFAULT_PARSE_PROFILE.splitting,
      customActions: [],
    });

    const result = parseProfileFromJson(json);
    expect(result).not.toBeNull();
    expect(result!.name).toBe('Imported');
    expect(result!.id).not.toBe('old-id'); // Gets new ID
  });

  it('returns null for invalid JSON', () => {
    expect(parseProfileFromJson('not json')).toBeNull();
  });

  it('returns null for JSON without required fields', () => {
    expect(parseProfileFromJson('{"foo":"bar"}')).toBeNull();
  });
});

describe('createNewProfile', () => {
  it('creates a profile based on DEFAULT with a new name and ID', () => {
    const profile = createNewProfile('Mein Profil');
    expect(profile.name).toBe('Mein Profil');
    expect(profile.id).not.toBe('default');
    expect(profile.keywords).toEqual(DEFAULT_PARSE_PROFILE.keywords);
    expect(profile.stepKeywords).toEqual(DEFAULT_PARSE_PROFILE.stepKeywords);
  });
});
