/**
 * Knowledge Base search — finds relevant chunks based on
 * identified tables, action-context pairs, and process chains.
 *
 * Keywords come from the uploaded Variablentabellen (TableDef),
 * NOT from the PDF text itself.
 */

import type { KBChunk, KBSearchResult, ActionContext, ProcessChain } from '../types/knowledgeBase';
import type { TableDef } from '../types/gherkin';

// ── Cache ─────────────────────────────────────────────────────

let _cachedChunks: KBChunk[] | null = null;
let _cacheTimestamp = 0;
const CACHE_TTL_MS = 30_000;

export function invalidateChunkCache(): void {
  _cachedChunks = null;
}

export async function getCachedChunks(): Promise<KBChunk[]> {
  if (_cachedChunks && Date.now() - _cacheTimestamp < CACHE_TTL_MS) {
    return _cachedChunks;
  }
  const { loadAllKBChunks } = await import('./kbStore');
  _cachedChunks = await loadAllKBChunks();
  _cacheTimestamp = Date.now();
  return _cachedChunks;
}

// ── Search ────────────────────────────────────────────────────

export interface KBSearchInput {
  /** Identified tables from Step 1 */
  tables: TableDef[];
  /** Action-context pairs from KI (e.g. [Neuanlage + Artikel]) */
  actionContexts?: ActionContext[];
  /** Process chain expansions (before/after tables) */
  processChains?: ProcessChain[];
  /** Raw requirements text for fallback matching */
  requirementsText?: string;
}

/**
 * Search the knowledge base for relevant chunks.
 * Uses table names (DE + EN), table refs, mask numbers as search terms.
 */
export function searchKnowledgeBase(
  chunks: KBChunk[],
  input: KBSearchInput,
  maxResults: number = 3,
): KBSearchResult[] {
  if (chunks.length === 0 || input.tables.length === 0) return [];

  // Build search terms from identified tables
  const searchTerms = buildSearchTerms(input);

  // Score each chunk
  const scored: KBSearchResult[] = [];
  for (const chunk of chunks) {
    const { score, matchedTerms } = scoreChunk(chunk, searchTerms, input.actionContexts);
    // Boost chunks that were rated positively, penalize negatively rated
    const ratingBoost = chunk.rating === 1 ? 1.5 : chunk.rating === -1 ? 0.3 : 1.0;
    const finalScore = score * ratingBoost;
    if (finalScore > 0) {
      scored.push({ chunk, score: finalScore, matchedTerms });
    }
  }

  // Sort by score descending, take top N
  scored.sort((a, b) => b.score - a.score);
  return scored.slice(0, maxResults);
}

// ── Search term building ──────────────────────────────────────

interface SearchTerms {
  /** Table refs like "7:1", "0:1" — highest weight */
  tableRefs: Set<string>;
  /** Mask numbers like 7, 32 */
  maskNumbers: Set<number>;
  /** Table names DE + EN like "Fertigungsvorschlag", "Production proposal" */
  tableNames: Set<string>;
  /** Process chain terms (before/after) */
  chainTerms: Set<string>;
}

/** Minimum word length for reverse-contains matching */
const MIN_CONTAINS_LEN = 4;

function buildSearchTerms(input: KBSearchInput): SearchTerms {
  const tableRefs = new Set<string>();
  const maskNumbers = new Set<number>();
  const tableNames = new Set<string>();
  const chainTerms = new Set<string>();

  for (const t of input.tables) {
    tableRefs.add(t.tableRef);
    if (t.maskNr !== undefined) maskNumbers.add(t.maskNr);
    // Add names in both languages
    const names = [t.nameDe, t.nameEn, t.name].filter(Boolean) as string[];
    for (const n of names) {
      tableNames.add(n.toLowerCase());
    }
    // For infosystems, also add the search word
    if (t.kind === 'infosystem') tableNames.add(t.tableRef.toLowerCase());
  }

  // Expand with process chain terms
  if (input.processChains) {
    for (const chain of input.processChains) {
      for (const term of [...chain.before, ...chain.after]) {
        chainTerms.add(term.toLowerCase());
      }
    }
  }

  return { tableRefs, maskNumbers, tableNames, chainTerms };
}

/**
 * Bidirectional contains: checks whether any word in `text` contains
 * `name` OR `name` contains any word from `text` (min length: MIN_CONTAINS_LEN).
 *
 * Language-agnostic — works for DE compounds ("Kundenstamm" ↔ "Kunde")
 * AND EN multi-word names ("Customer" ↔ "Customer master").
 *
 * Returns the matched word or null.
 */
function containsMatch(text: string, name: string): string | null {
  // Forward: text contains the full search term (exact substring)
  if (text.includes(name)) return name;

  // Reverse: search term contains a word from the text
  // Split text into words and check if any word is contained in the search term
  const words = text.split(/[\s,;:()/]+/);
  for (const word of words) {
    if (word.length < MIN_CONTAINS_LEN) continue;
    if (name.includes(word)) return word;
  }
  return null;
}

// ── Chunk scoring ─────────────────────────────────────────────

function scoreChunk(
  chunk: KBChunk,
  terms: SearchTerms,
  actionContexts?: ActionContext[],
): { score: number; matchedTerms: string[] } {
  let score = 0;
  const matchedTerms: string[] = [];
  const textLower = chunk.text.toLowerCase();
  const headingLower = chunk.heading.toLowerCase();
  const fullLower = `${headingLower} ${textLower}`;

  // 1. Table ref match with word boundaries
  // Heading match (chunk IS about this table) = 5, body-only (passing mention) = 2
  for (const ref of terms.tableRefs) {
    const escaped = ref.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const refRegex = new RegExp(`(?<![\\w.])${escaped}(?![\\w])`, 'i');
    if (refRegex.test(headingLower)) {
      score += 5;
      matchedTerms.push(`Ref:${ref}`);
    } else if (refRegex.test(textLower)) {
      score += 2;
      matchedTerms.push(`Ref(text):${ref}`);
    }
  }

  // 2. Mask number match (weight: 3)
  for (const nr of terms.maskNumbers) {
    const maskPatterns = [`maske ${nr}`, `mask ${nr}`, `maske${nr}`];
    if (maskPatterns.some(p => fullLower.includes(p))) {
      score += 3;
      matchedTerms.push(`Maske:${nr}`);
    }
  }

  // 3. Table name match — bidirectional contains
  // Exact match (heading contains "kundenstamm") = full weight
  // Contains match ("kundenstamm" contains "kunde" from heading) = reduced weight
  for (const name of terms.tableNames) {
    if (name.length < 3) continue;
    const headingMatch = containsMatch(headingLower, name);
    if (headingMatch) {
      const isExact = headingLower.includes(name);
      score += isExact ? 4 : 2.5;
      matchedTerms.push(`Heading${isExact ? '' : '~'}:${headingMatch}`);
    } else {
      const textMatch = containsMatch(textLower, name);
      if (textMatch) {
        const isExact = textLower.includes(name);
        score += isExact ? 2 : 1;
        matchedTerms.push(`Text${isExact ? '' : '~'}:${textMatch}`);
      }
    }
  }

  // 4. Process chain terms (weight: 1.5)
  for (const term of terms.chainTerms) {
    if (term.length < 3) continue;
    if (fullLower.includes(term)) {
      score += 1.5;
      matchedTerms.push(`Chain:${term}`);
    }
  }

  // 5. Action-context pair match (weight: 3 for combined match)
  if (actionContexts) {
    for (const ac of actionContexts) {
      const actionLower = ac.action.toLowerCase();
      const objectLower = ac.object.toLowerCase();
      const hasAction = fullLower.includes(actionLower);
      const hasObject = fullLower.includes(objectLower);
      if (hasAction && hasObject) {
        score += 3;
        matchedTerms.push(`Action:${ac.action}+${ac.object}`);
      } else if (hasObject) {
        score += 1;
      }
    }
  }

  // 6. Keyword match — chunk keywords vs table names/refs (weight: 2)
  if (chunk.keywords && chunk.keywords.length > 0) {
    for (const kw of chunk.keywords) {
      const kwLower = kw.toLowerCase();
      for (const name of terms.tableNames) {
        if (kwLower.includes(name) || name.includes(kwLower)) {
          score += 2;
          matchedTerms.push(`Keyword:${kw}`);
          break;
        }
      }
    }
  }

  // 7. Heading hierarchy context boost (×1.2)
  if (chunk.headingHierarchy.length > 0) {
    const hierLower = chunk.headingHierarchy.join(' ').toLowerCase();
    for (const name of terms.tableNames) {
      if (hierLower.includes(name)) {
        score *= 1.2;
        matchedTerms.push(`Hierarchy:${name}`);
        break;
      }
    }
  }

  return { score, matchedTerms };
}

// ── Default process chains ────────────────────────────────────

export const DEFAULT_PROCESS_CHAINS: ProcessChain[] = [
  {
    name: 'Fertigungsvorschlag', nameEn: 'Production proposal', tableRef: '7:1',
    before: ['Artikel', 'Stückliste', 'Arbeitsplan'],
    after: ['Betriebsauftrag', 'Arbeitsschein'],
  },
  {
    name: 'Verkaufsauftrag', nameEn: 'Sales order', tableRef: '3:23',
    before: ['Kunde', 'Artikel'],
    after: ['Lieferschein', 'Rechnung'],
  },
  {
    name: 'Einkaufsauftrag', nameEn: 'Purchase order', tableRef: '3:22',
    before: ['Lieferant', 'Artikel'],
    after: ['Einkaufslieferschein', 'Einkaufsrechnung'],
  },
  {
    name: 'Bestellvorschlag', nameEn: 'Purchase proposal', tableRef: '12:22',
    before: ['Artikel', 'Lieferant'],
    after: ['Bestellung', 'Einkaufslieferschein'],
  },
  {
    name: 'Lieferschein', nameEn: 'Delivery note', tableRef: '3:25',
    before: ['Verkaufsauftrag', 'Kunde', 'Artikel'],
    after: ['Rechnung'],
  },
  {
    name: 'Rechnung', nameEn: 'Invoice', tableRef: '3:24',
    before: ['Lieferschein', 'Verkaufsauftrag'],
    after: [],
  },
  {
    name: 'Betriebsauftrag', nameEn: 'Production order', tableRef: '3:42',
    before: ['Fertigungsvorschlag', 'Artikel', 'Stückliste'],
    after: ['Arbeitsschein'],
  },
];

/**
 * Find process chains relevant to the identified tables.
 */
export function findRelevantChains(tables: TableDef[], chains: ProcessChain[] = DEFAULT_PROCESS_CHAINS): ProcessChain[] {
  return chains.filter(chain => {
    const nameLower = chain.name.toLowerCase();
    return tables.some(t =>
      t.tableRef === chain.tableRef ||
      (t.nameDe?.toLowerCase().includes(nameLower)) ||
      (t.nameEn?.toLowerCase().includes(chain.nameEn?.toLowerCase() ?? '')) ||
      t.name.toLowerCase().includes(nameLower)
    );
  });
}
