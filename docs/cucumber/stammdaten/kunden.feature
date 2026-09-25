# *****************************************************************************
#  Name           : kunden.feature
#  Autor          : dago
#  Verantwortlich : teampss
#  Funktion       : Testet Funktionen rund um den Kundenstamm
#
# *****************************************************************************
#
@persistent
Feature: Kunden Stammdaten
Background:
Given I set the fake date to "05.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Kunde - Feldeingaben ueberpruefen
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
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "1"
# Fehler bei Feld D:liland,liwaehr, E:credLimCurr in Zeile 0: Unbekannte Waehrung (vgl. Kurstabelle im Firmenstamm)
Then setting field "liland" to "XYZ" throws the exception "185"
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
# Elektronischer Rechnungsversand aktiv. Bitte E-Mail-Adresse des Rechnungsempfaengers eintragen.
And I set field "erechok" to "ja"
Then saving the current editor throws the exception "6654"
And I set field "erechmail" to "mustermann@abas.de"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Eingabe des USt Schluessels fuer Kundenkontakt in FRA
# ----------------------------------------------------------------------------------------------

# Kunde neu Amerikaner
Given I open an editor "KundeKunde-1" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
	| such     | AMI                    |
	| namebspr | John Wayne & Co        |
	| str      | Mullholand Drive 1232  |
	| nort     | Hollywood              |
	| staat    | USA                    |
	| mwaehr   | USD                    |
And I save the current editor

# Kundenkontakt zum Amerikaner anlegen
Given I open an editor "KundeKundenkontakt-2" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
And I set fields
	| firma | AMI      |
	| such  | MILLER2  |
And I save the current editor

Given I open an editor "Kundekundenkontakt-2.3" from table "(Customer):(CustomerContact)" with command "UPDATE" for record from editor "KundeKundenkontakt-2"
# Kunde auf Franzosen aendern
And I set field "firma" to "008"
# Franzoesische UST ID eintragen
And I set field "ustid" to "FRXX123432356"
And I save the current editor

# Eingabe Staat/Laenderkennung testen
Given I open an editor "LandAblegen" from table "(Regions):(RegionCountryEconomicArea)" with command "DELETE" for record "Spanien"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Given I open an editor "KundeKunde-4" from table "(Customer):(Customer)" with command "NEW" for record ""
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

# Franzoesischen Kundenkontakt pruefen
Given I open an editor "KundeKundenkontakt-3" from table "(Customer):(CustomerContact)" with command "VIEW" for record "MILLER2"
Then field "such" has value "MILLER2"
Then field "firma" has value "008"
Then field "ustid" has value "FRXX123432356"
Then field "egkenn" has value "FR"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Eingabe Techniker Team
# ----------------------------------------------------------------------------------------------

# Neuen Techniker anlegen MOSS
Given I open an editor "techniker" from table "(ServiceEmployees):(EmployeeRole)" with command "NEW" for record ""
And I set field "such" to "Moss"
And I set field "namebspr" to "Moss"
And I set field "ma" to "TEST"
And I save the current editor

# Neuen Techniker anlegen Hannibal
Given I open an editor "techniker" from table "(ServiceEmployees):(EmployeeRole)" with command "NEW" for record ""
And I set field "such" to "Hannibal"
And I set field "namebspr" to "Hannibal"
And I set field "ma" to "KARL"
And I save the current editor

# Neuen Techniker anlegen B.A.
Given I open an editor "techniker" from table "(ServiceEmployees):(EmployeeRole)" with command "NEW" for record ""
And I set field "such" to "BA"
And I set field "namebspr" to "B.A."
And I set field "ma" to "Meier"
And I save the current editor

# Team A-Team anlegen
Given I open an editor "serviceeinsEinsatzmittel-17" from table "(ServiceEmployees):(Team)" with command "NEW" for record ""
And I set fields
	| such     | ATEAM  |
	| name     | A-Team |
	| teamleit | KARL   |
And I append rows
	| mitarbrolle | gltvon   |
	| Hannibal    | 01.01.95 |
	| BA          | 01.01.95 |
And I save the current editor

Given I open an editor "KundeKunde-2" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
	| such     | TEC     |
	| namebspr | TecTest |
And I set field "serteam" to "ATEAM"
# Der Techniker gehoert nicht zu dem ausgewaehlten Team
Then setting field "techniker" to "Moss" throws the exception "5819"
And I set field "techniker" to "BA"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: 2. Buchungswährung eintragen (Teil I) - VORBEREITUNG FÜR DAS EIGENTLICHE NÄCHSTE SZENARIO
# ----------------------------------------------------------------------------------------------
# separates Szenario, damit der Eintrag ohne Wartung erfolgt
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "5"
And I set field "w2ist" to "CAD"
And I set field "w2gjahr" to "95"
And I save the current editor

Given I open an editor "kunde" from table "(Customer):(Customer)" with command "VIEW" for record "5"
Then field "w2ist" has value "CAD"
Then field "w2gjahr" has value "95"
Then field "zeichen" has value "SY"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: 2. Buchungswährung muss in Wartung jederzeit geleert werden können (Teil II)
# ----------------------------------------------------------------------------------------------
# separates Szenario, weil das Wartungslogin nur am Anfang stehen kann!
Given I'm logged in with password "annette"

Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "5"
And I set field "w2ist" to ""
And I set field "w2gjahr" to ""
# das im letzten Szenario gespeicherte Zeichen ist...
Then field "zeichen" has value "SY"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: 2. Buchungswährung u. GJ leer. und muss auch ohne Wartung wieder speicherbar sein (Teil III)
# ----------------------------------------------------------------------------------------------
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "VIEW" for record "5"
Then field "w2ist" has value ""
Then field "w2gjahr" has value ""
# das im letzten Szenario gespeicherte Zeichen muss Wartung sein!
Then field "zeichen" has value "W*"
And I close the current editor

Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "5"
And I save the current editor
