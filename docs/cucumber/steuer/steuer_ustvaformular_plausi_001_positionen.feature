# *****************************************************************************
#  Name             : steuer_ustvaformular_plausi_001_positionen.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis in USTVA-Formular ueberwachen
#
#
# *****************************************************************************
@persistent
Feature: steuer_ustvaformular_plausi_001_positionen.feature
Background: Plausis in USTVA-Formular ueberwachen


Scenario: Geloeschte Positionen im Formular

# USt-Formular auf den aktuellen Jahr bringen
Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I press button "berech"
#
# Kontrolle in der Zeile 1
Then field "bempos" has value "81" in row 1
Then field "bemgr" has value "1460385.00" in row 1
Then field "stsatz" has value "19.00" in row 1
Then field "stpos" has value "200" in row 1
Then field "stbetr" has value "277473.15" in row 1
Then field "kpos" has value "581" in row 1
Then field "kpbetr" has value "277473.22" in row 1
Then field "tstdiff" has value "-0.07" in row 1
#
# Kontrolle in der Zeile 13
Then field "bempos" has value "89" in row 13
Then field "bemgr" has value "0.00" in row 13
Then field "stsatz" has value "19.00" in row 13
Then field "stpos" has value "200" in row 13
Then field "stbetr" has value "0.00" in row 13
Then field "kpos" is empty in row 13
Then field "kpbetr" has value "0.00" in row 13
Then field "tstdiff" has value "0.00" in row 13
#
Then the table has 40 rows
And I save the current editor
And I close the current editor


Given I open an editor "USTVAPOSITION81" from table "(Evaluation):(ItemNumber)" with command "DELETE" for record "81"
And saving the current editor throws the exception "2743"
And I close the current editor

Given I open an editor "USTVAPOSITION89" from table "(Evaluation):(ItemNumber)" with command "DELETE" for record "89"
# And saving the current editor throws the exception "2743"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

# USt-Formular im Zeigen
Given I open an editor "formular_view1" from table "(Evaluation):(AdvanceVATReturn)" with command "VIEW" for record "2011"
# Kontrolle in der Zeile 13
Then field "bempos" has value "+89" in row 13
Then field "bemgr" has value "0.00" in row 13
Then field "stsatz" has value "19.00" in row 13
Then field "stpos" has value "200" in row 13
Then field "stbetr" has value "0.00" in row 13
Then field "kpos" is empty in row 13
Then field "kpbetr" has value "0.00" in row 13
Then field "tstdiff" has value "0.00" in row 13
And I close the current editor

# USt-Formular im Aendern
Given I open an editor "formular_update1" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
Then the table has 40 rows
# Kontrolle in der Zeile 1
Then field "bempos" has value "81" in row 1
Then field "bemgr" has value "1460385.00" in row 1
Then field "stsatz" has value "19.00" in row 1
Then field "stpos" has value "200" in row 1
Then field "stbetr" has value "277473.15" in row 1
Then field "kpos" has value "581" in row 1
Then field "kpbetr" has value "277473.22" in row 1
Then field "tstdiff" has value "0.00" in row 1
#
# Kontrolle in der Zeile 13
Then field "bempos" has value "+89" in row 13
Then field "bemgr" has value "0.00" in row 13
Then field "stsatz" has value "19.00" in row 13
Then field "stpos" has value "200" in row 13
Then field "stbetr" has value "0.00" in row 13
Then field "kpos" is empty in row 13
Then field "kpbetr" has value "0.00" in row 13
Then field "tstdiff" has value "0.00" in row 13
#
# Versuch mit abgelegter Position in der Tabelle abzuspeichern
And saving the current editor throws the exception "4959"
#
# abgelegte Position aus der Tabelle loeschen 
And I set field "bempos" to "" in row 13
Then field "bempos" is empty in row 13
And I save the current editor
And I close the current editor
# =========================================================================================
