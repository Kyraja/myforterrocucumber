/**
 * ZIP archive generation for bulk `.feature` file export.
 *
 * Collects all successfully generated work package results, writes each as a
 * `.feature` file inside a ZIP archive, and triggers a browser download.
 * Duplicate filenames (arising from features with identical names) are resolved
 * by appending an incrementing counter suffix (`_2`, `_3`, …).
 *
 * Depends on the `jszip` library for in-memory ZIP creation.
 */
import JSZip from 'jszip';
import type { WorkPackageResult } from '../types/gherkin';

/**
 * Package all completed work package results into a single ZIP file and
 * trigger a browser download.
 *
 * Only results with `status === 'done'` and non-empty `gherkin` output are
 * included. The filename for each entry is derived from the feature name (or
 * work package title as fallback), lowercased and sanitized for file system
 * compatibility.
 *
 * @param results - Array of work package results from the generation pipeline.
 * @param zipFilename - Base name for the downloaded ZIP file (without extension). Defaults to `'features'`.
 */
export async function downloadAllAsZip(
  results: WorkPackageResult[],
  zipFilename: string = 'features',
): Promise<void> {
  const zip = new JSZip();
  const usedNames = new Set<string>();

  const completed = results.filter((r) => r.status === 'done' && r.gherkin);

  for (const result of completed) {
    const name = result.feature?.name || result.workPackage.title || 'feature';
    let filename = name.toLowerCase().replace(/[^a-z0-9äöü]+/g, '_').replace(/^_|_$/g, '') + '.feature';

    // Deduplicate filenames — always register the base name first
    if (usedNames.has(filename)) {
      let counter = 2;
      let candidate = filename.replace('.feature', `_${counter}.feature`);
      while (usedNames.has(candidate)) {
        counter++;
        candidate = filename.replace('.feature', `_${counter}.feature`);
      }
      filename = candidate;
    }
    usedNames.add(filename);

    zip.file(filename, result.gherkin);
  }

  const blob = await zip.generateAsync({ type: 'blob' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `${zipFilename}.zip`;
  a.click();
  URL.revokeObjectURL(url);
}
