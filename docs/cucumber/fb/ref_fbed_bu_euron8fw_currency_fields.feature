@persistant
Feature: Editing currency fields
Background:
Given I set the fake date to "2.2.1999"
Given I enable the flag 39

Scenario:  edit_field_bubudat
    Given I open an editor "BuchungC1" from table "(Entry):(Entry)" with command "NEW" for record ""  
    And I create a new row at the end of the table
    And I set field "konto" to "16000" in row 1
    And I set field "ewsbetr" to "100" in row 1
    Then field "iwbu" is modifiable
    Then field "iwbu" has value "DEM"
    Then field "ewbu" is modifiable
    Then field "ewbu" has value "DEM"
    Then field "ewekurs" is not modifiable
    Then field "ewekurs" has value "0.508031"
    Then field "ewkurs" is not modifiable
    Then field "ewkurs" has value "0.508031"
    Then field "eweinh" is not modifiable
    Then field "eweinh" has value "1"
    Then field "uw" is not modifiable    
    Then field "uw" has value "EUR"    
    Then field "iwkurs" is not modifiable
    Then field "iwkurs" has value "1.968384"
    Then field "iwekurs" is not modifiable
    Then field "iwekurs" has value "1.968384"
    Then field "eikurs" is not modifiable    
    Then field "eikurs" has value "1.000000"
    Then field "ieinh" is not modifiable    
    Then field "ieinh" has value "1"
    Then field "ewewu" is not modifiable    
    Then field "ewewu" has value "ja" 
    Then field "kursfix" is not modifiable
    Then field "kursfix" has value "nein" 
    Then field "ewsbetr" has value "100.00" in row 1
    Then field "sbetrag" has value "100.00" in row 1
    Then field "tiwbu" has value "DEM" in row 1
    Then field "tewbu" has value "DEM" in row 1
#
    And I set field "budat" to "01.01.00"
    Then field "iwbu" is not modifiable
    Then field "iwbu" has value "EUR"
    Then field "ewbu" is modifiable
    Then field "ewbu" has value "EUR"
    Then field "ewekurs" is not modifiable
    Then field "ewekurs" has value "1.000000"
    Then field "ewkurs" is not modifiable
    Then field "ewkurs" has value "1.000000"
    Then field "eweinh" is not modifiable
    Then field "eweinh" has value "1"
    Then field "uw" is not modifiable    
    Then field "uw" has value "EUR"    
    Then field "iwkurs" is not modifiable
    Then field "iwkurs" has value "1.000000"
    Then field "iwekurs" is not modifiable
    Then field "iwekurs" has value "1.000000"
    Then field "eikurs" is not modifiable    
    Then field "eikurs" has value "1.000000"
    Then field "ieinh" is not modifiable    
    Then field "ieinh" has value "1"
    Then field "ewewu" is not modifiable    
    Then field "ewewu" has value "nein" 
    Then field "kursfix" is not modifiable
    Then field "kursfix" has value "nein" 
    Then field "ewsbetr" has value "100.00" in row 1
    Then field "sbetrag" has value "100.00" in row 1
    Then field "tiwbu" has value "EUR" in row 1
    Then field "tewbu" has value "EUR" in row 1
    
    And I set field "budat" to "07.03.99"
    Then field "iwbu" is modifiable
    Then field "iwbu" has value "DEM"
    Then field "ewbu" is modifiable
    Then field "ewbu" has value "DEM"
    Then field "ewekurs" is not modifiable
    Then field "ewekurs" has value "0.508031"
    Then field "ewkurs" is not modifiable
    Then field "ewkurs" has value "0.508031"
    Then field "eweinh" is not modifiable
    Then field "eweinh" has value "1"
    Then field "uw" is not modifiable    
    Then field "uw" has value "EUR"    
    Then field "iwkurs" is not modifiable
    Then field "iwkurs" has value "1.968384"
    Then field "iwekurs" is not modifiable
    Then field "iwekurs" has value "1.968384"
    Then field "eikurs" is not modifiable    
    Then field "eikurs" has value "1.000000"
    Then field "ieinh" is not modifiable    
    Then field "ieinh" has value "1"
    Then field "ewewu" is not modifiable    
    Then field "ewewu" has value "ja" 
    Then field "kursfix" is not modifiable
    Then field "kursfix" has value "nein"   
    Then field "ewsbetr" has value "100.00" in row 1
    Then field "sbetrag" has value "100.00" in row 1
    Then field "tiwbu" has value "DEM" in row 1
    Then field "tewbu" has value "DEM" in row 1
      
    And I close the current editor  

Scenario:  edit_field_buiwbu
    Given I open an editor "BuchungC2" from table "(Entry):(Entry)" with command "NEW" for record ""  
    And I create a new row at the end of the table
    And I set field "konto" to "16000" in row 1
    And I set field "ewsbetr" to "100" in row 1
    And I set field "iwbu" to "EUR"
    Then field "iwbu" has value "EUR"
    Then field "ewbu" is modifiable
    Then field "ewbu" has value "DEM"
    Then field "ewekurs" is not modifiable
    Then field "ewekurs" has value "0.508031"
    Then field "ewkurs" is not modifiable
    Then field "ewkurs" has value "0.508031"
    Then field "eweinh" is not modifiable
    Then field "eweinh" has value "1"
    Then field "uw" is not modifiable    
    Then field "uw" has value "EUR"    
    Then field "iwkurs" is not modifiable
    Then field "iwkurs" has value "1.000000"
    Then field "iwekurs" is not modifiable
    Then field "iwekurs" has value "1.000000"
    Then field "eikurs" is not modifiable    
    Then field "eikurs" has value "0.508031"
    Then field "ieinh" is not modifiable    
    Then field "ieinh" has value "1"
    Then field "ewewu" is not modifiable    
    Then field "ewewu" has value "ja" 
    Then field "kursfix" is modifiable    
    Then field "ewsbetr" has value "100.00" in row 1
    Then field "sbetrag" has value "50.80" in row 1
# Eigentlich falsch, butiwbu wird bei der Änderung der Buchungswährung nicht aktualisiert => spielt aber nur in der Euroer�ffnung eine Rolle
# Korrigiert indem die Skipfelder nun per Skiplader gef�llt werden => nun ist es EUR
    Then field "tiwbu" has value "EUR" in row 1
    Then field "tewbu" has value "DEM" in row 1    
    
    And I set field "iwbu" to "DEM"
    Then field "ewbu" is modifiable
    Then field "ewbu" has value "DEM"
    Then field "ewekurs" is not modifiable
    Then field "ewekurs" has value "0.508031"
    Then field "ewkurs" is not modifiable
    Then field "ewkurs" has value "0.508031"
    Then field "eweinh" is not modifiable
    Then field "eweinh" has value "1"
    Then field "uw" is not modifiable    
    Then field "uw" has value "EUR"    
    Then field "iwkurs" is not modifiable
    Then field "iwkurs" has value "1.968384"
    Then field "iwekurs" is not modifiable
    Then field "iwekurs" has value "1.968384"
    Then field "eikurs" is not modifiable    
    Then field "eikurs" has value "1.000000"
    Then field "ieinh" is not modifiable    
    Then field "ieinh" has value "1"
    Then field "ewewu" is not modifiable    
    Then field "ewewu" has value "ja" 
    Then field "kursfix" is not modifiable
    Then field "kursfix" has value "nein"   
    
    Then field "ewsbetr" has value "100.00" in row 1
    Then field "sbetrag" has value "100.00" in row 1
    Then field "tiwbu" has value "DEM" in row 1
    Then field "tewbu" has value "DEM" in row 1  
    
    And setting field "iwbu" to "DKK" throws the exception "5668"
    And setting field "iwbu" to "" throws the exception "5668"
   
    And I close the current editor 
#
Scenario:  edit_field_buewbu
Given I open an editor "BuchungC3" from table "(Entry):(Entry)" with command "NEW" for record ""  
    And I create a new row at the end of the table
    And I set field "konto" to "16000" in row 1
    And I set field "ewsbetr" to "100" in row 1
    Then field "iwbu" has value "DEM"
    And I set field "ewbu" to "usd"
    Then field "ewbu" is modifiable
    Then field "ewbu" has value "USD"
    Then field "ewekurs" is modifiable
    Then field "ewekurs" has value "0.853492"
    Then field "ewkurs" is not modifiable
    Then field "ewkurs" has value "0.853492"
    Then field "eweinh" is not modifiable
    Then field "eweinh" has value "1"
    Then field "uw" is not modifiable    
    Then field "uw" has value "EUR"    
    Then field "iwkurs" is not modifiable
    Then field "iwkurs" has value "1.968384"
    Then field "iwekurs" is not modifiable
    Then field "iwekurs" has value "1.968384"
    Then field "eikurs" is not modifiable    
    Then field "eikurs" has value "1.680000"
    Then field "ieinh" is not modifiable    
    Then field "ieinh" has value "1"
    Then field "ewewu" is not modifiable    
    Then field "ewewu" has value "nein" 
    Then field "kursfix" is modifiable    
    Then field "kursfix" has value "nein"   
    Then field "ewsbetr" has value "100.00" in row 1
    Then field "sbetrag" has value "168.00" in row 1
    Then field "tiwbu" has value "DEM" in row 1
    Then field "tewbu" has value "USD" in row 1  
    
    And I close the current editor 
    
Given I open an editor "BuchungC4" from table "(Entry):(Entry)" with command "NEW" for record ""  
    And I create a new row at the end of the table
    And I set field "konto" to "16000" in row 1
    And I set field "ewsbetr" to "100000" in row 1
    Then field "iwbu" has value "DEM"
    And I set field "ewbu" to "TRL"
    Then field "ewbu" is modifiable
    Then field "ewbu" has value "TRL"
    Then field "ewekurs" is modifiable
    Then field "ewekurs" has value "0.003323"
    Then field "ewkurs" is not modifiable
    Then field "ewkurs" has value "0.000003"
    Then field "eweinh" is not modifiable
    Then field "eweinh" has value "1000"
    Then field "uw" is not modifiable    
    Then field "uw" has value "EUR"    
    Then field "iwkurs" is not modifiable
    Then field "iwkurs" has value "1.968384"
    Then field "iwekurs" is not modifiable
    Then field "iwekurs" has value "1.968384"
    Then field "eikurs" is not modifiable    
    Then field "eikurs" has value "0.000007"
    Then field "ieinh" is not modifiable    
    Then field "ieinh" has value "1"
    Then field "ewewu" is not modifiable    
    Then field "ewewu" has value "nein" 
    Then field "kursfix" is modifiable    
    Then field "kursfix" has value "nein"   
    Then field "ewsbetr" has value "100000.00" in row 1
    Then field "sbetrag" has value "0.65" in row 1
    Then field "tiwbu" has value "DEM" in row 1
    Then field "tewbu" has value "TRL" in row 1
    And I close the current editor     

#
Scenario:  edit_field_buewekurs
Given I open an editor "BuchungC5" from table "(Entry):(Entry)" with command "NEW" for record ""  
    And I create a new row at the end of the table
    And I set field "konto" to "16000" in row 1
    And I set field "ewsbetr" to "100" in row 1
    Then field "iwbu" has value "DEM"
    And I set field "ewbu" to "usd"
    And I set field "ewekurs" to "0.9"
    Then field "ewbu" is modifiable
    Then field "ewbu" has value "USD"
    Then field "ewekurs" is modifiable
    Then field "ewekurs" has value "0.900000"
    Then field "ewkurs" is not modifiable
    Then field "ewkurs" has value "0.900000"
    Then field "eweinh" is not modifiable
    Then field "eweinh" has value "1"
    Then field "uw" is not modifiable    
    Then field "uw" has value "EUR"    
    Then field "iwkurs" is not modifiable
    Then field "iwkurs" has value "1.968384"
    Then field "iwekurs" is not modifiable
    Then field "iwekurs" has value "1.968384"
    Then field "eikurs" is not modifiable    
    Then field "eikurs" has value "1.771546"
    Then field "ieinh" is not modifiable    
    Then field "ieinh" has value "1"
    Then field "ewewu" is not modifiable    
    Then field "ewewu" has value "nein" 
    Then field "kursfix" is modifiable    
    Then field "kursfix" has value "ja"   
    Then field "ewsbetr" has value "100.00" in row 1
    Then field "sbetrag" has value "177.15" in row 1
    Then field "tiwbu" has value "DEM" in row 1
    Then field "tewbu" has value "USD" in row 1 
    
    And I set field "kursfix" to "nein"
    Then field "ewekurs" is modifiable
    Then field "ewekurs" has value "0.853492"
    Then field "ewkurs" is not modifiable
    Then field "ewkurs" has value "0.853492"
    Then field "eweinh" is not modifiable
    Then field "eweinh" has value "1"
    Then field "uw" is not modifiable    
    Then field "uw" has value "EUR"    
    Then field "iwkurs" is not modifiable
    Then field "iwkurs" has value "1.968384"
    Then field "iwekurs" is not modifiable
    Then field "iwekurs" has value "1.968384"
    Then field "eikurs" is not modifiable    
    Then field "eikurs" has value "1.680000"
    Then field "ieinh" is not modifiable    
    Then field "ieinh" has value "1"
    Then field "ewewu" is not modifiable    
    Then field "ewewu" has value "nein" 
    Then field "kursfix" is modifiable    
    Then field "ewsbetr" has value "100.00" in row 1
    Then field "sbetrag" has value "168.00" in row 1
    Then field "tiwbu" has value "DEM" in row 1
    Then field "tewbu" has value "USD" in row 1 
       
    And I close the current editor 
        
#

