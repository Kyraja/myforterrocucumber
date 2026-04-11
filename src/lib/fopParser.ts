/**
 * Line-by-line parser that converts raw FOP source text into a structured
 * `FopFile` AST.
 *
 * The parser is intentionally permissive — it does not validate the FOP
 * language semantics, only extracts known patterns (variable declarations,
 * subprogram calls, buffer operations, event routing, etc.).  Unknown lines
 * are still scanned for buffer field references via regex.
 *
 * Entry point: {@link parseFopSource}
 * Hash utility: {@link computeFileHash}
 */
import type {
  FopFile, FopHeader, FopVariable, FopLabel, FopFunction,
  SubprogramCall, EventHandler, MaskReference, BufferOperation,
  EdpCall, FopError, MetaDirective, FopLanguage, BufferSlot
} from '../types/fop';

// ── Type resolution helpers ───────────────────────────────────

/** abas primitive types that do not reference a database. */
const PRIMITIVE_TYPES = new Set([
  'text', 't', 'gl', 'nt', 'integer', 'i', 'real', 'r', 'bool', 'b',
  'date', 'gd', 'gd2', 'gd8', 'au', 'au9',
]);

// Naming convention prefixes
const NAMING_PREFIX_MAP: Record<string, string> = {
  'text': 'xt', 'gl': 'xt', 'nt': 'xt',
  'integer': 'xi', 'real': 'xr', 'bool': 'xb',
  'date': 'xd', 'gd': 'xd', 'gd2': 'xd', 'gd8': 'xd',
};

const EVENT_MAP: Record<string, string> = {
  'maskein': 'SE', 'maskpruef': 'SV', 'maskaus': 'SX',
  'maskabbr': 'SC', 'maskende': 'SEE',
  'feldfuell': 'FF', 'feldpruef': 'FV', 'feldaus': 'FX', 'feldein': 'FE',
  'buttonvor': 'BB', 'buttonnach': 'BA',
  'zeileeinvor': 'RIB', 'zeileeinnach': 'RIA',
  'zeileausvor': 'RDB', 'zeileausnach': 'RDA',
  'zeilebewvor': 'RMB', 'zeilebewnach': 'RMA',
  'zeilemarkiert': 'RH',
};

/**
 * Resolve an abas type string to its associated database and field numbers.
 *
 * Handles `P12:26` (DB 12, field 26), infosystem pointers (`IP9`), and
 * alphanumeric type codes (`AS8`).  Returns nulls for unrecognized patterns.
 *
 * @param typeStr - Raw type string from the `.type` declaration (e.g. `"P12:26"`)
 * @returns Resolved DB/field numbers and a flag indicating a primitive type
 */
function resolveTypeToDatabase(typeStr: string): { db: number | null; field: number | null; isPrimitive: boolean } {
  const lower = typeStr.toLowerCase();

  if (PRIMITIVE_TYPES.has(lower)) return { db: null, field: null, isPrimitive: true };

  // Patterns like P12:26 → DB 12, field 26
  const pMatch = typeStr.match(/^[Pp](\d+)[:\.](\d+)$/);
  if (pMatch) return { db: parseInt(pMatch[1]), field: parseInt(pMatch[2]), isPrimitive: false };

  // Patterns like IP9, IP5 → infosystem pointer
  if (/^[Ii][Pp]\d+$/.test(typeStr)) return { db: null, field: null, isPrimitive: false };

  // AS8, KS5, etc. → heuristic: last digits may indicate DB
  const alphaNumMatch = typeStr.match(/^[A-Za-z]+(\d+)$/);
  if (alphaNumMatch) {
    // Common abas type patterns — rough heuristic
    return { db: null, field: null, isPrimitive: false };
  }

  return { db: null, field: null, isPrimitive: false };
}

/**
 * Check whether a variable name follows the abas naming convention.
 * Convention: `xt` prefix for text, `xi` for integer, `xb` for bool,
 * `xd` for date, `xv`/`xp` for reference types.
 *
 * @param name - Variable name as declared in the FOP
 * @param typeStr - Declared type string used to determine expected prefix
 */
function checkNamingConvention(name: string, typeStr: string): boolean {
  const lower = typeStr.toLowerCase();
  const prefix = NAMING_PREFIX_MAP[lower];
  if (prefix) return name.startsWith(prefix);
  // Reference types should start with xv or xp
  if (!PRIMITIVE_TYPES.has(lower)) return name.startsWith('xv') || name.startsWith('xp') || name.startsWith('x');
  return name.startsWith('x');
}

// ── Buffer reference regex ────────────────────────────────────

/** Matches any `BUFFER|fieldname` pattern in a FOP source line. */
const BUFFER_REF_RE = /\b([MHDAmUGTF09]|[0-9])\|([A-Za-z_][A-Za-z0-9_]*)/g;

/**
 * Extract all buffer field references from a single source line.
 *
 * Handles three reference forms in order of specificity:
 * 1. Attribute access: `M|kart^namebspr`
 * 2. Indirect access: `M|.U|xfldname`
 * 3. Direct access: `M|field`, `H|id`, `0|pos`, etc.
 *
 * @param line - Raw source line (not trimmed)
 * @param lineNum - 1-based line number for the resulting `MaskReference`
 * @param isWrite - Whether this line is a write statement (`.formula`, `.assign`, etc.)
 */
function extractMaskReferences(line: string, lineNum: number, isWrite: boolean): MaskReference[] {
  const refs: MaskReference[] = [];
  const attrRe = /([MHDAmUG09])\|([A-Za-z_][A-Za-z0-9_]*)\^([A-Za-z_][A-Za-z0-9_]*)/g;
  const indirectRe = /M\|\.([UG])\|([A-Za-z_][A-Za-z0-9_]*)/g;

  // Attribute access: M|kart^namebspr
  let m: RegExpExecArray | null;
  attrRe.lastIndex = 0;
  while ((m = attrRe.exec(line)) !== null) {
    refs.push({ field: m[2], buffer: m[1], accessType: 'attribute', attribute: m[3], line: lineNum });
  }

  // Indirect: M|.U|xfldname
  indirectRe.lastIndex = 0;
  while ((m = indirectRe.exec(line)) !== null) {
    refs.push({ field: m[2], buffer: 'M', accessType: 'indirect', line: lineNum });
  }

  // Direct references: M|field, H|field, 0|field, etc.
  BUFFER_REF_RE.lastIndex = 0;
  while ((m = BUFFER_REF_RE.exec(line)) !== null) {
    const buf = m[1];
    const field = m[2];
    if (!refs.find(r => r.field === field && r.buffer === buf && r.line === lineNum)) {
      refs.push({ field, buffer: buf, accessType: isWrite ? 'write' : 'read', line: lineNum });
    }
  }

  return refs;
}

// ── Header parsing ────────────────────────────────────────────

/**
 * Parse the structured comment header at the top of a FOP file.
 * Reads lines until the first non-comment line and extracts author, responsible
 * party, function description, and flow description from conventional patterns.
 *
 * @param lines - All raw source lines of the FOP file
 */
function parseHeader(lines: string[]): FopHeader {
  const header: FopHeader = { rawComments: [] };
  for (const line of lines) {
    if (!line.startsWith('..')) break;
    if (line.startsWith('..!')) continue;
    const comment = line.slice(2).trim();
    header.rawComments.push(comment);

    const autorMatch = comment.match(/^(?:FOP-?)?Autor\s*:\s*(.+)/i);
    if (autorMatch) { header.author = autorMatch[1].trim(); continue; }

    const verantwMatch = comment.match(/^Verantwortlich\s*:\s*(.+)/i);
    if (verantwMatch) { header.responsible = verantwMatch[1].trim(); continue; }

    const funktionMatch = comment.match(/^Funktion\s*:\s*(.+)/i);
    if (funktionMatch) { header.function = funktionMatch[1].trim(); continue; }

    const ablaufMatch = comment.match(/^Ablauf\s*:\s*(.+)/i);
    if (ablaufMatch) { header.flow = ablaufMatch[1].trim(); continue; }
  }
  return header;
}

// ── Main parser ───────────────────────────────────────────────

/**
 * Parse raw FOP source text into a fully structured `FopFile`.
 *
 * The parser makes a single linear pass over all lines, dispatching each line
 * to the appropriate extraction logic based on its prefix.  The resulting
 * collections (variables, labels, events, buffer operations, …) are assembled
 * into a `FopFile` that downstream analyzers consume.
 *
 * @param content - Raw file content (Windows or Unix line endings accepted)
 * @param relativePath - Path relative to the workspace root (e.g. `"owvk/S0032.kart.FV.FO2"`)
 * @param fileHash - SHA-256 hash of `content` used for cache invalidation
 * @returns Fully parsed `FopFile` ready for analysis
 */
export function parseFopSource(
  content: string,
  relativePath: string,
  fileHash: string,
): FopFile {
  // Normalize Windows CRLF line endings to LF before parsing
  const rawLines = content.replace(/\r\n/g, '\n').replace(/\r/g, '\n').split('\n');

  // Detect interpreter directive
  let interpreterMode: FopLanguage = 'english';
  let hasDeclaration = false;
  let hasNoabbrev = false;
  let isFo2 = false;

  for (const line of rawLines.slice(0, 5)) {
    const l = line.toLowerCase();
    if (!l.startsWith('..!interpreter')) continue;
    if (l.includes('german')) interpreterMode = 'german';
    if (l.includes('declaration')) hasDeclaration = true;
    if (l.includes('noabbrev')) hasNoabbrev = true;
    break;
  }

  const header = parseHeader(rawLines);

  const variables: FopVariable[] = [];
  const labels: FopLabel[] = [];
  const functions: FopFunction[] = [];
  const subprogramCalls: SubprogramCall[] = [];
  const maskReferences: MaskReference[] = [];
  const bufferOperations: BufferOperation[] = [];
  const edpCalls: EdpCall[] = [];
  const eventHandlers: EventHandler[] = [];
  const errorStatements: FopError[] = [];
  const metaDirectives: MetaDirective[] = [];

  // Track variable names for usedAtLines
  const varUsageMap = new Map<string, number[]>();

  const fo2FunctionStack: Array<{ name: string; startLine: number }> = [];

  for (let i = 0; i < rawLines.length; i++) {
    const line = rawLines[i];
    const lineNum = i + 1;
    const trimmed = line.trim();

    // Skip empty lines
    if (!trimmed) continue;

    // Comments (but check for META directives first)
    if (trimmed.startsWith('..')) {
      // META directive: ..<META H|= 'P2:1'>
      const metaMatch = trimmed.match(/\.\.<META\s+([A-Z0-9]+)\|=\s*['"]([^'"]+)['"]/i);
      if (metaMatch) {
        metaDirectives.push({ line: lineNum, buffer: metaMatch[1], typeReference: metaMatch[2] });
      }
      continue;
    }

    // FO2: def function() { ... }
    const defMatch = trimmed.match(/^def\s+(\w+)\s*\(/);
    if (defMatch) {
      isFo2 = true;
      fo2FunctionStack.push({ name: defMatch[1], startLine: lineNum });
      continue;
    }

    // FO2: closing brace for function (simplified: count outermost })
    if (trimmed === '}' && fo2FunctionStack.length > 0) {
      const fn = fo2FunctionStack.pop()!;
      functions.push({ name: fn.name, startLine: fn.startLine, endLine: lineNum });
      continue;
    }

    // FO1: Labels  !LABEL: or !LABEL
    const labelMatch = trimmed.match(/^!([A-Za-z_][A-Za-z0-9_.]*):?$/);
    if (labelMatch) {
      labels.push({ name: labelMatch[1], line: lineNum });
      continue;
    }

    const lowerTrimmed = trimmed.toLowerCase();

    // Variable declaration: .type TYP name [? condition]  or  .var TYP name
    const typeMatch = trimmed.match(/^\.(?:type|art)\s+(\S+)\s+([\w\s]+?)(?:\s*\?.*)?$/i);
    const varMatch = trimmed.match(/^\.var\s+(\S+)\s+(\w+)/i);

    const declMatch = typeMatch || varMatch;
    if (declMatch) {
      const typeStr = declMatch[1];
      const namesStr = typeMatch ? declMatch[2] : declMatch[2];
      const names = namesStr.trim().split(/\s+/);
      const isConditional = trimmed.includes('? _') || trimmed.includes('?_');
      const { db, field: fieldIdx, isPrimitive } = resolveTypeToDatabase(typeStr);

      for (const varName of names) {
        if (!varName || varName.startsWith('?')) continue;
        variables.push({
          name: varName.trim(),
          declaredType: typeStr,
          isPrimitive,
          referencedDatabase: db ?? undefined,
          referencedField: fieldIdx ?? undefined,
          conditionalDeclare: isConditional,
          declaredAtLine: lineNum,
          usedAtLines: [],
          followsNamingConvention: checkNamingConvention(varName.trim(), typeStr),
        });
        varUsageMap.set(varName.trim(), []);
      }
      continue;
    }

    // Subprogram calls: .input "path" / .eingabe NAME / .call func()
    const inputMatch = trimmed.match(/^\.(?:input|eingabe)\s+["']([^"']+)["']/i);
    const callMatch = trimmed.match(/^\.call\s+(\w+)\s*\(/i);

    if (inputMatch) {
      const target = inputMatch[1];
      const isDynamic = !target.includes('/') && target.includes('|');
      const condPart = trimmed.match(/\?\s*(.+)$/);
      subprogramCalls.push({
        line: lineNum,
        target,
        isDynamic,
        condition: condPart ? condPart[1].trim() : undefined,
        callType: lowerTrimmed.startsWith('.eingabe') ? 'eingabe' : 'input',
      });
      continue;
    }
    if (callMatch) {
      isFo2 = true;
      subprogramCalls.push({ line: lineNum, target: callMatch[1], isDynamic: false, callType: 'call' });
      continue;
    }

    // Buffer operations: .select, .load, .add
    const selectMatch = trimmed.match(/^\.(?:select|auswahl)\s+(\w+)\s+['"]?([^'"?\s]+)['"]?/i);
    if (selectMatch) {
      const op = selectMatch[1].toLowerCase();
      let operation: BufferOperation['operation'] = 'select';
      if (op === 'ascreen') operation = 'select-ascreen';

      // Try to extract DB number from group selection
      let db: number | null = null;
      const groupMatch = trimmed.match(/group\s+['"]?(\d+)['"]?/i);
      if (groupMatch) db = parseInt(groupMatch[1]);

      bufferOperations.push({
        line: lineNum,
        buffer: 'H',
        operation,
        sourceExpression: selectMatch[2],
        resolvedDatabase: db,
        confidence: db !== null ? 'certain' : 'unknown',
      });
      continue;
    }

    const loadMatch = trimmed.match(/^\.(?:load|laden)\s+(\d+)\s+/i);
    if (loadMatch) {
      const bufNum = loadMatch[1] as BufferSlot;
      // Extract source expression
      const objMatch = trimmed.match(/object\s+['"]([^'"]+)['"]/i);
      const src = objMatch ? objMatch[1] : '';
      bufferOperations.push({
        line: lineNum,
        buffer: bufNum,
        operation: 'load',
        sourceExpression: src,
        resolvedDatabase: null,
        confidence: 'unknown',
      });
      continue;
    }

    const addMatch = trimmed.match(/^\.add\s+([HDA])\|(\w+)/i);
    if (addMatch) {
      bufferOperations.push({
        line: lineNum,
        buffer: addMatch[1].toUpperCase() as BufferSlot,
        operation: 'add',
        sourceExpression: `${addMatch[1]}|${addMatch[2]}`,
        resolvedDatabase: null,
        confidence: 'unknown',
      });
      continue;
    }

    // EDP calls: .system or .command with edpimport/edpexport
    if (/edpimport|edpexport|edpinfosys/i.test(trimmed)) {
      let type: EdpCall['type'] = 'import';
      if (/edpexport/i.test(trimmed)) type = 'export';
      if (/edpinfosys/i.test(trimmed)) type = 'infosys';

      const dbMatch = trimmed.match(/-[bl]\s+(\d+:\d+)/i);
      const actionMatch = trimmed.match(/-a\s+(\w+)/i);

      edpCalls.push({
        line: lineNum,
        type,
        database: dbMatch ? dbMatch[1] : undefined,
        action: actionMatch ? actionMatch[1].toUpperCase() : undefined,
        commandLine: trimmed,
      });
      continue;
    }

    // Error statements
    if (/^\.(end|ende)\s+1\b/i.test(trimmed)) {
      errorStatements.push({ line: lineNum, type: 'end-1' });
      continue;
    }
    if (/^\.(error|fehler)\b/i.test(trimmed)) {
      const fieldMatch = trimmed.match(/-field\s+['"]?(\w+)['"]?/i);
      const msgMatch = trimmed.match(/-message\s+["']([^"']+)["']/i);
      errorStatements.push({
        line: lineNum,
        type: lowerTrimmed.startsWith('.fehler') ? 'fehler' : 'error',
        field: fieldMatch ? fieldMatch[1] : undefined,
        message: msgMatch ? msgMatch[1] : undefined,
      });
      continue;
    }

    // Event routing detection (FO1): .continue/.weiter LABEL ? T|evtart="maskein"
    const continueMatch = trimmed.match(/^\.(?:continue|weiter)\s+(\w+)\s*\?\s*(?:[TG])\|evtart\s*=\s*["'](\w+)["']/i);
    if (continueMatch) {
      const eventLong = continueMatch[2].toLowerCase();
      const eventShort = EVENT_MAP[eventLong] ?? eventLong.toUpperCase();

      eventHandlers.push({
        event: eventShort,
        eventLongName: eventLong,
        labelOrFunction: continueMatch[1],
        line: lineNum,
      });
      continue;
    }

    // FO1 field event routing: .continue LABEL ? G|evtvar = "fieldname"
    const fieldEventMatch = trimmed.match(/^\.(?:continue|weiter)\s+(\w+)\s*\?\s*[GU]\|evtvar\s*=\s*["'](\w+)["']/i);
    if (fieldEventMatch) {
      eventHandlers.push({
        event: 'FV',
        eventLongName: 'feldpruef',
        field: fieldEventMatch[2],
        labelOrFunction: fieldEventMatch[1],
        line: lineNum,
      });
      continue;
    }

    // FO2 switch on evtart: case ("maskein")
    const caseMatch = trimmed.match(/^case\s*\(\s*["'](\w+)["']\s*\)/i);
    if (caseMatch) {
      isFo2 = true;
      const eventLong = caseMatch[1].toLowerCase();
      const eventShort = EVENT_MAP[eventLong] ?? eventLong.toUpperCase();

      // Find the enclosing function
      const fn = fo2FunctionStack[fo2FunctionStack.length - 1]?.name ?? 'main';
      eventHandlers.push({ event: eventShort, eventLongName: eventLong, labelOrFunction: fn, line: lineNum });
      continue;
    }

    // Collect mask references from write statements
    const isWriteLine = /^\.(formula|formel|assign|zuweisen|copy)\s+[MHD09]?\|/i.test(trimmed);
    const refs = extractMaskReferences(trimmed, lineNum, isWriteLine);
    for (const ref of refs) {
      maskReferences.push(ref);
    }

    // Track variable usage
    for (const [varName, usages] of varUsageMap.entries()) {
      if (trimmed.includes(varName)) usages.push(lineNum);
    }
  }

  // Apply usage tracking back to variables
  for (const variable of variables) {
    variable.usedAtLines = varUsageMap.get(variable.name) ?? [];
  }

  return {
    filename: relativePath.split('/').pop() ?? relativePath,
    relativePath,
    fileHash,
    interpreterMode,
    hasDeclaration,
    hasNoabbrev,
    isFo2,
    header,
    variables,
    labels,
    functions,
    subprogramCalls,
    maskReferences,
    bufferOperations,
    edpCalls,
    eventHandlers,
    errorStatements,
    metaDirectives,
    rawLines,
  };
}

/** Compute SHA-256 hash of text using Web Crypto API */
export async function computeFileHash(content: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(content);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}
