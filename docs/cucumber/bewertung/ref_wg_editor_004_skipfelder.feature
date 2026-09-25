# *****************************************************************************
#  Name             : ref_wg_editor_004_skipfelder.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        :
#  Funktion         : das Verhalten von Skipfeldern in einer Warengruppe
#
#                    kurze Zusammenfassung:
#                    ===========================================
#
# *****************************************************************************
@persistent
Feature: Skipfelder in WG
Background: Skipfelder
Given I set the fake date to "09.01.2002"


@FALL-Skipfelder
Scenario: FALL-Skipfelder

Given I open an editor "wgruppe1" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "55"
And I set field "bestausfert" to "10001"
And I set field "bvausfertzug" to "50001"
And I set field "fertfuerbeist" to "ja"
Then field "bestbeibeistzug" has value "10001"
Then field "bvbeibeistzug" has value "50001"
# beide Checkboxen leer
And I set field "fertfuerbeist" to "nein"
Then field "bestbeibeistzug" has value ""
Then field "bvbeibeistzug" has value ""
# Versuch zu speichern -> Fehlermeldung
And saving the current editor throws the exception "10088"
# zurueck auf Einkaufkonten lenken
And I set field "eksofuerbeist" to "ja"
Then field "bestbeibeistzug" has value "10000"
Then field "bvbeibeistzug" has value "51000"
# nicht aenderbare Felder
Then field "bestbeibeistzug" is not modifiable
Then field "bvbeibeistzug" is not modifiable
# ohne zu speichern
And I close the current editor
####################################################################################################################################
