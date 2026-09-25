# *****************************************************************************
#  Name: lock_config_editable.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Feldaenderbarkeiten Sperrkonfiguration
# *****************************************************************************
@persistent
@LOCK_CONFIG_EDITABLE
Feature: Feldaenderbarkeiten_Sperrkonfig

background
Given I'm logged in with password "sy"

Scenario: Initial

Given I open an editor "LockConfigInitial" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
Then field "tabellenvorlage" is not modifiable in row 0
And I set field "gesperrtegruppe" to "V-02-01"
Then field "tabellenvorlage" is modifiable in row 0
And I create a new row at the end of the table
Then field "maskenpruefung" is not modifiable in row 1
And I close the current editor

Scenario: verweissperrstellenAnlegen

Given I open an editor "LockableReferences" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "MYLOCKREFLIST"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
   | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname |
   | V-03-23             | ja                   | artikel         |
   | V-03-24             | ja                   | artikel         |
And I save the current editor
And I close the current editor

Scenario: verweissperrstellenEintragen

Given I open an editor "LockConfig" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "classname" to "Shrotty"
And I create a new row at the end of the table
And I set field "verweissperrstellen" to "MYLOCKREFLIST" in row 1
Then field "maskenpruefung" is modifiable in row 1
And I close the current editor
