/**
 * Core Gherkin text generator.
 *
 * Converts a structured {@link FeatureInput} into a valid `.feature` file string
 * according to the Gherkin spec (Feature at col 0, Scenario indented 2 spaces,
 * steps indented 4 spaces). Also produces a line-number-to-element mapping used
 * by the preview pane to highlight the step/scenario that corresponds to a
 * clicked line.
 */
import type { FeatureInput } from '../types/gherkin';

/**
 * Maps a zero-based output line number to the step and/or scenario it originated from.
 * Used by the preview pane to support click-to-focus navigation.
 */
export interface GherkinLineMapping {
  stepId?: string;
  scenarioId?: string;
}

/**
 * Return value of {@link generateGherkinWithMapping}, bundling the rendered
 * Gherkin text with a map from line index to source element identifiers.
 */
export interface GherkinResult {
  text: string;
  lineMapping: Map<number, GherkinLineMapping>;
}

/**
 * Render a {@link FeatureInput} to Gherkin text and produce a line mapping.
 *
 * The line mapping allows the UI to correlate each output line back to the
 * scenario or step that produced it, enabling click-to-focus in the preview.
 *
 * @param input - The structured feature definition to render.
 * @returns The rendered Gherkin string and a map of line numbers to step/scenario IDs.
 */
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

      // "I set fields in row X" does not exist as an abas step — expand into individual
      // "I set field ... in row X" steps so the generated Gherkin is valid.
      const setFieldsInRowMatch = step.text.match(/^I set fields in row (\S+)$/);
      if (setFieldsInRowMatch && step.dataTable && step.dataTable.length > 0) {
        const row = setFieldsInRowMatch[1];
        for (const dtRow of step.dataTable) {
          if (dtRow.length >= 2) {
            lineMapping.set(lines.length, mapping);
            lines.push(`    ${step.keyword} I set field "${dtRow[0]}" to "${dtRow[1]}" in row ${row}`);
          }
        }
        continue;
      }

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

/**
 * Render a {@link FeatureInput} to a Gherkin `.feature` file string.
 *
 * Convenience wrapper around {@link generateGherkinWithMapping} for callers
 * that only need the text and not the line mapping.
 *
 * @param input - The structured feature definition to render.
 * @returns The complete Gherkin text, ending with a newline.
 */
export function generateGherkin(input: FeatureInput): string {
  return generateGherkinWithMapping(input).text;
}
