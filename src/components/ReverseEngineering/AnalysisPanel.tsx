/**
 * @module AnalysisPanel
 * Detail panel showing the AI-powered analysis results for a selected FOP program.
 *
 * Key responsibilities: renders five tabs (source code with syntax highlighting,
 * business description, technical description, guideline findings with a score badge,
 * and generated Cucumber tests), provides action buttons to trigger or re-trigger
 * analysis, generate tests, export to the editor, and export documentation.
 *
 * @exports AnalysisPanel (default)
 */
import { useState } from 'react';
import type { FopAnalysis, FopUsage, FopFile, GuidelineFinding } from '../../types/fop';
import styles from './AnalysisPanel.module.css';

interface AnalysisPanelProps {
  analysis: FopAnalysis | null;
  usage: FopUsage | null;
  fopFile: FopFile | null;
  /** Currently selected path (may be set even if fopFile is null = file not loaded) */
  selectedPath?: string | null;
  /** Analyze the currently selected FOP (KI-Analyse + Richtlinien) */
  onAnalyze?: (forceRefresh?: boolean) => void;
  /** Generate Cucumber tests from analysis results */
  onGenerateCucumber: () => void;
  /** Export generated tests to the Editor tab */
  onExportToEditor?: () => void;
  onExportDocs: () => void;
  isAnalyzing?: boolean;
  lang: 'de' | 'en';
}

type TabId = 'fachlich' | 'technisch' | 'richtlinien' | 'quellcode' | 'cucumber';

// Score → color class
const SCORE_CLASS: Record<string, string> = {
  A: 'scoreA',
  B: 'scoreB',
  C: 'scoreC',
  D: 'scoreD',
  F: 'scoreF',
};

const SEVERITY_CLASS: Record<GuidelineFinding['severity'], string> = {
  error: 'findingError',
  warning: 'findingWarning',
  info: 'findingInfo',
};

// Very basic FOP syntax highlighter — returns an array of {text, className} spans per line
interface Span {
  text: string;
  cls: string;
}

function highlightFopLine(line: string): Span[] {
  if (!line.trim()) return [{ text: line, cls: '' }];

  // Comments: lines starting with .. or ..
  if (/^\s*\.\./.test(line)) {
    return [{ text: line, cls: 'fopComment' }];
  }

  // Labels: !LABEL
  if (/^\s*![A-Z0-9_]+/.test(line)) {
    return [{ text: line, cls: 'fopLabel' }];
  }

  // Commands: lines starting with a dot-keyword (.formula, .continue, .weiter, .if, .def, etc.)
  if (/^\s*\.(formula|continue|weiter|if|else|endif|end|def|switch|case|default|call|input|eingabe|error|fehler|print|set|noabbrev|declaration)/i.test(line)) {
    const match = line.match(/^(\s*)(\.\w+)(.*)/);
    if (match) {
      return [
        { text: match[1], cls: '' },
        { text: match[2], cls: 'fopKeyword' },
        { text: match[3], cls: 'fopRest' },
      ];
    }
  }

  return [{ text: line, cls: '' }];
}

export default function AnalysisPanel({
  analysis,
  usage,
  fopFile,
  selectedPath,
  onAnalyze,
  onGenerateCucumber,
  onExportToEditor,
  onExportDocs,
  isAnalyzing,
  lang,
}: AnalysisPanelProps) {
  const [activeTab, setActiveTab] = useState<TabId>('quellcode');

  const tabs: { id: TabId; label: string }[] = [
    { id: 'quellcode', label: lang === 'de' ? 'Quellcode' : 'Source' },
    { id: 'fachlich', label: lang === 'de' ? 'Fachlich' : 'Business' },
    { id: 'technisch', label: lang === 'de' ? 'Technisch' : 'Technical' },
    { id: 'richtlinien', label: lang === 'de' ? 'Richtlinien' : 'Guidelines' },
    { id: 'cucumber', label: 'Cucumber' },
  ];

  const nothingSelected = !selectedPath && !analysis && !fopFile;

  return (
    <div className={styles.panel}>
      {/* Action bar */}
      {fopFile && (
        <div className={styles.actionBar}>
          {onAnalyze && (
            <button
              type="button"
              className={styles.analyzeBtn}
              onClick={() => onAnalyze(!!analysis)}
              disabled={isAnalyzing}
            >
              {isAnalyzing
                ? (lang === 'de' ? '⟳ Analyse läuft…' : '⟳ Analyzing…')
                : analysis
                  ? (lang === 'de' ? '↻ Erneut analysieren' : '↻ Re-analyze')
                  : (lang === 'de' ? '🤖 FOP analysieren' : '🤖 Analyze FOP')}
            </button>
          )}
          {analysis && (
            <button
              type="button"
              className={styles.secondaryBtn}
              onClick={onGenerateCucumber}
              disabled={isAnalyzing}
            >
              {lang === 'de' ? 'Tests generieren' : 'Generate Tests'}
            </button>
          )}
          {analysis?.cucumberTests && analysis.cucumberTests.length > 0 && onExportToEditor && (
            <button
              type="button"
              className={styles.secondaryBtn}
              onClick={onExportToEditor}
              disabled={isAnalyzing}
            >
              {lang === 'de' ? 'In Editor übernehmen' : 'Export to Editor'}
            </button>
          )}
          {analysis && (
            <button
              type="button"
              className={styles.secondaryBtn}
              onClick={onExportDocs}
              disabled={isAnalyzing}
            >
              {lang === 'de' ? 'Doku exportieren' : 'Export Docs'}
            </button>
          )}
        </div>
      )}

      {/* Tabs */}
      <div className={styles.tabBar}>
        {tabs.map((tab) => (
          <button
            key={tab.id}
            type="button"
            className={`${styles.tab} ${activeTab === tab.id ? styles.tabActive : ''}`}
            onClick={() => setActiveTab(tab.id)}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Tab content */}
      <div className={styles.tabContent}>
        {nothingSelected ? (
          <p className={styles.empty}>
            {lang === 'de'
              ? 'Kein FOP ausgewählt. Bitte ein Programm in der Bindungsliste anklicken.'
              : 'No FOP selected. Click a program in the bindings list.'}
          </p>
        ) : !fopFile ? (
          <p className={styles.empty}>
            ⚠ <strong>{selectedPath}</strong><br />
            {lang === 'de'
              ? 'Datei nicht im geladenen FOP-Ordner gefunden. Bitte den Ordner prüfen, der dieses Programm enthält.'
              : 'File not found in loaded FOP folder. Please check the folder containing this program.'}
          </p>
        ) : (
          <>
            {/* ── Tab 1: Fachlich ─────────────────────────────── */}
            {activeTab === 'fachlich' && (
              <div className={styles.section}>
                {analysis ? (
                  <>
                    <p className={styles.summary}>{analysis.humanDescription.summary}</p>

                    {analysis.humanDescription.useCases.length > 0 && (
                      <>
                        <h4 className={styles.subHeading}>
                          {lang === 'de' ? 'Anwendungsfälle' : 'Use Cases'}
                        </h4>
                        <ul className={styles.useCaseList}>
                          {analysis.humanDescription.useCases.map((uc, i) => (
                            <li key={i}>{uc}</li>
                          ))}
                        </ul>
                      </>
                    )}

                    {usage && usage.usageChains.length > 0 && (
                      <>
                        <h4 className={styles.subHeading}>
                          {lang === 'de' ? 'Verwendet in:' : 'Used in:'}
                        </h4>
                        <ul className={styles.usageList}>
                          {usage.usageChains.map((chain, i) => (
                            <li key={i} className={styles.usageChain}>
                              <span className={styles.usageLabel}>{chain.bindingLabel}</span>
                              <span className={styles.usagePath}>
                                {chain.path.join(' → ')}
                              </span>
                            </li>
                          ))}
                        </ul>
                      </>
                    )}
                  </>
                ) : (
                  <p className={styles.notAnalyzed}>
                    {lang === 'de'
                      ? 'Noch nicht analysiert.'
                      : 'Not yet analyzed.'}
                  </p>
                )}
              </div>
            )}

            {/* ── Tab 2: Technisch ────────────────────────────── */}
            {activeTab === 'technisch' && (
              <div className={styles.section}>
                {analysis ? (
                  <>
                    <p className={styles.summary}>{analysis.technicalDescription.summary}</p>

                    {Object.keys(analysis.technicalDescription.eventDescriptions).length > 0 && (
                      <>
                        <h4 className={styles.subHeading}>
                          {lang === 'de' ? 'Event-Beschreibungen' : 'Event Descriptions'}
                        </h4>
                        <dl className={styles.eventList}>
                          {Object.entries(analysis.technicalDescription.eventDescriptions).map(
                            ([key, desc]) => (
                              <>
                                <dt key={`dt-${key}`} className={styles.eventKey}>{key}</dt>
                                <dd key={`dd-${key}`} className={styles.eventDesc}>{desc}</dd>
                              </>
                            ),
                          )}
                        </dl>
                      </>
                    )}

                    {analysis.technicalDescription.sideEffects.length > 0 && (
                      <>
                        <h4 className={styles.subHeading}>
                          {lang === 'de' ? 'Seiteneffekte' : 'Side Effects'}
                        </h4>
                        <ul className={styles.sideEffectList}>
                          {analysis.technicalDescription.sideEffects.map((se, i) => (
                            <li key={i}>{se}</li>
                          ))}
                        </ul>
                      </>
                    )}
                  </>
                ) : (
                  <p className={styles.notAnalyzed}>
                    {lang === 'de'
                      ? 'Noch nicht analysiert.'
                      : 'Not yet analyzed.'}
                  </p>
                )}
              </div>
            )}

            {/* ── Tab 3: Richtlinien ──────────────────────────── */}
            {activeTab === 'richtlinien' && (
              <div className={styles.section}>
                {analysis ? (
                  <>
                    <div className={styles.scoreRow}>
                      <span
                        className={`${styles.scoreBadge} ${styles[SCORE_CLASS[analysis.guidelines.score] ?? 'scoreF']}`}
                      >
                        {analysis.guidelines.score}
                      </span>
                      <span className={styles.scoreLabel}>
                        {lang === 'de' ? 'Richtlinien-Score' : 'Guidelines Score'}
                      </span>
                    </div>

                    {analysis.guidelines.findings.length === 0 ? (
                      <p className={styles.noFindings}>
                        {lang === 'de' ? 'Keine Beanstandungen.' : 'No findings.'}
                      </p>
                    ) : (
                      <ul className={styles.findingsList}>
                        {analysis.guidelines.findings.map((f, i) => (
                          <li
                            key={i}
                            className={`${styles.finding} ${styles[SEVERITY_CLASS[f.severity]]}`}
                          >
                            <span className={styles.findingLine}>
                              {lang === 'de' ? 'Z.' : 'L.'} {f.line}
                            </span>
                            <span className={styles.findingRule}>{f.rule}</span>
                            <span className={styles.findingMsg}>{f.message}</span>
                          </li>
                        ))}
                      </ul>
                    )}
                  </>
                ) : (
                  <p className={styles.notAnalyzed}>
                    {lang === 'de'
                      ? 'Noch nicht analysiert.'
                      : 'Not yet analyzed.'}
                  </p>
                )}
              </div>
            )}

            {/* ── Tab 4: Quellcode ────────────────────────────── */}
            {activeTab === 'quellcode' && (
              <div className={styles.sourceSection}>
                {(fopFile ?? analysis?.parsedStructure) ? (
                  <pre className={styles.sourceCode}>
                    {(fopFile ?? analysis!.parsedStructure).rawLines.map((line, i) => {
                      const spans = highlightFopLine(line);
                      return (
                        <div key={i} className={styles.sourceLine}>
                          <span className={styles.lineNum}>{i + 1}</span>
                          {spans.map((span, j) => (
                            <span key={j} className={span.cls ? styles[span.cls] : undefined}>
                              {span.text}
                            </span>
                          ))}
                        </div>
                      );
                    })}
                  </pre>
                ) : (
                  <p className={styles.notAnalyzed}>
                    {lang === 'de' ? 'Quellcode nicht verfügbar.' : 'Source not available.'}
                  </p>
                )}
              </div>
            )}

            {/* ── Tab 5: Cucumber ─────────────────────────────── */}
            {activeTab === 'cucumber' && (
              <div className={styles.section}>
                {analysis?.cucumberTests && analysis.cucumberTests.length > 0 ? (
                  <div className={styles.cucumberList}>
                    {analysis.cucumberTests.map((feature, i) => (
                      <div key={i} className={styles.cucumberFeature}>
                        <strong>{feature.name}</strong>
                        {feature.description && (
                          <p className={styles.cucumberDesc}>{feature.description}</p>
                        )}
                        <span className={styles.cucumberCount}>
                          {feature.scenarios?.length ?? 0}{' '}
                          {lang === 'de' ? 'Szenario(s)' : 'scenario(s)'}
                        </span>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className={styles.cucumberPlaceholder}>
                    <p className={styles.notAnalyzed}>
                      {lang === 'de' ? 'Noch nicht generiert.' : 'Not yet generated.'}
                    </p>
                    <button
                      type="button"
                      className={styles.generateBtn}
                      onClick={onGenerateCucumber}
                    >
                      {lang === 'de' ? 'Cucumber generieren' : 'Generate Cucumber'}
                    </button>
                  </div>
                )}
              </div>
            )}
          </>
        )}
      </div>

    </div>
  );
}
