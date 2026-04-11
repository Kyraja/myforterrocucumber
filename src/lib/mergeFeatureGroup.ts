/**
 * Merges parsed feature groups from a document import.
 *
 * When a consultant marks a table-of-contents heading as a "Feature Group",
 * all descendant work packages are combined into a single `.feature` file
 * rather than generating one file per package. This module implements that
 * merge, producing a single {@link ParsedFeaturePackage} whose scenarios are
 * the union of all children's scenarios, prefixed with the child heading for
 * traceability.
 */
import type { FeatureInput, ParsedFeaturePackage, Scenario } from '../types/gherkin';
import { validateFeature } from './featureValidation';

/**
 * Merge multiple {@link ParsedFeaturePackage} instances into a single package.
 *
 * Each child package contributes its scenarios to the merged feature. If a
 * child has only one unnamed scenario the child's `sourceHeading` is used as
 * the scenario name directly; otherwise the heading is prepended as a prefix.
 * Children without any scenarios yet (pre-AI generation) receive a placeholder
 * scenario so they are not silently lost.
 *
 * Tags from all children are union-merged (deduplicated). The `database` and
 * `testUser` fields are taken from the first child.
 *
 * @param groupHeading - The heading text that acts as the merged Feature name.
 * @param childPackages - The descendant packages to merge; order is preserved.
 * @returns A single {@link ParsedFeaturePackage} with all child scenarios combined.
 */
export function mergeFeatureGroup(
  groupHeading: string,
  childPackages: ParsedFeaturePackage[],
): ParsedFeaturePackage {
  if (childPackages.length === 0) {
    const emptyFeature: FeatureInput = {
      name: groupHeading,
      description: '',
      tags: [],
      database: null,
      testUser: '',
      scenarios: [],
    };
    return {
      feature: emptyFeature,
      sourceHeading: groupHeading,
      sourceText: '',
      validation: validateFeature(emptyFeature),
      headingLevel: 1,
    };
  }

  // Collect all scenarios from children, prefixed with child heading
  const mergedScenarios: Scenario[] = [];
  for (const pkg of childPackages) {
    for (const scenario of pkg.feature.scenarios) {
      mergedScenarios.push({
        ...scenario,
        id: crypto.randomUUID(),
        name: pkg.feature.scenarios.length === 1 && !scenario.name
          ? pkg.sourceHeading
          : `${pkg.sourceHeading} - ${scenario.name}`,
      });
    }
    // If child has no scenarios yet (pre-AI), add a placeholder
    if (pkg.feature.scenarios.length === 0) {
      mergedScenarios.push({
        id: crypto.randomUUID(),
        name: pkg.sourceHeading,
        steps: [],
      });
    }
  }

  // Merge tags (union, deduplicated)
  const allTags = new Set<string>();
  for (const pkg of childPackages) {
    for (const tag of pkg.feature.tags) allTags.add(tag);
  }

  // Use first child's database/testUser as default
  const first = childPackages[0];

  const mergedFeature: FeatureInput = {
    name: groupHeading,
    description: childPackages.map((p) => p.feature.description || p.sourceText).filter(Boolean).join('\n\n'),
    tags: [...allTags],
    database: first.feature.database,
    testUser: first.feature.testUser,
    scenarios: mergedScenarios,
  };

  // Concatenate all source texts for AI generation
  const mergedSourceText = childPackages
    .map((p) => `### ${p.sourceHeading}\n${p.sourceText}`)
    .join('\n\n');

  return {
    feature: mergedFeature,
    sourceHeading: groupHeading,
    sourceText: mergedSourceText,
    validation: validateFeature(mergedFeature),
    headingLevel: first.headingLevel,
    kundeField: first.kundeField,
  };
}
