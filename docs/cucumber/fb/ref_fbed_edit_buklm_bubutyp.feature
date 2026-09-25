@persistant
Feature: Edit buklm, bubutyp für REWE-3047
Background:
Given I set the fake date to "2.2.2002"

# Personenkonto mit Währung CHF anelgen
Scenario: create_customer_chf
	Given I'm logged in with password "sy"
	Given I set the fake date to "2.2.2002"
    Given I open an editor "Kunde1" from table "(Customer):(Customer)" with command "COPY" for record "001"
    And I set field "nummer" to "011"
    And I set field "land" to "CHF"
    And I save the current editor
    And I close the current editor
    
# Personenkonten mit unterschiedlichen Währungen
Scenario: edit_entry_without_values
	Given I'm logged in with password "sy"
	Given I set the fake date to "2.2.2002"
    Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
    Then field "ewbu" has value "EUR"
    And I create a new row at the end of the table
# Bei Buchungstyp "Allgemeine Finanzbuchung" wird ewbu nicht in Abhängkgeit von buklm gesetzt
    And I set field "klm" to "K 011"
    Then field "ewbu" has value "EUR"
    And I set field "konto" to "" in row 1
    Then field "klm" has value ""
# Bei Buchungstyp "Rechnungsbuchung" wird ewbu in Abhängkgeit von buklm gesetzt
    And I set field "butyp" to "Rechnungsbuchung"
    And I set field "klm" to "K 011"
    Then field "ewbu" has value "CHF"
    And I set field "klm" to "K 006"
    Then field "ewbu" has value "USD"
# Beim Leeren des Personenkontos wird die Währung auf EUR zurückgesetzt
    And I set field "konto" to "" in row 1
    Then field "klm" has value ""
    Then field "ewbu" has value "EUR"
#  Setzen des Personekontos in der Zeile hat dieselbe Wirkung
    And I set field "konto" to "K 011" in row 1
    Then field "klm" has value "K 011"
    Then field "ewbu" has value "CHF"
    And I close the current editor
#
# Buchung mit Werten
Scenario: edit_entry_with_values
	Given I'm logged in with password "sy"
	Given I set the fake date to "2.2.2002"
    Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
    Then field "ewbu" has value "EUR"
    And I create a new row at the end of the table
# Bei Buchungstyp "Allgemeine Finanzbuchung" wird ewbu nicht in Abhängkgeit von buklm gesetzt
    And I set field "klm" to "K 011"
    Then field "ewbu" has value "EUR"
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "hbetrag" to "100" in row 2
    And I set field "konto" to "" in row 1
    Then field "klm" has value ""
# Bei Buchungstyp "Rechnungsbuchung" wird ewbu in Abhängkgeit von buklm gesetz
    And I set field "butyp" to "Rechnungsbuchung"
    And I set field "klm" to "K 011"
    Then field "ewbu" has value "CHF"
    And I set field "klm" to "K 006"
    Then field "ewbu" has value "USD"
#  Setzen des Personekontos in der Zeile hat dieselbe Wirkung
    And I set field "konto" to "K 011" in row 1
    Then field "klm" has value "K 011"
    Then field "ewbu" has value "CHF"
    And I close the current editor
