# *****************************************************************************
#  Name             : behaelter_ek_packm_berechnen_mz_scenario05.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Packmittel berechnen, ein Artikel, anderes und gleiches Packmittel wie in packanw
#
# *****************************************************************************
@persistent
Feature: behaelter_ek_packm_berechnen_mz_scenario05.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter erstellen
And I create a Container "KARTON" for packaging material "SKARTON"
And I create a Container "KLT" for packaging material "KLT"


Scenario: 02 Lieferschein anlegen
Given I open an editor "EKLS05" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | ebeleg | EKLS_M05 |
    | vom    | .        |
And I append rows
    | artikel | mge |
    | RAD     | 10  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "mzueb" to "nein"
And I delete all rows
And I append rows
    | zuomge | !dialogId                                     | !dialogAnswer | exbehnum       |
    | 6      | Externe Behälternummer ist bereits vergeben. | nein          | !KARTON^nummer |
    | 4      | Externe Behälternummer ist bereits vergeben. | nein          | !KLT^nummer    |
And I save the current subeditor to switch back to the parent editor
And I press button "packvor"
Then table has values
    | artikel  | mge |
    | RAD      | 10  |
    | KLT      | 1   |
    | SKARTON  | 1   |
And I set field "ueb" to "ja"
And I save the current editor

# Then field "bhbuchung" has value "" in row 1
# Then field "bhbuchung^mge" has value "1" in row 2
# Then field "bhbuchung^buart" has value "Zugang" in row 2
# Then field "bhbuchung" has value "" in row 3


Scenario Outline: 02 Behaelter pruefen
And I switch the current editor to editor "<behaelter>"
Then the table has 1 rows
Then field "mge" has value "<mge>" in row 1
And I close the current editor

Examples:
| behaelter | mge |
| KARTON    | 12  |
| KLT       | 8   |

