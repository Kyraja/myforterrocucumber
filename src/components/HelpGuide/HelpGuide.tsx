import { useState } from 'react';
import { useTranslation } from '../../i18n';
import styles from './HelpGuide.module.css';

type HelpTab = 'usage' | 'setup' | 'format';

export function HelpGuide() {
  const { t } = useTranslation();
  const [open, setOpen] = useState(false);
  const [tab, setTab] = useState<HelpTab>('usage');

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
                  className={tab === 'usage' ? styles.tabActive : styles.tab}
                  onClick={() => setTab('usage')}
                  type="button"
                >
                  {t('help.tabUsage')}
                </button>
                <button
                  className={tab === 'setup' ? styles.tabActive : styles.tab}
                  onClick={() => setTab('setup')}
                  type="button"
                >
                  {t('help.tabSetup')}
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

            {tab === 'usage' && <UsageContent />}
            {tab === 'setup' && <SetupContent />}
            {tab === 'format' && <FormatContent />}
          </div>
        </div>
      )}
    </>
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
        <h3>{t('help.usageBulkTitle')}</h3>
        <p>{t('help.usageBulkDesc')}</p>
        <pre className={styles.pre}>{t('help.usageBulkSteps')}</pre>
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

function SetupContent() {
  const { t } = useTranslation();
  return (
    <div className={styles.content}>
      <section>
        <h3>{t('help.prerequisites')}</h3>
        <ul>
          <li>{t('help.prereqJava')}</li>
          <li>{t('help.prereqEclipse')}</li>
          <li>{t('help.prereqGradle')}</li>
        </ul>
      </section>

      <section>
        <h3>{t('help.setupSteps')}</h3>
        <ol>
          <li>
            <strong>{t('help.installJava')}</strong>{t('help.setupAndEclipse')}
            {t('help.installJavaDesc')}
          </li>
          <li>
            <strong>{t('help.cucumberPlugin')}</strong>{t('help.setupInstallColon')}
            {t('help.cucumberPluginDesc')}
          </li>
          <li>
            <strong>{t('help.projectDir')}</strong>{t('help.setupCreateEg')}
            <code>{t('help.projectDirDesc')}</code>
          </li>
          <li>
            <strong>{t('help.gradleProps')}</strong>{t('help.setupWithExtranet')}
            <code>{t('help.gradlePropsDesc')}</code>{t('help.setupPlace')}
          </li>
          <li>
            <strong>{t('help.importGradle')}</strong>:
            {t('help.importGradleDesc')}
          </li>
          <li>
            <strong>{t('help.setJava')}</strong>:
            {t('help.setJavaDesc')}
          </li>
          <li>
            <strong>{t('help.junit')}</strong>{t('help.setupAddLibrary')}
          </li>
          <li>
            <strong>{t('help.runConfig')}</strong>{t('help.setupCreateConfig')}
            <code>{t('help.runConfigDesc')}</code>{t('help.setupTestRunner')}
          </li>
        </ol>
      </section>

      <section>
        <h3>{t('help.envVars')}</h3>
        <p>{t('help.envVarsDesc')}</p>
        <table className={styles.table}>
          <thead>
            <tr><th>{t('help.variable')}</th><th>{t('help.varDescription')}</th><th>{t('help.example')}</th></tr>
          </thead>
          <tbody>
            <tr><td><code>EDP_HOST</code></td><td>{t('help.edpHost')}</td><td><code>server.firma.de</code></td></tr>
            <tr><td><code>EDP_PORT</code></td><td>{t('help.edpPort')}</td><td><code>6550</code></td></tr>
            <tr><td><code>EDP_CLIENT</code></td><td>{t('help.edpClient')}</td><td><code>erp1</code></td></tr>
            <tr><td><code>EDP_PASSWORD</code></td><td>{t('help.edpPassword')}</td><td><code>sy</code></td></tr>
          </tbody>
        </table>
      </section>

      <section>
        <h3>{t('help.placeFeatureFile')}</h3>
        <p>
          {t('help.placeFeatureFileDesc')}
        </p>
      </section>

      <section>
        <h3>{t('help.commonSteps')}</h3>
        <pre className={styles.pre}>{t('help.commonStepsCode')}</pre>
      </section>

      <section>
        <h3>{t('help.commonTablesTitle')}</h3>
        <table className={styles.table}>
          <thead>
            <tr><th>{t('help.table')}</th><th>{t('help.reference')}</th></tr>
          </thead>
          <tbody>
            <tr><td>{t('help.tableCustomers')}</td><td><code>0:1</code></td></tr>
            <tr><td>{t('help.tableArticles')}</td><td><code>2:1</code></td></tr>
            <tr><td>{t('help.tableSalesOrders')}</td><td><code>2:5</code></td></tr>
            <tr><td>{t('help.tablePurchaseOrders')}</td><td><code>4:5</code></td></tr>
            <tr><td>{t('help.tableVendors')}</td><td><code>5:1</code></td></tr>
            <tr><td>{t('help.tableProductionOrders')}</td><td><code>9:1</code></td></tr>
            <tr><td>{t('help.tableServiceOrders')}</td><td><code>3:28</code></td></tr>
          </tbody>
        </table>
      </section>

      <section>
        <h3>{t('help.aiGenTitle')}</h3>
        <p>
          {t('help.aiGenDesc')}
        </p>
        <ol>
          <li>{t('help.aiStep1')}</li>
          <li>{t('help.aiStep2')}</li>
          <li>{t('help.aiStep3')}</li>
          <li>{t('help.aiStep4')}</li>
          <li>{t('help.aiStep5')}</li>
        </ol>
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
            <tr><td><code>{t('help.fieldNotEmpty')}</code></td><td>{t('help.fieldNotEmptyDesc')}</td></tr>
            <tr><td><code>{t('help.fieldEditable')}</code></td><td>{t('help.fieldEditableDesc')}</td></tr>
            <tr><td><code>{t('help.fieldLocked')}</code></td><td>{t('help.fieldLockedDesc')}</td></tr>
          </tbody>
        </table>

        <h4>{t('help.tableButtonSection')}</h4>
        <table className={styles.table}>
          <thead><tr><th>{t('help.action')}</th><th>{t('help.actionDescription')}</th></tr></thead>
          <tbody>
            <tr><td><code>{t('help.addRow')}</code></td><td>{t('help.addRowDesc')}</td></tr>
            <tr><td><code>{t('help.checkRowCount')}</code></td><td>{t('help.checkRowCountDesc')}</td></tr>
            <tr><td><code>{t('help.pressButton')}</code></td><td>{t('help.pressButtonDesc')}</td></tr>
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
        <h3>{t('help.fullExample')}</h3>
        <pre className={styles.pre}>{t('help.fullExampleCode')}</pre>
      </section>
    </div>
  );
}
