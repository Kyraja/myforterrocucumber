# *****************************************************************************
#  Name             : anbu_anlagen_kopieren_001.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Hier wird Kopieren von Anlagen getestet
#
# *****************************************************************************
@persistent
Feature: anbu_anlagen_kopieren_001.feature
Background: Kopieren von Anlagen

Given I set the fake date to "01.01.95"


@FALL-Umstellungsdatum
Scenario: Umstellungsdatum

# neue Anlage durch Kopieren anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "110060"
And I set field "nummer" to "100copy"
And I set field "modart" to "steuer"
Then field "bumafa" is empty in row 0
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "andat" to "15.02.95"
And I set field "veregel" to "ja"
# das Feld muss leer sein
Then field "bumafa" is empty
And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
# das Feld muss leer sein
Then field "bumafa" is empty
And I save the current editor

# Kontrolle
Given I open an editor "anlage-view" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "100copy"
Then field "andat" has value "15.02.1995"
Then field "afadat" has value "01.01.1995"
# das Feld muss leer sein
Then field "bumafa" is empty
And I close the current editor
# =========================================================================================

