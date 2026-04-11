/**
 * Tracks the abas FOP buffer state through a linear scan of the source file.
 *
 * In FOP programs, named buffer slots (H, D, 0–9, M, U, G, A) hold references
 * to database records.  To resolve field accesses like `H|name` to a
 * human-readable field name we need to know which database the H buffer holds
 * at that point in the code.
 *
 * `FopBufferTracker` performs a single forward pass and updates its internal
 * buffer-state map on every `.select`, `.load`, `.add`, META directive, and
 * assignment statement it encounters.  The tracker pre-populates variable origins
 * from `.type` declarations so that `U|xvkart` (type `AS8` → DB 2) can be
 * resolved immediately.
 *
 * This is a best-effort, flow-insensitive approximation — branches and loops
 * are not modeled, so inferences in conditional code paths may be imprecise.
 *
 * Usage:
 * ```ts
 * const tracker = trackBuffers(parsedFop);
 * const state = tracker.getBufferState('H');
 * ```
 */
import type { FopFile, FopVariable, BufferState, BufferSlot } from '../types/fop';

/**
 * Map a known abas type string to its database number.
 * Handles `P12:26` notation and a small hard-coded table of common type aliases.
 *
 * @param typeStr - Raw type string from a `.type` declaration
 * @returns Database number, or null if the type is primitive or unrecognized
 */
function typeToDatabase(typeStr: string): number | null {
  // P12:26 → DB 12
  const pMatch = typeStr.match(/^[Pp](\d+)[:.]/);
  if (pMatch) return parseInt(pMatch[1]);

  // Known type → DB mappings (abas standard)
  const TYPE_DB_MAP: Record<string, number> = {
    'as8': 2,   // Artikel
    'ks8': 0,   // Kunden
    'ls8': 1,   // Lieferanten
  };
  return TYPE_DB_MAP[typeStr.toLowerCase()] ?? null;
}

/**
 * Stateful tracker that infers which abas database each buffer slot holds
 * as FOP source lines are processed sequentially.
 *
 * Initialize with the FOP's variable declarations (to resolve `U|` types),
 * then call {@link FopBufferTracker.processLine} for each source line in order.
 */
export class FopBufferTracker {
  private bufferStates = new Map<string, BufferState>();
  private variableOrigins = new Map<string, { database: number | null; confidence: 'certain' | 'inferred' | 'unknown' }>();

  constructor(variables: FopVariable[]) {
    // Pre-populate from type declarations
    for (const v of variables) {
      const db = typeToDatabase(v.declaredType);
      if (db !== null || v.referencedDatabase) {
        this.variableOrigins.set(`U|${v.name}`, {
          database: v.referencedDatabase ?? db,
          confidence: 'certain',
        });
      }
    }
  }

  /** Process a single line to update buffer states */
  processLine(line: string, lineNum: number): void {
    const trimmed = line.trim();

    // META directive: ..<META H|= 'P2:1'>
    const metaMatch = trimmed.match(/\.\.<META\s+([A-Z0-9]+)\|=\s*['"]([^'"]+)['"]/i);
    if (metaMatch) {
      const db = this.parseTypeRef(metaMatch[2]);
      if (db !== null) {
        this.setBuffer(metaMatch[1] as BufferSlot, db, 'certain', lineNum, metaMatch[2]);
      }
      return;
    }

    // .select group 'N' → H buffer = group N
    const selectGroupMatch = trimmed.match(/^\.(?:select|auswahl)\s+group\s+['"]?(\d+)['"]?/i);
    if (selectGroupMatch) {
      this.setBuffer('H', parseInt(selectGroupMatch[1]), 'certain', lineNum, `group ${selectGroupMatch[1]}`);
      return;
    }

    // .select database "selstring" → extract @gruppe=N if present
    const selectDbMatch = trimmed.match(/^\.(?:select|auswahl)\s+(\w+)\s+["']([^"']+)["']/i);
    if (selectDbMatch && selectDbMatch[1].toLowerCase() !== 'group') {
      const selStr = selectDbMatch[2];
      // Try to extract @gruppe=N or @group=N from selection string
      const groupMatch = selStr.match(/@(?:gruppe|group)=(\d+)/i);
      if (groupMatch) {
        // We know the group but not the database — store as negative (group number only)
        // Negative means "group N, DB unknown" — caller can resolve with mask context
        this.setBuffer('H', -(parseInt(groupMatch[1])), 'inferred', lineNum, selStr);
      } else {
        this.setBuffer('H', null, 'unknown', lineNum, selStr);
      }
      return;
    }

    // .load N object 'source'
    const loadMatch = trimmed.match(/^\.(?:load|laden)\s+(\d+)\s+/i);
    if (loadMatch) {
      const buf = loadMatch[1] as BufferSlot;
      const objMatch = trimmed.match(/object\s+['"]([^'"]+)['"]/i);
      if (objMatch) {
        const src = objMatch[1];
        // Check if source has a known origin
        const origin = this.variableOrigins.get(src) ?? this.variableOrigins.get(`U|${src}`);
        if (origin) {
          this.setBuffer(buf, origin.database, origin.confidence === 'certain' ? 'certain' : 'inferred', lineNum, src);
        } else {
          // Check if it's a mask field with known type
          const mMatch = src.match(/^M\|(\w+)$/);
          if (mMatch) {
            // Will be resolved later via variable table
            this.setBuffer(buf, null, 'unknown', lineNum, src);
          } else {
            this.setBuffer(buf, null, 'unknown', lineNum, src);
          }
        }
      }
      return;
    }

    // Assignment: .formula U|x = H|id → propagate origin
    const assignMatch = trimmed.match(/^\.(?:formula|formel|assign|zuweisen|copy)\s+([UMG])\|(\w+)\s*=/i);
    if (assignMatch) {
      const targetBuf = assignMatch[1];
      const targetVar = assignMatch[2];
      const rhs = trimmed.split('=').slice(1).join('=');

      // Check if RHS references a buffer
      const bufRefMatch = rhs.match(/([H0-9D])\|(\w+)/);
      if (bufRefMatch) {
        const srcBuf = bufRefMatch[1] as BufferSlot;
        const state = this.bufferStates.get(srcBuf);
        if (state && targetBuf === 'U') {
          this.variableOrigins.set(`U|${targetVar}`, {
            database: state.database,
            confidence: state.confidence === 'certain' ? 'inferred' : state.confidence,
          });
        }
      }
      return;
    }

    // EDP export with -l DB:Group → infer DB from result
    const edpMatch = trimmed.match(/edpexport.*?-l\s+(\d+):\d+/i);
    if (edpMatch) {
      this.setBuffer('H', parseInt(edpMatch[1]), 'inferred', lineNum, `edpexport -l ${edpMatch[1]}`);
    }
  }

  private parseTypeRef(typeRef: string): number | null {
    const match = typeRef.match(/^[Pp]?(\d+)[:.]/);
    return match ? parseInt(match[1]) : null;
  }

  private setBuffer(buf: BufferSlot, db: number | null, confidence: BufferState['confidence'], line: number, src: string): void {
    this.bufferStates.set(buf, { buffer: buf, database: db, confidence, setAtLine: line, sourceExpression: src });
  }

  /** Get current state of a buffer */
  getBufferState(buf: string): BufferState | null {
    return this.bufferStates.get(buf) ?? null;
  }

  /** Resolve a buffer field reference to a database */
  resolveBufferField(buffer: string, _field: string): { database: number | null; confidence: 'certain' | 'inferred' | 'unknown' } {
    const state = this.bufferStates.get(buffer);
    if (!state) return { database: null, confidence: 'unknown' };
    return { database: state.database, confidence: state.confidence };
  }

  /** Get all buffer states */
  getAllStates(): Map<string, BufferState> {
    return new Map(this.bufferStates);
  }
}

/**
 * Convenience function: run the buffer tracker over every line of a parsed
 * `FopFile` and return the fully populated tracker.
 *
 * @param fopFile - Parsed FOP file to analyze
 * @returns Tracker with all buffer states resolved as far as statically possible
 */
export function trackBuffers(fopFile: FopFile): FopBufferTracker {
  const tracker = new FopBufferTracker(fopFile.variables);
  for (let i = 0; i < fopFile.rawLines.length; i++) {
    tracker.processLine(fopFile.rawLines[i], i + 1);
  }
  return tracker;
}
