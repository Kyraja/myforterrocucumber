@persistant
Feature: Validation of general Fields
Background:
Given I set the fake date to "2.2.2002"


# Ein Buchungkreis muß gesetzt sein
Scenario: validate_record_bubukreis
    Given I open an editor "Buchung1" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    And I set field "inbukreis1" to "nein"
    And I set field "inbukreis2" to "nein" 
    And I set field "inbukreis3" to "nein" 
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "100" in row 2
    Then saving the current editor throws the exception "5933"
    And I close the current editor

# Belegdatum muß gesetzt sein
Scenario: validate_record_beldat2    
	Given I'm logged in with password "annette"
	Given I set the fake date to "2.2.2002"
    Given I open an editor "Buchung3" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    And I set field "butyp" to "Eröffnungsbuchung"
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "M  1" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "butyp" to "Allgemeine Finanzbuchung"
    Then saving the current editor throws the exception "269"
    And I close the current editor

# Personenkontobuchungen mit zaart Sonstige Forderungen/Verbindlichkeiten
Scenario: validate_record_zaart
    Given I open an editor "Buchung4" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    And I set field "beleg" to "X1"
    And I set field "zaart" to "Sonstige Forderungen/Verbindlichkeiten"
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "100" in row 2
    And I set field "beldat" to ""
    Then saving the current editor throws the exception "1357"
    And I close the current editor
    
# buklm sollte in der Buchungszeile vorhanden sein => falsche Fehlermeldung
Scenario: validate_record_buklm1  
	Given I'm logged in with password "annette"
	Given I set the fake date to "2.2.2002"
    Given I open an editor "Buchung5" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    And I set field "butyp" to "Eröffnungsbuchung"
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "M  1" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "klm" to "M 1"
    Then saving the current editor throws the exception "10391"
    And I close the current editor
    
# Eröffnungsbuchung zum späteren Kopieren anlegen, dann mit sys editieren 
Scenario: validate_record_bubutyp  
	Given I'm logged in with password "annette"
	Given I set the fake date to "2.2.2002"
    Given I open an editor "Buchung5" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    And I set field "such" to "EROEFF1"
    And I set field "butyp" to "Eröffnungsbuchung"
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "M  1" in row 2
    And I set field "ewhbetr" to "100" in row 2
 	And I respond with answer "ja" to the dialog with id "7709"
    And I save the current editor
    And I close the current editor
	Given I'm logged in with password "sy"
	Given I set the fake date to "2.2.2002"
    Given I open an editor "Buchung6" from table "(RecurringEntry)" with command "COPY" for record "EROEFF1"
    Then saving the current editor throws the exception "8324"
    And I close the current editor

#
