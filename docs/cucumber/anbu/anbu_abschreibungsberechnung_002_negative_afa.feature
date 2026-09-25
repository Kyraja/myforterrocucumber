# *****************************************************************************
#  Name             : anbu_abschreibungsberechnung_002_negative_afa.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Hier wird die Beruecksichtigung von "zu viel" bezahlten AfA bei
#                     steuerlichen Anlagen geprueft
#
# *****************************************************************************
@persistent
Feature: anbu_abschreibungsberechnung_002_negative_afa.feature
Background:

Given I set the fake date to "7.1.01"


Scenario: zum Teil abgeschriebene Anlage mit storniertem Zugang -> zu viel AfA verbucht

# neue Anlagen anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "100neg"
And I set field "modart" to "steuer"
And I set field "such" to "PKW100"
And I set field "namebspr" to "abgeschr.Anlage mit storniertem Zugang"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set fields
    | afaart      | 10001  |
    | kstelle     | 100    |
    | andat       | 01.01. |
    | nmon        | 36     |
    | erinnerwert | 1.00   |
    | bilkto      | 05200  |
#And I respond with answer "Ja" to the dialog with id "4476"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor

# Zugangsbuchung zur Anlage "100neg"
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "kenn" to "ZU"
And I set field "budat" to "."
And I set field "beleg" to "100neg"
And I create a new row at the end of the table
And I set field "anlage" to "100neg" in row 1
And I set field "ewsbetr" to "36000.00" in row 1
And I create a new row at the end of the table
And I set field "konto" to "18100" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor


# AfA-Vorschlag fuer Anlage "100neg"
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "100v1"
And I set field "vmon" to "1"
And I set field "bmon" to "6"
And I set field "vanl" to "100neg"
And I set field "banl" to "100neg"
And I press button "afaerm"
Then the table has 1 rows
And I respond with answer "Ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


Given I open an editor "AfA-Buchung_Storno" from table "(Entry):(Entry)" with command "REVERSAL" for search criteria "$,,such=B100NEG;kenn=ZU;@richtung=rückwärts;@maxordtreffer=1"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# AfA-Vorschlag fuer Anlage "100neg"
Given I open an editor "vorschlag-2" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "100v2"
And I set field "vmon" to "1"
And I set field "bmon" to "6"
And I set field "vanl" to "100neg"
And I set field "banl" to "100neg"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "nein" in row 1
Then field "tafaftxt" is not empty in row 1
Then field "tafafehl" has value "3186" in row 1
Then field "betrag" has value "-6000.00" in row 1
And I set field "buchen" to "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor
# =========================================================================================

