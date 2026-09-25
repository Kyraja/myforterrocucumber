/**
 * Data model for the Excel/CSV data-import feature: customers hand over
 * spreadsheets with master/transactional data, consultants transform and map
 * them onto abas databases/fields, and eventually generate Gherkin test data
 * from them. See src/lib/dataImportStore.ts for workspace persistence and
 * src/lib/excelParser.ts for parsing.
 */

export interface DataImportSchema {
  columns: string[];
  rowCount: number;
}

/** Metadata for a single on-disk version (v{n} folder) of an import. */
export interface DataImportVersionMeta {
  version: number;
  createdAt: string;
  fileName: string;
  schema: DataImportSchema;
  hasTransformed: boolean;
  transformInstruction?: string;
  hasMapping: boolean;
}

/** One imported spreadsheet, tracked as current version + at most one backup. */
export interface DataImportRecord {
  id: string;
  name: string;
  createdAt: string;
  updatedAt: string;
  current: DataImportVersionMeta;
  backup?: DataImportVersionMeta;
}

export interface DataImportManifest {
  version: number;
  imports: DataImportRecord[];
}

export type MappingConfidence = 'high' | 'medium' | 'low';
export type MappingSource = 'ai' | 'standard' | 'manual';
export type DataImportMappingMode = 'ai' | 'manual';

/** Field option appended to a column header in ImportIT files, e.g. `nummer@notempty`. */
export type ImportItFieldOption = 'notempty' | 'modifiable' | 'skip' | 'dontChangeIfEqual';

/** Import options that ImportIT encodes as a bit-sum in the option code (cell C1). */
export type ImportItImportOption =
  | 'createNew'
  | 'disableFop'
  | 'clearTable'
  | 'checkModifiable'
  | 'englishVariables'
  | 'dontChangeIfEqual'
  | 'checkForbiddenChars';

/** Header settings written to row 1 of a generated ImportIT file. */
export interface DataImportItSettings {
  /** 1-based column where table fields start; 0 when the sheet has no table fields. */
  tableStartColumn: number;
  options: ImportItImportOption[];
  /** Manual option code, used instead of the computed bit-sum when set. */
  optionCodeOverride: number | null;
  /** Sachmerkmalsleiste number; empty when unused. */
  smlNumber: string;
}

/** One candidate database the Excel-Mapping-Agent considered for the sheet. */
export interface DataImportDatabaseCandidate {
  tableRef: string;
  name: string;
  confidence: MappingConfidence;
  confidencePercent: number | null;
}

/** Result of an Excel-Mapping-Agent call: column-to-field assignments. */
export interface DataImportFieldMapping {
  column: string;
  field: string | null;
  /** Origin of the selected field: AI prediction, known abas field, or manual free text. */
  source: MappingSource;
  /** Original AI field prediction, kept when a user manually overrides the current field. */
  aiField?: string | null;
  aiConfidence?: MappingConfidence | null;
  aiConfidencePercent?: number | null;
  aiAlternativeField?: string | null;
  /** AI confidence in the primary `field` suggestion (null when manually set by the user). */
  confidence: MappingConfidence | null;
  /** AI confidence in percent (0-100) for the primary `field` suggestion. */
  confidencePercent: number | null;
  /** Second-best field suggestion from the AI, if any (e.g. "num2" as an alternative to "nummer"). */
  alternativeField?: string | null;
  dataType: 'text' | 'integer' | 'real' | 'date' | 'bool' | null;
  /** Expected type of the selected abas field, assessed from its field definition. */
  fieldDataType: string | null;
  mapped: boolean;
  /** Field options appended to the ImportIT column header. */
  importItOptions?: ImportItFieldOption[];
  /** Short AI note on ambiguity/caveats (e.g. "values look numeric but field also accepts text"). */
  note?: string;
}

export interface DataImportRelationship {
  column: string;
  targetDatabase: string;
  status: 'found' | 'requires_preparation';
  note: string;
}

export interface DataImportMappingResult {
  /** AI-assisted mappings may be refreshed through the agent; manual mappings never call an agent. */
  mode: DataImportMappingMode;
  database: DataImportDatabaseCandidate | null;
  /** All databases the AI considered (highest confidence first), for manual override in the UI. */
  databaseCandidates: DataImportDatabaseCandidate[];
  fieldMapping: DataImportFieldMapping[];
  /** Header settings for the ImportIT export of this sheet. */
  importIt: DataImportItSettings;
  unmapped: string[];
  relationships: DataImportRelationship[];
  testData: { database: string; fields: Record<string, string> }[];
  /** Legacy combined instruction kept for compatibility with older saved mappings. */
  cleanupInstruction: string;
  /** Individual issues about columns, field compatibility, and mapping structure. */
  structuralHints: string[];
  /** Individual issues about values, formats, and content normalization. */
  contentHints: string[];
  warnings: string[];
}
