@persistent
Feature: ue_verwerfen 
# BW2-2128
Background:
Given I set the fake date to "10.01.2002"


Scenario: uE Buchung auch fuer konten auslösen

Given I open an editor "Konto50027" from table "(Account):(Account)" with command "UPDATE" for record "50027"
And I set field "hkost" to "ja"
And I save the current editor

Given I open an editor "Konto50089" from table "(Account):(Account)" with command "UPDATE" for record "50089"
And I set field "hkost" to "ja"
And I save the current editor


Scenario: 01 Rückbau nur Gutmenge mit mzeit ohne Fertigungszeiten jedoch mit Sonderkosten 
#-------------------------------------------------------------------------------

# Bestand für E1FR-VF mittels manuellem Lagerzugang bereitstellen 
   And I post a receipt via ManualStockAdjustment for Product "E1FR-VF" and quantity "10" on StorageLocation "F2" with document "zug1E1FR-VF" and price "4.0"

# Fertigungsvorschlag anlegen und freigeben, 

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel  | netmge | mfreig | bisuch | kstelle |
      | BG1EI-VO | 10     | ja     | RUECKB_EINSEITIG_   | 100000  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKB_EINSEITIG_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "bem" to "s1_rm1"
	# erbtext1    
    And I save the current editor
    
# Rückmeldung auf 2. Arbeitsgang
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKB_EINSEITIG_002"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "bem" to "s1_rm2"
    And I save the current editor

# dispo
And I run Scheduling
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Rückbau 
	# Given I open an editor "Rückbau1-nicht-möglich-und-keine-fehlermeldung" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
	Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for record "$,,nummer==1001002;gutmge==10;typ=Rückmeldung;@sort=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
	Then field "artikel" has value "BG1EI-VO" in row 1
	And I set field "mzeit" to "2.2"
	And I set field "gutmge" to "-10" in row 1
    And I save the current editor

# dispo
And I run Scheduling
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


# Nachmeldung Entnahmenge und Zeiten nach BA-Abschluss UND Gesamtrückbau:
	Given I open an editor "nach-rmeldung-fuer-rückmeldung2" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
	And I set field "mzeit" to "7"
	And I set field "gutmge" to "1" in row 1
	And I set field "mge" to "3" in row 2
	And I save the current editor
	
# dispo
And I run Scheduling
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue


Scenario: 02 Rückbau mit bzeit alle Mengen mit Fertigungszeiten und Sonderkosten 
#-------------------------------------------------------------------------------

Given I set the fake date to "12.01.2002"

# Bestand für E1FR-VF mittels manuellem Lagerzugang bereitstellen 
   And I post a receipt via ManualStockAdjustment for Product "E1FR-VF" and quantity "10" on StorageLocation "F2" with document "zug2E1FR-VF" and price "5.0"

# Fertigungsvorschlag anlegen und freigeben, 

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel  | netmge | mfreig | bisuch | kstelle |
      | BG1EI-VO | 10     | ja     | RUECKB_GESAMT_   | 100000  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "voll-rm1-fuer-rueckbau-gesamt" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKB_GESAMT_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "bem" to "gesamt_rm_1"
    And I set field "mzeit" to "4"
    And I set field "mzeit2" to "3"
    And I save the current editor
    
# Rückmeldung auf 2. Arbeitsgang
    Given I open an editor "voll-rm2-fuer-rueckbau-gesamt" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKB_GESAMT_002"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "bem" to "gesamt_rm_2"
    And I set field "lgr" to "1"
    And I set field "bzeit" to "2"
    And I save the current editor

# dispo
And I run Scheduling
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

Given I set the fake date to "13.01.2002"

# Rückbau mit Zeiten 
	Given I open an editor "Rückbau2" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for record "$,,nummer==1002002;gutmge==10;typ=Rückmeldung;@sort=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
	Then field "artikel" has value "BG1EI-VO" in row 1
    And I set field "bem" to "gesamt_rb"
	And I set field "lgr" to "1"
	And I set field "bzeit" to "5"
	And I set field "gutmge" to "-10" in row 1
	And I set field "mge" to "-10" in row 2
	And I save the current editor

Given I set the fake date to "14.01.2002"

	
# dispo
And I run Scheduling
# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
