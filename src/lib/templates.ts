/**
 * @module templates
 *
 * Scenario and step building block templates for the Gherkin editor.
 *
 * Two collections are exported:
 *
 * - {@link STEP_BUILDING_BLOCKS} — small reusable step groups (1-3 steps)
 *   shown in the step toolbox. Designed to be appended to an existing scenario.
 *
 * - {@link BUILTIN_TEMPLATES} — complete scenario templates (full Given/When/Then
 *   structure) shown as one-click starting points in the FeatureForm.
 *
 * Custom templates created by the consultant are persisted in localStorage
 * and merged into the above lists at runtime via {@link loadCustomTemplates}.
 *
 * Templates use empty-string placeholders for all user-specific values
 * (field names, record ids, etc.) so they can be used as blank forms.
 */

import type { Scenario, Step, StepKeyword, StepAction } from '../types/gherkin';
import { stepTextFromAction } from './actionText';

interface TemplateStep {
  keyword: StepKeyword;
  action: StepAction;
}

export interface ScenarioTemplate {
  id: string;
  label: string;
  /** English label (optional — falls back to label if not set) */
  labelEn?: string;
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
    label: 'Editor öffnen & Suchwort', labelEn: 'Open editor & search word',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'STORE', record: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: 'such', value: '', row: '' } },
    ],
  },
  {
    id: 'block_feld_setzen_pruefen',
    label: 'Feld setzen & prüfen', labelEn: 'Set & check field',
    steps: [
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: '', value: '', row: '' } },
      { keyword: 'Then', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  {
    id: 'block_felder_pruefen',
    label: 'Felder prüfen (mehrere)', labelEn: 'Check fields (multiple)',
    steps: [
      { keyword: 'Then', action: { type: 'feldAenderbar', fieldName: '', modifiable: true, row: '' } },
      { keyword: 'And', action: { type: 'feldLeer', fieldName: '', isEmpty: false, row: '' } },
      { keyword: 'And', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  {
    id: 'block_speichern_schliessen',
    label: 'Speichern & schließen', labelEn: 'Save & close',
    steps: [
      { keyword: 'When', action: { type: 'editorSpeichern' } },
      { keyword: 'And', action: { type: 'editorSchliessen' } },
    ],
  },
  {
    id: 'block_speichern_pruefen',
    label: 'Speichern & prüfen', labelEn: 'Save & check',
    steps: [
      { keyword: 'When', action: { type: 'editorSpeichern' } },
      { keyword: 'Then', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  {
    id: 'block_zeile_felder',
    label: 'Zeile anlegen & Felder setzen', labelEn: 'Create row & set fields',
    steps: [
      { keyword: 'And', action: { type: 'zeileAnlegen' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: '', value: '', row: '1' } },
    ],
  },
  {
    id: 'block_button_subeditor',
    label: 'Button & Subeditor', labelEn: 'Button & subeditor',
    steps: [
      { keyword: 'When', action: { type: 'buttonDruecken', buttonName: '', row: '' } },
      { keyword: 'And', action: { type: 'subeditorOeffnen', buttonName: '', subeditorName: '', row: '' } },
    ],
  },
  {
    id: 'block_speicher_exception',
    label: 'Speicher-Validierung', labelEn: 'Save validation',
    steps: [
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: '', value: '', row: '' } },
      { keyword: 'Then', action: { type: 'exceptionSpeichern', exceptionId: '' } },
    ],
  },
  {
    id: 'block_feld_exception',
    label: 'Feld-Validierung', labelEn: 'Field validation',
    steps: [
      { keyword: 'Then', action: { type: 'exceptionFeld', fieldName: '', value: '', exceptionId: '' } },
    ],
  },
  {
    id: 'block_dialog',
    label: 'Button & Dialog', labelEn: 'Button & dialog',
    steps: [
      { keyword: 'When', action: { type: 'buttonDruecken', buttonName: '', row: '' } },
      { keyword: 'And', action: { type: 'dialogBeantworten', dialogId: '', answer: '' } },
    ],
  },
  {
    id: 'block_infosystem',
    label: 'Infosystem prüfen', labelEn: 'Check infosystem',
    steps: [
      { keyword: 'Given', action: { type: 'infosystemOeffnen', infosystemName: '', infosystemRef: '' } },
      { keyword: 'Then', action: { type: 'tabelleZeilen', rowCount: '' } },
      { keyword: 'And', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '1' } },
    ],
  },
  {
    id: 'block_editor_wechseln',
    label: 'Editor wechseln & prüfen', labelEn: 'Switch editor & check',
    steps: [
      { keyword: 'And', action: { type: 'editorWechseln', editorName: '' } },
      { keyword: 'Then', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' } },
    ],
  },
  {
    id: 'block_editor_suche',
    label: 'Editor öffnen (Suche)', labelEn: 'Open editor (search)',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnenSuche', editorName: '', tableRef: '', command: 'UPDATE', searchCriteria: '' } },
    ],
  },
  {
    id: 'block_editor_menue',
    label: 'Editor öffnen (Menü)', labelEn: 'Open editor (menu)',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnenMenue', editorName: '', tableRef: '', command: 'NEW', record: '', menuChoice: '' } },
    ],
  },
  {
    id: 'block_zeilen_anfuegen',
    label: 'Zeilen anfügen (Tabelle)', labelEn: 'Append rows (table)',
    steps: [
      { keyword: 'And', action: { type: 'zeilenAnfuegen', columns: '', rows: '' } },
    ],
  },
  {
    id: 'block_freetext',
    label: 'Freitext-Step', labelEn: 'Freetext step',
    steps: [
      { keyword: 'And', action: { type: 'freetext' } },
    ],
  },
];

// ── Built-in scenario templates (full scenarios for FeatureForm) ──

export const BUILTIN_TEMPLATES: ScenarioTemplate[] = [
  // 1. Feldpruefung — neues Feld pruefen (modifiable, leer/nicht leer)
  {
    id: 'feld_pruefen',
    label: 'Feld pruefen', labelEn: 'Check field',
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
    label: 'Datensatz anlegen', labelEn: 'Create record',
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
    label: 'Neues Feld testen', labelEn: 'Test new field',
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
    label: 'Datensatz aendern', labelEn: 'Edit record',
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
    label: 'Validierung (Speichern)', labelEn: 'Validation (save)',
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
    label: 'Validierung (Feld)', labelEn: 'Validation (field)',
    steps: [
      { keyword: 'Given', action: { type: 'editorOeffnen', editorName: '', tableRef: '', command: 'NEW', record: '' } },
      { keyword: 'And', action: { type: 'feldSetzen', fieldName: 'such', value: '', row: '' } },
      { keyword: 'Then', action: { type: 'exceptionFeld', fieldName: '', value: '', exceptionId: '' } },
    ],
  },
  // 7. Tabellenzeilen — Zeilen anlegen und Felder in Zeilen setzen
  {
    id: 'tabellenzeilen',
    label: 'Tabellenzeilen bearbeiten', labelEn: 'Edit table rows',
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
    label: 'Infosystem pruefen', labelEn: 'Check infosystem',
    steps: [
      { keyword: 'Given', action: { type: 'infosystemOeffnen', infosystemName: '', infosystemRef: '' } },
      { keyword: 'Then', action: { type: 'tabelleZeilen', rowCount: '' } },
      { keyword: 'And', action: { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '1' } },
    ],
  },
  {
    id: 'prozess',
    label: 'Prozess (Ende-zu-Ende)', labelEn: 'Process (end-to-end)',
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

/**
 * Instantiates a new {@link Scenario} from a template by generating fresh
 * UUIDs for the scenario and all of its steps.
 *
 * @param template - The source template to instantiate
 * @returns A new Scenario with unique ids and an empty name, ready for editing
 */
export function createScenarioFromTemplate(template: ScenarioTemplate): Scenario {
  return {
    id: crypto.randomUUID(),
    name: '',
    steps: template.steps.map((ts) => buildStep(ts.keyword, ts.action)),
  };
}

// ── Custom template persistence ───────────────────────────────

const CUSTOM_TEMPLATES_KEY = 'cucumbergnerator_custom_templates';

/**
 * Loads user-created templates from localStorage.
 * Each loaded template is tagged with `custom: true` for UI differentiation.
 *
 * @returns Array of custom templates, or empty array if none exist or JSON is invalid
 */
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

/**
 * Converts a Scenario into a custom template and appends it to localStorage.
 *
 * Actions are deep-cloned so future edits to the source scenario do not
 * affect the saved template.
 *
 * @param scenario - The scenario to save as a template
 * @returns The newly created template object (with the generated id and label)
 */
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

/**
 * Triggers a browser download of all custom templates as a JSON file.
 * Does nothing if no custom templates exist.
 */
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

/**
 * Imports templates from a JSON string (previously exported by {@link exportCustomTemplates}).
 *
 * Templates with id collisions against already-stored templates receive a new
 * random id to prevent overwriting existing consultant work.
 *
 * @param json - Raw JSON string containing an array of ScenarioTemplate objects
 * @returns The number of successfully imported templates; 0 on parse error or no valid entries
 */
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
