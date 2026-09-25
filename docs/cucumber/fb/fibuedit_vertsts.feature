@persistant
Feature: Edit of lines in a posting with distribution tax key
Background:
Given I set the fake date to "02.01.2003"

# Manuelle Buchungen: Gegenkonto bei einer Personenkontenbuchung
Scenario: Buchung_mit_Verteilsteuerschluessel 
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "632.53" in row 2
    And I set field "kstelle" to "100" in row 2
    And I set field "strgl" to "VKINLVERT" in row 2
    And I press button "ksteuer"
    And I create a new row at the end of the table
    And I set field "konto" to "48420" in row 4
    And I set field "ewhbetr" to "0.01" in row 4
    And I create a new row at the end of the table
    And I set field "konto" to "68820" in row 5
    And I set field "ewsbetr" to "0.01" in row 5
    And I set field "beleg" to "VERTSTS1" 
    And I respond with answer "Ja" to the dialog with id "583"
    And I save the current editor


