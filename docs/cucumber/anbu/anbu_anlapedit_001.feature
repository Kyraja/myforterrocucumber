# *****************************************************************************
#  Name             : anbu_anlapedit_0001.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Cucumberscript zum Test ref_anlapedit
#
# *****************************************************************************

@persistent
Feature: anlapedit
Scenario: anlapedit

# Given I set the fake date to "19950101"

# ***************************************************************************
#  Verpfuschen der Konfiguration für editierb. AfA-Vorschläge 
# ***************************************************************************

Given I open an editor "anl-500" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"
Then setting field "apedit" to "nein" throws the exception "551"
And I set field "anlvlad" to "ja"
And I save the current editor
And I close the current editor

#  **************************************************************************
#  Fehlerhafte Abschreibungsvorschläge
#  -----------------------------------
#  
#  **************************************************
#  Anderes Abschreibungskonto (--> ok)
#  **************************************************

Given I open an editor "abvor-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "bmon" to "12"
And I create a new row at the end of the table
And I set field "buanlage" to "50000" in row 1
And I set field "bukto" to "62600" in row 1
And I close the current editor

#  **************************************************
#  Fehlerhaftes BilanzkontoKonto
#  **************************************************

Given I open an editor "abvor-2" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "bmon" to "12"
And I create a new row at the end of the table
And I set field "buanlage" to "50000" in row 1
Then setting field "gbukto" to "06500" in row 1 throws the exception "4404"
And I close the current editor

#  **************************************************
#  Fehlerhafter AfA-Betrag (zu viel AfA)
#  **************************************************

Given I open an editor "abvor-3" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "bmon" to "12"
And I create a new row at the end of the table
And I set field "buanlage" to "50000" in row 1
Then setting field "betrag" to "5000000" in row 1 throws the exception "4405"
And I close the current editor

#  **************************************************
#  Fehlerhafter AfA-Betrag (zu viel AfA storniert)
#  **************************************************

Given I open an editor "abvor-4" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "bmon" to "12"
And I create a new row at the end of the table
And I set field "buanlage" to "50000" in row 1
Then setting field "betrag" to "-5000000" in row 1 throws the exception "4405"
And I close the current editor

#  ************************************************** 
#  Plausibler Abschreibungsvorschlag für das Jahr 94
#  ************************************************** 

Given I open an editor "abvor-5" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "bmon" to "12"
And I create a new row at the end of the table
And I set field "buanlage" to "50000" in row 1
And I set field "bukto" to "62200" in row 1
And I set field "gbukto" to "04200" in row 1
And I set field "tkstelle" to "100" in row 1
And I set field "betrag" to "350.88" in row 1
And I set field "buchen" to "ja" in row 1
And I create a new row at the end of the table
And I set field "buanlage" to "50010" in row 2
And I set field "bukto" to "62200" in row 2
And I set field "gbukto" to "04200" in row 2
And I set field "tkstelle" to "100" in row 2
And I set field "betrag" to "200.00" in row 2
And I set field "buchen" to "ja" in row 2
And I create a new row at the end of the table
And I set field "buanlage" to "50020" in row 3
And I set field "bukto" to "62200" in row 3
And I set field "gbukto" to "04200" in row 3
And I set field "tkstelle" to "100" in row 3
And I set field "betrag" to "4936.31" in row 3
And I set field "buchen" to "ja" in row 3
And I create a new row at the end of the table
And I set field "buanlage" to "50040" in row 4
And I set field "bukto" to "62200" in row 4
And I set field "gbukto" to "04200" in row 4
And I set field "tkstelle" to "100" in row 4
And I set field "betrag" to "4210.53" in row 4
And I set field "buchen" to "ja" in row 4
And I create a new row at the end of the table
And I set field "buanlage" to "50050" in row 5
And I set field "bukto" to "62200" in row 5
And I set field "gbukto" to "04200" in row 5
And I set field "tkstelle" to "100" in row 5
And I set field "betrag" to "10526.32" in row 5
And I set field "buchen" to "ja" in row 5
And I create a new row at the end of the table
And I set field "buanlage" to "60000" in row 6
And I set field "bukto" to "62200" in row 6
And I set field "gbukto" to "04400" in row 6
And I set field "betrag" to "310.88" in row 6
And I set field "buchen" to "ja" in row 6
And I create a new row at the end of the table
And I set field "buanlage" to "100004" in row 7
And I set field "bukto" to "62200" in row 7
And I set field "gbukto" to "05200" in row 7
And I set field "tkstelle" to "100" in row 7
And I set field "betrag" to "44.26" in row 7
And I set field "buchen" to "ja" in row 7
And I create a new row at the end of the table
And I set field "buanlage" to "100007" in row 8
And I set field "bukto" to "62200" in row 8
And I set field "gbukto" to "05200" in row 8
And I set field "tkstelle" to "100" in row 8
And I set field "betrag" to "62.43" in row 8
And I set field "buchen" to "ja" in row 8
And I create a new row at the end of the table
And I set field "buanlage" to "100009" in row 9
And I set field "bukto" to "62200" in row 9
And I set field "gbukto" to "06500" in row 9
And I set field "tkstelle" to "100" in row 9
And I set field "betrag" to "12.22" in row 9
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

#  **************************************************
#  Stornierung von Buchungen
#  **************************************************

Given I open an editor "buch-32" from table "(Entry):(Entry)" with command "REVERSAL" for record "32"
And I respond with answer "ja" to the dialog with id ""
And I save the current editor
And I close the current editor

#  ************************************************** 

Given I open an editor "anl-50000" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "50000"
And I save the current editor
And I close the current editor
Given I open an editor "anl-50000" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "50000"
And I press button "bafamodell" to open a subeditor for "anl-50000-afamod"
Then setting field "bumafa" to "19940416" throws the exception "203"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor








