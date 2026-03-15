# Prompt: Word Add-in "Cucumber Vorlagen-Assistent" für abas ERP

## Projektauftrag

Erstelle ein vollständiges Microsoft Word Add-in (Office Web Add-in) namens **"Cucumber Vorlagen-Assistent"**. Das Add-in soll abas-ERP-Beratern ermöglichen, direkt in Word vorgefertigte Cucumber/Gherkin-Testszenarien als ausfüllbare Vorlagen einzufügen. Der Berater wählt eine Vorlage aus, das Add-in fügt ein formatiertes Gherkin-Szenario ins Dokument ein, wobei die Platzhalter (Datenbankname, Maskenname, Feldnamen, Werte etc.) als **Word Content Controls** eingefügt werden, die der Berater nur noch ausfüllen muss.

---

## Domänenkontext: abas ERP

- Zielgruppe: **abas-ERP-Berater**, die Test-Dokumentation für Kundenanpassungen erstellen
- Tests referenzieren abas-spezifische Konzepte: Datenbanken, Masken (Editoren), Infosysteme, Felder
- Ein **Arbeitspaket** erzeugt 1-n `.feature`-Dateien
- Die Gherkin-Steps sind auf Englisch (Cucumber-Standard), die UI des Add-ins ist auf Deutsch
- Das Add-in soll **offline-fähig** sein — keine Backend-Abhängigkeiten

---

## Tech Stack

- **Office.js** (Office Web Add-in API) — für Word-Integration
- **React 18 + TypeScript** — für das Task Pane UI
- **Vite** als Bundler (oder Webpack falls Office-Tooling es erfordert)
- **Fluent UI React v9** (@fluentui/react-components) — für Microsoft-konsistentes UI-Design
- Node.js 18+

---

## Architektur

### Projektstruktur

```
cucumber-word-addin/
├── manifest.xml                  # Office Add-in Manifest
├── package.json
├── tsconfig.json
├── vite.config.ts               # (oder webpack.config.js)
├── src/
│   ├── taskpane/
│   │   ├── index.tsx            # React Entry Point
│   │   ├── App.tsx              # Hauptkomponente
│   │   ├── components/
│   │   │   ├── TemplateList.tsx  # Liste aller Vorlagen (Built-in + Custom)
│   │   │   ├── TemplateCard.tsx  # Einzelne Vorlagen-Karte mit Vorschau
│   │   │   ├── SettingsPanel.tsx # Einstellungen (Sprache, Formatierung)
│   │   │   └── CustomTemplateManager.tsx  # Eigene Vorlagen verwalten
│   │   ├── hooks/
│   │   │   └── useTemplates.ts  # Template-State + localStorage
│   │   └── styles/
│   │       └── App.module.css
│   ├── lib/
│   │   ├── templates.ts         # Template-Definitionen (siehe unten)
│   │   ├── actionText.ts        # Action → Gherkin-Text Konvertierung
│   │   ├── wordInserter.ts      # Office.js: Szenario ins Dokument einfügen
│   │   └── templateStorage.ts   # localStorage für Custom Templates
│   ├── types/
│   │   └── gherkin.ts           # Datenmodell (siehe unten)
│   └── assets/
│       └── icon-*.png           # Add-in Icons (16, 32, 80px)
├── .vscode/
│   └── launch.json              # Debugging-Konfiguration
└── README.md                    # Installations- und Einrichtungsanleitung
```

---

## Datenmodell (src/types/gherkin.ts)

Dieses Datenmodell 1:1 übernehmen:

```typescript
export type StepKeyword = 'Given' | 'When' | 'Then' | 'And' | 'But';

export type EditorCommand =
  | 'NEW' | 'UPDATE' | 'STORE' | 'VIEW' | 'DELETE'
  | 'COPY' | 'DELIVERY' | 'INVOICE' | 'REVERSAL'
  | 'RELEASE' | 'PAYMENT' | 'CALCULATE' | 'TRANSFER' | 'DONE';

export type ActionType =
  | 'freetext'
  | 'editorOeffnen'
  | 'editorOeffnenSuche'
  | 'editorOeffnenMenue'
  | 'feldSetzen'
  | 'feldPruefen'
  | 'feldLeer'
  | 'feldAenderbar'
  | 'editorSpeichern'
  | 'editorSchliessen'
  | 'editorWechseln'
  | 'zeileAnlegen'
  | 'buttonDruecken'
  | 'subeditorOeffnen'
  | 'infosystemOeffnen'
  | 'tabelleZeilen'
  | 'exceptionSpeichern'
  | 'exceptionFeld'
  | 'dialogBeantworten';

// --- Action Interfaces ---

export interface ActionEditorOeffnen {
  type: 'editorOeffnen';
  editorName: string;
  tableRef: string;
  command: EditorCommand;
  record: string;
}

export interface ActionEditorOeffnenSuche {
  type: 'editorOeffnenSuche';
  editorName: string;
  tableRef: string;
  command: EditorCommand;
  searchCriteria: string;
}

export interface ActionEditorOeffnenMenue {
  type: 'editorOeffnenMenue';
  editorName: string;
  tableRef: string;
  command: EditorCommand;
  record: string;
  menuChoice: string;
}

export interface ActionFeldSetzen {
  type: 'feldSetzen';
  fieldName: string;
  value: string;
  row: string;
}

export interface ActionFeldPruefen {
  type: 'feldPruefen';
  fieldName: string;
  expectedValue: string;
  row: string;
}

export interface ActionFeldLeer {
  type: 'feldLeer';
  fieldName: string;
  isEmpty: boolean;
  row: string;
}

export interface ActionFeldAenderbar {
  type: 'feldAenderbar';
  fieldName: string;
  modifiable: boolean;
  row: string;
}

export interface ActionEditorSpeichern { type: 'editorSpeichern'; }
export interface ActionEditorSchliessen { type: 'editorSchliessen'; }
export interface ActionEditorWechseln { type: 'editorWechseln'; editorName: string; }
export interface ActionZeileAnlegen { type: 'zeileAnlegen'; }
export interface ActionButtonDruecken { type: 'buttonDruecken'; buttonName: string; }

export interface ActionSubeditorOeffnen {
  type: 'subeditorOeffnen';
  buttonName: string;
  subeditorName: string;
  row: string;
}

export interface ActionInfosystemOeffnen {
  type: 'infosystemOeffnen';
  infosystemName: string;
  infosystemRef: string;
}

export interface ActionTabelleZeilen { type: 'tabelleZeilen'; rowCount: string; }
export interface ActionExceptionSpeichern { type: 'exceptionSpeichern'; exceptionId: string; }

export interface ActionExceptionFeld {
  type: 'exceptionFeld';
  fieldName: string;
  value: string;
  exceptionId: string;
}

export interface ActionDialogBeantworten {
  type: 'dialogBeantworten';
  dialogId: string;
  answer: string;
}

export interface ActionFreetext { type: 'freetext'; }

export type StepAction =
  | ActionFreetext
  | ActionEditorOeffnen
  | ActionEditorOeffnenSuche
  | ActionEditorOeffnenMenue
  | ActionFeldSetzen
  | ActionFeldPruefen
  | ActionFeldLeer
  | ActionFeldAenderbar
  | ActionEditorSpeichern
  | ActionEditorSchliessen
  | ActionEditorWechseln
  | ActionZeileAnlegen
  | ActionButtonDruecken
  | ActionSubeditorOeffnen
  | ActionInfosystemOeffnen
  | ActionTabelleZeilen
  | ActionExceptionSpeichern
  | ActionExceptionFeld
  | ActionDialogBeantworten;

// --- Template Model ---

export interface TemplateStep {
  keyword: StepKeyword;
  action: StepAction;
}

export interface ScenarioTemplate {
  id: string;
  label: string;
  description: string;      // Kurzbeschreibung für die UI
  steps: TemplateStep[];
  custom?: boolean;
}
```

---

## Action → Gherkin-Text Konvertierung (src/lib/actionText.ts)

Diese Funktion konvertiert eine strukturierte Action in lesbaren Gherkin-Step-Text. **Platzhalter** (leere Strings) werden durch `«...»` ersetzt — das sind die Stellen, die im Word-Dokument als Content Controls eingefügt werden.

```typescript
export function stepTextFromAction(action: StepAction): { keyword: StepKeyword; text: string; placeholders: Placeholder[] } {
  // Gibt den fertigen Step-Text zurück PLUS eine Liste von Platzhaltern
  // mit Position und Label für die Content Controls.
  //
  // Beispiel für editorOeffnen mit leeren Feldern:
  // text: 'I open an editor "«Editor-Name»" from table "«Tabelle»" with command "STORE" for record "«Datensatz»"'
  // placeholders: [
  //   { start: 21, end: 35, label: 'Editor-Name', field: 'editorName' },
  //   { start: 50, end: 60, label: 'Tabelle', field: 'tableRef' },
  //   { start: 89, end: 101, label: 'Datensatz', field: 'record' },
  // ]
}
```

Die vollständige Mapping-Logik (zu übernehmen und um Platzhalter zu erweitern):

| Action Type | Gherkin-Text Pattern | Platzhalter-Felder |
|---|---|---|
| `editorOeffnen` | `I open an editor "{editorName}" from table "{tableRef}" with command "{command}" for record "{record}"` | editorName, tableRef, record |
| `editorOeffnenSuche` | `I open an editor "{editorName}" from table "{tableRef}" with command "{command}" for search criteria "{searchCriteria}"` | editorName, tableRef, searchCriteria |
| `editorOeffnenMenue` | `I open an editor "{editorName}" from table "{tableRef}" with command "{command}" for record "{record}" and menu choice "{menuChoice}"` | editorName, tableRef, record, menuChoice |
| `feldSetzen` | `I set field "{fieldName}" to "{value}"` (+ optional: `in row {row}`) | fieldName, value, (row) |
| `feldPruefen` | `field "{fieldName}" has value "{expectedValue}"` (+ optional: `in row {row}`) | fieldName, expectedValue, (row) |
| `feldLeer` | `field "{fieldName}" is empty` / `is not empty` | fieldName |
| `feldAenderbar` | `field "{fieldName}" is modifiable` / `is not modifiable` | fieldName |
| `editorSpeichern` | `I save the current editor` | (keine) |
| `editorSchliessen` | `I close the current editor` | (keine) |
| `editorWechseln` | `I switch the current editor to editor "{editorName}"` | editorName |
| `zeileAnlegen` | `I create a new row at the end of the table` | (keine) |
| `buttonDruecken` | `I press button "{buttonName}"` | buttonName |
| `subeditorOeffnen` | `I press button "{buttonName}" to open a subeditor for "{subeditorName}"` (+ optional: `in row {row}`) | buttonName, subeditorName, (row) |
| `infosystemOeffnen` | `I open the infosystem "{infosystemName}"` | infosystemName |
| `tabelleZeilen` | `the table has {rowCount} rows` | rowCount |
| `exceptionSpeichern` | `saving the current editor throws the exception "{exceptionId}"` | exceptionId |
| `exceptionFeld` | `setting field "{fieldName}" to "{value}" throws the exception "{exceptionId}"` | fieldName, value, exceptionId |
| `dialogBeantworten` | `I respond with answer "{answer}" to the dialog with id "{dialogId}"` | answer, dialogId |

---

## Die 12 Built-in Templates (src/lib/templates.ts)

Exakt diese Vorlagen implementieren:

### 1. Feld prüfen
- **ID:** `feld_pruefen`
- **Beschreibung:** Neues Feld auf Änderbarkeit und Inhalt prüfen
- **Steps:**
  1. `Given` → editorOeffnen (command: VIEW)
  2. `Then` → feldAenderbar (modifiable: true)
  3. `And` → feldLeer (isEmpty: false)
  4. `And` → feldPruefen

### 2. Datensatz anlegen
- **ID:** `datensatz_anlegen`
- **Beschreibung:** Neuen Datensatz mit STORE-Kommando anlegen
- **Steps:**
  1. `Given` → editorOeffnen (command: STORE)
  2. `And` → feldSetzen (fieldName: 'such')
  3. `And` → feldSetzen
  4. `When` → editorSpeichern
  5. `Then` → feldPruefen

### 3. Neues Feld testen
- **ID:** `neues_feld`
- **Beschreibung:** Neues Feld anlegen, setzen, speichern und prüfen
- **Steps:**
  1. `Given` → editorOeffnen (command: NEW)
  2. `And` → feldSetzen (fieldName: 'such')
  3. `And` → feldSetzen
  4. `When` → editorSpeichern
  5. `Then` → feldPruefen

### 4. Datensatz ändern
- **ID:** `datensatz_aendern`
- **Beschreibung:** Bestehenden Datensatz per UPDATE bearbeiten
- **Steps:**
  1. `Given` → editorOeffnen (command: UPDATE)
  2. `And` → feldSetzen
  3. `When` → editorSpeichern
  4. `Then` → feldPruefen

### 5. Validierung (Speichern)
- **ID:** `validierung_speichern`
- **Beschreibung:** Exception beim Speichern testen
- **Steps:**
  1. `Given` → editorOeffnen (command: NEW)
  2. `And` → feldSetzen (fieldName: 'such')
  3. `When` → feldSetzen
  4. `Then` → exceptionSpeichern

### 6. Validierung (Feld)
- **ID:** `validierung_feld`
- **Beschreibung:** Exception bei Feldwert-Eingabe testen
- **Steps:**
  1. `Given` → editorOeffnen (command: NEW)
  2. `And` → feldSetzen (fieldName: 'such')
  3. `Then` → exceptionFeld

### 7. Tabellenzeilen bearbeiten
- **ID:** `tabellenzeilen`
- **Beschreibung:** Zeilen anlegen und Felder in Zeilen setzen
- **Steps:**
  1. `Given` → editorOeffnen (command: NEW)
  2. `And` → feldSetzen (fieldName: 'such')
  3. `And` → zeileAnlegen
  4. `And` → feldSetzen (row: '1')
  5. `When` → editorSpeichern
  6. `Then` → tabelleZeilen

### 8. Infosystem prüfen
- **ID:** `infosystem`
- **Beschreibung:** Infosystem öffnen und Ergebnisse prüfen
- **Steps:**
  1. `Given` → infosystemOeffnen
  2. `Then` → tabelleZeilen
  3. `And` → feldPruefen (row: '1')

### 9. Prozess (Ende-zu-Ende)
- **ID:** `prozess`
- **Beschreibung:** Datensatz anlegen und in anderem Editor verwenden
- **Steps:**
  1. `Given` → editorOeffnen (command: STORE)
  2. `And` → feldSetzen (fieldName: 'such')
  3. `And` → feldSetzen
  4. `And` → editorSpeichern
  5. `And` → editorSchliessen
  6. `When` → editorOeffnen (command: NEW)
  7. `And` → feldSetzen
  8. `And` → editorSpeichern
  9. `Then` → feldPruefen

### 10. Button / Subeditor
- **ID:** `button_subeditor`
- **Beschreibung:** Button drücken und Subeditor öffnen
- **Steps:**
  1. `Given` → editorOeffnen (command: UPDATE)
  2. `When` → buttonDruecken
  3. `And` → subeditorOeffnen
  4. `And` → feldSetzen
  5. `And` → editorSpeichern
  6. `Then` → feldPruefen

### 11. Dialog beantworten
- **ID:** `dialog`
- **Beschreibung:** Dialog nach Button-Klick beantworten
- **Steps:**
  1. `Given` → editorOeffnen (command: UPDATE)
  2. `When` → buttonDruecken
  3. `And` → dialogBeantworten
  4. `Then` → feldPruefen

### 12. Datensatz suchen
- **ID:** `suche_oeffnen`
- **Beschreibung:** Datensatz per Suchkriterium öffnen
- **Steps:**
  1. `Given` → editorOeffnenSuche (command: VIEW)
  2. `Then` → feldPruefen

---

## Word-Einfüge-Logik (src/lib/wordInserter.ts)

Das ist das Herzstück — die Funktion, die ein Template ins Word-Dokument einfügt.

### Gewünschtes Verhalten

Wenn der Benutzer z.B. die Vorlage "Datensatz anlegen" auswählt, wird folgendes ins Dokument eingefügt:

```
Scenario: «Szenarioname»
    Given I open an editor "«Editor-Name»" from table "«Tabelle»" with command "STORE" for record "«Datensatz»"
    And I set field "such" to "«Suchwort»"
    And I set field "«Feldname»" to "«Wert»"
    When I save the current editor
    Then field "«Feldname»" has value "«Erwarteter Wert»"
```

Dabei:
- **Fester Text** (Keywords, "I open an editor", "from table", etc.) wird als normaler Text eingefügt, in **Courier New / Consolas** (Monospace)
- **«Platzhalter»** werden als **Plain Text Content Controls** eingefügt mit:
  - `title` = Label des Platzhalters (z.B. "Editor-Name", "Tabelle", "Feldname")
  - `placeholderText` = gleicher Label-Text als Hinweis
  - Visuell hervorgehoben (z.B. hellblaue Hintergrundfarbe)
- **Einrückung:** Scenario-Zeile 2 Leerzeichen, Steps 4 Leerzeichen (Gherkin-Standard)
- **Vorher eine leere Zeile** einfügen, falls der Cursor nicht am Dokumentanfang steht

### Implementierung mit Office.js

```typescript
import { ScenarioTemplate, TemplateStep } from '../types/gherkin';

export async function insertTemplateIntoDocument(
  template: ScenarioTemplate,
  context: Word.RequestContext
): Promise<void> {
  // 1. Cursor-Position ermitteln
  const selection = context.document.getSelection();

  // 2. Scenario-Zeile einfügen mit Content Control für den Namen
  //    "  Scenario: " + [Content Control: Szenarioname]

  // 3. Für jeden Step:
  //    a) Einrückung (4 Spaces) + Keyword + Leerzeichen
  //    b) Step-Text generieren mit stepTextFromAction()
  //    c) Feste Textteile als normaler Text
  //    d) Platzhalter als Content Controls einfügen

  // 4. Formatierung: Gesamter Block in Monospace-Font (Consolas, 10pt)

  // 5. Content Controls konfigurieren:
  //    - tag: eindeutige ID (z.B. "step_0_editorName")
  //    - title: Beschreibender Label (z.B. "Editor-Name")
  //    - appearance: "BoundingBox" (sichtbarer Rahmen)
  //    - color: "#0078D4" (Fluent Blue)

  await context.sync();
}
```

### Wichtig: Content Control API

```typescript
// So wird ein Content Control eingefügt:
const range = paragraph.getRange();
const cc = range.insertContentControl();
cc.tag = "step_0_editorName";
cc.title = "Editor-Name";
cc.placeholderText = "«Editor-Name»";
cc.appearance = Word.ContentControlAppearance.boundingBox;
cc.font.color = "#0078D4";
cc.font.highlightColor = "#E6F2FF";
```

### Alternative: Einfacher Plain-Text-Modus

Falls Content Controls zu komplex sind, biete auch einen **Plain-Text-Modus** an:
- Fügt den Gherkin-Text als normalen formatierten Text ein
- Platzhalter werden als `«...»` in den Text geschrieben (mit Guillemets)
- Der Berater ersetzt die Guillemet-Platzhalter manuell

Der Benutzer soll in den Einstellungen zwischen beiden Modi wählen können.

---

## Task Pane UI (React-Komponenten)

### App.tsx — Hauptlayout

```
┌─────────────────────────────┐
│  🥒 Cucumber Vorlagen       │  ← Header mit Logo
├─────────────────────────────┤
│  [🔍 Suchen...]             │  ← Suchfeld zum Filtern
├─────────────────────────────┤
│  ▸ Standard-Vorlagen (12)   │  ← Aufklappbare Gruppe
│    ┌───────────────────┐    │
│    │ Feld prüfen       │    │  ← Template-Karte
│    │ Feld auf Änder-   │    │
│    │ barkeit prüfen    │    │
│    │        [Einfügen] │    │
│    └───────────────────┘    │
│    ┌───────────────────┐    │
│    │ Datensatz anlegen │    │
│    │ Neuen Datensatz   │    │
│    │ mit STORE anlegen │    │
│    │        [Einfügen] │    │
│    └───────────────────┘    │
│    ... (weitere)            │
│                             │
│  ▸ Eigene Vorlagen (3)     │  ← Aufklappbare Gruppe
│    ...                      │
├─────────────────────────────┤
│  [Import] [Export] [⚙️]     │  ← Footer-Aktionen
└─────────────────────────────┘
```

### TemplateCard.tsx

Jede Vorlagen-Karte zeigt:
- **Titel** (fett): z.B. "Datensatz anlegen"
- **Beschreibung** (klein, grau): z.B. "Neuen Datensatz mit STORE-Kommando anlegen"
- **Step-Vorschau** (kompakt, Monospace, max 3 Zeilen): z.B.
  ```
  Given I open an editor "..." from table "..." ...
  And I set field "such" to "..."
  When I save the current editor
  ```
- **"Einfügen"-Button** (primary, Fluent UI): Klick fügt ins Dokument ein
- Bei eigenen Vorlagen: **Löschen-Button** (Icon, rot)

### SettingsPanel.tsx

- Toggle: **Einfügemodus** — "Content Controls" vs. "Plain Text"
- Toggle: **Feature-Header miteinfügen** — Wenn aktiviert, wird vor dem Szenario auch `Feature: «Feature-Name»` eingefügt
- Toggle: **Background-Step miteinfügen** — Wenn aktiviert, wird `Background: Given I'm logged in with password "«Testbenutzer»"` eingefügt
- Button: **Alle Vorlagen zurücksetzen** (löscht eigene Vorlagen)

### CustomTemplateManager.tsx

- **Import**: JSON-Datei hochladen (kompatibel mit cucumbergnerator-Export-Format!)
- **Export**: Eigene Vorlagen als JSON herunterladen
- **Vorlagen-Format**: Identisch zum cucumbergnerator (`cucumbergnerator-vorlagen.json`)

---

## Kompatibilität mit cucumbergnerator

### Import/Export-Format

Das Add-in soll **dasselbe JSON-Format** verwenden wie der cucumbergnerator für Custom Templates:

```json
[
  {
    "id": "custom_abc12345",
    "label": "Meine Vorlage",
    "custom": true,
    "steps": [
      {
        "keyword": "Given",
        "action": {
          "type": "editorOeffnen",
          "editorName": "Verkauf",
          "tableRef": "2:1",
          "command": "STORE",
          "record": ""
        }
      },
      {
        "keyword": "And",
        "action": {
          "type": "feldSetzen",
          "fieldName": "such",
          "value": "",
          "row": ""
        }
      }
    ]
  }
]
```

Vorlagen, die im cucumbergnerator exportiert wurden, sollen im Word Add-in importiert werden können und umgekehrt.

---

## Platzhalter-Labels (Deutsch)

Für die Content Controls / Platzhalter diese deutschen Labels verwenden:

| Feld | Platzhalter-Label |
|---|---|
| editorName | Editor-Name |
| tableRef | Tabelle (z.B. 0:1) |
| command | Kommando |
| record | Datensatz |
| searchCriteria | Suchkriterium |
| menuChoice | Menüauswahl |
| fieldName | Feldname |
| value | Wert |
| expectedValue | Erwarteter Wert |
| row | Zeile |
| buttonName | Button-Name |
| subeditorName | Subeditor-Name |
| infosystemName | Infosystem-Name |
| infosystemRef | Infosystem-Referenz |
| rowCount | Zeilenanzahl |
| exceptionId | Exception-ID |
| dialogId | Dialog-ID |
| answer | Antwort |
| scenarioName | Szenarioname |
| featureName | Feature-Name |
| testUser | Testbenutzer |

Wenn ein Feld bereits einen Wert hat (z.B. `fieldName: 'such'` oder `command: 'STORE'`), wird dieser Wert direkt als Text eingefügt (kein Content Control). Nur leere Felder werden zu Platzhaltern.

---

## Manifest (manifest.xml)

Das Office-Add-in-Manifest muss folgende Punkte enthalten:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<OfficeApp xmlns="http://schemas.microsoft.com/office/appforoffice/1.1"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:type="TaskPaneApp">
  <Id>einen-zufälligen-GUID-generieren</Id>
  <Version>1.0.0</Version>
  <ProviderName>Cucumber Vorlagen</ProviderName>
  <DefaultLocale>de-DE</DefaultLocale>
  <DisplayName DefaultValue="Cucumber Vorlagen-Assistent"/>
  <Description DefaultValue="Fügt Cucumber/Gherkin-Testszenarien als ausfüllbare Vorlagen in Word ein"/>

  <Hosts>
    <Host Name="Document"/>  <!-- Word -->
  </Hosts>

  <Requirements>
    <Sets>
      <Set Name="WordApi" MinVersion="1.3"/>  <!-- Für Content Controls -->
    </Sets>
  </Requirements>

  <DefaultSettings>
    <SourceLocation DefaultValue="https://localhost:3000/taskpane.html"/>
  </DefaultSettings>

  <Permissions>ReadWriteDocument</Permissions>

  <!-- Ribbon-Button -->
  <VersionOverrides xmlns="http://schemas.microsoft.com/office/taskpaneappversionoverrides" xsi:type="VersionOverridesV1_0">
    <Hosts>
      <Host xsi:type="Document">
        <DesktopFormFactor>
          <ExtensionPoint xsi:type="PrimaryCommandSurface">
            <OfficeTab id="TabHome">
              <Group id="CucumberGroup">
                <Label resid="GroupLabel"/>
                <Icon>
                  <bt:Image size="16" resid="Icon.16x16"/>
                  <bt:Image size="32" resid="Icon.32x32"/>
                  <bt:Image size="80" resid="Icon.80x80"/>
                </Icon>
                <Control xsi:type="Button" id="ShowTaskpane">
                  <Label resid="TaskpaneButton.Label"/>
                  <Supertip>
                    <Title resid="TaskpaneButton.Label"/>
                    <Description resid="TaskpaneButton.Tooltip"/>
                  </Supertip>
                  <Icon>
                    <bt:Image size="16" resid="Icon.16x16"/>
                    <bt:Image size="32" resid="Icon.32x32"/>
                    <bt:Image size="80" resid="Icon.80x80"/>
                  </Icon>
                  <Action xsi:type="ShowTaskpane">
                    <TaskpaneId>CucumberTaskpane</TaskpaneId>
                    <SourceLocation resid="Taskpane.Url"/>
                  </Action>
                </Control>
              </Group>
            </OfficeTab>
          </ExtensionPoint>
        </DesktopFormFactor>
      </Host>
    </Hosts>

    <Resources>
      <bt:Urls>
        <bt:Url id="Taskpane.Url" DefaultValue="https://localhost:3000/taskpane.html"/>
      </bt:Urls>
      <bt:ShortStrings>
        <bt:String id="GroupLabel" DefaultValue="Cucumber"/>
        <bt:String id="TaskpaneButton.Label" DefaultValue="Vorlagen"/>
      </bt:ShortStrings>
      <bt:LongStrings>
        <bt:String id="TaskpaneButton.Tooltip" DefaultValue="Cucumber-Testvorlagen einfügen"/>
      </bt:LongStrings>
      <bt:Images>
        <bt:Image id="Icon.16x16" DefaultValue="https://localhost:3000/assets/icon-16.png"/>
        <bt:Image id="Icon.32x32" DefaultValue="https://localhost:3000/assets/icon-32.png"/>
        <bt:Image id="Icon.80x80" DefaultValue="https://localhost:3000/assets/icon-80.png"/>
      </bt:Images>
    </Resources>
  </VersionOverrides>
</OfficeApp>
```

---

## Installations- und Einrichtungsanleitung

Die README.md soll folgende Abschnitte enthalten:

### Voraussetzungen

- Node.js 18+ installiert
- Microsoft Word (Desktop, Windows/Mac) oder Word Online
- Für Entwicklung: Ein Code-Editor (VS Code empfohlen)

### Installation & Entwicklung

```bash
# 1. Repository klonen / Ordner erstellen
mkdir cucumber-word-addin && cd cucumber-word-addin

# 2. Dependencies installieren
npm install

# 3. SSL-Zertifikate für localhost generieren (Office Add-ins erfordern HTTPS)
#    Option A: office-addin-dev-certs (empfohlen)
npx office-addin-dev-certs install

#    Option B: mkcert
#    mkcert -install && mkcert localhost

# 4. Dev-Server starten
npm run dev

# 5. Add-in in Word sideloaden
#    Windows: npm run sideload
#    Mac: Manuell über Word > Insert > My Add-ins > Upload My Add-in > manifest.xml
#    Web: https://www.office.com/launch/word → Insert → Upload My Add-in
```

### Sideloading unter Windows (Schritt für Schritt)

1. Dev-Server starten: `npm run dev`
2. Word öffnen
3. **Datei → Optionen → Trust Center → Einstellungen für das Trust Center → Vertrauenswürdige Add-in-Kataloge**
4. Alternativ: Den Befehl `npm run sideload` ausführen, der das Manifest automatisch registriert
5. In Word: **Einfügen → Meine Add-ins → Cucumber Vorlagen-Assistent**

### Sideloading unter macOS

1. Dev-Server starten: `npm run dev`
2. Word öffnen
3. **Einfügen → Add-ins → Meine Add-ins → Eigene Add-ins hochladen**
4. `manifest.xml` auswählen
5. Add-in erscheint im Ribbon unter "Start"

### Sideloading in Word Online

1. Dev-Server starten: `npm run dev`
2. Word Online öffnen (office.com)
3. **Einfügen → Add-ins → Meine Add-ins hochladen**
4. `manifest.xml` hochladen

### Produktion / Deployment

```bash
# Production Build
npm run build

# Die Dateien im dist/-Ordner auf einen Webserver deployen (muss HTTPS sein)
# Dann die URLs im manifest.xml auf den Produktions-Server ändern
```

### Package.json Scripts

```json
{
  "scripts": {
    "dev": "vite --https",
    "build": "tsc && vite build",
    "preview": "vite preview --https",
    "sideload": "npx office-addin-debugging start manifest.xml",
    "stop": "npx office-addin-debugging stop manifest.xml",
    "lint": "eslint src/"
  }
}
```

---

## Erwartetes Verhalten — Beispiel-Walkthrough

1. Berater öffnet Word, erstellt neues Dokument
2. Klickt auf **"Vorlagen"** im Ribbon → Task Pane öffnet sich rechts
3. Sieht die 12 Standard-Vorlagen in Karten-Ansicht
4. Klickt auf **"Datensatz anlegen"** → **"Einfügen"**
5. Im Dokument erscheint (mit Content Controls an den `«»`-Stellen):

```
  Scenario: «Szenarioname»
    Given I open an editor "«Editor-Name»" from table "«Tabelle»" with command "STORE" for record "«Datensatz»"
    And I set field "such" to "«Suchwort»"
    And I set field "«Feldname»" to "«Wert»"
    When I save the current editor
    Then field "«Feldname»" has value "«Erwarteter Wert»"
```

6. Berater klickt auf `«Editor-Name»` → tippt "Verkauf" ein
7. Klickt auf `«Tabelle»` → tippt "2:1" ein
8. Füllt alle weiteren Platzhalter aus
9. Fertig — das Szenario ist vollständig dokumentiert

Der Berater kann dann weitere Vorlagen einfügen, um ein komplettes Feature mit mehreren Szenarien zu erstellen.

---

## Zusätzliche Features (Nice-to-have, wenn Zeit bleibt)

1. **Feature-Wrapper einfügen**: Button der `Feature: «Name»` + Leerzeile vor dem ersten Szenario einfügt
2. **Background einfügen**: Button der `Background:\n    Given I'm logged in with password "«Testbenutzer»"` einfügt
3. **Vorschau-Tooltip**: Beim Hovern über eine Vorlage zeigt ein Tooltip das komplette generierte Gherkin
4. **Tastenkürzel**: Strg+Shift+C → Task Pane öffnen/schließen
5. **Letzte 3 Vorlagen**: Quick-Access-Leiste mit den zuletzt verwendeten Vorlagen
6. **Dunkelmodus**: Automatisch an das Word-Theme anpassen

---

## Zusammenfassung der Kernpunkte

- **12 Built-in Templates** mit den exakten Step-Definitionen wie oben angegeben
- **Content Controls** für Platzhalter (leere Felder) — bereits gefüllte Felder als fester Text
- **Monospace-Formatierung** (Consolas/Courier New, 10pt)
- **Gherkin-Einrückung** beibehalten (Scenario 2 Spaces, Steps 4 Spaces)
- **JSON-Import/Export** kompatibel zum cucumbergnerator-Format
- **Fluent UI v9** für konsistentes Microsoft-Look&Feel
- **Vollständig offline** — kein Backend, keine API-Aufrufe
- **HTTPS** für Entwicklung (Office-Requirement)
- **Deutsche UI**, englische Gherkin-Steps
