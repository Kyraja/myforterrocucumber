/**
 * File-system cache for FOP analysis results.
 *
 * Analysis is expensive (AI API call per FOP), so results are persisted to the
 * user's local file system via the File System Access API.  The cache lives in
 * a `.fopanalyzer/` directory next to the user's FOP workspace folder.
 *
 * Cache invalidation is hash-based: each entry stores the SHA-256 hash of the
 * source file; a stale entry is detected by comparing the stored hash to the
 * current file hash before reading.
 *
 * Layout:
 * ```
 * .fopanalyzer/
 *   manifest.json            ← index of all cached entries
 *   cache/<relativePath>.json ← individual FopAnalysis JSON files
 * ```
 *
 * Output directories (`Konzept/`, `Konzept/Tests/`) are also created by helpers
 * in this module so that generated documentation and `.feature` files have a
 * consistent location.
 */
import type { CacheManifest, FopAnalysis } from '../types/fop';

const CACHE_DIR = '.fopanalyzer';
const CACHE_SUBDIR = 'cache';
const MANIFEST_FILE = 'manifest.json';
const MANIFEST_VERSION = '1.0';

/**
 * Manages the `.fopanalyzer/` cache directory for a given workspace root.
 *
 * Must be initialized with {@link FopCache.init} before any read/write
 * operations — `init()` creates the directory if absent and loads the manifest.
 */
export class FopCache {
  private rootDir: FileSystemDirectoryHandle;
  private cacheDir: FileSystemDirectoryHandle | null = null;
  private manifest: CacheManifest = { version: MANIFEST_VERSION, entries: {} };

  constructor(rootDir: FileSystemDirectoryHandle) {
    this.rootDir = rootDir;
  }

  /**
   * Create (or open) the cache directory and load the manifest.
   * Must be awaited before calling any other method.
   */
  async init(): Promise<void> {
    this.cacheDir = await this.rootDir.getDirectoryHandle(CACHE_DIR, { create: true });
    await this.loadManifest();
  }

  private async loadManifest(): Promise<void> {
    if (!this.cacheDir) return;
    try {
      const fileHandle = await this.cacheDir.getFileHandle(MANIFEST_FILE);
      const file = await fileHandle.getFile();
      const text = await file.text();
      this.manifest = JSON.parse(text);
    } catch {
      this.manifest = { version: MANIFEST_VERSION, entries: {} };
    }
  }

  private async saveManifest(): Promise<void> {
    if (!this.cacheDir) return;
    const fileHandle = await this.cacheDir.getFileHandle(MANIFEST_FILE, { create: true });
    const writable = await fileHandle.createWritable();
    await writable.write(JSON.stringify(this.manifest, null, 2));
    await writable.close();
  }

  /** Check if a valid cache entry exists for a FOP */
  async isCached(relativePath: string, fileHash: string, lang: 'de' | 'en'): Promise<boolean> {
    const key = `${relativePath}__${lang}`;
    const entry = this.manifest.entries[key];
    return !!(entry && entry.fileHash === fileHash);
  }

  /** Read cached analysis for a FOP */
  async readCache(relativePath: string, lang: 'de' | 'en'): Promise<FopAnalysis | null> {
    if (!this.cacheDir) return null;
    const key = `${relativePath}__${lang}`;
    const entry = this.manifest.entries[key];
    if (!entry) return null;

    try {
      const parts = entry.cacheFile.split('/');
      let dir = this.cacheDir;
      for (const part of parts.slice(0, -1)) {
        dir = await dir.getDirectoryHandle(part);
      }
      const fileHandle = await dir.getFileHandle(parts[parts.length - 1]);
      const file = await fileHandle.getFile();
      return JSON.parse(await file.text()) as FopAnalysis;
    } catch {
      return null;
    }
  }

  /** Write analysis to cache */
  async writeCache(analysis: FopAnalysis, agentModel: string): Promise<void> {
    if (!this.cacheDir) return;

    const { fopPath, fileHash, language } = analysis;
    const key = `${fopPath}__${language}`;
    const cacheFilePath = `${CACHE_SUBDIR}/${fopPath}.json`;

    // Ensure directory structure exists
    const parts = cacheFilePath.split('/');
    let dir = this.cacheDir;
    for (const part of parts.slice(0, -1)) {
      dir = await dir.getDirectoryHandle(part, { create: true });
    }

    // Write JSON
    const fileHandle = await dir.getFileHandle(parts[parts.length - 1], { create: true });
    const writable = await fileHandle.createWritable();
    await writable.write(JSON.stringify(analysis, null, 2));
    await writable.close();

    // Update manifest
    this.manifest.entries[key] = {
      fopPath,
      fileHash,
      language,
      analyzedAt: new Date().toISOString(),
      agentModel,
      cacheFile: cacheFilePath,
    };
    await this.saveManifest();
  }

  /** Invalidate cache for a specific FOP */
  async invalidate(relativePath: string, lang?: 'de' | 'en'): Promise<void> {
    if (lang) {
      delete this.manifest.entries[`${relativePath}__${lang}`];
    } else {
      delete this.manifest.entries[`${relativePath}__de`];
      delete this.manifest.entries[`${relativePath}__en`];
    }
    await this.saveManifest();
  }

  /** Clear all cache entries */
  async clearAll(): Promise<void> {
    this.manifest = { version: MANIFEST_VERSION, entries: {} };
    await this.saveManifest();
    // Remove cache subdirectory
    try {
      await this.cacheDir!.removeEntry(CACHE_SUBDIR, { recursive: true });
    } catch {
      // Ignore if not found
    }
  }

  /**
   * Return hit/stale/total counts for the given FOP paths and language.
   * `stale` counts manifest entries whose FOP is no longer in `allFopPaths`
   * (i.e. the file was deleted or renamed since the last analysis).
   *
   * @param allFopPaths - Relative paths of all currently available FOP files
   * @param lang - Analysis language to count statistics for
   */
  getStats(allFopPaths: string[], lang: 'de' | 'en'): { cached: number; stale: number; total: number } {
    let cached = 0;
    let stale = 0;
    for (const path of allFopPaths) {
      const key = `${path}__${lang}`;
      if (this.manifest.entries[key]) cached++;
    }
    stale = Object.values(this.manifest.entries).filter(e => e.language === lang && !allFopPaths.includes(e.fopPath)).length;
    return { cached, stale, total: allFopPaths.length };
  }
}

/** Ensure Konzept/ and Konzept/Tests/ directories exist */
export async function ensureOutputDirectories(rootDir: FileSystemDirectoryHandle): Promise<void> {
  const konzept = await rootDir.getDirectoryHandle('Konzept', { create: true });
  await konzept.getDirectoryHandle('Tests', { create: true });
}

/** Write a Markdown documentation file to Konzept/ */
export async function writeKonzeptDoc(
  rootDir: FileSystemDirectoryHandle,
  filename: string,
  content: string,
): Promise<void> {
  const konzept = await rootDir.getDirectoryHandle('Konzept', { create: true });
  const mdName = filename.endsWith('.md') ? filename : `${filename}.md`;
  const fileHandle = await konzept.getFileHandle(mdName, { create: true });
  const writable = await fileHandle.createWritable();
  await writable.write(content);
  await writable.close();
}

/** Write a .feature file to Konzept/Tests/ */
export async function writeFeatureTest(
  rootDir: FileSystemDirectoryHandle,
  filename: string,
  content: string,
): Promise<void> {
  const konzept = await rootDir.getDirectoryHandle('Konzept', { create: true });
  const tests = await konzept.getDirectoryHandle('Tests', { create: true });
  const featName = filename.endsWith('.feature') ? filename : `${filename}.feature`;
  const fileHandle = await tests.getFileHandle(featName, { create: true });
  const writable = await fileHandle.createWritable();
  await writable.write(content);
  await writable.close();
}
