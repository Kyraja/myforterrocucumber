# *****************************************************************************
#  Name             : anbu_meldungen_in_vkz_001_4208.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Fehlerkorrektur zu REWE-3823.
#
# *****************************************************************************

@persistent

Feature: anbu_meldungen_in_vkz_001_4208.feature
Background: VKZ

Given I set the fake date to "07.01.01"

Scenario: Startzustand pruefen

# eine steuerliche Anlage neu anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "100st"
And I set field "such" to "ST100"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""

And I set field "wg" to "1002"
And I set field "erinnerwert" to "1.00"
And I set field "andat" to "1.3.2000"
And I set field "nmon" to "18"
#
#And I respond with answer "Ja" to the dialog with id "4475"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor



# Zugang auf die Anlage buchen
Given I open an editor "zugangsbuchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "ZUGANG"
And I set field "budat" to "1.7.2000"
And I set field "kenn" to "ZU"
And I set field "budat" to "1.7.2000"
And I create a new row at the end of the table
And I set field "anlage" to "100st" in row 1
And I set field "sbetrag" to "18000" in row 1
And I create a new row at the end of the table
And I set field "konto" to "35010" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# Anlage "100st" in 2000 abschreiben - 10 Monate aus 18
# AfA-Vorschlag fuer 1-12 200
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001aaa"
And I set field "gjahr" to "00"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "100st" in row 1
Then field "betrag" has value "10000.00" in row 1
Then field "tkstelle" has value "" in row 1
Then field "tafaftxt" is empty in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# GJ 2000 abschliessen
Given I open an editor "abschl" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "nummer" to "2000C"
And I set field "such" to "ABSCHL"
And I press button "fbbbu" in row 3
And I respond with answer "ja" to the dialog with id "7626"
And I save the current editor
And I close the current editor


# Anlage "100st"in 2001 abschreiben - weitere 5 Monate aus 18
# AfA-Vorschlag fuer 1-10 2001
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "002aaa"
And I set field "gjahr" to "01"
And I set field "vmon" to "1"
And I set field "bmon" to "5"
And I set field "vanl" to "100st"
And I set field "banl" to "100st"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "100st" in row 1
Then field "betrag" has value "5000.00" in row 1
Then field "tkstelle" has value "" in row 1
Then field "tafaftxt" is empty in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


Given I set the fake date to "07.01.02"

# GJ 2001 abschliessen -> Nachbuchungsmonate bleiben noch offen
Given I open an editor "abschl" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "nummer" to "2001A"
And I set field "such" to "ABSCHL"
And I set field "jastart" to "ja"
And I press button "fbbbu" in row 15
And I respond with answer "ja" to the dialog with id "7626"
And I save the current editor
And I close the current editor

Given I open an editor "abschl" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "nummer" to "2001B"
And I set field "such" to "ABSCHL"
And I set field "jastart" to "ja"
And I respond with answer "ja" to the dialog with id "10747"
And I respond with answer "ja" to the dialog with id "7626"
And I save the current editor
And I close the current editor


# Anlage "100st"in 2001 abschreiben - weitere 3 Monate aus 18
# AfA-Vorschlag fuer 1-12 2001
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "003aaa"
And I set field "gjahr" to "01"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "100st"
And I set field "banl" to "100st"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "100st" in row 1
Then field "betrag" has value "2999.00" in row 1
Then field "tkstelle" has value "" in row 1
Then field "tafaftxt" is empty in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


Given I open an editor "anlage-vkz" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "100st"
And I set field "modart" to "steuerlich"
And I respond with answer "9" to the dialog with id "Geschäftsjahr"
And I press button "bgjahr"
# And I set field "gjahr" to "01"
Then field "gjahr" has value "01"
#
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "modart" has value "steuerlich"
Then field "annum" is not modifiable
Then field "annum" has value "100st"
Then field "gjahr" is not modifiable
#
Then field "afafehl" has value "0"
Then field "afaftxt" is empty
#
Then field "hafa5" has value "5000.00"
Then field "hafa13" has value "2999.00"


And I close the current editor
And I switch the current editor to editor "anlage-vkz"
# Test abschliessen
And I save the current editor
# =========================================================================================



