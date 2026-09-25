# *****************************************************************************
#  Name             : behaelter_ek_packm_berechnen_mz_scenario06.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Packmittel berechnen, verschiedene Artikel in einem Behaelter
#
# *****************************************************************************
@persistent
Feature: behaelter_ek_packm_berechnen_mz_scenario06.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter erstellen
And I create a Container "PACKMITTEL" for packaging material "KLT"


Scenario: 02 Lieferschein anlegen
Given I open an editor "EKLS06" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | ebeleg | EKLS_M06 |
    | vom    | .        |
And I append rows
    | artikel | mge |
    | RAD     | 2   |
    | RAHMEN  | 1   |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum           |
    | 2      | Externe Behälternummer ist bereits vergeben. | nein          | !PACKMITTEL^nummer |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum           |
    | 1      | Externe Behälternummer ist bereits vergeben. | nein          | !PACKMITTEL^nummer |
And I save the current subeditor to switch back to the parent editor
And I press button "packvor"
Then table has values
    | artikel  | mge |
    | RAD      | 2   |
    | RAHMEN   | 1   |
    | KLT      | 1   |
And I set field "ueb" to "ja"
And I save the current editor

# Then field "bhbuchung" has value "" in row 1
# Then field "bhbuchung" has value "" in row 2
# Then field "bhbuchung^mge" has value "1" in row 3
# Then field "bhbuchung^buart" has value "Zugang" in row 3


Scenario: 17 Behaelter pruefen
And I switch the current editor to editor "PACKMITTEL"
Then table has values
    | artikel | mge |
    | RAHMEN  | 1   |
    | RAD     | 4   |
And I close the current editor

