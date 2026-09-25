@persistant
Feature: Validation of general Fields
Background:
Given I set the fake date to "2.2.2002"


# Ein Buchungkreis muß gesetzt sein
Scenario: validate_record_bubukreis
    Given I open an editor "Buchung1" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
    And I set field "inbukreis1" to "nein"
    And I set field "inbukreis2" to "nein" 
    And I set field "inbukreis3" to "nein" 
  	And I create a new row at the end of the table
    And I set field "konto" to "99900" in row 1
    And I set field "kstelle" to "100" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "99800" in row 2
    And I set field "hbetrag" to "100" in row 2
    And I set field "kstelle" to "100" in row 2
    Then saving the current editor throws the exception "5933"
    And I close the current editor

# Belegdatum muß gesetzt sein, wird aber automatisch aus dem Buchngsdatum gesetzt
Scenario: validate_record_beldat
    Given I open an editor "Buchung2" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
    And I set field "beleg" to "X1"
  	And I create a new row at the end of the table
    And I set field "konto" to "99900" in row 1
    And I set field "kstelle" to "100" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "99800" in row 2
    And I set field "hbetrag" to "100" in row 2
    And I set field "kstelle" to "100" in row 2
    And I set field "beldat" to ""
    And I respond with answer "Ja" to the dialog with id "583"
    And I save the current editor
    And I close the current editor

# Buchung muß Zeilen enthalten
Scenario: validate_record_zeilen1
    Given I open an editor "Buchung2" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
    And I set field "beleg" to "X1"
    Then saving the current editor throws the exception "2106"
    And I close the current editor

# Buchung muß Eintr�ge in den Zeilen enthalten
Scenario: validate_record_zeilen2
    Given I open an editor "Buchung2" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
    And I set field "beleg" to "X1"
    And I create a new row at the end of the table
    Then saving the current editor throws the exception "2106"
    And I close the current editor
    
# Buchung muß Konten in den Zeilen enthalten
Scenario: validate_record_zeilen3
    Given I open an editor "Buchung2" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
    And I set field "beleg" to "X1"
    And I create a new row at the end of the table
    And I set field "konto" to "99900" in row 1
    And I set field "hbetrag" to "100" in row 1
	And I set field "konto" to "" in row 1
    Then saving the current editor throws the exception "2106"
    And I close the current editor
    
# Buchung muß Betr�ge enthalten
Scenario: validate_record_zeilen_betraege
    Given I open an editor "Buchung2" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
    And I set field "beleg" to "X1"
    And I create a new row at the end of the table
    And I set field "konto" to "99900" in row 1
    And I set field "kstelle" to "100" in row 1  
    Then saving the current editor throws the exception "2106"
    And I close the current editor    

# Buchung muß Betr�ge enthalten
Scenario: validate_record_zeilen_betraege
    Given I open an editor "Buchung2" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
    And I set field "beleg" to "X1"
    And I create a new row at the end of the table
    And I set field "konto" to "99900" in row 1
    And I set field "kstelle" to "100" in row 1  
    And I set field "hbetrag" to "100" in row 1  
    And I create a new row at the end of the table
    Then saving the current editor throws the exception "2197"
    And I close the current editor    
#
