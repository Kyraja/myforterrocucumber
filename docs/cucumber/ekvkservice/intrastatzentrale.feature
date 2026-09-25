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
Feature: IS Intrastatzentrale
Background:
Given I set the fake date to "02.01.1995"
Given I set saved value "REF_FILE" to "INTRASTATZENTRALE.CU.REF"
Given I set saved value "Feldliste1" to "iflow,vorgang,vorgang^vorganga"
Given I set saved value "Feldliste2" to "iflow,mge,kuerzel,swert"

Scenario: Warengruppe anlegen
Given I open an editor "warennum" from table "(Company):(Summary)" with command "STORE" for record "warennumme"
And I set field "such" to "WARENNUMME"
And I set field "namebspr" to "Warennummer"
And I set field "ahnum" to "12345678"
And I save the current editor

Scenario: Finanzamtsdaten aktualisieren
Given I open an editor "region" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "Deutschland"
And I set field "finlakenn" to "BADEN-W"
And I set field "steunr" to "12345678901"
And I save the current editor

Scenario: Geschaeftsart anlegen
Given I open an editor "geschart" from table "(Company):(Summary)" with command "STORE" for record "geart"
And I set field "such" to "GEART"
And I set field "schl" to "34"
And I set field "namebspr" to "sonstige Geschäfte"
And I save the current editor

Scenario: STAMMDATEN - Neuen EU-Kunden anlegen
Given I open an editor "kunde" from table "00:01" with command "STORE" for record "Bayram"
And I set field "such" to "Bayram"
And I set field "namebspr" to "Bayram Werkzeugbau, Rastatt"
And I set field "ans" to "Bayram Werkzeugbau GmbH"
And I set field "str" to "Riedstr. 24-28"
And I set field "plz" to "76437"
And I set field "nort" to "Rastatt"
And I set field "staat" to "Italien"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@bayram-corp.de"
And I set field "betreuer" to "."
And I set field "ustid" to "IT99999999999"
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I set field "gart" to id from editor "geschart"
And I save the current editor
Then field "name" has value "Bayram Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

Scenario: STAMMDATEN - Neuen EU-Lieferanten anlegen
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "REUS"
And I set field "such" to "REUS"
And I set field "namebspr" to "Reus Werkzeugbau, Rastatt"
And I set field "ans" to "Reus Werkzeugbau GmbH"
And I set field "str" to "Riedstr. 24-28"
And I set field "plz" to "76437"
And I set field "nort" to "Rastatt"
And I set field "staat" to "Italien"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@bayram-corp.de"
And I set field "betreuer" to "."
And I set field "ustid" to "IT99999999999"
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I set field "gart" to id from editor "geschart"
And I save the current editor
Then field "name" has value "Reus Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

Scenario Outline: STAMMDATEN - Drei neue Artikel anlegen
Given I open an editor "<such>" from table "02:01" with command "STORE" for record "<such>"
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
And I set field "intrarel" to "ja"
And I set field "ahnum" to id from editor "warennum"
And I set field "urregion" to "Bayern"
And I set field "urland" to "Deutschland"
And I set field "bsregion" to "Baden"
And I save the current editor

Examples: Artikel
|such      | namebspr      |  vkbez       |  vbez        |    ebez       |  vpr     | bsart             |  dispoa          | lief  |  epr   |  efrist |
|artikel1  |    Artikel 1  |  Artikel 1   |   Artikel 1  |    Artikel 1  |   10000  | Fremdbeschaffung  |   bedarfsbezogen |  reus |  9000  |  15     |
|artikel2  |    Artikel 2  |  Artikel 2   |   Artikel 2  |    Artikel 2  |   9000   | Fremdbeschaffung  |   bedarfsbezogen |  reus |  7000  |  10     |
|artikel3  |    Artikel 3  |  Artikel 3   |   Artikel 3  |    Artikel 3  |   8000   | Fremdbeschaffung  |   bedarfsbezogen |  reus |  6000  |  12     |

Scenario Outline: STAMMDATEN - Zusatzpositionen vom Typ AU/BE und neutrale Position anlegen
Given I open an editor "<zusatzpos>" from table "02:04" with command "STORE" for record "<such>"
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


Scenario: STAMMDATEN - Konsignationslagergruppe anlegen
Given I open an editor "Konsignationslg" from table "39:02" with command "STORE" for record "konsi"
And I set field "such" to "konsi"
And I set field "namebspr" to "Konsignationslagergruppe"
And I set field "zkonsilg" to "ja"
And I save the current editor

Scenario: STAMMDATEN - Externe Lagergruppe anlegen
Given I open an editor "Externelg" from table "39:02" with command "STORE" for record "extern"
And I set field "such" to "extern"
And I set field "namebspr" to "Externe Lagergruppe"
And I set field "zkonsilg" to "nein"
And I save the current editor

Scenario Outline: STAMMDATEN - Konsignationslager und externes Lager anlegen
Given I open an editor "<lager>" from table "39:01" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples: Lager
|lager           | such       |             namebspr             |     lgruppe           |
|Konsignationsla | konsi      |             Konsignationslager   |     Konsignationslg   |
|Externesla      | extern     |             Externes Lager       |     Externelg         |

Scenario Outline: STAMMDATEN - Konsignationslagerplatz und externen Lagerplatz anlegen
Given I open an editor "<lagerplatz>" from table "38:01" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lager" to id from editor "<lager>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples: Lagerplatz
|lagerplatz   |   such   |  namebspr             |   lager            | lgruppe          |
|Konsilp      |   konsi  |  Konsignationslager   |   Konsignationsla  | Konsignationslg  |
|Externerlp   |   extern |  Externer Lagerplatz  |   Externesla       | Externelg        |

Scenario: In interner Lagergruppe den Konsigationslagerplatz eintragen
Given I open an editor "lagergruppe" from table "39:02" with command "UPDATE" for record "KARLSRUHE"
And I set field "vkkundenanlieferung" to id from editor "Konsilp"
And I close the current editor

Scenario: Auftrag mit zwei Positionen anlegen, daraus KundenAL und LS erstellen und dann Rechnung und kaufmaennische Gutschrift erstellen
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row 2
And I set field "mge" to "-1" in row 2
And I save the current editor

#Lieferschein aus Auftrag erzeugen
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
Then the table has 1 rows
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I save the current editor

#Kundenanlieferung aus Auftrag erzeugen
Given I open an editor "kundenanlieferung" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "kundenanlieferung"
And I set field "beleg" to id from editor "auftrag"
Then the table has 1 rows
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I set field "platz" to "konsi" in row 1
And I save the current editor

#Kaufmaennische Gutschrift aus Kundenanlieferung erzeugen
Given I open an editor "kaufmgutschrift" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "kundenanlieferung"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Rechnung aus Lieferschein erzeugen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Einkauf
Scenario: Bestellung mit einer Position anlegen, daraus LS und RLS erstellen und dann Rechnung und kaufmaennische Gutschrift erstellen
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

#Lieferschein aus Bestellung erzeugen
Given I open an editor "eklieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "ebeleg" to "LS"
And I set field "vom" to "."
Then the table has 1 rows
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I save the current editor

#Rechnung aus Lieferschein erstellen
Given I open an editor "ekrechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "eklieferschein"
And I set field "ebeleg" to "RE"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Ruecklieferung aus Lieferschein erstellen
Given I open an editor "ekruekl" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "eklieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "ebeleg" to "RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "-3" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor

#KGS zu Ruecklieferung erstellen
Given I open an editor "ekguts" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I set field "beleg" to id from editor "ekruekl"
And I set field "ebeleg" to "KGS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#INTRASTATZENTRALE
Scenario: Infosystem INTRASTATZENTRALE 1. Mal aufrufen
Given I open the infosystem "INTRASTATZENTRALE"
And I press button "aktmonat"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

Scenario: Infosystem INTRASTATZENTRALE 1. Mal aufrufen nur Versendung
Given I open the infosystem "INTRASTATZENTRALE"
And I press button "aktmonat"
And I set field "bere" to "FALSE"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

Scenario: Infosystem INTRASTATZENTRALE 1. Mal aufrufen nur Eingang
Given I open the infosystem "INTRASTATZENTRALE"
And I press button "aktmonat"
And I set field "bvre" to "FALSE"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

#INTRASTATNACHRICHT fuer Eingang
Scenario: Infosytem INTRASTATNACHRICHT 1. Mal aufrufen
Given I open the infosystem "INTRASTATNACHRICHT"
And I set field "kvorgang" to id from editor "kaufmgutschrift"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste2" from table content to output file "$REF_FILE"
And I close the current editor

Scenario: Infosytem INTRASTATNACHRICHT 2. Mal aufrufen
Given I open the infosystem "INTRASTATNACHRICHT"
And I set field "kvorgang" to id from editor "ekguts"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste2" from table content to output file "$REF_FILE"
And I close the current editor

Scenario: Kaufmaennische Gutschrift aus Verkauf stornieren
Given I open an editor "vkgutstorno" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "kaufmgutschrift"
And I save the current editor

#INTRASTATZENTRALE
Scenario: Infosystem INTRASTATZENTRALE 2. Mal aufrufen
Given I open the infosystem "INTRASTATZENTRALE"
And I press button "aktmonat"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

Scenario: Kaufmaennische Gutschrift aus Einkauf stornieren
Given I open an editor "ekgutstorno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "ekguts"
And I save the current editor

#INTRASTATZENTRALE
Scenario: Infosystem INTRASTATZENTRALE 3. Mal aufrufen
Given I open the infosystem "INTRASTATZENTRALE"
And I press button "aktmonat"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

#KGS im Einkauf direkt erzeugen (ohne Vorgaenger)
Scenario: KGS anlegen, EK-Rechnung anfuegen und Zusatzposition anhaengen
Given I open an editor "kgsdirekt" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ekrechnung"
And I set field "ebeleg" to "KGS2"
And I set field "vom" to "."
And I create a new row at position 1
And I set field "artex" to id from editor "textPOS" in row 1
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#INTRASTATZENTRALE
Scenario: Infosystem INTRASTATZENTRALE 4. Mal aufrufen
Given I open the infosystem "INTRASTATZENTRALE"
And I press button "aktmonat"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Intrastat-Relevanz bei Wertgutschrift nicht neu ermitteln
# ----------------------------------------------------------------------------------------------

# Rechnung mit LB
Given I open an editor "REINTRA" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 002     |
   | such   | REINTRA |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
And I append rows
   | artikel   | mge | preis |
   | !artikel1 | 20  | 7     |
Then field "intrarel" has value "ja" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "WGSINTRA" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "REINTRA"
And I set fields
   | such   | WGSINTRA |
   | ueb    | ja       |
   | tterm  | .        |
And I set field "mge" to "-10" in row 1
Then field "intrarel" has value "nein" in row 1
And I set field "budat" to "+1"
Then field "intrarel" has value "nein" in row 1
And I save the current editor
