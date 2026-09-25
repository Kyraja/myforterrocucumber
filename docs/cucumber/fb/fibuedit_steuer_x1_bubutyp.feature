@persistant
Feature: Editieren einer Buchung, Verhalten beim Aendern des Feldes bubutyp
Background:
Given I set the fake date to "02.01.2003"
    
Scenario: Buchung_anlegen
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    Then field "butyp" has value "Allgemeine Finanzbuchung"
    Then field "kenn" has value "DI"
  	And I create a new row at the end of the table
    And I set field "konto" to "K 1" in row 1
    Then field "klm" has value "K 1"
    Then field "ustid" has value "DE-USTID111"
#    
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    Then field "strgl" has value "VKINREGEL" in row 2
#
    And I set field "ewhbetr" to "632.53" in row 2
    And I set field "kstelle" to "100" in row 2
#
    And I set field "butyp" to "Rechnungsbuchung"
#
    Then field "kenn" has value "VK"
    Then field "vrgstrgl" has value "VKINL"
#
    And I set field "butyp" to "Bruttokonten-Abschlussbuchung"    
    Then field "klm" has value ""
    Then field "kenn" has value "DI"
    Then field "vrgstrgl" has value ""
#
    And I set field "butyp" to "Rechnungsbuchung"    
    And I set field "klm" to "K 1"
    Then field "kenn" has value "VK"
    Then field "vrgstrgl" has value "VKINL"
#
    And I set field "butyp" to "Eroeffnungsbuchung"    
    Then field "klm" has value "K 1"
    Then field "kenn" has value "DI"
    Then field "vrgstrgl" has value ""
#
    And I set field "butyp" to "Rechnungsbuchung"    
    Then field "kenn" has value "VK"
    Then field "vrgstrgl" has value "VKINL"
#
    And I set field "butyp" to "Nicht steuerrelevante Buchung"    
    Then field "klm" has value "K 1"
    Then field "kenn" has value "DI"
    Then field "vrgstrgl" has value ""
#
    And I set field "butyp" to "Rechnungsbuchung"    
    Then field "kenn" has value "VK"
    Then field "vrgstrgl" has value "VKINL"
#
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor
    And I close the current editor
