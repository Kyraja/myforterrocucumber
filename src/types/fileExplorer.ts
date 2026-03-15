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
