# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**cucumbergnerator** is a local web app for generating Cucumber/Gherkin BDD test scenarios in an **abas ERP** consulting context. Consultants write customization concepts (Anforderungstexte) and need to generate structured test scenarios documenting deviations from standard behavior — new fields, record creation, process changes.

### Domain Context: abas ERP

- Target users are **abas ERP consultants** creating test documentation for customizations
- Tests reference abas-specific concepts: databases (Datenbanken), screens/masks (Masken), infosystems, fields
- A **work package** (Arbeitspaket) produces 1-n `.feature` files, freely organized by the consultant
- Input workflow: **paste requirements text** as starting point → **refine in building-block editor** (select database, mask, fields, actions, expected outcomes)
- The tool runs entirely **locally** with no backend — ease of use is critical

## Commands

```bash
npm run dev          # Start dev server (Vite)
npm run build        # TypeScript check + production build
npm test             # Run all tests (Vitest, single run)
npm run test:watch   # Run tests in watch mode
npm run lint         # ESLint
```

Run a single test file:
```bash
npx vitest run src/lib/generator.test.ts
```

## Architecture

React 18 + TypeScript, built with Vite. No backend — all logic runs client-side. Styling via CSS Modules.

### Data Flow

`FeatureInput` state (in App.tsx) → `FeatureForm` edits it → `useGherkinGenerator` hook calls pure `generateGherkin()` → `GherkinPreview` displays syntax-highlighted output → `ActionBar` provides copy/download.

### Key Files

- `src/types/gherkin.ts` — Central data model: `FeatureInput`, `Scenario`, `Step`, `StepKeyword`
- `src/lib/generator.ts` — Pure function `generateGherkin(FeatureInput) → string`. Most important business logic; has comprehensive tests.
- `src/lib/gherkinHighlight.ts` — Line-by-line regex tokenizer for syntax highlighting (keywords, tags, strings, comments). No external dependencies.
- `src/hooks/useGherkinGenerator.ts` — `useMemo` wrapper connecting state to generator
- `src/lib/clipboard.ts` / `src/lib/download.ts` — Browser API utilities for copy and `.feature` file download

### Component Tree

```
App (owns FeatureInput state, two-column grid layout)
├── FeatureForm (name, description, tags + scenario list)
│   └── ScenarioBuilder (scenario name + step list)
│       └── StepRow (keyword select + text input)
├── GherkinPreview (syntax-highlighted <pre> block)
└── ActionBar (copy + download buttons)
```

### Gherkin Formatting Rules

The generator follows the Gherkin spec: Feature at column 0, Scenario indented 2 spaces, steps indented 4 spaces, blank line between scenarios, file ends with newline.

### Testing

Vitest with happy-dom environment. Pure logic tests in `src/lib/*.test.ts` are the highest-value tests. Component tests use React Testing Library. Test setup in `src/test-setup.ts` imports jest-dom matchers.

### Note on Node Version

The project was scaffolded on Node 18.17.1. Vite 7 and some dev deps emit engine warnings but work. Upgrading to Node 20+ is recommended.
