/**
 * @module useGherkinGenerator
 * Thin memoized bridge between React state and the pure Gherkin generator.
 * Keeps the generated text and line mapping in sync with the FeatureInput
 * without forcing consumers to call the generator directly.
 */

import { useMemo } from 'react';
import type { FeatureInput } from '../types/gherkin';
import { generateGherkinWithMapping } from '../lib/generator';
import type { GherkinLineMapping } from '../lib/generator';

/**
 * Derives the Gherkin text and a line-to-step mapping from the given feature input.
 * The result is memoized — recomputation only happens when `input` changes.
 *
 * @param input - The current feature being edited.
 * @returns An object with the formatted Gherkin string and a map from line number
 *   to {@link GherkinLineMapping}, enabling click-to-step navigation in the preview.
 */
export function useGherkinGenerator(input: FeatureInput): { gherkin: string; lineMapping: Map<number, GherkinLineMapping> } {
  return useMemo(() => {
    const result = generateGherkinWithMapping(input);
    return { gherkin: result.text, lineMapping: result.lineMapping };
  }, [input]);
}
