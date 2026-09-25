# *****************************************************************************
#  Name           : bug_84651.feature
#  Autor          : fwester
#  Verantwortlich : @forterro-prd/t024-abas-core
#  Funktion       : Testet die eindeutige Feldselektion beim Aktualisieren.
#                   Vergleiche hierzu Fehler 84651 bzw. EAF-4192
# *****************************************************************************
@persistent
@BUG_84651_TEST
Feature: CRUD 65:1

   Given I'm logged in with password "sy"

   Background:
      And I enable the flag 364
      And I enable the flag 387

################################################################################

Scenario: Erzeuge neue Infosystemstammdaten

	   And I enable the flag 298

Given I open an editor "Infosystem neu" from table "(Infosystem):(Infosystem)" with command "NEW" for record ""
   And I set field "nummer" to "84651"
   And I set field "such" to "BUG84651"
   And I set field "arb" to "sy"
   And I set field "maskorigin" to "Automatisch erzeugen"
   And I set field "layoutorigin" to "Keine Ausgabe"
   And I set field "classname" to "Bug_84651"

# Ergänze das Feld isbuinfo, das ohne Präfix wie buinfosys beginnt.

   And I press button "tbuvein" in row 1
   And I set field "vitf" to "BU3" in rowspec "$,,vname==`"
   And I set field "inmask" to "1" in rowspec "$,,vname==`"
   And I set field "vprio" to "B" in rowspec "$,,vname==`"
   And I set field "vbed" to "Gleicher Basisname" in rowspec "$,,vname==`"
   And I set field "vname" to "isbuinfo" in rowspec "$,,vname==`"
   And I press button "buexportanpass"
And I close the current editor

################################################################################

Scenario: Veraenderunpsprio von isbuinfo auf A setzen

	   And I enable the flag 298

Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "BUG84651"
   And I set field "vprio" to "A" in rowspec "$,,vname==isbuinfo"
And I save the current editor
And I close the current editor

################################################################################

Scenario: Import der zuvor exportierten Anpassungen

Given I open an editor "Infosystem aendern" from table "(Infosystem):(Infosystem)" with command "UPDATE" for record "BUG84651"
   Then field "vprio" has value "A" in rowspec "$,,vname==isbuinfo"
   And I respond with answer "Ja" to the dialog with id "9968"
   And I press button "bureinitanpass"
   Then field "vprio" has value "B" in rowspec "$,,vname==isbuinfo"
And I save the current editor
And I close the current editor
