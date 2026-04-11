/**
 * @module useProcessFlow
 * Hook managing the live state of the process-flow visualization diagram.
 *
 * The diagram accompanies AI generation runs to give users a step-by-step view
 * of what the system is currently doing (parsing, calling the AI, caching, etc.).
 * Two flow types are supported: `'cucumber'` (Gherkin generation) and `'fop'`
 * (FOP analysis pipeline).
 *
 * Each step can be independently activated, completed, failed, or populated with
 * diagnostic items — allowing callers to drive the diagram from async callbacks
 * without coupling it to component state.
 */

import { useState, useCallback } from 'react';
import type { DiagramFlow, DiagramStep, DiagramItem } from '../components/ProcessDiagram/ProcessDiagram';

/** Which pipeline the diagram currently visualizes. `null` means no active flow. */
export type FlowType = 'cucumber' | 'fop' | null;

// ── Default step definitions for each flow ────────────────────

export const CUCUMBER_STEPS: DiagramStep[] = [
  { id: 'read-ap',      labelDe: 'AP lesen',          labelEn: 'Read Package',    type: 'local',  status: 'pending',
    descDe: 'Das Arbeitspaket (Kapitel aus dem Konzeptdokument) wird gelesen und der Anforderungstext extrahiert.',
    descEn: 'The work package (chapter from the concept document) is read and the requirements text is extracted.' },
  { id: 'branch-tables',labelDe: 'Tabellen?',         labelEn: 'Tables?',         type: 'branch', status: 'pending',
    descDe: 'Entscheidung: Werden die relevanten Datenbanken lokal per V/P-Notation erkannt oder muss die KI sie identifizieren?',
    descEn: 'Decision: Are the relevant databases detected locally via V/P notation or does the AI need to identify them?' },
  { id: 'local-tables', labelDe: 'Lokal ermittelt',   labelEn: 'Local detect',    type: 'local',  status: 'pending',
    descDe: 'V-Notation (z.B. V-00-01) oder P-Notation (z.B. P0:1) im Text gefunden → Datenbank direkt zugeordnet, Felder aus der Variablentabelle geladen.',
    descEn: 'V-notation (e.g. V-00-01) or P-notation (e.g. P0:1) found in text → database directly matched, fields loaded from variable table.' },
  { id: 'ki-tables',    labelDe: 'KI ermittelt',      labelEn: 'AI detect',       type: 'ki',     status: 'pending', agentType: 'cucumber',
    descDe: 'Keine V/P-Notation im Text → KI analysiert den Anforderungstext und identifiziert relevante Datenbanken und Infosysteme anhand von Fachbegriffen.',
    descEn: 'No V/P notation in text → AI analyzes the requirements text and identifies relevant databases and infosystems based on domain terms.' },
  { id: 'build-prompt', labelDe: 'Prompt aufbauen',   labelEn: 'Build Prompt',    type: 'local',  status: 'pending',
    descDe: 'Der Prompt wird aus dem Anforderungstext, den erkannten Tabellenfeldern (Kopf/Tabelle, Skip-Status) und den Gherkin-Regeln zusammengebaut.',
    descEn: 'The prompt is assembled from the requirements text, detected table fields (header/table, skip status) and the Gherkin rules.' },
  { id: 'gen-gherkin',  labelDe: 'Gherkin generieren',labelEn: 'Generate Gherkin',type: 'ki',     status: 'pending', agentType: 'cucumber',
    descDe: 'Die KI generiert aus dem zusammengebauten Prompt vollständige Gherkin-Testszenarien mit abas Cucumber Standard-Steps.',
    descEn: 'The AI generates complete Gherkin test scenarios with abas Cucumber standard steps from the assembled prompt.' },
  { id: 'branch-result',labelDe: 'Ergebnis?',         labelEn: 'Result?',         type: 'branch', status: 'pending',
    descDe: 'Prüfung ob die KI-Antwort gültige Szenarien enthält.',
    descEn: 'Check whether the AI response contains valid scenarios.' },
  { id: 'result-ok',    labelDe: 'Erfolgreich',       labelEn: 'Success',         type: 'local',  status: 'pending',
    descDe: 'Szenarien erfolgreich generiert und im Editor verfügbar.',
    descEn: 'Scenarios successfully generated and available in the editor.' },
  { id: 'result-err',   labelDe: 'Fehler',            labelEn: 'Error',           type: 'local',  status: 'pending',
    descDe: 'Fehler bei der Generierung — z.B. KI-Antwort enthielt keine Szenarien oder Token-Limit erreicht.',
    descEn: 'Error during generation — e.g. AI response contained no scenarios or token limit reached.' },
];

export const FOP_STEPS: DiagramStep[] = [
  { id: 'fop-parse',     labelDe: 'FOP parsen',         labelEn: 'Parse FOP',       type: 'local',  status: 'pending',
    descDe: 'Der FOP-Quellcode wird geparst: Variablen, Events, Labels, Funktionen, Unterprogramm-Aufrufe (.input/.eingabe), Masken-Referenzen, Buffer-Operationen und EDP-Aufrufe werden extrahiert.',
    descEn: 'The FOP source code is parsed: variables, events, labels, functions, subprogram calls (.input/.eingabe), mask references, buffer operations and EDP calls are extracted.' },
  { id: 'fop-buffers',   labelDe: 'Buffer-Tracking',    labelEn: 'Buffer Tracking', type: 'local',  status: 'pending',
    descDe: 'Jede Zeile wird durchlaufen um zu erkennen welche Datenbank in welchem Puffer-Slot liegt (H|, D|, 0|–9|). Erkennung über .select/.load/.add, META-Direktiven und Variablentypen.',
    descEn: 'Each line is walked to detect which database is in which buffer slot (H|, D|, 0|–9|). Detection via .select/.load/.add, META directives and variable types.' },
  { id: 'fop-fields',    labelDe: 'Felder auflösen',    labelEn: 'Resolve Fields',  type: 'local',  status: 'pending',
    descDe: 'Masken-Referenzen (M|feldname) werden über Buffer-Status und Variablentabellen zu echten Datenbank-Feldern aufgelöst. Confidence: sicher / abgeleitet / unbekannt.',
    descEn: 'Mask references (M|fieldname) are resolved to real database fields via buffer state and variable tables. Confidence: certain / inferred / unknown.' },
  { id: 'fop-local-chk', labelDe: 'Lokale Prüfung',    labelEn: 'Local Check',     type: 'local',  status: 'pending',
    descDe: 'Statische Richtlinien-Prüfung ohne KI: fehlende noabbrev-Deklaration, deutsche Befehle statt englischer, Namenskonventionen, Header-Kommentare.',
    descEn: 'Static guideline check without AI: missing noabbrev declaration, German commands instead of English, naming conventions, header comments.' },
  { id: 'fop-analyst',   labelDe: 'KI-Analyse',         labelEn: 'AI Analysis',     type: 'ki',     status: 'pending', agentType: 'fop-analyst',
    descDe: 'Die KI erhält: alle Bindungen, Event-Routing, Feld-Zugriffe, Buffer-Operationen, Unterprogramm-Zusammenfassungen und den kompletten Quellcode. Sie liefert: technische Beschreibung, fachliche Beschreibung und Feld-Interaktionen.',
    descEn: 'The AI receives: all bindings, event routing, field accesses, buffer operations, subprogram summaries and the complete source code. It returns: technical description, business description and field interactions.' },
  { id: 'fop-guidelines',labelDe: 'Richtlinienprüfung', labelEn: 'Guidelines Check',type: 'ki',     status: 'pending', agentType: 'fop-guidelines',
    descDe: 'Die KI prüft den Quellcode gegen 10 abas-Programmierrichtlinien und erkennt semantische Probleme (fehlende G|success-Prüfung nach .select, Magic Strings, ungenutzte Variablen).',
    descEn: 'The AI checks the source code against 10 abas programming guidelines and detects semantic issues (missing G|success check after .select, magic strings, unused variables).' },
  { id: 'fop-save',      labelDe: 'Speichern',          labelEn: 'Save',            type: 'local',  status: 'pending',
    descDe: 'Die komplette Analyse wird im .fopanalyzer/-Ordner gecacht (inkl. Hash). Bei erneutem Aufruf wird der Cache verwendet wenn die Quelldatei unverändert ist.',
    descEn: 'The complete analysis is cached in the .fopanalyzer/ folder (incl. hash). On re-run the cache is used if the source file is unchanged.' },
];

/**
 * Deep-clone the step definitions and reset runtime fields (`items`, `branches`)
 * so each new flow starts from a clean slate without mutating the shared constants.
 */
function cloneSteps(steps: DiagramStep[]): DiagramStep[] {
  return steps.map(s => ({ ...s, items: [], branches: {} }));
}

// ── Hook ──────────────────────────────────────────────────────

/** Return type of {@link useProcessFlow}. */
export interface UseProcessFlowReturn {
  diagramFlow: DiagramFlow | null;
  expanded: boolean;
  statusText: string | null;
  toggleExpanded: () => void;
  /** Reset a step back to pending (clears items + status) */
  resetStep: (stepId: string) => void;
  /** Update the LAST item in a step (merge fields into it) */
  updateLastItem: (stepId: string, patch: Partial<DiagramItem>) => void;
  startFlow: (type: FlowType) => void;
  activateStep: (stepId: string) => void;
  completeStep: (stepId: string, items?: DiagramItem[]) => void;
  failStep: (stepId: string, items?: DiagramItem[]) => void;
  addItemsToStep: (stepId: string, items: DiagramItem[]) => void;
  resetFlow: () => void;
}

/**
 * Hook for process flow diagram state management.
 *
 * Exposes fine-grained step control (activate, complete, fail, add items) so
 * that async generation code can update individual diagram steps as they execute.
 * `statusText` is derived (not stored) from the current step state to avoid
 * synchronisation bugs.
 *
 * @returns {@link UseProcessFlowReturn}
 */
export function useProcessFlow(): UseProcessFlowReturn {
  const [diagramFlow, setDiagramFlow] = useState<DiagramFlow | null>(null);
  const [expanded, setExpanded] = useState(false);

  const toggleExpanded = useCallback(() => setExpanded(v => !v), []);

  const startFlow = useCallback((type: FlowType) => {
    if (!type) { setDiagramFlow(null); return; }
    setDiagramFlow({
      type,
      steps: type === 'cucumber' ? cloneSteps(CUCUMBER_STEPS) : cloneSteps(FOP_STEPS),
    });
    setExpanded(true); // auto-expand when flow starts
  }, []);

  const updateStep = useCallback((stepId: string, updater: (s: DiagramStep) => DiagramStep) => {
    setDiagramFlow(prev => {
      if (!prev) return prev;
      return { ...prev, steps: prev.steps.map(s => s.id === stepId ? updater(s) : s) };
    });
  }, []);

  const activateStep = useCallback((stepId: string) => {
    setDiagramFlow(prev => {
      if (!prev) return prev;
      return {
        ...prev,
        steps: prev.steps.map(s => ({
          ...s,
          // Target → active; other currently-active → pending; done stays done
          status: s.id === stepId
            ? 'active'
            : s.status === 'active' ? 'pending' : s.status,
        })),
      };
    });
  }, []);

  const completeStep = useCallback((stepId: string, items?: DiagramItem[]) => {
    updateStep(stepId, s => ({
      ...s,
      status: 'done',
      items: items ? [...(s.items ?? []), ...items] : s.items,
    }));
  }, [updateStep]);

  const failStep = useCallback((stepId: string, items?: DiagramItem[]) => {
    updateStep(stepId, s => ({
      ...s,
      status: 'error',
      items: items ? [...(s.items ?? []), ...items] : s.items,
    }));
  }, [updateStep]);

  const addItemsToStep = useCallback((stepId: string, items: DiagramItem[]) => {
    updateStep(stepId, s => ({
      ...s,
      items: [...(s.items ?? []), ...items],
    }));
  }, [updateStep]);

  const resetStep = useCallback((stepId: string) => {
    updateStep(stepId, s => ({ ...s, status: 'pending', items: [] }));
  }, [updateStep]);

  const updateLastItem = useCallback((stepId: string, patch: Partial<DiagramItem>) => {
    updateStep(stepId, s => {
      const items = s.items ?? [];
      if (items.length === 0) return s;
      const updated = [...items];
      updated[updated.length - 1] = { ...updated[updated.length - 1], ...patch };
      return { ...s, items: updated };
    });
  }, [updateStep]);

  const resetFlow = useCallback(() => {
    setDiagramFlow(null);
  }, []);

  // Derive human-readable status text from current active step
  const activeStep = diagramFlow?.steps.find(s => s.status === 'active');
  const lastDone = diagramFlow ? [...diagramFlow.steps].reverse().find(s => s.status === 'done') : null;
  const statusText: string | null = (() => {
    if (!diagramFlow) return null;
    if (activeStep) {
      const allItems = activeStep.items ?? [];
      const lastItem = allItems[allItems.length - 1];
      const itemName = lastItem?.name ? ` "${lastItem.name}"` : '';
      // Show count if multiple items accumulated
      const countHint = allItems.length > 1 ? ` (${allItems.length})` : '';
      return `${activeStep.labelDe}${itemName}${countHint} …`;
    }
    if (lastDone) {
      const workSteps = diagramFlow.steps.filter(s => s.type !== 'branch' && s.type !== 'start' && s.type !== 'end');
      const allDone = workSteps.every(s => s.status === 'done');
      if (allDone) {
        const total = workSteps.find(s => s.id === 'result-ok')?.items?.length ?? 0;
        return total > 0 ? `✓ Fertig — ${total} AP${total !== 1 ? 's' : ''} generiert` : `✓ Abgeschlossen`;
      }
      return `${lastDone.labelDe} ✓`;
    }
    return null;
  })();

  return {
    diagramFlow,
    expanded,
    statusText,
    toggleExpanded,
    startFlow,
    activateStep,
    completeStep,
    failStep,
    addItemsToStep,
    resetStep,
    updateLastItem,
    resetFlow,
  };
}
