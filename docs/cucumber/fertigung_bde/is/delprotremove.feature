@persistent
Feature: delprotremove.feature
# *****************************************************************************
#  Name             : delprotremove
#  Autor            : tiwe
#  Verantwortlich   : teaminfosysteme
#  Kontrolle        : cl
#  Funktion         : Testet das Infosystem DELPROTREMOVE. Entfernen des Löschschutzes
#  ref              : ref_infosys_delprotremove_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "12.01.1995"

Scenario: 01 Infosystem DELPROTREMOVE oeffnen, BA laden und Loeschschutz entfernen

Given I open the infosystem "DELPROTREMOVE"
And I press start
Then the table has 0 rows
And I close the current editor

Given I open an editor "BG_REMOVE" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set fields
    | such          | BG_REMOVE         |
    | namebspr      | Baugruppe         |
    | bsart         | Eigenfertigung    |
And I save the current editor

Given I create a work order "BA01" for Product "BG_REMOVE" with quantity "10" and search word "BA01_"

Given I open an editor "BA01_000" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA01_000"
And I set field "noloesch" to "ja"
And I save value from field "nummer" in row 0
And I save the current editor

Given I open an editor "RM_BA01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA01_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | gut       | ja        |
    | bem       | RM_BA01   |
And I save the current editor

# letzte Rueckmeldung ist nicht aelter als 6 Tage, deshalb wird BA nicht geladen
Given I open the infosystem "DELPROTREMOVE"
And I press start
Then the table has 0 rows
And I close the current editor

Given I set the fake date to "20.01.1995"

Given I open the infosystem "DELPROTREMOVE"
And I press start
Then the table has 1 rows
Then table has values
    | tbanummer^id  | tloeschschutz | tofmge    | tstatusba | tgrund    |
    | !BA01_000^id  | ja            | 0         | *         |           |
And I set field "tauswahl" to "ja" in row 1
And I press button "loeschschutzentfernen"
Then field "tstatus" has value "icon:ok" in row 1
And I press start
Then the table has 0 rows
And I close the current editor

# Prüfen ob FeVo in der Ablage
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG_REMOVE"
And I set field "banummer" in row 0 to saved value
And I set field "nurablage" to "ja"
And I press button "ladetab"
Then the table has 1 rows
And I close the current editor


Scenario: 02 Loeschschutz kann nicht entfernt werden, wenn eine offene Rueckmeldung vorhanden ist

Given I create a work order "BA02" for Product "BG_REMOVE" with quantity "10" and search word "BA02_"

Given I open an editor "BA02_000" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA02_000"
And I set field "noloesch" to "ja"
And I save value from field "nummer" in row 0
And I save the current editor

# ungebuchte Rueckmeldung erstellen
Given I open an editor "RM1_BA02" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA02_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | gut       | ja        |
    | bem       | RM1_BA02  |
And I save the current editor

Given I open an editor "RM2_BA02" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA02_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | gut       | ja        |
    | bem       | RM2_BA02  |
And I save the current editor

Given I set the fake date to "20.01.1995"

Given I open the infosystem "DELPROTREMOVE"
And I press start
Then the table has 1 rows
Then table has values
    | tbanummer^id  | tloeschschutz | tofmge    | tstatusba | tgrund                           |
    | !BA02_000^id  | ja            | 0         | *         | Offene Rückmeldung vorhanden    |
Then field "tauswahl" is not modifiable in row 1
And I close the current editor

Given I open an editor "RM1_BUCHEN" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record from editor "RM1_BA02"
And I set field "sofort" to "ja"
And I save the current editor

Given I open the infosystem "DELPROTREMOVE"
And I set field "letzterm" to ""
And I press start
And I set field "tauswahl" to "ja" in row 1
And I press button "loeschschutzentfernen"
Then field "tstatus" has value "icon:ok" in row 1
And I press start
Then the table has 0 rows
And I close the current editor

# Prüfen ob FeVo in der Ablage
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG_REMOVE"
And I set field "banummer" in row 0 to saved value
And I set field "nurablage" to "ja"
And I press button "ladetab"
Then the table has 1 rows
And I close the current editor


Scenario: 03 Loeschschutz kann nicht entfernt werden, wenn eine offene Auftragszeit vorhanden ist

Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "MA_BDE"
And I set fields
    | such  | MA_BDE    |
    | splan | 303       |
    | lohn  | 1         |
And I save the current editor

Given I create a work order "BA03" for Product "BG_REMOVE" with quantity "10" and search word "BA03_"

Given I open an editor "BA03_000" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA03_000"
And I set field "noloesch" to "ja"
And I save value from field "nummer" in row 0
And I save the current editor

Given I open an editor "AS" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BA03_001;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# ungebuchte Auftragszeit erstellen
Given I open an editor "Auftragszeit03" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | MA_BDE        |
    | asma      | !AS^nummer    |
    | anfdat    | .             |
    | anfzeit   | 10:00         |
    | endzeit   | 10:45         |
And I save the current editor

Given I open an editor "RM_BA03" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA03_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | gut       | ja        |
    | bem       | RM_BA03   |
And I save the current editor

Given I set the fake date to "20.01.1995"

Given I open the infosystem "DELPROTREMOVE"
And I press start
Then the table has 1 rows
Then table has values
    | tbanummer^id  | tloeschschutz | tofmge    | tstatusba | tgrund                           |
    | !BA03_000^id  | ja            | 0         | *         | Nicht übertragene BDE-Objekte vorhanden |
Then field "tauswahl" is not modifiable in row 1
And I close the current editor

# Auftragszeit buchen
Given I open an editor "Auftragszeit03" from table "(PDC):(OrderTime)" with command "UPDATE" for record from editor "Auftragszeit03"
And I set field "sofort" to "ja"
And I save the current editor

Given I open the infosystem "DELPROTREMOVE"
And I set field "letzterm" to ""
And I press start
And I set field "tauswahl" to "ja" in row 1
And I press button "loeschschutzentfernen"
Then field "tstatus" has value "icon:ok" in row 1
And I press start
Then the table has 0 rows
And I close the current editor

# Prüfen ob FeVo in der Ablage
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG_REMOVE"
And I set field "banummer" in row 0 to saved value
And I set field "nurablage" to "ja"
And I press button "ladetab"
Then the table has 1 rows
And I close the current editor


Scenario: 04 Loeschschutz kann nicht entfernt werden, wenn noch offene Materialmengen vorhanden sind

Given I create a work order "BA04" for Product "BG_REMOVE" with quantity "10" and search word "BA04_"

Given I open an editor "BA04_000" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA04_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I save the current editor
And I switch the current editor to editor "BA04_000"
And I set field "noloesch" to "ja"
And I save value from field "nummer" in row 0
And I save the current editor

Given I open an editor "RM_BA04" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA04_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | gut       | ja        |
    | bem       | RM_BA03   |
And I save the current editor

Given I set the fake date to "20.01.1995"

Given I open the infosystem "DELPROTREMOVE"
And I press start
Then the table has 1 rows
Then table has values
    | tbanummer^id  | tloeschschutz | tofmge    | tstatusba | tgrund                           |
    | !BA04_000^id  | ja            | 0         | *         | Offene Materialmenge in der Auftragsfertigungsliste |
Then field "tauswahl" is not modifiable in row 1
And I close the current editor

# Materialentnahme buchen
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | BA04_001  |
    | bem           | Entnahme  |
And I press button "stlvblad"
Then table has values
    | elex  | bumge | manbu |
    | E1    | 2     | ja    |
And I save the current editor

Given I open the infosystem "DELPROTREMOVE"
And I set field "letzterm" to ""
And I press start
And I set field "tauswahl" to "ja" in row 1
And I press button "loeschschutzentfernen"
Then field "tstatus" has value "icon:ok" in row 1
And I press start
Then the table has 0 rows
And I close the current editor

# Prüfen ob FeVo in der Ablage
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG_REMOVE"
And I set field "banummer" in row 0 to saved value
And I set field "nurablage" to "ja"
And I press button "ladetab"
Then the table has 1 rows
And I close the current editor
