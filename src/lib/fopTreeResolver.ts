/**
 * Builds the FOP call tree by resolving subprogram references between parsed
 * FOP files and wiring them to their `FOP.txt` entry-point bindings.
 *
 * The main export {@link buildFopTree} takes the list of bindings and all
 * uploaded FOP files, then recursively resolves `.input`/`.call` statements to
 * produce a tree of `FopTreeNode` objects.  Cycles are detected and skipped.
 *
 * Additional exports allow traversing the tree (bottom-up levels, flat path
 * list) without coupling callers to the tree structure directly.
 */
import type { FopFile, FopTreeNode, FopBinding, InfosystemPattern, SubprogramCall } from '../types/fop';

/**
 * Normalize a FOP path so that case differences, backslashes, and `.fo1`/`.fo2`
 * extensions do not prevent a match.
 * @param path - Raw path string from a subprogram call or relative path
 */
function normalizePath(path: string): string {
  return path.toLowerCase().replace(/\\/g, '/').replace(/\.fo[12]?$/, '');
}

/**
 * Locate a `FopFile` in the map by normalized path, falling back to filename-only
 * matching when the folder prefix differs.
 * @param fopMap - Index of all uploaded FOP files keyed by relative path
 * @param target - Path string from the `.input` statement to resolve
 */
function findFop(fopMap: Map<string, FopFile>, target: string): FopFile | undefined {
  const normalized = normalizePath(target);
  for (const [key, file] of fopMap.entries()) {
    if (normalizePath(key) === normalized) return file;
    // Also try matching just the filename
    const keyBase = key.split('/').pop() ?? key;
    const targetBase = target.split('/').pop() ?? target;
    if (normalizePath(keyBase) === normalizePath(targetBase)) return file;
  }
  return undefined;
}

/** Detect standard infosystem pattern from a group of related FOPs */
function detectInfosystemPattern(fop: FopFile, fopMap: Map<string, FopFile>): InfosystemPattern | undefined {
  const name = fop.filename.replace(/\.[^.]+$/, ''); // strip extension

  // IS.KEYWORD.EVENT pattern
  const isMatch = name.match(/^(IS\.\w+)\.(SE|SV|SX|BA|FF|FV|FX|BKOPF|TAB|BFUSS|ME|EV)(\.\w+)?$/i);
  if (!isMatch) return undefined;

  const prefix = isMatch[1];
  const pattern: InfosystemPattern = { name: prefix };

  for (const [, file] of fopMap.entries()) {
    const fn = file.filename.replace(/\.[^.]+$/, '');
    if (fn.startsWith(prefix)) {
      if (fn.includes('.ME') || fn.includes('.maskein')) pattern.me = file;
      else if (fn.includes('.EV')) pattern.ev = file;
      else if (fn.includes('.BKOPF')) pattern.bkopf = file;
      else if (fn.includes('.TAB')) pattern.tab = file;
      else if (fn.includes('.BFUSS')) pattern.bfuss = file;
      else if (fn.includes('.SELECT')) pattern.select = file;
    }
  }

  return pattern;
}

/**
 * Recursively build a `FopTreeNode` for `fop` and all its called sub-FOPs.
 * The `visited` set prevents infinite recursion on cyclic call graphs.
 *
 * @param fop - The FOP file for this node
 * @param fopMap - Full index of available FOP files
 * @param visited - Paths already on the current call stack (cycle guard)
 * @param depth - Current depth in the tree (0 = entry point)
 * @param binding - FOP.txt binding that started this tree (root nodes only)
 */
function buildNode(
  fop: FopFile,
  fopMap: Map<string, FopFile>,
  visited: Set<string>,
  depth: number,
  binding?: FopBinding,
): FopTreeNode {
  const nodeKey = fop.relativePath;
  visited.add(nodeKey);

  const children: FopTreeNode[] = [];
  const unresolvedCalls: SubprogramCall[] = [];
  const missingCalls: string[] = [];

  for (const call of fop.subprogramCalls) {
    if (call.isDynamic) {
      unresolvedCalls.push(call);
      continue;
    }

    if (visited.has(call.target) || visited.has(normalizePath(call.target))) {
      // Cycle detected — skip
      continue;
    }

    const childFop = findFop(fopMap, call.target);
    if (!childFop) {
      missingCalls.push(call.target);
      continue;
    }

    const childNode = buildNode(childFop, fopMap, new Set(visited), depth + 1);
    children.push(childNode);
  }

  const pattern = detectInfosystemPattern(fop, fopMap);

  return {
    fopFile: fop,
    children,
    unresolvedCalls,
    missingCalls,
    depth,
    entryPoint: binding,
    pattern,
    cacheStatus: 'unanalyzed',
    usageCount: 0,
  };
}

/**
 * Build the complete FOP call forest from a list of FOP.txt bindings and
 * the full set of uploaded FOP files.
 *
 * Each binding that resolves to an existing FOP file becomes a root node.
 * Bindings pointing to missing FOPs are silently skipped (the missing entry
 * is visible via `missingCalls` on the parent instead).
 *
 * @param bindings - All parsed FOP.txt entries
 * @param fopFiles - All parsed FOP files available in the workspace
 * @returns Array of root tree nodes, one per resolvable binding
 */
export function buildFopTree(
  bindings: FopBinding[],
  fopFiles: FopFile[],
): FopTreeNode[] {
  const fopMap = new Map<string, FopFile>();
  for (const fop of fopFiles) {
    fopMap.set(fop.relativePath, fop);
  }

  const roots: FopTreeNode[] = [];

  for (const binding of bindings) {
    const fop = findFop(fopMap, binding.fopPath);
    if (!fop) {
      // Entry point FOP not found — create placeholder
      continue;
    }
    const node = buildNode(fop, fopMap, new Set(), 0, binding);
    roots.push(node);
  }

  return roots;
}

/**
 * Collect all tree nodes grouped by depth, ordered from the deepest level
 * upward.  Used by the batch analyzer to process leaf FOPs before their
 * callers so that sub-FOP descriptions are available when building parent prompts.
 *
 * @param roots - Root nodes of the FOP call forest
 * @returns Array of node arrays, index 0 = deepest level, last = depth 0
 */
export function traverseBottomUpLevels(roots: FopTreeNode[]): FopTreeNode[][] {
  const maxDepth = getMaxDepth(roots);
  const levels: FopTreeNode[][] = Array.from({ length: maxDepth + 1 }, () => []);

  function collect(node: FopTreeNode): void {
    levels[node.depth].push(node);
    for (const child of node.children) collect(child);
  }

  for (const root of roots) collect(root);

  // Return from deepest to shallowest
  return levels.reverse().filter(l => l.length > 0);
}

function getMaxDepth(nodes: FopTreeNode[]): number {
  let max = 0;
  function traverse(node: FopTreeNode): void {
    if (node.depth > max) max = node.depth;
    for (const child of node.children) traverse(child);
  }
  for (const node of nodes) traverse(node);
  return max;
}

/**
 * Flatten the call forest to a deduplicated list of relative FOP paths.
 * Useful for cache statistics and progress tracking.
 *
 * @param roots - Root nodes of the FOP call forest
 * @returns Unique relative paths of every FOP reachable from the roots
 */
export function getAllFopPaths(roots: FopTreeNode[]): string[] {
  const paths = new Set<string>();
  function collect(node: FopTreeNode): void {
    paths.add(node.fopFile.relativePath);
    for (const child of node.children) collect(child);
  }
  for (const root of roots) collect(root);
  return Array.from(paths);
}
