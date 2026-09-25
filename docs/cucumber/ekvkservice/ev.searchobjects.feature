@include @persistent
Feature: Daten fuer SEARCHOBJECTS
Background:
Given I set the fake date to "02.01.1995"
Given I set saved value "REF_FILE" to "EV.SEARCHOBJECTS.CU.REF"
Given I set saved value "Feldliste" to "tbeleg,tbelegsuch,typ,vorgangsart,tkuli,tkuli2,tkuli3,vertret,spediteur"

Scenario Outline: STAMMDATEN - Kunden anlegen
Given I open an editor "<kunde>" from table "(Customer):(Customer)" with command "STORE" for record "<such>"
And I set fields
 | such     | <such>     |
 | namebspr | <namebspr> |
 | ans      | <ans>      |
 | str      | <str>      |
 | plz      | <plz>      |
 | nort     | <nort>     |
 | ustid    | <ustid>    |
 | lbed     | <lbed>     |
 | zbed     | <zbed>     |
 | vertret  | <vertret>  |
And I save the current editor
Examples:
 | kunde | such  | namebspr | ans      | str             | plz   | nort | ustid       | lbed | zbed | vertret |
 | maier | maier | Maier AG | Maier AG | Poststraße 1    | 77777 | Dorf | DE123456789 | EXW  | 200  | 4       |
 | bauer | bauer | Bauer KG | Bauer KG | Hauptstraße 2   | 55555 | Kaff | DE987456321 | EXW  | 201  | 4       |
 | kopp  | kopp  | Kopp OHG | Kopp OHG | Schlossstraße 3 | 66666 | Ort  | DE147852369 | exw  | 202  | 4       |

Scenario Outline: STAMMDATEN - Kundenkontakt anlegen
Given I open an editor "<kkontakt>" from table "(Customer):(CustomerContact)" with command "STORE" for record "<such>"
And I set fields
 | such     | <such>     |
 | firma    | <firma>    |
 | namebspr | <namebspr> |
And I save the current editor
Examples:
 | kkontakt | such   | firma | namebspr            |
 | k1maier  | maier1 | maier | Maier AG, Kontakt 1 |
 | k1bauer  | bauer1 | bauer | Bauer KG, Kontakt 1 |
 | k1kopp   | kopp1  | kopp  | Kopp OHG, Kontakt 1 |

Scenario Outline: STAMMDATEN - Interessenten anlegen
Given I open an editor "<interessent>" from table "(Customer):(Prospect)" with command "STORE" for record "<such>"
And I set fields
 | such     | <such>     |
 | namebspr | <namebspr> |
 | ans      | <ans>      |
 | str      | <str>      |
 | plz      | <plz>      |
 | nort     | <nort>     |
 | ustid    | <ustid>    |
 | lbed     | <lbed>     |
 | zbed     | <zbed>     |
And I save the current editor
Examples:
 | kunde  | such   | namebspr   | ans        | str             | plz   | nort  | ustid       | lbed | zbed |
 | kurz   | kurz   | Kurz AG    | Kurz AG    | Poststraße 4    | 77777 | IDorf | DE963214785 | EXW  | 200  |
 | lang   | lang   | Lang KG    | Lang KG    | Hauptstraße 5   | 55555 | IKaff | DE987412365 | EXW  | 201  |
 | mittel | mittel | Mittel OHG | Mittel OHG | Schlossstraße 6 | 66666 | IOrt  | DE852369741 | exw  | 202  |

Scenario Outline: STAMMDATEN - Interessentenkontakt anlegen
Given I open an editor "<Ikontakt>" from table "(Customer):(ProspectContact)" with command "STORE" for record "<such>"
And I set fields
 | such     | <such>     |
 | firma    | <firma>    |
 | namebspr | <namebspr> |
And I save the current editor
Examples:
 | kkontakt | such   | firma  | namebspr               |
 | k1kurz   | kurz1   | kurz   | Kurz AG, Kontakt 1    |
 | k1lang   | lang1   | lang   | Lang KG, Kontakt 1    |
 | k1mittel | mittel1 | mittel | Mittel OHG, Kontakt 1 |

Scenario Outline: STAMMDATEN - Lieferanten anlegen
Given I open an editor "<lieferant>" from table "(Vendor):(Vendor)" with command "STORE" for record "<such>"
And I set fields
 | such     | <such>     |
 | namebspr | <namebspr> |
 | ans      | <ans>      |
 | str      | <str>      |
 | plz      | <plz>      |
 | nort     | <nort>     |
 | ustid    | <ustid>    |
 | lbed     | <lbed>     |
 | zbed     | <zbed>     |
And I save the current editor
Examples:
 | lieferant | such    | namebspr   | ans       | str             | plz   | nort  | ustid       | lbed | zbed |
 | gold      | gold    | Gold AG    | Gold AG   | Poststraße 7    | 77777 | LDorf | DE123456789 | EXW  | 200  |
 | schwarz   | schwarz | Schwarz KG | Scharz KG | Hauptstraße 8   | 55555 | LKaff | DE987456321 | EXW  | 201  |
 | rot       | rot     | Rot OHG    | Rot OHG   | Schlossstraße 9 | 66666 | LOrt  | DE147852369 | EXW  | 202  |

Scenario Outline: STAMMDATEN - Lieferantenkontakt anlegen
Given I open an editor "<lkontakt>" from table "(Vendor):(VendorContact)" with command "STORE" for record "<such>"
And I set fields
 | such     | <such>     |
 | firma    | <firma>    |
 | namebspr | <namebspr> |
And I save the current editor
Examples:
 | kkontakt  | such     | firma   | namebspr              |
 | k1gold    | gold1    | gold    | Gold AG, Kontakt 1    |
 | k1schwarz | schwarz1 | schwarz | Schwarz KG, Kontakt 1 |
 | k1rot     | rot1     | rot     | Rot OHG, Kontakt 1    |

Scenario: STAMMDATEN - Ursache anlegen
Given I open an editor "ursache" from table "(ServiceRequest):(ServiceRequestCause)" with command "STORE" for record "unklar"
And I set field "such" to "unklar"
And I set field "bezbspr" to "Unklar"
And I save the current editor

Scenario: STAMMDATEN - Dienstleistung anlgen
Given I open an editor "dienstl" from table "(Part):(Service)" with command "STORE" for record "reparatur"
And I set field "such" to "reparatur"
And I set field "namebspr" to "reparatur"
And I set field "vpr" to "100"
And I save the current editor

Scenario: STAMMDATEN - Konsignationslagergruppe anlegen
Given I open an editor "Konsignationslg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "konsi"
And I set fields
    | such     | konsi                    |
    | namebspr | Konsignationslagergruppe |
    | zkonsilg | ja                       |
And I save the current editor

Scenario: STAMMDATEN - Konsignationslager anlegen
Given I open an editor "lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "konsi"
And I set field "such" to "konsi"
And I set field "namebspr" to "Konsignationslager"
And I set field "lgruppe" to id from editor "Konsignationslg"
And I save the current editor

Scenario: STAMMDATEN - Konsignationslagerplatz anlegen
Given I open an editor "lagerplatz" from table "(Location):(Location)" with command "STORE" for record "konsi"
And I set field "such" to "konsi"
And I set field "namebspr" to "Konsignationslagerplatz"
And I set field "lager" to id from editor "lager"
And I set field "lgruppe" to id from editor "Konsignationslg"
And I save the current editor

#Einkauf
Scenario: Ausschreibung anlegen
Given I open an editor "ausschreibung" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I append rows
 | tlief | artikel | mge |
 | gold  | e2      | 10  |
 | rot1  | e2      | 10  |
And I save the current editor

Scenario: Anfrage anlegen
Given I open an editor "anfrage1" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
 | lief | gold |
And I append rows
 | artex | mge |
 | e2    | 10  |
And I save the current editor

#Lieferrantenkontakt
Given I open an editor "anfrage2" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
 | lief | rot1 |
And I append rows
 | artex | mge |
 | e2    | 10  |
And I save the current editor

Scenario: Bestellvorschlaege anlegen
Given I open an editor "bestellvor" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
 | artex | lief | mge | preis |
 | e2    | gold | 10  | 10    |
 | e3    | rot1 | 10  | 10    |
And I save the current editor

Scenario: Umlagerungsvorschlaege anlegen
Given I open an editor "umlvor" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I append rows
 | artex | lief | mge | abplatz | platz  |
 | e2    | gold | 10  | F1      | L3F1   |
 | e3    | rot1 | 10  | F1      | L3F1   |
And I save the current editor

Scenario: Rahmenauftraege anlegen
Given I open an editor "ekrahmen1" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
 | lief | gold |
And I append rows
 | artex | mge | preis |
 | e2    | 100 | 5     |
And I save the current editor

#Rahmenauftrag fuer Lieferantenkontakt
Given I open an editor "ekrahmen2" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
 | lief | rot1 |
And I append rows
 | artex | mge | preis |
 | e2    | 100 | 6     |
And I save the current editor

Scenario: Bestellung anlegen
Given I open an editor "best1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
 | lief | gold |
And I append rows
 | artex | mge |
 | e2    | 10  |
And I save the current editor

#Bestellung mit Lieferantenkontakt anlegen
Given I open an editor "best2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
 | lief | rot1 |
And I append rows
 | artex | mge |
 | e2    | 10  |
And I save the current editor

Scenario: Lieferschein und Ruecklieferschein anlegen
Given I open an editor "eklief1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | lief   | gold         |
 | ebeleg | lieferschein |
 | vom    | .            |
 | ueb    | ja           |
And I append rows
 | artex | mge |
 | e2    | 10  |
And I save the current editor

#Lieferschein mit Lieferantenkontakt anlegen
Given I open an editor "eklief2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | lief   | rot1         |
 | ebeleg | lieferschein |
 | vom    | .            |
 | ueb    | ja           |
And I append rows
 | artex | mge |
 | e2    | 10  |
And I save the current editor

#Ruecklieferschein anlegen
Given I open an editor "ekrueck1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "eklief1"
And I set field "mge" to "-6" in row 1
And I save the current editor

Given I open an editor "ekrueck2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "eklief2"
And I set field "mge" to "-6" in row 1
And I save the current editor

Scenario: Rechnung und Gutschrift anlegen
Given I open an editor "ekrech1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
 | lief   | gold     |
 | ebeleg | rechnung |
 | vom    | .        |
And I append rows
 | artex | mge |
 | e2    | 10  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Rechnung fuer Gutschrift anleggen - muss gebucht werden
Given I open an editor "ekrech2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
 | lief   | gold     |
 | ebeleg | rechnung |
 | vom    | .        |
 | ueb    | ja       |
And I append rows
 | artex | mge |
 | e2    | 10  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Rechnung gutschreiben
Given I open an editor "ekgut" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ekrech2"
And I set field "ebeleg" to "gutschrift"
And I set field "vom" to "."
And I set field "mge" to "-10" in row 1
And I save the current editor

#Verkauf
Scenario: Angebte anlegen
Given I open an editor "angebot1" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
 | kunde | bauer |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Angebot mit Kundenkontakt anlegen
Given I open an editor "angebot2" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
 | kunde | kopp1 |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Angebot mit Interessent anlgen
Given I open an editor "angebot3" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
 | kunde | kurz |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

# Angebot mit Interssentenkontakt anlegen
Given I open an editor "angebot4" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
 | kunde | lang1 |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

Scenario: Chance anlegen
Given I open an editor "chance1" from table "(Sales):(Opportunity)" with command "NEW" for record ""
And I set fields
 | kunde | bauer |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Chance mit Kundenkontakt anlegen
Given I open an editor "chance2" from table "(Sales):(Opportunity)" with command "NEW" for record ""
And I set fields
 | kunde | kopp1 |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Chance mit Interessent anlegen
Given I open an editor "chance3" from table "(Sales):(Opportunity)" with command "NEW" for record ""
And I set fields
 | kunde | kurz |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Chance mit Interessentenkontakt anlegen
Given I open an editor "chance4" from table "(Sales):(Opportunity)" with command "NEW" for record ""
And I set fields
 | kunde | lang1 |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

Scenario: Webauftrag anlegen
Given I open an editor "web1" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I set fields
 | kunde | bauer |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Webauftrag mit Kundenkontakt anlegen
Given I open an editor "web2" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I set fields
 | kunde | kopp1 |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Webauftrag mit Interessent anlegen
Given I open an editor "web3" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I set fields
 | kunde | kurz |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Webauftrag mit Interessentenkontakt anlegen
Given I open an editor "web4" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I set fields
 | kunde | lang1 |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

Scenario: Serviceanfrage anlegen
Given I open an editor "serviceanfr1" from table "(ServiceRequest):(ServiceRequest)" with command "NEW" for record ""
And I set fields
 | such    | kunde  |
 | kunde   | bauer  |
 | ursache | unklar |
And I save the current editor

#Serviceanfrage mit Kundenkontakt anlegen
Given I open an editor "serviceanfr2" from table "(ServiceRequest):(ServiceRequest)" with command "NEW" for record ""
And I set fields
 | such    | kunde  |
 | kunde   | kopp1  |
 | ursache | unklar |
And I save the current editor

#Serviceanfrage mit Interessent anlegen
Given I open an editor "serviceanfr3" from table "(ServiceRequest):(ServiceRequest)" with command "NEW" for record ""
And I set fields
 | such    | kunde  |
 | kunde   | kurz   |
 | ursache | unklar |
And I save the current editor

#Serviceanfrage mit Interessentenkontakt anlegen
Given I open an editor "serviceanfr4" from table "(ServiceRequest):(ServiceRequest)" with command "NEW" for record ""
And I set fields
 | such    | kunde  |
 | kunde   | lang1  |
 | ursache | unklar |
And I save the current editor

Scenario: Serviceangebot anlegen
Given I open an editor "servicean1" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set fields
 | kunde | bauer |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Serviceangebot mit Kundenkontakt anlegen
Given I open an editor "servicean2" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set fields
 | kunde | kopp1 |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Serviceangebot mit Interessent anlegen
Given I open an editor "servicean3" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set fields
 | kunde | kurz |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Serviceangebot mit Interessentenkontakt anlegen
Given I open an editor "servicean4" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set fields
 | kunde | lang1 |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

Scenario: Serviceauftrag anlegen
Given I open an editor "serviceauf1" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
 | kunde | bauer |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Serviceauftrag mit Kundenkontakt anlegen
Given I open an editor "serviceauf2" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
 | kunde | kopp1 |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

Scenario: Reparaturauftrag und Kostenvoranschlag anlegen
Given I open an editor "repauftrag1" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set fields
 | kunde | bauer |
And I append rows
 | artex      | mge         |
 | v1         | !dontChange |
 | reparatur  | 1           |
And I press button "kostenvorb" to open a subeditor for "kva1"
And I save the current editor
And I switch the current editor to editor "repauftrag1"
And I save the current editor

#Reparaturauftrag mit Kundenkontakt anlegen
Given I open an editor "repauftrag2" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set fields
 | kunde | kopp1 |
And I append rows
 | artex      | mge         |
 | v1         | !dontChange |
 | reparatur  | 1           |
And I press button "kostenvorb" to open a subeditor for "kva2"
And I save the current editor
And I switch the current editor to editor "repauftrag2"
And I save the current editor

Scenario: Rahmenauftrag anlegen
Given I open an editor "vkrahmen1" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
 | kunde | bauer |
And I append rows
 | artex | mge | preis |
 | v1    | 100 | 10    |
And I save the current editor

#Rahmenauftrag mit Kundenkontakt anlegen
Given I open an editor "vkrahmen2" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
 | kunde | kopp1 |
And I append rows
 | artex | mge | preis |
 | v1    | 100 | 10    |
And I save the current editor

Scenario: Auftrag anlegen
Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
 | kunde | bauer |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Auftrag mit Kundenkontakt anlegen
Given I open an editor "auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
 | kunde | kopp1 |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

Scenario: Speditionsauftrag, Lieferschein, Rucklieferung und Kundenanlieferung anlegen
Given I open an editor "vklief1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | kunde | bauer |
 | ueb   | ja    |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Lieferschein mit Kundenkontakt anlegen
Given I open an editor "vklief2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | kunde | kopp1 |
 | ueb   | ja    |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
And I save the current editor

#Ruecklieferschein anlegen
Given I open an editor "vkrueck1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "vklief1"
And I set field "mge" to "-6" in row 1
And I save the current editor

#Ruecklieferschein mit Kundenkontakt anlegen
Given I open an editor "vkrueck2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "vklief2"
And I set field "mge" to "-6" in row 1
And I save the current editor

#Speditionsauftrag anlegen
Given I open an editor "sped1" from table "(ShipOrder):(ShippingOrder)" with command "NEW" for record ""
And I set fields
 | warenempf | bauer   |
 | spediteur | schwarz |
And I save the current editor

#Speditionsauftrag mit Kundenkontakt anlegen
Given I open an editor "sped2" from table "(ShipOrder):(ShippingOrder)" with command "NEW" for record ""
And I set fields
 | warenempf | kopp1 |
 | spediteur | gold1 |
And I save the current editor

#Kundenanlieferung anlegen
Given I open an editor "kundenan1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | lsart | Kundenanlieferung |
 | kunde | bauer             |
 | ueb   | ja                |
And I append rows
 | artex | mge | preis | platz |
 | v1    | -10 | 10    | konsi |
And I save the current editor

#Kundenanlieferung mit Kundenkontakt anlegen
Given I open an editor "kundenan1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | lsart | Kundenanlieferung |
 | kunde | kopp1             |
 | ueb   | ja                |
And I append rows
 | artex | mge | preis | platz |
 | v1    | -10 | 10    | konsi |
And I save the current editor

Scenario: Versandplanung anlegen
Given I open an editor "versand1" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
And I set fields
 | pstermvon | .     |
 | pstermbis | .     |
 | warenempf | bauer |
And I press button "ladetab"
And I save the current editor

#Versandplanung mit Kundenkontakt anlegen
Given I open an editor "versand2" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
And I set fields
 | pstermvon | .     |
 | pstermbis | .     |
 | warenempf | kopp1 |
And I press button "ladetab"
And I save the current editor

Scenario: Rechnung und Gutschrift anlegen
Given I open an editor "vkrech1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
 | kunde     | bauer |
 | spediteur | gold  |
And I append rows
 | artex | mge | preis |
 | v1    | 10  | 10    |
 And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Rechnung anlegen und buchen, um Gutschrift zu erzeugen
Given I open an editor "vkrech2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
 | kunde     | bauer |
 | spediteur | rot   |
 | ueb       | ja    |
And I append rows
 | artex | mge | preis | pros |
 | v1    | 10  | 10    | 10   |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Gutschrift anlegen
Given I open an editor "vkgut" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "vkrech2"
And I set field "mge" to "-1" in row 1
And I save the current editor

#Verkauf
Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde MAIER
Given I open the infosystem "SEARCHOBJECTS"
And I set field "kkl" to "K MAIER"
And I press start
Then the table has 26 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde BAUER
Given I open the infosystem "SEARCHOBJECTS"
And I set field "kkl" to "K BAUER"
And I press start
Then the table has 17 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde KOPP
Given I open the infosystem "SEARCHOBJECTS"
And I set field "kkl" to "K KOPP"
And I press start
Then the table has 12 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde MAIER1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "kkl" to "K MAIER1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde BAUER1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "kkl" to "K BAUER1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde KOPP1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "kkl" to "K KOPP1"
And I press start
Then the table has 15 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde KURZ
Given I open the infosystem "SEARCHOBJECTS"
And I set field "kkl" to "K KURZ"
And I press start
Then the table has 5 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde MITTEL
Given I open the infosystem "SEARCHOBJECTS"
And I set field "kkl" to "K MITTEL"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde LANG
Given I open the infosystem "SEARCHOBJECTS"
And I set field "kkl" to "K LANG"
And I press start
Then the table has 4 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde KURZ1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "kkl" to "K KURZ1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde MITTEL1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "kkl" to "K MITTEL1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde LANG1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "kkl" to "K LANG1"
And I press start
Then the table has 5 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

#Einkauf
Scenario:  Infosystem SEARCHOBJECTS starten mit Lieferant GOLD
Given I open the infosystem "SEARCHOBJECTS"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L GOLD"
And I press start
Then the table has 11 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Lieferant SCHWARZ
Given I open the infosystem "SEARCHOBJECTS"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L SCHWARZ"
And I press start
Then the table has 1 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Lieferant ROT
Given I open the infosystem "SEARCHOBJECTS"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L ROT"
And I press start
Then the table has 7 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Lieferant GOLD1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L GOLD1"
And I press start
Then the table has 1 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Lieferant SCHWARZ1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L SCHWARZ1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Lieferant ROT1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L ROT1"
And I press start
Then the table has 8 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

#Verkauf
#Ablageart=abgelegt
Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde MAIER
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "kkl" to "K MAIER"
And I press start
Then the table has 1 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde BAUER
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "kkl" to "K BAUER"
And I press start
Then the table has 1 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde KOPP
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "kkl" to "K KOPP"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde MAIER1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "kkl" to "K MAIER1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde BAUER1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "kkl" to "K BAUER1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde KOPP1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "kkl" to "K KOPP1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde KURZ
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "kkl" to "K KURZ"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde MITTEL
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "kkl" to "K MITTEL"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde LANG
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "kkl" to "K LANG"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde KURZ1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "kkl" to "K KURZ1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde MITTEL1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "kkl" to "K MITTEL1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Kunde LANG1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "kkl" to "K LANG1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

#Einkauf
Scenario:  Infosystem SEARCHOBJECTS starten mit Lieferant GOLD
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L GOLD"
And I press start
Then the table has 1 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Lieferant SCHWARZ
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L SCHWARZ"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Lieferant ROT
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L ROT"
And I press start
Then the table has 1 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Lieferant GOLD1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L GOLD1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Lieferant SCHWARZ1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L SCHWARZ1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem SEARCHOBJECTS starten mit Lieferant ROT1
Given I open the infosystem "SEARCHOBJECTS"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "abgelegt"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L ROT1"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
