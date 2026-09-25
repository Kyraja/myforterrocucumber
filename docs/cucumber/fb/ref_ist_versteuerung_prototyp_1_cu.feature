# *****************************************************************************************
#  Name           : ref_ist_versteuerung_prototyp_1_cu.feature
#  Autor          : rem
#  Funktion       : ABS--2769 1.durchgehendes Test-szenario von EK-Rechnung bis Zahlung mit Ist-Versteuerung
#  dokumentiert hier: https://abascloud.atlassian.net/wiki/spaces/DEV/pages/192920223947/ABS-2769+ABAS-671+1.+zusammenh+ngendes+Testszenario+Prototyp+1 
#  
#  
# ****************************************************************************************
@persistant

Feature: Ist_versteuerung_Prototyp_1

Background:
Given I set the fake date to "31.12.2022"

Scenario: Einkaufsrechnung mit Ist-Versteuerung anlegen
Given I open an editor "EK-Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
  |num4          |1000-RE1|
  |lief          |       1|
  |ueb           |      ja|
  |vom           |       .|
  |budat         |       .|  
  |istversteuerer|      ja|
  |vrgstrgl      |EKIN-IST|

Then field "versteuerungsart" has value "Ist-Versteuerung"
Then I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "100" in row 1
Then field "konto" has value "10000" in row 1
Then field "estkonto" has value "14340" in row 1
Then field "ustva" has value "" in row 1
Then I create a new row at the end of the table
And I set field "artex" to "e2" in row 2
And I set field "mge" to "100" in row 2
Then field "konto" has value "10000" in row 2
Then field "estkonto" has value "14340" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: erstellte Finanzbuchungen pruefen
# diese ID ist im Verursacher-Feld der Steuerumbuchung eingetragen"
Given I open an editor "RE1-Buchung" from table "(Entry):(Entry)" with command "VIEW" for record "E1000-RE1"
Then fields have values
|butyp            |Rechnungsbuchung|
|vrgstrgl         |EKIN-IST        |
|versteuerungsart |Ist-Versteuerung|
Then table has values
|!row|konto|ustva|
|3    |14340 |   | 
And I close the current editor

Scenario: Ustva_pruefen_zahlung 
Given I open an editor "avr1" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "USTVA2026"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "23"
And I set field "gendjahr" to "23"
And I set field "ganmon" to "3"
And I set field "gendmon" to "3"
And I press button "berech"
Then field "stbetr" has value "0.00" in row 26
And I save the current editor
And I close the current editor

Scenario: Rechnung bezahlen
# 102:1 - (OIProcessing):(OutgoingPaymentsBankTransfers)
Given I open an editor "UEBERW1" from table "(OIProcessing):(OutgoingPaymentsBankTransfers)" with command "NEW" for record ""
And I set fields
  |such       |REF-IST1|
  |beleg      |UEBERW1|
  |beldat     |01.03.2023|
  |kbudat     |01.03.2023|
  |gkonto     |14600|
Then field "zaraum" has value "SEPA-Zahlungen"  
And I create a new row at the end of the table
And I set field "tbeleg" to "1000-RE1" in row 1
And I press button "topladen" in row 1
Then field "ofbetr" has value "5593.00" in row 1
And I press button "tueber" in row 1
Then field "opzabetr" has value "5593.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

Scenario: Ustva_pruefen_nach_Zahlung 
Given I open an editor "avr1" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "USTVA2026"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "23"
And I set field "gendjahr" to "23"
And I set field "ganmon" to "3"
And I set field "gendmon" to "3"
And I press button "berech"
Then field "stbetr" has value "893.00" in row 26
And I save the current editor
And I close the current editor
