@persistent
Feature: Verpackungsplanung - mehrere Artikel bei mehrstufiger Verpackung
Background:
Given I set the fake date to "02.01.1995"


Scenario: STAMMDATEN - Neuen Kunden anlegen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Bayram"
And I set fields
   | such     | Bayram                       |
   | namebspr | Bayram Werkzeugbau, Rastatt  |
   | ans      | Bayram Werkzeugbau GmbH      |
   | str      | Riedstr. 24-28               |
   | plz      | 76437                        |
   | nort     | Rastatt                      |
   | zbed     | 201                          |
   | betreuer | .                            |
   | ustid    | DE56454651                   |
   | lbed     | EXW                          |
And I save the current editor

Scenario Outline: STAMMDATEN - Zwei neue Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "bsart" to "<bsart>"
And I set field "dispoa" to "<dispoa>"
And I set field "gewicht" to "<gewicht>"
And I save the current editor

Examples: Artikel
| such     | namebspr  | vkbez     | vbez      | ebez      | vpr   | bsart            | dispoa         | gewicht |
| artikel1 | Artikel 1 | Artikel 1 | Artikel 1 | Artikel 1 | 10000 | Fremdbeschaffung | bedarfsbezogen | 1       |
| artikel2 | Artikel 2 | Artikel 2 | Artikel 2 | Artikel 2 | 9000  | Fremdbeschaffung | bedarfsbezogen | 0,25    |
| artikel3 | Artikel 3 | Artikel 3 | Artikel 3 | Artikel 3 | 8500  | Fremdbeschaffung | bedarfsbezogen | 0,5     |
| artikel4 | Artikel 4 | Artikel 4 | Artikel 4 | Artikel 4 | 7000  | Fremdbeschaffung | bedarfsbezogen | 2       |

Scenario: STAMMDATEN - Packmittel anlegen
Given I open an editor "packmittel" from table "(Part):(Product)" with command "STORE" for record "grbehaelter"
And I set field "such" to "grbehaelter"
And I set field "namebspr" to "Großer Behaelter"
And I set field "packmit" to "ja"
And I set field "pmtyp" to "Behaelter"
And I set field "gewicht" to "0,5"
And I save the current editor

Scenario: Lieferschein anlegen - Verpackungsplanung aufrufen
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "100" in row 1
And I set field "fmenge" to "100" in row 1
And I press button "pmneu" in row 1
And I create a new row at the end of the table
And I set field "artex" to "behaelter" in row 2
And I set field "mge" to "1" in row 2
And I press button "pmneu" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 3
And I set field "mge" to "100" in row 3
And I set field "fmenge" to "100" in row 3
And I press button "pmneu" in row 3
And I create a new row at the end of the table
And I set field "artex" to "behaelter" in row 4
And I set field "mge" to "1" in row 4
And I press button "pmneu" in row 3
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 5
And I set field "mge" to "120" in row 5
And I set field "fmenge" to "120" in row 5
And I press button "pmneu" in row 5
And I create a new row at the end of the table
And I set field "artex" to "behaelter" in row 6
And I set field "mge" to "1" in row 6
And I press button "pmneu" in row 5
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 7
And I set field "mge" to "120" in row 7
And I set field "fmenge" to "120" in row 7
And I press button "pmneu" in row 7
And I create a new row at the end of the table
And I set field "artex" to "behaelter" in row 8
And I set field "mge" to "1" in row 8
And I press button "pmneu" in row 7
And I press button "verpplanbearb" to open a subeditor for "verpacken"
And I create a new row at the end of the table
And I set field "packmittel" to "grbehaelter" in row 5
And I set field "istmaster" to "ja" in row 5
And I set field "zuteilen" to "ja" in row 1
And I set field "zuteilen" to "ja" in row 2
And I press button "verpacken"
And I create a new row at the end of the table
And I set field "packmittel" to "grbehaelter" in row 6
And I set field "istmaster" to "ja" in row 6
And I set field "zuteilen" to "ja" in row 3
And I set field "zuteilen" to "ja" in row 4
And I press button "verpacken"
And I save the current editor
And I switch the current editor to editor "lieferschein"
And I press button "verpplanbearb" to open a subeditor for "verpacken"
And I create a new row at the end of the table
And I set field "packmittel" to "palette2" in row 7
And I set field "istmaster" to "ja" in row 7
# TODO: Zuteilen ist noch nicht moeglich
Then field "zuteilen" is not modifiable in row 3
Then field "zuteilen" is not modifiable in row 6
And I close the current editor
And I switch the current editor to editor "lieferschein"
And I save the current editor

Scenario: Lieferschein mit 2 Artikel anlegen - Verpackungsplanung aufrufen

Given I open an editor "lieferschein2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "120" in row 1
And I set field "fmenge" to "10" in row 1
And I press button "pmneu" in row 1
And I create a new row at the end of the table
And I set field "artex" to "behaelter" in row 2
And I set field "mge" to "12" in row 2
And I press button "pmneu" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 3
And I set field "mge" to "240" in row 3
And I set field "fmenge" to "10" in row 3
And I press button "pmneu" in row 3
And I create a new row at the end of the table
And I set field "artex" to "behaelter" in row 4
And I set field "mge" to "24" in row 4
And I press button "pmneu" in row 3
And I press button "verpplanbearb" to open a subeditor for "verpacken"
And I create a new row at the end of the table
And I set field "packmittel" to "grbehaelter" in row 3
And I set field "istmaster" to "ja" in row 3
And I set field "zuteilen" to "ja" in row 1
And I set field "zuteilen" to "ja" in row 2
And I press button "verpacken"
And I save the current editor
And I switch the current editor to editor "lieferschein2"
And I press button "verpplanbearb" to open a subeditor for "verpacken"
And I create a new row at the end of the table
And I set field "packmittel" to "palette2" in row 4
And I set field "istmaster" to "ja" in row 4
# TODO: Zuteilen ist noch nicht moeglich
Then field "zuteilen" is not modifiable in row 3
And I close the current editor
And I switch the current editor to editor "lieferschein2"
And I save the current editor

Scenario: Lieferschein mit 4 Artikel anlegen - Verpackungsplanung aufrufen

Given I open an editor "lieferschein3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "20" in row 1
And I set field "fmenge" to "10" in row 1
And I press button "pmneu" in row 1
And I create a new row at the end of the table
And I set field "artex" to "behaelter" in row 2
And I set field "mge" to "2" in row 2
And I press button "pmneu" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 3
And I set field "mge" to "30" in row 3
And I set field "fmenge" to "10" in row 3
And I press button "pmneu" in row 3
And I create a new row at the end of the table
And I set field "artex" to "behaelter" in row 4
And I set field "mge" to "3" in row 4
And I press button "pmneu" in row 3
And I press button "verpplanbearb" to open a subeditor for "verpacken"
And I create a new row at the end of the table
And I set field "packmittel" to "grbehaelter" in row 3
And I set field "istmaster" to "ja" in row 3
And I set field "zuteilen" to "ja" in row 1
And I set field "zuteilen" to "ja" in row 2
And I press button "verpacken"
And I save the current editor
And I switch the current editor to editor "lieferschein3"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel3" in row 6
And I set field "mge" to "40" in row 6
And I set field "fmenge" to "10" in row 6
And I press button "pmneu" in row 6
And I create a new row at the end of the table
And I set field "artex" to "behaelter" in row 7
And I set field "mge" to "4" in row 7
And I press button "pmneu" in row 6
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel4" in row 8
And I set field "mge" to "20" in row 8
And I set field "fmenge" to "10" in row 8
And I press button "pmneu" in row 8
And I create a new row at the end of the table
And I set field "artex" to "behaelter" in row 9
And I set field "mge" to "2" in row 9
And I press button "pmneu" in row 8
And I press button "verpplanbearb" to open a subeditor for "verpacken"
And I create a new row at the end of the table
And I set field "packmittel" to "grbehaelter" in row 6
And I set field "istmaster" to "ja" in row 6
And I set field "zuteilen" to "ja" in row 4
And I set field "zuteilen" to "ja" in row 5
And I press button "verpacken"
And I save the current editor
And I switch the current editor to editor "lieferschein3"
And I press button "verpplanbearb" to open a subeditor for "verpacken"
And I create a new row at the end of the table
And I set field "packmittel" to "palette2" in row 7
And I set field "istmaster" to "ja" in row 7
# TODO: Zuteilen ist noch nicht moeglich
Then field "zuteilen" is not modifiable in row 3
Then field "zuteilen" is not modifiable in row 6
And I close the current editor
And I switch the current editor to editor "lieferschein3"
And I save the current editor

Scenario: Lieferschein mit gemeinsamen Packmitteln zurueckliefern

Given I open an editor "VPP_T1" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VPP_T1"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "VPP_T1_R" from table "(Sales):(PackingSlip)" with command "RETURN" for record "VPP_T1"
And I set field "such" to "VPP_T1_R"
And I delete row at position 20
And I delete row at position 19
And I delete row at position 18
And I delete row at position 17
And I delete row at position 16
And I delete row at position 14
And I delete row at position 12
And I delete row at position 11
And I delete row at position 10
And I delete row at position 9
And I delete row at position 7
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I delete row at position 2
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-1" in row 2
And I set field "mge" to "-5" in row 3
And I set field "mge" to "-1" in row 4
And I set field "mge" to "-5" in row 5
And I set field "mge" to "-1" in row 6
# Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor

Given I open an editor "VPP_T1_R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VPP_T1_R"
And I set field "mge" to "-10" in row 1
And I set field "mge" to "-10" in row 3
And I set field "mge" to "-10" in row 5
# Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor

Given I open an editor "VPP_T1_R" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VPP_T1_R"
And I set field "ueb" to "ja"
# Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor


Scenario: Lieferschein mit zwei Paletten als Packmittel

# Zwei Paletten als Packmittel mit unterschiedlichen Preisen anlegen
Given I open an editor "palette1" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "such" to "palettep1"
And I set field "namebspr" to "Palette P1"
And I set field "packmit" to "ja"
And I set field "pmtyp" to "Palette"
And I set field "gewicht" to "20"
And I set field "vpr" to "10.50"
And I save the current editor

Given I open an editor "palette2" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "such" to "palettep2"
And I set field "namebspr" to "Palette P2"
And I set field "packmit" to "ja"
And I set field "pmtyp" to "Palette"
And I set field "gewicht" to "20"
And I set field "vpr" to "17.60"
And I save the current editor

# Neuer Lieferschein anlegen mit Artikel V2 und Menge 11
Given I open an editor "lieferschein_palette" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "300099"
And I set field "waehr" to "DEM"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 1
And I set field "mge" to "11" in row 1
And I set field "fmenge" to "1" in row 1
# Button pmneu in Zeile 1 druecken => es wird eine neue Zeile angelegt
And I press button "pmneu" in row 1
And I create a new row at the end of the table
# Behaelter mit Menge 1 und Fuellmenge 1 eintragen
And I set field "artex" to "behaelter" in row 2
And I set field "mge" to "1" in row 2
And I set field "fmenge" to "1" in row 2
# Neue Zeile anlegen mit Behaelter mit Menge 10 und Fuellmenge 1
# And I press button "pmneu" in row 1
And I create a new row at the end of the table
And I set field "artex" to "behaelter" in row 3
And I set field "mge" to "10" in row 3
And I set field "fmenge" to "1" in row 3
# Button verpplanbearb im Lieferschein druecken => Verpackungsplanung oeffnet sich
And I press button "verpplanbearb" to open a subeditor for "verpacken"
# Neue Zeile anlegen mit Palette 1 und Menge und Fuellmenge 1
And I create a new row at the end of the table
And I set field "packmittel" to "palettep1" in row 3
Then field "mge" has value "1" in row 3
And I set field "maxfmenge" to "1" in row 3
# Neue Zeile anlegen mit Palette 2 und Menge 1 und Fuellmenge 10
And I create a new row at the end of the table
And I set field "packmittel" to "palettep2" in row 4
Then field "mge" has value "1" in row 4
And I set field "maxfmenge" to "10" in row 4
# In der Zeile mit Palette 1 den Kenner istmaster und in Zeile 1 den Kenner zuteilen aktivieren und Button verpacken druecken
And I set field "istmaster" to "ja" in row 3
And I set field "zuteilen" to "ja" in row 1
And I press button "verpacken"
# In der Zeile mit Palette 2 den Kenner istmaster und in Zeile 2 den Kenner zuteilen aktivieren und Button verpacken druecken
And I set field "istmaster" to "ja" in row 4
And I set field "zuteilen" to "ja" in row 2
And I press button "verpacken"
# Verpackungsplanung speichern
And I save the current editor
And I switch the current editor to editor "lieferschein_palette"
# Preise der beiden Paletten pruefen
Then field "preis" has value "10.50" in row 4
Then field "preis" has value "17.60" in row 5
# Lieferschein speichern
And I close the current editor
