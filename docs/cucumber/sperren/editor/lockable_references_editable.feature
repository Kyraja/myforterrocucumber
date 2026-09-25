# *****************************************************************************
#  Name: lockable_references_editable.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Feldaenderbarkeiten Verweissperrstellen
# *****************************************************************************
@persistent
@LOCKABLE_REFERENCES_EDITABLE
Feature: Feldaenderbarkeiten_Verweissperrstellen

background
Given I'm logged in with password "sy"

Scenario: Initial

Given I open an editor "LockConfigInitial" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I create a new row at the end of the table
Then field "verweisfeldauswahl" is not modifiable in row 1
And I close the current editor

Scenario: verweisEintragen

Given I open an editor "LockableReferences" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I create a new row at the end of the table
Then field "verweisfeldname" is not modifiable in row 1
Then field "verweisfeldauswahl" is not modifiable in row 1
And I set field "gesperrtegruppe" to "V-02-01" in row 0
Then field "verweisfeldname" is not modifiable in row 1
Then field "verweisfeldauswahl" is not modifiable in row 1
And I set field "verweisfeldingruppe" to "V-03-24" in row 1
Then field "verweisfeldname" is modifiable in row 1
Then field "verweisfeldauswahl" is modifiable in row 1
And I set field "gesperrtegruppe" to "" in row 0
Then field "verweisfeldname" is not modifiable in row 1
Then field "verweisfeldauswahl" is not modifiable in row 1
And I close the current editor

Scenario: VerweisImKopfBedeutetBedingungImKopf

Given I open an editor "ARTIKEL_IN_KOPF" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "ARTIKEL_IN_KOPF"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "namebspr" to "Sperre Nachfolgeartikel"
And I append rows
    | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname  |
    | V-02-01             | nein                 | nachfolgeartikel |
Then field "bedingungsfeldintabelle" is not modifiable in row 1
And I save the current editor
And I close the current editor
