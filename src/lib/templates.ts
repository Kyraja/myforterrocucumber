import type { Scenario, Step, StepKeyword, StepAction } from '../types/gherkin';
import { stepTextFromAction } from './actionText';

interface TemplateStep {
  keyword: StepKeyword;
  action: StepAction;
}

export interface ScenarioTemplate {
  id: string;
  label: string;
  steps: TemplateStep[];
  custom?: boolean;
}

function buildStep(keyword: StepKeyword, action: StepAction): Step {
  const result = stepTextFromAction(action);
  return {
    id: crypto.randomUUID(),
    keyword,
    text: result.text,
    action,
  };
}

// ── Step building blocks for the toolbox (small step groups, no boilerplate) ──

export const STEP_BUILDING_BLOCKS: ScenarioTemplate[] = [
  {
    id: 'block_editor_oeffnen',
    label: 'Editor öffnen & Suchwort',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'STORE', record: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: 'such', value: '', row: '' } },
    ],
  },
  {
    id: 'block_feld_setzen_pruefen',
    label: 'Feld setzen & prüfen',
    steps: [
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: '', value: '', row: '' } },
      { keyword: 'Then', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  {
    id: 'block_felder_pruefen',
    label: 'Felder prüfen (mehrere)',
    steps: [
      { keyword: 'Then', action: { type: 'feldAenderbar', fieldName: '', modifiable: true, row: '' } },
      { keyword: 'And', action: { type: 'feldLeer', fieldName: '', isEmpty: false, row: '' } },
      { keyword: 'And', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  {
    id: 'block_speichern_schliessen',
    label: 'Speichern & schließen',
    steps: [
      { keyword: 'When', action: { type: 'editorSpeichern' } },
      { keyword: 'And', action: { type: 'editorSchliessen' } },
    ],
  },
  {
    id: 'block_speichern_pruefen',
    label: 'Speichern & prüfen',
    steps: [
      { keyword: 'When', action: { type: 'editorSpeichern' } },
      { keyword: 'Then', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  {
    id: 'block_zeile_felder',
    label: 'Zeile anlegen & Felder setzen',
    steps: [
      { keyword: 'And', action: { type: 'zeileAnlegen' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: '', value: '', row: '1' } },
    ],
  },
  {
    id: 'block_button_subeditor',
    label: 'Button & Subeditor',
    steps: [
      { keyword: 'When', action: { type: 'buttonDruecken', buttonName: '', row: '' } },
      { keyword: 'And', action: { type: 'subeditorOeffnen', buttonName: '', subeditorName: '', row: '' } },
    ],
  },
  {
    id: 'block_speicher_exception',
    label: 'Speicher-Validierung',
    steps: [
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: '', value: '', row: '' } },
      { keyword: 'Then', action: { type: 'exceptionSpeichern', exceptionId: '' } },
    ],
  },
  {
    id: 'block_feld_exception',
    label: 'Feld-Validierung',
    steps: [
      { keyword: 'Then', action: { type: 'exceptionFeld', fieldName: '', value: '', exceptionId: '' } },
    ],
  },
  {
    id: 'block_dialog',
    label: 'Button & Dialog',
    steps: [
      { keyword: 'When', action: { type: 'buttonDruecken', buttonName: '', row: '' } },
      { keyword: 'And', action: { type: 'dialogBeantworten', dialogId: '', answer: '' } },
    ],
  },
  {
    id: 'block_infosystem',
    label: 'Infosystem prüfen',
    steps: [
      { keyword: 'Given', action: { type: 'infosystemOeffnen', infosystemName: '', infosystemRef: '' } },
      { keyword: 'Then', action: { type: 'tabelleZeilen', rowCount: '' } },
      { keyword: 'And', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '1' } },
    ],
  },
  {
    id: 'block_editor_wechseln',
    label: 'Editor wechseln & prüfen',
    steps: [
      { keyword: 'And', action: { type: 'editorWechseln', editorName: '' } },
      { keyword: 'Then', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
];

// ── Built-in scenario templates (full scenarios for FeatureForm) ──

export const BUILTIN_TEMPLATES: ScenarioTemplate[] = [
  // 1. Feldpruefung — neues Feld pruefen (modifiable, leer/nicht leer)
  {
    id: 'feld_pruefen',
    label: 'Feld pruefen',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'VIEW', record: '' } },
      { keyword: 'Then', action: { type: 'feldAenderbar', fieldName: '', modifiable: true, row: '' } },
      { keyword: 'And', action: { type: 'feldLeer', fieldName: '', isEmpty: false, row: '' } },
      { keyword: 'And', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  // 2. Neuanlage — neuen Datensatz mit STORE anlegen
  {
    id: 'datensatz_anlegen',
    label: 'Datensatz anlegen',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'STORE', record: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: 'such', value: '', row: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: '', value: '', row: '' } },
      { keyword: 'When', action: { type: 'editorSpeichern' } },
      { keyword: 'Then', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  // 3. Neues Feld testen — Feld anlegen, setzen, speichern, pruefen
  {
    id: 'neues_feld',
    label: 'Neues Feld testen',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'NEW', record: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: 'such', value: '', row: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: '', value: '', row: '' } },
      { keyword: 'When', action: { type: 'editorSpeichern' } },
      { keyword: 'Then', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  // 4. Datensatz aendern — bestehenden Datensatz per UPDATE bearbeiten
  {
    id: 'datensatz_aendern',
    label: 'Datensatz aendern',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'UPDATE', record: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: '', value: '', row: '' } },
      { keyword: 'When', action: { type: 'editorSpeichern' } },
      { keyword: 'Then', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  // 5. Validierung / Exception beim Speichern
  {
    id: 'validierung_speichern',
    label: 'Validierung (Speichern)',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'NEW', record: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: 'such', value: '', row: '' } },
      { keyword: 'When', action: { type: 'feldSetzen', fieldName: '', value: '', row: '' } },
      { keyword: 'Then', action: { type: 'exceptionSpeichern', exceptionId: '' } },
    ],
  },
  // 6. Validierung / Exception bei Feldwert
  {
    id: 'validierung_feld',
    label: 'Validierung (Feld)',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'NEW', record: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: 'such', value: '', row: '' } },
      { keyword: 'Then', action: { type: 'exceptionFeld', fieldName: '', value: '', exceptionId: '' } },
    ],
  },
  // 7. Tabellenzeilen — Zeilen anlegen und Felder in Zeilen setzen
  {
    id: 'tabellenzeilen',
    label: 'Tabellenzeilen bearbeiten',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'NEW', record: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: 'such', value: '', row: '' } },
      { keyword: 'And', action: { type: 'zeileAnlegen' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: '', value: '', row: '1' } },
      { keyword: 'When', action: { type: 'editorSpeichern' } },
      { keyword: 'Then', action: { type: 'tabelleZeilen', rowCount: '' } },
    ],
  },
  // 8. Infosystem pruefen
  {
    id: 'infosystem',
    label: 'Infosystem pruefen',
    steps: [
      { keyword: 'Given', action: { type: 'infosystemOeffnen', infosystemName: '', infosystemRef: '' } },
      { keyword: 'Then', action: { type: 'tabelleZeilen', rowCount: '' } },
      { keyword: 'And', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '1' } },
    ],
  },
  // 9. Prozess — Datensatz anlegen und in anderem Editor verwenden
  {
    id: 'prozess',
    label: 'Prozess (Ende-zu-Ende)',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'STORE', record: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: 'such', value: '', row: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: '', value: '', row: '' } },
      { keyword: 'And', action: { type: 'editorSpeichern' } },
      { keyword: 'And', action: { type: 'editorSchliessen' } },
      { keyword: 'When', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'NEW', record: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: '', value: '', row: '' } },
      { keyword: 'And', action: { type: 'editorSpeichern' } },
      { keyword: 'Then', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  // 10. Button / Subeditor — Button druecken und Subeditor oeffnen
  {
    id: 'button_subeditor',
    label: 'Button / Subeditor',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'UPDATE', record: '' } },
      { keyword: 'When', action: { type: 'buttonDruecken', buttonName: '', row: '' } },
      { keyword: 'And', action: { type: 'subeditorOeffnen', buttonName: '', subeditorName: '', row: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: '', value: '', row: '' } },
      { keyword: 'And', action: { type: 'editorSpeichern' } },
      { keyword: 'Then', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  // 11. Dialog beantworten
  {
    id: 'dialog',
    label: 'Dialog beantworten',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'UPDATE', record: '' } },
      { keyword: 'When', action: { type: 'buttonDruecken', buttonName: '', row: '' } },
      { keyword: 'And', action: { type: 'dialogBeantworten', dialogId: '', answer: '' } },
      { keyword: 'Then', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  // 12. Datensatz per Suche oeffnen
  {
    id: 'suche_oeffnen',
    label: 'Datensatz suchen',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnenSuche', editorName: '', tableRef: '', command: 'VIEW', searchCriteria: '' } },
      { keyword: 'Then', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
];

export function createScenarioFromTemplate(template: ScenarioTemplate): Scenario {
  return {
    id: crypto.randomUUID(),
    name: '',
    steps: template.steps.map((ts) => buildStep(ts.keyword, ts.action)),
  };
}

// ── Custom template persistence ───────────────────────────────

const CUSTOM_TEMPLATES_KEY = 'cucumbergnerator_custom_templates';

export function loadCustomTemplates(): ScenarioTemplate[] {
  const json = localStorage.getItem(CUSTOM_TEMPLATES_KEY);
  if (!json) return [];
  try {
    const data = JSON.parse(json);
    return Array.isArray(data) ? data.map((t: ScenarioTemplate) => ({ ...t, custom: true })) : [];
  } catch {
    return [];
  }
}

export function saveCustomTemplate(scenario: Scenario): ScenarioTemplate {
  const existing = loadCustomTemplates();
  const template: ScenarioTemplate = {
    id: 'custom_' + crypto.randomUUID().slice(0, 8),
    label: scenario.name || 'Eigene Vorlage',
    custom: true,
    steps: scenario.steps.map((s) => ({
      keyword: s.keyword,
      action: JSON.parse(JSON.stringify(s.action)),
    })),
  };
  existing.push(template);
  localStorage.setItem(CUSTOM_TEMPLATES_KEY, JSON.stringify(existing));
  return template;
}

export function removeCustomTemplate(id: string): void {
  const existing = loadCustomTemplates();
  const filtered = existing.filter((t) => t.id !== id);
  localStorage.setItem(CUSTOM_TEMPLATES_KEY, JSON.stringify(filtered));
}

/** All templates: building blocks + built-in scenarios + custom (used for drop lookup) */
export function getAllTemplates(): ScenarioTemplate[] {
  return [...STEP_BUILDING_BLOCKS, ...BUILTIN_TEMPLATES, ...loadCustomTemplates()];
}

/** Scenario templates only: built-in + custom (used for FeatureForm template pills) */
export function getScenarioTemplates(): ScenarioTemplate[] {
  return [...BUILTIN_TEMPLATES, ...loadCustomTemplates()];
}

// ── Export / Import ───────────────────────────────────────────

export function exportCustomTemplates(): void {
  const templates = loadCustomTemplates();
  if (templates.length === 0) return;
  const json = JSON.stringify(templates, null, 2);
  const blob = new Blob([json], { type: 'application/json;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'cucumbergnerator-vorlagen.json';
  a.click();
  URL.revokeObjectURL(url);
}

export function importCustomTemplates(json: string): number {
  let imported: ScenarioTemplate[];
  try {
    const data = JSON.parse(json);
    const arr = Array.isArray(data) ? data : [];
    imported = arr.filter(
      (t: Record<string, unknown>) => t && typeof t.label === 'string' && Array.isArray(t.steps),
    );
  } catch {
    return 0;
  }
  if (imported.length === 0) return 0;

  const existing = loadCustomTemplates();
  const existingIds = new Set(existing.map((t) => t.id));

  for (const t of imported) {
    // Assign new ID if collision with existing
    if (existingIds.has(t.id)) {
      t.id = 'custom_' + crypto.randomUUID().slice(0, 8);
    }
    t.custom = true;
    existing.push(t);
    existingIds.add(t.id);
  }

  localStorage.setItem(CUSTOM_TEMPLATES_KEY, JSON.stringify(existing));
  return imported.length;
}
