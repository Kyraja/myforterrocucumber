# *****************************************************************************
# Name             : fevor.feature
# Autor            : amk
# Verantwortlich   : amk
# Kontrolle        : bschiga
# Funktion         : Testet diverse Prozesse im Zusammenhang mit dem Anlegen
# und Freigeben von Fertigungsvorschlaegen.
# *****************************************************************************
@persistent
Feature: fevor.feature

  Scenario Outline: Baugruppe FILTER mit Filtereinstellungen anlegen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>          |
      | namebspr | <namebspr>      |
      | dispoa   | auftragsbezogen |
      | bsart    | Eigenfertigung  |
    And I delete all rows
    And I append rows
      | elex    | anzahl    | amge    | pverlust    | filter    | filtervgl    |
      | <elex1> | <anzahl1> |         |             |           |              |
      | <ag1>   | 1         | <amge1> | <pverlust1> | <filter1> | <filtervgl1> |
      | <ag2>   | 1         | <amge2> | <pverlust2> | <filter2> | <filtervgl2> |
      | <ag3>   | 1         | <amge3> | <pverlust3> | <filter3> |              |
    And I save the current editor

    Examples:
      | such   | namebspr                | elex1      | anzahl1 | ag1   | amge1 | pverlust1 | filter1 | filtervgl1 | ag2   | amge2 | pverlust2 | filter2 | filtervgl2 | ag3   | amge3 | pverlust3 | filter3 |
      | FILTER | Bruttobedarf mit Filter | EK1-BEDARF | 1       | A AG1 | 1     | 10        | Q>=     | 100        | A AG2 | 2     | 10        | D>=     | 01.01.1999 | A AG3 | 3     | 10        | NIE     |

  # FDA-5271: Manuell erstellter FV mit durch Filter nicht relevantem AG mit pverlust
  Scenario: 1. Beim Anlegen eines FV werden die Filtereinstellungen in der STL beruecksichtigt
    Given I set the fake date to "01.01.1998"
    Given I open an editor "FV_FILTER" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge |
      | FILTER  | 99     |
    And I set field "netmge" to "100" in row 1
    Then field "mge" has value "112.111" in row 1
    And I set field "tterm" to "01.01.1999" in row 1
    Then field "mge" has value "126.679" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 2a. Feld evmfreig ist nach sperren der Kostenstelle im Zeigen noch immer auf true, im Freigeben aber auf false (Hülse)
    # Artikel anlegen
    Given I open an editor "BG2H" from table "(Part):(Product)" with command "COPY" for record "BG1"
    And I set field "such" to "BG2H"
    And I save the current editor
    # Sperrfähige Kostenstelle anlegen
    Given I open an editor "Kst211" from table "(Account):(CostCenter)" with command "COPY" for record "101"
    And I set field "nummer" to "211"
    And I save the current editor
    # FV anlegen
    Given I open an editor "fvor_neu" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | verw | netmge | kstelle | mfreig |
      | BG2H    | SC2A | 10     | 211     | ja     |
    And I save the current editor
    # Kostenstelle sperren
    Given I open an editor "Kst211-sperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "211"
    And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
    And I save the current editor
    # FV Zeigen (Hülsenpuffer)
    Given I open an editor "fvor_huelse_zeigen" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BG2H"
    And I press button "ladetab"
    Then the table has 1 rows
    Then table has values
      | artikel | netmge | netlimge | netfrgmge | kstelle | mfreig |
      | BG2H    | 10     | 10       | 0         | 211     | ja     |
    And I close the current editor
    # FV Freigeben (Hülsenpuffer) - nicht möglich, da Kst 211 noch gesperrt
    Given I open an editor "fvor_huelse_zeigen" from table "(Purchasing):(WorkOrderSuggestions)" with command "RELEASE" for record ""
    And I set field "artikel" to "BG2H"
    And I press button "ladetab"
    Then the table has 0 rows
    And I close the current editor
    # Kostenstelle entsperren
    Given I open an editor "Kst211-entsperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "211"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    # FV Freigeben - jetzt möglich
    Given I open an editor "fvor_huelse_zeigen" from table "(Purchasing):(WorkOrderSuggestions)" with command "RELEASE" for record ""
    And I set field "artikel" to "BG2H"
    And I press button "ladetab"
    Then the table has 1 rows
    Then table has values
      | artikel | netmge | netlimge | netfrgmge | kstelle | mfreig |
      | BG2H    | 10     | 0        | 10        | 211     | ja     |
    And I save the current editor

  Scenario: 2b. Feld evmfreig ist nach sperren der Kostenstelle im Zeigen noch immer auf true, im Freigeben aber auf false (Einzeleditor)
    # Artikel anlegen
    Given I open an editor "BG2E" from table "(Part):(Product)" with command "COPY" for record "BG1"
    And I set field "such" to "BG2E"
    And I save the current editor
    # Sperrfähige Kostenstelle anlegen
    Given I open an editor "Kst311" from table "(Account):(CostCenter)" with command "COPY" for record "101"
    And I set field "nummer" to "311"
    And I save the current editor
    # FV anlegen
    Given I open an editor "fvor_neu" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | verw | netmge | kstelle | mfreig |
      | BG2E    | SC2B | 10     | 311     | ja     |
    And I save the current editor
    # Kostenstelle sperren
    Given I open an editor "Kst311-sperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "311"
    And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
    And I save the current editor
    # FV Zeigen (Einzeleditor)
    Given I open an editor "fvor_einzel_zeigen" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==BG2E;@maxordtreffer=1"
    Then field "artikel" has value "BG2E"
    And field "netmge" has value "10"
    And field "netlimge" has value "10"
    And field "netfrgmge" has value "0"
    And field "kstelle" has value "311"
    And field "mfreig" has value "ja"
    And I close the current editor
    # FV Freigeben (Einzeleditor) - nicht möglich, da Kst 311 noch gesperrt
    Given opening an editor from table "(Purchasing):(WorkOrderSuggestion)" with command "RELEASE" for search criteria "$,,artikel==BG2E;@maxordtreffer=1" throws the exception "3685"
    And I close the current editor
    # Kostenstelle entsperren
    Given I open an editor "Kst311-sperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "311"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor
    # FV Freigeben - jetzt möglich
    Given I open an editor "fvor_einzel_zeigen" from table "(Purchasing):(WorkOrderSuggestion)" with command "RELEASE" for search criteria "$,,artikel==BG2E;@maxordtreffer=1"
    Then field "artikel" has value "BG2E"
    And field "netmge" has value "10"
    And field "netlimge" has value "0"
    And field "netfrgmge" has value "10"
    And field "kstelle" has value "311"
    And field "mfreig" has value "ja"
    And I save the current editor
