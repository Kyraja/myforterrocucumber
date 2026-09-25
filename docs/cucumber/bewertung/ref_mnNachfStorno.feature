@persistent
Feature: Storno
Background: Test Storno MN Lager und Umlagern


# ---------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "29.12.95"

Given I open an editor "SMN1" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MN017"
And I set field "such" to "SMN017" 

And I save the current editor
And I close the current editor

# ---------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "29.12.95"

Given I open an editor "MN22" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN017B" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art=KICIA;buart=1;platz=L3F1;mge=24;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1

And I set field "ntbewpr" to "40" in row 1
And I set field "nbewertet" to "vorlaeufig" in row 1

And I save the current editor
And I close the current editor



# ---------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "30.12.95"

Given I open an editor "SMNSKRA" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+SKRA"
And I set field "such" to "SMNSKRA" 

And I save the current editor
And I close the current editor




# ---------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "30.12.95"

Given I open an editor "SRUDY102" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+RUDY102"
And I set field "such" to "SRUDY102" 

And I save the current editor
And I close the current editor



# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# ---------------------
@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) C2 >
Given I set the fake date to "30.12.95"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.12.95"
And I set field "edat" to "."
And I press button "kosvor"

And I respond with answer "yes" to the dialog with id "2324"
And I save the current editor
And I close the current editor

# ---------------------
