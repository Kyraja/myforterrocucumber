# *****************************************************************************
#  Name             : behaelter_ekre_mitmz_scenario05.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Lieferung ueber Rechnung mit Charge
#
# *****************************************************************************
@persistent
Feature: behaelter_ekre_mitmz_scenario05.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Chargen anlegen
And I create a Lot "SATTEL105" for Product "SATTEL"
And I create a Lot "SATTEL205" for Product "SATTEL"
And I create a Lot "SATTEL305" for Product "SATTEL"
And I create a Lot "RAD105" for Product "RAD"


Scenario: 05 Lieferung mit Charge
Given I open an editor "Rechnung05" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | RE_05   |
And I append rows
    | artikel | mge | exbehnum         | packm       | charge      |
    | SATTEL  | 5   | !dontChange      | !dontChange | !dontChange |
    | SATTEL  | 3   | !dontChange      | !dontChange | !dontChange |
    | SATTEL  | 1   | !dontChange      | !dontChange | !dontChange |
    | RAD     | 3   | !dontChange      | !dontChange | !dontChange |
    | SATTEL  | 3   | 8016_RECHNUNG05F | KLT         | !dontChange |
    | RAD     | 3   | 8016_RECHNUNG05D | KLT         | RAD105      |
    | RAD     | 3   | 8016_RECHNUNG05D | KLT         | RAD105      |
# eine Charge in einem Behaelter MZ
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row | exbehnum         | packm | charge    |
    | 1    | 8016_RECHNUNG05A | KLT   | SATTEL105 |
And I save the current subeditor to switch back to the parent editor
# mehrere Chargen und verw in einem Behaelter MZ
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I delete all rows
And I append rows
    | zuomge | exbehnum         | packm | charge    | verw          |
    | 1      | 8016_RECHNUNG05B | KLT   | SATTEL205 | !dontChange   |
    | 1      | 8016_RECHNUNG05B | KLT   | SATTEL205 | Verwendung05B |
    | 1      | 8016_RECHNUNG05B | KLT   | SATTEL305 | !dontChange   |
And I save the current subeditor to switch back to the parent editor
# verschiedene Artikel mit Charge ueber MZ in Behaelter
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I modify table
    | !row | exbehnum         | packm | charge    |
    | 1    | 8016_RECHNUNG05C | KLT   | SATTEL105 |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 4
And I delete all rows
And I append rows
    | zuomge | exbehnum         | packm | charge |
    | 3      | 8016_RECHNUNG05C | KLT   | RAD105 |
And I save the current subeditor to switch back to the parent editor
# verschiedene Artikel ueber MZ und Position in Behaelter
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 5
And I set field "mzueb" to "nein"
And I delete all rows
And I append rows
    | zuomge | exbehnum         | packm | charge    |
    | 1      | 8016_RECHNUNG05D | KLT   | SATTEL205 |
    | 1      | 8016_RECHNUNG05E | KLT   | SATTEL205 |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 6
And I set field "mzueb" to "nein"
And I delete all rows
And I append rows
    | zuomge | exbehnum         | packm |
    | 2      | 8016_RECHNUNG05E | KLT   |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 13.3. Lisa, Behaelterkonto wird nicht richtig gebucht, Test ist noch anzupassen, VERSAND-836
#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1


Scenario Outline: 05 Behaelter pruefen
And I open an editor "<record>" from table "(Container):(ContainerShell)" with command "VIEW" for record "<record>"
Then field "charge^such" has value "<chargesuch1>" in row <row>
Then field "verw" has value "<verw>" in row <row>
Then field "mge" has value "<mge>" in row <row>
And I close the current editor

Examples:
| record           | row | chargesuch1 |  verw         | mge |
| 8016_RECHNUNG05A | 1   | SATTEL105   |               | 5   |
| 8016_RECHNUNG05B | 1   | SATTEL205   |               | 1   |
| 8016_RECHNUNG05B | 2   | SATTEL205   | Verwendung05B | 1   |
| 8016_RECHNUNG05B | 3   | SATTEL305   |               | 1   |
| 8016_RECHNUNG05C | 1   | RAD105      |               | 6   |
| 8016_RECHNUNG05C | 2   | SATTEL105   |               | 1   |
| 8016_RECHNUNG05D | 1   | RAD105      |               | 8   |
| 8016_RECHNUNG05D | 2   | SATTEL205   |               | 1   |
| 8016_RECHNUNG05E | 1   | RAD105      |               | 4   |
| 8016_RECHNUNG05E | 2   | SATTEL205   |               | 1   |
| 8016_RECHNUNG05F | 1   |             |               | 1   |

