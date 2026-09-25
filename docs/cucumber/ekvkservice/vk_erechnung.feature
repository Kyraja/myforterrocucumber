#@persistent
Feature: Plausi-Test der Felder fuer die E-Rechnung und fuer ZUGFeRD
Background:
Given I set the fake date to "02.01.2002"
Given I enable the flag 39

Scenario: Werden die E-Rechnungsinformationen in Vorgaengen richtig uebernohmen?

@print:
Scenario: Aktivieren der Konfiguration erech
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "habel" to "1"
And I save the current editor

# STAMMDATEN - Neuen Kunden anlegen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Bayram"
And I set field "such" to "Bayram"
And I set field "namebspr" to "Bayram Werkzeugbau, Rastatt"
And I set field "ans" to "Bayram Werkzeugbau GmbH"
And I set field "str" to "Riedstr. 24-28"
And I set field "plz" to "76437"
And I set field "nort" to "Rastatt"
And I set field "region" to "BADEN"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@bayram-corp.de"
And I set field "betreuer" to "."
And I set field "ustid" to "DE56454651"
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I set field "erechok" to "ja"
And I set field "erechmail" to "info@abas.de"
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
And I save the current editor

Examples: Artikel
| such     | namebspr  | vkbez     | vbez      | ebez      | vpr   | bsart            | dispoa         |
| artikel1 | Artikel 1 | Artikel 1 | Artikel 1 | Artikel 1 | 10000 | Fremdbeschaffung | bedarfsbezogen |
| artikel2 | Artikel 2 | Artikel 2 | Artikel 2 | Artikel 2 | 9000  | Fremdbeschaffung | bedarfsbezogen |

Scenario: Chance anlegen
Given I open an editor "chance" from table "(Sales):(Opportunity)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "1" in row 1
And I save the current editor
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"

# Chance in Angebot ueberfuehren
Given I open an editor "angebot1" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set field "beleg" to id from editor "chance"
And I set field "such" to "ANG1"
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"
And I save the current editor

# E-Rechnungsfelder im Angebot anpassen
Given I open an editor "angebot1" from table "(Sales):(Quotation)" with command "UPDATE" for record "ANG1"
And I set field "erechok" to "ja"
And I set field "erechmail" to "angebot1@abas.de"
And I save the current editor

# Aus Angebot einen Auftrag erfassen, Felder aus dem Angebot uebernehmen.
Given I open an editor "auftrag11" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "beleg" to id from editor "angebot1"
Then field "erechok" has value "ja"
Then field "erechmail" has value "angebot1@abas.de"
And I save the current editor

Scenario: Angebot anlegen
Given I open an editor "angebot2" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ANG2"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "1" in row 1
And I save the current editor
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"

# E-Felder leeren, um zu pruefen, ob diese aus den Stammdaten uebernohmen werden
Given I open an editor "angebot1" from table "(Sales):(Quotation)" with command "UPDATE" for record "ANG2"
And I set field "erechok" to "nein"
And I set field "erechmail" to ""
And I save the current editor

# Angebot in Auftrag ueberfuehren
Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "beleg" to id from editor "angebot2"
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"
And I save the current editor

Scenario: Auftrag anlegen
Given I open an editor "auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "2" in row 1
And I save the current editor
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"

# Auftrag in Lieferschein ueberfuehren
Given I open an editor "lieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag2"
And I set field "mge" to "1" in row 1
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"
And I save the current editor

Scenario: Lieferschein anlegen
Given I open an editor "lieferschein2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "ueb" to "ja"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "2" in row 1
And I save the current editor
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"

# Lieferschein in Rechnung ueberfuehren
Given I open an editor "rechnung1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein2"
And I set field "vom" to "."
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Rechnung anlegen
Given I open an editor "rechnung2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vom" to "."
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"

Scenario: Lieferschein anlegen ohne erechok und erechmail
Given I open an editor "lieferschein3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "erechok" to "nein"
And I set field "erechmail" to ""
And I set field "ueb" to "ja"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "3" in row 1
And I save the current editor
Then field "erechok" has value "nein"
Then field "erechmail" is empty

# Lieferschein in Rechnung ueberfuehren
Given I open an editor "rechnung3" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein3"
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Angebot anlegen, leere E-Rechnungsfelder im Angebot -> diese aus den Stammdaten des Rechnungsempfaengers uebernehmen
Given I open an editor "angebot3" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ANG3"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "3" in row 1
And I save the current editor
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"

# E-Felder leeren, um zu pruefen, ob diese aus den Stammdaten uebernohmen werden
Given I open an editor "angebot3" from table "(Sales):(Quotation)" with command "UPDATE" for record "ANG3"
And I set field "erechok" to "nein"
And I set field "erechmail" to ""
And I save the current editor

# Angebot in Auftrag ueberfuehren
Given I open an editor "auftrag3" from table "(Sales):(SalesOrder)" with command "NEW" for record "ANG3"
And I set field "beleg" to id from editor "angebot3"
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"
And I save the current editor

Scenario: Webauftrag anlegen
Given I open an editor "web1" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "2" in row 1
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 2
And I set field "mge" to "2" in row 2
And I save the current editor
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"

# Webauftrag in Auftrag ueberfuehren
Given I open an editor "auftrag3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "beleg" to id from editor "web1"
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"
And I set field "mge" to "1" in row 1
And I delete row at position 2
And I save the current editor

# Aus Webauftrag erechok und erechmail entfernen
Given I open an editor "web2" from table "(Sales):(WebOrder)" with command "UPDATE" for record from editor "web1"
And I set field "erechok" to "nein"
And I set field "erechmail" to ""
And I save the current editor

# Webauftrag in Auftrag ueberfuehren
Given I open an editor "auftrag4" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "beleg" to id from editor "web2"
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"
And I save the current editor

Scenario: Rahmenauftrag anlegen
Given I open an editor "rahmen1" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"

# Rahmenauftrag in Auftrag ueberfuehren
Given I open an editor "auftrag5" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rahmen1"
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"
And I set field "mge" to "5" in row 1
And I save the current editor

# Aus Rahmenauftrag erechok und erechmail entfernen
Given I open an editor "rahmen2" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record from editor "rahmen1"
And I set field "erechok" to "ja"
And I set field "erechmail" to "rahmen2@abas.de"
And I save the current editor

# Rahmenauftrag in Auftrag ueberfuehren
Given I open an editor "auftrag6" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rahmen2"
Then field "erechok" has value "ja"
Then field "erechmail" has value "rahmen2@abas.de"
And I save the current editor

Scenario: Auftrag anlegen
Given I open an editor "auftrag7" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "2" in row 1
And I save the current editor
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"

# Auftrag in Lieferschein ueberfuehren
Given I open an editor "lieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag7"
And I set field "mge" to "1" in row 1
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"
And I save the current editor

# Aus Auftrag erechok und erechmail entfernen
Given I open an editor "auftrag8" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "auftrag7"
And I set field "erechok" to "nein"
And I set field "erechmail" to ""
And I save the current editor

# Auftrag in Lieferschein ueberfuehren
Given I open an editor "lieferschein2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag8"
And I set field "mge" to "1" in row 1
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"
And I save the current editor

Scenario: Lieferschein anlegen
Given I open an editor "lieferschein3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "2" in row 1
And I set field "ueb" to "ja"
And I save the current editor
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"

# Lieferschein in Rechnung ueberfuehren
Given I open an editor "rechnung1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein3"
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"
And I set field "mge" to "1" in row 1
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841" 
And I save the current editor

# Neuen Lieferschein anlegen und erechok und erechmail entfernen
Given I open an editor "lieferschein4" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "6" in row 1
And I set field "ueb" to "ja"
And I set field "erechok" to "nein"
And I set field "erechmail" to ""
And I save the current editor

# Lieferschein in Rechnung ueberfuehren
Given I open an editor "erechnung2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "2ERECH"
And I set field "such" to "ERECH2"
And I set field "beleg" to id from editor "lieferschein4"
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841" 
And I save the current editor

Scenario: Rechnung anlegen
Given I open an editor "erechnung3" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "3ERECH"
And I set field "such" to "ERECH3"
And I set field "kunde" to id from editor "kunde"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841" 
And I save the current editor
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"

Scenario: Lieferschein anlegen und erechok und erechmail aendern
Given I open an editor "lieferschein5" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "erechmail" to "email@abas.de"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "5" in row 1
And I set field "ueb" to "ja"
And I save the current editor
Then field "erechok" has value "ja"
Then field "erechmail" has value "email@abas.de"

# Lieferschein in Rechnung ueberfuehren
Given I open an editor "rechnung4" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein5"
And I set field "such" to "RECH4"
Then field "erechok" has value "ja"
Then field "erechmail" has value "email@abas.de"
And I respond with answer "Ja" to the dialog with id "4841" 
And I save the current editor

# Rechnungsempfaenger neu eintragen -> erechmail aus den Stammdaten
Given I open an editor "rechnung4" from table "(Sales):(Invoice)" with command "UPDATE" for record "RECH4"
And I set field "kl2" to id from editor "kunde"
And I save the current editor
Then field "erechok" has value "ja"
Then field "erechmail" has value "info@abas.de"

#####################################################################################################################

# Plausibilitaeten fuer ZUGFeRD

#####################################################################################################################

Scenario: Aktivieren der Konfiguration fuer ZUGFeRD
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "zugferd" to "1"
# Die Aktivierung von EDI ist Voraussetzung fuer ZUGFeRD.
And I set field "edi" to "ja"
And I save the current editor

Scenario: Zwei Rechnungen anlegen
Given I open an editor "zugferdRE1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set fields
 | nummer       | 1ZFRE |
 | such         | ZFRE1 |
 | vom          | .     |
 | ueb          | ja    |
 | zfdoctyp     | Vorauszahlungsrechnung |
 | zfpaymenttyp | Kartenzahlung |
 | zfduedatetyp | Ausstellungsdatum des Rechnungsbelegs |
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "21" in row 1
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 2
And I set field "mge" to "22" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "zugferdRE2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set fields
 | nummer       | 2ZFRE |
 | such         | ZFRE2 |
 | vom          | .     |
 | ueb          | ja    |
 | zfdoctyp     | Vorauszahlungsrechnung |
 | zfpaymenttyp | Kartenzahlung |
 | zfduedatetyp | Ausstellungsdatum des Rechnungsbelegs |
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 1
And I set field "mge" to "3" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Kopie von Rechnung 1 ohne die ZUGFeRD Spezifikationen zu uebernehmen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "COPY" for record "+1ZFRE"
And I set fields
 | nummer | 1ZFREKOP |
 | such   | KOPZFRE1 |
Then field "zfdoctyp" has value ""
Then field "zfpaymenttyp" has value ""
Then field "zfduedatetyp" has value ""
And I save the current editor

Scenario: Ruecklieferung (Retoure) von Rechnung 1 ohne die ZUGFeRD Spezifikationen zu uebernehmen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "RETURN" for record "+1ZFRE"
And I set fields
 | nummer | 1ZFRERET |
 | such   | RETZFRE1 |
Then field "zfdoctyp" has value ""
Then field "zfpaymenttyp" has value ""
Then field "zfduedatetyp" has value ""
And I set field "mge" to "-1" in row 1
And I save the current editor

Scenario: Storno von Rechnung 2 ohne die ZUGFeRD Spezifikationen zu uebernehmen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+2ZFRE"
And I set fields
 | nummer | 1ZFRESTO |
Then field "zfdoctyp" has value ""
Then field "zfpaymenttyp" has value ""
Then field "zfduedatetyp" has value ""
And I save the current editor
