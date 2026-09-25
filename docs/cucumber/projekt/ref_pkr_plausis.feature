# *****************************************************************************
#  Name             : ref_pkr_plausis.feature
#  Autor            : Waldemar Neufeld
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis fuer die Projektfeldern im Editor "Bewertung"
#
# *****************************************************************************
@persistent
Feature: Plausis im Editor "Bewertung"

@FALL-Bewertungstabelle1
Scenario: FALL-Bewertungstabelle1

# eine Bewertung mit gefuellten Projektfeldern finden
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "UPDATE" for search criteria "$,,0:gebucht==(No);1:projekt2<>`;1:projekt<>`;1:zn==1;@richtung=(Backwards);@ablageart=(Active);@maxtreffer=1;@zeilen=(Yes)"
Then field "projekt" is not empty in row 1
Then field "projekt2" is not empty in row 1

# Projektfelder leeren
# frueher gab es an der Stelle eine Diag. -> BUG 83706.
And I set field "projekt2" to "" in row 1
And I set field "projekt" to "" in row 1

Then field "projekt" is empty in row 1
Then field "projekt2" is empty in row 1

# ohne Speichern schliessen
And I close the current editor
