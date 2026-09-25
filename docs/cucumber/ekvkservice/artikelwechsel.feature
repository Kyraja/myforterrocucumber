# *****************************************************************************
#  Name           : artikelwechsel.feature
#  Autor          : as
#  Verantwortlich : teampss
#  Funktion       : Testet den Wechsel des Artikels in gespeicherten
#                   Einkaufs- und Verkaufspositionen.
#
# *****************************************************************************
#
@persistent
Feature: Artikelwechsel in gespeicherten Einkaufs- und Verkaufspositionen

Background:
Given I set the fake date to "02.01.1995"

#----------------------------------------------------------------------------------------------
Scenario: Stammdaten
#----------------------------------------------------------------------------------------------

# Artikel anlegen
Given I open an editor "TE001" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE001            |
   | namebspr | Teil001          |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | vpr      | 20               |
   | lief     | 1                |
   | epr      | 10               |
And I save the current editor

Given I open an editor "TE002" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE002            |
   | namebspr | Teil002          |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | vpr      | 22               |
   | lief     | 1                |
   | epr      | 11               |
And I save the current editor

Given I open an editor "TE003" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE003            |
   | namebspr | Teil003          |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | vpr      | 24               |
   | lief     | 1                |
   | epr      | 12               |
And I save the current editor

# Serviceprodukte anlegen
Given I open an editor "SP001-1" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
	| such        | SP001-1                      |
	| name        | Serviceprodukt Artikel TE001 |
	| artikel     | TE001                        |
And I save the current editor

Given I open an editor "SP002-1" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
	| such        | SP002-1                      |
	| name        | Serviceprodukt Artikel TE002 |
	| artikel     | TE002                        |
And I save the current editor

Given I open an editor "VE1-rot" from table "(Part):(Product)" with command "COPY" for record "TE003"
And I set field "such" to "VE1-rot"
And I save the current editor

Given I open an editor "VE1-gelb" from table "(Part):(Product)" with command "COPY" for record "TE003"
And I set field "such" to "VE1-gelb"
And I set field "le" to "Stueck"
And I save the current editor

Given I open an editor "VE1-gruen" from table "(Part):(Product)" with command "COPY" for record "TE003"
And I set field "such" to "VE1-gruen"
And I set field "le" to "Stueck"
And I save the current editor

Given I open an editor "VE1-blau" from table "(Part):(Product)" with command "COPY" for record "TE003"
And I set field "such" to "VE1-blau"
And I set field "bsart" to "Eigenfertigung"
And I set field "le" to "Stueck"
And I save the current editor

Given I open an editor "BASIS-VE1" from table "(Part):(BaseProduct)" with command "NEW" for record ""
And I set field "such" to "BASIS-VE1"
And I append rows
  | tversion  | tindex | tstdvers |
  | VE1-blau  | 1      | ja       |
  | VE1-rot   | 2      | nein     |
  | VE1-gelb  | 3      | nein     |
  | VE1-gruen | 4      | nein     |
And I save the current editor

Given I open an editor "BASIS-TE" from table "(Part):(BaseProduct)" with command "NEW" for record ""
And I set field "such" to "BASIS-TE"
And I append rows
  | tversion  | tindex | tstdvers |
  | TE001     | 1      | nein     |
  | TE002     | 2      | nein     |
  | TE003     | 3      | ja       |
And I save the current editor

Given I open an editor "TE004" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE004            |
   | namebspr | Teil004          |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | vpr      | 10               |
   | lief     | 1                |
   | epr      | 7                |
And I save the current editor

Given I open an editor "TEVARI" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TEVARI           |
   | namebspr | TeilVariante     |
   | bsart    | Fremdbeschaffung |
   | dispoa   | variantenbezogen |
   | vpr      | 90               |
   | lief     | 1                |
   | epr      | 80               |
And I save the current editor

# Setartikel
Given I open an editor "TESET" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TESET            |
   | namebspr | TeilSet          |
   | bsart    | Eigenfertigung   |
   | dispoa   | auftragsbezogen  |
   | vpr      | 90               |
   | lief     | 1                |
   | epr      | 80               |
   | eart     | (UsingBOM)       |
And I create a new row at the end of the table
And I set field "elex" to "TE001" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "TE002" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor

Given I open an editor "BASIS-MIX" from table "(Part):(BaseProduct)" with command "NEW" for record ""
And I set field "such" to "BASIS-MIX"
And I append rows
  | tversion  | tindex | tstdvers |
  | TE004     | 1      | ja       |
  | TEVARI    | 2      | nein     |
  | TESET     | 3      | nein     |
And I save the current editor

# Dienstleistung
Given I open an editor "DL001" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
  | such | DL001 |
  | vpr  | 50    |
And I append rows
  | elex  | anzahl |
  | TE001 | 1      |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Pruefung von Feldinhalten, die beim Artikelwechsel erhalten bleiben sollen
#----------------------------------------------------------------------------------------------

Given I open an editor "1AU001" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU001 |
   | kunde   | 1      |
And I append rows
   | artikel | mge | preis | proz | fixpwert | wtterm   | serpflicht | serprod | zignrahmen | ptext | einplan | katext | rerelev | konddat  | kalk |
   | TE001   | 1   | 31.00 | -10  | ja       | 12.01.95 | ja         | SP001-1 | ja         | ptext | ja      | katext | nein    | 02.02.95 | ja   |
   | TE001   | 1   | 20.00 | 0    | nein     | 14.01.95 | nein       |         | nein       | ptext | ja      | katext | ja      | 04.02.95 | nein |
And I save the current editor

Given I open an editor "1AU001" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU001"
And I set field "artikel" to "TE002" in row 1
Then table has values
   | artikel | mge | preis | proz | fixpwert | wtterm   | serpflicht           | zignrahmen | ptext | einplan | katext | rerelev | konddat  | kalk |
   | TE002   | 1   | 31.00 | -10  | ja       | 12.01.95 | ja                   | ja         | ptext | ja      | katext | nein    | 02.02.95 | ja   |
   | TE001   | 1   | 20.00 | 0    | nein     | 14.01.95 | nein                 | nein       | ptext | ja      | katext | ja      | 04.02.95 | nein |
And I set field "artikel" to "TE003" in row 1
And I set field "einplan" to "nein" in row 1
And I set field "lirelev" to "nein" in row 1
And I set field "artikel" to "TE002" in row 2
Then table has values
   | artikel | mge | preis | proz | fixpwert | wtterm   | serpflicht           | zignrahmen | ptext | einplan | katext | rerelev | konddat  | kalk |
   | TE003   | 1   | 31.00 | -10  | ja       | 12.01.95 | ja                   | ja         | ptext | nein    | katext | nein    | 02.02.95 | ja   |
   | TE002   | 1   | 22.00 | 0    | nein     | 14.01.95 | nein                 | nein       | ptext | ja      | katext | ja      | 04.02.95 | nein |
And I save the current editor

Given I open an editor "1AU001" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU001"
Then table has values
   | artikel | mge | preis | proz | fixpwert | wtterm   | serpflicht           | zignrahmen | ptext | einplan | katext | rerelev | konddat  | kalk |
   | TE003   | 1   | 31.00 | -10  | ja       | 12.01.95 | ja                   | ja         | ptext | nein    | katext | nein    | 02.02.95 | ja   |
   | TE002   | 1   | 22.00 | 0    | nein     | 14.01.95 | nein                 | nein       | ptext | ja      | katext | ja      | 04.02.95 | nein |
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: Artikel aendern im Auftrag mit MZ
#----------------------------------------------------------------------------------------------

# Auftrag mit MZs anlegen
Given I open an editor "AU-001" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "001-AU"
And I set field "such3" to "AU_001"
And I create a new row at the end of the table
And I set field "artex" to "VE1-blau" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "20" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "5" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "5" in row 2
And I save the current editor
And I switch the current editor to editor "AU-001"
And I save the current editor

# Reservierung und Beschaffer pruefen
Given I open an editor "Reserv1" from table "(Purchasing):(Reservations)" with command "VIEW" for search criteria "$,,elex=VE1-blau;@richtung=rueckwaerts;@maxtreffer=1"
Then field "elex" has value "VE1-BLAU" in row 1
And I close the current editor

And I run Scheduling

Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "VE1-blau"
And I press button "ladetab"
Then the table has 1 rows
And I close the current editor

# Version im Auftrag tauschen
Given I open an editor "AU-001-UP" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-001"
And I respond with answer "Ja" to the dialog with id "6726"
And I set field "artex" to "VE1-rot" in row 1
And I set field "artex" to "VE1-gelb" in row 1
And I save the current editor

# Reservierung ist geloescht, neue Reservierung wurde angelegt
# Fehler 1582: ungueltige Objektangabe
Then opening an editor from table "(Purchasing):(Reservations)" with command "VIEW" for record from editor "Reserv1" throws the exception "1582"
And I close the current editor

Given I open an editor "Reserv1" from table "(Purchasing):(Reservations)" with command "VIEW" for search criteria "$,,elex=VE1-gelb;@richtung=rueckwaerts;@maxtreffer=1"
Then field "elex" has value "VE1-GELB" in row 1
And I close the current editor

 # Bestellvorschlag zu VE1-blau ist geloescht
And I run Scheduling

Given I open an editor "Bestellvorschlaege" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "VE1-blau"
And I press button "ladetab"
Then the table has 0 rows
And I close the current editor

# Nachkalkulation (nicht gestartet ohne menuechoice)
Given I open an editor "AU-001-NK" from table "(Sales):(SalesOrder)" with command "CALCULATE" for record "AU_001" and menu choice "1"
And I save the current editor

Given I open an editor "AU-001-NK" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-001"
And I press button "kalkul" to open a subeditor for "Nachkalkulation" in row 0 with dialog "" and answer "1"
And I save the current subeditor to switch back to the parent editor
# And I press button "kblatt" to open a subeditor for "Kblatt" in row 1
# And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Nach Artikelwechsel ist Kalkulationsblatt geloescht
Given I open an editor "AU-001-KB" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-001"
And I set field "artex" to "VE1-rot" in row 1
# And I press button "kblatt" to open a subeditor for "KBlatt" in row 1
# And I save the current subeditor to switch back to the parent editor
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Artikel aendern in Auftrag mit Kostensammler
#----------------------------------------------------------------------------------------------

# Auftrag mit MZs anlegen
Given I open an editor "AU-002" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "002-AU"
And I create a new row at the end of the table
And I set field "artex" to "VE1-gelb" in row 1
And I set field "mge" to "35" in row 1
And I set field "preis" to "12" in row 1
And I save the current editor

Given I open an editor "AU-002-UP" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-002"
And I set field "artex" to "VE1-gruen" in row 1
And I save the current editor

# Kostensammler hat sich nach dem Speichern angepasst
Given I open an editor "AU-002-KS" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-002"
And I press button "buksamml" to open a subeditor for "Kostensammler" in row 1
Then the table has 0 rows
And I save the current subeditor to switch back to the parent editor
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Artikel aendern in Bestellung mit MZ
#----------------------------------------------------------------------------------------------

# Bestellung anlegen
Given I open an editor "BE-001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "001-BE"
And I create a new row at the end of the table
And I set field "artex" to "VE1-rot" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "25" in row 1
And I save the current editor
And I switch the current editor to editor "BE-001"
And I respond with answer "Ja" to the dialog with id "6726"
And I set field "artex" to "VE1-blau" in row 1
And I set field "mge" to "25" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Artikel ohne Basisartikel nach Speichern nicht aenderbar
#----------------------------------------------------------------------------------------------

# Auftrag anlegen
Given I open an editor "AU-003" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "003-AU"
And I create a new row at the end of the table
And I set field "artex" to "E3" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "3" in row 1
And I save the current editor

Given I open an editor "AU-003-UP" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-003"
Then field "artex" is not modifiable in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: Set-Artikel und variantenbezogener Artikel nicht aenderbar
#----------------------------------------------------------------------------------------------

# Auftrag anlegen
Given I open an editor "AU-004" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "004-AU"
And I create a new row at the end of the table
And I set field "artex" to "TE004" in row 1
And I set field "mge" to "2" in row 1
And I set field "preis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artex" to "TEVARI" in row 2
And I set field "mge" to "5" in row 2
And I set field "preis" to "90" in row 2
And I create a new row at the end of the table
And I set field "artex" to "TESET" in row 3
And I set field "mge" to "3" in row 3
And I set field "preis" to "15" in row 3
And I save the current editor

Given I open an editor "AU-004-UP" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-004"
And I set field "artex" to "TESET" in row 1
Then field "artex" is not modifiable in row 2
Then field "artex" is not modifiable in row 3
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Artikel im Auftrag mit Folgeaktion (Lieferschein) nicht aenderbar
#----------------------------------------------------------------------------------------------

# Auftrag anlegen
Given I open an editor "AU-005" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "005-AU"
And I create a new row at the end of the table
And I set field "artex" to "TE004" in row 1
And I set field "mge" to "120" in row 1
And I set field "preis" to "12" in row 1
And I save the current editor

# Artikel in Auftrag aenderbar
Given I open an editor "AU-005E" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-005"
Then field "artex" is modifiable in row 1
And I save the current editor

# Lieferschein zu Auftrag
Given I open an editor "LS-005" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU-005"
And I set field "mge" to "100" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Artikel in Auftrag nicht mehr aenderbar
Given I open an editor "AU-005NE" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-005"
Then field "artex" is not modifiable in row 1
And I save the current editor

# Storno Lieferschein
Given I open an editor "STO-LS-005" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS-005"
And I set field "num3" to "005-STLS"
And I save the current editor

# Artikel in Auftrag wieder aenderbar
Given I open an editor "AU-005AE" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-005"
Then field "artex" is modifiable in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Aenderbarkeit der Artikelversion im Serviceauftrag
#----------------------------------------------------------------------------------------------

# Serviceauftrag anlegen
Given I open an editor "1SA001" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1SA001 |
   | kunde   | 1      |
And I append rows
   | artikel | mge |
   | TE001   | 10  |
And I save the current editor

# Artikelversion in Serviceauftrag aenderbar
Given I open an editor "1SA001" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA001"
Then field "artex" is modifiable in row 1
And I save the current editor

# Lieferschein zu Serviceauftrag
Given I open an editor "1LS001" from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record from editor "1SA001"
And I set fields
   | nummer  | 1LS001 |
   | ueb     | ja     |
And I set field "mge" to "5" in row 1
And I save the current editor

# Artikelversion im Serviceauftrag nicht mehr aenderbar
Given I open an editor "1SA001" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA001"
Then field "artex" is not modifiable in row 1
And I save the current editor

# Storno Lieferschein
Given I open an editor "1LS001S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS001"
And I set field "num3" to "1LS001S"
And I save the current editor

# Artikelversion im Serviceauftrag wieder aenderbar
Given I open an editor "1SA001" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA001"
Then field "artex" is modifiable in row 1
And I save the current editor

# Artikelversioen bei vorhandenen MZs aenderbar
Given I open an editor "1SA001" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA001"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "5" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "5" in row 2
And I save the current editor
And I switch the current editor to editor "1SA001"
Then field "artex" is modifiable in row 1
And I save the current editor

# Serviceauftrag anlegen
Given I open an editor "1SA003" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1SA003 |
   | kunde   | 1      |
And I append rows
   | artikel | mge |
   | TE001   | 10  |
And I save the current editor

# Rueckmeldung zum Serviceauftrag anlegen
Given I open an editor "1ECC01" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set fields
   | nummer  | 1ECC01 |
   | servau  | 1SA003 |
   | lgr     | 1      |
   | kstelle | 101    |
   | ueb     | nein   |
And I press button "ladetab"
And I set field "bumge" to "6" in row 1
And I save the current editor

# Artikelversion im Serviceauftrag nicht mehr aenderbar
Given I open an editor "1SA003" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA003"
Then field "artex" is not modifiable in row 1
And I save the current editor

# Rueckmeldung zum Serviceauftrag buchen
Given I open an editor "1ECC01" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "UPDATE" for record from editor "1ECC01"
And I set field "ueb" to "ja"
And I save the current editor

# Artikelversion im Serviceauftrag nicht mehr aenderbar
Given I open an editor "1SA003" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA003"
Then field "artex" is not modifiable in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Behandlung des Originalvorgangs beim Wechsel der Artikelposition
#----------------------------------------------------------------------------------------------

Given I open an editor "1AN001" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AN001 |
   | kunde   | 1      |
And I append rows
   | artikel | mge |
   | TE001   | 10  |
And I save the current editor

Given I open an editor "1AU002" from table "(Sales):(Quotation)" with command "RELEASE" for record from editor "1AN001"
And I set field "nummer" to "1AU002"
And I set field "artikel" to "TE002" in row 1
And I save the current editor
Then "(Sales):(Quotation)" with the editor id "1AN001" is filed

Given I open an editor "1WA001" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1WA001 |
   | kunde   | 1      |
And I append rows
   | artikel | mge |
   | TE001   | 10  |
And I save the current editor

Given I open an editor "1AU003" from table "(Sales):(WebOrder)" with command "RELEASE" for record from editor "1WA001"
And I set field "nummer" to "1AU003"
And I set field "artikel" to "TE002" in row 1
And I save the current editor
Then "(Sales):(WebOrder)" with the editor id "1WA001" is filed

Given I open an editor "1RA001" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1RA001 |
   | kunde   | 1      |
And I append rows
   | artikel | mge  | preis |
   | TE001   | 1000 | 17    |
And I save the current editor

Given I open an editor "1RA001" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record from editor "1RA001"
And I set field "nummer" to "1AU004"
And I set field "artikel" to "TE002" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Artikeltausch mit Abbruch in der Maske
#----------------------------------------------------------------------------------------------

Given I open an editor "1AU005" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU005 |
   | kunde   | 1      |
And I append rows
   | artikel | mge |
   | TE001   | 10  |
And I save the current editor

Given I open an editor "1AU005" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU005"
And I set field "artikel" to "TE002" in row 1
And I close the current editor

Given I open an editor "1AU005" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU005"
And I set field "artikel" to "TE002" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK -  Leeren des Artikels im Auftrag mit Basisartikel nicht erlaubt
#----------------------------------------------------------------------------------------------

# Auftrag mit Artikel und Basisartikel anlegen
Given I open an editor "1AU006" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1AU006 |
	| kunde  | 1      |
	| vom	 | .      |
And I append rows
   | artikel | mge |
   | VE1-rot | 10  |
Then field "basisartikel" has value "BASIS-VE1" in row 1
And I save the current editor

# Artikel leeren ist nicht moeglich, aendern jedoch schon
Given I open an editor "1AU6UP" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU006"
Then setting field "artikel" to "" in row 1 throws the exception "9954"
And I set field "artikel" to "VE1-blau" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Aendern des Artikels nicht erlaubt, wenn Status gesetzt
#----------------------------------------------------------------------------------------------

# Auftrag mit Artikel und Basisartikel anlegen
Given I open an editor "1AU007" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1AU007 |
	| kunde  | 1      |
	| vom	 | .      |
And I append rows
   | artikel  | mge | status |
   | VE1-rot  | 10  | .      |
   | VE1-blau | 10  |        |
Then field "basisartikel" has value "BASIS-VE1" in row 1
And I save the current editor

# Artikel aendern nicht moeglich
Given I open an editor "1AU7UP" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU007"
Then field "artex" is not modifiable in row 1
And I set field "artikel" to "VE1-gruen" in row 2
# Wollen Sie wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 2
Then field "artex" is not modifiable in row 2
And I set field "status" to "" in row 2
Then field "artex" is modifiable in row 2
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Aendern des Artikels im Auftrag nicht erlaubt, wenn Versandplanung vorhanden
#----------------------------------------------------------------------------------------------

# Auftrag mit Artikel und Basisartikel anlegen
Given I open an editor "1AU008" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1AU008 |
	| kunde  | 1      |
	| vom	 | .      |
And I append rows
   | artikel  | mge |
   | VE1-blau | 10  |
Then field "basisartikel" has value "BASIS-VE1" in row 1
And I save the current editor

# Versandplanung ueber Beleg anfuegen
Given I open an editor "Versandplanung" from table "119:01" with command "NEW" for record ""
And I set field "pstermvon" to "."
And I set field "beleganfuegen" to "nummer" from editor "1AU008"
Then the table has 1 rows
And I save the current editor

# Artikel aendern nicht moeglich
Given I open an editor "1AU8UP" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU008"
Then field "artex" is not modifiable in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Aendern des Artikels im Serviceauftrag erlaubt
#----------------------------------------------------------------------------------------------

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "SPROD" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "SPRO-001"
And I set field "namebspr" to "SPRO-001"
And I set field "artikel" to "VE1-rot"
And I set field "kunde" to "1"
And I save the current editor

Given I open an editor "1SA002" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1SA002 |
	| kunde  | 1      |
	| vom	 | .      |
And I append rows
   | serprod  | artikel | mge |
   | SPRO-001 | VE1-rot | 10  |
And I save the current editor
 
# Artikel aendern nicht moeglich
Given I open an editor "1SAU2UP" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "1SA002"
Then field "artex" is modifiable in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Aendern des Artikels im Reparaturauftrag nicht erlaubt
#----------------------------------------------------------------------------------------------

# Reparaturauftrag anlegen 
Given I open an editor "1RP001" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1RP001 |
	| kunde  | 1      |
	| vom	 | .      |
And I append rows
   | serprod  | artikel |
   | SPRO-001 | VE1-rot |
And I save the current editor

# Artikel aendern nicht moeglich
Given I open an editor "1RAU1UP" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "1RP001"
Then field "artex" is not modifiable in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Aenderung des Artikels im Kostenvoranschlag
#----------------------------------------------------------------------------------------------

# Reparaturauftrag mit Kostenvoranschlag anlegen, Artikelwechsel
Given I open an editor "1RP002" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1RP002 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge | repverr                             |
   | DL001   | 1   | Nach Aufwand zzgl. Ersatzteilkosten |
And I press button "kostenvorb" to open a subeditor for "1KV001"
And I set field "artikel" to "" in row 2
And I set field "artikel" to "TE002" in row 2
And I save the current editor
And I switch the current editor to editor "1RP002"
And I save the current editor

# Im Reparaturauftrag in die Feritgungsliste absteigen
Given I open an editor "1RP002" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "1RP002"
And I press button "absteig" to open a subeditor for "afl" in row 1
And I save the current editor
And I switch the current editor to editor "1RP002"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Aendern des Artikels im Auftrag mit Abruftyp nicht erlaubt
#----------------------------------------------------------------------------------------------

# Auftrag anlegen
Given I open an editor "AU-09" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "09-AU"
And I append rows
  | artikel  | mge | preis | fmenge | abruftyp |
  | VE1-blau | 100 | 9     | 10     | LAB      |
Then field "basisartikel" has value "BASIS-VE1" in row 1
And I save the current editor

# Aendern-Modus: In Auftragspositionen mit gesetzten Abruftyp darf der Artikel nicht getauscht werden und wird schreibgeschuetzt.
Given I open an editor "AU-09-UP" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-09"
Then field "artex" is not modifiable in row 1
And I set field "abruftyp" to "" in row 1
And I set field "artikel" to "VE1-gelb" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Basisartikelfeld leeren
#----------------------------------------------------------------------------------------------

Given I open an editor "" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1AU010 |
	| kunde  | 1      |
	| vom	 | .      |
And I append rows
    | artikel  | mge |
    | V1       | 100 |
And I set field "basisartikel" to "" in row 1
And I set field "kl2" to "1"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Artikelwechsel nach Freigabe Rahmenauftrag
#----------------------------------------------------------------------------------------------

# Rahmenauftrag mit Fertigungsliste anlegen
Given I open an editor "1RA011" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1RA011   |
   | kunde   | 1        |
And I append rows
   | artikel | he    | mge  | preis |
   | TE001   | Stück | 1000 | 90    |
And I press button "absteig" to open a subeditor for "afl" in row 1
And I save the current editor
And I switch the current editor to editor "1RA011"
And I save the current editor

# Rahmenauftrag freigeben, Artikel austauschen
Given I open an editor "1AU011" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record from editor "1RA011"
And I set fields
   | nummer  | 1AU011   |
And I set field "artikel" to "TE002" in row 1
And I set field "artikel" to "TE001" in row 1
And I save the current editor

