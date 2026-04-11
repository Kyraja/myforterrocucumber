/**
 * @module openrouter
 *
 * OpenRouter API client for AI chat completions.
 *
 * OpenRouter provides a unified OpenAI-compatible endpoint that routes
 * requests to multiple LLM providers. This module is the primary AI backend
 * used when no Anthropic API key is configured (development / consultant use).
 *
 * All requests use a 120-second abort timeout to prevent the UI from hanging
 * on slow model responses. Token usage from each call is recorded via
 * {@link recordTokenUsage} so consultants can monitor daily costs.
 *
 * Entry points: {@link openRouterChatCompletion}, {@link listOpenRouterModels}
 */

import { getOpenRouterKey, getOpenRouterModel } from './settings';
import { recordTokenUsage, type TokenPurpose } from './tokenHistory';
import { getTemperature } from './settings';

const OPENROUTER_BASE = 'https://openrouter.ai/api/v1';
const TIMEOUT_MS = 120_000;

type Message = { role: 'system' | 'user' | 'assistant'; content: string };

interface OpenRouterChoice {
  message?: { content?: string };
}

interface OpenRouterResponse {
  choices?: OpenRouterChoice[];
  usage?: {
    prompt_tokens: number;
    completion_tokens: number;
    total_tokens: number;
  };
  error?: { message?: string };
}

/**
 * Sends a chat completion request to OpenRouter and returns the model's response text.
 *
 * Reads the API key, model, and temperature from the app settings. Automatically
 * records token usage after a successful response. Provides specific error messages
 * for common failure modes (missing key, 401, 429, timeout).
 *
 * @param messages - Conversation history in OpenAI message format
 * @param purpose - Category label for the token usage log entry
 * @param details - Human-readable details for the token history (e.g. table names sent)
 * @returns The full text content of the model's first choice
 * @throws Error with a German user-facing message on any failure
 */
export async function openRouterChatCompletion(
  messages: Message[],
  purpose?: TokenPurpose,
  details?: string,
): Promise<string> {
  const apiKey = getOpenRouterKey();
  if (!apiKey) {
    throw new Error('Kein OpenRouter API Key gesetzt. Bitte in den Einstellungen eintragen.');
  }

  const model = getOpenRouterModel();
  const temperature = getTemperature();

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), TIMEOUT_MS);

  let res: Response;
  try {
    res = await fetch(`${OPENROUTER_BASE}/chat/completions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({ model, messages, temperature, stream: false }),
      signal: controller.signal,
    });
  } catch (err) {
    clearTimeout(timer);
    if (err instanceof DOMException && err.name === 'AbortError') {
      throw new Error(`Timeout nach ${TIMEOUT_MS / 1000}s — OpenRouter antwortet nicht.`);
    }
    throw new Error(`Netzwerkfehler (OpenRouter): ${err instanceof Error ? err.message : 'Verbindung fehlgeschlagen'}`);
  } finally {
    clearTimeout(timer);
  }

  if (!res.ok) {
    const body = await res.text().catch(() => '');
    if (res.status === 401) {
      throw new Error('OpenRouter API Key ungueltig. Bitte in den Einstellungen pruefen.');
    }
    if (res.status === 429) {
      throw new Error('OpenRouter Rate-Limit erreicht. Bitte kurz warten.');
    }
    throw new Error(`OpenRouter Fehler ${res.status}: ${body.slice(0, 200)}`);
  }

  const data: OpenRouterResponse = await res.json();

  if (data.error) {
    throw new Error(`OpenRouter: ${data.error.message}`);
  }

  if (data.usage) {
    recordTokenUsage({
      model: `[OR] ${model}`,
      promptTokens: data.usage.prompt_tokens,
      completionTokens: data.usage.completion_tokens,
      totalTokens: data.usage.total_tokens,
      purpose: purpose ?? 'unknown',
      ...(details && { details: `[OpenRouter] ${details}` }),
    });
  }

  const content = data.choices?.[0]?.message?.content;
  if (!content) {
    throw new Error('Leere Antwort von OpenRouter. Bitte erneut versuchen.');
  }
  return content;
}

// ── Model listing ────────────────────────────────────────────

export interface OpenRouterModel {
  id: string;
  name: string;
  pricing: { prompt: string; completion: string };
  context_length: number;
}

/**
 * Fetches the list of available models from OpenRouter and returns them
 * sorted alphabetically by model ID.
 *
 * Used to populate the model selector in the settings UI, so consultants
 * can choose cost/capability trade-offs without hardcoded model lists.
 *
 * @param apiKey - The OpenRouter API key (read from user input, not settings)
 * @returns Sorted array of models with id, name, pricing, and context length
 */
export async function listOpenRouterModels(apiKey: string): Promise<OpenRouterModel[]> {
  const res = await fetch(`${OPENROUTER_BASE}/models`, {
    headers: { Authorization: `Bearer ${apiKey}` },
  });
  if (!res.ok) {
    throw new Error(`OpenRouter Modelle laden fehlgeschlagen (${res.status})`);
  }
  const data: { data: OpenRouterModel[] } = await res.json();
  return data.data
    .filter((m) => m.id && m.name)
    .sort((a, b) => a.id.localeCompare(b.id));
}
