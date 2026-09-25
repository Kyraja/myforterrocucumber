# *****************************************************************************
#  Name: lockable_process_step_validate_save.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Maskenprüfung des Datensatzes (record_validate_save)
# *****************************************************************************
@persistent
@LOCKABLE_PROCESS_STEP_VALIDATE_SAVE
Feature: CRUD 192:2

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

################################################################################

Scenario: ErzeugePrivilegiertTestdaten

Given I enable the flag 298

Given I open an editor "EINS" from table "(LockConfiguration):(LockableProcessStep)" with command "NEW" for record ""
And I set field "such" to "EINS"
And I set field "gesperrtegruppe" to "V-02-04"
And I set field "prozessstelle" to "Auftragsposition einplanen"
And I save the current editor
And I close the current editor

Given I open an editor "ZWEI" from table "(LockConfiguration):(LockableProcessStep)" with command "NEW" for record "EINS"
And saving the current editor throws the exception "3517"
And I close the current editor

Given I disable the flag 298
