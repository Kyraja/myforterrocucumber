# *****************************************************************************************
#  Name           : ev_kopievon.feature
#  Autor          : foe
#  Verantwortlich : foe
#  Kontrolle      :
#  Funktion       : Test fuer das Feld evkopievon
#  Beschreibung   :
#  Testet das Feld evkopievon, das angibt, aus welcher Position eine Position kopiert wurde.
#  Es muss immer geleert werden, wenn die Position, aus der kopiert wurde, geloescht wird.
#
# *****************************************************************************************
#
@persistent
Feature: Test zum Feld evkopievon im Ein- und Verkauf
Background:
Given I set the fake date to "02.01.1995"

#----------------------------------------------------------------------------------------------
Scenario: EK - Anfrage kopieren und Position loeschen
#----------------------------------------------------------------------------------------------
Given I open an editor "ANF-1O" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
   | lief    | 1        |
   | such    | ANF-1O   |
When I create a new row at the end of the table
And I set field "artex" to "E1" in row 1
And I set field "mge" to "1" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "15" in row 2
When I create a new row at the end of the table
And I set field "artex" to "V3" in row 3
And I set field "mge" to "5" in row 3
And I save the current editor

Given I open an editor "ANF-1K" from table "(Purchasing):(Request)" with command "COPY" for record from editor "ANF-1O"
And I set fields
   | such    | ANF-1K   |
And I save the current editor

Given I open an editor "ANF-1OU" from table "(Purchasing):(Request)" with command "UPDATE" for record from editor "ANF-1O"
And I delete row at position 2
And I save the current editor

Given I open an editor "ANF-1KV" from table "(Purchasing):(Request)" with command "VIEW" for record from editor "ANF-1K"
Then field "kopievon" has value "" in row 2
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung kopieren und Position loeschen nicht moeglich
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-1O" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1OBE    |
   | lief    | 1       |
   | such    | BE-1O   |
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "20" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "3" in row 2
When I create a new row at the end of the table
And I set field "artex" to "V2" in row 3
And I set field "mge" to "25" in row 3
And I save the current editor

Given I open an editor "BE-1K" from table "(Purchasing):(PurchaseOrder)" with command "COPY" for record from editor "BE-1O"
And I set fields
   | such    | BE-1K   |
And I save the current editor

Given I open an editor "BE-1OU" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE-1O"
Then deleting the row at position 1 throws the exception "111"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Lieferschein kopieren und Position loeschen
#----------------------------------------------------------------------------------------------
Given I open an editor "LS-1O" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1OLS    |
   | lief    | 1       |
   | such    | LS-1O   |
   | vom     | .       |
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "20" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "3" in row 2
When I create a new row at the end of the table
And I set field "artex" to "V2" in row 3
And I set field "mge" to "25" in row 3
And I save the current editor

Given I open an editor "LS-1K" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "LS-1O"
And I set fields
   | such    | LS-1K   |
   | ebeleg  | 1KLS    |
   | vom     | .       |
And I save the current editor

Given I open an editor "LS-1OU" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS-1O"
And I delete row at position 1
And I save the current editor

Given I open an editor "LS-1KV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS-1K"
Then field "kopievon" has value "" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Rechnung kopieren und Position loeschen
#----------------------------------------------------------------------------------------------
Given I open an editor "RE-1O" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer  | 1ORE    |
   | ebeleg  | 1ORE    |
   | lief    | 1       |
   | such    | RE-1O   |
   | vom     | .       |
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "20" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "3" in row 2
When I create a new row at the end of the table
And I set field "artex" to "V2" in row 3
And I set field "mge" to "25" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE-1K" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "RE-1O"
And I set fields
   | such    | RE-1K   |
   | ebeleg  | 1KRE    |
   | vom     | .       |
And I save the current editor

Given I open an editor "RE-1OU" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE-1O"
And I delete row at position 1
And I save the current editor

Given I open an editor "RE-1KV" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE-1K"
Then field "kopievon" has value "" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Rahmenauftrag kopieren und Position loeschen
#----------------------------------------------------------------------------------------------
Given I open an editor "RA-1O" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1ORA    |
   | lief    | 1       |
   | such    | RA-1O   |
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "20" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "3" in row 2
When I create a new row at the end of the table
And I set field "artex" to "V2" in row 3
And I set field "mge" to "25" in row 3
And I save the current editor

Given I open an editor "RA-1K" from table "(Purchasing):(BlanketOrder)" with command "COPY" for record from editor "RA-1O"
And I set fields
   | such    | RA-1K   |
And I save the current editor

Given I open an editor "RA-1OU" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record from editor "RA-1O"
And I delete row at position 1
And I save the current editor

Given I open an editor "RA-1KV" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record from editor "RA-1K"
Then field "kopievon" has value "" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Angebot kopieren und Position loeschen
#----------------------------------------------------------------------------------------------
Given I open an editor "ANG-1O" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
   | nummer  | 1OANG    |
   | kunde   | 1        |
   | such    | ANG-1O   |
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "20" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "3" in row 2
When I create a new row at the end of the table
And I set field "artex" to "V2" in row 3
And I set field "mge" to "25" in row 3
And I save the current editor

Given I open an editor "ANG-1K" from table "(Sales):(Quotation)" with command "COPY" for record from editor "ANG-1O"
And I set fields
   | such    | ANG-1K   |
And I save the current editor

Given I open an editor "ANG-1OU" from table "(Sales):(Quotation)" with command "UPDATE" for record from editor "ANG-1O"
And I delete row at position 1
And I save the current editor

Given I open an editor "ANG-1KV" from table "(Sales):(Quotation)" with command "VIEW" for record from editor "ANG-1K"
Then field "kopievon" has value "" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag kopieren und Position loeschen nicht moeglich
#----------------------------------------------------------------------------------------------
Given I open an editor "AU-1O" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1OAU    |
   | kunde   | 1        |
   | such    | AU-1O   |
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "20" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "3" in row 2
When I create a new row at the end of the table
And I set field "artex" to "V2" in row 3
And I set field "mge" to "25" in row 3
And I save the current editor

Given I open an editor "AU-1K" from table "(Sales):(SalesOrder)" with command "COPY" for record from editor "AU-1O"
And I set fields
   | such    | AU-1K   |
And I save the current editor

Given I open an editor "AU-1OU" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-1O"
Then deleting the row at position 1 throws the exception "111"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Lieferschein kopieren und Position loeschen
#----------------------------------------------------------------------------------------------
Given I open an editor "LS-1O" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1OLS    |
   | kunde   | 1       |
   | such    | LS-1O   |
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "20" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "3" in row 2
When I create a new row at the end of the table
And I set field "artex" to "V2" in row 3
And I set field "mge" to "25" in row 3
And I save the current editor

Given I open an editor "LS-1K" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "LS-1O"
And I set fields
   | such    | LS-1K   |
And I save the current editor

Given I open an editor "LS-1OU" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS-1O"
And I delete row at position 1
And I save the current editor

Given I open an editor "LS-1KV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS-1K"
Then field "kopievon" has value "" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Rechnung kopieren und Position loeschen
#----------------------------------------------------------------------------------------------
Given I open an editor "RE-1O" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer  | 1ORE    |
   | kunde   | 1       |
   | such    | RE-1O   |
   | tterm   | .       |
   | budat   | .       |
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "20" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "3" in row 2
When I create a new row at the end of the table
And I set field "artex" to "V2" in row 3
And I set field "mge" to "25" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE-1K" from table "(Sales):(Invoice)" with command "COPY" for record from editor "RE-1O"
And I set fields
   | such    | RE-1K   |
   | tterm   | .       |
   | budat   | .       |
And I save the current editor

Given I open an editor "RE-1OU" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE-1O"
And I delete row at position 1
And I save the current editor

Given I open an editor "RE-1KV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE-1K"
Then field "kopievon" has value "" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Rahmenauftrag kopieren und Position loeschen
#----------------------------------------------------------------------------------------------
Given I open an editor "RA-1O" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1ORA    |
   | kunde   | 1       |
   | such    | RA-1O   |
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "20" in row 1
When I create a new row at the end of the table
And I set field "artex" to "EINK" in row 2
And I set field "mge" to "3" in row 2
When I create a new row at the end of the table
And I set field "artex" to "V2" in row 3
And I set field "mge" to "25" in row 3
And I save the current editor

Given I open an editor "RA-1K" from table "(Sales):(BlanketOrder)" with command "COPY" for record from editor "RA-1O"
And I set fields
   | such    | RA-1K   |
And I save the current editor

Given I open an editor "RA-1OU" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record from editor "RA-1O"
And I delete row at position 1
And I save the current editor

Given I open an editor "RA-1KV" from table "(Sales):(BlanketOrder)" with command "VIEW" for record from editor "RA-1K"
Then field "kopievon" has value "" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK- Rechnung kopieren und pruefen, dass Feld dokumentbaurl in der Kopie geleert ist
#----------------------------------------------------------------------------------------------
Given I open an editor "VKURL" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | vom    | .     |
   | tterm  | .     |
   | such   | COPYV |
And I set field "dokumentbaurl" to "112"
And I append rows
   | artikel  | mge    |
   | V2       | 11     |
Then field "dokumentbaurl" has value "http://112"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "VKURL copy" from table "(Sales):(Invoice)" with command "COPY" for record "COPYV"
And I set fields
   | vom    | .     |
   | tterm  | .     |
Then field "dokumentbaurl" has value ""
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK- Bestellung kopieren und pruefen, dass Feld dokumentbaurl in der Kopie geleert ist
#----------------------------------------------------------------------------------------------
Given I open an editor "EKURL" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1     |
   | vom    | .     |
   | tterm  | .     |
   | such   | COPYE |
And I set field "dokumentbaurl" to "112"
And I append rows
   | artikel  | mge    |
   | E2       | 11     |
Then field "dokumentbaurl" has value "http://112"
And I save the current editor

Given I open an editor "EKURL copy" from table "(Purchasing):(PurchaseOrder)" with command "COPY" for record "COPYE"
And I set fields
   | vom    | .     |
   | tterm  | .     |
Then field "dokumentbaurl" has value ""
And I save the current editor
