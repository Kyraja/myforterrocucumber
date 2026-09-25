/**
 * Central data model for the Cucumber/Gherkin BDD test generator.
 *
 * Defines the full type hierarchy: action building blocks → steps → scenarios →
 * feature files, plus supporting types for work packages, parse profiles, and
 * the abas ERP variable table (TableDef/FieldDef).
 *
 * All UI state, generator logic, and import/export routines are typed against
 * these interfaces so that the data shape is the single source of truth.
 */

/** Gherkin step keyword — maps directly to the Gherkin specification keywords. */
export type StepKeyword = 'Given' | 'When' | 'Then' | 'And' | 'But';

// ── Action types ──────────────────────────────────────────────

/**
 * Discriminant union of all structured step action types.
 * Each value corresponds to a concrete `Action*` interface below and maps to
 * a specific step template in the Gherkin generator.
 */
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
  | 'subeditorSchliessen'
  | 'subeditorSpeichern'
  | 'infosystemOeffnen'
  | 'tabelleZeilen'
  | 'exceptionSpeichern'
  | 'exceptionFeld'
  | 'dialogBeantworten'
  | 'zeilenAnfuegen'
  | 'boxMeldung'
  | 'editorOeffnenTipp';

/** A single field name / value pair, used inside data tables or multi-field steps. */
export interface FieldValue {
  fieldName: string;
  value: string;
}

/** Free-text step with no structured action — the user writes the step text directly. */
export interface ActionFreetext {
  type: 'freetext';
}

/** Commands for opening an editor (maps to abas EDP commands) */
export type EditorCommand =
  | 'NEW' | 'UPDATE' | 'STORE' | 'VIEW' | 'DELETE'
  | 'COPY' | 'DELIVERY' | 'INVOICE' | 'REVERSAL'
  | 'RELEASE' | 'PAYMENT' | 'CALCULATE' | 'TRANSFER' | 'DONE';

/**
 * Opens an abas editor (mask) for a specific record and EDP command.
 *
 * `record` and `recordFromEditor` are mutually exclusive:
 * - `record` holds a record number / search word (e.g. "PO001-01", "SPS001-01", "").
 * - `recordFromEditor` holds the name of a previously opened editor in the same
 *   scenario when this step chains from it (→ "for record from editor \"AUF1\"").
 *   Used for follow-up commands like DELIVERY/INVOICE on an earlier document.
 */
export interface ActionEditorOeffnen {
  type: 'editorOeffnen';
  editorName: string;
  tableRef: string;
  command: EditorCommand;
  record: string;
  recordFromEditor?: string;
}

/** Opens an abas editor by performing a search rather than loading a specific record ID. */
export interface ActionEditorOeffnenSuche {
  type: 'editorOeffnenSuche';
  editorName: string;
  tableRef: string;
  command: EditorCommand;
  searchCriteria: string;
}

/**
 * Opens an abas editor by navigating through a menu path from an existing record.
 *
 * `record` and `recordFromEditor` are mutually exclusive — see {@link ActionEditorOeffnen}.
 */
export interface ActionEditorOeffnenMenue {
  type: 'editorOeffnenMenue';
  editorName: string;
  tableRef: string;
  command: EditorCommand;
  record: string;
  recordFromEditor?: string;
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

/** Asserts that a field in the current mask has the expected value. */
export interface ActionFeldPruefen {
  type: 'feldPruefen';
  fieldName: string;
  expectedValue: string;
  row: string;
}

/** Asserts that a field is empty or non-empty (controlled by `isEmpty`). */
export interface ActionFeldLeer {
  type: 'feldLeer';
  fieldName: string;
  isEmpty: boolean;
  row: string;
}

/** Asserts whether a field is editable or read-only on the current mask. */
export interface ActionFeldAenderbar {
  type: 'feldAenderbar';
  fieldName: string;
  modifiable: boolean;
  row: string;
}

/** Saves (stores) the currently open editor. */
export interface ActionEditorSpeichern {
  type: 'editorSpeichern';
}

/** Closes the currently open editor without saving. */
export interface ActionEditorSchliessen {
  type: 'editorSchliessen';
}

/** Switches focus to a different already-open editor by name. */
export interface ActionEditorWechseln {
  type: 'editorWechseln';
  editorName: string;
}

/** Creates a new table row in the current editor's table section. */
export interface ActionZeileAnlegen {
  type: 'zeileAnlegen';
}

export interface ActionButtonDruecken {
  type: 'buttonDruecken';
  buttonName: string;
  row: string;
}

/** Opens a sub-editor (nested editor) via a button in a specific table row. */
export interface ActionSubeditorOeffnen {
  type: 'subeditorOeffnen';
  buttonName: string;
  subeditorName: string;
  row: string;
}

/** Closes the current subeditor without saving and switches back to the parent editor. */
export interface ActionSubeditorSchliessen {
  type: 'subeditorSchliessen';
}

/** Saves the current subeditor and switches back to the parent editor. */
export interface ActionSubeditorSpeichern {
  type: 'subeditorSpeichern';
}

export interface ActionInfosystemOeffnen {
  type: 'infosystemOeffnen';
  infosystemName: string;
  /** Infosystem reference (e.g. "200:1" from Suchwort V-200-01) */
  infosystemRef: string;
}

/** Asserts the number of rows currently visible in the editor's table section. */
export interface ActionTabelleZeilen {
  type: 'tabelleZeilen';
  rowCount: string;
}

/** Expects an exception (error dialog) identified by `exceptionId` to appear. */
export interface ActionExceptionSpeichern {
  type: 'exceptionSpeichern';
  exceptionId: string;
}

/** Asserts a specific field value within an open exception dialog. */
export interface ActionExceptionFeld {
  type: 'exceptionFeld';
  fieldName: string;
  value: string;
  exceptionId: string;
}

/** Answers a modal dialog with the given answer (e.g. "Ja" / "Nein"). */
export interface ActionDialogBeantworten {
  type: 'dialogBeantworten';
  dialogId: string;
  answer: string;
}

/** Appends new rows to the table section via the "Zeilen anfügen" mechanism. */
export interface ActionZeilenAnfuegen {
  type: 'zeilenAnfuegen';
}

/** Asserts that an abas hint/info box with the given message text was displayed. */
export interface ActionBoxMeldung {
  type: 'boxMeldung';
  messageText: string;
}

/**
 * Opens an editor via an abas typed command (Tippkommando).
 * Step pattern: `Given I open an editor "<name>" for tip command "<cmd>" and arguments "<args>"`
 * No `from table` or `with command` — the framework derives the target from the typed command.
 */
export interface ActionEditorOeffnenTipp {
  type: 'editorOeffnenTipp';
  editorName: string;
  tipCommand: string;
  arguments: string;
}

/**
 * Discriminated union of every concrete step action.
 * The `type` field is the discriminant; components and the generator switch on it.
 */
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
  | ActionSubeditorSchliessen
  | ActionSubeditorSpeichern
  | ActionInfosystemOeffnen
  | ActionTabelleZeilen
  | ActionExceptionSpeichern
  | ActionExceptionFeld
  | ActionDialogBeantworten
  | ActionZeilenAnfuegen
  | ActionBoxMeldung
  | ActionEditorOeffnenTipp;

// ── Core model ────────────────────────────────────────────────

/**
 * A single Gherkin step — one line beginning with Given/When/Then/And/But.
 * The `action` carries structured data that the generator uses to produce the
 * step text; `dataTable` is only populated for multi-value steps.
 */
export interface Step {
  id: string;
  keyword: StepKeyword;
  text: string;
  action: StepAction;
  /** Gherkin data table rows (e.g. for "I set fields", "I append rows") */
  dataTable?: string[][];
}

/**
 * A single Gherkin scenario within a feature file.
 * An optional `comment` is rendered as a `# comment` line above the Scenario keyword.
 */
export interface Scenario {
  id: string;
  name: string;
  comment?: string;
  steps: Step[];
}

/**
 * Top-level state object representing one `.feature` file.
 * This is the central piece of state owned by `App.tsx` and passed down to all
 * child components. `generateGherkin()` consumes it to produce the feature text.
 */
export interface FeatureInput {
  name: string;
  description: string;
  tags: string[];
  database: AbasDatabase | null;
  testUser: string;
  scenarios: Scenario[];
}

/**
 * Represents one abas ERP database (Datenbank) from the standard list.
 * `id` is the internal DB number, `sw` the search word, `de`/`en` the names,
 * and `fc` the field count used for display hints.
 */
export interface AbasDatabase {
  id: number;
  sw: string;
  de: string;
  en: string;
  fc: number;
}

// ── Bulk import (work packages) ─────────────────────────────

/**
 * A single work package (Arbeitspaket) parsed from a requirements document.
 * Each work package is independently passed to the AI generator to produce one
 * `FeatureInput` / `.feature` file.
 */
export interface WorkPackage {
  id: string;
  title: string;
  description: string;
  implementationTime: string;
  qaTime: string;
  priority: string;
  area: string;
}

/** Lifecycle state of a single work package during bulk generation. */
export type WorkPackageStatus = 'pending' | 'generating' | 'done' | 'error';

/** Combines a work package with its current generation status and output. */
export interface WorkPackageResult {
  workPackage: WorkPackage;
  status: WorkPackageStatus;
  feature: FeatureInput | null;
  gherkin: string;
  error: string | null;
}

// ── Parse profiles (configurable import keywords) ────────────

/**
 * A user-defined regex pattern that maps a custom keyword in a requirements
 * document to a Gherkin step template.  Allows teams to extend the parser
 * without modifying source code.
 */
export interface CustomActionPattern {
  id: string;
  label: string;       // Display name, e.g. "Workflow starten"
  pattern: string;     // Regex string, e.g. "^Workflow starten:\\s*(.+)$"
  stepText: string;    // Template with {1},{2}… placeholders, e.g. "I start workflow \"{1}\""
}

/**
 * A named configuration profile that controls how a requirements document is
 * parsed into feature packages.  Different customer projects may use different
 * heading words and step keywords, so profiles let consultants adapt the parser
 * without code changes.
 */
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

/** A single validation message produced during document parsing or feature generation. */
export interface ValidationIssue {
  level: 'error' | 'warning' | 'info';
  message: string;
}

/**
 * The result of parsing one document chapter into a feature package.
 * Carries both the structured `FeatureInput` and the original source text so
 * the AI generator can work from the unmodified document language.
 */
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

/** A document chapter that was skipped during parsing, with the reason recorded for the UI. */
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

/**
 * Definition of a single field within an abas ERP database table, sourced from
 * the variable table CSV export.  The `name` is the technical field identifier
 * (e.g. `kart`); description fields carry the human-readable labels used in
 * prompt construction and in the generated Gherkin steps.
 */
export interface FieldDef {
  name: string;
  description: string;
  /** abas effective type from the uploaded variable table (for example I9 or C20). */
  dataType?: string;
  /** German description (when available from export) */
  descriptionDe?: string;
  /** English description (when available from export) */
  descriptionEn?: string;
  /** True if this field is marked as "Skip" in the variable table */
  skip?: boolean;
  /** True if write-protected on screens (cannot be set by user) */
  readonly?: boolean;
  /** True if this is a table/row field (prefix 'T'), false if header field (prefix 'K') */
  isTableField?: boolean;
}

/**
 * Definition of an abas ERP database or infosystem, with all its fields.
 * `tableRef` is the canonical reference in V/P-notation (e.g. `"3:23"` for
 * Sales Orders).  Used as the AI context when generating Gherkin for a package.
 */
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
  /** Mask number from the variable table export (Identity number / Number of 1st screen) */
  maskNr?: number;
  /**
   * When true, the AI should assume records in this table already exist
   * and only USE/reference them — not create new ones with STORE/NEW.
   * Useful for lookup tables like Aufzählung, Währung, etc.
   */
  assumeExists?: boolean;
}
