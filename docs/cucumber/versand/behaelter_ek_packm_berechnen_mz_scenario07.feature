# *****************************************************************************
#  Name             : behaelter_ek_packm_berechnen_mz_scenario07.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Packmittel berechnen, verschiedene Artikel in versch. Behaelter aufteilen
#
# *****************************************************************************
@persistent
Feature: behaelter_ek_packm_berechnen_mz_scenario07.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter erstellen
And I create a Container "PACKMITTEL1" for packaging material "KLT"
And I create a Container "PACKMITTEL2" for packaging material "KLT"


Scenario: 02 Lieferschein anlegen
Given I open an editor "EKLS07" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | ebeleg | EKLS_M07 |
    | vom    | .        |
And I append rows
    | artikel | mge |
    | RAD     | 2   |
    | RAHMEN  | 2   |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum            |
    | 1      | Externe Behälternummer ist bereits vergeben. | nein          | !PACKMITTEL1^nummer |
    | 1      | Externe Behälternummer ist bereits vergeben. | nein          | !PACKMITTEL2^nummer |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum            |
    | 1      | Externe Behälternummer ist bereits vergeben. | nein          | !PACKMITTEL1^nummer |
    | 1      | Externe Behälternummer ist bereits vergeben. | nein          | !PACKMITTEL2^nummer |
And I save the current subeditor to switch back to the parent editor
And I press button "packvor"
Then table has values
    | artikel  | mge |
    | RAD      | 2   |
    | RAHMEN   | 2   |
    | KLT      | 2   |
And I set field "ueb" to "ja"
And I save the current editor

# Then field "bhbuchung" has value "" in row 1
# Then field "bhbuchung" has value "" in row 2
# Then field "bhbuchung^mge" has value "1" in row 3
# Then field "bhbuchung^buart" has value "Zugang" in row 3
# Then field "bhbuchung^mge" has value "1" in row 4
# Then field "bhbuchung^buart" has value "Zugang" in row 4


Scenario: 03 Behaelter pruefen
And I switch the current editor to editor "PACKMITTEL1"
Then table has values
    | artikel | mge |
    | RAHMEN  | 1   |
    | RAD     | 2   |
And I close the current editor

And I switch the current editor to editor "PACKMITTEL2"
Then table has values
    | artikel | mge |
    | RAHMEN  | 1   |
    | RAD     | 2   |
And I close the current editor

