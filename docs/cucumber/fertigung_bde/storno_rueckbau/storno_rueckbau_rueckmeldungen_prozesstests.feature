@persistent
Feature: storno_rueckbau_rueckmeldungen_prozesstests.feature

  Background:
# Given I enable the flag 42
    And I set the fake date to "5.1.95"
# fake dates können mit std/test/fake_date_subst_in_cucumber.pl gepflegt werden. anleitung s. dort

# *****************************************************************************
#  Name             : storno_rueckbau_rueckmeldungen_prozesstests
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet die Prozesse des Stornos von Rückbauten
#  Jira-Issue       : FDA-1005
# *****************************************************************************

## Storno der Rückgaben auf einen lebendigen Betriebsauftrag

  Scenario: 01 Storno eines Teil-Rückbaus auf Arbeitsschein nach retrograder Buchung über Rückmeldung
    Given I set the fake date to "6.1.95"
# Bestandskorrektur auf 0 BAUGRUPPE
    And I set the fake date to "7.1.95"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN01"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN01"
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

# Rückmeldung auf ersten Arbeitsgang und Bewertung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ARBEITSS_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Bewertung_Rückmeldung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Rückbau auf ersten Arbeitsschein und Bewertung
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ARBEITSS_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-2" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

    Given I switch the current editor to editor "Bewertung_Rückmeldung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_Rückbau" via ID from editor "Bewertung_Rückmeldung" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Storno Rückbau zu ARBEITSS_001
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I set field "erbtext1" to "Storno-Rückbau1" in row 1
    And I save the current editor

# Bewertung erhält Nachfolger
    Given I switch the current editor to editor "Bewertung_Rückbau" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_Storno" via ID from editor "Bewertung_Rückbau" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache               | rueckmge | restmge | !row |
      | BAUGRUPPE | 2    |      | Storno-Rückbau Fertigung | 2        | 0       | 1    |
      | EINKAUF-1 |      | 4    | Storno-Rückbau Fertigung | 4        | 0       | 2    |
      | EINKAUF-2 |      | 2    | Storno-Rückbau Fertigung | 2        | 0       | 3    |
      | BAUGRUPPE | -2   |      | Rückbau Fertigung        | -2       | 0       | 4    |
      | EINKAUF-1 |      | -4   | Rückbau Fertigung        | -4       | 0       | 5    |
      | EINKAUF-2 |      | -2   | Rückbau Fertigung        | -2       | 0       | 6    |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung    | 0        | 5       | 7    |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung    | 0        | 10      | 8    |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung    | 0        | 5       | 9    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 6
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
    Then table has values
      | !row | gebmge | kopfzugvorg^id   |
      | 2    | 3      | !Rückmeldung1^id |
      | 3    | 2      | !Rückmeldung1^id |
    And I set fields
      | artikel | EINKAUF-1 |
      | klplatz | F1        |
      | details | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | !row | gebmge | kopfzugvorg^id    |
      | 2    | 6      | !RechnungLager^id |
      | 3    | 4      | !RechnungLager^id |
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ARBEITSS_000"
    Then field "mge" has value "5"
    Then field "rgutmge" has value "0"
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | limge | gmge | !row |
      | 10    | 10   | 1    |
      | 5     | 5    | 2    |
      | 5     | 0.5  | 3    |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ARBEITSS_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-01"


  Scenario: 02 Storno eines Gesamt-Rückbaus auf Arbeitsschein nach retrograder Buchung über Rückmeldung
    Given I set the fake date to "8.1.95"
# Bestandskorrektur auf 0
    And I set the fake date to "9.1.95"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN02"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN02"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag02" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

# Bedarfe einkaufen
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

# Rückmeldung und Rückbau auf ersten Arbeitsgang und Bewertungen prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLES_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

    Given I open an editor "Bewertung_Rückmeldung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ALLES_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-5" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

    Given I open an editor "Bewertung_Rückbau" via ID from editor "Bewertung_Rückmeldung" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Storno Rückbau1
    Given I open an editor "Storno1_Rückbau" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such==ALLES_001;erbtext1==Rückbau1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I save the current editor

# Rückbau-Bewertung erhält Nachfolger
    Given I switch the current editor to editor "Bewertung_Rückbau" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_Storno" via ID from editor "Bewertung_Rückbau" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache               | rueckmge | restmge | !row |
      | BAUGRUPPE | 5    |      | Storno-Rückbau Fertigung | 5        | 0       | 1    |
      | EINKAUF-1 |      | 10   | Storno-Rückbau Fertigung | 10       | 0       | 2    |
      | EINKAUF-2 |      | 5    | Storno-Rückbau Fertigung | 5        | 0       | 3    |
      | BAUGRUPPE | -5   |      | Rückbau Fertigung        | -5       | 0       | 4    |
      | EINKAUF-1 |      | -10  | Rückbau Fertigung        | -10      | 0       | 5    |
      | EINKAUF-2 |      | -5   | Rückbau Fertigung        | -5       | 0       | 6    |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung    | 0        | 5       | 7    |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung    | 0        | 10      | 8    |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung    | 0        | 5       | 9    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 6
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
    Then the table has 2 rows
    Then table has values
      | !row | gebmge | kopfzugvorg^id   |
      | 2    | 5      | !Rückmeldung1^id |
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | !row | gebmge | kopfzugvorg^id    |
      | 2    | 10     | !RechnungLager^id |
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ALLES_000"
    Then field "mge" has value "5"
    Then field "rgutmge" has value "0"
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | limge | gmge | !row |
      | 10    | 10   | 1    |
      | 5     | 5    | 2    |
      | 5     | 0.5  | 3    |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLES_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor
    Given I deliver the SalesOrder "auftrag02" with PackingSlip "LS-02"


  Scenario: 03 Storno eines Teil-Rückbaus auf Betriebsauftrag nach retrograder Buchung über Betriebsauftrag
    Given I set the fake date to "10.1.95"
# Bestandskorrektur auf 0
    And I set the fake date to "11.1.95"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN03"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN03"

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

# Rückmeldung und Rückbau auf Betriebsauftrag, Bewertungen prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BETRIEB_000"
    And I set fields
      | sofort | ja  |
      | mgr    | 112 |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

    Given I open an editor "Bewertung_Rückmeldung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BETRIEB_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "-2" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

    Given I open an editor "Bewertung_Rückbau" via ID from editor "Bewertung_Rückmeldung" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Storno des Rückbaus
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Bewertung erhält Nachfolger
    Given I switch the current editor to editor "Bewertung_Rückbau" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_Storno" via ID from editor "Bewertung_Rückbau" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache               | rueckmge | restmge | !row |
      | BAUGRUPPE | 2    |      | Storno-Rückbau Fertigung | 2        | 0       | 1    |
      | EINKAUF-1 |      | 4    | Storno-Rückbau Fertigung | 4        | 0       | 2    |
      | EINKAUF-2 |      | 2    | Storno-Rückbau Fertigung | 2        | 0       | 3    |
      | BAUGRUPPE | -2   |      | Rückbau Fertigung        | -2       | 0       | 4    |
      | EINKAUF-1 |      | -4   | Rückbau Fertigung        | -4       | 0       | 5    |
      | EINKAUF-2 |      | -2   | Rückbau Fertigung        | -2       | 0       | 6    |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung    | 0        | 5       | 7    |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung    | 0        | 10      | 8    |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung    | 0        | 5       | 9    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 6
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
    Then table has values
      | !row | gebmge | kopfzugvorg^id   |
      | 2    | 3      | !Rückmeldung1^id |
      | 3    | 2      | !Rückmeldung1^id |
    And I set fields
      | artikel | EINKAUF-1 |
      | klplatz | F1        |
      | details | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | !row | gebmge | kopfzugvorg^id    |
      | 2    | 6      | !RechnungLager^id |
      | 3    | 4      | !RechnungLager^id |
    And I close the current editor

# Mengen in Reservierung prüfen, Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BETRIEB_000"
    Then field "mge" has value "5"
    Then field "rgutmge" has value "5"
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | limge | gmge | !row |
      | 10    | 10   | 1    |
      | 5     | 5    | 2    |
      | 5     | 0.5  | 3    |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BETRIEB_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor
    Given I deliver the SalesOrder "auftrag03" with PackingSlip "LS-03"


  Scenario: 04 Storno eines Rückbaus, der den Status in der Zeile gesetzt hat
    Given I set the fake date to "12.1.95"
#  Auftrag anlegen und Bedarfe einkaufen
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

# Rückbau2 stornieren
    Given I open an editor "Storno1_Rückbau2" via ID from editor "Rückbau2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "status" is empty in row 1
    And I save the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "STATUS_002"
    Then fields have values
      | status  |   |
      | mge     | 1 |
      | rgutmge | 9 |
    And I close the current editor

# Rückbau1 kann nicht storniert werden wegen Rückmeldung2
    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1" throws the exception "9503"

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "STATUS_001"
    Then fields have values
      | status  |   |
      | mge     | 1 |
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


  Scenario: 05 Storno eines Rückbaus reduziert die Herstellkosten um die positiven Zeiten aus dem Rückbaubeleg
    Given I set the fake date to "13.1.95"
# Bestandskorrektur BAUGRUPPE
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN05"

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

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "KOSTEN_001"
    And I set fields
      | sofort | ja  |
      | bzeit  | 0.5 |
      | mzeit  | 0.5 |
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor

# Nachbewerten und Nachkalkulation prüfen
    And I set the fake date to "14.1.95"
    Given I run Revaluation
    Given I open an editor "KBlatt" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for record "$,,artikel=BAUGRUPPE;typ=Nachkalkulation;@richtung=rückwärts;@maxordtreffer=1"
    Then field "herkunft^banummer" in row 0 has value equal to field "nummer" from editor "Betriebsauftrag" in row 0
    Then table has values
      | !row | eeinzk | evzeit | ksart             | ekart  |
      | 5    | 1.5000 | 1      | aus der Fertigung | Lohn   |
      | 6    | 2.0000 | 1      | aus der Fertigung | FK fix |
      | 7    | 3.5000 | 1      | aus der Fertigung | FK var |
    And I close the current editor

# Rückbau stornieren
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
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
      | 5    | 0.7500 | 0.5    | aus der Fertigung | Lohn   |
      | 6    | 1.5000 | 0.5    | aus der Fertigung | FK fix |
      | 7    | 2.7500 | 0.5    | aus der Fertigung | FK var |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOSTEN_001"
    And I set fields
      | sofort   | ja   |
      | rzbuchen | nein |
      | gut      | ja   |
      | bzeit    | 0.75 |
      | mzeit    | 0.75 |
    And I save the current editor
    Given I deliver the SalesOrder "auftrag05" with PackingSlip "LS-05"

# Nachkalkulation prüfen
    And I run Revaluation
    And I switch the current editor to editor "KBlatt" with command "VIEW"
    Then table has values
      | !row | eeinzk | evzeit | ksart             | ekart  |
      | 3    | 1.8750 | 1.25   | aus der Fertigung | Lohn   |
      | 4    | 2.2500 | 1.25   | aus der Fertigung | FK fix |
      | 5    | 3.8750 | 1.25   | aus der Fertigung | FK var |
    And I close the current editor


  Scenario: 06 Storno eines Rückbaus mit Gutmenge im Behälter
    Given I set the fake date to "15.1.95"
# Auftrag anlegen, Bedarfe einkaufen und Behälter anlegen
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

    Given I create a Container "BEHAELTER_1" for packaging material "BEHAELTER"

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

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "WORKED_001"
    And I set fields
      | sofort    | ja              |
      | behaelter | !BEHAELTER_1^id |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "WORKED_001"
    And I set fields
      | sofort    | ja              |
      | behaelter | !BEHAELTER_1^id |
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor

# Storno des Rückbaus
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Behälter prüfen, hat wieder die ursprüngliche Menge
    Given I switch the current editor to editor "BEHAELTER_1" with command "VIEW"
    Then field "mge" has value "5" in row 1
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | zmge | amge | detursache               | rueckmge | restmge | !row |
      | BG-BEHAELTER | 2    |      | Storno-Rückbau Fertigung | 2        | 0       | 1    |
      | EINKAUF-1    |      | 4    | Storno-Rückbau Fertigung | 4        | 0       | 2    |
      | EINKAUF-2    |      | 2    | Storno-Rückbau Fertigung | 2        | 0       | 3    |
      | BG-BEHAELTER | -2   |      | Rückbau Fertigung        | -2       | 0       | 4    |
      | EINKAUF-1    |      | -4   | Rückbau Fertigung        | -4       | 0       | 5    |
      | EINKAUF-2    |      | -2   | Rückbau Fertigung        | -2       | 0       | 6    |
      | BG-BEHAELTER | 5    |      | Rückmeldung Fertigung    | 0        | 5       | 7    |
      | EINKAUF-1    |      | 10   | Rückmeldung Fertigung    | 0        | 10      | 8    |
      | EINKAUF-2    |      | 5    | Rückmeldung Fertigung    | 0        | 5       | 9    |
    Then field "behaelter^id" in row 1 has value equal to field "behaelter^id" from editor "LJ" in row 4
    Then field "behaelter^id" in row 1 has value equal to field "behaelter^id" from editor "LJ" in row 7
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "WORKED_001"
    And I set fields
      | sofort    | ja              |
      | gut       | ja              |
      | manrest   | ja              |
      | behaelter | !BEHAELTER_1^id |
    And I save the current editor

    And I switch the current editor to editor "auftrag06" with command "DELIVERY"
    And I set fields
      | ueb | ja |
    And I set field "mge" to "10" in row 1
    And I press button "packvor"
    And I set field "behaelter" to id from editor "BEHAELTER_1" in row 1
    And I respond with answer "ja" to the dialog with id "8076"
    And I save the current editor


  Scenario: 07 Storno eines Rückbaus, der Gutmenge aus einem Behälter gebucht hat, Behälter hat negative Menge
    Given I set the fake date to "16.1.95"
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
      | artikel      | netmge | bisuch      | mfreig |
      | BG-BEHAELTER | 10     | SCENARIO07_ | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag07" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIO07_001"
    And I set fields
      | sofort    | ja              |
      | behaelter | !BEHAELTER_1^id |
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

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "SCENARIO07_001"
    And I set fields
      | sofort    | ja              |
      | behaelter | !BEHAELTER_1^id |
    And I set field "gutmge" to "-5" in row 1
    And I set field "erbtext1" to "alles_001_rb2" in row 1
    And I save the current editor

# Stonro auf Rückbau1
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | zmge | amge | detursache               | rueckmge | restmge | !row |
      | BG-BEHAELTER | 5    |      | Storno-Rückbau Fertigung | 5        | 0       | 1    |
      | EINKAUF-1    |      | 10   | Storno-Rückbau Fertigung | 10       | 0       | 2    |
      | EINKAUF-2    |      | 5    | Storno-Rückbau Fertigung | 5        | 0       | 3    |
      | BG-BEHAELTER | -5   |      | Rückbau Fertigung        | -5       | 0       | 4    |
      | EINKAUF-1    |      | -10  | Rückbau Fertigung        | -10      | 0       | 5    |
      | EINKAUF-2    |      | -5   | Rückbau Fertigung        | -5       | 0       | 6    |
      | BG-BEHAELTER | 5    |      | Rückmeldung Fertigung    | 0        | 5       | 7    |
      | EINKAUF-1    |      | 10   | Rückmeldung Fertigung    | 0        | 10      | 8    |
      | EINKAUF-2    |      | 5    | Rückmeldung Fertigung    | 0        | 5       | 9    |
    Then field "behaelter^id" in row 1 has value equal to field "behaelter^id" from editor "LJ" in row 4
    Then field "behaelter^id" in row 1 has value equal to field "behaelter^id" from editor "LJ" in row 7
    And I close the current editor

# BEHAELTER_1 und BEHALTER_2 prüfen
    Then Container from editor "BEHAELTER_1" is empty
    Given I switch the current editor to editor "BEHAELTER_2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel      | mge |
      | BG-BEHAELTER | 5   |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIO07_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I set field "behaelter" to id from editor "BEHAELTER_2"
    And I save the current editor

# Behälter prüfen
    Then Container from editor "BEHAELTER_1" is empty
    And I switch the current editor to editor "BEHAELTER_2"
    Then the table has 1 rows
    Then table has values
      | artikel      | mge |
      | BG-BEHAELTER | 10  |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag07" in row 1
    And I close the current editor

# Auftrag ausliefern
    And I switch the current editor to editor "auftrag07" with command "DELIVERY"
    And I set fields
      | ueb | ja |
    And I set field "mge" to "10" in row 1
    And I press button "packvor"
    And I set field "behaelter" to id from editor "BEHAELTER_2" in row 1
    And I respond with answer "ja" to the dialog with id "8076"
    And I save the current editor


  Scenario: 08 Storno eines Rückbaus, wenn Gutmenge auf einem anderen Lagerplatz liegt
    Given I set the fake date to "17.1.95"
# Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN08"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F2" with document "SCEN08"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag09" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP9 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag09" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag09" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch      | mfreig |
      | BAUGRUPPE | 10     | ALLESPLATZ_ | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag09" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLESPLATZ_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ALLESPLATZ_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-3" in row 1
    And I set field "erbtext1" to "allesplatz_001_rb3" in row 1
    And I save the current editor

# Gutmenge auf anderen Lagerplatz umbuchen
    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE |
      | beldat  | .         |
      | beleg   | 4711      |
      | buart   | Umbuchung |
    And I modify table
      | mge | platz | platz2 | !row |
      | 2   | F1    | F2     | 1    |
    And I set field "verw" in row 1 to "verw" from editor "auftrag09" in row 1
    And I set field "verw2" in row 1 to "verw" from editor "auftrag09" in row 1
    And I save the current editor

# Rückbau stornieren, Bestand prüfen
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "buplatz" has value "F1" in row 1
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
      | lemge | gebmge | lplatz | kopfzugvorg^id   |
      | 3     |        | F1     | (0,0,0)          |
      |       | 3      | F1     | !Rückmeldung1^id |
      | 2     |        | F2     | (0,0,0)          |
      |       | 2      | F2     | !Rückmeldung1^id |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLESPLATZ_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Given I switch the current editor to editor "auftrag09" with command "DELIVERY"
    And I set field "ueb" to "ja"
    And I set field "mge" to "10" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | zuomge | lpsuch | !row |
      | 2      | F2     | 1    |
      | 8      | F1     | +2   |
    And I save the current editor
    And I switch the current editor to editor "auftrag09"
    And I save the current editor


  Scenario: 09 Storno eines Rückbaus mit bedarfsbezogener Gutmenge
    Given I set the fake date to "18.1.95"
# Bestandskorrektur auf 0 B_BAUGRUPPE
    And I set the fake date to "19.1.95"
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "SCEN09"

# Auftrag anlegen, Fertigungsvorschlag anlegen und freigeben
    Given I create a SalesOrder "auftrag10" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"
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

# Rückmeldung und Rückbau auf ersten Arbeitsgang, Bewertungen prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKBAU_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "30" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

    Given I open an editor "Bewertung_Rückmeldung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=B_BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RUECKBAU_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-20" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

    Given I open an editor "Bewertung_Rückbau" via ID from editor "Bewertung_Rückmeldung" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Storno des Rückbaus und Bewertung prüfen
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I switch the current editor to editor "Bewertung_Rückbau" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_Storno" via ID from editor "Bewertung_Rückbau" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# rueckmge und restmge in Storno, Rückbau und Rückmeldung prüfen
    And I switch the current editor to editor "Storno1_Rückbau" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 20      | 20    | 10     | 30     |
      | B_EINKAUF-2 | 0        | 20      | 20    | 40     | 20     |
      | B_EINKAUF-1 | 0        | 40      | 40    | 80     | 40     |
    And I close the current editor

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
      | B_BAUGRUPPE | 0        | 30      | 30    | 0      | 30     |
      | B_EINKAUF-2 | 0        | 30      | 30    | 50     | 20     |
      | B_EINKAUF-1 | 0        | 60      | 60    | 100    | 40     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | detursache               | !row |
      | B_BAUGRUPPE | 20   |      | 20       | 0       | Storno-Rückbau Fertigung | 1    |
      | B_EINKAUF-1 |      | 40   | 40       | 0       | Storno-Rückbau Fertigung | 2    |
      | B_EINKAUF-2 |      | 20   | 20       | 0       | Storno-Rückbau Fertigung | 3    |
      | B_BAUGRUPPE | -20  |      | -20      | 0       | Rückbau Fertigung        | 4    |
      | B_EINKAUF-1 |      | -40  | -40      | 0       | Rückbau Fertigung        | 5    |
      | B_EINKAUF-2 |      | -20  | -20      | 0       | Rückbau Fertigung        | 6    |
      | B_BAUGRUPPE | 30   |      | 0        | 30      | Rückmeldung Fertigung    | 7    |
      | B_EINKAUF-1 |      | 60   | 0        | 60      | Rückmeldung Fertigung    | 8    |
      | B_EINKAUF-2 |      | 30   | 0        | 30      | Rückmeldung Fertigung    | 9    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 6
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKBAU_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

# Bestandsinfo prüfen, Auftrag liefern
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 50    |        | (0,0,0)          |
      |       | 10     | !Rückmeldung1^id |
      |       | 20     | !Rückmeldung1^id |
      |       | 20     | !Rückmeldung2^id |
    And I close the current editor
    Given I deliver the SalesOrder "auftrag10" with PackingSlip "LS-10"


  Scenario: 10 Storno eines Rückbaus, dessen Menge zwei Rückmeldungen betrifft, setzt die rueckmge und restmge in den Rückmeldungen korrekt
    Given I set the fake date to "20.1.95"
# Bestandskorrektur B_BAUGRUPPE
    And I set the fake date to "21.1.95"
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "SCEN_10"

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
    And I set the fake date to "22.1.95"
    And I wait 1 time units to move the time forward
# = Given I set the fake date to "04.02.1995"

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEIRUECK_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "20" in row 1
    And I set field "erbtext1" to "Rückmeldung2" in row 1
    And I save the current editor
    And I set the fake date to "23.1.95"
    And I wait 1 time units to move the time forward
# = Given I set the fake date to "04.02.1995"

# Rückbau1 und Storno des Rückbaus
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ZWEIRUECK_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-30" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# rueckmge und restmge in Storno1_Rückbau, Rückbau1 und Rückmeldungen prüfen
    Given I switch the current editor to editor "Storno1_Rückbau" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 30      | 30    | 10     | 40     |
      | B_EINKAUF-2 | 0        | 30      | 30    | 40     | 10     |
      | B_EINKAUF-1 | 0        | 60      | 60    | 80     | 20     |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -30      | 0       | -30   | 40     | 10     |
      | B_EINKAUF-2 | -30      | 0       | -30   | 10     | 40     |
      | B_EINKAUF-1 | -60      | 0       | -60   | 20     | 80     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 20      | 20    | 20     | 40     |
      | B_EINKAUF-2 | 0        | 20      | 20    | 30     | 10     |
      | B_EINKAUF-1 | 0        | 40      | 40    | 60     | 20     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 20      | 20    | 0      | 20     |
      | B_EINKAUF-2 | 0        | 20      | 20    | 50     | 30     |
      | B_EINKAUF-1 | 0        | 40      | 40    | 100    | 60     |
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
    Then the table has 4 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 40    |        | (0,0,0)          |
      |       | 10     | !Rückmeldung1^id |
      |       | 20     | !Rückmeldung2^id |
      |       | 10     | !Rückmeldung1^id |
    And I close the current editor

# Lagerbewegungsjournal
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | amge | zmge | rueckmge | restmge | detursache               | rueckbew | storniert | !row |
      | B_BAUGRUPPE |      | 10   | 10       | 0       | Storno-Rückbau Fertigung | nein     | nein      | 1    |
      | B_BAUGRUPPE |      | 20   | 20       | 0       | Storno-Rückbau Fertigung | nein     | nein      | 2    |
      | B_EINKAUF-1 | 40   |      | 40       | 0       | Storno-Rückbau Fertigung | nein     | nein      | 3    |
      | B_EINKAUF-1 | 20   |      | 20       | 0       | Storno-Rückbau Fertigung | nein     | nein      | 4    |
      | B_EINKAUF-2 | 20   |      | 20       | 0       | Storno-Rückbau Fertigung | nein     | nein      | 5    |
      | B_EINKAUF-2 | 10   |      | 10       | 0       | Storno-Rückbau Fertigung | nein     | nein      | 6    |
      | B_BAUGRUPPE |      | -20  | -20      | 0       | Rückbau Fertigung        | ja       | ja        | 7    |
      | B_BAUGRUPPE |      | -10  | -10      | 0       | Rückbau Fertigung        | ja       | ja        | 8    |
      | B_EINKAUF-1 | -20  |      | -20      | 0       | Rückbau Fertigung        | ja       | ja        | 9    |
      | B_EINKAUF-1 | -40  |      | -40      | 0       | Rückbau Fertigung        | ja       | ja        | 10   |
      | B_EINKAUF-2 | -10  |      | -10      | 0       | Rückbau Fertigung        | ja       | ja        | 11   |
      | B_EINKAUF-2 | -20  |      | -20      | 0       | Rückbau Fertigung        | ja       | ja        | 12   |
      | B_BAUGRUPPE |      | 20   | 0        | 20      | Rückmeldung Fertigung    | nein     | nein      | 13   |
      | B_EINKAUF-1 | 40   |      | 0        | 40      | Rückmeldung Fertigung    | nein     | nein      | 14   |
      | B_EINKAUF-2 | 20   |      | 0        | 20      | Rückmeldung Fertigung    | nein     | nein      | 15   |
      | B_BAUGRUPPE |      | 20   | 0        | 20      | Rückmeldung Fertigung    | nein     | nein      | 16   |
      | B_EINKAUF-1 | 40   |      | 0        | 40      | Rückmeldung Fertigung    | nein     | nein      | 17   |
      | B_EINKAUF-2 | 20   |      | 0        | 20      | Rückmeldung Fertigung    | nein     | nein      | 18   |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 8
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 10
    Then field "stornolj^id" in row 5 has value equal to field "verweis^id" from editor "LJ" in row 12
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEIRUECK_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag12" with PackingSlip "LS-12"


  Scenario: 11 Storno eines Rückbaus zu Rückmeldung mit Material aus zwei Zugängen; Joker und Verwendung
    Given I set the fake date to "24.1.95"
# Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN11"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN11"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "SCEN11"

    # sicher keine bestände mehr!
    Given I query "platz,gebmge,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==EINKAUF-1;platz==F1;gebmge<>0"
    Then query has no hits
    Given I query "platz,gebmge,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==EINKAUF-2;platz==F1;gebmge<>0"
    Then query has no hits
    Given I query "platz,gebmge,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==BAUGRUPPE;platz==F1;gebmge<>0"
    Then query has no hits

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

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | bisuch | mfreig |
      | BAUGRUPPE | 60  | JOKER_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag13" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang und Rückbau
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "JOKER_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "50" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "JOKER_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-45" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# Storno des Rückbaus
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

  # todo uo: bitte Ergebnisse prüfen
# zugehörigkeit/prüflogik: prinzip spiegelbild: die doku findest Du wenn Du i.d. datei nach "zugehörigkeit/prüflogik" suchst
#Given I query "lgruppe,lager,platz,pflag,charge,projekt,gebmge,1:verw,1:lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement" where "artikel==EINKAUF-1;platz==F1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge.rueckw,lj^id;@zeilen=ja"
#Then query has values
#|  lgruppe|lager|platz|pflag|charge|projekt|gebmge|  1:verw|1:lffert|bewmge|
#|KARLSRUHE|   L1|   F1|   ja|      |       |   -40|  200015|        |   -40|
#|KARLSRUHE|   L1|   F1|   ja|      |       |   -50|200015_1|        |   -50|
#
#Given I query "lgruppe,lager,platz,pflag,charge,projekt,gebmge,1:verw,1:lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==EINKAUF-2;platz==F1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge.rueckw,lj^id;@zeilen=ja"
#Then query has values
#|  lgruppe|lager|platz|pflag|charge|projekt|gebmge|  1:verw|1:lffert|bewmge|
#|KARLSRUHE|   L1|   F1|   ja|      |       |   -45|200015_1|        |   -45|
#
#Given I query "lgruppe,lager,platz,pflag,charge,projekt,gebmge,1:verw,1:lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==BAUGRUPPE;platz==F1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge.rueckw,lj^id;@zeilen=ja"
#Then query has values
#|  lgruppe|lager|platz|pflag|charge|projekt|gebmge|  1:verw|1:lffert|bewmge|
#|KARLSRUHE|   L1|   F1|   ja|      |       |    45|200015_1|        |    45|

# Lagerbewegungsjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rückmeldung1^barmex |
      | adatum   | -10                  |
      | edatum   | +30                  |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | art       | zmge | amge | rueckmge | restmge | detursache               | !row |
      | BAUGRUPPE | 45   |      | 45       | 0       | Storno-Rückbau Fertigung | 1    |
      | EINKAUF-1 |      | 40   | 40       | 0       | Storno-Rückbau Fertigung | 2    |
      | EINKAUF-1 |      | 50   | 50       | 0       | Storno-Rückbau Fertigung | 3    |
      | EINKAUF-2 |      | 45   | 45       | 0       | Storno-Rückbau Fertigung | 4    |
      | BAUGRUPPE | -45  |      | -45      | 0       | Rückbau Fertigung        | 5    |
      | EINKAUF-1 |      | -50  | -50      | 0       | Rückbau Fertigung        | 6    |
      | EINKAUF-1 |      | -40  | -40      | 0       | Rückbau Fertigung        | 7    |
      | EINKAUF-2 |      | -45  | -45      | 0       | Rückbau Fertigung        | 8    |
      | BAUGRUPPE | 50   |      | 0        | 50      | Rückmeldung Fertigung    | 9    |
      | EINKAUF-1 |      | 40   | 0        | 40      | Rückmeldung Fertigung    | 10   |
      | EINKAUF-1 |      | 60   | 0        | 60      | Rückmeldung Fertigung    | 11   |
      | EINKAUF-2 |      | 50   | 0        | 50      | Rückmeldung Fertigung    | 12   |
# Jokerbestand wird durch Storno wieder abgebucht
    Then field "verwla" in row 7 has value equal to field "verw" from editor "RechnungmL" in row 2
    Then field "verwla" in row 2 has value equal to field "verw" from editor "RechnungmL" in row 2
# Restlicher Storno über Bestand mit eindeutiger Verwendung
    Then field "verwla" in row 6 has value equal to field "verw" from editor "RechnungmL" in row 1
    Then field "verwla" in row 3 has value equal to field "verw" from editor "RechnungmL" in row 1
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge |
      | 20    |        |
      |       | 20     |
    Then field "verw" in row 2 has value equal to field "verw" from editor "RechnungmL" in row 2
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "JOKER_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag13" with PackingSlip "LS-13"

    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "B_SCEN135s"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_SCEN135s"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "B_SCEN135s"


  Scenario: 12 Storno eines Rückbaus zu Rückmeldung mit Chargen für die Gutmenge und Material
    Given I set the fake date to "25.1.95"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "chrueckb01s"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1" with document "chrueckb01s"
    Given I set StorageQuantity to zero for Product "B_BAUGRUPPE" on StorageLocation "F1" with document "chrueckb01s"

# sicher keine bestände mehr!
    Given I query "platz,gebmge,bewmge" from StorageQuantity for Product "B_EINKAUF-1" on StorageLocation "F1"
    Then StorageQuantity is zero
    Given I query "platz,gebmge,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==B_EINKAUF-2;platz==F1;gebmge<>0"
    Then query has no hits
    Given I query "platz,gebmge,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==B_BAUGRUPPE;platz==F1;gebmge<>0"
    Then query has no hits

# Chargen anlegen
    Given I create a Lot "B_MATERIAL1" for Product "B_EINKAUF-1"
    Given I create a Lot "B_MATERIAL2" for Product "B_EINKAUF-1"
    Given I create a Lot "B_BG1" for Product "B_BAUGRUPPE"
    Given I create a Lot "B_BG2" for Product "B_BAUGRUPPE"

# Auftrag anlegen und # Bedarfe einkaufen
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

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHRUECKBAU_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "40" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "CHRUECKBAU_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-10" in row 1
    And I set field "charge" to "!B_BG1^id" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "CHRUECKBAU_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-25" in row 1
    And I set field "charge" to "!B_BG2^id" in row 1
    And I set field "erbtext1" to "Rückbau2" in row 1
    And I save the current editor

# Storno des Rückbaus
    Given I open an editor "Storno2_Rückbau" via ID from editor "Rückbau2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# ------------------------
# zugehörigkeit/prüflogik:
# ------------------------
# die platzmengen wurden vor dem storno des rückbaus auf 0 gebracht.
# die tabellenmengen müssen sich also  genau spiegelbildlich zu den tabellenmengen in
# std/test/cucumber/fertigung_bde/BC2_RUECKBAU_Fertigung_Rueckmeldungen_Prozesstests.feature
# mit  such==CHRUECKBAU_001  verhalten, weil auch vor dem rückbau die platzmengen auf
# 0 gebracht wurden. einziger unterschied im spiegelbild: die zeilensortierung nach den mengen
# (oder die reihenfolge muss bei @ordnung gedreht werden, weil die VZ jeweils anders sind)

  # todo uo: bitte Ergebnisse prüfen
#Given I query "lgruppe,lager,platz,pflag,charge,projekt,gebmge,1:verw,1:lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==B_EINKAUF-1;gebmge<>0;lager<>`;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;@zeilen=ja"
#Then query has values
#|  lgruppe|lager|platz|pflag|charge|projekt|gebmge|1:verw|1:lffert|bewmge|
#|KARLSRUHE|   L1|   F1|   ja|     7|       |   -50|      |        |   -50|
#|KARLSRUHE|   L1|   F1|   ja|     8|       |   -20|      |        |   -20|
#|KARLSRUHE|   L1|     | nein|      |       |   -70|      |        |     0|
#
#Given I query "lgruppe,lager,platz,pflag,charge,projekt,gebmge,1:verw,1:lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==B_EINKAUF-2;gebmge<>0;lager<>`;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;@zeilen=ja"
#Then query has values
#|  lgruppe|lager|platz|pflag|charge|projekt|gebmge|1:verw|1:lffert|bewmge|
#|KARLSRUHE|   L1|   F1|   ja|      |       |   -35|      |        |   -35|
#|KARLSRUHE|   L1|     | nein|      |       |   -35|      |        |     0|
#
#Given I query "lgruppe,lager,platz,pflag,charge,projekt,gebmge,1:verw,1:lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==B_BAUGRUPPE;gebmge<>0;lager<>`;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,gebmge,lj^id;@zeilen=ja"
#Then query has values
#|  lgruppe|lager|platz|pflag|charge|projekt|gebmge|1:verw|1:lffert|bewmge|
#|KARLSRUHE|   L1|   F1|   ja|      |       |     5|      |        |     5|
#|KARLSRUHE|   L1|   F1|   ja|     9|       |     5|      |        |     5|
#|KARLSRUHE|   L1|   F1|   ja|    10|       |    25|      |        |    25|
#|KARLSRUHE|   L1|     | nein|      |       |    35|      |        |     0|

# rueckmge und restmge in Storno, Rückbau und Rückmeldung prüfen
    And I switch the current editor to editor "Storno2_Rückbau" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 25      | 25    | 5      | 30     |
      | B_EINKAUF-2 | 0        | 25      | 25    | 45     | 20     |
      | B_EINKAUF-1 | 0        | 50      | 50    | 90     | 40     |
    And I close the current editor

    And I switch the current editor to editor "Storno1_Rückbau" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 10      | 10    | 30     | 40     |
      | B_EINKAUF-2 | 0        | 10      | 10    | 20     | 10     |
      | B_EINKAUF-1 | 0        | 20      | 20    | 40     | 20     |
    And I close the current editor

    And I switch the current editor to editor "Rückbau2" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -25      | 0       | -25   | 30     | 5      |
      | B_EINKAUF-2 | -25      | 0       | -25   | 20     | 45     |
      | B_EINKAUF-1 | -50      | 0       | -50   | 40     | 90     |
    And I close the current editor

    And I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | -10      | 0       | -10   | 40     | 30     |
      | B_EINKAUF-2 | -10      | 0       | -10   | 10     | 20     |
      | B_EINKAUF-1 | -20      | 0       | -20   | 20     | 40     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | rueckmge | restmge | bumge | limgev | limgen |
      | B_BAUGRUPPE | 0        | 40      | 40    | 0      | 40     |
      | B_EINKAUF-2 | 0        | 40      | 40    | 50     | 10     |
      | B_EINKAUF-1 | 0        | 80      | 80    | 100    | 20     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | ncharge^such | rueckbew | storniert | !row |
      | B_BAUGRUPPE | 10   |      | 10       | 0       |              | B_BG1        | nein     | nein      | 1    |
      | B_EINKAUF-1 |      | 20   | 20       | 0       | B_MATERIAL1  | B_BG1        | nein     | nein      | 2    |
      | B_EINKAUF-2 |      | 10   | 10       | 0       |              | B_BG1        | nein     | nein      | 3    |
      | B_BAUGRUPPE | 25   |      | 25       | 0       |              | B_BG2        | nein     | nein      | 4    |
      | B_EINKAUF-1 |      | 10   | 10       | 0       | B_MATERIAL2  | B_BG2        | nein     | nein      | 5    |
      | B_EINKAUF-1 |      | 40   | 40       | 0       | B_MATERIAL1  | B_BG2        | nein     | nein      | 6    |
      | B_EINKAUF-2 |      | 25   | 25       | 0       |              | B_BG2        | nein     | nein      | 7    |
      | B_BAUGRUPPE | -25  |      | -25      | 0       |              | B_BG2        | ja       | ja        | 8    |
      | B_EINKAUF-1 |      | -40  | -40      | 0       | B_MATERIAL1  | B_BG2        | ja       | ja        | 9    |
      | B_EINKAUF-1 |      | -10  | -10      | 0       | B_MATERIAL2  | B_BG2        | ja       | ja        | 10   |
      | B_EINKAUF-2 |      | -25  | -25      | 0       |              | B_BG2        | ja       | ja        | 11   |
      | B_BAUGRUPPE | -10  |      | -10      | 0       |              | B_BG1        | ja       | ja        | 12   |
      | B_EINKAUF-1 |      | -20  | -20      | 0       | B_MATERIAL1  | B_BG1        | ja       | ja        | 13   |
      | B_EINKAUF-2 |      | -10  | -10      | 0       |              | B_BG1        | ja       | ja        | 14   |
      | B_BAUGRUPPE | 5    |      | 0        | 5       |              |              | nein     | nein      | 15   |
      | B_BAUGRUPPE | 25   |      | 0        | 25      |              | B_BG2        | nein     | nein      | 16   |
      | B_BAUGRUPPE | 10   |      | 0        | 10      |              | B_BG1        | nein     | nein      | 17   |
      | B_EINKAUF-1 |      | 10   | 0        | 10      | B_MATERIAL2  |              | nein     | nein      | 18   |
      | B_EINKAUF-1 |      | 10   | 0        | 10      | B_MATERIAL2  | B_BG2        | nein     | nein      | 19   |
      | B_EINKAUF-1 |      | 40   | 0        | 40      | B_MATERIAL1  | B_BG2        | nein     | nein      | 20   |
      | B_EINKAUF-1 |      | 20   | 0        | 20      | B_MATERIAL1  | B_BG1        | nein     | nein      | 21   |
      | B_EINKAUF-2 |      | 5    | 0        | 5       |              |              | nein     | nein      | 22   |
      | B_EINKAUF-2 |      | 25   | 0        | 25      |              | B_BG2        | nein     | nein      | 23   |
      | B_EINKAUF-2 |      | 10   | 0        | 10      |              | B_BG1        | nein     | nein      | 24   |
    And I close the current editor

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


  Scenario: 13 Storno eines Rückbaus zu Rückmeldung mit Gutmenge mit Projekt
    Given I set the fake date to "26.1.95"
# Bestände auf 0
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "SCEN13"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1" with document "SCEN13"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN13"

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
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | projekt      | mfreig |
      | BAUGRUPPE | 50     | PROJEKT_BG16 | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    And I modify table
      | elex        | elanzahl    | !row |
      | !dontChange | !dontChange | -1   |
      | !dontChange | !dontChange | -1   |
      | B_EINKAUF-1 | 2           | +1   |
      | B_EINKAUF-2 | 1           | +2   |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "PROJEKT1_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROJEKT1_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "40" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "PROJEKT1_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-35" in row 1
    And I save the current editor

# Rückbau stornieren
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerjournal und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | projekt      | projektla | detursache               |
      | BAUGRUPPE   | 35   |      | PROJEKT_BG16 | ja        | Storno-Rückbau Fertigung |
      | B_EINKAUF-1 |      | 70   | PROJEKT_BG16 | nein      | Storno-Rückbau Fertigung |
      | B_EINKAUF-2 |      | 35   | PROJEKT_BG16 | nein      | Storno-Rückbau Fertigung |
      | BAUGRUPPE   | -35  |      | PROJEKT_BG16 | ja        | Rückbau Fertigung        |
      | B_EINKAUF-1 |      | -70  | PROJEKT_BG16 | nein      | Rückbau Fertigung        |
      | B_EINKAUF-2 |      | -35  | PROJEKT_BG16 | nein      | Rückbau Fertigung        |
      | BAUGRUPPE   | 40   |      | PROJEKT_BG16 | ja        | Rückmeldung Fertigung    |
      | B_EINKAUF-1 |      | 80   | PROJEKT_BG16 | nein      | Rückmeldung Fertigung    |
      | B_EINKAUF-2 |      | 40   | PROJEKT_BG16 | nein      | Rückmeldung Fertigung    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    | F1          |
      | verdichten | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | !row | gebmge | projekt |
      | 2    | 20     |         |
    And I close the current editor

# Betriebsauftrag und Auftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROJEKT1_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-16"


  Scenario: 14 Storno eines Rückbaus auf Arbeitsschein und Betriebsauftrag
    Given I set the fake date to "27.1.95"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "KORR_14"
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
      | artikel     | mge |
      | B_EINKAUF-1 | 20  |
      | B_EINKAUF-2 | 10  |
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

# Zwei Rückmeldungen auf ersten Arbeitsgang und Rückmeldung auf Betriebsauftrag
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AS_BA_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    And I set the fake date to "28.1.95"
    And I wait 1 time units to move the time forward
# 1 = "04.02.1995"

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AS_BA_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    And I set the fake date to "1.2.95"
    And I wait 1 time units to move the time forward
# 1 = "04.02.1995"

    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AS_BA_000"
    And I set fields
      | sofort | ja  |
      | mgr    | 112 |
    And I set field "gutmge" to "8" in row 1
    And I save the current editor
    And I set the fake date to "2.2.95"
    And I wait 1 time units to move the time forward
# 1 = "04.02.1995"

# Rückbau auf Arbeistschein und Betriebsauftrag
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "AS_BA_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor

    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "AS_BA_000"
    And I set fields
      | sofort | ja  |
      | mgr    | 112 |
    And I set field "gutmge" to "-6" in row 1
    And I save the current editor

# Storno der Rückbauten
    Given I open an editor "Storno2_Rückbau" via ID from editor "Rückbau2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache            | rueckmge | restmge | storniert | !row |
      | BAUGRUPPE | 3    |      | Rückmeldung Fertigung | 0        | 3       | nein      | 1    |
      | EINKAUF-1 |      | 6    | Rückmeldung Fertigung | 0        | 6       | nein      | 2    |
      | EINKAUF-2 |      | 3    | Rückmeldung Fertigung | 0        | 3       | nein      | 3    |
      | BAUGRUPPE | 2    |      | Rückmeldung Fertigung | 0        | 2       | nein      | 4    |
      | EINKAUF-1 |      | 4    | Rückmeldung Fertigung | 0        | 4       | nein      | 5    |
      | EINKAUF-2 |      | 2    | Rückmeldung Fertigung | 0        | 2       | nein      | 6    |
    And I set field "beleg" to "barmex" from editor "Rückmeldung3"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache               | rueckmge | restmge | !row |
      | BAUGRUPPE | 2    |      | Storno-Rückbau Fertigung | 2        | 0       | 1    |
      | BAUGRUPPE | 3    |      | Storno-Rückbau Fertigung | 3        | 0       | 2    |
      | EINKAUF-1 |      | 6    | Storno-Rückbau Fertigung | 6        | 0       | 3    |
      | EINKAUF-1 |      | 4    | Storno-Rückbau Fertigung | 4        | 0       | 4    |
      | EINKAUF-2 |      | 3    | Storno-Rückbau Fertigung | 3        | 0       | 5    |
      | EINKAUF-2 |      | 2    | Storno-Rückbau Fertigung | 2        | 0       | 6    |
      | BAUGRUPPE | -3   |      | Rückbau Fertigung        | -3       | 0       | 7    |
      | BAUGRUPPE | -2   |      | Rückbau Fertigung        | -2       | 0       | 8    |
      | EINKAUF-1 |      | -4   | Rückbau Fertigung        | -4       | 0       | 9    |
      | EINKAUF-1 |      | -6   | Rückbau Fertigung        | -6       | 0       | 10   |
      | EINKAUF-2 |      | -2   | Rückbau Fertigung        | -2       | 0       | 11   |
      | EINKAUF-2 |      | -3   | Rückbau Fertigung        | -3       | 0       | 12   |
      | BAUGRUPPE | 3    |      | Rückmeldung Fertigung    | 0        | 3       | 13   |
      | EINKAUF-1 |      | 6    | Rückmeldung Fertigung    | 0        | 6       | 14   |
      | EINKAUF-2 |      | 3    | Rückmeldung Fertigung    | 0        | 3       | 15   |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 8
    And I close the current editor

# Offene Mengen im FV prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "AS_BA_000"
    Then fields have values
      | mge     | 2 |
      | rgutmge | 8 |
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | elex       | gmge | limge |
      | EINKAUF-1  | 4    | 4     |
      | EINKAUF-2  | 2    | 2     |
      | A MONTAGE1 | 0.2  | 2     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

# Betriebsauftrag und Auftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AS_BA_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-18"


  Scenario: 15 Storno eines Rückbaus über eine Rückmeldung mit Einheiten
    Given I set the fake date to "3.2.95"
# Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "BG-EINHEITEN" on StorageLocation "F1" with document "SCEN15"
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "SCEN15"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "SCEN15"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITEN" and quantity "20"
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ebeleg | RückbauP19 |
      | ueb    | ja         |
      | fakt   | ja         |
    And I append rows
      | artikel    | mge |
      | GEBINDE    | 20  |
      | GEBINDEPFL | 2   |
      | EINKAUF-1  | 4   |
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben, Betriebsauftrag aufrufen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig |
      | BG-EINHEITEN | 4      | ja     |
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

# Rückmeldungen und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINHEIT_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    And I set the fake date to "4.2.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "EINHEIT_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-3" in row 1
    And I set field "erbtext1" to "1-Rückbau" in row 1
    And I save the current editor

# Storno des Rückbaus
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-30"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | zmge | amge | mei   | detursache               | rueckmge | restmge | rueckbew | storniert | !row |
      | BG-EINHEITEN | 3    |      | Stück | Storno-Rückbau Fertigung | 3        | 0       | nein     | nein      | 1    |
      | GEBINDE      |      | 3    | Stück | Storno-Rückbau Fertigung | 3        | 0       | nein     | nein      | 2    |
      | GEBINDEPFL   |      | 3    | Stück | Storno-Rückbau Fertigung | 3        | 0       | nein     | nein      | 3    |
      | EINKAUF-1    |      | 3    | Stück | Storno-Rückbau Fertigung | 3        | 0       | nein     | nein      | 4    |
      | BG-EINHEITEN | -3   |      | Stück | Rückbau Fertigung        | -3       | 0       | ja       | ja        | 5    |
      | GEBINDE      |      | -3   | Stück | Rückbau Fertigung        | -3       | 0       | ja       | ja        | 6    |
      | GEBINDEPFL   |      | -3   | Stück | Rückbau Fertigung        | -3       | 0       | ja       | ja        | 7    |
      | EINKAUF-1    |      | -3   | Stück | Rückbau Fertigung        | -3       | 0       | ja       | ja        | 8    |
      | BG-EINHEITEN | 3    |      | Stück | Rückmeldung Fertigung    | 0        | 3       | nein     | nein      | 9    |
      | GEBINDE      |      | 3    | Stück | Rückmeldung Fertigung    | 0        | 3       | nein     | nein      | 10   |
      | GEBINDEPFL   |      | 1.5  | Paar  | Rückmeldung Fertigung    | 0        | 3       | nein     | nein      | 11   |
      | EINKAUF-1    |      | 3    | Stück | Rückmeldung Fertigung    | 0        | 3       | nein     | nein      | 12   |
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
      | 0.5    | Paar | 1    |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINHEIT_001"
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
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | geinheit | kopfzugvorg^id   |
      | 4     |        |          | (0,0,0)          |
      |       | 3      | Stück    | !Rückmeldung1^id |
      |       | 1      | Stück    | !Rückmeldung2^id |
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


  Scenario: A01 Storno eines Teil-Rückbaus auf Arbeitsschein eines abgelegten FV nach retrograder Buchung über Rückmeldung
    Given I set the fake date to "5.2.95"
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

# Rückmeldung1 auf ersten Arbeitsgang, Rückbau auf abgelegten FV
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEILRUECKA_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=TEILRUECKA_;typ=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

# Storno des Rückbaus
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Belege prüfen Storno, Rückbau und Rückmeldung
    And I switch the current editor to editor "Storno1_Rückbau" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 0        | 3       | 3     | 7      | 10     |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
    And I close the current editor

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
      | BAUGRUPPE | 0        | 10      | 10    | 0      | 10     |
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
      | art       | detursache               | amge | zmge | rueckmge | restmge |
      | BAUGRUPPE | Storno-Rückbau Fertigung |      | 3    | 3        | 0       |
      | BAUGRUPPE | Rückbau Fertigung        |      | -3   | -3       | 0       |
      | BAUGRUPPE | Rückmeldung Fertigung    |      | 10   | 0        | 10      |
      | EINKAUF-1 | Rückmeldung Fertigung    | 20   |      | 0        | 20      |
      | EINKAUF-2 | Rückmeldung Fertigung    | 10   |      | 0        | 10      |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I close the current editor

# Nachfolger in Bewertung Rückmeldung ist entstanden
    Given I open an editor "Bewertung_Rückmeldung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=Baugruppe;detursache=Rückmeldung Fertigung;buart=Zugang;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "ppsrefid^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    Then field "nachfolger" is not empty
    Then field "tmge" has value "10" in row 1
    And I close the current editor

    And I open an editor "Neubewertung_Rückmeldung1" via ID from editor "Bewertung_Rückmeldung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "buart" has value "Neubewertung"
    Then field "nachfolger" is not empty
    And I close the current editor

    And I open an editor "Bewertung_Rückbau1" via ID from editor "Neubewertung_Rückmeldung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "ppsrefid^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    Then field "nachfolger" is not empty
    Then field "tmge" has value "7" in row 1
    And I close the current editor

    And I open an editor "Bewertung_Storno1" via ID from editor "Bewertung_Rückbau1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "vorgaenger^id" has value equal to field "id" from editor "Bewertung_Rückbau1"
    Then field "ppsrefid^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    Then field "detursache" has value "Storno-Rückbau Fertigung"
    Then field "tmge" has value "10" in row 1
    And I close the current editor

# Lieferschein zu Auftrag
    Given I deliver the SalesOrder "auftrag" with PackingSlip "LS-A01"


  Scenario: A02 Storno eines Gesamt-Rückbaus auf Arbeitsschein eines abgelegten FV nach retrograder Buchung über Rückmeldung
    Given I set the fake date to "6.2.95"
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
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

# Rückbau stornieren
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Belege prüfen
    And I switch the current editor to editor "Storno1_Rückbau" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 0        | 10      | 10    | 0      | 10     |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
    And I close the current editor

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
      | BAUGRUPPE | 0        | 10      | 10    | 0      | 10     |
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
      | art       | detursache               | amge | zmge | rueckmge | restmge |
      | BAUGRUPPE | Storno-Rückbau Fertigung |      | 10   | 10       | 0       |
      | BAUGRUPPE | Rückbau Fertigung        |      | -10  | -10      | 0       |
      | BAUGRUPPE | Rückmeldung Fertigung    |      | 10   | 0        | 10      |
      | EINKAUF-1 | Rückmeldung Fertigung    | 20   |      | 0        | 20      |
      | EINKAUF-2 | Rückmeldung Fertigung    | 10   |      | 0        | 10      |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I close the current editor

# Auftrag liefern
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A02"


  Scenario: A03 Storno eines Teil-Rückbaus auf Betriebsauftrag eines abgelegten FV nach retrograder Buchung über Betriebsauftrag
    Given I set the fake date to "7.2.95"
# Fertigungsvorschlag anlegen und freigeben
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

# Rückmeldung1 auf ersten Arbeitsgang und Rückbau1 zu abgelegten FV
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GESAMTRBA_000"
    And I set fields
      | sofort | ja          |
      | gut    | ja          |
      | mgr    | 112         |
      | bem    | Rückmeldung |
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=GESAMTRBA_000;bem=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

# Storno des Rückbaus
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Belege prüfen
    And I switch the current editor to editor "Storno1_Rückbau" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 0        | 3       | 3     | 7      | 10     |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
    And I close the current editor

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
      | BAUGRUPPE | 0        | 10      | 10    | 0      | 10     |
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
      | art       | detursache               | amge | zmge | rueckmge | restmge | !row |
      | BAUGRUPPE | Storno-Rückbau Fertigung |      | 3    | 3        | 0       | 1    |
      | BAUGRUPPE | Rückbau Fertigung        |      | -3   | -3       | 0       | 2    |
      | BAUGRUPPE | Preisbildung Fertigung   |      | 10   | 0        | 10      | 3    |
      | BAUGRUPPE | Rückmeldung Fertigung    |      | 10   | 0        | 10      | 4    |
      | EINKAUF-1 | Rückmeldung Fertigung    | 20   |      | 0        | 20      | 5    |
      | EINKAUF-2 | Rückmeldung Fertigung    | 10   |      | 0        | 10      | 6    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I close the current editor

# Nachfolger in Bewertung Rückmeldung ist entstanden
    Given I open an editor "Bewertung_Rückbau" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=Baugruppe;detursache=Rückbau Fertigung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "nachfolger" is not empty
    Then field "ppsrefid^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    Then field "tmge" has value "7" in row 1
    And I close the current editor

    And I open an editor "Bewertung_Storno" via ID from editor "Bewertung_Rückbau" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "vorgaenger^id" has value equal to field "id" from editor "Bewertung_Rückbau"
    Then field "detursache" has value "Storno-Rückbau Fertigung"
    Then field "ppsrefid^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    Then field "tmge" has value "10" in row 1
    And I close the current editor

# FV abschließen und Auftrag liefern
    Given I deliver the SalesOrder "auftrag" with PackingSlip "LS-A03"


  Scenario: A04 Storno eines Rückbaus auf abgelegten FV mit Gutmenge in Behältern
    Given I set the fake date to "8.2.95"
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

# Rückmeldung1 auf ersten Arbeitsgang und Rückbau1 zu abgelegten FV
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHRUECKA_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I set field "behaelter" to id from editor "ABLAGE_GUTMGE1"
    And I save the current editor

    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "behaelter" to id from editor "ABLAGE_GUTMGE1"
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

# Storno des Rückbaus
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Behälter prüfen
    And I switch the current editor to editor "ABLAGE_GUTMGE1" with command "VIEW"
    Then fields have values
      | behleer | nein |
      | platz   | F1   |
    Then the table has 1 rows
    Then field "mge" has value "5" in row 1
    And I close the current editor
    Then field "mge" from editor "ABLAGE_GUTMGE2" in row 1 has value "5"

# Auftrag liefern
    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
    And I set field "mge" to "10" in row 1
    And I press button "packvor"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | behaelter          |
      | 1    | 5      | !ABLAGE_GUTMGE1^id |
      | +2   | 5      | !ABLAGE_GUTMGE2^id |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I respond with answer "ja" to the dialog with id "151"
    And I respond with answer "ja" to the dialog with id "8076"
    And I save the current editor


  Scenario: A05 Storno eines Rückbaus auf abgelegten FV, der Gutmenge aus einem Behälter gebucht hat, Behälter hat negative Menge
    Given I set the fake date to "9.2.95"
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

# Rückmeldung1 auf ersten Arbeitsgang und Rückbau1 zu abgelegten FV
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALSCHERB_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I set field "behaelter" to id from editor "BEH_MIT_GUTMGE"
    And I save the current editor
    Then field "mge" from editor "BEH_MIT_GUTMGE" in row 1 has value "10"

    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "behaelter" to id from editor "BEH_OHNE_GUTMGE"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

# Storno des Rückbaus und Behälter prüfen
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Then Container from editor "BEH_OHNE_GUTMGE" is empty

# Auftrag liefern
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


  Scenario: A06 Storno eines Rückbaus auf abgelegten FV, dessen Menge zwei Belege betrifft
    Given I set the fake date to "10.2.95"
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

# Rückmeldung1 und Rückmeldung2 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEIRUECKM_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor
    And I set the fake date to "11.2.95"
    And I wait 1 time units to move the time forward
# 1 = "04.02.1995"

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEIRUECKM_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I set field "erbtext1" to "Rückmeldung2" in row 1
    And I save the current editor

# Rückbau1 zu abgelegten FV betrifft beide Rückmeldebelege
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-7" in row 1
    And I set field "erbtext1" to "T-Rückbau1" in row 1
    And I save the current editor

# Storno des Rückbaus
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | detursache               | amge | zmge | rueckmge | restmge | !row |
      | BAUGRUPPE | Storno-Rückbau Fertigung |      | 2    | 2        | 0       | 1    |
      | BAUGRUPPE | Storno-Rückbau Fertigung |      | 5    | 5        | 0       | 2    |
      | BAUGRUPPE | Rückbau Fertigung        |      | -5   | -5       | 0       | 3    |
      | BAUGRUPPE | Rückbau Fertigung        |      | -2   | -2       | 0       | 4    |
      | BAUGRUPPE | Rückmeldung Fertigung    |      | 5    | 0        | 5       | 5    |
      | EINKAUF-1 | Rückmeldung Fertigung    | 10   |      | 0        | 10      | 6    |
      | EINKAUF-2 | Rückmeldung Fertigung    | 5    |      | 0        | 5       | 7    |
      | BAUGRUPPE | Rückmeldung Fertigung    |      | 5    | 0        | 5       | 8    |
      | EINKAUF-1 | Rückmeldung Fertigung    | 10   |      | 0        | 10      | 9    |
      | EINKAUF-2 | Rückmeldung Fertigung    | 5    |      | 0        | 5       | 10   |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 3
    And I close the current editor

# Belege prüfen: Storno, Rückbau1, Rückmeldung1 und 2
    And I switch the current editor to editor "Storno1_Rückbau" with command "VIEW"
    Then  table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 0        | 7       | 7     | 3      | 10     |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
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
      | BAUGRUPPE | 0        | 5       | 5     | 5      | 10     |
      | EINKAUF-2 | 0        | 5       | 5     | 5      | 0      |
      | EINKAUF-1 | 0        | 10      | 10    | 10     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then  table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 0        | 5       | 5     | 0      | 5      |
      | EINKAUF-2 | 0        | 5       | 5     | 10     | 5      |
      | EINKAUF-1 | 0        | 10      | 10    | 20     | 10     |
    And I close the current editor

# Auftrag liefern
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A07"


  Scenario: A07 Storno eines Rückbaus auf abgelegte FV mit Gutmenge mit Charge
    Given I set the fake date to "12.2.95"
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

# Rückmeldung1 auf ersten Arbeitsgang und Rückbau auf abgelegten FV
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGENABL_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-5" in row 1
    And I set field "charge" to "CH_BG1" in row 1
    And I save the current editor

    Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-2" in row 1
    And I set field "charge" to "CH_BG2" in row 1
    And I save the current editor

# Storno des Rückbaus
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | detursache               | amge | zmge | rueckmge | restmge | ncharge^such | vcharge^such | !row |
      | BAUGRUPPE | Storno-Rückbau Fertigung |      | 5    | 5        | 0       | CH_BG1       |              | 1    |
      | BAUGRUPPE | Rückbau Fertigung        |      | -2   | -2       | 0       | CH_BG2       |              | 2    |
      | BAUGRUPPE | Rückbau Fertigung        |      | -5   | -5       | 0       | CH_BG1       |              | 3    |
      | BAUGRUPPE | Rückmeldung Fertigung    |      | 5    | 2        | 3       | CH_BG2       |              | 4    |
      | BAUGRUPPE | Rückmeldung Fertigung    |      | 5    | 0        | 5       | CH_BG1       |              | 5    |
      | EINKAUF-1 | Rückmeldung Fertigung    | 10   |      | 0        | 10      | CH_BG2       |              | 6    |
      | EINKAUF-1 | Rückmeldung Fertigung    | 10   |      | 0        | 10      | CH_BG1       |              | 7    |
      | EINKAUF-2 | Rückmeldung Fertigung    |  5   |      | 0        | 5       | CH_BG2       |              | 8    |
      | EINKAUF-2 | Rückmeldung Fertigung    |  5   |      | 0        | 5       | CH_BG1       |              | 9    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    And I close the current editor

# Rückmeldung und Rückgabebeleg prüfen
    Given I switch the current editor to editor "Storno1_Rückbau" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 0        | 5       | 5     | 3      | 8      |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
    And I close the current editor

    Given I switch the current editor to editor "Rückbau1" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | -5       | 0       | -5    | 10     | 5      |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 2        | 8       | 10    | 0      | 10     |
      | EINKAUF-2 | 0        | 10      | 10    | 10     | 0      |
      | EINKAUF-1 | 0        | 20      | 20    | 20     | 0      |
    And I close the current editor

# Auftrag liefern
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A08"


  Scenario: A08 Storno eines Rückbaus auf abgelegte FV mit Charge, dessen Menge zwei Rückmeldungen betrifft
    Given I set the fake date to "13.2.95"
# Chargen anlegen
    Given I create a Lot "CH_BG1-08" for Product "BAUGRUPPE"
    Given I create a Lot "CH_BG2-08" for Product "BAUGRUPPE"
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

# Rückmeldung1 und Rückmeldung2 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEICHARGE_001"
    And I set fields
      | sofort  | ja              |
      | kcharge | !CH_BG1-08^id   |
      | bem     | Rückmeldung1    |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    And I set the fake date to "14.2.95"
    And I wait 1 time units to move the time forward
# 1 = "04.02.1995"

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEICHARGE_001"
    And I set fields
      | sofort  | ja              |
      | kcharge | !CH_BG2-08^id   |
      | bem     | Rückmeldung2    |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    And I set the fake date to "15.2.95"
    And I wait 1 time units to move the time forward

# Rückbau1 und Rückbau2 zu abgelegten FV ohne Chargenangabe
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | gutmge | charge        | erbtext1   | !row |
      | -2     | !CH_BG2-08^id | S-Rückbau1 | 1    |
    And I save the current editor
    And I set the fake date to "16.2.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückbau2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | gutmge | charge        | erbtext1   | !row |
      | -5     | !CH_BG1-08^id | S-Rückbau2 | 1    |
    And I save the current editor
    And I set the fake date to "17.2.95"
    And I wait 1 time units to move the time forward

# Storno Rückbau2
    Given I open an editor "Storno1_Rückbau2" via ID from editor "Rückbau2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Belege prüfen: Storno, Rückbau, Rückmeldungen
    And I switch the current editor to editor "Storno1_Rückbau2" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 0        | 5       | 5     | 3      | 8      |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückbau2" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | -5       | 0       | -5    | 8      | 3      |
      | EINKAUF-1 | 0        | 0       | 0     | 20     | 20     |
      | EINKAUF-2 | 0        | 0       | 0     | 10     | 10     |
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

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel   | rueckmge | restmge | bumge | limgev | limgen |
      | BAUGRUPPE | 0        | 5       | 5     | 0      | 5      |
      | EINKAUF-2 | 0        | 5       | 5     | 10     | 5      |
      | EINKAUF-1 | 0        | 10      | 10    | 20     | 10     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | detursache               | amge | zmge | rueckmge | restmge | ncharge^such | !row |
      | BAUGRUPPE | Storno-Rückbau Fertigung |      | 5    | 5        | 0       | CH_BG1-08    | 1    |
      | BAUGRUPPE | Rückbau Fertigung        |      | -5   | -5       | 0       | CH_BG1-08    | 2    |
      | BAUGRUPPE | Rückbau Fertigung        |      | -2   | -2       | 0       | CH_BG2-08    | 3    |
      | BAUGRUPPE | Rückmeldung Fertigung    |      | 5    | 2        | 3       | CH_BG2-08    | 4    |
      | EINKAUF-1 | Rückmeldung Fertigung    | 10   |      | 0        | 10      | CH_BG2-08    | 5    |
      | EINKAUF-2 | Rückmeldung Fertigung    | 5    |      | 0        | 5       | CH_BG2-08    | 6    |
      | BAUGRUPPE | Rückmeldung Fertigung    |      | 5    | 0        | 5       | CH_BG1-08    | 7    |
      | EINKAUF-1 | Rückmeldung Fertigung    | 10   |      | 0        | 10      | CH_BG1-08    | 8    |
      | EINKAUF-2 | Rückmeldung Fertigung    | 5    |      | 0        | 5       | CH_BG1-08    | 9    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I close the current editor

# FV abschließen und Auftrag liefern
    Given I open an editor "Storno1_Rückbau1" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "10" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | zuomge | charge        | !row |
      | 5      | !CH_BG1-08^id | 1    |
      | 5      | !CH_BG2-08^id | +2   |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor


  Scenario: A09 Storno eines Rückbaus auf abgelgten FV mit Gutmenge mit Chargen in verschiedenen Behältern
    Given I set the fake date to "18.2.95"
# Charge anlegen
    Given I create a Lot "CH_BEH1" for Product "BG-BEHAELTER"
    Given I create a Lot "CH_BEH2" for Product "BG-BEHAELTER"

# Bestand auf 0 korrigieren, Behälter anlegen
    Given I set StorageQuantity to zero for Product "BG-BEHAELTER" on StorageLocation "F1" with document "SCEN_A09"
    Given I create a Container "BEHAELTER1" for packaging material "BEHAELTER"
    Given I create a Container "BEHAELTER2" for packaging material "BEHAELTER"

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

# Storno der Rückbauten und Behälter prüfen
    Given I open an editor "Storno1_Rückbau2" via ID from editor "Rückbau2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    And I switch the current editor to editor "BEHAELTER2"
    Then field "mge" has value "2" in row 1
    Then field "charge^such" has value "CH_BEH2" in row 1
    And I close the current editor

    Given I open an editor "Storno2_Rückbau3" via ID from editor "Rückbau3" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    And I switch the current editor to editor "BEHAELTER2"
    Then field "mge" has value "5" in row 1
    Then field "charge^such" has value "CH_BEH2" in row 1
    And I close the current editor
    And I switch the current editor to editor "BEHAELTER1"
    Then field "mge" has value "2" in row 1
    Then field "charge^such" has value "CH_BEH1" in row 1
    And I close the current editor

    Given I open an editor "Storno3_Rückbau1" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    And I switch the current editor to editor "BEHAELTER1"
    Then field "mge" has value "5" in row 1
    Then field "charge^such" has value "CH_BEH1" in row 1
    And I close the current editor

# Bestand prüfen
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

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | detursache               | amge | zmge | rueckmge | restmge | vcharge^such | ncharge^such | behaelter^id   | !row |
      | BG-BEHAELTER | Storno-Rückbau Fertigung |      | 3    | 3        | 0       |              | CH_BEH1      | !BEHAELTER1^id | 1    |
      | BG-BEHAELTER | Storno-Rückbau Fertigung |      | 3    | 3        | 0       |              | CH_BEH2      | !BEHAELTER2^id | 2    |
      | BG-BEHAELTER | Storno-Rückbau Fertigung |      | 2    | 2        | 0       |              | CH_BEH2      | !BEHAELTER2^id | 3    |
      | BG-BEHAELTER | Rückbau Fertigung        |      | -3   | -3       | 0       |              | CH_BEH2      | !BEHAELTER2^id | 4    |
      | BG-BEHAELTER | Rückbau Fertigung        |      | -2   | -2       | 0       |              | CH_BEH2      | !BEHAELTER2^id | 5    |
      | BG-BEHAELTER | Rückbau Fertigung        |      | -3   | -3       | 0       |              | CH_BEH1      | !BEHAELTER1^id | 6    |
      | BG-BEHAELTER | Rückmeldung Fertigung    |      | 5    | 0        | 5       |              | CH_BEH2      | !BEHAELTER2^id | 7    |
      | BG-BEHAELTER | Rückmeldung Fertigung    |      | 5    | 0        | 5       |              | CH_BEH1      | !BEHAELTER1^id | 8    |
      | EINKAUF-1    | Rückmeldung Fertigung    | 10   |      | 0        | 10      |              | CH_BEH2      | !dontChange    | 9    |
      | EINKAUF-1    | Rückmeldung Fertigung    | 10   |      | 0        | 10      |              | CH_BEH1      | !dontChange    | 10   |
      | EINKAUF-2    | Rückmeldung Fertigung    | 5    |      | 0        | 5       |              | CH_BEH2      | !dontChange    | 11   |
      | EINKAUF-2    | Rückmeldung Fertigung    | 5    |      | 0        | 5       |              | CH_BEH1      | !dontChange    | 12   |
    And I close the current editor

# Auftrag liefern
    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "10" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | zuomge | charge      | behaelter      | !row |
      | 5      | !CH_BEH1^id | !BEHAELTER1^id | 1    |
      | 5      | !CH_BEH2^id | !BEHAELTER2^id | +2   |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor


  Scenario: A10 Storno eines Rückbaus über zwei Rückmeldungen mit Einheiten
    Given I set the fake date to "19.2.95"
# Bestandskorrektur auf 0
    And I set the fake date to "20.2.95"
    Given I set StorageQuantity to zero for Product "BG-EINHEITEN" on StorageLocation "F1" with document "SCEN_A10"
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "SCEN_A10"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "SCEN_A10"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN_A10"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITEN" and quantity "40"
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

# Rückmeldungen auf ersten Arbeitsgang und Rückbau
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINHEITA_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    And I set the fake date to "21.2.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINHEITA_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    And I set the fake date to "22.2.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINHEITA_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | gutmge      | mge         | bueinh      | erbtext1   | !row                    |
      | -5          | !dontChange | !dontChange | A-Rückbau1 | artikel=="BG-EINHEITEN" |
      | !dontChange | -1          | kg          | A-Rückbau1 | artikel=="GEBINDE"      |
      | !dontChange | -1          | Paar        | A-Rückbau1 | artikel=="GEBINDEPFL"   |
      | !dontChange | -1          | !dontChange | A-Rückbau1 | artikel=="EINKAUF-1"    |
    And I save the current editor

# Storno des Rückbaus
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then table has values
      | artikel      | bumge | mge | bueinh | chentmge | rueckmge | restmge | limgen | limgev |
      | BG-EINHEITEN | 5     | 0   | Stück  | 0        | 0        | 5       | 8      | 3      |
      | GEBINDE      | 1     | 0.2 | kg     | 0        | 0        | 0.2     | 8      | 7.8    |
      | GEBINDEPFL   | 1     | 2   | Paar   | 0        | 0        | 2       | 8      | 6      |
      | EINKAUF-1    | 1     | 1   | Stück  | 0        | 0        | 1       | 8      | 7      |
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | zmge | amge | mei   | detursache               | rueckmge | restmge | !row |
      | BG-EINHEITEN | 3    |      | Stück | Storno-Rückbau Fertigung | 3        | 0       | 1    |
      | BG-EINHEITEN | 2    |      | Stück | Storno-Rückbau Fertigung | 2        | 0       | 2    |
      | GEBINDE      |      | 0.2  | Stück | Storno-Rückbau Fertigung | 0.2      | 0       | 3    |
      | GEBINDEPFL   |      | 1    | Paar  | Storno-Rückbau Fertigung | 2        | 0       | 4    |
      | EINKAUF-1    |      | 1    | Stück | Storno-Rückbau Fertigung | 1        | 0       | 5    |
      | BG-EINHEITEN | -2   |      | Stück | Rückbau Fertigung        | -2       | 0       | 6    |
      | BG-EINHEITEN | -3   |      | Stück | Rückbau Fertigung        | -3       | 0       | 7    |
      | GEBINDE      |      | -0.2 | Stück | Rückbau Fertigung        | -0.2     | 0       | 8    |
      | GEBINDEPFL   |      | -1   | Paar  | Rückbau Fertigung        | -2       | 0       | 9    |
      | EINKAUF-1    |      | -1   | Stück | Rückbau Fertigung        | -1       | 0       | 10   |
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
      | gebmge | geinheit | lemge | leinheit | kopfzugvorg^id   |
      |        |          | 8     | Stück    | (0,0,0)          |
      | 3      | Stück    |       |          | !Rückmeldung1^id |
      | 2      | Stück    |       |          | !Rückmeldung3^id |
      | 3      | Stück    |       |          | !Rückmeldung2^id |


    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | verdichten | nein    |
      | nullmge    | nein    |
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


  Scenario: A11 Storno eines Rückbaus, der gebucht wurde, als der FV noch lebendig war
    Given I set the fake date to "23.2.95"
# Bestandskorrektur auf 0 BAUGRUPPE
    And I set the fake date to "24.2.95"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN-A11"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN-A11"

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
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch        | mfreig |
      | BAUGRUPPE | 10     | ABLAGESTORNO_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang und Bewertung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABLAGESTORNO_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Bewertung_Rückmeldung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Rückbau auf ersten Arbeitsschein und Bewertung
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ABLAGESTORNO_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-2" in row 1
    And I set field "erbtext1" to "Rückbau1" in row 1
    And I save the current editor

    Given I open an editor "Bewertung_Rückbau" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückbau Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Rückmeldung2, Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABLAGESTORNO_001"
    And I set field "sofort" to "ja"
    And I set field "mgereduzieren" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Storno Rückbau
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I set field "erbtext1" to "Storno-Rückbau1" in row 1
    And I save the current editor

# Bewertung erhält Nachfolger
    Given I switch the current editor to editor "Bewertung_Rückbau" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_Storno" via ID from editor "Bewertung_Rückbau" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "-10"
    And I set field "edatum" to "+30"
    And I set field "beleg" to "barmex" from editor "Rückbau1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache               | rueckmge | restmge | !row |
      | BAUGRUPPE | 2    |      | Storno-Rückbau Fertigung | 2        | 0       | 1    |
      | EINKAUF-1 |      | 4    | Storno-Rückbau Fertigung | 4        | 0       | 2    |
      | EINKAUF-2 |      | 2    | Storno-Rückbau Fertigung | 2        | 0       | 3    |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung    | 0        | 5       | 4    |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung    | 0        | 10      | 5    |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung    | 0        | 5       | 6    |
      | BAUGRUPPE | -2   |      | Rückbau Fertigung        | -2       | 0       | 7    |
      | EINKAUF-1 |      | -4   | Rückbau Fertigung        | -4       | 0       | 8    |
      | EINKAUF-2 |      | -2   | Rückbau Fertigung        | -2       | 0       | 9    |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung    | 0        | 5       | 10   |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung    | 0        | 10      | 11   |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung    | 0        | 5       | 12   |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 8
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 9
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
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 10    |        | (0,0,0)          |
      |       | 3      | !Rückmeldung1^id |
      |       | 5      | !Rückmeldung2^id |
      |       | 2      | !Rückmeldung1^id |
    And I set fields
      | artikel | EINKAUF-1 |
      | klplatz | F1        |
      | nullmge | nein      |
      | details | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Auftrag liefern
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-01"


  Scenario: C1 Vergleich Storno/Rückbau. Das Ergebnis muss das gleiche sein
    Given I set the fake date to "3.3.95"

# Fertigungsvorschlag für Rückbau anlegen und freigeben, Löschschutz setzen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch  | mfreig | binoloe |
      | BAUGRUPPE2 | 10     | RBSTRN_ | ja     | nein    |
      | BAUGRUPPE2 | 10     | STRNRB_ | ja     | nein    |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# FV RBSTRN_000 bebuchen
# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "RB-RMAG1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=RBSTRN_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "9" in row 1
    And I set field "verlust" to "1" in row 1
    And I save the current editor

# Rückmeldung auf zweiten Arbeitsgang
    Given I open an editor "RB-RMAG2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=RBSTRN_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "6" in row 1
    And I set field "verlust" to "3" in row 1
    And I save the current editor

# FV STRNRB_000 bebuchen
# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "STRN-RMAG1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=STRNRB_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "9" in row 1
    And I set field "verlust" to "1" in row 1
    And I save the current editor

# Rückmeldung auf zweiten Arbeitsgang
    Given I open an editor "STRN-RMAG2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=STRNRB_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "6" in row 1
    And I set field "verlust" to "3" in row 1
    And I save the current editor

# Rückbauen und stornieren - Ergebnisse vergleichen
# Rückbau auf zweiten Arbeitsgang
    Given I open an editor "RB-RBAG2" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=RBSTRN_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-6" in row 1
    And I set field "verlust" to "-3" in row 1
    And I save the current editor

# Storno auf zweiten Arbeitsgang
    Given I open an editor "STRN-STORNOAG2" via ID from editor "STRN-RMAG2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "BA-RB" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=RBSTRN_000;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | mge     | 10 |
      | rgutmge | 0  |
    And I press button "absteig" to open a subeditor for "AFL-RB"
    Then table has values
      | elex        | limge | frgmge |
      | EINKAUF-1   | 2     | 2      |
      | A SCHRAUBEN | 1     | 1      |
      | EINKAUF-2   | 10    | 10     |
      | A MONTAGE1  | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "BA-RB"
    And I save the current editor

    Given I open an editor "BA-STRN" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=STRNRB_000;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | mge     | 10 |
      | rgutmge | 0  |
    And I press button "absteig" to open a subeditor for "AFL-STRN"
    Then table has values
      | elex        | limge | frgmge |
      | EINKAUF-1   | 2     | 2      |
      | A SCHRAUBEN | 1     | 1      |
      | EINKAUF-2   | 10    | 10     |
      | A MONTAGE1  | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "BA-STRN"
    And I save the current editor

# Rückbau auf ersten Arbeitsgang
    Given I open an editor "RB-RBAG1" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=RBSTRN_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-9" in row 1
    And I set field "verlust" to "-1" in row 1
    And I save the current editor

# Storno auf ersten Arbeitsgang
    Given I open an editor "STRN-STORNOAG1" via ID from editor "STRN-RMAG1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "BA-RB" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=RBSTRN_000;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | mge     | 10 |
      | rgutmge | 0  |
    And I press button "absteig" to open a subeditor for "AFL-RB"
    Then table has values
      | elex        | limge | frgmge |
      | EINKAUF-1   | 20    | 20     |
      | A SCHRAUBEN | 10    | 10     |
      | EINKAUF-2   | 10    | 10     |
      | A MONTAGE1  | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "BA-RB"
    And I save the current editor

    Given I open an editor "BA-STRN" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=STRNRB_000;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | mge     | 10 |
      | rgutmge | 0  |
    And I press button "absteig" to open a subeditor for "AFL-STRN"
    Then table has values
      | elex        | limge | frgmge |
      | EINKAUF-1   | 20    | 20     |
      | A SCHRAUBEN | 10    | 10     |
      | EINKAUF-2   | 10    | 10     |
      | A MONTAGE1  | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "BA-STRN"
    And I save the current editor

# Aufräumen, d.h. BA rückmelden
    Given I open an editor "RB-RMBA" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=RBSTRN_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I save the current editor

    Given I open an editor "STRN-RMBA" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=STRNRB_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I save the current editor


  Scenario: C2 Vergleich Storno/Rückbau bei mehreren AG's für ein Material. Das Ergebnis muss das gleiche sein
    Given I set the fake date to "3.3.95"

# Baugruppe mit mehreren AG's für ein Material anlegen
    Given I open an editor "BGMULTIAG" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such     | BGMULTIAG       |
      | namebspr | BG multi AG     |
      | dispoa   | auftragsbezogen |
      | lief     | KETTLER         |
      | efrist   | 2               |
      | epr      | 2,2             |
    And I delete all rows
    And I append rows
      | elex           | anzahl |
      | EINKAUF-1      | 1      |
      | A SCHRAUBEN    | 1      |
      | A VORBEREITUNG | 1      |
      | A MONTAGE1     | 1      |
    And I save the current editor

# Fertigungsvorschlag für Rückbau und Storno anlegen und freigeben, Löschschutz setzen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig | binoloe |
      | BGMULTIAG | 10     | RBSTRN2_ | ja     | nein    |
      | BGMULTIAG | 10     | STRNRB2_ | ja     | nein    |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# FV RBSTRN2_002 bebuchen
# 1. Rückmeldung auf zweiten Arbeitsgang
    Given I open an editor "RB1-RMAG2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=RBSTRN2_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RM1_auf_AG2"
    And I set field "gutmge" to "4" in row 1
    And I set field "verlust" to "2" in row 1
    And I save the current editor

# 2. Rückmeldung auf zweiten Arbeitsgang
    Given I open an editor "RB2-RMAG2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=RBSTRN2_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RM2_auf_AG2"
    And I set field "gutmge" to "5" in row 1
    And I set field "verlust" to "3" in row 1
    And I save the current editor

# FV STRNRB2_002 bebuchen
# 1. Rückmeldung auf zweiten Arbeitsgang
    Given I open an editor "STRN-RMAG1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=STRNRB2_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RM1_auf_AG2"
    And I set field "gutmge" to "4" in row 1
    And I set field "verlust" to "2" in row 1
    And I save the current editor

# 2. Rückmeldung auf zweiten Arbeitsgang
    Given I open an editor "STRN-RMAG2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=STRNRB2_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RM2_auf_AG2"
    And I set field "gutmge" to "5" in row 1
    And I set field "verlust" to "3" in row 1
    And I save the current editor

# Rückbauen und stornieren - Ergebnisse vergleichen
# Rückbau auf zweiten Arbeitsgang
    Given I open an editor "RB2-RBAG2" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=RBSTRN2_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RM_RM1_auf_AG2"
    And I set field "gutmge" to "-4" in row 1
    And I set field "verlust" to "-2" in row 1
    And I save the current editor

# Storno auf zweiten Arbeitsgang
    Given I open an editor "STRN-STORNOAG2" via ID from editor "STRN-RMAG1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I set field "bem" to "STRN_RM1_auf_AG2"
    And I save the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "BA-RB" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=RBSTRN2_000;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | mge      | 10 |
      | rgutmge  | 0  |
      | rverlust | 0  |
    And I press button "absteig" to open a subeditor for "AFL-RB"
    Then table has values
      | elex           | limge | frgmge |
      | EINKAUF-1      | 5     | 5      |
      | A SCHRAUBEN    | 5     | 5      |
      | A VORBEREITUNG | 5     | 5      |
      | A MONTAGE1     | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "BA-RB"
    And I close the current editor

    Given I open an editor "BA-STRN" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=STRNRB2_000;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | mge      | 10 |
      | rgutmge  | 0  |
      | rverlust | 0  |
    And I press button "absteig" to open a subeditor for "AFL-STRN"
    Then table has values
      | elex           | limge | frgmge |
      | EINKAUF-1      | 5     | 5      |
      | A SCHRAUBEN    | 5     | 5      |
      | A VORBEREITUNG | 5     | 5      |
      | A MONTAGE1     | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "BA-STRN"
    And I save the current editor

# Aufräumen, d.h. BA rückmelden
    Given I open an editor "RB-RMBA" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=RBSTRN2_000;@richtung=rückwärts;@maxtreffer=1"
    And I set field "mgr" to "101"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I save the current editor

    Given I open an editor "STRN-RMBA" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=STRNRB2_000;@richtung=rückwärts;@maxtreffer=1"
    And I set field "mgr" to "101"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I save the current editor


  Scenario: C3 Vergleich Storno/Rückbau bei Anfahrmenge und Ausschuss auf Material. Das Ergebnis muss das gleiche sein
    Given I set the fake date to "4.3.95"

# Baugruppe mit mehreren AG's für ein Material anlegen
    Given I open an editor "BGEVERL" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such     | BGEVERL         |
      | namebspr | BG mit Verlust  |
      | dispoa   | auftragsbezogen |
    And I delete all rows
    And I append rows
      | elex           | anzahl | amge | pverlust | kompeig       |
      | EINKAUF-1      | 1      | 1    | 15       | !dontChange   |
      | A SCHRAUBEN    | 1      |      |          | !dontChange   |
      | EINKAUF-2      | 2      | 2    | 10       | !dontChange   |
      | KOPPELPROD     | 1      |      |          | Koppelprodukt |
      | A VORBEREITUNG | 1      |      |          | !dontChange   |
      | A BOHR         | 1      |      |          | !dontChange   |
      | EINKAUF-3      | 3      | 3    | 5        | !dontChange   |
      | A MONTAGE1     | 1      |      |          | !dontChange   |
    And I save the current editor

# Fertigungsvorschlag für Rückbau und Storno anlegen und freigeben, Löschschutz setzen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch   | mfreig | binoloe |
      | BGEVERL | 10     | RBSTRN3_ | ja     | nein    |
      | BGEVERL | 10     | STRNRB3_ | ja     | nein    |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# FV RBSTRN3_001 .. RBSTRN3_004 bebuchen
    Given I open an editor "RBSTRN3_RM1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=RBSTRN3_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RM1_auf_AG1"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

    Given I open an editor "RBSTRN3_RM2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=RBSTRN3_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RM2_auf_AG2"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor

    Given I open an editor "RBSTRN3_RM3" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=RBSTRN3_003;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RM3_auf_AG3"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

    Given I open an editor "RBSTRN3_RM4" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=RBSTRN3_004;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RM4_auf_AG4"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor


# FV STRNRB3_001 .. STRNRB3_004 bebuchen
    Given I open an editor "STRNRB3_RM1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=STRNRB3_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RM1_auf_AG1"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

    Given I open an editor "STRNRB3_RM2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=STRNRB3_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RM2_auf_AG2"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor

    Given I open an editor "STRNRB3_RM3" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=STRNRB3_003;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RM3_auf_AG3"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

    Given I open an editor "STRNRB3_RM4" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=STRNRB3_004;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RM4_auf_AG4"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor


# Rückbauen und stornieren - Ergebnisse vergleichen
# Alle Rückmeldungen auf RBSTRN3_ rückbauen
    Given I open an editor "RBSTRN3_RB4" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=RBSTRN3_004;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RB4_auf_AG4"
    And I set field "gutmge" to "-4" in row 1
    And I save the current editor

    Given I open an editor "RBSTRN3_RB3" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=RBSTRN3_003;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RB3_auf_AG3"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

    Given I open an editor "RBSTRN3_RB2" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=RBSTRN3_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RB2_auf_AG2"
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor

    Given I open an editor "RBSTRN3_RB1" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=RBSTRN3_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "bem" to "RB1_auf_AG1"
    And I set field "gutmge" to "-1" in row 1
    And I save the current editor


# Alle Rückmeldungen auf STRNRB3_ stornieren
    Given I open an editor "STRNRB3_STRN4" via ID from editor "STRNRB3_RM4" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I set field "bem" to "STRN1_auf_AG4"
    And I save the current editor

    Given I open an editor "STRNRB3_STRN3" via ID from editor "STRNRB3_RM3" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I set field "bem" to "STRN1_auf_AG3"
    And I save the current editor

    Given I open an editor "STRNRB3_STRN2" via ID from editor "STRNRB3_RM2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I set field "bem" to "STRN1_auf_AG2"
    And I save the current editor

    Given I open an editor "STRNRB3_STRN1" via ID from editor "STRNRB3_RM1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I set field "bem" to "STRN1_auf_AG1"
    And I save the current editor


# Offene Mengen Material und Arbeitsgänge prüfen (an einigen Stellen gibt es Rundungsdifferenzen)
# Rückbau prüfen
    Given I open an editor "BA-RB" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=RBSTRN3_000;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | mge      | 10 |
      | rgutmge  | 0  |
      | rverlust | 0  |
    And I press button "absteig" to open a subeditor for "AFL-RB"
    Then table has values
      | elex           | mge    | limge  | frgmge | amge | pverlust |
      | EINKAUF-1      | 12.941 | 12.94  | 12.94  | 1    | 15       |
      | A SCHRAUBEN    | 10     | 10     | 10     | 0    | 0        |
      | EINKAUF-2      | 24.444 | 24.444 | 24.444 | 2    | 10       |
      | KOPPELPROD     | 10     | 10     | 10     | 0    | 0        |
      | A VORBEREITUNG | 10     | 10     | 10     | 0    | 0        |
      | A BOHR         | 10     | 10     | 10     | 0    | 0        |
      | EINKAUF-3      | 34.737 | 34.737 | 34.737 | 3    | 5        |
      | A MONTAGE1     | 10     | 10     | 10     | 0    | 0        |
    And I close the current editor
    And I switch the current editor to editor "BA-RB"
    And I close the current editor

# Storno prüfen
    Given I open an editor "BA-STRN" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=STRNRB3_000;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | mge      | 10 |
      | rgutmge  | 0  |
      | rverlust | 0  |
    And I press button "absteig" to open a subeditor for "AFL-STRN"
    Then table has values
      | elex           | mge    | limge  | frgmge | amge | pverlust |
      | EINKAUF-1      | 12.941 | 12.94  | 12.94  | 1    | 15       |
      | A SCHRAUBEN    | 10     | 10     | 10     | 0    | 0        |
      | EINKAUF-2      | 24.444 | 24.443 | 24.443 | 2    | 10       |
      | KOPPELPROD     | 10     | 10     | 10     | 0    | 0        |
      | A VORBEREITUNG | 10     | 10     | 10     | 0    | 0        |
      | A BOHR         | 10     | 10     | 10     | 0    | 0        |
      | EINKAUF-3      | 34.737 | 34.737 | 34.737 | 3    | 5        |
      | A MONTAGE1     | 10     | 10     | 10     | 0    | 0        |
    And I close the current editor
    And I switch the current editor to editor "BA-STRN"
    And I save the current editor

# Aufräumen, d.h. BA rückmelden
    Given I open an editor "RB-RMBA" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=RBSTRN3_000;@richtung=rückwärts;@maxtreffer=1"
    And I set field "mgr" to "101"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I save the current editor

    Given I open an editor "STRN-RMBA" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=STRNRB3_000;@richtung=rückwärts;@maxtreffer=1"
    And I set field "mgr" to "101"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I save the current editor
