@persistent
Feature: ue_verwerfen 
# BW2-2128
Background:
Given I set the fake date to "10.01.2002"


Scenario: uE Buchung auch fuer konten auslösen
--------------------------------------------------

Given I open an editor "Konto50027" from table "(Account):(Account)" with command "UPDATE" for record "50027"
And I set field "hkost" to "ja"
And I save the current editor

Given I open an editor "Konto50089" from table "(Account):(Account)" with command "UPDATE" for record "50089"
And I set field "hkost" to "ja"
And I save the current editor


Scenario: 01 Abbruch und Nachmeldung auf BA alle Mengen mit Fertigungszeiten und Sonderkosten 
#-----------------------------------------------------------------------------------------------

# Bestand für E1FR-VF mittels manuellem Lagerzugang bereitstellen 
And I post a receipt via ManualStockAdjustment for Product "E1FR-VF" and quantity "10" on StorageLocation "F2" with document "zug3E1FR-VF" and price "6.0"

# Fertigungsvorschlag anlegen und freigeben, 

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
  | artikel  | netmge | mfreig | bisuch | kstelle |
  | BG1EI-VO | 10     | ja     | ABBR_NACHMELD_  | 100000  |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
Given I open an editor "voll-rm1-fuer-abbruch_nachmeldung" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABBR_NACHMELD_001"
And I set field "gut" to "1"
And I set field "sofort" to "1"
And I set field "mzeit" to "1"
And I set field "gutmge" to "8" in row 1
And I save the current editor
    
# Betriebsauftrag abschließen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ABBR_NACHMELD_000"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "s"
And I save the current editor

# dispo
And I run Scheduling
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Nachmeldung Entnahmenge und Zeiten nach BA-Abschluss UND Gesamtrückbau:
Given I open an editor "nach-abbruch-rmeldung" via ID from editor "voll-rm1-fuer-abbruch_nachmeldung" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
And I set field "mzeit" to "2"
And I set field "mge" to "3" in row 2
And I save the current editor

# dispo
And I run Scheduling
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
