import JSZip from 'jszip';
import type { WorkPackageResult } from '../types/gherkin';

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

    // Deduplicate filenames
    if (usedNames.has(filename)) {
      let counter = 2;
      while (usedNames.has(filename.replace('.feature', `_${counter}.feature`))) {
        counter++;
      }
      filename = filename.replace('.feature', `_${counter}.feature`);
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
