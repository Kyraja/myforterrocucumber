import type { WorkflowPhase } from '../types/fop';

type LabelPair = { de: string; en: string };

const LABELS: Record<WorkflowPhase, LabelPair> = {
  // FOP analysis
  'fop-parsing':        { de: 'FOP parsen',                en: 'Parse FOP' },
  'fop-buffers':        { de: 'Buffer-Tracking',           en: 'Buffer tracking' },
  'fop-fields':         { de: 'Feldauflösung',             en: 'Field resolution' },
  'fop-local-check':    { de: 'Lokale Richtlinien-Prüfung', en: 'Local guidelines check' },
  'fop-analyst':        { de: 'FOP-Analyst (KI)',          en: 'FOP Analyst (AI)' },
  'fop-guidelines':     { de: 'FOP-Richtlinien (KI)',      en: 'FOP Guidelines (AI)' },
  'fop-cache-save':     { de: 'Cache speichern',           en: 'Save cache' },
  // Cucumber from text
  'cuc-table-id-local': { de: 'Tabellen-ID (lokal)',       en: 'Table ID (local)' },
  'cuc-table-id-ai':    { de: 'Tabellen-ID (KI)',          en: 'Table ID (AI)' },
  'cuc-kb-extract':     { de: 'KB-Stichpunkte (KI)',       en: 'KB keywords (AI)' },
  'cuc-kb-search':      { de: 'KB-Suche (lokal)',          en: 'KB search (local)' },
  'cuc-context-send':   { de: 'Tabellen-Kontext (KI)',     en: 'Table context (AI)' },
  'cuc-kb-send':        { de: 'KB-Kontext senden (KI)',    en: 'Send KB context (AI)' },
  'cuc-build-prompt':   { de: 'Prompt zusammenbauen',      en: 'Build prompt' },
  'cuc-generate':       { de: 'Gherkin generieren (KI)',   en: 'Generate Gherkin (AI)' },
  'cuc-deep-round':     { de: 'Deep-Test-Runde (KI)',      en: 'Deep test round (AI)' },
  'cuc-parse':          { de: 'Antwort parsen',            en: 'Parse response' },
  'cuc-scenario-list':  { de: 'Szenarien-Liste (KI)',      en: 'Scenario list (AI)' },
  'cuc-scenario-single': { de: 'Szenario (KI)',            en: 'Scenario (AI)' },
  'cuc-scenario-continue': { de: 'Szenario-Fortsetzung (KI)', en: 'Scenario continuation (AI)' },
  'cuc-feature-assemble': { de: 'Feature zusammenbauen',   en: 'Assemble feature' },
  // Prompt rating
  'rating-input':       { de: 'Eingabe vorbereiten',       en: 'Prepare input' },
  'rating-call':        { de: 'Bewertung (KI)',            en: 'Rating (AI)' },
  'rating-parse':       { de: 'Bewertung parsen',          en: 'Parse rating' },
  // Agent free-chat
  'agent-chat-response': { de: 'Agent-Antwort (KI)',       en: 'Agent response (AI)' },
  // FOP → Cucumber deep-test
  'fop-cuc-table-id':    { de: 'FOP→Cuc Tabellen-ID (KI)', en: 'FOP→Cuc Table ID (AI)' },
  'fop-cuc-build-prompt': { de: 'FOP→Cuc Prompt',          en: 'FOP→Cuc prompt' },
  'fop-cuc-deep-round':  { de: 'FOP→Cuc Runde (KI)',       en: 'FOP→Cuc round (AI)' },
  'fop-cuc-force-final': { de: 'FOP→Cuc Final (KI)',       en: 'FOP→Cuc final (AI)' },
  'fop-cuc-parse':       { de: 'FOP→Cuc Parse',            en: 'FOP→Cuc parse' },
  // Bulk
  'bulk-package-start':  { de: 'Bulk-Paket starten',       en: 'Bulk package start' },
  'bulk-package-end':    { de: 'Bulk-Paket fertig',        en: 'Bulk package end' },
};

export function getPhaseLabel(phase: WorkflowPhase, lang: 'de' | 'en'): string {
  return LABELS[phase][lang];
}

export function getAllPhases(): WorkflowPhase[] {
  return Object.keys(LABELS) as WorkflowPhase[];
}
