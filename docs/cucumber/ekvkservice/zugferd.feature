# ******************************************************************************************************
#  Name           : zugferd.feature
#  Autor          : cl
#  Verantwortlich : cl
#  Kontrolle      : mh
#  Funktion       : Cucumber Tests fuer zugferd Export und Import bis zum Start von IS ELINVOICECENTER
#
# *****************************************************************************************************
#
@persistent
Feature: Testdaten für den Import von ZUGFeRD-Rechnungen
Background:
Given I enable the flag 39
Given I set the fake date to "02.01.1999"

Scenario: STAMMDATEN - In der Konfiguration muessen erech und zugferd aktiv sein
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I press button "bsperremand"
And I set field "edi" to "ja"
And I set field "habel" to "ja"
And I set field "zugferd" to "ja"
And I save the current editor
And I close the current editor

Scenario: Betriebsdaten IBAN eintragen
Given I open an editor "konfiguration" from table "(Company):(CompanyData)" with command "UPDATE" for record "1"
And I set field "iban" to "123456789"
And I save the current editor
And I close the current editor

Scenario: STAMMDATEN - Betriebsdaten pflegen
Given I open an editor "bdaten" from table "(Company):(CompanyData)" with command "UPDATE" for record "1"
And I set fields
    | such     | Zugferd            |
    | namebspr | ZUGFeRD Kunde      |
    | knam1    | ZUGFeRD Kunde      |
    | ans      | ZUGFeRD AG         |
    | str      | ZUGFeRD Strasse 15 |
    | plz      | 44444              |
    | nort     | ZUGFeRDdorf        |
    | region   | Baden-Württemberg  |
    | staat    | Deutschland        |
    | tele     | 070010100          |
And I save the current editor
And I close the current editor

Scenario: STAMMDATEN - Mitarbeiter anlegen
Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "Zugferd"
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

Scenario: STAMMDATEN - Kunde anlegen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Zugferd"
And I set fields
    | such      | Zugferd            |
    | namebspr  | ZUGFeRD Kunde      |
    | ans       | ZUGFeRD AG         |
    | str       | ZUGFeRD Strasse 15 |
    | plz       | 44444              |
    | nort      | ZUGFeRDdorf        |
    | region    | Baden-Württemberg  |
    | tele      | 070010100          |
    | betreuer  | zugferd            |
    | ustid     | DE123456780        |
    | lbed      | exw                |
    | zbed      | 200                |
    | zaform    | Lastschrift        |
    | erechmail | zug@test.de        |
And I save the current editor

Scenario Outline: Artikel vkbez anpassen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "<nummer>"
And I set field "vkbez" to "<vkbez>"
And I save the current editor

Examples: Artikel
| nummer | vkbez        |
| 201    | Testteil 201 |
| 202    | Testteil 202 |
| 203    | Testteil 203 |

Scenario Outline: Artikel vkbez anpassen
Given I open an editor "Artikel" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<nummer>"
And I set field "vkbez" to "<vkbez>"
And I save the current editor

Examples: Artikel
| nummer | vkbez       |
| 7      | Platzhalter |

Scenario Outline: Steuerregel Mit ZUGFeRD Einträgen aktualisieren
Given I open an editor "Steuerregel" from table "(TaxCode):(TaxRuleHead)" with command "UPDATE" for record "<nummer>"
And I set field "zftaxcode" to "<zftaxcode>"
And I set field "zftaxtyp" to "<zftaxtyp>"
And I set field "zfvatexemp" to "<zfvatexemp>"
And I save the current editor

Examples: Steuerregel
| steuerregel | nummer | zftaxcode             | zftaxtyp          | zfvatexemp              |
| steuer5000  | 5000   | (ZFTaxCodeStandard)   | (TaxTypeCodeVAT)  | (EmptyEntry)            |
| steuer5001  | 5001   | (ZFTaxCodeInsideEU)   | (TaxTypeCodeVAT)  | (VATExemptionVatexEUic) |
| steuer5002  | 5002   | (ZFTaxCodeInsideEU)   | (TaxTypeCodeVAT)  | (VATExemptionVatexEUic) |
| steuer5003  | 5003   | (ZFTaxCodeOutsideEU)  | (TaxTypeCodeVAT)  | (VATExemptionVatexEUg)  |
| steuer5004  | 5004   | (ZFTaxCodeReverse)    | (TaxTypeCodeVAT)  | (VATExemptionVatexEUae) |
| steuer5005  | 5005   | (ZFTaxCodeStandard)   | (TaxTypeCodeVAT)  | (EmptyEntry)            |
| steuer5006  | 5006   | (ZFTaxCodeExempt)     | (TaxTypeCodeVAT)  | (VATExamptionVatexEUo)  |
| steuer5008  | 5008   | (ZFTaxCodeExempt)     | (TaxTypeCodeVAT)  | (VATExamptionVatexEUo)  |
| steuer5009  | 5009   | (ZFTaxCodeInsideEU)   | (TaxTypeCodeVAT)  | (VATExemptionVatexEUic) |
| steuer6000  | 6000   | (ZFTaxCodeStandard)   | (TaxTypeCodeVAT)  | (EmptyEntry)            |
| steuer6001  | 6001   | (ZFTaxCodeStandard)   | (TaxTypeCodeVAT)  | (EmptyEntry)            |
| steuer6002  | 6002   | (ZFTaxCodeExempt)     | (TaxTypeCodeVAT)  | (VATExamptionVatexEUo)  |
| steuer6003  | 6003   | (ZFTaxCodeInsideEU)   | (TaxTypeCodeVAT)  | (EmptyEntry)            |
| steuer6004  | 6004   | (ZFTaxCodeInsideEU)   | (TaxTypeCodeVAT)  | (EmptyEntry)            |
| steuer6005  | 6005   | (ZFTaxCodeOutsideEU)  | (TaxTypeCodeVAT)  | (VATExemptionVatexEUg)  |
| steuer6006  | 6006   | (ZFTaxCodeReverse)    | (TaxTypeCodeVAT)  | (EmptyEntry)            |
| steuer6007  | 6007   | (ZFTaxCodeInsideEU)   | (TaxTypeCodeVAT)  | (EmptyEntry)            |
| steuer6008  | 6008   | (ZFTaxCodeReverse)    | (TaxTypeCodeVAT)  | (EmptyEntry)            |


Scenario: EDI-Nachricht ZUGFeRD eintragen
Given I open an editor "edikunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferd"
And I press button "edinfo" to open a subeditor for "edinachricht"
And I create a new row at the end of the table
And I set field "edinachraz" to "ZUGFeRD-Rechnung Export" in row 1
And I set field "ieabmodell" to "4150" in row 1
And I set field "erlaubt" to "ja" in row 1
And I save the current editor
And I switch the current editor to editor "edikunde"
And I save the current editor
And I close the current editor

Scenario: ZUGFERD2XML Layout aktivieren
Given I open an editor "sammellayout" from table "(PrintParameter):(Layout)" with command "UPDATE" for record "13635"
And I set field "aktiv" to "ja"
And I save the current editor
And I close the current editor

Scenario: ZUGFERD2 Sammellayout aktivieren
Given I open an editor "sammellayout" from table "(PrintParameter):(CollectiveLayout)" with command "UPDATE" for record "12760"
And I set field "aktiv" to "ja"
And I save the current editor
And I close the current editor

Scenario: ZUGFERD2 Sammellayout aktivieren
Given I open an editor "sammellayout" from table "(PrintParameter):(CollectiveLayout)" with command "UPDATE" for record "12761"
And I set field "aktiv" to "ja"
And I save the current editor
And I close the current editor

Scenario: ZUGFERD2 Sammellayout aktivieren
Given I open an editor "sammellayout" from table "(PrintParameter):(CollectiveLayout)" with command "UPDATE" for record "12762"
And I set field "aktiv" to "ja"
And I save the current editor
And I close the current editor    

Scenario: STAMMDATEN - Lieferant anlegen
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "Zugferd"
And I set fields
    | such     | Zugferd            |
    | namebspr | ZUGFeRD Lieferant  |
    | ans      | ZUGFeRD GmbH       |
    | str      | ZUGFeRD Strasse 12 |
    | plz      | 55555              |
    | nort     | ZUGFeRDstadt       |
    | region   | Bayern             |
    | tele     | 080010100          |
    | betreuer | zugferd            |
    | ustid    | DE123456789        |
    | lbed     | exw                |
    | zbed     | 200                |
    | zaform   | Lastschrift        |
And I save the current editor
And I close the current editor

Scenario: In Lieferant ZUGFERD die EDI-Nachricht ZUGFeRD eintragen
Given I open an editor "edilieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "Zugferd"
And I press button "edinfo" to open a subeditor for "edinachricht"
And I create a new row at the end of the table
And I set field "edinachraz" to "ZUGFeRD-Rechnung Import" in row 1
And I set field "ieabmodell" to "4160" in row 1
And I set field "erlaubt" to "ja" in row 1
And I save the current editor
And I switch the current editor to editor "edilieferant"
And I save the current editor
And I close the current editor

Scenario: In Kunde 4 Kunden-EDI-Nachricht ZUGFeRD eintragen
Given I open an editor "rekunde" from table "(Customer):(Customer)" with command "UPDATE" for record "4"
And I press button "edinfo" to open a subeditor for "edinachricht"
And I create a new row at the end of the table
And I set field "edinachraz" to "ZUGFeRD-Rechnung Export" in row 1
And I set field "ieabmodell" to "4150" in row 1
And I set field "erlaubt" to "ja" in row 1
And I save the current editor
And I switch the current editor to editor "rekunde"
And I save the current editor
And I close the current editor

Scenario: STAMMDATEN - Dienstleistung anlegen
Given I open an editor "dl" from table "(Part):(Service)" with command "STORE" for record "dl"
And I set fields
    | such      | dl             |
    | vkbezbspr | Dienstleistung |
    | vpr       | 50             |
    | lief      | zugferd        |
    | epr       | 50             |
And I save the current editor

Scenario: STAMMDATEN - Einheit in Zusatzpositon vom Typ AU/BE eintragen
Given I open an editor "zupos" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "a."
And I set fields
    | le   | Stück |
    | vhe  | Stück |
    | vpe | Stück |
And I save the current editor


#1. Fall: Bestellung "E 667788" - Lieferschein - Rechnung
Scenario: Bestellung anlgen
Given I open an editor "bestellung1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "nummer" to "667788"
And I set field "lief" to "60001"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  |
    | 1    | e2     | 15          | 10,5        |             |        |
    | 2    | 4      | !dontChange | !dontChange | -10         | -15,75 |
    | 3    | a.     | 10          | 10          |             |        |
# Position ohne Menge ist nicht erlaubt (Textposition / neutrale Position)
#    | 4    | text   | !dontChange | !dontChange | !dontChange | 110    |
    | 5    | dl     | 1           | 50          |             |        |
And I save the current editor

Scenario: Auftragsbestaetigung 777777 anlegen
Given I open an editor "ab1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "777777"
And I set field "kunde" to "70001"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  |
    | 1    | e2     | 15          | 10,5        |             |        |
    | 2    | 4      | !dontChange | !dontChange | -10         | -15,75 |
    | 3    | a.     | 10          | 10          |             |        |
# Position ohne Menge ist nicht erlaubt
#    | 4    | text   | !dontChange | !dontChange | !dontChange | 110    |
    | 5    | dl     | 1           | 50          |             |        |
And I save the current editor

Scenario: AB-Nummer in Bestellpositionen eintragen
Given I open an editor "bestellung2" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "bestellung1"
And I set field "abnrpo" to "777777" in row 1
And I set field "abnrpo" to "777777" in row 2
And I set field "abnrpo" to "777777" in row 3
And I set field "abnrpo" to "777777" in row 4
#And I set field "abnrpo" to "777777" in row 5
And I save the current editor

Scenario: VK-Lieferschein 888888 aus Auftrag 777777 anlegen
Given I open an editor "vklieferschein" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "ab1"
And I set field "nummer" to "888888"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
#And I press button "offueb" in row 5
And I save the current editor

Scenario: EK-Lieferschein "E 888888" aus Bestellung "E 667788" anlegen
Given I open an editor "eklieferschein" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "bestellung1"
And I set field "ebeleg" to "888888"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
#And I press button "offueb" in row 5
And I save the current editor

Scenario: Rechnung des Kunden an uns anlegen aus VK-Lieferschein 888888
Given I open an editor "rechnung1" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "vklieferschein"
And I set field "ueb" to "ja"
And I set field "zfpaymenttyp" to "Sepa Lastschrift"
And I set field "budat" to "03.01.95"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: ZUGFeRD-Rechnung über ZUGFERD2 drucken: rechnung1
# mit xml Export 
#Given I open an editor "dvkrech1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung1"
#And I press button "budruck2" to open a subeditor for "Druckdialog"
#And I set field "layout" to "ZUGFERD2"
#And I set field "drucker" to "DATEI"
#And I set field "archiv" to "nein"
#And I set field "loglevel" to "7"
#And I set field "datname" to "dfue/empfangen/rechnung1.pdf"
#And I save the current editor
#And I switch the current editor to editor "dvkrech1"
#And I close the current editor

#2. Fall: Rechnung aus Bestellung
Scenario: Bestellung anlegen
Given I open an editor "bestellung3" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  |
    | 1    | e3     | 15          | 10,5        |             |        |
    | 2    | 4      | !dontChange | !dontChange | -5          |        |
    | 3    | a.     | 5           | 15          |             |        |
#    | 4    | text   | !dontChange | !dontChange | !dontChange | 110    |
    | 5    | dl     | 2           | 50          |             |        |
And I save the current editor

Scenario: Auftragsbestaetigung 666666 anlegen
Given I open an editor "ab2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "666666"
And I set field "kunde" to id from editor "kunde"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  |
    | 1    | e3     | 15          | 10,5        |             |        |
    | 2    | 4      | !dontChange | !dontChange | -5          | -7,88  |
    | 3    | a.     | 10          | 10          |             |        |
#    | 4    | text   | !dontChange | !dontChange | !dontChange | 110    |
    | 5    | dl     | 2           | 50          |             |        |
And I save the current editor

Scenario: AB-Nummer in Bestellpositionen eintragen
Given I open an editor "bestellung4" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "bestellung3"
And I set field "abnrpo" to "666666" in row 1
And I set field "abnrpo" to "666666" in row 2
And I set field "abnrpo" to "666666" in row 3
And I set field "abnrpo" to "666666" in row 4
#And I set field "abnrpo" to "666666" in row 5
And I save the current editor

Scenario: Rechnung des Kunden an uns anlegen aus Auftrag
Given I open an editor "rechnung2" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "ab2"
And I set field "ueb" to "ja"
And I set field "zfpaymenttyp" to "Sepa Lastschrift"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
#And I press button "offueb" in row 5
And I set field "budat" to "03.01.95"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: ZUGFeRD-Rechnung drucken über ZUGFERD2: rechnung2
# mit xml Export 
#Given I open an editor "dvkrech2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung2"
#And I press button "budruck2" to open a subeditor for "Druckdialog"
#And I set field "layout" to "ZUGFERD2"
#And I set field "drucker" to "DATEI"
#And I set field "archiv" to "nein"
#And I set field "loglevel" to "7"
#And I set field "datname" to "dfue/empfangen/rechnung2.pdf"
#And I save the current editor
#And I switch the current editor to editor "dvkrech2"
#And I close the current editor

#3. Fall: Neue Rechnung ohne Vorgaenger
Scenario: Neue Rechnung ohne Vorgaenger anlegen
Given I open an editor "rechnung3" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "ueb" to "ja"
And I set field "zfpaymenttyp" to "Sepa Lastschrift"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  |
    | 1    | e1     | 15          | 10,5        |             |        |
    | 2    | 4      | !dontChange | !dontChange | -5          | -7,88  |
    | 3    | a.     | 11          | 11          |             |        |
#    | 4    | text   | !dontChange | !dontChange | !dontChange | 120    |
    | 5    | dl     | 3           | 50          |             |        |
And I set field "budat" to "03.01.95"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: ZUGFeRD-Rechnung über ZUGFERD2 drucken: rechnung3
# mit xml Export
#Given I open an editor "dvkrech3" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung3"
#And I press button "budruck2" to open a subeditor for "Druckdialog"
#And I set field "layout" to "ZUGFERD2"
#And I set field "drucker" to "DATEI"
#And I set field "archiv" to "nein"
#And I set field "loglevel" to "7"
#And I set field "datname" to "dfue/empfangen/rechnung3.pdf"
#And I save the current editor
#And I switch the current editor to editor "dvkrech3"
#And I close the current editor

#Scenario: Extract XML from rechnung1.pdf
#Given I execute shell command "cd dfue/empfangen && pdfdetach -save 1 -o factur-x1.xml rechnung1.pdf"
#Given I execute shell command "cd dfue/empfangen && pdfdetach -save 1 -o factur-x2.xml rechnung2.pdf"
#Given I execute shell command "cd dfue/empfangen && pdfdetach -save 1 -o factur-x3.xml rechnung3.pdf"

#Scenario: Dateien importieren
## -forceParserErrors: es werden immer EDI-Nachrichten angelegt auch wenn die XML-Datei nicht valide ist
## -importprefix: es wird der Prefix des Import-EDI-Modells angegeben
#Given I execute FOP "de.abas.edi2.JEdi.java -id 4160 -importprefix factur-x -forceParserErrors -suppressloglevel"

#Given I open the infosystem "ELINVOICECENTER"
#And I set field "datumv" to ""
#And I set field "datumb" to ""
#And I press button "bstart"
## EDI-NAchrichten 6,7,und 8
#Then the table has 3 rows
