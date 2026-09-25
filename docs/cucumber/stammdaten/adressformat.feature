# ***************************************************************************
#
#  Name      : adressformat.feature
#  Datum     : 23.08.2024
#  Autor     : foe
#  Verantwortlich : foe
#  Kontrolle : as
#
#  Funktion  : Cucumber Skript zum Testen von Adressformaten
#
# ***************************************************************************
@persistent
Feature: Test von Adressformaten
Background:
Given I set the fake date to "02.01.1995"

# ----------------------------------------------------------------------------
Scenario: Schreibschutz- und Feldpruefungen
# ----------------------------------------------------------------------------

Given I open an editor "ADRFORM_TEST" from table "(Regions):(AddressFormats)" with command "NEW" for record ""
Then field "adrtyp" is not modifiable
And I set field "person" to "K 1"
Then field "adrtyp" is modifiable
And I create a new row at the end of the table
Then the table has 1 rows
# Schreibschutz fuer Tabellenfelder
Then field "grossb" is not modifiable in row 1
Then field "beddavor" is not modifiable in row 1
Then field "bedhinter" is not modifiable in row 1
Then field "leerzeich" is not modifiable in row 1
Then field "neuezeile" is not modifiable in row 1
Then field "text" is not modifiable in row 1
Then field "nurausland" is not modifiable in row 1
Then field "ankerzeile" is not modifiable in row 1
Then field "zeilenr" is not modifiable in row 1
Then field "leerzausg" is not modifiable in row 1
Then field "leerzdavor" is not modifiable in row 1
And I set field "adrteil" to "Zusatztext" in row 1
Then field "grossb" is not modifiable in row 1
Then field "beddavor" is not modifiable in row 1
Then field "bedhinter" is not modifiable in row 1
Then field "leerzeich" is modifiable in row 1
Then field "neuezeile" is modifiable in row 1
Then field "text" is modifiable in row 1
Then field "nurausland" is modifiable in row 1
Then field "ankerzeile" is modifiable in row 1
Then field "zeilenr" is modifiable in row 1
Then field "leerzausg" is modifiable in row 1
Then field "leerzdavor" is modifiable in row 1
And I set field "adrteil" to "Name" in row 1
Then field "grossb" is modifiable in row 1
Then field "beddavor" is modifiable in row 1
Then field "bedhinter" is modifiable in row 1

# Adresstyp prufen: 0-2
Then setting field "adrtyp" to "-1" throws the exception "131"
Then setting field "adrtyp" to "3" throws the exception "131"
And I set field "adrtyp" to "1"

# Laengen- und Breitengradeingaben -180 bis 180 und -90 bis 90 pruefen
Then setting field "laengengrad" to "-181" throws the exception "131"
Then setting field "laengengrad" to "180.6" throws the exception "131"
And I set field "laengengrad" to "101.15"
Then setting field "breitengrad" to "-90,5" throws the exception "131"
Then setting field "breitengrad" to "95" throws the exception "131"
And I set field "laengengrad" to "67"

# Leeren und Fuellen des Feld Person wird der Adresstyp angepasst
And I set field "person" to ""
Then field "adrtyp" has value "0"
And I set field "person" to "K 1"
Then field "adrtyp" has value "1"

# Entweder "Leerzeichen" oder "Neue Zeile" ausgewaehlt
And I set field "leerzeich" to "ja" in row 1
Then field "neuezeile" has value "nein" in row 1
And I set field "neuezeile" to "ja" in row 1
Then field "leerzeich" has value "nein" in row 1

# Nur 1 Zeile kann Ankerzeile sein
And I create a new row at the end of the table
And I set field "adrteil" to "Zusatztext" in row 2
And I set field "ankerzeile" to "2" in row 2

And I create a new row at the end of the table
And I set field "adrteil" to "Postleitzahl" in row 3
And I set field "ankerzeile" to "3" in row 3
# Nur 1 Ankerzeile ausweahlbar
Then field "ankerzeile" has value "0" in row 2

# Bei Zusatztext die Felder regrossb, rebeddavor, rebedhinter leeren
And I set field "grossb" to "ja" in row 3
And I set field "beddavor" to " - " in row 3
And I set field "bedhinter" to " - " in row 3
And I set field "adrteil" to "Zusatztext" in row 3
Then field "grossb" has value "nein" in row 3
Then field "beddavor" has value "" in row 3
Then field "bedhinter" has value "" in row 3

# Adressbestandteil leer -> Alle Tabllenfelder leer
And I create a new row at the end of the table
Then field "adrteil" has value "" in row 4
Then field "grossb" has value "nein" in row 4
Then field "beddavor" has value "" in row 4
Then field "bedhinter" has value "" in row 4
Then field "leerzeich" has value "nein" in row 4
Then field "neuezeile" has value "nein" in row 4
Then field "text" has value "" in row 4
Then field "nurausland" has value "nein" in row 4
Then field "ankerzeile" has value "0" in row 4
Then field "zeilenr" has value "0" in row 4
Then field "leerzausg" has value "nein" in row 4
Then field "leerzdavor" has value "0" in row 4

And I set field "such" to "ADRFORM-TEST"
And I set field "rnamebspr" to "adrform_Test"
And I save the current editor

# ----------------------------------------------------------------------------
Scenario: Neues Adressforamt anlegen
# ----------------------------------------------------------------------------
Given I open an editor "ADRFORM_T1" from table "(Regions):(AddressFormats)" with command "NEW" for record ""
And I set field "such" to "ADRFORM-T1"
And I set field "rnamebspr" to "adrform_T1"
And I append rows
| adrteil            | grossb | neuezeile | leerzeich | nurausland | beddavor    | bedhinter    | text          | zeilenr | leerzausg | leerzdavor |
| Name               | nein   | ja        | nein      | nein       | !dontChange | !dontChange  | !dontChange   | 0       | nein      | 0          |
| Strasse            | ja     | ja        | nein      | nein       | !dontChange | !dontChange  | !dontChange   | 0       | nein      | 0          |
| Postleitzahl       | nein   | nein      | ja        | nein       | !dontChange | !dontChange  | !dontChange   | 0       | nein      | 0          |
| Regionenkennzeichen| nein   | nein      | ja        | nein       | !dontChange | -            | !dontChange   | 0       | nein      | 0          |
| Ort                | nein   | nein      | ja        | nein       | !dontChange | !dontChange  | !dontChange   | 0       | nein      | 0          |
| Regionenname       | ja     | ja        | nein      | nein       | !dontChange | !dontChange  | !dontChange   | 0       | nein      | 0          |
| Landeskennzeichen  | nein   | nein      | nein      | ja         | !dontChange | !dontChange  | !dontChange   | 0       | nein      | 0          |
And I save the current editor

# ----------------------------------------------------------------------------
Scenario: Adressformat loeschen
# ----------------------------------------------------------------------------
Given I open an editor "ADRFORM_DEL" from table "(Regions):(AddressFormats)" with command "DELETE" for record from editor "ADRFORM_TEST"
# Wirklich loeschen?
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

# ----------------------------------------------------------------------------
Scenario: Adressformat ADRFORM-AF kann nicht geloescht werden, da es verwendet wird
# ----------------------------------------------------------------------------
Then opening an editor from table "(Regions):(AddressFormats)" with command "DELETE" for record "1" throws the exception "1622"

# ----------------------------------------------------------------------------
Scenario: Pruefungen beim Speichern
# ----------------------------------------------------------------------------
Given I open an editor "ADRFORM-MIN" from table "(Regions):(AddressFormats)" with command "NEW" for record ""
# Bitte Suchwort eintragen
Then saving the current editor throws the exception "10179"
And I set field "such" to "ADRFORM_MIN"
And I save the current editor
