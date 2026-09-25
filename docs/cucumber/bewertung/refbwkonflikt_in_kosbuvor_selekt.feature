# *****************************************************************************
#  Autor            : uo
#  Verantwortlich   : uo
# *****************************************************************************
@persistent
Feature: Bewertungskonflikt in Kosbuvor selektieren
 
Background:
Given I set the fake date to "30.4.2002"


Scenario: Nur rote selektieren, hier nur 2 Konfliktzeilen

# es existieren aus dem vorgänger genau 2 Konfliktbewertungen. Ihre Erzeugung passiert dort
# damit werden in der verbesserten version genau die beiden bewertungen selektiert
Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "NURKONFLIKTE"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "01.04.02"
And I set field "edat" to "30.04.02"
And I set field "vart" to "E1A-VLI"
And I set field "ursache" to "Lieferschein"
And I set field "buart" to "Zugang"

And I set field "verbausw" to "nein"
And I set field "verbhbedarfausw" to "nein"
And I set field "niverbausw" to "ja"

And I press button "kosvor"
# And I respond with answer "JA" to the dialog with id "2324"
And I respond with answer "JA" to the dialog with id "9402"

# tabelle ist leer, weil selektionsfehler noch nicht behoben 
# And saving the current editor throws the exception "3641"
And I save the current editor
