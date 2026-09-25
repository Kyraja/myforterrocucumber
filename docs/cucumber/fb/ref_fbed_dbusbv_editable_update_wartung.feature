 @persistant
Feature: Editability of Fields new entries
Background:
Given I'm logged in with password "annette"
Given I set the fake date to "2.2.2002"

Scenario: editable_new_entry_fields_general

    Given I open an editor "BuchungC" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "NEW" for record ""
     And I set field "such" to "K4" 
    And I set field "budat" to "02.02.2002"
  	And I create a new row at the end of the table
    And I set field "konto" to "99800" in row 1
    And I set field "kstelle" to "100" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "99900" in row 2
    And I set field "hbetrag" to "100" in row 2
    And I set field "kstelle" to "100" in row 2
    And I respond with answer "Ja" to the dialog with id "7709"
    And I save the current editor
    
 Given I open an editor "Buchung1" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "UPDATE" for record "K4"
    Then field "nummer" is modifiable
    Then field "such" is modifiable
    Then field "text" is modifiable
    Then field "kenn" is modifiable
    Then field "beleg" is modifiable
    Then field "beldat" is modifiable
    Then field "budat" is modifiable
    Then field "monat" is modifiable
    Then field "periode" is not modifiable
    Then field "gjahr" is not modifiable
    Then field "ursache" is not modifiable
    Then field "ursacheref" is not modifiable
    Then field "stornoobjekt" is not modifiable
    Then field "stornovorlobjekt" is not modifiable
    And I close the current editor
    
Scenario: editable_update_w_entry_fields_currency    
 Given I open an editor "Buchung2" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "UPDATE" for record "K4"
    Then field "iwbu" is not modifiable
    And I close the current editor
    
        
Scenario: editable_update_w_entry_fields_action
    Given I open an editor "Buchung4" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "UPDATE" for record "K4"
    Then field "storno" is modifiable
    Then field "ktausch" is modifiable
    Then field "bubelnw" is not modifiable
    Then field "summe" is modifiable    
    And I close the current editor
        
Scenario: editable_update_w_entry_fields_set_of_books
    Given I open an editor "Buchung6" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "UPDATE" for record "K4" 
    Then field "inbukreis1" is modifiable
    Then field "bukreis1" is not modifiable
    Then field "inbunr1" is not modifiable
    Then field "exbunr1" is modifiable
    Then field "inbukreis2" is modifiable
    Then field "bukreis2" is not modifiable
    Then field "inbunr2" is not modifiable
    Then field "exbunr2" is modifiable
    Then field "inbukreis3" is modifiable
    Then field "bukreis3" is not modifiable
    Then field "inbunr3" is not modifiable
    Then field "exbunr3" is modifiable
    Then field "inbukreis4" is modifiable
    Then field "bukreis4" is not modifiable
    Then field "inbunr4" is not modifiable
    Then field "exbunr4" is modifiable
    Then field "inbukreis5" is modifiable
    Then field "bukreis5" is not modifiable
    Then field "inbunr5" is not modifiable
    Then field "exbunr5" is modifiable
    
Scenario: editable_update_w_entry_fields_row_general
    Given I open an editor "Buchung7" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "UPDATE" for record "K4" 
    Then field "konto" is modifiable in row 1
    Then field "soll" is not modifiable in row 1
    Then field "sbetrag" is modifiable in row 1
    Then field "hbetrag" is modifiable in row 1
    Then field "fertig" is not modifiable in row 1
    Then field "ptext" is modifiable in row 1
    Then field "saldo" is modifiable in row 1
    Then field "anlage" is not modifiable in row 1
    Then field "mge" is modifiable in row 1
    Then field "einheit" is modifiable in row 1
    Then field "me" is modifiable in row 1
    Then field "gegen1" is modifiable in row 1
    Then field "gegen2" is modifiable in row 1
    Then field "gegen3" is modifiable in row 1
    Then field "gegen4" is modifiable in row 1
    Then field "gegen5" is modifiable in row 1
    Then field "gegen" is not modifiable in row 1  
    Then field "gegenfix" is modifiable in row 1  
             
    Then field "sbetrag" is modifiable in row 1
    Then field "hbetrag" is modifiable in row 1

    And I close the current editor

Scenario: editable_update_w_entry_fields_row_statistical
    Given I open an editor "Buchung8" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "UPDATE" for record "K4" 
    Then field "pfixbetr" is not modifiable in row 1
    Then field "ppropbetr" is not modifiable in row 1
    Then field "psfixbetr" is not modifiable in row 1
    Then field "pspropbetr" is not modifiable in row 1
    Then field "phfixbetr" is not modifiable in row 1
    Then field "phpropbetr" is not modifiable in row 1
    And I close the current editor
    
#    
