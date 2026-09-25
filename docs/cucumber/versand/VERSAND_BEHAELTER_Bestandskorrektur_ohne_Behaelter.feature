@persistent
Feature: VERSAND_BEHAELTER_Bestandskorrektur_ohne_Behaelter.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Bestandskorrektur_ohne_Behaelter.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Bestandskorrektur ohne Behaeltern
#  ref              : ref_behaelter_bestandskorrektur_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"

@testvorbereitung
Scenario: Bestaende zubuchen

# LOHNFERT mit Fertigteil VERKAUF und BAUGRUPPE
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | LOHNFERT_1010   |
    | buart     | Zugang          |
    | beleg     | TEST_1010       |
    | beldat    | .               |
And I delete all rows
And I append rows
    | mge    | platz2   | lffert         | projekt     |
    | 9      | F1       | VERKAUF_1010   |             |
    | 7      | F1       | VERKAUF_1010   | T3ESTP_1010 |
    | 5      | F1       | BAUGRUPPE_1010 | T2ESTP_1010 |
    | 9      | F1       | VERKAUF_1010   | T2ESTP_1010 |
    | 3      | F1       | BAUGRUPPE_1010 |             |
And I save the current editor

# Bestaende EKTEIL
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EKTEIL_1010   |
    | buart     | Zugang        |
    | beleg     | TEST_1010     |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 10     | F1       |
    | 20     | F1       |
    | 15     | F2       |
And I save the current editor

# Bestaende BAUGRUPPE
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BAUGRUPPE_1010 |
    | buart     | Zugang         |
    | beleg     | TEST_1010      |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2   | projekt     |
    | 9      | F1       |             |
    | 15     | F1       | TESTP_1010  |
    | 10     | F2       | T2ESTP_1010 |
And I save the current editor

# Bestaende ERWBEDARF
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | ERWBEDARF_1010 |
    | buart     | Zugang         |
    | beleg     | TEST_1010      |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2   | verw              | projekt     |
    | 12     | F1       | Sicherheit_1010   |             |
    | 12     | F1       | Sicherheit_1010   | T3ESTP_1010 |
    | 2      | F2       | Sicherheit_1010   | T3ESTP_1010 |
    | 10     | F1       | VW1_1010          | T2ESTP_1010 |
And I save the current editor

# Bestaende AUFTRAG
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | AUFTRAG_1010   |
    | buart     | Zugang         |
    | beleg     | TEST_1010      |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2   | verw         | projekt     |
    | 25     | F1       | 12345_1010   |             |
    | 15     | F1       | 6789_25_1010 |             |
    | 15     | F1       | 123_1010     |             |
    | 15     | L2F1     | 12345_1010   | T2ESTP_1010 |
    | 7      | L2F2     |              | T2ESTP_1010 |
    | 3      | L3F1     | 12345_1010   |             |
And I save the current editor

# Bestaende PROJEKT
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | PROJEKT_1010   |
    | buart     | Zugang         |
    | beleg     | TEST_1010      |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2   | projekt     |
    | 9      | F1       | TESTP_1010  |
    | 15     | F1       | TESTP_1010  |
    | 9      | F1       | TESTP_1010  |
    | 9      | F1       | TESTP_1010  |
    | 15     | F1       | T2ESTP_1010 |
    | 12     | F1       | T3ESTP_1010 |
    | 9      | F2       | TESTP_1010  |
And I save the current editor

# Bestaende CHARGE
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | CHARGE_1010    |
    | buart     | Zugang         |
    | beleg     | TEST_1010      |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2   |
    | 12     | F1       | CH1_1010  |
    | 5      | F1       | CH1_1010  |
    | 25     | F2       | CH1_1010  |
And I save the current editor

# Bestaende ACHARGE
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | ACHARGE_1010   |
    | buart     | Zugang         |
    | beleg     | TEST_1010      |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2   | verw         | charge2     |
    | 2      | F1       | VW1_1010     | CHA1_1010   |
    | 5      | F2       | VW2_1010     | CHA1_1010   |
    | 5      | F1       | VW1_1010     | CHA2_1010   |
    | 5      | F1       | VW2_1010     | CHA2_1010   |
    | 5      | F1       | VW1_1010     | CHA2_1010   |
And I save the current editor

# Bestaende MINDESTB_1010
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | MINDESTB_1010 |
    | buart     | Zugang        |
    | beleg     | TEST_1010     |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 70     | F1       |
    | 20     | F1       |
And I save the current editor

@testvorbereitung
Scenario Outline: Vorbereitung Bestaende anlegen

Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel   | <artikel> |
    | buart     | Zugang    |
    | beleg     | TEST_1010 |
    | beldat    | .         |
And I modify table
    | mge   | platz2    | ze     | zele    | verw    | projekt   | !row  |
    | <mge> | <platz2>  | <ze>   | <zele>  | <verw>  | <projekt> | +1    |
And I save the current editor

Examples:
| artikel       | platz2 |  mge | ze     | zele  | verw        | projekt     |
| EINHEIT_1010  |  F1    |  10  | m      | 1     | !dontChange | !dontChange |
| EINHEIT_1010  |  F1    |  20  | m      | 1     | !dontChange | !dontChange | 
| EINHEIT_1010  |  F1    |   5  | kg     | 1     | !dontChange | !dontChange | 
| EINHEIT_1010  |  F1    |  17  | Stück | 2     | !dontChange | !dontChange | 
| AEINHEIT_1010 |  F1    |  4   | Stück | 2     | V2_1010     | !dontChange | 
| AEINHEIT_1010 |  F1    |  10  | m      | 1     | V1_1010     | !dontChange | 
| AEINHEIT_1010 |  F1    |  20  | m      | 1     | V1_1010     | !dontChange | 
| AEINHEIT_1010 |  F1    |  15  | m      | 1     | V2_1010     | !dontChange | 
| AEINHEIT_1010 |  F1    |  15  | m      | 1     | !dontChange | TESTP_1010  |
| AEINHEIT_1010 |  F1    |  15  | m      | 1     | !dontChange | T2ESTP_1010 |
| AEINHEIT_1010 |  F1    |  10  | m      | 1     | !dontChange | TESTP_1010  |
| AEINHEIT_1010 |  F1    |  5   | m      | 1     | VW_1010     | TESTP_1010  |
| AEINHEIT_1010 |  F1    |  5   | kg     | 1     | V1_1010     | !dontChange |


##################################################################################

Scenario: 01 Bestand erhoehen, CHARGE Charge, AUFTRAG Verw, PROJEKT Projekt

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | CHARGE_1010 |
    | beleg     | 01_CHA_1010 |
    | beldat    | .           |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "42"
Then the table has 1 rows
Then table has values
    | mge   | tcharge1    | 
    | 17    | 887799_1010 |
And I set field "mge" to "20" in row 1
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | AUFTRAG_1010 |
    | beleg     | 01_AUF_1010  |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "80"
Then the table has 3 rows
Then table has values
    | mge   | verw         | 
    | 25    | 12345_1010   |
    | 15    | 123_1010     |
    | 15    | 6789_25_1010 |
And I set field "mge" to "30" in row 1
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | PROJEKT_1010 |
    | beleg     | 01_PRO_1010  |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "78"
Then the table has 3 rows
Then table has values
    | mge   | projekt      | 
    | 42    | TESTP_1010   |
    | 15    | T2ESTP_1010  |
    | 12    | T3ESTP_1010  |
And I set field "mge" to "20" in row 2
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | CHARGE_1010 |
    | klgruppe   |             |
    | verdichten | nein        |
	| details    | nein        |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 5 rows
Then table has values
    | !row  | lemge | gebmge    | exnum       |
    | 1     | 20    |           |             |
    | 4     |       | 3         | 887799_1010 |
And I set fields
    | artikel    | AUFTRAG_1010 |
    | klgruppe   |              |
    | verdichten | nein         |
	| details    | nein         |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 8 rows
Then table has values
    | !row  | lemge | gebmge    | verw        |
    | 1     | 60    |           |             |
    | 5     |       | 5         | 12345_1010  |
And I set fields
    | artikel    | PROJEKT_1010 |
    | klgruppe   |              |
    | verdichten | nein         |
	| details    | nein         |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 9 rows
Then table has values
    | !row  | lemge | gebmge    | projekt     |
    | 1     | 74    |           |             |
    | 8     |       | 5         | T2ESTP_1010 |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .            |
    | beleg      | 01_CHA_1010  |
    | artikel    | CHARGE_1010  |    
And I press start
Then the table has 1 rows
Then table has values
    | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw       | projekt     | tncharge    |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | 3    | Stück | F1        |           |       |       |            |             | 887799_1010 |
And I set fields
    | beleg      | 01_AUF_1010  |
    | artikel    | AUFTRAG_1010 |    
And I press start
Then table has values
    | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw       | projekt     | tncharge    |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | Stück | F1        |           |       |       | 12345_1010 |             |             |
And I set fields
    | beleg      | 01_PRO_1010  |
    | artikel    | PROJEKT_1010 |    
And I press start
Then table has values
    | !row | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw | projekt     | tncharge   |
    | 2    | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | Stück | F1        |           |       |       |      | T2ESTP_1010 |            |
And I close the current editor


Scenario: 02 Bestand verringern, CHARGE Charge, AUFTRAG Verw, PROJEKT Projekt

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | CHARGE_1010 |
    | beleg     | 02_CHA_1010 |
    | beldat    | .           |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "45"
Then the table has 1 rows
Then table has values
    | mge   | tcharge1    |
    | 20    | 887799_1010 |
And I set field "mge" to "17" in row 1
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | AUFTRAG_1010 |
    | beleg     | 02_AUF_1010  |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "85"
Then the table has 3 rows
Then table has values
    | mge   | verw         |
    | 30    | 12345_1010   |
    | 15    | 123_1010     |
    | 15    | 6789_25_1010 |
And I set field "mge" to "25" in row 1
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | PROJEKT_1010 |
    | beleg     | 02_PRO_1010  |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "83"
Then the table has 3 rows
Then table has values
    | mge   | projekt      |
    | 42    | TESTP_1010   |
    | 20    | T2ESTP_1010  |
    | 12    | T3ESTP_1010  |
And I set field "mge" to "15" in row 2
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | CHARGE_1010 |
    | klgruppe   |             |
    | verdichten | nein        |
	| details    | nein        |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 5 rows
Then table has values
    | !row  | lemge | gebmge    | exnum       |
    | 1     | 17    |           |             |
    | 3     |       | 5         | 887799_1010 |
And I set fields
    | artikel    | AUFTRAG_1010 |
    | klgruppe   |              |
    | verdichten | ja           |
	| details    | nein         |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 7 rows
Then table has values
    | !row  | lemge | gebmge    | verw        |
    | 1     | 55    |           |             |
    | 2     |       | 25        | 12345_1010  |
And I set fields
    | artikel    | PROJEKT_1010 |
    | klgruppe   |              |
    | verdichten | ja           |
	| details    | nein         |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 5 rows
Then table has values
    | !row  | lemge | gebmge    | projekt     |
    | 1     | 69    |           |             |
    | 3     |       | 15        | T2ESTP_1010 |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .            |
    | beleg      | 02_CHA_1010  |
    | artikel    | CHARGE_1010  |    
And I press start
Then table has values
    | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw  | projekt   | tvcharge    |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | -3   | Stück | F1        |           |       |       |       |           | 887799_1010 |
And I set fields
    | beleg      | 02_AUF_1010  |
    | artikel    | AUFTRAG_1010 |    
And I press start
Then table has values
    | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw       | projekt   | tncharge  |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | Stück | F1        |           |       |       | 12345_1010 |           |           |
And I set fields
    | beleg      | 02_PRO_1010  |
    | artikel    | PROJEKT_1010 |    
And I press start
Then table has values
    | !row | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw | projekt     | tncharge  |
    | 2    | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | Stück | F1        |           |       |       |      | T2ESTP_1010 |           |
And I close the current editor


Scenario: 03 Kombination Bestand erhoehen, ERWBEDARF Charge und Projekt, ACHARGE Charge und Verw

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ERWBEDARF_1010 |
    | beleg     | 03_C_P_1010    |
    | beldat    | .              |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "36"
Then the table has 3 rows
Then table has values
    | mge   | verw            | projekt     |
    | 12    | Sicherheit_1010 |             |
    | 10    | VW1_1010        | T2ESTP_1010 |
    | 12    | Sicherheit_1010 | T3ESTP_1010 |
And I set field "mge" to "15" in row 1
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ACHARGE_1010 |
    | beleg     | 03_C_V_1010  |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "22"
Then the table has 3 rows
Then table has values
    | mge   | verw      | tcharge1    |
    |  2    | VW1_1010  | 89639_1010  |
    | 10    | VW1_1010  | 67zu99_1010 |
    |  5    | VW2_1010  | 67zu99_1010 |
And I set field "mge" to "12" in row 2
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | ERWBEDARF_1010 |
    | klgruppe   |                |
    | verdichten | nein           |
	| details    | nein           |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 6 rows
Then table has values
    | !row  | lemge | gebmge    | verw            | projekt |
    | 1     | 37    |           |                 |         |
    | 5     |       | 3         | Sicherheit_1010 |         |
And I set fields
    | artikel    | ACHARGE_1010 |
    | klgruppe   |              |
    | verdichten | nein         |
	| details    | nein         |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 7 rows
Then table has values
    | !row  | lemge | gebmge    | verw     | exnum        |
    | 1     | 19    |           |          |              |
    | 6     |       | 2         | VW1_1010 | 67zu99_1010  |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .              |
    | beleg      | 03_C_P_1010    |
    | artikel    | ERWBEDARF_1010 |    
And I press start
Then table has values
    | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw              | projekt   | tncharge   |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | 3    | Stück | F1        |           |       |       | Sicherheit_1010   |           |            |
And I set fields
    | beleg      | 03_C_V_1010  |
    | artikel    | ACHARGE_1010 |    
And I press start
Then table has values
    | !row | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw     | projekt  | tncharge    |
    | 2    | Korrektur  | erfasst | Manuelle Bestandskorrektur | 2    | Stück | F1        |           |       |       | VW1_1010 |          | 67zu99_1010 |
And I close the current editor


Scenario: 04 Kombination Bestand verringern ERWBEDARF Charge und Projekt, ACHARGE Charge und Verw

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ERWBEDARF_1010 |
    | beleg     | 04_C_P_1010    |
    | beldat    | .              |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "39"
Then the table has 3 rows
Then table has values
    | mge   | verw            | projekt     |
    | 15    | Sicherheit_1010 |             |
    | 10    | VW1_1010        | T2ESTP_1010 |
    | 12    | Sicherheit_1010 | T3ESTP_1010 |
And I set field "mge" to "12" in row 1
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ACHARGE_1010 |
    | beleg     | 04_C_V_1010  |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "24"
Then the table has 3 rows
Then table has values
    | mge   | verw      | tcharge1    |
    |  2    | VW1_1010  | 89639_1010  |
    | 12    | VW1_1010  | 67zu99_1010 |
    |  5    | VW2_1010  | 67zu99_1010 |
And I set field "mge" to "10" in row 2
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | ERWBEDARF_1010 |
    | klgruppe   |                |
    | verdichten | ja             |
	| details    | nein           |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 5 rows
Then table has values
    | !row  | lemge | gebmge    | verw            | projekt |
    | 1     | 34    |           |                 |         |
    | 2     |       | 12        | Sicherheit_1010 |         |
And I set fields
    | artikel    | ACHARGE_1010 |
    | klgruppe   |              |
    | verdichten | nein         |
	| details    | nein         |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 7 rows
Then table has values
    | !row  | lemge | gebmge    | verw     | exnum        |
    | 1     | 17    |           |          |              |
    | 5     |       | 5         | VW1_1010 | 67zu99_1010  |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .              |
    | beleg      | 04_C_P_1010    |
    | artikel    | ERWBEDARF_1010 |    
And I press start
Then table has values
    | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw              | projekt   | tncharge   |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | -3   | Stück | F1        |           |       |       | Sicherheit_1010   |           |            |
And I set fields
    | beleg      | 04_C_V_1010  |
    | artikel    | ACHARGE_1010 |    
And I press start
Then table has values
    | !row | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw     | projekt  | tvcharge    |
    | 2    | Korrektur  | erfasst | Manuelle Bestandskorrektur | -2   | Stück | F1        |           |       |       | VW1_1010 |          | 67zu99_1010 |
And I close the current editor


Scenario: 05 Gebinde Bestand erhoehen, EINHEIT und AEINHEIT

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EINHEIT_1010 |
    | beleg     | 05_E_1010    |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "69"
Then field "le" has value "m"
Then the table has 3 rows
Then table has values
    | mge   | ze     |
    | 30    | m      |
    |  5    | kg     |
    | 17    | Stück |
# 203 Eintrag ist schreibgeschuetzt
Then pressing button "zeae" in row 2 throws the exception "203"
And I modify table
    | !row  | mge   |
    | 1     | 35    |
    | 2     | 10    |
    | 3     | 25    |
Then pressing button "zeae" in row 2 throws the exception "203"
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | AEINHEIT_1010 |
    | beleg     | 05_AE_1010    |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "103"
Then field "le" has value "m"
Then the table has 7 rows
Then table has values
    | !row  | mge   | ze     | verw      | projekt     |
    | 1     | 30    | m      | V1_1010   |             |
    | 2     |  5    | kg     | V1_1010   |             |
    | 3     | 15    | m      | V2_1010   |             |
    | 4     |  4    | Stück | V2_1010   |             |
    | 5     | 25    | m      |           | TESTP_1010  |
    | 6     |  5    | m      | VW_1010   | TESTP_1010  |
    | 7     | 15    | m      |           | T2ESTP_1010 |
# 203 Eintrag ist schreibgeschuetzt
Then pressing button "zeae" in row 1 throws the exception "203"
And I modify table
    | !row  | mge   |
    | 2     | 10    |
    | 3     | 20    |
    | 4     | 30    |
    | 6     | 10    |
Then pressing button "zeae" in row 1 throws the exception "203"
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | EINHEIT_1010 |
    | klgruppe   |              |
    | verdichten | nein         |
	| details    | nein         |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 8 rows
Then table has values
    | !row  | lemge | leinheit  | gebmge | geinheit  | gebf |
    | 1     | 95    |  m        |        |           |      |
    | 6     |       |           | 5      | m         | 1    |
    | 7     |       |           | 5      | kg        | 1    |
    | 8     |       |           | 8      | Stück    | 2    |
And I set fields
    | artikel    | AEINHEIT_1010 |
    | klgruppe   |               |
    | verdichten | nein          |
	| details    | nein          |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 14 rows
Then table has values
    | !row  | lemge | leinheit  | gebmge | geinheit  | gebf | verw    | projekt     |
    | 1     | 170   |  m        |        |           |      |         |             |
    | 11    |       |           | 5      | kg        | 1    | V1_1010 |             |
    | 12    |       |           | 5      | m         | 1    | V2_1010 |             |
    | 13    |       |           | 26     | Stück    | 2    | V2_1010 |             |
    | 14    |       |           | 5      | m         | 1    | VW_1010 | TESTP_1010  |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .              |
    | beleg      | 05_E_1010      |
    | artikel    | EINHEIT_1010   |
And I press start
Then the table has 3 rows
Then table has values
    | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | leimei |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | m      | F1        |           |       |       | 1      |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | kg     | F1        |           |       |       | 1      |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | 8    | Stück | F1        |           |       |       | 2      |
And I set fields
    | beleg      | 05_AE_1010     |
    | artikel    | AEINHEIT_1010  |
And I press start
Then table has values
    | !row  | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw    | projekt    |
    | 2     | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | kg     | F1        |           |       |       | V1_1010 |            |
    | 3     | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | m      | F1        |           |       |       | V2_1010 |            |
    | 4     | Korrektur  | erfasst | Manuelle Bestandskorrektur | 26   | Stück | F1        |           |       |       | V2_1010 |            |
    | 6     | Korrektur  | erfasst | Manuelle Bestandskorrektur | 5    | m      | F1        |           |       |       | VW_1010 | TESTP_1010 |
And I close the current editor


Scenario: 06 Gebinde Bestand verringern, EINHEIT und AEINHEIT

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EINHEIT_1010 |
    | beleg     | 06_E_1010    |
    | beldat    | .            |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "95"
Then field "le" has value "m"
Then the table has 3 rows
Then table has values
    | mge   | ze     |
    | 35    | m      |
    | 10    | kg     |
    | 25    | Stück |
Then field "ze" is not modifiable in row 1
# 203 Eintrag ist schreibgeschuetzt
Then pressing button "zeae" in row 1 throws the exception "203"
And I modify table
    | !row  | mge   |
    | 1     | 30    |
    | 2     |  5    |
    | 3     | 17    |
Then pressing button "zeae" in row 1 throws the exception "203"
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | AEINHEIT_1010 |
    | beleg     | 06_AE_1010    |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then field "bestand" has value "170"
Then field "le" has value "m"
Then the table has 7 rows
Then table has values
    | !row  | mge   | ze     | verw      | projekt     |
    | 1     | 30    | m      | V1_1010   |             |
    | 2     | 10    | kg     | V1_1010   |             |
    | 3     | 20    | m      | V2_1010   |             |
    | 4     | 30    | Stück | V2_1010   |             |
    | 5     | 25    | m      |           | TESTP_1010  |
    | 6     | 10    | m      | VW_1010   | TESTP_1010  |
    | 7     | 15    | m      |           | T2ESTP_1010 |
# 203 Eintrag ist schreibgeschuetzt
Then pressing button "zeae" in row 1 throws the exception "203"
And I modify table
    | !row  | mge   |
    | 2     |  5    |
    | 3     | 15    |
    | 4     |  4    |
    | 6     |  5    |
Then pressing button "zeae" in row 1 throws the exception "203"
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | EINHEIT_1010 |
    | klgruppe   |              |
    | verdichten | ja           |
	| details    | nein         |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 4 rows
Then table has values
    | !row  | lemge | leinheit  | gebmge | geinheit  | gebf |
    | 1     | 69    |  m        |        |           |      |
    | 2     |       |           | 30     | m         | 1    |
    | 3     |       |           | 5      | kg        | 1    |
    | 4     |       |           | 17     | Stück    | 2    |
And I set fields
    | artikel    | AEINHEIT_1010 |
    | klgruppe   |               |
    | verdichten | nein          |
	| details    | nein          |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 11 rows
Then table has values
    | !row  | lemge | leinheit  | gebmge | geinheit  | verw    | projekt     |
    | 1     | 103   |  m        |        |           |         |             |
    | 5     |       |           | 15     | m         |         | TESTP_1010  |
    | 7     |       |           | 10     | m         |         | TESTP_1010  |
    | 8     |       |           | 5      | kg        | V1_1010 |             |
    | 10    |       |           | 4      | Stück    | V2_1010 |             |
    | 11    |       |           | 5      | m         | VW_1010 | TESTP_1010  |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .              |
    | beleg      | 06_E_1010      |
    | artikel    | EINHEIT_1010   |    
And I press start
Then the table has 3 rows
Then table has values
    | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | leimei |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | m      | F1        |           |       |       | 1      |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | kg     | F1        |           |       |       | 1      |
    | Korrektur  | erfasst | Manuelle Bestandskorrektur | -8   | Stück | F1        |           |       |       | 2      |
And I set fields
    | beleg      | 06_AE_1010     |
    | artikel    | AEINHEIT_1010  |
And I press start
Then table has values
    | !row  | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw    | projekt    |
    | 2     | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | kg     | F1        |           |       |       | V1_1010 |            |
    | 3     | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | m      | F1        |           |       |       | V2_1010 |            |
    | 4     | Korrektur  | erfasst | Manuelle Bestandskorrektur | -26  | Stück | F1        |           |       |       | V2_1010 |            |
    | 6     | Korrektur  | erfasst | Manuelle Bestandskorrektur | -5   | m      | F1        |           |       |       | VW_1010 | TESTP_1010 |
And I close the current editor


Scenario: 07 Fehler keinen weiteren Lagerplatz in Maske laden moeglich

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EKTEIL_1010   |
    | beleg     | 07_1010       |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then the table has 1 rows
And I create a new row at the end of the table
# 1663 Bestandskorrektur jeweils nur fuer einen Lagerplatz erlaubt
# QSW-498
#Then setting field "platz" to "F2" in row !lastRow throws the exception "1663"
And I close the current editor


Scenario: 08 Neue Zeilen mit gleichen Details bringt Fehler ERWBEDRARF

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ERWBEDARF_1010  |
    | beleg     | 08_1010         |
    | beldat    | .               |
And I set field "platz" to "F1" in row 1
Then the table has 3 rows
And I append rows
    | platz  | mge   | ze       | verw            |
    | F1     |  1    | Stück    | Sicherheit_1010 |
# 6633 Einheit mit gleichem Faktor, gleichem Behaelter, gleicher Charge, gleichem Projekt oder gleicher Verwendung gibt es schon.
Then saving the current editor throws the exception "6633"
And I modify table
    | !row  |  verw     | projekt     |
    |  4    |  VW1_1010 | T2ESTP_1010 |
# 6633 Einheit mit gleichem Faktor, gleichem Behaelter, gleicher Charge, gleichem Projekt oder gleicher Verwendung gibt es schon.
Then saving the current editor throws the exception "6633"
And I close the current editor


Scenario: 09 Neue Zeilen einfuegen werden gebucht ERWBEDARF

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ERWBEDARF_1010  |
    | beleg     | 09_Z_1010       |
    | beldat    | .               |
And I set field "platz" to "F1" in row 1
Then the table has 3 rows
And I append rows
    | platz  | mge   |
    | F1     |  1    |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "zeae" in row 4
And I append rows
    | platz  | mge   |
    | F1     |  1    |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "zeae" in row 5
And I modify table
    | !row  |  verw     | projekt     |
    |  5    |  VW1_1010 | TESTP_1010  |
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | ERWBEDARF_1010 |
    | klgruppe   |                |
    | verdichten | nein           |
	| details    | nein           |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 8 rows
Then table has values
    | !row  | lemge | gebmge |  verw    | projekt     |
    | 1     |  36   |        |          |             |
    | 6     |       |  1     |          |             |
    | 7     |       |  1     | VW1_1010 | TESTP_1010  |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .               |
    | beleg      | 09_Z_1010       |
    | artikel    | ERWBEDARF_1010  |
And I press start
Then table has values
    | !row  | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw     | projekt    |
    | 1     | Korrektur  | erfasst | Manuelle Bestandskorrektur |  1   | Stück | F1        |           |       |       |          |            |
    | 3     | Korrektur  | erfasst | Manuelle Bestandskorrektur |  1   | Stück | F1        |           |       |       | VW1_1010 | TESTP_1010 |
And I close the current editor

# Bestaende auf Anfangsbestand korrigieren
Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | ERWBEDARF_1010  |
    | beleg     | 09_K_1010       |
    | beldat    | .               |
And I set field "platz" to "F1" in row 1
Then the table has 5 rows
And I set field "mge" to "0" in row 1
And I set field "mge" to "0" in row 3
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | ERWBEDARF_1010 |
    | klgruppe   |                |
    | verdichten | ja             |
	| details    | nein           |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 5 rows
And I close the current editor


Scenario: 10 Neue Zeilen einfuegen mit Einheiten werden gebucht AEINHEIT

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | AEINHEIT_1010  |
    | beleg     | 10_Z_1010      |
    | beldat    | .              |
And I set field "platz" to "F1" in row 1
Then the table has 7 rows
And I append rows
    | platz  | mge   |
    | F1     |  1    |
And I respond with answer "1" to the dialog with id "Einheit"
And I press button "zeae" in row 8
And I set field "verw" to "VW1_1010" in row 8
And I append rows
    | platz  | mge   |
    | F1     |  1    |
And I respond with answer "2" to the dialog with id "Einheit"
And I press button "zeae" in row 9
And I set field "projekt" to "T3ESTP_1010" in row 9
And I append rows
    | platz  | mge   |
    | F1     |  1    |
And I respond with answer "3" to the dialog with id "Einheit"
And I press button "zeae" in row 10
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | AEINHEIT_1010  |
    | klgruppe   |                |
    | verdichten | nein           |
	| details    | nein           |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 14 rows
Then table has values
    | !row  | lemge | leinheit  | gebmge | geinheit  | verw     | projekt     |
    | 1     | 107   |  m        |        |           |          |             |
    | 12    |       |           | 1      | kg        |          |             |
    | 13    |       |           | 1      | m         | VW1_1010 |             |
    | 14    |       |           | 1      | Stück    |          | T3ESTP_1010 |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum     | .               |
    | beleg      | 10_Z_1010       |
    | artikel    | AEINHEIT_1010   |
And I press start
Then table has values
    | !row  | buart      | ursache | detursache                 | kmge | mei    | vplatz    | nplatz    | zmge  | amge  | verw     | projekt     |
    | 1     | Korrektur  | erfasst | Manuelle Bestandskorrektur |  1   | kg     | F1        |           |       |       |          |             |
    | 6     | Korrektur  | erfasst | Manuelle Bestandskorrektur |  1   | m      | F1        |           |       |       | VW1_1010 |             |
    | 10    | Korrektur  | erfasst | Manuelle Bestandskorrektur |  1   | Stück | F1        |           |       |       |          | T3ESTP_1010 |
And I close the current editor

# Bestaende auf Anfangsbestand korrigieren AEINHEIT
Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | AEINHEIT_1010  |
    | beleg     | 10_K_1010      |
    | beldat    | .              |
And I set field "platz" to "F1" in row 1
Then the table has 10 rows
And I modify table
    | !row  | mge |
    |  1    | 0   |
    |  6    | 0   |
    |  10   | 0   |
And I save the current editor

Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | AEINHEIT_1010  |
    | klgruppe   |                |
    | verdichten | ja             |
	| details    | nein           |
And I press button "bstart"
And I press button "taufzu" in row 1
Then the table has 8 rows
And I close the current editor


Scenario: 11 Fehler bei Zeilen loeschen

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | MINDESTB_1010  |
    | beleg     | 11_L_1010      |
    | beldat    | .              |
And I set field "platz" to "F1" in row 1
#      439  de      |Zeile darf nicht geloescht werden.
# oder 3885 de      |Zeile kann nicht geloescht werden
# Test laeuft nur mit 3885; in der GUI kommt 439
And deleting the row at position 1 throws the exception "3885"
And I close the current editor
