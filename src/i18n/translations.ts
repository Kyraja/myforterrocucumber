/**
 * @module translations
 * Central repository of all UI string keys and their German/English values.
 *
 * The `Translations` interface enforces that every key has a value in both
 * languages — TypeScript will report a compile error if a key is missing from
 * either the `de` or `en` locale object. Keys follow a dot-namespaced
 * convention (`<component>.<identifier>`) matching the component tree.
 *
 * Consumed exclusively via the `t()` function from `useTranslation()`.
 */

/** Supported UI language codes. */
export type Language = 'de' | 'en';

/**
 * Complete set of translation keys.
 * Each key maps to a localised string; `{placeholder}` syntax is supported
 * for runtime interpolation via the `t()` function in `LanguageContext`.
 */
export interface Translations {
  // App
  'app.title': string;
  'app.subtitle': string;
  'app.editor': string;
  'app.bulkImport': string;
  'app.text': string;
  'app.diagram': string;
  'app.feature': string;
  'app.copy': string;
  'app.loadFeatureZip': string;
  'app.undo': string;
  'app.redo': string;
  'app.resetAll': string;
  'app.resetConfirm': string;
  'app.duplicateFeature': string;
  'app.newFeature': string;

  // ActionBar
  'action.copied': string;
  'action.copy': string;
  'action.download': string;
  'action.allAsZip': string;

  // FeatureForm
  'form.featureName': string;
  'form.featureNameHelp': string;
  'form.featureNamePlaceholder': string;
  'form.testUser': string;
  'form.testUserHelp': string;
  'form.testUserPlaceholder': string;
  'form.requirementText': string;
  'form.description': string;
  'form.requirementHelp': string;
  'form.descriptionHelp': string;
  'form.requirementPlaceholder': string;
  'form.descriptionPlaceholder': string;
  'form.analyzingTables': string;
  'form.generatingScenarios': string;
  'form.generateScenarios': string;
  'form.generateNoDbConfirm': string;
  'form.preRating': string;
  'form.aiRating': string;
  'form.preRatingSuggestions': string;
  'form.aiRatingSuggestions': string;
  'form.requestRating': string;
  'form.requestingRating': string;
  'form.inconsistencies': string;
  'form.tags': string;
  'form.tagsHelp': string;
  'form.tagsPlaceholder': string;
  'form.scenarios': string;
  'form.scenariosHelp': string;
  'form.scenario': string;
  'form.duplicateScenario': string;
  'form.template': string;
  'form.saveAsTemplate': string;
  'form.saveAsTemplateTitle': string;
  'form.import': string;
  'form.importTemplatesTitle': string;
  'form.export': string;
  'form.exportTemplatesTitle': string;
  'form.noTemplates': string;
  'form.addEmptyScenario': string;

  // ScenarioBuilder
  'scenario.namePlaceholder': string;
  'scenario.nameLabel': string;
  'scenario.remove': string;
  'scenario.commentPlaceholder': string;
  'scenario.move': string;
  'scenario.addStep': string;

  // StepRow
  'step.actionType': string;
  'step.keyword': string;
  'step.textPlaceholder': string;
  'step.textLabel': string;
  'step.duplicate': string;
  'step.duplicateLabel': string;
  'step.remove': string;
  'step.multiFields': string;
  'step.addTable': string;
  'step.removeTable': string;
  'step.editorName': string;
  'step.tableRef': string;
  'step.searchDb': string;
  'step.fieldName': string;
  'step.searchCriteria': string;
  'step.record': string;
  'step.menuSelection': string;
  'step.value': string;
  'step.row': string;
  'step.searchField': string;
  'step.expectedValue': string;
  'step.empty': string;
  'step.notEmpty': string;
  'step.editable': string;
  'step.notEditable': string;
  'step.recordOptional': string;
  'step.buttonName': string;
  'step.buttonNameRequired': string;
  'step.subeditorName': string;
  'step.label': string;
  'step.searchWord': string;
  'step.searchInfosystem': string;
  'step.count': string;
  'step.exceptionId': string;
  'step.answer': string;
  'step.dialogId': string;
  'step.insertRecord': string;

  // DataTableEditor
  'dataTable.addRow': string;
  'dataTable.removeRow': string;
  'dataTable.addColumn': string;
  'dataTable.removeColumn': string;
  'dataTable.fieldPlaceholder': string;
  'dataTable.cellPlaceholder': string;

  // GherkinPreview
  'preview.empty': string;

  // BulkImport
  'bulk.uploadXlsx': string;
  'bulk.downloadExample': string;
  'bulk.packagesLoaded': string;
  'bulk.importTitle': string;
  'bulk.importDesc': string;
  'bulk.importColumns': string;
  'bulk.downloadExampleBtn': string;
  'bulk.testUserPlaceholder': string;
  'bulk.generateAll': string;
  'bulk.cancel': string;
  'bulk.progress': string;
  'bulk.downloadZip': string;
  'bulk.colTitle': string;
  'bulk.colArea': string;
  'bulk.colPrio': string;
  'bulk.colTime': string;
  'bulk.colActions': string;
  'bulk.download': string;
  'bulk.edit': string;
  'bulk.generate': string;
  'bulk.retry': string;
  'bulk.done': string;
  'bulk.error': string;

  // CsvUpload
  'csv.loading': string;
  'csv.uploadTable': string;
  'csv.uploadDb': string;
  'csv.uploadIs': string;
  'csv.tablesFields': string;
  'csv.pasteText': string;
  'csv.pasteDbPlaceholder': string;
  'csv.pasteIsPlaceholder': string;
  'csv.variablentabelle': string;
  'csv.infosystem': string;
  'csv.apply': string;
  'csv.parsedInfo': string;
  'csv.exportHelpTitle': string;
  'csv.exportNote': string;
  'csv.reimportHint': string;

  // DatabaseSelect
  'db.searchPlaceholder': string;
  'db.searchLabel': string;
  'db.removeLabel': string;
  'db.noResults': string;
  'db.fields': string;

  // SettingsPanel
  'settings.aiSettings': string;
  'settings.model': string;
  'settings.save': string;
  'settings.systemPrompt': string;
  'settings.systemPromptCustomized': string;
  'settings.tableIdPrompt': string;
  'settings.tableIdPromptCustomized': string;
  'settings.ratingPrompt': string;
  'settings.ratingPromptCustomized': string;
  'settings.reset': string;
  'settings.login': string;
  'settings.logout': string;
  'settings.clientId': string;
  'settings.clientIdHint': string;
  'settings.clientSecret': string;
  'settings.clientSecretHint': string;
  'settings.loggedInAs': string;
  'settings.notLoggedIn': string;
  'settings.tenant': string;
  'settings.advanced': string;
  'settings.authorize': string;
  'settings.authorizeUrl': string;
  'settings.redirecting': string;
  'settings.loginModeRedirect': string;
  'settings.loginModeManual': string;
  'settings.manualOpenLogin': string;
  'settings.manualCodePlaceholder': string;
  'settings.manualCodeExchange': string;
  'settings.manualCodeHint': string;
  'settings.tokenUrl': string;
  'settings.applicationId': string;
  'settings.applicationIdHint': string;
  'settings.loadingModels': string;
  'settings.loginError': string;
  'settings.noTenants': string;
  'settings.noModels': string;
  'settings.tenantIdManual': string;

  // HelpGuide
  'help.showHelp': string;
  'help.tabOverview': string;
  'help.tabFormat': string;

  // HelpGuide — Overview tab
  'help.overviewTitle': string;
  'help.overviewDesc': string;
  'help.overviewArchTitle': string;
  'help.overviewArchDesc': string;
  'help.overviewArchStorage': string;
  'help.overviewFlowTitle': string;
  'help.overviewFlowDesc': string;
  'help.overviewInputTitle': string;
  'help.overviewInputEditor': string;
  'help.overviewInputDocx': string;
  'help.overviewInputBulk': string;
  'help.overviewInputFeature': string;
  'help.overviewGenTitle': string;
  'help.overviewGenManual': string;
  'help.overviewGenRules': string;
  'help.overviewGenAi': string;
  'help.overviewGenAiSteps': string;
  'help.overviewOutputTitle': string;
  'help.overviewOutputDesc': string;
  'help.overviewOutputExplorer': string;
  'help.overviewNote': string;
  'help.formatOverview': string;
  'help.formatOverviewDesc': string;
  'help.formatProfilesTitle': string;
  'help.formatProfilesDesc': string;
  'help.formatProfileStandardTitle': string;
  'help.formatProfileStandardDesc': string;
  'help.formatProfileEfkTitle': string;
  'help.formatProfileEfkDesc': string;
  'help.formatProfileNote': string;
  'help.structure': string;
  'help.headerSection': string;
  'help.perScenario': string;
  'help.rulesCatalog': string;
  'help.rulesCatalogDesc': string;
  'help.editorSection': string;
  'help.action': string;
  'help.actionDescription': string;
  'help.editorOpen': string;
  'help.editorOpenDesc': string;
  'help.editorOpenRecord': string;
  'help.editorOpenRecordDesc': string;
  'help.editorOpenSearch': string;
  'help.editorOpenSearchDesc': string;
  'help.editorOpenMenu': string;
  'help.editorOpenMenuDesc': string;
  'help.editorSave': string;
  'help.editorSaveDesc': string;
  'help.editorClose': string;
  'help.editorCloseDesc': string;
  'help.editorSwitch': string;
  'help.editorSwitchDesc': string;
  'help.commands': string;
  'help.fieldsSection': string;
  'help.fieldSet': string;
  'help.fieldSetDesc': string;
  'help.fieldSetRow': string;
  'help.fieldSetRowDesc': string;
  'help.fieldCheck': string;
  'help.fieldCheckDesc': string;
  'help.fieldCheckRow': string;
  'help.fieldEmpty': string;
  'help.fieldEmptyDesc': string;
  'help.fieldNotEmpty': string;
  'help.fieldNotEmptyDesc': string;
  'help.fieldEditable': string;
  'help.fieldEditableDesc': string;
  'help.fieldLocked': string;
  'help.fieldLockedDesc': string;
  'help.tableButtonSection': string;
  'help.addRow': string;
  'help.addRowDesc': string;
  'help.checkRowCount': string;
  'help.checkRowCountDesc': string;
  'help.pressButton': string;
  'help.pressButtonDesc': string;
  'help.openSubeditor': string;
  'help.openSubeditorDesc': string;
  'help.openSubeditorRow': string;
  'help.appendRows': string;
  'help.appendRowsDesc': string;
  'help.pressButtonRow': string;
  'help.fieldEmptyRow': string;
  'help.fieldNotEmptyRow': string;
  'help.fieldEditableRow': string;
  'help.fieldLockedRow': string;
  'help.naturalVariantsTitle': string;
  'help.naturalVariantsDesc': string;
  'help.naturalVariants': string;
  'help.infosystemSection': string;
  'help.openInfosystem': string;
  'help.openInfosystemDesc': string;
  'help.exceptionSave': string;
  'help.exceptionSaveDesc': string;
  'help.exceptionField': string;
  'help.exceptionFieldDesc': string;
  'help.answerDialog': string;
  'help.answerDialogDesc': string;
  'help.fullExample': string;

  // HelpGuide — Usage tab
  'help.tabUsage': string;
  'help.usageIntro': string;
  'help.usageEditorTitle': string;
  'help.usageEditorDesc': string;
  'help.usageFeatureTabsTitle': string;
  'help.usageFeatureTabsDesc': string;
  'help.usageScenariosTitle': string;
  'help.usageScenariosDesc': string;
  'help.usageStepsTitle': string;
  'help.usageStepsDesc': string;
  'help.usagePreviewTitle': string;
  'help.usagePreviewDesc': string;
  'help.usageTemplatesTitle': string;
  'help.usageTemplatesDesc': string;
  'help.usageTemplatesBuiltin': string;
  'help.usageTemplatesCustom': string;
  'help.usageTemplatesImportExport': string;
  'help.usageImportExportTitle': string;
  'help.usageImportFeature': string;
  'help.usageExportFeature': string;
  'help.usageExportZip': string;
  'help.usageCsvTitle': string;
  'help.usageCsvDesc': string;
  'help.usageUndoRedoTitle': string;
  'help.usageUndoRedoDesc': string;
  'help.usageAiTitle': string;
  'help.usageAiDesc': string;
  'help.usageAiSetup': string;
  'help.usageAiModel': string;
  'help.usageAiPrompt': string;
  'help.usageAiGenerate': string;
  'help.usageBulkTitle': string;
  'help.usageBulkDesc': string;
  'help.usageBulkSteps': string;
  'help.usageDocxTitle': string;
  'help.usageDocxDesc': string;
  'help.usageDocxSteps': string;
  'help.usageProfilesTitle': string;
  'help.usageProfilesDesc': string;
  'help.usageProfilesKeywords': string;
  'help.usageProfilesCustomActions': string;
  'help.usageSettingsTitle': string;
  'help.usageSettingsDesc': string;

  // FlowDiagram
  'flow.scenario': string;
  'flow.unnamed': string;
  'flow.emptyState': string;
  'flow.freetext': string;
  'flow.empty': string;
  'flow.notEmpty': string;
  'flow.editable': string;
  'flow.notEditable': string;
  'flow.row': string;

  // FieldValueEditor
  'fieldEditor.field': string;
  'fieldEditor.value': string;
  'fieldEditor.fieldPlaceholder': string;
  'fieldEditor.valuePlaceholder': string;
  'fieldEditor.removeField': string;
  'fieldEditor.addField': string;

  // TableFieldSelect
  'tableField.searchTable': string;
  'tableField.searchField': string;
  'tableField.noResults': string;
  'tableField.fields': string;

  // DocxImport
  'docx.upload': string;
  'docx.downloadTemplate': string;
  'docx.profile': string;
  'docx.featuresDetected': string;
  'docx.skipped': string;
  'docx.loading': string;
  'docx.emptyTitle': string;
  'docx.emptyDesc1': string;
  'docx.emptyDesc2': string;
  'docx.emptyDesc3': string;
  'docx.importAll': string;
  'docx.rateAll': string;
  'docx.aiGenerate': string;
  'docx.cancel': string;
  'docx.aiProgress': string;
  'docx.aiStepTables': string;
  'docx.aiStepScenarios': string;
  'docx.ratingProgress': string;
  'docx.aiEnhanceError': string;
  'docx.tokenLimitReached': string;
  'docx.ratingError': string;
  'docx.noFeatures': string;
  'docx.profileChanged': string;
  'docx.notLoggedIn': string;
  'docx.ratingParseError': string;
  'docx.ratingFailed': string;
  'docx.readError': string;
  'docx.noTablesWarning': string;
  'docx.contextFiles': string;
  'docx.efkAgent': string;
  'docx.createEfkAgent': string;
  'docx.efkAgentName': string;
  'docx.noAgent': string;
  'docx.selectExistingAgent': string;
  'docx.newAgent': string;
  'docx.noAgentSelected': string;
  'docx.agentRequired': string;
  'docx.agentActive': string;
  'docx.agentCreating': string;
  'docx.deleteEfkAgent': string;
  'docx.efkAgentCreated': string;
  'docx.efkChat': string;
  'docx.efkChatHint': string;
  'docx.efkChatEmpty': string;
  'docx.efkChatPlaceholder': string;
  'docx.skippedChapters': string;
  'docx.noName': string;
  'docx.scenarioStats': string;
  'docx.edit': string;
  'docx.remove': string;
  'docx.aiFeedback': string;
  'docx.rating': string;
  'docx.inconsistencies': string;
  'docx.notSet': string;
  'docx.description': string;
  'docx.testUser': string;
  'docx.tags': string;
  'docx.noTags': string;
  'docx.unnamedScenario': string;
  'docx.noSteps': string;
  'docx.noScenarios': string;

  // SettingsPanel — additional
  'settings.clientIdLabel': string;
  'settings.clientSecretLabel': string;
  'settings.hide': string;
  'settings.show': string;
  'settings.apiBaseUrl': string;
  'settings.tenantDisplay': string;
  'settings.loadModelsError': string;
  'settings.importProfiles': string;
  'settings.profileNew': string;
  'settings.profileImport': string;
  'settings.profileExport': string;
  'settings.profileDelete': string;
  'settings.profileEditClose': string;
  'settings.profileEditOpen': string;
  'settings.profileSave': string;
  'settings.profileDefault': string;
  'settings.profileNewName': string;
  'settings.profileNewDefault': string;
  'settings.profileInvalid': string;
  'settings.featureKeywords': string;
  'settings.stepKeywords': string;
  'settings.headingLevels': string;
  'settings.levels': string;
  'settings.techSection': string;
  'settings.customActions': string;
  'settings.addPattern': string;
  'settings.removePattern': string;

  // FeatureForm — additional
  'form.removeTemplate': string;

  // App — additional
  'app.docxImport': string;

  // Settings — ProfileEditor labels
  'settings.kwFeature': string;
  'settings.kwDatabase': string;
  'settings.kwTestUser': string;
  'settings.kwTags': string;
  'settings.kwDescription': string;
  'settings.kwScenario': string;
  'settings.kwComment': string;
  'settings.skPrecondition': string;
  'settings.skAction': string;
  'settings.skResult': string;
  'settings.skAnd': string;
  'settings.skBut': string;
  'settings.placeholderEg': string;
  'settings.placeholderLevels': string;
  'settings.placeholderTechSection': string;
  'settings.placeholderCustomLabel': string;

  // HelpGuide — strong labels
  'help.labelBuiltinTemplates': string;
  'help.labelCustomTemplates': string;
  'help.labelImportExport': string;
  'help.labelSetup': string;
  'help.labelModel': string;
  'help.labelPrompt': string;
  'help.labelGenerate': string;

  // HelpGuide — format notes
  'help.headerNote': string;
  'help.scenarioNote': string;

  // HelpGuide — code blocks
  'help.commonStepsCode': string;
  'help.headerFormatCode': string;
  'help.scenarioFormatCode': string;
  'help.fullExampleCode': string;

  // HelpGuide — common table names
  'help.tableCustomers': string;
  'help.tableArticles': string;
  'help.tableSalesOrders': string;
  'help.tablePurchaseOrders': string;
  'help.tableVendors': string;
  'help.tableProductionOrders': string;
  'help.tableServiceOrders': string;
}

const de: Translations = {
  // App
  'app.title': 'Testgenerator',
  'app.subtitle': 'Cucumber Generator',
  'app.editor': 'Editor',
  'app.bulkImport': 'Bulk Import',
  'app.text': 'Text',
  'app.diagram': 'Diagramm',
  'app.feature': 'Feature',
  'app.copy': 'Kopie',
  'app.loadFeatureZip': '.feature / ZIP laden',
  'app.undo': 'Rückgängig (Ctrl+Z)',
  'app.redo': 'Wiederholen (Ctrl+Y)',
  'app.resetAll': 'Alles zurücksetzen',
  'app.resetConfirm': 'Alle Features und Szenarien wirklich löschen?',
  'app.duplicateFeature': 'Feature duplizieren',
  'app.newFeature': 'Neues Feature hinzufügen',

  // ActionBar
  'action.copied': 'Kopiert!',
  'action.copy': 'Kopieren',
  'action.download': '.feature',
  'action.allAsZip': 'Alle als ZIP',

  // FeatureForm
  'form.featureName': 'Feature Name',
  'form.featureNameHelp': 'Name der .feature-Datei. Beschreibt die getestete Funktionalität (z.B. "Kundenklassifizierung erweitern").',
  'form.featureNamePlaceholder': 'z.B. User Login',
  'form.testUser': 'Testbenutzer',
  'form.testUserHelp': 'Der abas-Benutzer für den Test-Login (wird als Background-Step generiert). Leer lassen wenn kein Login nötig.',
  'form.testUserPlaceholder': 'cucumber',
  'form.requirementText': 'Anforderungstext / Beschreibung',
  'form.description': 'Beschreibung',
  'form.requirementHelp': 'Anforderungstext aus dem Einführungskonzept hier einfügen. Die KI generiert daraus automatisch Testszenarien.',
  'form.descriptionHelp': 'Optionale Beschreibung des Features im Format: As a / I want / So that.',
  'form.requirementPlaceholder': 'Anforderungstext hier einfügen, um Szenarien per KI zu generieren...',
  'form.descriptionPlaceholder': 'As a <role>\nI want <goal>\nSo that <benefit>',
  'form.analyzingTables': 'Analysiere Tabellen...',
  'form.generatingScenarios': 'Generiere Szenarien...',
  'form.generateScenarios': 'Szenarien generieren',
  'form.generateNoDbConfirm': 'Ohne Variablentabelle fehlen der KI Datenbank- und Feldinformationen — die Ergebnisse werden weniger genau. Trotzdem fortfahren?',
  'form.preRating': 'Vor-Rating',
  'form.aiRating': 'KI-Rating',
  'form.preRatingSuggestions': 'Empfehlungen',
  'form.aiRatingSuggestions': 'KI-Empfehlungen',
  'form.requestRating': 'KI-Feedback',
  'form.requestingRating': 'Bewerte...',
  'form.inconsistencies': 'Unstimmigkeiten',
  'form.tags': 'Tags',
  'form.tagsHelp': 'Optionale Tags zur Kategorisierung (z.B. @smoke, @regression, @vertrieb). Mehrere Tags mit Leerzeichen trennen.',
  'form.tagsPlaceholder': '@smoke @login',
  'form.scenarios': 'Scenarios',
  'form.scenariosHelp': 'Jedes Szenario beschreibt einen Testfall. Verwende Vorlagen für typische abas-Testmuster oder erstelle eigene Szenarien mit den Baustein-Aktionen.',
  'form.scenario': 'Szenario',
  'form.duplicateScenario': 'Szenario duplizieren',
  'form.template': 'Vorlage:',
  'form.saveAsTemplate': '+ Als Vorlage speichern',
  'form.saveAsTemplateTitle': 'Aktuelles Szenario als Vorlage speichern',
  'form.import': 'Importieren',
  'form.importTemplatesTitle': 'Vorlagen aus JSON-Datei importieren',
  'form.export': 'Exportieren',
  'form.exportTemplatesTitle': 'Eigene Vorlagen als JSON exportieren',
  'form.noTemplates': 'Keine eigenen Vorlagen vorhanden',
  'form.addEmptyScenario': '+ Leeres Szenario',

  // ScenarioBuilder
  'scenario.namePlaceholder': 'Szenarioname...',
  'scenario.nameLabel': 'Szenarioname',
  'scenario.remove': 'Szenario entfernen',
  'scenario.commentPlaceholder': 'Kommentar / Notiz (erscheint als # im Gherkin)...',
  'scenario.move': 'Verschieben',
  'scenario.addStep': '+ Schritt hinzufügen',

  // StepRow
  'step.actionType': 'Aktionstyp',
  'step.keyword': 'Step-Keyword',
  'step.textPlaceholder': 'Step-Text...',
  'step.textLabel': 'Step-Text',
  'step.duplicate': 'Duplizieren',
  'step.duplicateLabel': 'Schritt duplizieren',
  'step.remove': 'Schritt entfernen',
  'step.multiFields': 'Mehrere Felder',
  'step.addTable': 'Datentabelle',
  'step.removeTable': 'Tabelle entfernen',
  'dataTable.addRow': '+ Zeile',
  'dataTable.removeRow': 'Zeile entfernen',
  'dataTable.addColumn': '+ Spalte',
  'dataTable.removeColumn': '- Spalte',
  'dataTable.fieldPlaceholder': 'Feldname...',
  'dataTable.cellPlaceholder': '...',
  'step.editorName': 'Editor-Name *',
  'step.tableRef': 'Tabelle (z.B. 0:1) *',
  'step.searchDb': 'Datenbank suchen...',
  'step.fieldName': 'Feldname *',
  'step.searchCriteria': 'Suchkriterium *',
  'step.record': 'Datensatz *',
  'step.menuSelection': 'Menüauswahl *',
  'step.value': 'Wert *',
  'step.row': 'Z',
  'step.searchField': 'Feld suchen...',
  'step.expectedValue': 'Erwarteter Wert *',
  'step.empty': 'leer',
  'step.notEmpty': 'nicht leer',
  'step.editable': 'änderbar',
  'step.notEditable': 'nicht änderbar',
  'step.recordOptional': 'Datensatz (leer für neu)...',
  'step.buttonName': 'Button-Name (z.B. freig) *',
  'step.buttonNameRequired': 'Button-Name *',
  'step.subeditorName': 'Subeditor-Name *',
  'step.label': 'Bezeichnung',
  'step.searchWord': 'Suchwort *',
  'step.searchInfosystem': 'Infosystem suchen...',
  'step.count': 'Anzahl *',
  'step.exceptionId': 'Exception-ID *',
  'step.answer': 'Antwort *',
  'step.dialogId': 'Dialog-ID *',
  'step.insertRecord': 'Angelegten Datensatz einfügen',

  // GherkinPreview
  'preview.empty': 'Formular ausfüllen um Gherkin zu generieren',

  // BulkImport
  'bulk.uploadXlsx': 'XLSX hochladen',
  'bulk.downloadExample': 'Beispiel herunterladen',
  'bulk.packagesLoaded': 'Arbeitspakete geladen',
  'bulk.importTitle': 'Arbeitspakete importieren',
  'bulk.importDesc': 'Lade eine XLSX-Datei mit Arbeitspaketen hoch, um automatisch Gherkin-Tests zu generieren.',
  'bulk.importColumns': 'Spalten: Überschrift, Beschreibung, Umsetzungszeit, QS-Zeit, Priorität, Bereich',
  'bulk.downloadExampleBtn': 'Beispiel-Datei herunterladen',
  'bulk.testUserPlaceholder': 'Testbenutzer...',
  'bulk.generateAll': 'Alle generieren',
  'bulk.cancel': 'Abbrechen',
  'bulk.progress': '{current} / {total}',
  'bulk.downloadZip': 'ZIP herunterladen ({done}/{total})',
  'bulk.colTitle': 'Überschrift',
  'bulk.colArea': 'Bereich',
  'bulk.colPrio': 'Prio',
  'bulk.colTime': 'Zeit',
  'bulk.colActions': 'Aktionen',
  'bulk.download': 'Download',
  'bulk.edit': 'Bearbeiten',
  'bulk.generate': 'Generieren',
  'bulk.retry': 'Wiederholen',
  'bulk.done': 'Fertig',
  'bulk.error': 'Fehler',

  // CsvUpload
  'csv.loading': 'Wird geladen...',
  'csv.uploadTable': 'Variablentabelle hochladen',
  'csv.uploadDb': 'Variablentabelle hochladen',
  'csv.uploadIs': 'Infosysteme hochladen',
  'csv.tablesFields': '{tables} Tabellen, {fields} Felder',
  'csv.pasteText': 'Als Text einfügen',
  'csv.pasteDbPlaceholder': 'Ausgabe von VARIABLENTABELLE hier einfügen (Tab- oder Semikolon-getrennt)...',
  'csv.pasteIsPlaceholder': 'Ausgabe von INFOSYSTEM hier einfügen (Tab- oder Semikolon-getrennt)...',
  'csv.variablentabelle': 'Variablentabelle',
  'csv.infosystem': 'Infosystem',
  'csv.apply': 'Übernehmen',
  'csv.parsedInfo': '{tables} Tabellen, {fields} Felder erkannt',
  'csv.exportHelpTitle': 'Suchleisten für abas Export anzeigen',
  'csv.exportNote': 'Export muss auf Englisch erfolgen, damit deutsche und englische Bezeichnungen enthalten sind.',
  'csv.reimportHint': 'Tabellen neu importieren für zweisprachige Anzeige (DE/EN)',

  // DatabaseSelect
  'db.searchPlaceholder': 'Datenbank suchen (Nr., Name, Suchbegriff)...',
  'db.searchLabel': 'Datenbank suchen',
  'db.removeLabel': 'Datenbank entfernen',
  'db.noResults': 'Keine Ergebnisse',
  'db.fields': '{count} Felder',

  // SettingsPanel
  'settings.aiSettings': 'KI-Einstellungen',
  'settings.model': 'Modell',
  'settings.save': 'Speichern',
  'settings.systemPrompt': 'Generierung: System-Prompt',
  'settings.systemPromptCustomized': 'Generierung: System-Prompt (angepasst)',
  'settings.tableIdPrompt': 'Tabellen-Erkennung: Prompt',
  'settings.tableIdPromptCustomized': 'Tabellen-Erkennung: Prompt (angepasst)',
  'settings.ratingPrompt': 'KI-Bewertung: Prompt',
  'settings.ratingPromptCustomized': 'KI-Bewertung: Prompt (angepasst)',
  'settings.reset': 'Zurücksetzen',
  'settings.login': 'Einloggen',
  'settings.logout': 'Ausloggen',
  'settings.clientId': 'Client ID',
  'settings.clientIdHint': 'OAuth Client ID der Anwendung (aus der Tenant-Konfiguration)',
  'settings.clientSecret': 'Client Secret',
  'settings.clientSecretHint': 'Falls vom OAuth-Server verlangt (Confidential Client)',
  'settings.loggedInAs': 'Eingeloggt als',
  'settings.notLoggedIn': 'Nicht eingeloggt',
  'settings.tenant': 'Tenant',
  'settings.advanced': 'Erweitert',
  'settings.authorize': 'Autorisieren',
  'settings.authorizeUrl': 'Authorize-URL',
  'settings.redirecting': 'Weiterleitung...',
  'settings.loginModeRedirect': 'Redirect',
  'settings.loginModeManual': 'Manuell',
  'settings.manualOpenLogin': 'Login-Seite oeffnen',
  'settings.manualCodePlaceholder': 'Code oder Callback-URL einfuegen',
  'settings.manualCodeExchange': 'Code einloesen',
  'settings.manualCodeHint': 'Nach dem Login den Code aus der URL kopieren und hier einfuegen.',
  'settings.tokenUrl': 'Token-URL',
  'settings.applicationId': 'Application ID',
  'settings.applicationIdHint': 'Zielanwendung fuer Token-Scoping',
  'settings.loadingModels': 'Lade Modelle...',
  'settings.loginError': 'Login fehlgeschlagen',
  'settings.noTenants': 'Keine Tenants gefunden',
  'settings.noModels': 'Keine Modelle verfuegbar',
  'settings.tenantIdManual': 'Tenant-ID eingeben',

  // HelpGuide
  'help.showHelp': 'Hilfe anzeigen',
  'help.tabOverview': 'Überblick',
  'help.tabFormat': 'Konzeptformat',

  // HelpGuide — Overview tab (DE)
  'help.overviewTitle': 'Was macht der cucumbergnerator?',
  'help.overviewDesc': 'Der cucumbergnerator erzeugt aus Anforderungstexten (Einführungskonzept, Customizing-Beschreibungen) strukturierte Cucumber/Gherkin-Testszenarien für abas ERP.',

  'help.overviewArchTitle': 'Technische Architektur',
  'help.overviewArchDesc': '• React 18 + TypeScript, gebaut mit Vite\n• Läuft komplett lokal im Browser — kein Backend, kein Server, keine Installation\n• Alle Logik (Parsing, Generierung, Validierung) läuft client-seitig\n• Styling über CSS Modules',
  'help.overviewArchStorage': '• Features und Einstellungen → localStorage\n• Variablentabellen und Datei-Handles → IndexedDB\n• Kein externer Server (außer bei KI-Generierung über MyForterro)',

  'help.overviewFlowTitle': 'Datenfluss-Pipeline',
  'help.overviewFlowDesc': '1. Eingabe (Text / DOCX / .feature)\n2. Parsing (regelbasiert oder KI)\n3. FeatureInput-Datenmodell — Features mit Szenarien und typisierten Steps\n    → 20 abas-spezifische Aktionstypen (editorÖffnen, feldSetzen, feldPrüfen …)\n4. Gherkin-Generator (reine Funktion) → formatierter .feature-Text\n5. Vorschau / Diagramm / Export',

  'help.overviewInputTitle': 'Eingabewege',
  'help.overviewInputEditor': '• Editor — Features manuell im Baustein-Editor aufbauen. Jeder Step hat einen Aktionstyp mit strukturierten Feldern (Editor-Name, Tabellenreferenz, Kommando etc.).',
  'help.overviewInputDocx': '• Konzept Import (.docx) — Word-Dokumente werden mit mammoth.js zu HTML konvertiert, an Überschriften (H1/H2 oder H2/H3, konfigurierbar) in Kapitel aufgeteilt. Je nach Profil wird der relevante Abschnitt identifiziert (→ Tab „Konzeptformat"). Strukturierte Aktionsmuster werden per Regex zu typisierten Steps geparst.',
  'help.overviewInputBulk': '',
  'help.overviewInputFeature': '• .feature Import — Bestehende Gherkin-Dateien (.feature oder ZIP) werden zurück in das interne Datenmodell geparst (Round-Trip). Englische Step-Texte werden per Regex zu typisierten Aktionen zurückübersetzt.',

  'help.overviewGenTitle': 'Generierungsmethoden',
  'help.overviewGenManual': '1. Manuell (Baustein-Editor)\n    • Steps mit typisierten Aktionen zusammenbauen\n    • 20 Aktionstypen: Editor öffnen, Feld setzen/prüfen, Button drücken, Infosystem, Exception, Dialog u.a.\n    • 12 Vorlagen für typische abas-Tests beschleunigen die Erstellung',
  'help.overviewGenRules': '2. Regelbasiert (ohne KI, beim Konzept Import)\n    • Strukturierte Textmuster per Regex erkennen, z.B.:\n      „Editor öffnen: Name, DB-Ref, Kommando"\n      „Feld setzen: feldname = Wert"\n    • Natürlichsprachliche Varianten: „Feld X auf Y setzen", „Speichern" etc.\n    • Eigene Aktionsmuster über Import-Profile definierbar',
  'help.overviewGenAi': '3. KI-gestützt (MyForterro)\n    • OAuth2-Authentifizierung mit PKCE\n    • Mehrere Modelle (automatisch geladen)\n    • System-Prompt definiert alle abas-Step-Formate und Regeln\n      (STORE für Stammdaten, NEW nur für Belege, Suchwort-Schema etc.)',
  'help.overviewGenAiSteps': '    KI-Generierung in zwei Schritten:\n    (1) Tabellen-Identifikation — welche Datenbanken/Infosysteme sind relevant?\n         Lokal per Keyword-Matching oder per KI.\n    (2) Gherkin-Generierung — Anforderungstext + Felddefinitionen werden an die KI gesendet.\n         Bei großen Feldlisten wird progressiv reduziert (y-Felder priorisiert).\n         Antwort wird geparst und in das Datenmodell überführt.',

  'help.overviewOutputTitle': 'Ausgabe und Export',
  'help.overviewOutputDesc': '• Gherkin-Generator (reine Funktion): FeatureInput → formatierter .feature-Text\n    Feature Spalte 0, Szenario 2 Spaces, Steps 4 Spaces, Datentabellen 6 Spaces\n• Export als einzelne .feature-Datei, alle als ZIP-Archiv oder Druck\n• Syntaxhervorhebung in der Vorschau, Ablaufdiagramm als Alternative',
  'help.overviewOutputExplorer': '• Datei-Explorer (Chrome/Edge) — über die File System Access API ein lokales Verzeichnis öffnen. .feature-Dateien werden direkt gelesen, bearbeitet und mit 2s-Debounce zurückgeschrieben.',

  'help.overviewNote': 'Alle Daten bleiben lokal im Browser (localStorage + IndexedDB). Es werden keine Daten an externe Server gesendet — außer bei aktiver KI-Generierung über MyForterro.',

  'help.formatOverview': 'Konzeptformat — Übersicht',
  'help.formatOverviewDesc': 'Wenn Sie dieses Format in Ihrem Konzept einhalten, kann der cucumbergnerator daraus automatisch Gherkin-Testszenarien erzeugen — ohne KI. Laden Sie Ihr Word-Dokument über den Tab „Konzept Import" hoch.',
  'help.formatProfilesTitle': 'Konzept-Profile',
  'help.formatProfilesDesc': 'Der cucumbergnerator unterstützt zwei Konzeptformate, die über Import-Profile gesteuert werden. Das Profil wird im Konzept Import oder in den Einstellungen gewählt.',
  'help.formatProfileStandardTitle': 'Standard-Profil',
  'help.formatProfileStandardDesc': 'Dokument wird an H1/H2-Überschriften aufgeteilt. Kapitel mit dem Abschnitt „Technische Umsetzung" werden geparst — der Text davor wird zur Feature-Beschreibung, der Text danach wird nach Szenarien und Aktionen durchsucht. Kapitel ohne diesen Abschnitt werden übersprungen.',
  'help.formatProfileEfkTitle': 'Einführungskonzept (Forterro) — Standard',
  'help.formatProfileEfkDesc': 'Dokument wird an H2/H3-Überschriften aufgeteilt. Der relevante Inhalt endet bei der Tabelle „Auswirkungen der Customization/Extension". Alles davor wird als Anforderungstext verwendet. Zusätzlich werden die Felder „Realisierung" und „Aufwand" aus der Auswirkungstabelle extrahiert. Kapitel ohne diese Tabelle werden übersprungen.',
  'help.formatProfileNote': 'Standardmäßig ist das Profil „Einführungskonzept (Forterro)" aktiv. Eigene Profile können in den Einstellungen erstellt werden.',
  'help.structure': 'Aufbau',
  'help.headerSection': 'Kopfbereich',
  'help.perScenario': 'Pro Testszenario',
  'help.rulesCatalog': 'Regelkatalog — Strukturierte Aktionen',
  'help.rulesCatalogDesc': 'Nach Vorbedingung/Aktion/Ergebnis können strukturierte Aktionen verwendet werden. Diese werden automatisch in korrekte Cucumber-Steps umgewandelt. Werte mit Leerzeichen in "Anführungszeichen". Alles was keinem Muster entspricht wird als Freitext übernommen.',
  'help.editorSection': 'Editor',
  'help.action': 'Aktion',
  'help.actionDescription': 'Beschreibung',
  'help.editorOpen': 'Editor öffnen: Name, DB-Ref, Kommando',
  'help.editorOpenDesc': 'Maske öffnen',
  'help.editorOpenRecord': 'Editor öffnen: Name, DB-Ref, Kdo, Datensatz ID',
  'help.editorOpenRecordDesc': 'Mit Datensatz',
  'help.editorOpenSearch': 'Editor öffnen: Name, DB-Ref, Kdo, Suche Kriterium',
  'help.editorOpenSearchDesc': 'Mit Suchkriterium',
  'help.editorOpenMenu': 'Editor öffnen: Name, DB-Ref, Kdo, Datensatz ID, Menü Auswahl',
  'help.editorOpenMenuDesc': 'Mit Menüwahl',
  'help.editorSave': 'Editor speichern',
  'help.editorSaveDesc': 'Aktuellen Editor speichern',
  'help.editorClose': 'Editor schließen',
  'help.editorCloseDesc': 'Aktuellen Editor schließen',
  'help.editorSwitch': 'Editor wechseln: Name',
  'help.editorSwitchDesc': 'Zu anderem Editor wechseln',
  'help.commands': 'Kommandos:',
  'help.fieldsSection': 'Felder',
  'help.fieldSet': 'Feld setzen: feldname = "Wert"',
  'help.fieldSetDesc': 'Feld auf Wert setzen',
  'help.fieldSetRow': 'Feld setzen: feldname = "Wert", Zeile 3',
  'help.fieldSetRowDesc': 'In bestimmter Zeile',
  'help.fieldCheck': 'Feld prüfen: feldname = "Wert"',
  'help.fieldCheckDesc': 'Wert prüfen',
  'help.fieldCheckRow': 'Feld prüfen: feldname = "Wert", Zeile 3',
  'help.fieldEmpty': 'Feld leer: feldname',
  'help.fieldEmptyDesc': 'Feld muss leer sein',
  'help.fieldNotEmpty': 'Feld nicht leer: feldname',
  'help.fieldNotEmptyDesc': 'Feld darf nicht leer sein',
  'help.fieldEditable': 'Feld änderbar: feldname',
  'help.fieldEditableDesc': 'Feld muss editierbar sein',
  'help.fieldLocked': 'Feld gesperrt: feldname',
  'help.fieldLockedDesc': 'Feld muss gesperrt sein',
  'help.tableButtonSection': 'Tabelle / Buttons',
  'help.addRow': 'Zeile anlegen',
  'help.addRowDesc': 'Neue Tabellenzeile am Ende',
  'help.checkRowCount': 'Tabelle hat 5 Zeilen',
  'help.checkRowCountDesc': 'Zeilenanzahl prüfen',
  'help.pressButton': 'Button drücken: buttonname',
  'help.pressButtonDesc': 'Button im Editor klicken',
  'help.openSubeditor': 'Subeditor öffnen: button, name',
  'help.openSubeditorDesc': 'Subeditor öffnen',
  'help.openSubeditorRow': 'Subeditor öffnen: button, name, Zeile 3',
  'help.appendRows': 'Zeilen anfuegen (mit Datentabelle)',
  'help.appendRowsDesc': 'Mehrere Zeilen kompakt anfuegen',
  'help.pressButtonRow': 'Button drücken: buttonname, Zeile 3',
  'help.fieldEmptyRow': 'Feld leer: feldname, Zeile 3',
  'help.fieldNotEmptyRow': 'Feld nicht leer: feldname, Zeile 3',
  'help.fieldEditableRow': 'Feld änderbar: feldname, Zeile 3',
  'help.fieldLockedRow': 'Feld gesperrt: feldname, Zeile 3',
  'help.naturalVariantsTitle': 'Natürlichsprachliche Alternativen',
  'help.naturalVariantsDesc': 'Neben den oben genannten Mustern werden auch natürlichsprachliche Formulierungen erkannt:',
  'help.naturalVariants': 'Feld X auf Y setzen  •  Feld X zeigt Y  •  Feld X hat Wert Y  •  Feld X ist leer  •  Feld X ist nicht leer  •  Feld X ist änderbar  •  Feld X ist gesperrt  •  Speichern  •  Schließen  •  Fehlermeldung X erscheint',
  'help.infosystemSection': 'Infosystem / Exceptions / Dialoge',
  'help.openInfosystem': 'Infosystem öffnen: name',
  'help.openInfosystemDesc': 'Infosystem starten',
  'help.exceptionSave': 'Exception beim Speichern: ID',
  'help.exceptionSaveDesc': 'Fehler beim Speichern erwarten',
  'help.exceptionField': 'Exception bei Feld: feld = "Wert", Exception ID',
  'help.exceptionFieldDesc': 'Fehler bei Feldwert',
  'help.answerDialog': 'Dialog beantworten: ID, Antwort Ja',
  'help.answerDialogDesc': 'Dialog beantworten',
  'help.fullExample': 'Vollständiges Beispiel',

  // HelpGuide — Usage tab
  'help.tabUsage': 'Bedienung',
  'help.usageIntro': 'Der cucumbergnerator hat zwei Hauptansichten: Editor und Konzept Import. Alle Daten bleiben lokal im Browser gespeichert.',
  'help.usageEditorTitle': 'Editor — Hauptansicht',
  'help.usageEditorDesc': 'Die Hauptansicht ist zweigeteilt: links das Formular, rechts die Vorschau. Der Trenner zwischen beiden Seiten kann mit der Maus verschoben werden.',
  'help.usageFeatureTabsTitle': 'Feature-Tabs',
  'help.usageFeatureTabsDesc': 'Oben im Formular werden Features als Tabs angezeigt. Mit "+" kann ein neues Feature erstellt werden. Jeder Tab kann dupliziert oder geschlossen werden. Alle Features werden automatisch im Browser gespeichert.',
  'help.usageScenariosTitle': 'Szenarien',
  'help.usageScenariosDesc': 'Jedes Feature kann beliebig viele Szenarien enthalten. Szenarien können per Drag & Drop umsortiert, dupliziert und gelöscht werden. Über „+ Leeres Szenario" wird ein leeres Szenario hinzugefügt.',
  'help.usageStepsTitle': 'Steps (Baustein-Aktionen)',
  'help.usageStepsDesc': 'Jeder Schritt besteht aus einem Keyword (Vorbedingung/Aktion/Ergebnis/Und/Aber) und einer strukturierten Aktion. Im Dropdown „Aktionstyp" stehen alle abas-typischen Aktionen zur Verfügung: Editor öffnen (inkl. Suche und Menü), Feld setzen (einzeln oder mehrere), Feld prüfen, Feld leer/nicht leer, Feld änderbar, Editor speichern/schließen/wechseln, Zeile anlegen, Zeilen anfügen (kompakt mit Datentabelle), Button drücken, Subeditor öffnen, Infosystem öffnen, Tabelle Zeilenanzahl, Exception (Speichern/Feld), Dialog beantworten und Freitext.',
  'help.usagePreviewTitle': 'Vorschau (Text / Diagramm)',
  'help.usagePreviewDesc': 'Die rechte Seite zeigt die generierte Gherkin-Ausgabe. Umschalten zwischen "Text" (syntaxhervorgehobenes Gherkin) und "Diagramm" (Ablaufdiagramm der Szenarien). Von hier aus kann kopiert, heruntergeladen oder gedruckt werden.',
  'help.usageTemplatesTitle': 'Vorlagen (Templates)',
  'help.usageTemplatesDesc': 'Vorlagen beschleunigen die Erstellung typischer Testszenarien. Sie sind über das Dropdown „Vorlage" bei jedem Szenario verfügbar.',
  'help.usageTemplatesBuiltin': '12 Standardvorlagen für typische abas-Tests: Feld prüfen, Datensatz anlegen, Feldvalidierung, Tabellenzeilen, Infosystem, Prozess/Workflow, Button/Subeditor, Dialog, suchbasiertes Öffnen u.a.',
  'help.usageTemplatesCustom': 'Eigene Vorlagen: Über „+ Als Vorlage speichern" kann das aktuelle Szenario als eigene Vorlage gespeichert werden. Eigene Vorlagen erscheinen im Dropdown und können dort auch gelöscht werden.',
  'help.usageTemplatesImportExport': 'Vorlagen-Import/Export: Eigene Vorlagen können als JSON exportiert und auf anderen Rechnern wieder importiert werden (Buttons „Importieren" / „Exportieren" im Vorlagen-Bereich).',
  'help.usageImportExportTitle': 'Import / Export',
  'help.usageImportFeature': '.feature / ZIP laden: Bestehende .feature-Dateien oder ZIP-Archive mit .feature-Dateien können über den Button in der Toolbar importiert werden. Die Dateien werden geparst und als Feature-Tabs geladen.',
  'help.usageExportFeature': '.feature herunterladen: Ueber den Download-Button in der Vorschau wird das aktuelle Feature als .feature-Datei gespeichert.',
  'help.usageExportZip': 'Alle als ZIP: Bei mehreren Features erscheint der Button "Alle als ZIP", der alle Features gebundelt als ZIP-Archiv herunterladet.',
  'help.usageCsvTitle': 'Variablentabelle (CSV/XLSX)',
  'help.usageCsvDesc': 'Ueber "Variablentabelle hochladen" in der Toolbar kann eine CSV- oder XLSX-Datei mit Tabellen- und Felddefinitionen geladen werden. Danach stehen die Felder bei der Datenbank-Suche und in den Step-Feldern als Autovervollstaendigung zur Verfuegung.',
  'help.usageUndoRedoTitle': 'Rückgängig / Wiederholen',
  'help.usageUndoRedoDesc': 'Alle Änderungen können mit Ctrl+Z (Rückgängig) und Ctrl+Y (Wiederholen) rückgängig gemacht werden. „Alles zurücksetzen" löscht sämtliche Features und Szenarien.',
  'help.usageAiTitle': 'KI-Generierung',
  'help.usageAiDesc': 'Mit einer MyForterro-Anmeldung können Szenarien automatisch aus Anforderungstexten generiert werden.',
  'help.usageAiSetup': 'Einrichtung: Oben rechts auf „Nicht eingeloggt" klicken → Anwendungs-ID und Geheimnis eingeben (aus MyForterro). Nach dem Login Tenant auswählen — dann erscheint der Button „Szenarien generieren" im Formular.',
  'help.usageAiModel': 'Modell: In den Einstellungen kann zwischen den verfügbaren KI-Modellen gewählt werden. Die Modelle werden automatisch von der MyForterro API geladen.',
  'help.usageAiPrompt': 'System-Prompt: Der System-Prompt steuert, wie die KI Szenarien generiert. Er kann in den Einstellungen angepasst und bei Bedarf zurückgesetzt werden.',
  'help.usageAiGenerate': 'Generieren: Anforderungstext ins Beschreibungsfeld eingeben → „Szenarien generieren" klicken → die KI erzeugt passende Szenarien, die dann im Editor angepasst werden können.',
  'help.usageBulkTitle': '',
  'help.usageBulkDesc': '',
  'help.usageBulkSteps': '',
  'help.usageDocxTitle': 'Konzept Import (DOCX)',
  'help.usageDocxDesc': 'Über den Tab „Konzept Import" können Word-Dokumente (.docx) mit Einführungskonzepten direkt importiert werden.',
  'help.usageDocxSteps': '1. DOCX-Datei hochladen — das Dokument wird nach Überschriften in einzelne Features aufgeteilt.\n2. Ohne KI: Wenn das Dokument dem Konzeptformat folgt (siehe Tab „Konzeptformat"), werden die Szenarien direkt aus dem Text geparst.\n3. Mit KI: Über den Button „KI-Verbesserung" können die geparsten Szenarien mit KI angereichert werden.\n4. „Alle importieren" lädt alle Features in den Editor. Einzelne Features können auch einzeln bearbeitet werden.',
  'help.usageProfilesTitle': 'Import-Profile',
  'help.usageProfilesDesc': 'Import-Profile steuern, wie Word-Dokumente und Texte geparst werden. Sie definieren die Keywords, mit denen Szenarien, Schritte und Aktionen erkannt werden.',
  'help.usageProfilesKeywords': 'Keywords: Jedes Profil hat Feature-Keywords (Feature, Datenbank, Testbenutzer, Tags, Szenario, Kommentar) und Schritt-Keywords (Vorbedingung, Aktion, Ergebnis, Und, Aber). Mehrere Aliase pro Keyword sind möglich (kommagetrennt).',
  'help.usageProfilesCustomActions': 'Eigene Aktionsmuster: Über Regex-Muster können eigene Aktionen definiert werden, die beim Parsen automatisch erkannt und in Cucumber-Steps umgewandelt werden. Jedes Muster hat ein Label, einen Regex und einen Step-Text mit Platzhaltern ({1}, {2} usw.).',
  'help.usageSettingsTitle': 'Einstellungen',
  'help.usageSettingsDesc': 'Alle Einstellungen (API-Key, Modell, System-Prompt, Import-Profile) werden über das Zahnrad-Symbol oben rechts erreicht. Änderungen werden sofort im Browser gespeichert.',

  // FlowDiagram
  'flow.scenario': 'Scenario',
  'flow.unnamed': 'Unbenannt',
  'flow.emptyState': 'Szenarien hinzufügen um das Ablaufdiagramm zu sehen',
  'flow.freetext': 'Freitext',
  'flow.empty': 'leer',
  'flow.notEmpty': 'nicht leer',
  'flow.editable': 'änderbar',
  'flow.notEditable': 'nicht änderbar',
  'flow.row': 'Z.',

  // FieldValueEditor
  'fieldEditor.field': 'Feld',
  'fieldEditor.value': 'Wert',
  'fieldEditor.fieldPlaceholder': 'Feldname...',
  'fieldEditor.valuePlaceholder': 'Wert...',
  'fieldEditor.removeField': 'Feld entfernen',
  'fieldEditor.addField': '+ Feld',

  // TableFieldSelect
  'tableField.searchTable': 'Tabelle suchen...',
  'tableField.searchField': 'Feld suchen...',
  'tableField.noResults': 'Keine Ergebnisse',
  'tableField.fields': '{count} Felder',

  // DocxImport
  'docx.upload': '.docx hochladen',
  'docx.downloadTemplate': 'Vorlage herunterladen',
  'docx.profile': 'Profil:',
  'docx.featuresDetected': '{count} Feature(s) erkannt',
  'docx.skipped': ', {count} uebersprungen',
  'docx.loading': 'Dokument wird verarbeitet...',
  'docx.emptyTitle': 'Konzept-Dokument importieren',
  'docx.emptyDesc1': 'Laden Sie ein Word-Dokument (.docx) hoch, das Ihre Test-Features enthaelt.',
  'docx.emptyDesc2': 'Verwenden Sie Ueberschriften (H1/H2) um Features voneinander zu trennen.',
  'docx.emptyDesc3': 'Innerhalb jeder Sektion: Szenario, Vorbedingung, Aktion, Ergebnis.',
  'docx.importAll': 'Alle importieren ({importable}/{total})',
  'docx.rateAll': 'Alle bewerten ({count})',
  'docx.aiGenerate': 'KI-Tests generieren ({count})',
  'docx.cancel': 'Abbrechen',
  'docx.aiProgress': 'KI generiert Tests {current}/{total}',
  'docx.aiStepTables': '(Tabellen identifizieren...)',
  'docx.aiStepScenarios': '(Szenarien generieren...)',
  'docx.ratingProgress': 'KI bewertet Feature {current}/{total}',
  'docx.aiEnhanceError': 'KI-Erweiterung: {errorCount} von {total} Features konnten nicht verarbeitet werden.',
  'docx.tokenLimitReached': 'Tageslimit fuer KI-Anfragen erreicht. Bitte morgen erneut versuchen oder das Limit erhoehen lassen.',
  'docx.ratingError': 'KI-Bewertung: {errorCount} von {total} Features konnten nicht bewertet werden.',
  'docx.noFeatures': 'Keine Features im Dokument erkannt. Verwenden Sie Ueberschriften (H1/H2) als Trennung.',
  'docx.profileChanged': 'Profil gewechselt — bitte Dokument erneut hochladen.',
  'docx.notLoggedIn': 'Nicht eingeloggt. Bitte zuerst anmelden.',
  'docx.ratingParseError': 'KI-Antwort konnte nicht als Bewertung geparst werden.',
  'docx.ratingFailed': 'Fehler bei der KI-Bewertung',
  'docx.readError': 'Fehler beim Lesen der Datei: {error}',
  'docx.noTablesWarning': 'Es ist keine Variablentabelle geladen. Die KI-Generierung liefert ohne Datenbank-/Feldkontext weniger genaue Ergebnisse. Trotzdem fortfahren?',
  'docx.contextFiles': 'Notwendige Kontext-Dateien',
  'docx.efkAgent': 'EFK-Agent',
  'docx.createEfkAgent': 'EFK-Agent erstellen',
  'docx.efkAgentName': 'Name fuer den EFK-Agent:',
  'docx.noAgent': 'Ohne Agent',
  'docx.selectExistingAgent': 'Bestehenden Agent auswaehlen',
  'docx.newAgent': 'Neuen Agent erstellen',
  'docx.noAgentSelected': '-- Agent auswaehlen --',
  'docx.agentRequired': 'Bitte waehlen oder erstellen Sie einen EFK-Agent',
  'docx.agentActive': 'Agent: {name}',
  'docx.agentCreating': 'Agent wird erstellt...',
  'docx.deleteEfkAgent': 'Agent loeschen',
  'docx.efkAgentCreated': 'EFK-Agent erstellt',
  'docx.efkChat': 'Chat mit Agent',
  'docx.efkChatHint': 'Hinweis: Der Agent kennt nur die Arbeitspakete, die bereits bewertet oder generiert wurden — nicht das vollstaendige EFK-Dokument.',
  'docx.efkChatEmpty': 'Stellen Sie dem Agent eine Frage zu den bereits verarbeiteten Arbeitspaketen.',
  'docx.efkChatPlaceholder': 'Frage an den Agent... (Enter = Senden)',
  'docx.skippedChapters': 'Uebersprungene Kapitel',
  'docx.noName': '(Ohne Name)',
  'docx.scenarioStats': '{scenarios} Szenario(en), {steps} Schritte',
  'docx.edit': 'Bearbeiten',
  'docx.remove': 'Entfernen',
  'docx.aiFeedback': 'KI-Feedback',
  'docx.rating': 'Bewerte...',
  'docx.inconsistencies': 'Unstimmigkeiten',
  'docx.notSet': '(nicht gesetzt)',
  'docx.description': 'Beschreibung:',
  'docx.testUser': 'Testbenutzer:',
  'docx.tags': 'Tags:',
  'docx.noTags': '(keine)',
  'docx.unnamedScenario': '(Unbenanntes Szenario)',
  'docx.noSteps': 'Keine Schritte',
  'docx.noScenarios': 'Keine Szenarien erkannt',

  // SettingsPanel — additional
  'settings.clientIdLabel': 'Client ID',
  'settings.clientSecretLabel': 'Client Secret',
  'settings.hide': 'Verbergen',
  'settings.show': 'Anzeigen',
  'settings.apiBaseUrl': 'API Base URL',
  'settings.tenantDisplay': 'Tenant: {tenantId}',
  'settings.loadModelsError': 'Fehler beim Laden der Modelle',
  'settings.importProfiles': 'Import-Profile ({name})',
  'settings.profileNew': '+ Neu',
  'settings.profileImport': 'Importieren',
  'settings.profileExport': 'Exportieren',
  'settings.profileDelete': 'Loeschen',
  'settings.profileEditClose': 'Bearbeitung schliessen',
  'settings.profileEditOpen': 'Keywords bearbeiten',
  'settings.profileSave': 'Profil speichern',
  'settings.profileDefault': '(Standard)',
  'settings.profileNewName': 'Name fuer neues Profil:',
  'settings.profileNewDefault': 'Mein Profil',
  'settings.profileInvalid': 'Ungueltige Profil-Datei.',
  'settings.featureKeywords': 'Feature-Keywords (Komma-getrennt)',
  'settings.stepKeywords': 'Schritt-Keywords (Komma-getrennt)',
  'settings.headingLevels': 'Splitting (Heading-Ebenen)',
  'settings.levels': 'Ebenen:',
  'settings.techSection': 'Tech. Abschnitt:',
  'settings.customActions': 'Eigene Aktionsmuster ({count})',
  'settings.addPattern': '+ Muster',
  'settings.removePattern': 'Entfernen',

  // FeatureForm — additional
  'form.removeTemplate': 'Vorlage entfernen',

  // App — additional
  'app.docxImport': 'Konzept Import',

  // Settings — ProfileEditor labels
  'settings.kwFeature': 'Feature',
  'settings.kwDatabase': 'Datenbank',
  'settings.kwTestUser': 'Testbenutzer',
  'settings.kwTags': 'Tags',
  'settings.kwDescription': 'Beschreibung',
  'settings.kwScenario': 'Szenario',
  'settings.kwComment': 'Kommentar',
  'settings.skPrecondition': 'Vorbedingung',
  'settings.skAction': 'Aktion',
  'settings.skResult': 'Ergebnis',
  'settings.skAnd': 'Und',
  'settings.skBut': 'Aber',
  'settings.placeholderEg': 'z.B.',
  'settings.placeholderLevels': 'z.B. 1, 2',
  'settings.placeholderTechSection': 'z.B. Technische Umsetzung',
  'settings.placeholderCustomLabel': 'z.B. Workflow starten',

  // HelpGuide — strong labels
  'help.labelBuiltinTemplates': 'Standardvorlagen:',
  'help.labelCustomTemplates': 'Eigene Vorlagen:',
  'help.labelImportExport': 'Import/Export:',
  'help.labelSetup': 'Einrichtung:',
  'help.labelModel': 'Modell:',
  'help.labelPrompt': 'System-Prompt:',
  'help.labelGenerate': 'Generieren:',

  // HelpGuide — format notes
  'help.headerNote': '(alles optional ausser Feature):',
  'help.scenarioNote': '(Vorbedingung/Aktion/Ergebnis mehrfach möglich):',

  // HelpGuide — code blocks
  'help.commonStepsCode': '# Editor oeffnen (NEW, UPDATE, STORE, VIEW, DELETE, COPY)\nGiven I open an editor "Name" from table "DD:GG" with command "CMD" for record "ID"\n\n# Felder setzen\nAnd I set field "feldname" to "wert"\nAnd I set field "feldname" to "wert" in row 1\n\n# Felder pruefen\nThen field "feldname" has value "wert"\nThen field "feldname" is empty\nThen field "feldname" is modifiable\n\n# Editor speichern/schliessen\nAnd I save the current editor\nAnd I close the current editor\n\n# Tabellenzeile anlegen\nAnd I create a new row at the end of the table\n\n# Button druecken\nAnd I press button "buttonname"\n\n# Fehler testen\nThen saving the current editor throws the exception "ID"\n\n# Infosystem\nGiven I open the infosystem "Name"',
  'help.headerFormatCode': 'Feature:       Name des Features (Pflicht)\nDatenbank:     abas-Datenbanknummer (z.B. 1000)\nTestbenutzer:  Login-Benutzer (z.B. sy)\nTags:          Kommaseparierte Tags (z.B. @smoke, @vertrieb)\nBeschreibung:  Kurze Beschreibung der Anforderung',
  'help.scenarioFormatCode': 'Szenario:       Name des Szenarios\nKommentar:      Optionaler Kommentar (wird als # im Test)\nVorbedingung:   Was gegeben sein muss\nAktion:         Was getan wird\nErgebnis:       Was erwartet wird\nUnd:            Zusaetzlicher Schritt\nAber:           Ausnahme / Gegenprobe',
  'help.fullExampleCode': 'Feature: Kundenklassifizierung erweitern\nDatenbank: 1000\nTestbenutzer: sy\nTags: @smoke, @vertrieb\nBeschreibung: Neues Feld ykundenkategorie im Kundenstamm\n\nSzenario: Feld setzen und speichern\nVorbedingung: Editor oeffnen: Kundenstamm, 0:1, NEW\nAktion: Feld setzen: ykundenkategorie = "A-Kunde"\nAktion: Editor speichern\nErgebnis: Feld pruefen: ykundenkategorie = "A-Kunde"\n\nSzenario: Ungueltige Kategorie abfangen\nVorbedingung: Editor oeffnen: Kundenstamm, 0:1, NEW\nAktion: Feld setzen: ykundenkategorie = ""\nErgebnis: Exception beim Speichern: EX-KATEGORIE\n\nSzenario: Klassifizierung im Infosystem pruefen\nVorbedingung: Infosystem oeffnen: KUNDENUEBERSICHT\nErgebnis: Tabelle hat 1 Zeilen\nErgebnis: Feld pruefen: ykundenkategorie = "A-Kunde", Zeile 1',

  // HelpGuide — common table names
  'help.tableCustomers': 'Kunden',
  'help.tableArticles': 'Artikel/Produkte',
  'help.tableSalesOrders': 'Verkaufsauftraege',
  'help.tablePurchaseOrders': 'Einkaufsbestellungen',
  'help.tableVendors': 'Lieferanten',
  'help.tableProductionOrders': 'Betriebsauftraege',
  'help.tableServiceOrders': 'Serviceauftraege',
};

const en: Translations = {
  // App
  'app.title': 'Test Generator',
  'app.subtitle': 'Cucumber Generator',
  'app.editor': 'Editor',
  'app.bulkImport': 'Bulk Import',
  'app.text': 'Text',
  'app.diagram': 'Diagram',
  'app.feature': 'Feature',
  'app.copy': 'Copy',
  'app.loadFeatureZip': 'Load .feature / ZIP',
  'app.undo': 'Undo (Ctrl+Z)',
  'app.redo': 'Redo (Ctrl+Y)',
  'app.resetAll': 'Reset all',
  'app.resetConfirm': 'Really delete all features and scenarios?',
  'app.duplicateFeature': 'Duplicate feature',
  'app.newFeature': 'Add new feature',

  // ActionBar
  'action.copied': 'Copied!',
  'action.copy': 'Copy',
  'action.download': '.feature',
  'action.allAsZip': 'All as ZIP',

  // FeatureForm
  'form.featureName': 'Feature Name',
  'form.featureNameHelp': 'Name of the .feature file. Describes the tested functionality (e.g. "Extend customer classification").',
  'form.featureNamePlaceholder': 'e.g. User Login',
  'form.testUser': 'Test User',
  'form.testUserHelp': 'The abas user for test login (generated as Background step). Leave empty if no login needed.',
  'form.testUserPlaceholder': 'cucumber',
  'form.requirementText': 'Requirement Text / Description',
  'form.description': 'Description',
  'form.requirementHelp': 'Paste requirement text from the implementation concept here. AI will automatically generate test scenarios.',
  'form.descriptionHelp': 'Optional feature description in format: As a / I want / So that.',
  'form.requirementPlaceholder': 'Paste requirement text here to generate scenarios via AI...',
  'form.descriptionPlaceholder': 'As a <role>\nI want <goal>\nSo that <benefit>',
  'form.analyzingTables': 'Analyzing tables...',
  'form.generatingScenarios': 'Generating scenarios...',
  'form.generateScenarios': 'Generate scenarios',
  'form.generateNoDbConfirm': 'Without a variable table, the AI lacks database and field information — results will be less accurate. Continue anyway?',
  'form.preRating': 'Pre-rating',
  'form.aiRating': 'AI Rating',
  'form.preRatingSuggestions': 'Suggestions',
  'form.aiRatingSuggestions': 'AI Suggestions',
  'form.requestRating': 'AI Feedback',
  'form.requestingRating': 'Rating...',
  'form.inconsistencies': 'Inconsistencies',
  'form.tags': 'Tags',
  'form.tagsHelp': 'Optional tags for categorization (e.g. @smoke, @regression, @sales). Separate multiple tags with spaces.',
  'form.tagsPlaceholder': '@smoke @login',
  'form.scenarios': 'Scenarios',
  'form.scenariosHelp': 'Each scenario describes a test case. Use templates for typical abas test patterns or create custom scenarios with building-block actions.',
  'form.scenario': 'Scenario',
  'form.duplicateScenario': 'Duplicate scenario',
  'form.template': 'Template:',
  'form.saveAsTemplate': '+ Save as template',
  'form.saveAsTemplateTitle': 'Save current scenario as template',
  'form.import': 'Import',
  'form.importTemplatesTitle': 'Import templates from JSON file',
  'form.export': 'Export',
  'form.exportTemplatesTitle': 'Export custom templates as JSON',
  'form.noTemplates': 'No custom templates available',
  'form.addEmptyScenario': '+ Empty Scenario',

  // ScenarioBuilder
  'scenario.namePlaceholder': 'Scenario name...',
  'scenario.nameLabel': 'Scenario name',
  'scenario.remove': 'Remove scenario',
  'scenario.commentPlaceholder': 'Comment / note (appears as # in Gherkin)...',
  'scenario.move': 'Move',
  'scenario.addStep': '+ Add Step',

  // StepRow
  'step.actionType': 'Action type',
  'step.keyword': 'Step keyword',
  'step.textPlaceholder': 'Step text...',
  'step.textLabel': 'Step text',
  'step.duplicate': 'Duplicate',
  'step.duplicateLabel': 'Duplicate step',
  'step.remove': 'Remove step',
  'step.multiFields': 'Multiple fields',
  'step.addTable': 'Data table',
  'step.removeTable': 'Remove table',
  'dataTable.addRow': '+ Row',
  'dataTable.removeRow': 'Remove row',
  'dataTable.addColumn': '+ Column',
  'dataTable.removeColumn': '- Column',
  'dataTable.fieldPlaceholder': 'Field name...',
  'dataTable.cellPlaceholder': '...',
  'step.editorName': 'Editor name *',
  'step.tableRef': 'Table (e.g. 0:1) *',
  'step.searchDb': 'Search database...',
  'step.fieldName': 'Field name *',
  'step.searchCriteria': 'Search criteria *',
  'step.record': 'Record *',
  'step.menuSelection': 'Menu selection *',
  'step.value': 'Value *',
  'step.row': 'R',
  'step.searchField': 'Search field...',
  'step.expectedValue': 'Expected value *',
  'step.empty': 'empty',
  'step.notEmpty': 'not empty',
  'step.editable': 'editable',
  'step.notEditable': 'not editable',
  'step.recordOptional': 'Record (empty for new)...',
  'step.buttonName': 'Button name (e.g. freig) *',
  'step.buttonNameRequired': 'Button name *',
  'step.subeditorName': 'Sub-editor name *',
  'step.label': 'Label',
  'step.searchWord': 'Search word *',
  'step.searchInfosystem': 'Search infosystem...',
  'step.count': 'Count *',
  'step.exceptionId': 'Exception ID *',
  'step.answer': 'Answer *',
  'step.dialogId': 'Dialog ID *',
  'step.insertRecord': 'Insert created record',

  // GherkinPreview
  'preview.empty': 'Fill in the form to generate Gherkin',

  // BulkImport
  'bulk.uploadXlsx': 'Upload XLSX',
  'bulk.downloadExample': 'Download example',
  'bulk.packagesLoaded': 'work packages loaded',
  'bulk.importTitle': 'Import work packages',
  'bulk.importDesc': 'Upload an XLSX file with work packages to automatically generate Gherkin tests.',
  'bulk.importColumns': 'Columns: Title, Description, Implementation time, QA time, Priority, Area',
  'bulk.downloadExampleBtn': 'Download example file',
  'bulk.testUserPlaceholder': 'Test user...',
  'bulk.generateAll': 'Generate all',
  'bulk.cancel': 'Cancel',
  'bulk.progress': '{current} / {total}',
  'bulk.downloadZip': 'Download ZIP ({done}/{total})',
  'bulk.colTitle': 'Title',
  'bulk.colArea': 'Area',
  'bulk.colPrio': 'Prio',
  'bulk.colTime': 'Time',
  'bulk.colActions': 'Actions',
  'bulk.download': 'Download',
  'bulk.edit': 'Edit',
  'bulk.generate': 'Generate',
  'bulk.retry': 'Retry',
  'bulk.done': 'Done',
  'bulk.error': 'Error',

  // CsvUpload
  'csv.loading': 'Loading...',
  'csv.uploadTable': 'Upload variable table',
  'csv.uploadDb': 'Upload variable table',
  'csv.uploadIs': 'Upload infosystems',
  'csv.tablesFields': '{tables} tables, {fields} fields',
  'csv.pasteText': 'Paste as text',
  'csv.pasteDbPlaceholder': 'Paste VARIABLENTABELLE output here (tab- or semicolon-separated)...',
  'csv.pasteIsPlaceholder': 'Paste INFOSYSTEM output here (tab- or semicolon-separated)...',
  'csv.variablentabelle': 'Variable table',
  'csv.infosystem': 'Infosystem',
  'csv.apply': 'Apply',
  'csv.parsedInfo': '{tables} tables, {fields} fields detected',
  'csv.exportHelpTitle': 'Show abas export search queries',
  'csv.exportNote': 'Export must be in English to get both German and English field names.',
  'csv.reimportHint': 'Re-import tables for bilingual display (DE/EN)',

  // DatabaseSelect
  'db.searchPlaceholder': 'Search database (No., name, keyword)...',
  'db.searchLabel': 'Search database',
  'db.removeLabel': 'Remove database',
  'db.noResults': 'No results',
  'db.fields': '{count} fields',

  // SettingsPanel
  'settings.aiSettings': 'AI Settings',
  'settings.model': 'Model',
  'settings.save': 'Save',
  'settings.systemPrompt': 'Generation: System Prompt',
  'settings.systemPromptCustomized': 'Generation: System Prompt (customized)',
  'settings.tableIdPrompt': 'Table Detection: Prompt',
  'settings.tableIdPromptCustomized': 'Table Detection: Prompt (customized)',
  'settings.ratingPrompt': 'AI Rating: Prompt',
  'settings.ratingPromptCustomized': 'AI Rating: Prompt (customized)',
  'settings.reset': 'Reset',
  'settings.login': 'Login',
  'settings.logout': 'Logout',
  'settings.clientId': 'Client ID',
  'settings.clientIdHint': 'OAuth Client ID of the application (from tenant configuration)',
  'settings.clientSecret': 'Client Secret',
  'settings.clientSecretHint': 'Required if OAuth server demands it (Confidential Client)',
  'settings.loggedInAs': 'Logged in as',
  'settings.notLoggedIn': 'Not logged in',
  'settings.tenant': 'Tenant',
  'settings.advanced': 'Advanced',
  'settings.authorize': 'Authorize',
  'settings.authorizeUrl': 'Authorize URL',
  'settings.redirecting': 'Redirecting...',
  'settings.loginModeRedirect': 'Redirect',
  'settings.loginModeManual': 'Manual',
  'settings.manualOpenLogin': 'Open login page',
  'settings.manualCodePlaceholder': 'Paste code or callback URL',
  'settings.manualCodeExchange': 'Exchange code',
  'settings.manualCodeHint': 'After login, copy the code from the URL and paste it here.',
  'settings.tokenUrl': 'Token URL',
  'settings.applicationId': 'Application ID',
  'settings.applicationIdHint': 'Target application for token scoping',
  'settings.loadingModels': 'Loading models...',
  'settings.loginError': 'Login failed',
  'settings.noTenants': 'No tenants found',
  'settings.noModels': 'No models available',
  'settings.tenantIdManual': 'Enter tenant ID',

  // HelpGuide
  'help.showHelp': 'Show help',
  'help.tabOverview': 'Overview',
  'help.tabFormat': 'Concept Format',

  // HelpGuide — Overview tab (EN)
  'help.overviewTitle': 'What does the cucumbergnerator do?',
  'help.overviewDesc': 'The cucumbergnerator generates structured Cucumber/Gherkin test scenarios for abas ERP from requirement texts (implementation concepts, customization descriptions).',

  'help.overviewArchTitle': 'Technical Architecture',
  'help.overviewArchDesc': '• React 18 + TypeScript, built with Vite\n• Runs entirely locally in the browser — no backend, no server, no installation\n• All logic (parsing, generation, validation) runs client-side\n• Styling via CSS Modules',
  'help.overviewArchStorage': '• Features and settings → localStorage\n• Variable tables and file handles → IndexedDB\n• No external server (except AI generation via MyForterro)',

  'help.overviewFlowTitle': 'Data Flow Pipeline',
  'help.overviewFlowDesc': '1. Input (text / DOCX / .feature)\n2. Parsing (rule-based or AI)\n3. FeatureInput data model — features with scenarios and typed steps\n    → 20 abas-specific action types (editorOpen, fieldSet, fieldCheck …)\n4. Gherkin generator (pure function) → formatted .feature text\n5. Preview / diagram / export',

  'help.overviewInputTitle': 'Input Methods',
  'help.overviewInputEditor': '• Editor — Manually build features with scenarios and steps. Each step has an action type with structured fields (editor name, table reference, command, etc.).',
  'help.overviewInputDocx': '• Concept Import (.docx) — Word documents are converted to HTML via mammoth.js, split into chapters at headings (H1/H2 or H2/H3, configurable). The relevant section is identified based on the profile (→ "Concept Format" tab). Structured action patterns are parsed via regex into typed steps.',
  'help.overviewInputBulk': '',
  'help.overviewInputFeature': '• .feature Import — Existing Gherkin files (.feature or ZIP) are parsed back into the internal data model (round-trip). English step texts are reverse-engineered via regex into typed actions.',

  'help.overviewGenTitle': 'Generation Methods',
  'help.overviewGenManual': '1. Manual (Building-Block Editor)\n    • Assemble steps with typed actions\n    • 20 action types: open editor, set/check field, press button, infosystem, exception, dialog, etc.\n    • 12 templates for typical abas tests speed up creation',
  'help.overviewGenRules': '2. Rule-based (no AI, during concept import)\n    • Recognize structured text patterns via regex, e.g.:\n      "Editor öffnen: Name, DB-Ref, Command"\n      "Feld setzen: fieldname = Value"\n    • Natural language variants: "Feld X auf Y setzen", "Speichern", etc.\n    • Custom action patterns definable via import profiles',
  'help.overviewGenAi': '3. AI-assisted (MyForterro)\n    • OAuth2 authentication with PKCE\n    • Multiple models (loaded automatically)\n    • System prompt defines all abas step formats and rules\n      (STORE for master data, NEW only for documents, search word schema, etc.)',
  'help.overviewGenAiSteps': '    AI generation in two steps:\n    (1) Table identification — which databases/infosystems are relevant?\n         Locally via keyword matching or via AI.\n    (2) Gherkin generation — requirement text + field definitions sent to AI.\n         For large field lists, progressive reduction is applied (y-fields prioritized).\n         Response is parsed and transferred into the data model.',

  'help.overviewOutputTitle': 'Output and Export',
  'help.overviewOutputDesc': '• Gherkin generator (pure function): FeatureInput → formatted .feature text\n    Feature column 0, Scenario 2 spaces, steps 4 spaces, data tables 6 spaces\n• Export as individual .feature file, all as ZIP archive, or print\n• Syntax highlighting in preview, flow diagram as alternative view',
  'help.overviewOutputExplorer': '• File Explorer (Chrome/Edge) — via the File System Access API, open a local directory. .feature files are read, edited, and written back with 2s debounce.',

  'help.overviewNote': 'All data stays locally in the browser (localStorage + IndexedDB). No data is sent to external servers — except when using AI generation via MyForterro.',

  'help.formatOverview': 'Concept Format — Overview',
  'help.formatOverviewDesc': 'If you follow this format in your concept, the cucumbergnerator can automatically generate Gherkin test scenarios — without AI. Upload your Word document via the "Concept Import" tab.',
  'help.formatProfilesTitle': 'Concept Profiles',
  'help.formatProfilesDesc': 'The cucumbergnerator supports two concept formats, controlled via import profiles. The profile is selected in Concept Import or in the settings.',
  'help.formatProfileStandardTitle': 'Standard Profile',
  'help.formatProfileStandardDesc': 'Document is split at H1/H2 headings. Chapters containing a "Technische Umsetzung" section are parsed — text before becomes the feature description, text after is searched for scenarios and actions. Chapters without this section are skipped.',
  'help.formatProfileEfkTitle': 'Implementation Concept (Forterro) — Default',
  'help.formatProfileEfkDesc': 'Document is split at H2/H3 headings. Relevant content ends at the "Auswirkungen der Customization/Extension" table. Everything before is used as requirement text. Additionally, the "Realisierung" and "Aufwand" fields are extracted from the impact table. Chapters without this table are skipped.',
  'help.formatProfileNote': 'By default, the "Einfuehrungskonzept (Forterro)" profile is active. Custom profiles can be created in the settings.',
  'help.structure': 'Structure',
  'help.headerSection': 'Header section',
  'help.perScenario': 'Per test scenario',
  'help.rulesCatalog': 'Rule Catalog — Structured Actions',
  'help.rulesCatalogDesc': 'After precondition/action/result, structured actions can be used. These are automatically converted into correct Cucumber steps. Values with spaces in "quotes". Anything not matching a pattern is used as free text.',
  'help.editorSection': 'Editor',
  'help.action': 'Action',
  'help.actionDescription': 'Description',
  'help.editorOpen': 'Editor open: Name, DB-Ref, Command',
  'help.editorOpenDesc': 'Open screen',
  'help.editorOpenRecord': 'Editor open: Name, DB-Ref, Cmd, Record ID',
  'help.editorOpenRecordDesc': 'With record',
  'help.editorOpenSearch': 'Editor open: Name, DB-Ref, Cmd, Search Criteria',
  'help.editorOpenSearchDesc': 'With search criteria',
  'help.editorOpenMenu': 'Editor open: Name, DB-Ref, Cmd, Record ID, Menu Selection',
  'help.editorOpenMenuDesc': 'With menu selection',
  'help.editorSave': 'Editor save',
  'help.editorSaveDesc': 'Save current editor',
  'help.editorClose': 'Editor close',
  'help.editorCloseDesc': 'Close current editor',
  'help.editorSwitch': 'Editor switch: Name',
  'help.editorSwitchDesc': 'Switch to another editor',
  'help.commands': 'Commands:',
  'help.fieldsSection': 'Fields',
  'help.fieldSet': 'Field set: fieldname = "Value"',
  'help.fieldSetDesc': 'Set field to value',
  'help.fieldSetRow': 'Field set: fieldname = "Value", Row 3',
  'help.fieldSetRowDesc': 'In specific row',
  'help.fieldCheck': 'Field check: fieldname = "Value"',
  'help.fieldCheckDesc': 'Check value',
  'help.fieldCheckRow': 'Field check: fieldname = "Value", Row 3',
  'help.fieldEmpty': 'Field empty: fieldname',
  'help.fieldEmptyDesc': 'Field must be empty',
  'help.fieldNotEmpty': 'Field not empty: fieldname',
  'help.fieldNotEmptyDesc': 'Field must not be empty',
  'help.fieldEditable': 'Field editable: fieldname',
  'help.fieldEditableDesc': 'Field must be editable',
  'help.fieldLocked': 'Field locked: fieldname',
  'help.fieldLockedDesc': 'Field must be locked',
  'help.tableButtonSection': 'Table / Buttons',
  'help.addRow': 'Add row',
  'help.addRowDesc': 'New table row at end',
  'help.checkRowCount': 'Table has 5 rows',
  'help.checkRowCountDesc': 'Check row count',
  'help.pressButton': 'Press button: buttonname',
  'help.pressButtonDesc': 'Click button in editor',
  'help.openSubeditor': 'Open sub-editor: button, name',
  'help.openSubeditorDesc': 'Open sub-editor',
  'help.openSubeditorRow': 'Open sub-editor: button, name, Row 3',
  'help.appendRows': 'Append rows (with data table)',
  'help.appendRowsDesc': 'Append multiple rows compactly',
  'help.pressButtonRow': 'Press button: buttonname, Row 3',
  'help.fieldEmptyRow': 'Field empty: fieldname, Row 3',
  'help.fieldNotEmptyRow': 'Field not empty: fieldname, Row 3',
  'help.fieldEditableRow': 'Field editable: fieldname, Row 3',
  'help.fieldLockedRow': 'Field locked: fieldname, Row 3',
  'help.naturalVariantsTitle': 'Natural language alternatives',
  'help.naturalVariantsDesc': 'In addition to the patterns above, natural language phrasings are also recognized:',
  'help.naturalVariants': 'Feld X auf Y setzen  •  Feld X zeigt Y  •  Feld X hat Wert Y  •  Feld X ist leer  •  Feld X ist nicht leer  •  Feld X ist aenderbar  •  Feld X ist gesperrt  •  Speichern  •  Schliessen  •  Fehlermeldung X erscheint',
  'help.infosystemSection': 'Infosystem / Exceptions / Dialogs',
  'help.openInfosystem': 'Open infosystem: name',
  'help.openInfosystemDesc': 'Start infosystem',
  'help.exceptionSave': 'Exception on save: ID',
  'help.exceptionSaveDesc': 'Expect error on save',
  'help.exceptionField': 'Exception on field: field = "Value", Exception ID',
  'help.exceptionFieldDesc': 'Error on field value',
  'help.answerDialog': 'Answer dialog: ID, Answer Yes',
  'help.answerDialogDesc': 'Answer dialog',
  'help.fullExample': 'Full example',

  // HelpGuide — Usage tab
  'help.tabUsage': 'Usage',
  'help.usageIntro': 'The cucumbergnerator has two main views: Editor and Concept Import. All data stays locally in the browser.',
  'help.usageEditorTitle': 'Editor — Main View',
  'help.usageEditorDesc': 'The main view is split in two: the form on the left, the preview on the right. The divider between both sides can be dragged with the mouse.',
  'help.usageFeatureTabsTitle': 'Feature Tabs',
  'help.usageFeatureTabsDesc': 'Features are shown as tabs at the top of the form. Use "+" to create a new feature. Each tab can be duplicated or closed. All features are automatically saved in the browser.',
  'help.usageScenariosTitle': 'Scenarios',
  'help.usageScenariosDesc': 'Each feature can contain any number of scenarios. Scenarios can be reordered via drag & drop, duplicated, and deleted. Use "+ Empty Scenario" to add a blank scenario.',
  'help.usageStepsTitle': 'Steps (Building-Block Actions)',
  'help.usageStepsDesc': 'Each step consists of a keyword (Given/When/Then/And/But) and a structured action. The "Action type" dropdown provides all typical abas actions: Open editor (incl. search and menu), Set field (single or multiple), Check field, Field empty/not empty, Field editable, Save/close/switch editor, Add row, Append rows (compact with data table), Press button, Open sub-editor, Open infosystem, Table row count, Exception (save/field), Answer dialog, and Free text.',
  'help.usagePreviewTitle': 'Preview (Text / Diagram)',
  'help.usagePreviewDesc': 'The right side shows the generated Gherkin output. Switch between "Text" (syntax-highlighted Gherkin) and "Diagram" (flow diagram of scenarios). From here you can copy, download, or print.',
  'help.usageTemplatesTitle': 'Templates',
  'help.usageTemplatesDesc': 'Templates speed up the creation of typical test scenarios. They are available via the "Template" dropdown on each scenario.',
  'help.usageTemplatesBuiltin': '12 built-in templates for typical abas tests: Check field, Create record, Field validation, Table rows, Infosystem, Process/Workflow, Button/Sub-editor, Dialog, Search-based opening, and more.',
  'help.usageTemplatesCustom': 'Custom templates: Use "+ Save as template" to save the current scenario as a custom template. Custom templates appear in the dropdown and can also be deleted there.',
  'help.usageTemplatesImportExport': 'Template import/export: Custom templates can be exported as JSON and imported on other machines (buttons "Import" / "Export" in the template area).',
  'help.usageImportExportTitle': 'Import / Export',
  'help.usageImportFeature': 'Load .feature / ZIP: Existing .feature files or ZIP archives with .feature files can be imported via the toolbar button. Files are parsed and loaded as feature tabs.',
  'help.usageExportFeature': 'Download .feature: The download button in the preview saves the current feature as a .feature file.',
  'help.usageExportZip': 'All as ZIP: With multiple features, the "All as ZIP" button appears, downloading all features bundled as a ZIP archive.',
  'help.usageCsvTitle': 'Variable Table (CSV/XLSX)',
  'help.usageCsvDesc': 'Via "Upload variable table" in the toolbar, a CSV or XLSX file with table and field definitions can be loaded. Afterwards, fields are available for auto-completion in database search and step fields.',
  'help.usageUndoRedoTitle': 'Undo / Redo',
  'help.usageUndoRedoDesc': 'All changes can be undone with Ctrl+Z (Undo) and Ctrl+Y (Redo). "Reset all" deletes all features and scenarios.',
  'help.usageAiTitle': 'AI Generation',
  'help.usageAiDesc': 'With a MyForterro login, scenarios can be automatically generated from requirement texts.',
  'help.usageAiSetup': 'Setup: Click "Not logged in" top right → enter Application ID and Secret (from MyForterro). After login, select a tenant — then the "Generate scenarios" button appears in the form.',
  'help.usageAiModel': 'Model: In the settings, available AI models can be selected. Models are loaded automatically from the MyForterro API.',
  'help.usageAiPrompt': 'System prompt: The system prompt controls how the AI generates scenarios. It can be customized in the settings and reset if needed.',
  'help.usageAiGenerate': 'Generate: Enter requirement text in the description field → click "Generate scenarios" → the AI creates matching scenarios that can then be adjusted in the editor.',
  'help.usageBulkTitle': '',
  'help.usageBulkDesc': '',
  'help.usageBulkSteps': '',
  'help.usageDocxTitle': 'Concept Import (DOCX)',
  'help.usageDocxDesc': 'Via the "Concept Import" tab, Word documents (.docx) with implementation concepts can be imported directly.',
  'help.usageDocxSteps': '1. Upload DOCX file — the document is split into individual features by headings.\n2. Without AI: If the document follows the concept format (see "Concept Format" tab), scenarios are parsed directly from the text.\n3. With AI: The "AI Enhancement" button can enrich parsed scenarios with AI.\n4. "Import all" loads all features into the editor. Individual features can also be edited separately.',
  'help.usageProfilesTitle': 'Import Profiles',
  'help.usageProfilesDesc': 'Import profiles control how Word documents and texts are parsed. They define the keywords used to recognize scenarios, steps, and actions.',
  'help.usageProfilesKeywords': 'Keywords: Each profile has feature keywords (Feature, Database, Test user, Tags, Scenario, Comment) and step keywords (Precondition, Action, Result, And, But). Multiple aliases per keyword are possible (comma-separated).',
  'help.usageProfilesCustomActions': 'Custom action patterns: Regex patterns can define custom actions that are automatically recognized during parsing and converted into Cucumber steps. Each pattern has a label, a regex, and a step text with placeholders ({1}, {2}, etc.).',
  'help.usageSettingsTitle': 'Settings',
  'help.usageSettingsDesc': 'All settings (API key, model, system prompt, import profiles) are accessed via the gear icon top right. Changes are saved immediately in the browser.',

  // FlowDiagram
  'flow.scenario': 'Scenario',
  'flow.unnamed': 'Unnamed',
  'flow.emptyState': 'Add scenarios to see the flow diagram',
  'flow.freetext': 'Free text',
  'flow.empty': 'empty',
  'flow.notEmpty': 'not empty',
  'flow.editable': 'editable',
  'flow.notEditable': 'not editable',
  'flow.row': 'R.',

  // FieldValueEditor
  'fieldEditor.field': 'Field',
  'fieldEditor.value': 'Value',
  'fieldEditor.fieldPlaceholder': 'Field name...',
  'fieldEditor.valuePlaceholder': 'Value...',
  'fieldEditor.removeField': 'Remove field',
  'fieldEditor.addField': '+ Field',

  // TableFieldSelect
  'tableField.searchTable': 'Search table...',
  'tableField.searchField': 'Search field...',
  'tableField.noResults': 'No results',
  'tableField.fields': '{count} fields',

  // DocxImport
  'docx.upload': 'Upload .docx',
  'docx.downloadTemplate': 'Download template',
  'docx.profile': 'Profile:',
  'docx.featuresDetected': '{count} feature(s) detected',
  'docx.skipped': ', {count} skipped',
  'docx.loading': 'Processing document...',
  'docx.emptyTitle': 'Import concept document',
  'docx.emptyDesc1': 'Upload a Word document (.docx) containing your test features.',
  'docx.emptyDesc2': 'Use headings (H1/H2) to separate features.',
  'docx.emptyDesc3': 'Within each section: Scenario, Precondition, Action, Result.',
  'docx.importAll': 'Import all ({importable}/{total})',
  'docx.rateAll': 'Rate all ({count})',
  'docx.aiGenerate': 'AI generate tests ({count})',
  'docx.cancel': 'Cancel',
  'docx.aiProgress': 'AI generating tests {current}/{total}',
  'docx.aiStepTables': '(Identifying tables...)',
  'docx.aiStepScenarios': '(Generating scenarios...)',
  'docx.ratingProgress': 'AI rating feature {current}/{total}',
  'docx.aiEnhanceError': 'AI enhancement: {errorCount} of {total} features could not be processed.',
  'docx.tokenLimitReached': 'Daily AI token limit reached. Please try again tomorrow or contact support to increase your limit.',
  'docx.ratingError': 'AI rating: {errorCount} of {total} features could not be rated.',
  'docx.noFeatures': 'No features detected in document. Use headings (H1/H2) as separators.',
  'docx.profileChanged': 'Profile changed — please re-upload the document.',
  'docx.notLoggedIn': 'Not logged in. Please log in first.',
  'docx.ratingParseError': 'AI response could not be parsed as rating.',
  'docx.ratingFailed': 'Error during AI rating',
  'docx.readError': 'Error reading file: {error}',
  'docx.noTablesWarning': 'No variable table loaded. AI generation will produce less accurate results without database/field context. Continue anyway?',
  'docx.contextFiles': 'Required context files',
  'docx.efkAgent': 'EFK Agent',
  'docx.createEfkAgent': 'Create EFK agent',
  'docx.efkAgentName': 'Name for the EFK agent:',
  'docx.noAgent': 'Without agent',
  'docx.selectExistingAgent': 'Select existing agent',
  'docx.newAgent': 'Create new agent',
  'docx.noAgentSelected': '-- Select agent --',
  'docx.agentRequired': 'Please select or create an EFK agent',
  'docx.agentActive': 'Agent: {name}',
  'docx.agentCreating': 'Creating agent...',
  'docx.deleteEfkAgent': 'Delete agent',
  'docx.efkAgentCreated': 'EFK agent created',
  'docx.efkChat': 'Chat with agent',
  'docx.efkChatHint': 'Note: The agent only knows work packages that have already been rated or generated — not the full EFK document.',
  'docx.efkChatEmpty': 'Ask the agent a question about the work packages already processed.',
  'docx.efkChatPlaceholder': 'Question for the agent... (Enter = Send)',
  'docx.skippedChapters': 'Skipped chapters',
  'docx.noName': '(No name)',
  'docx.scenarioStats': '{scenarios} scenario(s), {steps} steps',
  'docx.edit': 'Edit',
  'docx.remove': 'Remove',
  'docx.aiFeedback': 'AI Feedback',
  'docx.rating': 'Rating...',
  'docx.inconsistencies': 'Inconsistencies',
  'docx.notSet': '(not set)',
  'docx.description': 'Description:',
  'docx.testUser': 'Test user:',
  'docx.tags': 'Tags:',
  'docx.noTags': '(none)',
  'docx.unnamedScenario': '(Unnamed scenario)',
  'docx.noSteps': 'No steps',
  'docx.noScenarios': 'No scenarios detected',

  // SettingsPanel — additional
  'settings.clientIdLabel': 'Client ID',
  'settings.clientSecretLabel': 'Client Secret',
  'settings.hide': 'Hide',
  'settings.show': 'Show',
  'settings.apiBaseUrl': 'API Base URL',
  'settings.tenantDisplay': 'Tenant: {tenantId}',
  'settings.loadModelsError': 'Error loading models',
  'settings.importProfiles': 'Import Profiles ({name})',
  'settings.profileNew': '+ New',
  'settings.profileImport': 'Import',
  'settings.profileExport': 'Export',
  'settings.profileDelete': 'Delete',
  'settings.profileEditClose': 'Close editing',
  'settings.profileEditOpen': 'Edit keywords',
  'settings.profileSave': 'Save profile',
  'settings.profileDefault': '(Default)',
  'settings.profileNewName': 'Name for new profile:',
  'settings.profileNewDefault': 'My Profile',
  'settings.profileInvalid': 'Invalid profile file.',
  'settings.featureKeywords': 'Feature keywords (comma-separated)',
  'settings.stepKeywords': 'Step keywords (comma-separated)',
  'settings.headingLevels': 'Splitting (heading levels)',
  'settings.levels': 'Levels:',
  'settings.techSection': 'Tech section:',
  'settings.customActions': 'Custom action patterns ({count})',
  'settings.addPattern': '+ Pattern',
  'settings.removePattern': 'Remove',

  // FeatureForm — additional
  'form.removeTemplate': 'Remove template',

  // App — additional
  'app.docxImport': 'Concept Import',

  // Settings — ProfileEditor labels
  'settings.kwFeature': 'Feature',
  'settings.kwDatabase': 'Database',
  'settings.kwTestUser': 'Test user',
  'settings.kwTags': 'Tags',
  'settings.kwDescription': 'Description',
  'settings.kwScenario': 'Scenario',
  'settings.kwComment': 'Comment',
  'settings.skPrecondition': 'Precondition',
  'settings.skAction': 'Action',
  'settings.skResult': 'Result',
  'settings.skAnd': 'And',
  'settings.skBut': 'But',
  'settings.placeholderEg': 'e.g.',
  'settings.placeholderLevels': 'e.g. 1, 2',
  'settings.placeholderTechSection': 'e.g. Technical implementation',
  'settings.placeholderCustomLabel': 'e.g. Start workflow',

  // HelpGuide — strong labels
  'help.labelBuiltinTemplates': 'Built-in templates:',
  'help.labelCustomTemplates': 'Custom templates:',
  'help.labelImportExport': 'Import/Export:',
  'help.labelSetup': 'Setup:',
  'help.labelModel': 'Model:',
  'help.labelPrompt': 'System prompt:',
  'help.labelGenerate': 'Generate:',

  // HelpGuide — format notes
  'help.headerNote': '(all optional except Feature):',
  'help.scenarioNote': '(Precondition/Action/Result can appear multiple times):',

  // HelpGuide — code blocks
  'help.commonStepsCode': '# Open editor (NEW, UPDATE, STORE, VIEW, DELETE, COPY)\nGiven I open an editor "Name" from table "DD:GG" with command "CMD" for record "ID"\n\n# Set fields\nAnd I set field "fieldname" to "value"\nAnd I set field "fieldname" to "value" in row 1\n\n# Check fields\nThen field "fieldname" has value "value"\nThen field "fieldname" is empty\nThen field "fieldname" is modifiable\n\n# Save/close editor\nAnd I save the current editor\nAnd I close the current editor\n\n# Create table row\nAnd I create a new row at the end of the table\n\n# Press button\nAnd I press button "buttonname"\n\n# Test errors\nThen saving the current editor throws the exception "ID"\n\n# Infosystem\nGiven I open the infosystem "Name"',
  'help.headerFormatCode': 'Feature:       Feature name (required)\nDatabase:      abas database number (e.g. 1000)\nTest user:     Login user (e.g. sy)\nTags:          Comma-separated tags (e.g. @smoke, @sales)\nDescription:   Short description of the requirement',
  'help.scenarioFormatCode': 'Scenario:      Scenario name\nComment:       Optional comment (becomes # in test)\nPrecondition:  What must be given\nAction:        What is done\nResult:        What is expected\nAnd:           Additional step\nBut:           Exception / counter-check',
  'help.fullExampleCode': 'Feature: Extend customer classification\nDatabase: 1000\nTest user: sy\nTags: @smoke, @sales\nDescription: New field ykundenkategorie in customer master\n\nScenario: Set field and save\nPrecondition: Editor open: Kundenstamm, 0:1, NEW\nAction: Field set: ykundenkategorie = "A-Kunde"\nAction: Editor save\nResult: Field check: ykundenkategorie = "A-Kunde"\n\nScenario: Catch invalid category\nPrecondition: Editor open: Kundenstamm, 0:1, NEW\nAction: Field set: ykundenkategorie = ""\nResult: Exception on save: EX-KATEGORIE\n\nScenario: Check classification in infosystem\nPrecondition: Open infosystem: KUNDENUEBERSICHT\nResult: Table has 1 rows\nResult: Field check: ykundenkategorie = "A-Kunde", Row 1',

  // HelpGuide — common table names
  'help.tableCustomers': 'Customers',
  'help.tableArticles': 'Articles/Products',
  'help.tableSalesOrders': 'Sales Orders',
  'help.tablePurchaseOrders': 'Purchase Orders',
  'help.tableVendors': 'Vendors',
  'help.tableProductionOrders': 'Production Orders',
  'help.tableServiceOrders': 'Service Orders',
};

export const translations: Record<Language, Translations> = { de, en };
