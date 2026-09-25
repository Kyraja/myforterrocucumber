# *****************************************************************************
#  Name: crud_lock_field_validation.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet Feldvalidierungen beim Editieren von Sperrkonfigurationen
# *****************************************************************************
@persistent
@LOCK_CONFIGURATION_FIELD_VALIDATION_TEST
Feature: CRUD 192:1

  Background:
    And I set the operation language to "Deutsch"
    Given I'm logged in with password "sy"
    Given I disable the flag 298

Scenario: Field_validations

# Pflichtfelder
Given I open an editor "CREATE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And saving the current editor throws the exception "10179"
# Funktioniert nicht.
# Zum einen doppelter Text auf cucumber-Seite, zum anderen tut der diff auch nicht bei Verdoppelung hier.
#"""
#Vorgang abgebrochen
#Folgende Pflichtfelder sind nicht ausgefüllt:
#Suchwort
#Datenbankgruppe der gesperrten Objekte
#Java-Klassenname
#Sperrwirkung
#Suchwort bitte eintragen
#Folgende Pflichtfelder sind nicht ausgefüllt:
#Suchwort
#Datenbankgruppe der gesperrten Objekte
#Java-Klassenname
#Sperrwirkung
#Suchwort bitte eintragen
#"""
And I close the current editor

# Selektionsbedingungen
Given I open an editor "CREATE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And setting field "gesperrtegruppe" to "V-65-01" throws the exception "1361"
And I close the current editor

Given I enable the flag 298

Given I open an editor "CREATE" from table "(LockConfiguration):(LockableProcessStep)" with command "NEW" for record ""
And setting field "gesperrtegruppe" to "V-65-01" throws the exception "1361"
And I close the current editor

Given I disable the flag 298

Given I open an editor "CREATE" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And setting field "gesperrtegruppe" to "V-65-01" throws the exception "1361"
And I close the current editor

# Andere Feldprüfungen
Given I open an editor "CREATE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And setting field "classname" to "§keinKlassenname" throws the exception "8228"
And I close the current editor
