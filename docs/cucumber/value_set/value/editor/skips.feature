# *****************************************************************************
#  Name: skips.feature
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Skipfelder
# *****************************************************************************
@persistent
@VALUE_SKIPS
Feature: SKIPS_109:3

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

Scenario: ErzeugeWertemengenBezeichner

Given I open an editor "SKIP_BEZ" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "SKIP_WMBEZ"
And I set field "classname" to "SkipValueSetIdentifier"
And I save the current editor
And I close the current editor

Scenario: ErzeugeBezeichner

Given I open an editor "SKIP_BEZEICHNER" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "SKIP_BEZEICHNER"
And I set field "classname" to "SkipIdentifier"
And I save the current editor
And I close the current editor

Scenario: TesteSkipSucherweiterungBeiWerterzeugung

Given I open an editor "SKIP_VALUE" from table "(ValueSet):(Value)" with command "NEW" for record ""
Then field "sucherw" is empty
And I set field "wmbez" to "SKIP_WMBEZ"
And I set field "bezeichner" to "SKIP_BEZEICHNER"
And I set field "bool" to "true"
Then field "sucherw" has value "ja"
And I set field "bool" to "false"
Then field "sucherw" has value "nein"
And I set field "wtyp" to ""
Then field "sucherw" is empty
And I close the current editor
