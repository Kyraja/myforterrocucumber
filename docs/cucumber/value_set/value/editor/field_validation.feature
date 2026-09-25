# *****************************************************************************
#  Name: field_validation.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Feldprüfungen
# *****************************************************************************
@persistent
@VALUE_FIELD_VALIDATION
Feature: FIELD_VALIDATION_109:3

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

Scenario: ErzeugeWertemengenBezeichner

Given I open an editor "FV_BEZ" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "FV_WMBEZ"
And I set field "classname" to "FvValueSetIdentifier"
And I save the current editor
And I close the current editor

Scenario: ErzeugeBezeichner

Given I open an editor "FV_BEZEICHNER" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "FV_BEZEICHNER"
And I set field "classname" to "FvIdentifier"
And I save the current editor
And I close the current editor

Scenario: ErzeugeWertPflichtfeldValidierung
Given I open an editor "FV_VALUE_MANDATORY" from table "(ValueSet):(Value)" with command "NEW" for record ""
Then saving the current editor throws the exception "10179"
And I set field "wmbez" to "FV_WMBEZ"
Then saving the current editor throws the exception "10179"
And I set field "bezeichner" to "FV_BEZEICHNER"
Then saving the current editor throws the exception "10179"
And I set field "wtyp" to "Real"
And I set field "real" to "2,25"
And I close the current editor

Scenario: ErzeugeBoolWert

Given I open an editor "FV_VALUE" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FV_WMBEZ"
And I set field "bezeichner" to "FV_BEZEICHNER"
And I set field "wtyp" to "Bool"
And I set field "bool" to "true"
And I save the current editor
And I close the current editor

Scenario: ErzeugeBoolWertDupletteScheitert

Given I open an editor "FV_VALUE_DOUBLE" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FV_WMBEZ"
And I set field "bezeichner" to "FV_BEZEICHNER"
Then message "Datensatz existiert - Mehrfacherfassung nicht erlaubt" was displayed
And I set field "wtyp" to "Integer"
And I set field "integer" to "1"
Then saving the current editor throws the exception "351"
And I close the current editor
