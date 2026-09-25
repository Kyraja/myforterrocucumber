@persistent
Feature: VERSAND_BEHAELTER_Verdichten_Behaelterlagermenge.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Verdichten_Behaelterlagermenge.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Verdichten der Lagermengen
#  Vorgaenger       : ref_behaelter_bestandskorrektur_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"

Scenario: Lager und Lagerplatz anlegen
# weiteres Lager und zugehoerigen Lagerplatz in der Lagergruppe KARLSRUHE anlegen
Given I open an editor "Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "L4"
And I set fields
    | such     | INTERN_L4     |
    | namebspr | Lager 4 KA    |
    | lgruppe  | KARLSRUHE     |
    | disporel | ja            |
    | lnullm   | ja            |
And I save the current editor

Given I open an editor "Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "INTERN_L4_1"
And I set fields
    | such     | INTERN_L4_1     |
    | namebspr | PLatz 1 Lager 4 |
    | lager    | !Lager^id       |
And I save the current editor


Scenario: Bestaende zubuchen

# LOHNFERT mit Fertigteil VERKAUF
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | LOHNFERT_1010   |
    | buart     | Zugang          |
    | beleg     | TEST2_1010      |
    | beldat    | .               |
And I delete all rows
And I append rows
    | mge    | platz2       | lffert         | projekt      |
    | 2      | F1           | VERKAUF_1010   |              |
    | 1      | F2           | VERKAUF_1010   |              |
    | 2      | F2           | VERKAUF_1010   |              |
    | 5      | L2F1         | VERKAUF_1010   |              |
    | 1      | L2F1         | VERKAUF_1010   | T2ESTP_1010  |
    | 2      | F2           | BAUGRUPPE_1010 | T2ESTP_1010  |
    | 3      | INTERN_L4_1  | VERKAUF_1010   |              |
    | 4      | INTERN_L4_1  | VERKAUF_1010   |              |
    | 5      | INTERN_L4_1  | BAUGRUPPE_1010 |              |
    | 7      | INTERN_L4_1  | BAUGRUPPE_1010 |              |
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
    | mge    | platz2       | verw         | projekt     |
    | 12     | INTERN_L4_1  | 12345_1010   |             |
    |  8     | INTERN_L4_1  | 12345_1010   | T2ESTP_1010 |
    |  7     | INTERN_L4_1  | 12345_1010   |             |
    |  5     | L2F1         | 12345_1010   |             |
    | 10     | L2F1         | 12345_1010   | T2ESTP_1010 |
    | 10     | F2           | 12345_1010   |             |
And I save the current editor

# Bestaende CHARGE
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | CHARGE_1010    |
    | buart     | Zugang         |
    | beleg     | TEST2_1010     |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2       | charge2   |
    | 10     | L2F1         | CH1_1010  |
    | 12     | INTERN_L4_1  | CH1_1010  |
    | 5      | INTERN_L4_1  | CH1_1010  |
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
    | mge    | platz2       | verw         | charge2     |
    | 2      | L2F1         | VW1_1010     | CHA1_1010   |
    | 3      | L2F1         | VW1_1010     | CHA1_1010   |
    | 5      | L2F2         | VW2_1010     | CHA1_1010   |
    | 4      | L2F2         | VW2_1010     | CHA1_1010   |
    | 4      | L2F1         | VW1_1010     | CHA2_1010   |
    | 3      | L2F1         | VW2_1010     | CHA2_1010   |
    | 5      | L2F2         | VW1_1010     | CHA2_1010   |
    | 1      | INTERN_L4_1  | VW1_1010     | CHA1_1010   |
    | 1      | INTERN_L4_1  | VW2_1010     | CHA1_1010   |
And I save the current editor


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
    | artikel       | platz2        |  mge | ze     | zele  | verw        | projekt     |
    | AEINHEIT_1010 |  F1           |  10  | Stück | 2     | V2_1010     | !dontChange |
    | AEINHEIT_1010 |  F2           |  20  | Stück | 2     | V2_1010     | !dontChange |
    | AEINHEIT_1010 |  F2           |  15  | m      | 1     | V1_1010     | !dontChange |
    | AEINHEIT_1010 |  F2           |  10  | m      | 1     | V1_1010     | !dontChange |
    | AEINHEIT_1010 |  L2F1         |  20  | m      | 1     | !dontChange | TESTP_1010  |
    | AEINHEIT_1010 |  L2F1         |   5  | m      | 1     | !dontChange | T2ESTP_1010 |
    | AEINHEIT_1010 |  L2F1         |  10  | m      | 1     | !dontChange | TESTP_1010  |
    | AEINHEIT_1010 |  L2F1         |   5  | kg     | 1     | VW_1010     | TESTP_1010  |
    | AEINHEIT_1010 |  F1           |   3  | kg     | 1     | V2_1010     | !dontChange |
    | AEINHEIT_1010 |  F2           |   4  | kg     | 1     | V1_1010     | !dontChange |
    | AEINHEIT_1010 | INTERN_L4_1   |  20  | Stück | 2     | V2_1010     | !dontChange |
    | AEINHEIT_1010 | INTERN_L4_1   |  10  | Stück | 2     | V2_1010     | !dontChange |
    | AEINHEIT_1010 | INTERN_L4_1   |   5  | m      | 1     | V1_1010     | !dontChange |
    | AEINHEIT_1010 | INTERN_L4_1   |  20  | m      | 1     | V1_1010     | !dontChange |


Scenario Outline: Behaelter anlegen

Given I create a Container "<such>" for packaging material "KLT"

Examples:
    | such                    |
    | ACHARGE_AUFTRAG1        |
    | AUFTRAG11               |
    | AUFTRAG12               |
    | AUFTRAG13               |


Scenario: Bestaende mit Behaelter

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | AUFTRAG_3000   |
    | buart     | Zugang         |
    | beleg     | TEST_3000      |
    | beldat    | .              |
And I delete all rows
And I append rows
    | mge    | platz2       | verw         | behaelter             |
    | 25     | F1           | 12345_3000   | !ACHARGE_AUFTRAG1^id  |
    | 15     | F1           | 6789_25_3000 | !AUFTRAG11^id         |
    | 15     | F1           | 12345_3000   | !AUFTRAG11^id         |
    | 15     | L2F1         | 12345_3000   | !AUFTRAG12^id         |
    | 7      | INTERN_L4_1  |              | !AUFTRAG13^id         |
    | 3      | L3F1         | 12345_3000   |                       |
And I save the current editor

##################################################################################

Scenario: Plausis

Given I open an editor "BehLagMge" for tip command "(ContainerQuantities)" and arguments ""
# Lagerplatz verdichten ist vorbelegt
Then field "platzverdichten" has value "ja"
Then field "artikel" is empty
# 2382 de      |Bitte Artikel eintragen
Then pressing button "ladetab" throws the exception "2382"
And I set field "artikel" to "CHARGE_1010"
# Tabelle wird nicht automatisch geladen, nur ueber Button ladetab
Then the table has 0 rows
And I press button "ladetab"
Then the table has 4 rows
And I set field "artverdichten" to "ja"
# wird eine andere Verdichtungsstufe angehakt, wird der bisher gesetzte Haken entfernt
Then field "platzverdichten" has value "nein"
# Tabelle wurde automatisch geleert, weil Selektion geaendert wurde
Then the table has 0 rows
And I set field "artverdichten" to "nein"
#2924 de      |Waehlen Sie eine Verdichtungsstufe aus.
Then pressing button "ladetab" throws the exception "2924"
And I set field "platzverdichten" to "ja"
And I set field "platz" to "F1"
Then field "lager" has value "L1"
Then field "lgruppe" has value "KARLSRUHE"
# wenn Lagergruppe verdichten ausgewaehlt wird, dann werden die Felder "platz" und "lager" geleert
And I set field "lgverdichten" to "ja"
Then field "platz" is empty
Then field "lager" is empty
Then field "platz" is not modifiable
Then field "lager" is not modifiable
And I set field "platzverdichten" to "ja"
And I set field "platz" to "F1"
# wenn Behaelter angegeben ist, kann nur auf Platzebene verdichtet werden
And I set field "behaelter" to "!AUFTRAG11^id"
Then field "artverdichten" is not modifiable
Then field "lgverdichten" is not modifiable
Then field "lagerverdichten" is not modifiable
And I press button "ladetab"
# es werden keine Zeilen geladen, da Artikel CHARGE_1010 nicht in diesem Behaelter liegt
Then the table has 0 rows
And I close the current editor


Scenario: 01 Artikel mit Charge, alle Verdichtungsstufen testen, auch getrennt nach Lagergruppe

Given I open an editor "BehLagMge" for tip command "(ContainerQuantities)" and arguments ""
And I set field "artikel" to "CHARGE_1010"
# Platzmengen verdichten ist vorbelegt
Then field "platzverdichten" has value "ja"
And I press button "ladetab"
Then the table has 4 rows
Then table has values
    | tplatz        | mge   | ztexnum        |
    | F1            | 17    | 887799_1010    |
    | F2            | 25    | 887799_1010    |
    | INTERN_L4_1   | 17    | 887799_1010    |
    | L2F1          | 10    | 887799_1010    |
# Artikelmengen verdichten
And I set field "artverdichten" to "ja"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | mge   | ztexnum        |
    | 69    | 887799_1010    |
# Lagergruppenmenge verdichten
And I set field "lgverdichten" to "ja"
And I press button "ladetab"
Then the table has 2 rows
Then table has values
    | tlgruppe    | mge   | ztexnum        |
    | KARLSRUHE   | 59    | 887799_1010    |
    | HONGKONG    | 10    | 887799_1010    |
# Lagermengen verdichten
And I set field "lagerverdichten" to "ja"
And I press button "ladetab"
Then the table has 3 rows
Then table has values
    | tlager    | mge   | ztexnum        |
    | L1        | 42    | 887799_1010    |
    | INTERN_L4 | 17    | 887799_1010    |
    | L2        | 10    | 887799_1010    |
And I set field "lgruppe" to "KARLSRUHE"
And I press button "ladetab"
Then the table has 2 rows
Then table has values
    | tlager    | mge   | ztexnum        |
    | L1        | 42    | 887799_1010    |
    | INTERN_L4 | 17    | 887799_1010    |
And I set field "lgruppe" to "HONGKONG"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | tlager    | mge   | ztexnum        |
    | L2        | 10    | 887799_1010    |
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then the table has 0 rows
And I close the current editor


Scenario: 02 auftragsbezogener Artikel mit Charge und unterschiedlicher Verwendung, Verdichtung mit Chargenangabe

Given I open an editor "BehLagMge" for tip command "(ContainerQuantities)" and arguments ""
And I set fields
    | artikel       | ACHARGE_1010  |
    | charge        | CHA1_1010     |
    | artverdichten | ja            |
And I press button "ladetab"
Then the table has 2 rows
# Mengen des Artikels und der Charge pro Verwendung
Then table has values
    | tplatz    | mge   | ztexnum       | verw      |
    |           |  8    | 89639_1010    | VW1_1010  |
    |           | 15    | 89639_1010    | VW2_1010  |
And I set field "lagerverdichten" to "ja"
And I press button "ladetab"
Then the table has 6 rows
Then table has values
    | tlager    | mge   | ztexnum       | verw     |
    | L1        | 2     | 89639_1010    | VW1_1010 |
    | L1        | 5     | 89639_1010    | VW2_1010 |
    | INTERN_L4 | 1     | 89639_1010    | VW1_1010 |
    | INTERN_L4 | 1     | 89639_1010    | VW2_1010 |
    | L2        | 5     | 89639_1010    | VW1_1010 |
    | L2        | 9     | 89639_1010    | VW2_1010 |
And I set field "kverw" to "VW1_1010"
And I press button "ladetab"
Then the table has 3 rows
Then table has values
    | tlager    | mge   | ztexnum       | verw     |
    | L1        | 2     | 89639_1010    | VW1_1010 |
    | INTERN_L4 | 1     | 89639_1010    | VW1_1010 |
    | L2        | 5     | 89639_1010    | VW1_1010 |
And I set field "kverw" to ""
And I set field "lgverdichten" to "ja"
And I press button "ladetab"
Then the table has 4 rows
Then table has values
    | tlgruppe  | tlager    | mge   | ztexnum       | verw     |
    | KARLSRUHE |           | 3     | 89639_1010    | VW1_1010 |
    | KARLSRUHE |           | 6     | 89639_1010    | VW2_1010 |
    | HONGKONG  |           | 5     | 89639_1010    | VW1_1010 |
    | HONGKONG  |           | 9     | 89639_1010    | VW2_1010 |
And I close the current editor


Scenario: 03 Mengen verdichten, auftragsbezogener Artikel mit Verwendung und tlw mit Projekt

Given I open an editor "BehLagMge" for tip command "(ContainerQuantities)" and arguments ""
And I set fields
    | artikel    | AUFTRAG_1010  |
    | kverw      | 12345_1010    |
And I press button "ladetab"
Then the table has 7 rows
# Platzmengen sind verdichtet, eine Zeile pro Lagerplatz und Projekt bzw. Projekt "leer"
Then table has values
    | tplatz        | mge   | verw          | tprojekt     |
    | F1            | 25    | 12345_1010    |              |
    | F2            | 10    | 12345_1010    |              |
    | INTERN_L4_1   | 19    | 12345_1010    |              |
    | INTERN_L4_1   |  8    | 12345_1010    | T2ESTP_1010  |
    | L2F1          |  5    | 12345_1010    |              |
    | L2F1          | 25    | 12345_1010    | T2ESTP_1010  |
    | L3F1          |  3    | 12345_1010    |              |
# Artikelmengen verdichten, eine Zeile pro Projekt
And I set field "artverdichten" to "ja"
And I press button "ladetab"
Then the table has 2 rows
Then table has values
    | mge   | verw          | tprojekt      |
    | 62    | 12345_1010    |               |
    | 33    | 12345_1010    | T2ESTP_1010   |
# Lagergruppenmenge verdichten
And I set field "lgverdichten" to "ja"
And I press button "ladetab"
Then the table has 5 rows
Then table has values
    | tlgruppe  | mge   | verw          | tprojekt    |
    | KARLSRUHE | 54    | 12345_1010    |             |
    | KARLSRUHE |  8    | 12345_1010    | T2ESTP_1010 |
    | HONGKONG  |  5    | 12345_1010    |             |
    | HONGKONG  | 25    | 12345_1010    | T2ESTP_1010 |
    | BERLIN    |  3    | 12345_1010    |             |
# Lagermenge verdichten
And I set field "lagerverdichten" to "ja"
And I press button "ladetab"
Then the table has 6 rows
Then table has values
    | tlager    | mge   | verw          | tprojekt    |
    | L1        | 35    | 12345_1010    |             |
    | INTERN_L4 | 19    | 12345_1010    |             |
    | INTERN_L4 |  8    | 12345_1010    | T2ESTP_1010 |
    | L2        |  5    | 12345_1010    |             |
    | L2        | 25    | 12345_1010    | T2ESTP_1010 |
    | L3        |  3    | 12345_1010    |             |
And I set field "platzverdichten" to "ja"
And I set field "kverw" to ""
And I set field "projekt" to "T2ESTP_1010"
And I press button "ladetab"
Then the table has 3 rows
Then table has values
    | tplatz        | mge   | verw          | tprojekt     |
    | INTERN_L4_1   |  8    | 12345_1010    | T2ESTP_1010  |
    | L2F1          | 25    | 12345_1010    | T2ESTP_1010  |
    | L2F2          |  7    |               | T2ESTP_1010  |
And I close the current editor


Scenario: 04 Bestaende mit Fertigteil Lohnfertiung und Projekt, Verdichtung nach lffert

Given I open an editor "BehLagMge" for tip command "(ContainerQuantities)" and arguments ""
And I set fields
    | artikel       | LOHNFERT_1010 |
    | klffert       | VERKAUF_1010  |
    | artverdichten | ja            |
And I press button "ladetab"
Then the table has 3 rows
# Mengen des Artikels pro Fertigteil und Projekt, auch Projekt "leer"
Then table has values
    | tplatz    | mge   | lffert        | tprojekt    |
    |           | 26    | VERKAUF_1010  |             |
    |           | 10    | VERKAUF_1010  | T2ESTP_1010 |
    |           |  7    | VERKAUF_1010  | T3ESTP_1010 |
And I set fields
    | klffert   |               |
    | projekt   | T2ESTP_1010   |
And I press button "ladetab"
Then the table has 2 rows
# Mengen des Artikels pro Fertigteil
Then table has values
    | tplatz    | mge   | lffert            | tprojekt    |
    |           |  7    | BAUGRUPPE_1010    | T2ESTP_1010 |
    |           | 10    | VERKAUF_1010      | T2ESTP_1010 |
And I set field "projekt" to ""
And I press button "ladetab"
Then the table has 5 rows
# Mengen des Artikels pro Fertigteil und Projekt, auch Projekt "leer"
Then table has values
    | tplatz    | mge   | lffert            | tprojekt    |
    |           | 15    | BAUGRUPPE_1010    |             |
    |           | 26    | VERKAUF_1010      |             |
    |           |  7    | BAUGRUPPE_1010    | T2ESTP_1010 |
    |           | 10    | VERKAUF_1010      | T2ESTP_1010 |
    |           |  7    | VERKAUF_1010      | T3ESTP_1010 |
And I set field "lgverdichten" to "ja"
And I press button "ladetab"
Then the table has 7 rows
Then table has values
    | tlgruppe  | tplatz    | mge   | lffert            | tprojekt    |
    | KARLSRUHE |           | 15    | BAUGRUPPE_1010    |             |
    | KARLSRUHE |           | 21    | VERKAUF_1010      |             |
    | KARLSRUHE |           |  7    | BAUGRUPPE_1010    | T2ESTP_1010 |
    | KARLSRUHE |           |  9    | VERKAUF_1010      | T2ESTP_1010 |
    | KARLSRUHE |           |  7    | VERKAUF_1010      | T3ESTP_1010 |
    | HONGKONG  |           |  5    | VERKAUF_1010      |             |
    | HONGKONG  |           |  1    | VERKAUF_1010      | T2ESTP_1010 |
And I set field "lagerverdichten" to "ja"
And I press button "ladetab"
Then the table has 9 rows
Then table has values
    | tlager    | tplatz    | mge   | lffert            | tprojekt    |
    | L1        |           |  3    | BAUGRUPPE_1010    |             |
    | L1        |           | 14    | VERKAUF_1010      |             |
    | L1        |           |  7    | BAUGRUPPE_1010    | T2ESTP_1010 |
    | L1        |           |  9    | VERKAUF_1010      | T2ESTP_1010 |
    | L1        |           |  7    | VERKAUF_1010      | T3ESTP_1010 |
    | INTERN_L4 |           | 12    | BAUGRUPPE_1010    |             |
    | INTERN_L4 |           |  7    | VERKAUF_1010      |             |
    | L2        |           |  5    | VERKAUF_1010      |             |
    | L2        |           |  1    | VERKAUF_1010      | T2ESTP_1010 |
And I close the current editor


Scenario: 05 Artikel mit unterschiedlichen Einheiten, alle Verdichtungsstufen testen

# Artikel verdichten, es gibt eine Zeile pro Kombination aus Einheit, Verwendung und Projekt
Given I open an editor "BehLagMge" for tip command "(ContainerQuantities)" and arguments ""
And I set fields
    | artikel        | AEINHEIT_1010    |
And I press button "ladetab"
Then the table has 16 rows
And I set field "artverdichten" to "ja"
And I press button "ladetab"
Then the table has 9 rows
Then table has values
    | tlager    | tplatz    | mge   | gebf  | gebeinh   | verw      | tprojekt    |
    |           |           | 80    | 1     | m         | V1_1010   |             |
    |           |           |  9    | 1     | kg        | V1_1010   |             |
    |           |           | 15    | 1     | m         | V2_1010   |             |
    |           |           |  3    | 1     | kg        | V2_1010   |             |
    |           |           | 64    | 2     | Stück    | V2_1010   |             |
    |           |           | 55    | 1     | m         |           | TESTP_1010  |
    |           |           |  5    | 1     | m         | VW_1010   | TESTP_1010  |
    |           |           |  5    | 1     | kg        | VW_1010   | TESTP_1010  |
    |           |           | 20    | 1     | m         |           | T2ESTP_1010 |
And I set field "lagerverdichten" to "ja"
And I press button "ladetab"
Then the table has 13 rows
Then table has values
    | tlager    | mge   | gebf  | gebeinh   | verw      | tprojekt    |
    | L1        | 55    | 1     | m         | V1_1010   |             |
    | L1        |  9    | 1     | kg        | V1_1010   |             |
    | L1        | 15    | 1     | m         | V2_1010   |             |
    | L1        |  3    | 1     | kg        | V2_1010   |             |
    | L1        | 34    | 2     | Stück    | V2_1010   |             |
    | L1        | 25    | 1     | m         |           | TESTP_1010  |
    | L1        |  5    | 1     | m         | VW_1010   | TESTP_1010  |
    | L1        | 15    | 1     | m         |           | T2ESTP_1010 |
    | INTERN_L4 | 25    | 1     | m         | V1_1010   |             |
    | INTERN_L4 | 30    | 2     | Stück    | V2_1010   |             |
    | L2        | 30    | 1     | m         |           | TESTP_1010  |
    | L2        |  5    | 1     | kg        | VW_1010   | TESTP_1010  |
    | L2        |  5    | 1     | m         |           | T2ESTP_1010 |
And I set field "lgverdichten" to "ja"
And I press button "ladetab"
Then the table has 11 rows
Then table has values
    | tlgruppe  | tlager    | mge   | gebf  | gebeinh   | verw      | tprojekt    |
    | KARLSRUHE |           | 80    | 1     | m         | V1_1010   |             |
    | KARLSRUHE |           |  9    | 1     | kg        | V1_1010   |             |
    | KARLSRUHE |           | 15    | 1     | m         | V2_1010   |             |
    | KARLSRUHE |           |  3    | 1     | kg        | V2_1010   |             |
    | KARLSRUHE |           | 64    | 2     | Stück    | V2_1010   |             |
    | KARLSRUHE |           | 25    | 1     | m         |           | TESTP_1010  |
    | KARLSRUHE |           |  5    | 1     | m         | VW_1010   | TESTP_1010  |
    | KARLSRUHE |           | 15    | 1     | m         |           | T2ESTP_1010 |
    | HONGKONG  |           | 30    | 1     | m         |           | TESTP_1010  |
    | HONGKONG  |           |  5    | 1     | kg        | VW_1010   | TESTP_1010  |
    | HONGKONG  |           |  5    | 1     | m         |           | T2ESTP_1010 |
And I close the current editor


Scenario: 06 Bestand in Behaelter, Verdichtung nur auf Platzebene moeglich

Given I open an editor "BehLagMge" for tip command "(ContainerQuantities)" and arguments ""
And I set fields
    | artikel        | AUFTRAG_3000    |
    | artverdichten  | ja              |
And I set field "behaelter" to "AUFTRAG11"
Then field "artverdichten" has value "nein"
Then field "platzverdichten" has value "ja"
Then field "artverdichten" is not modifiable
Then field "lgverdichten" is not modifiable
Then field "lagerverdichten" is not modifiable
And I press button "ladetab"
Then the table has 2 rows
Then table has values
    | tplatz    | mge   | exbehnum     | verw          |
    | F1        | 15    | AUFTRAG11    | 12345_3000    |
    | F1        | 15    | AUFTRAG11    | 6789_25_3000  |
And I close the current editor
