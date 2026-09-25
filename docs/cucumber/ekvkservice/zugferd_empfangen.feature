# *****************************************************************************
#  Name           : zugferd_empfangen.feature
#  Autor          : sb
#  Verantwortlich : teampss
#  Funktion       : Testet Zugferd Empfangen Funktionalitaet
#
# *****************************************************************************
#
@persistent
Feature: Import von ZUGFeRD-Sammelrechnungen fuer 2 Mandanten im Comfort Format
# Testdaten fuer den Export von ZUGFeRD-Sammelrechnungen  fuer 2 Mandanten (Comfort Format)
Background:
Given I set the fake date to "02.01.1999"
Given I enable the flag 39

# ----------------------------------------------------------------------------------------------
Scenario: GJ-Tabelle pruefen
# ----------------------------------------------------------------------------------------------
# Aktuelles Jahr muss 1998 sein (EUR)
Given I open an editor "gjtab" from table "(Company):(FinancialDates)" with command "VIEW" for record "2"
Then table has values
 | gjahr | gjkenn                  |
 | 94    | vergangen               |
 | 95    | vergangen               |
 | 96    | vergangen               |
 | 97    | vorläufig abgeschlossen |
 | 98    | aktuell                 |
 | 99    | neu                     |
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - In der Konfiguration muessen erech und zugferd aktiv sein
# ----------------------------------------------------------------------------------------------
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "zugferd" to "ja"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Betriebsdaten pflegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "bdaten" from table "(Company):(CompanyData)" with command "UPDATE" for record "1"
And I set fields
    | such     | Zugferd-im         |
    | namebspr | ZUGFeRD Import     |
    | knam1    | ZUGFeRD Import     |
    | ans      | ZUGFeRD Import AG  |
    | str      | ZUGFeRD Strasse 15 |
    | plz      | 12345              |
    | nort     | ZUGFeRDdorf        |
    | region   | Baden-Württemberg  |
    | staat    | Deutschland        |
    | tele     | 070010100          |
    | iban     | DE5500000000000030 |
    | gln      | 666555444          |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: USTID in Land eintragen
# ----------------------------------------------------------------------------------------------
Given I open an editor "land" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "deutschland"
And I set field "ustid" to "DE123456789"
And I set field "steunr" to "123456789"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Mitarbeiter anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "zugferd"
And I set fields
    | such     | Zugferd             |
    | namebspr | ZUGFeRD Mitarbeiter |
    | ans      | ZUGFeRD GmbH        |
    | str      | ZUGFeRD Strasse 12  |
    | plz      | 55555               |
    | nort     | ZUGFeRDstadt        |
    | region   | Bayern              |
    | tele     | 080010100           |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Lieferant anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "Zugferd"
And I set fields
    | such     | Zugferd            |
    | namebspr | ZUGFeRD Export     |
    | ans      | ZUGFeRD Export AG  |
    | str      | ZUGFeRD Strasse 20 |
    | plz      | 54321              |
    | nort     | ZUGFeRDstadt       |
    | region   | Baden-Württemberg  |
    | tele     | 080010101          |
    | betreuer | zugferd            |
    | ustid    | DE987654321        |
    | steunr   | 987654321          |
    | lbed     | exw                |
    | zbed     | 200                |
    | zaform   | Lastschrift        |
    | frbez    | 22233              |
    | gln      | 999888777          |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Bankverbindung für Lieferant anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "bank" from table "(BankData):(BankDetails)" with command "STORE" for record "ZUGFERDEXPORTAG"
And I set fields
    | konto | l ZUGFERD          |
    | bank  | 1                  |
    | iban  | DE5500000000000025 |
And I save the current editor

#EDI-Nachricht ZUGFeRD und Bankverbindung eintragen
Given I open an editor "edilieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "Zugferd"
And I set field "bverb" to id from editor "bank"
And I press button "edinfo" to open a subeditor for "edinachricht"
And I create a new row at the end of the table
And I set field "edinachraz" to "ZUGFeRD-Rechnung Import" in row 1
And I set field "ieabmodell" to "4160" in row 1
And I set field "abmodell" to "4161" in row 1
And I set field "erlaubt" to "ja" in row 1
And I set field "suchkonfig" to "11003" in row 1
And I save the current editor
And I switch the current editor to editor "edilieferant"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Dienstleistung anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "dl" from table "(Part):(Service)" with command "STORE" for record "dl"
And I set fields
    | such     | dl             |
    | namebspr | Dienstleistung |
    | vpr      | 50             |
    | lief     | zugferd        |
    | epr      | 50             |
    | bstnr    | 100001         |
    | gtin     | GTIN-DL        |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Einheit in Zusatzpositon vom Typ AU/BE eintragen
# ----------------------------------------------------------------------------------------------
Given I open an editor "zupos" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "a."
And I set fields
    | le       | Stück       |
    | vhe      | Stück       |
    | vpe      | Stück       |
    | ebezbspr | Platzhalter |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Sammellayout 12762 aktivieren
# ----------------------------------------------------------------------------------------------
Given I open an editor "layout" from table "(PrintParameter):(CollectiveLayout)" with command "UPDATE" for record "12762"
And I set field "aktiv" to "ja"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - GTIN in Artikel eintragen
# ----------------------------------------------------------------------------------------------
Given I open an editor "art1" from table "(Part):(Product)" with command "UPDATE" for record "E2"
And I set field "gtin" to "GTIN-E2"
And I save the current editor

Given I open an editor "art2" from table "(Part):(Product)" with command "UPDATE" for record "E3"
And I set field "gtin" to "GTIN-E3"
And I save the current editor

Given I open an editor "art3" from table "(Part):(Product)" with command "UPDATE" for record "E1"
And I set field "gtin" to "GTIN-E1"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario:  Fall 1 Bestellung - 2 Lieferscheine - Rechnung
# ----------------------------------------------------------------------------------------------
Given I open an editor "bestellung01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "nummer" to "01SBest"
And I set field "lief" to id from editor "lieferant"
And I set field "betreff" to "Sammelrechnung Fall 1"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  |
    | 1    | e2     | 15          | 10,5        | -10         |        |
    | 3    | a.     | 10          | 10          |             |        |
    | 5    | dl     | 20          | 50          | -5          |        |
And I save the current editor

#AB-Nummer in Bestellpositionen eintragen
Given I open an editor "bestellung02" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "bestellung01"
And I set field "abnrpo" to "200SRech" in row 1
And I set field "abnrpo" to "200SRech" in row 2
And I set field "abnrpo" to "200SRech" in row 3
And I save the current editor

#EK-Lieferschein 1 aus Bestellung anlegen
Given I open an editor "ek01lief" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "bestellung01"
And I set field "nummer" to "300SRech"
And I set field "ebeleg" to "300SRech"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Fall 2 Bestellung - 2 Lieferschein mit fakt false - Rechnung aus Bestellung
# ----------------------------------------------------------------------------------------------
Given I open an editor "bestellung03" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "nummer" to "02SBest"
And I set field "lief" to id from editor "lieferant"
And I set field "betreff" to "Sammelrechnung Fall 2"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  |
    | 1    | e2     | 15          | 10,5        | -10         |        |
    | 3    | a.     | 10          | 10          |             |        |
    | 5    | dl     | 20          | 50          | -5          |        |
And I save the current editor

#AB-Nummer in Bestellpositionen eintragen
Given I open an editor "bestellung04" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "bestellung03"
And I set field "abnrpo" to "201SRech" in row 1
And I set field "abnrpo" to "201SRech" in row 2
And I set field "abnrpo" to "201SRech" in row 3
And I save the current editor

#Lieferschein 1 aus Bestellung mit fakt = false
Given I open an editor "ek03lief" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "bestellung03"
And I set field "nummer" to "301SRe1"
And I set field "ebeleg" to "301SRe1"
And I set field "fakt" to "nein"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I set field "mge" to "20" in row 3
And I save the current editor

#Lieferschein 2 aus Bestellung mit fakt = false
Given I open an editor "ek04lief" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "bestellung03"
And I set field "nummer" to "301SRe2"
And I set field "ebeleg" to "301SRe2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "5" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Fall 3 Bestellung - Rechnung - 2 Lieferscheine mit fakt false
# ----------------------------------------------------------------------------------------------
Given I open an editor "bestellung05" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "nummer" to "03SBest"
And I set field "lief" to id from editor "lieferant"
And I set field "betreff" to "Sammelrechnung Fall 3"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  |
    | 1    | e2     | 15          | 10,5        | -10         |        |
    | 3    | a.     | 10          | 10          |             |        |
    | 5    | dl     | 20          | 50          | -10         |        |
And I save the current editor

#AB-Nummer in Bestellpositionen eintragen
Given I open an editor "bestellung06" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "bestellung05"
And I set field "abnrpo" to "202SRech" in row 1
And I set field "abnrpo" to "202SRech" in row 2
And I set field "abnrpo" to "202SRech" in row 3
And I save the current editor

#EK-Lieferschein 1 aus Bestellung anlegen mit fakt=false
Given I open an editor "ek05lief" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "bestellung05"
And I set field "ebeleg" to "302SRe1"
And I set field "fakt" to "nein"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "10" in row 1
And I set field "mge" to "5" in row 2
And I set field "mge" to "10" in row 3
And I save the current editor

#EK-Lieferschein 2 aus Bestellung anlegen mit fakt=false
Given I open an editor "ek6lief" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "bestellung05"
And I set field "ebeleg" to "302SRe2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Fall 4 Zwei Bestellungen - Sammellieferschein - Rechnung aus Lieferschein
# ----------------------------------------------------------------------------------------------
Given I open an editor "bestellung09" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "nummer" to "05SBest"
And I set field "lief" to id from editor "lieferant"
And I set field "betreff" to "Sammelrechnung Fall 4"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  |
    | 1    | e2     | 10          | 10,5        | -10         |        |
    | 3    | a.     | 10          | 10          |             |        |
    | 5    | dl     | 5           | 50          | -10         |        |
And I save the current editor

#AB-Nummer in Bestellpositionen eintragen
Given I open an editor "bestellung10" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "bestellung09"
And I set field "abnrpo" to "203SRe1" in row 1
And I set field "abnrpo" to "203SRe1" in row 2
And I set field "abnrpo" to "203SRe1" in row 3
And I save the current editor

#Bestellung 2 anlegen
Given I open an editor "bestellung11" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "nummer" to "06SBest"
And I set field "lief" to id from editor "lieferant"
And I set field "betreff" to "Sammelrechnung Fall 4"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  |
    | 1    | e2     | 5           | 10,5        |             |        |
    | 3    | a.     | 5           | 10          | -10         |        |
    | 5    | dl     | 5           | 50          | -10         |        |
And I save the current editor

#AB-Nummer in Bestellpositionen eintragen
Given I open an editor "bestellung12" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "bestellung11"
And I set field "abnrpo" to "203SRe2" in row 1
And I set field "abnrpo" to "203SRe2" in row 2
And I set field "abnrpo" to "203SRe2" in row 3
And I save the current editor

#Sammellieferschein anlegen aus Bestellung
Given I open an editor "ek08lief" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "bestellung09"
And I set field "nummer" to "303SRech"
And I set field "ebeleg" to "303SRech"
And I set field "beleg" to id from editor "bestellung11"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 4
And I press button "offueb" in row 5
And I press button "offueb" in row 6
And I press button "offueb" in row 7
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Fall 5: Neue Rechnung - Wertgutschrift
# Hier benoetige ich einen Bezug!!!   Geht aktuell noch nicht
# ----------------------------------------------------------------------------------------------
# Neue Rechnung anlegen
Given I open an editor "rech1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief    | Zugferd                       |
    | nummer  | 404WertG                      |
    | ebeleg  | 404WertG                      |
    | betreff | Re fuer Wertgutschirft Fall 1 |
    | ueb     | ja                    |
    | vom     | .                     |
And I append rows
    | pnum | artex  | mge         | preis       |
    | 1    | e2     | 15          | 10,5        |
    | 2    | a.     | 10          | 10          |
    | 3    | dl     | 20          | 50          |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Fall 6: Bestellung - Lieferschein - Rechnung - Wertgutschrift
# ----------------------------------------------------------------------------------------------
# Bestellung anlegen
Given I open an editor "best1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | nummer  | 605WertG              |
    | lief    | Zugferd               |
    | betreff | Wertgutschrift Fall 2 |
And I append rows
    | pnum | artex  | mge         | preis       |
    | 1    | e2     | 15          | 10,5        |
    | 2    | a.     | 10          | 10          |
    | 3    | dl     | 20          | 50          |
And I save the current editor

#AB-Nummer in Bestellpositionen eintragen
Given I open an editor "best2" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "best1"
And I set field "abnrpo" to "205WertG" in row 1
And I set field "abnrpo" to "205WertG" in row 2
And I set field "abnrpo" to "205WertG" in row 3
And I save the current editor

#Lieferschein anlegen
Given I open an editor "ek1lief" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "best1"
And I set fields
    | nummer | 305WertG |
    | ebeleg | 305WertG |
    | ueb    | ja       |
    | vom    | .        |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

#Rechnung anlegen
Given I open an editor "rech2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ek1lief"
And I set fields
    | nummer | 405WertG |
    | ebeleg | 405WertG |
    | ueb    | ja       |
    | vom    | .        |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Fall 7: Bestellung - Lieferschein ohne fakt - Rechnung aus Bestellung - Wertgutschrift
# ----------------------------------------------------------------------------------------------
# Bestellung anlegen
Given I open an editor "best2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | nummer  | 606WertG              |
    | lief    | Zugferd               |
    | betreff | Wertgutschrift Fall 3 |
And I append rows
    | pnum | artex  | mge         | preis       |
    | 1    | e2     | 15          | 10,5        |
    | 2    | a.     | 10          | 10          |
    | 3    | dl     | 20          | 50          |
And I save the current editor

#AB-Nummer in Bestellpositionen eintragen
Given I open an editor "best3" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "best2"
And I set field "abnrpo" to "206WertG" in row 1
And I set field "abnrpo" to "206WertG" in row 2
And I set field "abnrpo" to "206WertG" in row 3
And I save the current editor

#Lieferschein anlegen
Given I open an editor "ek2lief" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "best2"
And I set fields
    | nummer | 306WertG |
    | ebeleg | 306WertG |
    | ueb    | ja       |
    | vom    | .        |
    | fakt   | nein     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

#Rechnung anlegen
Given I open an editor "rech3" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "best2"
And I set fields
    | nummer | 406WertG |
    | ebeleg | 406WertG |
    | ueb    | ja       |
    | vom    | .        |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#XML-Dateien importieren
Scenario: XML-Dateien ueber Infosystem ELINVOICECENTER importieren
Given I open the infosystem "ELINVOICECENTER"
And I press button "buimport"
And I close the current editor

#-----------------------------------------------------------------------------------------------
Scenario: ZUGFeRD-Dateien importieren/Exportdateien umbenennen
# ----------------------------------------------------------------------------------------------
#Abbildungsmodell 4160 normal
Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4160"
And I press start
Then the table has 1 rows
And I press button "buimport"
Then the table has 1 rows
And I close the current editor

Given I open the infosystem "ELINVOICECENTER"
And I set field "datumv" to "02.01.99"
And I set field "datumb" to "02.01.99"
And I press start
Then the table has 7 rows
And I press button "sellall"
And I press button "kbuidentifizierenunduebernehmen"
Then table has values
    | edinr | vorgangstyp     | vom        | vorgangnrextern | edipartner | fotoz          |
    | 8     | Handelsrechnung | 02.01.1999 | 400SRech        | L 60001    | icon:ball_blue |
    | 9     | Handelsrechnung | 02.01.1999 | 401SRech        | L 60001    | icon:ball_blue |
    | 10    | Handelsrechnung | 02.01.1999 | 402SRech        | L 60001    | icon:ball_blue |
    | 11    | Handelsrechnung | 02.01.1999 | 403SRech        | L 60001    | icon:ball_blue |
    | 12    | Gutschrift      | 02.01.1999 | 504WertG        | L 60001    | icon:ball_blue |
    | 13    | Gutschrift      | 02.01.1999 | 505WertG        | L 60001    | icon:ball_blue |
    | 14    | Gutschrift      | 02.01.1999 | 506WertG        | L 60001    | icon:ball_blue |
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario Outline: EK Rechnungen anlegen
# ----------------------------------------------------------------------------------------------
Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "<edifact>"
And I press start

# Objekte indentifizieren
And I press button "kbuobjektsuche"

# Platzhalter A. (AU/BE Pos) Das sollte zuordenbar sein
Then field "artikel" has value "" in row 2
And I set field "artikel" to "A." in row 2

# Das sollte zuordenbar sein
Then field "artikel" has value "A." in row 2

Then field "bausbe" has value "<bausbe>"
Then field "bausls" has value "<bausls>"
Then field "breneu" has value "<breneu>"
Then field "bbeleganfuegen" has value "<bbeleganfuegen>"
Then field "bausrlsre" has value "<bausrlsre>"

And I press button "reneu"

Then field "reek" has value "<rech_id>"
And I close the current editor

# Erstellte Rechnung ausgeben
Given I open an editor "" from table "(Purchasing):(Invoice)" with command "VIEW" for record "<rech_id>"
Then I fill template "EV_VORG_BEI_AUSS.ftl" and append it to output file "../../ref_zugferd_empfangen_cu.out"
And I close the current editor


Examples:
| edifact | rech_id | bausbe | bausls | breneu  | bbeleganfuegen | bausrlsre |
|       8 |       2 | nein   | ja     | nein    | nein           | nein      |
|       9 |       3 | ja     | nein   | nein    | nein           | nein      |
|      10 |       4 | ja     | nein   | nein    | nein           | nein      |
#|      12 |      10 | nein   | nein   | ja      | nein           | ja        | 
|      13 |      5  | nein   | nein   | nein    | nein           | ja        |
|      14 |      6  | nein   | nein   | nein    | nein           | ja        |

# ----------------------------------------------------------------------------------------------
Scenario Outline: nochmal EK Rechnungen anlegen
# ----------------------------------------------------------------------------------------------
Given I open the infosystem "ELINVOICEPROCESS"
And I set field "edifact" to "<edifact>"
And I press start

# Objekte indentifizieren
And I press button "kbuobjektsuche"

# Platzhalter A. (AU/BE Pos) Das sollte zuordenbar sein
Then field "artikel" has value "" in row 2
And I set field "artikel" to "A." in row 2
Then field "artikel" has value "" in row 4
And I set field "artikel" to "A." in row 4

# Das sollte zuordenbar sein
Then field "artikel" has value "A." in row 2
Then field "artikel" has value "A." in row 4

Then field "bausbe" has value "<bausbe>"
Then field "bausls" has value "<bausls>"
Then field "breneu" has value "<breneu>"
Then field "bbeleganfuegen" has value "<bbeleganfuegen>"

And I press button "reneu"

Then field "reek" has value "<rech_id>"
And I close the current editor

# Erstellte Rechnung ausgeben
Given I open an editor "" from table "(Purchasing):(Invoice)" with command "VIEW" for record "<rech_id>"
Then I fill template "EV_VORG_BEI_AUSS.ftl" and append it to output file "../../ref_zugferd_empfangen_cu.out"
And I close the current editor

Examples:
| edifact | rech_id | bausbe | bausls | breneu  | bbeleganfuegen | beaurlsre  |
|      11 |       7 | nein   | ja     | nein    | nein           | nein       |

