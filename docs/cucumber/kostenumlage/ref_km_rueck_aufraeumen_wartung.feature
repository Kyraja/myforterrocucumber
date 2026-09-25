# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
# *****************************************************************************
@persistent
Feature: Test Kostenumlagerückführungen aufräumen und Buchungen bereinigen 

# ------------------------------------------------------------------------------------------------
Background:
# ------------------------------------------------------------------------------------------------
#  OP-s kann man nur in Wartung aufräumen, deshalb hier separat Wartung
#  das geht im Aufräumen auch nur im allein-modus und der wiederum geht nur 
#  mit login im background :(

Given I'm logged in with password "annette"
Given I set the fake date to "31.01.2003"


# ------------------------------------------------------------------------------------------------
Scenario:  Offener Posten ausbuchen
# ------------------------------------------------------------------------------------------------

Given I set the fake date to "31.12.2002"

Given I open an editor "OP-Bearbeitung" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I set field "opausgleich" to "ja"
And I press button "opladen"
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

# ------------------------------------------------------------------------------------------------
Scenario:  aufraeumen
# ------------------------------------------------------------------------------------------------
Given I set the fake date to "31.01.2003"

Given I open an editor "CleanUp" for tip command "(CleanUp)" and arguments ""
And I set field "obj" to "Offene Posten"
# And I create a new row at the end of the table
And I set field "stich" to "31.12.2002" in row 1
And I respond with answer "Ja" to the dialog with id "2077"
And I save the current editor


Given I open an editor "CleanUp" for tip command "(CleanUp)" and arguments ""
And I set field "obj" to "Einkauf"
Then field "vorg" has value "Lieferschein" in row 4
And I set field "stich" to "31.12.2002" in row 4

Then field "vorg" has value "Rechnung" in row 5
And I set field "stich" to "31.12.2002" in row 5

And I respond with answer "Ja" to the dialog with id "2077"
And I save the current editor
