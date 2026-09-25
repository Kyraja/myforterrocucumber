import { describe, it, expect } from 'vitest';
import {
  isSchedulingOnlyRequirement,
  makeSchedulingOnlyFeature,
  cleanSchedulingArtifacts,
} from './schedulingShortcut';
import type { FeatureInput } from '../types/gherkin';

describe('isSchedulingOnlyRequirement', () => {
  it.each([
    'Dispo starten. (Tippkommando - (Scheduling))',
    'Disposition starten',
    'Tippkommando Scheduling',
    'Scheduling starten',
    'Disposition / Scheduling starten per Tippkommando',
    'Tippkommando Scheduling ausfuehren',
  ])('matches %j', (text) => {
    expect(isSchedulingOnlyRequirement(text)).toBe(true);
  });

  it.each([
    '',
    '   ',
    'Auftrag anlegen, dann Disposition starten und Bestand pruefen',
    'Im Editor Kunde auf Speichern klicken',
    'Artikel mit Suchwort T001ARTI anlegen',
    'Disposition starten und neuen Lieferschein erzeugen',
    'Lieferant aendern und Scheduling triggern',
  ])('rejects %j', (text) => {
    expect(isSchedulingOnlyRequirement(text)).toBe(false);
  });

  it('rejects very long mixed texts even when scheduling appears', () => {
    const long = 'Scheduling ' + 'lorem ipsum dolor sit amet '.repeat(20);
    expect(isSchedulingOnlyRequirement(long)).toBe(false);
  });
});

describe('makeSchedulingOnlyFeature', () => {
  it('produces a two-step feature with tip command + close', () => {
    const f = makeSchedulingOnlyFeature('1.2.4 Disposition starten');
    expect(f.name).toBe('1.2.4 Disposition starten');
    expect(f.scenarios).toHaveLength(1);
    expect(f.scenarios[0].steps).toHaveLength(2);
    const open = f.scenarios[0].steps[0];
    expect(open.text).toBe('I open an editor "dispo" for tip command "(Scheduling)" and arguments ""');
    expect(open.action.type).toBe('editorOeffnenTipp');
    expect(open.keyword).toBe('Given');
    const close = f.scenarios[0].steps[1];
    expect(close.action.type).toBe('editorSchliessen');
  });

  it('falls back to a default name when none given', () => {
    expect(makeSchedulingOnlyFeature().name).toBe('Disposition starten');
    expect(makeSchedulingOnlyFeature('   ').name).toBe('Disposition starten');
  });
});

describe('cleanSchedulingArtifacts', () => {
  function feat(steps: { keyword: 'Given' | 'And' | 'Then'; text: string }[]): FeatureInput {
    return {
      name: 'F', description: '', tags: [], database: null, testUser: '',
      scenarios: [{
        id: 'sc1',
        name: 'Scheduling starten',
        steps: steps.map((s, i) => ({
          id: `s${i}`, keyword: s.keyword, text: s.text, action: { type: 'freetext' },
        })),
      }],
    };
  }

  it('replaces a scenario with bad "from table + for tip command Scheduling" pattern', () => {
    const before = feat([
      { keyword: 'Given', text: 'I open an editor "X" from table "126:4" with command "STORE" for search criteria "$,,guid==abc"' },
      { keyword: 'And', text: 'I set fields' },
      { keyword: 'And', text: 'I save the current editor' },
      { keyword: 'And', text: 'I close the current editor' },
      { keyword: 'Given', text: 'I open an editor "X" from table "126:4" with command "UPDATE" for tip command "Scheduling" and arguments ""' },
      { keyword: 'Then', text: 'field "such" has value "T001DISP"' },
    ]);
    const after = cleanSchedulingArtifacts(before);
    expect(after.scenarios[0].steps).toHaveLength(2);
    expect(after.scenarios[0].steps[0].text).toContain('for tip command "(Scheduling)"');
    expect(after.scenarios[0].steps[0].action.type).toBe('editorOeffnenTipp');
    expect(after.scenarios[0].steps[1].action.type).toBe('editorSchliessen');
  });

  it('leaves scenarios without the artifact untouched', () => {
    const before = feat([
      { keyword: 'Given', text: 'I open an editor "X" from table "0:1" with command "STORE" for record ""' },
      { keyword: 'And', text: 'I save the current editor' },
    ]);
    const after = cleanSchedulingArtifacts(before);
    expect(after).toBe(before);
  });
});
