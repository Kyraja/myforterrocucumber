/**
 * @module ActionBar
 * Toolbar component providing copy-to-clipboard and download actions
 * for the currently generated Gherkin text.
 */

import { useState } from 'react';
import { useTranslation } from '../../i18n';
import { copyToClipboard } from '../../lib/clipboard';
import { downloadFeatureFile } from '../../lib/download';

import styles from './ActionBar.module.css';

/** Props for {@link ActionBar}. */
interface ActionBarProps {
  /** The Gherkin text to copy or download. */
  gherkin: string;
  /** Used to derive the `.feature` filename on download (spaces → underscores, lowercased). */
  featureName: string;
  /** When true, renders an additional "Download all as ZIP" button. */
  showZip?: boolean;
  /** Callback for the ZIP download button; only relevant when `showZip` is true. */
  onDownloadZip?: () => void;
}

/**
 * Renders Copy, Download (.feature), and optional ZIP buttons.
 * All buttons are disabled when `gherkin` is empty or contains only the bare `Feature:` header.
 * The Copy button shows a brief "Copied!" confirmation for 2 seconds after success.
 */
export function ActionBar({ gherkin, featureName, showZip = false, onDownloadZip }: ActionBarProps) {
  const { t } = useTranslation();
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    const success = await copyToClipboard(gherkin);
    if (success) {
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  const handleDownload = () => {
    const filename = featureName
      ? featureName.toLowerCase().replace(/\s+/g, '_')
      : 'feature';
    downloadFeatureFile(gherkin, filename);
  };

  const isEmpty = !gherkin.trim() || gherkin.trim() === 'Feature:';

  return (
    <div className={styles.bar}>
      <button
        className={styles.copy}
        onClick={handleCopy}
        disabled={isEmpty}
        type="button"
      >
        {copied ? t('action.copied') : t('action.copy')}
      </button>
      <button
        className={styles.download}
        onClick={handleDownload}
        disabled={isEmpty}
        type="button"
      >
        {t('action.download')}
      </button>
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
