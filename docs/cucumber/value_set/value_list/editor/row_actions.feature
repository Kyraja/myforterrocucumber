# *****************************************************************************
#  Name: row_actions.feature
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Zeilenaktionen
# *****************************************************************************
@persistent
@VALUE_LIST_ROW_ACTIONS
Feature: ROW_ACTIONS_109:4

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

Scenario: ErzeugeWertemengenBezeichner

Given I open an editor "RA_BRD" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "RA_BRD"
And I set field "classname" to "RaBrd"
And I save the current editor
And I close the current editor

Scenario: ErzeugeBezeichner

Given I open an editor "RA_BAYERN" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "RA_BAYERN"
And I set field "classname" to "RaBayern"
And I save the current editor
And I close the current editor

Scenario: ErzeugeWert

Given I open an editor "RA_BAYERN" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "RA_BRD"
And I set field "bezeichner" to "RA_BAYERN"
And I set field "wtyp" to "Integer"
And I set field "integer" to "1"
And I save the current editor
And I close the current editor

Scenario: ZeileAddierenScheitert

Given I open an editor "RA_INSERT" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to ""
Then the table has 0 rows
Then creating a new row at position 1 throws the exception "294"
Then the table has 0 rows
And I close the current editor

Scenario: ZeileAddierenOk

Given I open an editor "RA_INSERT" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "RA_BRD"
And I create a new row at the end of the table
Then the table has 1 rows
Then field "wmbez^such" has value "RA_BRD" in row 1
And I close the current editor

Scenario: ZeileEntfernen

Given I open an editor "RA_DELETE" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "RA_BRD"
And I press button "ladetab"
Then the table has 1 rows
And I delete row at position 1
Then the table has 0 rows
And I close the current editor

Scenario: ZeileVerschieben

Given I open an editor "RA_MOVE" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "RA_BRD"
And I press button "ladetab"
Then the table has 1 rows
And I create a new row at the end of the table
Then the table has 2 rows
Then field "bezeichner" is not empty in row 1
And I move rows "2" to position "1"
Then field "bezeichner" is empty in row 1
And I close the current editor
