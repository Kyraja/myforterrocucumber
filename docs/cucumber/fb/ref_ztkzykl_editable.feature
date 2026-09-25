@persistant
Feature: Editing CalenderCycle
Background:
Given I set the fake date to "2.2.2002"

Scenario: editable_CalenderCycle
 
Given I open an editor "CC1" from table "(PlanningTimePeriod):(CalendarCycle)" with command "NEW" for record ""
    Then field "nummer" is modifiable
    Then field "such" is modifiable
    Then field "zeiteinheit" is modifiable
    Then field "zefaktor" is modifiable
    Then field "suchrekal" is not modifiable
   	Then field "suchrakal" is modifiable
#
	Then field "wochemo" is not modifiable
	Then field "wochedi" is not modifiable
	Then field "wochemi" is not modifiable
	Then field "wochedo" is not modifiable
	Then field "wochefr" is not modifiable
	Then field "wochesa" is not modifiable
	Then field "wocheso" is not modifiable
#
	Then field "monattag" is not modifiable
	Then field "manzwochtag" is not modifiable
	Then field "mwochtag" is not modifiable
	Then field "zqmonat" is not modifiable
	Then field "zqmonattag" is not modifiable
#	
	Then field "jahrtim1" is not modifiable
	Then field "jahrtim2" is not modifiable
	Then field "jahrtim3" is not modifiable
	Then field "jahrtim4" is not modifiable
	Then field "jahrtim5" is not modifiable
	Then field "jahrtim6" is not modifiable
	Then field "jahrtim7" is not modifiable
	Then field "jahrtim8" is not modifiable
	Then field "jahrtim9" is not modifiable
	Then field "jahrtim10" is not modifiable
	Then field "jahrtim11" is not modifiable
	Then field "jahrtim12" is not modifiable
#
    And I set field "zeiteinheit" to "Tag"
#
    Then field "nummer" is modifiable
    Then field "such" is modifiable
    Then field "zeiteinheit" is modifiable
    Then field "zefaktor" is modifiable
    Then field "suchrekal" is not modifiable
   	Then field "suchrakal" is modifiable
#
	Then field "wochemo" is not modifiable
	Then field "wochedi" is not modifiable
	Then field "wochemi" is not modifiable
	Then field "wochedo" is not modifiable
	Then field "wochefr" is not modifiable
	Then field "wochesa" is not modifiable
	Then field "wocheso" is not modifiable
#
	Then field "monattag" is not modifiable
	Then field "manzwochtag" is not modifiable
	Then field "mwochtag" is not modifiable
	Then field "zqmonat" is not modifiable
	Then field "zqmonattag" is not modifiable
#	
	Then field "jahrtim1" is not modifiable
	Then field "jahrtim2" is not modifiable
	Then field "jahrtim3" is not modifiable
	Then field "jahrtim4" is not modifiable
	Then field "jahrtim5" is not modifiable
	Then field "jahrtim6" is not modifiable
	Then field "jahrtim7" is not modifiable
	Then field "jahrtim8" is not modifiable
	Then field "jahrtim9" is not modifiable
	Then field "jahrtim10" is not modifiable
	Then field "jahrtim11" is not modifiable
	Then field "jahrtim12" is not modifiable
##
    And I set field "zeiteinheit" to "Woche"
#
    Then field "nummer" is modifiable
    Then field "such" is modifiable
    Then field "zeiteinheit" is modifiable
    Then field "zefaktor" is modifiable
    Then field "suchrekal" is not modifiable
   	Then field "suchrakal" is modifiable
#
	Then field "wochemo" is modifiable
	Then field "wochedi" is modifiable
	Then field "wochemi" is modifiable
	Then field "wochedo" is modifiable
	Then field "wochefr" is modifiable
	Then field "wochesa" is modifiable
	Then field "wocheso" is modifiable
#
	Then field "monattag" is not modifiable
	Then field "manzwochtag" is not modifiable
	Then field "mwochtag" is not modifiable
	Then field "zqmonat" is not modifiable
	Then field "zqmonattag" is not modifiable
#	
	Then field "jahrtim1" is not modifiable
	Then field "jahrtim2" is not modifiable
	Then field "jahrtim3" is not modifiable
	Then field "jahrtim4" is not modifiable
	Then field "jahrtim5" is not modifiable
	Then field "jahrtim6" is not modifiable
	Then field "jahrtim7" is not modifiable
	Then field "jahrtim8" is not modifiable
	Then field "jahrtim9" is not modifiable
	Then field "jahrtim10" is not modifiable
	Then field "jahrtim11" is not modifiable
	Then field "jahrtim12" is not modifiable
##
    And I set field "zeiteinheit" to "Monat"
#
    Then field "nummer" is modifiable
    Then field "such" is modifiable
    Then field "zeiteinheit" is modifiable
    Then field "zefaktor" is modifiable
    Then field "suchrekal" is modifiable
   	Then field "suchrakal" is modifiable
#
	Then field "wochemo" is not modifiable
	Then field "wochedi" is not modifiable
	Then field "wochemi" is not modifiable
	Then field "wochedo" is not modifiable
	Then field "wochefr" is not modifiable
	Then field "wochesa" is not modifiable
	Then field "wocheso" is not modifiable
#
	Then field "monattag" is modifiable
	Then field "manzwochtag" is modifiable
	Then field "mwochtag" is modifiable
	Then field "zqmonat" is not modifiable
	Then field "zqmonattag" is not modifiable
#	
	Then field "jahrtim1" is not modifiable
	Then field "jahrtim2" is not modifiable
	Then field "jahrtim3" is not modifiable
	Then field "jahrtim4" is not modifiable
	Then field "jahrtim5" is not modifiable
	Then field "jahrtim6" is not modifiable
	Then field "jahrtim7" is not modifiable
	Then field "jahrtim8" is not modifiable
	Then field "jahrtim9" is not modifiable
	Then field "jahrtim10" is not modifiable
	Then field "jahrtim11" is not modifiable
	Then field "jahrtim12" is not modifiable

##
    And I set field "zeiteinheit" to "Quartal"
#
    Then field "nummer" is modifiable
    Then field "such" is modifiable
    Then field "zeiteinheit" is modifiable
    Then field "zefaktor" is modifiable
    Then field "suchrekal" is modifiable
   	Then field "suchrakal" is modifiable
#
	Then field "wochemo" is not modifiable
	Then field "wochedi" is not modifiable
	Then field "wochemi" is not modifiable
	Then field "wochedo" is not modifiable
	Then field "wochefr" is not modifiable
	Then field "wochesa" is not modifiable
	Then field "wocheso" is not modifiable
#
	Then field "monattag" is not modifiable
	Then field "manzwochtag" is not modifiable
	Then field "mwochtag" is not modifiable
	Then field "zqmonat" is modifiable
	Then field "zqmonattag" is modifiable
#	
	Then field "jahrtim1" is not modifiable
	Then field "jahrtim2" is not modifiable
	Then field "jahrtim3" is not modifiable
	Then field "jahrtim4" is not modifiable
	Then field "jahrtim5" is not modifiable
	Then field "jahrtim6" is not modifiable
	Then field "jahrtim7" is not modifiable
	Then field "jahrtim8" is not modifiable
	Then field "jahrtim9" is not modifiable
	Then field "jahrtim10" is not modifiable
	Then field "jahrtim11" is not modifiable
	Then field "jahrtim12" is not modifiable
##
    And I set field "zeiteinheit" to "Jahr"
#
    Then field "nummer" is modifiable
    Then field "such" is modifiable
    Then field "zeiteinheit" is modifiable
    Then field "zefaktor" is modifiable
    Then field "suchrekal" is modifiable
   	Then field "suchrakal" is modifiable
#
	Then field "wochemo" is not modifiable
	Then field "wochedi" is not modifiable
	Then field "wochemi" is not modifiable
	Then field "wochedo" is not modifiable
	Then field "wochefr" is not modifiable
	Then field "wochesa" is not modifiable
	Then field "wocheso" is not modifiable
#
	Then field "monattag" is not modifiable
	Then field "manzwochtag" is not modifiable
	Then field "mwochtag" is not modifiable
	Then field "zqmonat" is not modifiable
	Then field "zqmonattag" is not modifiable
#	
	Then field "jahrtim1" is modifiable
	Then field "jahrtim2" is modifiable
	Then field "jahrtim3" is modifiable
	Then field "jahrtim4" is modifiable
	Then field "jahrtim5" is modifiable
	Then field "jahrtim6" is modifiable
	Then field "jahrtim7" is modifiable
	Then field "jahrtim8" is modifiable
	Then field "jahrtim9" is modifiable
	Then field "jahrtim10" is modifiable
	Then field "jahrtim11" is modifiable
	Then field "jahrtim12" is modifiable
	
# Speichern
    And I set field "zeiteinheit" to "Tag"
    And I set field "such" to "Tag1"
    
And I save the current editor
And I close the current editor


