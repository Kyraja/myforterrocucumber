import type { FeatureInput } from '../types/gherkin';

export interface GherkinLineMapping {
  stepId?: string;
  scenarioId?: string;
}

export interface GherkinResult {
  text: string;
  lineMapping: Map<number, GherkinLineMapping>;
}

export function generateGherkinWithMapping(input: FeatureInput): GherkinResult {
  const lines: string[] = [];
  const lineMapping = new Map<number, GherkinLineMapping>();

  const tags = [...input.tags];

  if (tags.length > 0) {
    lines.push(tags.join(' '));
  }

  lines.push(`Feature: ${input.name}`);

  if (input.description.trim()) {
    for (const dl of input.description.trim().split('\n')) {
      lines.push(`  # ${dl}`);
    }
  }

  if (input.testUser.trim()) {
    lines.push('');
    lines.push('  Background:');
    lines.push(`    Given I'm logged in with password "${input.testUser.trim()}"`);
  }

  for (const scenario of input.scenarios) {
    lines.push('');
    if (scenario.comment?.trim()) {
      for (const cl of scenario.comment.trim().split('\n')) {
        lines.push(`  # ${cl}`);
      }
    }
    lineMapping.set(lines.length, { scenarioId: scenario.id });
    lines.push(`  Scenario: ${scenario.name}`);
    for (const step of scenario.steps) {
      const mapping: GherkinLineMapping = { stepId: step.id, scenarioId: scenario.id };
      lineMapping.set(lines.length, mapping);
      lines.push(`    ${step.keyword} ${step.text}`);
      if (step.dataTable && step.dataTable.length > 0) {
        const colCount = Math.max(...step.dataTable.map((row) => row.length));
        const colWidths: number[] = Array(colCount).fill(0);
        for (const row of step.dataTable) {
          for (let c = 0; c < row.length; c++) {
            colWidths[c] = Math.max(colWidths[c], row[c].length);
          }
        }
        for (const row of step.dataTable) {
          const cells = row.map((cell, c) => ` ${cell.padEnd(colWidths[c])} `);
          lineMapping.set(lines.length, mapping);
          lines.push(`      |${cells.join('|')}|`);
        }
      }
    }
  }

  return { text: lines.join('\n') + '\n', lineMapping };
}

export function generateGherkin(input: FeatureInput): string {
  return generateGherkinWithMapping(input).text;
}
