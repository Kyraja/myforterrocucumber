# *****************************************************************************
#  Name             : anbu_inbetriebnahmedatum_001_edit.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Hier werden die Plausis, die mit dem Inbetriebnahmedatum
#                     im Editor AfA-Modell zusammenhaengen, geprueft
#
#                     Konfig hier:
#                      * ANBU-Start in 1999
#                      * Inbetriebnahmedatum inaktiv
#                      * beliebiger AfA-Beginn inaktiv
#                      * kein Tages-AfA
#
# *****************************************************************************
@persistent
Feature: Inbetriebnahmedatum 1
Background: Test des Editors fuer AfA-Modell

Given I set the fake date to "01.01.01"

@FALL-Altanlage
Scenario: Alt-Anlage
# ANBU-Start in 1999
# kein Inbetriebnahmedatum
# keine beliebiger AfA-Beginn
# kein Tages-AfA

# eine kalk. Anlage neu anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "100kalk"
And I set field "such" to "KA100"
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
Then field "inbetdat" is not empty in row 0
Then field "afadat" is empty in row 0
Then field "afadatquelle" is empty in row 0
#
# Anschaffungsdatum eintragen -> vergangener GJ / Altanlage
And I set field "andat" to "11.02.99"
And I set field "uebahk" to "12000"
Then field "inbetdat" is modifiable
Then field "afadat" is modifiable
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" has value "01.02.1999"
Then field "afadatquelle" has value "Anschaffungsdatum"
Then field "restnutzdau" has value "109"
Then field "altanlage" has value "ja"
#
And I set field "ve" to "ja"
Then field "afadat" has value "01.01.1999"
Then field "afadatquelle" has value "Anschaffungsdatum"
Then field "inbetdat" has value "01.01.2001"
Then field "restnutzdau" has value "108"
#
And I set field "ve" to "nein"
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" has value "01.02.1999"
Then field "afadatquelle" has value "Anschaffungsdatum"
Then field "restnutzdau" has value "109"
#
And I respond with answer "Ja" to the dialog with id "4475"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor

# AfA-Vorschlag fuer 100kalk
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001kalk"
And I set field "gjahr" to "01"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "100kalk"
And I set field "banl" to "100kalk"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Kontrolle
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "VIEW" for record "+001kalk"
Then the table has 1 rows
Then field "tbuafa" is not empty in row 1
Then field "vbuch" has value "ja" in row 1
Then field "buanlage" has value "100kalk" in row 1
Then field "tkstelle" has value "100" in row 1
Then field "betrag" has value "1485.00" in row 1
And I close the current editor
# =========================================================================================


@FALL-AltanlageKopieren
Scenario: eine steuerl. Alt-Anlage kopieren  -> Inbetriebnahmedatum leeren + AfA-Buchungen
# ANBU-Start in 1999
# kein Inbetriebnahmedatum
# keine beliebiger AfA-Beginn
# kein Tages-AfA

# eine steuerl. Anlage kopieren -> Inbetriebnahmedatum leeren + AfA-Buchungen
Given I open an editor "anlage-steuer987" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "440001"
And I set field "nummer" to "987st"
And I set field "such" to "ST987"
And I set field "modart" to "steuer"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""

Then field "ve" has value "ja"
Then field "inbetdat" has value "03.11.1995"
Then field "andat" has value "03.11.1995"
Then field "afadat" has value "01.07.1995"

And I set field "ve" to "nein"
Then field "afadat" has value "01.11.1995"
#
Then field "andat" is modifiable
Then field "inbetdat" is modifiable

And I set field "andat" to "04.02.1996"
Then field "inbetdat" has value "04.02.1996"
Then field "andat" has value "04.02.1996"
Then field "afadat" has value "01.02.1996"
Then field "altanlage" has value "ja"
#
Then field "erzuab" has value "90000.00"
And I set field "erafa" to "65000.00"
# Inbetriebnahmedatum leeren
And I set field "inbetdat" to ""
#
Then field "afadatquelle" has value "Anschaffungsdatum"
#
And I set field "kstelle" to "100"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-steuer987"
And I save the current editor

# AfA-Vorschlag fuer 987st
Given I open an editor "vorschlag987st" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "1st987"
And I set field "gjahr" to "01"
And I set field "apart" to "steuer"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "987st"
And I set field "banl" to "987st"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Kontrolle
Given I open an editor "vorschlag-987st" from table "(FixedAsset):(DepreciationSuggestion)" with command "VIEW" for record "+1st987"
Then the table has 1 rows
Then field "tbuafa" is not empty in row 1
Then field "vbuch" has value "ja" in row 1
Then field "buanlage" has value "987st" in row 1
Then field "tkstelle" has value "100" in row 1
Then field "betrag" has value "8108.00" in row 1
And I close the current editor
# =========================================================================================


@FALL-AltanlageKopieren2
Scenario: Alt-Anlage kopieren2 -> Inbetriebnahmedatum leeren + keine AfA-Buchungen
# ANBU-Start in 1999
# kein Inbetriebnahmedatum
# keine beliebiger AfA-Beginn
# kein Tages-AfA

# eine steuerl. Anlage kopieren -> Inbetriebnahmedatum leeren + keine AfA-Buchungen

# noch eine steuerl. Anlage kopieren -> Inbetriebnahmedatum vorhanden
Given I open an editor "anlage-steuer777" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "440001"
And I set field "nummer" to "777st"
And I set field "such" to "ST777"
And I set field "modart" to "steuer"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""

Then field "ve" has value "ja"
Then field "afadat" has value "01.07.1995"
And I set field "ve" to "nein"
Then field "afadat" has value "01.11.1995"
#
Then field "andat" is modifiable
Then field "inbetdat" is modifiable

And I set field "andat" to "04.02.1996"
Then field "inbetdat" has value "04.02.1996"
Then field "andat" has value "04.02.1996"
Then field "afadat" has value "01.02.1996"
Then field "altanlage" has value "ja"
#
Then field "erzuab" has value "90000.00"
And I set field "erafa" to "67000.00"
And I set field "kstelle" to "100"
# Inbetriebnahmedatum leeren
And I set field "inbetdat" to ""
#
Then field "afadatquelle" has value "Anschaffungsdatum"
#
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-steuer777"
And I save the current editor
# =========================================================================================


@FALL-Neuanlage
Scenario: NEU-Anlage

# eine steuer. Anlage neu anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "100steuer"
And I set field "such" to "ST100"
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
Then field "afadatquelle" is empty in row 0
And saving the current editor throws the exception "10179"
#
# Anschaffungsdatum eintragen -> aktueller GJ
And I set field "andat" to "01.01.01"
Then field "inbetdat" is modifiable
Then field "afadat" is not modifiable
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" has value "01.01.2001"
Then field "afadatquelle" has value "Anschaffungsdatum"
Then field "altanlage" has value "nein"
#
# Anschaffungsdatum ist leer
And I set field "andat" to ""
Then field "inbetdat" is modifiable
Then field "inbetdat" is not empty in row 0
Then field "afadat" is empty in row 0
Then field "afadatquelle" is empty in row 0
#
# Anschaffungsdatum eintragen -> vergangener GJ / Altanlage
And I set field "andat" to "11.02.99"
And I respond with answer "Ja" to the dialog with id "4476"
And I set field "uebahk" to "12000"
Then field "inbetdat" is modifiable
Then field "afadat" is modifiable
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" has value "01.02.1999"
Then field "afadatquelle" has value "Anschaffungsdatum"
Then field "restnutzdau" has value "109"
Then field "altanlage" has value "ja"
#
And I set field "ve" to "ja"
Then field "afadat" has value "01.01.1999"
Then field "afadatquelle" has value "Anschaffungsdatum"
Then field "inbetdat" has value "01.01.2001"
Then field "restnutzdau" has value "108"
#
And I set field "ve" to "nein"
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" has value "01.02.1999"
Then field "afadatquelle" has value "Anschaffungsdatum"
Then field "restnutzdau" has value "109"
#
And I respond with answer "Ja" to the dialog with id "4475"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor

# AfA-Vorschlag fuer 100steuer
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001steuer"
And I set field "gjahr" to "01"
And I set field "apart" to "steuer"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "100steuer"
And I set field "banl" to "100steuer"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Kontrolle
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "VIEW" for record "+001steuer"
Then the table has 1 rows
Then field "tbuafa" is not empty in row 1
Then field "vbuch" has value "ja" in row 1
Then field "buanlage" has value "100steuer" in row 1
Then field "tkstelle" has value "100" in row 1
Then field "betrag" has value "1485.00" in row 1
And I close the current editor
# =========================================================================================


@FALL-NeuanlageKopieren
Scenario: NEU-Anlage kopieren -> Inbetriebnahmedatum leeren + AfA-Buchungen

# eine steuer. Anlage neu anlegen -> Inbetriebnahmedatum leeren + AfA-Buchungen
Given I open an editor "anlage-9999" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "524003"
And I set field "nummer" to "9999st"
And I set field "such" to "ST9999"
And I set field "modart" to "steuer"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""

Then field "inbetdat" is modifiable
Then field "afadat" is not modifiable
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" has value "01.01.2001"
Then field "altanlage" has value "nein"


# Inbetriebnahmedatum leeren
And I set field "inbetdat" to ""
And I set field "kstelle" to "100"
And I set field "erinnerwert" to "1.00"
#
Then field "afadatquelle" has value "Anschaffungsdatum"
#
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-9999"
And I save the current editor

# AfA-Vorschlag fuer 9999st
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "999steuer"
And I set field "gjahr" to "01"
And I set field "apart" to "steuer"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "9999st"
And I set field "banl" to "9999st"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Kontrolle
Given I open an editor "vorschlag-9999" from table "(FixedAsset):(DepreciationSuggestion)" with command "VIEW" for record "+999steuer"
Then the table has 1 rows
Then field "tbuafa" is not empty in row 1
Then field "vbuch" has value "ja" in row 1
Then field "buanlage" has value "9999st" in row 1
Then field "tkstelle" has value "100" in row 1
Then field "betrag" has value "5000.00" in row 1
And I close the current editor
# =========================================================================================


@FALL-NeuanlageKopieren2
Scenario: NEU-Anlage kopieren2 -> Inbetriebnahmedatum leeren + keine AfA-Buchungen

# eine steuer. Anlage neu anlegen2 -> Inbetriebnahmedatum leeren + keine AfA-Buchungen
Given I open an editor "anlage-5555" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "524003"
And I set field "nummer" to "5555st"
And I set field "such" to "ST5555"
And I set field "modart" to "steuer"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""

Then field "inbetdat" is modifiable
Then field "afadat" is not modifiable
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" has value "01.01.2001"
Then field "altanlage" has value "nein"

And I set field "kstelle" to "100"
And I set field "erinnerwert" to "1.00"
# Inbetriebnahmedatum leeren
And I set field "inbetdat" to ""
#
Then field "afadatquelle" has value "Anschaffungsdatum"
#
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-5555"
And I save the current editor
# =========================================================================================

