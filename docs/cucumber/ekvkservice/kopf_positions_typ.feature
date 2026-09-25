#***************************************************************************
#
#  Name      : kopf_positions_typ.feature (alt TYPTEST.LAD)
#
#  Autor     : dago
#  Verantwortlich : dago
#
#  Funktion  : Einkauf/Verkauf - Kopf-/Positionstyp laden
#
#***************************************************************************
@persistent
Feature: Kopf-/Positionstypen

# ---------------------------------
Scenario: Verkaufsauftraege anlegen
# ---------------------------------
Given I open an editor "Auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| kunde | mert1   |
	| such  | VKPOS1  |
And I append rows
	| pnum | artikel | mge |
	| 1    | v1      | 1   |
	| 2    | v2      | 2   |
And I save the current editor

Given I open an editor "Auftrag-2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| kunde | mert1   |
	| such  | VKPOS2  |
And I create a new row at position 1
And I set field "pnum" to "1" in row 1
And I set field "artikel" to "v1" in row 1
And I set field "mge" to "3" in row 1
And I create a new row at position 2
And I set field "pnum" to "2" in row 2
And I set field "artikel" to "v2" in row 2
And I set field "mge" to "4" in row 2
And I create a new row at position 3
And I set field "pnum" to "3" in row 3
And I set field "artikel" to "v3" in row 3
And I set field "mge" to "5" in row 3
And I save the current editor

Given I open an editor "Auftrag-3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| kunde | mert1   |
	| such  | VKPOS3  |
And I create a new row at position 1
And I set field "pnum" to "1" in row 1
And I set field "artikel" to "v1" in row 1
And I set field "mge" to "6" in row 1
And I create a new row at position 2
And I set field "pnum" to "2" in row 2
And I set field "artikel" to "v2" in row 2
And I set field "mge" to "7" in row 2
And I create a new row at position 3
And I set field "pnum" to "3" in row 3
And I set field "artikel" to "v3" in row 3
And I set field "mge" to "8" in row 3
And I save the current editor

# ---------------------------------
Scenario: Bestellungen anlegen
# ---------------------------------
Given I open an editor "Bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| lief | 1       |
	| such | EKPOS1  |
And I create a new row at position 1
And I append rows
	| artikel | mge |
	| e1      | 10  |
	| e2      | 20  |
And I save the current editor

Given I open an editor "Bestellung-2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| lief | 1       |
	| such | EKPOS2  |
And I create a new row at position 1
And I set field "artikel" to "e1" in row 1
And I set field "mge" to "30" in row 1
And I create a new row at position 2
And I set field "artikel" to "e2" in row 2
And I set field "mge" to "40" in row 2
And I create a new row at position 3
And I set field "artikel" to "e3" in row 3
And I set field "mge" to "50" in row 3
And I save the current editor

# ---------------------------------
Scenario: Wartung, Flag 71
# ---------------------------------
Given I'm logged in with password "annette"
Given I enable the flag 71
# ---------------------------------
# Verkauf/Einkauf
# Scenario: Kopf-/Positionstyp kaputtmachen
# ---------------------------------
Given I execute FOP "EKVKTYPKAPUTT.FOP"

Given I disable the flag 71
Given I'm logged in with password "sy"
