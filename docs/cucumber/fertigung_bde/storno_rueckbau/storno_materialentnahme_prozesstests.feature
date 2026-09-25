@persistent
Feature: storno_materialentnahme_prozesstests.feature

  Background:
    And I enable the flag 42
    And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : storno_materialentnahme_prozesstests.feature
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet den Storno von Materialentnahmen in der 
#                     Fertigung
#  Jira-Issue       : FDA-542
# *****************************************************************************

## Materialentnahme

  Scenario: 01 Materialentnahme auf ersten Arbeitsschein; keine Gutmenge auf AS, manbu in AFL=ja
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch      | mfreig |
      | M_BAUGRUPPE | 10     | SCENARIO01_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO01_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO01_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel     | mge | gutmge |
      | M_BAUGRUPPE | 10  | 0      |
      | EINKAUF-2   | -10 | 0      |
      | EINKAUF-1   | -20 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 4 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -20  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO01_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 02 Materialentnahme zum Arbeitsschein auf zweiten Arbeitsschein; keine Gutmenge auf AS, manbu in AFL=ja
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch      | mfreig |
      | M_BAUGRUPPE2 | 10     | SCENARIO02_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO02_002;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO02_002;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | artikel      | mge | gutmge |
      | M_BAUGRUPPE2 | 10  | 0      |
      | EINKAUF-2    | -10 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 2 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO02_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex        | limge | frgmge |
      | EINKAUF-1   | 20    | 20     |
      | A SCHRAUBEN | 10    | 10     |
      | EINKAUF-2   | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 03 Materialentnahme zweiter AS, Materialentnahme zum BA über Material laden, keine Rückmeldung auf erstsen AS
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch      | mfreig |
      | M_BAUGRUPPE2 | 10     | SCENARIO03_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO03_002;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stllad"
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO03_002;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel      | mge | gutmge |
      | M_BAUGRUPPE2 | 10  | 0      |
      | EINKAUF-2    | -10 | 0      |
      | EINKAUF-1    | -20 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 4 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -20  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO03_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex        | limge | frgmge |
      | EINKAUF-1   | 20    | 20     |
      | A SCHRAUBEN | 10    | 10     |
      | EINKAUF-2   | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 04 Zusätzliche Materialentnahme auf ersten Arbeitsschein; keine Gutmenge auf BA, manbu in AFL=ja
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch      | mfreig |
      | M_BAUGRUPPE | 10     | SCENARIO04_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO04_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I append rows
      | elex      | bumge |
      | EINKAUF-3 | 10    |
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO04_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 4 rows
    Then table has values
      | artikel     | mge | gutmge |
      | M_BAUGRUPPE | 10  | 0      |
      | EINKAUF-3   | -10 | 0      |
      | EINKAUF-2   | -10 | 0      |
      | EINKAUF-1   | -20 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 6 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -20  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-3 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO04_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 05 Mehrentnahme eines Materials auf ersten Arbeitsschein; keine Gutmenge auf BA, manbu in AFL=ja
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch      | mfreig |
      | M_BAUGRUPPE | 10     | SCENARIO05_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO05_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I set field "bumge" to "50" in row 1
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO05_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel     | mge | gutmge |
      | M_BAUGRUPPE | 10  | 0      |
      | EINKAUF-2   | -10 | 0      |
      | EINKAUF-1   | -50 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 4 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -50  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO05_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 06 Materialentnahme auf ersten Arbeitsschein; keine Gutmenge auf AS, manbu in AFL=nein
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch      | mfreig |
      | BAUGRUPPE | 10     | SCENARIO06_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO06_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO06_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel   | mge | gutmge |
      | BAUGRUPPE | 10  | 0      |
      | EINKAUF-2 | -10 | 0      |
      | EINKAUF-1 | -20 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 4 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -20  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO06_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 07 Materialentnahme zum Arbeitsschein auf zweiten Arbeitsschein; keine Gutmenge auf AS, manbu in AFL=nein
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch      | mfreig |
      | BAUGRUPPE2 | 10     | SCENARIO07_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO07_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO07_002;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gutmge |
      | BAUGRUPPE2 | 10  | 0      |
      | EINKAUF-2  | -10 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 2 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO07_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex        | limge | frgmge |
      | EINKAUF-1   | 20    | 20     |
      | A SCHRAUBEN | 10    | 10     |
      | EINKAUF-2   | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 08 Materialentnahme zum BA auf zweiten Arbeitsschein; keine Gutmenge auf AS, manbu in AFL=nein
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch      | mfreig |
      | BAUGRUPPE2 | 10     | SCENARIO08_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO08_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stllad"
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO08_002;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel    | mge | gutmge |
      | BAUGRUPPE2 | 10  | 0      |
      | EINKAUF-2  | -10 | 0      |
      | EINKAUF-1  | -20 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -20  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO08_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex        | limge | frgmge |
      | EINKAUF-1   | 20    | 20     |
      | A SCHRAUBEN | 10    | 10     |
      | EINKAUF-2   | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 09 Zusätzliche Materialentnahme auf ersten Arbeitsschein; keine Gutmenge auf BA, manbu in AFL=nein
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch      | mfreig |
      | BAUGRUPPE | 10     | SCENARIO09_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO09_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I append rows
      | elex      | bumge |
      | EINKAUF-3 | 10    |
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO09_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 4 rows
    Then table has values
      | artikel   | mge | gutmge |
      | BAUGRUPPE | 10  | 0      |
      | EINKAUF-3 | -10 | 0      |
      | EINKAUF-2 | -10 | 0      |
      | EINKAUF-1 | -20 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 6 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -20  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-3 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO09_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 10 Mehrentnahme eines Materials auf ersten Arbeitsschein; keine Gutmenge auf BA, manbu in AFL=nein
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch      | mfreig |
      | BAUGRUPPE | 10     | SCENARIO10_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO10_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I set field "manbu" to "ja" in row 1
    And I set field "bumge" to "50" in row 1
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO10_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel   | mge | gutmge |
      | BAUGRUPPE | 10  | 0      |
      | EINKAUF-2 | -10 | 0      |
      | EINKAUF-1 | -50 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 4 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -50  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO10_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 11 Materialentnahme auf ersten Arbeitsschein; Gutmenge auf BA, Rückmeldung erster AG, manbu in AFL=ja
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch      | mfreig |
      | M_BAUGRUPPE | 10     | SCENARIO11_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIO11_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO11_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO11_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel     | mge | gutmge |
      | M_BAUGRUPPE | 5   | 0      |
      | EINKAUF-2   | -10 | 0      |
      | EINKAUF-1   | -20 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 5 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -20  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO11_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 12 Materialentnahme auf zweiten Arbeitsschein; Gutmenge auf BA, Rückmeldung erster AG, manbu in AFL=ja
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch      | mfreig |
      | M_BAUGRUPPE | 10     | SCENARIO12_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIO12_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO12_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO12_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel     | mge | gutmge |
      | M_BAUGRUPPE | 5   | 0      |
      | EINKAUF-2   | -10 | 0      |
      | EINKAUF-1   | -20 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 5 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -20  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO12_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 13 Zusätzliche Materialentnahme; Gutmenge auf BA, Rückmeldung erster AG, manbu in AFL=ja
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch      | mfreig |
      | M_BAUGRUPPE | 10     | SCENARIO13_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIO13_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO13_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I append rows
      | elex      | bumge |
      | EINKAUF-3 | 10    |
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO13_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 4 rows
    Then table has values
      | artikel     | mge | gutmge |
      | M_BAUGRUPPE | 5   | 0      |
      | EINKAUF-3   | -10 | 0      |
      | EINKAUF-2   | -10 | 0      |
      | EINKAUF-1   | -20 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 7 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -20  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-3 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO13_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 14 Mehrentnahme eines Materials auf ersten Arbeitsschein; Gutmenge auf BA, Rückmeldung erster AG, manbu in AFL=ja
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch      | mfreig |
      | M_BAUGRUPPE | 10     | SCENARIO14_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIO14_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO14_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I set field "bumge" to "50" in row 1
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO14_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel     | mge | gutmge |
      | M_BAUGRUPPE | 5   | 0      |
      | EINKAUF-2   | -10 | 0      |
      | EINKAUF-1   | -50 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 5 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -50  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO14_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 15 Materialentnahme auf ersten Arbeitsschein; Gutmenge auf BA, Rückmeldung erster AG, manbu in AFL=nein
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch      | mfreig |
      | BAUGRUPPE | 10     | SCENARIO15_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIO15_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO15_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO15_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel   | mge | gutmge |
      | BAUGRUPPE | 5   | 0      |
      | EINKAUF-2 | -5  | 0      |
      | EINKAUF-1 | -10 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 7 rows
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -10  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -5   |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO15_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 10    | 10     |
      | EINKAUF-2 | 5     | 5      |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 16 Materialentnahme auf zweiten Arbeitsschein; Gutmenge auf BA, Rückmeldung erster AG, manbu in AFL=nein
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch      | mfreig |
      | BAUGRUPPE2 | 10     | SCENARIO16_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIO16_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO16_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO16_002;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gutmge |
      | BAUGRUPPE2 | 10  | 0      |
      | EINKAUF-2  | -10 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | detursache                        | !row |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung | 1    |
      | EINKAUF-2 | 10   |      | Materialentnahme Fertigung        | 2    |
    And I close the current editor


  Scenario: 17 Zusätzliche Materialentnahme; Gutmenge auf BA, Rückmeldung erster AG, manbu in AFL=nein
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch      | mfreig |
      | BAUGRUPPE | 10     | SCENARIO17_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIO17_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO17_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I append rows
      | elex      | bumge |
      | EINKAUF-3 | 10    |
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO17_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 4 rows
    Then table has values
      | artikel   | mge | gutmge |
      | BAUGRUPPE | 5   | 0      |
      | EINKAUF-3 | -10 | 0      |
      | EINKAUF-2 | -5  | 0      |
      | EINKAUF-1 | -10 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -10  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -5   |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-3 | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO17_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 10    | 10     |
      | EINKAUF-2 | 5     | 5      |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 18 Mehrentnahme eines Materials auf ersten Arbeitsschein; Gutmenge auf BA, Rückmeldung erster AG, manbu in AFL=nein
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch      | mfreig |
      | BAUGRUPPE | 10     | SCENARIO18_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIO18_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO18_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I set field "manbu" to "ja" in row 1
    And I set field "bumge" to "50" in row 1
    And I save the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCENARIO18_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel   | mge | gutmge |
      | BAUGRUPPE | 5   | 0      |
      | EINKAUF-2 | -5  | 0      |
      | EINKAUF-1 | -50 | 0      |
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | detursache                        |
      | EINKAUF-1 | -50  |      | Storno-Materialentnahme Fertigung |
      | EINKAUF-2 | -5   |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO18_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 10    | 10     |
      | EINKAUF-2 | 5     | 5      |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 19 Materialentnahme mit Chargen, keine Gutmenge auf BA
# Chargen anlegen
    Given I create a Lot "CH_E11" for Product "EINKAUF-1"
    Given I create a Lot "CH_E12" for Product "EINKAUF-1"

# Bestände korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_KORR19"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "B_KORR19"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig |
      | M_BAUGRUPPE | 10     | ja     |
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge     |
      | +1   | 10     | !CH_E11^id |
      | +2   | 5      | !CH_E12^id |
      | +3   | 5      |            |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "SCENARIO19_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und Bestände prüfen
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO19_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SCENARIO19_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | gebmge | charge^such | zugvorg |
      | -20   |        |             |         |
	  |       | -10    | CH_E11      |         |
	  |       | -5     | CH_E12      |         |
      |       | -5     |             |         |
    And I close the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerjornaleintrag und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | detursache                        | vcharge^such | ncharge | storniert | !row |
      | EINKAUF-1 | -10  |      | Storno-Materialentnahme Fertigung | CH_E11       |         | nein      | 1    |
      | EINKAUF-1 | -5   |      | Storno-Materialentnahme Fertigung | CH_E12       |         | nein      | 2    |
      | EINKAUF-1 | -5   |      | Storno-Materialentnahme Fertigung |              |         | nein      | 3    |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |              |         | nein      | 4    |
      | EINKAUF-1 | 5    |      | Materialentnahme Fertigung        |              |         | ja        | 5    |
      | EINKAUF-1 | 5    |      | Materialentnahme Fertigung        | CH_E12       |         | ja        | 6    |
      | EINKAUF-1 | 10   |      | Materialentnahme Fertigung        | CH_E11       |         | ja        | 7    |
      | EINKAUF-2 | 10   |      | Materialentnahme Fertigung        |              |         | ja        | 8    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 8
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO19_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 20 Materialentnahme über Teilmenge mit Charge, keine Gutmenge auf BA
# Chargen anlegen
    Given I create a Lot "CH_E11-20" for Product "EINKAUF-1"
    Given I create a Lot "CH_E12-20" for Product "EINKAUF-1"

# Bestände korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_KORR20"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "B_KORR20"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig |
      | M_BAUGRUPPE | 10     | ja     |
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge        |
      | +1   | 10     | !CH_E11-20^id |
      | +2   | 5      | !CH_E12-20^id |
      | +3   | 5      |               |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "SCENARIO20_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und Bestände prüfen
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO20_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gmgevorschl" to "9"
    And I press button "stlvblad"
    And I save the current editor
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SCENARIO20_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | gebmge | charge^such | zugvorg |
      | -18   |        |             |         |
      |       | -10    | CH_E11-20   |         |
      |       | -5     | CH_E12-20   |         |
      |       | -3     |             |         |
    And I close the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerjornaleintrag und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | detursache                        | vcharge^such | ncharge | storniert | !row |
      | EINKAUF-1 | -10  |      | Storno-Materialentnahme Fertigung | CH_E11-20    |         | nein      | 1    |
      | EINKAUF-1 | -5   |      | Storno-Materialentnahme Fertigung | CH_E12-20    |         | nein      | 2    |
      | EINKAUF-1 | -3   |      | Storno-Materialentnahme Fertigung |              |         | nein      | 3    |
      | EINKAUF-2 | -9   |      | Storno-Materialentnahme Fertigung |              |         | nein      | 4    |
      | EINKAUF-1 | 3    |      | Materialentnahme Fertigung        |              |         | ja        | 5    |
      | EINKAUF-1 | 5    |      | Materialentnahme Fertigung        | CH_E12-20    |         | ja        | 6    |
      | EINKAUF-1 | 10   |      | Materialentnahme Fertigung        | CH_E11-20    |         | ja        | 7    |
      | EINKAUF-2 | 9    |      | Materialentnahme Fertigung        |              |         | ja        | 8    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 8
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO20_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 21 Materialentnahme über BA mit Charge, keine Gutmenge auf BA
# Chargen anlegen
    Given I create a Lot "CH_E11-21" for Product "EINKAUF-1"
    Given I create a Lot "CH_E12-21" for Product "EINKAUF-1"

# Bestände korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_KORR21"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "B_KORR21"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig |
      | M_BAUGRUPPE | 10     | ja     |
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge        |
      | +1   | 10     | !CH_E11-21^id |
      | +2   | 5      | !CH_E12-21^id |
      | +3   | 5      |               |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "SCENARIO21_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und Bestände prüfen
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO21_000;@richtung=rückwärts;@maxtreffer=1"
    And I set field "mgr" to "112"
    And I press button "stllad"
    And I save the current editor
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SCENARIO21_000;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | gebmge | charge^such | zugvorg |
      | -20   |        |             |         |
      |       | -10    | CH_E11-21   |         |
      |       | -5     | CH_E12-21   |         |
      |       | -5     |             |         |
    And I close the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerjornaleintrag und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | detursache                        | vcharge^such | ncharge | storniert | !row |
      | EINKAUF-1 | -10  |      | Storno-Materialentnahme Fertigung | CH_E11-21    |         | nein      | 1    |
      | EINKAUF-1 | -5   |      | Storno-Materialentnahme Fertigung | CH_E12-21    |         | nein      | 2    |
      | EINKAUF-1 | -5   |      | Storno-Materialentnahme Fertigung |              |         | nein      | 3    |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung |              |         | nein      | 4    |
      | EINKAUF-1 | 5    |      | Materialentnahme Fertigung        |              |         | ja        | 5    |
      | EINKAUF-1 | 5    |      | Materialentnahme Fertigung        | CH_E12-21    |         | ja        | 6    |
      | EINKAUF-1 | 10   |      | Materialentnahme Fertigung        | CH_E11-21    |         | ja        | 7    |
      | EINKAUF-2 | 10   |      | Materialentnahme Fertigung        |              |         | ja        | 8    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 8
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO21_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 22 Materialentnahme mit Projekt, keine Gutmenge auf BA
# Bestände korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_KORR22"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "B_KORR22"

# Projekt anlegen
    Given I open an editor "PROJEKT_M22" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT_M22"
    And I set field "such" to "PROJEKT_M22"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | projekt     | bisuch      |
      | M_BAUGRUPPE | 10     | ja     | PROJEKT_M22 | SCENARIO22_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und Bestände prüfen
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO22_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SCENARIO22_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | projekt     | zugvorg |
      | -20   |        |             |         |
      |       | -20    | PROJEKT_M22 |         |
    And I close the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerjornaleintrag und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | detursache                        | projekt     | projektla | storniert | !row |
      | EINKAUF-1 | -20  |      | Storno-Materialentnahme Fertigung | PROJEKT_M22 | ja        | nein      | 1    |
      | EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung | PROJEKT_M22 | ja        | nein      | 2    |
      | EINKAUF-1 | 20   |      | Materialentnahme Fertigung        | PROJEKT_M22 | ja        | ja        | 3    |
      | EINKAUF-2 | 10   |      | Materialentnahme Fertigung        | PROJEKT_M22 | ja        | ja        | 4    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO22_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 23 Materialentnahme Teilmenge mit Projekt, keine Gutmenge auf BA
# Bestände korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_KORR23"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "B_KORR23"

# Projekt anlegen
    Given I open an editor "PROJEKT_M23" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT_M23"
    And I set field "such" to "PROJEKT_M23"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | projekt     | bisuch      |
      | M_BAUGRUPPE | 10     | ja     | PROJEKT_M23 | SCENARIO23_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und Bestände prüfen
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO23_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gmgevorschl" to "9"
    And I press button "stlvblad"
    And I save the current editor
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SCENARIO23_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | projekt     | zugvorg |
      | -18   |        |             |         |
      |       | -18    | PROJEKT_M23 |         |
    And I close the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerjornaleintrag und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | detursache                        | projekt     | projektla | storniert | !row |
      | EINKAUF-1 | -18  |      | Storno-Materialentnahme Fertigung | PROJEKT_M23 | ja        | nein      | 1    |
      | EINKAUF-2 | -9   |      | Storno-Materialentnahme Fertigung | PROJEKT_M23 | ja        | nein      | 2    |
      | EINKAUF-1 | 18   |      | Materialentnahme Fertigung        | PROJEKT_M23 | ja        | ja        | 3    |
      | EINKAUF-2 | 9    |      | Materialentnahme Fertigung        | PROJEKT_M23 | ja        | ja        | 4    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO23_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 20    | 20     |
      | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 24 Materialentnahme Fertigteil mit Projekt, Komponenten ohne Projekt, BA mit Gutmenge
# Bestände korrigieren
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "B_KORR24"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1" with document "B_KORR24"

# Bestände zubuchen
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "LAGER-24" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "LAGER-24" and price "0"

# Projekt anlegen
    Given I open an editor "PROJEKT_M24" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT_M24"
    And I set field "such" to "PROJEKT_M24"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | projekt     |
      | M_BAUGRUPPE | 10     | ja     | PROJEKT_M24 |
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    And I modify table
      | !row | elex        | elanzahl | manbu |
      | -1   |             |          |       |
      | -1   |             |          |       |
      | +1   | B_EINKAUF-1 | 2        | ja    |
      | +2   | B_EINKAUF-2 | 1        | ja    |
    Then the table has 3 rows
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "SCENARIO24_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme, Rückmeldung und Bestände prüfen
    Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=SCENARIO24_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SCENARIO24_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIO24_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerjornaleintrag und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | amge | zmge | detursache                        | projekt     | projektla | storniert | !row |
      | B_EINKAUF-1 | -20  |      | Storno-Materialentnahme Fertigung | PROJEKT_M24 | nein      | nein      | 1    |
      | B_EINKAUF-2 | -10  |      | Storno-Materialentnahme Fertigung | PROJEKT_M24 | nein      | nein      | 2    |
      | M_BAUGRUPPE |      | 5    | Rückmeldung Fertigung             | PROJEKT_M24 | ja        | nein      | 3    |
      | B_EINKAUF-1 | 20   |      | Materialentnahme Fertigung        | PROJEKT_M24 | nein      | ja        | 4    |
      | B_EINKAUF-2 | 10   |      | Materialentnahme Fertigung        | PROJEKT_M24 | nein      | ja        | 5    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | projekt | zugvorg |
      | 20    |        |         |         |
      |       | 20     |         |         |
    And I close the current editor

# Offene Mengen in Reserverung prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCENARIO24_000"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex        | limge | frgmge |
      | B_EINKAUF-1 | 20    | 20     |
      | B_EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 25 Storno einer Materialentnahme, die Material zu mehreren Arbeitsscheinen abgebucht hat
# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | mfreig | bisuch  |
      | M_BAUGRUPPE2 | 10  | ja     | MENGEN_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MENGEN_002"
    And I close the current editor

# Materialentnahme Arbeitsschein1 und Arbeitsschein2,
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein2^nummer |
    And I press button "stllad"
    Then the table has 2 rows
    And I save the current editor

    Given I open an editor "Materialentnahme1_view" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MENGEN_002;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialentnahme stornieren
    Given I open an editor "Storno1" via ID from editor "Materialentnahme1_view" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then the table has 3 rows
    Then table has values
      | artikel   | mge | !row |
      | EINKAUF-2 | -10 | 2    |
      | EINKAUF-1 | -20 | 3    |
    And I save the current editor

# LJ und offene Mengen prüfen, Betriebsauftrag abbrechen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Materialentnahme1_view^barmex |
      | richtung | rückwärts                      |
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | storniert | !row |
      | EINKAUF-1 | -20  | -20      | 0       | nein      | 1    |
      | EINKAUF-2 | -10  | -10      | 0       | nein      | 2    |
      | EINKAUF-1 | 20   | 20       | 0       | ja        | 3    |
      | EINKAUF-2 | 10   | 10       | 0       | ja        | 4    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

    Given I switch the current editor to editor "Storno1" with command "VIEW"
    Then table has values
      | !row | artikel   | mge | rueckmge | restmge | limgen | limgev |
      | 2    | EINKAUF-2 | -10 | 0        | -10     | 10     | 0      |
      | 3    | EINKAUF-1 | -20 | 0        | -20     | 20     | 0      |
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Materialentnahme1_view"
    And I close the current editor

    Given I switch the current editor to editor "Materialentnahme1_view" with command "VIEW"
    Then table has values
      | !row | artikel   | mge | rueckmge | restmge | limgen | limgev |
      | 2    | EINKAUF-2 | 10  | 0        | 10      | 0      | 10     |
      | 3    | EINKAUF-1 | 20  | 0        | 20      | 0      | 20     |
    And I close the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MENGEN_000"
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | !row | elex      | limge | frgmge |
      | 1    | EINKAUF-1 | 20    | 20     |
      | 3    | EINKAUF-2 | 10    | 10     |
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 26 Storno einer Materialentnahme auf abgelegten FV, die das Fertigteil entnommen hatte
# FDA-3790: Storno einer Materialentnahme Fertigteil für Nacharbeit nicht möglich

# Bestand auf 100 korrigieren
    Given I set StorageQuantity to zero for Product "M_BAUGRUPPE2" on StorageLocation "F1" with document "KORR-01"

    Given I open an editor "Lagerbuchung" for tip command "Lbuchung" and arguments ""
    And I set field "artikel" to "M_BAUGRUPPE2"
    And I set field "buart" to "Zugang"
    And I set field "beldat" to "."
    And I set field "beleg" to "SC26"
    And I set field "mge" to "100" in row 1
    And I save the current editor

# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | mfreig | bisuch  |
      | M_BAUGRUPPE2 | 10  | ja     | FTSTRN_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme Arbeitsschein1, alles Material und das Fertigteil
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | FTSTRN_001 |
    And I press button "stllad"
    And I append rows
      | elex         | bumge |
      | M_BAUGRUPPE2 | 1     |
    And I save the current editor

# Materialentnahme Arbeitsschein2, alles Material
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | FTSTRN_002 |
    And I press button "stllad"
    And I save the current editor

# Gesamte Gutmenge buchen und FV abschliessen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FTSTRN_000"
    And I set field "mgr" to "101"
    And I set field "gut" to "true"
    And I set field "sofort" to "1"
    And I save the current editor

# Materialentnahme1 stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=FTSTRN_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I save the current editor


  Scenario: 27 Materialentnahme Teilmenge mit Restmenge buchen
# Bestände korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_KORR27"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "B_KORR27"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch      | mfreig |
      | M_BAUGRUPPE | 10     | SCENARIO27_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf BA über Teilmenge mit Restmenge buchen=ja
    Given I open an editor "RM1_BA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIO27_000"
    And I set field "mgr" to "101"
    And I set field "manrest" to "ja"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "RM1_BA"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | amge | zmge | detursache                        | storniert | !row |
      | M_BAUGRUPPE |      | 8    | Rückmeldung Fertigung             | nein      | 1    |
      | EINKAUF-1   | 20   |      | Rückmeldung Fertigung             | nein      | 2    |
      | EINKAUF-2   | 10   |      | Rückmeldung Fertigung             | nein      | 3    |
    And I close the current editor

# Rückmeldung stornieren
    Given I open an editor "STORNO_RM1_BA" via ID from editor "RM1_BA" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Lagerjornaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "STORNO_RM1_BA"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | amge | zmge | detursache                        | storniert | !row |
      | M_BAUGRUPPE |      | -8   | Storno-Rückmeldung Fertigung      | nein      | 1    |
      | EINKAUF-1   | -20  |      | Storno-Rückmeldung Fertigung      | nein      | 2    |
      | EINKAUF-2   | -10  |      | Storno-Rückmeldung Fertigung      | nein      | 3    |
      | M_BAUGRUPPE |      | 8    | Rückmeldung Fertigung             | ja        | 4    |
      | EINKAUF-1   | 20   |      | Rückmeldung Fertigung             | ja        | 5    |
      | EINKAUF-2   | 10   |      | Rückmeldung Fertigung             | ja        | 6    |
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 6
    And I close the current editor


### ------------------- Scenarios autorm=nein ---------------------- ###



  Scenario: Konfiguration autorm=nein
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set fields
      | autorm | nein |
    And I save the current editor

  Scenario: 100 Storno einer Materialentnahme auf abgelegten FV, die das Fertigteil entnommen hatte
# FDA-5025: Beim Storno von Materialentnahme wird das Material ggfs. nicht zurückgebucht

    Given I open an editor "BG3" from table "(Part):(Product)" with command "COPY" for record "M_BAUGRUPPE"
    And I set fields
      | such      | M_BAUGRUPPE3      |
      | namebspr  | BG mit 3 AG       |
      | dispoa    | auftragsbezogen   |
      | bsart     | Eigenfertigung    |
      | chverfolgung |                   |
    And I append rows
      | elex       | anzahl | manbu       |
      | A BOHR     | 1      | !dontChange |
      | A DREH     | 1      | !dontChange |
    And I save the current editor

# Bestand auf 100 korrigieren
    Given I set StorageQuantity to zero for Product "M_BAUGRUPPE3" on StorageLocation "F1" with document "KORR-03"

    Given I open an editor "Lagerbuchung" for tip command "Lbuchung" and arguments ""
    And I set field "artikel" to "M_BAUGRUPPE3"
    And I set field "buart" to "Zugang"
    And I set field "beldat" to "."
    And I set field "beleg" to "SC100"
    And I set field "mge" to "100" in row 1
    And I save the current editor

# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | mfreig | bisuch  |
      | M_BAUGRUPPE3 | 10  | ja     | SC100_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme Arbeitsschein1, alles Material und das Fertigteil
    Given I open an editor "FBU1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | SC100_002 |
      | gmgevorschl |         5 |
    And I press button "stllad"
    And I save the current editor

# Materialentnahme1 stornieren
    Given I open an editor "StornoFBU1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SC100_002;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I save the current editor

# LJ Mengen prüfen, Betriebsauftrag abbrechen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !StornoFBU1^barmex |
      | richtung | rückwärts    |
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | storniert | !row |
      | EINKAUF-1 | -10  | -10      | 0       | nein      | 1    |
      | EINKAUF-2 |  -5  |  -5      | 0       | nein      | 2    |
      | EINKAUF-1 | 10   | 10       | 0       | ja        | 3    |
      | EINKAUF-2 |  5   |  5       | 0       | ja        | 4    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SC100_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor
