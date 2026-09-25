 @persistant
Feature: Editability of Fields new entries
Background:
Given I set the fake date to "2.2.2002"

Scenario: editable_new_entry_fields_general
 
 Given I open an editor "Buchung1" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
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
   
Scenario: editable_new_entry_fields_only_fibu
 
 Given I open an editor "Buchung1" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    Then field "ebeleg" is modifiable
    Then field "buartrdiff" is not modifiable
    And I close the current editor
     
Scenario: editable_new_entry_fields_consolidation
 
Given I open an editor "Buchung1" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    Then field "konsol" is not modifiable
    Then field "konzfa" is modifiable
    Then field "isstorno" is not modifiable
    And I close the current editor
    
Scenario: editable_new_entry_fields_currency    
 Given I open an editor "Buchung2" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    Then field "iwbu" is not modifiable
    Then field "ewbu" is modifiable
    Then field "ewkurs" is not modifiable
    Then field "eweinh" is not modifiable
    Then field "uw" is not modifiable
    Then field "iwkurs" is not modifiable
    Then field "iwekurs" is not modifiable
    Then field "eikurs" is not modifiable
    Then field "kursfix" is not modifiable
    Then field "ewewu" is not modifiable
    Then field "ieinh" is not modifiable
    Then field "ewekurs" is not modifiable

    And I set field "ewbu" to "usd"  
    Then field "iwbu" is not modifiable
    Then field "ewbu" is modifiable
    Then field "ewkurs" is not modifiable
    Then field "eweinh" is not modifiable
    Then field "uw" is not modifiable
    Then field "iwkurs" is not modifiable
    Then field "iwekurs" is not modifiable
    Then field "eikurs" is modifiable
    Then field "kursfix" is modifiable
    Then field "ewewu" is not modifiable
    Then field "ieinh" is not modifiable
    Then field "ewekurs" is modifiable
    And I close the current editor
    
Scenario: editable_new_entry_fields_payment
    Given I open an editor "Buchung3" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    Then field "zbed" is modifiable
    Then field "zbedschl" is modifiable
    Then field "vdat" is modifiable
    Then field "term" is modifiable
    Then field "mterm" is modifiable
    Then field "zasperre" is modifiable
    Then field "zaform" is modifiable
    Then field "zakodzeile" is modifiable
    Then field "zatlnr" is modifiable
    Then field "zareferenz" is modifiable
    Then field "zarefpruef" is modifiable
    Then field "vzweck" is modifiable
    Then field "zatext" is modifiable
    Then field "sepamand" is not modifiable
    Then field "bverb" is not modifiable
    Then field "kobverb" is not modifiable
            
    And I set field "zaform" to "Lastschrift"  
    Then field "sepamand" is not modifiable 
    And I close the current editor
        
Scenario: editable_new_entry_fields_action
    Given I open an editor "Buchung4" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    Then field "storno" is modifiable
    Then field "ktausch" is modifiable
    Then field "knetto" is modifiable
    Then field "nettoalle" is modifiable
    Then field "bubelnw" is not modifiable
    Then field "summe" is modifiable    
    Then field "ksteuer" is modifiable
    And I set field "butyp" to "nicht steuerrelevante Buchung"
    Then field "knetto" is not modifiable
    Then field "ksteuer" is not modifiable
    And I close the current editor
    
Scenario: editable_new_entry_fields_head_tax
    Given I open an editor "Buchung5" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    Then field "butyp" is modifiable
    Then field "sabw" is not modifiable
    Then field "ustid" is modifiable
    Then field "klm" is modifiable
    Then field "netto" is not modifiable
    Then field "artst" is not modifiable
    Then field "vrgstrgl" is modifiable
    Then field "vrgstrglustland" is not modifiable
    Then field "zmrel" is not modifiable
    Then field "ustidfa" is not modifiable

    And I set field "butyp" to "nicht steuerrelevante Buchung"
    Then field "sabw" is not modifiable
    Then field "ustid" is modifiable
    Then field "klm" is modifiable
    Then field "netto" is not modifiable
    Then field "artst" is not modifiable
    Then field "vrgstrgl" is not modifiable
    Then field "vrgstrglustland" is not modifiable
    Then field "zmrel" is not modifiable
    Then field "ustidfa" is not modifiable
    And I close the current editor
        
Scenario: editable_new_entry_fields_set_of_books
    Given I open an editor "Buchung6" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record "" 
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
    Then field "exbunr4" is not modifiable
    Then field "inbukreis5" is modifiable
    Then field "bukreis5" is not modifiable
    Then field "inbunr5" is not modifiable
    Then field "exbunr5" is not modifiable
    
Scenario: editable_new_entry_fields_row_general
    Given I open an editor "Buchung7" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record "" 
    
    And I create a new row at the end of the table
    Then field "konto" is modifiable in row 1
    Then field "soll" is not modifiable in row 1
    Then field "sbetrag" is not modifiable in row 1
    Then field "hbetrag" is not modifiable in row 1
    Then field "ewsbetr" is not modifiable in row 1
    Then field "ewhbetr" is not modifiable in row 1
    Then field "kart" is not modifiable in row 1
    Then field "fertig" is not modifiable in row 1
    Then field "ptext" is modifiable in row 1
    Then field "saldo" is modifiable in row 1
    Then field "anlage" is not modifiable in row 1
    Then field "mge" is modifiable in row 1
    Then field "einheit" is modifiable in row 1
    Then field "me" is modifiable in row 1
    Then field "ewrdiff" is not modifiable in row 1
    Then field "rdiff" is not modifiable in row 1
    Then field "gegen1" is modifiable in row 1
    Then field "gegen2" is modifiable in row 1
    Then field "gegen3" is modifiable in row 1
    Then field "gegen4" is modifiable in row 1
    Then field "gegen5" is modifiable in row 1
    Then field "gegen" is not modifiable in row 1  
    Then field "gegenfix" is modifiable in row 1  
             
    And I set field "konto" to "K 1" in row 1
    Then field "sbetrag" is modifiable in row 1
    Then field "hbetrag" is modifiable in row 1
    Then field "ewsbetr" is modifiable in row 1
    Then field "ewhbetr" is modifiable in row 1
    And I set field "ewbu" to "usd"    
    Then field "sbetrag" is not modifiable in row 1
    Then field "hbetrag" is not modifiable in row 1
    Then field "ewsbetr" is modifiable in row 1
    Then field "ewhbetr" is modifiable in row 1
 
    And I create a new row at the end of the table
    And I set field "konto" to "68800" in row 2
    Then field "sbetrag" is modifiable in row 2
    Then field "hbetrag" is modifiable in row 2
    And I set field "konto" to "18100" in row 2
    Then field "sbetrag" is not modifiable in row 2
    Then field "hbetrag" is not modifiable in row 2
    And I set field "konto" to "48420" in row 2
    Then field "sbetrag" is modifiable in row 2
    Then field "hbetrag" is modifiable in row 2
    And I close the current editor
    
Scenario: editable_new_entry_fields_row_advance_payment
    Given I open an editor "Buchung8" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record "" 
    And I create a new row at the end of the table
    And I set field "konto" to "K 1" in row 1
    Then field "anzlewbetr" is not modifiable in row 1
    Then field "anzlewhbetr" is not modifiable in row 1
    Then field "anzurewbetr" is not modifiable in row 1
    Then field "anzurewhbetr" is not modifiable in row 1
    And I close the current editor

Scenario: editable_new_entry_fields_kv
    Given I open an editor "Buchung9" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record "" 
    And I create a new row at the end of the table
    Then field "kvoffen" is not modifiable in row 1
    Then field "kv" is not modifiable in row 1
    Then field "kvrel" is not modifiable in row 1
    Then field "kvnum" is not modifiable in row 1
    And I set field "konto" to "44000" in row 1
    Then field "kvoffen" is not modifiable in row 1
    Then field "kv" is not modifiable in row 1
    Then field "kvrel" is not modifiable in row 1
    Then field "kvnum" is modifiable in row 1
    And I set field "konto" to "K 1" in row 1
    Then field "kvoffen" is not modifiable in row 1
    Then field "kv" is modifiable in row 1
    Then field "kvrel" is modifiable in row 1
    Then field "kvnum" is modifiable in row 1
    And I close the current editor

Scenario: editable_new_entry_fields_w2
    Given I open an editor "Buchung10" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record "" 
    And I create a new row at the end of the table
    Then field "kow2" is not modifiable in row 1
    Then field "w2kurs" is not modifiable in row 1
    Then field "w2ewkurs" is not modifiable in row 1
    Then field "w2einh" is not modifiable in row 1
    Then field "w2ekurs" is not modifiable in row 1
    Then field "w2betr" is not modifiable in row 1
    Then field "w2hbetr" is not modifiable in row 1
    Then field "w2gjahr" is not modifiable in row 1
    And I set field "konto" to "44000" in row 1
    Then field "kow2" is not modifiable in row 1
    Then field "w2kurs" is not modifiable in row 1
    Then field "w2ewkurs" is not modifiable in row 1
    Then field "w2einh" is not modifiable in row 1
    Then field "w2ekurs" is not modifiable in row 1
    Then field "w2betr" is not modifiable in row 1
    Then field "w2hbetr" is not modifiable in row 1
    Then field "w2gjahr" is not modifiable in row 1
    And I set field "konto" to "44000USD" in row 1
    Then field "kow2" is not modifiable in row 1
    Then field "w2kurs" is not modifiable in row 1
    Then field "w2ewkurs" is not modifiable in row 1
    Then field "w2einh" is not modifiable in row 1
    Then field "w2ekurs" is modifiable in row 1
    Then field "w2betr" is not modifiable in row 1
    Then field "w2hbetr" is not modifiable in row 1
    Then field "w2gjahr" is not modifiable in row 1
    And I close the current editor 

Scenario: editable_new_entry_fields_fibu_general
    Given I open an editor "Buchung11" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record "" 
    And I create a new row at the end of the table
    Then field "umsatz" is not modifiable in row 1
    Then field "umgelegtinkm" is not modifiable in row 1    
    Then field "inkkreis" is not modifiable in row 1
    Then field "tkonsol" is not modifiable in row 1  
    And I close the current editor     

Scenario: editable_new_entry_fields_row_tax
    Given I open an editor "Buchung12" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record "" 
    And I create a new row at the end of the table
    Then field "strgl" is not modifiable in row 1
    Then field "zstrgl" is not modifiable in row 1    
    Then field "steuer" is not modifiable in row 1
    Then field "ev" is not modifiable in row 1  
    Then field "laart" is not modifiable in row 1
    Then field "stbasis" is not modifiable in row 1    
    Then field "zmart" is not modifiable in row 1
    Then field "ustva" is not modifiable in row 1
#
    Then field "nbkenn" is not modifiable in row 1
    Then field "hilfbetr" is not modifiable in row 1    
    Then field "znetto" is modifiable in row 1
    Then field "bsts" is not modifiable in row 1  
    Then field "isvert" is not modifiable in row 1
    Then field "ustart" is not modifiable in row 1    
    Then field "stdat" is not modifiable in row 1
    Then field "stper" is not modifiable in row 1
#
    Then field "ewurbetr" is not modifiable in row 1
    Then field "urbetr" is not modifiable in row 1    
    Then field "ewstbetr" is not modifiable in row 1
    Then field "stbetr" is not modifiable in row 1  
    Then field "skkonto" is not modifiable in row 1
    Then field "sktoustpos" is not modifiable in row 1    
    Then field "estkonto" is not modifiable in row 1
    Then field "vstkonto" is not modifiable in row 1
    Then field "ekstustpos" is not modifiable in row 1
    Then field "vkstustpos" is not modifiable in row 1
    Then field "ustland" is not modifiable in row 1
    Then field "stnichtabziehbar" is not modifiable in row 1
    And I close the current editor     

Scenario: editable_new_entry_fields_row_currency
    Given I open an editor "Buchung13" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record "" 
    And I create a new row at the end of the table
    Then field "tiwbu" is not modifiable in row 1
    Then field "tewbu" is not modifiable in row 1    
    Then field "teweinh" is not modifiable in row 1
    Then field "tewekurs" is not modifiable in row 1  
    Then field "teikurs" is not modifiable in row 1    
    And I close the current editor 

Scenario: editable_new_entry_fields_controlling
    Given I open an editor "Buchung14" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record "" 
    And I create a new row at the end of the table
    Then field "kstelle" is not modifiable in row 1
    Then field "projekt" is modifiable in row 1    
    Then field "kvalt" is not modifiable in row 1  
    Then field "vert" is not modifiable in row 1  
    Then field "koart" is not modifiable in row 1  
    Then field "koretyp" is not modifiable in row 1  
    And I set field "konto" to "44000USD" in row 1
    And I set field "ewsbetr" to "100" in row 1
    Then field "kstelle" is modifiable in row 1
    Then field "projekt" is modifiable in row 1    
    Then field "kvalt" is not modifiable in row 1  
    Then field "vert" is modifiable in row 1  
    Then field "koart" is not modifiable in row 1  
    Then field "koretyp" is not modifiable in row 1
    And I close the current editor  

Scenario: editable_new_entry_fields_row_asset
    Given I open an editor "Buchung15" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record "" 
    And I create a new row at the end of the table
    Then field "anlage" is not modifiable in row 1 
    And I set field "kenn" to "ZU"
    Then field "anlage" is modifiable in row 1 
    And I close the current editor 
