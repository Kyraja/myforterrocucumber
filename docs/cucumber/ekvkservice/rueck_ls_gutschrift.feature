# *****************************************************************************
#  Name           : rueck_ls_gutschrift.feature
#  Autor          : dago
#  Verantwortlich : teampss
#  Funktion       : Ruecklieferungen ausfuehren und mit kaufmaennischer Gutschrift begleichen. (EK/VK)
#
# *****************************************************************************
#
@persistent
Feature: Gutschrift
Background: Test von Rechnung der Art "kaufmännischen Gutschrift" bzw. "Gutschrift" im Verkauf
Given I set the fake date to "02.01.1995"

################################################################################
# S T A M M D A T E N
################################################################################

@Testdaten
Scenario: STAMMDATEN - Neuen Kunden anlegen
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
And I save the current editor
Then field "name" has value "Bayram Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

Scenario: STAMMDATEN - Neuen Lieferanten anlegen
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "REUS"
And I set field "such" to "REUS"
And I set field "namebspr" to "Reus Werkzeugbau, Rastatt"
And I set field "ans" to "Reus Werkzeugbau GmbH"
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
And I save the current editor
Then field "name" has value "Reus Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

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
And I set field "lief" to "<lief>"
And I set field "epr" to "<epr>"
And I set field "efrist" to "<efrist>"
And I save the current editor

Examples: Artikel
 |such     |namebspr  |vkbez     |vbez      |ebez      |vpr   |bsart            |dispoa         |lief |epr  |efrist |
 |artikel1 |Artikel 1 |Artikel 1 |Artikel 1 |Artikel 1 |10000 |Fremdbeschaffung |bedarfsbezogen |reus |9000 |15 |
 |artikel2 |Artikel 2 |Artikel 2 |Artikel 2 |Artikel 2 | 9000 |Fremdbeschaffung |bedarfsbezogen |reus |7000 |10 |
 |artikel3 |Artikel 3 |Artikel 3 |Artikel 3 |Artikel 3 | 8000 |Fremdbeschaffung |bedarfsbezogen |reus |6000 | 5 |

Scenario Outline: STAMMDATEN - Zusatzposition vom Typ AU/BE anlegen
Given I open an editor "<zusatzpos>" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "epr" to "<epr>"
And I save the current editor

Examples: Artikel
|zusatzpos   | such   | namebspr             | zptyp             | vkbez                | vbez                 | ebez                 | vpr         | epr         |
|zusatzAUBE  | AUBE   | Zusatzposition AU/BE | AU/BE-Position,BV | Zusatzposition AU/BE | Zusatzposition AU/BE | Zusatzposition AU/BE | 1100        | 1000        |
|neutralePOS | NEUPOS | Neutrale Position    | Neutrale Position | Neutrale Position    | Neutrale Position    | Neutrale Position    | 500         | 400         |
|textPOS     | TXTPOS | Textposition         | Text              | Textposition         | Textposition         | Textposition         | !dontChange | !dontChange |

Scenario Outline: STAMMDATEN - Dienstleistungen anlegen
Given I open an editor "<dienstleistung>" from table "(Part):(Service)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vpr" to "<preis>"
And I set field "vpe" to "h"
And I set field "vhe" to "h"
And I save the current editor

Examples: Dienstleistungen
| dienstleistung | such         | namebspr     | preis |
| hdienstl       | DL-ANALYSE   | Analyse in h | 10.00 |

Scenario: STAMMDATEN - Artikel anlegen mit Handelseinheit ungleich Lagereinheit
Given I open an editor "1FB" from table "(Part):(Product)" with command "STORE" for record "1FB"
And I set field "nummer" to "1FB"
And I set field "such" to "FB1"
And I set field "namebspr" to "FB1"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I save the current editor

Scenario: EK - Lagerbestand: Bestellung -> LS
Given I open an editor "bestellung1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel1" in row 1
And I set field "mge" to "120" in row 1
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel2" in row 2
And I set field "mge" to "120" in row 2
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel3" in row 3
And I set field "mge" to "120" in row 3
And I save the current editor

Given I open an editor "eklieferschein1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung1"
And I set field "such" to "ekls1"
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EKLieferschein1"
And I set field "vom" to "."
And I set field "mge" to "120" in row 1
And I set field "mge" to "120" in row 2
And I set field "mge" to "120" in row 3
And I save the current editor

#---------------------------------------------------------------------------------------------
Scenario: BE -> LS -> RE (Pauschalpreis) -> RLS (andere Waehrung, andere Einheit) -> KGS
#         Pauschalpreis wird aus der Rechnung entnommen. Waehrung und Einheit aendern sich.
#----------------------------------------------------------------------------------------------

# Bestellung anlegen
Given I open an editor "BE13" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1     |
   | nummer | 13-BE |
   | such   | BE13  |
And I create a new row at the end of the table
And I set field "artex" to "FB1" in row 1
And I set field "mge" to "13" in row 1
And I set field "preis" to "0" in row 1
And I set field "pwert" to "1300" in row 1
And I save the current editor

# Lieferschein
Given I open an editor "EKLS13" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE13"
And I set fields
   | nummer | 13-EKLS |
   | such   | LS13    |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "13" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE13" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "LS13"
And I set fields
   | nummer | 13-EKRE |
   | such   | RE13    |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "pwert" to "1500" in row 1
Then table has values
    | artikel | mge  | pwert    |
    | FB1     | 13   |  1500.00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS13" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+LS13"
And I set fields
   | nummer | 13-EKRLS |
   | such   | RLS13    |
   | ueb    | ja       |
   | land   | USD      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "-26" in row 1
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS13" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS13"
And I set fields
   | nummer | 13-EKKGS |
   | such   | KGS13    |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
Then field "pwert" has value "-892.86" in row 1
And I set field "mge" to "-13" in row 1
Then field "pwert" has value "-446.43" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#---------------------------------------------------------------------------------------------
Scenario: BE (Pauschalpreis 0) -> LS -> RE (Pauschalpreis 0) -> RLS -> KGS
# Ein Pauschalpreis von 0.0 muss richtig behandelt werden.
#---------------------------------------------------------------------------------------------

# Bestellung anlegen
Given I open an editor "BE14" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1     |
   | nummer | 14-BE |
   | such   | BE14  |
And I append rows
   | artikel | mge | preis  | pwert       |
   | FB1     | 14  | 0      | 0           |
   | FB1     | 14  | 14     | !dontChange |
And I save the current editor

# Lieferschein
Given I open an editor "EKLS14" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE14"
And I set fields
   | nummer | 14-EKLS |
   | such   | LS14    |
   | vom    | .       |
   | ueb    | ja      |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Rechnung
Given I open an editor "RE14" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "LS14"
And I set fields
   | nummer | 14-EKRE |
   | such   | RE14    |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "preis" to "0" in row 2
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS14" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+LS14"
And I set fields
   | nummer | 14-EKRLS |
   | such   | RLS14    |
   | ueb    | ja       |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS14" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS14"
And I set fields
   | nummer | 14-EKKGS |
   | such   | KGS14    |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
Then field "pwert" has value "0.00" in row 1
Then field "pwert" has value "0.00" in row 2
And I set field "mge" to "-7" in row 1
And I set field "mge" to "-7" in row 2
Then field "pwert" has value "0.00" in row 1
Then field "pwert" has value "0.00" in row 2
And I save the current editor

################################################################################
# V E R K A U F
################################################################################

#----------------------------------------------------------------------------------------------
# TSQ-GUTSCHRIFT-01: Verkauf -> LS - Rueck-LS - RE mit der Art "Kaufmaennische Gutschrift"
#----------------------------------------------------------------------------------------------

Scenario: 01 Auftrag mit 2 normalen Positionen und 2 Zusatzpositonen anlegen
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "001"
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel2" in row 2
And I set field "mge" to "10" in row 2
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel3" in row 3
And I set field "mge" to "10" in row 3
And I create a new row at the end of the table
And I set field "artikel" to id from editor "zusatzAUBE" in row 4
And I set field "mge" to "10" in row 4
And I create a new row at the end of the table
And I set field "artikel" to id from editor "neutralePOS" in row 5
And I save the current editor

Scenario: 01 Lieferschein zu obigem Auftrag anlegen, buchen, rueckliefern und kaufm. Gutschrift erstellen
Given I open an editor "vk1lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "nummer" to "002"
And I set field "ueb" to "ja"
And I set field "budat" to "."
Then setting field "mge" to "-1" in row 2 throws the exception "1361"
And I set field "mge" to "10" in row 1
And I set field "mge" to "5" in row 2
And I set field "mge" to "5" in row 4
And I save the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "vkre_004" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "vk1lieferschein"
And I set field "num3" to "004-VKRE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "004" in row 1
And I set field "kenn" to "FALL-004"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#1. Position des Lieferscheins rueckliefern
Given I open an editor "vkrueck1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "vk1lieferschein"
And I set field "nummer" to "003"
Then field "lsart" has value "Rücklieferschein"
And I set field "ueb" to "ja"
And I set field "mge" to "-5" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor

#2. Position des Lieferscheins rueckliefern
Given I open an editor "vkrueck2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "vk1lieferschein"
And I set field "nummer" to "004"
Then field "lsart" has value "Rücklieferschein"
And I set field "ueb" to "ja"
And I set field "mge" to "-5" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor

#Kaufmaennische Gutschrift zu erster Ruecklieferung anlegen und zweite Ruecklieferung anfuegen
Given I open an editor "vkgut1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "vkrueck1"
And I set field "nummer" to "005"
And I set field "ueb" to "ja"
# Diese GS wird im Folgedrucktest als Gutschrift ausgegeben
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "lsart" has value ""
# Feld dfuesenden ist in kaufm. Gutschrift nicht gesetzt, aber aenderbar
Then field "dfuesenden" has value "nein"
Then field "dfuesenden" is modifiable
And I set field "beleg" to id from editor "vkrueck2"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#Beide Ruecklieferscheine sind in der Ablage
Given I open an editor "vkrueck7" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "vkrueck1"
Then field "ablagef" has value "ja"
And I close the current editor

Given I open an editor "vkrueck8" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "vkrueck2"
Then field "ablagef" has value "ja"
And I close the current editor

Given I open an editor "vkgut1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "vkgut1"
Then field "ablagef" has value "ja"
And I close the current editor

Scenario: 01 Kenner Gutschrift in einer Position setzen, in der anderen nicht, Ruecklieferschein geht in die Ablage
Given I open an editor "vkrechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "ueb" to "ja"
And I set field "budat" to "."
Then the table has 3 rows
Then setting field "mge" to "-1" in row 2 throws the exception "1361"
And I set field "mge" to "5" in row 1
And I set field "mge" to "10" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#Rechnung rueckliefern
Given I open an editor "vkrueck3" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "vkrechnung"
And I set field "nummer" to "006"
Then field "lsart" has value "Rücklieferschein"
Then field "vorganga" has value ""
Then the table has 2 rows
And I set field "ueb" to "ja"
And I set field "mge" to "-5" in row 1
Then field "rerelev" has value "ja" in row 1
And I set field "rerelev" to "nein" in row 1
And I set field "mge" to "-10" in row 2
Then field "rerelev" has value "ja" in row 2
And I save the current editor

#Kaufm. Gutschrift erstellen, nur eine Position wird uebernommen
Given I open an editor "vkgut2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "007"
And I set field "kunde" to id from editor "kunde"
And I set field "beleg" to id from editor "vkrueck3"
And I set field "ueb" to "ja"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then the table has 1 rows
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung ist in der Ablage
Given I open an editor "vkrueck4" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "vkrueck3"
Then field "ablagef" has value "ja"

Scenario: 01 Im Ruecklieferschein die Gutschrift auf nein setzen, Ruecklieferschein geht in die Ablage
Given I open an editor "vk2lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "ueb" to "ja"
And I set field "mge" to "5" in row 1
And I save the current editor

#Lieferschein rueckliefern und Gutschrift nicht setzen
Given I open an editor "vkrueck5" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "vk2lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "vorganga" has value ""
And I set field "ueb" to "ja"
And I set field "mge" to "-5" in row 1
Then field "rerelev" has value "ja" in row 1
And I set field "rerelev" to "nein" in row 1
And I save the current editor

#Ruecklieferschein ist in der Ablage
Given I open an editor "vkrueck6" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "vkrueck5"
Then field "ablagef" has value "ja"

#----------------------------------------------------------------------------------------------
# TSQ-GUTSCHRIFT-02: Verkauf -> RE NEU, Kunden eintragen, Beleg anfuegen -> RE-Art "Kaufmaennische Gutschrift"
#----------------------------------------------------------------------------------------------

Scenario: 02 Rechnung Neu, Kunden eintragen, Ruecklieferschein als Beleg anfuegen
Given I open an editor "vkrekaufgutschrift1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "beleg" to id from editor "vkrueck1"
# Ist Rechnung, da die vorgeschl. Rl Menge = 0 ist (Wrde schon vollst. Zurueckgeliefert)
Then field "vorganga" has value "Rechnung"
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-GUTSCHRIFT-03: Verkauf -> kaufm. Gutschrift: mehrhaftes Einfuegen einer RLS-Pos in mehreren kaufm. Gutschriften nicht erlaubt.
#----------------------------------------------------------------------------------------------

Scenario: 03 Rechnung der Art "kaufm. Gutschrift" existiert. Dessen Positionen in eine andere Rechnung duerfen nicht hinzugefuegt werden.
Given I open an editor "vkrekaufgutschrift2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "vkrueck2"
And setting field "beleg" to "vkrueck1" throws the exception ""
# Ist Rechnung, da die vorgeschl. Rl Menge = 0 ist (Wrde schon vollst. Zurueckgeliefert)
Then field "vorganga" has value "Rechnung"
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-GUTSCHRIFT-10: Verkauf -> Keine Anzahlungspositionen in kaufm. Gutschrift zu Ruecklieferung uebernehmen
#----------------------------------------------------------------------------------------------

Scenario: Keine Anzahlungspositionen in KGS zu Ruecklieferung uebernehmen
Given I create a SalesOrder "AUFANZ01" for Customer "1" with Product "V1" and quantity "1" and price "5000"

# Fakturaplan anlegen und Anzahlungsrechnungen anlegen
Given I open an editor "FP01" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "AUFANZ01"
And I set fields
	| such | FPANZ01 |
And I append rows
	| reart     | anzpwert | ptext        | zbed |
	| Anzahlung | 1000     | 1. Anzahlung | 203  |
	| Anzahlung | 2000     | 2. Anzahlung | 203  |
And I press button "anzahlungsrechn" to open a subeditor for "anzrecherstellen" in row 1
And I set field "ueb" to "ja"
And I set field "pwert" to "100.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "FP01"
And I press button "anzahlungsrechn" to open a subeditor for "anzrecherstellen" in row 1
And I set field "ueb" to "ja"
And I set field "pwert" to "200.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "FP01"
Then the table has 2 rows
And I save the current editor

# Offener Posten ausbuchen
Given I open an editor "OP-Bearbeitung" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I press button "opladen"
And I set field "opzabetr" to "115" in row 1
And I set field "opzabetr" to "230" in row 2
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

# Lieferschein fuer erste Position buchen
Given I deliver the SalesOrder "AUFANZ01" with PackingSlip "LSANZ01"

# Ruecklieferung erstellen
Given I open an editor "RLSANZ01" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LSANZ01"
Then I set field "such" to "RLSANZ01"
Then I set field "ueb" to "ja"
Then I set field "mge" to "-1" in row !lastRow
And I save the current editor

# KGS zu RLS erzeugen
Given I open an editor "KGSANZ01" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLSANZ01"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
Then the table has 1 rows
Then table has values
    | artikel | mge  |
    | V1      |  0   |
And I save the current editor

# Folgende Objekte muessen abgelegt sein
Then "(Sales):(Invoice)" with the editor id "KGSANZ01" is filed
Then "(Sales):(PackingSlip)" with the editor id "RLSANZ01" is filed


################################################################################
# E I N K A U F
################################################################################

#----------------------------------------------------------------------------------------------
# TSQ-GUTSCHRIFT-04: Einkauf BE -> LS - Rueck-LS - RE mit der Art "Kaufmaennische Gutschrift"
#----------------------------------------------------------------------------------------------

Scenario: 04 Bestellung mit 3 normalen Positionen und 2 Zusatzpositonen anlegen
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I set field "nummer" to "01"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel2" in row 2
And I set field "mge" to "10" in row 2
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel3" in row 3
And I set field "mge" to "10" in row 3
And I create a new row at the end of the table
And I set field "artikel" to id from editor "zusatzAUBE" in row 4
And I set field "mge" to "10" in row 4
And I create a new row at the end of the table
And I set field "artikel" to id from editor "neutralePOS" in row 5
And I save the current editor

Scenario: 04 Lieferschein zu obiger Bestellung anlegen, buchen, rueckliefern und kaufm. Gutschrift erstellen
Given I open an editor "ek1lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "nummer" to "02"
And I set field "such" to "ek1ls"
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EKLieferschein"
And I set field "vom" to "."
Then setting field "mge" to "-1" in row 2 throws the exception "1361"
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
And I set field "mge" to "5" in row 3
And I save the current editor

# Rechnung zu LS erzeugen, sonst ist keine KGS moeglich
Given I open an editor "EKRechnung1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ek1lieferschein"
And I set field "ebeleg" to "444"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "term" to "."
And I set field "such" to "EKRECH1"
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
And I set field "mge" to "5" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#1. Position des Lieferscheins rueckliefern
Given I open an editor "ekrueck1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ek1lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "03"
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EKRlschein"
And I set field "vom" to "."
And I set field "such" to "EKRUECK1"
And I set field "mge" to "-5" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor

#2. Position des Lieferscheins rueckliefern
Given I open an editor "ekrueck2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ek1lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "04"
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EKRlschein"
And I set field "vom" to "."
And I set field "such" to "EKRUECK2"
And I set field "mge" to "-5" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor

#Kaufm. Gutschrift zu erster Ruecklieferung anlegen und zweite Ruecklieferung anfuegen
Given I open an editor "ekgut1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ekrueck1"
And I set field "nummer" to "05"
And I set field "ueb" to "ja"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "lsart" has value ""
And I set field "beleg" to id from editor "ekrueck2"
And I set field "ebeleg" to "EKGutschrift"
And I set field "vom" to "."
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: 04 Kenner Gutschrift in einer Position setzen, in der anderen nicht, Ruecklieferschein geht in die Ablage
Given I open an editor "ekrechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "nummer" to "06"
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EKRechnung"
And I set field "vom" to "."
Then the table has 4 rows
Then setting field "mge" to "-1" in row 2 throws the exception "1361"
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#Rechnung rueckliefern
Given I open an editor "ekrueck3" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "ekrechnung"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "07"
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EKRlschein"
And I set field "vom" to "."
And I set field "such" to "EKRUECK3"
Then the table has 2 rows
And I set field "mge" to "-5" in row 1
Then field "rerelev" has value "ja" in row 1
And I set field "rerelev" to "nein" in row 1
And I set field "mge" to "-5" in row 2
Then field "rerelev" has value "ja" in row 2
And I save the current editor

#Kaufm. Gutschrift erstellen, nur eine Position wird uebernommen
Given I open an editor "ekgut2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I set field "beleg" to id from editor "ekrueck3"
And I set field "nummer" to "08"
And I set field "ueb" to "ja"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "ebeleg" to "EKGutschrift"
And I set field "vom" to "."
Then the table has 1 rows
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung ist in der Ablage
Given I open an editor "ekrueck4" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "ekrueck3"
Then field "ablagef" has value "ja"

Scenario: 04 Im Ruecklieferschein die Gutschrift auf nein setzen, Ruecklieferschein geht in die Ablage
Given I open an editor "ek2lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "nummer" to "09"
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EKLieferschein"
And I set field "vom" to "."
And I set field "mge" to "5" in row 1
And I save the current editor

#1. Position des Lieferscheins rueckliefern und Gutschrift nicht setzen
Given I open an editor "ekrueck5" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "ek2lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "010"
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EKRlschein"
And I set field "vom" to "."
And I set field "mge" to "-5" in row 1
Then field "rerelev" has value "ja" in row 1
And I set field "rerelev" to "nein" in row 1
And I save the current editor

#Ruecklieferschein ist in der Ablage
Given I open an editor "ekrueck6" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "ekrueck5"
Then field "ablagef" has value "ja"

#----------------------------------------------------------------------------------------------
# TSQ-GUTSCHRIFT-05: Einkauf -> Kaufm. Gutschrift manuell auswaehlen.
#----------------------------------------------------------------------------------------------

Scenario: 05 Rechnung NEU mit Art "Kaufm. Gutschrift" erstellen
#Rechnung Neu zu Position 1 aus bestellung anlegen
Given I open an editor "EKRechnung1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "nummer" to "1RE012"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "term" to "."
And I set field "mge" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#EK - Rechnung Neu als Kaufm. Gutschrift
Given I open an editor "ekkaufmgut1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I set field "nummer" to "011"
And I set field "vom" to "."
And I set field "beleg" to id from editor "EKRechnung1"
Then the table has 4 rows
Then field "pwert" has value "0.00" in row 1
Then field "preis" has value "511.29" in row 1
Then field "nwert" has value "0.00" in row 1
Then field "npwert" has value "0.00" in row 1
Then field "rabmge" has value "0" in row 1
Then field "prgmge" has value "0" in row 1
Then field "fixpwert" has value "ja" in row 1
Then field "mge" has value "0" in row 1
And I set field "mge" to "-1" in row 1
And I create a new row at position 2
And I set field "artex" to "NEUPOS" in row 2
Then field "pwert" is modifiable in row 2
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-GUTSCHRIFT-06: Einkauf -> Kaufm. Gutschrift manuell auswaehlen -> Barzahlung via "Beleg anfuegen"
#----------------------------------------------------------------------------------------------

Scenario: 06 Barrechnung anlegen
Given I open an editor "barrechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "012"
And I set field "vorganga" to "Barzahlung"
And I set field "lief" to id from editor "lieferant"
And I set field "ebeleg" to "barrechnung"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel1" in row 1
And I set field "mge" to "5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: 06 Wertgutschrift fuer ungebuchte Barrechnung darf nicht angelegt werden
Given I open an editor "wertgut-nie-erlaubt" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And setting field "beleg" to "012" throws the exception ""
And I close the current editor

Scenario: 06 Barrechnung buchen
Given I open an editor "barrechnung" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "012"
And I set field "ueb" to "ja"
And I save the current editor

Scenario: 06 Wertgutschrift fuer Barrechnung anlegen
Given I open an editor "wertgut-erlaubt" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "barrechnung"
And I set field "vom" to "."
And I set field "nummer" to "013"
And I set field "ebeleg" to "Kaufm. Gutschrift manuell"
Then the table has 4 rows
And I set field "mge" to "-5" in row 1
And I create a new row at the end of the table
And I set field "artikel" to id from editor "textPOS" in row !lastRow
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-GUTSCHRIFT-07: Einkauf -> Kaufm. Gutschrift zu Ruecklieferschein mit Preisuebernahme aus Rechnungen
#----------------------------------------------------------------------------------------------

Scenario: Kaufm. GS zu RLS mit Preisuebernahme aus RE-Pos -> GS-Pos
#
#      RE01
#     /
# BE01 -> LS01 -> RLS01 -> KGS01 (Preis aus RE01)
#

# Bestellung anlegen
Given I create a PurchaseOrder "BE01" for Vendor "1" with Product "E1" and quantity "10" and price "10"

# Berechne die Bestellung
Given I open an editor "RE01" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE01"
Then setting field "vorganga" to "Kaufmännische Gutschrift" throws the exception "131"
And I set fields
   | ebeleg | RE01 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE01 |
And I set field "mge" to "10" in row 1
And I set field "preis" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Liefere die Bestellung
Given I deliver the PurchaseOrder "BE01" with PackingSlip "LS01"

# Ruecklieferung des LS
Given I return the PurchasingPackingSlip "LS01" with ReturnPackingSlip "RLS01"

# RL gutschreiben
Given I open an editor "KGS01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS01"
Then field "vorganga" has value "Kaufmännische Gutschrift"
# Der Preis der GS zur RL kommt aus der Rechnung!
Then field "preis" has value "12.00" in row 1
Then field "herkunft^kopf^such" has value "RE01" in row 1
And I set fields
   | ebeleg | KGS01 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS01 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Kaufm. GS zu RLS mit geteilten GS Positionen
# Test Preisuebernahme in GS bei mehreren RE
#
# BE11 ---------------- RE11
# 20 St. zu 3           7 St. zu 4 (1!)
# | Aktion | remge |
# |        | 20 St.|
# | (1)    | 13 St.|
# | (2)    |  7 St.|
#       \
#         ---------------- RE12
#         \                6 St. zu 5 (2!)
#          \
#           \
#             ------ LS11 --------------- RLS11 ------------- KGS11 (Preise aus RE11, RE12) ---------- SKGS11 Storno
#             \       15 St.  (3!)        -15 St. (5!)        -8 St.  (7 St. zu 4 + 1 St. zu 5) (6!)   10 St. (8!)
#              \      | Aktion | remge |  | Aktion | remge |  | Aktion | mge   | herkunft |
#               \     |        |  0 St.|  |        | -8 St.|  |        | -7 St.| RE11     |
#                \                        | (6)    | -0 St.|  |        | -1 St.| RE12     |
#                 \                       | (8)    | -8 St.|
#                  \
#                    ------ LS12 -------------- RLS12 ------------- KGS12 (Preise aus RE11)
#                           5 St. (4!)          -5 St. (7!)         5 St. (9!)
#                           | Aktion | remge |  | Aktion | remge |  | Aktion | mge   | herkunft |
#                           |        |  0 St.|  |        |  5 St.|  |        | -5 St.| RE11     |
#                                               | (9)    |  0 St.|
# Bestellung anlegen
Given I create a PurchaseOrder "BE11" for Vendor "1" with Product "E1" and quantity "20" and price "3"

# Berechne (Teil) die Bestellung
Given I open an editor "RE11" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE11"
And I set fields
   | ebeleg | RE11 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE11 |
And I set field "mge" to "7" in row 1
And I set field "preis" to "4" in row 1
And I set field "pftext" to "Das ist ein laaaaaaaaaaaaaaaanger Freitext." in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Berechne (Teil) die Bestellung
Given I open an editor "RE12" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE11"
And I set fields
   | ebeleg | RE12 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE12 |
And I set field "mge" to "6" in row 1
And I set field "preis" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Liefere die Bestellung (Teil)
Given I open an editor "LS11" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE11"
And I set fields
   | ebeleg | LS11 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS11 |
And I set field "mge" to "15" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor

# Liefere die Bestellung (Teil 2)
Given I open an editor "LS12" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE11"
And I set fields
   | ebeleg | LS12 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS12 |
And I set field "mge" to "5" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor

# Ruecklieferung des LS
Given I return the PurchasingPackingSlip "LS11" with ReturnPackingSlip "RLS11"

# RL gutschreiben
Given I open an editor "KGS11" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
Then setting field "vorganga" to "Kaufmännische Gutschrift" throws the exception "131"
# GS erstellen ueber Beleg anfuegen
And I set field "beleg" to id from editor "RLS11"
Then the table has 2 rows
Then table has values
     | art | mge | preis | remge | herkunft^kopf^such | pftext |
     | E1  | -7  | 4.00  | -7    | RE11               |        |
     | E1  | -1  | 5.00  | -1    | RE12               |        |

# Der Preis der GS zur RL kommt aus den Rechnungen und der Bestellung!
Then field "preis" has value "4.00" in row 1
And I set fields
   | ebeleg | KGS11 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS11 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nach dem Speichern noch einmal oeffnen
Given I open an editor "KGS11V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS11"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such | herkunft^verrechmge |
    | E1  | -7  | 4.00  | 0     | RE11               | 7 |
    | E1  | -1  | 5.00  | 0     | RE12               | 1 |
And I close the current editor

# Eine weitere Ruecklieferung erhaelt den Preis aus den Rechnung RE12, da
# RE11 vollst. verrechnet ist
# Ruecklieferung des LS12
Given I return the PurchasingPackingSlip "LS12" with ReturnPackingSlip "RLS12"

# RLS gutschreiben - Es kann eine KGS erzeugt werden - nicht speichern
Given I open an editor "REVIEW" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS12"
Then field "mge" has value "-5" in row 1
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such | herkunft^verrechmge |
    | E1  | -5  | 5.00  | -5    | RE12               | 1                   |
And I close the current editor

# Storno KGS
Given I open an editor "KGSS11" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS11"
And I save the current editor

Given I open an editor "KGS11V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS11"
Then field "vorganga" has value "Stornierte kaufmännische Gutschrift"
# Then the table has 3 rows
Then table has values
    | art | mge | preis | herkunft^kopf^such | herkunft^verrechmge |
    | E1  | -7  | 4.00  | RE11               | 0                   |
    | E1  | -1  | 5.00  | RE12               | 0                   |
And I close the current editor

# RL gutschreiben (Dieses mal mit Verrechnung)
Given I open an editor "KGS12" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS12"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then the table has 1 rows
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such |
    | E1  | -5  | 4.00  | -5    | RE11               |
# Der Preis der GS zur RL kommt aus der RE11!
And I set fields
   | ebeleg | KGS12 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS12 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KGS12V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS12"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then the table has 4 rows
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such | herkunft^verrechmge |
    | E1  | -5  | 4.00  | 0     | RE11               | 5                   |
And I close the current editor

Scenario: Kaufm. GS zu RLS mit geteilten GS Positionen und unterschiedl. Waehrungen
# Test Preisuebernahme in GS bei mehreren RE und Waehrungswechsel
#
# BE21 ---------------- RE21
# 20 St. zu 3           6 St. zu 4€ (1!)
# | Aktion | remge |
# |        | 20 St.|
# | (1)    | 14 St.|
# | (2)    |  6 St.|
#    \
#      --------------------- RE22
#      \                     8 St. zu 4.85€ (5$ umgerechnet) (2!)
#       \                    | Aktion | remge |
#        \                   |        |  0 St.|
#         \
#           ------ LS21 -------------- RLS21 ------------ KGS21 (Preise aus RE21, RE22)
#           \      15 St.  (3!)        -15 St. (5!)       -5 St.  (6 St. zu 4€ + 3 St. zu 5€) (6!)
#            \     | Aktion | remge |  | Aktion | remge | | Aktion | mge   | herkunft |
#             \    |        |  0 St.|  |        | -9 St.| |        | -6 St.| RE21     |
#              \                                          |        | -3 St.| RE22     |
#                ------ LS22
#                        5 St. (4!)
#                       | Aktion | remge |
#                       |        |  0 St.|
#
# Bestellung anlegen
Given I create a PurchaseOrder "BE21" for Vendor "1" with Product "E1" and quantity "20" and price "3"

# Berechne (Teil) die Bestellung
Given I open an editor "RE21" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE21"
And I set fields
   | ebeleg | RE21 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE21 |
And I set field "mge" to "6" in row 1
And I set field "preis" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Berechne (Teil) die Bestellung
Given I open an editor "RE22" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE21"
And I set fields
   | ebeleg | RE22 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | land   | USD  |
   | such   | RE22 |
And I set field "mge" to "8" in row 1
# Preis 5$ (USD)
And I set field "preis" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Liefere die Bestellung (Teil)
Given I open an editor "LS21" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE21"
And I set fields
   | ebeleg | LS21 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS21 |
And I set field "mge" to "15" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor

# Liefere die Bestellung (Teil 2)
Given I open an editor "LS22" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE21"
And I set fields
   | ebeleg | LS22 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS22 |
And I set field "mge" to "5" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor

# Ruecklieferung des LS
Given I return the PurchasingPackingSlip "LS21" with ReturnPackingSlip "RLS21"

# RL gutschreiben
Given I open an editor "KGS21" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS21"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then the table has 2 rows
Then table has values
    | art | mge | preis | zwaehr |remge | herkunft^kopf^such |
    | E1  | -6  | 4.00  | DEM    |-6    | RE21               |
    | E1  | -3  | 8.40  | DEM    |-3    | RE22               |
# Der Preis der GS zur RL kommt aus den Rechnungen und der Bestellung!
And I set fields
   | ebeleg | KGS21 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS21 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Kaufm. GS zu RLS mit geteilten GS Positionen und unterschiedl. Handelseinheiten
# Test Preisuebernahme in GS bei mehreren RE und untersch. HE
#
# BE31 ---------------- RE31
# 20 St. zu 3           7 St. zu 4 (1!)
# | Aktion | remge |
# |        | 20 St.|
# | (1)    | 13 St.|
# | (2)    |  1 St.|
#    \
#      --------------------- RE32
#      \                     2 Satz zu 21.60 (2!) 1 Satz=6 Stueck
#       \
#        \
#          ------ LS31 --------------- RLS31 ------------- KGS31 (Preise aus RE31, RE32)
#          \      15 St.  (3!)         -15 St. (5!)        -14 St.  (7 St. zu 4 + 7 St. zu 3.60) (6!)
#           \     | Aktion | remge |   | Aktion | remge  | | Aktion | mge   | herkunft |
#            \    |        |  0 St.|   |        | -14 St.| |        | -7 St.| RE31     |
#             \                                            |        | -7 St.| RE32     | (verrechnet behandelt HE)
#               ------ LS32
#                      5 St. (4!)
#                      | Aktion | remge |
#                      |        |  0 St.|
#
# Teil E1 Handelseinheit Satz anlegen
Given I open an editor "E1" from table "(Part):(Product)" with command "UPDATE" for record "E1"
And I set field "vpe" to "Satz"
And I set field "fvple" to "6"
And I save the current editor

# Bestellung anlegen
Given I create a PurchaseOrder "BE31" for Vendor "1" with Product "E1" and quantity "20" and price "3"

# Berechne (Teil) die Bestellung
Given I open an editor "RE31" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE31"
And I set fields
   | ebeleg | RE31 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE31 |
And I set field "mge" to "7" in row 1
And I set field "preis" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Berechne (Teil) die Bestellung
Given I open an editor "RE32" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE31"
And I set fields
   | ebeleg | RE32 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE32 |
And I set field "mge" to "2" in row 1
# Handelseinheit Satz (entspr. 6 Stueck)
And I set field "he" to "Satz" in row 1
And I set field "preis" to "21.60" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Liefere die Bestellung (Teil)
Given I open an editor "LS31" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE31"
And I set fields
   | ebeleg | LS31 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS31 |
And I set field "mge" to "15" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor

# Liefere die Bestellung (Teil 2)
Given I open an editor "LS32" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE31"
And I set fields
   | ebeleg | LS32 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS32 |
And I set field "mge" to "5" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor

# Ruecklieferung des LS
Given I return the PurchasingPackingSlip "LS31" with ReturnPackingSlip "RLS31"

# RL gutschreiben
Given I open an editor "KGS31" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS31"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then table has values
    | art | mge | preis | zwaehr |remge | herkunft^kopf^such |
    | E1  | -7  | 4.00  | DEM    |-7    | RE31               |
    | E1  | -7  | 21.60 | DEM    |-7    | RE32               |
# Der Preis der GS zur RL kommt aus den Rechnungen und der Bestellung!
And I set fields
   | ebeleg | KGS31 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS31 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KGS31V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS31"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then the table has 5 rows
# verrechnet Werte pruefen
Then table has values
    | art | mge | preis  | zwaehr |remge | herkunft^kopf^such | herkunft^verrechmge |
    | E1  | -7  | 4.00   | DEM    | 0    | RE31               | 7                   |
    | E1  | -7  | 21.60  | DEM    | 0    | RE32               | 1.167               |
And I close the current editor

# Teil E1 Handelseinheit zuruecksetzen
Given I open an editor "E1" from table "(Part):(Product)" with command "UPDATE" for record "E1"
And I set field "vpe" to "Stück"
And I set field "fvple" to "1"
And I save the current editor

Scenario: Kaufm. GS zu RLS mehrere Teilgutschriften mit geteilten GS Positionen
# Gutschriften Teilgutschriften
#
# BE41 ---------------- RE42
# 20 St. zu 3           7 St. zu 4 (2!)
# | Aktion | remge |
# |        | 20 St.|
# | (1)    | 13 St.|
# | (2)    |  5 St.|
#    \
#     ---------------------- RE43
#      \                     8 St. zu 5 (3!)
#       \
#        \
#         --------------------- LS41 -------------- RLS41 -------------- KGS41 (Preise aus RE42, RE43)
#          \                    15 St.  (4!)        -15 St. (5!)         -8 von 10 St. (7 St. zu 4 + 1 von 3 St. zu 5) (7!)
#           \                   | Aktion | remge |  | Aktion | remge  |  | Aktion | mge   | herkunft |
#            \                  |        |  0 St.|  |        | -10 St.|  |        | -7 St.| RE42     |
#             \                                     |    (7) |  -2 St.|  |        | -1 St.| RE43     |
#              \                                    |    (8) |   0 St.|
#               \                                     \
#                \                                      ------ KGS42 (Preise aus RE43)
#                 \                                            2 St. zu 5 (8!)
#                  \                                           | Aktion | mge  | herkunft |
#                   \                                          |        | 0 St.| RE43     |
#                    \
#                     ------------------------------------ RE41 n. geb
#                                                          5 St. zu 2 (6!)

# Bestellung anlegen
Given I create a PurchaseOrder "BE41" for Vendor "1" with Product "E1" and quantity "20" and price "3"


# Berechne (Teil) die Bestellung
Given I open an editor "RE42" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE41"
And I set fields
   | ebeleg | RE42 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE42 |
And I set field "mge" to "7" in row 1
And I set field "preis" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Berechne (Teil) die Bestellung
Given I open an editor "RE43" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE41"
And I set fields
   | ebeleg | RE43 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE43 |
And I set field "mge" to "8" in row 1
And I set field "preis" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Liefere die Bestellung (Teil)
Given I open an editor "LS41" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE41"
And I set fields
   | ebeleg | LS41 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS41 |
And I set field "mge" to "15" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor

# Ruecklieferung des LS
Given I return the PurchasingPackingSlip "LS41" with ReturnPackingSlip "RLS41"

# Berechne (Teil) die Bestellung (ungebucht) - noch 5 zu berechnen
Given I open an editor "RE41" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE41"
And I set fields
   | ebeleg | RE41 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | nein |
   | such   | RE41 |
And I set field "mge" to "5" in row 1
And I set field "preis" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# RL gutschreiben (Teil 1)
Given I open an editor "KGS41" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS41"
Then the table has 2 rows
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such |
    | E1  | -7  | 4.00  | -7    | RE42               |
    | E1  | -3  | 5.00  | -3    | RE43               |
And I set field "mge" to "-1" in row 2
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such |
    | E1  | -7  | 4.00  | -7    | RE42               |
    | E1  | -1  | 5.00  | -3    | RE43               |
And I set fields
   | ebeleg | KGS41 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS41 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nach dem Speichern noch einmal oeffnen
Given I open an editor "KGS41V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS41"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such | herkunft^verrechmge |
    | E1  | -7  | 4.00  | 0     | RE42               | 7                   |
    | E1  | -1  | 5.00  | 0     | RE43               | 1                   |
And I close the current editor

# RL gutschreiben (Teil 2)
Given I open an editor "KGS42" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS41"
Then the table has 1 rows
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such |
    | E1  | -2  | 5.00  | -2    | RE43               |
And I set fields
   | ebeleg | KGS42 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS42 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nach dem Speichern noch einmal oeffnen
Given I open an editor "KGS42V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS42"
Then field "vorganga" has value "Kaufmännische Gutschrift"
# Bedient sich an den restlichen noch nicht verrechneten Mengen
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such | herkunft^verrechmge |
    | E1  | -2  | 5.00  | 0     | RE43               | 3                   |
And I close the current editor

Scenario: Kaufm. GS zu RLS mit geteilten GS Positionen und unterschiedl. Handelseinheiten, Preiseinheiten
# Test Preisuebernahme in GS bei mehreren RE und untersch. HE
#
# BE51 ---------------- RE51
# 20 St. zu 3           7 St. zu 4 (1!)
# | Aktion | remge |
# |        | 20 St.|
# | (1)    | 13 St.|
# | (2)    |  1 St.|
#    \
#      --------------------- RE52
#      \                     2 Satz zu 21.60 (2!) 1 Satz=6 Stueck
#       \
#        \
#          ------ LS51 -------------- RLS51 ------------- KGS51 (Preise aus RE51, RE52)
#          \      15 St.  (3!)        -15 St. (5!)        -14 St. (7 St. zu 4 + 7 Satz zu 21.60) (6!)
#           \     | Aktion | remge |  | Aktion | remge  | | Aktion | mge   | herkunft |
#            \    |        |  0 St.|  |        | -14 St.| |        | -7 St.| RE51     |
#             \                       | (6!)   |   0 St.| |        | -7 St.| RE52     | (Preiseinheit)
#               ------ LS32
#                      5 St. (4!)
#                      | Aktion | remge |
#                      |        |  0 St.|
#
# Teil E1 Handelseinheit Satz anlegen
Given I open an editor "E1" from table "(Part):(Product)" with command "UPDATE" for record "E1"
And I set field "epe" to "Satz"
And I set field "feple" to "6"
And I save the current editor

# Bestellung anlegen
Given I create a PurchaseOrder "BE51" for Vendor "1" with Product "E1" and quantity "20" and price "3"

# Berechne (Teil) die Bestellung
Given I open an editor "RE51" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE51"
And I set fields
   | ebeleg | RE51 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE51 |
And I set field "mge" to "7" in row 1
And I set field "preis" to "4" in row 1
Then table has values
    | art  | mge  | he    | zwaehr | preis | pe     | pwert |
    | E1   | 7    | Stück | DEM    | 4.00  | Satz   | 4.67  |

And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Berechne (Teil) die Bestellung
Given I open an editor "RE52" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE51"
And I set fields
   | ebeleg | RE52 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE52 |
And I set field "mge" to "2" in row 1
# Handelseinheit Satz (entspr. 6 Stueck)
And I set field "he" to "Satz" in row 1
And I set field "preis" to "21.60" in row 1
Then table has values
    | art  | mge  | he    | zwaehr | preis | pe     | pwert |
    | E1   | 2    | Satz  | DEM    | 21.60 | Satz   | 43.20 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Liefere die Bestellung (Teil)
Given I open an editor "LS51" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE51"
And I set fields
   | ebeleg | LS51 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS51 |
And I set field "mge" to "15" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor

# Liefere die Bestellung (Teil 2)
Given I open an editor "LS52" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE51"
And I set fields
   | ebeleg | LS51 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS51 |
And I set field "mge" to "5" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor

# Ruecklieferung des LS
Given I return the PurchasingPackingSlip "LS51" with ReturnPackingSlip "RLS51"

# RL gutschreiben
Given I open an editor "KGS51" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS51"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then table has values
    | art  | mge  | he    | preis | zwaehr | pe   | pwert  |remge | herkunft^kopf^such |
    | E1   | -7   | Stück | 4.00  | DEM    | Satz | -4.67  | -7   | RE51               |
    | E1   | -7   | Stück | 21.60 | DEM    | Satz | -25.20 | -7   | RE52               |
# Der Preis der GS zur RL kommt aus den Rechnungen und der Bestellung!
And I set fields
   | ebeleg | KGS51 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS51 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KGS51V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS51"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then the table has 5 rows
# verrechnet Werte pruefen
Then table has values
    | art  | mge  | he    | preis | zwaehr | pe   | pwert  |remge | herkunft^kopf^such |
    | E1   | -7   | Stück | 4.00  | DEM    | Satz | -4.67  | 0    | RE51               |
    | E1   | -7   | Stück | 21.60 | DEM    | Satz | -25.20 | 0    | RE52               |
And I close the current editor

# Teil E1 Handelseinheit zuruecksetzen
Given I open an editor "E1" from table "(Part):(Product)" with command "UPDATE" for record "E1"
And I set field "epe" to "Stück"
And I set field "feple" to "1"
And I save the current editor

Scenario: Kaufm. GS Aendern aktualisiert die verremge in den Rechnungen
#
#                RE61
#                (20 zu 5)
#                 /
#                /   ---> RE62
#               /   /    (17 zu 6)
#              /   /
# BE61 -----> LS61 ----------> RLS61 --> KGS61 -------- KGS61 (aendern->verremge in den Rechnungen anpassen!)
# (60 zu 3)   (55)             (40)      (5 zu 5)       (3 zu 5)
#                                \
#                                 ---------> KGS62 ...... KGS62  ................. KGS62
#                                            (-15 zu 5!)  (aendern->verremge RE!)  (1. Pos loeschen, verrmge RE61!)
#                                            (-15 zu 5!)  (-11 zu 5)               (-3  zu 6)
#                                            (-2  zu 6!)  (-3  zu 6)
#
# Bestellung anlegen
Given I create a PurchaseOrder "BE61" for Vendor "1" with Product "E1" and quantity "60" and price "3"

# Liefere die Bestellung (Teil)
Given I open an editor "LS61" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE61"
And I set fields
   | ebeleg | LS61 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS61 |
And I set field "mge" to "55" in row 1
And I save the current editor

# Teilrechnung zum LS
Given I open an editor "RE61" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS61"
And I set fields
   | ebeleg | RE61 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE61 |
And I set field "mge" to "20" in row 1
And I set field "preis" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilrechnung2 zum LS
Given I open an editor "RE62" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS61"
And I set fields
   | ebeleg | RE62 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE62 |
And I set field "mge" to "17" in row 1
And I set field "preis" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Ruecklieferung des LS
Given I open an editor "RLS61" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS61"
And I set fields
   | ebeleg | RLS61 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RLS61 |
And I set field "mge" to "-40" in row 1
And I save the current editor

# 1. Kaufm GS zu Ruecklieferschein
Given I open an editor "KGS61" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS61"
Then the table has 2 rows
Then table has values
    | art | mge  | preis |  herkunft^kopf^such |
    | E1  | -20  | 5.00  |  RE61               |
    | E1  | -2   | 6.00  |  RE62               |
And I set field "mge" to "-5" in row 1
And I delete row at position 2
And I set fields
   | ebeleg | KGS61 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS61 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KGS61V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS61"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then table has values
    | art | mge | preis | herkunft^kopf^such | herkunft^verrechmge |
    | E1  | -5  | 5.00  | RE61               | 5                   |
And I close the current editor

# 2. Kaufm GS zu Ruecklieferschein
Given I open an editor "KGS62" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS61"
Then the table has 2 rows
Then table has values
    | art | mge  | preis |  herkunft^kopf^such |
    | E1  | -15  | 5.00  |  RE61               |
    | E1  | -2   | 6.00  |  RE62               |
And I set fields
   | ebeleg | KGS62 |
   | vom    | .     |
   | tterm  | .     |
   | such   | KGS62 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KGS62V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS62"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then table has values
    | art | mge | preis | herkunft^kopf^such | herkunft^verrechmge |
    | E1  | -15 | 5.00  | RE61               | 20                  |
    | E1  | -2  | 6.00  | RE62               | 2                   |
And I close the current editor

Given I open an editor "KGS62U" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS62"
And I set field "mge" to "-11" in row 1
And I set field "mge" to "-1" in row 2
And I save the current editor

Given I open an editor "KGS62V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS62"
Then table has values
    | art | mge | preis | herkunft^kopf^such | herkunft^verrechmge |
    | E1  | -11 | 5.00  | RE61               | 16                  |
    | E1  | -1  | 6.00  | RE62               | 1                   |
And I close the current editor

Given I open an editor "KGS62U" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS62"
# 1. Pos aus KGS loeschen -> verrmge der RE muss angepasst werden
And I delete row at position 1
And I save the current editor

# Pruefe die verrmge in RE62
Given I open an editor "RE62V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE62"
Then table has values
    | art | mge | preis | verrechmge |
    | E1  | 17  | 6.00  | 1          |
And I close the current editor

# Pruefe die verrmge in RE61
Given I open an editor "RE61V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE61"
Then table has values
    | art | mge | preis | verrechmge |
    | E1  | 20  | 5.00  | 5          |
And I close the current editor

Scenario: Kaufm. GS Vorschlag Menge bei mehreren RLS, KGS
#
# BE71 ---------------- RE71
# 60 St. zu 5           30 St. zu 6 (1!)
# | Aktion | remge |
# |        | 60 St.|
# | (1)    | 20 St.|
#    \
#     \
#      --------------------- LS71 --------------- RLS71 ------------- KGS71 nicht speichern --- KGS71 erneut nicht speichern
#                            50 St. (2!)         -30 St. (3!)         0 St. zu 6 (4!)           -10 zu 6 (6!)
#                            | Aktion | remge |  | Aktion |  remge  | | Aktion | mge   | herkunft |
#                            |        |  0 St.|  |        |   0 St. | |        |  0 St.| RE71     |
#                                        \       | (5)    | -10 St. | |   (7)  |-10 St.| RE71     |
#                                         \
#                                           ------- RLS72  ------------- KGS72 nicht speichern --- KGS72 nicht speichern
#                                                   -10 St. zu 5 (5!)    -10 St. zu 6 (7!)         -10 St. zu 6 (6!)
#                                                   | Aktion | remge  |  | Aktion | remge |        | Aktion | remge |
#                                                   |        | -10 St.|  |        | -7 St.|        |        | -7 St.|
#

# Bestellung anlegen
Given I create a PurchaseOrder "BE71" for Vendor "1" with Product "E1" and quantity "60" and price "5"

# Berechne die Bestellung
Given I open an editor "RE71" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE71"
And I set fields
   | ebeleg | RE71 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE71 |
And I set field "mge" to "30" in row 1
And I set field "preis" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Liefere die Bestellung (Teil)
Given I open an editor "LS71" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE71"
And I set fields
   | ebeleg | LS71 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS71 |
And I set field "mge" to "50" in row 1
And I save the current editor

# Teil-Ruecklieferung des LS
Given I open an editor "RLS71" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS71"
And I set fields
   | ebeleg | RLS71 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RLS71 |
And I set field "mge" to "-30" in row 1
And I save the current editor

# Kaufm GS zu Ruecklieferschein zu RLS71 (wird nicht gespeichert)
Given I open an editor "KGS71" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS71"
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such |
    | E1  | 0   | 6.00  | 0     | RE71               |
And I close the current editor

# 2. Teil-Ruecklieferung des LS
Given I open an editor "RLS72" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS71"
And I set fields
   | ebeleg | RLS72 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RLS72 |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Kaufm GS zu Ruecklieferschein zu RLS71 2. Versuch (wird nicht gespeichert)
# Da es nun eine weitere RLS gibt, koennen nun 10 gutgeschrieben werden
Given I open an editor "KGS71" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS71"
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such |
    | E1  | -10 | 6.00  | -10   | RE71               |
And I close the current editor

# Kaufm GS zu Ruecklieferschein zu RLS72 (wird gespeichert)
Given I open an editor "KGS72" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS72"
Then the table has 1 rows
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such |
    | E1  | -10 | 6.00  | -10   | RE71               |
And I set fields
   | ebeleg | KGS72 |
   | vom    | .     |
   | tterm  | .     |
   | such   | KGS72 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Kaufm GS zu Ruecklieferschein zu RLS71 3. Versuch (wird nicht gespeichert)
Given I open an editor "KGS71" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS71"
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such |
    | E1  | -10 | 6.00  | -10   | RE71               |
And I close the current editor

Scenario: Kaufm. GS Vorschlag Menge bei mehreren RLS, KGS 2 (Gutschriftsmenge wird global betrachtet)
#
# BE81 ---------------- RE81
# 100 St. zu 5          10 St. zu 8500 (1!)
# | Aktion | remge |
# |        |100 St.|
# | (1)    | 90 St.|
# | (2)    | 35 St.|
# | (7)    | 35 St.|
#    \
#     \
#       ------------- RE82
#       \             55 St. zu 9500  (2!)
#        \
#         \
#           -------------- LS82 --------------- RLS81 -------------- KGS81
#           \              55 St.zu 5 (3!)      -40 St. zu 5(4!)     -5 St. zu 8500 (5!)
#            \             | Aktion | remge |   | Aktion |  remge  | | Aktion | mge   | herkunft |
#             \            |        |  0 St.|   |        |  -5 St. | |        | -5 St.| RE81     |
#              \             \                  | (5)    |   0 St. |
#               \             \                 | (7)    | -10 St. |
#                \             \                 \
#                 \             \                  ------- KGS82X (nicht speichern)
#                  \             \                 \       0 St. (6!)
#                   \             \                 \
#                    \             \                  ------------------- KGS83 nichts gut zu schreiben
#                     \             \                                     -0 St. (8!)
#                      \             \                                    | Aktion | mge   |
#                       \             \                                   |        | -0 St.|
#                        \             \
#                         \              -------------------------------------- RLS82 -------------- KGS84
#                          \                                                    -15 zu 5 (9!)        -5 zu 8500 und -10 zu 9100 (10!)
#                           \                                                   | Aktion | remge  |  | Aktion |  mge   | herkunft |
#                            \                                                  |        | -15 St.|  |        |  -5 St.| RE81     |
#                             \                                                 |        | -15 St.|  |        | -10 St.| RE82     |
#                               ----------------------------- RE83 (ungebucht)
#                                                             35 St. (7!)

# Bestellung anlegen
Given I create a PurchaseOrder "BE81" for Vendor "1" with Product "E1" and quantity "100" and price "5"

# 1. Rechnung anlegen
Given I open an editor "RE81" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE81"
And I set fields
   | ebeleg | RE81 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE81 |
And I set field "mge" to "10" in row 1
And I set field "preis" to "8500" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Rechnung anlegen
Given I open an editor "RE82" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE81"
And I set fields
   | ebeleg | RE82 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE82 |
And I set field "mge" to "55" in row 1
And I set field "preis" to "9500" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Liefere die Bestellung (Teil)
Given I open an editor "LS81" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE81"
And I set fields
   | ebeleg | LS81 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS81 |
And I set field "mge" to "55" in row 1
And I save the current editor

# Teil-Ruecklieferung des LS
Given I open an editor "RLS81" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS81"
And I set fields
   | ebeleg | RLS81 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RLS81 |
And I set field "mge" to "-40" in row 1
And I save the current editor

# Kaufm GS zu Ruecklieferschein zu RLS81
Given I open an editor "KGS81" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS81"
Then table has values
    | art | mge | preis    | remge | herkunft^kopf^such |
    | E1  |  -5 | 9500.00  |  -5   | RE82               |
And I set fields
   | ebeleg | KGS81 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS81 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Noch eine KGS erzeugen - Vorschlag muss 0 sein
Given I open an editor "KGS82X" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS81"
Then field "mge" has value "0" in row 1
And I close the current editor

# 3. Rechnung anlegen - noch 35 zu berechnen
Given I open an editor "RE83" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE81"
And I set fields
   | ebeleg | RE83 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | nein |
   | such   | RE83 |
Then field "remge" has value "35" in row 1
And I set field "mge" to "35" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Noch eine KGS erzeugen - Vorschlag muss 0 sein
Given I open an editor "KGS83" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS81"
Then the table has 1 rows
Then table has values
    | art | mge | preis    | remge | herkunft^kopf^such |
    | E1  |   0 | 9500.00  |     0 | RE82               |
And I set fields
   | ebeleg | KGS83 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS83 |
And I close the current editor

# 2. Teil-Ruecklieferung des LS
Given I open an editor "RLS82" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS81"
And I set fields
   | ebeleg | RLS82 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RLS82 |
And I set field "mge" to "-15" in row 1
And I save the current editor

# KGS zu RLS82
Given I open an editor "KGS84" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS82"
Then the table has 2 rows
Then table has values
    | art | mge | preis    | remge | herkunft^kopf^such |
    | E1  | -10 | 8500.00  |   -10 | RE81               |
    | E1  |  -5 | 9500.00  |    -5 | RE82               |
And I set fields
   | ebeleg | KGS84 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS84 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Noch eine KGS zu RLS81 erzeugen - Es kann nur noch eine 0 KGS erzeugt werden
Given I open an editor "REVIEW" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS81"
Then field "mge" has value "0" in row 1
And I close the current editor

# Noch eine KGS zu RLS82 erzeugen - Objekt kann nicht geladen werden (ist bereits vollstaendig berechnet)
Given I open an editor "REVIEW" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS82"
Then field "mge" has value "0" in row 1
And I close the current editor

Scenario: Kaufm. GS zu RLS - Abschliessen eines RLS mit 0 KGS
# Testet, wann der RLS in die Ablage geht, bzw. wieder aus der Ablage kommt.
#
# BE91 ---------------- RE91
# 10 St. zu 10          6 St. zu 12 (1!)
# | Aktion | remge |
# |        | 10 St.|
# | (1)    |  4 St.|
#    \
#      ------ LS91 --------------- RLS91 -------------- KGS91
#      \      9 St. (2!)           -8 St. (3!)          -3 St. statt -4 St. (4!)
#       \     | Aktion | remge |   | Aktion | remge |   | Aktion |   mge | herkunft |
#        \    |        |  0 St.|   |        | -4 St.|   |        | -4 St.| RE91     |
#         \                        |    (4) | -1 St.|
#          \                       |    (5) |  0 St.|
#           \                      |    (6) | -1 St.|
#            \                       \
#             \                       \
#              \                       \
#               \                        ------ KGS92 ------------------------ KGS92ST
#                \                       \      0* statt -1 St. (5!)           0 St. Storno (!6)
#                 \                       \     | Aktion | remge | herkunft |  RLS offen
#                  \                       \    |        | -1 St.| RE91     |
#                   \                       \
#                    \                        --------- KGS93
#                     \                                 -4 St. (8!)
#                      \                                | Aktion | remge  |
#                       \                               |        |  -1 St.|
#                        \
#                          --------------------- RE92 (ungebucht)
#                                                 4 St. zu 5 (7!)
#                                                 | Aktion | remge |
#                                                 |        |  4 St.|
#

# Bestellung anlegen
Given I create a PurchaseOrder "BE91" for Vendor "1" with Product "E1" and quantity "10" and price "10"

# Berechne die Bestellung
Given I open an editor "RE91" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE91"
Then setting field "vorganga" to "Kaufmännische Gutschrift" throws the exception "131"
And I set fields
   | ebeleg | RE91 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE91 |
And I set field "mge" to "6" in row 1
And I set field "preis" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Liefere die Bestellung (Teil)
Given I open an editor "LS91" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE91"
And I set fields
   | ebeleg | LS91 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS91 |
And I set field "mge" to "9" in row 1
And I save the current editor

# Teil-Ruecklieferung des LS
Given I open an editor "RLS91" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS91"
And I set fields
   | ebeleg | RLS91 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RLS91 |
And I set field "mge" to "-8" in row 1
And I save the current editor

# remge im RLS pruefen
Given I open an editor "RLS91V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS91"
Then field "remge" has value "-4" in row 1
And I close the current editor

# RLS gutschreiben
Given I open an editor "KGS91" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS91"
Then field "vorganga" has value "Kaufmännische Gutschrift"
# Der Preis der GS zur RL kommt aus der Rechnung!
Then field "preis" has value "12.00" in row 1
Then field "herkunft^kopf^such" has value "RE91" in row 1
Then field "mge" has value "-4" in row 1
And I set field "mge" to "-3" in row 1
And I set fields
   | ebeleg | KGS91 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS91 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "RLS91" is not filed

# remge im RLS pruefen
Given I open an editor "RLS91V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS91"
Then field "remge" has value "-1" in row 1
And I close the current editor

# RL 0 Gutschrift zum ablegen
Given I open an editor "KGS92" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS91"
Then field "vorganga" has value "Kaufmännische Gutschrift"
# Der Preis der GS zur RL kommt aus der Rechnung!
Then field "preis" has value "12.00" in row 1
Then field "herkunft^kopf^such" has value "RE91" in row 1
And I set fields
   | ebeleg | KGS92  |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | KGS92  |
Then field "mge" has value "-1" in row 1
And I set field "mge" to "0" in row 1
# Wollen Sie wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "RLS91" is filed

# remge im RLS pruefen
Given I open an editor "RLS91V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS91"
Then field "remge" has value "0" in row 1
And I close the current editor

# Storno KGS
Given I open an editor "KGS92ST" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS92"
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "RLS91" is not filed

# remge im RLS pruefen
Given I open an editor "RLS91V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS91"
Then field "remge" has value "-1" in row 1
And I close the current editor

# Berechne die Bestellung komplett - nichts zu berechnen
Given I open an editor "RE92" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE91"
Then setting field "vorganga" to "Kaufmännische Gutschrift" throws the exception "131"
And I set fields
   | ebeleg | RE92 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | nein |
   | such   | RE92 |
Then field "remge" has value "4" in row 1
And I set field "mge" to "4" in row 1
And I set field "preis" to "14" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# RLS erneut gutschreiben - nicht speichern
Given I open an editor "KGS93" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS91"
Then field "vorganga" has value "Kaufmännische Gutschrift"
# Der Preis der GS zur RL kommt aus der Rechnung!
Then field "preis" has value "12.00" in row 1
Then field "herkunft^kopf^such" has value "RE91" in row 1
And I set fields
   | ebeleg | KGS93  |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | KGS93  |
Then the table has 1 rows
Then table has values
    | art  | mge | preis | remge | herkunft^kopf^such |
    | E1   |  -1 | 12.00 |    -1 | RE91               |
And I close the current editor

# RLS ist nicht in der Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS91" is not filed

# remge im RLS pruefen
Given I open an editor "RLS91V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS91"
Then field "remge" has value "-1" in row 1
And I close the current editor

Scenario: Kaufm. GS zu RLS - Abschliessen eines RLS mit 0 KGS mit untersch. Handelseinheiten
# Test Preisuebernahme in GS bei mehreren RE und untersch. HE
#
# BE103 --------------- RE103
# 20 St. zu 3           8 St. zu 4 (1!)
# | Aktion | remge |
# |        | 20 St.|
# | (1)    | 12 St.|
# | (2)    |  0 St.|
#    \
#      ------------------ RE1032
#      \                  2 Satz zu 21.60 (2!) 1 Satz=6 Stueck
#       \
#        \
#          ------ LS103 -------------- RLS103 -----------  KGS103 (Preise aus RE103, RE1032) ----------- KGS103ST
#                  15 St.  (3!)        -15 St. (4!)        0* St. (5!) RLS abgelegt                      Storno (6!)
#                  | Aktion | remge |  | Aktion | remge  | | Aktion |  mge   | herkunft |                RLS offen
#                  |        |  0 St.|  |        | -15 St.| |        |  -8 St.| RE103    |
#                                      | (5)    |   0 St.| |        |  -7 St.| RE1032   |(verrechnet behandelt HE)
#                                      | (6)    | -15 St.|
#                                      | (7)    |   0 St.|
#                                       \
#                                        \
#                                          ------------------------- KGS1032 (Preise aus RE103, RE1032) RLS abgelegt
#                                                                    -15 St. (8 zu 4 und 7 zu 21.60) (7!)
#                                                                    | Aktion |  mge   | herkunft |
#                                                                    |        |  -8 St.| RE103    |
#                                                                    |        |  -7 St.| RE1032   |(Preiseinheit)

# Teil E1 Handelseinheit Satz anlegen
Given I open an editor "E1" from table "(Part):(Product)" with command "UPDATE" for record "E1"
And I set field "epe" to "Satz"
And I set field "feple" to "6"
And I save the current editor

# Bestellung anlegen
Given I create a PurchaseOrder "BE103" for Vendor "1" with Product "E1" and quantity "20" and price "3"

# Berechne (Teil) die Bestellung
Given I open an editor "RE103" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE103"
And I set fields
   | ebeleg | RE103 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RE103 |
And I set field "mge" to "8" in row 1
And I set field "preis" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Berechne (Teil) die Bestellung
Given I open an editor "RE1032" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE103"
And I set fields
   | ebeleg | RE1032 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | RE1032 |
And I set field "mge" to "2" in row 1
# Handelseinheit Satz (entspr. 6 Stueck)
And I set field "he" to "Satz" in row 1
And I set field "preis" to "21.60" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Liefere die Bestellung (Teil)
Given I open an editor "LS103" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE103"
And I set fields
   | ebeleg | LS103 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | LS103 |
And I set field "mge" to "15" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor

# Ruecklieferung des LS
Given I return the PurchasingPackingSlip "LS103" with ReturnPackingSlip "RLS103"

# RLS 0-Gutschrift erstellen
Given I open an editor "KGS103" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS103"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then the table has 2 rows
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such |
    | E1  | -8  | 4.00  | -8    | RE103              |
    | E1  | -7  | 21.60 | -7    | RE1032             |
# Der Preis der GS zur RL kommt aus den Rechnungen und der Bestellung!
And I set fields
   | ebeleg | KGS103 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | KGS103 |
And I delete row at position 1
And I set field "mge" to "0" in row 1
# Wollen Sie wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

# RLS ist in der Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS103" is filed

# Storno KGS
Given I open an editor "KGS103ST" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS103"
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "RLS103" is not filed

# RLS erneut gutschreiben
Given I open an editor "KGS1032" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS103"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then the table has 2 rows
Then table has values
    | art | mge | preis |remge | herkunft^kopf^such |
    | E1  | -8  | 4.00  |-8    | RE103              |
    | E1  | -7  | 21.60 |-7    | RE1032             |
# Der Preis der GS zur RL kommt aus den Rechnungen und der Bestellung!
And I set fields
   | ebeleg | KGS1032 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
   | such   | KGS1032 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# RLS ist wieder in der Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS103" is filed

## Teil E1 Handelseinheit zuruecksetzen
Given I open an editor "E1" from table "(Part):(Product)" with command "UPDATE" for record "E1"
And I set field "epe" to "Stück"
And I set field "feple" to "1"
And I save the current editor

Scenario: VK Kaufm. GS zu RLS (VK) - Abschliessen eines RLS mit 0 KGS
#
# AU102 --------------- RE1021
# 100 St. zu 10         50 St. zu 11 (1!)
# | Aktion | remge |    | Aktion | remge |
# |        |100 St.|    |        |  0 St.|
# | (1)    | 50 St.|
# | (2)    | 20 St.|
#    \
#      --------------------- RE1022
#      \                     30 St. zu 12 (2!)
#       \                    | Aktion | remge |
#        \                   |        |  0 St.|
#         \
#           --------------------  LS102 --------------- RLS102 --------------  KGS102 (Preise aus RE1021, RE1022)
#                                 90 St. (3!)           -85 St. (4!)           65 St. (45 zu 11 und 20 zu 12) (5!) RLS abgelegt
#                                 | Aktion | remge |    | Aktion | remge  |    | Aktion | remge  | herkunft |
#                                 |        |  0 St.|    |        | -65 St.|    |        | -45 St.| RE1021   |
#                                                        \                |             | -20 St.| RE1022   |
#                                                         \
#                                                           ---------------------- KGS1022 (Preise aus RE1021) nicht buchen
#                                                                   0 St. (6!)

# Auftrag anlegen
Given I open an editor "AU102" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | vom    | .     |
   | tterm  | .     |
   | such   | AU102 |
And I append rows
   | artikel | mge | preis |
   | V1      | 100 |    10 |
And I save the current editor

# Teilrechnung zum AU
Given I open an editor "RE1021" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU102"
And I set fields
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | fakt   | nein   |
   | such   | RE1021 |
And I set field "mge" to "50" in row 1
And I set field "preis" to "11" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Teilrechnung zum AU
Given I open an editor "RE1022" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU102"
And I set fields
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | RE1022 |
And I set field "mge" to "30" in row 1
And I set field "preis" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# LS anlegen
Given I open an editor "LS102" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU102"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | LS102 |
And I set field "mge" to "90" in row 1
And I save the current editor

# Ruecklieferung des LS
Given I open an editor "RLS102" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS102"
And I set fields
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | RLS102 |
And I set field "mge" to "-85" in row 1
And I save the current editor

# RLS gutschreiben
Given I open an editor "KGS102" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS102"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then the table has 2 rows
Then table has values
    | art  | mge | preis | remge | herkunft^kopf^such |
    | V1   | -45 | 11.00 | -45   | RE1021             |
    | V1   | -20 | 12.00 | -20   | RE1022             |
And I set fields
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | KGS102 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# RLS kann nicht mehr gutgeschrieben werden
Given I open an editor "KGS1022" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS102"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then the table has 1 rows
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such |
    | V1  | 0   | 11.00 | 0     | RE1021             |
And I close the current editor

#----------------------------------------------------------------------------------------------
# TSQ-GUTSCHRIFT-08: Einkauf -> Rechnung mit verrechneten Positionen stornieren
#----------------------------------------------------------------------------------------------

Scenario: Rechnung mit verrechneten Positionen stornieren
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE01" throws the exception "2006"

Scenario: VK Kaufm. GS zu RLS (VK) - Abschliessen eines RLS mit 0 KGS
#
#       RE1011 RE1012 RE1013
#       (10)   (20)   (70)
#       /      /     /
# LS101 ----------------> RLS101 -> KGS101
# (100)                  (-100)   (-10!)
#                                 (-20!)
#                                 (-70!)
#
# LS anlegen
Given I open an editor "LS101" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | LS101 |
And I append rows
   | artikel | mge | preis |
   | V1      | 100 |    10 |
And I save the current editor


# Teilrechnung zum LS
Given I open an editor "RE1011" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS101"
And I set fields
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | RE1011 |
And I set field "mge" to "10" in row 1
And I set field "preis" to "11" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilrechnung zum LS
Given I open an editor "RE1012" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS101"
Then setting field "vorganga" to "Kaufmännische Gutschrift" throws the exception "131"
And I set fields
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | RE1012 |
And I set field "mge" to "20" in row 1
And I set field "preis" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilrechnung zum LS
Given I open an editor "RE1013" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS101"
Then setting field "vorganga" to "Kaufmännische Gutschrift" throws the exception "131"
And I set fields
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | RE1013 |
And I set field "mge" to "70" in row 1
And I set field "preis" to "13" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung des LS
Given I open an editor "RLS101" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS101"
And I set fields
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | RLS101 |
And I set field "mge" to "-100" in row 1
And I save the current editor

# RLS gutschreiben
Given I open an editor "KGS101" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS101"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then the table has 3 rows
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such |
    | V1  | -10 | 11.00 | -10   | RE1011             |
    | V1  | -20 | 12.00 | -20   | RE1012             |
    | V1  | -70 | 13.00 | -70   | RE1013             |
And I close the current editor

#----------------------------------------------------------------------------------------------
# TSQ-GUTSCHRIFT-10: VK -> RLS1, RLS2, kGS aus Beiden erstellen und speichern. Erste Position in KGS loeschen und buchen.
#  Pruefen, dass nur RLS2 in der Ablage ist.
#----------------------------------------------------------------------------------------------

Scenario: 10 Lieferschein zu einem Auftrag anlegen, liefern und buchen, Rechnung, rueckliefern und kaufm. Gutschrift erstellen
# Auftrag mit 3 normalen Positionen
Given I open an editor "auftrag10" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "010"
And I set field "kunde" to id from editor "kunde"
And I append rows
| artikel  | mge  |
| artikel1 | 10   |
| artikel2 | 12   |
| artikel3 | 10   |
And I save the current editor

# Lieferschein fuer Pos 1 und 2
Given I open an editor "vk1ls10" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag10"
And I set fields
   | nummer | 010-VKLS |
   | budat  | .        |
   | ueb    | ja       |
   | such   | LS10     |
And I set field "mge" to "10" in row 1
And I set field "mge" to "12" in row 2
And I save the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "vk1re10" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "vk1ls10"
And I set fields
   | num3 | 010-VKRE |
   | vom  | .        |
   | ueb  | ja       |
   | such | RE10     |
   | kenn | FALL-010 |
And I set field "mge" to "10" in row 1
And I set field "preis" to "12" in row 1
And I set field "mge" to "12" in row 2
And I set field "preis" to "12" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#1. Lieferschein rueckliefern RLS1
Given I open an editor "vkrueck13" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "vk1ls10"
Then field "lsart" has value "Rücklieferschein"
And I set fields
 | nummer | 013-RLS |
 | ueb    | ja      |
 | such   | RLS13   |
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-3" in row 2
Then field "rerelev" has value "ja" in row 1
And I save the current editor

#2. Lieferschein rueckliefern RLS2
Given I open an editor "vkrueck14" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "vk1ls10"
Then field "lsart" has value "Rücklieferschein"
And I set fields
 | nummer | 014-RLS |
 | ueb    | ja      |
 | such   | RLS14   |
And I set field "mge" to "-4" in row 1
And I set field "mge" to "-3" in row 2
Then field "rerelev" has value "ja" in row 1
And I save the current editor

# Kaufmaennische Gutschrift zu erster Ruecklieferung anlegen und zweite Ruecklieferung anfuegen
Given I open an editor "vkgut10" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "vkrueck13"
And I set field "nummer" to "010KGS"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "lsart" has value ""
And I set field "beleg" to id from editor "vkrueck14"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "vkgut10" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "vkgut10"
And I delete row at position 1
And I save the current editor

# Noch nicht abgelegt
Then "(Sales):(PackingSlip)" with the editor id "vkrueck13" is not filed
Then "(Sales):(PackingSlip)" with the editor id "vkrueck14" is not filed

Given I open an editor "vkgut10" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "vkgut10"
And I set field "ueb" to "ja"
And I save the current editor

# Nur RLS14 ist abgelegt
Then "(Sales):(PackingSlip)" with the editor id "vkrueck13" is not filed
Then "(Sales):(PackingSlip)" with the editor id "vkrueck14" is filed

#----------------------------------------------------------------------------------------------
# TSQ-GUTSCHRIFT-11: VK -> RLS -> KGS, nur speichern. In KGS alle Zeilen löschen, buchen und speichern. RLS ist nicht abgelegt.
#----------------------------------------------------------------------------------------------
Scenario: Bei leerer kaufm. Gutschrift, Pruefung dass zugehoeriger RLS nicht in die Ablage geht

# Auftrag anlegen
Given I create a SalesOrder "AU11" for Customer "1" with Product "V1" and quantity "20" and price "11"

# Lieferschein fuer erste Position buchen
Given I deliver the SalesOrder "AU11" with PackingSlip "LS11"

# Ruecklieferung erstellen
Given I open an editor "RLS11" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS11"
Then I set field "such" to "RLS11"
Then I set field "ueb" to "ja"
Then I set field "mge" to "-1" in row !lastRow
And I save the current editor

# KGS zu RLS11 erzeugen
Given I open an editor "KGS11" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS11"
And I set field "vom" to "."

And I set field "tterm" to "."
Then the table has 1 rows
Then table has values
    | artikel | mge  |
    | V1      |  0   |
And I save the current editor

Given I open an editor "KGS11" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "KGS11"
And I delete all rows
And I set field "ueb" to "ja"
And I save the current editor

# Pruefen ob RLS11 aktiv ist, muss nicht in die Ablage gegangen sein.
Given I open an editor "RLS11" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "RLS11"
Then field "ablagef" has value "ja"
And I close the current editor

#---------------------------------------------------------------------------------------------
# TSQ-GUTSCHRIFT-20: Einkauf -> Kontopruefung in Zusatzpositionen bei kaufm. Gutschriften
#                    Bei einem Bestandskonto wird 'gemeckert', aber nicht abgebrochen
#----------------------------------------------------------------------------------------------
Scenario: Kontopruefung in einer Zusatzposition bei kaufm. Gutschrift

# Bestellung anlegen
Given I create a PurchaseOrder "BE55" for Vendor "1" with Product "E1" and quantity "20" and price "3"

# Lieferung
Given I open an editor "LS55" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE55"
And I set field "nummer" to "55LS"
And I set field "such" to "LS55"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I save the current editor

# Berechne die Lieferung
Given I open an editor "RE55" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "LS55"
And I set fields
   | ebeleg | RE55 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE55 |
And I set field "mge" to "20" in row 1
And I set field "preis" to "2,75" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung des LS
Given I open an editor "RLS55" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS55"
And I set field "nummer" to "55RLS"
And I set field "such" to "RLS55"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I save the current editor

# RL gutschreiben ->  kaufm. Gutschrift erstellen
Given I open an editor "KGS55" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS55"
And I set field "nummer" to "55KGS"
And I set field "such" to "KGS55"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I create a new row at position 2
And I set field "artikel" to "NEUPOS" in row 2
And I set field "pwert" to "-2.00" in row 2
And I set field "konto" to "10000" in row 2
And I create a new row at position 3
And I set field "artikel" to "TEXT" in row 3
And I set field "pwert" to "-3.00" in row 3
And I set field "konto" to "10000" in row 3
And I respond with answer "ja" to the dialog with id "4970"
And I respond with answer "ja" to the dialog with id "4970"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nach dem Speichern KGS noch einmal oeffnen und verbuchen
Given I open an editor "KGS55V" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KGS55"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "ueb" to "ja"
And I set field "fixkonto" to "nein" in row 3
Then field "konto" has value "50000" in row 3
And I respond with answer "ja" to the dialog with id "4970"
And I save the current editor

Scenario: Vorbelegungsmenge KGS (zunaechst Die noch nicht berechneten aber gelieferten beruecksichtigen)
#
#                  RE51
#                  (20 zu 5)
#                  /
#                 /
# BE51 -------> LS51 ---> RLS51  -> KGS51 (Preis aus RE51)
# (60 zu 3)     (55)      (40)      (5 zu 5) (Annahme: 40 zurueck, zunaechst die noch nicht bezahlten, aber gelieferten (35) abziehen, dann noch 5 bezahlte)
#

# Bestellung anlegen
Given I create a PurchaseOrder "BE51" for Vendor "1" with Product "E1" and quantity "60" and price "3"

# Liefere die Bestellung (Teil)
Given I open an editor "LS51" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE51"
And I set fields
   | ebeleg | LS51 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS51 |
And I set field "mge" to "55" in row 1
And I save the current editor

# Teilrechnung zum LS
Given I open an editor "RE51" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS51"
And I set fields
   | ebeleg | RE51 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE51 |
And I set field "mge" to "20" in row 1
And I set field "preis" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Ruecklieferung des LS
Given I open an editor "RLS51" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS51"
And I set fields
   | ebeleg | RLS51 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RLS51 |
And I set field "mge" to "-40" in row 1
And I save the current editor

# Kaufm GS zu Ruecklieferschein
Given I open an editor "KGS51" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS51"
Then the table has 1 rows
Then table has values
    | art | mge | preis | remge | herkunft^kopf^such |
    | E1  | -5  | 5.00  | -5    | RE51               |
And I close the current editor

#---------------------------------------------------------------------------------------------
Scenario: VK -> AU -> LS -> RE -> RLS -> pwert in KGS aendern -> KGS zeigen
#         Positionswert wird aus der KGS genommen
#----------------------------------------------------------------------------------------------

# Auftrag anlegen
Given I open an editor "AU12" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1     |
   | num3  | 12-AU |
And I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "12" in row 1
And I set field "preis" to "12" in row 1
And I set field "proz" to "-5" in row 1
And I save the current editor

# Lieferschein
Given I open an editor "VKLS12" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU12"
And I set fields
   | nummer | 12-VKLS |
   | budat  | .       |
   | ueb    | ja      |
   | such   | LS12    |
And I set field "mge" to "12" in row 1
And I save the current editor

# RE zu LS12 erzeugen
Given I open an editor "RE12" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "LS12"
And I set fields
   | vom   | .  |
   | tterm | .  |
   | ueb   | ja |
Then table has values
    | artikel | mge  | proz |
    | V1      | 12   |  -5  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung erstellen
Given I open an editor "RLS12" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+LS12"
And I set fields
   | nummer | 12-VKRLS |
   | such   | RLS12    |
   | ueb    | ja       |
Then I set field "mge" to "-12" in row 1
And I save the current editor

# KGS zu RLS12 erzeugen
Given I open an editor "KGS12" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS12"
And I set fields
   | vom   | .  |
   | tterm | .  |
Then I set field "pwert" to "-50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KGS12" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KGS12"
Then field "proz" has value "-65.28" in row 1
And I close the current editor

#---------------------------------------------------------------------------------------------
Scenario: AU -> LS -> RE (Pauschalpreis) -> RLS (Teilruecklieferung) -> KGS
#         Pauschalpreis wird anteilig zur Menge aus der Rechnung entnommen.
#----------------------------------------------------------------------------------------------

# Auftrag anlegen
Given I open an editor "AU13" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | nummer | 13-AU |
   | such   | AU13  |
And I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "13" in row 1
And I set field "preis" to "0" in row 1
And I set field "pwert" to "1300" in row 1
And I save the current editor

# Lieferschein
Given I open an editor "VKLS13" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AU13"
And I set fields
   | nummer | 13-VKLS |
   | such   | LS13    |
   | budat  | .       |
   | ueb    | ja      |
And I set field "mge" to "13" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE13" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "LS13"
And I set fields
   | nummer | 13-VKRE |
   | such   | RE13    |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "pwert" to "1500" in row 1
Then table has values
    | artikel | mge  | pwert    |
    | V1      | 13   |  1500.00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS13" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+LS13"
And I set fields
   | nummer | 13-VKRLS |
   | such   | RLS13    |
   | ueb    | ja       |
Then I set field "mge" to "-10" in row 1
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS13" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS13"
And I set fields
   | nummer | 13-VKKGS |
   | such   | KGS13    |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
Then field "pwert" has value "-1153.85" in row 1
And I set field "mge" to "-5" in row 1
Then field "pwert" has value "-576.92" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#---------------------------------------------------------------------------------------------
Scenario: Mengenverrechnung bei AUBE-Zusatzpositionen
#---------------------------------------------------------------------------------------------
#
# BE15 ---------------- RE15
# 20 St. zu 3           7 St. zu 4
#       \
#         ---------------- RE15-2
#         \                6 St. zu 5
#          \
#            ---------------- LS15 ------- RLS15 ------- KGS15 ---------------- KGS15S Storno
#                             15 St.      -15 St.       -7 St.
#                                                       -1 St.
#                                                       (Preise aus RE15, RE15-2)

# Bestellung anlegen
Given I create a PurchaseOrder "BE15" for Vendor "1" with Product "AUBE" and quantity "20" and price "3"

# Teilrechnung zur Bestellung
Given I open an editor "RE15" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE15"
And I set fields
   | ebeleg | RE15 |
   | vom    | .    |
   | ueb    | ja   |
   | such   | RE15 |
And I set field "mge" to "7" in row 1
And I set field "preis" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilrechnung zur Bestellung
Given I open an editor "RE15-2" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE15"
And I set fields
   | ebeleg | RE15-2 |
   | vom    | .      |
   | ueb    | ja     |
   | such   | RE15-2 |
And I set field "mge" to "6" in row 1
And I set field "preis" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teillieferung zur Bestellung
Given I open an editor "LS15" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE15"
And I set fields
   | ebeleg | LS15 |
   | vom    | .    |
   | ueb    | ja   |
   | such   | LS15 |
And I set field "mge" to "15" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor

# Komplette Ruecklieferung
Given I return the PurchasingPackingSlip "LS15" with ReturnPackingSlip "RLS15"

# Kaufm. Gurtschrift zur Ruecklieferung
Given I open an editor "KGS15" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS15"
Then the table has 2 rows
Then table has values
   | art   | mge | preis | remge | herkunft^kopf^such |
   | AUBE  | -2  | 4.00  | -2    | RE15               |
   | AUBE  | -6  | 5.00  | -6    | RE15-2             |
And I set fields
   | ebeleg | KGS15 |
   | vom    | .     |
   | ueb    | ja    |
   | such   | KGS15 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefung der verrechneten Menge
Given I open an editor "KGS15V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS15"
Then the table has 5 rows
Then table has values
   | art  | mge | herkunft^kopf^such | herkunft^verrechmge |
   | AUBE | -2  | RE15               | 2                   |
   | AUBE | -6  | RE15-2             | 6                   |
And I close the current editor

# Kaufm. Gutschrift stornieren
Given I open an editor "KGS15S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS15"
And I save the current editor

# Pruefung der verrechneten Menge
Given I open an editor "KGS15V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS15"
Then the table has 5 rows
Then table has values
   | art  | mge | herkunft^kopf^such | herkunft^verrechmge |
   | AUBE | -2  | RE15               | 0                   |
   | AUBE | -6  | RE15-2             | 0                   |
And I close the current editor

#---------------------------------------------------------------------------------------------
Scenario: Mengenverrechnung bei AUBE-Zusatzpositionen (Storno Rechnung -> Kaufm. Gutschrift)
#---------------------------------------------------------------------------------------------
#
# BE16 ---------------- RE16 -------------------- RE16S
# 20 St. zu 3           15 St. zu 4              -15 St.
#       \
#         ------------------- LS16 ------- RLS16 -------- KGS16
#                             15 St.      -15 St.         0 St.

# Bestellung anlegen
Given I open an editor "BE16" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1     |
   | such   | BE16  |
And I append rows
   | artikel | mge | preis  |
   | AUBE    | 20  | 3      |
And I save the current editor

# Rechnung
Given I open an editor "RE16" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE16"
And I set fields
   | ebeleg | RE16 |
   | vom    | .    |
   | ueb    | ja   |
   | such   | RE16 |
And I set field "mge" to "15" in row 1
And I set field "preis" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferung
Given I open an editor "LS16" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE16"
And I set fields
   | ebeleg | LS16 |
   | vom    | .    |
   | ueb    | ja   |
   | such   | LS16 |
And I set field "mge" to "15" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS16" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+LS16"
And I set fields
   | ebeleg | RLS16 |
   | vom    | .     |
   | ueb    | ja    |
   | such   | RLS16 |
And I set field "mge" to "-15" in row 1
And I save the current editor

# Storno Rechnung
Given I open an editor "RE16S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE16"
And I save the current editor

# Kaufm. Gutschrift zur Ruecklieferung
Given I open an editor "KGS16" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS16"
Then the table has 1 rows
Then table has values
   | art   | mge | preis | remge |
   | AUBE  | 0   | 5.00  | 0     |
And I close the current editor

#---------------------------------------------------------------------------------------------
Scenario: VK - Ruecklieferung und kaufmaennische Gutschrift mit Restmengenstorno
#---------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU111" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU111 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge          | preis       | pwert       |
   | V1      |  10          | 10          | !dontChange |
   | NEUPOS  | !dontChange  | !dontChange | 10          |
And I save the current editor

# Lieferschein aus Auftrag
Given I open an editor "1LS111" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | beleg  | 1AU111 |
   | nummer | 1LS111 |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung aus Lieferschein
Given I open an editor "1RE111" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS111"
And I set fields
   | nummer | 1RE111 |
   | ueb    | ja     |
   | tterm  | .      |
And I set field "mge" to "10" in row 1
And I set field "pwert" to "10" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "1LS111R" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS111"
And I set fields
   | nummer | 1LS111R |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-6" in row 1
And I save the current editor

# Kaufm. Gutschrift mit Restmengenstorno
Given I open an editor "1KGS111" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS111R"
And I set fields
   | nummer | 1KGS111 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-3" in row 1
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I set field "pwert" to "-10" in row 2
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1LS111R" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "1LS111R" is filed

# Kaufm. Gutschrift stornieren
Given I open an editor "1KGS111S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1KGS111"
And I set fields
   | nummer | 1KGS111S |
And I save the current editor

Then field "remge" from editor "1LS111R" in row 1 has value "-6"
Then "(Sales):(PackingSlip)" with the editor id "1LS111R" is not filed

#---------------------------------------------------------------------------------------------
Scenario: EK - Ruecklieferung und kaufmaennische Gutschrift mit Restmengenstorno
#---------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE112" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE112 |
   | lief   | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge          | preis       | pwert       |
   | E2      |  10          | 10          | !dontChange |
   | NEUPOS  | !dontChange  | !dontChange | 10          |
And I save the current editor

# Lieferschein aus Bestellung
Given I open an editor "1LS112" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | beleg  | 1BE112 |
   | nummer | 1LS112 |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung aus Lieferschein
Given I open an editor "1RE112" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS112"
And I set fields
   | nummer | 1RE112 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "10" in row 1
And I set field "pwert" to "10" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "1LS112R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS112"
And I set fields
   | nummer | 1LS112R |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-6" in row 1
And I save the current editor

# Kaufm. Gutschrift mit Restmengenstorno
Given I open an editor "1KGS112" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS112R"
And I set fields
   | nummer | 1KGS112 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-3" in row 1
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1LS112R" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1LS112R" is filed

# Kaufm. Gutschrift stornieren
Given I open an editor "1KGS112S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1KGS112"
And I set fields
   | nummer | 1KGS112S |
And I save the current editor

Then field "remge" from editor "1LS112R" in row 1 has value "-6"
Then "(Purchasing):(PackingSlip)" with the editor id "1LS112R" is not filed

#---------------------------------------------------------------------------------------------
Scenario: EK - Ruecklieferung und kaufmaennische Gutschrift vor Rechnung
#---------------------------------------------------------------------------------------------

# Bestellung anlegen mit neutraler Zusaztposition und 2 Artikeln
Given I open an editor "1BE17" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE17  |
   | lief   | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge          | preis       | pwert       |
   | NEUPOS  | !dontChange  | !dontChange | 10          |
   | E1      |  10          | 10          | !dontChange |
   | E2      |  5           | 20          | !dontChange |
And I save the current editor

# Lieferschein aus Bestellung und nur die ersten beiden Position buchen
Given I open an editor "1LS17" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | beleg  | 1BE17 |
   | nummer | 1LS17 |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I delete row at position 3
And I save the current editor

# Bestellung ist noch nicht in der Ablage
Given I open an editor "1BE17V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE17"
Then field "ablagef" has value "nein"
And I close the current editor

# Rechnung aus Lieferschein anlegen und speichern, nicht buchen
Given I open an editor "1RE17" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS17"
And I set fields
   | nummer | 1RE17 |
   | ueb    | nein   |
   | vom    | .      |
And I set field "pwert" to "10" in row 1
And I set field "mge" to "10" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# In der Bestellung die letzte Position stornieren => Bestellung ist jetzt abgelegt
Given I open an editor "1BE17U" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "1BE17"
# Wollen Sie wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 3
And I save the current editor

# Bestellung ist in der Ablage
Given I open an editor "1BE17V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE17"
Then field "ablagef" has value "ja"
And I close the current editor

# Ruecklieferung aus Lieferschein anlegen und buchen
Given I open an editor "1LS17R" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS17"
And I set fields
   | nummer | 1LS17R  |
   | ueb    | ja      |
   | vom    | .       |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Kaufmännische Gutschrift aus Rücklieferschein anlegen und speichern, nicht buchen
Given I open an editor "1KGS17" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS17R"
And I set fields
   | nummer | 1KGS17  |
   | ueb    | nein    |
   | vom    | .       |
# Es kann noch nichts gutgeschreiben werden, da Rechnung nicht gebucht ist.
Then field "pwert" has value "0.00" in row 1
Then field "pwert" has value "0.00" in row 2
And I save the current editor

# Offener Vorgang an RLS
Given I open an editor "1LS17RV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS17R"
Then field "ablagef" has value "ja"
Then field "re" has value "1" in row 1
Then field "re" has value "1" in row 2
And I close the current editor

# Rechnung buchen
Given I open an editor "1RE17B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "1RE17"
And I set field "ueb" to "ja"
And I save the current editor

# KGS buchen
Given I open an editor "1KGS17B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "1KGS17"
And I set field "ueb" to "ja"
And I save the current editor

# Kein offener Vorgang an RLS
Given I open an editor "1LS17RV" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS17R"
Then field "ablagef" has value "ja"
Then field "re" has value "0" in row 1
Then field "re" has value "0" in row 2
And I close the current editor


#---------------------------------------------------------------------------------------------
Scenario: VK -  Ruecklieferung und kaufmaennische Gutschrift vor Rechnung
#---------------------------------------------------------------------------------------------

# Auftrag anlegen mit Textposition und 2 Artikeln
Given I open an editor "1AU17" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU17  |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge          | preis       | pwert       |
   | TEXT    | !dontChange  | !dontChange | 10          |
   | E1      |  10          | 10          | !dontChange |
   | E2      |  5           | 20          | !dontChange |
And I save the current editor

# Lieferschein aus Auftrag und nur die ersten beiden Position buchen
Given I open an editor "1LS17" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | beleg  | 1AU17  |
   | nummer | 1LS17  |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I delete row at position 3
And I save the current editor

# Auftrag ist noch nicht in der Ablage
Given I open an editor "1AU17V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU17"
Then field "ablagef" has value "nein"
And I close the current editor

# Rechnung aus Lieferschein anlegen und speichern, nicht buchen
Given I open an editor "1RE17" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS17"
And I set fields
   | nummer | 1RE17  |
   | ueb    | nein   |
   | vom    | .      |
   | tterm  | .      |
And I set field "pwert" to "10" in row 1
And I set field "mge" to "10" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Im Auftrag die letzte Position stornieren => Auftrag ist jetzt abgelegt
Given I open an editor "1AU17U" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU17"
# Wollen Sie wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 3
And I save the current editor

# Auftrag ist in der Ablage
Given I open an editor "1AU17V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU17"
Then field "ablagef" has value "ja"
And I close the current editor

# Ruecklieferung aus Lieferschein anlegen und buchen
Given I open an editor "1LS17R" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS17"
And I set fields
   | nummer | 1LS17R  |
   | ueb    | ja      |
   | vom    | .       |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Kaufmännische Gutschrift aus Rücklieferschein anlegen und speichern, nicht buchen
Given I open an editor "1KGS17" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS17R"
And I set fields
   | nummer | 1KGS17  |
   | ueb    | nein    |
   | vom    | .       |
   | tterm  | .       |
# Es kann noch nichts gutgeschreiben werden, da Rechnung nicht gebucht ist.
Then field "pwert" has value "0.00" in row 1
Then field "pwert" has value "0.00" in row 2
And I save the current editor

# Offener Vorgang an RLS
Given I open an editor "1LS17RV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS17R"
Then field "ablagef" has value "ja"
Then field "re" has value "1" in row 1
Then field "re" has value "1" in row 2
And I close the current editor

# Rechnung buchen
Given I open an editor "1RE17B" from table "(Sales):(Invoice)" with command "UPDATE" for record "1RE17"
And I set field "ueb" to "ja"
And I save the current editor

# KGS buchen
Given I open an editor "1KGS17B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "1KGS17"
And I set field "ueb" to "ja"
And I save the current editor

# Kein offener Vorgang an RLS
Given I open an editor "1LS17RV" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS17R"
Then field "ablagef" has value "ja"
Then field "re" has value "0" in row 1
Then field "re" has value "0" in row 2
And I close the current editor

#---------------------------------------------------------------------------------------------
Scenario: EK - Uebernahme Inline-Rabatt in Kaufm. Gutschriften
#---------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE18" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE18  |
   | lief   | 1      |
   | vom    | .      |
And I append rows
   | artikel    | mge  | preis | proz |
   | E2         | 10   | 10    | -10  |
   | AUBE       | 10   | 10    | -10  |
   | DL-ANALYSE | 10   | 10    | -10  |
And I save the current editor

# Lieferschein
Given I open an editor "1LS18" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | beleg  | 1BE18 |
   | nummer | 1LS18 |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# Rechnung
Given I open an editor "1RE18" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS18"
And I set fields
   | nummer | 1RE18 |
   | ueb    | ja    |
   | vom    | .     |
And I set field "proz" to "-20" in row 1
And I set field "proz" to "-20" in row 2
And I set field "proz" to "-20" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "1RLS18" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS18"
And I set fields
   | nummer | 1RLS18 |
   | ueb    | ja     |
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-1" in row 2
And I set field "mge" to "-1" in row 3
And I save the current editor

# Kaufm. Gutschrift
Given I open an editor "1KGS18" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS18"
And I set fields
   | nummer | 1KGS18  |
   | ueb    | ja      |
   | vom    | .       |
Then field "proz" has value "-20" in row 1
Then field "proz" has value "-20" in row 2
Then field "proz" has value "-20" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#---------------------------------------------------------------------------------------------
Scenario: VK - Uebernahme Inline-Rabatt in Kaufm. Gutschriften
#---------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU18" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU18  |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel    | mge  | preis | proz |
   | V1         | 10   | 10    | -10  |
   | AUBE       | 10   | 10    | -10  |
   | DL-ANALYSE | 10   | 10    | -10  |
And I save the current editor

# Lieferschein
Given I open an editor "1LS18" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU18"
And I set fields
   | nummer | 1LS18 |
   | ueb    | ja    |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# Rechnung
Given I open an editor "1RE18" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS18"
And I set fields
   | nummer | 1RE18 |
   | ueb    | ja    |
   | tterm  | .     |
And I set field "proz" to "-20" in row 1
And I set field "proz" to "-20" in row 2
And I set field "proz" to "-20" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "1RLS18" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS18"
And I set fields
   | nummer | 1RLS18 |
   | ueb    | ja     |
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-1" in row 2
And I set field "mge" to "-1" in row 3
And I save the current editor

# Kaufm. Gutschrift
Given I open an editor "1KGS18" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1RLS18"
And I set fields
   | nummer | 1KGS18  |
   | ueb    | ja      |
   | tterm  | .       |
Then field "proz" has value "-20" in row 1
Then field "proz" has value "-20" in row 2
Then field "proz" has value "-20" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#---------------------------------------------------------------------------------------------
Scenario: EK - Die Umrechnungsfaktoren lehe und pehe sind im Ruecklieferschein aenderbar
#---------------------------------------------------------------------------------------------

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "kette"
And I set fields
   | such     | kette  |
   | namebspr | Kette  |
   | vpr      | 10.00  |
   | vhe      | Stück  |
   | fvhle    | 10     |
   | le       | g      |
   | vpe      | g      |
   | ehe      | Stück  |
   | fehle    | 10     |
   | epe      | g      |
   | lief     | 1      |
   | epr      | 5.00   |
And I save the current editor

# Bestellung anlegen
Given I open an editor "1BE19" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "nummer" to "1BE19"
And I set field "lief" to "1"
And I append rows
    | pnum | artex  | mge |
    | 1    | kette  | 2   |
And I save the current editor

#Lieferschein aus Bestellung erzeugen
Given I open an editor "1LS19" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE19"
And I set field "nummer" to "1LS19"
And I set field "ebeleg" to "LS19"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "10" in row 1
And I save the current editor

#Rechnung aus Lieferschein erzeugen
Given I open an editor "1RE19" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS19"
And I set field "nummer" to "1RE19"
And I set field "ebeleg" to "RE19"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Ruecklieferung aus Lieferschein erzeugen
Given I open an editor "1RLS19" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS19"
And I set field "nummer" to "1RLS19"
And I set field "ueb" to "ja"
And I set field "mge" to "-1" in row 1
And I set field "lehe" to "11" in row 1
Then field "pehe" is modifiable in row 1
Then field "pehe" has value "11" in row 1
And I save the current editor

#Kaufmaennische Gutschrift aus Ruecklieferung erzeugen
Given I open an editor "1KGS19" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS19"
And I set field "nummer" to "1KGS19"
And I set field "ebeleg" to "KGS19"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then field "pwert" has value "-55.00" in row 1
Then field "lehe" is not modifiable in row 1
Then field "pehe" is not modifiable in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
