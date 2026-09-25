#  Autor            : gk
#  Verantwortlich   : uo
#  Kontrolle        :
#  Funktion         :

@persistant
Feature: Validation of general Fields
Background:
Given I set the fake date to "2.2.2002"

Scenario: validate_field_bukenn
    Given I open an editor "Buchung1" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    And setting field "kenn" to "XY" throws the exception "1336"
    And I set field "kenn" to ""
    Then field "kenn" has value "DI"
    And I close the current editor
    
Scenario: validate_field_bubudat_sy
    Given I open an editor "Buchung2" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    And setting field "budat" to "" throws the exception "316"
    And setting field "budat" to "1.1.99" throws the exception "1294"
    And setting field "budat" to "1.1.00" throws the exception "2202"
    And I close the current editor
    
Scenario: validate_field_bubudat_wartung    
    Given I'm logged in with password "annette"
    Given I open an editor "Buchung3" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "UPDATE" for record "BBU01"
    And setting field "budat" to "1.1.99" throws the exception "106"
    And I set field "budat" to "1.1.00"
    And I close the current editor
    
Scenario: validate_field_bumonat_sy    
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung4" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""  
    And setting field "monat" to "-1" throws the exception "131"
    And setting field "monat" to "16" throws the exception "1361"
    And setting field "monat" to "1" throws the exception "1361"
    And I close the current editor
    Given I open an editor "Buchung5" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "UPDATE" for record "BBU01"
    And setting field "monat" to "-1" throws the exception "131"
    And setting field "monat" to "16" throws the exception "1361"
    And setting field "monat" to "1" throws the exception "1361"
    And I close the current editor
    Given I open an editor "Buchung6" from table "(RecurringEntry):" with command "NEW" for record "1"
    And setting field "monat" to "4" throws the exception "5010"
    And I close the current editor    
    
Scenario: validate_field_buewbu    
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung7" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""  
    And setting field "ewbu" to "" throws the exception "185"
    And I close the current editor  
      
Scenario: validate_field_buewekurs   
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung8" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""  
    And I set field "ewbu" to "USD"
    And I set field "ewekurs" to "0.0"
    Then field "ewekurs" has value "1.123800"
    And I close the current editor  
            
Scenario: validate_field_buewekurs   
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung9" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""  
    And I set field "ewbu" to "USD"
    And I set field "eikurs" to "0.0"
    Then field "eikurs" has value "1.123800"
    And I close the current editor  
    Given I open an editor "Buchung9" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""  
    And I set field "ewbu" to "USD"
    And I set field "eikurs" to "1.1"
    Then field "kursfix" has value "ja"
    And I close the current editor  
    
Scenario: validate_field_bukprojekt 
    Given I'm logged in with password "sy"
    Given I open an editor "Buchung10" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""  
    And setting field "kprojekt" to "100000" throws the exception "1361"
    And I close the current editor  
    
Scenario: validate_field_bukonto
	Given I open an editor "Buchung11" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
	And I create a new row at the end of the table
    And setting field "konto" to "99800" in row 1 throws the exception "99800: Statistische Kostenrechnungs-Konten nicht erlaubt"
    And I close the current editor  
    Given I open an editor "Buchung11" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    And I set field "budat" to "31.12.01" 
    And I set field "monat" to "15" 
	And I create a new row at the end of the table
    And setting field "konto" to "K 1" in row 1 throws the exception "264"
    And setting field "konto" to "M 1" in row 1 throws the exception "264"
    And I close the current editor  
    	
Scenario: validate_field_bukstelle
	Given I open an editor "Buchung12" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
	And I set field "such" to "dbkv"
	And I create a new row at the end of the table
	And I set field "konto" to "54000" in row 1
	And I set field "ewsbetr" to "123,96" in row 1
	And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
	And I create a new row at the end of the table
	And I set field "kstelle" to "100" in row 1
	And I set field "proz" to "10" in row 1
	And I create a new row at the end of the table
	And I set field "kstelle" to "101" in row 2
	And I set field "proz" to "90" in row 2
	And I save the current subeditor to switch back to the parent editor
	And I create a new row at the end of the table
	And I set field "konto" to "11400" in row 2
 	And I respond with answer "Ja" to the dialog with id "7709"
	And I save the current editor
	And I close the current editor

	Given I open an editor "Buchung13" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
	And I create a new row at the end of the table
	And I set field "konto" to "54000" in row 1
	# muss den passenden dyn. kostenverteiler finden (auch in 2 weiterteren std/test/cucumber/fb/ref_fbed_*_validate_field.feature)
	And setting field "kstelle" to "$,,ozeilen==2;1:kstelle==100;1:proz==10;1:betr=12.39!12.41;@maxtreffer=1;@datenbank=5;@group=9" in row 1 throws the exception "7705" 
	And I close the current editor  
    
	Given I open an editor "Buchung14" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "UPDATE" for record "DBKV"
	And I respond with answer "ja" to the dialog with id "1482"
	And I set field "kstelle" to "100" in row 1
	And I close the current editor
    
#
