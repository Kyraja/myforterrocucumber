/**
 * @module EventChip
 * Coloured badge component that displays an abas ERP FOP/IS event code (e.g.
 * "SE", "FV", "BA") as a human-readable label in German or English. The chip's
 * colour is determined by event category (mask, field, button, row, report).
 * Optionally appends the raw code in parentheses when `showCode` is true.
 * Also exports `getEventLabel` as a standalone helper for use outside JSX.
 */
import styles from './EventChip.module.css';

// ── Event label maps ──────────────────────────────────────────

const EVENT_LABELS_DE: Record<string, string> = {
  // Masken-Events
  'SE':  'Masken-Eintritt',
  'SEE': 'Masken-Ende',
  'SV':  'Masken-Prüfung',
  'SC':  'Masken-Abbruch',
  'SX':  'Masken-Austritt',
  // Feld-Events
  'FE':  'Feld-Eintritt',
  'FF':  'Feld-Ausgefüllt',
  'FV':  'Feld-Prüfung',
  'FX':  'Feld-Austritt',
  // Button-Events
  'BB':  'Button-Vor',
  'BA':  'Button-Nach',
  // Zeilen-Events
  'RIB': 'Zeile-Einfügen-Vor',
  'RIA': 'Zeile-Einfügen-Nach',
  'RDB': 'Zeile-Löschen-Vor',
  'RDA': 'Zeile-Löschen-Nach',
  'RH':  'Zeile-Markieren',
  'RMB': 'Zeilen-Verschieben-Vor',
  'RMA': 'Zeilen-Verschieben-Nach',
  // Bericht
  'BFUSS': 'Berichtsfuß',
};

const EVENT_LABELS_EN: Record<string, string> = {
  'SE':  'Mask Entry',
  'SEE': 'Mask End',
  'SV':  'Mask Check',
  'SC':  'Mask Cancel',
  'SX':  'Mask Exit',
  'FE':  'Field Entry',
  'FF':  'Field Fill',
  'FV':  'Field Check',
  'FX':  'Field Exit',
  'BB':  'Button Before',
  'BA':  'Button After',
  'RIB': 'Row Insert Before',
  'RIA': 'Row Insert After',
  'RDB': 'Row Delete Before',
  'RDA': 'Row Delete After',
  'RH':  'Row Mark',
  'RMB': 'Row Move Before',
  'RMA': 'Row Move After',
  'BFUSS': 'Report Footer',
};

// ── Event categories → CSS modifier class ────────────────────

type EventCategory = 'mask' | 'field' | 'button' | 'row' | 'report' | 'unknown';

function getCategory(event: string): EventCategory {
  if (['SE', 'SEE', 'SV', 'SC', 'SX'].includes(event)) return 'mask';
  if (['FE', 'FF', 'FV', 'FX'].includes(event)) return 'field';
  if (['BB', 'BA'].includes(event)) return 'button';
  if (['RIB', 'RIA', 'RDB', 'RDA', 'RH', 'RMB', 'RMA'].includes(event)) return 'row';
  if (event === 'BFUSS') return 'report';
  return 'unknown';
}

const CATEGORY_CLASS: Record<EventCategory, string> = {
  mask:    'chipMask',
  field:   'chipField',
  button:  'chipButton',
  row:     'chipRow',
  report:  'chipReport',
  unknown: 'chipUnknown',
};

// ── Component ──────────────────────────────────────────────────

interface EventChipProps {
  event: string;       // Short code: "SE", "BA", "FV" etc.
  lang: 'de' | 'en';
  /** If true, show short code in parens: "Button-Nach (BA)" */
  showCode?: boolean;
}

export function EventChip({ event, lang, showCode = false }: EventChipProps) {
  const labels = lang === 'de' ? EVENT_LABELS_DE : EVENT_LABELS_EN;
  const label = labels[event.toUpperCase()] ?? event;
  const category = getCategory(event.toUpperCase());
  const cls = `${styles.chip} ${styles[CATEGORY_CLASS[category]]}`;

  return (
    <span className={cls} title={`${event} — ${label}`}>
      {label}
      {showCode && <span className={styles.code}>{event}</span>}
    </span>
  );
}

// Export helpers for use in other components
export function getEventLabel(event: string, lang: 'de' | 'en'): string {
  const labels = lang === 'de' ? EVENT_LABELS_DE : EVENT_LABELS_EN;
  return labels[event.toUpperCase()] ?? event;
}
