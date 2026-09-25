# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : sih, ak
# *****************************************************************************
@persistent
Feature: BW2-1520 Rückführung von Kostenumlagen 

Background:
Given I set the fake date to "02.01.2002"

# ---------------------------------------------------------------------------------------------
Scenario: 
# ---------------------------------------------------------------------------------------------

Given I'm logged in with password "sy"
Given I set the fake date to "02.01.2002"

Given I open an editor "kmr" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "such" to "rueck7"
And I set field "origvorg" to "+U-7Z-TRANS"
And I set field "zurueckfuehren" to "nein" in row 1
And I set field "zurueckfuehren" to "nein" in row 4
And I set field "zurueckfuehren" to "nein" in row 7
And I save the current editor
