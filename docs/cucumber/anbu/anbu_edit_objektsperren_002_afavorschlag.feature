# *****************************************************************************
#  Name             : anbu_edit_objektsperren_002_afavorschlag.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Sperren bei AfA-Vorschlag
#
#
#
# *****************************************************************************
@persistent
Feature: anbu_edit_objektsperren_002_afavorschlag.feature
Background: Sperren bei AfA-Vorschlag

Given I set the fake date to "01.03.01"


Scenario: gesperrter Kostenverteiler

# AfA-Vorschlag fuer 1-3 2002
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001aaa"
And I set field "gjahr" to "02"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I set field "vanl" to "520003"
And I set field "banl" to "520003"
And I press button "afaerm"
Then the table has 1 rows
#
Then field "buanlage" has value "520003" in row 1
Then field "statusico" has value "icon:ball_red" in row 1
Then field "tafaftxt" is not empty in row 1
Then field "buchen" has value "nein" in row 1

Then field "tkstelle" has value "1004" in row 1
#
Then saving the current editor throws the exception "2743"
Then saving the current editor throws the exception "4806"
And I close the current editor
# =========================================================================================


Scenario: Kostenverteiler mit gesperrten Kostenobjekten

# AfA-Vorschlag fuer 3-3 2001
Given I open an editor "vorschlag-2" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001bbb"
And I set field "gjahr" to "01"
And I set field "vmon" to "3"
And I set field "bmon" to "3"
And I set field "vanl" to "770000"
And I set field "banl" to "770000"
And I press button "afaerm"
Then the table has 1 rows
#
Then field "buanlage" has value "770000" in row 1
Then field "statusico" has value "icon:ball_red" in row 1
Then field "buchen" has value "nein" in row 1
Then field "tafaftxt" has value "Kostenverteiler enthält gesperrte Objekte." in row 1

Then field "tkstelle" has value "1001" in row 1
#
# Wenn man die Zeile aktiviert, dann gibt es eine ADM.FEHL
# And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: gesperrter Kostentraeger

# AfA-Vorschlag fuer 1-3 2002
Given I open an editor "vorschlag-3" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001ccc"
And I set field "gjahr" to "02"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I set field "vanl" to "440002"
And I set field "banl" to "440002"
And I press button "afaerm"
Then the table has 1 rows
#
Then field "buanlage" has value "440002" in row 1
Then field "statusico" has value "icon:ball_red" in row 1
Then field "tafaftxt" is not empty in row 1
Then field "buchen" has value "nein" in row 1

Then field "tkstelle" has value "100000a" in row 1
#
Then saving the current editor throws the exception "2743"
Then saving the current editor throws the exception "4806"
And I close the current editor
# =========================================================================================


Scenario: gesperrtes Konto bei der Anlage

# Konto sperren
Given I open an editor "konto-sperren1" from table "(Account):(Account)" with command "UPDATE" for record "62200"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
And I save the current editor
And I close the current editor


# AfA-Vorschlag fuer 1-3 2002
Given I open an editor "vorschlag-4" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001ddd"
And I set field "gjahr" to "02"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I set field "vanl" to "135002"
And I set field "banl" to "135002"
And I press button "afaerm"
Then the table has 1 rows
#
Then field "buanlage" has value "135002" in row 1
Then field "statusico" has value "icon:ball_red" in row 1
Then field "tafaftxt" is not empty in row 1
Then field "buchen" has value "nein" in row 1

Then field "tkstelle" has value "" in row 1
Then field "bukto" has value "62200" in row 1
#
Then saving the current editor throws the exception "2743"
Then saving the current editor throws the exception "4806"
And I close the current editor


# Konto entsperren
Given I open an editor "konto-sperren1" from table "(Account):(Account)" with command "UPDATE" for record "62200"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor
# =========================================================================================



Scenario: STORNO mit gesperrten Kostenobjekten

# AfA-Vorschlag fuer 1-3 2002
Given I open an editor "vorschlag-5" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001eee"
And I set field "gjahr" to "02"
And I set field "vmon" to "1"
And I set field "bmon" to "3"
And I set field "vanl" to "690007"
And I set field "banl" to "690007"
And I press button "afaerm"
Then the table has 1 rows
#
Then field "buanlage" has value "690007" in row 1
Then field "statusico" has value "icon:ball_green" in row 1
Then field "tafaftxt" is empty in row 1
Then field "buchen" has value "ja" in row 1
Then field "tkstelle" has value "100c" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# KST 100c wird gesperrt
Given I open an editor "kstelle-sperren1" from table "(Account):(CostCenter)" with command "UPDATE" for record "100a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
And I save the current editor
And I close the current editor

#
# AfA-Vorschlag 001eee wird storniert
Given I open an editor "vorschlag-storno" from table "(FixedAsset):(DepreciationSuggestion)" with command "REVERSAL" for record "+001eee"
And I set field "nummer" to "001storno"
And I save the current editor
And I close the current editor
# =========================================================================================

