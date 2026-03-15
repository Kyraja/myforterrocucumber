import { createContext, useContext, useState, useCallback, type ReactNode } from 'react';
import { translations, type Language, type Translations } from './translations';

export type TranslationFn = (key: keyof Translations, params?: Record<string, string | number>) => string;

interface LanguageContextValue {
  lang: Language;
  setLang: (lang: Language) => void;
  t: TranslationFn;
}

const LanguageContext = createContext<LanguageContextValue | null>(null);

const STORAGE_KEY = 'cucumbergnerator_lang';

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

export function useTranslation() {
  const ctx = useContext(LanguageContext);
  if (!ctx) throw new Error('useTranslation must be used within LanguageProvider');
  return ctx;
}
