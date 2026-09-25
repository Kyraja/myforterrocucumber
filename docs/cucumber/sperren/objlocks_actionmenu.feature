# *****************************************************************************
#  Name: objlocks_actionmenu.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Legt Testdaten an und prueft Objektsperren-Historie
# *****************************************************************************
@persistent
Feature: ObjectLocksHistory

Background:
   Given I'm logged in with password "admin"

Scenario: Testdata

Given I open an editor "HARDLOCK" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "HARDLOCK"
And I set field "sucherw" to "Hard"
And I set field "classname" to "LockHard"
And I set field "gesperrtegruppe" to "V-02-01"
And I save the current editor
And I close the current editor

Given I open an editor "SOFTLOCK" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "SOFTLOCK"
And I set field "sucherw" to "Soft"
And I set field "classname" to "LockSoft"
And I set field "gesperrtegruppe" to "V-02-01"
And I save the current editor
And I close the current editor

Given I open an editor "AUFZAEHLUNG" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "22001"
And I append rows
   | vaufzelem               |
   | Sperrkonfiguration Hard |
   | Sperrkonfiguration Soft |
And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor

Given I open an editor "PRODUCT" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "such" to "PRODUCT"
And I save the current editor
And I close the current editor

Given I open an editor "LOCKED_PRODUCT" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "such" to "LOCKED_PRODUCT"
And I set field "sperrkonfigurationneu" to "Soft"
And I set field "sperrgrundneu" to "Nur noch wenige lieferbar."
And I save the current editor
And I close the current editor

Given I open an editor "LOCKED_PRODUCT_UPD" from table "(Part):(Product)" with command "UPDATE" for record "LOCKED_PRODUCT"
And I set field "sperrkonfigurationneu" to "Hard"
And I set field "sperrgrundneu" to "Nicht mehr lieferbar."
And I save the current editor
And I close the current editor

################################################################################

Scenario: Actionmenu4UnlockedProduct

Given I open an editor "PRODUCT_VIEW" from table "(Part):(Product)" with command "VIEW" for record "PRODUCT"
And I press button "buaktion" to open a subeditor for "Aktionsmenü"
Then table has values
    | !row                              | tmenuemoeglich | tkommando | tparams |
    | $,,taufrufparameter^nummer==53226 | nein           |           |         |
And I close the current editor
And I switch the current editor to editor "PRODUCT_VIEW"
And I close the current editor

################################################################################

Scenario: Actionmenu4LockedProduct

Given I open an editor "LOCKED_PRODUCT_VIEW" from table "(Part):(Product)" with command "VIEW" for record "LOCKED_PRODUCT"
And I press button "buaktion" to open a subeditor for "Aktionsmenü"
Then I fill template "objlocks_actionmenu.ftl" and append it to output file "ref_objlocks_actionmenu.out"
And I close the current editor
And I switch the current editor to editor "LOCKED_PRODUCT_VIEW"
And I close the current editor

################################################################################

