/**
 * Syntax highlighter for the Gherkin preview pane.
 *
 * Tokenizes raw Gherkin text line-by-line and wraps recognized tokens in
 * `<span>` elements with CSS class names (e.g. `gh-keyword`, `gh-tag`,
 * `gh-string`). A line-by-line strategy avoids cascading regex failures that
 * occur when a multi-line regex matches across keyword and value boundaries.
 *
 * Each output line is wrapped in `<span data-line="N">` so the UI can map
 * click events back to the corresponding source line index.
 *
 * No external dependencies — all tokenization is done with plain regexes.
 */

/**
 * Convert raw Gherkin text to an HTML string with syntax-highlight spans.
 *
 * The input is first HTML-escaped, then split into lines. Each line is
 * classified and annotated independently via {@link highlightLine}.
 *
 * @param text - Raw Gherkin text (e.g. from `generateGherkin`).
 * @returns HTML string suitable for injection into a `<pre>` element's `innerHTML`.
 */
export function highlightGherkin(text: string): string {
  // Escape HTML first
  const escaped = text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');

  // Tokenize line-by-line to avoid cascading regex issues
  return escaped
    .split('\n')
    .map((line, i) => `<span data-line="${i}">${highlightLine(line)}</span>`)
    .join('\n');
}

/**
 * Apply syntax highlighting to a single, already HTML-escaped Gherkin line.
 * Priority order: comments → tags → data tables → keyword lines → string fallback.
 *
 * @param line - A single HTML-escaped line of Gherkin text.
 * @returns The line with highlight `<span>` elements inserted.
 */
function highlightLine(line: string): string {
  // Comments take priority — entire line is a comment
  if (/^\s*#/.test(line)) {
    return `<span class="gh-comment">${line}</span>`;
  }

  // Tags line
  if (/^\s*@/.test(line)) {
    return line.replace(/(@\w+)/g, '<span class="gh-tag">$1</span>');
  }

  // Data table row (| col1 | col2 |)
  if (/^\s*\|/.test(line)) {
    return line.replace(/(\|)/g, '<span class="gh-table-pipe">$1</span>');
  }

  // Keyword at start of line (with optional leading whitespace)
  let result = line.replace(
    /^(\s*)(Feature|Scenario Outline|Scenario|Background|Examples|Given|When|Then|And|But)(:?)(.*)$/,
    (_, indent, kw, colon, rest) =>
      `${indent}<span class="gh-keyword">${kw}</span>${colon}${highlightStrings(rest)}`,
  );

  if (result !== line) return result;

  // Fallback: just highlight strings
  return highlightStrings(line);
}

/**
 * Wrap all double-quoted string literals in a line with a `gh-string` span.
 *
 * @param text - Partial line text (keyword suffix or a plain line).
 * @returns Text with quoted substrings highlighted.
 */
function highlightStrings(text: string): string {
  return text.replace(/(".*?")/g, '<span class="gh-string">$1</span>');
}
