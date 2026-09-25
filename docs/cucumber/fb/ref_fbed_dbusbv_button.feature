@persistant
Feature: Validation of general Fields
Background:
Given I set the fake date to "2.2.2002"


# Buttons dr�cken
Scenario: press_button
    Given I open an editor "Buchung1" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
  	And I create a new row at the end of the table
    And I set field "konto" to "99900" in row 1
    And I set field "kstelle" to "100" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "99800" in row 2
    And I set field "hbetrag" to "100" in row 2
    And I set field "kstelle" to "100" in row 2
    And I press button "storno"
    Then field "hbetrag" has value "-100.00" in row 2
    And I press button "storno"
    Then field "hbetrag" has value "100.00" in row 2
    And I press button "ktausch"
    Then field "sbetrag" has value "100.00" in row 2
    Then field "hbetrag" has value "0.00" in row 2
    And I press button "ktausch"
    Then field "sbetrag" has value "0.00" in row 2
    Then field "hbetrag" has value "100.00" in row 2
    And I press button "summe"
    Then message "Soll: 0,00 EUR   Haben: 100,00 EUR   Saldo: -100,00 EUR" was displayed
    And I press button "saldo" in row 1
    Then message "Saldo: 200,00 EUR 99900 KOSTENRECHNUNG s" was displayed
  	And I respond with answer "ja" to the dialog with id "1941"
    And I save the current editor
    And I close the current editor

#
