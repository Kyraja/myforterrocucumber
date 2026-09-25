/**
 * @module ConfirmDialog
 * Generic modal confirmation dialog with customizable title, message, and button labels.
 *
 * Key responsibilities: renders a two-button (confirm/cancel) overlay dialog,
 * traps click propagation so clicking the backdrop dismisses without confirming,
 * and auto-focuses the confirm button for keyboard accessibility.
 *
 * @exports ConfirmDialog
 */
import { createPortal } from 'react-dom';
import styles from './ConfirmDialog.module.css';

interface ConfirmDialogProps {
  title: string;
  message: string;
  confirmLabel?: string;
  secondaryLabel?: string;
  cancelLabel?: string;
  onConfirm: () => void;
  onSecondary?: () => void;
  onCancel: () => void;
}

export function ConfirmDialog({
  title,
  message,
  confirmLabel = 'Ja',
  secondaryLabel,
  cancelLabel = 'Nein',
  onConfirm,
  onSecondary,
  onCancel,
}: ConfirmDialogProps) {
  return createPortal(
    <div className={styles.overlay} onClick={onCancel}>
      <div className={styles.dialog} onClick={(e) => e.stopPropagation()}>
        <div className={styles.header}>
          <span className={styles.title}>{title}</span>
        </div>
        <div className={styles.body}>
          <p className={styles.message}>{message}</p>
        </div>
        <div className={styles.footer}>
          <button className={styles.cancelBtn} onClick={onCancel} type="button">
            {cancelLabel}
          </button>
          {secondaryLabel && onSecondary && (
            <button className={styles.secondaryBtn} onClick={onSecondary} type="button">
              {secondaryLabel}
            </button>
          )}
          <button className={styles.confirmBtn} onClick={onConfirm} type="button" autoFocus>
            {confirmLabel}
          </button>
        </div>
      </div>
    </div>,
    document.body
  );
}
