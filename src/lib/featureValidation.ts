/**
 * Validates a {@link FeatureInput} for completeness and structural correctness.
 *
 * Produces a list of {@link ValidationIssue} entries at three severity levels:
 *  - `error`   — the feature cannot be imported (e.g. missing name, no scenarios).
 *  - `warning` — importable but likely incorrect (e.g. no Given/Then step).
 *  - `info`    — advisory only (e.g. unstructured freetext steps remain).
 *
 * Also provides per-step and per-scenario error checks used by the editor UI
 * to highlight individual rows with missing required fields.
 */
import type { FeatureInput, Step, Scenario, ValidationIssue } from '../types/gherkin';

/**
 * Validates a FeatureInput and returns a list of issues
 * (errors, warnings, info) for import feedback.
 */
export function validateFeature(feature: FeatureInput): ValidationIssue[] {
  const issues: ValidationIssue[] = [];

  // ── Feature-level checks ───────────────────────────────────

  if (!feature.name.trim()) {
    issues.push({ level: 'error', message: 'Kein Feature-Name angegeben' });
  }

  if (feature.scenarios.length === 0) {
    issues.push({ level: 'error', message: 'Keine Szenarien erkannt' });
  }

  // ── Scenario-level checks ──────────────────────────────────

  for (const scenario of feature.scenarios) {
    const label = scenario.name || '(unbenannt)';

    if (scenario.steps.length === 0) {
      issues.push({ level: 'error', message: `Szenario '${label}' hat keine Schritte` });
      continue;
    }

    const hasGiven = scenario.steps.some((s) => s.keyword === 'Given');
    if (!hasGiven) {
      issues.push({ level: 'warning', message: `'${label}': Kein Einstiegspunkt (Vorbedingung)` });
    }

    const hasThen = scenario.steps.some((s) => s.keyword === 'Then');
    if (!hasThen) {
      issues.push({ level: 'warning', message: `'${label}': Keine Pruefung (Ergebnis)` });
    }

    const freetextCount = scenario.steps.filter((s) => s.action.type === 'freetext').length;
    if (freetextCount > 0) {
      issues.push({
        level: 'info',
        message: `'${label}': ${freetextCount} unstrukturierte${freetextCount === 1 ? 'r' : ''} Freitext-Schritt${freetextCount === 1 ? '' : 'e'}`,
      });
    }
  }

  return issues;
}

/**
 * Returns true if the feature has any errors (not just warnings/info).
 */
export function hasErrors(issues: ValidationIssue[]): boolean {
  return issues.some((i) => i.level === 'error');
}

/**
 * Returns true if the feature has warnings (but may still be importable).
 */
export function hasWarnings(issues: ValidationIssue[]): boolean {
  return issues.some((i) => i.level === 'warning');
}

/**
 * Check whether a step has any missing required fields for its action type.
 *
 * Used by the editor UI to show inline error indicators on individual step rows.
 * Each action type defines its own required fields — e.g. `editorOeffnen` needs
 * both `editorName` and `tableRef`, while `buttonDruecken` only needs `buttonName`.
 *
 * @param step - The step to validate.
 * @returns `true` if any required field for the step's action type is empty.
 */
export function stepHasError(step: Step): boolean {
  const a = step.action;
  switch (a.type) {
    case 'editorOeffnen':
    case 'editorOeffnenSuche':
    case 'editorOeffnenMenue':
      return !a.editorName.trim() || !a.tableRef.trim();
    case 'feldSetzen':
      if (a.multi) return !step.dataTable || step.dataTable.length === 0;
      return !a.fieldName.trim() || !a.value.trim();
    case 'feldPruefen':
      if (step.dataTable && step.dataTable.length > 0) return false;
      return !a.fieldName.trim() || !a.expectedValue.trim();
    case 'feldLeer':
    case 'feldAenderbar':
      return !a.fieldName.trim();
    case 'editorWechseln':
      return !a.editorName.trim();
    case 'buttonDruecken':
      return !a.buttonName.trim();
    case 'subeditorOeffnen':
      return !a.buttonName.trim() || !a.subeditorName.trim();
    case 'infosystemOeffnen':
      return !a.infosystemName.trim();
    case 'tabelleZeilen':
      return !a.rowCount.trim();
    case 'exceptionSpeichern':
      return !a.exceptionId.trim();
    case 'exceptionFeld':
      return !a.fieldName.trim() || !a.exceptionId.trim();
    case 'dialogBeantworten':
      return !a.dialogId.trim() || !a.answer.trim();
    case 'boxMeldung':
      return !a.messageText.trim();
    case 'editorOeffnenTipp':
      return !a.tipCommand.trim();
    default:
      return false;
  }
}

/** Check if a scenario has any steps with validation errors. */
export function scenarioHasErrors(scenario: Scenario): boolean {
  return scenario.steps.some(stepHasError);
}

/** Check if a feature has any scenario with validation errors. */
export function featureHasStepErrors(feature: FeatureInput): boolean {
  return feature.scenarios.some(scenarioHasErrors);
}
