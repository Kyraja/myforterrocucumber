# *****************************************************************************
#  Name             : anbu_edit_objektsperren_003_anlage.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Sperren bei Anlagen/AfA-Modell
#
#
#
# *****************************************************************************
@persistent
Feature: anbu_edit_objektsperren_003_anlage.feature
Background: Sperren bei Anlagen/AfA-Modell: Objekte Sperren

Given I set the fake date to "01.02.01"



Scenario: Versuch ein gesperrtes Objekt einzutragen

# Kontrolle, dass die KST 100a wirklich gesperrt ist
Given I open an editor "kstelle-view1" from table "(Account):(CostCenter)" with command "VIEW" for record "100a"
Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
And I save the current editor
And I close the current editor


Given I open an editor "anlage-edit1" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "440006"
And I set field "modart" to "steuerlich"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
Then setting field "kstelle" to "100a" throws the exception "1361"
#
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-edit1"
And I save the current editor
# =========================================================================================


Scenario: Zugang auf die Anlage, die ein gesperrtes Kostenobjekt hat

# bei der Anlage 770001 ist die KST gesperrt
Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "kenn" to "ZU"
And I set field "budat" to "15.02."
And I create a new row at the end of the table
And I set field "anlage" to "770001" in row 1
And I set field "ewsbetr" to "10000" in row 1
#
And I create a new row at the end of the table
And I set field "konto" to "35010" in row 2
And I respond with answer "JA" to the dialog with id "1941"
And I save the current editor
And I close the current editor
# =========================================================================================



