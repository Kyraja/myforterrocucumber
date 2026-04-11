/**
 * Resolves FOP buffer field references (e.g. `M|kart`, `U|xvkart`) to
 * human-readable field names using a multi-priority lookup chain.
 *
 * Resolution priority (highest to lowest):
 * 1. Variable table lookup using the current buffer-state database
 * 2. Scan all variable tables for `M|` fields (mask context fallback)
 * 3. Variable type declaration for `U|` variables (`P12:26` → DB 12)
 * 4. Common fields table (`fopCommonFields`)
 * 5. Unknown — returns the raw field name unchanged
 *
 * The `FopBufferTracker` is used to determine which database a buffer slot
 * currently holds at the point of the field access.
 */
import type { FopFile, FieldResolution } from '../types/fop';
import type { TableDef } from '../types/gherkin';
import { lookupCommonField } from './fopCommonFields';
import { FopBufferTracker } from './fopBufferTracker';

/**
 * Resolve a single buffer field reference to a `FieldResolution` record.
 *
 * @param buffer - Buffer slot letter (e.g. `"M"`, `"H"`, `"U"`)
 * @param fieldName - Raw field name from the source (e.g. `"kart"`)
 * @param attribute - Attribute name for `M|kart^namebspr` accesses, otherwise `undefined`
 * @param fopFile - Parsed FOP file providing variable declarations
 * @param varTables - Uploaded variable table definitions for DB lookup
 * @param tracker - Buffer tracker with the current state of all buffer slots
 * @returns Resolved name, type, database number, and confidence level
 */
export function resolveField(
  buffer: string,
  fieldName: string,
  attribute: string | undefined,
  fopFile: FopFile,
  varTables: TableDef[],
  tracker: FopBufferTracker,
): FieldResolution {
  const lookupName = attribute ?? fieldName;

  // Priority 1: Variable table lookup via buffer state
  const bufState = tracker.getBufferState(buffer);
  if (bufState?.database !== null && bufState !== null) {
    const result = lookupInVarTables(varTables, bufState.database!, lookupName);
    if (result) {
      return {
        fieldName,
        buffer,
        resolvedName: result.name,
        resolvedType: result.type ?? '',
        database: bufState.database,
        confidence: 'from-vartable',
      };
    }
  }

  // Priority 2: For M| fields — look up by mask number from FopBinding context
  if (buffer === 'M') {
    for (const table of varTables) {
      const found = table.fields.find(f => f.name === lookupName);
      if (found) {
        return {
          fieldName,
          buffer,
          resolvedName: found.descriptionDe ?? found.description ?? found.name,
          resolvedType: '',
          database: null,
          confidence: 'from-vartable',
        };
      }
    }
  }

  // Priority 3: Resolve from variable type declaration (for U| variables)
  if (buffer === 'U') {
    const variable = fopFile.variables.find(v => v.name === fieldName);
    if (variable && variable.referencedDatabase) {
      const result = lookupInVarTables(varTables, variable.referencedDatabase, lookupName);
      if (result) {
        return {
          fieldName,
          buffer,
          resolvedName: result.name,
          resolvedType: result.type ?? '',
          database: variable.referencedDatabase,
          confidence: 'from-type',
        };
      }
      return {
        fieldName,
        buffer,
        resolvedName: `DB ${variable.referencedDatabase}: ${lookupName}`,
        resolvedType: variable.declaredType,
        database: variable.referencedDatabase,
        confidence: 'from-type',
      };
    }
  }

  // Priority 4: Common fields
  const common = lookupCommonField(lookupName);
  if (common) {
    return {
      fieldName,
      buffer,
      resolvedName: common,
      resolvedType: '',
      database: null,
      confidence: 'common-field',
    };
  }

  // Priority 5: Unknown
  return {
    fieldName,
    buffer,
    resolvedName: lookupName,
    resolvedType: '',
    database: null,
    confidence: 'unknown',
  };
}

/**
 * Look up a field by name in the variable tables for a specific database number.
 * The `database` property on `TableDef` is matched as an integer after stripping
 * non-digit characters (handles both `"2"` and `"DB 2"` formats).
 *
 * @param tables - All available variable table definitions
 * @param dbNumber - abas database number to filter by
 * @param fieldName - Technical field name to look up (case-insensitive)
 * @returns Human-readable name and optional type, or null if not found
 */
function lookupInVarTables(tables: TableDef[], dbNumber: number, fieldName: string): { name: string; type?: string } | null {
  for (const table of tables) {
    // Match by database number (TableDef.database is a string like "2" or "DB 2")
    const tableDbNum = parseInt(String(table.database).replace(/\D/g, ''));
    if (tableDbNum !== dbNumber) continue;
    const field = table.fields.find(f => f.name.toLowerCase() === fieldName.toLowerCase());
    if (field) {
      return { name: field.descriptionDe ?? field.description ?? field.name };
    }
  }
  return null;
}

/**
 * Resolve every unique mask reference in a `FopFile` to a `FieldResolution`.
 *
 * Deduplicates by `buffer|field` key so each unique access is resolved only
 * once, even if the same field appears on multiple lines.
 *
 * @param fopFile - Parsed FOP file whose `maskReferences` are to be resolved
 * @param varTables - Variable table definitions for DB lookup
 * @param tracker - Pre-computed buffer state tracker for the FOP file
 * @returns One `FieldResolution` per unique buffer+field combination
 */
export function resolveAllFields(
  fopFile: FopFile,
  varTables: TableDef[],
  tracker: FopBufferTracker,
): FieldResolution[] {
  const seen = new Set<string>();
  const results: FieldResolution[] = [];

  for (const ref of fopFile.maskReferences) {
    const key = `${ref.buffer}|${ref.field}`;
    if (seen.has(key)) continue;
    seen.add(key);

    const resolution = resolveField(ref.buffer, ref.field, ref.attribute, fopFile, varTables, tracker);
    results.push(resolution);
  }

  return results;
}
