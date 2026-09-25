# *****************************************************************************
#  Name: action_menu.feature
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Buttonklick auf Buttonmenü
# *****************************************************************************
@persistent
@VALUE_LIST_ACTION_MENU
Feature: ACTION_MENU_109:4

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

Scenario: ErzeugeWertemengenBezeichner

Given I open an editor "AM_BRD" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "AM_BRD"
And I set field "classname" to "AmBrd"
And I save the current editor
And I close the current editor

Scenario: ErzeugeBezeichnerBaden

Given I open an editor "AM_BADEN" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "AM_BADEN"
And I set field "classname" to "AmBaden"
And I save the current editor
And I close the current editor

Scenario: ErzeugeWert

Given I open an editor "AM_BADEN" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "AM_BRD"
And I set field "bezeichner" to "AM_BADEN"
And I set field "wtyp" to "Integer"
And I set field "integer" to "1"
And I save the current editor
And I close the current editor

Scenario: ZeigeAktionenZurWertemenge

Given I open an editor "AM_ACTION_HEAD" from table "(ValueSet):(ValueSetIdentifier)" with command "VIEW" for record "AM_BRD"
And I press button "buaktion" to open a subeditor for "Aktionsmenü"
Then I fill template "buttonmenu.ftl" and append it to output file "ref_buttonmenu.out"
And I close the current editor
And I switch the current editor to editor "AM_ACTION_HEAD"
And I close the current editor
