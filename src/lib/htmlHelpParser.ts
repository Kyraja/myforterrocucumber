/**
 * Parser for abas ERP HTML help files.
 * Extracts field-level help sections from HTML documentation.
 *
 * Each field help entry is identified by:
 *   <A NAME="3.FIELDNAME"> followed by <FONT CLASS=FHELP>Title</FONT>
 * Content runs until the next such entry.
 */

import type { KBChunk } from '../types/knowledgeBase';

/** A single help entry extracted from an HTML file */
export interface HtmlHelpEntry {
  /** Anchor name from the HTML, e.g. "3.KUNDE" */
  anchorName: string;
  /** Field title from FHELP, e.g. "Kunde" */
  title: string;
  /** Plain text content (HTML stripped) */
  text: string;
  /** Original HTML content for rich display */
  htmlContent: string;
  /** Source file name */
  sourceFile: string;
  /** Auto-detected keywords from anchor and content */
  keywords: string[];
}

export interface HtmlParseProgress {
  phase: 'reading' | 'parsing' | 'indexing';
  current: number;
  total: number;
  currentFile?: string;
}

/**
 * Filter only .html/.htm files from a list of files.
 * Accepts FileList (from input) or File[] (pre-converted array).
 */
export function filterHtmlFiles(files: FileList | File[]): File[] {
  const arr = files instanceof FileList ? Array.from(files) : files;
  return arr.filter(file => {
    const name = file.name.toLowerCase();
    return name.endsWith('.html') || name.endsWith('.htm');
  });
}

/**
 * Parse a single HTML help file and extract field help entries.
 */
export function parseHtmlHelpFile(htmlString: string, fileName: string): HtmlHelpEntry[] {
  const entries: HtmlHelpEntry[] = [];

  // Strategy: find all field help sections by matching the pattern:
  //   <A NAME="X.FIELD"> ... <FONT CLASS=FHELP>Title</FONT>
  // Then capture content until the next such pattern.

  // First, find all field help positions
  const fhelpPattern = /<A\s+NAME="([^"]+)"[^>]*>(?:<\/A>)?\s*(?:<[^>]+>\s*)*<FONT\s+CLASS=FHELP>\s*([\s\S]*?)<\/FONT>/gi;
  const matches: { anchorName: string; title: string; startIndex: number; matchEnd: number }[] = [];

  let m: RegExpExecArray | null;
  while ((m = fhelpPattern.exec(htmlString)) !== null) {
    const anchorName = m[1];
    const rawTitle = m[2].replace(/<[^>]+>/g, '').replace(/\s+/g, ' ').trim();
    matches.push({
      anchorName,
      title: rawTitle,
      startIndex: m.index,
      matchEnd: m.index + m[0].length,
    });
  }

  if (matches.length === 0) return entries;

  // For each match, capture content from matchEnd to the start of the next match
  for (let i = 0; i < matches.length; i++) {
    const current = matches[i];
    const nextStart = i < matches.length - 1 ? matches[i + 1].startIndex : htmlString.length;

    // Extract the HTML content between this entry and the next
    const htmlContent = htmlString.slice(current.matchEnd, nextStart).trim();

    // Skip entries with no real content
    if (htmlContent.length < 20) continue;

    // Convert HTML to plain text
    const text = htmlToPlainText(htmlContent);
    if (text.length < 30) continue;

    // Extract keywords from anchor name and content
    const keywords = extractKeywords(current.anchorName, current.title, text);

    entries.push({
      anchorName: current.anchorName,
      title: current.title,
      text,
      htmlContent: cleanHtmlContent(htmlContent),
      sourceFile: fileName,
      keywords,
    });
  }

  return entries;
}

/**
 * Convert HTML to readable plain text.
 */
function htmlToPlainText(html: string): string {
  let text = html;

  // Replace common block elements with newlines
  text = text.replace(/<\/?(P|DIV|BR|TR|LI|H[1-6]|UL|OL|TABLE|BLOCKQUOTE)\b[^>]*>/gi, '\n');
  // Replace TD/TH with tab
  text = text.replace(/<\/?(TD|TH)\b[^>]*>/gi, '\t');

  // Remove all remaining HTML tags
  text = text.replace(/<[^>]+>/g, '');

  // Decode HTML entities
  text = decodeHtmlEntities(text);

  // Clean up whitespace
  text = text.replace(/[ \t]+/g, ' ');
  text = text.replace(/\n\s*\n\s*\n+/g, '\n\n');
  text = text.trim();

  return text;
}

/**
 * Decode common HTML entities.
 */
function decodeHtmlEntities(text: string): string {
  const entities: Record<string, string> = {
    '&amp;': '&', '&lt;': '<', '&gt;': '>', '&quot;': '"', '&#39;': "'",
    '&auml;': 'ä', '&ouml;': 'ö', '&uuml;': 'ü',
    '&Auml;': 'Ä', '&Ouml;': 'Ö', '&Uuml;': 'Ü',
    '&szlig;': 'ß', '&nbsp;': ' ',
    '&ndash;': '–', '&mdash;': '—', '&hellip;': '…',
    '&laquo;': '«', '&raquo;': '»',
    '&copy;': '©', '&reg;': '®',
  };
  return text.replace(/&[a-zA-Z0-9#]+;/g, match => entities[match] ?? match);
}

/**
 * Clean HTML content for display (remove comments, normalize).
 */
function cleanHtmlContent(html: string): string {
  // Remove HTML comments
  let clean = html.replace(/<!--[\s\S]*?-->/g, '');
  // Remove excessive whitespace between tags
  clean = clean.replace(/>\s+</g, '> <');
  // Remove empty lines
  clean = clean.replace(/\n\s*\n\s*\n+/g, '\n\n');
  return clean.trim();
}

/**
 * Extract keywords from anchor name, title, and content.
 */
function extractKeywords(anchorName: string, title: string, text: string): string[] {
  const keywords = new Set<string>();

  // 1. The anchor name itself (e.g. "3.KUNDE" → "KUNDE")
  const parts = anchorName.split('.');
  // Add full anchor
  keywords.add(anchorName.toUpperCase());
  // Add the field part (last segment that is not purely numeric)
  for (let i = parts.length - 1; i >= 0; i--) {
    if (!/^\d+$/.test(parts[i])) {
      keywords.add(parts[i].toUpperCase());
      break;
    }
  }

  // 2. Keywords from title (split by comma, space)
  const titleWords = title
    .split(/[,;/()]+/)
    .map(w => w.trim())
    .filter(w => w.length > 2);
  for (const word of titleWords) {
    keywords.add(word);
  }

  // 3. Detect abas field variable names in text (e.g. "(ev)kunde", "(ev)waehr")
  const varPattern = /\(ev\)(\w+)/gi;
  let vm: RegExpExecArray | null;
  while ((vm = varPattern.exec(text)) !== null) {
    keywords.add(vm[1].toUpperCase());
  }

  return Array.from(keywords);
}

/**
 * Parse all HTML files and convert to KBChunks.
 */
export async function parseHtmlFolder(
  files: File[],
  docId: string,
  onProgress?: (info: HtmlParseProgress) => void,
): Promise<KBChunk[]> {
  const htmlFiles = filterHtmlFiles(files);
  if (htmlFiles.length === 0) return [];

  const allChunks: KBChunk[] = [];
  let chunkIndex = 0;

  for (let i = 0; i < htmlFiles.length; i++) {
    const file = htmlFiles[i];
    onProgress?.({ phase: 'parsing', current: i + 1, total: htmlFiles.length, currentFile: file.name });

    const htmlString = await file.text();
    const entries = parseHtmlHelpFile(htmlString, file.name);

    // Also extract the page title for hierarchy context
    const pageTitle = extractPageTitle(htmlString);

    for (const entry of entries) {
      allChunks.push({
        id: crypto.randomUUID(),
        docId,
        index: chunkIndex++,
        heading: entry.title,
        headingHierarchy: pageTitle ? [pageTitle] : [],
        text: entry.text,
        charCount: entry.text.length,
        keywords: entry.keywords,
        sourceFile: entry.sourceFile,
        anchorName: entry.anchorName,
        htmlContent: entry.htmlContent,
      });
    }
  }

  onProgress?.({ phase: 'indexing', current: htmlFiles.length, total: htmlFiles.length });
  return allChunks;
}

/**
 * Extract page title from HTML <TITLE> or <H2> tag.
 */
function extractPageTitle(html: string): string {
  // Try <TITLE>
  const titleMatch = /<TITLE>([\s\S]*?)<\/TITLE>/i.exec(html);
  if (titleMatch) {
    return decodeHtmlEntities(titleMatch[1].replace(/<[^>]+>/g, '').trim());
  }
  // Try first <H2>
  const h2Match = /<H2[^>]*>([\s\S]*?)<\/H2>/i.exec(html);
  if (h2Match) {
    return decodeHtmlEntities(h2Match[1].replace(/<[^>]+>/g, '').trim());
  }
  return '';
}
