@persistant
Feature: Validation of general Fields
Background:
Given I set the fake date to "2.2.2002"


# Buttons druecken
Scenario: press_button
    Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I set field "such" to "BUTTON1"
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "100" in row 2
    And I press button "storno"
    Then field "ewhbetr" has value "-100.00" in row 2
    And I press button "storno"
    Then field "ewhbetr" has value "100.00" in row 2
    And I press button "ktausch"
    Then field "sbetrag" has value "100.00" in row 2
    Then field "hbetrag" has value "0.00" in row 2
    And I press button "ktausch"
    Then field "sbetrag" has value "0.00" in row 2
    Then field "hbetrag" has value "100.00" in row 2
    And I press button "knetto"
    Then field "sbetrag" has value "0.00" in row 2
    Then field "hbetrag" has value "86.21" in row 2
    And I press button "ksteuer"
    Then field "sbetrag" has value "100.00" in row 1
    Then field "hbetrag" has value "86.21" in row 2
    Then field "hbetrag" has value "13.79" in row 3
    And I press button "summe"
    Then message "Soll: 100,00 EUR   Haben: 100,00 EUR   Saldo: 0,00 EUR" was displayed
    And I press button "saldo" in row 1
    Then message "Saldo: 100,00 EUR 1 TEST Testkunde" was displayed
    And I press button "znetto" in row 2
    Then field "hbetrag" has value "100.00" in row 2
    And I press button "znetto" in row 2
    Then field "hbetrag" has value "86.21" in row 2
  	And I respond with answer "ja" to the dialog with id "1941"
    And I save the current editor
    And I close the current editor

#
