/**
 * @module DataImportTab
 * Excel/CSV data-import workspace: consultants upload customer spreadsheets
 * (master/transactional data), optionally transform them via natural-language
 * instructions (Excel-Transform-Agent, batched for large sheets), and map
 * columns onto abas databases/fields with JSON test-data drafts
 * (Excel-Mapping-Agent). History keeps the current version + one backup per
 * import (see lib/dataImportStore.ts).
 */
import { useState, useRef, useEffect, useCallback } from 'react';
import type { FeatureInput, TableDef } from '../../types/gherkin';
import type { DataImportRecord, DataImportMappingResult, ImportItFieldOption, ImportItImportOption, MappingConfidence, MappingSource } from '../../types/dataImport';
import type { ExcelSheet } from '../../lib/excelParser';
import {
  readManifest, createDataImport, updateDataImportOriginal, restoreDataImportBackup, deleteDataImport,
  readOriginalSheets, readTransformedSheets, saveTransformedSheets, readMapping, saveMapping,
} from '../../lib/dataImportStore';
import { generateCucumberTestsFromDataImport, transformSheetWithAgent, mapSheetWithAgent, mapFieldsForDatabase } from '../../lib/excelAgent';
import {
  DEFAULT_IMPORT_IT_SETTINGS,
  IMPORT_IT_FIELD_OPTIONS,
  IMPORT_IT_IMPORT_OPTIONS,
  buildImportItWorkbook,
  downloadImportItWorkbook,
  formatImportItDatabaseRef,
  getExportableMappings,
  resolveImportItOptionCode,
} from '../../lib/importItExport';
import { parseGherkin } from '../../lib/gherkinParser';
import { useTranslation } from '../../i18n';
import { IconImport, IconUndo } from '../icons';
import styles from './DataImportTab.module.css';

interface DataImportTabProps {
  rootHandle: FileSystemDirectoryHandle | null;
  tableDefs: TableDef[];
  onFeatureGenerated: (feature: FeatureInput) => void;
}

const FREE_TEXT_FIELD = '__freitext__';

const IMPORT_IT_OPTION_LABEL_KEYS: Record<ImportItImportOption, 'dataimport.importItOptionCreateNew' | 'dataimport.importItOptionDisableFop' | 'dataimport.importItOptionClearTable' | 'dataimport.importItOptionCheckModifiable' | 'dataimport.importItOptionEnglishVariables' | 'dataimport.importItOptionDontChangeIfEqual' | 'dataimport.importItOptionCheckForbiddenChars'> = {
  createNew: 'dataimport.importItOptionCreateNew',
  disableFop: 'dataimport.importItOptionDisableFop',
  clearTable: 'dataimport.importItOptionClearTable',
  checkModifiable: 'dataimport.importItOptionCheckModifiable',
  englishVariables: 'dataimport.importItOptionEnglishVariables',
  dontChangeIfEqual: 'dataimport.importItOptionDontChangeIfEqual',
  checkForbiddenChars: 'dataimport.importItOptionCheckForbiddenChars',
};

type PickerGroup = 'action' | 'ai' | 'standard';

interface PickerChip {
  label: string;
  tone: 'confidence' | 'type' | 'sourceAi' | 'sourceStandard' | 'sourceManual';
}

interface PickerOption {
  value: string;
  label: string;
  detail?: string;
  chips?: PickerChip[];
  group: PickerGroup;
}

function tableLabel(table: TableDef): string {
  const name = table.nameDe || table.name || table.nameEn || table.tableRef;
  return `${name} (${table.tableRef})`;
}

function fieldLabel(field: TableDef['fields'][number]): string {
  const description = fieldDescription(field);
  return description ? `${field.name} — ${description}` : field.name;
}

function fieldDescription(field: TableDef['fields'][number]): string {
  return field.descriptionDe || field.description || field.descriptionEn || '';
}

function findFieldByTechnicalName(table: TableDef | undefined, technicalName: string | null | undefined) {
  if (!table || !technicalName) return undefined;
  const normalizedName = technicalName.trim().toLocaleLowerCase();
  return table.fields.find((field) => field.name.trim().toLocaleLowerCase() === normalizedName);
}

function mergeTransformedSheets(originalSheets: ExcelSheet[], transformedSheets: ExcelSheet[]): ExcelSheet[] {
  const transformedByName = new Map(transformedSheets.map((sheet) => [sheet.name, sheet]));
  return originalSheets.map((originalSheet) => transformedByName.get(originalSheet.name) ?? originalSheet);
}

/** Applies the mapping order to the preview columns; columns missing from the order keep their position at the end. */
function orderColumns(columns: string[], columnOrder?: string[]): string[] {
  if (!columnOrder || columnOrder.length === 0) return columns;
  const ordered = columnOrder.filter((column) => columns.includes(column));
  return [...ordered, ...columns.filter((column) => !ordered.includes(column))];
}

function sourceChip(source: MappingSource, lang: 'de' | 'en'): PickerChip {
  if (source === 'ai') return { label: 'KI', tone: 'sourceAi' };
  if (source === 'standard') return { label: lang === 'de' ? 'abas-Standardfeld' : 'abas standard field', tone: 'sourceStandard' };
  return { label: lang === 'de' ? 'Manuell' : 'Manual', tone: 'sourceManual' };
}

function chipClassName(tone: PickerChip['tone']): string {
  if (tone === 'type') return styles.pickerTypeChip;
  if (tone === 'sourceAi') return styles.pickerSourceAiChip;
  if (tone === 'sourceStandard') return styles.pickerSourceStandardChip;
  if (tone === 'sourceManual') return styles.pickerSourceManualChip;
  return styles.pickerChip;
}

function SearchablePicker({ displayValue, options, placeholder, onSelect, disabled, className, allowFreeText = false }: {
  displayValue: string;
  options: PickerOption[];
  placeholder: string;
  onSelect: (value: string) => void;
  disabled?: boolean;
  className?: string;
  allowFreeText?: boolean;
}) {
  const [query, setQuery] = useState(displayValue);
  const [isOpen, setIsOpen] = useState(false);
  const committedFromOption = useRef(false);
  useEffect(() => { setQuery(displayValue); }, [displayValue]);

  const normalizedQuery = query.trim().toLocaleLowerCase();
  const exactTechnicalMatch = normalizedQuery
    ? options.find((option) => option.value.trim().toLocaleLowerCase() === normalizedQuery)
    : undefined;
  const matchingOptions = exactTechnicalMatch
    ? [exactTechnicalMatch]
    : options.filter((option) =>
      `${option.label} ${option.detail ?? ''} ${option.value}`.toLocaleLowerCase().includes(normalizedQuery),
    );
  const actionOptions = matchingOptions.filter((option) => option.group === 'action');
  const aiOptions = matchingOptions.filter((option) => option.group === 'ai');
  const standardOptions = matchingOptions.filter((option) => option.group === 'standard');
  const renderOptions = (items: PickerOption[]) => items.map((option) => (
    <button
      key={`${option.group}-${option.value}`}
      className={option.group === 'ai' ? styles.pickerOptionAi : styles.pickerOption}
      type="button"
      onMouseDown={(event) => {
        event.preventDefault();
        committedFromOption.current = true;
        setQuery(option.value);
        setIsOpen(false);
        onSelect(option.value);
      }}
    >
      <span className={styles.pickerOptionContent}>
        <span>{option.label}</span>
        {option.detail && <small>{option.detail}</small>}
      </span>
      {option.chips && (
        <span className={styles.pickerChips}>
          {option.chips.map((chip) => (
            <span key={`${chip.tone}-${chip.label}`} className={chipClassName(chip.tone)}>{chip.label}</span>
          ))}
        </span>
      )}
    </button>
  ));

  return (
    <div className={`${styles.picker} ${className ?? ''}`}>
      <input
        className={styles.pickerInput}
        type="search"
        value={query}
        placeholder={placeholder}
        onFocus={() => setIsOpen(true)}
        onChange={(event) => { setQuery(event.target.value); setIsOpen(true); }}
        onKeyDown={(event) => {
          if (event.key !== 'Enter' || !allowFreeText || !query.trim()) return;
          event.preventDefault();
          setIsOpen(false);
          onSelect(query.trim());
        }}
        onBlur={() => {
          setIsOpen(false);
          if (committedFromOption.current) {
            committedFromOption.current = false;
            return;
          }
          if (allowFreeText && query.trim()) onSelect(query.trim());
        }}
        disabled={disabled}
        aria-expanded={isOpen}
      />
      {isOpen && (
        <div className={styles.pickerMenu}>
          {actionOptions.length > 0 && renderOptions(actionOptions)}
          {actionOptions.length > 0 && (aiOptions.length > 0 || standardOptions.length > 0) && <div className={styles.pickerDivider} />}
          {aiOptions.length > 0 && <div className={styles.pickerGroupLabel}>KI-Vorschläge</div>}
          {renderOptions(aiOptions)}
          {aiOptions.length > 0 && standardOptions.length > 0 && <div className={styles.pickerDivider} />}
          {standardOptions.length > 0 && <div className={styles.pickerGroupLabel}>abas-Daten</div>}
          {renderOptions(standardOptions)}
          {matchingOptions.length === 0 && <div className={styles.pickerEmpty}>Keine Treffer</div>}
        </div>
      )}
    </div>
  );
}

function ConfidenceBadge({ confidence, percent }: { confidence: MappingConfidence | null | undefined; percent: number | null | undefined }) {
  if (!confidence) return null;
  return <span className={styles[`confidence_${confidence}`]}>{percent === null || percent === undefined ? confidence : `${confidence} ${percent}%`}</span>;
}

function SheetTable({
  sheet,
  originalSheet,
  editable = false,
  onCellChange,
  columnOrder,
  maxRows = 50,
}: {
  sheet: ExcelSheet;
  originalSheet?: ExcelSheet;
  editable?: boolean;
  onCellChange?: (rowIndex: number, column: string, value: string) => void;
  columnOrder?: string[];
  maxRows?: number;
}) {
  const { t } = useTranslation();
  const [columnFilters, setColumnFilters] = useState<Record<string, string>>({});
  const columns = orderColumns(sheet.columns, columnOrder);
  const rows = sheet.rows
    .map((row, rowIndex) => ({ row, rowIndex }))
    .filter(({ row }) => columns.every((column) => {
      const filter = columnFilters[column]?.trim().toLocaleLowerCase();
      return !filter || String(row[column] ?? '').toLocaleLowerCase().includes(filter);
    }))
    .slice(0, maxRows);
  return (
    <div className={styles.tableScroll}>
      <table className={styles.table}>
        <thead>
          <tr>{columns.map((c) => <th key={c}>{c}</th>)}</tr>
          <tr className={styles.columnFilters}>
            {columns.map((column) => (
              <th key={column}>
                <input
                  className={styles.columnFilterInput}
                  value={columnFilters[column] ?? ''}
                  onChange={(event) => setColumnFilters((filters) => ({ ...filters, [column]: event.target.value }))}
                  placeholder={t('dataimport.searchColumn')}
                  aria-label={`${column}: ${t('dataimport.searchColumn')}`}
                />
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map(({ row, rowIndex }) => (
            <tr key={rowIndex}>
              {columns.map((c) => {
                const value = String(row[c] ?? '');
                const originalValue = String(originalSheet?.rows[rowIndex]?.[c] ?? '');
                const changed = editable && value !== originalValue;
                return (
                  <td key={c} className={changed ? styles.changedCell : undefined} title={changed ? `${originalSheet?.name ?? 'Original'}: ${originalValue || '—'}` : undefined}>
                    {editable
                      ? <input className={styles.cellInput} value={value} onChange={(event) => onCellChange?.(rowIndex, c, event.target.value)} />
                      : value}
                  </td>
                );
              })}
            </tr>
          ))}
        </tbody>
      </table>
      {rows.length === 0 && <p className={styles.hint}>{t('dataimport.noMatchingRows')}</p>}
      {sheet.rows.length > maxRows && (
        <p className={styles.hint}>
          {sheet.rows.length - maxRows} weitere Zeilen ausgeblendet (Vorschau auf {maxRows} begrenzt).
        </p>
      )}
    </div>
  );
}

export function DataImportTab({ rootHandle, tableDefs, onFeatureGenerated }: DataImportTabProps) {
  const { lang, t } = useTranslation();
  const [imports, setImports] = useState<DataImportRecord[]>([]);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [originalSheets, setOriginalSheets] = useState<ExcelSheet[]>([]);
  const [transformedSheets, setTransformedSheets] = useState<ExcelSheet[] | null>(null);
  const [mapping, setMapping] = useState<DataImportMappingResult | null>(null);
  const [activeSheetIdx, setActiveSheetIdx] = useState(0);
  const [viewMode, setViewMode] = useState<'original' | 'transformed'>('original');
  const [mappingTab, setMappingTab] = useState<'mapping' | 'structural' | 'content'>('mapping');
  const [applyAiMappingsDirectly, setApplyAiMappingsDirectly] = useState(false);
  const [previousTransformedSheets, setPreviousTransformedSheets] = useState<ExcelSheet[] | null>(null);
  const [draggedColumn, setDraggedColumn] = useState<string | null>(null);
  const [instruction, setInstruction] = useState('');
  const [busy, setBusy] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const replaceInputRef = useRef<HTMLInputElement>(null);
  const instructionRef = useRef<HTMLTextAreaElement>(null);

  const selected = imports.find((i) => i.id === selectedId) ?? null;
  const completeTransformedSheets = transformedSheets ? mergeTransformedSheets(originalSheets, transformedSheets) : null;
  const displaySheets = viewMode === 'transformed' ? (completeTransformedSheets ?? originalSheets) : originalSheets;
  const activeSheet = displaySheets[activeSheetIdx];

  const createManualMapping = (sheet: ExcelSheet): DataImportMappingResult => ({
    mode: 'manual',
    database: null,
    databaseCandidates: [],
    fieldMapping: sheet.columns.map((column) => ({
      column,
      field: null,
      source: 'manual',
      confidence: null,
      confidencePercent: null,
      dataType: null,
      fieldDataType: null,
      mapped: false,
    })),
    unmapped: [...sheet.columns],
    relationships: [],
    testData: [],
    cleanupInstruction: '',
    structuralHints: [],
    contentHints: [],
    warnings: [],
    importIt: { ...DEFAULT_IMPORT_IT_SETTINGS },
  });

  const applyAbasFieldTypes = (result: DataImportMappingResult | null): DataImportMappingResult | null => {
    if (!result?.database) return result;
    const table = tableDefs.find((entry) => entry.tableRef === result.database?.tableRef);
    if (!table) return result;
    return {
      ...result,
      fieldMapping: result.fieldMapping.map((fieldMapping) => ({
        ...fieldMapping,
        fieldDataType: findFieldByTechnicalName(table, fieldMapping.field)?.dataType ?? null,
      })),
    };
  };

  const reloadManifest = useCallback(async () => {
    if (!rootHandle) return;
    const manifest = await readManifest(rootHandle);
    setImports(manifest.imports);
  }, [rootHandle]);

  useEffect(() => { void reloadManifest(); }, [reloadManifest]);

  const loadSelected = useCallback(async (record: DataImportRecord) => {
    if (!rootHandle) return;
    setError(null);
    const [original, transformed] = await Promise.all([
      readOriginalSheets(rootHandle, record.id, record.current.version),
      readTransformedSheets(rootHandle, record.id, record.current.version),
    ]);
    const firstSheet = (transformed ?? original)[0];
    const savedMapping = firstSheet
      ? await readMapping(rootHandle, record.id, record.current.version, firstSheet.name)
      : null;
    const mappingResult = savedMapping ?? (firstSheet ? createManualMapping(firstSheet) : null);
    if (!savedMapping && firstSheet && mappingResult) {
      await saveMapping(rootHandle, record.id, record.current.version, firstSheet.name, mappingResult);
    }
    setOriginalSheets(original);
    setTransformedSheets(transformed ? mergeTransformedSheets(original, transformed) : null);
    setPreviousTransformedSheets(null);
    setMapping(applyAbasFieldTypes(mappingResult));
    setActiveSheetIdx(0);
    setViewMode(transformed ? 'transformed' : 'original');
    setInstruction(record.current.transformInstruction ?? '');
  }, [rootHandle]);

  const handleSelect = (record: DataImportRecord) => {
    setSelectedId(record.id);
    void loadSelected(record);
  };

  const handleSelectSheet = async (index: number) => {
    if (!rootHandle || !selected) return;
    const sheet = displaySheets[index];
    setActiveSheetIdx(index);
    const savedMapping = sheet ? await readMapping(rootHandle, selected.id, selected.current.version, sheet.name) : null;
    const mappingResult = savedMapping ?? (sheet ? createManualMapping(sheet) : null);
    if (!savedMapping && sheet && mappingResult) {
      await saveMapping(rootHandle, selected.id, selected.current.version, sheet.name, mappingResult);
    }
    setMapping(applyAbasFieldTypes(mappingResult));
  };

  const handleSetViewMode = async (mode: 'original' | 'transformed') => {
    if (!rootHandle || !selected) return;
    const workingSheets = mode === 'transformed' && !completeTransformedSheets
      ? originalSheets.map((sheet) => ({ ...sheet, rows: sheet.rows.map((row) => ({ ...row })) }))
      : completeTransformedSheets;
    if (mode === 'transformed' && workingSheets && !completeTransformedSheets) {
      setTransformedSheets(workingSheets);
    }
    const sheets = mode === 'transformed' ? (workingSheets ?? originalSheets) : originalSheets;
    const sheet = sheets[activeSheetIdx];
    setViewMode(mode);
    const savedMapping = sheet ? await readMapping(rootHandle, selected.id, selected.current.version, sheet.name) : null;
    const mappingResult = savedMapping ?? (sheet ? createManualMapping(sheet) : null);
    if (!savedMapping && sheet && mappingResult) {
      await saveMapping(rootHandle, selected.id, selected.current.version, sheet.name, mappingResult);
    }
    setMapping(applyAbasFieldTypes(mappingResult));
  };

  const handleUpload = async (file: File) => {
    if (!rootHandle) return;
    setBusy(lang === 'de' ? 'Importiere…' : 'Importing…');
    setError(null);
    try {
      const { record } = await createDataImport(rootHandle, file, file.name.replace(/\.(xlsx|xls|csv)$/i, ''));
      await reloadManifest();
      setSelectedId(record.id);
      await loadSelected(record);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(null);
    }
  };

  const handleReplace = async (file: File) => {
    if (!rootHandle || !selected) return;
    setBusy(lang === 'de' ? 'Aktualisiere…' : 'Updating…');
    setError(null);
    try {
      const { record } = await updateDataImportOriginal(rootHandle, selected.id, file);
      await reloadManifest();
      await loadSelected(record);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(null);
    }
  };

  const handleRestoreBackup = async () => {
    if (!rootHandle || !selected) return;
    setBusy(lang === 'de' ? 'Stelle Backup wieder her…' : 'Restoring backup…');
    try {
      const record = await restoreDataImportBackup(rootHandle, selected.id);
      await reloadManifest();
      await loadSelected(record);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(null);
    }
  };

  const handleDelete = async () => {
    if (!rootHandle || !selected) return;
    await deleteDataImport(rootHandle, selected.id);
    setSelectedId(null);
    setOriginalSheets([]);
    setTransformedSheets(null);
    setPreviousTransformedSheets(null);
    setMapping(null);
    await reloadManifest();
  };

  const handleTransform = async () => {
    if (!rootHandle || !selected || !instruction.trim()) return;
    const sheet = originalSheets[activeSheetIdx];
    if (!sheet) return;
    setBusy(lang === 'de' ? 'Transformiere…' : 'Transforming…');
    setError(null);
    try {
      const { sheet: transformed, warnings } = await transformSheetWithAgent(sheet, instruction.trim(), (p) => {
        setBusy(`${lang === 'de' ? 'Transformiere Batch' : 'Transforming batch'} ${p.batchIndex}/${p.batchCount}…`);
      });
      const nextTransformed = (completeTransformedSheets ?? originalSheets).map((entry, index) => index === activeSheetIdx ? transformed : entry);
      setPreviousTransformedSheets((completeTransformedSheets ?? originalSheets).map((entry) => ({ ...entry, rows: entry.rows.map((row) => ({ ...row })) })));
      await saveTransformedSheets(rootHandle, selected.id, selected.current.version, nextTransformed, '');
      setTransformedSheets(nextTransformed);
      setViewMode('transformed');
      setInstruction('');
      setBusy(lang === 'de' ? 'Ermittle aktuelle Hinweise…' : 'Refreshing current hints…');
      const refreshedMapping = await mapSheetWithAgent(transformed, tableDefs, rootHandle);
      const mappingToSave = applyAiMappingsDirectly
        ? {
          ...refreshedMapping,
          fieldMapping: refreshedMapping.fieldMapping.map((fieldMapping) => fieldMapping.aiField
            ? {
              ...fieldMapping,
              field: fieldMapping.aiField,
              source: 'ai' as const,
              confidence: fieldMapping.aiConfidence ?? null,
              confidencePercent: fieldMapping.aiConfidencePercent ?? null,
              mapped: true,
            }
            : fieldMapping),
          unmapped: refreshedMapping.fieldMapping.filter((fieldMapping) => !fieldMapping.aiField).map((fieldMapping) => fieldMapping.column),
        }
        : refreshedMapping;
      setMapping(mappingToSave);
      await saveMapping(rootHandle, selected.id, selected.current.version, sheet.name, mappingToSave);
      if (warnings.length > 0) setError(warnings.join(' | '));
      await reloadManifest();
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(null);
    }
  };

  const handleTransformedCellChange = (rowIndex: number, column: string, value: string) => {
    const workingCopy = (completeTransformedSheets ?? originalSheets).map((sheet) => ({
      ...sheet,
      rows: sheet.rows.map((row) => ({ ...row })),
    }));
    const row = workingCopy[activeSheetIdx]?.rows[rowIndex];
    if (!row) return;
    setPreviousTransformedSheets(null);
    row[column] = value;
    setTransformedSheets(workingCopy);
    if (rootHandle && selected) {
      void saveTransformedSheets(rootHandle, selected.id, selected.current.version, workingCopy, instruction.trim());
    }
  };

  const handleUndoTransformation = async () => {
    if (!rootHandle || !selected || !previousTransformedSheets) return;
    setBusy(lang === 'de' ? 'Stelle vorherigen Stand wieder her…' : 'Restoring previous state…');
    setError(null);
    try {
      await saveTransformedSheets(rootHandle, selected.id, selected.current.version, previousTransformedSheets, instruction.trim());
      setTransformedSheets(previousTransformedSheets);
      setPreviousTransformedSheets(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(null);
    }
  };

  const handleMap = async () => {
    if (!rootHandle || !selected || !activeSheet) return;
    setBusy(lang === 'de' ? 'Ermittle Zuordnung…' : 'Determining mapping…');
    setError(null);
    try {
      const result = await mapSheetWithAgent(activeSheet, tableDefs, rootHandle);
      const resultToSave = applyAiMappingsDirectly
        ? {
          ...result,
          fieldMapping: result.fieldMapping.map((fieldMapping) => fieldMapping.aiField
            ? {
              ...fieldMapping,
              field: fieldMapping.aiField,
              source: 'ai' as const,
              confidence: fieldMapping.aiConfidence ?? null,
              confidencePercent: fieldMapping.aiConfidencePercent ?? null,
              mapped: true,
            }
            : fieldMapping),
          unmapped: result.fieldMapping.filter((fieldMapping) => !fieldMapping.aiField).map((fieldMapping) => fieldMapping.column),
        }
        : result;
      await saveMapping(rootHandle, selected.id, selected.current.version, activeSheet.name, resultToSave);
      setMapping(resultToSave);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(null);
    }
  };

  const handleGenerateTests = async (scope: 'all' | 'active') => {
    if (!rootHandle || !selected) return;
    const workbookSheets = completeTransformedSheets ?? originalSheets;
    const sheets = scope === 'active' && activeSheet ? [activeSheet] : workbookSheets;
    if (sheets.length === 0) return;
    setBusy(lang === 'de'
      ? `Generiere Cucumber-Tests${scope === 'active' ? ` für ${activeSheet?.name ?? ''}` : ''}…`
      : `Generating Cucumber tests${scope === 'active' ? ` for ${activeSheet?.name ?? ''}` : ''}…`);
    setError(null);
    try {
      const contexts = await Promise.all(sheets.map(async (sheet) => ({
        sheetName: sheet.name,
        mapping: await readMapping(rootHandle, selected.id, selected.current.version, sheet.name),
      })));
      if (!contexts.some((context) => context.mapping?.database && context.mapping.fieldMapping.some((field) => field.field))) {
        throw new Error(lang === 'de' ? 'Bitte zuerst mindestens eine Datenbank- und Feld-Zuordnung anlegen.' : 'Please create at least one database and field mapping first.');
      }
      const gherkin = await generateCucumberTestsFromDataImport(selected.name, sheets, contexts);
      const feature = parseGherkin(gherkin, { fromAI: true });
      if (!feature.name || feature.scenarios.length === 0) {
        throw new Error(lang === 'de' ? 'Die KI-Antwort enthielt keine verwertbare Feature-Datei.' : 'The AI response did not contain a usable feature file.');
      }
      onFeatureGenerated(feature);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(null);
    }
  };

  const handleSelectDatabase = async (tableRef: string) => {
    if (!rootHandle || !selected || !mapping || !activeSheet) return;
    const table = tableDefs.find((t) => t.tableRef === tableRef);
    if (!table) return;
    const databaseCandidate = mapping.databaseCandidates.find((candidate) => candidate.tableRef === tableRef);
    const updatedMapping: DataImportMappingResult = {
      ...mapping,
      database: {
        tableRef: table.tableRef,
        name: table.nameDe || table.name || table.nameEn || table.tableRef,
        confidence: databaseCandidate?.confidence ?? 'medium',
        confidencePercent: databaseCandidate?.confidencePercent ?? null,
      },
      fieldMapping: activeSheet.columns.map((column) => {
        const existing = mapping.fieldMapping.find((fieldMapping) => fieldMapping.column === column);
        return {
          column,
          field: null,
          source: 'manual',
          confidence: null,
          confidencePercent: null,
          dataType: existing?.dataType ?? null,
          fieldDataType: null,
          mapped: false,
        };
      }),
      unmapped: [...activeSheet.columns],
      relationships: [],
      testData: [],
      warnings: [],
    };
    setMapping(updatedMapping);
    if (mapping.mode === 'manual') {
      await saveMapping(rootHandle, selected.id, selected.current.version, activeSheet.name, updatedMapping);
      return;
    }
    setBusy(lang === 'de' ? 'Ermittle Feld-Zuordnung…' : 'Determining field mapping…');
    setError(null);
    try {
      const result = await mapFieldsForDatabase(activeSheet, table, mapping.databaseCandidates, rootHandle);
      await saveMapping(rootHandle, selected.id, selected.current.version, activeSheet.name, result);
      setMapping(result);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(null);
    }
  };

  const handleSelectField = async (column: string, field: string) => {
    if (!rootHandle || !selected || !mapping || !activeSheet) return;
    const resolvedField = field === FREE_TEXT_FIELD ? (window.prompt(lang === 'de' ? 'Freitext-Feldname eingeben:' : 'Enter free-text field name:') ?? '').trim() : field;
    if (!resolvedField) return;
    const selectedTable = tableDefs.find((table) => table.tableRef === mapping.database?.tableRef);
    const selectedField = findFieldByTechnicalName(selectedTable, resolvedField);
    const updated: DataImportMappingResult = {
      ...mapping,
      fieldMapping: mapping.fieldMapping.map((m) => {
        if (m.column !== column) return m;
        const keepsAiPrediction = !!m.aiField && m.aiField.trim().toLocaleLowerCase() === resolvedField.toLocaleLowerCase();
        return {
          ...m,
          field: selectedField?.name ?? resolvedField,
          fieldDataType: selectedField?.dataType ?? null,
          mapped: true,
          source: keepsAiPrediction ? 'ai' : (selectedField ? 'standard' : 'manual'),
          confidence: keepsAiPrediction ? m.aiConfidence ?? null : null,
          confidencePercent: keepsAiPrediction ? m.aiConfidencePercent ?? null : null,
        };
      }),
      unmapped: mapping.unmapped.filter((c) => c !== column),
    };
    setMapping(updated);
    await saveMapping(rootHandle, selected.id, selected.current.version, activeSheet.name, updated);
  };

  const persistMapping = async (updated: DataImportMappingResult) => {
    if (!rootHandle || !selected || !activeSheet) return;
    setMapping(updated);
    await saveMapping(rootHandle, selected.id, selected.current.version, activeSheet.name, updated);
  };

  const appendInstruction = (text: string) => {
    const addition = text.trim();
    if (!addition) return;
    setInstruction((current) => (current.trim() ? `${current.trim()}\n${addition}` : addition));
    instructionRef.current?.focus();
    instructionRef.current?.scrollIntoView({ block: 'nearest' });
  };

  const handleAddColumn = async () => {
    if (!rootHandle || !selected || !activeSheet) return;
    const name = (window.prompt(t('dataimport.addColumnPrompt')) ?? '').trim();
    if (!name) return;
    if (activeSheet.columns.includes(name)) {
      setError(t('dataimport.columnExists'));
      return;
    }
    setError(null);
    const workingCopy = (completeTransformedSheets ?? originalSheets).map((sheet, index) => (
      index === activeSheetIdx
        ? { ...sheet, columns: [...sheet.columns, name], rows: sheet.rows.map((row) => ({ ...row, [name]: '' })) }
        : { ...sheet, rows: sheet.rows.map((row) => ({ ...row })) }
    ));
    setTransformedSheets(workingCopy);
    setPreviousTransformedSheets(null);
    setViewMode('transformed');
    await saveTransformedSheets(rootHandle, selected.id, selected.current.version, workingCopy, instruction.trim());
    if (mapping) {
      await persistMapping({
        ...mapping,
        fieldMapping: [...mapping.fieldMapping, {
          column: name,
          field: null,
          source: 'manual',
          confidence: null,
          confidencePercent: null,
          dataType: null,
          fieldDataType: null,
          mapped: false,
          importItOptions: [],
        }],
        unmapped: [...mapping.unmapped, name],
      });
    }
  };

  const handleReorderField = async (fromColumn: string, toColumn: string) => {    if (!mapping || fromColumn === toColumn) return;
    const reordered = [...mapping.fieldMapping];
    const fromIndex = reordered.findIndex((entry) => entry.column === fromColumn);
    const toIndex = reordered.findIndex((entry) => entry.column === toColumn);
    if (fromIndex < 0 || toIndex < 0) return;
    const [moved] = reordered.splice(fromIndex, 1);
    reordered.splice(toIndex, 0, moved);
    await persistMapping({ ...mapping, fieldMapping: reordered });
  };

  const handleToggleFieldOption = async (column: string, option: ImportItFieldOption) => {
    if (!mapping) return;
    await persistMapping({
      ...mapping,
      fieldMapping: mapping.fieldMapping.map((entry) => {
        if (entry.column !== column) return entry;
        const current = entry.importItOptions ?? [];
        return {
          ...entry,
          importItOptions: current.includes(option)
            ? current.filter((existing) => existing !== option)
            : [...current, option],
        };
      }),
    });
  };

  const handleImportItSettingChange = async (patch: Partial<DataImportMappingResult['importIt']>) => {
    if (!mapping) return;
    await persistMapping({ ...mapping, importIt: { ...mapping.importIt, ...patch } });
  };

  const handleToggleImportItOption = async (option: ImportItImportOption) => {
    if (!mapping) return;
    const current = mapping.importIt.options;
    await handleImportItSettingChange({
      options: current.includes(option) ? current.filter((entry) => entry !== option) : [...current, option],
    });
  };

  const handleExportImportIt = () => {
    if (!mapping || !activeSheet) return;
    if (!mapping.database) {
      setError(t('dataimport.importItNeedsDatabase'));
      return;
    }
    if (getExportableMappings(mapping.fieldMapping).length === 0) {
      setError(t('dataimport.importItNeedsFields'));
      return;
    }
    setError(null);
    const workbook = buildImportItWorkbook(activeSheet, mapping.fieldMapping, mapping.importIt, mapping.database.tableRef);
    const databaseRef = formatImportItDatabaseRef(mapping.database.tableRef).replace(':', '-');
    downloadImportItWorkbook(workbook, `ImportIT_${databaseRef}_${activeSheet.name}`);
  };

  const handleRestoreAiField = async (column: string) => {
    if (!rootHandle || !selected || !mapping || !activeSheet) return;
    const selectedTable = tableDefs.find((table) => table.tableRef === mapping.database?.tableRef);
    const updated: DataImportMappingResult = {
      ...mapping,
      fieldMapping: mapping.fieldMapping.map((fieldMapping) => {
        if (fieldMapping.column !== column || !fieldMapping.aiField) return fieldMapping;
        const aiField = findFieldByTechnicalName(selectedTable, fieldMapping.aiField);
        return {
          ...fieldMapping,
          field: aiField?.name ?? fieldMapping.aiField,
          fieldDataType: aiField?.dataType ?? null,
          source: 'ai',
          confidence: fieldMapping.aiConfidence ?? null,
          confidencePercent: fieldMapping.aiConfidencePercent ?? null,
          mapped: true,
        };
      }),
      unmapped: mapping.unmapped.filter((entry) => entry !== column),
    };
    setMapping(updated);
    await saveMapping(rootHandle, selected.id, selected.current.version, activeSheet.name, updated);
  };

  if (!rootHandle) {
    return (
      <div className={styles.container}>
        <p className={styles.hint}>
          {lang === 'de'
            ? 'Bitte zuerst einen Workspace-Ordner öffnen, um Excel-Importe zu verwalten.'
            : 'Please open a workspace folder first to manage Excel imports.'}
        </p>
      </div>
    );
  }

  return (
    <div className={styles.container}>
      <aside className={styles.sidebar}>
        <button className={styles.uploadBtn} onClick={() => fileInputRef.current?.click()} type="button">
          {lang === 'de' ? '+ Excel/CSV hochladen' : '+ Upload Excel/CSV'}
        </button>
        <input
          ref={fileInputRef}
          type="file"
          accept=".xlsx,.xls,.csv"
          style={{ display: 'none' }}
          onChange={(e) => { const f = e.target.files?.[0]; if (f) void handleUpload(f); e.target.value = ''; }}
        />
        <ul className={styles.list}>
          {imports.map((record) => (
            <li key={record.id}>
              <button
                className={record.id === selectedId ? styles.listItemActive : styles.listItem}
                onClick={() => handleSelect(record)}
                type="button"
              >
                <span className={styles.listItemName}>{record.name}</span>
                <span className={styles.listItemMeta}>
                  v{record.current.version}{record.backup ? ` (+backup)` : ''} · {record.current.schema.rowCount} {lang === 'de' ? 'Zeilen' : 'rows'}
                </span>
              </button>
            </li>
          ))}
          {imports.length === 0 && (
            <li className={styles.hint}>{lang === 'de' ? 'Noch keine Excel-Importe.' : 'No Excel imports yet.'}</li>
          )}
        </ul>
      </aside>

      <main className={styles.main}>
        {!selected ? (
          <p className={styles.hint}>
            {lang === 'de' ? 'Wähle links einen Import aus oder lade eine neue Datei hoch.' : 'Select an import on the left or upload a new file.'}
          </p>
        ) : (
          <>
            <div className={styles.toolbar}>
              <h3 className={styles.title}>{selected.name}</h3>
              <div className={styles.toolbarActions}>
                <button className={styles.primaryBtn} onClick={() => void handleGenerateTests('all')} disabled={!!busy} type="button">
                  {lang === 'de' ? 'Tests für alle Blätter' : 'Generate tests for all sheets'}
                </button>
                <button className={styles.secondaryBtn} onClick={() => void handleGenerateTests('active')} disabled={!!busy || !activeSheet} type="button">
                  {lang === 'de' ? 'Tests für dieses Blatt' : 'Generate tests for this sheet'}
                </button>
                <button
                  className={styles.secondaryBtn}
                  onClick={handleExportImportIt}
                  disabled={!!busy || !mapping?.database}
                  type="button"
                >
                  {t('dataimport.importItExport')}
                </button>
                <button className={styles.secondaryBtn} onClick={() => replaceInputRef.current?.click()} type="button">
                  {lang === 'de' ? 'Datei ersetzen' : 'Replace file'}
                </button>
                <input
                  ref={replaceInputRef}
                  type="file"
                  accept=".xlsx,.xls,.csv"
                  style={{ display: 'none' }}
                  onChange={(e) => { const f = e.target.files?.[0]; if (f) void handleReplace(f); e.target.value = ''; }}
                />
                {selected.backup && (
                  <button className={styles.secondaryBtn} onClick={handleRestoreBackup} type="button">
                    {lang === 'de' ? 'Backup wiederherstellen' : 'Restore backup'}
                  </button>
                )}
                <button className={styles.dangerBtn} onClick={handleDelete} type="button">
                  {lang === 'de' ? 'Löschen' : 'Delete'}
                </button>
              </div>
            </div>

            {error && <div className={styles.error}>{error}</div>}
            {busy && <div className={styles.busy}>{busy}</div>}

            {originalSheets.length > 1 && (
              <div className={styles.sheetTabs} role="tablist" aria-label={lang === 'de' ? 'Tabellenblätter' : 'Worksheets'}>
                {originalSheets.map((s, i) => (
                  <button
                    key={s.name}
                    className={i === activeSheetIdx ? styles.sheetTabActive : styles.sheetTab}
                    onClick={() => void handleSelectSheet(i)}
                    type="button"
                    role="tab"
                    aria-selected={i === activeSheetIdx}
                  >
                    {s.name}
                  </button>
                ))}
              </div>
            )}

            <div className={styles.viewToggle} role="tablist" aria-label={lang === 'de' ? 'Datenansicht' : 'Data view'}>
              <button
                className={viewMode === 'original' ? styles.viewToggleActive : styles.viewToggleBtn}
                onClick={() => void handleSetViewMode('original')}
                type="button"
                role="tab"
                aria-selected={viewMode === 'original'}
              >
                {lang === 'de' ? 'Original' : 'Original'}
              </button>
              <button
                className={viewMode === 'transformed' ? styles.viewToggleActive : styles.viewToggleBtn}
                onClick={() => void handleSetViewMode('transformed')}
                type="button"
                role="tab"
                aria-selected={viewMode === 'transformed'}
              >
                {lang === 'de' ? 'Transformiert' : 'Transformed'}
              </button>
            </div>

            {activeSheet ? (
              <>
                <div className={styles.tableToolbar}>
                  <button
                    className={styles.secondaryBtn}
                    type="button"
                    onClick={() => void handleAddColumn()}
                    disabled={!!busy}
                  >
                    + {t('dataimport.addColumn')}
                  </button>
                </div>
                <SheetTable
                  sheet={activeSheet}
                  originalSheet={originalSheets[activeSheetIdx]}
                  editable={viewMode === 'transformed'}
                  onCellChange={viewMode === 'transformed' ? handleTransformedCellChange : undefined}
                  columnOrder={mapping?.fieldMapping.map((entry) => entry.column)}
                />
              </>
            ) : <p className={styles.hint}>—</p>}

            <div className={styles.section}>
              <label className={styles.sectionLabel}>
                {lang === 'de' ? 'Transformations-Anweisung' : 'Transform instruction'}
              </label>
              <textarea
                ref={instructionRef}
                className={styles.textarea}
                value={instruction}
                onChange={(e) => setInstruction(e.target.value)}
                rows={3}
                placeholder={lang === 'de'
                  ? 'z.B. „Splitte die Spalte Adresse in Straße/PLZ/Ort" oder „Entferne Duplikate anhand Kundennummer"'
                  : 'e.g. "Split the Address column into Street/ZIP/City" or "Remove duplicates by customer number"'}
              />
              <div className={styles.transformActions}>
                <button className={styles.primaryBtn} onClick={() => void handleTransform()} disabled={!instruction.trim() || !!busy} type="button">
                  {lang === 'de' ? 'Transformieren' : 'Transform'}
                </button>
                <button
                  className={styles.restoreAiBtn}
                  type="button"
                  title={lang === 'de' ? 'Vorherigen Transformationsstand wiederherstellen' : 'Restore previous transformed state'}
                  aria-label={lang === 'de' ? 'Vorherigen Transformationsstand wiederherstellen' : 'Restore previous transformed state'}
                  onClick={() => void handleUndoTransformation()}
                  disabled={!previousTransformedSheets || !!busy}
                >
                  <IconUndo />
                </button>
              </div>
            </div>

            <div className={styles.section}>
              <div className={styles.sectionHeaderRow}>
                <label className={styles.sectionLabel}>
                  {lang === 'de' ? 'DB/Feld-Zuordnung' : 'DB/field mapping'}
                </label>
                <div className={styles.mappingActions}>
                  <label className={styles.aiMappingToggle}>
                    <input
                      type="checkbox"
                      checked={applyAiMappingsDirectly}
                      onChange={(event) => setApplyAiMappingsDirectly(event.target.checked)}
                      disabled={!!busy}
                    />
                    <span>{t('dataimport.applyAiMappingsDirectly')}</span>
                  </label>
                  <button className={styles.secondaryBtn} onClick={() => void handleMap()} disabled={!!busy} type="button">
                    {lang === 'de' ? 'KI-Zuordnung ermitteln' : 'Determine AI mapping'}
                  </button>
                </div>
              </div>
              {mapping ? (
                <div className={styles.mappingResult}>
                  <div className={styles.sheetTabs} role="tablist" aria-label={lang === 'de' ? 'Zuordnungsansichten' : 'Mapping views'}>
                    {([
                      ['mapping', t('dataimport.mappingTab')],
                      ['structural', t('dataimport.structuralHintsTab')],
                      ['content', t('dataimport.contentHintsTab')],
                    ] as const).map(([tab, label]) => {
                      const hintCount = tab === 'structural' ? mapping.structuralHints.length : tab === 'content' ? mapping.contentHints.length : 0;
                      return (
                      <button
                        key={tab}
                        className={mappingTab === tab ? styles.sheetTabActive : styles.sheetTab}
                        onClick={() => setMappingTab(tab)}
                        type="button"
                        role="tab"
                        aria-selected={mappingTab === tab}
                      >
                        {label}
                        {hintCount > 0 && <span className={styles.hintTabBadge} title={`${hintCount} ${lang === 'de' ? 'Hinweise' : 'hints'}`} aria-label={`${hintCount} ${lang === 'de' ? 'Hinweise' : 'hints'}`}>⚠ {hintCount}</span>}
                      </button>
                      );
                    })}
                  </div>
                  {mappingTab === 'mapping' && (
                    <>
                  <div className={styles.dbSelectRow}>
                    <label className={styles.sectionLabel}>{lang === 'de' ? 'Datenbank' : 'Database'}</label>
                    <SearchablePicker
                      className={styles.databasePicker}
                      displayValue={mapping.database ? tableLabel(tableDefs.find((table) => table.tableRef === mapping.database?.tableRef) ?? { ...mapping.database, database: '', group: '', fields: [], kind: 'database' }) : ''}
                      options={[
                        ...mapping.databaseCandidates.map((candidate) => {
                          const table = tableDefs.find((entry) => entry.tableRef === candidate.tableRef);
                          return {
                            value: candidate.tableRef,
                            label: table ? tableLabel(table) : `${candidate.name} (${candidate.tableRef})`,
                            detail: candidate.confidence,
                            chips: candidate.confidencePercent === null ? undefined : [{ label: `${candidate.confidencePercent}%`, tone: 'confidence' as const }],
                            group: 'ai' as const,
                          };
                        }),
                        ...tableDefs
                          .filter((table) => table.kind === 'database' && !mapping.databaseCandidates.some((candidate) => candidate.tableRef === table.tableRef))
                          .map((table) => ({ value: table.tableRef, label: tableLabel(table), detail: `DB ${table.database} / Gruppe ${table.group}`, group: 'standard' as const })),
                      ]}
                      placeholder={lang === 'de' ? 'Datenbank suchen…' : 'Search database…'}
                      onSelect={(tableRef) => void handleSelectDatabase(tableRef)}
                      disabled={!!busy}
                    />
                    {mapping.database && <ConfidenceBadge confidence={mapping.database.confidence} percent={mapping.database.confidencePercent} />}
                  </div>

                  <div className={styles.importItPanel}>
                    <label className={styles.sectionLabel}>{t('dataimport.importItTitle')}</label>
                    <div className={styles.importItFields}>
                      <label className={styles.importItField}>
                        <span>{t('dataimport.importItTableStart')}</span>
                        <input
                          className={styles.importItInput}
                          type="number"
                          min={0}
                          value={mapping.importIt.tableStartColumn}
                          onChange={(event) => void handleImportItSettingChange({ tableStartColumn: Math.max(0, Number(event.target.value) || 0) })}
                        />
                        <small>{t('dataimport.importItTableStartHint')}</small>
                      </label>
                      <label className={styles.importItField}>
                        <span>{t('dataimport.importItSml')}</span>
                        <input
                          className={styles.importItInput}
                          value={mapping.importIt.smlNumber}
                          onChange={(event) => void handleImportItSettingChange({ smlNumber: event.target.value })}
                        />
                      </label>
                      <label className={styles.importItField}>
                        <span>{t('dataimport.importItOptionCode')}</span>
                        <input
                          className={styles.importItInput}
                          type="number"
                          min={0}
                          value={resolveImportItOptionCode(mapping.importIt)}
                          onChange={(event) => void handleImportItSettingChange({ optionCodeOverride: Number(event.target.value) || 0 })}
                        />
                        <small>
                          {mapping.importIt.optionCodeOverride === null
                            ? t('dataimport.importItOptionCodeAuto')
                            : `A1 = ${formatImportItDatabaseRef(mapping.database?.tableRef ?? '')}`}
                        </small>
                      </label>
                    </div>
                    <div className={styles.importItOptions}>
                      {IMPORT_IT_IMPORT_OPTIONS.map((option) => (
                        <label key={option.key} className={styles.importItOption}>
                          <input
                            type="checkbox"
                            checked={mapping.importIt.options.includes(option.key)}
                            onChange={() => void handleToggleImportItOption(option.key)}
                          />
                          <span>{t(IMPORT_IT_OPTION_LABEL_KEYS[option.key])}</span>
                        </label>
                      ))}
                    </div>
                  </div>

                  <table className={styles.table}>
                    <thead>
                      <tr>
                        <th aria-label={t('dataimport.importItReorder')} />
                        <th>{lang === 'de' ? 'Spalte' : 'Column'}</th>
                        <th>{lang === 'de' ? 'Feld' : 'Field'}</th>
                        <th>{t('dataimport.importItFieldOptions')}</th>
                        <th>{lang === 'de' ? 'Konfidenz' : 'Confidence'}</th>
                        <th>{lang === 'de' ? 'Excel-Typ' : 'Source type'}</th>
                        <th>{lang === 'de' ? 'Feld-Typ' : 'Field type'}</th>
                      </tr>
                    </thead>
                    <tbody>
                      {mapping.fieldMapping.map((m) => {
                        const currentTable = tableDefs.find((t) => t.tableRef === mapping.database?.tableRef);
                        const selectedField = findFieldByTechnicalName(currentTable, m.field);
                        const aiField = findFieldByTechnicalName(currentTable, m.aiField);
                        return (
                          <tr
                            key={m.column}
                            className={draggedColumn === m.column ? styles.draggedRow : undefined}
                            onDragOver={(event) => { if (draggedColumn) event.preventDefault(); }}
                            onDrop={(event) => {
                              event.preventDefault();
                              if (draggedColumn) void handleReorderField(draggedColumn, m.column);
                              setDraggedColumn(null);
                            }}
                          >
                            <td
                              className={styles.dragHandle}
                              draggable
                              title={t('dataimport.importItReorder')}
                              onDragStart={() => setDraggedColumn(m.column)}
                              onDragEnd={() => setDraggedColumn(null)}
                            >
                              ⠿
                            </td>
                            <td>
                              <div className={styles.columnCell}>
                                <span>{m.column}</span>
                              </div>
                            </td>
                            <td>
                              <div className={styles.fieldSelection}>
                                <SearchablePicker
                                  key={`${m.column}:${m.field ?? ''}:${m.fieldDataType ?? ''}`}
                                  className={styles.fieldPicker}
                                  displayValue={m.field ?? ''}
                                  options={[
                                    {
                                      value: FREE_TEXT_FIELD,
                                      label: lang === 'de' ? 'Freitext…' : 'Free text…',
                                      detail: lang === 'de' ? 'Eigenen technischen Feldnamen eingeben' : 'Enter a technical field name',
                                      chips: [sourceChip('manual', lang)],
                                      group: 'action',
                                    },
                                    ...(m.aiField
                                      ? [{
                                        value: m.aiField,
                                        label: fieldLabel(aiField ?? { name: m.aiField, description: '' }),
                                        detail: m.aiConfidence ?? undefined,
                                        chips: [
                                          sourceChip('ai', lang),
                                          ...(m.aiConfidencePercent === null || m.aiConfidencePercent === undefined ? [] : [{ label: `${m.aiConfidencePercent}%`, tone: 'confidence' as const }]),
                                          ...(aiField?.dataType ? [{ label: aiField.dataType, tone: 'type' as const }] : []),
                                        ],
                                        group: 'ai' as const,
                                      }]
                                      : []),
                                    ...(m.aiAlternativeField && m.aiAlternativeField !== m.aiField
                                      ? (() => {
                                        const alternativeField = findFieldByTechnicalName(currentTable, m.aiAlternativeField);
                                        return [{
                                          value: m.aiAlternativeField,
                                          label: fieldLabel(alternativeField ?? { name: m.aiAlternativeField, description: '' }),
                                          detail: lang === 'de' ? 'KI-Alternative' : 'AI alternative',
                                          chips: [
                                            sourceChip('ai', lang),
                                            ...(alternativeField?.dataType ? [{ label: alternativeField.dataType, tone: 'type' as const }] : []),
                                          ],
                                          group: 'ai' as const,
                                        }];
                                      })()
                                      : []),
                                    ...(currentTable?.fields
                                      .filter((field) => field.name !== m.aiField && field.name !== m.aiAlternativeField)
                                      .map((field) => ({
                                        value: field.name,
                                        label: fieldLabel(field),
                                        chips: [
                                          sourceChip('standard', lang),
                                          ...(field.dataType ? [{ label: field.dataType, tone: 'type' as const }] : []),
                                        ],
                                        group: 'standard' as const,
                                      })) ?? []),
                                  ]}
                                  placeholder={lang === 'de' ? 'Feld suchen…' : 'Search field…'}
                                  onSelect={(field) => void handleSelectField(m.column, field)}
                                  disabled={!!busy}
                                  allowFreeText
                                />
                                {selectedField && <span className={styles.fieldDescription}>{fieldDescription(selectedField)}</span>}
                                {m.field && (
                                  <span className={styles.pickerChips}>
                                    <span className={chipClassName(sourceChip(m.source, lang).tone)}>{sourceChip(m.source, lang).label}</span>
                                    {m.source === 'ai' && m.confidencePercent !== null && <span className={styles.pickerChip}>{m.confidencePercent}%</span>}
                                    {selectedField?.dataType && <span className={styles.pickerTypeChip}>{selectedField.dataType}</span>}
                                  </span>
                                )}
                                {m.source !== 'ai' && m.aiField && (
                                  <button
                                    className={styles.restoreAiBtn}
                                    type="button"
                                    title={lang === 'de' ? 'KI-Vorschlag wiederherstellen' : 'Restore AI suggestion'}
                                    aria-label={lang === 'de' ? 'KI-Vorschlag wiederherstellen' : 'Restore AI suggestion'}
                                    onClick={() => void handleRestoreAiField(m.column)}
                                  >
                                    <IconUndo />
                                  </button>
                                )}
                              </div>
                              {m.note && <div className={styles.fieldNote}>{m.note}</div>}
                            </td>
                            <td>
                              <div className={styles.fieldOptionToggles}>
                                {IMPORT_IT_FIELD_OPTIONS.map((option) => (
                                  <button
                                    key={option}
                                    type="button"
                                    className={(m.importItOptions ?? []).includes(option) ? styles.fieldOptionActive : styles.fieldOption}
                                    onClick={() => void handleToggleFieldOption(m.column, option)}
                                    disabled={!m.field || !!busy}
                                    aria-pressed={(m.importItOptions ?? []).includes(option)}
                                  >
                                    @{option}
                                  </button>
                                ))}
                              </div>
                            </td>
                            <td><ConfidenceBadge confidence={m.confidence} percent={m.confidencePercent} /></td>
                            <td>{m.dataType ?? '—'}</td>
                            <td>{m.fieldDataType ?? '—'}</td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                  {mapping.relationships.length > 0 && (
                    <ul className={styles.relationshipList}>
                      {mapping.relationships.map((r, i) => (
                        <li key={i} className={r.status === 'requires_preparation' ? styles.relationshipWarn : undefined}>
                          {r.column} → {r.targetDatabase} ({r.status}) — {r.note}
                        </li>
                      ))}
                    </ul>
                  )}
                    </>
                  )}
                  {mappingTab === 'structural' && mapping.structuralHints.length > 0 && (
                    <div className={styles.hintPanel}>
                      <div className={styles.sectionHeaderRow}>
                        <label className={styles.sectionLabel}>{t('dataimport.structuralHintsTab')}</label>
                        <button
                          className={styles.secondaryBtn}
                          type="button"
                          onClick={() => appendInstruction(mapping.structuralHints.join('\n'))}
                          disabled={!!busy}
                        >
                          <IconImport />
                          {t('dataimport.applyAllHints')}
                        </button>
                      </div>
                      <ul className={styles.hintList}>
                        {mapping.structuralHints.map((hint, index) => (
                          <li key={index} className={styles.hintItem}>
                            <button className={styles.secondaryBtn} type="button" onClick={() => appendInstruction(hint)} disabled={!!busy}>
                              <IconImport />
                              {t('dataimport.applyHint')}
                            </button>
                            <span>{hint}</span>
                          </li>
                        ))}
                      </ul>
                    </div>
                  )}
                  {mappingTab === 'content' && mapping.contentHints.length > 0 && (
                    <div className={styles.hintPanel}>
                      <div className={styles.sectionHeaderRow}>
                        <label className={styles.sectionLabel}>{t('dataimport.contentHintsTab')}</label>
                        <button
                          className={styles.secondaryBtn}
                          type="button"
                          onClick={() => appendInstruction(mapping.contentHints.join('\n'))}
                          disabled={!!busy}
                        >
                          <IconImport />
                          {t('dataimport.applyAllHints')}
                        </button>
                      </div>
                      <ul className={styles.hintList}>
                          {mapping.contentHints.map((warning, index) => (
                          <li key={index} className={styles.hintItem}>
                            <button
                              className={styles.secondaryBtn}
                              type="button"
                              onClick={() => appendInstruction(warning)}
                              disabled={!!busy}
                            >
                              <IconImport />
                              {t('dataimport.applyHint')}
                            </button>
                            <span>{warning}</span>
                          </li>
                        ))}
                      </ul>
                    </div>
                  )}
                </div>
              ) : (
                <p className={styles.hint}>
                  {lang === 'de' ? 'Noch keine Zuordnung ermittelt.' : 'No mapping determined yet.'}
                </p>
              )}
            </div>
          </>
        )}
      </main>
    </div>
  );
}
