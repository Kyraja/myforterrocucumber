# verantwortlich: uo
@persistent
Feature: Lagerneubewertung bei manuell erfassten Zugängen

Background:
And I set the fake date to "3.3.02"

Scenario: 01

And I set the fake date to "3.3.02"

Given I open an editor "ek1" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "OM0BENTF" 
And I press button "absteig" to open a subeditor for "AFL_Stufe_1" in row 1
And I delete row at position 1
And I save the current editor
And I switch the current editor to editor "ek1"
And I save the current editor


Given I open an editor "ek2" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "M0BM02" 
And I press button "absteig" to open a subeditor for "AFL_Stufe_1" in row 1
And I set field "elanzahl" to "2" in row 1
And I save the current editor
And I switch the current editor to editor "ek2"
And I save the current editor


Given I open an editor "ek3" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "OM2BENTF" 
And I press button "absteig" to open a subeditor for "AFL_Stufe_1" in row 1
And I delete row at position 1
And I save the current editor
And I switch the current editor to editor "ek3"
And I save the current editor


Given I open an editor "ek4" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "OM2BM20" 
And I press button "absteig" to open a subeditor for "AFL_Stufe_1" in row 1
And I set field "elanzahl" to "0" in row 1
And I save the current editor
And I switch the current editor to editor "ek4"
And I save the current editor


Given I open an editor "ek5" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "M2BM23" 
And I press button "absteig" to open a subeditor for "AFL_Stufe_1" in row 1
And I set field "elanzahl" to "3" in row 1
And I save the current editor
And I switch the current editor to editor "ek5"
And I save the current editor


Given I open an editor "ek6" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "MOHBHINZU" 
And I press button "absteig" to open a subeditor for "AFL_Stufe_1" in row 1
And I create a new row at position 1
And I set field "elex" to "E2" in row 1
And I set field "bu" to "Lieferantenbeistellung" in row 1
And I set field "elanzahl" to "2" in row 1
And I save the current editor
And I switch the current editor to editor "ek6"
And I save the current editor
