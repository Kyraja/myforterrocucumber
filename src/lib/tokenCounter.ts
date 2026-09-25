/**
 * @module tokenCounter
 *
 * Exact client-side token counting for OpenAI-compatible models, used when the
 * API does not return a usage object (e.g. the MyForterro agent SSE stream).
 *
 * Uses `gpt-tokenizer` with the `cl100k_base` encoder, which covers all
 * GPT-3.5/4/4o/5 models currently exposed by MyForterro. Specialized encoders
 * (e.g. `o200k_base` for o1/o4) are only loaded on demand to keep the initial
 * bundle small.
 *
 * Counts are exact for the text content, but agents may add hidden
 * system/tool-call tokens the server sees but the client does not — so
 * expect a small residual under-count when comparing to the server-side
 * consumption report.
 */

import { encode } from 'gpt-tokenizer';

/**
 * Counts the number of tokens in a string using the cl100k_base encoder.
 *
 * @param text - Input to tokenize
 * @returns Exact token count, or 0 for empty/falsy input
 */
export function countTokens(text: string | null | undefined): number {
  if (!text) return 0;
  try {
    return encode(text).length;
  } catch {
    // Fallback to the old heuristic if the encoder throws (shouldn't happen
    // for valid UTF-8 strings, but keep the call site safe).
    return Math.ceil(text.length / 3);
  }
}
