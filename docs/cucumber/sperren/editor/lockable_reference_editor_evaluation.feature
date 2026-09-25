# *****************************************************************************
#  Name:lockable_reference_editor_evaluation.feature
#  Autor: tf
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Konfigurierbare Maskenprüfung für Verweissperrstellen
# *****************************************************************************
@persistent
Feature: Editor evaluation

Scenario: Editor evaluation of lockable refs

Given I'm logged in with password "sy"

Given I open an editor "Part" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "Artikelhinweis"
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

Given I open an editor "INVOICE" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "40002"
And I set field "kl" to "001"
And I set field "budat" to "19950201"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "Part" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "Artikelsperre"
And I save the current editor
And I close the current editor

Given I open an editor "LockableReferenz" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "V-02-01-VERKAUF-LOCK"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I append rows
   | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname |
   | v-03-24              | ja                  | artikel         |
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100000"
And I create a new row at the end of the table
And I set field "verweissperrstellen" to "V-02-01-VERKAUF-LOCK" in row 1
And I set field "maskenpruefung" to "true" in row 1
And I set field "sperrwirkung" to "Gesperrt" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "INVOICE" from table "(Sales):(Invoice)" with command "UPDATE" for record "40001"
And I set field "bem" to "Sperr-Maskenpruefung aktiv"
And saving the current editor throws the exception "2743"
And I close the current editor

Given I open an editor "INVOICE" from table "(Sales):(Invoice)" with command "UPDATE" for record "40002"
And saving the current editor throws the exception "4806"
And I close the current editor

Given I open an editor "INVOICE" from table "(Sales):(Invoice)" with command "MODIFY" for record "40002"
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100000"
And I set field "aktiv" to "nein" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "INVOICE" from table "(Sales):(Invoice)" with command "UPDATE" for record "40001"
And I set field "bem" to "Sperr-Maskenpruefung inaktiv"
And I save the current editor
And I close the current editor
