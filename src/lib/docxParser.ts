import mammoth from 'mammoth';
import {
  Document, Packer, Paragraph, TextRun,
  HeadingLevel, AlignmentType, BorderStyle,
} from 'docx';
import type { ParseProfile, ParsedFeaturePackage, SkippedChapter, TocEntry } from '../types/gherkin';
import { parseConsultantTemplate } from './consultantTemplate';
import { validateFeature } from './featureValidation';
import { DEFAULT_PARSE_PROFILE } from './parseProfile';

// ── Public API ───────────────────────────────────────────────

export interface DocxImportResult {
  features: ParsedFeaturePackage[];
  skippedChapters: SkippedChapter[];
  /** Full document TOC — all headings in order, regardless of whether they became packages */
  toc: TocEntry[];
}

/**
 * Parses a .docx file into multiple FeatureInput objects (one per heading section).
 * Uses mammoth to convert .docx → HTML, splits by headings, then passes each
 * section through parseConsultantTemplate().
 *
 * When `profile.splitting.technicalSectionKeywords` is non-empty, the parser
 * looks for a "Technische Umsetzung" (or equivalent) sub-heading within each
 * chapter. Content before it becomes the Feature description, content after it
 * gets parsed for scenarios. Chapters without the keyword are skipped (no
 * customization needed → no tests).
 */
export async function parseDocx(file: File, profile?: ParseProfile): Promise<DocxImportResult> {
  const p = profile ?? DEFAULT_PARSE_PROFILE;
  const buffer = await file.arrayBuffer();
  const { value: html } = await mammoth.convertToHtml({ arrayBuffer: buffer });

  const techKeywords = p.splitting.technicalSectionKeywords ?? [];
  const contentEndKeywords = p.splitting.contentEndKeywords ?? [];
  const sections = splitByHeadings(html, p.splitting.headingLevels);

  // Extract full TOC from all headings in the document (h1–h6)
  const allHeadings = extractAllHeadings(html);

  // If no headings found, treat the entire document as one section
  if (sections.length === 0) {
    const plainText = htmlToPlainText(html);
    if (!plainText.trim()) {
      return { features: [], skippedChapters: [], toc: [] };
    }
    const feature = parseConsultantTemplate(plainText, p);
    const validation = validateFeature(feature);
    return {
      features: [{ feature, sourceHeading: feature.name || '(Gesamtes Dokument)', sourceText: plainText, validation, headingLevel: 1 }],
      skippedChapters: [],
      toc: [],
    };
  }

  const features: ParsedFeaturePackage[] = [];
  const skippedChapters: SkippedChapter[] = [];

  for (const section of sections) {
    // Mode: contentEndKeywords — "Auswirkungen" table as end-of-content marker.
    // Content BEFORE the marker = requirement text for AI. No marker = skip.
    if (contentEndKeywords.length > 0) {
      const beforeHtml = splitByContentEnd(section.bodyHtml, contentEndKeywords);

      if (beforeHtml === null) {
        if (section.heading.trim()) {
          skippedChapters.push({
            sourceHeading: section.heading,
            reason: 'Kein Customization-Marker gefunden',
            headingLevel: section.headingLevel,
          });
        }
        continue;
      }

      const plainText = htmlToPlainText(beforeHtml).trim();
      if (!plainText && !section.heading.trim()) continue;

      const featureKw = p.keywords.feature[0];
      const fullText = `${featureKw}: ${section.heading}\n${plainText}`;
      const feature = parseConsultantTemplate(fullText, p);
      const validation = validateFeature(feature);
      const sourceText = [section.heading, plainText].filter(Boolean).join('\n\n');
      const { kundeField, aufwandField } = extractBoxFields(section.bodyHtml);

      features.push({ feature, sourceHeading: section.heading, sourceText, validation, headingLevel: section.headingLevel, kundeField, aufwandField });
      continue;
    }

    // When technicalSectionKeywords are configured, split each chapter into
    // "general description" + "technical content" around the keyword.
    if (techKeywords.length > 0) {
      const split = splitByTechnicalSection(section.bodyHtml, techKeywords);

      // Chapter has no technical section → no customization → skip
      if (!split) {
        if (section.heading.trim()) {
          skippedChapters.push({
            sourceHeading: section.heading,
            reason: 'Kein Abschnitt "Technische Umsetzung" gefunden',
            headingLevel: section.headingLevel,
          });
        }
        continue;
      }

      const descriptionText = htmlToPlainText(split.beforeHtml).trim();
      const technicalText = htmlToPlainText(split.afterHtml).trim();
      if (!technicalText && !section.heading.trim()) continue;

      const featureKw = p.keywords.feature[0];
      const descKw = p.keywords.description[0];

      let fullText = `${featureKw}: ${section.heading}\n`;
      if (descriptionText) {
        fullText += `${descKw}: ${descriptionText}\n`;
      }
      fullText += technicalText;

      const feature = parseConsultantTemplate(fullText, p);
      const validation = validateFeature(feature);
      const sourceText = [section.heading, descriptionText, technicalText].filter(Boolean).join('\n\n');

      features.push({
        feature,
        sourceHeading: section.heading,
        sourceText,
        validation,
        headingLevel: section.headingLevel,
      });
    } else {
      // Legacy behavior: parse entire section
      const plainText = htmlToPlainText(section.bodyHtml);
      if (!plainText.trim() && !section.heading.trim()) continue;

      const featureKeywords = p.keywords.feature;
      const textStartsWithFeature = featureKeywords.some((kw) =>
        plainText.trimStart().startsWith(kw + ':')
      );

      const fullText = textStartsWithFeature
        ? plainText
        : `${featureKeywords[0]}: ${section.heading}\n${plainText}`;

      const feature = parseConsultantTemplate(fullText, p);
      const validation = validateFeature(feature);
      const sourceText = `${section.heading}\n\n${plainText}`;

      features.push({
        feature,
        sourceHeading: section.heading,
        sourceText,
        validation,
        headingLevel: section.headingLevel,
      });
    }
  }

  // Build the full TOC by annotating all headings with their kind
  const packageHeadings = new Set(features.map((f) => f.sourceHeading));
  const skippedHeadings = new Set(skippedChapters.map((s) => s.sourceHeading));
  const toc: TocEntry[] = allHeadings.map(({ text, level }) => ({
    text,
    level,
    kind: packageHeadings.has(text) ? 'package' : skippedHeadings.has(text) ? 'skipped' : 'structure',
  }));

  return { features, skippedChapters, toc };
}

// ── HTML splitting ───────────────────────────────────────────

interface HtmlSection {
  heading: string;
  bodyHtml: string;
  headingLevel: number;
}

/**
 * Splits HTML content by heading elements (h1, h2, etc.) based on
 * the configured heading levels.
 */
function splitByHeadings(html: string, headingLevels: number[]): HtmlSection[] {
  const parser = new DOMParser();
  const doc = parser.parseFromString(html, 'text/html');
  const body = doc.body;

  if (!body || body.children.length === 0) return [];

  const headingTags = new Set(headingLevels.map((l) => `h${l}`));
  const sections: HtmlSection[] = [];
  let currentHeading = '';
  let currentLevel = 1;
  let currentBodyParts: string[] = [];

  for (const node of Array.from(body.childNodes)) {
    const el = node as Element;
    if (el.tagName && headingTags.has(el.tagName.toLowerCase())) {
      if (currentHeading || currentBodyParts.length > 0) {
        sections.push({ heading: currentHeading, bodyHtml: currentBodyParts.join(''), headingLevel: currentLevel });
      }
      currentHeading = el.textContent?.trim() ?? '';
      currentLevel = parseInt(el.tagName.slice(1), 10) || 1;
      currentBodyParts = [];
    } else {
      currentBodyParts.push((el as Element).outerHTML ?? node.textContent ?? '');
    }
  }

  if (currentHeading || currentBodyParts.length > 0) {
    sections.push({ heading: currentHeading, bodyHtml: currentBodyParts.join(''), headingLevel: currentLevel });
  }

  if (sections.length > 0 && !sections[0].heading) {
    sections.shift();
  }

  return sections;
}

/**
 * Extracts ALL headings (h1–h6) from the HTML to build a full document TOC.
 * Headings at all levels are included, not just the configured split levels.
 */
function extractAllHeadings(html: string): { text: string; level: number }[] {
  const parser = new DOMParser();
  const doc = parser.parseFromString(html, 'text/html');
  const headings: { text: string; level: number }[] = [];
  for (const el of Array.from(doc.body.querySelectorAll('h1,h2,h3,h4,h5,h6'))) {
    const text = el.textContent?.trim() ?? '';
    const level = parseInt(el.tagName.slice(1), 10);
    if (text) headings.push({ text, level });
  }
  return headings;
}

// ── Technical section splitting ──────────────────────────────

interface TechnicalSplit {
  beforeHtml: string;   // Content before the technical section keyword
  afterHtml: string;    // Content after the technical section keyword
}

/**
 * Searches for a technical section keyword (e.g. "Technische Umsetzung")
 * within a chapter's body HTML. The keyword can appear as:
 * - A sub-heading (h3, h4, etc.)
 * - A bold paragraph
 * - A plain paragraph starting with the keyword
 *
 * Returns the HTML split into before/after, or null if keyword not found.
 */
function splitByTechnicalSection(bodyHtml: string, keywords: string[]): TechnicalSplit | null {
  const parser = new DOMParser();
  const doc = parser.parseFromString(bodyHtml, 'text/html');
  const body = doc.body;
  if (!body) return null;

  const nodes = Array.from(body.childNodes);
  const lowerKeywords = keywords.map((k) => k.toLowerCase());

  for (let i = 0; i < nodes.length; i++) {
    const node = nodes[i];
    const text = (node.textContent ?? '').trim().toLowerCase();

    // Check if this node's text matches (or starts with) a technical section keyword
    const matches = lowerKeywords.some((kw) => text === kw || text.startsWith(kw + ':'));

    if (matches) {
      const beforeParts: string[] = [];
      const afterParts: string[] = [];

      for (let j = 0; j < nodes.length; j++) {
        const el = nodes[j] as Element;
        const html = el.outerHTML ?? nodes[j].textContent ?? '';
        if (j < i) {
          beforeParts.push(html);
        } else if (j > i) {
          afterParts.push(html);
        }
        // j === i: the keyword node itself is skipped
      }

      return {
        beforeHtml: beforeParts.join(''),
        afterHtml: afterParts.join(''),
      };
    }
  }

  return null; // keyword not found → chapter has no technical section
}

// ── Content end marker splitting ─────────────────────────────

/**
 * Finds the first node whose text contains a content-end keyword
 * (e.g. "Auswirkungen der Customization/Extension").
 * Returns the HTML of everything BEFORE that node, or null if not found.
 */
function splitByContentEnd(bodyHtml: string, keywords: string[]): string | null {
  const parser = new DOMParser();
  const doc = parser.parseFromString(bodyHtml, 'text/html');
  const body = doc.body;
  if (!body) return null;

  const nodes = Array.from(body.childNodes);
  const lowerKeywords = keywords.map((k) => k.toLowerCase());

  for (let i = 0; i < nodes.length; i++) {
    const text = (nodes[i].textContent ?? '').trim().toLowerCase();
    if (lowerKeywords.some((kw) => text.includes(kw))) {
      const beforeParts: string[] = [];
      for (let j = 0; j < i; j++) {
        const el = nodes[j] as Element;
        beforeParts.push(el.outerHTML ?? nodes[j].textContent ?? '');
      }
      return beforeParts.join('');
    }
  }

  return null; // marker not found → not a customization section
}

// ── Box field extraction (Realisierung, Aufwand) ─────────────

/** Labels that identify the "who realizes this" column/row in the box table. */
const REALISIERUNG_LABELS = ['realisierung', 'realisierung durch', 'umsetzung', 'umsetzung durch'];

/** Labels that identify the "effort" column/row in the box table. */
const AUFWAND_LABELS = ['aufwand', 'aufwand customization', 'aufwand extension', 'aufwand gesamt',
  'geschaetzter aufwand', 'geschätzter aufwand', 'zeit', 'umsetzungszeit', 'dauer'];

interface BoxFields {
  kundeField?: string;
  aufwandField?: string;
}

function matchesLabel(text: string, labels: string[]): boolean {
  const lower = text.toLowerCase();
  return labels.some((label) => lower === label || lower.startsWith(label));
}

/**
 * Extracts key fields from the box table at the end of a chapter.
 *
 * Supports two table layouts:
 * 1. **Column-based** (header row + data row):
 *    | Priorität | Realisierung | Dauer (ca./h) | … |
 *    | 1         | Kunde        | 1,00          | … |
 *
 * 2. **Row-based** (label + value in same row):
 *    | Realisierung | Kunde  |
 *    | Aufwand      | 2 Tage |
 */
function extractBoxFields(bodyHtml: string): BoxFields {
  const parser = new DOMParser();
  const doc = parser.parseFromString(bodyHtml, 'text/html');

  let kundeField: string | undefined;
  let kundeFallback: string | undefined;
  let aufwandField: string | undefined;

  for (const table of Array.from(doc.querySelectorAll('table'))) {
    const rows = Array.from(table.querySelectorAll('tr'));
    if (rows.length === 0) continue;

    // ── Strategy 1: Column-based (header row + data rows) ──
    // Check if the first row looks like a header with known labels
    const headerCells = Array.from(rows[0].querySelectorAll('td, th'));
    const headerTexts = headerCells.map((c) => (c.textContent ?? '').trim());

    const realCol = headerTexts.findIndex((h) => matchesLabel(h, REALISIERUNG_LABELS));
    const aufwandCol = headerTexts.findIndex((h) => matchesLabel(h, AUFWAND_LABELS));

    if (realCol >= 0 || aufwandCol >= 0) {
      // Found column headers — read values from subsequent data rows
      for (let r = 1; r < rows.length; r++) {
        const dataCells = Array.from(rows[r].querySelectorAll('td, th'));
        if (realCol >= 0 && !kundeField && dataCells[realCol]) {
          const val = (dataCells[realCol].textContent ?? '').trim();
          if (val) kundeField = val;
        }
        if (aufwandCol >= 0 && !aufwandField && dataCells[aufwandCol]) {
          const val = (dataCells[aufwandCol].textContent ?? '').trim();
          if (val) aufwandField = val;
        }
      }
      continue; // done with this table
    }

    // ── Strategy 2: Row-based (label in first cell, value in second) ──
    for (const row of rows) {
      const cells = Array.from(row.querySelectorAll('td, th'));
      if (cells.length < 2) continue;
      const label = (cells[0].textContent ?? '').trim();
      const value = (cells[1].textContent ?? '').trim();
      if (!value) continue;

      if (!kundeField && matchesLabel(label, REALISIERUNG_LABELS)) {
        kundeField = value;
      }
      if (!aufwandField && matchesLabel(label, AUFWAND_LABELS)) {
        aufwandField = value;
      }
      // Legacy fallback: cell labelled "Kunde" with value next to it
      if (label.toLowerCase() === 'kunde' && !kundeFallback) {
        kundeFallback = value;
      }
    }
  }

  return {
    kundeField: kundeField ?? kundeFallback,
    aufwandField,
  };
}

// ── HTML → plain text conversion ─────────────────────────────

/**
 * Converts HTML to plain text, preserving line structure.
 * Block-level elements (p, div, li, br) → newlines.
 */
function htmlToPlainText(html: string): string {
  const parser = new DOMParser();
  const doc = parser.parseFromString(html, 'text/html');
  const lines: string[] = [];

  function walk(node: Node) {
    if (node.nodeType === Node.TEXT_NODE) {
      const text = node.textContent ?? '';
      if (text.trim()) {
        lines.push(text.trim());
      }
      return;
    }

    if (node.nodeType === Node.ELEMENT_NODE) {
      const el = node as Element;
      const tag = el.tagName.toLowerCase();

      // Line break
      if (tag === 'br') {
        lines.push('');
        return;
      }

      // Table cells: collect cell text separated by " | "
      if (tag === 'table') {
        for (const row of Array.from(el.querySelectorAll('tr'))) {
          const cells = Array.from(row.querySelectorAll('td, th'));
          const cellTexts = cells
            .map((c) => (c.textContent ?? '').trim())
            .filter(Boolean);
          if (cellTexts.length > 0) {
            lines.push(cellTexts.join(' | '));
          }
        }
        lines.push('');
        return;
      }

      // Block elements: process children, add line break after
      const isBlock = ['p', 'div', 'li', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'tr'].includes(tag);

      for (const child of Array.from(node.childNodes)) {
        walk(child);
      }

      if (isBlock && lines.length > 0) {
        // Ensure block separation (don't add double empty lines)
        const last = lines[lines.length - 1];
        if (last !== '') {
          lines.push('');
        }
      }
    }
  }

  walk(doc.body);

  // Clean up: remove trailing empty lines, join
  while (lines.length > 0 && lines[lines.length - 1] === '') {
    lines.pop();
  }

  return lines.join('\n');
}

// ── Template download (.docx) ───────────────────────────────

/**
 * Generates and downloads a real .docx template with the expected
 * document structure: chapter headings, general description,
 * "Technische Umsetzung" sub-heading, then scenario keywords.
 *
 * @param lang - 'de' or 'en' — controls the prose text; keywords come from the profile.
 */
export async function downloadDocxTemplate(profile?: ParseProfile, lang: 'de' | 'en' = 'de'): Promise<void> {
  const p = profile ?? DEFAULT_PARSE_PROFILE;

  const dbKw = p.keywords.database[0];
  const userKw = p.keywords.testUser[0];
  const tagsKw = p.keywords.tags[0];
  const scenarioKw = p.keywords.scenario[0];
  const preKw = p.stepKeywords.precondition[0];
  const actKw = p.stepKeywords.action[0];
  const resKw = p.stepKeywords.result[0];

  const techKw = (p.splitting.technicalSectionKeywords ?? [])[0] || 'Technische Umsetzung';

  // ── Bilingual text ───────────────────────────────────────────
  const txt = lang === 'en' ? {
    title: 'Implementation Concept',
    subtitle: '[Project Name / Client]',
    instructionsTitle: 'Instructions:',
    instructions: [
      'This document serves as a template for the concept import in cucumbergnerator.',
      'Each chapter (Heading 1 or 2) corresponds to a work package / feature.',
      `Within a chapter, the sub-heading "${techKw}" marks the beginning of the technical test description.`,
      `Chapters without "${techKw}" are skipped during import (no customization = no tests).`,
    ],
    scenarioStructure: 'Structure per scenario:',
    preHint: `${preKw}: What must exist beforehand? (e.g. which editor, which record)`,
    actHint: `${actKw}: What is being done? (e.g. set field, press button, save)`,
    resHint: `${resKw}: What should be true afterwards? (e.g. field has value X, error message appears)`,
    freetextHint: 'Write in your own words — free text is allowed and can be refined later in the editor.',
    placeholderHint: 'Replace the [...] placeholders with your values and delete these instructions.',
    ch1Heading: 'Extend Customer Classification',
    ch1Desc: [
      'A new field "ykundenkategorie" should be added in the customer master,',
      'enabling the classification of customers into A/B/C categories.',
      'This is needed for sales management.',
    ],
    ch1s1Name: 'Set new customer category and save',
    ch1s1Pre: 'Editor oeffnen: Kundenstamm, P0:1, NEW',
    ch1s1Act1: 'Feld setzen: ykundenkategorie = "A-Kunde"',
    ch1s1Act2: 'Editor speichern',
    ch1s1Res: 'Feld pruefen: ykundenkategorie = "A-Kunde"',
    ch1s2Name: 'Mandatory field check for category',
    ch1s2Pre: 'Editor oeffnen: Kundenstamm, P0:1, NEW',
    ch1s2Act: 'Editor speichern',
    ch1s2Res: 'Exception beim Speichern: EX-KATEGORIE',
    ch1s3Name: 'Change category',
    ch1s3Pre: 'Editor oeffnen: Kundenstamm, P0:1, UPDATE, Datensatz 70000',
    ch1s3Act: 'Feld setzen: ykundenkategorie = "B-Kunde"',
    ch1s3Res: 'Feld pruefen: ykundenkategorie = "B-Kunde"',
    ch2Heading: 'Item Weight Class',
    ch2Desc: [
      'For shipping, the weight per item must be maintained.',
      'The field ygewicht is added in the item master.',
    ],
    ch2s1Name: 'Maintain weight',
    ch2s1Pre: 'Open item',
    ch2s1Act: 'Enter weight (e.g. 12.5 kg)',
    ch2s1Res: 'Weight is saved and visible',
    ch2s2Name: 'Check weight in delivery note',
    ch2s2Pre: 'Create delivery note for item with weight',
    ch2s2Res: 'Weight is displayed in the delivery note',
    ch3Heading: 'General Process Description',
    ch3Desc: [
      'This chapter describes the general order processing workflow.',
      'No system customizations are needed — therefore no tests.',
    ],
    ch3Skip: `(No "${techKw}" section present — skipped during import)`,
    filename: 'template-concept-import.docx',
  } : {
    title: 'Einfuehrungskonzept',
    subtitle: '[Projektname / Kunde]',
    instructionsTitle: 'Anleitung:',
    instructions: [
      'Dieses Dokument dient als Vorlage fuer den Konzept-Import in den cucumbergnerator.',
      'Jedes Kapitel (Ueberschrift 1 oder 2) entspricht einem Arbeitspaket / Feature.',
      `Innerhalb eines Kapitels markiert die Unterueberschrift "${techKw}" den Beginn der technischen Testbeschreibung.`,
      `Kapitel ohne "${techKw}" werden beim Import uebersprungen (keine Anpassung = keine Tests).`,
    ],
    scenarioStructure: 'Aufbau pro Szenario:',
    preHint: `${preKw}: Was muss vorher vorhanden sein? (z.B. welcher Editor, welcher Datensatz)`,
    actHint: `${actKw}: Was wird gemacht? (z.B. Feld setzen, Button druecken, speichern)`,
    resHint: `${resKw}: Was soll danach gelten? (z.B. Feld hat Wert X, Fehlermeldung erscheint)`,
    freetextHint: 'Schreiben Sie in Ihren eigenen Worten — Freitext ist erlaubt und kann spaeter im Editor verfeinert werden.',
    placeholderHint: 'Ersetzen Sie die [...] Platzhalter durch Ihre Werte und loeschen Sie diese Anleitung.',
    ch1Heading: 'Kundenklassifizierung erweitern',
    ch1Desc: [
      'Im Kundenstamm soll ein neues Feld "ykundenkategorie" eingefuehrt werden,',
      'das die Klassifizierung von Kunden in A/B/C-Kategorien ermoeglicht.',
      'Dies wird fuer die Vertriebssteuerung benoetigt.',
    ],
    ch1s1Name: 'Neue Kundenkategorie setzen und speichern',
    ch1s1Pre: 'Editor oeffnen: Kundenstamm, P0:1, NEW',
    ch1s1Act1: 'Feld setzen: ykundenkategorie = "A-Kunde"',
    ch1s1Act2: 'Editor speichern',
    ch1s1Res: 'Feld pruefen: ykundenkategorie = "A-Kunde"',
    ch1s2Name: 'Pflichtfeldpruefung Kategorie',
    ch1s2Pre: 'Editor oeffnen: Kundenstamm, P0:1, NEW',
    ch1s2Act: 'Editor speichern',
    ch1s2Res: 'Exception beim Speichern: EX-KATEGORIE',
    ch1s3Name: 'Kategorie aendern',
    ch1s3Pre: 'Editor oeffnen: Kundenstamm, P0:1, UPDATE, Datensatz 70000',
    ch1s3Act: 'Feld setzen: ykundenkategorie = "B-Kunde"',
    ch1s3Res: 'Feld pruefen: ykundenkategorie = "B-Kunde"',
    ch2Heading: 'Artikelgewichtsklasse',
    ch2Desc: [
      'Fuer den Versand muss das Gewicht pro Artikel gepflegt werden.',
      'Das Feld ygewicht wird im Artikelstamm hinzugefuegt.',
    ],
    ch2s1Name: 'Gewicht pflegen',
    ch2s1Pre: 'Artikel oeffnen',
    ch2s1Act: 'Gewicht eintragen (z.B. 12.5 kg)',
    ch2s1Res: 'Gewicht ist gespeichert und sichtbar',
    ch2s2Name: 'Gewicht im Lieferschein pruefen',
    ch2s2Pre: 'Lieferschein fuer Artikel mit Gewicht anlegen',
    ch2s2Res: 'Gewicht wird im Lieferschein angezeigt',
    ch3Heading: 'Allgemeine Prozessbeschreibung',
    ch3Desc: [
      'Dieses Kapitel beschreibt den allgemeinen Ablauf der Auftragsabwicklung.',
      'Es sind keine Anpassungen am System notwendig — daher keine Tests.',
    ],
    ch3Skip: `(Kein Abschnitt "${techKw}" vorhanden → wird beim Import uebersprungen)`,
    filename: 'vorlage-konzeptimport.docx',
  };

  // Helpers
  const heading1 = (text: string) =>
    new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun(text)] });
  const heading3 = (text: string) =>
    new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun(text)] });
  const para = (text: string) =>
    new Paragraph({ children: [new TextRun(text)] });
  const bold = (text: string) =>
    new Paragraph({ children: [new TextRun({ text, bold: true })] });
  const italic = (text: string) =>
    new Paragraph({ children: [new TextRun({ text, italics: true, color: '808080' })] });
  const emptyLine = () => new Paragraph({});
  const separator = () =>
    new Paragraph({
      border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: 'CCCCCC' } },
      spacing: { after: 200 },
    });

  const doc = new Document({
    sections: [{
      properties: {},
      children: [
        // ── Title ───────────────────
        new Paragraph({
          heading: HeadingLevel.TITLE,
          alignment: AlignmentType.CENTER,
          children: [new TextRun({ text: txt.title, bold: true, size: 48 })],
        }),
        new Paragraph({
          alignment: AlignmentType.CENTER,
          children: [new TextRun({ text: txt.subtitle, color: '808080' })],
        }),
        emptyLine(),
        separator(),

        // ── Instructions ────────────
        bold(txt.instructionsTitle),
        ...txt.instructions.map(para),
        emptyLine(),
        bold(txt.scenarioStructure),
        para(txt.preHint),
        para(txt.actHint),
        para(txt.resHint),
        emptyLine(),
        italic(txt.freetextHint),
        italic(txt.placeholderHint),
        emptyLine(),
        separator(),

        // ── Chapter 1: Realistic on-site example ────────────────────────
        heading1(txt.ch1Heading),
        emptyLine(),
        ...txt.ch1Desc.map(para),
        emptyLine(),

        heading3(techKw),
        emptyLine(),
        para(`${dbKw}: V-00-01`),
        para(`${userKw}: sy`),
        para(`${tagsKw}: @vertrieb`),
        emptyLine(),
        para(`${scenarioKw}: ${txt.ch1s1Name}`),
        para(`${preKw}: ${txt.ch1s1Pre}`),
        para(`${actKw}: ${txt.ch1s1Act1}`),
        para(`${actKw}: ${txt.ch1s1Act2}`),
        para(`${resKw}: ${txt.ch1s1Res}`),
        emptyLine(),
        para(`${scenarioKw}: ${txt.ch1s2Name}`),
        para(`${preKw}: ${txt.ch1s2Pre}`),
        para(`${actKw}: ${txt.ch1s2Act}`),
        para(`${resKw}: ${txt.ch1s2Res}`),
        emptyLine(),
        para(`${scenarioKw}: ${txt.ch1s3Name}`),
        para(`${preKw}: ${txt.ch1s3Pre}`),
        para(`${actKw}: ${txt.ch1s3Act}`),
        para(`${resKw}: ${txt.ch1s3Res}`),
        emptyLine(),
        separator(),

        // ── Chapter 2: Minimal/quick notes ──────────────────────────────
        heading1(txt.ch2Heading),
        emptyLine(),
        ...txt.ch2Desc.map(para),
        emptyLine(),

        heading3(techKw),
        emptyLine(),
        para(`${dbKw}: P2:1`),
        emptyLine(),
        para(`${scenarioKw}: ${txt.ch2s1Name}`),
        para(`${preKw}: ${txt.ch2s1Pre}`),
        para(`${actKw}: ${txt.ch2s1Act}`),
        para(`${resKw}: ${txt.ch2s1Res}`),
        emptyLine(),
        para(`${scenarioKw}: ${txt.ch2s2Name}`),
        para(`${preKw}: ${txt.ch2s2Pre}`),
        para(`${resKw}: ${txt.ch2s2Res}`),
        emptyLine(),
        separator(),

        // ── Chapter 3: Without technical section (skipped on import) ─────
        heading1(txt.ch3Heading),
        emptyLine(),
        ...txt.ch3Desc.map(para),
        emptyLine(),
        italic(txt.ch3Skip),
        emptyLine(),
      ],
    }],
  });

  const blob = await Packer.toBlob(doc);
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = txt.filename;
  a.click();
  URL.revokeObjectURL(url);
}
