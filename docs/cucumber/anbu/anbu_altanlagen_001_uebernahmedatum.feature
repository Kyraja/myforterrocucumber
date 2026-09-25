# *****************************************************************************
#  Name             : anbu_altanlagen_001_uebernahmedatum.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Testet Uebernahmedatum bzw. das abweichende Uebernahmedatum bei Altanlagen
#
#  Umfang:
#        #@FALL-Uebernahmedatum1
#          Scenario: Altanlage mit abweichendem Uebernahmedatum durch Kopieren
#        #@FALL-Uebernahmedatum2
#          Scenario: Altanlage mit abweichendem Uebernahmedatum durch Kommando NEU
#        #@FALL-Buchungen001
#            legt eine AltAnlage ('30st') durch Kopieren -> Uebernahmedatum ist 01.01.01;
#            Anlage '30st' wird im GJ 01 bebucht -> eine Zugangsbuchung
#        #@FALL-Buchungen002
#            bei der Anlage '30st' wird abweichendes Uebernahmedatum auf 01.01.2002 veraendert -> nur in Wartung moeglich
#        #@FALL-Buchungen003
#            Ueberwachung der Zugangsbuchung zur Anlage '30st'
#
# *****************************************************************************
@persistent
Feature: ANBU Altanlagen
Background: Test des Uebernahmedatum bei Altanlagen

Given I set the fake date to "01.01.01"


#@FALL-Uebernahmedatum1
Scenario: Altanlage mit abweichendem Uebernahmedatum durch Kopieren

# eine neue Anlage anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "690001"
And I set field "nummer" to "10st"
And I set field "modart" to "steuer"
And I set field "such" to "steuer10"
And I set field "namebspr" to "abweichendes Uebernahmedatum liegt in der Zukunft;\n durch Kopieren von 690001 entstanden"
And I set field "kopafamod" to "ja"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "veregel" to "nein"
And I set field "erinnerwert" to "1.00"
And I set field "erafa" to "10000.00"
And I set field "andat" to "15.09.1999"
And I set field "abwuebdat" to "01.01.2002"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor

Given I open an editor "afa-vorschlag00" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "00"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "10st"
And I set field "banl" to "10st"
And I press button "afaerm" in row 0
# hier (GJ 00) duerfen keine Vorschlaege kommen,
# weil die Anlage erst ab 01.01.2002 beruecksichtigt werden darf
Then the table has 0 rows
And I close the current editor

Given I open an editor "afa-vorschlag01" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "01"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "10st"
And I set field "banl" to "10st"
And I press button "afaerm" in row 0
# hier (GJ 01) duerfen keine Vorschlaege kommen,
# weil die Anlage erst ab 01.01.2002 beruecksichtigt werden darf
Then the table has 0 rows
And I close the current editor

Given I open an editor "afa-vorschlag02" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "02"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I set field "vanl" to "10st"
And I set field "banl" to "10st"
And I press button "afaerm" in row 0
Then the table has 1 rows
And I close the current editor
###################################################################################################

#@FALL-Uebernahmedatum2
Scenario: Altanlage mit abweichendem Uebernahmedatum durch Kommando NEU

# eine neue Anlage anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "20st"
And I set field "modart" to "steuer"
And I set field "such" to "steuer20"
And I set field "namebspr" to "abweichendes Uebernahmedatum liegt in der Zukunft;\n durch Neuanlegen entstanden"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "wg" to "1003"
And I set field "veregel" to "nein"
And I set field "erinnerwert" to "1.00"
And I set field "erzuab" to "25000.00"
And I set field "erafa" to "10000.00"
And I set field "andat" to "15.09.1999"
And I set field "abwuebdat" to "01.01.2002"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor

Given I open an editor "afa-vorschlag00" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "00"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "20st"
And I set field "banl" to "20st"
And I press button "afaerm" in row 0
Then the table has 0 rows
And I close the current editor

Given I open an editor "afa-vorschlag01" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "01"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "20st"
And I set field "banl" to "20st"
And I press button "afaerm" in row 0
Then the table has 0 rows
And I close the current editor

Given I open an editor "afa-vorschlag02" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "02"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I set field "vanl" to "20st"
And I set field "banl" to "20st"
And I press button "afaerm" in row 0
Then the table has 1 rows
And I close the current editor
###################################################################################################

#@FALL-Buchungen001
Scenario: Altanlage im Uebernahme-GJ bebuchen und Uebernahme-GJ verschieben; Teil 1 (keine Wartung)

# eine neue Anlage anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "690001"
And I set field "nummer" to "30st"
And I set field "modart" to "steuer"
And I set field "such" to "steuer30"
And I set field "namebspr" to "Bebuchen und abw.Uebernahmedatum verschieben;\n durch Kopieren von 690001 entstanden"
And I set field "kopafamod" to "ja"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "veregel" to "nein"
And I set field "nmon" to "65"
And I set field "erinnerwert" to "1.00"
And I set field "erafa" to "10000.00"
And I set field "andat" to "15.09.1999"
And I set field "abwuebdat" to "01.01.01"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor


# Zugang verbuchen
# eine Zugangsbuchung zur Anlage 30st anlegen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "kenn" to "ZU"
And I set field "beleg" to "1234567"
And I set field "such" to "ZU30ST"
And I set field "budat" to "01.05."
And I create a new row at the end of the table
And I set field "anlage" to "30st" in row 1
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 2
And I set field "ewhbetr" to "1000" in row 2
And I set field "kstelle" to "100" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Given I open an editor "afa-vorschlag00" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "00"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "10st"
And I set field "banl" to "10st"
And I press button "afaerm" in row 0
# hier (GJ 00) duerfen keine Vorschlaege kommen,
# weil die Anlage erst ab 01.01.2001 beruecksichtigt werden darf
Then the table has 0 rows
And I close the current editor

Given I open an editor "afa-vorschlag01" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "01"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "30st"
And I set field "banl" to "30st"
And I press button "afaerm" in row 0
# hier (GJ 01) duerfen Vorschlaege kommen,
# weil die Anlage ab 01.01.2001 beruecksichtigt werden darf
Then the table has 1 rows
And I close the current editor

Given I open an editor "afa-vorschlag02" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "02"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I set field "vanl" to "30st"
And I set field "banl" to "30st"
And I set field "budat" to "29.03.2002"
And I press button "afaerm" in row 0
Then the table has 1 rows
And I close the current editor
###################################################################################################


#@FALL-Buchungen002
Scenario: Altanlage im Uebernahme-GJ bebuchen und Uebernahme-GJ verschieben; Teil 2 (Wartung)

Given I'm logged in with password "annette"


## Storno der Buchung
#Given I open an editor "storno-bu" from table "(Entry):(Entry)" with command "REVERSAL" for search criteria "$,,such=ZU30ST;@richtung=rückwärts;@maxtreffer=1"
#Then field "anlage" has value "30st" in row 1
#And I respond with answer "Ja" to the dialog with id "583"
#And I save the current editor
#And I close the current editor


Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "30st"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
# aendern des Datums ist moeglich -> Fehler
# zu der Anlage gibt es eine BU im 2001, die nicht beruecksichtigt wird
And I set field "abwuebdat" to "2002"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor

###################################################################################################


#@FALL-Buchungen003
Scenario: Altanlage im Uebernahme-GJ bebuchen und Uebernahme-GJ verschieben; Teil 3 (keine Wartung)

Given I'm logged in with password "sy"

# Ueberwachung der Buchung
Given I open an editor "zugang-bu" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,such=ZU30ST;@richtung=rückwärts;@maxtreffer=1"
Then field "anlage" has value "30st" in row 1
Then field "stornoobjekt" is empty in row 0
And I close the current editor


# Storno der Buchung
# Storno ist nicht moeglich -> Anlage in 2001 nicht mehr bebuchbar
Given I open an editor "storno-bu" from table "(Entry):(Entry)" with command "REVERSAL" for search criteria "$,,such=ZU30ST;@richtung=rückwärts;@maxtreffer=1"
Then field "anlage" has value "30st" in row 1
And saving the current editor throws the exception "8615"
And I close the current editor


