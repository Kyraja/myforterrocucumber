import { describe, it, expect } from 'vitest';
import { validateFeature, hasErrors, hasWarnings } from './featureValidation';
import type { FeatureInput } from '../types/gherkin';

function makeFeature(overrides: Partial<FeatureInput> = {}): FeatureInput {
  return {
    name: 'Test Feature',
    description: '',
    tags: ['@smoke'],
    database: null,
    testUser: 'sy',
    scenarios: [
      {
        id: '1',
        name: 'Happy Path',
        steps: [
          { id: 's1', keyword: 'Given', text: 'I open editor', action: { type: 'editorSpeichern' } },
          { id: 's2', keyword: 'Then', text: 'field ok', action: { type: 'editorSpeichern' } },
        ],
      },
    ],
    ...overrides,
  };
}

describe('validateFeature', () => {
  it('returns no issues for a complete feature', () => {
    const issues = validateFeature(makeFeature());
    expect(issues).toHaveLength(0);
  });

  it('reports error for missing feature name', () => {
    const issues = validateFeature(makeFeature({ name: '' }));
    expect(issues).toContainEqual({ level: 'error', message: 'Kein Feature-Name angegeben' });
  });

  it('reports error for no scenarios', () => {
    const issues = validateFeature(makeFeature({ scenarios: [] }));
    expect(issues).toContainEqual({ level: 'error', message: 'Keine Szenarien erkannt' });
  });

  it('reports error for scenario without steps', () => {
    const issues = validateFeature(makeFeature({
      scenarios: [{ id: '1', name: 'Leer', steps: [] }],
    }));
    expect(issues).toContainEqual({ level: 'error', message: "Szenario 'Leer' hat keine Schritte" });
  });

  it('does not warn for missing test user (optional)', () => {
    const issues = validateFeature(makeFeature({ testUser: '' }));
    expect(issues.some((i) => i.message.includes('Testbenutzer'))).toBe(false);
  });

  it('reports warning for scenario without Given', () => {
    const issues = validateFeature(makeFeature({
      scenarios: [{
        id: '1', name: 'Nur Aktion', steps: [
          { id: 's1', keyword: 'When', text: 'do something', action: { type: 'freetext' } },
          { id: 's2', keyword: 'Then', text: 'check result', action: { type: 'freetext' } },
        ],
      }],
    }));
    expect(issues).toContainEqual({ level: 'warning', message: "'Nur Aktion': Kein Einstiegspunkt (Vorbedingung)" });
  });

  it('reports warning for scenario without Then', () => {
    const issues = validateFeature(makeFeature({
      scenarios: [{
        id: '1', name: 'Nur Vorbedingung', steps: [
          { id: 's1', keyword: 'Given', text: 'open editor', action: { type: 'freetext' } },
          { id: 's2', keyword: 'When', text: 'do action', action: { type: 'freetext' } },
        ],
      }],
    }));
    expect(issues).toContainEqual({ level: 'warning', message: "'Nur Vorbedingung': Keine Pruefung (Ergebnis)" });
  });

  it('reports info for freetext steps', () => {
    const issues = validateFeature(makeFeature({
      scenarios: [{
        id: '1', name: 'Gemischt', steps: [
          { id: 's1', keyword: 'Given', text: 'something', action: { type: 'freetext' } },
          { id: 's2', keyword: 'Then', text: 'check', action: { type: 'freetext' } },
        ],
      }],
    }));
    expect(issues).toContainEqual({
      level: 'info',
      message: "'Gemischt': 2 unstrukturierte Freitext-Schritte",
    });
  });

  it('reports info for single freetext step', () => {
    const issues = validateFeature(makeFeature({
      scenarios: [{
        id: '1', name: 'Eins', steps: [
          { id: 's1', keyword: 'Given', text: 'something', action: { type: 'freetext' } },
          { id: 's2', keyword: 'Then', text: 'check', action: { type: 'editorSpeichern' } },
        ],
      }],
    }));
    expect(issues).toContainEqual({
      level: 'info',
      message: "'Eins': 1 unstrukturierter Freitext-Schritt",
    });
  });
});

describe('hasErrors / hasWarnings', () => {
  it('hasErrors returns true for errors', () => {
    expect(hasErrors([{ level: 'error', message: 'test' }])).toBe(true);
  });

  it('hasErrors returns false for only warnings', () => {
    expect(hasErrors([{ level: 'warning', message: 'test' }])).toBe(false);
  });

  it('hasWarnings returns true for warnings', () => {
    expect(hasWarnings([{ level: 'warning', message: 'test' }])).toBe(true);
  });

  it('hasWarnings returns false for only info', () => {
    expect(hasWarnings([{ level: 'info', message: 'test' }])).toBe(false);
  });
});
