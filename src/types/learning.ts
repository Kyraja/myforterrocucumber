export type LearningCategory = 'rule' | 'pattern' | 'warning' | 'example';
export type LearningScope = 'customer' | 'general';
export type LearningUsage = 'both' | 'tests' | 'programs' | 'tests-global';

export interface LearningEntry {
  id: string;
  title: string;
  summary: string;
  comment?: string;
  keywords: string[];
  category: LearningCategory;
  scope: LearningScope;
  /** Optional relevance tag for prompt routing. Missing values are treated as "both". */
  usage?: LearningUsage;
  confirmed: boolean;
  acceptedCount?: number;
  rejectedCount?: number;
  sourcePath?: string;
  createdAt: string;
  updatedAt: string;
}
