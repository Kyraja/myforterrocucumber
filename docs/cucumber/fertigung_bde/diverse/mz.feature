# *****************************************************************************
# Name             : mz.feature
# Autor            : amk
# Verantwortlich   : amk
# Kontrolle        : drpf
# Funktion         : Testet diverse Prozesse im Zusammenhang mit
# Materialzuordnungen in der Fertigung.
# *****************************************************************************
@persistent
Feature: mz.feature

  # FDA-5349: MZ bleibt liegen wenn es mehrere ungebuchte RM zu einem FV gibt
  Scenario: 0. Vorbereitung: Fertigungsvorschlag anlegen und ungebuchte Rueckmeldung erfassen
    # Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV_neu" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | verw    | mfreig | bisuch   |
      | BG-AUFTRAG | 10     | MZPRUEF | ja     | MZPRUEF_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "FV_neu"
    And I save the current editor
    # Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "RM_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZPRUEF_001"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

  Scenario: 1. Zugangs-MZ anlegen auf Fertigungsvorschlag ist nicht erlaubt
    Given I open an editor "FV_MZZU" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-AUFTRAG"
    And I press button "ladetab"
    Then pressing button "mzsubm" throws the exception "1283"
    And I close the current editor

  Scenario: 2. Zugangs-MZ anlegen auf AFL ist nicht erlaubt
    Given I open an editor "FV_MZZU" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-AUFTRAG"
    And I press button "ladetab"
    Then pressing button "absteig" in row 1 throws the exception "1191"
    And I close the current editor

  Scenario: 3. Zugangs-MZ anlegen auf AS1 ist nicht erlaubt
    Given I open an editor "AS1_MZZU" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MZPRUEF_001"
    Then pressing button "mzsubm" throws the exception "1272"
    And I close the current editor

  Scenario: 4. Zugangs-MZ anlegen auf AS2 ist nicht erlaubt
    Given I open an editor "AS2_MZZU" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MZPRUEF_002"
    Then pressing button "mzsubm" throws the exception "1272"
    And I close the current editor

  Scenario: 5. Zugangs-MZ anlegen auf BA ist nicht erlaubt
    Given I open an editor "BA_MZZU" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MZPRUEF_000"
    Then pressing button "mzsubm" throws the exception "1089"
    And I close the current editor

  Scenario: 6. Zugangs-MZ anlegen auf RM auf AS2 ist nicht erlaubt
    Given I open an editor "RM_AS2_MZZU" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZPRUEF_002"
    Then pressing button "mzsubm" throws the exception "1283"
    And I close the current editor

  Scenario: 7. Zugangs-MZ anlegen auf RM auf BA ist nicht erlaubt
    Given I open an editor "RM_BA_MZZU" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZPRUEF_000"
    Then pressing button "mzsubm" throws the exception "1283"
    And I close the current editor

  Scenario: 8. Zugangs-MZ anlegen auf ungebuchte RM auf AS1 ist erlaubt
    Given I open an editor "RM_AS1_MZZU" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for search criteria "$,,such=MZPRUEF_001;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "mzsubm" to open a subeditor for "MZZU" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
