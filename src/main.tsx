/**
 * @module main
 * Application entry point — mounts the React component tree into the DOM.
 *
 * Wraps the root `App` component in React `StrictMode` and the `LanguageProvider`
 * context so that i18n is available throughout the entire component tree from
 * the very first render.
 */
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { LanguageProvider } from './i18n';
import './styles/global.css';
import App from './App';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <LanguageProvider>
      <App />
    </LanguageProvider>
  </StrictMode>,
);
