@persistant
Feature: Validation on postings with assets
Background:
Given I set the fake date to "2.2.2002"


# Ein Journalkennzeichen, das kein Anlagenjournalkennzeichen ist, darf nur gesetzt werden, wenn keine Anlage in der Buchung ist
Scenario: validate_bukenn_anlbu
    Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record "32"
    And setting field "kenn" to "DI" throws the exception "4164"
    And I close the current editor
#
# Das Buchungsdatum darf nicht vor dem Anschafungsdatum der Anlage liegen
Scenario: validate_bukenn_anlbu
    Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record "12"
    And setting field "budat" to "31.1.00" throws the exception "8118"
    And I close the current editor
#
