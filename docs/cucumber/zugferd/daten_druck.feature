# *****************************************************************************
#  Name             : daten_druck.feature
#  Autor            : oschneider
#  Verantwortlich   : oschneider
#  Kontrolle        : tkellermann
#  Funktion         : Vorbereitung von Daten fuer ZUGFeRD Druck
#
# *****************************************************************************
Feature: Test von ZUGFeRD Rechnungen

Scenario: STAMMDATEN - Intrastat-Kurztext

Given I open an editor "intrastat" from table "(Company):(Summary)" with command "STORE" for record "INTRAART"
And I set field "such" to "INTRAART"
And I set field "namebspr" to "Eintrag fuer Test ZUGFeRD"
And I set field "ahnum" to "12315848"
And I save the current editor

Given I open an editor "intrastatart" from table "(Company):(Summary)" with command "STORE" for record "INTRAVERKA" 
And I set field "such" to "INTRAVERKA"
And I set field "namebspr" to "Zum Vollstaendigen Verbleib"
And I set field "schl" to "11"
And I save the current editor

Scenario Outline: STAMMDATEN - Neue Kunden anlegen

Given I open an editor "<such>" from table "(Customer):(Customer)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "ans" to "<ans>"
And I set field "str" to "<str>"
And I set field "plz" to "<plz>"
And I set field "nort" to "<nort>"
And I set field "region" to "<region>"
And I set field "tele" to "<tele>"
And I set field "fax" to "<fax>"
And I set field "email" to "<email>"
And I set field "erechmail" to "<erechmail>"
And I set field "betreuer" to "<betreuer>"
And I set field "ustid" to "<ustid>"
And I set field "lbed" to "<lbed>"
And I set field "zbed" to "<zbed>"
And I set field "staat" to "<staat>"
And I set field "waehr" to "<waehr>"
And I save the current editor

Examples: Kunde
| such            | namebspr                    | ans                                                  | str                    | plz      | nort             | region  | tele                | fax                 | email                  | erechmail              | betreuer | ustid      | lbed | zbed | staat       | waehr | gart     |
| Bayram          | Bayram Werkzeugbau, Rastatt | Bayram Werkzeugbau GmbH                              | Riedstr. 24-28         | 76437    | Rastatt          | BADEN   | +49 (0) 7222/9456-0 |                     | info@bayram-corp.de    | info@bayram-corp.de    | .        | DE56454651 | EXW  | 201  | DEUTSCHLAND | EUR   | INTRAART |
| Inatis          | INATIS LE GROUPE            | INATIS LE GROUPE, Centre d'affaires du Chateau Rouge | 278 avenue de la Marne | 59700    | MARCQ EN BAROEUL |         | +33 3 20 68 55 00   | +33 3 20 68 56 06   | info-contact@inatis.fr | info-contact@inatis.fr | .        |            | CPT  | 201  | FRANKREICH  | USD   | INTRAART |
| BGG             | BCG Cosmetics Group GmbH    | BCG Baden-Baden Cosmetics Group GmbH                 | Im Rosengarten 7       | 76532    | Baden-Baden      | BADEN   | +49-(0)7221-688-100 | +49-(0)7221-688-369 | info@bcg-cosmetics.de  | info@bcg-cosmetics.de  | .        | DE56454651 | EXW  | 201  | DEUTSCHLAND | EUR   | INTRAART |

Scenario: Kunden nochmal aufrufen und EDI-Nachricht anlegen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "Bayram"
And I press button "edinfo" to open a subeditor for "zugferd"
And I create a new row at the end of the table
And I set field "edinachraz" to "ZUGFeRD-Rechnung Export" in row 1
And I set field "ieabmodell" to "4150" in row 1
And I set field "erlaubt" to "ja" in row 1
And I set field "startdat" to "." in row 1
And I save the current editor
And I switch the current editor to editor "kunde"
And I save the current editor

Given I open an editor "kunde2" from table "(Customer):(Customer)" with command "UPDATE" for record "Inatis"
And I press button "edinfo" to open a subeditor for "zugferd"
And I create a new row at the end of the table
And I set field "edinachraz" to "ZUGFeRD-Rechnung Export" in row 1
And I set field "ieabmodell" to "4150" in row 1
And I set field "erlaubt" to "ja" in row 1
And I set field "startdat" to "." in row 1
And I save the current editor
And I switch the current editor to editor "kunde2"
And I save the current editor

Given I open an editor "kunde3" from table "(Customer):(Customer)" with command "UPDATE" for record "BGG"
And I press button "edinfo" to open a subeditor for "zugferd"
And I create a new row at the end of the table
And I set field "edinachraz" to "ZUGFeRD-Rechnung Export" in row 1
And I set field "ieabmodell" to "4150" in row 1
And I set field "erlaubt" to "ja" in row 1
And I set field "startdat" to "." in row 1
And I save the current editor
And I switch the current editor to editor "kunde3"
And I save the current editor

Scenario: STAMMDATEN - Naturalrabat anlegen
Given I open an editor "naturalrabat" from table "(Pricing):(Pricing)" with command "STORE" for record "natural"
And I set field "typ" to "Verkauf Rabatte"
And I set field "such" to "natural"
And I set field "artpg" to "artikel1"
And I set field "mgeab" to "ja"
And I set field "rfolge" to "2"
And I create a new row at the end of the table
And I set field "mgrenze" to "10" in row 1
And I set field "mnrab" to "1" in row 1
And I save the current editor

Scenario: STAMMDATEN - Projekt anlegen
Given I open an editor "projekt1" from table "(Transaction):(Project)" with command "STORE" for record "test"
And I set field "such" to "test"
And I set field "name" to "Projekt Test"
And I save the current editor

#Materialzuschlag anlegen
Given I open an editor "matzuschlag" from table "(Company):(MaterialSurchargeHeader)" with command "STORE" for record "30"
And I create a new row at the end of the table
And I set field "matart" to "CU" in row 1
And I set field "matbasis" to "100" in row 1
And I set field "matnotiz" to "110" in row 1
And I create a new row at the end of the table
And I set field "matart" to "FE" in row 2
And I set field "matbasis" to "100" in row 2
And I set field "matnotiz" to "120" in row 2
And I save the current editor

Given I open an editor "produktgruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "such" to "FAL-012"
And I set field "pgerlo" to "43000"
And I save the current editor

Scenario: STAMMDATEN - Neue Dienstleistung anlegen
Given I open an editor "dienstl" from table "(Part):(Service)" with command "STORE" for record "dl-analyse"
And I set field "such" to "dl-analyse"
And I set field "namebspr" to "Anlayse"
And I set field "vpr" to "50.00"
And I create a new row at the end of the table
And I set field "elex" to "A AG1" in row 1
And I save the current editor

Given I open an editor "dienstl2" from table "(Part):(Service)" with command "STORE" for record "dl-reparatur"
And I set field "such" to "dl-reparatur"
And I set field "namebspr" to "Reparatur"
And I set field "vpr" to "150.00"
And I set field "vpe" to "h"
And I save the current editor

Scenario Outline: STAMMDATEN neue Artikeln anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "bsart" to "<bsart>"
And I set field "dispoa" to "<dispoa>"
#And I set field "lief" to "<lief>"
#And I set field "epr" to "<epr>"
#And I set field "efrist" to "<efrist>"
And I set field "matart" to "<matart>"
And I set field "zmge" to "<zmge>"
And I set field "matvrel" to "<matvrel>"
And I set field "materel" to "<materel>"
And I set field "matart2" to "<matart2>"
And I set field "zmge2" to "<zmge2>"
And I set field "matvrel2" to "<matvrel2>"
And I set field "materel2" to "<materel2>"
And I set field "erlgrp" to "<erlgrp>"
And I set field "vrab" to "<vrab>"
And I save the current editor

Examples: Artikel
| such            | namebspr     | vkbez     | vbez       | ebez      | vpr    | bsart             | dispoa          | matart | zmge | matvrel | materel | matart2 | zmge2 | matvrel2 | materel2 | erlgrp                                              | vrab      | intrarel| ahnum    | urregion           | urland      | bsregion            
| artikel1        | Artikel 1    | Artikel 1 | Artikel 1  | Artikel 1 | 10000  | Fremdbeschaffung  | bedarfsbezogen  | CU     | 1    | ja      | ja      | FE      | 1     | ja       | ja       |                                                     | artikel1  | ja      | INTRAART | BADEN-WUERTTEMBERG | DEUTSCHLAND | BADEN-WUERTTEMBERG  
| artikel2        | Artikel 2    | Artikel 2 | Artikel 2  | Artikel 2 | 9000   | Fremdbeschaffung  | bedarfsbezogen  |        |      |         |         |         |       |          |          | $,,such=FAL-012;@richtung=(Backwards);@maxtreffer=1 | artikel1  | ja      | INTRAART | BADEN-WUERTTEMBERG | DEUTSCHLAND | BADEN-WUERTTEMBERG  
| artikel3        | Artikel 3    | Artikel 3 | Artikel 3  | Artikel 3 | 7000   | Fremdbeschaffung  | bedarfsbezogen  |        |      |         |         |         |       |          |          |                                                     |           | ja      | INTRAART | BADEN-WUERTTEMBERG | DEUTSCHLAND | BADEN-WUERTTEMBERG  
| artikel4        | Artikel 4    | Artikel 4 | Artikel 4  | Artikel 4 | 8000   | Fremdbeschaffung  | bedarfsbezogen  |        |      |         |         |         |       |          |          |                                                     | artikel4  | ja      | INTRAART | BADEN-WUERTTEMBERG | DEUTSCHLAND | BADEN-WUERTTEMBERG  

Scenario Outline: STAMMDATEN - Zusatzposition vom Typ AU/BE anlegen
Given I open an editor "<zusatzpos>" from table "02:04" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "epr" to "<epr>"
And I set field "le" to "<le>"
And I set field "vhe" to "<vhe>"
And I set field "vpe" to "<vpe>"
And I set field "ehe" to "<ehe>"
And I set field "epe" to "<epe>"
And I set field "zfabtyp" to "<zfabtyp>"
And I set field "zfabtyp" to "<zfabtyp>"
And I set field "zfabtyp" to "<zfabtyp>"

And I save the current editor

Examples: Zusatzposition
| zusatzpos   | such   | namebspr             | zptyp             | vkbez                | vbez                 | ebez                 | vpr  | epr  | zfzutyp              | zfabtyp                  | le          | vhe         | vpe         | ehe         | epe         |
| zusatzAUBE  | AUBE   | Zusatzposition AU/BE | AU/BE-Position,BV | Zusatzposition AU/BE | Zusatzposition AU/BE | Zusatzposition AU/BE | 1100 | 1000 |                      |                          | Stück       | Stück       | Stück       | Stück       | Stück       |
| neutralePOS | NEUPOS | Neutrale Position    | Neutrale Position | Neutrale Position    | Neutrale Position    | Neutrale Position    | 500  | 400  | (ChargeReasonCodeABK)|                          | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange |
| textpos     | TEXT   | Textposition         | Text              |                      |                      |                      |      |      | (ChargeReasonCodeABK)| (AllowanceReasonCode104) | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange |

Scenario: Anzahlungsposition mit Lagereinheit versehem
Given I open an editor "anzpos" from table "02:04" with command "UPDATE" for record "11"
And I set field "le" to "Stück"
And I set field "vhe" to "Stück"
And I set field "vpe" to "Stück"
And I set field "ehe" to "Stück"
And I set field "epe" to "Stück"
And I save the current editor

Scenario: Zahlungsverteiler anlegen
Given I open an editor "zverteiler" from table "(PaymentMasterFiles):(PaymentDistributor)" with command "NEW" for record ""
And I set field "such" to "ZVERT"
And I create a new row at the end of the table
And I set field "proz" to "30" in row !lastRow
And I set field "zbed" to "201" in row !lastRow
And I create a new row at the end of the table
And I set field "proz" to "30" in row !lastRow
And I set field "zbed" to "200" in row !lastRow
And I create a new row at the end of the table
And I set field "proz" to "40" in row !lastRow
And I set field "zbed" to "202" in row !lastRow
Then the table has 3 rows
And I save the current editor

Scenario: Beim Betreuer eine Telfonnummer eintragen
Given I open an editor "Betreuer" from table "(Employee):(Employee)" with command "UPDATE" for record "7801"
And I set field "tele" to ""
And I save the current editor

Scenario: Rechnung mit Fehlern 
Given I open an editor "rechnung0" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ZFRECH0"
And I set field "bem" to "Rechnung 0: Rechnung mit unterschiedlichen Steuersaetzen ohne gepflegte Daten"
And I set field "betreff" to "Rechnung 0: Rechnung mit unterschiedlichen Steuersaetzen ohne gepflegte Daten"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I set field "budat" to "03.01.95"
And I press button "bureabschluss"
Then the table has 10 rows
Then saving the current editor throws the exception "ZUGFeRD: Die Telefonnummer des Betreuers fehlt. Bitte eintragen."

Scenario: Beim Betreuer eine Telfonnummer eintragen
Given I open an editor "Betreuer" from table "(Employee):(Employee)" with command "UPDATE" for record "7801"
And I set field "tele" to "0815/8888"
And I save the current editor

Scenario: Rechnung 01 mit Fehlern 
Given I open an editor "rechnung01" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ZFRECH0"
And I set field "bem" to "Rechnung 0: Rechnung mit unterschiedlichen Steuersaetzen ohne gepflegte Daten"
And I set field "betreff" to "Rechnung 0: Rechnung mit unterschiedlichen Steuersaetzen ohne gepflegte Daten"
And I set field "zfpaymenttyp" to "Sepa Lastschrift"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I set field "budat" to "03.01.95"
#And I respond with answer "Ja" to the dialog with id "4841"
Then saving the current editor throws the exception 
"""
ZUGFeRD: Positionsnummern für Zeilen vom Typ "AU/BE-Position,BV" müssen vergeben sein. Bitte vervollständigen.
"""

Scenario: Rechnung 1101 mit Fehlern Steuerbefreiung fehlt
Given I open an editor "rechnung1101" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ZFRECH0"
And I set field "bem" to "Rechnung 0: Rechnung mit unterschiedlichen Steuersaetzen ohne gepflegte Daten"
And I set field "betreff" to "Rechnung 0: Rechnung mit unterschiedlichen Steuersaetzen ohne gepflegte Daten"
And I set field "zfpaymenttyp" to "Sepa Lastschrift"
And I create a new row at the end of the table
And I set field "pnum" to "1" in row 1
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "pnum" to "1" in row !lastRow
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I set field "budat" to "03.01.95"
#And I respond with answer "Ja" to the dialog with id "4841"
Then saving the current editor throws the exception "ZUGFeRD: Grund der Steuerbefreiung in der Steuerregel nicht gefüllt. Bitte eintragen."   

Scenario: Rechnung 1102 mit Fehlern Zahlungsart
Given I open an editor "rechnung1101" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde2"
And I set field "such" to "ZFRECH0"
And I set field "bem" to "Rechnung 0: Rechnung mit unterschiedlichen Steuersaetzen ohne gepflegte Daten"
And I set field "betreff" to "Rechnung 0: Rechnung mit unterschiedlichen Steuersaetzen ohne gepflegte Daten"
And I create a new row at the end of the table
And I set field "pnum" to "1" in row 1
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
#And I respond with answer "Ja" to the dialog with id "4841"
Then saving the current editor throws the exception "ZUGFeRD: Bitte Zahlungsart im Reiter ZUGFeRD füllen."

Scenario: In Kunde Inatis USTID fuellen
Given I open an editor "kunde21" from table "(Customer):(Customer)" with command "UPDATE" for record "Inatis"
And I set field "ustid" to "FR123243456" 
And I save the current editor

# Anmerkung Prüfung ob Steuerregeln,Zusatzposition, Einheiten, Ländercodes, Zahungsart, Zeilennummern gefüllt sind hier einfügen @CL

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

Scenario: KontensteSteuerregel Mit ZUGFeRD Einträgen aktualisieren
Given I open an editor "Steuerregel" from table "(TaxCode):(AccountTaxRuleHead)" with command "UPDATE" for record "7002"
And I create a new row at the end of the table
And I set field "vrgstrgl" to "VKEUSTFR" in row !lastRow
And I set field "strgl" to "VKEUWARE" in row !lastRow
And I set field "belteartdleist" to "nein" in row !lastRow
And I save the current editor

Given I open an editor "Steuerregel" from table "(TaxCode):(AccountTaxRuleHead)" with command "UPDATE" for record "7001"
And I create a new row at the end of the table
And I set field "vrgstrgl" to "VKEUSTFR" in row !lastRow
And I set field "strgl" to "VKEUWARE" in row !lastRow
And I set field "belteartdleist" to "ja" in row !lastRow
And I save the current editor

Scenario Outline: STAMMDATEN - Zusatzposition mit Zu- / Abschlagstyp füllen
Given I open an editor "<zusatzpos2>" from table "02:04" with command "STORE" for record "<nummer>"
And I set field "zfzutyp" to "<zfzutyp>"
And I set field "zfabtyp" to "<zfabtyp>"
And I save the current editor

Examples: Zusatzposition
| zusatzpos2      | nummer | zfzutyp               | zfabtyp                  |
| zusatzgesamtrab | 4      |                       | (AllowanceReasonCode90)  |
| neutraleMATZU   | 10     | (ChargeReasonCodeADQ) | (AllowanceReasonCode88)  |
| neutralePOS1    | 20     | (ChargeReasonCodeRAD) |                          |
| neutraleTEXT    | 12     | (ChargeReasonCodeABK) | (AllowanceReasonCode104) |
| neutralePOS2    | 13     | (ChargeReasonCodeRAD) |                          |

Scenario: Kunden Bayram  Zahlungsart Überweisung nachtragen
Given I open an editor "kundeza" from table "(Customer):(Customer)" with command "UPDATE" for record "Bayram"
And I set field "zaform" to "Überweisung" 
And I save the current editor

Scenario: Kunden Inatis Zahlungsart Überweisung nachtragen
Given I open an editor "kunde2za" from table "(Customer):(Customer)" with command "UPDATE" for record "Inatis"
And I set field "zaform" to "Lastschrift" 
And I save the current editor

Scenario: Kunden BGG Zahlungsart Überweisung nachtragen
Given I open an editor "kunde3za" from table "(Customer):(Customer)" with command "UPDATE" for record "BGG"
And I set field "zaform" to "Kreditkarte" 
And I save the current editor

Scenario Outline: STAMMDATEN - Einheit mit der ZUGFERD-Einheit füllen
Given I open an editor "<einheit>" from table "62:01" with command "UPDATE" for record "<such>"
And I set field "zfunece" to "<zfunece>"
And I save the current editor

Examples: Einheiten
| einheit    | such   | zfunece |
| einhstück  | STUECK | H87     |
| einhkg     | KGM    | KGM     |
| einhstunde | HUR    | HUR     |

# Jetzt werden die Werte für die ZUGFeRD-Felder aus den Steuerregeln gefüllt
# Das Schreiben und Wiederladen muss wieder ausgebaut werden.
Scenario: Rechnung mit unterschiedlichen Steuersaetzen mit gepflegten Daten
Given I open an editor "rechnung1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kundeza"
And I set field "such" to "ZFRECH1"
And I set field "bem" to "Rechnung 1: Rechnung mit unterschiedlichen Steuersaetzen mit gepflegten Daten"
And I set field "betreff" to "Rechnung 1: Rechnung mit unterschiedlichen Steuersaetzen mit gepflegten Daten"
And I create a new row at the end of the table
And I set field "pnum" to "1" in row 1
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "pnum" to "2" in row !lastRow
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "10 " in row !lastRow
And I set field "budat" to "03.01.95"
And I create a new row at the end of the table
And I set field "artex" to "9" in row !lastRow
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Given I open an editor "rechnungw1" from table "(Sales):(Invoice)" with command "UPDATE" for record with id from editor "rechnung1"
#And I save the current editor

Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "rechnung1"
And I press start
Then field "zuschlagsum" has value "0.00"
Then field "ohnesteuersum" has value "190300.00"
Then field "nettosum" has value "190300.00"
Then field "abschlagsum" has value "0.00"
Then field "steuersum" has value "21345.00"
Then field "vorauszahlsum" has value "0.00"
Then field "gesamtsum" has value "211645.00"
Then field "restzahlsum" has value "211645.00"
Then field "rundungsbetrag" has value "0.00"
And I close the current editor

Scenario: Rechnung mit unterschiedlichen Steuersaetzen + Bruttopreise
Given I open an editor "rechnung2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ZFRECH2"
And I set field "bem" to "Rechnung 2: Rechnung mit unterschiedlichen Steuersaetzen + Bruttopreise"
And I set field "betreff" to "Rechnung 2: Rechnung mit unterschiedlichen Steuersaetzen + Bruttopreise"
And I set field "budat" to "03.01.95"
And I set field "brutto" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "-2,00" in row 1
And I set field "pnum" to "1" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I set field "pnum" to "2" in row !lastRow
And I create a new row at the end of the table
And I set field "artex" to "9" in row !lastRow
##And I respond with answer "Ja" to the dialog with id "4841"
Then saving the current editor throws the exception "ZUGFeRD: Es werden keine Bruttopreise unterstützt."


#Given I open the infosystem "EVVORGANG"
#And I set field "vorgang" to id from editor "rechnung2"
#And I press start
#Then field "zuschlagsum" has value "0.00"
#Then field "ohnesteuersum" has value "90293.04"
#Then field "nettosum" has value "90293.04"
#Then field "abschlagsum" has value "0.00"
#Then field "steuersum" has value "6343.96"
#Then field "vorauszahlsum" has value "0.00"
#Then field "gesamtsum" has value "96637.00"
#Then field "restzahlsum" has value "96637.00"
#Then field "rundungsbetrag" has value "0.00"
#And I close the current editor

Scenario: Rechnung mit unterschiedlichen Steuersaetzen  Gesamtrechnungsrabatt
Given I open an editor "rechnung3" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ZFRECH3"
And I set field "bem" to "Rechnung 3: Rechnung mit unterschiedlichen Steuersaetzen + Bruttopreise + Gesamtrechnungsrabatt"
And I set field "betreff" to "Rechnung 3: Rechnung mit unterschiedlichen Steuersaetzen + Bruttopreise + Gesamtrechnungsrabatt"
And I set field "budat" to "03.01.95"
#And I set field "brutto" to "ja"
And I create a new row at the end of the table
And I set field "pnum" to "1" in row 1
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "11,90" in row 2
And I set field "preis" to "-2,38" in row 3
And I set field "zfabtyp" to "Rabatt" in row 3
And I create a new row at the end of the table
And I set field "pnum" to "2" in row !lastRow
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "artex" to "9" in row !lastRow
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "rechnung3"
And I press start
Then field "zuschlagsum" has value "0.00"
Then field "ohnesteuersum" has value "190095.20"
Then field "nettosum" has value "190095.20"
Then field "abschlagsum" has value "0.00"
Then field "steuersum" has value "21314.28"
Then field "vorauszahlsum" has value "0.00"
Then field "gesamtsum" has value "211409.48"
Then field "restzahlsum" has value "211409.48"
Then field "rundungsbetrag" has value "0.00"
And I close the current editor

Scenario: Rechnung + Projekt in der ersten Zeile
Given I open an editor "rechnung4" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ZFRECH4"
And I set field "bem" to "Rechnung 4: Rechnung + Projekt in der ersten Zeile"
And I set field "betreff" to "Rechnung 4: Rechnung + Projekt in der ersten Zeile"
And I set field "budat" to "03.01.95"
And I create a new row at the end of the table
And I set field "pnum" to "1" in row 1
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I set field "projekt" to id from editor "projekt1" in row 1
And I create a new row at the end of the table
And I set field "pnum" to "2" in row !lastRow
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "artex" to "9" in row !lastRow
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "rechnung4"
And I press start
Then field "zuschlagsum" has value "0.00"
Then field "ohnesteuersum" has value "190300.00"
Then field "nettosum" has value "190300.00"
Then field "abschlagsum" has value "0.00"
Then field "steuersum" has value "21345.00"
Then field "vorauszahlsum" has value "0.00"
Then field "gesamtsum" has value "211645.00"
Then field "restzahlsum" has value "211645.00"
Then field "rundungsbetrag" has value "0.00"
And I close the current editor

Scenario: ZUGFeRD Felder testen / Kopf und die Tabelle aus der Rechnung (Register ZUGFeRD)
Given I open an editor "rechnung5" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ZFRECH5"
And I set field "bem" to "Rechnung 5: ZUGFeRD Felder testen / Kopf und die Tabelle aus der Rechnung (Register ZUGFeRD)"
And I set field "betreff" to "Rechnung 5: ZUGFeRD Felder testen / Kopf und die Tabelle aus der Rechnung (Register ZUGFeRD)"
And I set field "budat" to "03.01.95"
And I set field "zaform" to "Lastschrift"
And I create a new row at the end of the table
And I set field "pnum" to "1" in row 1
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "pnum" to "2" in row !lastRow
And I set field "artex" to id from editor "neutralePOS" in row !lastRow
And I set field "zfzutyp" to "Werbung" in row !lastRow
And I set field "zfabtyp" to "Rabatt" in row !lastRow
And I create a new row at the end of the table
And I set field "artex" to "9" in row !lastRow
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "rechnung5"
And I press start
Then field "zahltyplang" has value "SEPA Lastschrift"
Then field "doctyplang" has value "Handelsrechnung"
Then field "duedatetypelang" has value "Ausstellungsdatum des Rechnungsbelegs"
Then field "zutyplang" has value "" in row 1
Then field "abtyplang" has value "" in row 1
#Then field "steuerbefrcodelang" has value "" in row 1
Then field "steuerartlang" has value "Mehrwertsteuer" in row 1
#Then field "steuercodelang" has value "Steuerbefreit" in row 1
Then field "zutyplang" has value "Werbung" in row 5
Then field "abtyplang" has value "" in row 5
#Then field "steuerbefrcodelang" has value "" in row 5
Then field "steuerartlang" has value "Mehrwertsteuer" in row 5
#Then field "steuercodelang" has value "Steuerbefreit" in row 5
And I close the current editor

Scenario: Rechnung mit fast allem
Given I open an editor "rechnung6" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ZFRECH6"
And I set field "bem" to "Rechnung 6: Rechnung mit fast allem"
And I set field "betreff" to "Rechnung 6: Rechnung mit fast allem"
And I set field "budat" to "03.01.95"
And I create a new row at the end of the table
And I set field "pnum" to "1" in row 1
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "20" in row 1
And I create a new row at the end of the table
And I set field "pnum" to "2" in row !lastRow
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "30" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "3" in row !lastRow
And I set field "artex" to "4" in row !lastRow
And I set field "konto" to "43000" in row !lastRow
And I set field "proz" to "-5" in row !lastRow
#And I create a new row at the end of the table
#And I set field "pnum" to "4" in row !lastRow
#And I set field "artex" to "10" in row !lastRow
#And I set field "preis" to "10" in row !lastRow
#And I set field "pwert" to "20" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "5" in row !lastRow
And I set field "artex" to id from editor "artikel3" in row !lastRow
And I set field "mge" to "40" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "6" in row !lastRow
And I set field "artex" to id from editor "zusatzAUBE" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "7" in row !lastRow
And I set field "artex" to id from editor "zusatzAUBE" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "8" in row !lastRow
And I set field "artex" to id from editor "dienstl2" in row !lastRow
And I set field "mge" to "8" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "9" in row !lastRow
And I set field "artex" to "16" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "10" in row !lastRow
And I set field "artex" to "17" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "11" in row !lastRow
And I set field "artex" to "12" in row !lastRow
And I set field "pwert" to "100" in row !lastRow
And I set field "pftext" to "Textposition" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "12" in row !lastRow
And I set field "artex" to "12" in row !lastRow
And I set field "pwert" to "-100" in row !lastRow
And I set field "pftext" to "Textposition" in row !lastRow
And I create a new row at the end of the table
And I set field "artex" to "9" in row !lastRow
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Rechnung mit fast allem + Bruttopreise
Given I open an editor "rechnung7" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ZFRECH7"
And I set field "bem" to "Rechnung 7: Rechnung mit fast allem + Bruttopreise"
And I set field "betreff" to "Rechnung 7: Rechnung mit fast allem + Bruttopreise"
And I set field "budat" to "03.01.95"
#And I set field "brutto" to "ja"
And I create a new row at the end of the table
And I set field "pnum" to "1" in row 1
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "20" in row 1
And I create a new row at the end of the table
And I set field "pnum" to "2" in row !lastRow
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "30" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "3" in row !lastRow
And I set field "artex" to "4" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "4" in row !lastRow
And I set field "artex" to "10" in row !lastRow
And I set field "preis" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "5" in row !lastRow
And I set field "artex" to id from editor "artikel3" in row !lastRow
And I set field "mge" to "40" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "6" in row !lastRow
And I set field "artex" to id from editor "zusatzAUBE" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "7" in row !lastRow
And I set field "artex" to id from editor "zusatzAUBE" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "8" in row !lastRow
And I set field "artex" to id from editor "dienstl2" in row !lastRow
And I set field "mge" to "8" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "9" in row !lastRow
And I set field "artex" to "16" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "10" in row !lastRow
And I set field "artex" to "17" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "11" in row !lastRow
And I set field "artex" to "12" in row !lastRow
And I set field "pwert" to "100" in row !lastRow
And I set field "pftext" to "Textposition" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "12" in row !lastRow
And I set field "artex" to "9" in row !lastRow
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Rechnung mit fast allem + andere Waehrung
Given I open an editor "rechnung8" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde2"
And I set field "such" to "ZFRECH8"
And I set field "bem" to "Rechnung 8: Rechnung mit fast allem + andere Waehrung"
And I set field "betreff" to "Rechnung 8: Rechnung mit fast allem + andere Waehrung"
And I set field "budat" to "03.01.95"
And I create a new row at the end of the table
And I set field "pnum" to "1" in row 1
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "20" in row 1
And I create a new row at the end of the table
And I set field "pnum" to "2" in row !lastRow
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "30" in row !lastRow
And I set field "pnum" to "2" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "3" in row !lastRow
And I set field "artex" to "4" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "4" in row !lastRow
And I set field "artex" to "10" in row !lastRow
And I set field "preis" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "5" in row !lastRow
And I set field "artex" to id from editor "artikel3" in row !lastRow
And I set field "mge" to "40" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "6" in row !lastRow
And I set field "artex" to id from editor "zusatzAUBE" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "7" in row !lastRow
And I set field "artex" to id from editor "zusatzAUBE" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "8" in row !lastRow
And I set field "artex" to id from editor "dienstl2" in row !lastRow
And I set field "mge" to "8" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "9" in row !lastRow
And I set field "artex" to "16" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "10" in row !lastRow
And I set field "artex" to "17" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "11" in row !lastRow
And I set field "artex" to "12" in row !lastRow
And I set field "pwert" to "100" in row !lastRow
And I set field "pftext" to "Pangramme mit aeoeue und ss:(71 Buchstaben) -> Zornig und gequaelt ruegen jeweils Pontifex und Volk die masslose bischoefliche Hybris." in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "12" in row !lastRow
And I set field "artex" to "9" in row !lastRow
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor 

#Anzahlungsrechnung anlegen
Scenario: Auftrag anlegen fuer die Anzahlungsrechnung
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ZFauftrag"
And I set field "betreff" to "Auftrag mit Fakturaplan"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "1" in row !lastRow
And I save the current editor
Then field "fktaplan" is empty
Then field "zbed" has value "201"

Scenario: Fakturaplan fuer Auftrag anlegen
Given I open an editor "vkfakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "auftrag"
And I set field "namebspr" to "Fakturaplan zu Auftrag"
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 1
And I set field "proz" to "20" in row 1
And I set field "ptext" to "1. Anzahlung" in row 1
And I set field "zbed" to "203" in row 1

#Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "vkanzahlung" in row 1
And I set field "such" to "ZFANZRE1"
And I set field "ueb" to "ja"
And I set field "budat" to "03.01.95"
And I set field "pnum" to "1" in row 1
And I set field "zfzutyp" to "(ChargeReasonCodeRAD)" in row 1
And I create a new row at the end of the table
And I set field "pnum" to "3" in row !lastRow
And I set field "artex" to "9" in row !lastRow
And I set field "zfzutyp" to "(ChargeReasonCodeRAD)" in row !lastRow
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "vkfakturaplan"
Then field "sumfakturiert" has value "3806.00" in row 1
And I save the current editor

Scenario: Schlussrechnug anlegen
Given I open an editor "rechnung9" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "such" to "ZFRECH9"
#And I set field "ueb" to "ja"
And I set field "budat" to "03.01.95"
And I set field "pnum" to "1" in row 1
And I set field "pnum" to "1" in row 4
And I press button "offueb" in row 1
And I press button "offueb" in row 4
And I set field "zfabtyp" to "Rabatt" in row 5
And I create a new row at the end of the table
And I set field "pnum" to "3" in row !lastRow
And I set field "artex" to "9" in row !lastRow
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Gutschrift anlegen
Scenario: Auftrag anlegen fuer die Gutschrift
Given I open an editor "auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "ZFAUFGUT1"
And I set field "betreff" to "Auftrag fuer Gutschrift"
When I create a new row at the end of the table
And I set field "pnum" to "1" in row !lastRow
And I set field "artex" to id from editor "artikel2" in row 1
And I set field "mge" to "-1" in row 1
And I create a new row at the end of the table
And I set field "artex" to "9" in row !lastRow
And I set field "pnum" to "2" in row !lastRow
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Gutschrift anlegen
Given I open an editor "rechnung10" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag2"
And I set field "such" to "ZFGUT2"
And I set field "ueb" to "ja"
And I set field "budat" to "03.01.95"
And I press button "offueb" in row 1
And I create a new row at the end of the table
And I set field "pnum" to "1" in row !lastRow
And I set field "artex" to "9" in row !lastRow
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Rechnung mit fast allem + Kunde ungleich Rechnungsempfaenger und ungleich Warenempfaenger + Zahlungsbedingungsschluessel
Given I open an editor "rechnung11" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "kunde2" to id from editor "BGG"
And I set field "kunde3" to id from editor "kunde2"
And I set field "such" to "ZFRECH11"
And I set field "bem" to "Rechnung 11: Rechnung mit fast allem + Kunde ungleich Rechnungsempfaenger und ungleich Warenempfaenger + Zahlungsbedingungsschluessel"
And I set field "betreff" to "Rechnung 11: Rechnung mit fast allem + Kunde ungleich Rechnungsempfaenger und ungleich Warenempfaenger + Zahlungsbedingungsschluessel"
And I set field "zbedschl" to "4"
And I set field "budat" to "03.01.95"
And I create a new row at the end of the table
And I set field "pnum" to "1" in row 1
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "20" in row 1
And I create a new row at the end of the table
And I set field "pnum" to "2" in row !lastRow
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "30" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "3" in row !lastRow
And I set field "artex" to "4" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "4" in row !lastRow
And I set field "artex" to "10" in row !lastRow
And I set field "preis" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "5" in row !lastRow
And I set field "artex" to id from editor "dienstl2" in row !lastRow
And I set field "mge" to "3" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "6" in row !lastRow
And I set field "artex" to id from editor "zusatzAUBE" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "7" in row !lastRow
And I set field "artex" to id from editor "zusatzAUBE" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "8" in row !lastRow
And I set field "artex" to id from editor "dienstl2" in row !lastRow
And I set field "mge" to "8" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "9" in row !lastRow
And I set field "artex" to "16" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "10" in row !lastRow
And I set field "artex" to "17" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "11" in row !lastRow
And I set field "artex" to "12" in row !lastRow
And I set field "pwert" to "100" in row !lastRow
And I set field "pftext" to "Textposition" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "12" in row !lastRow
And I set field "artex" to "9" in row !lastRow
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Rechnung mit fast allem + Kunde ungleich Rechnungsempfaenger und ungleich Warenempfaenger + Zahlungsverteiler
Given I open an editor "rechnung12" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "kunde2" to id from editor "BGG"
And I set field "kunde3" to id from editor "kunde2"
And I set field "such" to "ZFRECH12"
And I set field "bem" to "Rechnung 12: Rechnung mit fast allem + Kunde ungleich Rechnungsempfaenger und ungleich Warenempfaenger + Zahlungsverteiler"
And I set field "betreff" to "Rechnung 12: Rechnung mit fast allem + Kunde ungleich Rechnungsempfaenger und ungleich Warenempfaenger + Zahlungsverteiler"
And I set field "zbedvert" to id from editor "zverteiler"
And I set field "budat" to "03.01.95"
And I create a new row at the end of the table
And I set field "pnum" to "1" in row 1
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "20" in row 1
And I create a new row at the end of the table
And I set field "pnum" to "2" in row !lastRow
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "30" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "3" in row !lastRow
And I set field "artex" to "4" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "4" in row !lastRow
And I set field "artex" to "10" in row !lastRow
And I set field "preis" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "5" in row !lastRow
And I set field "artex" to id from editor "dienstl2" in row !lastRow
And I set field "mge" to "3" in row !lastRow
And I create a new row at the end of the table
And I set field "artex" to id from editor "zusatzAUBE" in row !lastRow
And I set field "pnum" to "6" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "7" in row !lastRow
And I set field "artex" to id from editor "zusatzAUBE" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "8" in row !lastRow
And I set field "artex" to id from editor "dienstl2" in row !lastRow
And I set field "mge" to "8" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "9" in row !lastRow
And I set field "artex" to "16" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "10" in row !lastRow
And I set field "artex" to "17" in row !lastRow
And I create a new row at the end of the table
And I set field "pnum" to "11" in row !lastRow
And I set field "artex" to "12" in row !lastRow
And I set field "pwert" to "100" in row !lastRow
And I set field "pftext" to "Textposition" in row !lastRow
And I create a new row at the end of the table
And I set field "artex" to "9" in row !lastRow
#And I respond with answer "Ja" to the dialog with id "4841"
Then saving the current editor throws the exception "ZUGFeRD: Der Zahlungsverteiler darf nicht gefüllt sein. Bitte entfernen."
And I set field "zbedvert" to ""
And I save the current editor

Scenario: Rechnung1 drucken
Given I open an editor "rechnung100" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung1"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "ZUGFERD2"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "loglevel" to "9"
And I set field "datname" to "rmtmp/rechnung1.pdf"
And I save the current editor
And I switch the current editor to editor "rechnung100"
And I close the current editor

#Scenario: Rechnung2 drucken
#Given I open an editor "rechnung101" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung2"
#And I press button "budruck2" to open a subeditor for "Druckdialog"
#And I set field "layout" to "ZUGFERD2"
#And I set field "drucker" to "DATEI"
#And I set field "archiv" to "nein"
#And I set field "loglevel" to "9"
#And I set field "datname" to "rmtmp/rechnung2.pdf"
#And I save the current editor
#And I switch the current editor to editor "rechnung101"
#And I close the current editor

Scenario: Rechnung3 drucken
Given I open an editor "rechnung102" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung3"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "ZUGFERD2"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "loglevel" to "9"
And I set field "datname" to "rmtmp/rechnung3.pdf"
And I save the current editor
And I switch the current editor to editor "rechnung102"
And I close the current editor

Scenario: Rechnung4 drucken
Given I open an editor "rechnung103" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung4"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "ZUGFERD2"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "loglevel" to "9"
And I set field "datname" to "rmtmp/rechnung4.pdf"
And I save the current editor
And I switch the current editor to editor "rechnung103"
And I close the current editor

Scenario: Rechnung5 drucken
Given I open an editor "rechnung104" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung5"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "ZUGFERD2"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "loglevel" to "9"
And I set field "datname" to "rmtmp/rechnung5.pdf"
And I save the current editor
And I switch the current editor to editor "rechnung104"
And I close the current editor
#Rechnung 5 muss scheitern da Steuerfrei eingetragen ist obwohl der Steuerschlüssel 1 eingetragen ist

Scenario: Rechnung6 drucken
Given I open an editor "rechnung105" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung6"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "ZUGFERD2"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "loglevel" to "7"
And I set field "datname" to "rmtmp/rechnung6.pdf"
And I save the current editor
And I switch the current editor to editor "rechnung105"
And I close the current editor

Scenario: Rechnung7 drucken
Given I open an editor "rechnung106" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung7"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "ZUGFERD2"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "loglevel" to "7"
And I set field "datname" to "rmtmp/rechnung7.pdf"
And I save the current editor
And I switch the current editor to editor "rechnung106"
And I close the current editor

Scenario: Rechnung8 drucken
Given I open an editor "rechnung107" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung8"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "ZUGFERD2"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "loglevel" to "7"
And I set field "datname" to "rmtmp/rechnung8.pdf"
And I save the current editor
And I switch the current editor to editor "rechnung107"
And I close the current editor

Scenario: Anzahlungs-Rechnung drucken
Given I open an editor "rechnung1anz" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "vkanzahlung"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "ZUGFERD2"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "loglevel" to "7"
And I set field "datname" to "rmtmp/rechnunganz.pdf"
And I save the current editor
And I switch the current editor to editor "rechnung1anz"
And I close the current editor

Scenario: Rechnung9 Schlussrechnung drucken 
Given I open an editor "rechnung108" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung9"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "ZUGFERD2"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "loglevel" to "7"
And I set field "datname" to "rmtmp/rechnung9.pdf"
And I save the current editor
And I switch the current editor to editor "rechnung108"
And I close the current editor

Scenario: Gutschrift 10 drucken
Given I open an editor "rechnung109" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung10"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "ZUGFERD2"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "loglevel" to "7"
And I set field "datname" to "rmtmp/rechnung10.pdf"
And I save the current editor
And I switch the current editor to editor "rechnung109"
And I close the current editor

Scenario: Rechnung11 drucken
Given I open an editor "rechnung110" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung11"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "ZUGFERD2"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "loglevel" to "7"
And I set field "datname" to "rmtmp/rechnung11.pdf"
And I save the current editor
And I switch the current editor to editor "rechnung110"
And I close the current editor

Scenario: Rechnung12 ohne einen Zahlungsverteiler drucken - irgendwann muss das mit Zahlungsverteiler funktionieren?
Given I open an editor "rechnung111" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung12"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "ZUGFERD2"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "loglevel" to "7"
And I set field "datname" to "rmtmp/rechnung12.pdf"
And I save the current editor
And I switch the current editor to editor "rechnung111"
And I close the current editor

Scenario: Rechnung 1 stornieren und drucken
Given I open an editor "rechnungbuchen1" from table "(Sales):(Invoice)" with command "TRANSFER" for record from editor "rechnung1"
And I save the current editor
And I close the current editor

Given I open an editor "rechnung1storno" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung1"
And I save the current editor
And I close the current editor

Scenario: Stornorechnung drucken
Given I open an editor "rechnungdruck1storno" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung1storno"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "ZUGFERD2"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "loglevel" to "7"
And I set field "datname" to "rmtmp/rechnung1storno.pdf"
And I save the current editor
And I switch the current editor to editor "rechnungdruck1storno"
And I close the current editor
