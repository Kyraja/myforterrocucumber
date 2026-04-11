/**
 * Browser clipboard API wrapper.
 *
 * Provides a safe, promise-based interface for writing text to the system
 * clipboard. Returns a boolean instead of throwing so callers can show
 * appropriate UI feedback without needing try/catch at every call site.
 */

/**
 * Copy a string to the system clipboard using the async Clipboard API.
 *
 * Returns `false` silently if the API is unavailable (e.g. non-HTTPS context)
 * or if the user denies the clipboard-write permission.
 *
 * @param text - The text to place on the clipboard.
 * @returns `true` if the write succeeded, `false` otherwise.
 */
export async function copyToClipboard(text: string): Promise<boolean> {
  try {
    await navigator.clipboard.writeText(text);
    return true;
  } catch {
    return false;
  }
}
