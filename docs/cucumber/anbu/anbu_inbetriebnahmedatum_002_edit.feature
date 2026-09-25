# *****************************************************************************
#  Name             : anbu_inbetriebnahmedatum__edit.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Hier werden die Plausis, die mit dem Inbetriebnahmedatum
#                     im Editor AfA-Modell zusammenhaengen, geprueft
#
#                     Konfig hier:
#                      * ANBU-Start in 1999
#                      * Inbetriebnahmedatum aktiv
#                      * keine beliebiger AfA-Beginn
#                      * kein Tages-AfA
#
# *****************************************************************************
@persistent
Feature: Inbetriebnahmedatum 2
Background: Test des Editors fuer AfA-Modell

Given I set the fake date to "01.01.01"

@FALL-Konfig
Scenario: Inbetriebnahmedatum aktivieren

Given I open an editor "anbukinfig" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"
And I set field "inbetdatumaktiv" to "ja"
And I save the current editor
And I close the current editor
# =========================================================================================

@FALL-Altanlage2
Scenario: Alt-Anlage2

# eine kalk. Anlage neu anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "200kalk"
And I set field "such" to "KA200"
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
Then field "inbetdat" is empty
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
And I set field "inbetdat" to "21.08.01"
Then field "andat" has value "01.01.2001"
Then field "afadat" has value "01.08.2001"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
#
# Anschaffungsdatum ist leer
And I set field "andat" to ""
Then field "inbetdat" is modifiable
Then field "inbetdat" has value "21.08.2001"
Then field "afadat" is not empty
Then field "afadatquelle" has value "Inbetriebnahmedatum"
#
# Anschaffungsdatum eintragen -> vergangener GJ / Altanlage
And I set field "andat" to "11.02.1999"
And I set field "uebahk" to "12000"
Then field "inbetdat" is modifiable
Then field "afadat" is modifiable
Then field "inbetdat" has value "21.08.2001"
Then field "afadat" has value "01.08.2001"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
Then field "restnutzdau" has value "120"
Then field "altanlage" has value "ja"
#
# Inbetriebnahmedatum eintragen: Anschaffungsdatum und Inbetriebnahmedatum gehen auseinander
And I set field "inbetdat" to "17.09.1999"
Then field "andat" has value "11.02.1999"
Then field "afadat" has value "01.09.1999"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
#
And I set field "ve" to "ja"
Then field "andat" has value "11.02.1999"
Then field "inbetdat" has value "17.09.1999"
Then field "afadat" has value "01.07.1999"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
Then field "restnutzdau" has value "114"
#
And I set field "ve" to "nein"
Then field "andat" has value "11.02.1999"
Then field "inbetdat" has value "17.09.1999"
Then field "afadat" has value "01.09.1999"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
Then field "restnutzdau" has value "116"
#
And I respond with answer "Ja" to the dialog with id "4475"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor

# AfA-Vorschlag fuer 200kalk
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "002kalk"
And I set field "gjahr" to "01"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "200kalk"
And I set field "banl" to "200kalk"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Kontrolle
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "VIEW" for record "+002kalk"
Then the table has 1 rows
Then field "tbuafa" is not empty in row 1
Then field "vbuch" has value "ja" in row 1
Then field "buanlage" has value "200kalk" in row 1
Then field "tkstelle" has value "100" in row 1
Then field "betrag" has value "1385.00" in row 1
And I close the current editor
# =========================================================================================


@FALL-AltanlageAendern
Scenario: Alt-Anlage2

# eine steuerl. Alt-Anlage aendern: Inbetriebnahmedatum leer + AfA-Buchungen
Given I open an editor "anlage-update987st" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "987st"
And I set field "modart" to "steuer"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""

Then field "afadatquelle" has value "Anschaffungsdatum"
Then field "altanlage" has value "ja"
Then field "inbetdat" is modifiable
Then field "afadat" is not modifiable
Then field "inbetdat" is empty
Then field "afadat" has value "01.02.1996"
#
And I set field "kstelle" to "101"
Then field "altanlage" has value "ja"
Then field "eafabu" is not empty
#And I set field "inbetdat" to "04.01.1996"
And setting field "inbetdat" to "04.01.1996" throws the exception "Datum der Inbetriebnahme muss jünger oder gleich Anschaffungsdatum sein."
And I set field "inbetdat" to "01.01.1999"
#
# Darf sich nicht aendern -> Altanlage + AfA-Buchungen
Then field "afadat" has value "01.02.1996"
And setting field "inbetdat" to "01.01.1993" throws the exception "Datum der Inbetriebnahme muss jünger oder gleich Anschaffungsdatum sein."
#
# Darf sich nicht aendern -> Altanlage + AfA-Buchungen
Then field "afadat" has value "01.02.1996"
Then field "afadatquelle" has value "Anschaffungsdatum"

# die Anlage hat noch schon AfA-Buchungen -> kein Inbetriebnahmedatum verlangen
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-update987st"
And I save the current editor
And I close the current editor
# =========================================================================================


@FALL-AltanlageAendern3

Scenario: Alt-Anlage kopieren3 -> Inbetriebnahmedatum leer + keine AfA-Buchungen

# Ausgangssituation: Inbetriebnahmedatum leer + keine AfA-Buchungen


Given I open an editor "anlage-update777st" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "777st"
And I set field "modart" to "steuer"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""

Then field "afadatquelle" has value "Anschaffungsdatum"
Then field "afadat" has value "01.02.1996"
Then field "andat" has value "04.02.1996"
Then field "andat" is modifiable
Then field "inbetdat" is modifiable
Then field "inbetdat" is empty
Then field "altanlage" has value "ja"

# ein Feld aendern, damit die post_ok-Plausis greifen
And I set field "kstelle" to "101"

Then field "eafabu" is empty
Then field "inbetdat" is empty
# die Anlage hat noch keine AfA-Buchungen, aber ist eine Alt-Anlage -> kein Inbetriebnahmedatum verlangen
#
# Speichern und zurueck in das AfA-Modell
And I save the current editor
And I switch the current editor to editor "anlage-update777st"
And I press button "bafamodell" to open a subeditor for ""
#
Then field "eafabu" is empty
Then field "inbetdat" is empty
#
And setting field "inbetdat" to "04.01.1993" throws the exception "Datum der Inbetriebnahme muss jünger oder gleich Anschaffungsdatum sein."

And I set field "inbetdat" to "01.01.1999"
Then field "afadat" has value "01.01.1999"
Then field "afadatquelle" has value "Inbetriebnahmedatum"

#
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-update777st"
And I save the current editor
And I close the current editor


# noch Mal aendern -> AfA-Beginn ueberwachen
Given I open an editor "anlage2-update777st" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "777st"
And I set field "modart" to "steuer"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""

Then field "afadat" has value "01.01.1999"
Then field "andat" has value "04.02.1996"
Then field "inbetdat" has value "01.01.1999"
Then field "afadatquelle" has value "Inbetriebnahmedatum"

And I set field "inbetdat" to "01.01.1997"
Then field "inbetdat" has value "01.01.1997"
Then field "afadat" has value "01.01.1997"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
#
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage2-update777st"
And I save the current editor
And I close the current editor
# =========================================================================================


@FALL-Neuanlage2
Scenario: NEU-Anlage2

# eine steuer. Anlage neu anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "200steuer"
And I set field "such" to "ST200"
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
# default-Fall
Then field "afadatquelle" has value "Anschaffungsdatum"
Then field "altanlage" has value "nein"
#
# Anschaffungsdatum ist leer
And I set field "andat" to ""
Then field "inbetdat" is modifiable
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" is not empty
Then field "afadatquelle" has value "Inbetriebnahmedatum"
#
# Anschaffungsdatum eintragen -> vergangener GJ / Altanlage
And I set field "andat" to "11.02.1999"
And I respond with answer "Ja" to the dialog with id "4476"
And I set field "uebahk" to "12000"
Then field "inbetdat" is modifiable
Then field "afadat" is modifiable
Then field "inbetdat" has value "01.01.2001"
Then field "afadat" has value "01.01.2001"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
Then field "restnutzdau" has value "120"
Then field "altanlage" has value "ja"
#
# Inbetriebnahmedatum eintragen: Anschaffungsdatum und Inbetriebnahmedatum gehen auseinander
And I set field "inbetdat" to "11.10.1999"
Then field "andat" has value "11.02.1999"
Then field "afadat" has value "01.10.1999"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
#
And I set field "ve" to "ja"
Then field "andat" has value "11.02.1999"
Then field "inbetdat" has value "11.10.1999"
Then field "afadat" has value "01.07.1999"
Then field "restnutzdau" has value "114"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
#
And I set field "ve" to "nein"
Then field "andat" has value "11.02.1999"
Then field "inbetdat" has value "11.10.1999"
Then field "afadat" has value "01.10.1999"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
Then field "restnutzdau" has value "117"
#
And I respond with answer "Ja" to the dialog with id "4475"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor

# AfA-Vorschlag fuer 200steuer
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "002steuer"
And I set field "gjahr" to "01"
And I set field "apart" to "steuer"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "200steuer"
And I set field "banl" to "200steuer"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Kontrolle
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "VIEW" for record "+002steuer"
Then the table has 1 rows
Then field "tbuafa" is not empty in row 1
Then field "vbuch" has value "ja" in row 1
Then field "buanlage" has value "200steuer" in row 1
Then field "tkstelle" has value "100" in row 1
Then field "betrag" has value "1371.00" in row 1
And I close the current editor
# =========================================================================================


@FALL-NeuanlageAendern
Scenario: NEU-Anlage aendern -> Inbetriebnahmedatum leer + AfA-Buchungen

#
Given I open an editor "anlage-update9999" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "9999st"
And I set field "modart" to "steuer"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""

Then field "afadatquelle" has value "Anschaffungsdatum"
Then field "afadat" is not modifiable
Then field "afadat" has value "01.01.2001"
Then field "inbetdat" is modifiable
Then field "inbetdat" is empty
Then field "altanlage" has value "nein"

# AfA-Buchungen vorhanden
Then field "eafabu" is not empty

# ein Feld aendern, damit post_ok-Plausis greifen
And I set field "kstelle" to "101"

# "afadatquelle" darf sich nicht aendern
Then field "afadatquelle" has value "Anschaffungsdatum"

# die Anlage hat noch schon AfA-Buchungen -> kein Inbetriebnahmedatum verlangen
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-update9999"
And I save the current editor
And I close the current editor
# =========================================================================================


@FALL-NeuanlageAendern2
Scenario: NEU-Anlage aendern2 -> Inbetriebnahmedatum leeren + keine AfA-Buchungen

# Inbetriebnahmedatum leer + keine AfA-Buchungen
Given I open an editor "anlage-5555" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "5555st"
And I set field "modart" to "steuer"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""

Then field "afadatquelle" has value "Anschaffungsdatum"
Then field "afadat" is not modifiable
Then field "afadat" has value "01.01.2001"
Then field "inbetdat" is modifiable
Then field "inbetdat" is empty
Then field "altanlage" has value "nein"

# ein Feld aendern, damit post_ok-Plausis greifen
And I set field "kstelle" to "101"

Then field "eafabu" is empty
# die Anlage hat noch keine AfA-Buchungen -> Inbetriebnahmedatum verlangen
Then saving the current editor throws the exception "Inbetriebnahmedatum ist nicht eingetragen."

# Korrekte Fehlermeldung
And setting field "inbetdat" to "04.01.1996" throws the exception "Datum der Inbetriebnahme muss jünger oder gleich Anschaffungsdatum sein."
# Fehlerzustand: laesst kein GJ aus Termine hier eintragen!!!
And setting field "inbetdat" to "01.10.2022" throws the exception "zukünftiges Datum nicht erlaubt"

And I set field "inbetdat" to "01.10.2001"
Then field "afadat" has value "01.10.2001"
Then field "afadatquelle" has value "Inbetriebnahmedatum"
# Fehlerzustand: kann nicht speichern -> Sackgasse!!!
# And I save the current editor
#
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-5555"
And I save the current editor
And I close the current editor
# =========================================================================================

