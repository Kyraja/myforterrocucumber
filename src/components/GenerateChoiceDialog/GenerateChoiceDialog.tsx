/**
 * @module GenerateChoiceDialog
 * Modal dialog that lets the user choose between regenerating all scenarios or only
 * those that have not yet been generated.
 *
 * Key responsibilities: presents a three-action overlay (cancel / regenerate all /
 * generate missing only) so bulk AI generation runs can be scoped to avoid
 * overwriting already-completed work.
 *
 * @exports GenerateChoiceDialog
 */
import styles from './GenerateChoiceDialog.module.css';

interface GenerateChoiceDialogProps {
  title: string;
  message: string;
  onAll: () => void;
  onUngeneratedOnly: () => void;
  onCancel: () => void;
}

export function GenerateChoiceDialog({
  title,
  message,
  onAll,
  onUngeneratedOnly,
  onCancel,
}: GenerateChoiceDialogProps) {
  return (
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
            Abbrechen
          </button>
          <button className={styles.secondaryBtn} onClick={onAll} type="button">
            Alle neu generieren
          </button>
          <button className={styles.confirmBtn} onClick={onUngeneratedOnly} type="button" autoFocus>
            Nur fehlende generieren
          </button>
        </div>
      </div>
    </div>
  );
}
