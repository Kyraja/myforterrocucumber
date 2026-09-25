@persistant

Feature: Creating VAT scenario for country VAT form with/without currency

Background:
Given I set the fake date to "02.01.2002"
 

Scenario: Tax Key

    Given I open an editor "TAX KEY" from table "(TaxCode):(TaxCode)" with command "STORE" for record "STS20"

    And I set field "such" to "STS20"

    And I set field "namebspr" to "Steuerschluessel Frankreich 20%"

    And I set field "ustland" to "Frankreich"

#    And I create a new row at the end of the table

    And I set field "gperr" to "PER1" in row 1

    And I set field "psatz" to "20" in row 1

    And I save the current editor

    

Scenario: process tax rule VK

    Given I open an editor "Process tax rule" from table "(ProcessTaxRule):(ProcessTaxRule)" with command "STORE" for record "VKIN-FRA"

    And I set field "such" to "VKIN-FRA"

    And I set field "ustland" to "Frankreich"

    And I set field "stlaart" to "EU-Staat"

    And I set field "namebspr" to "Verkauf Inland Frankreich"

    And I set field "ev" to "Verkauf"

    And I set field "ustartsf" to "ja"

    And I set field "ustartsp" to "nein"

    And I set field "ustartsp" to "ja"

    And I save the current editor

    

Scenario: process tax rule EK

    Given I open an editor "Process tax rule" from table "(ProcessTaxRule):(ProcessTaxRule)" with command "STORE" for record "EKIN-FRA"

    And I set field "such" to "EKIN-FRA"

    And I set field "ustland" to "Frankreich"

    And I set field "stlaart" to "EU-Staat"

    And I set field "namebspr" to "Einkauf Inland Frankreich"

    And I set field "ev" to "Einkauf"

    And I set field "ustartsf" to "Ja"

    And I set field "ustartsp" to "nein"

    And I set field "ustartsp" to "Ja"

    And I save the current editor

    

Scenario: Customer

    Given I open an editor "customer" from table "(Customer):(Customer)" with command "STORE" for record "KFRANZ"

    And I set field "such" to "KFRANZ"

    And I set field "staat" to "Frankreich"

    And I set field "namebspr" to "Kunde Frankreich"

    And I set field "vrgstrgl" to "VKIN-FRA"

    And I set field "ustid" to "FR123134434"
    
    And I set field "zbed" to "200"

    And I save the current editor

    

Scenario: supplier1

    Given I open an editor "supplier" from table "(Vendor):(Vendor)" with command "STORE" for record "LFINAMT"

    And I set field "such" to "LFINAMT"

    And I set field "staat" to "Frankreich"

    And I set field "namebspr" to "Finanzamt Frankreich"

    And I save the current editor

    

Scenario: supplier2

    Given I open an editor "supplier" from table "(Vendor):(Vendor)" with command "STORE" for record "LFRANZ"

    And I set field "such" to "LFRANZ"

    And I set field "staat" to "Frankreich"

    And I set field "namebspr" to "Lieferant Frankreich"

    And I set field "vrgstrgl" to "EKIN-FRA"

    And I set field "ustid" to "FR987525122"

    And I set field "zbed" to "200"

    And I save the current editor



Scenario: country

    Given I open an editor "country" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "Frankreich"

    And I set field "finamt" to "LFINAMT"

    And I set field "steunr" to "FR 40 123456824"

    And I set field "ustid" to "FRXX999999999"

    And I save the current editor

    

Scenario: VAT Item VK Bemessung

    Given I open an editor "VAT item" from table "(Evaluation):(ItemNumber)" with command "STORE" for record "9981"

    And I set field "nummer" to "9981"

    And I set field "such" to "FRP81"

    And I set field "ustland" to "Frankreich"

    And I set field "namebspr" to "Steuerpflichtige Ums�tze 20%"

    And I set field "postyp" to "Mwst-Bemessung"

    And I set field "ev" to "Verkauf"

    And I set field " w2ist" to "USD"

    And I set field "hatsteuer" to "Ja"

    And I create a new row at the end of the table

    And I set field "sts" to "STS20" in row 1

    And I save the current editor

    

Scenario: VAT Item VK Steuer

    Given I open an editor "VAT item" from table "(Evaluation):(ItemNumber)" with command "STORE" for record "9881"

    And I set field "nummer" to "9881"

    And I set field "such" to "K5P81"

    And I set field "ustland" to "Frankreich"

    And I set field "namebspr" to "Kontroll f�r Steuerpflichtige Ums�tze  Frankreich 20%"

    And I set field "postyp" to "Kontrolle"

    And I set field "ev" to "Verkauf"

    And I set field " w2ist" to "USD"

    And I set field "hatsteuer" to "Ja"

    And I create a new row at the end of the table

    And I set field "sts" to "STS20" in row 1

    And I save the current editor

    

Scenario: VAT Item EK Steuer

    Given I open an editor "VAT item" from table "(Evaluation):(ItemNumber)" with command "STORE" for record "66FR"

    And I set field "nummer" to "66FR"

    And I set field "such" to "P66FR"

    And I set field "ustland" to "Frankreich"

    And I set field "namebspr" to "Vorsteuer  Frankreich 20%"

    And I set field "postyp" to "Vorsteuer"

    And I set field "ev" to "Einkauf"

    And I set field "w2ist" to "USD"

    And I set field "hatsteuer" to "Ja"

    And I create a new row at the end of the table

    And I set field "sts" to "STS20" in row 1

    And I save the current editor

    

Scenario: VAT Item sum

    Given I open an editor "VAT item" from table "(Evaluation):(SpecialItem)" with command "STORE" for record "6689"

    And I set field "nummer" to "6689"

    And I set field "such" to "P99FR"

    And I set field "namebspr" to "Umsatzsteuer minus Vorsteuer"

    And I set field "zeispal" to "Zeile"

    And I set field "optyp" to "Subtraktion"

    And I set field "bervonzeile" to "1"

    And I set field "berbiszeile" to "2"

    And I create a new row at the end of the table

    And I set field "nspalte" to "stbetrag" in row 1

    And I save the current editor

    

Scenario: VAT Form

    Given I open an editor "VAT Form" from table "(Evaluation):(AdvanceVATReturn)" with command "STORE" for record "FR2002"

    And I set field "nummer" to "200203"

    And I set field "such" to "FR2002"

    And I set field "ustland" to "Frankreich"

    And I set field "namebspr" to "Umsatzsteuerformular 2002 Frankreich"

    And I set field "zeitraum" to "monatlich"

    And I set field "ganjahr" to "02"

    And I set field "gendjahr" to "02"

    And I set field "ganmon" to "7"

    And I set field "gendmon" to "7"

    And I set field "waehr" to "USD"

    And I create a new row at the end of the table

    And I set field "bempos" to "FRP81" in row 1

    And I set field "stpos" to "200" in row 1

    And I set field "kpos" to "K5P81" in row 1

    And I create a new row at the end of the table

    And I set field "stpos" to "P66FR" in row 2

    And I create a new row at the end of the table

    And I set field "stpos" to "P99FR" in row 3

    And I save the current editor

    

Scenario: process tax config

    Given I open an editor "tax config" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"

    And I create a new row at the end of the table

    And I set field "ev" to "Verkauf" in row 28

    And I set field "rechnlaart" to "EU-Staat" in row 28

    And I set field "bestlaart" to "EU-Staat" in row 28

    And I set field "rechnustid" to "vorhanden und aus EU-Staat" in row 28

    And I set field "vrgstrgl" to "VKIN-FRA" in row 28

    And I create a new row at the end of the table

    And I set field "ev" to "Einkauf" in row !lastRow

    And I set field "rechnlaart" to "EU-Staat" in row 29

    And I set field "bestlaart" to "EU-Staat" in row 29

    And I set field "rechnustid" to "vorhanden und aus EU-Staat" in row 29

    And I set field "vrgstrgl" to "EKIN-FRA" in row 29

    And I save the current editor

    

Scenario: GL account 1

    Given I open an editor "account 1" from table "5:01" with command "STORE" for record "UST20"

    And I set field "nummer" to "38069"

    And I set field "such" to "UST20"

    And I set field "namebspr" to "Umsatzsteuer 20%"

    And I set field "ev" to "Verkauf"

    And I set field "karta" to "Steuerkonto"

    And I set field "steuersts" to "STS20"

    And I set field "w2ist" to "USD"

    And I set field "w2gjahr" to "02"

    And I save the current editor

    

Scenario: GL account 2

    Given I open an editor "account 2" from table "5:01" with command "STORE" for record "VST20"

     And I set field "nummer" to "14069"

    And I set field "such" to "VST20"

    And I set field "namebspr" to "Vorsteuer 20%"

    And I set field "ev" to "Einkauf"

    And I set field "karta" to "Steuerkonto"

    And I set field "steuersts" to "STS20"

    And I set field "w2ist" to "USD"

    And I set field "w2gjahr" to "02"

    And I save the current editor

    

Scenario: GL account 3

    Given I open an editor "account 3" from table "5:01" with command "STORE" for record "GSKTO20"

     And I set field "nummer" to "47369"

    And I set field "such" to "GSKTO20"

    And I set field "namebspr" to "Gew�hrte Skonti20% netto Frankreich"

    And I set field "gv" to "Ja"

    And I set field "ev" to "Verkauf"

    And I set field "karta" to "Skontokonto"

    And I set field "w2ist" to "USD"

    And I set field "w2gjahr" to "02"

    And I save the current editor

    

    Scenario: GL account 4

    Given  I open an editor "account 4" from table "5:01" with command "STORE" for record "ESKTO20"

     And  I set field "nummer" to "57369"

    And  I set field "such" to "ESKTO20"

    And  I set field "namebspr" to "Erhaltene Skonti 20% VST netto Frankreich"

    And  I set field "gv" to "Ja"

    And  I set field "ev" to "Einkauf"

    And  I set field "karta" to "Skontokonto"

    And I set field "w2ist" to "USD"

    And I set field "w2gjahr" to "02"  

    And  I save the current editor

    

    Scenario: GL account 5

    Given  I open an editor "account 5" from table "5:01" with command "STORE" for record "UEFR20"

     And  I set field "nummer" to "44999"

    And  I set field "such" to "UEFR20"

    And  I set field "namebspr" to "Umsatzserl�se Frankreich 20%"

    And  I set field "gv" to "Ja"

    And  I set field "ev" to "Verkauf"

    And I set field "w2ist" to "USD"

    And I set field "w2gjahr" to "02"  

    And  I save the current editor

 

    

    Scenario: GL account 6

    Given  I open an editor "account 5" from table "5:01" with command "STORE" for record "RHB20"

     And  I set field "nummer" to "10099"

    And  I set field "such" to "RHB20"

    And  I set field "namebspr" to "Roh- ,Hilfs- und Betriebsstoffe Frankreich"

    And  I set field "ev" to "Einkauf"

    And I set field "w2ist" to "USD"

    And I set field "w2gjahr" to "02"  

    And  I save the current editor

 

    

    Scenario: vorgangskontotausch 1

    Given  I open an editor "VKT" from table "(ProcessAccountChange):(ProcessAccountChange)" with command "UPDATE" for record "44000"

    And  I create a new row at the end of the table

    And  I set field "vrgstrgl" to "VKIN-FRA" in row 4

    And  I set field "konto" to "UEFR20" in row 4

    And  I save the current editor

    

    Scenario: vorgangskontotausch 2

    Given  I open an editor "VKT" from table "(ProcessAccountChange):(ProcessAccountChange)" with command "UPDATE" for record "10000"

    And  I create a new row at the end of the table

    And  I set field "vrgstrgl" to "EKIN-FRA" in row 3

    And  I set field "konto" to "RHB20" in row 3

    And  I save the current editor

    

    

    Scenario: Steuerregel 1

    Given  I open an editor "tax rule 1" from table "(TaxCode):(TaxRule)" with command "STORE" for record "VKFR"

#    And  I set field "nummer" to "5010"

    And  I set field "such" to "VKFR"

    And  I set field "namebspr" to "Verkauf Frankreich Regelsteuer 20%"

    And  I set field "ev" to "Verkauf"

    And  I set field "stlaart" to "EU-Staat"

    And  I set field "ustart" to "steuerpflichtig"

    And  I set field "ustland" to "Frankreich"

    And  I set field "sts" to "STS20"

#    And  I create a new row at the end of the table

    And  I set field "sts" to "STS20" in row 1

    And  I set field "budatstper" to "STS20-PER1" in row 1

    And  I set field "stdatstper" to "STS20-PER1" in row 1

    And  I set field "ktoustpos" to "FRP81" in row 1

    And  I set field "sktoustpos" to "FRP81" in row 1

    And  I set field "skkto" to "GSKTO20" in row 1

    And  I set field "vstkonto" to "UST20" in row 1

    And  I set field "vkstustpos" to "K5P81" in row 1

    And  I save the current editor

    

    

    Scenario: Steuerregel 2

    Given  I open an editor "tax rule 2" from table "(TaxCode):(TaxRule)" with command "STORE" for record "EKFR"

#    And  I set field "nummer" to "5011"

    And  I set field "such" to "EKFR"

    And  I set field "namebspr" to "Einkauf Frankreich Regelsteuer 20%"

    And  I set field "ev" to "Einkauf"

    And  I set field "stlaart" to "EU-Staat"

    And  I set field "ustart" to "steuerpflichtig"

    And  I set field "ustland" to "Frankreich"

    And  I set field "sts" to "STS20"

#    And  I create a new row at the end of the table

    And  I set field "sts" to "STS20" in row 1

    And  I set field "budatstper" to "STS20-PER1" in row 1

    And  I set field "stdatstper" to "STS20-PER1" in row 1

    And  I set field "sktoustpos" to "66FR" in row 1

    And  I set field "skkto" to "ESKTO20" in row 1

    And  I set field "estkonto" to "VST20" in row 1

    And  I set field "ekstustpos" to "P66FR" in row 1

    And  I save the current editor

    

    Scenario: Konten-Steuerregel 1

    Given  I open an editor "account tax rule 1" from table "(TaxCode):(AccountTaxRule)" with command "STORE" for record "VKFR-01"

#    And  I set field "nummer" to "7018"

    And  I set field "such" to "VKFR-01"

    And  I set field "namebspr" to "Verkauf, steuerpflichtig/steuerfrei Frankreich"

    And  I set field "ev" to "Verkauf"  

    And  I set field "ustland" to "Frankreich"

#    And  I create a new row at the end of the table

    And  I set field "vrgstrgl" to "VKIN-FRA" in row 1

    And  I set field "strgl" to "VKFR" in row 1

    And  I save the current editor

    

    Scenario: Konten-Steuerregel 2

    Given  I open an editor "account tax rule 2" from table "(TaxCode):(AccountTaxRule)" with command "STORE" for record "EKFR-01"

    And  I set field "such" to "EKFR-01"

    And  I set field "namebspr" to "Einkauf, steuerpflichtig/steuerfrei Frankreich"

    And  I set field "ev" to "Einkauf"  

    And  I set field "ustland" to "Frankreich"

#    And  I create a new row at the end of the table

    And  I set field "vrgstrgl" to "EKIN-FRA" in row 1

    And  I set field "strgl" to "EKFR" in row 1

    And  I save the current editor

    

    Scenario: GL account Update 1

    Given I open an editor "accountup1" from table "5:01" with command "UPDATE" for record "GSKTO20"

    And I set field "ktostrgl" to "VKFR-01"

    And I save the current editor

 

    Scenario: GL account Update 2

    Given I open an editor "accountup1" from table "5:01" with command "UPDATE" for record "ESKTO20"

    And I set field "ktostrgl" to "EKFR-01"

    And I save the current editor

    

    Scenario: GL account Update 3

    Given I open an editor "accountup1" from table "5:01" with command "UPDATE" for record "UEFR20"

    And I set field "ktostrgl" to "VKFR-01"

    And I save the current editor

    

    Scenario: GL account Update 4

    Given I open an editor "accountup1" from table "5:01" with command "UPDATE" for record "RHB20"

    And I set field "ktostrgl" to "EKFR-01"

    And I save the current editor
    
    Scenario: entry 1
    Given I open an editor "Finanzbuchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I set field "budat" to "01.02.02"
    And I set field "butyp" to "Rechnungsbuchung"
    And I set field "beleg" to "4711"

    And I set field "beldat" to "01.02.02"
    And  I create a new row at the end of the table 
    And I set field "konto" to "K KFRANZ" in row 1 
    And I set field "erfwaehr" to "USD"
    And I set field "ewsbetr" to "12000" in row 1
    And  I create a new row at the end of the table
    And I set field "konto" to "44999" in row 2
    And I respond with answer "ja" to the dialog with id "583" 
    And I save the current editor
      
    Scenario: entry 2
    Given I open an editor "Finanzbuchung" from table "(Entry):(Entry)" with command "NEW" for record ""
#    And I set field "butyp" to "Rechnungsbuchung"
    And I set field "beleg" to "4712"
    And I set field "budat" to "01.02.02"
    And I set field "beldat" to "01.02.02"
    And  I create a new row at the end of the table 
    And I set field "konto" to "L LFRANZ" in row 1 
    And I set field "erfwaehr" to "USD"
    And I set field "ewhbetr" to "6000" in row 1
    And  I create a new row at the end of the table
    And I set field "konto" to "10099" in row 2
    And I respond with answer "ja" to the dialog with id "583" 
    And I save the current editor 

    Scenario: VAT Form 
    Given I open an editor "VAT Form" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "FR2002" 
    And I set field "zeitraum" to "monatlich" 
    And I set field "ganjahr" to "." 
    And I set field "gendjahr" to "." 
    And I set field "ganmon" to "2" 
    And I set field "gendmon" to "2" 
    And I press button "berech"
    And I save the current editor 
    Then field "bemgr" has value "10000.00" in row 1
    Then field "stsatz" has value "20.00" in row 1 
    Then field "stbetr" has value "2000.00" in row 1
    Then field "stbetr" has value "1000.00" in row 2
    Then field "stbetr" has value "1000.00" in row 2
    
    Scenario: Kontosteuerregel Land leeren 
    Given I open an editor "Kontosteueregel" from table "(TaxCode):(AccountTaxRuleHead)" with command "UPDATE" for record "VKINLREGEL"
    And I set field "ustland" to ""
    And I create a new row at the end of the table
    And I set field "vrgstrgl" to "5005" in row 5
    And I set field "strgl" to "5007" in row 5
    And I save the current editor
    
    Scenario: Vorgangkontotausch leeren
    Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "44000"
    And I set field "vrgktotsch" to ""
    And I save the current editor 
    
    Scenario: VKRechnung fuer Ust-Land D erfassen 
    Given I open an editor "VKrechnung" from table "03:24" with command "NEW" for record ""
    And I set field "Kunde" to "1"
    And I set field "tterm" to "."
    And I create a new row at the end of the table    
    And I set field "artikel" to "V1" in row 1
    And I set field "mge" to "10" in row 1
    And I set field "kstelle" to "100" in row 1
    And I set field "ueb" to "ja" 
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor
    Then field "vrgstrglustland" has value "DEUTSCHLAND"
    Then field "ustva" has value "51" in row 1
    Then field "vstkonto" has value "38050" in row 1
    Then field "skkonto" has value "47355" in row 1
    Then field "vkstustpos" has value "551" in row 1
    Then field "ustland" has value "DEUTSCHLAND" in row 1
    
    Scenario: VKRechnung Fankreich
    Given I open an editor "vkrechnung" from table "03:24" with command "NEW" for record ""
    And I set field "Kunde" to "kfranz"
    Then field "vrgstrglustland" has value "FRANKREICH"
    Then field "vrgstrgl" has value "VKIN-FRA"
    Then field "vstaat" has value "FRANKREICH"
    Then field "ustidfa" has value "FRXX999999999"
    Then field "rechnustid" has value "FR123134434"
    And I create a new row at the end of the table
    And I set field "artikel" to "V1" in row 1
    And I set field "mge" to "10" in row 1
    And I set field "kstelle" to "100" in row 1
    And I set field "ueb" to "ja"
    And I set field "intrarel" to "nein" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor
    Then field "strgl" has value "VKFR" in row 1
    Then field "steuer" has value "3" in row 1
    Then field "ustva" has value "9981" in row 1 
    Then field "ustland" has value "FRANKREICH" in row 1
    
    Scenario: Finanzbuchung Frankreich
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I set field "vrgstrgl" to "VKIN-FRA"
    And I create a new row at the end of the table
    And I set field "konto" to "K kfranz" in row 1
    And I set field "ewsbetr" to "1000" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "strgl" to "VKFR" in row 2
    Then field "ustva" has value "9981" in row 2
    And I set field "kstelle" to "100" in row 2
    And I respond with answer "ja" to the dialog with id "1941" 
    And I save the current editor
    
    
  
    


    
    
