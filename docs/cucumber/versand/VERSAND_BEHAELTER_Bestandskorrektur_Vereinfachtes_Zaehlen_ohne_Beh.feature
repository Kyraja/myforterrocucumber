@persistent
Feature: VERSAND_BEHAELTER_Bestandskorrektur_Vereinfachtes_Zaehlen_ohne_Beh.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Inventur_Vereinfachtes_Zaehlen_ohne_Beh.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Vereinfachtes Zaehlen bei Inventur ohne Behaelter
#  ref              : ref_behaelter_bestandskorrektur_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"

@testvorbereitung
Scenario Outline: Bestaende AUF-V-B
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | AUFT-V_1024    |
    | buart     | Zugang         |
    | beleg     | TEST_1024      |
    | beldat    | .              |
And I modify table
    | !row      | platz2   | mge   | verw   | projekt     |
    | +1        | <platz2> | <mge> | <verw> | <projekt>   |
And I save the current editor

Examples: Bestaende
| mge | platz2 | verw         | projekt     |
| 25  | F1     | Verwendung_A | !dontChange |
| 23  | F1     | VERWENDUNG_B | !dontChange |
| 15  | F1     | VERWENDUNG_C | !dontChange |
| 11  | F1     | VERWENDUNG_A | VPROJEKT2   |
| 7   | F1     | !dontChange  | VPROJEKT2   |
| 3   | F1     | VERWENDUNG_B | VPROJEKT2   |

@testvorbereitung
Scenario Outline: Bestaende PROJ-V-B
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | PROJ-V_1024    |
    | buart     | Zugang         |
    | beleg     | TEST_1024      |
    | beldat    | .              |
And I modify table
    | !row      | platz2   | mge   | projekt     |
    | +1        | <platz2> | <mge> | <projekt>   |
And I save the current editor

Examples: Bestaende
| mge | platz2 | projekt   |
| 24  | F1     | VPROJEKT1 |
| 51  | F1     | VPROJEKT2 |

@testvorbereitung
Scenario Outline: Bestaende ACH-V-B
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | ACH-V_1024    |
    | buart     | Zugang        |
    | beleg     | TEST_1024     |
    | beldat    | .             |
And I modify table
    | !row      | platz2   | mge   | verw   | charge2     |
    | +1        | <platz2> | <mge> | <verw> | <charge2>   |
And I save the current editor

Examples: Bestaende
| mge | platz2 | verw         | charge2       |
| 2   | F1     | VERWENDUNG_A | ZCHARGE1_1024 |
| 5   | F1     | VERWENDUNG_B | ZCHARGE1_1024 |
| 10  | F1     | VERWENDUNG_A | ZCHARGE2_1024 |
| 96  | F1     | VERWENDUNG_B | ZCHARGE2_1024 |
| 13  | F1     | VERWENDUNG_C | ZCHARGE2_1024 |

@testvorbereitung
Scenario Outline: Bestaende EINH-V-B 
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EINH-V_1024    |
    | buart     | Zugang         |
    | beleg     | TEST_1024      |
    | beldat    | .              |
And I modify table
    | !row      | platz2   | mge   | ze     | zele   | verw   | projekt     |
    | +1        | <platz2> | <mge> | <ze>   | <zele> | <verw> | <projekt>   |
And I save the current editor

Examples: Bestande
| mge | platz2 | ze     | zele | verw         | projekt     |
| 4   | F1     | Stück  | 2    | VERWENDUNG_A | VPROJEKT1   |
| 10  | F1     | m      | 1    | VERWENDUNG_B | VPROJEKT1   |
| 20  | F1     | m      | 1    | VERWENDUNG_A | !dontChange |
| 15  | F1     | kg     | 1    | VERWENDUNG_B | !dontChange |

#############################################################################################

Scenario: 01 Bestand erhoehen, auftragsbezogener Artikel

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ACH-V_1024  |
    | beleg     | 01          |
    | beldat    | .           |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "ja"
Then field "bestand" has value "126"
Then the table has 2 rows
Then table has values
    | mge   | charge1^such  |
    |   7   | ZCHARGE1_1024 |
    | 119   | ZCHARGE2_1024 |
And I set field "mge" to "20" in row 1
Then field "zele" is not modifiable in row 1
Then field "charge1" is not modifiable in row 1
Then field "verw" is not modifiable in row 1
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | ACH-V_1024 |
    | klgruppe   |            |
	| details    | nein       |
And I press button "bstart"
Then field "lemge" has value "139" in row 1
Then field "lzu" is empty in row 1
And I set field "verdichten" to "nein"
And I press button "bstart"
Then the table has 7 rows
Then table has values
    | !row | gebmge | charge^such   | verw         |
    | 2    | 2      | ZCHARGE1_1024 | VERWENDUNG_A |
    | 3    | 5      | ZCHARGE1_1024 | VERWENDUNG_B |
    | 4    | 10     | ZCHARGE2_1024 | VERWENDUNG_A |
    | 5    | 96     | ZCHARGE2_1024 | VERWENDUNG_B |
    | 6    | 13     | ZCHARGE2_1024 | VERWENDUNG_C |
    | 7    | 13     | ZCHARGE1_1024 |              |
And I close the current editor


Scenario: 02 Bestand erhoehen, auftragsbezogener Artikel, neuer Bestand

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ACH-V_1024  |
    | beleg     | 02          |
    | beldat    | .           |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "ja"
Then field "bestand" has value "139"
Then the table has 2 rows
Then table has values
    | mge   | charge1^such  |
    |  20   | ZCHARGE1_1024 |
    | 119   | ZCHARGE2_1024 |
And I append rows
    | platz | mge   |
    | F1    | 10    |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "zeae" in row 3
Then field "ze" has value "Stück" in row !lastRow
And I set field "charge1" to "ZCHARGE3_1024" in row !lastRow
Then field "zele" is modifiable in row !lastRow
Then field "verw" is not modifiable in row !lastRow
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | ACH-V_1024 |
    | klgruppe   |            |
	| details    | nein       |
And I press button "bstart"
Then field "lemge" has value "149" in row 1
Then field "lzu" is empty in row 1
And I set field "verdichten" to "nein"
And I press button "bstart"
Then the table has 8 rows
Then field "lzu" has value "" in row 1
Then table has values
    | !row | gebmge | charge^such   | verw         |
    | 2    | 2      | ZCHARGE1_1024 | VERWENDUNG_A |
    | 3    | 5      | ZCHARGE1_1024 | VERWENDUNG_B |
    | 4    | 10     | ZCHARGE2_1024 | VERWENDUNG_A |
    | 5    | 96     | ZCHARGE2_1024 | VERWENDUNG_B |
    | 6    | 13     | ZCHARGE2_1024 | VERWENDUNG_C |
    | 7    | 13     | ZCHARGE1_1024 |              |
    | 8    | 10     | ZCHARGE3_1024 |              |
And I close the current editor


Scenario: 03 Bestand verringern, alle Artikel liegen ohne Behaelter auf Lagerplatz

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ACH-V_1024  |
    | beleg     | 03          |
    | beldat    | .           |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "ja"
Then field "bestand" has value "149"
Then the table has 3 rows
Then table has values
    | mge   | charge1^such  |
    |  20   | ZCHARGE1_1024 |
    | 119   | ZCHARGE2_1024 |
    |  10   | ZCHARGE3_1024 |
And I set field "mge" to "7" in row 1
Then field "charge1^such" has value "ZCHARGE1_1024" in row 1
Then field "zele" is not modifiable in row 1
Then field "verw" is not modifiable in row 1
And I set field "mge" to "0" in row 3
Then field "charge1^such" has value "ZCHARGE3_1024" in row 3
Then field "zele" is not modifiable in row 3
Then field "verw" is not modifiable in row 3
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | ACH-V_1024 |
    | klgruppe   |            |
	|  details   | nein       |
And I press button "bstart"
Then field "lemge" has value "126" in row 1
And I set field "verdichten" to "nein"
And I press button "bstart"
Then the table has 6 rows
Then table has values
    | !row | gebmge | charge^such   | verw         |
    | 2    | 2      | ZCHARGE1_1024 | VERWENDUNG_A |
    | 3    | 5      | ZCHARGE1_1024 | VERWENDUNG_B |
    | 4    | 10     | ZCHARGE2_1024 | VERWENDUNG_A |
    | 5    | 96     | ZCHARGE2_1024 | VERWENDUNG_B |
    | 6    | 13     | ZCHARGE2_1024 | VERWENDUNG_C |
And I close the current editor


Scenario: 04 Bestand erhoehen, gebindepflichtiger Artikel

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EINH-V_1024 |
    | beleg     | 04          |
    | beldat    | .           |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "ja"
Then field "bestand" has value "53"
Then the table has 3 rows
Then table has values
    | mge   | ze    | verw    |
    |  30   | m     |         | 
    |  15   | kg    |         | 
    |   4   | Stück |         | 
And I set field "mge" to "50" in row 1
Then field "zele" is not modifiable in row 1
Then field "verw" is not modifiable in row 1
And I set field "mge" to "30" in row 2
Then field "zele" is not modifiable in row 2
Then field "verw" is not modifiable in row 2
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | EINH-V_1024 |
    | klgruppe   |             |
	| details    | nein        |
And I press button "bstart"
Then field "lemge" has value "88" in row 1
And I set field "verdichten" to "nein"
And I press button "bstart"
Then the table has 7 rows
Then table has values
    | !row | gebmge | verw         |
    | 2    | 4      | VERWENDUNG_A |
    | 3    | 10     | VERWENDUNG_B |
    | 4    | 20     | VERWENDUNG_A |
    | 5    | 15     | VERWENDUNG_B |
    | 6    | 20     |              |
    | 7    | 15     |              |
And I close the current editor


Scenario: 05 Bestand erhoehen, gebindepflichtiger Artikel, neuer Bestand

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EINH-V_1024 |
    | beleg     | 05          |
    | beldat    | .           |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "ja"
Then field "bestand" has value "88"
Then the table has 3 rows
Then table has values
    | mge   | ze    | verw    |
    |  50   | m     |         | 
    |  30   | kg    |         | 
    |   4   | Stück |         | 
# Einheit m
And I append rows
    | platz | mge   |
    | F1    | 35    |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
Then field "ze" has value "m" in row !lastRow
And I set field "zele" to "0,5" in row !lastRow
Then field "verw" is not modifiable in row !lastRow
# Einheit Stueck
And I append rows
    | platz | mge   |
    | F1    | 45    |
And I respond with answer "2" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
Then field "ze" has value "Stück" in row !lastRow
And I set field "zele" to "1,5" in row !lastRow
Then field "verw" is not modifiable in row !lastRow
# Einheit kg
And I append rows
    | platz | mge   |
    | F1    | 55    |
And I respond with answer "3" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
Then field "ze" has value "kg" in row !lastRow
And I set field "zele" to "2" in row !lastRow
Then field "verw" is not modifiable in row !lastRow
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | EINH-V_1024 |
    | klgruppe   |             |
	| details    | nein        |
And I press button "bstart"
Then field "lemge" has value "283" in row 1
And I set field "verdichten" to "nein"
And I press button "bstart"
Then the table has 10 rows
Then table has values
    | !row | gebmge | geinheit | verw         | gebf |
    | 2    | 4      | Stück    | VERWENDUNG_A | 2    |
    | 3    | 10     | m        | VERWENDUNG_B | 1    |
    | 4    | 20     | m        | VERWENDUNG_A | 1    |
    | 5    | 15     | kg       | VERWENDUNG_B | 1    |
    | 6    | 20     | m        |              | 1    |
    | 7    | 15     | kg       |              | 1    |
    | 8    | 35     | m        |              | 0.5  |
    | 9    | 55     | kg       |              | 2    |
    | 10   | 45     | Stück    |              | 1.5  |
And I close the current editor


Scenario: 06 Bestand verringern, gebindepflichtiger Artikel

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EINH-V_1024 |
    | beleg     | 06          |
    | beldat    | .           |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "ja"
Then field "bestand" has value "283"
Then the table has 6 rows
Then table has values
    | mge   | ze    |
    |  35   | m     |
    |  50   | m     |
    |  30   | kg    |
    |  55   | kg    | 
    |  45   | Stück |
    |   4   | Stück | 
And I modify table
    | !row  | mge   |
    | 1     | 0     |
    | 2     | 20    |
    | 3     | 15    |
    | 4     | 0     |
    | 5     | 0     |
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | EINH-V_1024 |
    | klgruppe   |             |
	| details    | nein        |
And I press button "bstart"
Then field "lemge" has value "43" in row 1
And I set field "verdichten" to "nein"
And I press button "bstart"
Then the table has 5 rows
Then table has values
    | !row | gebmge | verw         |
    | 2    | 4      | VERWENDUNG_A |
    | 3    | 10     | VERWENDUNG_B |
    | 4    | 10     | VERWENDUNG_A |
    | 5    | 15     | VERWENDUNG_B |
And I close the current editor
