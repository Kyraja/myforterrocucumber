# *****************************************************************************
#  Name: ident_lock_config.feature
#  Autor: tf
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Identnummernvergabe von Sperrkonfigurationen
# *****************************************************************************
@persistent
@IDENT_LOCK_CONFIGURATION_TEST
Feature: CRUD 192:1

Scenario: Standarduser

Given I'm logged in with password "sy"

Given I open an editor "CREATE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "CREATE"
And I set field "nummer" to "100000"
And I set field "classname" to "ArtikelSperre"
And I set field "gesperrtegruppe" to "V-02-01"
And I save the current editor

Given I open an editor "CREATE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And setting field "nummer" to "500" throws the exception "10634"
And I close the current editor

Given I open an editor "CREATE" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "CREATE"
And setting field "nummer" to "2000" throws the exception "10634"
And I close the current editor

Scenario: Maintenance and flag 298

Given I'm logged in with password "annette"
Given I enable the flag 298

Given I open an editor "CREATE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "CREATE"
And I set field "nummer" to "500"
And I set field "classname" to "ArtikelSperre2"
And I set field "gesperrtegruppe" to "V-02-01"
And I save the current editor
And I close the current editor

Given I open an editor "CREATE" from table "(LockConfiguration):(LockableProcessStep)" with command "NEW" for record ""
And I set field "such" to "CREATE"
And I set field "nummer" to "1000"
And I set field "gesperrtegruppe" to "V-02-04"
And I set field "prozessstelle" to "Auftragsposition einplanen"
And I save the current editor
And I close the current editor

Given I open an editor "CREATE" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "CREATE"
And I set field "nummer" to "2000"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
   | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname |
   | V-03-24             | ja                   | artikel         |
And I save the current editor
And I close the current editor
