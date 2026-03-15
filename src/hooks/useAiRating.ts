import { useState } from 'react';
import type { TableDef } from '../types/gherkin';
import { chatCompletion, isLoggedIn } from '../lib/myforterroApi';
import { buildRatingMessages, parseRatingResponse } from '../lib/aiPrompt';
import type { AiPromptRating } from '../lib/aiPrompt';

interface UseAiRatingResult {
  loading: boolean;
  error: string | null;
  rating: AiPromptRating | null;
  requestRating: (text: string, model: string, tables?: TableDef[]) => Promise<void>;
  clearRating: () => void;
}

export function useAiRating(): UseAiRatingResult {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [rating, setRating] = useState<AiPromptRating | null>(null);

  const requestRating = async (text: string, model: string, tables?: TableDef[]) => {
    if (!isLoggedIn()) {
      setError('Nicht eingeloggt. Bitte zuerst anmelden.');
      return;
    }

    setError(null);
    setLoading(true);

    try {
      const tableInfo = tables?.map((t) => ({
        name: t.name,
        tableRef: t.tableRef,
        kind: t.kind,
      }));

      const messages = buildRatingMessages(text, tableInfo);
      const response = await chatCompletion(messages, model);
      const parsed = parseRatingResponse(response);

      if (!parsed) {
        setError('KI-Antwort konnte nicht als Bewertung geparst werden.');
        return;
      }

      setRating(parsed);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Fehler bei der KI-Bewertung');
    } finally {
      setLoading(false);
    }
  };

  const clearRating = () => {
    setRating(null);
    setError(null);
  };

  return { loading, error, rating, requestRating, clearRating };
}
