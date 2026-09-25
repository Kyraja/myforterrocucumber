@persistent
Feature: storno_rueckmeldungen_mz_prozesstests.feature

  Background:
    And I set the fake date to "02.01.1995"

# *****************************************************************************
#  Name             : storno_rueckmeldungen_mz_prozesstests
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet Prozesse in der Fertigung mit Materialzuordnungen
#  ref				: ref_fe_storno_RM_MZ_prozess_cu
#  Jira-Issue       : FDA-1363
# *****************************************************************************

## Rückmeldungen eines lebendigen Betriebsauftrags


  Scenario: 01 Fertigartikel, die auf unterschiedliche Lagerplätze gebucht wurden, werden nach Storno wieder zurückgebucht
# Lagerzugnag Material
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "Zugang" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "Zugang" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BAUGRUPPE | 10  | ja     |
    And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
    And I delete all rows
    And I append rows
      | zuomge | lpsuch |
      | 5      | F1     |
      | 5      | F2     |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "PLATZ_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLATZ_001"
    And I set fields
      | sofort | 1 |
    And I modify table
      | gutmge | buplatz | erbtext1    | !row |
      | 7      | F1      | Rückmeldung | 1    |
    And I save the current editor

# Bewertung
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I set field "erbtext1" to "Storno" in row 1
    And I save the current editor

# Bewertung hat Nachfolger
    And I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | nplatz | amge | vplatz | storniert | !row |
      | BAUGRUPPE | -5   | F1     |      |        | nein      | 1    |
      | BAUGRUPPE | -2   | F2     |      |        | nein      | 2    |
      | EINKAUF-1 |      |        | -14  | F1     | nein      | 3    |
      | EINKAUF-2 |      |        | -7   | F1     | nein      | 4    |
      | BAUGRUPPE | 2    | F2     |      |        | ja        | 5    |
      | BAUGRUPPE | 5    | F1     |      |        | ja        | 6    |
      | EINKAUF-1 |      |        | 14   | F1     | ja        | 7    |
      | EINKAUF-2 |      |        | 7    | F1     | ja        | 8    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "PLATZ_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 02 Fertigartikel mit Chargen und Verwendungen werden wieder aus dem Lager gebucht
    And I set the fake date to "03.01.1995"
# Chargen anlegen
    Given I create a Lot "CHARGE1_BG" for Product "BAUGRUPPE"
    Given I create a Lot "CHARGE2_BG" for Product "BAUGRUPPE"

# Zugang manuelle Lagerbuchung für das Material
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "Zugang" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "Zugang" and price "0"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag01" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

# Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BAUGRUPPE | 10  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag01" in row 1
    And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
    And I delete all rows
    And I append rows
      | zuomge | charge         |
      | 5      | !CHARGE1_BG^id |
      | 5      | !CHARGE2_BG^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "CHVERW_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHVERW_001"
    And I set fields
      | sofort | 1 |
    And I set field "bem" in row 0 to "verw" from editor "auftrag01" in row 1
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=CHVERW_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | vcharge^such | ncharge^such | storniert | !row |
      | BAUGRUPPE | -5   |      |              | CHARGE1_BG   | nein      | 1    |
      | BAUGRUPPE | -2   |      |              | CHARGE2_BG   | nein      | 2    |
      | EINKAUF-1 |      | -10  |              | CHARGE1_BG   | nein      | 3    |
      | EINKAUF-1 |      | -4   |              | CHARGE2_BG   | nein      | 4    |
      | EINKAUF-2 |      | -5   |              | CHARGE1_BG   | nein      | 5    |
      | EINKAUF-2 |      | -2   |              | CHARGE2_BG   | nein      | 6    |
      | BAUGRUPPE | 2    |      |              | CHARGE2_BG   | ja        | 7    |
      | BAUGRUPPE | 5    |      |              | CHARGE1_BG   | ja        | 8    |
      | EINKAUF-1 |      | 4    |              | CHARGE2_BG   | ja        | 9    |
      | EINKAUF-1 |      | 10   |              | CHARGE1_BG   | ja        | 10   |
      | EINKAUF-2 |      | 2    |              | CHARGE2_BG   | ja        | 11   |
      | EINKAUF-2 |      | 5    |              | CHARGE1_BG   | ja        | 12   |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag01" in row 1
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 8
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 7
    And I close the current editor

# Betriebsauftrag und Auftrag abschließen
    Given I open an editor "Betriebsauftrag1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHVERW_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor
    And I deliver the SalesOrder "auftrag01" with PackingSlip "LS-02"


  Scenario: 03 Fertigartikel in Behälter werden durch die Storno-Rückmeldung wieder aus dem Behälter gebucht
    And I set the fake date to "04.01.1995"
# Behälter erstellen
    Given I create a Container "MZ_BEHAELTER1" for packaging material "BEHAELTER"
    Given I create a Container "MZ_BEHAELTER2" for packaging material "BEHAELTER"

# Fertigungsvorschlag mit MZ Fertigartikel anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig |
      | BG-BEHAELTER | 10     | ja     |
    And I press button "mzsubm" to open a subeditor for "MZuordnung" in row 1
    And I delete all rows
    And I append rows
      | zuomge | behaelter      |
      | 5      | !MZ_BEHAELTER1 |
      | 5      | !MZ_BEHAELTER2 |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MZ_BEH_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZ_BEH_001"
    And I set field "gutmge" to "7" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Behälter auf Fertigartikel prüfen
    Given I switch the current editor to editor "MZ_BEHAELTER1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel      | mge |
      | BG-BEHAELTER | 5   |
    And I close the current editor

    Given I switch the current editor to editor "MZ_BEHAELTER2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel      | mge |
      | BG-BEHAELTER | 2   |
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Behälter prüfen
    Then Container from editor "MZ_BEHAELTER1" is empty
    Then Container from editor "MZ_BEHAELTER2" is empty

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MZ_BEH_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 04 Fertigartikel mit Material mit Chargen und Verwendungen werden wieder an das Lager gebucht
    And I set the fake date to "05.01.1995"
# Chargen anlegen
    Given I create a Lot "CHARGE1_E1" for Product "EINKAUF-1"
    Given I create a Lot "CHARGE2_E1" for Product "EINKAUF-1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag04" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

# Chargen ans Lager buchen
    Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | EINKAUF-1 |
      | beleg   | 04-L      |
      | beldat  | .         |
      | buart   | Zugang    |
    And I append rows
      | mge | charge2        |
      | 10  | !CHARGE1_E1^id |
      | 10  | !CHARGE2_E1^id |
    And I save the current editor

# Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge |
      | BAUGRUPPE | 10  |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag04" in row 1
    And I press button "mzabsm" to open a subeditor for "MZKomp" in row !lastRow
    And I append rows
      | zuomge | charge         |
      | 10     | !CHARGE1_E1^id |
      | 10     | !CHARGE2_E1^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "CHKOMP_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHKOMP_001"
    And I set fields
      | sofort | 1 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Erste Rückmeldung stornieren
    Given I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | vcharge^such | ncharge^such | storniert | !row |
      | BAUGRUPPE | -7   |      |              |              | nein      | 1    |
      | EINKAUF-1 |      | -10  | CHARGE1_E1   |              | nein      | 2    |
      | EINKAUF-1 |      | -4   | CHARGE2_E1   |              | nein      | 3    |
      | EINKAUF-2 |      | -7   |              |              | nein      | 4    |
      | BAUGRUPPE | 7    |      |              |              | ja        | 5    |
      | EINKAUF-1 |      | 4    | CHARGE2_E1   |              | ja        | 6    |
      | EINKAUF-1 |      | 10   | CHARGE1_E1   |              | ja        | 7    |
      | EINKAUF-2 |      | 7    |              |              | ja        | 8    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 7
    And I close the current editor

# Betriebsauftrag und Auftrag abschließen
    Given I open an editor "Betriebsauftrag1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHKOMP_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor
    And I deliver the SalesOrder "auftrag04" with PackingSlip "LS-04"


  Scenario: 05 Komponenten aus MZ werden durch die Storno-Rückmeldung wieder in den zuvor angegebenen Behälter gelegt
    Given I set the fake date to "06.01.1995"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-05"

# Behälter erstellen
    Given I create a Container "ZURUECK-1" for packaging material "BEHAELTER"
    Given I create a Container "ZURUECK-2" for packaging material "BEHAELTER"

# Lagerbuchung EINKAUF-1 in Behälter
    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | EINKAUF-1 |
      | buart   | Zugang    |
      | beleg   | 07-L      |
      | beldat  | .         |
    And I append rows
      | mge | behaelter  |
      | 10  | !ZURUECK-1 |
      | 10  | !ZURUECK-2 |
    And I save the current editor

# Fertigungsvorschlag mit EntnahmeMZ für EINKAUF-1 anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BAUGRUPPE | 10     | ja     |
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I delete all rows
    And I append rows
      | zuomge | behaelter  |
      | 10     | !ZURUECK-1 |
      | 10     | !ZURUECK-2 |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "ZURUECK_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZURUECK_001"
    And I set field "gutmge" to "7" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Behälter ZURUECK-1 prüfen, ob leer
    Then Container from editor "ZURUECK-1" is empty
    And I switch the current editor to editor "ZURUECK-2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 6   |
    And I close the current editor

# Erste Rückmeldung stornieren und Behälter prüfen
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    And I save the current editor

    Given I switch the current editor to editor "ZURUECK-1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 10  |
    And I close the current editor
    Given I switch the current editor to editor "ZURUECK-2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 10  |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZURUECK_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 06 Komponente aus MZ kann über Storno-Rückmeldung in einen gesperrten Behälter zurückgelegt werden Status geht auf leer
    And I set the fake date to "07.01.1995"
# Bestände korrigieren, Auftrag erstellen
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-MZ06"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-MZ06"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-MZ06"
    Given I create a SalesOrder "auftrag06" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

# Behälter erstellen
    Given I create a Container "BEHAELTER_1" for packaging material "BEHAELTER"
    Given I create a Container "GESPERRTER_BEH" for packaging material "BEHAELTER"

# Lagerbuchung EINKAUF-1 in GESPERRTER_BEH
    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | EINKAUF-1 |
      | buart   | Zugang    |
      | beleg   | 06-L      |
      | beldat  | .         |
    And I modify table
      | mge | behaelter       | !row |
      | 5   | !GESPERRTER_BEH | 1    |
      | 5   | !BEHAELTER_1    | +2   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag06" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag06" in row 1
    And I save the current editor

# Fertigungsvorschlag mit EntnahmeMZ für EINKAUF-1 anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BAUGRUPPE | 10     | ja     |
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I delete all rows
    And I append rows
      | zuomge | behaelter       |
      | 5      | !GESPERRTER_BEH |
      | 5      | !BEHAELTER_1    |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "SPERRE_" in row 1
    And I set field "verw" to "verw" from editor "auftrag06" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SPERRE_001"
    And I set field "gutmge" to "7" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Behälter GESPERRTER_BEH sperren
    Then Container from editor "GESPERRTER_BEH" is empty
    Given I switch the current editor to editor "GESPERRTER_BEH" with command "UPDATE"
    And I set field "behstatusaz" to "Gesperrt"
    And I save the current editor

# Erste Rückmeldung stornieren
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    And I save the current editor

# Behälter prüfen
    Given I switch the current editor to editor "GESPERRTER_BEH" with command "VIEW"
    Then field "behstatusaz" is empty
    Then field "behleer" has value "nein"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 5   |
    And I close the current editor

# Betriebsauftrag abschließen und Behälter prüfen
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SPERRE_001;@richtung=rückwärts;@maxtreffer=1"
    And I set fields
      | autorment | ja |
    And I press button "stllad"
    And I set field "manbu" to "ja" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | zuomge | !row |
      | 5      | 1    |
      | 5      | +2   |
      | 10     | +3   |
    And I set field "behaelter" to "id" from editor "BEHAELTER_1" in row 1
    And I set field "behaelter" to "id" from editor "GESPERRTER_BEH" in row 2
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SPERRE_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Then Container from editor "GESPERRTER_BEH" is empty

    And I deliver the SalesOrder "auftrag06" with PackingSlip "LS-06"


  Scenario: 07 Storno einer MZ für verschiedene Lagerplätze aus Rückmeldung auf Betriebsauftrag bucht den Fertigartikel vom Lager ab
    And I set the fake date to "08.01.1995"
# Lagerzugang buchen
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "Zugang07" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "Zugang07" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch    |
      | M_BAUGRUPPE | 10  | ja     | BAPLÄTZE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme" for tip command "FBuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=BAPLÄTZE_000;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | 7                                                      |
      | mgr         | 112                                                    |
    And I press button "stllad"
    And I save the current editor

# Rückmeldung auf Betriebsauftrag
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BAPLÄTZE_000"
    And I set fields
      | sofort | 1   |
      | mgr    | 112 |
    And I set field "gutmge" to "7" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I append rows
      | zuomge | lpsuch |
      | 5      | F1     |
      | 2      | F2     |
    And I save the current editor
    And I switch the current editor to editor "Rückmeldung1"
    And I save the current editor

# Erste Rückmeldung stornieren
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | nplatz | amge | vplatz | storniert | !row |
      | M_BAUGRUPPE | -5   | F1     |      |        | nein      | 1    |
      | M_BAUGRUPPE | -2   | F2     |      |        | nein      | 2    |
      | M_BAUGRUPPE | 2    | F2     |      |        | ja        | 3    |
      | M_BAUGRUPPE | 5    | F1     |      |        | ja        | 4    |
      | EINKAUF-1   |      |        | 14   | F1     | nein      | 5    |
      | EINKAUF-2   |      |        | 7    | F1     | nein      | 6    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 3
    And I close the current editor


  Scenario: 08 Storno einer MZ für verschiedene Chargen aus Rückmeldung auf Betriebsauftrag bucht den Fertigartikel vom Lager ab
    And I set the fake date to "09.01.1995"
# Chargen anlegen
    Given I create a Lot "CHARGE_BG1" for Product "BAUGRUPPE"
    Given I create a Lot "CHARGE_BG2" for Product "BAUGRUPPE"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | BACHARGE_ |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I append rows
      | zuomge | charge         |
      | 5      | !CHARGE_BG1^id |
      | 2      | !CHARGE_BG2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BACHARGE_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf Betriebsauftrag, Bestand prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BACHARGE_000"
    And I set fields
      | sofort | 1   |
      | mgr    | 112 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id   |
      | 7     |        |             | (0,0,0)          |
      |       | 5      | CHARGE_BG1  | !Rückmeldung1^id |
      |       | 2      | CHARGE_BG2  | !Rückmeldung1^id |
    And I close the current editor

# Erste Rückmeldung stornieren und Bestand prüfen
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | ncharge^such | amge | vcharge^such | storniert | !row |
      | BAUGRUPPE | -5   | CHARGE_BG1   |      |              | nein      | 1    |
      | BAUGRUPPE | -2   | CHARGE_BG2   |      |              | nein      | 2    |
      | EINKAUF-1 |      | CHARGE_BG1   | -10  |              | nein      | 3    |
      | EINKAUF-1 |      | CHARGE_BG2   | -4   |              | nein      | 4    |
      | EINKAUF-2 |      | CHARGE_BG1   | -5   |              | nein      | 5    |
      | EINKAUF-2 |      | CHARGE_BG2   | -2   |              | nein      | 6    |
      | BAUGRUPPE | 2    | CHARGE_BG2   |      |              | ja        | 7    |
      | BAUGRUPPE | 5    | CHARGE_BG1   |      |              | ja        | 8    |
      | EINKAUF-1 |      | CHARGE_BG2   | 4    |              | ja        | 9    |
      | EINKAUF-1 |      | CHARGE_BG1   | 10   |              | ja        | 10   |
      | EINKAUF-2 |      | CHARGE_BG2   | 2    |              | ja        | 11   |
      | EINKAUF-2 |      | CHARGE_BG1   | 5    |              | ja        | 12   |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 8
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 10
    And I close the current editor


  Scenario: 09 Storno einer MZ für verschiedene Behälter aus Rückmeldung auf Betriebsauftrag bucht den Fertigartikel aus den Behältern
    And I set the fake date to "10.01.1995"
# Behälter erstellen
    Given I create a Container "MZBA_BEHAELTER1" for packaging material "BEHAELTER"
    Given I create a Container "MZBA_BEHAELTER2" for packaging material "BEHAELTER"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BAUGRUPPE | 10  | ja     |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I append rows
      | zuomge | behaelter        |
      | 5      | !MZBA_BEHAELTER1 |
      | 2      | !MZBA_BEHAELTER2 |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to " BACHARGE2_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf Betriebsauftrag
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BACHARGE2_000"
    And I set fields
      | sofort | 1   |
      | mgr    | 112 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Erste Rückmeldung stornieren
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    And I save the current editor

# Behälter prüfen
    Then Container from editor "MZBA_BEHAELTER1" is empty
    Then Container from editor "MZBA_BEHAELTER2" is empty


  Scenario: 10 Variantenbezogenes Fertigartikel mit Chargen und Verwendungen werden wieder aus dem Lager gebucht
    And I set the fake date to "11.01.1995"
# Artikel anlegen
    Given I open an editor "BAUGRUPPE-V" from table "(Part):(Product)" with command "STORE" for record "BAUGRUPPE-V"
    And I set fields
      | such     | BAUGRUPPE-V       |
      | namebspr | Baugruppe variant |
      | dispoa   | variantenbezogen  |
      | bsart    | Eigenfertigung    |
    And I delete all rows
    And I append rows
      | elex        | anzahl |
      | B_EINKAUF-1 | 1      |
      | A MONTAGE1  | 1      |
    And I save the current editor

# Chargen anlegen
    Given I create a Lot "CHARGE1_BG-V" for Product "BAUGRUPPE-V"
    Given I create a Lot "CHARGE2_BG-V" for Product "BAUGRUPPE-V"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | BAUGRUPPE-V | 10  | ja     |
    And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
    And I delete all rows
    And I append rows
      | zuomge | charge           |
      | 5      | !CHARGE1_BG-V^id |
      | 5      | !CHARGE2_BG-V^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "CHVAR2_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHVAR2_001"
    And I set fields
      | sofort | 1 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=CHVAR2_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | vcharge^such | ncharge^such | storniert | !row |
      | BAUGRUPPE-V | -5   |      |              | CHARGE1_BG-V | nein      | 1    |
      | BAUGRUPPE-V | -2   |      |              | CHARGE2_BG-V | nein      | 2    |
      | B_EINKAUF-1 |      | -5   |              | CHARGE1_BG-V | nein      | 3    |
      | B_EINKAUF-1 |      | -2   |              | CHARGE2_BG-V | nein      | 4    |
      | BAUGRUPPE-V | 2    |      |              | CHARGE2_BG-V | ja        | 5    |
      | BAUGRUPPE-V | 5    |      |              | CHARGE1_BG-V | ja        | 6    |
      | B_EINKAUF-1 |      | 2    |              | CHARGE2_BG-V | ja        | 7    |
      | B_EINKAUF-1 |      | 5    |              | CHARGE1_BG-V | ja        | 8    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 8
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "CHVAR2_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 11 Storno von einer Rückmeldung mit MZ mit Chargen für Komponenten und Fertigteil
    And I set the fake date to "12.01.1995"
# Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-11"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "KORR-11"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag11" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

# Chargen anlegen
    Given I create a Lot "CHARGE11-1_BG" for Product "BAUGRUPPE"
    Given I create a Lot "CHARGE11-2_BG" for Product "BAUGRUPPE"
    Given I create a Lot "CHARGE11-1_E1" for Product "EINKAUF-1"
    Given I create a Lot "CHARGE11-2_E1" for Product "EINKAUF-1"

# Fertigungsvorschlag anlegen und freigben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BAUGRUPPE | 10  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag11" in row 1
    And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
    And I modify table
      | zuomge | charge             | !row |
      | 5      | !CHARGE11-1_BG^id  | +1   |
      | 5      | !CHARGE11-2_BG^id  | +2   |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzabsm" to open a subeditor for "MZFertig" in row !lastRow
    And I modify table
      | zuomge | charge             | !row |
      | 10     | !CHARGE11-1_E1^id  | +1   |
      | 10     | !CHARGE11-2_E1^id  | +2   |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "PROZESS_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROZESS_001"
    And I set fields
      | sofort | 1 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Rückmeldung stornieren
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | vcharge^such  | ncharge^such   | storniert | !row |
      | BAUGRUPPE | -5   |      |               | CHARGE11-1_BG  | nein      | 1    |
      | BAUGRUPPE | -2   |      |               | CHARGE11-2_BG  | nein      | 2    |
      | EINKAUF-1 |      | -10  | CHARGE11-1_E1 | CHARGE11-1_BG  | nein      | 3    |
      | EINKAUF-1 |      | -4   | CHARGE11-2_E1 | CHARGE11-2_BG  | nein      | 4    |
      | EINKAUF-2 |      | -5   |               | CHARGE11-1_BG  | nein      | 5    |
      | EINKAUF-2 |      | -2   |               | CHARGE11-2_BG  | nein      | 6    |
      | BAUGRUPPE | 2    |      |               | CHARGE11-2_BG  | ja        | 7    |
      | BAUGRUPPE | 5    |      |               | CHARGE11-1_BG  | ja        | 8    |
      | EINKAUF-1 |      | 4    | CHARGE11-2_E1 | CHARGE11-2_BG  | ja        | 9    |
      | EINKAUF-1 |      | 10   | CHARGE11-1_E1 | CHARGE11-1_BG  | ja        | 10   |
      | EINKAUF-2 |      | 2    |               | CHARGE11-2_BG  | ja        | 11   |
      | EINKAUF-2 |      | 5    |               | CHARGE11-1_BG  | ja        | 12   |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 8
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 10
    And I close the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag11" with command "INVOICE"
    And I set fields
      | ueb  | ja |
      | fakt | ja |
    And I set field "mge" to "10" in row 1
    And I set field "preis" to "80" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | zuomge | charge         | !row |
      | 5      | !CHARGE1_BG^id | 1    |
      | 5      | !CHARGE2_BG^id | +2   |
    And I save the current editor
    And I switch the current editor to editor "auftrag11"
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor


  Scenario: 12 Storno von einer Rückmeldung mit MZ für Komponenten und Fertigteil mit Einheiten mit Behältern
    And I set the fake date to "13.01.1995"
# Auftrag anlegen
    Given I create a SalesOrder "auftrag12" for Customer "RADSHOP" with Product "BG-EINHEITEN" and quantity "50"

# Behälter anlegen
    Given I create a Container "BEH_EINHEITEN1" for packaging material "BEHAELTER"
    Given I create a Container "BEH_EINHEITEN2" for packaging material "BEHAELTER"
    Given I create a Container "BEH_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "BEH_MATERIAL2" for packaging material "BEHAELTER"

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | ebeleg | LS-12   |
      | ueb    | ja      |
      | fakt   | ja      |
      | vom    | .       |
    And I append rows
      | artikel    | mge | preis |
      | GEBINDE    | 50  | 10    |
      | GEBINDEPFL | 5   | 10    |
      | EINKAUF-1  | 10  | 4,5   |
      | BEHAELTER  | 4   | 1     |
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "BEH_MATERIAL1" in row 1
    And I set field "verw" in row 1 to "verw" from editor "auftrag12" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "BEH_MATERIAL2" in row 2
    And I set field "verw" in row 2 to "verw" from editor "auftrag12" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "BEH_MATERIAL2" in row 3
    And I set field "verw" in row 3 to "verw" from editor "auftrag12" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | mfreig |
      | BG-EINHEITEN | 10  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag12" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I append rows
      | zuomge | behaelter      | einh  |
      | 10     | !BEH_MATERIAL1 | Stück |
    And I press button "abv" to open a subeditor for "EntnahmeMZ2"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I append rows
      | zuomge | behaelter      | einh |
      | 5      | !BEH_MATERIAL2 | Paar |
    And I press button "abv" to open a subeditor for "EntnahmeMZ3"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I append rows
      | zuomge | behaelter      | einh  |
      | 10     | !BEH_MATERIAL2 | Stück |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
    And I delete all rows
    And I append rows
      | zuomge | behaelter       | einh  |
      | 8      | !BEH_EINHEITEN1 | Stück |
      | 10     | !BEH_EINHEITEN2 | kg    |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "PROZESS2_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROZESS2_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "9" in row 1
    And I save the current editor

# Behälter prüfen
    And I switch the current editor to editor "BEH_EINHEITEN1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel      | mge | gebeinh |
      | BG-EINHEITEN | 8   | Stück   |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag12" in row 1
    And I close the current editor
    And I switch the current editor to editor "BEH_EINHEITEN2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel      | mge | gebeinh |
      | BG-EINHEITEN | 1   | Stück   |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag12" in row 1
    And I close the current editor
    And I switch the current editor to editor "BEH_MATERIAL1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel | mge | gebeinh |
      | GEBINDE | 1   | Stück   |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag12" in row 1
    And I close the current editor
    And I switch the current editor to editor "BEH_MATERIAL2" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | EINKAUF-1  | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag12" in row 1
    Then field "verw" in row 2 has value equal to field "verw" from editor "auftrag12" in row 1
    And I close the current editor

# Rückmeldung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1"
    And I save the current editor

# Behälter prüfen
    Then Container from editor "BEH_EINHEITEN1" is empty
    Then Container from editor "BEH_EINHEITEN2" is empty
    And I switch the current editor to editor "BEH_MATERIAL1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel | mge | gebeinh |
      | GEBINDE | 10  | Stück   |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag12" in row 1
    And I close the current editor
    And I switch the current editor to editor "BEH_MATERIAL2" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | EINKAUF-1  | 10  | Stück   |
      | GEBINDEPFL | 5   | Paar    |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag12" in row 1
    Then field "verw" in row 2 has value equal to field "verw" from editor "auftrag12" in row 1
    And I close the current editor


  Scenario: 13 Storno von einer Rückmeldung mit MZ für Komponenten und Fertigteil mit Gebindepflicht mit Behältern
    And I set the fake date to "14.01.1995"
# Auftrag anlegen
    Given I create a SalesOrder "auftrag13" for Customer "RADSHOP" with Product "BG-EINHEITENPFL" and quantity "5"

# Behälter anlegen
    Given I create a Container "BEH_EINPFLICHT1" for packaging material "BEHAELTER"
    Given I create a Container "BEH_EINPFLICHT2" for packaging material "BEHAELTER"
    Given I create a Container "BEH_MATPFLICHT1" for packaging material "BEHAELTER"
    Given I create a Container "BEH_MATPFLICHT2" for packaging material "BEHAELTER"

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | ebeleg | LS-12   |
      | ueb    | ja      |
      | fakt   | ja      |
      | vom    | .       |
    And I append rows
      | artikel    | mge | preis |
      | GEBINDE    | 50  | 10    |
      | GEBINDEPFL | 5   | 10    |
      | EINKAUF-1  | 10  | 4,5   |
      | BEHAELTER  | 4   | 1     |
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "BEH_MATPFLICHT1" in row 1
    And I set field "verw" in row 1 to "verw" from editor "auftrag13" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "BEH_MATPFLICHT2" in row 2
    And I set field "verw" in row 2 to "verw" from editor "auftrag13" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "BEH_MATPFLICHT2" in row 3
    And I set field "verw" in row 3 to "verw" from editor "auftrag13" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel         | mge | mfreig |
      | BG-EINHEITENPFL | 10  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag13" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I append rows
      | zuomge | behaelter        | einh  |
      | 10     | !BEH_MATPFLICHT1 | Stück |
    And I press button "abv" to open a subeditor for "EntnahmeMZ2"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I append rows
      | zuomge | behaelter        | einh |
      | 5      | !BEH_MATPFLICHT2 | Paar |
    And I press button "abv" to open a subeditor for "EntnahmeMZ3"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I append rows
      | zuomge | behaelter        | einh  |
      | 10     | !BEH_MATPFLICHT2 | Stück |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
    And I delete all rows
    And I append rows
      | zuomge | behaelter        | einh  |
      | 6      | !BEH_EINPFLICHT1 | Stück |
      | 2      | !BEH_EINPFLICHT2 | Paar  |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "PROZESS2_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROZESS2_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "9" in row 1
    And I save the current editor

# Behälter prüfen
    And I switch the current editor to editor "BEH_EINPFLICHT1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel         | mge | gebeinh |
      | BG-EINHEITENPFL | 6   | Stück   |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag13" in row 1
    And I close the current editor
    And I switch the current editor to editor "BEH_EINPFLICHT2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel         | mge | gebeinh |
      | BG-EINHEITENPFL | 1.5 | Paar    |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag13" in row 1
    And I close the current editor
    And I switch the current editor to editor "BEH_MATPFLICHT1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel | mge | gebeinh |
      | GEBINDE | 1   | Stück   |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag13" in row 1
    And I close the current editor
    And I switch the current editor to editor "BEH_MATPFLICHT2" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | EINKAUF-1  | 1   | Stück   |
      | GEBINDEPFL | 0.5 | Paar    |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag13" in row 1
    Then field "verw" in row 2 has value equal to field "verw" from editor "auftrag13" in row 1
    And I close the current editor

# Rückmeldung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1"
    And I save the current editor

# Behälter prüfen
    Then Container from editor "BEH_EINPFLICHT1" is empty
    Then Container from editor "BEH_EINPFLICHT2" is empty
    And I switch the current editor to editor "BEH_MATPFLICHT1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel | mge | gebeinh |
      | GEBINDE | 10  | Stück   |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag13" in row 1
    And I close the current editor
    And I switch the current editor to editor "BEH_MATPFLICHT2" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | EINKAUF-1  | 10  | Stück   |
      | GEBINDEPFL | 5   | Paar    |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag13" in row 1
    Then field "verw" in row 2 has value equal to field "verw" from editor "auftrag13" in row 1
    And I close the current editor


  Scenario: 14 Storno von einer Rückmeldung mit MZ für Komponenten in verschiedenen Einheiten und Fertigteil mit Gebindepflicht mit Behältern
    And I set the fake date to "15.01.1995"
# Auftrag anlegen
    Given I create a SalesOrder "auftrag14" for Customer "RADSHOP" with Product "BG-EINHEITENPFL" and quantity "5"

# Behälter anlegen
    Given I create a Container "BEH_EINPFLICHT1" for packaging material "BEHAELTER"
    Given I create a Container "BEH_EINPFLICHT2" for packaging material "BEHAELTER"
    Given I create a Container "BEH_MATPFLICHT1" for packaging material "BEHAELTER"
    Given I create a Container "BEH_MATPFLICHT2" for packaging material "BEHAELTER"

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | ebeleg | LS-12   |
      | ueb    | ja      |
      | fakt   | ja      |
      | vom    | .       |
    And I append rows
      | artikel    | mge | preis | he    |
      | GEBINDE    | 50  | 10    | kg    |
      | GEBINDEPFL | 3   | 10    | Paar  |
      | GEBINDEPFL | 4   | 10    | Stück |
      | EINKAUF-1  | 10  | 4,5   | Stück |
      | BEHAELTER  | 4   | 1     | Stück |
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "BEH_MATPFLICHT1" in row 1
    And I set field "verw" in row 1 to "verw" from editor "auftrag14" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "BEH_MATPFLICHT2" in row 2
    And I set field "verw" in row 2 to "verw" from editor "auftrag14" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "BEH_MATPFLICHT1" in row 3
    And I set field "verw" in row 3 to "verw" from editor "auftrag14" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "BEH_MATPFLICHT2" in row 4
    And I set field "verw" in row 4 to "verw" from editor "auftrag14" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel         | mge | mfreig |
      | BG-EINHEITENPFL | 10  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag14" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I append rows
      | zuomge | behaelter        | einh  |
      | 10     | !BEH_MATPFLICHT1 | Stück |
    And I press button "abv" to open a subeditor for "EntnahmeMZ2"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I append rows
      | zuomge | behaelter        | einh  |
      | 3      | !BEH_MATPFLICHT2 | Paar  |
      | 4      | !BEH_MATPFLICHT1 | Stück |
    And I press button "abv" to open a subeditor for "EntnahmeMZ3"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I append rows
      | zuomge | behaelter        | einh  |
      | 10     | !BEH_MATPFLICHT2 | Stück |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
    And I delete all rows
    And I append rows
      | zuomge | behaelter        | einh  |
      | 6      | !BEH_EINPFLICHT1 | Stück |
      | 2      | !BEH_EINPFLICHT2 | Paar  |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "PROZESS2_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROZESS2_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "9" in row 1
    And I save the current editor

# Behälter prüfen
    And I switch the current editor to editor "BEH_EINPFLICHT1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel         | mge | gebeinh |
      | BG-EINHEITENPFL | 6   | Stück   |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag14" in row 1
    And I close the current editor
    And I switch the current editor to editor "BEH_EINPFLICHT2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel         | mge | gebeinh |
      | BG-EINHEITENPFL | 1.5 | Paar    |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag14" in row 1
    And I close the current editor
    And I switch the current editor to editor "BEH_MATPFLICHT1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 1   | Stück   |
      | GEBINDEPFL | 1   | Stück   |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag14" in row 1
    Then field "verw" in row 2 has value equal to field "verw" from editor "auftrag14" in row 1
    And I close the current editor
    And I switch the current editor to editor "BEH_MATPFLICHT2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge | gebeinh |
      | EINKAUF-1 | 1   | Stück   |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag14" in row 1
    And I close the current editor

# Rückmeldung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1"
    And I save the current editor

# Behälter prüfen
    Then Container from editor "BEH_EINPFLICHT1" is empty
    Then Container from editor "BEH_EINPFLICHT2" is empty
    And I switch the current editor to editor "BEH_MATPFLICHT1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 10  | Stück   |
      | GEBINDEPFL | 4   | Stück   |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag14" in row 1
    Then field "verw" in row 2 has value equal to field "verw" from editor "auftrag14" in row 1
    And I close the current editor
    And I switch the current editor to editor "BEH_MATPFLICHT2" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | EINKAUF-1  | 10  | Stück   |
      | GEBINDEPFL | 3   | Paar    |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag14" in row 1
    Then field "verw" in row 2 has value equal to field "verw" from editor "auftrag14" in row 1
    And I close the current editor


  Scenario: 15 Storno einer Rückmeldung Teile retrograd entnommen, vor Storno auf manuelle Entnahme umgestellt
    And I set the fake date to "16.01.1995"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE2" on StorageLocation "F1" with document "KORR-01"
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch    | mfreig | binoloe |
      | BAUGRUPPE2 | 10     | RETRO101_ | ja     | ja      |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag zeigen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RETRO101_000"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RETRO101_002"
    And I set fields
      | sofort | 1   |
      | bzeit  | 1,5 |
      | mzeit  | 1,5 |
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

# Material auf manuelle Entnahme umstellen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "RETRO101_000"
    And I press button "absteig" to open a subeditor for "AFL"
    And I set field "manbu" to "1" in row 1
    And I set field "manbu" to "1" in row 3
    And I save the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I save the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | amge | detursache                   | storniert |
      | BAUGRUPPE2 | -3   |      | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-1  |      | -6   | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-2  |      | -3   | Storno-Rückmeldung Fertigung | nein      |
      | BAUGRUPPE2 | 3    |      | Rückmeldung Fertigung        | ja        |
      | EINKAUF-1  |      | 6    | Rückmeldung Fertigung        | ja        |
      | EINKAUF-2  |      | 3    | Rückmeldung Fertigung        | ja        |
    And I close the current editor
