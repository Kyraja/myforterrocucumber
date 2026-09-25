# *****************************************************************************
#  Name: record_init.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Datensatzinitialisierungen
# *****************************************************************************
@persistent
@VALUE_SET_IDENTIFIER_RECORD_INIT
Feature: RECORD_INIT_109:1

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298


Scenario: InitialisierungenBeiNeu

Given I open an editor "NEU" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
Then field "such" is empty
Then field "namebspr" is empty
Then field "besch" is empty
Then field "classname" is empty
And I set field "such" to "NEU"
And I set field "namebspr" to "Neu"
And I set field "besch" to "Dies ist der Bezeichner für das Wort Neu."
And I set field "classname" to "New"
And I save the current editor
And I close the current editor

Scenario: InitialisierungenBeiKopie

Given I open an editor "KOPIE" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record "NEU"
Then field "such" is empty
And I set field "such" to "KOPIE"
Then field "namebspr" has value "Neu"
Then field "besch" has value "Dies ist der Bezeichner für das Wort Neu."
Then field "classname" is empty
And I close the current editor
