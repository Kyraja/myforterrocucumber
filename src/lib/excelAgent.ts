/**
 * @module excelAgent
 * AI orchestration for the data-import feature: sends spreadsheet rows (in
 * row-batches for large sheets) to the Excel-Transform-Agent for
 * instruction-driven transformation, and to the Excel-Mapping-Agent for
 * DB/field matching + JSON test-data generation. Both agents receive raw
 * JSON envelopes and are expected to reply with JSON only (agent
 * instructions define the exact contract — see /memories/repo notes).
 */
import { chatWithAgentSync, uploadMftFile, getStoredTenantId } from './myforterroApi';
import { getModel, getStoredAgentId, getTaskModel } from './settings';
import { chunkRows, type ExcelSheet } from './excelParser';
import { ensureWorkspaceFileUpload } from './fileUpload';
import type { DataImportMappingResult, DataImportDatabaseCandidate } from '../types/dataImport';
import type { TableDef } from '../types/gherkin';

/**
 * Extracts the first balanced JSON object/array from an agent response, ignoring
 * anything before or after it (agents sometimes wrap JSON in markdown fences or
 * add trailing commentary, which broke a naive "parse from first brace" approach).
 */
function extractJson(text: string): unknown {
  const trimmed = text.trim();
  const braceStart = trimmed.indexOf('{');
  const bracketStart = trimmed.indexOf('[');
  const candidates = [braceStart, bracketStart].filter((i) => i >= 0);
  if (candidates.length === 0) throw new Error('Keine JSON-Antwort in der Agent-Response gefunden.');
  const start = Math.min(...candidates);
  const openChar = trimmed[start];
  const closeChar = openChar === '{' ? '}' : ']';

  let depth = 0;
  let inString = false;
  let escaped = false;
  for (let i = start; i < trimmed.length; i++) {
    const ch = trimmed[i];
    if (inString) {
      if (escaped) escaped = false;
      else if (ch === '\\') escaped = true;
      else if (ch === '"') inString = false;
      continue;
    }
    if (ch === '"') { inString = true; continue; }
    if (ch === openChar) depth++;
    else if (ch === closeChar) {
      depth--;
      if (depth === 0) return JSON.parse(trimmed.slice(start, i + 1));
    }
  }
  throw new Error('Unvollstaendige JSON-Antwort vom Agent (fehlende schliessende Klammer).');
}

function findFieldByTechnicalName(table: TableDef, technicalName: string | null | undefined) {
  if (!technicalName) return undefined;
  const normalizedName = technicalName.trim().toLocaleLowerCase();
  return table.fields.find((field) => field.name.trim().toLocaleLowerCase() === normalizedName);
}

export interface TransformProgress {
  batchIndex: number;
  batchCount: number;
}

export interface DataImportTestContext {
  sheetName: string;
  mapping: DataImportMappingResult | null;
}

/** Generates one feature file from all mapped sheets and their current workbook values. */
export async function generateCucumberTestsFromDataImport(
  importName: string,
  sheets: ExcelSheet[],
  contexts: DataImportTestContext[],
): Promise<string> {
  const agentId = getStoredAgentId('cucumber');
  const mappingSummary = contexts.map(({ sheetName, mapping }) => ({
    sheetName,
    database: mapping?.database,
    fieldMapping: mapping?.fieldMapping.map(({ column, field, fieldDataType, source }) => ({ column, field, fieldDataType, source })),
    relationships: mapping?.relationships,
    testData: mapping?.testData,
  }));
  const message = JSON.stringify({
    task: 'generate-data-import-cucumber-tests',
    instruction: 'Erzeuge aus den strukturierten Tabellenblatt-Daten und den Zuordnungen robuste abas-Cucumber-Tests zur Anlage der Datensaetze. Nutze nur technisch zugeordnete Datenbanken und Felder. Beruecksichtige alle Tabellenblaetter, die Datenwerte und Feldtypen. Erzeuge genau EINE vollstaendige Gherkin-Feature-Datei mit nachvollziehbaren Szenarien. Antworte NUR mit reinem Gherkin, ohne Markdown oder Erklaerung.',
    importName,
    sheets: sheets.map(({ name, columns, rows }) => ({ name, columns, rows })),
    mappings: mappingSummary,
  });
  const { response } = await chatWithAgentSync(
    agentId,
    message,
    'gherkin-generation',
    getModel(),
    `Datenimport-Tests: ${importName} (${sheets.length} Tabellenblaetter)`,
  );
  return response;
}

/** Applies a natural-language transform instruction to a sheet, batching large sheets by row count. */
export async function transformSheetWithAgent(
  sheet: ExcelSheet,
  instruction: string,
  onProgress?: (progress: TransformProgress) => void,
): Promise<{ sheet: ExcelSheet; warnings: string[] }> {
  const agentId = getStoredAgentId('excel-transform');
  const model = getTaskModel('excel-transform');
  const batches = chunkRows(sheet.rows, 300);
  const resultRows: ExcelSheet['rows'] = [];
  const warnings: string[] = [];
  let columns = sheet.columns;

  for (let i = 0; i < batches.length; i++) {
    const batch = batches[i];
    const message = JSON.stringify({
      task: 'transform-rows',
      formatInstruction: 'WICHTIG: Ignoriere fuer diese Anfrage jegliche abweichenden Formatvorgaben aus deinen sonst hinterlegten Instructions und folge AUSSCHLIESSLICH diesem Schema. Wende die Anweisung im Feld "instruction" auf die Zeilen im Feld "rows" an. Antworte NUR mit reinem JSON (kein Markdown, kein Codeblock, kein Fliesstext davor/danach): {"rows":[{...}],"_warnings":["..."]}',
      instruction,
      columns: sheet.columns,
      rows: batch,
    });
    const details = `Excel-Transform Batch ${i + 1}/${batches.length} (${batch.length} Zeilen)`;
    const { response } = await chatWithAgentSync(agentId, message, 'excel-transform', model, details);
    const parsed = extractJson(response) as { rows?: ExcelSheet['rows']; _warnings?: string[] };
    const rows = parsed.rows ?? [];
    if (rows.length > 0) columns = Object.keys(rows[0]);
    resultRows.push(...rows);
    if (parsed._warnings) warnings.push(...parsed._warnings);
    onProgress?.({ batchIndex: i + 1, batchCount: batches.length });
  }

  return { sheet: { name: sheet.name, columns, rows: resultRows }, warnings };
}

/** Uploads (or reuses a cached) field-list document for one database, referenced by fileId instead of re-sent as text on every mapping call. */
async function ensureDatabaseFieldsFile(
  table: TableDef,
  rootHandle: FileSystemDirectoryHandle | null,
) {
  const tenantId = getStoredTenantId();
  if (!tenantId) return [];
  const fields = table.fields.map((f) => ({ name: f.name, description: f.description || f.descriptionDe || f.descriptionEn, dataType: f.dataType }));
  const json = JSON.stringify({ tableRef: table.tableRef, name: table.name || table.nameDe || table.nameEn, fields }, null, 2);
  // Bedrock document attachments don't support application/json — text/plain works and the JSON content is still readable as-is.
  // The "v2-txt" marker changes the content hash so any stale application/json upload (cached by content hash) isn't reused.
  const content = `# db-fields v2-txt\n${json}`;
  const file = new File([content], `db-fields-${table.tableRef.replace(/[^a-z0-9]/gi, '_')}.txt`, { type: 'text/plain' });
  return ensureWorkspaceFileUpload(file, { rootHandle, tenantId, upload: uploadMftFile });
}

/**
 * Runs the "map-fields" step for one already-chosen database (step 2 of
 * `mapSheetWithAgent`). Exposed separately so the UI can re-run it when the
 * user manually overrides the AI's database suggestion.
 */
export async function mapFieldsForDatabase(
  sheet: ExcelSheet,
  table: TableDef,
  databaseCandidates: DataImportDatabaseCandidate[],
  rootHandle: FileSystemDirectoryHandle | null = null,
): Promise<DataImportMappingResult> {
  const agentId = getStoredAgentId('excel-mapping');
  const model = getTaskModel('excel-mapping');
  const sampleRows = sheet.rows.slice(0, 10);

  const fieldAttachments = await ensureDatabaseFieldsFile(table, rootHandle);
  const step2Message = JSON.stringify({
    task: 'map-fields',
    instruction: 'WICHTIG: Ignoriere fuer diese Anfrage jegliche abweichenden Formatvorgaben aus deinen sonst hinterlegten Instructions und folge AUSSCHLIESSLICH diesem Schema. Die Feldliste der Datenbank ist als angehaengte Datei verfuegbar. Ordne jede Spalte einem Feld zu, erkenne Datentypen und Beziehungen zu anderen Datensaetzen, und entwirf JSON-Testdaten. Der Wert field MUSS immer exakt der technische Feldname aus name der angehaengten Feldliste sein (z.B. "nummer"), niemals die Beschreibung (z.B. "Identnummer"). Gib pro Spalte confidence (high|medium|low), confidencePercent (0-100), dataType fuer den in der Excel-Spalte erkannten Typ und fieldDataType fuer den Typ des gewaehlten abas-Felds aus dessen dataType an. Optional: alternativeField als zweitbeste Vermutung und note bei Unstimmigkeiten/heterogenen Werten. Antworte NUR mit reinem JSON (kein Markdown, kein Codeblock, kein Fliesstext davor/danach): {"fieldMapping":[{"column":"...","field":"...","confidence":"high|medium|low","confidencePercent":0,"alternativeField":"...","note":"...","dataType":"text|integer|real|date|bool","fieldDataType":"...","mapped":true}],"unmapped":["..."],"relationships":[{"column":"...","targetDatabase":"...","status":"found|requires_preparation","note":"..."}],"testData":[{"database":"...","fields":{...}}],"warnings":["..."]}',
    columns: sheet.columns,
    sampleRows,
    database: { tableRef: table.tableRef, name: table.name || table.nameDe || table.nameEn },
  });
  const step2Details = `Excel-Mapping Schritt 2: Feld-Zuordnung (${table.fields.length} Felder, als Datei referenziert)`;
  const step2 = await chatWithAgentSync(agentId, step2Message, 'excel-mapping', model, step2Details, undefined, fieldAttachments);
  const parsed = extractJson(step2.response) as Partial<DataImportMappingResult> & { _warnings?: string[] };
  const matchedCandidate = databaseCandidates.find((c) => c.tableRef === table.tableRef);

  return {
    mode: 'ai',
    database: { tableRef: table.tableRef, name: table.name || table.nameDe || table.nameEn || table.tableRef, confidence: matchedCandidate?.confidence ?? 'medium', confidencePercent: matchedCandidate?.confidencePercent ?? null },
    databaseCandidates,
    fieldMapping: (parsed.fieldMapping ?? []).map((fieldMapping) => {
      const field = findFieldByTechnicalName(table, fieldMapping.field);
      return {
        ...fieldMapping,
        field: field?.name ?? fieldMapping.field,
        source: 'ai',
        aiField: field?.name ?? fieldMapping.field,
        aiConfidence: fieldMapping.confidence ?? null,
        aiConfidencePercent: fieldMapping.confidencePercent ?? null,
        aiAlternativeField: fieldMapping.alternativeField ?? null,
        confidence: fieldMapping.confidence ?? null,
        confidencePercent: fieldMapping.confidencePercent ?? null,
        fieldDataType: field?.dataType ?? null,
      };
    }),
    unmapped: parsed.unmapped ?? [],
    relationships: parsed.relationships ?? [],
    testData: parsed.testData ?? [],
    warnings: parsed.warnings ?? parsed._warnings ?? [],
  };
}

/**
 * Matches sheet columns onto known abas databases/fields and drafts JSON test-data payloads.
 *
 * Runs as TWO calls to keep each request small (sending every database's full
 * field list in one shot caused oversized requests / ERR_CONNECTION_RESET):
 *   1. Identify the best-matching database from NAMES ONLY (tiny payload).
 *   2. Map fields + relationships + test-data — the identified database's field
 *      list is uploaded once and referenced as a file attachment (cached per
 *      workspace/tenant via ensureWorkspaceFileUpload), not re-sent as text.
 */
export async function mapSheetWithAgent(
  sheet: ExcelSheet,
  knownTables: TableDef[],
  rootHandle: FileSystemDirectoryHandle | null = null,
): Promise<DataImportMappingResult> {
  const agentId = getStoredAgentId('excel-mapping');
  const model = getTaskModel('excel-mapping');
  const sampleRows = sheet.rows.slice(0, 10);

  const databaseNames = knownTables
    .filter((t) => t.kind === 'database')
    .map((t) => ({ tableRef: t.tableRef, name: t.name || t.nameDe || t.nameEn }));

  const step1Message = JSON.stringify({
    task: 'identify-database',
    instruction: 'WICHTIG: Ignoriere fuer diese Anfrage jegliche abweichenden Formatvorgaben aus deinen sonst hinterlegten Instructions und folge AUSSCHLIESSLICH diesem Schema. Bestimme anhand der Spaltenueberschriften und Beispielzeilen, welche der folgenden abas-Datenbanken zur Tabelle passen koennten (bis zu 3 Kandidaten, absteigend nach Konfidenz sortiert, beste Vermutung zuerst). Gib fuer jeden Kandidaten confidence (high|medium|low) und confidencePercent (0-100) an. Antworte NUR mit reinem JSON (kein Markdown, kein Codeblock, kein Fliesstext davor/danach): {"candidates":[{"tableRef":"...","name":"...","confidence":"high|medium|low","confidencePercent":0}]} oder {"candidates":[],"reason":"..."} wenn keine passt.',
    columns: sheet.columns,
    sampleRows,
    databases: databaseNames,
  });
  const step1Details = `Excel-Mapping Schritt 1: Datenbank-Erkennung (${databaseNames.length} Kandidaten)`;
  const step1 = await chatWithAgentSync(agentId, step1Message, 'excel-mapping', model, step1Details);
  const step1Parsed = extractJson(step1.response) as { candidates?: DataImportDatabaseCandidate[]; reason?: string };
  const candidates = (step1Parsed.candidates ?? [])
    .filter((c) => knownTables.some((t) => t.tableRef === c.tableRef))
    .map((candidate) => ({ ...candidate, confidencePercent: candidate.confidencePercent ?? null }));
  const topCandidate = candidates[0];

  const matchedTable = topCandidate ? knownTables.find((t) => t.tableRef === topCandidate.tableRef) : undefined;
  if (!matchedTable) {
    return {
      mode: 'ai',
      database: null,
      databaseCandidates: candidates,
      fieldMapping: sheet.columns.map((c) => ({ column: c, field: null, source: 'manual', aiField: null, aiConfidence: null, aiConfidencePercent: null, aiAlternativeField: null, confidence: null, confidencePercent: null, dataType: null, fieldDataType: null, mapped: false })),
      unmapped: [...sheet.columns],
      relationships: [],
      testData: [],
      warnings: [step1Parsed.reason ?? 'Keine passende Datenbank gefunden.'],
    };
  }

  return mapFieldsForDatabase(sheet, matchedTable, candidates, rootHandle);
}

