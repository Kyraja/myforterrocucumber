# *****************************************************************************
#  Name             : behaelter_ekre_mitmz_scenario06.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Ruecklieferung mit Charge - verschiedene Szenarien
#
# *****************************************************************************
@persistent
Feature: behaelter_ekre_mitmz_scenario06.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Chargen anlegen
And I create a Lot "RAHMEN106" for Product "RAHMEN"
And I create a Lot "RAHMEN206" for Product "RAHMEN"
And I create a Lot "RAHMEN306" for Product "RAHMEN"
And I create a Lot "PEDALE106" for Product "PEDALE"


Scenario: 02 Behaelter anlegen
And I create a Container "behaelter06A" for packaging material "KLT"
And I create a Container "behaelter06B" for packaging material "KLT"
And I create a Container "behaelter06C" for packaging material "KLT"
And I create a Container "behaelter06D" for packaging material "KLT"
And I create a Container "behaelter06E" for packaging material "KLT"
And I create a Container "behaelter06F" for packaging material "KLT"


Scenario: 03 Erste Rechnung mit Lagerbewegung mit Charge anlegen und verbuchen
Given I open an editor "Rechnung06_1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | RE_06_1 |
And I append rows
    | artikel | mge |
    | RAHMEN  | 2   |
# eine Charge in einem Behaelter MZ
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row | !dialogId                                     | !dialogAnswer | exbehnum             | charge        |
    | 1    | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter06A^nummer | !RAHMEN106^id |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


Scenario: 04 Ruecklieferung auf erste Rechnung mit Lagerbewegung
Given I open an editor "Rechnung06_1R" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "Rechnung06_1"
And I set fields
    | vom    | .        |
    | ebeleg | RE_06_1R |
And I modify table
    | !row | mge |
    | 1    | -2  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row | zuomge | behaelter        | charge        |
    | 1    | -2     | !behaelter06A^id | !RAHMEN106^id |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 05 Zweite Rechnung mit Lagerbewegung mit Charge anlegen und verbuchen
Given I open an editor "Rechnung06_2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | RE_06_2 |
And I append rows
    | artikel | mge |
    | RAHMEN  | 6   |
# mehrere Chargen und verw in einem Behaelter MZ
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum             | charge        | verw        |
    | 2      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter06B^nummer | !RAHMEN206^id | !dontChange |
    | 2      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter06B^nummer | !RAHMEN306^id | VERWENDUNG1 |
    | 2      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter06B^nummer | !RAHMEN306^id | VERWENDUNG2 |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


Scenario: 06 Ruecklieferung auf zweite Rechnung mit Lagerbewegung
Given I open an editor "Rechnung06_2R" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "Rechnung06_2"
And I set fields
    | vom    | .        |
    | ebeleg | RE_06_2R |
And I modify table
    | !row | mge |
    | 1    | -6  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | behaelter        | charge        |
    | -2     | !behaelter06B^id | !RAHMEN206^id |
    | -2     | !behaelter06B^id | !RAHMEN306^id |
    | -2     | !behaelter06B^id | !RAHMEN306^id |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 07 Dritte Rechnung mit Lagerbewegung mit Charge anlegen und verbuchen
Given I open an editor "Rechnung06_3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | RE_06_3 |
And I append rows
    | artikel | mge |
    | RAHMEN  | 2   |
    | PEDALE  | 2   |
    | RAD     | 2   |
# verschiedene Artikel mit Charge ueber MZ in Beahelter
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row | !dialogId                                     | !dialogAnswer | exbehnum             | charge        |
    | 1    | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter06C^nummer | !RAHMEN106^id |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I modify table
    | !row | !dialogId                                     | !dialogAnswer | exbehnum             | charge        |
    | 1    | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter06C^nummer | !PEDALE106^id |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I modify table
    | !row | !dialogId                                     | !dialogAnswer | exbehnum             | verw       |
    | 1    | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter06C^nummer | VERWENDUNG1 |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


Scenario: 08 Ruecklieferung auf dritte Rechnung
Given I open an editor "Rechnung06_3R" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "Rechnung06_3"
And I set fields
    | vom    | .        |
    | ebeleg | RE_06_3R |
And I modify table
    | !row | mge |
    | 1    | -2  |
    | 2    | -2  |
    | 3    | -2  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row | zuomge | behaelter        | charge        |
    | 1    | -2     | !behaelter06C^id | !RAHMEN106^id |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I modify table
    | !row | zuomge | behaelter        | charge        |
    | 1    | -2     | !behaelter06C^id | !PEDALE106^id |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I modify table
    | !row | zuomge | behaelter        |
    | 1    | -2     | !behaelter06C^id |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor


# 24.5. Lisa, automatisch generierte MZ-Zeile beim Buchen traegt die falsche Einheit --> negative Zeile in behaelter06D, VERSAND-1000
Scenario: 09 Vierte Rechnung mit Charge anlegen und verbuchen
Given I open an editor "Rechnung06_4" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | RE_06_4 |
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | RAHMEN  | 3   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter06D^nummer |
    | PEDALE  | 4   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter06F^nummer |
    | PEDALE  | 3   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter06E^nummer |
# verschiedene Artikel ueber MZ und Position in Behaelter
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "mzueb" to "nein"
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum             | charge        |
    | 1      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter06E^nummer | !RAHMEN106^id |
    | 1      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter06F^nummer | !RAHMEN206^id |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "mzueb" to "nein"
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum             | charge         |
    | 2      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter06E^nummer | !PEDALE106^id  |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


#Scenario: 10 Ruecklieferung auf vierte Rechnung - scheitert wegen VERSAND-1000
#Given I open an editor "Rechnung06_4R" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "Rechnung06_4"
#And I set fields
#    | vom    | .        |
#    | ebeleg | RE_06_4R |
#And I modify table
#    | !row | mge | behaelter        |
#    | 1    | -3  | !behaelter06D^id |
#    | 2    | -4  | !behaelter06F^id |
#    | 3    | -3  | !behaelter06E^id |
# verschiedene Artikel ueber MZ und Position in Behaelter
#And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
#And I set field "mzueb" to "nein"
#And I delete all rows
#And I append rows
#    | zuomge | behaelter        | charge        |
#    | -1     | !behaelter06E^id | !RAHMEN106^id |
#    | -1     | !behaelter06F^id | !RAHMEN206^id |
#And I save the current subeditor to switch back to the parent editor
#And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
#And I set field "mzueb" to "nein"
#And I delete all rows
#And I append rows
#    | zuomge | behaelter        | charge        |
#    | -2     | !behaelter06E^id | !PEDALE106^id |
#And I save the current subeditor to switch back to the parent editor
#And I set field "ueb" to "ja"
#And I save the current editor


Scenario Outline: 11 Behaelter pruefen
And I switch the current editor to editor "<behedit>"
Then the table has 0 rows
Then field "behstatusaz" has value "Rücklieferung"
Then field "behleer" has value "nein"
And I close the current editor

Examples: Behaelter
| behedit      |
| behaelter06A |
| behaelter06B |
| behaelter06C |
# | behaelter06D |
# | behaelter06E |
# | behaelter06F |
