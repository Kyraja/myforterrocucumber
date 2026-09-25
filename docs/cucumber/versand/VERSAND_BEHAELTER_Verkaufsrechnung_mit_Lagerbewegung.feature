# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Verkaufsrechnung_mit_Lagerbewegung.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Rechnungen mit Lagerbewegung im Verkauf mit Behaeltern
#  ref              : ref_behaelter_verkauf_cu
#  Stammdaten       : VERSAND_BEHAELTER_Stammdaten.feature
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Verkaufsrechnung_mit_Lagerbewegung.feature
Background:
Given I set the fake date to "02.01.1995"

##################################################################################################################

Scenario: 01 Behaelter mit einem Artikel versenden
# Behaelter anlegen und befuellen
And I create a Container "behaelter_01r" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "5" on StorageLocation "F1" with document "L01RZU" and Container "behaelter_01r"

# Verkaufsrechnung mit Behaelter in der Position
Given I open an editor "VKRechnung01" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde | WRADSHOP  |
    | vom   | .         |
    | such  | VKRE_01   |
    | ueb   | ja        |
    | fakt  | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | PEDALE    | 5     | !behaelter_01r^id |
Then field "packanw" is not empty in row 1
And I save the current editor

# Behaelterbuchung wurde durchgefuehrt
Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1

# Behaelter pruefen
And I switch the current editor to editor "behaelter_01r" with command "VIEW"
Then fields have values
    | kl            |           |
    | behstatusaz   | Geliefert |
    | behleer       | nein      |
Then the table has 0 rows
And I close the current editor

# Lagerjournal pruefen, Behaelter ist eingetragen
And I open the infosystem "LJ"
And I set fields
    | adatum    | .                      |
    | beleg     | !VKRechnung01^nummer   |
And I press start
Then the table has 1 rows
Then table has values
    | art       | amge  | behaelter^id      |
    | PEDALE    | 5     | !behaelter_01r^id |
And I close the current editor


Scenario: 02 Eine Behaelter mit zwei unterschiedlichen Artikeln versenden
# Behaelter anlegen und befuellen
And I create a Container "behaelter_02r" for packaging material "KLT"
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "10" on StorageLocation "F1" with document "L02RZU" and Container "behaelter_02r"
And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "5" on StorageLocation "F1" with document "L02RZU" and Container "behaelter_02r"

# Verkaufsrechnung mit Behaelter in beiden Positionen
Given I open an editor "VKRechnung02" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde | WRADSHOP  |
    | vom   | .         |
    | such  | VKRE_02   |
    | ueb   | ja        |
    | fakt  | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | PEDALE    | 10    | !behaelter_02r^id |
    | SATTEL    | 5     | !behaelter_02r^id |
Then field "packanw" is not empty in row 1
Then field "packanw" is not empty in row 2
And I save the current editor

# in Zeile 2 keine Behaelterbuchung, da es der selbe Behaelter ist wie in Zeile 1
Then field "bhbuchung^mge" has value "1" in row 1
Then field "bhbuchung^buart" has value "Abgang" in row 1
Then field "bhbuchung" is empty in row 2

# Behaelter pruefen
And I switch the current editor to editor "behaelter_02r"
Then the table has 0 rows
Then fields have values
    | kl            |           |
    | behstatusaz   | Geliefert |
    | behleer       | nein      |
And I close the current editor

# im Lagerjournal ist der Behaelter eingetragen
And I open the infosystem "LJ"
And I set fields
    | adatum    | .                      |
    | beleg     | !VKRechnung02^nummer   |
And I press start
Then the table has 2 rows
Then table has values
    | art       | amge  | behaelter^id      |
    | PEDALE    | 10    | !behaelter_02r^id |
    | SATTEL    | 5     | !behaelter_02r^id |
And I close the current editor


Scenario: 03 Feld kl bleibt bei Versand von Behaelter gefuellt (Lieferant)

# Behaelter fuellen
Given I open an editor "EKLS_03R" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER   |
    | such   | ER_03     |
    | ebeleg | B11_ER03  |
    | vom    | .         |
    | ueb    | ja        |
And I delete all rows
And I append rows
    | artikel | mge | exbehnum        | packm   |
    | SATTEL  | 2   | KL_GEFUELLT_V03 | KLT     |
And I save the current editor

And I open an editor "behaelter_03r" from table "(Container):(ContainerShell)" with command "VIEW" for record "KL_GEFUELLT_V03"
Then field "kl^such" has value "KETTLER"
And I close the current editor

# Verkaufsrechnung mit Behaelter in der Position
Given I open an editor "VKRechnung03" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | vom   | .         |
    | ueb   | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | behaelter         |
    | SATTEL    | 2     | !behaelter_03r^id |
And I save the current editor

# Lieferant bleibt im Behaelter gefuellt
And I open an editor "behaelter_03r" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_03r"
Then fields have values
    | kl^such       | KETTLER   |
    | behstatusaz   | Geliefert |
    | behleer       | nein      |
Then the table has 0 rows
And I close the current editor


Scenario: 04 Verkaufsprozess
# Behaelter anlegen und befuellen
And I create a Container "behaelter_04r" for packaging material "KLT"

Given I open an editor "Lagerbuchung04" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | Fahrrad   |
    | buart     | Zugang    |
    | beleg     | LR04      |
    | beldat    | .         |
    | wert      | 600       |
And I delete all rows
And I append rows
    | mge   | behaelter         |
    | 10    | !behaelter_04r^id |
And I save the current editor

# Verkaufsprozess - Auftrag
Given I open an editor "auftrag04" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP            |
    | such      | AUFTRAG04          |
    | betreff   | Bestellung Fahrrad |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | FAHRRAD   | 10    |
And I save the current editor


# Verkaufsprozess - Rechnung mit Behaelter
Given I open an editor "VRechnung04" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | beleg | !auftrag04^nummer |
    | such  | VKR_04            |
    | ueb   | ja                |
And I modify table
    |!row   | mge   | behaelter         | verw  |
    | 1     | 10    | !behaelter_04r^id |       |
And I save the current editor

# Behaelter VK pruefen
And I switch the current editor to editor "behaelter_04r"
Then field "behstatusaz" has value "Geliefert"
Then the table has 0 rows
And I close the current editor

# Verkaufsprozess - Ruecklieferung neuer Behaelter wird erstellt
Given I open an editor "VRueck041" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VRechnung04"
And I set field "such" to "VRueck041"
And I modify table
    | !row  | mge   | exbehnum          | packm |
    | 1     | -5    | PROZESS_RUECK_V11 | KLT   |
And I set field "ueb" to "JA"
And I save the current editor

# Behaelter aus VK-Rechnung nach der Ruecklieferung pruefen
And I switch the current editor to editor "behaelter_04r"
Then the table has 0 rows
Then field "behstatusaz" has value "Geliefert"
And I close the current editor

# neuer Behaelter aus Ruecklieferung pruefen
And I open an editor "behaelter04r_1" from table "(Container):(ContainerShell)" with command "VIEW" for record "PROZESS_RUECK_V11"
Then the table has 1 rows
Then field "mge" has value "5" in row 1
And I close the current editor

# Verkaufsprozess - Ruecklieferung bestehender Behaelter
And I create a Container "behaelter04r_2" for packaging material "KLT"

# Verkaufsrechnung
Given I open an editor "VRechnung042" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VRechnung04"
And I set field "such" to "VRueck042"
And I modify table
    | !row  | mge   | !dialogId                                     | !dialogAnswer | exbehnum               | packm |
    | 1     | -5    | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter04r_2^nummer | KLT   |
And I set field "ueb" to "JA"
And I save the current editor

# Behaelter nach Ruecklieferung pruefen
And I switch the current editor to editor "behaelter04r_2"
Then the table has 1 rows
Then field "mge" has value "5" in row 1
And I close the current editor

