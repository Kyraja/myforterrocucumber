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

function highlightStrings(text: string): string {
  return text.replace(/(".*?")/g, '<span class="gh-string">$1</span>');
}
