# *****************************************************************************
#  Name: lock_config_skips.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet Skip-Behandlungen in der Sperrkonfigurationen
# *****************************************************************************
@persistent
@LOCK_CONFIGURATION_SKIP_TEST
Feature: CRUD 192:1

Given I'm logged in with password "annette"
Given I disable the flag 298

Scenario: Skips

Given I open an editor "SKIPS" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "SKIPS"
Then field "gesperrtegruppename" has value "" in row 0
And I set field "gesperrtegruppe" to "V-02-01"
Then field "gesperrtegruppename" has value "Artikel" in row 0
And I set field "gesperrtegruppe" to ""
Then field "gesperrtegruppename" is empty in row 0
And I close the current editor
