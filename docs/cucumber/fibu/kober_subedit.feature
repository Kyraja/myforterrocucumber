@persistent
Feature: Kontenbereichsformular
Background:
Given I set the fake date to "10.01.2002"

# *****************************************************************************
#  Name             : kober_subeditor.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : Test des Öffnens der Subeditoren in der Tabelle des Kontenbereichsformulars
#                     bei Neuanlage eines KB-Formulars
#
# *****************************************************************************

Scenario: Verschiedene Kontenbereichsformulare anlegen
Given I open an editor "kontenbereich" from table "(AccountRange):(CorridorControllingPL)" with command "NEW" for record ""
And I set field "nummer" to "900"
And I set field "such" to "CCGUV"
And I set field "iagj" to "02"
And I set field "iegj" to "02"
And I set field "bagj" to "02"
And I set field "begj" to "02"
And I set field "pagj" to "02"
And I set field "pegj" to "02"
And I create a new row at the end of the table
And I set field "kbereich" to "1" in row 1
#And I press button "tbist" to open a subeditor for "Istdaten" in row 1
# 2619
# And pressing button "tbist" throws the exception "2619"
# Then setting field "lsart" to "Lieferschein" throws the exception "203"
#And I respond with answer "OK" to the dialog with id ""
Then I save the current editor







