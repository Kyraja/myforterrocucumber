# *****************************************************************************
#  Name             : Inventur_Zaehllisten_ohne_Behaelter.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Inventur ohne Behaelter
#
# *****************************************************************************
@persistent
Feature: Inventur_Zaehllisten_ohne_Behaelter.feature

Background:
Given I set the fake date to "02.01.95"

#### Artikel und Bestaende anlegen ####
Scenario Outline: Verschiedene Kaufteile anlegen
Given I open an editor "<artikel>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such         | <such>           |
    | namebspr     | <namebspr>       |
    | bsart        | Fremdbeschaffung |
    | dispoa       | <dispoa>         |
    | chverfolgung | <chverfolgung>   |
    | chimlager    | <chimlager>      |
    | lief         | 1                |
    | efrist       | 2                |
    | epr          | 3                |
    | invsperr     | <invsperr>       |
And I save the current editor

Examples: Kaufteile
    | artikel        | such           | namebspr                 | dispoa                   | chverfolgung      | chimlager   | invsperr |
    | EKTEIL_6001    | EKTEIL_6001    | Einkaufsteil             | bedarfsbezogen           | !dontChange       | !dontChange | nein     |
    | ERWBEDARF_6001 | ERWBEDARF_6001 | Erweitert Bedarfsbezogen | erweitert bedarfsbezogen | !dontChange       | !dontChange | nein     |
    | AUFTRAG_6001   | AUFTRAG_6001   | Auftrag                  | auftragsbezogen          | !dontChange       | !dontChange | nein     |
    | PROJEKT_6001   | PROJEKT_6001   | Projekt                  | projektbezogen           | !dontChange       | !dontChange | nein     |
    | CHARGE_6001    | CHARGE_6001    | Charge                   | !dontChange              | Chargenverfolgung | ja          | nein     |
    | ACHARGE_6001   | ACHARGE_6001   | Charge, Auftrag          | auftragsbezogen          | Chargenverfolgung | ja          | nein     |
    | INVSPERRE      | INVSPERRE      | Inventursperre           | bedarfsbezogen           | !dontChange       | !dontChange | ja       |
    | LOESCH         | LOESCH         | Artikel loeschen         | bedarfsbezogen           | !dontChange       | !dontChange | nein     |


Scenario Outline: Projekte
Given I open an editor "<projekt>" from table "(Transaction):(Project)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I save the current editor

Examples: Projekte
    | projekt     | such        | namebspr           |
    | TEST_6001   | TESTP_6001  | Testprojekt_6001   |
    | T2ESTP_6001 | T2ESTP_6001 | Testprojekt 2_6001 |
    | T3ESTP_6001 | T3ESTP_6001 | Testprojekt 3_6001 |


Scenario: Chargen und weitere Kaufteile anlegen
And I create a Lot "CH1_6001" for Product "CHARGE_6001"
And I create a Lot "CHA1_6001" for Product "ACHARGE_6001"
And I create a Lot "CHA2_6001" for Product "ACHARGE_6001"

# auftragsbezogenes Kaufteil m Mindestbestand MINDESTB
Given I open an editor "MINDESTB_6001" from table "(Part):(Product)" with command "STORE" for record "MINDESTB_6001"
And I set fields
    | such     | MINDESTB_6001    |
    | namebspr | Mindestbestand   |
    | bsart    | Fremdbeschaffung |
    | dispoa   | auftragsbezogen  |
    | mindest  | 50               |
    | lief     | 1                |
    | efrist   | 2                |
    | epr      | 3                |
And I save the current editor

# Kaufteil m Gebindeeinheiten EINHEIT
Given I open an editor "EINHEIT_6001" from table "(Part):(Product)" with command "STORE" for record "EINHEIT_6001"
And I set fields
    | such     | EINHEIT_6001     |
    | namebspr | Einheit          |
    | bsart    | Fremdbeschaffung |
    | lief     | 1                |
    | efrist   | 2                |
    | epr      | 3                |
    | le       | m                |
    | vhe      | Stück            |
    | fvhle    | 2                |
    | gebvhe   | JA               |
    | vpe      | Stück            |
    | fvple    | 2                |
    | gebvpe   | JA               |
    | ehe      | kg               |
    | fehle    | 1                |
    | gebehe   | JA               |
    | epe      | kg               |
    | feple    | 1                |
    | gebepe   | JA               |
    | ve       | Stück            |
    | fvele    | 2                |
    | gebve    | JA               |
    | ge       | m                |
And I save the current editor

# bedarfsbezogenes Kaufteil mit Mengen loeschen
Given I open an editor "MGELOESCH" from table "(Part):(Product)" with command "STORE" for record "MGELOESCH"
And I set fields
    | such     | MGELOESCH        |
    | namebspr | Mengen loeschen  |
    | bsart    | Fremdbeschaffung |
    | dispoa   | bedarfsbezogen   |
    | lnullm   | ja               |
    | abplatz  | LP_INV1          |
    | lief     | 1                |
    | efrist   | 2                |
    | epr      | 3                |
And I save the current editor

### Bestaende mit Lagerbuchung ###

Scenario: Bestaende zubuchen

Given I post a receipt via ManualStockAdjustment for Product "MINDESTB_6001" and quantity "70" on StorageLocation "LP_INV1" with document "TEST_6001"
Given I post a receipt via ManualStockAdjustment for Product "MINDESTB_6001" and quantity "20" on StorageLocation "LP_INV1" with document "TEST_6001"

Given I post a receipt via ManualStockAdjustment for Product "INVSPERRE" and quantity "10" on StorageLocation "LP_INV1" with document "TEST_6001"
Given I post a receipt via ManualStockAdjustment for Product "INVSPERRE" and quantity "20" on StorageLocation "LP_INV3" with document "TEST_6001"

Given I post a receipt via ManualStockAdjustment for Product "MGELOESCH" and quantity "10" on StorageLocation "LP_INV1" with document "TEST_6001"
Given I post a receipt via ManualStockAdjustment for Product "MGELOESCH" and quantity "20" on StorageLocation "LP_INV3" with document "TEST_6001"

# Bestaende EINHEIT ze=m, zele=1
Given I open an editor "Lagerbuchung_01" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | EINHEIT_6001 |
    | beleg   | TEST_6001    |
    | beldat  |  .           |
    | buart   | Zugang       |
    | wert    |     1        |
And I append rows
    | mge | platz2  | ze     | zele |
    | 10  | LP_INV1 | m      | 1    |
    | 20  | LP_INV1 | m      | 1    |
    |  5  | LP_INV1 | kg     | 1    |
    | 17  | LP_INV1 | Stück  | 2    |
And I save the current editor

### Bestaende durch EK-Rechnung  ###

Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE1_TEST_6001 |
    | budat    | .             |
    | erfwaehr | DEM           |
And I append rows
    | artikel     | mge | platz   | verfdat | preis |
    | EKTEIL_6001 | 10  | LP_INV1 |  -5     |  5,00 |
    | EKTEIL_6001 | 20  | LP_INV1 |  -10    |  4,00 |
    | EKTEIL_6001 | 15  | LP_INV2 |  -5     |  4,50 |
    | EKTEIL_6001 | 15  | LP_INV3 |  -10    |  4,50 |
    | EKTEIL_6001 |  5  | LP_INV3 |  .      |  4,50 |
    | EKTEIL_6001 | 10  | LP_INV3 |  .      |  4,25 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Rechnung_02" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE2_TEST_6001 |
    | budat    | .             |
    | erfwaehr | DEM           |
And I append rows
    | artikel        | mge | platz   | verw            | projekt     | verfdat | preis |
    | ERWBEDARF_6001 | 12  | LP_INV1 | Sicherheit_6001 | !dontChange |  -5     |  5,00 |
    | ERWBEDARF_6001 | 12  | LP_INV1 | Sicherheit_6001 | T3ESTP_6001 |  -10    |  4,00 |
    | ERWBEDARF_6001 |  2  | LP_INV2 | Sicherheit_6001 | T3ESTP_6001 |  .      |  5,00 |
    | ERWBEDARF_6001 | 10  | LP_INV1 | VW1_6001        | T2ESTP_6001 |  -1     |  5,00 |
    | ERWBEDARF_6001 |  5  | LP_INV3 |                 |             |  .      |  5,00 |
    | ERWBEDARF_6001 |  8  | LP_INV3 |                 |             |  -5     |  4,50 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Rechnung_03" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE3_TEST_6001 |
    | budat    | .             |
    | erfwaehr | DEM           |
And I append rows
    | artikel      | mge | platz   | verw         | projekt     | verfdat | preis  |
    | AUFTRAG_6001 | 25  | LP_INV1 | 12345_6001   | !dontChange |  -5     |  10,00 |
    | AUFTRAG_6001 | 15  | LP_INV1 | 6789_25_6001 | !dontChange |  -10    |  11,00 |
    | AUFTRAG_6001 | 15  | LP_INV1 | 123_6001     | !dontChange |  .      |   9,00 |
    | AUFTRAG_6001 | 15  | LP_INV1 | 12345_6001   | T2ESTP_6001 |  -1     |  10,00 |
    | AUFTRAG_6001 | 7   | LP_INV2 | !dontChange  | T2ESTP_6001 |  -5     |  10,00 |
    | AUFTRAG_6001 | 3   | LP_INV3 | 12345_6001   | !dontChange |  -8     |   8,00 |
    | AUFTRAG_6001 | 2   | LP_INV3 | !dontChange  | !dontChange |  -5     |  10,00 |
    | AUFTRAG_6001 | 4   | LP_INV3 | !dontChange  | !dontChange |  -8     |   9,00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Rechnung_04" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE4_TEST_6001 |
    | budat    | .             |
    | erfwaehr | DEM           |
And I append rows
    | artikel      | mge | platz   | projekt     | verfdat | preis  |
    | PROJEKT_6001 | 9   | LP_INV1 | TESTP_6001  |  -5     |  10,00 |
    | PROJEKT_6001 | 15  | LP_INV1 | TESTP_6001  |  -10    |  11,00 |
    | PROJEKT_6001 | 9   | LP_INV1 | TESTP_6001  |  .      |   9,00 |
    | PROJEKT_6001 | 9   | LP_INV1 | TESTP_6001  |  -1     |  10,00 |
    | PROJEKT_6001 | 15  | LP_INV1 | T2ESTP_6001 |  -5     |  10,00 |
    | PROJEKT_6001 | 12  | LP_INV1 | T3ESTP_6001 |  -8     |   8,00 |
    | PROJEKT_6001 | 9   | LP_INV3 | TESTP_6001  |  -5     |  10,00 |
    | PROJEKT_6001 | 8   | LP_INV3 | T3ESTP_6001 |   .     |   9,00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Rechnung_05" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE5_TEST_6001 |
    | budat    | .             |
    | erfwaehr | DEM           |
And I append rows
    | artikel     | mge | platz   | charge   | verfdat | preis  |
    | CHARGE_6001 | 12  | LP_INV1 | CH1_6001 |  -5     |  10,00 |
    | CHARGE_6001 |  5  | LP_INV1 | CH1_6001 |  -10    |  11,00 |
    | CHARGE_6001 | 25  | LP_INV2 | CH1_6001 |  .      |   9,00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Rechnung_06" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE6_TEST_6001 |
    | budat    | .             |
    | erfwaehr | DEM           |
And I append rows
    | artikel      | mge | platz   | verw     | charge    | verfdat | preis  |
    | ACHARGE_6001 |  2  | LP_INV1 | VW1_6001 | CHA1_6001 |  -5     |  20,00 |
    | ACHARGE_6001 |  5  | LP_INV2 | VW2_6001 | CHA1_6001 |  -10    |  19,00 |
    | ACHARGE_6001 |  5  | LP_INV1 | VW1_6001 | CHA2_6001 |  .      |  18,00 |
    | ACHARGE_6001 |  5  | LP_INV1 | VW2_6001 | CHA2_6001 |  -1     |  21,00 |
    | ACHARGE_6001 |  5  | LP_INV1 | VW1_6001 | CHA2_6001 |  .      |  20,00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


######################################################################################################
#####################   Scenario 01 Zaehlliste fuer Lager INVENTUR  ###################################
#### Testet Artikel Inventursperre und Dummyzeile und Platzmenge anderes Lager und Zeilen loeschen ####


Scenario: 01 Zaehlliste fuer Lager INVENTUR

# Zaehlliste anlegen Lager INVENTUR (alle Lagerplaetze)
Given I open an editor "Zaehlliste_Lager_01" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "LAGER-INVENTUR"
And I set field "lager" to "INVENTUR"
And I create a new row at the end of the table
And I set field "artikel" to "EKTEIL_6001" in row !lastRow
And I set field "platz" to "LP_INV1" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "EKTEIL_6001" in row !lastRow
And I set field "platz" to "LP_INV2" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "EKTEIL_6001" in row !lastRow
And I set field "platz" to "LP_INV3" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "AUFTRAG_6001" in row !lastRow
And I set field "platz" to "LP_INV1" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "AUFTRAG_6001" in row !lastRow
And I set field "platz" to "LP_INV2" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "AUFTRAG_6001" in row !lastRow
And I set field "platz" to "LP_INV3" in row !lastRow
And I create a new row at the end of the table
And I set field "istdummy" to "ja" in row !lastRow
And I set field "platz" to "LP_INV3" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "ERWBEDARF_6001" in row !lastRow
And I set field "platz" to "LP_INV1" in row !lastRow
## Test Zeile loeschen moeglich
And I delete row at position !lastRow
And I create a new row at the end of the table
##2608 de |Lagerplatz befindet sich nicht in vorgegebenem Lager
Then setting field "platz" to "F1" in row !lastRow throws the exception "2608"
##3065 de |Artikel ist fuer Inventur gesperrt
Then setting field "artikel" to "INVSPERRE" in row !lastRow throws the exception "3065"
And I delete row at position !lastRow
## Pruefen dass Einheiten wechseln moeglich ist - aus Scenario 051 genommen ##
Then pressing button "einhbut" in row 1 throws the exception ""
And I press button "setzposnr"
And I save the current editor


# Zaehlliste Lager INVENTUR pruefen
Given I open an editor "Zaehllistepruefen_01" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "LAGER-INVENTUR"
Then table has values
    | artikel      | platz   | charge | verw         | projekt     |
    | EKTEIL_6001  | LP_INV1 |        |              |             |
    | EKTEIL_6001  | LP_INV2 |        |              |             |
    | EKTEIL_6001  | LP_INV3 |        |              |             |
    | AUFTRAG_6001 | LP_INV1 |        | 12345_6001   | T2ESTP_6001 |
    | AUFTRAG_6001 | LP_INV1 |        | 6789_25_6001 |             |
    | AUFTRAG_6001 | LP_INV1 |        | 123_6001     |             |
    | AUFTRAG_6001 | LP_INV1 |        | 12345_6001   |             |
    | AUFTRAG_6001 | LP_INV2 |        |              | T2ESTP_6001 |
    | AUFTRAG_6001 | LP_INV3 |        | 12345_6001   |             |
    | AUFTRAG_6001 | LP_INV3 |        |              |             |
    |              | LP_INV3 |        |              |             |
And I close the current editor

# Zaehlliste LAGER-INVENTUR bearbeiten
Given I open an editor "Invbearb_01" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "LAGER-INVENTUR"
# Dummyzeile loeschen #
And I delete row at position 11
# unabhaengige Position loeschen #
And I delete row at position 1
# Artikel mit verschiedenen Auspraegungen loeschen, fuehrt zu loeschen mehrere Zeilen #
And I delete row at position 4
Then the table has 5 rows
And I save the current editor

# Zaehlliste loeschen
Given I open an editor "Invbearb_01" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "DELETE" for record "LAGER-INVENTUR"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

#####################################################################################################################
####### Scenario 02 Zaehlliste fuer Zeilen loeschen und Artikel loeschen, sowie Plausis bei addmge und nbest  #######

Scenario: 02 Zaehlliste fuer Zeilen loeschen und Artikel loeschen, sowie Plausis bei addmge und nbest 

# Zaehlliste anlegen fuer paralleles Erfassen
Given I open an editor "Zaehlliste_parallel" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "PARALLEL"
And I append rows
    | artikel        | platz   |
    | CHARGE_6001    | LP_INV1 |
    | CHARGE_6001    | LP_INV2 |
    | ERWBEDARF_6001 | LP_INV1 |
    | ERWBEDARF_6001 | LP_INV2 |
    | MINDESTB_6001  | LP_INV1 |
And I press button "setzposnr"
And I save the current editor

# Zaehlliste anlegen fuer Test loeschen (Zeilen loeschen nach Eroeffnung und Artikel loeschen)
Given I open an editor "Zaehlliste_loeschen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "LOESCHEN"
And I append rows
    | artikel        | platz   |
    | EKTEIL_6001    | LP_INV1 |
    | EKTEIL_6001    | LP_INV2 |
    | AUFTRAG_6001   | LP_INV1 |
    | AUFTRAG_6001   | LP_INV2 |
And I create a new row at the end of the table
And I set field "istdummy" to "ja" in row !lastRow
And I set field "platz" to "LP_INV3" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "LOESCH" in row !lastRow
And I set field "platz" to "LP_INV3" in row !lastRow
And I set field "gebeinh" to "Stück" in row !lastRow
And I set field "gebf" to "1" in row !lastRow
And I press button "setzposnr"
And I save the current editor

# Pruefen, dass Artikel nicht geloescht werden kann
Given I open an editor "artikel_loesch" from table "(Part):(Product)" with command "DELETE" for record "LOESCH"
# 51 de |Artikel befindet sich noch in der Inventur - darf nicht gelöscht werden
Then saving the current editor throws the exception "51"
And I close the current editor

# Zaehlliste LOESCHEN bearbeiten vor Eroeffnung
Given I open an editor "Invbearb_loeschen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "LOESCHEN"
# Artikel LOESCH entfernen #
And I delete row at position !lastRow
And I save the current editor

# Artikel LOESCH nicht mehr auf Zaehlliste und kann nun geloescht werden
Given I open an editor "artikel_loesch" from table "(Part):(Product)" with command "DELETE" for record "LOESCH"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

# Inventur eroeffnen für beide ZAEHLLISTEN nacheinander
Given I open an editor "Invbearb_parallel" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "RELEASE" for record "PARALLEL" and menu choice "ja"
And I save the current editor

Given I open an editor "Invbearb_loeschen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "RELEASE" for record "LOESCHEN" and menu choice "ja"
And I save the current editor

# Zaehlliste bearbeiten, Plausi bei addmge und nbest pruefen
Given I open an editor "Invbearb1" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "PARALLEL"
# nur 2 Zeilen laden, da die Zaehlliste noch mal geoeffnet werden soll, Laden mit Objektauswahl funktioniert nicht
And I set field "anzinv" to "2"
And I set field "nbest" to "18" in row 1
And I set field "nbest" to "25" in row 2
And I set field "nbest" to "10" in row 3
#    179 de   |Ungültige Menge, dadurch ensteht ein negativer Platzbestand.
Then setting field "addmge" to "-12" in row 3 throws the exception "179"
# 8172 de   |Bitte einen Wert größer als 0 eintragen.
Then setting field "nbest" to "-12" in row 4 throws the exception "8172"
And I set field "nbest" to "12" in row 4
And I set field "nbest" to "11" in row 5
And I set field "nbest" to "3" in row 6
And I set field "nbest" to "88" in row 7
And I save the current editor

# Zaehlmenge nbest gespeichert, Zaehlliste noch mal bearbeiten und negative addmge setzen
Given I open an editor "Invbearb1" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "PARALLEL"
#    179 de   |Ungültige Menge, dadurch ensteht ein negativer Platzbestand.
Then setting field "addmge" to "-20" in row 1 throws the exception "179"
And I close the current editor


# Prüfen dass das Inventurkennzeichen gesetzt ist
Given I query "artikel,platz,inv" from table "(StorageQuantity):(LocationQuantity)" where "platz==LP_INV1;artikel==EKTEIL_6001"
Then query has values
    | artikel      | platz   | inv |
    | EKTEIL_6001  | LP_INV1 | Z   |

#Given I open StorageQuantity for Product "EKTEIL_6001" on StorageLocation "LP_INV1"
#Then table has values
#  | inv |
#  |  Z  |
#And I close the current editor

Given I query "artikel,platz,inv" from table "(StorageQuantity):(LocationQuantity)" where "platz==LP_INV1;artikel==AUFTRAG_6001"
Then query has values
    | artikel      | platz   | inv |
    | AUFTRAG_6001 | LP_INV1 | Z   |

# Test Bearbeiten eroeffnete Zaehlliste, bspw. Zeilen entfernen, neue Zeilen anfuegen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "LOESCHEN"
# Pruefen dass Einheit nicht aenderbar ist
Then field "le" is not modifiable in row 2
# Dummyzeile entfernen
And I set field "loeschen" to "ja" in row 1
# Artikel mit verschiedenen Auspraegungen loeschen, fuehrt zu loeschen mehrere Zeilen
And I set field "loeschen" to "ja" in row 3
# unabhaengige Position loeschen
And I set field "loeschen" to "ja" in row !lastRow
# neue Zeile einfuegen moeglich, kein Bestand auf diesem Platz
And I create a new row at the end of the table
And I set field "artikel" to "MINDESTB_6001" in row !lastRow
And I set field "platz" to "LP_INV2" in row !lastRow
And I set field "gebeinh" to "Stück" in row !lastRow
And I set field "gebf" to "1" in row !lastRow
And I save the current editor

# Zaehlmengen erfassen
# Zaehlliste LOESCHEN bearbeiten
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "LOESCHEN"
Then table has values
    | artikel       | platz   | ibest | charge | verw  | projekt     |
    | MINDESTB_6001 | LP_INV2 |    0  |        |       |             |
    | EKTEIL_6001   | LP_INV2 |   15  |        |       |             |
    | AUFTRAG_6001  | LP_INV2 |    7  |        |       | T2ESTP_6001 |
Then I modify table
    | !row | nbest |
    |  1   |  4    |
    |  2   |  14   |
    |  3   |  6    |
And I save the current editor

## Prüfen dass das Inventurkennzeichen aus den geloeschten Platzmengen entfernt wurde
Given I query "artikel,platz,inv" from table "(StorageQuantity):(LocationQuantity)" where "platz==LP_INV1;artikel==EKTEIL_6001"
Then query has values
    | artikel      | platz   | inv |
    | EKTEIL_6001  | LP_INV1 |     |

Given I query "artikel,platz,inv" from table "(StorageQuantity):(LocationQuantity)" where "platz==LP_INV1;artikel==AUFTRAG_6001"
Then query has values
    | artikel      | platz   | inv |
    | AUFTRAG_6001 | LP_INV1 |     |

# Zählliste löschen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "DELETE" for record "LOESCHEN"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

# Zählliste löschen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "DELETE" for record "PARALLEL"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

####################################################################################################
### SCENARIO 03 Zaehlliste fuer Auspraegungen # aus Behaeltertest uebernommen  #####################
### testet auch Zaehlliste loeschen nicht moeglich, Identnummer kann nicht mehr verwendet werden ###
### nach Bestandsabschluss keine Zeilen zufuegen oder entfernen ####################################


Scenario: 03 Zaehlliste fuer Auspraegungen

# Zaehlliste anlegen fuer Auspraegungen PROJEKT, ACHARGE, EINHEIT
Given I open an editor "Zaehlliste_PRO_ACH_EINH" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "P_ACH_EIN_ZAEHL_6001"
And I append rows
    | artikel       | platz   |
    | PROJEKT_6001  | LP_INV1 |
    | ACHARGE_6001  | LP_INV1 |
    | EINHEIT_6001  | LP_INV1 |
And I save the current editor

# Zaehlliste PROJEKT, ACHARGE, EINHEIT pruefen
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "P_ACH_EIN_ZAEHL_6001"
Then table has values
    | gebeinh | gebf | tcharge   | verw     | projekt     |
    | m       | 1    |           |          |             |
    | kg      | 1    |           |          |             |
    | Stück   | 2    |           |          |             |
    | Stück   | 1    | CHA1_6001 | VW1_6001 |             |
    | Stück   | 1    | CHA2_6001 | VW1_6001 |             |
    | Stück   | 1    | CHA2_6001 | VW2_6001 |             |
    | Stück   | 1    |           |          | TESTP_6001  |
    | Stück   | 1    |           |          | T2ESTP_6001 |
    | Stück   | 1    |           |          | T3ESTP_6001 |
And I close the current editor

# Inventur eroeffnen
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "P_ACH_EIN_ZAEHL_6001" and menu choice "Ja"
And I save the current editor

# Zaehlmengen erfassen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "P_ACH_EIN_ZAEHL_6001"
Then table has values
    | platz   | ibest | gebeinh | gebf | tcharge   | verw     | projekt     |
    | LP_INV1 | 30    | m       | 1    |           |          |             |
    | LP_INV1 | 5     | kg      | 1    |           |          |             |
    | LP_INV1 | 17    | Stück   | 2    |           |          |             |
    | LP_INV1 | 2     | Stück   | 1    | CHA1_6001 | VW1_6001 |             |
    | LP_INV1 | 10    | Stück   | 1    | CHA2_6001 | VW1_6001 |             |
    | LP_INV1 | 5     | Stück   | 1    | CHA2_6001 | VW2_6001 |             |
    | LP_INV1 | 42    | Stück   | 1    |           |          | TESTP_6001  |
    | LP_INV1 | 15    | Stück   | 1    |           |          | T2ESTP_6001 |
    | LP_INV1 | 12    | Stück   | 1    |           |          | T3ESTP_6001 |
And I modify table
    | !row | nbest |
    |  1   | 25    |
    |  2   | 10    |
    |  3   | 15    |
    |  4   |       |
    |  5   | 17    |
    |  6   |       |
    |  7   | 45    |
    |  8   | 15    |
    |  9   | 12    |
And I save the current editor

# Bestandsabschluss PROJEKT, ACHARGE, EINHEIT
Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "P_ACH_EIN_ZAEHL_6001" and menu choice "Ja"
And I save the current editor

# Pruefung Zaehlliste nach Bestandsabschluss aendern (Zeile anfuegen, loeschen)
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "P_ACH_EIN_ZAEHL_6001"
# 3794 de   |Zeile kann nicht eingefügt werden
And creating a new row at position 1 throws the exception "3794"
# 3885 de   |Zeile kann nicht gelöscht werden
And deleting the row at position 1 throws the exception "3885"
And I close the current editor

# Pruefung Zaehlliste loeschen
#2947 de |Löschen nicht erlaubt, weil bestandsmäßige Inventur schon abgeschlossen
#Then opening an editor from table "(Stocktaking):(HeaderOfStocktakingSheet)" with command "DELETE" for record "P_ACH_EIN_ZAEHL_6001" throws the exception "2947"
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "DELETE" for record "P_ACH_EIN_ZAEHL_6001"
Then saving the current editor throws the exception "2947"
And I close the current editor

# Inventurkorrekturbuchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "kursache" to "Inventur"
And I set field "artikel" to "PROJEKT_6001"
And I press start
Then table has values
    | kmge | mei    | verw     | tvcharge  | tncharge  | projekt     |
    | 3    | Stück  |          |           |           | TESTP_6001  |
    |      | Stück  |          |           |           | T2ESTP_6001 |
    |      | Stück  |          |           |           | T3ESTP_6001 |
And I set field "artikel" to "ACHARGE_6001"
And I press start
Then table has values
    | kmge | mei   | verw     | tvcharge  | tncharge  | projekt     |
    | -2   | Stück | VW1_6001 | CHA1_6001 |           |             |
    | 7    | Stück | VW1_6001 |           | CHA2_6001 |             |
    | -5   | Stück | VW2_6001 | CHA2_6001 |           |             |
And I set field "artikel" to "EINHEIT_6001"
And I press start
Then table has values
    | kmge | mei    | verw     | tvcharge  | tncharge  | projekt     |
    | -5   | m      |          |           |           |             |
    | 5    | kg     |          |           |           |             |
    | -2   | Stück  |          |           |           |             |
And I close the current editor

# Inventurabschluss
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "P_ACH_EIN_ZAEHL_6001" and menu choice "Ja"
And I save the current editor

# Test Identnummer
Given I open an editor "Zaehlliste_IDENT" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
# 2424 de |Identnummer ist schon in der Ablage vorhanden. Bitte neue wählen!
Then setting field "nummer" in row 0 to "nummer" from editor "Zaehllistepruefen" in row 0 throws the exception "2424"
And I close the current editor

################################################################################################################
######################                Scenario 04 Kompletter Durchlauf                 #########################
### testet auch Inventurdifferenzliste, Bestandskorrektur uebersteuert Zaehlliste, Mischpreis in Zaehliste #####
### Abgang Artikel mit Mengen loeschen -> Platzmenge bleibt erhalten; Inventurkennzeichen werden entfernt   ####

Scenario: 04 kompletter Inventur-Durchlauf

# Zaehlliste anlegen fuer kompletten Inventur-Durchlauf
Given I open an editor "Zaehlliste_DURCHLAUF" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "DURCHLAUF"
And I append rows
    | artikel        | platz   |
    | EKTEIL_6001    | LP_INV1 |
    | ERWBEDARF_6001 | LP_INV1 |
    | AUFTRAG_6001   | LP_INV1 |
    | PROJEKT_6001   | LP_INV1 |
    | MGELOESCH      | LP_INV1 |
    | EKTEIL_6001    | LP_INV3 |
    | ERWBEDARF_6001 | LP_INV3 |
    | AUFTRAG_6001   | LP_INV3 |
And I press button "setzposnr"
And I save the current editor

# Zaehlliste DURCHLAUF pruefen
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "DURCHLAUF"
Then table has values
    | artikel        | platz   | gebeinh | gebf | verw            | projekt     |
    | EKTEIL_6001    | LP_INV1 | Stück   | 1    |                 |             |
    | ERWBEDARF_6001 | LP_INV1 | Stück   | 1    | Sicherheit_6001 | T3ESTP_6001 |
    | ERWBEDARF_6001 | LP_INV1 | Stück   | 1    | VW1_6001        | T2ESTP_6001 |
    | ERWBEDARF_6001 | LP_INV1 | Stück   | 1    | Sicherheit_6001 |             |
    | AUFTRAG_6001   | LP_INV1 | Stück   | 1    | 12345_6001      | T2ESTP_6001 |
    | AUFTRAG_6001   | LP_INV1 | Stück   | 1    | 6789_25_6001    |             |
    | AUFTRAG_6001   | LP_INV1 | Stück   | 1    | 123_6001        |             |
    | AUFTRAG_6001   | LP_INV1 | Stück   | 1    | 12345_6001      |             |
    | PROJEKT_6001   | LP_INV1 | Stück   | 1    |                 | T3ESTP_6001 |
    | PROJEKT_6001   | LP_INV1 | Stück   | 1    |                 | T2ESTP_6001 |
    | PROJEKT_6001   | LP_INV1 | Stück   | 1    |                 | TESTP_6001  |
    | MGELOESCH      | LP_INV1 | Stück   | 1    |                 |             |
    | EKTEIL_6001    | LP_INV3 | Stück   | 1    |                 |             |
    | ERWBEDARF_6001 | LP_INV3 | Stück   | 1    |                 |             |
    | AUFTRAG_6001   | LP_INV3 | Stück   | 1    | 12345_6001      |             |
    | AUFTRAG_6001   | LP_INV3 | Stück   | 1    |                 |             |
And I close the current editor

# Inventur eroeffnen
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "DURCHLAUF" and menu choice "Ja"
And I save the current editor

## Pruefen dass das Inventurkennzeichen in den Platzmengen gesetzt ist
Given I query "artikel,platz,inv" from table "(StorageQuantity):(LocationQuantity)" where "platz==LP_INV1;inv==Z;"
Then query has values
    | artikel        | platz   | inv |
    | EKTEIL_6001    | LP_INV1 |  Z  |
    | ERWBEDARF_6001 | LP_INV1 |  Z  |
    | AUFTRAG_6001   | LP_INV1 |  Z  |
    | PROJEKT_6001   | LP_INV1 |  Z  |
    | MGELOESCH      | LP_INV1 |  Z  |

Given I query "artikel,platz,inv" from table "(StorageQuantity):(LocationQuantity)" where "platz==LP_INV3;inv==Z;"
Then query has values
    | artikel        | platz   | inv |
    | EKTEIL_6001    | LP_INV3 |  Z  |
    | ERWBEDARF_6001 | LP_INV3 |  Z  |
    | AUFTRAG_6001   | LP_INV3 |  Z  |


## Bestand pruefen um mit ibest zu vergleichen
Given I open the infosystem "BESTAND"
And I set field "artikel" to "EKTEIL_6001"
And I set field "klplatz" to "LP_INV1"
And I set field "nullmge" to "nein"
And I press start
And I save value from field "lemge" in row 1
And I close the current editor

Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "DURCHLAUF"
Then field "ibest" in row 1 equals saved value
Then table has values
    | artikel        | platz   | gebeinh | gebf | verw            | projekt     | ibest |
    | EKTEIL_6001    | LP_INV1 | Stück   | 1    |                 |             | 30    |
    | ERWBEDARF_6001 | LP_INV1 | Stück   | 1    | Sicherheit_6001 | T3ESTP_6001 | 12    |
    | ERWBEDARF_6001 | LP_INV1 | Stück   | 1    | VW1_6001        | T2ESTP_6001 | 10    |
    | ERWBEDARF_6001 | LP_INV1 | Stück   | 1    | Sicherheit_6001 |             | 12    |
    | AUFTRAG_6001   | LP_INV1 | Stück   | 1    | 12345_6001      | T2ESTP_6001 | 15    |
    | AUFTRAG_6001   | LP_INV1 | Stück   | 1    | 6789_25_6001    |             | 15    |
    | AUFTRAG_6001   | LP_INV1 | Stück   | 1    | 123_6001        |             | 15    |
    | AUFTRAG_6001   | LP_INV1 | Stück   | 1    | 12345_6001      |             | 25    |
    | PROJEKT_6001   | LP_INV1 | Stück   | 1    |                 | T3ESTP_6001 | 12    |
    | PROJEKT_6001   | LP_INV1 | Stück   | 1    |                 | T2ESTP_6001 | 15    |
    | PROJEKT_6001   | LP_INV1 | Stück   | 1    |                 | TESTP_6001  | 45    |
    | MGELOESCH      | LP_INV1 | Stück   | 1    |                 |             | 10    |
    | EKTEIL_6001    | LP_INV3 | Stück   | 1    |                 |             | 30    |
    | ERWBEDARF_6001 | LP_INV3 | Stück   | 1    |                 |             | 13    |
    | AUFTRAG_6001   | LP_INV3 | Stück   | 1    | 12345_6001      |             | 3     |
    | AUFTRAG_6001   | LP_INV3 | Stück   | 1    |                 |             | 6     |
And I close the current editor


# Artikelstamm oeffnen um Zugriff auf Feld Mischpreis zu haben
Given I open an editor "EKTEIL" from table "(Part):(Product)" with command "VIEW" for record "EKTEIL_6001"
And I close the current editor
Given I open an editor "ERWBEDARF" from table "(Part):(Product)" with command "VIEW" for record "ERWBEDARF_6001"
And I close the current editor
Given I open an editor "AUFTRAG" from table "(Part):(Product)" with command "VIEW" for record "AUFTRAG_6001"
And I close the current editor
Given I open an editor "PROJEKT" from table "(Part):(Product)" with command "VIEW" for record "PROJEKT_6001"
And I close the current editor
Given I open an editor "MGELOESCH" from table "(Part):(Product)" with command "VIEW" for record "MGELOESCH"
And I close the current editor

# Mischpreis aus Artikelstamm mit Mischpreis in Zählliste vergleichen
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "DURCHLAUF"
Then field "impr" in row 1 has value equal to field "mpr" from editor "EKTEIL" in row 0
Then field "impr" in row 2 has value equal to field "mpr" from editor "ERWBEDARF" in row 0
Then field "impr" in row 3 has value equal to field "mpr" from editor "ERWBEDARF" in row 0
Then field "impr" in row 4 has value equal to field "mpr" from editor "ERWBEDARF" in row 0
Then field "impr" in row 5 has value equal to field "mpr" from editor "AUFTRAG" in row 0
Then field "impr" in row 6 has value equal to field "mpr" from editor "AUFTRAG" in row 0
Then field "impr" in row 7 has value equal to field "mpr" from editor "AUFTRAG" in row 0
Then field "impr" in row 8 has value equal to field "mpr" from editor "AUFTRAG" in row 0
Then field "impr" in row 9 has value equal to field "mpr" from editor "PROJEKT" in row 0
Then field "impr" in row 10 has value equal to field "mpr" from editor "PROJEKT" in row 0
Then field "impr" in row 11 has value equal to field "mpr" from editor "PROJEKT" in row 0
Then field "impr" in row 12 has value equal to field "mpr" from editor "MGELOESCH" in row 0
Then field "impr" in row 13 has value equal to field "mpr" from editor "EKTEIL" in row 0
Then field "impr" in row 14 has value equal to field "mpr" from editor "ERWBEDARF" in row 0
Then field "impr" in row 15 has value equal to field "mpr" from editor "AUFTRAG" in row 0
Then field "impr" in row 16 has value equal to field "mpr" from editor "AUFTRAG" in row 0
And I close the current editor

#Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "DURCHLAUF"
#And I press button "ladeinvo"
#Then table has values
#| impr        |
#| !EKTEIL^mpr |
#And I close the current editor

# INVENTORYSHEET Sortierung
Given I open an editor "INV1" from table "(Location):(Location)" with command "VIEW" for record "LP_INV1"
And I close the current editor

Given I open an editor "INV3" from table "(Location):(Location)" with command "VIEW" for record "LP_INV3"
And I close the current editor

Given I open the infosystem "INVENTORYSHEET"
And I set field "zaehllistenr" to "DURCHLAUF"
# Sortierreihenfolge Platzsuchwort und Artikelnummer
And I set field "bplsartn" to "ja"
And I press start
Then the table has 16 rows
Then table has values
    | suchartikel    | numartikel        | tename                   | suchplatz | numplatz     | verw            |
    | EKTEIL_6001    | !EKTEIL^nummer    | Einkaufsteil             | LP_INV1   | !INV1^nummer |                 |
    | ERWBEDARF_6001 | !ERWBEDARF^nummer | Erweitert Bedarfsbezogen | LP_INV1   | !INV1^nummer | Sicherheit_6001 |
    | ERWBEDARF_6001 | !ERWBEDARF^nummer | Erweitert Bedarfsbezogen | LP_INV1   | !INV1^nummer | VW1_6001        |
    | ERWBEDARF_6001 | !ERWBEDARF^nummer | Erweitert Bedarfsbezogen | LP_INV1   | !INV1^nummer | Sicherheit_6001 |
    | AUFTRAG_6001   | !AUFTRAG^nummer   | Auftrag                  | LP_INV1   | !INV1^nummer | 12345_6001      |
    | AUFTRAG_6001   | !AUFTRAG^nummer   | Auftrag                  | LP_INV1   | !INV1^nummer | 6789_25_6001    |
    | AUFTRAG_6001   | !AUFTRAG^nummer   | Auftrag                  | LP_INV1   | !INV1^nummer | 123_6001        |
    | AUFTRAG_6001   | !AUFTRAG^nummer   | Auftrag                  | LP_INV1   | !INV1^nummer | 12345_6001      |
    | PROJEKT_6001   | !PROJEKT^nummer   | Projekt                  | LP_INV1   | !INV1^nummer |                 |
    | PROJEKT_6001   | !PROJEKT^nummer   | Projekt                  | LP_INV1   | !INV1^nummer |                 |
    | PROJEKT_6001   | !PROJEKT^nummer   | Projekt                  | LP_INV1   | !INV1^nummer |                 |
    | MGELOESCH      | !MGELOESCH^nummer | Mengen loeschen          | LP_INV1   | !INV1^nummer |                 |
    | EKTEIL_6001    | !EKTEIL^nummer    | Einkaufsteil             | LP_INV3   | !INV3^nummer |                 |
    | ERWBEDARF_6001 | !ERWBEDARF^nummer | Erweitert Bedarfsbezogen | LP_INV3   | !INV3^nummer |                 |
    | AUFTRAG_6001   | !AUFTRAG^nummer   | Auftrag                  | LP_INV3   | !INV3^nummer | 12345_6001      |
    | AUFTRAG_6001   | !AUFTRAG^nummer   | Auftrag                  | LP_INV3   | !INV3^nummer |                 |
# Sortierreihenfolge Artikelsuchwort und Platzsuchwort
And I set field "bartspls" to "ja"
And I press start
Then table has values
    | suchartikel    | numartikel        | tename                   | suchplatz | numplatz     | verw            |
    | AUFTRAG_6001   | !AUFTRAG^nummer   | Auftrag                  | LP_INV1   | !INV1^nummer | 12345_6001      |
    | AUFTRAG_6001   | !AUFTRAG^nummer   | Auftrag                  | LP_INV1   | !INV1^nummer | 6789_25_6001    |
    | AUFTRAG_6001   | !AUFTRAG^nummer   | Auftrag                  | LP_INV1   | !INV1^nummer | 123_6001        |
    | AUFTRAG_6001   | !AUFTRAG^nummer   | Auftrag                  | LP_INV1   | !INV1^nummer | 12345_6001      |
    | AUFTRAG_6001   | !AUFTRAG^nummer   | Auftrag                  | LP_INV3   | !INV3^nummer | 12345_6001      |
    | AUFTRAG_6001   | !AUFTRAG^nummer   | Auftrag                  | LP_INV3   | !INV3^nummer |                 |
    | EKTEIL_6001    | !EKTEIL^nummer    | Einkaufsteil             | LP_INV1   | !INV1^nummer |                 |
    | EKTEIL_6001    | !EKTEIL^nummer    | Einkaufsteil             | LP_INV3   | !INV3^nummer |                 |
    | ERWBEDARF_6001 | !ERWBEDARF^nummer | Erweitert Bedarfsbezogen | LP_INV1   | !INV1^nummer | Sicherheit_6001 |
    | ERWBEDARF_6001 | !ERWBEDARF^nummer | Erweitert Bedarfsbezogen | LP_INV1   | !INV1^nummer | VW1_6001        |
    | ERWBEDARF_6001 | !ERWBEDARF^nummer | Erweitert Bedarfsbezogen | LP_INV1   | !INV1^nummer | Sicherheit_6001 |
    | ERWBEDARF_6001 | !ERWBEDARF^nummer | Erweitert Bedarfsbezogen | LP_INV3   | !INV3^nummer |                 |
    | MGELOESCH      | !MGELOESCH^nummer | Mengen loeschen          | LP_INV1   | !INV1^nummer |                 |
    | PROJEKT_6001   | !PROJEKT^nummer   | Projekt                  | LP_INV1   | !INV1^nummer |                 |
    | PROJEKT_6001   | !PROJEKT^nummer   | Projekt                  | LP_INV1   | !INV1^nummer |                 |
    | PROJEKT_6001   | !PROJEKT^nummer   | Projekt                  | LP_INV1   | !INV1^nummer |                 |
And I close the current editor


## Bestand des Artikels MGELOESCH, der Mengen loeschen gesetzt hat, per Abgang auf 0 bringen, Platzmenge bleibt erhalten

# Platzmengenelement pruefen, Gebindemenge ist 10
Given I query "artikel,platz,gebmge" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV1;artikel==MGELOESCH"
Then query has values
    | artikel      | platz   | gebmge |
    | MGELOESCH    | LP_INV1 |   10   |

# Auftrag anlegen und liefern, Bestand auf LP_INV1 wird dadurch 0
Given I create a SalesOrder "auftrag01" for Customer "TEST" with Product "MGELOESCH" and quantity "10"
And I deliver the SalesOrder "auftrag01" with PackingSlip "LS01"

# Platzmenge pruefen
Given I query "artikel,platz,gebmge" from table "(StorageQuantity):(LocationQuantity)" where "platz==LP_INV1;artikel==MGELOESCH"
Then query has values
    | artikel      | platz   | gebmge |
    | MGELOESCH    | LP_INV1 |        |

# Platzmengenelement pruefen, kein Treffer
Given I query "artikel,platz,gebmge" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV1;artikel==MGELOESCH"
Then query has no hits


# Buchbestand von MGELOESCH in Zaehlliste bleibt auf 10
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "DURCHLAUF"
Then field "ibest" has value "10" in row 13
And I close the current editor

# Zaehlmengen erfassen, nbest und addmge
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "DURCHLAUF"
Then table has values
    | artikel        | ibest | gebeinh | gebf | verw            | projekt     |
    | AUFTRAG_6001   | 15    | Stück   | 1    | 12345_6001      | T2ESTP_6001 |
    | AUFTRAG_6001   | 15    | Stück   | 1    | 6789_25_6001    |             |
    | AUFTRAG_6001   | 15    | Stück   | 1    | 123_6001        |             |
    | AUFTRAG_6001   | 25    | Stück   | 1    | 12345_6001      |             |
    | AUFTRAG_6001   | 3     | Stück   | 1    | 12345_6001      |             |
    | AUFTRAG_6001   | 6     | Stück   | 1    |                 |             |
    | EKTEIL_6001    | 30    | Stück   | 1    |                 |             |
    | EKTEIL_6001    | 30    | Stück   | 1    |                 |             |
    | ERWBEDARF_6001 | 12    | Stück   | 1    | Sicherheit_6001 | T3ESTP_6001 |
    | ERWBEDARF_6001 | 10    | Stück   | 1    | VW1_6001        | T2ESTP_6001 |
    | ERWBEDARF_6001 | 12    | Stück   | 1    | Sicherheit_6001 |             |
    | ERWBEDARF_6001 | 13    | Stück   | 1    |                 |             |
    | MGELOESCH      | 10    | Stück   | 1    |                 |             |
    | PROJEKT_6001   | 45    | Stück   | 1    |                 | TESTP_6001  |
    | PROJEKT_6001   | 12    | Stück   | 1    |                 | T3ESTP_6001 |
    | PROJEKT_6001   | 15    | Stück   | 1    |                 | T2ESTP_6001 |
And I modify table
    | !row | nbest | addmge |
    |  1   | 10    |   5    |
    |  2   | 16    |   0    |
    |  3   | 16    |  -1    |
    |  4   | 27    |        |
    |  5   |  8    |   1    |
    |  6   |  1    |        |
    |  7   | 20    |   3    |
    |  8   | 28    |   1    |
    |  9   | 12    |        |
    |  10  |  8    |   2    |
    |  11  | 11    |        |
    |  12  | 14    |        |
    |  13  |  0    |        |
    |  14  | 40    |   6    |
    |  15  | 12    |   2    |
    |  16  | 11    |   0    |
# in einer Zeile einen eigenen Preis setzen, um in der Inventurdifferenzliste zu pruefen, dass dieser angezeigt wird
And I set field "bpr" to "9" in row 15
And I save the current editor

# vorlaeufige Inventurdifferenzliste pruefen
And I open the infosystem "STOCKTAKINGDIFF"
And I set field "zlsnr" to "DURCHLAUF"
And I set field "bnurabweichungen" to "nein"
And I press start
And I set field "bnurabweichungen" to "ja"
And I press start
Then table has values
    | tartikel       | tbpr    | preisinfo                | tnbest | tibest  | tmgediffle |
    | AUFTRAG_6001   | 9.8837  | aus Zählliste, vorläufig | 16     | 15      |    1       |
    | AUFTRAG_6001   | 9.8837  | aus Zählliste, vorläufig | 27     | 25      |    2       |
    | AUFTRAG_6001   | 9.8837  | aus Zählliste, vorläufig |  9     |  3      |    6       |
    | AUFTRAG_6001   | 9.8837  | aus Zählliste, vorläufig |  1     |  6      |   -5       |
    | EKTEIL_6001    | 4.4000  | aus Zählliste, vorläufig | 23     | 30      |   -7       |
    | EKTEIL_6001    | 4.4000  | aus Zählliste, vorläufig | 29     | 30      |   -1       |
    | ERWBEDARF_6001 | 4.6735  | aus Zählliste, vorläufig | 11     | 12      |   -1       |
    | ERWBEDARF_6001 | 4.6735  | aus Zählliste, vorläufig | 14     | 13      |    1       |
    | MGELOESCH      | 1.0000  | aus Zählliste, vorläufig | 0      | 10      |  -10       |
    | PROJEKT_6001   | 9.6977  | aus Zählliste, vorläufig | 46     | 45      |    1       |
    | PROJEKT_6001   | 9.0000  | aus Zählliste, vorläufig | 14     | 12      |    2       |
    | PROJEKT_6001   | 9.6977  | aus Zählliste, vorläufig | 11     | 15      |   -4       |
And I set field "abwprozent" to "10"
And I press start
Then table has values
    | tartikel       | tbpr    | preisinfo                | tnbest | tibest  | tmgediffle |
    | AUFTRAG_6001   | 9.8837  | aus Zählliste, vorläufig |  9     |  3      |    6       |
    | AUFTRAG_6001   | 9.8837  | aus Zählliste, vorläufig |  1     |  6      |   -5       |
    | EKTEIL_6001    | 4.4000  | aus Zählliste, vorläufig | 23     | 30      |   -7       |
    | MGELOESCH      | 1.0000  | aus Zählliste, vorläufig | 0      | 10      |  -10       |
    | PROJEKT_6001   | 9.0000  | aus Zählliste, vorläufig | 14     | 12      |    2       |
    | PROJEKT_6001   | 9.6977  | aus Zählliste, vorläufig | 11     | 15      |   -4       |
And I close the current editor

# Bestandskorrektur fuer Artikel EKTEIL_6001
Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set field "artikel" to "EKTEIL_6001"
And I set field "beleg" to "manuellKorr"
And I set field "beldat" to "."
And I set field "platz" to "LP_INV1" in row 1
Then the table has 1 rows
And I set field "mge" to "25" in row 1
And I save the current editor

# Inventurkennzeichen ist jetzt K anstatt Z
Given I query "artikel,platz,inv" from table "(StorageQuantity):(LocationQuantity)" where "platz==LP_INV1;artikel==EKTEIL_6001"
Then query has values
    | artikel      | platz   | inv |
    | EKTEIL_6001  | LP_INV1 |  K  |

# Inventurbestandsabschluss
Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "DURCHLAUF" and menu choice "Ja"
And I save the current editor

# Pruefen dass das Inventurkennzeichen aus den Platzmengen entfernt wurde
Given I query "artikel,platz,inv" from table "(StorageQuantity):(LocationQuantity)" where "platz==LP_INV1;artikel==EKTEIL_6001"
Then query has values
    | artikel        | platz   | inv |
    | EKTEIL_6001    | LP_INV1 |     |

Given I query "artikel,platz,inv" from table "(StorageQuantity):(LocationQuantity)" where "platz==LP_INV1;artikel==ERWBEDARF_6001"
Then query has values
    | artikel        | platz   | inv |
    | ERWBEDARF_6001 | LP_INV1 |     |

Given I query "artikel,platz,inv" from table "(StorageQuantity):(LocationQuantity)" where "platz==LP_INV1;artikel==AUFTRAG_6001"
Then query has values
    | artikel       | platz   | inv |
    | AUFTRAG_6001  | LP_INV1 |     |

Given I query "artikel,platz,inv" from table "(StorageQuantity):(LocationQuantity)" where "platz==LP_INV1;artikel==PROJEKT_6001"
Then query has values
    | artikel       | platz   | inv |
    | PROJEKT_6001  | LP_INV1 |     |

Given I query "artikel,platz,inv" from table "(StorageQuantity):(LocationQuantity)" where "platz==LP_INV1;artikel==MGELOESCH"
Then query has values
    | artikel       | platz   | inv |
    | MGELOESCH     | LP_INV1 |     |


# LJ beachten dass EKTEIL_6001 keine Korrektur durch Inventur hat, nur die manuelle Korrektur
# MGELOESCH hat auch Inventurkorrektur zusaetzlich zum Abgang

# Lagerjournal EKTEIL_6001 pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "artikel" to "EKTEIL_6001"
And I set field "lplatz" to "LP_INV1"
And I set field "richtung" to "rückwärts"
And I press start
Then table has values
    | kmge | mei   | ursache  | detursache                       |
    |      | Stück | Inventur | Bestandskorrektur durch Inventur |
    |  -5  | Stück | erfasst  | Manuelle Bestandskorrektur       |
 # Lagerjournal MGELOESCH pruefen
And I set field "artikel" to "MGELOESCH"
And I press start
Then table has values
    | amge    | kmge  | mei   | ursache         | detursache                       |
    |         | -10   | Stück | Inventur        | Bestandskorrektur durch Inventur |
    |  10     |       | Stück | Lieferschein    | Lieferschein Verkauf             |
# Lagerjournal EKTEIL_6001 pruefen, nur Inventur
And I set field "artikel" to "EKTEIL_6001"
And I set field "lplatz" to "LP_INV3"
And I set field "kursache" to "Inventur"
And I press start
Then table has values
    | kmge | mei   | ursache  | detursache                       |
    |  -1  | Stück | Inventur | Bestandskorrektur durch Inventur |
And I set field "artikel" to "AUFTRAG_6001"
And I set field "lplatz" to "LP_INV1"
And I press start
Then table has values
    | kmge | mei   | verw         | projekt     |
    |  2   | Stück | 12345_6001   |             |
    |      | Stück | 123_6001     |             |
    |  1   | Stück | 6789_25_6001 |             |
    |      | Stück | 12345_6001   | T2ESTP_6001 |
And I set field "lplatz" to "LP_INV3"
And I press start
Then table has values
    | kmge | mei   | verw          | projekt    |
    |  -5  | Stück |               |            |
    |  6   | Stück | 12345_6001    |            |
# Lagerjournal PROJEKT_6001 pruefen
And I set field "artikel" to "PROJEKT_6001"
And I set field "lplatz" to "LP_INV1"
And I press start
Then table has values
    | kmge | mei   | projekt     |
    |  -4  | Stück | T2ESTP_6001 |
    |   2  | Stück | T3ESTP_6001 |
    |   1  | Stück | TESTP_6001  |
# Lagerjournal ERWBEDARF_6001 pruefen
And I set field "artikel" to "ERWBEDARF_6001"
And I press start
Then table has values
    | kmge | mei   | verw            | projekt     |
    |  -1  | Stück | Sicherheit_6001 |             |
    |      | Stück | VW1_6001        | T2ESTP_6001 |
    |      | Stück | Sicherheit_6001 | T3ESTP_6001 |

And I set field "lplatz" to "LP_INV3"
And I press start
Then table has values
    | kmge | mei   | verw            | projekt     |
    |   1  | Stück |                 |             |
And I close the current editor


# Platzmengenelemente pruefen, Gebindemenge, Verwendung und Charge, pro Artikel und PLatz
Given I query "artikel,platz,gebmge,verw,projekt" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV1;artikel==AUFTRAG_6001;@sort=Artikel_Platz_Auspraegung_Elemente"
Then query has values
    | artikel      | platz   | gebmge | verw            | projekt        |
    | AUFTRAG_6001 | LP_INV1 |   25   | 12345_6001      |                |
    | AUFTRAG_6001 | LP_INV1 |    2   | 12345_6001      |                |
    | AUFTRAG_6001 | LP_INV1 |   15   | 123_6001        |                |
    | AUFTRAG_6001 | LP_INV1 |   15   | 6789_25_6001    |                |
    | AUFTRAG_6001 | LP_INV1 |    1   | 6789_25_6001    |                |
    | AUFTRAG_6001 | LP_INV1 |   15   | 12345_6001      | T2ESTP_6001    |

Given I query "artikel,platz,gebmge,verw,projekt" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV3;artikel==AUFTRAG_6001;@sort=Artikel_Platz_Auspraegung_Elemente"
Then query has values
    | artikel      | platz   | gebmge | verw       | projekt        |
    | AUFTRAG_6001 | LP_INV3 |    1   |            |                |
    | AUFTRAG_6001 | LP_INV3 |    3   | 12345_6001 |                |
    | AUFTRAG_6001 | LP_INV3 |    6   | 12345_6001 |                |

Given I query "artikel,platz,gebmge,verw,projekt" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV1;artikel==ERWBEDARF_6001;@sort=Artikel_Platz_Auspraegung_Elemente"
Then query has values
    | artikel        | platz   | gebmge | verw              | projekt        |
    | ERWBEDARF_6001 | LP_INV1 |   11   | Sicherheit_6001   |                |
    | ERWBEDARF_6001 | LP_INV1 |   10   | VW1_6001          | T2ESTP_6001    |
    | ERWBEDARF_6001 | LP_INV1 |   12   | Sicherheit_6001   | T3ESTP_6001    |

Given I query "artikel,platz,gebmge,verw,projekt" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV3;artikel==ERWBEDARF_6001;@sort=Artikel_Platz_Auspraegung_Elemente"
Then query has values
    | artikel        | platz   | gebmge | verw  | projekt    |
    | ERWBEDARF_6001 | LP_INV3 |   5    |       |            |
    | ERWBEDARF_6001 | LP_INV3 |   8    |       |            |
    | ERWBEDARF_6001 | LP_INV3 |   1    |       |            |


Given I query "artikel,platz,gebmge,verw,projekt" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV1;artikel==PROJEKT_6001;@sort=Artikel_Platz_Auspraegung_Elemente"
Then query has values
    | artikel      | platz   | gebmge | verw    | projekt       |
    | PROJEKT_6001 | LP_INV1 |   9    |         | TESTP_6001    |
    | PROJEKT_6001 | LP_INV1 |   15   |         | TESTP_6001    |
    | PROJEKT_6001 | LP_INV1 |   9    |         | TESTP_6001    |
    | PROJEKT_6001 | LP_INV1 |   9    |         | TESTP_6001    |
    | PROJEKT_6001 | LP_INV1 |   3    |         | TESTP_6001    |
    | PROJEKT_6001 | LP_INV1 |   1    |         | TESTP_6001    |
    | PROJEKT_6001 | LP_INV1 |   11   |         | T2ESTP_6001   |
    | PROJEKT_6001 | LP_INV1 |   12   |         | T3ESTP_6001   |
    | PROJEKT_6001 | LP_INV1 |   2    |         | T3ESTP_6001   |


Given I query "artikel,platz,gebmge" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV1;artikel==EKTEIL_6001;@sort=Artikel_Platz_Auspraegung_Elemente"
Then query has values
    | artikel      | platz   | gebmge |
    | EKTEIL_6001  | LP_INV1 |   10   |
    | EKTEIL_6001  | LP_INV1 |   15   |

Given I query "artikel,platz,gebmge" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV3;artikel==EKTEIL_6001;@sort=Artikel_Platz_Auspraegung_Elemente"
Then query has values
    | artikel      | platz   | gebmge |
    | EKTEIL_6001  | LP_INV3 |   14   |
    | EKTEIL_6001  | LP_INV3 |    5   |
    | EKTEIL_6001  | LP_INV3 |   10   |


Given I query "artikel,platz,gebmge" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==LP_INV1;artikel==MGELOESCH;@sort=Artikel_Platz_Auspraegung_Elemente"
Then query has values
    | artikel      | platz   | gebmge |
    | MGELOESCH    | LP_INV1 |  -10   |

# aktuelle Inventurdifferenzliste pruefen
And I open the infosystem "STOCKTAKINGDIFF"
And I set field "zlsnr" to "DURCHLAUF"
Then field "preisauszl" has value "nein"
And I set field "bnurabweichungen" to "nein"
And I press start
And I set field "bnurabweichungen" to "ja"
And I press start
Then table has values
    | tartikel       |  tbpr    | preisinfo      | tnbest | tibest  | tmgediffle |
    | AUFTRAG_6001   |  9.8800  | aus Bewertung  | 16     | 15      |    1       |
    | AUFTRAG_6001   |  9.8850  | aus Bewertung  | 27     | 25      |    2       |
    | AUFTRAG_6001   |  9.8833  | aus Bewertung  |  9     |  3      |    6       |
    | AUFTRAG_6001   |  9.8820  | aus Bewertung  |  1     |  6      |   -5       |
    | EKTEIL_6001    |  4.4000  | aus Bewertung  | 29     | 30      |   -1       |
    | ERWBEDARF_6001 |  4.6700  | aus Bewertung  | 11     | 12      |   -1       |
    | ERWBEDARF_6001 |  4.6700  | aus Bewertung  | 14     | 13      |    1       |
    | MGELOESCH      |  1.0000  | aus Bewertung  | 0      | 10      |  -10       |
    | PROJEKT_6001   |  9.7000  | aus Bewertung  | 46     | 45      |    1       |
    | PROJEKT_6001   |  9.7000  | aus Bewertung  | 14     | 12      |    2       |
    | PROJEKT_6001   |  9.6975  | aus Bewertung  | 11     | 15      |   -4       |
And I set field "abwprozent" to "10"
And I press start
Then table has values
    | tartikel       |  tbpr    | preisinfo      | tnbest | tibest  | tmgediffle |
    | AUFTRAG_6001   |  9.8833  | aus Bewertung  |  9     |  3      |    6       |
    | AUFTRAG_6001   |  9.8820  | aus Bewertung  |  1     |  6      |   -5       |
    | MGELOESCH      |  1.0000  | aus Bewertung  |  0     | 10      |  -10       |
    | PROJEKT_6001   |  9.7000  | aus Bewertung  | 14     | 12      |    2       |
    | PROJEKT_6001   |  9.6975  | aus Bewertung  | 11     | 15      |   -4       |
And I close the current editor
# Anmerkung: EKTEIL_6001 auf LP_INV1 wurde NICHT durch Inventur gebucht, die Zeile erscheint deshalb nicht in der Differenzliste

Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "DURCHLAUF"
# in einer Zeile einen eigenen Preis setzen, um in der Inventurdifferenzliste zu pruefen, dass dieser angezeigt wird wird
And I set field "bpr" to "9" in row 15
And I save the current editor

And I open the infosystem "STOCKTAKINGDIFF"
And I set field "zlsnr" to "DURCHLAUF"
Then field "preisauszl" has value "nein"
And I set field "bnurabweichungen" to "ja"
And I press start
Then table has values
    | tartikel       |  tbpr    | preisinfo      | tnbest | tibest  | tmgediffle |
    | AUFTRAG_6001   |  9.8800  | aus Bewertung  | 16     | 15      |    1       |
    | AUFTRAG_6001   |  9.8850  | aus Bewertung  | 27     | 25      |    2       |
    | AUFTRAG_6001   |  9.8833  | aus Bewertung  |  9     |  3      |    6       |
    | AUFTRAG_6001   |  9.8820  | aus Bewertung  |  1     |  6      |   -5       |
    | EKTEIL_6001    |  4.4000  | aus Bewertung  | 29     | 30      |   -1       |
    | ERWBEDARF_6001 |  4.6700  | aus Bewertung  | 11     | 12      |   -1       |
    | ERWBEDARF_6001 |  4.6700  | aus Bewertung  | 14     | 13      |    1       |
    | MGELOESCH      |  1.0000  | aus Bewertung  | 0      | 10      |  -10       |
    | PROJEKT_6001   |  9.7000  | aus Bewertung  | 46     | 45      |    1       |
    | PROJEKT_6001   |  9.7000  | aus Bewertung  | 14     | 12      |    2       |
    | PROJEKT_6001   |  9.6975  | aus Bewertung  | 11     | 15      |   -4       |
And I set field "preisauszl" to "ja"
# tbpr ist dann der Mischpreis
And I press start
Then table has values
    | tartikel       | preisinfo     |
    | AUFTRAG_6001   | aus Zählliste |
    | AUFTRAG_6001   | aus Zählliste |
    | AUFTRAG_6001   | aus Zählliste |
    | AUFTRAG_6001   | aus Zählliste |
    | EKTEIL_6001    | aus Zählliste |
    | ERWBEDARF_6001 | aus Zählliste |
    | ERWBEDARF_6001 | aus Zählliste |
    | MGELOESCH      | aus Zählliste |
    | PROJEKT_6001   | aus Zählliste |
    | PROJEKT_6001   | aus Zählliste |
    | PROJEKT_6001   | aus Zählliste |
# Feld "Preis aus Zaehlliste" ist angehakt, tbpr ist dann der Mischpreis
# Editor fuer den jeweiligen Artikelstamm wird weiter oben schon geoeffnet, um Zugriff auf das Feld mpr zu haben
Then field "tbpr" in row 1 has value equal to field "mpr" from editor "AUFTRAG" in row 0
Then field "tbpr" in row 2 has value equal to field "mpr" from editor "AUFTRAG" in row 0
Then field "tbpr" in row 3 has value equal to field "mpr" from editor "AUFTRAG" in row 0
Then field "tbpr" in row 4 has value equal to field "mpr" from editor "AUFTRAG" in row 0
Then field "tbpr" in row 5 has value equal to field "mpr" from editor "EKTEIL" in row 0
Then field "tbpr" in row 6 has value equal to field "mpr" from editor "ERWBEDARF" in row 0
Then field "tbpr" in row 7 has value equal to field "mpr" from editor "ERWBEDARF" in row 0
Then field "tbpr" in row 8 has value equal to field "mpr" from editor "MGELOESCH" in row 0
Then field "tbpr" in row 9 has value equal to field "mpr" from editor "PROJEKT" in row 0
# fuer diese Zeile wurde in der Zaehlliste ein eigener Preis gesetzt
Then field "tbpr" has value "9.0000" in row 10
Then field "tbpr" in row 11 has value equal to field "mpr" from editor "PROJEKT" in row 0
And I close the current editor

# Inventurabschluss
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "DURCHLAUF" and menu choice "Ja"
And I save the current editor

#################################################################################################################
########### Scenario 05 Inventurzentrale testen - kompletter Durchlauf ueber die entsprechenden Button ##########
### Zaehlliste eroeffnen, Zaehlmengen erfassen, Bestandsabschluss, Inventurabschluss, Zaehlliste ist abgelegt ###

Scenario: 05 Infosystem INVSHEETCENTER Inventurzentrale

# in der Inventurzentrale alle Schritte ueber die Button durchfuehren

#Zaehlliste erstellen
Given I open the infosystem "INVSHEETCENTER"
And I press button "buneu" to open a subeditor for "Zaehlliste"
And I set field "such" to "CENTER"
And I append rows
    | artikel        | platz   |
    | AUFTRAG_6001   | LP_INV2 |
    | ERWBEDARF_6001 | LP_INV2 |
And I save the current subeditor to switch back to the parent editor
#Zaehlliste in Inventurzentrale laden
And I set field "zaehllistevon" to "CENTER"
And I set field "zaehllistebis" to "CENTER"
And I press start
Then the table has 1 rows
And I press button "bueroeffnen" in row 1
And I close the current editor

# Zaehlliste im Aendern-Modus oeffnen
Given I open an editor "Zaehlliste_Center" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "CENTER"
And I set field "nbest" to "3" in row 1
And I set field "nbest" to "6" in row 2
And I save the current editor

# Infosystem INVSHEETCENTER wieder oeffnen
Given I open the infosystem "INVSHEETCENTER"
And I set field "zaehllistevon" to "CENTER"
And I set field "zaehllistebis" to "CENTER"
And I press start
Then the table has 1 rows
Then field "bend" has value "nein" in row 1
And I respond with answer "nein" to the dialog with id "Inventurbestandsabschluss durchführen?"
And I press button "bubestandsab" in row 1
# Bestandsabschluss ist nicht erfolgt, Feld bend auf nein
Then field "bend" has value "nein" in row 1
And I respond with answer "ja" to the dialog with id "Inventurbestandsabschluss durchführen?"
And I press button "bubestandsab" in row 1
# Bestandsabschluss erfolgt, Feld bend auf ja
Then field "bend" has value "ja" in row 1
And I press button "buabschliessen" in row 1
Then the table has 0 rows
And I close the current editor
# abgeschlossene Zaehlliste im Zeigen-Modus oeffnen
Given I open an editor "Zaehlliste_Center" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for search criteria "$,,such=CENTER;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
Then field "abschluss" has value "ja"
And I close the current editor


Scenario: 06 Infosystem INVSHEETCENTER Inventurzentrale - Aktionen durchfuehren fuer mehrere Zaehllisten gleichzeitig

# Zaehlliste erstellen
Given I open an editor "Zaehlliste_Center" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "CENTER1"
And I append rows
    | artikel        | platz   |
    | ERWBEDARF_6001 | LP_INV1 |
And I save the current editor

Given I open an editor "Zaehlliste_Center" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "CENTER2"
And I append rows
    | artikel        | platz   |
    | ERWBEDARF_6001 | LP_INV2 |
And I save the current editor

Given I open an editor "Zaehlliste_Center" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "CENTER3"
And I append rows
    | artikel        | platz   |
    | ERWBEDARF_6001 | LP_INV3 |
And I save the current editor

Given I open an editor "Zaehlliste_Center" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "CENTER4"
And I append rows
    | artikel        | platz   |
    | AUFTRAG_6001   | LP_INV2 |
And I save the current editor

# in der Inventurzentrale alle Schritte ueber die Button durchfuehren
Given I open the infosystem "INVSHEETCENTER"
And I set field "zaehllistevon" to "CENTER1"
And I set field "zaehllistebis" to "CENTER4"
And I press start
Then the table has 4 rows
And I set field "tauswahl" to "ja" in row 3
Then field "event" has value "Inventureröffnung"
And I set field "tauswahl" to "nein" in row 3
Then field "event" is empty
And I press button "allean"
Then field "event" has value "Inventureröffnung"
Then field "tauswahl" has value "ja" in all rows
And I press button "alleab"
Then field "tauswahl" has value "nein" in all rows
And I set field "tauswahl" to "ja" in row 2
And I set field "tauswahl" to "ja" in row 3
And I press button "durchfuehren"
Then table has values
    | bueroeffnen   |
    | icon:process  |
    | icon:ok       |
    | icon:ok       |
    | icon:process  |
And I press button "allean"
# wenn keine Auswahl gemacht wurde, werden Zeilen mit dem fruehesten Event ausgewaehlt
Then field "event" has value "Inventureröffnung"
Then table has values
    | tauswahl  |
    | ja        |
    | nein      |
    | nein      |
    | ja        |
And I press button "alleab"
And I set field "tauswahl" to "ja" in row 3
Then field "event" has value "Bestandsabschluss"
Then fields in table are modifiable
    | tauswahl  |
    | nein      |
    | ja        |
    | ja        |
    | nein      |
And I press button "allean"
Then table has values
    | tauswahl  |
    | nein      |
    | ja        |
    | ja        |
    | nein      |
And I set field "tauswahl" to "nein" in row 2
And I respond with answer "ja" to the dialog with id "Inventurbestandsabschluss durchführen?"
And I respond with answer "ja" to the dialog with id "Es wurden keine Zählmengen erfasst, trotzdem Bestandsabschluss durchführen?"
And I press button "durchfuehren"
Then table has values
    | bueroeffnen   | bubestandsab  |
    | icon:process  | icon:flash    |
    | icon:ok       | icon:flash    |
    | icon:ok       | icon:ok       |
    | icon:process  | icon:flash    |
And I set field "tauswahl" to "ja" in row 3
Then field "event" has value "Inventurabschluss"
And I press button "durchfuehren"
Then the table has 3 rows
Then table has values
    | bueroeffnen   | bubestandsab  |
    | icon:process  | icon:flash    |
    | icon:ok       | icon:flash    |
    | icon:process  | icon:flash    |
And I close the current editor

Given I'm logged in with password "adm"

Given I open an editor "CENTER1" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "CENTER1"
# offen lassen, damit Datensatz belegt ist in der Inventurzentrale

Given I'm logged in with password "sy"
Given I open the infosystem "INVSHEETCENTER"
And I set field "zaehllistevon" to "CENTER1"
And I set field "zaehllistebis" to "CENTER4"
And I press start
And I set field "tauswahl" to "ja" in row 1
And I set field "tauswahl" to "ja" in row 3
And I press button "durchfuehren"
# Fehlermeldung erscheint "Fehler bei der Bearbeitung der Zählliste 10" kann aber nicht abgefragt werden, da kein Abbruch
# Aktion wird durchgefuehrt, fuer die Zaehllisten, die nicht gesperrt sind
Then the table has 3 rows
Then table has values
    | bueroeffnen   | bubestandsab  |
    | icon:process  | icon:flash    |
    | icon:ok       | icon:flash    |
    | icon:ok       | icon:flash    |
And I close the current editor

Given I'm logged in with password "adm"
And I switch the current editor to editor "CENTER1" with command "UPDATE"
And I close the current editor

Given I'm logged in with password "sy"

# bei abgelegten Zaehllisten kann das Feld "Auswahl" nicht angehakt werden
Given I open the infosystem "INVSHEETCENTER"
And I set field "zaehllistevon" to "CENTER1"
And I set field "zaehllistebis" to "CENTER4"
And I set field "ablage" to "abgelegt"
And I press start
Then the table has 1 rows
Then field "tauswahl" is not modifiable in row 1
And I close the current editor

