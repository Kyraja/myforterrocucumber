# *****************************************************************************
#  Name             : steuer_ustva_edit_001_anteil.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Ueberwachung/Anzeige von "Anteil" bei Positionen
#
#
# *****************************************************************************
@persistent
Feature: steuer_ustva_edit_001_anteil.feature
Background: negative Betraege positiv in USTVA-Formular darstellen


Scenario: Anteil bei Positionen veraendern und ueber Formular ueberwachen

Given I open an editor "postion81_view" from table "(Evaluation):(ItemNumber)" with command "VIEW" for record "81"
Then field "anteil" has value "1.00" in row 0
And I close the current editor

Given I open an editor "postion41_view" from table "(Evaluation):(ItemNumber)" with command "VIEW" for record "41"
Then field "anteil" has value "1.00" in row 0
And I close the current editor

Given I open an editor "postion581_view" from table "(Evaluation):(ItemNumber)" with command "VIEW" for record "581"
Then field "anteil" has value "1.00" in row 0
And I close the current editor

# Ust-Formular
Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I press button "berech"
And I save the current editor
And I close the current editor

# Ust-Formular
Given I open an editor "formular_view1" from table "(Evaluation):(AdvanceVATReturn)" with command "VIEW" for record "2011"
Then field "bempos" has value "81" in row 1
Then field "bemgr" has value "1460385.00" in row 1
#
Then field "kpos" has value "581" in row 1
Then field "kpbetr" has value "277473.22" in row 1
#
Then field "bempos" has value "41" in row 7
Then field "bemgr" has value "216850.00" in row 7
#
And I save the current editor
And I close the current editor


# ----- bei Positionen "Anteil" anpassen ------
Given I open an editor "postion81_update" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "81"
And I set field "anteil" to "0.50"
And I save the current editor
And I close the current editor

Given I open an editor "postion41_update" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "41"
And I set field "anteil" to "-0.10"
And I save the current editor
And I close the current editor

Given I open an editor "postion581_update" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "581"
And I set field "anteil" to "0.50"
And I save the current editor
And I close the current editor


# Ust-Formular
Given I open an editor "formular_view2" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
And I press button "berech"
Then field "bempos" has value "81" in row 1
Then field "bemgr" has value "730193.00" in row 1
#
Then field "kpos" has value "581" in row 1
Then field "kpbetr" has value "138736.61" in row 1
#
Then field "bempos" has value "41" in row 7
Then field "bemgr" has value "-21685.00" in row 7
#
And I save the current editor
And I close the current editor

