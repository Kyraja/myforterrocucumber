@persistent
Feature: kore_objektsperren

Background:
And I set the fake date to "20.02.2002"

# ***********************************************************************************************
#  Autor            : uo
#  Verantwortlich   : uo
#  Funktion         : Rechungswesensperren Kostenrechnung Sonderverhalten Stat.Buchungseditor
#  Jira-Issue       : 
# ***********************************************************************************************

Scenario: 01 sperrpruefung ohne wartung 
And I set the fake date to "20.02.2002"

    # -------- sperrfähige kostenstelle anlegen ---------
	Given I open an editor "freie_Kostenstelle" from table "(Account):(CostCenter)" with command "COPY" for record "100"
	And I set field "nummer" to "511"
	And I save the current editor

	Given I open an editor "Buchung" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
	And I set field "such" to "sperrbu1"
	And I set field "beleg" to "sperrbu1"
	And I create a new row at the end of the table
	And I set field "konto" to "99900" in row !lastRow
	And I set field "sbetrag" to "3" in row !lastRow
	And I create a new row at the end of the table
	And I set field "konto" to "99800" in row !lastRow
	And I set field "kstelle" to "511" in row !lastRow
	And I respond with answer "Ja" to the dialog with id "583"
	And I save the current editor


	Given I open an editor "Konto_sperren" from table "(Account):(Account)" with command "UPDATE" for record "99800" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
    And I save the current editor

	Given I open an editor "Konto_sperre_prüfen" from table "(Account):(Account)" with command "VIEW" for record "99800" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kontosperre"
    And I close the current editor

	Given I open an editor "Konto_sperren" from table "(Account):(Account)" with command "UPDATE" for record "99900" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
    And I save the current editor

	Given I open an editor "Konto_sperre_prüfen" from table "(Account):(Account)" with command "VIEW" for record "99900" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kontosperre"
    And I close the current editor



    Given I open an editor "Kostenstelle_sperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "511" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
    And I save the current editor

    Given I open an editor "Kostenstelle_sperre_prüfen" from table "(Account):(CostCenter)" with command "VIEW" for record "511" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
    And I close the current editor

	 
    Given I open an editor "Buchung_view1" from table "(Entry):(StatisticalEntry)" with command "VIEW" for record "SPERRBU1"
	Then field "konto" has value "99900" in row 1
	Then field "konto" has value "99800" in row 2
	Then field "kstelle" has value "511" in row 2
    And I close the current editor


    Given I open an editor "Buchung" from table "(Entry):(StatisticalEntry)" with command "UPDATE" for record "SPERRBU1"
	And I set field "text" to "butext aendern"
	Then setting field "sbetrag" to "4" in row 1 throws the exception "203"
	And I set field "ptext" to "ptext ergaenzen" in row 2
	And I respond with answer "Ja" to the dialog with id "583"
	And I save the current editor

	
Scenario: 02 sperrpruefung mit Wartung Maintenance 

Given I'm logged in with password "annette"
# ohne das datum geht es nicht!
And I set the fake date to "20.02.2002"

    Given I open an editor "Buchung_view1" from table "(Entry):(StatisticalEntry)" with command "VIEW" for record "SPERRBU1"
	Then field "konto" has value "99900" in row 1
	Then field "konto" has value "99800" in row 2
	Then field "kstelle" has value "511" in row 2
    And I close the current editor

	Given I open an editor "Konto_sperre_prüfen" from table "(Account):(Account)" with command "VIEW" for record "99800" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kontosperre"
    And I close the current editor

	Given I open an editor "Konto_sperre_prüfen" from table "(Account):(Account)" with command "VIEW" for record "99900" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kontosperre"
    And I close the current editor

    Given I open an editor "Kostenstelle_sperre_prüfen" from table "(Account):(CostCenter)" with command "VIEW" for record "511" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
    And I close the current editor

    Given I open an editor "Buchung" from table "(Entry):(StatisticalEntry)" with command "UPDATE" for record "SPERRBU1"
	And I set field "text" to "butext aendern"
	# in wartung auch betrag ändern
	And I set field "sbetrag" to "4" in row 1
	And I set field "hbetrag" to "0" in row 2
	And I set field "ptext" to "ptext ergaenzen" in row 2
	And I respond with answer "Ja" to the dialog with id "583"
	And I save the current editor

    Given I open an editor "Buchung_view1" from table "(Entry):(StatisticalEntry)" with command "VIEW" for record "SPERRBU1"
	Then field "konto" has value "99900" in row 1
	Then field "konto" has value "99800" in row 2
	Then field "kstelle" has value "511" in row 2
    And I close the current editor

    # -------- sperrfähige kostenstelle anlegen ---------
	Given I open an editor "freie_Kostenstelle" from table "(Account):(CostCenter)" with command "COPY" for record "101"
	And I set field "nummer" to "211"
	And I save the current editor

    Given I open an editor "Kostenstelle_sperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "211" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
    And I save the current editor

    Given I open an editor "Kostenstelle_sperre_prüfen" from table "(Account):(CostCenter)" with command "VIEW" for record "211" 	
	Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
    And I close the current editor


	# neu mit gesperrten konto und kst 
	Given I open an editor "Buchung" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
	And I set field "such" to "sperrbu2"
	And I set field "budat" to "20.02.2002"
	And I set field "beleg" to "sperrbu2"
	And I create a new row at the end of the table
	And I set field "konto" to "99900" in row !lastRow
	And I set field "sbetrag" to "3" in row !lastRow
	And I create a new row at the end of the table
	And I set field "konto" to "99800" in row !lastRow
	And I set field "kstelle" to "211" in row !lastRow
	And I respond with answer "Ja" to the dialog with id "583"
	And I save the current editor
