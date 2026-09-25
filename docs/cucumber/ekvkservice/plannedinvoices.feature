# *****************************************************************************
# Name           : plannedinvoices.feature
# Autor          : cl
# Verantwortlich : cl
# Kontrolle      : teampss
# Funktion       : Testet Serviceauftrag und Reparaturauftrag im IS PLANNEDINVOICES
#
# *****************************************************************************
#
@persistent
Feature: Fakturaplan für Serviceauftrag und Reparaturauftrag

  Scenario: STAMMDATEN - Neuen Kunden anlegen
    Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Bayram"
    And I set field "such" to "Bayram"
    And I set field "namebspr" to "Bayram Werkzeugbau, Rastatt"
    And I set field "ans" to "Bayram Werkzeugbau GmbH"
    And I set field "str" to "Riedstr. 24-28"
    And I set field "plz" to "76437"
    And I set field "nort" to "Rastatt"
    And I set field "region" to "BADEN"
    And I set field "tele" to "+49 (0) 7222/9456-0"
    And I set field "email" to "info@bayram-corp.de"
    And I set field "betreuer" to "."
    And I set field "ustid" to "DE56454651"
    And I set field "lbed" to "EXW"
    And I set field "zbed" to "201"
    And I save the current editor
    Then field "name" has value "Bayram Werkzeugbau, Rastatt"
    Then field "zbed" has value "201"

  Scenario: STAMMDATEN - Konsignationslagergruppe anlegen
    Given I open an editor "Konsignationslg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "konsi"
    And I set field "such" to "konsi"
    And I set field "namebspr" to "Konsignationslagergruppe"
    And I set field "zkonsilg" to "ja"
    Then field "vkruecklieferung" is not modifiable
    Then field "vkkundenanlieferung" is not modifiable
    And I save the current editor

  Scenario: STAMMDATEN - Externe Lagergruppe anlegen
    Given I open an editor "Externelg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "extern"
    And I set field "such" to "extern"
    And I set field "namebspr" to "Externe Lagergruppe"
    And I set field "zkonsilg" to "nein"
    Then field "vkruecklieferung" is modifiable
    Then field "vkkundenanlieferung" is modifiable
    And I save the current editor

  Scenario Outline: STAMMDATEN - Konsignationslager und externes Lager anlegen
    Given I open an editor "<lager>" from table "(Warehouse):(Warehouse)" with command "STORE" for record "<such>"
    And I set field "such" to "<such>"
    And I set field "namebspr" to "<namebspr>"
    And I set field "lgruppe" to id from editor "<lgruppe>"
    And I save the current editor

    Examples: Lager
      | lager           | such   | namebspr           | lgruppe         |
      | Konsignationsla | konsi  | Konsignationslager | Konsignationslg |
      | Externesla      | extern | Externes Lager     | Externelg       |

  Scenario Outline: STAMMDATEN - Konsignationslagerplatz und externen Lagerplatz anlegen
    Given I open an editor "<lagerplatz>" from table "(Location):(Location)" with command "STORE" for record "<such>"
    And I set field "such" to "<such>"
    And I set field "namebspr" to "<namebspr>"
    And I set field "lager" to id from editor "<lager>"
    And I set field "lgruppe" to id from editor "<lgruppe>"
    And I save the current editor

    Examples: Lagerplatz
      | lagerplatz      | such   | namebspr            | lager           | lgruppe         |
      | Konsignationslp | konsi  | Konsignationslager  | Konsignationsla | Konsignationslg |
      | Externerlp      | extern | Externer Lagerplatz | Externesla      | Externelg       |

  Scenario: STAMMDATEN - Konsignationslagerplatz in interne Lagergruppe eingragen
    Given I open an editor "internelg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KARLSRUHE"
    And I set field "vkkundenanlieferung" to id from editor "Konsignationslp"
    And I save the current editor

  Scenario: STAMMDATEN - Schichtplan im Mitarbeiter hinterlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "UPDATE" for record "Test"
    And I set field "splan" to "301"
    And I save the current editor

  Scenario: STAMMDATEN - Neuen Techniker anlegen
    Given I open an editor "techniker" from table "(ServiceEmployees):(EmployeeRole)" with command "STORE" for record "techniker"
    And I set field "such" to "techniker"
    And I set field "namebspr" to "Techniker"
    And I set field "ma" to "test"
    And I save the current editor

  Scenario: STAMMDATEN - Neue Dienstleistung anlegen
    Given I open an editor "dienstl" from table "(Part):(Service)" with command "STORE" for record "dl-analyse"
    And I set field "such" to "dl-analyse"
    And I set field "namebspr" to "Anlayse"
    And I set field "vpr" to "50.00"
    And I create a new row at the end of the table
    And I set field "elex" to "A AG1" in row 1
    And I save the current editor

  Scenario Outline: STAMMDATEN - Neue Dienstleistungen mit Preiseinheit h anlegen
    Given I open an editor "<ndienstl>" from table "(Part):(Service)" with command "STORE" for record "<such>"
    And I set field "such" to "<such>"
    And I set field "namebspr" to "<namebspr>"
    And I set field "vpr" to "<preis>"
    And I set field "vpe" to "h"
    And I set field "vhe" to "h"
    And I save the current editor

    Examples: Dienstleistungen
      | ndienstl   | such         | namebspr     | preis |
      | hdienstl   | dl-hanalyse  | Analyse in h | 60.00 |
      | repdienstl | dl-reparatur | Reparatur    | 70.00 |

  Scenario: STAMMDATEN - Neues Einsatzmittel anlegen
    Given I open an editor "einsatzm" from table "(ServiceAssignment):(AssignmentResources)" with command "STORE" for record ""
    And I set field "such" to "em-pkw"
    And I save the current editor

  Scenario: STAMMDATEN - Neue Kostenstelle anlegen
    Given I open an editor "kostenstelle" from table "(Account):(CostCenter)" with command "STORE" for record ""
    And I set field "such" to "KS-TECHN"
    And I save the current editor

  Scenario: STAMMDATEN - Mitarbeiter TEST um Lohngruppe und Kostenstelle erweitern
    Given I open an editor "mitarbiter" from table "(Employee):(Employee)" with command "UPDATE" for record "1"
    And I set field "kstelle" to id from editor "kostenstelle"
    And I set field "lohn" to "1"
    And I save the current editor

  Scenario: STAMMDATEN - Servicepflichtigen Artikel anlegen
    Given I open an editor "serartikel" from table "(Part):(Product)" with command "STORE" for record ""
    And I set field "such" to "SERARTIKEL"
    And I set field "namebspr" to "Servicepflichtiger Artikel"
    And I set field "vkbez" to "Servicepflichtiger Artikel"
    And I set field "vbez" to "Servicepflichtiger Artikel"
    And I set field "ebez" to "Servicepflichtiger Artikel"
    And I set field "vpr" to "1000"
    And I set field "bsart" to "Eigenfertigung"
    And I set field "dispoa" to "Auftragsbezogen"
    And I set field "chimlager" to "ja"
    And I set field "serpflicht" to "ja"
    # Stückliste anlegen
    And I create a new row at the end of the table
    And I set field "elex" to "E2" in row 1
    And I set field "elanzahl" to "2" in row 1
    And I set field "tnwpflicht" to "ja" in row 1
    And I set field "tersatzt" to "ja" in row 1
    And I create a new row at the end of the table
    And I set field "elex" to "A AG3" in row 2
    And I create a new row at the end of the table
    And I set field "elex" to "BG1" in row 3
    And I set field "elanzahl" to "1" in row 3
    And I set field "tnwpflicht" to "ja" in row 3
    And I set field "tverschlt" to "ja" in row 3
    And I create a new row at the end of the table
    And I set field "elex" to "A AG4" in row 4
    And I save the current editor

  Scenario: STAMMDATEN - Nachweispflicht in Elementen von BG1 setzen
    Given I open an editor "bg1" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
    And I set field "tnwpflicht" to "ja" in row 1
    And I save the current editor

  Scenario: Charge anlegen
    Given I open an editor "charge" from table "(Lots):(Lots)" with command "NEW" for record ""
    And I set field "such" to "LEIH"
    And I set field "exnum" to "001"
    And I set field "artikel" to id from editor "serartikel"
    And I save the current editor

  Scenario Outline: Serviceprodukt als Kunden- und Leihgeraet anlegen
    Given I open an editor "<serprodukt>" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
    And I set field "such" to "<such>"
    And I set field "namebspr" to "<namebspr>"
    And I set field "artikel" to id from editor "<artikel>"
    And I save the current editor
    And I switch the current editor to editor "<serprodukt>"
    And I set field "serprodtyp" to "<serprodtyp>"
    And I set field "zuplatzlg" to "<zuplatzlg>"
    And I set field "abplatzlg" to "<abplatzlg>"
    And I set field "charge" to id from editor "<charge>"
    And I save the current editor

    Examples: Serviceprodukt
      | serprodukt | such  | namebspr | artikel    | serprodtyp  | zuplatzlg | abplatzlg | charge      |
      | kundeng1   | KGSP1 | KGSP1    | serartikel | Kundengerät |           |           | !dontChange |
      | kundeng2   | KGSP2 | KGSP2    | serartikel | Kundengerät |           |           | !dontChange |
      | kundeng3   | KGSP3 | KGSP3    | serartikel | Kundengerät |           |           | !dontChange |
      | kundeng4   | KGSP4 | KGSP4    | serartikel | Kundengerät |           |           | !dontChange |
      | kundeng5   | KGSP5 | KGSP5    | serartikel | Kundengerät |           |           | !dontChange |
      | leihgeraet | LHSP  | LHSP     | serartikel | Leihgerät   | F4        | F4        | charge      |

  Scenario: Serviceprodukt ausliefern
    Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I create a new row at the end of the table
    And I set field "artikel" to id from editor "serartikel" in row 1
    And I set field "mge" to "1" in row 1
    And I set field "serprod" to id from editor "kundeng1" in row 1
    And I save the current editor
    # Disposition starten
    And I run Scheduling
    Given I open an editor "freigeben" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to id from editor "serartikel"
    And I press button "ladetab"
    Then the table has 1 rows
    And I set field "bisuch" to "Service" in row 1
    And I set field "mfreig" to "ja" in row 1
    And I press button "freig" to open a subeditor for "fertigung"
    And I close the current editor
    And I switch the current editor to editor "freigeben"
    And I close the current editor
    # BAs rueckmelden
    Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "service000"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "101"
    And I save the current editor
    Given I open an editor "lieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set field "beleg" to id from editor "auftrag1"
    And I set field "such" to "liefer1"
    And I set field "ueb" to "ja"
    And I set field "mge" to "1" in row 1
    And I save the current editor

  Scenario: Serviceauftrag anlegen
    Given I open an editor "serauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "betreff" to "Serviceauftrag mit Fakturaplan"
    And I set field "vserprod" to id from editor "kundeng1"
    When I create a new row at the end of the table
    And I set field "artex" to id from editor "dienstl" in row 1
    And I set field "mge" to "1" in row 1
    And I set field "ganztag" to "ja" in row 1
    And I create a new row at the end of the table
    And I set field "artex" to "V1" in row 2
    And I set field "mge" to "1" in row 2
    And I save the current editor
    Then field "fktaplan" is empty
    Then field "zbed" has value "201"

  Scenario: Fakturaplan für Serviceauftrag anlegen
    Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
    And I set field "evvorgang" to id from editor "serauftrag"
    And I set field "namebspr" to "Fakturaplan zu Serviceauftrag"
    And I create a new row at the end of the table
    And I set field "reart" to "Anzahlung" in row 1
    And I set field "proz" to "20" in row 1
    And I set field "ptext" to "1. Anzahlung" in row 1
    And I set field "zbed" to "203" in row 1
    And I create a new row at the end of the table
    And I set field "reart" to "Anzahlung" in row 2
    And I set field "proz" to "10" in row 2
    And I set field "ptext" to "2. Anzahlung" in row 2
    And I set field "zbed" to "203" in row 2
    And I save the current editor

  Scenario: Reparaturauftrag anlegen
    Given I open an editor "repauftrag" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
    And I set field "kunde" to id from editor "kunde"
    And I set field "vserprod" to id from editor "kundeng1"
    And I create a new row at the end of the table
    And I set field "artikel" to id from editor "serartikel" in row 1
    Then the table has 2 rows
    # Kundengeraet annehmen
    And I press button "repzug" to open a subeditor for "zugangsls"
    And I set field "ueb" to "ja"
    Then field "platz" has value "KONSI" in row 1
    And I save the current editor
    And I switch the current editor to editor "repauftrag"
    # Abgang des Leihgerätes
    And I press button "repabgl" to open a subeditor for "abgangsls"
    And I set field "such" to "Fall615"
    And I set field "ueb" to "ja"
    And I set field "umplatz" to "L3F1"
    Then field "platz" has value "F4" in row 1
    And I save the current editor
    And I switch the current editor to editor "repauftrag"
    # Dienstleistung aufnehmen
    And I create a new row at the end of the table
    And I set field "artikel" to id from editor "dienstl" in row 3
    And I set field "mge" to "1" in row 3
    # Reparatur aufnehmen
    And I create a new row at the end of the table
    And I set field "artikel" to id from editor "repdienstl" in row 4
    And I set field "mge" to "2" in row 4
    And I press button "absteig" to open a subeditor for "reparatur" in row 4
    And I create a new row at the end of the table
    And I set field "elex" to "E2" in row 1
    And I set field "elanzahl" to "1" in row 1
    And I create a new row at the end of the table
    And I set field "elex" to "A AG2" in row 2
    And I save the current editor
    And I switch the current editor to editor "repauftrag"
    And I save the current editor

  Scenario: Fakturaplan für Reparaturauftrag anlegen
    Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
    And I set field "evvorgang" to id from editor "repauftrag"
    And I set field "namebspr" to "Fakturaplan zu Reparaturauftrag"
    And I create a new row at the end of the table
    And I set field "reart" to "Anzahlung" in row 1
    And I set field "proz" to "20" in row 1
    And I set field "ptext" to "1. Anzahlung" in row 1
    And I set field "zbed" to "203" in row 1
    And I create a new row at the end of the table
    And I set field "reart" to "Anzahlung" in row 2
    And I set field "proz" to "10" in row 2
    And I set field "ptext" to "2. Anzahlung" in row 2
    And I set field "zbed" to "203" in row 2
    And I save the current editor
    Given I open the infosystem "PLANNEDINVOICES"
    And I press start
    Then the table has 6 rows
    Given I open the infosystem "PLANNEDINVOICES"
    And I set field "kauftrag" to "200006"
    And I press start
    Then the table has 1 rows
    Given I open the infosystem "PLANNEDINVOICES"
    And I set field "serauftrag" to "!serauftrag^id"
    And I press start
    Then the table has 2 rows
    Given I open the infosystem "PLANNEDINVOICES"
    And I set field "repauf" to "!repauftrag^id"
    And I press start
    Then the table has 2 rows
