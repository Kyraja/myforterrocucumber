# *****************************************************************************
#  Name: lockable_references.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet Editor der Verweissperrstellen
# *****************************************************************************
@persistent
@LOCKABLE_REFERENCES
Feature: CRUD 192:3

Given I'm logged in with password "annette"

Scenario: CREATE

Given I open an editor "LR_CREATE" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "LR_CREATE"
And I set field "gesperrtegruppe" to "V-02-01"
And I append rows
   | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname |
   | V-03-24             | ja                   | artikel         |
Then field "verweisfeldbedeutung" has value "Artikel" in row 1
And I save the current editor
And I close the current editor

Scenario: COPY

Given I open an editor "LR_COPY" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record "LR_CREATE"
And I set field "such" to "LR_COPY"
And I save the current editor
And I close the current editor

Scenario: READ

Given I open an editor "LR_READ" from table "(LockConfiguration):(LockableReferences)" with command "VIEW" for record "LR_COPY"
Then field "gesperrtegruppe" has value "V-02-01" in row 0
And I save the current editor
And I close the current editor

Scenario: UPDATE

Given I open an editor "LR_UPDATE" from table "(LockConfiguration):(LockableReferences)" with command "UPDATE" for record "LR_COPY"
And I set field "such" to "LR_UPDATE"
And I set field "gesperrtegruppe" to "V-02-04"
And I save the current editor
And I close the current editor

Scenario: DELETE

Given I open an editor "LR_DELETE" from table "(LockConfiguration):(LockableReferences)" with command "DELETE" for record "LR_UPDATE"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor
