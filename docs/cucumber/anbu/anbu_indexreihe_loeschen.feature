# *****************************************************************************
#  Name             : anbu_indexreihe_loeschen.feature
#  Autor            : jeffler
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Hier wird das Loeschen von Indexreihen geprueft
#
# *****************************************************************************
@persistent
Feature: ANBU Fehler
Background: Test des Editors fuer Indexreihen

Given I'm logged in with password "sy"

Scenario: Indexreihen anlegen

Given I open an editor "indexseries" from table "(FixedAsset):(IndexSeries)" with command "NEW" for record "" 
And I set field "such" to "IDX1"
And I create a new row at the end of the table
And I set field "vdat" to "01.01.00" in row 1
And I set field "bdat" to "31.12.00" in row 1
And I set field "infla" to "1,7" in row 1
Then field "ablagef" has value "nein"
And I save the current editor
And I close the current editor

Given I open an editor "indexseries" from table "(FixedAsset):(IndexSeries)" with command "NEW" for record "" 
And I set field "such" to "IDX2"
And I create a new row at the end of the table
And I set field "vdat" to "01.01.00" in row 1
And I set field "bdat" to "31.12.00" in row 1
And I set field "infla" to "1,7" in row 1
Then field "ablagef" has value "nein"
And I save the current editor
And I close the current editor

Given I open an editor "indexseries" from table "(FixedAsset):(IndexSeries)" with command "NEW" for record "" 
And I set field "such" to "IDX3"
And I create a new row at the end of the table
And I set field "vdat" to "01.01.00" in row 1
And I set field "bdat" to "31.12.00" in row 1
And I set field "infla" to "1,7" in row 1
Then field "ablagef" has value "nein"
And I save the current editor
And I close the current editor

Scenario: Anlagen anlegen und Indexreihen eintragen

Given I open an editor "anlage1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record "" 
And I set field "such" to "anlmidx1"
And I press button "bafamodell" to open a subeditor for "anlage1_afamod"
And I set field "bilkto" to "05200"
And I set field "andat" to "01.04.98"
And I set field "nmon" to "36"
And I set field "kkidx" to "IDX2"
And I respond with answer "ja" to the dialog with id "4475"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anlage2" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record "" 
And I set field "such" to "anlmidx2"
And I press button "bafamodell" to open a subeditor for "anlage2_afamod"
And I set field "bilkto" to "05200"
And I set field "andat" to "01.04.98"
And I set field "nmon" to "36"
And I set field "kkidx2" to "IDX3"
And I respond with answer "ja" to the dialog with id "4475"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Scenario: Loeschen ungenutzter Indexreihe

Given I open an editor "del_idx" from table "(FixedAsset):(IndexSeries)" with command "DELETE" for record "IDX1" 
Then field "ablagef" has value "nein"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: Loeschen von Anlage mit Indexreihe

Given I open an editor "anlage_loeschen" from table "(FixedAsset):(FixedAsset)" with command "DELETE" for record "anlmidx1" 
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: Loeschen von Indexreihe (verwendet in abgelegter Anlage)

Given I open an editor "del_idx2" from table "(FixedAsset):(IndexSeries)" with command "DELETE" for record "IDX2"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: Loeschen von Abschreibungsmodell (lebendige Anlage)

Given I open an editor "afamod_loeschen" from table "27:10" with command "DELETE" for record "anlmidx2" 
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: Loeschen von Indexreihe (Abschreibungsmodell zuvor geloescht - ehemals zugehoerige Anlage weiterhin lebendig)

Given I open an editor "idx_wieder_frei_loesch2" from table "(FixedAsset):(IndexSeries)" with command "DELETE" for record "IDX3"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor
