import { describe, it, expect } from 'vitest';
import { parseGherkin } from './gherkinParser';
import { generateGherkin } from './generator';

describe('parseGherkin', () => {
  it('parses a simple feature with one scenario', () => {
    const text = `Feature: User Login

  Scenario: Successful login
    Given the login page is open
    When the user enters valid credentials
    Then the dashboard is displayed
`;
    const result = parseGherkin(text);
    expect(result.name).toBe('User Login');
    expect(result.scenarios).toHaveLength(1);
    expect(result.scenarios[0].name).toBe('Successful login');
    expect(result.scenarios[0].steps).toHaveLength(3);
    expect(result.scenarios[0].steps[0].keyword).toBe('Given');
    expect(result.scenarios[0].steps[0].text).toBe('the login page is open');
    expect(result.scenarios[0].steps[1].keyword).toBe('When');
    expect(result.scenarios[0].steps[2].keyword).toBe('Then');
  });

  it('parses tags before the feature', () => {
    const text = `@smoke @login
Feature: Login
  Scenario: Test
    Given something
`;
    const result = parseGherkin(text);
    expect(result.tags).toEqual(['@smoke', '@login']);
  });

  it('parses a description block', () => {
    const text = `Feature: My Feature
  As a user
  I want to do something
  So that I get value

  Scenario: Test
    Given something
`;
    const result = parseGherkin(text);
    expect(result.description).toBe('As a user\nI want to do something\nSo that I get value');
  });

  it('parses multiple scenarios', () => {
    const text = `Feature: Multi
  Scenario: First
    Given step one
    When step two
  Scenario: Second
    Given step three
    Then step four
`;
    const result = parseGherkin(text);
    expect(result.scenarios).toHaveLength(2);
    expect(result.scenarios[0].name).toBe('First');
    expect(result.scenarios[0].steps).toHaveLength(2);
    expect(result.scenarios[1].name).toBe('Second');
    expect(result.scenarios[1].steps).toHaveLength(2);
  });

  it('parses And and But keywords', () => {
    const text = `Feature: Steps
  Scenario: Mixed
    Given setup
    And more setup
    When action
    But not this
    Then result
`;
    const result = parseGherkin(text);
    const keywords = result.scenarios[0].steps.map((s) => s.keyword);
    expect(keywords).toEqual(['Given', 'And', 'When', 'But', 'Then']);
  });

  it('all parsed steps have freetext action type', () => {
    const text = `Feature: Actions
  Scenario: Test
    Given die Maske "Kunde" (1000) ist geoeffnet
    When das Feld "Name" auf "Test" gesetzt wird
`;
    const result = parseGherkin(text);
    for (const step of result.scenarios[0].steps) {
      expect(step.action).toEqual({ type: 'freetext' });
    }
  });

  it('round-trips: parse then generate produces equivalent output', () => {
    const original = `Feature: Round Trip

  Scenario: First scenario
    Given first step
    When second step
    Then third step

  Scenario: Second scenario
    Given another step
    And one more
    Then final step
`;
    const parsed = parseGherkin(original);
    const regenerated = generateGherkin(parsed);
    expect(regenerated).toBe(original);
  });

  it('handles empty input gracefully', () => {
    const result = parseGherkin('');
    expect(result.name).toBe('');
    expect(result.scenarios).toHaveLength(0);
  });

  it('handles Scenario Outline', () => {
    const text = `Feature: Outline
  Scenario Outline: Template
    Given step with data
    When action happens
`;
    const result = parseGherkin(text);
    expect(result.scenarios[0].name).toBe('Template');
  });

  it('parses data table rows attached to steps', () => {
    const text = `Feature: Tables
  Scenario: Set fields
    And I set fields
      | such     | T001      |
      | namebspr | Testkunde |
    Then field "such" has value "T001"
`;
    const result = parseGherkin(text);
    const setStep = result.scenarios[0].steps[0];
    expect(setStep.text).toBe('I set fields');
    expect(setStep.action.type).toBe('feldSetzen');
    expect(setStep.dataTable).toEqual([
      ['such', 'T001'],
      ['namebspr', 'Testkunde'],
    ]);
    // Next step should NOT have a data table
    const checkStep = result.scenarios[0].steps[1];
    expect(checkStep.dataTable).toBeUndefined();
  });

  it('parses append rows with data table', () => {
    const text = `Feature: Append
  Scenario: Add items
    And I append rows
      | artikel | menge |
      | A001    | 10    |
`;
    const result = parseGherkin(text);
    const step = result.scenarios[0].steps[0];
    expect(step.action.type).toBe('zeilenAnfuegen');
    expect(step.dataTable).toEqual([
      ['artikel', 'menge'],
      ['A001', '10'],
    ]);
  });

  it('merges consecutive feldSetzen steps into multi step', () => {
    const text = `Feature: Merge
  Scenario: Set multiple
    And I set field "such" to "T001"
    And I set field "namebspr" to "Testkunde"
    And I set field "ort" to "Berlin"
    Then field "such" has value "T001"
`;
    const result = parseGherkin(text);
    const steps = result.scenarios[0].steps;
    // 3 consecutive feldSetzen → 1 merged multi step + 1 feldPruefen
    expect(steps).toHaveLength(2);
    expect(steps[0].text).toBe('I set fields');
    expect(steps[0].action.type).toBe('feldSetzen');
    if (steps[0].action.type === 'feldSetzen') {
      expect(steps[0].action.multi).toBe(true);
    }
    expect(steps[0].dataTable).toEqual([
      ['such', 'T001'],
      ['namebspr', 'Testkunde'],
      ['ort', 'Berlin'],
    ]);
    expect(steps[1].action.type).toBe('feldPruefen');
  });

  it('does not merge single feldSetzen step', () => {
    const text = `Feature: NoMerge
  Scenario: Single
    And I set field "such" to "T001"
    Then field "such" has value "T001"
`;
    const result = parseGherkin(text);
    const steps = result.scenarios[0].steps;
    expect(steps).toHaveLength(2);
    expect(steps[0].text).toContain('I set field');
    if (steps[0].action.type === 'feldSetzen') {
      expect(steps[0].action.multi).toBeFalsy();
    }
  });

  it('parses button press with row', () => {
    const text = `Feature: Buttons
  Scenario: Press
    And I press button "freig" in row 3
`;
    const result = parseGherkin(text);
    const step = result.scenarios[0].steps[0];
    expect(step.action.type).toBe('buttonDruecken');
    if (step.action.type === 'buttonDruecken') {
      expect(step.action.buttonName).toBe('freig');
      expect(step.action.row).toBe('3');
    }
  });

  it('supports !lastRow in feldSetzen and feldPruefen', () => {
    const text = `Feature: LastRow
  Scenario: Use lastRow
    And I set field "menge" to "10" in row !lastRow
    Then field "menge" has value "10" in row !lastRow
`;
    const result = parseGherkin(text);
    const steps = result.scenarios[0].steps;
    if (steps[0].action.type === 'feldSetzen') {
      expect(steps[0].action.row).toBe('!lastRow');
    }
    if (steps[1].action.type === 'feldPruefen') {
      expect(steps[1].action.row).toBe('!lastRow');
    }
  });

  it('round-trips data table through parse → generate', () => {
    const text = `Feature: Round Trip Table

  Scenario: With table
    And I set fields
      | such     | T001      |
      | namebspr | Testkunde |
`;
    const parsed = parseGherkin(text);
    const regenerated = generateGherkin(parsed);
    expect(regenerated).toBe(text);
  });

  it('normalizes smart/curly quotes to straight quotes', () => {
    const text = `Feature: Smart Quotes

  Scenario: Test
    Given I open an editor \u201CKunde\u201D from table \u201C0:1\u201D with command \u201CNEW\u201D for record \u201C\u201D
    And I set field \u201Csuch\u201D to \u201CT001\u201D
    Then field \u201Csuch\u201D has value \u201CT001\u201D
`;
    const result = parseGherkin(text);
    const actions = result.scenarios[0].steps.map((s) => s.action.type);
    expect(actions).toEqual(['editorOeffnen', 'feldSetzen', 'feldPruefen']);
  });
});
