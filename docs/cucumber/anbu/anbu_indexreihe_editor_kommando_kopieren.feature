# *****************************************************************************
#  Name             : anbu_indexreihe_editor_kommando_kopieren.feature
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

@FALL-XXX
Scenario: Indexreihe kopieren 1

Given I open an editor "indexreihe-copy" from table "(FixedAsset):(IndexSeries)" with command "COPY" for record "1A"
Then field "nummer" is empty in row 0
Then field "such" is not empty in row 0
Then field "basisgj" has value "1995"
Then field "nkomma" has value "2"
Then the table has 13 rows
#
And I set field "basisgj" to "1998"
And I set field "such" to "BJ1998"
And I set field "name" to "angepasste Kopie von 1A"
And I delete row at position 1
And I delete row at position 1
And I delete row at position 1
Then the table has 10 rows
And I save the current editor
And I close the current editor


# Kontrolle
Given I open an editor "indexreihe-view" from table "(FixedAsset):(IndexSeries)" with command "VIEW" for record "BJ1998"
Then field "nummer" is not empty in row 0
Then field "nummer" has value "3"
Then field "basisgj" has value "1998"
Then the table has 10 rows
And I close the current editor
# =========================================================================================

