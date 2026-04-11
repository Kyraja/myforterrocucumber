# Prompts fuer Claude: Grafische Darstellungen des Cucumber Test Manager

Kopiere die Prompts einzeln in claude.ai (mit Artifacts aktiviert).

---

## Prompt 1: Architektur-Diagramm

Erstelle mir ein professionelles Architektur-Diagramm als HTML/CSS Artifact (mit Boxen, Pfeilen, Farben) fuer folgendes System:

**System: "Cucumber Test Manager" fuer abas ERP**

Komponenten und Datenfluss:

1. **Cucumbergenerator (Web-Tool)** — erzeugt .feature-Dateien
   - Pfeil nach rechts zu: .feature Dateien auf dem Server

2. **.feature Dateien auf dem Server** — Ablage: $MANDANT/ow1/cucumber/features/<arbeitspaket>/
   - Pfeil nach unten zu: IS:CUCUMBER_TEST_MANAGER

3. **IS: CUCUMBER_TEST_MANAGER (Infosystem)** — Zentrale Verwaltungsoberflaeche
   - Hat 4 Reiter: Feature-Uebersicht, Konzeptimport, Cron-Verwaltung, Konfiguration
   - Pfeil nach rechts zu: DB:CUCUMBER_RESULT
   - Pfeil nach unten zu: FOP/Java Step-Runner

4. **DB: CUCUMBER_RESULT (Zusatz-Datenbank)** — 1 Datensatz pro Feature
   - Kopf: Feature-Infos + berechnete KPIs (Avg. Dauer, Erfolgsquote letzte X Laeufe)
   - Tabelle: Testlauf-Historie (je Zeile = 1 Lauf mit Status, Dauer, Fehlerlog, Step-Details als JSON)

5. **FOP/Java Step-Runner** — Fuehrt Steps als abas-Operationen aus
   - Besteht aus: CUCUMBER_RUNNER (FOP), CUCUMBER_PARSER (FOP), CUCUMBER_ACTIONS (FOP), CucumberStepRunner (Java)
   - Pfeil zurueck hoch zu DB:CUCUMBER_RESULT (schreibt Ergebnisse)

6. **Cronjob** — Ruft naechtlich ow1.CUCUMBER_CRON auf
   - Pfeil zu FOP/Java Step-Runner
   - Fuehrt alle Features aus (ausser @manual/@wip)

7. **CUCUMBER_CONFIG.FOP** — Konfigurationsdatei (Include-FOP)
   - Wird von allen FOP-Programmen eingezogen
   - Aenderbar ueber IS:CUCUMBER_TEST_MANAGER Reiter "Konfiguration"

Zusaetzlich eine **Verzeichnisstruktur-Grafik** (Baumansicht mit Ordner-Icons) fuer:
```
$MANDANT/ow1/cucumber/
  features/
    AP-2024-001/
      login.feature              (#1)
      artikel/
        neuanlage.feature        (#1.1)
        aenderung.feature        (#1.2)
      auftrag.feature            (#2)
      rechnung.feature           (#3)
    AP-2024-002/
      kunde_anlage.feature
      kunde_suche.feature
  screenshots/
  logs/
$MANDANT/ow1/CUCUMBER_CONFIG.FOP
```

Stil: Professionell, clean. Blaue Kaesten fuer Infosysteme, gruene fuer Datenbanken, graue fuer Dateisystem, orange fuer Runner/Cronjob. Pfeile mit Beschriftung (z.B. "erzeugt", "liest", "schreibt Ergebnisse"). Alles in einem HTML Artifact.

---

## Prompt 2: Infosystem-Mockups (alle 4 Reiter)

Erstelle mir professionelle Wireframe-Mockups als HTML/CSS Artifact fuer ein abas ERP Infosystem namens "CUCUMBER_TEST_MANAGER". Das Infosystem verwaltet Cucumber/Gherkin Test-Feature-Dateien. Erstelle fuer jeden Reiter ein eigenes Mockup.

### Reiter 1: "Feature-Uebersicht" (Hauptansicht)

**Kopfbereich:**
- Dropdown "Ordner" (Arbeitspaket-Auswahl, z.B. "AP-2024-001")
- Textfeld "Tag-Filter"
- Dropdown "Ergebnis-Filter" (Alle / Passed / Failed / Nie gelaufen)
- Readonly-Feld "Verzeichnis" zeigt "/ow1/cucumber/features/"
- Buttons rechts: "Verzeichnis scannen", "Ordner hochladen", "Alle ausfuehren", "Markierte ausfuehren"

**Tabelle mit Beispieldaten (5 Zeilen):**

| Checkbox | Nr. | Ampel | Pfad | Feature-Name | Beschreibung | Steps | Pass-Rate | Avg.Dauer | Letzter Lauf | Trend | Aktionen |
|---|---|---|---|---|---|---|---|---|---|---|---|
| [x] | 1 | gruen | AP-001/login.feature | Login Customizing | Prueft Login-Prozess | 8/8 OK | 10/10 (100%) | 12s | 25.03.2026 OK | = | Ausfuehren, Ergebnisse, Anzeigen, Austauschen, Loeschen |
| [ ] | 1.1 | gruen | AP-001/artikel/neuanlage.feature | Artikelanlage | Neuanlage mit Pflichtfeldern | 18/20 OK | 9/10 (90%) | 45s | 25.03.2026 OK | Pfeil hoch | ... |
| [ ] | 1.2 | rot | AP-001/artikel/aenderung.feature | Artikelaenderung | Aenderung von Feldern | 12/15 FAIL | 6/10 (60%) | 30s | 25.03.2026 FAIL | Pfeil runter | ... |
| [x] | 2 | gruen | AP-001/auftrag.feature | Auftragsanlage | Standardauftrag | 25/25 OK | 8/10 (80%) | 60s | 24.03.2026 OK | Pfeil hoch | ... |
| [ ] | 3 | grau | AP-001/rechnung.feature | Rechnungslauf | Sammelrechnung | 10 (nie gel.) | - | - | - | - | ... |

Die Nummerierung (1, 1.1, 1.2, 2, 3) bildet die Ordnerstruktur ab. Unterordner werden eingerueckt.
Ampel: Gruener Kreis = Passed, Roter Kreis = Failed, Grauer Kreis = nie gelaufen.
Trend: Pfeil hoch gruen, Pfeil runter rot, Gleichzeichen grau.
Aktionsbuttons pro Zeile: kleine Icons oder Buttons fuer Ausfuehren, Ergebnisse, Datei anzeigen, Datei austauschen, Loeschen.

### Reiter 2: "Konzeptimport" (nur sichtbar wenn Ordner gewaehlt)

- Zielordner (readonly, z.B. "features/AP-2024-001/")
- Radio-Buttons: "Datei(en) hochladen" / "Ordner hochladen" / "Konzepttext"
- Bei "Ordner hochladen": Datei-Upload + Vorschau-Tabelle mit Nummerierung und Status (NEU/EXISTIERT/AKTUALISIERT)
- Bei "Konzepttext": Grosses Textfeld + Button "Features generieren"
- Buttons: "Uebernehmen", "Abbrechen"

### Reiter 3: "Cron-Verwaltung"

- Cron-Status (Aktiv/Inaktiv Toggle)
- Cron-Ausdruck Textfeld (z.B. "0 2 * * *")
- Ausschluss-Tags (Standard: "@manual,@wip")
- Ordner-Filter (optional, leer = alle)
- Readonly: Letzter Lauf + Ergebnis
- Buttons: "Cron jetzt starten", "Cron-Log anzeigen"
- Tabelle "Cron-Historie" mit 3 Beispielzeilen (Datum, Ergebnis, Dauer, Fehlgeschlagen)

### Reiter 4: "Konfiguration"

- Formular mit den Konfigurationswerten:
  - KPI Stichprobengroesse (Dropdown: 5/10/15/20/50)
  - Step-Timeout (Zahl in Sekunden)
  - Scenario-Timeout (Zahl in Sekunden)
  - Screenshot bei Fehler (Ja/Nein)
  - Log-Level (INFO/DEBUG/ERROR)
  - Testdaten-Praefix (Text)
  - Feature-Pfad (Text)
- Button: "Speichern" (schreibt CUCUMBER_CONFIG.FOP)

Stil: Professionell, clean, wie eine ERP-Anwendung. Grau/Weiss Hintergrund, blaue Buttons, gruene/rote/graue Ampeln. Tabellen mit Zebra-Striping. Reiter-Navigation oben (aktiver Reiter hervorgehoben). Desktop-optimiert (min. 1200px Breite). Jeder Reiter als eigene Section, untereinander dargestellt.

---

## Prompt 3: DB:CUCUMBER_RESULT Datensatz-Ansicht

Erstelle mir ein professionelles Wireframe-Mockup als HTML/CSS Artifact fuer eine abas ERP Datenbank-Maske namens "CUCUMBER_RESULT".

**Kopfbereich (Feature-Infos):**
- GUID: a1b2c3d4-e5f6-7890-abcd-ef1234567890
- Feature-Name: Artikelanlage Customizing
- Beschreibung: Prueft die kundenspezifische Artikelanlage mit Pflichtfeldern
- Tags: @AP-2024-001
- Dateipfad: /ow1/cucumber/features/AP-2024-001/artikel/neuanlage.feature
- Arbeitspaket: AP-2024-001
- Scenarios: 3, Steps gesamt: 20

**KPI-Box (hervorgehoben, z.B. als Cards):**
- Erfolgsquote: 9/10 (90%) — grosse Zahl, gruener Hintergrund
- Trend: Pfeil hoch (Besser) — gruen
- Avg. Dauer: 45s
- Steps OK (letzter Lauf): 18/20
- Letzter Lauf: 25.03.2026 — PASSED (gruen)

**Tabelle (Testlauf-Historie), 4 Zeilen:**

| Datum | Ergebnis | Dauer | User | Scenarios OK | Scenarios Fail | Fehler bei |
|---|---|---|---|---|---|---|
| 25.03.2026 14:30 | PASSED (gruen) | 42s | FP | 3/3 | 0 | - |
| 25.03.2026 02:00 | FAILED (rot) | 48s | CRON | 2/3 | 1 | Scenario: Neuanlage / Step 5: field "such" has value... |
| 24.03.2026 02:00 | PASSED (gruen) | 44s | CRON | 3/3 | 0 | - |
| 23.03.2026 02:00 | PASSED (gruen) | 46s | CRON | 3/3 | 0 | - |

Stil: Professionell, ERP-typisch. KPI-Box als farbige Cards oben. Tabelle mit farbcodierten Ergebnis-Zellen (gruen=PASSED, rot=FAILED). Grau/Weiss Hintergrund.
