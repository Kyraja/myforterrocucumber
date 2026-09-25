# *****************************************************************************
#  Name             : anbu_vkz_aus_objekten.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : 
#                    
#
# *****************************************************************************
@persistent
Feature: ANBU VKZ
Background: Anzeigen/Verwendung von VKZ

Given I set the fake date to "01.09.01"

Scenario: Stammdaten vorbereiten
Given I open an editor "konto" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "99901"
And I set field "such" to "KORE1"
And I set field "namebspr" to "Kostenrechnung; kalk. Anlagen"
And I set field "bu" to "ja"
And I set field "stat" to "Kostenrechnung"
And I set field "gv" to "nein"
And I save the current editor
# =========================================================================================


Scenario: Ist-VKZ (Zeigen)

# eine Anlage laden
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "440004"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "annum" is not modifiable
Then field "annum" has value "440004"
Then field "gjahr" is not modifiable
Then field "bukreis" is not modifiable
Then field "waehr" is not modifiable
Then field "waehr" has value "DEM"
Then field "modart" is not modifiable
# Reiter 'Abschreibungsberechnung'
Then field "afabtr1" has value "280.00"
Then field "kmafa5" has value "1400.00"
# Reiter 'Jahresuebersicht'
Then field "sahkgja" has value "67200.00"
Then field "hahkgja" has value "0.00"
Then field "hafagja" has value "65520.00"
# Reiter 'Anfangs- und Endwerte'
Then field "kahkgja" has value "67200.00"
Then field "kafagje" has value "67199.00"
Then field "rbwgja" has value "1680.00"
Then field "rbwgje" has value "1.00"
Then field "afafehl" has value "0"
Then field "afaftxt" is empty
And I close the current editor
And I switch the current editor to editor "anlage-1"

# Test abschliessen
And I save the current editor
# =========================================================================================

Scenario: Ist-VKZ (Zeigen): Wechsel zw. steuer. und kalk. VKZ

# eine neue Anlage mit 2 AfA-Modellen anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "100beide"
And I set field "modart" to "steuer"
And I set field "such" to "beide100"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "uebahk" to "0.00"
And I set field "erinnerwert" to "1.00"
And I set field "andat" to "01.01."
And I set field "wg" to "1008"
Then field "afaart" has value "10001"
Then field "nmon" is not empty in row 0
#And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor

# neu angelegte Anlage laden
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "100beide"
And I set field "modart" to "kalkulatorisch"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I press button "kpafamod"
Then field "wg" has value "1008"
Then field "afaart" has value "10001"
Then field "nmon" is not empty in row 0
And I set field "afako" to "99800"
And I set field "bilkto" to "99901"
And I set field "uebahk" to "0.00"
And I set field "erinnerwert" to "100.00"
#And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor

# Zugaenge steuerlich und kalk. verbuchen
# eine Zugangsbuchung zur Anlage 600st anlegen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "kenn" to "ZU"
And I set field "beleg" to "88888"
And I set field "such" to "ZU600ST"
And I create a new row at the end of the table
And I set field "anlage" to "100beide" in row 1
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 2
And I set field "ewhbetr" to "1000" in row 2
And I set field "kstelle" to "100" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "kenn" to "ZU"
And I set field "beleg" to "111111"
And I set field "such" to "ZU600ST"
And I create a new row at the end of the table
And I set field "anlage" to "100beide" in row 1
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 2
And I set field "sbetrag" to "7000" in row 2
And I set field "kstelle" to "100" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

#  neu angelegte Anlage wiederladen
Given I open an editor "anlage-vkz" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "100beide"
And I set field "modart" to "steuerlich"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "modart" has value "steuerlich"
Then field "annum" is not modifiable
Then field "annum" has value "100beide"
Then field "gjahr" is not modifiable
And I close the current editor
And I switch the current editor to editor "anlage-vkz"
#
And I set field "modart" to "kalkulatorisch"
And I press button "ivkz" to open a subeditor for "IST_VKZ"
Then field "modart" has value "kalkulatorisch"
Then field "annum" is not modifiable
Then field "annum" has value "100beide"
Then field "gjahr" is not modifiable
And I close the current editor
And I switch the current editor to editor "anlage-vkz"

# Test abschliessen
And I save the current editor
# =========================================================================================

Scenario: Plan-VKZ (Zeigen); temporaer erzeugen

# eine Anlage laden
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "440004"

# TODO Plan-VKZ testen

#And I respond with answer "Ja" to the dialog with id "7107"
#And I respond with answer "Ja" to the dialog with id "7108"
#And I respond with answer "Ja" to the dialog with id "Nicht verbuchte planmäßige AfA berücksichtigen?"

#And I press button "pvkz" to open a subeditor for "PLAN_VKZ"

#And I respond with answer "Ja" to the dialog with id "7107"
#And I respond with answer "Ja" to the dialog with id "Nicht verbuchte planmäßige AfA berücksichtigen?"
#And I respond with answer "Ja" to the dialog with id "7108"

#And I close the current editor
#And I switch the current editor to editor "anlage-1"

# Test abschliessen
And I save the current editor
# =========================================================================================


Scenario: Ist-Verkehrszahlen ohne Nachbuchungen (Zeigen)

# eine Anlage laden
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "690007"
And I press button "nbvkz" to open a subeditor for "IST_VKZ"
Then field "ozeilen" has value "6"
Then field "annum" is not modifiable
Then field "annum" has value "690007"
Then field "gjahr" is not modifiable
Then field "bukreis" is not modifiable
Then field "waehr" is not modifiable
Then field "waehr" has value "DEM"
Then field "modart" is not modifiable
# Reiter 'Jahresuebersicht'
Then field "kjsahk" has value "8400.00"
Then field "kjhafa" has value "525.00"
Then field "kjsuahk" has value "3024.00"
Then field "kjhuafa" has value "1764.00"
#          Restwert Jahresende
Then field "rbwgje" has value "9135.00"
# Reiter 'Anfangs- und Endwerte'
Then field "afafehl" has value "2180"
Then field "afaftxt" is not empty
And I close the current editor
And I switch the current editor to editor "anlage-1"

# Test abschliessen
And I save the current editor
# =========================================================================================
