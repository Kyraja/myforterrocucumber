# *****************************************************************************
#  Name           : fibu_liefer_gegen_steuer_cu.feature
#  Autor          : jeffler
#  Verantwortlich : sih
#  Kontrolle      :
#  Funktion       : 
# *****************************************************************************
@persistent
Feature: zweizeilige Projektbuchungen, z.B.: Lieferant gegen Steuer mit Projekt

Background: Plausi Prüfung auf Projektreinheit bei Buchungen mit zwei Zeilen und Sonderkonten (Steuerkonto/Rundungsdifferenzkonto/Kursdifferenzkonto)

Given I'm logged in with password "sy"
And I set the fake date to "07.01.02"

Scenario: Pruefen Projektkore aktiv

Given I open an editor "firmenstammkonfig" from table "(Company):(Configuration)" with command "VIEW" for record "0k"
Then field "projekt" has value "ja" in row 0
Then field "kost" has value "ja" in row 0
And I close the current editor

Scenario: Buchung mit zwei Zeilen, ein Lieferant und eine Steuerkonto, Projektrein

Given I open an editor "lieferant-gegen-sonder" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "LISO" in row 0
And I set field "kprojekt" to "P10" in row 0
And I create a new row at the end of the table
And I set field "konto" to "L 001" in row 1
And I set field "ewsbetr" to "100" in row 1
And I create a new row at the end of the table
And I set field "konto" to "38010" in row 2
And I set field "projekt" to "P10" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
Given I open an editor "BLISO" from table "(Entry):(Entry)" with command "VIEW" for record "BLISO"
Then the table has 2 rows
Then field "kprojekt" has value "P10" in row 0
Then field "projekt" has value "" in row 1
Then field "projekt" has value "P10" in row 2
And I close the current editor

Scenario: Buchung mit zwei Zeilen, ein Lieferant und eine Steuerkonto, Projektrein, Projekteintrag nur im Kopf, Ergaenzung in der Zeile erwartet

Given I open an editor "lieferant-gegen-sonder" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "LISO1" in row 0
And I set field "kprojekt" to "P10" in row 0
And I create a new row at the end of the table
And I set field "konto" to "L 001" in row 1
And I set field "ewsbetr" to "100" in row 1
And I create a new row at the end of the table
And I set field "konto" to "38010" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
Given I open an editor "BLISO1" from table "(Entry):(Entry)" with command "VIEW" for record "BLISO1"
Then the table has 2 rows
Then field "kprojekt" has value "P10" in row 0
Then field "projekt" has value "" in row 1
Then field "projekt" has value "P10" in row 2
And I close the current editor

Scenario: Buchung mit zwei Zeilen, ein Lieferant und eine Steuerkonto, Projektrein,Projekteintrag nur in der Zeile, Ergaenzung im Kopf erwartet

Given I open an editor "lieferant-gegen-sonder" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "LISO2" in row 0
And I create a new row at the end of the table
And I set field "konto" to "L 001" in row 1
And I set field "ewsbetr" to "100" in row 1
And I create a new row at the end of the table
And I set field "konto" to "38010" in row 2
And I set field "projekt" to "P10" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
Given I open an editor "BLISO2" from table "(Entry):(Entry)" with command "VIEW" for record "BLISO2"
Then the table has 2 rows
Then field "kprojekt" has value "P10" in row 0
Then field "projekt" has value "" in row 1
Then field "projekt" has value "P10" in row 2
And I close the current editor

Scenario: Buchung mit zwei Zeilen, ein Lieferant und eine Steuerkonto, anderes Projekt in Zeile, NACH Eintrag in KOPF

Given I open an editor "lieferant-gegen-sonder2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "LISO3" in row 0
And I set field "kprojekt" to "P20" in row 0
And I create a new row at the end of the table
And I set field "konto" to "L 001" in row 1
And I set field "ewsbetr" to "100" in row 1
And I create a new row at the end of the table
And I set field "konto" to "38010" in row 2
And I set field "projekt" to "P10" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
Given I open an editor "BLISO3" from table "(Entry):(Entry)" with command "VIEW" for record "BLISO3"
Then the table has 2 rows
Then field "kprojekt" has value "P10" in row 0
Then field "projekt" has value "" in row 1
Then field "projekt" has value "P10" in row 2
And I close the current editor

Scenario: Buchung mit zwei Zeilen, ein Lieferant und eine Steuerkonto, anderes Projekt in Kopf, NACH Eintrag in ZEILE

Given I open an editor "lieferant-gegen-sonder2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "LISO4" in row 0
And I create a new row at the end of the table
And I set field "konto" to "L 001" in row 1
And I set field "ewsbetr" to "100" in row 1
And I create a new row at the end of the table
And I set field "konto" to "38010" in row 2
And I set field "projekt" to "P10" in row 2
And I set field "kprojekt" to "P20" in row 0
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
Given I open an editor "BLISO4" from table "(Entry):(Entry)" with command "VIEW" for record "BLISO4"
Then the table has 2 rows
Then field "kprojekt" has value "P20" in row 0
Then field "projekt" has value "" in row 1
Then field "projekt" has value "P20" in row 2
And I close the current editor

Scenario: Buchung mit zwei Zeilen, zwei Sonderkonten, Projekt im Kopf

Given I open an editor "sonder" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "SONDER0" in row 0
And I set field "kprojekt" to "P10" in row 0
And I create a new row at the end of the table
And I set field "konto" to "38010" in row 1
And I set field "ewsbetr" to "100" in row 1
And I create a new row at the end of the table
And I set field "konto" to "48420" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
Given I open an editor "BSONDER0" from table "(Entry):(Entry)" with command "VIEW" for record "BSONDER0"
Then the table has 2 rows
Then field "kprojekt" has value "P10" in row 0
Then field "projekt" has value "P10" in row 1
Then field "projekt" has value "P10" in row 2
And I close the current editor


Scenario: Buchung mit zwei Zeilen, zwei Sonderkonten, Projekt in einer Zeile

Given I open an editor "sonder" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "SONDER1" in row 0
And I create a new row at the end of the table
And I set field "konto" to "38010" in row 1
And I set field "ewsbetr" to "100" in row 1
And I set field "projekt" to "P10" in row 1
And I create a new row at the end of the table
And I set field "konto" to "48420" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
Given I open an editor "BSONDER1" from table "(Entry):(Entry)" with command "VIEW" for record "BSONDER1"
Then the table has 2 rows
Then field "kprojekt" has value "" in row 0
Then field "projekt" has value "" in row 1
Then field "projekt" has value "" in row 2
And I close the current editor


Scenario: Buchung mit zwei Zeilen, zwei Sonderkonten, Projekt in beiden Zeile

Given I open an editor "sonder" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "SONDER2" in row 0
And I create a new row at the end of the table
And I set field "konto" to "38010" in row 1
And I set field "ewsbetr" to "100" in row 1
And I set field "projekt" to "P10" in row 1
And I create a new row at the end of the table
And I set field "konto" to "48420" in row 2
And I set field "projekt" to "P10" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
Given I open an editor "BSONDER2" from table "(Entry):(Entry)" with command "VIEW" for record "BSONDER2"
Then the table has 2 rows
Then field "kprojekt" has value "P10" in row 0
Then field "projekt" has value "P10" in row 1
Then field "projekt" has value "P10" in row 2
And I close the current editor

Scenario: Buchung mit zwei Zeilen, zweimal der gleiche Lieferanten (Personenkonten) -> erlaubt
Given I open an editor "lieferanten" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "LIEFER0" in row 0
And I create a new row at the end of the table
And I set field "konto" to "L 001" in row 1
And I set field "ewsbetr" to "100" in row 1
And I create a new row at the end of the table
And I set field "konto" to "L 001" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Scenario: Buchung mit zwei Zeilen, zwei verschiedene Lieferanten (Personenkonten) -> nicht erlaubt

Given I open an editor "lieferanten" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "LIEFER1" in row 0
And I create a new row at the end of the table
And I set field "konto" to "L 001" in row 1
And I set field "ewsbetr" to "100" in row 1
And I create a new row at the end of the table
Then setting field "konto" to "L 002" in row 2 throws the exception "269"
And I close the current editor

Scenario: Buchung, Lieferant auf Aufwandskonto Steuerzeile wird ergänzt -> 3. Zeile

Given I open an editor "ergaenzt" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "ERG" in row 0
And I create a new row at the end of the table
And I set field "konto" to "L 001" in row 1
And I set field "ewsbetr" to "100" in row 1
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 2
And I set field "projekt" to "P10" in row 2
And I set field "kstelle" to "101" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
Given I open an editor "BERG" from table "(Entry):(Entry)" with command "VIEW" for record "BERG"
Then the table has 3 rows
Then field "kprojekt" has value "P10" in row 0
Then field "projekt" has value "" in row 1
Then field "projekt" has value "P10" in row 2
Then field "projekt" has value "P10" in row 3
And I close the current editor

Scenario: projektreine Buchung mit zwei Aufwandskonten, Steuerzeilen werden ergaenzt -> 5 Zeilen

Given I open an editor "aufwand" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "AUFWAND" in row 0
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewsbetr" to "100" in row 1
And I set field "projekt" to "P10" in row 1
And I set field "kstelle" to "101" in row 1
And I create a new row at the end of the table
And I set field "konto" to "50001" in row 2
And I set field "projekt" to "P10" in row 2
And I set field "kstelle" to "101" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
Given I open an editor "BAUFWAND" from table "(Entry):(Entry)" with command "VIEW" for record "BAUFWAND"
Then the table has 5 rows
Then field "kprojekt" has value "P10" in row 0
Then field "projekt" has value "P10" in row 1
Then field "projekt" has value "P10" in row 2
Then field "projekt" has value "P10" in row 3
Then field "projekt" has value "P10" in row 4
Then field "projekt" has value "P10" in row 5
And I close the current editor

Scenario: Buchung mit zwei Aufwandskonten und verschiedenen Projekten in der Tabelle, Steuerzeilen werden ergaenzt -> 5 Zeilen

Given I open an editor "aufwand" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "AUFWAND1" in row 0
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewsbetr" to "100" in row 1
And I set field "projekt" to "P10" in row 1
And I set field "kstelle" to "101" in row 1
And I create a new row at the end of the table
And I set field "konto" to "50001" in row 2
And I set field "projekt" to "20" in row 2
And I set field "kstelle" to "101" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
Given I open an editor "BAUFWAND1" from table "(Entry):(Entry)" with command "VIEW" for record "BAUFWAND1"
Then the table has 5 rows
Then field "kprojekt" has value "" in row 0
Then field "projekt" has value "P10" in row 1
Then field "projekt" has value "P20" in row 2
Then field "projekt" has value "" in row 3
Then field "projekt" has value "" in row 4
Then field "projekt" has value "" in row 5
And I close the current editor

Scenario: Buchung, Sonder- auf Aufwandskonto, Steuerzeile wird ergänzt

Given I open an editor "ergaenzt" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "ERG1" in row 0
And I create a new row at the end of the table
And I set field "konto" to "48420" in row 1
And I set field "ewsbetr" to "100" in row 1
And I set field "kstelle" to "101" in row 1
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 2
And I set field "projekt" to "P10" in row 2
And I set field "kstelle" to "101" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
Given I open an editor "BERG1" from table "(Entry):(Entry)" with command "VIEW" for record "BERG1"
Then the table has 3 rows
Then field "kprojekt" has value "P10" in row 0
Then field "projekt" has value "P10" in row 1
Then field "projekt" has value "P10" in row 2
Then field "projekt" has value "P10" in row 3
And I close the current editor







