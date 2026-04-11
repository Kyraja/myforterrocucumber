import { describe, it, expect } from 'vitest';
import { parseFopSource } from './fopParser';

const MOCK_HASH = 'abc123';

describe('parseFopSource', () => {
  it('detects FO1 german interpreter', () => {
    const src = `..!interpreter german declaration\n.. FOP-Name: TEST\n.. Autor: FK\n.. Funktion: Test FOP\n.weiter START\n!START:\n`;
    const result = parseFopSource(src, 'test/TEST', MOCK_HASH);
    expect(result.interpreterMode).toBe('german');
    expect(result.hasDeclaration).toBe(true);
    expect(result.isFo2).toBe(false);
    expect(result.header.author).toBe('FK');
    expect(result.header.function).toBe('Test FOP');
  });

  it('detects FO2 english interpreter', () => {
    const src = `..!interpreter english declaration noabbrev\ndef main() {\n}\n`;
    const result = parseFopSource(src, 'test/TEST.FO2', MOCK_HASH);
    expect(result.interpreterMode).toBe('english');
    expect(result.hasNoabbrev).toBe(true);
    expect(result.isFo2).toBe(true);
    expect(result.functions).toHaveLength(1);
    expect(result.functions[0].name).toBe('main');
  });

  it('parses variable declarations', () => {
    const src = `..!interpreter english declaration noabbrev\n.type text xtname\n.type integer xicounter\n.type AS8 xvkart\n.type bool xbflag ? _F|defined(U|xbflag)\n`;
    const result = parseFopSource(src, 'test/TEST', MOCK_HASH);
    expect(result.variables).toHaveLength(4);
    const textVar = result.variables.find(v => v.name === 'xtname')!;
    expect(textVar.isPrimitive).toBe(true);
    expect(textVar.followsNamingConvention).toBe(true);
    const refVar = result.variables.find(v => v.name === 'xvkart')!;
    expect(refVar.isPrimitive).toBe(false);
    const guardVar = result.variables.find(v => v.name === 'xbflag')!;
    expect(guardVar.conditionalDeclare).toBe(true);
  });

  it('parses subprogram calls', () => {
    const src = `..!interpreter english declaration\n.input "op/LOP.SELECT"\n.input 'M|tab'\n.input "is/DBCHOOSER" ? U|xbactive\n`;
    const result = parseFopSource(src, 'test/TEST', MOCK_HASH);
    expect(result.subprogramCalls).toHaveLength(3);
    expect(result.subprogramCalls[0].target).toBe('op/LOP.SELECT');
    expect(result.subprogramCalls[0].isDynamic).toBe(false);
    expect(result.subprogramCalls[1].isDynamic).toBe(true);
    expect(result.subprogramCalls[2].condition).toBeTruthy();
  });

  it('parses FO1 event routing', () => {
    const src = `..!interpreter german declaration\n.weiter SPME ? T|evtart="maskein"\n.weiter SPKART ? G|evtvar = "kart"\n!SPME:\n!SPKART:\n`;
    const result = parseFopSource(src, 'test/TEST', MOCK_HASH);
    expect(result.eventHandlers.length).toBeGreaterThanOrEqual(2);
    const maskein = result.eventHandlers.find(e => e.event === 'SE');
    expect(maskein).toBeTruthy();
    expect(maskein?.labelOrFunction).toBe('SPME');
  });

  it('parses buffer operations', () => {
    const src = `..!interpreter english declaration\n.select group '12' 'U|xsel'\n.load 0 object 'M|kart'\n`;
    const result = parseFopSource(src, 'test/TEST', MOCK_HASH);
    expect(result.bufferOperations.length).toBeGreaterThanOrEqual(1);
  });

  it('parses error statements', () => {
    const src = `..!interpreter english declaration\n.end 1\n.error -field "kart" -message "Invalid article"\n`;
    const result = parseFopSource(src, 'test/TEST', MOCK_HASH);
    expect(result.errorStatements).toHaveLength(2);
    expect(result.errorStatements[0].type).toBe('end-1');
    expect(result.errorStatements[1].type).toBe('error');
    expect(result.errorStatements[1].field).toBe('kart');
  });

  it('parses META directives', () => {
    const src = `..!interpreter english declaration\n..<META H|= 'P2:1'>\n`;
    const result = parseFopSource(src, 'test/TEST', MOCK_HASH);
    expect(result.metaDirectives).toHaveLength(1);
    expect(result.metaDirectives[0].buffer).toBe('H');
    expect(result.metaDirectives[0].typeReference).toBe('P2:1');
  });

  it('parses labels', () => {
    const src = `..!interpreter english declaration\n!LABEL1:\n!LABEL2\n`;
    const result = parseFopSource(src, 'test/TEST', MOCK_HASH);
    expect(result.labels).toHaveLength(2);
  });
});
