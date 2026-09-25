import { beforeEach, describe, expect, it } from 'vitest';
import type { FeatureInput } from '../types/gherkin';
import {
  deleteFeatureTemplate,
  exportFeatureTemplatesJson,
  getFeatureTemplate,
  importFeatureTemplates,
  loadFeatureTemplates,
  saveFeatureTemplate,
} from './settings';

const makeFeature = (name: string): FeatureInput => ({
  name,
  description: `${name} description`,
  tags: ['@smoke'],
  database: null,
  testUser: 'sy',
  scenarios: [
    {
      id: `${name}-scenario`,
      name: `${name} scenario`,
      steps: [
        {
          id: `${name}-step`,
          keyword: 'Given',
          text: 'a saved template exists',
          action: { type: 'freetext' },
        },
      ],
    },
  ],
});

beforeEach(() => {
  localStorage.clear();
});

describe('feature template persistence', () => {
  it('saves and loads templates sorted by most recent update', () => {
    saveFeatureTemplate('Erste Vorlage', makeFeature('First'));
    saveFeatureTemplate('Zweite Vorlage', makeFeature('Second'));

    const templates = loadFeatureTemplates();
    expect(templates).toHaveLength(2);
    expect(templates[0].name).toBe('Zweite Vorlage');
    expect(templates[1].name).toBe('Erste Vorlage');
  });

  it('returns a deep-cloned feature when loading a saved template', () => {
    const feature = makeFeature('Original');
    saveFeatureTemplate('Vorlage A', feature);

    feature.name = 'Mutated';
    feature.scenarios[0].name = 'Changed later';

    const loaded = getFeatureTemplate('Vorlage A');
    expect(loaded).not.toBeNull();
    expect(loaded?.name).toBe('Original');
    expect(loaded?.scenarios[0].name).toBe('Original scenario');
  });

  it('replaces templates with the same name and deletes them again', () => {
    saveFeatureTemplate('Vorlage A', makeFeature('First'));
    saveFeatureTemplate('Vorlage A', makeFeature('Updated'));

    expect(loadFeatureTemplates()).toHaveLength(1);
    expect(getFeatureTemplate('Vorlage A')?.name).toBe('Updated');

    const remaining = deleteFeatureTemplate('Vorlage A');
    expect(remaining).toEqual([]);
    expect(getFeatureTemplate('Vorlage A')).toBeNull();
  });

  it('exports and re-imports feature templates as JSON', () => {
    saveFeatureTemplate('Vorlage A', makeFeature('First'));
    const json = exportFeatureTemplatesJson();

    localStorage.clear();

    const imported = importFeatureTemplates(json);
    expect(imported).toHaveLength(1);
    expect(imported[0].name).toBe('Vorlage A');
    expect(getFeatureTemplate('Vorlage A')?.name).toBe('First');
  });

  it('merges imported templates by name and keeps imported content on collision', () => {
    saveFeatureTemplate('Vorlage A', makeFeature('Local'));

    const imported = importFeatureTemplates(JSON.stringify([
      {
        name: 'Vorlage A',
        feature: makeFeature('Imported'),
        updatedAt: '2026-07-16T10:00:00.000Z',
      },
      {
        name: 'Vorlage B',
        feature: makeFeature('Second'),
        updatedAt: '2026-07-16T11:00:00.000Z',
      },
    ]));

    expect(imported).toHaveLength(2);
    expect(getFeatureTemplate('Vorlage A')?.name).toBe('Imported');
    expect(getFeatureTemplate('Vorlage B')?.name).toBe('Second');
  });
});