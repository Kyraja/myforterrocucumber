import type { FeatureInput, Scenario, StepKeyword, StepAction, EditorCommand } from '../types/gherkin';

const EDITOR_COMMANDS = new Set([
  'NEW', 'UPDATE', 'STORE', 'VIEW', 'DELETE', 'COPY',
  'DELIVERY', 'INVOICE', 'REVERSAL', 'RELEASE', 'PAYMENT',
  'CALCULATE', 'TRANSFER', 'DONE',
]);

/** Normalize smart/curly quotes to straight ASCII quotes (LLMs love to produce these) */
function normalizeQuotes(s: string): string {
  return s
    .replace(/[\u201C\u201D\u201E\u201F\u2033\u2036]/g, '"')
    .replace(/[\u2018\u2019\u201A\u201B\u2032\u2035]/g, "'");
}

/**
 * Tries to parse step text into a structured action.
 * Returns freetext if no pattern matches.
 */
function parseStepAction(rawText: string): StepAction {
  const text = normalizeQuotes(rawText).trim();
  let m: RegExpMatchArray | null;

  // Editor oeffnen: I open an editor "X" from table "Y" with command "Z" for record "W"
  m = text.match(/^I open an editor "([^"]*)" from table "([^"]*)" with command "([^"]*)" for record "([^"]*)"$/);
  if (m && EDITOR_COMMANDS.has(m[3])) {
    return { type: 'editorOeffnen', editorName: m[1], tableRef: m[2], command: m[3] as EditorCommand, record: m[4] };
  }

  // Editor oeffnen (Suche): ... for search criteria "X"
  m = text.match(/^I open an editor "([^"]*)" from table "([^"]*)" with command "([^"]*)" for search criteria "([^"]*)"$/);
  if (m && EDITOR_COMMANDS.has(m[3])) {
    return { type: 'editorOeffnenSuche', editorName: m[1], tableRef: m[2], command: m[3] as EditorCommand, searchCriteria: m[4] };
  }

  // Editor oeffnen (Menue): ... and menu choice "X"
  m = text.match(/^I open an editor "([^"]*)" from table "([^"]*)" with command "([^"]*)" for record "([^"]*)" and menu choice "([^"]*)"$/);
  if (m && EDITOR_COMMANDS.has(m[3])) {
    return { type: 'editorOeffnenMenue', editorName: m[1], tableRef: m[2], command: m[3] as EditorCommand, record: m[4], menuChoice: m[5] };
  }

  // Zeilen anfuegen: I append rows (data table follows)
  if (text === 'I append rows') {
    return { type: 'zeilenAnfuegen' };
  }

  // Felder setzen (multi): I set fields (data table follows)
  if (text === 'I set fields') {
    return { type: 'feldSetzen', fieldName: '', value: '', row: '', multi: true };
  }

  // Feld setzen (id from editor, mit Zeile): I set field "X" to id from editor "Y" in row Z
  m = text.match(/^I set field "([^"]*)" to id from editor "([^"]*)" in row (\S+)$/);
  if (m) {
    return { type: 'feldSetzen', fieldName: m[1], value: `id from editor "${m[2]}"`, row: m[3] };
  }

  // Feld setzen (id from editor): I set field "X" to id from editor "Y"
  m = text.match(/^I set field "([^"]*)" to id from editor "([^"]*)"$/);
  if (m) {
    return { type: 'feldSetzen', fieldName: m[1], value: `id from editor "${m[2]}"`, row: '' };
  }

  // Feld setzen (value from editor): I set field "X" to "Y" from editor "Z"
  m = text.match(/^I set field "([^"]*)" to "([^"]*)" from editor "([^"]*)"$/);
  if (m) {
    return { type: 'feldSetzen', fieldName: m[1], value: `"${m[2]}" from editor "${m[3]}"`, row: '' };
  }

  // Feld setzen (mit Zeile): I set field "X" to "Y" in row Z (supports !lastRow)
  m = text.match(/^I set field "([^"]*)" to "([^"]*)" in row (\S+)$/);
  if (m) {
    return { type: 'feldSetzen', fieldName: m[1], value: m[2], row: m[3] };
  }

  // Feld setzen: I set field "X" to "Y"
  m = text.match(/^I set field "([^"]*)" to "([^"]*)"$/);
  if (m) {
    return { type: 'feldSetzen', fieldName: m[1], value: m[2], row: '' };
  }

  // Felder pruefen (multi): fields have values (data table follows)
  if (text === 'fields have values') {
    return { type: 'feldPruefen', fieldName: '', expectedValue: '', row: '' };
  }

  // Feld pruefen (mit Zeile): field "X" has value "Y" in row Z (supports !lastRow)
  m = text.match(/^field "([^"]*)" has value "([^"]*)" in row (\S+)$/);
  if (m) {
    return { type: 'feldPruefen', fieldName: m[1], expectedValue: m[2], row: m[3] };
  }

  // Feld pruefen: field "X" has value "Y"
  m = text.match(/^field "([^"]*)" has value "([^"]*)"$/);
  if (m) {
    return { type: 'feldPruefen', fieldName: m[1], expectedValue: m[2], row: '' };
  }

  // Feld leer (mit Zeile): field "X" is empty/not empty in row Z (supports !lastRow)
  m = text.match(/^field "([^"]*)" is (empty|not empty)(?: in row (\S+))?$/);
  if (m) {
    return { type: 'feldLeer', fieldName: m[1], isEmpty: m[2] === 'empty', row: m[3] || '' };
  }

  // Feld aenderbar (mit Zeile): field "X" is modifiable/not modifiable in row Z (supports !lastRow)
  m = text.match(/^field "([^"]*)" is (modifiable|not modifiable)(?: in row (\S+))?$/);
  if (m) {
    return { type: 'feldAenderbar', fieldName: m[1], modifiable: m[2] === 'modifiable', row: m[3] || '' };
  }

  // Editor speichern
  if (text === 'I save the current editor') {
    return { type: 'editorSpeichern' };
  }

  // Editor schliessen
  if (text === 'I close the current editor') {
    return { type: 'editorSchliessen' };
  }

  // Editor wechseln (with command)
  m = text.match(/^I switch the current editor to editor "([^"]*)" with command "([^"]*)"$/);
  if (m) {
    return { type: 'editorWechseln', editorName: m[1] };
  }

  // Editor wechseln
  m = text.match(/^I switch the current editor to editor "([^"]*)"$/);
  if (m) {
    return { type: 'editorWechseln', editorName: m[1] };
  }

  // Subeditor speichern
  if (text === 'I save the current subeditor to switch back to the parent editor') {
    return { type: 'editorSpeichern' };
  }

  // Start druecken
  if (text === 'I press start') {
    return { type: 'buttonDruecken', buttonName: 'start', row: '' };
  }

  // Neue Zeile (am Ende)
  if (text === 'I create a new row at the end of the table') {
    return { type: 'zeileAnlegen' };
  }

  // Neue Zeile (an Position)
  m = text.match(/^I create a new row at position (\S+)$/);
  if (m) {
    return { type: 'zeileAnlegen' };
  }

  // Zeile loeschen
  m = text.match(/^I delete row at position (\S+)$/);
  if (m) {
    return { type: 'buttonDruecken', buttonName: 'delete row', row: m[1] };
  }

  // Alle Zeilen loeschen
  if (text === 'I delete all rows') {
    return { type: 'buttonDruecken', buttonName: 'delete all rows', row: '' };
  }

  // Subeditor oeffnen (mit Zeile, supports !lastRow)
  m = text.match(/^I press button "([^"]*)" to open a subeditor for "([^"]*)"(?: in row (\S+))?$/);
  if (m) {
    return { type: 'subeditorOeffnen', buttonName: m[1], subeditorName: m[2], row: m[3] || '' };
  }

  // Button druecken (mit Zeile, supports !lastRow)
  m = text.match(/^I press button "([^"]*)" in row (\S+)$/);
  if (m) {
    return { type: 'buttonDruecken', buttonName: m[1], row: m[2] };
  }

  // Button druecken
  m = text.match(/^I press button "([^"]*)"$/);
  if (m) {
    return { type: 'buttonDruecken', buttonName: m[1], row: '' };
  }

  // Infosystem oeffnen (with optional ref for backwards compatibility)
  m = text.match(/^I open the infosystem "([^"]*)"(?: from "([^"]*)")?$/);
  if (m) {
    const isName = m[1];
    return { type: 'infosystemOeffnen', infosystemName: isName, infosystemRef: m[2] || isName };
  }

  // Tabelle Zeilen
  m = text.match(/^the table has (\d+) rows$/);
  if (m) {
    return { type: 'tabelleZeilen', rowCount: m[1] };
  }

  // Exception Speichern
  m = text.match(/^saving the current editor throws the exception "([^"]*)"$/);
  if (m) {
    return { type: 'exceptionSpeichern', exceptionId: m[1] };
  }

  // Exception Feld (mit Zeile)
  m = text.match(/^setting field "([^"]*)" to "([^"]*)" in row (\S+) throws the exception "([^"]*)"$/);
  if (m) {
    return { type: 'exceptionFeld', fieldName: m[1], value: m[2], exceptionId: m[4] };
  }

  // Exception Feld
  m = text.match(/^setting field "([^"]*)" to "([^"]*)" throws the exception "([^"]*)"$/);
  if (m) {
    return { type: 'exceptionFeld', fieldName: m[1], value: m[2], exceptionId: m[3] };
  }

  // Exception Button
  m = text.match(/^pressing button "([^"]*)" throws the exception "([^"]*)"$/);
  if (m) {
    return { type: 'exceptionSpeichern', exceptionId: m[2] };
  }

  // Dialog beantworten
  m = text.match(/^I respond with answer "([^"]*)" to the dialog with id "([^"]*)"$/);
  if (m) {
    return { type: 'dialogBeantworten', answer: m[1], dialogId: m[2] };
  }

  return { type: 'freetext' };
}

/** Parse a Gherkin data table row: "| a | b |" → ["a", "b"] */
function parseTableRow(line: string): string[] | null {
  const trimmed = line.trim();
  if (!trimmed.startsWith('|') || !trimmed.endsWith('|')) return null;
  return trimmed.split('|').slice(1, -1).map((c) => c.trim());
}

/**
 * Parses raw Gherkin text into a FeatureInput structure.
 * Detects known abas step patterns and creates structured actions.
 * Unrecognized steps remain as freetext.
 */
export function parseGherkin(text: string): FeatureInput {
  const lines = text.split('\n');

  let name = '';
  let description = '';
  const tags: string[] = [];
  const scenarios: Scenario[] = [];

  let currentScenario: Scenario | null = null;
  let inDescription = false;
  let inBackground = false;

  for (const raw of lines) {
    const line = raw.trim();

    // Blank line ends description mode
    if (line === '') {
      inDescription = false;
      continue;
    }

    // Tags line (can appear before Feature or Scenario)
    if (line.startsWith('@')) {
      const lineTags = line.split(/\s+/).filter((t) => t.startsWith('@'));
      if (!name) {
        // Tags before Feature
        tags.push(...lineTags);
      }
      // Tags before Scenario are ignored for now (not in our model)
      inDescription = false;
      continue;
    }

    // Feature line
    if (line.startsWith('Feature:')) {
      name = line.slice('Feature:'.length).trim();
      inDescription = true;
      continue;
    }

    // Background block — skip its steps (login managed by UI)
    if (line.startsWith('Background:')) {
      inBackground = true;
      inDescription = false;
      continue;
    }

    // Scenario / Scenario Outline
    if (line.startsWith('Scenario:') || line.startsWith('Scenario Outline:')) {
      inBackground = false;
      const prefix = line.startsWith('Scenario Outline:') ? 'Scenario Outline:' : 'Scenario:';
      // Save previous scenario
      if (currentScenario) {
        scenarios.push(currentScenario);
      }
      currentScenario = {
        id: crypto.randomUUID(),
        name: line.slice(prefix.length).trim(),
        steps: [],
      };
      inDescription = false;
      continue;
    }

    // Step line (skip steps inside Background)
    const stepMatch = line.match(/^(Given|When|Then|And|But)\s+(.*)/);
    if (stepMatch && inBackground) {
      continue;
    }
    if (stepMatch && currentScenario) {
      const keyword = stepMatch[1] as StepKeyword;
      const stepText = normalizeQuotes(stepMatch[2]).trim();
      const action = parseStepAction(stepText);

      currentScenario.steps.push({
        id: crypto.randomUUID(),
        keyword,
        text: stepText,
        action,
      });
      inDescription = false;
      continue;
    }

    // Data table row (| col1 | col2 | ...) — attach to last step
    const tableRow = parseTableRow(line);
    if (tableRow !== null) {
      if (inBackground) continue;
      if (currentScenario && currentScenario.steps.length > 0) {
        const lastStep = currentScenario.steps[currentScenario.steps.length - 1];
        if (!lastStep.dataTable) {
          lastStep.dataTable = [];
        }
        lastStep.dataTable.push(tableRow);
      }
      continue;
    }

    // Description lines (after Feature: and before first Scenario)
    // Strip leading "# " prefix (generator writes descriptions as Gherkin comments)
    if (inDescription && !currentScenario) {
      const descLine = line.startsWith('# ') ? line.slice(2) : line.startsWith('#') ? line.slice(1) : line;
      description += (description ? '\n' : '') + descLine;
    }
  }

  // Push last scenario
  if (currentScenario) {
    scenarios.push(currentScenario);
  }

  // Mark search words from AI as auto-generated (for cleanup)
  for (const scenario of scenarios) {
    for (let i = 0; i < scenario.steps.length; i++) {
      const step = scenario.steps[i];
      const prev = scenario.steps[i - 1];
      if (
        step.action.type === 'feldSetzen' &&
        step.action.fieldName.toLowerCase() === 'such' &&
        step.action.value &&
        prev?.action.type === 'editorOeffnen' &&
        (prev.action.command === 'NEW' || prev.action.command === 'STORE')
      ) {
        scenario.steps[i] = {
          ...step,
          action: { ...step.action, autoSearchWord: true },
        };
      }
    }
  }

  // Merge consecutive feldSetzen steps with the same row into a single multi step
  for (const scenario of scenarios) {
    const merged: typeof scenario.steps = [];
    let i = 0;
    while (i < scenario.steps.length) {
      const step = scenario.steps[i];
      if (
        step.action.type === 'feldSetzen' &&
        !step.action.multi &&
        !step.action.autoSearchWord
      ) {
        const row = step.action.row;
        const group = [step];
        let j = i + 1;
        while (j < scenario.steps.length) {
          const next = scenario.steps[j];
          if (
            next.action.type === 'feldSetzen' &&
            !next.action.multi &&
            !next.action.autoSearchWord &&
            next.action.row === row
          ) {
            group.push(next);
            j++;
          } else {
            break;
          }
        }
        if (group.length >= 2) {
          const dataTable = group.map((s) => {
            const a = s.action as import('../types/gherkin').ActionFeldSetzen;
            return [a.fieldName, a.value];
          });
          merged.push({
            id: group[0].id,
            keyword: group[0].keyword,
            text: 'I set fields',
            action: { type: 'feldSetzen', fieldName: '', value: '', row, multi: true },
            dataTable,
          });
          i = j;
        } else {
          merged.push(step);
          i++;
        }
      } else {
        merged.push(step);
        i++;
      }
    }
    scenario.steps = merged;
  }

  return { name, description, tags, database: null, testUser: '', scenarios };
}
