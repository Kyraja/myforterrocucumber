# *****************************************************************************
#  Name           : fibuedit_kosperre.feature
#  Autor          : Gisela Koehne
#  Verantwortlich : uo
#  Kontrolle      : hc
#  Funktion       : Editieren der Finanzbuchungsmaske
# *****************************************************************************
@persistent
Feature: REWE-2464
Background:
Given I set the fake date to "31.12.2002"

Scenario: Setzen Kontosperre
	Given I open an editor "Konto_001" from table "(Account):(Account)" with command "NEW" for record "18100"
	And I set field "nummer" to "001_S"
	And I set field "such" to "S_001X"
	And I set field "namebspr" to "S_001X"
	And I set field "kenn" to "XS"
	And I save the current editor
	And I close the current editor
	
    Given I open an editor "Kunde_001" from table "(Customer):(Customer)" with command "NEW" for record "1"
	And I set field "nummer" to "010_S"
	And I set field "such" to "K_010X"
	And I set field "namebspr" to "K_010"
	And I set field "kenn" to "S"
	And I save the current editor
	And I close the current editor
	
    Given I open an editor "Mitarbeiter_001" from table "(Employee):(Employee)" with command "NEW" for record "1"
	And I set field "nummer" to "010_M"
	And I set field "such" to "M_010X"
	And I set field "namebspr" to "M_010"
	And I set field "kenn" to "S"
	And I save the current editor
	And I close the current editor
	
	
   Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
	And I create a new row at the end of the table
    And I set field "konto" to "K K_010X" in row 1
    Then message "----  G E S P E R R T ----" was displayed
    And I create a new row at the end of the table
    And I set field "konto" to "001_S" in row 2
    Then message "----  G E S P E R R T ----" was displayed
    And I set field "konto" to "M 010_M" in row 1
    Then message "----  G E S P E R R T ----" was displayed
    And I set field "ewhbetr" to "100" in row 2
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor
    
#
