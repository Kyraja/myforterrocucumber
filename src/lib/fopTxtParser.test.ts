import { describe, it, expect } from 'vitest';
import { parseFopTxt, getUniqueMasks, getBindingLabel } from './fopTxtParser';

const SAMPLE_FOP_TXT = `
.. FOP.txt Beispiel
32  ändern  maskein  *  *  K  [C] owvk/S0032.SE.FO2
32  ändern  feldpruef  *  kart  K  [C] owvk/S0032.kart.FV.FO2
32  ändern  buttonnach  *  druck  K  [S] owvk/S0032.druck.BA.FO2
67  *  maskein  *  *  *  [C] owst/IS.LOP.SE.FO2
*   *  maskein  *  *  *  [C] is/GLOBAL.SE.FO2
`;

describe('parseFopTxt', () => {
  it('parses valid bindings', () => {
    const result = parseFopTxt(SAMPLE_FOP_TXT);
    expect(result.length).toBe(5);
  });

  it('skips comments and empty lines', () => {
    const result = parseFopTxt(SAMPLE_FOP_TXT);
    expect(result.every(b => b.fopPath)).toBe(true);
  });

  it('sets eventShort correctly', () => {
    const result = parseFopTxt(SAMPLE_FOP_TXT);
    const maskein = result.find(b => b.event === 'maskein');
    expect(maskein?.eventShort).toBe('SE');
    const feldpruef = result.find(b => b.event === 'feldpruef');
    expect(feldpruef?.eventShort).toBe('FV');
  });

  it('sets continueSearch correctly', () => {
    const result = parseFopTxt(SAMPLE_FOP_TXT);
    const c = result.find(b => b.fopPath.includes('S0032.SE'));
    expect(c?.continueSearch).toBe(true);
    const s = result.find(b => b.fopPath.includes('S0032.druck'));
    expect(s?.continueSearch).toBe(false);
  });

  it('handles wildcard mask', () => {
    const result = parseFopTxt(SAMPLE_FOP_TXT);
    const wildcard = result.find(b => b.mask === '*');
    expect(wildcard).toBeTruthy();
  });
});

describe('getUniqueMasks', () => {
  it('returns sorted unique mask numbers', () => {
    const bindings = parseFopTxt(SAMPLE_FOP_TXT);
    const masks = getUniqueMasks(bindings);
    expect(masks).toContain(32);
    expect(masks).toContain(67);
    expect(masks.length).toBe(2);
  });
});

describe('getBindingLabel', () => {
  it('generates German label', () => {
    const bindings = parseFopTxt(SAMPLE_FOP_TXT);
    const binding = bindings.find(b => b.field === 'kart')!;
    const label = getBindingLabel(binding, 'de');
    expect(label).toContain('Maske 32');
    expect(label).toContain('FV:kart');
  });
});
