/**
 * Builds a reverse dependency index from the FOP call forest so callers can
 * quickly answer "where is this FOP used?" without traversing the tree each time.
 *
 * The index maps each FOP's relative path to a `FopUsage` record that lists:
 * - Direct callers (immediate parents in the call tree)
 * - Full usage chains from each `FopBinding` entry point down to the FOP
 * - Whether the FOP is "shared" (reachable from more than one entry point)
 *
 * As a side effect, `buildUsageIndex` also updates the `usageCount` field on
 * every `FopTreeNode` so the UI can display usage badges without a separate pass.
 */
import type { FopBinding, FopUsage, UsageChain, FopTreeNode } from '../types/fop';
import { getBindingLabel } from './fopTxtParser';

/**
 * Build the complete reverse dependency index from the FOP call forest.
 *
 * The algorithm makes three passes over the tree:
 * 1. Initialize an entry for every reachable FOP
 * 2. Populate `calledBy` (direct parent → child relationships)
 * 3. Trace full chains from each `entryPoint` binding to every descendant
 *
 * After all chains are built, FOPs with more than one unique mask+event+field
 * combination in their chains are flagged as `isShared`.
 *
 * @param roots - Root nodes of the FOP call forest (one per FOP.txt binding)
 * @param _bindings - Unused; retained for API symmetry with callers
 * @param lang - Language for human-readable binding labels in usage chains
 * @returns Map from relative FOP path to its `FopUsage` record
 */
export function buildUsageIndex(
  roots: FopTreeNode[],
  _bindings: FopBinding[],
  lang: 'de' | 'en' = 'de',
): Map<string, FopUsage> {
  const index = new Map<string, FopUsage>();

  // Initialize entries for all FOPs
  function initNode(node: FopTreeNode): void {
    if (!index.has(node.fopFile.relativePath)) {
      index.set(node.fopFile.relativePath, {
        fopPath: node.fopFile.relativePath,
        calledBy: [],
        usageChains: [],
        isShared: false,
      });
    }
    for (const child of node.children) initNode(child);
  }
  for (const root of roots) initNode(root);

  // Build caller relationships
  function buildCallers(node: FopTreeNode): void {
    for (const child of node.children) {
      const usage = index.get(child.fopFile.relativePath);
      if (usage && !usage.calledBy.includes(node.fopFile.relativePath)) {
        usage.calledBy.push(node.fopFile.relativePath);
      }
      buildCallers(child);
    }
  }
  for (const root of roots) buildCallers(root);

  // Build usage chains (path from FOP to FOP.txt binding)
  function buildChains(node: FopTreeNode, chain: string[], binding: FopBinding): void {
    const fopPath = node.fopFile.relativePath;
    const usage = index.get(fopPath);
    if (usage) {
      const fullChain: UsageChain = {
        path: [...chain, fopPath],
        binding,
        bindingLabel: getBindingLabel(binding, lang),
      };
      usage.usageChains.push(fullChain);
    }
    for (const child of node.children) {
      buildChains(child, [...chain, fopPath], binding);
    }
  }

  for (const root of roots) {
    if (root.entryPoint) {
      buildChains(root, [], root.entryPoint);
    }
  }

  // Mark shared FOPs (used in more than one unique entry point tree)
  for (const [, usage] of index.entries()) {
    const uniqueMasks = new Set(usage.usageChains.map(c => `${c.binding.mask}_${c.binding.event}_${c.binding.field}`));
    usage.isShared = uniqueMasks.size > 1;
  }

  // Update usageCount on tree nodes
  function updateCount(node: FopTreeNode): void {
    const usage = index.get(node.fopFile.relativePath);
    if (usage) node.usageCount = usage.usageChains.length;
    for (const child of node.children) updateCount(child);
  }
  for (const root of roots) updateCount(root);

  return index;
}

/**
 * Return all FOPs that are used in more than one entry-point tree.
 * Shared FOPs require extra care when modified, as a change affects multiple masks.
 *
 * @param index - Usage index produced by {@link buildUsageIndex}
 */
export function getSharedFops(index: Map<string, FopUsage>): FopUsage[] {
  return Array.from(index.values()).filter(u => u.isShared);
}

/**
 * Generate a short human-readable string describing how many entry points and
 * masks would be affected by a change to this FOP.  Used in the UI tooltip and
 * analysis report.
 *
 * @param usage - Usage record for the FOP
 * @param lang - Output language (`'de'` for German, `'en'` for English)
 * @returns Localized impact summary, e.g. "Change affects 3 entry points in 2 masks"
 */
export function getImpactDescription(usage: FopUsage, lang: 'de' | 'en' = 'de'): string {
  const masks = new Set(usage.usageChains.map(c => c.binding.mask));
  const count = usage.usageChains.length;
  if (lang === 'de') {
    return `Änderung betrifft ${count} Einstiegspunkt${count !== 1 ? 'e' : ''} in ${masks.size} Maske${masks.size !== 1 ? 'n' : ''}`;
  }
  return `Change affects ${count} entry point${count !== 1 ? 's' : ''} in ${masks.size} mask${masks.size !== 1 ? 's' : ''}`;
}
