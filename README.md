# cucumbergnerator

A local web application for generating Cucumber/Gherkin BDD test scenarios in an **abas ERP** consulting context. Consultants write customization concepts and need structured test documentation for deviations from standard behavior -- new fields, record creation, process changes.

## Features

### Manual Test Editor
- Building-block step editor with 20+ abas-specific action types (open editor, set field, check field, save, etc.)
- Real-time Gherkin preview with syntax highlighting
- Undo/redo support for all editing operations
- Copy to clipboard and `.feature` file download

### AI-Powered Generation
- Paste requirements text and generate complete Gherkin test scenarios via AI
- Two-step pipeline: automatic table identification, then scenario generation
- Deep-test mode with multi-round conversations for comprehensive coverage
- Supports **MyForterro AI** (OAuth2 PKCE) and **OpenRouter** as AI backends
- Prompt quality rating (local heuristics + optional AI-powered)

### DOCX Import
- Import `.docx` requirement documents (Forterro/abas consulting templates)
- Automatic chapter splitting with configurable parse profiles
- Batch generation of multiple feature files from a single document
- Technical section detection and content-end markers

### Variable Table Integration
- Upload abas variable table CSV exports for field-aware prompt building
- Database and infosystem definitions with field names, types, and descriptions
- Automatic V/P-notation reference resolution from requirements text

### FOP Reverse Engineering
- Upload and parse FOP (Flexible Oberflaechen-Programmierung) source files
- Static analysis: variable tracking, buffer state inference, field resolution
- Call-tree visualization with `@xyflow/react` flow diagrams
- AI-powered analysis: technical descriptions, business summaries, guidelines checks
- Automatic Cucumber test generation from analyzed FOP behavior

### File System Integration
- Open a local directory via File System Access API
- File explorer with drag-and-drop, rename, create, delete
- Auto-save with 1.5s debounce
- DOCX import directly into folder structure with GUID-based deduplication

### Knowledge Base
- Upload reference documents (DOCX, PDF, HTML) as searchable knowledge base
- Keyword-based chunk retrieval integrated into AI prompts
- Chain-of-reference support for contextual patterns

### Internationalization
- Full German and English UI translation
- Configurable per-session language toggle

## Architecture

```
React 18 + TypeScript, built with Vite
No backend -- all logic runs client-side
CSS Modules for component-scoped styling
IndexedDB for persistent storage (tables, agents, KB)
localStorage for settings and preferences
```

### Application Views

| View | Description |
|------|-------------|
| **Editor** | Manual Gherkin feature editing with step toolbox |
| **DOCX Import** | Requirement document import with batch AI generation |
| **Stammdaten** | Variable table management and knowledge base |
| **Reverse Engineering** | FOP source analysis and call-tree visualization |

### Data Flow

```
FeatureInput (App.tsx state)
    |
    v
FeatureForm -----> useGherkinGenerator (useMemo) -----> GherkinPreview
  (editing)            |                                   (display)
                       v
                 generateGherkin()  -----> ActionBar
                   (pure function)        (copy/download)
```

### Project Structure

```
src/
  App.tsx                          # Root component, owns all top-level state
  main.tsx                         # Application entry point
  
  types/
    gherkin.ts                     # Central data model (FeatureInput, Step, StepAction, etc.)
    fop.ts                         # FOP analysis types (FopFile, FopTreeNode, FopAnalysis)
    agent.ts                       # AI agent type definitions
    fileExplorer.ts                # File tree node types
    knowledgeBase.ts               # KB document and chunk types
  
  lib/
    # -- Core Gherkin --
    generator.ts                   # FeatureInput -> .feature text (+ line mapping)
    gherkinHighlight.ts            # Regex tokenizer for syntax highlighting
    gherkinParser.ts               # .feature text -> FeatureInput (reverse parser)
    actionText.ts                  # StepAction -> Gherkin step text serialization
    featureValidation.ts           # Feature completeness validation
    consultantTemplate.ts          # German keyword format -> FeatureInput parser
    
    # -- AI Generation --
    generatePackage.ts             # Two-step AI generation pipeline orchestrator
    aiPrompt.ts                    # Prompt construction, system prompts, table context
    myforterroApi.ts               # MyForterro OAuth2 PKCE + chat completions
    openrouter.ts                  # OpenRouter API client (alternative backend)
    promptRating.ts                # Prompt quality scoring
    tokenHistory.ts                # Token usage tracking for cost monitoring
    
    # -- Import/Export --
    docxParser.ts                  # DOCX -> HTML -> chapter splitting
    workPackageParser.ts           # Excel .xlsx -> WorkPackage[]
    confluenceParser.ts            # Confluence HTML -> chapters
    pdfParser.ts                   # PDF text extraction via pdf.js
    download.ts                    # Single .feature file download
    zipDownload.ts                 # Bulk ZIP download
    clipboard.ts                   # Clipboard API wrapper
    
    # -- FOP Analysis Pipeline --
    fopParser.ts                   # FOP source -> FopFile AST (line-by-line parser)
    fopTxtParser.ts                # FOP.txt binding configuration parser
    fopBufferTracker.ts            # Buffer slot state tracking through execution
    fopFieldResolver.ts            # Buffer field -> human-readable name resolution
    fopGuidelines.ts               # Local coding guidelines checks
    fopAgentPrompt.ts              # AI prompt construction for FOP analysis
    fopOrchestrator.ts             # Full analysis pipeline orchestrator
    fopTreeResolver.ts             # Call tree construction from bindings
    fopUsageIndex.ts               # Reverse dependency index
    fopCache.ts                    # File-system cache for analysis results
    fopCommonFields.ts             # Well-known abas field name lookups
    
    # -- Persistence --
    idb.ts                         # Shared IndexedDB helper (v6)
    settings.ts                    # localStorage-based app settings
    agentStore.ts                  # IndexedDB CRUD for AI agents
    kbStore.ts                     # IndexedDB CRUD for KB documents
    kbChunker.ts                   # Document chunking for KB search
    kbSearch.ts                    # Keyword-based KB chunk retrieval
    fileSystemAccess.ts            # File System Access API wrapper
    
    # -- Utilities --
    featureGuid.ts                 # 16-hex-char GUID generation for features
    resolveTableRefs.ts            # V/P-notation reference extraction
    csvTableParser.ts              # Variable table CSV parsing
    recordTracker.ts               # Tracks created records across scenarios
    mergeFeatureGroup.ts           # Merges multiple features into one
    parseProfile.ts                # Default + custom parse profiles
    pkce.ts                        # PKCE code verifier/challenge utilities
    mftErrors.ts                   # MyForterro-specific error classes
    templates.ts                   # Step template definitions
    htmlHelpParser.ts              # HTML help file parser
    exampleWorkPackages.ts         # Built-in example data
  
  hooks/
    useGherkinGenerator.ts         # Memoized FeatureInput -> Gherkin bridge
    useAiGeneration.ts             # AI generation state machine
    useAiRating.ts                 # AI prompt rating hook
    useBulkGeneration.ts           # Batch generation for work packages
    useFileExplorer.ts             # Directory session + file CRUD + auto-save
    useFopAnalysis.ts              # FOP analysis workspace state
    useUndoRedo.ts                 # Generic undo/redo history stack
    useAgentActivity.ts            # Agent run tracking (progress, history)
    useProcessFlow.ts              # Process step visualization state
  
  components/
    ActionBar/                     # Copy + download buttons
    AgentActivityModal/            # Full-screen agent activity log viewer
    AgentPanel/                    # AI agent chat interface
    AgentStatusBar/                # Compact agent run status indicator
    BulkImport/                    # Excel work package batch import
    ConfirmDialog/                 # Reusable confirmation modal
    CsvUpload/                     # Variable table CSV file upload
    DatabaseSelect/                # abas database picker dropdown
    DataStatusBar/                 # Loaded data summary bar
    DataTableEditor/               # Gherkin data table (|col|col|) editor
    DocxImport/                    # DOCX requirement document import view
    EventChip/                     # FOP event type badge/chip
    FeatureForm/                   # Main feature editing form
    FieldValueEditor/              # Field name + value pair editor
    FileExplorer/                  # Directory tree with context menu
    FlowDiagram/                   # @xyflow/react flow diagram wrapper
    GenerateChoiceDialog/          # AI generation method selection dialog
    GherkinPreview/                # Syntax-highlighted Gherkin output
    HelpGuide/                     # In-app help and documentation
    ProcessDiagram/                # Multi-step process visualization
    ProcessFlowBar/                # Horizontal process flow indicator
    ReverseEngineering/            # FOP upload, tree, and analysis panels
    ScenarioBuilder/               # Scenario name + step list editor
    SettingsPanel/                 # App settings (API keys, model, prompts)
    StammdatenView/                # Master data + knowledge base management
    StepRow/                       # Single Gherkin step editor row
    StepToolbox/                   # Action type palette for building steps
    TableFieldSelect/              # Table + field multi-select
    TokenHistory/                  # Token usage history and cost display
  
  i18n/
    translations.ts                # DE/EN translation key-value pairs
    LanguageContext.tsx             # React context + useTranslation hook
    index.ts                       # Public re-exports
  
  styles/
    global.css                     # Global CSS reset and variables
  
  data/
    databases.json                 # Static list of abas standard databases
```

### Gherkin Formatting Rules

The generator follows the official Gherkin specification:
- `Feature:` at column 0
- `Scenario:` indented 2 spaces
- Steps (`Given`, `When`, `Then`, `And`, `But`) indented 4 spaces
- Data tables indented 6 spaces with column-aligned pipes
- Blank line between scenarios
- File ends with a newline

## Getting Started

### Prerequisites

- **Node.js** 18+ (Node 20+ recommended)
- npm

### Installation

```bash
git clone <repository-url>
cd cucumbergenerator2
npm install
```

### Development

```bash
npm run dev          # Start Vite dev server (http://localhost:5173)
```

### Production Build

```bash
npm run build        # TypeScript check + Vite production build
npm run serve        # Serve built files with Node.js server
```

### Standalone Executable (Windows)

```bash
npm run build:exe    # Package as standalone .exe via pkg
```

### Testing

```bash
npm test             # Run all tests (Vitest, single run)
npm run test:watch   # Run tests in watch mode
npm run lint         # ESLint
```

Run a single test file:

```bash
npx vitest run src/lib/generator.test.ts
```

## Configuration

All settings are stored in the browser's `localStorage` under the `cucumbergnerator_` prefix:

| Setting | Description |
|---------|-------------|
| AI Model | Select from available MyForterro or OpenRouter models |
| OpenRouter API Key | Alternative AI backend key |
| System Prompt | Customizable prompt for Gherkin generation |
| Table ID Prompt | Customizable prompt for table identification |
| Temperature | AI response randomness (0.0 - 1.0) |
| Test Depth | Normal or deep (multi-round) generation |
| Language | DE / EN interface language |

## AI Backend Setup

### MyForterro (Primary)

1. Open Settings and enter your Client ID and Application ID
2. Click "Login" to start the OAuth2 PKCE flow
3. After redirect, the app stores tokens and refreshes automatically

### OpenRouter (Alternative)

1. Get an API key from [openrouter.ai](https://openrouter.ai)
2. Enter it in Settings under "OpenRouter"
3. Select a model from the auto-populated list

## Tech Stack

| Technology | Purpose |
|-----------|---------|
| [React 19](https://react.dev) | UI framework |
| [TypeScript 5.9](https://typescriptlang.org) | Type safety |
| [Vite 6](https://vitejs.dev) | Build tool and dev server |
| [Vitest 4](https://vitest.dev) | Test framework |
| [CSS Modules](https://github.com/css-modules/css-modules) | Scoped component styling |
| [mammoth](https://github.com/mwilliamson/mammoth.js) | DOCX to HTML conversion |
| [xlsx](https://sheetjs.com) | Excel file parsing |
| [jszip](https://stuk.github.io/jszip/) | ZIP archive generation |
| [pdfjs-dist](https://mozilla.github.io/pdf.js/) | PDF text extraction |
| [@xyflow/react](https://reactflow.dev) | Flow diagram visualization |
| [docx](https://github.com/dolanmiu/docx) | DOCX template generation |

## License

Private project. All rights reserved.
