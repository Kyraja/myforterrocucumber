# *****************************************************************************
#  Name             : steuer_ustva_edit_002_formular.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis bei Editieren/Speichern von USTVA-Formularen
#
#
# *****************************************************************************
@persistent
Feature: steuer_ustva_edit_002_formular.feature
Background: Plausis in USTVA-Formular


Scenario: Vesuch das Feld 'bukreis' zu leeren

# USt-Formular
Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I set field "bukreis" to ""
And I press button "berech"
Then saving the current editor throws the exception "Buchungskreis bitte eintragen"
And I close the current editor


# USt-Formular
Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "nummer" to "3000a"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I set field "bukreis" to ""
Then saving the current editor throws the exception "Buchungskreis bitte eintragen"
And I close the current editor
#############################################################################################################################


Scenario: Vesuch das Formular mit der leeren Tabelle zu speichern

# USt-Formular
Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "NEW" for record ""
And I set field "nummer" to "3000c"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I set field "bukreis" to "1"
# Fehler wird nicht erkannt -> eine leere Zeile ist da
Then saving the current editor throws the exception "Tabelle unvollständig ausgefüllt!"
And I close the current editor
#############################################################################################################################
