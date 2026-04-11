/**
 * @module HelpGuide
 * Modal help dialog accessible via a "?" trigger button in the toolbar.
 *
 * Key responsibilities:
 * - Provides three tabs: Overview (architecture & workflow), Usage (step-by-step guide),
 *   and Format (Gherkin spec, rule catalog, and full example).
 * - All content is i18n-translated via the useTranslation hook.
 * - Closes on overlay click or the dedicated close button.
 */
import { useState } from 'react';
import { useTranslation } from '../../i18n';
import styles from './HelpGuide.module.css';

type HelpTab = 'overview' | 'usage' | 'format';

export function HelpGuide() {
  const { t } = useTranslation();
  const [open, setOpen] = useState(false);
  const [tab, setTab] = useState<HelpTab>('overview');

  return (
    <>
      <button
        className={styles.trigger}
        onClick={() => setOpen(true)}
        type="button"
        aria-label={t('help.showHelp')}
      >
        ?
      </button>

      {open && (
        <div className={styles.overlay} onClick={() => setOpen(false)}>
          <div className={styles.modal} onClick={(e) => e.stopPropagation()}>
            <div className={styles.modalHeader}>
              <div className={styles.tabs}>
                <button
                  className={tab === 'overview' ? styles.tabActive : styles.tab}
                  onClick={() => setTab('overview')}
                  type="button"
                >
                  {t('help.tabOverview')}
                </button>
                <button
                  className={tab === 'usage' ? styles.tabActive : styles.tab}
                  onClick={() => setTab('usage')}
                  type="button"
                >
                  {t('help.tabUsage')}
                </button>
                <button
                  className={tab === 'format' ? styles.tabActive : styles.tab}
                  onClick={() => setTab('format')}
                  type="button"
                >
                  {t('help.tabFormat')}
                </button>
              </div>
              <button
                className={styles.closeBtn}
                onClick={() => setOpen(false)}
                type="button"
              >
                &times;
              </button>
            </div>

            {tab === 'overview' && <OverviewContent />}
            {tab === 'usage' && <UsageContent />}
            {tab === 'format' && <FormatContent />}
          </div>
        </div>
      )}
    </>
  );
}

function OverviewContent() {
  const { t } = useTranslation();
  return (
    <div className={styles.content}>
      <section>
        <h3>{t('help.overviewTitle')}</h3>
        <p>{t('help.overviewDesc')}</p>
      </section>

      <section>
        <h3>{t('help.overviewArchTitle')}</h3>
        <pre className={styles.pre}>{t('help.overviewArchDesc')}</pre>
        <pre className={styles.pre}>{t('help.overviewArchStorage')}</pre>
      </section>

      <section>
        <h3>{t('help.overviewFlowTitle')}</h3>
        <pre className={styles.pre}>{t('help.overviewFlowDesc')}</pre>
      </section>

      <section>
        <h3>{t('help.overviewInputTitle')}</h3>
        <pre className={styles.pre}>{t('help.overviewInputEditor')}</pre>
        <pre className={styles.pre}>{t('help.overviewInputDocx')}</pre>
        <pre className={styles.pre}>{t('help.overviewInputFeature')}</pre>
      </section>

      <section>
        <h3>{t('help.overviewGenTitle')}</h3>
        <pre className={styles.pre}>{t('help.overviewGenManual')}</pre>
        <pre className={styles.pre}>{t('help.overviewGenRules')}</pre>
        <pre className={styles.pre}>{t('help.overviewGenAi')}</pre>
        <pre className={styles.pre}>{t('help.overviewGenAiSteps')}</pre>
      </section>

      <section>
        <h3>{t('help.overviewOutputTitle')}</h3>
        <pre className={styles.pre}>{t('help.overviewOutputDesc')}</pre>
        <pre className={styles.pre}>{t('help.overviewOutputExplorer')}</pre>
      </section>

      <section>
        <p><em>{t('help.overviewNote')}</em></p>
      </section>
    </div>
  );
}

function UsageContent() {
  const { t } = useTranslation();
  return (
    <div className={styles.content}>
      <p><em>{t('help.usageIntro')}</em></p>

      <section>
        <h3>{t('help.usageEditorTitle')}</h3>
        <p>{t('help.usageEditorDesc')}</p>

        <h4>{t('help.usageFeatureTabsTitle')}</h4>
        <p>{t('help.usageFeatureTabsDesc')}</p>

        <h4>{t('help.usageScenariosTitle')}</h4>
        <p>{t('help.usageScenariosDesc')}</p>

        <h4>{t('help.usageStepsTitle')}</h4>
        <p>{t('help.usageStepsDesc')}</p>

        <h4>{t('help.usagePreviewTitle')}</h4>
        <p>{t('help.usagePreviewDesc')}</p>
      </section>

      <section>
        <h3>{t('help.usageTemplatesTitle')}</h3>
        <p>{t('help.usageTemplatesDesc')}</p>
        <ul>
          <li><strong>{t('help.labelBuiltinTemplates')}</strong> {t('help.usageTemplatesBuiltin')}</li>
          <li><strong>{t('help.labelCustomTemplates')}</strong> {t('help.usageTemplatesCustom')}</li>
          <li><strong>{t('help.labelImportExport')}</strong> {t('help.usageTemplatesImportExport')}</li>
        </ul>
      </section>

      <section>
        <h3>{t('help.usageImportExportTitle')}</h3>
        <ul>
          <li>{t('help.usageImportFeature')}</li>
          <li>{t('help.usageExportFeature')}</li>
          <li>{t('help.usageExportZip')}</li>
        </ul>
      </section>

      <section>
        <h3>{t('help.usageCsvTitle')}</h3>
        <p>{t('help.usageCsvDesc')}</p>
      </section>

      <section>
        <h3>{t('help.usageUndoRedoTitle')}</h3>
        <p>{t('help.usageUndoRedoDesc')}</p>
      </section>

      <section>
        <h3>{t('help.usageAiTitle')}</h3>
        <p>{t('help.usageAiDesc')}</p>
        <ul>
          <li><strong>{t('help.labelSetup')}</strong> {t('help.usageAiSetup')}</li>
          <li><strong>{t('help.labelModel')}</strong> {t('help.usageAiModel')}</li>
          <li><strong>{t('help.labelPrompt')}</strong> {t('help.usageAiPrompt')}</li>
          <li><strong>{t('help.labelGenerate')}</strong> {t('help.usageAiGenerate')}</li>
        </ul>
      </section>


      <section>
        <h3>{t('help.usageDocxTitle')}</h3>
        <p>{t('help.usageDocxDesc')}</p>
        <pre className={styles.pre}>{t('help.usageDocxSteps')}</pre>
      </section>

      <section>
        <h3>{t('help.usageProfilesTitle')}</h3>
        <p>{t('help.usageProfilesDesc')}</p>
        <ul>
          <li>{t('help.usageProfilesKeywords')}</li>
          <li>{t('help.usageProfilesCustomActions')}</li>
        </ul>
      </section>

      <section>
        <h3>{t('help.usageSettingsTitle')}</h3>
        <p>{t('help.usageSettingsDesc')}</p>
      </section>
    </div>
  );
}

function FormatContent() {
  const { t } = useTranslation();
  return (
    <div className={styles.content}>
      <section>
        <h3>{t('help.formatOverview')}</h3>
        <p>
          {t('help.formatOverviewDesc')}
        </p>
      </section>

      <section>
        <h3>{t('help.formatProfilesTitle')}</h3>
        <p>{t('help.formatProfilesDesc')}</p>

        <h4>{t('help.formatProfileEfkTitle')}</h4>
        <p>{t('help.formatProfileEfkDesc')}</p>

        <h4>{t('help.formatProfileStandardTitle')}</h4>
        <p>{t('help.formatProfileStandardDesc')}</p>

        <p><em>{t('help.formatProfileNote')}</em></p>
      </section>

      <section>
        <h3>{t('help.structure')}</h3>
        <p><strong>{t('help.headerSection')}</strong> {t('help.headerNote')}</p>
        <pre className={styles.pre}>{t('help.headerFormatCode')}</pre>

        <p><strong>{t('help.perScenario')}</strong> {t('help.scenarioNote')}</p>
        <pre className={styles.pre}>{t('help.scenarioFormatCode')}</pre>
      </section>

      <section>
        <h3>{t('help.rulesCatalog')}</h3>
        <p>
          {t('help.rulesCatalogDesc')}
        </p>

        <h4>{t('help.editorSection')}</h4>
        <table className={styles.table}>
          <thead><tr><th>{t('help.action')}</th><th>{t('help.actionDescription')}</th></tr></thead>
          <tbody>
            <tr><td><code>{t('help.editorOpen')}</code></td><td>{t('help.editorOpenDesc')}</td></tr>
            <tr><td><code>{t('help.editorOpenRecord')}</code></td><td>{t('help.editorOpenRecordDesc')}</td></tr>
            <tr><td><code>{t('help.editorOpenSearch')}</code></td><td>{t('help.editorOpenSearchDesc')}</td></tr>
            <tr><td><code>{t('help.editorOpenMenu')}</code></td><td>{t('help.editorOpenMenuDesc')}</td></tr>
            <tr><td><code>{t('help.editorSave')}</code></td><td>{t('help.editorSaveDesc')}</td></tr>
            <tr><td><code>{t('help.editorClose')}</code></td><td>{t('help.editorCloseDesc')}</td></tr>
            <tr><td><code>{t('help.editorSwitch')}</code></td><td>{t('help.editorSwitchDesc')}</td></tr>
          </tbody>
        </table>
        <p>
          <em>{t('help.commands')}</em> NEW, UPDATE, STORE, VIEW, DELETE, COPY,
          DELIVERY, INVOICE, REVERSAL, RELEASE, PAYMENT, CALCULATE, TRANSFER, DONE
        </p>

        <h4>{t('help.fieldsSection')}</h4>
        <table className={styles.table}>
          <thead><tr><th>{t('help.action')}</th><th>{t('help.actionDescription')}</th></tr></thead>
          <tbody>
            <tr><td><code>{t('help.fieldSet')}</code></td><td>{t('help.fieldSetDesc')}</td></tr>
            <tr><td><code>{t('help.fieldSetRow')}</code></td><td>{t('help.fieldSetRowDesc')}</td></tr>
            <tr><td><code>{t('help.fieldCheck')}</code></td><td>{t('help.fieldCheckDesc')}</td></tr>
            <tr><td><code>{t('help.fieldCheckRow')}</code></td><td>{t('help.fieldSetRowDesc')}</td></tr>
            <tr><td><code>{t('help.fieldEmpty')}</code></td><td>{t('help.fieldEmptyDesc')}</td></tr>
            <tr><td><code>{t('help.fieldEmptyRow')}</code></td><td>{t('help.fieldSetRowDesc')}</td></tr>
            <tr><td><code>{t('help.fieldNotEmpty')}</code></td><td>{t('help.fieldNotEmptyDesc')}</td></tr>
            <tr><td><code>{t('help.fieldNotEmptyRow')}</code></td><td>{t('help.fieldSetRowDesc')}</td></tr>
            <tr><td><code>{t('help.fieldEditable')}</code></td><td>{t('help.fieldEditableDesc')}</td></tr>
            <tr><td><code>{t('help.fieldEditableRow')}</code></td><td>{t('help.fieldSetRowDesc')}</td></tr>
            <tr><td><code>{t('help.fieldLocked')}</code></td><td>{t('help.fieldLockedDesc')}</td></tr>
            <tr><td><code>{t('help.fieldLockedRow')}</code></td><td>{t('help.fieldSetRowDesc')}</td></tr>
          </tbody>
        </table>

        <h4>{t('help.tableButtonSection')}</h4>
        <table className={styles.table}>
          <thead><tr><th>{t('help.action')}</th><th>{t('help.actionDescription')}</th></tr></thead>
          <tbody>
            <tr><td><code>{t('help.addRow')}</code></td><td>{t('help.addRowDesc')}</td></tr>
            <tr><td><code>{t('help.appendRows')}</code></td><td>{t('help.appendRowsDesc')}</td></tr>
            <tr><td><code>{t('help.checkRowCount')}</code></td><td>{t('help.checkRowCountDesc')}</td></tr>
            <tr><td><code>{t('help.pressButton')}</code></td><td>{t('help.pressButtonDesc')}</td></tr>
            <tr><td><code>{t('help.pressButtonRow')}</code></td><td>{t('help.fieldSetRowDesc')}</td></tr>
            <tr><td><code>{t('help.openSubeditor')}</code></td><td>{t('help.openSubeditorDesc')}</td></tr>
            <tr><td><code>{t('help.openSubeditorRow')}</code></td><td>{t('help.fieldSetRowDesc')}</td></tr>
          </tbody>
        </table>

        <h4>{t('help.infosystemSection')}</h4>
        <table className={styles.table}>
          <thead><tr><th>{t('help.action')}</th><th>{t('help.actionDescription')}</th></tr></thead>
          <tbody>
            <tr><td><code>{t('help.openInfosystem')}</code></td><td>{t('help.openInfosystemDesc')}</td></tr>
            <tr><td><code>{t('help.exceptionSave')}</code></td><td>{t('help.exceptionSaveDesc')}</td></tr>
            <tr><td><code>{t('help.exceptionField')}</code></td><td>{t('help.exceptionFieldDesc')}</td></tr>
            <tr><td><code>{t('help.answerDialog')}</code></td><td>{t('help.answerDialogDesc')}</td></tr>
          </tbody>
        </table>
      </section>

      <section>
        <h4>{t('help.naturalVariantsTitle')}</h4>
        <p>{t('help.naturalVariantsDesc')}</p>
        <p><code>{t('help.naturalVariants')}</code></p>
      </section>

      <section>
        <h3>{t('help.fullExample')}</h3>
        <pre className={styles.pre}>{t('help.fullExampleCode')}</pre>
      </section>
    </div>
  );
}
