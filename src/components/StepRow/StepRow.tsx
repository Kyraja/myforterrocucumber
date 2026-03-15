import { useState, useRef, useEffect, useMemo } from 'react';
import type { Step, StepKeyword, StepAction, ActionType, EditorCommand, TableDef } from '../../types/gherkin';
import type { CreatedRecord } from '../../lib/recordTracker';
import { useTranslation } from '../../i18n';
import { stepTextFromAction, ACTION_LABELS, ACTION_HELP, createDefaultAction, EDITOR_COMMANDS } from '../../lib/actionText';
import { FieldCombobox, TableCombobox } from '../TableFieldSelect/TableFieldSelect';
import { DataTableEditor } from '../DataTableEditor/DataTableEditor';
import styles from './StepRow.module.css';

const KEYWORDS: StepKeyword[] = ['Given', 'When', 'Then', 'And', 'But'];
const KEYWORD_LABELS: Record<StepKeyword, string> = {
  Given: 'Gegeben',
  When: 'Wenn',
  Then: 'Dann',
  And: 'Und',
  But: 'Aber',
};
const ACTION_TYPES: ActionType[] = [
  'freetext',
  'editorOeffnen', 'editorOeffnenSuche', 'editorOeffnenMenue',
  'feldSetzen', 'feldPruefen', 'feldLeer', 'feldAenderbar',
  'editorSpeichern', 'editorSchliessen', 'editorWechseln',
  'zeileAnlegen', 'zeilenAnfuegen', 'buttonDruecken', 'subeditorOeffnen',
  'infosystemOeffnen', 'tabelleZeilen',
  'exceptionSpeichern', 'exceptionFeld', 'dialogBeantworten',
];

interface StepRowProps {
  step: Step;
  onChange: (updated: Step) => void;
  onRemove: () => void;
  onDuplicate: () => void;
  tables: TableDef[];
  currentTableRef?: string;
  createdRecords: CreatedRecord[];
}

export function StepRow({ step, onChange, onRemove, onDuplicate, tables, currentTableRef, createdRecords }: StepRowProps) {
  const { t } = useTranslation();
  const isAction = step.action.type !== 'freetext';

  // Fields from the currently active table (inferred from preceding editorOeffnen)
  const currentFields = tables.find((t) => t.tableRef === currentTableRef)?.fields ?? [];

  const handleActionTypeChange = (newType: ActionType) => {
    if (newType === 'freetext') {
      onChange({ ...step, action: { type: 'freetext' } });
      return;
    }
    const newAction = createDefaultAction(newType);
    const { keyword, text } = stepTextFromAction(newAction);
    // Initialize data table for actions that need one
    if (newType === 'zeilenAnfuegen') {
      onChange({ ...step, action: newAction, keyword, text, dataTable: [['', ''], ['', '']] });
    } else if (newType === 'feldSetzen') {
      // Clear any leftover dataTable when switching to single feldSetzen
      const { dataTable: _, ...rest } = step;
      onChange({ ...rest, action: newAction, keyword, text } as Step);
    } else {
      onChange({ ...step, action: newAction, keyword, text });
    }
  };

  const updateAction = (updated: StepAction) => {
    if (updated.type === 'freetext') return;
    const { keyword, text } = stepTextFromAction(updated);
    onChange({ ...step, action: updated, keyword, text });
  };

  const toggleMultiField = (multi: boolean) => {
    if (step.action.type !== 'feldSetzen') return;
    if (multi) {
      // Single → Multi: migrate current field/value into first table row
      const initRow = [step.action.fieldName || '', step.action.value || ''];
      const newAction = { ...step.action, multi: true, fieldName: '', value: '', row: '' };
      const { keyword, text } = stepTextFromAction(newAction);
      onChange({ ...step, action: newAction, keyword, text, dataTable: [initRow] });
    } else {
      // Multi → Single: take first table row back
      const first = step.dataTable?.[0] ?? ['', ''];
      const newAction = { ...step.action, multi: false, fieldName: first[0] || '', value: first[1] || '' };
      const { keyword, text } = stepTextFromAction(newAction);
      const { dataTable: _, ...rest } = step;
      onChange({ ...rest, action: newAction, keyword, text } as Step);
    }
  };

  return (
    <div id={`step-${step.id}`} className={isAction ? styles.card : styles.row}>
      <div className={styles.topRow}>
        <select
          className={styles.actionType}
          value={step.action.type}
          onChange={(e) => handleActionTypeChange(e.target.value as ActionType)}
          aria-label={t('step.actionType')}
          title={ACTION_HELP[step.action.type]}
        >
          {ACTION_TYPES.map((at) => (
            <option key={at} value={at} title={ACTION_HELP[at]}>{ACTION_LABELS[at]}</option>
          ))}
        </select>
        <select
          className={styles.keyword}
          value={step.keyword}
          onChange={(e) => onChange({ ...step, keyword: e.target.value as StepKeyword })}
          aria-label={t('step.keyword')}
        >
          {KEYWORDS.map((kw) => (
            <option key={kw} value={kw}>{KEYWORD_LABELS[kw]}</option>
          ))}
        </select>
        {!isAction && (
          <input
            className={styles.text}
            type="text"
            value={step.text}
            onChange={(e) => onChange({ ...step, text: e.target.value })}
            placeholder={t('step.textPlaceholder')}
            aria-label={t('step.textLabel')}
          />
        )}
        <button className={styles.duplicate} onClick={onDuplicate} aria-label={t('step.duplicateLabel')} type="button" title={t('step.duplicate')}>
          &#x2398;
        </button>
        <button className={styles.remove} onClick={onRemove} aria-label={t('step.remove')} type="button">
          &times;
        </button>
      </div>

      {isAction && (
        <div className={styles.params}>
          <ActionParams
            action={step.action}
            onChange={updateAction}
            tables={tables}
            currentFields={currentFields}
            createdRecords={createdRecords}
            onToggleMultiField={toggleMultiField}
          />
          <div className={styles.generatedText}>{step.text}</div>
        </div>
      )}

      {/* Multi-field data table for feldSetzen multi mode */}
      {step.action.type === 'feldSetzen' && step.action.multi && step.dataTable && (
        <div className={styles.dataTableSection}>
          <DataTableEditor
            table={step.dataTable}
            onChange={(newTable) => onChange({ ...step, dataTable: newTable })}
            columnHeaders={[t('fieldEditor.field'), t('fieldEditor.value')]}
            fixedColumns
            fields={currentFields}
          />
        </div>
      )}

      {/* Append rows data table (first row = field names, rest = data) */}
      {step.action.type === 'zeilenAnfuegen' && step.dataTable && (
        <div className={styles.dataTableSection}>
          <DataTableEditor
            table={step.dataTable}
            onChange={(newTable) => onChange({ ...step, dataTable: newTable })}
            fields={currentFields}
            fieldSuggestionsMode="row"
          />
        </div>
      )}

      {/* Generic data table editor — shown for non-multi steps that have a data table */}
      {step.dataTable && step.dataTable.length > 0 && !(step.action.type === 'feldSetzen' && step.action.multi) && step.action.type !== 'zeilenAnfuegen' && (
        <div className={styles.dataTableSection}>
          <DataTableEditor
            table={step.dataTable}
            onChange={(newTable) => onChange({ ...step, dataTable: newTable })}
          />
          <button
            className={styles.removeTableBtn}
            onClick={() => {
              const { dataTable: _, ...rest } = step;
              onChange(rest as Step);
            }}
            type="button"
            title={t('step.removeTable')}
          >
            {t('step.removeTable')}
          </button>
        </div>
      )}
    </div>
  );
}

interface ActionParamsProps {
  action: StepAction;
  onChange: (a: StepAction) => void;
  tables: TableDef[];
  currentFields: { name: string; description: string }[];
  createdRecords: CreatedRecord[];
  onToggleMultiField?: (multi: boolean) => void;
}

/** Returns paramInput class, adding paramRequired when value is empty */
function reqClass(value: string) {
  return `${styles.paramInput} ${!value.trim() ? styles.paramRequired : ''}`;
}

function EditorFields({ action, onChange, tables }: {
  action: { editorName: string; tableRef: string; command: EditorCommand };
  onChange: (updates: Partial<{ editorName: string; tableRef: string; command: EditorCommand }>) => void;
  tables: TableDef[];
}) {
  const { t, lang } = useTranslation();
  const databases = useMemo(() => tables.filter((t) => t.kind === 'database'), [tables]);

  /** Resolve localized table name */
  const tblName = (tbl: TableDef) => {
    if (lang === 'de' && tbl.nameDe) return tbl.nameDe;
    if (lang === 'en' && tbl.nameEn) return tbl.nameEn;
    return tbl.name;
  };

  const handleTableRefChange = (ref: string) => {
    const match = databases.find((t) => t.tableRef === ref);
    if (match) {
      onChange({ tableRef: ref, editorName: tblName(match) });
    } else {
      onChange({ tableRef: ref });
    }
  };

  const handleEditorNameChange = (name: string) => {
    const q = name.toLowerCase();
    const match = databases.find((t) =>
      tblName(t).toLowerCase() === q ||
      t.name.toLowerCase() === q ||
      (t.nameDe && t.nameDe.toLowerCase() === q) ||
      (t.nameEn && t.nameEn.toLowerCase() === q)
    );
    if (match) {
      onChange({ editorName: name, tableRef: match.tableRef });
    } else {
      onChange({ editorName: name });
    }
  };

  return (
    <div className={styles.paramCol}>
      <div className={styles.paramRow}>
        <TableCombobox
          value={action.editorName}
          onChange={handleEditorNameChange}
          onSelect={(tbl) => onChange({ editorName: tblName(tbl), tableRef: tbl.tableRef })}
          tables={databases}
          placeholder={t('step.editorName')}
          className={styles.paramInput}
        />
        <input
          className={reqClass(action.tableRef)}
          type="text"
          value={action.tableRef}
          onChange={(e) => handleTableRefChange(e.target.value)}
          placeholder={t('step.tableRef')}
        />
      </div>
      <div className={styles.paramRow}>
        <select
          className={styles.paramSelect}
          value={action.command}
          onChange={(e) => onChange({ command: e.target.value as EditorCommand })}
        >
          {EDITOR_COMMANDS.map((cmd) => (
            <option key={cmd} value={cmd}>{cmd}</option>
          ))}
        </select>
      </div>
    </div>
  );
}

/* FieldNameInput replaced by FieldCombobox from TableFieldSelect */

/** Dropdown to pick a search word from previously created records */
function RecordPicker({ records, onSelect }: {
  records: CreatedRecord[];
  onSelect: (searchWord: string) => void;
}) {
  const { t } = useTranslation();
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClick = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener('mousedown', handleClick);
    return () => document.removeEventListener('mousedown', handleClick);
  }, []);

  if (records.length === 0) return null;

  return (
    <div className={styles.recordPicker} ref={ref}>
      <button
        type="button"
        className={styles.recordPickerBtn}
        onClick={() => setOpen(!open)}
        title={t('step.insertRecord')}
      >
        &darr;
      </button>
      {open && (
        <ul className={styles.recordDropdown}>
          {records.map((r, i) => (
            <li
              key={i}
              className={styles.recordOption}
              onClick={() => { onSelect(r.searchWord); setOpen(false); }}
            >
              <span className={styles.recordWord}>{r.searchWord}</span>
              <span className={styles.recordMeta}>{r.tableName} ({r.tableRef})</span>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

/** Value input with record picker */
function ValueInput({ value, onChange, placeholder, records, required = true }: {
  value: string;
  onChange: (v: string) => void;
  placeholder: string;
  records: CreatedRecord[];
  required?: boolean;
}) {
  return (
    <div className={styles.valueWithPicker}>
      <input
        className={required ? reqClass(value) : styles.paramInput}
        type="text"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
      />
      <RecordPicker records={records} onSelect={onChange} />
    </div>
  );
}

function ActionParams({ action, onChange, tables, currentFields, createdRecords, onToggleMultiField }: ActionParamsProps) {
  const { t, lang } = useTranslation();
  switch (action.type) {
    case 'editorOeffnen':
      return (
        <div className={styles.paramCol}>
          <EditorFields
            action={action}
            onChange={(u) => onChange({ ...action, ...u })}
            tables={tables}
          />
          <input
            className={styles.paramInput}
            type="text"
            value={action.record}
            onChange={(e) => onChange({ ...action, record: e.target.value })}
            placeholder={t('step.recordOptional')}
          />
        </div>
      );

    case 'editorOeffnenSuche':
      return (
        <div className={styles.paramCol}>
          <EditorFields
            action={action}
            onChange={(u) => onChange({ ...action, ...u })}
            tables={tables}
          />
          <input
            className={reqClass(action.searchCriteria)}
            type="text"
            value={action.searchCriteria}
            onChange={(e) => onChange({ ...action, searchCriteria: e.target.value })}
            placeholder={t('step.searchCriteria')}
          />
        </div>
      );

    case 'editorOeffnenMenue':
      return (
        <div className={styles.paramCol}>
          <EditorFields
            action={action}
            onChange={(u) => onChange({ ...action, ...u })}
            tables={tables}
          />
          <div className={styles.paramRow}>
            <input
              className={reqClass(action.record)}
              type="text"
              value={action.record}
              onChange={(e) => onChange({ ...action, record: e.target.value })}
              placeholder={t('step.record')}
            />
            <input
              className={reqClass(action.menuChoice)}
              type="text"
              value={action.menuChoice}
              onChange={(e) => onChange({ ...action, menuChoice: e.target.value })}
              placeholder={t('step.menuSelection')}
            />
          </div>
        </div>
      );

    case 'feldSetzen':
      return (
        <div className={styles.paramCol}>
          <label className={styles.multiToggle}>
            <input
              type="checkbox"
              checked={!!action.multi}
              onChange={(e) => onToggleMultiField?.(e.target.checked)}
            />
            {t('step.multiFields')}
          </label>
          {!action.multi && (
            <div className={styles.paramRow}>
              <FieldCombobox
                value={action.fieldName}
                onChange={(v) => onChange({ ...action, fieldName: v })}
                fields={currentFields}
                className={styles.paramInput}
              />
              <ValueInput
                value={action.value}
                onChange={(v) => onChange({ ...action, value: v, autoSearchWord: false })}
                placeholder={t('step.value')}
                records={createdRecords}
              />
              <input
                className={styles.paramInputSmall}
                type="text"
                value={action.row}
                onChange={(e) => onChange({ ...action, row: e.target.value })}
                placeholder={t('step.row')}
              />
            </div>
          )}
        </div>
      );

    case 'feldPruefen':
      return (
        <div className={styles.paramRow}>
          <FieldCombobox
            value={action.fieldName}
            onChange={(v) => onChange({ ...action, fieldName: v })}
            fields={currentFields}
            className={styles.paramInput}
          />
          <ValueInput
            value={action.expectedValue}
            onChange={(v) => onChange({ ...action, expectedValue: v })}
            placeholder={t('step.expectedValue')}
            records={createdRecords}
          />
          <input
            className={styles.paramInputSmall}
            type="text"
            value={action.row}
            onChange={(e) => onChange({ ...action, row: e.target.value })}
            placeholder={t('step.row')}
          />
        </div>
      );

    case 'feldLeer':
      return (
        <div className={styles.paramRow}>
          <FieldCombobox
            value={action.fieldName}
            onChange={(v) => onChange({ ...action, fieldName: v })}
            fields={currentFields}
            className={styles.paramInput}
          />
          <select
            className={styles.paramSelect}
            value={action.isEmpty ? 'empty' : 'notEmpty'}
            onChange={(e) => onChange({ ...action, isEmpty: e.target.value === 'empty' })}
          >
            <option value="empty">{t('step.empty')}</option>
            <option value="notEmpty">{t('step.notEmpty')}</option>
          </select>
          <input
            className={styles.paramInputSmall}
            type="text"
            value={action.row}
            onChange={(e) => onChange({ ...action, row: e.target.value })}
            placeholder={t('step.row')}
          />
        </div>
      );

    case 'feldAenderbar':
      return (
        <div className={styles.paramRow}>
          <FieldCombobox
            value={action.fieldName}
            onChange={(v) => onChange({ ...action, fieldName: v })}
            fields={currentFields}
            className={styles.paramInput}
          />
          <select
            className={styles.paramSelect}
            value={action.modifiable ? 'yes' : 'no'}
            onChange={(e) => onChange({ ...action, modifiable: e.target.value === 'yes' })}
          >
            <option value="yes">{t('step.editable')}</option>
            <option value="no">{t('step.notEditable')}</option>
          </select>
          <input
            className={styles.paramInputSmall}
            type="text"
            value={action.row}
            onChange={(e) => onChange({ ...action, row: e.target.value })}
            placeholder={t('step.row')}
          />
        </div>
      );

    case 'editorSpeichern':
    case 'editorSchliessen':
    case 'zeileAnlegen':
    case 'zeilenAnfuegen':
      return null;

    case 'editorWechseln':
      return (
        <input
          className={reqClass(action.editorName)}
          type="text"
          value={action.editorName}
          onChange={(e) => onChange({ ...action, editorName: e.target.value })}
          placeholder={t('step.editorName')}
        />
      );

    case 'buttonDruecken':
      return (
        <div className={styles.paramRow}>
          <input
            className={reqClass(action.buttonName)}
            type="text"
            value={action.buttonName}
            onChange={(e) => onChange({ ...action, buttonName: e.target.value })}
            placeholder={t('step.buttonName')}
          />
          <input
            className={styles.paramInputSmall}
            type="text"
            value={action.row}
            onChange={(e) => onChange({ ...action, row: e.target.value })}
            placeholder={t('step.row')}
          />
        </div>
      );

    case 'subeditorOeffnen':
      return (
        <div className={styles.paramRow}>
          <input
            className={reqClass(action.buttonName)}
            type="text"
            value={action.buttonName}
            onChange={(e) => onChange({ ...action, buttonName: e.target.value })}
            placeholder={t('step.buttonNameRequired')}
          />
          <input
            className={reqClass(action.subeditorName)}
            type="text"
            value={action.subeditorName}
            onChange={(e) => onChange({ ...action, subeditorName: e.target.value })}
            placeholder={t('step.subeditorName')}
          />
          <input
            className={styles.paramInputSmall}
            type="text"
            value={action.row}
            onChange={(e) => onChange({ ...action, row: e.target.value })}
            placeholder={t('step.row')}
          />
        </div>
      );

    case 'infosystemOeffnen': {
      const infosystems = tables.filter((tbl) => tbl.kind === 'infosystem');
      const isName = (tbl: TableDef) => {
        if (lang === 'de' && tbl.nameDe) return tbl.nameDe;
        if (lang === 'en' && tbl.nameEn) return tbl.nameEn;
        return tbl.name;
      };
      const handleBezeichnungChange = (name: string) => {
        const q = name.toLowerCase();
        const match = infosystems.find((tbl) =>
          isName(tbl).toLowerCase() === q ||
          tbl.name.toLowerCase() === q ||
          (tbl.nameDe && tbl.nameDe.toLowerCase() === q) ||
          (tbl.nameEn && tbl.nameEn.toLowerCase() === q)
        );
        if (match) {
          onChange({ ...action, infosystemName: name, infosystemRef: match.tableRef });
        } else {
          onChange({ ...action, infosystemName: name });
        }
      };
      const handleSuchwortChange = (ref: string) => {
        const match = infosystems.find((tbl) => tbl.tableRef === ref);
        if (match) {
          onChange({ ...action, infosystemRef: ref, infosystemName: isName(match) });
        } else {
          onChange({ ...action, infosystemRef: ref });
        }
      };
      return (
        <div className={styles.paramRow}>
          <TableCombobox
            value={action.infosystemName}
            onChange={handleBezeichnungChange}
            onSelect={(tbl) => onChange({ ...action, infosystemName: isName(tbl), infosystemRef: tbl.tableRef })}
            tables={infosystems}
            placeholder={t('step.label')}
            required={false}
            className={styles.paramInput}
          />
          <input
            className={reqClass(action.infosystemRef)}
            type="text"
            value={action.infosystemRef}
            onChange={(e) => handleSuchwortChange(e.target.value)}
            placeholder={t('step.searchWord')}
          />
        </div>
      );
    }

    case 'tabelleZeilen':
      return (
        <input
          className={`${styles.paramInputSmall} ${!action.rowCount.trim() ? styles.paramRequired : ''}`}
          type="text"
          value={action.rowCount}
          onChange={(e) => onChange({ ...action, rowCount: e.target.value })}
          placeholder={t('step.count')}
        />
      );

    case 'exceptionSpeichern':
      return (
        <input
          className={reqClass(action.exceptionId)}
          type="text"
          value={action.exceptionId}
          onChange={(e) => onChange({ ...action, exceptionId: e.target.value })}
          placeholder={t('step.exceptionId')}
        />
      );

    case 'exceptionFeld':
      return (
        <div className={styles.paramRow}>
          <FieldCombobox
            value={action.fieldName}
            onChange={(v) => onChange({ ...action, fieldName: v })}
            fields={currentFields}
            className={styles.paramInput}
          />
          <ValueInput
            value={action.value}
            onChange={(v) => onChange({ ...action, value: v })}
            placeholder={t('step.value')}
            records={createdRecords}
          />
          <input
            className={reqClass(action.exceptionId)}
            type="text"
            value={action.exceptionId}
            onChange={(e) => onChange({ ...action, exceptionId: e.target.value })}
            placeholder={t('step.exceptionId')}
          />
        </div>
      );

    case 'dialogBeantworten':
      return (
        <div className={styles.paramRow}>
          <input
            className={reqClass(action.answer)}
            type="text"
            value={action.answer}
            onChange={(e) => onChange({ ...action, answer: e.target.value })}
            placeholder={t('step.answer')}
          />
          <input
            className={reqClass(action.dialogId)}
            type="text"
            value={action.dialogId}
            onChange={(e) => onChange({ ...action, dialogId: e.target.value })}
            placeholder={t('step.dialogId')}
          />
        </div>
      );

    default:
      return null;
  }
}
