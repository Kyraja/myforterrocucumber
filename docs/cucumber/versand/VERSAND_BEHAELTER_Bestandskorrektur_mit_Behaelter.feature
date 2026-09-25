@persistent
Feature: VERSAND_BEHAELTER_Bestandskorrektur_mit_Behaelter.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Bestandskorrektur_mit_Behaelter.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Bestandskorrektur mit Behaeltern
#  ref				: ref_behaelter_bestandskorrektur_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"

@testvorbereitung
Scenario Outline: Behaelter anlegen

Given I create a Container "<such>" for packaging material "KLT"

Examples:
| such                    |
| ACHARGE_AUFTRAG1        |
| ACHARGE_CHARGE_PROJEKT1 |
| ACHARGE_CHARGE1         |
| ACHARGE_PROJEKT1        |
| AEINH_EKTEIL_ERWBED1    |
| AEINH_LOHNF_PROJEKT1    |
| AEINHEIT_CHARGE1        |
| AEINHEIT_MINDESTB1      |
| AEINHEIT_PROJEKT1       |
| AEINHEIT1               |
| AEINHEIT2               |
| AUFTRAG1                |
| AUFTRAG2                |
| AUFTRAG3                |
| BAUGR_ERWBEDARF1        |
| BAUGRUPPE1              |
| BAUGRUPPE2              |
| EINHEIT1                |
| EINHEIT2                |
| EKTEIL_EINHEIT1         |
| EKTEIL1                 |
| ERWBEDARF1              |
| LOHNFERT1               |
| LOHNFERT2               |
| MINDESTB1               |
| PROJEKT1                |
| PROJEKT2                |

@testvorbereitung
Scenario: Bestaende anlegen

# Bestaende LOHNFERT mit Fertigteil VERSAND und BAUGRUPPE
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | LOHNFERT_3000   |
    | buart     | Zugang          |
    | beleg     | TEST_3000       |
    | beldat    | .               |
And I delete all rows
And I append rows
    | mge    | platz2   | lffert         | projekt     | behaelter                  |
    | 9      | F1       | VERKAUF_3000   |             |                            |
    | 7      | F1       | VERKAUF_3000   | T3ESTP_3000 | !LOHNFERT1^id              |
    | 5      | F1       | BAUGRUPPE_3000 | T2ESTP_3000 | !AEINH_LOHNF_PROJEKT1^id   |
    | 9      | F1       | VERKAUF_3000   | T2ESTP_3000 | !LOHNFERT2^id              |
    | 3      | F1       | BAUGRUPPE_3000 |             | !LOHNFERT1^id              |
And I save the current editor

# Bestaende EKTEIL
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EKTEIL_3000   |
    | buart     | Zugang        |
    | beleg     | TEST_3000     |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   | behaelter                 |
    | 10     | F1       | !AEINH_EKTEIL_ERWBED1^id  |
    | 20     | F1       | !EKTEIL1^id               |
    | 15     | F2       |                           |
And I save the current editor

# Bestaende BAUGRUPPE
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BAUGRUPPE_3000 |
    | buart     | Zugang         |
    | beleg     | TEST_3000      |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2   | projekt     | behaelter            |
    | 9      | F1       |             | !BAUGRUPPE1^id       |
    | 15     | F1       | TESTP_3000  | !BAUGRUPPE2^id       |
    | 10     | F2       | T2ESTP_3000 | !BAUGR_ERWBEDARF1^id |
And I save the current editor

# Bestaende ERWBEDARF
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | ERWBEDARF_3000 |
    | buart     | Zugang         |
    | beleg     | TEST_3000      |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2   | verw              | projekt     | behaelter                |
    | 12     | F1       | Sicherheit_3000   |             | !AEINH_EKTEIL_ERWBED1^id |
    | 12     | F1       | Sicherheit_3000   | T3ESTP_3000 | !ERWBEDARF1^id           |
    | 2      | F2       | Sicherheit_3000   | T3ESTP_3000 | !BAUGR_ERWBEDARF1^id     |
    | 10     | F1       | VW1_3000          | T2ESTP_3000 | !AEINH_EKTEIL_ERWBED1^id |
And I save the current editor

# Bestaende AUFTRAG
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | AUFTRAG_3000   |
    | buart     | Zugang         |
    | beleg     | TEST_3000      |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2   | verw         | projekt     | behaelter            |
    | 25     | F1       | 12345_3000   |             | !ACHARGE_AUFTRAG1^id |
    | 15     | F1       | 6789_25_3000 |             | !AUFTRAG1^id         |
    | 15     | F1       | 123_3000     |             | !AUFTRAG1^id         |
    | 15     | L2F1     | 12345_3000   | T2ESTP_3000 | !AUFTRAG2^id         |
    | 7      | L2F2     |              | T2ESTP_3000 | !AUFTRAG3^id         |
    | 3      | L3F1     | 12345_3000   |             |                      |
And I save the current editor

# Bestaende PROJEKT
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | PROJEKT_3000   |
    | buart     | Zugang         |
    | beleg     | TEST_3000      |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2   | projekt     | behaelter                   |
    | 9      | F1       | TESTP_3000  | !AEINH_LOHNF_PROJEKT1^id    |
    | 15     | F1       | TESTP_3000  | !PROJEKT2^id                |
    | 9      | F1       | TESTP_3000  | !ACHARGE_PROJEKT1^id        |
    | 9      | F1       | TESTP_3000  |                             |
    | 15     | F1       | T2ESTP_3000 |                             |
    | 12     | F1       | T3ESTP_3000 | !AEINHEIT_PROJEKT1^id       |
    | 9      | F2       | TESTP_3000  | !ACHARGE_CHARGE_PROJEKT1^id |
And I save the current editor

# Bestaende CHARGE
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | CHARGE_3000    |
    | buart     | Zugang         |
    | beleg     | TEST_3000      |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2   | behaelter                     |
    | 12     | F1       | CH1_3000  | !ACHARGE_CHARGE1^id           |
    | 5      | F1       | CH1_3000  | !AEINHEIT_CHARGE1^id          |
    | 25     | F2       | CH1_3000  | !ACHARGE_CHARGE_PROJEKT1^id   |
And I save the current editor

# Bestaende ACHARGE
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | ACHARGE_3000   |
    | buart     | Zugang         |
    | beleg     | TEST_3000      |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2   | verw         | charge2     | behaelter                    |
    | 2      | F1       | VW1_3000     | CHA1_3000   | !ACHARGE_PROJEKT1^id         |
    | 5      | F2       | VW2_3000     | CHA1_3000   | !ACHARGE_CHARGE_PROJEKT1^id  |
    | 5      | F1       | VW1_3000     | CHA2_3000   | !ACHARGE_CHARGE1^id          |
    | 5      | F1       | VW2_3000     | CHA2_3000   | !ACHARGE_AUFTRAG1^id         |
    | 5      | F1       | VW1_3000     | CHA2_3000   |                              |
And I save the current editor

# Bestaende MINDESTB
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | MINDESTB_3000 |
    | buart     | Zugang        |
    | beleg     | TEST_3000     |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   | behaelter              |
    | 70     | F1       | !AEINHEIT_MINDESTB1^id |
    | 20     | F1       | !MINDESTB1^id          |
And I save the current editor

@testvorbereitung
Scenario Outline: Vorbereitung Bestaende anlegen

Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel   | <artikel> |
    | buart     | Zugang    |
    | beleg     | TEST_3000 |
    | beldat    | .         |
And I modify table
    | !row      | platz2   | mge   | ze    | zele   | verw        | projekt     | behaelter   |
    | +1        | <platz2> | <mge> | <ze>  | <zele> | <verw>      | <projekt>   | <behaelter> |
And I save the current editor

Examples:
| artikel       | platz2   |  mge  | ze     | zele   | verw        | projekt     | behaelter                 |
| EINHEIT_3000  |  F1      |  10   | m      | 1      | !dontChange | !dontChange | !EINHEIT2^id              |
| EINHEIT_3000  |  F1      |  20   | m      | 1      | !dontChange | !dontChange | !EINHEIT1^id              |
| EINHEIT_3000  |  F1      |   5   | kg     | 1      | !dontChange | !dontChange | !EINHEIT1^id              |
| EINHEIT_3000  |  F1      |  17   | Stück | 2      | !dontChange | !dontChange | !EKTEIL_EINHEIT1^id       |
| AEINHEIT_3000 |  F1      |  4    | Stück | 2      | V2_3000     | !dontChange |                           |
| AEINHEIT_3000 |  F1      |  10   | m      | 1      | V1_3000     | !dontChange | !AEINHEIT2^id             |
| AEINHEIT_3000 |  F1      |  20   | m      | 1      | V1_3000     | !dontChange | !AEINHEIT_PROJEKT1^id     |
| AEINHEIT_3000 |  F1      |  15   | m      | 1      | V2_3000     | !dontChange | !AEINHEIT_CHARGE1^id      |
| AEINHEIT_3000 |  F1      |  15   | m      | 1      | !dontChange | TESTP_3000  | !AEINH_EKTEIL_ERWBED1^id  |
| AEINHEIT_3000 |  F1      |  15   | m      | 1      | !dontChange | T2ESTP_3000 | !AEINHEIT_PROJEKT1^id     |
| AEINHEIT_3000 |  F1      |  10   | m      | 1      | !dontChange | TESTP_3000  | !AEINH_LOHNF_PROJEKT1^id  |
| AEINHEIT_3000 |  F1      |  5    | m      | 1      | VW_3000     | TESTP_3000  | !AEINHEIT_MINDESTB1^id    |
| AEINHEIT_3000 |  F1      |  5    | kg     | 1      | V1_3000     | !dontChange | !AEINHEIT1^id             |

#############################################################################################################

Scenario: 01 Bestand erhoehen, CHARGE Charge, AUFTRAG Verw, PROJEKT Projekt

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | CHARGE_3000 |
    | beleg     | 01_CHA_3000 |
    | beldat    | .           |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "42"
Then the table has 2 rows
Then table has values
    | mge   | tcharge1    | behaelter^such   |
    | 12    | 887799_3000 | ACHARGE_CHARGE1  |
    |  5    | 887799_3000 | AEINHEIT_CHARGE1 |
And I set field "mge" to "10" in row 2
Then field "zele" is not modifiable in row 1
Then field "behaelter" is not modifiable in row 1
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | AUFTRAG_3000 |
    | beleg     | 01_AUF_3000  |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "80"
Then the table has 3 rows
Then table has values
    | mge   | verw         | behaelter^such   |
    | 25    | 12345_3000   | ACHARGE_AUFTRAG1 |
    | 15    | 123_3000     | AUFTRAG1         |
    | 15    | 6789_25_3000 | AUFTRAG1         |
And I set field "mge" to "20" in row 3
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | PROJEKT_3000 |
    | beleg     | 01_PRO_3000  |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "78"
Then the table has 6 rows
Then table has values
    | mge   | projekt      | behaelter^such       |
    |  9    | TESTP_3000   |                      |
    |  9    | TESTP_3000   | ACHARGE_PROJEKT1     |
    |  9    | TESTP_3000   | AEINH_LOHNF_PROJEKT1 |
    | 15    | TESTP_3000   | PROJEKT2             |
    | 15    | T2ESTP_3000  |                      |
    | 12    | T3ESTP_3000  | AEINHEIT_PROJEKT1    |
And I set field "mge" to "20" in row 4
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | CHARGE_3000 |
    | klgruppe   |             |
    | verdichten | ja          |
	| details    | nein        |
And I press button "bstart"
Then field "lemge" has value "22" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 3 rows
Then table has values
    | !row  | gebmge    | exnum       | lzu | tbehaelter^such |
    | 1     | 12        | 887799_3000 |     | ACHARGE_CHARGE1 |
And I set fields
    | artikel    | AUFTRAG_3000 |
    | klgruppe   |              |
    | verdichten | ja           |
And I press button "bstart"
Then field "lemge" has value "60" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 6 rows
Then table has values
    | !row  | gebmge    | verw        | lzu | tbehaelter^such  |
    | 1     |  25       | 12345_3000  |     | ACHARGE_AUFTRAG1 |
And I set fields
    | artikel    | PROJEKT_3000 |
    | klgruppe   |              |
    | verdichten | ja           |
And I press button "bstart"
Then field "lemge" has value "74" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 7 rows
Then table has values
    | !row  | gebmge    | projekt     | lzu | tbehaelter^such  |
    | 2     |  9        | TESTP_3000  |     | ACHARGE_PROJEKT1 |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .            |
    | beleg      | 01_CHA_3000  |
    | artikel    | CHARGE_3000  |    
And I press start
Then table has values
    | !row     | buart      | ursache | detursache                 | kmge | mei    | vplatz | nplatz | zmge  | amge  | verw         | projekt   | tncharge    | behaelter^such   |
    | 1        | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | Stück | F1     |        |       |       |              |           | 887799_3000 | ACHARGE_CHARGE1  |
And I set fields
    | beleg    | 01_AUF_3000  |
    | artikel  | AUFTRAG_3000 |    
And I press start
Then field "kmge" has value "" in row 1
Then table has values
    | !row     | buart      | ursache | detursache                 | kmge | mei    | vplatz | nplatz | zmge  | amge  | verw         | projekt   | tncharge   | behaelter^such   |
    | !lastRow | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | Stück | F1     |        |       |       | 6789_25_3000 |           |            | AUFTRAG1         |
And I set fields
    | beleg    | 01_PRO_3000  |
    | artikel  | PROJEKT_3000 |    
And I press start
Then table has values
    | !row     | buart      | ursache | detursache                 | kmge | mei    | vplatz | nplatz | zmge  | amge  | verw         | projekt    | tncharge  | behaelter^such   |
    | 1        | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | Stück | F1     |        |       |       |              | TESTP_3000 |           |                  |
And I close the current editor

Scenario Outline: 01 Behaelter pruefen CHARGE, AUFTRAG, PROJEKT
Given I switch the current editor to editor "<editor>"
Then table has values
    | !row   | artikel   | mge   | gebeinh   | verw   | projekt   | exnum   |
    | <row>  | <artikel> | <mge> | <gebeinh> | <verw> | <projekt> | <exnum> |
And I close the current editor

Examples: 01 Behaelter pruefen CHARGE, AUFTRAG, PROJEKT
| editor               | row | artikel       | mge | gebeinh | verw         | projekt     | exnum       |
| AEINHEIT_CHARGE1     | 1   | CHARGE_3000   | 10  | Stück  |              |             | 887799_3000 |
| AEINHEIT_CHARGE1     | 2   | AEINHEIT_3000 | 15  | m       | V2_3000      |             |             |
| ACHARGE_CHARGE1      | 1   | CHARGE_3000   | 12  | Stück  |              |             | 887799_3000 |
| ACHARGE_CHARGE1      | 2   | ACHARGE_3000  | 5   | Stück  | VW1_3000     |             | 67zu99_3000 |
| AUFTRAG1             | 1   | AUFTRAG_3000  | 15  | Stück  | 123_3000     |             |             |
| AUFTRAG1             | 2   | AUFTRAG_3000  | 20  | Stück  | 6789_25_3000 |             |             |
| ACHARGE_AUFTRAG1     | 1   | AUFTRAG_3000  | 25  | Stück  | 12345_3000   |             |             |
| ACHARGE_AUFTRAG1     | 2   | ACHARGE_3000  | 5   | Stück  | VW2_3000     |             | 67zu99_3000 |
| PROJEKT2             | 1   | PROJEKT_3000  | 20  | Stück  |              | TESTP_3000  |             |
| AEINH_LOHNF_PROJEKT1 | 1   | PROJEKT_3000  | 9   | Stück  |              | TESTP_3000  |             |
| AEINH_LOHNF_PROJEKT1 | 2   | AEINHEIT_3000 | 10  | m       |              | TESTP_3000  |             |
| AEINH_LOHNF_PROJEKT1 | 3   | LOHNFERT_3000 | 5   | Stück  |              | T2ESTP_3000 |             |
| ACHARGE_PROJEKT1     | 1   | PROJEKT_3000  | 9   | Stück  |              | TESTP_3000  |             |
| ACHARGE_PROJEKT1     | 2   | ACHARGE_3000  | 2   | Stück  | VW1_3000     |             | 89639_3000  |
| AEINHEIT_PROJEKT1    | 1   | PROJEKT_3000  | 12  | Stück  |              | T3ESTP_3000 |             |
| AEINHEIT_PROJEKT1    | 2   | AEINHEIT_3000 | 15  | m       |              | T2ESTP_3000 |             |
| AEINHEIT_PROJEKT1    | 3   | AEINHEIT_3000 | 20  | m       | V1_3000      |             |             |


Scenario: 02 Bestand verringern, CHARGE Charge, AUFTRAG Verw, PROJEKT Projekt

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | CHARGE_3000 |
    | beleg     | 02_CHA_3000 |
    | beldat    | .           |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "47"
Then the table has 2 rows
Then table has values
    | mge   | tcharge1    | behaelter^such   |
    | 12    | 887799_3000 | ACHARGE_CHARGE1  |
    | 10    | 887799_3000 | AEINHEIT_CHARGE1 |
And I set field "mge" to "5" in row 2
Then field "behaelter^such" has value "AEINHEIT_CHARGE1" in row 2
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | AUFTRAG_3000 |
    | beleg     | 02_AUF_3000  |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "85"
Then the table has 3 rows
Then table has values
    | mge   | verw         | behaelter^such   |
    | 25    | 12345_3000   | ACHARGE_AUFTRAG1 |
    | 15    | 123_3000     | AUFTRAG1         |
    | 20    | 6789_25_3000 | AUFTRAG1         |
And I set field "mge" to "15" in row 3
Then field "behaelter^such" has value "AUFTRAG1" in row 3
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | PROJEKT_3000 |
    | beleg     | 02_PRO_3000  |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "83"
Then the table has 6 rows
Then table has values
    | mge   | projekt      | behaelter^such       |
    |  9    | TESTP_3000   |                      |
    |  9    | TESTP_3000   | ACHARGE_PROJEKT1     |
    |  9    | TESTP_3000   | AEINH_LOHNF_PROJEKT1 |
    | 20    | TESTP_3000   | PROJEKT2             |
    | 15    | T2ESTP_3000  |                      |
    | 12    | T3ESTP_3000  | AEINHEIT_PROJEKT1    |
And I set field "mge" to "15" in row 4
Then field "behaelter^such" has value "PROJEKT2" in row 4
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | CHARGE_3000 |
    | klgruppe   |             |
    | verdichten | ja          |
	| details    | nein        |
And I press button "bstart"
Then field "lemge" has value "17" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 3 rows
Then table has values
    | !row  | gebmge    | exnum       | lzu | tbehaelter^such  |
    | 2     |  5        | 887799_3000 |     | AEINHEIT_CHARGE1 |
And I set fields
    | artikel    | AUFTRAG_3000 |
    | klgruppe   |              |
    | verdichten | ja           |
And I press button "bstart"
Then field "lemge" has value "55" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 6 rows
Then table has values
    | !row  | gebmge    | verw      | tbehaelter^such  |
    | 2     |  15       | 123_3000  | AUFTRAG1         |
And I set fields
    | artikel    | PROJEKT_3000 |
    | klgruppe   |              |
    | verdichten | ja           |
And I press button "bstart"
Then field "lemge" has value "69" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 7 rows
Then table has values
    | !row  | gebmge    | projekt     | tbehaelter^such  |
    | 4     |  15       | TESTP_3000  | PROJEKT2         |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .            |
    | beleg      | 02_CHA_3000  |
    | artikel    | CHARGE_3000  |
And I press start
Then table has values
    | !row     | buart      | ursache | detursache                 | kmge | mei     | vplatz | nplatz | zmge  | amge  | verw         | projekt   | tvcharge    | behaelter^such   |
    | 1        | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | Stück  | F1     |        |       |       |              |           | 887799_3000 | ACHARGE_CHARGE1  |
And I set fields
    | beleg    | 02_AUF_3000  |
    | artikel  | AUFTRAG_3000 |    
And I press start
Then field "kmge" has value "" in row 1
Then table has values
    | !row     | buart      | ursache | detursache                 | kmge | mei     | vplatz | nplatz | zmge  | amge  | verw         | projekt   | tncharge  | behaelter^such   |
    | !lastRow | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | Stück  | F1     |        |       |       | 6789_25_3000 |           |           | AUFTRAG1         |
And I set fields
    | beleg    | 02_PRO_3000  |
    | artikel  | PROJEKT_3000 |    
And I press start
Then table has values
    | !row     | buart      | ursache | detursache                 | kmge | mei     | vplatz | nplatz | zmge  | amge  | verw         | projekt    | tncharge  | behaelter^such   |
    | 1        | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | Stück  | F1     |        |       |       |              | TESTP_3000 |           |                  |
And I close the current editor
Scenario Outline: 02 Behaelter pruefen CHARGE, AUFTRAG, PROJEKT
Given I switch the current editor to editor "<editor>"
Then table has values
    | !row   | artikel   | mge   | gebeinh   | verw   | projekt   | exnum   |
    | <row>  | <artikel> | <mge> | <gebeinh> | <verw> | <projekt> | <exnum> |
And I close the current editor

Examples: 02 Behaelter pruefen CHARGE, AUFTRAG, PROJEKT
| editor               | row | artikel       | mge | gebeinh | verw         | projekt     | exnum       |
| AEINHEIT_CHARGE1     | 1   | CHARGE_3000   | 5   | Stück  |              |             | 887799_3000 |
| AEINHEIT_CHARGE1     | 2   | AEINHEIT_3000 | 15  | m       | V2_3000      |             |             |
| ACHARGE_CHARGE1      | 1   | CHARGE_3000   | 12  | Stück  |              |             | 887799_3000 |
| ACHARGE_CHARGE1      | 2   | ACHARGE_3000  | 5   | Stück  | VW1_3000     |             | 67zu99_3000 |
| AUFTRAG1             | 1   | AUFTRAG_3000  | 15  | Stück  | 123_3000     |             |             |
| AUFTRAG1             | 2   | AUFTRAG_3000  | 15  | Stück  | 6789_25_3000 |             |             |
| ACHARGE_AUFTRAG1     | 1   | AUFTRAG_3000  | 25  | Stück  | 12345_3000   |             |             |
| ACHARGE_AUFTRAG1     | 2   | ACHARGE_3000  | 5   | Stück  | VW2_3000     |             | 67zu99_3000 |
| PROJEKT2             | 1   | PROJEKT_3000  | 15  | Stück  |              | TESTP_3000  |             |
| AEINH_LOHNF_PROJEKT1 | 1   | PROJEKT_3000  | 9   | Stück  |              | TESTP_3000  |             |
| AEINH_LOHNF_PROJEKT1 | 2   | AEINHEIT_3000 | 10  | m       |              | TESTP_3000  |             |
| AEINH_LOHNF_PROJEKT1 | 3   | LOHNFERT_3000 | 5   | Stück  |              | T2ESTP_3000 |             |
| ACHARGE_PROJEKT1     | 1   | PROJEKT_3000  | 9   | Stück  |              | TESTP_3000  |             |
| ACHARGE_PROJEKT1     | 2   | ACHARGE_3000  | 2   | Stück  | VW1_3000     |             | 89639_3000  |
| AEINHEIT_PROJEKT1    | 1   | PROJEKT_3000  | 12  | Stück  |              | T3ESTP_3000 |             |
| AEINHEIT_PROJEKT1    | 2   | AEINHEIT_3000 | 15  | m       |              | T2ESTP_3000 |             |
| AEINHEIT_PROJEKT1    | 3   | AEINHEIT_3000 | 20  | m       | V1_3000      |             |             |


Scenario: 03 Kombination Bestand erhoehen, ERWBEDARF Charge und Projekt, ACHARGE Charge und Verw

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ERWBEDARF_3000 |
    | beleg     | 03_C_P_3000    |
    | beldat    | .              |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "36"
Then the table has 3 rows
Then table has values
    | mge   | verw            | projekt     | behaelter^such        |
    | 12    | Sicherheit_3000 |             | AEINH_EKTEIL_ERWBED1  |
    | 10    | VW1_3000        | T2ESTP_3000 | AEINH_EKTEIL_ERWBED1  |
    | 12    | Sicherheit_3000 | T3ESTP_3000 | ERWBEDARF1            |
And I set field "mge" to "15" in row 3
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ACHARGE_3000 |
    | beleg     | 03_C_V_3000  |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "22"
Then the table has 4 rows
Then table has values
    | mge   | verw      | tcharge1    | behaelter^such   |
    |  2    | VW1_3000  | 89639_3000  | ACHARGE_PROJEKT1 |
    |  5    | VW1_3000  | 67zu99_3000 |                  |
    |  5    | VW1_3000  | 67zu99_3000 | ACHARGE_CHARGE1  |
    |  5    | VW2_3000  | 67zu99_3000 | ACHARGE_AUFTRAG1 |
And I set field "mge" to "12" in row 4
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | ERWBEDARF_3000 |
    | klgruppe   |                |
    | verdichten | ja             |
	| details    | nein           |
And I press button "bstart"
Then field "lemge" has value "37" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 4 rows
Then table has values
    | !row  | gebmge    | verw            | projekt     | lzu | tbehaelter^such  |
    | 3     |  15       | Sicherheit_3000 | T3ESTP_3000 |     | ERWBEDARF1       |
And I set fields
    | artikel    | ACHARGE_3000 |
    | klgruppe   |              |
    | verdichten | ja           |
And I press button "bstart"
Then field "lemge" has value "24" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 5 rows
Then table has values
    | !row  | gebmge    | verw      | exnum         | lzu   | tbehaelter^such  |
    | 4     |  12       | VW2_3000  | 67zu99_3000   |       | ACHARGE_AUFTRAG1 |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum   | .              |
    | beleg    | 03_C_P_3000    |
    | artikel  | ERWBEDARF_3000 |    
And I press start
Then table has values
    | !row     | buart      | ursache | detursache                 | kmge | mei    | vplatz | nplatz | zmge | amge | verw            | projekt     | tncharge   | behaelter^such  |
    | !lastRow | Korrektur  | erfasst | Manuelle Bestandskorrektur | 3    | Stück | F1     |        |      |      | Sicherheit_3000 | T3ESTP_3000 |            | ERWBEDARF1      |
Then field "kmge" has value "" in row 1
Then field "kmge" has value "" in row 2
And I set fields
    | beleg    | 03_C_V_3000  |
    | artikel  | ACHARGE_3000 |    
And I press start
Then table has values
    | !row     | buart      | ursache | detursache                 | kmge | mei    | vplatz | nplatz | zmge | amge | verw            | projekt    | tncharge    | behaelter^such   |
    | !lastRow | Korrektur  | erfasst | Manuelle Bestandskorrektur | 7    | Stück | F1     |        |      |      | VW2_3000        |            | 67zu99_3000 | ACHARGE_AUFTRAG1 |
Then field "kmge" has value "" in row 1
Then field "kmge" has value "" in row 2
And I close the current editor

Scenario Outline: 03 Behaelter pruefen ERWBEDARF, ACHARGE
Given I switch the current editor to editor "<editor>"
Then table has values
    | !row   | artikel   | mge   | gebeinh   | verw   | projekt   | exnum   |
    | <row>  | <artikel> | <mge> | <gebeinh> | <verw> | <projekt> | <exnum> |
And I close the current editor

Examples: 03 Behaelter pruefen ERWBEDARF, ACHARGE
| editor               | row | artikel        | mge | gebeinh  | verw            | projekt     | exnum       | 
| AEINH_EKTEIL_ERWBED1 | 1   | EKTEIL_3000    | 10  | Stück   |                 |             |             |
| AEINH_EKTEIL_ERWBED1 | 2   | ERWBEDARF_3000 | 12  | Stück   | Sicherheit_3000 |             |             |
| AEINH_EKTEIL_ERWBED1 | 3   | ERWBEDARF_3000 | 10  | Stück   | VW1_3000        | T2ESTP_3000 |             |
| AEINH_EKTEIL_ERWBED1 | 4   | AEINHEIT_3000  | 15  | m        |                 | TESTP_3000  |             |
| ERWBEDARF1           | 1   | ERWBEDARF_3000 | 15  | Stück   | Sicherheit_3000 | T3ESTP_3000 |             |
| ACHARGE_CHARGE1      | 1   | CHARGE_3000    | 12  | Stück   |                 |             | 887799_3000 |
| ACHARGE_CHARGE1      | 2   | ACHARGE_3000   | 5   | Stück   | VW1_3000        |             | 67zu99_3000 |
| ACHARGE_AUFTRAG1     | 1   | AUFTRAG_3000   | 25  | Stück   | 12345_3000      |             |             |
| ACHARGE_AUFTRAG1     | 2   | ACHARGE_3000   | 12  | Stück   | VW2_3000        |             | 67zu99_3000 |
| ACHARGE_PROJEKT1     | 1   | PROJEKT_3000   | 9   | Stück   |                 | TESTP_3000  |             |
| ACHARGE_PROJEKT1     | 2   | ACHARGE_3000   | 2   | Stück   | VW1_3000        |             | 89639_3000  |


Scenario: 04 Kombination Bestand verringern ERWBEDARF Charge und Projekt, ACHARGE Charge und Verw

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ERWBEDARF_3000 |
    | beleg     | 04_C_P_3000    |
    | beldat    | .              |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "39"
Then the table has 3 rows
Then table has values
    | mge   | verw            | projekt     | behaelter^such        |
    | 12    | Sicherheit_3000 |             | AEINH_EKTEIL_ERWBED1  |
    | 10    | VW1_3000        | T2ESTP_3000 | AEINH_EKTEIL_ERWBED1  |
    | 15    | Sicherheit_3000 | T3ESTP_3000 | ERWBEDARF1            |
And I set field "mge" to "12" in row 3
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ACHARGE_3000 |
    | beleg     | 04_C_V_3000  |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "29"
Then the table has 4 rows
Then table has values
    | mge   | verw      | tcharge1    | behaelter^such   |
    |  2    | VW1_3000  | 89639_3000  | ACHARGE_PROJEKT1 |
    |  5    | VW1_3000  | 67zu99_3000 |                  |
    |  5    | VW1_3000  | 67zu99_3000 | ACHARGE_CHARGE1  |
    | 12    | VW2_3000  | 67zu99_3000 | ACHARGE_AUFTRAG1 |
And I set field "mge" to "5" in row 4
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | ERWBEDARF_3000 |
    | klgruppe   |                |
    | verdichten | ja             |
	| details    | nein           |
And I press button "bstart"
Then field "lemge" has value "34" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 4 rows
Then table has values
    | !row  | gebmge    | verw            | projekt     | lzu | tbehaelter^such  |
    | 3     |  12       | Sicherheit_3000 | T3ESTP_3000 |     | ERWBEDARF1       |
And I set fields
    | artikel    | ACHARGE_3000 |
    | klgruppe   |              |
    | verdichten | ja           |
And I press button "bstart"
Then field "lemge" has value "17" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 5 rows
Then table has values
    | !row  | gebmge    | verw      | exnum         | lzu   | tbehaelter^such  |
    | 4     |  5        | VW2_3000  | 67zu99_3000   |       | ACHARGE_AUFTRAG1 |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum   | .              |
    | beleg    | 04_C_P_3000    |
    | artikel  | ERWBEDARF_3000 |    
And I press start
Then table has values
    | !row     | buart      | ursache | detursache                 | kmge | mei     | vplatz | nplatz | zmge | amge | verw            | projekt     | tncharge   | behaelter^such  |
    | !lastRow | Korrektur  | erfasst | Manuelle Bestandskorrektur | -3   | Stück  | F1     |        |      |      | Sicherheit_3000 | T3ESTP_3000 |            | ERWBEDARF1      |
Then field "kmge" has value "" in row 1
Then field "kmge" has value "" in row 2
And I set fields
    | beleg    | 04_C_V_3000  |
    | artikel  | ACHARGE_3000 |    
And I press start
Then table has values
    | !row     | buart      | ursache | detursache                 | kmge | mei     | vplatz | nplatz | zmge | amge | verw            | projekt    | tncharge    | behaelter^such   |
    | !lastRow | Korrektur  | erfasst | Manuelle Bestandskorrektur | -7   | Stück  | F1     |        |      |      | VW2_3000        |            |             | ACHARGE_AUFTRAG1 |
Then field "kmge" has value "" in row 1
Then field "kmge" has value "" in row 2
And I close the current editor

Scenario Outline: 04 Behaelter pruefen ERWBEDARF, ACHARGE
Given I switch the current editor to editor "<editor>"
Then table has values
    | !row   | artikel   | mge   | gebeinh   | verw   | projekt   | exnum   |
    | <row>  | <artikel> | <mge> | <gebeinh> | <verw> | <projekt> | <exnum> |
And I close the current editor

Examples: 04 Behaelter pruefen ERWBEDARF, ACHARGE
| editor               | row | artikel        | mge | gebeinh  | verw            | projekt     | exnum       |
| AEINH_EKTEIL_ERWBED1 | 1   | EKTEIL_3000    | 10  | Stück   |                 |             |             |
| AEINH_EKTEIL_ERWBED1 | 2   | ERWBEDARF_3000 | 12  | Stück   | Sicherheit_3000 |             |             |
| AEINH_EKTEIL_ERWBED1 | 3   | ERWBEDARF_3000 | 10  | Stück   | VW1_3000        | T2ESTP_3000 |             |
| AEINH_EKTEIL_ERWBED1 | 4   | AEINHEIT_3000  | 15  | m        |                 | TESTP_3000  |             |
| ERWBEDARF1           | 1   | ERWBEDARF_3000 | 12  | Stück   | Sicherheit_3000 | T3ESTP_3000 |             |
| ACHARGE_CHARGE1      | 1   | CHARGE_3000    | 12  | Stück   |                 |             | 887799_3000 |
| ACHARGE_CHARGE1      | 2   | ACHARGE_3000   | 5   | Stück   | VW1_3000        |             | 67zu99_3000 |
| ACHARGE_AUFTRAG1     | 1   | AUFTRAG_3000   | 25  | Stück   | 12345_3000      |             |             |
| ACHARGE_AUFTRAG1     | 2   | ACHARGE_3000   | 5   | Stück   | VW2_3000        |             | 67zu99_3000 |
| ACHARGE_PROJEKT1     | 1   | PROJEKT_3000   | 9   | Stück   |                 | TESTP_3000  |             |
| ACHARGE_PROJEKT1     | 2   | ACHARGE_3000   | 2   | Stück   | VW1_3000        |             | 89639_3000  |


Scenario: 05 Gebinde Bestand erhoehen, EINHEIT und AEINHEIT; Pruefung Einheit waehlen schreibgeschuetzt

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EINHEIT_3000 |
    | beleg     | 05_E_3000    |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "69"
Then field "le" has value "m"
Then the table has 4 rows
Then table has values
    | mge   | ze     | behaelter^such    |
    | 20    | m      | EINHEIT1          |
    | 10    | m      | EINHEIT2          |
    |  5    | kg     | EINHEIT1          |
    | 17    | Stück | EKTEIL_EINHEIT1   |
# 203 Eintrag ist schreibgeschützt
Then pressing button "zeae" in row 1 throws the exception "203"
And I modify table
    | !row  | mge   |
    | 1     | 25    |
    | 2     | 15    |
    | 3     | 10    |
    | 4     | 20    |
Then pressing button "zeae" in row 1 throws the exception "203"
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | AEINHEIT_3000 |
    | beleg     | 05_AE_3000    |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "103"
Then field "le" has value "m"
Then the table has 9 rows
Then table has values
    | !row  | mge   | ze     | verw      | projekt     | behaelter^such       |
    | 1     | 20    | m      | V1_3000   |             | AEINHEIT_PROJEKT1    |
    | 2     | 10    | m      | V1_3000   |             | AEINHEIT2            |
    | 3     |  5    | kg     | V1_3000   |             | AEINHEIT1            |
    | 4     | 15    | m      | V2_3000   |             | AEINHEIT_CHARGE1     |
    | 5     |  4    | Stück | V2_3000   |             |                      |
    | 6     | 15    | m      |           | TESTP_3000  | AEINH_EKTEIL_ERWBED1 |
    | 7     | 10    | m      |           | TESTP_3000  | AEINH_LOHNF_PROJEKT1 |
    | 8     |  5    | m      | VW_3000   | TESTP_3000  | AEINHEIT_MINDESTB1   |
    | 9     | 15    | m      |           | T2ESTP_3000 | AEINHEIT_PROJEKT1    |
# 203 Eintrag ist schreibgeschützt
Then pressing button "zeae" in row 1 throws the exception "203"
And I modify table
    | !row  | mge   |
    | 3     | 10    |
    | 5     |  5    |
    | 8     | 10    |
    | 9     | 20    |
Then pressing button "zeae" in row 1 throws the exception "203"
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | EINHEIT_3000   |
    | klgruppe   |                |
    | verdichten | ja             |
	| details    | nein           |
And I press button "bstart"
Then field "lemge" has value "90" in row 1
Then field "leinheit" has value "m" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 4 rows
Then table has values
    | !row  | gebmge | geinheit  | gebf | tbehaelter^such   |
    | 1     | 25     | m         | 1    | EINHEIT1          |  
    | 2     | 15     | m         | 1    | EINHEIT2          |
    | 3     | 10     | kg        | 1    | EINHEIT1          | 
    | 4     | 20     | Stück    | 2    | EKTEIL_EINHEIT1   |
And I set fields
    | artikel    | AEINHEIT_3000 |
    | klgruppe   |               |
    | verdichten | ja            |
	| details    | nein          |
And I press button "bstart"
Then field "lemge" has value "120" in row 1
Then field "leinheit" has value "m" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 9 rows
Then table has values
    | !row  | gebmge | geinheit  | gebf | verw    | projekt     | lzu   | tbehaelter^such   |
    | 1     | 20     | m         | 1    | V1_3000 |             |       | AEINHEIT_PROJEKT1 |
    | 2     | 10     | m         | 1    | V1_3000 |             |       | AEINHEIT2         |
    | 3     | 10     | kg        | 1    | V1_3000 |             |       | AEINHEIT1         |
    | 5     |  5     | Stück    | 2    | V2_3000 |             |       |                   |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .              |
    | beleg      | 05_E_3000      |
    | artikel    | EINHEIT_3000   |
And I press start
Then table has values
    | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | leimei |  behaelter^such   |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | 10   | m      | F1        |           |       |       | 1      | EINHEIT1          |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | kg     | F1        |           |       |       | 1      | EINHEIT1          |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | 3    | Stück | F1        |           |       |       | 2      | EKTEIL_EINHEIT1   |
And I set fields
    | beleg      | 05_AE_3000     |
    | artikel    | AEINHEIT_3000  |    
And I press start
Then table has values
    | !row  | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw    | projekt     |  behaelter^such    |
    | 2     | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | kg     | F1        |           |       |       | V1_3000 |             | AEINHEIT1          |
    | 4     | Korrektur  | erfasst | Manuelle Bestandskorrektur | 1    | Stück | F1        |           |       |       | V2_3000 |             |                    |
    | 6     | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | m      | F1        |           |       |       | VW_3000 | TESTP_3000  | AEINHEIT_MINDESTB1 |
    | 7     | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | m      | F1        |           |       |       |         | T2ESTP_3000 | AEINHEIT_PROJEKT1  |
And I close the current editor

Scenario Outline: 05 Behaelter pruefen EINHEIT, AEINHEIT
Given I switch the current editor to editor "<editor>"
Then table has values
    | !row   | artikel   | mge   | gebeinh   | verw   | projekt   | exnum   |
    | <row>  | <artikel> | <mge> | <gebeinh> | <verw> | <projekt> | <exnum> |
And I close the current editor

Examples: 05 Behaelter pruefen EINHEIT, AEINHEIT
| editor               | row | artikel        | mge | gebeinh | verw            | projekt     | exnum       |
| EINHEIT1             | 1   | EINHEIT_3000   | 25  | m       |                 |             |             |
| EINHEIT1             | 2   | EINHEIT_3000   | 10  | kg      |                 |             |             |
| EINHEIT2             | 1   | EINHEIT_3000   | 15  | m       |                 |             |             |
| AEINHEIT1            | 1   | AEINHEIT_3000  | 10  | kg      | V1_3000         |             |             |
| AEINHEIT_MINDESTB1   | 1   | AEINHEIT_3000  | 10  | m       | VW_3000         | TESTP_3000  |             |
| AEINHEIT_MINDESTB1   | 2   | MINDESTB_3000  | 70  | Stück  |                 |             |             |
| AEINH_LOHNF_PROJEKT1 | 1   | PROJEKT_3000   | 9   | Stück  |                 | TESTP_3000  |             |
| AEINH_LOHNF_PROJEKT1 | 2   | AEINHEIT_3000  | 10  | m       |                 | TESTP_3000  |             |
| AEINH_LOHNF_PROJEKT1 | 3   | LOHNFERT_3000  | 5   | Stück  |                 | T2ESTP_3000 |             |
| AEINHEIT_PROJEKT1    | 1   | PROJEKT_3000   | 12  | Stück  |                 | T3ESTP_3000 |             |
| AEINHEIT_PROJEKT1    | 2   | AEINHEIT_3000  | 20  | m       |                 | T2ESTP_3000 |             |
| AEINHEIT_PROJEKT1    | 3   | AEINHEIT_3000  | 20  | m       | V1_3000         |             |             |
| AEINH_EKTEIL_ERWBED1 | 1   | EKTEIL_3000    | 10  | Stück  |                 |             |             |
| AEINH_EKTEIL_ERWBED1 | 2   | ERWBEDARF_3000 | 12  | Stück  | Sicherheit_3000 |             |             |
| AEINH_EKTEIL_ERWBED1 | 3   | ERWBEDARF_3000 | 10  | Stück  | VW1_3000        | T2ESTP_3000 |             |
| AEINH_EKTEIL_ERWBED1 | 4   | AEINHEIT_3000  | 15  | m       |                 | TESTP_3000  |             |
| AEINHEIT_CHARGE1     | 1   | CHARGE_3000    | 5   | Stück  |                 |             | 887799_3000 |
| AEINHEIT_CHARGE1     | 2   | AEINHEIT_3000  | 15  | m       | V2_3000         |             |             |
| AEINHEIT2            | 1   | AEINHEIT_3000  | 10  | m       | V1_3000         |             |             |


Scenario: 06 Gebinde Bestand verringern, EINHEIT und AEINHEIT

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EINHEIT_3000 |
    | beleg     | 06_E_3000    |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "90"
Then field "le" has value "m"
Then the table has 4 rows
Then table has values
    | mge   | ze     | behaelter^such    |
    | 25    | m      | EINHEIT1          |
    | 15    | m      | EINHEIT2          |
    | 10    | kg     | EINHEIT1          |
    | 20    | Stück | EKTEIL_EINHEIT1   |
# 203 Eintrag ist schreibgeschützt
Then field "ze" is not modifiable in row 1
Then pressing button "zeae" in row 1 throws the exception "203"
And I modify table
    | !row  | mge   |
    | 1     | 20    |
    | 2     | 10    |
    | 3     |  5    |
    | 4     | 17    |
Then pressing button "zeae" in row 1 throws the exception "203"
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | AEINHEIT_3000 |
    | beleg     | 06_AE_3000    |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "120"
Then field "le" has value "m"
Then the table has 9 rows
Then table has values
    | !row  | mge   | ze     | verw      | projekt     | behaelter^such       |
    | 1     | 20    | m      | V1_3000   |             | AEINHEIT_PROJEKT1    |
    | 2     | 10    | m      | V1_3000   |             | AEINHEIT2            |
    | 3     | 10    | kg     | V1_3000   |             | AEINHEIT1            |
    | 4     | 15    | m      | V2_3000   |             | AEINHEIT_CHARGE1     |
    | 5     |  5    | Stück | V2_3000   |             |                      |
    | 6     | 15    | m      |           | TESTP_3000  | AEINH_EKTEIL_ERWBED1 |
    | 7     | 10    | m      |           | TESTP_3000  | AEINH_LOHNF_PROJEKT1 |
    | 8     | 10    | m      | VW_3000   | TESTP_3000  | AEINHEIT_MINDESTB1   |
    | 9     | 20    | m      |           | T2ESTP_3000 | AEINHEIT_PROJEKT1    |
# 203 Eintrag ist schreibgeschützt
Then pressing button "zeae" in row 1 throws the exception "203"
And I modify table
    | !row  | mge   |
    | 3     |  5    |
    | 5     |  4    |
    | 8     |  5    |
    | 9     | 15    |
Then pressing button "zeae" in row 1 throws the exception "203"
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | EINHEIT_3000   |
    | klgruppe   |                |
    | verdichten | ja             |
	| details    | nein           |
And I press button "bstart"
Then field "lemge" has value "69" in row 1
Then field "leinheit" has value "m" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 4 rows
Then table has values
    | !row  | gebmge | geinheit  | gebf | tbehaelter^such   |
    | 1     | 20     | m         | 1    | EINHEIT1          |
    | 2     | 10     | m         | 1    | EINHEIT2          |
    | 3     |  5     | kg        | 1    | EINHEIT1          |
    | 4     | 17     | Stück    | 2    | EKTEIL_EINHEIT1   |
And I set fields
    | artikel    | AEINHEIT_3000 |
    | klgruppe   |               |
    | verdichten | ja            |
	| details    | nein          |
And I press button "bstart"
Then field "lemge" has value "103" in row 1
Then field "leinheit" has value "m" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 9 rows
Then table has values
    | !row  | gebmge | geinheit  | gebf | verw    | projekt     | tbehaelter^such      |
    | 3     |  5     | kg        | 1    | V1_3000 |             | AEINHEIT1            |
    | 5     |  4     | Stück    | 2    | V2_3000 |             |                      |
    | 7     | 10     | m         | 1    |         | TESTP_3000  | AEINH_LOHNF_PROJEKT1 |
    | 8     |  5     | m         | 1    | VW_3000 | TESTP_3000  | AEINHEIT_MINDESTB1   |
    | 9     | 15     | m         | 1    |         | T2ESTP_3000 | AEINHEIT_PROJEKT1    |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .              |
    | beleg      | 06_E_3000      |
    | artikel    | EINHEIT_3000   |
And I press start
Then table has values
    | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | leimei | behaelter^such    |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | -10  | m      | F1        |           |       |       | 1      | EINHEIT1          |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | kg     | F1        |           |       |       | 1      | EINHEIT1          |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | -3   | Stück | F1        |           |       |       | 2      | EKTEIL_EINHEIT1   |
And I set fields
    | beleg      | 06_AE_3000     |
    | artikel    | AEINHEIT_3000  |    
And I press start
Then table has values
    | !row  | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw    | projekt     | behaelter^such     |
    | 2     | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | kg     | F1        |           |       |       | V1_3000 |             | AEINHEIT1          |
    | 4     | Korrektur  | erfasst | Manuelle Bestandskorrektur | -1   | Stück | F1        |           |       |       | V2_3000 |             |                    |   
    | 6     | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | m      | F1        |           |       |       | VW_3000 | TESTP_3000  | AEINHEIT_MINDESTB1 |
    | 7     | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | m      | F1        |           |       |       |         | T2ESTP_3000 | AEINHEIT_PROJEKT1  |
And I close the current editor

Scenario Outline: 06 Behaelter pruefen EINHEIT, AEINHEIT
Given I switch the current editor to editor "<editor>"
Then table has values
    | !row   | artikel   | mge   | gebeinh   | verw   | projekt   | exnum   |
    | <row>  | <artikel> | <mge> | <gebeinh> | <verw> | <projekt> | <exnum> |
And I close the current editor

Examples: 06 Behaelter pruefen EINHEIT, AEINHEIT
| editor               | row | artikel        | mge | gebeinh | verw            | projekt     | exnum       |
| EINHEIT1             | 1   | EINHEIT_3000   | 20  | m       |                 |             |             |
| EINHEIT1             | 2   | EINHEIT_3000   | 5   | kg      |                 |             |             |
| EINHEIT2             | 1   | EINHEIT_3000   | 10  | m       |                 |             |             |
| AEINHEIT1            | 1   | AEINHEIT_3000  | 5   | kg      | V1_3000         |             |             |
| AEINHEIT_MINDESTB1   | 1   | AEINHEIT_3000  | 5   | m       | VW_3000         | TESTP_3000  |             |
| AEINHEIT_MINDESTB1   | 2   | MINDESTB_3000  | 70  | Stück  |                 |             |             |
| AEINH_LOHNF_PROJEKT1 | 1   | PROJEKT_3000   | 9   | Stück  |                 | TESTP_3000  |             |
| AEINH_LOHNF_PROJEKT1 | 2   | AEINHEIT_3000  | 10  | m       |                 | TESTP_3000  |             |
| AEINH_LOHNF_PROJEKT1 | 3   | LOHNFERT_3000  | 5   | Stück  |                 | T2ESTP_3000 |             |
| AEINHEIT_PROJEKT1    | 1   | PROJEKT_3000   | 12  | Stück  |                 | T3ESTP_3000 |             |
| AEINHEIT_PROJEKT1    | 2   | AEINHEIT_3000  | 15  | m       |                 | T2ESTP_3000 |             |
| AEINHEIT_PROJEKT1    | 3   | AEINHEIT_3000  | 20  | m       | V1_3000         |             |             |
| AEINH_EKTEIL_ERWBED1 | 1   | EKTEIL_3000    | 10  | Stück  |                 |             |             |
| AEINH_EKTEIL_ERWBED1 | 2   | ERWBEDARF_3000 | 12  | Stück  | Sicherheit_3000 |             |             |
| AEINH_EKTEIL_ERWBED1 | 3   | ERWBEDARF_3000 | 10  | Stück  | VW1_3000        | T2ESTP_3000 |             |
| AEINH_EKTEIL_ERWBED1 | 4   | AEINHEIT_3000  | 15  | m       |                 | TESTP_3000  |             |
| AEINHEIT_CHARGE1     | 1   | CHARGE_3000    | 5   | Stück  |                 |             | 887799_3000 |
| AEINHEIT_CHARGE1     | 2   | AEINHEIT_3000  | 15  | m       | V2_3000         |             |             |
| AEINHEIT2            | 1   | AEINHEIT_3000  | 10  | m       | V1_3000         |             |             |


Scenario: 07 Neue Zeile mit gleichen Details bringt Fehler

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | AUFTRAG_3000 |
    | beleg     | 08_3000      |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
And I append rows
    | platz     | mge         |
    | F1        | 1           |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
And I modify table
    | !row     | verw         | behaelter     |
    | 4        | 123_3000     | !AUFTRAG1^id  |
# 6633 de      |Einheit mit gleichem Faktor, gleichem Behälter, gleicher Charge, gleichem Projekt oder gleicher Verwendung gibt es schon.
Then saving the current editor throws the exception "6633"
And I close the current editor


Scenario: 08 Eingefuegte Zeilen werden gebucht

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ERWBEDARF_3000 |
    | beleg     | 09_Z_3000      |
    | beldat    | .              |
And I set field "platz" to "F1" in row 1
Then the table has 3 rows
And I append rows
    | platz     | mge         | behaelter      |
    | F1        | 1           | !ERWBEDARF1^id |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
And I append rows
    | platz     | mge         |
    | F1        | 1           |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
And I modify table
    | !row     | verw         | projekt    | behaelter  |
    | 5        | VW1_3000     | TESTP_3000 |            |
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | ERWBEDARF_3000 |
    | klgruppe   |                |
    | behaelter  | ja             |
	| details    | nein           |
And I press button "bstart"
Then the table has 6 rows
Then table has values
    | !row  | gebmge   | verw     | projekt    | tbehaelter^such  |
    | 1     |  1       |          |            | ERWBEDARF1       |
    | 3     |  1       | VW1_3000 | TESTP_3000 |                  |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum   | .              |
    | beleg    | 09_Z_3000      |
    | artikel  | ERWBEDARF_3000 |    
And I press start
Then table has values
    | !row     | buart      | ursache | detursache                 | kmge | mei     | vplatz | nplatz | zmge | amge | verw     | projekt    | tncharge   | behaelter^such  |
    | 1        | Korrektur  | erfasst | Manuelle Bestandskorrektur |  1   | Stück  | F1     |        |      |      |          |            |            | ERWBEDARF1      |
    | 3        | Korrektur  | erfasst | Manuelle Bestandskorrektur |  1   | Stück  | F1     |        |      |      | VW1_3000 | TESTP_3000 |            |                 |
And I close the current editor


Scenario: 09 Eingefuegte Zeilen mit Einheiten werden gebucht

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | AEINHEIT_3000  |
    | beleg     | 10_Z_3000      |
    | beldat    | .              |
And I set field "platz" to "F1" in row 1
Then the table has 9 rows
And I append rows
    | platz     | mge         |
    | F1        | 1           |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
And I modify table
    | !row     | verw         | behaelter    |
    | 10       | VW1_3000     | !AEINHEIT1^id|
And I append rows
    | platz     | mge         |
    | F1        | 1           |
And I respond with answer "2" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
And I modify table
    | !row     | projekt      | behaelter              |
    | 11       | T3ESTP_3000  | !AEINHEIT_MINDESTB1^id |
And I append rows
    | platz     | mge         |
    | F1        | 1           |
And I respond with answer "3" to the dialog with id "Einheit"
And I press button "zeae" in row !lastRow
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | AEINHEIT_3000 |
    | klgruppe   |               |
    | verdichten | ja            |
	| details    | nein          |
And I press button "bstart"
Then field "lemge" has value "107" in row 1
Then field "leinheit" has value "m" in row 1
And I set field "behaelter" to "JA"
And I press button "bstart"
Then the table has 12 rows
Then table has values
    | !row  | gebmge | geinheit  | gebf | verw     | projekt     | tbehaelter^such      |
    | 1     |  1     | kg        | 1    |          |             |                      |
    | 7     |  1     | m         | 1    | VW1_3000 |             | AEINHEIT1            |
    | 12    |  1     | Stück    | 2    |          | T3ESTP_3000 | AEINHEIT_MINDESTB1   |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .              |
    | beleg      | 10_Z_3000      |
    | artikel    | AEINHEIT_3000  |    
And I press start
Then table has values
    | !row  | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw     | projekt     | behaelter^such     |
    | 1     | Korrektur  | erfasst | Manuelle Bestandskorrektur | 1    | kg     | F1        |           |       |       |          |             |                    |
    | 6     | Korrektur  | erfasst | Manuelle Bestandskorrektur | 1    | m      | F1        |           |       |       | VW1_3000 |             | AEINHEIT1          |   
    | 10    | Korrektur  | erfasst | Manuelle Bestandskorrektur | 1    | Stück | F1        |           |       |       |          | T3ESTP_3000 | AEINHEIT_MINDESTB1 |
And I close the current editor


Scenario: 10 Behaelter angeben, der auf einem anderen Lagerplatz liegt, bringt Fehler

Given I create a Container "LEERERBEH" for packaging material "KLT"
Given I create a Container "GEFUELLTBEH" for packaging material "KLT"

Given I open an editor "Lagerbuchung13_1" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EKTEIL_3000  |
    | buart     | Zugang       |
    | beleg     | L13_3000     |
    | beldat    | .            |
And I delete all rows
And I append rows
    | mge   | platz2    | behaelter     |
    | 10    | F3        | GEFUELLTBEH   |
And I save the current editor

# Behaelter angeben, der auf einem anderen Lagerplatz liegt 
Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EKTEIL_3000  |
    | beleg     | 13_B_3000    |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then the table has 2 rows
And I append rows
    | platz    | mge    |
    | F1       | 5      |
# 11069 Gefüllter Behälter auf einem anderen Lagerplatz.
And setting field "behaelter" to "!GEFUELLTBEH^id" in row !lastRow throws the exception "11069"
And I close the current editor


Scenario: 11 Zugang in Behaelter, Abgang ohne Behaelter, Magic Line pruefen

Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "INVKUNDE"
And I set fields
    | such      | INVKUNDE       |
    | namebspr  | Kunde Inventur |
And I save the current editor 

Given I create a Container "BEHAELTER_VERKAUF1" for packaging material "KLT"
Given I create a Container "BEHAELTER_VERKAUF2" for packaging material "KLT"

Scenario Outline: 11 Lagerbuchungen VERKAUF in BEHAELTER
Given I open an editor "Lagerbuchung14_1" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | VERKAUF_3000 |
    | buart     | Zugang       |
    | beleg     | L14_3000     |
    | beldat    | .            |
And I delete all rows
And I append rows
    | mge   | platz2    | behaelter     |
    | <mge> | <platz2>  | <behaelter>   |
And I save the current editor

Examples: Lagerbuchungen
    | mge | platz2 | behaelter              |
    | 10  | F1     | !BEHAELTER_VERKAUF1^id |
    | 20  | F1     | !BEHAELTER_VERKAUF2^id |
    | 30  | F2     |                        |

Scenario Outline: 11 Verkaufslieferscheine Abgang F1 ohne Behaelter und F2 ohne Behaelter
Given I open an editor "<editor>" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | INVKUNDE  |
    | vom   | .         |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | platz    |
    | <artikel> | <mge> | <platz>  |
And I save the current editor

Examples: Lieferscheine Verkauf
| editor   | artikel      | mge | platz |
| VKLS14_1 | VERKAUF_3000 | 10  | F1    |
| VKLS14_2 | VERKAUF_3000 | 10  | F2    |

Scenario: 11 Magic Line VERKAUF pruefen
Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | VERKAUF_3000 |
    | beleg     | 14_B_3000    |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then the table has 3 rows
Then table has values
    | mge   | behaelter^such     |
    | -10   |                    |
    |  10   | BEHAELTER_VERKAUF1 |
    |  20   | BEHAELTER_VERKAUF2 |
Then field "behhinwicon" is not empty in row 1
Then field "behhinwicon" is empty in row 2
Then field "behhinwicon" is empty in row 3
And I close the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | VERKAUF_3000 |
    | beleg     | 14_B_3000    |
    | beldat    | .            |
And I set field "platz" to "F2" in row 1
Then the table has 1 rows
Then field "mge" has value "20" in row 1
And I close the current editor


Scenario: 12 Bestand auf 0 korrigieren, Behaelter ist dann leer

Given I create a Container "BEHAELTER_NULL_1" for packaging material "KLT"

# Lagerbuchung EKTEIL in BEHAELTER_NULL
Given I open an editor "Lagerbuchung15_1" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EKTEIL_3000  |
    | buart     | Zugang       |
    | beleg     | L13_3000     |
    | beldat    | .            |
And I delete all rows
And I append rows
    | mge   | platz2    | behaelter        |
    | 10    | L2F1      | BEHAELTER_NULL_1 |
And I save the current editor

# Bestand auf 0 korrigieren, Behaelter ist dann leer
Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EKTEIL_3000  |
    | beleg     | 15_B_3000    |
    | beldat    | .            |
And I set field "platz" to "L2F1" in row 1
And I set field "mge" to "0" in row 1
And I save the current editor

Then Container "BEHAELTER_NULL_1" is empty
