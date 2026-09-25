# ***************************************************************************
#
#  Name      : plan_zeit.feature
#  Datum     : 15.01.2026
#  Autor     : foe
#  Verantwortlich : teampss
#
#  Funktion  : Cucumber Skript zum Testen von Zeitrastern und Planungszeitraeumen
#
# ***************************************************************************
@persistent
Feature: Test von Zeitrastern und Planungszeitraeumen
Background:
Given I set the fake date to "02.01.1995"

# ----------------------------------------------------------------------------
Scenario: Schreibschutz- und Feldpruefungen
# ----------------------------------------------------------------------------

# Wochenraster
Given I open an editor "zrwoche" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set field "such" to "ZRWOCHE"
# Initialwert TAG fuer Zeiteinheit
Then field "zeiteinheit" has value "Tag"
And I set field "zefaktor" to "7"
# Faktor darf nicht 0 sein
Then setting field "zefaktor" to "0" throws the exception "2046"
# Zeiteineinheit muss gefuellt sein
Then setting field "zeiteinheit" to "" throws the exception "8231"
# Keine Tabelle ausser bei freiem Raster
Then creating a new row at position 1 throws the exception "7778"
# Einheit/faktor aendern
And I set field "zeiteinheit" to "Woche"
And I set field "zefaktor" to "1"
And I save the current editor

# Monatsraster
Given I open an editor "zrmonat" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set field "such" to "ZRMONAT"
And I set field "zeiteinheit" to "Monat"
And I set field "zefaktor" to "1"
And I save the current editor

# Freies Raster
Given I open an editor "ZRFREI" from table "(PlanningTimePeriod):(PeriodPattern)" with command "COPY" for record "ZRWOCHE"
And I set field "such" to "ZRFREI"
And I set field "zeiteinheit" to "Frei"
Then field "zefaktor" is not modifiable
Then field "zefaktor" has value "1"
And I create a new row at the end of the table
And I set field "vondat" to "1.1.2026" in row 1
# Bis_datum mus groesser als von-Datum sein
Then setting field "bisdat" to "31.12.2025" in row 1 throws the exception "7594"
And I set field "bisdat" to "1.2.2026" in row 1
And I create a new row at the end of the table
And I set field "vondat" to "1.2.2026" in row 2
# Bis-Datum wird angespasst
Then field "bisdat" has value "31.01.2026" in row 1
And I set field "bisdat" to "28.2.2026" in row 2
And I set field "bisdat" to "09.02.2026" in row 1
# Von-Datum wird angepasst
Then field "vondat" has value "10.02.2026" in row 2
And I save the current editor

# Gespeichertes Zeitraster
Given I open an editor "ZRWOCHE" from table "(PlanningTimePeriod):(PeriodPattern)" with command "UPDATE" for record "ZRWOCHE"
# Nummer automatisch vergeben
Then field "nummer" has value "1"
# Nummer nicht mehr aenderbar
Then field "nummer" is not modifiable
And I close the current editor

# Wochenraster in Planungseinheit eintragen
Given I open an editor "ZP20WOCHEN" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set field "such" to "ZP20WOCHEN"
And I set field "zraster" to "ZRWOCHE"
And I set field "dauer" to "20"
And I set field "vorgdat" to "1.1.2026"
And I save the current editor

# Planungseinheit pruefen
Given I open an editor "ZP20WOCHEN" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "UPDATE" for record "ZP20WOCHEN"
# Zeitabschnitte wurdeb´ün berechnet
Then field "anfdat" has value "01.01.2026"
Then field "enddat" has value "20.05.2026"
Then the table has 20 rows
# Vorgabedatum aendern
And I set field "vorgdat" to "5.5.2026"
# Abhaengige Felder sind geleert
Then field "anfdat" has value ""
Then field "enddat" has value ""
Then the table has 0 rows
And I close the current editor

# Verwendetes Zeitraster
Given I open an editor "ZRWOCHE" from table "(PlanningTimePeriod):(PeriodPattern)" with command "UPDATE" for record "ZRWOCHE"
# Nummer nicht mehr aenderbar
Then field "nummer" is not modifiable
# Zeitenheit nicht mehr aenderbar
Then field "zeiteinheit" is not modifiable
And I save the current editor

# Zeitraster kopieren
Given I open an editor "ZRMONAT2" from table "(PlanningTimePeriod):(PeriodPattern)" with command "COPY" for record "ZRMONAT"
Then field "zeiteinheit" is modifiable
Then field "zefaktor" is modifiable
And I set field "zeiteinheit" to "Frei"
# Faktor bei freiem Zeitraster nicht aenderbar
Then field "zefaktor" is not modifiable
And I close the current editor

Given I open an editor "ZRFREIUP" from table "(PlanningTimePeriod):(PeriodPattern)" with command "UPDATE" for record "ZRFREI"
And I set field "zeiteinheit" to "Quartal"
# Tabelle wird geleert
Then the table has 0 rows
And I close the current editor

# Plnaungszeitraum kopieren und alles aendern
Given I open an editor "ZP12MONATE" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "COPY" for record "ZP20WOCHEN"
And I set field "such" to "ZP12MONATE"
And I set field "vorgzeit" to "1.1.2027"
And I set field "dauer" to "12"
And I set field "zraster" to "ZRMONAT"
Then field "anfdat" is not modifiable
Then field "enddat" is not modifiable
And I press button "bzrbest"
Then field "anfdat" has value "01.01.2027"
Then field "enddat" has value "31.12.2027"
Then field "anfdat" is not modifiable
Then field "enddat" is not modifiable
# Zeitabschnitte wurden berechnet
Then the table has 12 rows
Then field "vondat" is not modifiable in row 1
Then field "bisdat" is not modifiable in row 1
And I save the current editor

# Planungszeitraum in Planung eintragen
Given I open an editor "Planung2026" from table "(SalesPlanning):(Planning)" with command "NEW" for record ""
And I set fields
 | such        | NPLAN2026         |
 | namebspr    | Planung fuer 2026 |
 | swprefix    | NPL26             |
 | nametext    | Plan fuer 2026    |
 | vtabstufen  | 1                 |
 | vtabzeilen  | 10                |
 | planzraum   | ZP12MONATE        |
And I save the current editor

# Verwendeten Planungszeitraum
Given I open an editor "ZP12MONATE" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "UPDATE" for record "ZP12MONATE"
# Nummer nicht mehr aenderbar
Then field "nummer" is not modifiable
# Felder nicht mehr aenderbar
Then field "vorgdat" is not modifiable
Then field "zraster" is not modifiable
Then field "dauer" is not modifiable
Then field "bzrbest" is not modifiable
And I save the current editor

# ----------------------------------------------------------------------------
Scenario: Pruefungen beim Speichern
# ----------------------------------------------------------------------------
# Zeitraster ohne Suchwort nicht erlaubt
Given I open an editor "ZRJAHR" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set field "zeiteinheit" to "Jahr"
# Bezeichnung bitte eintragen
Then saving the current editor throws the exception "10179"
And I set field "such" to "ZRJAHR"
And I save the current editor

# Zeitraster Quartal Pflichtfelder pruefen
Given I open an editor "zrleer" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
# Suchwort bitte eintragen
Then saving the current editor throws the exception "10179"
And I set field "such" to "ZRLEER"
# Faktor bitte eintragen
Then saving the current editor throws the exception "2046"
And I set field "zefaktor" to "10"
# Tag -> Quartal
And I set field "zeiteinheit" to "Quartal"
And I save the current editor

# Planungseinheit Dauer muss gefuellt sein
Given I open an editor "ZPMonat" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set field "such" to "ZPMONAT2"
And I set field "zraster" to "ZRMONAT"
Then saving the current editor throws the exception "10179"
And I set field "dauer" to "20"
And I set field "vorgdat" to "1.1.2026"
And I save the current editor

#  Freies Zeitraster:  Von- und Bis-Datum pruefen
Given I open an editor "ZPFrei2" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set field "such" to "ZPFREI"
And I set field "zeiteinheit" to "Frei"
And I create a new row at the end of the table
And I set field "vondat" to "1.3.2026" in row 1
And I set field "bisdat" to "31.3.2026" in row 1
And I create a new row at the end of the table
And I set field "vondat" to "1.4.2026" in row 2
Then saving the current editor throws the exception "8210"
And I set field "bisdat" to "30.4.2026" in row 2
And I save the current editor

# ----------------------------------------------------------------------------
Scenario: Pruefungen beim Losechen
# ----------------------------------------------------------------------------

# Zeitraster loeschen
Given I open an editor "ZRFREI" from table "(PlanningTimePeriod):(PeriodPattern)" with command "DELETE" for record from editor "ZRFREI"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Then "(PlanningTimePeriod):(PeriodPattern)" with the editor id "ZRFREI" is filed

# Versuch ein verwendetes Zeitraster zu loeschen
Given I open an editor "zrwoche" from table "(PlanningTimePeriod):(PeriodPattern)" with command "DELETE" for record from editor "ZRWOCHE"
And I respond with answer "ja" to the dialog with id "4958"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

# Abgelegtes Zeitraster wiederbelebbar
Given I open an editor "ZRFREI" from table "(PlanningTimePeriod):(PeriodPattern)" with command "UPDATE" for record "+ZRFREI" with dialog "1999" and answer "ja"
And I save the current editor

Then "(PlanningTimePeriod):(PeriodPattern)" with the editor id "ZRFREI" is not filed

# Planungszeitraum loeschen
Given I open an editor "ZP20WOCHEN" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "DELETE" for record from editor "ZP20WOCHEN"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

# Versuch einen verwendeten Planungszeitraum zu loeschen
Given I open an editor "ZP12MONATE" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "DELETE" for record from editor "ZP12MONATE"
And I respond with answer "ja" to the dialog with id "4958"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Then "(PlanningTimePeriod):(PlanningTimePeriod)" with the editor id "ZP12MONATE" is filed

# Abgelegter Planungszeitraum wiederbelebbar
Given I open an editor "ZP12MONATE" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "UPDATE" for record "+ZP12MONATE" with dialog "1999" and answer "ja"
And I save the current editor

Then "(PlanningTimePeriod):(PlanningTimePeriod)" with the editor id "ZP12MONATE" is not filed
