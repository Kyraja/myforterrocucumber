# *****************************************************************************
#  Name             : anbu_afamodell_editor_plausichecks.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Hier werden die Plausis im Editor fuer AfA-Modell geprueft
#
# *****************************************************************************
@persistent
Feature: ANBU Fehler
Background: Test des Editors fuer AfA-Modell

Given I set the fake date to "01.01.01"


@FALL-Anschaffungsdatum
Scenario: Leeres Anschaffungsdatum

# eine kalk. Anlage durch Kopieren anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "524001"
And I set field "nummer" to "100kalk"
And I set field "modart" to "kalk"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "uebahk" to "0.00"
And I set field "erinnerwert" to "0.00"
# Anschaffungsdatum ist leer
And I set field "andat" to ""
And saving the current editor throws the exception "10179"
And I set field "andat" to "01.01."
And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
# =========================================================================================

@FALL-Kategorie/Art
Scenario: Anlagenkategorie und Abschreibungsart passen nicht zusammen

# eine kalk. Anlage durch Kopieren anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "524001"
And I set field "nummer" to "101kalk"
And I set field "modart" to "kalk"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "uebahk" to "0.00"
And I set field "erinnerwert" to "0.00"
And I set field "andat" to "01.01."
And I set field "afaart" to "10004"
And saving the current editor throws the exception "1491"
And I set field "afaart" to "10001"
And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
# =========================================================================================

@FALL-Errinerungswert
Scenario: Erinnerungswert ist groesser als Anschaffungskosten

# eine steuerl. Anlage durch Kopieren anlegen
Given I open an editor "anlage-2" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "524001"
And I set field "nummer" to "100st"
And I set field "such" to "st100"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "andat" to "1.1.00"
And I set field "uebahk" to "1000.00"
And I set field "erinnerwert" to "10004.00"
#
# 5003: Restbuchwert bzw. Erinnerungswert unplausibel! 
And saving the current editor throws the exception "5003"
And I set field "erinnerwert" to "1.00"
And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-2"
And I save the current editor
# =========================================================================================

@FALL-Abschaffungsdatum1
Scenario: Unplanmaessige AfA und Abschaffungsdatum beide gefuellt

# eine steuerl. Anlage durch Kopieren anlegen
Given I open an editor "anlage-2" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "524001"
And I set field "nummer" to "200st"
And I set field "such" to "st200"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "upbetr" to "5200"
And I set field "abschaffdat" to "."
And I set field "andat" to "1.1.00"
#
# 4196: Anlage bereits abgeschafft! 
And saving the current editor throws the exception "4196"
And I set field "abschaffdat" to ""
And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-2"
And I save the current editor
# =========================================================================================

@FALL-Tabelle
Scenario: Editieren in der Tabelle

# eine steuerl. Anlage durch Kopieren anlegen
Given I open an editor "anlage-2" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "524001"
And I set field "nummer" to "300st"
And I set field "such" to "st300"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "afaart" to ""
And I create a new row at the end of the table
# hier ist USD eingetragen; Fehler???
And I set field "safawaehr" to "USD" in row 1
And I set field "safavgj" to "." in row 1
And saving the current editor throws the exception "279"
And I set field "safavm" to "1" in row 1
And saving the current editor throws the exception "279"
And I set field "safabgj" to "2002" in row 1
And saving the current editor throws the exception "279"
And I set field "safabm" to "12" in row 1
And I set field "safapr" to "3" in row 1
And saving the current editor throws the exception "279"
And I set field "safabasis" to "20000" in row 1
And saving the current editor throws the exception "279"
And I set field "safako" to "62200" in row 1
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-2"
And I save the current editor
# =========================================================================================

@FALL-Tabelle2
Scenario: Editieren in der Tabelle; Zeitraeume

# eine steuerl. Anlage durch Kopieren anlegen
Given I open an editor "anlage-3" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "524001"
And I set field "nummer" to "400st"
And I set field "such" to "st400"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "afaart" to ""
And I create a new row at the end of the table
# hier ist USD eingetragen; Fehler???
And I set field "safawaehr" to "USD" in row 1
And I set field "safavgj" to "2002" in row 1
And I set field "safavm" to "1" in row 1
And I set field "safabgj" to "." in row 1
And I set field "safabm" to "12" in row 1
And I set field "safapr" to "3" in row 1
And I set field "safabasis" to "20000" in row 1
And saving the current editor throws the exception "279"
And I set field "safako" to "62200" in row 1
And saving the current editor throws the exception "3003"
# GJahre richtig setzen
And I set field "safavgj" to "." in row 1
And I set field "safabgj" to "2002" in row 1
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-3"
And I save the current editor
# =========================================================================================

@FALL-NICHT_BEBUCHT
Scenario: Editieren von Konten anwertbko und anbilkto

# eine steuerl. Anlage durch Kopieren anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "524001"
And I set field "nummer" to "500st"
And I set field "such" to "st500"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "andat" to "1.1.00"
And I set field "uebahk" to "1000.00"
And I set field "erinnerwert" to "4.00"
Then field "wertbko" is not modifiable
Then field "bilkto" is modifiable
#
And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor

# Anlage wieder oeffnen
Given I open an editor "anlage-2" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "500st"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
Then field "bilkto" has value "05200"
And I set field "bilkto" to "04400"
#
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-2"
And I save the current editor
And I close the current editor
# =========================================================================================

@FALL-ANBILKTO
Scenario: Editieren vom Feld anbilkto (AfA-Modell)

# 1) Hier wird eine Anlage durch Kopieren angelegt/gespeichert.
# 2) Anschlissend wird das Feld 'anbilkto' editiert -> muss moeglich sein, weil die Anlage noch nicht bebucht
# 3) eine manuelle Zugangsbuchung fuer die Anlage
# 4) Versuch das Feld 'anbilkto' zu editiert -> darf nicht gehen -> die Anlage ist schon bebucht
# 5) Storno der Zugangsbuchung
# 6) erneute Versuch das Feld 'anbilkto' zu editiert -> muss gehen -> die Anlage keine nicht stornierte Buchungen

# eine steuerl. Anlage durch Kopieren anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "524001"
And I set field "nummer" to "600st"
And I set field "such" to "st600"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "andat" to "."
And I set field "uebahk" to "0.00"
And I set field "erinnerwert" to "1.00"
Then field "wertbko" is not modifiable
Then field "bilkto" is modifiable
#
And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
Then field "uebahk" has value "0.00"
Then field "hiahk" has value "0.00"
And I save the current editor
And I close the current editor

# eine Zugangsbuchung zur Anlage 600st anlegen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "kenn" to "ZU"
And I set field "beleg" to "88888"
And I set field "such" to "ZU600ST"
And I create a new row at the end of the table
And I set field "anlage" to "600st" in row 1
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 2
And I set field "ewhbetr" to "1000" in row 2
And I set field "kstelle" to "100" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# Anlage wieder oeffnen und editieren -> muss die Meldung 'Anlage bereits bebucht!' kommen
Given I open an editor "anlage-2" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "600st"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
Then field "bilkto" has value "05200"
Then field "bilkto" is not modifiable
And setting field "bilkto" to "04400" throws the exception "Anlage bereits bebucht!"
Then field "bilkto" has value "05200"
#
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-2"
And I save the current editor
And I close the current editor

# Storno der Buchung
Given I open an editor "storno-bu" from table "(Entry):(Entry)" with command "REVERSAL" for search criteria "$,,such=ZU600ST;@richtung=rückwärts;@maxtreffer=1"
Then field "anlage" has value "600st" in row 1
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# Anlage wieder oeffnen und editieren
Given I open an editor "anlage-3" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "600st"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
# nach dem Storno der Buchung muss wieder moeglich sein!!!
Then field "bilkto" is modifiable
Then field "bilkto" has value "05200"
And I set field "bilkto" to "04400"
#
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-3"
And I save the current editor
And I close the current editor
# =========================================================================================

@FALL-INDEXFELDER_EDITIERBAR
Scenario: Editieren von Konten ankkidx und ankkix2 - auch im Aendern-Modus muessen sie editierbar sein

# eine steuerl. Anlage durch Kopieren anlegen
Given I open an editor "anlage-4" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "524001"
And I set field "nummer" to "700st"
And I set field "such" to "st700"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "andat" to "1.1.00"
And I set field "uebahk" to "1000.00"
And I set field "erinnerwert" to "4.00"
Then field "kkidx" is modifiable
Then field "kkidx2" is modifiable
Then field "wbwab" is modifiable
Then field "noidxafa" is modifiable
Then field "bilkto" is modifiable
#
And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-4"
And I save the current editor
And I close the current editor

# Anlage wieder oeffnen - Modus "AENDERN"
Given I open an editor "anlage-5" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "700st"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
Then field "kkidx" is modifiable
Then field "kkidx2" is modifiable
Then field "wbwab" is modifiable
Then field "noidxafa" is modifiable
#
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-5"
And I save the current editor
And I close the current editor

# Anlage wieder oeffnen - Modus "ZEIGEN"
Given I open an editor "anlage-5" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "700st"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
Then field "kkidx" is not modifiable
Then field "kkidx2" is not modifiable
Then field "wbwab" is not modifiable
Then field "noidxafa" is not modifiable
#
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-5"
And I save the current editor
And I close the current editor

# =========================================================================================

