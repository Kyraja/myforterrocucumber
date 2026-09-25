# *****************************************************************************
#  Name             : anbu_vorgang1_002_aktualisierung_abgang.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Anlagenvorgang wird hier zuerst ohne zu buchen gespeichert
#                     und die betroffene Anlage wird weiter abgeschrieben -> Daten im Vorgang sind nicht mehr aktuell.
#                     Anschliessend wird der Vorgang gebucht.
#
#                     Aufbau:
#                     Scenario: eine steuerliche Anlage; Vollabgang:
#                          1) Vollabgang; nur gespeichert, nicht verbucht
#                          2) Anlage geht komplett mit einem anderem Vorgang ab
#                          3) Versuch Vorgang aus 1)  zu verbuchen -> Fehlermeldung
#                     Scenario: eine steuerliche Anlage; Vollumbuchung
#                          1) Vollumbuchung; nur gespeichert, nicht verbucht
#                          2) abgehende Anlage wird abgeschrieben
#                          3) zugebuchte Anlage geht komplett mit einem anderem Vorgang ab
#                          4) Versuch Vorgang aus 1)  zu verbuchen -> Fehlermeldung
#
#                     Ausloeser: REWE-3239 bzw. Anf. 602960
#
# *****************************************************************************
@persistent
Feature: anbu_vorgang1_002_aktualisierung_abgang.feature
Background: Test der Aktualisierung der Daten im ANBU-Vorgang


Given I set the fake date to "01.01.01"

@FALL-NeuanlageSTEUERVollabgang
Scenario: eine steuerliche Anlage; Vollabgang mit vorherigem Abgang

# eine steuer. Anlage neu anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "400steuer"
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


# AfA-Vorschlag fuer 400steuer
Given I open an editor "vorschlag0" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001steuer"
And I set field "gjahr" to "01"
And I set field "apart" to "steuer"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I set field "vanl" to "400steuer"
And I set field "banl" to "400steuer"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Kontrolle1: Anlage
Given I open an editor "anlage-view0" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "400steuer"
And I set field "modart" to "steuer"
Then field "erinnerwert" has value "1.00"
Then field "uebahk" has value "25000.00"
Then field "hiahk" has value "25000.00"
Then field "hiabg" has value "0.00"
Then field "hiafa" has value "624.99"
Then field "hirbw" has value "24375.01"
And I close the current editor


# einen neuen Anlagenvorgang anlegen, aber nicht verbuchen
Given I open an editor "anlagenvorg" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "1VAnicht"
And I set field "vorgart" to "Vollabgang"
And I set field "such" to "VOLLABG1"
And I set field "vdatum" to "15.11.2001"
And I set field "anlage" to "400steuer"
#
# Kumulierte Anschaffungs- und Herstellungskosten
Then field "kumahk" has value "25000.00"
# Kumulierte Abschreibungen
Then field "kumafa" has value "624.99"
# Restbuchwert
Then field "rbw" has value "24375.01"
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
Then field "nochafa" has value "1666.64"
Then field "buahk" is empty in row 0
Then field "buafa" is empty in row 0
And I respond with answer "Nein" to the dialog with id "4479"
And I save the current editor
And I close the current editor


# einen neuen Anlagenvorgang: Vollabgang + Verbuchung
Given I open an editor "anlagenvorg_abgang" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "10000VA"
And I set field "vorgart" to "Vollabgang"
And I set field "such" to "VOLLABG1"
And I set field "vdatum" to "15.11.2001"
And I set field "anlage" to "400steuer"
#
# Kumulierte Anschaffungs- und Herstellungskosten
Then field "kumahk" has value "25000.00"
# Kumulierte Abschreibungen
Then field "kumafa" has value "624.99"
# Restbuchwert
Then field "rbw" has value "24375.01"
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
Then field "nochafa" has value "1666.64"
Then field "buahk" is empty in row 0
Then field "buafa" is empty in row 0
And I respond with answer "ja" to the dialog with id "4479"
And I save the current editor
And I close the current editor


# nicht gebuchten Anlagenvorgang verbuchen -> Anlage nicht mehr bebuchbar!!!
Given I open an editor "anlagenvorg" from table "(FixedAsset):(FixedAssetTransaction)" with command "UPDATE" for record "1VAnicht"
Then field "vorgart" has value "Vollabgang"
Then field "vdatum" has value "15.11.2001"
Then field "anlage" has value "400steuer"
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
# Anlage nicht bebuchbar: in diesem Buchungskreis bereits abgegangen
And saving the current editor throws the exception "8609"
And I close the current editor


# Kontrolle3: Anlage
Given I open an editor "anlage-view2" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "400steuer"
And I set field "modart" to "steuer"
Then field "erinnerwert" has value "1.00"
Then field "uebahk" has value "25000.00"
Then field "hiahk" has value "25000.00"
Then field "hiabg" has value "24375.01"
Then field "hiafa" has value "624.99"
Then field "hirbw" has value "0.00"
And I close the current editor
# =========================================================================================


@FALL-NeuanlageSTEUERVollumbuchungMitAbgang
Scenario: eine steuerliche Anlage; Vollumbuchung mit vorherigen Abgang der Anlage

# eine steuer. Anlage neu anlegen
Given I open an editor "anlage-01" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "500steuer"
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
And I switch the current editor to editor "anlage-01"
And I save the current editor
And I close the current editor


Given I open an editor "anlage-02" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "600steuer"
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
And I switch the current editor to editor "anlage-02"
And I save the current editor
And I close the current editor


# AfA-Vorschlag fuer 500steuer und 600steuer
Given I open an editor "vorschlag0" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "021steuer"
And I set field "gjahr" to "01"
And I set field "apart" to "steuer"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I set field "vanl" to "500steuer"
And I set field "banl" to "600steuer"
And I press button "afaerm"
Then the table has 2 rows
Then field "buchen" has value "ja" in row 2
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# Kontrolle1: Anlage
Given I open an editor "anlage-view0" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "500steuer"
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
And I set field "nummer" to "1100VU"
And I set field "vorgart" to "Vollumbuchung"
And I set field "such" to "VOLLUMB"
And I set field "vdatum" to "15.11.2001"
And I set field "anlage" to "500steuer"
And I set field "uanlage" to "600steuer"
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


# AfA-Vorschlag fuer 500steuer und 600steuer
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "042steuer"
And I set field "gjahr" to "01"
And I set field "apart" to "steuer"
And I set field "vmon" to "1"
And I set field "bmon" to "5"
And I set field "vanl" to "500steuer"
And I set field "banl" to "600steuer"
And I press button "afaerm"
Then the table has 2 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# einen neuen Anlagenvorgang anlegen
Given I open an editor "anlagenvorg" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "1200VA"
And I set field "vorgart" to "Vollabgang"
And I set field "such" to "VOLLABG1"
And I set field "vdatum" to "10.11.2001"
And I set field "anlage" to "600steuer"
And I respond with answer "ja" to the dialog with id "4479"
And I save the current editor


# Kontrolle2: Anlage
Given I open an editor "anlage-view1" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "500steuer"
And I set field "modart" to "steuer"
Then field "erinnerwert" has value "1.00"
Then field "uebahk" has value "25000.00"
Then field "hiahk" has value "25000.00"
Then field "hiabg" has value "0.00"
Then field "hiafa" has value "1041.65"
Then field "hirbw" has value "23958.35"
And I close the current editor


# nicht gebuchten Anlagenvorgang verbuchen -> Werte der Anlage haben sich geaendert
Given I open an editor "anlagenvorg" from table "(FixedAsset):(FixedAssetTransaction)" with command "UPDATE" for record "1100VU"
Then field "vorgart" has value "Vollumbuchung"
Then field "vdatum" has value "15.11.2001"
Then field "anlage" has value "500steuer"
Then field "uanlage" has value "600steuer"

# Kumulierte Anschaffungs- und Herstellungskosten
Then field "kumahk" has value "25000.00"
Then field "akumahk" has value "10000.00"
# Kumulierte Abschreibungen
Then field "kumafa" has value "624.99"
Then field "akumafa" has value "249.99"
# Restbuchwert
Then field "rbw" has value "24375.01"
Then field "arbw" has value "9750.01"

# _____START: ABGEHENDE WERTE
# Abgehende oder umzubuchende Anschaffungskosten
Then field "auahk" has value "25000.00"
# Abgehende oder umzubuchende Abschreibungen
Then field "auafa" has value "624.99"
# Abgehender oder umzubuchender Restbuchwert
Then field "aurbw" has value "24375.01"
# _____ENDE: ABGEHENDE WERTE
# Noch zu verbuchende Abschreibungen
Then field "nochafa" has value "1458.31"
#
# Anlage nicht bebuchbar: in diesem Buchungskreis bereits abgegangen
And saving the current editor throws the exception "8609"
And I close the current editor


# Kontrolle3: Anlage
Given I open an editor "anlage-view2" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "500steuer"
And I set field "modart" to "steuer"
Then field "erinnerwert" has value "1.00"
Then field "uebahk" has value "25000.00"
Then field "hiahk" has value "25000.00"
Then field "hiabg" has value "0.00"
Then field "hiafa" has value "1041.65"
Then field "hirbw" has value "23958.35"
And I close the current editor
# =========================================================================================


