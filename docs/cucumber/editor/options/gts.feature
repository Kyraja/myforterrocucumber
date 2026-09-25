# *****************************************************************************
#  Name           : gts.feature
#  Verantwortlich : @forterro-prd/t024-abas-core
#  Funktion       : Tests für Editorstatus gts
# Für Status CONFIRMCANCEL* in confirm_cancel.feature nachschauen.
# *****************************************************************************
@persistent
@GTS_TEST
Feature: GTS

  Background:
    Given I'm logged in with password "sy"

################################################################################

Scenario: Create new infosystem

Given I open an editor "GTS" from table "(Infosystem):(Infosystem)" with command "NEW" for record ""
And I set field "such" to "GTS"
And I set field "arb" to "owdemo"
And I set field "maskorigin" to "Automatisch erzeugen"
And I set field "layoutorigin" to "Keine Ausgabe"
And I save the current editor
And I close the current editor

################################################################################

Scenario: Get editor status in a running infosystem and subeditor

Given I open the infosystem "GTS"
Then editor status "CAPABILITY" has value "FULL"
And I press button "budruck" to open a subeditor for "Druckdialog"
Then editor status "CAPABILITY" has value "FULL"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

################################################################################

Scenario: Get editor status while deleting record using the editor
Given I open an editor "DELETE_GTS" from table "(Infosystem):(Infosystem)" with command "DELETE" for record "GTS"
Then editor status "CAPABILITY" has value "LIMITED"
And I close the current editor

################################################################################

Scenario: Get editor status with no editor

And I run Scheduling
Then editor status "CAPABILITY" has value "NONE"
And I close the current editor

################################################################################

Scenario: Get editor status in a sml editor

Given I open an editor "Product" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "sach" to "0s"
And I press button "bmerk" to open a subeditor for "Sml"
Then editor status "CAPABILITY" has value "FULL"
And I close the current subeditor to switch back to the parent editor
And I close the current editor
