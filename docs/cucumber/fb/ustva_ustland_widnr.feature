# *****************************************************************************
#  Name             : ustva_ustland_widnr.feature                                  
#  Autor            : sih 
#  Verantwortlich   : sih  
#  Kontrolle        : wane
#  Funktion         : Vorbelegung Wirtschafts-Identifikationsnummer und weitere Daten im Umsatzsteuerformular
#
#
# *****************************************************************************
@persistent
Feature: ustva_ustland_widnr.feature                                      
Background: Vorbelegung Daten im  USTVA-Formular 


Scenario: 01 UStVA-Formular erzeugen, Firma Betrieb enthält keine Steuernummer, keine Wirtschafts-Identifikationsnummer
Given I open an editor "ustva-form1" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "nummer" to "8000"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "-1"
And I set field "gendjahr" to "-1"
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I create a new row at the end of the table
And I set field "bempos" to "10" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "ustva-form1-view" from table "(Evaluation):(AdvanceVATReturn)" with command "VIEW" for record "8000"
Then field "steunr" has value ""
Then field "widnr" has value ""
And I close the current editor

Scenario: 02 Firma Betrieb: Adressdaten hinterlegen, Land Deutschland: Steuernummer, UStID, Wirtschaftsidentifikationsnummer hinterlegen 
Given I open an editor "Betriebsdaten" from table "(Company):(CompanyData)" with command "UPDATE" for record "1"
And I set field "ans" to "Musterfirma"
And I set field "str" to "Musterstrasse 88"
And I set field "plz" to "88123"
And I set field "nort" to "Musterstadt"
And I set field "region" to "Baden-"
And I save the current editor
And I close the current editor

Given I open an editor "deutschland" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "DEUTSCHLAND"
And I set field "steunr" to "88888888"
And I set field "ustid" to "DE88888888"
And I set field "widnr" to "ABCD888888"
And I save the current editor
And I close the current editor

Scenario: 03 UStVA-Formular erzeugen, Firma Betrieb enthält Steuernummer, Wirtschafts-Identifikationsnummer
Given I open an editor "ustva-form2" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "nummer" to "8001"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "-1"
And I set field "gendjahr" to "-1"
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I create a new row at the end of the table
And I set field "bempos" to "10" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "ustva-form2-view" from table "(Evaluation):(AdvanceVATReturn)" with command "VIEW" for record "8001"
Then field "steunr" has value "88888888"
Then field "widnr" has value "ABCD888888"
Then field "faans" has value "Musterfirma"
And I close the current editor

Scenario: 04 Kopieren eines Formulars mit leerer Steuernummer und leerer Wirtschaftsidentifikationsnummer, beide Felder erhalten nun Vorbelegung
Given I open an editor "ustva-form3" from table "(Evaluation):(AdvanceVATReturn)" with command "COPY" for record "8000"
And I set field "nummer" to "8002"
Then field "steunr" has value "88888888"
Then field "widnr" has value "ABCD888888"
Then field "faans" has value "Musterfirma"
Then field "fastr" has value "Musterstrasse 88"
Then field "faplz" has value "88123"
And I save the current editor
And I close the current editor

Scenario: 05 Aendern der Steuer- und Wirtschaftsidentifikationsnummer in UStVA-Formular 8001 und Kopie des Formulars erstellen
Given I open an editor "ustva-form4" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "8001"
And I set field "steunr" to "12"
And I set field "widnr" to "KKKKK0073"
And I set field "fastr" to "Musterweg 222"
And I set field "faplz" to "22222"
And I set field "faans" to ""
And I set field "fanort" to ""
And I save the current editor
And I close the current editor

Given I open an editor "ustva-form5" from table "(Evaluation):(AdvanceVATReturn)" with command "COPY" for record "8001"
And I set field "nummer" to "8003"
Then field "steunr" has value "12"
Then field "widnr" has value "KKKKK0073"
Then field "faans" has value "Musterfirma"
Then field "fastr" has value "Musterweg 222"
Then field "fanort" has value "Musterstadt"
And I save the current editor
And I close the current editor



