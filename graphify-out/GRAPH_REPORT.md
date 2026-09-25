# Graph Report - E:\DEV\cucumbergenerator2  (2026-04-19)

## Corpus Check
- 139 files · ~205,784 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 791 nodes · 1220 edges · 100 communities detected
- Extraction: 79% EXTRACTED · 21% INFERRED · 0% AMBIGUOUS · INFERRED: 253 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 38|Community 38]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 40|Community 40]]
- [[_COMMUNITY_Community 41|Community 41]]
- [[_COMMUNITY_Community 42|Community 42]]
- [[_COMMUNITY_Community 43|Community 43]]
- [[_COMMUNITY_Community 44|Community 44]]
- [[_COMMUNITY_Community 45|Community 45]]
- [[_COMMUNITY_Community 46|Community 46]]
- [[_COMMUNITY_Community 47|Community 47]]
- [[_COMMUNITY_Community 48|Community 48]]
- [[_COMMUNITY_Community 49|Community 49]]
- [[_COMMUNITY_Community 50|Community 50]]
- [[_COMMUNITY_Community 51|Community 51]]
- [[_COMMUNITY_Community 52|Community 52]]
- [[_COMMUNITY_Community 53|Community 53]]
- [[_COMMUNITY_Community 54|Community 54]]
- [[_COMMUNITY_Community 55|Community 55]]
- [[_COMMUNITY_Community 56|Community 56]]
- [[_COMMUNITY_Community 57|Community 57]]
- [[_COMMUNITY_Community 58|Community 58]]
- [[_COMMUNITY_Community 59|Community 59]]
- [[_COMMUNITY_Community 60|Community 60]]
- [[_COMMUNITY_Community 61|Community 61]]
- [[_COMMUNITY_Community 62|Community 62]]
- [[_COMMUNITY_Community 63|Community 63]]
- [[_COMMUNITY_Community 64|Community 64]]
- [[_COMMUNITY_Community 65|Community 65]]
- [[_COMMUNITY_Community 66|Community 66]]
- [[_COMMUNITY_Community 67|Community 67]]
- [[_COMMUNITY_Community 68|Community 68]]
- [[_COMMUNITY_Community 69|Community 69]]
- [[_COMMUNITY_Community 70|Community 70]]
- [[_COMMUNITY_Community 71|Community 71]]
- [[_COMMUNITY_Community 72|Community 72]]
- [[_COMMUNITY_Community 73|Community 73]]
- [[_COMMUNITY_Community 74|Community 74]]
- [[_COMMUNITY_Community 75|Community 75]]
- [[_COMMUNITY_Community 76|Community 76]]
- [[_COMMUNITY_Community 77|Community 77]]
- [[_COMMUNITY_Community 78|Community 78]]
- [[_COMMUNITY_Community 79|Community 79]]
- [[_COMMUNITY_Community 80|Community 80]]
- [[_COMMUNITY_Community 81|Community 81]]
- [[_COMMUNITY_Community 82|Community 82]]
- [[_COMMUNITY_Community 83|Community 83]]
- [[_COMMUNITY_Community 84|Community 84]]
- [[_COMMUNITY_Community 85|Community 85]]
- [[_COMMUNITY_Community 86|Community 86]]
- [[_COMMUNITY_Community 87|Community 87]]
- [[_COMMUNITY_Community 88|Community 88]]
- [[_COMMUNITY_Community 89|Community 89]]
- [[_COMMUNITY_Community 90|Community 90]]
- [[_COMMUNITY_Community 91|Community 91]]
- [[_COMMUNITY_Community 92|Community 92]]
- [[_COMMUNITY_Community 93|Community 93]]
- [[_COMMUNITY_Community 94|Community 94]]
- [[_COMMUNITY_Community 95|Community 95]]
- [[_COMMUNITY_Community 96|Community 96]]
- [[_COMMUNITY_Community 97|Community 97]]
- [[_COMMUNITY_Community 98|Community 98]]
- [[_COMMUNITY_Community 99|Community 99]]

## God Nodes (most connected - your core abstractions)
1. `generatePackage()` - 49 edges
2. `getStored()` - 21 edges
3. `openDb()` - 20 edges
4. `runGenerationLoop()` - 15 edges
5. `getValidToken()` - 15 edges
6. `setStored()` - 14 edges
7. `log()` - 13 edges
8. `warn()` - 13 edges
9. `loginWithClientCredentials()` - 12 edges
10. `FopCache` - 11 edges

## Surprising Connections (you probably didn't know these)
- `handleStart()` --calls--> `isLoggedIn()`  [INFERRED]
  E:\DEV\cucumbergenerator2\src\components\BulkImport\BulkImport.tsx → E:\DEV\cucumbergenerator2\src\lib\myforterroApi.ts
- `loadModels()` --calls--> `listModels()`  [INFERRED]
  E:\DEV\cucumbergenerator2\src\components\SettingsPanel\SettingsPanel.tsx → E:\DEV\cucumbergenerator2\src\lib\myforterroApi.ts
- `handleMethodChange()` --calls--> `setLoginMethod()`  [INFERRED]
  E:\DEV\cucumbergenerator2\src\components\SettingsPanel\SettingsPanel.tsx → E:\DEV\cucumbergenerator2\src\lib\myforterroApi.ts
- `handleLogout()` --calls--> `logout()`  [INFERRED]
  E:\DEV\cucumbergenerator2\src\components\SettingsPanel\SettingsPanel.tsx → E:\DEV\cucumbergenerator2\src\lib\myforterroApi.ts
- `clearTableDefs()` --calls--> `openDb()`  [INFERRED]
  E:\DEV\cucumbergenerator2\src\lib\csvTableParser.ts → E:\DEV\cucumbergenerator2\src\lib\idb.ts

## Communities

### Community 0 - "Community 0"
Cohesion: 0.03
Nodes (69): handleProfileChange(), handleUseOwnKeyAndRetry(), buildFopAnalystPrompt(), buildFopGuidelinesPrompt(), openRouterChatCompletion(), createNewProfile(), exportProfileAsJson(), getActiveProfile() (+61 more)

### Community 1 - "Community 1"
Cohesion: 0.05
Nodes (58): batchTablesBySize(), buildAssumeExistsBlock(), buildDialogCatalogBlock(), buildKeywordExtractionMessages(), buildMessages(), buildMessagesWithFields(), buildRatingMessages(), buildTableIdentificationMessages() (+50 more)

### Community 2 - "Community 2"
Cohesion: 0.09
Nodes (62): isRateLimitMessage(), warn(), chatCompletion(), chatWithAgent(), chatWithAgentSync(), clearSessionAndNotify(), createMftAgent(), deleteMftAgent() (+54 more)

### Community 3 - "Community 3"
Cohesion: 0.06
Nodes (38): deleteAgent(), loadAgents(), saveAgent(), clearDirectoryHandle(), clearFopDirectoryHandle(), copyDirectoryContents(), isFileSystemAccessSupported(), loadDirectoryHandle() (+30 more)

### Community 4 - "Community 4"
Cohesion: 0.1
Nodes (24): handleTablesChange(), clearTableDefs(), detectColumnMapping(), isTableLevelDesc(), isTableSectionValue(), loadTableDefs(), mergeTableDefs(), migrateTableDefsFromLocalStorage() (+16 more)

### Community 5 - "Community 5"
Cohesion: 0.1
Nodes (23): buildTableSourceText(), collectFullText(), collectPlainText(), decodeQuotedPrintable(), extractAllHeadings(), extractFieldGroups(), extractHtmlFromMime(), extractSections() (+15 more)

### Community 6 - "Community 6"
Cohesion: 0.09
Nodes (20): async(), handleDownloadAllZip(), handleFeatureFileChange(), handleGenerate(), resolveImportFolder(), updateFeature(), sanitizeName(), writeFeatureFile() (+12 more)

### Community 7 - "Community 7"
Cohesion: 0.13
Nodes (21): parseRatingResponse(), generateViaAgent(), getUniqueKeyForPkg(), handleAiGenerate(), handleBulkRating(), handleCreateWithAgent(), handleDismissTokenLimit(), handler() (+13 more)

### Community 8 - "Community 8"
Cohesion: 0.11
Nodes (20): createDefaultAction(), stepTextFromAction(), collectExistingSearchWords(), extractCreatedRecords(), generateSearchWord(), addStep(), createStepsFromToolbox(), handleDragOver() (+12 more)

### Community 9 - "Community 9"
Cohesion: 0.09
Nodes (18): ElapsedTimer(), toLocaleString(), DataStatusBar(), buildSearchTerms(), containsMatch(), findRelevantChains(), getCachedChunks(), scoreAndRank() (+10 more)

### Community 10 - "Community 10"
Cohesion: 0.12
Nodes (8): pkgExistsOnDisk(), buildGuidInput(), generateFeatureGuid(), makeFeatureGuid(), makeFopGuid(), createFeatureFile(), generateCucumberFromAnalysis(), generateCucumberFromFopAnalysis()

### Community 11 - "Community 11"
Cohesion: 0.24
Nodes (18): build_parser(), cmd_chat(), cmd_models(), cmd_tenants(), cmd_token(), debug(), decode_jwt(), err() (+10 more)

### Community 12 - "Community 12"
Cohesion: 0.16
Nodes (7): FopBufferTracker, trackBuffers(), typeToDatabase(), lookupCommonField(), lookupInVarTables(), resolveAllFields(), resolveField()

### Community 13 - "Community 13"
Cohesion: 0.12
Nodes (10): handleCopy(), handleDownload(), handleDownloadAll(), handleDownloadOne(), handleFileChange(), handleStart(), copyToClipboard(), downloadFeatureFile() (+2 more)

### Community 14 - "Community 14"
Cohesion: 0.28
Nodes (13): buildStepAliasMap(), fuzzyMaxDistance(), isPlaceholder(), levenshtein(), makeStep(), matchKeyword(), matchStepAlias(), parseActionFromText() (+5 more)

### Community 15 - "Community 15"
Cohesion: 0.25
Nodes (1): FopCache

### Community 16 - "Community 16"
Cohesion: 0.42
Nodes (7): buildFopTree(), buildNode(), detectInfosystemPattern(), findFop(), getMaxDepth(), normalizePath(), traverseBottomUpLevels()

### Community 17 - "Community 17"
Cohesion: 0.39
Nodes (6): buildLookups(), findMatch(), isNumericRef(), normalizeVNotation(), resolveAction(), resolveTableRefs()

### Community 18 - "Community 18"
Cohesion: 0.29
Nodes (0): 

### Community 19 - "Community 19"
Cohesion: 0.29
Nodes (0): 

### Community 20 - "Community 20"
Cohesion: 0.38
Nodes (3): isCertainFopFile(), isCertainlyNotFop(), scanDirectory()

### Community 21 - "Community 21"
Cohesion: 0.48
Nodes (5): checkNamingConvention(), extractMaskReferences(), parseFopSource(), parseHeader(), resolveTypeToDatabase()

### Community 22 - "Community 22"
Cohesion: 0.4
Nodes (2): collectFiles(), handleOpenDirectory()

### Community 23 - "Community 23"
Cohesion: 0.33
Nodes (2): useTranslation(), StepRow()

### Community 24 - "Community 24"
Cohesion: 0.33
Nodes (3): isMftTenantOrAuthError(), RateLimitError, TokenLimitError

### Community 25 - "Community 25"
Cohesion: 0.7
Nodes (4): buildHierarchy(), chunkDocument(), detectSections(), splitLargeSection()

### Community 26 - "Community 26"
Cohesion: 0.5
Nodes (0): 

### Community 27 - "Community 27"
Cohesion: 0.67
Nodes (2): EventChip(), getCategory()

### Community 28 - "Community 28"
Cohesion: 0.5
Nodes (0): 

### Community 29 - "Community 29"
Cohesion: 0.5
Nodes (0): 

### Community 30 - "Community 30"
Cohesion: 0.5
Nodes (0): 

### Community 31 - "Community 31"
Cohesion: 0.5
Nodes (0): 

### Community 32 - "Community 32"
Cohesion: 0.5
Nodes (0): 

### Community 33 - "Community 33"
Cohesion: 0.5
Nodes (0): 

### Community 34 - "Community 34"
Cohesion: 0.83
Nodes (3): checkGuidelinesLocal(), finding(), scoreFromFindings()

### Community 35 - "Community 35"
Cohesion: 0.5
Nodes (0): 

### Community 36 - "Community 36"
Cohesion: 0.67
Nodes (2): highlightLine(), highlightStrings()

### Community 37 - "Community 37"
Cohesion: 0.67
Nodes (0): 

### Community 38 - "Community 38"
Cohesion: 1.0
Nodes (2): handleKeyDown(), handleSend()

### Community 39 - "Community 39"
Cohesion: 0.67
Nodes (0): 

### Community 40 - "Community 40"
Cohesion: 0.67
Nodes (0): 

### Community 41 - "Community 41"
Cohesion: 0.67
Nodes (0): 

### Community 42 - "Community 42"
Cohesion: 0.67
Nodes (0): 

### Community 43 - "Community 43"
Cohesion: 0.67
Nodes (0): 

### Community 44 - "Community 44"
Cohesion: 1.0
Nodes (0): 

### Community 45 - "Community 45"
Cohesion: 1.0
Nodes (0): 

### Community 46 - "Community 46"
Cohesion: 1.0
Nodes (0): 

### Community 47 - "Community 47"
Cohesion: 1.0
Nodes (0): 

### Community 48 - "Community 48"
Cohesion: 1.0
Nodes (0): 

### Community 49 - "Community 49"
Cohesion: 1.0
Nodes (0): 

### Community 50 - "Community 50"
Cohesion: 1.0
Nodes (0): 

### Community 51 - "Community 51"
Cohesion: 1.0
Nodes (0): 

### Community 52 - "Community 52"
Cohesion: 1.0
Nodes (0): 

### Community 53 - "Community 53"
Cohesion: 1.0
Nodes (0): 

### Community 54 - "Community 54"
Cohesion: 1.0
Nodes (0): 

### Community 55 - "Community 55"
Cohesion: 1.0
Nodes (0): 

### Community 56 - "Community 56"
Cohesion: 1.0
Nodes (0): 

### Community 57 - "Community 57"
Cohesion: 1.0
Nodes (0): 

### Community 58 - "Community 58"
Cohesion: 1.0
Nodes (0): 

### Community 59 - "Community 59"
Cohesion: 1.0
Nodes (0): 

### Community 60 - "Community 60"
Cohesion: 1.0
Nodes (0): 

### Community 61 - "Community 61"
Cohesion: 1.0
Nodes (0): 

### Community 62 - "Community 62"
Cohesion: 1.0
Nodes (0): 

### Community 63 - "Community 63"
Cohesion: 1.0
Nodes (0): 

### Community 64 - "Community 64"
Cohesion: 1.0
Nodes (0): 

### Community 65 - "Community 65"
Cohesion: 1.0
Nodes (0): 

### Community 66 - "Community 66"
Cohesion: 1.0
Nodes (0): 

### Community 67 - "Community 67"
Cohesion: 1.0
Nodes (0): 

### Community 68 - "Community 68"
Cohesion: 1.0
Nodes (0): 

### Community 69 - "Community 69"
Cohesion: 1.0
Nodes (0): 

### Community 70 - "Community 70"
Cohesion: 1.0
Nodes (0): 

### Community 71 - "Community 71"
Cohesion: 1.0
Nodes (0): 

### Community 72 - "Community 72"
Cohesion: 1.0
Nodes (0): 

### Community 73 - "Community 73"
Cohesion: 1.0
Nodes (0): 

### Community 74 - "Community 74"
Cohesion: 1.0
Nodes (0): 

### Community 75 - "Community 75"
Cohesion: 1.0
Nodes (0): 

### Community 76 - "Community 76"
Cohesion: 1.0
Nodes (0): 

### Community 77 - "Community 77"
Cohesion: 1.0
Nodes (0): 

### Community 78 - "Community 78"
Cohesion: 1.0
Nodes (0): 

### Community 79 - "Community 79"
Cohesion: 1.0
Nodes (0): 

### Community 80 - "Community 80"
Cohesion: 1.0
Nodes (0): 

### Community 81 - "Community 81"
Cohesion: 1.0
Nodes (0): 

### Community 82 - "Community 82"
Cohesion: 1.0
Nodes (0): 

### Community 83 - "Community 83"
Cohesion: 1.0
Nodes (0): 

### Community 84 - "Community 84"
Cohesion: 1.0
Nodes (0): 

### Community 85 - "Community 85"
Cohesion: 1.0
Nodes (0): 

### Community 86 - "Community 86"
Cohesion: 1.0
Nodes (0): 

### Community 87 - "Community 87"
Cohesion: 1.0
Nodes (0): 

### Community 88 - "Community 88"
Cohesion: 1.0
Nodes (0): 

### Community 89 - "Community 89"
Cohesion: 1.0
Nodes (0): 

### Community 90 - "Community 90"
Cohesion: 1.0
Nodes (0): 

### Community 91 - "Community 91"
Cohesion: 1.0
Nodes (0): 

### Community 92 - "Community 92"
Cohesion: 1.0
Nodes (0): 

### Community 93 - "Community 93"
Cohesion: 1.0
Nodes (0): 

### Community 94 - "Community 94"
Cohesion: 1.0
Nodes (0): 

### Community 95 - "Community 95"
Cohesion: 1.0
Nodes (0): 

### Community 96 - "Community 96"
Cohesion: 1.0
Nodes (0): 

### Community 97 - "Community 97"
Cohesion: 1.0
Nodes (0): 

### Community 98 - "Community 98"
Cohesion: 1.0
Nodes (0): 

### Community 99 - "Community 99"
Cohesion: 1.0
Nodes (0): 

## Knowledge Gaps
- **5 isolated node(s):** `Perform an HTTP request. Returns (status, headers_dict, body_text).`, `Decode a JWT payload without verifying the signature.`, `POST /connect/token with client_credentials grant. Returns parsed JSON dict.`, `Return a valid access token.      Priority: --token flag > MFT_TOKEN env var > a`, `Print a helpful error message for non-2xx API responses and exit.`
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Community 44`** (2 nodes): `ConfirmDialog()`, `ConfirmDialog.tsx`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 45`** (2 nodes): `handler()`, `ContextMenu.tsx`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 46`** (2 nodes): `FileTreeItem.tsx`, `FileTreeItem()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 47`** (2 nodes): `GenerateChoiceDialog.tsx`, `GenerateChoiceDialog()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 48`** (2 nodes): `ProcessFlowBar.tsx`, `stepIcon()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 49`** (2 nodes): `highlightFopLine()`, `AnalysisPanel.tsx`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 50`** (2 nodes): `useAiGeneration.ts`, `useAiGeneration()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 51`** (2 nodes): `useAiRating.ts`, `useAiRating()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 52`** (2 nodes): `useGherkinGenerator.ts`, `useGherkinGenerator()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 53`** (2 nodes): `useUndoRedo.ts`, `useUndoRedo()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 54`** (2 nodes): `mockFile()`, `docxParser.test.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 55`** (2 nodes): `exampleWorkPackages.ts`, `downloadExampleXlsx()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 56`** (2 nodes): `featureValidation.test.ts`, `makeFeature()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 57`** (2 nodes): `generator.test.ts`, `ft()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 58`** (2 nodes): `kbSearch.test.ts`, `makeChunk()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 59`** (2 nodes): `pdfParser.ts`, `extractTextFromPdf()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 60`** (2 nodes): `resolveTableRefs.test.ts`, `makeFeature()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 61`** (2 nodes): `schedulingShortcut.test.ts`, `feat()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 62`** (2 nodes): `workflowEmitter.test.ts`, `makeSink()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 63`** (2 nodes): `workPackageParser.test.ts`, `makeXlsx()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 64`** (1 nodes): `eslint.config.js`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 65`** (1 nodes): `server.ps1`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 66`** (1 nodes): `test-mft-auth.ps1`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 67`** (1 nodes): `vite.config.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 68`** (1 nodes): `main.tsx`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 69`** (1 nodes): `test-setup.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 70`** (1 nodes): `index.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 71`** (1 nodes): `AgentStatusBar.tsx`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 72`** (1 nodes): `index.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 73`** (1 nodes): `FileExplorer.tsx`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 74`** (1 nodes): `GherkinPreview.tsx`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 75`** (1 nodes): `HelpGuide.tsx`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 76`** (1 nodes): `ProcessDiagram.tsx`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 77`** (1 nodes): `index.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 78`** (1 nodes): `StepToolbox.tsx`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 79`** (1 nodes): `index.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 80`** (1 nodes): `translations.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 81`** (1 nodes): `abasDialogCatalog.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 82`** (1 nodes): `actionText.test.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 83`** (1 nodes): `aiPrompt.test.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 84`** (1 nodes): `confluenceParser.test.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 85`** (1 nodes): `consultantTemplate.test.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 86`** (1 nodes): `fopBufferTracker.test.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 87`** (1 nodes): `fopParser.test.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 88`** (1 nodes): `fopTxtParser.test.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 89`** (1 nodes): `gherkinHighlight.test.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 90`** (1 nodes): `gherkinParser.test.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 91`** (1 nodes): `myforterroApi.test.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 92`** (1 nodes): `parseProfile.test.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 93`** (1 nodes): `agent.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 94`** (1 nodes): `file-system-access.d.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 95`** (1 nodes): `fileExplorer.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 96`** (1 nodes): `fop.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 97`** (1 nodes): `gherkin.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 98`** (1 nodes): `images.d.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 99`** (1 nodes): `knowledgeBase.ts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `generatePackage()` connect `Community 1` to `Community 0`, `Community 2`, `Community 6`, `Community 7`, `Community 9`, `Community 10`, `Community 17`, `Community 24`?**
  _High betweenness centrality (0.199) - this node is a cross-community bridge._
- **Why does `runGenerationLoop()` connect `Community 7` to `Community 1`, `Community 2`, `Community 5`, `Community 6`, `Community 10`?**
  _High betweenness centrality (0.127) - this node is a cross-community bridge._
- **Why does `warn()` connect `Community 2` to `Community 1`, `Community 11`, `Community 4`, `Community 7`?**
  _High betweenness centrality (0.117) - this node is a cross-community bridge._
- **Are the 48 inferred relationships involving `generatePackage()` (e.g. with `generateViaAgent()` and `generateOne()`) actually correct?**
  _`generatePackage()` has 48 INFERRED edges - model-reasoned connections that need verification._
- **Are the 19 inferred relationships involving `openDb()` (e.g. with `loadAgents()` and `saveAgent()`) actually correct?**
  _`openDb()` has 19 INFERRED edges - model-reasoned connections that need verification._
- **Are the 8 inferred relationships involving `runGenerationLoop()` (e.g. with `getPhaseLabel()` and `makeFeatureGuid()`) actually correct?**
  _`runGenerationLoop()` has 8 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Perform an HTTP request. Returns (status, headers_dict, body_text).`, `Decode a JWT payload without verifying the signature.`, `POST /connect/token with client_credentials grant. Returns parsed JSON dict.` to the rest of the system?**
  _5 weakly-connected nodes found - possible documentation gaps or missing edges._