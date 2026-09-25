# *****************************************************************************
#  Name             : anbu_afavorschlag1_002_storno.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Hier werden Plausis im Editor fuer AfA-Vorschlag geprueft
#                     * Scenario1: Storno von Storno darf nicht passieren
#
# *****************************************************************************
@persistent
Feature: anbu_afavorschlag1_002_storno.feature
Background: Test des AfA-Vorschlag-Editors

Given I set the fake date to "01.03.01"


@FALL-Storno_von_Storno
Scenario: 1: Storno von Storno darf nicht passieren

Given I open an editor "stornovorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "REVERSAL" for record "+009mmm"
And I set field "nummer" to "009stor"
And I save the current editor
And I close the current editor

# 5768 : AfA-Vorschlag ist schon storniert.
Then opening an editor from table "(FixedAsset):(DepreciationSuggestion)" with command "REVERSAL" for record "+009stor" throws the exception "5768"
