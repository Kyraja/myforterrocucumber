# *****************************************************************************
#  Name             : behaelter_ek_packm_berechnen_mz_scenario04.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Packmittel berechnen, ein Artikel, anderes Packmittel als in packanw
#
# *****************************************************************************
@persistent
Feature: behaelter_ek_packm_berechnen_mz_scenario04.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter erstellen
And I create a Container "KARTON1" for packaging material "SKARTON"
And I create a Container "KARTON2" for packaging material "SKARTON"


Scenario: 02 Lieferschein anlegen
Given I open an editor "EKLS04" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | ebeleg | EKLS_M04 |
    | vom    | .        |
And I append rows
    | artikel | mge |
    | RAD     | 10  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum        |
    | 6      | Externe Behälternummer ist bereits vergeben. | nein          | !KARTON1^nummer |
    | 4      | Externe Behälternummer ist bereits vergeben. | nein          | !KARTON2^nummer |
And I save the current subeditor to switch back to the parent editor
And I press button "packvor"
Then table has values
    | artikel  | mge |
    | RAD      | 10  |
    | SKARTON  | 1   |
    | SKARTON  | 1   |
And I set field "ueb" to "ja"
And I save the current editor

# Then field "bhbuchung" has value "" in row 1
# Then field "bhbuchung" has value "" in row 2
# Then field "bhbuchung" has value "" in row 3


Scenario Outline: 03 Behaelter pruefen
And I switch the current editor to editor "<behaelter>"
Then the table has 1 rows
Then field "mge" has value "<mge>" in row 1
And I close the current editor

Examples:
| behaelter | mge |
| KARTON1   | 12  |
| KARTON2   | 8   |

