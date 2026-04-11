/**
 * File download utility for individual `.feature` files.
 *
 * Triggers a browser download by creating a temporary object URL from a Blob
 * and clicking a synthetic anchor element. The URL is immediately revoked after
 * the click to avoid memory leaks — the browser has already queued the download
 * at that point.
 */

/**
 * Prompt the browser to download a Gherkin feature file.
 *
 * Automatically appends `.feature` to `filename` if it is not already present.
 * For bulk downloads of multiple features, use {@link downloadAllAsZip} from
 * `zipDownload.ts` instead.
 *
 * @param content - The Gherkin text content to write into the file.
 * @param filename - The desired download filename (with or without `.feature` extension).
 */
export function downloadFeatureFile(content: string, filename: string): void {
  const blob = new Blob([content], { type: 'text/plain;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename.endsWith('.feature') ? filename : `${filename}.feature`;
  a.click();
  URL.revokeObjectURL(url);
}
