import { useState } from 'react';
import type { FeatureInput, TableDef } from '../types/gherkin';
import { chatCompletion, isLoggedIn, TokenLimitError } from '../lib/myforterroApi';
import {
  buildMessages,
  identifyTablesLocally,
  buildTableIdentificationMessages,
  parseTableIdentificationResponse,
  lookupRelevantTables,
  buildMessagesWithFields,
  extractGherkin,
  extractPromptRating,
} from '../lib/aiPrompt';
import type { AiPromptRating } from '../lib/aiPrompt';
import { parseGherkin } from '../lib/gherkinParser';
import { resolveTableRefs } from '../lib/resolveTableRefs';

export type GenerationStep = 'idle' | 'identifying-tables' | 'generating-gherkin';

interface GenerateResult {
  feature: FeatureInput;
  aiRating: AiPromptRating | null;
}

interface UseAiGenerationResult {
  loading: boolean;
  generationStep: GenerationStep;
  error: string | null;
  generate: (text: string, model: string, testUser?: string, tables?: TableDef[]) => Promise<GenerateResult | null>;
}

export function useAiGeneration(): UseAiGenerationResult {
  const [generationStep, setGenerationStep] = useState<GenerationStep>('idle');
  const [error, setError] = useState<string | null>(null);

  const loading = generationStep !== 'idle';

  const generate = async (text: string, model: string, testUser?: string, tables?: TableDef[]): Promise<GenerateResult | null> => {
    if (!isLoggedIn()) {
      setError('Nicht eingeloggt. Bitte zuerst anmelden.');
      return null;
    }

    setError(null);

    try {
      let messages: { role: 'system' | 'user'; content: string }[];

      // Local table identification first, AI fallback if nothing found
      const tablesWithFields = tables?.filter((t) => t.fields.length > 0) ?? [];

      if (tablesWithFields.length > 0) {
        let relevantTables = identifyTablesLocally(text, tablesWithFields);

        // Fallback: if local matching found nothing, ask AI (handles typos, implicit references)
        if (relevantTables.length === 0) {
          setGenerationStep('identifying-tables');
          const step1Messages = buildTableIdentificationMessages(text, tables!);
          const step1Response = await chatCompletion(step1Messages, model);
          const identified = parseTableIdentificationResponse(step1Response);
          relevantTables = lookupRelevantTables(identified, tablesWithFields);
        }

        setGenerationStep('generating-gherkin');
        if (relevantTables.length > 0) {
          messages = buildMessagesWithFields(text, relevantTables, testUser);
        } else {
          messages = buildMessages(text, testUser, tables);
        }
      } else {
        setGenerationStep('generating-gherkin');
        messages = buildMessages(text, testUser, tables);
      }

      const response = await chatCompletion(messages, model);

      // Extract AI rating before stripping code fences
      const { cleaned, rating: aiRating } = extractPromptRating(response);

      const gherkin = extractGherkin(cleaned);
      let parsed = parseGherkin(gherkin);

      if (tables && tables.length > 0) {
        parsed = resolveTableRefs(parsed, tables);
      }

      if (parsed.scenarios.length === 0) {
        setError('Die KI-Antwort enthielt keine Szenarien. Bitte versuche es erneut.');
        return null;
      }

      return { feature: parsed, aiRating };
    } catch (err) {
      if (err instanceof TokenLimitError) {
        setError(err.message);
        throw err; // re-throw so callers can abort their loop
      }
      setError(err instanceof Error ? err.message : 'Unbekannter Fehler bei der KI-Generierung');
      return null;
    } finally {
      setGenerationStep('idle');
    }
  };

  return { loading, generationStep, error, generate };
}
