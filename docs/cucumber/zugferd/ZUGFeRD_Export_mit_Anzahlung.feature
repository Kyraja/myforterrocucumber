@persistent
Feature: Testdaten für den Export von ZUGFeRD-Rechnungen mit Anzahlung

Scenario: STAMMDATEN - In der Konfiguration muss zugferd aktiv sein
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "VIEW" for record "0k"
Then field "zugferd" has value "ja"
And I close the current editor

Scenario: STAMMDATEN - Betriebsdaten pflegen
Given I open an editor "bdaten" from table "(Company):(CompanyData)" with command "UPDATE" for record "1"
And I set fields
    | such       | Zugferd            |
    | namebspr   | ZUGFeRD Kunde      |
    | knam1      | ZUGFeRD Kunde      |
    | ans        | ZUGFeRD AG         |
    | str        | ZUGFeRD Strasse 15 |
    | plz        | 44444              |
    | nort       | ZUGFeRDdorf        |
    | region     | Baden-Württemberg  |
    | staat      | Deutschland        |
    | tele       | 070010100          |
	| iban       | DE5500000000000025 |
    | gln        | 999888777          |
	| adminemail | admin@mydomain.de  |
And I save the current editor

Scenario: STAMMDATEN - Mitarbeiter anlegen
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
	| email    | betreuer@abas.de    | 
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
    | ans2      | ZUGFeRD AG Versand |
    | str2      | ZUGFeRD Strasse 15 |
    | plz2      | 44444              |
    | nort2     | ZUGFeRDdorf        |
    | region2   | Baden-Württemberg  |
    | tele      | 070010100          |
    | betreuer  | zugferd            |
	| email     | buyer@abas.de      | 
    | erechmail | info@abas.de       | 
    | ustid     | DE123456780        |
    | lbed      | exw                |
    | zbed      | 200                |
    | zaform    | Lastschrift        |
And I save the current editor

#EDI-Nachricht ZUGFeRD und Abbildungsmodell 4150 eintragen
Given I open an editor "edikunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferd"
And I press button "edinfo" to open a subeditor for "edinachricht"
And I create a new row at the end of the table
And I set field "edinachraz" to "ZUGFeRD-Rechnung Export" in row 1
And I set field "ieabmodell" to "4150" in row 1
And I set field "erlaubt" to "ja" in row 1
And I save the current editor
And I switch the current editor to editor "edikunde"
And I save the current editor

Scenario: STAMMDATEN - Dienstleistung anlegen
Given I open an editor "dl" from table "(Part):(Service)" with command "STORE" for record "dl"
And I set fields
    | such     | dl             |
    | namebspr | Dienstleistung |
    | vpr      | 50             |
And I save the current editor

Scenario: STAMMDATEN - Einheit in Zusatzpositon vom Typ AU/BE eintragen
Given I open an editor "zupos" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "a."
And I set fields
    | vbez | vbez Platzhalter |
    | le   | Stück            |
    | vhe  | Stück            |
    | vpe  | Stück            |
And I save the current editor

Scenario: STAMMDATEN - Zu- und Abschlagstyp in Zusatzpositon Anzahlung eintragen
Given I open an editor "zu_anz" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "anzahlung"
And I set fields
    | vhe     | Stück     |
    | vpe     | Stück     |
    | zfzutyp | Sonstiges |
    | zfabtyp | Rabatt    |
And I save the current editor

Scenario: STAMMDATEN - Steuerregel mit Steuercode fuellen
Given I open an editor "strrgl" from table "(TaxCode):(TaxRuleRow)" with command "UPDATE" for record "VKINREGEL"
And I set fields
    | zftaxcode | (ZFTaxCodeStandard) |
    | zftaxtyp  | (TaxTypeCodeVAT)    |
And I save the current editor

Scenario: STAMMDATEN - Steuerregel mit Steuercode fuellen
Given I open an editor "strrgl7" from table "(TaxCode):(TaxRuleRow)" with command "UPDATE" for record "VKINERM"
And I set fields
    | zftaxcode | (ZFTaxCodeStandard) |
    | zftaxtyp  | (TaxTypeCodeVAT)    |
And I save the current editor

Scenario: STAMMDATEN - Sammellayout 12762 aktivieren
Given I open an editor "layout" from table "(PrintParameter):(CollectiveLayout)" with command "UPDATE" for record "12762"
And I set field "aktiv" to "ja"
And I save the current editor

Scenario: STAMMDATEN - neue Produktgruppe anlegen mit 7% Steuer
Given I open an editor "produktgruppe" from table "(Company):(ProductGroup)" with command "STORE" for record "PG-7P"
And I set fields
    | such               | PG-7P                       |
    | namebspr           | Produktgruppe mit 7% Steuer |
    | pgkst              | 101                         |
    | pgerlo             | 43000                       |
    | uebest             | 10500                       |
    | bvzumaschkostfix   | 48100                       |
    | bvzugkmaschkostfix | 48100                       |
    | bvzumaschkostvar   | 48100                       |
    | bvzugkmaschkostvar | 48100                       |
    | bvzulohnkost       | 48100                       |
    | bvzugklohnkost     | 48100                       |
    | bvzusonderkostfix  | 48100                       |
    | bvzusonderkostvar  | 48100                       |
    | bvzumatkost        | 48100                       |
    | bvzugkmatkost      | 48100                       |
    | bvalleabgaenge     | 48100                       |
And I save the current editor

Scenario: STAMMDATEN - Anzahlungsposition mit 7% Steuer
Given I open an editor "zu_7anz" from table "(Part):(SupplementaryItem)" with command "STORE" for record "anz7"
And I set fields
    | such      | ANZ7             |
    | namebspr  | Anzahlung mit 7% |
    | zptyp     | neutrale Position |
    | kategorie | Anzahlung         |
    | vkonto    | 43000             |
    | zfzutyp   | Sonstiges         |
    | zfabtyp   | Rabatt            |
And I save the current editor

#1. Fall: Auftrag mit Fakturaplan und Anzahlungsrechnung
Scenario: Auftrag 1 anlegen
Given I open an editor "ab1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "budat" to "2.1.2"
And I set field "betreff" to "Anzahlung Fall 1"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  |
    | 1    | v1     | 15          | 10,5        |             |        |
    | 2    | a.     | 10          | 10          |             |        |
And I save the current editor

#Fakturaplan anlegen
Given I open an editor "fakturaplan1" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "ab1"
And I set field "namebspr" to "Fakturaplan 1 zu ZUGFeRD Auftrag"
And I append rows
 | reart     | proz | ptext        | zbed |
 | Anzahlung | 10   | 1. Anzahlung | 203  |
 | Anzahlung | 20   | 2. Anzahlung | 203  |
And I save the current editor

#Anzahlungsrechnungen anlegen
Given I open an editor "anzrech1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "ab1"
And I set field "betreff" to "Anzahlung Fall 1"
And I set field "zaform" to "(Check)"
And I set field "frzeich" to "FRZEICH001"
And I set field "leitwegid" to "LEITWEGID001"
And I set field "pnum" to "1" in row 1
And I delete row at position 2 
And I save the current editor

Given I open an editor "anzrech2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "ab1"
And I set field "betreff" to "Anzahlung Fall 1"
And I set field "zaform" to "(Check)"
And I set field "frzeich" to "FRZEICH002"
And I set field "pnum" to "2" in row 2
And I delete row at position 1
And I save the current editor

#ZUGFeRD-Anzahlungsrechnungen über EVVORGANG drucken 
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "anzrech1"
And I press button "bstart"
And I print layout "XMLDATAGEN" with printer "BILDSCHIRM" and filename "dfue/senden/factur-x_1.xml" with quantity "1" and copies "1"
And I close the current editor

Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "anzrech2"
And I press button "bstart"
And I print layout "XMLDATAGEN" with printer "BILDSCHIRM" and filename "dfue/senden/factur-x_2.xml" with quantity "1" and copies "1"
And I close the current editor

#2. Fall: Auftrag mit Fakturaplan, Anzahlungsrechnung und Schlussrechnung mit einer Steuerposition
Scenario: Auftrag 2 anlegen
Given I open an editor "ab2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "budat" to "2.1.2"
And I set field "betreff" to "Anzahlung Fall 2"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  |
    | 1    | v1     | 10          | 10,5        |             |        |
    | 2    | a.     | 5           | 10          |             |        |
And I save the current editor

#Fakturaplan anlegen
Given I open an editor "fakturaplan3" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "ab2"
And I set field "namebspr" to "Fakturaplan 2 zu ZUGFeRD Auftrag mit Storno Anzahlung"
And I append rows
 | reart     | proz | ptext        | zbed |
 | Anzahlung | 15   | 1. Anzahlung | 203  |
 | Anzahlung | 25   | 2. Anzahlung | 203  |
And I save the current editor

#Anzahlungsrechnungen anlegen
Given I open an editor "anzrech3" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "ab2"
And I set field "betreff" to "Anzahlung Fall 2"
And I set field "ueb" to "ja"
And I delete row at position 2 
And I save the current editor

Given I open an editor "anzrech4" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "ab2"
And I set field "betreff" to "Anzahlung Fall 2"
And I set field "ueb" to "ja"
And I delete row at position 1
And I save the current editor

#Schlussrechnung aus Auftrag erstellen
Given I open an editor "schlussrech1" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "ab2"
And I set field "zaform" to "(Check)"
And I set field "frzeich" to "FRZEICH003"
And I set field "leitwegid" to "LEITWEGID003"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

#Schlussrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "schlussrech1"
And I press button "bstart"
And I print layout "XMLDATAGEN" with printer "BILDSCHIRM" and filename "dfue/senden/factur-x_3.xml" with quantity "1" and copies "1"
And I close the current editor

#3. Fall: Auftrag mit Fakturaplan, Anzahlungsrechnung und Schlussrechnung mit mehreren Steuerpositionen
Scenario: Auftrag 3 anlegen
Given I open an editor "ab3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "budat" to "2.1.2"
And I set field "betreff" to "Anzahlung Fall 3"
And I append rows
    | pnum | artex  | mge         | preis       | proz        | pwert  |
    | 1    | v1     | 10          | 10,5        |             |        |
    | 2    | a.     | 5           | 10          |             |        |
And I save the current editor

#Fakturaplan anlegen
Given I open an editor "fakturaplan3" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "ab3"
And I set field "namebspr" to "Fakturaplan 3 zu ZUGFeRD Auftrag mit Storno Anzahlung"
And I append rows
 | reart     | proz | ptext        | zbed |
 | Anzahlung | 15   | 1. Anzahlung | 203  |
 | Anzahlung | 25   | 2. Anzahlung | 203  |
And I save the current editor

#Anzahlungsrechnungen anlegen
Given I open an editor "anzrech5" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "ab3"
And I set field "betreff" to "Anzahlung Fall 3"
And I set field "ueb" to "ja"
And I delete row at position 2 
And I save the current editor

Given I open an editor "anzrech6" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "ab3"
And I set field "betreff" to "Anzahlung Fall 3"
And I set field "ueb" to "ja"
And I delete row at position 1
And I save the current editor

#Schlussrechnung aus Auftrag erstellen
Given I open an editor "schlussrech2" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "ab3"
And I set field "reanzpossteuer" to "ja"
And I set field "zaform" to "(Check)"
And I set field "frzeich" to "FRZEICH004"
And I set field "leitwegid" to "LEITWEGID004"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

#Schlussrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "schlussrech2"
And I press button "bstart"
And I print layout "XMLDATAGEN" with printer "BILDSCHIRM" and filename "dfue/senden/factur-x_4.xml" with quantity "1" and copies "1"
And I close the current editor

#4. Fall: Auftrag mit Fakturaplan, Anzahlungsrechnung und Schlussrechnung mit mehreren Steuerpositionen und unterschiedlichen Steuersaetzen
Scenario: Artikel v2 auf 16% Steuer umstellen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "v2"
And I set field "erlgrp" to "PG-7P"
And I save the current editor

#Auftrag anlegen
Given I open an editor "ab4" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "budat" to "2.1.2"
And I set field "betreff" to "Anzahlung Fall 4"
And I append rows
    | pnum | artex     | mge         | preis       | proz        | pwert       |
    | 1    | v1        | 10          | 10,5        |             |             |
    | 2    | v2        | 5           | 10          |             |             |
    | 3    | anzahlung | !dontChange | !dontChange | !dontChange | !dontChange |
    | 4    | anz7      | !dontChange | !dontChange | !dontChange | !dontChange |
And I save the current editor

#Anzahlungsrechnungen anlegen
Given I open an editor "anzrech7" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "ab4"
And I set field "betreff" to "Anzahlung Fall 4"
And I set field "ueb" to "ja"
And I set field "budat" to "2.1.2"
And I set field "pwert" to "20" in row 1
And I delete row at position 2 
And I save the current editor

Given I open an editor "anzrech8" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "ab4"
And I set field "betreff" to "Anzahlung Fall 4"
And I set field "ueb" to "ja"
And I set field "budat" to "2.1.2"
And I set field "pwert" to "15" in row 2
And I delete row at position 1
And I save the current editor

#Schlussrechnung aus Auftrag anlegen
Given I open an editor "schlussrech3" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "ab4"
And I set field "reanzpossteuer" to "ja"
And I set field "zaform" to "(Check)"
And I set field "frzeich" to "FRZEICH005"
And I set field "leitwegid" to "LEITWEGID005"
And I set field "budat" to "2.1.2"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

#Schlussrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "schlussrech3"
And I press button "bstart"
And I print layout "XMLDATAGEN" with printer "BILDSCHIRM" and filename "dfue/senden/factur-x_5.xml" with quantity "1" and copies "1"
And I close the current editor

Scenario: ZUGFERD mit Abbildungsmodell 4180-EXTENDED exportieren
Given I open an editor "edikunde2" from table "(Customer):(Customer)" with command "UPDATE" for record "Zugferd"
And I press button "edinfo" to open a subeditor for "edinachricht2"
And I set field "ieabmodell" to "4180" in row 1
And I save the current editor
And I switch the current editor to editor "edikunde2"
And I save the current editor

#1. Fall: Auftrag mit Fakturaplan und Anzahlungsrechnung
#ZUGFeRD-Anzahlungsrechnungen über EVVORGANG drucken 
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "anzrech1"
And I press button "bstart"
And I print layout "XMLDATAGEN" with printer "BILDSCHIRM" and filename "dfue/senden/factur-x_b1.xml" with quantity "1" and copies "1"
And I close the current editor

Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "anzrech2"
And I press button "bstart"
And I print layout "XMLDATAGEN" with printer "BILDSCHIRM" and filename "dfue/senden/factur-x_b2.xml" with quantity "1" and copies "1"
And I close the current editor

#2. Fall: Auftrag mit Fakturaplan, Anzahlungsrechnung und Schlussrechnung mit einer Steuerposition
#Schlussrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "schlussrech1"
And I press button "bstart"
And I print layout "XMLDATAGEN" with printer "BILDSCHIRM" and filename "dfue/senden/factur-x_b3.xml" with quantity "1" and copies "1"
And I close the current editor

#3. Fall: Auftrag mit Fakturaplan, Anzahlungsrechnung und Schlussrechnung mit mehreren Steuerpositionen
#Schlussrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "schlussrech2"
And I press button "bstart"
And I print layout "XMLDATAGEN" with printer "BILDSCHIRM" and filename "dfue/senden/factur-x_b4.xml" with quantity "1" and copies "1"
And I close the current editor

#4. Fall: Auftrag mit Fakturaplan, Anzahlungsrechnung und Schlussrechnung mit mehreren Steuerpositionen und unterschiedlichen Steuersaetzen
#Schlussrechnung drucken
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "schlussrech3"
And I press button "bstart"
And I print layout "XMLDATAGEN" with printer "BILDSCHIRM" and filename "dfue/senden/factur-x_b5.xml" with quantity "1" and copies "1"
And I close the current editor
