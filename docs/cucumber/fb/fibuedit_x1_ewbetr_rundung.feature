@persistant
Feature: Editieren einer Buchung bei einer Waehrung mit 0 Nachkommsastellen
Background:
Given I set the fake date to "02.01.2003"

Scenario: Nachkommastellen in Waehrung Aendern 
    Given I'm logged in with password "annette"
    Given I open an editor "Currency" from table "(Currency):(Currency)" with command "UPDATE" for record "DKK"
    And I set field "nkst" to "0" in row 0
    And I save the current editor
    And I close the current editor
    
Scenario: Buchung_mit_Waehrung_ohne_nkst
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I set field "beleg" to "DKK1" in row 0
    And I set field "ewbu" to "DKK" in row 0
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "632.53" in row 2
    Then field "ewhbetr" has value "633.00" in row 2
    And I set field "kstelle" to "100" in row 2
    And I respond with answer "Ja" to the dialog with id "583"
    And I save the current editor
    And I close the current editor

    Scenario: Buchung_mit_Waehrung_ohne_nkst
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I set field "beleg" to "DKK1" in row 0
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "632.53" in row 2
    Then field "ewhbetr" has value "632.53" in row 2
    And I set field "kstelle" to "100" in row 2
    And I set field "ewbu" to "DKK" in row 0
    Then field "ewhbetr" has value "633.00" in row 2
    And I respond with answer "Ja" to the dialog with id "583"
    And I save the current editor
    And I close the current editor
