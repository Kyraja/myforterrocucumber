# *****************************************************************************
#  Name             : steuer_ustvaformular_plausi_004_edit_kopf.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis in USTVA-Formular-Kopf ueberwachen
#
#
# *****************************************************************************
@persistent
Feature: steuer_ustvaformular_plausi_004_edit_kopf.feature
Background: Plausis in USTVA-Formular ueberwachen


Scenario: Plausis im Kopf: Finanzamt


Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
# USt-Formular auf den aktuellen Jahr bringen
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I press button "berech"
#
# Startwerte
Then field "famt" is empty in row 0
Then field "finans" is empty in row 0
Then field "finstr" is empty in row 0
Then field "finplz" is empty in row 0
Then field "finnort" is empty in row 0
#
# Finanzamt eintagen
And I set field "famt" to "1"
Then field "finplz" has value "90411" in row 0
Then field "finplz" is modifiable in row 0
Then field "finans" is not empty in row 0
Then field "finans" is modifiable in row 0
Then field "finstr" is not empty in row 0
Then field "finstr" is modifiable in row 0
Then field "finnort" is not empty in row 0
Then field "finnort" is modifiable in row 0
#
# Finanzamt entfernen
And I set field "famt" to ""
Then field "finans" is empty in row 0
Then field "finstr" is empty in row 0
Then field "finplz" is empty in row 0
Then field "finnort" is empty in row 0
#
And I close the current editor
#############################################################################################################################


Scenario: Plausis im Kopf: Koordinaten


Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
# USt-Formular auf den aktuellen Jahr bringen
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I press button "berech"
#
# Finanzamt Nuernberg
And I set field "famt" to "1"
And I set field "finlaengengrad" to "11.0683"
And I set field "finbreitengrad" to "49.4478"
#
# Firma
And setting field "fabreitengrad" to "999.9999" throws the exception "unzulässige Angabe"
And setting field "falaengengrad" to "-999.9999" throws the exception "unzulässige Angabe"
#
And I save the current editor
And I close the current editor
#############################################################################################################################


Scenario: Plausis im Kopf: Verschiedenes


Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
# USt-Formular auf den aktuellen Jahr bringen
And I set field "zeitraum" to "quartalsweise"
And setting field "gendmon" to "5" throws the exception "Ungültiger Feldwert"
#
And I set field "zeitraum" to "monatlich"
# hier muesste  the exception "Bitte eintragen"
And I set field "ganjahr" to "+2"
And I press button "berech"
# Then pressing button "berech" throws the exception "ungültige Bereichsangabe"
# And setting field "gendjahr" to "-1" throws the exception "Bitte eintragen"
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And setting field "gendmon" to "24" throws the exception "Ungültiger Feldwert"
And I set field "gendmon" to "12"
And I press button "berech"
#
And I close the current editor
#############################################################################################################################







