# *****************************************************************************
#  Name             : fibucopy_budat_nicht_bebuchbar.feature
#  Autor            : jeffler
#  Verantwortlich   : uo
#  Kontrolle        : 
#  Funktion         : Test zu REWE-3554: Diag -1111 Währung fehlerhaft, 
#                     in buewbu_nach(), 
#                     wenn Buchungsdatum in der Finanzbuchung leer
#
# *****************************************************************************
@persistent

Feature: fibucopy_budat_nicht_bebuchbar
Background: Finanzbuchung kopieren

Given I set the fake date to "07.02.2002"

Scenario: GJ-Tabelle pruefen

Given I open an editor "gjtab" from table "(Company):(FinancialDates)" with command "VIEW" for record "2"
Then the table has 7 rows
Then field "gjahr" has value "00" in row 1
Then field "gjkenn" has value "aktuell" in row 3
Then field "offmon" has value "1-12" in row 3
Then field "gjahr" has value "06" in row 7

Scenario: Finanzbuchung anlegen und buchen

Given I open an editor "fibu" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "fbzrgschl"
And I set field "text" to "Finanzbuchung mit Buchungsdatum in, nach dem Verbuchen der Buchung, abgeschlossenem Zeitraum"
And I set field "budat" to "07.01.02"
And I append rows
|konto|ewsbetr|ewhbetr|
|K 001|    100|       |
|16000|       |    100|
# 1941 : Buchung o.k., Automatische Belegnummer?
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: Zeitraum in welchem die Finanzbuchung liegt abschliessen

Given I open an editor "abschl" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "such" to "AB"
And I press button "fbbbu" in row 4
Then field "fbbbu" has value "icon:ball_red" in row 4
# 7626 : Aktion wirklich durchfuehren?
And I respond with answer "ja" to the dialog with id "7626"
And I save the current editor
And I close the current editor

Scenario: GJ-Tabelle pruefen

Given I open an editor "gjtab" from table "(Company):(FinancialDates)" with command "VIEW" for record "2"
Then the table has 7 rows
Then field "gjahr" has value "00" in row 1
Then field "gjkenn" has value "aktuell" in row 3
# Januar wurde abgeschlossen
Then field "offmon" has value "2-12" in row 3
Then field "gjahr" has value "06" in row 7

Scenario: Finanzbuchung kopieren und Personenkontenzeile löschen

Given I open an editor "fibucopy" from table "(Entry):(Entry)" with command "COPY" for record "fbzrgschl"
# ursprüngliches budat nicht bebuchbar -> Tagesdatum wird eingesetzt
Then field "budat" has value "07.02.02"
# Urspruenglich war das Feld budat bei nicht bebuchbarem Buchungsdatum der Vorlage leer.
# Wird in diesem Zustand eine Personenkontenzeile geloescht fliegt eine Diag (-1111) => Dieser Fall wird hier getestet
Then field "konto" has value "K 001" in row 1
And I delete row at position 1
And I close the current editor

#TODO wird über edp getestet, bis ein entsprechender Cucumber Step zur Verfügung steht

# Scenario: Finanzbuchung mit nicht bebuchbarem Buchungsdatum kopieren bei nicht bebuchbarem Tagesdatum in der Zukunft (ausserhalb Termindatensatz)
# 
# Given I set the fake date to "01.06.2007"
# 
# Given I open an editor "fibucopyz" from table "(Entry):(Entry)" with command "COPY" for record "fbzrgschl"
# Then field "budat" has value "01.06.07"
# Then field "konto" has value "K 001" in row 1
# And I delete row at position 1
# And I close the current editor
# 
# Scenario: Finanzbuchung mit nicht bebuchbarem Buchungsdatum kopieren bei nicht bebuchbarem Tagesdatum in der Zukunft (innerhalb Termindatensatz)
# 
# Given I set the fake date to "01.06.2005"
# 
# Given I open an editor "fibucopyz" from table "(Entry):(Entry)" with command "COPY" for record "fbzrgschl"
# Then field "budat" has value "01.06.05"
# Then field "konto" has value "K 001" in row 1
# And I delete row at position 1
# And I close the current editor

# Scenario: Finanzbuchung mit nicht bebuchbarem Buchungsdatum kopieren bei nicht bebuchbarem Tagesdatum in der Vergangenheit (ausserhalb Termindatensatz)

# Given I set the fake date to "09.01.1995"


# Then opening an editor from table "(Entry):(Entry)" with command "COPY" for record "fbzrgschl" throws the exception "3650"
# Then field "budat" has value "09.01.95"
# Then field "konto" has value "K 001" in row 1
# And I delete row at position 1
# And I close the current editor


# Scenario: Finanzbuchung mit nicht bebuchbarem Buchungsdatum kopieren bei nicht bebuchbarem Tagesdatum in der Vergangenheit (innerhalb Termindatensatz)
# 
# Given I set the fake date to "31.12.2000"
# 
# Then opening an editor from table "(Entry):(Entry)" with command "COPY" for record "fbzrgschl" throws the exception "3650"
# Then field "budat" has value "31.12.00"
# Then field "konto" has value "K 001" in row 1
# And I delete row at position 1
# And I close the current editor
