import { useTranslation } from '../../i18n';
import { highlightGherkin } from '../../lib/gherkinHighlight';
import type { GherkinLineMapping } from '../../lib/generator';
import styles from './GherkinPreview.module.css';

interface GherkinPreviewProps {
  gherkin: string;
  lineMapping?: Map<number, GherkinLineMapping>;
  onStepClick?: (stepId: string) => void;
}

export function GherkinPreview({ gherkin, lineMapping, onStepClick }: GherkinPreviewProps) {
  const { t } = useTranslation();

  if (!gherkin.trim() || gherkin.trim() === 'Feature:') {
    return (
      <div className={styles.empty}>
        <p>{t('preview.empty')}</p>
      </div>
    );
  }

  const handleClick = (e: React.MouseEvent) => {
    if (!onStepClick || !lineMapping) return;
    const lineEl = (e.target as HTMLElement).closest('[data-line]');
    if (!lineEl) return;
    const lineNum = parseInt(lineEl.getAttribute('data-line')!, 10);
    const mapping = lineMapping.get(lineNum);
    if (mapping?.stepId) {
      onStepClick(mapping.stepId);
    }
  };

  return (
    <pre className={`${styles.preview} ${onStepClick ? styles.clickable : ''}`} onClick={handleClick}>
      <code dangerouslySetInnerHTML={{ __html: highlightGherkin(gherkin) }} />
    </pre>
  );
}
