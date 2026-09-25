#***************************************************************************
#
#  Name      : packstuecknr.feature
#  Datum     : 15.07.2010
#  Vers.     : 2.0
#  Autor     : amk
#  Verantwortlich : foe
#  Kontrolle : dago
#
#
#  Funktion  : Skript zum Referenztest ref_packstuecknr. Dient im
#              Wesentlichen zur Anlage und Manipulation von Packstuecknummern
#              im Lieferschein.
#
#              Aehnlich wie bei std/test/PLAUSI ist ein EFOP (PACKSTNRPLAUSI.FOP)
#              an den Button <yprintref> gehaengt, um zur Laufzeit
#              dieses Skripts Werte ausgeben zu koennen.
#
#***************************************************************************
#
@persistent
Feature: packstuecknr.feature
Background:
Given I enable the flag 39
#
# ------------------------------------------------------
Scenario: EDI und Automotive einschalten
# ------------------------------------------------------
# Given I open an editor "" from table "(Company):(NOT FOUND)" with command "UPDATE" for record "Konf"
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
	| edi        | j  |
	| automotive | j  |
And I save the current editor
#
# ------------------------------------------------------
Scenario: Warenanhaengerlayout eintragen
# ------------------------------------------------------
Given I open an editor "Packanweisung" from table "(PackingInstructions):(PackingInstructions)" with command "UPDATE" for record "KARTON4711"
And I set field "walayout" to "ISVDA4902K" in row 1
And I set field "walayout" to "ISVDA4902G" in row 4
And I save the current editor
#
# ------------------------------------------------------
Scenario: Test1: Lieferschein anlegen
# Packstuecknummern eintragen, aber mit Abbruch beenden
# ------------------------------------------------------
Given I open an editor "VerkaufLieferschein-1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
	| nummer | 123L  |
	| kunde  | 1     |
	| such   | LS123 |
And I append rows
	| pnum | artikel | mge | packanw    | fmenge |
	| 1    | V1      | 75  | KARTON4711 | 10     |
# Packmittel berechnen
And I press button "packvor"
Then the table has 7 rows
# Packstuecknummern eintragen
And I press button "pastnrgen" to open a subeditor for "Packstnr0"
And I close the current subeditor to switch back to the parent editor
# 8186: Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
# Lieferschein speichern, ohne dass die Packstuecknummern angelegt werden
And I respond with answer "nein" to the dialog with id "8186"
And I save the current editor
#
# ------------------------------------------------------
Scenario: Packstuecknummern zeigen
# ------------------------------------------------------
# Fehler erwartet: Ungueltige Objektangabe, da Objekt noch nicht vorhanden
Then opening an editor from table "(ShippingPlanning):(PackageNumbers)" with command "VIEW" for record "123L" throws the exception "1582"
#
# ------------------------------------------------------
Scenario: Lieferschein aendern und Packstuecknummern eintragen
# ------------------------------------------------------
Given I open an editor "LS123L1" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS123"
# Packstuecknummern eintragen
And I press button "pastnrgen" to open a subeditor for "Packstnr"
And I set field "name" to "Test 1/1: Objekt anlegen, kein Hinweis, noNr!"
And I press button "yprintref"
And I set field "name" to "Test 1/2: Objekt anlegen, kein Hinweis, Nr!"
And I press button "genpmnum"
And I press button "yprintref"
Then the table has 9 rows
# Individuelles Feld fuellen
And I modify table
    | !row | yinfo |
    | 1    | INFO1 |
    | 2    | INFO2 |
    | 3    | INFO3 |
    | 4    | INFO4 |
    | 5    | INFO5 |
    | 6    | INFO6 |
    | 7    | INFO7 |
    | 8    | INFO8 |
    | 9    | INFO9 |
And I save the current editor
And I switch the current editor to editor "LS123L1"
And I save the current editor
#
# ------------------------------------------------------
Scenario: Packstuecknummern zeigen
# ------------------------------------------------------
Given I open an editor "Packnum1" from table "(ShippingPlanning):(PackageNumbers)" with command "VIEW" for record "123L"
Then field "nummer" has value "123L"
And I press button "yprintref"
And I save the current editor
#
# ------------------------------------------------------
Scenario: Test2: Lieferschein aendern und Layout der Palette entfernen
# ------------------------------------------------------
Given I open an editor "LS123L2" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS123"
And I set field "walayout" to " " in row 6
# 8186: Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor
#
Given I open an editor "Packnum2" from table "(ShippingPlanning):(PackageNumbers)" with command "UPDATE" for record "123L"
And I set field "name" to "Test 2: Layout geloescht, autom. aktualisert!"
And I press button "yprintref"
And I close the current editor
#
# ------------------------------------------------------
Scenario: Test3: Packstuecknummern aktualisieren
# ------------------------------------------------------
Given I open an editor "LS123L3" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS123"
# Packstuecknummern eintragen
And I press button "pastnrgen" to open a subeditor for "packstnr2"
And I set field "name" to "Test 3: Autom. aktualisert, kein Hinweis!"
And I press button "yprintref"
And I save the current editor
And I switch the current editor to editor "LS123L3"
And I save the current editor
#
Given I open an editor "Packnum3" from table "(ShippingPlanning):(PackageNumbers)" with command "UPDATE" for record "123L"
And I set field "name" to "Test 3: Objekt aktualisiert, kein Hinweis!"
And I press button "yprintref"
And I close the current editor
#
# ------------------------------------------------------
Scenario: Test4: Lieferschein aendern und Layout der Palette wieder eintragen
# ------------------------------------------------------
Given I open an editor "LS123L4" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS123"
And I set field "walayout" to "ISVDA4902G" in row 6
# 8186: Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok? ?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor
#
Given I open an editor "Packnum4" from table "(ShippingPlanning):(PackageNumbers)" with command "UPDATE" for record "123L"
# Test 4: Layout wieder eingetragen, kein Hinweis!
And I set field "name" to "Test 4: Layout wieder eingetragen,kein Hinw.!"
And I press button "yprintref"
And I close the current editor
#
# ------------------------------------------------------
Scenario: Test5: Packstuecknummern aktualisieren
# ------------------------------------------------------
Given I open an editor "LS123L5" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS123"
# Packstuecknummern eintragen
And I press button "pastnrgen" to open a subeditor for "packstnr3"
And I press button "genpmnum"
And I set field "name" to "Test 5: Objekt akt., kein Hinweis!"
And I press button "yprintref"
And I save the current editor
And I switch the current editor to editor "LS123L5"
And I save the current editor
#
Given I open an editor "Packnum5" from table "(ShippingPlanning):(PackageNumbers)" with command "UPDATE" for record "123L"
And I set field "name" to "Test 5: Objekt akt., kein Hinweis!"
And I press button "yprintref"
And I save the current editor
#
# ------------------------------------------------------
Scenario: Test6: Packstuecknummer max. 17-stellig
# Lieferschein mit langer Nummer anlegen
# Packstuecknummern autom. eintragen
# ------------------------------------------------------
Given I open an editor "VerkaufLieferschein-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
	| nummer | 12345678  |
	| kunde  | 1         |
	| such   | LS1234567 |
And I append rows
	| pnum | artikel | mge | packanw    | fmenge |
	| 1    | V1      | 75  | KARTON4711 | 10     |
# Packmittel berechnen
And I press button "packvor"
# 8186: Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor
#
Given I open an editor "Packnum6" from table "(ShippingPlanning):(PackageNumbers)" with command "UPDATE" for search criteria "$,,nummer=12345678;@gruppe=11"
And I set field "name" to "Test 6: Lieferscheinnummer nicht abschneiden!"
# Packstuecknummer nicht VDA konform (max. 17 Stellen)
And I respond with answer "ja" to the dialog with id "6413"
And I set field "pastnr1" to "345678901234567001"
And I press button "genpmnum"
And I press button "yprintref"
And I save the current editor
#
# ------------------------------------------------------
Scenario: Test7: Packmittel im Lieferschein ersetzen
# -> Packstuecknummern muessen ebenfalls aktualisiert werden
# ------------------------------------------------------
Given I open an editor "LS1234567_2" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS1234567"
And I set field "artikel" to "pm2karton" in row 2
And I set field "fmenge" to "10" in row 2
# 8186: Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor
#
Given I open an editor "Packnum7" from table "(ShippingPlanning):(PackageNumbers)" with command "UPDATE" for search criteria "$,,nummer=12345678;@gruppe=11"
And I set field "name" to "Test 7: Packmittel ersetzen!"
And I press button "yprintref"
And I save the current editor
#
#
# ------------------------------------------------------
Scenario: Test8: mehr als 65535 Packstuecknummer anlegen
# -> Hinweis, dass das Objekt nicht angelegt werden kann
# ------------------------------------------------------
Given I open an editor "VerkaufLieferschein-3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
	| nummer | 2345678   |
	| kunde  | 1         |
	| such   | LS2345678 |
And I append rows
	| pnum | artikel | mge   | packanw    | fmenge |
	| 1    | V1      | 66000 | KARTON4711 | 1      |
# 8186: Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
# 9396: Hinweis - Maximale Anzahl Packstcknummern (65535) ueberschritten. Objekt wird nicht angelegt/geaendert.
And I save the current editor
#
Given I open an editor "LS2345678_2" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS2345678"
And I set field "mge" to "67000" in row 1
# 8186: Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
# 9396: Hinweis - Maximale Anzahl Packstcknummern (65535) ueberschritten. Objekt wird nicht angelegt/geaendert.
And I save the current editor

#
# ------------------------------------------------------
Scenario: Test9: Packstuecknummer max. 9-stellig
# Lieferschein mit langer Nummer anlegen
# Packstuecknummern autom. eintragen
# Wenn mehr als 999 Packstuecke, dann weiter vorne verkuerzen
# ------------------------------------------------------
Given I open an editor "VerkaufLieferschein-4" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
	| nummer | 87654321  |
	| kunde  | 1         |
	| such   | LS8765432 |
And I append rows
	| pnum | artikel | mge | packanw    | fmenge |
	| 1    | V1      | 925 | KARTON4711 | 1      |
# Packmittel berechnen
And I press button "packvor"
# 8186: Hinweis - Packstuecknummern werden automatisch angelegt bzw. aktualisiert - ok?
And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor
#
Given I open an editor "Packnum9" from table "(ShippingPlanning):(PackageNumbers)" with command "UPDATE" for search criteria "$,,nummer=87654321;@gruppe=11"
# Test 9: Lieferscheinnummer nicht abschneiden (Packstuecknr > 999)!
And I set field "name" to "Test 9: Lieferscheinnummer nicht abschneiden"
And I press button "yprintref"
And I save the current editor
#
# ------------------- Ende ----------------------
