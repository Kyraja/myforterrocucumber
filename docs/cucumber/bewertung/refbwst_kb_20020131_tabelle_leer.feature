# es steht nichts an...
@Kostenbuchung
Scenario: Kommando <(CostEntriesSuggestion)>
Given I set the fake date to "31.01.2002"

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
# ---------------------

Given I open an editor "Kostenbuchung" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""

And I set field "adat" to "01.01.2002"
And I set field "edat" to "." 
And I press button "kosvor"

# And I respond with answer "yes" to the dialog with id "2324"

#    3641 de   |Die Tabelle ist leer
Then saving the current editor throws the exception "3641"

And I close the current editor
