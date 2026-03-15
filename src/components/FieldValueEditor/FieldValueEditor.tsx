import type { FieldValue } from '../../types/gherkin';
import { useTranslation } from '../../i18n';
import styles from './FieldValueEditor.module.css';

interface FieldValueEditorProps {
  values: FieldValue[];
  onChange: (updated: FieldValue[]) => void;
  fieldLabel?: string;
  valueLabel?: string;
}

export function FieldValueEditor({
  values,
  onChange,
  fieldLabel,
  valueLabel,
}: FieldValueEditorProps) {
  const { t } = useTranslation();
  const resolvedFieldLabel = fieldLabel ?? t('fieldEditor.field');
  const resolvedValueLabel = valueLabel ?? t('fieldEditor.value');

  const addRow = () => {
    onChange([...values, { fieldName: '', value: '' }]);
  };

  const updateRow = (index: number, field: Partial<FieldValue>) => {
    const updated = [...values];
    updated[index] = { ...updated[index], ...field };
    onChange(updated);
  };

  const removeRow = (index: number) => {
    onChange(values.filter((_, i) => i !== index));
  };

  return (
    <div className={styles.editor}>
      {values.length > 0 && (
        <div className={styles.header}>
          <span className={styles.headerLabel}>{resolvedFieldLabel}</span>
          <span className={styles.headerLabel}>{resolvedValueLabel}</span>
          <span className={styles.headerSpacer} />
        </div>
      )}
      {values.map((fv, i) => (
        <div key={i} className={styles.row}>
          <input
            className={styles.fieldInput}
            type="text"
            value={fv.fieldName}
            onChange={(e) => updateRow(i, { fieldName: e.target.value })}
            placeholder={t('fieldEditor.fieldPlaceholder')}
          />
          <input
            className={styles.valueInput}
            type="text"
            value={fv.value}
            onChange={(e) => updateRow(i, { value: e.target.value })}
            placeholder={t('fieldEditor.valuePlaceholder')}
          />
          <button
            className={styles.removeBtn}
            onClick={() => removeRow(i)}
            type="button"
            aria-label={t('fieldEditor.removeField')}
          >
            &times;
          </button>
        </div>
      ))}
      <button className={styles.addBtn} onClick={addRow} type="button">
        + {resolvedFieldLabel}
      </button>
    </div>
  );
}
