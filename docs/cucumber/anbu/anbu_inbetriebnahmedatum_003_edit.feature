# *****************************************************************************
#  Name             : anbu_inbetriebnahmedatum_003_edit.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Hier werden die Plausis, die mit dem Inbetriebnahmedatum
#                     im Editor AfA-Modell zusammenhaengen, geprueft
#
#                     Konfig hier:
#                      * ANBU-Start in 1999
#                      * Inbetriebnahmedatum aktiv
#                      * beliebiger AfA-Beginn aktiv
#                      * kein Tages-AfA
#
# *****************************************************************************
@persistent
Feature: Inbetriebnahmedatum 3
Background: Test des Editors fuer AfA-Modell

Given I set the fake date to "01.01.01"

@FALL-Konfig
Scenario: Inbetriebnahmedatum aktiviert + AfA-Beginn beliebig

Given I open an editor "anbukinfig" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"
And I set field "tgafa" to "ja"
And I save the current editor
And I close the current editor
# =========================================================================================

@FALL-Altanlage
Scenario: Alt-Anlage

# ANBU-Start in 1999
# kein Inbetriebnahmedatum
# keine beliebiger AfA-Beginn
# kein Tages-AfA

# eine kalk. Anlage neu anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "300kalk"
And I set field "such" to "KA300"
And I set field "modart" to "kalk"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""

And I set field "wg" to "1008"
And I set field "bilkto" to "99800a"
And I set field "kstelle" to "100"
And I set field "afako" to "88889"
And I set field "erinnerwert" to "1.00"
# Anschaffungsdatum ist leer
And I set field "andat" to ""
Then field "inbetdat" is modifiable
Then field "inbetdat" is empty in row 0
Then field "afadat" is not modifiable
Then field "afadat" is empty in row 0
Then field "afadatquelle" is empty in row 0
And saving the current editor throws the exception "10179"
#
# Anschaffungsdatum eintragen -> aktueller GJ
And I set field "andat" to "01.01.01"
Then field "inbetdat" is modifiable
Then field "afadat" is modifiable
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" has value "01.01.2001"
Then field "afadatquelle" has value "Anschaffungsdatum"
Then field "altanlage" has value "nein"
#
# Anschaffungsdatum ist leer
And I set field "andat" to ""
Then field "inbetdat" is modifiable
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" is not empty in row 0
Then field "afadatquelle" has value "Inbetriebnahmedatum"
#
# Anschaffungsdatum eintragen -> vergangener GJ / Altanlage
And I set field "andat" to "11.02.1999"
And I set field "uebahk" to "12000"
Then field "inbetdat" is modifiable
Then field "afadat" is modifiable
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" has value "01.01.2001"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
Then field "restnutzdau" has value "120"
Then field "altanlage" has value "ja"
#
And I set field "ve" to "ja"
Then field "afadat" has value "01.01.2001"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
Then field "inbetdat" has value "01.01.2001"
Then field "restnutzdau" has value "120"
#
And I set field "ve" to "nein"
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" has value "01.01.2001"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
Then field "restnutzdau" has value "120"
#
And I set field "afadat" to "17.11.1999"
Then field "inbetdat" has value "01.01.2001"
Then field "andat" has value "11.02.1999"
Then field "restnutzdau" has value "118"
Then field "altanlage" has value "ja"
#
And I set field "inbetdat" to "15.12.1999"
Then field "afadat" has value "01.12.1999"
Then field "andat" has value "11.02.1999"
Then field "restnutzdau" has value "119"
Then field "altanlage" has value "ja"
#
And I respond with answer "Ja" to the dialog with id "4475"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor

# AfA-Vorschlag fuer 300kalk
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "003kalk"
And I set field "gjahr" to "01"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "300kalk"
And I set field "banl" to "300kalk"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Kontrolle
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "VIEW" for record "+003kalk"
Then the table has 1 rows
Then field "tbuafa" is not empty in row 1
Then field "vbuch" has value "ja" in row 1
Then field "buanlage" has value "300kalk" in row 1
Then field "tkstelle" has value "100" in row 1
Then field "betrag" has value "1346.00" in row 1
And I close the current editor
# =========================================================================================


@FALL-Neuanlage3
Scenario: NEU-Anlage3

# eine steuer. Anlage neu anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "300steuer"
And I set field "such" to "ST300"
And I set field "modart" to "steuer"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""

And I set field "wg" to "1008"
And I set field "kstelle" to "100"
And I set field "erinnerwert" to "1.00"
# Anschaffungsdatum ist leer
And I set field "andat" to ""
Then field "inbetdat" is modifiable
Then field "inbetdat" is empty in row 0
Then field "afadat" is not modifiable
Then field "afadat" is empty in row 0
And saving the current editor throws the exception "10179"
#
# Anschaffungsdatum eintragen -> aktueller GJ
And I set field "andat" to "01.01.01"
Then field "inbetdat" is modifiable
Then field "afadat" is modifiable
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" has value "01.01.2001"
Then field "altanlage" has value "nein"
#
# Anschaffungsdatum ist leer
And I set field "andat" to ""
Then field "inbetdat" is modifiable
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" is not empty in row 0
#
# Anschaffungsdatum eintragen -> vergangener GJ / Altanlage
And I set field "andat" to "11.02.99"
And I respond with answer "Ja" to the dialog with id "4476"
And I set field "uebahk" to "12000"
Then field "inbetdat" is modifiable
Then field "afadat" is modifiable
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" has value "01.01.2001"
Then field "restnutzdau" has value "120"
Then field "altanlage" has value "ja"
#
# Inbetriebnahmedatum eintragen: Anschaffungsdatum und Inbetriebnahmedatum gehen auseinander
And I set field "inbetdat" to "17.09.1999"
Then field "andat" has value "11.02.1999"
Then field "afadat" has value "01.09.1999"
#
And I set field "ve" to "ja"
Then field "afadat" has value "01.07.1999"
Then field "inbetdat" has value "17.09.1999"
Then field "restnutzdau" has value "114"
#
And I set field "ve" to "nein"
Then field "inbetdat" has value "17.09.1999"
Then field "afadat" has value "01.09.1999"
Then field "restnutzdau" has value "116"
#
And I set field "afadat" to "17.11.1999"
Then field "inbetdat" has value "17.09.1999"
Then field "andat" has value "11.02.1999"
Then field "restnutzdau" has value "118"
Then field "altanlage" has value "ja"
#
And I respond with answer "Ja" to the dialog with id "4475"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor

# AfA-Vorschlag fuer 300steuer
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "003steuer"
And I set field "gjahr" to "01"
And I set field "apart" to "steuer"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "300steuer"
And I set field "banl" to "300steuer"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Kontrolle
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "VIEW" for record "+003steuer"
Then the table has 1 rows
Then field "tbuafa" is not empty in row 1
Then field "vbuch" has value "ja" in row 1
Then field "buanlage" has value "300steuer" in row 1
Then field "tkstelle" has value "100" in row 1
Then field "betrag" has value "1359.00" in row 1
And I close the current editor
# =========================================================================================

