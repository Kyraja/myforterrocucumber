# *****************************************************************************
#  Name             : anbu_anlage_edit_001_neu.feature
#  Autor            : Waldemar Neufeld
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : 
#
# *****************************************************************************

@persistent
Feature: ANBU Fehler
Background: Test des Editors fuer Anlage

Given I set the fake date to "01.01.01"

Given I'm logged in with password "sy"


Scenario: Anlage anlegen

Given I open an editor "anl-1000" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "1000"
And I set field "such" to "BENZ"
And I set field "name" to "KA-AB 993"
And I press button "bafamodell" to open a subeditor for "anl-1000-afamod"
And I set field "wg" to "1001"
And I set field "andat" to "15.01.2000"
And I set field "kstelle" to "100"
Then field "nmon" has value "60"
Then field "afadat" has value "01.01.2000"
And I set field "erinnerwert" to "1.00"
 And I set field "uebahk" to "30000"
# AfA-Modell speichern
And I respond with answer "Ja" to the dialog with id "4181"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anl-1000"
# AfA-Modell wieder oeffnen
And I press button "bafamodell" to open a subeditor for "anl-1000-afamod2"
And I set field "kstelle" to "101"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor


# AfA-Vorschlag fuer 1-12 2000 nur fuer neue Anlage
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001aaa"
And I set field "gjahr" to "00"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "1000"
And I set field "banl" to "1000"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

