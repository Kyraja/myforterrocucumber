# *****************************************************************************
#  Name             : anbu_konfig_01_veregel_und_belieb_beginn.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : 
#
# *****************************************************************************
@persistent
Feature: ANBU
Background: Test des Verhalten der Variable 'vollabgeschr'


Given I set the fake date to "01.01.01"


#
#
#   Abschnitt: VE-Regel und Anschaffung
#
#
@FALL-1.Zugang
Scenario: FALL-1.Zugang

# eine neue Anlage durch Kopieren anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "690007"
And I set field "nummer" to "6900st"
And I set field "modart" to "steuer"
And I set field "namebspr" to "3 PC Pentium III 750 MHZ incl. Bildschirm 19 Zoll"
Then field "nbvkz" is not modifiable
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
Then field "bukreis" has value "HGB"
Then field "veregel" has value "ja"
Then field "andat" has value "30.09.2001"
# 01.07.2001 -> weil Anlage kopiert wurde
Then field "afadat" has value "01.07.2001"
# in der Kombination mit veregel=ja muss das Feld schreibgeschuetzt sein
#Then field "afadat" is not modifiable
Then field "afadat" is modifiable
And I set field "veregel" to "nein"
Then field "afadat" is modifiable
Then field "veregel" has value "nein"
Then field "afadat" has value "01.09.2001"
And I set field "veregel" to "ja"
# hier muss jetzt 01.01.2001 kommen
Then field "afadat" has value "01.01.2001"
And I set field "uebahk" to "10000.00"
And I set field "erinnerwert" to "1.00"
And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor

# AfA-Vorschlag fuer die Anlage 6900st bis September verbuchen
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "6900st1"
And I set field "vmon" to "1"
And I set field "bmon" to "8"
And I press button "afaerm"
Then the table has 1 rows
And I set field "bmon" to "9"
And I press button "afaerm"
Then the table has 3 rows
# weniger zeigen
And I set field "nzeigwarn" to "ja"
And I set field "nzeigfehl" to "ja"
Then the table has 1 rows
Then field "buanlage" has value "6900st" in row 1
Then field "bukto" has value "62200" in row 1
Then field "betrag" has value "1874.97" in row 1
#Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# =========================================================================================
#
#
#   Abschnitt: VE-Regel und Abschaffung
#
#

@FALL-1.Abgang
Scenario: FALL-1.Abgang

# die Anlage 6900st voll abgehen lassen + vorherige AfA-Verbuchung
Given I open an editor "vorgang-1" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
Then field "vorgart" has value "Vollabgang"
And I set field "nummer" to "6900vor1"
And I set field "vdatum" to "01.03.2002"
#Then pressing button "buch" throws the exception "4394"
Then pressing button "buch" throws the exception "3968"
And I set field "anlage" to "6900st"
Then field "kumahk" has value "10000.00"
Then field "vorgart" has value "Vollabgang"
# bis zum Jahresende muss gerechnet sein + nicht verbuchte AfA aus dem Vorjahr
# soll: 208.34 * 12 + 208.34 * 3 = 208.34 * 15 = 3125.10
#Then field "nochafa" has value "3125.10"
# ist: (10000.00 - 1874.97) : 36 * 12 = 2708,34
#      (AHK -AfA) : RND in 2002 * (Anz. GM im GJ)
Then field "nochafa" has value "2708.03"
#
And I press button "bafavorschlag" to open a subeditor for "afa-vorschlag"
And I set field "nummer" to "6900st2"
And I set field "namebspr" to "AfA bei Vollabgang fuer Anl. 6900st"
Then the table has 1 rows
Then field "buanlage" has value "6900st" in row 1
# bis zum Jahresende muss gerechnet sein + nicht verbuchte AfA aus dem Vorjahr
# 208.34 * 12 + 208.34 * 3 = 208.34 * 15 = 3125.10
#Then field "betrag" has value "3125.10" in row 1
Then field "betrag" has value "2708.03" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
#
And I switch the current editor to editor "vorgang-1"
And I set field "erloes" to "3500.00"
And I respond with answer "ja" to the dialog with id "4479"
And I save the current editor
And I close the current editor

# Daten in Anlagenvorgang pruefen
Given I open an editor "vorgang-2" from table "(FixedAsset):(FixedAssetTransaction)" with command "VIEW" for record "+6900vor1"
Then field "vorgart" has value "Vollabgang"
Then field "anlage" has value "6900st"
Then field "kumahk" has value "10000.00"
Then field "kumafa" has value "4583.00"
Then field "rbw" has value "5417.00"
Then field "erloes" has value "3500.00"
Then field "nochafa" has value "0.00"
Then field "buahk" is not empty
Then field "buafa" is not empty
Then pressing button "bafavorschlag" throws the exception "4478"
And I close the current editor

