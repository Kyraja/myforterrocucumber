# *****************************************************************************
#  Name             : ref_138_einkauf_verkauf_003_sammeln.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Sammeln in der Buchung: "kvnum" wird beruecksichtigt
#
# *****************************************************************************
@persistent
Feature: ref_138_einkauf_verkauf_003_sammeln.feature
Background:


Scenario: Sammeln in der Buchung

Given I open an editor "auftrag410" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "410au"
When I create a new row at the end of the table
And I set field "artex" to "V3" in row 1
And I set field "mge" to "120" in row 1
And I set field "preis" to "35" in row 1
And I set field "platz" to "F1" in row 1
Then field "kvnum" is modifiable in row 1
Then field "kvnum" has value "" in row 1
And I set field "kvnum" to "test410" in row 1
When I create a new row at the end of the table
And I set field "artex" to "ANZ" in row 2
Then field "kvnum" is modifiable in row 2
Then field "kvnum" has value "" in row 2
When I create a new row at the end of the table
And I set field "artex" to "ANZ" in row 3
Then field "kvnum" is modifiable in row 3
Then field "kvnum" has value "" in row 3
And I set field "kvnum" to "anz410" in row 3
When I create a new row at the end of the table
And I set field "artex" to "ANZ" in row 4
Then field "kvnum" is modifiable in row 4
Then field "kvnum" has value "" in row 4
When I create a new row at the end of the table
And I set field "artex" to "ANZ" in row 5
Then field "kvnum" is modifiable in row 5
Then field "kvnum" has value "" in row 5
And I save the current editor


# Anzahlungsrechnung1 anlegen
Given I open an editor "anzahlungsrechnung410" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag410"
Then field "vorgang" has value "R" in row 0
Then the table has 5 rows
And I set field "vorgang" to "Anzahlung"
Then field "vorgang" has value "A" in row 0
Then the table has 4 rows
And I set field "nummer" to "410anz"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
#
Then field "artex" has value "11" in row 1
Then field "kvnum" is modifiable in row 1
Then field "kvnum" has value "410au" in row 1
And I set field "pwert" to "100" in row 1
#
When I create a new row at the end of the table
Then field "artex" has value "11" in row 2
Then field "kvnum" is modifiable in row 2
Then field "kvnum" has value "anz410" in row 2
And I set field "pwert" to "200" in row 2
#
When I create a new row at the end of the table
Then field "artex" has value "11" in row 3
Then field "kvnum" is modifiable in row 3
Then field "kvnum" has value "410au" in row 3
And I set field "pwert" to "300" in row 3
#
When I create a new row at the end of the table
Then field "artex" has value "11" in row 4
Then field "kvnum" is modifiable in row 4
Then field "kvnum" has value "410au" in row 4
And I set field "pwert" to "400" in row 4
#
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Schlussrechnung aus dem Auftrag
Given I open an editor "schlussrechnung410" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag410"
And I set field "nummer" to "410re"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
Then the table has 5 rows
And I press button "offueb" in row 1
Then field "kvnum" has value "test410" in row 1
#
Then field "artex" has value "11" in row 2
Then field "kvnum" is modifiable in row 2
Then field "kvnum" has value "410au" in row 2
Then field "pwert" has value "-100.00" in row 2
#
When I create a new row at the end of the table
Then field "artex" has value "11" in row 3
Then field "kvnum" is modifiable in row 3
Then field "kvnum" has value "anz410" in row 3
Then field "pwert" has value "-200.00" in row 3
#
When I create a new row at the end of the table
Then field "artex" has value "11" in row 4
Then field "kvnum" is modifiable in row 4
Then field "kvnum" has value "410au" in row 4
Then field "pwert" has value "-300.00" in row 4
#
When I create a new row at the end of the table
Then field "artex" has value "11" in row 5
Then field "kvnum" is modifiable in row 5
Then field "kvnum" has value "410au" in row 5
Then field "pwert" has value "-400.00" in row 5
#
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Buchung pruefen
Given I open an editor "buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,@richtung=rückwärts;@maxtreffer=1"
Then the table has 5 rows
Then field "kvnum" has value "410re" in row 1
#
Then field "konto" has value "44000" in row 2
Then field "kvnum" has value "test410" in row 2
Then field "ewhbetr" has value "84000.00" in row 2
#
# 100 + 300 + 400
Then field "konto" has value "44000" in row 3
Then field "kvnum" has value "410au" in row 3
Then field "ewsbetr" has value "800.00" in row 3
#
# 200
Then field "konto" has value "44000" in row 4
Then field "kvnum" has value "anz410" in row 4
Then field "ewsbetr" has value "200.00" in row 4
And I close the current editor
########################################################################################################

