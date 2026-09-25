# *****************************************************************************
#  Name             : anbu_indexreihe_editor_plausichecks.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Hier werden die Plausis bzw. die Aenderbarkeit
#                     im Editor fuer Indexreihen geprueft.
#
# *****************************************************************************
@persistent
Feature: ANBU Fehler
Background: Test des Editors fuer Indexreihen

#Given I set the fake date to "01.01.01"


@FALL-AnlagenZeilenEdit
Scenario: eine Anlage mit Tabelle editieren

# die Tabelle bei einer Anlage wird erst dann gefuellt, wenn eine Indexreihe eingetragen ist.
# deswegen die Pruefung in der Anlage auch hier

# eine neue Anlage anlegen
Given I open an editor "anlage-11" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "9001D"
And I set field "nummer" to "100TAB"
And I set field "modart" to "kalk"
And I set field "such" to "TAB100"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for "afamod-1" in row 0

And I save the current editor
And I close the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-11"

#
# # # # # Tabelle # # # #
#

Then field "wbw" has value "50000.00" in row 1

#Zeile 6
Then field "vgj" has value "00" in row 6
Then field "vgm" has value "1" in row 6
Then field "bgj" has value "00" in row 6
Then field "bgm" has value "12" in row 6
Then field "infla" has value "1.7000" in row 6
Then field "wbw" has value "52665.00" in row 6
Then field "gjwaehr" has value "DEM" in row 6
#Zeile 6
Then field "vgj" has value "01" in row 7
Then field "vgm" has value "1" in row 7
Then field "bgj" has value "01" in row 7
Then field "bgm" has value "12" in row 7
Then field "infla" has value "2.3667" in row 7
Then field "wbw" has value "27563.74" in row 7
Then field "gjwaehr" has value "EUR" in row 7
Then setting field "gjwaehr" to "USD" in row 7 throws the exception "203"

# Zeilen einfuegen und loeschen
#
# Exception 294: Es dürfen keine Zeilen ein- oder angefügt werden
Then creating a new row at position 7 throws the exception "294"
#
# Exception 295: Es dürfen keine Zeilen gelöscht werden
And deleting the row at position 5 throws the exception "295"
#
#
# Test abschliessen
And I save the current editor
And I close the current editor
# =========================================================================================

