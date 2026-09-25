# *****************************************************************************************
#  Name           : beleg.feature
#  Autor          : foe
#  Verantwortlich : teampss
#  Funktion       : Test der Funktion 'Beleg anfuegen' per (ev)beleg
#  Beschreibung   : Testet die Funktion 'Beleg anfuegen' in Ein-/Verkaufsvorgaengen.

# *****************************************************************************************
#
@persistent
Feature: Test der Funktion 'Beleg anfuegen' in Ein-/Verkaufsvorgaengen.
Background:
Given I set the fake date to "02.01.1995"

#----------------------------------------------------------------------------------------------
# Anfuegen von AU an RE aus Lieferschein
#----------------------------------------------------------------------------------------------

Scenario: Verkauf Rechnung aus Lieferschein und Auftrag über Beleg anfuegen

# Auftrag
Given I open an editor "1AU100" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU100    |
   | such   | AU100     |
   | kunde  | 1         |
   | vom    | .         |
And I append rows
   | artikel | mge  | preis |
   | V1      | 20   |  60   |
   | V2      | 10   | 100   |
And I save the current editor

# Lieferschein aus Auftrag
Given I open an editor "1LS100" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU100"
And I set fields
   | nummer | 1LS100  |
   | such   | LS100   |
   | ueb    | ja      |
And I set field "mge" to "20" in row 1
And I delete row at position 2
Then field "fakt" has value "ja"
And I save the current editor

#  RE aus LS anlegen -> LS anfuegen -> RLS
Given I open an editor "1RE100" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1LS100"
And I set fields
   | nummer | 1RE100  |
   | such   | RE100   |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
Then field "fakt" is not modifiable
Then field "fakt" has value "nein"
Then the table has 1 rows
And I press button "offueb" in row 1
# AU an RE anfuegen
And I set field "beleg" to "nummer" from editor "1AU100"
Then field "fakt" is not modifiable
Then field "fakt" has value "nein"
Then the table has 3 rows
And I press button "offueb" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein aus Auftrag
Given I open an editor "2LS100" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU100"
And I set fields
   | nummer | 2LS100  |
   | such   | LS1002  |
   | ueb    | ja      |
And I set field "mge" to "10" in row 1
Then field "fakt" has value "nein"
And I save the current editor

#----------------------------------------------------------------------------------------------
# Anfuegen von BE an RE aus Lieferschein
#----------------------------------------------------------------------------------------------

Scenario: Einkauf Rechnung aus Lieferschein und Bestellung ueber Beleg anfuegen

# Bestellung
Given I open an editor "1BE200" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE200    |
   | such   | BE200     |
   | lief   | 1         |
   | vom    | .         |
And I append rows
   | artikel | mge  | preis |
   | E1      | 20   |  15   |
   | E2      | 10   |  21   |
And I save the current editor

# Lieferschein aus Bestellung: 1. Position liefern
Given I open an editor "1LS200" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE200"
And I set fields
   | nummer | 1LS200    |
   | such   | LS200     |
   | vom    | .         |
   | ueb    | ja        |
And I set field "mge" to "20" in row 1
And I delete row at position 2
Then field "fakt" has value "ja"
And I save the current editor

#  RE aus LS anlegen -> BE anfuegen
Given I open an editor "1RE100" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "1LS200"
And I set fields
   | nummer | 1RE200 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | RE200  |
Then field "fakt" is not modifiable
Then field "fakt" has value "nein"
Then the table has 1 rows
And I press button "offueb" in row 1
# BE an RE anfuegen
And I set field "beleg" to "nummer" from editor "1BE200"
Then field "fakt" is not modifiable
Then field "fakt" has value "nein"
Then the table has 3 rows
And I press button "offueb" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein aus Bestellung: 2 Position liefern
Given I open an editor "2LS200" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE200"
And I set fields
   | nummer | 2LS200    |
   | such   | LS2001    |
   | vom    | .         |
   | ueb    | ja        |
And I set field "mge" to "10" in row 1
Then field "fakt" has value "nein"
And  I save the current editor

#----------------------------------------------------------------------------------------------
# Mehrfaches Anfuegen einer Lieferscheinposition an eine Rechnung, mit Zwischenspeichern
#----------------------------------------------------------------------------------------------

Scenario: VK-LS-Position fakturieren und noch einmal an die Rechnung anfuegen

# Auftrag
Given I open an editor "1AU101" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU101 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge |
   | V1      | 10  |
And I save the current editor

# Lieferschein aus Auftrag
Given I open an editor "1LS101" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU101"
And I set fields
   | nummer | 1LS101 |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Teilrechnung zum Lieferschein
Given I open an editor "1RE101" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1LS101"
And I set fields
	| nummer | 1RE101 |
	| vom    | .      |
	| tterm  | .      |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferscheinposition noch einmal an die Rechnung anfuegen (Positionssplit)
Given I open an editor "1RE101" from table "(Sales):(Invoice)" with command "UPDATE" for record "1RE101"
And I delete row at position 4
And I delete row at position 3
And I delete row at position 2
And I set field "beleg" to "1LS101"
And I set field "mge" to "4" in row 3
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: EK-LS-Position fakturieren und noch einmal an die Rechnung anfuegen

# Bestellung
Given I open an editor "1AU101" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1BE101 |
	| lief   | 1      |
	| vom    | .      |
And I append rows
	| artikel | mge |
	| E2      | 10  |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS101" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE101"
And I set fields
	| nummer | 1LS101 |
	| ueb    | ja     |
	| vom    | .      |
And I set field "mge" to "10" in row 1
And I save the current editor

# Teilrechnung zum Lieferschein
Given I open an editor "1RE101" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "1LS101"
And I set fields
	| nummer | 1RE101 |
	| vom    | .      |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferscheinposition noch einmal an die Rechnung anfuegen (Positionssplit)
Given I open an editor "1RE101" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "1RE101"
And I delete row at position 4
And I delete row at position 3
And I delete row at position 2
And I set field "beleg" to "1LS101"
And I set field "mge" to "4" in row 3
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
