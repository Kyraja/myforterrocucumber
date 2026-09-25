@persistant
Feature: Editing CalenderCycle
Background:
Given I set the fake date to "2.2.2002"

Scenario: field_check_CalenderCycle
 
Given I open an editor "CC2" from table "(PlanningTimePeriod):(CalendarCycle)" with command "NEW" for record ""

# Keine Leereinträge bei zefaktor und zeiteinheit
	Then setting field "zefaktor" to "" throws the exception "2046"
	Then setting field "zeiteinheit" to "" throws the exception "8231"
	
# ändern der Zeiteinheit initialisiert
	And I set field "zeiteinheit" to "Woche"
    And I set field "wochemo" to "ja"
    And I set field "zeiteinheit" to "Tag"
    Then field "wochemo" has value "nein"

# Feld-Prüf und Feld-Nach von ztmonattag
	And I set field "zeiteinheit" to "Monat"
	And I set field "manzwochtag" to "1"
	Then setting field "monattag" to "32" throws the exception "1361"
    And I set field "monattag" to "30"
    Then field "manzwochtag" has value "0"
    
# Feld-Prüf und Feld-Nach von ztmanzwochtag
	And I set field "monattag" to "1"
	Then setting field "manzwochtag" to "7" throws the exception "1361"
    And I set field "manzwochtag" to "4"
    Then field "monattag" has value "0"

# Feld-Prüf von ztzqmonat
	And I set field "zeiteinheit" to "Quartal"
 	Then setting field "zqmonat" to "7" throws the exception "1361"

# Feld-Prüf von ztzqmonat
 	Then setting field "zqmonattag" to "32" throws the exception "1361"

# Feld-Prüf von ztjahrtim1
	And I set field "zeiteinheit" to "Jahr"
 	Then setting field "jahrtim1" to "32" throws the exception "1361"
  	Then setting field "jahrtim2" to "30" throws the exception "1361"	
 	Then setting field "jahrtim3" to "32" throws the exception "1361"
 	Then setting field "jahrtim4" to "31" throws the exception "1361"
  	Then setting field "jahrtim5" to "32" throws the exception "1361"	
 	Then setting field "jahrtim6" to "31" throws the exception "1361"
 	Then setting field "jahrtim7" to "32" throws the exception "1361"
  	Then setting field "jahrtim8" to "32" throws the exception "1361"	
 	Then setting field "jahrtim9" to "31" throws the exception "1361"
 	Then setting field "jahrtim10" to "32" throws the exception "1361"
  	Then setting field "jahrtim11" to "31" throws the exception "1361"	
 	Then setting field "jahrtim12" to "32" throws the exception "1361"
 
# Speichern
    And I set field "zeiteinheit" to "Tag"
    And I set field "such" to "Tag1"
    
And I save the current editor
And I close the current editor
