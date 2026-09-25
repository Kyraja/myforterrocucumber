@persistent
Feature: rueckmeldungen_loeschen.feature

  Background:
    And I set the fake date to "03.02.1995"


# *****************************************************************************
#  Name             : rueckmeldungen_loeschen
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet das Löschen von ungebuchten Objekten in der Fertigung und
#                     Betriebsdatenerfassung
# Jira-Issue        : FDA-535
# *****************************************************************************

  Scenario: 01 Ungebuchte Rückmeldung kann über das Kommando Löschen gelöscht werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | DELETE_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# ungebuchte Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "DELETE_001"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# ungebuchte Rückmeldung löschen
    And I switch the current editor to editor "Rückmeldung1" with command "DELETE"
    And I respond with answer "ja" to the dialog with id "826"
    And I save the current editor

# Verweis auf ungebuchte Rückmeldung im Arbeitsschein ist leer
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "DELETE_001"
    Then field "barm" is empty
    And I close the current editor

# Zähler ungebuchte Rückmeldungen auf leer BA prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "DELETE_000"
    Then field "nrm" has value "0"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 02 Gebuchte Rückmeldungen können über das Kommando Löschen nicht gelöscht werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | NODELETE_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NODELETE_001"
    And I set field "gutmge" to "5" in row 1
    And I set field "sofort" to "ja"
    And I save the current editor

# Fehlermeldung bei Rückmeldung löschen
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "DELETE" for record from editor "Rückmeldung1" throws the exception "2620"
    And I close the current editor

# Betriebsauftrag abschließen, Verweis auf Rückmeldung im BA vorhanden
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "NODELETE_000"
    Then field "ngrm" has value "1"
    Then field "nrm" has value "0"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 03 Der Betriebsauftrag kann über das Kommando Löschen nicht gelöscht werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | NODELETE_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag öffnen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "NODELETE_000"
    And I close the current editor

# Fehlermeldung bei Betriebsauftrag löschen
    Given opening an editor from table "(WorkOrder):(Workorders)" with command "DELETE" for record from editor "Betriebsauftrag" throws the exception "823"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NODELETE_001"
    And I set field "gutmge" to "5" in row 1
    And I set field "sofort" to "ja"
    And I save the current editor

# Fehlermeldung bei Betriebsauftrag löschen
    Given opening an editor from table "(WorkOrder):(Workorders)" with command "DELETE" for record from editor "Betriebsauftrag" throws the exception "823"
    And I close the current editor

# Betriebsauftrag abschließen
    And I switch the current editor to editor "Betriebsauftrag" with command "UPDATE"
    Then field "ngrm" has value "1"
    Then field "nrm" has value "0"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 04 Das Löschen einer Rückmeldung ist nur durch Storno des BDE-Objekts möglich
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | BDE_   | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Arbeitsschein für Arbeitsscheinnummer öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BDE_001"
    And I close the current editor

# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "TEST"
    And I set field "splan" to "303"
    And I set field "lohn" to "1"
    And I save the current editor

# Personal- und Auftragszeit erstellen und übertragen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=TEST;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | enddat  | .    |
      | endzeit | 9:45 |
      | istmge  | 5    |
    And I save the current editor

# Auftragszeit übertragen
    And I switch the current editor to editor "Auftragszeit" with command "TRANSFER"
    And I save the current editor

# Rückmeldung löschen
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "DELETE" for record "$,,such=BDE_001;@gruppe=2;@maxtreffer=1" throws the exception "10899"
    And I close the current editor
