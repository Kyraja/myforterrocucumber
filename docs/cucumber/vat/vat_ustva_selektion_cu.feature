# *****************************************************************************
#  Name           : vat_ustva_selektion_cu.feature
#  Autor          : jeffler
#  Verantwortlich : wane
#  Kontrolle      :
#  Funktion       : prueft, dass Nachbuchungsmonate in der Selektion des 
#                   UStVa-Formular nur fuer vergangene GJ akzeptiert werden
# *****************************************************************************
@persistent
Feature: UStVa

Background: REWE-3559: UStVa-Formular Nachbuchungsmonate nur für vergangene Jahre

Scenario: vergangenes Geschaeftsjahr - regulaere Monate

Given I open an editor "avr1" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "nummer" to "9871"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "-1"
And I set field "gendjahr" to "-1"
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I create a new row at the end of the table
And I set field "bempos" to "10" in row 1
And I save the current editor
And I close the current editor

Scenario: vergangenes Geschaeftsjahr - Nachbuchungsmonate

Given I open an editor "avr2" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "nummer" to "9872"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "-1"
And I set field "gendjahr" to "-1"
And I set field "ganmon" to "13"
And I set field "gendmon" to "15"
And I create a new row at the end of the table
And I set field "bempos" to "10" in row 1
And I save the current editor
And I close the current editor

Scenario: aktuelles Geschaeftsjahr - regulaere Monate

Given I open an editor "avr3" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "nummer" to "9873"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "2"
Then message "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!" was not displayed
And I set field "gendmon" to "10"
Then message "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!" was not displayed
And I create a new row at the end of the table
And I set field "bempos" to "10" in row 1
And I save the current editor
And I close the current editor

Scenario: aktuelles Geschaeftsjahr - Nachbuchungsmonate

Given I open an editor "avr4" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "14"
Then message "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!" was not displayed
And I set field "gendmon" to "15"
Then message "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!" was not displayed
And I close the current editor

Given I open an editor "avr4" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "+1"
And I set field "ganmon" to "14"
Then message "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!" was not displayed
And I set field "gendmon" to "15"
Then message "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!" was displayed
And I close the current editor

Given I open an editor "avr4" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "+1"
And I set field "gendjahr" to "."
And I set field "ganmon" to "14"
Then message "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!" was displayed
And I set field "gendmon" to "15"
Then message "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!" was displayed
And I close the current editor

Scenario: zukünftiges Geschaeftsjahr - regulaere Monate

Given I open an editor "avr5" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "nummer" to "9874"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "+1"
And I set field "gendjahr" to "+1"
And I set field "ganmon" to "5"
And I set field "gendmon" to "5"
And I create a new row at the end of the table
And I set field "bempos" to "10" in row 1
And I save the current editor
And I close the current editor

Scenario: zukünftiges Geschaeftsjahr - Nachbuchungsmonate

Given I open an editor "avr6" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "+1"
And I set field "gendjahr" to "+1"
And I set field "ganmon" to "13"
Then message "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!" was displayed
And I set field "gendmon" to "14"
Then message "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!" was displayed
And I close the current editor

Scenario: zukünftiges Anfangsgeschaeftsjahr - regulaere Monate

Given I open an editor "avr7" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "+1"
And I set field "gendjahr" to "-1"
And I set field "ganmon" to "12"
And I set field "gendmon" to "12"
And I close the current editor

Scenario: zukünftiges Endgeschaeftsjahr - regulaere Monate

Given I open an editor "avr8" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "-1"
And I set field "gendjahr" to "+1"
And I set field "ganmon" to "10"
And I set field "gendmon" to "11"
And I close the current editor

Scenario: zukünftiges Anfangsgeschaeftsjahr - Nachbuchungsmonate

Given I open an editor "avr9" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "+1"
And I set field "gendjahr" to "+1"
And I set field "ganmon" to "13"
Then message "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!" was displayed
And I set field "gendmon" to "14"
Then message "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!" was displayed
And I close the current editor

Scenario: zukünftiges Endgeschaeftsjahr - Nachbuchungsmonate

Given I open an editor "avr10" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "-1"
And I set field "gendjahr" to "+1"
And I set field "ganmon" to "13"
And I set field "gendmon" to "14"
Then message "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!" was displayed

And I close the current editor

Scenario: Eintragung: vergangenes GJ -> Nachbuchungsmonate -> gendjahr auf zukünftig ändern

Given I open an editor "avr11" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "nummer" to "11111" in row 0
And I set field "zeitraum" to "monatlich" in row 0
And I set field "ganjahr" to "-1" in row 0
And I set field "gendjahr" to "-1" in row 0
And I set field "ganmon" to "13" in row 0
And I set field "gendmon" to "14" in row 0
And I set field "gendjahr" to "+1" in row 0
And I create a new row at the end of the table
And I set field "bempos" to "21" in row 1
Then saving the current editor throws the exception "2973"
And I close the current editor

Scenario: Button berechne Formular - Nachbuchungsmonat für zukünftiges GJ

Given I open an editor "avr12" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "nummer" to "222222" in row 0
And I set field "zeitraum" to "monatlich" in row 0
And I set field "ganmon" to "13" in row 0
And I set field "gendmon" to "14" in row 0
And I set field "ganjahr" to "-1" in row 0
And I set field "gendjahr" to "+1" in row 0
Then field "ganmon" has value "13" in row 0
Then field "gendmon" has value "14" in row 0
Then field "ganjahr" has value "01" in row 0
Then field "gendjahr" has value "03" in row 0
# ######################################################################################################################################### #
# Erwartet wurde die Fehlermeldung "Selektionszeitraum ungültig oder Umsatzsteuervoranmeldung nicht konfiguriert!"                          #
# Diese wird im Mandanten angezeigt, nicht aber in Cucumber. Zudem ist das Felds "status" bei Cucumber auf den Wert "undefiniert" gesetzt.  #
# Im Mandanten wird dieses Feld beim setzen des Feldes "zeitraum" auf den Wert "berechnet" gesetzt und behält diesen bei                    #
# ######################################################################################################################################### # 
# Then pressing button "berech" in row 0 throws the exception "2973"
And I press button "berech" in row 0
Then saving the current editor throws the exception "2973"
And I close the current editor



