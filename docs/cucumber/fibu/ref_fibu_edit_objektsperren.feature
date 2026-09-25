@persistent
Feature: fibu_objektsperren

Background:
And I set the fake date to "20.02.2002"

# *****************************************************************************
#  Autor            : uo
#  Verantwortlich   : uo
#  Funktion         : Rechungswesensperren Sonderhalten Fibu-Editor
#  Jira-Issue       : 
# *****************************************************************************

Scenario: 01 sperrpruefung ohne wartung 
And I set the fake date to "20.02.2002"

    # -------- sperrfähiges konto anlegen ---------
	Given I open an editor "freies_konto" from table "(Account):(Account)" with command "COPY" for record "50000"
	And I set field "nummer" to "50011"
	And I save the current editor


    # -------- sperrfähige kostenstelle anlegen ---------
	Given I open an editor "freie_Kostenstelle" from table "(Account):(CostCenter)" with command "COPY" for record "100"
	And I set field "nummer" to "511"
	And I save the current editor

	Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
	And I set field "such" to "sperrbu1"
	And I set field "beleg" to "sperrbu1"
	And I create a new row at the end of the table
	And I set field "konto" to "10000" in row !lastRow
	And I set field "ewsbetr" to "3" in row !lastRow
	And I create a new row at the end of the table
	And I set field "konto" to "50011" in row !lastRow
	And I set field "kstelle" to "511" in row !lastRow
	And I respond with answer "Ja" to the dialog with id "583"
	And I save the current editor


	Given I open an editor "Konto_sperren" from table "(Account):(Account)" with command "UPDATE" for record "50011" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	# Then saving the current editor throws the exception "1822"
    And I save the current editor

	Given I open an editor "Konto_sperre_prüfen" from table "(Account):(Account)" with command "VIEW" for record "50011" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kontosperre"
    And I close the current editor


    Given I open an editor "Kostenstelle_sperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "511" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
	# Then saving the current editor throws the exception "1822"
    And I save the current editor

    Given I open an editor "Kostenstelle_sperre_prüfen" from table "(Account):(CostCenter)" with command "VIEW" for record "511" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
    And I close the current editor

	 
    Given I open an editor "Buchung_view1" from table "(Entry):(Entry)" with command "VIEW" for record "BSPERRBU1"
	Then field "konto" has value "10000" in row 1
	Then field "konto" has value "50011" in row 2
	Then field "kstelle" has value "511" in row 2
    And I close the current editor


    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "UPDATE" for record "BSPERRBU1"
	And I set field "text" to "butext aendern"
	Then setting field "ewsbetr" to "4" in row 1 throws the exception "203"
	And I set field "ptext" to "ptext ergaenzen" in row 2
	And I respond with answer "Ja" to the dialog with id "583"
	And I save the current editor

	
Scenario: 02 sperrpruefung mit Wartung Maintenance Buchung ändern 

Given I'm logged in with password "annette"
# ohne das datum geht es nicht!
And I set the fake date to "20.02.2002"

	Given I open an editor "Konto_sperre_prüfen" from table "(Account):(Account)" with command "VIEW" for record "50011" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kontosperre"
    And I close the current editor

    Given I open an editor "Kostenstelle_sperre_prüfen" from table "(Account):(CostCenter)" with command "VIEW" for record "511" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
    And I close the current editor
	 
    Given I open an editor "Buchung_view1" from table "(Entry):(Entry)" with command "VIEW" for record "BSPERRBU1"
	Then field "konto" has value "10000" in row 1
	Then field "konto" has value "50011" in row 2
	Then field "kstelle" has value "511" in row 2
    And I close the current editor


    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "UPDATE" for record "BSPERRBU1"
	And I set field "text" to "butext aendern"
	And I set field "ewsbetr" to "4" in row 1
	And I set field "ewhbetr" to "0" in row 2
	And I set field "ptext" to "ptext ergaenzen" in row 2
	And I respond with answer "Ja" to the dialog with id "583"
	And I save the current editor

	Given I open an editor "Konto_sperre_prüfen" from table "(Account):(Account)" with command "VIEW" for record "50011" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kontosperre"
    And I close the current editor

    Given I open an editor "Kostenstelle_sperre_prüfen" from table "(Account):(CostCenter)" with command "VIEW" for record "511" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
    And I close the current editor
	 
    Given I open an editor "Buchung_view1" from table "(Entry):(Entry)" with command "VIEW" for record "BSPERRBU1"
	Then field "konto" has value "10000" in row 1
	Then field "konto" has value "50011" in row 2
	Then field "kstelle" has value "511" in row 2
    And I close the current editor



Scenario: 03 sperrpruefung mit Wartung Maintenance Buchung neu mit gesperrten Konto und Kostenstelle 

Given I'm logged in with password "annette"
# ohne das datum geht es nicht!
And I set the fake date to "20.02.2002"

	Given I open an editor "Konto_sperre_prüfen" from table "(Account):(Account)" with command "VIEW" for record "50011" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kontosperre"
    And I close the current editor

    Given I open an editor "Kostenstelle_sperre_prüfen" from table "(Account):(CostCenter)" with command "VIEW" for record "511" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
    And I close the current editor


	# neu mit gesperrten konto und kst 
	Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
	And I set field "such" to "sperrbu2"
	And I set field "budat" to "20.02.2002"
	And I set field "beleg" to "sperrbu2"
	And I create a new row at the end of the table
	And I set field "konto" to "10000" in row !lastRow
	And I set field "ewsbetr" to "3" in row !lastRow
	And I create a new row at the end of the table
	And I set field "konto" to "50000" in row !lastRow
	And I set field "kstelle" to "511" in row !lastRow
	And I respond with answer "Ja" to the dialog with id "583"
	And I save the current editor
