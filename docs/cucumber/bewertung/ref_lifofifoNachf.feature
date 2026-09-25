@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "21.08.1996"

@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "21.08.1996"

Given I open an editor "MNMPR" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNMPRSUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art=MZ;verw==Bond;buart=3;mge=7;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1

And I set field "ntbewpr" to "20" in row 1
And I set field "nbewertet" to "direkt" in row 1

And I save the current editor
And I close the current editor


@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "21.08.1996"

Given I open an editor "MN2" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN2SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art=E3;verw=`;buart=3;mge=5;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1

And I set field "ntbewpr" to "30" in row 1
And I set field "nbewertet" to "direkt" in row 1

And I save the current editor
And I close the current editor


@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) A >
Given I set the fake date to "21.08.1996"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.08.1996" 
And I set field "edat" to "." 
And I press button "kosvor"

And I respond with answer "yes" to the dialog with id "2324"
# 5567=WEITER?, JEDOCH SIND EIGENTLICH FOLGENDE FRAGEN INHALTLICH ENTSCHEIDEND!
# Kostenbuchungen ab Startdatum %s erzeugen. oder...
# Kostenbuchungsvorschlag speichern und Startdatum auf den %s setzen.
# And I respond with answer "yes" to the dialog with id "5667"
And I save the current editor

And I close the current editor


@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "22.08.1996"

Given I open an editor "SMN" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MNMPRSUCH"
And I set field "such" to "SMNMPRSUCH" 

And I save the current editor
And I close the current editor

@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "22.08.1996"

Given I open an editor "SMN2" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MN2SUCH"
And I set field "such" to "SMN2SUCH"

And I save the current editor
And I close the current editor


@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) A >
Given I set the fake date to "22.08.1996"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.08.1996"
And I set field "edat" to "." 
And I press button "kosvor"

And I respond with answer "yes" to the dialog with id "2324"
# 5567=WEITER?, JEDOCH SIND EIGENTLICH FOLGENDE FRAGEN INHALTLICH ENTSCHEIDEND!
# Kostenbuchungen ab Startdatum %s erzeugen. oder...
# Kostenbuchungsvorschlag speichern und Startdatum auf den %s setzen.
# And I respond with answer "yes" to the dialog with id "5667"
And I save the current editor

And I close the current editor

# ------------------------------------------------------------
@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "23.08.1996"

Given I open an editor "MN3" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN3SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,vorgang^kopf^nummer==04099;mge==4;art==Q;buarta=Zugang;detursache==Umlagerungslieferschein Einkauf;@datei=10;@gruppe=1" in row 1

And I set field "ntbewpr" to "35" in row 1
And I set field "nbewertet" to "direkt" in row 1

And I save the current editor
And I close the current editor


@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "24.08.1996"

Given I open an editor "SMN3" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MN3SUCH"
And I set field "such" to "SMN3SUCH"

And I save the current editor
And I close the current editor


@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "25.08.1996"

Given I open an editor "MN4" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MN4SUCH" 

Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,vorgang^kopf^nummer==04099;mge==4;art==Q;buarta=Zugang;detursache==Umlagerungslieferschein Einkauf;@datei=10;@gruppe=1" in row 1

And I set field "ntbewpr" to "15" in row 1
And I set field "nbewertet" to "direkt" in row 1

And I save the current editor
And I close the current editor


@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion) A >
Given I set the fake date to "25.08.1996"

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.08.1996"
And I set field "edat" to "." 
And I press button "kosvor"

And I respond with answer "yes" to the dialog with id "2324"
# 5567=WEITER?, JEDOCH SIND EIGENTLICH FOLGENDE FRAGEN INHALTLICH ENTSCHEIDEND!
# Kostenbuchungen ab Startdatum %s erzeugen. oder...
# Kostenbuchungsvorschlag speichern und Startdatum auf den %s setzen.
# And I respond with answer "yes" to the dialog with id "5667"
And I save the current editor

And I close the current editor
