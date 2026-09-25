import { useState } from 'react';
import { createPortal } from 'react-dom';
import styles from './ConfirmDialog.module.css';

interface PromptDialogProps {
  title: string;
  message: string;
  placeholder?: string;
  defaultValue?: string;
  confirmLabel?: string;
  cancelLabel?: string;
  onConfirm: (value: string) => void;
  onCancel: () => void;
}

export function PromptDialog({
  title,
  message,
  placeholder,
  defaultValue = '',
  confirmLabel = 'OK',
  cancelLabel = 'Abbrechen',
  onConfirm,
  onCancel,
}: PromptDialogProps) {
  const [value, setValue] = useState(defaultValue);

  return createPortal(
    <div className={styles.overlay} onClick={onCancel}>
      <div className={styles.dialog} onClick={(e) => e.stopPropagation()}>
        <div className={styles.header}>
          <span className={styles.title}>{title}</span>
        </div>
        <div className={styles.body}>
          <p className={styles.message}>{message}</p>
          <input
            className={styles.promptInput}
            value={value}
            placeholder={placeholder}
            onChange={(e) => setValue(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === 'Enter') onConfirm(value.trim());
              if (e.key === 'Escape') onCancel();
            }}
            autoFocus
          />
        </div>
        <div className={styles.footer}>
          <button className={styles.cancelBtn} onClick={onCancel} type="button">
            {cancelLabel}
          </button>
          <button
            className={styles.confirmBtn}
            onClick={() => onConfirm(value.trim())}
            type="button"
          >
            {confirmLabel}
          </button>
        </div>
      </div>
    </div>,
    document.body
  );
}
