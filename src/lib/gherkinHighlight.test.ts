import { describe, it, expect } from 'vitest';
import { highlightGherkin } from './gherkinHighlight';

describe('highlightGherkin', () => {
  it('highlights Gherkin keywords', () => {
    const result = highlightGherkin('Feature: Login');
    expect(result).toContain('<span class="gh-keyword">Feature</span>');
  });

  it('highlights step keywords', () => {
    const result = highlightGherkin('    Given the user is logged in');
    expect(result).toContain('<span class="gh-keyword">Given</span>');
  });

  it('highlights tags', () => {
    const result = highlightGherkin('@smoke @login');
    expect(result).toContain('<span class="gh-tag">@smoke</span>');
    expect(result).toContain('<span class="gh-tag">@login</span>');
  });

  it('highlights strings in quotes', () => {
    const result = highlightGherkin('    Given the user enters "admin"');
    expect(result).toContain('<span class="gh-string">"admin"</span>');
  });

  it('highlights comments', () => {
    const result = highlightGherkin('# This is a comment');
    expect(result).toContain('<span class="gh-comment"># This is a comment</span>');
  });

  it('escapes HTML entities', () => {
    const result = highlightGherkin('Given a <placeholder> value');
    expect(result).toContain('&lt;placeholder&gt;');
    expect(result).not.toContain('<placeholder>');
  });

  it('highlights data table pipe characters', () => {
    const result = highlightGherkin('      | such | T001 |');
    expect(result).toContain('<span class="gh-table-pipe">|</span>');
    expect(result).toContain('such');
    expect(result).toContain('T001');
  });

  it('highlights pipes in multi-row data table', () => {
    const input = '      | field1 | value1 |\n      | field2 | value2 |';
    const result = highlightGherkin(input);
    const pipeCount = (result.match(/gh-table-pipe/g) || []).length;
    expect(pipeCount).toBe(6); // 3 pipes per row × 2 rows
  });
});
