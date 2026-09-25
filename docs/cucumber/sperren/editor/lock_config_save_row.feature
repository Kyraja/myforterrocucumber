# *****************************************************************************
#  Name: lock_config_save_row.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet Durchführung des Abschnitts [record_validate_save_row]
# *****************************************************************************
@persistent
@RECORD_VALIDATE_SAVE_ROW
Feature: CRUD 192:1

  Background:
    And I set the operation language to "de"
    Given I'm logged in with password "sy"
    Given I disable the flag 298

Scenario: Zeilenvalidierung

# Das Speichern des neuen Datensatzes scheitert, weil die angefügte Zeile nicht
# leer, aber unvollständig ist. Die Zeilenprüfung wird durchgeführt.

Given I open an editor "CREATE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "PLOCKNOTE"
And I set field "classname" to "BlameProduct"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "sperrwirkung" to "Hinweis" in row !lastRow
And saving the current editor throws the exception "4807"


Scenario: Keine_Zeilenvalidierung

# Das Speichern des neuen Datensatzes ist erfolgreich, weil die angefügte Zeile leer ist.
# Die Zeilenprüfung wird in diesem Fall nicht durchgeführt.

Given I open an editor "CREATE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "PLOCK"
And I set field "classname" to "BlockProduct"
And I set field "gesperrtegruppe" to "V-02-01"
And I create a new row at the end of the table
And I set field "aktiv" to "Nein" in row !lastRow
And I save the current editor
