# *****************************************************************************
#  Name             : anbu_indexreihe_editor_identnummer.feature
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

@FALL-Identnummer1
Scenario: Indexreihe neu anlegen

Given I open an editor "indexreihe1" from table "(FixedAsset):(IndexSeries)" with command "NEW" for record ""
Then field "nummer" is empty in row 0
Then field "such" is empty in row 0
Then field "basisgj" has value "2000"

And I append rows
    | startdat |   enddat | infla |
    | 20001201 | 20001231 |   1.0 |
    | 20010101 | 20011231 |   1.2 |
    | 20020101 | 20021231 |   1.2 |
    | 20030101 | 20051231 |   4.5 |
# Suchwort darf nicht leer sein: 10179 TX=de   |bitte eintragen
And saving the current editor throws the exception "10179"
#
And I set field "such" to "BASIS01"
And I save the current editor
And I close the current editor


# Kontrolle fuer automatische Identnummervergabe, wenn man selbst keine Nummer eintraegt
Given I open an editor "indexreihe-view1" from table "(FixedAsset):(IndexSeries)" with command "VIEW" for record "BASIS01"
Then field "nummer" is not empty in row 0
Then field "nummer" has value "2"
And I close the current editor


# Versuch die Nummer wieder zu verwenden
Given I open an editor "indexreihe2" from table "(FixedAsset):(IndexSeries)" with command "NEW" for record ""
Then field "nummer" is empty in row 0
And setting field "nummer" to "2" throws the exception "Nummer schon vorhanden"
# ohne zu speichern
And I close the current editor
# =========================================================================================


@FALL-Identnummer2
Scenario: Indexreihe aendern

# Identnummer bei einem existierenden Objekt aendern
Given I open an editor "indexreihe-update" from table "(FixedAsset):(IndexSeries)" with command "UPDATE" for record "BASIS01"
Then field "nummer" has value "2"
Then field "basisgj" has value "2000"
And I set field "nummer" to "2000MA"
And I save the current editor
And I close the current editor


# Kontrolle
Given I open an editor "indexreihe-view2" from table "(FixedAsset):(IndexSeries)" with command "VIEW" for record "BASIS01"
Then field "nummer" is not empty in row 0
Then field "nummer" has value "2000MA"
And I close the current editor
# =========================================================================================


@FALL-Identnummer3
Scenario: Indexreihe kopieren

Given I open an editor "indexreihe-copy" from table "(FixedAsset):(IndexSeries)" with command "COPY" for record "BASIS01"
Then field "nummer" is empty in row 0
Then field "such" is not empty in row 0
Then field "basisgj" has value "2000"
# die Nummer ist wieder frei -> siehe @FALL-Identnummer2
And I set field "nummer" to "2"
# die Nummer ist vergeben -> Fehlermeldung
And setting field "nummer" to "2000MA" throws the exception "Nummer schon vorhanden"
And I set field "nummer" to "2000KO"
And I save the current editor
And I close the current editor

