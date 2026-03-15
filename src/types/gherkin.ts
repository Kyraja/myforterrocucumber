export type StepKeyword = 'Given' | 'When' | 'Then' | 'And' | 'But';

// ── Action types ──────────────────────────────────────────────

export type ActionType =
  | 'freetext'
  | 'editorOeffnen'
  | 'editorOeffnenSuche'
  | 'editorOeffnenMenue'
  | 'feldSetzen'
  | 'feldPruefen'
  | 'feldLeer'
  | 'feldAenderbar'
  | 'editorSpeichern'
  | 'editorSchliessen'
  | 'editorWechseln'
  | 'zeileAnlegen'
  | 'buttonDruecken'
  | 'subeditorOeffnen'
  | 'infosystemOeffnen'
  | 'tabelleZeilen'
  | 'exceptionSpeichern'
  | 'exceptionFeld'
  | 'dialogBeantworten'
  | 'zeilenAnfuegen';

export interface FieldValue {
  fieldName: string;
  value: string;
}

export interface ActionFreetext {
  type: 'freetext';
}

/** Commands for opening an editor (maps to abas EDP commands) */
export type EditorCommand =
  | 'NEW' | 'UPDATE' | 'STORE' | 'VIEW' | 'DELETE'
  | 'COPY' | 'DELIVERY' | 'INVOICE' | 'REVERSAL'
  | 'RELEASE' | 'PAYMENT' | 'CALCULATE' | 'TRANSFER' | 'DONE';

export interface ActionEditorOeffnen {
  type: 'editorOeffnen';
  editorName: string;
  tableRef: string;
  command: EditorCommand;
  record: string;
}

export interface ActionEditorOeffnenSuche {
  type: 'editorOeffnenSuche';
  editorName: string;
  tableRef: string;
  command: EditorCommand;
  searchCriteria: string;
}

export interface ActionEditorOeffnenMenue {
  type: 'editorOeffnenMenue';
  editorName: string;
  tableRef: string;
  command: EditorCommand;
  record: string;
  menuChoice: string;
}

export interface ActionFeldSetzen {
  type: 'feldSetzen';
  fieldName: string;
  value: string;
  row: string;
  /** When true, uses "I set fields" with a data table instead of a single field */
  multi?: boolean;
  /** True if the search word was auto-generated (will be cleaned up at end) */
  autoSearchWord?: boolean;
}

export interface ActionFeldPruefen {
  type: 'feldPruefen';
  fieldName: string;
  expectedValue: string;
  row: string;
}

export interface ActionFeldLeer {
  type: 'feldLeer';
  fieldName: string;
  isEmpty: boolean;
  row: string;
}

export interface ActionFeldAenderbar {
  type: 'feldAenderbar';
  fieldName: string;
  modifiable: boolean;
  row: string;
}

export interface ActionEditorSpeichern {
  type: 'editorSpeichern';
}

export interface ActionEditorSchliessen {
  type: 'editorSchliessen';
}

export interface ActionEditorWechseln {
  type: 'editorWechseln';
  editorName: string;
}

export interface ActionZeileAnlegen {
  type: 'zeileAnlegen';
}

export interface ActionButtonDruecken {
  type: 'buttonDruecken';
  buttonName: string;
  row: string;
}

export interface ActionSubeditorOeffnen {
  type: 'subeditorOeffnen';
  buttonName: string;
  subeditorName: string;
  row: string;
}

export interface ActionInfosystemOeffnen {
  type: 'infosystemOeffnen';
  infosystemName: string;
  /** Infosystem reference (e.g. "200:1" from Suchwort V-200-01) */
  infosystemRef: string;
}

export interface ActionTabelleZeilen {
  type: 'tabelleZeilen';
  rowCount: string;
}

export interface ActionExceptionSpeichern {
  type: 'exceptionSpeichern';
  exceptionId: string;
}

export interface ActionExceptionFeld {
  type: 'exceptionFeld';
  fieldName: string;
  value: string;
  exceptionId: string;
}

export interface ActionDialogBeantworten {
  type: 'dialogBeantworten';
  dialogId: string;
  answer: string;
}

export interface ActionZeilenAnfuegen {
  type: 'zeilenAnfuegen';
}

export type StepAction =
  | ActionFreetext
  | ActionEditorOeffnen
  | ActionEditorOeffnenSuche
  | ActionEditorOeffnenMenue
  | ActionFeldSetzen
  | ActionFeldPruefen
  | ActionFeldLeer
  | ActionFeldAenderbar
  | ActionEditorSpeichern
  | ActionEditorSchliessen
  | ActionEditorWechseln
  | ActionZeileAnlegen
  | ActionButtonDruecken
  | ActionSubeditorOeffnen
  | ActionInfosystemOeffnen
  | ActionTabelleZeilen
  | ActionExceptionSpeichern
  | ActionExceptionFeld
  | ActionDialogBeantworten
  | ActionZeilenAnfuegen;

// ── Core model ────────────────────────────────────────────────

export interface Step {
  id: string;
  keyword: StepKeyword;
  text: string;
  action: StepAction;
  /** Gherkin data table rows (e.g. for "I set fields", "I append rows") */
  dataTable?: string[][];
}

export interface Scenario {
  id: string;
  name: string;
  comment?: string;
  steps: Step[];
}

export interface FeatureInput {
  name: string;
  description: string;
  tags: string[];
  database: AbasDatabase | null;
  testUser: string;
  scenarios: Scenario[];
}

export interface AbasDatabase {
  id: number;
  sw: string;
  de: string;
  en: string;
  fc: number;
}

// ── Bulk import (work packages) ─────────────────────────────

export interface WorkPackage {
  id: string;
  title: string;
  description: string;
  implementationTime: string;
  qaTime: string;
  priority: string;
  area: string;
}

export type WorkPackageStatus = 'pending' | 'generating' | 'done' | 'error';

export interface WorkPackageResult {
  workPackage: WorkPackage;
  status: WorkPackageStatus;
  feature: FeatureInput | null;
  gherkin: string;
  error: string | null;
}

// ── Parse profiles (configurable import keywords) ────────────

export interface CustomActionPattern {
  id: string;
  label: string;       // Display name, e.g. "Workflow starten"
  pattern: string;     // Regex string, e.g. "^Workflow starten:\\s*(.+)$"
  stepText: string;    // Template with {1},{2}… placeholders, e.g. "I start workflow \"{1}\""
}

export interface ParseProfile {
  id: string;
  name: string;

  keywords: {
    feature: string[];
    database: string[];
    testUser: string[];
    tags: string[];
    description: string[];
    scenario: string[];
    comment: string[];
  };

  stepKeywords: {
    precondition: string[];
    action: string[];
    result: string[];
    and: string[];
    but: string[];
  };

  splitting: {
    headingLevels: number[];
    /** Keywords that mark the start of the technical section within a chapter.
     *  If non-empty, only chapters containing one of these sub-headings/keywords
     *  are parsed — content before the keyword becomes the Feature description,
     *  content after it gets parsed for scenarios. Chapters without are skipped.
     *  Empty array = parse entire section (legacy behavior). */
    technicalSectionKeywords: string[];
    /** Keywords that mark the END of the relevant content within a chapter
     *  (e.g. "Auswirkungen der Customization/Extension" table in Forterro templates).
     *  If non-empty and technicalSectionKeywords is empty: content BEFORE the marker
     *  is used as the AI source text. Chapters without the marker are skipped.
     *  Takes precedence over technicalSectionKeywords when both are set. */
    contentEndKeywords?: string[];
  };

  customActions: CustomActionPattern[];
}

export interface ValidationIssue {
  level: 'error' | 'warning' | 'info';
  message: string;
}

export interface ParsedFeaturePackage {
  feature: FeatureInput;
  sourceHeading: string;
  /** The original plain text from the document section, before parsing.
   *  Used as AI input so the text stays in the original language. */
  sourceText: string;
  validation: ValidationIssue[];
  /** HTML heading level (1 = h1, 2 = h2, …) for TOC indentation */
  headingLevel: number;
  /** Value of the "Realisierung" (or legacy "Kunde") field from the box table.
   *  Used to determine who realizes this package (abas/Berater = internal, Kunde = customer). */
  kundeField?: string;
  /** Value of the "Aufwand" field from the box table (e.g. "2 Tage", "4h"). */
  aufwandField?: string;
}

export interface SkippedChapter {
  sourceHeading: string;
  reason: string;
  headingLevel: number;
}

/** A single entry in the document's full table of contents (all headings) */
export interface TocEntry {
  text: string;
  level: number;
  /** Whether this heading became a parsed feature package */
  kind: 'package' | 'skipped' | 'structure';
}

// ── Table/Field definitions (from CSV upload) ─────────────────

export interface FieldDef {
  name: string;
  description: string;
  /** German description (when available from export) */
  descriptionDe?: string;
  /** English description (when available from export) */
  descriptionEn?: string;
  /** True if this field is marked as "Skip" in the variable table */
  skip?: boolean;
}

export interface TableDef {
  database: string;
  group: string;
  tableRef: string;
  name: string;
  /** German table name (when available from export) */
  nameDe?: string;
  /** English table name (when available from export) */
  nameEn?: string;
  fields: FieldDef[];
  /** 'database' = Datenbank (V-DD-GG), 'infosystem' = Infosystem */
  kind: 'database' | 'infosystem';
}
