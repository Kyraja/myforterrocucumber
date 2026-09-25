# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
# *****************************************************************************
@persistent
Feature: Plausi zu Kostenumlagerückführung 

Background:
Given I set the fake date to "25.01.2002"

Scenario: Plausi: nur abgelegte Kostenumlagen  (ACHTUNG! HIER FAKEDATEN)

Given I'm logged in with password "annette"
Given I enable the flag 71

Given I open an editor "lebendig_machen" from table "(CostDistribution):(CostDistribution)" with command "MODIFY" for record "+U11-2ZEI"
And I set field "ablagef" to "false"
And I save the current editor

Given I disable the flag 71
Given I'm logged in with password "sy"

Given I set the fake date to "25.01.2002"

Given I open an editor "kostenumlrueck-11" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "111" 
And I set field "name" to "KMRF" 
# 10143 de      |Lebendige Objekte dürfen nicht verwendet werden
And setting field "origvorg" to "U11-2ZEI" throws the exception "10143"
And I close the current editor
