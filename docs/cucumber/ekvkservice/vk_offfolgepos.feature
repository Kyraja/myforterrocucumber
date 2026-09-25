# *****************************************************************************************
#  Name           : vk_offfolgepos.feature
#  Autor          : foe
#  Verantwortlich : teampss
#  Funktion       : Test fuer das Feld evofffolgepos im Verkauf
#  Beschreibung   :
#  Testet das Feld evofffolgepos, das angibt, wieviele offene Folgepositionen zu einen EV-Objekt vorhanden sind.
#
# *****************************************************************************************
#
@persistent
Feature: Test zu Feld offfolgepos im Verkauf
Background:
Given I set the fake date to "02.01.1995"

Scenario Outline: Folgevorganege im Verkauf

#---------------------------------------------------------------------------------------------
Scenario: AU -> LS -> RE -> RLS -> KGS
#----------------------------------------------------------------------------------------------

# Auftrag anlegen
Given I open an editor "AU1F" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1     |
   | nummer | 1F-AU |
   | such   | AU1F  |
   And I append rows
	| artikel      | mge    | preis |
	| EINK         | 15     | 19    |
	| E1           | 10     | 5     |
	| E3           | 20     | 4     |
And I save the current editor

# Lieferschein 1
Given I open an editor "LS1F1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AU1F"
And I set fields
   | nummer | 1F-VKLS |
   | such   | LS1F1   |
   | vom    | .       |
   | budat  | .       |
   | ueb    | nein    |
And I set field "mge" to "5" in row 1
And I set field "mge" to "4" in row 2
And I set field "mge" to "10" in row 3
And I save the current editor

# Lieferschein 2
Given I open an editor "LS1F2" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AU1F"
And I set fields
   | nummer | 1F-VKLS2 |
   | such   | LS1F2    |
   | vom    | .        |
   | budat  | .        |
   | ueb    | nein     |
And I set field "mge" to "3" in row 1
And I set field "mge" to "7" in row 3
And I save the current editor

# Lieferschein 3
Given I open an editor "LS1F3" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AU1F"
And I set fields
   | nummer | 1F-VKLS3 |
   | such   | LS1F3    |
   | vom    | .        |
   | budat  | .        |
   | ueb    | nein     |
And I set field "mge" to "5" in row 2
And I save the current editor

# Ungebuchte LS in Auftrag AU1F pruefen
Given I open an editor "AU1FP" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU1F"
Then field "re" has value "2" in row 1
Then field "offfolgepos" has value "6"
And I close the current editor

Given I open an editor "LS1F1B" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS1F1"
And I set field "ueb" to "ja"
And I save the current editor

# Ungebuchte LS in Auftrag AU1F pruefen
Given I open an editor "AU1FP" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU1F"
Then field "re" has value "1" in row 2
Then field "offfolgepos" has value "3"
And I close the current editor

Given I open an editor "LS1F2B" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS1F2"
And I set field "ueb" to "ja"
And I delete row at position 1
And I save the current editor

# Ungebuchte LS in Auftrag AU1F pruefen
Given I open an editor "AU1FP" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU1F"
Then field "re" has value "1" in row 2
Then field "offfolgepos" has value "1"
And I close the current editor

Given I open an editor "LS1F3B" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS1F3"
And I set field "ueb" to "ja"
And I save the current editor

# Ungebuchte LS in Auftrag AU1F pruefen
Given I open an editor "AU1FP" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU1F"
Then field "re" has value "0" in row 2
Then field "offfolgepos" has value "0"
And I close the current editor

# Rechnung 1
Given I open an editor "RE1F1" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "LS1F1"
And I set fields
   | nummer | 1F-VKRE1 |
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
Given I open an editor "LS1F1P" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS1F1"
Then field "re" has value "1" in row 1
Then field "offfolgepos" has value "3"
And I close the current editor

# Rechnung 2
Given I open an editor "RE1F2" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "LS1F1"
And I set fields
   | nummer | 1F-VKRE2 |
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
Given I open an editor "LS1F1P" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS1F1"
Then field "re" has value "2" in row 3
Then field "offfolgepos" has value "4"
And I close the current editor

Given I open an editor "RE1F2B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE1F2"
And I set field "ueb" to "ja"
And I save the current editor

# Ungebuchte RE in Lieferschein LS1F1 pruefen
Given I open an editor "LS1F1P" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS1F1"
Then field "re" has value "1" in row 1
Then field "offfolgepos" has value "3"
And I close the current editor

Given I open an editor "RE1F1B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE1F1"
And I set field "ueb" to "ja"
And I save the current editor

# Ungebuchte RE in Lieferschein LS1F1 pruefen
Given I open an editor "LS1F1P" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS1F1"
Then field "re" has value "0" in row 3
Then field "offfolgepos" has value "0"
And I close the current editor

# Rechnung 4
Given I open an editor "RE1F4" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "LS1F2"
And I set fields
   | nummer | 1F-VKRE4 |
   | such   | RE1F4    |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
And I set field "mge" to "7" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS1F2" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+LS1F2"
And I set fields
   | nummer | 1F-VKRL2 |
   | such   | RLS1F2   |
   | ueb    | nein     |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Ungebuchte RLS in Lieferschein LS1F2 pruefen
Given I open an editor "LS1F2P" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS1F2"
Then field "offfolgepos" has value "1"
And I close the current editor

Given I open an editor "RE1F1B" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS1F2"
And I set field "ueb" to "ja"
And I save the current editor

# Ungebuchte RLS in Lieferschein LS1F2 pruefen
Given I open an editor "LS1F2P" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS1F2"
Then field "offfolgepos" has value "0"
And I close the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS1F2" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS1F2"
And I set fields
   | nummer | 1F-VKKG2 |
   | such   | KGS1F2   |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | nein     |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ungebuchte KGS in Lieferschein RLS1F2 pruefen
Given I open an editor "RLS1F2P" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS1F2"
Then field "offfolgepos" has value "1"
And I close the current editor

Given I open an editor "WG1F1" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1F1"
And I set fields
	| nummer | 1F-VKWG1 |
	| such   | WG1F1    |
	| ueb    | nein     |
	| tterm  | .        |
	| vom    | .        |
	| budat  | .        |
And I press button "komplettieren"
And I save the current editor

# Ungebuchte WGS in Rechnung RE1F1 pruefen
Given I open an editor "RE15P" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE1F1"
Then field "offfolgepos" has value "3"
And I close the current editor

Given I open an editor "WG15L" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "WG1F1"
And I delete row at position 2
And I save the current editor

# Eine ungebuchte WGS-Position zu Rechnung RE1F1
Given I open an editor "RE15P2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE1F1"
Then field "offfolgepos" has value "2"
And I close the current editor

Given I open an editor "WG15B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "WG1F1"
And I set field "ueb" to "ja"
And I save the current editor

# Eine ungebuchte WGS-Position zu Rechnung RE1F1
Given I open an editor "RE15P2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE1F1"
Then field "offfolgepos" has value "0"
And I close the current editor
