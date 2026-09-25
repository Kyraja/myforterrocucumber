# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Verkaufslieferschein.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Verkaufslieferscheine mit Behaeltern
#  ref              : ref_behaelter_verkauf_cu
#  Stammdaten       : VERSAND_BEHAELTER_Stammdaten.feature
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Verkaufslieferschein.feature
Background:
Given I set the fake date to "02.01.1995"

##################################################################################################################


Scenario: 01 Behaelter mit einem Artikel versenden
# Behaelter anlegen und befuellen
And I create a Container "behaelter_01l" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "5" on StorageLocation "F1" with document "L01ZU" and Container "behaelter_01l"

# Verkaufslieferschein mit Behaelter
Given I open an editor "VKLS_01" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | WRADSHOP  |
    | vom   | .         |
    | such  | VKLS_01   |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | PEDALE    | 5     | !behaelter_01l^id |
Then field "packanw" is not empty in row 1
Then field "pmneu" is modifiable in row 1
And I save the current editor

# Behaelterbuchung in LS-Position pruefen
Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1

And I switch the current editor to editor "behaelter_01l" with command "VIEW"
Then fields have values
    | kl            |           |
    | behstatusaz   | Geliefert |
    | behleer       | nein      |
Then the table has 0 rows
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum    | .                 |
    | beleg     | !VKLS_01^nummer   |
And I press start
Then table has values
    | art       | amge  | behaelter^id      |
    | PEDALE    | 5     | !behaelter_01l^id |
And I close the current editor


Scenario: 02 Ein Behaelter mit zwei unterschiedlichen Artikeln versenden
# Behaelter anlegen und befuellen
And I create a Container "behaelter_02l" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "5" on StorageLocation "F1" with document "L02ZU" and Container "behaelter_02l"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "5" on StorageLocation "F1" with document "L02ZU" and Container "behaelter_02l"

# Verkaufslieferschein mit Behaelter
Given I open an editor "VKLS_02" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | WRADSHOP  |
    | vom   | .         |
    | such  | BEH_VER02 |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel | mge | behaelter         |
    | PEDALE  | 5   | !behaelter_02l^id |
    | SATTEL  | 5   | !behaelter_02l^id |
Then field "packanw" is not empty in row 1
Then field "pmneu" is modifiable in row 1
Then field "packanw" is not empty in row 2
Then field "pmneu" is modifiable in row 2
And I save the current editor

# Behaelterbuchung in LS pruefen, nur in Zeile 1 wird Behaelterkonto bebucht, Zeile 2 ist der selbe Behaelter
Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung" is empty in row 2

And I switch the current editor to editor "behaelter_02l"
Then fields have values
    | kl            |           |
    | behstatusaz   | Geliefert |
    | behleer       | nein      |
Then the table has 0 rows
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum    | .                 |
    | beleg     | !VKLS_02^nummer   |
And I press start
Then the table has 2 rows
Then table has values
    | art       | amge  | behaelter^id      |
    | PEDALE    | 5     | !behaelter_02l^id |
    | SATTEL    | 5     | !behaelter_02l^id |
And I close the current editor


Scenario: 03 Mehrere Artikel mit manueller und berechneter Packmittelzeile
# Behaelter anlegen und befuellen
And I create a Container "behaelter_03l-1" for packaging material "KLT"
And I create a Container "behaelter_03l-2" for packaging material "KLT"
And I create a Container "behaelter_03l-3" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "5" on StorageLocation "F1" with document "L03ZU" and Container "behaelter_03l-1"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "3" on StorageLocation "F1" with document "L03ZU" and Container "behaelter_03l-2"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "1" on StorageLocation "F1" with document "L03ZU" and Container "behaelter_03l-3"

# Verkaufslieferschein it Behaelter und Packmittel berechnen
Given I open an editor "VKLS-_03" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | vom   | .         |
    | such  | BEH_A03   |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel | mge | behaelter           |
    | SATTEL  | 5   | !behaelter_03l-1^id |
Then field "packanw" is not empty in row 1
And I press button "packvor"
Then field "behaelter" is not modifiable in row 2
Then field "exbehnum" is not modifiable in row 2
Then field "behaelter" is not modifiable in row 3
Then field "exbehnum" is not modifiable in row 3
Then field "behaelter" is not modifiable in row 4
Then field "exbehnum" is not modifiable in row 4
And I append rows
    | artikel | mge | he    | behaelter           |
    | RAD     | 3   | Paar  | !behaelter_03l-2^id |
Then field "packanw" is not empty in row 5
And I press button "packvor"
Then field "behaelter" is not modifiable in row 6
Then field "exbehnum" is not modifiable in row 6
Then field "behaelter" is not modifiable in row 7
Then field "exbehnum" is not modifiable in row 7
Then field "behaelter" is not modifiable in row 8
Then field "exbehnum" is not modifiable in row 8
And I append rows
    | artikel | mge | he    |
    | RAD     | 1   | Paar  |
And I press button "pmneu" in row !lastRow
And I append rows
    | artikel | mge |
    | KLT     | 1   |
And I set field "behaelter" to id from editor "behaelter_03l-3" in row 9
Then field "behaelter" is not modifiable in row 10
Then field "exbehnum" is not modifiable in row 10
And I save the current editor

And I switch the current editor to editor "behaelter_03l-1"
Then the table has 0 rows
Then field "behstatusaz" has value "Geliefert"
And I close the current editor

And I switch the current editor to editor "behaelter_03l-2"
Then the table has 0 rows
Then field "behstatusaz" has value "Geliefert"
And I close the current editor

And I switch the current editor to editor "behaelter_03l-3"
Then the table has 0 rows
Then field "behstatusaz" has value "Geliefert"
And I close the current editor


Scenario: 04 Feld kl Lieferant bleibt bei Versand von Behaelter gefuellt
# Behaelter anlegen
Given I open an editor "behaelter_04l_1" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set fields
    | such  | behaelter_04l_1 |
    | kl    | L KETTLER       |
    | packm | KLT             |
And I save the current editor

And I create a Container "behaelter_04l_2" for packaging material "KLT"

# Behaelter fuellen
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "5" on StorageLocation "F1" with document "L04ZU" and Container "behaelter_04l_1"
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "5" on StorageLocation "F1" with document "L04ZU" and Container "behaelter_04l_2"

# Verkaufslieferschein mit Behaelter
Given I open an editor "VKLS_04" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | vom   | .         |
    | such  | BEH_E04   |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel | mge | behaelter           |
    | PEDALE  | 5   | !behaelter_04l_1^id |
    | PEDALE  | 5   | !behaelter_04l_2^id |
And I save the current editor

# Behaelter pruefen, Feld kl bleibt gefuellt
And I open an editor "behaelter_04l_1" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_04l_1"
Then the table has 0 rows
Then fields have values
    | kl^such       | KETTLER   |
    | behstatusaz   | Geliefert |
    | behleer       | nein      |
And I close the current editor

And I open an editor "behaelter_04l_2" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_04l_2"
Then the table has 0 rows
Then fields have values
    | kl^such       |           |
    | behstatusaz   | Geliefert |
    | behleer       | nein      |
And I close the current editor


#@Verkaufsprozess
Scenario: 05 Verkaufsprozess mit Behaelter

And I create a Container "behaelter05l_1" for packaging material "KLT"

# Lagerbuchung Behaelter fuellen
Given I open an editor "Lagerbuchung05" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | Fahrrad   |
    | buart     | Zugang    |
    | beleg     | LM05      |
    | beldat    | .         |
    | wert      | 600       |
And I delete all rows
And I append rows
    | mge   | behaelter         |
    | 5     | !behaelter05l_1^id |
And I save the current editor

# Verkaufsprozess - Auftrag
Given I open an editor "Auftrag05" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP            |
    | such      | VA_05              |
    | betreff   | Bestellung Fahrrad |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | FAHRRAD   | 5     |
And I save the current editor

# Verkaufsprozess - Lieferschein mit Behaelter
Given I open an editor "VKLS_05_1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag05"
And I set fields
    | such    | VKLS05  |
    | vom     | .       |
    | ueb     | ja      |
And I modify table
    | !row  | mge   | behaelter             | verw  |
    | 1     | 5     | !behaelter05l_1^id    |       |
And I save the current editor

# Behaelter VK pruefen
And I switch the current editor to editor "behaelter05l_1"
Then the table has 0 rows
And I close the current editor

# Verkaufsprozess - Ruecklieferung neuer Behaelter wird erstellt
Given I open an editor "VKRLS05_1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS_05_1"
And I set fields
    | such    | VKRLS05_1 |
    | vom     | .       |
    | ueb     | ja      |
And I modify table
    | !row  | mge   | exbehnum            | packm |
    | 1     | -2    | PROZESS05_RUECK_B18 | KLT   |
And I save the current editor

# Behaelter Ruecklieferung pruefen
And I open an editor "behaelter05l_2" from table "(Container):(ContainerShell)" with command "VIEW" for record "PROZESS05_RUECK_B18"
Then field "behstatusaz" has value ""
Then the table has 1 rows
Then field "mge" has value "2" in row 1
And I close the current editor

# Verkaufsprozess - Ruecklieferung bestehender Behaelter
And I create a Container "behaelter05l_3" for packaging material "KLT"

# Ruecklieferschein
Given I open an editor "VKRLS05_2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "VKLS_05_1"
And I set fields
    | such    | VKRLS05_2 |
    | vom     | .         |
    | ueb     | ja        |
And I modify table
    | !row  | mge   | !dialogId                                     | !dialogAnswer | exbehnum               |
    | 1     | -1    | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter05l_3^nummer |
And I save the current editor

# Behaelter nach Ruecklieferung pruefen
And I switch the current editor to editor "behaelter05l_3"
Then the table has 1 rows
Then field "mge" has value "1" in row 1
And I close the current editor


Scenario: 06 Packmittel berechnen, 1 Behaelter, 1 Artikel, Artikelmenge = Fuellmenge packanw
# Behaelter anlegen und fuellen
And I create a Container "behaelter_06l" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "10" on StorageLocation "F1" with document "L06-ZU" and Container "behaelter_06l"

# Verkaufslieferschein mit Behaelter und Packmittel berechnen
Given I open an editor "VKLS_06" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I delete all rows
And I append rows
    | artikel | mge | behaelter             |
    | RAD     | 10  | !behaelter_06l^nummer |
And I press button "packvor"
Then table has values
    | !row | artikel^such | mge |
    | 1    | RAD          | 10  |
    | 2    | KLT          |  1  |
    | 3    | KLT          |  3  |
    | 4    | SPALETTE     |  1  |
And I set field "ueb" to "JA"
And I save the current editor


Scenario: 07 Packmittel berechnen, mehrere Behaelter, 1 Artikel, Artikelmenge = Fuellmenge packanw
# Behaelter anlegen und fuellen
And I create a Container "behaelter_07l_1" for packaging material "KLT"
And I create a Container "behaelter_07l_2" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "10" on StorageLocation "F1" with document "L07-ZU" and Container "behaelter_07l_1"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "10" on StorageLocation "F1" with document "L07-ZU" and Container "behaelter_07l_2"

# Verkaufslieferschein mit Behaelter und Packmittel berechnen
Given I open an editor "VKLS_07" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "WRADSHOP"
And I delete all rows
And I append rows
    | artikel | mge | behaelter           |
    | RAD     | 10  | !behaelter_07l_1^id |
    | RAD     | 10  | !behaelter_07l_2^id |
And I press button "packvor"
Then table has values
    | !row | artikel^such | mge |
    | 1    | RAD          | 10  |
    | 2    | RAD          | 10  |
    | 3    | KLT          |  2  |
    | 4    | KLT          |  2  |
    | 5    | SPALETTE     |  1  |
And I set field "ueb" to "JA"
And I save the current editor

# Behaelterbuchung im LS pruefen, KLT werden in den Artikelzeilen mit Behaelter gebucht, Zeile 3 keine Buchung da es die KLT aus Zeile 1 und 2 sind
# Zeile 4 sind die leeren KLT; insgesamt werden 4 KLT versendet und gebucht
Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung^mge" has value "1" in row 2
Then field "bhbuchung^buart" has value "Abgang" in row 2
Then field "bhbuchung" is empty in row 3
Then field "bhbuchung^mge" has value "2" in row 4
Then field "bhbuchung^buart" has value "Abgang" in row 4


Scenario: 08 Packmittel berechnen, 1 Behaelter, versch. Artikel, Artikelmenge = Fuellmenge packanw
# Behaelter anlegen und befuellen
And I create a Container "behaelter_08l" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "5" on StorageLocation "F1" with document "L08-ZU" and Container "behaelter_08l"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "5" on StorageLocation "F1" with document "L08-ZU" and Container "behaelter_08l"

# Verkaufslieferschein mit verschiedenen Artikeln im Behaelter, Packmittel berechnen nicht moeglich
Given I open an editor "VKLS_08" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "WRADSHOP"
And I delete all rows
And I append rows
    | artikel | mge | behaelter         |
    | SATTEL  | 5   | !behaelter_08l^id |
    | RAD     | 5   | !behaelter_08l^id |
And I press button "packvor"
# 10995 Packmittel können für die Position nicht berechnet werden, da ein Behälter mehrere Artikel beinhaltet.
Then message "Packmittel können für die Position nicht berechnet werden, da ein Behälter mehrere Artikel beinhaltet." was displayed
Then table has values
    | !row | artikel^such | mge |
    | 1    | SATTEL       | 5   |
    | 2    | RAD          | 5   |
And I set field "ueb" to "JA"
And I save the current editor

# Behaelterbuchung im LS pruefen, Zeile 2 keine Buchung, da es der selbe KLT wie in Zeile 1 ist, es wird insgesamt nur 1 KLT versendet
Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung" is empty in row 2


Scenario: 09 Packmittel berechnen, mehrere Behaelter, versch. Artikel, Artikelmenge = Fuellmenge packanw
# Behaelter anlegen und befuellen
And I create a Container "behaelter_09l_1" for packaging material "KLT"
And I create a Container "behaelter_09l_2" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "5" on StorageLocation "F1" with document "L09-ZU" and Container "behaelter_09l_1"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "5" on StorageLocation "F1" with document "L09-ZU" and Container "behaelter_09l_2"

# Verkaufslieferschein mit zwei Behaeltern und Packmittel berechnen
Given I open an editor "VKLS_09" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "WRADSHOP"
And I delete all rows
And I append rows
    | artikel | mge | behaelter           |
    | SATTEL  | 5   | !behaelter_09l_2^id |
    | RAD     | 5   | !behaelter_09l_1^id |
And I press button "packvor"
Then table has values
    | !row | artikel^such | mge |
    | 1    | SATTEL       | 5   |
    | 2    | KLT          | 1   |
    | 3    | KLT          | 3   |
    | 4    | SPALETTE     | 1   |
    | 5    | RAD          | 5   |
    | 6    | KLT          | 1   |
    | 7    | KLT          | 3   |
    | 8    | SPALETTE     | 1   |
And I set field "ueb" to "JA"
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung" is empty in row 2
Then field "bhbuchung^mge" has value "3" in row 3
Then field "bhbuchung^buart" has value "Abgang" in row 3

Then field "bhbuchung^mge" has value "1" in row 5
Then field "bhbuchung^buart" has value "Abgang" in row 5
Then field "bhbuchung" is empty in row 6
Then field "bhbuchung^mge" has value "3" in row 7
Then field "bhbuchung^buart" has value "Abgang" in row 7


Scenario: 10 Packmittel berechnen, 1 Behaelter, 1 Artikel, Artikelmenge ungleich Fuellmenge packanw
# Behaelter anlegen und befuellen
And I create a Container "behaelter_10l" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "13" on StorageLocation "F1" with document "L10-ZU" and Container "behaelter_10l"

# Verkaufslieferschein mit Behaelter und Packmittel berechnen
Given I open an editor "VKLS_10" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "WRADSHOP"
And I delete all rows
And I append rows
    | artikel | mge | behaelter         |
    | RAD     | 13  | !behaelter_10l^id |
And I press button "packvor"
Then the table has 2 rows
Then table has values
    | !row  | tename    | mge   | fmenge    |
    | 2     | KLT       | 1     | 13        |
And I set field "ueb" to "JA"
And I save the current editor

# der Behälter enthält die 13 Paar die versendet werden, trotz Fuellmenge 10 wird deshalb nur 1 KLT versendet
Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung" is empty in row 2


Scenario: 11 Packmittel werden nicht berechnet, da 1 Behaelter mit 2 Artikeln, Artikelmenge ungleich Fuellmenge packanw
# Behaelter anlegen und befuellen
And I create a Container "behaelter_11l" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "13" on StorageLocation "F1" with document "L11-ZU" and Container "behaelter_11l"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "13" on StorageLocation "F1" with document "L11-ZU" and Container "behaelter_11l"

# Verkaufslieferschein mit verschiedenen Artikeln im Behaelter, Packmittel berechnen nicht moeglich
Given I open an editor "VKLS_11" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "WRADSHOP"
And I delete all rows
And I append rows
    | artikel | mge | behaelter         |
    | SATTEL  | 13  | !behaelter_11l^id |
    | RAD     | 13  | !behaelter_11l^id |
And I press button "packvor"
Then message "Packmittel können für die Position nicht berechnet werden, da ein Behälter mehrere Artikel beinhaltet." was displayed
Then table has values
    | !row | artikel^such | mge |
    | 1    | SATTEL       | 13  |
    | 2    | RAD          | 13  |
And I set field "ueb" to "JA"
And I save the current editor

# Behaelterbuchung in LS-Positionen pruefen, nur KLT aus Zeile 1 wird gebucht, da in Zeile 2 der selbe Behaelter, es wird nur 1 KLT versendet und gebucht
Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung" is empty in row 2


Scenario: 12 Packmittel berechnen, mehrere Behaelter, 1 Artikel, Artikelmenge ungleich Fuellmenge packanw
# Behaelter anlegen und befuellen
And I create a Container "behaelter_12l_1" for packaging material "KLT"
And I create a Container "behaelter_12l_2" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "13" on StorageLocation "F1" with document "L12-ZU" and Container "behaelter_12l_1"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "13" on StorageLocation "F1" with document "L12-ZU" and Container "behaelter_12l_2"

# Verkaufslieferschein mit zwei Behaeltern und Packmittel berechnen
Given I open an editor "VKLS_12" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "WRADSHOP"
And I delete all rows
And I append rows
    | artikel | mge | behaelter           |
    | SATTEL  | 13  | !behaelter_12l_2^id |
    | RAD     | 13  | !behaelter_12l_1^id |
And I press button "packvor"
Then table has values
    | !row | artikel^such | mge |
    | 1    | SATTEL       | 13  |
    | 2    | KLT          | 1   |
    | 3    | RAD          | 13  |
    | 4    | KLT          | 1   |
And I set field "ueb" to "JA"
And I save the current editor

Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung" is empty in row 2
Then field "bhbuchung^mge" has value "1" in row 3
Then field "bhbuchung^buart" has value "Abgang" in row 3
Then field "bhbuchung" is empty in row 4


Scenario: 13 Jokerbestand ohne Verwendung und Projekt wird Auftragsposition mit Projekt zugeordnet
# Artikel JOKER erstellen
Given I open an editor "artikel_12" from table "(Part):(Product)" with command "STORE" for record "JOKER_PROJEKT"
And I set field "such" to "JOKER_PROJEKT"
And I save the current editor

Given I open an editor "projekt_13" from table "(Transaction):(Project)" with command "STORE" for record "JOKER_PROJEKT"
And I set field "such" to "JOKER_PROJEKT"
And I save the current editor

And I create a Container "behaelter_13l_1" for packaging material "BEHAELTER"
And I create a Container "behaelter_13l_2" for packaging material "BEHAELTER"

# Lagerbuchung Zugang Jokerbestand in Behaelter OHNE Projekt
And I post a receipt via ManualStockAdjustment for Product "JOKER_PROJEKT" and quantity "5" on StorageLocation "F1" with document "L13-ZU" and Container "behaelter_13l_1"
And I post a receipt via ManualStockAdjustment for Product "JOKER_PROJEKT" and quantity "2" on StorageLocation "F1" with document "L13-ZU" and Container "behaelter_13l_2"

# Auftrag mit Projekt
Given I open an editor "auftrag_13" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I append rows
    | artikel       | mge | projekt        |
    | JOKER_PROJEKT | 5   | !projekt_13^id |
    | JOKER_PROJEKT | 2   | !projekt_13^id |
And I save the current editor

And I run Scheduling

# Lieferschein aus Auftrag
And I switch the current editor to editor "auftrag_13" with command "DELIVERY"
And I modify table
    | !row  | mge    | behaelter            |
    | 1     | 5      | !behaelter_13l_1^id  |
    | 2     | 2      | !behaelter_13l_2^id  |
And I set field "ueb" to "ja"
And I save the current editor

# Behaelter pruefen
And I switch the current editor to editor "behaelter_13l_1" with command "VIEW"
Then the table has 0 rows
And I close the current editor

And I switch the current editor to editor "behaelter_13l_2" with command "VIEW"
Then the table has 0 rows
And I close the current editor

# es sind keine negativen Gebindezeilen entstanden
Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | JOKER_PROJEKT |
    | klgruppe   |               |
    | verdichten | nein          |
And I press button "bstart"
Then the table has 1 rows
Then field "lemge" is empty in row 1
And I close the current editor


Scenario: 14 Jokerbestand mit unscharfer Verwendung wird Auftragsposition mit Verwendung zugeordnet
# Artikel JOKER erstellen
Given I open an editor "artikel_14" from table "(Part):(Product)" with command "STORE" for record "JOKER_VERWEND"
And I set field "such" to "JOKER_VERWEND"
And I set field "dispoa" to "auftragsbezogen"
And I save the current editor

And I create a Container "behaelter_14l_1" for packaging material "BEHAELTER"
And I create a Container "behaelter_14l_2" for packaging material "BEHAELTER"

# Auftragspositionen bekommen eine Verwendung
Given I open an editor "auftrag_14" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I append rows
    | artikel       | mge |
    | JOKER_VERWEND | 5   |
    | JOKER_VERWEND | 2   |
And I save the current editor

# Lagerbuchung Zugang Jokerbestand in Behaelter OHNE Verwendung
And I post a receipt via ManualStockAdjustment for Product "JOKER_VERWEND" and quantity "5" on StorageLocation "F1" with document "L14-ZU" and Container "behaelter_14l_1"
And I post a receipt via ManualStockAdjustment for Product "JOKER_VERWEND" and quantity "2" on StorageLocation "F1" with document "L14-ZU" and Container "behaelter_14l_2"

And I run Scheduling

# Lieferschein aus Auftrag
And I switch the current editor to editor "auftrag_14" with command "DELIVERY"
And I modify table
    | !row  | mge    | behaelter            |
    | 1     | 5      | !behaelter_14l_1^id  |
    | 2     | 2      | !behaelter_14l_2^id  |
    And I set field "mge" to "5" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Behaelter pruefen
And I switch the current editor to editor "behaelter_14l_1" with command "VIEW"
Then the table has 0 rows
And I close the current editor

And I switch the current editor to editor "behaelter_14l_2" with command "VIEW"
Then the table has 0 rows
And I close the current editor

# es sind keine negativen Gebindezeilen entstanden
Given I open the infosystem "BESTAND"
And I set fields
    | artikel    | JOKER_VERWEND |
    | klgruppe   |               |
    | verdichten | nein          |
And I press button "bstart"
Then the table has 1 rows
Then field "lemge" is empty in row 1
And I close the current editor
