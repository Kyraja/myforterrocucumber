/**
 * Deterministic GUID generation for features using FNV-1a hashing.
 *
 * Each `.feature` file carries a stable 16-hex-char GUID stored as a `@<guid>`
 * tag. The GUID is derived deterministically from the feature's chapter number
 * and name so that the same feature always receives the same GUID across
 * machines and sessions — enabling safe cross-reference between features (e.g.
 * record search words that reference the creating feature's GUID).
 *
 * Hash algorithm: FNV-1a 64-bit, chosen for its simplicity and low collision
 * rate on short strings. Output is truncated to 16 hex characters.
 *
 * Key functions:
 *  - {@link makeFeatureGuid}   — canonical entry point (chapter + name → GUID).
 *  - {@link makeFopGuid}       — GUID from a FOP filename (abas form objects).
 *  - {@link replaceFeatureGuid} — propagate a GUID change across a FeatureInput.
 *  - {@link collectExistingGuids} — scan the file tree for all assigned GUIDs.
 */
import type { FileTreeNode } from '../types/fileExplorer';
import type { FeatureInput } from '../types/gherkin';

/**
 * Build the normalized key string used as input to the GUID hash.
 *
 * Concatenates `chapterNum` + `name`, removes all whitespace, and lowercases
 * the result so that formatting differences never produce different GUIDs.
 *
 * @example
 * buildGuidInput("3.4.3", "Bezeichnung") // → "3.4.3bezeichnung"
 * buildGuidInput("",      "Login Test")  // → "logintest"
 *
 * @param chapterNum - The chapter/section number prefix (may be empty).
 * @param name - The feature name.
 * @returns The normalized string to be hashed.
 */
export function buildGuidInput(chapterNum: string, name: string): string {
  return `${chapterNum}${name}`.replace(/\s+/g, '').toLowerCase();
}

/**
 * Compute a deterministic 16-hex-char GUID from a raw string using FNV-1a 64-bit.
 *
 * Does NOT normalize the input — pass the exact string you want hashed. For
 * feature GUIDs derived from chapter number and name, prefer the higher-level
 * {@link makeFeatureGuid} which applies normalization first.
 *
 * Returns `'0000000000000000'` for empty/whitespace-only input.
 *
 * @param input - The raw string to hash.
 * @returns A 16-character lowercase hexadecimal string.
 */
export function generateFeatureGuid(input: string): string {
  const trimmed = input.trim();
  if (!trimmed) return '0000000000000000';

  // FNV-1a 64-bit
  const FNV_OFFSET = BigInt('0xcbf29ce484222325');
  const FNV_PRIME = BigInt('0x100000001b3');
  const MASK_64 = BigInt('0xffffffffffffffff');

  let hash = FNV_OFFSET;
  for (let i = 0; i < trimmed.length; i++) {
    hash ^= BigInt(trimmed.charCodeAt(i));
    hash = (hash * FNV_PRIME) & MASK_64;
  }

  return hash.toString(16).padStart(16, '0');
}

/**
 * THE canonical way to create a feature GUID.
 * Concatenates chapterNum + name, strips whitespace, lowercases → hash.
 *
 * makeFeatureGuid("3.4.3", "Bezeichnung") → hash of "3.4.3bezeichnung"
 * makeFeatureGuid("",      "Login Test")  → hash of "logintest"
 *
 * Use this everywhere a feature GUID is created or checked.
 */
export function makeFeatureGuid(chapterNum: string, name: string): string {
  return generateFeatureGuid(buildGuidInput(chapterNum, name));
}

/**
 * Create a deterministic GUID from a FOP filename.
 * Strips extension and folder, lowercases → hash.
 * e.g. "owvk/S0032.kart.FV" → hash of "s0032.kart.fv"
 * e.g. "FOP.PRJM.UP.DEF" → hash of "fop.prjm.up.def"
 */
export function makeFopGuid(fopPath: string): string {
  const filename = fopPath.split('/').pop() ?? fopPath;
  return generateFeatureGuid(filename.toLowerCase());
}

const GUID_TAG_RE = /^@(?:guid-)?([0-9a-f]{16})$/;

/**
 * Collect all feature GUIDs currently assigned in the file explorer tree.
 *
 * Walks the entire tree recursively and reads `@<guid>` tags from every
 * `.feature` file node. The tag is the single source of truth — GUIDs are
 * never stored separately.
 *
 * @param tree - Root nodes of the file explorer tree.
 * @returns A set of all 16-hex-char GUIDs found across all feature files.
 */
export function collectExistingGuids(tree: FileTreeNode[]): Set<string> {
  const guids = new Set<string>();
  const walk = (nodes: FileTreeNode[]) => {
    for (const node of nodes) {
      if (node.type === 'file' && node.featureInput) {
        for (const tag of node.featureInput.tags) {
          const m = GUID_TAG_RE.exec(tag);
          if (m) guids.add(m[1]);
        }
      }
      if (node.children.length > 0) walk(node.children);
    }
  };
  walk(tree);
  return guids;
}

/**
 * Find the current GUID tag in a feature's tags array.
 * Returns the 16-hex-char GUID (without @) or null.
 */
export function findGuidInTags(tags: string[]): string | null {
  for (const tag of tags) {
    const m = GUID_TAG_RE.exec(tag);
    if (m) return m[1];
  }
  return null;
}

/**
 * Propagate a GUID change throughout a {@link FeatureInput}.
 *
 * Replaces every occurrence of `oldGuid` with `newGuid` in:
 *  - Feature tags (`@<oldGuid>` → `@<newGuid>`)
 *  - Step texts and data table cells (e.g. record references like `<guid>-KB-001`)
 *  - Structured action fields (`record`, `searchCriteria`, `value`, `expectedValue`)
 *
 * Returns the original object unchanged if `oldGuid === newGuid` or if
 * `oldGuid` is empty.
 *
 * @param feature - The feature to update.
 * @param oldGuid - The GUID string to replace (16 hex chars, without `@`).
 * @param newGuid - The replacement GUID string.
 * @returns A new {@link FeatureInput} with all references updated.
 */
export function replaceFeatureGuid(feature: FeatureInput, oldGuid: string, newGuid: string): FeatureInput {
  if (oldGuid === newGuid || !oldGuid) return feature;

  const replaceInString = (s: string): string => s.replaceAll(oldGuid, newGuid);

  return {
    ...feature,
    tags: feature.tags.map((tag) => replaceInString(tag)),
    scenarios: feature.scenarios.map((scenario) => ({
      ...scenario,
      steps: scenario.steps.map((step) => ({
        ...step,
        text: replaceInString(step.text),
        dataTable: step.dataTable?.map((row) => row.map((cell) => replaceInString(cell))),
        action: replaceGuidInAction(step.action, oldGuid, newGuid),
      })),
    })),
  };
}

/** Replace GUID in action field values (record, searchCriteria, value fields). */
function replaceGuidInAction(action: import('../types/gherkin').StepAction, oldGuid: string, newGuid: string): import('../types/gherkin').StepAction {
  const r = (s: string) => s.replaceAll(oldGuid, newGuid);
  switch (action.type) {
    case 'editorOeffnen':
      return { ...action, record: r(action.record) };
    case 'editorOeffnenSuche':
      return { ...action, searchCriteria: r(action.searchCriteria) };
    case 'feldSetzen':
      return { ...action, value: r(action.value) };
    case 'feldPruefen':
      return { ...action, expectedValue: r(action.expectedValue) };
    default:
      return action;
  }
}
