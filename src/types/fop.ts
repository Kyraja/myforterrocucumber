/**
 * Complete type system for the FOP (Flexible Oberflächen-Programmierung) analyzer.
 *
 * FOP is the abas ERP scripting language used to customize masks and business
 * logic.  This module defines every data structure produced by the analysis
 * pipeline:
 *
 * - Parsed file structure (`FopFile`, `FopVariable`, `EventHandler`, …)
 * - FOP.txt binding configuration (`FopBinding`)
 * - Call-tree nodes (`FopTreeNode`) and usage index (`FopUsage`)
 * - AI analysis output (`FopAnalysis`, `FieldInteraction`, …)
 * - Cache manifest (`CacheManifest`, `CacheEntry`)
 * - Agent run state (`AgentRun`, `AgentExchange`, …)
 */

// ── FOP Language & Header ─────────────────────────────────────

/** Interpreter language mode declared in the FOP's first line. */
export type FopLanguage = 'german' | 'english';

/**
 * Structured metadata extracted from the FOP comment header block.
 * abas convention uses `..Autor:`, `..Funktion:`, etc. at the top of the file.
 */
export interface FopHeader {
  author?: string;
  responsible?: string;
  function?: string;
  flow?: string;
  rawComments: string[];
}

// ── Variables ─────────────────────────────────────────────────

/**
 * A variable declared in a FOP file via `.type` or `.var`.
 * The parser resolves the declared type to an optional abas database number so
 * the field resolver can map buffer accesses to human-readable field names.
 */
export interface FopVariable {
  name: string;
  declaredType: string;           // "text", "AS8", "P12:26", "integer", etc.
  isPrimitive: boolean;           // text/integer/bool/real/date → true
  referencedDatabase?: number;    // AS8 → DB 2, P12:26 → DB 12
  referencedField?: number;       // P12:26 → field index 26
  conditionalDeclare: boolean;    // true if declared with ? _F|defined() guard
  declaredAtLine: number;
  usedAtLines: number[];
  followsNamingConvention: boolean; // xt=text, xi=integer, xb=bool, xd=date, xv/xp=ref
}

// ── Labels & Functions ────────────────────────────────────────

/** A FO1-style jump label (`!LABELNAME`) with its source line. */
export interface FopLabel {
  name: string;
  line: number;
}

/** A FO2-style `def functionName() { }` block with start and end lines. */
export interface FopFunction {
  name: string;
  startLine: number;
  endLine: number;
}

// ── Subprogram Calls ──────────────────────────────────────────

/**
 * A `.input`, `.eingabe`, or `.call` statement that invokes another FOP.
 * Dynamic calls (using a buffer variable instead of a literal path) cannot be
 * statically resolved and are flagged separately in the call tree.
 */
export interface SubprogramCall {
  line: number;
  target: string;            // "op/LOP.SELECT" or variable 'M|tab'
  isDynamic: boolean;        // true if using variable instead of literal
  condition?: string;        // optional condition after ?
  callType: 'input' | 'eingabe' | 'call';
}

// ── Events ────────────────────────────────────────────────────

/**
 * An event routing declaration detected in the FOP source.
 * In FO1 this is a `.continue LABEL ? T|evtart="maskein"` pattern;
 * in FO2 it is a `case ("maskein")` statement inside a switch block.
 */
export interface EventHandler {
  event: string;             // SE, SV, SX, SC, SEE, FF, FV, FX, BB, BA, RIB, RIA...
  eventLongName: string;     // maskein, maskpruef, feldpruef, feldaus, buttonnach...
  field?: string;            // for FV/FX/BB/BA: which field
  labelOrFunction: string;   // jump target or def-function name
  line: number;
}

// ── Mask / Buffer References ──────────────────────────────────

/**
 * A single buffer field access detected in the source, e.g. `M|kart`, `H|id`,
 * or the attribute form `M|kart^namebspr`.
 * `accessType` distinguishes reads from writes and indirect/attribute accesses.
 */
export interface MaskReference {
  field: string;
  buffer: string;            // M, H, 0-9, D, A, U, G
  accessType: 'read' | 'write' | 'attribute' | 'indirect';
  attribute?: string;        // M|kart^namebspr → "namebspr"
  line: number;
  resolvedName?: string;     // resolved from variable table / buffer tracker
  resolvedDatabase?: number;
}

// ── Buffer Operations ─────────────────────────────────────────

/**
 * The set of named buffer slots in the abas FOP runtime.
 * H=selection, D=dazu/reference, 0-9=load buffers, A=old state.
 */
export type BufferSlot = 'H' | 'D' | '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' | 'A';

/**
 * A `.select`, `.load`, or `.add` statement that fills a buffer slot.
 * The resolver attempts to determine which abas database the buffer now holds,
 * with a confidence rating reflecting how certain the inference is.
 */
export interface BufferOperation {
  line: number;
  buffer: BufferSlot;
  operation: 'select' | 'load' | 'add' | 'select-ascreen';
  sourceExpression: string;       // 'M|kart', '"12"', 'U|xref', etc.
  resolvedDatabase: number | null;
  confidence: 'certain' | 'inferred' | 'unknown';
}

/**
 * The inferred state of a buffer slot at a point in the execution flow.
 * Tracked by `FopBufferTracker` as it processes each line top-to-bottom.
 */
export interface BufferState {
  buffer: BufferSlot;
  database: number | null;
  confidence: 'certain' | 'inferred' | 'unknown';
  setAtLine: number;
  sourceExpression: string;
}

// ── EDP Calls ─────────────────────────────────────────────────

/**
 * An `edpimport` / `edpexport` / `edpinfosys` shell call detected in the FOP.
 * EDP is the abas batch interface for reading and writing records without a GUI.
 */
export interface EdpCall {
  line: number;
  type: 'import' | 'export' | 'infosys';
  database?: string;         // -b DB:Group or -l DB:Group
  action?: string;           // NEW, UPDATE, STORE, etc.
  inputFile?: string;
  commandLine: string;
}

// ── Error Statements ──────────────────────────────────────────

/**
 * A `.end 1`, `.error`, or `.fehler` statement — the primary mechanisms for
 * rejecting user input or aborting processing in FOP programs.
 */
export interface FopError {
  line: number;
  type: 'end-1' | 'error' | 'fehler';
  field?: string;
  message?: string;
}

// ── META Directives ───────────────────────────────────────────

/**
 * A `..<META H|= 'P2:1'>` comment directive that explicitly declares which
 * abas database a buffer holds.  Used as the highest-confidence source for
 * buffer-to-database mapping in the field resolver.
 */
export interface MetaDirective {
  line: number;
  buffer: string;
  typeReference: string;     // 'P2:1' → direct DB type info for buffer
}

// ── Parsed FOP File ───────────────────────────────────────────

/**
 * The complete parsed representation of a single FOP source file.
 * Produced by `parseFopSource()` and serves as the input to all downstream
 * analysis steps (field resolution, guidelines checking, AI prompt building).
 * `rawLines` is kept to allow line-level access without re-parsing.
 */
export interface FopFile {
  filename: string;
  relativePath: string;          // e.g. "owvk/S0032.kart.FV.FO2"
  fileHash: string;              // SHA-256 for cache invalidation
  interpreterMode: FopLanguage;
  hasDeclaration: boolean;
  hasNoabbrev: boolean;
  isFo2: boolean;                // FO2 (def/switch/if) vs FO1 (labels/.weiter)
  header: FopHeader;
  variables: FopVariable[];
  labels: FopLabel[];
  functions: FopFunction[];
  subprogramCalls: SubprogramCall[];
  maskReferences: MaskReference[];
  bufferOperations: BufferOperation[];
  edpCalls: EdpCall[];
  eventHandlers: EventHandler[];
  errorStatements: FopError[];
  metaDirectives: MetaDirective[];
  rawLines: string[];
}

// ── FOP.txt Binding ───────────────────────────────────────────

/**
 * A single entry from the abas `FOP.txt` configuration file.
 * Each binding wires a specific event on a mask+field combination to a FOP
 * program, making it the entry point of the call tree.
 */
export interface FopBinding {
  mask: number | '*';
  command: string;           // NEU, ÄNDERN, ZEIGEN, FREIGEBEN, *
  event: string;             // maskein, feldpruef, buttonnach, etc.
  eventShort: string;        // SE, FV, BA, etc.
  key: string;
  field: string;
  scope: 'K' | 'T' | '*';
  continueSearch: boolean;   // [C] vs [S]
  fopPath: string;           // e.g. "owvk/S0032.kart.FV"
}

// ── Field Resolution ──────────────────────────────────────────

/**
 * How confident the field resolver is about a resolved field name.
 * Resolution attempts fall through a priority chain:
 * `from-vartable` (certain) → `from-type` → `from-context` → `common-field` → `unknown`.
 */
export type FieldConfidence = 'from-vartable' | 'from-type' | 'from-context' | 'common-field' | 'unknown';

/** The result of resolving a single buffer field reference to a human-readable name. */
export interface FieldResolution {
  fieldName: string;
  buffer: string;
  resolvedName: string;
  resolvedType: string;
  database: number | null;
  confidence: FieldConfidence;
}

// ── Tree Nodes ────────────────────────────────────────────────

/**
 * A node in the FOP call tree rooted at a `FopBinding` entry point.
 * Children are sub-FOPs called via `.input`/`.call`; unresolved/missing
 * calls are tracked separately so the UI can surface gaps.
 */
export interface FopTreeNode {
  fopFile: FopFile;
  children: FopTreeNode[];
  unresolvedCalls: SubprogramCall[];   // dynamic calls like 'M|tab'
  missingCalls: string[];              // literal paths not found in uploaded files
  depth: number;
  entryPoint?: FopBinding;
  pattern?: InfosystemPattern;
  cacheStatus: 'cached' | 'stale' | 'missing' | 'unanalyzed';
  usageCount: number;                  // how many entry points use this FOP
}

/**
 * Groups the individual FOP files that together implement one abas infosystem.
 * Detected heuristically from the `IS.KEYWORD.EVENT` naming pattern.
 */
export interface InfosystemPattern {
  name: string;
  me?: FopFile;
  ev?: FopFile;
  bkopf?: FopFile;
  tab?: FopFile;
  bfuss?: FopFile;
  select?: FopFile;
}

// ── Usage Index ───────────────────────────────────────────────

/**
 * A full call chain from a `FopBinding` entry point down to a specific FOP.
 * Used by the usage index to answer "which masks/events use this sub-FOP?"
 */
export interface UsageChain {
  path: string[];             // ["SUB.S0032.TEST", "S0032.ART.FV.FO2"]
  binding: FopBinding;
  bindingLabel: string;       // "Maske 32 — Feld-Prüfung Artikel"
}

/** Reverse dependency record for a single FOP — who calls it and how. */
export interface FopUsage {
  fopPath: string;
  calledBy: string[];         // direct callers
  usageChains: UsageChain[];  // full chains up to FOP.txt binding
  isShared: boolean;          // used in more than one entry-point tree
}

// ── KI Analysis Output ────────────────────────────────────────

/**
 * A single field read or write interaction extracted by the AI analyst.
 * Combines technical detail (which buffer, which event triggered it) with a
 * human-readable business purpose so the output is useful to non-developers.
 */
export interface FieldInteraction {
  field: string;
  resolvedName: string;
  mask: string;
  maskNr: number | null;
  accessType: 'read' | 'write';
  writtenFrom?: string;       // e.g. "M|kart^namebspr (Artikelstamm DB 2)"
  trigger: string;            // e.g. "FV (feldpruef) auf M|kart"
  purposeTechnical: string;
  purposeHuman: string;
}

/** AI-generated technical analysis for a FOP, targeted at developers. */
export interface TechnicalDescription {
  summary: string;
  eventDescriptions: Record<string, string>;  // key: "FV:kart", value: description
  dataFlow: string;
  sideEffects: string[];
}

/** AI-generated business-language description of a FOP, targeted at non-technical stakeholders. */
export interface HumanDescription {
  summary: string;
  useCases: string[];
}

/** A single guideline violation or improvement suggestion for a FOP file. */
export interface GuidelineFinding {
  rule: string;
  line: number;
  severity: 'error' | 'warning' | 'info';
  message: string;
  source: 'local' | 'ai';
}

/** Aggregated guidelines check result: a letter grade and the list of findings. */
export interface GuidelinesResult {
  score: 'A' | 'B' | 'C' | 'D' | 'F';
  findings: GuidelineFinding[];
}

/**
 * The complete analysis result for one FOP file, persisted to the file system
 * cache as a JSON document.  Combines the parsed structure, resolved field
 * names, AI descriptions, and guidelines score into a single record.
 */
export interface FopAnalysis {
  fopPath: string;
  fileHash: string;
  language: 'de' | 'en';
  analyzedAt: string;
  parsedStructure: FopFile;
  fieldResolutions: FieldResolution[];
  technicalDescription: TechnicalDescription;
  humanDescription: HumanDescription;
  fieldInteractions: FieldInteraction[];
  guidelines: GuidelinesResult;
  cucumberTests?: import('./gherkin').FeatureInput[];
}

// ── Cache ─────────────────────────────────────────────────────

/** Metadata record for a single cached FOP analysis, stored in the manifest. */
export interface CacheEntry {
  fopPath: string;
  fileHash: string;
  language: 'de' | 'en';
  analyzedAt: string;
  agentModel: string;
  cacheFile: string;
}

/**
 * The root manifest file stored in `.fopanalyzer/manifest.json`.
 * Maps `"{relativePath}__{lang}"` keys to cache entry metadata so the system
 * can validate freshness (via `fileHash`) without reading every analysis file.
 */
export interface CacheManifest {
  version: string;
  entries: Record<string, CacheEntry>;  // key: "{relativePath}__{lang}"
}

// ── Agent Activity ────────────────────────────────────────────

/** Lifecycle state of a multi-step AI agent run (e.g. bulk FOP analysis). */
export type AgentRunStatus = 'idle' | 'running' | 'done' | 'error' | 'paused';

/** @deprecated legacy chat-bubble entry — replaced by WorkflowStep. Kept for migration. */
export interface AgentExchange {
  label: string;
  input: string;
  output?: string;
}

// ── Workflow Timeline ─────────────────────────────────────────

/** Lifecycle state of a single workflow step shown in the timeline. */
export type WorkflowStepStatus = 'running' | 'done' | 'error';

/**
 * Discriminator identifying which workflow phase a step belongs to.
 * Covers every AI workflow in the app (FOP analysis, Cucumber generation,
 * prompt rating, agent chat, FOP→Cucumber deep-test, bulk).
 */
export type WorkflowPhase =
  // FOP analysis
  | 'fop-parsing' | 'fop-buffers' | 'fop-fields' | 'fop-local-check'
  | 'fop-analyst' | 'fop-guidelines' | 'fop-cache-save'
  // Cucumber from text
  | 'cuc-table-id-local' | 'cuc-table-id-ai' | 'cuc-kb-extract' | 'cuc-kb-search'
  | 'cuc-context-send' | 'cuc-kb-send'
  | 'cuc-build-prompt' | 'cuc-generate' | 'cuc-deep-round' | 'cuc-parse'
  | 'cuc-scenario-list' | 'cuc-scenario-single' | 'cuc-scenario-continue'
  | 'cuc-feature-assemble'
  // Prompt rating
  | 'rating-input' | 'rating-call' | 'rating-parse'
  // Agent free-chat
  | 'agent-chat-response'
  // FOP → Cucumber deep-test
  | 'fop-cuc-table-id' | 'fop-cuc-build-prompt'
  | 'fop-cuc-deep-round' | 'fop-cuc-force-final' | 'fop-cuc-parse'
  // Bulk generation
  | 'bulk-package-start' | 'bulk-package-end';

interface WorkflowStepBase {
  /** Stable identifier assigned on creation — used to update the step later. */
  id: string;
  phase: WorkflowPhase;
  /** Localized, human-readable label (e.g. "Buffer-Tracking"). */
  label: string;
  /** Unix timestamp (ms) the step started. */
  timestamp: number;
  status: WorkflowStepStatus;
  /** Groups steps belonging to the same item (FOP path, feature name, package id). */
  itemKey?: string;
  /** Parent step id for nested workflows (e.g. bulk → inner generation). */
  parentId?: string;
  /** Filled when the step transitions out of `running`. */
  durationMs?: number;
  /** Filled when `status === 'error'` — user-facing error summary. */
  errorMessage?: string;
}

/** A step that runs entirely in local code (parsing, resolution, caching...). */
export interface LocalStep extends WorkflowStepBase {
  kind: 'local';
  /** One-line summary, e.g. "12 Buffer-Operationen verfolgt". */
  summary: string;
  /** Full human-readable input (collapsible in UI). */
  inputText?: string;
  /** Full human-readable output (collapsible in UI). */
  outputText?: string;
}

/** A step that makes a single AI/LLM call — records system + user prompt + raw response. */
export interface AiStep extends WorkflowStepBase {
  kind: 'ai';
  /** Logical agent identifier, e.g. 'fop-analyst', 'rating', 'cucumber-generation'. */
  agent: string;
  /** Exact system prompt sent to the model. */
  systemPrompt: string;
  /** Exact user message / context sent to the model. */
  userPrompt: string;
  /** Raw response text — filled once the call returns. */
  rawResponse?: string;
  /** Model identifier (e.g. 'gpt-4o-mini'). */
  model?: string;
}

export type WorkflowStep = LocalStep | AiStep;

/**
 * Live state of an ongoing or completed agent run.
 * Tracks progress, current item, and the complete workflow step timeline.
 */
export interface AgentRun {
  agentType: AgentType;
  agentLabel: string;
  status: AgentRunStatus;
  progress?: { current: number; total: number };
  currentItem?: string;
  /** Authoritative timeline of every local/AI step in this run. */
  steps: WorkflowStep[];
  /** @deprecated kept for legacy UI code — will be removed. */
  inputSnapshot?: string;
  /** @deprecated kept for legacy UI code — will be removed. */
  outputSoFar?: string;
  /** @deprecated kept for legacy UI code — will be removed. */
  exchanges: AgentExchange[];
  history: AgentRunHistoryItem[];
  startedAt?: number;
}

/** Identifies which AI agent/workflow a run belongs to. */
export type AgentType =
  | 'cucumber'
  | 'fop-analyst'
  | 'fop-guidelines'
  | 'rating'
  | 'bulk'
  | 'fop-cucumber'
  | 'agent-chat';

/** Summary record appended to the run history once an item is completed or fails. */
export interface AgentRunHistoryItem {
  item: string;
  status: 'done' | 'error';
  completedAt: number;
  durationMs: number;
}
