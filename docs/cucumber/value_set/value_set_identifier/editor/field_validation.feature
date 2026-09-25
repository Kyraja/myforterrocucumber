# *****************************************************************************
#  Name: field_validation.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Feldprüfungen
# *****************************************************************************
@persistent
@VALUE_SET_IDENTIFIER_FIELD_VALIDATION
Feature: FIELD_VALIDATION_109:1

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298


Scenario: ErzeugeTestBezeichner

Given I open an editor "SUCHWORT" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "SUCHWORT"
And I set field "classname" to "Swd"
And I save the current editor
And I close the current editor

Scenario: ErzeugeTestBezeichnerMitVorhandenemSuchwortScheitert

Given I open an editor "SUCHWORT" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "SUCHWORT"
Then message "Suchwort ist nicht eindeutig" was displayed
And I set field "classname" to "Swd"
Then saving the current editor throws the exception "1602"
And I close the current editor

Scenario: ErzeugeWertmengenBezeichnerMehrdeutigerClassname

Given I open an editor "TEST1" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "TESTBEZ1"
And I set field "classname" to "TestIdent1"
And I save the current editor
And I close the current editor

Given I open an editor "TEST2" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "TESTBEZ2"
And I set field "classname" to "TestIdent2"
And I save the current editor
And I close the current editor

Given I open an editor "TEST2A" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "TESTBEZ2A"
And I set field "classname" to "TestIdent2"
And saving the current editor throws the exception "8222"
And I close the current editor
