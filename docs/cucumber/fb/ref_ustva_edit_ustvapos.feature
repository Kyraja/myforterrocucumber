@persistant

Feature: Editing VAT_Position

Background:
Given I set the fake date to "02.01.2002"

Scenario: Create_VAT_Item
    Given I open an editor "VAT item1" from table "(Evaluation):(ItemNumber)" with command "NEW" for record ""
    And I set field "nummer" to "9881"
    And I set field "such" to "K5P81" 
    Then field "meldungsnr" has value "9881"
    And I set field "postyp" to "Kontrolle"
    Then field "meldungsnr" has value ""
    Then field "meldungsnr" is not modifiable
    And I set field "ev" to "Verkauf"
    And I set field "hatsteuer" to "Ja"
    And I create a new row at the end of the table
    And I set field "sts" to "STS1" in row 1
    And I save the current editor
    And I close the current editor
        
    Given I open an editor "VAT item2" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "9881"
    And I set field "postyp" to "Mwst-Bemessung"
    Then field "meldungsnr" has value ""
    Then field "meldungsnr" is modifiable
    Then saving the current editor throws the exception "279"
    And I set field "meldungsnr" to "98"
    And I save the current editor
    And I close the current editor

    Given I open an editor "VAT item3" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "51"
    And I set field "meldungsnr" to "51_meld"
    And I save the current editor
    And I close the current editor
    
    Given I open an editor "VAT item4" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "36"
    And I set field "meldungsnr" to "36_meld"
    And I save the current editor
    And I close the current editor
    
    Given I open an editor "VAT item1" from table "(Evaluation):(ItemNumber)" with command "NEW" for record ""
    And I set field "nummer" to "100"
    And I set field "such" to "K100" 
    Then field "meldungsnr" has value "100"
    And I set field "nummer" to "101"
    Then field "meldungsnr" has value "101"
    And I set field "meldungsnr" to "101m"
    And I set field "nummer" to "102"
    Then field "meldungsnr" has value "101m"
    And I set field "postyp" to "Mwst-Bemessung"
    And I set field "ev" to "Verkauf"
    And I set field "hatsteuer" to "Ja"
    And I create a new row at the end of the table
    And I set field "sts" to "STS1" in row 1
    And I save the current editor
    And I close the current editor
    
    Given I open an editor "VAT item1" from table "(Evaluation):(ItemNumber)" with command "NEW" for record ""
    And I set field "postyp" to "Kontrolle"
    And I set field "nummer" to "9882"
    Then field "meldungsnr" has value ""
    Then field "meldungsnr" is not modifiable
    And I set field "ev" to "Verkauf"
    And I save the current editor
    And I close the current editor
#    
