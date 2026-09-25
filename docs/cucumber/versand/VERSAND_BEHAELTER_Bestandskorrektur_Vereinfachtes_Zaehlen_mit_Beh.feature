@persistent
Feature: VERSAND_BEHAELTER_Bestandskorrektur_Vereinfachtes_Zaehlen_mit_Beh.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Bestandskorrektur_Vereinfachtes_Zaehlen_mit_Beh.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Vereinfachtes Zaehlen in der Bestandskorrektur mit Behaeltern
#  ref				: ref_behaelter_bestandskorrektur_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"

@testvorbereitung
Scenario Outline: Behaelter anlegen

Given I create a Container "<such>" for packaging material "KLT"

Examples:
| such           |
| VEREINFACHT_1  |
| VEREINFACHT_2  |
| VEREINFACHT_3  |
| VEREINFACHT_4  |
| VEREINFACHT_5  |
| VEREINFACHT_6  |
| VEREINFACHT_7  |
| VEREINFACHT_8  |
| VEREINFACHT_9  |
| VEREINFACHT_10 |

@testvorbereitung
Scenario Outline: Bestaende BAU-V-B

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BAU-V-B_1014    |
    | buart     | Zugang          |
    | beleg     | TEST_1014       |
    | beldat    | .               |
And I modify table
    | !row      | platz2   | mge   | projekt     | behaelter   |
    | +1        | <platz2> | <mge> | <projekt>   | <behaelter> |
And I save the current editor

Examples: Bestaende
| mge | platz2 | projekt     | behaelter     |
| 9   | F1     | !dontChange | VEREINFACHT_1 |
| 15  | F1     | VPROJEKT1   | VEREINFACHT_2 |
| 10  | F1     | VPROJEKT1   | !dontChange   |
| 10  | F1     | VPROJEKT1   | !dontChange   |

@testvorbereitung
Scenario Outline: Bestaende BED-V-B

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BED-V-B_1014    |
    | buart     | Zugang          |
    | beleg     | TEST_1014       |
    | beldat    | .               |
And I modify table
    | !row      | platz2   | mge   | behaelter   |
    | +1        | <platz2> | <mge> | <behaelter> |
And I save the current editor

Examples: Bestaende
| mge | platz2 | behaelter     |
| 9   | F1     | VEREINFACHT_3 |
| 2   | F1     | VEREINFACHT_4 |
| 10  | F1     | VEREINFACHT_5 |

@testvorbereitung
Scenario Outline: Bestaende AUF-V-B

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | AUFT-V-B_1014   |
    | buart     | Zugang          |
    | beleg     | TEST_1014       |
    | beldat    | .               |
And I modify table
    | !row      | platz2   | mge   | verw   | projekt     | behaelter   |
    | +1        | <platz2> | <mge> | <verw> | <projekt>   | <behaelter> |
And I save the current editor

Examples: Bestaende
| mge | platz2 | verw         | projekt     | behaelter     |
| 25  | F1     | Verwendung_A | !dontChange | VEREINFACHT_6 |
| 23  | F1     | VERWENDUNG_B | !dontChange | VEREINFACHT_6 |
| 15  | F1     | VERWENDUNG_C | !dontChange | VEREINFACHT_7 |
| 11  | F1     | VERWENDUNG_A | VPROJEKT2   | VEREINFACHT_8 |
| 7   | F1     | !dontChange  | VPROJEKT2   | VEREINFACHT_8 |
| 3   | F1     | VERWENDUNG_B | !dontChange | !dontChange   |

@testvorbereitung
Scenario Outline: Bestaende PROJ-V-B

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | PROJ-V-B_1014   |
    | buart     | Zugang          |
    | beleg     | TEST_1014       |
    | beldat    | .               |
And I modify table
    | !row      | platz2   | mge   | projekt     | behaelter   |
    | +1        | <platz2> | <mge> | <projekt>   | <behaelter> |
And I save the current editor

Examples: Bestaende
| mge | platz2 | projekt   | behaelter     |
| 9   | F1     | VPROJEKT1 | VEREINFACHT_1 |
| 15  | F1     | VPROJEKT1 | VEREINFACHT_8 |
| 33  | F1     | VPROJEKT1 | VEREINFACHT_9 |
| 18  | F1     | VPROJEKT1 | !dontChange   |

@testvorbereitung
Scenario Outline: Bestaende ACH-V-B

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | ACH-V-B_1014    |
    | buart     | Zugang          |
    | beleg     | TEST_1014       |
    | beldat    | .               |
And I modify table
    | !row      | platz2   | mge   | verw   | charge2     | behaelter   |
    | +1        | <platz2> | <mge> | <verw> | <charge2>   | <behaelter> |
And I save the current editor

Examples: Bestaende
| mge | platz2 | verw         | charge2       | behaelter   |
| 2   | F1     | VERWENDUNG_A | VCHARGE1_1014 | !dontChange |
| 5   | F1     | VERWENDUNG_B | VCHARGE1_1014 | !dontChange |
| 10  | F1     | VERWENDUNG_A | VCHARGE2_1014 | !dontChange |
| 96  | F1     | VERWENDUNG_B | VCHARGE2_1014 | !dontChange |
| 13  | F1     | VERWENDUNG_C | VCHARGE2_1014 | !dontChange |

@testvorbereitung
Scenario Outline: Bestaende EINH-V-B 

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EINH-V-B_1014   |
    | buart     | Zugang          |
    | beleg     | TEST_1014       |
    | beldat    | .               |
And I modify table
    | !row      | platz2   | mge   | verw   | projekt     | ze   | zele   | behaelter   |
    | +1        | <platz2> | <mge> | <verw> | <projekt>   | <ze> | <zele> | <behaelter> |
And I save the current editor

Examples: Bestande
| mge | platz2 | ze     | zele | verw         | projekt     | behaelter      |
| 4   | F1     | Stück  | 2    | VERWENDUNG_A | !dontChange | VEREINFACHT_10 |
| 10  | F1     | m      | 1    | VERWENDUNG_B | !dontChange | VEREINFACHT_1  |
| 20  | F1     | m      | 1    | VERWENDUNG_A | !dontChange | !dontChange    |
| 15  | F1     | kg     | 1    | VERWENDUNG_B | !dontChange | !dontChange    |

###########################################################################################

Scenario: 01 Bestand erhoehen, alle Artikel liegen ohne Behaelter auf Lagerplatz

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ACH-V-B_1014  |
    | beleg     | 01            |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "ja"
Then field "bestand" has value "126"
Then the table has 2 rows
Then table has values
    | mge   | charge1^such  | behaelter^such |
    |   7   | VCHARGE1_1014 |                |
    | 119   | VCHARGE2_1014 |                |
And I set field "mge" to "20" in row 1
Then field "zele" is not modifiable in row 1
Then field "charge1" is not modifiable in row 1
Then field "verw" is not modifiable in row 1
Then field "behaelter" is not modifiable in row 1
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | ACH-V-B_1014 |
    | klgruppe   |              |
	| details    | nein         |
And I press button "bstart"
Then field "lemge" has value "139" in row 1
Then field "lzu" is empty in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 6 rows
Then table has values
    | !row | gebmge | charge^such   | verw         | tbehaelter |
    | 1    | 13     | VCHARGE1_1014 |              |            |
    | 2    | 2      | VCHARGE1_1014 | VERWENDUNG_A |            |
    | 3    | 5      | VCHARGE1_1014 | VERWENDUNG_B |            |
    | 4    | 10     | VCHARGE2_1014 | VERWENDUNG_A |            |
    | 5    | 96     | VCHARGE2_1014 | VERWENDUNG_B |            |
    | 6    | 13     | VCHARGE2_1014 | VERWENDUNG_C |            |
And I close the current editor


Scenario: 02 Bestand erhoehen, alle Artikel liegen ohne Behaelter auf Lagerplatz, neuer Bestand ohne Behaelter

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ACH-V-B_1014  |
    | beleg     | 02            |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "ja"
Then field "bestand" has value "139"
Then the table has 2 rows
Then table has values
    | mge   | charge1^such  | behaelter^such |
    |  20   | VCHARGE1_1014 |                |
    | 119   | VCHARGE2_1014 |                |
And I append rows
    | platz | mge   |
    | F1    |  10   |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "zeae" in row 3
Then field "ze" has value "Stück" in row !lastRow
And I set field "charge1" to "VCHARGE3_1014" in row !lastRow
Then field "zele" is modifiable in row !lastRow
Then field "verw" is not modifiable in row !lastRow
Then field "behaelter" is not modifiable in row !lastRow
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | ACH-V-B_1014 |
    | klgruppe   |              |
	| details    | nein         |
And I press button "bstart"
Then field "lemge" has value "149" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 7 rows
Then field "lzu" is empty in row 1
Then field "tbehaelter" is empty in row 1
Then table has values
    | !row | gebmge | charge^such   | verw         |
    | 1    | 13     | VCHARGE1_1014 |              |
    | 2    | 2      | VCHARGE1_1014 | VERWENDUNG_A |
    | 3    | 5      | VCHARGE1_1014 | VERWENDUNG_B |
    | 4    | 10     | VCHARGE2_1014 | VERWENDUNG_A |
    | 5    | 96     | VCHARGE2_1014 | VERWENDUNG_B |
    | 6    | 13     | VCHARGE2_1014 | VERWENDUNG_C |
    | 7    | 10     | VCHARGE3_1014 |              |
And I close the current editor


Scenario: 03 Bestand verringern, alle Artikel liegen ohne Behaelter auf Lagerplatz

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ACH-V-B_1014  |
    | beleg     | 03            |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "ja"
Then field "bestand" has value "149"
Then the table has 3 rows
Then table has values
    | mge   | charge1^such  | behaelter^such |
    |  20   | VCHARGE1_1014 |                |
    | 119   | VCHARGE2_1014 |                |
    |  10   | VCHARGE3_1014 |                |
And I set field "mge" to "7" in row 1
Then field "charge1^such" has value "VCHARGE1_1014" in row 1
Then field "zele" is not modifiable in row 1
Then field "verw" is not modifiable in row 1
Then field "behaelter" is not modifiable in row 1
And I set field "mge" to "0" in row 3
Then field "charge1^such" has value "VCHARGE3_1014" in row 3
Then field "zele" is not modifiable in row 3
Then field "verw" is not modifiable in row 3
Then field "behaelter" is not modifiable in row 3
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | ACH-V-B_1014 |
    | klgruppe   |              |
	| details    | nein         |
And I press button "bstart"
Then field "lemge" has value "126" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 5 rows
Then field "tbehaelter" is empty in row 1
Then table has values
    | !row | gebmge | charge^such   | verw         |
    | 1    | 2      | VCHARGE1_1014 | VERWENDUNG_A |
    | 2    | 5      | VCHARGE1_1014 | VERWENDUNG_B |
    | 3    | 10     | VCHARGE2_1014 | VERWENDUNG_A |
    | 4    | 96     | VCHARGE2_1014 | VERWENDUNG_B |
    | 5    | 13     | VCHARGE2_1014 | VERWENDUNG_C |
And I close the current editor


Scenario: 04 Bestand erhoehen, alle Artikel liegen in Behaelter auf Lagerplatz

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | BED-V-B_1014  |
    | beleg     | 04            |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "nein"
Then field "bestand" has value "21"
Then the table has 3 rows
Then table has values
    | mge   | behaelter^such |
    |   9   | VEREINFACHT_3  |
    |   2   | VEREINFACHT_4  |
    |  10   | VEREINFACHT_5  |
And I set field "mge" to "15" in row 1
Then field "zele" is not modifiable in row 1
Then field "behaelter^such" has value "VEREINFACHT_3" in row 1
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | BED-V-B_1014 |
    | klgruppe   |              |
	| details    | nein         |
And I press button "bstart"
Then field "lemge" has value "27" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 3 rows
Then field "lzu" has value "" in row 1
Then table has values
| !row | gebmge | tbehaelter^such |
| 1    | 15     | VEREINFACHT_3   |
| 2    | 2      | VEREINFACHT_4   |
| 3    | 10     | VEREINFACHT_5   |
And I close the current editor


Scenario: 05 Bestand erhoehen, alle Artikel liegen in Behaelter auf Lagerplatz, neuer Bestand in bestehenden und leeren Behaelter

Given I create a Container "NEUERBEH_05" for packaging material "KLT"

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | BED-V-B_1014  |
    | beleg     | 05            |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "nein"
Then field "bestand" has value "27"
Then the table has 3 rows
Then table has values
    | mge   | behaelter^such |
    |  15   | VEREINFACHT_3  |
    |   2   | VEREINFACHT_4  |
    |  10   | VEREINFACHT_5  |
And I append rows
    | platz | mge   |
    | F1    |  13   |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
And I set field "behaelter" to "VEREINFACHT_2" in row !lastRow
And I append rows
    | platz | mge   |
    | F1    |  12   |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
And I set field "behaelter" to id from editor "NEUERBEH_05" in row !lastRow
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | BED-V-B_1014 |
    | klgruppe   |              |
	| details    | nein         |
And I press button "bstart"
Then field "lemge" has value "52" in row 1
Then field "lzu" has value "" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 5 rows
Then table has values
| !row | gebmge | tbehaelter^such |
| 1    | 13     | VEREINFACHT_2   |
| 2    | 15     | VEREINFACHT_3   |
| 3    | 2      | VEREINFACHT_4   |
| 4    | 10     | VEREINFACHT_5   |
| 5    | 12     | NEUERBEH_05     |
And I close the current editor

Scenario Outline: Behaelter pruefen
And I switch the current editor to editor "<such>"
Then the table has <sollrows> rows
Then table has values
    | !row   | artikel   | mge   | gebeinh   |
    | <row>  | <artikel> | <mge> | <gebeinh> |
And I close the current editor

Examples: 05 Behaelter pruefen
| such          | sollrows | row | artikel      | mge | gebeinh |
| VEREINFACHT_2 | 2        | 1   | BED-V-B_1014 | 13  | Stück   |
| NEUERBEH_05   | 1        | 1   | BED-V-B_1014 | 12  | Stück   |


Scenario: 06 Bestand verringern, alle Artikel liegen in Behaelter auf Lagerplatz

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | BED-V-B_1014  |
    | beleg     | 06            |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "nein"
Then field "bestand" has value "52"
Then the table has 5 rows
Then table has values
    | mge   | behaelter^such |
    |  13   | VEREINFACHT_2  |
    |  15   | VEREINFACHT_3  |
    |   2   | VEREINFACHT_4  |
    |  10   | VEREINFACHT_5  |
    |  12   | NEUERBEH_05    |
And I modify table
    | !row  | mge   |
    | 1     | 0     |
    | 2     | 9     |
    | 5     | 0     |
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | BED-V-B_1014 |
    | klgruppe   |              |
	| details    | nein         |
And I press button "bstart"
Then field "lemge" has value "21" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 3 rows
Then table has values
    | !row | gebmge | tbehaelter^such |
    | 1    | 9      | VEREINFACHT_3   |
    | 2    | 2      | VEREINFACHT_4   |
    | 3    | 10     | VEREINFACHT_5   |
And I close the current editor

# Behaelter pruefen
And I switch the current editor to editor "VEREINFACHT_2"
Then the table has 1 rows
And I close the current editor

And I switch the current editor to editor "NEUERBEH_05"
Then the table has 0 rows
And I close the current editor


Scenario: 07 Bestand erhoehen, Artikel liegen teilweise in Behaelter auf Lagerplatz

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EINH-V-B_1014 |
    | beleg     | 07            |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "nein"
Then field "bestand" has value "53"
Then the table has 4 rows
Then table has values
    | mge   | ze    | verw          | behaelter^such |
    |  20   | m     | VERWENDUNG_A  |                |
    |   4   | Stück | VERWENDUNG_A  | VEREINFACHT_10 |
    |  10   | m     | VERWENDUNG_B  | VEREINFACHT_1  |
    |  15   | kg    | VERWENDUNG_B  |                |
And I set field "mge" to "25" in row 1
Then field "zele" is not modifiable in row 1
Then field "verw" has value "VERWENDUNG_A" in row 1
Then field "behaelter" is empty in row 1
And I set field "mge" to "10" in row 2
Then field "zele" is not modifiable in row 2
Then field "verw" has value "VERWENDUNG_A" in row 2
Then field "behaelter^such" has value "VEREINFACHT_10" in row 2
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | EINH-V-B_1014 |
    | klgruppe   |               |
	| details    | nein          |
And I press button "bstart"
Then field "lemge" has value "70" in row 1
Then field "lzu" has value "" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 4 rows
Then table has values
    | !row | gebmge | verw         | tbehaelter^such |
    | 1    | 25     | VERWENDUNG_A |                 |
    | 2    | 10     | VERWENDUNG_A | VEREINFACHT_10  |
    | 3    | 10     | VERWENDUNG_B | VEREINFACHT_1   |
    | 4    | 15     | VERWENDUNG_B |                 |
And I close the current editor


Scenario: 08 Bestand erhoehen, Artikel liegen teilweise in Behaelter auf Lagerplatz, neuer Bestand in bestehenden, neuen und ohne Behaelter

Given I create a Container "NEUERBEH_08" for packaging material "BEHÄLTER"

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EINH-V-B_1014 |
    | beleg     | 08            |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "nein"
Then field "bestand" has value "70"
Then the table has 4 rows
Then table has values
    | mge   | ze    | verw          | behaelter^such |
    |  25   | m     | VERWENDUNG_A  |                |
    |  10   | Stück | VERWENDUNG_A  | VEREINFACHT_10 |
    |  10   | m     | VERWENDUNG_B  | VEREINFACHT_1  |
    |  15   | kg    | VERWENDUNG_B  |                |
And I append rows
    | platz | mge   |
    | F1    | 35    |
# Einheit m
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
Then field "ze" has value "m" in row !lastRow
And I set field "verw" to "VERWENDUNG_A" in row !lastRow
And I set field "behaelter" to id from editor "VEREINFACHT_2" in row !lastRow
And I append rows
    | platz | mge   |
    | F1    | 45    |
# Einheit Stueck
And I respond with answer "2" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
And I set field "verw" to "VERWENDUNG_A" in row !lastRow
And I set field "behaelter" to id from editor "NEUERBEH_08" in row !lastRow
And I append rows
    | platz | mge   |
    | F1    | 55    |
# Einheit kg
And I respond with answer "3" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | EINH-V-B_1014 |
    | klgruppe   |               |
	| details    | nein          |
And I press button "bstart"
Then field "lemge" has value "250" in row 1
Then field "lzu" has value "" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 7 rows
Then field "lzu" has value "" in row 2
Then field "lzu" has value "" in row 7
Then table has values
    | !row | gebmge | geinheit | verw         | tbehaelter^such |
    | 1    | 55     | kg       |              |                 |
    | 2    | 25     | m        | VERWENDUNG_A |                 |
    | 3    | 35     | m        | VERWENDUNG_A | VEREINFACHT_2   |
    | 4    | 10     | Stück    | VERWENDUNG_A | VEREINFACHT_10  |
    | 5    | 45     | Stück    | VERWENDUNG_A | NEUERBEH_08     |
    | 6    | 10     | m        | VERWENDUNG_B | VEREINFACHT_1   |
    | 7    | 15     | kg       | VERWENDUNG_B |                 |
And I close the current editor

Scenario Outline: 08 Behaelter pruefen
And I switch the current editor to editor "<such>"
Then the table has <sollrows> rows
Then table has values
    | !row   | artikel   | mge   | gebeinh   |
    | <row>  | <artikel> | <mge> | <gebeinh> |
And I close the current editor

Examples: 08 Behaelter pruefen
| such          | sollrows | row | artikel       | mge | gebeinh |
| VEREINFACHT_2 | 2        | 2   | BAU-V-B_1014  | 15  | Stück  |
| NEUERBEH_08   | 1        | 1   | EINH-V-B_1014 | 45  | Stück  |


Scenario: 09 Bestand verringern, Artikel liegen teilweise in Behaelter auf Lagerplatz

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EINH-V-B_1014 |
    | beleg     | 09            |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then field "vzaehlen" has value "nein"
Then field "bestand" has value "250"
Then the table has 7 rows
Then table has values
    | mge   | ze     | verw          | behaelter^such |
    |  55   | kg     |               |                |
    |  25   | m      | VERWENDUNG_A  |                |
    |  35   | m      | VERWENDUNG_A  | VEREINFACHT_2  |
    |  10   | Stück | VERWENDUNG_A  | VEREINFACHT_10 |
    |  45   | Stück | VERWENDUNG_A  | NEUERBEH_08    |
    |  10   | m      | VERWENDUNG_B  | VEREINFACHT_1  |
    |  15   | kg     | VERWENDUNG_B  |                |
And I modify table
    | !row  | mge   |
    | 1     |  0    |
    | 2     | 20    |
    | 3     |  0    |
    | 4     |  4    |
    | 5     |  0    |
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | EINH-V-B_1014 |
    | klgruppe   |               |
	| details    | nein          |
And I press button "bstart"
Then field "lemge" has value "53" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 4 rows
Then table has values
    | !row | gebmge | verw         | tbehaelter^such |
    | 1    | 20     | VERWENDUNG_A |                 |
    | 2    | 4      | VERWENDUNG_A | VEREINFACHT_10  |
    | 3    | 10     | VERWENDUNG_B | VEREINFACHT_1   |
    | 4    | 15     | VERWENDUNG_B |                 |
And I close the current editor

And I switch the current editor to editor "VEREINFACHT_2"
Then the table has 1 rows
And I close the current editor

And I switch the current editor to editor "NEUERBEH_08"
Then the table has 0 rows
And I close the current editor
