@persistent
Feature: VERSAND_BEHAELTER_Bestandskorrektur_Einheiten.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Bestandskorrektur_Einheiten.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Schreibbarkeit des Einheitenfelds in der Bestandskorrektur
#  ref              : ref_behaelter_bestandskorrektur_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"

@testvorbereitung
Scenario Outline: Vorbereitung Bestaende anlegen

Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel   | <artikel> |
    | buart     | Zugang    |
    | beleg     | <beleg>   |
    | beldat    | .         |
And I modify table
    | mge   | platz2    | ze     | zele    | !row  |
    | <mge> | <platz2>  | <ze>   | <zele>  | +1    |
And I save the current editor

Examples:
| artikel      | beleg     | platz2 |  mge | ze     | zele  |
| GEBINDE      | TEST_3000 | F1     |  10  | m      | 1     |
| GEBINDE      | TEST_9999 | F1     |  20  | m      | 1     |
| GEBINDE      | TEST_9999 | F1     |   5  | kg     | 1     |
| GEBINDE      | TEST_9999 | F1     |  17  | Stück  | 2     |
| OHNE_GEBINDE | TEST_9999 | F1     |  10  | m      | 1     |
| OHNE_GEBINDE | TEST_9999 | F2     |  20  | m      | 1     |
| OHNE_GEBINDE | TEST_9999 | F1     |   5  | kg     | 1     |
| OHNE_GEBINDE | TEST_9999 | F1     |  17  | Stück  | 2     |

@testvorbereitung
Scenario: Vorbereitung weitere Bestaende anlegen und LJ pruefen fuer Beleg TEST_9999

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EKTEIL_9999   |
    | buart     | Zugang        |
    | beleg     | TEST_9999     |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 10     | F1       |
    | 20     | F1       |
    | 15     | F2       |
And I save the current editor

Given I open the infosystem "LJ"
And I set fields
    | adatum    | .         |
    | beleg     | TEST_9999 |
And I press start
Then the table has 10 rows
Then table has values
    | art          | nplatz | zmge | mei    |
    | GEBINDE      | F1     | 20   | m      |
    | GEBINDE      | F1     | 5    | kg     |
    | GEBINDE      | F1     | 17   | Stück  |
    | OHNE_GEBINDE | F1     | 10   | m      |
    | OHNE_GEBINDE | F2     | 20   | m      |
    | OHNE_GEBINDE | F1     | 5    | kg     |
    | OHNE_GEBINDE | F1     | 17   | Stück  |
    | EKTEIL_9999  | F1     | 10   | Stück  |
    | EKTEIL_9999  | F1     | 20   | Stück  |
    | EKTEIL_9999  | F2     | 15   | Stück  |
And I close the current editor


Scenario: 01 Bestaende fuer Kaufteil ohne abweichende Einheiten korrigieren

Given I open an editor "Korr_EKTEIL" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EKTEIL_9999 |
    | beleg     | TEST_K_9999 |
    | beldat    | .           |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "45"
Then the table has 1 rows
Then table has values
    | mge   | ze    | 
    | 30    | Stück |
And I modify table
    | !row  | mge   |
    | 1     | 18    |
And I append rows
    | platz | mge   | ze    | zele |
    | F1    | 99    | Stück | 2    |
And I save the current editor

Given I open the infosystem "LJ"
And I set fields
    | adatum    | .           |
    | beleg     | TEST_K_9999 |
    | artikel   | EKTEIL_9999 |
And I press start
Then the table has 2 rows
Then table has values
    | art          | vplatz | kmge | mei    |
    | EKTEIL_9999  | F1     | -12  | Stück  |
    | EKTEIL_9999  | F1     |  99  | Stück  |
And I close the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | EKTEIL_9999 |
    | klplatz    | F1          |
    | verdichten | nein        |
	| details    | nein        |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 3 rows
Then table has values
    | lemge | gebmge | geinheit | gebf |
    | 216   |        |          |      |
    |       | 18     | Stück    | 1    |
    |       | 99     | Stück    | 2    |
And I close the current editor


Scenario: 02 Bestaende fuer Einkaufsartikel mit Einheiten und Gebindepflicht korrigieren

Given I open an editor "Korr_GEBINDE" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | GEBINDE     |
    | beleg     | TEST_K_9999 |
    | beldat    | .           |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "69"
Then the table has 3 rows
Then table has values
    | !row  | mge   | ze    | 
    | 1     | 30    | m     |
And I set field "mge" to "2" in row 1
Then table has values
    | !row  | mge   | ze    | 
    | 2     | 5     | kg    |
And I set field "mge" to "10" in row 2
Then table has values
    | !row  | mge   | ze    | 
    | 3     | 17    | Stück |
And I set field "mge" to "20" in row 3
And I append rows
    | platz | mge   | ze    | zele |
    | F1    | 4     | Stück | 6    |
    | F1    | 5     | m     | 5    |
    | F1    | 6     | kg    | 4    |
And I save the current editor

Given I open the infosystem "LJ"
And I set fields
    | adatum    | .           |
    | beleg     | TEST_K_9999 |
    | artikel   | GEBINDE     |
And I press start
Then the table has 6 rows
Then table has values
    | art     | vplatz | kmge | mei    |
    | GEBINDE | F1     | -28  | m      |
    | GEBINDE | F1     |   5  | m      |
    | GEBINDE | F1     |   5  | kg     |
    | GEBINDE | F1     |   6  | kg     |
    | GEBINDE | F1     |   3  | Stück  |
    | GEBINDE | F1     |   4  | Stück  |
And I close the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | GEBINDE |
    | klplatz    | F1      |
    | verdichten | nein    |
	| details    | nein    |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 9 rows
Then table has values
    | lemge | gebmge | geinheit | gebf |
    | 125   |        |          |      |
    |       | 2      | m        | 1    |
    |       | 5      | kg       | 1    |
    |       | 17     | Stück    | 2    |
    |       | 5      | m        | 5    |
    |       | 5      | kg       | 1    |
    |       | 6      | kg       | 4    |
    |       | 3      | Stück    | 2    |
    |       | 4      | Stück    | 6    |
And I close the current editor


Scenario: 03 Bestaende fuer Kaufteil Einheit m ohne Gebindeeinheiten korrigieren

Given I open an editor "Korr_NOGEBINDE" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | OHNE_GEBINDE |
    | beleg     | TEST_K_9999  |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "69"
Then the table has 1 rows
Then table has values
    | mge   | ze | 
    | 49    | m  |
And I modify table
    | !row  | platz         | mge   |
    | 1     | !dontChange   | 50    |
    | +2    | F1            | 4     |
# 1361 Ungültiger Feldwert
Then setting field "ze" to "Stück" in row 2 throws the exception "1361"
And I set field "ze" to "m" in row 2
And I close the current editor
