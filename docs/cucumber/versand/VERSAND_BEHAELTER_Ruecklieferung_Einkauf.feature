# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Ruecklieferung_Einkauf.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Ruecklieferungen im Einkauf mit Behaeltern
#  ref              : ref_behaelter_rueckliefern_cu
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Ruecklieferung_Einkauf.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Ruecklieferung, ein Artikel

And I create a Container "behaelter_01ek" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "5" on StorageLocation "F1" with document "L01-ZU" and Container "behaelter_01ek"

Given I open an editor "EKLS_01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS_01   |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | RAD       | 15    |
    | KLINGEL   | 5     |
And I save the current editor

Then field "bhbuchung^mge" has value "0" in row 1
Then field "bhbuchung^buart" is empty in row 1

Given I open an editor "EKRLS_01" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EKLS_01"
And I set fields
    | ebeleg    | EK-EKRLS_01 |
    | vom       | .           |
    | ueb       | ja          |
And I modify table
    | !row  | mge   | behaelter              |
    | 1     | -5    | !behaelter_01ek^nummer |
And I save the current editor

And I switch the current editor to editor "behaelter_01ek"
Then the table has 0 rows
Then field "kl^such" is empty
Then field "behstatusaz" has value "Rücklieferung"
And I close the current editor


Scenario: 02 Ruecklieferung, ein Artikel, durch Lieferschein erstellten Behaelter PROZESS

Given I open an editor "EKLS_02" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS_02p  |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | exbehnum              | packm |
    | RAD       | 5     | RUECKLIEF_EIN_ART_K6  | KLT   |
And I save the current editor

Given I open an editor "EKRLS_02" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EKLS_02"
And I set fields
    | ebeleg    | EK-Lieferschein_02 RUECK  |
    | vom       | .                         |
    | ueb       | ja                        |
And I modify table
    | !row  | mge   | behaelter             |
    | 1     | -5    | RUECKLIEF_EIN_ART_K6  |
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1

Given I open an editor "behaelter_02ek" from table "(Container):(ContainerShell)" with command "VIEW" for record "RUECKLIEF_EIN_ART_K6"
Then the table has 0 rows
Then field "kl^such" has value "KETTLER"
Then field "behstatusaz" has value "Rücklieferung"
And I close the current editor


Scenario: 03 Ruecklieferung mehrere Artikel aus einem Behaelter, Charge

And I create a Container "behaelter_03ek" for packaging material "KLT"
And I create a Lot "EK_SATTEL_03" for Product "SATTEL"
And I create a Lot "EK_PEDALE_03" for Product "PEDALE"

Scenario Outline: 03 Lagerbuchung fuer Ruecklieferung, ein Artikel, bestehender Behaelter
Given I open an editor "<Leditor>" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | <artikel>     |
    | buart     | Zugang        |
    | beleg     | LZU3          |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | behaelter                | charge2   |
    | <mge>  | !behaelter_03ek^nummer   | <charge>  |
And I save the current editor

Examples: Lagerbuchungen
| Leditor          | artikel | mge | charge       |
| Lagerbuchung03_1 | SATTEL  | 5   | EK_SATTEL_03 |
| Lagerbuchung03_2 | RAD     | 10  |              |
| Lagerbuchung03_3 | PEDALE  | 10  | EK_PEDALE_03 |

Scenario: 03 Einkaufslieferschein, Ruecklieferung mehrere Artikel aus einem Behaelter, Charge

Given I open an editor "EKLS_03" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS_03   |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel | mge   | charge       |
    | SATTEL  | 10    | EK_SATTEL_03 |
    | RAD     | 20    | !dontChange  |
    | PEDALE  | 15    | EK_PEDALE_03 |
And I save the current editor

Then table has values
    | bhbuchung^mge | bhbuchung^buart   |
    | 0             |                   |
    | 0             |                   |
And I close the current editor

Given I open an editor "EKRLS_03" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EKLS_03"
And I set fields
    | vom       | .         |
    | ebeleg    | EKRLS_03  |
    | ueb       | ja        |
And I modify table
    | !row              | mge | behaelter          |
    | artikel=='SATTEL' | -5  | !behaelter_03ek^id |
    | artikel=='RAD'    | -10 | !behaelter_03ek^id |
    | artikel=='PEDALE' | -10 | !behaelter_03ek^id |
And I save the current editor

And I switch the current editor to editor "behaelter_03ek" with command "VIEW"
Then the table has 0 rows
Then field "behstatusaz" has value "Rücklieferung"
And I close the current editor


Scenario: 04 Ruecklieferung aus mehreren Behaeltern

And I create a Container "behaelter_04ek_1" for packaging material "KLT"
And I create a Container "behaelter_04ek_2" for packaging material "KLT"
And I create a Container "behaelter_04ek_3" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "5" on StorageLocation "F1" with document "L04-ZU" and Container "behaelter_04ek_1"
And I post a receipt via ManualStockAdjustment for Product "RAHMEN" and quantity "10" on StorageLocation "F1" with document "L04-ZU" and Container "behaelter_04ek_2"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "10" on StorageLocation "F1" with document "L04-ZU" and Container "behaelter_04ek_3"

# Einkaufslieferschein, Ruecklieferung aus mehreren Behaeltern
Given I open an editor "EKLS_04" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER   |
    | vom       | .         |
    | ebeleg    | EKLS_04   |
    | ueb       | ja        |
And I delete all rows
And I append rows
    | artikel | mge |
    | RAD     | 10  |
    | RAHMEN  | 20  |
    | RAD     | 15  |
And I save the current editor

Then table has values
    | bhbuchung^mge | bhbuchung^buart   |
    | 0             |                   |
    | 0             |                   |
And I close the current editor

Given I open an editor "ekls_rueck_04" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EKLS_04"
And I set fields
    | vom       | .            |
    | ebeleg    | EK_Rueck_04  |
    | ueb       | ja           |
And I modify table
    | !row | mge | behaelter            |
    | 1    | -5  | !behaelter_04ek_1^id |
    | 2    | -10 | !behaelter_04ek_2^id |
    | 3    | -10 | !behaelter_04ek_3^id |
And I save the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                     |
    | beleg         | !ekls_rueck_04^nummer |
And I press start
Then the table has 3 rows
And I close the current editor

Scenario Outline: 04 Behaelter pruefen
And I switch the current editor to editor "<BEHrecord>" with command "VIEW"
Then the table has 0 rows
Then field "behstatusaz" has value "Rücklieferung"
And I close the current editor

Examples: Behaelter
| BEHrecord        |
| behaelter_04ek_1 |
| behaelter_04ek_2 |
| behaelter_04ek_3 |


Scenario: 05 Ruecklieferung, versch. Artikel, manuelle und berechnete Packmittel

And I create a Container "behaelter_05ek_1" for packaging material "KLT"
And I create a Container "behaelter_05ek_2" for packaging material "KLT"
And I create a Container "behaelter_05ek_3" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "5" on StorageLocation "F1" with document "L05-ZU" and Container "behaelter_05ek_1"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "5" on StorageLocation "F1" with document "L05-ZU" and Container "behaelter_05ek_2"
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "5" on StorageLocation "F1" with document "L05-ZU" and Container "behaelter_05ek_3"

# Lieferschein, Ruecklieferung, versch. Artikel, manuelle und berechnete Packmittel
Given I open an editor "EKLS_05" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | EKLS_05 |
    | ueb    | JA      |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | RAD       | 10    |
    | SATTEL    | 20    |
    | PEDALE    | 15    |
And I save the current editor

Given I open an editor "ekls_rueck_05" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EKLS_05"
And I set fields
    | vom    | .            |
    | ebeleg | EK-Rueck_05  |
    | ueb    | JA           |
And I modify table
    | !row              | mge | behaelter            |
    | artikel=='RAD'    | -5  | !behaelter_05ek_1^id |
    | artikel=='SATTEL' | -5  | !behaelter_05ek_2^id |
    | artikel=='PEDALE' | -5  | !behaelter_05ek_3^id |
Then field "packanw" is not empty in row 1
# 551 de      |Feld ist nicht änderbar
And pressing button "packvor" throws the exception "551"
And I press button "pmneu" in row !lastRow
And I create a new row at the end of the table
# 313 de      |Für Rücklieferungen dürfen nur Zusatzpositionen und Dienstleistungen neu erfasst werden.
And setting field "artikel" to "KLT" in row !lastRow throws the exception "313"
And I delete row at position 4
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1

Scenario Outline: 05 Behaelter pruefen
Given I open an editor "<BEHeditor>" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "<BEHeditor>"
Then the table has 0 rows
Then field "behstatusaz" has value "Rücklieferung"
And I close the current editor

Examples: Behaelter
| BEHeditor        |
| behaelter_05ek_1 |
| behaelter_05ek_2 |
| behaelter_05ek_3 |


Scenario: 06 Ruecksendung mehrere Artikel in mehreren Behaeltern

And I create a Container "behaelter_06ek_1" for packaging material "KLT"
And I create a Container "behaelter_06ek_2" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "1" on StorageLocation "F1" with document "L06-ZU" and Container "behaelter_06ek_1"
And I post a receipt via ManualStockAdjustment for Product "KLINGEL" and quantity "1" on StorageLocation "F1" with document "L06-ZU" and Container "behaelter_06ek_2"

Given I open an editor "RechnungmL06" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | RE_06   |
    | ueb    | JA      |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | SATTEL    | 8     |
    | KLINGEL   | 5     |
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Ruecklieferung06" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RechnungmL06"
And I set fields
    | vom    | .            |
    | ebeleg | RE_Rueck_06  |
    | ueb    | JA           |
And I modify table
    | !row   | mge | behaelter            |
    | 1      | -1  | !behaelter_06ek_1^id |
    | 2      | -1  | !behaelter_06ek_2^id |
And I save the current editor

# 6.3. Lisa, Ruecklieferung erzeugt keinen Behaelterabgang auf dem Konto, VERSAND-836
#Then field "bhbuchung^mge" has value "1" in row 1
#Then field "bhbuchung^buart" has value "Abgang" in row 1
#Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1
#Then field "bhbuchung^mge" has value "1" in row 2
#Then field "bhbuchung^buart" has value "Abgang" in row 2

Scenario Outline: 06 Behaelter pruefen
Given I open an editor "<BEHeditor>" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "<BEHeditor>"
Then the table has 0 rows
Then field "behstatusaz" has value "Rücklieferung"
And I close the current editor

Examples: Behaelter
| BEHeditor        |
| behaelter_06ek_1 |
| behaelter_06ek_2 |


Scenario: 07 Ruecklieferung mit Charge Rechnung mL

And I create a Container "behaelter_07ek" for packaging material "KLT"

And I create a Lot "CH_EK_07" for Product "SATTEL"

Given I open an editor "Rechnung_mL07" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | vom    | .        |
    | ebeleg | RE_07    |
    | ueb    | JA       |
And I delete all rows
And I append rows
    | artikel | mge | charge       | !dialogId                                     | !dialogAnswer | exbehnum               |
    | SATTEL  | 5   | !CH_EK_07^id | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_07ek^nummer |
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Then field "bhbuchung^mge" has value "1" in row 1
# Then field "bhbuchung^buart" has value "Zugang" in row 1
# Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1

And I open an editor "behaelter_07ek" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_07ek"
Then the table has 1 rows
Then field "charge^such" has value "CH_EK_07" in row 1
And I save the current editor

Given I open an editor "Rechnung_mL07R" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "Rechnung_mL07"
And I set fields
    | vom    | .       |
    | ebeleg | RE_R07  |
    | ueb    | JA      |
And I modify table
    | !row   | mge | behaelter              |
    | 1      | -5  | !behaelter_07ek^nummer |
And I save the current editor

# Then field "bhbuchung^mge" has value "1" in row 1
# Then field "bhbuchung^buart" has value "Abgang" in row 1
# Then field "bhbuchung^bhkto^such" has value "KNTKETTLER" in row 1

And I open an editor "behaelter_07ek" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_07ek"
Then the table has 0 rows
Then fields have values
    | behstatusaz   | Rücklieferung |
    | behleer       | nein          |
And I close the current editor


Scenario: 08 Ruecklieferung mit und ohne Charge Rechnung mL

And I create a Container "behaelter_08ek" for packaging material "KLT"

And I create a Lot "CH_EK_081" for Product "SATTEL"
And I create a Lot "CH_EK_082" for Product "RAD"

Given I open an editor "Rechnung_mL08" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER  |
    | vom    | .        |
    | ebeleg | RE_08    |
    | ueb    | JA       |
And I delete all rows
And I append rows
    | artikel   | mge   | !dialogId                                     | !dialogAnswer | exbehnum               | charge        |
    | SATTEL    | 5     | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_08ek^nummer | !CH_EK_081^id |
    | SATTEL    | 5     | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_08ek^nummer | !dontChange   |
    | RAD       | 5     | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_08ek^nummer | !CH_EK_082^id |
    | RAD       | 5     | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_08ek^nummer | !CH_EK_082^id |
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

Then field "bhbuchung" has value "15" in row 1
Then field "bhbuchung" is empty in row 2

And I open an editor "behaelter_08ek" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_08ek"
Then the table has 3 rows
Then table has values
    | exnum     |
    | CH_EK_082 |
    |           |
    | CH_EK_081 |
And I close the current editor

Given I open an editor "Ruecklieferung08" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "Rechnung_mL08"
And I set fields
    | vom    | .        |
    | ebeleg | RE_R08   |
    | ueb    | JA       |
And I modify table
    | !row | mge | behaelter          |
    | 1    | -5  | !behaelter_08ek^id |
    | 2    | -5  | !behaelter_08ek^id |
    | 3    | -5  | !behaelter_08ek^id |
    | 4    | -5  | !behaelter_08ek^id |
And I save the current editor

Then table has values
    | bhbuchung^mge | bhbuchung^buart   | bhbuchung^bhkto^such  |
    | 1             | Abgang            | KNTKETTLER            |
And I close the current editor

And I open an editor "behaelter_08ek" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_08ek"
Then the table has 0 rows
Then field "behstatusaz" has value "Rücklieferung"
And I save the current editor


Scenario: 09 EK-Prozess - Bestellung anlegen

Given I open an editor "Bestellung09" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
And I delete all rows
And I append rows
    | artikel   | mge  |
    | SATTEL    | 10   |
And I save the current editor

Given I open an editor "Rechnung_mL09" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "Bestellung09"
And I set fields
    | beleg  | !Bestellung09^nummer |
    | vom    | .                    |
    | ebeleg | RE_09                |
    | fakt   | JA                   |
    | ueb    | JA                   |
And I modify table
    | !row  | mge   | exbehnum        | packm   |
    | 1     | 10    | RECHNUNG_09_J48 | KLT     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I open an editor "behaelter_09ek" from table "(Container):(ContainerShell)" with command "VIEW" for record "RECHNUNG_09_J48"
Then the table has 1 rows
Then field "mge" has value "10" in row 1
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                     |
    | beleg         | !Rechnung_mL09^nummer |
And I press start
Then the table has 4 rows
And I close the current editor

Given I open an editor "Ruecklieferung09" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "Rechnung_mL09"
And I set fields
    | ebeleg | RE-Ruecklieferung_09 |
    | vom    | .                    |
    | ueb    | JA                   |
And I modify table
    | !row   | mge   | behaelter          |
    | 1      | -10   | !behaelter_09ek^id |
And I save the current editor

Given I open an editor "behaelter_09ek" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_09ek"
Then the table has 0 rows
Then fields have values
    | behstatusaz   | Rücklieferung |
    | behleer       | nein          |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                         |
    | beleg         | !Ruecklieferung09^nummer  |
    | kdetursache   | Rücklieferung Einkauf     |
And I press start
Then the table has 1 rows
And I close the current editor

