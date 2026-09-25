@persistent
Feature: Storno MN
Background: Test von Stornos MN
Given I set the fake date to "31.12.1995"

@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "31.12.1995"

Given I open an editor "MN1" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN1SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art=T20;buart=3;mge=1;platz=F1;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "20" in row 1
And I set field "nbewertet" to "direkt" in row 1


And I create a new row at the end of the table
And I set field "vorgang" to "$,,such==LERSTER10ER;art==E2;buart=1;mge=10;@datei=10;@gruppe=1;@ablageart=lebendig" in row 2
And I set field "ntbewpr" to "60" in row 2
# And I set field "nbewertet" to "direkt" in row 2

And I save the current editor
And I close the current editor


# cucu kostenbuchung #@Kostenbuchung
# cucu kostenbuchung #Scenario: Kommando <(CostEntriesSuggestion) A >
# cucu kostenbuchung #Given I set the fake date to "31.12.1995"
# cucu kostenbuchung #
# cucu kostenbuchung #Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
# cucu kostenbuchung #
# cucu kostenbuchung #And I set field "adat" to "01.12.1995" 
# cucu kostenbuchung #And I set field "edat" to "." 
# cucu kostenbuchung #And I press button "kosvor"
# cucu kostenbuchung #
# cucu kostenbuchung #And I respond with answer "yes" to the dialog with id "2324"
# cucu kostenbuchung #
# cucu kostenbuchung #And I save the current editor
# cucu kostenbuchung #
# cucu kostenbuchung #And I close the current editor


@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "31.12.1995"

Given I open an editor "SMN1" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MN1"
And I set field "such" to "SMN1SUCH" 

And I save the current editor
And I close the current editor

