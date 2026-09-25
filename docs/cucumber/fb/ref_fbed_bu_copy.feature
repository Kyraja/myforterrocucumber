@persistant
Feature: Copying financial entries and financial entry templates
Background:
Given I set the fake date to "2.2.2002"

Scenario: create_financial_entry
    Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record "" 
  	And I set field "such" to "CP1BU"  
  	And I create a new row at the end of the table
    And I set field "konto" to "18100" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "16000" in row 2
    And I set field "hbetrag" to "100" in row 2
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor
    And I close the current editor
    
Scenario: copy_financial_entry_to_template
    Given I open an editor "Buchung2" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "COPY" for record "CP1BU"
    And I set field "such" to "CP1TMP" 
    And I respond with answer "Ja" to the dialog with id "7709"
    And I save the current editor
    And I close the current editor  

Scenario: copy_template_to_financial_entry
    Given I open an editor "Buchung3" from table "(Entry):(Entry)" with command "COPY" for record "110 CP1TMP"
    And I respond with answer "Ja" to the dialog with id "583"
    And I save the current editor
    And I close the current editor  
    
Scenario: copy_financial_entry_without_bukonto
    Given I open an editor "Buchung3" from table "(Entry):(Entry)" with command "COPY" for record "BBU03"
    And I set field "such" to "CP3"
    And I set field "budat" to "7.2.02"
    Then saving the current editor throws the exception "10179"
    And I set field "konto" to "54000" in row 1
    And I set field "kstelle" to "100" in row 1
    And I respond with answer "Ja" to the dialog with id "583"
    And I save the current editor
    And I close the current editor 
#End
