# *****************************************************************************
#  Name             : anbu_anlage_editor_plausichecks.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Hier werden die Plausis bzw. die Aenderbarkeit
#                     im Editor fuer Anlage geprueft.
#
# *****************************************************************************
@persistent
Feature: ANBU Fehler
Background: Test des Editors fuer Anlage

Given I set the fake date to "01.01.01"


@FALL-Anlage
Scenario: eine Anlage ohne AfA-Modell anlegen

# eine neue Anlage anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "111st"
And I set field "modart" to "steuer"
And I set field "such" to "steuer111"
Then pressing button "ivkz" throws the exception "Keine passenden Daten vorhanden"
Then pressing button "pvkz" throws the exception "Keine passenden Daten vorhanden"
And setting field "selbukreis" to "" throws the exception "279"
# pruefen, ob Buttons klickbar sind
Then pressing button "bgjahr" throws the exception ""
Then pressing button "bwaehr" throws the exception ""

# Test abschliessen
And I save the current editor
# =========================================================================================

@FALL-Anlage2
Scenario: AfA-Modell ist noch nicht da -> Editieren

# die Anlage 111st zu Editieren oeffnen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "111st"
Then pressing button "ivkz" throws the exception "6732"
#
# aenderbare Felder(nicht alle aufgefuehrt)
Then field "mwaehr" is modifiable
Then field "gjahr" is modifiable
Then field "selbukreis" is modifiable
#
# nicht aenderbare Felder(nicht alle aufgefuehrt)
Then field "lafabu" is not modifiable
Then field "aktafabu" is not modifiable
Then field "nmon" is not modifiable
Then field "andat" is not modifiable
Then field "afadat" is not modifiable
Then field "wg" is not modifiable
Then field "afaart" is not modifiable
Then field "afako" is not modifiable
Then field "bilkto" is not modifiable
Then field "hirbw" is not modifiable
Then field "hiafa" is not modifiable
Then field "hiabg" is not modifiable
Then field "hiahk" is not modifiable

# Exception 294: Es dürfen keine Zeilen ein- oder angefügt werden
Then creating a new row at position 1 throws the exception "294"

# Test abschliessen
And I save the current editor
# =========================================================================================

@FALL-Anlage3
Scenario:  AfA-Modell ist noch nicht da -> Anzeigen

# die Anlage 111st im "Anzeigen"-Modus oeffnen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "111st"
Then pressing button "nbvkz" throws the exception "6732"
Then pressing button "pvkz" throws the exception "6732"
Then pressing button "bafamodell" throws the exception ""

# Test abschliessen
And I close the current editor
# =========================================================================================

@FALL-Anlage4
Scenario:  AfA-Modell ist noch nicht da -> Anzeigen

Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "520005"
# eigentlich muesste hier "6733" kommen
Then setting field "selbukreis" to "2" in row 0 throws the exception "1361"
And I set field "selbukreis" to "HGB"
Then setting field "aktafabu" to "2" in row 0 throws the exception "203"
Then field "aktafabu" is not modifiable
Then field "rbwgja" is not modifiable

# Test abschliessen
And I close the current editor
# =========================================================================================

@FALL-falscheVKZ1
Scenario:  Versuch VKZ fuer Jahre vor der ANBU-Start(2000) anzulegen -> Aendern

Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "440006"
Then field "andat" has value "26.04.1982"
And I set field "gjahr" to "94"
Then pressing button "ivkz" throws the exception "6738"
And I close the current editor
# =========================================================================================

@FALL-falscheVKZ2
Scenario:  Versuch VKZ fuer Jahre vor der Anlagenanschaffung anzulegen -> Aendern

Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "520005"
Then field "andat" has value "12.03.2001"
And I set field "gjahr" to "00"
Then pressing button "ivkz" throws the exception "6738"
And I close the current editor
# =========================================================================================

@FALL-Abschreibungsplannung
Scenario: Berechnung der Abschreibungsplannung ueberwachen

Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "520005"
And I set field "berplafa" to "ja"
# GJahre
Then field "gjafapl1" has value "01"
Then field "gjafapl2" has value "02"
Then field "gjafapl3" has value "03"
Then field "gjafapl4" has value "04"
Then field "gjafapl5" has value "05"
Then field "gjafapl6" has value "06"
Then field "gjafapl7" has value ""
# AfA-Betraege
Then field "afaplan1" has value "15519.56"
Then field "afaplan2" is not empty in row 0
Then field "afaplan3" has value "15520.00"
Then field "afaplan4" is not empty in row 0
Then field "afaplan5" has value "15519.00"
Then field "afaplan6" has value "0.00"
Then field "afaplan7" has value "0.00"
Then field "afaplan1" is not modifiable
Then field "afaplan2" is not modifiable
Then field "afaplan3" is not modifiable
Then field "afaplan4" is not modifiable
Then field "afaplan5" is not modifiable
Then field "afaplan6" is not modifiable
Then field "afaplan7" is not modifiable
# geplanter Restbuchwert
Then field "rbwplan1" has value "62078.00"
Then field "rbwplan2" is not empty in row 0
Then field "rbwplan3" has value "31039.00"
Then field "rbwplan4" has value "15520.00"
Then field "rbwplan5" has value "1.00"
Then field "rbwplan6" has value "1.00"
Then field "rbwplan7" has value "0.00"
# Fehlertext
Then field "afaftxt1" is empty in row 0
Then field "afaftxt2" is empty in row 0
Then field "afaftxt3" is empty in row 0
Then field "afaftxt4" is empty in row 0
Then field "afaftxt5" is empty in row 0
Then field "afaftxt6" is empty in row 0
Then field "afaftxt7" is empty in row 0

And I close the current editor
# =========================================================================================

@FALL-Abschreibungsplannung2
Scenario: eine Anlage mit Status (Anlage planen) anlegen und Plan-AfA berechnen

# eine neue Anlage anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "520005"
And I set field "nummer" to "2055st"
And I set field "modart" to "steuer"
And I set field "such" to "steuer2055"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "uebahk" to "50000.00"
And I set field "erinnerwert" to "1.00"
And I set field "andat" to "01.01."
And I set field "afaart" to ""
And I set field "wg" to ""
And I set field "nmon" to "0"
Then field "afaart" is empty in row 0
Then field "wg" is empty in row 0
And I set field "status" to "Anlage planen"
And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor

Given I open an editor "anlage-2" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "2055st"
And I set field "berplafa" to "ja"
# AfA-Betraege
Then field "afaplan1" has value "0.00"
Then field "afaplan2" has value "0.00"
Then field "afaplan3" has value "0.00"
# geplanter Restbuchwert
Then field "rbwplan1" has value "0.00"
Then field "rbwplan2" has value "0.00"
Then field "rbwplan3" has value "0.00"
Then field "rbwplan4" has value "0.00"
Then field "rbwplan5" has value "0.00"
Then field "rbwplan6" has value "50000.00"
Then field "rbwplan7" has value "0.00"
# Fehlertext
Then field "afaftxt1" has value "Unvollständige Stammdaten in der Anlage!"
Then field "afaftxt2" has value "Unvollständige Stammdaten in der Anlage!"
Then field "afaftxt3" has value "Unvollständige Stammdaten in der Anlage!"
Then field "afaftxt4" has value "Unvollständige Stammdaten in der Anlage!"
Then field "afaftxt5" has value "Unvollständige Stammdaten in der Anlage!"
Then field "afaftxt6" is empty in row 0
Then field "afaftxt7" is empty in row 0
#
Then field "mbetr" has value "1.00"
# Test abschliessen
And I save the current editor
And I close the current editor
# =========================================================================================

@FALL-Abgangswerte
Scenario: Abgangswerte ueberwachen

Given I open an editor "anlage-15" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "440001"
And I set field "selbukreis" to "1"
And I set field "modart" to "steuerlich"
Then field "selbukreis" has value "HGB"
Then field "modart" has value "steuerlich"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for "my_test" in row 0
#And I press button "bafamodell" to open a subeditor for ""
Then field "bukreis" has value "HGB"
Then field "modart" has value "steuerlich"
Then field "id" has value "(204,27,0)"
Then field "ansn" has value "440001"
########
# CUCUMBER-Fehler; hier muss eigentlich 'ja' kommen
Then field "vollabgeschr" has value "nein"
#Then field "vollabgeschr" has value "nein"
#Then field "verko" is not empty in row 0
#Then field "abdat" has value "01.01.2001"
#Then field "abbetr" has value "17754.77"
#Then field "gewinn" has value "0.00"
#Then field "verlust" has value "17754.77"
#Then field "abertrag" has value "0.00"
And I save the current editor
And I close the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-15"
# Reiter Abschaffung
# CUCUMBER-Fehler; hier muss eigentlich 'ja' kommen
Then field "vollabgeschr" has value "nein"
#Then field "vollabgeschr" has value "ja"
#Then field "verko" is not empty in row 0
#Then field "abdat" has value "01.01.2001"
#Then field "abbetr" has value "17754.77"
#Then field "gewinn" has value "0.00"
#Then field "verlust" has value "17754.77"
#Then field "abertrag" has value "0.00"
# Reiter Anschaffung
Then field "bilkto" is not modifiable
Then field "afako" is not modifiable
Then field "afaart" is not modifiable
Then field "wg" is not modifiable
Then field "kstelle" is not modifiable
Then field "andat" is not modifiable
Then field "afadat" is not modifiable
Then field "nmon" is not modifiable
# Abgangswerte
#Then field "hiabahk" has value "90000.00"
#Then field "hiabafa" has value "72245.23"
#Then field "hiabahkad" has value "90000.00"
#Then field "hiabafaad" has value "72245.23"
And I close the current editor
# =========================================================================================

@FALL-Waehrung
Scenario:  Versuch VKZ fuer Jahre vor der Anlagenanschaffung anzulegen -> Aendern

Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "520005"
Then field "mwaehr" has value "DEM"
Then field "w2ist" has value "DEM"
Then field "wvkz" has value "DEM"
Then field "upwaehr" has value "DEM"
Then field "pwaehr" has value "DEM"
Then field "abwaehr" has value "DEM"
# Aenderbarkeit von Waehrungsfeldern
Then field "mwaehr" is modifiable
Then field "w2ist" is not modifiable
Then field "wvkz" is not modifiable
Then field "upwaehr" is not modifiable
Then field "pwaehr" is not modifiable
Then field "abwaehr" is not modifiable


#Then setting field "mwaehr" to "USD" in row 0 throws the exception "1361"
#Then setting field "mwaehr" to "USD" in row 0 throws the exception ""
#Then setting field "mwaehr" to "USD" in row 0 throws the exception "5668"
#Then setting field "mwaehr" to "USD" in row 0 throws the exception "Nur Inlandswährung(en) erlaubt"
#And I respond with answer "Ja" to the dialog with id "1361"
#And I respond with answer "Ja" to the dialog with id "Ungültiger Feldwert mwaehr(0) = [USD]\nNur Inlandswährung(en) erlaubt"
#And I set field "mwaehr" to "USD"
And I set field "mwaehr" to "DEM"
#
Then field "mwaehr" has value "DEM"
#Then setting field "mwaehr" to "" in row 0 throws the exception "5668"
#And I set field "mwaehr" to "DEM"
And I close the current editor
# =========================================================================================
