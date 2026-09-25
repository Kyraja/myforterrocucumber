# Verantwortlich: uo

@persistant
Feature: Editieren einer Buchung mit Fremdwährung, diese muss als Erfassungswährung erhalten bleiben REWE-3934
Background:
Given I set the fake date to "02.01.2003"

    
Scenario: Änderungen in allgemeiner Finanzbuchung mit Fremdwährung als Erfasswährung

    Given I'm logged in with password "sy"
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    
    And I set field "beleg" to "Kunde1" in row 0
    Then field "butyp" has value "Allgemeine Finanzbuchung" in row 0
    And I set field "erfwaehr" to "CAD" in row 0

  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    Then field "butyp" has value "Allgemeine Finanzbuchung"

    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "632.53" in row 2

    Then field "erfwaehr" has value "CAD"
    Then field "butyp" has value "Allgemeine Finanzbuchung"

	# Personenkonto (klm) ändern
    And I set field "konto" to "K MUELL" in row 1
    Then field "erfwaehr" has value "CAD"
    Then field "butyp" has value "Allgemeine Finanzbuchung"
    
    Then the table has 2 rows
    # eine Zeile löschen
    And I delete row at position 1
    Then field "erfwaehr" has value "CAD"
    Then field "butyp" has value "Allgemeine Finanzbuchung"
    Then field "ewhbetr" has value "632.53" in row 1
    Then the table has 1 rows
    And I close the current editor
