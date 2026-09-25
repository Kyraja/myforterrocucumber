# *****************************************************************************
#  Name             : anbu_kalk_anlagen_und_vollabgeschr.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : 
#
# *****************************************************************************
@persistent
Feature: ANBU
Background: Test des Verhalten der Variable 'vollabgeschr'


Given I set the fake date to "01.01.01"



@FALL-1.Zugangsbuchung
Scenario: FALL-1.Zugangsbuchung
# H�lt fest das fehlerhafte Verhalten von der Variable 'vollabgeschr', wenn die AHK für eine neuangelegte
# kalkulatorische Anlage über eine Zugangsbuchung auf die Anlage gebracht werden.
# Obwohl es eine Zugangsbuchung zur Anlage 100kalk gibt, steht 'vollabgeschr' auf 'ja'
# siehe ANF.425334 (BUG 83571) bzw. Jira-Issue REWE-2144
# Stand M�rz 2019

# eine kalk. Anlage durch Kopieren anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "524001"
And I set field "nummer" to "100kalk"
And I set field "modart" to "kalk"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "uebahk" to "0.00"
And I set field "erinnerwert" to "0.00"
And I set field "andat" to "01.01."
And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor

# Ausgleich des Anzahlungs-Kontos
Given I open an editor "stat-buchung" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "such" to "Zugang100k"
And I set field "kenn" to "ZU"
And I create a new row at the end of the table
And I set field "anlage" to "100kalk" in row 1
#And I set field "kstelle" to "101" in row 1
And I set field "sbetrag" to "17424" in row 1
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 2
And I set field "hbetrag" to "17424" in row 2
And I respond with answer "JA" to the dialog with id "1941"
And I save the current editor
# =========================================================================================
