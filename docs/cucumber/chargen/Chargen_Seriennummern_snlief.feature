@persistent
Feature: Chargen_Seriennummern_snlief.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Chargen_Seriennummern_snlief.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : carue
#  Funktion         : Testet Chargen-/Seriennummernverwaltung Skipfeld snlief
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************

Scenario: Einkaufen

Given I open an editor "CHBG01" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
    | such     | EK01_CHARGE_MY  |
    | Artikel  | EK01_CHARGE     |
    | lief     | LIEFCHA2        |
    | snlief   | L_EK01_0001     |
	| exnum    | 0001            |
And I save the current editor

Given I open an editor "BE_EK01_CHARGE_MY" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BEI0001  |
    | ebeleg | BEI0001  |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel          | mge | charge         |
    | EK01_CHARGE      | 15  | EK01_CHARGE_MY |
Then field "snlief" has value "L_EK01_0001" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge         |
    |  1    | F1     | 15       | EK01_CHARGE_MY |
And I save the current subeditor to switch back to the parent editor
Then field "snlief" has value "L_EK01_0001" in row 1
And I save the current editor

Given I open an editor "L_EK01_CHARGE_MY" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BEI0001"
And I set fields
   | ebeleg | LEK01CHMY |
   | such   | LEK01CHMY |
   | vom    | .         |
Then field "snlief" has value "L_EK01_0001" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "LEK01CHARGEMY" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LEK01CHMY"
Then field "snlief" has value "L_EK01_0001" in row 1
Then I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "REK01CHARGEMY" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BEI0001"
And I set fields
    | such   | REK01CHMY  |
    | ebeleg | REK01CHMY  |
    | vom    | .          |
    | tterm  | .          |
    | ueb    | nein       |
And I set field "mge" to "5" in row 1
Then field "snlief" has value "L_EK01_0001" in row 1
And I save the current editor

Scenario: Journal

Given I open an editor "CHBG01" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=EK01_CHARGE;ncharge=EK01_CHARGE_MY;@maxtreffer=1;@ablageart=lebendig"
Then field "nsnlief" has value "L_EK01_0001" in row 1
And I close the current editor

Scenario: AFL

Given I create a work order "FVSNLIEF" for Product "BG01_CHARGE" with quantity "20" and search word "FVSNLIEF_"

Given I open an editor "BA_FVSNLIEF" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FVSNLIEF_000"
And I close the current editor

Given I open an editor "FVOR" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
    | banummer | !BA_FVSNLIEF^nummer |
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I modify table
    | !row  | charge   			|
    | 1     | EK01_CHARGE_MY    |
Then field "snlief" has value "L_EK01_0001" in row 1
And I save the current editor
And I switch the current editor to editor "FVOR"
And I save the current editor
