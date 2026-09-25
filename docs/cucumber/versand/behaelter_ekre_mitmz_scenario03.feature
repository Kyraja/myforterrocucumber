# *****************************************************************************
#  Name             : behaelter_ekre_mitmz_scenario03.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Rechnung mL, in bestehende Behaelter buchen
#
# *****************************************************************************
@persistent
Feature: behaelter_ekre_mitmz_scenario03.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter anlegen
And I create a Container "behaelter03A" for packaging material "KLT"
And I create a Container "behaelter03B" for packaging material "KLT"
And I create a Container "behaelter03C" for packaging material "KLT"
And I create a Container "behaelter03D" for packaging material "KLT"
And I create a Container "behaelter03E" for packaging material "KLT"


Scenario: 02 in bestehende Behaelter buchen
Given I open an editor "Rechnung03" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | RE_03   |
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | SATTEL  | 10  |                                               |               | !dontChange          |
    | SATTEL  | 20  |                                               |               | !dontChange          |
    | RAD     | 20  |                                               |               | !dontChange          |
    | PEDALE  | 2   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter03E^nummer |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | 5      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter03A^nummer |
    | 5      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter03B^nummer |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | 5      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter03A^nummer |
    | 5      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter03C^nummer |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | 5      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter03B^nummer |
    | 5      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter03D^nummer |
    | 5      | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter03E^nummer |
And I save the current subeditor to switch back to the parent editor
And I modify table
    | !row | mge | !dialogId                                     | !dialogAnswer | exbehnum             |
    | 2    | 20  | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter03D^nummer |
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


Scenario Outline: 03 Behaelter pruefen
And I open an editor "<record>" from table "(Container):(ContainerShell)" with command "VIEW" for record "<record>"
Then field "mge" has value "<mge>" in row <row>
And I close the current editor

Examples:
| record       | row | mge |
| behaelter03A | 1   | 10  |
| behaelter03B | 1   | 10  |
| behaelter03B | 2   | 5   |
| behaelter03C | 1   | 5   |
| behaelter03D | 1   | 10  |
| behaelter03D | 2   | 10  |
| behaelter03E | 1   | 10  |
| behaelter03E | 2   | 4   |

