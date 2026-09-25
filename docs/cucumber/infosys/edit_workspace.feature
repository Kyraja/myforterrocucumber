# *****************************************************************************
#  Name           : edit_workspace.feature
#  Autor          : fwester
#  Verantwortlich : @forterro-prd/t024-abas-core
#  Funktion       : Testet das Editieren des Arbeitsbereiches
# *****************************************************************************
@persistent
@EDIT_WORKSPACE_TEST
Feature: CRUD 65:1

Scenario: Erzeuge neue Infosystemstammdaten

Given I'm logged in with password "sy"
Given I open an editor "Infosystem neu" from table "(Infosystem):(Infosystem)" with command "NEW" for record ""
And I set field "such" to "WORKSPACE"
And I set field "arb" to "ow1"
And I set field "maskorigin" to "Automatisch erzeugen"
And I set field "layoutorigin" to "Keine Ausgabe"
And I modify table
    | !row                  | inmask |
    | vname=='isbstart'     | 1      |
And I save the current editor
And I close the current editor

################################################################################

Scenario: Fehler 131, weil ein unbekannter Arbeitsbereich eingetragen wird

Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "WORKSPACE"
And setting field "arb" to "xylophone" in row 0 throws the exception "131"
And I close the current editor

################################################################################

Scenario: Fehler 10179, weil mit leerem Arbeitsbereich gespeichert wird

Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "WORKSPACE"
And I set field "arb" to ""
Then saving the current editor throws the exception "10179"
And I close the current editor

Scenario: Fehler 10179, weil mit Arbeitsbereich aus Leerraeumen gespeichert wird

Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "WORKSPACE"
And I set field "arb" to " 	"
Then saving the current editor throws the exception "10179"
And I close the current editor

################################################################################

Scenario: Fehler 10826, weil ein Standardarbeitsbereich eingetragen wird

Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "WORKSPACE"
And setting field "arb" to "sy" in row 0 throws the exception "10826"
And I close the current editor

################################################################################

Scenario: Wir erstellen ein geliefertes Infosystem mit Standardarbeitsbereich

Given I enable the flag 298
Given I open an editor "Infosystem neu" from table "(Infosystem):(Infosystem)" with command "NEW" for record ""
And I set field "nummer" to "10000"
And I set field "such" to "STDWORKSPACE"
And I set field "namebspr" to "Standardinfosystem"
And I set field "arb" to "sy"
And I set field "classname" to "StandardInfosystem"
And I set field "maskorigin" to "Automatisch erzeugen"
And I set field "layoutorigin" to "Keine Ausgabe"
And I modify table
    | !row                  | inmask |
    | vname=='isbstart'     | 1      |
And I save the current editor
And I close the current editor
Given I disable the flag 298

################################################################################

Scenario: Wir erstellen ein individuelles Infosystem, aber mit Standardarbeitsbereich

Given I enable the flag 298
Given I open an editor "Infosystem neu" from table "(Infosystem):(Infosystem)" with command "NEW" for record ""
And I set field "such" to "YWORKSPACE"
And I set field "arb" to "sy"
And I set field "maskorigin" to "Automatisch erzeugen"
And I set field "layoutorigin" to "Keine Ausgabe"
And I modify table
    | !row                  | inmask |
    | vname=='isbstart'     | 1      |
And I save the current editor
And I close the current editor
Given I disable the flag 298

################################################################################

Scenario: Fehler 10826, weil ein anderer Standardarbeitsbereich wie vorher eingetragen wird

Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "YWORKSPACE"
Then field "arb" has value "sy"
And setting field "arb" to "ek" in row 0 throws the exception "10826"
And I close the current editor

################################################################################

Scenario: Kein Fehler, weil derselbe Standardarbeitsbereich wie vorher eingetragen wird

Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "YWORKSPACE"
Then field "arb" has value "sy"
And I set field "arb" to "sy"
And I save the current editor
And I close the current editor

Scenario: Kein Fehler, weil im LU derselbe Standardarbeitsbereich wie vorher gespeichert wird

Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "STDWORKSPACE"
Then field "arb" has value "sy"
And I save the current editor
And I close the current editor
