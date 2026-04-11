/**
 * Type definitions for the sidebar file-explorer tree.
 *
 * The explorer displays the user's locally opened folder as a three-level tree:
 * folders → `.feature` files → individual scenarios.  Each node carries the
 * handles needed to read/write files via the File System Access API, so the
 * tree doubles as the workspace navigation structure.
 */

import type { FeatureInput } from './gherkin';

/** A node in the explorer file tree */
export interface FileTreeNode {
  /** Unique path relative to root directory, using '/' separator */
  path: string;
  /** Display name: Feature title for files, folder name for folders, scenario name for scenarios */
  displayName: string;
  /** Node type */
  type: 'folder' | 'file' | 'scenario';
  /** Child nodes (subfolders, files in folder, or scenarios in file) */
  children: FileTreeNode[];
  /** Whether this node is expanded in the UI */
  expanded: boolean;
  /** File handle for read/write (file nodes only) */
  fileHandle?: FileSystemFileHandle;
  /** Directory handle for operations (folder nodes only) */
  dirHandle?: FileSystemDirectoryHandle;
  /** Cached parsed content (file nodes only) */
  featureInput?: FeatureInput;
  /** Scenario ID within parent file (scenario nodes only) */
  scenarioId?: string;
}
