@persistent
Feature: schedconf.feature

# **********************************************************************************
#  Name             : schedconf.feature
#  Autor            : bschiga
#  Verantwortlich   : teaminfosysteme
#  Kontrolle        : bheim
#  Funktion         : Testet Infosystem SCHEDCONF Vererbung dispositiver Stammdaten
#
# **********************************************************************************

Background:
Given I set the fake date to "02.01.1995"

# es duerfen keine Zeilen angefügt, verschoben oder geloescht werden
# Felder die im Objekt schreibgeschuetzt sind, muessen auch im Infosystem schreibgeschuetzt sein
# Auswahl kann nach Datenbankgruppe eingeschraenkt werden
# Feld im Infosystem anhaken und speichern, muss dann auch im Objekt angehakt sein

Scenario: 01 Es duerfen keine Zeilen geloescht, angefuegt oder verschoben werden

Given I open the infosystem "SCHEDCONF"
And I press start
# 295 de      |Es dürfen keine Zeilen gelöscht werden
Then deleting the row at position 1 throws the exception "295"
# 294 de      |Es dürfen keine Zeilen ein- oder angefügt werden
Then creating a new row at position !lastRow throws the exception "294"
#9871 de      |Es dürfen keine Zeilen verschoben werden
Then moving rows "1" to position "5" throws the exception "9871"
And I close the current editor


Scenario: 02 Schreibschutz der gleichen Felder wie im Objekt Konfiguration der Stammdatenvererbung

Given I open an editor "FIELDCONFIG1" from table "(SchedulingConfiguration):(FieldConfigInheritance)" with command "UPDATE" for record "MVERLUST"
Then field "nichtfixvorg" is modifiable
Then field "fixvorg" is not modifiable
Then field "infl" is not modifiable
And I close the current editor

Given I open the infosystem "SCHEDCONF"
And I press start
Then field "tsuch^id" has value "!FIELDCONFIG1^id" in row 1
Then field "tnichtfixvorg" is modifiable in row 1
Then field "tfixvorg" is not modifiable in row 1
Then field "tinfl" is not modifiable in row 1
And I close the current editor

Given I open an editor "FIELDCONFIG7" from table "(SchedulingConfiguration):(FieldConfigInheritance)" with command "UPDATE" for record "RUNDUNG"
Then field "nichtfixvorg" is modifiable
Then field "fixvorg" is not modifiable
Then field "infl" is not modifiable
And I close the current editor

Given I open the infosystem "SCHEDCONF"
And I press start
Then field "tsuch^id" has value "!FIELDCONFIG7^id" in row 6
Then field "tnichtfixvorg" is modifiable in row 7
Then field "tfixvorg" is not modifiable in row 7
Then field "tinfl" is not modifiable in row 7
And I close the current editor


Scenario: 03 Auswahl kann nach Datenbankgruppe eingeschraenkt werden

Given I open the infosystem "SCHEDCONF"
Then field "dbgruppe" is empty
And I press start
Then the table has 77 rows
And I set field "dbgruppe" to "V-128-01"
And I press start
Then the table has 25 rows
Then field "tfelddatenbank" has value "Fertigungsliste" in all rows
Then field "tgruppename" has value "Fertigungsliste" in all rows
And I set field "dbgruppe" to "V-39-03"
And I press start
Then the table has 16 rows
Then field "tfelddatenbank" has value "Lager" in all rows
Then field "tgruppename" has value "Lagergruppeneigenschaft" in all rows
And I set field "dbgruppe" to "V-02-01"
And I press start
Then the table has 23 rows
Then field "tfelddatenbank" has value "Teil" in all rows
Then field "tgruppename" has value "Artikel" in all rows
And I set field "dbgruppe" to "V-07-00"
And I press start
Then the table has 13 rows
Then field "tfelddatenbank" has value "Arbeitsgang" in all rows
Then field "tgruppename" has value "Arbeitsgang" in all rows
And I close the current editor


Scenario: 04 Aenderungen werden in das jeweilige Objekt zurueckgeschrieben

Given I open the infosystem "SCHEDCONF"
And I press start
And I modify table
    | !row               | taktiv       | tnichtfixvorg | tfixvorg      | tinfl         |
    | tsuch=='MVERLUST'  | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='DISPOA'    | ja           | ja            | ja            | !dontChange   |
    | tsuch=='ABPLATZ'   | ja           | ja            | ja            | !dontChange   |
    | tsuch=='FLISTESTD' | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='FVERLUST'  | ja           | !dontChange   | !dontChange   | ja            |
# Feld tauswahl wurde auf "ja" gesetzt bei den Zeilen, die geaendert wurden
#Then table has values
#    | !row                                      | tsuch        | tauswahl     |
#    | $,,tsuch==MVERLUST                        | MVERLUST     | ja           |
#    | $,,tsuch==DISPOA;tfeldgruppe==V-02-01     | DISPOA       | ja           |
#    | $,,tsuch==ABPLATZ                         | ABPLATZ      | ja           |
#    | $,,tsuch==FLISTESTD                       | FLISTESTD    | ja           |
#    | $,,tsuch==FVERLUST                        | FVERLUST     | ja           |
And I press button "update"
And I close the current editor

Scenario Outline: Objekte pruefen
Given I open an editor "FIELDCONFIG" from table "(SchedulingConfiguration):(FieldConfigInheritance)" with command "VIEW" for record "<such>"
Then fields have values
    | aktiv         | <aktiv>         |
    | nichtfixvorg  | <nichtfixvorg>  |
    | fixvorg       | <fixvorg>       |
    | infl          | <infl>          |
And I close the current editor

Examples:
    | such      | aktiv     | nichtfixvorg    | fixvorg   | infl      |
    | MVERLUST  | ja        | ja              | nein      | nein      |
    | DISPOA    | ja        | ja              | ja        | nein      |
    | ABPLATZ   | ja        | ja              | ja        | nein      |
    | FLISTESTD | ja        | ja              | nein      | nein      |
    | FVERLUST  | ja        | nein            | nein      | ja        |
