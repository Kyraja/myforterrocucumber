# *****************************************************************************
#  Name           : kvert_kopieren_mit_AP.feature
#  Autor          : Gisela Koehne
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Kopieren von statischen und dynamischen Kostenverteilern. Dabei müssen die Inhalte von Kundenfeldern übernommen werden.
#
# *****************************************************************************
@persistent
Feature: REWE-2542
Background:
Given I set the fake date to "31.12.2002"

# Kostenverteiler anlegen 
Scenario: Anlegen Stammkostenverteiler
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "NEW" for record ""
# Währungsfelder sind leer
# And I delete all rows
And I set field "nummer" to "550"
And I set field "such" to "KV550"
And I set field "kvkopf2" to "TEST"
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "41" in row 1
And I set field "kvzeile1" to "1" in row 1
And I set field "kvzeile4" to "Test1" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "59" in row 2
And I set field "kvzeile1" to "2" in row 2
And I set field "kvzeile4" to "Test2" in row 2
And I save the current editor
#
Scenario: In einer Finanzbuchung: dynamischen Kostenverteiler aus einem statischen Kopieren
Given I open an editor "BuchungKV_2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "31.12.02"
And I set field "beleg" to "BUKV_2"
And I set field "beldat" to "31.12.02"
And I create a new row at the end of the table 
And I set field "konto" to "50000" in row 1 
And I set field "ewsbetr" to "12000" in row 1
And I set field "kstelle" to "550" in row 1
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
# Wertinitialisierungen für dynamische Kostenverteiler
Then field "bsum" has value "12000.00"
Then field "brest" has value "0.00"
Then field "ebsum" has value "12000.00"
Then field "ebrest" has value "0.00"
Then field "kvkopf2" has value "TEST" 
Then field "kvzeile1" has value "1" in row 1
Then field "kvzeile4" has value "Test1" in row 1
Then field "kvzeile1" has value "2" in row 2
Then field "kvzeile4" has value "Test2" in row 2 
And I save the current editor
And I close the current editor
And I switch the current editor to editor "BuchungKV_2"
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 2
And I respond with answer "Ja" to the dialog with id "583" 
And I save the current editor
And I close the current editor
#
# Kostenverteiler anlegen 
Scenario: Anlegen Stammkostenverteiler aus Vorlage dynamischer Kostenverteiler
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "NEW" for record "(968,5,0)"
# Währungsfelder sind leer
# And I delete all rows
And I set field "nummer" to "551"
And I set field "such" to "KV551"
Then field "kvkopf2" has value "TEST" 
Then field "kvzeile1" has value "1" in row 1
Then field "kvzeile4" has value "Test1" in row 1
Then field "kvzeile1" has value "2" in row 2
Then field "kvzeile4" has value "Test2" in row 2 
And I save the current editor
