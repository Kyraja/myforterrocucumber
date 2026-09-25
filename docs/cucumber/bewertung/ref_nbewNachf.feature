@persistent
Feature: Storno
Background: Test Storno MN

# ---------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "31.12.95"

Given I open an editor "SMN1" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+KOPELPROD"
And I set field "such" to "SKOPELPROD" 

And I save the current editor
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# ---------------------
@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) C2 >
Given I set the fake date to "31.12.95"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.12.95"
And I set field "edat" to "."
And I set field "vart" to "KOPPEL"
And I press button "kosvor"

And I respond with answer "yes" to the dialog with id "2324"
And I save the current editor
# Then saving the current editor throws the exception "3641"
And I close the current editor

# ---------------------
