# *****************************************************************************
#  Name             : behaelter_ek_packm_berechnen_mz_scenario03.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Packmittel berechnen, ein Artikel in mehreren Zeilen, mehrere Behaelter MZ und Artikelzeile
#
# *****************************************************************************
@persistent
Feature: behaelter_ek_packm_berechnen_mz_scenario03.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Charge anlegen
And I create a Lot "CH_M03" for Product "RAD"


Scenario: 02 Behaelter anlegen
And I create a Container "PACKM1" for packaging material "KLT"
And I create a Container "PACKM2" for packaging material "KLT"
And I create a Container "PACKM3" for packaging material "KLT"
And I create a Container "PACKM4" for packaging material "KLT"
And I create a Container "PACKM5" for packaging material "KLT"


Scenario: 03 Lieferschein anlegen und verbuchen
Given I open an editor "EKLS03" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | ebeleg | EKLS_M03 |
    | vom    | .        |
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum       | charge     |
    | RAD     | 10  | Externe Behälternummer ist bereits vergeben. | nein          | !PACKM3^nummer |            |
    | RAD     | 5   |                                               |               |                | !CH_M03^id |
    | RAD     | 10  | Externe Behälternummer ist bereits vergeben. | nein          | !PACKM5^nummer |            |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "mzueb" to "nein"
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum       |
    | 2      | Externe Behälternummer ist bereits vergeben. | nein          | !PACKM1^nummer |
    | 2      | Externe Behälternummer ist bereits vergeben. | nein          | !PACKM2^nummer |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "mzueb" to "nein"
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum       |
    | 2      | Externe Behälternummer ist bereits vergeben. | nein          | !PACKM4^nummer |
And I save the current subeditor to switch back to the parent editor
And I press button "packvor"
Then table has values
    | artikel  | mge | fmenge |
    | RAD      | 10  | 10     |
    | KLT      | 1   | 6      |
    | KLT      | 2   | 2      |
    | RAD      | 5   | 10     |
    | KLT      | 1   | 5      |
    | KLT      | 3   | 0      |
    | SPALETTE | 1   | 4      |
    | RAD      | 10  | 10     |
    | KLT      | 1   | 10     |
    | KLT      | 3   | 0      |
    | SPALETTE | 1   | 4      |
And I set field "ueb" to "ja"
And I save the current editor

# Then field "bhbuchung^mge" has value "1" in row 2
# Then field "bhkto^such" has value "KNTKETTLER" in row 2
# Then field "bhbuchung^mge" has value "2" in row 3
# Then field "bhkto^such" has value "KNTKETTLER" in row 3
# Then field "bhbuchung^mge" has value "1" in row 5
# Then field "bhkto^such" has value "KNTKETTLER" in row 5
# Then field "bhbuchung^mge" has value "3" in row 6
# Then field "bhkto^such" has value "KNTKETTLER" in row 6


Scenario Outline: 04 Behaelter pruefen
And I open an editor "behaelter" from table "(Container):(ContainerShell)" with command "VIEW" for record "<record>"
Then the table has 1 rows
Then field "mge" has value "<mge>" in row 1
And I close the current editor

Examples:
| record | mge |
| PACKM1 | 4   |
| PACKM2 | 4   |
| PACKM3 | 12  |
| PACKM4 | 4   |
| PACKM5 | 20  |

