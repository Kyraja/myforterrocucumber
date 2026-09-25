# *****************************************************************************
#  Name: process_lock_inaktiv.feature
#  Autor: tf
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet das Verhalten von Vorgängen inaktiven Prozesssperrstellen
# *****************************************************************************
@persistent
@Inactive_ProcessLockConfiguration
Feature: Inactive_ProcessLockConfiguration

Given I'm logged in with password "sy"
Scenario: test_inactive_process_locking

Given I open an editor "INACTIVE_PROCESSLOCKCONDIF" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100000"
And I append rows
    | aktiv    | prozesssperrstelle| sperrwirkung |
    | nein     |20014              | Gesperrt     |
And I save the current editor
And I close the current editor

Given I open an editor "INVOICE" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "40001"
And I set field "kl" to "001"
And I set field "budat" to "19950201"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "invoice1" from table "(Sales):(Invoice)" with command "TRANSFER" for record "40001"
And I save the current editor
