@persistent
Feature: zeitbuchung.feature

  Background:
    And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : zeitbuchung.feature
#  Autor            : lschneider, bschiga
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet Zeitbuchungen und -korrekturen über die Masken
#                     Zeitbuchung, Kurzläufer, Auftragszeit und Rückmeldung
#                     in der Fertigung
#  Jira-Issue       : FDA-527, FDA-2746
# *****************************************************************************

### Positive Zeitbuchung: Plausichecks und Prozesstests ###

  Scenario: P01 Positive und negative Zeitangeban dürfen in einer Zeitbuchung nicht gemischt werden
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | MISCHUNG_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MISCHUNG_001"
    And I set fields
      | sofort | 1 |
      | bzeit  | 2 |
      | mzeit  | 2 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Fehlermeldung in Zeitbuchung
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung1"
    And I set field "bzeit" to "-1"
    And I set field "mzeit" to "5"
    Then saving the current editor throws the exception "266"
    And I set field "bzeit" to "1"
    And I set field "mzeit" to "-5"
    Then saving the current editor throws the exception "266"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MISCHUNG_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P02 In einer Zeitbuchung auf den BA sind die Felder mgr und lgr leer und änderbar
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | SCHREIBS2_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHREIBS2_001"
    And I set fields
      | sofort | 1 |
      | bzeit  | 1 |
      | mzeit  | 1 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SCHREIBS2_000"
    And I close the current editor

# Zeitbuchung Prüfen der Felder
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Betriebsauftrag"
    Then field "mgr" is empty
    Then field "mgr" is modifiable
    Then field "lgr" is modifiable
    Then field "sofort" has value "ja"
    Then field "sofort" is modifiable
    And I close the current editor

# Betriebsauftrag abschließen
    And I switch the current editor to editor "Betriebsauftrag" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P03 In einer Zeitbuchung auf den Arbeitsschein sind die Felder mgr und lgr änderbar, Beleg buchen ist aktiv und schreibgeschützt
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | SCHREIBS_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHREIBS_001"
    And I set fields
      | sofort | 1 |
      | bzeit  | 1 |
      | mzeit  | 1 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Zeitbuchung Prüfen der Felder
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung1"
    Then field "mgr" is modifiable
    Then field "lgr" is modifiable
    Then field "sofort" has value "ja"
    Then field "sofort" is modifiable
    And I set field "sofort" to "ja"
    And I save the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCHREIBS_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P04 Feld Bemerkung in Zeitbuchung auf den Arbeitsschein editierbar und Text wird vererbt
    Given I set the fake date to "03.02.1995"
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch  |
      | BAUGRUPPE | 10  | ja     | BEMERK_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEMERK_001"
    And I set fields
      | sofort | 1 |
      | bzeit  | 1 |
      | mzeit  | 1 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Zeitbuchung
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung1"
    And I set field "bem" to "Zeitbuchung BEMERK_000"
    And I set field "sofort" to "ja"
    And I save the current editor

# Zeitbuchung zeigen
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEMERK_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then field "bem" has value "Zeitbuchung BEMERK_000"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BEMERK_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P05 Durch eine positive Zeitbuchung auf den BA mit Zeitbuchung und Gutmenge entsteht eine Rückmeldung mit typ=Zeitmeldung
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch  |
      | BAUGRUPPE | 10  | ja     | BAZEIT_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung_BA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BAZEIT_000"
    And I set fields
      | mgr    | 112 |
      | sofort | 1   |
      | lgr    | 1   |
      | bzeit  | 1   |
      | mzeit  | 1   |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Zeitbuchung
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung_BA"
    And I set fields
      | mgr   | 112 |
      | lgr   | 1   |
      | bzeit | 0.5 |
      | mzeit | 0.5 |
    And I save the current editor

# Zeitbuchung zeigen
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BAZEIT_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitbuchung |
      | mzeit   | 0.5         |
      | bzeit   | 0.5         |
    And I close the current editor

# Zeiten auf Arbeitsgang prüfen und Betriebsauftrag abschließen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung_BA"
    And I press start
    Then table has values
      | bzeit | mzeit |
      | 1.5   | 1.5   |
    Then field "vzeit" is empty in row 1
    And I close the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BAZEIT_000"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "gmge" has value "0.3" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: P06 Durch eine positive Zeitbuchung auf den BA ohne Zeitbuchung und Gutmenge entsteht eine Rückmeldung mit typ=Zeitbuchung
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | NURZ_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "NURZ_000"
    And I close the current editor

# Zeitbuchung
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Betriebsauftrag"
    And I set fields
      | mgr   | 112 |
      | lgr   | 1   |
      | bzeit | 0.5 |
      | mzeit | 0.5 |
    And I save the current editor

# Zeitbuchung zeigen
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=NURZ_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitbuchung |
      | mzeit   | 0.5         |
      | bzeit   | 0.5         |
    And I close the current editor

# Zeiten auf Arbeitsgang prüfen und Betriebsauftrag abschließen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "nummer" from editor "Betriebsauftrag"
    And I press start
    Then table has values
      | bzeit | mzeit |
      | 0.5   | 0.5   |
    Then field "vzeit" is empty in row 1
    And I close the current editor

    Given I switch the current editor to editor "Betriebsauftrag" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "gmge" has value "1.25" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P07 Durch eine positive Zeitbuchung auf den Arbeitsschein entsteht eine Rückmeldung mit typ=Zeitbuchung
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | POSITIVZ_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "POSITIVZ_001"
    And I set fields
      | sofort | 1 |
      | bzeit  | 1 |
      | mzeit  | 1 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Zeitbuchung
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | bzeit | 0.5 |
      | mzeit | 0.5 |
    And I save the current editor

# Zeitbuchung zeigen
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=POSITIVZ_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitbuchung |
      | mzeit   | 0.5         |
      | bzeit   | 0.5         |
    And I close the current editor

# Zeiten auf Arbeitsgang prüfen und Betriebsauftrag abschließen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung1"
    And I set field "detail" to "ja"
    And I press start
    Then field "bzeit" has value "1.5" in row 4
    Then field "mzeit" has value "1.5" in row 4
    Then field "vzeit" has value "0.3" in row 4
    And I close the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "POSITIVZ_000"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "gmge" has value "0.3" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P08 Durch eine positive Zeitbuchung in einem Kurzläufer entsteht eine Rückmeldung mit typ=Zeitbuchung
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | KURZLAUF_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KURZLAUF_000"
    And I close the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KURZLAUF_001"
    And I close the current editor

# Kurzläufer auf Betriebsauftrag
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Betriebsauftrag"
    And I set fields
      | mgr     | 112 |
      | anfdat  | .   |
      | anfzeit | .   |
      | istzeit | 2   |
      | mzeit   | 1   |
      | sofort  | ja  |
    And I save the current editor

# Kurzläufer prüfen
    Given I open an editor "Kurzläufer_pruef1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZLAUF_000;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Zeitbuchung"
    Then fields have values
      | mzeit | 1 |
      | bzeit | 2 |
    And I close the current editor

# Kurzläufer auf Arbeitsschein 1
    Given I open an editor "Kurzläufer2" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | anfdat  | .  |
      | anfzeit | .  |
      | istzeit | 3  |
      | mzeit   | 2  |
      | sofort  | ja |
    And I save the current editor

# Kurzläufer prüfen
    Given I open an editor "Kurzläufer_pruef2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZLAUF_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
#Then field "typa279" has value "Zeitbuchung"
    Then fields have values
      | mzeit | 2 |
      | bzeit | 3 |
    And I close the current editor

# Betriebsauftrag abschließen
    And I switch the current editor to editor "Betriebsauftrag" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P09 Ein BDE-Beleg mit positiver Zeit erzeugt beim Übertragen eine Zeitbuchung
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | BDEPZEIT_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf Arbeitsschein1
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDEPZEIT_001"
    And I set field "sofort" to "ja"
    And I set fields
      | mzeit | 1 |
      | bzeit | 1 |
    And I save the current editor

# Personal- und Auftragszeit erstellen und übertragen sowie Rückmeldung buchen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Rückmeldung1"
    And I set fields
      | anfdat    | .     |
      | anfzeit   | 9:00  |
      | enddat    | .     |
      | endzeit   | 10:00 |
      | automzeit | ja    |
      | sofort    | ja    |
    And I save the current editor

# Zeitbuchung ist entstanden
    Given I open an editor "Zeitbuchung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDEPZEIT_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Zeitbuchung"
    And I close the current editor

# Betriebsauftrag und Personalzeit abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDEPZEIT_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P10 Durch eine positive Zeitbuchung auf abgelegten BA entsteht eine Rückmeldung mit typ=Zeitbuchung
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | ABLAGEP_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABLAGEP_001"
    And I set fields
      | sofort | ja   |
      | gut    | ja   |
      | bzeit  | 1.25 |
      | mzeit  | 1.25 |
    And I save the current editor

    Given I open an editor "FVorschläge" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set fields
      | artikel   | BAUGRUPPE |
      | nurablage | ja        |
    And I press button "ladetab"
    And I save work order number from WorkOrderSuggestion in row !lastRow
    And I close the current editor

# Zeitbuchung
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to id from editor "Rückmeldung1"
    And I set fields
      | mgr   | 1 |
      | lgr   | 1 |
      | bzeit | 1 |
      | mzeit | 1 |
    And I save the current editor

# Zeitbuchung zeigen
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ABLAGEP_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitbuchung auf abgelegten Fertigungsvorschlag |
      | mzeit   | 1                                              |
      | bzeit   | 1                                              |
    And I close the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-111" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

  Scenario: P11 Das Feld Bemerkung in der Zeitbuchung zu abgelegtem BA überschreibbar und wird vererbt
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | BEMERKUE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BEMERKUE_000"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEMERKUE_001"
    And I set fields
      | sofort | ja   |
      | gut    | ja   |
      | bzeit  | 1.25 |
      | mzeit  | 1.25 |
    And I save the current editor

    Given I open an editor "FVorschläge" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set fields
      | artikel   | BAUGRUPPE |
      | nurablage | ja        |
    And I press button "ladetab"
    And I save work order number from WorkOrderSuggestion in row !lastRow
    And I close the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitbuchung
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to id from editor "Rückmeldung1"
    And I set fields
      | mgr   | 1                        |
      | lgr   | 1                        |
      | bzeit | 1                        |
      | mzeit | 1                        |
      | bem   | Zeitbuchung BEMERKUE_000 |
    And I save the current editor

# Zeitbuchung zeigen
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEMERKUE_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then field "bem" has value "Zeitbuchung BEMERKUE_000"
    And I close the current editor


  Scenario: P12 Storno einer Zeitbuchung auf einen Arbeitsschein
# Fertigungsvorschlag anlegen, freigeben und Arbeitsschein öffnen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | STORNOZ_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "STORNOZ_001"
    And I close the current editor


# Zeitbuchung und Zeitbuchung öffnen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | bzeit | 0.5 |
      | mzeit | 0.5 |
    And I save the current editor

    Given I open an editor "Zeitbuchung1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=STORNOZ_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-111" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeiten auf Arbeitsgang prüfen und Betriebsauftrag abbrechen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "nummer" from editor "Arbeitsschein1"
    And I set field "detail" to "ja"
    And I press start
    Then table has values
      | bzeit | mzeit | vzeit | !row |
      | 0.5   | 0.5   | 1.25  | 4    |
    And I close the current editor

# Zeitbuchung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=STORNOZ_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | bzeit | -0.5 |
      | mzeit | -0.5 |
    And I set field "bem" to "Storno1"
#Then field "stornopartnervorg^id" has value equal to field "id" from editor "Zeitbuchung1"      ----> Feld ist nicht in Skipgruppe
    And I save the current editor
#Then field "typa279" from editor "Zeitbuchung1" in row 0 has value "Stornierte Zeitbuchung"     ----> ID erst nach Umstellung auf Hülse verfügbar

# Storno Zeitbuchung zeigen
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=STORNOZ_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Storno-Zeitbuchung |
      | mzeit   | -0.5               |
      | bzeit   | -0.5               |
    And I close the current editor

# Zeiten auf Arbeitsgang prüfen und Betriebsauftrag abbrechen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "nummer" from editor "Arbeitsschein1"
    And I set field "detail" to "ja"
    And I press start
    Then table has values
      | bzeit | mzeit | vzeit | !row |
      | 0     | 0     | 1.25  | 4    |
    And I close the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "STORNOZ_000"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "gmge" has value "1.25" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P13 Storno einer Zeitbuchung, die durch einen Kurzläufer entstand
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | KURZLAUFS_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KURZLAUFS_000"
    And I close the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KURZLAUFS_001"
    And I close the current editor


# Kurzläufer auf Betriebsauftrag und Kurzläufer stornieren
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Betriebsauftrag"
    And I set fields
      | mgr     | 112 |
      | anfdat  | .   |
      | anfzeit | .   |
      | istzeit | 2   |
      | mzeit   | 1   |
      | sofort  | ja  |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."


# Kurzläufer stornieren und Rückmeldemeleg prüfen
    Given I open an editor "Storno1" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer1"
    Then fields have values
      | mzeit   | -1                  |
      | istzeit | -2                  |
      | typa332 | Storno-Auftragszeit |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

    Given I open an editor "Storno1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZLAUFS_000;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Storno-Zeitbuchung"
    Then fields have values
      | mzeit | -1 |
      | bzeit | -2 |
    And I close the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Kurzläufer auf Arbeitsschein 1
    Given I open an editor "Kurzläufer2" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | anfdat  | .  |
      | anfzeit | .  |
      | istzeit | 3  |
      | mzeit   | 2  |
      | sofort  | ja |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Kurzläufer stornieren und Rückmeldemeleg prüfen
    Given I open an editor "Storno2" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer2"
    Then fields have values
      | mzeit   | -2                  |
      | istzeit | -3                  |
      | typa332 | Storno-Auftragszeit |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."


    Given I open an editor "Storno2_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZLAUFS_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Storno-Zeitbuchung"
    Then fields have values
      | mzeit | -2 |
      | bzeit | -3 |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "nummer" from editor "Betriebsauftrag"
    And I set field "detail" to "ja"
    And I press start
    Then table has values
      | bzeit | mzeit | vzeit | !row |
      | 0     | 0     | 1.25  | 4    |
    And I close the current editor

    And I switch the current editor to editor "Betriebsauftrag" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P14 Storno einer Zeitbuchung, die durch einen BDE-Beleg entstand
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch     | mfreig |
      | BAUGRUPPE | 10     | BDEPZEITS_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf Arbeitsschein1
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDEPZEITS_001"
    And I set field "sofort" to "ja"
    And I set fields
      | mzeit | 1 |
      | bzeit | 1 |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Personal- und Auftragszeit erstellen und übertragen sowie Rückmeldung buchen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Rückmeldung1"
    And I set fields
      | anfdat    | .     |
      | anfzeit   | 9:00  |
      | enddat    | .     |
      | endzeit   | 10:00 |
      | automzeit | ja    |
      | sofort    | ja    |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitbuchung zeigen und stornieren
    Given I open an editor "Zeitbuchung1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDEPZEITS_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Zeitbuchung"
    Then field "bzeit" has value "1"
    And I close the current editor

    Given I open an editor "Storno1" from table "(PDC):(OrderTime)" with command "REVERSAL" for record from editor "Auftragszeit"
    Then field "typa332" has value "Storno-Auftragszeit"
    Then field "istzeit" has value "-1"
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Auftragszeit"
    And I save the current editor

    Given I open an editor "Zeitbuchung1b" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDEPZEITS_001;bzeit=1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Stornierte Zeitbuchung" in row 0
    And I close the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."


# Betriebsauftrag und Personalzeit abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDEPZEITS_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P15 Storno einer Zeitbuchung auf einen Betriebsauftrag
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | NURZS_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "NURZS_000"
    And I close the current editor

# Zeitbuchung
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Betriebsauftrag"
    And I set fields
      | mgr   | 112 |
      | lgr   | 1   |
      | bzeit | 0.5 |
      | mzeit | 0.5 |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitbuchung zeigen und stornieren
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=NURZS_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitbuchung |
      | mzeit   | 0.5         |
      | bzeit   | 0.5         |
    And I close the current editor

    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=NURZS_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Storno-Zeitbuchung |
      | mzeit   | -0.5               |
      | bzeit   | -0.5               |
#Then field "stornopartnervorg^id" has value equal to field "id" from editor "Zeitbuchung_pruef"	----> Feld ist erst nach Umstellung auf Hülse vorhanden
    And I save the current editor
#Then field "typa279" from editor "Zeitbuchung_pruef" in row 0 has value "Stornierte Zeitbuchung"   ---> erst nach Umstelung auf Hülse

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeiten auf Arbeitsgang prüfen und Betriebsauftrag abschließen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "nummer" from editor "Betriebsauftrag"
    And I press start
    Then table has values
      | bzeit | mzeit |
      | 0     | 0     |
    Then field "vzeit" is empty in row 1
    And I close the current editor

    Given I switch the current editor to editor "Betriebsauftrag" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "gmge" has value "1.25" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P16 Storno einer Storno-Zeitbuchung oder Stornierten Zeitbuchung ist nicht möglich
# Fertigungsvorschlag anlegen, freigeben und Arbeitsschein öffnen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | FEHLERS_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FEHLERS_001"
    And I close the current editor

# Zeitbuchung und Zeirbuchung öffnen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | bzeit | 0.5 |
      | mzeit | 0.5 |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitbuchung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=FEHLERS_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I save the current editor

    Given I open an editor "Storno1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FEHLERS_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Storno-Zeitbuchung und Stornierte Zeitbuchung können nicht storniert werden: nicht gefunden (149)
#Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Zeitbuchung1" throws the exception "149"		-> Hülse
#Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Storno1_pruef" throws the exception "149"	-> Hülse

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FEHLERS_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P17 Beim Storno einer Zeitbuchung sind alle Felder außer der Bemerkung schreibgeschützt
# Fertigungsvorschlag anlegen, freigeben und Arbeitsschein öffnen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch  |
      | BAUGRUPPE | 10  | ja     | SCHUTZ_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SCHUTZ_001"
    And I close the current editor

# Zeitbuchung und Zeirbuchung öffnen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | bzeit | 0.5 |
      | mzeit | 0.5 |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitbuchung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCHUTZ_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then field "bzeit" is not modifiable
    Then field "mzeit" is not modifiable
    Then field "sofort" is not modifiable
    Then field "vom" is not modifiable
    Then field "kstelle" is not modifiable
    Then field "verw" is not modifiable
    Then field "fixkost" is not modifiable
    Then field "varkost" is not modifiable
    Then field "skostfix" is not modifiable
    Then field "skostvar" is not modifiable
    Then field "bem" is modifiable
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCHUTZ_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P18 Storno einer Zeitbuchung auf einen abgelegten Arbeitsschein
# Fertigungsvorschlag anlegen, freigeben und Arbeitsschein öffnen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | STORNOA_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "STORNOA_001"
    And I close the current editor

# Zeitbuchung und Zeitbuchung öffnen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | bzeit | 1 |
      | mzeit | 1 |
    And I save the current editor

# Komplettrückmeldung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOA_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitbuchung stornieren
    Given I open an editor "Zeitbuchung1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=STORNOA_001;bzeit=1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | bzeit | -1 |
      | mzeit | -1 |
    And I save the current editor
    Given I open an editor "Zeitbuchung1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=STORNOA_001;bzeit=1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then field "typa279" has value "Stornierte Zeitbuchung" in row 0
#Then field "stornopartnervorg^id" has value equal to field "id" from editor "Zeitbuchung1"       -----> Umstellung  auf Hülse
    And I close the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Storno Zeitbuchung zeigen
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=STORNOA_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Storno-Zeitbuchung auf abgelegten Fertigungsvorschlag |
      | mzeit   | -1                                                    |
      | bzeit   | -1                                                    |
    And I close the current editor


  Scenario: P19 Storno einer Zeitnachbuchung auf einen abgelegten Arbeitsschein
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | STORNON_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrückmeldung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNON_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-113" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitbuchung und Zeitbuchung öffnen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "id" from editor "Rückmeldung1"
    Then field "typa279" has value "Zeitbuchung auf abgelegten Fertigungsvorschlag"
    And I set fields
      | bzeit | 1 |
      | mzeit | 1 |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-111" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitbuchung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=STORNON_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Storno-Zeitbuchung auf abgelegten Fertigungsvorschlag |
      | bzeit   | -1                                                    |
      | mzeit   | -1                                                    |
#Then field "stornopartnervorg^id" has value equal to field "id" from editor "Zeitbuchung1"        ----> Umstellung Hülse
    And I save the current editor
    Given I open an editor "Zeitbuchung1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=STORNON_001;bzeit=1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then field "typa279" has value "Stornierte Zeitbuchung auf abgelegten Fertigungsvorschlag" in row 0
    And I close the current editor


  Scenario: P20 Storno einer Zeitbuchung auf einen Arbeitsschein, die durch einen Kurzläufer entstand, abgelegter FV
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | KURZLAUFA_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KURZLAUFA_000"
    And I close the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KURZLAUFA_001"
    And I close the current editor

# Kurzläufer auf Betriebsauftrag und Kurzläufer stornieren
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Betriebsauftrag"
    And I set fields
      | mgr     | 112 |
      | anfdat  | .   |
      | anfzeit | .   |
      | istzeit | 2   |
      | mzeit   | 1   |
      | sofort  | ja  |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

    Given I open an editor "Kurzläufer1_Rueckmeldung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZLAUFA_000;typa279=Zeitbuchung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Zeitbuchung"
    And I save the current editor

# Kurzläufer auf Arbeitsschein 1
    Given I open an editor "Kurzläufer2" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | anfdat  | .  |
      | anfzeit | .  |
      | istzeit | 3  |
      | mzeit   | 2  |
      | sofort  | ja |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

    Given I open an editor "Kurzläufer2_Rueckmeldung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZLAUFA_001;typa279=Zeitbuchung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Zeitbuchung"
    And I save the current editor

# Komplettrückmeldung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KURZLAUFA_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Kurzläufer auf Betriebsauftrag und Arbeitsschein stornieren und Belege prüfen
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=KURZLAUFA_000;typa279=Zeitbuchung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Storno-Zeitbuchung auf abgelegten Fertigungsvorschlag"
    Then fields have values
      | mzeit | -1 |
      | bzeit | -2 |
#Then field "stornopartnervorg^id" has value equal to field "id" from editor "Kurzläufer1_Rueckmeldung"   -> Umstellung Hülse
    And I save the current editor

    Given I open an editor "Kurzläufer1_Prüf" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZLAUFA_000;mzeit=1;bzeit=2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Stornierte Zeitbuchung" in row 0
    And I close the current editor

# Kurzläufer auf Arbeitsschein stornieren und Rückmeldemeleg prüfen
    Given I open an editor "Storno2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=KURZLAUFA_001;typa279=Zeitbuchung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Storno-Zeitbuchung auf abgelegten Fertigungsvorschlag"
    Then fields have values
      | mzeit | -2 |
      | bzeit | -3 |
#Then field "stornopartnervorg^id" has value equal to field "id" from editor "Kurzläufer2_Rueckmeldung"   ----> Umstellung Hülse
    And I save the current editor
#Then field "typa279" from editor "Kurzläufer2_Rueckmeldung" in row 0 has value "Stornierte Zeitbuchung"   ----> Umstellung Hülse

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

  Scenario: P21 Storno einer Zeitbuchung, die durch einen BDE-Beleg entstand, abgelegter FV
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch     | mfreig |
      | BAUGRUPPE | 10     | BDEPZEITA_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf Arbeitsschein1
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDEPZEITA_001"
    And I set field "sofort" to "ja"
    And I set fields
      | mzeit | 1 |
      | bzeit | 1 |
    And I save the current editor

# Personal- und Auftragszeit erstellen und übertragen sowie Rückmeldung buchen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Rückmeldung1"
    And I set fields
      | anfdat    | .     |
      | anfzeit   | 9:00  |
      | enddat    | .     |
      | endzeit   | 10:00 |
      | automzeit | ja    |
      | sofort    | ja    |
    And I save the current editor

    Given I open an editor "Zeitbuchung1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDEPZEITA_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Zeitbuchung"
    Then field "bzeit" has value "1"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDEPZEITA_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitbuchung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BDEPZEITA_001;bzeit=1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Storno-Zeitbuchung auf abgelegten Fertigungsvorschlag"
    Then field "bzeit" has value "-1"
#Then field "stornopartnervorg^id" has value equal to field "id" from editor "Zeitbuchung1"       --------> Umstellung Hülse
    And I save the current editor

    Given I open an editor "Storno1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDEPZEITA_001;bzeit=1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Stornierte Zeitbuchung" in row 0
    And I close the current editor

  Scenario: P22 Storno einer Zeitbuchung auf einen Betriebsauftrag, abgelegter FV
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | NURZA_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "NURZA_000"
    And I close the current editor

# Zeitbuchung
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Betriebsauftrag"
    And I set fields
      | mgr   | 112 |
      | lgr   | 1   |
      | bzeit | 0.5 |
      | mzeit | 0.5 |
    And I save the current editor

    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=NURZA_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitbuchung |
      | mzeit   | 0.5         |
      | bzeit   | 0.5         |
    And I close the current editor

# Komplettrückmeldung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NURZA_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitbuchng stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=NURZA_000;abschluss=n;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Storno-Zeitbuchung auf abgelegten Fertigungsvorschlag |
      | mzeit   | -0.5                                                  |
      | bzeit   | -0.5                                                  |
#Then field "stornopartnervorg^id" has value equal to field "id" from editor "Zeitbuchung_pruef"	> Hülse
    And I save the current editor
#Then field "typa279" from editor "Zeitbuchung_pruef" in row 0 has value "Stornierte Zeitbuchung"	-> Hülse


  Scenario: P23 Eine Zeitbuchung kann nicht strorniert werden, wenn es bereits eine Zeitkorrekur dazu gibt
# Fertigungsvorschlag anlegen, freigeben und Arbeitsschein öffnen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | DOPPELS_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "DOPPELS_001"
    And I close the current editor

# Zeitbuchung, Zeitkorrektur und Zeitkorrektur öffnen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | bzeit | 2 |
      | mzeit | 2 |
    And I save the current editor

    Given I open an editor "Zeitbuchung1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=DOPPELS_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | bzeit | -1 |
      | mzeit | -1 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=DOPPELS_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Zeitbuchung, auf die es eine Zeitkorrektur gibt, kann nicht storniert werden
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=DOPPELS_001;bzeit=2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then saving the current editor throws the exception "11126"
    And I close the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "DOPPELS_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-112" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."


  Scenario: P24 Das Feld Bemerkung wird in den Storno-Belegen der Zeitbuchung vererbt
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | BEMZ_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BEMZ_001"
    And I close the current editor

# Zeitbuchung erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | mzeit | 3           |
      | bzeit | 3           |
      | bem   | Zeitbuchung |
    And I save the current editor

    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BEMZ_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I set field "bem" to "Zeitstorno"
    And I save the current editor

# Feld Bemerkung in Original- und Stornobeleg prüfen
    Given I open an editor "Zeitbuchung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEMZ_001;typa279=Stornierte Zeitbuchung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "bem" has value "Zeitbuchung"
    And I close the current editor

    Given I open an editor "Zeitbuchung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEMZ_001;typa279=Storno-Zeitbuchung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "bem" has value "Zeitstorno"
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BEMZ_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P25 Durch den Storno einer Zeitbuchung werden die Zeiten im Arbeitsgang entsprechend korrigiert
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | ZEITENZ_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZEITENZ_001"
    And I close the current editor

# Zeitbuchung erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | mzeit | 3           |
      | bzeit | 3           |
      | bem   | Zeitbuchung |
    And I save the current editor

    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ZEITENZ_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I set field "bem" to "Zeitkorrektur"
    And I save the current editor

# Zeiten im Arbeitsschein sind reduziert
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "nummer" from editor "Arbeitsschein"
    And I set field "detail" to "ja"
    And I press start
    Then table has values
      | !row | bzeit | mzeit | vzeit |
      | 4    | 0     | 0     | 1.25  |
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZEITENZ_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor



### Negative Zeitbuchung: Plausichecks und Prozesstests ###

  Scenario:  N01 Durch eine negative Zeitbuchung darf die Gesamtzeit des Betriebsauftrags nicht negativ werden
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | ZUNEGATIV_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung_BA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUNEGATIV_000"
    And I set fields
      | mgr    | 112 |
      | lgr    | 1   |
      | sofort | 1   |
      | mzeit  | 1   |
      | bzeit  | 1   |
    And I save the current editor

# Fehlermeldung in Zeitkorrektur
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung_BA"
    And I set fields
      | lgr   | 2   |
      | mgr   | 112 |
      | mzeit | -2  |
    Then saving the current editor throws the exception "11126"
    And I set fields
      | mzeit | 0  |
      | bzeit | -2 |
    Then saving the current editor throws the exception "11127"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZUNEGATIV_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N02 Durch eine negative Zeitbuchung darf die Gesamtzeit des Arbeitsscheins nicht negativ werden
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch       |
      | BAUGRUPPE | 10  | ja     | ZUNEGATIVAS_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUNEGATIVAS_001"
    And I set fields
      | sofort | 1 |
      | mzeit  | 1 |
      | bzeit  | 1 |
    And I save the current editor

# Fehlermeldung in Zeitkorrektur
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung1"
    And I set field "lgr" to "2"
    And I set field "mgr" to "112"
    And I set field "mzeit" to "-2"
    Then saving the current editor throws the exception "11126"
    And I set field "mzeit" to "0"
    And I set field "bzeit" to "-2"
    Then saving the current editor throws the exception "11127"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZUNEGATIVAS_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N03 Durch eine negative Zeitbuchung in einem Kurzläufer darf die Gesamtzeit nicht negativ werden
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch      |
      | BAUGRUPPE | 10  | ja     | GESAMTZEIT_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GESAMTZEIT_001"
    And I set fields
      | sofort | ja |
      | mzeit  | 1  |
      | bzeit  | 1  |
    And I save the current editor

# Fehlermeldung in Kurzläufer auf Arbeitsschein 1
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | anfdat  | .  |
      | anfzeit | .  |
      | istzeit | -2 |
      | mzeit   | -2 |
      | sofort  | ja |
    Then saving the current editor throws the exception "11126"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "GESAMTZEIT_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N04 Eine negative Maschinenzeit im BDE-Beleg kann nicht gebucht werden
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch     | mfreig |
      | BAUGRUPPE | 10     | BDEGESAMT_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf Arbeitsschein1
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDEGESAMT_001"
    And I set field "sofort" to "ja"
    And I set fields
      | mzeit | 1 |
      | bzeit | 1 |
    And I save the current editor

# Personal- und Auftragszeit erstellen und übertragen sowie Rückmeldung buchen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Rückmeldung1"
    And I set fields
      | anfdat  | . |
      | anfzeit | . |
      | enddat  | . |
      | endzeit | . |
    Then setting field "mzeit" to "-2" throws the exception "10847"
    And I close the current editor

# Betriebsauftrag und Personalzeit abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDEGESAMT_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N05 Eine negative Zeitbuchung in einem Kurzläufer ist nur bei mge=0 und verlustmge=0 erlaubt
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch        |
      | BAUGRUPPE | 10  | ja     | AUSSCHUSSMGE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUSSCHUSSMGE_001"
    And I set fields
      | sofort | ja |
      | mzeit  | 1  |
      | bzeit  | 1  |
    And I save the current editor

# Felder prüfen in Kurzläufer auf Arbeitsschein 1
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | anfdat    | .  |
      | anfzeit   | .  |
      | automzeit | ja |
# positive Menge, negative Ist-Zeit
    And I set field "istmge" to "5"
    Then setting field "istzeit" to "-1" throws the exception "11125"
# positiver Ausschuss, negative Ist-Zeit
    And I set field "istmge" to "0"
    And I set field "istzeit" to "-1"
    And I set field "ausmge" to "5"
    And I set field "istmge" to "-1"
    Then saving the current editor throws the exception "9334"
# positive Menge, negative Maschinenzeit
    And I set field "ausmge" to "0"
    Then setting field "istmge" to "5" throws the exception "11125"
    And I set field "mzeit" to "-1"
# positiver Ausschuss, negative Maschinenzeit
    And I set field "istmge" to "0"
    And I set field "ausmge" to "5"
    And I set field "mzeit" to "-1"
    Then saving the current editor throws the exception "9334"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "AUSSCHUSSMGE_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N06 Durch eine negative Zeitbuchung auf den BA mit Zeitbuchung und Gutmenge entsteht eine Rückmeldung mit typ=Zeitkorrektur
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | BANZEIT_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung_BA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BANZEIT_000"
    And I set fields
      | mgr    | 112 |
      | lgr    | 1   |
      | sofort | 1   |
      | bzeit  | 2   |
      | mzeit  | 2   |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Zeitkorrektur
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung_BA"
    And I set fields
      | mgr   | 112  |
      | lgr   | 1    |
      | bzeit | -0.5 |
      | mzeit | -0.5 |
    And I save the current editor

# Zeitbuchung zeigen
    Given I open an editor "Zeitkorrektur_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BANZEIT_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitkorrektur |
      | mzeit   | -0.5          |
      | bzeit   | -0.5          |
    And I close the current editor

# Zeiten auf Arbeitsgang prüfen und Betriebsauftrag abschließen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung_BA"
    And I set field "detail" to "ja"
    And I press start
    Then table has values
      | bzeit | mzeit |
      | 1.5   | 1.5   |
    Then field "vzeit" is empty in row 1
    And I close the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BANZEIT_000"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "gmge" has value "0.3" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N07 Durch eine negative Zeitbuchung auf einen Arbeitsschein entsteht eine Rückmeldung mit typ=Zeitkorrektur
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | ASNZEIT_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ASNZEIT_001"
    And I set fields
      | sofort | 1 |
      | bzeit  | 2 |
      | mzeit  | 2 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Zeitkorrektur
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | bzeit | -0.5 |
      | mzeit | -0.5 |
    And I save the current editor

# Zeitbuchung zeigen
    Given I open an editor "Zeitkorrektur_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ASNZEIT_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitkorrektur |
      | mzeit   | -0.5          |
      | bzeit   | -0.5          |
    And I close the current editor

# Zeiten auf Arbeitsgang prüfen und Betriebsauftrag abschließen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung1"
    And I set field "detail" to "ja"
    And I press start
    Then field "bzeit" has value "1.5" in row 4
    Then field "mzeit" has value "1.5" in row 4
    Then field "vzeit" has value "0.3" in row 4
    And I close the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ASNZEIT_000"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "gmge" has value "0.3" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N08 Durch eine negative Zeitbuchung in einem Kurzläufer entsteht eine Rückmeldung mit typ=Zeitkorrektur
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | KURZLAUFN_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KURZLAUFN_001"
    And I set fields
      | sofort | ja |
      | mzeit  | 1  |
      | bzeit  | 1  |
    And I save the current editor

# Kurzläufer auf Arbeitsschein 1
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | .    |
      | istzeit | -0.5 |
      | mzeit   | -0.5 |
      | sofort  | ja   |
    And I save the current editor

# Kurzläufer prüfen
    Given I open an editor "Kurzläufer_pruef1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZLAUFN_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Zeitkorrektur"
    Then fields have values
      | mzeit | -0.5 |
      | bzeit | -0.5 |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "KURZLAUFN_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N09 Das erste eingetragene Vorzeichen gibt den Belegtyp der Zeitbuchung an
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch      |
      | BAUGRUPPE | 10  | ja     | VORZEICHEN_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "VORZEICHEN_000"
    And I close the current editor

# Zeitkorrektur
    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Betriebsauftrag"
    And I set field "bzeit" to "-1"
    Then field "typa279" has value "Zeitkorrektur"
    And I set field "bzeit" to "1"
    Then field "typa279" has value "Zeitbuchung"
    And I set field "sofort" to "ja"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N10 Durch eine negative Zeitbuchung auf einen abgelegten FV entsteht eine Rückmeldung mit typ=Zeitkorrektur
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | ABLAGEN_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# BA-Nummer speichern, um im weiteren Schritt den FV zu selektieren
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ABLAGEN_000"
    And I save value from field "nummer" in row 0
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABLAGEN_000"
    And I set fields
      | sofort | ja  |
      | gut    | ja  |
      | mgr    | 112 |
      | lgr    | 1   |
      | bzeit  | 2   |
      | mzeit  | 2   |
    And I save the current editor

    Given I open an editor "FVorschläge" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set fields
      | artikel   | BAUGRUPPE |
      | nurablage | ja        |
    And I set field "banummer" in row 0 to saved value
    And I press button "ladetab"
    And I save work order number from WorkOrderSuggestion in row !lastRow
    And I close the current editor

# Zeitkorrektur und Beleg prüfen
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set WorkSlip to !filed work order number in row 0
    And I set fields
      | mgr   | 112 |
      | lgr   | 1   |
      | bzeit | -1  |
      | mzeit | -1  |
    And I save the current editor

    Given I open an editor "Zeitkorrektur_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ABLAGEN_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitkorrektur auf abgelegten Fertigungsvorschlag |
      | mzeit   | -1                                               |
      | bzeit   | -1                                               |
    And I close the current editor


  Scenario: N11 Durch eine negative Zeitbuchung auf den AS eines abgelegten FV entsteht eine Rückmeldung mit typ=Zeitkorrektur
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | ASABLAGEN_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ASABLAGEN_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Zeitkorrektur zeigen und Beleg prüfen
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to id from editor "Rückmeldung1"
    And I set fields
      | bzeit | -1 |
      | mzeit | -1 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ASABLAGEN_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitkorrektur auf abgelegten Fertigungsvorschlag |
      | mzeit   | -1                                               |
      | bzeit   | -1                                               |
    And I close the current editor


  Scenario: N12 Durch eine negative Zeitbuchung auf einen abgelegten darf die Gesamtzeit des Arbeitsscheins nicht negativ werden
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | ABLAGEZUN_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABLAGEZUN_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Zeitkorrektur
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to id from editor "Rückmeldung1"
    And I set fields
      | mgr   | 112 |
      | lgr   | 1   |
      | bzeit | -5  |
    Then saving the current editor throws the exception "11127"
    And I set fields
      | bzeit | 0  |
      | mzeit | -5 |
    Then saving the current editor throws the exception "11126"
    And I close the current editor


# Bewertung ist negativ bzw. positiv und Status direkt, wenn Maschinenstundensätze angegeben sind
  Scenario: N13 Durch eine negative Zeibuchung auf einen BA und AS mit Machinengruppe über eine Zeitkorrektur dürfen die insgesamt gebuchten Fertigungskosten nicht negativ werden
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch         |
      | BAUGRUPPE | 10  | ja     | ZBU_AS_FKS_NEG |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZBU_AS_FKS_NEG001"
    And I set fields
      | sofort  | ja |
      | bzeit   | 3  |
      | mzeit   | 3  |
      | bsatz   | 12 |
      | fixkost | 8  |
    And I save the current editor

# Zeitkorrektur
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | lgr3   | 1  |
      | bzeit3 | -2 |
      | mzeit3 | -5 |
    Then saving the current editor throws the exception "11126"
    And I set fields
      | bzeit3 | -5 |
      | mzeit3 | -2 |
    Then saving the current editor throws the exception "11127"
    And I set fields
      | bzeit3 | -3 |
      | mzeit3 | -3 |
    And I close the current editor


  Scenario: N14 Durch eine negative Zeibuchung auf einen BA und AS mit Abteilung über eine Zeitkorrektur dürfen die insgesamt gebuchten Fertigungskosten nicht negativ werden
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch          |
      | BAUGRUPPE | 10  | ja     | ZBU_MGR_FKS_NEG |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZBU_MGR_FKS_NEG"
    And I set fields
      | sofort  | ja |
      | bzeit   | 3  |
      | mzeit   | 3  |
      | bsatz   | 12 |
      | fixkost | 8  |
    And I save the current editor

# Zeitkorrektur
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | lgr3   | 1  |
      | bzeit3 | -2 |
      | mzeit3 | -5 |
    Then saving the current editor throws the exception "11126"
    And I set fields
      | bzeit3 | -5 |
      | mzeit3 | -2 |
    Then saving the current editor throws the exception "11127"
    And I set fields
      | bzeit3 | -2 |
      | mzeit3 | -2 |
    And I close the current editor


  Scenario: N15 Durch eine negative Zeibuchung auf einen BA und AS über einen Kurzläufer dürfen die insgesamt gebuchten Fertigungskosten nicht negativ werden
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch      |
      | BAUGRUPPE | 10  | ja     | PDC_FKS_NEG |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PDC_FKS_NEG"
    And I set fields
      | mgr     | 112 |
      | sofort  | ja  |
      | lgr2    | 1   |
      | bzeit2  | 3   |
      | mzeit2  | 3   |
      | bsatz2  | 12  |
      | varkost | 4   |
    And I save the current editor

# Kurzläufer
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "asma" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | mgr     | 112    |
      | ma      | BDE_MA |
      | anfdat  | .      |
      | anfzeit | .      |
      | istzeit | -3     |
      | mzeit   | -2     |
      | sofort  | ja     |
    Then saving the current editor throws the exception "997"
    And I set fields
      | istzeit | -2 |
      | mzeit   | -3 |
    Then saving the current editor throws the exception "997"
    And I set fields
      | istzeit | -2 |
      | mzeit   | -2 |
    And I close the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-113" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

  Scenario: N16 Im Kurzläufer können negative und positive Zeiten nicht gemischt werden
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | MISCHUNG_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MISCHUNG_001"
    And I set fields
      | sofort | ja |
      | bzeit  | 3  |
      | mzeit  | 3  |
    And I save the current editor

# Kurzläufer
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "asma" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | mgr     | 112    |
      | ma      | BDE_MA |
      | anfdat  | .      |
      | anfzeit | .      |
      | istzeit | 1      |
      | mzeit   | -1     |
      | sofort  | ja     |
    Then saving the current editor throws the exception "266"
    And I set fields
      | istzeit | -1 |
      | mzeit   | 1  |
    Then saving the current editor throws the exception "266"
    And I close the current editor


  Scenario: N17 Storno einer Zeitkorrektur auf den Betriebsauftrag
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | BANZEITS_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung_BA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BANZEITS_000"
    And I set fields
      | mgr    | 112 |
      | lgr    | 1   |
      | sofort | 1   |
      | bzeit  | 2   |
      | mzeit  | 2   |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Zeitkorrektur und Beleg prüfen
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung_BA"
    And I set fields
      | mgr   | 112  |
      | lgr   | 1    |
      | bzeit | -0.5 |
      | mzeit | -0.5 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BANZEITS_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitkorrektur |
      | mzeit   | -0.5          |
      | bzeit   | -0.5          |
    And I close the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-113" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitkorrektur stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BANZEITS_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Storno-Zeitkorrektur |
      | mzeit   | 0.5                  |
      | bzeit   | 0.5                  |
#Then field "stornopartnervorg^id" has value equal to field "id" from editor "Zeitkorrektur_pruef"	-> Hülse
    And I save the current editor
#Then field "typa279" from editor "Zeitkorrektur_pruef" in row 0 has value "Stornierte Zeitkorrektur"	-> Hülse

# Zeiten auf Arbeitsgang prüfen und Betriebsauftrag abschließen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung_BA"
    And I set field "detail" to "ja"
    And I press start
    Then table has values
      | bzeit | mzeit |
      | 2     | 2     |
    Then field "vzeit" is empty in row 1
    And I close the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BANZEITS_000"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "gmge" has value "0.3" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N18 Storno einer Zeitkorrektur auf einen Arbeitsschein
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | ASNZEITS_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ASNZEITS_001"
    And I set fields
      | sofort | 1 |
      | bzeit  | 2 |
      | mzeit  | 2 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Zeitkorrektur und Beleg prüfen
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | bzeit | -0.5 |
      | mzeit | -0.5 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ASNZEITS_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitkorrektur |
      | mzeit   | -0.5          |
      | bzeit   | -0.5          |
    And I close the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-113" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitkorrektur stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ASNZEITS_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Storno-Zeitkorrektur |
      | mzeit   | 0.5                  |
      | bzeit   | 0.5                  |
#	| stornopartnervorg^id	| !Zeitkorrektur_pruef^id	|			-> Hülse
    And I save the current editor
#Then field "typa279" from editor "Zeitkorrektur_pruef" in row 0 has value "Stornierte Zeitkorrektur"	-> Hülse

# Zeiten auf Arbeitsgang prüfen und Betriebsauftrag abschließen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung1"
    And I set field "detail" to "ja"
    And I press start
    Then table has values
      | bzeit | mzeit | vzeit | !row |
      | 2     | 2     | 0.3   | 4    |
    And I close the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ASNZEITS_000"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "gmge" has value "0.3" in row 3
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N19 Storno einer Zeitkorrektur, die durch einen Kurzläufer entstanden ist
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch      |
      | BAUGRUPPE | 10  | ja     | KURZLAUFNS_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KURZLAUFNS_001"
    And I set fields
      | sofort | ja |
      | mzeit  | 1  |
      | bzeit  | 1  |
    And I save the current editor

# Kurzläufer auf Arbeitsschein 1 und Beleg prüfen
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | .    |
      | istzeit | -0.5 |
      | mzeit   | -0.5 |
      | sofort  | ja   |
    And I save the current editor

    Given I open an editor "Kurzläufer_pruef1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZLAUFNS_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Zeitkorrektur"
    Then fields have values
      | mzeit | -0.5 |
      | bzeit | -0.5 |
    And I close the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-113" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Kurzläufer stornieren
    Given I open an editor "Storno1" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer1"
    Then fields have values
      | typa332              | Storno-Auftragszeit |
      | stornopartnervorg^id | !Kurzläufer1^id     |
      | istzeit              | 0.5                 |
      | mzeit                | 0.5                 |
    And I save the current editor
#Then field "typa279" from editor "Kurzläufer_pruef1" in row 0 has value "Stornierte Zeitkorrektur"		-> Hülse

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "KURZLAUFNS_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N20 Storno einer Zeitkorrektur auf einen Betriebsauftrag, abgelegter FV
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | BANZEITA_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung_BA1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BANZEITA_000"
    And I set fields
      | mgr    | 112 |
      | lgr    | 1   |
      | sofort | 1   |
      | bzeit  | 2   |
      | mzeit  | 2   |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Zeitkorrektur und Beleg prüfen
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung_BA1"
    And I set fields
      | mgr   | 112  |
      | lgr   | 1    |
      | bzeit | -0.5 |
      | mzeit | -0.5 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BANZEITA_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitkorrektur |
      | mzeit   | -0.5          |
      | bzeit   | -0.5          |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung_BA2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BANZEITA_000"
    And I set fields
      | mgr    | 112 |
      | lgr    | 1   |
      | sofort | 1   |
      | gut    | ja  |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-113" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitkorrektur stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BANZEITA_000;mzeit=-0,5;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Storno-Zeitkorrektur auf abgelegten Fertigungsvorschlag |
      | mzeit   | 0.5                                                     |
      | bzeit   | 0.5                                                     |
#Then field "stornopartnervorg^id" has value equal to field "id" from editor "Zeitkorrektur_pruef"	-> Hülse
    And I save the current editor
#Then field "typa279" from editor "Zeitkorrektur_pruef" in row 0 has value "Stornierte Zeitkorrektur"	-> Hülse


  Scenario: N21 Storno einer Zeitkorrektur auf einen Arbeitsschein, abgelegter FV
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | ASNZEITA_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ASNZEITA_001"
    And I set fields
      | sofort | 1 |
      | bzeit  | 2 |
      | mzeit  | 2 |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Zeitkorrektur und Beleg prüfen
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | bzeit | -0.5 |
      | mzeit | -0.5 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ASNZEITA_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitkorrektur |
      | mzeit   | -0.5          |
      | bzeit   | -0.5          |
    And I close the current editor

# Komplettrückmeldung
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ASNZEITA_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-113" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."


# Zeitkorrektur stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ASNZEITA_001;mzeit=-0,5;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Storno-Zeitkorrektur auf abgelegten Fertigungsvorschlag |
      | mzeit   | 0.5                                                     |
      | bzeit   | 0.5                                                     |
#	| stornopartnervorg^id	| !Zeitkorrektur_pruef^id	|		-> Hülse
    And I save the current editor
#Then field "typa279" from editor "Zeitkorrektur_pruef" in row 0 has value "Stornierte Zeitkorrektur"	-> Hülse


  Scenario: N22 Storno einer nachträglichen Zeitkorrektur auf einen abgelegten FV
# Fertigungsvorschlag anlegen, freigeben und Komplettrückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | NACHTRAGA_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NACHTRAGA_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Zeitkorrektur und Beleg prüfen
    Given I open an editor "Zeitkorrektur1" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "id" from editor "Rückmeldung1"
    And I set fields
      | bzeit | -0.5 |
      | mzeit | -0.5 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=NACHTRAGA_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitkorrektur auf abgelegten Fertigungsvorschlag |
      | mzeit   | -0.5                                             |
      | bzeit   | -0.5                                             |
    And I close the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-113" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitkorrektur stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=NACHTRAGA_001;mzeit=-0,5;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Storno-Zeitkorrektur auf abgelegten Fertigungsvorschlag |
      | mzeit   | 0.5                                                     |
      | bzeit   | 0.5                                                     |
#	| stornopartnervorg^id	| !Zeitkorrektur_pruef^id	|	-> Hülse
    And I save the current editor
#Then field "typa279" from editor "Zeitkorrektur_pruef" in row 0 has value "Stornierte Zeitkorrektur auf abgelegten Fertigungsvorschlag"	--> Hülse


  Scenario: N23 Storno einer Zeitkorrektur, die durch einen Kurzläufer entstanden ist, abgelegter FV
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch      |
      | BAUGRUPPE | 10  | ja     | KURZLAUFNA_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KURZLAUFNA_001"
    And I set fields
      | sofort | ja |
      | mzeit  | 1  |
      | bzeit  | 1  |
    And I save the current editor

# Kurzläufer auf Arbeitsschein 1 und Beleg prüfen
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | .    |
      | istzeit | -0.5 |
      | mzeit   | -0.5 |
      | sofort  | ja   |
    And I save the current editor

    Given I open an editor "Kurzläufer_pruef1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZLAUFNA_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Zeitkorrektur"
    Then fields have values
      | mzeit | -0.5 |
      | bzeit | -0.5 |
    And I close the current editor

# Komplettrückmeldung
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KURZLAUFNA_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-113" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Kurzläufer stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=KURZLAUFNA_001;mzeit=-0,5;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then fields have values
      | typa279 | Storno-Zeitkorrektur auf abgelegten Fertigungsvorschlag |
#	| stornopartnervorg^id	| !Kurzläufer_pruef1^id	|		-> Hülse
      | bzeit   | 0.5                                                     |
      | mzeit   | 0.5                                                     |
    And I save the current editor
#Then field "typa279" from editor "Kurzläufer_pruef1" in row 0 has value "Stornierte Zeitkorrektur"		-> Hülse


  Scenario: N24 Eine Storno-Zeitkorrekur oder stornierte Zeitkorrekur kann nicht storniert werden
# Fertigungsvorschlag anlegen, freigeben und Arbeitsschein öffnen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | FEHLERA_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FEHLERA_001"
    And I close the current editor

# Zeitbuchung, Zeitkorrektur und Zeitkorrektur öffnen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | bzeit | 2 |
      | mzeit | 2 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | bzeit | -2 |
      | mzeit | -2 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FEHLERA_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-113" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."

# Zeitbuchung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=FEHLERA_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I save the current editor

    Given I open an editor "Storno1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FEHLERA_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Storno-Teitkorrektur und Stornierte Zeitkorrektur können nicht storniert werden: nicht gefunden (149)
#Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Zeitkorrektur1" throws the exception "149"	-> Hülse
#Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Storno1_pruef" throws the exception "149"	-> Hülse

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FEHLERA_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

# Fertigungskostenverbuchung
    Given I create a CostEntriesSuggestion "fkv-114" with type of cost entry "Verbuchung Fertigungskosten" for startdate "." until enddate "."


  Scenario: N25 Bis auf Bemerkung sind im Storno-Beleg einer Zeitkorrektur alle Felder schreibgeschützt
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | SCHREIBSK_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SCHREIBSK_001"
    And I close the current editor

# Zeitbuchung und Zeitkorrektur erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | mzeit | 3 |
      | bzeit | 3 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | mzeit | -1 |
      | bzeit | -1 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCHREIBSK_001;@richtung=rückwärts;typa279=Zeitkorrektur;@ablageart=abgelegt;@maxtreffer=1"
    Then fields have values
      | mzeit | 1 |
      | bzeit | 1 |
    Then field "mzeit" is not modifiable
    Then field "bzeit" is not modifiable
    Then field "mgr" is not modifiable
    Then field "verw" is not modifiable
    Then field "kstelle" is not modifiable
    Then field "bem" is modifiable
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCHREIBSK_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N26 Das Feld Bemerkung wird in den Storno-Belegen der Zeitkorrektur vererbt
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | BEMK_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BEMK_001"
    And I close the current editor

# Zeitbuchung und Zeitkorrektur erstellen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | mzeit | 3           |
      | bzeit | 3           |
      | bem   | Zeitbuchung |
    And I save the current editor

    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | mzeit | -1            |
      | bzeit | -1            |
      | bem   | Zeitkorrektur |
    And I save the current editor

# Zeitkorrektur stornieren
    Given I open an editor "Zeitkorrektur_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BEMK_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I set field "bem" to "Zeitstorno"
    And I save the current editor

# Feld Bemerkung in Original- und Stornobeleg prüfen
    Given I open an editor "Zeitkorrektur" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEMK_001;typa279=Stornierte Zeitkorrektur;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "bem" has value "Zeitkorrektur"
    And I close the current editor

    Given I open an editor "Zeitkorrektur" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEMK_001;typa279=Storno-Zeitkorrektur;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "bem" has value "Zeitstorno"
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BEMK_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N27 Durch den Storno einer Zeitkorrektur werden die Zeiten im Arbeitsgang erhöht
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | ZEITKORR_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZEITKORR_001"
    And I close the current editor

# Zeitbuchung und Zeitkorrektur erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | mzeit | 3 |
      | bzeit | 3 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | mzeit | -1 |
      | bzeit | -1 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ZEITKORR_001;@richtung=rückwärts;typa279=Zeitkorrektur;@ablageart=abgelegt;@maxtreffer=1"
    Then fields have values
      | mzeit | 1 |
      | bzeit | 1 |
    Then field "typa279" has value "Storno-Zeitkorrektur"
    And I save the current editor

    Given I open an editor "Zeitkorrektur_Orig" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZEITKORR_001;@richtung=rückwärts;bzeit=-1;@ablageart=abgelegt;@maxtreffer=1"
    Then fields have values
      | sofort | nein |
      | mzeit  | -1   |
      | bzeit  | -1   |
    Then field "typa279" has value "Stornierte Zeitkorrektur"
    And I close the current editor

# Zeiten im Arbeitsschein sind wieder erhöht
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "nummer" from editor "Arbeitsschein"
    And I set field "detail" to "ja"
    And I press start
    Then table has values
      | !row | bzeit | mzeit | vzeit |
      | 4    | 3     | 3     | 1.25  |
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZEITKORR_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N28 Storno einer Rückmeldung, zu der es eine Zeitkorrektur gibt, nicht möglich
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | RUECKMR_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RUECKMR_001"
    And I close the current editor

# Rückmeldung und Zeitkorrektur erstellen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKMR_001"
    And I set field "sofort" to "ja"
    And I set fields
      | mzeit | 3 |
      | bzeit | 3 |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Rückmeldung1"
    And I set fields
      | mzeit | -1 |
      | bzeit | -1 |
    And I save the current editor

# Rückmekdung1 stornieren
    Given I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
#  11126 de   |Die zurückzubuchende Maschinenzeit kann nicht größer als die bereits mit der Maschinengruppe gebuchte Maschinenzeit sein.
    Then saving the current editor throws the exception "11126"
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "RUECKMR_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N29 Storno einer Auftragszeit darf nicht mehr stornieren, als gebucht wurde, die Maschinengruppe muss angegeben werden
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 11  | ja     | AZMISCH_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AZMISCH_001"
    And I set fields
      | sofort | ja |
      | bzeit  | 1  |
      | mzeit  | 1  |
    And I save the current editor

# Personalzeit
    Given I open an editor "Personalzeit1" from table "(PDC):(TimeAndLaborData)" with command "NEW" for record ""
    And I set fields
      | ma      | BDE_MA |
      | anfdat  | .      |
      | anfzeit | -4     |
    And I save the current editor

# Auftragszeit
    Given I open an editor "Auftragszeit1" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "asma" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | mgr       |        |
      | ma        | BDE_MA |
      | anfdat    | .      |
      | anfzeit   | .      |
      | enddat    | .      |
      | endzeit   | -1     |
      | sofort    | ja     |
    Then saving the current editor throws the exception "320"
    And I set fields
      | mgr       | 112 |
      | automzeit | ja  |
      | endzeit   | +1  |
    And I save the current editor


  Scenario: U01 ungebuchte Zeitbuchung erfassen über TimeEntry und löschen über Workorder CompletionConfirmation DELETE

# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | U01_   |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung_BA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "U01_000"
    And I set fields
      | mgr    | 112 |
      | sofort | ja  |
      | lgr    | 1   |
      | bzeit  | 1   |
      | mzeit  | 1   |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Zeitbuchung erfassen ohne Buchen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung_BA"
    And I set fields
      | sofort | nein   |
      | mgr    | 112    |
      | ma     | BDE_MA |
      | bzeit  | 0.5    |
      | mzeit  | 0.5    |
    And I save the current editor

# ungebuchte Zeitbuchung zeigen
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for search criteria "$,,such=U01_000;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitbuchung |
      | mzeit   | 0.5         |
      | bzeit   | 0.5         |
      | sofort  | nein        |
    And I close the current editor

# Betriebsauftrag abschließen nicht möglich, Status ist schreibgeschützt
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "U01_000"
    Then field "status" is not modifiable
    And I close the current editor

# Zeiten auf BA prüfen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung_BA"
    And I press start
    Then table has values
      | bzeit | mzeit |
      | 1     | 1     |
    And I close the current editor

# weitere Zeitbuchung erstellen nicht möglich, da es bereits ungebuchte Zeitbuchung gibt
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
# 253 Vorher übernehmen
    Then setting field "barmex" in row 0 to "barmex" from editor "Rückmeldung_BA" in row 0 throws the exception "253"
    And I close the current editor


## dieser Step ist noch nicht vorhanden, search criteria erforderlich, da keine Datensatz-Id

# ungebuchten Zeitrückmeldebeleg stornieren ist nicht möglich
# 7058 de |Dieser Vorgang ist noch nicht gebucht.
#Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=U01_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1" throws the exception "7058"
#And I close the current editor

# Zeitbuchung löschen
    Given I open an editor "Zeitbuchung_loeschen" from table "(Workorder):(CompletionConfirmations)" with command "DELETE" for search criteria "$,,such=U01_000;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
    And I respond with answer "ja" to the dialog with id "826"
    And I save the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "U01_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: U02 ungebuchte Zeitbuchung erfassen über TimeEntry und ändern, dann buchen über Workorder TRANSFER, dann stornieren

# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | U02_   |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung_BA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "U02_000"
    And I set fields
      | mgr    | 112    |
      | sofort | ja     |
      | ma     | BDE_MA |
      | bzeit  | 1      |
      | mzeit  | 1      |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Zeitbuchung erfassen ohne Buchen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung_BA"
    And I set fields
      | sofort | nein   |
      | mgr    | 112    |
      | ma     | BDE_MA |
      | bzeit  | 0.5    |
      | mzeit  | 0.5    |
    And I save the current editor

# Zeitbuchung ändern ohne buchen, Maske Zeitbuchung
    Given I open an editor "Zeitbuchung_aendern" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for search criteria "$,,such=U02_000;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitbuchung   |
      | grbez   | Rückmeldungen |
      | mzeit   | 0.5           |
      | bzeit   | 0.5           |
      | sofort  | nein          |
    And I set field "bzeit" to "1"
    And I save the current editor

# ungebuchte Zeitbuchung buchen
    Given I open an editor "Zeitbuchung_buchen" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for search criteria "$,,such=U02_000;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
    And I save the current editor

# Zeiten auf BA prüfen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung_BA"
    And I press start
    Then table has values
      | bzeit | mzeit |
      | 2     | 1.5   |
    And I close the current editor

# gebuchte Zeitbuchung stornieren, Storno wird sofort gebucht
    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=U02_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I save the current editor

# Zeiten auf BA prüfen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung_BA"
    And I press start
    Then table has values
      | bzeit | mzeit |
      | 1     | 1     |
    Then field "vzeit" is empty in row 1
    And I close the current editor

# Zeitkorrektur erfassen, aber nicht buchen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung_BA"
    And I set fields
      | sofort | nein   |
      | mgr    | 112    |
      | ma     | BDE_MA |
      | bzeit  | -0.5   |
      | mzeit  | -0.5   |
    And I save the current editor

# Zeitkorrektur ändern ohne buchen
    Given I open an editor "Zeitkorrektur_aendern" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for search criteria "$,,such=U02_000;typa279=Zeitkorrektur;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitkorrektur |
      | mzeit   | -0.5          |
      | bzeit   | -0.5          |
      | sofort  | nein          |
    And I set fields
      | bzeit | -0.25 |
      | mzeit | -0.25 |
    And I save the current editor

# ungebuchte Zeitkorrektur buchen
    Given I open an editor "Zeitkorrektur_buchen" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for search criteria "$,,such=U02_000;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
    And I save the current editor

# Zeiten auf BA prüfen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung_BA"
    And I press start
    Then table has values
      | bzeit | mzeit |
      | 0.75  | 0.75  |
    Then field "vzeit" is empty in row 1
    And I close the current editor

# gebuchte Zeitkorrektur stornieren, Storno wird sofort gebucht
    Given I open an editor "Zeitkorrektur_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=U02_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I save the current editor

# Zeiten auf BA prüfen und Betriebsauftrag abschließen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung_BA"
    And I press start
    Then table has values
      | bzeit | mzeit |
      | 1     | 1     |
    Then field "vzeit" is empty in row 1
    And I close the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "U02_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: U03 ungebuchte Zeitbuchung erstellen über Auftragszeit erfassen und übertragen, dann ändern, dann buchen, dann BDE-Objekt stornieren

# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | U03_   | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf Arbeitsschein1
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "U03_001"
    And I set fields
      | sofort | ja |
      | mzeit  | 1  |
      | bzeit  | 1  |
    And I save the current editor

# Personal- und Auftragszeit erstellen und übertragen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Rückmeldung1"
    And I set fields
      | anfdat    | .       |
      | anfzeit   | 9:00    |
      | enddat    | .       |
      | endzeit   | 10:00   |
      | automzeit | ja      |
      | sofort    | nein    |
      | bem       | BDE_U03 |
    And I save the current editor

# Auftragszeit übertragen
    And I switch the current editor to editor "Auftragszeit" with command "TRANSFER"
    And I save the current editor

# ungebuchte Zeitbuchung ist entstanden
    Given I open an editor "Zeitbuchung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=U03_001;@richtung=rückwärts;@ablageart=lebendig;@maxtreffer=1"
    Then field "typa279" has value "Zeitbuchung"
    And I close the current editor

# Zeitbuchung ändern und sofort auf ja, dadurch wird beim Speichern gebucht
    Given I open an editor "Zeitbuchung_aendern" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for search criteria "$,,such=U03_001;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitbuchung |
      | bzeit   | 1           |
      | sofort  | nein        |
    And I set field "bzeit" to "2"
    And I set field "sofort" to "ja"
    And I save the current editor

# Zeiten auf Arbeitsschein prüfen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung1"
    And I set field "detail" to "ja"
    And I press start
    Then field "bzeit" has value "3" in row 4
    Then field "mzeit" has value "2" in row 4
    And I close the current editor

### diesen Step gibt es noch nicht, ist aber geplant das umzusetzen, Steffen ist informiert
## gebuchte Zeitbuchung direkt stornieren nicht möglich
# Die Rückmeldung kann nur durch Stornieren des BDE-Satzes storniert werden.
#Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=U03_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1" throws the exception "10917"
#And I close the current editor

# BDE-Objekt stornieren
    And I switch the current editor to editor "Auftragszeit" with command "REVERSAL"
    And I set field "bem" to "STORNO_U03"
    And I save the current editor

# Stornierte Zeitbuchung zeigen
    Given I open an editor "Rueckmeldung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=U03_001;bzeit=2;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    Then fields have values
      | typa279 | Stornierte Zeitbuchung |
    And I close the current editor

# Storno Zeitbuchung zeigen
    Given I open an editor "Storno_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=U03_001;bzeit=-2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Storno-Zeitbuchung |
    And I close the current editor

# Zeiten auf Arbeitsschein prüfen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung1"
    And I set field "detail" to "ja"
    And I press start
    Then field "bzeit" has value "1" in row 4
    Then field "mzeit" has value "1" in row 4
    And I close the current editor

### Kommando "Auftragszeit und Betriebsauftrag übertragen" sollte getestet werden, momentan nicht klar, wie das funktioniert in Cucumber, Steffen ist informiert
# weitere Auftragszeit erfassen und direkt übertragen und durchbuchen durch "Beleg buchen"
    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Rückmeldung1"
    And I set fields
      | anfdat    | .     |
      | anfzeit   | 10:30 |
      | enddat    | .     |
      | endzeit   | 11:30 |
      | automzeit | ja    |
      | sofort    | ja    |
    And I save the current editor

# Zeiten auf Arbeitsschein prüfen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung1"
    And I set field "detail" to "ja"
    And I press start
    Then field "bzeit" has value "2" in row 4
    Then field "mzeit" has value "2" in row 4
    And I close the current editor

# Betriebsauftrag und Personalzeit abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "U03_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: U04 ungebuchte Zeitbuchung erstellen, dann Auftragszeit erfassen, übertragen ist nicht möglich

# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | U04_   | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "U04_001"
    And I close the current editor

# Personalzeit erstellen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor

# Zeitbuchung erfassen ohne Buchen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | nein   |
      | mgr    | 112    |
      | ma     | BDE_MA |
      | bzeit  | 0.5    |
      | mzeit  | 0.5    |
    And I save the current editor

# Auftragszeit erfassen ohne buchen
    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | anfdat    | .    |
      | anfzeit   | 8:15 |
      | enddat    | .    |
      | endzeit   | 9:15 |
      | automzeit | ja   |
      | sofort    | nein |
    And I save the current editor

# Auftragszeit übertragen nicht möglich, weil ungebuchter Zeitrückmeldebeleg vorhanden
    And I switch the current editor to editor "Auftragszeit" with command "TRANSFER"
    Then saving the current editor throws the exception "8808"
    And I close the current editor

# Zeitrückmeldebeleg buchen
    Given I open an editor "Zeitbuchung_buchen" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for search criteria "$,,such=U04_001;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
    And I save the current editor

# Auftragszeit übertragen und daraus entstandenen Zeitrückmeldebeleg buchen
## es sollte Kommando "Auftragszeit und Betriebsauftrag übertragen" verwendet werden, noch klären ob das geht

# das Suchwort funktioniert nur, wenn man fake date 03.02.1995 verwendet
#Given I open an editor "Auftragszeit_buchen" from table "(PDC):(OrderTime)" with command "TRANSFER" for record "A19950203-0815" and menu choice "Auftragszeit und Betriebsauftrag"
#And I save the current editor
## Step wird ausgeführt, scheint aber nur "Auftragszeit übertragen" durchzuführen

#Given I open an editor "Auftragszeit_buchen" from table "(PDC):(OrderTime)" with command "TRANSFER" for record "A19950203-0815" and menu choice "OrderTime and WorkOrder"
#And I save the current editor

## mit einzelnen Schritten lässt sich die Auftragszeit übertragen und die daraus entstandene Zeitbuchung buchen
    And I switch the current editor to editor "Auftragszeit" with command "TRANSFER"
    And I save the current editor

    Given I open an editor "Zeitbuchung_buchen" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for search criteria "$,,such=U04_001;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
    And I save the current editor


# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "U04_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: U05 ungebuchte Zeitbuchung erfassen auf BA über TimeEntry, alle AS komplett buchen, BA wird nicht gelöscht, Zeitbuchung noch buchen

# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | U05_   |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "U05_000"
    And I close the current editor

# Zeitbuchung erfassen ohne Buchen, auf Arbeitsschein 1
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Betriebsauftrag"
    And I set fields
      | sofort | nein   |
      | mgr    | 112    |
      | ma     | BDE_MA |
      | bzeit  | 0.5    |
      | mzeit  | 0.5    |
    And I save the current editor

# ungebuchte Zeitbuchung zeigen
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for search criteria "$,,such=U05_000;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitbuchung |
      | mzeit   | 0.5         |
      | bzeit   | 0.5         |
      | sofort  | nein        |
    And I close the current editor

# komplette Rückmeldung auf Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "U05_001"
    And I set fields
      | mzeit  | 1  |
      | bzeit  | 1  |
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

# Betriebsauftrag noch vorhanden, Status * und schreibgeschützt, weil offene Zeitbuchung vorhanden
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "U05_000"
    Then field "status" has value "*"
    Then field "status" is not modifiable
    And I close the current editor

# ungebuchte Zeitkorrektur buchen
    Given I open an editor "Zeitkorrektur_buchen" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for search criteria "$,,such=U05_000;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
    And I save the current editor

# Betriebsauftrag ist gelöscht
    Then opening an editor from table "(Workorder):(WorkOrders)" with command "VIEW" for record "U05_000" throws the exception "149"
    And I close the current editor


  Scenario: U06 ungebuchte Zeitbuchung auf abgelegten FV erfassen über TimeEntry, wird beim Speichern gebucht

# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | U06_   |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf BA, damit Kopiervorlage für Nachbuchen vorhanden ist
    Given I open an editor "RückmeldungBA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "U06_000"
    And I set fields
      | sofort | ja |
      | mgr    | 1  |
      | lgr    | 1  |
      | bzeit  | 1  |
      | mzeit  | 1  |
    And I save the current editor

# Komplettrückmeldung auf Arbeitschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "U06_001"
    And I set fields
      | sofort | ja   |
      | gut    | ja   |
      | bzeit  | 1.25 |
      | mzeit  | 1.25 |
    And I save the current editor

# Zeitbuchung auf abgelegten Fertigungsvorschlag, wird direkt gebucht, sofort ist gesetzt und schreibgeschützt
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to id from editor "Rückmeldung1"
    Then field "sofort" has value "ja"
    Then field "sofort" is not modifiable in row 0
    And I set fields
      | mgr   | 1 |
      | lgr   | 1 |
      | bzeit | 1 |
      | mzeit | 1 |
    And I save the current editor

# Zeitbuchung zeigen
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=U06_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitbuchung auf abgelegten Fertigungsvorschlag |
      | mzeit   | 1                                              |
      | bzeit   | 1                                              |
    And I close the current editor

# Zeitkorrektur auf abgelegten Fertigungsvorschlag, wird direkt gebucht, sofort ist gesetzt und schreibgeschützt
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to id from editor "RückmeldungBA"
    Then field "sofort" has value "ja"
    Then field "sofort" is not modifiable
    And I set fields
      | mgr   | 1    |
      | lgr   | 1    |
      | bzeit | -0,5 |
      | mzeit | -0,5 |
    And I save the current editor

# Zeitkorrektur zeigen
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=U06_000;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitkorrektur auf abgelegten Fertigungsvorschlag |
      | mzeit   | -0.5                                             |
      | bzeit   | -0.5                                             |
    And I close the current editor


  Scenario: U07 ungebuchte Zeitbuchung erstellen über Auftragszeit erfassen und übertragen, dann BDE-Objekt stornieren, dann Zeitbuchung buchen

# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | U07_   | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "U07_001"
    And I set fields
      | sofort | ja   |
      | bzeit  | 1.25 |
      | mzeit  | 1.25 |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Personal- und Auftragszeit erstellen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Rückmeldung1"
    And I set fields
      | anfdat    | .      |
      | anfzeit   | 9:00   |
      | enddat    | .      |
      | endzeit   | 10:00  |
      | automzeit | ja     |
      | sofort    | nein   |
      | bem       | AZ_U07 |
    And I save the current editor

# Auftragszeit übertragen
    And I switch the current editor to editor "Auftragszeit" with command "TRANSFER"
    And I save the current editor

# ungebuchte Zeitbuchung ist entstanden
    Given I open an editor "Zeitbuchung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=U07_001;@richtung=rückwärts;@ablageart=lebendig;@maxtreffer=1"
    Then field "typa279" has value "Zeitbuchung"
    And I close the current editor

# BDE-Objekt stornieren
    And I switch the current editor to editor "Auftragszeit" with command "REVERSAL"
    And I set field "bem" to "STORNO_U07"
    And I save the current editor

# ungebuchte Zeitbuchung ist nicht mehr vorhanden
    Given I query "such,typa279" from table "(Workorder):(CompletionConfirmations)" where "such=U07_001;typa279=Zeitbuchung"
    Then query has no hits

# stornierte Auftragszeit wird nicht mehr übertragen, uebertr ist nein
    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,bem=AZ_U07;@richtung=rückwärts;@ablageart=lebendig;@maxtreffer=1"
    Then field "uebertr" has value "nein"
    And I save the current editor

# Storno-Auftragszeit wird nicht übertragen, uebertr ist nein
    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,bem=STORNO_U07;@richtung=rückwärts;@ablageart=lebendig;@maxtreffer=1"
    Then field "uebertr" has value "nein"
    And I save the current editor

# Zeiten auf Arbeitsschein prüfen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "barmex" from editor "Rückmeldung1"
    And I set field "detail" to "ja"
    And I press start
    Then field "bzeit" has value "1.25" in row 4
    Then field "mzeit" has value "1.25" in row 4
    And I close the current editor


# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "U07_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: U08 Auftragszeit erfassen, BA komplett bebuchen, Auftragszeit übertragen, dann Zeitbuchung buchen

# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | U08_   | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Arbeitsschein öffnen um Zugriff auf Nummer zu haben
    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "U08_001"
    And I close the current editor

# Personal- und Auftragszeit erstellen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | anfdat    | .     |
      | anfzeit   | 9:00  |
      | enddat    | .     |
      | endzeit   | 10:00 |
      | automzeit | ja    |
      | sofort    | nein  |
    And I save the current editor

# Komplettrückmeldung auf BA
    Given I open an editor "RückmeldungBA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "U08_000"
    And I set fields
      | sofort | ja   |
      | gut    | ja   |
      | mgr    | 1    |
      | lgr    | 1    |
      | bzeit  | 1.25 |
      | mzeit  | 1.25 |
    And I save the current editor

# BA ist erledigt, hat Löschschutz bekommen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "U08_000"
    Then field "status" has value "*"
    Then field "noloesch" has value "ja"
# 10931 de      |Löschschutz kann nicht entfernt werden, da noch offene BDE Vorgänge vorhanden sind.
    Then setting field "noloesch" to "nein" throws the exception "10931"
    And I close the current editor

# Auftragszeit übertragen
    And I switch the current editor to editor "Auftragszeit" with command "TRANSFER"
    And I save the current editor

# ungebuchte Zeitbuchung ist entstanden
    Given I open an editor "Zeitbuchung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=U08_001;@richtung=rückwärts;@ablageart=lebendig;@maxtreffer=1"
    Then field "typa279" has value "Zeitbuchung"
    And I close the current editor

# ungebuchte Zeitbuchung buchen
    Given I open an editor "Zeitbuchung_buchen" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for search criteria "$,,such=U08_001;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
    And I save the current editor

# Zeiten auf Arbeitsschein prüfen
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "nummer" from editor "Arbeitsschein"
    And I set field "detail" to "ja"
    And I press start
    Then field "bzeit" has value "1" in row 4
    Then field "mzeit" has value "1" in row 4
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "U08_000"
    And I set field "noloesch" to "nein"
    And I save the current editor


  Scenario: NA1 Nachbuchen auf abgelegten BA ohne Fertigteil im Kopf der RM holt sich das Fertigteil aus dem FV
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch  |
      | BAUGRUPPE | 11  | ja     | NACHBU_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NACHBU_001"
    And I set fields
      | sofort | ja   |
      | gut    | ja   |
      | bzeit  | 2.25 |
      | mzeit  | 2.25 |
    And I save the current editor

    Given I open an editor "FVorschläge" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set fields
      | artikel   | BAUGRUPPE |
      | nurablage | ja        |
    And I press button "ladetab"
    And I save work order number from WorkOrderSuggestion in row !lastRow
    And I close the current editor

# Fertigteil im Kopf der RM löschen
    Given I'm logged in with password "annette"
    Given I enable the flag 71
    Given I open an editor "Zeitbuchung_ohne_cfbew" from table "(Workorder):(CompletionConfirmations)" with command "MODIFY" for search criteria "$,,such=NACHBU_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "artikel" to ""
    And I save the current editor
    Given I disable the flag 71
    Given I'm logged in with password "sy"

# Per Flag 71 geänderte Zeitbuchung prüfen
    Given I open an editor "Zeitbuchung_ohne_cfbew_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=NACHBU_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then field "artikel" is empty
    And I close the current editor

# Zeitbuchung
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "+NACHBU_001"
    And I set fields
      | mgr   | 1 |
      | lgr   | 1 |
      | bzeit | 2 |
      | mzeit | 2 |
    And I save the current editor

# Zeitbuchung zeigen
    Given I open an editor "Zeitbuchung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=NACHBU_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then fields have values
      | typa279 | Zeitbuchung auf abgelegten Fertigungsvorschlag |
      | artikel | BAUGRUPPE                                      |
      | mzeit   | 2                                              |
      | bzeit   | 2                                              |
    And I close the current editor

  Scenario: AM1 Flag "Maschinenzeit in BDE vorschlagen" testen
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch   |
      | BGAUTOMZEIT | 13  | ja     | AMZEIT1_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Auftragszeit auf 1. AG mit Mgr mit automzeit = ja
    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA"
    And I set field "asma" to "AMZEIT1_001"
    Then field "automzeit" has value "ja"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 9:00  |
      | enddat  | .     |
      | endzeit | 11:30 |
      | korr    | -0.15 |
    Then field "mzeit" has value "2.1"
    And I set field "automzeit" to "nein"
    And I set field "mzeit" to "1"
    And I set field "automzeit" to "ja"
    Then field "mzeit" has value "2.1"
    And I set field "mgr" to "BOHR"
    Then field "automzeit" has value "nein"
    And I set field "mzeit" to "2"
    And I set field "mgr" to "LACK"
    Then field "automzeit" has value "ja"
    Then field "mzeit" has value "2.1"
    And I set field "mzeit" to "3"
    And I set field "istmge" to "1"
    And I set field "sofort" to "ja"
    And I save the current editor

# Rückmeldungen prüfen
    Given I open an editor "RMAZ" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AMZEIT1_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then field "mzeit" has value "3"
    And I close the current editor

# Kurzläufer auf auf 1. AG mit Mgr mit automzeit = ja
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA"
    And I set field "asma" to "AMZEIT1_001"
    Then field "automzeit" has value "ja"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 7:00  |
      | istzeit | 4.5   |
    Then field "mzeit" has value "4.5"
    And I set field "automzeit" to "nein"
    And I set field "mzeit" to "1"
    And I set field "automzeit" to "ja"
    Then field "mzeit" has value "4.5"
    And I set field "mgr" to "BOHR"
    Then field "automzeit" has value "nein"
    And I set field "mzeit" to "2"
    And I set field "mgr" to "LACK"
    Then field "automzeit" has value "ja"
    Then field "mzeit" has value "4.5"
    And I set field "mzeit" to "4"
    And I set field "istmge" to "2"
    And I set field "sofort" to "ja"
    And I save the current editor

# Rückmeldungen prüfen
    Given I open an editor "RMKURZ" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AMZEIT1_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then field "mzeit" has value "4"
    And I close the current editor

