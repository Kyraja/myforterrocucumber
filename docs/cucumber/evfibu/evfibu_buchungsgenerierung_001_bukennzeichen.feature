# *****************************************************************************
#  Name             : evfibu_buchungsgenerierung_001_bukennzeichen.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Vorschlag in "bukenn" bei STORNO in RE
#
# *****************************************************************************

@persistent
Feature: evfibu_buchungsgenerierung_001_bukennzeichen.feature
Background:
Given I set the fake date to "01.02.2001"



Scenario Outline: Buchungskreis

# So werden Buchungen in bestimmten Bereichen abgeschaltet
Given I open an editor "bukreis_<nummer>" from table "(AcctngMasterFiles):(SetOfBooksConfiguration)" with command "UPDATE" for record "<nummer>"
And I set fields
# Anlagenbuchhaltung
| vbburst | nein |
# Einkauf
| vbburse | nein |
# Verkauf
| vbbursv | nein |
And I save the current editor
And I close the current editor

Examples:
| nummer |
|      2 |
|      3 |
|      4 |
|      5 |
###################################################################################################



@FALL-Stammdaten
Scenario: Stammdaten

Given I open an editor "termine" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "FIBU"
And I set field "jekkenn" to "EK"
And I set field "jekname" to "Einkauf"
And I set field "jvkkenn" to "VK"
And I set field "jvkname" to "Verkauf"
And I save the current editor
And I close the current editor


#Given I open an editor "termine" from table "(Company):(FinancialDates)" with command "UPDATE" for record "2"
#And I set field "beganbugj2" to "00"
#And I set field "beganbugj3" to "00"
#And I set field "beganbugj4" to "00"
#And I set field "beganbugj5" to "00"
#And I save the current editor
#And I close the current editor

# eine steuerl. Anlage durch Kopieren anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "520003"
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
# Zugangskonto eintragen
And I set field "ktozug1" to "54000"
And I save the current editor
And I close the current editor


Given I open an editor "anlage-2" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "520003"
# Abgangskonto eintragen
And I set field "ktoabg1" to "44000"
And I save the current editor
And I close the current editor
###################################################################################################


@Einkauf
Scenario: Einkauf

Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num" to "500anl"
And I set field "lief" to "001"
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "1000" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "50000" in row 1
Then field "bukenn" has value "EK"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Anlage ueberwachen: vor Zugangsbuchung
Given I open an editor "anlage-view1" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "500st"
Then field "hiahk" has value "1000.00"
Then field "hirbw" has value "1000.00"
And I close the current editor


Given I open an editor "buchung_update" from table "(Entry):(Entry)" with command "UPDATE" for search criteria "$,,such=;@richtung=rückwärts;@maxtreffer=1"
Then field "kenn" has value "EK"
And I set field "kenn" to "ZU"
# Anlage eintragen
And I set field "anlage" to "500st" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor


# Anlage ueberwachen: nach Zugangsbuchung
Given I open an editor "anlage-view2" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "500st"
Then field "hiahk" has value "51000.00"
Then field "hirbw" has value "51000.00"
And I close the current editor


# Rechnung stornieren
Given I open an editor "rechnungStr" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+500anl"
And I set field "nummer" to "500STOR"
Then field "bukenn" is modifiable
Then field "bukenn" has value "ZU"
And I set field "bukenn" to "DI"
Then field "bukenn" has value "DI"
And I save the current editor
And I close the current editor


# Anlage ueberwachen: nach Storno der Rechnung
Given I open an editor "anlage-view3" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "500st"
Then field "hiahk" has value "1000.00"
Then field "hirbw" has value "1000.00"
And I close the current editor


Given I open an editor "buchung_view" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,such=;@richtung=rückwärts;@maxtreffer=1"
Then field "kenn" is not modifiable
Then field "kenn" has value "ZU"
Then field "stornovorlobjekt" is not empty
# Anlage pruefen
Then field "anlage" has value "500st" in row 2
And I close the current editor
###################################################################################################



@Verkauf
Scenario: Verkauf

Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "555anl"
And I set field "kunde" to "001"
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "1000" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "30000" in row 1
Then field "bukenn" has value "VK"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Anlage ueberwachen: vor Zugangsbuchung
Given I open an editor "anlage-view1" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "520003"
Then field "hiahk" has value "74599.00"
Then field "hirbw" has value "36809.00"
And I close the current editor


Given I open an editor "buchung_update" from table "(Entry):(Entry)" with command "UPDATE" for search criteria "$,,such=;@richtung=rückwärts;@maxtreffer=1"
Then field "kenn" has value "VK"
And I set field "kenn" to "AAB"
# Anlage eintragen
And I set field "anlage" to "520003" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor


# Anlage ueberwachen: nach Abgangsbuchung
Given I open an editor "anlage-view2" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "520003"
Then field "hiahk" has value "74599.00"
Then field "hirbw" has value "6809.00"
And I close the current editor


# Rechnung stornieren
Given I open an editor "rechnungStr" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+555anl"
And I set field "nummer" to "555STOR"
Then field "bukenn" is modifiable
Then field "bukenn" has value "AAB"
And I set field "bukenn" to "DI"
Then field "bukenn" has value "DI"
And I save the current editor
And I close the current editor


# Anlage ueberwachen: nach Storno der Rechnung
Given I open an editor "anlage-view3" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "520003"
Then field "hiahk" has value "74599.00"
Then field "hirbw" has value "36809.00"
And I close the current editor


Given I open an editor "buchung_view" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,such=;@richtung=rückwärts;@maxtreffer=1"
Then field "kenn" is not modifiable
Then field "kenn" has value "AAB"
Then field "stornovorlobjekt" is not empty
# Anlage pruefen
Then field "anlage" has value "520003" in row 2
And I close the current editor
###################################################################################################


