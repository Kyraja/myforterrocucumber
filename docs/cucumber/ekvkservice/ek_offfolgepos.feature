# *****************************************************************************************
#  Name           : ek_offfolgepos.feature
#  Autor          : foe
#  Verantwortlich : teampss
#  Funktion       : Test fuer das Feld evofffolgepos im Einkauf
#  Beschreibung   :
#  Testet das Feld evofffolgepos, das angibt, wieviele offene Folgepositionen zu einen EV-Objekt vorhanden sind.
#
# *****************************************************************************************
#
@persistent
Feature: Test zu Feld offfolgepos im Einkauf
Background:
Given I set the fake date to "02.01.1995"

Scenario Outline: Folgevorganege im Einkauf

#---------------------------------------------------------------------------------------------
Scenario: BE -> LS -> RE -> RLS  -> KGS
#----------------------------------------------------------------------------------------------

# Bestellung anlegen
Given I open an editor "BE1F" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1     |
   | nummer | 1F-BE |
   | such   | BE1F  |
   And I append rows
	| artikel      | mge    | preis |
	| EINK         | 15     | 19    |
	| E1           | 10     | 5     |
	| E3           | 20     | 4     |
And I save the current editor

# Lieferschein 1
Given I open an editor "LS1F1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE1F"
And I set fields
   | nummer | 1F-EKLS |
   | such   | LS1F1   |
   | vom    | .       |
   | ueb    | nein    |
And I set field "mge" to "5" in row 1
And I set field "mge" to "4" in row 2
And I set field "mge" to "10" in row 3
And I save the current editor

# Lieferschein 2
Given I open an editor "LS1F2" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE1F"
And I set fields
   | nummer | 1F-EKLS2 |
   | such   | LS1F2    |
   | vom    | .        |
   | ueb    | nein     |
And I set field "mge" to "3" in row 1
And I set field "mge" to "7" in row 3
And I save the current editor

# Lieferschein 3
Given I open an editor "LS1F3" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE1F"
And I set fields
   | nummer | 1F-EKLS3 |
   | such   | LS1F3    |
   | vom    | .        |
   | ueb    | nein     |
And I set field "mge" to "5" in row 2
And I save the current editor

# Ungebuchte LS in Bestellung BE1F pruefen
Given I open an editor "BE1FP" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE1F"
Then field "re" has value "2" in row 1
Then field "offfolgepos" has value "6"
And I close the current editor

Given I open an editor "LS1F1B" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS1F1"
And I set field "ueb" to "ja"
And I save the current editor

# Ungebuchte LS in Bestellung BE1F pruefen
Given I open an editor "BE1FP" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE1F"
Then field "re" has value "1" in row 2
Then field "offfolgepos" has value "3"
And I close the current editor

Given I open an editor "LS1F2B" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS1F2"
And I set field "ueb" to "ja"
And I delete row at position 1
And I save the current editor

# Ungebuchte LS in Bestellung BE1F pruefen
Given I open an editor "BE1FP" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE1F"
Then field "re" has value "1" in row 2
Then field "offfolgepos" has value "1"
And I close the current editor

Given I open an editor "LS1F3B" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS1F3"
And I set field "ueb" to "ja"
And I save the current editor

# Ungebuchte LS in Bestellung BE1F pruefen
Given I open an editor "BE1FP" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE1F"
Then field "re" has value "0" in row 2
Then field "offfolgepos" has value "0"
And I close the current editor

# Rechnung 1
Given I open an editor "RE1F1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "LS1F1"
And I set fields
   | nummer | 1F-EKRE1 |
   | such   | RE1F1    |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | nein     |
And I set field "mge" to "1" in row 1
And I set field "mge" to "2" in row 2
And I set field "mge" to "3" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ungebuchte RE in Lieferschein LS1F1 pruefen
Given I open an editor "LS1F1P" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS1F1"
Then field "re" has value "1" in row 1
Then field "offfolgepos" has value "3"
And I close the current editor

# Rechnung 2
Given I open an editor "RE1F2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "LS1F1"
And I set fields
   | nummer | 1F-EKRE2 |
   | such   | RE1F2    |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | nein     |
And I set field "mge" to "3" in row 3
And I delete row at position 2
And I delete row at position 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ungebuchte RE in Lieferschein LS1F1 pruefen
Given I open an editor "LS1F1P" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS1F1"
Then field "re" has value "2" in row 3
Then field "offfolgepos" has value "4"
And I close the current editor

Given I open an editor "RE1F2B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE1F2"
And I set field "ueb" to "ja"
And I save the current editor

# Ungebuchte RE in Lieferschein LS1F1 pruefen
Given I open an editor "LS1F1P" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS1F1"
Then field "re" has value "1" in row 1
Then field "offfolgepos" has value "3"
And I close the current editor

Given I open an editor "RE1F1B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE1F1"
And I set field "ueb" to "ja"
And I save the current editor

# Ungebuchte RE in Lieferschein LS1F1 pruefen
Given I open an editor "LS1F1P" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS1F1"
Then field "re" has value "0" in row 3
Then field "offfolgepos" has value "0"
And I close the current editor

# Rechnung 4
Given I open an editor "RE1F4" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "LS1F2"
And I set fields
   | nummer | 1F-EKRE4 |
   | such   | RE1F4    |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
And I set field "mge" to "7" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS1F2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+LS1F2"
And I set fields
   | nummer | 1F-EKRL2 |
   | such   | RLS1F2   |
   | ueb    | nein     |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Ungebuchte RLS in Lieferschein LS1F2 pruefen
Given I open an editor "LS1F2P" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS1F2"
Then field "offfolgepos" has value "1"
And I close the current editor

Given I open an editor "RE1F1B" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS1F2"
And I set field "ueb" to "ja"
And I save the current editor

# Ungebuchte RLS in Lieferschein LS1F2 pruefen
Given I open an editor "LS1F2P" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS1F2"
Then field "offfolgepos" has value "0"
And I close the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS1F2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS1F2"
And I set fields
   | nummer | 1F-EKKG2 |
   | such   | KGS1F2   |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | nein     |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ungebuchte KGS in Lieferschein RLS1F2 pruefen
Given I open an editor "RLS1F2P" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS1F2"
Then field "offfolgepos" has value "1"
And I close the current editor

Given I open an editor "WG1F1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1F1"
And I set fields
	| nummer | 1F-EKWG1 |
	| such   | WG1F1    |
	| ueb    | nein     |
	| tterm  | .        |
	| vom    | .        |
	| budat  | .        |
And I press button "komplettieren"
And I save the current editor

# Ungebuchte WGS in Rechnung RE1F1 pruefen
Given I open an editor "RE15P" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE1F1"
Then field "offfolgepos" has value "3"
And I close the current editor

Given I open an editor "WG15L" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "WG1F1"
And I delete row at position 2
And I save the current editor

# Eine ungebuchte WGS-Position zu Rechnung RE1F1
Given I open an editor "RE15P2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE1F1"
Then field "offfolgepos" has value "2"
And I close the current editor

Given I open an editor "WG15B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "WG1F1"
And I set field "ueb" to "ja"
And I save the current editor

# Eine ungebuchte WGS-Position zu Rechnung RE1F1
Given I open an editor "RE15P2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE1F1"
Then field "offfolgepos" has value "0"
And I close the current editor

