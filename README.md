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
git clone https://github.com/Kyraja/myforterrocucumber.git
cd myforterrocucumber
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

## Authentication & AI Integration (Developer Reference)

### Authentication Architecture

The app authenticates against the **MyForterro API** using **OAuth 2.0 Authorization Code + PKCE** (Proof Key for Code Exchange). This is the standard for public clients (SPAs) that cannot store a client secret securely.

#### OAuth2 PKCE Flow

```
Browser (SPA)                    MyForterro Auth Server
     |                                    |
     |  1. Generate code_verifier         |
     |     + code_challenge (SHA-256)     |
     |                                    |
     |  2. Redirect to /connect/authorize |
     |     ?code_challenge=...            |
     |     &client_id=...                 |
     |     &redirect_uri=...              |
     |     &scope=openid profile email    |
     |  --------------------------------> |
     |                                    |
     |  3. User logs in at MyForterro     |
     |                                    |
     |  4. Redirect back with ?code=...   |
     |  <-------------------------------- |
     |                                    |
     |  5. POST /connect/token            |
     |     code + code_verifier           |
     |  --------------------------------> |
     |                                    |
     |  6. Response: access_token,        |
     |     refresh_token, id_token        |
     |  <-------------------------------- |
     |                                    |
     |  7. Store tokens in localStorage   |
     |     Auto-refresh before expiry     |
```

#### Key Classes and Functions

| File | Function | Purpose |
|------|----------|---------|
| `src/lib/pkce.ts` | `generateCodeVerifier()` | Creates a random 86-char URL-safe string |
| `src/lib/pkce.ts` | `generateCodeChallenge()` | SHA-256 hash of verifier (Web Crypto API) |
| `src/lib/pkce.ts` | `generateState()` | Random CSRF protection token |
| `src/lib/myforterroApi.ts` | `initiateLogin()` | Builds authorize URL, stores PKCE data in sessionStorage, redirects browser |
| `src/lib/myforterroApi.ts` | `hasAuthCallback()` | Checks if URL contains `?code=...&state=...` |
| `src/lib/myforterroApi.ts` | `handleAuthCallback()` | Exchanges auth code for tokens, validates state, stores tokens |
| `src/lib/myforterroApi.ts` | `getValidToken()` | Returns cached token or auto-refreshes via refresh_token |
| `src/lib/myforterroApi.ts` | `refreshAccessToken()` | Exchanges refresh_token for a new access_token |
| `src/lib/myforterroApi.ts` | `logout()` | Clears all stored tokens (keeps client_id for convenience) |
| `src/lib/myforterroApi.ts` | `isLoggedIn()` | Checks if an access_token exists in localStorage |

#### Token Storage

Tokens are stored in `localStorage` under the `cucumbergnerator_mft_` prefix:

| Key | Content | Lifetime |
|-----|---------|----------|
| `mft_token` | OAuth access_token | ~1 hour (auto-refreshed) |
| `mft_refresh_token` | OAuth refresh_token | Days/weeks |
| `mft_token_expiry` | Timestamp (ms) | Updated on each refresh |
| `mft_id_token` | OpenID Connect JWT | Contains user display name |
| `mft_client_id` | OAuth client ID | Persistent (pre-fills login form) |
| `mft_application` | Application ID | Persistent |
| `mft_tenant_id` | Selected tenant | Persistent |

PKCE ephemeral data (`code_verifier`, `state`) is stored in `sessionStorage` and cleared immediately after the callback.

#### Proxy Configuration

API calls to MyForterro are proxied to avoid CORS issues:

| Local Path | Target |
|-----------|--------|
| `/mft-auth/*` | `https://integration-myforterro-core.fcs-dev.eks.forterro.com` |
| `/mft-api/*` | `https://integration-myforterro-api.fcs-dev.eks.forterro.com` |

- **Development**: Configured in `vite.config.ts` under `server.proxy`
- **Production**: Handled by `server.cjs` (or the standalone `.exe`)

### AI Generation Pipeline

The AI generation follows a two-step pipeline, orchestrated by `src/lib/generatePackage.ts`:

```
Requirements Text
        |
        v
  ┌─────────────────────────────┐
  │  Step 1: Table Identification │
  │                               │
  │  1a. Local: scan text for     │
  │      V/P-notation refs        │
  │      (e.g. V-03-23, P12:26)  │
  │                               │
  │  1b. AI fallback: send text   │
  │      + table list to LLM     │
  │      → JSON response with    │
  │        matched table refs     │
  └───────────┬───────────────────┘
              |
              v
  ┌─────────────────────────────┐
  │  Step 2: Gherkin Generation   │
  │                               │
  │  Build prompt with:           │
  │  - System prompt (abas steps) │
  │  - Field definitions from     │
  │    identified tables          │
  │  - Requirements text          │
  │  - Knowledge base chunks      │
  │                               │
  │  → AI returns Gherkin text    │
  │  → parseGherkin() converts    │
  │    to FeatureInput            │
  └───────────────────────────────┘
```

#### AI Backends

| Backend | Module | When Used |
|---------|--------|-----------|
| **MyForterro Agent** | `myforterroApi.ts` → `chatWithAgentSync()` | Primary — when logged in and agent selected |
| **MyForterro Direct** | `myforterroApi.ts` → `chatCompletion()` | Fallback — when no agent configured |
| **OpenRouter** | `openrouter.ts` → `openRouterChatCompletion()` | Alternative — when API key configured in settings |

The system automatically falls back: Agent → Direct → OpenRouter.

#### Deep Test Mode

When `testDepth: 'deep'` is enabled, the generator runs multiple conversation rounds (default: up to 5). Each round sends the previously generated Gherkin back to the AI with a prompt asking for additional scenarios covering edge cases, error paths, and boundary conditions. The AI signals completion by responding with a `DONE` marker.

#### Token Usage Tracking

Every AI call records its token consumption via `src/lib/tokenHistory.ts`:
- Stored per-day in localStorage
- Visible in the Token History panel (top-right corner)
- Daily limit with configurable threshold
- Tracks: model, prompt tokens, completion tokens, purpose, details

### OpenRouter as Alternative Backend

For development or when MyForterro is unavailable:

| File | Function | Purpose |
|------|----------|---------|
| `src/lib/openrouter.ts` | `openRouterChatCompletion()` | Send chat completions to OpenRouter API |
| `src/lib/openrouter.ts` | `listOpenRouterModels()` | Fetch available models for the settings dropdown |
| `src/lib/settings.ts` | `getOpenRouterKey()` | Read API key from localStorage |

OpenRouter uses the standard OpenAI-compatible `/v1/chat/completions` endpoint with a 120-second timeout.

---

## Deployment for Consultants (Packaged Build)

### Building the Package

```bash
npm run build          # 1. Build the production bundle into dist/
npm run build:exe      # 2. Package as standalone Windows .exe (optional)
```

### What Gets Packaged

The `build:exe` command uses [pkg](https://github.com/vercel/pkg) to bundle `server.cjs` + the `dist/` folder into a single `cucumbergnerator.exe`. The executable contains:
- A Node.js runtime (Node 18)
- The production web server (`server.cjs`)
- All static files from `dist/`
- Proxy routes for MyForterro API calls

### How Consultants Use It

**Option A: With the .exe**

1. Copy `cucumbergnerator.exe` to any Windows machine
2. Double-click to start -- a browser window opens automatically at `http://localhost:5173`
3. Keep the console window open while using the app
4. Close the console window to stop the server

**Option B: With start.bat (development/shared drive)**

1. Copy the project folder (with `dist/` and `node_modules/`) to a shared drive or USB
2. Double-click `start.bat`
3. The script waits 1 second, opens the browser, and starts the PowerShell server

**Option C: Manual start**

```bash
node server.cjs        # Start the server
# or
node server.js         # ESM variant (same functionality)
```

### Network Requirements

The packaged server proxies API calls to MyForterro:
- Outbound HTTPS to `integration-myforterro-core.fcs-dev.eks.forterro.com` (auth)
- Outbound HTTPS to `integration-myforterro-api.fcs-dev.eks.forterro.com` (AI API)
- No inbound ports required (the server runs on localhost only)
- If using OpenRouter instead: outbound HTTPS to `openrouter.ai`

---

## User Guide

### 1. First Launch & Login

1. **Start the application** (dev server, .exe, or start.bat)
2. Click the **gear icon** (Settings) in the top-right corner
3. **Login to MyForterro:**
   - Enter your **Client ID** and **Application ID** (provided by your admin)
   - Click **"Anmelden"** (Login)
   - You are redirected to the MyForterro login page
   - After successful login, you are redirected back -- the app shows your name
   - The session stays active and auto-refreshes; you only need to log in again if the refresh token expires
4. **Select an AI Model** from the dropdown (e.g. `gpt-4o`, `claude-3.5-sonnet`)

#### Fallback: OpenRouter

If MyForterro is unavailable or you want to use a different model:

1. In Settings, scroll to **"OpenRouter"**
2. Enter your [OpenRouter API key](https://openrouter.ai/keys)
3. Click **"Modelle laden"** to populate the model list
4. Select a model -- the app will automatically use OpenRouter when MyForterro calls fail

### 2. Loading Reference Data (Stammdaten)

Before generating tests, load the abas variable table for field-aware prompts:

1. Switch to the **"Stammdaten"** tab
2. Click **"CSV hochladen"** and select the exported variable table CSV
3. The app parses all databases, infosystems, and their fields
4. Loaded data persists in IndexedDB across sessions

The more field definitions are available, the better the AI can generate accurate field references in the test steps.

### 3. Manual Test Creation (Editor)

For writing individual test scenarios by hand:

1. Switch to the **"Editor"** tab
2. Enter a **Feature name** (e.g. "Customer Group Field")
3. Optionally set the **test user**, **database**, and **tags**
4. Click **"+ Szenario"** to add a scenario
5. Use the **Step Toolbox** (right panel) to drag building-block steps:
   - "Editor oeffnen" -- opens an abas mask
   - "Feld setzen" -- sets a field value
   - "Feld pruefen" -- asserts a field value
   - "Editor speichern" -- saves the current record
   - ... and 16 more action types
6. Each step auto-generates the correct Gherkin syntax in the **preview pane**
7. Use **"Kopieren"** (Copy) or **"Download"** to export the `.feature` file

### 4. AI-Powered Single Test Generation

Generate a complete test from a requirements description:

1. In the **Editor** tab, enter a **Feature name**
2. In the **"Anforderungstext"** (requirements) textarea, paste or type the customization description
3. The **prompt quality meter** shows a score (0-100) with improvement suggestions
4. Click **"KI generieren"** (AI Generate)
5. The two-step pipeline runs:
   - **Step 1:** Tables are identified (locally via V/P-notation, or via AI)
   - **Step 2:** Gherkin scenarios are generated using the identified field definitions
6. The generated scenarios appear in the editor -- review and adjust as needed
7. The **Token History** (clock icon) shows how many tokens were consumed

#### Deep Test Mode

For more thorough test coverage:

1. In Settings, set **"Testtiefe"** to **"Tief"** (Deep)
2. The AI runs up to 5 conversation rounds, each adding more scenarios
3. Covers edge cases, error paths, and boundary conditions automatically

### 5. Batch Generation from DOCX (Concept Import)

Generate tests for an entire customization concept document:

1. Switch to the **"DOCX Import"** tab
2. Click **"DOCX laden"** and select your requirements document
3. The parser splits the document into chapters based on headings
4. A **table of contents** shows which chapters were detected vs. skipped
5. For each chapter, you can:
   - **Preview** the extracted requirement text
   - **Select/deselect** individual chapters
   - **Choose generation scope:** All chapters, only selected, or only ungenerated
6. Click **"Alle generieren"** to start batch generation
7. Progress is shown per-chapter with live status indicators
8. When complete, use **"Alle herunterladen (ZIP)"** to download all `.feature` files

#### Parse Profiles

Different document formats can be handled by switching the **Parse Profile** in Settings:

- **Standard:** Parses full chapter content
- **Technical Section:** Only parses content after a "Technische Umsetzung" sub-heading
- **Content End Marker:** Stops parsing at "Auswirkungen der Customization" tables
- **Custom:** Define your own heading keywords and step patterns

### 6. Prompt Quality Rating

The app rates requirement text quality on a 0-100 scale:

| Score | Color | Meaning |
|-------|-------|---------|
| 80-100 | Green | Good -- detailed process description with field names |
| 50-79 | Yellow | Acceptable -- could use more specifics |
| 0-49 | Red | Weak -- too vague for reliable AI generation |

**Improvement tips** are shown below the score, with bad/good examples for each criterion:
- Text length and structure
- Field name mentions (e.g. `ykdgruppe`, `kart`)
- Database/table references (e.g. `V-02-01`)
- Process step descriptions
- Expected outcomes / assertions

### 7. File System Explorer

For managing multiple `.feature` files as a project:

1. Click the **folder icon** to open a local directory
2. The **File Explorer** (left sidebar) shows the directory tree
3. Features are **auto-saved** (1.5s debounce) when you edit them
4. Right-click for context menu: create, rename, delete, move files/folders
5. DOCX imports can write directly into the folder structure
6. GUIDs in `@`-tags prevent duplicate imports

### 8. FOP Reverse Engineering

Analyze existing FOP customizations and auto-generate tests from them:

1. Switch to the **"Reverse Engineering"** tab
2. Click **"Ordner oeffnen"** and select a folder containing `.FO1` / `.FO2` files
3. Upload the `FOP.txt` binding configuration
4. The app parses all files and builds a **call tree** visualization
5. Click **"Analyse starten"** to run AI analysis on each FOP:
   - Technical description (events, data flow, side effects)
   - Business description (what the customization does in plain language)
   - Guidelines check (coding quality score A-F)
6. Results are cached per file hash -- re-analysis only for changed files
7. From the analysis, generate Cucumber tests covering the FOP's behavior

### 9. Knowledge Base

Build a searchable reference library for better AI context:

1. Go to **Stammdaten** → **"Wissensdatenbank"** tab
2. Upload reference documents (DOCX, PDF, HTML -- e.g. abas online help)
3. Documents are chunked and indexed by keywords
4. During AI generation, relevant chunks are automatically included in the prompt
5. Enable/disable in Settings under **"Wissensdatenbank verwenden"**

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
