@persistent
Feature: VERSAND_BEHAELTER_Einkaufsrechnung_mL_MZ_Plausis.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Einkaufsrechnung_mL_MZ_Plausis.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Plausis in Einkaufsrechnung mit Lagerbewegung bei MZs mit Behaeltern
#  ref              : ref_behaelter_einkauf_mitmz_plausis_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"

Scenario: 01 Der Behaelter ist bereits vorhanden und nicht leer
And I create a Container "BehaelterL01" for packaging material "KLT" and search word "BEH_L01"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | PEDALE   |
    | buart     | Zugang   |
    | beleg     | L01      |
    | beldat    | .        |
And I delete all rows
And I append rows
    | mge    | behaelter           |
    | 10     |!BehaelterL01^nummer |
And I save the current editor

Given I open an editor "EKRechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER          |
    | vom       | .                |
    | ebeleg    | RechnungML_01    |
And I delete all rows
And I append rows
	| artikel | mge |
	| PEDALE  | 11  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_01" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge |
	| F1     | 11     |
And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
# Fehler 8346: Die Behaelternummer ist bereits vorhanden und nicht leer.
And setting field "exbehnum" in row 1 to "nummer" from editor "BehaelterL01" in row 0 throws the exception "8346"
And I close the current editor
And I switch the current editor to editor "EKRechnung_01"
And I close the current editor


Scenario: 02a Bei Angabe einer externen Behaelternummer darf das Packmittel nicht leer sein

Given I open an editor "EKRechnung_02a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER          |
    | vom       | .                |
    | ebeleg    | RechnungML_02a   |
And I delete all rows
And I append rows
	| artikel | mge |
	| PEDALE  | 11  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_02a" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum  |
	| F1     | 11     | MZ_02_590 |
# Fehler 6613: Bitte Packmittel eintragen!
Then saving the current editor throws the exception "6613"
And I close the current editor
And I switch the current editor to editor "EKRechnung_02a"
And I close the current editor


Scenario: 02b Bei Angabe einer externen Behaelternummer muss ein Packmittel eingetragen werden

Given I open an editor "EKRechnung_02b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER          |
    | vom       | .                |
    | ebeleg    | RechnungML_02b   |
And I delete all rows
And I append rows
	| artikel | mge |
	| PEDALE  | 11  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_02b" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum  |
	| F1     | 11     | MZ_02_590 |
# Fehler 1361: Ungueltiger Feldwert
Then setting field "packm" to "PEDALE" in row 1 throws the exception "1361"
And I close the current editor
And I switch the current editor to editor "EKRechnung_02b"
And I close the current editor


Scenario: 02c Packmittel muss Behaelter, Palette oder Container sein

Given I open an editor "EKRechnung_02c" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER          |
    | vom       | .                |
    | ebeleg    | RechnungML_02c   |
And I delete all rows
And I append rows
	| artikel | mge |
	| PEDALE  | 11  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_02c" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum  |
	| F1     | 11     | MZ_02_590 |
# Fehler 1361: Ungueltiger Feldwert
Then setting field "packm" to "SDECKEL" in row 1 throws the exception "1361"
And I close the current editor
And I switch the current editor to editor "EKRechnung_02c"
And I close the current editor


Scenario: 03a Gleiche Behaelternummer muss gleichen Platz in allen Zeilen haben, in LS und MZ

Given I open an editor "EKRechnung_03a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER          |
    | vom       | .                |
    | ebeleg    | RechnungML_03a   |
    | ueb       | ja               |
And I delete all rows
And I append rows
	| artikel | mge | exbehnum | platz | packm |
	| PEDALE  | 200 | MZ03_AR1 | F1    | KLT   |
	| RAD     | 200 | MZ03_AR1 | F1    | KLT   |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_03a1" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum | packm |
	| F1     | 100    | MZ03_AR2 | KLT   |
	| F1     | 100    | MZ03_AR3 | KLT   |
And I save the current editor
And I switch the current editor to editor "EKRechnung_03a"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_03a2" in row 2
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum | packm |
	| F1     | 100    | MZ03_AR2 | KLT   |
	| F1     | 100    | MZ03_AR3 | KLT   |
And I save the current editor
And I switch the current editor to editor "EKRechnung_03a"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


Scenario: 03b Gleiche Behaelternummer mit unterschiedlichen Plaetzen in LS und MZ fuehrt zu Fehler

Given I open an editor "EKRechnung_03b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER          |
    | vom       | .                |
    | ebeleg    | RechnungML_03b   |
    | ueb       | ja               |
And I delete all rows
And I append rows
	| artikel | mge | exbehnum | platz | packm |
	| PEDALE  | 200 | MZ03_BR1 | F1    | KLT   |
	| RAD     | 200 | MZ03_BR1 | F1    | KLT   |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_03b1" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum | packm |
	| F1     | 100    | MZ03_BR2 | KLT   |
	| F1     | 100    | MZ03_BR3 | KLT   |
And I save the current editor
And I switch the current editor to editor "EKRechnung_03b"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_03b2" in row 2
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum | packm |
	| F2     | 100    | MZ03_BR2 | KLT   |
	| F2     | 100    | MZ03_BR3 | KLT   |
And I save the current editor
And I switch the current editor to editor "EKRechnung_03b"
And I respond with answer "ja" to the dialog with id "4841"
# Fehler 8391: Gleiche Behaelternummer, abweichender Lagerplatz.
And saving the current editor throws the exception "8391"
And I close the current editor


Scenario: 03c Gleiche Behaelternummer muss gleichen Platz in allen Zeilen haben, in LS und MZ

Given I open an editor "EKRechnung_03c" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER          |
    | vom       | .                |
    | ebeleg    | RechnungML_03c   |
    | ueb       | ja               |
And I delete all rows
And I append rows
	| artikel | mge | exbehnum | platz | packm |
	| PEDALE  | 200 | MZ03_CR1 | F1    | KLT   |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_03c" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum | packm |
	| F1     | 100    | MZ03_CR1 | KLT   |
	| F1     | 100    | MZ03_CR2 | KLT   |
And I save the current editor
And I switch the current editor to editor "EKRechnung_03c"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


Scenario: 03d Gleiche Behaelternummer mit unterschiedlichen Plaetzen in LS und MZ fuehrt zu Fehler

Given I open an editor "EKRechnung_03d" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER          |
    | vom       | .                |
    | ebeleg    | RechnungML_03d   |
    | ueb       | ja               |
And I delete all rows
And I append rows
	| artikel | mge | exbehnum | platz | packm |
	| PEDALE  | 200 | MZ03_DR1 | F1    | KLT   |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_03d" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum | packm |
	| F2     | 100    | MZ03_DR1 | KLT   |
	| F1     | 100    | MZ03_DR2 | KLT   |
And I save the current editor
And I switch the current editor to editor "EKRechnung_03d"
And I respond with answer "ja" to the dialog with id "4841"
# Fehler 8391: Gleiche Behaelternummer, abweichender Lagerplatz.
And saving the current editor throws the exception "8391"
And I close the current editor


Scenario: 04a Bei gleicher Behaelternummer muss das Packmittel in LS und MZ gleich sein

Given I open an editor "EKRechnung_04a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER          |
    | vom       | .                |
    | ebeleg    | RechnungML_04a   |
    | ueb       | ja               |
And I delete all rows
And I append rows
	| artikel | mge | exbehnum | platz | packm |
	| PEDALE  | 200 | MZ04_AR1 | F1    | KLT   |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_04a" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum | packm |
	| F1     | 100    | MZ04_AR1 | KLT   |
	| F1     | 100    | MZ04_AR2 | KLT   |
And I save the current editor
And I switch the current editor to editor "EKRechnung_04a"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


Scenario: 04b Gleiche Behaelternummer mit unterschiedlichen Packmitteln in LS und MZ fuehrt zu Fehler

Given I open an editor "EKRechnung_04b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER          |
    | vom       | .                |
    | ebeleg    | RechnungML_04b   |
    | ueb       | ja               |
And I delete all rows
And I append rows
	| artikel | mge | exbehnum | platz | packm   |
	| PEDALE  | 200 | MZ04_BR1 | F1    | SKARTON |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_04b" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum | packm |
	| F1     | 100    | MZ04_BR1 | KLT   |
	| F1     | 100    | MZ04_BR2 | KLT   |
And I save the current editor
And I switch the current editor to editor "EKRechnung_04b"
And I respond with answer "ja" to the dialog with id "4841"
# Fehler 8371: Gleiche Behaelternummer, unterschiedliche Packmittel.
And saving the current editor throws the exception "8371"
And I close the current editor


Scenario: 04c Gleiche Behaelternummer mit unterschiedlichen Packmitteln in LS und MZ fuehrt zu Fehler

Given I open an editor "EKRechnung_04c" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER          |
    | vom       | .                |
    | ebeleg    | RechnungML_04c   |
    | ueb       | ja               |
And I delete all rows
And I append rows
	| artikel | mge | exbehnum | platz | packm |
	| PEDALE  | 200 | MZ04_CR1 | F1    | KLT   |
	| RAD     | 200 | MZ04_CR1 | F1    | KLT   |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_04c1" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum | packm |
	| F1     | 100    | MZ04_CR2 | KLT   |
	| F1     | 100    | MZ04_CR3 | KLT   |
And I save the current editor
And I switch the current editor to editor "EKRechnung_04c"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_04c2" in row 2
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum | packm   |
	| F1     | 100    | MZ04_CR2 | SKARTON |
	| F1     | 100    | MZ04_CR3 | SKARTON |
And I save the current editor
And I switch the current editor to editor "EKRechnung_04c"
And I respond with answer "ja" to the dialog with id "4841"
# Fehler 8371: Gleiche Behaelternummer, unterschiedliche Packmittel.
And saving the current editor throws the exception "8371"
And I close the current editor


Scenario: 05a Bei gleicher Nummer in 2 MZ-Zeilen muessen sich die Gebindeinformationen unterscheiden

Given I open an editor "EKRechnung_05a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER          |
    | vom       | .                |
    | ebeleg    | RechnungML_05a   |
    | ueb       | ja               |
And I delete all rows
And I append rows
	| artikel | mge | platz |
	| PEDALE  | 200 | F1    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_05a" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum | packm | verw |
	| F1     | 100    | MZ05_AR1 | KLT   | abc  |
	| F1     | 100    | MZ05_AR1 | KLT   | cde  |
And I save the current editor
And I switch the current editor to editor "EKRechnung_05a"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


Scenario: 05b Gleiche Behaelternummer in 2 MZ-Zeilen mit gleichen Gebindeinformationen fuehrt zu Fehler

Given I open an editor "EKRechnung_05b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER          |
    | vom       | .                |
    | ebeleg    | RechnungML_05b   |
    | ueb       | ja               |
And I delete all rows
And I append rows
	| artikel | mge | platz |
	| PEDALE  | 200 | F1    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_05b" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge | exbehnum | packm | verw |
	| F1     | 100    | MZ05_BR1 | KLT   | abc  |
	| F1     | 100    | MZ05_BR1 | KLT   | abc  |
# 8370 de      |Behälter darf nur einmal zu einer Artikelposition angegeben werden.
Then saving the current editor throws the exception "8370"
And I close the current editor
And I switch the current editor to editor "EKRechnung_05b"
And I close the current editor

