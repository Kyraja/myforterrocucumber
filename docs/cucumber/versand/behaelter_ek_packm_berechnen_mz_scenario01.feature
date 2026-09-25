# *****************************************************************************
#  Name             : behaelter_ek_packm_berechnen_mz_scenario01.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Packmittel berechnen, ein Artikel, Charge, ein Behaelter
#
# *****************************************************************************
@persistent
Feature: behaelter_ek_packm_berechnen_mz_scenario01.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Charge und Behaelter anlegen
And I create a Lot "CH_M01" for Product "RAD"
And I create a Container "CNT_CHARGE" for packaging material "KLT"


Scenario: 02 Lieferschein anlegen
Given I open an editor "EKLS01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | ebeleg | EKLS_M01 |
    | vom    | .        |
And I append rows
    | artikel | mge |
    | RAD     | 10  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | charge     | !dialogId                                     | !dialogAnswer | exbehnum           |
    | 6      | !CH_M01^id | Externe Behälternummer ist bereits vergeben. | nein          | !CNT_CHARGE^nummer |
    | 4      |            | Externe Behälternummer ist bereits vergeben. | nein          | !CNT_CHARGE^nummer |
And I save the current subeditor to switch back to the parent editor
And I press button "packvor"
Then table has values
    | artikel  | mge |
    | RAD      | 10  |
    | KLT      | 1   |
    | KLT      | 3   |
    | SPALETTE | 1   |
And I set field "ueb" to "ja"
And I save the current editor

# Then field "bhbuchung" has value "" in row 1
# Then field "bhbuchung^mge" has value "1" in row 2
# Then field "bhbuchung^buart" has value "Zugang" in row 2
# Then field "bhbuchung^mge" has value "3" in row 3
# Then field "bhbuchung^buart" has value "Zugang" in row 3


Scenario: 03 Behaelter pruefen
And I switch the current editor to editor "CNT_CHARGE"
Then table has values
    | artikel | mge | charge^id  |
    | RAD     | 8   | (0,0,0)    |
    | RAD     | 12  | !CH_M01^id |
And I close the current editor

