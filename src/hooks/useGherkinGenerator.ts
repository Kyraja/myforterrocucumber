import { useMemo } from 'react';
import type { FeatureInput } from '../types/gherkin';
import { generateGherkinWithMapping } from '../lib/generator';
import type { GherkinLineMapping } from '../lib/generator';

export function useGherkinGenerator(input: FeatureInput): { gherkin: string; lineMapping: Map<number, GherkinLineMapping> } {
  return useMemo(() => {
    const result = generateGherkinWithMapping(input);
    return { gherkin: result.text, lineMapping: result.lineMapping };
  }, [input]);
}
