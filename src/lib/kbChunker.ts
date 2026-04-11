/**
 * Chunks PDF text into sections based on headings.
 * Primary: split at numbered headings (4.2.1 Titel)
 * Secondary: if chunk > MAX_CHUNK_CHARS, split at sub-headings
 * Tertiary: if still too big, split at paragraph breaks
 */

import type { KBChunk } from '../types/knowledgeBase';

const MAX_CHUNK_CHARS = 8000;
const MIN_CHUNK_CHARS = 50;

// Matches numbered headings like "4.2.1 Fertigungsvorschläge" or "12 Einkauf"
const HEADING_RE = /^(\d+(?:\.\d+)*)\s+(.+)$/;

interface RawSection {
  heading: string;
  level: number;         // heading depth: "4" = 1, "4.2" = 2, "4.2.1" = 3
  text: string;
  page?: number;
}

/**
 * Parse the full text into sections based on numbered headings.
 * Now works with line-preserved text from the improved PDF parser.
 */
function detectSections(pages: { page: number; text: string }[]): RawSection[] {
  const sections: RawSection[] = [];
  let currentHeading = '';
  let currentLevel = 0;
  let currentPage = 1;
  let currentLines: string[] = [];

  for (const { page, text } of pages) {
    // Split by actual newlines (preserved by the PDF parser)
    const lines = text.split('\n');

    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed) {
        // Empty line — keep as paragraph separator
        if (currentLines.length > 0 && currentLines[currentLines.length - 1] !== '') {
          currentLines.push('');
        }
        continue;
      }

      const match = HEADING_RE.exec(trimmed);
      if (match) {
        // Save previous section
        if (currentLines.length > 0) {
          const sectionText = currentLines.join('\n').trim();
          if (sectionText.length >= MIN_CHUNK_CHARS) {
            sections.push({
              heading: currentHeading,
              level: currentLevel,
              text: sectionText,
              page: currentPage,
            });
          }
        }

        // Start new section
        const numbering = match[1];
        currentLevel = numbering.split('.').length;
        currentHeading = trimmed;
        currentPage = page;
        currentLines = [];
      } else {
        currentLines.push(trimmed);
      }
    }
  }

  // Don't forget the last section
  if (currentLines.length > 0) {
    const sectionText = currentLines.join('\n').trim();
    if (sectionText.length >= MIN_CHUNK_CHARS) {
      sections.push({
        heading: currentHeading,
        level: currentLevel,
        text: sectionText,
        page: currentPage,
      });
    }
  }

  return sections;
}

/**
 * Split a section that is too large into smaller chunks.
 * First tries paragraph boundaries (double newline), then single newlines.
 */
function splitLargeSection(section: RawSection): RawSection[] {
  if (section.text.length <= MAX_CHUNK_CHARS) return [section];

  // Try splitting at paragraph boundaries first (empty lines)
  let parts = section.text.split(/\n\s*\n/);
  // If no paragraph breaks, split at single newlines
  if (parts.length <= 1) parts = section.text.split('\n');

  const chunks: RawSection[] = [];
  let current = '';
  let partNum = 1;

  for (const part of parts) {
    if (current.length + part.length + 1 > MAX_CHUNK_CHARS && current.length >= MIN_CHUNK_CHARS) {
      chunks.push({
        ...section,
        heading: `${section.heading} (${partNum})`,
        text: current.trim(),
      });
      current = '';
      partNum++;
    }
    current += (current ? '\n\n' : '') + part;
  }

  if (current.trim().length >= MIN_CHUNK_CHARS) {
    chunks.push({
      ...section,
      heading: partNum > 1 ? `${section.heading} (${partNum})` : section.heading,
      text: current.trim(),
    });
  }

  return chunks;
}

/**
 * Build heading hierarchy for a section based on heading levels.
 */
function buildHierarchy(sections: RawSection[], currentIndex: number): string[] {
  const current = sections[currentIndex];
  const hierarchy: string[] = [];

  // Walk backwards to find parent headings
  for (let i = currentIndex - 1; i >= 0; i--) {
    if (sections[i].level < current.level) {
      hierarchy.unshift(sections[i].heading);
      if (sections[i].level === 1) break;
    }
  }

  return hierarchy;
}

export interface ChunkProgress {
  phase: 'chunking' | 'indexing';
  current: number;
  total: number;
  currentHeading: string;
}

/**
 * Main entry: chunk a parsed PDF into KBChunk objects.
 */
export function chunkDocument(
  docId: string,
  pages: { page: number; text: string }[],
  onProgress?: (info: ChunkProgress) => void,
): KBChunk[] {
  // Step 1: Detect sections from headings
  const rawSections = detectSections(pages);
  onProgress?.({ phase: 'chunking', current: 0, total: rawSections.length, currentHeading: '' });

  // Step 2: Split oversized sections
  const allSections: RawSection[] = [];
  for (let i = 0; i < rawSections.length; i++) {
    onProgress?.({ phase: 'chunking', current: i + 1, total: rawSections.length, currentHeading: rawSections[i].heading });
    const parts = splitLargeSection(rawSections[i]);
    allSections.push(...parts);
  }

  // Step 3: Build KBChunks with hierarchy
  const chunks: KBChunk[] = [];
  for (let i = 0; i < allSections.length; i++) {
    const section = allSections[i];
    onProgress?.({ phase: 'indexing', current: i + 1, total: allSections.length, currentHeading: section.heading });

    chunks.push({
      id: crypto.randomUUID(),
      docId,
      index: i,
      heading: section.heading,
      headingHierarchy: buildHierarchy(allSections, i),
      text: section.text,
      charCount: section.text.length,
      page: section.page,
    });
  }

  return chunks;
}
