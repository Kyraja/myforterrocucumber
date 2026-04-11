/**
 * @module GherkinPreview
 * Read-only, syntax-highlighted preview of the generated Gherkin text.
 * Optionally supports click-to-step navigation when a line mapping is provided.
 */

import { useTranslation } from '../../i18n';
import { highlightGherkin } from '../../lib/gherkinHighlight';
import type { GherkinLineMapping } from '../../lib/generator';
import styles from './GherkinPreview.module.css';

/** Props for {@link GherkinPreview}. */
interface GherkinPreviewProps {
  /** Raw Gherkin string to display. An empty or bare `Feature:` value renders the empty state. */
  gherkin: string;
  /**
   * Optional map from 1-based line number to step metadata.
   * When provided together with `onStepClick`, clicking a step line scrolls
   * the editor to the corresponding step.
   */
  lineMapping?: Map<number, GherkinLineMapping>;
  /**
   * Called with the step ID when the user clicks a step line.
   * Requires `lineMapping` to be set; clicks on non-step lines are ignored.
   */
  onStepClick?: (stepId: string) => void;
}

/**
 * Renders the Gherkin text inside a `<pre>` block with token-level syntax
 * highlighting. Uses `dangerouslySetInnerHTML` with the output of
 * `highlightGherkin` — a pure regex tokenizer with no external dependencies.
 *
 * Click events are handled via event delegation on the `<pre>` element;
 * the clicked element is walked up the DOM to find the nearest `[data-line]`
 * ancestor and its line number is resolved against `lineMapping`.
 */
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
