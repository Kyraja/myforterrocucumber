/** A collection of HTML help files imported from a folder */
export interface KBDocument {
  id: string;
  /** Display name (folder name or user-given name) */
  fileName: string;
  uploadedAt: number;
  /** Number of HTML files processed */
  fileCount: number;
  chunkCount: number;
  totalChars: number;
}

/** A text chunk extracted from a document */
export interface KBChunk {
  id: string;
  docId: string;
  index: number;
  /** Section heading (empty if none detected) */
  heading: string;
  /** Parent headings for context, e.g. ["4 Verkauf", "4.1 Aufträge"] */
  headingHierarchy: string[];
  /** The chunk text content */
  text: string;
  /** Character count */
  charCount: number;
  /** Page number in the PDF (approximate) */
  page?: number;
  /** User note attached to this chunk */
  note?: string;
  /** User rating: 1 = helpful, -1 = not helpful, 0/undefined = unrated */
  rating?: number;
  /** Keywords for matching and search (e.g. field anchors like "KUNDE", "WAEHR") */
  keywords?: string[];
  /** Source HTML file name (only for html-folder chunks) */
  sourceFile?: string;
  /** HTML anchor name from the original document (e.g. "3.KUNDE") */
  anchorName?: string;
  /** Original HTML content for rich display */
  htmlContent?: string;
}

/** Search result with a relevance score */
export interface KBSearchResult {
  chunk: KBChunk;
  score: number;
  matchedTerms: string[];
}

/** Action-context pair recognized from requirements text */
export interface ActionContext {
  action: string;   // "Neuanlage", "Freigabe", "Bearbeiten"
  object: string;   // "Artikel", "Fertigungsvorschlag"
}

/** Process chain definition */
export interface ProcessChain {
  name: string;       // "Fertigungsvorschlag"
  nameEn?: string;    // "Production proposal"
  tableRef?: string;  // "7:1"
  before: string[];   // ["Artikel", "Stückliste", "Arbeitsplan"]
  after: string[];    // ["Betriebsauftrag", "Arbeitsschein"]
}
