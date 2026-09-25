@persistent
Feature: storno_rueckbau_bde.feature

  Background:
    And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : storno_rueckbau_bde
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet Rückbau und Storno des Rückbaus von BDE-Objekten
#  Jira-Issue       : -
# *****************************************************************************

  Scenario: 01 Ein BDE-Beleg mit negativer Gutmenge erzeugt beim Übertragen einen Rückbau Fertigung, Storno des Rückbaus
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA1"
    And I set fields
      | such  | BDE_MA1 |
      | splan | 303     |
      | lohn  | 1       |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | BDERUECK_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf Arbeitsschein1
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDERUECK_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "9" in row 1
    And I save the current editor

# Personal- und Auftragszeit erstellen und übertragen sowie Rückmeldung buchen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA1;@richtung=rückwärts;@maxtreffer=1"
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
      | anfdat    | .    |
      | anfzeit   | 9:00 |
      | enddat    | .    |
      | endzeit   | 9:45 |
      | automzeit | ja   |
      | istmge    | -5   |
    And I save the current editor

    And I switch the current editor to editor "Auftragszeit" with command "TRANSFER"
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for search criteria "$,,such=BDERUECK_001;@richtung=rückwärts;@maxtreffer=1"
    And I save the current editor

# Rückbau Fertigung ist entstanden
    Given I open an editor "Rückbau" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDERUECK_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Rückbau auf Betriebsauftrag"
    And I close the current editor

# Storno des Rückbaus, Belege prüfen
    Given I open an editor "StornoRückbau-BDERUECK_001" from table "(PDC):(OrderTime)" with command "REVERSAL" for record from editor "Auftragszeit"
    And I save the current editor

    Given I switch the current editor to editor "StornoRückbau-BDERUECK_001" with command "VIEW"
    Then field "typa332" has value "Storno-Auftragszeit"
    Then field "rm^typa279" has value "Storno-Rückbau auf Betriebsauftrag"
    And I close the current editor

    Given I switch the current editor to editor "Rückbau" with command "VIEW"
    Then field "typa279" has value "Stornierter Rückbau auf Betriebsauftrag"
    And I close the current editor

# Betriebsauftrag und Personalzeit abschließen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDERUECK_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 02 Ein Kurzläufer mit negativer Gutmenge erzeugt beim Übertragen einen Rückbau Fertigung, Storno des Rückbaus
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA1"
    And I set fields
      | such  | BDE_MA1 |
      | splan | 303     |
      | lohn  | 1       |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | KURZL_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KURZL_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "9" in row 1
    And I save the current editor

# Personalzeit und Kurzläufer erstellen und buchen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA1;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor

    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat    | .    |
      | anfzeit   | 9:00 |
      | automzeit | ja   |
      | istmge    | -5   |
      | sofort    | ja   |
    And I save the current editor

# Rückbau Fertigung ist entstanden
    Given I open an editor "Rückbau" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZL_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Rückbau auf Betriebsauftrag"
    And I close the current editor

# Storno des Rückbaus, Belege prüfen
    Given I open an editor "StornoRückbau-KURZL_001" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer"
    And I save the current editor

    Given I switch the current editor to editor "StornoRückbau-KURZL_001" with command "VIEW"
    Then field "typa332" has value "Storno-Auftragszeit"
    Then field "rm^typa279" has value "Storno-Rückbau auf Betriebsauftrag"
    And I close the current editor

    Given I switch the current editor to editor "Rückbau" with command "VIEW"
    Then field "typa279" has value "Stornierter Rückbau auf Betriebsauftrag"
    And I close the current editor

# Betriebsauftrag und Personalzeit abschließen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "KURZL_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 03 Ein Kurzläufer mit negativer Gutmenge und positiver Istzeit erzeugt beim Übertragen einen Rückbau Fertigung, Storno des Rückbaus
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA1"
    And I set fields
      | such  | BDE_MA1 |
      | splan | 303     |
      | lohn  | 1       |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | KURZLB_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KURZLB_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "9" in row 1
    And I save the current editor

# Personalzeit und Kurzläufer erstellen und buchen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA1;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor

    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat    | .    |
      | anfzeit   | 9:00 |
      | automzeit | ja   |
      | istzeit   | 1    |
      | istmge    | -5   |
      | sofort    | ja   |
    And I save the current editor

# Rückbau Fertigung ist entstanden
    Given I open an editor "Rückbau" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZLB_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Rückbau auf Betriebsauftrag"
    Then field "bzeit" has value "1"
    Then field "gutmge" has value "-5" in row 1
    And I close the current editor

# Storno des Rückbaus
    Given I open an editor "StornoRückbau-KURZLB_001" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer"
    And I save the current editor

# Betriebsauftrag und Personalzeit abschließen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "KURZLB_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 04 Ein Kurzläufer mit positiver Gutmenge kann keine negative Zeit haben
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA1"
    And I set fields
      | such  | BDE_MA1 |
      | splan | 303     |
      | lohn  | 1       |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | KURZZEIT_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Arbeitsschein für Arbeitsscheinnummer öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KURZZEIT_001"
    And I close the current editor

# Personalzeit und Kurzläufer erstellen und buchen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA1;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat    | .     |
      | anfzeit   | 8:00  |
      | enddat    | .     |
      | endzeit   | 16:00 |
    And I save the current editor

    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat    | .    |
      | anfzeit   | 9:00 |
      | automzeit | ja   |
      | istmge    | 5    |
    Then setting field "istzeit" to "-3" throws the exception "11125"
    And I close the current editor

# Betriebsauftrag und Personalzeit abschließen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "KURZZEIT_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 05 Ein Kurzläufer mit positiver Gutmenge und negativer Ausschussmenge (und vv) kann nicht gespeichert werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | VZ_    | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma        | BDE_MA1 |
      | asma      | VZ_001  |
      | anfdat    | .       |
      | anfzeit   | 9:00    |
      | automzeit | ja      |
      | istmge    | 5       |
      | ausmge    | -1      |
    Then saving the current editor throws the exception "266"
    And I close the current editor

    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma        | BDE_MA1 |
      | asma      | VZ_001  |
      | anfdat    | .       |
      | anfzeit   | 9:00    |
      | automzeit | ja      |
      | istmge    | -3      |
      | ausmge    | 1       |
    Then saving the current editor throws the exception "266"
    And I close the current editor


  Scenario: 06 Ein Kurzläufer mit negativer Ausschussmenge oder Nacharbeitsmenge erzeugt einen Rückbau
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | BDEAUS_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma        | BDE_MA1    |
      | asma      | BDEAUS_001 |
      | anfdat    | .          |
      | anfzeit   | 9:00       |
      | automzeit | ja         |
      | ausmge    | 5          |
      | sofort    | ja         |
    And I save the current editor

    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma        | BDE_MA1    |
      | asma      | BDEAUS_001 |
      | anfdat    | .          |
      | anfzeit   | 9:05       |
      | automzeit | ja         |
      | ausmge    | -3         |
      | sofort    | ja         |
    And I save the current editor

# Rückbau Fertigung ist entstanden
    Given I open an editor "Rückbau" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDEAUS_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Rückbau auf Betriebsauftrag"
    Then field "verlustmge" has value "-3" in row 1
    And I close the current editor

    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma        | BDE_MA1    |
      | asma      | BDEAUS_001 |
      | anfdat    | .          |
      | anfzeit   | 10:00      |
      | automzeit | ja         |
      | namge     | 3          |
      | sofort    | ja         |
    And I save the current editor

    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma        | BDE_MA1    |
      | asma      | BDEAUS_001 |
      | anfdat    | .          |
      | anfzeit   | 10:03      |
      | automzeit | ja         |
      | namge     | -2         |
      | sofort    | ja         |
    And I save the current editor

# Rückbau Fertigung ist entstanden
    Given I open an editor "Rückbau" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDEAUS_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Rückbau auf Betriebsauftrag"
    Then field "namge" has value "-2" in row 1
    And I close the current editor

# Betriebsauftrag und Personalzeit abschließen
    Given I open an editor "Arbeitsschein6" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDEAUS_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 07 Ein Kurzläufer mit negativer Gutmenge darf manrest/stornorest nicht gesetzt haben
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | REST_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma        | BDE_MA1  |
      | asma      | REST_001 |
      | anfdat    | .        |
      | anfzeit   | 9:11     |
      | automzeit | ja       |
      | istmge    | 7        |
    And I save the current editor

    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma        | BDE_MA1  |
      | asma      | REST_001 |
      | anfdat    | .        |
      | anfzeit   | 9:12     |
      | automzeit | ja       |
      | istmge    | -3       |
      | manrest   | j        |
    Then saving the current editor throws the exception "11183"
    And I close the current editor

    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma         | BDE_MA1  |
      | asma       | REST_001 |
      | anfdat     | .        |
      | anfzeit    | 9:12     |
      | automzeit  | ja       |
      | istmge     | -3       |
      | stornorest | j        |
    Then saving the current editor throws the exception "11183"
    And I close the current editor



