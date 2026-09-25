# *****************************************************************************
#  Name: lock_config_tab_textarray.feature
#  Autor: tf
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet das Editieren des Tabellen-Textarrays 
# *****************************************************************************
@persistent
Feature: Manipulation

Given I'm logged in with password "annette"
# Given I enable the flag 46
# Given I set the operation language to "DEUTSCH"

Scenario: test row text array in lock configuration

Given I open an editor "LockableReferences" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "LOCKREFLIST"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
   | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname |
   | V-03-23             | ja                   | artikel         |
   | V-03-24             | ja                   | artikel         |
And I save the current editor
And I close the current editor

Given I open an editor "LockConfig" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCKCONFIG"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "classname" to "Shrotty"
And I create a new row at the end of the table
And I set field "verweissperrstellen" to "LOCKREFLIST" in row 1
And I set field "sperrwirkung" to "gesperrt" in row 1
Then field "maskenpruefung" is modifiable in row 1
And I save the current editor
And I close the current editor

Given I open an editor "UPDATE" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "LOCKCONFIG"
And I set field "sperrhinweisbspr" to "Bitte melden" in row 1
Then field "sperrhinweis" has value "Bitte melden" in row 1
And I save the current editor
And I close the current editor

Given I'm logged in with password "annette"
Given I enable the flag 46
Given I set the operation language to "ENGLISH"

Given I open an editor "UPDATE" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "LOCKCONFIG"
And I set field "sperrhinweisbspr" to "Please report" in row 1
Then field "sperrhinweis" has value "Please report" in row 1
Then field "sperrhinweis2" has value "" in row 1
And I save the current editor
And I close the current editor




