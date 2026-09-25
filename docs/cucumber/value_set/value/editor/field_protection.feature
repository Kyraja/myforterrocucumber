# *****************************************************************************
#  Name: field_protection.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Feldschutze
# *****************************************************************************
@persistent
@VALUE_FIELD_PROTECTION
Feature: FIELD_PROTECTION_109:3

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

Scenario: ErzeugeWertemengenBezeichner

Given I open an editor "FP_BEZ" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "FP_WMBEZ"
And I set field "classname" to "FpValueSetIdentifier"
And I save the current editor
And I close the current editor

Scenario: ErzeugeBezeichner

Given I open an editor "FP_BEZEICHNER" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "FP_BEZEICHNER"
And I set field "classname" to "FpIdentifier"
And I save the current editor
And I close the current editor

Scenario: ErzeugeWert

Given I open an editor "FP_BOOL" from table "(ValueSet):(Value)" with command "NEW" for record ""
Then field "nummer" is not modifiable
Then field "such" is not modifiable
Then field "wert" is not modifiable
Then field "wmbez" is modifiable
Then field "bezeichner" is modifiable
Then field "wtyp" is modifiable
Then field "bool" is modifiable
Then field "integer" is modifiable
Then field "real" is modifiable
Then field "objekt" is modifiable
Then field "kurztxt" is modifiable
Then field "einzlgtxt" is modifiable
Then field "mzlgtxt" is modifiable
Then field "ftext" is modifiable
And I set field "wmbez" to "FP_WMBEZ"
And I set field "bezeichner" to "FP_BEZEICHNER"
And I set field "wtyp" to "Bool"
And I set field "bool" to "true"
And I save the current editor
And I close the current editor

Scenario: ErzeugeWert

Given I open an editor "FP_BOOL" from table "(ValueSet):(Value)" with command "UPDATE" for record "$,wmbez==FP_WMBEZ;bezeichner==FP_BEZEICHNER"
Then field "nummer" is not modifiable
Then field "such" is not modifiable
Then field "wert" is not modifiable
Then field "wmbez" is not modifiable
Then field "bezeichner" is not modifiable
Then field "wtyp" is modifiable
Then field "bool" is modifiable
Then field "integer" is modifiable
Then field "real" is modifiable
Then field "objekt" is modifiable
Then field "kurztxt" is modifiable
Then field "einzlgtxt" is modifiable
Then field "mzlgtxt" is modifiable
Then field "ftext" is modifiable
And I close the current editor
