# *****************************************************************************
#  Name           : intrastatzentrale_wgs.feature
#  Autor          : cl
#  Verantwortlich : cl
#  Kontrolle      : teaminfosysteme
#  Funktion       : Cucumber Tests fuer Intrastatzentrale mit Wertgutschriften
#
# *****************************************************************************
#
@persistent
Feature: Wertgutschrift und Rechnungskorrektur fuer EK und VK zu ungemeldeten Rechnungen
Background:
Given I set the fake date to "02.02.1996"
Given I set saved value "REF_FILE" to "SK.INTRASTATZENTRALE.WGS.CU.REF"
Given I set saved value "Feldliste1" to "vorgang"

#Verkauf
###############################################################################################################################################################################
#Fall 1: Rechnung, auf die sich die Wertgutschrift bezieht, ist noch NICHT gemeldet
###############################################################################################################################################################################
#########
#Fall 1a: Gibt es eine 100% Wertgutschrift aber noch keine Rechnungskorrektur, darf die urspr. Rechnung noch nicht gemeldet werden. Es wird weder Re, noch WGS angezeigt!
#########

Scenario: Auftrag mit zwei Positionen anlegen, daraus LS erstellen und dann Rechnung erstellen
Given I open an editor "AUF1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "70002"
And I set field "vom" to "."
And I create a new row at the end of the table
# Artikel1
And I set field "artex" to "ARTIKEL1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
# Artikel2
And I set field "artex" to "ARTIKEL2" in row 2
And I set field "mge" to "5" in row 2
And I save the current editor

Scenario: Lieferschein 1 aus Auftrag 1 erzeugen (ueber Beleg anfuegen)
Given I open an editor "LS1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AUF1"
And I set field "vom" to "."
Then the table has 2 rows
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

Scenario: Rechnung1 aus Lieferschein1 erzeugen (ueber Beleg anfuegen) -> 4RE010
Given I open an editor "RE1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS1"
And I set field "such" to "RE1LS1"
And I set field "nummer" to "4RE010"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Infosystem INTRASTATZENTRALE 1. mal aufrufen. Es erscheint nur die Rechnung +4RE010
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.1996"
And I set field "datumbis" to "28.2.1996"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

Scenario: 1. Komplettwertgutschrift zu 1. Rechnung erstellen und buchen -> +4WGS011
Given I open an editor "WGS1" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1"
And I set fields
    | such   | WGSAUSRE1  |
    | nummer | 4WGS011    |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I press button "komplettieren"
Then table has values
    | mge   | preis       | pwert      |
    | -10   | 5112.92     | -51129.20  |
    | -5    | 4601.63     | -23008.15  |
And I save the current editor

Scenario: Infosystem INTRASTATZENTRALE 2. mal aufrufen. Es gibt nichts zu melden.
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.1996"
And I set field "datumbis" to "28.2.1996"
Then pressing button "bstart" in row 0 throws the exception "3981"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

#########
#Fall 1b: Wurde die Rechnung noch nicht gemeldet und es wurde eine 100% Wertgutschrift und eine RE-Korrektur erstellt , wird nur die Rechnungskorrektur uebernommen und nicht die Originalrechnung.
#########

Scenario: 2. Auftrag mit zwei Positionen anlegen, daraus 2. LS erstellen und dann 2. Rechnung erstellen
Given I open an editor "AUF2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "70002"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "ARTIKEL1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artex" to "ARTIKEL2" in row 2
And I set field "mge" to "5" in row 2
And I save the current editor

Scenario: 2. Lieferschein aus 2. Auftrag erzeugen (ueber Beleg anfuegen)
Given I open an editor "LS2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AUF2"
And I set field "vom" to "."
Then the table has 2 rows
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

Scenario: 2. Rechnung aus 2. Lieferschein erzeugen und buchen (ueber Beleg anfuegen) -> +4RE012
Given I open an editor "RE2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS2"
And I set field "such" to "RE2LS2"
And I set field "nummer" to "4RE012"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: 2. 100% Wertgutschrift zu Rechnung2 erstellen und buchen -> +4WGS013
Given I open an editor "WGS2" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE2"
And I set field "such" to "WGS2RE2"
And I set field "nummer" to "4WGS013"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "budat" to "."
And I set field "vom" to "."
And I press button "komplettieren"
And I save the current editor

Scenario: 1. Rechnungskorrektur aus 2. LS anlegen und buchen -> +4REK014
Given I open an editor "REKORR1" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS2"
And I set fields
    | such   | REKORR1     |
    | nummer | 4REK014     |
    | tterm  | .           |
    | budat  | .           |
    | vom    | .           |
    | ueb    | ja          |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "4000" in row 1
Then field "rekorrektur" has value "ja" in row 2
And I set field "mge" to "5" in row 2
And I set field "preis" to "4000" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: INTRASTATZENTRALE das 3. mal aufrufen. Es erscheint nur die Rechnungskorrektur 4REK014 im Infosystem, nicht aber die urspr. Rechnung +400012 und nicht die WGS +400013
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.1996"
And I set field "datumbis" to "28.2.1996"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

#########
#Fall 1c: Wurde eine Rechnung noch nicht gemeldet und es wurde eine Teilwertgutschrift erstellt, so erscheint nur die Rechnung in der Intrastatzentrale
#########
Scenario: 3. Auftrag mit zwei Positionen anlegen, daraus 3. LS erstellen und dann 3. Rechnung erstellen
Given I open an editor "AUF3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "70002"
And I set field "vom" to "."
And I create a new row at the end of the table
# Artikel1
And I set field "artex" to "ARTIKEL1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
# Artikel2
And I set field "artex" to "ARTIKEL2" in row 2
And I set field "mge" to "5" in row 2
And I save the current editor

Scenario: 3. Lieferschein aus 3. Auftrag erzeugen (ueber Beleg anfuegen)
Given I open an editor "LS3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AUF3"
And I set field "vom" to "."
Then the table has 2 rows
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

Scenario: 3. Rechnung aus 3. Lieferschein erzeugen und buchen (ueber Beleg anfuegen) -> +4RE015
Given I open an editor "RE3" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS3"
And I set field "such" to "RE3LS3"
And I set field "nummer" to "4RE015"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: 1. Teil-Wertgutschrift zu Re erstellen und buchen -> +4TWG016
Given I open an editor "TWGS1" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE3"
And I set field "such" to "TWGS1RE3"
And I set field "nummer" to "4TWG016"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-2" in row 2
And I save the current editor

Scenario: Infosystem INTRASTATZENTRALE das 4. mal aufrufen. Es erscheinen nur der vorigen Vorgang (Rechnungskorrektur +4REK014) und die Rechnung 4RE015, keine TWGS
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.1996"
And I set field "datumbis" to "28.2.1996"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

#########
# Fall 1d: Wurde eine Rechnung noch nicht gemeldet und es wurde eine Teilwertgutschrift erstellt über die Menge, nicht den Preis, so erscheint nur die Rechnung in der Intrastatzentrale
#########
Scenario: 4. Auftrag mit zwei Positionen anlegen, daraus 4. LS erstellen und dann 4. Rechnung erstellen
Given I open an editor "AUF4" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "70002"
And I set field "vom" to "."
And I create a new row at the end of the table
# Artikel1
And I set field "artex" to "ARTIKEL1" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "10" in row 1
And I create a new row at the end of the table
# Artikel2
And I set field "artex" to "ARTIKEL2" in row 2
And I set field "mge" to "5" in row 2
And I set field "preis" to "10" in row 2
And I save the current editor

Scenario: 4. Lieferschein aus 4. Auftrag erzeugen (ueber Beleg anfuegen)
Given I open an editor "LS4" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AUF4"
And I set field "vom" to "."
Then the table has 2 rows
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

Scenario: 4. Rechnung aus 4. Lieferschein erzeugen und buchen (ueber Beleg anfuegen) -> +4RE016
Given I open an editor "RE4" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS4"
And I set field "such" to "RE3LS4"
And I set field "nummer" to "4RE016"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Wertgutschrift zu Re erstellen mit voller Menge und Teil preis und buchen -> +4TWG017
Given I open an editor "TWGS2" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE3"
And I set field "such" to "TWGS1RE3"
And I set field "nummer" to "4TWG017"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "mge" to "-10" in row 1
And I set field "preis" to "1" in row 1
And I set field "mge" to "-5" in row 2
And I set field "preis" to "1" in row 2
And I save the current editor

Scenario: Infosystem INTRASTATZENTRALE das 5. mal aufrufen. Es erscheinen die vorigen und +4RE016
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.1996"
And I set field "datumbis" to "28.2.1996"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

##########
# Einkauf
##########
# Fall 1a: Gibt es eine 100% Wertgutschrift aber noch keine Rechnungskorrektur, darf die urspr. Rechnung noch nicht gemeldet werden. Es wird weder Re, noch WGS angezeigt!
##########
Scenario: Bestellung mit zwei Positionen anlegen, daraus LS erstellen und dann Rechnung erstellen
Given I open an editor "BE1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "60001"
And I set field "vom" to "."
And I create a new row at the end of the table
# Artikel1
And I set field "artex" to "ARTIKEL1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
# Artikel2
And I set field "artex" to "ARTIKEL2" in row 2
And I set field "mge" to "5" in row 2
And I save the current editor

Scenario: Lieferschein 1 aus Bestellung 1 erzeugen (ueber Beleg anfuegen)
Given I open an editor "LS1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE1"
And I set field "nummer" to "3LS1E"
And I set field "vom" to "."
Then the table has 2 rows
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

Scenario: Rechnung1 aus Lieferschein1 erzeugen (ueber Beleg anfuegen) -> 4RE010
Given I open an editor "RE1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS1"
And I set field "such" to "RE1LS1E"
And I set field "nummer" to "4RE010E"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: 1. Komplettwertgutschrift zu 1. Rechnung erstellen und buchen -> +4WGS011E
Given I open an editor "WGS1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1"
And I set fields
    | such   | WGS011E    |
    | nummer | 4WGS011E   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I press button "komplettieren"
Then table has values
    | mge   | preis       | pwert      |
    | -10   | 9000.00     | -90000.00  |
    | -5    | 7000.00     | -35000.00  |
And I save the current editor

Scenario: Infosystem INTRASTATZENTRALE 6. mal aufrufen. Es gibt nichts zu melden. Nur die vorigen aus dem Verkauf
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.1996"
And I set field "datumbis" to "28.2.1996"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

##########
# Fall 1b: Wurde die Rechnung noch nicht gemeldet und es wurde eine 100% Wertgutschrift und eine RE-Korrektur erstellt, wird nur die Rechnungskorrektur uebernommen und nicht die Originalrechnung.
##########
Scenario: 2. Bestellung mit zwei Positionen anlegen, daraus 2. LS erstellen und dann 2. Rechnung erstellen
Given I open an editor "BE2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "60001"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "ARTIKEL1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artex" to "ARTIKEL2" in row 2
And I set field "mge" to "5" in row 2
And I save the current editor

Scenario: 2. Lieferschein aus 2. Auftrag erzeugen (ueber Beleg anfuegen)
Given I open an editor "LS2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE2"
And I set field "nummer" to "3LS2E"
And I set field "vom" to "."
Then the table has 2 rows
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

Scenario: 2. Rechnung aus 2. Lieferschein erzeugen und buchen (ueber Beleg anfuegen) -> +4RE012E
Given I open an editor "RE2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS2"
And I set field "such" to "RE2LS2E"
And I set field "nummer" to "4RE012E"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: 2. Komplettwertgutschrift zu Rechnung2 erstellen und buchen -> +4WGS013E
Given I open an editor "WGS2" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE2"
And I set field "such" to "WGS2RE2E"
And I set field "nummer" to "4WGS013E"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "budat" to "."
And I set field "vom" to "."
And I press button "komplettieren"
And I save the current editor

Scenario: 1. Rechnungskorrektur aus 2. LS anlegen und buchen -> +4REK014E
Given I open an editor "REKORR1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS2"
And I set fields
    | such   | REKORR1E   |
    | nummer | 4REK014E   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "4000" in row 1
Then field "rekorrektur" has value "ja" in row 2
And I set field "mge" to "5" in row 2
And I set field "preis" to "4000" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: INTRASTATZENTRALE das 7. mal aufrufen. Es erscheinen die 3 vorigen und nur die Rechnungskorrektur 4REK014E im Infosystem, nicht aber die urspr. Rechnung +400012 und nicht die WGS +400013
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.1996"
And I set field "datumbis" to "28.2.1996"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"

And I close the current editor

##########
# Fall 1c: Wurde eine Rechnung noch nicht gemeldet und es wurde eine Teilwertgutschrift erstellt, so erscheint nur die Rechnung in der Intrastatzentrale
##########
Scenario: 3. Bestellung mit zwei Positionen anlegen, daraus 3. LS erstellen und dann 3. Rechnung erstellen
Given I open an editor "BE3" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "60001"
And I set field "vom" to "."
And I create a new row at the end of the table
# Artikel1
And I set field "artex" to "ARTIKEL1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
# Artikel2
And I set field "artex" to "ARTIKEL2" in row 2
And I set field "mge" to "5" in row 2
And I save the current editor

Scenario: 3. Lieferschein aus 3. Bestellung erzeugen (ueber Beleg anfuegen)
Given I open an editor "LS3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE3"
And I set field "nummer" to "3LS3E"
And I set field "vom" to "."
Then the table has 2 rows
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

Scenario: 3. Rechnung aus 3. Lieferschein erzeugen und buchen (ueber Beleg anfuegen) -> +4RE015E
Given I open an editor "RE3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS3"
And I set field "such" to "RE3LS3E"
And I set field "nummer" to "4RE015E"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: 1. Teil-Wertgutschrift zu Re erstellen und buchen -> +4TWG016E
Given I open an editor "TWGS1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE3"
And I set field "such" to "TWGS016E"
And I set field "nummer" to "4TWG016E"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-2" in row 2
And I save the current editor

Scenario: Infosystem INTRASTATZENTRALE das 8. mal aufrufen. Es erscheinen nur die vorigen Vorgaenge und die Rechnung 4RE015E, keine TWGS
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.1996"
And I set field "datumbis" to "28.2.1996"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

##########
# Fall 1d: Wurde eine Rechnung noch nicht gemeldet und es wurde eine Teilwertgutschrift erstellt mit komplett gutgeschriebener Menge aber nicht kompletten Preis, so erscheint nur die Rechnung in der Intrastatzentrale
##########
Scenario: 4. Bestellung mit zwei Positionen anlegen, daraus 3. LS erstellen und dann 3. Rechnung erstellen
Given I open an editor "BE4" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "60001"
And I set field "vom" to "."
And I create a new row at the end of the table
# Artikel1
And I set field "artex" to "ARTIKEL1" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "10" in row 1
And I create a new row at the end of the table
# Artikel2
And I set field "artex" to "ARTIKEL2" in row 2
And I set field "mge" to "5" in row 2
And I set field "preis" to "10" in row 2
And I save the current editor

Scenario: 4. Lieferschein aus 4. Bestellung erzeugen (ueber Beleg anfuegen)
Given I open an editor "LS4" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE4"
And I set field "nummer" to "4LS4E"
And I set field "vom" to "."
Then the table has 2 rows
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

Scenario: 4. Rechnung aus 4. Lieferschein erzeugen und buchen (ueber Beleg anfuegen) -> +4RE016E
Given I open an editor "RE4" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS4"
And I set field "such" to "RE4LS4E"
And I set field "nummer" to "4RE016E"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: 1. Teil-Wertgutschrift zu Re erstellen mit gelicher Menge und unterschiedlichem preis und buchen -> +4TWG016E
Given I open an editor "TWGS1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE3"
And I set field "such" to "TWGS016E"
And I set field "nummer" to "4TWG01E"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "mge" to "-10" in row 1
And I set field "preis" to "1" in row 1
And I set field "mge" to "-5" in row 2
And I set field "preis" to "1" in row 1
And I save the current editor

Scenario: Infosystem INTRASTATZENTRALE das 9. mal aufrufen. Es erscheinen nur die vorigen Vorgaenge und die Rechnung 4RE016E, keine TWGS
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.1996"
And I set field "datumbis" to "28.2.1996"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor
