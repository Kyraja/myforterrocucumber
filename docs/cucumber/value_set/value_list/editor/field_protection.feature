# *****************************************************************************
#  Name: field_protection.feature
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Feldschutze
# *****************************************************************************
@persistent
@VALUE_LIST_FIELD_PROTECTION
Feature: FIELD_PROTECTION_109:4

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

Scenario: ErzeugeWertemengenBezeichner

Given I open an editor "FP_BRD" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "FP_BRD"
And I set field "classname" to "FpBrd"
And I save the current editor
And I close the current editor

Scenario: ErzeugeBezeichner

Given I open an editor "FP_BAYERN" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "FP_BAYERN"
And I set field "classname" to "FpBayern"
And I save the current editor
And I close the current editor

Scenario: ErzeugeWert

Given I open an editor "FP_BAYERN" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FP_BRD"
And I set field "bezeichner" to "FP_BAYERN"
And I set field "wtyp" to "Integer"
And I set field "integer" to "1"
And I save the current editor
And I close the current editor

Scenario: LeereWertelisteZumBearbeiten

Given I open an editor "FP_Werteliste" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
Then field "nummer" is not modifiable
Then field "such" is not modifiable
Then field "wmbezeichner" is modifiable
Then field "wmbezeichner" is empty
Then field "ladetab" is not modifiable
Then the table has 0 rows
And I close the current editor

Scenario: LeereWertelisteZumZeigen

Given I open an editor "FP_Werteliste" from table "(ValueSet):(ValueList)" with command "VIEW" for record ""
Then field "nummer" is not modifiable
Then field "such" is not modifiable
Then field "wmbezeichner" is modifiable
Then field "wmbezeichner" is empty
Then field "ladetab" is not modifiable
Then the table has 0 rows
And I close the current editor

Scenario: WertelisteBRDZumZeigen

Given I open an editor "FP_Werteliste" from table "(ValueSet):(ValueList)" with command "VIEW" for record ""
And I set field "wmbezeichner" to "FP_BRD"
Then the table has 0 rows
Then field "ladetab" is modifiable
And I press button "ladetab"
Then the table has 1 rows
Then field "wert" is not modifiable in row 1
Then field "wmbez" is not modifiable in row 1
Then field "bezeichner" is not modifiable in row 1
Then field "wtyp" is not modifiable in row 1
Then field "bool" is not modifiable in row 1
Then field "integer" is not modifiable in row 1
Then field "real" is not modifiable in row 1
Then field "objekt" is not modifiable in row 1
Then field "kurztxt" is not modifiable in row 1
Then field "einzlgtxt" is not modifiable in row 1
Then field "mzlgtxt" is not modifiable in row 1
Then field "ftext" is not modifiable in row 1
Then field "wmbezeichner" is modifiable
Then field "ladetab" is modifiable
And I close the current editor

Scenario: WertelisteBRDZumBearbeiten

Given I open an editor "FP_Werteliste" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FP_BRD"
Then the table has 0 rows
Then field "ladetab" is modifiable
And I press button "ladetab"
Then the table has 1 rows
Then field "wert" is not modifiable in row 1
Then field "wmbez" is not modifiable in row 1
Then field "bezeichner" is not modifiable in row 1
Then field "wtyp" is modifiable in row 1
Then field "bool" is modifiable in row 1
Then field "integer" is modifiable in row 1
Then field "real" is modifiable in row 1
Then field "objekt" is modifiable in row 1
Then field "kurztxt" is modifiable in row 1
Then field "einzlgtxt" is modifiable in row 1
Then field "mzlgtxt" is modifiable in row 1
Then field "ftext" is modifiable in row 1
And I create a new row at the end of the table
Then the table has 2 rows
Then field "wert" is not modifiable in row 2
Then field "wmbez" is not modifiable in row 2
Then field "bezeichner" is modifiable in row 2
Then field "wtyp" is modifiable in row 2
Then field "bool" is modifiable in row 2
Then field "integer" is modifiable in row 2
Then field "real" is modifiable in row 2
Then field "objekt" is modifiable in row 2
Then field "kurztxt" is modifiable in row 2
Then field "einzlgtxt" is modifiable in row 2
Then field "mzlgtxt" is modifiable in row 2
Then field "ftext" is modifiable in row 2
Then field "wmbezeichner" is modifiable
Then field "ladetab" is modifiable
And I close the current editor
