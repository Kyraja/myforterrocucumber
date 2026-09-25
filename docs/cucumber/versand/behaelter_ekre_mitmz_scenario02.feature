# *****************************************************************************
#  Name             : behaelter_ekre_mitmz_scenario02.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Neue Behaelter ueber Rechnung erstellen
#
# *****************************************************************************
@persistent
Feature: behaelter_ekre_mitmz_scenario02.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Neue Behaelter ueber Rechnung erstellen
Given I open an editor "Rechnung02" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | RE_02   |
And I append rows
    | artikel | mge | exbehnum          | packm       |
    | SATTEL  | 10  | !dontChange       | !dontChange |
    | SATTEL  | 20  | !dontChange       | !dontChange |
    | RAD     | 20  | !dontChange       | !dontChange |
    | PEDALE  | 2   | 8016_RECHNUNG02_5 | KLT         |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | exbehnum          | packm |
    | 5      | 8016_RECHNUNG02_1 | KLT   |
    | 5      | 8016_RECHNUNG02_2 | KLT   |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I delete all rows
And I append rows
    | zuomge | exbehnum          | packm |
    | 5      | 8016_RECHNUNG02_1 | KLT   |
    | 5      | 8016_RECHNUNG02_3 | KLT   |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I delete all rows
And I append rows
    | zuomge | exbehnum          | packm |
    | 5      | 8016_RECHNUNG02_2 | KLT   |
    | 5      | 8016_RECHNUNG02_4 | KLT   |
    | 5      | 8016_RECHNUNG02_5 | KLT   |
And I save the current subeditor to switch back to the parent editor
And I modify table
    | !row | mge | exbehnum          | packm |
    | 2    | 20  | 8016_RECHNUNG02_4 | KLT   |
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 16.7. Lisa, Behaelterbuchung funktioniert nicht, VERSAND-836
#Then field "bhbuchung^mge" has value "2" in row 1
#Then field "bhbuchung^buart" has value "Zugang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1
#Then field "bhbuchung^mge" has value "2" in row 2
#Then field "bhbuchung^buart" has value "Zugang" in row 2
#Then field "bhbuchung^mge" has value "1" in row 3
#Then field "bhbuchung^buart" has value "Zugang" in row 3
#Then field "bhbuchung^mge" has value "0" in row 4


Scenario Outline: 02 Behaelter pruefen
And I open an editor "<record>" from table "(Container):(ContainerShell)" with command "VIEW" for record "<record>"
Then field "mge" has value "<mge>" in row <row>
And I close the current editor

Examples:
| record            | row | mge |
| 8016_RECHNUNG02_1 | 1   | 10  |
| 8016_RECHNUNG02_2 | 1   | 10  |
| 8016_RECHNUNG02_2 | 2   | 5   |
| 8016_RECHNUNG02_3 | 1   | 5   |
| 8016_RECHNUNG02_4 | 1   | 10  |
| 8016_RECHNUNG02_4 | 2   | 10  |
| 8016_RECHNUNG02_5 | 1   | 10  |
| 8016_RECHNUNG02_5 | 2   | 4   |

