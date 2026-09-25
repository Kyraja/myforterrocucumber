# *****************************************************************************
#  Name             : verw_proj.feature
#  Autor            : amk
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Funktion         : Testet die Änderbarkeit der Felder Verwendung und Projekt in der Fertigung.
#  Jira-Issue       : FDA-161
# *****************************************************************************
@persistent
Feature: verw_proj.feature

  Scenario Outline: Notwendige Stammdaten anlegen
    # Projekte anlegen
    Given I open an editor "<such>" from table "(Transaction):(Project)" with command "STORE" for record "<such>"
    And I set fields
      | such | <such> |
    And I save the current editor

    Examples:
      | such      |
      | PROJEKT_A |
      | PROJEKT_B |
      | PROJEKT_C |
      | PROJEKT_D |
      | PROJEKT_E |

  Scenario: 0. Konfigurationseinstellung prüfen
    # Projekt muss auf "Ja" stehen
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "VIEW" for record "0k"
    Then field "projekt" has value "ja"
    And I close the current editor


  Scenario: 1. Änderbarkeit der Felder verw und projekt in einem FV VOR der Freigabe prüfen. MZ anlegen und FV freigeben.
    Given I open an editor "fvorNew" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | verw   | projekt   |
      | BG-AUFTRAG | 100    | VERW_A | PROJEKT_A |
    And I save the current editor

    Given I open an editor "fvorUpd" from table "(Purchasing):(WorkOrderSuggestion)" with command "UPDATE" for search criteria "$,,verw=VERW_A;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "verw" to "VERW_B"
    And I set field "projekt" to "PROJEKT_B"
    And I save the current editor

    Given I open an editor "fvorRelease" from table "(Purchasing):(WorkOrderSuggestion)" with command "UPDATE" for search criteria "$,,verw=VERW_B;@gruppe=5;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "mzsubm" to open a subeditor for "MZuordZu"
    And I delete all rows 
    And I append rows 
      | lpsuch | zuomge |
      | F1     | 10     |
      | F2     | 20     |
      | F3     | 30     |
      | F4     | 40     |
    And I save the current editor
    And I switch the current editor to editor "fvorRelease"
    And I press button "mzabsm" to open a subeditor for "MZuordAb"
    And I delete all rows 
    And I append rows 
      | lpsuch | zuomge |
      | F1     | 10     |
      | F2     | 20     |
      | F3     | 30     |
      | F4     | 40     |
    And I save the current editor
    And I switch the current editor to editor "fvorRelease"
    And I save the current editor

    Given I open an editor "fvorRelease" from table "(Purchasing):(WorkOrderSuggestion)" with command "RELEASE" for search criteria "$,,verw=VERW_B;@gruppe=5;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "bisuch" to "VRWPRJ"
    And I set field "mfreig" to "ja"
    And I save the current editor


  Scenario: 2. Schreibschutz im FV, MZ, BA, AS, RM prüfen.
    Given I open an editor "fvorTest1" from table "(Purchasing):(WorkOrderSuggestion)" with command "UPDATE" for search criteria "$,,verw=VERW_B;@gruppe=5;@richtung=rückwärts;@maxordtreffer=1"
    Then field "verw" is not modifiable
    And field "projekt" is not modifiable
    And I press button "mzsubm" to open a subeditor for "MZuordZu"
    Then field "verw" is not modifiable in row 1
    Then field "projekt" is not modifiable in row 1
    And I close the current editor
    And I switch the current editor to editor "fvorTest1"
    And I press button "mzabsm" to open a subeditor for "MZuordAb"
    Then field "verw" is not modifiable in row 1
    Then field "projekt" is not modifiable in row 1
    And I close the current editor
    And I switch the current editor to editor "fvorTest1"
    And I close the current editor

    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "VRWPRJ000"
    Then field "verw" is not modifiable
    And field "projekt" is not modifiable
    And I close the current editor

    Given I open an editor "AS" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "VRWPRJ001"
    Then field "verw" is not modifiable
    And field "projekt" is not modifiable
    And I close the current editor

    Given I open an editor "RM" from table "(Workorder):(WorkOrders)" with command "DONE" for record "VRWPRJ001"
    Then field "verw" is not modifiable
    And field "projekt" is not modifiable
    And I close the current editor


  Scenario: 3. Rückmeldung auf AS2 (letzter AS) buchen und Verwendung/Projekt im LJ prüfen
    Given I open an editor "RMAS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "VRWPRJ002"
    Then field "verw" has value "VERW_B"
    And field "projekt" has value "PROJEKT_B"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "10" in row 1
    And I save the current editor
    And I close the current editor

    Given I open the infosystem "LJ" 
    And I set field "beleg" to "barmex" from editor "RMAS2"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 2 rows
    Then table has values
      | art         | nplatz | vplatz | zmge | amge | verw   | projekt   |
      | BG-AUFTRAG  | F1     |        | 10   |      | VERW_B | PROJEKT_B |
      | EK1-AUFTRAG |        | F1     |      | 10   | VERW_B | PROJEKT_B |
    And I close the current editor


  Scenario: 4. Fehlermeldung bei Verwendung/Projekt in der AFL ändern und FV splitten.
    Given I open an editor "fvorFehl" from table "(Purchasing):(WorkOrderSuggestion)" with command "UPDATE" for search criteria "$,,verw=VERW_B;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "verw" has value "VERW_B"
    And field "projekt" has value "PROJEKT_B"
    Then I set field "verw" to "VERW_C"
    And I set field "netblimge" to "92" 
    Then saving the current editor throws the exception "2030"
    And I close the current editor
    And I switch the current editor to editor "fvorFehl"
    And I close the current editor


  Scenario: 5. Verwendung/Projekt in der AFL ändern.
    Given I open an editor "fvorChg" from table "(Purchasing):(WorkOrderSuggestion)" with command "UPDATE" for search criteria "$,,verw=VERW_B;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL"
    And I set field "verw" to "VERW_C"
    And I set field "projekt" to "PROJEKT_C"
    And I save the current editor
    And I switch the current editor to editor "fvorChg"
    And I save the current editor


  Scenario: 6. Änderung im FV, MZ, BA und AS prüfen.
    Given I open an editor "fvorTest2" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,verw=VERW_C;@richtung=rückwärts;@maxordtreffer=1"
    Then field "verw" has value "VERW_C"
    And field "projekt" has value "PROJEKT_C"
    And I press button "mzsubm" to open a subeditor for "MZuordZu"
    Then field "verw" has value "VERW_C" in row 1
    And field "projekt" has value "PROJEKT_C" in row 1
    And I close the current editor
    And I switch the current editor to editor "fvorTest2"
    And I press button "mzabsm" to open a subeditor for "MZuordAb"
    Then field "verw" has value "VERW_C" in row 1
    And field "projekt" has value "PROJEKT_C" in row 1
    And I close the current editor
    And I switch the current editor to editor "fvorTest2"
    And I close the current editor

    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "VRWPRJ000"
    Then field "verw" has value "VERW_C"
    And field "projekt" has value "PROJEKT_C"
    And I close the current editor

    Given I open an editor "AS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "VRWPRJ001"
    Then field "verw" has value "VERW_C"
    And field "projekt" has value "PROJEKT_C"
    And I close the current editor


  Scenario: 7. RM auf BA erfassen und buchen. LJ Eintrag kontrollieren
    Given I open an editor "RMBA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "VRWPRJ000"
    Then field "verw" has value "VERW_C"
    And field "projekt" has value "PROJEKT_C"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "30" in row 1
    And I save the current editor
    And I close the current editor

    Given I open the infosystem "LJ" 
    And I set field "beleg" to "barmex" from editor "RMBA"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 2 rows
    Then table has values
      | art         | nplatz | vplatz | zmge | amge | verw   | projekt   |
      | BG-AUFTRAG  | F2     |        | 20   |      | VERW_C | PROJEKT_C |
      | EK1-AUFTRAG |        | F2     |      | 20   | VERW_C | PROJEKT_C |
    And I close the current editor
