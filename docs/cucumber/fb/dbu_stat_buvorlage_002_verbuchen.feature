# *****************************************************************************
#  Name             : dbu_stat_buvorlage_002_verbuchen.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Dauerbuchungsvorschlaege verbuchen
#
# *****************************************************************************
@persistent
Feature: dbu_stat_buvorlage_002_verbuchen.feature
Background: Dauerbuchungsvorschlaege verbuchen

Given I set the fake date to "11.02.02"


Scenario: stat. Vorlagen

Given I open an editor "DBV1" from table "(RecurringEntry):(RecurringEntrySuggestion)" with command "NEW" for record ""
And I set field "such" to "DBV-ST1"
And I set field "selr" to "DBR-WOCH"
And I set field "selbuart" to "statistische Buchung"
And I set field "selerstbd" to "1.1.02"
And I set field "selletztbd" to "31.10.02"
And I press button "selladen"
#

Then field "iwbu" has value "EUR" in row 1
Then field "erfwaehr" has value "EUR" in row 1
Then field "vfxrbudat" has value "nein" in row 1
Then field "ewekurs" has value "1.000000" in row 1
Then field "vewekurs" has value "1.000000" in row 1
Then field "veikurs" has value "1.000000" in row 1
Then field "eikurs" has value "1.000000" in row 1
And I press button "bucheschl" to open a subeditor for "Verbuchen" in row 0 with dialog "6932" and answer "Ja"

And I save the current editor
And I close the current editor
# =========================================================================================

