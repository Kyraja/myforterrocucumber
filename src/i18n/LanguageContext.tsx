/**
 * @module LanguageContext
 * React context provider and hook for German/English UI localisation.
 *
 * The active language is persisted in `localStorage` and auto-detected from
 * `navigator.language` on the first visit. The `t()` translation function
 * supports simple `{key}` placeholder substitution.
 */

import { createContext, useContext, useState, useCallback, useEffect, type ReactNode } from 'react';
import { translations as fallbackTranslations, type Language, type Translations } from './translations';

/**
 * Translation function type.
 * @param key - A key from {@link Translations}.
 * @param params - Optional `{placeholder}` substitution map.
 * @returns The localised string with placeholders replaced.
 */
export type TranslationFn = (key: keyof Translations, params?: Record<string, string | number>) => string;

/** Shape of the value provided by {@link LanguageProvider}. */
interface LanguageContextValue {
  /** Currently active language code. */
  lang: Language;
  /** Translate a key with optional placeholder substitution. */
  t: TranslationFn;
}

const LanguageContext = createContext<LanguageContextValue | null>(null);

function normalizeGermanUmlauts(text: string): string {
  return text
    .replace(/\bAe/g, 'Ä')
    .replace(/\bOe/g, 'Ö')
    .replace(/\bUe/g, 'Ü')
    .replace(/ae/g, 'ä')
    .replace(/oe/g, 'ö')
    // Avoid converting "Que..." patterns that are common in loanwords.
    .replace(/(?<![Qq])ue/g, 'ü');
}

function detectBrowserLanguage(): Language {
  const candidates = [...(navigator.languages ?? []), navigator.language];
  for (const candidate of candidates) {
    const normalized = candidate.toLowerCase();
    if (normalized.startsWith('de')) return 'de';
    if (normalized.startsWith('en')) return 'en';
  }
  return 'en';
}

/**
 * Provides language state and the `t()` translation function to the component tree.
 * The initial language is read from `localStorage`; if absent, it is inferred from
 * `navigator.language` (German for `de-*` locales, English otherwise).
 */
export function LanguageProvider({ children }: { children: ReactNode }) {
  const [dictionary, setDictionary] = useState<Record<Language, Translations>>(fallbackTranslations);

  const [lang, setLangState] = useState<Language>(() => {
    return detectBrowserLanguage();
  }, []);

  useEffect(() => {
    const updateLanguage = () => setLangState(detectBrowserLanguage());
    window.addEventListener('languagechange', updateLanguage);
    return () => window.removeEventListener('languagechange', updateLanguage);
  }, []);

  useEffect(() => {
    let cancelled = false;

    const loadJsonTranslations = async () => {
      try {
        const deUrl = new URL('../resources/i18n/de.json', import.meta.url).href;
        const enUrl = new URL('../resources/i18n/en.json', import.meta.url).href;

        const [deRes, enRes] = await Promise.all([
          fetch(deUrl, { cache: 'no-store' }),
          fetch(enUrl, { cache: 'no-store' }),
        ]);
        if (!deRes.ok || !enRes.ok) return;

        const [deJson, enJson] = await Promise.all([
          deRes.json() as Promise<Translations>,
          enRes.json() as Promise<Translations>,
        ]);
        if (cancelled) return;
        setDictionary({
          de: deJson,
          en: enJson,
        });
      } catch {
        // Keep fallback translations.ts map when JSON loading fails.
      }
    };

    void loadJsonTranslations();
    return () => { cancelled = true; };
  }, []);

  const t = useCallback(
    (key: keyof Translations, params?: Record<string, string | number>): string => {
      let text =
        dictionary[lang]?.[key]
        ?? fallbackTranslations[lang]?.[key]
        ?? dictionary.en?.[key]
        ?? fallbackTranslations.en?.[key]
        ?? key;
      if (params) {
        for (const [k, v] of Object.entries(params)) {
          text = text.replace(`{${k}}`, String(v));
        }
      }
      if (lang === 'de') {
        text = normalizeGermanUmlauts(text);
      }
      return text;
    },
    [dictionary, lang],
  );

  return (
    <LanguageContext.Provider value={{ lang, t }}>
      {children}
    </LanguageContext.Provider>
  );
}

/**
 * Hook to access the current language and translation function.
 * Must be called inside a {@link LanguageProvider}.
 *
 * @throws If called outside of {@link LanguageProvider}.
 * @returns `{ lang, setLang, t }`
 */
export function useTranslation() {
  const ctx = useContext(LanguageContext);
  if (!ctx) throw new Error('useTranslation must be used within LanguageProvider');
  return ctx;
}
