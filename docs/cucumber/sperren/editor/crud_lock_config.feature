# *****************************************************************************
#  Name: crud_lock_config.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet das Editieren von Sperrkonfigurationen
# *****************************************************************************
@persistent
@CRUD_LOCK_CONFIGURATION_TEST
Feature: CRUD 192:1

Given I'm logged in with password "annette"
Given I disable the flag 298

Scenario: CRUD
# Testablauf
## C Erzeugen Datensatz CREATE
## R Lesen Datensatz CREATE
## U Ändern Suchwort UPDATE
## D Löschen Datensatz UPDATE

Given I open an editor "CREATE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "CREATE"
And I set field "nummer" to "100000"
And I set field "classname" to "ArtikelSperre"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "icontext" to "icon:lock"
And I save the current editor
And I close the current editor

Given I open an editor "READ" from table "(LockConfiguration):(LockConfiguration)" with command "VIEW" for record "CREATE"
Then field "nummer" has value "100000" in row 0
Then field "such" has value "CREATE" in row 0
And I close the current editor

Given I open an editor "UPDATE" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "CREATE"
And I set field "such" to "UPDATE"
And I set field "classname" to "ArtikelSperreUpdate"
And I save the current editor
And I close the current editor

Given I open an editor "DELETE" from table "(LockConfiguration):(LockConfiguration)" with command "DELETE" for record "UPDATE"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor


Scenario: CRUD Ablage
# Testablauf
## C Erzeugen Datensatz COPY (aus oben geloeschtem)
## R Lesen Datensatz UPDATE (der oben geloeschte)
## R Lesen Datensatz COPY
## U Ändern Datensatz UPDATE (der oben geloeschte) FEHLER
## D Löschen Datensatz UPDATE (der oben geloeschte). Mehrfach Loeschen geht.

Given I open an editor "CREATE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record "UPDATE;@ablage=abgelegt"
Then field "classname" is empty in row 0
And I set field "such" to "COPY"
And I set field "classname" to "ArtikelSperreCopy"
And I save the current editor
And I close the current editor

Given I open an editor "READ copy" from table "(LockConfiguration):(LockConfiguration)" with command "VIEW" for record "COPY"
# Der Nummernzaehler vergibt gleich wieder die freigewordene Nummer 100000
Then field "nummer" has value "100000" in row 0
Then field "such" has value "COPY" in row 0
Then field "ablagef" has value "nein" in row 0
And I close the current editor

Given I open an editor "READ deleted" from table "(LockConfiguration):(LockConfiguration)" with command "VIEW" for record "UPDATE;@ablage=abgelegt"
Then field "nummer" has value "100000" in row 0
Then field "such" has value "UPDATE" in row 0
And I close the current editor

Then opening an editor from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "UPDATE;@ablage=abgelegt" throws the exception "1582"

Given I open an editor "DELETE" from table "(LockConfiguration):(LockConfiguration)" with command "DELETE" for record "UPDATE;@ablage=abgelegt"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor
