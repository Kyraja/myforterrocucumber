@persistent
Feature: rueckbau_rueckmeldungen_prozesstests.feature


# Test wurde am 03.02.22 angepasst und jedes Scenario um das Fake Date ergänzt.
# Dadurch sind teilweise Kommentare falsch, die sich auf den vorherigen Zustand beziehen.
# Diese Kommentare werden im Zuge des Test Refactoring des Teams MPS korrigiert.


  Background:
    And I set the fake date to "02.01.1995"


# *****************************************************************************
#  Name             : rueckbau_rueckmeldungen_prozesstests
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet die Prozesse des Rückbaus von Rückmeldungen
#  Jira-Issue       : FDA-537
# *****************************************************************************

## Rückgaben auf einen lebendigen Betriebsauftrag


  Scenario: 01 Teil-Rückbau zu Rückmeldung auf letzten AS
# Bestandskorrektur BAUGRUPPE
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | ARBEITSS_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ARBEITSS_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "5" in row 2
    Then field "kopfzugvorg^id" in row 2 has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Bewertung prüfen
    Given I open an editor "Bewertung_1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ARBEITSS_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-2" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache            | rueckmge | restmge |
      | BAUGRUPPE | -2   |      | Rückbau Fertigung     | -2       | 0       |
      | EINKAUF-1 |      | -4   | Rückbau Fertigung     | -4       | 0       |
      | EINKAUF-2 |      | -2   | Rückbau Fertigung     | -2       | 0       |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung | 2        | 3       |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung | 4        | 6       |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung | 2        | 3       |
    And I close the current editor

# Journaleinträge prüfen
    Given I open an editor "LJ_BG_Rück" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;erbtext1=Rückbau1;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -2 |
      | restmge  | 0  |
      | mge      | -2 |
    And I close the current editor

    Given I open an editor "LJ_BG_Orig" via ID from editor "LJ_BG_Rück" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then field "vorgang^id" in row 0 has value equal to field "id" from editor "Rückmeldung1" in row 0
    Then fields have values
      | rueckmge | 2 |
      | restmge  | 3 |
      | mge      | 5 |
    And I close the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "3" in row 2
    Then field "kopfzugvorg^id" in row 2 has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Bewertung erhält Nachfolger
    Given I switch the current editor to editor "Bewertung_1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_2" via ID from editor "Bewertung_1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ARBEITSS_000"
    Then field "mge" has value "7"
    Then field "rgutmge" has value "0"
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | limge | gmge | !row |
      | 14    | 14   | 1    |
      | 7     | 7    | 2    |
      | 7     | 0.7  | 3    |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ARBEITSS_000"
    And I set fields
      | sofort | ja  |
      | gut    | ja  |
      | mgr    | 112 |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-01"


  Scenario: 02 Gesamt-Rückbau zu Rückmeldung auf letzten AS
    And I set the fake date to "03.01.1995"
# Bestandskorrektur BAUGRUPPE auf 0
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag02" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP2 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag02" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag02" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | ALLES_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag02" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLES_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# Bewertung prüfen
    Given I open an editor "Bewertung_1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "5" in row 2
    Then field "kopfzugvorg^id" in row 2 has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ALLES_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-5" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache            | rueckmge | restmge |
      | BAUGRUPPE | -5   |      | Rückbau Fertigung     | -5       | 0       |
      | EINKAUF-1 |      | -10  | Rückbau Fertigung     | -10      | 0       |
      | EINKAUF-2 |      | -5   | Rückbau Fertigung     | -5       | 0       |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung | 5        | 0       |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung | 10       | 0       |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung | 5        | 0       |
    And I close the current editor

# Journaleinträge prüfen
    Given I open an editor "LJ_BG_Rück" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;erbtext1=Rückbau1;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -5 |
      | restmge  | 0  |
      | mge      | -5 |
    And I close the current editor

    Given I open an editor "LJ_BG_Orig" via ID from editor "LJ_BG_Rück" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then field "vorgang^id" in row 0 has value equal to field "id" from editor "Rückmeldung1" in row 0
    Then fields have values
      | rueckmge | 5 |
      | restmge  | 0 |
      | mge      | 5 |
    And I close the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel | BAUGRUPPE |
      | klplatz | F1        |
      | nullmge | nein      |
      | details | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Bewertung erhält Nachfolger
    Given I switch the current editor to editor "Bewertung_1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_2" via ID from editor "Bewertung_1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ALLES_000"
    Then field "mge" has value "10"
    Then field "rgutmge" has value "0"
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | limge | gmge | !row |
      | 20    | 20   | 1    |
      | 10    | 10   | 2    |
      | 10    | 1.25 | 3    |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLES_000"
    And I set fields
      | sofort | ja  |
      | gut    | ja  |
      | mgr    | 112 |
    And I save the current editor
    Given I deliver the SalesOrder "auftrag02" with PackingSlip "LS-02"


  Scenario: 03 Teil-Rückbau auf Betriebsauftrag, bisher Rückmeldung auf Betriebsauftrag gebucht
    And I set the fake date to "04.01.1995"
# Bestandskorrektur BAUGRUPPE
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag03" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP3 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag03" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag03" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | BETRIEB_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag03" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf Betriebsauftrag
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BETRIEB_000"
    And I set fields
      | sofort | ja  |
      | mgr    | 112 |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# Bewertung prüfen
    Given I open an editor "Bewertung_1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "5" in row 2
    Then field "kopfzugvorg^id" in row 2 has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Rückbau auf Betriebsauftrag
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BETRIEB_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "-2" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache            | rueckmge | restmge |
      | BAUGRUPPE | -2   |      | Rückbau Fertigung     | -2       | 0       |
      | EINKAUF-1 |      | -4   | Rückbau Fertigung     | -4       | 0       |
      | EINKAUF-2 |      | -2   | Rückbau Fertigung     | -2       | 0       |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung | 2        | 3       |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung | 4        | 6       |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung | 2        | 3       |
    And I close the current editor

# Journaleinträge prüfen
    Given I open an editor "LJ_BG_Rück" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;erbtext1=Rückbau1;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -2 |
      | restmge  | 0  |
      | mge      | -2 |
    And I close the current editor

    Given I open an editor "LJ_BG_Orig" via ID from editor "LJ_BG_Rück" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then field "vorgang^id" in row 0 has value equal to field "id" from editor "Rückmeldung1" in row 0
    Then fields have values
      | rueckmge | 2 |
      | restmge  | 3 |
      | mge      | 5 |
    And I close the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "3" in row 2
    Then field "kopfzugvorg^id" in row 2 has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Bewertung erhält Nachfolger
    Given I switch the current editor to editor "Bewertung_1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_2" via ID from editor "Bewertung_1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BETRIEB_000"
    Then field "mge" has value "7"
    Then field "rgutmge" has value "3"
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | limge | gmge | !row |
      | 14    | 14   | 1    |
      | 7     | 7    | 2    |
      | 7     | 0.7  | 3    |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BETRIEB_000"
    And I set fields
      | sofort | ja  |
      | gut    | ja  |
      | mgr    | 112 |
    And I save the current editor
    Given I deliver the SalesOrder "auftrag03" with PackingSlip "LS-03"


  Scenario: 04 Setzen Statuskennzeichen im Rückbaus schließt den AS ab
    And I set the fake date to "05.01.1995"
# Auftrag anlegen und  Bedarfe einkaufen
    Given I create a SalesOrder "auftrag04" for Customer "RADSHOP" with Product "BAUGRUPPE2" and quantity "10"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP4 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag04" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag04" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben, Löschschutz setzen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch  | mfreig | binoloe |
      | BAUGRUPPE2 | 10     | STATUS_ | ja     | ja      |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag04" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang, keine Gutmengenbuchung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STATUS_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "9" in row 1
    And I save the current editor

# Rückbau auf ersten Arbeitsgang, Status setzen und Statusfeld in Arbeitsschein prüfen
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "STATUS_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-1" in row 1
    And I set field "status" to "s" in row 1
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "STATUS_001"
    Then fields have values
      | status  | S |
      | mge     | 2 |
      | rgutmge | 8 |
    And I close the current editor

# Rückmeldung auf zweiten Arbeitsgang, Gutmengenbuchung
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STATUS_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "9" in row 1
    And I save the current editor

# Rückbau auf zweiten Arbeitsgang, Status setzen und Statusfeld in Arbeitsschein prüfen
    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "STATUS_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-1" in row 1
    And I set field "status" to "s" in row 1
    And I respond with answer "ja" to the dialog with id "1483"
    And I save the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "STATUS_002"
    Then fields have values
      | status  | S |
      | mge     | 2 |
      | rgutmge | 8 |
    And I close the current editor

# Betriebsauftrag abschließen, Auftrag liefern
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STATUS_002"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "STATUS_000"
    And I set field "noloesch" to "nein"
    And I save the current editor

    Given I deliver the SalesOrder "auftrag04" with PackingSlip "LS-04"


  Scenario: 05 Positive Zeiten im Rückbaubeleg erhöhen die Herstellkosten
    And I set the fake date to "06.01.1995"
# Bestandskorrektur BAUGRUPPE
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag05" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP5 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag05" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag05" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | KOSTEN_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag05" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KOSTEN_000"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOSTEN_001"
    And I set fields
      | sofort   | ja   |
      | rzbuchen | nein |
      | bzeit    | 0.5  |
      | mzeit    | 0.5  |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Kalkulationsblatt prüfen
    And I run Revaluation
    Given I open an editor "KBlatt" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for record "$,,artikel=BAUGRUPPE;typ=Nachkalkulation;@richtung=rückwärts;@maxtreffer=1"
    Then table has values
      | !row | eeinzk | evzeit | ksart             | ekart  |
      | 5    | 0.7500 | 0.5    | aus der Fertigung | Lohn   |
      | 6    | 1.5000 | 0.5    | aus der Fertigung | FK fix |
      | 7    | 2.7500 | 0.5    | aus der Fertigung | FK var |
    And I close the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "KOSTEN_001"
    And I set fields
      | sofort | ja  |
      | bzeit  | 0.5 |
      | mzeit  | 0.5 |
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor

# Nachkaklulieren und Nachkalkulation prüfen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "banummer" to "nummer" from editor "Betriebsauftrag"
    And I press button "ladetab"
    And I press button "bunkalk" to open a subeditor for "nachkalk" in row 1
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

    And I switch the current editor to editor "KBlatt" with command "VIEW"
    Then table has values
      | !row | eeinzk | evzeit | ksart             | ekart  |
      | 5    | 1.5000 | 1      | aus der Fertigung | Lohn   |
      | 6    | 2.0000 | 1      | aus der Fertigung | FK fix |
      | 7    | 3.5000 | 1      | aus der Fertigung | FK var |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOSTEN_001"
    And I set fields
      | sofort   | ja   |
      | rzbuchen | nein |
      | gut      | ja   |
      | bzeit    | 0.5  |
      | mzeit    | 0.5  |
    And I save the current editor
    Given I deliver the SalesOrder "auftrag05" with PackingSlip "LS-05"

# Nachkalkulation prüfen
    And I run Revaluation
    And I switch the current editor to editor "KBlatt" with command "VIEW"
    Then table has values
      | !row | eeinzk | evzeit | ksart             | ekart  |
      | 3    | 2.2500 | 1.5    | aus der Fertigung | Lohn   |
      | 4    | 2.5000 | 1.5    | aus der Fertigung | FK fix |
      | 5    | 4.2500 | 1.5    | aus der Fertigung | FK var |
    And I close the current editor


  Scenario: 06 Teil-Rückbau zu Rückmeldung auf letzten AS, bisher Gutmenge über RM in einen Behälter gebucht
    And I set the fake date to "07.01.1995"
# Bestandskorrektur BEHAELTER
    Given I set StorageQuantity to zero for Product "BEHAELTER" on StorageLocation "F1"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag06" for Customer "RADSHOP" with Product "BG-BEHAELTER" and quantity "10"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP6 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 20  |
      | EINKAUF-2  | 10  |
      | BEHAELTER  | 4   |
      | EU-PALETTE | 1   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag06" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag06" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Behälter anlegen
    Given I create a Container "BEHAELTER_1" for packaging material "BEHAELTER" and search word "BEHAELTER_1"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch  | mfreig |
      | BG-BEHAELTER | 10     | WORKED_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag06" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "WORKED_001"
    And I set field "sofort" to "1"
    And I set field "behaelter" to id from editor "BEHAELTER_1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "WORKED_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-2" in row 1
    Then field "buplatz" has value "F1" in row 1
    And I set field "behaelter" to "nummer" from editor "BEHAELTER_1"
    Then field "buplatz" is not modifiable in row 1
    And I save the current editor

# Behälter prüfen
    Given I switch the current editor to editor "BEHAELTER_1" with command "VIEW"
    Then field "mge" has value "3" in row 1
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BEHAELTER |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "4" in row 2
    Then field "kopfzugvorg^id" in row 2 has value equal to field "id" from editor "RechnungLager" in row 0
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | zmge | amge | detursache            | rueckmge | restmge |
      | BG-BEHAELTER | -2   |      | Rückbau Fertigung     | -2       | 0       |
      | EINKAUF-1    |      | -4   | Rückbau Fertigung     | -4       | 0       |
      | EINKAUF-2    |      | -2   | Rückbau Fertigung     | -2       | 0       |
      | BG-BEHAELTER | 5    |      | Rückmeldung Fertigung | 2        | 3       |
      | EINKAUF-1    |      | 10   | Rückmeldung Fertigung | 4        | 6       |
      | EINKAUF-2    |      | 5    | Rückmeldung Fertigung | 2        | 3       |
    Then field "behaelter^id" in row 1 has value equal to field "behaelter^id" from editor "LJ" in row 4
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "WORKED_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I set field "behaelter" to "nummer" from editor "BEHAELTER_1"
    And I save the current editor

    And I switch the current editor to editor "auftrag06" with command "DELIVERY"
    And I set fields
      | ueb | ja |
    And I set field "mge" to "10" in row 1
    And I press button "packvor"
    And I set field "behaelter" to id from editor "BEHAELTER_1" in row 1
    And I respond with answer "ja" to the dialog with id "8076"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel | BEHAELTER |
      | klplatz | F1        |
      | details | nein      |
    And I press start
    Then the table has 1 rows
    Then table has values
      | tartikel  | lemge |
      | BEHAELTER |       |
    And I close the current editor


# FDA-951: Packmittelbestand erhöht sich durch Umbuchung über LBuchung, wenn beide Behälter dann leer werden
  Scenario: 07 Teil-Rückbau bucht Behälter ins Negative, wenn Behälter leer ist oder nicht ausreichend Menge enthält, bisher Rückmeldung in Behälter, dann Gutmenge in einen anderen Behälter umgebucht
    And I set the fake date to "08.01.1995"
# Bestandskorrektur BEHAELTER und BG-BEHAELTER
    Given I set StorageQuantity to zero for Product "BEHAELTER" on StorageLocation "F1"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag07" for Customer "RADSHOP" with Product "BG-BEHAELTER" and quantity "10"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP7 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 20  |
      | EINKAUF-2  | 10  |
      | BEHAELTER  | 4   |
      | EU-PALETTE | 1   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag07" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag07" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Behälter anlegen
    Given I create a Container "BEHAELTER_1" for packaging material "BEHAELTER" and search word "BEHAELTER_1"
    Given I create a Container "BEHAELTER_2" for packaging material "BEHAELTER" and search word "BEHAELTER_2"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch | mfreig |
      | BG-BEHAELTER | 10     | ALLES_ | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag07" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLES_001"
    And I set field "sofort" to "1"
    And I set field "behaelter" to id from editor "BEHAELTER_1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Behälterinhalt in BEHAELTER_2 umbuchen
    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | BG-BEHAELTER |
      | beldat  | .            |
      | beleg   | 4711         |
      | buart   | Umbuchung    |
    And I modify table
      | mge | platz | platz2 | !row |
      | 5   | F1    | F1     | 1    |
    And I set field "verw" in row 1 to "verw" from editor "auftrag07" in row 1
    And I set field "verw2" in row 1 to "verw" from editor "auftrag07" in row 1
    And I set field "behaelter" to id from editor "BEHAELTER_1" in row 1
    And I set field "behaelterzu" to id from editor "BEHAELTER_2" in row 1
    And I save the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ALLES_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-5" in row 1
    And I set field "erbtext1" to "alles_001_rb2" in row 1
    And I set field "behaelter" to "nummer" from editor "BEHAELTER_1"
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | zmge | amge | detursache            | rueckmge | restmge |
      | BG-BEHAELTER | -5   |      | Rückbau Fertigung     | -5       | 0       |
      | EINKAUF-1    |      | -10  | Rückbau Fertigung     | -10      | 0       |
      | EINKAUF-2    |      | -5   | Rückbau Fertigung     | -5       | 0       |
      | BG-BEHAELTER | 5    |      | Rückmeldung Fertigung | 5        | 0       |
      | EINKAUF-1    |      | 10   | Rückmeldung Fertigung | 10       | 0       |
      | EINKAUF-2    |      | 5    | Rückmeldung Fertigung | 5        | 0       |
    Then field "behaelter^id" in row 1 has value equal to field "behaelter^id" from editor "LJ" in row 4
    And I close the current editor

# BEHAELTER_1 und BEHALTER_2 prüfen
    Given I switch the current editor to editor "BEHAELTER_1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel      | mge |
      | BG-BEHAELTER | -5  |
    And I close the current editor
    Given I switch the current editor to editor "BEHAELTER_2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel      | mge |
      | BG-BEHAELTER | 5   |
    And I close the current editor

# BEHAELTER_1 und _2 korrigieren
    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | BG-BEHAELTER |
      | beldat  | .            |
      | beleg   | 4711         |
      | buart   | Umbuchung    |
    And I modify table
      | mge | platz | platz2 | !row |
      | 5   | F1    | F1     | 1    |
    And I set field "verw" in row 1 to "verw" from editor "auftrag07" in row 1
    And I set field "behaelter" to id from editor "BEHAELTER_2" in row 1
    And I set field "verw2" in row 1 to "verw" from editor "auftrag07" in row 1
    And I set field "behaelterzu" to id from editor "BEHAELTER_1" in row 1
    And I save the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLES_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I set field "behaelter" to id from editor "BEHAELTER_1"
    And I save the current editor

# Behälter prüfen
    Then Container from editor "BEHAELTER_2" is empty
    And I switch the current editor to editor "BEHAELTER_1"
    Then the table has 1 rows
    Then table has values
      | artikel      | mge |
      | BG-BEHAELTER | 10  |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag07" in row 1
    And I close the current editor

# Auftrag ausliefern und Bestände prüfen
    And I switch the current editor to editor "auftrag07" with command "DELIVERY"
    And I set fields
      | ueb | ja |
    And I set field "mge" to "10" in row 1
    And I set field "behaelter" to id from editor "BEHAELTER_1" in row 1
    And I press button "packvor"
    And I save the current editor

#Given I open the infosystem "BESTAND"
#And I set fields
#	| artikel	| BEHAELTER	|
#	| verdichten	| ja		|
#   | details     | nein  |
#And I press start
#Then the table has 1 rows
#Then table has values
#	| tartikel	| lemge		|
#	| BEHAELTER	| 0			|
#And I close the current editor


  Scenario: 08 Rückbau möglich, wenn Gutmenge in Behälter auf einem anderen Lagerplatz liegt, Prüfung auf Übereinstimmung Lagerplatz
    And I set the fake date to "09.01.1995"
# Bestandskorrektur BEHAELTER und Behälter anlegen
    Given I set StorageQuantity to zero for Product "BEHAELTER" on StorageLocation "F1"
    Given I create a Container "BEHAELTER_8" for packaging material "BEHAELTER" and search word "BEHAELTER_8"

# Auftrag anlegen und BEdarfe einkaufen
    Given I create a SalesOrder "auftrag08" for Customer "RADSHOP" with Product "M_BG-BEHAELTER" and quantity "10"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP8 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 20  |
      | EINKAUF-2  | 10  |
      | BEHAELTER  | 4   |
      | EU-PALETTE | 1   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag08" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag08" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel        | netmge | bisuch | mfreig |
      | M_BG-BEHAELTER | 10     | ALLES_ | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag08" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme Behälter
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=ALLES_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stllad"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLES_001"
    And I set field "sofort" to "1"
    And I set field "behaelter" to id from editor "BEHAELTER_8"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Bewertung prüfen
    Given I open an editor "Bewertung_1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=M_BG-BEHAELTER;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Behälter auf anderen Lagerplatz umbuchen
    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel   | M_BG-BEHAELTER |
      | beldat    | .              |
      | beleg     | 4711           |
      | buart     | Umbuchung      |
      | mkvwunsch | ja             |
    And I modify table
      | mge | platz | platz2 | !row |
      | 5   | F1    | F2     | 1    |
    And I set field "verw" in row 1 to "verw" from editor "auftrag08" in row 1
    And I set field "verw2" in row 1 to "verw" from editor "auftrag08" in row 1
    And I set field "behaelter" to id from editor "BEHAELTER_8" in row !lastRow
    And I set field "behaelterzu" to id from editor "BEHAELTER_8" in row !lastRow
    And I save the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ALLES_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-5" in row 1
    And I set field "erbtext1" to "alles_001_rb3" in row 1
    Then field "buplatz" has value "F1" in row 1
    And I set field "behaelter" to "nummer" from editor "BEHAELTER_8"
    Then field "buplatz" has value "F2" in row 1
    Then field "buplatz" is not modifiable in row 1
    And I save the current editor

# Bewertung erhält Nachfolger
    Given I switch the current editor to editor "Bewertung_1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_2" via ID from editor "Bewertung_1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern, Bestaand Behälter prüfen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLES_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I set field "behaelter" to id from editor "BEHAELTER_8"
    And I set field "buplatz" to "F2" in row 1
    And I save the current editor

    And I run Scheduling
    Given I switch the current editor to editor "auftrag08" with command "DELIVERY"
    And I set field "ueb" to "ja"
    And I modify table
      | mge | platz | !row |
      | 10  | F2    | 1    |
    And I press button "packvor"
    And I set field "behaelter" to id from editor "BEHAELTER_8" in row 1
    And I respond with answer "ja" to the dialog with id "8076"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel | BEHAELTER |
      | klplatz | F1        |
      | details | nein      |
    And I press start
    Then the table has 1 rows
    Then table has values
      | tartikel  | lemge |
      | BEHAELTER |       |
    And I close the current editor


## Scenario: 09 Im Rückbaubeleg können für retrograd gebuchte oder neue Teile keine Zeilen hinzugefügt werden, Gutmenge des Fertigteils kann maximal die bereits gebuchte Gutmenge sein
## zu Plausichecks


  Scenario: 10 Teil-Rückbau zu Rückmeldung auf letzten AS, FV zu bedarfsbezogener Gutmenge
    And I set the fake date to "10.01.1995"
# Bestandskorrektur B_BAUGRUPPE
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag10" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch    |
      | B_BAUGRUPPE | 50     | ja     | RUECKBAU_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau10 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag10" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag10" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKBAU_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "30" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# Bewertung prüfen
    Given I open an editor "Bewertung_1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=B_BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Rückbau1 zu Betriebsauftrag
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RUECKBAU_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-20" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# Bewertung erhält Nachfolger
    Given I switch the current editor to editor "Bewertung_1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_2" via ID from editor "Bewertung_1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "10" in row 2
    Then field "kopfzugvorg^id" in row 2 has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# rueckmge und restmge in Rückbau und Rückmeldung prüfen
    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -20      | 0       | -20   | 30     | 10     |
      | B_EINKAUF-2 | -20      | 0       | -20   | 20     | 40     |
      | B_EINKAUF-1 | -40      | 0       | -40   | 40     | 80     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 20       | 10      | 30    | 0      | 30     |
      | B_EINKAUF-2 | 20       | 10      | 30    | 50     | 20     |
      | B_EINKAUF-1 | 40       | 20      | 60    | 100    | 40     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | detursache            | rueckbew |
      | B_BAUGRUPPE | -20  |      | -20      | 0       | Rückbau Fertigung     | ja       |
      | B_EINKAUF-1 |      | -40  | -40      | 0       | Rückbau Fertigung     | ja       |
      | B_EINKAUF-2 |      | -20  | -20      | 0       | Rückbau Fertigung     | ja       |
      | B_BAUGRUPPE | 30   |      | 20       | 10      | Rückmeldung Fertigung | nein     |
      | B_EINKAUF-1 |      | 60   | 40       | 20      | Rückmeldung Fertigung | nein     |
      | B_EINKAUF-2 |      | 30   | 20       | 10      | Rückmeldung Fertigung | nein     |
    And I close the current editor

# Lagerjournal-Einträge prüfen, Verweis auf Rückbau
    Given I open an editor "LJ_Baugruppe" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=B_BAUGRUPPE;erbtext1=Rückbau1;mge=-20;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -20 |
      | restmge  | 0   |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Baugruppe_Orig" via ID from editor "LJ_Baugruppe" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 30 |
      | rueckmge | 20 |
      | restmge  | 10 |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKBAU_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then field "lemge" has value "50" in row 1
    Then field "kopfzugvorg^id" in row 3 has value equal to field "id" from editor "Rückmeldung2" in row 0
    And I close the current editor

    Given I deliver the SalesOrder "auftrag10" with PackingSlip "LS-10"

  Scenario: 11 Teil-Rückbau zu Rückmeldung mit Zeitbuchung auf letzten AS, FV zu bedarfsbezogener Gutmenge
    And I set the fake date to "11.01.1995"
# Bestandskorrektur B_BAUGRUPPE
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag11" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "50"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch     |
      | B_BAUGRUPPE | 50     | ja     | RUECKZEIT_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau11 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag11" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag11" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKZEIT_001"
    And I set fields
      | sofort | ja |
      | bzeit  | 3  |
      | mzeit  | 3  |
    And I set field "gutmge" to "30" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# Bewertung prüfen
    Given I open an editor "Bewertung_1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=B_BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Rückbau1 zu Betriebsauftrag
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RUECKZEIT_001"
    And I set fields
      | sofort | ja |
      | bzeit  | 1  |
      | mzeit  | 1  |
    And I set field "gutmge" to "-20" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then field "lemge" has value "10" in row 1
    Then field "kopfzugvorg^id" in row 2 has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Bewertung erhält Nachfolger
    Given I switch the current editor to editor "Bewertung_1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_2" via ID from editor "Bewertung_1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# rueckmge und restmge in Rückbau prüfen
    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then fields have values
      | bzeit | 1 |
      | mzeit | 1 |
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -20      | 0       | -20   | 30     | 10     |
      | B_EINKAUF-2 | -20      | 0       | -20   | 20     | 40     |
      | B_EINKAUF-1 | -40      | 0       | -40   | 40     | 80     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then fields have values
      | bzeit | 3 |
      | mzeit | 3 |
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 20       | 10      | 30    | 0      | 30     |
      | B_EINKAUF-2 | 20       | 10      | 30    | 50     | 20     |
      | B_EINKAUF-1 | 40       | 20      | 60    | 100    | 40     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | detursache            | rueckbew |
      | B_BAUGRUPPE | -20  |      | -20      | 0       | Rückbau Fertigung     | ja       |
      | B_EINKAUF-1 |      | -40  | -40      | 0       | Rückbau Fertigung     | ja       |
      | B_EINKAUF-2 |      | -20  | -20      | 0       | Rückbau Fertigung     | ja       |
      | B_BAUGRUPPE | 30   |      | 20       | 10      | Rückmeldung Fertigung | nein     |
      | B_EINKAUF-1 |      | 60   | 40       | 20      | Rückmeldung Fertigung | nein     |
      | B_EINKAUF-2 |      | 30   | 20       | 10      | Rückmeldung Fertigung | nein     |
    And I close the current editor

# Lagerjournal-Einträge prüfen, Verweis auf Rückbau
    Given I open an editor "LJ_Baugruppe" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=B_BAUGRUPPE;erbtext1=Rückbau1;mge=-20;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -20 |
      | restmge  | 0   |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Baugruppe_Orig" via ID from editor "LJ_Baugruppe" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 30 |
      | rueckmge | 20 |
      | restmge  | 10 |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKZEIT_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then field "lemge" has value "50" in row 1
    Then field "kopfzugvorg^id" in row 3 has value equal to field "id" from editor "Rückmeldung2" in row 0
    And I close the current editor

    Given I deliver the SalesOrder "auftrag11" with PackingSlip "LS-11"


  Scenario: 12 Teil-Rückbau, der zwei Rückmeldung auf letzten AS betrifft, FV zu bedarfsbezogener Gutmenge
    And I set the fake date to "12.01.1995"
# Bestandskorrektur B_BAUGRUPPE
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag12" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "50"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | vom    | .        |
      | ebeleg | Rückbau1 |
      | ueb    | ja       |
      | fakt   | ja       |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch     |
      | B_BAUGRUPPE | 50     | ja     | ZWEIRUECK_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung1 und Rückmeldung2 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEIRUECK_001"
    And I set fields
      | sofort | ja |
      | vom    | -1 |
    And I set field "gutmge" to "20" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEIRUECK_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "20" in row 1
    And I set field "erbtext1" to "Rückmeldung2" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

# Rückbau1
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ZWEIRUECK_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-15" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# rueckmge und restmge in Rückbau1 und zugehöriger Rückmeldung prüfen
    Given I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -15      | 0       | -15   | 40     | 25     |
      | B_EINKAUF-2 | -15      | 0       | -15   | 10     | 25     |
      | B_EINKAUF-1 | -30      | 0       | -30   | 20     | 50     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 15       | 5       | 20    | 20     | 40     |
      | B_EINKAUF-2 | 15       | 5       | 20    | 30     | 10     |
      | B_EINKAUF-1 | 30       | 10      | 40    | 60     | 20     |
    And I close the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 25    |        | (0,0,0)          |
      |       | 20     | !Rückmeldung1^id |
      |       | 5      | !Rückmeldung2^id |
    And I close the current editor

# Rückbau2 zu Betriebsauftrag
    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ZWEIRUECK_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-10" in row 1
    And I set field "erbtext1" to "Rückbau2" in row 1
    And I save the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "15" in row 2
    Then field "kopfzugvorg^id" in row 2 has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Lagerbewegungsjournal
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | amge | zmge | rueckmge | restmge | detursache            | rueckbew | !row |
      | B_BAUGRUPPE |      | -5   | -5       | 0       | Rückbau Fertigung     | ja       | 1    |
      | B_BAUGRUPPE |      | -5   | -5       | 0       | Rückbau Fertigung     | ja       | 2    |
      | B_EINKAUF-1 | -10  |      | -10      | 0       | Rückbau Fertigung     | ja       | 3    |
      | B_EINKAUF-1 | -10  |      | -10      | 0       | Rückbau Fertigung     | ja       | 4    |
      | B_EINKAUF-2 | -5   |      | -5       | 0       | Rückbau Fertigung     | ja       | 5    |
      | B_EINKAUF-2 | -5   |      | -5       | 0       | Rückbau Fertigung     | ja       | 6    |
      | B_BAUGRUPPE |      | -15  | -15      | 0       | Rückbau Fertigung     | ja       | 7    |
      | B_EINKAUF-1 | -30  |      | -30      | 0       | Rückbau Fertigung     | ja       | 8    |
      | B_EINKAUF-2 | -15  |      | -15      | 0       | Rückbau Fertigung     | ja       | 9    |
      | B_BAUGRUPPE |      | 20   | 20       | 0       | Rückmeldung Fertigung | nein     | 10   |
      | B_EINKAUF-1 | 40   |      | 40       | 0       | Rückmeldung Fertigung | nein     | 11   |
      | B_EINKAUF-2 | 20   |      | 20       | 0       | Rückmeldung Fertigung | nein     | 12   |
      | B_BAUGRUPPE |      | 20   | 5        | 15      | Rückmeldung Fertigung | nein     | 13   |
      | B_EINKAUF-1 | 40   |      | 10       | 30      | Rückmeldung Fertigung | nein     | 14   |
      | B_EINKAUF-2 | 20   |      | 5        | 15      | Rückmeldung Fertigung | nein     | 15   |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 10
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 13
    Then field "rueckorig^id" in row 7 has value equal to field "verweis^id" from editor "LJ" in row 10
    And I close the current editor

# rueckmge und restmge in Rückbau1 und Rückbau2 prüfen
    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -15      | 0       | -15   | 40     | 25     |
      | B_EINKAUF-2 | -15      | 0       | -15   | 10     | 25     |
      | B_EINKAUF-1 | -30      | 0       | -30   | 20     | 50     |
    And I close the current editor

    And I switch the current editor to editor "Rückbau2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -10      | 0       | -10   | 25     | 15     |
      | B_EINKAUF-2 | -10      | 0       | -10   | 25     | 35     |
      | B_EINKAUF-1 | -20      | 0       | -20   | 50     | 70     |
    And I close the current editor

# rueckmge und restmge in Rückmeldung1 und Rückmeldung2 prüfen
    Given I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge |
      | B_BAUGRUPPE | 20       | 0       |
      | B_EINKAUF-2 | 20       | 0       |
      | B_EINKAUF-1 | 40       | 0       |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge |
      | B_BAUGRUPPE | 5        | 15      |
      | B_EINKAUF-2 | 5        | 15      |
      | B_EINKAUF-1 | 10       | 30      |
    And I close the current editor

# Lagerjournaleinträge zu Rückbau1 und Rückbau2 prüfen
    Given I open an editor "LJ_Rückbau1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=B_BAUGRUPPE;erbtext1=Rückbau1;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -15 |
      | restmge  | 0   |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Rückmeldung2" via ID from editor "LJ_Rückbau1" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 20 |
      | rueckmge | 20 |
      | restmge  | 0  |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung2"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEIRUECK_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag12" with PackingSlip "LS-12"


  Scenario: 13 Teil-Rückbau zu Rückmeldung, bisher Rückmeldung hat Material mit Verwendung und aus Jokerbestand gebucht
    And I set the fake date to "13.01.1995"
# Bestände korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_SCEN13"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1"

# Auftrag anlegen und Hälfte der Bedarfe einkaufen (Verwendung)
    Given I create a SalesOrder "auftrag13" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "60"
    Given I open an editor "RechnungmL" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | fakt   | ja      |
      | ebeleg | 13R     |
      | ueb    | ja      |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 60  |
      | EINKAUF-1 | 60  |
      | EINKAUF-2 | 60  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag13" in row 1
    And I set field "verw" in row 2 to "nummer" from editor "auftrag13" in row 0
    And I set field "verw" in row 3 to "verw" from editor "auftrag13" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | bisuch | mfreig |
      | BAUGRUPPE | 60  | JOKER_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag13" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "JOKER_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "50" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# bestände auf 0 bringen, WICHTIG FÜR SPIEGELBILDLICHEN VERGLEICH, s. dazu in der storno-feature-datei
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "B_SCEN132"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_SCEN132"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "B_SCEN132"

	# TODO @uo: Prüfungen schlagen fehl
# sicher keine bestände mehr!
#Given I query "platz,gebmge,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==EINKAUF-1;platz==F1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;"
#Then query has no hits
#Given I query "platz,gebmge,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==EINKAUF-2;platz==F1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;"
#Then query has no hits
#Given I query "platz,gebmge,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==BAUGRUPPE;platz==F1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;"
#Then query has no hits

# Rückbau1 zu Betriebsauftrag  JOKER_001
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "JOKER_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-45" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

		# TODO @uo: Prüfungen schlagen fehl
#Given I query "lgruppe,platz,charge,projekt,gebmge,1:verw,1:lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==EINKAUF-1;platz==F1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;"
#Then query has values
#|  lgruppe|platz|charge|projekt|gebmge|  1:verw|1:lffert|bewmge|
#|KARLSRUHE|   F1|      |       |    40|  200015|        |    40|
#|KARLSRUHE|   F1|      |       |    50|200015_1|        |    50|
#
#Given I query "lgruppe,platz,charge,projekt,gebmge,1:verw,1:lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==EINKAUF-2;platz==F1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;"
#Then query has values
#|  lgruppe|platz|charge|projekt|gebmge|  1:verw|1:lffert|bewmge|
#|KARLSRUHE|   F1|      |       |    45|200015_1|        |    45|
#
#Given I query "lgruppe,platz,charge,projekt,gebmge,1:verw,1:lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==BAUGRUPPE;platz==F1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;"
#Then query has values
#|  lgruppe|platz|charge|projekt|gebmge|  1:verw|1:lffert|bewmge|
#|KARLSRUHE|   F1|      |       |   -45|200015_1|        |   -45|

# Lagerbewegungsjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | -10       |
      | edatum   | +30       |
      | richtung | rückwärts |
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I press start
    Then table has values
      | art       | zmge | amge | rueckmge | restmge | detursache            | !row |
      | BAUGRUPPE | -45  |      | -45      | 0       | Rückbau Fertigung     | 1    |
      | EINKAUF-1 |      | -50  | -50      | 0       | Rückbau Fertigung     | 2    |
      | EINKAUF-1 |      | -40  | -40      | 0       | Rückbau Fertigung     | 3    |
      | EINKAUF-2 |      | -45  | -45      | 0       | Rückbau Fertigung     | 4    |
      | BAUGRUPPE | 50   |      | 45       | 5       | Rückmeldung Fertigung | 5    |
      | EINKAUF-1 |      | 40   | 40       | 0       | Rückmeldung Fertigung | 6    |
      | EINKAUF-1 |      | 60   | 50       | 10      | Rückmeldung Fertigung | 7    |
      | EINKAUF-2 |      | 50   | 45       | 5       | Rückmeldung Fertigung | 8    |
# Jokerbestand wird durch Rückbau vollständig zurückgebucht
    Then field "verwla" in row 3 has value equal to field "verw" from editor "RechnungmL" in row 2
# Restliche Rückbuchung Bestand mit eindeutiger  Verwendung
    Then field "verwla" in row 2 has value equal to field "verw" from editor "RechnungmL" in row 1
    And I close the current editor

# Lagerjournal prüfen
    Given I open an editor "LJ_Rückbau1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;erbtext1=Rückbau1;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -45 |
      | restmge  | 0   |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Rückmeldung_Orig" via ID from editor "LJ_Rückbau1" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 50 |
      | rueckmge | 45 |
      | restmge  | 5  |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "JOKER_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag13" with PackingSlip "LS-13"

    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "B_SCEN133"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_SCEN133"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "B_SCEN133"


  Scenario: 14 Teil-Rückbau zu Rückmeldung auf letzten AS, FertigteilMZ mit Chargen, EntnahmeMZ mit Chargen vor Freigabe FV angelegt
    And I set the fake date to "14.01.1995"
# Chargen anlegen
    Given I create a Lot "B_MATERIAL1" for Product "B_EINKAUF-1"
    Given I create a Lot "B_MATERIAL2" for Product "B_EINKAUF-1"
    Given I create a Lot "B_BG1" for Product "B_BAUGRUPPE"
    Given I create a Lot "B_BG2" for Product "B_BAUGRUPPE"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag14" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "50"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | vom    | .        |
      | ebeleg | Rückbau1 |
      | ueb    | ja       |
      | fakt   | ja       |
    And I append rows
      | artikel     | mge | charge          |
      | B_EINKAUF-1 | 60  | !B_MATERIAL1^id |
      | B_EINKAUF-1 | 40  | !B_MATERIAL2^id |
      | B_EINKAUF-2 | 50  |                 |
    And I set field "verw" in row 1 to "verw" from editor "auftrag14" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag14" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag14" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig |
      | B_BAUGRUPPE | 50     | ja     |
    And I press button "mzsubm" to open a subeditor for "MZFertig" in row 1
    And I delete all rows
    And I append rows
      | zuomge | charge    |
      | 10     | !B_BG1^id |
      | 25     | !B_BG2^id |
      | 15     |           |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzabsm" to open a subeditor for "MZMaterial" in row 1
    And I delete all rows
    And I append rows
      | zuomge | charge          |
      | 60     | !B_MATERIAL1^id |
      | 40     | !B_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "CHRUECKBAU_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHRUECKBAU_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "40" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor


# bestände auf 0 bringen, WICHTIG FÜR SPIEGELBILDLICHEN VERGLEICH,
# s. dazu in der storno-feature-datei CHRUECKBAU_001

# Bestandskorrektur B_BAUGRUPPE: für eine einfachere spätere platzmengenkontrolle
    Given I open an editor "Bestandskorrektur" for tip command "LBestand" and arguments ""
    And I set fields
      | artikel | B_BAUGRUPPE |
      | beleg   | chrueckb01  |
      | beldat  | .           |
    And I set field "platz" to "F1" in row 1
    Then the table has 3 rows
    And I modify table
      | !row | mge |
      | 1    | 0   |
      | 2    | 0   |
      | 3    | 0   |
    And I save the current editor
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "chrueckb01"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1" with document "chrueckb01"

		# TODO @uo: Prüfungen schlagen fehl
# sicher keine bestände mehr!
#Given I query "platz,gebmge,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==B_EINKAUF-1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;"
#Then query has no hits
#Given I query "platz,gebmge,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==B_EINKAUF-2;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;"
#Then query has no hits
#Given I query "platz,gebmge,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==B_BAUGRUPPE;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;"
#Then query has no hits

# Rückbau1 zu Betriebsauftrag  CHRUECKBAU_001
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "CHRUECKBAU_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-10" in row 1
    And I set field "charge" to "B_BG1" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# Rückbau2 zu Betriebsauftrag  CHRUECKBAU_001
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "CHRUECKBAU_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-25" in row 1
    And I set field "charge" to "B_BG2" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor


# rueckmge und restmge in Rückbau und Rückmeldung prüfen
    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -25      | 0       | -25   | 30     | 5      |
      | B_EINKAUF-2 | -25      | 0       | -25   | 20     | 45     |
      | B_EINKAUF-1 | -50      | 0       | -50   | 40     | 90     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | ncharge^such |
      | B_BAUGRUPPE | -25  |      | -25      | 0       |              | B_BG2        |
      | B_EINKAUF-1 |      | -40  | -40      | 0       | B_MATERIAL1  | B_BG2        |
      | B_EINKAUF-1 |      | -10  | -10      | 0       | B_MATERIAL2  | B_BG2        |
      | B_EINKAUF-2 |      | -25  | -25      | 0       |              | B_BG2        |
      | B_BAUGRUPPE | -10  |      | -10      | 0       |              | B_BG1        |
      | B_EINKAUF-1 |      | -20  | -20      | 0       | B_MATERIAL1  | B_BG1        |
      | B_EINKAUF-2 |      | -10  | -10      | 0       |              | B_BG1        |
      | B_BAUGRUPPE | 5    |      | 0        | 5       |              |              |
      | B_BAUGRUPPE | 25   |      | 25       | 0       |              | B_BG2        |
      | B_BAUGRUPPE | 10   |      | 10       | 0       |              | B_BG1        |
      | B_EINKAUF-1 |      | 10   | 0        | 10      | B_MATERIAL2  |              |
      | B_EINKAUF-1 |      | 10   | 10       | 0       | B_MATERIAL2  | B_BG2        |
      | B_EINKAUF-1 |      | 40   | 40       | 0       | B_MATERIAL1  | B_BG2        |
      | B_EINKAUF-1 |      | 20   | 20       | 0       | B_MATERIAL1  | B_BG1        |
      | B_EINKAUF-2 |      | 5    | 0        | 5       |              |              |
      | B_EINKAUF-2 |      | 25   | 25       | 0       |              | B_BG2        |
      | B_EINKAUF-2 |      | 10   | 10       | 0       |              | B_BG1        |
    And I close the current editor

# Lagerjournal-Einträge prüfen, Verweis auf Rückbau
    Given I open an editor "LJ_Rückbau1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=B_BAUGRUPPE;ursache=Fertigung;mge=-25;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -25 |
      | restmge  | 0   |
    Then field "ncharge^such" has value "B_BG2" in row 1
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Rückmeldung_Orig" via ID from editor "LJ_Rückbau1" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 25 |
      | rueckmge | 25 |
      | restmge  | 0  |
    Then field "ncharge^such" has value "B_BG2" in row 1
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

		# TODO @uo: Prüfungen schlagen fehl
#Given I query "lgruppe,platz,charge,projekt,gebmge,1:verw,1:lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==B_EINKAUF-1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;"
#Then query has values
#|  lgruppe|platz|charge|projekt|gebmge|1:verw|1:lffert|bewmge|
#|KARLSRUHE|   F1|     7|       |    50|      |        |    50|
#|KARLSRUHE|   F1|     8|       |    20|      |        |    20|
#|KARLSRUHE|     |      |       |    70|      |        |     0|
#
#Given I query "lgruppe,platz,charge,projekt,gebmge,1:verw,1:lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==B_EINKAUF-2;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;"
#Then query has values
#|  lgruppe|lager|platz|charge|projekt|gebmge|1:verw|1:lffert|bewmge|
#|KARLSRUHE|   L1|   F1|      |       |    35|      |        |    35|
#|KARLSRUHE|   L1|     |      |       |    35|      |        |     0|
#
#Given I query "lgruppe,platz,charge,projekt,gebmge,1:verw,1:lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==B_BAUGRUPPE;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;"
#Then query has values
#|  lgruppe|lager|platz|charge|projekt|gebmge|1:verw|1:lffert|bewmge|
#|KARLSRUHE|   L1|   F1|      |       |    -5|      |        |    -5|
#|KARLSRUHE|   L1|   F1|     9|       |    -5|      |        |    -5|
#|KARLSRUHE|   L1|   F1|    10|       |   -25|      |        |   -25|
#|KARLSRUHE|   L1|     |      |       |   -35|      |        |     0|

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHRUECKBAU_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    And I switch the current editor to editor "auftrag14" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "50" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | zuomge | charge    | !row |
      | 10     | !B_BG1^id | 1    |
      | 25     | !B_BG2^id | +2   |
      | 15     |           | +3   |
    And I save the current editor
    And I switch the current editor to editor "auftrag14"
    And I save the current editor


  Scenario: 15 A Teil-Rückbau, der zwei Rückmeldung auf letzten AS betrifft, FertigteilMZ mit Chargen, EntnahmeMZ mit Chargen vor Freigabe FV angelegt
    And I set the fake date to "15.01.1995"
# Chargen anlegen
    Given I create a Lot "B_MATERIAL" for Product "B_EINKAUF-1"
    Given I create a Lot "B_BG1-15" for Product "B_BAUGRUPPE"
    Given I create a Lot "B_BG2-15" for Product "B_BAUGRUPPE"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag15" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "50"

    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | vom    | .        |
      | ebeleg | Rückbau1 |
      | ueb    | ja       |
      | fakt   | ja       |
    And I append rows
      | artikel     | mge | charge         |
      | B_EINKAUF-1 | 60  | !B_MATERIAL^id |
      | B_EINKAUF-1 | 40  |                |
      | B_EINKAUF-2 | 50  |                |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig |
      | B_BAUGRUPPE | 50     | ja     |
    And I press button "mzsubm" to open a subeditor for "MZFertig" in row 1
    And I delete all rows
    And I append rows
      | zuomge | charge         |
      | 10     | !B_BG1-15^id   |
      | 25     | !B_BG2-15^id   |
      | 15     |                |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzabsm" to open a subeditor for "MZMaterial" in row 1
    And I delete all rows
    And I append rows
      | zuomge | charge         |
      | 60     | !B_MATERIAL^id |
      | 40     |                |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "CHZWEIRUECK_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  Scenario Outline: 15 B Teil-Rückbau, der zwei Rückmeldung auf letzten AS betrifft, FertigteilMZ mit Chargen , EntnahmeMZ mit Chargen vor Freigabe FV angelegt
    And I set the fake date to "16.01.1995"
# Rückmeldungen, Rückbau1 auf ersten Arbeitsgang
    And I wait <timeunit> time units to move the time forward

    Given I open an editor "<editor>" from table "(Workorder):(WorkOrders)" with command "<command>" for record "CHZWEIRUECK_001"
    And I set fields
      | sofort  | ja        |
      | kcharge | <kcharge> |
    And I set field "gutmge" to "<gutmge>" in row 1
    And I set field "erbtext1" to "<erbtext1>" in row 1
    And I save the current editor

    Examples:
      | editor       | kcharge      | gutmge | command | erbtext1     | timeunit |
      | Rückmeldung1 | !B_BG1-15^id | 10     | DONE    | Rückmeldung1 | 1        |
      | Rückmeldung2 | !B_BG2-15^id | 10     | DONE    | Rückmeldung2 | 2        |
      | Rückmeldung3 | !B_BG2-15^id | 15     | DONE    | Rückmeldung3 | 3        |
      | Rückmeldung4 |              | 5      | DONE    | Rückmeldung4 | 4        |
      | Rückbau1     | !B_BG2-15^id | -20    | RETURN  | Rückbau1     | 4        |

  Scenario: 15 C Teil-Rückbau, der zwei Rückmeldung auf letzten AS betrifft, FertigteilMZ mit Chargen, EntnahmeMZ mit Chargen vor Freigabe FV angelegt
    And I set the fake date to "17.01.1995"
# rueckmge und restmge in Rückbau1 und Rückmeldungen prüfen
    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -20      | 0       | -20   | 40     | 20     |
      | B_EINKAUF-2 | -20      | 0       | -20   | 10     | 30     |
      | B_EINKAUF-1 | -40      | 0       | -40   | 20     | 60     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung4" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 5       | 5     | 35     | 40     |
      | B_EINKAUF-2 | 0        | 5       | 5     | 15     | 10     |
      | B_EINKAUF-1 | 0        | 10      | 10    | 30     | 20     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung3" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 15       | 0       | 15    | 20     | 35     |
      | B_EINKAUF-2 | 15       | 0       | 15    | 30     | 15     |
      | B_EINKAUF-1 | 30       | 0       | 30    | 60     | 30     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 5        | 5       | 10    | 10     | 20     |
      | B_EINKAUF-2 | 5        | 5       | 10    | 40     | 30     |
      | B_EINKAUF-1 | 10       | 10      | 20    | 80     | 60     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 10      | 10    | 0      | 10     |
      | B_EINKAUF-2 | 0        | 10      | 10    | 50     | 40     |
      | B_EINKAUF-1 | 0        | 20      | 20    | 100    | 80     |
    And I close the current editor

# Rückbau2 zu Arbeitsschein zum Zeitpunkt 17.01.1995 14:54:00
    Given I set the fake date to "17.01.95 14:54:00"
    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "CHZWEIRUECK_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-5" in row 1
    And I set field "charge" to "!B_BG2-15^id" in row 1
    And I set field "erbtext1" to "Rückbau2" in row 1
    And I save the current editor

# Rückbau2 zu Arbeitsschein zum Zeitpunkt 17.01.1995 15:00:00
    Given I set the fake date to "17.01.95 15:00:00"
    Given I open an editor "Rückbau3" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "CHZWEIRUECK_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-10" in row 1
    And I set field "charge" to "!B_BG1-15^id" in row 1
    And I set field "erbtext1" to "Rückbau3" in row 1
    And I save the current editor

# Lagerbewegungsjournal
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | ncharge^such | vcharge^such | rueckbew | !row |
      | B_BAUGRUPPE | -10  |      | -10      | 0       | B_BG1-15     |              | ja       | 1    |
      | B_EINKAUF-1 |      | -20  | -20      | 0       | B_BG1-15     | B_MATERIAL   | ja       | 2    |
      | B_EINKAUF-2 |      | -10  | -10      | 0       | B_BG1-15     |              | ja       | 3    |
      | B_BAUGRUPPE | -5   |      | -5       | 0       | B_BG2-15     |              | ja       | 4    |
      | B_EINKAUF-1 |      | -10  | -10      | 0       | B_BG2-15     | B_MATERIAL   | ja       | 5    |
      | B_EINKAUF-2 |      | -5   | -5       | 0       | B_BG2-15     |              | ja       | 6    |
      | B_BAUGRUPPE | -15  |      | -15      | 0       | B_BG2-15     |              | ja       | 7    |
      | B_BAUGRUPPE | -5   |      | -5       | 0       | B_BG2-15     |              | ja       | 8    |
      | B_EINKAUF-1 |      | -10  | -10      | 0       | B_BG2-15     | B_MATERIAL   | ja       | 9    |
      | B_EINKAUF-1 |      | -20  | -20      | 0       | B_BG2-15     | B_MATERIAL   | ja       | 10   |
      | B_EINKAUF-1 |      | -10  | -10      | 0       | B_BG2-15     |              | ja       | 11   |
      | B_EINKAUF-2 |      | -5   | -5       | 0       | B_BG2-15     |              | ja       | 12   |
      | B_EINKAUF-2 |      | -15  | -15      | 0       | B_BG2-15     |              | ja       | 13   |
      | B_BAUGRUPPE | 5    |      | 0        | 5       |              |              | nein     | 14   |
      | B_EINKAUF-1 |      | 10   | 0        | 10      |              |              | nein     | 15   |
      | B_EINKAUF-2 |      | 5    | 0        | 5       |              |              | nein     | 16   |
      | B_BAUGRUPPE | 15   |      | 15       | 0       | B_BG2-15     |              | nein     | 17   |
      | B_EINKAUF-1 |      | 10   | 10       | 0       | B_BG2-15     |              | nein     | 18   |
      | B_EINKAUF-1 |      | 20   | 20       | 0       | B_BG2-15     | B_MATERIAL   | nein     | 19   |
      | B_EINKAUF-2 |      | 15   | 15       | 0       | B_BG2-15     |              | nein     | 20   |
      | B_BAUGRUPPE | 10   |      | 10       | 0       | B_BG2-15     |              | nein     | 21   |
      | B_EINKAUF-1 |      | 20   | 20       | 0       | B_BG2-15     | B_MATERIAL   | nein     | 22   |
      | B_EINKAUF-2 |      | 10   | 10       | 0       | B_BG2-15     |              | nein     | 23   |
      | B_BAUGRUPPE | 10   |      | 10       | 0       | B_BG1-15     |              | nein     | 24   |
      | B_EINKAUF-1 |      | 20   | 20       | 0       | B_BG1-15     | B_MATERIAL   | nein     | 25   |
      | B_EINKAUF-2 |      | 10   | 10       | 0       | B_BG1-15     |              | nein     | 26   |
    And I close the current editor

# rueckmge und restmge in Rückbau2 und Rückmeldungen prüfen
    And I switch the current editor to editor "Rückbau3" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -10      | 0       | -10   | 15     | 5      |
      | B_EINKAUF-2 | -10      | 0       | -10   | 35     | 45     |
      | B_EINKAUF-1 | -20      | 0       | -20   | 70     | 90     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung4" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 5       | 5     | 35     | 40     |
      | B_EINKAUF-2 | 0        | 5       | 5     | 15     | 10     |
      | B_EINKAUF-1 | 0        | 10       | 10    | 30     | 20     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung3" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 15       | 0       | 15    | 20     | 35     |
      | B_EINKAUF-2 | 15       | 0       | 15    | 30     | 15     |
      | B_EINKAUF-1 | 30       | 0       | 30    | 60     | 30     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 10       | 0       | 10    | 10     | 20     |
      | B_EINKAUF-2 | 10       | 0       | 10    | 40     | 30     |
      | B_EINKAUF-1 | 20       | 0       | 20    | 80     | 60     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 10       | 0       | 10    | 0      | 10     |
      | B_EINKAUF-2 | 10       | 0       | 10    | 50     | 40     |
      | B_EINKAUF-1 | 20       | 0       | 20    | 100    | 80     |
    And I close the current editor

  Scenario Outline: 15 D Teil-Rückbau, der zwei Rückmeldung auf letzten AS betrifft, FertigteilMZ mit Chargen, EntnahmeMZ mit Chargen vor Freigabe FV angelegt
    And I set the fake date to "18.01.1995"
# Lagerjournaleinträge zu Rückbau1 und Rückbau2 prüfen
    Given I open an editor "<editor>" from table "(Journal):(Journal)" with command "VIEW" for search criteria "<search_criteria>"
    Then fields have values
      | rueckmge | <rueckmge> |
      | restmge  | <restmge>  |
    Then field "vorgang^id" has value equal to field "id" from editor "<vorgang>"
    And I close the current editor

    And I open an editor "LJ_Baugruppe_Orig" via ID from editor "<editor>" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | <mge_orig>      |
      | rueckmge | <rueckmge_orig> |
      | restmge  | <restmge_orig>  |
    Then field "<field>" has value "<charge>" in row <row>
    Then field "vorgang^id" has value equal to field "id" from editor "<vorgang_orig>"
    And I close the current editor

    Examples:
      | vorgang  | editor        | rueckmge | restmge | mge_orig | rueckmge_orig | restmge_orig | vorgang_orig | field        | charge      | row | search_criteria                                                                    |
      | Rückbau3 | LJ_Rückbau3_1 | -10      | 0       | 10       | 10            | 0            | Rückmeldung1 | ncharge^such | B_BG1-15    | 1   | $,,artikel=B_BAUGRUPPE;mge=-10;erbtext1=Rückbau3;@richtung=rückwärts;@maxtreffer=1 |
      | Rückbau2 | LJ_Rückbau2_1 | -5       | 0       | 10       | 10            | 0            | Rückmeldung2 | ncharge^such | B_BG2-15    | 1   | $,,artikel=B_BAUGRUPPE;mge=-5;erbtext1=Rückbau2;@richtung=rückwärts;@maxtreffer=1  |
      | Rückbau1 | LJ_Rückbau1_2 | -15      | 0       | 15       | 15            | 0            | Rückmeldung3 | ncharge^such | B_BG2-15    | 1   | $,,artikel=B_BAUGRUPPE;mge=-15;erbtext1=Rückbau1;@richtung=rückwärts;@maxtreffer=1 |
      | Rückbau1 | LJ_Rückbau1_1 | -5       | 0       | 10       | 10            | 0            | Rückmeldung2 | ncharge^such | B_BG2-15    | 1   | $,,artikel=B_BAUGRUPPE;mge=-5;erbtext1=Rückbau1;@richtung=rückwärts;@maxtreffer=1  |

# Betriebsauftrag abschließen
  Scenario: 15 E Teil-Rückbau, der zwei Rückmeldung auf letzten AS betrifft, FertigteilMZ mit Chargen, EntnahmeMZ mit Chargen vor Freigabe FV angelegt
    And I set the fake date to "19.01.1995"
    And I wait 4 time units to move the time forward
    Given I open an editor "Rückmeldung5" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHZWEIRUECK_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    And I switch the current editor to editor "auftrag15" with command "DELIVERY"
    And I set field "ueb" to "ja"
    And I set field "mge" to "50" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | zuomge | charge         | !row |
      | 10     | !B_BG1-15^id   | 1    |
      | 25     | !B_BG2-15^id   | +2   |
      | 15     |                | +3   |
    And I save the current editor
    And I switch the current editor to editor "auftrag15"
    And I save the current editor


  Scenario: 16 Teil-Rückbau zu Rückmeldung auf letzten AS, FV mit Projekt und AFL mit auftrags- und bedarfsbezogenem Material freigegeben
    And I set the fake date to "20.01.1995"
# Bestände auf 0
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "B_SCEN16"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"

# Projekt anlegen
    Given I open an editor "PROJEKT_BG16" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT_BG16"
    And I set field "such" to "PROJEKT_BG16"
    And I save the current editor

# Auftrag anlegen
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I append rows
      | artikel   | mge | projekt      |
      | BAUGRUPPE | 50  | PROJEKT_BG16 |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I modify table
      | elex        | elanzahl    | !row |
      | !dontChange | !dontChange | -1   |
      | !dontChange | !dontChange | -1   |
      | B_EINKAUF-1 | 2           | +1   |
      | B_EINKAUF-2 | 1           | +2   |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set fields
      | artikel | BAUGRUPPE |
    And I press button "ladetab"
    And I modify table
      | !row                                      | mfreig | bisuch   |
      | projekt=="PROJEKT_BG16" && mfreig=="nein" | ja     | PROJEKT_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROJEKT_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "40" in row 1
    And I save the current editor

# Rückbau1 zu Betriebsauftrag
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "PROJEKT_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-35" in row 1
    And I save the current editor

# Lagerjournal und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | projekt      | projektla | detursache            |
      | BAUGRUPPE   | -35  |      | PROJEKT_BG16 | ja        | Rückbau Fertigung     |
      | B_EINKAUF-1 |      | -70  | PROJEKT_BG16 | nein      | Rückbau Fertigung     |
      | B_EINKAUF-2 |      | -35  | PROJEKT_BG16 | nein      | Rückbau Fertigung     |
      | BAUGRUPPE   | 40   |      | PROJEKT_BG16 | ja        | Rückmeldung Fertigung |
      | B_EINKAUF-1 |      | 80   | PROJEKT_BG16 | nein      | Rückmeldung Fertigung |
      | B_EINKAUF-2 |      | 40   | PROJEKT_BG16 | nein      | Rückmeldung Fertigung |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then field "projekt" is empty in row 2
    Then field "projekt" is empty in row 3
    And I close the current editor

# Lagerjournal-Einträge prüfen, Verweis auf Rückbau
    Given I open an editor "LJ_Baugruppe" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;mge=-35;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge     | -35          |
      | restmge      | 0            |
      | projekt^such | PROJEKT_BG16 |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Baugruppe_Orig" via ID from editor "LJ_Baugruppe" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge          | 40           |
      | rueckmge     | 35           |
      | restmge      | 5            |
      | projekt^such | PROJEKT_BG16 |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Betriebsauftrag und Auftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROJEKT_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-16"


  Scenario: 17 A Teil-Rückbau, der zwei Rückmeldungen auf letzten AS betrifft, FV mit Projekt, Material auftrags- und bedarfsbezogen freigegeben
    And I set the fake date to "21.01.1995"
# Projekt anlegen
    Given I open an editor "PROJEKT2_BG17" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT2_BG17"
    And I set field "such" to "PROJEKT2_BG17"
    And I save the current editor

# Auftrag anlegen, bedrafsbezogenes Teil in AFL, um Projektweitergabe beim Buchen zu testen
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I append rows
      | artikel   | mge | projekt       |
      | BAUGRUPPE | 50  | PROJEKT2_BG17 |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I modify table
      | elex        | elanzahl    | !row |
      | !dontChange | !dontChange | -2   |
      | B_EINKAUF-2 | 1           | +2   |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel     | mge | projekt       |
      | EINKAUF-1   | 100 | PROJEKT2_BG17 |
      | B_EINKAUF-2 | 50  |               |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | projekt       | mfreig |
      | BAUGRUPPE | 50  | PROJEKT2_BG17 | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I modify table
      | elex        | elanzahl    | !row |
      | !dontChange | !dontChange | -2   |
      | B_EINKAUF-2 | 1           | +2   |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "PROJEKT2_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  Scenario Outline: 17 B Teil-Rückbau, der zwei Rückmeldungen auf letzten AS betrifft, FV mit Projekt, Material auftrags- und bedarfsbezogen freigegeben
    And I set the fake date to "22.01.1995"
# Rückmeldungen, Rückbau1 auf ersten Arbeitsgang
    And I wait <timeunit> time units to move the time forward

    Given I open an editor "<editor>" from table "(Workorder):(WorkOrders)" with command "<command>" for record "PROJEKT2_001"
    And I set fields
      | sofort | ja |
    And I modify table
      | !row | gutmge   | erbtext1   |
      | 1    | <gutmge> | <erbtext1> |
    And I save the current editor

    Examples:
      | editor       | gutmge | command | erbtext1     | timeunit |
      | Rückmeldung1 | 10     | DONE    | Rückmeldung1 | 1        |
      | Rückmeldung2 | 10     | DONE    | Rückmeldung2 | 2        |
      | Rückmeldung3 | 15     | DONE    | Rückmeldung3 | 3        |
      | Rückmeldung4 | 5      | DONE    | Rückmeldung4 | 4        |
      | Rückbau1     | -22    | RETURN  | Rückbau1     | 4        |

  Scenario: 17 C Teil-Rückbau, der zwei Rückmeldungen auf letzten AS betrifft, FV mit Projekt, Material auftrags- und bedarfsbezogen freigegeben
    And I set the fake date to "23.01.1995"
# rueckmge und restmge in Rückbau1 und Rückmeldungen prüfen
    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE   | -22      | 0       | -22   | 40     | 18     |
      | B_EINKAUF-2 | -22      | 0       | -22   | 10     | 32     |
      | EINKAUF-1   | -44      | 0       | -44   | 20     | 64     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung4" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE   | 5        | 0       | 5     | 35     | 40     |
      | B_EINKAUF-2 | 5        | 0       | 5     | 15     | 10     |
      | EINKAUF-1   | 10       | 0       | 10    | 30     | 20     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung3" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE   | 15       | 0       | 15    | 20     | 35     |
      | B_EINKAUF-2 | 15       | 0       | 15    | 30     | 15     |
      | EINKAUF-1   | 30       | 0       | 30    | 60     | 30     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE   | 2        | 8       | 10    | 10     | 20     |
      | B_EINKAUF-2 | 2        | 8       | 10    | 40     | 30     |
      | EINKAUF-1   | 4        | 16      | 20    | 80     | 60     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE   | 0        | 10      | 10    | 0      | 10     |
      | B_EINKAUF-2 | 0        | 10      | 10    | 50     | 40     |
      | EINKAUF-1   | 0        | 20      | 20    | 100    | 80     |
    And I close the current editor

# Lagerbewegungsjournal
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | projekt       | projektla | !row |
      | BAUGRUPPE   | -5   |      | -5       | 0       | PROJEKT2_BG17 | ja        | 1    |
      | BAUGRUPPE   | -15  |      | -15      | 0       | PROJEKT2_BG17 | ja        | 2    |
      | BAUGRUPPE   | -2   |      | -2       | 0       | PROJEKT2_BG17 | ja        | 3    |
      | EINKAUF-1   |      | -4   | -4       | 0       | PROJEKT2_BG17 | ja        | 4    |
      | EINKAUF-1   |      | -30  | -30      | 0       | PROJEKT2_BG17 | ja        | 5    |
      | EINKAUF-1   |      | -10  | -10      | 0       | PROJEKT2_BG17 | ja        | 6    |
      | B_EINKAUF-2 |      | -2   | -2       | 0       | PROJEKT2_BG17 | nein      | 7    |
      | B_EINKAUF-2 |      | -15  | -15      | 0       | PROJEKT2_BG17 | nein      | 8    |
      | B_EINKAUF-2 |      | -5   | -5       | 0       | PROJEKT2_BG17 | nein      | 9    |
      | BAUGRUPPE   | 5    |      | 5        | 0       | PROJEKT2_BG17 | ja        | 10   |
      | EINKAUF-1   |      | 10   | 10       | 0       | PROJEKT2_BG17 | ja        | 11   |
      | B_EINKAUF-2 |      | 5    | 5        | 0       | PROJEKT2_BG17 | nein      | 12   |
      | BAUGRUPPE   | 15   |      | 15       | 0       | PROJEKT2_BG17 | ja        | 13   |
      | EINKAUF-1   |      | 30   | 30       | 0       | PROJEKT2_BG17 | ja        | 14   |
      | B_EINKAUF-2 |      | 15   | 15       | 0       | PROJEKT2_BG17 | nein      | 15   |
      | BAUGRUPPE   | 10   |      | 2        | 8       | PROJEKT2_BG17 | ja        | 16   |
      | EINKAUF-1   |      | 20   | 4        | 16      | PROJEKT2_BG17 | ja        | 17   |
      | B_EINKAUF-2 |      | 10   | 2        | 8       | PROJEKT2_BG17 | nein      | 18   |
      | BAUGRUPPE   | 10   |      | 0        | 10      | PROJEKT2_BG17 | ja        | 19   |
      | EINKAUF-1   |      | 20   | 0        | 20      | PROJEKT2_BG17 | ja        | 20   |
      | B_EINKAUF-2 |      | 10   | 0        | 10      | PROJEKT2_BG17 | nein      | 21   |
    And I close the current editor

# Betriebsauftrag und Auftrag abschließen
# Hier wird die Restmenge des Betriebsauftrags aus Scenario 17 B rueckgemeldet
    And I set the fake date to "24.01.1995"
    And I wait 4 time units to move the time forward
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROJEKT2_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-17"

  Scenario Outline: 17 D Teil-Rückbau, der zwei Rückmeldungen auf letzten AS betrifft, FV mit Projekt, Material auftrags- und bedarfsbezogen freigegeben
    And I set the fake date to "25.01.1995"
# Lagerjournaleinträge zu Rückbau1 und Rückbau2 prüfen
    Given I open an editor "<editor>" from table "(Journal):(Journal)" with command "VIEW" for search criteria "<search_criteria>"
    Then fields have values
      | rueckmge | <rueckmge> |
      | restmge  | <restmge>  |
    Then field "vorgang^id" has value equal to field "id" from editor "<vorgang>"
    And I close the current editor

    And I open an editor "LJ_Baugruppe_Orig" via ID from editor "<editor>" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | <mge_orig>      |
      | rueckmge | <rueckmge_orig> |
      | restmge  | <restmge_orig>  |
      | projekt  | PROJEKT2_BG17   |
    Then field "vorgang^id" has value equal to field "id" from editor "<vorgang_orig>"
    And I close the current editor
    Examples:
      | editor        | rueckmge | restmge | vorgang  | mge_orig | rueckmge_orig | restmge_orig | vorgang_orig | search_criteria                                                                  |
      | LJ_Rückbau1_1 | -2       | 0       | Rückbau1 | 10       | 2             | 8            | Rückmeldung2 | $,,artikel=BAUGRUPPE;mge=-2;erbtext1=Rückbau1;@richtung=rückwärts;@maxtreffer=1  |
      | LJ_Rückbau1_2 | -15      | 0       | Rückbau1 | 15       | 15            | 0            | Rückmeldung3 | $,,artikel=BAUGRUPPE;mge=-15;erbtext1=Rückbau1;@richtung=rückwärts;@maxtreffer=1 |
      | LJ_Rückbau1_3 | -5       | 0       | Rückbau1 | 5        | 5             | 0            | Rückmeldung4 | $,,artikel=BAUGRUPPE;mge=-5;erbtext1=Rückbau1;@richtung=rückwärts;@maxtreffer=1  |


  Scenario: 18 Rückbau gemischt auf Arbeitsschein und Betriebsauftrag nach Rückmeldungen auf AS und BA
    And I set the fake date to "26.01.1995"
# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | bisuch | mfreig |
      | BAUGRUPPE | 10  | AS_BA_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Zwei Rückmeldungen auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AS_BA_001"
    And I set fields
      | sofort | ja |
    And I set field "bem" to "AS_BA_011"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward
# 1 = "04.02.1995"

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AS_BA_001"
    And I set fields
      | sofort | ja |
    And I set field "bem" to "AS_BA_012"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward
# 1 = "04.02.1995"

# Rückmeldung auf Betriebsauftrag
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AS_BA_000"
    And I set fields
      | sofort | ja  |
      | mgr    | 112 |
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward
# 1 = "04.02.1995"

# Rückbau1 auf Arbeistschein 1 und Betriebsauftrag
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "AS_BA_001"
    And I set fields
      | sofort | ja |
    And I set field "bem" to "AS_BA_013"
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor
    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "AS_BA_000"
    And I set fields
      | sofort | ja  |
      | mgr    | 112 |
    And I set field "gutmge" to "-6" in row 1
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache            | rueckmge | restmge | !row |
      | BAUGRUPPE | 3    |      | Rückmeldung Fertigung | 2        | 1       | 1    |
      | EINKAUF-1 |      | 6    | Rückmeldung Fertigung | 4        | 2       | 2    |
      | EINKAUF-2 |      | 3    | Rückmeldung Fertigung | 2        | 1       | 3    |
      | BAUGRUPPE | 2    |      | Rückmeldung Fertigung | 0        | 2       | 4    |
      | EINKAUF-1 |      | 4    | Rückmeldung Fertigung | 0        | 4       | 5    |
      | EINKAUF-2 |      | 2    | Rückmeldung Fertigung | 0        | 2       | 6    |
    And I set field "beleg" to "barmex" from editor "Rückmeldung3"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache            | rueckmge | restmge | !row |
      | BAUGRUPPE | -3   |      | Rückbau Fertigung     | -3       | 0       | 1    |
      | BAUGRUPPE | -2   |      | Rückbau Fertigung     | -2       | 0       | 2    |
      | EINKAUF-1 |      | -4   | Rückbau Fertigung     | -4       | 0       | 3    |
      | EINKAUF-1 |      | -6   | Rückbau Fertigung     | -6       | 0       | 4    |
      | EINKAUF-2 |      | -2   | Rückbau Fertigung     | -2       | 0       | 5    |
      | EINKAUF-2 |      | -3   | Rückbau Fertigung     | -3       | 0       | 6    |
      | BAUGRUPPE | 3    |      | Rückmeldung Fertigung | 3        | 0       | 7    |
      | EINKAUF-1 |      | 6    | Rückmeldung Fertigung | 6        | 0       | 8    |
      | EINKAUF-2 |      | 3    | Rückmeldung Fertigung | 3        | 0       | 9    |
    Then field "rueckorig^vorgang^id" in row 2 has value equal to field "id" from editor "Rückmeldung2" in row 0
    Then field "rueckorig^vorgang^id" in row 1 has value equal to field "id" from editor "Rückmeldung3" in row 0
    And I close the current editor

# Offene Mengen im FV prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "AS_BA_000"
    Then fields have values
      | mge     | 7 |
      | rgutmge | 2 |
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | elex       | gmge | limge |
      | EINKAUF-1  | 14   | 14    |
      | EINKAUF-2  | 7    | 7     |
      | A MONTAGE1 | 0.7  | 7     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

# Betriebsauftrag und Auftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AS_BA_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I set field "bem" to "AS_BA_014"
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-18"


  Scenario: 19 Rückbau, der zwei Rückmeldungen auf letzten AS betrifft, EntnahmeMZ mit Einheiten vor Freigabe FV angelegt
    And I set the fake date to "27.01.1995"
# Bestandskorrektur BAUGRUPPE und Auftrag anlegen
    Given I set StorageQuantity to zero for Product "BG-EINHEITEN" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1"

    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITEN" and quantity "20"

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ebeleg | RückbauP19 |
      | ueb    | ja         |
      | fakt   | ja         |
    And I append rows
      | artikel    | mge |
      | GEBINDE    | 30  |
      | GEBINDEPFL | 3   |
      | EINKAUF-1  | 6   |
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben, Betriebsauftrag aufrufen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig |
      | BG-EINHEITEN | 6      | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "mzabsm" to open a subeditor for "MZ_Entnahme" in row !lastRow
    And I press button "abv" to open a subeditor for "MZ_Entnahme1"
    And I close the current editor
    And I switch the current editor to editor "MZ_Entnahme"
    And I modify table
      | zuomge | einh | !row |
      | 2      | Paar | +1   |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "EINHEIT_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "EINHEIT_000"
    And I close the current editor

# Rückmeldungen auf ersten Arbeitsgang in Lagereinheit und Bewertungen prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINHEIT_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

    Given I open an editor "Bewertung_1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BG-EINHEITEN;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINHEIT_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

    Given I open an editor "Bewertung_2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BG-EINHEITEN;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung2"
    And I close the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITEN |
      | klplatz    | F1           |
      | verdichten | nein         |
      | details    | nein         |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 3     |        | (0,0,0)          |
      |       | 2      | !Rückmeldung1^id |
      |       | 1      | !Rückmeldung2^id |
    And I close the current editor

# Rückbau auf ersten Arbeitsschein, bucht laut Fertigungsliste in Einheit Stück zurück.
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "EINHEIT_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-3" in row 1
    And I set field "erbtext1" to "1-Rückbau" in row 1
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-30"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | zmge | amge | mei   | detursache            | rueckmge | restmge | !row |
      | BG-EINHEITEN | -1   |      | Stück | Rückbau Fertigung     | -1       | 0       | 1    |
      | BG-EINHEITEN | -2   |      | Stück | Rückbau Fertigung     | -2       | 0       | 2    |
      | GEBINDE      |      | -2   | Stück | Rückbau Fertigung     | -2       | 0       | 3    |
      | GEBINDE      |      | -1   | Stück | Rückbau Fertigung     | -1       | 0       | 4    |
      | GEBINDEPFL   |      | -2   | Stück | Rückbau Fertigung     | -2       | 0       | 5    |
      | GEBINDEPFL   |      | -1   | Stück | Rückbau Fertigung     | -1       | 0       | 6    |
      | EINKAUF-1    |      | -2   | Stück | Rückbau Fertigung     | -2       | 0       | 7    |
      | EINKAUF-1    |      | -1   | Stück | Rückbau Fertigung     | -1       | 0       | 8    |
      | BG-EINHEITEN | 1    |      | Stück | Rückmeldung Fertigung | 1        | 0       | 9    |
      | GEBINDE      |      | 1    | Stück | Rückmeldung Fertigung | 1        | 0       | 10   |
      | GEBINDEPFL   |      | 0.5  | Paar  | Rückmeldung Fertigung | 1        | 0       | 11   |
      | EINKAUF-1    |      | 1    | Stück | Rückmeldung Fertigung | 1        | 0       | 12   |
      | BG-EINHEITEN | 2    |      | Stück | Rückmeldung Fertigung | 2        | 0       | 13   |
      | GEBINDE      |      | 2    | Stück | Rückmeldung Fertigung | 2        | 0       | 14   |
      | GEBINDEPFL   |      | 1    | Paar  | Rückmeldung Fertigung | 2        | 0       | 15   |
      | EINKAUF-1    |      | 2    | Stück | Rückmeldung Fertigung | 2        | 0       | 16   |
    And I close the current editor

# Journaleinträge prüfen
    Given I open an editor "LJ_BG_Rück1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BG-EINHEITEN;mge=-2;erbtext1=1-Rückbau;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -2 |
      | restmge  | 0  |
      | mge      | -2 |
    And I close the current editor

    Given I open an editor "LJ_BG_Orig1" via ID from editor "LJ_BG_Rück1" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then field "vorgang^id" in row 0 has value equal to field "id" from editor "Rückmeldung1" in row 0
    Then fields have values
      | rueckmge | 2 |
      | restmge  | 0 |
      | mge      | 2 |
    And I close the current editor

    Given I open an editor "LJ_BG_Rück2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BG-EINHEITEN;mge=-1;erbtext1=1-Rückbau;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -1 |
      | restmge  | 0  |
      | mge      | -1 |
    And I close the current editor

    Given I open an editor "LJ_BG_Orig2" via ID from editor "LJ_BG_Rück2" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then field "vorgang^id" in row 0 has value equal to field "id" from editor "Rückmeldung2" in row 0
    Then fields have values
      | rueckmge | 1 |
      | restmge  | 0 |
      | mge      | 1 |
    And I close the current editor

# Bewertungen erhalten Nachfolger
    Given I switch the current editor to editor "Bewertung_1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_3" via ID from editor "Bewertung_1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    Given I switch the current editor to editor "Bewertung_2" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_4" via ID from editor "Bewertung_2" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung2"
    And I close the current editor

# MZ wieder anlegen, BA abschließen und Auftrag liefern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "banummer" to "nummer" from editor "Betriebsauftrag"
    And I press button "ladetab"
    Then the table has 1 rows
    And I press button "mzabsm" to open a subeditor for "MZ_Entnahme2" in row 1
    And I press button "abv" to open a subeditor for "MZ_EntnahmeX"
    And I close the current editor
    And I switch the current editor to editor "MZ_Entnahme2"
    And I modify table
      | zuomge | einh | !row |
      | 1.5    | Paar | 1    |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINHEIT_001"
    And I set field "sofort" to "1"
    And I set field "gut" to "1"
    And I save the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITEN |
      | klplatz    | F1           |
      | verdichten | nein         |
      | details    | nein         |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | geinheit | kopfzugvorg^id   |
      | 6     |        |          | (0,0,0)          |
      |       | 6      | Stück    | !Rückmeldung3^id |
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel    | GEBINDEPFL |
      | klplatz    | F1         |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-19"


  Scenario: 20 Rückbau zu Rückmeldung auf letzten AS, die Gutmenge mit Charge gebucht hat
    And I set the fake date to "28.01.1995"
  # Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "KORR-99"

  # Chargen anlegen
    Given I create a Lot "CH-BG1" for Product "B_BAUGRUPPE"

  # Auftrag anlegen und Bedarfe buchen, FV anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "LBUCH99" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "LBUCH99" and price "0"

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch    |
      | B_BAUGRUPPE | 10  | ja     | CHARGE99_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  # Rückmeldung auf ersten AS mit Charge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGE99_001"
    And I set fields
      | sofort  | ja         |
      | kcharge | !CH-BG1^id |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

  # Rückbau mit und ohne Chargenangabe
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "CHARGE99_001"
    And I set fields
      | sofort  | ja         |
      | kcharge | !CH-BG1^id |
    And I set field "gutmge" to "-1" in row 1
    And I save the current editor

    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "CHARGE99_001"
    And I set fields
      | sofort  | ja         |
      | kcharge | !CH-BG1^id |
    And I set field "gutmge" to "-1" in row 1
    And I save the current editor

  # LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rückmeldung1^barmex |
      | artikel  | B_BAUGRUPPE          |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | zmge | rueckmge | restmge | detursache            | ncharge^such | !row |
      | -1   | -1       | 0       | Rückbau Fertigung     | CH-BG1       | 1    |
      | -1   | -1       | 0       | Rückbau Fertigung     | CH-BG1       | 2    |
      | 5    | 2        | 3       | Rückmeldung Fertigung | CH-BG1       | 3    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id   |
      | 3     |        |             | (0,0,0)          |
      |       | 3      | CH-BG1      | !Rückmeldung1^id |
    And I close the current editor

  # FV abschließen und Auftrag liefern, Bestand prüfen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGE99_001"
    And I set fields
      | sofort  | ja         |
      | kcharge | !CH-BG1^id |
      | gut     | ja         |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id   |
      | 10    |        |             | (0,0,0)          |
      |       | 3      | CH-BG1      | !Rückmeldung1^id |
      |       | 7      | CH-BG1      | !Rückmeldung2^id |
    And I close the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-P99"


  Scenario: 21 Rückbau ohne Chargenangabe, der zwei Rückmeldungen mit unterschiedlichen Chargen auf letzten AS betrifft
    And I set the fake date to "29.01.1995"
  # Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "KORR-98"

  # Chargen anlegen
    Given I create a Lot "CH-BG1-21" for Product "B_BAUGRUPPE"
    Given I create a Lot "CH-BG2-21" for Product "B_BAUGRUPPE"

  # Auftrag anlegen und Bedarfe buchen, FV anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "LBUCH98" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "LBUCH98" and price "0"

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch    |
      | B_BAUGRUPPE | 10  | ja     | CHARGE98_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  # Rückmeldung auf ersten AS mit Charge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGE98_001"
    And I set fields
      | sofort  | ja            |
      | kcharge | !CH-BG1-21^id |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGE98_001"
    And I set fields
      | sofort  | ja            |
      | kcharge | !CH-BG2-21^id |
    And I set field "gutmge" to "4" in row 1
    And I save the current editor

  # Rückbau ohne Chargenangabe
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "CHARGE98_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-8" in row 1
    And saving the current editor throws the exception "2743"
    And I close the current editor

  # LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rückmeldung1^barmex |
      | artikel  | B_BAUGRUPPE          |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | zmge | rueckmge | restmge | detursache            | ncharge^such | !row |
      | 4    | 0        | 4       | Rückmeldung Fertigung | CH-BG2-21    | 1    |
      | 5    | 0        | 5       | Rückmeldung Fertigung | CH-BG1-21    | 2    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id   |
      | 9     |        |             | (0,0,0)          |
      |       | 5      | CH-BG1-21   | !Rückmeldung1^id |
      |       | 4      | CH-BG2-21   | !Rückmeldung2^id |
    And I close the current editor

  # FV abschließen und Auftrag liefern, Bestand prüfen
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGE98_001"
    And I set fields
      | sofort  | ja            |
      | kcharge | !CH-BG1-21^id |
    And I set field "gutmge" to "4" in row 1
    And I save the current editor

  #  Given I open the infosystem "BESTAND"
  #  And I set fields
  #    | artikel    | B_BAUGRUPPE |
  #    | klplatz    | F1          |
  #    | verdichten | nein        |
  #    | details    | nein        |
  #  And I press start
  #  And I press button "taufzu" in row 1
  #  Then the table has 4 rows
  #  Then table has values
  #    | lemge | gebmge | charge^such | kopfzugvorg^id   |
  #    | 13    |        |             | (0,0,0)          |
  #    |       | 5      | CH-BG1-21   | !Rückmeldung1^id |
  #    |       | 4      | CH-BG1-21   | !Rückmeldung3^id |
  #    |       | 4      | CH-BG2-21   | !Rückmeldung2^id |


  #And I close the current editor
  # Infosystem BESTAND hat die Tabelle in unterschiedlicher Reihenfolge ausgegeben. Es wurden verschiedene Schlüssel verwendet.
  # Deswegen auf eine Query umgestellt um den Test stabiler zu machen.
Given I query "gebmge, tcharge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==B_BAUGRUPPE;platz==F1;@sort=(SingleQuantitiesDateOfReceipt)"
Then query has values
|gebmge | tcharge   |
|     5 | CH-BG1-21 |
|     4 | CH-BG2-21 |
|     4 | CH-BG1-21 |
And I close the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-P98"


  Scenario: 22 Rückbau zu Rückmeldung auf letzten AS, FertigteilMZ mit einem Behälter
    And I set the fake date to "30.01.1995"
  # Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "KORR-971"

  # Behälter und Auftrag anlegen und Bedarfe buchen, FV anlegen und freigeben
    Given I create a Container "BEHAELTER1" for packaging material "BEHAELTER"
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "LBUCH971" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "LBUCH971" and price "0"

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | B_BAUGRUPPE | 10  | ja     |
    And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row 1
    And I modify table
      | !row | zuomge | behaelter      |
      | +1   | 10     | !BEHAELTER1^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEHAELTER971_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  # Rückmeldung auf ersten AS
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHAELTER971_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

  # Rückbau mit Behälterangabe
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BEHAELTER971_001"
    And I set fields
      | sofort    | ja             |
      | behaelter | !BEHAELTER1^id |
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

  # LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rückmeldung1^barmex |
      | artikel  | B_BAUGRUPPE          |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | zmge | rueckmge | restmge | detursache            | behaelter^such | !row |
      | -5   | -5       | 0       | Rückbau Fertigung     | BEHAELTER1     | 1    |
      | 8    | 5        | 3       | Rückmeldung Fertigung | BEHAELTER1     | 2    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | B_BAUGRUPPE |
      | klplatz   | F1          |
      | behaelter | ja          |
      | details   | nein        |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | tbehaelter^such |
      | 3      | BEHAELTER1      |
    And I close the current editor

  # FV abschließen und Auftrag liefern, Bestand prüfen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHAELTER971_001"
    And I set fields
      | sofort    | ja             |
      | gut       | ja             |
      | behaelter | !BEHAELTER1^id |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 10    |        | (0,0,0)          |
      |       | 3      | !Rückmeldung1^id |
      |       | 2      | !Rückmeldung2^id |
      |       | 5      | !Rückmeldung2^id |

    And I set fields
      | behaelter | ja |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | tbehaelter^such |
      | 10     | BEHAELTER1      |
    And I close the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "10" in row 1
    And I set field "behaelter" to "!BEHAELTER1^id" in row 1
    And I save the current editor


  Scenario: 23 Rückbau mit Behälterangabe auf letzten AS, bisher Rüclmeldung ohne Behälterangabe bucht Gutmege in zwei Behälter, FertigteilMZ mit zwei behältern vor Freigabe FV angelegt
    And I set the fake date to "31.01.1995"
# Besatnd auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BG-BEHAELTER" on StorageLocation "F1" with document "SCEN-03"

# Behälter anlegen und Bedarfe buchen
    Given I create a Container "MZ_BEHAELTER1" for packaging material "BEHAELTER"
    Given I create a Container "MZ_BEHAELTER2" for packaging material "BEHAELTER"

    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "SCEN-03" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "SCEN-03" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "BEHAELTER" and quantity "2" on StorageLocation "F1" with document "SCEN-03" and price "0"

# Auftrag und Fertigungsvorschlag mit MZ Fertigartikel anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-BEHAELTER" and quantity "10"
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig |
      | BG-BEHAELTER | 10     | ja     |
    And I press button "mzsubm" to open a subeditor for "MZuordnung" in row 1
    And I delete all rows
    And I append rows
      | zuomge | behaelter         |
      | 5      | !MZ_BEHAELTER1^id |
      | 5      | !MZ_BEHAELTER2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MZ_BEH1_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZ_BEH1_001"
    And I set field "gutmge" to "9" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Rückbau auf ersten Arbeitsgang, Behälter und Bestand prüfen
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "MZ_BEH1_001"
    And I set field "sofort" to "ja"
    And I set field "behaelter" to "!MZ_BEHAELTER1^id"
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

    Given I switch the current editor to editor "MZ_BEHAELTER2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel      | mge |
      | BG-BEHAELTER | 4   |
    And I close the current editor
    Then Container from editor "MZ_BEHAELTER1" is empty

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | BG-BEHAELTER |
      | klplatz   | F1           |
      | behaelter | ja           |
      | details   | nein         |
    And I press start
    Then table has values
      | gebmge | tbehaelter^id     |
      | 4      | !MZ_BEHAELTER2^id |
    And I close the current editor

# Betriebsauftrag und Auftrag abschließen, Behälter prüfen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZ_BEH1_001"
    And I set fields
      | gut       | ja                |
      | sofort    | ja                |
      | behaelter | !MZ_BEHAELTER2^id |
      | manrest   | ja                |
    And I save the current editor

    Then Container from editor "MZ_BEHAELTER1" is empty
    Given I switch the current editor to editor "MZ_BEHAELTER2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel      | mge |
      | BG-BEHAELTER | 10  |
    And I close the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I modify table
      | !row | mge | behaelter         |
      | 1    | 10  | !MZ_BEHAELTER2^id |
    And I save the current editor


  Scenario: 24 Rückbauten auf zwei Rückmeldungen auf letzten AS betrifft, FertigteilMZ mit zwei Behälter
    And I set the fake date to "01.02.1995"
  # Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "KORR-97"

  # Behälter anlegen
    Given I create a Container "BEHAELTER1" for packaging material "BEHAELTER"
    Given I create a Container "BEHAELTER2" for packaging material "BEHAELTER"

  # Auftrag anlegen und Bedarfe buchen, FV anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "LBUCH97" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "LBUCH97" and price "0"

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | B_BAUGRUPPE | 10  | ja     |
    And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row 1
    And I modify table
      | !row | zuomge | behaelter      |
      | +1   | 5      | !BEHAELTER1^id |
      | +2   | 5      | !BEHAELTER2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEHAELTER97_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  # Rückmeldung auf ersten AS mit Behälter
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHAELTER97_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

  # Rückbau mit Behälterangabe
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BEHAELTER97_001"
    And I set fields
      | sofort    | ja             |
      | behaelter | !BEHAELTER1^id |
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BEHAELTER97_001"
    And I set fields
      | sofort    | ja             |
      | behaelter | !BEHAELTER2^id |
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor

  # LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rückmeldung1^barmex |
      | artikel  | B_BAUGRUPPE          |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | zmge | rueckmge | restmge | detursache            | behaelter^such | !row |
      | -2   | -2       | 0       | Rückbau Fertigung     | BEHAELTER2     | 1    |
      | -3   | -3       | 0       | Rückbau Fertigung     | BEHAELTER1     | 2    |
      | -2   | -2       | 0       | Rückbau Fertigung     | BEHAELTER1     | 3    |
      | 3    | 3        | 0       | Rückmeldung Fertigung | BEHAELTER2     | 4    |
      | 5    | 4        | 1       | Rückmeldung Fertigung | BEHAELTER1     | 5    |
    Then field "rueckorig^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | B_BAUGRUPPE |
      | klplatz   | F1          |
      | behaelter | ja          |
      | details   | nein        |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | tbehaelter^such |
      | 1      | BEHAELTER2      |
    And I close the current editor

  # FV abschließen und Auftrag liefern, Bestand prüfen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHAELTER97_001"
    And I set fields
      | sofort    | ja             |
      | behaelter | !BEHAELTER2^id |
    And I set field "gutmge" to "4" in row 1
    And I save the current editor

    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHAELTER97_001"
    And I set fields
      | sofort    | ja             |
      | behaelter | !BEHAELTER1^id |
      | gut       | ja             |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 5 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 10    |        | (0,0,0)          |
      |       | 1      | !Rückmeldung1^id |
      |       | 2      | !Rückmeldung2^id |
      |       | 2      | !Rückmeldung2^id |
      |       | 5      | !Rückmeldung3^id |
    And I set fields
      | behaelter | ja |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | tbehaelter^such |
      | 5      | BEHAELTER1      |
      | 5      | BEHAELTER2      |
    And I close the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "15" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | behaelter      |
      | 1    | 5      | !BEHAELTER1^id |
      | +2   | 5      | !BEHAELTER2^id |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor


  Scenario: 25 Rückbau auf letzten AS, bisher eine Rückmeldung über Teilmenge betrifft zwei Lagerplätze, FertigteilMZ mit Lagerplätzen vor Freigabe FV angelegt
    And I set the fake date to "02.02.1995"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN-01_1"

# Bestand ans Lager buchen
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "Zugang-01" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "Zugang-01" and price "0"

# Auftrag, Fertigungsvorschlag anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
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

# Rückmeldung auf ersten Arbeitsgang, Bewertung aufrufen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLATZ_001"
    And I set fields
      | sofort | 1 |
    And I modify table
      | gutmge | buplatz | erbtext1    | !row |
      | 7      | F1      | Rückmeldung | 1    |
    And I save the current editor

    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel==BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Rückbau und Bestand prüfen
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "PLATZ_001"
    And I set fields
      | sofort | 1 |
    And I modify table
      | gutmge | buplatz | erbtext1 | !row |
      | -2     | F2      | Rückbau1 | 1    |
    And I save the current editor

    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "PLATZ_001"
    And I set fields
      | sofort | 1 |
    And I modify table
      | gutmge | erbtext1 | !row |
      | -4     | Rückbau2 | 1    |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | !row | lplatz | gebmge | kopfzugvorg^id   |
      | 2    | F1     | 1      | !Rückmeldung1^id |
    And I close the current editor

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
      | art       | zmge | nplatz | amge | vplatz | rueckmge | restmge | rueckbew | !row |
      | BAUGRUPPE | -4   | F1     |      |        | -4       | 0       | ja       | 1    |
      | EINKAUF-1 |      |        | -8   | F1     | -8       | 0       | ja       | 2    |
      | EINKAUF-2 |      |        | -4   | F1     | -4       | 0       | ja       | 3    |
      | BAUGRUPPE | -2   | F2     |      |        | -2       | 0       | ja       | 4    |
      | EINKAUF-1 |      |        | -4   | F1     | -4       | 0       | ja       | 5    |
      | EINKAUF-2 |      |        | -2   | F1     | -2       | 0       | ja       | 6    |
      | BAUGRUPPE | 2    | F2     |      |        | 2        | 0       | nein     | 7    |
      | BAUGRUPPE | 5    | F1     |      |        | 4        | 1       | nein     | 8    |
      | EINKAUF-1 |      |        | 14   | F1     | 12       | 2       | nein     | 9    |
      | EINKAUF-2 |      |        | 7    | F1     | 6        | 1       | nein     | 10   |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 8
    Then field "rueckorig^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 7
    And I close the current editor

# Lagerjournaleinträge
    Given I open an editor "Journal_rueck_F1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;platz=F1;erbtext1=Rückbau2;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau2"
    Then fields have values
      | mge      | -4 |
      | rueckmge | -4 |
      | restmge  | 0  |
    And I close the current editor

    Given I open an editor "Journal_rueck_F2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;platz=F2;erbtext1=Rückbau1;@richtung=rückwärts;@maxtreffer=1"
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    Then fields have values
      | mge      | -2 |
      | rueckmge | -2 |
      | restmge  | 0  |
    And I close the current editor

    Given I open an editor "Journal_orig_F1" via ID from editor "Journal_rueck_F1" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    Then fields have values
      | mge      | 5 |
      | rueckmge | 4 |
      | restmge  | 1 |
    And I close the current editor

    Given I open an editor "Journal_orig_F2" via ID from editor "Journal_rueck_F2" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    Then fields have values
      | mge      | 2 |
      | rueckmge | 2 |
      | restmge  | 0 |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Betriebsauftrag1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLATZ_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

    Given I deliver the SalesOrder "auftrag" with PackingSlip "LS-01"

# Nicht mehr möglich -> plausitest?
# Scenario: 26 Rückbau zu Rückmeldung auf letzten AS, Gutmenge wurde in RM auf unterschiedliche Lagerplätze gebucht
#And I set the fake date to "03.02.1995"
# Bestandskorrektur auf 0
# 	Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "KORR-86"
# 	Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F2" with document "KORR-86"
#
#   # Behälter und Auftrag anlegen und Bedarfe zubuchen, FV anlegen und freigeben
# 	Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"
#
# 	Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "87-ZUGANG" and price "0"
# 	Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "87-ZUGANG" and price "0"
#
# 	Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
# 	And I append rows
# 		| artikel	    | mge	| mfreig	| bisuch       |
# 		| B_BAUGRUPPE	| 10	| ja		| PLAETZE86_   |
# 	And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
# 	And I press button "freig" to open a subeditor for "BA_freigeben"
# 	And I close the current editor
# 	And I switch the current editor to editor "fvor"
# 	And I save the current editor
#
#   # Rückmeldungen auf F2 und F1, Bestand prüfen
# 	Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZE86_001"
# 	And I set field "sofort" to "ja"
# 	And I set field "gutmge" to "4" in row 1
# 	And I set field "buplatz" to "F2" in row 1
# 	And I save the current editor
# 	And I wait 1 time units to move the time forward
#
# 	Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZE86_001"
# 	And I set field "sofort" to "ja"
# 	And I set field "gutmge" to "4" in row 1
# 	And I set field "buplatz" to "F1" in row 1
# 	And I save the current editor
#
# 	Given I open the infosystem "BESTAND"
# 	And I set fields
# 		| artikel     | B_BAUGRUPPE |
# 		| verdichten  | nein        |
#       | details     | nein        |
# 	And I press start
#   And I press button "taufzu" in row 1
# 	Then table has values
# 		| lemge | lplatz  | gebmge  | geinheit    | kopfzugvorg^id    |
# 		| 4     | F1      |         | 		      | (0,0,0)			  |
# 		|       | F2      | 4       | Stück       | !Rückmeldung1^id  |
# 		|       | F1      | 4       | Stück       | !Rückmeldung2^id  |
# 	And I close the current editor
#
#     # Rückbau ohne Angabe des buplatz, Bestand prüfen
# 	Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "PLAETZE86_001"
# 	And I set field "sofort" to "ja"
# 	And I set field "gutmge" to "-5" in row 1
# 	And I save the current editor
#
# 	Given I open the infosystem "BESTAND"
# 	And I set fields
# 		| artikel 	 | B_BAUGRUPPE |
# 		| verdichten | nein        |
#       | details    | nein        |
# 	And I press start
#   And I press button "taufzu" in row 1
# 	Then table has values
# 		| lemge | lplatz  | gebmge  | geinheit    | kopfzugvorg^id    |
# 		| 3     | F2      |         | 		      | (0,0,0)			  |
# 		|       | F2      | 3       | Stück       | !Rückmeldung1^id  |
# 	And I close the current editor
#
#   # LJ und Belege prüfen
# 	Given I open the infosystem "LJ"
# 	And I set fields
# 		| beleg   | !Rückmeldung1^barmex  |
# 		| artikel | B_BAUGRUPPE           |
# 		| richtung| rückwärts             |
# 	And I press start
# 	Then table has values
# 		| zmge  | nplatz   | rueckmge  | restmge | !row  |
# 		| -1    | F2       | -1        | 0       | 1     |
# 		| -4    | F1       | -4        | 0       | 2     |
# 		| 4     | F1       | 4         | 0       | 3     |
# 		| 4     | F2       | 1         | 3       | 4     |
# 	And I close the current editor
#
#   # FV abschließen udn Auftrag liefern
# 	Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZE86_001"
# 	And I set field "sofort" to "ja"
# 	And I set field "gut" to "ja"
# 	And I set field "buplatz" to "F2" in row 1
# 	And I save the current editor
#
# 	And I switch the current editor to editor "auftrag" with command "DELIVERY"
# 	And I set fields
# 		| vom | .   |
# 		| ueb | ja  |
# 	And I set field "mge" to "10" in row 1
# 	And I set field "platz" to "F2" in row 1
# 	And I save the current editor
#
# 	Given I open the infosystem "BESTAND"
# 	And I set fields
# 		| artikel     | B_BAUGRUPPE  |
# 		| verdichten  | nein         |
# 		| nullmge	  | nein         |
#       | details     | nein         |
# 	And I press start
# 	Then the table has 0 rows
# 	And I close the current editor


  Scenario: 27 Rückbau zu Rückmeldung auf letzten AS, Gutmenge wurde in RM auf unterschiedliche Plätze gebucht, FertigteilMZ Plätze, EntnahmeMZ Plätze
    And I set the fake date to "04.02.1995"
  # Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-94"
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "KORR-94"
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F2" with document "KORR-94"
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F3" with document "KORR-94"

  # Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "15"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "15" on StorageLocation "F1" with document "ZUG94" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "15" on StorageLocation "F2" with document "ZUG94" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "15" on StorageLocation "F1" with document "ZUG94" and price "0"

  # FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | B_BAUGRUPPE | 15  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row 1
    And I modify table
      | !row | zuomge | lpsuch |
      | +1   | 5      | F1     |
      | +2   | 5      | F2     |
      | +3   | 5      | F3     |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzabsm" to open a subeditor for "EntnhameMZ" in row 1
    And I modify table
      | !row | zuomge | lpsuch |
      | +1   | 15     | F1     |
      | +2   | 15     | F2     |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "PLAETZE94_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  # Betriebsauftrag öffnen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "PLAETZE94_000"
    And I close the current editor

  # Rückmeldung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZE94_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "14" in row 1
    And I save the current editor

  # Rückbau mit und ohne Platzangabe für die Gutmenge
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "PLAETZE94_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-5" in row 1
    And I set field "buplatz" to "F2" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "PLAETZE94_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

  # LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rückmeldung1^barmex |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | art         | amge | vplatz | zmge | nplatz | rueckmge | restmge | detursache            | !row |
      | B_BAUGRUPPE |      |        | -5   | F1     | -5       | 0       | Rückbau Fertigung     | 1    |
      | B_EINKAUF-1 | -7   | F1     |      |        | -7       | 0       | Rückbau Fertigung     | 2    |
      | B_EINKAUF-1 | -3   | F2     |      |        | -3       | 0       | Rückbau Fertigung     | 3    |
      | B_EINKAUF-2 | -5   | F1     |      |        | -5       | 0       | Rückbau Fertigung     | 4    |
      | B_BAUGRUPPE |      |        | -5   | F2     | -5       | 0       | Rückbau Fertigung     | 5    |
      | B_EINKAUF-1 | -10  | F2     |      |        | -10      | 0       | Rückbau Fertigung     | 6    |
      | B_EINKAUF-2 | -5   | F1     |      |        | -5       | 0       | Rückbau Fertigung     | 7    |
      | B_BAUGRUPPE |      |        | 4    | F3     | 0        | 4       | Rückmeldung Fertigung | 8    |
      | B_BAUGRUPPE |      |        | 5    | F2     | 5        | 0       | Rückmeldung Fertigung | 9    |
      | B_BAUGRUPPE |      |        | 5    | F1     | 5        | 0       | Rückmeldung Fertigung | 10   |
      | B_EINKAUF-1 | 13   | F2     |      |        | 13       | 0       | Rückmeldung Fertigung | 11   |
      | B_EINKAUF-1 | 15   | F1     |      |        | 7        | 8       | Rückmeldung Fertigung | 12   |
      | B_EINKAUF-2 | 14   | F1     |      |        | 10       | 4       | Rückmeldung Fertigung | 13   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 3
    Then the table has 4 rows
    Then table has values
      | lemge | lplatz | gebmge | kopfzugvorg^id   | !row |
      | 4     | F3     |        | (0,0,0)          | 3    |
      |       | F3     | 4      | !Rückmeldung1^id | 4    |
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    Then the table has 2 rows
    Then table has values
      | lemge | lplatz | gebmge | kopfzugvorg^id |
      | 7     | F1     |        | (0,0,0)        |
      | 15    | F2     |        | (0,0,0)        |
    And I close the current editor

  # MZ wiederherstellen, Betriebsauftrag abschließen und Auftrag liefern, Bestand prüfen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "banummer" to "!Betriebsauftrag^nummer"
    And I press button "ladetab"
    And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row 1
    And I modify table
      | !row | zuomge | lpsuch |
      | 1    | 5      | F1     |
      | +2   | 5      | F2     |
      | +3   | 1      | F3     |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzabsm" to open a subeditor for "EntnhameMZ" in row 1
    And I modify table
      | !row | zuomge | lpsuch |
      | 1    | 7      | F1     |
      | +2   | 15     | F2     |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZE94_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "15" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | zuomge | lpsuch | !row |
      | 5      | F1     | 1    |
      | 5      | F2     | +2   |
      | 5      | F3     | +3   |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel | B_BAUGRUPPE |
      | nullmge | nein        |
      | details | nein        |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | B_EINKAUF-1 |
    Then the table has 0 rows
    And I close the current editor


  Scenario: 28 Rückbau zu Rückmeldung auf letzten AS, die Gutmenge in anderer Einheit gebucht hat
    And I set the fake date to "05.02.1995"
  # Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "BG-EINHEITENPFL" on StorageLocation "F1" with document "KORR-88"
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "KORR-88"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "KORR-88"

  # Behälter und Auftrag anlegen und Bedarfe einkaufen, FV anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITENPFL" and quantity "5"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 10  |
      | GEBINDEPFL | 5   |
      | GEBINDE    | 50  |
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel         | mge | mfreig |
      | BG-EINHEITENPFL | 10  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | einh |
      | +1   | 5      | Paar |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BGEINHEIT88_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BGEINHEIT88_000"
    And I save value from field "nummer" in row 0
    And I close the current editor

  # Rückmeldung in Stück und Rückbau in Stück
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT88_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BGEINHEIT88_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-1" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | details    | nein            |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id   |
      | 3     | Stück    |        |          | (0,0,0)          |
      |       |          | 3      | Stück    | !Rückmeldung1^id |
    And I set fields
      | artikel | GEBINDE |
      | details | nein    |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id |
      | 7     | Stück    |        |          | (0,0,0)        |
      |       |          | 6      | Stück    | !Rechnung^id   |
      |       |          | 1      | Stück    | !Rechnung^id   |
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id |
      | 7     | Stück    |        |          | (0,0,0)        |
      |       |          | 3      | Paar     | !Rechnung^id   |
      |       |          | 1      | Stück    | !Rechnung^id   |
    And I close the current editor

 # Rückmeldung in Paar und Rückbau in Paar, Bestand prüfen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT88_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I set field "bueinh" to "Paar" in row 1
    And I save the current editor

    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BGEINHEIT88_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-1" in row 1
    And I set field "bueinh" to "Paar" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | details    | nein            |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id   |
      | 5     | Stück    |        |          | (0,0,0)          |
      |       |          | 3      | Stück    | !Rückmeldung1^id |
      |       |          | 1      | Paar     | !Rückmeldung2^id |
    And I set fields
      | artikel | GEBINDE |
      | details | nein    |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id |
      | 5     | Stück    |        |          | (0,0,0)        |
      |       |          | 2      | Stück    | !Rechnung^id   |
      |       |          | 1      | Stück    | !Rechnung^id   |
      |       |          | 2      | Stück    | !Rechnung^id   |
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id |
      | 5     | Stück    |        |          | (0,0,0)        |
      |       |          | 1      | Paar     | !Rechnung^id   |
      |       |          | 1      | Stück    | !Rechnung^id   |
      |       |          | 2      | Stück    | !Rechnung^id   |
    And I close the current editor

  # LJ und Belege prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rückmeldung1^barmex |
      | artikel  | BG-EINHEITENPFL      |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | zmge | mei   | rueckmge | restmge | !row |
      | -1   | Paar  | -2       | 0       | 1    |
      | 2    | Paar  | 2        | 2       | 2    |
      | -1   | Stück | -1       | 0       | 3    |
      | 4    | Stück | 1        | 3       | 4    |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau2" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | gutmge | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -1    | Paar   | -2     | -2       | 0       | 5      | 7      |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | gutmge | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | 2     | Paar   | 4      | 2        | 2       | 7      | 3      |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | gutmge | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -1    | Stück  | -1     | -1       | 0       | 3      | 4      |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | gutmge | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | 4     | Stück  | 4      | 1        | 3       | 4      | 0      |
    And I close the current editor

  # FV abschließen und Auftrag liefern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "banummer" in row 0 to saved value
    And I press button "ladetab"
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | einh |
      | 1    | 1      | Paar |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT88_001"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "5" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | zuomge | einh  | !row |
      | 8      | Stück | 1    |
      | 1      | Paar  | +2   |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | nullmge    | nein            |
      | details    | nein            |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | GEBINDE |
      | details | nein    |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: 29 Rückbau zu Rückmeldung auf letzten AS, der zwei Rückmeldungen auf letzten AS betrifft, Belege in unterschiedlichen Einheiten der Gutmenge
    And I set the fake date to "06.02.1995"
  # Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "BG-EINHEITENPFL" on StorageLocation "F1" with document "KORR-89"

  # Behälter und Auftrag anlegen und Bedarfe einkaufen, FV anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITENPFL" and quantity "5"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 10  |
      | GEBINDEPFL | 10  |
      | GEBINDE    | 10  |
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel         | mge | mfreig | bisuch       |
      | BG-EINHEITENPFL | 10  | ja     | BGEINHEIT89_ |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  # Rückmeldungen in Stück und in Paar, Bestand prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT89_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT89_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I set field "bueinh" to "Paar" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | details    | nein            |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id   |
      | 8     | Stück    |        |          | (0,0,0)          |
      |       |          | 4      | Stück    | !Rückmeldung1^id |
      |       |          | 2      | Paar     | !Rückmeldung2^id |
    And I close the current editor

    # Rückbau in Stück und in Paar, RB3 in Paar betrifft beide Gebindezeilen; Bestand prüfen
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BGEINHEIT89_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-1" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BGEINHEIT89_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-1" in row 1
    And I set field "bueinh" to "Paar" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | details    | nein            |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id   |
      | 5     | Stück    |        |          | (0,0,0)          |
      |       |          | 3      | Stück    | !Rückmeldung1^id |
      |       |          | 1      | Paar     | !Rückmeldung2^id |
    And I close the current editor

    Given I open an editor "Rückbau3" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BGEINHEIT89_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-1" in row 1
    And I set field "bueinh" to "Paar" in row 1
    And I save the current editor

    Given I open an editor "Rückbau4" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BGEINHEIT89_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | details    | nein            |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id   |
      | 1     | Stück    |        |          | (0,0,0)          |
      |       |          | 1      | Stück    | !Rückmeldung1^id |
    And I close the current editor

  # LJ und Belege prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rückmeldung1^barmex |
      | artikel  | BG-EINHEITENPFL      |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | zmge | mei   | rueckmge | restmge | !row |
      | -2   | Stück | -2       | 0       | 1    |
      | -1   | Paar  | -2       | 0       | 2    |
      | -1   | Paar  | -2       | 0       | 3    |
      | -1   | Stück | -1       | 0       | 4    |
      | 2    | Paar  | 4        | 0       | 5    |
      | 4    | Stück | 3        | 1       | 6    |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau4" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -2    | Stück  | -2       | 0       | 1      | 3      |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau3" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -1    | Paar   | -2       | 0       | 3      | 5      |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau2" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -1    | Paar   | -2       | 0       | 5      | 7      |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -1    | Stück  | -1       | 0       | 7      | 8      |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | 2     | Paar   | 4        | 0       | 8      | 4      |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | 4     | Stück  | 3        | 1       | 4      | 0      |
    And I close the current editor

    # FV abschließen udn Auftrag liefern
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT89_001"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I save the current editor

    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "10" in row 1
    And I set field "he" to "Stück" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | nullmge    | nein            |
      | details    | nein            |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: 30 Rückbau zu Rückmeldung auf letzten AS, der zwei Rückmeldungen auf letzten AS betrifft, FerzigteilMZ mit Einheiten
    And I set the fake date to "07.02.1995"
	# Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "BG-EINHEITENPFL" on StorageLocation "F1" with document "KORR-87"

  # Behälter und Auftrag anlegen und Bedarfe einkaufen, FV anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITENPFL" and quantity "20"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 40  |
      | GEBINDEPFL | 20  |
      | GEBINDE    | 20  |
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel         | mge | mfreig |
      | BG-EINHEITENPFL | 20  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row 1
    And I modify table
      | !row | zuomge | einh  |
      | +1   | 10     | Stück |
      | +2   | 5      | Paar  |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BGEINHEIT87_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  # Rückmeldungen in Stück, Bestand prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT87_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "12" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT87_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "6" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | details    | nein            |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id   |
      | 18    | Stück    |        |          | (0,0,0)          |
      |       |          | 10     | Stück    | !Rückmeldung1^id |
      |       |          | 1      | Paar     | !Rückmeldung1^id |
      |       |          | 3      | Paar     | !Rückmeldung2^id |
    And I close the current editor

  # Rückbau in Stück betrifft ersten Rückmeldebelege;
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BGEINHEIT87_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-10" in row 1
    And I save the current editor

  # Rückbau in Paar betrifft beide Rückmeldebelege;
    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BGEINHEIT87_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-2" in row 1
    And I set field "bueinh" to "Paar" in row 1
    And I save the current editor

  #  Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | details    | nein            |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id   |
      | 4     | Stück    |        |          | (0,0,0)          |
      |       |          | 1      | Paar     | !Rückmeldung1^id |
      |       |          | 1      | Paar     | !Rückmeldung2^id |
    And I close the current editor

  # LJ und Belege prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rückmeldung1^barmex |
      | artikel  | BG-EINHEITENPFL      |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | zmge | mei   | rueckmge | restmge | !row |
      | -2   | Paar  | -4       | 0       | 1    |
      | -10  | Stück | -10      | 0       | 2    |
      | 3    | Paar  | 4        | 2       | 3    |
      | 1    | Paar  | 0        | 2       | 4    |
      | 10   | Stück | 10       | 0       | 5    |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau2" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -2    | Paar   | -4       | 0       | 4      | 8      |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -10   | Stück  | -10      | 0       | 8      | 18     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | 6     | Stück  | 4        | 2       | 18     | 12     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | 12    | Stück  | 10       | 2       | 12     | 0      |
    And I close the current editor

  # FV abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT87_001"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I save the current editor

    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "20" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | zuomge | einh  | !row |
      | 14     | Stück | 1    |
      | 3      | Paar  | +2   |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | nullmge    | nein            |
      | details    | nein            |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: 31 Rückbau ohne Chargenangabe auf ketzten AS, bisher Teil-Rückmeldung bucht zwei Chargen, Fertigteil variantenbezogen, FertigteilMZ mit Chargen vor Freigabe FV angelegt,  eines variantenbezogenen Fertigartikel mit Chargen und Verwendungen bucht Bestand aus dem Lager ab
    And I set the fake date to "08.02.1995"
# Artikel anlegen
    Given I open an editor "BAUGRUPPE-V" from table "(Part):(Product)" with command "STORE" for record "BAUGRUPPE-V"
    And I set fields
      | such      | BAUGRUPPE-V       |
      | chverfolgung | Chargenverfolgung                |
      | namebspr  | Baugruppe variant |
      | dispoa    | variantenbezogen  |
      | bsart     | Eigenfertigung    |
    And I delete all rows
    And I append rows
      | elex       | anzahl |
      | EINKAUF-1  | 1      |
      | A MONTAGE1 | 1      |
    And I save the current editor

# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE-V" on StorageLocation "F1" with document "SCEN-10"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE-V" on StorageLocation "F2" with document "SCEN-10"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE-V" on StorageLocation "F3" with document "SCEN-10"

# Chargen erstellen
    Given I create a Lot "CHARGE1_BG-V" for Product "BAUGRUPPE-V"
    Given I create a Lot "CHARGE2_BG-V" for Product "BAUGRUPPE-V"

# Auftrag anlegen, Fertigungsvorschlag anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE-V" and quantity "10"
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

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "CHVAR2_000"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHVAR2_001"
    And I set fields
      | sofort | 1 |
    And I set field "gutmge" to "9" in row 1
    And I save the current editor

# Rückbau auf ersten Arbeitsgang und Betand prüfen
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "CHVAR2_001"
    And I set fields
      | sofort | 1 |
    And I set field "gutmge" to "-6" in row 1
    And saving the current editor throws the exception "2743"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE-V |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^such  | kopfzugvorg^id   |
      | 9     |        |              | (0,0,0)          |
      |       | 5      | CHARGE1_BG-V | !Rückmeldung1^id |
      |       | 4      | CHARGE2_BG-V | !Rückmeldung1^id |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | vcharge^such | ncharge^such | rueckmge | restmge | !row |
      | BAUGRUPPE-V | 4    |      |              | CHARGE2_BG-V | 0        | 4       | 1    |
      | BAUGRUPPE-V | 5    |      |              | CHARGE1_BG-V | 0        | 5       | 2    |
      | EINKAUF-1   |      | 4    |              | CHARGE2_BG-V | 0        | 4       | 3    |
      | EINKAUF-1   |      | 5    |              | CHARGE1_BG-V | 0        | 5       | 4    |
    And I close the current editor

# MZ wieder anlegen, Betriebsauftrag und Auftrag abschließen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "banummer" to "!Betriebsauftrag^nummer"
    And I press button "ladetab"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | charge           |
      | 1    | 1      | !CHARGE2_BG-V^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHVAR2_001"
    And I set fields
      | sofort | 1  |
      | gut    | ja |
    And I save the current editor

    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I modify table
      | !row | mge |
      | 1    | 10  |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | charge           |
      | 1    | 5      | !CHARGE1_BG-V^id |
      | +2   | 5      | !CHARGE2_BG-V^id |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

  Scenario: 32 Rückbau auf Betriebsauftrag mit Angabe Lagerplatz, bisher Rückmeldung aif Betriebsauftrag mit MZ für Lagerplätze gebucht
    And I set the fake date to "09.02.1995"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN-07"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F2" with document "SCEN-07"

# Bestand Material buchen
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "Zugang-07" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "Zugang-07" and price "0"

# Auftrag anlegen, Fertigungsvorschlag anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | BAPLAETZE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf Betriebsauftrag
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BAPLAETZE_000"
    And I set fields
      | sofort | 1   |
      | mgr    | 112 |
    And I set field "gutmge" to "9" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I append rows
      | zuomge | lpsuch |
      | 5      | F1     |
      | 4      | F2     |
    And I save the current editor
    And I switch the current editor to editor "Rückmeldung1"
    And I save the current editor

# Rückbau auf Betriebsauftrag und Bestand prüfen
# Rückbau auf F1
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BAPLAETZE_000"
    And I set fields
      | sofort | 1   |
      | mgr    | 112 |
    And I set field "gutmge" to "-3" in row 1
    And I set field "buplatz" to "F1" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    And I press button "taufzu" in row 3
    Then the table has 4 rows
    Then table has values
      | lemge | lplatz | gebmge | kopfzugvorg^id   |
      | 2     | F1     |        | (0,0,0)          |
      |       | F1     | 2      | !Rückmeldung1^id |
      | 4     | F2     |        | (0,0,0)          |
      |       | F2     | 4      | !Rückmeldung1^id |
    And I close the current editor

# Rückbau auf F2
    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BAPLAETZE_000"
    And I set fields
      | sofort | 1   |
      | mgr    | 112 |
    And I set field "gutmge" to "-3" in row 1
    And I set field "buplatz" to "F2" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    And I press button "taufzu" in row 3
    Then the table has 4 rows
    Then table has values
      | lemge | lplatz | gebmge | kopfzugvorg^id   |
      | 2     | F1     |        | (0,0,0)          |
      |       | F1     | 2      | !Rückmeldung1^id |
      | 1     | F2     |        | (0,0,0)          |
      |       | F2     | 1      | !Rückmeldung1^id |
    And I close the current editor

# Rückbau ohne geänderte Platzangabe (Standardlagerplatz F1), bucht Rest von F2 und dann F1
    Given I open an editor "Rückbau3" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BAPLAETZE_000"
    And I set fields
      | sofort | 1   |
      | mgr    | 112 |
    And I set field "gutmge" to "-2" in row 1
    Then field "buplatz" has value "F1" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 2
    Then the table has 3 rows
    Then table has values
      | lemge | lplatz | gebmge | kopfzugvorg^id   | !row |
      | 1     | F2     |        | (0,0,0)          | 2    |
      |       | F2     | 1      | !Rückmeldung1^id | 3    |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "artikel" to "BAUGRUPPE"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | nplatz | amge | vplatz | rueckmge | restmge | !row |
      | BAUGRUPPE | -2   | F1     |      |        | -2       | 0       | 1    |
      | BAUGRUPPE | -3   | F2     |      |        | -3       | 0       | 2    |
      | BAUGRUPPE | -3   | F1     |      |        | -3       | 0       | 3    |
      | BAUGRUPPE | 4    | F2     |      |        | 3        | 1       | 4    |
      | BAUGRUPPE | 5    | F1     |      |        | 5        | 0       | 5    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "rueckorig^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BAPLAETZE_000"
    And I set fields
      | sofort | 1   |
      | gut    | 1   |
      | mgr    | 112 |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I append rows
      | zuomge | lpsuch |
      | 5      | F1     |
      | 4      | F2     |
    And I save the current editor
    And I switch the current editor to editor "Rückmeldung2"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    And I press button "taufzu" in row 3
    Then the table has 5 rows
    Then table has values
      | lemge | lplatz | gebmge | kopfzugvorg^id   |
      | 5     | F1     |        | (0,0,0)          |
      |       | F1     | 5      | !Rückmeldung2^id |
      | 5     | F2     |        | (0,0,0)          |
      |       | F2     | 1      | !Rückmeldung1^id |
      |       | F2     | 4      | !Rückmeldung2^id |
    And I close the current editor

    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I modify table
      | !row | mge |
      | 1    | 10  |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | platz |
      | 1    | 5      | F1    |
      | +2   | 5      | F2    |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: 33 Rückbau auf Betriebsauftrag ohne Chargenangabe, bisher Rückmeldung auf BA mit MZ für Chargen gebucht
    And I set the fake date to "10.02.1995"
# Bestand auf 0 korrigieren und Bedarfe zubuchen
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN-08"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "Zugang-08" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "Zugang-08" and price "0"

# Chargen anlegen
    Given I create a Lot "CHARGE1_BG" for Product "BAUGRUPPE"
    Given I create a Lot "CHARGE2_BG" for Product "BAUGRUPPE"

# Auftrag anlegen, Fertigungsvorschlag anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | BACHARGE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf Betriebsauftrag
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BACHARGE_000"
    And I set fields
      | sofort | 1   |
      | mgr    | 112 |
    And I set field "gutmge" to "9" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I append rows
      | zuomge | charge         |
      | 5      | !CHARGE1_BG^id |
      | 4      | !CHARGE2_BG^id |
    And I save the current editor
    And I switch the current editor to editor "Rückmeldung1"
    And I save the current editor

# Rückbau auf Betriebsauftrag und Bestand prüfen
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BACHARGE_000"
    And I set fields
      | sofort | 1   |
      | mgr    | 112 |
    And I set field "gutmge" to "-6" in row 1
    And saving the current editor throws the exception "2743"
    And I close the current editor

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
      | 9     |        |             | (0,0,0)          |
      |       | 5      | CHARGE1_BG  | !Rückmeldung1^id |
      |       | 4      | CHARGE2_BG  | !Rückmeldung1^id |
    And I close the current editor

	# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | vcharge^such | ncharge^such | rueckmge | restmge | !row |
      | BAUGRUPPE | 4    |      |              | CHARGE2_BG   | 0        | 4       | 1    |
      | BAUGRUPPE | 5    |      |              | CHARGE1_BG   | 0        | 5       | 2    |
      | EINKAUF-1 |      | 8    |              | CHARGE2_BG   | 0        | 8       | 3    |
      | EINKAUF-1 |      | 10   |              | CHARGE1_BG   | 0        | 10      | 4    |
    And I close the current editor

	# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BACHARGE_000"
    And I set fields
      | sofort | 1   |
      | gut    | 1   |
      | mgr    | 112 |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I append rows
      | zuomge | charge         |
      | 1      | !CHARGE2_BG^id |
    And I save the current editor
    And I switch the current editor to editor "Rückmeldung2"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id   |
      | 10    |        |             | (0,0,0)          |
      |       | 5      | CHARGE1_BG  | !Rückmeldung1^id |
      |       | 4      | CHARGE2_BG  | !Rückmeldung1^id |
      |       | 1      | CHARGE2_BG  | !Rückmeldung2^id |
    And I close the current editor

    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I modify table
      | !row | mge |
      | 1    | 10  |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | charge         |
      | 1    | 5      | !CHARGE1_BG^id |
      | +2   | 5      | !CHARGE2_BG^id |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor


  Scenario: 34 Rückbau auf Betriebsauftrag mit Behälterangabe, bisher Rückmeldugn auf Betriebsauftrag mit MZ für Behälter
    And I set the fake date to "11.02.1995"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BG-BEHAELTER" on StorageLocation "F1" with document "SCEN-09"

# Behälter erstellen
    Given I create a Container "MZBA_BEHAELTER1" for packaging material "BEHAELTER"
    Given I create a Container "MZBA_BEHAELTER2" for packaging material "BEHAELTER"

# Material zubuchen
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "Zugang-09" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "Zugang-09" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "BEHAELTER" and quantity "2" on StorageLocation "F1" with document "Zugang-09" and price "0"

# Auftrag anlegen, Fertigungsvorschlag anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-BEHAELTER" and quantity "10"
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | mfreig | bisuch     |
      | BG-BEHAELTER | 10  | ja     | BACHARGE2_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf Betriebsauftrag
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BACHARGE2_000"
    And I set fields
      | sofort | 1   |
      | mgr    | 112 |
    And I set field "gutmge" to "9" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I append rows
      | zuomge | behaelter           |
      | 5      | !MZBA_BEHAELTER1^id |
      | 4      | !MZBA_BEHAELTER2^id |
    And I save the current editor
    And I switch the current editor to editor "Rückmeldung1"
    And I save the current editor

# Rückbau auf Betriebsauftrag, Betand und Behälter prüfen
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BACHARGE2_000"
    And I set fields
      | sofort    | 1                   |
      | mgr       | 112                 |
      | behaelter | !MZBA_BEHAELTER1^id |
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | BG-BEHAELTER |
      | klplatz   | F1           |
      | behaelter | ja           |
      | details   | nein         |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | tbehaelter^id       |
      | 2      | !MZBA_BEHAELTER1^id |
      | 4      | !MZBA_BEHAELTER2^id |
    And I close the current editor

    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BACHARGE2_000"
    And I set fields
      | sofort    | 1                   |
      | mgr       | 112                 |
      | behaelter | !MZBA_BEHAELTER2^id |
    And I set field "gutmge" to "-4" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | BG-BEHAELTER |
      | klplatz   | F1           |
      | behaelter | ja           |
      | details   | nein         |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | tbehaelter^id       |
      | 2      | !MZBA_BEHAELTER1^id |
    And I close the current editor

    Then Container from editor "MZBA_BEHAELTER2" is empty
    And I switch the current editor to editor "MZBA_BEHAELTER1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel      | mge |
      | BG-BEHAELTER | 2   |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BACHARGE2_000"
    And I set fields
      | sofort  | ja  |
      | gut     | ja  |
      | manrest | ja  |
      | mgr     | 112 |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I append rows
      | zuomge | behaelter           |
      | 3      | !MZBA_BEHAELTER1^id |
      | 5      | !MZBA_BEHAELTER2^id |
    And I save the current editor
    And I switch the current editor to editor "Rückmeldung2"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | BG-BEHAELTER |
      | klplatz   | F1           |
      | behaelter | ja           |
      | details   | nein         |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | tbehaelter^id       |
      | 5      | !MZBA_BEHAELTER1^id |
      | 5      | !MZBA_BEHAELTER2^id |
    And I close the current editor

    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I modify table
      | !row | mge |
      | 1    | 10  |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | behaelter           | verw |
      | 1    | 5      | !MZBA_BEHAELTER1^id |      |
      | +2   | 5      | !MZBA_BEHAELTER2^id |      |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

  Scenario: 35 Teil-Rückbau zu Rückmeldung auf letzten AS, FertigteilMZ mit Chargen, EntnahmeMZ mit Chargen vor Freigabe FV angelegt
    And I set the fake date to "12.02.1995"
# Bestandskorrektur BAUGRUPPE
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F2"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F3"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag35" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "100"

# Bedarfe einkaufen
    Given I open an editor "RechnungLager35" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 200 |
      | EINKAUF-2 | 100 |
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 100    | ARBEITSS_ | ja     |
    And I press button "mzsubm" to open a subeditor for "MZFertig" in row 1
    And I delete all rows
    And I append rows
      | zuomge |
      | 25     |
      | 25     |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "UM35RUECKBAU_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UM35RUECKBAU_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "50" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# Bestandsinfo prüfen
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
      | lemge | gebmge |
      | 50    |        |
      |       | 25     |
      |       | 25     |
    And I close the current editor

    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE |
      | buart   | Umbuchung |
      | beleg   | 35        |
      | beldat  | .         |
    And I append rows
      | platz2 | platz | mge |
      | F2     | F1    | 40  |
      | F2     | F1    | 10  |
    And I save the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F2        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | gebmge |
      | 50    |        |
      |       | 25     |
      |       | 15     |
      |       | 10     |
    And I close the current editor

    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE |
      | buart   | Umbuchung |
      | beleg   | 35        |
      | beldat  | .         |
    And I append rows
      | platz2 | platz | mge |
      | F3     | F2    | 50  |
    And I save the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F3        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | gebmge |
      | 50    |        |
      |       | 25     |
      |       | 15     |
      |       | 10     |
    And I close the current editor
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel | BAUGRUPPE |
      | klplatz | F2        |
      | nullmge | nein      |
      | details | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "UM35RUECKBAU_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-45" in row 1
    And I set field "buplatz" to "F2" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache            | rueckmge | restmge |
      | BAUGRUPPE | -20  |      | Rückbau Fertigung     | -20      | 0       |
      | BAUGRUPPE | -25  |      | Rückbau Fertigung     | -25      | 0       |
      | EINKAUF-1 |      | -90  | Rückbau Fertigung     | -90      | 0       |
      | EINKAUF-2 |      | -45  | Rückbau Fertigung     | -45      | 0       |
      | BAUGRUPPE | 25   |      | Rückmeldung Fertigung | 20       | 5       |
      | BAUGRUPPE | 25   |      | Rückmeldung Fertigung | 25       | 0       |
      | EINKAUF-1 |      | 100  | Rückmeldung Fertigung | 90       | 10      |
      | EINKAUF-2 |      | 50   | Rückmeldung Fertigung | 45       | 5       |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UM35RUECKBAU_000"
    And I set fields
      | sofort | ja  |
      | gut    | ja  |
      | mgr    | 112 |
    And I save the current editor
    And I deliver the SalesOrder "auftrag35" with PackingSlip "LS-35"

  Scenario: 36 Rueckbau von umgelagertem Material, vom Folgeplatz der Umlagerung
    And I set the fake date to "13.02.1995"
# Bestandskorrektur BAUGRUPPE
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F2"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F3"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag36" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "100"

# Bedarfe einkaufen
    Given I open an editor "RechnungLager36" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 200 |
      | EINKAUF-2 | 100 |
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 100    | ARBEITSS_ | ja     |
    And I set field "bisuch" to "UM36RUECKBAU_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung36" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UM36RUECKBAU_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "10" in row 1
    And I set field "buplatz" to "F1" in row 1
    And I set field "erbtext1" to "Rückmeldung36" in row 1
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung36" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UM36RUECKBAU_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "10" in row 1
    And I set field "buplatz" to "F2" in row 1
    And I set field "erbtext1" to "Rückmeldung26" in row 1
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung36" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UM36RUECKBAU_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "10" in row 1
    And I set field "buplatz" to "F3" in row 1
    And I set field "erbtext1" to "Rückmeldung36" in row 1
    And I save the current editor

    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE |
      | buart   | Umbuchung |
      | beleg   | 36        |
      | beldat  | .         |
    And I append rows
      | platz2 | platz | mge |
      | F2     | F1    | 5   |
    And I save the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau36" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "UM36RUECKBAU_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-12" in row 1
    And I set field "buplatz" to "F2" in row 1
    And I set field "erbtext1" to "Rückbau36" in row 1
    And I save the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau36" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "UM36RUECKBAU_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-3" in row 1
    And I set field "buplatz" to "F2" in row 1
    And I set field "erbtext1" to "Rückbau36" in row 1
    And I save the current editor


  Scenario: 37 Gesamt-Rückbau zu Rückmeldung auf ersten AS, wenn ein Teil der STL manuell entnommen wurde
    And I set the fake date to "14.02.1995"
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch | mfreig |
      | BG3-GEMISCHT | 2      | BGRB_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme auf zweiten Arbeitsgang
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "BGRB_002"
    And I press button "stllad"
    And I save the current editor

# Rückmeldung auf zweiten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGRB_002"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "2" in row 1
    And I set field "erbtext1" to "Sc37:Rückmeldung1" in row 1
    And I save the current editor

# Rückbau auf zweiten Arbeitsschein
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BGRB_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-2" in row 1
    And I set field "erbtext1" to "Sc37:Rückbau1" in row 1
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                 | rueckmge | restmge |
      | EINKAUF-3 |      | -2   | Rückbau Fertigung          | -2       | 0       |
      | EINKAUF-3 |      | 2    | Rückmeldung Fertigung      | 2        | 0       |
      | EINKAUF-1 |      | 2    | Materialentnahme Fertigung | 0        | 2       |
      | EINKAUF-2 |      | 2    | Materialentnahme Fertigung | 0        | 2       |
    And I close the current editor

  Scenario: 38 Teil-Rückbau zu Rückmeldung auf BA für Dienstlestung
    And I set the fake date to "15.02.1995"
# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch | mfreig |
      | EINRICHTEN | 10     | EINR_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINR_000"
    And I set field "sofort" to "1"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "EINR_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "-2" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINR_000"
    And I set fields
      | sofort  | ja  |
      | gut     | ja  |
      | mgr     | 112 |
      | manrest | ja  |
    And I save the current editor

  Scenario: 39 Teil-Rückbau auf Betriebsauftrag, Rückbau ohne Verwendung
    And I set the fake date to "16.02.1995"
# Bestandskorrektur BM_BAUGRUPPE
    Given I set StorageQuantity to zero for Product "BM_BAUGRUPPE" on StorageLocation "F1"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch   | mfreig | verw   |
      | BM_BAUGRUPPE | 10     | BETRIEB_ | ja     | verw39 |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf Betriebsauftrag
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BETRIEB_000"
    And I set fields
      | sofort | ja  |
      | mgr    | 112 |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# Rückbau auf Betriebsauftrag
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BETRIEB_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "-2" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

    Given I query "lgruppe,verw" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==BM_BAUGRUPPE;lgruppe<>`;verw<>`;@ordnung=artikel;"
    Then query has no hits

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BETRIEB_000"
    Then field "mge" has value "7"
    Then field "rgutmge" has value "3"
    And I press button "absteig" to open a subeditor for "AFL"
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor


  Scenario: 40 Rückbau auf überbuchten Arbeitsgang
    And I set the fake date to "17.02.1995"
# Bestandskorrektur BM_BAUGRUPPE
    Given I set StorageQuantity to zero for Product "BM_BAUGRUPPE" on StorageLocation "F1"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | binoloe | bisuch | mfreig | verw   |
      | B_BAUGRUPPE | 20     | ja      | SC40_  | ja     | verw40 |
    And I press button "freig" to open a subeditor for "fv"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang, AG wird überbucht
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SC40_001"
    And I set field "sofort" to "ja"
    And I set field "bem" to "SC40_001"
    And I set field "gutmge" to "25" in row 1
    And I set field "verlust" to "15" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "SC40_001"
    And I set field "sofort" to "ja"
    And I set field "verlustmge" to "-15" in row 1
    And I save the current editor

# Im Rückmeldebeleg wird alles Material, das zurückgegeben wurde, angezeigt
    Given I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | mge | verlustmge |
      | B_BAUGRUPPE | -5  | -15        |
      | B_EINKAUF-2 | -15 | 0          |
      | B_EINKAUF-1 | -30 | 0          |
    And I close the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I press start
    Then table has values
      | art         | detursache            | zmge | amge |
      | B_EINKAUF-2 | Rückmeldung Fertigung |      | 40   |
      | B_EINKAUF-1 | Rückmeldung Fertigung |      | 80   |
      | B_BAUGRUPPE | Rückmeldung Fertigung | 25   |      |
      | B_EINKAUF-2 | Rückbau Fertigung     |      | -15  |
      | B_EINKAUF-1 | Rückbau Fertigung     |      | -30  |
    And I close the current editor

# FV Löschschutz entfernen
    Given I open an editor "BA1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SC40_000"
    And I set field "noloesch" to "nein"
    And I save the current editor


# Scenario: 41 Rückbau von Ausschuss des Fertigteils der im Lager gebucht wurde
# And I set the fake date to "18.02.1995"
# # Auf den letzten Arbeitschein wird eine Gutmenge gebucht. Diese wird in vollem umfang als Lagerzugang gebucht.
# # Auf den Betriebsauftrag wird nun ein Teil der Menge des Arbeitscheins als Gutmenge gebucht ein weiterer Teil
# # als Ausschuss. Die Gutmenge verursacht keinen Lagerzugang, da die Menge bereits über den Arbeitschein gebucht wurde.
# # Der Ausschuss wird jedoch als Lagerabgang gebucht, da er als Minderung der bereits auf das Lager gebuchten Menge
# # gesehen wird. Wird dieser Auschuss zurückgebaut, muss ein Lagerzugang für das Fertigteil über den Rückbau entstehen.
# # Wichtig ist auch, dass hier die richtige Rückmeldung für den Rückbau vom System ausgewählt wird.
# # NOCH OFFEN: Wie muss die Rückmenge für den Beleg aussehen?
#
# # Fertigungsvorschlag anlegen und freigeben
# Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
# And I append rows
# 	| artikel		| netmge	| bisuch	| mfreig	|
# 	| B_BAUGRUPPE2	| 10		| BG2_40_	| ja		|
# And I press button "freig" to open a subeditor for "BA_freigeben"
# And I close the current editor
# And I switch the current editor to editor "fvor"
# And I save the current editor
#
# # Rückmeldung auf zweiten Arbeitsgang
# Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG2_40_002"
# And I set field "sofort" to "1"
# And I set field "gutmge" to "5" in row 1
# And I save the current editor
#
# # Rückmeldung auf Betriebsauftrag
# Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG2_40_000"
# And I set field "sofort" to "1"
# And I set field "mgr" to "112"
# And I set field "gutmge" to "1" in row 1
# And I set field "verlust" to "2" in row 1
# And I save the current editor
#
# # Rückbau auf Betriebsauftrag
# Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BG2_40_000"
# And I set field "sofort" to "ja"
# And I set field "mgr" to "112"
# And I set field "gutmge" to "-1" in row 1
# And I set field "verlust" to "-2" in row 1
# And I save the current editor
#
# # Lagerjournaleintrag prüfen
# Given I open the infosystem "LJ"
# And I set field "adatum" to "-10"
# And I set field "edatum" to "+30"
# And I set field "beleg" to "barmex" from editor "Rückbau1"
# And I set field "richtung" to "rückwärts"
# And I press start
# Then table has values
# 	| art			| zmge	| amge	| detursache				| rueckmge	| restmge	|
# 	| EINKAUF-3		| 		| -2	| Rückbau Fertigung			| -2		| 0			|
# 	| EINKAUF-3		| 		|  2	| Rückmeldung Fertigung		|  2		| 0			|
# 	| EINKAUF-1		| 		|  2	| Materialentnahme Fertigung|  0		| 2			|
# 	| EINKAUF-2		| 		|  2	| Materialentnahme Fertigung|  0		| 2			|
# And I close the current editor


  Scenario Outline: Baugruppe fuer Scenario 42
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>          |
      | namebspr  | <namebspr>      |
      | dispoa    | auftragsbezogen |
      | bsart     | Eigenfertigung  |
    And I delete all rows
    And I append rows
      | elex    | anzahl    |
      | <elex1> | <anzahl1> |
      | <ag1>   | 1         |
      | <elex2> | <anzahl2> |
      | <elex3> | <anzahl3> |
      | <ag2>   | 1         |
      | <ag3>   | 1         |
      | <ag4>   | 1         |
    And I save the current editor
    Examples:
      | such    | namebspr       | elex1     | anzahl1 | ag1   | elex2     | anzahl2 | elex3     | anzahl3 | ag2   | ag3   | ag4   |
      | BG_SC42 | Baugruppe SC42 | EINKAUF-1 | 71,1014 | A AG1 | EINKAUF-2 | 11,8465 | EINKAUF-3 | 2,9014  | A AG2 | A AG3 | A AG4 |


### Scenarios autorm=nein ###

  Scenario: Konfiguration autorm=nein
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k" 
    And I set fields
      | autorm | nein |
    And I save the current editor


  Scenario: 42 Rückbau auf überbuchten Arbeitsgang mit autorm=false
    And I set the fake date to "17.02.1995"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch | mfreig | verw   |
      | BG_SC42 | 8      | SC42_  | ja     | verw42 |
    And I press button "freig" to open a subeditor for "fv"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf AG1, gut=8 => 8/8
    Given I open an editor "RM1_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SC42_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

# Rückmeldung auf AG2, gut=1 => 1/8
    Given I open an editor "RM1_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SC42_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

# Rückmeldung auf AG2, gut=3 => 4/8
    Given I open an editor "RM2_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SC42_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

# Rückmeldung auf AG3, gut=3 => 3/8
    Given I open an editor "RM1_AS3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SC42_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

# Rückmeldung auf AG2, gut=3 => 7/8
    Given I open an editor "RM3_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SC42_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

# Rückmeldung auf AG3, gut=3 => 6/8
    Given I open an editor "RM2_AS3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SC42_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

# Rückmeldung auf AG2, gut=1 => 8/8
    Given I open an editor "RM4_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SC42_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

# Rückmeldung auf AG3, gut=2 => 8/8
    Given I open an editor "RM3_AS3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SC42_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor

# Rückmeldung auf AG3, gut=1 => 9/8
    Given I open an editor "RM4_AS3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SC42_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

# Rückbau auf AG3, gut=-1 => 8/8 erzeugt DIAG RDSU-2216
    Given I open an editor "RB1_AS3" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "SC42_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-1" in row 1
    And I save the current editor

# Rückmeldung auf AG4, gut=8 => 8/8 => BA abschliessen
    Given I open an editor "RM1_AS4" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SC42_004"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "8" in row 1
    And I save the current editor


### Scenarios autorm=ja ###

  Scenario: Konfiguration autorm=ja
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k" 
    And I set fields
      | autorm | ja |
    And I save the current editor


  Scenario: A01 Teil-Rückbau auf letzten AS eines abgelegten FV
    And I set the fake date to "19.02.1995"
# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau18 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch      |
      | BAUGRUPPE | 10     | ja     | TEILRUECKA_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEILRUECKA_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Rückbau1 zu abgelegten FV und Rückmeldungen prüfen
    Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=TEILRUECKA_;typ=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | -3       | 0       | -3    | 10     | 7      |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 3        | 7       | 10    | 0      | 10     |
      | EINKAUF-2 | 0        | 10      | 10    | 10     | 0      |
      | EINKAUF-1 | 0        | 20      | 20    | 20     | 0      |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | detursache            | amge | zmge | rueckmge | restmge | rueckbew |
      | BAUGRUPPE | Rückbau Fertigung     |      | -3   | -3       | 0       | ja       |
      | BAUGRUPPE | Rückmeldung Fertigung |      | 10   | 3        | 7       | nein     |
      | EINKAUF-1 | Rückmeldung Fertigung | 20   |      | 0        | 20      | nein     |
      | EINKAUF-2 | Rückmeldung Fertigung | 10   |      | 0        | 10      | nein     |
    And I close the current editor

# Lagerjournaleintrag zu Rückbau1 prüfen
    Given I open an editor "LJ_Rückbau" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückbau Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -3 |
      | restmge  | 0  |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Rückmeldung" via ID from editor "LJ_Rückbau" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 10 |
      | rueckmge | 3  |
      | restmge  | 7  |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Nachfolger in Bewertung Rückmeldung ist entstanden
    Given I open an editor "Bewertung_Rückmeldung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=Baugruppe;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "LJ_Rückmeldung"
    Then field "nachfolger" is not empty
    Then field "tmge" has value "10" in row 1
    And I close the current editor

    And I open an editor "Bewertung_Rückbau1" via ID from editor "Bewertung_Rückmeldung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "vorgaenger^id" has value equal to field "id" from editor "Bewertung_Rückmeldung1"
    Then field "ppsrefid" has value equal to field "id" from editor "LJ_Rückmeldung"
    Then field "detursache" has value "Rückbau Fertigung"
    Then field "tmge" has value "7" in row 1
    And I close the current editor

# Lieferschein zu Auftrag
    Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=TEILRUECKA_;typ=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    Given I deliver the SalesOrder "auftrag" with PackingSlip "LS-A01"


  Scenario: A02 Gesamt-Rückbau auf letzten AS eines abgelegten FV
    And I set the fake date to "20.02.1995"
# Auftrag anlegen, Fertigungsvorschlag anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch        |
      | BAUGRUPPE | 10     | ja     | GESAMTRUECKA_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau19 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I delete all rows
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang und Rückbau1 zu abgelegten FV
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GESAMTRUECKA_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=GESAMTRUECKA_;typ=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gutmge" to "-10" in row 1
	Then field "tchzuordnung" is empty in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# Belege prüfen
    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | -10      | 0       | -10   | 10     | 0      |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 10       | 0       | 10    | 0      | 10     |
      | EINKAUF-2 | 0        | 10      | 10    | 10     | 0      |
      | EINKAUF-1 | 0        | 20      | 20    | 20     | 0      |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | detursache            | amge | zmge | rueckmge | restmge | rueckbew |
      | BAUGRUPPE | Rückbau Fertigung     |      | -10  | -10      | 0       | ja       |
      | BAUGRUPPE | Rückmeldung Fertigung |      | 10   | 10       | 0       | nein     |
      | EINKAUF-1 | Rückmeldung Fertigung | 20   |      | 0        | 20      | nein     |
      | EINKAUF-2 | Rückmeldung Fertigung | 10   |      | 0        | 10      | nein     |
    And I close the current editor

# Lagerjournaleintrag zu Rückbau1 prüfen
    Given I open an editor "LJ_Rückbau" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückbau Fertigung;erbtext1=Rückbau1;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -10 |
      | restmge  | 0   |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Rückmeldung" via ID from editor "LJ_Rückbau" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 10 |
      | rueckmge | 10 |
      | restmge  | 0  |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Nachfolger in Bewertung Rückmeldung ist entstanden
    Given I open an editor "Bewertung_Rückmeldung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=Baugruppe;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "LJ_Rückmeldung"
    Then field "nachfolger" is not empty
    Then field "tmge" has value "10" in row 1
    And I close the current editor

    And I open an editor "Bewertung_Rückbau" via ID from editor "Bewertung_Rückmeldung" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "vorgaenger^id" has value equal to field "id" from editor "Bewertung_Rückmeldung"
    Then field "ppsrefid" has value equal to field "id" from editor "LJ_Rückmeldung"
    Then field "detursache" has value "Rückbau Fertigung"
    Then field "tmge" has value "0" in row 1
    And I close the current editor

# BA abschließen und liefern
    Given I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "gutmge" to "10" in row 1
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A02"


  Scenario: A03 Teil-Rückbau auf Betriebsauftrag eines abgelegten FV, bisher Rückmeldung auf Betriebsauftrag gebucht
    And I set the fake date to "22.02.1995"
# Fertigungsvorschlag anlegen und freigeben
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "B_SCENA03"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_SCENA03"

    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch     |
      | BAUGRUPPE | 10     | ja     | GESAMTRBA_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau20 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I delete all rows
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung1 auf Betriebsauftrag und Rückbau1 zu abgelegten FV
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GESAMTRBA_000"
    And I set fields
      | sofort | ja          |
      | gut    | ja          |
      | mgr    | 112         |
      | bem    | Rückmeldung |
    And I save the current editor

# Bestand pruefen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 10    |        | (0,0,0)          |
      |       | 10     | !Rückmeldung1^id |
    And I set fields
      | artikel | EINKAUF-1 |
      | nullmge | nein      |
    Then the table has 0 rows
    And I close the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=GESAMTRBA_000;bem=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

# Belege prüfen
    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | -3       | 0       | -3    | 10     | 7      |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 3        | 7       | 10    | 0      | 10     |
      | EINKAUF-2 | 0        | 10      | 10    | 10     | 0      |
      | EINKAUF-1 | 0        | 20      | 20    | 20     | 0      |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | detursache             | amge | zmge | rueckmge | restmge | rueckbew | !row |
      | BAUGRUPPE | Rückbau Fertigung      |      | -3   | -3       | 0       | ja       | 1    |
      | BAUGRUPPE | Preisbildung Fertigung |      | 10   | 0        | 10      | nein     | 2    |
      | BAUGRUPPE | Rückmeldung Fertigung  |      | 10   | 3        | 7       | nein     | 3    |
      | EINKAUF-1 | Rückmeldung Fertigung  | 20   |      | 0        | 20      | nein     | 4    |
      | EINKAUF-2 | Rückmeldung Fertigung  | 10   |      | 0        | 10      | nein     | 5    |
    And I close the current editor

# Lagerjournaleintrag zu Rückbau1 prüfen
    Given I open an editor "LJ_Rückbau" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückbau Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -3 |
      | restmge  | 0  |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Rückmeldung" via ID from editor "LJ_Rückbau" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 10 |
      | rueckmge | 3  |
      | restmge  | 7  |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Bestand pruefen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 7     |        | (0,0,0)          |
      |       | 7      | !Rückmeldung1^id |
    And I set fields
      | artikel | EINKAUF-1 |
      | nullmge | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Nachfolger in Bewertung Rückmeldung ist entstanden
    Given I open an editor "Bewertung_Rückmeldung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=Baugruppe;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "nachfolger" is not empty
    Then field "ppsrefid" has value equal to field "id" from editor "LJ_Rückmeldung"
    Then field "tmge" has value "10" in row 1
    And I close the current editor

    And I open an editor "Bewertung_Rückbau" via ID from editor "Bewertung_Rückmeldung" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "vorgaenger^id" has value equal to field "id" from editor "Bewertung_Rückmeldung"
    Then field "detursache" has value "Rückbau Fertigung"
    Then field "ppsrefid" has value equal to field "id" from editor "LJ_Rückmeldung"
    Then field "tmge" has value "7" in row 1
    And I close the current editor

# FV abschließen und Auftrag liefern
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "gutmge" to "10" in row 1
    And I save the current editor
    Given I deliver the SalesOrder "auftrag" with PackingSlip "LS-A03"


  Scenario: A04 Teil-Rückbau zu letzten AS eines abgelegten FV, FertigteilMZ mit Behältern  vor Freigabe FV angelegt
    And I set the fake date to "23.02.1995"
# Behälter anlegen
    Given I create a Container "ABLAGE_GUTMGE1" for packaging material "BEHAELTER"
    Given I create a Container "ABLAGE_GUTMGE2" for packaging material "BEHAELTER"

# Auftrag anlegen und Fertigungsvorschlag anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-BEHAELTER" and quantity "10"
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig |
      | BG-BEHAELTER | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row !lastRow
    And I delete all rows
    And I append rows
      | zuomge | behaelter          |
      | 5      | !ABLAGE_GUTMGE1^id |
      | 5      | !ABLAGE_GUTMGE2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEHRUECKA_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau22 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 20  |
      | EINKAUF-2  | 10  |
      | BEHAELTER  | 4   |
      | EU-PALETTE | 1   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHRUECKA_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I set field "behaelter" to id from editor "ABLAGE_GUTMGE1"
    And I save the current editor

# Rückbau1 zu abgelegten FV
    Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=BEHRUECKA_;typ=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "behaelter" to id from editor "ABLAGE_GUTMGE1"
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

# Behälter prüfen
    Then Container from editor "ABLAGE_GUTMGE1" is empty
    Then field "mge" from editor "ABLAGE_GUTMGE2" in row 1 has value "5"

# FV abschließen und Lieferschein
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "behaelter" to id from editor "ABLAGE_GUTMGE2"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Then Container from editor "ABLAGE_GUTMGE1" is empty
    Then field "mge" from editor "ABLAGE_GUTMGE2" in row 1 has value "10"

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I modify table
      | !row | mge |
      | 1    | 10  |
    And I set field "behaelter" to id from editor "ABLAGE_GUTMGE2" in row 1
    And I press button "packvor"
    And I save the current editor


  Scenario: A05 Teil-Rückbau auf letzten AS eines abgelegten FV bucht Behälter ins Negative, wenn Behälter leer ist oder nicht ausreichend Menge enthält, bisher Rückmeldung in Behälter, dann Gutmenge in anderen Behälter umgebucht
    And I set the fake date to "24.02.1995"
# Auftrag und Behälter anlegen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-BEHAELTER" and quantity "10"
    Given I create a Container "BEH_MIT_GUTMGE" for packaging material "BEHAELTER"
    Given I create a Container "BEH_OHNE_GUTMGE" for packaging material "BEHAELTER"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch     |
      | BG-BEHAELTER | 10     | ja     | FALSCHERB_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau22 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 20  |
      | EINKAUF-2  | 10  |
      | BEHAELTER  | 4   |
      | EU-PALETTE | 1   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALSCHERB_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I set field "behaelter" to id from editor "BEH_MIT_GUTMGE"
    And I save the current editor
    Then field "mge" from editor "BEH_MIT_GUTMGE" in row 1 has value "10"

# Rückbau1 zu abgelegten FV, Behälter prüfen
    Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=FALSCHERB_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "behaelter" to id from editor "BEH_OHNE_GUTMGE"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor
    Then field "mge" from editor "BEH_OHNE_GUTMGE" in row 1 has value "-3"

# Umbuchung BEH_OHNE_GUTMGE in BEH_MIT_GUTMGE, FV abschließen und Auftrag liefern
Given I open the infosystem "SQRELOCATION"
And I set field "container" to id from editor "BEH_MIT_GUTMGE"
And I set field "workflow" to "Bestand umpacken"
And I press start
And I set field "tmge" to "3" in row 1
And I set field "tbehzugang" to id from editor "BEH_OHNE_GUTMGE" in row 1
And I set field "tmark" to "ja" in row 1
And I press button "umbuch"
And I close the current editor

    
	Then Container from editor "BEH_OHNE_GUTMGE" is empty
	 
    Then field "mge" from editor "BEH_MIT_GUTMGE" in row 1 has value "7"

    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "behaelter" to id from editor "BEH_MIT_GUTMGE"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I modify table
      | !row | mge |
      | 1    | 10  |
    And I set field "behaelter" to id from editor "BEH_MIT_GUTMGE" in row 1
    And I press button "packvor"
    And I save the current editor


  Scenario: A06 Teil-Rückbau auf abgelegte FV möglich, wenn Gutmenge in Behälter auf einem anderen Lagerplatz liegt, Prüfung auf Lagerplatz
    And I set the fake date to "25.02.1995"
# Auftrag und Behälter anlegen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-BEHAELTER" and quantity "10"
    Given I create a Container "LAGERPLATZ" for packaging material "BEHAELTER"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch      |
      | BG-BEHAELTER | 10     | ja     | LAGERPLATZ_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau24 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 20  |
      | EINKAUF-2  | 10  |
      | BEHAELTER  | 4   |
      | EU-PALETTE | 1   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LAGERPLATZ_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I set field "behaelter" to id from editor "LAGERPLATZ"
    And I save the current editor

# Behälter umlagern
    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | BG-BEHAELTER |
      | buart   | Umbuchung    |
      | beleg   | 24           |
      | beldat  | .            |
    And I append rows
      | platz2 | platz | mge | behaelter      | behaelterzu    |
      | F2     | F1    | 10  | !LAGERPLATZ^id | !LAGERPLATZ^id |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I set field "verw2" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I save the current editor

# Rückbau1 zu abgelegten FV und Behälter prüfen
    Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=LAGERPLATZ_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "behaelter" to id from editor "LAGERPLATZ"
    And I set field "gutmge" to "-3" in row 1
    Then field "buplatz" has value "F2" in row 1
    And I save the current editor
    Then field "mge" from editor "LAGERPLATZ" in row 1 has value "7"

# Menge rückmelden, Behälter prüfen und Lieferschein
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "behaelter" to id from editor "LAGERPLATZ"
    And I set field "gutmge" to "3" in row 1
    Then field "buplatz" has value "F2" in row 1
    And I save the current editor
    Then field "mge" from editor "LAGERPLATZ" in row 1 has value "10"

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I modify table
      | !row | mge | platz |
      | 1    | 10  | F2    |
    And I set field "behaelter" to id from editor "LAGERPLATZ" in row 1
    And I press button "packvor"
    And I save the current editor


  Scenario: A07 Teil-Rückbau auf abgelegten FV, der zwei Rückmeldungen auf letzten AS betrifft, bisher zwei Rückmeldumgen auf letzten AS gebucht
    And I set the fake date to "26.02.1995"
# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau20 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch      |
      | BAUGRUPPE | 10     | ja     | ZWEIRUECKM_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEIRUECKM_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward
# 1 = "04.02.1995"

# Rückmeldung2 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEIRUECKM_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I set field "erbtext1" to "Rückmeldung2" in row 1
    And I save the current editor

# Rückbau1 zu abgelegten FV
    Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=ZWEIRUECKM_001;typ=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gutmge" to "-7" in row 1
    And I set field "erbtext1" to "T-Rückbau1" in row 1
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | detursache            | amge | zmge | rueckmge | restmge | rueckbew |
      | BAUGRUPPE | Rückbau Fertigung     |      | -5   | -5       | 0       | ja       |
      | BAUGRUPPE | Rückbau Fertigung     |      | -2   | -2       | 0       | ja       |
      | BAUGRUPPE | Rückmeldung Fertigung |      | 5    | 5        | 0       | nein     |
      | EINKAUF-1 | Rückmeldung Fertigung | 10   |      | 0        | 10      | nein     |
      | EINKAUF-2 | Rückmeldung Fertigung | 5    |      | 0        | 5       | nein     |
      | BAUGRUPPE | Rückmeldung Fertigung |      | 5    | 2        | 3       | nein     |
      | EINKAUF-1 | Rückmeldung Fertigung | 10   |      | 0        | 10      | nein     |
      | EINKAUF-2 | Rückmeldung Fertigung | 5    |      | 0        | 5       | nein     |
    And I close the current editor

# Rückmeldebelege und Lagerjournaleintrag zu Rückbau1/ Rückmeldung2 prüfen
    Given I open an editor "LJ_Rückbau1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,rueckmge=-5;detursache=Rückbau Fertigung;erbtext1=T-Rückbau1;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -5 |
      | restmge  | 0  |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Rückmeldung2" via ID from editor "LJ_Rückbau1" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 5 |
      | rueckmge | 5 |
      | restmge  | 0 |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung2"
    And I close the current editor

    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then  table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | -7       | 0       | -7    | 10     | 3      |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then  table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 5        | 0       | 5     | 5      | 10     |
      | EINKAUF-2 | 0        | 5       | 5     | 5      | 0      |
      | EINKAUF-1 | 0        | 10      | 10    | 10     | 0      |
    And I close the current editor

# Lagerjournaleintrag zu Rückbau1/ Rückmeldung1 prüfen
    Given I open an editor "LJ_Rückbau" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,rueckmge=-2;detursache=Rückbau Fertigung;erbtext1=T-Rückbau1;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -2 |
      | restmge  | 0  |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Rückmeldung1" via ID from editor "LJ_Rückbau" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 5 |
      | rueckmge | 2 |
      | restmge  | 3 |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then  table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 2        | 3       | 5     | 0      | 5      |
      | EINKAUF-2 | 0        | 5       | 5     | 10     | 5      |
      | EINKAUF-1 | 0        | 10      | 10    | 20     | 10     |
    And I close the current editor

# FV fertigstellen und Auftrag liefern
    Given I open an editor "Rückmeldung3" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=ZWEIRUECKM_001;typ=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gutmge" to "7" in row 1
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A07"


  Scenario: A08 Teil-Rückbau auf letzten AS eines abgelegten FV, FertigteilMZ mit Chargen vor Freigabe FV angelegt
    And I set the fake date to "27.02.1995"
# Chargen anlegen
    Given I create a Lot "CH_BG1" for Product "BAUGRUPPE"
    Given I create a Lot "CH_BG2" for Product "BAUGRUPPE"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau26 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BAUGRUPPE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row !lastRow
    And I delete all rows
    And I append rows
      | zuomge | charge     |
      | 5      | !CH_BG1^id |
      | 5      | !CH_BG2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "CHARGENABL_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGENABL_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Rückbau1 zu abgelegten FV
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-5" in row 1
    And I set field "charge" to "CH_BG1" in row 1
    And I save the current editor

# Rückbau1 zu abgelegten FV
    Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-2" in row 1
    And I set field "charge" to "CH_BG2" in row 1
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | detursache            | amge | zmge | rueckmge | restmge | rueckbew | ncharge^such | vcharge^such |
      | BAUGRUPPE | Rückbau Fertigung     |      | -2   | -2       | 0       | ja       | CH_BG2       |              |
      | BAUGRUPPE | Rückbau Fertigung     |      | -5   | -5       | 0       | ja       | CH_BG1       |              |
      | BAUGRUPPE | Rückmeldung Fertigung |      | 5    | 2        | 3       | nein     | CH_BG2       |              |
      | BAUGRUPPE | Rückmeldung Fertigung |      | 5    | 5        | 0       | nein     | CH_BG1       |              |
      | EINKAUF-1 | Rückmeldung Fertigung | 10   |      | 0        | 10      | nein     | CH_BG2       |              |
      | EINKAUF-1 | Rückmeldung Fertigung | 10   |      | 0        | 10      | nein     | CH_BG1       |              |
      | EINKAUF-2 | Rückmeldung Fertigung | 5    |      | 0        | 5       | nein     | CH_BG2       |              |
      | EINKAUF-2 | Rückmeldung Fertigung | 5    |      | 0        | 5       | nein     | CH_BG1       |              |
    And I close the current editor

# Rückmeldung und Rückgabebeleg prüfen
    Given I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | -5       | 0       | -5    | 10     | 5      |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau2" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | -2       | 0       | -2    | 5      | 3      |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 7        | 3       | 10    | 0      | 10     |
      | EINKAUF-2 | 0        | 10      | 10    | 10     | 0      |
      | EINKAUF-1 | 0        | 20      | 20    | 20     | 0      |
    And I close the current editor

# FV fertigstellen und Auftrag liefern
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "gutmge" to "7" in row 1
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A08"


  Scenario: A09 Teil-Rückbau ohne Chargenangabe zu abgelegtem FV, der zwei Rückmeldungen auf letzten AS mit betrifft, bisher zwei Rückmeldungen mit verschiedenen Chargen gebucht
    And I set the fake date to "28.02.1995"
# Chargen anlegen
    Given I create a Lot "CH_BG1-A09" for Product "BAUGRUPPE"
    Given I create a Lot "CH_BG2-A09" for Product "BAUGRUPPE"

# Auftrag und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau20 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch      |
      | BAUGRUPPE | 10     | ja     | ZWEICHARGE_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEICHARGE_001"
    And I set fields
      | sofort  | ja                |
      | kcharge | !CH_BG1-A09^id    |
      | bem     | Rückmeldung1      |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward
# 1 = "04.02.1995"

# Rückmeldung2 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEICHARGE_001"
    And I set fields
      | sofort  | ja                |
      | kcharge | !CH_BG2-A09^id    |
      | bem     | Rückmeldung2      |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

# Rückbau1 zu abgelegten FV
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | gutmge | erbtext1   | charge            | !row |
      | -2     | S-Rückbau1 | !CH_BG2-A09^id    | 1    |
    And I save the current editor

# Rückmelde- und Rückbaubelege und Lagerjournaleintrag zu Rückbau1/ Rückmeldung2 prüfen
    Given I open an editor "LJ_Rückbau1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,rueckmge=-2;detursache=Rückbau Fertigung;erbtext1=S-Rückbau1;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -2 |
      | restmge  | 0  |
    Then field "ncharge^such" has value "CH_BG2-A09" in row 1
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Rückmeldung2" via ID from editor "LJ_Rückbau1" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 5 |
      | rueckmge | 2 |
      | restmge  | 3 |
    Then field "ncharge^such" has value "CH_BG2-A09" in row 1
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung2"
    And I close the current editor

    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | -2       | 0       | -2    | 10     | 8      |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 2        | 3       | 5     | 5      | 10     |
      | EINKAUF-2 | 0        | 5       | 5     | 5      | 0      |
      | EINKAUF-1 | 0        | 10      | 10    | 10     | 0      |
    And I close the current editor

# Rückbau2 zu abgelegten FV
    Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | gutmge | charge         | erbtext1   | !row |
      | -5     | !CH_BG1-A09^id | S-Rückbau2 | 1    |
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | detursache            | amge | zmge | rueckmge | restmge | rueckbew | ncharge^such |
      | BAUGRUPPE | Rückbau Fertigung     |      | -5   | -5       | 0       | ja       | CH_BG1-A09   |
      | BAUGRUPPE | Rückbau Fertigung     |      | -2   | -2       | 0       | ja       | CH_BG2-A09   |
      | BAUGRUPPE | Rückmeldung Fertigung |      | 5    | 2        | 3       | nein     | CH_BG2-A09   |
      | EINKAUF-1 | Rückmeldung Fertigung | 10   |      | 0        | 10      | nein     | CH_BG2-A09   |
      | EINKAUF-2 | Rückmeldung Fertigung | 5    |      | 0        | 5       | nein     | CH_BG2-A09   |
      | BAUGRUPPE | Rückmeldung Fertigung |      | 5    | 5        | 0       | nein     | CH_BG1-A09   |
      | EINKAUF-1 | Rückmeldung Fertigung | 10   |      | 0        | 10      | nein     | CH_BG1-A09   |
      | EINKAUF-2 | Rückmeldung Fertigung | 5    |      | 0        | 5       | nein     | CH_BG1-A09   |
    And I close the current editor

# FV abschließen und Auftrag liefern
    Given I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "kcharge" to id from editor "CH_BG1-A09"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I switch the current editor to editor "Rückmeldung2" with command "COPY"
    And I set field "kcharge" to id from editor "CH_BG2-A09"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "10" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | zuomge | charge         | !row |
      | 5      | !CH_BG1-A09^id | 1    |
      | 5      | !CH_BG2-A09^id | +2   |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor


  Scenario: A10 Rückbau auf letzten AS zu abgelegtem FV, FV mit Projekt freigegeben
    And I set the fake date to "01.03.1995"
# Projekt anlegen
    Given I open an editor "PROJEKT_BG29" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT_BG29"
    And I set field "such" to "PROJEKT_BG29"
    And I save the current editor

# Bestand BAUGRUPPE auf 0 korrigieren und Auftrag anlegen
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "B_SCENA10"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_SCENA10"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "B_SCENA10"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1" with document "B_SCENA10"

# Auftrag anlegen (AFL um bedarfsbezogenes Teil ergänzen) und Bedarfe einkaufen
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I append rows
      | artikel   | mge | projekt      |
      | BAUGRUPPE | 50  | PROJEKT_BG29 |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I modify table
      | !row | elex        | elanzahl |
      | -2   | EINKAUF-2   | 1        |
      | +2   | B_EINKAUF-2 | 1        |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau28 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel     | mge | projekt      |
      | EINKAUF-1   | 100 | PROJEKT_BG29 |
      | B_EINKAUF-2 | 50  |              |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set fields
      | artikel | BAUGRUPPE |
    And I press button "ladetab"
    And I modify table
      | !row                                                 | mfreig | bisuch      |
      | projekt=='PROJEKT_BG29' && mge==50 && mfreig=='nein' | ja     | PROJEKTABL_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROJEKTABL_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor
    And I wait 1 time units to move the time forward
# 1 = "04.02.1995"

# Rückbau1 zu abgelegten FV
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-30" in row 1
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | detursache            | amge | zmge | rueckmge | restmge | rueckbew | projekt      | projektla |
      | BAUGRUPPE   | Rückbau Fertigung     |      | -30  | -30      | 0       | ja       | PROJEKT_BG29 | ja        |
      | BAUGRUPPE   | Rückmeldung Fertigung |      | 50   | 30       | 20      | nein     | PROJEKT_BG29 | ja        |
      | EINKAUF-1   | Rückmeldung Fertigung | 100  |      | 0        | 100     | nein     | PROJEKT_BG29 | ja        |
      | B_EINKAUF-2 | Rückmeldung Fertigung | 50   |      | 0        | 50      | nein     | PROJEKT_BG29 | nein      |
    And I close the current editor

# Rückmeldund, Rückbau und Lagerjournaleintrag zu Rückbau1 prüfen
    Given I open an editor "LJ_Rückbau" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=Baugruppe;detursache=Rückbau Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -30          |
      | restmge  | 0            |
      | projekt  | PROJEKT_BG29 |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Rückmeldung" via ID from editor "LJ_Rückbau" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 50           |
      | rueckmge | 30           |
      | restmge  | 20           |
      | projekt  | PROJEKT_BG29 |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# FV abschließen und Auftrag liefern
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "gutmge" to "30" in row 1
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A10"


  Scenario: A11 Rückbau zu abgelegtem FV, der zwei Rückmleldungen auf letzten AS betrifft, FV mit Projekt freigegeben
    And I set the fake date to "02.03.1995"
# Projekt anlegen
    Given I open an editor "PROJEKT_BG29" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT_BG29"
    And I set field "such" to "PROJEKT_BG29"
    And I save the current editor

# Bestand BAUGRUPPE auf 0 korrigieren und Auftrag anlegen, in AFL auftrags- und bedarfsbezogene Komponente
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "B_SCENA11"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_SCENA11"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1" with document "B_SCENA11"

    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I append rows
      | artikel   | mge | projekt      |
      | BAUGRUPPE | 70  | PROJEKT_BG29 |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I modify table
      | !row | elex        | elanzahl |
      | -2   |             |          |
      | +2   | B_EINKAUF-2 | 1        |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau12 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel     | mge | projekt      |
      | EINKAUF-1   | 140 | PROJEKT_BG29 |
      | B_EINKAUF-2 | 70  |              |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set fields
      | artikel | BAUGRUPPE |
    And I press button "ladetab"
    And I modify table
      | !row                                                 | mfreig | bisuch      |
      | projekt=='PROJEKT_BG29' && mfreig=='nein' && mge==70 | ja     | PROJEKTABL_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROJEKTABL_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "20" in row 1
    And I set field "erbtext1" to "Projekt_RM1" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward
# 1 = "04.02.1995"

# Rückmeldung2 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROJEKTABL_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "50" in row 1
    And I set field "erbtext1" to "Projekt_RM2" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

# Rückbau1 zu abgelegten FV
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-60" in row 1
    And I set field "erbtext1" to "Projekt_RB1" in row 1
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | detursache            | amge | zmge | rueckmge | restmge | rueckbew | projekt      | projektla |
      | BAUGRUPPE   | Rückbau Fertigung     |      | -50  | -50      | 0       | ja       | PROJEKT_BG29 | ja        |
      | BAUGRUPPE   | Rückbau Fertigung     |      | -10  | -10      | 0       | ja       | PROJEKT_BG29 | ja        |
      | BAUGRUPPE   | Rückmeldung Fertigung |      | 50   | 50       | 0       | nein     | PROJEKT_BG29 | ja        |
      | EINKAUF-1   | Rückmeldung Fertigung | 100  |      | 0        | 100     | nein     | PROJEKT_BG29 | ja        |
      | B_EINKAUF-2 | Rückmeldung Fertigung | 50   |      | 0        | 50      | nein     | PROJEKT_BG29 | nein      |
      | BAUGRUPPE   | Rückmeldung Fertigung |      | 20   | 10       | 10      | nein     | PROJEKT_BG29 | ja        |
      | EINKAUF-1   | Rückmeldung Fertigung | 40   |      | 0        | 40      | nein     | PROJEKT_BG29 | ja        |
      | B_EINKAUF-2 | Rückmeldung Fertigung | 20   |      | 0        | 20      | nein     | PROJEKT_BG29 | nein      |
    And I close the current editor

# Rückmeldung, Rückau unf Lagerjournaleintrag zu Rückbau1 prüfen
    Given I open an editor "LJ_Rückbau1_1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,erbtext1=Projekt_RB1;rueckmge=-10;detursache=Rückbau Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -10          |
      | restmge  | 0            |
      | projekt  | PROJEKT_BG29 |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Rückmeldung1_1" via ID from editor "LJ_Rückbau1_1" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 20           |
      | rueckmge | 10           |
      | restmge  | 10           |
      | projekt  | PROJEKT_BG29 |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    Given I open an editor "LJ_Rückbau1_2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,erbtext1=Projekt_RB1;rueckmge=-50;detursache=Rückbau Fertigung;@sort=Suchwort;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -50          |
      | restmge  | 0            |
      | projekt  | PROJEKT_BG29 |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
    And I close the current editor

    And I open an editor "LJ_Rückmeldung1_2" via ID from editor "LJ_Rückbau1_2" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge      | 50           |
      | rueckmge | 50           |
      | restmge  | 0            |
      | projekt  | PROJEKT_BG29 |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung2"
    And I close the current editor

    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE   | -60      | 0       | -60   | 70     | 10     |
      | EINKAUF-1   | 0        | 0       | 0     | 140    | 140    |
      | B_EINKAUF-2 | 0        | 0       | 0     | 70     | 70     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE   | 10       | 10      | 20    | 0      | 20     |
      | B_EINKAUF-2 | 0        | 20      | 20    | 70     | 50     |
      | EINKAUF-1   | 0        | 40      | 40    | 140    | 100    |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE   | 50       | 0       | 50    | 20     | 70     |
      | B_EINKAUF-2 | 0        | 50      | 50    | 50     | 0      |
      | EINKAUF-1   | 0        | 100     | 100   | 100    | 0      |
    And I close the current editor

# FV abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "60" in row 1
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A11"


  Scenario: A12 Drei Rückbauten auf letzen AS eines abgelegten FV, RB1 Behälter und Charge, RB2 Behälter, RB3 Behälter und Charge angegeben, bisher eine Rückmeldung, FertigteilMZ mit Behälter und Charge  vor Freigabe FV angelegt
    And I set the fake date to "03.03.1995"
# Bestand auf 0 korrigieren, Behälter anlegen
    Given I set StorageQuantity to zero for Product "BG-BEHAELTER" on StorageLocation "F1"
    Given I create a Container "BEHAELTER1" for packaging material "BEHAELTER"
    Given I create a Container "BEHAELTER2" for packaging material "BEHAELTER"

# Charge anlegen
    Given I create a Lot "CH_BEH1" for Product "BG-BEHAELTER"
    Given I create a Lot "CH_BEH2" for Product "BG-BEHAELTER"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-BEHAELTER" and quantity "10"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau30 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 20  |
      | EINKAUF-2  | 10  |
      | BEHAELTER  | 4   |
      | EU-PALETTE | 1   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | mfreig |
      | BG-BEHAELTER | 10  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row !lastRow
    And I delete all rows
    And I append rows
      | zuomge | charge      | behaelter      |
      | 5      | !CH_BEH1^id | !BEHAELTER1^id |
      | 5      | !CH_BEH2^id | !BEHAELTER2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "CHARGEBEH_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang und Bestand prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGEBEH_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | BG-BEHAELTER |
      | klplatz   | F1           |
      | behaelter | ja           |
      | details   | nein         |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | tbehaelter^id  | charge^such |
      | 5      | !BEHAELTER1^id | CH_BEH1     |
      | 5      | !BEHAELTER2^id | CH_BEH2     |
    And I close the current editor

# Rückbau2 zu abgelegten FV, Bestand und Behälter prüfen
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | behaelter | !BEHAELTER1^id  |
      | kcharge   | !CH_BEH1^nummer |
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

    Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | behaelter | !BEHAELTER2^id  |
      | kcharge   | !CH_BEH2^nummer |
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor

    Given I open an editor "Rückbau3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | behaelter | !BEHAELTER2^id  |
      | kcharge   | !CH_BEH2^nummer |
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

    Then Container from editor "BEHAELTER2" is empty
    And I switch the current editor to editor "BEHAELTER1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | mge | charge^such |
      | 2   | CH_BEH1     |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | BG-BEHAELTER |
      | klplatz   | F1           |
      | behaelter | ja           |
      | details   | nein         |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | tbehaelter^id  | charge^such |
      | 2      | !BEHAELTER1^id | CH_BEH1     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | detursache            | amge | zmge | rueckmge | restmge | vcharge^such | ncharge^such | behaelter^id   | !row |
      | BG-BEHAELTER | Rückbau Fertigung     |      | -3   | -3       | 0       |              | CH_BEH2      | !BEHAELTER2^id | 1    |
      | BG-BEHAELTER | Rückbau Fertigung     |      | -2   | -2       | 0       |              | CH_BEH2      | !BEHAELTER2^id | 2    |
      | BG-BEHAELTER | Rückbau Fertigung     |      | -3   | -3       | 0       |              | CH_BEH1      | !BEHAELTER1^id | 3    |
      | BG-BEHAELTER | Rückmeldung Fertigung |      | 5    | 5        | 0       |              | CH_BEH2      | !BEHAELTER2^id | 4    |
      | BG-BEHAELTER | Rückmeldung Fertigung |      | 5    | 3        | 2       |              | CH_BEH1      | !BEHAELTER1^id | 5    |
      | EINKAUF-1    | Rückmeldung Fertigung | 10   |      | 0        | 10      |              | CH_BEH2      | !dontChange    | 6    |
      | EINKAUF-1    | Rückmeldung Fertigung | 10   |      | 0        | 10      |              | CH_BEH1      | !dontChange    | 7    |
      | EINKAUF-2    | Rückmeldung Fertigung | 5    |      | 0        | 5       |              | CH_BEH2      | !dontChange    | 8    |
      | EINKAUF-2    | Rückmeldung Fertigung | 5    |      | 0        | 5       |              | CH_BEH1      | !dontChange    | 9    |
    And I close the current editor

# Fehlende Menge nachbuchen
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | behaelter | !BEHAELTER1^id  |
      | kcharge   | !CH_BEH1^nummer |
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | BG-BEHAELTER |
      | klplatz   | F1           |
      | behaelter | ja           |
      | details   | nein         |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | tbehaelter^id  | charge^such |
      | 10     | !BEHAELTER1^id | CH_BEH1     |
    And I close the current editor

# Auftrag liefern
    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I modify table
      | !row | mge | behaelter      | charge   |
      | 1    | 10  | !BEHAELTER1^id | !CH_BEH1 |
    And I save the current editor


  Scenario: A13 Rückbau zu abgelegtem FV, der zwei Rückmeldungen auf letzten AS betrifft, EnthamheMZ mit Einheiten vor Freigabe FV angelegt
    And I set the fake date to "04.03.1995"
# Bestandskorrektur BAUGRUPPE und Auftrag anlegen
    Given I set StorageQuantity to zero for Product "BG-EINHEITEN" on StorageLocation "F1" with document "KORR-A13"
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "KORR-A13"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "KORR-A13"
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITEN" and quantity "40"

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ebeleg | RückbauP19 |
      | ueb    | ja         |
      | fakt   | ja         |
    And I append rows
      | artikel    | mge |
      | GEBINDE    | 40  |
      | GEBINDEPFL | 4   |
      | EINKAUF-1  | 8   |
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben, Betriebsauftrag aufrufen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig |
      | BG-EINHEITEN | 8      | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "mzabsm" to open a subeditor for "MZ_Entnahme" in row !lastRow
    And I press button "abv" to open a subeditor for "MZ_Entnahme1"
    And I close the current editor
    And I switch the current editor to editor "MZ_Entnahme"
    And I modify table
      | zuomge | einh | !row |
      | 4      | Paar | +1   |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "EINHEITA_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang und Bewertungen prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINHEITA_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Bewertung_1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BG-EINHEITEN;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINHEITA_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

    Given I open an editor "Bewertung_2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BG-EINHEITEN;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung2"
    And I close the current editor

    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINHEITA_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor

    Given I open an editor "Bewertung_3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BG-EINHEITEN;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung3"
    And I close the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITEN |
      | klplatz    | F1           |
      | verdichten | nein         |
      | details    | nein         |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 8     |        | (0,0,0)          |
      |       | 3      | !Rückmeldung1^id |
      |       | 3      | !Rückmeldung2^id |
      |       | 2      | !Rückmeldung3^id |
    And I close the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | gutmge      | mge         | bueinh      | erbtext1   | !row                    |
      | -5          | !dontChange | !dontChange | A-Rückbau1 | artikel=="BG-EINHEITEN" |
      | !dontChange | -1          | kg          | A-Rückbau1 | artikel=="GEBINDE"      |
      | !dontChange | -1          | Paar        | A-Rückbau1 | artikel=="GEBINDEPFL"   |
      | !dontChange | -1          | !dontChange | A-Rückbau1 | artikel=="EINKAUF-1"    |
    Then table has values
      | !row | rueckmge | restmge | limgev | limgen |
      | 1    | 0        | -5      | 8      | 3      |
      | 2    | 0        | -0.2    | 8      | 7.8    |
      | 3    | 0        | -2      | 8      | 6      |
      | 4    | 0        | -1      | 8      | 7      |
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | zmge | amge | mei   | detursache            | rueckmge | restmge | !row |
      | BG-EINHEITEN | -2   |      | Stück | Rückbau Fertigung     | -2       | 0       | 1    |
      | BG-EINHEITEN | -3   |      | Stück | Rückbau Fertigung     | -3       | 0       | 2    |
      | GEBINDE      |      | -0.2 | Stück | Rückbau Fertigung     | -0.2     | 0       | 3    |
      | GEBINDEPFL   |      | -1   | Paar  | Rückbau Fertigung     | -2       | 0       | 4    |
      | EINKAUF-1    |      | -1   | Stück | Rückbau Fertigung     | -1       | 0       | 5    |
      | BG-EINHEITEN | 2    |      | Stück | Rückmeldung Fertigung | 2        | 0       | 6    |
      | GEBINDE      |      | 2    | Stück | Rückmeldung Fertigung | 0.2      | 1.8     | 7    |
      | GEBINDEPFL   |      | 1    | Paar  | Rückmeldung Fertigung | 2        | 0       | 8    |
      | EINKAUF-1    |      | 2    | Stück | Rückmeldung Fertigung | 1        | 1       | 9    |
      | BG-EINHEITEN | 3    |      | Stück | Rückmeldung Fertigung | 3        | 0       | 10   |
      | GEBINDE      |      | 3    | Stück | Rückmeldung Fertigung | 0        | 3       | 11   |
      | GEBINDEPFL   |      | 1.5  | Paar  | Rückmeldung Fertigung | 0        | 3       | 12   |
      | EINKAUF-1    |      | 3    | Stück | Rückmeldung Fertigung | 0        | 3       | 13   |
      | BG-EINHEITEN | 3    |      | Stück | Rückmeldung Fertigung | 0        | 3       | 14   |
      | GEBINDE      |      | 3    | Stück | Rückmeldung Fertigung | 0        | 3       | 15   |
      | GEBINDEPFL   |      | 1.5  | Paar  | Rückmeldung Fertigung | 0        | 3       | 16   |
      | EINKAUF-1    |      | 3    | Stück | Rückmeldung Fertigung | 0        | 3       | 17   |
    And I close the current editor

# Journaleinträge prüfen
    Given I open an editor "LJ_BG_Rück1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BG-EINHEITEN;mge=-2;erbtext1=A-Rückbau1;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -2 |
      | restmge  | 0  |
      | mge      | -2 |
    And I close the current editor

    Given I open an editor "LJ_BG_Orig1" via ID from editor "LJ_BG_Rück1" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then field "vorgang^id" in row 0 has value equal to field "id" from editor "Rückmeldung3" in row 0
    Then fields have values
      | rueckmge | 2 |
      | restmge  | 0 |
      | mge      | 2 |
    And I close the current editor

    Given I open an editor "LJ_BG_Rück2" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BG-EINHEITEN;mge=-3;erbtext1=A-Rückbau1;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -3 |
      | restmge  | 0  |
      | mge      | -3 |
    And I close the current editor

    Given I open an editor "LJ_BG_Orig2" via ID from editor "LJ_BG_Rück2" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then field "vorgang^id" in row 0 has value equal to field "id" from editor "Rückmeldung2" in row 0
    Then fields have values
      | rueckmge | 3 |
      | restmge  | 0 |
      | mge      | 3 |
    And I close the current editor

    Given I open an editor "LJ_KOMP_Rück1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=GEBINDE;mge=-0.2;erbtext1=A-Rückbau1;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -0.2 |
      | restmge  | 0    |
      | mge      | -0.2 |
    And I close the current editor

    Given I open an editor "LJ_KOMP_Orig1" via ID from editor "LJ_KOMP_Rück1" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then field "vorgang^id" in row 0 has value equal to field "id" from editor "Rückmeldung3" in row 0
    Then fields have values
      | rueckmge | 0.2 |
      | restmge  | 1.8 |
      | mge      | 2   |
    And I close the current editor

# Bewertungen erhalten Nachfolger
    Given I switch the current editor to editor "Bewertung_1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor
    Given I open an editor "Bewertung_3" via ID from editor "Bewertung_1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor
    Given I switch the current editor to editor "Bewertung_2" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor
    Given I open an editor "Bewertung_4" via ID from editor "Bewertung_2" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung2"
    And I close the current editor

# Rückbauten Nachbuchen
    Given I open an editor "Rückmeldung4" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | gutmge      | mge         | bueinh      | !row                    |
      | 5           | !dontChange | !dontChange | artikel=='BG-EINHEITEN' |
      | !dontChange | 1           | kg          | artikel=='GEBINDE'      |
      | !dontChange | 1           | Paar        | artikel=='GEBINDEPFL'   |
      | !dontChange | 1           | !dontChange | artikel=='EINKAUF-1'    |
    And I save the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITEN |
      | klplatz    | F1           |
      | verdichten | nein         |
      | details    | nein         |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | geinheit | kopfzugvorg^id   |
      | 8     |        |          | (0,0,0)          |
      |       | 3      | Stück    | !Rückmeldung1^id |
      |       | 5      | Stück    | !Rückmeldung4^id |
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel    | GEBINDEPFL |
      | klplatz    | F1         |
      | verdichten | nein       |
      | nullmge    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A13"


  Scenario: A14 Rückbau1 auf letzten AS eines abgelegten FV bucht bucht LP ins Minus, Rückbau2 betrifft zwei Rückmeldungen, Gutmenge wurde in RM auf unterschiedliche Lagerplätze gebucht und Bestand umgebucht
    And I set the fake date to "05.03.1995"
# Bestandskorrektur B_Baugruppe auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "59KORR-X"
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F2" with document "59KORR-X"
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F3" with document "59KORR-X"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "15"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZUGANG69" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG69" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch       |
      | B_BAUGRUPPE | 15     | ja     | PLAETZERM59_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZERM59_001"
    And I set fields
      | sofort | ja |
    And I modify table
      | !row | gutmge | buplatz | erbtext1     |
      | 1    | 5      | F3      | Rückmeldung1 |
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZERM59_001"
    And I set fields
      | sofort | ja |
    And I modify table
      | !row | gutmge | buplatz | erbtext1     |
      | 1    | 5      | F2      | Rückmeldung2 |
    And I save the current editor

    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZERM59_001"
    And I set fields
      | sofort | ja |
    And I modify table
      | !row | gutmge | buplatz | erbtext1     |
      | 1    | 5      | F1      | Rückmeldung3 |
    And I save the current editor

# Bestand von F2 auf F1 umbuchen, wird von dort im nächsten Schritt ins Minus abgebucht
    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | beleg     | umbuch      |
      | beldat    | .           |
      | artikel   | B_BAUGRUPPE |
      | buart     | Umbuchung   |
      | mkvwunsch | ja          |
    And I modify table
      | !row | mge | platz | platz2 |
      | 1    | 5   | F2    | F1     |
    And I save the current editor

# Rückbau2 buplatz=F2, bucht F2 ins Minus
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row | gutmge | buplatz | erbtext1 |
      | 1    | -2     | F2      | Rückbau2 |
    And I save the current editor

# Rückbau1 buplatz=F1, Rückbau betrifft megenmäßig zwei Rückmeldungen
    Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row | gutmge | buplatz | erbtext1 |
      | 1    | -6     | F1      | Rückbau1 |
    And I save the current editor

# BESTAND und LJ prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 8 rows
    Then table has values
      | lemge | lplatz | gebmge |
      | 4     | F1     |        |
      |       | F1     | 1      |
      |       | F1     | 1      |
      |       | F1     | 2      |
      | -2    | F2     |        |
      |       | F2     | -2     |
      | 5     | F3     |        |
      |       | F3     | 5      |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | -10                  |
      | edatum   | +30                  |
      | beleg    | !Rückmeldung1^barmex |
      | richtung | rückwärts            |
      | artikel  | B_BAUGRUPPE          |
    And I press start
    Then table has values
      | art         | zmge | nplatz | rueckmge | restmge | !row |
      | B_BAUGRUPPE | -4   | F1     | -4       | 0       | 1    |
      | B_BAUGRUPPE | -2   | F1     | -2       | 0       | 2    |
      | B_BAUGRUPPE | -2   | F2     | -2       | 0       | 3    |
      | B_BAUGRUPPE | 5    | F1     | 4        | 1       | 4    |
      | B_BAUGRUPPE | 5    | F2     | 4        | 1       | 5    |
      | B_BAUGRUPPE | 5    | F3     | 0        | 5       | 6    |
    And I close the current editor

# Betriebsauftrag nachbuchen, Auftrag liefern und Bestand prüfen
    Given I open an editor "Rückmeldung4" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "8" in row 1
    And I set field "buplatz" to "F2" in row 1
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "15" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | lpsuch |
      | 1    | 4      | F1     |
      | +2   | 6      | F2     |
      | +3   | 5      | F3     |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Bestandskorrektur B_Baugruppe auf 0 fuer den naechsten Test
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "58KORR-X"
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F2" with document "58KORR-X"
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F3" with document "58KORR-X"

  Scenario: A15 Rückbau1 auf letzten AS eines abgelegten FV bucht bucht LP ins Minus, Rückbau2 betrifft zwei Rückmeldungen Gutmenge wurde in RM auf unterschiedliche Lagerplätze gebucht, FertigteilMZ Plätze, EntnahmeMZ Plätze
    And I set the fake date to "06.03.1995"
# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "15"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "15" on StorageLocation "F1" with document "ZUGANG58" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "15" on StorageLocation "F2" with document "ZUGANG58" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "15" on StorageLocation "F1" with document "ZUGANG58" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig |
      | B_BAUGRUPPE | 15     | ja     |
    And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row 1
    And I modify table
      | !row | zuomge | lpsuch |
      | +1   | 5      | F1     |
      | +2   | 5      | F2     |
      | +3   | 5      | F3     |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | !row | zuomge | lpsuch |
      | +1   | 15     | F1     |
      | +2   | 15     | F2     |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "PLAETZERM58_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZERM58_001"
    And I set fields
      | sofort | ja |
    And I modify table
      | !row | gutmge | erbtext1     |
      | 1    | 6      | Rückmeldung1 |
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZERM58_001"
    And I set fields
      | sofort | ja |
    And I modify table
      | !row | gutmge | erbtext1     |
      | 1    | 6      | Rückmeldung2 |
    And I save the current editor

    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZERM58_001"
    And I set fields
      | sofort | ja |
    And I modify table
      | !row | gutmge | erbtext1     |
      | 1    | 3      | Rückmeldung3 |
    And I save the current editor

# Gesamten Bestand von F2 auf F1 umbuchen
    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | beleg     | umbuch      |
      | beldat    | .           |
      | artikel   | B_BAUGRUPPE |
      | buart     | Umbuchung   |
      | mkvwunsch | ja          |
    And I modify table
      | !row | mge | platz | platz2 |
      | 1    | 5   | F2    | F1     |
    And I save the current editor

# Rückbau1 buplatz=F2, bucht F2 ins Minus
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row | gutmge | buplatz | erbtext1 |
      | 1    | -3     | F2      | Rückbau1 |
    And I save the current editor

# Rückbau1 buplatz=F1, betrifft mengenmäßig zwei Rückmeldungen und Platz mit negativem Bestand
    And I wait 1 time units to move the time forward
    Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row | gutmge | buplatz | erbtext1 |
      | 1    | -7     | F1      | Rückbau2 |
    And I save the current editor

# BESTAND und LJ prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | verdichten | nein        |
      | klplatz    |             |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 3
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 7 rows
    Then table has values
      | lemge | lplatz | gebmge |
      | 3     | F1     |        |
      |       | F1     | 3      |
      | -3    | F2     |        |
      |       | F2     | -3     |
      | 5     | F3     |        |
      |       | F3     | 2      |
      |       | F3     | 3      |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | -10                  |
      | edatum   | +30                  |
      | artikel  | B_BAUGRUPPE          |
      | beleg    | !Rückmeldung1^barmex |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | art         | zmge | nplatz | rueckmge | restmge | !row |
      | B_BAUGRUPPE | -1   | F1     | -1       | 0       | 1    |
      | B_BAUGRUPPE | -1   | F1     | -1       | 0       | 2    |
      | B_BAUGRUPPE | -5   | F1     | -5       | 0       | 3    |
      | B_BAUGRUPPE | -3   | F2     | -3       | 0       | 4    |
      | B_BAUGRUPPE | 3    | F3     | 0        | 3       | 5    |
      | B_BAUGRUPPE | 2    | F3     | 0        | 2       | 6    |
      | B_BAUGRUPPE | 4    | F2     | 4        | 0       | 7    |
      | B_BAUGRUPPE | 1    | F2     | 1        | 0       | 8    |
      | B_BAUGRUPPE | 5    | F1     | 5        | 0       | 9    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 8
    Then field "rueckorig^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 9
    Then field "rueckorig^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 7
    And I close the current editor

# Betriebsauftrag nachbuchen, Auftrag liefern und Bestand prüfen
    Given I open an editor "Rückmeldung4" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "10" in row 1
    And I set field "buplatz" to "F2" in row 1
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "15" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | lpsuch |
      | 1    | 3      | F1     |
      | +2   | 7      | F2     |
      | +3   | 5      | F3     |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: A16 Rückbau ohne Chargenangabe auf letzten AS eines abgelegten FV, zwei Rückmeldungen mit gleicher Charge
    And I set the fake date to "07.03.1995"
 # Bestandskorrektur B_Baugruppe auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "79KORR-X"

  # Chargen anlegen
    Given I create a Lot "AB_BG1" for Product "B_BAUGRUPPE"

# Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZUGANG79" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG79" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch      |
      | B_BAUGRUPPE | 10     | ja     | CHARGERM79_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang mit Chargenangabe
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM79_001"
    And I set fields
      | sofort  | ja         |
      | kcharge | !AB_BG1^id |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM79_001"
    And I set fields
      | sofort  | ja         |
      | kcharge | !AB_BG1^id |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung2" in row 1
    And I save the current editor

# Rückbau1 ohne Chargenangabe
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-6" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And saving the current editor throws the exception "2743"
    And I close the current editor

# Belege und Bestand prüfen
    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 5       | 5     | 5      | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 5       | 5     | 0      | 5      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^id  |
      | 10    |        | (0,0,0)    |
      |       | 5      | !AB_BG1^id |
      |       | 5      | !AB_BG1^id |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | -10                  |
      | edatum   | +30                  |
      | beleg    | !Rückmeldung1^barmex |
      | richtung | rückwärts            |
      | artikel  | B_BAUGRUPPE          |
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | ncharge^such |
      | B_BAUGRUPPE | 5    |      | 0        | 5       |              | AB_BG1       |
      | B_BAUGRUPPE | 5    |      | 0        | 5       |              | AB_BG1       |
    And I close the current editor

# Betriebsauftrag nachbuchen, Auftrag liefern und Bestand prüfen
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | kcharge | !AB_BG1 |
    And I set field "gutmge" to "6" in row 1
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "10" in row 1
    And I set field "charge" to "!AB_BG1^id" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    And I close the current editor


  Scenario: A17 Rückbau ohne Chargenangabe zu abgelegten FV, der zwei Rückmeldungen mit unterschiedlichen Chargen auf letzten AS betrifft
    And I set the fake date to "08.03.1995"
# Bestandskorrektur B_Baugruppe auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "76KORR-X"

  # Chargen anlegen
    Given I create a Lot "B_BG1-A17" for Product "B_BAUGRUPPE"
    Given I create a Lot "B_BG2-A17" for Product "B_BAUGRUPPE"

# Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZUGANG76" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG76" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch      |
      | B_BAUGRUPPE | 10     | ja     | CHARGERM76_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang mit Chargenangabe
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM76_001"
    And I set fields
      | sofort  | ja            |
      | kcharge | !B_BG1-A17^id |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM76_001"
    And I set fields
      | sofort  | ja            |
      | kcharge | !B_BG2-A17^id |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung2" in row 1
    And I save the current editor

# Rückbau1 ohne Chargenangabe
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-7" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And saving the current editor throws the exception "2743"
    And I close the current editor


# Belege und Bestand prüfen
    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 5       | 5     | 5      | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 5       | 5     | 0      | 5      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | -10                  |
      | edatum   | +30                  |
      | beleg    | !Rückmeldung1^barmex |
      | richtung | rückwärts            |
      | artikel  | B_BAUGRUPPE          |
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | ncharge^such |
      | B_BAUGRUPPE | 5    |      | 0        | 5       |              | B_BG2-A17    |
      | B_BAUGRUPPE | 5    |      | 0        | 5       |              | B_BG1-A17    |
    And I close the current editor

# Betriebsauftrag abschließen, Auftrag liefern und Bestand prüfen
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | kcharge | !B_BG1-A17    |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "10" in row 1
    And I set field "charge" to "!B_BG1-A17^id" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    And I close the current editor


  Scenario: A18 Rückbau mit Chargenangabe auf letzten AS eines abgelegten FV, zwei Rückmeldungen mit gleicher Charge
    And I set the fake date to "09.03.1995"
 # Bestandskorrektur B_Baugruppe auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "78KORR-X"

  # Chargen anlegen
    Given I create a Lot "AB_BG1-A18" for Product "B_BAUGRUPPE"

# Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZUGANG78" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG78" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch      |
      | B_BAUGRUPPE | 10     | ja     | CHARGERM78_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang mit Chargenangabe
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM78_001"
    And I set fields
      | sofort  | ja                |
      | kcharge | !AB_BG1-A18^id    |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM78_001"
    And I set fields
      | sofort  | ja                |
      | kcharge | !AB_BG1-A18^id    |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung2" in row 1
    And I save the current editor

# Rückbau1 mit Chargenangabe
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "kcharge" to "!AB_BG1-A18^id"
    And I set field "gutmge" to "-6" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# Belege und Bestand prüfen
    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -6       | 0       | -6    | 10     | 4      |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 5        | 0       | 5     | 5      | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 1        | 4       | 5     | 0      | 5      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | charge^id      |
      | 4     |        | (0,0,0)        |
      |       | 4      | !AB_BG1-A18^id |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | -10                  |
      | edatum   | +30                  |
      | beleg    | !Rückmeldung1^barmex |
      | richtung | rückwärts            |
      | artikel  | B_BAUGRUPPE          |
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | ncharge^such |
      | B_BAUGRUPPE | -5   |      | -5       | 0       |              | AB_BG1-A18   |
      | B_BAUGRUPPE | -1   |      | -1       | 0       |              | AB_BG1-A18   |
      | B_BAUGRUPPE | 5    |      | 5        | 0       |              | AB_BG1-A18   |
      | B_BAUGRUPPE | 5    |      | 1        | 4       |              | AB_BG1-A18   |
    And I close the current editor

# Betriebsauftrag nachbuchen, Auftrag liefern und Bestand prüfen
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | kcharge | !AB_BG1 |
    And I set field "gutmge" to "6" in row 1
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "10" in row 1
    And I set field "charge" to "!AB_BG1-A18^id" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: A19 Rückbau mit Chargenangabe zu abgelegtem FV, der zwei Rückmeldungen mit unterschiedlichen Chargen auf letzten AS betrifft
    And I set the fake date to "10.03.1995"
# Bestandskorrektur B_Baugruppe auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "77KORR-X"

  # Chargen anlegen
    Given I create a Lot "B_BG1-A19" for Product "B_BAUGRUPPE"
    Given I create a Lot "B_BG2-A19" for Product "B_BAUGRUPPE"

# Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZUGANG77" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG77" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch      |
      | B_BAUGRUPPE | 10     | ja     | CHARGERM77_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang mit Chargenangabe
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM77_001"
    And I set fields
      | sofort  | ja            |
      | kcharge | !B_BG1-A19^id |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM77_001"
    And I set fields
      | sofort  | ja            |
      | kcharge | !B_BG2-A19^id |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung2" in row 1
	#
    And I save the current editor

# Rückbau1 und Rückbau2 mit unterschiedlichen Chargenangabe
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | kcharge | !B_BG1-A19 |
    And I set field "gutmge" to "-3" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

    Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | kcharge | !B_BG2-A19 |
    And I set field "gutmge" to "-3" in row 1
    And I set field "erbtext1" to "Rückbau2" in row 1
    And I save the current editor

# Belege und Bestand prüfen
    And I switch the current editor to editor "Rückbau2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -3       | 0       | -3    | 7      | 4      |
    And I close the current editor

    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -3       | 0       | -3    | 10     | 7      |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 3        | 2       | 5     | 5      | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 3        | 2       | 5     | 0      | 5      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^id      | kopfzugvorg^id   |
      | 4     |        | (0,0,0)        | (0,0,0)          |
      |       | 2      | !B_BG1-A19^id  | !Rückmeldung1^id |
      |       | 2      | !B_BG2-A19^id  | !Rückmeldung2^id |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | -10                  |
      | edatum   | +30                  |
      | beleg    | !Rückmeldung1^barmex |
      | richtung | rückwärts            |
      | artikel  | B_BAUGRUPPE          |
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | ncharge^such |
      | B_BAUGRUPPE | -3   |      | -3       | 0       |              | B_BG2-A19    |
      | B_BAUGRUPPE | -3   |      | -3       | 0       |              | B_BG1-A19    |
      | B_BAUGRUPPE | 5    |      | 3        | 2       |              | B_BG2-A19    |
      | B_BAUGRUPPE | 5    |      | 3        | 2       |              | B_BG1-A19    |
    And I close the current editor

# Betriebsauftrag nachbuchen, Auftrag liefern und Bestand prüfen
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | kcharge | !B_BG1-A19 |
    And I set field "gutmge" to "6" in row 1
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "10" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | charge          |
      | 1    | 8      | !B_BG1-A19^id   |
      | +2   | 2      | !B_BG2-A19^id   |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: A20 Rückbau auf letzten AS eines abgelegten FV, Rückmeldung der Gutmenge in einen Behälter
    And I set the fake date to "11.03.1995"
# Bestandskorrektur B_Baugruppe auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "69KORR-X"

  # Behälter anlegen
    Given I create a Container "BEHAELTER1" for packaging material "BEHAELTER"

# Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZUGANG69" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG69" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch         |
      | B_BAUGRUPPE | 10     | ja     | BEHAELTERRM69_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang mit Behälterangabe
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHAELTERRM69_001"
    And I set fields
      | sofort    | ja             |
      | behaelter | !BEHAELTER1^id |
    And I set field "gutmge" to "10" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# Rückbau1 mit Behälterangabe
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "behaelter" to "!BEHAELTER1^id"
    And I set field "gutmge" to "-3" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# BESTAND und Behälter prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | B_BAUGRUPPE |
      | klplatz   | F1          |
      | behaelter | ja          |
      | details   | nein        |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | tbehaelter^id  |
      | 7      | !BEHAELTER1^id |
    And I close the current editor

    Given I switch the current editor to editor "BEHAELTER1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel     | mge |
      | B_BAUGRUPPE | 7   |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | -10                  |
      | edatum   | +30                  |
      | beleg    | !Rückmeldung1^barmex |
      | richtung | rückwärts            |
      | artikel  | B_BAUGRUPPE          |
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | behaelter^such |
      | B_BAUGRUPPE | -3   |      | -3       | 0       | BEHAELTER1     |
      | B_BAUGRUPPE | 10   |      | 3        | 7       | BEHAELTER1     |
    And I close the current editor

# Betriebsauftrag nachbuchen, Auftrag liefern und Bestand prüfen
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | behaelter | !BEHAELTER1 |
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "10" in row 1
    And I set field "behaelter" to "!BEHAELTER1^id" in row 1
    And I save the current editor

    And I switch the current editor to editor "BEHAELTER1" with command "VIEW"
    Then field "behstatusaz" has value "Geliefert"
    Then field "behleer" has value "nein"
    Then the table has 0 rows
    And I close the current editor


  Scenario: A21 Rückbau auf letzten AS eines abgelegten FV, die Gutmenge in anderer Einheit gebucht hat
    And I set the fake date to "12.03.1995"
  # Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "BG-EINHEITENPFL" on StorageLocation "F1" with document "KORR-81"

  # Behälter und Auftrag anlegen und Bedarfe einkaufen, FV anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITENPFL" and quantity "10"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 10  |
      | GEBINDEPFL | 10  |
      | GEBINDE    | 100 |
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel         | mge | mfreig | bisuch       |
      | BG-EINHEITENPFL | 20  | ja     | BGEINHEIT81_ |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  # Rückmeldung1 in Stück und Rückmeldung2 in Paar
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT81_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "10" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT81_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I set field "bueinh" to "Paar" in row 1
    And I save the current editor

  # Rückbau1 in Stück und Rückbau2 in Paar, Rückbauten betreffen mengenmäßig nur eine Rückmeldung
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor

    Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-2" in row 1
    And I set field "bueinh" to "Paar" in row 1
    And I save the current editor

  # Bestand, LJ und Belege prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | details    | nein            |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id   |
      | 14    | Stück    |        |          | (0,0,0)          |
      |       |          | 8      | Stück    | !Rückmeldung1^id |
      |       |          | 3      | Paar     | !Rückmeldung2^id |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rückmeldung1^barmex |
      | artikel  | BG-EINHEITENPFL      |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | zmge | mei   | rueckmge | restmge | !row |
      | -2   | Paar  | -4       | 0       | 1    |
      | -2   | Stück | -2       | 0       | 2    |
      | 5    | Paar  | 4        | 6       | 3    |
      | 10   | Stück | 2        | 8       | 4    |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau2" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | gutmge | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -2    | Paar   | -4     | -4       | 0       | 14     | 18     |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | gutmge | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -2    | Stück  | -2     | -2       | 0       | 18     | 20     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | gutmge | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | 5     | Paar   | 10     | 4        | 6       | 20     | 10     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | gutmge | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | 10    | Stück  | 10     | 2        | 8       | 10     | 0      |
    And I close the current editor

    # FV abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "6" in row 1
    And I save the current editor

    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "20" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | zuomge | einh  | !row |
      | 14     | Stück | 1    |
      | 3      | Paar  | +2   |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | nullmge    | nein            |
      | details    | nein            |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: A22 Rückbau auf letzten AS eines abgelegten FV, FertigteilMZ mit Einheiten
    And I set the fake date to "13.03.1995"
	  # Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "BG-EINHEITENPFL" on StorageLocation "F1" with document "KORR-83"

  # Behälter und Auftrag anlegen und Bedarfe einkaufen, FV anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITENPFL" and quantity "10"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 10  |
      | GEBINDEPFL | 10  |
      | GEBINDE    | 100 |
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel         | mge | mfreig |
      | BG-EINHEITENPFL | 20  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row 1
    And I modify table
      | !row | zuomge | einh  |
      | +1   | 10     | Stück |
      | +2   | 5      | Paar  |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BGEINHEIT83_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  # Rückmeldungen in LE
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT83_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "10" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT83_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

  # Rückbau1 in Stück und Rückbau2 in Paar, Rückbauten betreffen mengenmäßig nur eine Rückmeldung
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor

    Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-2" in row 1
    And I set field "bueinh" to "Paar" in row 1
    And I save the current editor

  # Bestand, LJ und Belege prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | details    | nein            |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id   |
      | 14    | Stück    |        |          | (0,0,0)          |
      |       |          | 8      | Stück    | !Rückmeldung1^id |
      |       |          | 3      | Paar     | !Rückmeldung2^id |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rückmeldung1^barmex |
      | artikel  | BG-EINHEITENPFL      |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | zmge | mei   | rueckmge | restmge | !row |
      | -2   | Paar  | -4       | 0       | 1    |
      | -2   | Stück | -2       | 0       | 2    |
      | 5    | Paar  | 4        | 6       | 3    |
      | 10   | Stück | 2        | 8       | 4    |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau2" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | gutmge | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -2    | Paar   | -4     | -4       | 0       | 14     | 18     |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | gutmge | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -2    | Stück  | -2     | -2       | 0       | 18     | 20     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | gutmge | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | 10    | Stück  | 10     | 4        | 6       | 20     | 10     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | gutmge | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | 10    | Stück  | 10     | 2        | 8       | 10     | 0      |
    And I close the current editor

    # FV abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "6" in row 1
    And I save the current editor

    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "20" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | zuomge | einh  | !row |
      | 14     | Stück | 1    |
      | 3      | Paar  | +2   |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | nullmge    | nein            |
      | details    | nein            |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: A23 Rückbau auf letzten AS eines abgelegten FV, der zwei Rückmeldungen auf letzten AS betrifft, FerzigteilMZ mit Einheiten
    And I set the fake date to "14.03.1995"
  # Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "BG-EINHEITENPFL" on StorageLocation "F1" with document "KORR-84"

  # Behälter und Auftrag anlegen und Bedarfe einkaufen, FV anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITENPFL" and quantity "15"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 10  |
      | GEBINDEPFL | 10  |
      | GEBINDE    | 100 |
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel         | mge | mfreig |
      | BG-EINHEITENPFL | 30  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row 1
    And I modify table
      | !row | zuomge | einh  |
      | +1   | 5      | Paar  |
      | +2   | 10     | Stück |
      | +3   | 5      | Paar  |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BGEINHEIT84_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  # Zwei Rückmeldungen in LE
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT84_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "15" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT84_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "15" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

  # Rückbau1 betrifft mengenmäßig immer beide Rückmeldungen
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-10" in row 1
    And I save the current editor

  # Rückbau1 betrifft mengenmäßig immer beide Rückmeldungen
    Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-9" in row 1
    And I set field "bueinh" to "Paar" in row 1
    And I save the current editor

  # Bestand, LJ und Belege prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | details    | nein            |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | leinheit | gebmge | geinheit | kopfzugvorg^id   |
      | 2     | Stück    |        |          | (0,0,0)          |
      |       |          | 1      | Paar     | !Rückmeldung1^id |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rückmeldung1^barmex |
      | artikel  | BG-EINHEITENPFL      |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | zmge | mei   | rueckmge | restmge | !row |
      | -5   | Paar  | -10      | 0       | 1    |
      | -4   | Paar  | -8       | 0       | 2    |
      | -5   | Stück | -5       | 0       | 3    |
      | -5   | Stück | -5       | 0       | 4    |
      | 5    | Paar  | 10       | 0       | 5    |
      | 5    | Stück | 5        | 0       | 6    |
      | 5    | Stück | 5        | 0       | 7    |
      | 5    | Paar  | 8        | 2       | 8    |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -10   | Stück  | -10      | 0       | 20     | 30     |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau2" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | -9    | Paar   | -18      | 0       | 2      | 20     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | 15    | Stück  | 15       | 0       | 30     | 15     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel         | bumge | bueinh | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITENPFL | 15    | Stück  | 13       | 2       | 15     | 0      |
    And I close the current editor

    # FV abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "14" in row 1
    And I set field "bueinh" to "Paar" in row 1
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-R83"

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | klplatz    | F1              |
      | verdichten | nein            |
      | nullmge    | nein            |
      | details    | nein            |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: A24 Rückbau ohne Chargenangabe auf letzten AS eines abgelegten FV, bisher zwei Rückmeldungen mit gleicher Charge gebucht
    And I set the fake date to "15.03.1995"
 # Bestandskorrektur B_Baugruppe auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "79KORR-X"

  # Chargen anlegen
    Given I create a Lot "AB_BG1-A24" for Product "B_BAUGRUPPE"

# Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZUGANG79" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG79" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch      |
      | B_BAUGRUPPE | 10     | ja     | CHARGERM79_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang mit Chargenangabe
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM79_001"
    And I set fields
      | sofort  | ja                |
      | kcharge | !AB_BG1-A24^id    |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM79_001"
    And I set fields
      | sofort  | ja                |
      | kcharge | !AB_BG1-A24^id    |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung2" in row 1
    And I save the current editor

# Rückbau1 ohne Chargenangabe
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-6" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And saving the current editor throws the exception "2743"
    And I close the current editor

# Belege und Bestand prüfen
    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 5       | 5     | 5      | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 5       | 5     | 0      | 5      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^id      |
      | 10    |        | (0,0,0)        |
      |       | 5      | !AB_BG1-A24^id |
      |       | 5      | !AB_BG1-A24^id |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | -10                  |
      | edatum   | +30                  |
      | beleg    | !Rückmeldung1^barmex |
      | richtung | rückwärts            |
      | artikel  | B_BAUGRUPPE          |
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | ncharge^such |
      | B_BAUGRUPPE | 5    |      | 0        | 5       |              | AB_BG1-A24   |
      | B_BAUGRUPPE | 5    |      | 0        | 5       |              | AB_BG1-A24   |
    And I close the current editor

# Betriebsauftrag nachbuchen, Auftrag liefern und Bestand prüfen
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | kcharge | !AB_BG1-A24   |
    And I set field "gutmge" to "6" in row 1
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "10" in row 1
    And I set field "charge" to "!AB_BG1-A24^id" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    And I close the current editor


  Scenario: A25 Rückbau mit Chargenangabe auf letzten AS eines abgelegten FV, bisher zwei Rückmeldungen mit gleicher Charge gebucht
    And I set the fake date to "16.03.1995"
 # Bestandskorrektur B_Baugruppe auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "78KORR-X"

  # Chargen anlegen
    Given I create a Lot "AB_BG1-A25" for Product "B_BAUGRUPPE"

# Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZUGANG78" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG78" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch      |
      | B_BAUGRUPPE | 10     | ja     | CHARGERM78_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang mit Chargenangabe
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM78_001"
    And I set fields
      | sofort  | ja                |
      | kcharge | !AB_BG1-A25^id    |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM78_001"
    And I set fields
      | sofort  | ja                |
      | kcharge | !AB_BG1-A25^id    |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung2" in row 1
    And I save the current editor

# Rückbau1 mit Chargenangabe
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "kcharge" to "!AB_BG1-A25^id"
    And I set field "gutmge" to "-6" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# Belege und Bestand prüfen
    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -6       | 0       | -6    | 10     | 4      |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 5        | 0       | 5     | 5      | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 1        | 4       | 5     | 0      | 5      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | charge^id      |
      | 4     |        | (0,0,0)        |
      |       | 4      | !AB_BG1-A25^id |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | -10                  |
      | edatum   | +30                  |
      | beleg    | !Rückmeldung1^barmex |
      | richtung | rückwärts            |
      | artikel  | B_BAUGRUPPE          |
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | ncharge^such |
      | B_BAUGRUPPE | -5   |      | -5       | 0       |              | AB_BG1-A25   |
      | B_BAUGRUPPE | -1   |      | -1       | 0       |              | AB_BG1-A25   |
      | B_BAUGRUPPE | 5    |      | 5        | 0       |              | AB_BG1-A25   |
      | B_BAUGRUPPE | 5    |      | 1        | 4       |              | AB_BG1-A25   |
    And I close the current editor

# Betriebsauftrag nachbuchen, Auftrag liefern und Bestand prüfen
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | kcharge | !AB_BG1-A25   |
    And I set field "gutmge" to "6" in row 1
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "10" in row 1
    And I set field "charge" to "!AB_BG1-A25^id" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: A26 Rückbau mit Chargenangabe zu abgelegtem FV betrifft zwei Rückmeldungen, bisher zwei Rückmeldungen mit unterschiedlichen Chargen auf letzten AS gebucht
    And I set the fake date to "17.03.1995"
# Bestandskorrektur B_Baugruppe auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "77KORR-X"

  # Chargen anlegen
    Given I create a Lot "B_BG1-A26" for Product "B_BAUGRUPPE"
    Given I create a Lot "B_BG2-A26" for Product "B_BAUGRUPPE"

# Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZUGANG77" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG77" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch      |
      | B_BAUGRUPPE | 10     | ja     | CHARGERM77_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang mit Chargenangabe
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM77_001"
    And I set fields
      | sofort  | ja            |
      | kcharge | !B_BG1-A26^id |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM77_001"
    And I set fields
      | sofort  | ja            |
      | kcharge | !B_BG2-A26^id |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung2" in row 1
    And I save the current editor

# Rückbau1 und Rückbau2 mit unterschiedlichen Chargenangabe
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | kcharge | !B_BG1-A26    |
    And I set field "gutmge" to "-3" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

    Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | kcharge | !B_BG2-A26    |
    And I set field "gutmge" to "-3" in row 1
    And I set field "erbtext1" to "Rückbau2" in row 1
    And I save the current editor

# Belege und Bestand prüfen
    And I switch the current editor to editor "Rückbau2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -3       | 0       | -3    | 7      | 4      |
    And I close the current editor

    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -3       | 0       | -3    | 10     | 7      |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 3        | 2       | 5     | 5      | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 3        | 2       | 5     | 0      | 5      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^id      | kopfzugvorg^id   |
      | 4     |        | (0,0,0)        | (0,0,0)          |
      |       | 2      | !B_BG1-A26^id  | !Rückmeldung1^id |
      |       | 2      | !B_BG2-A26^id  | !Rückmeldung2^id |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | -10                  |
      | edatum   | +30                  |
      | beleg    | !Rückmeldung1^barmex |
      | richtung | rückwärts            |
      | artikel  | B_BAUGRUPPE          |
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | ncharge^such |
      | B_BAUGRUPPE | -3   |      | -3       | 0       |              | B_BG2-A26    |
      | B_BAUGRUPPE | -3   |      | -3       | 0       |              | B_BG1-A26    |
      | B_BAUGRUPPE | 5    |      | 3        | 2       |              | B_BG2-A26    |
      | B_BAUGRUPPE | 5    |      | 3        | 2       |              | B_BG1-A26    |
    And I close the current editor

# Betriebsauftrag nachbuchen, Auftrag liefern und Bestand prüfen
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | kcharge | !B_BG1-A26    |
    And I set field "gutmge" to "6" in row 1
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "10" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | charge          |
      | 1    | 8      | !B_BG1-A26^id   |
      | +2   | 2      | !B_BG2-A26^id   |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: A27 Rückbau ohne Chargenangabe zu abgelegten FV betrifft zwei Rückmeldungen, bisher zwei Rückmeldungen mit unterschiedlichen Chargen auf letzten AS gebucht
    And I set the fake date to "18.03.1995"
# Bestandskorrektur B_Baugruppe auf 0
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "76KORR-X"

  # Chargen anlegen
    Given I create a Lot "B_BG1-A27" for Product "B_BAUGRUPPE"
    Given I create a Lot "B_BG2-A27" for Product "B_BAUGRUPPE"

# Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZUGANG76" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG76" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch      |
      | B_BAUGRUPPE | 10     | ja     | CHARGERM76_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang mit Chargenangabe
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM76_001"
    And I set fields
      | sofort  | ja            |
      | kcharge | !B_BG1-A27^id |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERM76_001"
    And I set fields
      | sofort  | ja            |
      | kcharge | !B_BG2-A27^id |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung2" in row 1
    And I save the current editor

# Rückbau1 ohne Chargenangabe
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-7" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And saving the current editor throws the exception "2743"
    And I close the current editor

# Belege und Bestand prüfen
    And I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 5       | 5     | 5      | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 5       | 5     | 0      | 5      |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^id      | kopfzugvorg^id   |
      | 10    |        | (0,0,0)        | (0,0,0)          |
      |       | 5      | !B_BG1-A27^id  | !Rückmeldung1^id |
      |       | 5      | !B_BG2-A27^id  | !Rückmeldung2^id |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | -10                  |
      | edatum   | +30                  |
      | beleg    | !Rückmeldung1^barmex |
      | richtung | rückwärts            |
      | artikel  | B_BAUGRUPPE          |
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | ncharge^such |
      | B_BAUGRUPPE | 5    |      | 0        | 5       |              | B_BG2-A27    |
      | B_BAUGRUPPE | 5    |      | 0        | 5       |              | B_BG1-A27    |
    And I close the current editor

# Betriebsauftrag abschließen, Auftrag liefern und Bestand prüfen
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | kcharge | !B_BG1-A27    |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
      | vom | .  |
    And I set field "mge" to "10" in row 1
    And I set field "charge" to "!B_BG1-A27^id" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    And I close the current editor



#	Scenario: A28 Rückbau auf letzten AS eines abgelegten FV, bisher Rückmeldung der Gutmenge in einen Behälter
# And I set the fake date to "19.03.1995"
## Bestandskorrektur B_Baugruppe auf 0
#		Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "69KORR-X"
#
#  # Behälter anlegen
#		Given I create a Container "BEHAELTER1" for packaging material "BEHAELTER"
#
## Auftrag anlegen und Bedarfe zubuchen
#		Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"
#
#		Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZUGANG69" and price "0" 
#		Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG69" and price "0"
#
## Fertigungsvorschlag anlegen und freigeben
#		Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
#		And I append rows
#			| artikel		| netmge	| mfreig	| bisuch          |
#			| B_BAUGRUPPE	| 10		| ja		| BEHAELTERRM69_  |
#		And I press button "freig" to open a subeditor for "BA_freigeben"
#		And I close the current editor
#		And I switch the current editor to editor "fvor"
#		And I save the current editor
#
## Rückmeldungen auf ersten Arbeitsgang mit Behälterangabe
#		Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHAELTERRM69_001"
#		And I set fields
#			| sofort	  | ja	            |
#			| behaelter   | !BEHAELTER1^id  |
#		And I set field "gutmge" to "10" in row 1
#		And I set field "erbtext1" to "Rückmeldung1" in row 1
#		And I save the current editor
#
## Rückbau1 mit Behälterangabe
#		Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
#		And I set field "behaelter" to "!BEHAELTER1^id"
#		And I set field "gutmge" to "-3" in row 1
#		And I set field "erbtext1" to "Rückbau1" in row 1
#		And I save the current editor
#
## BESTAND und Behälter prüfen
#		Given I open the infosystem "BESTAND"
#		And I set fields
#			| artikel   | B_BAUGRUPPE |
#			| klplatz   | F1          |
#			| behaelter | ja          |
#           | details   | nein        |
#		And I press start
#		Then the table has 1 rows
#		Then table has values
#			| gebmge | tbehaelter^id       |
#			| 7      | !BEHAELTER1^id      |
#		And I close the current editor
#
#		Given I switch the current editor to editor "BEHAELTER1" with command "VIEW"
#		Then the table has 1 rows
#		Then table has values
#			| artikel     | mge   |
#			| B_BAUGRUPPE | 7     |
#		And I close the current editor
#
## Lagerjournal prüfen
#		Given I open the infosystem "LJ"
#		And I set fields
#			| adatum    | -10                   |
#			| edatum    | +30                   |
#			| beleg     | !Rückmeldung1^barmex  |
#			| richtung  | rückwärts             |
#			| artikel   | B_BAUGRUPPE           |
#		And I press start
#		Then table has values
#			| art			| zmge	| amge	| rueckmge	| restmge	| behaelter^such  |
#			| B_BAUGRUPPE	| -3	|		| -3		| 0			| BEHAELTER1      |
#			| B_BAUGRUPPE	| 10	|		| 3 		| 7			| BEHAELTER1      |
#		And I close the current editor
#
## Betriebsauftrag nachbuchen, Auftrag liefern und Bestand prüfen
#		Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
#		And I set fields
#			| behaelter   | !BEHAELTER1  |
#		And I set field "gutmge" to "3" in row 1
#		And I save the current editor
#
#		And I switch the current editor to editor "auftrag" with command "DELIVERY"
#		And I set fields
#			| ueb	| ja	|
#			| vom	| .		|
#		And I set field "mge" to "10" in row 1
#		And I set field "behaelter" to "!BEHAELTER1^id" in row 1
#		And I save the current editor
#
#		And I switch the current editor to editor "BEHAELTER1" with command "VIEW"
#		Then field "behstatusaz" has value "Geliefert"
#		Then field "behleer" has value "nein"
#		Then the table has 0 rows
#		And I close the current editor
#
#
#
#	Scenario: A29 Rückbau auf letzten AS zu abgelegtem FV, bisher Rückmeldung mit anderer Einheit gebucht
# And I set the fake date to "20.03.1995"      
# Bestandskorrektur auf 0
#		Given I set StorageQuantity to zero for Product "BG-EINHEITENPFL" on StorageLocation "F1" with document "KORR-81"
#
#  # Behälter und Auftrag anlegen und Bedarfe einkaufen, FV anlegen und freigeben
#		Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITENPFL" and quantity "10"
#
#		Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
#		And I set fields
#			| lief	    | KETTLER	|
#			| vom		| .			|
#			| ebeleg	| RückbauP1	|
#			| ueb		| ja		|
#			| fakt	    | ja		|
#		And I append rows
#			| artikel 	    | mge	|
#			| EINKAUF-1	    | 10	|
#			| GEBINDEPFL	| 10	|
#			| GEBINDE 	    | 10	|
#		Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
#		Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
#		Given I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
#		And I respond with answer "ja" to the dialog with id "4841"
#		And I save the current editor
#
#		Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
#		And I append rows
#			| artikel	        | mge	| mfreig	| bisuch         |
#			| BG-EINHEITENPFL	| 20	| ja		| BGEINHEIT81_   |
#		And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
#		And I press button "freig" to open a subeditor for "BA_freigeben"
#		And I close the current editor
#		And I switch the current editor to editor "fvor"
#		And I save the current editor
#
#  # Rückmeldung1 in Stück und Rückmeldung2 in Paar
#		Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT81_001"
#		And I set field "sofort" to "ja"
#		And I set field "gutmge" to "10" in row 1
#		And I save the current editor
#		And I wait 1 time units to move the time forward
#
#		Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT81_001"
#		And I set field "sofort" to "ja"
#		And I set field "gutmge" to "5" in row 1
#		And I set field "bueinh" to "Paar" in row 1
#		And I save the current editor
#
#  # Rückbau1 in Stück und Rückbau2 in Paar, Rückbauten betreffen mengenmäßig nur eine Rückmeldung
#		Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
#		And I set field "gutmge" to "-2" in row 1
#		And I save the current editor
#
#  Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
#  And I set field "gutmge" to "-2" in row 1
#  And I set field "bueinh" to "Paar" in row 1
#  And I save the current editor
#
#  # Bestand, LJ und Belege prüfen
#  Given I open the infosystem "BESTAND"
#  And I set fields
#    | artikel | BG-EINHEITENPFL |
#    | klplatz | F1              |
#    | verdichten  | nein              |
#    | details     | nein              |
#  And I press start
#  And I press button "taufzu" in row 1
#  Then table has values
#    | lemge | leinheit  | gebmge  | geinheit    | kopfzugvorg^id        |
#    | 14    | 		     | 		   | 		     | (0,0,0)			 |
#    |       | Stück     | 8       | Stück       | !Rückmeldung1^id  |
#    |       | Stück     | 3       | Paar        | !Rückmeldung2^id  |
#  And I close the current editor
#
#  Given I open the infosystem "LJ"
#  And I set fields
#    | beleg   | !Rückmeldung1^barmex  |
#    | artikel | BG-EINHEITENPFL       |
#    | richtung| rückwärts             |
#  And I press start
#  Then table has values
#    | zmge  | mei   | rueckmge  | restmge | lei   | !row  |
#    | -2    | Paar  | -4        | 0       | Stück | 1     |
#    | -2    | Stück | -2        | 0       | Stück | 2     |
#    | 5     | Paar  | 4         | 6       | Stück | 3     |
#    | 10    | Stück | 2         | 8       | Stück | 4     |
#  And I close the current editor
#
#  Given I switch the current editor to editor "Rückbau2" with command "VIEW"
#  Then table has values
#    | artikel         | bumge | bueinh  | rueckmge  | restmge | limgen  | limgev  |
#    | BG-EINHEITENPFL | -2    | Paar    | -4        | 0       | 14      | 18      |
#  And I close the current editor
#
#  Given I switch the current editor to editor "Rückbau1" with command "VIEW"
#  Then table has values
#    | artikel         | bumge | bueinh  | rueckmge  | restmge | limgen  | limgev  |
#    | BG-EINHEITENPFL | -2    | Stück   | -2        | 0       | 18      | 20      |
#  And I close the current editor
#
#  Given I switch the current editor to editor "Rückmeldung2" with command "VIEW"
#  Then table has values
#    | artikel         | bumge | bueinh  | rueckmge  | restmge | limgen  | limgev  |
#    | BG-EINHEITENPFL | 5     | Paar    | 4         | 6       | 20      | 10      |
#  And I close the current editor
#
#  Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
#  Then table has values
#    | artikel         | bumge | bueinh  | rueckmge  | restmge | limgen  | limgev  |
#    | BG-EINHEITENPFL | 10    | Stück   | 2         | 8       | 10      | 0       |
#  And I close the current editor
#
#    # FV abschließen und Auftrag liefern
#  Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
#  And I set field "gutmge" to "6" in row 1
#  And I save the current editor
#
#  Given I switch the current editor to editor "auftrag" with command "DELIVERY"
#  And I set fields
#    | vom | .   |
#    | ueb | ja  |
#  And I set field "mge" to "20" in row 1
#  And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
#  And I modify table
#    | zuomge  | einh   | !row |
#    | 14      | Stück  | 1    |
#    | 3       | Paar   | +2   |
#  And I save the current editor
#  And I switch the current editor to editor "auftrag"
#  And I save the current editor
#
#  Given I open the infosystem "BESTAND"
#  And I set fields
#    | artikel | BG-EINHEITENPFL |
#    | klplatz | F1              |
#    | verdichten | nein         |
#    | nullmge | nein         |
#    | details | nein         |
#  And I press start
#  Then the table has 0 rows
#  And I close the current editor
#
#
#
#Scenario: A30 Rückbau auf letzten AS eines abgelegten FV, bisher Rückmeldung gebucht, FertigteilMZ mit Einheiten vor Freigabe FV angelegt
# And I set the fake date to "21.03.1995"  
# Bestandskorrektur auf 0
#  Given I set StorageQuantity to zero for Product "BG-EINHEITENPFL" on StorageLocation "F1" with document "KORR-83"
#
#  # Behälter und Auftrag anlegen und Bedarfe einkaufen, FV anlegen und freigeben
#		Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITENPFL" and quantity "10"
#
#		Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
#		And I set fields
#			| lief	    | KETTLER	|
#			| vom		| .			|
#			| ebeleg	| RückbauP1	|
#			| ueb		| ja		|
#			| fakt	    | ja		|
#		And I append rows
#			| artikel 	    | mge	|
#			| EINKAUF-1	    | 10	|
#			| GEBINDEPFL	| 10	|
#			| GEBINDE 	    | 10	|
#		Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
#		Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
#		Given I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
#		And I respond with answer "ja" to the dialog with id "4841"
#		And I save the current editor
#
#		Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
#		And I append rows
#			| artikel	        | mge	| mfreig	|
#			| BG-EINHEITENPFL	| 20	| ja		|
#		And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
#		And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row 1
#		And I modify table
#			| !row  | zuomge   | einh   |
#			| +1    | 10       | Stück  |
#			| +2    | 5        | Paar   |
#		And I save the current editor
#		And I switch the current editor to editor "fvor"
#		And I set field "bisuch" to "BGEINHEIT83_" in row 1
#		And I press button "freig" to open a subeditor for "BA_freigeben"
#		And I close the current editor
#		And I switch the current editor to editor "fvor"
#		And I save the current editor
#
#  # Rückmeldungen in LE
#		Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT83_001"
#		And I set field "sofort" to "ja"
#		And I set field "gutmge" to "10" in row 1
#		And I save the current editor
#		And I wait 1 time units to move the time forward
#
#		Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT83_001"
#		And I set field "sofort" to "ja"
#		And I set field "gutmge" to "10" in row 1
#		And I save the current editor
#
#  # Rückbau1 in Stück und Rückbau2 in Paar, Rückbauten betreffen mengenmäßig nur eine Rückmeldung
#		Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
#		And I set field "gutmge" to "-2" in row 1
#		And I save the current editor
#
#    Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
#    And I set field "gutmge" to "-2" in row 1
#    And I set field "bueinh" to "Paar" in row 1
#    And I save the current editor
#
#  # Bestand, LJ und Belege prüfen
#    Given I open the infosystem "BESTAND"
#    And I set fields
#      | artikel | BG-EINHEITENPFL |
#      | klplatz | F1              |
#      | verdichten | nein             |
#      | details    | nein             |
#    And I press start
#    And I press button "taufzu" in row 1
#    Then table has values
#      | lemge | leinheit  | gebmge  | geinheit    | kopfzugvorg^id        |
#      | 14    | Stück     |        |       | (0,0,0)  |
#      |     | Stück     | 8       | Stück       | !Rückmeldung1^id  |
#      |     | Stück     | 3       | Paar        | !Rückmeldung2^id  |
#    And I close the current editor
#
#    Given I open the infosystem "LJ"
#    And I set fields
#      | beleg   | !Rückmeldung1^barmex  |
#      | artikel | BG-EINHEITENPFL       |
#      | richtung| rückwärts             |
#    And I press start
#    Then table has values
#      | zmge  | mei   | rueckmge  | restmge | !row  |
#      | -2    | Paar  | -4        | 0       | 1     |
#      | -2    | Stück | -2        | 0       | 2     |
#      | 5     | Paar  | 4         | 6       | 3     |
#      | 10    | Stück | 2         | 8       | 4     |
#    And I close the current editor
#
#    Given I switch the current editor to editor "Rückbau2" with command "VIEW"
#    Then table has values
#      | artikel         | bumge | bueinh  | rueckmge  | restmge | limgen  | limgev  |
#      | BG-EINHEITENPFL | -2    | Paar    | -4        | 0       | 14      | 18      |
#    And I close the current editor
#
#    Given I switch the current editor to editor "Rückbau1" with command "VIEW"
#    Then table has values
#      | artikel         | bumge | bueinh  | rueckmge  | restmge | limgen  | limgev  |
#      | BG-EINHEITENPFL | -2    | Stück   | -2        | 0       | 18      | 20      |
#    And I close the current editor
#
#    Given I switch the current editor to editor "Rückmeldung2" with command "VIEW"
#    Then table has values
#      | artikel         | bumge | bueinh  | rueckmge  | restmge | limgen  | limgev  |
#      | BG-EINHEITENPFL | 10    | Stück   | 4         | 6       | 20      | 10      |
#    And I close the current editor
#
#    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
#    Then table has values
#      | artikel         | bumge | bueinh  | rueckmge  | restmge | limgen  | limgev  |
#      | BG-EINHEITENPFL | 10    | Stück   | 2         | 8      | 10      | 0       |
#    And I close the current editor
#
#    # FV abschließen und Auftrag liefern
#    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
#    And I set field "gutmge" to "6" in row 1
#    And I save the current editor
#
#    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
#    And I set fields
#      | vom | .   |
#      | ueb | ja  |
#    And I set field "mge" to "20" in row 1
#    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
#    And I modify table
#      | zuomge  | einh   | !row |
#      | 14      | Stück  | 1    |
#      | 3       | Paar   | +2   |
#    And I save the current editor
#    And I switch the current editor to editor "auftrag"
#    And I save the current editor
#
#    Given I open the infosystem "BESTAND"
#    And I set fields
#      | artikel | BG-EINHEITENPFL |
#      | klplatz | F1              |
#      | verdichten  | nein            |
#      | nullmge  | nein            |
#      | details  | nein            |
#    And I press start
#    Then the table has 0 rows
#    And I close the current editor
#
#
#
#Scenario: A31 Rückbau auf letzten AS eines abgelegten FV betrifft zwei Rückmeldungen, biser zwei Rückmeldungen gebucht, FerzigteilMZ mit Einheiten vor Freigabe FV angelegt
# And I set the fake date to "22.03.1995" 
#   # Bestandskorrektur auf 0
#	Given I set StorageQuantity to zero for Product "BG-EINHEITENPFL" on StorageLocation "F1" with document "KORR-84"
#
#  # Behälter und Auftrag anlegen und Bedarfe einkaufen, FV anlegen und freigeben
#	Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITENPFL" and quantity "15"
#
#	Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
#	And I set fields
#		| lief	    | KETTLER	|
#		| vom		| .			|
#		| ebeleg	| RückbauP1	|
#		| ueb		| ja		|
#		| fakt	    | ja		|
#	And I append rows
#		| artikel 	    | mge	|
#		| EINKAUF-1	    | 10	|
#		| GEBINDEPFL	| 10	|
#		| GEBINDE 	    | 10	|
#	Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
#	Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
#	Given I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
#	And I respond with answer "ja" to the dialog with id "4841"
#	And I save the current editor
#
#	Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
#	And I append rows
#		| artikel	        | mge	| mfreig	|
#		| BG-EINHEITENPFL	| 30	| ja		|
#	And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
#	And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row 1
#	And I modify table
#		| !row  | zuomge    | einh    |
#		| +1    | 5         | Paar    |
#		| +2    | 10        | Stück   |
#		| +3    | 5         | Paar    |
#	And I save the current editor
#	And I switch the current editor to editor "fvor"
#	And I set field "bisuch" to "BGEINHEIT84_" in row 1
#	And I press button "freig" to open a subeditor for "BA_freigeben"
#	And I close the current editor
#	And I switch the current editor to editor "fvor"
#	And I save the current editor
#
#  # Zwei Rückmeldungen in LE
#	Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT84_001"
#	And I set field "sofort" to "ja"
#	And I set field "gutmge" to "15" in row 1
#	And I save the current editor
#	And I wait 1 time units to move the time forward
#
#	Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGEINHEIT84_001"
#	And I set field "sofort" to "ja"
#	And I set field "gutmge" to "15" in row 1
#	And I save the current editor
#	And I wait 1 time units to move the time forward
#
#  # Rückbau1 betrifft mengenmäßig immer beide Rückmeldungen
#	Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
#	And I set field "gutmge" to "-10" in row 1
#	And I save the current editor
#	
#  # Rückbau1 betrifft mengenmäßig immer beide Rückmeldungen
#	Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
#	And I set field "gutmge" to "-9" in row 1
#	And I set field "bueinh" to "Paar" in row 1
#	And I save the current editor
#
#  # Bestand, LJ und Belege prüfen
#	Given I open the infosystem "BESTAND"
#	And I set fields
#		| artikel | BG-EINHEITENPFL |
#		| klplatz | F1              |
#		| verdichten  | nein              |
#       | details     | nein              | 
#	And I press start
#	And I press button "taufzu" in row 1
#	Then table has values
#		| lemge | leinheit  | gebmge  | geinheit    | kopfzugvorg^id        |
#		| 2     | Stück     |        |         | (0,0,0)	 |
#		|      |     | 1       | Paar        | !Rückmeldung1^id  |
#	And I close the current editor
#
#	Given I open the infosystem "LJ"
#	And I set fields
#		| beleg   | !Rückmeldung1^barmex  |
#		| artikel | BG-EINHEITENPFL       |
#		| richtung| rückwärts             |
#	And I press start
#	Then table has values
#		| zmge  | mei   | rueckmge  | restmge | !row  |
#		| -5    | Paar  | -10       | 0       | 1     |
#		| -4    | Paar  | -8        | 0       | 2     |
#		| -5    | Stück | -5        | 0       | 3     |
#		| -5    | Stück | -5        | 0       | 4     |
#		| 5     | Paar  | 10        | 0       | 5     |
#		| 5     | Stück | 5         | 0       | 6     |
#		| 5     | Stück | 5         | 0       | 7     |
#		| 5     | Paar  | 8         | 2       | 8     |
#	And I close the current editor
#
#	Given I switch the current editor to editor "Rückbau1" with command "VIEW"
#	Then table has values
#		| artikel         | bumge | bueinh  | rueckmge  | restmge | limgen  | limgev  |
#		| BG-EINHEITENPFL | -10   | Stück   | -10       | 0       | 20      | 30      |
#	And I close the current editor
#	
#	Given I switch the current editor to editor "Rückbau2" with command "VIEW"
#	Then table has values
#		| artikel         | bumge | bueinh  | rueckmge  | restmge | limgen  | limgev  |
#		| BG-EINHEITENPFL | -9    | Paar    | -18       | 0       | 2       | 20      |
#	And I close the current editor
#
#	Given I switch the current editor to editor "Rückmeldung2" with command "VIEW"
#	Then table has values
#		| artikel         | bumge | bueinh  | rueckmge  | restmge | limgen  | limgev  |
#		| BG-EINHEITENPFL | 15    | Stück   | 15        | 0       | 30      | 15      |
#	And I close the current editor
#
#	Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
#	Then table has values
#		| artikel         | bumge | bueinh  | rueckmge  | restmge | limgen  | limgev  |
#		| BG-EINHEITENPFL | 15    | Stück   | 13        | 2       | 15      | 0       |
#	And I close the current editor
#
#    # FV abschließen und Auftrag liefern
#    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
#    And I set field "gutmge" to "14" in row 1
#    And I set field "bueinh" to "Paar" in row 1
#    And I save the current editor
#
#    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
#    And I set fields
#      | vom | .   |
#      | ueb | ja  |
#    And I set field "mge" to "15" in row 1
#    And I save the current editor
#
#    Given I open the infosystem "BESTAND"
#    And I set fields
#      | artikel | BG-EINHEITENPFL |
#      | klplatz | F1              |
#      | verdichten | nein           |
#      | nullmge | nein           |
#      | details | nein           | 
#    And I press start
#    Then the table has 0 rows
#    And I close the current editor

