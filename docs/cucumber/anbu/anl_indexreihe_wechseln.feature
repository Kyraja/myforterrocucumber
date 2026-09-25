# *****************************************************************************
#  Name             : anl_indexreihe_wechseln.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Hier werden die Aenderungen von "Indexreihenfeldern"
#                     bzw. Wiederbeschaffungswerte (Tabelle bei Anlage) geprueft.
#
# *****************************************************************************
@persistent
Feature: ANBU Indexreihen
Background: Wechsel von Indexreihen fuer eine Anlage

Given I set the fake date to "01.01.03"


@FALL-IndexreiheWechseln
Scenario: eine Anlage mit Tabelle editieren

# die Tabelle bei einer Anlage wird erst dann gefuellt, wenn eine Indexreihe eingetragen ist.

# eine neue kalk.Anlage durch Kopieren anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "9001D"
And I set field "nummer" to "100INDX"
And I set field "modart" to "kalk"
And I set field "such" to "TAB100"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for "afamod-1" in row 0
And I save the current editor
And I close the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor


# Daten sichern
Given I open an editor "anlage-2" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "100INDX"
And I set field "modart" to "kalk"
And I close the current editor


# die Anlage 100INDX zum Editieren oeffnen
Given I open an editor "anlage-3" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "100INDX"
And I set field "modart" to "kalk"
#
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for "afamod-2" in row 0
And I set field "kkidx" to "1C"
And I save the current editor
And I close the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-3"
And I save the current editor
And I close the current editor


# Daten sichern
Given I open an editor "anlage-4" from table "(FixedAsset):(FixedAsset)" with command "VIEW" for record "100INDX"
And I set field "modart" to "kalk"
And I close the current editor
# =========================================================================================

