# *****************************************************************************
#  Name           : lieferanten.feature
#  Autor          : dago
#  Verantwortlich : teampss
#  Funktion       : Testet Funktionen rund um den Lieferantenstamm
#
# *****************************************************************************
#
@persistent
Feature: Lieferanten Stammdaten
Background:
Given I set the fake date to "05.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Lieferant - Feldeingaben ueberpruefen
# ----------------------------------------------------------------------------------------------

# Sanktionslistenpruefung einschalten
Given I open an editor "config" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "slp" to "ja"
And I save the current editor

# Phantasie-Waehrung anlegen
Given I open an editor "Currency" from table "(Currency):(Currency)" with command "NEW" for record ""
And I set fields
   | such  | XYZ |
   | iso3a | 123 |
   | iso3n | 123 |
And I save the current editor

# Eingaben Pruefen
Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "1"
# Fehler bei Feld D:land,liwaehr, E:credLimCurr in Zeile 0: Unbekannte Waehrung (vgl. Kurstabelle im Firmenstamm)
Then setting field "land" to "XYZ" throws the exception "3120"
Then setting field "w2ist" to "XYZ" throws the exception "185"
Then setting field "mwaehr" to "" throws the exception "0"
# Geschaeftsjahr in Termindatensatz nicht definiert
Then setting field "gjahr" to "2001" throws the exception "131"
# Minimaler Laengengrad: -180 / Maximaler Laengengrad: 180
# Minimaler Breitengrad:  -90 / Maximaler Breitengrad:  90
Then setting field "laengengrad" to "-181" throws the exception "131"
Then setting field "laengengrad2" to "-181" throws the exception "131"
Then setting field "laengengrad" to "188" throws the exception "131"
Then setting field "laengengrad2" to "188" throws the exception "131"
Then setting field "breitengrad" to "-91" throws the exception "131"
Then setting field "breitengrad2" to "-91" throws the exception "131"
Then setting field "breitengrad" to "92" throws the exception "131"
Then setting field "breitengrad2" to "92" throws the exception "131"
# Die DUNS-Nummer muss aus 9 Ziffern und maximal 2 Trennzeichen (-) bestehen.
Then setting field "duns" to "12ab-3---3" throws the exception "2789"
# "nicht gefunden"
Then setting field "grkenn" to "__" throws the exception "149"
# USt-IdNr muss mit EU-Kennung beginnen
Then setting field "ustid" to "rrrr56" throws the exception "1694"
# 334: ist keine Region des Landes: DEUTSCHLAND
Then setting field "region" to "334" throws the exception ""
# Bei eingeschalteter Sanktionslistenpruefung wird die Hashadresse neu ermittelt.
And I set field "str" to "Musterstrasse"
Then field "hashadr" has value ""
# Keine Telefonnummer eingetragen
And I set field "tele" to ""
Then pressing button "anrufen" throws the exception "4948"
And I set field "tele2" to ""
Then pressing button "anrufen2" throws the exception "4948"
And I set field "mtele" to ""
Then pressing button "manrufen" throws the exception "4948"
Then pressing button "manrufen2" throws the exception "4948"
# Keine E-Mail eingetragen.
Then pressing button "mailto" throws the exception "4220"
Then pressing button "mailto2" throws the exception "4220"
# Keine Website eingetragen.
Then pressing button "browurl" throws the exception "2862"
Then pressing button "browurl2" throws the exception "2862"
# Unzulaessiges Sprachkennzeichen
Then setting field "spr" to "B" throws the exception "131"
# Identnummer darf nur waehrend der Neuanlage geaendert werden
Then setting field "nummer" to "11" throws the exception "7167"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Eingabe des USt Schluessels fuer Lieferantenkontakt in FRA
# ----------------------------------------------------------------------------------------------

# Lieferant neu Amerikaner
Given I open an editor "LieferantLieferant-1" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
	| such     | AMI                    |
	| namebspr | John Wayne & Co        |
	| str      | Mullholand Drive 1232  |
	| nort     | Hollywood              |
	| staat    | USA                    |
	| mwaehr   | USD                    |
And I save the current editor

# Lieferantenkontakt zum Amerikaner anlegen
Given I open an editor "LieferantLieferantenkontakt-2" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
And I set fields
	| firma | AMI      |
	| such  | VENDOR2  |
And I save the current editor

Given I open an editor "LieferantLieferantenkontakt-2.3" from table "(Vendor):(VendorContact)" with command "UPDATE" for record from editor "LieferantLieferantenkontakt-2"
# Lieferant auf Franzosen aendern
And I set field "firma" to "004"
# Franzoesische UST ID eintragen
And I set field "ustid" to "FRXX123432356"
And I save the current editor

# Eingabe Staat/Laenderkennung testen
Given I open an editor "LandAblegen" from table "(Regions):(RegionCountryEconomicArea)" with command "DELETE" for record "Spanien"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Given I open an editor "LieferantLieferant-4" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
	| such     | LAENDERK            |
	| namebspr | Laenderkennungtest  |
# Erwarteter Fehler: Land-Kennzeichen nicht definiert
Then setting field "lakenn" to "UNGUELTIG" throws the exception "1361"
And I set field "lakenn" to "D"
# Erwarteter Fehler: UNGUELTIG: nicht gefunden
Then setting field "staat" to "UNGUELTIG" throws the exception "1361"
# Erwarteter Fehler: NIEDERSACHSEN ist kein Land
Then setting field "staat" to "NIEDERSACHSEN" throws the exception "1361"
# Erwarteter Fehler: SPANIEN: nicht gefunden (ist abgelegt)
Then setting field "staat" to "SPANIEN" throws the exception "1361"
And I set field "staat" to "DEUTSCHLAND"
# alles wieder verwerfen
And I close the current editor

# Franzoesischen Lieferantenkontakt pruefen
Given I open an editor "LieferantLieferantenkontakt-3" from table "(Vendor):(VendorContact)" with command "VIEW" for record "VENDOR2"
Then field "such" has value "VENDOR2"
Then field "firma" has value "004"
Then field "ustid" has value "FRXX123432356"
Then field "egkenn" has value "FR"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: 2. Buchungswährung eintragen (Teil I) - VORBEREITUNG FÜR DAS EIGENTLICHE NÄCHSTE SZENARIO
# ----------------------------------------------------------------------------------------------
# separates Szenario, damit der Eintrag ohne Wartung erfolgt
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "004"
And I set field "w2ist" to "CAD"
And I set field "w2gjahr" to "95"
And I save the current editor

Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "004"
Then field "w2ist" has value "CAD"
Then field "w2gjahr" has value "95"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: 2. Buchungswährung muss in Wartung jederzeit geleert werden können (Teil II)
# ----------------------------------------------------------------------------------------------
# separates Szenario, weil das Wartungslogin nur am Anfang stehen kann!
Given I'm logged in with password "annette"

Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "004"
And I set field "w2ist" to ""
And I set field "w2gjahr" to ""
# das im letzten Szenario gespeicherte Zeichen ist...
Then field "zeichen" has value "SY"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: 2. Buchungswährung u. GJ leer. und muss auch ohne Wartung wieder speicherbar sein (Teil III)
# ----------------------------------------------------------------------------------------------
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "VIEW" for record "004"
Then field "w2ist" has value ""
Then field "w2gjahr" has value ""
# das im letzten Szenario gespeicherte Zeichen muss Wartung sein!
Then field "zeichen" has value "W*"
And I close the current editor

Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "004"
And I save the current editor
