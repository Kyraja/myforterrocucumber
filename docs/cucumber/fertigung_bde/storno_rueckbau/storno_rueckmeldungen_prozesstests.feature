@persistent
Feature: storno_rueckmeldungen_prozesstests.feature

  Background:
    And I enable the flag 42
    And I set the fake date to "5.1.95"
# fake dates können mit std/test/fake_date_subst_in_cucumber.pl gepflegt werden. anleitung s. dort

# *****************************************************************************
#  Name             : storno_rueckmeldungen_prozesstests
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet die Prozesse beim Storno von Rückmeldungen
#  Jira-Issue       : FDA-544
# *****************************************************************************

## Rückmeldungen eines lebendigen Betriebsauftrags


  Scenario: 01 Storno einer Rückmeldung über die gesamte Gutemenge, Teile retrograd entnommen
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch | mfreig | binoloe |
      | BAUGRUPPE2 | 10     | RETRO_ | ja     | ja      |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag zeigen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RETRO_000"
    And I close the current editor

# Auftragsvorkalkulation Fertigungskosten prüfen
    Given I open an editor "Vorkalk" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE2;typ=Auftragsvorkalkulation;@richtung=rückwärts;@maxtreffer=1"
    Then field "varfek" has value "13.1667"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RETRO_001"
    And I set fields
      | sofort | 1   |
      | bzeit  | 1,5 |
      | mzeit  | 1,5 |
      | gut    | 1   |
    And I save the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE2;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Betriebsauftrag nachkalkulieren
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "banummer" to "!Betriebsauftrag^nummer"
    And I press button "ladetab"
    And I press button "bunkalk" to open a subeditor for "Nachkalkulieren" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Nachkalkulaiton prüfen, FK var sind höher durch höhere Zeitangabe in Rückmeldung
    Given I open an editor "Nachkalk1" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE2;typ=Nachkalkulation;herkunft^ablagef=nein;@richtung=rückwärts;@maxtreffer=1"
    Then field "varfek" has value "13.4167"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE2 |
      | klplatz    | F1         |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Betriebsauftrag nachkalkulieren
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "banummer" to "!Betriebsauftrag^nummer"
    And I press button "ladetab"
    And I press button "bunkalk" to open a subeditor for "Nachkalkulieren" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Nachkalkulaiton prüfen, FK var müssen nach Storno wieder auf dem Wert der Auftragsvorkalkulation sein
    And I switch the current editor to editor "Nachkalk1" with command "VIEW"
    Then field "varfek" has value "13.1667"
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert |
      | EINKAUF-1 |      | -20  | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-1 |      | 20   | Rückmeldung Fertigung        | ja        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "RETRO_000"
    Then fields have values
      | mge     | 10 |
      | rgutmge | 0  |
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | limge | gmge |
      | 20    | 20   |
      | 10    | 1.75 |
      | 10    | 10   |
      | 10    | 1.25 |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I set field "noloesch" to "nein"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 02 Storno einer Teil-Rückmeldung, Teile retrograd entnommen
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-02"
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch     | mfreig |
      | BAUGRUPPE | 10     | TEILRETRO_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsuaftrag öffnen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "TEILRETRO_000"
    And I close the current editor

# Auftragsvorkalkulation Fertigungskosten prüfen
    Given I open an editor "Vorkalk" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;typ=Auftragsvorkalkulation;@richtung=rückwärts;@maxtreffer=1"
    Then field "varfek" has value "5.8750"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I set the fake date to "5.1.95"
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEILRETRO_001"
    And I set field "sofort" to "1"
    And I set field "bzeit" to "1"
    And I set field "mzeit" to "1"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

# Nachkalkulation starten
    And I run Revaluation

# Nachkalkulaiton prüfen, FK var sind höher durch höhere Zeitangabe in Rückmeldung
    Given I open an editor "Nachkalk1" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;typ=Nachkalkulation;herkunft^ablagef=nein;@richtung=rückwärts;@maxtreffer=1"
    Then field "varfek" has value "6.1750"
    And I close the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
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

# Betriebsauftrag nachkalkulieren
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "banummer" to "!Betriebsauftrag^nummer"
    And I press button "ladetab"
    And I press button "bunkalk" to open a subeditor for "Nachkalkulieren" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Nachkalkulaiton prüfen, FK var müssen nach Storno wieder auf dem Wert der Auftragsvorkalkulation sein
    And I switch the current editor to editor "Nachkalk1" with command "VIEW"
    Then field "varfek" has value "5.8750"
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert |
      | BAUGRUPPE | -1   |      | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-1 |      | -2   | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-2 |      | -1   | Storno-Rückmeldung Fertigung | nein      |
      | BAUGRUPPE | 1    |      | Rückmeldung Fertigung        | ja        |
      | EINKAUF-1 |      | 2    | Rückmeldung Fertigung        | ja        |
      | EINKAUF-2 |      | 1    | Rückmeldung Fertigung        | ja        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "TEILRETRO_000"
    Then field "mge" has value "10"
    Then field "rgutmge" has value "0"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "20" in row 1
    Then field "limge" has value "10" in row 2
    Then field "gmge" has value "1.25" in row 3
    Then field "limge" has value "10" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 03 Storno einer Rückmeldung über die gesamte Gutmenge, Teile manuell entnommen
# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "M_BAUGRUPPE" on StorageLocation "F1" with document "B_03"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch | binoloe |
      | M_BAUGRUPPE | 10     | ja     | MANBU_ | ja      |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag aufrufen für BA-Nummer
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MANBU_000"
    And I close the current editor

# Materialentnahme für Betriebsauftrag
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "nummer" from editor "Betriebsauftrag"
    And I press button "stllad"
    And I set field "mgr" to "112"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANBU_001"
    And I set field "gut" to "1"
    And I set field "bzeit" to "1,5"
    And I set field "mzeit" to "1,5"
    And I set field "sofort" to "1"
    And I save the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=M_BAUGRUPPE;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | M_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | ja          |
      | details    | nein        |
    And I press start
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | detursache                   | storniert |
      | M_BAUGRUPPE | -10  |      | Storno-Rückmeldung Fertigung | nein      |
      | M_BAUGRUPPE | 10   |      | Rückmeldung Fertigung        | ja        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MANBU_000"
    Then field "mge" has value "10"
    Then field "rgutmge" has value "0"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "0" in row 1
    Then field "limge" has value "0" in row 2
    Then field "gmge" has value "1.25" in row 3
    Then field "limge" has value "10" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I set field "noloesch" to "nein"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 04 Storno einer Teil-Rückmeldung, Teile manuell entnommen
# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "M_BAUGRUPPE" on StorageLocation "F1" with document "B_04"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch     |
      | M_BAUGRUPPE | 10     | ja     | TEILMANBU_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag aufrufen für BA-Nummer
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "TEILMANBU_000"
    Then field "nummer" is not empty
    And I close the current editor

# Materialentnahme für Betriebsauftrag
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "nummer" from editor "Betriebsauftrag"
    And I set field "manent" to "ja"
    And I press button "stllad"
    And I set field "mgr" to "112"
    And I set field "bumge" to "10" in row 1
    And I set field "bumge" to "5" in row 2
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEILMANBU_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=M_BAUGRUPPE;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | M_BAUGRUPPE |
      | klplatz    | F1          |
      | verdichten | ja          |
      | details    | nein        |
    And I press start
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | detursache                   | storniert |
      | M_BAUGRUPPE | -5   |      | Storno-Rückmeldung Fertigung | nein      |
      | M_BAUGRUPPE | 5    |      | Rückmeldung Fertigung        | ja        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    And I switch the current editor to editor "Betriebsauftrag" with command "UPDATE"
    Then field "mge" has value "10"
    Then field "rgutmge" has value "0"
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | limge | gmge |
      | 10    | 10   |
      | 5     | 5    |
      | 10    | 1.25 |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 05 Storno einer Rückmeldung mit Zeitmeldung und ohne Gutmenge
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch   | mfreig |
      | BAUGRUPPE2 | 10     | NURZEIT_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Zeit-Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NURZEIT_001"
    And I set field "mzeit" to "1.75"
    And I set field "bzeit" to "1.75"
    And I set field "sofort" to "1"
    And I save the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE2;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Zeitangaben auf Arbeitsgang = 0 in Prodlist prüfen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "$,,such=NURZEIT_000;@richtung=rückwärts;@maxtreffer=1"
    And I set field "detail" to "ja"
    And I press start
#Then field "vzeit" is empty in row 3
    Then field "bzeit" has value "1.75" in row 3
    Then field "mzeit" has value "1.75" in row 3
    And I close the current editor

# Zeit-Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then the table has 1 rows
    Then field "gutmge" has value "0" in row 1
    Then field "mzeit" has value "-1.75"
    Then field "bzeit" has value "-1.75"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Zeitangaben auf Arbeitsgang in Prodlist prüfen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "$,,such=NURZEIT_000;@richtung=rückwärts;@maxtreffer=1"
    And I set field "detail" to "ja"
    And I press start
    Then field "vzeit" has value "1.75" in row 3
    Then field "bzeit" has value "0" in row 3
    Then field "mzeit" has value "0" in row 3
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "NURZEIT_000"
    And I set field "noloesch" to "nein"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 06 Storno einer Rückmeldung mit Zeitmeldung und gesamter Gutmenge
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch   | mfreig | binoloe |
      | BAUGRUPPE2 | 10     | ZEITMGE_ | ja     | ja      |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE2 |
      | klplatz    | F1         |
      | verdichten | ja         |
      | nullmge    | ja         |
      | details    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Zeit-Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZEITMGE_001"
    And I set field "gut" to "ja"
    And I set field "mzeit" in row 0 to "vzeit" from editor "Rückmeldung1" in row 0
    And I set field "bzeit" in row 0 to "vzeit" from editor "Rückmeldung1" in row 0
    And I set field "sofort" to "1"
    And I save the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE2;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Zeit- und Mengenangaben auf Arbeitsgang = 0 in Prodlist prüfen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "$,,such=ZEITMGE_000;@richtung=rückwärts;@maxtreffer=1"
    And I set field "detail" to "ja"
    And I press start
    Then field "vzeit" is empty in row 3
    Then field "bzeit" has value "1.75" in row 3
    Then field "mzeit" has value "1.75" in row 3
    Then field "ofmge" has value "0" in row 2
    And I close the current editor

# Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "mzeit" has value "-1.75"
    Then field "bzeit" has value "-1.75"
    Then field "gutmge" has value "-10" in row 1
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE2 |
      | klplatz    | F1         |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Zeit- und Mengenangaben auf Arbeitsgang in Prodlist prüfen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "$,,such=ZEITMGE_000;@richtung=rückwärts;@maxtreffer=1"
    And I set field "detail" to "ja"
    And I press start
    Then field "vzeit" has value "1.75" in row 3
    Then field "bzeit" has value "0" in row 3
    Then field "mzeit" has value "0" in row 3
    Then field "ofmge" has value "20" in row 2
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZEITMGE_000"
    And I set field "noloesch" to "nein"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 07 Fertigartikel mit Charge und Verwendung werden nach Storno vom Lager abgebucht
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-07"
# Chargen anlegen
    Given I open an editor "Charge" from table "(Lots):(Lots)" with command "STORE" for record "CHARGE_R"
    And I set fields
      | such    | CHARGE_R  |
      | exnum   | 11833     |
      | artikel | BAUGRUPPE |
    And I save the current editor

# Auftrag anlegen
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I append rows
      | artikel   | mge | charge   |
      | BAUGRUPPE | 10  | CHARGE_R |
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row 1
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

# Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | bisuch  | mfreig |
      | BAUGRUPPE | 10  | CHVERW_ | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHVERW_001"
    And I set fields
      | kcharge | CHARGE_R |
      | sofort  | 1        |
    And I set field "bem" in row 0 to "verw" from editor "auftrag" in row 1
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
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
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert |
      | BAUGRUPPE | -5   |      | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-1 |      | -10  | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-2 |      | -5   | Storno-Rückmeldung Fertigung | nein      |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung        | ja        |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung        | ja        |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung        | ja        |
    Then field "ncharge^such" has value "CHARGE_R" in row 1
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag" in row 1
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

# Betriebsauftrag und Auftrag abschließen
    Given I open an editor "Betriebsauftrag1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHVERW_000"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "mgr" to "112"
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set field "mge" to "10" in row 1
    And I set field "ueb" to "ja"
    And I save the current editor


  Scenario: 08 Fertigartikel mit Projekt werden durch Storno-Rückmeldung vom Lager gebucht
# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "B_08"

# Projekt anlegen
    Given I open an editor "PROJEKT_R" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT_R"
    And I set fields
      | such | PROJEKT_R |
    And I save the current editor

# Auftrag anlegen
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I append rows
      | artikel   | mge | projekt   |
      | BAUGRUPPE | 10  | PROJEKT_R |
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row 1
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor

# Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | projekt   | mfreig | bisuch   |
      | BAUGRUPPE | 10  | PROJEKT_R | ja     | PROJEKT_ |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    And I save value from field "lemge" in row 1
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROJEKT_001"
    Then field "projekt" has value "PROJEKT_R"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "ProjektRM1" in row 1
    And I save the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert | projekt   |
      | BAUGRUPPE | -5   |      | Storno-Rückmeldung Fertigung | nein      | PROJEKT_R |
      | EINKAUF-1 |      | -10  | Storno-Rückmeldung Fertigung | nein      | PROJEKT_R |
      | EINKAUF-2 |      | -5   | Storno-Rückmeldung Fertigung | nein      | PROJEKT_R |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung        | ja        | PROJEKT_R |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung        | ja        | PROJEKT_R |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung        | ja        | PROJEKT_R |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

# Betriebsauftrag und Auftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROJEKT_000"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "mgr" to "112"
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set field "mge" to "10" in row 1
    And I set field "ueb" to "ja"
    And I save the current editor


  Scenario: 09 Storno einer Rückmeldung mit Koppelprodukt
# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "BG-KOPPEL" on StorageLocation "F1" with document "KORR09"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BG-KOPPEL | 10     | KOPPEL_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPPEL_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BG-KOPPEL;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-KOPPEL |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | detursache                   | zmge | amge | storniert |
      | BG-KOPPEL  | Storno-Rückmeldung Fertigung | -5   |      | nein      |
      | KOPPELPROD | Storno-Rückmeldung Fertigung | -5   |      | nein      |
      | EINKAUF-1  | Storno-Rückmeldung Fertigung |      | -10  | nein      |
      | BG-KOPPEL  | Rückmeldung Fertigung        | 5    |      | ja        |
      | KOPPELPROD | Rückmeldung Fertigung        | 5    |      | ja        |
      | EINKAUF-1  | Rückmeldung Fertigung        |      | 10   | ja        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 6
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOPPEL_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "mgr" to "112"
    And I save the current editor


  Scenario: 10 Storno von Rückmeldungen mit zusätzlich entnommenem Material über Rückmeldung
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 5      | ZUSATZ_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang mit zusätzlichem Material
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUSATZ_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "2" in row 1
    And I append rows
      | artikel   | mge |
      | EINKAUF-3 | 2   |
    And I save the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "artikel" has value "EINKAUF-3" in row 2
    Then field "mge" has value "-2" in row 2
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | ja        |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | detursache                   | zmge | amge | storniert |
      | BAUGRUPPE | Storno-Rückmeldung Fertigung | -2   |      | nein      |
      | EINKAUF-1 | Storno-Rückmeldung Fertigung |      | -4   | nein      |
      | EINKAUF-2 | Storno-Rückmeldung Fertigung |      | -2   | nein      |
      | EINKAUF-3 | Storno-Rückmeldung Fertigung |      | -2   | nein      |
      | BAUGRUPPE | Rückmeldung Fertigung        | 2    |      | ja        |
      | EINKAUF-1 | Rückmeldung Fertigung        |      | 4    | ja        |
      | EINKAUF-2 | Rückmeldung Fertigung        |      | 2    | ja        |
      | EINKAUF-3 | Rückmeldung Fertigung        |      | 2    | ja        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "stornolj^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 8
    And I close the current editor

# Offene Menge Betriebsauftrag prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZUSATZ_000"
    Then field "mge" has value "5"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUSATZ_000"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "mgr" to "112"
    And I save the current editor


  Scenario Outline: 10 A Variantenbezogenes Fertigartikel mit Chargen und Verwendungen werden wieder aus dem Lager gebucht
# Artikel anlegen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
      | dispoa   | <dispoa>   |
      | bsart    | <bsart>    |
    And I delete all rows
    And I append rows
      | elex    | anzahl    |
      | <elex1> | <anzahl1> |
      | <elex2> | <anzahl2> |
    And I save the current editor

    Examples:
      | such        | namebspr       | dispoa           | bsart            | elex1       | anzahl1     | elex2       | anzahl2     |
      | EKTEIL-1    | Einkaufsteil 1 | bedarfsbezogen   | Fremdbeschaffung | !dontChange | !dontChange | !dontChange | !dontChange |
      | BAUGRUPPE-1 | Baugruppe	1    | variantenbezogen | Eigenfertigung   | EKTEIL-1    | 1           | A AG1       | 1           |

  Scenario: 10 B Variantenbezogenes Fertigartikel mit Chargen und Verwendungen werden wieder aus dem Lager gebucht
# Chargen anlegen
    Given I create a Lot "CHARGE_BG-1" for Product "BAUGRUPPE-1"
    Given I create a Lot "CHARGE_BG-2" for Product "BAUGRUPPE-1"

# Bestandskorrektur
    Given I open an editor "Bestandskorrektur" for tip command "LBestand" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE-1 |
      | beleg   | B_10        |
      | beldat  | .           |
    And I set field "platz" to "F1" in row 1
    And I modify table
      | !row        | mge |
      | platz=='F1' | 0   |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | BAUGRUPPE-1 | 10  | ja     |
    And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
    And I delete all rows
    And I append rows
      | zuomge | charge          |
      | 3      | !CHARGE_BG-2^id |
      | 5      | !CHARGE_BG-1^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "CHVAR_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHVAR_001"
    And I set fields
      | kcharge | !CHARGE_BG-1^id |
      | sofort  | 1               |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE-1;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE-1 |
      | klplatz    | F1          |
      | verdichten | ja          |
      | details    | nein        |
    And I press start
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "richtung" to "rueckwaerts"
    And I press start
    Then table has values
      | art         | zmge | amge | vcharge^such | ncharge^such |
      | BAUGRUPPE-1 | -5   |      |              | CHARGE_BG-1  |
      | BAUGRUPPE-1 | -2   |      |              | CHARGE_BG-1  |
      | EKTEIL-1    |      | -7   |              | CHARGE_BG-1  |
      | BAUGRUPPE-1 | 2    |      |              | CHARGE_BG-1  |
      | BAUGRUPPE-1 | 5    |      |              | CHARGE_BG-1  |
      | EKTEIL-1    |      | 7    |              | CHARGE_BG-1  |
    And I close the current editor

# Betriebsauftrag abschliessen
    Given I open an editor "Betriebsauftrag1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "CHVAR_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 11 Storno einer Rückmeldung mit Ausschuss und ohne Gutmenge
# Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "KORR-11"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch     | mfreig |
      | BAUGRUPPE | 5      | AUSSCHUSS_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag öffnen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "AUSSCHUSS_000"
    And I close the current editor

# Auftragsvorkalkulation Materialkosten prüfen
    Given I open an editor "Vorkalk" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;typ=Auftragsvorkalkulation;@richtung=rückwärts;@maxtreffer=1"
    Then field "matek" has value "29.3360"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUSSCHUSS_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "1" in row 1
    And I set field "verlustmge" to "2" in row 1
    And I save the current editor

# Nachkalkulation starten
    And I run Revaluation

# Nachkalkulaiton prüfen, Materialkosten sind höher durch gemeldeten ungeplanten Ausschuss
    Given I open an editor "Nachkalk1" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;typ=Nachkalkulation;herkunft^ablagef=nein;@richtung=rückwärts;@maxtreffer=1"
    Then field "matek" has value "32.4688"
    And I close the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
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

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | detursache                   | zmge | amge | storniert |
      | BAUGRUPPE | Storno-Rückmeldung Fertigung | -1   |      | nein      |
      | EINKAUF-1 | Storno-Rückmeldung Fertigung |      | -6   | nein      |
      | EINKAUF-2 | Storno-Rückmeldung Fertigung |      | -3   | nein      |
      | BAUGRUPPE | Rückmeldung Fertigung        | 1    |      | ja        |
      | EINKAUF-1 | Rückmeldung Fertigung        |      | 6    | ja        |
      | EINKAUF-2 | Rückmeldung Fertigung        |      | 3    | ja        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

# Betriebsauftrag nachkalkulieren
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "banummer" to "!Betriebsauftrag^nummer"
    And I press button "ladetab"
    And I press button "bunkalk" to open a subeditor for "Nachkalkulieren" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Nachbewertung prüfen
    And I switch the current editor to editor "Nachkalk1" with command "VIEW"
    Then field "matek" has value "29.3360"
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "AUSSCHUSS_000"
    Then field "mge" has value "5"
    Then field "rgutmge" has value "0"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "10" in row 1
    Then field "limge" has value "5" in row 2
    Then field "gmge" has value "0.75" in row 3
    Then field "limge" has value "5" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 12 Mengen über Rückmeldung Restmengen mitbuchen gebucht, werden bei einem Storno nicht wieder erhöht
# Bestandskorrektur
    Given I open an editor "Bestandskorrektur" for tip command "LBestand" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE2 |
      | beleg   | B_12       |
      | beldat  | .          |
    And I set field "platz" to "F1" in row 1
    And I modify table
      | !row        | mge |
      | platz=='F1' | 0   |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BAUGRUPPE2 | 10     | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I set field "manbu" to "ja" in row 1
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MITBUCHEN_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Teil-Rückmeldung auf ersten Arbeitsgang, Restmengen stornieren
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MITBUCHEN_001"
    And I set field "gutmge" to "5" in row 1
    And I set field "manrest" to "ja"
    And I set field "sofort" to "1"
    And I save the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE2;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE2 |
      | klplatz    | F1         |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Offene Menge in AFL prüfen und BA abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MITBUCHEN_000"
    And I press button "absteig" to open a subeditor for "AFL_pruef"
    Then field "limge" has value "20" in row 1
    Then field "limge" has value "10" in row 2
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 13 Mehrere Rückmeldungen auf den ersten Arbeitsschein können über die Menge storniert werden, die noch nicht in Arbeitsschein zwei gebucht wurde
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig | bisuch      |
      | BAUGRUPPE2 | 10     | ja     | TEILSTORNO_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Teil-Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1_1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEILSTORNO_001"
    And I set field "gutmge" to "1" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Teil-Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1_2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEILSTORNO_001"
    And I set field "gutmge" to "2" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Teil-Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1_3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEILSTORNO_001"
    And I set field "gutmge" to "3" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Teil-Rückmeldung auf zweiten Arbeitsgang
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEILSTORNO_002"
    And I set field "gutmge" to "5" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Erste Rückmeldung erster Arbeitsgang kann storniert werden
    Given I open an editor "Storno1_1" via ID from editor "Rückmeldung1_1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1_1" in row 0

# Zweite Rückmeldung erster Arbeitsgang kann nicht storniert werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1_2" throws the exception "9503"

# BA abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "TEILSTORNO_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 14 Storno einer Rückmeldung mit geplantem Ausschuss setzt die Mengen korrekt
# Artikel mit geplantem Ausschuss
    Given I open an editor "AUSSCHUSS" from table "(Part):(Product)" with command "STORE" for record "AUSSCHUSS"
    And I set fields
      | such     | AUSSCHUSS           |
      | namebspr | Geplanter Ausschuss |
      | bsart    | Eigenfertigung      |
    And I delete all rows
    And I append rows
      | elex        | anzahl | pverlust |
      | EINKAUF-1   | 1      |          |
      | A SCHRAUBEN | 1      | 50       |
    And I save the current editor

# Bestandskorrektur
    Given I open an editor "Bestandskorrektur" for tip command "LBestand" and arguments ""
    And I set fields
      | artikel | AUSSCHUSS |
      | beleg   | B_14      |
      | beldat  | .         |
    And I set field "platz" to "F1" in row 1
    And I modify table
      | !row        | mge |
      | platz=='F1' | 0   |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch      | mfreig |
      | AUSSCHUSS | 10     | AUSSCHUSS2_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUSSCHUSS2_001"
    And I set fields
      | sofort | 1 |
    And I set field "gutmge" to "5" in row 1
    And I set field "verlustmge" to "5" in row 1
    And I save the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=AUSSCHUSS;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | AUSSCHUSS |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "AUSSCHUSS2_000"
    Then fields have values
      | mge     | 20 |
      | rgutmge | 0  |
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | limge | gmge |
      | 20    | 20   |
      | 20    | 3.42 |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 15 Material wird bei Storno einer Rückmeldung wieder zurück in den Behälter gebucht
# Behälter anlegen
    Given I open an editor "MATERIAL" from table "(Container):(ContainerShell)" with command "NEW" for record ""
    And I set fields
      | such  | MATERIAL  |
      | packm | BEHAELTER |
    And I save the current editor

# Material in Behälter buchen
    Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | EINKAUF-1 |
      | beleg   | 15-L      |
      | beldat  | .         |
      | buart   | Zugang    |
    And I create a new row at the end of the table
    And I set field "mge" to "20" in row 1
    And I set field "behaelter" to id from editor "MATERIAL" in row 1
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BAUGRUPPE | 10  | ja     |
    And I press button "mzabsm" to open a subeditor for "MZMaterial" in row 1
    And I create a new row at the end of the table
    And I set field "zuomge" to "20" in row 1
    And I set field "behaelter" to id from editor "MATERIAL" in row 1
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEHMAT_" in row 1
    And I press button "freig" to open a subeditor for "BA"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHMAT_001"
    And I set fields
      | sofort | 1 |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Behälter prüfen
    And I switch the current editor to editor "MATERIAL" with command "VIEW"
    Then the table has 1 rows
    Then field "mge" has value "20" in row 1
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BEHMAT_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 16 Gutmenge wird bei Storno einer Rückmeldung wieder aus dem Behälter gebucht
# Behälter anlegen
    Given I create a Container "GUTMENGE" for packaging material "BEHAELTER"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch  |
      | BAUGRUPPE | 10  | ja     | BEHGUT_ |
    And I press button "freig" to open a subeditor for "BA"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHGUT_001"
    And I set fields
      | sofort | 1 |
    And I set field "behaelter" to id from editor "GUTMENGE"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Behälter prüfen
    Then Container from editor "GUTMENGE" is empty

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BEHGUT_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 17 Storno möglich, wenn es noch ungebuchte Rückmeldungen zum gleichen oder einem anderen Arbeitsschein gibt
# Fertigungsvorschlag anlegen und freigeben, Fall mit erlaubtem BA-Abbruch da eine KST verwendet wird
#
# Ausserdem wird hier folgendes Verhalten dokumentiert:
# die letzte rückmeldung bucht std.mässig alle entnahmemengen gleich ab. nach deren storno wird
# die entnahmemenge die für den 1. arbeitsgang benötigt wird nochmals abgebucht, sobald
# die rückmeldung zum 1. arbeitsgang gebucht wird. die zeit für RM1 wird nur hier gebucht.
# dadurch enstehen herstellkosten nachdem der letzte arbeitsgang (und damit gutmenge)
# storniert wurden. auf diese kosten wird hier beim abbrechen des BA hingewiesen.
# nur mit bestätigung der warnung kann der BA abgebrochen werden. es entstehen dann
#  a) mengenabbuchungen im lager (in Fertigung) und b) fertigungsaufwand wird in der FKV gebucht.
#
# wird die zuerst erfasste aber nicht gebucht RM für den 1. AG vor abbruch des BA gelöscht,
# enstehen keine kostenbuchungen.
# alternativ könnte die RM für den 1. AG auch gebucht und dann wieder storniert werden (wäre aber
# überflüssig)
#
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig | bisuch      | kstelle |
      | BAUGRUPPE2 | 10     | ja     | STORNONEIN_ | 101     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang ohne Buchen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNONEIN_001"
    And I set field "gut" to "1"
    And I save the current editor

# Rückmeldung auf zweiten Arbeitsgang
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNONEIN_002"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "manrest" to "1"
    And I save the current editor

# Zweite Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung2" in row 0

# Erste Rückmeldung übernehmen
    And I switch the current editor to editor "Rückmeldung1" with command "TRANSFER"
    And I save the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "STORNONEIN_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 18 Storno/Abbruch eines angearbeiteten BAs ohne Gutmenge bei aktiver Materialkostenverbuchung verhindern - ks mit Gemeinkosten kann storniert werden
# Fertigungsvorschlag anlegen und freigeben, Fall mit erlaubtem BA-Abbruch da eine KST verwendet wird
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig | bisuch   | kstelle |
      | BAUGRUPPE2 | 10     | ja     | ABBRUCH_ | 101     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang ohne Buchen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABBRUCH_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ABBRUCH_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 19 Storno/Abbruch eines angearbeiteten BAs ohne Gutmenge bei aktiver Materialkostenverbuchung (AS bebucht) - ks ohne Gemeinkosten - Storno ist moeglich
# Fertigungsvorschlag anlegen und freigeben, Fall mit nicht erlaubtem BA-Abbruch da keine KST verwendet wird
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig | bisuch | kstelle |
      | BAUGRUPPE2 | 10     | ja     | ABB_   | 100000  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABB_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

# Betriebsauftrag durch Status setzen abschließen ist moeglich
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ABB_000"
    And I respond with answer "ja" to the dialog with id "1483"
    And I set field "status" to "s"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ABB_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 20 Gebuchte Sonderkosten werden bei einem Storno einer Rückmeldung storniert und in der nächsten Rückmeldung erneut gebucht
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | SONDERK_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SONDERK_001"
    And I set fields
      | sofort   | ja  |
      | skostfix | 100 |
      | skostvar | 70  |
    And I set field "erbtext1" to "SONDERK_001" in row 1
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Sonderkosten gebucht und Flag akgebucht auf ja
    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SONDERK_001"
    Then field "skgebucht" is not empty
    Then field "skgebucht^id" has value "!Rückmeldung1^id"
    And I close the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    Then table has values
      | !row | tlbbuwert | tlbstatus  |
      | 1    | 100.00  | verbuchbar |
      | 2    | 70.00   | verbuchbar |
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Flag Sonderkosten in Arbeitsschein auf nein
    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SONDERK_001"
    Then field "skgebucht" is empty
    And I close the current editor

# Bewertung Rückmeldung1 hat Nachfolger mit Wert 0
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    Then table has values
      | !row | tlbbuwert | tlbstatus  |
      | 1    | 100.00  | verbuchbar |
      | 2    | 70.00   | verbuchbar |
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then table has values
      | !row | tlbbuwert | tlbstatus |
      | 1    | 0.00    | verworfen |
      | 2    | 0.00    | verworfen |
    And I close the current editor

# erneut Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SONDERK_001"
    And I set fields
      | sofort   | ja  |
      | skostfix | 100 |
      | skostvar | 70  |
    And I set field "erbtext1" to "SONDERK_001" in row 1
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Flag Sonderkosten in Arbeitsschein auf ja
    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SONDERK_001"
    Then field "skgebucht" is not empty
    Then field "skgebucht^id" has value "!Rückmeldung2^id"
    And I close the current editor

# Neue Bewertung ist entstanden
    Given I open an editor "Bewertung2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung2"
    Then table has values
      | !row | tlbbuwert | tlbstatus  |
      | 1    | 100.00  | verbuchbar |
      | 2    | 70.00   | verbuchbar |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SONDERK_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 21 Storno der zweiten RM auf einen Arbeitsschein hat keinen Einfluss auf die Sonderkosten, die in der ersten RM gebucht wurden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | SONDERK2_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung1 und 2 auf ersten Arbeitsgang und Bewertungen öffnen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SONDERK2_001"
    And I set fields
      | sofort | ja           |
      | bem    | Rückmeldung1 |
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=`;1:tmge=1;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    Then table has values
      | !row | tlbbuwert | tlbstatus  |
      | 1    | 10.00   | verbuchbar |
      | 2    | 20.00   | verbuchbar |
    And I close the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SONDERK2_001"
    And I set fields
      | sofort | ja           |
      | bem    | Rückmeldung2 |
    And I set field "gutmge" to "2" in row 1
    And I save the current editor

    Given I open an editor "Bewertung2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=`;1:tmge=1;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    Then table has values
      | !row | tlbbuwert | tlbstatus  |
      | 1    | 10.00   | verbuchbar |
      | 2    | 20.00   | verbuchbar |
    And I close the current editor

# Storno Rückmeldung2
    Given I open an editor "Storno1" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung2" in row 0

# Sonderkosten in Arbeistsschein gebucht und Flag akgebucht auf ja
    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SONDERK2_001"
    Then field "skgebucht^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Bewertung Rückmeldung1 hat Sonderkosten
    Given I switch the current editor to editor "Bewertung1"
    Then field "nachfolger" is empty
    Then table has values
      | !row | tlbbuwert | tlbstatus  |
      | 1    | 10.00   | verbuchbar |
      | 2    | 20.00   | verbuchbar |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SONDERK2_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 22 Storno zu Rueckmeldung mit Material aus zwei Zugaengen; Joker und Verwendung
# Artikel anlegen
    Given I open an editor "JOKER-K" from table "(Part):(Product)" with command "STORE" for record "JOKER-K"
    And I set fields
      | such      | JOKER-K             |
      | namebspr  | Komponente Joker-BG |
      | dispoa    | auftragsbezogen     |
      | lief      | KETTLER             |
      | efrist    | 2                   |
      | epr       | 4,50                |
      | ekbewverf | 4                   |
      | wgruppe   | 55                  |
      | erlgrp    | 66                  |
    And I save the current editor

    Given I open an editor "BG-JOKER" from table "(Part):(Product)" with command "STORE" for record "BG-JOKER"
    And I set fields
      | such      | BG-JOKER        |
      | namebspr  | BG Jokerbestand |
      | dispoa    | auftragsbezogen |
      | bsart     | Eigenfertigung  |
      | ekbewverf | 4               |
      | wgruppe   | 55              |
      | erlgrp    | 66              |
    And I delete all rows
    And I append rows
      | elex       | anzahl |
      | JOKER-K    | 2      |
      | A MONTAGE1 | 1      |
    And I save the current editor

# Bestände korrigieren
    Given I set StorageQuantity to zero for Product "BG-JOKER" on StorageLocation "F1" with document "KORR"
    Given I set StorageQuantity to zero for Product "JOKER-K" on StorageLocation "F1" with document "KORR"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-JOKER" and quantity "60"

# Hälfte der Bedarfe einkaufen (Verwendung)
    Given I open an editor "RechnungmL" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | fakt   | ja      |
      | ebeleg | 22R     |
      | ueb    | ja      |
    And I append rows
      | artikel | mge |
      | JOKER-K | 60  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I respond with answer "JA" to the dialog with id "4841"
    And I save the current editor

# Lagerbuchung Jokerbestand
    Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | JOKER-K |
      | beleg   | R22     |
      | buart   | Zugang  |
      | beldat  | .       |
    And I delete all rows
    And I append rows
      | mge |
      | 60  |
    And I save the current editor

# Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel  | bisuch | mge | mfreig |
      | BG-JOKER | JOKER_ | 60  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "JOKER_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "50" in row 1
    And I save the current editor

# R�ckbau1 zu Betriebsauftrag
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerbewegungsjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | .         |
      | richtung | rückwärts |
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I press start
    Then table has values
      | art      | zmge | amge | rueckmge | restmge | storniert |
      | BG-JOKER | -50  |      | -50      | 0       | nein      |
      | JOKER-K  |      | -60  | -60      | 0       | nein      |
      | JOKER-K  |      | -40  | -40      | 0       | nein      |
      | BG-JOKER | 50   |      | 50       | 0       | ja        |
      | JOKER-K  |      | 40   | 40       | 0       | ja        |
      | JOKER-K  |      | 60   | 60       | 0       | ja        |
    Then field "verw" in row 1 has value equal to field "verw" from editor "auftrag" in row 1
    Then field "verwla" in row 1 has value equal to field "verw" from editor "auftrag" in row 1
# Verwendung im Lager wurde bei Joker Bestand nicht ans Lager gebucht
    Then field "verw" in row 2 has value equal to field "verw" from editor "auftrag" in row 1
    Then field "verwla" in row 2 has value equal to field "verw" from editor "auftrag" in row 1
    Then field "verw" in row 3 has value equal to field "verw" from editor "auftrag" in row 1
    Then field "verwla" is empty in row 3
# Verwendung im Lager wurde bei Joker Bestand nicht vom Lager gebucht
    Then field "verw" in row 5 has value equal to field "verw" from editor "auftrag" in row 1
    Then field "verwla" is empty in row 5
    Then field "verw" in row 6 has value equal to field "verw" from editor "auftrag" in row 1
    Then field "verwla" in row 6 has value equal to field "verw" from editor "auftrag" in row 1
    And I close the current editor

# Journaleintrag prüfen
    Given I open an editor "LJ_Storno" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BG-JOKER;mge=-50;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | rueckmge | -50 |
      | restmge  | 0   |
    Then field "stornolj" is not empty
    Then field "vorgang^id" has value equal to field "id" from editor "Storno1"
    And I close the current editor

    And I open an editor "LJ_Rückmeldung" via ID from editor "LJ_Storno" from field "stornolj" in row 0 for table "(Journal):(Journal)" with command "VIEW"
    Then fields have values
      | mge       | 50 |
      | rueckmge  | 50 |
      | restmge   | 0  |
      | storniert | ja |
    Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "JOKER_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-22"


  Scenario: 23 Variantenbezogenes Fertigartikel mit Chargen und Verwendungen werden wieder aus dem Lager gebucht
# Artikel anlegen
    Given I open an editor "BAUGRUPPE-V" from table "(Part):(Product)" with command "STORE" for record "BAUGRUPPE-V"
    And I set fields
      | such     | BAUGRUPPE-V      |
      | namebspr | Baugruppe V      |
      | dispoa   | variantenbezogen |
      | bsart    | Eigenfertigung   |
    And I delete all rows
    And I append rows
      | elex        | anzahl |
      | B_EINKAUF-1 | 1      |
      | A AG1       | 1      |
    And I save the current editor

# Chargen anlegen
    Given I create a Lot "CHARGE_BG-1" for Product "BAUGRUPPE-V"
    Given I create a Lot "CHARGE_BG-2" for Product "BAUGRUPPE-V"

# Bestandskorrektur BAUGRUPPE-V und B_EINKAUF-1
    Given I set StorageQuantity to zero for Product "BAUGRUPPE-V" on StorageLocation "F1" with document "BKORR23"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "BKORR23"

# Auftrag anlegen, Fertigungsvorschlag anlegen und freigeben
    Given I create a SalesOrder "auftrag10" for Customer "RADSHOP" with Product "BAUGRUPPE-V" and quantity "10"

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | BAUGRUPPE-V | 10  | ja     |
    And I set field "verw" in row 1 to "verw" from editor "auftrag10" in row 1
    And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
    And I delete all rows
    And I append rows
      | zuomge | charge          |
      | 5      | !CHARGE_BG-1^id |
      | 5      | !CHARGE_BG-2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "CHVAR_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHVAR_001"
    And I set fields
      | sofort | 1 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Bewertung Rückmeldung1
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE-V;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE-V |
      | klplatz    | F1          |
      | verdichten | ja          |
      | details    | nein        |
    And I press start
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | detursache                   | storniert | ncharge^such | !row |
      | BAUGRUPPE-V | -5   |      | Storno-Rückmeldung Fertigung | nein      | CHARGE_BG-1  | 1    |
      | BAUGRUPPE-V | -2   |      | Storno-Rückmeldung Fertigung | nein      | CHARGE_BG-2  | 2    |
      | B_EINKAUF-1 |      | -5   | Storno-Rückmeldung Fertigung | nein      | CHARGE_BG-1  | 3    |
      | B_EINKAUF-1 |      | -2   | Storno-Rückmeldung Fertigung | nein      | CHARGE_BG-2  | 4    |
      | BAUGRUPPE-V | 2    |      | Rückmeldung Fertigung        | ja        | CHARGE_BG-2  | 5    |
      | BAUGRUPPE-V | 5    |      | Rückmeldung Fertigung        | ja        | CHARGE_BG-1  | 6    |
      | B_EINKAUF-1 |      | 2    | Rückmeldung Fertigung        | ja        | CHARGE_BG-2  | 7    |
      | B_EINKAUF-1 |      | 5    | Rückmeldung Fertigung        | ja        | CHARGE_BG-1  | 8    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

# Betriebsauftrag und Auftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHVAR_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

    And I deliver the SalesOrder "auftrag10" with PackingSlip "LS-10"


  Scenario: 24 Storno bucht Fertigartikel von Lagerplätzen ab, bisher Rückmeldung Teilmenge auf AS bucht auf unterschiedliche Lagerplätze, FertigteilMZ mit Lagerplätze vor Freigabe FV angelegt
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


  Scenario: 25 Storno bucht Fertigartikel aus dem Behälter, bisher Rückmeldung Teilmenge auf AS bucht in verschiedene Behälter, FertigteilMZ für Behälter vor Freigabe FV angelegt
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


  Scenario: 26 Storno bucht Fertigartikel entsprechend MZ aus Rückmeldung auf BA zurück, bisher Rückmeldung auf BA und MZ für Lagerplätze darin angelegt
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


  Scenario: 27 Storno bucht Fertigartikel entsprechend MZ aus Rückmeldung auf BA zurück, bisher Rückmeldung auf BA und MZ für Chargen darin angelegt
# Bestand Baugruppe auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "KORR-S1"

# Chargen anlegen
    Given I create a Lot "CHARGE_BG1" for Product "BAUGRUPPE"
    Given I create a Lot "CHARGE_BG2" for Product "BAUGRUPPE"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | BACHARGE_ |
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
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I append rows
      | zuomge | charge         |
      | 5      | !CHARGE_BG1^id |
      | 2      | !CHARGE_BG2^id |
    And I save the current editor
    And I switch the current editor to editor "Rückmeldung1"
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
    Then field "lemge" has value "7" in row 1
    Then table has values
      | !row | lemge | gebmge | charge^such | kopfzugvorg^id   |
      | 2    |       | 5      | CHARGE_BG1  | !Rückmeldung1^id |
      | 3    |       | 2      | CHARGE_BG2  | !Rückmeldung1^id |
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


  Scenario: 28 Storno bucht Fertigartikel entsprechend MZ aus Rückmeldung auf BA zurück, bisher Rückmeldung auf BA und MZ für Behälter darin angelegt
# Behälter erstellen
    Given I create a Container "MZBA_BEHAELTER1" for packaging material "BEHAELTER"
    Given I create a Container "MZBA_BEHAELTER2" for packaging material "BEHAELTER"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | BACHARGE2_ |
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
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I delete all rows
    And I append rows
      | zuomge | behaelter        |
      | 5      | !MZBA_BEHAELTER1 |
      | 2      | !MZBA_BEHAELTER2 |
    And I save the current editor
    And I switch the current editor to editor "Rückmeldung1"
    And I save the current editor

# Erste Rückmeldung stornieren
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    And I save the current editor

# Behälter prüfen
    Then Container from editor "MZBA_BEHAELTER1" is empty
    Then Container from editor "MZBA_BEHAELTER2" is empty


  Scenario: 29 Storno bucht Material und Fertigteil mit Chargen vom bzw ans Lager, bisher Rückmeldung auf AS betrifft mehrere Chargen für Fertigteil und Komponenten, FertigteilMZ und EntnahmeMZ vor Freigabe FV angelegt
# Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-11"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "KORR-11"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag11" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

# Chargen anlegen
    Given I create a Lot "CHARGE1_BG" for Product "BAUGRUPPE"
    Given I create a Lot "CHARGE2_BG" for Product "BAUGRUPPE"
    Given I create a Lot "CHARGE1_E1" for Product "EINKAUF-1"
    Given I create a Lot "CHARGE2_E1" for Product "EINKAUF-1"

# Fertigungsvorschlag anlegen und freigben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BAUGRUPPE | 10  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag11" in row !lastRow
    And I press button "mzsubm" to open a subeditor for "MZFertig" in row !lastRow
    And I modify table
      | !row | zuomge | charge         |
      | +1   | 5      | !CHARGE1_BG^id |
      | +2   | 5      | !CHARGE2_BG^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzabsm" to open a subeditor for "MZFertig" in row !lastRow
    And I modify table
      | !row | zuomge | charge         |
      | +1   | 10     | !CHARGE1_E1^id |
      | +2   | 10     | !CHARGE2_E1^id |
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
      | art       | zmge | amge | vcharge^such | ncharge^such | storniert | !row |
      | BAUGRUPPE | -5   |      |              | CHARGE1_BG   | nein      | 1    |
      | BAUGRUPPE | -2   |      |              | CHARGE2_BG   | nein      | 2    |
      | EINKAUF-1 |      | -10  | CHARGE1_E1   | CHARGE1_BG   | nein      | 3    |
      | EINKAUF-1 |      | -4   | CHARGE2_E1   | CHARGE2_BG   | nein      | 4    |
      | EINKAUF-2 |      | -5   |              | CHARGE1_BG   | nein      | 5    |
      | EINKAUF-2 |      | -2   |              | CHARGE2_BG   | nein      | 6    |
      | BAUGRUPPE | 2    |      |              | CHARGE2_BG   | ja        | 7    |
      | BAUGRUPPE | 5    |      |              | CHARGE1_BG   | ja        | 8    |
      | EINKAUF-1 |      | 4    | CHARGE2_E1   | CHARGE2_BG   | ja        | 9    |
      | EINKAUF-1 |      | 10   | CHARGE1_E1   | CHARGE1_BG   | ja        | 10   |
      | EINKAUF-2 |      | 2    |              | CHARGE2_BG   | ja        | 11   |
      | EINKAUF-2 |      | 5    |              | CHARGE1_BG   | ja        | 12   |
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


  Scenario: 30 Storno bucht Fertigteil mit Einheiten und Material mit Einheiten und Gebindepflicht aus bzw in Behälter, bisher Rückmeldung auf AS bucht aus und in verschiedene Behälter, FertigteilMZ Behälter und Einheiten und EntnahmeMZ Behälter und Einheiten vor Freiagbe
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


  Scenario: 31 Storno bucht Fertigteil mit Einheiten und Gebindepflicht und Material mit Einheiten und Gebindepflicht aus bzw in Behälter, bisher Rückmeldung auf AS bucht aus und in verschiedene Behälter, FertigteilMZ Behälter und Einheiten und EntnahmeMZ Behälter und Einheiten vor Freigabe FV angelegt
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


  Scenario: 32 Storno/Abbruch eines angearbeiteten BAs ohne Gutmenge bei aktiver Materialkostenverbuchung verhindern (BA bebucht) - ks ohne Gemeinkosten - Fehlermeldung beim Stornieren
# Fertigungsvorschlag anlegen und freigeben, Fall mit nicht erlaubtem BA-Abbruch da keine KST verwendet wird
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig | bisuch | kstelle |
      | BAUGRUPPE2 | 10     | ja     | T32_   | 100000  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf den Betriebsauftrag
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "T32_000"
    And I set field "autorment" to "ja"
    And I press button "stllad"
    And I set field "mgr" to "112"
    And I save the current editor

# Betriebsauftrag durch storno abschließen -> Fehlermeldung
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "T32_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I close the current editor

# Rückmeldung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=T32_000;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I save the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "T32_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 33 Storno einer Teil-Rückmeldung mit ungeplantem Ausschuss, Teile retrograd entnommen
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-02"
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch     | mfreig |
      | BAUGRUPPE2 | 50     | AUSUNGEPL_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsuaftrag öffnen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "AUSUNGEPL_000"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUSUNGEPL_001"
    And I set field "sofort" to "1"
    And I set field "bzeit" to "1"
    And I set field "mzeit" to "1"
    And I set field "gutmge" to "30" in row 1
    And I set field "verlustmge" to "5" in row 1
    And I save the current editor

# Rückmeldung auf zweiten Arbeitsgang
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUSUNGEPL_002"
    And I set field "sofort" to "1"
    And I set field "bzeit" to "1"
    And I set field "mzeit" to "1"
    And I set field "gutmge" to "25" in row 1
    And I set field "verlustmge" to "5" in row 1
    And I save the current editor

# Erste Rückmeldung stornieren
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1" throws the exception "9503"

# Zweite Rückmeldung stornieren
    Given I open an editor "Storno2" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung2" in row 0

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache            | storniert |
      | EINKAUF-1 |      | 70   | Rückmeldung Fertigung | nein      |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung2"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | amge | detursache                   | storniert |
      | BAUGRUPPE2 | -25  |      | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-2  |      | -30  | Storno-Rückmeldung Fertigung | nein      |
      | BAUGRUPPE2 | 25   |      | Rückmeldung Fertigung        | ja        |
      | EINKAUF-2  |      | 30   | Rückmeldung Fertigung        | ja        |
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "AUSUNGEPL_000"
    Then field "mge" has value "50"
    Then field "rgutmge" has value "0"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "40" in row 1
    Then field "limge" has value "20" in row 2
    Then field "limge" has value "50" in row 3
    Then field "limge" has value "50" in row 4
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor


### Scenarios autorm=nein ###

  Scenario: Konfiguration autorm=nein
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set fields
      | autorm | nein |
    And I save the current editor

  Scenario: 34 Storno einer Abschluss-RM, autorm=Nein, Teile retrograd entnommen
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-02"
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch    | mfreig |
      | BAUGRUPPE2 | 50     | ABSCHLRM_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsuaftrag öffnen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ABSCHLRM_000"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABSCHLRM_001"
    And I set field "sofort" to "1"
    And I set field "bzeit" to "1"
    And I set field "mzeit" to "1"
    And I set field "gutmge" to "33" in row 1
    And I set field "verlustmge" to "3" in row 1
    And I save the current editor

# Rückmeldung auf zweiten Arbeitsgang
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABSCHLRM_002"
    And I set field "sofort" to "1"
    And I set field "bzeit" to "1"
    And I set field "mzeit" to "1"
    And I set field "gutmge" to "44" in row 1
    And I set field "verlustmge" to "4" in row 1
    And I save the current editor

# BA stornieren -> FV abschliessen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ABSCHLRM_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

# Abschluss-RM stornieren
    Given I open an editor "StornoAbschlussRM" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ABSCHLRM_000;abschluss=j;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "StornoAbschlussRM"
    And I set field "artikel" to "EINKAUF-1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert |
      | EINKAUF-1 |      | -30  | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-1 |      | 30   | Rückmeldung Fertigung        | ja        |
    And I close the current editor


### Scenarios autorm=ja ###

  Scenario: Konfiguration autorm=ja
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set fields
      | autorm | ja |
    And I save the current editor



###########################
# Storno auf abgelegte FV #
###########################

  Scenario: A01 Storno einer Rückmeldung über die gesamte Gutmenge eines abgelgeten FV
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A01"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A01"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A01"

# Fertigungsvorschlag anlegen und freigeben, BA-Nummer speichern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch       | mfreig |
      | BAUGRUPPE | 10     | SCENARIOA01_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SCENARIOA01_000"
    And I save value from field "nummer" in row 0
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA01_001"
    And I set fields
      | sofort | 1   |
      | bzeit  | 1,5 |
      | mzeit  | 1,5 |
      | gut    | 1   |
    And I save the current editor

# Bewertung Rückmeldung1 und Bestand prüfen
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

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
      |       | 10     | !Rückmeldung1^id |
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | -20   |        | (0,0,0)          |
      |       | -20    | !Rückmeldung1^id |
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert |
      | BAUGRUPPE | -10  |      | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-1 |      | -20  | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-2 |      | -10  | Storno-Rückmeldung Fertigung | nein      |
      | BAUGRUPPE | 10   |      | Rückmeldung Fertigung        | ja        |
      | EINKAUF-1 |      | 20   | Rückmeldung Fertigung        | ja        |
      | EINKAUF-2 |      | 10   | Rückmeldung Fertigung        | ja        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 6
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then table has values
      | mge | limge |
      | 10  | 0     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then table has values
      | limge | gmge | elex       |
      | 0     | 20   | EINKAUF-1  |
      | 0     | 10   | EINKAUF-2  |
      | 0     | 0    | A MONTAGE1 |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor


  Scenario: A02 Storno einer Teil-Rückmeldung auf einen abgelegten FV
# Bestand auf 0 korrigieren und Auftrag anlegen, Bedarfe einkaufen
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A02"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A02"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A02"

    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER     |
      | vom    | .           |
      | ebeleg | RechnungA02 |
      | ueb    | ja          |
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
      | artikel   | netmge | bisuch       | mfreig |
      | BAUGRUPPE | 10     | SCENARIOA02_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang und Bwertung prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA02_001"
    And I set fields
      | sofort | 1 |
      | bzeit  | 1 |
      | mzeit  | 1 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA02_001"
    And I set fields
      | sofort | 1   |
      | bzeit  | 0,5 |
      | mzeit  | 0,5 |
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

# Bestand prüfen
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
      |       | 7      | !Rückmeldung1^id |
      |       | 3      | !Rückmeldung2^id |
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0
    Then field "typa279" from editor "Rückmeldung1" in row 1 has value "Stornierte Rückmeldung"

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "3" in row 1
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "14" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert | !row |
      | BAUGRUPPE | -7   |      | Storno-Rückmeldung Fertigung | nein      | 1    |
      | EINKAUF-1 |      | -14  | Storno-Rückmeldung Fertigung | nein      | 2    |
      | EINKAUF-2 |      | -7   | Storno-Rückmeldung Fertigung | nein      | 3    |
      | BAUGRUPPE | 3    |      | Rückmeldung Fertigung        | nein      | 4    |
      | EINKAUF-1 |      | 6    | Rückmeldung Fertigung        | nein      | 5    |
      | EINKAUF-2 |      | 3    | Rückmeldung Fertigung        | nein      | 6    |
      | BAUGRUPPE | 7    |      | Rückmeldung Fertigung        | ja        | 7    |
      | EINKAUF-1 |      | 14   | Rückmeldung Fertigung        | ja        | 8    |
      | EINKAUF-2 |      | 7    | Rückmeldung Fertigung        | ja        | 9    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 8
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 9
    And I close the current editor

# FV abschließen und liefern
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row | mge         | gutmge      |
      | 1    | !dontChange | 7           |
      | 2    | 14          | !dontChange |
      | 3    | 7           | !dontChange |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "10" in row 1
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A02"


  Scenario: A03 Storno einer Rückmeldung auf abgelegten FV mit mehreren Arbeitsgängen
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE2" on StorageLocation "F1" with document "BK0-BG-A01"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A01"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A01"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER     |
      | vom    | .           |
      | ebeleg | RechnungA03 |
      | ueb    | ja          |
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
      | artikel    | netmge | bisuch       | mfreig |
      | BAUGRUPPE2 | 10     | SCENARIOA03_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang und Bewertung prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA03_001"
    And I set fields
      | sofort | 1   |
      | bzeit  | 1,5 |
      | mzeit  | 1,5 |
      | gut    | 1   |
    And I save the current editor

    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE2;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor
    Given I open an editor "Bewertung2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Rückmeldung auf zweiten Arbeitsgang und Bestand prüfen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA03_002"
    And I set fields
      | sofort | 1   |
      | bzeit  | 1,5 |
      | mzeit  | 1,5 |
      | gut    | 1   |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE2 |
      | klplatz    | F1         |
      | verdichten | nein       |
      | details    | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 10    |        | (0,0,0)          |
      |       | 10     | !Rückmeldung2^id |
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor
    Given I switch the current editor to editor "Bewertung2" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE2 |
      | klplatz    | F1         |
      | verdichten | ja         |
      | details    | nein       |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "10" in row 1
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "20" in row 1
    And I set fields
      | artikel    | EINKAUF-2 |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert |
      | EINKAUF-1 |      | -20  | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-1 |      | 20   | Rückmeldung Fertigung        | ja        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I set field "beleg" to "barmex" from editor "Rückmeldung2"
    And I press start
    Then table has values
      | art        | zmge | amge | detursache            | storniert |
      | BAUGRUPPE2 | 10   |      | Rückmeldung Fertigung | nein      |
      | EINKAUF-2  |      | 10   | Rückmeldung Fertigung | nein      |
    And I close the current editor

# FV abschließen und liefern
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "mge" to "20" in row 2
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE2 |
      | klplatz    | F1         |
      | verdichten | ja         |
      | details    | nein       |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "10" in row 1
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A03"


  Scenario: A04 Storno einer Rückmeldung auf abgelegten FV mit Chargen für Fertigteil und Material
# Chargen anlegen
    Given I create a Lot "ENK1_01" for Product "EINKAUF-1"
    Given I create a Lot "ENK1_02" for Product "EINKAUF-1"
    Given I create a Lot "BAUGR_01" for Product "BAUGRUPPE"
    Given I create a Lot "BAUGR_02" for Product "BAUGRUPPE"

# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A04"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A04"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A04"

# Fertigungsvorschlag mit MZ anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BAUGRUPPE | 10     | ja     |
    And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge       |
      | +1   | 5      | !BAUGR_01^id |
      | +2   | 5      | !BAUGR_02^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge      |
      | +1   | 10     | !ENK1_01^id |
      | +2   | 10     | !ENK1_02^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "SCENARIOA04_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA04_001"
    And I set fields
      | sofort | 1   |
      | bzeit  | 1,5 |
      | mzeit  | 1,5 |
      | gut    | 1   |
    And I save the current editor

# Bewertung Rückmeldung1 und Bestand prüfen
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id   |
      | 10    |        |             | (0,0,0)          |
      |       | 5      | BAUGR_01    | !Rückmeldung1^id |
      |       | 5      | BAUGR_02    | !Rückmeldung1^id |
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id   |
      | -20   |        |             | (0,0,0)          |
      |       | -10    | ENK1_01     | !Rückmeldung1^id |
      |       | -10    | ENK1_02     | !Rückmeldung1^id |
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | vcharge^such | ncharge^such | storniert | !row |
      | BAUGRUPPE | -5   |      | Storno-Rückmeldung Fertigung |              | BAUGR_01     | nein      | 1    |
      | BAUGRUPPE | -5   |      | Storno-Rückmeldung Fertigung |              | BAUGR_02     | nein      | 2    |
      | EINKAUF-1 |      | -10  | Storno-Rückmeldung Fertigung | ENK1_01      | BAUGR_01     | nein      | 3    |
      | EINKAUF-1 |      | -10  | Storno-Rückmeldung Fertigung | ENK1_02      | BAUGR_02     | nein      | 4    |
      | EINKAUF-2 |      | -5   | Storno-Rückmeldung Fertigung |              | BAUGR_01     | nein      | 5    |
      | EINKAUF-2 |      | -5   | Storno-Rückmeldung Fertigung |              | BAUGR_02     | nein      | 6    |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung        |              | BAUGR_02     | ja        | 7    |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung        |              | BAUGR_01     | ja        | 8    |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung        | ENK1_02      | BAUGR_02     | ja        | 9    |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung        | ENK1_01      | BAUGR_01     | ja        | 10   |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung        |              | BAUGR_02     | ja        | 11   |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung        |              | BAUGR_01     | ja        | 12   |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 8
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 10
    Then field "stornolj^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 9
    And I close the current editor


  Scenario: A05 Storno einer Teil-Rückmeldung auf abgelegten FV mit Chargen für Fertigteil und Material
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A05"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A05"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A05"

# Chargen anlegen
    Given I create a Lot "ENKA1_01" for Product "EINKAUF-1"
    Given I create a Lot "ENKA1_02" for Product "EINKAUF-1"
    Given I create a Lot "BAUGRA_01" for Product "BAUGRUPPE"
    Given I create a Lot "BAUGRA_02" for Product "BAUGRUPPE"

# Fertigungsvorschlag mit MZ anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BAUGRUPPE | 10     | ja     |
    And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge        |
      | +1   | 5      | !BAUGRA_01^id |
      | +2   | 5      | !BAUGRA_02^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge       |
      | +1   | 10     | !ENKA1_01^id |
      | +2   | 10     | !ENKA1_02^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "SCENARIOA05_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA05_001"
    And I set fields
      | sofort | 1   |
      | bzeit  | 1,5 |
      | mzeit  | 1,5 |
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA05_001"
    And I set fields
      | sofort | 1   |
      | bzeit  | 1,5 |
      | mzeit  | 1,5 |
    And I set field "gutmge" to "2" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id   |
      | 10    |        |             | (0,0,0)          |
      |       | 5      | BAUGRA_01   | !Rückmeldung1^id |
      |       | 3      | BAUGRA_02   | !Rückmeldung1^id |
      |       | 2      | BAUGRA_02   | !Rückmeldung2^id |
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id   |
      | -20   |        |             | (0,0,0)          |
      |       | -10    | ENKA1_01    | !Rückmeldung1^id |
      |       | -6     | ENKA1_02    | !Rückmeldung1^id |
      |       | -4     | ENKA1_02    | !Rückmeldung2^id |
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id   |
      | 2     |        |             | (0,0,0)          |
      |       | 2      | BAUGRA_02   | !Rückmeldung2^id |
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id   |
      | -4    |        |             | (0,0,0)          |
      |       | -4     | ENKA1_02    | !Rückmeldung2^id |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | vcharge^such | ncharge^such | storniert | !row |
      | BAUGRUPPE | -5   |      | Storno-Rückmeldung Fertigung |              | BAUGRA_01    | nein      | 1    |
      | BAUGRUPPE | -3   |      | Storno-Rückmeldung Fertigung |              | BAUGRA_02    | nein      | 2    |
      | EINKAUF-1 |      | -10  | Storno-Rückmeldung Fertigung | ENKA1_01     | BAUGRA_01    | nein      | 3    |
      | EINKAUF-1 |      | -6   | Storno-Rückmeldung Fertigung | ENKA1_02     | BAUGRA_02    | nein      | 4    |
      | EINKAUF-2 |      | -5   | Storno-Rückmeldung Fertigung |              | BAUGRA_01    | nein      | 5    |
      | EINKAUF-2 |      | -3   | Storno-Rückmeldung Fertigung |              | BAUGRA_02    | nein      | 6    |
      | BAUGRUPPE | 2    |      | Rückmeldung Fertigung        |              | BAUGRA_02    | nein      | 7    |
      | EINKAUF-1 |      | 4    | Rückmeldung Fertigung        | ENKA1_02     | BAUGRA_02    | nein      | 8    |
      | EINKAUF-2 |      | 2    | Rückmeldung Fertigung        |              | BAUGRA_02    | nein      | 9    |
      | BAUGRUPPE | 3    |      | Rückmeldung Fertigung        |              | BAUGRA_02    | ja        | 10   |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung        |              | BAUGRA_01    | ja        | 11   |
      | EINKAUF-1 |      | 6    | Rückmeldung Fertigung        | ENKA1_02     | BAUGRA_02    | ja        | 12   |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung        | ENKA1_01     | BAUGRA_01    | ja        | 13   |
      | EINKAUF-2 |      | 3    | Rückmeldung Fertigung        |              | BAUGRA_02    | ja        | 14   |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung        |              | BAUGRA_01    | ja        | 15   |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 11
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 10
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 13
    Then field "stornolj^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 12
    And I close the current editor


  Scenario: A06 Storno einer Rückmeldung auf abgelegten FV mit Projektbezug
# Projekt anlegen
    Given I open an editor "PROJEKT_A" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT_A"
    And I set fields
      | such | PROJEKT_A |
    And I save the current editor

# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A06"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A06"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A06"

# Auftrag anlegen und Bedarfe einkaufen
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I append rows
      | artikel   | mge | projekt   |
      | BAUGRUPPE | 20  | PROJEKT_A |
    And I save the current editor

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | fakt   | ja      |
      | ebeleg | A06R    |
      | ueb    | ja      |
    And I append rows
      | artikel   | mge | projekt   |
      | EINKAUF-1 | 40  | PROJEKT_A |
      | EINKAUF-2 | 20  | PROJEKT_A |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "JA" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | projekt   | mfreig | bisuch       |
      | BAUGRUPPE | 20  | PROJEKT_A | ja     | SCENARIOA06_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA06_001"
    And I set fields
      | sofort | 1   |
      | bzeit  | 1,5 |
      | mzeit  | 1,5 |
      | gut    | 1   |
    And I save the current editor

# Bewertung Rückmeldung1 und Bestand prüfen
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=`;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | projekt   | kopfzugvorg^id   |
      | 20    |        |           | (0,0,0)          |
      |       | 20     | PROJEKT_A | !Rückmeldung1^id |
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | projekt   | kopfzugvorg^id |
      | 40    |        |           | (0,0,0)        |
      |       | 40     | PROJEKT_A | !Rechnung^id   |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | projekt   | projektla | storniert | !row |
      | BAUGRUPPE | -20  |      | Storno-Rückmeldung Fertigung | PROJEKT_A | ja        | nein      | 1    |
      | EINKAUF-1 |      | -40  | Storno-Rückmeldung Fertigung | PROJEKT_A | ja        | nein      | 2    |
      | EINKAUF-2 |      | -20  | Storno-Rückmeldung Fertigung | PROJEKT_A | ja        | nein      | 3    |
      | BAUGRUPPE | 20   |      | Rückmeldung Fertigung        | PROJEKT_A | ja        | ja        | 4    |
      | EINKAUF-1 |      | 40   | Rückmeldung Fertigung        | PROJEKT_A | ja        | ja        | 5    |
      | EINKAUF-2 |      | 20   | Rückmeldung Fertigung        | PROJEKT_A | ja        | ja        | 6    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 6
    And I close the current editor


  Scenario: A07 Storno einer Rückmeldung auf BA, abgelegter FV
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A07"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A07"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A07"

# Fertigungsvorschlag anlegen und freigeben, BA-Nummer speichern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch       | mfreig |
      | BAUGRUPPE | 10     | SCENARIOA07_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA07_000"
    And I set fields
      | sofort | 1   |
      | gut    | 1   |
      | mgr    | 112 |
    And I save the current editor

# Bewertung Rückmeldung1 und Bestand prüfen
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

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
      |       | 10     | !Rückmeldung1^id |
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | -20   |        | (0,0,0)          |
      |       | -20    | !Rückmeldung1^id |
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert |
      | BAUGRUPPE | -10  |      | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-1 |      | -20  | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-2 |      | -10  | Storno-Rückmeldung Fertigung | nein      |
      | BAUGRUPPE | 10   |      | Rückmeldung Fertigung        | ja        |
      | EINKAUF-1 |      | 20   | Rückmeldung Fertigung        | ja        |
      | EINKAUF-2 |      | 10   | Rückmeldung Fertigung        | ja        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 6
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "banummer" to "barmex" from editor "Rückmeldung1"
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then table has values
      | mge | limge |
      | 10  | 0     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then table has values
      | limge | gmge | elex       |
      | 0     | 20   | EINKAUF-1  |
      | 0     | 10   | EINKAUF-2  |
      | 0     | 0    | A MONTAGE1 |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor


  Scenario: A08 Storno auf abgelegten FV mit Koppelprodukt
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BG-KOPPEL" on StorageLocation "F1" with document "BK0-BG-A07"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A07"
    Given I set StorageQuantity to zero for Product "KOPPELPROD" on StorageLocation "F2" with document "BK0-BG-A07"

# Fertigungsvorschlag anlegen und freigeben, BA-Nummer speichern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch       | mfreig |
      | BG-KOPPEL | 10     | SCENARIOA08_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SCENARIOA08_000"
    And I save value from field "nummer" in row 0
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA08_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Bewertung Rückmeldung1 und Bestand prüfen
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=KOPPELPROD;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-KOPPEL |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 10    |        | (0,0,0)          |
      |       | 10     | !Rückmeldung1^id |
    And I set fields
      | artikel    | KOPPELPROD |
      | klplatz    | F2         |
      | verdichten | nein       |
      | details    | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 10    |        | (0,0,0)          |
      |       | 10     | !Rückmeldung1^id |
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-KOPPEL |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I set fields
      | artikel    | KOPPELPROD |
      | verdichten | ja         |
      | details    | nein       |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | amge | detursache                   | storniert |
      | BG-KOPPEL  | -10  |      | Storno-Rückmeldung Fertigung | nein      |
      | KOPPELPROD | -10  |      | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-1  |      | -20  | Storno-Rückmeldung Fertigung | nein      |
      | BG-KOPPEL  | 10   |      | Rückmeldung Fertigung        | ja        |
      | KOPPELPROD | 10   |      | Rückmeldung Fertigung        | ja        |
      | EINKAUF-1  |      | 20   | Rückmeldung Fertigung        | ja        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 6
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then table has values
      | mge | limge |
      | 10  | 0     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then table has values
      | limge | gmge | elex       |
      | 0     | 10   | KOPPELPROD |
      | 0     | 20   | EINKAUF-1  |
      | 0     | 0    | A MONTAGE1 |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor


  Scenario: A09 Storno auf abgelegten FV mit Behältern
# Behälter anlegen
    Given I create a Container "A09_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "A09_MATERIAL2" for packaging material "BEHAELTER"
    Given I create a Container "A09_GUTMGE1" for packaging material "BEHAELTER"
    Given I create a Container "A09_GUTMGE2" for packaging material "BEHAELTER"

# Bestand auf 0 korrigieren und Bedarf in Behälter buchen
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A09"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A09"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A09"

    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | EINKAUF-1 |
      | beleg   | A09       |
      | beldat  | .         |
      | buart   | Zugang    |
    And I append rows
      | mge | platz2 | behaelter         |
      | 10  | F1     | !A09_MATERIAL1^id |
      | 10  | F1     | !A09_MATERIAL2^id |
    And I save the current editor

# Fertigungsvorschlag mit MZ anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BAUGRUPPE | 10     | ja     |
    And I press button "mzsubm" to open a subeditor for "FertigteilMZ" in row !lastRow
    And I modify table
      | !row | zuomge | behaelter       |
      | +1   | 5      | !A09_GUTMGE1^id |
      | +2   | 5      | !A09_GUTMGE2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | behaelter         |
      | +1   | 10     | !A09_MATERIAL1^id |
      | +2   | 10     | !A09_MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "SCENARIOA09_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA09_001"
    And I set fields
      | sofort | 1   |
      | bzeit  | 1,5 |
      | mzeit  | 1,5 |
    And I set field "gutmge" to "8" in row 1
    And I save the current editor
    And I set the fake date to "6.1.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA09_001"
    And I set fields
      | sofort | 1   |
      | bzeit  | 1,5 |
      | mzeit  | 1,5 |
    And I set field "gutmge" to "2" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | BAUGRUPPE |
      | klplatz   | F1        |
      | behaelter | ja        |
      | details   | nein      |
    And I press start
    Then table has values
      | gebmge | tbehaelter^id   |
      | 5      | !A09_GUTMGE1^id |
      | 5      | !A09_GUTMGE2^id |
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Bestand und Behälter prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | BAUGRUPPE |
      | klplatz   | F1        |
      | behaelter | ja        |
      | details   | nein      |
    And I press start
    Then table has values
      | gebmge | tbehaelter^id   |
      | 2      | !A09_GUTMGE2^id |
    And I set field "behaelter" to "nein"
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then field "kopfzugvorg^id" has value "!Rückmeldung2^id" in row 2
    And I set fields
      | artikel   | EINKAUF-1 |
      | klplatz   | F1        |
      | behaelter | ja        |
      | details   | nein      |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | tbehaelter^id     |
      | 10     | !A09_MATERIAL1^id |
      | 6      | !A09_MATERIAL2^id |
    And I close the current editor

    Then Container from editor "A09_GUTMGE1" is empty
    And I switch the current editor to editor "A09_GUTMGE2" with command "VIEW"
    Then fields have values
      | behleer     | nein |
      | behstatusaz |      |
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | BAUGRUPPE | 2   |
    And I close the current editor
    And I switch the current editor to editor "A09_MATERIAL1" with command "VIEW"
    Then fields have values
      | behleer     | nein |
      | behstatusaz |      |
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 10  |
    And I close the current editor
    And I switch the current editor to editor "A09_MATERIAL2" with command "VIEW"
    Then fields have values
      | behleer     | nein |
      | behstatusaz |      |
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 6   |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | behaelter^such | storniert | !row |
      | BAUGRUPPE | -5   |      | Storno-Rückmeldung Fertigung | A09_GUTMGE1    | nein      | 1    |
      | BAUGRUPPE | -3   |      | Storno-Rückmeldung Fertigung | A09_GUTMGE2    | nein      | 2    |
      | EINKAUF-1 |      | -10  | Storno-Rückmeldung Fertigung | A09_MATERIAL1  | nein      | 3    |
      | EINKAUF-1 |      | -6   | Storno-Rückmeldung Fertigung | A09_MATERIAL2  | nein      | 4    |
      | EINKAUF-2 |      | -8   | Storno-Rückmeldung Fertigung |                | nein      | 5    |
      | BAUGRUPPE | 2    |      | Rückmeldung Fertigung        | A09_GUTMGE2    | nein      | 6    |
      | EINKAUF-1 |      | 4    | Rückmeldung Fertigung        | A09_MATERIAL2  | nein      | 7    |
      | EINKAUF-2 |      | 2    | Rückmeldung Fertigung        |                | nein      | 8    |
      | BAUGRUPPE | 3    |      | Rückmeldung Fertigung        | A09_GUTMGE2    | ja        | 9    |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung        | A09_GUTMGE1    | ja        | 10   |
      | EINKAUF-1 |      | 6    | Rückmeldung Fertigung        | A09_MATERIAL2  | ja        | 11   |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung        | A09_MATERIAL1  | ja        | 12   |
      | EINKAUF-2 |      | 8    | Rückmeldung Fertigung        |                | ja        | 13   |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 10
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 9
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 12
    Then field "stornolj^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 11
    Then field "stornolj^id" in row 5 has value equal to field "verweis^id" from editor "LJ" in row 13
    And I close the current editor


  Scenario: A10 Storno auf abgelegten FV mit zusätzlichem Material
    And I set the fake date to "6.1.95"

# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-3" on StorageLocation "F1" with document "BK0-BG-A09"

# Fertigungsvorschlag anlegen und freigeben, BA-Nummer speichern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch       | mfreig |
      | BAUGRUPPE | 10     | SCENARIOA10_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang mit zusätzlichem Material EINKAUF-3
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA10_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I append rows
      | artikel   | mge |
      | EINKAUF-3 | 5   |
    And I save the current editor

# Bewertung Rückmeldung1 und Bestand prüfen
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-3;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-3 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | -5    |        | (0,0,0)          |
      |       | -5     | !Rückmeldung1^id |
    And I close the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-3 |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert | !row |
      | BAUGRUPPE | -10  |      | Storno-Rückmeldung Fertigung | nein      | 1    |
      | EINKAUF-1 |      | -20  | Storno-Rückmeldung Fertigung | nein      | 2    |
      | EINKAUF-2 |      | -10  | Storno-Rückmeldung Fertigung | nein      | 3    |
      | EINKAUF-3 |      | -5   | Storno-Rückmeldung Fertigung | nein      | 4    |
      | BAUGRUPPE | 10   |      | Rückmeldung Fertigung        | ja        | 5    |
      | EINKAUF-1 |      | 20   | Rückmeldung Fertigung        | ja        | 6    |
      | EINKAUF-2 |      | 10   | Rückmeldung Fertigung        | ja        | 7    |
      | EINKAUF-3 |      | 5    | Rückmeldung Fertigung        | ja        | 8    |
    Then field "stornolj^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 8
    And I close the current editor


  Scenario: A11 Storno einer Rückmeldung auf abgelegten FV mit Einheiten
    And I set the fake date to "6.1.95"

# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BG-EINHEITEN" on StorageLocation "F1" with document "BK0-BG-A09"
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "BK0-BG-A09"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "BK0-BG-A09"

# Bedarfe einkaufen
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER     |
      | vom    | .           |
      | ebeleg | RechnungA02 |
      | ueb    | ja          |
    And I append rows
      | artikel    | mge |
      | GEBINDE    | 50  |
      | GEBINDEPFL | 5   |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben, BA-Nummer speichern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch       | mfreig |
      | BG-EINHEITEN | 10     | SCENARIOA11_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SCENARIOA11_000"
    And I save value from field "nummer" in row 0
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA11_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Erste Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITEN |
      | klplatz    | F1           |
      | verdichten | ja           |
      | details    | nein         |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | verdichten | nein    |
      | details    | nein    |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | geinheit | kopfzugvorg^id |
      | 10    |        |          | (0,0,0)        |
      |       | 10     | Stück    | !Rechnung^id   |
    And I set fields
      | artikel    | GEBINDEPFL |
      | klplatz    | F1         |
      | verdichten | nein       |
      | details    | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | gebf | kopfzugvorg^id |
      | 10    | Stück    |        |          |      | (0,0,0)        |
      |       |          | 5      | Paar     | 2    | !Rechnung^id   |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | zmge | amge | mei   | detursache                   | storniert |
      | BG-EINHEITEN | -10  |      | Stück | Storno-Rückmeldung Fertigung | nein      |
      | GEBINDE      |      | -10  | Stück | Storno-Rückmeldung Fertigung | nein      |
      | GEBINDEPFL   |      | -10  | Stück | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-1    |      | -10  | Stück | Storno-Rückmeldung Fertigung | nein      |
      | BG-EINHEITEN | 10   |      | Stück | Rückmeldung Fertigung        | ja        |
      | GEBINDE      |      | 10   | Stück | Rückmeldung Fertigung        | ja        |
      | GEBINDEPFL   |      | 10   | Stück | Rückmeldung Fertigung        | ja        |
      | EINKAUF-1    |      | 10   | Stück | Rückmeldung Fertigung        | ja        |
    And I close the current editor


  Scenario: A12 Storno einer Nachbuchung auf abgelegten FV
    And I set the fake date to "6.1.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A12"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A12"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A12"

# Auftrag anlegen und Bestände einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER     |
      | vom    | .           |
      | ebeleg | RechnungA02 |
      | ueb    | ja          |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben, BA-Nummer speichern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch       | mfreig |
      | BAUGRUPPE | 10     | SCENARIOA12_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA12_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Nachbuchen auf abgelegten FV
    Given I open an editor "Nachbuchen1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | mge         | gutmge      | !row |
      | !dontChange | 1           | 1    |
      | 1           | !dontChange | 2    |
    And I save the current editor

# Bewertung Rückmeldung1 und Bestand prüfen
    Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "ppsrefid^vorgang^id" has value equal to field "id" from editor "Nachbuchen1"
    And I close the current editor

# Nachbuchung stornieren
    Given I open an editor "Storno1" via ID from editor "Nachbuchen1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "typa279" has value "Storno-Rückmeldung auf abgelegten Fertigungsvorschlag"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Nachbuchen1" in row 0

# Berwertung hat Nachfolger
    Given I switch the current editor to editor "Bewertung" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "10" in row 1
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert | !row |
      | BAUGRUPPE | -1   |      | Storno-Rückmeldung Fertigung | nein      | 1    |
      | EINKAUF-1 |      | -1   | Storno-Rückmeldung Fertigung | nein      | 2    |
      | BAUGRUPPE | 1    |      | Rückmeldung Fertigung        | ja        | 3    |
      | EINKAUF-1 |      | 1    | Rückmeldung Fertigung        | ja        | 4    |
      | BAUGRUPPE | 10   |      | Rückmeldung Fertigung        | nein      | 5    |
      | EINKAUF-1 |      | 20   | Rückmeldung Fertigung        | nein      | 6    |
      | EINKAUF-2 |      | 10   | Rückmeldung Fertigung        | nein      | 7    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# Auftrag liefern
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A12"


  Scenario: A13 Storno einer Rückmeldung auf abgelegten FV, zu dem es Nachbuchungen gibt
    And I set the fake date to "6.1.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A13"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A13"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A13"

# Fertigungsvorschlag anlegen und freigeben, BA-Nummer speichern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch       | mfreig |
      | BAUGRUPPE | 10     | SCENARIOA12_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA12_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Nachbuchen auf abgelegten FV
    Given I open an editor "Nachbuchen1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | mge         | gutmge      | !row |
      | !dontChange | 1           | 1    |
      | 1           | !dontChange | 2    |
    And I save the current editor

# Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "1" in row 1
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "-1" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert | !row |
      | BAUGRUPPE | -10  |      | Storno-Rückmeldung Fertigung | nein      | 1    |
      | EINKAUF-1 |      | -20  | Storno-Rückmeldung Fertigung | nein      | 2    |
      | EINKAUF-2 |      | -10  | Storno-Rückmeldung Fertigung | nein      | 3    |
      | BAUGRUPPE | 1    |      | Rückmeldung Fertigung        | nein      | 4    |
      | EINKAUF-1 |      | 1    | Rückmeldung Fertigung        | nein      | 5    |
      | BAUGRUPPE | 10   |      | Rückmeldung Fertigung        | ja        | 6    |
      | EINKAUF-1 |      | 20   | Rückmeldung Fertigung        | ja        | 7    |
      | EINKAUF-2 |      | 10   | Rückmeldung Fertigung        | ja        | 8    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 8
    And I close the current editor


# FDA-3185
  Scenario: A14 Nachbuchen auf abgelegten FV wenn alle Rueckmeldungen storniert wurden, RM auf BA, stornierte RM als Vorlage
    And I set the fake date to "6.1.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A14"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A14"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A14"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | A14_   | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrueckmeldung auf BA
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "A14_000"
    And I set fields
      | sofort | 1   |
      | gut    | 1   |
      | mgr    | 112 |
    And I save the current editor

# Rueckmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rueckmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rueckmeldung1" in row 0

# Nachbuchen auf abgelegten FV, stornierte Rueckmeldung als Vorlage
    Given I open an editor "Nachbuchen1" via ID from editor "Rueckmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    Then field "typa279" has value "Rückmeldung auf abgelegten Fertigungsvorschlag"
    Then table has values
      | !row | artikel   | mge         | gutmge      | verlustmge  |
      | 1    | BAUGRUPPE | !dontChange | 0           | 0           |
      | 2    | EINKAUF-1 | 0           | !dontChange | !dontChange |
      | 3    | EINKAUF-2 | 0           | !dontChange | !dontChange |
    And I modify table
      | mge         | gutmge      | !row |
      | !dontChange | 1           | 1    |
      | 1           | !dontChange | 2    |
    And I save the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "1" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rueckmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert | !row |
      | BAUGRUPPE | 1    |      | Rückmeldung Fertigung        | nein      | 1    |
      | EINKAUF-1 |      | 1    | Rückmeldung Fertigung        | nein      | 2    |
      | BAUGRUPPE | -10  |      | Storno-Rückmeldung Fertigung | nein      | 3    |
      | EINKAUF-1 |      | -20  | Storno-Rückmeldung Fertigung | nein      | 4    |
      | EINKAUF-2 |      | -10  | Storno-Rückmeldung Fertigung | nein      | 5    |
      | BAUGRUPPE | 10   |      | Rückmeldung Fertigung        | ja        | 6    |
      | EINKAUF-1 |      | 20   | Rückmeldung Fertigung        | ja        | 7    |
      | EINKAUF-2 |      | 10   | Rückmeldung Fertigung        | ja        | 8    |
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "stornolj^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "stornolj^id" in row 5 has value equal to field "verweis^id" from editor "LJ" in row 8
    And I close the current editor


# FDA-3185
  Scenario: A15 Nachbuchen auf abgelegten FV wenn alle Rueckmeldungen storniert wurden, RM auf BA, Storno-RM als Vorlage
    And I set the fake date to "6.1.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A15"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A15"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A15"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | A15_   | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrueckmeldung auf BA
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "A15_000"
    And I set fields
      | sofort | 1   |
      | gut    | 1   |
      | mgr    | 112 |
    And I save the current editor

# Rueckmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rueckmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rueckmeldung1" in row 0

# Nachbuchen auf abgelegten FV, Storno-Rueckmeldung als Vorlage
    Given I open an editor "Nachbuchen1" via ID from editor "Storno1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    Then field "typa279" has value "Rückmeldung auf abgelegten Fertigungsvorschlag"
    Then table has values
      | !row | artikel   | mge         | gutmge      | verlustmge  |
      | 1    | BAUGRUPPE | !dontChange | 0           | 0           |
      | 2    | EINKAUF-1 | 0           | !dontChange | !dontChange |
      | 3    | EINKAUF-2 | 0           | !dontChange | !dontChange |
    And I modify table
      | mge         | gutmge      | !row |
      | !dontChange | 1           | 1    |
      | 1           | !dontChange | 2    |
    And I save the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then field "lemge" has value "1" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rueckmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert | !row |
      | BAUGRUPPE | 1    |      | Rückmeldung Fertigung        | nein      | 1    |
      | EINKAUF-1 |      | 1    | Rückmeldung Fertigung        | nein      | 2    |
      | BAUGRUPPE | -10  |      | Storno-Rückmeldung Fertigung | nein      | 3    |
      | EINKAUF-1 |      | -20  | Storno-Rückmeldung Fertigung | nein      | 4    |
      | EINKAUF-2 |      | -10  | Storno-Rückmeldung Fertigung | nein      | 5    |
      | BAUGRUPPE | 10   |      | Rückmeldung Fertigung        | ja        | 6    |
      | EINKAUF-1 |      | 20   | Rückmeldung Fertigung        | ja        | 7    |
      | EINKAUF-2 |      | 10   | Rückmeldung Fertigung        | ja        | 8    |
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "stornolj^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "stornolj^id" in row 5 has value equal to field "verweis^id" from editor "LJ" in row 8
    And I close the current editor


# FDA-3185
  Scenario: A16A Nachbuchen auf abgelegten FV, RM auf AS, Abschluss-RM als Vorlage

    And I set the fake date to "6.1.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A16A"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A16A"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A16A"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | A16A_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Teilrueckmeldung auf AS
    Given I open an editor "RueckmeldungAS" from table "(Workorder):(WorkOrders)" with command "DONE" for record "A16A_001"
    And I set fields
      | sofort | 1   |
      | mgr    | 112 |
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

# Abschluss-Rueckmeldung erzeugen
    Given I open an editor "RueckmeldungAS" from table "(Workorder):(WorkOrders)" with command "DONE" for record "A16A_001"
    And I set fields
      | sofort | 1   |
      | gut    | 1   |
      | mgr    | 112 |
    And I save the current editor

# Nachbuchen auf abgelegten FV, Abschluss-Rueckmeldung als Vorlage
    Given I open an editor "Nachbuchen1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=A16A_000;abschluss=j;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    Then field "typa279" has value "Rückmeldung auf abgelegten Fertigungsvorschlag"
    Then table has values
      | !row | artikel   | mge         | gutmge      | verlustmge  |
      | 1    | BAUGRUPPE | !dontChange | 0           | 0           |
      | 2    | EINKAUF-1 | 0           | !dontChange | !dontChange |
      | 3    | EINKAUF-2 | 0           | !dontChange | !dontChange |
    And I set field "mgr" to "112"
    And I modify table
      | mge         | gutmge      | !row |
      | !dontChange | 1           | 1    |
      | 1           | !dontChange | 2    |
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!RueckmeldungAS^barmex"
    And I press start
    Then the table has 6 rows
    Then table has values
      | art       | zmge | amge | detursache            |
      | EINKAUF-2 |      | 8    | Rückmeldung Fertigung |
      | EINKAUF-1 |      | 16   | Rückmeldung Fertigung |
      | BAUGRUPPE | 8    |      | Rückmeldung Fertigung |
      | EINKAUF-2 |      | 2    | Rückmeldung Fertigung |
      | EINKAUF-1 |      | 4    | Rückmeldung Fertigung |
      | BAUGRUPPE | 2    |      | Rückmeldung Fertigung |
    And I set field "beleg" to "!Nachbuchen1^barmex"
    And I press start
    Then the table has 2 rows
    Then table has values
      | art       | zmge | amge | detursache            |
      | EINKAUF-1 |      | 1    | Rückmeldung Fertigung |
      | BAUGRUPPE | 1    |      | Rückmeldung Fertigung |
    And I close the current editor


# FDA-3185
  Scenario: A16B Nachbuchen auf abgelegten FV, RM auf AS, mit Status abschliessen, Abschluss-RM als Vorlage

    And I set the fake date to "6.1.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A16B"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A16B"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A16B"

# Fertigungsvorschlag anlegen und freigeben, BA-Nummer speichern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | A16B_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Teilrueckmeldung auf AS
    Given I open an editor "Rueckmeldung1AS" from table "(Workorder):(WorkOrders)" with command "DONE" for record "A16B_001"
    And I set fields
      | sofort | 1   |
      | mgr    | 112 |
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

# Abschluss-Rueckmeldung mit Statuskennzeichen
    Given I open an editor "Rueckmeldung2AS" from table "(Workorder):(WorkOrders)" with command "DONE" for record "A16B_001"
    And I set fields
      | sofort | 1   |
      | mgr    | 112 |
    And I set field "status" to "S" in row 1
    And I save the current editor

# Nachbuchen auf abgelegten FV, Abschluss-Rueckmeldung als Vorlage
    Given I open an editor "Nachbuchen1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=A16B_000;abschluss=j;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    Then field "typa279" has value "Rückmeldung auf abgelegten Fertigungsvorschlag"
    Then table has values
      | !row | artikel   | mge         | gutmge      | verlustmge  |
      | 1    | BAUGRUPPE | !dontChange | 0           | 0           |
      | 2    | EINKAUF-1 | 0           | !dontChange | !dontChange |
      | 3    | EINKAUF-2 | 0           | !dontChange | !dontChange |
    And I set field "mgr" to "112"
    And I modify table
      | mge         | gutmge      | !row |
      | !dontChange | 1           | 1    |
      | 1           | !dontChange | 2    |
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rueckmeldung1AS^barmex"
    And I press start
    Then the table has 3 rows
    Then table has values
      | art       | zmge | amge | detursache            |
      | EINKAUF-2 |      | 1    | Rückmeldung Fertigung |
      | EINKAUF-1 |      | 2    | Rückmeldung Fertigung |
      | BAUGRUPPE | 1    |      | Rückmeldung Fertigung |
    And I set field "beleg" to "!Nachbuchen1^barmex"
    And I press start
    Then the table has 2 rows
    Then table has values
      | art       | zmge | amge | detursache            |
      | EINKAUF-1 |      | 1    | Rückmeldung Fertigung |
      | BAUGRUPPE | 1    |      | Rückmeldung Fertigung |
    And I close the current editor


# FDA-3185
  Scenario: A17 Nachbuchen auf abgelegten FV wenn alle Rueckmeldungen storniert wurden, Zeitbuchung als Vorlage

    And I set the fake date to "6.1.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-A17"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-A17"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-A17"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | A17_   | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Zeitbuchung auf BA
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "A17_000"
    And I set fields
      | mgr    | 112  |
      | ma     | Karl |
      | lgr    | 1    |
      | bzeit  | 2    |
      | mzeit  | 1    |
      | sofort | ja   |
    And I save the current editor

# Komplettrueckmeldung auf BA
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "A17_000"
    And I set fields
      | sofort | 1   |
      | gut    | 1   |
      | mgr    | 112 |
    And I save the current editor

# Rueckmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rueckmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rueckmeldung1" in row 0

# Nachbuchen auf abgelegten FV, Zeitbuchung als Vorlage
    Given I open an editor "Nachbuchen1" via ID from editor "Zeitbuchung" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    Then field "typa279" has value "Rückmeldung auf abgelegten Fertigungsvorschlag"
    Then table has values
      | !row | artikel   | mge         | gutmge      | verlustmge  |
      | 1    | BAUGRUPPE | !dontChange | 0           | 0           |
      | 2    | EINKAUF-1 | 0           | !dontChange | !dontChange |
      | 3    | EINKAUF-2 | 0           | !dontChange | !dontChange |
    And I modify table
      | mge         | gutmge      | !row |
      | !dontChange | 1           | 1    |
      | 1           | !dontChange | 2    |
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rueckmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert |
      | BAUGRUPPE | 1    |      | Rückmeldung Fertigung        | nein      |
      | EINKAUF-1 |      | 1    | Rückmeldung Fertigung        | nein      |
      | BAUGRUPPE | -10  |      | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-1 |      | -20  | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-2 |      | -10  | Storno-Rückmeldung Fertigung | nein      |
      | BAUGRUPPE | 10   |      | Rückmeldung Fertigung        | ja        |
      | EINKAUF-1 |      | 20   | Rückmeldung Fertigung        | ja        |
      | EINKAUF-2 |      | 10   | Rückmeldung Fertigung        | ja        |
    And I close the current editor


  Scenario: 100 Storno einer Rückmeldung nur mit Zeiten (Bugfix: offene Menge in vorangegangener AG-RES wird erhöht)

    Given I open an editor "BG-LANG" from table "(Part):(Product)" with command "STORE" for record "BG-LANG"
    And I set fields
      | such      | BG-LANG           |
      | namebspr  | BG mit langer STL |
      | dispoa    | auftragsbezogen   |
      | bsart     | Eigenfertigung    |
      | chverfolgung |                |
    And I delete all rows
    And I append rows
      | elex       | anzahl | manbu       |
      | EINK       | 1      | nein        |
      | A AG1      | 1      | !dontChange |
      | E2         | 1      | nein        |
      | A AG2      | 1      | !dontChange |
      | E3         | 1      | nein        |
      | A AG3      | 1      | !dontChange |
      | A BOHR     | 1      | !dontChange |
      | A DREH     | 1      | !dontChange |
      | A MONTAGE1 | 1      | !dontChange |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch   | mfreig |
      | BG-LANG | 1      | AGLIMGE_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag öffnen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "AGLIMGE_000"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang - Menge und Zeit
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AGLIMGE_001"
    And I set field "sofort" to "1"
    And I set field "bzeit" to "1"
    And I set field "mzeit" to "1"
    And I set field "gut" to "ja"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang - Menge und Zeit
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AGLIMGE_002"
    And I set field "sofort" to "1"
    And I set field "bzeit" to "2"
    And I set field "mzeit" to "2"
    And I set field "gut" to "ja"
    And I save the current editor

# Rückmeldung auf fünften Arbeitsgang - nur Zeit
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AGLIMGE_005"
    And I set field "sofort" to "1"
    And I set field "bzeit" to "5"
    And I set field "mzeit" to "5"
    And I save the current editor

# Dritte Rückmeldung stornieren
    Given I open an editor "StornoAS5" via ID from editor "Rückmeldung3" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung3" in row 0

# BA öffnen und in die AFL abzusteigen und die Mengen zu prüfen
    Given I open an editor "BAPRUEF" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "AGLIMGE_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex       | mge | limge | frgmge |
      | EINK       | 1   | 0     | 0      |
      | A AG1      | 1   | 0     | 0      |
      | E2         | 1   | 0     | 0      |
      | A AG2      | 1   | 0     | 0      |
      | E3         | 1   | 1     | 1      |
      | A AG3      | 1   | 1     | 1      |
      | A BOHR     | 1   | 1     | 1      |
      | A DREH     | 1   | 1     | 1      |
      | A MONTAGE1 | 1   | 1     | 1      |
    And I close the current editor
    And I switch the current editor to editor "BAPRUEF"
    And I close the current editor

############################################################
## neues Scenario für FDA-3340

  Scenario: 200 Storno einer Teil-Rückmeldung, zusaetzliche Zeile mit Ausschuss und Nacharbeit

# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN_200"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | AUS_NACH_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag öffnen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "AUS_NACH_000"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang, zusaetzliche Entnahme mit Ausschuss und Nacharbeit
    Given I set the fake date to "5.1.95"
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUS_NACH_001"
    And I set field "sofort" to "1"
    And I set field "bzeit" to "1"
    And I set field "mzeit" to "1"
    And I set field "gutmge" to "5" in row 1
#And I create a new row at the end of the table
    And I append rows
      | artikel | mge | verlustmge | namge |
      | E3      | 1   | 1          | 1     |
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
      | art       | zmge | amge | detursache                   | storniert |
      | BAUGRUPPE | -5   |      | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-1 |      | -10  | Storno-Rückmeldung Fertigung | nein      |
      | EINKAUF-2 |      | -5   | Storno-Rückmeldung Fertigung | nein      |
      | E3        |      | -1   | Storno-Rückmeldung Fertigung | nein      |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung        | ja        |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung        | ja        |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung        | ja        |
      | E3        |      | 1    | Rückmeldung Fertigung        | ja        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "stornolj^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 8
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "AUS_NACH_000"
    Then field "mge" has value "10"
    Then field "gutmgeauto" has value "0"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "20" in row 1
    Then field "limge" has value "10" in row 2
    Then field "limge" has value "10" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

##############################
## neues Scenario für FDA-3340

  Scenario: 201 Rückbau bei einer Teil-Rückmeldung, zusaetzliche Zeile mit Ausschuss und Nacharbeit

# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN_201"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | AUS_RB_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag öffnen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "AUS_RB_000"
    And I close the current editor


# Rückmeldung auf ersten Arbeitsgang, zusaetzliche Entnahme mit Ausschuss und Nacharbeit
    Given I set the fake date to "5.1.95"
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUS_RB_001"
    And I set field "sofort" to "1"
    And I set field "bzeit" to "1"
    And I set field "mzeit" to "1"
    And I set field "gutmge" to "5" in row 1
    And I append rows
      | artikel | mge | verlustmge | namge |
      | E3      | 1   | 1          | 1     |
    And I save the current editor

# Rueckbau buchen
    Given I open an editor "Rueckbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "AUS_RB_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "-1" in row 1
    Then field "artikel" has value "E3" in row 2
    And I set field "verlustmge" to "-5" in row 2
    And I save the current editor

# RM-Beleg Rueckbau pruefen
    Given I switch the current editor to editor "Rueckbau1" with command "VIEW"
    Then table has values
      | artikel   | mge | gutmge | verlustmge |
      | BAUGRUPPE | 5   | -1     | 0          |
      | E3        | 0   | 0      | -5         |
      | EINKAUF-2 | -1  | 0      | 0          |
      | EINKAUF-1 | -2  | 0      | 0          |
    And I close the current editor

# Lagerjournaleintrag prüfen, Ausschuss zusaetzliche Entnahme wurde nicht gebucht
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache            |
      | BAUGRUPPE | -1   |      | Rückbau Fertigung     |
      | EINKAUF-1 |      | -2   | Rückbau Fertigung     |
      | EINKAUF-2 |      | -1   | Rückbau Fertigung     |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung |
      | E3        |      | 1    | Rückmeldung Fertigung |
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "AUS_RB_000"
    Then field "mge" has value "6"
    Then field "gutmgeauto" has value "4"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "12" in row 1
    Then field "limge" has value "6" in row 2
    Then field "limge" has value "6" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I save the current editor

# Rueckbau stornieren
    Given I open an editor "Storno1" via ID from editor "Rueckbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rueckbau1" in row 0

# Lagerjournaleintrag prüfen, Ausschuss zusaetzliche Entnahme wurde nicht gebucht
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache               | storniert |
      | BAUGRUPPE | 1    |      | Storno-Rückbau Fertigung | nein      |
      | EINKAUF-1 |      | 2    | Storno-Rückbau Fertigung | nein      |
      | EINKAUF-2 |      | 1    | Storno-Rückbau Fertigung | nein      |
      | BAUGRUPPE | -1   |      | Rückbau Fertigung        | ja        |
      | EINKAUF-1 |      | -2   | Rückbau Fertigung        | ja        |
      | EINKAUF-2 |      | -1   | Rückbau Fertigung        | ja        |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung    | nein      |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung    | nein      |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung    | nein      |
      | E3        |      | 1    | Rückmeldung Fertigung    | nein      |
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "AUS_RB_000"
    Then field "mge" has value "5"
    Then field "gutmgeauto" has value "5"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "10" in row 1
    Then field "limge" has value "5" in row 2
    Then field "limge" has value "5" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

##############################
## neues Scenario für FDA-3340

  Scenario: 202 Rückbau nur zusaetzliche Zeile mit Ausschuss und Nacharbeit, Rückbau stornieren

# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN_201"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch      | mfreig |
      | BAUGRUPPE | 10     | AUSNACH_RB_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag öffnen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "AUSNACH_RB_000"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang, zusaetzliche Entnahme mit Ausschuss und Nacharbeit
    Given I set the fake date to "5.1.95"
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUSNACH_RB_001"
    And I set field "sofort" to "1"
    And I set field "bzeit" to "1"
    And I set field "mzeit" to "1"
    And I set field "gutmge" to "5" in row 1
    And I append rows
      | artikel | mge | verlustmge | namge |
      | E3      | 1   | 1          | 1     |
    And I save the current editor

# Rueckbau buchen, zusaetzliche Zeile, sonst keine Mengen rueckbauen
    Given I open an editor "Rueckbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "AUSNACH_RB_001"
    And I set fields
      | sofort | ja |
    And I append rows
      | artikel | mge | verlustmge | namge |
      | E1      |     | -5         | -1    |
    And I save the current editor

# RM-Beleg Rueckbau pruefen
    Given I switch the current editor to editor "Rueckbau1" with command "VIEW"
    Then table has values
      | artikel   | mge | gutmge | verlustmge | namge |
      | BAUGRUPPE | 5   | 0      | 0          | 0     |
      | E3        | 0   | 0      | 0          | 0     |
      | E1        | 0   | 0      | -5         | -1    |
    And I close the current editor

# Lagerjournaleintrag prüfen, Ausschuss zusaetzliche Entnahme wurde nicht gebucht
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache            |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung |
      | E3        |      | 1    | Rückmeldung Fertigung |
    And I close the current editor

# Rueckbau stornieren
    Given I open an editor "Storno1" via ID from editor "Rueckbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rueckbau1" in row 0

# Lagerjournaleintrag prüfen, Storno zusaetzliche Entnahme wurde nicht gebucht
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache            |
      | BAUGRUPPE | 5    |      | Rückmeldung Fertigung |
      | EINKAUF-1 |      | 10   | Rückmeldung Fertigung |
      | EINKAUF-2 |      | 5    | Rückmeldung Fertigung |
      | E3        |      | 1    | Rückmeldung Fertigung |
    And I close the current editor

# Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "AUSNACH_RB_000"
    Then field "mge" has value "5"
    Then field "gutmgeauto" has value "5"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "10" in row 1
    Then field "limge" has value "5" in row 2
    Then field "limge" has value "5" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

###################################################
## 2 neue Scenarien fuer FDA-3908

  Scenario: N01 autorm=nein, Storno auf letzten Arbeitsschein ist moeglich und bucht keine Gutmenge
## FDA-3908
# autorm in der Konfig ausschalten
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set field "autorm" to "nein"
    And I save the current editor

    And I set the fake date to "6.2.95"

# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE2" on StorageLocation "F1" with document "BK0-BG-N01"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-N01"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-N01"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch | binoloe | mfreig |
      | BAUGRUPPE2 | 10     | N01_   | ja      | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrueckmeldung auf BA, Gutmenge wird zugebucht
    Given I open an editor "RM_BA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "N01_000"
    And I set fields
      | sofort | 1   |
      | gut    | 1   |
      | mgr    | 112 |
    And I save the current editor

# Komplettrueckmeldung auf AS2, es wird keine Gutmenge mehr zugebucht, nur Material zu AS2 wird abgebucht
    Given I open an editor "RM_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "N01_002"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Loeschschutz entfernen, bucht restliches Material ab
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "N01_000"
    And I set field "noloesch" to "nein"
    And I save the current editor

# Rueckmeldung auf BA stornieren, bucht Gutmenge wieder ab
    Given I open an editor "StornoBA" via ID from editor "RM_BA" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "RM_BA" in row 0

# Rueckmeldung auf AS2 stornieren, es wird keine Gutmenge abgebucht, aber Material zurueckgebucht
    Given I open an editor "StornoAS" via ID from editor "RM_AS2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "RM_AS2" in row 0

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE2 |
      | klplatz    | F1         |
      | verdichten | ja         |
      | details    | nein       |
    And I press start
    Then the table has 1 rows
    Then field "lemge" is empty in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "RM_BA"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | amge | detursache                   | storniert | !row |
      | BAUGRUPPE2 | -10  |      | Storno-Rückmeldung Fertigung | nein      | 1    |
      | EINKAUF-1  |      | 20   | Rückmeldung Fertigung        | nein      | 2    |
      | BAUGRUPPE2 | 10   |      | Rückmeldung Fertigung        | ja        | 3    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
# Buchungen AS2 pruefen
    And I set field "beleg" to "barmex" from editor "RM_AS2"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert | !row |
      | EINKAUF-2 |      | -10  | Storno-Rückmeldung Fertigung | nein      | 1    |
      | EINKAUF-2 |      | 10   | Rückmeldung Fertigung        | ja        | 2    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I close the current editor


  Scenario: N02 autorm=nein, Storno auf letzten Arbeitsschein ist moeglich und bucht keine Gutmenge
## FDA-3908
    And I set the fake date to "6.2.95"

# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "BAUGRUPPE2" on StorageLocation "F1" with document "BK0-BG-N02"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "BK0-BG-N02"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "BK0-BG-N02"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch | binoloe | mfreig |
      | BAUGRUPPE2 | 10     | N02_   | ja      | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrueckmeldung auf BA, Gutmenge wird zugebucht
    Given I open an editor "RM_BA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "N02_000"
    And I set fields
      | sofort | 1   |
      | gut    | 1   |
      | mgr    | 112 |
    And I save the current editor

# Komplettrueckmeldung auf AS2, es wird keine Gutmenge mehr zugebucht, nur Material zu AS2 wird abgebucht
    Given I open an editor "RM_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "N02_002"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Loeschschutz entfernen, bucht restliches Material ab
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "N02_000"
    And I set field "noloesch" to "nein"
    And I save the current editor

# Rueckmeldung auf AS2 stornieren, es wird keine Gutmenge abgebucht, aber Material zurueckgebucht
    Given I open an editor "StornoAS" via ID from editor "RM_AS2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "RM_AS2" in row 0

# Rueckmeldung auf BA stornieren, bucht Gutmenge wieder ab
    Given I open an editor "StornoBA" via ID from editor "RM_BA" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "RM_BA" in row 0

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE2 |
      | klplatz    | F1         |
      | verdichten | ja         |
      | details    | nein       |
    And I press start
    Then the table has 1 rows
    Then field "lemge" is empty in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "RM_BA"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | amge | detursache                   | storniert | !row |
      | BAUGRUPPE2 | -10  |      | Storno-Rückmeldung Fertigung | nein      | 1    |
      | EINKAUF-1  |      | 20   | Rückmeldung Fertigung        | nein      | 2    |
      | BAUGRUPPE2 | 10   |      | Rückmeldung Fertigung        | ja        | 3    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
# Buchungen AS2 pruefen
    And I set field "beleg" to "barmex" from editor "RM_AS2"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache                   | storniert | !row |
      | EINKAUF-2 |      | -10  | Storno-Rückmeldung Fertigung | nein      | 1    |
      | EINKAUF-2 |      | 10   | Rückmeldung Fertigung        | ja        | 2    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I close the current editor

# autorm in der Konfig wieder anschalten
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set field "autorm" to "ja"
    And I close the current editor

