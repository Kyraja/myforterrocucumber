# *****************************************************************************
#  Name             : anbu_konto_loeschen_001.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Loeschen von Konten in ANBU
#
#
# *****************************************************************************
@persistent
Feature: anbu_konto_loeschen_001.feature
Background: Anzeigen/Verwendung von VKZ

Given I set the fake date to "01.09.01"


Scenario Outline: Stammdaten vorbereiten 1, neue Konten


Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "<alt>"
And I set fields
 | nummer   | <nummer> |
 | such     | <such>   |
 | namebspr | <text>   |
And I save the current editor
And I close the current editor
Examples:
 | nummer | such  | alt   | text            |
 | 50rrr  | RRR50 | 68850 | Kopie von 68850 |
 | 51rrr  | RRR51 | 48450 | Kopie von 48450 |
 | 52rrr  | RRR52 | 62200 | Kopie von 62200 |

#####################################################################################################################################


Scenario: Stammdaten vorbereiten 2, Anbu-Konfig mit neuen Konten bestuecken

Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"
And I set field "erabver" to "50rrr"
And I set field "erabgew" to "51rrr"
And I save the current editor
And I close the current editor

#####################################################################################################################################


Scenario: Anlagen mit neuen Konten bestuecken

# neue Anlage durch Kopieren anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "520003"
And I set field "nummer" to "100copy"
And I set field "modart" to "steuer"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "andat" to "15.02.01"
And I set field "veregel" to "ja"
And I set field "afako" to "52rrr"
And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor

#####################################################################################################################################


Scenario: Konten loeschen


Given I open an editor "konto-loeschen1" from table "(Account):(Account)" with command "DELETE" for record "50rrr"
And saving the current editor throws the exception "2796"
And I close the current editor

Given I open an editor "konto-loeschen2" from table "(Account):(Account)" with command "DELETE" for record "51rrr"
And saving the current editor throws the exception "2796"
And I close the current editor

Given I open an editor "konto-loeschen3" from table "(Account):(Account)" with command "DELETE" for record "52rrr"
And saving the current editor throws the exception "4484"
And I close the current editor

#####################################################################################################################################


