import { describe, expect, it } from 'vitest';
import { buildFeatureEditMessage, extractEditedFeatureGherkin, getDefaultFeatureEditPrompt } from './featureEditPrompt';
import { clearCustomFeatureEditPrompt, setCustomFeatureEditPrompt } from './settings';

describe('buildFeatureEditMessage', () => {
  it('uses the editable feature-edit template with placeholders', () => {
    const message = buildFeatureEditMessage(
      'Feature: Demo\n\n  Scenario: A\n    Given x',
      'Fuege ein Feld hinzu',
      'de',
    );

    expect(getDefaultFeatureEditPrompt('de')).toContain('{{CHANGE_REQUEST}}');
    expect(getDefaultFeatureEditPrompt('de')).toContain('{{CURRENT_FILE}}');
    expect(message).toContain('Fuege ein Feld hinzu');
    expect(message).toContain('Feature: Demo');
  });

  it('contains change request and current gherkin', () => {
    const message = buildFeatureEditMessage(
      'Feature: Demo\n\n  Scenario: A\n    Given x',
      'Ersetze alle K mit T',
      'de',
    );

    expect(message).toContain('Aenderungswunsch');
    expect(message).toContain('Ersetze alle K mit T');
    expect(message).toContain('Feature: Demo');
  });

  it('honors a custom editable feature-edit prompt from storage', () => {
    setCustomFeatureEditPrompt('de', 'CUSTOM EDIT PROMPT\nREQUEST: {{CHANGE_REQUEST}}\nFILE: {{CURRENT_FILE}}');

    const message = buildFeatureEditMessage(
      'Feature: Demo\n\n  Scenario: A\n    Given x',
      'Nur Kommentar anpassen',
      'de',
    );

    clearCustomFeatureEditPrompt('de');
    expect(message).toContain('CUSTOM EDIT PROMPT');
    expect(message).toContain('REQUEST: Nur Kommentar anpassen');
    expect(message).toContain('FILE: Feature: Demo');
  });
});

describe('extractEditedFeatureGherkin', () => {
  it('strips markdown fence and explanatory prefix', () => {
    const cleaned = extractEditedFeatureGherkin(
      'Hier ist die angepasste Datei:\n```gherkin\n@guid-abc\nFeature: Demo\n\n  Scenario: A\n    Given x\n```',
    );

    expect(cleaned.startsWith('@guid-abc')).toBe(true);
    expect(cleaned).toContain('Feature: Demo');
    expect(cleaned).not.toContain('```');
  });

  it('removes FEATURE_END marker when present', () => {
    const cleaned = extractEditedFeatureGherkin(
      'Feature: Demo\n\n  Scenario: A\n    Given x\n# FEATURE_END',
    );

    expect(cleaned).not.toContain('FEATURE_END');
  });
});