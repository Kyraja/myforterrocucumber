# *****************************************************************************
#  Name: lockable_references_zulaessig.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Zulässigkeit des Datensatzes
# *****************************************************************************
@persistent
@LOCKABLE_REFERENCES_ZULAESSIG
Feature: CRUD 192:3

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

################################################################################

Scenario: ErzeugePrivilegiertTestdaten

# Lieferdaten anlegen geht nur mit Zauberflagge

Given I enable the flag 298

Given I open an editor "STANDARD1" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "nummer" to "11"
And I set field "such" to "STANDARD1"
And I set field "gesperrtegruppe" to "V-02-01"
And I save the current editor
And I close the current editor

Given I open an editor "STANDARD2" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record "STANDARD1"
And I set field "nummer" to "12"
And I set field "such" to "STANDARD2"
And I save the current editor
And I close the current editor

# Sonstige Verweissperrstellen kann der Kunde sonst anlegen

Given I disable the flag 298

Given I open an editor "INDIVIDUAL1" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "nummer" to "100001"
And I set field "such" to "INDIVIDUAL1"
And I set field "gesperrtegruppe" to "V-02-01"
And I save the current editor
And I close the current editor

Given I open an editor "INDIVIDUAL2" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record "INDIVIDUAL1"
And I set field "nummer" to "100002"
And I set field "such" to "INDIVIDUAL2"
And I save the current editor
And I close the current editor

################################################################################

Scenario: AktionenNichtPrivilegiert

# Der Kunde darf alle Datensätze kopieren

Given I open an editor "COPY_STANDARD1" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record "STANDARD1"
And I set field "such" to "COPY_STANDARD1"
And I save the current editor
And I close the current editor

Given I open an editor "COPY_INDIVIDUAL1" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record "INDIVIDUAL1"
And I set field "such" to "COPY_INDIVIDUAL1"
And I save the current editor
And I close the current editor

# Der Kunde darf Lieferdaten nicht löschen oder ändern

Given opening an editor from table "(LockConfiguration):(LockableReferences)" with command "UPDATE" for record "STANDARD1" throws the exception "3560"
Given opening an editor from table "(LockConfiguration):(LockableReferences)" with command "DELETE" for record "STANDARD1" throws the exception "3560"

# Der Kunde darf eigene Datensätze löschen, ändern und zeigen (zeigen auch bei Lieferdaten).

Given I open an editor "UPDATE_COPY_INDIVIDUAL1" from table "(LockConfiguration):(LockableReferences)" with command "UPDATE" for record "COPY_INDIVIDUAL1"
And I set field "such" to "LOESCH_MICH"
And I save the current editor
And I close the current editor

Given I open an editor "DELETE_LOESCH_MICH" from table "(LockConfiguration):(LockableReferences)" with command "DELETE" for record "LOESCH_MICH"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Given I open an editor "VIEW" from table "(LockConfiguration):(LockableReferences)" with command "VIEW" for record "STANDARD1"
And field "nummer" has value "11"
And I close the current editor

Given I open an editor "VIEW" from table "(LockConfiguration):(LockableReferences)" with command "VIEW" for record "INDIVIDUAL1"
And field "nummer" has value "100001"
And I close the current editor


################################################################################

Scenario: AktionenPrivilegiert

# Privilegiert darf man alles

Given I enable the flag 298

Given I open an editor "UPDATE" from table "(LockConfiguration):(LockableReferences)" with command "UPDATE" for record "STANDARD2"
And I set field "such" to "LOESCHMICH"
And I save the current editor
And I close the current editor

Given I open an editor "VIEW" from table "(LockConfiguration):(LockableReferences)" with command "VIEW" for record "LOESCHMICH"
And field "nummer" has value "12"
And I close the current editor

Given I open an editor "DELETE" from table "(LockConfiguration):(LockableReferences)" with command "DELETE" for record "LOESCHMICH"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Given I open an editor "UPDATE" from table "(LockConfiguration):(LockableReferences)" with command "UPDATE" for record "INDIVIDUAL2"
And I set field "such" to "LOESCHMICH"
And I save the current editor
And I close the current editor

Given I open an editor "VIEW" from table "(LockConfiguration):(LockableReferences)" with command "VIEW" for record "LOESCHMICH"
And field "nummer" has value "100002"
And I close the current editor

Given I open an editor "DELETE" from table "(LockConfiguration):(LockableReferences)" with command "DELETE" for record "LOESCHMICH"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Given I disable the flag 298
