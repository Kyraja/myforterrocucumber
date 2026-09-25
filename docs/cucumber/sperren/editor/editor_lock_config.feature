# *****************************************************************************
#  Name: editor_lock_config.feature
#  Autor: tf
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet den Editor der Sperrkonfiguration
# *****************************************************************************
@persistent
@CRUD_LOCK_CONFIGURATION_TEST
Feature: CRUD 192:1

Scenario: classname 

Given I'm logged in with password "sy"

Given I open an editor "CREATE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "CREATE"
And I set field "nummer" to "100000"
And I set field "classname" to "ArtikelSperre"
And I set field "gesperrtegruppe" to "V-02-01"
And I save the current editor
And I close the current editor

# Maskenprüfung scheitert wegen mehrdeutiger Klassennamen
Given I open an editor "CREATE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "CREATE"
And I set field "nummer" to "100001"
And I set field "classname" to "ArtikelSperre"
And I set field "gesperrtegruppe" to "V-02-01"
And saving the current editor throws the exception "8222"
And I close the current editor

Given I open an editor "UPDATE" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "CREATE"
And I save the current editor
And I close the current editor

