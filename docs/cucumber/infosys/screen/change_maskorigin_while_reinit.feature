# *****************************************************************************
#  Name           : change_maskorigin_while_reinit.feature
#  Autor          : fwester
#  Verantwortlich : @forterro-prd/t024-abas-core
#  Funktion       : Testet das Aendern der Maskenentstehung im Rahmen
# der Reinitialisierung (Upgrade, Update etc.)
# *****************************************************************************
@persistent
@CHANGE_MASKORIGIN_WHILE_REINIT_TEST
Feature: CRUD 65:1

Scenario: Create new infosystem with a automatically maintained screen and export.

Given I'm logged in with password "sy"
Given I open an editor "Infosystem neu" from table "(Infosystem):(Infosystem)" with command "NEW" for record ""
And I set field "such" to "MASKORIGIN"
And I set field "name1" to "CHANGE_MASKORIGIN_WHILE_REINIT"
And I set field "arb" to "ow1"
And I set field "maskorigin" to "Automatisch erzeugen"
And I set field "layoutorigin" to "Keine Ausgabe"
And I modify table
    | !row | inmask |
    | vname=='isbstart' | 1 |
    | vname=='isisref' | 1 |
And I respond with answer "nein" to the dialog with id "7576"
And I press button "buexport"
And I close the current editor

################################################################################

Scenario: Edit infosystem and export with individual changes

Given I'm logged in with password "sy"
Given I open an editor "Infosystem neu" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "MASKORIGIN"
And I press button "buexportanpass"
And I close the current editor

################################################################################

Scenario: Change maskorigin to manually maintained and reinit infosystem

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "MASKORIGIN"
And I set field "maskorigin" to "Manuell pflegen"
And I save the current editor
And I close the current editor
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "MASKORIGIN"
And I respond with answer "Ja" to the dialog with id "9968"
# And I respond with answer "Nein" to the dialog with id "4552"
And I press button "bureinit"
# And I set field "maskorigin" to "Manuell pflegen"
And I save the current editor
And I close the current editor

################################################################################

Scenario: Change maskorigin to manually maintained and reinit infosystem with individual changes

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "MASKORIGIN"
And I set field "maskorigin" to "Manuell pflegen"
And I save the current editor
And I close the current editor
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "MASKORIGIN"
And I respond with answer "Ja" to the dialog with id "9968"
And I press button "bureinitanpass"
And I save the current editor
And I close the current editor

################################################################################

Scenario: Change maskorigin to manually maintained and upgrade infosystem

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "MASKORIGIN"
And I set field "maskorigin" to "Manuell pflegen"
And I save the current editor
And I close the current editor
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "MASKORIGIN"
And I respond with answer "Ja" to the dialog with id "9968"
And I press button "buupgrade"
And I save the current editor
And I close the current editor

################################################################################

Scenario: Change maskorigin to manually maintained and upgrade infosystem with individual changes

Given I'm logged in with password "sy"
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "MASKORIGIN"
And I set field "maskorigin" to "Manuell pflegen"
And I save the current editor
And I close the current editor
Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "MASKORIGIN"
And I respond with answer "Ja" to the dialog with id "9968"
And I press button "buupgradeanpass"
And I save the current editor
And I close the current editor
