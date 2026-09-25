# *****************************************************************************
#  Name           : createinvoice.feature
#  Autor          : cl
#  Verantwortlich : cl
#  Kontrolle      : teampss
#  Funktion       : Testet das IS CREATEINVOICE
#
# *****************************************************************************
#
@persistent
Feature: Daten fuer CREATEINVOICE anlegen
Background:
Given I set the fake date to "02.01.1995"
Given I set saved value "REF_FILE" to "VK.CREATEINVOICE.CU.REF"
Given I set saved value "Feldliste1" to "vlnummer,vkkl2,twarenempf,vkkbelegnr,rechnung,sumbrutto,waehr,tkunde,vertreter,zeich,zbed,pbed,laart,vrgstrgl,treturnus"
Given I set saved value "Feldliste2" to "vlnummer,vkkl2,twarenempf,vkkbelegnr,rechnung,vom,budat,sumbrutto,waehr,tkunde,vertreter,zeich,zbed,pbed,laart,vrgstrgl,treturnus"


@Stammdaten
Scenario: Stammdaten Lagergruppen, Lagerplätze, Lohnfertiger, Beistellung

# Lieferant 1 Waehrung EUR
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "1"
And I set field "waehr" to "EUR"
And I save the current editor

# Kunde 1 Waehrung EUR
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "1"
And I set field "waehr" to "EUR"
And I save the current editor

# Kunde 4 Waehrung EUR, Zahlungsbedingung und Turnus
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "4"
And I set field "waehr" to "EUR"
And I set field "zbed" to "201"
And I set field "rechturnus" to "Woche"
And I save the current editor

# Kunde 102 Waehrung EUR und Turnus
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "102"
And I set field "rechturnus" to "Monat"
And I save the current editor

# Zusatzposition Anzahlung mit richtigen Konten
Given I open an editor "zuspos" from table "(Part):(SupplementaryItem)" with command "STORE" for record "ANZAHLUNG"
And I set field "ekonto" to "07800"
And I set field "vkonto" to "32700"
And I save the current editor

# Konto 32700 mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "STORE" for record "32700"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

# Konto 11840 mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "STORE" for record "11840"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

######################################

# Lagergruppe Kundenanlieferung
Given I open an editor "K-Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KUNDENAN"
And I set field "such" to "KUNDENAN"
And I set field "namebspr" to "Kundenanlieferung"
And I set field "zkonsilg" to "JA"
And I save the current editor

# Konsignationslager Lieferanten Lagerplatz
Given I open an editor "K-Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "KUNDENAN"
And I set field "such" to "KUNDENAN"
And I set field "namebspr" to "Kundenanlieferung"
And I set field "lgruppe" to "KUNDENAN"
And I set field "disporel" to "NEIN"
And I save the current editor

# Lieferanten Lagerplatz
Given I open an editor "K-Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "KUNDENAN"
And I set field "such" to "KUNDENAN"
And I set field "namebspr" to "Kundenanlieferung-Platz"
And I set field "lager" to "KUNDENAN"
And I save the current editor


#####################################################################################################################################

@FALL-901
Scenario: FALL-901 VK Kundenanlieferung

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "901-FALL"
And I set field "num2" to "901-FALL"
And I set field "such" to "FALL-901"
And I set field "namebspr" to "FALL-901"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "55"
And I set field "erlgrp" to "66"
# Maybe more
And I save the current editor

# Lieferschein Kundenanlieferung anlegen -> diese darf nicht in CREATEINVOICE erscheinen
Given I open an editor "lieferschein-1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "(CustomerDelivery)"
And I set field "kunde" to "1"
And I set field "num3" to "901-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "art" to "901-FALL" in row 1
And I set field "mge" to "-901" in row 1
And I set field "platz" to "KUNDENAN" in row 1
And I set field "kenn" to "FALL-901"
And I save the current editor


Scenario: STAMMDATEN - Neuen Kunden anlegen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Bayram"
And I set field "num" to "77777"
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

Scenario Outline: STAMMDATEN - Drei neue Artikel anlegen
Given I open an editor "<such>" from table "02:01" with command "STORE" for record "<num2>"
And I set field "num2" to "<num2>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "bsart" to "<bsart>"
And I set field "dispoa" to "<dispoa>"
And I set field "packanwstdversand" to "<packanwstdversand>"
And I set field "fmengestdversand" to "<fmengestdversand>"
And I set field "matart" to "<matart>"
And I set field "zmge" to "<zmge>"
And I set field "matvrel" to "<matvrel>"
And I set field "materel" to "<materel>"
And I save the current editor

Examples: Artikel
| num2  | such      | namebspr     | vkbez     | vbez       | ebez         | vpr    | bsart             | dispoa          | packanwstdversand| fmengestdversand | matart | zmge | matvrel | materel |
| 11111 | artikel1  | Artikel 1    | Artikel 1 | Artikel 1  | Artikel 1    | 10000  | Fremdbeschaffung  | bedarfsbezogen  | 501              | 10               | CU     | 1    | ja      |         |
| 22222 | artikel2  | Artikel 2    | Artikel 2 | Artikel 2  | Artikel 2    | 9000   | Fremdbeschaffung  | bedarfsbezogen  | 501              | 10               | CU     | 1    |         | ja      |
| 33333 | artikel3  | Artikel 3    | Artikel 3 | Artikel 3  | Artikel 3    | 8000   | Fremdbeschaffung  | bedarfsbezogen  | 501              | 10               |        |      |         |         |

Scenario Outline: STAMMDATEN - Zusatzposition anlegen
Given I open an editor "<zusatzpos>" from table "02:04" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "kategorie" to "<kategorie>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "epr" to "<epr>"
And I save the current editor

Examples: Zusatzposition
| zusatzpos       | such    | namebspr             | zptyp             | kategorie | vkbez                   | vbez                 | ebez                  | vpr   | epr  |
| zusatzAUBE      | AUBE    | Zusatzposition AU/BE | AU/BE-Position,BV |           | Zusatzposition AU/BE    | Zusatzposition AU/BE | Zusatzposition AU/BE  | 1100  | 1000 |
| neutralePOS     | NEUPOS  | Neutrale Position    | Neutrale Position |           | Neutrale Position       | Neutrale Position    | Neutrale Position     | 500   | 400  |
| gutschein       | GUTS    | Gutschein            | Neutrale Position | gutschein | Gutschein               | Gutschein            | Gutschein             | 0     | 0    |

Scenario: STAMMDATEN - Rechnungstellung anlegen
Given I open an editor "rechstellung" from table "(Company):(Invoicing)" with command "STORE" for record "rtext"
And I set field "such" to "rtext"
And I create a new row at the end of the table
And I set field "posex" to "text" in row 1
And I save the current editor

Scenario: Lieferscheine anlegen
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

#Zahlungsbedingung unterschiedlich
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "zbed" to "200"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel3" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "zbed" to "200"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnungsempfaenger unterschiedlich
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "kl2" to "4"
# Turnus aus Rechnungskunde 4 ueberschreiben (Woche)
And I set field "rechturnus" to "Jahr"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "kl2" to "4"
# Turnus aus Rechnungskunde 4 ueberschreiben (Woche)
And I set field "rechturnus" to "Monat"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel3" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnungsstellung unterschiedlich
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "rechnung" to "6"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "rechnung" to "6"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "rechnung" to id from editor "rechstellung"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel3" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "rechnung" to id from editor "rechstellung"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

#Vertreter unterschiedlich
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vertret" to "4"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel3" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vertret" to "4"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vertret" to "1"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vertret" to "1"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel3" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

# Preisstellung unterschiedlich
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "pbed" to "51"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "pbed" to "51"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "pbed" to "52"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel3" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "pbed" to "52"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

# Waehrung unterschiedlich
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "waehr" to "USD"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "waehr" to "USD"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel3" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

# Vorgangssteuerregel unterschiedlich
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vrgstrgl" to "5003"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel3" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vrgstrgl" to "5003"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Scenario:  Infosystem starten - 1
Given I open the infosystem "CREATEINVOICE"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"

Scenario:  Infosystem starten - 2
Given I open the infosystem "CREATEINVOICE"
And I set field "faelligkeit" to "."
And I set field "lsohnezbed" to "ja"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"

Scenario:  Infosystem starten - 3
Given I open the infosystem "CREATEINVOICE"
And I set field "lsohnezbed" to "ja"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"

Scenario:  Infosystem starten - 4
Given I open the infosystem "CREATEINVOICE"
And I set field "faelligkeit" to "."
And I set field "selvertret" to "1"
And I set field "lsohnezbed" to "ja"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"

Scenario:  Infosystem starten - 5
Given I open the infosystem "CREATEINVOICE"
And I set field "faelligkeit" to "."
And I set field "kunde" to "77777"
And I set field "lsohnezbed" to "ja"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"

Scenario:  Infosystem starten - 6
Given I open the infosystem "CREATEINVOICE"
And I set field "faelligkeit" to "."
And I set field "warenempf" to "4711"
And I set field "lsohnezbed" to "ja"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste2" from table content to output file "$REF_FILE"

Scenario:  Infosystem starten - 7
Given I open the infosystem "CREATEINVOICE"
And I set field "faelligkeit" to "."
And I set field "kzeich" to "sa"
And I set field "lsohnezbed" to "ja"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste2" from table content to output file "$REF_FILE"

Scenario:  Infosystem starten - 8
Given I open the infosystem "CREATEINVOICE"
And I set field "faelligkeit" to "."
And I set field "projekt" to "100800"
And I set field "lsohnezbed" to "ja"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste2" from table content to output file "$REF_FILE"

Scenario:  Infosystem starten - 9
Given I open the infosystem "CREATEINVOICE"
And I set field "faelligkeit" to "."
And I set field "lsohnezbed" to "ja"
And I press button "bstart"
And I press button "bugruppen"
Then field "freeslnummer" has value "22"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"

Scenario:  Infosystem starten - 10
Given I open the infosystem "CREATEINVOICE"
And I set field "faelligkeit" to "."
And I set field "bkriterien" to "ja"
And I set field "lsohnezbed" to "ja"
And I press button "bstart"
Then field "freeslnummer" has value "1"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I press button "bugruppen"
Then field "freeslnummer" has value "22"
And I press button "buerstellen"
# hier passiert leider nichts ;-( wird edp nicht ausgefuehrt?
Then field "ticon" has value "" in row 1
# in ticon muessten eigentlich Haken stehen
Then field "freeslnummer" has value "22"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"


# ----------------------------------------------------------------------------------------------
Scenario: Rechnungsturnus im VK Schreibschutz und Vererbung der Werte
# ----------------------------------------------------------------------------------------------
# vkrechturnus gibt es nur im VK
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "1"
And I set field "rechturnus" to "Monat"
And I save the current editor

Given I open an editor "CH01" from table "(Sales):(Opportunity)" with command "NEW" for record ""
And I set fields
   | kunde   | 4        |
   | kl2     | 4        |
   | such    | CH01     |
And I append rows
   | artikel   | mge | preis | intrarel |
   | !artikel1 | 20  | 6     | nein     |
Then field "rechturnus" is not modifiable
Then field "rechturnus" has value "Woche"
And I save the current editor

# Angebot
Given I open an editor "AN01" from table "(Sales):(Opportunity)" with command "RELEASE" for record from editor "CH01"
And I set fields
   | such    | AN01    |
Then field "rechturnus" is modifiable
Then field "rechturnus" has value "Woche"
And I set field "rechturnus" to "Quartal"
And I set field "kl2" to "4"
Then field "rechturnus" has value "Woche"
And I set field "rechturnus" to "Halbjahr"
And I save the current editor

# Auftrag
Given I open an editor "AU01" from table "(Sales):(Quotation)" with command "RELEASE" for record from editor "AN01"
And I set fields
   | such    | AU01    |
Then field "rechturnus" is modifiable
Then field "rechturnus" has value "Halbjahr"
And I set field "kl2" to "4"
Then field "rechturnus" has value "Woche"
And I set field "rechturnus" to "Halbjahr"
And I save the current editor

# Lieferschein
Given I open an editor "LS01" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU01"
And I set fields
   | such   | LS01 |
   | ueb    | ja   |
   | tterm  | .    |
   | budat  | .    |
And I set field "mge" to "20" in row 1
Then field "rechturnus" is modifiable
Then field "rechturnus" has value "Halbjahr"
And I set field "kl2" to "4"
Then field "rechturnus" has value "Woche"
And I set field "rechturnus" to "Halbjahr"
And I save the current editor

# Storno Lieferschein Versuch
Given I open an editor "SLS01" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS01"
Then field "rechturnus" is not modifiable
And I close the current editor

# Rechnung
Given I open an editor "RE01" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS01"
And I set fields
   | such   | RE01 |
   | ueb    | ja   |
   | tterm  | .    |
   | budat  | .    |
Then field "rechturnus" is not modifiable
Then field "rechturnus" has value "Halbjahr"
And I set field "intrarel" to "nein" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Storno Rechnung Versuch
Given I open an editor "SRE01" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE01"
Then field "rechturnus" is not modifiable
And I close the current editor

# RLS
Given I open an editor "RLS01" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS01"
And I set fields
   | such   | RLS01 |
   | ueb    | ja    |
   | tterm  | .     |
   | budat  | .     |
And I set field "mge" to "-10" in row 1
Then field "rechturnus" has value "Halbjahr"
Then field "rechturnus" is modifiable
And I save the current editor

# Storno RLS Versuch
Given I open an editor "SRLS01" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS01"
Then field "rechturnus" is not modifiable
And I close the current editor

# KGS
Given I open an editor "KGS01" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS01"
And I set fields
   | such   | KGS01 |
   | ueb    | ja    |
   | tterm  | .     |
   | budat  | .     |
Then field "rechturnus" is not modifiable
And I set field "mge" to "-10" in row 1
And I set field "intrarel" to "nein" in row 1
Then field "rechturnus" has value "Halbjahr"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Storno KGS Versuch
Given I open an editor "SKGS01" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS01"
Then field "rechturnus" is not modifiable
And I close the current editor

# WGS
Given I open an editor "WGS01" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE01"
And I set fields
   | such  | WGS01 |
   | ueb   | ja    |
   | tterm | .     |
   | budat | .     |
Then field "rechturnus" has value "Halbjahr"
And I set field "mge" to "-10" in row 1
And I save the current editor

# Storno WGS Versuch
Given I open an editor "SWGS01" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WGS01"
Then field "rechturnus" is not modifiable
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Rechnungsturnus bei Rahmenauftrag freigeben
# ----------------------------------------------------------------------------------------------
# neuen Rahmenauftrag anlegen
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 4       |
   | kl2     | 4       |
   | such    | RA01    |
Then field "rechturnus" is modifiable
Then field "rechturnus" has value "Woche"
And I set field "rechturnus" to "Halbjahr"
And I append rows
    | artikel   | mge  | zgltvon  | zgltbis  | einplan |
    | !artikel1 | 2700 | 01.01.95 | 01.01.96 | ja      |
And I save the current editor

# Rhmenauftrag freigeben
Given I open an editor "AU02" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record from editor "Rahmen"
Then field "rechturnus" is modifiable
# Rechnungsturnus kommt aus Rahmenauftrag
Then field "rechturnus" has value "Halbjahr"
And I save the current editor

