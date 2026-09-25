@persistent
Feature: refbw_faktor_einheitenaenderung_in_rm_dann_rbau_mrueckg.feature

Background:
Given I set the fake date to "6.01.1995"

# *****************************************************************************
#  Autor            : lschneider 
#  Verantwortlich   : uo
#  Kontrolle        :
#  Funktion         : Faktoränderung in der RM
# *****************************************************************************

Scenario: 01 Storno von Materialrückgabe über Rückmeldung und Fbuchung von zusätzlich entnommenem Material 
          mit Einheiten über Rückmeldung.
          Einheit und Faktor werden ggü. den Teilestammdaten ausschließlich in der Rückmeldung und dort 
          im zusätzl. entnommenen Material geändert. Sonst an keiner Stelle. 
          
Given I set the fake date to "6.01.1995"

# Bestand auf 0 korrigieren
Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "QUANT0-1"
Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "QUANT0-1"

# das wäre in STL nochmal das selbe material, dafür kann man den faktor in der RM aber NICHT ändern. das wird schon anderswo getestet # Given I open an editor "baugruppe" from table "(Part):(Product)" with command "UPDATE" for record "BAUGRUPPE"
# das wäre in STL nochmal das selbe material, dafür kann man den faktor in der RM aber NICHT ändern. das wird schon anderswo getestet # And I modify table
# das wäre in STL nochmal das selbe material, dafür kann man den faktor in der RM aber NICHT ändern. das wird schon anderswo getestet # 	| !row	| elex		| anzahl	| 
# das wäre in STL nochmal das selbe material, dafür kann man den faktor in der RM aber NICHT ändern. das wird schon anderswo getestet # 	| +3	| GEBINDE		| 2			| 
# das wäre in STL nochmal das selbe material, dafür kann man den faktor in der RM aber NICHT ändern. das wird schon anderswo getestet # 	| +3	| GEBINDEPFL	| 1			| 
# das wäre in STL nochmal das selbe material, dafür kann man den faktor in der RM aber NICHT ändern. das wird schon anderswo getestet # And I save the current editor

 # Auftrag anlegen und Material einkaufen
 Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
 Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
 And I set fields
   | lief	| KETTLER	|
   | vom		| .			|
   | ueb		| ja		|
   | fakt	| ja		|
   | ebeleg	| R-13		|
 And I append rows
   | artikel		| mge	|
   | EINKAUF-1	| 10	|
   | EINKAUF-2	| 5		|
   | GEBINDE		| 10	|
   | GEBINDEPFL	| 6		|
 And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
 And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
 And I respond with answer "ja" to the dialog with id "4841"
 And I save the current editor

# Fertigungsvorschlag anlagen und freigeben
 Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
 And I append rows
   | artikel	    | netmge	| bisuch	| mfreig	|
   | BAUGRUPPE	| 10		| EINHAEND_SR_	| ja		|
 And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row !lastRow
 And I press button "freig" to open a subeditor for "BA_freigeben"
 And I close the current editor
 And I switch the current editor to editor "fvor"
 And I save the current editor

# Buchen von zusätzlichem Material über Rückmeldung und Teil der Gutmenge
 Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINHAEND_SR_001"
 And I set fields
   | sofort	| ja			|
   | bem		| Rückmeldung1	|
 And I modify table
   | artikel		| bueinh		| zele			| bumge			| gutmge		|!row	|
   | !dontChange	| !dontChange	| !dontChange	| !dontChange	| 5				| 1		|
   | GEBINDEPFL	| Paar			| 5				|    6			| !dontChange	| +2	|
   | GEBINDE		| kg			| 2 			|    10			| !dontChange	| +3	|
 And I save the current editor

# Materialrückgabe über Rückmeldung und Fbuchung
 Given I open an editor "Rückgabe1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "EINHAEND_SR_001"
 And I set fields
   | sofort	| ja		|
   | bem		| Rückgabe1	|
 Then the table has 3 rows
 And I modify table
   | artikel		| bueinh		| bumge			| gutmge		|!row	|
   | !dontChange	| !dontChange	| !dontChange	| -1			| 1		|
   | GEBINDEPFL	| Stück			| -6			| !dontChange	| 2		|
   | GEBINDE		| Stück			| -1			| !dontChange	| 3		|
 And I save the current editor

#    And I wait 1 time units to move the time forward
Given I set the fake date to "7.01.1995"
    
  Given I open an editor "Rückgabe2" for tip command "Fbuchung" and arguments ""
  And I set fields
    | auftrag		| $,,such=EINHAEND_SR_001;@richtung=rückwärts;@maxtreffer=1	|
    | bem			| Rückgabe2					|
  And I press button "stllad"
  And I modify table
    | !row                  | bumge | bueinh  |
    | artikel=='GEBINDE'    | -5    | kg      |
    | artikel=='GEBINDEPFL' | -3    | Paar    |
  And I save the current editor

  Given I open an editor "Rückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=EINHAEND_SR_001;bem=Rückgabe2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
  And I close the current editor

# Storno der Rückgaben
  Given I open an editor "Storno1_Rückgabe2" via ID from editor "Rückgabe2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
  And I save the current editor

  Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
  And I save the current editor

# Betriebsauftrag abschließen
  Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EINHAEND_SR_001"
  And I set fields
    | sofort	| ja			|
    | gut		| ja			|
  And I save the current editor
  And I deliver the SalesOrder "auftrag" with PackingSlip "LS-R14"

# Bestände auf 0 korrigieren
 Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "BK_RUECK_SR"
 Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "BK_RUECK_SR"

# NB
 And I run Revaluation
