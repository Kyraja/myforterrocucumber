# *****************************************************************************
#  Name: lockable_process_step_zulaessig.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Zulässigkeit des Datensatzes
# *****************************************************************************
@persistent
@LOCKABLE_PROCESS_STEP_ZULAESSIG
Feature: CRUD 192:2

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

################################################################################

Scenario: ErzeugePrivilegiertTestdaten

Given I enable the flag 298

Given I open an editor "STANDARD2" from table "(LockConfiguration):(LockableProcessStep)" with command "NEW" for record "20021"
And I set field "nummer" to "12"
And I set field "such" to "STANDARD2"
And I set field "gesperrtegruppe" to "V-02-05"
And I save the current editor
And I close the current editor

Given I open an editor "INDIVIDUAL1" from table "(LockConfiguration):(LockableProcessStep)" with command "NEW" for record ""
And I set field "nummer" to "100001"
And I set field "such" to "INDIVIDUAL1"
And I set field "gesperrtegruppe" to "V-02-05"
And I set field "prozessstelle" to "Einkaufslieferschein verbuchen"
And I save the current editor
And I close the current editor

Given I open an editor "INDIVIDUAL2" from table "(LockConfiguration):(LockableProcessStep)" with command "NEW" for record "INDIVIDUAL1"
And I set field "nummer" to "100002"
And I set field "such" to "INDIVIDUAL2"
And I set field "gesperrtegruppe" to "V-05-01"
And I save the current editor
And I close the current editor

Given I disable the flag 298

################################################################################

Scenario: AktionenNichtPrivilegiert

Given opening an editor from table "(LockConfiguration):(LockableProcessStep)" with command "NEW" for record "" throws the exception "40"
Given opening an editor from table "(LockConfiguration):(LockableProcessStep)" with command "NEW" for record "20021" throws the exception "40"
Given opening an editor from table "(LockConfiguration):(LockableProcessStep)" with command "NEW" for record "INDIVIDUAL1" throws the exception "40"

Given opening an editor from table "(LockConfiguration):(LockableProcessStep)" with command "UPDATE" for record "20021" throws the exception "3560"
Given opening an editor from table "(LockConfiguration):(LockableProcessStep)" with command "UPDATE" for record "INDIVIDUAL1" throws the exception "40"

Given opening an editor from table "(LockConfiguration):(LockableProcessStep)" with command "DELETE" for record "20021" throws the exception "3560"
Given opening an editor from table "(LockConfiguration):(LockableProcessStep)" with command "DELETE" for record "INDIVIDUAL1" throws the exception "40"

Given I open an editor "VIEW" from table "(LockConfiguration):(LockableProcessStep)" with command "VIEW" for record "20021"
And field "nummer" has value "20021"
And I close the current editor
Given I open an editor "VIEW" from table "(LockConfiguration):(LockableProcessStep)" with command "VIEW" for record "INDIVIDUAL1"
And field "nummer" has value "100001"
And I close the current editor


################################################################################

Scenario: AktionenPrivilegiert

Given I enable the flag 298

Given I open an editor "UPDATE" from table "(LockConfiguration):(LockableProcessStep)" with command "UPDATE" for record "STANDARD2"
And I set field "such" to "LOESCHMICH"
And I save the current editor
And I close the current editor

Given I open an editor "VIEW" from table "(LockConfiguration):(LockableProcessStep)" with command "VIEW" for record "LOESCHMICH"
And field "nummer" has value "12"
And I close the current editor

Given I open an editor "DELETE" from table "(LockConfiguration):(LockableProcessStep)" with command "DELETE" for record "LOESCHMICH"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Given I open an editor "UPDATE" from table "(LockConfiguration):(LockableProcessStep)" with command "UPDATE" for record "INDIVIDUAL2"
And I set field "such" to "LOESCHMICH"
And I save the current editor
And I close the current editor

Given I open an editor "VIEW" from table "(LockConfiguration):(LockableProcessStep)" with command "VIEW" for record "LOESCHMICH"
And field "nummer" has value "100002"
And I close the current editor

Given I open an editor "DELETE" from table "(LockConfiguration):(LockableProcessStep)" with command "DELETE" for record "LOESCHMICH"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Given I disable the flag 298
