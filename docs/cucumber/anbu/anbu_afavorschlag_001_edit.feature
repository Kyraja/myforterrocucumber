# *****************************************************************************
#  Name             : anbu_afavorschlag_001_edit.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Hier werden Plausis und Editierverhalten
#                     im Editor fuer AfA-Vorschlag geprueft
#
# *****************************************************************************
@persistent
Feature: anbu_afavorschlag_001_edit.feature
Background: Test des Editors fuer AfA-Vorschlag

Given I set the fake date to "01.01.01"


@FALL-VON-BIS
# 1: vanl-banl; vkstelle-bkstelle und vwg-bwg
Scenario: vanl-banl vkstelle-bkstelle und vwg-bwg

# AfA-Vorschlag fuer 1-3 2002
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001aaa"
And I set field "gjahr" to "02"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I press button "afaerm"
Then the table has 16 rows
# nicht alles zeigen
And I set field "nzeigwarn" to "ja"
And I set field "nzeigfehl" to "ja"
Then the table has 16 rows
# von-bis Anlage belegen
And I set field "vanl" to "240001"
Then the table has 0 rows
And I set field "banl" to "240005"
Then the table has 0 rows
And I press button "afaerm"
Then the table has 5 rows
And I set field "vanl" to ""
Then the table has 0 rows
And I set field "banl" to ""
Then the table has 0 rows
And I press button "afaerm"
Then the table has 16 rows
# von-bis Kostenobjekt
And I set field "vkstelle" to "100"
Then the table has 0 rows
And I set field "bkstelle" to "101"
Then the table has 0 rows
And I press button "afaerm"
Then the table has 0 rows
And I set field "vkstelle" to ""
Then the table has 0 rows
And I set field "bkstelle" to ""
Then the table has 0 rows
And I press button "afaerm"
Then the table has 16 rows
# von-bis Anlagenkategorie
And I set field "vwg" to "1001"
Then the table has 0 rows
And I set field "bwg" to "1005"
Then the table has 0 rows
And I press button "afaerm"
Then the table has 9 rows
And I set field "vwg" to ""
Then the table has 0 rows
And I set field "bwg" to ""
Then the table has 0 rows
And I press button "afaerm"
Then the table has 16 rows
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "VIEW" for record "+001aaa"
Then the table has 16 rows
And I close the current editor
# =========================================================================================
