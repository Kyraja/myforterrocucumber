import type { FeatureInput, ValidationIssue } from '../types/gherkin';

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
