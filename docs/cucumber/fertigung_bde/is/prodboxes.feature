# *****************************************************************************
#  Name           : prodboxes.feature
#  Autor          : khuelskaemper
#  Verantwortlich : teaminfosysteme
#  Funktion       : Testet Funktionen IS PRODBOXES und ob 
# 					ContainerShell und -Head richtig gehandelt werden
#
# *****************************************************************************
#


@persistent
Feature: Behälter zum Betriebsauftrag
Background:
Given I set the fake date to "05.01.1995"

# ------------------------------------------------------
Scenario: Artikel ein Lagerpackmittel zuweisen
# ------------------------------------------------------

Given I open an editor "Artikel" from table "(Part):(Product)" with command "COPY" for record "BEHAELTER"
And I set field "such" to "BEHAELTER_neu"
And I save the current editor

Given I open an editor "Packanw." from table "(PackingInstructions)" with command "UPDATE" for record "501"
And I set field "artikel" to "BEHAELTER_neu" in row 1
And I save the current editor

Given I open an editor "Artikel" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
And I set field "packanwstdla" to "501"
And I set field "fmengestdla" to "10"
And I set field "packmnotw" to "ja" in row 2
And I save the current editor

# ------------------------------------------------------
Scenario: Fertigungsvorschläge erstellen
# ------------------------------------------------------

Given I open an editor "Fertigungsvorschläge" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "BG1" in row 1
Then field "packanw" has value "501" in row 1
And I set field "mfreig" to "ja" in row 1
And I set field "bisuch" to "BDE1_" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "Fertigungsvorschläge"
And I save the current editor

# ------------------------------------------------------
Scenario: Betriebsauftrag
# ------------------------------------------------------

Given I open the infosystem "PRODBOXES"
And I set field "kba" to "BDE1_000"
And I press button "bstart"
And I set field "kpackanzke" to "1"
And I press button "kbubehgenke"
Then the table has 1 rows
And I close the current editor

# ------------------------------------------------------
Scenario: Materialzuordnung 
# ------------------------------------------------------

Given I open an editor "Fertigungsvorschlag" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "BG1"
And I press button "ladetab"
Then field "packanw" has value "501" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "20" in row 1
And I set field "behaelter" to "BEHAELTER_neu" in row 1
And I save the current editor
And I switch the current editor to editor "Fertigungsvorschlag"
And I save the current editor
	

# ------------------------------------------------------
Scenario: Betriebsauftrag testen
# ------------------------------------------------------

Given I open the infosystem "PRODBOXES"
And I set field "kba" to "BDE1_000"
And I press button "bstart"
Then the table has 1 rows
And I close the current editor

