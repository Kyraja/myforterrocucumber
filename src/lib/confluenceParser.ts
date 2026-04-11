/**
 * @module confluenceParser
 *
 * Parses Confluence .doc exports (MIME-encoded HTML) into {@link FeatureInput}
 * objects, one per document chapter.
 *
 * Two extraction strategies are applied per chapter:
 *
 * 1. **Table-based** — headings in "Name | DB-Ref | Mask" format with
 *    "Kopffeld/Wert" tables generate structured field-setting scenarios
 *    automatically, without requiring AI assistance.
 *
 * 2. **Freetext** — any heading with prose content is captured as a feature
 *    description and source text, intended for subsequent AI-based generation.
 *
 * Confluence exports use MIME multipart encoding with quoted-printable HTML;
 * this module handles that decoding transparently.
 *
 * Entry point: {@link parseConfluenceDoc}
 */

import type { FeatureInput, Scenario, Step, ParsedFeaturePackage, SkippedChapter, TocEntry } from '../types/gherkin';
import { validateFeature } from './featureValidation';

// ── Public API ───────────────────────────────────────────────

export interface ConfluenceImportResult {
  features: ParsedFeaturePackage[];
  skippedChapters: SkippedChapter[];
  toc: TocEntry[];
}

/**
 * Parses a Confluence .doc export (MIME/HTML) into multiple FeatureInput
 * objects. Supports two kinds of sections:
 *
 * 1. **Table-based** (h4 with "Name | DB-Ref | Mask"): Generates field-setting
 *    scenarios from Kopffeld/Wert tables.
 * 2. **Freetext** (any heading level with prose): Captures the text as
 *    Feature description + sourceText for AI generation.
 */
export async function parseConfluenceDoc(file: File): Promise<ConfluenceImportResult> {
  const raw = await file.text();
  const html = extractHtmlFromMime(raw);
  return parseConfluenceHtml(html);
}

/**
 * Core parser — works on clean HTML (after MIME decoding).
 * Exported for testing.
 */
export function parseConfluenceHtml(html: string): ConfluenceImportResult {
  const parser = new DOMParser();
  const doc = parser.parseFromString(html, 'text/html');
  const body = doc.body;
  if (!body) return { features: [], skippedChapters: [], toc: [] };

  const allHeadings = extractAllHeadings(doc);
  const sections = extractSections(body);

  const features: ParsedFeaturePackage[] = [];
  const skippedChapters: SkippedChapter[] = [];

  for (const section of sections) {
    // Skip the document title (h1)
    if (section.level === 1) continue;

    const parsed = parseHeading(section.heading);
    const hasTables = section.tables.length > 0;
    const plainText = collectPlainText(section.textNodes);

    // ── Strategy 1: Table-based (h4 with pipe format) ──────────
    if (parsed && hasTables) {
      const fieldGroups = extractFieldGroups(section.tables);
      if (fieldGroups.length === 0 && !plainText.trim()) {
        skippedChapters.push({
          sourceHeading: section.heading,
          reason: 'Keine Kopffeld/Wert-Tabellen gefunden',
          headingLevel: section.level,
        });
        continue;
      }

      if (fieldGroups.length > 0) {
        const scenarios = buildTableScenarios(parsed, fieldGroups);
        const feature: FeatureInput = {
          name: `${parsed.name} (${parsed.dbRef})`,
          description: `Stammdaten-Testdefinition aus Confluence.\nDatenbank: ${parsed.dbRef}, Maske: ${parsed.maskRef}`,
          tags: [],
          database: null,
          testUser: 'sy',
          scenarios,
        };

        features.push({
          feature,
          sourceHeading: section.heading,
          sourceText: buildTableSourceText(section, parsed),
          validation: validateFeature(feature),
          headingLevel: section.level,
        });
        continue;
      }
    }

    // ── Strategy 2: Freetext (any heading with prose content) ──
    // Include both text AND tables so the AI gets the full picture.
    const fullText = collectFullText(section);
    if (fullText.trim()) {
      const featureName = parsed
        ? `${parsed.name} (${parsed.dbRef})`
        : section.heading;

      const feature: FeatureInput = {
        name: featureName,
        description: fullText.trim(),
        tags: [],
        database: null,
        testUser: 'sy',
        scenarios: [],
      };

      features.push({
        feature,
        sourceHeading: section.heading,
        sourceText: fullText.trim(),
        validation: validateFeature(feature),
        headingLevel: section.level,
      });
      continue;
    }

    // ── Skip: heading with no usable content ───────────────────
    // Only skip if this heading has no child sections that were processed
    // (structural headings like "Stammdaten" are still in the TOC)
  }

  // Build TOC
  const packageHeadings = new Set(features.map(f => f.sourceHeading));
  const skippedHeadings = new Set(skippedChapters.map(s => s.sourceHeading));
  const toc: TocEntry[] = allHeadings.map(({ text, level }) => ({
    text,
    level,
    kind: packageHeadings.has(text) ? 'package' : skippedHeadings.has(text) ? 'skipped' : 'structure',
  }));

  return { features, skippedChapters, toc };
}

// ── MIME decoding ────────────────────────────────────────────

/**
 * Extracts HTML content from a MIME-encoded Confluence .doc export.
 * Handles quoted-printable decoding (=XX hex escapes, soft line breaks).
 * If the input is already plain HTML, returns it as-is.
 */
export function extractHtmlFromMime(raw: string): string {
  if (raw.trimStart().startsWith('<')) return raw;

  const htmlPartRegex = /Content-Type:\s*text\/html[^\r\n]*[\r\n]+Content-Transfer-Encoding:\s*quoted-printable[^\r\n]*[\r\n]+(?:Content-Location:[^\r\n]*[\r\n]+)?[\r\n]+([\s\S]*?)(?:------=_Part|$)/;
  const match = raw.match(htmlPartRegex);
  if (!match) {
    const htmlStart = raw.indexOf('<html');
    if (htmlStart >= 0) {
      return decodeQuotedPrintable(raw.slice(htmlStart));
    }
    return raw;
  }

  return decodeQuotedPrintable(match[1]);
}

/**
 * Decodes quoted-printable encoding:
 * - =XX → character with hex code XX
 * - =\r\n or =\n → soft line break (continuation)
 */
export function decodeQuotedPrintable(input: string): string {
  return input
    .replace(/=\r?\n/g, '')
    .replace(/=([0-9A-Fa-f]{2})/g, (_, hex) => {
      const byte = parseInt(hex, 16);
      return String.fromCharCode(byte);
    });
}

// ── Heading parsing ──────────────────────────────────────────

interface ParsedHeading {
  name: string;
  dbRef: string;
  maskRef: string;
}

/**
 * Parses a heading like "Kurztext | V-12-03 | P12:3" into its components.
 * Returns null if the heading doesn't match the pipe-separated format.
 */
function parseHeading(heading: string): ParsedHeading | null {
  const parts = heading.split('|').map(s => s.trim());
  if (parts.length < 3) return null;

  const name = parts[0];
  const dbRef = parts[1];
  const maskRef = parts[2];

  if (!name || !dbRef || !maskRef) return null;
  return { name, dbRef, maskRef };
}

// ── DOM extraction ───────────────────────────────────────────

interface ContentSection {
  heading: string;
  level: number;
  tables: HTMLTableElement[];
  /** Non-table elements (p, div, ul, ol, etc.) between headings */
  textNodes: HTMLElement[];
}

/**
 * Walks through the DOM and groups content by ANY heading (h1–h6).
 * Each section contains the heading text, level, tables, and text nodes.
 * Sections are "leaf" — a h2 section only includes content directly
 * under it until the next heading of any level.
 */
function extractSections(body: HTMLElement): ContentSection[] {
  const sections: ContentSection[] = [];
  let current: ContentSection | null = null;

  // Confluence exports use deeply nested divs; query all relevant elements
  const allElements = body.querySelectorAll('h1, h2, h3, h4, h5, h6, table, p, ul, ol, div.panel, blockquote');

  for (const el of Array.from(allElements)) {
    const tag = el.tagName.toLowerCase();

    if (/^h[1-6]$/.test(tag)) {
      if (current) sections.push(current);
      current = {
        heading: el.textContent?.trim() ?? '',
        level: parseInt(tag.slice(1), 10),
        tables: [],
        textNodes: [],
      };
    } else if (current) {
      // Skip elements that are children of another collected element
      // (e.g. <p> inside a <table> — already handled by table extraction)
      if (el.closest('table') && tag !== 'table') continue;

      if (tag === 'table') {
        current.tables.push(el as HTMLTableElement);
      } else {
        // Only collect elements with actual text content
        const text = (el.textContent ?? '').trim();
        if (text) {
          current.textNodes.push(el as HTMLElement);
        }
      }
    }
  }

  if (current) sections.push(current);
  return sections;
}

/**
 * Collects plain text from non-table DOM elements, preserving paragraph breaks.
 */
function collectPlainText(elements: HTMLElement[]): string {
  const lines: string[] = [];
  for (const el of elements) {
    const text = (el.textContent ?? '').trim();
    if (text) {
      lines.push(text);
    }
  }
  return lines.join('\n');
}

/**
 * Converts HTML tables to pipe-separated plain text so table data is preserved
 * for the AI. Each row becomes "col1 | col2 | col3".
 */
function tablesToPlainText(tables: HTMLTableElement[]): string {
  const lines: string[] = [];
  for (const table of tables) {
    const rows = Array.from(table.querySelectorAll('tr'));
    for (const row of rows) {
      const cells = Array.from(row.querySelectorAll('td, th'));
      const cellTexts = cells
        .map((c) => (c.textContent ?? '').trim().replace(/\s+/g, ' '))
        .filter(Boolean);
      if (cellTexts.length > 0) {
        lines.push(cellTexts.join(' | '));
      }
    }
    lines.push('');
  }
  return lines.join('\n').trim();
}

/**
 * Collects ALL content from a section — text nodes AND tables — in DOM order.
 * Used for the Freetext strategy so the AI receives the complete source text.
 */
function collectFullText(section: ContentSection): string {
  const textContent = collectPlainText(section.textNodes);
  const tableContent = tablesToPlainText(section.tables);
  const parts = [textContent, tableContent].filter((p) => p.trim());
  return parts.join('\n\n');
}

// ── Field group extraction ───────────────────────────────────

interface FieldPair {
  field: string;
  value: string;
}

interface FieldGroup {
  headFields: FieldPair[];
  tableFields: FieldPair[];
}

/**
 * Extracts field-value pairs from Confluence tables.
 * Tables have headers "Kopffeld | Wert" or "Tabellenfeld | Wert".
 * Multiple tables under one heading may represent different record variants.
 */
function extractFieldGroups(tables: HTMLTableElement[]): FieldGroup[] {
  const groups: FieldGroup[] = [];
  let currentGroup: FieldGroup = { headFields: [], tableFields: [] };

  for (const table of tables) {
    const rows = Array.from(table.querySelectorAll('tr'));
    if (rows.length === 0) continue;

    // Check if this table has Kopffeld/Tabellenfeld headers at all
    const firstRowText = (rows[0].textContent ?? '').toLowerCase();
    const isFieldTable = firstRowText.includes('kopffeld') || firstRowText.includes('tabellenfeld');
    if (!isFieldTable) continue; // Skip non-field tables (e.g. process tables)

    let isTableFields = false;

    for (const row of rows) {
      const cells = Array.from(row.querySelectorAll('td, th'));
      if (cells.length < 2) continue;

      const col1 = (cells[0].textContent ?? '').trim();
      const col2 = (cells[1].textContent ?? '').trim();

      const col1Lower = col1.toLowerCase();
      if (col1Lower === 'kopffeld' || col1Lower === 'tabellenfeld') {
        if (col1Lower === 'tabellenfeld') {
          isTableFields = true;
        } else {
          if (currentGroup.headFields.length > 0 && !isTableFields) {
            groups.push(currentGroup);
            currentGroup = { headFields: [], tableFields: [] };
          }
          isTableFields = false;
        }
        continue;
      }

      if (!col1 && !col2) continue;
      if (!col1) continue;

      const pair: FieldPair = { field: col1, value: col2 };
      if (isTableFields) {
        currentGroup.tableFields.push(pair);
      } else {
        currentGroup.headFields.push(pair);
      }
    }
  }

  if (currentGroup.headFields.length > 0 || currentGroup.tableFields.length > 0) {
    groups.push(currentGroup);
  }

  return groups;
}

// ── Scenario builders ────────────────────────────────────────

function buildTableScenarios(parsed: ParsedHeading, fieldGroups: FieldGroup[]): Scenario[] {
  return fieldGroups.map((group, idx) => {
    const steps: Step[] = [];
    const scenarioName = fieldGroups.length === 1
      ? `${parsed.name} anlegen`
      : `${parsed.name} Variante ${idx + 1} anlegen`;

    steps.push(makeStep('Given', `Editor oeffnen: ${parsed.maskRef}, NEW`));

    for (const { field, value } of group.headFields) {
      steps.push(makeStep(
        steps.length === 1 ? 'When' : 'And',
        `Feld setzen: ${field} = "${value}"`,
      ));
    }

    steps.push(makeStep('And', 'Editor speichern'));

    const checkFields = group.headFields.filter(f =>
      ['such', 'nummer', 'namebspr', 'name'].includes(f.field.toLowerCase())
    );
    for (const { field, value } of checkFields) {
      steps.push(makeStep(
        steps.find(s => s.keyword === 'Then') ? 'And' : 'Then',
        `Feld pruefen: ${field} = "${value}"`,
      ));
    }

    if (group.tableFields.length > 0) {
      for (const { field, value } of group.tableFields) {
        steps.push(makeStep('And', `Feld pruefen: ${field} = "${value}"`));
      }
    }

    if (!steps.find(s => s.keyword === 'Then')) {
      steps.push(makeStep('Then', 'Editor ist gespeichert'));
    }

    return { id: crypto.randomUUID(), name: scenarioName, steps };
  });
}

// ── Helpers ──────────────────────────────────────────────────

function extractAllHeadings(doc: Document): { text: string; level: number }[] {
  const headings: { text: string; level: number }[] = [];
  for (const el of Array.from(doc.querySelectorAll('h1,h2,h3,h4,h5,h6'))) {
    const text = el.textContent?.trim() ?? '';
    const level = parseInt(el.tagName.slice(1), 10);
    if (text) headings.push({ text, level });
  }
  return headings;
}

function makeStep(keyword: 'Given' | 'When' | 'Then' | 'And' | 'But', text: string): Step {
  return {
    id: crypto.randomUUID(),
    keyword,
    text,
    action: { type: 'freetext' },
  };
}

function buildTableSourceText(section: ContentSection, parsed: ParsedHeading): string {
  const lines: string[] = [
    `${parsed.name} | ${parsed.dbRef} | ${parsed.maskRef}`,
    '',
  ];

  for (const table of section.tables) {
    const rows = Array.from(table.querySelectorAll('tr'));
    for (const row of rows) {
      const cells = Array.from(row.querySelectorAll('td, th'));
      if (cells.length >= 2) {
        const col1 = (cells[0].textContent ?? '').trim();
        const col2 = (cells[1].textContent ?? '').trim();
        if (col1 || col2) {
          lines.push(`${col1}: ${col2}`);
        }
      }
    }
    lines.push('');
  }

  return lines.join('\n');
}
