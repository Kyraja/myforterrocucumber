@persistent
Feature: lagerbuchung.feature

Background:
And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name           : lagerbuchung.feature
#  Autor          : lschneider   
#  Verantwortlich	: drpf
#  Kontrolle      : carue
#  Funktion       : Testet Erweiterungen in Lbuchung
#  Jira-Issue     : FDA-1038
# *****************************************************************************


Scenario: 01 behleer=ja setzen, wenn über Lbuchung Umlagern ein Behälter mit negativer und positiver Menge leer wird
# Behälter anlegen und Lagerbuchung Material in Behälter
    Given I create a Container "B_UMLAGERN" for packaging material "BEHAELTER"

    Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
    And I set fields
      | artikel     | EINKAUF-1   |
      | beleg       | UML         |
      | beldat      | .           |
      | buart       | Zugang      |
    And I modify table
      | !row  | mge   | verw      | behaelter       |
      | +1    | 1     | v123      | !B_UMLAGERN^id  |
      | +1    | 1     |           | !B_UMLAGERN^id  |
    And I save the current editor

# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel		| netmge	| mfreig	| bisuch       |
      | M_BAUGRUPPE	| 1 		| ja		| UMLAGERN_    |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "UMLAGERN_001"
    And I close the current editor

# Durch Materialentnahme negative Menge in den Behälter buchen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag		| !Arbeitsschein1^nummer	|
    And I press button "stllad"
    And I set field "behaelter" to "!B_UMLAGERN^id" in row 1
    And I save the current editor

# Behälter hat nun eine negative und eine positive Zeile
    Given I switch the current editor to editor "B_UMLAGERN" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | !row  | artikel     | mge | verw    |
      | 1     | EINKAUF-1   | -1  |         |
      | 2     | EINKAUF-1   | 1   | v123    |
    And I close the current editor

# über Lbuchung negative Menge durch positive Menge im Behälter ausgleichen, behleer=ja
    Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
    And I set fields
      | artikel     | EINKAUF-1   |
      | beleg       | UML         |
      | beldat      | .           |
      | buart       | Umbuchung   |
    And I modify table
      | !row  | mge   | platz | platz2  | verw      | verw2   | behaelter       | behaelterzu     |
      | +1    | 1     | F1    | F1      | v123      |         | !B_UMLAGERN^id  | !B_UMLAGERN^id  |
    And I save the current editor

    Then Container "B_UMLAGERN" is empty
