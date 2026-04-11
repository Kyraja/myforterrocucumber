import { useState } from 'react';
import type { FeatureInput, TableDef } from '../types/gherkin';
import { isLoggedIn, TokenLimitError } from '../lib/myforterroApi';
import type { AiPromptRating } from '../lib/aiPrompt';
import { generatePackage } from '../lib/generatePackage';

export type GenerationStep = 'idle' | 'identifying-tables' | 'generating-gherkin';

interface GenerateResult {
  feature: FeatureInput;
  aiRating: AiPromptRating | null;
  tableIdPath: 'local' | 'ki' | 'none';
  identifiedTables: string[];
  fieldCount: number;
  tableIdRequest?: string;
  tableIdRawResponse?: string;
  gherkinRequest?: string;
  rawResponse?: string;
  tableContext?: string;
}

interface UseAiGenerationResult {
  loading: boolean;
  generationStep: GenerationStep;
  error: string | null;
  generate: (
    text: string, model: string, agentId: string, testUser?: string,
    tables?: TableDef[], featureName?: string,
    onDelta?: (text: string) => void,
    onTablesIdentified?: (info: { path: 'local'|'ki'; tables: string[]; fieldCount: number }) => void,
    forcedRelevantTables?: TableDef[],
    onRound?: (round: number, maxRounds: number, sent: string, received: string) => void,
  ) => Promise<GenerateResult | null>;
}

export function useAiGeneration(): UseAiGenerationResult {
  const [generationStep, setGenerationStep] = useState<GenerationStep>('idle');
  const [error, setError] = useState<string | null>(null);

  const loading = generationStep !== 'idle';

  const generate = async (
    text: string,
    model: string,
    agentId: string,
    testUser?: string,
    tables?: TableDef[],
    featureName?: string,
    onDelta?: (text: string) => void,
    onTablesIdentified?: (info: { path: 'local'|'ki'; tables: string[]; fieldCount: number }) => void,
    forcedRelevantTables?: TableDef[],
    onRound?: (round: number, maxRounds: number, sent: string, received: string) => void,
  ): Promise<GenerateResult | null> => {
    if (!isLoggedIn()) {
      setError('Nicht eingeloggt. Bitte zuerst anmelden.');
      return null;
    }
    if (!agentId) {
      setError('Kein Agent ausgewählt. Bitte zuerst einen Agent erstellen oder auswählen.');
      return null;
    }

    setError(null);

    try {
      setGenerationStep('identifying-tables');

      const { getTestDepth } = await import('../lib/settings');
      const result = await generatePackage({
        text,
        model,
        tables: tables ?? [],
        testUser,
        agentId,
        featureName,
        onDelta,
        onTablesIdentified,
        forcedRelevantTables,
        testDepth: getTestDepth(),
        maxRounds: (await import('../lib/settings')).getDeepTestMaxRounds(),
        onRound,
      });

      setGenerationStep('generating-gherkin');

      // Extract AI rating if present in response
      const aiRating: AiPromptRating | null = null;

      if (result.feature.scenarios.length === 0) {
        setError('Die KI-Antwort enthielt keine Szenarien. Bitte versuche es erneut.');
        return null;
      }

      return {
        feature: result.feature,
        aiRating,
        tableIdPath: result.tableIdPath,
        identifiedTables: result.identifiedTables,
        fieldCount: result.fieldCount,
        tableIdRequest: result.tableIdRequest,
        tableIdRawResponse: result.tableIdRawResponse,
        gherkinRequest: result.gherkinRequest,
        rawResponse: result.rawResponse,
        tableContext: result.tableContext,
      };
    } catch (err) {
      if (err instanceof TokenLimitError) {
        setError(err.message);
        throw err;
      }
      setError(err instanceof Error ? err.message : 'Unbekannter Fehler bei der KI-Generierung');
      return null;
    } finally {
      setGenerationStep('idle');
    }
  };

  return { loading, generationStep, error, generate };
}
