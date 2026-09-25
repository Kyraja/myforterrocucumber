# *****************************************************************************
#  Name             : anbu_kommandos.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : für Test ref_anbu_kommandos
#
#
# *****************************************************************************

@persistent
Feature: Benutzerf�hrung

Background:
Given I enable the flag 71

Scenario:anbu Kommandos

Given I open an editor "anl-100000" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "100000"
And I set field "selbukreis" to "HGB"
And I press button "bafamodell" to open a subeditor for "anl-100000-afamod"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor
Given I open an editor "anl-100000" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record "100000"
And I set field "nummer" to "100000CY"
And I set field "kopafamod" to "ja"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor
