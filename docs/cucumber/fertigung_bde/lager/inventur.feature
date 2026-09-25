@persistent
Feature: inventur.feature

Background:
And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name           : inventur.feature
#  Autor          : lschneider
#  Verantwortlich : drpf
#  Kontrolle      : carue
#  Funktion       : Testet Erweiterungen in der Inventur
#                   Es dürfen keine negativen Mengen in einer Zählliste angegeben
#                   werden bzw. darf die addierte Menge nicht kleiner Null werden
#  Jira-Issue     : FDA-722
# *****************************************************************************

Scenario: 01 In nbest können keine negativen Mengen erfasst werden
# Bestand über Rechnung mit Lagerbewegung buchen
Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief		| KETTLER		|
    | vom		| .				|
    | budat		| .			    |
    | ebeleg	| Inventur01	|
    | ueb		| ja			|
    | fakt		| ja			|
And I append rows
| artikel		| mge	| verw		| platz	|
| EINKAUF-1		| 5		| Inventur1	| F3	|
| EINKAUF-1		| 5		| Inventur2	| F3	|
| EINKAUF-1		| 5		| Inventur3	| F3	|
| EINKAUF-1		| 5		| Inventur4	| F3	|
| EINKAUF-1		| 5		| Inventur5	| F3	|
| EINKAUF-1		| 10	|			| F3	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Zählliste" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set fields
    | such	| NBEST01	|
And I append rows
    | artikel	| platz	|
    | EINKAUF-1	| F3	|
Then the table has 6 rows
And I save the current editor

# Inventureröffnung
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "NBEST01" and menu choice "Ja"
And I save the current editor

# nbest kann nicht negativ gesetzt werden
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "NBEST01"
Then setting field "nbest" to "-2" in row 1 throws the exception "8172"
Then setting field "nbest" to "-2" in row !lastRow throws the exception "8172"
And I close the current editor

# Zählliste löschen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "DELETE" for record "NBEST01"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

# Mengen zurückliefern
Given I switch the current editor to editor "RechnungLager" with command "REVERSAL"
And I save the current editor



Scenario: 02 In addmge sind negative Angaben, bis maximal dem Wert der in nbest steht, erlaubt, nbest darf nicht kleiner 0 werden
# Bestand über Rechnung mit Lagerbewegung buchen
Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief		| KETTLER		|
    | vom		| .				|
    | budat		| .				|
    | ebeleg	| Inventur02	|
    | ueb		| ja			|
    | fakt		| ja			|
And I append rows
| artikel	| mge	| verw		| platz	|
| EINKAUF-2	| 5		| Inventur1	| F3	|
| EINKAUF-2	| 5		| Inventur2	| F3	|
| EINKAUF-2	| 5		| Inventur3	| F3	|
| EINKAUF-2	| 5		| Inventur4	| F3	|
| EINKAUF-2	| 5		| Inventur5	| F3	|
| EINKAUF-2	| 10	|			| F3	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Zählliste" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set fields
    | such	| ADDMGE02	|
And I append rows
    | artikel	| platz	|
    | EINKAUF-2	| F3	|
Then the table has 6 rows
And I save the current editor

# Inventureröffnung
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ADDMGE02" and menu choice "Ja"
And I save the current editor

# nbest kann nicht negativ gesetzt werden
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ADDMGE02"
And I set field "addmge" to "3" in row 1
And I set field "addmge" to "3" in row !lastRow
And I save the current editor

And I switch the current editor to editor "Invbearb" with command "UPDATE"
And I set field "addmge" to "-1" in row 1
And I set field "addmge" to "-1" in row !lastRow
And I save the current editor

And I switch the current editor to editor "Invbearb" with command "UPDATE"
Then setting field "addmge" to "-3" in row 1 throws the exception "179"
Then setting field "addmge" to "-3" in row !lastRow throws the exception "179"
And I save the current editor

# Zählliste löschen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "DELETE" for record "ADDMGE02"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

# Mengen stornieren
Given I switch the current editor to editor "RechnungLager" with command "REVERSAL"
And I save the current editor


Scenario: 03 Ein Setartikel kann keiner Zählliste hinzugefügt werden
# Zählliste erstellen
Given I open an editor "Zählliste" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set fields
    | such	| ADDMGE03	|
And I create a new row at the end of the table
Then setting field "artikel" to "SET-ARTIKEL" in row 1 throws the exception "10680"
And I close the current editor
