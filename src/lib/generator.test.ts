import { describe, it, expect } from 'vitest';
import { generateGherkin } from './generator';
import type { FeatureInput, Step } from '../types/gherkin';

const ft = (id: string, keyword: Step['keyword'], text: string): Step => ({
  id, keyword, text, action: { type: 'freetext' },
});

describe('generateGherkin', () => {
  it('generates minimal feature with just a name', () => {
    const input: FeatureInput = {
      name: 'Login',
      description: '',
      tags: [],
      database: null,
      testUser: '',
      scenarios: [],
    };
    expect(generateGherkin(input)).toBe('Feature: Login\n');
  });

  it('includes tags before feature', () => {
    const input: FeatureInput = {
      name: 'Login',
      description: '',
      tags: ['@smoke', '@login'],
      database: null,
      testUser: '',
      scenarios: [],
    };
    const result = generateGherkin(input);
    expect(result).toBe('@smoke @login\nFeature: Login\n');
  });

  it('includes description as comments', () => {
    const input: FeatureInput = {
      name: 'Login',
      description: 'As a user\nI want to log in',
      tags: [],
      database: null,
      testUser: '',
      scenarios: [],
    };
    const result = generateGherkin(input);
    expect(result).toContain('  # As a user\n  # I want to log in');
  });

  it('generates scenarios with steps', () => {
    const input: FeatureInput = {
      name: 'Login',
      description: '',
      tags: [],
      database: null,
      testUser: '',
      scenarios: [
        {
          id: '1',
          name: 'Successful login',
          steps: [
            ft('s1', 'Given', 'the user is on the login page'),
            ft('s2', 'When', 'the user enters valid credentials'),
            ft('s3', 'Then', 'the user is redirected to the dashboard'),
          ],
        },
      ],
    };
    const result = generateGherkin(input);
    expect(result).toContain('  Scenario: Successful login');
    expect(result).toContain('    Given the user is on the login page');
    expect(result).toContain('    When the user enters valid credentials');
    expect(result).toContain('    Then the user is redirected to the dashboard');
  });

  it('generates multiple scenarios with blank lines between', () => {
    const input: FeatureInput = {
      name: 'Login',
      description: '',
      tags: [],
      database: null,
      testUser: '',
      scenarios: [
        { id: '1', name: 'Success', steps: [ft('s1', 'Given', 'valid user')] },
        { id: '2', name: 'Failure', steps: [ft('s2', 'Given', 'invalid user')] },
      ],
    };
    const result = generateGherkin(input);
    expect(result).toContain('  Scenario: Success');
    expect(result).toContain('  Scenario: Failure');
    expect(result).toMatch(/Given valid user\n\n  Scenario: Failure/);
  });

  it('handles And and But keywords', () => {
    const input: FeatureInput = {
      name: 'Cart',
      description: '',
      tags: [],
      database: null,
      testUser: '',
      scenarios: [
        {
          id: '1',
          name: 'Add items',
          steps: [
            ft('s1', 'Given', 'an empty cart'),
            ft('s2', 'And', 'a product catalog'),
            ft('s3', 'When', 'the user adds an item'),
            ft('s4', 'But', 'the item is out of stock'),
            ft('s5', 'Then', 'an error is shown'),
          ],
        },
      ],
    };
    const result = generateGherkin(input);
    expect(result).toContain('    And a product catalog');
    expect(result).toContain('    But the item is out of stock');
  });

  it('ends with a newline', () => {
    const input: FeatureInput = {
      name: 'Test',
      description: '',
      tags: [],
      database: null,
      testUser: '',
      scenarios: [],
    };
    expect(generateGherkin(input).endsWith('\n')).toBe(true);
  });

  it('uses correct indentation (2 for scenario, 4 for steps)', () => {
    const input: FeatureInput = {
      name: 'Test',
      description: '',
      tags: [],
      database: null,
      testUser: '',
      scenarios: [
        { id: '1', name: 'Indent check', steps: [ft('s1', 'Given', 'something')] },
      ],
    };
    const lines = generateGherkin(input).split('\n');
    const scenarioLine = lines.find(l => l.includes('Scenario:'))!;
    const stepLine = lines.find(l => l.includes('Given'))!;
    expect(scenarioLine).toMatch(/^ {2}Scenario:/);
    expect(stepLine).toMatch(/^ {4}Given/);
  });

  it('does not auto-generate database tag', () => {
    const input: FeatureInput = {
      name: 'Kunde anlegen',
      description: '',
      tags: ['@smoke'],
      database: { id: 1000, sw: 'V-00-01', de: 'Variablentabelle: Kunde', en: 'Table of variables: Customer', fc: 445 },
      testUser: '',
      scenarios: [],
    };
    const result = generateGherkin(input);
    expect(result).toBe('@smoke\nFeature: Kunde anlegen\n');
  });

  it('generates Background block with test user login', () => {
    const input: FeatureInput = {
      name: 'Artikel Kategorisierung',
      description: '',
      tags: [],
      database: null,
      testUser: 'cucumber',
      scenarios: [
        { id: '1', name: 'Neuanlage', steps: [ft('s1', 'Given', 'die Maske ist geoeffnet')] },
      ],
    };
    const result = generateGherkin(input);
    expect(result).toContain('  Background:');
    expect(result).toContain('    Given I\'m logged in with password "cucumber"');
    expect(result).toMatch(/Background:\n    Given I'm logged in with password "cucumber"\n\n  Scenario:/);
  });

  it('omits Background when testUser is empty', () => {
    const input: FeatureInput = {
      name: 'Test',
      description: '',
      tags: [],
      database: null,
      testUser: '',
      scenarios: [],
    };
    const result = generateGherkin(input);
    expect(result).not.toContain('Background');
  });

  it('outputs data table rows with aligned columns', () => {
    const input: FeatureInput = {
      name: 'Fields',
      description: '',
      tags: [],
      database: null,
      testUser: '',
      scenarios: [
        {
          id: '1',
          name: 'Set multiple fields',
          steps: [
            {
              id: 's1',
              keyword: 'And',
              text: 'I set fields',
              action: { type: 'feldSetzen', fieldName: '', value: '', row: '', multi: true },
              dataTable: [
                ['such', 'T001'],
                ['namebspr', 'Testkunde'],
              ],
            },
          ],
        },
      ],
    };
    const result = generateGherkin(input);
    expect(result).toContain('    And I set fields');
    expect(result).toContain('      | such     | T001      |');
    expect(result).toContain('      | namebspr | Testkunde |');
  });

  it('outputs data table for append rows with header row', () => {
    const input: FeatureInput = {
      name: 'Append',
      description: '',
      tags: [],
      database: null,
      testUser: '',
      scenarios: [
        {
          id: '1',
          name: 'Append items',
          steps: [
            {
              id: 's1',
              keyword: 'And',
              text: 'I append rows',
              action: { type: 'zeilenAnfuegen' },
              dataTable: [
                ['artikel', 'menge'],
                ['A001', '10'],
                ['A002', '20'],
              ],
            },
          ],
        },
      ],
    };
    const result = generateGherkin(input);
    expect(result).toContain('    And I append rows');
    expect(result).toContain('      | artikel | menge |');
    expect(result).toContain('      | A001    | 10    |');
    expect(result).toContain('      | A002    | 20    |');
  });

  it('handles single-column data table', () => {
    const input: FeatureInput = {
      name: 'Single',
      description: '',
      tags: [],
      database: null,
      testUser: '',
      scenarios: [
        {
          id: '1',
          name: 'One col',
          steps: [
            {
              id: 's1',
              keyword: 'Given',
              text: 'some step',
              action: { type: 'freetext' },
              dataTable: [['alpha'], ['beta']],
            },
          ],
        },
      ],
    };
    const result = generateGherkin(input);
    expect(result).toContain('      | alpha |');
    expect(result).toContain('      | beta  |');
  });
});
