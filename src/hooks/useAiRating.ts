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
import { getRatingPromptForLang, parseRatingResponse } from '../lib/aiPrompt';
import type { AiPromptRating } from '../lib/aiPrompt';
import type { WorkflowEmitter } from '../lib/workflowEmitter';
import { getPhaseLabel } from '../lib/workflowLabels';

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
  requestRating: (
    text: string,
    model: string,
    agentId: string,
    emitter?: WorkflowEmitter,
    lang?: 'de' | 'en',
  ) => Promise<void>;
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

  const requestRating = async (
    text: string,
    model: string,
    agentId: string,
    emitter?: WorkflowEmitter,
    lang: 'de' | 'en' = 'de',
  ) => {
    if (!isLoggedIn()) {
      setError(lang === 'en' ? 'Not signed in. Please sign in first.' : 'Nicht eingeloggt. Bitte zuerst anmelden.');
      return;
    }
    if (!agentId) {
      setError(
        lang === 'en'
          ? 'No agent selected. Please create or select an agent first.'
          : 'Kein Agent ausgewählt. Bitte zuerst einen Agent erstellen oder auswählen.',
      );
      return;
    }

    setError(null);
    setLoading(true);

    try {
      const ratingPrompt = getRatingPromptForLang(lang);
      const userMessage = lang === 'en'
        ? `TASK: Rate the following requirements text. Do NOT generate Gherkin — respond ONLY with JSON.\n\n${ratingPrompt}\n\nRequirements text:\n\n${text}`
        : `AUFGABE: Bewerte den folgenden Anforderungstext. Generiere KEIN Gherkin, sondern antworte NUR mit JSON.\n\n${ratingPrompt}\n\nAnforderungstext:\n\n${text}`;
      const ratingDetails = lang === 'en'
        ? `Rating | Mode: Agent (Editor) | Description text only (${text.length} chars), no tables`
        : `Bewertung | Modus: Agent (Editor) | Nur Beschreibungstext (${text.length} Zeichen), keine Tabellen`;

      emitter?.emitLocal({
        phase: 'rating-input',
        label: getPhaseLabel('rating-input', lang),
        summary: `${text.length} ${lang === 'de' ? 'Zeichen Anforderungstext' : 'chars requirements text'}`,
        inputText: text,
      });

      const response = emitter
        ? await emitter.emitAiCall(
            {
              phase: 'rating-call',
              label: getPhaseLabel('rating-call', lang),
              agent: 'rating',
              systemPrompt: ratingPrompt,
              userPrompt: userMessage,
              model,
            },
            async () => {
              const r = await chatWithAgentSync(agentId, userMessage, 'rating', model, ratingDetails);
              return r.response;
            },
          )
        : (await chatWithAgentSync(agentId, userMessage, 'rating', model, ratingDetails)).response;

      const parsed = parseRatingResponse(response);

      updateLastResponseSummary(
        parsed
          ? lang === 'en'
            ? `Response: Score ${parsed.score}% | ${parsed.reason} | ${parsed.suggestions.length} suggestions`
            : `Antwort: Score ${parsed.score}% | ${parsed.reason} | ${parsed.suggestions.length} Vorschläge`
          : lang === 'en'
            ? `Response: could not be parsed | Raw response: ${response.slice(0, 200)}`
            : `Antwort: Konnte nicht geparst werden | Rohantwort: ${response.slice(0, 200)}`
      );

      if (!parsed) {
        emitter?.emitLocal({
          phase: 'rating-parse',
          label: lang === 'de' ? 'Parse-Fehler' : 'Parse error',
          summary: lang === 'de' ? 'Antwort nicht parsebar' : 'Response not parseable',
          inputText: response,
        });
        setError(
          lang === 'en'
            ? 'AI response could not be parsed as a rating.'
            : 'KI-Antwort konnte nicht als Bewertung geparst werden.',
        );
        return;
      }

      emitter?.emitLocal({
        phase: 'rating-parse',
        label: getPhaseLabel('rating-parse', lang),
        summary: `Score ${parsed.score}% · ${parsed.suggestions.length} ${lang === 'de' ? 'Vorschläge' : 'suggestions'}`,
        outputText: lang === 'en'
          ? `Score: ${parsed.score}%\nReason: ${parsed.reason}\n\nSuggestions:\n${parsed.suggestions.map(s => `- ${s}`).join('\n')}`
          : `Score: ${parsed.score}%\nGrund: ${parsed.reason}\n\nVorschläge:\n${parsed.suggestions.map(s => `- ${s}`).join('\n')}`,
      });

      setRating(parsed);
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : lang === 'en'
            ? 'Error during AI rating'
            : 'Fehler bei der KI-Bewertung',
      );
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
