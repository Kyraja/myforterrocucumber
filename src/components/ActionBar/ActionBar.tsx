import { useState } from 'react';
import { useTranslation } from '../../i18n';
import { copyToClipboard } from '../../lib/clipboard';
import { downloadFeatureFile } from '../../lib/download';

import styles from './ActionBar.module.css';

interface ActionBarProps {
  gherkin: string;
  featureName: string;
  showZip?: boolean;
  onDownloadZip?: () => void;
}

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
