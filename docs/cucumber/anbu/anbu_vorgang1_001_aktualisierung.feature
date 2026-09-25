# *****************************************************************************
#  Name             : anbu_vorgang1_001_aktualisierung.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Anlagenvorgang wird hier zuerst ohne zu buchen gespeichert
#                     und die betroffene Anlage wird weiter abgeschrieben -> Daten im Vorgang sind nicht mehr aktuell.
#                     Anschliessend wird der Vorgang gebucht.
#
#                     Aufbau:
#                     Scenario: eine steuerliche Anlage; Vollabgang
#                     Scenario: eine kalk. Anlage; Teilabgang
#                     Scenario: eine steuerliche Anlage; Vollumbuchung
#
#                     Ausloeser: REWE-3239 bzw. Anf. 602960
#
# *****************************************************************************
@persistent
Feature: anbu_vorgang1_001_aktualisierung.feature
Background: Test der Aktualisierung der Daten im ANBU-Vorgang


Given I set the fake date to "01.01.01"

@FALL-NeuanlageSTEUERVollabgang
Scenario: eine steuerliche Anlage; Vollabgang

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
And I set field "andat" to "01.01.01"
And I set field "uebahk" to "25000.00"
And I respond with answer "Ja" to the dialog with id "4181"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor


# AfA-Vorschlag fuer 100steuer
Given I open an editor "vorschlag0" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001steuer"
And I set field "gjahr" to "01"
And I set field "apart" to "steuer"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I set field "vanl" to "100steuer"
And I set field "banl" to "100steuer"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Kontrolle1: Anlage
Given I open an editor "anlage-view0" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "100steuer"
And I set field "modart" to "steuer"
Then field "erinnerwert" has value "1.00"
Then field "uebahk" has value "25000.00"
Then field "hiahk" has value "25000.00"
Then field "hiabg" has value "0.00"
Then field "hiafa" has value "624.99"
Then field "hirbw" has value "24375.01"
And I close the current editor


# einen neuen Anlagenvorgang anlegen
Given I open an editor "anlagenvorg" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "100VA"
And I set field "vorgart" to "Vollabgang"
And I set field "such" to "VOLLABG1"
And I set field "vdatum" to "15.11.2001"
And I set field "anlage" to "100steuer"


# Kumulierte Anschaffungs- und Herstellungskosten
Then field "kumahk" has value "25000.00"
# Kumulierte Abschreibungen
Then field "kumafa" has value "624.99"
# Restbuchwert
Then field "rbw" has value "24375.01"

# _____START: ABGEHENDE WERTE
# Abgehende oder umzubuchende Anschaffungskosten
Then field "auahk" has value "25000.00"
# Abgehende oder umzubuchende Abschreibungen
Then field "auafa" has value "624.99"
# Abgehender oder umzubuchender Restbuchwert
Then field "aurbw" has value "24375.01"
# _____ENDE: ABGEHENDE WERTE

# Noch zu verbuchende Abschreibungen
Then field "nochafa" has value "1666.64"

Then field "buahk" is empty in row 0
Then field "buafa" is empty in row 0
And I respond with answer "Nein" to the dialog with id "4479"
And I save the current editor
And I close the current editor


# AfA-Vorschlag fuer 100steuer
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001steuer"
And I set field "gjahr" to "01"
And I set field "apart" to "steuer"
And I set field "vmon" to "1"
And I set field "bmon" to "5"
And I set field "vanl" to "100steuer"
And I set field "banl" to "100steuer"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# Kontrolle2: Anlage
Given I open an editor "anlage-view1" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "100steuer"
And I set field "modart" to "steuer"
Then field "erinnerwert" has value "1.00"
Then field "uebahk" has value "25000.00"
Then field "hiahk" has value "25000.00"
Then field "hiabg" has value "0.00"
Then field "hiafa" has value "1041.65"
Then field "hirbw" has value "23958.35"
And I close the current editor


# nicht gebuchten Anlagenvorgang verbuchen -> Werte der Anlage haben sich geaendert
Given I open an editor "anlagenvorg" from table "(FixedAsset):(FixedAssetTransaction)" with command "UPDATE" for record "100VA"
Then field "vorgart" has value "Vollabgang"
Then field "vdatum" has value "15.11.2001"
Then field "anlage" has value "100steuer"
# Kumulierte Anschaffungs- und Herstellungskosten
Then field "kumahk" has value "25000.00"
# Kumulierte Abschreibungen
Then field "kumafa" has value "624.99"
# Restbuchwert
Then field "rbw" has value "24375.01"
# _____START: ABGEHENDE WERTE
# Abgehende oder umzubuchende Anschaffungskosten
Then field "auahk" has value "25000.00"
# Abgehende oder umzubuchende Abschreibungen
Then field "auafa" has value "624.99"
# Abgehender oder umzubuchender Restbuchwert
Then field "aurbw" has value "24375.01"
# _____ENDE: ABGEHENDE WERTE
# Noch zu verbuchende Abschreibungen
Then field "nochafa" has value "1666.64"
#
And I respond with answer "Ja" to the dialog with id "4479"
# "Anlage wurde inzwischen geaendert - nochmal laden."
And saving the current editor throws the exception "4165"
# die Anlage neu eintragen
And I set field "anlage" to "100steuer"
#
Then field "anlage" has value "100steuer"
# Kumulierte Anschaffungs- und Herstellungskosten
Then field "kumahk" has value "25000.00"
# Kumulierte Abschreibungen
Then field "kumafa" has value "1041.65"
# Restbuchwert
Then field "rbw" has value "23958.35"
# _____START: ABGEHENDE WERTE
# Abgehende oder umzubuchende Anschaffungskosten
Then field "auahk" has value "25000.00"
# Abgehende oder umzubuchende Abschreibungen
Then field "auafa" has value "1041.65"
# Abgehender oder umzubuchender Restbuchwert
Then field "aurbw" has value "23958.35"
# _____ENDE: ABGEHENDE WERTE
# Noch zu verbuchende Abschreibungen
Then field "nochafa" has value "1249.98"
#
And I respond with answer "Ja" to the dialog with id "4479"
And I save the current editor
And I close the current editor


# Kontrolle3: Anlage
Given I open an editor "anlage-view2" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "100steuer"
And I set field "modart" to "steuer"
Then field "erinnerwert" has value "1.00"
Then field "uebahk" has value "25000.00"
Then field "hiahk" has value "25000.00"
Then field "hiabg" has value "23958.35"
Then field "hiafa" has value "1041.65"
Then field "hirbw" has value "0.00"
And I close the current editor
# =========================================================================================


@FALL-NeuanlageKALKTeilabgang
Scenario: eine kalk. Anlage; Teilabgang

Given I open an editor "konto" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "1test"
And I set field "such" to "TEST1"
And I set field "stat" to "Kostenrechnung"
And I set field "namebspr" to "Bilanzkonto fuer stat. Anlagen; Testkonto1"
And I set field "bebuchbar" to "ja"
And I set field "gv" to "nein"
And I save the current editor
And I close the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "1test"
And I set field "nummer" to "2test"
And I set field "such" to "TEST2"
And I set field "namebspr" to "Bilanzkonto fuer stat. Anlagen; Testkonto2"
And I save the current editor
And I close the current editor

# eine steuer. Anlage neu anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "100kalk"
And I set field "such" to "KA100"
And I set field "modart" to "kalk"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "wg" to "1008"
And I set field "kstelle" to "100"
And I set field "afako" to "99800"
And I set field "bilkto" to "1test"
And I set field "erinnerwert" to "1.00"
And I set field "andat" to "01.01.01"
And I set field "uebahk" to "50000.00"
And I respond with answer "Ja" to the dialog with id "4181"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor


# AfA-Vorschlag fuer 100kalk
Given I open an editor "vorschlag0" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001kalk"
And I set field "gjahr" to "01"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I set field "vanl" to "100kalk"
And I set field "banl" to "100kalk"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Kontrolle1: Anlage
Given I open an editor "anlage-view0" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "100kalk"
And I set field "modart" to "kalk"
Then field "erinnerwert" has value "1.00"
Then field "uebahk" has value "50000.00"
Then field "hiahk" has value "50000.00"
Then field "hiabg" has value "0.00"
Then field "hiafa" has value "1250.01"
Then field "hirbw" has value "48749.99"
And I close the current editor


# einen neuen Anlagenvorgang anlegen
Given I open an editor "anlagenvorg" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "200TA"
And I set field "such" to "TEILABG1"
And I set field "apart" to "kalk"
And I set field "vorgart" to "Teilabgang"
And I set field "vdatum" to "15.11.2001"
And I set field "anlage" to "100kalk"
And I set field "vkoahk2" to "2test"
And I set field "vkoafa2" to "2test"
And I set field "auahk" to "25000"

# Kumulierte Anschaffungs- und Herstellungskosten
Then field "kumahk" has value "50000.00"
# Kumulierte Abschreibungen
Then field "kumafa" has value "1250.01"
# Restbuchwert
Then field "rbw" has value "48749.99"

# _____START: ABGEHENDE WERTE
# Abgehende oder umzubuchende Anschaffungskosten
Then field "auahk" has value "25000.00"
# Abgehende oder umzubuchende Abschreibungen
Then field "auafa" has value "625.01"
# Abgehender oder umzubuchender Restbuchwert
Then field "aurbw" has value "24374.99"
# _____ENDE: ABGEHENDE WERTE

# Noch zu verbuchende Abschreibungen
Then field "nochafa" has value "3333.36"
#
Then field "buahk" is empty in row 0
Then field "buafa" is empty in row 0
And I respond with answer "Nein" to the dialog with id "4479"
And I save the current editor
And I close the current editor


# AfA-Vorschlag fuer 100kalk
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "10kalk"
And I set field "gjahr" to "01"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "5"
And I set field "vanl" to "100kalk"
And I set field "banl" to "100kalk"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# Kontrolle2: Anlage
Given I open an editor "anlage-view1" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "100kalk"
And I set field "modart" to "kalk"
Then field "erinnerwert" has value "1.00"
Then field "uebahk" has value "50000.00"
Then field "hiahk" has value "50000.00"
Then field "hiabg" has value "0.00"
Then field "hiafa" has value "2083.35"
Then field "hirbw" has value "47916.65"
And I close the current editor


# nicht gebuchten Anlagenvorgang verbuchen -> Werte der Anlage haben sich geaendert
Given I open an editor "anlagenvorg" from table "(FixedAsset):(FixedAssetTransaction)" with command "UPDATE" for record "200TA"
Then field "vorgart" has value "Teilabgang"
Then field "vdatum" has value "15.11.2001"
Then field "anlage" has value "100kalk"
# Kumulierte Anschaffungs- und Herstellungskosten
Then field "kumahk" has value "50000.00"
# Kumulierte Abschreibungen
Then field "kumafa" has value "1250.01"
# Restbuchwert
Then field "rbw" has value "48749.99"
#
# _____START: ABGEHENDE WERTE
# Abgehende oder umzubuchende Anschaffungskosten
Then field "auahk" has value "25000.00"
# Abgehende oder umzubuchende Abschreibungen
Then field "auafa" has value "625.01"
# Abgehender oder umzubuchender Restbuchwert
Then field "aurbw" has value "24374.99"
# _____ENDE: ABGEHENDE WERTE
#
# Noch zu verbuchende Abschreibungen
Then field "nochafa" has value "3333.36"
#
# And I press button "buch"
# beim Druecken des Buttons kommt die Meldung "Ungueltige Buttonart buch(0) = []"
# deswegen ueber Speichern
And I respond with answer "Ja" to the dialog with id "4479"
# "Anlage wurde inzwischen geaendert - nochmal laden."
And saving the current editor throws the exception "4165"
# die Anlage neu eintragen
And I set field "anlage" to "100kalk"
And I set field "vkoahk2" to "2test"
And I set field "vkoafa2" to "2test"
# abgehende Werte nochmal eintragen sonst ist das Feld leer
And I set field "auahk" to "25000"
#
# _____START: ABGEHENDE WERTE
# Abgehende oder umzubuchende Anschaffungskosten
Then field "auahk" has value "25000.00"
# Abgehende oder umzubuchende Abschreibungen
Then field "auafa" has value "1041.68"
# Abgehender oder umzubuchender Restbuchwert
Then field "aurbw" has value "23958.32"
# _____ENDE: ABGEHENDE WERTE
#
# Noch zu verbuchende Abschreibungen
Then field "nochafa" has value "2500.02"
And I respond with answer "Ja" to the dialog with id "4479"
And I save the current editor
And I close the current editor


# Kontrolle3: Anlage
Given I open an editor "anlage-view2" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "100kalk"
And I set field "modart" to "kalk"
Then field "erinnerwert" has value "1.00"
Then field "uebahk" has value "50000.00"
Then field "hiahk" has value "50000.00"
Then field "hiabg" has value "23958.32"
Then field "hiafa" has value "2083.35"
Then field "hirbw" has value "23958.33"
And I close the current editor
# =========================================================================================


@FALL-NeuanlageSTEUERVollumbuchung
Scenario: eine steuerliche Anlage; Vollumbuchung

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
And I set field "andat" to "01.01.01"
And I set field "uebahk" to "25000.00"
And I respond with answer "Ja" to the dialog with id "4181"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor

Given I open an editor "anlage-2" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "300steuer"
And I set field "such" to "ST300"
And I set field "modart" to "steuer"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "wg" to "1008"
And I set field "kstelle" to "100"
And I set field "erinnerwert" to "1.00"
And I set field "andat" to "01.01.01"
And I set field "uebahk" to "10000.00"
And I respond with answer "Ja" to the dialog with id "4181"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-2"
And I save the current editor
And I close the current editor


# AfA-Vorschlag fuer 200steuer und 300steuer
Given I open an editor "vorschlag0" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "002steuer"
And I set field "gjahr" to "01"
And I set field "apart" to "steuer"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I set field "vanl" to "200steuer"
And I set field "banl" to "300steuer"
And I press button "afaerm"
Then the table has 2 rows
Then field "buchen" has value "ja" in row 2
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# Kontrolle1: Anlage
Given I open an editor "anlage-view0" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "200steuer"
And I set field "modart" to "steuer"
Then field "erinnerwert" has value "1.00"
Then field "uebahk" has value "25000.00"
Then field "hiahk" has value "25000.00"
Then field "hiabg" has value "0.00"
Then field "hiafa" has value "624.99"
Then field "hirbw" has value "24375.01"
And I close the current editor


# einen neuen Anlagenvorgang anlegen
Given I open an editor "anlagenvorg" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "300VU"
And I set field "vorgart" to "Vollumbuchung"
And I set field "such" to "VOLLUMB"
And I set field "vdatum" to "15.11.2001"
And I set field "anlage" to "200steuer"
And I set field "uanlage" to "300steuer"
#
# Kumulierte Anschaffungs- und Herstellungskosten
Then field "kumahk" has value "25000.00"
Then field "akumahk" has value "10000.00"
# Kumulierte Abschreibungen
Then field "kumafa" has value "624.99"
Then field "akumafa" has value "249.99"
# Restbuchwert
Then field "rbw" has value "24375.01"
Then field "arbw" has value "9750.01"
#
# _____START: ABGEHENDE WERTE
# Abgehende oder umzubuchende Anschaffungskosten
Then field "auahk" has value "25000.00"
# Abgehende oder umzubuchende Abschreibungen
Then field "auafa" has value "624.99"
# Abgehender oder umzubuchender Restbuchwert
Then field "aurbw" has value "24375.01"
# _____ENDE: ABGEHENDE WERTE
#
# Noch zu verbuchende Abschreibungen
Then field "nochafa" has value "1458.31"
Then field "buahk" is empty in row 0
Then field "buafa" is empty in row 0
And I respond with answer "Nein" to the dialog with id "4479"
And I save the current editor
And I close the current editor


# AfA-Vorschlag fuer 200steuer und 300steuer
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "032steuer"
And I set field "gjahr" to "01"
And I set field "apart" to "steuer"
And I set field "vmon" to "1"
And I set field "bmon" to "5"
And I set field "vanl" to "200steuer"
And I set field "banl" to "300steuer"
And I press button "afaerm"
Then the table has 2 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# Kontrolle2: Anlage
Given I open an editor "anlage-view1" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "200steuer"
And I set field "modart" to "steuer"
Then field "erinnerwert" has value "1.00"
Then field "uebahk" has value "25000.00"
Then field "hiahk" has value "25000.00"
Then field "hiabg" has value "0.00"
Then field "hiafa" has value "1041.65"
Then field "hirbw" has value "23958.35"
And I close the current editor


# nicht gebuchten Anlagenvorgang verbuchen -> Werte der Anlage haben sich geaendert
Given I open an editor "anlagenvorg" from table "(FixedAsset):(FixedAssetTransaction)" with command "UPDATE" for record "300VU"
Then field "vorgart" has value "Vollumbuchung"
Then field "vdatum" has value "15.11.2001"
Then field "anlage" has value "200steuer"
Then field "uanlage" has value "300steuer"
#
# Kumulierte Anschaffungs- und Herstellungskosten
Then field "kumahk" has value "25000.00"
Then field "akumahk" has value "10000.00"
# Kumulierte Abschreibungen
Then field "kumafa" has value "624.99"
Then field "akumafa" has value "249.99"
# Restbuchwert
Then field "rbw" has value "24375.01"
Then field "arbw" has value "9750.01"
#
# _____START: ABGEHENDE WERTE
# Abgehende oder umzubuchende Anschaffungskosten
Then field "auahk" has value "25000.00"
# Abgehende oder umzubuchende Abschreibungen
Then field "auafa" has value "624.99"
# Abgehender oder umzubuchender Restbuchwert
Then field "aurbw" has value "24375.01"
# _____ENDE: ABGEHENDE WERTE
#
# Noch zu verbuchende Abschreibungen
Then field "nochafa" has value "1458.31"
#
# In GUI funktionier der Button
# And I press button "buch"
# beim Druecken des Buttons kommt die Meldung "Ungueltige Buttonart buch(0) = []"
# deswegen ueber Speichern
And I respond with answer "Ja" to the dialog with id "4479"

# "Anlage wurde inzwischen geaendert - nochmal laden."
And saving the current editor throws the exception "4165"
# die Anlage neu eintragen
And I set field "anlage" to "200steuer"
#
# _____START: ABGEHENDE WERTE
# Abgehende oder umzubuchende Anschaffungskosten
Then field "auahk" has value "25000.00"
# Abgehende oder umzubuchende Abschreibungen
Then field "auafa" has value "1041.65"
# Abgehender oder umzubuchender Restbuchwert
Then field "aurbw" has value "23958.35"
# _____ENDE: ABGEHENDE WERTE
#
# Noch zu verbuchende Abschreibungen
Then field "nochafa" has value "1041.65"
And I respond with answer "Ja" to the dialog with id "4479"
And I save the current editor
And I close the current editor


# Kontrolle3: Anlage
Given I open an editor "anlage-view2" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "200steuer"
And I set field "modart" to "steuer"
Then field "erinnerwert" has value "1.00"
Then field "uebahk" has value "25000.00"
Then field "hiahk" has value "25000.00"
Then field "hiabg" has value "23958.35"
Then field "hiafa" has value "1041.65"
Then field "hirbw" has value "0.00"
And I close the current editor
# =========================================================================================

