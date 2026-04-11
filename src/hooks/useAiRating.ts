/**
 * @module useAiRating
 * Hook that submits a requirements text to the myForterro AI agent and returns
 * a structured quality rating ({@link AiPromptRating}).
 *
 * The rating complements the local static pre-rating (`lib/promptRating`) with
 * semantic feedback — consistency checks, missing context, etc. — that only an
 * LLM can provide.
 */

import { useState } from 'react';
import { chatWithAgentSync, isLoggedIn } from '../lib/myforterroApi';
import { updateLastResponseSummary } from '../lib/tokenHistory';
import { DEFAULT_RATING_PROMPT, parseRatingResponse } from '../lib/aiPrompt';
import type { AiPromptRating } from '../lib/aiPrompt';

/** Return value of {@link useAiRating}. */
interface UseAiRatingResult {
  /** True while the AI call is in flight. */
  loading: boolean;
  /** Error message from the last failed request, or `null` when clean. */
  error: string | null;
  /** Parsed rating from the last successful response, or `null` before first request. */
  rating: AiPromptRating | null;
  /**
   * Send `text` to the AI agent and populate `rating` on success.
   * Guards against unauthenticated state and missing agent ID before making the call.
   */
  requestRating: (text: string, model: string, agentId: string) => Promise<void>;
  /** Reset rating and error back to their initial values. */
  clearRating: () => void;
}

/**
 * Hook for requesting an AI-powered prompt quality rating.
 *
 * Wraps the myForterro agent API: constructs the rating prompt, calls
 * `chatWithAgentSync`, parses the JSON response, and exposes loading/error
 * state to the caller.
 *
 * @returns {@link UseAiRatingResult}
 */
export function useAiRating(): UseAiRatingResult {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [rating, setRating] = useState<AiPromptRating | null>(null);

  const requestRating = async (text: string, model: string, agentId: string) => {
    if (!isLoggedIn()) {
      setError('Nicht eingeloggt. Bitte zuerst anmelden.');
      return;
    }
    if (!agentId) {
      setError('Kein Agent ausgewählt. Bitte zuerst einen Agent erstellen oder auswählen.');
      return;
    }

    setError(null);
    setLoading(true);

    try {
      const userMessage = `AUFGABE: Bewerte den folgenden Anforderungstext. Generiere KEIN Gherkin, sondern antworte NUR mit JSON.\n\n${DEFAULT_RATING_PROMPT}\n\nAnforderungstext:\n\n${text}`;
      const ratingDetails = `Bewertung | Modus: Agent (Editor) | Nur Beschreibungstext (${text.length} Zeichen), keine Tabellen`;
      const result = await chatWithAgentSync(agentId, userMessage, null, 'rating', model, ratingDetails);
      const parsed = parseRatingResponse(result.response);

      updateLastResponseSummary(
        parsed
          ? `Antwort: Score ${parsed.score}% | ${parsed.reason} | ${parsed.suggestions.length} Vorschläge`
          : `Antwort: Konnte nicht geparst werden | Rohantwort: ${result.response.slice(0, 200)}`
      );

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
