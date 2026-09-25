# *****************************************************************************
#  Name             : behaelter_ekls_mit_mz_scenario04.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Behaelter anlegen und fuellen ueber Einkaufslieferschein
#
# *****************************************************************************
@persistent
Feature: behaelter_ekls_mit_mz_scenario04.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Einkauf Lieferschein mehrere Artikel in Behaelter ohne Charge
Given I open an editor "EKLS04" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | ebeleg | EKLS_M04 |
    | vom    | .        |
And I append rows
    | artikel | mge |
    | SATTEL  | 5   |
    | SATTEL  | 5   |
    | SATTEL  | 5   |

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | exbehnum  | packm | verw  |
    | F1     | 2      | 7089_M04A | KLT   | M04AP |
    | F2     | 2      | 7089_M04B | KLT   | M04BP |
    | F3     | 1      | 7089_M04C | KLT   | M04CP |
And I save the current subeditor to switch back to the parent editor

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I delete all rows
And I append rows
    | lpsuch | zuomge | exbehnum  | packm | verw  |
    | F1     | 2      | 7089_M04A | KLT   | M04AR |
    | F2     | 2      | 7089_M04B | KLT   | M04BR |
    | F3     | 1      | 7089_M04C | KLT   | M04CR |
And I save the current subeditor to switch back to the parent editor

And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 3
And I delete all rows
And I append rows
    | lpsuch | zuomge | exbehnum  | packm | verw  |
    | F1     | 2      | 7089_M04A | KLT   | M04AS |
    | F2     | 2      | 7089_M04B | KLT   | M04BS |
    | F3     | 1      | 7089_M04C | KLT   | M04CS |
And I save the current subeditor to switch back to the parent editor

And I set field "ueb" to "ja"
And I save the current editor


Scenario: 02 Lagerjournal pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "EKLS04"
And I press start
Then table has values
    | art    | zmge | verw  |
    | SATTEL | 2    | M04AP |
    | SATTEL | 2    | M04BP |
    | SATTEL | 1    | M04CP |
    | SATTEL | 2    | M04AR |
    | SATTEL | 2    | M04BR |
    | SATTEL | 1    | M04CR |
    | SATTEL | 2    | M04AS |
    | SATTEL | 2    | M04BS |
    | SATTEL | 1    | M04CS |
And I close the current editor


Scenario Outline: 03 Behaelter pruefen
Given I open an editor "behaelter" from table "(Container):(ContainerShell)" with command "VIEW" for record "<record>"
Then the table has 3 rows
Then field "platz" has value "<platz>"
Then field "artikel" has value "SATTEL" in row <row>
Then field "mge" has value "<mge>" in row <row>
Then field "verw" has value "<verw>" in row <row>
And I close the current editor

Examples:
| record    | platz | row | mge | verw  |
| 7089_M04A | F1    | 1   | 2   | M04AP |
| 7089_M04A | F1    | 2   | 2   | M04AR |
| 7089_M04A | F1    | 3   | 2   | M04AS |
| 7089_M04B | F2    | 1   | 2   | M04BP |
| 7089_M04B | F2    | 2   | 2   | M04BR |
| 7089_M04B | F2    | 3   | 2   | M04BS |
| 7089_M04C | F3    | 1   | 1   | M04CP |
| 7089_M04C | F3    | 2   | 1   | M04CR |
| 7089_M04C | F3    | 3   | 1   | M04CS |

