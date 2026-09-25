# *****************************************************************************************
#  Name           : leitwegid.feature
#  Autor          : foe
#  Verantwortlich : foe
#  Kontrolle      : dago
#  Funktion       : Test fuer das Feld (kl)/(ev)leitwegid
#  Beschreibung   :
#  Testet das Feld (kl)/(ev)leitwegid, das die Leitweg-ID enthaelt, aus
#  den Stammdaten uebernommen und ueber die Vorgangskette
#  weitergegeben wird.
#
# *****************************************************************************************
#
@persistent
Feature: Test zum Feld (kl)/(ev)leitwegid in den Stammdaten und im Ein- und Verkauf
Background:
Given I set the fake date to "02.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario: Interessent mit Kontakten anlegen
# ----------------------------------------------------------------------------------------------

# Interessent anlegen
Given I open an editor "Interessent-1" from table "(Customer):(Prospect)" with command "NEW" for record ""
And I set fields
	| such      | inter1                  |
	| name      | Testinteressent         |
	| leitwegid | 09025354-1234567890-00  |
And I save the current editor

# Sachbearbeiter 1 zu Interessent anlegen
Given I open an editor "Interessentenkontakt1" from table "(Customer):(ProspectContact)" with command "NEW" for record ""
And I set fields
	| firma     | inter1                  |
	| such      | INTSB1                  |
And I save the current editor

# Kunde anlegen
Given I open an editor "Kunde-1" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
	| such      | KUNDE                  |
	| namebspr  | John Wayne & Co        |
	| str       | Mullholand Drive 1232  |
	| nort      | Hollywood              |
	| staat     | USA                    |
	| mwaehr    | USD                    |
	| leitwegid | 11111111-1234567890-12 |
And I save the current editor

# Kundenkontakt zum Kunde anlegen
Given I open an editor "Kundenkontakt-2" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
And I set fields
	| firma     | KUNDE                  |
	| such      | MILLER                 |
And I save the current editor

# 2. Kunde anlegen
Given I open an editor "Kunde-2" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
	| such      | KUNDE2                 |
	| namebspr  | Peter Hermann          |
	| str       | Schillerstrasse 19     |
	| nort      | Lünen                  |
	| staat     | Deutschland            |
	| leitwegid | 22222222-1234567890-12 |
And I save the current editor

# Lieferant anlegen
Given I open an editor "Lieferant-1" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
	| such      | LIEF                   |
	| namebspr  | Schreinerei Maier      |
	| str       | Fuggerpark 89          |
	| nort      | Augsburg               |
	| staat     | Deutschland            |
	| leitwegid | 33333333-1234567890-12 |
And I save the current editor

# Lieferantenkontakt anlegen
Given I open an editor "Lieferantenkontakt-2" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
And I set fields
	| firma     | LIEF                    |
	| such      | SCHULZ                  |
And I save the current editor

# 2. Lieferant anlegen
Given I open an editor "Lieferant-2" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
	| such      | LIEF2                  |
	| namebspr  | Kleinschmidt GmbH      |
	| str       | Heineweg 32            |
	| nort      | Essen                  |
	| staat     | Deutschland            |
	| leitwegid | 44444444-1234567890-12 |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung zu Lieferantenkontakt erzeugen
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-1K" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief      | SCHULZ |
   | such      | BE-1K  |
Then field "leitwegid" has value "33333333-1234567890-12"
When I create a new row at the end of the table
And I set field "artex" to "E1" in row 1
And I set field "mge" to "1" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Anfrage zu Lieferant erzeugen
#----------------------------------------------------------------------------------------------
Given I open an editor "ANF-01" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
   | lief      | LIEF    |
   | such      | ANF-01  |
And I set field "leitwegid" to "55555555-1234567890-55"
When I create a new row at the end of the table
And I set field "artex" to "E1" in row 1
And I set field "mge" to "1" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung aus Anfrage
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-01" from table "(Purchasing):(Request)" with command "RELEASE" for record from editor "ANF-01"
And I set fields
   | nummer  | 01BE    |
   | such    | BE-01   |
Then field "leitwegid" has value "55555555-1234567890-55"
And I set field "mge" to "10" in row 1
And I set field "leitwegid" to "09025105-1234567890-12"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Lieferschein aus Bestellung
#----------------------------------------------------------------------------------------------
Given I open an editor "LS-01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE-01"
And I set fields
   | nummer  | 01LS    |
   | such    | LS-01   |
   | vom     | .       |
   | ueb     | ja      |
And I set field "mge" to "10" in row 1
Then field "leitwegid" has value "09025105-1234567890-12"
And I set field "leitwegid" to "12121212-1212121212-12"
And I set field "mge" to "10" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Rechnung aus Lieferschein
#----------------------------------------------------------------------------------------------
Given I open an editor "RE-01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS-01"
And I set fields
   | nummer  | 01RE    |
   | ebeleg  | 01RE    |
   | such    | RE-01   |
   | vom     | .       |
   | tterm   | .       |
And I set field "mge" to "10" in row 1
Then field "leitwegid" has value "12121212-1212121212-12"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Rahmenauftrag zu Lieferant erzeugen
#----------------------------------------------------------------------------------------------
Given I open an editor "RA-01" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 01RA    |
   | lief    | LIEF2   |
   | such    | RA-01   |
Then field "leitwegid" has value "44444444-1234567890-12"
And I set field "leitwegid" to "01010101-010101010101-01"
When I create a new row at the end of the table
And I set field "artex" to "E1" in row 1
And I set field "mge" to "200" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung aus Rahmenauftrag
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-01-2" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record from editor "RA-01"
And I set fields
   | nummer  | 01BE2   |
   | such    | BE-01-2 |
And I set field "mge" to "10" in row 1
Then field "leitwegid" has value "01010101-010101010101-01"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Lieferschein zu Kundenkontakt erzeugen
#----------------------------------------------------------------------------------------------
Given I open an editor "LS-1K" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde     | MILLER |
   | such      | BE-1K  |
Then field "leitwegid" has value "11111111-1234567890-12"
When I create a new row at the end of the table
And I set field "artex" to "E1" in row 1
And I set field "mge" to "1" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Angebot zu Interessentenkontakt erzeugen
#----------------------------------------------------------------------------------------------
Given I open an editor "ANG-1I" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
   | nummer    | 1IANG    |
   | kunde     | INTSB1   |
   | such      | ANG-1I   |
Then field "leitwegid" has value "09025354-1234567890-00"
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "20" in row 1
And I set field "reempf" to "KUNDE2"
Then field "leitwegid" has value "22222222-1234567890-12"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Angebot zu Kunden erzeugen
#----------------------------------------------------------------------------------------------
Given I open an editor "ANG-01" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
   | nummer    | 01ANG    |
   | kunde     | KUNDE    |
   | such      | ANG-01   |
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "20" in row 1
Then field "leitwegid" has value "11111111-1234567890-12"
And I set field "leitwegid" to "56756756-5675675675-56"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag aus Angebot
#----------------------------------------------------------------------------------------------
Given I open an editor "AU-01" from table "(Sales):(Quotation)" with command "RELEASE" for record from editor "ANG-01"
And I set fields
   | nummer  | 01AU    |
   | such    | AU-01   |
And I set field "mge" to "20" in row 1
Then field "leitwegid" has value "56756756-5675675675-56"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Lieferschein aus Auftrag
#----------------------------------------------------------------------------------------------
Given I open an editor "LS-01" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU-01"
And I set fields
   | nummer  | 01LS    |
   | such    | LS-01   |
   | ueb     | ja      |
And I set field "mge" to "20" in row 1
Then field "leitwegid" has value "56756756-5675675675-56"
And I set field "leitwegid" to "12121212-1212121212-12"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Rechnung aus Lieferschein
#----------------------------------------------------------------------------------------------
Given I open an editor "RE-01" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS-01"
And I set fields
   | nummer  | 01RE    |
   | such    | RE-01   |
   | tterm   | .       |
   | budat   | .       |
   | ueb     | ja      |
And I set field "mge" to "20" in row 1
Then field "leitwegid" has value "12121212-1212121212-12"
Then field "leitwegid" is modifiable
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift aus Rechnung
#----------------------------------------------------------------------------------------------
Given I open an editor "WG-01" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE-01"
And I set fields
   | nummer  | 01WG    |
   | such    | WG-01   |
   | tterm   | .       |
   | budat   | .       |
   | ueb     | ja      |
And I set field "mge" to "-10" in row 1
Then field "leitwegid" has value "12121212-1212121212-12"
Then field "leitwegid" is not modifiable
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Ruecklieferschein
#----------------------------------------------------------------------------------------------
Given I open an editor "RLS-01" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS-01"
And I set fields
   | nummer  | 01RLS   |
   | such    | RLS-01  |
   | tterm   | .       |
   | budat   | .       |
   | ueb     | ja      |
And I set field "mge" to "-10" in row 1
Then field "leitwegid" has value "12121212-1212121212-12"
Then field "leitwegid" is not modifiable
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Kaufmaennische Gutschrift
#----------------------------------------------------------------------------------------------
Given I open an editor "KGS-01" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS-01"
And I set fields
   | nummer  | 01KGS   |
   | such    | KGS-01  |
   | tterm   | .       |
   | budat   | .       |
And I set field "mge" to "-10" in row 1
Then field "leitwegid" has value "12121212-1212121212-12"
Then field "leitwegid" is not modifiable
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Rahmenauftrag zu Kunden erzeugen
#----------------------------------------------------------------------------------------------
Given I open an editor "RA-01" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 01RA    |
   | kunde   | KUNDE   |
   | such    | RA-01   |
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "20" in row 1
Then field "leitwegid" has value "11111111-1234567890-12"
And I set field "leitwegid" to "12312312-1231231231-12"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag aus Rahmenauftrag
#----------------------------------------------------------------------------------------------
Given I open an editor "AU-01" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record from editor "RA-01"
And I set fields
   | nummer  | 01AU2   |
   | such    | AU-01-1 |
And I set field "mge" to "20" in row 1
Then field "leitwegid" has value "12312312-1231231231-12"
And I save the current editor
