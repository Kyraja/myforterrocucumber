 @persistant
Feature: Editability of Fields new entries
Background:
Given I set the fake date to "2.2.2002"

Scenario: editable_new_entry_fields_general
 
 Given I open an editor "Buchung1" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
    Then field "nummer" is not modifiable
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

    Then field "vorlaeu" is not modifiable
    Then field "vkzart" is not modifiable 
    
    And I close the current editor
    
Scenario: editable_new_entry_fields_currency    
 Given I open an editor "Buchung2" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
    Then field "iwbu" is not modifiable
    And I close the current editor
    
        
Scenario: editable_new_entry_fields_action
    Given I open an editor "Buchung4" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
    Then field "storno" is modifiable
    Then field "ktausch" is modifiable
    Then field "bubelnw" is not modifiable
    Then field "summe" is modifiable    
    And I close the current editor
    
        
Scenario: editable_new_entry_fields_set_of_books
    Given I open an editor "Buchung6" from table "(Entry):(StatisticalEntry)" with command "NEW" for record "" 
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
    Then field "inbukreis4" is not modifiable
    Then field "bukreis4" is not modifiable
    Then field "inbunr4" is not modifiable
    Then field "exbunr4" is not modifiable
    Then field "inbukreis5" is not modifiable
    Then field "bukreis5" is not modifiable
    Then field "inbunr5" is not modifiable
    Then field "exbunr5" is not modifiable
    
Scenario: editable_new_entry_fields_row_general
    Given I open an editor "Buchung7" from table "(Entry):(StatisticalEntry)" with command "NEW" for record "" 
    
    And I create a new row at the end of the table
    Then field "konto" is modifiable in row 1
    Then field "soll" is not modifiable in row 1
    Then field "sbetrag" is not modifiable in row 1
    Then field "hbetrag" is not modifiable in row 1
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
             
    And I set field "konto" to "99800" in row 1
    Then field "sbetrag" is modifiable in row 1
    Then field "hbetrag" is modifiable in row 1
    And I close the current editor
  
Scenario: editable_new_entry_fields_row_statistical
    Given I open an editor "Buchung8" from table "(Entry):(StatisticalEntry)" with command "NEW" for record "" 
    And I create a new row at the end of the table
    And I set field "konto" to "99800" in row 1
    Then field "pfixbetr" is not modifiable in row 1
    Then field "ppropbetr" is not modifiable in row 1
    Then field "phfixbetr" is not modifiable in row 1
    Then field "phpropbetr" is not modifiable in row 1
    And I close the current editor

Scenario: editable_new_entry_fields_controlling
    Given I open an editor "Buchung14" from table "(Entry):(StatisticalEntry)" with command "NEW" for record "" 
    And I create a new row at the end of the table
    Then field "kstelle" is not modifiable in row 1
    Then field "projekt" is modifiable in row 1    
    Then field "kvalt" is not modifiable in row 1  
    Then field "vert" is not modifiable in row 1  
    Then field "koart" is not modifiable in row 1  
    Then field "koretyp" is not modifiable in row 1  
    And I set field "konto" to "99800" in row 1
    And I set field "sbetrag" to "100" in row 1
    Then field "kstelle" is modifiable in row 1
    Then field "projekt" is modifiable in row 1    
    Then field "kvalt" is not modifiable in row 1  
    Then field "vert" is modifiable in row 1  
    Then field "koart" is not modifiable in row 1  
    Then field "koretyp" is not modifiable in row 1
    And I close the current editor  

Scenario: editable_new_entry_fields_row_asset
    Given I open an editor "Buchung15" from table "(Entry):(StatisticalEntry)" with command "NEW" for record "" 
    And I create a new row at the end of the table
    Then field "anlage" is not modifiable in row 1 
    And I set field "kenn" to "ZU"
    Then field "anlage" is modifiable in row 1 
    And I close the current editor 

#    
