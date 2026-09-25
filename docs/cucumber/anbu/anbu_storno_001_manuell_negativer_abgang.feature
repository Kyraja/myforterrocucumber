# *****************************************************************************
#  Name             : anbu_storno_001_manuell_negativer_abgang.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : XXXXXXXXX
#
# *****************************************************************************
@persistent
Feature: anbu_storno_001_manuell_negativer_abgang.feature
Background: Test des Editors fuer AfA-Vorschlag

Given I set the fake date to "01.01.01"


Scenario: 1: man. Storno ein Monat spaeter

Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "10mabg"
And I set field "such" to "MAN1"
And I set field "modart" to "steuer"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "wg" to "1008"
And I set field "kstelle" to "101"
And I set field "andat" to "01.01."
And I set field "uebahk" to "20000.00"
And I set field "erinnerwert" to "1.00"
#
Then field "nmon" has value "120"
Then field "restnutzdau" has value "120"

And I respond with answer "Ja" to the dialog with id "4181"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor


# AfA-Vorschlag fuer 1-3 2002
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "01a10mabg"
And I set field "gjahr" to "01"
And I set field "vmon" to "1"
And I set field "bmon" to "4"
And I set field "vanl" to "10mabg"
And I set field "banl" to "10mabg"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "10mabg" in row 1
Then field "betrag" has value "666.68" in row 1
Then field "tkstelle" has value "101" in row 1
Then field "tafaftxt" is empty in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor


# Vollabgang 
Given I open an editor "anlagenvorg1" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "01VA"
And I set field "such" to "Voll10mabg"
And I set field "vorgart" to "Vollabgang"
And I set field "vdatum" to "30.04."
And I set field "anlage" to "10mabg"
And I respond with answer "Ja" to the dialog with id "4479"
And I save the current editor


# Abschaffungsdatum leeren
Given I open an editor "anlage-1a" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "10mabg"
And I set field "modart" to "steuer"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "abschaffdat" to ""
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1a"
And I save the current editor


# Vollabgang AHK manuell stornieren
Given I open an editor "ahk-buchung" via ID from editor "anlagenvorg1" from field "buahk" in row 0 for table "(Entry):(Entry)" with command "COPY"
And I press button "storno"
And I set field "budat" to "30.05."
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor


# Vollabgang AfA manuell stornieren
Given I open an editor "afa-buchung" via ID from editor "anlagenvorg1" from field "buafa" in row 0 for table "(Entry):(Entry)" with command "COPY"
And I press button "storno"
And I set field "budat" to "30.05."
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor


# eine Anlage laden
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "10mabg"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "annum" is not modifiable
Then field "annum" has value "10mabg"
###################
# Reiter 'Abschreibungsberechnung'
###################
Then field "afabtr1" has value "166.67"
Then field "afabtr2" has value "166.67"
Then field "afabtr3" has value "166.67"
Then field "afabtr4" has value "166.67"
Then field "afabtr5" has value "166.67"
Then field "afabtr6" has value "166.67"
Then field "afabtr7" has value "166.67"
Then field "afabtr8" has value "166.67"
Then field "afabtr9" has value "166.67"
Then field "afabtr10" has value "166.67"
Then field "afabtr11" has value "166.67"
Then field "afabtr12" has value "166.67"
#
Then field "bemgr1" has value "20000.00"
Then field "bemgr2" has value "20000.00"
Then field "bemgr3" has value "20000.00"
Then field "bemgr4" has value "20000.00"
Then field "bemgr5" has value "19333.32"
Then field "bemgr6" has value "19333.32"
Then field "bemgr7" has value "19333.32"
Then field "bemgr8" has value "19333.32"
Then field "bemgr9" has value "19333.32"
Then field "bemgr10" has value "19333.32"
Then field "bemgr11" has value "19333.32"
Then field "bemgr12" has value "19333.32"
#
Then field "rnad1" has value "120"
Then field "rnad2" has value "120"
Then field "rnad3" has value "120"
Then field "rnad4" has value "120"
Then field "rnad5" has value "116"
Then field "rnad6" has value "116"
Then field "rnad7" has value "116"
Then field "rnad8" has value "116"
Then field "rnad9" has value "116"
Then field "rnad10" has value "116"
Then field "rnad11" has value "116"
Then field "rnad12" has value "116"
#
Then field "kafabtr" has value "2000.04"
Then field "gldiff" has value "0.04"
#
And I close the current editor
And I switch the current editor to editor "anlage-1"

# Test abschliessen
And I save the current editor
# =========================================================================================


Scenario: 2: Abstand zw. Abgangsbuchung und man. Storno mehrere Monate


Given I open an editor "anlage-2" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "20mabg"
And I set field "such" to "MAN2"
And I set field "modart" to "steuer"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "wg" to "1008"
And I set field "kstelle" to "101"
And I set field "andat" to "01.01."
And I set field "uebahk" to "20000.00"
And I set field "erinnerwert" to "1.00"
#
Then field "nmon" has value "120"
Then field "restnutzdau" has value "120"

And I respond with answer "Ja" to the dialog with id "4181"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-2"
And I save the current editor


# AfA-Vorschlag fuer 1-4 2002
Given I open an editor "vorschlag-2" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "01a20mabg"
And I set field "gjahr" to "01"
And I set field "vmon" to "1"
And I set field "bmon" to "4"
And I set field "vanl" to "20mabg"
And I set field "banl" to "20mabg"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "20mabg" in row 1
Then field "betrag" has value "666.68" in row 1
Then field "tkstelle" has value "101" in row 1
Then field "tafaftxt" is empty in row 1
#And I press button "buch"
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor


# Vollabgang 
Given I open an editor "anlagenvorg-2" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "01VA"
And I set field "such" to "Voll20mabg"
And I set field "vorgart" to "Vollabgang"
And I set field "vdatum" to "30.04."
And I set field "anlage" to "20mabg"
And I respond with answer "Ja" to the dialog with id "4479"
And I save the current editor
# Test abschliessen
# And I close the current editor


# Abschaffungsdatum leeren
Given I open an editor "anlage-2a" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "20mabg"
And I set field "modart" to "steuer"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "abschaffdat" to ""
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-2a"
And I save the current editor


# Vollabgang AHK manuell stornieren
Given I open an editor "ahk-buchung2" via ID from editor "anlagenvorg-2" from field "buahk" in row 0 for table "(Entry):(Entry)" with command "COPY"
And I press button "storno"
And I set field "budat" to "30.08."
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor


# Vollabgang AfA manuell stornieren
Given I open an editor "afa-buchung2" via ID from editor "anlagenvorg-2" from field "buafa" in row 0 for table "(Entry):(Entry)" with command "COPY"
And I press button "storno"
And I set field "budat" to "30.08."
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor


# die Anlage 20mabg laden
Given I open an editor "anlage-2b" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "20mabg"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "annum" is not modifiable
Then field "annum" has value "20mabg"
###################
# Reiter 'Abschreibungsberechnung'
###################
Then field "afabtr1" has value "166.67"
Then field "afabtr2" has value "166.67"
Then field "afabtr3" has value "166.67"
Then field "afabtr4" has value "166.67"
Then field "afabtr5" has value "0.00"
Then field "afabtr6" has value "0.00"
Then field "afabtr7" has value "0.00"
Then field "afabtr8" has value "166.67"
Then field "afabtr9" has value "166.67"
Then field "afabtr10" has value "166.67"
Then field "afabtr11" has value "166.67"
Then field "afabtr12" has value "166.67"
#
Then field "bemgr1" has value "20000.00"
Then field "bemgr2" has value "20000.00"
Then field "bemgr3" has value "20000.00"
Then field "bemgr4" has value "20000.00"
Then field "bemgr5" has value "0.00"
Then field "bemgr6" has value "0.00"
Then field "bemgr7" has value "0.00"
Then field "bemgr8" has value "19333.32"
Then field "bemgr9" has value "19333.32"
Then field "bemgr10" has value "19333.32"
Then field "bemgr11" has value "19333.32"
Then field "bemgr12" has value "19333.32"
#
Then field "rnad1" has value "120"
Then field "rnad2" has value "120"
Then field "rnad3" has value "120"
Then field "rnad4" has value "120"
Then field "rnad5" has value "0"
Then field "rnad6" has value "0"
Then field "rnad7" has value "0"
Then field "rnad8" has value "116"
Then field "rnad9" has value "116"
Then field "rnad10" has value "116"
Then field "rnad11" has value "116"
Then field "rnad12" has value "116"
#
Then field "kafabtr" has value "1500.03"
Then field "gldiff" has value "0.03"
#
And I close the current editor
And I switch the current editor to editor "anlage-2b"

# Test abschliessen
And I save the current editor
# =========================================================================================

