# *****************************************************************************
#  Name             : Inventur_Vereinfachtes_Zaehlen.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Vereinfachtes Zaehlen bei Inventur
#
# *****************************************************************************
@persistent
Feature: Inventur_Vereinfachtes_Zaehlen.feature

Background:
Given I set the fake date to "02.01.95"


### Stammdaten anlegen ###

Scenario Outline: Kaufteile vzaehlen ERWBEDARF, AUFTRAG, PROJEKT (bedarfsbezogen, auftragsbezogen, projektbezogen)
Given I open an editor "<artikel>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such         | <such>           |
    | namebspr     | <namebspr>       |
    | bsart        | Fremdbeschaffung |
    | dispoa       | <dispoa>         |
    | chverfolgung | <chverfolgung>   |
    | chimlager    | <chimlager>      |
    | vzaehlen     | ja               |
    | lief         | 1                |
    | efrist       | 2                |
    | epr          | 3                |
And I save the current editor

Examples: Kaufteile
    | artikel          | such             | namebspr                 | dispoa                   | chverfolgung      | chimlager   |
    | VZAEHL_ERWBEDARF | VZAEHL_ERWBEDARF | Erweitert Bedarfsbezogen | erweitert bedarfsbezogen | !dontChange       | !dontChange |
    | VZAEHL_AUFTRAG   | VZAEHL_AUFTRAG   | Auftrag                  | auftragsbezogen          | !dontChange       | !dontChange |
    | VZAEHL_PROJEKT   | VZAEHL_PROJEKT   | Projekt                  | projektbezogen           | !dontChange       | !dontChange |
    | IN_BEHAELTER     | IN_BEHAELTER     | Artikel in Behaelter     | auftragsbezogen          | !dontChange       | !dontChange |
    | VZAEHL_ACHARGE   | VZAEHL_ACHARGE   | Charge Auftrag vzaehlen  | auftragsbezogen          | Chargenverfolgung | ja          |


Scenario: Kaufteile anlegen
# Kaufteil mit Gebindeeinheiten EINHEIT
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "VZAEHL_EINHEIT"
And I set fields
    | such     | VZAEHL_EINHEIT   |
    | namebspr | Einheit vzaehlen |
    | bsart    | Fremdbeschaffung |
    | vzaehlen | ja               |
    | lief     | 1                |
    | efrist   | 2                |
    | epr      | 3                |
    | le       | m                |
    | vhe      | Stück           |
    | fvhle    | 2                |
    | gebvhe   | JA               |
    | vpe      | Stück           |
    | fvple    | 2                |
    | gebvpe   | JA               |
    | ehe      | kg               |
    | fehle    | 1                |
    | gebehe   | JA               |
    | epe      | kg               |
    | feple    | 1                |
    | gebepe   | JA               |
    | ve       | Stück           |
    | fvele    | 2                |
    | gebve    | JA               |
    | ge       | m                |
And I save the current editor

# Chargen anlegen
And I create a Lot "VZ_CHARGE1" for Product "VZAEHL_ACHARGE"
And I create a Lot "VZ_CHARGE2" for Product "VZAEHL_ACHARGE"
And I create a Lot "VZ_CHARGE3" for Product "VZAEHL_ACHARGE"

Scenario Outline: Projekte
Given I open an editor "projekt" from table "(Transaction):(Project)" with command "STORE" for record "<projekt>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I save the current editor

Examples: Projekte
    | projekt 	  | such    	| namebspr           |
    | TEST_1017   | TESTP_1017  | Testprojekt_1017   |
    | T2ESTP_1017 | T2ESTP_1017 | Testprojekt 2_1017 |
    | T3ESTP_1017 | T3ESTP_1017 | Testprojekt 3_1017 |
    | B1_1017 	  | B1_1017 	| Testprojekt 1_1017 |
    | C1_1017 	  | C1_1017 	| Testprojekt 2_1017 |
    | A1_1017 	  | A1_1017 	| Testprojekt 3_1017 |

Scenario: Bestaende zubuchen

# Bestaende VZAEHL_ERWBEDARF
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST            |
    | vom      | .               |
    | ueb      | ja              |
    | fakt     | ja              |
    | ebeleg   | RE1_TEST_VZAEHL |
    | budat    | .               |
    | erfwaehr | DEM             |
And I append rows
    | artikel          | mge | platz   | verw            | projekt     | verfdat | preis  |
    | VZAEHL_ERWBEDARF |  12 | LP_INV4 | Sicherheit_1017 | !dontChange |  -5     |  20,00 |
    | VZAEHL_ERWBEDARF |  12 | LP_INV4 | Sicherheit_1017 | T3ESTP_1017 |  -3     |  19,00 |
    | VZAEHL_ERWBEDARF |  2  | LP_INV5 | Sicherheit_1017 | T3ESTP_1017 |  .      |  18,00 |
    | VZAEHL_ERWBEDARF |  10 | LP_INV4 | VW1_1017        | T2ESTP_1017 |  -1     |  21,00 |
    | VZAEHL_ERWBEDARF |  10 | LP_INV4 | !dontChange     | !dontChange |  .      |  20,00 |
    | VZAEHL_ERWBEDARF |  15 | LP_INV6 | !dontChange     | !dontChange |  .      |  20,00 |
    | VZAEHL_ERWBEDARF |   5 | LP_INV6 | !dontChange     | TESTP_1017  |  -5     |  20,00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Bestaende VZAEHL_AUFTRAG
Given I open an editor "Rechnung_02" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST            |
    | vom      | .               |
    | ueb      | ja              |
    | fakt     | ja              |
    | ebeleg   | RE2_TEST_VZAEHL |
    | budat    | .               |
    | erfwaehr | DEM             |
And I append rows
   | artikel         | mge | platz   | verw         | projekt     | verfdat | preis  |
   | VZAEHL_AUFTRAG  |  25 | LP_INV4 | 12345_1017   | !dontChange |  -10    |  20,00 |
   | VZAEHL_AUFTRAG  |  15 | LP_INV4 | 6789_25_1017 | !dontChange |  -3     |  19,00 |
   | VZAEHL_AUFTRAG  |  15 | LP_INV4 | 123_1017     | !dontChange |  .      |  18,00 |
   | VZAEHL_AUFTRAG  |  15 | LP_INV5 | 12345_1017   | T2ESTP_1017 |  -1     |  21,00 |
   | VZAEHL_AUFTRAG  |   7 | LP_INV6 | !dontChange  | T2ESTP_1017 |  .      |  20,00 |
   | VZAEHL_AUFTRAG  |   3 | LP_INV6 | 12345_1017   | !dontChange |  .      |  20,00 |
   | VZAEHL_AUFTRAG  |   5 | LP_INV4 | !dontChange  | !dontChange |  -5     |  20,00 |
   | VZAEHL_AUFTRAG  |   7 | LP_INV5 | !dontChange  | !dontChange |  -5     |  20,00 |
   | VZAEHL_AUFTRAG  |  10 | LP_INV6 | !dontChange  | !dontChange |  -5     |  20,00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Bestaende VZAEHL_PROJEKT
Given I open an editor "Rechnung_03" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST            |
    | vom      | .               |
    | ueb      | ja              |
    | fakt     | ja              |
    | ebeleg   | RE3_TEST_VZAEHL |
    | budat    | .               |
    | erfwaehr | DEM             |
And I append rows
    | artikel        | mge | platz   | projekt | verfdat | preis  |
    | VZAEHL_PROJEKT |  7  | LP_INV4 | B1_1017 |  -25    |  20,00 |
    | VZAEHL_PROJEKT |  3  | LP_INV4 | B1_1017 |  -20    |  19,00 |
    | VZAEHL_PROJEKT |  4  | LP_INV4 | A1_1017 |  -10    |  18,00 |
    | VZAEHL_PROJEKT |  3  | LP_INV4 | A1_1017 |  -15    |  21,00 |
    | VZAEHL_PROJEKT |  1  | LP_INV4 | C1_1017 |  -5     |  20,00 |
    | VZAEHL_PROJEKT |  4  | LP_INV4 | C1_1017 |   .     |  21,00 |
 And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Bestaende VZAEHL_ACHARGE
Given I open an editor "Rechnung_04" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST            |
    | vom      | .               |
    | ueb      | ja              |
    | fakt     | ja              |
    | ebeleg   | RE4_TEST_VZAEHL |
    | budat    | .               |
    | erfwaehr | DEM             |
And I append rows
    | artikel        | mge | platz   | verw   | charge     | verfdat | preis  |
    | VZAEHL_ACHARGE |  2  | LP_INV5 | VERW_A | VZ_CHARGE1 |  -10    |  20,00 |
    | VZAEHL_ACHARGE |  5  | LP_INV5 | VERW_B | VZ_CHARGE1 |  -3     |  19,00 |
    | VZAEHL_ACHARGE |  10 | LP_INV5 | VERW_A | VZ_CHARGE2 |  .      |  18,00 |
    | VZAEHL_ACHARGE |  14 | LP_INV5 | VERW_B | VZ_CHARGE2 |  -1     |  21,00 |
    | VZAEHL_ACHARGE |  20 | LP_INV5 | VERW_B | VZ_CHARGE3 |  .      |  20,00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Bestaende EINHEIT ze=m, zele=1
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | VZAEHL_EINHEIT |
    | buart   | Zugang         |
    | beleg   | TEST_VZ1       |
    | beldat  |  .             |
    | wert    |  5             |
And I append rows
    | mge | platz2  | ze | zele |
    | 10  | LP_INV6 | m  | 1    |
And I save the current editor

# Bestaende EINHEIT ze=m, zele=1
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | VZAEHL_EINHEIT |
    | buart   | Zugang         |
    | beleg   | TEST_VZ2       |
    | beldat  |  .             |
    | wert    |  5             |
And I append rows
    | mge | platz2  | ze | zele |
    | 20  | LP_INV6 | m  | 1    |
And I save the current editor

# Bestaende EINHEIT ze=kg, zele=1
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | VZAEHL_EINHEIT |
    | buart   | Zugang         |
    | beleg   | TEST_VZ3       |
    | beldat  |  .             |
    | wert    |  5             |
And I append rows
    | mge | platz2  | ze | zele |
    |  2  | LP_INV6 | kg | 1    |
And I save the current editor

# Bestaende EINHEIT ze=kg, zele=1
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | VZAEHL_EINHEIT |
    | buart   | Zugang         |
    | beleg   | TEST_VZ4       |
    | beldat  |  .             |
    | wert    |  5             |
And I append rows
    | mge | platz2  | ze | zele |
    |  3  | LP_INV6 | kg | 1    |
And I save the current editor

# Bestaende EINHEIT ze=Stueck, zele=2
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | VZAEHL_EINHEIT |
    | buart   | Zugang         |
    | beleg   | TEST_VZ5       |
    | beldat  |  .             |
    | wert    |  5             |
And I append rows
    | mge | platz2  | ze   | zele |
    | 17  | LP_INV6 |Stück | 2    |
And I save the current editor

Scenario Outline: Behaelter anlegen
Given I open an editor "<such>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I save the current editor

Examples:
| such            | packm |
| VEREINFACHT_1   | KLT   |
| VEREINFACHT_2   | KLT   |
| VEREINFACHT_3   | KLT   |

# Bestand in Behaelter buchen
Scenario: Bestaende IN_BEHAELTER
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "IN_BEHAELTER"
And I set field "buart" to "Zugang"
And I set field "beleg" to "TEST_VZAEHL"
And I set field "beldat" to "."
And I append rows
    | mge | platz2  | verw       | behaelter     |
    | 10  | LP_INV4 | 12345_KLT  | VEREINFACHT_1 |
    |  5  | LP_INV5 | 123_KLT    | VEREINFACHT_2 |
    |  8  | LP_INV5 | 1234_KLT   | VEREINFACHT_3 |
And I save the current editor

##############################################################################
## Scenario 01 - Vereinfacht zaehlen nicht moeglich fuer Behaelterbestaende ##
## Pruefen Haken vzaehlen wird entfernt, Zaehlliste nicht speichern ##

Scenario: 01 Vereinfacht zaehlen nicht moeglich fuer Behaelterbestaende

# Zaehlliste anlegen VZAEHL fuer Behaelterbestand
Given I open an editor "Zaehlliste_BEHAELTER" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "VZ_BEHAELTER"
And I set field "vzaehlen" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "IN_BEHAELTER" in row !lastRow
And I set field "platz" to "LP_INV4" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "IN_BEHAELTER" in row !lastRow
And I set field "platz" to "LP_INV5" in row !lastRow
# Pruefen dass Haken vzaehlen entfernt wurde
Then field "vzaehlen" has value "nein" in row 0
And I close the current editor

###################################################################################################################
### Scenario 02: Zaehlliste Vereinfachtes Zaehlen fuer auftragsbezogenen und erweitert bedarfsbezogenen Artikel ###
### kompletter Durchlauf und Verteilung Bestandsabbau pruefen ###


Scenario: 02 Zaehlliste Vereinfachtes Zaehlen fuer auftragsbezogenen und erweitert bedarfsbezogenen Artikel

# Zaehlliste anlegen VZAEHL fuer AUFTRAG und ERWBEDARF
Given I open an editor "Zaehlliste_AUFTRAG" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "VZAEHL_1017"
And I set field "vzaehlen" to "ja"
And I append rows
    | artikel          | platz   |
    | VZAEHL_AUFTRAG   | LP_INV4 |
    | VZAEHL_AUFTRAG   | LP_INV5 |
    | VZAEHL_AUFTRAG   | LP_INV6 |
    | VZAEHL_ERWBEDARF | LP_INV4 |
    | VZAEHL_ERWBEDARF | LP_INV5 |
    | VZAEHL_ERWBEDARF | LP_INV6 |
And I save the current editor

# Zaehlliste VZAEHL pruefen
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "VZAEHL_1017"
Then table has values
    | artikel          | platz   | gebeinh  | gebf | verw  | projekt |
    | VZAEHL_ERWBEDARF | LP_INV6 | Stück   | 1    |       |         |
    | VZAEHL_ERWBEDARF | LP_INV5 | Stück   | 1    |       |         |
    | VZAEHL_ERWBEDARF | LP_INV4 | Stück   | 1    |       |         |
    | VZAEHL_AUFTRAG   | LP_INV6 | Stück   | 1    |       |         |
    | VZAEHL_AUFTRAG   | LP_INV5 | Stück   | 1    |       |         |
    | VZAEHL_AUFTRAG   | LP_INV4 | Stück   | 1    |       |         |
And I close the current editor

# Inventur eroeffnen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "RELEASE" for record "VZAEHL_1017" and menu choice "Ja"
And I save the current editor

# Zaehlmengen erfassen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "VZAEHL_1017"
Then table has values
    | artikel          | platz   | gebeinh  | gebf | ibest | verw |
    | VZAEHL_ERWBEDARF | LP_INV6 | Stück   | 1    |  20   |      |
    | VZAEHL_ERWBEDARF | LP_INV5 | Stück   | 1    |   2   |      |
    | VZAEHL_ERWBEDARF | LP_INV4 | Stück   | 1    |  44   |      |
    | VZAEHL_AUFTRAG   | LP_INV6 | Stück   | 1    |  20   |      |
    | VZAEHL_AUFTRAG   | LP_INV5 | Stück   | 1    |  22   |      |
    | VZAEHL_AUFTRAG   | LP_INV4 | Stück   | 1    |  60   |      |
And I modify table
    | !row | nbest |
    |  1   |  3    |
    |  2   | 36    |
    |  3   | 18    |
    |  4   |  5    |
    |  5   | 40    |
    |  6   | 37    |
And I save the current editor

# Bestandsabschluss VZAEHL
Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "VZAEHL_1017" and menu choice "Ja"
And I save the current editor

# Zaehlliste VZAEHL Aenderungen schreibgeschuetzt
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "VZAEHL_1017"
Then field "nbest" is not modifiable in row 1
Then field "nbest" is not modifiable in row 2
Then field "nbest" is not modifiable in row 4
And I close the current editor

# Verteilung Bestandsabbau pruefen
# Lagerjournal VZAEHL_AUFTRAG pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "kursache" to "Inventur"
And I set field "artikel" to "VZAEHL_AUFTRAG"
And I press start
Then table has values
    | kmge | mei    | vplatz  | verw         | projekt     |
    | -10  | Stück | LP_INV6 |              |             |
    | -5   | Stück | LP_INV6 |              | T2ESTP_1017 |
    |  18  | Stück | LP_INV5 |              |             |
    | -5   | Stück | LP_INV4 |              |             |
    | -15  | Stück | LP_INV4 | 123_1017     |             |
    | -3   | Stück | LP_INV4 | 6789_25_1017 |             |
And I set field "artikel" to "VZAEHL_ERWBEDARF"
And I press start
Then table has values
    | kmge | mei    | vplatz  | verw            | projekt     |
    | -15  | Stück | LP_INV6 |                 |             |
    | -2   | Stück | LP_INV6 |                 | TESTP_1017  |
    |  34  | Stück | LP_INV5 |                 |             |
    | -10  | Stück | LP_INV4 |                 |             |
    | -12  | Stück | LP_INV4 | Sicherheit_1017 |             |
    | -4   | Stück | LP_INV4 | VW1_1017        | T2ESTP_1017 |
And I close the current editor

# Platzmengenelemente pruefen
Given I query "artikel,platz,gebmge,verw,projekt" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV4;artikel==VZAEHL_ERWBEDARF"
Then query has values
    | artikel      		| platz   | gebmge | verw		 	 | projekt		|
    | VZAEHL_ERWBEDARF 	| LP_INV4 |    6   | VW1_1017 		 | T2ESTP_1017	|
    | VZAEHL_ERWBEDARF 	| LP_INV4 |   12   | Sicherheit_1017 | T3ESTP_1017	|

Given I query "artikel,platz,gebmge,verw,projekt" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV5;artikel==VZAEHL_ERWBEDARF"
Then query has values
    | artikel      		| platz   | gebmge | verw		 	 | projekt		|
    | VZAEHL_ERWBEDARF 	| LP_INV5 |    2   | Sicherheit_1017 | T3ESTP_1017	|
    | VZAEHL_ERWBEDARF 	| LP_INV5 |   34   | 				 | 				|

Given I query "artikel,platz,gebmge,verw,projekt" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV6;artikel==VZAEHL_ERWBEDARF"
Then query has values
    | artikel      		| platz   | gebmge | verw		 	 | projekt		|
    | VZAEHL_ERWBEDARF 	| LP_INV6 |    3   | 				 | TESTP_1017	|

Given I query "artikel,platz,gebmge,verw,projekt" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV4;artikel==VZAEHL_AUFTRAG"
Then query has values
    | artikel      		| platz   | gebmge | verw		 	 | projekt		|
    | VZAEHL_AUFTRAG 	| LP_INV4 |   25   | 12345_1017		 |				|
    | VZAEHL_AUFTRAG 	| LP_INV4 |   12   | 6789_25_1017	 | 				|

Given I query "artikel,platz,gebmge,verw,projekt" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV5;artikel==VZAEHL_AUFTRAG"
Then query has values
    | artikel      		| platz   | gebmge | verw		 	 | projekt		|
    | VZAEHL_AUFTRAG 	| LP_INV5 |   15   | 12345_1017		 | T2ESTP_1017	|
    | VZAEHL_AUFTRAG 	| LP_INV5 |    7   |				 | 				|
    | VZAEHL_AUFTRAG 	| LP_INV5 |   18   |				 | 				|

Given I query "artikel,platz,gebmge,verw,projekt" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV6;artikel==VZAEHL_AUFTRAG"
Then query has values
    | artikel      		| platz   | gebmge | verw		 	 | projekt		|
    | VZAEHL_AUFTRAG 	| LP_INV6 |    3   | 12345_1017		 |				|
    | VZAEHL_AUFTRAG 	| LP_INV6 |    2   | 				 | T2ESTP_1017	|

# aktuelle Inventurdifferenzliste pruefen
And I open the infosystem "STOCKTAKINGDIFF"
And I set field "zlsnr" to "VZAEHL_1017"
And I set field "bnurabweichungen" to "ja"
And I press start
Then table has values
    | tartikel         | tbpr    | preisinfo     | tnbest | tibest  | tmgediffle |
    | VZAEHL_ERWBEDARF | 19.9094 | aus Bewertung |   3    |  20     |    -17     |
    | VZAEHL_ERWBEDARF | 19.9091 | aus Bewertung |  36    |   2     |     34     |
    | VZAEHL_ERWBEDARF | 19.9092 | aus Bewertung |  18    |  44     |    -26     |
    | VZAEHL_AUFTRAG   | 19.7060 | aus Bewertung |   5    |  20     |    -15     |
    | VZAEHL_AUFTRAG   | 19.7061 | aus Bewertung |  40    |  22     |     18     |
    | VZAEHL_AUFTRAG   | 19.7061 | aus Bewertung |  37    |  60     |    -23     |
And I set field "abwprozent" to "60"
And I press start
Then table has values
    | tartikel         | tbpr    | preisinfo     | tnbest | tibest  | tmgediffle |
    | VZAEHL_ERWBEDARF | 19.9094 | aus Bewertung |   3    |  20     |    -17     |
    | VZAEHL_ERWBEDARF | 19.9091 | aus Bewertung |  36    |   2     |     34     |
    | VZAEHL_AUFTRAG   | 19.7060 | aus Bewertung |   5    |  20     |    -15     |
    | VZAEHL_AUFTRAG   | 19.7061 | aus Bewertung |  40    |  22     |     18     |
And I close the current editor

# Inventurabschluss
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "VZAEHL_1017" and menu choice "Ja"
And I save the current editor


##########################################################################################
### Scenario 03 Vereinfacht Zaehlen fuer Artikel mit Charge und Einheiten ################
### vzaehlen wird automatisch gesetzt - kompletter Durchlauf und Bestandsabbau pruefen ###


Scenario: 03 Vereinfacht Zaehlen fuer Artikel mit Charge und Einheiten

# Zaehlliste anlegen ACHARGE, EINHEIT
Given I open an editor "Zaehlliste_ACHARGE_EINH" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ACHARGE_EIN_VZAEHL"
And I append rows
    | artikel        | platz   |
    | VZAEHL_ACHARGE | LP_INV5 |
    | VZAEHL_EINHEIT | LP_INV6 |
And I save the current editor

# vzaehlen wird automatisch gesetzt, Charge wird nicht zusammengefasst, aber 1 Zeile pro Charge unterschiedliche Verwendung wird zusammengefasst
# Zaehlliste ACHARGE, EINHEIT pruefen
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "ACHARGE_EIN_VZAEHL"
Then table has values
    | artikel			| gebeinh  | gebf | tcharge    | verw   | vzaehlen |
    | VZAEHL_EINHEIT	| m		   | 1    | 		   |        |  ja      |
    | VZAEHL_EINHEIT	| kg	   | 1    | 		   |        |  ja      |
    | VZAEHL_EINHEIT	| Stück    | 2    | 		   |        |  ja      |
    | VZAEHL_ACHARGE	| Stück    | 1    | VZ_CHARGE1 |        |  ja      |
    | VZAEHL_ACHARGE	| Stück    | 1    | VZ_CHARGE2 |        |  ja      |
    | VZAEHL_ACHARGE	| Stück    | 1    | VZ_CHARGE3 |        |  ja      |
And I close the current editor

# Inventur eroeffnen
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ACHARGE_EIN_VZAEHL" and menu choice "Ja"
And I save the current editor

# Zaehlliste ACHARGE, EINHEIT bearbeiten und Zaehlmengen erfassen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ACHARGE_EIN_VZAEHL"
Then table has values
    | platz   | ibest | gebeinh | gebf | tcharge    | verw   |
    | LP_INV6 | 30    | m       | 1    |            |        |
    | LP_INV6 | 5     | kg      | 1    |            |        |
    | LP_INV6 | 17    | Stück  | 2    |            |        |
    | LP_INV5 | 7     | Stück  | 1    | VZ_CHARGE1 |        |
    | LP_INV5 | 24    | Stück  | 1    | VZ_CHARGE2 |        |
    | LP_INV5 | 20    | Stück  | 1    | VZ_CHARGE3 |        |
And I modify table
    | !row | nbest |
    |  1   |  25   |
    |  2   |  10   |
    |  3   |  15   |
    |  4   |   4   |
    |  5   |  23   |
    |  6   |  22   |
And I save the current editor

# Bestandsabschluss ACHARGE, EINHEIT
Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ACHARGE_EIN_VZAEHL" and menu choice "Ja"
And I save the current editor

# Verteilung Bestandsabbau und Charge bei Zubuchung pruefen
# Lagerjournal ACHARGE, EINHEIT pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "kursache" to "Inventur"
And I set field "artikel" to "VZAEHL_ACHARGE"
And I press start
Then table has values
    | kmge | mei    | verw   | tvcharge   | tncharge    |
    | -3   | Stück | VERW_B | VZ_CHARGE1 |             |
    | -1   | Stück | VERW_B | VZ_CHARGE2 |             |
    |  2   | Stück |        |            | VZ_CHARGE3  |
And I set field "artikel" to "VZAEHL_EINHEIT"
And I press start
Then table has values
     | kmge | mei    | verw   |
     | -5   | m      |        |
     | 5    | kg     |        |
     | -2   | Stück |        |
And I close the current editor


# Platzmengenelemente pruefen
Given I query "artikel,platz,gebmge,verw,charge^such" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV5;artikel==VZAEHL_ACHARGE"
Then query has values
    | artikel      		| platz   | gebmge | verw	 | charge^such 	|
    | VZAEHL_ACHARGE 	| LP_INV5 |    2   | VERW_A  | VZ_CHARGE1	|
    | VZAEHL_ACHARGE 	| LP_INV5 |    2   | VERW_B	 | VZ_CHARGE1	|
    | VZAEHL_ACHARGE 	| LP_INV5 |   10   | VERW_A	 | VZ_CHARGE2	|
    | VZAEHL_ACHARGE 	| LP_INV5 |   13   | VERW_B	 | VZ_CHARGE2	|
    | VZAEHL_ACHARGE 	| LP_INV5 |   20   | VERW_B	 | VZ_CHARGE3	|
    | VZAEHL_ACHARGE 	| LP_INV5 |    2   | 		 | VZ_CHARGE3 	|

Given I query "artikel,platz,gebmge,gebeinh,gebf" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV6;artikel==VZAEHL_EINHEIT"
Then query has values
    | artikel      		| platz   | gebmge | gebeinh | gebf			|
    | VZAEHL_EINHEIT 	| LP_INV6 |   10   |   m	 |   1			|
    | VZAEHL_EINHEIT 	| LP_INV6 |   15   |   m	 |   1			|
    | VZAEHL_EINHEIT 	| LP_INV6 |    2   |   kg	 |   1			|
    | VZAEHL_EINHEIT 	| LP_INV6 |    3   |   kg	 |   1			|
    | VZAEHL_EINHEIT 	| LP_INV6 |   15   |   Stück |   2			|
    | VZAEHL_EINHEIT 	| LP_INV6 |    5   |   kg	 |   1			|

# Inventurabschluss
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "ACHARGE_EIN_VZAEHL" and menu choice "Ja"
And I save the current editor

#######################################################################################
### Scenario 04 Vereinfacht Zaehlen fuer Artikel mit Projekt

Scenario: 04 Vereinfacht Zaehlen fuer Artikel mit Projekt

# Zaehlliste anlegen VZAEHL_PROJEKT
Given I open an editor "Zaehlliste_ACHARGE_EINH" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "PROJEKT_VZAEHL"
And I append rows
    | artikel        | platz   |
    | VZAEHL_PROJEKT | LP_INV4 |
And I save the current editor

# vzaehlen wird automatisch gesetzt, Charge wird nicht zusammengefasst, aber 1 Zeile pro Charge unterschiedliche Verwendung wird zusammengefasst
# Zaehlliste VZAEHL_PROJEKT pruefen
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "PROJEKT_VZAEHL"
Then table has values
    | artikel        | platz   | gebeinh | gebf | verw  | projekt |
    | VZAEHL_PROJEKT | LP_INV4 | Stück   | 1    |       |         |
And I close the current editor

# Inventur eroeffnen
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "PROJEKT_VZAEHL" and menu choice "Ja"
And I save the current editor

# Zaehlliste VZAEHL_PROJEKT bearbeiten und Zaehlmengen erfassen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "PROJEKT_VZAEHL"
Then table has values
    | platz   | ibest | gebeinh | gebf | verw	| projekt |
    | LP_INV4 |  22   | Stück   | 1    |        |         |
And I modify table
    | !row | nbest |
    |  1   |  11   |
And I save the current editor

# Bestandsabschluss VZAEHL_PROJEKT
Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "PROJEKT_VZAEHL" and menu choice "Ja"
And I save the current editor

# Verteilung Bestandsabbau pruefen
# Lagerjournal VZAEHL_PROJEKT pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "kursache" to "Inventur"
And I set field "artikel" to "VZAEHL_PROJEKT"
And I press start
Then table has values
    | kmge | mei    | vplatz  | verw         | projekt |
    | -4   | Stück | LP_INV4 |              | C1_1017 |
    | -1   | Stück | LP_INV4 |              | C1_1017 |
    | -3   | Stück | LP_INV4 |              | A1_1017 |
    | -1   | Stück | LP_INV4 |              | A1_1017 |
And I close the current editor

# Platzmengenelemente pruefen
Given I query "artikel,platz,gebmge,projekt,verfdat" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV4;artikel==VZAEHL_PROJEKT"
Then query has values
    | artikel      		| platz   | gebmge | projekt |
    | VZAEHL_PROJEKT 	| LP_INV4 |    7   | B1_1017 |
    | VZAEHL_PROJEKT 	| LP_INV4 |    1   | B1_1017 |
    | VZAEHL_PROJEKT 	| LP_INV4 |    3   | A1_1017 |


# Inventurabschluss
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "PROJEKT_VZAEHL" and menu choice "Ja"
And I save the current editor

