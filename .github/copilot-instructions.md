# Copilot Instructions for cucumbergenerator

Use this guidance when generating or modifying code in this repository.

## Project Context

- Project: cucumbergenerator
- Type: local React + TypeScript web app (Vite)
- Goal: generate Cucumber/Gherkin BDD scenarios for abas ERP consulting customizations
- Runtime: fully local, no backend
- Priority: practical workflow for consultants, low friction UX

## Domain Context (abas ERP)

- Users are abas ERP consultants writing test documentation for customizations.
- Inputs are requirement texts (Anforderungstexte).
- Outputs are one or more `.feature` files per work package (Arbeitspaket).
- Typical entities: databases (Datenbanken), masks/screens (Masken), infosystems, fields.
- Focus on documenting deviations from standard behavior (new fields, record creation, process changes).

## Development Commands

- `npm run dev` - Start Vite dev server
- `npm run build` - TypeScript check + production build
- `npm test` - Run tests once (Vitest)
- `npm run test:watch` - Run tests in watch mode
- `npm run lint` - Run ESLint
- Single test: `npx vitest run src/lib/generator.test.ts`

## Architecture

- Stack: React 18 + TypeScript + Vite
- Styling: CSS Modules
- No backend services; business logic runs client-side

Data flow:

`FeatureInput` state in `src/App.tsx` -> `FeatureForm` editing -> `useGherkinGenerator` hook -> pure `generateGherkin()` -> `GherkinPreview` rendering -> `ActionBar` copy/download

High-value files:

- `src/types/gherkin.ts` (core data model)
- `src/lib/generator.ts` (core generation logic)
- `src/lib/gherkinHighlight.ts` (syntax highlighting tokenizer)
- `src/hooks/useGherkinGenerator.ts` (generator hook)
- `src/lib/clipboard.ts` and `src/lib/download.ts` (browser utilities)

## Gherkin Output Rules

Keep generated Gherkin formatting consistent:

- `Feature` starts at column 0
- `Scenario` is indented by 2 spaces
- Steps are indented by 4 spaces
- Add a blank line between scenarios
- End file with a trailing newline

## Testing Guidance

- Prioritize tests around pure logic, especially `src/lib/*.test.ts`.
- Use React Testing Library for component behavior.
- `src/test-setup.ts` configures jest-dom matchers.

## Change Guidelines

- Prefer minimal, targeted changes.
- Preserve existing naming and structure unless refactoring is requested.
- Keep generator behavior stable unless requirements explicitly change.
- For generator updates, add or update tests in the same change.

## Node Version Note

- Originally scaffolded on Node 18.17.1.
- Vite 7/dependencies may show engine warnings but can still work.
- Node 20+ is preferred for development.

## Graphify Notes

- Architecture reference is available in `graphify-out/GRAPH_REPORT.md`.
- If `graphify-out/wiki/index.md` exists, prefer it over raw graph files.
- After significant code edits, update the graph with `graphify update .` when available.