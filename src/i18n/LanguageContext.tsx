/**
 * @module LanguageContext
 * React context provider and hook for German/English UI localisation.
 *
 * The active language is persisted in `localStorage` and auto-detected from
 * `navigator.language` on the first visit. The `t()` translation function
 * supports simple `{key}` placeholder substitution.
 */

import { createContext, useContext, useState, useCallback, type ReactNode } from 'react';
import { translations, type Language, type Translations } from './translations';

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
  /** Change the language and persist the choice in `localStorage`. */
  setLang: (lang: Language) => void;
  /** Translate a key with optional placeholder substitution. */
  t: TranslationFn;
}

const LanguageContext = createContext<LanguageContextValue | null>(null);

/** localStorage key for persisting the user's language preference. */
const STORAGE_KEY = 'cucumbergnerator_lang';

/**
 * Provides language state and the `t()` translation function to the component tree.
 * The initial language is read from `localStorage`; if absent, it is inferred from
 * `navigator.language` (German for `de-*` locales, English otherwise).
 */
export function LanguageProvider({ children }: { children: ReactNode }) {
  const [lang, setLangState] = useState<Language>(() => {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved === 'de' || saved === 'en') return saved;
    return navigator.language.startsWith('de') ? 'de' : 'en';
  });

  const setLang = useCallback((newLang: Language) => {
    setLangState(newLang);
    localStorage.setItem(STORAGE_KEY, newLang);
  }, []);

  const t = useCallback(
    (key: keyof Translations, params?: Record<string, string | number>): string => {
      let text = translations[lang][key] ?? key;
      if (params) {
        for (const [k, v] of Object.entries(params)) {
          text = text.replace(`{${k}}`, String(v));
        }
      }
      return text;
    },
    [lang],
  );

  return (
    <LanguageContext.Provider value={{ lang, setLang, t }}>
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
