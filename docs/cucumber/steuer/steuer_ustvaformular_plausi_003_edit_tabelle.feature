# *****************************************************************************
#  Name             : steuer_ustvaformular_plausi_003_edit_tabelle.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis in USTVA-Formular-Tabelle ueberwachen
#
#
# *****************************************************************************
@persistent
Feature: steuer_ustvaformular_plausi_003_edit_tabelle.feature
Background: Plausis in USTVA-Formular ueberwachen


Scenario: Editierbarkeit in der Tabelle


Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
# USt-Formular auf den aktuellen Jahr bringen
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I press button "berech"
#
# Startzustand in der Zeile 1
Then field "bempos" is modifiable in row 1
Then field "bemposnr" is not modifiable in row 1
Then field "bemgr" is modifiable in row 1
Then field "stsatz" is modifiable in row 1
Then field "stpos" is modifiable in row 1
Then field "stposnr" is not modifiable in row 1
Then field "stbetr" is modifiable in row 1
Then field "kpos" is modifiable in row 1
Then field "kbppos" is not modifiable in row 1
Then field "kpbetr" is modifiable in row 1
Then field "tstdiff" is not modifiable in row 1
#
Then field "bempos" has value "281SA" in row 1
Then field "bemgr" is not empty in row 1
Then field "tstdiff" has value "-0.07" in row 1
#
#
And I set field "bempos" to "" in row 1
Then field "bemgr" has value "0.00" in row 1
Then field "stsatz" is not empty in row 1
#
#
And I set field "kpos" to "" in row 1
Then field "kbppos" is modifiable in row 1
Then field "kpbetr" has value "0.00" in row 1
Then field "tstdiff" has value "0.00" in row 1
#
And I save the current editor
And I close the current editor
#############################################################################################################################


Scenario: Plausis in der Tabelle


Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
# USt-Formular auf den aktuellen Jahr bringen
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I press button "berech"
#
# Bemessungsposition
Then setting field "bempos" to "581" in row 1 throws the exception "2961"
# Steuerposition
Then setting field "stpos" to "581" in row 1 throws the exception "2961"
# Kontrollposition
Then setting field "kpos" to "81" in row 1 throws the exception "2985"
#
And I set field "kpos" to "581" in row 1
Then field "kpos" is not empty in row 1
Then field "kbppos" is not modifiable in row 1
Then setting field "kbppos" to "2001" in row 1 throws the exception "8140"
#
And I close the current editor
#############################################################################################################################


