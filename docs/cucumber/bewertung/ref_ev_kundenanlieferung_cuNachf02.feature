# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Funktion       : 
#
# *****************************************************************************
#
@persistent
Feature: Kundenanlieferung
Background:
Given I set the fake date to "15.01.1995"


Scenario: Storno MN in Kundenanlieferung
Given I set the fake date to "16.01.1995"

@Mengenneubewertung
Scenario: Kommando <(QuantityRevaluation)>
Given I set the fake date to "17.01.1995"

Given I open an editor "SMN1" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+MN1SUCH"
And I set field "such" to "SMN1SUCH" 

And I save the current editor
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# ---------------------
