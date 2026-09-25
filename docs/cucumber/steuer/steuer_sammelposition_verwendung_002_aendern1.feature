# *****************************************************************************
#  Name             : steuer_sammelposition_verwendung_002_aendern1.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis in UStVA-Formular beim Aendern von Sammelpositionen
#                     ueberwachen
#
#
# *****************************************************************************
@persistent
Feature: steuer_sammelposition_verwendung_002_aendern1.feature
Background: Plausis in UStVA-Formular



Scenario: Anteil bei Sammelposition

Given I open an editor "formular_edit1" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "1UK"
And I press button "berech"
Then the table has 6 rows
Then field "bempos" has value "6VK-Alle" in row 1
Then field "bemgr" has value "2354435.00" in row 1
And I close the current editor


# Anteil im Kopf verdoppeln
Given I open an editor "sammelpos_update1" from table "(Evaluation):(CollectiveItem)" with command "UPDATE" for record "6VK-Alle"
Then field "anteil" has value "1.00" in row 0
And I set field "anteil" to "2" in row 0
And I save the current editor
And I close the current editor


Given I open an editor "formular_edit2" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "1UK"
And I press button "berech"
Then the table has 6 rows
Then field "bempos" has value "6VK-Alle" in row 1
Then field "bemgr" has value "4708871.00" in row 1
And I close the current editor


# Erhoehung im Kopf mit Anteilen in Zeilen zurueck drehen
Given I open an editor "sammelpos_update2" from table "(Evaluation):(CollectiveItem)" with command "UPDATE" for record "6VK-Alle"
Then field "anteil" has value "2.00" in row 0
Then the table has 3 rows
Then field "ustposanteil" has value "1.00" in row 1
Then field "ustposanteil" has value "1.00" in row 2
Then field "ustposanteil" has value "1.00" in row 3
And I set field "ustposanteil" to "0.5" in row 1
And I set field "ustposanteil" to "0.5" in row 2
And I set field "ustposanteil" to "0.5" in row 3
And I save the current editor
And I close the current editor

Given I open an editor "formular_edit3" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "1UK"
And I press button "berech"
Then the table has 6 rows
Then field "bempos" has value "6VK-Alle" in row 1
Then field "bemgr" has value "2354435.00" in row 1
And I close the current editor
# =========================================================================================

