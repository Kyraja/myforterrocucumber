# *****************************************************************************
#  Name           : zugferd_senden.feature
#  Autor          : sb
#  Verantwortlich : teampss
#  Funktion       : Testet Zugferd Senden Funktionalitaet
#
# *****************************************************************************
#
@persistent
Feature: Export von ZUGFeRD-Sammelrechnungen fuer 2 Mandanten im Comfort Format
# Testdaten fuer den Export von ZUGFeRD-Sammelrechnungen  fuer 2 Mandanten (Comfort Format)
Background:
Given I set the fake date to "02.01.1999"
Given I enable the flag 39

# ----------------------------------------------------------------------------------------------
Scenario Outline: Drei Jahresabschluesse durchfuehren bis 1998
# ----------------------------------------------------------------------------------------------
# Erst ab 1998 ist Buchungswaehrung und Erfassungswaehrung EUR -> ZugFerd funktioniert NICHT mit DEM!
And I set the fake date to "<datum>"
Given I open an editor "abschl<num>" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "nummer" to "200zz<num>"
And I set field "such" to "ABSCHL<num>"
And I set field "such" to "ABSCHL<num>"
And I set field "jastart" to "ja"
And I respond with answer "ja" to the dialog with id "10747"
And I respond with answer "ja" to the dialog with id "7626"
And I save the current editor
And I close the current editor

Examples:
| num| datum      |
| 1  | 02.01.1996 |
| 2  | 02.01.1998 |
| 3  | 02.01.1999 |

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
Scenario: STAMMDATEN - In der Konfiguration muss zugferd aktiv sein
# ----------------------------------------------------------------------------------------------
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "zugferd" to "ja"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Betriebsdaten pflegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "bdaten" from table "(Company):(CompanyData)" with command "UPDATE" for record "1"
And I set fields
    | such     | Zugferd-Ex         |
    | namebspr | ZUGFeRD Export     |
    | knam1    | ZUGFeRD Export     |
    | ans      | ZUGFeRD Export AG  |
    | str      | ZUGFeRD Strasse 20 |
    | plz      | 54321              |
    | nort     | ZUGFeRDstadt       |
    | region   | Baden-Württemberg  |
    | staat    | Deutschland        |
    | tele     | 070010101          |
    | iban     | DE5500000000000025 |
    | gln      | 999888777          |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: USTID in Land eintragen
# ----------------------------------------------------------------------------------------------
Given I open an editor "land" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "deutschland"
And I set field "ustid" to "DE987654321"
And I set field "steunr" to "987654321"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Mitarbeiter anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "zugferdS"
And I set fields
    | such     | zugferdS            |
    | namebspr | ZUGFeRD Mitarbeiter |
    | ans      | ZUGFeRD GmbH        |
    | str      | ZUGFeRD Strasse 12  |
    | plz      | 55555               |
    | nort     | ZUGFeRDstadt        |
    | region   | Bayern              |
    | tele     | 080010100           |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Kunde anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "zugferdS"
And I set fields
    | nummer    | 22233              |
    | such      | zugferdS           |
    | namebspr  | ZUGFeRD Import     |
    | ans       | ZUGFeRD Import AG  |
    | str       | ZUGFeRD Strasse 15 |
    | plz       | 12345              |
    | nort      | ZUGFeRDdorf        |
    | region    | Baden-Württemberg  |
    | ans2      | ZUGFeRD Import AG  |
    | str2      | ZUGFeRD Strasse 15 |
    | plz2      | 12345              |
    | nort2     | ZUGFeRDdorf        |
    | region2   | Baden-Württemberg  |
    | tele      | 070010100          |
    | betreuer  | zugferd            |
    | erechmail | info@abas.de       |
    | ustid     | DE123456789        |
    | steunr    | 123456789          |
    | lbed      | exw                |
    | zbed      | 200                |
    | zaform    | Überweisung        |
    | frbez     | 11122              |
    | gln       | 666555444          |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EDI-Nachricht zugferdi eintragen
# ---------------------------------------------------------------------------------------------
Given I open an editor "edikunde" from table "(Customer):(Customer)" with command "UPDATE" for record "zugferdS"
And I press button "edinfo" to open a subeditor for "edinachricht"
And I create a new row at the end of the table
And I set field "edinachraz" to "ZUGFeRD-Rechnung Export" in row 1
And I set field "ieabmodell" to "4150" in row 1
And I set field "erlaubt" to "ja" in row 1
And I save the current editor
And I switch the current editor to editor "edikunde"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Dienstleistung anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "dl" from table "(Part):(Service)" with command "STORE" for record "dl"
And I set fields
    | such     | dl             |
    | namebspr | Dienstleistung |
    | vpr      | 50             |
    | epr      | 50             |
    | gtin     | GTIN-DL        |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Einheit in Zusatzpositon vom Typ AU/BE eintragen
# ----------------------------------------------------------------------------------------------
Given I open an editor "zupos" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "a."
And I set fields
    | le  | Stück |
    | vhe | Stück |
    | vpe | Stück |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Sammellayout 12762 aktivieren
# ----------------------------------------------------------------------------------------------
Given I open an editor "layout" from table "(PrintParameter):(CollectiveLayout)" with command "UPDATE" for record "12762"
And I set field "such" to "XMLDATAGENS"
And I set field "aktiv" to "ja"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Zuschlags- und Abschlagstyp in Textposition eintragen
# ----------------------------------------------------------------------------------------------
Given I open an editor "text" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "text"
And I set fields
    | zfzutyp | Sonstiges |
    | zfabtyp | Rabatt    |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - GTIN in Artikel eintragen
# ----------------------------------------------------------------------------------------------
Given I open an editor "Artikel" from table "(Part):(Product)" with command "UPDATE" for record "E2"
And I set field "gtin" to "GTIN-E2"
And I save the current editor

Given I open an editor "Artikel" from table "(Part):(Product)" with command "UPDATE" for record "E3"
And I set field "gtin" to "GTIN-E3"
And I save the current editor

Given I open an editor "Artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1"
And I set field "gtin" to "GTIN-E1"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Fall 1 Auftrag - Lieferschein - Rechnung
# ----------------------------------------------------------------------------------------------

Given I open an editor "ab01" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "200SRech"
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Sammelrechnung Fall 1"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  | abnrpo   |
    | 1    | e2     | 15          | 10,5        | -10         |        | 01SBest  |
    | 3    | a.     | 10          | 10          |             |        | 01SBest  |
    | 5    | dl     | 20          | 50          | -5          |        | 01SBest  |
And I save the current editor

#VK-Lieferschein aus Auftrag anlegen
Given I open an editor "vk1lief" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "ab01"
And I set field "nummer" to "300SRech"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

# Rechnung anlegen aus VK-Lieferschein
Given I open an editor "rechnung1" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "vk1lief"
And I set field "nummer" to "400SRech"
And I set field "ueb" to "ja"
And I set field "budat" to "."
# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ZUGFeRD-Rechnung ueber EVVORGANG drucken (Re 400SRech)
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to "+400SRech"
And I press button "bstart"
And I print layout "XMLDATAGENS" with printer "BILDSCHIRM" and filename "dfue/empfangen/factur-x_1.xml" with quantity "1" and copies "1"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario:  Fall 2 Auftrag - 2 Lieferscheine mit fakt = false - Rechnung aus Auftrag
# ----------------------------------------------------------------------------------------------

Given I open an editor "ab02" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "201SRech"
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Sammelrechnung Fall 2"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  | abnrpo  |
    | 1    | e2     | 15          | 10,5        | -10         |        | 02SBest |
    | 3    | a.     | 10          | 10          |             |        | 02SBest  |
    | 5    | dl     | 20          | 50          | -5          |        | 02SBest  |
And I save the current editor

# Lieferschein 1 mit fakt = false anlegen
Given I open an editor "vk3lief" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "ab02"
And I set field "nummer" to "301SRe1"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I set field "mge" to "20" in row 3
And I save the current editor

#Lieferschein 2 mit fakt = false anlegen
Given I open an editor "vk4lief" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "ab02"
And I set field "nummer" to "301SRe2"
And I set field "ueb" to "ja"
And I set field "mge" to "5" in row 1
And I save the current editor

#Rechnung aus Auftrag anlegen
Given I open an editor "rechnung2" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "ab02"
And I set field "nummer" to "401SRech"
And I set field "budat" to "."
And I set field "ueb" to "ja"
# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#ZUGFeRD-Rechnung ueber EVVORGANG drucken (Re 401SRech)
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to "+401SRech"
And I press button "bstart"
And I print layout "XMLDATAGENS" with printer "BILDSCHIRM" and filename "dfue/empfangen/factur-x_2.xml" with quantity "1" and copies "1"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Fall 3 Auftrag - Rechnung - 2 Lieferscheine mit fakt false
# ----------------------------------------------------------------------------------------------
Given I open an editor "ab03" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "202SRech"
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Sammelrechnung Fall 3"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  | abnrpo  |
    | 1    | e2     | 15          | 10,5        | -10         |        | 03SBest |
    | 3    | a.     | 10          | 10          |             |        | 03SBest  |
    | 5    | dl     | 20          | 50          | -10         |        | 03SBest  |
And I save the current editor

#Rechnung anlegen aus Auftrag
Given I open an editor "rechnung3" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "ab03"
And I set field "nummer" to "402SRech"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "budat" to "."
And I set field "mge" to "15" in row 1
And I set field "mge" to "10" in row 2
And I set field "mge" to "20" in row 3
# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#Lieferschein 1 anlegen aus Auftrag mit fakt = false
Given I open an editor "vk5lief" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "ab03"
And I set field "nummer" to "302SRe1"
And I set field "ueb" to "ja"
And I set field "mge" to "10" in row 1
And I set field "mge" to "5" in row 2
And I set field "mge" to "10" in row 3
And I save the current editor

#Lieferschein 2 anlegen aus Auftrag mit fakt = false
Given I open an editor "vk6lief" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "ab03"
And I set field "nummer" to "302SRe2"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

#ZUGFeRD-Rechnung ueber EVVORGANG drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "rechnung3"
And I press button "bstart"
And I print layout "XMLDATAGENS" with printer "BILDSCHIRM" and filename "dfue/empfangen/factur-x_3.xml" with quantity "1" and copies "1"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Fall 4 Zwei Auftraege - Sammellieferschein - Rechnung aus Lieferschein
# ----------------------------------------------------------------------------------------------
Given I open an editor "ab05" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "203SRe1"
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Sammelrechnung Fall 4"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  | abnrpo  |
    | 1    | e2     | 10          | 10,5        |             |        | 05SBest |
    | 3    | a.     | 5           | 10          | -10         |        | 05SBest  |
    | 5    | dl     | 5           | 50          | -10         |        | 05SBest  |
And I save the current editor

#Auftrag anlegen
Given I open an editor "ab06" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "203SRe2"
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Sammelrechnung Fall 4"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  | abnrpo  |
    | 1    | e2     | 5           | 10,5        |             |        | 06SBest |
    | 3    | a.     | 5           | 10          | -10         |        | 06SBest  |
    | 5    | dl     | 5           | 50          | -10         |        | 06SBest  |
And I save the current editor

#Sammellieferschein anlegen aus Auftrag
Given I open an editor "vk8lief" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "ab05"
And I set field "nummer" to "303SRech"
And I set field "beleg" to id from editor "ab06"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 4
And I press button "offueb" in row 5
And I press button "offueb" in row 6
And I press button "offueb" in row 7
And I save the current editor

#Rechnung anlegen aus Lieferschein
Given I open an editor "rechnung4" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "vk8lief"
And I set field "nummer" to "403SRech"
And I set field "ueb" to "ja"
And I set field "budat" to "."
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#ZUGFeRD-Rechnung ueber EVVORGANG drucken (Re 403SRech)
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "rechnung4"
And I press button "bstart"
And I print layout "XMLDATAGENS" with printer "BILDSCHIRM" and filename "dfue/empfangen/factur-x_4.xml" with quantity "1" and copies "1"

# ----------------------------------------------------------------------------------------------
Scenario: Fall 5 : Neue Rechnung mit Lagerbewegung - Wertgutschrift
# ----------------------------------------------------------------------------------------------
# Neue Rechnung anlegen
Given I open an editor "rech1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | nummer  | 404WertG                      |
    | kunde   | zugferdS                      |
    | betreff | Re fuer Wertgutschrift Fall 1 |
    | ueb     | ja                              |
And I append rows
    | pnum | artex  | mge         | preis       |
    | 1    | e2     | 15          | 10,5        |
    | 2    | a.     | 10          | 10          |
    | 3    | dl     | 20          | 50          |
And I save the current editor

#Wertgutschrift zu Rechnung anlegen
Given I open an editor "gut1" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "rech1"
And I set field "nummer" to "504WertG"
And I set field "ebeleg" to "404WertG"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

#ZUGFeRD-Wertgutschrift ueber EVVORGANG drucken (Re 504WertG)
# hier muss ebeleg und/oder kenn übergeben werden beim Export! Ich habe in der Wertgutschrift sonst keinen Bezug 
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "gut1"
And I press button "bstart"
And I print layout "XMLDATAGENS" with printer "BILDSCHIRM" and filename "dfue/empfangen/factur-x_5.xml" with quantity "1" and copies "1"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Fall 6: Auftrag - Lieferschein - Rechnung - Wertgutschrift
# ----------------------------------------------------------------------------------------------
# Auftrag anlegen
Given I open an editor "auf1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | nummer  | 205WertG              |
    | kunde   | zugferdS              |
    | betreff | Wertgutschrift Fall 2 |
And I append rows
    | pnum | artex  | mge         | preis       | abnrpo   |
    | 1    | e2     | 15          | 10,5        | 605WertG |
    | 2    | a.     | 10          | 10          | 605WertG |
    | 3    | dl     | 20          | 50          | 605WertG |
And I save the current editor

#Lieferschein zu Auftrag anlegen
Given I open an editor "vk1lief" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "auf1"
And I set field "nummer" to "305WertG"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

#Rechnung zu Lieferschein anlegen
Given I open an editor "rech2" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "vk1lief"
And I set field "nummer" to "405WertG"
And I set field "ueb" to "ja"
And I save the current editor

#Wertgutschrift zu Rechnung anlegen
Given I open an editor "gut2" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "rech2"
And I set field "nummer" to "505WertG"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

#ZUGFeRD-Wertgutschrift ueber EVVORGANG drucken (Re 505WertG)
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "gut2"
And I press button "bstart"
And I print layout "XMLDATAGENS" with printer "BILDSCHIRM" and filename "dfue/empfangen/factur-x_6.xml" with quantity "1" and copies "1"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Fall 7 Auftrag - Lieferschein ohne fakt - Rechnung auf Auftrag Wertgutschrift
# ----------------------------------------------------------------------------------------------
# Auftrag anlegen
Given I open an editor "auf2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | nummer  | 206WertG              |
    | kunde   | zugferdS              |
    | betreff | Wertgutschrift Fall 3 |
And I append rows
    | pnum | artex  | mge         | preis       | abnrpo   |
    | 1    | e2     | 15          | 10,5        | 606WertG |
    | 2    | a.     | 10          | 10          | 606WertG |
    | 3    | dl     | 20          | 50          | 606WertG |
And I save the current editor

#Lieferschein zu Auftrag anlegen
Given I open an editor "vk2lief" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "auf2"
And I set field "nummer" to "306WertG"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

#Rechnung zu Auftrag anlegen
Given I open an editor "rech3" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "auf2"
And I set field "nummer" to "406WertG"
And I set field "ueb" to "ja"
And I save the current editor

#Wertgutschrift zu Rechnung anlegen
Given I open an editor "gut3" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "rech3"
And I set field "nummer" to "506WertG"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

#ZUGFeRD-Wertgutschrift ueber EVVORGANG drucken (Re 506WertG)
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "gut3"
And I press button "bstart"
And I print layout "XMLDATAGENS" with printer "BILDSCHIRM" and filename "dfue/empfangen/factur-x_7.xml" with quantity "1" and copies "1"
And I close the current editor

