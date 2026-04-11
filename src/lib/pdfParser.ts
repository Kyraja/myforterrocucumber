/**
 * PDF text extraction using pdfjs-dist.
 * Runs in the browser — no backend needed.
 * Uses PDF Outline (bookmarks) for chapter structure when available.
 */

import * as pdfjsLib from 'pdfjs-dist';

// Configure the worker
pdfjsLib.GlobalWorkerOptions.workerSrc = new URL(
  'pdfjs-dist/build/pdf.worker.min.mjs',
  import.meta.url,
).toString();

export interface PdfParseProgress {
  phase: 'loading' | 'extracting' | 'outline';
  current: number;
  total: number;
  currentHeading?: string;
}

export interface PdfOutlineEntry {
  title: string;
  page: number;  // 1-based page number
  level: number;  // nesting depth (0 = top level)
  children: PdfOutlineEntry[];
}

/**
 * Extract all text from a PDF file, page by page.
 * Preserves line breaks by detecting Y-position jumps between text items.
 * Detects headings by font size differences.
 * Returns an array of { page, text } for each page.
 */
export async function extractTextFromPdf(
  file: File,
  onProgress?: (info: PdfParseProgress) => void,
): Promise<{ pages: { page: number; text: string }[]; totalPages: number }> {
  const buffer = await file.arrayBuffer();
  onProgress?.({ phase: 'loading', current: 0, total: 0 });

  const pdf = await pdfjsLib.getDocument({ data: buffer }).promise;
  const totalPages = pdf.numPages;
  const pages: { page: number; text: string }[] = [];

  for (let i = 1; i <= totalPages; i++) {
    onProgress?.({ phase: 'extracting', current: i, total: totalPages });

    const page = await pdf.getPage(i);
    const content = await page.getTextContent();
    const items = content.items.filter((item): item is typeof item & { str: string; transform: number[]; height: number } =>
      'str' in item && typeof item.str === 'string' && item.str.trim().length > 0
    );

    if (items.length === 0) continue;

    // Build lines by detecting Y-position changes
    const lines: string[] = [];
    let currentLine = '';
    let lastY: number | null = null;

    for (const item of items) {
      // transform[5] = Y position (bottom of text), transform[4] = X position
      const y = Math.round(item.transform[5]);
      const text = item.str;

      if (lastY !== null && Math.abs(y - lastY) > 3) {
        // Y position changed significantly → new line
        if (currentLine.trim()) lines.push(currentLine.trim());
        currentLine = text;
      } else {
        // Same line — append with space if needed
        if (currentLine && !currentLine.endsWith(' ') && !text.startsWith(' ')) {
          currentLine += ' ';
        }
        currentLine += text;
      }
      lastY = y;
    }
    if (currentLine.trim()) lines.push(currentLine.trim());

    const pageText = lines.join('\n');
    if (pageText.trim()) {
      pages.push({ page: i, text: pageText });
    }
  }

  return { pages, totalPages };
}
