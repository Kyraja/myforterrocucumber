export function downloadFeatureFile(content: string, filename: string): void {
  const blob = new Blob([content], { type: 'text/plain;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename.endsWith('.feature') ? filename : `${filename}.feature`;
  a.click();
  URL.revokeObjectURL(url);
}
