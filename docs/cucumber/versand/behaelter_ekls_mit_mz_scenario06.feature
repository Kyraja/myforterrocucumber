# *****************************************************************************
#  Name             : behaelter_ekls_mit_mz_scenario06.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Einkaufslieferschein mit teilweiser Zuordnung ueber MZ
#
# *****************************************************************************
@persistent
Feature: behaelter_ekls_mit_mz_scenario06.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Behaelter erstellen
And I create a Container "M06A" for packaging material "KLT"
And I create a Container "M06B" for packaging material "KLT"
And I create a Container "M06C" for packaging material "KLT"


Scenario: 02 Einkauf Lieferschein Artikelmenge 100 MZ aber nur fuer 50 Stueck
Given I open an editor "EKLS06" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | ebeleg | EKLS_M06 |
    | vom    | .        |
And I append rows
    | artikel | mge |
    | PEDALE  | 100 |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "mzueb" to "nein"
And I delete all rows
And I append rows
    | lpsuch | zuomge | verw | !dialogId                                     | !dialogAnswer | exbehnum     |
    | F1     | 20     | M06A | Externe Behälternummer ist bereits vergeben. | nein          | !M06A^nummer |
    | F2     | 20     | M06B | Externe Behälternummer ist bereits vergeben. | nein          | !M06B^nummer |
    | F3     | 10     | M06C | Externe Behälternummer ist bereits vergeben. | nein          | !M06C^nummer |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 03 Lagerjournal pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "EKLS06"
And I press start
Then table has values
    | art    | zmge | verw | nplatz | mei    |
    | PEDALE | 20   | M06A | F1     | Paar   |
    | PEDALE | 20   | M06B | F2     | Paar   |
    | PEDALE | 10   | M06C | F3     | Paar   |
    | PEDALE | 100  |      | F1     | Stück |
And I close the current editor


Scenario Outline: 04 Behaelter pruefen
And I switch the current editor to editor "<record>"
Then field "platz" has value "<platz>"
Then field "artikel" has value "<artikel>" in row 1
Then field "mge" has value "<mge>" in row 1
Then field "verw" has value "<verw>" in row 1
And I close the current editor

Examples:
| record | platz | artikel | mge | verw |
| M06A   | F1    | PEDALE  | 40  | M06A |
| M06B   | F2    | PEDALE  | 40  | M06B |
| M06C   | F3    | PEDALE  | 20  | M06C |

