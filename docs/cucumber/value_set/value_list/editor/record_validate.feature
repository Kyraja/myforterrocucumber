# *****************************************************************************
#  Name: record_validate.feature
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Maskenprüfung
# *****************************************************************************
@persistent
@VALUE_LIST_RECORD_VALIDATE
Feature: RECORD_VALIDATE_109:4

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

Scenario: ErzeugeWertemengenBezeichner

Given I open an editor "RV_BRD" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "RV_BRD"
And I set field "classname" to "RvBrd"
And I save the current editor
And I close the current editor

Scenario: ErzeugeBezeichnerBaden

Given I open an editor "RV_BADEN" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "RV_BADEN"
And I set field "classname" to "RvBaden"
And I save the current editor
And I close the current editor

Scenario: ErzeugeBezeichnerBayern

Given I open an editor "RV_BAYERN" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "RV_BAYERN"
And I set field "classname" to "RvBayern"
And I save the current editor
And I close the current editor

Scenario: ErzeugeWertBrdBaden

Given I open an editor "RV_BADEN" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "RV_BRD"
And I set field "bezeichner" to "RV_BADEN"
And I set field "wtyp" to "Integer"
And I set field "integer" to "1"
And I save the current editor
And I close the current editor

Scenario: BezeichnerNur1x

Given I open an editor "RV_BEZ_NUR_1x" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "RV_BRD"
And I press button "ladetab"
Then the table has 1 rows
And I create a new row at the end of the table
Then the table has 2 rows
And I set field "bezeichner" to "RV_BADEN" in row 2
And I set field "integer" to "0" in row 2
Then saving the current editor throws the exception "5114"
And I close the current editor

Scenario: WerteEindeutig

Given I open an editor "RV_WERT_NUR_1x" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "RV_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
Then the table has 1 rows
And I set field "bezeichner" to "RV_BADEN" in row 1
And I set field "integer" to "0" in row 1
Then saving the current editor throws the exception "351"
And I close the current editor

Scenario: GeloeschtenWertWiederErzeugen

Given I open an editor "RV_DEL_WERT_NEU" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "RV_BRD"
And I press button "ladetab"
Then the table has 1 rows
And I delete row at position 1
Then the table has 0 rows
And I create a new row at the end of the table
Then the table has 1 rows
And I set field "bezeichner" to "RV_BADEN" in row 1
And I set field "integer" to "0" in row 1
And I save the current editor
And I close the current editor
