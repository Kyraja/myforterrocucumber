/** @module ActionBar */

import { useTranslation } from '../../i18n';

import styles from './ActionBar.module.css';

/** Props for {@link ActionBar}. */
interface ActionBarProps {
  /** When true, renders an additional "Download all as ZIP" button. */
  showZip?: boolean;
  /** Callback for the ZIP download button; only relevant when `showZip` is true. */
  onDownloadZip?: () => void;
}

export function ActionBar({
  showZip = false,
  onDownloadZip,
}: ActionBarProps) {
  const { t } = useTranslation();

  return (
    <div className={styles.bar}>
      {showZip && onDownloadZip && (
        <button
          className={styles.zip}
          onClick={onDownloadZip}
          type="button"
        >
          {t('action.allAsZip')}
        </button>
      )}
    </div>
  );
}
