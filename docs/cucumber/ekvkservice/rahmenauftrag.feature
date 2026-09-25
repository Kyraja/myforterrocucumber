# *****************************************************************************
#  Name           : rahmenauftrag.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Testet Funktionen rund um den Rahmenauftrag,
#                   z.B: Vorbelegungen im Kopf auf die Zeilen uebernehmen.
#
# *****************************************************************************
#
@persistent
Feature: Rahmenauftraege

Background:
Given I set the fake date to "02.01.1995"

@Testdaten
#----------------------------------------------------------------------------------------------
Scenario: Testdaten (Stammdaten) anlegen - Konsignationslagerplatz
#----------------------------------------------------------------------------------------------
# Konsilager, Konsilagergruppe anlegen
Given I open an editor "Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KONSILG"
And I set field "such" to "KONSILG"
And I set field "zkonsilg" to "Ja"
And I save the current editor

Given I open an editor "Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "KONSILAGER"
And I set field "such" to "KONSILAGER"
And I set field "lgruppe" to "KONSILG"
And I save the current editor

Given I open an editor "Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "KONSILP"
And I set field "such" to "KONSILP"
And I set field "lager" to "KONSILAGER"
And I save the current editor

# Lagergruppe mit Lagerplatz: Platz fuer Kundenanlieferung (Konsilager) eintragen
Given I open an editor "LagergruppeKA" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "KARLSRUHE"
And I set field "vkkundenanlieferung" to "KONSILP"
And I save the current editor

################################## VERKAUF ##################################

#----------------------------------------------------------------------------------------------
Scenario: Stammdaten
#----------------------------------------------------------------------------------------------
# Kunden anlegen
Given I open an editor "kunde-1" from table "(Customer):(Customer)" with command "STORE" for record "Bayram"
And I set field "such" to "Rebayram"
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

# Kunde anlegen und obigen Kunden als Rechnungsempfaenger eintragen
Given I open an editor "kunde-2" from table "(Customer):(Customer)" with command "STORE" for record "Bayram"
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
And I set field "reempf" to id from editor "kunde-1"
And I save the current editor
Then field "name" has value "Bayram Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

# Kundenkontakt 1 zum Kunde anlegen
Given I open an editor "Bayram-1" from table "(Customer):(CustomerContact)" with command "STORE" for record "Bayram-1"
And I set field "such" to "Bayram-1"
And I set field "firma" to id from editor "kunde-2"
And I set field "namebspr" to "Bayram Werkzeugbau, Baden-Baden"
And I set field "ans" to "Bayram Werkzeugbau GmbH"
And I set field "str" to "Badenerstr. 24"
And I set field "plz" to "76530"
And I set field "nort" to "Baden-Baden"
And I set field "region" to "BADEN"
And I set field "tele" to "+49 (0) 7221/2221-0"
And I set field "email" to "info@bayram-corp-baden.de"
And I set field "betreuer" to "."
And I set field "ustid" to "DE56454652"
And I save the current editor

# Kundenkontakt 2 zum Kunde anlegen
Given I open an editor "Bayram-2" from table "(Customer):(CustomerContact)" with command "STORE" for record "Bayram-2"
And I set field "such" to "Bayram-2"
And I set field "firma" to id from editor "kunde-2"
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
And I save the current editor

# Weiteren Kunden anlegen
Given I open an editor "Ayran" from table "(Customer):(Customer)" with command "STORE" for record "Ayran"
And I set field "such" to "Ayran1"
And I set field "namebspr" to "Ayran Milch GmbH, Rastatt"
And I set field "ans" to "Ayran Milch GmbH"
And I set field "str" to "Milchstr. 1"
And I set field "plz" to "76437"
And I set field "nort" to "Rastatt"
And I set field "region" to "BADEN"
And I set field "tele" to "+49 (0) 7222/1234-0"
And I set field "email" to "info@ayran-corp.de"
And I set field "betreuer" to "."
And I set field "ustid" to "DE111111111"
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I save the current editor

# Kundenkontakt 1 zum Kunde Ayran anlegen
Given I open an editor "Ayran-KK1" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
And I set field "such" to "AyranKK1"
And I set field "firma" to "Ayran1"
And I set field "namebspr" to "Ayran Milch GmbH, Karlsruhe"
And I set field "ans" to "Ayran Milch GmbH"
And I set field "str" to "Joghurtstr. 33"
And I set field "plz" to "76187"
And I set field "nort" to "Karlsruhe"
And I set field "region" to "BADEN"
And I set field "tele" to "+49 (0) 721/3333-0"
And I set field "email" to "info@ayran-corp-ka.de"
And I set field "betreuer" to "."
And I set field "ustid" to "DE7618776187"
And I save the current editor

# Neuen Artikel Rasentraktor 10 anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "traktor10ps"
And I set field "such" to "TRA10PS"
And I set field "namebspr" to "Rasentraktor 10 PS"
And I set field "vkbez" to "Rasentraktor 10 PS"
And I set field "vbez" to "Rasentraktor 10 PS"
And I set field "ebez" to "Rasentraktor 10 PS"
And I set field "vpr" to "10000"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I save the current editor
Then field "such" has value "TRA10PS"

# Neuen Artikel Rasentraktor 20 anlegen
Given I open an editor "artikel20" from table "(Part):(Product)" with command "STORE" for record "traktor20ps"
And I set field "such" to "TRA20PS"
And I set field "namebspr" to "Rasentraktor 20 PS"
And I set field "vkbez" to "Rasentraktor 20 PS"
And I set field "vbez" to "Rasentraktor 20 PS"
And I set field "ebez" to "Rasentraktor 20 PS"
And I set field "vpr" to "20000"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I save the current editor

# Rahmenauftrag mit dem Kunden und Artikel anlegen
Given I open an editor "rahmen-VK-01" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "num3" to "01RA"
And I set field "such" to "RA-VK-01"
And I set field "kunde" to id from editor "kunde-2"
And I set field "betreff" to "Testcase AU167 (Rahmenauftrag mit dem Kunden und Artikel anlegen)"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "9000" in row 1
And I save the current editor

# Rahmenauftrag mit dem Kundenkontakt und Artikel anlegen
Given I open an editor "rahmen-VK-02" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "num3" to "02"
And I set field "kunde" to "Bayram-1"
And I set field "betreff" to "Testcase AU167 (Rahmenauftrag mit dem Kunden und Artikel anlegen)"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "9000" in row 1
And I save the current editor

# Weiteren Kunden mit Kundenkontakt anlegen
Given I open an editor "KU001" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
    | such    | KU001      |
    | name    | KU001      |
    | ans     | KU001      |
    | nort    | Karlsruhe  |
    | plz     | 76133      |
And I save the current editor

Given I open an editor "KK001" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
And I set fields
    | such    | KK001      |
    | name    | KK001      |
    | ans     | KK001      |
    | nort    | Karlsruhe  |
    | plz     | 76133      |
    | firma   | KU001      |
And I save the current editor

# Weiteren Kunden mit Kundenkontakt anlegen
Given I open an editor "KU002" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
    | such    | KU002      |
    | name    | KU002      |
    | ans     | KU002      |
    | nort    | Karlsruhe  |
    | plz     | 76133      |
And I save the current editor

Given I open an editor "KK002" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
And I set fields
    | such    | KK002      |
    | name    | KK002      |
    | ans     | KK002      |
    | nort    | Karlsruhe  |
    | plz     | 76133      |
    | firma   | KU001      |
And I save the current editor

# Weiteren Artikel anlegen
Given I open an editor "TE009" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE009            |
   | namebspr | Teil009          |
   | vpr      | 20               |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
And I save the current editor

# Weiteren Artikel anlegen
Given I open an editor "TE010" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE010            |
   | namebspr | Teil010          |
   | vpr      | 50               |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
And I save the current editor

# Weiteren Artikel anlegen - mehrere Einheiten
Given I open an editor "TE011" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | TE011            |
   | bsart  | Fremdbeschaffung |
   | dispoa | auftragsbezogen  |
   | vpr    | 100              |
   | lief   | 1                |
   | epr    | 100              |
   | fvhe   | 2                |
   | vhe    | kg               |
And I save the current editor

# Weiteren Artikel anlegen
Given I open an editor "TE012" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE012            |
   | namebspr | Teil012          |
   | vpr      | 50               |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
And I save the current editor

# Fertigteil Lohnfertigung
Given I open an editor "LFERT001" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | LFERT001         |
   | namebspr | LFertTeil001     |
   | vpr      | 50               |
   | bsart    | Lohnfertigung    |
   | dispoa   | auftragsbezogen  |
And I save the current editor

Given I open an editor "TE013" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE013            |
   | namebspr | Teil013          |
   | vpr      | 10000            |
   | bsart    | Fremdbeschaffung |
   | dispoa   | bedarfsbezogen   |
And I save the current editor

Given I open an editor "TE014" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE014            |
   | namebspr | Teil014          |
   | vpr      | 9000             |
   | bsart    | Fremdbeschaffung |
   | dispoa   | bedarfsbezogen   |
And I save the current editor

Given I open an editor "TE015" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE015            |
   | namebspr | Teil015          |
   | vpr      | 150              |
   | bsart    | Fremdbeschaffung |
   | dispoa   | bedarfsbezogen   |
And I save the current editor

Given I open an editor "TE016" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE016            |
   | namebspr | Teil016          |
   | vpr      | 160              |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
And I save the current editor

# Artikel anlegen mit unterschiedlichen Einheiten: 2 kg = 1 St
Given I open an editor "TE018" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | TE018            |
   | bsart  | Fremdbeschaffung |
   | dispoa | auftragsbezogen  |
   | vpr    | 14               |
   | lief   | 1                |
   | epr    | 100              |
   | fvhle  | 2                |
   | vhe    | kg               |
   | ehe    | Paar             |
And I save the current editor

Given I open an editor "TE037" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE037            |
   | namebspr | Teil037          |
   | vpr      | 370              |
   | bsart    | Fremdbeschaffung |
   | dispoa   |                  |
And I save the current editor

# Weiteren Artikel anlegen mit verschiedenen Einheiten
Given I open an editor "TE021" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
| such     | TE021            |
| namebspr | Teil021          |
| vpr      | 50               |
| bsart    | Fremdbeschaffung |
| dispoa   | auftragsbezogen  |
| lief     | 1                |
| epr      | 30               |
| le       | Stück            |
| fvhle    | 10               |
| vhe      | kg               |
| fehle    | 2                |
| ehe      | Paar             |
And I save the current editor

# Artikel mit verschiedenen Lieferanten
Given I open an editor "TE042" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE042            |
   | namebspr | Teil042          |
   | vpr      | 42               |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | lief     | 004              |
   | epr      | 40               |
   | le       | kg               |
   | lief2    | 004              |
   | epr2     | 41               |
   | lief3    | 1                |
   | epr3     | 39               |
   | lief4    | 004              |
   | epr4     | 52               |
   | lief5    | 002              |
   | epr5     | 62               |
And I save the current editor

Given I open an editor "TE043" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE043           |
   | namebspr | Teil043         |
   | vpr      | 43              |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
And I save the current editor

Given I open an editor "TE044" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE044            |
   | namebspr | Teil044          |
   | vpr      | 44               |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
And I save the current editor

# Artikel mit VK-Preisstaffel
Given I open an editor "TE045" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | nummer   | 045TE            |
   | such     | TE045            |
   | namebspr | Teil045          |
   | vpr      | 45               |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
And I save the current editor

Given I open an editor "EK-RAB-GR1" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
  | such   | PR-TE045           |
  | typ    | Verkauf Preisliste |
  | klpg   | 4                  |
  | artpg  | 045TE              |
And I delete all rows
And I append rows
  | mgrenze | mpreis |
  | 100     | 35     |
And I save the current editor

Given I open an editor "TE046" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE046            |
   | namebspr | Teil046          |
   | vpr      | 46               |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag mit Kundenkontakt anlegen, Kunden/-kontakt wechseln
#----------------------------------------------------------------------------------------------
# Auftrag zum Kundenkontakt erstellen
Given I open an editor "AU-KK1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "Bayram-1"
And I set field "betreff" to "Testcase - Auftrag mit Kundenkontakt anlegen"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1" in row 1
Then field "zrahmen" has value "02" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-02" in row 1
Then field "preis" has value "9000.00" in row 1
# Anderen Kundenkontakt, mit gleichem Hauptkunden, eintragen
And I set field "kunde" to "Bayram-2"
And I set field "such" to "AU-KK1"
Then field "zrahmen" has value "02" in row 1
Then field "zrahmen" is modifiable in row 1
Then field "origrahmen" has value "nein" in row 1
And I save the current editor

# Nicht zum RA passenden Kundenkontakt wechseln - RA wird entfernt
Given I open an editor "AU-KK1" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU-KK1"
And I set field "kunde" to "AyranKK1"
Then field "zrahmen" has value "" in row 1
And I close the current editor

# Zum RA 02 Passenden Kundenkontakt eintragen -> RA wird wieder eingetragen
Given I open an editor "AU-KK2" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU-KK1"
And I set field "kunde" to "Bayram-1"
Then field "zrahmen" has value "02" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag mit Kunde anlegen
#----------------------------------------------------------------------------------------------
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde-2"
And I set field "betreff" to "Testcase AU167 (Auftrag mit Kunde anlegen)"
And I set field "such" to "AU-KU1"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1" in row 1
Then field "zrahmen" is modifiable in row 1
Then field "zrahmen" has value "01RA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-01" in row 1
Then field "preis" has value "9000.00" in row 1
When I set field "zrahmen" to "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I press button "rabdr"
Then field "zrahmen" has value "01RA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-01" in row 1
Then field "preis" has value "9000.00" in row 1
Then field "zrahmen" is modifiable in row 1
Then field "origrahmen" has value "nein" in row 1
Then field "orig" is empty in row 1
And I save the current editor

# Anderen Kunden eintragen - RA wird entfernt
Given I open an editor "AU-KU1" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU-KU1"
And I set field "kunde" to "Ayran1"
Then field "zrahmen" has value "" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag aus Rahmenauftrag freigeben: Feld rahmen pruefen
#----------------------------------------------------------------------------------------------
# Auftrag aus Rahmenauftrag 01
Given I open an editor "AU-ZU-RA01" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "01RA"
And I set fields
   | nummer  | 01AU    |
   | such    | AU-RA01 |
Then field "rahmen" has value "01RA"
And I set field "mge" to "1" in row 1
Then field "zrahmen" has value "01RA" in row 1
Then field "zrahmen" is not modifiable in row 1
Then field "origrahmen" has value "ja" in row 1
# Kundenkontakt eintragen -> RA bleibt
And I set field "kunde" to "Bayram-1"
Then field "rahmen" has value "01RA"
Then field "zrahmen" has value "01RA" in row 1
Then field "zrahmen" is not modifiable in row 1
Then field "origrahmen" has value "ja" in row 1
# Anderen Kunden eintragen
And I set field "kunde" to "Ayran1"
Then field "zrahmen" has value "" in row 1
# @ToDo mibr: checken warum nachfolgende Zeile nicht geht
# Then field "zrahmen" is modifiable in row 1
Then field "origrahmen" has value "nein" in row 1
Then field "orig" is empty in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Aus Rahmenauftrag einen Auftrag erstellen
#----------------------------------------------------------------------------------------------
# Rahmenauftrag 03RA anlegen
Given I open an editor "rahmen-VK-03" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 03RA     |
   | kunde   | 1        |
   | such    | RA-VK-03 |
   | betreff | RAVK03   |
And I append rows
   | artikel | he    | mge  | preis |
   | TRA10PS | Stück | 1000 | 90    |
   | TRA10PS | Stück | 2000 | 80    |
   | TRA20PS | Stück | 1000 | 100   |
   | TRA20PS | Stück | 2000 | 95    |
And I save the current editor

# Feld "fzahlgeliefert" darf nicht geaendert werden
Given I open an editor "rahmen-VK-03" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA-VK-03"
Then setting field "fzahlgeliefert" to "999" throws the exception "1283"
And I close the current editor

# Auftrag aus Rahmenauftrag 03RA
Given I open an editor "AU-ZU-RA03" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-03"
And I set fields
   | nummer  | 03AU    |
   | such    | AU-RA03 |
Then field "rahmen" has value "03RA"
And I set field "mge" to "30" in row 1
Then field "zrahmen" has value "03RA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-03" in row 1
Then setting field "fzahlgeliefert" to "999" throws the exception "1283"
Then field "zrahmen" has value "03RA" in row 2
# Kundenkontakt eintragen -> RA bleibt
And I set field "kunde" to "2"
Then field "rahmen" has value "03RA"
Then field "zrahmen" has value "03RA" in row 1
Then field "zrahmen" has value "03RA" in row 2
And I save the current editor

# Anderen Kunden eintragen -> RA wird aus Kopf und Position entfernt
Given I open an editor "AU03" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "03AU"
And I set field "kunde" to "5"
Then field "rahmen" has value ""
Then field "zrahmen" has value "" in row 1
Then field "zrahmen" has value "" in row 2
Then field "fzahlabrufoffenicon" has value "" in row 2
And I close the current editor


#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag Neu: Rahmenauftrag in "Beleg anfuegen" angeben
#----------------------------------------------------------------------------------------------
Given I open an editor "AU04-ZU-RA03" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 04AU    |
   | beleg   | 03RA    |
   | such    | AU-RA04 |
And I set field "mge" to "40" in row 1
Then field "zrahmen" has value "03RA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-03" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Nicht passenden Rahmenauftrag ueber "Beleg anfuegen" (bei vorhandenem Vorgang)
#----------------------------------------------------------------------------------------------
Given I open an editor "AU-RA04" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU-RA04"
Then the table has 1 rows
And I set field "beleg" to "01RA"
Then the table has 1 rows
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag Neu
#----------------------------------------------------------------------------------------------
Given I open an editor "AU-ZU-RA03" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 05AU    |
   | kunde  | 1       |
   | such   | AU-RA03 |
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "10" in row 1
And I set field "zrahmen" to "03RA" in row 1
Then field "zrahmen" has value "03RA" in row 1
Then field "zrahmenpos" has value "*" in row 1
Then field "preis" has value "90.00" in row 1
Then field "fzahlabrufoffenicon" has value "icon:ball_green" in row 1
Then setting field "fzahlgeliefert" to "999" throws the exception "1283"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag aus Angebot
#----------------------------------------------------------------------------------------------
Given I open an editor "ANG-ZU-RA03" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
   | nummer  | 03ANG    |
   | kunde   | 1        |
   | such    | ANG-RA03 |
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "15" in row 1
And I set field "zrahmen" to "03RA" in row 1
Then field "zrahmenpos" has value "*" in row 1
Then field "preis" has value "90.00" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag aus Angebot
#----------------------------------------------------------------------------------------------
# Angebot in Auftrag ueberfuehren
Given I open an editor "AU06-RA03" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 06AU      |
   | beleg   | 03ANG     |
   | such    | AU06-RA03 |
Then field "zrahmen" has value "03RA" in row 1
Then field "zrahmenpos" has value "*" in row 1
Then field "preis" has value "90.00" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Angebot kopieren
#----------------------------------------------------------------------------------------------
Given I open an editor "ANG-RA04_KOPIE" from table "(Sales):(Quotation)" with command "COPY" for record from editor "ANG-ZU-RA03"
And I set field "such" to "ANG-RA04K"
And I set field "vom" to "."
Then field "zrahmen" has value "03RA" in row 1
Then field "zrahmenpos" has value "*" in row 1
Then field "preis" has value "90.00" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag kopieren
#----------------------------------------------------------------------------------------------
Given I open an editor "AU-RA06-KOPIE" from table "(Sales):(SalesOrder)" with command "COPY" for record from editor "AU-ZU-RA03"
And I set fields
   | nummer  | 07AU    |
   | such    | AU06K   |
   | vom     | .       |
Then field "zrahmen" has value "03RA" in row 1
Then field "zrahmenpos" has value "*" in row 1
Then field "preis" has value "90.00" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Lieferschein kopieren, stornieren
#----------------------------------------------------------------------------------------------
Given I open an editor "LS-ZU-RA03" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "03AU"
And I set fields
   | such    | LS-RA03 |
   | ueb     | ja      |
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "03RA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-03" in row 1
Then setting field "fzahlgeliefert" to "999" throws the exception "1283"
And I save the current editor

# Pruefen fzahl und fzahlgeliefert im Rahmen und LS
Then field "fzahl" from editor "rahmen-VK-03" in row 1 has value "5"
Then field "fzahlgeliefert" from editor "rahmen-VK-03" in row 1 has value "5"
Then field "fzahlabgerufen" from editor "rahmen-VK-03" in row 1 has value "105"
Then field "fzahlabrufoffen" from editor "rahmen-VK-03" in row 1 has value "895"

Then field "fzahl" from editor "LS-ZU-RA03" in row 1 has value "5"
Then field "fzahlgeliefert" from editor "LS-ZU-RA03" in row 1 has value "5"

# LS kopieren
Given I open an editor "LS-RA03-KOPIE" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "LS-ZU-RA03"
And I set fields
   | such    | LS-RA03K |
   | vom     | .        |
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos" has value "" in row 1
And I save the current editor

# Lieferschein erstellen -> stornieren
Given I open an editor "LS-ZU-RA03B" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "03AU"
And I set fields
   | such    | LS-RA03B |
   | ueb     | ja       |
And I set field "mge" to "7" in row 1
Then field "zrahmen" has value "03RA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-03" in row 1
And I save the current editor

# Pruefen fzahl und fzahlgeliefert
Then field "fzahl" from editor "rahmen-VK-03" in row 1 has value "12"
Then field "fzahlgeliefert" from editor "rahmen-VK-03" in row 1 has value "12"
Then field "fzahlabgerufen" from editor "rahmen-VK-03" in row 1 has value "105"
Then field "fzahlabrufoffen" from editor "rahmen-VK-03" in row 1 has value "895"

# LS stornieren und Fortschrittszahlen pruefen
Given I open an editor "SLS-ZU-RA03B" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS-ZU-RA03B"
And I save the current editor
Then field "fzahl" from editor "rahmen-VK-03" in row 1 has value "5"
Then field "fzahlgeliefert" from editor "rahmen-VK-03" in row 1 has value "5"
Then field "fzahlabgerufen" from editor "rahmen-VK-03" in row 1 has value "105"
Then field "fzahlabrufoffen" from editor "rahmen-VK-03" in row 1 has value "895"

#----------------------------------------------------------------------------------------------
Scenario: VK - Rechnung und Rechnung mit LB: kopieren und stornieren, RA kopieren
#----------------------------------------------------------------------------------------------
Given I open an editor "RE-ZU-RA03" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS-ZU-RA03"
And I set fields
   | such    | RE-RA03 |
   | ueb     | ja      |
   | tterm   | .       |
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "03RA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-03" in row 1
Then setting field "fzahlgeliefert" to "999" throws the exception "1283"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE-RA03-KOPIE" from table "(Sales):(Invoice)" with command "COPY" for record from editor "RE-ZU-RA03"
And I set fields
   | such  | RE-RA03K |
   | tterm | .        |
   | vom   | .        |
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos" has value "" in row 1
And I save the current editor

# Rechnung mit LB
Given I open an editor "RE-ZU-RA03LB" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "03AU"
And I set fields
   | such  | RE-RA03LB |
   | ueb   | ja        |
   | tterm | .         |
   | budat | .         |
And I set field "mge" to "6" in row 1
Then field "zrahmen" has value "03RA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-03" in row 1
Then setting field "fzahlgeliefert" to "999" throws the exception "1283"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Fortschrittszahlen im RA ueberpruefen
Then field "fzahl" from editor "rahmen-VK-03" in row 1 has value "11"
Then field "fzahlgeliefert" from editor "rahmen-VK-03" in row 1 has value "11"

Given I open an editor "RE-RA03LB-KOPIE" from table "(Sales):(Invoice)" with command "COPY" for record from editor "RE-ZU-RA03LB"
And I set fields
   | such  | RE-RA3LBK |
   | tterm | .         |
   | vom   | .         |
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos" has value "" in row 1
And I save the current editor

# RE stornieren und Fortschrittszahlen pruefen
Given I open an editor "SRE-ZU-RA03LB" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE-ZU-RA03LB"
And I save the current editor
Then field "fzahl" from editor "rahmen-VK-03" in row 1 has value "5"
Then field "fzahlgeliefert" from editor "rahmen-VK-03" in row 1 has value "5"

# Initialisierung der Felder beim Kopieren eines RA
Given I open an editor "RA03-Kopie" from table "(Sales):(BlanketOrder)" with command "COPY" for record from editor "rahmen-VK-03"
Then field "fzahl" from editor "RA03-Kopie" in row 1 has value "0"
Then field "maxabrufmge" from editor "RA03-Kopie" in row 1 has value "0"
Then field "fzahlgeliefert" from editor "RA03-Kopie" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "RA03-Kopie" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "RA03-Kopie" in row 1 has value "1000"
Then field "zgltvon" from editor "RA03-Kopie" in row 1 has value ""
Then field "zgltbis" from editor "RA03-Kopie" in row 1 has value ""
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Setzen und Ruecksetzen von (ev)zrahmenpos
#----------------------------------------------------------------------------------------------
Given I open an editor "1RA009-VK" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | nummer | 1RA009 |
And I append rows
   | artikel | mge   | preis |
   | TE015   | 1500  | 150   |
   | TE016   | 1600  | 160   |
And I save the current editor

Given I open an editor "2RA009-VK" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | nummer | 2RA009 |
And I append rows
   | artikel | mge   | preis |
   | TE015   | 1500  | 151   |
And I save the current editor

Given I open an editor "3RA009-VK" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 001    |
   | nummer | 3RA009 |
And I append rows
   | artikel | mge  | preis | savings |
   | TE015   | 1500 | 152   | true    |
And I save the current editor

Given I open an editor "1AU009" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | nummer | 1AU009 |
And I append rows
   | artikel | mge  |
   | TE015   | 150  |
Then field "zrahmen" has value "2RA009" in row 1
Then field "preis" has value "151.00" in row 1
And I set field "artikel" to "TE016" in row 1
Then field "zrahmen" has value "1RA009" in row 1
Then field "zrahmenpos" has value "*" in row 1
Then field "preis" has value "160.00" in row 1
Then setting field "zrahmen" to "2RA009" in row 1 throws the exception "2438"
And I close the current editor

Given I open an editor "1AU009" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record from editor "2RA009-VK"
And I set fields
   | kunde  | 1      |
   | nummer | 1AU009 |
Then field "rahmen" has value "2RA009"
And I set field "mge" to "150" in row 1
And I set field "zignrahmen" to "true" in row 1
Then field "zrahmen" is empty in row 1
Then field "zrahmenpos" is empty in row 1
And I set field "fixpwert" to "false" in row 1
Then field "zrahmen" is empty in row 1
Then field "zrahmenpos" is empty in row 1
And I set field "fixpwert" to "true" in row 1
And I set field "zignrahmen" to "false" in row 1
# Wegen (ev)fixpwert = true keine Uebernahme des Rahmenauftrags aus dem Kopffeld (ev)rahmen
Then field "zrahmen" is empty in row 1
Then field "zrahmenpos" is empty in row 1
And I set field "fixpwert" to "false" in row 1
Then field "zrahmen" has value "2RA009" in row 1
And I close the current editor

Given I open an editor "1AU009" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | nummer | 1AU009 |
And I set field "beleg" to "2RA009"
Then field "rahmen" is empty
And I set field "mge" to "150" in row 1
And I set field "zignrahmen" to "true" in row 1
Then field "zrahmen" is empty in row 1
Then field "zrahmenpos" is empty in row 1
And I set field "zignrahmen" to "false" in row 1
Then field "zrahmen" is empty in row 1
Then field "zrahmenpos" is empty in row 1
And I set field "fixpwert" to "false" in row 1
Then field "zrahmen" has value "2RA009" in row 1
And I close the current editor

Given I open an editor "1AU009" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | nummer | 1AU009 |
And I append rows
   | artikel | mge  |
   | TE015   | 150  |
Then field "zrahmen" has value "2RA009" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "2RA009-VK" in row 0
And I set field "ignrahmen" to "true"
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I set field "ignrahmen" to "false"
Then field "zrahmen" has value "2RA009" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "2RA009-VK" in row 0
And I set field "kunde" to "001"
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I set field "rahmen" to "3RA009"
Then field "zrahmen" has value "3RA009" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "3RA009-VK" in row 0
And I set field "zignrahmen" to "true" in row 1
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I set field "kunde" to "1"
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I set field "zignrahmen" to "false" in row 1
Then field "zrahmen" has value "2RA009" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "2RA009-VK" in row 0
And I set field "mge" to "0" in row 1
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I set field "kunde" to "004"
And I set field "mge" to "150" in row 1
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I set field "kunde" to "1"
Then field "zrahmen" has value "2RA009" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "2RA009-VK" in row 0
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Loeschen von Rahmenauftraegen und Rahmenauftragspositionen
#----------------------------------------------------------------------------------------------
Given I open an editor "2AU009" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 001    |
   | nummer | 2AU009 |
And I append rows
   | artikel | mge  | zrahmen |
   | TE015   | 90   | 3RA009  |
And I save the current editor

Given I open an editor "2RA009-VK" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record from editor "2RA009-VK"
# Loeschen nicht erlaubt. Position wird schon verwendet.
Then deleting the row at position 1 throws the exception "10938"
And I respond with answer "JA" to the dialog with id "191"
# Stornieren nicht erlaubt. Position wird schon verwendet.
Then setting field "mge" to "0" in row 1 throws the exception "10939"
And I close the current editor

Given I open an editor "3RA009-VK" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record from editor "3RA009-VK"
And I set field "tterm" to ""
And I save the current editor

Given I open an editor "CleanUp" for tip command "(CleanUp)" and arguments ""
And I set field "obj" to "Verkauf"
And I set field "stich" to "." in row 2
And I respond with answer "Ja" to the dialog with id "2077"
And I save the current editor

Given I open an editor "2AU009" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "2AU009"
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Aendern der Fortschrittszahl: fzahl und fzahlgeliefert laufen auseinander
#----------------------------------------------------------------------------------------------
# Rahmenauftrag 11 anlegen
Given I open an editor "rahmen-VK-11" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 11       |
   | kunde   | 5        |
   | such    | RA-VK-11 |
   | betreff | RAVK11   |
And I append rows
   | artikel | he    | mge  | preis |
   | TRA10PS | Stück | 1000 | 90    |
And I save the current editor

# Auftrag aus Rahmenauftrag 11
Given I open an editor "AU-ZU-RA11" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-11"
And I set fields
   | such    | AU-RA11 |
And I set field "mge" to "100" in row 1
And I save the current editor

# Lieferschein 11 buchen
Given I open an editor "LS-ZU-RA11" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU-ZU-RA11"
And I set fields
   | such    | LS-RA11 |
   | ueb     | ja      |
And I set field "mge" to "15" in row 1
And I save the current editor

# Pruefen fzahl und fzahlgeliefert im Rahmen und LS
Then field "fzahl" from editor "rahmen-VK-11" in row 1 has value "15"
Then field "fzahlgeliefert" from editor "rahmen-VK-11" in row 1 has value "15"

Then field "fzahl" from editor "LS-ZU-RA11" in row 1 has value "15"
Then field "fzahlgeliefert" from editor "LS-ZU-RA11" in row 1 has value "15"

# Auftrag aus Rahmenauftrag 11, mge pruefen (mge - fzahlabgerufen)
Given I open an editor "AU-ZU-RA11B" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-11"
And I set fields
   | such    | AU-RA11B |
Then field "mge" has value "900" in row 1
And I close the current editor

# Im Rahmenauftrag, Fortschrittszahl manuell aendern
Given I open an editor "rahmen-VK-11" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA-VK-11"
And I set field "fzahl" to "7" in row 1
And I save the current editor

# Lieferschein 11B buchen
Given I open an editor "LS-ZU-RA11B" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU-ZU-RA11"
And I set fields
   | such    | VLS-RA11B |
   | ueb     | ja        |
And I set field "mge" to "30" in row 1
And I save the current editor

# Pruefen fzahl und fzahlgeliefert im Rahmen und LS
Then field "fzahl" from editor "rahmen-VK-11" in row 1 has value "37"
Then field "fzahlgeliefert" from editor "rahmen-VK-11" in row 1 has value "45"

Then field "fzahl" from editor "LS-ZU-RA11B" in row 1 has value "37"
Then field "fzahlgeliefert" from editor "LS-ZU-RA11B" in row 1 has value "45"

# RLS erzeugen
Given I open an editor "LS-VK-RLS11" from table "(Sales):(PackingSlip)" with command "RETURN" for record "VLS-RA11B"
And I set fields
   | such    | VRLSRA11B |
   | vom     | .         |
   | tterm   | .         |
   | ueb     | ja        |
And I set field "mge" to "-6" in row 1
And I save the current editor
Then field "fzahl" from editor "rahmen-VK-11" in row 1 has value "31"
Then field "fzahlgeliefert" from editor "rahmen-VK-11" in row 1 has value "39"

# RLS stornieren
Given I open an editor "SLS-VK-RLS11" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS-VK-RLS11"
And I save the current editor
Then field "fzahl" from editor "rahmen-VK-11" in row 1 has value "37"
Then field "fzahlgeliefert" from editor "rahmen-VK-11" in row 1 has value "45"


#----------------------------------------------------------------------------------------------
Scenario: VK - Kundenanlieferung neu und stornieren
#----------------------------------------------------------------------------------------------
Given I open an editor "KANL-AU1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1       |
   | such  | KANLAU1 |
   | vom   | .       |
And I append rows
   | artikel | mge | preis | platz   |
   | TRA10PS | -2  | 6     | KONSILP |
And I save the current editor

Then field "fzahl" from editor "rahmen-VK-11" in row 1 has value "37"
Then field "fzahlgeliefert" from editor "rahmen-VK-11" in row 1 has value "45"

Given I open an editor "KANL-LS1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lsart | Kundenanlieferung |
   | beleg | KANLAU1           |
   | such  | KANLLS1           |
   | ueb   | ja                |
Then field "lsart" has value "Kundenanlieferung"
Then field "kunde" has value "1"
Then the table has 1 rows
And I press button "offueb" in row 1
Then field "mge" has value "-2" in row 1
And I save the current editor
Then field "fzahl" from editor "rahmen-VK-11" in row 1 has value "37"
Then field "fzahlgeliefert" from editor "rahmen-VK-11" in row 1 has value "45"

# KANL stornieren und Fortschrittszahlen pruefen
Given I open an editor "SKANL-LS1" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "KANL-LS1"
And I save the current editor
Then field "fzahl" from editor "rahmen-VK-11" in row 1 has value "37"
Then field "fzahlgeliefert" from editor "rahmen-VK-11" in row 1 has value "45"

#----------------------------------------------------------------------------------------------
Scenario: VK - Plausibilitaetspruefung maximale Rahmenmenge (ev)maxabrufmge
#----------------------------------------------------------------------------------------------
# Rahmenauftrag 13 anlegen
Given I open an editor "rahmen-VK-13" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 13       |
   | kunde   | 1        |
   | such    | RA-VK-13 |
   | betreff | RAVK13   |
And I append rows
   | artikel | he    | mge  | preis |
   | TE010   | Stück | 120  | 50    |
Then setting field "maxabrufmge" to "110" in row 1 throws the exception "1048"
And I set field "maxabrufmge" to "0" in row 1
And I set field "maxabrufmge" to "160" in row 1
Then field "maxabrufmge" has value "160" in row 1
Then setting field "mge" to "200" in row 1 throws the exception "1048"
And I set field "maxabrufmge" to "250" in row 1
And I set field "mge" to "200" in row 1
And I save the current editor

# Auftrag aus Rahmenauftrag 13: maxabrufmge wird nicht vererbt
Given I open an editor "AU-ZU-RA13" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-13"
And I set fields
   | such    | AU-RA13 |
Then field "mge" has value "200" in row 1
And I set field "mge" to "100" in row 1
Then field "maxabrufmge" has value "0" in row 1
And I save the current editor
Then field "maxabrufmge" from editor "AU-ZU-RA13" in row 1 has value "0"

#----------------------------------------------------------------------------------------------
Scenario: VK - Pruefung der Fortschrittszahlen mit RLS und Storno
#----------------------------------------------------------------------------------------------

#  RA-VK-14 ----------------------------------------- AU-RA14
#  1000 St.                                           30 St. (1!) ---> 20 St. (2!)
#  | Aktion | fzahlgeliefert | fzahlabgerufen |       | Aktion | limge  | lifrg  |
#  | (1)    |  0 St.         | 30 St.         |       | (1)    | 30 St. |  0 St. |
#  | (2)    |  0 St.         | 20 St.         |       | (2)    | 20 St. |  0 St. |
#  | (3)    |  0 St.         | 20 St.         |       | (3)    | 20 St. | 10 St. |
#  | (4)    |  0 St.         | 20 St.         |       | (4)    | 20 St. | 20 St. |
#  | (5)    |  0 St.         | 30 St.         |       | (5)    | 20 St. | 30 St. |
#  | (6)    | 20 St.         | 30 St.         |       | (6)    |  0 St. | 10 St. |
#  | (7)    | 30 St.         | 30 St.         |       | (7)    |  0 St. |  0 St. |
#  | (8)    | 30 St.         | 25 St.         |       | (8)    |  0 St. |  0 St. |
#  | (9)    | 20 St.         | 15 St.         |       | (9)    |  0 St. |  0 St. |
#  | (10)   | 20 St.         | 10 St.         |       | (10)   |  0 St. |  0 St. |
#  | (11)   | 10 St.         | 10 St.         |       | (11)   |  0 St. |  0 St. |
#                                                       /
#                                                      /
#     ------------------------------------------------
#   /
#   \
#      -------------- LS1-RA14 (ungebucht) ------------- LS1-RA14 (gebucht)
#     \               10 St. (3!) ---> 20 St. (5!)       20 St. (6!)
#      \                                                   \
#       \                                                   \
#        \                                                     ----------- VRLSRA14 (Rueck-LS, ungebucht) -------- VRLSRA14 (gebucht)
#         \                                                                -5 St. (8!) -------> -10 St. (10!)      -10 St. (11!)
#          \
#             ------------ LS2-RA14 (ungebucht) ---------------- LS2-RA14 (gebucht) ---- 2LSRA14S (Storno)
#                          10 St. (4!)                           10 St. (7!)             -10 St. (9!)

# Rahmenauftrag 14 mit Menge 1000
Given I open an editor "rahmen-VK-14" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 14RA        |
   | kunde   | 2           |
   | such    | RA-VK-14    |
   | betreff | Test fzahl* |
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "140" in row 1
And I save the current editor

# Auftrag aus Rahmenauftrag 14 mit Menge 30
Given I open an editor "AU-ZU-RA14" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-14"
And I set fields
   | nummer  | 14AU    |
   | such    | AU-RA14 |
And I set field "mge" to "30" in row 1
And I save the current editor

Then field "fzahlabrufoffen" from editor "AU-ZU-RA14" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "AU-ZU-RA14" in row 1 has value "0"
Then field "fzahlgeliefert" from editor "rahmen-VK-14" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-VK-14" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-VK-14" in row 1 has value "970"

# Auftrag auf 20 reduzieren
Given I open an editor "AU-VK-14" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "14AU"
And I set field "mge" to "20" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-14" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-VK-14" in row 1 has value "20"
Then field "fzahlabrufoffen" from editor "rahmen-VK-14" in row 1 has value "980"

# LS 1 und LS 2 ungebucht
Given I open an editor "LS1-RA14" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "14AU"
And I set fields
   | such    | LS1-RA14 |
   | ueb     | nein     |
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "LS2-RA14" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "14AU"
And I set fields
   | such    | LS2-RA14 |
   | ueb     | nein     |
And I set field "mge" to "10" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-VK-14" in row 1 has value "20"
Then field "fzahlabrufoffen" from editor "rahmen-VK-14" in row 1 has value "980"

# LS 1 Menge erhoehen 10 -> 20
Given I open an editor "LS1-RA14" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS1-RA14"
And I set field "mge" to "20" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-VK-14" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-VK-14" in row 1 has value "970"

# LS 1 buchen (Menge 20) (6!)
Given I open an editor "LS1-RA14" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS1-RA14"
And I set fields
   | ueb     | ja     |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-14" in row 1 has value "20"
Then field "fzahlabgerufen" from editor "rahmen-VK-14" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-VK-14" in row 1 has value "970"

# LS 2 buchen (Menge 10) (7!)
Given I open an editor "LS2-RA14" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS2-RA14"
And I set fields
   | ueb     | ja     |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-14" in row 1 has value "30"
Then field "fzahlabgerufen" from editor "rahmen-VK-14" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-VK-14" in row 1 has value "970"

# RLS 1 ungebucht Menge -5 (8!)
Given I open an editor "RLS1-RA14" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS1-RA14"
And I set fields
   | such    | VRLSRA14  |
   | vom     | .         |
   | tterm   | .         |
And I set field "mge" to "-5" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-14" in row 1 has value "30"
Then field "fzahlabgerufen" from editor "rahmen-VK-14" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-VK-14" in row 1 has value "975"

# LS 2 storno Menge 10 (9!)
Given I open an editor "SLS2-RA14" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS2-RA14"
And I set fields
   | nummer | 2LSRA14S |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-14" in row 1 has value "20"
Then field "fzahlabgerufen" from editor "rahmen-VK-14" in row 1 has value "15"
Then field "fzahlabrufoffen" from editor "rahmen-VK-14" in row 1 has value "985"

# RLS 1 ungebucht Menge erhoehen -5 -> -10 (10!)
Given I open an editor "RLS1-RA14" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS1-RA14"
And I set field "mge" to "-10" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-14" in row 1 has value "20"
Then field "fzahlabgerufen" from editor "rahmen-VK-14" in row 1 has value "10"
Then field "fzahlabrufoffen" from editor "rahmen-VK-14" in row 1 has value "990"

# RLS 1 buchen (11!)
Given I open an editor "RLS1-RA14" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS1-RA14"
And I set fields
   | ueb     | ja        |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-14" in row 1 has value "10"
Then field "fzahlabgerufen" from editor "rahmen-VK-14" in row 1 has value "10"
Then field "fzahlabrufoffen" from editor "rahmen-VK-14" in row 1 has value "990"

#----------------------------------------------------------------------------------------------
Scenario: VK - Pruefung der Fortschrittszahlen mit Mengenaenderung, Ueberbelieferung, Buchung
#----------------------------------------------------------------------------------------------

#  RA-VK-15 ----------------------------------------- AU-RA15
#  1000 St.                                           30 St. (1!)
#  | Aktion | fzahlabgerufen | fzahlgeliefert |       | Aktion | limge  | lifrg  |
#  | (1)    | 30 St.         |  0 St.         |       | (1)    | 30 St. |  0 St. |
#  | (2)    | 30 St.         |  0 St.         |       | (2)    | 30 St. | 20 St. |
#  | (3)    | 40 St.         |  0 St.         |       | (3)    | 30 St. | 40 St. |
#  | (4)    | 30 St.         |  0 St.         |       | (4)    | 30 St. | 30 St. |
#  | (5)    | 40 St.         |  0 St.         |       | (5)    | 30 St. | 40 St. |
#  | (6)    | 30 St.         |  0 St.         |       | (6)    | 30 St. | 20 St. |
#  | (7)    | 50 St.         |  0 St.         |       | (7)    | 30 St. | 50 St. |
#  | (8)    | 80 St.         | 40 St.         |       | (8)    |  0 St. | 40 St. |
#  | (9)    | 50 St.         | 40 St.         |       | (9)    |  0 St. | 10 St. |
#  | (10)   | 50 St.         | 50 St.         |       | (10)   |  0 St. |  0 St. |
#                                                       /
#                                                      /
#     ------------------------------------------------
#   /
#   \
#      -------------- LS1-RA15 (ungebucht) ----------------------------------------------------------------LS1-RA15 (gebucht)
#     \               20 St. (2!) -----> 10 St. (4!) ------------------> 40 St. (7!) -----> 10 St. (9!)    10 St. (10!)
#      \
#       \
#         ----------------- LS2-RA15 (ungebucht) ------------------------------- LS2-RA15 (gebucht)
#                           20 St. (3!) -----> 30 St. (5!) -----> 10 St. (6!)    40 St. (8!)

# Rahmenauftrag 15 mit Menge 1000
Given I open an editor "rahmen-VK-15" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 15RA        |
   | kunde   | 2           |
   | such    | RA-VK-15    |
   | betreff | Test fzahl* |
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "150" in row 1
And I save the current editor

# Auftrag aus Rahmenauftrag 15 mit Menge 30
Given I open an editor "AU-RA15" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-15"
And I set fields
   | nummer  | 15AU    |
   | such    | AU-RA15 |
And I set field "mge" to "30" in row 1
And I save the current editor

Then field "fzahlabrufoffen" from editor "AU-RA15" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "AU-RA15" in row 1 has value "0"
Then field "fzahlgeliefert" from editor "rahmen-VK-15" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-VK-15" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-VK-15" in row 1 has value "970"

# LS 1 und LS 2 ungebucht
Given I open an editor "LS1-RA15" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "15AU"
And I set fields
   | such    | LS1-RA15 |
   | ueb     | nein     |
And I set field "mge" to "20" in row 1
And I save the current editor

Given I open an editor "LS2-RA15" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "15AU"
And I set fields
   | such    | LS2-RA15 |
   | ueb     | nein     |
And I set field "mge" to "20" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-VK-15" in row 1 has value "40"
Then field "fzahlabrufoffen" from editor "rahmen-VK-15" in row 1 has value "960"

# LS 1 Mengen aendern 20 -> 10 (4!) -> 40 (7!) -> 10 (9!)
# LS 2 Mengen aendern 20 -> 30 (5!) -> 10 (6!) -> 40 (8!)

# (4!)
Given I open an editor "LS1-RA15" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS1-RA15"
And I set field "mge" to "10" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-VK-15" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-VK-15" in row 1 has value "970"

# (5!)
Given I open an editor "LS2-RA15" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS2-RA15"
And I set field "mge" to "30" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-VK-15" in row 1 has value "40"
Then field "fzahlabrufoffen" from editor "rahmen-VK-15" in row 1 has value "960"

# (6!)
Given I open an editor "LS2-RA15" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS2-RA15"
And I set field "mge" to "10" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-VK-15" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-VK-15" in row 1 has value "970"

# (7!)
Given I open an editor "LS1-RA15" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS1-RA15"
And I set field "mge" to "40" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-VK-15" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-VK-15" in row 1 has value "950"

# (8!)
Given I open an editor "LS2-RA15" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS2-RA15"
And I set fields
   | ueb     | ja     |
And I set field "mge" to "40" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-15" in row 1 has value "40"
Then field "fzahlabgerufen" from editor "rahmen-VK-15" in row 1 has value "80"
Then field "fzahlabrufoffen" from editor "rahmen-VK-15" in row 1 has value "920"

# (9!)
Given I open an editor "LS1-RA15" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS1-RA15"
And I set field "mge" to "10" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-15" in row 1 has value "40"
Then field "fzahlabgerufen" from editor "rahmen-VK-15" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-VK-15" in row 1 has value "950"

# LS 1 buchen (Menge 10) (10!)
Given I open an editor "LS1-RA15" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS1-RA15"
And I set fields
   | ueb     | ja     |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-15" in row 1 has value "50"
Then field "fzahlabgerufen" from editor "rahmen-VK-15" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-VK-15" in row 1 has value "950"

#----------------------------------------------------------------------------------------------
Scenario: VK - Pruefung der Fortschrittszahlen mit Aenderung in AU und LS, Ueberbelieferung, Buchung, Restmengenstorno
#----------------------------------------------------------------------------------------------

#  RA-VK-16 ------------------------ AU-RA16
#  1000 St.                          30 St. (1!) ---> 100 St. (4!) ---> Restmengenstorno (6!)
#  | Aktion | fzahlabgerufen | fzahlgeliefert |      | Aktion | limge  | lifrg  |
#  | (1)    |  30 St.        |  0 St.         |      | (1)    | 30 St. |  0 St. |
#  | (2)    |  30 St.        |  0 St.         |      | (2)    | 30 St. | 30 St. |
#  | (3)    |  60 St.        | 30 St.         |      | (3)    |  0 St. | 30 St. |
#  | (4)    | 100 St.        | 30 St.         |      | (4)    | 70 St. | 30 St. |
#  | (5)    | 100 St.        | 70 St.         |      | (5)    | 30 St. |  0 St. |
#  | (6)    |  70 St.        | 70 St.         |      | (6)    |  0 St. |  0 St. |
#                                                      /
#                                                     /
#     -----------------------------------------------
#   /
#   \
#      -------------- LS1-RA16 (ungebucht) ----- LS1-RA16 (gebucht)
#     \               30 St. (2!)                40 St. (5!)
#      \
#       \
#         -------------------- LS2-RA16 (gebucht)
#                              30 St. (3!)

# Rahmenauftrag 16 mit Menge 1000
Given I open an editor "rahmen-VK-16" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 16RA        |
   | kunde   | 2           |
   | such    | RA-VK-16    |
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "160" in row 1
And I save the current editor

# Auftrag aus Rahmenauftrag 16 mit Menge 30
Given I open an editor "AU-ZU-RA16" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-16"
And I set fields
   | nummer  | 16AU    |
   | such    | AU-RA16 |
And I set field "mge" to "30" in row 1
And I save the current editor

Then field "fzahlabrufoffen" from editor "AU-ZU-RA16" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "AU-ZU-RA16" in row 1 has value "0"
Then field "fzahlgeliefert" from editor "rahmen-VK-16" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-VK-16" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-VK-16" in row 1 has value "970"

# LS 1 ungebucht (2!)
Given I open an editor "LS1-RA16" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "16AU"
And I set fields
   | such    | LS1-RA16 |
   | ueb     | nein     |
And I set field "mge" to "30" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-VK-16" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-VK-16" in row 1 has value "970"

# LS 2 gebucht (3!)
Given I open an editor "LS2-RA16" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "16AU"
And I set fields
   | such    | LS2-RA16 |
   | ueb     | ja       |
And I set field "mge" to "30" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-16" in row 1 has value "30"
Then field "fzahlabgerufen" from editor "rahmen-VK-16" in row 1 has value "60"
Then field "fzahlabrufoffen" from editor "rahmen-VK-16" in row 1 has value "940"

# Auftrag auf 100 erhoehen (4!)
Given I open an editor "AU-VK-16" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "16AU"
And I set field "mge" to "100" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-16" in row 1 has value "30"
Then field "fzahlabgerufen" from editor "rahmen-VK-16" in row 1 has value "100"
Then field "fzahlabrufoffen" from editor "rahmen-VK-16" in row 1 has value "900"

# LS 1 buchen (Menge 40) (5!)
Given I open an editor "LS1-RA16" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS1-RA16"
And I set fields
   | ueb     | ja     |
And I set field "mge" to "40" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-16" in row 1 has value "70"
Then field "fzahlabgerufen" from editor "rahmen-VK-16" in row 1 has value "100"
Then field "fzahlabrufoffen" from editor "rahmen-VK-16" in row 1 has value "900"

# Restmengenstorno Auftrag (4!)
Given I open an editor "AU-VK-16" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "16AU"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-16" in row 1 has value "70"
Then field "fzahlabgerufen" from editor "rahmen-VK-16" in row 1 has value "70"
Then field "fzahlabrufoffen" from editor "rahmen-VK-16" in row 1 has value "930"

#----------------------------------------------------------------------------------------------
Scenario: VK - Maximale Rahmenmenge wirkt sich auf die Fortschrittszahlen aus
#----------------------------------------------------------------------------------------------
# Rahmenauftrag 17 anlegen
Given I open an editor "rahmen-VK-17" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 17RA     |
   | kunde   | 1        |
   | such    | RA-VK-17 |
   | betreff | RAVK17   |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE010   | Stück | 170  | 70    | 200         |
And I save the current editor

# Auftrag aus Rahmenauftrag 17 mit Menge 180
Given I open an editor "AU-RA17" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-17"
And I set fields
   | nummer  | 17AU      |
   | such    | AU17-RA17 |
And I set field "mge" to "180" in row 1
Then field "fzahlabrufoffenicon" has value "icon:flag_red" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-17" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-VK-17" in row 1 has value "180"
Then field "fzahlabrufoffen" from editor "rahmen-VK-17" in row 1 has value "-10"

#----------------------------------------------------------------------------------------------
Scenario: VK - Fortschrittszahlen bei unterschiedlichen Einheiten in den Vorgaengen
#----------------------------------------------------------------------------------------------
# Rahmenauftrag anlegen
Given I open an editor "rahmen-VK-18" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 18RA     |
   | kunde   | 1        |
   | such    | RA-VK-18 |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE011   | Stück | 200  | 70    | 200         |
And I save the current editor

# Auftrag aus Rahmenauftrag
Given I open an editor "AU-RA18" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-18"
And I set fields
   | nummer  | 18AU    |
   | such    | AU-RA18 |
And I set field "he" to "kg" in row 1
And I set field "mge" to "100" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-18" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-VK-18" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-VK-18" in row 1 has value "150"

# Lieferschein aus Auftrag (ungebucht)
Given I open an editor "LS-RA18" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "18AU"
And I set fields
   | such    | LS-RA18 |
   | ueb     | nein    |
And I set field "he" to "Stück" in row 1
And I set field "mge" to "60" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-18" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-VK-18" in row 1 has value "60"
Then field "fzahlabrufoffen" from editor "rahmen-VK-18" in row 1 has value "140"

# Lieferschein buchen
Given I open an editor "LS-RA18" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS-RA18"
And I set fields
   | ueb     | ja     |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-18" in row 1 has value "60"
Then field "fzahlabgerufen" from editor "rahmen-VK-18" in row 1 has value "60"
Then field "fzahlabrufoffen" from editor "rahmen-VK-18" in row 1 has value "140"

# 2. Auftrag aus Rahmenauftrag
Given I open an editor "AU2-RA18" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-18"
And I set fields
   | nummer  | 18AU2    |
   | such    | AU2-RA18 |
And I set field "he" to "kg" in row 1
And I set field "mge" to "200" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-18" in row 1 has value "60"
Then field "fzahlabgerufen" from editor "rahmen-VK-18" in row 1 has value "160"
Then field "fzahlabrufoffen" from editor "rahmen-VK-18" in row 1 has value "40"

# Versuch die Einheit im 2. Auftrag aus Rahmenauftrag zu aendern
Given I open an editor "AU2-RA18" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "18AU2"
Then setting field "he" to "Stück" in row 1 throws the exception "1299"
And I set field "mge" to "100" in row 1
And I set field "he" to "Stück" in row 1
And I set field "he" to "kg" in row 1
And I set field "mge" to "200" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK -Eintrag im Feld Menge und seine Nachwirkungen - Plausi
#----------------------------------------------------------------------------------------------
# Meldung: Menge ueberschreitet die maximale Rahmenmenge.

# LS 1 ueber 201 Stueck
Given I open an editor "LS1-RA17" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AU17-RA17"
And I set fields
   | such    | LS1-RA17 |
   | ueb     | ja       |
Then setting field "mge" to "201" in row 1 throws the exception "1299"
And I set field "mge" to "190" in row 1
And I save the current editor

# Angebot anlegen
Given I open an editor "ANG17-RA17" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
   | kunde   | 1        |
   | such    | ANG17-RA |
And I append rows
   | artikel | he    |
   | TE010   | Stück |
And I set field "mge" to "150" in row 1
Then field "zrahmen" is not empty in row 1
And I set field "mge" to "151" in row 1
Then field "zrahmen" is empty in row 1
And I close the current editor

# Chance anlegen
Given I open an editor "CH17-RA17" from table "(Sales):(Opportunity)" with command "NEW" for record ""
And I set fields
   | kunde   | 1       |
   | such    | CH17-RA |
And I append rows
   | artikel | he    |
   | TE010   | Stück |
And I set field "mge" to "150" in row 1
Then field "zrahmen" is not empty in row 1
And I set field "mge" to "151" in row 1
Then field "zrahmen" is empty in row 1
And I close the current editor

# Webauftrag anlegen
Given I open an editor "WEB17-RA17" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1        |
   | such    | WEB17-RA |
And I append rows
   | artikel | he    |
   | TE010   | Stück |
And I set field "mge" to "150" in row 1
Then field "zrahmen" has value "13" in row 1
And I set field "mge" to "151" in row 1
Then field "zrahmen" is empty in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Rahmenauftragsposition in (ev)zrahmenpos eintragen
#----------------------------------------------------------------------------------------------
# Rahmenauftraege anlegen
Given I open an editor "rahmen-VK-20-1" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 20RA-1    |
   | kunde   | 1         |
   | such    | RA-VK-201 |
And I append rows
   | artikel | he    | mge  | preis |
   | TE012   | Stück | 200  | 70    |
And I save the current editor

Given I open an editor "rahmen-VK-20-2" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 20RA-2    |
   | kunde   | 1         |
   | such    | RA-VK-202 |
And I append rows
   | artikel | he    | mge  | preis |
   | TE012   | Stück | 200  | 80    |
And I save the current editor

# Auftrag mit Variationen von (ev)zrahmen und (ev)zrahmenpos
Given I open an editor "AU-RA20" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 20AU    |
   | such   | AU-RA20 |
   | kunde  | 1       |
And I append rows
   | artikel | mge |
   | TE012   | 20  |
Then field "zrahmen" has value "20RA-2" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-20-2" in row 0
And I set field "zrahmen" to "" in row 1
Then field "zrahmenpos" is empty in row 1
And I set field "zrahmen" to "20RA-1" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-20-1" in row 0
And I set field "zrahmenpos" to "" in row 1
Then field "zrahmen" is empty in row 1
And I set field "zrahmenpos" to "pos^id" from editor "rahmen-VK-20-1" in row 1
Then field "zrahmen" has value "20RA-1" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Gueltigkeitszeitraeume pruefen - Plausibilitaeten
#----------------------------------------------------------------------------------------------
# Rahmenauftrag anlegen, Vorgangsdatum leer lassen
Given I open an editor "rahmen-VK-21" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 21RA-VK  |
   | kunde   | 1        |
   | such    | RA-VK-21 |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE009   | Stück | 180  | 78    | 200         |
And I set field "zgltvon" to "+2" in row 1
Then setting field "zgltbis" to "." in row 1 throws the exception "8568"
And I save the current editor

# Vorgangsdatum setzen, von - bis: 04.01.1995 - ""
Given I open an editor "rahmen-VK-21" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "21RA-VK"
And I set fields
   | vom     | .        |
And I set field "zgltvon" to "+1" in row 1
Then setting field "zgltbis" to "." in row 1 throws the exception "8568"
And I set field "zgltbis" to "+1" in row 1
And I save the current editor

Given I open an editor "21RA-Kopie" from table "(Sales):(BlanketOrder)" with command "COPY" for record from editor "rahmen-VK-21"
Then field "fzahlabrufoffen" from editor "21RA-Kopie" in row 1 has value "180"
Then field "maxabrufmge" from editor "21RA-Kopie" in row 1 has value "0"
Then field "zgltvon" from editor "21RA-Kopie" in row 1 has value ""
Then field "zgltbis" from editor "21RA-Kopie" in row 1 has value ""
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Ist die Rahmenmenge ausgeschoepft?
#----------------------------------------------------------------------------------------------
Given I open an editor "rahmen-VK-22" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 22RA     |
   | kunde   | 004      |
   | such    | RA-VK-22 |
   | vom     | .        |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE009   | Stück | 22   | 78    | 24          |
And I save the current editor

# Auftrag 1 + Lieferung 1
Given I open an editor "AU1-RA22" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 22AU1    |
   | kunde  | 004      |
   | such   | AU1-RA22 |
And I append rows
   | artikel | mge |
   | TE009   | 20  |
And I save the current editor

# LS 1 ueber 20 Stueck
Given I open an editor "LS1-RA22" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "22AU1"
And I set fields
   | such    | LS1-RA22 |
   | ueb     | ja       |
And I set field "mge" to "20" in row 1
And I save the current editor

# Auftrag 2 + Lieferung 2
Given I open an editor "AU2-RA22" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 22AU2    |
   | kunde  | 004      |
   | such   | AU2-RA22 |
And I append rows
   | artikel | mge |
   | TE009   |  2  |
And I save the current editor

# LS 2 ueber 4 Stueck
Given I open an editor "LS2-RA22" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "22AU2"
And I set fields
   | such    | LS2-RA22 |
   | ueb     | ja       |
And I set field "mge" to "4" in row 1
And I save the current editor

# Auftrag 3, zrahmenpos eintragen -> Meldung: Rahmenauftrag ist ausgeschoepft
Given I open an editor "AU3-RA22" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 22AU3    |
   | kunde  | 004      |
   | such   | AU3-RA22 |
And I append rows
   | artikel | mge |
   | TE009   |  0  |
And I set field "mge" to "3" in row 1
Then setting field "zrahmenpos" in row 1 to "pos^id" from editor "rahmen-VK-22" in row 1 throws the exception "1909"
And I set field "zrahmenpos" to "" in row 1
And I save the current editor

# LS 3 -> zrahmen/zrahmenpos: Dieser Rahmenauftrag ist ausgeschoepft.
Given I open an editor "LS3-RA22" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "22AU3"
And I set fields
   | such    | LS3-RA22 |
   | ueb     | ja       |
And I set field "fixpwert" to "false" in row 1
And I set field "mge" to "1" in row 1
Then setting field "zrahmenpos" in row 1 to "pos^id" from editor "rahmen-VK-22" in row 1 throws the exception "1909"
And I close the current editor

# Rahmen eintragen, pruefen ob Meldung kommt
Given I open an editor "LS3-RA22" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "22AU3"
And I set fields
   | such    | LS3-RA22 |
   | ueb     | ja       |
And I set field "fixpwert" to "false" in row 1
And I set field "mge" to "1" in row 1
# Maximale Rahmenmenge ist bereits komplett abgerufen.
Then setting field "zrahmen" in row 1 to "id" from editor "rahmen-VK-22" in row 0 throws the exception "2438"
And I close the current editor

Given I open an editor "AU3-RA22" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "22AU3"
Then setting field "zrahmen" in row 1 to "id" from editor "rahmen-VK-22" in row 0 throws the exception "2438"
And I close the current editor

# Keine Ueberpruefung der maximalen Rahmenmenge bei Kundenanlieferung
Given I open an editor "KANL-RA22" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lsart  | Kundenanlieferung |
   | nummer | 22KANL            |
   | kunde  | 004               |
   | such   | KL1-RA22          |
And I append rows
   | artikel | mge |
   | TE009   | -44 |
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Abrufmenge gegen offene Rahmenauftragsmenge pruefen
#----------------------------------------------------------------------------------------------
# Rahmenauftrag anlegen
Given I open an editor "rahmen-VK-23" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 23VKRA   |
   | kunde   | 1        |
   | such    | RA-VK-23 |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE011   | Stück |  50  | 87    | 100         |
And I save the current editor

# Auftrag aus Rahmenauftrag
Given I open an editor "AU-RA23" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-23"
And I set fields
   | nummer  | 23AU    |
   | such    | AU-RA23 |
Then setting field "mge" to "105" in row 1 throws the exception "1299"
And I set field "mge" to "60" in row 1
Then field "fzahlabrufoffenicon" has value "icon:flag_red" in row 1
And I save the current editor

# Pruefen fzahl und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-23" in row 1 has value "60"
Then field "fzahlgeliefert" from editor "rahmen-VK-23" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "rahmen-VK-23" in row 1 has value "-10"

# Lieferschein 23 buchen
Given I open an editor "LS-RA23" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU-RA23"
And I set fields
   | such    | LS-RA23 |
   | ueb     | ja      |
Then setting field "mge" to "105" in row 1 throws the exception "1299"
And I set field "mge" to "25" in row 1
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-23" in row 1 has value "60"
Then field "fzahlgeliefert" from editor "rahmen-VK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-VK-23" in row 1 has value "-10"

# 2. Auftrag aus Rahmenauftrag
Given I open an editor "AU-RA23A" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-23"
And I set fields
   | nummer  | 23AUA    |
   | such    | AU-RA23A |
And I set field "mge" to "45" in row 1
Then field "fzahlabrufoffenicon" has value "icon:flash" in row 1
Then saving the current editor throws the exception "1050"
And I set field "mge" to "15" in row 1
Then field "fzahlabrufoffenicon" has value "icon:flag_red" in row 1
And I set field "beleg" to "23VKRA"
And I set field "mge" to "30" in row 2
Then saving the current editor throws the exception "1050"
And I set field "mge" to "5" in row 2
Then field "fzahlabrufoffenicon" has value "icon:flag_red" in row 2
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-23" in row 1 has value "80"
Then field "fzahlgeliefert" from editor "rahmen-VK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-VK-23" in row 1 has value "-30"

# Lieferschein 23B
Given I open an editor "LS-RA23B" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU-RA23"
And I set fields
   | such    | LS-RA23B |
And I set field "mge" to "76" in row 1
And I set field "ueb" to "ja"
# Pruefungen schlagen nur bei buchen = ja zu
Then saving the current editor throws the exception "10937"
And I set field "mge" to "20" in row 1
And I set field "beleg" to "23AU"
And I set field "mge" to "60" in row 2
Then saving the current editor throws the exception "10937"
And I set field "mge" to "5" in row 2
# Nicht buchen
And I set field "ueb" to "nein"
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-23" in row 1 has value "80"
Then field "fzahlgeliefert" from editor "rahmen-VK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-VK-23" in row 1 has value "-30"

# Lieferschein 23B aendern
Given I open an editor "LS-RA23B" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS-RA23B"
# Pruefungen schlagen im LS nur zu wenn buchen = ja
And I set field "mge" to "56" in row 2
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "10937"
And I set field "mge" to "10" in row 2
And I set field "ueb" to "nein"
And I delete row at position 2
And I set field "beleg" to "23AU"
And I set field "mge" to "60" in row 3
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "10937"
And I set field "mge" to "21" in row 3
And I set field "ueb" to "nein"
Then field "fzahlabrufoffenicon" has value "icon:flag_red" in row 3
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-23" in row 1 has value "86"
Then field "fzahlgeliefert" from editor "rahmen-VK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-VK-23" in row 1 has value "-36"

# Rechnung mit Lagerbewegung
Given I open an editor "RE-RA23" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU-RA23"
And I set fields
   | such    | RE-RA23  |
   | vom     | .        |
   | tterm   | .        |
   | fakt    | ja       |
   | ueb     | nein     |
And I set field "mge" to "4" in row 1
And I set field "beleg" to "23AU"
And I set field "mge" to "1" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung mit Lagerbewegung aendern
Given I open an editor "RE-RA23" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE-RA23"
And I set field "mge" to "80" in row 1
And I set field "ueb" to "ja"
# Pruefungen schlagen im LS nur zu wenn buchen = ja
Then saving the current editor throws the exception "10937"
And I set field "mge" to "5" in row 1
And I set field "ueb" to "nein"
And I set field "mge" to "77" in row 2
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "10937"
And I set field "mge" to "3" in row 2
And I set field "ueb" to "nein"
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-23" in row 1 has value "94"
Then field "fzahlgeliefert" from editor "rahmen-VK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-VK-23" in row 1 has value "-44"

# Rechnung mit Lagerbewegung ohne Rahmenauftrag buchen
Given I open an editor "RE-RA23" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE-RA23"
And I set field "ueb" to "ja"
And I set field "mge" to "10" in row 1
And I set field "fixpwert" to "nein" in row 1
And I set field "zrahmenpos" to "" in row 1
And I delete row at position 2
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-23" in row 1 has value "86"
Then field "fzahlgeliefert" from editor "rahmen-VK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-VK-23" in row 1 has value "-36"

# Lieferschein aus Auftrag AU-RA23A anlegen
Given I open an editor "LS-RA23A" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU-RA23A"
And I set fields
   | such    | LS-RA23A |
And I set field "mge" to "81" in row 1
And I set field "ueb" to "ja"
# Pruefungen schlagen im LS nur zu wenn buchen = ja
Then saving the current editor throws the exception "10937"
And I set field "mge" to "25" in row 1
And I set field "ueb" to "nein"
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-23" in row 1 has value "96"
Then field "fzahlgeliefert" from editor "rahmen-VK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-VK-23" in row 1 has value "-46"

#----------------------------------------------------------------------------------------------
Scenario: VK - Maximale Rahmenauftragsmenge pruefen - Plausibilitaeten
#----------------------------------------------------------------------------------------------
# Rahmenauftrag anlegen,
Given I open an editor "rahmen-VK-24" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 24VKRA   |
   | kunde   | 001      |
   | such    | RA-VK-24 |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE011   | Stück |  200  | 88    | 300         |
And I save the current editor

# Auftrag aus Rahmenauftrag
Given I open an editor "AU-RA24" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-24"
And I set fields
   | nummer  | 24AU    |
   | such    | AU-RA24 |
And I set field "mge" to "180" in row 1
Then field "fzahlabrufoffenicon" has value "icon:ball_green" in row 1
And I set field "beleg" to "24VKRA"
And I set field "mge" to "130" in row 2
Then saving the current editor throws the exception "1050"
And I set field "mge" to "100" in row 2
Then field "fzahlabrufoffenicon" has value "icon:flag_red" in row 2
And I save the current editor

# Pruefen fzahl und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-24" in row 1 has value "280"
Then field "fzahlgeliefert" from editor "rahmen-VK-24" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "rahmen-VK-24" in row 1 has value "-80"

# 1. Lieferschein aus Auftrag buchen
Given I open an editor "LS-RA24" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU-RA24"
And I set fields
   | such    | LS-RA24 |
   | ueb     | ja      |
# And I set field "mge" to "0" in row 1
And I set field "mge" to "90" in row 2
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-24" in row 1 has value "280"
Then field "fzahlgeliefert" from editor "rahmen-VK-24" in row 1 has value "90"
Then field "fzahlabrufoffen" from editor "rahmen-VK-24" in row 1 has value "-80"

# 2. Lieferschein aus Auftrag
Given I open an editor "LS-RA24A" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU-RA24"
And I set fields
   | such    | LS-RA24A |
And I set field "mge" to "211" in row 1
And I set field "ueb" to "ja"
# Pruefungen schlagen im LS nur zu wenn buchen = ja
Then saving the current editor throws the exception "10937"
And I set field "mge" to "201" in row 1
And I set field "mge" to "10" in row 2
Then saving the current editor throws the exception "10937"
And I set field "mge" to "9" in row 2
And I set field "ueb" to "nein"
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-24" in row 1 has value "301"
Then field "fzahlgeliefert" from editor "rahmen-VK-24" in row 1 has value "90"
Then field "fzahlabrufoffen" from editor "rahmen-VK-24" in row 1 has value "-101"

# Rahmenauftrag 24B1 anlegen
Given I open an editor "rahmen-VK-24B1" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 24B1VKRA  |
   | kunde   | 001       |
   | such    | RA-VK24B1 |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE011   | Stück |  200 | 90    | 200         |
And I save the current editor

# Rahmenauftrag 24B2 anlegen,
Given I open an editor "rahmen-VK-24B2" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 24B2VKRA  |
   | kunde   | 001       |
   | such    | RA-VK24B2 |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE011   | Stück |  120 | 91    | 120         |
And I save the current editor

# Auftrag aus Rahmenauftrag
Given I open an editor "AU-RA24B" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK24B1"
And I set fields
   | nummer  | 24AUB     |
   | such    | AU-RA24B  |
And I set field "mge" to "100" in row 1
And I set field "beleg" to "24B2VKRA"
Then setting field "mge" to "121" in row 3 throws the exception "1299"
And I set field "mge" to "60" in row 3
And I save the current editor

# Pruefen fzahl und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-24B1" in row 1 has value "100"
Then field "fzahlgeliefert" from editor "rahmen-VK-24B1" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "rahmen-VK-24B1" in row 1 has value "100"
Then field "fzahlabgerufen" from editor "rahmen-VK-24B2" in row 1 has value "60"
Then field "fzahlgeliefert" from editor "rahmen-VK-24B2" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "rahmen-VK-24B2" in row 1 has value "60"

# 1. Lieferschein aus Auftrag buchen
Given I open an editor "LS-RA24B" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU-RA24B"
And I set fields
   | such    | LS-RA24B |
   | ueb     | ja       |
And I set field "mge" to "50" in row 1
And I set field "mge" to "30" in row 3
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-24B1" in row 1 has value "100"
Then field "fzahlgeliefert" from editor "rahmen-VK-24B1" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-VK-24B1" in row 1 has value "100"
Then field "fzahlabgerufen" from editor "rahmen-VK-24B2" in row 1 has value "60"
Then field "fzahlgeliefert" from editor "rahmen-VK-24B2" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-VK-24B2" in row 1 has value "60"

# 2. Lieferschein aus Auftrag
Given I open an editor "LS-RA24BB" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU-RA24B"
And I set fields
   | such    | LS-RA24BB |
And I set field "fixpwert" to "nein" in row 1
And I set field "fixpwert" to "nein" in row 3
And I set field "mge" to "95" in row 3
And I set field "ueb" to "ja"
# Pruefungen schlagen im LS nur zu wenn buchen = ja
Then saving the current editor throws the exception "10937"
And I set field "mge" to "60" in row 3
And I set field "ueb" to "nein"
And I set field "mge" to "151" in row 1
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "10937"
And I set field "mge" to "80" in row 1
And I set field "ueb" to "nein"
# Pruefungen schlagen im LS nur zu wenn buchen = ja
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-24B1" in row 1 has value "130"
Then field "fzahlgeliefert" from editor "rahmen-VK-24B1" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-VK-24B1" in row 1 has value "70"
Then field "fzahlabgerufen" from editor "rahmen-VK-24B2" in row 1 has value "90"
Then field "fzahlgeliefert" from editor "rahmen-VK-24B2" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-VK-24B2" in row 1 has value "30"

# Weiteren Auftrag erstellen
Given I open an editor "AU-RA24C" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 24CAU    |
   | kunde   | 001      |
   | such    | AU-RA24C |
And I append rows
   | artikel | he    | mge  | preis |
   | TE011   | Stück |  50  | 21    |
And I set field "fixpwert" to "nein" in row 1
And I set field "zrahmenpos" to "pos^id" from editor "rahmen-VK-24B1" in row 1
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-24B1" in row 1 has value "180"
Then field "fzahlgeliefert" from editor "rahmen-VK-24B1" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-VK-24B1" in row 1 has value "20"
Then field "fzahlabgerufen" from editor "rahmen-VK-24B2" in row 1 has value "90"
Then field "fzahlgeliefert" from editor "rahmen-VK-24B2" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-VK-24B2" in row 1 has value "30"

# Auftrag aendern: Offene Menge fuer Rahmenauftrag 24B2 zu gering
Given I open an editor "AU-RA24C" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU-RA24C"
And I set field "fixpwert" to "nein" in row 1
Then setting field "zrahmenpos" in row 1 to "pos^id" from editor "rahmen-VK-24B2" in row 1 throws the exception "1299"
And I set field "mge" to "10" in row 1
And I set field "zrahmenpos" to "pos^id" from editor "rahmen-VK-24B2" in row 1
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-24B1" in row 1 has value "130"
Then field "fzahlgeliefert" from editor "rahmen-VK-24B1" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-VK-24B1" in row 1 has value "70"
Then field "fzahlabgerufen" from editor "rahmen-VK-24B2" in row 1 has value "100"
Then field "fzahlgeliefert" from editor "rahmen-VK-24B2" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-VK-24B2" in row 1 has value "20"

#----------------------------------------------------------------------------------------------
Scenario: VK - Rechnungen ohne Lagerbewegung beruecksichtigen max. Rahmenmenge nicht
#----------------------------------------------------------------------------------------------
# Rahmenauftrag anlegen
Given I open an editor "RA-VK-25" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 25VKRA   |
   | kunde   | 001      |
   | such    | RA-VK-25 |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE011   | Stück | 200  | 25    | 202         |
And I save the current editor

# AU -> LS -> Rechnung (ohne Lagerbewegung)

Given I open an editor "AU-RA25" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-25"
And I set fields
   | nummer  | 25AU     |
   | such    | AU-RA5   |
And I set field "mge" to "202" in row 1
And I save the current editor

Given I open an editor "LS-RA25" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU-RA25"
And I set fields
   | such    | LS-RA25  |
   | ueb     | ja       |
And I set field "mge" to "202" in row 1
And I save the current editor

Given I open an editor "RE-ZU-LS25" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS-RA25"
And I set fields
   | such    | RE-RA25 |
   | ueb     | ja      |
   | tterm   | .       |
And I set field "mge" to "202" in row 1
Then field "zrahmen" has value "25VKRA" in row 1
And I append rows
   | artikel | he    | mge  |
   | TE011   | Stück | 200  |
And I set field "zrahmen" to "25VKRA" in row 2
And I set field "zrahmenpos" in row 2 to "pos^id" from editor "RA-VK-25" in row 0
And I set field "mge" to "204" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Gueltigkeitsbereiche pruefen - Plausibilitaeten
#----------------------------------------------------------------------------------------------
# 1. Rahmenauftrag 26A anlegen
Given I open an editor "rahmen-VK-26A" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 26AVKRA   |
   | kunde   | 1         |
   | such    | RA-VK-26A |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge | zgltvon | zgltbis | status |
   | TE009   | Stück |  100  | 18   | 200         |         |         |        |
   | TE010   | Stück |  200  | 48   | 300         |         | +100    |        |
   | TE009   | Stück |  100  | 19   | 200         |         |         |        |
   | TE009   | Stück |  50   | 21   | 0           |         |         |        |
   | TE010   | Stück |  120  | 51   | 0           |         |         |        |
   | TE010   | Stück |  200  | 49   | 0           |         |         |        |
   | TE010   | Stück |  300  | 45   | 0           |         | +100    | S      |
Then saving the current editor throws the exception "6815"
And I set field "zgltvon" to "+101" in row 5
Then saving the current editor throws the exception "6815"
And I set field "zgltbis" to "+200" in row 5
And I set field "zgltvon" to "+201" in row 6
And I save the current editor

# 2. Rahmenauftrag 26B anlegen
Given I open an editor "rahmen-VK-26B" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 26BVKRA  |
   | kunde   | 1        |
   | such    | RA-VK26B |
And I append rows
   | artikel | he    | mge  | preis |
   | TE009   | Stück |  100  | 19   |
   | TE010   | Stück |  200  | 52   |
   | TE010   | Stück |  100  | 53   |
   | TE010   | Stück |  200  | 54   |
And I save the current editor

# 2. Rahmenauftrag 26B aendern
Given I open an editor "rahmen-VK-26B" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA-VK26B"
And I set field "zgltvon" to "+3" in row 1

And I set field "zgltbis" to "+10" in row 2
And I set field "zgltvon" to "+500" in row 4
Then saving the current editor throws the exception "6815"
And I set field "zgltvon" to "+300" in row 3
And I set field "zgltbis" to "+350" in row 3
And I save the current editor

# 3. Rahmenauftrag 26C anlegen
Given I open an editor "rahmen-VK-26C" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 26CVKRA  |
   | kunde   | 1        |
   | such    | RA-VK26C |
And I append rows
   | artikel | he    | mge  | preis | zgltvon | zgltbis |
   | TE011   | Stück |  50  | 21   |+50      | +69     |
   | TE011   | Stück |  120 | 51   |+60      | +99     |
Then saving the current editor throws the exception "6815"
And I set field "zgltvon" to "+70" in row 2
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Rahmenauftraege mit Gueltigkeitsbereich haben Vorrang
#----------------------------------------------------------------------------------------------
# 1. Rahmenauftrag 27A mit Gueltigkeit anlegen
Given I open an editor "rahmen-VK-27A" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 27AVKRA   |
   | kunde   | 1         |
   | such    | RA-VK-27A |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge | zgltvon | zgltbis |
   | TE011  | Stück |  100  | 56   | 120         |         | +200    |
And I save the current editor

# 2. Rahmenauftrag 27B anlegen
Given I open an editor "rahmen-VK-27B" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 27BVKRA  |
   | kunde   | 1        |
   | such    | RA-VK27B |
And I append rows
   | artikel | he    | mge  | preis |
   | TE011   | Stück |  100  | 63   |
And I save the current editor

# Auftrag erstellen
Given I open an editor "AU-RA27A" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 27AAU    |
   | kunde   | 1        |
   | such    | AU-RA27A |
And I append rows
   | artikel | he    | mge  |
   | TE011   | Stück |  80  |
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-27A" in row 1 has value "80"
Then field "fzahlabrufoffen" from editor "rahmen-VK-27A" in row 1 has value "20"
Then field "fzahlabgerufen" from editor "rahmen-VK-27B" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "rahmen-VK-27B" in row 1 has value "100"

# 3. Rahmenauftrag 27C mit Gueltigkeitsbereich anlegen
Given I open an editor "rahmen-VK-27C" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 27CVKRA  |
   | kunde   | 1        |
   | such    | RA-VK27C |
And I append rows
   | artikel | he    | mge  | preis | zgltvon | zgltbis |
   | TE011   | Stück | 100  | 58    | .       | +50     |
And I save the current editor

# 4. Rahmenauftrag 27D mit unpassendem Gueltigkeitsbereich anlegen
Given I open an editor "rahmen-VK-27D" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 27DVKRA  |
   | kunde   | 1        |
   | such    | RA-VK27D |
And I append rows
   | artikel | he    | mge  | preis | zgltvon | zgltbis |
   | TE011   | Stück | 200  | 66    | +200    | +350     |
And I save the current editor

# 5. Rahmenauftrag 27E ohne Gueltigkeitsbereich anlegen
Given I open an editor "rahmen-VK-27E" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 27EVKRA  |
   | kunde   | 1        |
   | such    | RA-VK27E |
And I append rows
   | artikel | he    | mge  | preis |
   | TE011   | Stück | 200  | 69    |
And I save the current editor

# Weitere Auftrag erstellen
Given I open an editor "AU-RA27B" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 27BAU    |
   | kunde   | 1        |
   | such    | AU-RA27B |
And I append rows
   | artikel | he    | mge  |
   | TE011   | Stück |  50  |
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-VK-27A" in row 1 has value "80"
Then field "fzahlabrufoffen" from editor "rahmen-VK-27A" in row 1 has value "20"
Then field "fzahlabgerufen" from editor "rahmen-VK-27B" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "rahmen-VK-27B" in row 1 has value "100"
Then field "fzahlabgerufen" from editor "rahmen-VK-27C" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-VK-27C" in row 1 has value "50"

#Fall 1
#----------------------------------------------------------------------------------------------
Scenario: VK -Rahmenauftrag mit einer Position mit Gueltigkeitsbereich anlegen
#----------------------------------------------------------------------------------------------
Given I open an editor "rahmen-VK-27F1A" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "Rebayram"
And I set field "such" to "RAVK27F1A"
And I create a new row at the end of the table
And I set field "artikel" to "TE013" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "8888" in row 1
And I set field "zgltvon" to "." in row 1
And I save the current editor

# Rahmenauftrag mit einer Positionen ohne Gueltigkeitsbereich anlegen
Given I open an editor "rahmen-VK-27F1B" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "Rebayram"
And I set field "such" to "RAVK27F1B"
And I create a new row at the end of the table
And I set field "artikel" to "TE013" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "9999" in row 1
And I save the current editor

#Auftrag anlegen
Given I open an editor "AU-RA27F1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "Rebayram"
And I set field "such" to "AU-RA27F1"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "TE013" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor
Then field "preis" has value "8888.00" in row 1

#Fall 2
#Rahmenauftrag mit einer Position mit Gueltigkeitsbereich anlegen
Given I open an editor "rahmen-VK-27F2A" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "Rebayram"
And I set field "such" to "RAVK27F2A"
And I create a new row at the end of the table
And I set field "artikel" to "TE014" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "7777" in row 1
And I set field "zgltvon" to "." in row 1
And I set field "zgltbis" to "31.12." in row 1
And I save the current editor

#Rahmenauftrag mit einer Position mit Gueltigkeitsbereich anlegen
Given I open an editor "rahmen-VK-27F2B" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "Rebayram"
And I set field "such" to "RAVK27F2B"
And I create a new row at the end of the table
And I set field "artikel" to "TE014" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "6666" in row 1
And I set field "zgltvon" to "." in row 1
And I set field "zgltbis" to "31.03." in row 1
And I save the current editor

#Auftrag anlegen
Given I open an editor "AU-RA27F2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "Rebayram"
And I set field "such" to "AU-RA27F2"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "TE014" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor
Then field "preis" has value "6666.00" in row 1

#Aendern des Stichtags fuer die Preisfindung in Bestellposition
Given I open an editor "AU-RA27F2U" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-RA27F2"
And I set field "konddat" to "15.4." in row 1
And I set field "fixpwert" to "Nein" in row 1
Then field "preis" has value "7777.00" in row 1

#----------------------------------------------------------------------------------------------
Scenario: VK - Rahmenauftrag Maxwert ueberschreiten erlauben in LS und RE mit LB
#----------------------------------------------------------------------------------------------
# Weiteren Artikel anlegen
Given I open an editor "TE029" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE029            |
   | namebspr | Teil029VK        |
   | vpr      | 12               |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
And I save the current editor

# Rahmenauftrag 29 mit max Menge 200 anlegen
Given I open an editor "RA-VK29" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 001       |
   | such    | RA-VK29   |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | !TE029  | Stück |  10  | 11    | 200         |
And I save the current editor

# Rahmenauftrag fast aufbrauchen
Given I open an editor "RE-29" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde   | 001   |
   | such    | RE-29 |
   | fakt    | ja    |
   | ueb     | ja    |
   | tterm   | .     |
   | budat   | .     |
And I append rows
   | artikel | he    | mge  |
   | !TE029  | Stück |  190 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "fzahl" from editor "RA-VK29" in row 1 has value "190"

# Auftrag anlegen - Ueberschreiten der Maxmenge fuehrt zum Leeren des Rahmenauftrags
Given I open an editor "AU-29" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 001   |
   | such    | AU-29 |
   | tterm   | .     |
   | budat   | .     |
And I append rows
   | artikel | he    | mge |
   | !TE029  | Stück |  8  |
Then field "zrahmen" is not empty in row 1
And I set field "mge" to "11" in row 1
# Menge ueberschreitet die maximale Rahmenmenge
Then field "zrahmen" is empty in row 1
And I set field "mge" to "8" in row 1
Then field "zrahmen" is not empty in row 1
And I save the current editor

# LS anlegen - Ueberschreiten der Maxmenge fuehrt zum Hinweis
Given I open an editor "LS-29" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde   | 001   |
   | such    | LS-29 |
   | tterm   | .     |
And I create a new row at the end of the table
And I set field "artikel" to "!TE029" in row 1
# Preisfindung findet einen Rahmenauftrag.
And I set field "mge" to "2" in row 1
And I save the current editor

Given I open an editor "LS-29U" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS-29"
And I set field "ueb" to "ja"
Then setting field "mge" to "20" in row 1 throws the exception "1299"
And I set field "ueb" to "nein"
And I set field "mge" to "20" in row 1
# Beim LS darf Menge ueberschritten werden, wenn nicht gebucht - auch gespeichert - lediglich Hinweis
And I save the current editor

# Ob LS gebucht oder ungebucht spielt keine Rolle: es wird immer gegen die max. Rahmenmenge geprueft
Given I open an editor "LS-29U" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS-29"
And I set fields
   | ueb     | ja    |
# Beim LS darf Menge nicht ueberschritten werden, wenn buchen = ja
# Abrufmenge zu hoch. Buchen nicht moeglich.
Then saving the current editor throws the exception "10937"
# Menge auf gueltigen Wert setzen
And I set field "mge" to "2" in row 1
And I save the current editor

# Das Gleiche mit RE + LB
# LS stornieren
Given I open an editor "LS-29STORNO" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS-29"
And I save the current editor

Then field "fzahl" from editor "RA-VK29" in row 1 has value "190"

# RE + LB anlegen - Ueberschreiten der Maxmenge fuehrt lediglich zu Hinweis, wenn buchen = nein
Given I open an editor "RE-29" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde   | 001   |
   | such    | RE-29 |
   | tterm   | .     |
   | budat   | .     |
And I create a new row at the end of the table
And I set field "artikel" to "!TE029" in row 1
# Preisfindung findet einen Rahmenauftrag.
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE-29U" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE-29"
And I set field "ueb" to "ja"
Then setting field "mge" to "20" in row 1 throws the exception "1299"
And I set field "ueb" to "nein"
And I set field "mge" to "20" in row 1
# Bei RE + LB darf Menge ueberschritten werden, wenn nicht gebucht - auch gespeichert - lediglich Hinweis
And I save the current editor

# Ob LS gebucht oder ungebucht spielt keine Rolle: es wird immer gegen die max. Rahmenmenge geprueft
# Aendern RE mit LB und buchen=ja -> Fehlermeldung
Given I open an editor "RE-29U" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE-29"
And I set fields
   | ueb     | ja    |
# Beim RE+LB darf Menge nicht ueberschritten werden, wenn buchen = ja
# Abrufmenge zu hoch
Then saving the current editor throws the exception "10937"
# Menge auf gueltigen Wert setzen
And I set field "mge" to "2" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Vorbelegung Gueltigkeit im Rahmenauftrag
#----------------------------------------------------------------------------------------------
Given I open an editor "Artikelpos" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | ARTIKELPOS       |
   | name     | Artikelposition  |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
And I save the current editor

Given I open an editor "AUBEPos" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
	| such   | AUBEPOS               |
	| name   | Zusatzposition AU/BE  |
	| zptyp  | AU/BE                 |
And I save the current editor

Given I open an editor "DLPos" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such   | DLPOS           |
	| name   | Dienstleistung  |
And I save the current editor

Given I open an editor "RA-VK30" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 001      |
   | such    | RA-VK30  |
   | gltvon  | 03.01.95 |
   | gltbis  | 03.05.95 |
And I append rows
   | artikel    | mge         | preis       |
   | ARTIKELPOS | 300         | 30          |
   | TEXT       | !dontChange | !dontChange |
   | AUBEPOS    | 300         | 30          |
   | DLPOS      | 300         | 30          |
Then table has values
   | zgltvon  | zgltbis  |
   | 03.01.95 | 03.05.95 |
   | 03.01.95 | 03.05.95 |
   | 03.01.95 | 03.05.95 |
   | 03.01.95 | 03.05.95 |
And I set field "gltvon" to "04.01.95"
And I set field "gltbis" to "04.05.95"
And I set field "artikel" to "ARTIKELPOS" in row 1
And I set field "artikel" to "TEXT" in row 2
And I set field "artikel" to "AUBEPOS" in row 3
And I set field "artikel" to "DLPOS" in row 4
Then table has values
   | zgltvon  | zgltbis  |
   | 03.01.95 | 03.05.95 |
   | 03.01.95 | 03.05.95 |
   | 03.01.95 | 03.05.95 |
   | 03.01.95 | 03.05.95 |
And I set field "zgltvon" to "" in row 1
And I set field "zgltvon" to "" in row 2
And I set field "zgltvon" to "" in row 3
And I set field "zgltvon" to "" in row 4
And I set field "artikel" to "ARTIKELPOS" in row 1
And I set field "artikel" to "TEXT" in row 2
And I set field "artikel" to "AUBEPOS" in row 3
And I set field "artikel" to "DLPOS" in row 4
Then table has values
   | zgltvon  | zgltbis  |
   |          | 03.05.95 |
   |          | 03.05.95 |
   |          | 03.05.95 |
   |          | 03.05.95 |
And I set field "zgltbis" to "" in row 1
And I set field "zgltbis" to "" in row 2
And I set field "zgltbis" to "" in row 3
And I set field "zgltbis" to "" in row 4
And I set field "artikel" to "ARTIKELPOS" in row 1
And I set field "artikel" to "TEXT" in row 2
And I set field "artikel" to "AUBEPOS" in row 3
And I set field "artikel" to "DLPOS" in row 4
Then table has values
   | zgltvon  | zgltbis  |
   | 04.01.95 | 04.05.95 |
   | 04.01.95 | 04.05.95 |
   | 04.01.95 | 04.05.95 |
   | 04.01.95 | 04.05.95 |
And I save the current editor

Given I open an editor "RA-VK30" from table "(Sales):(BlanketOrder)" with command "COPY" for record "RA-VK30"
Then field "gltvon" has value ""
Then field "gltbis" has value ""
Then table has values
   | zgltvon  | zgltbis  |
   |          |          |
   |          |          |
   |          |          |
   |          |          |
And I close the current editor

Given I set the fake date to "07.01.1995"
Given I open an editor "RA-VK30" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK30"
Then field "gltvon" has value ""
Then field "gltbis" has value ""
Then table has values
   | zgltvon  | zgltbis  |
   |          |          |
   |          |          |
   |          |          |
   |          |          |
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Maximale Rahmenauftragsmenge bei unterschiedlichen Einheiten in den Vorgaengen pruefen
#----------------------------------------------------------------------------------------------
# Rahmenauftrag anlegen
Given I open an editor "rahmen-VK-34" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num3    | 34RA     |
   | kunde   | 1        |
   | such    | RA-VK-34 |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE018   | Stück | 100  | 15    | 100         |
And I save the current editor

# Auftrag aus Rahmenauftrag
Given I open an editor "AU-RA34" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK-34"
And I set fields
   | nummer  | 34AU    |
   | such    | AU-RA34 |
And I set field "mge" to "40" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-34" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-VK-34" in row 1 has value "80"
Then field "fzahlabrufoffen" from editor "rahmen-VK-34" in row 1 has value "20"

# Lieferschein aus Auftrag (ungebucht)
Given I open an editor "LS-RA34" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "34AU"
And I set fields
   | such    | LS-RA34 |
   | ueb     | nein    |
And I set field "mge" to "45" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-34" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-VK-34" in row 1 has value "90"
Then field "fzahlabrufoffen" from editor "rahmen-VK-34" in row 1 has value "10"

# Lieferschein buchen
Given I open an editor "LS-RA34" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LS-RA34"
And I set fields
   | ueb     | ja     |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-34" in row 1 has value "90"
Then field "fzahlabgerufen" from editor "rahmen-VK-34" in row 1 has value "90"
Then field "fzahlabrufoffen" from editor "rahmen-VK-34" in row 1 has value "10"

# 2. Auftrag, Rahmenauftrag kommt aus Preisfindung
Given I open an editor "AU2-RA34" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 34AU2    |
   | kunde   | 1        |
   | such    | AU2-RA34 |
And I append rows
   | artikel | he     | mge  |
   | TE018   | kg     | 10   |
# Rahmen darf nicht gezogen werden
Then field "zrahmen" is empty in row 1
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "34RA" in row 1
And I save the current editor

Given I open an editor "AU2-RA34" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU2-RA34"
Then setting field "mge" to "10" in row 1 throws the exception "1299"
And I set field "he" to "Stück" in row 1
And I set field "mge" to "10" in row 1
And I set field "mge" to "5" in row 1
And I set field "he" to "kg" in row 1
Then setting field "lehe" to "3" in row 1 throws the exception "1299"
And I set field "lehe" to "1.1" in row 1
And I set field "mge" to "9" in row 1
Then setting field "mge" to "11" in row 1 throws the exception "1299"
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-VK-34" in row 1 has value "90"
Then field "fzahlabgerufen" from editor "rahmen-VK-34" in row 1 has value "99.9"
Then field "fzahlabrufoffen" from editor "rahmen-VK-34" in row 1 has value "0.1"

#----------------------------------------------------------------------------------------------
Scenario: VK - Nur relevante Positionen bei Rahmenauftragsfreigabe uebernehmen
#----------------------------------------------------------------------------------------------
Given I open an editor "RA-VK35" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 001      |
   | such    | RA-VK35  |
   | gltvon  | 03.01.95 |
   | gltbis  | 03.02.95 |
And I append rows
   | artikel    | mge         | preis       | maxabrufmge |
   | ARTIKELPOS | 350         | 30          | 400         |
   | TEXT       | !dontChange | !dontChange | !dontChange |
   | AUBEPOS    | 350         | 30          | 400         |
   | DLPOS      | 350         | 30          | 400         |
And I set field "zgltvon" to "" in row 2
And I set field "zgltbis" to "" in row 2
And I save the current editor

Given I set the fake date to "02.01.1995"
Given I open an editor "RA-VK35" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK35"
Then the table has 1 rows
Then table has values
   | artikel    |
   | TEXT       |
And I close the current editor

Given I set the fake date to "02.03.1995"
Given I open an editor "RA-VK35" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK35"
Then the table has 1 rows
Then table has values
   | artikel    |
   | TEXT       |
And I close the current editor

Given I set the fake date to "07.01.1995"
Given I open an editor "RA-VK35" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK35"
Then table has values
   | artikel    |
   | ARTIKELPOS |
   | TEXT       |
   | AUBEPOS    |
   | DLPOS      |
And I close the current editor

Given I open an editor "RA-VK35" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA-VK35"
And I set field "status" to "*" in row 1
And I set field "status" to "*" in row 2
And I save the current editor

Given I open an editor "RA-VK35" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK35"
Then the table has 2 rows
Then table has values
   | artikel    |
   | AUBEPOS    |
   | DLPOS      |
And I close the current editor

Given I open an editor "RA-VK35" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA-VK35"
And I set field "status" to "" in row 1
And I set field "status" to "" in row 2
And I set field "zgltvon" to "03.01.95" in row 2
And I set field "zgltbis" to "03.02.95" in row 2
And I save the current editor

Given I open an editor "RA-VK35" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK35"
And I set fields
   | such    | AU-VK35  |
And I set field "mge" to "200" in row 1
And I set field "mge" to "200" in row 3
And I set field "mge" to "200" in row 4
And I save the current editor

Given I open an editor "RA-VK35" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK35"
Then table has values
   | artikel    |
   | ARTIKELPOS |
   | TEXT       |
   | AUBEPOS    |
   | DLPOS      |
And I set fields
   | such    | AU2-VK35  |
And I set field "mge" to "200" in row 1
And I set field "mge" to "200" in row 3
And I set field "mge" to "200" in row 4
And I save the current editor

Given I open an editor "RA-VK35" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA-VK35"
Then the table has 1 rows
Then table has values
   | artikel    |
   | TEXT       |
And I close the current editor

Given I open an editor "RA-VK35" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA-VK35"
And I set field "maxabrufmge" to "500" in row 1
And I set field "maxabrufmge" to "500" in row 3
And I set field "maxabrufmge" to "500" in row 4
And I save the current editor

Given I open an editor "AU3-VK35" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 001      |
   | vom     | 03.03.95 |
And I set field "beleg" to "RA-VK35"
Then the table has 0 rows
And I set field "vom" to "03.02.95"
And I set field "beleg" to "RA-VK35"
Then table has values
   | artikel    |
   | ARTIKELPOS |
   | TEXT       |
   | AUBEPOS    |
   | DLPOS      |
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Liefertermin in Abhaengigkeit der Menge bestimmen
#----------------------------------------------------------------------------------------------
Given I open an editor "rahmen-VK-36A" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 36ARAVK   |
   | kunde   | 1         |
   | such    | RA-VK-36A |
   | vom     | .         |
And I append rows
   | artikel | he     | mge  | preis | verfuegbmge | lzeit | lfristkurz |
   | TE009   | Stück  | 300  | 67    | 50          | 5     | 1          |
And I save the current editor

Given I open an editor "rahmen-VK-36B" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 36BRAVK   |
   | kunde   | 1         |
   | such    | RA-VK-36B |
   | vom     | .         |
And I append rows
   | artikel | he     | mge  | preis | verfuegbmge | lzeit | lfristkurz |
   | TE009   | Stück  | 300  | 78    | 50          | 10    | 2          |
And I save the current editor

# Auftrag 1
Given I open an editor "AU1-RA36" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 36AU1    |
   | kunde  | 1        |
   | such   | AU1-RA36 |
And I append rows
   | artikel | mge |
   | TE009   | 50  |
And I set field "zrahmen" to "RA-VK-36B" in row 1
Then field "verfuegbmge" has value "50" in row 1
Then field "lfristkurz" has value "2" in row 1
Then field "lzeit" has value "10" in row 1
And I set field "mge" to "60" in row 1
# Menge groß         -> Lieferzeit lang
Then field "tterm" has value "17.01.95" in row 1
Then field "tsterm" has value "17.01.95" in row 1
# Menge klein        -> Lieferzeit kurz
And I set field "mge" to "40" in row 1
Then field "tterm" has value "04.01.95" in row 1
Then field "tsterm" has value "04.01.95" in row 1
# Rahmen ignorieren
And I set field "zignrahmen" to "ja" in row 1
Then field "tterm" has value "02.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
# Rahmen wieder beruecksichtigen
And I set field "zignrahmen" to "nein" in row 1
Then field "tterm" has value "04.01.95" in row 1
Then field "tsterm" has value "04.01.95" in row 1
# Anderen Rahmen eintragen
And I set field "zrahmen" to "RA-VK-36A" in row 1
Then field "tterm" has value "03.01.95" in row 1
Then field "tsterm" has value "03.01.95" in row 1
# Zurueck aendern
And I set field "zrahmen" to "RA-VK-36B" in row 1
Then field "tterm" has value "04.01.95" in row 1
Then field "tsterm" has value "04.01.95" in row 1
# Bedarfstermin spaet  -> Lieferzeit lang
And I set field "rterm" to "07.02.95" in row 1
And I set field "fix" to "nein" in row 1
And I set field "mge" to "40" in row 1
Then field "tterm" has value "17.01.95" in row 1
Then field "tsterm" has value "17.01.95" in row 1
# Bedarfstermin frueh -> Lieferzeit kurz
And I set field "rterm" to "10.01.95" in row 1
And I set field "fix" to "nein" in row 1
And I set field "mge" to "40" in row 1
Then field "tterm" has value "04.01.95" in row 1
Then field "tsterm" has value "04.01.95" in row 1
# Menge aendern
And I set field "mge" to "60" in row 1
Then field "tterm" has value "17.01.95" in row 1
And I save the current editor

# Auftrag 1 aendern
Given I open an editor "AU1-RA36A" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU1-RA36"
# Menge aendern, Liefertermin unveraendert
And I set field "mge" to "30" in row 1
Then field "tterm" has value "17.01.95" in row 1
Then field "tsterm" has value "17.01.95" in row 1
# Termin wird im Aendern nicht neu berechnet
And I set field "zignrahmen" to "ja" in row 1
Then field "tterm" has value "17.01.95" in row 1
Then field "tsterm" has value "17.01.95" in row 1
And I set field "mge" to "30" in row 1
Then field "tterm" has value "17.01.95" in row 1
Then field "tsterm" has value "17.01.95" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Rahmenauftrag und Preisfindung
#----------------------------------------------------------------------------------------------
Given I open an editor "1RA037" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1RA037 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE037   | Stück | 100  | 37    | 100         |
And I save the current editor

Given I open an editor "1AU037" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU037 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge |
   | TE037   | 90  |
And I save the current editor

Given I open an editor "2AU037" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 2AU037 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge |
   | TE037   | 5   |
And I save the current editor

Given I open an editor "1AU037" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU037"
And I set field "mge" to "85" in row 1
And I save the current editor

Given I open an editor "2AU037" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "2AU037"
And I set field "mge" to "14" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "15" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "16" in row 1
Then field "zrahmen" is empty in row 1
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I save the current editor

Given I open an editor "1LS037" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "2AU037"
And I set fields
   | nummer | 1LS037 |
   | vom    | .      |
And I set field "fixpwert" to "false" in row 1
And I set field "mge" to "14" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "15" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "16" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I save the current editor

Given I open an editor "1LS037" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "1LS037"
And I set field "mge" to "14" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "15" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "16" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "0" in row 1
And I save the current editor

Given I open an editor "2LS037" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 2LS037 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge  |
   | TE037   | 9    |
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "11" in row 1
Then field "zrahmen" is empty in row 1
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I save the current editor

Given I open an editor "2LS037" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "2LS037"
And I set field "mge" to "9" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "11" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I save the current editor

Given I open an editor "1AU037" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU037"
And I set field "mge" to "85" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "86" in row 1
Then field "zrahmen" is empty in row 1
And I close the current editor

Given I open an editor "2RA037" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 2RA037 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE037   | Stück | 100  | 37    | 100         |
   | TE037   | Stück | 100  | 73    | 100         |
And I save the current editor

Given I open an editor "3AU037" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record from editor "2RA037"
And I set fields
   | nummer | 3AU037 |
   | vom    | .      |
And I delete row at position 2
And I set field "mge" to "90" in row 1
And I save the current editor

Given I open an editor "4AU037" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record from editor "2RA037"
And I set fields
   | nummer | 4AU037 |
   | vom    | .      |
And I delete row at position 1
And I set field "mge" to "95" in row 1
And I save the current editor

Given I open an editor "5AU037" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 5AU037 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge |
   |  TE037  | 10  |
And I save the current editor

Given I open an editor "5AU037" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "5AU037"
Then field "zrahmen" has value "2RA037" in row 1
And I set field "mge" to "15" in row 1
Then field "zrahmen" is empty in row 1
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "2RA037" in row 1
And I save the current editor

Given I open an editor "6AU037" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 6AU037 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge |
   |  TE037  | 5   |
Then field "zrahmen" has value "2RA037" in row 1
And I set field "mge" to "6" in row 1
Then field "zrahmen" is empty in row 1
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "2RA037" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Rahmenauftrag, mehrere AU, offene verfuegbare Menge pruefen
#----------------------------------------------------------------------------------------------
# Rahmenauftrag 38 anlegen mit lfristkurz
Given I open an editor "RA-VK-38" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 38VKRA1   |
   | kunde   | 1         |
   | such    | RA-VK-38A |
   | vom     | .         |
And I append rows
   | artikel | he    | mge | preis | verfuegbmge | lzeit | lfristkurz |
   | TE009   | Stück | 380 | 38    | 50          | 10    | 2          |
And I save the current editor

# Auftrag aus Rahmenauftrag erzeugen, noch abrufbare Menge pruefen
Given I open an editor "AU-ZU-RA38" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "38VKRA1"
Then field "rahmen" has value "38VKRA1"
Then field "ofverfuegbmge" has value "50" in row 1
Then field "verwendlfristkurz" has value "ja" in row 1
And I close the current editor

# Auftrag 1 zu RA 38
Given I open an editor "AU38" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU38 |
   | kunde  | 1     |
   | such   | AU38  |
   | vom    | .     |
And I append rows
   | artikel | mge |
   | TE009   | 4   |
And I set field "tterm" to "+21" in row 1
Then field "ofverfuegbmge" has value "50" in row 1
And I save the current editor
# Liefertermin - lzeit liegen in der Zukunft
Then field "ofverfuegbmge" from editor "AU38" in row 1 has value "50"
Then field "ofverfuegbmge" from editor "RA-VK-38" in row 1 has value "50"

Given I open an editor "AU38" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU38"
And I set field "tterm" to "+5" in row 1
Then field "verwendlfristkurz" has value "nein" in row 1
Then field "lfristkurz" has value "2" in row 1
And I set field "zignrahmen" to "ja" in row 1
Then field "lfristkurz" has value "0" in row 1
And I set field "zignrahmen" to "nein" in row 1
Then field "lfristkurz" has value "2" in row 1
And I save the current editor
Then field "verwendlfristkurz" from editor "AU38" in row 1 has value "ja"
Then field "ofverfuegbmge" from editor "AU38" in row 1 has value "46"
Then field "ofverfuegbmge" from editor "RA-VK-38" in row 1 has value "46"

# Auftrag 2 zu RA 38
Given I open an editor "AU38B" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 2AU38 |
   | kunde  | 1     |
   | such   | AU38B |
   | vom    | .     |
And I append rows
   | artikel | mge |
   | TE009   | 11  |
Then field "ofverfuegbmge" has value "46" in row 1
And I save the current editor
Then field "ofverfuegbmge" from editor "AU38B" in row 1 has value "35"
Then field "ofverfuegbmge" from editor "RA-VK-38" in row 1 has value "35"

Given I open an editor "AU38B" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU38B"
Then field "ofverfuegbmge" has value "35" in row 1
And I set field "mge" to "10" in row 1
Then field "ofverfuegbmge" has value "35" in row 1
And I save the current editor
Then field "ofverfuegbmge" from editor "AU38B" in row 1 has value "36"
Then field "ofverfuegbmge" from editor "RA-VK-38" in row 1 has value "36"

#----------------------------------------------------------------------------------------------
Scenario: VK - Rahmenauftrag, mehrere LS offen, manche mit Status Stern, LS altern
# LS altern und so aendert sich ofverfuegbmge (Werden wieder verfuegbar). Wochenende, Feiertage werden beruecksichtigt
#----------------------------------------------------------------------------------------------
# Weiteren Artikel anlegen
Given I open an editor "TE019" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TE019            |
   | namebspr | Teil019          |
   | vpr      | 50               |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
And I save the current editor

# Rahmenauftrag 039 anlegen mit lfristkurz
Given I open an editor "RA039" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1     |
   | such    | RA039 |
   | vom     | .     |
And I append rows
   | artikel | he    | mge | preis | verfuegbmge | lzeit | lfristkurz |
   | !TE019  | Stück | 100 | 38    | 50          | 10    | 2          |
And I save the current editor

Given I open an editor "AU039" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | such   | AU039 |
   | vom    | .     |
And I append rows
   | artikel | mge | zrahmen |
   | !TE019  | 4   | !RA039  |
   | !TE019  | 3   | !RA039  |
And I save the current editor
# Liefertermin - lzeit liegt in der Zukunft
Then field "lfristkurz" from editor "AU039" in row 1 has value "2"
Then field "lfristkurz" from editor "AU039" in row 2 has value "2"
Then field "ofverfuegbmge" from editor "AU039" in row 1 has value "43"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "43"

Given I open an editor "AU039" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU039"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
Then field "ofverfuegbmge" has value "43" in row 1
And I save the current editor
Then field "ofverfuegbmge" from editor "AU039" in row 1 has value "47"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "47"

# Auftrag 2 zu RA039
Given I open an editor "AU039B" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU039B |
   | vom    | .      |
And I append rows
   | artikel | mge | zrahmen |
   | !TE019  | 47  | !RA039  |
And I save the current editor
Then field "lfristkurz" from editor "AU039B" in row 1 has value "2"
Then field "ofverfuegbmge" from editor "AU039B" in row 1 has value "0"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "0"

Given I open an editor "AU039B" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU039B"
And I set field "mge" to "46" in row 1
Then field "lzeit" from editor "AU039B" in row 1 has value "10"
Then field "lfristkurz" from editor "AU039B" in row 1 has value "2"
And I set field "zignrahmen" to "ja" in row 1
Then field "lzeit" from editor "AU039B" in row 1 has value "0"
Then field "lfristkurz" from editor "AU039B" in row 1 has value "0"
Then field "lzeit" from editor "AU039B" in row 1 has value "0"
And I set field "zignrahmen" to "nein" in row 1
And I save the current editor
Then field "lzeit" from editor "AU039B" in row 1 has value "10"
Then field "lfristkurz" from editor "AU039B" in row 1 has value "2"
Then field "ofverfuegbmge" from editor "AU039B" in row 1 has value "1"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "1"

Given I open an editor "AU039B" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU039B"
And I set field "mge" to "47" in row 1
And I append rows
   | artikel | mge | zrahmen |
   | !TE019  | 1   | !RA039  |
Then saving the current editor throws the exception "6818"
And I set field "verwendlfristkurz" to "nein" in row 2
And I save the current editor
Then field "lfristkurz" from editor "AU039B" in row 1 has value "2"
Then field "verwendlfristkurz" from editor "AU039B" in row 1 has value "ja"
Then field "verwendlfristkurz" from editor "AU039B" in row 2 has value "nein"
Then field "ofverfuegbmge" from editor "AU039B" in row 1 has value "0"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "0"

# AU altert
Given I set the fake date to "04.01.95"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "0"
Then field "ofverfuegbmge" from editor "AU039" in row 1 has value "0"
Given I set the fake date to "13.01.95"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "0"
Given I set the fake date to "19.01.95"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "50"
Given I set the fake date to "22.03.95"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "50"

#----------------------------------------------------------------------------------------------
Scenario: VK - Rahmenauftrag, Verfuegbare Menge in Vorgangskette
#              Verschiedene Einheiten, gebuchte und ungebuchte Lieferscheine
#----------------------------------------------------------------------------------------------

# Rahmenauftrag 040 anlegen mit lfristkurz
Given I open an editor "RA040" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| kunde  | 001      |
| nummer | 1RA040   |
| such   | RA040    |
| vom    | .        |
And I append rows
| artikel | he   | mge  | preis | verfuegbmge | lzeit | lfristkurz |
| !TE021  | Paar | 1000 | 35    | 150         | 10    | 2          |
And I save the current editor

Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "150"

Given I open an editor "AU040" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
| kunde  | 001     |
| such   | AU040   |
| vom    | .       |
And I append rows
| artikel | mge | he | zrahmen |
| !TE021  | 12  | kg | RA040   |
Then field "verfuegbmge" has value "30" in row 1
And I save the current editor
# Liefertermin - lzeit liegt in der Zukunft
Then field "lfristkurz" from editor "AU040" in row 1 has value "2"
# Einheit Kg (1 Kg = 10 Stueck; 1 Paar = 2 Stueck)
Then field "ofverfuegbmge" from editor "AU040" in row 1 has value "18"
# Einheit Paare
Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "90"

# 1. Teillieferung zu Auftrag
Given I open an editor "1LS040" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU040"
And I set fields
   | nummer | 1LS040 |
   | vom    | .      |
And I set field "fixpwert" to "false" in row 1
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "1RA040" in row 1
Then field "verfuegbmge" has value "30" in row 1
And I save the current editor

Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "90"

# LS direkt anlegen
Given I open an editor "LS040X" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
| kunde  | 001    |
| such   | LS040X |
| vom    | .      |
| tterm  | .      |
And I create a new row at the end of the table
And I set field "artikel" to "!TE021" in row 1
# Preisfindung findet einen Rahmenauftrag.
And I set field "mge" to "62" in row 1
And I set field "he" to "Stück" in row 1
Then field "zrahmen" has value "1RA040" in row 1
Then field "verfuegbmge" has value "300" in row 1
And I set field "tterm" to "." in row 1
And I save the current editor

Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "59"

# Lieferschein LS040X buchen
Given I open an editor "LS040XX" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS040X"
And I set fields
   | ueb     | ja      |
And I save the current editor

Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "59"

# 2. Teillieferung zu Auftrag, Ueberlieferung
Given I open an editor "1LS040B" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU040"
And I set fields
   | nummer | 1LS040B |
   | vom    | .       |
And I set field "fixpwert" to "false" in row 1
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "1RA040" in row 1
Then field "verfuegbmge" has value "30" in row 1
And I save the current editor

Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "44"

# Auftrag aus Rahmenauftrag erzeugen, Menge groesser als sofort verfuegbare Menge
Given I open an editor "AU040B" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RA040"
And I set fields
| such   | AU040B  |
| vom    | .       |
And I set field "mge" to "120" in row 1
And I set field "he" to "Stück" in row 1
Then field "verfuegbmge" has value "300" in row 1
And I save the current editor
# Liefertermin - lzeit liegt in der Zukunft
Then field "verwendlfristkurz" from editor "AU040B" in row 1 has value "nein"
# Stueck
Then field "ofverfuegbmge" from editor "AU040B" in row 1 has value "88"
# Paare
Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "44"

Given I open an editor "RE040X" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS040X"
And I set fields
   | such    | RE040X   |
   | ueb     | ja       |
   | vom     | .        |
   | tterm   | .        |
And I set field "mge" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "44"

#----------------------------------------------------------------------------------------------
Scenario: VK - Rahmenauftrag mit lfristkurz und maxabrufmge
#----------------------------------------------------------------------------------------------
# Rahmenauftrag 41 anlegen mit lfristkurz und maxabrufmge
Given I open an editor "RA-VK-41" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 41VKRA1  |
   | kunde   | 1        |
   | such    | RA-VK-41 |
   | vom     | .        |
And I append rows
   | artikel | he    | mge | preis | verfuegbmge | lzeit | lfristkurz | maxabrufmge |
   | TE016   | Stück | 100 | 11    | 5           | 10    | 2          | 120         |
And I save the current editor

# Auftrag 1 zu RA 41
Given I open an editor "AU-VK-41" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 41VKAU1  |
   | kunde  | 1        |
   | such   | RA-VK-41 |
   | vom    | .        |
And I append rows
   | artikel | mge | tterm |
   | TE016   | 2   |  +2   |
Then field "zrahmen" has value "41VKRA1" in row 1
Then field "verwendlfristkurz" has value "ja" in row 1
And I save the current editor

# Sofort verfuegbare Menge wird von Auftrag reduziert
Then field "ofverfuegbmge" from editor "AU-VK-41" in row 1 has value "3"
Then field "ofverfuegbmge" from editor "RA-VK-41" in row 1 has value "3"

#----------------------------------------------------------------------------------------------
Scenario: VK - Aenderung des Kunden in einer Rechnung mit Rahmenauftragsbezug
#----------------------------------------------------------------------------------------------

# Rahmenauftrag anlegen
Given I open an editor "1RA046" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1RA046 |
   | kunde   | 1      |
   | such    | RA046  |
And I append rows
   | artikel | he    | mge  | preis |
   | TE046   | Stück | 100  | 40    |
And I save the current editor

# Auftrag
Given I open an editor "1AU046" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU046 |
   | kunde   | 1      |
   | such    | AU046  |
And I append rows
   | artikel | he    | mge  |
   | TE046   | Stück | 10   |
Then field "zrahmen" has value "1RA046" in row 1
And I save the current editor

# Lieferschein
Given I open an editor "1LS046" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU046"
And I set fields
   | nummer  | 1LS046 |
   | such    | LS046  |
   | ueb     | ja     |
And I set field "mge" to "20" in row 1
And I save the current editor

# Rechnung - (ev)orig muss beim Kundenwechsel erhalten bleiben
Given I open an editor "1RE046" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS046"
And I set fields
   | nummer   | 1RE0046 |
   | such     | RE046   |
   | kunde    | 4       |
   | ueb      | ja      |
   | tterm    | .       |
Then field "zrahmen" is empty in row 1
Then field "orig^kopf^nummer" has value "1LS046" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Rechnung mit Rahmenauftragsbezug und Aenderung der Positionswertfixierung in der Steuerposition
#----------------------------------------------------------------------------------------------

# Teil anlegen
Given I open an editor "TE100" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
| such     | TE100            |
| namebspr | Teil 100         |
| vpr      | 100              |
| epr      | 100              |
| bsart    | Fremdbeschaffung |
| dispoa   | auftragsbezogen  |
And I save the current editor

# Rahmenauftrag anlegen
Given I open an editor "1RA015" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1      |
   | nummer  | 1RA015 |
   | such    | RA015  |
And I append rows
   | artikel | he    | mge  | preis |
   | TE100   | Stück | 1000 | 50    |
And I save the current editor

# Auftrag aus Rahmenauftrag
Given I open an editor "1AU015" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record from editor "1RA015"
And I set fields
   | nummer | 1AU015  |
   | such   | AU015   |
   | kunde  | 1       |
And I set field "mge" to "100" in row 1
And I save the current editor

# Rechnung aus Auftrag
Given I open an editor "1RE015" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU015"
And I set fields
   | nummer | 1RE015  |
   | such   | RE015   |
   | tterm  | .       |
And I set field "mge" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung bearbeiten - Positionswertfixierung in der Steuerposition aendern
Given I open an editor "1RE015" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "1RE015"
And I set field "fixpwert" to "nein" in row 3
And I set field "fixpwert" to "ja" in row 3
And I save the current editor

################################## EINKAUF ##################################

#----------------------------------------------------------------------------------------------
Scenario: EK STAMMDATEN - Neuen Lieferanten anlegen
#----------------------------------------------------------------------------------------------
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "REUS"
And I set fields
| such     | REUS                      |
| namebspr | Reus Werkzeugbau, Rastatt |
| ans      | Reus Werkzeugbau GmbH     |
| str      | Riedstr. 24-28            |
| plz      | 76437                     |
| nort     | Rastatt                   |
| tele     | +49 (0) 7222/9456-0       |
| email    | info@bayram-corp.de       |
| betreuer | .                         |
| ans2     | Reus Fussball GmbH        |
| str2     | Bvbstr. 24-28             |
| plz2     | 33333                     |
| nort2    | Dortmund                  |
| ustid    | DE56454651                |
| lbed     | EXW                       |
| zbed     | 201                       |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario Outline: EK STAMMDATEN - Zwei neue Artikel mit Mindestbestand anlegen
#----------------------------------------------------------------------------------------------
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "bsart" to "<bsart>"
And I set field "dispoa" to "<dispoa>"
And I set field "mindest" to "<mindest>"
And I set field "lief" to "<lief>"
And I set field "epr" to "<epr>"
And I set field "efrist" to "<efrist>"
And I save the current editor
Examples: Artikel
| such     | namebspr  | vkbez     | vbez      | ebez      | vpr   | bsart            | dispoa         | mindest | lief | epr  | efrist |
| artikel1 | Artikel 1 | Artikel 1 | Artikel 1 | Artikel 1 | 10000 | Fremdbeschaffung | bedarfsbezogen | 30      | reus | 9000 | 15     |
| artikel2 | Artikel 2 | Artikel 2 | Artikel 2 | Artikel 2 | 9000  | Fremdbeschaffung | bedarfsbezogen | 21      | reus | 7000 | 10     |


#----------------------------------------------------------------------------------------------
Scenario: EK - Aus Rahmenauftrag eine Bestellung erstellen
#----------------------------------------------------------------------------------------------
# Rahmenauftraege anlegen
Given I open an editor "rahmen-EK-01" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 1        |
   | nummer  | 01EKRA   |
   | such    | RA-EK-01 |
   | betreff | RAEK01   |
And I append rows
   | artikel | he    | mge  | preis |
   | TRA10PS | Stück | 1000 | 90    |
   | TRA20PS | Stück | 1000 | 100   |
And I save the current editor

# Feld fzahlgeliefert darf nicht veraendert werden
Given I open an editor "rahmen-EK-01" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA-EK-01"
Then setting field "fzahlgeliefert" to "999" throws the exception "1283"
And I close the current editor

Given I open an editor "rahmen-EK-02" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 002      |
   | nummer  | 02EK     |
   | such    | RA-EK-02 |
   | betreff | RAEK02   |
And I append rows
   | artikel | he    | mge  | preis |
   | TE011   | Stück | 1000 | 23    |
And I save the current editor

# Bestellung aus Rahmenauftrag 01
Given I open an editor "BE-ZU-RA01" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-01"
And I set fields
   | such    | BE-RA01 |
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "01EKRA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-01" in row 1
Then setting field "fzahlgeliefert" to "999" throws the exception "1283"
# Lieferantenkontakt zum Hauptliefranten 1
And I set field "lief" to "200"
Then field "rahmen" has value "01EKRA"
Then field "zrahmen" has value "01EKRA" in row 1
# Liefrantenkontakt zu einem anderen Hauptlieferanten
And I set field "lief" to "002"
Then field "rahmen" has value ""
Then field "zrahmen" has value "" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung Neu: Rahmenauftrag in "Beleg anfuegen" angeben
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-ZU-RA02" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | beleg   | 01EKRA  |
   | such    | BE-RA02 |
And I set field "mge" to "20" in row 1
Then field "zrahmen" has value "01EKRA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-01" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Nicht passenden Rahmenauftrag ueber "Beleg anfuegen" (bei vorhandenem Vorgang)
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-RA02" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE-RA02"
Then the table has 2 rows
And I set field "beleg" to "02EK"
Then the table has 2 rows
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung Neu
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-ZU-RA01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 01BE    |
   | lief    | 1       |
   | such    | BE-RA01 |
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "20" in row 1
And I set field "zrahmen" to "01EKRA" in row 1
Then field "zrahmen" has value "01EKRA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-01" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung aus Anfrage
#----------------------------------------------------------------------------------------------
Given I open an editor "ANF-ZU-RA04" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
   | lief    | 1        |
   | such    | ANF-RA04 |
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "15" in row 1
# Keine Preisfindung in Anfragen. Rahmenauftragsangaben manuell eintragen.
And I set field "zrahmen" to "01EKRA" in row 1
And I set field "zrahmenpos" to "pos^id" from editor "rahmen-EK-01" in row 1
Then setting field "fzahlgeliefert" to "999" throws the exception "1283"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung aus Anfrage
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-ZU-RA06" from table "(Purchasing):(Request)" with command "RELEASE" for record from editor "ANF-ZU-RA04"
And I set field "such" to "BE-RA06"
Then field "zrahmen" has value "01EKRA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-01" in row 1
Then the table has 1 rows
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Anfrage kopieren
#----------------------------------------------------------------------------------------------
Given I open an editor "ANF-RA04-KOPIE" from table "(Purchasing):(Request)" with command "COPY" for record from editor "ANF-ZU-RA04"
And I set field "such" to "ANF-RA04K"
And I set field "vom" to "."
Then field "zrahmen" has value "01EKRA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-01" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung kopieren
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-RA01-KOPIE" from table "(Purchasing):(PurchaseOrder)" with command "COPY" for record from editor "BE-ZU-RA01"
And I set field "such" to "BE-RA01K"
And I set field "vom" to "."
Then field "zrahmen" has value "01EKRA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-01" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Lieferschein kopieren, stornieren
#----------------------------------------------------------------------------------------------
Given I open an editor "LS-ZU-RA01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE-ZU-RA01"
And I set fields
   | ebeleg  | 01EKLS   |
   | such    | ELS-RA01 |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "8" in row 1
Then field "zrahmen" has value "01EKRA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-01" in row 1
Then setting field "fzahlgeliefert" to "999" throws the exception "1283"
And I save the current editor

# Pruefen fzahl und fzahlgeliefert im Rahmen und LS
Then field "fzahl" from editor "rahmen-EK-01" in row 1 has value "8"
Then field "fzahlgeliefert" from editor "rahmen-EK-01" in row 1 has value "8"

Then field "fzahl" from editor "LS-ZU-RA01" in row 1 has value "8"
Then field "fzahlgeliefert" from editor "LS-ZU-RA01" in row 1 has value "8"

# LS kopieren
Given I open an editor "LS-RA01-KOPIE" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "LS-ZU-RA01"
And I set field "such" to "LS-RA01K"
And I set field "nummer" to "1LS05K"
And I set field "vom" to "."
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos" has value "" in row 1
Then field "fzahlabrufoffenicon" has value "" in row 1
And I save the current editor

# Lieferschein erstellen -> stornieren
Given I open an editor "ELS-ZU-RA01B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "01BE"
And I set fields
   | such    | ELS-RA01B |
   | ebeleg  | 01EKSLS   |
   | vom     | .         |
   | tterm   | .         |
   | ueb     | ja        |
And I set field "mge" to "8" in row 1
Then field "zrahmen" has value "01EKRA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-01" in row 1
And I save the current editor

# Pruefen fzahl und fzahlgeliefert im Rahmen
Then field "fzahl" from editor "rahmen-EK-01" in row 1 has value "16"
Then field "fzahlgeliefert" from editor "rahmen-EK-01" in row 1 has value "16"

# LS stornieren und Fortschrittszahlen pruefen
Given I open an editor "SELS-ZU-RA01B" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "ELS-ZU-RA01B"
And I save the current editor
Then field "fzahl" from editor "rahmen-EK-01" in row 1 has value "8"
Then field "fzahlgeliefert" from editor "rahmen-EK-01" in row 1 has value "8"

#----------------------------------------------------------------------------------------------
Scenario: EK - Rechnung und Rechnung mit LB: kopieren und stornieren, RA kopieren
#----------------------------------------------------------------------------------------------
Given I open an editor "ERE-ZU-RA01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS-ZU-RA01"
And I set fields
   | ebeleg  | 01EKRE   |
   | such    | ERE-RA01 |
   | ueb     | ja       |
   | vom     | .        |
   | tterm   | .        |
And I set field "mge" to "8" in row 1
Then field "zrahmen" has value "01EKRA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-01" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE-RA01-KOPIE" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "ERE-ZU-RA01"
And I set field "such" to "RE-RA01K"
And I set field "nummer" to "1RE05K"
And I set field "vom" to "."
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos" has value "" in row 1
And I save the current editor

# Rechnung mit LB
Given I open an editor "ERE-ZU-RA01LB" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "01BE"
And I set fields
   | ebeleg | 01BEKRE   |
   | such   | ERE-RA1LB |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
   | fakt   | ja        |
And I set field "mge" to "6" in row 1
Then field "zrahmen" has value "01EKRA" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-01" in row 1
Then setting field "fzahlgeliefert" to "999" throws the exception "1283"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Fortschrittszahlen im RA ueberpruefen
Then field "fzahl" from editor "rahmen-EK-01" in row 1 has value "14"
Then field "fzahlgeliefert" from editor "rahmen-EK-01" in row 1 has value "14"

# RE stornieren und Fortschrittszahlen pruefen
Given I open an editor "SERE-ZU-RA01LB" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "ERE-ZU-RA01LB"
And I save the current editor
Then field "fzahl" from editor "rahmen-EK-01" in row 1 has value "8"
Then field "fzahlgeliefert" from editor "rahmen-EK-01" in row 1 has value "8"

# Initialisierung der Felder beim Kopieren eines RA
Given I open an editor "RA01-EK-Kopie" from table "(Purchasing):(BlanketOrder)" with command "COPY" for record from editor "rahmen-EK-01"
Then field "fzahl" from editor "RA01-EK-Kopie" in row 1 has value "0"
Then field "maxabrufmge" from editor "RA01-EK-Kopie" in row 1 has value "0"
Then field "fzahlgeliefert" from editor "RA01-EK-Kopie" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "RA01-EK-Kopie" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "RA01-EK-Kopie" in row 1 has value "1000"
Then field "zgltvon" from editor "RA01-EK-Kopie" in row 1 has value ""
Then field "zgltbis" from editor "RA01-EK-Kopie" in row 1 has value ""
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Setzen und Ruecksetzen von (ev)zrahmenpos
#----------------------------------------------------------------------------------------------
Given I open an editor "1RA009-EK" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | nummer | 1RA009 |
And I append rows
   | artikel | mge   | preis |
   | TE015   | 1500  | 150   |
   | TE016   | 1600  | 160   |
And I save the current editor

Given I open an editor "2RA009-EK" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | nummer | 2RA009 |
And I append rows
   | artikel | mge   | preis |
   | TE015   | 1500  | 151   |
And I save the current editor

Given I open an editor "3RA009-EK" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 001    |
   | nummer | 3RA009 |
And I append rows
   | artikel | mge  | preis | savings |
   | TE015   | 1500 | 152   | true    |
And I save the current editor

Given I open an editor "1BE009" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | nummer | 1BE009 |
And I append rows
   | artikel | mge  |
   | TE015   | 150  |
Then field "zrahmen" has value "2RA009" in row 1
Then field "preis" has value "151.00" in row 1
And I set field "artikel" to "TE016" in row 1
And I set field "mge" to "150" in row 1
Then field "zrahmen" has value "1RA009" in row 1
Then field "zrahmenpos" has value "*" in row 1
Then field "preis" has value "160.00" in row 1
Then setting field "zrahmen" to "2RA009" in row 1 throws the exception "2438"
And I close the current editor

Given I open an editor "1BE009" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record from editor "2RA009-EK"
And I set fields
   | lief   | 1      |
   | nummer | 1BE009 |
Then field "rahmen" has value "2RA009"
And I set field "mge" to "150" in row 1
And I set field "zignrahmen" to "true" in row 1
Then field "zrahmen" is empty in row 1
Then field "zrahmenpos" is empty in row 1
And I set field "fixpwert" to "false" in row 1
Then field "zrahmen" is empty in row 1
Then field "zrahmenpos" is empty in row 1
And I set field "fixpwert" to "true" in row 1
And I set field "zignrahmen" to "false" in row 1
# Wegen (ev)fixpwert = true keine Uebernahme des Rahmenauftrags aus dem Kopffeld (ev)rahmen
Then field "zrahmen" is empty in row 1
Then field "zrahmenpos" is empty in row 1
And I set field "fixpwert" to "false" in row 1
Then field "zrahmen" has value "2RA009" in row 1
And I close the current editor

Given I open an editor "1BE009" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | nummer | 1BE009 |
And I set field "beleg" to "2RA009"
Then field "rahmen" is empty
And I set field "mge" to "150" in row 1
And I set field "zignrahmen" to "true" in row 1
Then field "zrahmen" is empty in row 1
Then field "zrahmenpos" is empty in row 1
And I set field "zignrahmen" to "false" in row 1
Then field "zrahmen" is empty in row 1
Then field "zrahmenpos" is empty in row 1
And I set field "fixpwert" to "false" in row 1
Then field "zrahmen" has value "2RA009" in row 1
And I close the current editor

Given I open an editor "1BE009" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | nummer | 1BE009 |
And I append rows
   | artikel | mge  |
   | TE015   | 150  |
Then field "zrahmen" has value "2RA009" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "2RA009-EK" in row 0
And I set field "ignrahmen" to "true"
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I set field "ignrahmen" to "false"
Then field "zrahmen" has value "2RA009" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "2RA009-EK" in row 0
And I set field "lief " to "001"
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I set field "rahmen" to "3RA009"
Then field "zrahmen" has value "3RA009" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "3RA009-EK" in row 0
And I set field "zignrahmen" to "true" in row 1
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I set field "lief " to "1"
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I set field "zignrahmen" to "false" in row 1
Then field "zrahmen" has value "2RA009" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "2RA009-EK" in row 0
And I set field "mge" to "0" in row 1
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I set field "lief " to "004"
And I set field "mge" to "150" in row 1
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I set field "lief " to "1"
Then field "zrahmen" has value "2RA009" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "2RA009-EK" in row 0
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK -Loeschen von Rahmenauftraegen und Rahmenauftragspositionen
#----------------------------------------------------------------------------------------------
Given I open an editor "2BE009" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 001    |
   | nummer | 2BE009 |
And I append rows
   | artikel | mge  | zrahmen |
   | TE015   | 150  | 3RA009  |
And I save the current editor

Given I open an editor "2RA009-EK" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record from editor "2RA009-EK"
# Loeschen nicht erlaubt. Position wird schon verwendet.
Then deleting the row at position 1 throws the exception "10938"
And I respond with answer "JA" to the dialog with id "191"
# Stornieren nicht erlaubt. Position wird schon verwendet.
Then setting field "mge" to "0" in row 1 throws the exception "10939"
And I close the current editor

Given I open an editor "3RA009-EK" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record from editor "3RA009-EK"
And I set field "tterm" to ""
And I save the current editor

Given I open an editor "CleanUp" for tip command "(CleanUp)" and arguments ""
And I set field "obj" to "Einkauf"
And I set field "stich" to "." in row 2
And I respond with answer "Ja" to the dialog with id "2077"
And I save the current editor

Given I open an editor "2BE009" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "2BE009"
Then field "zrahmen" has value "" in row 1
Then field "zrahmenpos^id" has value "(0,0,0)" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK -Aendern der Fortschrittszahl: fzahl und fzahlgeliefert laufen auseinander
#----------------------------------------------------------------------------------------------
# Rahmenauftrag 11 anlegen
Given I open an editor "rahmen-EK-11" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 11       |
   | lief    | 1        |
   | such    | RA-EK-11 |
   | betreff | RAEK11   |
And I append rows
   | artikel | he    | mge  | preis |
   | TRA10PS | Stück | 1000 | 90    |
And I save the current editor

# Bestellung aus Rahmenauftrag 11
Given I open an editor "BE-ZU-RA11" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-11"
And I set fields
   | such    | BE-RA11 |
And I set field "mge" to "100" in row 1
And I save the current editor

# Lieferschein 11 buchen
Given I open an editor "LS-EK-RA11" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE-ZU-RA11"
And I set fields
   | ebeleg  | 11EKLS  |
   | such    | LS-RA11 |
   | vom     | .       |
   | tterm   | .       |
   | ueb     | ja      |
And I set field "mge" to "15" in row 1
And I save the current editor

# Pruefen fzahl und fzahlgeliefert im Rahmen und LS
Then field "fzahl" from editor "rahmen-EK-11" in row 1 has value "15"
Then field "fzahlgeliefert" from editor "rahmen-EK-11" in row 1 has value "15"

Then field "fzahl" from editor "LS-EK-RA11" in row 1 has value "15"
Then field "fzahlgeliefert" from editor "LS-EK-RA11" in row 1 has value "15"

# Bestellung aus Rahmenauftrag 11, mge pruefen (mge - fzahlabgerufen)
Given I open an editor "BE-ZU-RA11B" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-11"
And I set fields
   | such    | BE-RA11B |
Then field "mge" has value "900" in row 1
And I close the current editor

# Im Rahmenauftrag, Fortschrittszahl manuell aendern
Given I open an editor "rahmen-EK-11" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA-EK-11"
And I set field "fzahl" to "7" in row 1
And I save the current editor

# Lieferschein 11B buchen
Given I open an editor "LS-EK-RA11B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE-ZU-RA11"
And I set fields
   | ebeleg  | 11EKLS   |
   | such    | LS-RA11B |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "30" in row 1
And I save the current editor

# Pruefen fzahl und fzahlgeliefert im Rahmen und LS
Then field "fzahl" from editor "rahmen-EK-11" in row 1 has value "37"
Then field "fzahlgeliefert" from editor "rahmen-EK-11" in row 1 has value "45"

Then field "fzahl" from editor "LS-EK-RA11B" in row 1 has value "37"
Then field "fzahlgeliefert" from editor "LS-EK-RA11B" in row 1 has value "45"

# RLS erzeugen
Given I open an editor "LS-EK-RLS11" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS-RA11"
And I set fields
   | ebeleg  | 11EKRLS   |
   | such    | RLS-RA11B |
   | vom     | .         |
   | tterm   | .         |
   | ueb     | ja        |
And I set field "mge" to "-5" in row 1
And I save the current editor
Then field "fzahl" from editor "rahmen-EK-11" in row 1 has value "32"
Then field "fzahlgeliefert" from editor "rahmen-EK-11" in row 1 has value "40"

# RLS stornieren
Given I open an editor "SLS-EK-RLS11" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS-EK-RLS11"
And I save the current editor
Then field "fzahl" from editor "rahmen-EK-11" in row 1 has value "37"
Then field "fzahlgeliefert" from editor "rahmen-EK-11" in row 1 has value "45"

#----------------------------------------------------------------------------------------------
Scenario: EK -Plausibilitaetspruefung maximale Rahmenmenge
#----------------------------------------------------------------------------------------------
# Rahmenauftrag 12 anlegen
Given I open an editor "rahmen-EK-12" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 12       |
   | lief    | 1        |
   | such    | RA-EK-12 |
   | betreff | RAEK12   |
And I append rows
   | artikel | he    | mge  | preis |
   |  TE010  | Stück | 150  | 50    |
Then setting field "maxabrufmge" to "140" in row 1 throws the exception "1048"
And I set field "maxabrufmge" to "0" in row 1
And I set field "maxabrufmge" to "160" in row 1
Then field "maxabrufmge" has value "160" in row 1
Then setting field "mge" to "200" in row 1 throws the exception "1048"
And I set field "maxabrufmge" to "250" in row 1
And I set field "mge" to "200" in row 1
And I save the current editor

# Bestellung aus Rahmenauftrag 12: maxabrufmge wird nicht vererbt
Given I open an editor "BE-ZU-RA12" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-12"
And I set fields
   | such    | BE-RA12 |
And I set field "mge" to "100" in row 1
Then field "maxabrufmge" has value "0" in row 1
And I save the current editor
Then field "maxabrufmge" from editor "BE-ZU-RA12" in row 1 has value "0"

#----------------------------------------------------------------------------------------------
Scenario: EK -Pruefung der Fortschrittszahlen mit RLS und Storno
#----------------------------------------------------------------------------------------------

#  RA-EK-14 ----------------------------------------- BE-RA14
#  1000 St.                                           30 St. (1!) ---> 20 St. (2!)
#  | Aktion | fzahlgeliefert | fzahlabgerufen |       | Aktion | limge  | lifrg  |
#  | (1)    |  0 St.         | 30 St.         |       | (1)    | 30 St. |  0 St. |
#  | (2)    |  0 St.         | 20 St.         |       | (2)    | 20 St. |  0 St. |
#  | (3)    |  0 St.         | 20 St.         |       | (3)    | 20 St. | 10 St. |
#  | (4)    |  0 St.         | 20 St.         |       | (4)    | 20 St. | 20 St. |
#  | (5)    |  0 St.         | 30 St.         |       | (5)    | 20 St. | 30 St. |
#  | (6)    | 20 St.         | 30 St.         |       | (6)    |  0 St. | 10 St. |
#  | (7)    | 30 St.         | 30 St.         |       | (7)    |  0 St. |  0 St. |
#  | (8)    | 30 St.         | 25 St.         |       | (8)    |  0 St. |  0 St. |
#  | (9)    | 20 St.         | 15 St.         |       | (9)    |  0 St. |  0 St. |
#  | (10)   | 20 St.         | 10 St.         |       | (10)   |  0 St. |  0 St. |
#  | (11)   | 10 St.         | 10 St.         |       | (11)   |  0 St. |  0 St. |
#                                                       /
#                                                      /
#     ------------------------------------------------
#   /
#   \
#      -------------- LS1-RA14 (ungebucht) ------------- LS1-RA14 (gebucht)
#     \               10 St. (3!) ---> 20 St. (5!)       20 St. (6!)
#      \                                                   \
#       \                                                   \
#        \                                                     ----------- VRLSRA14 (Rueck-LS, ungebucht) -------- VRLSRA14 (gebucht)
#         \                                                                -5 St. (8!) -------> -10 St. (10!)      -10 St. (11!)
#          \
#             ------------ LS2-RA14 (ungebucht) ---------------- LS2-RA14 (gebucht) ---- 2LSRA14S (Storno)
#                          10 St. (4!)                           10 St. (7!)             -10 St. (9!)

# Rahmenauftrag 14 mit Menge 1000
Given I open an editor "rahmen-EK-14" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 14RA        |
   | lief    | 001         |
   | such    | RA-EK-14    |
   | betreff | Test fzahl* |
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "140" in row 1
And I save the current editor

# Bestellung aus Rahmenauftrag 14 mit Menge 30
Given I open an editor "BE-ZU-RA14" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-14"
And I set fields
   | nummer  | 14BE    |
   | such    | BE-RA14 |
And I set field "mge" to "30" in row 1
And I save the current editor

Then field "fzahlabrufoffen" from editor "BE-ZU-RA14" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "BE-ZU-RA14" in row 1 has value "0"
Then field "fzahlgeliefert" from editor "rahmen-EK-14" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-EK-14" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-EK-14" in row 1 has value "970"

# Bestellung auf 20 reduzieren
Given I open an editor "BE-EK-14" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "14BE"
And I set field "mge" to "20" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-14" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-EK-14" in row 1 has value "20"
Then field "fzahlabrufoffen" from editor "rahmen-EK-14" in row 1 has value "980"

# LS 1 und LS 2 ungebucht
Given I open an editor "LS1-RA14" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "14BE"
And I set fields
   | nummer  | 14LS1    |
   | such    | LS1-RA14 |
   | ueb     | nein     |
   | vom     | .        |
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "LS2-RA14" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "14BE"
And I set fields
   | nummer  | 14LS2    |
   | such    | LS2-RA14 |
   | ueb     | nein     |
   | vom     | .        |
And I set field "mge" to "10" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-EK-14" in row 1 has value "20"
Then field "fzahlabrufoffen" from editor "rahmen-EK-14" in row 1 has value "980"

# LS 1 Menge erhoehen 10 -> 20
Given I open an editor "LS1-RA14" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS1-RA14"
And I set field "mge" to "20" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-EK-14" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-EK-14" in row 1 has value "970"

# LS 1 buchen (Menge 20) (6!)
Given I open an editor "LS1-RA14" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS1-RA14"
And I set fields
   | ueb     | ja     |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-14" in row 1 has value "20"
Then field "fzahlabgerufen" from editor "rahmen-EK-14" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-EK-14" in row 1 has value "970"

# LS 2 buchen (Menge 10) (7!)
Given I open an editor "LS2-RA14" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS2-RA14"
And I set fields
   | ueb     | ja     |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-14" in row 1 has value "30"
Then field "fzahlabgerufen" from editor "rahmen-EK-14" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-EK-14" in row 1 has value "970"

# RLS 1 ungebucht Menge -5 (8!)
Given I open an editor "RLS1-RA14" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS1-RA14"
And I set fields
   | such    | VRLSRA14  |
   | vom     | .         |
   | tterm   | .         |
And I set field "mge" to "-5" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-14" in row 1 has value "30"
Then field "fzahlabgerufen" from editor "rahmen-EK-14" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-EK-14" in row 1 has value "975"

# LS 2 storno Menge 10 (9!)
Given I open an editor "SLS2-RA14" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS2-RA14"
And I set fields
   | nummer | 2LSRA14S |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-14" in row 1 has value "20"
Then field "fzahlabgerufen" from editor "rahmen-EK-14" in row 1 has value "15"
Then field "fzahlabrufoffen" from editor "rahmen-EK-14" in row 1 has value "985"

# RLS 1 ungebucht Menge erhoehen -5 -> -10 (10!)
Given I open an editor "RLS1-RA14" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS1-RA14"
And I set field "mge" to "-10" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-14" in row 1 has value "20"
Then field "fzahlabgerufen" from editor "rahmen-EK-14" in row 1 has value "10"
Then field "fzahlabrufoffen" from editor "rahmen-EK-14" in row 1 has value "990"

# RLS 1 buchen (11!)
Given I open an editor "RLS1-RA14" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS1-RA14"
And I set fields
   | ueb     | ja        |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-14" in row 1 has value "10"
Then field "fzahlabgerufen" from editor "rahmen-EK-14" in row 1 has value "10"
Then field "fzahlabrufoffen" from editor "rahmen-EK-14" in row 1 has value "990"

#----------------------------------------------------------------------------------------------
Scenario: EK - Pruefung der Fortschrittszahlen mit Mengenaenderung, Ueberbelieferung, Buchung
#----------------------------------------------------------------------------------------------

#  RA-EK-15 ----------------------------------------- BE-RA15
#  1000 St.                                           30 St. (1!)
#  | Aktion | fzahlabgerufen | fzahlgeliefert |       | Aktion | limge  | lifrg  |
#  | (1)    | 30 St.         |  0 St.         |       | (1)    | 30 St. |  0 St. |
#  | (2)    | 30 St.         |  0 St.         |       | (2)    | 30 St. | 20 St. |
#  | (3)    | 40 St.         |  0 St.         |       | (3)    | 30 St. | 40 St. |
#  | (4)    | 30 St.         |  0 St.         |       | (4)    | 30 St. | 30 St. |
#  | (5)    | 40 St.         |  0 St.         |       | (5)    | 30 St. | 40 St. |
#  | (6)    | 30 St.         |  0 St.         |       | (6)    | 30 St. | 20 St. |
#  | (7)    | 50 St.         |  0 St.         |       | (7)    | 30 St. | 50 St. |
#  | (8)    | 80 St.         | 40 St.         |       | (8)    |  0 St. | 40 St. |
#  | (9)    | 50 St.         | 40 St.         |       | (9)    |  0 St. | 10 St. |
#  | (10)   | 50 St.         | 50 St.         |       | (10)   |  0 St. |  0 St. |
#                                                       /
#                                                      /
#     ------------------------------------------------
#   /
#   \
#      -------------- LS1-RA15 (ungebucht) ----------------------------------------------------------------LS1-RA15 (gebucht)
#     \               20 St. (2!) -----> 10 St. (4!) ------------------> 40 St. (7!) -----> 10 St. (9!)    10 St. (10!)
#      \
#       \
#         ----------------- LS2-RA15 (ungebucht) ------------------------------- LS2-RA15 (gebucht)
#                           20 St. (3!) -----> 30 St. (5!) -----> 10 St. (6!)    40 St. (8!)

# Rahmenauftrag 15 mit Menge 1000
Given I open an editor "rahmen-EK-15" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 15RA        |
   | lief    | 001         |
   | such    | RA-EK-15    |
   | betreff | Test fzahl* |
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "150" in row 1
And I save the current editor

# Bestellung aus Rahmenauftrag 15 mit Menge 30
Given I open an editor "BE-RA15" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-15"
And I set fields
   | nummer  | 15BE    |
   | such    | BE-RA15 |
And I set field "mge" to "30" in row 1
And I save the current editor

Then field "fzahlabrufoffen" from editor "BE-RA15" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "BE-RA15" in row 1 has value "0"
Then field "fzahlgeliefert" from editor "rahmen-EK-15" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-EK-15" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-EK-15" in row 1 has value "970"

# LS 1 und LS 2 ungebucht
Given I open an editor "LS1-RA15" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "15BE"
And I set fields
   | nummer  | 15LS     |
   | such    | LS1-RA15 |
   | ueb     | nein     |
   | vom     | .        |
And I set field "mge" to "20" in row 1
And I save the current editor

Given I open an editor "LS2-RA15" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "15BE"
And I set fields
   | nummer  | 15LS2    |
   | such    | LS2-RA15 |
   | ueb     | nein     |
   | vom     | .        |
And I set field "mge" to "20" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-EK-15" in row 1 has value "40"
Then field "fzahlabrufoffen" from editor "rahmen-EK-15" in row 1 has value "960"

# LS 1 Mengen aendern 20 -> 10 (4!) -> 40 (7!) -> 10 (9!)
# LS 2 Mengen aendern 20 -> 30 (5!) -> 10 (6!) -> 40 (8!)

# (4!)
Given I open an editor "LS1-RA15" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS1-RA15"
And I set field "mge" to "10" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-EK-15" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-EK-15" in row 1 has value "970"

# (5!)
Given I open an editor "LS2-RA15" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS2-RA15"
And I set field "mge" to "30" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-EK-15" in row 1 has value "40"
Then field "fzahlabrufoffen" from editor "rahmen-EK-15" in row 1 has value "960"

# (6!)
Given I open an editor "LS2-RA15" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS2-RA15"
And I set field "mge" to "10" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-EK-15" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-EK-15" in row 1 has value "970"

# (7!)
Given I open an editor "LS1-RA15" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS1-RA15"
And I set field "mge" to "40" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-EK-15" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-EK-15" in row 1 has value "950"

# (8!)
Given I open an editor "LS2-RA15" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS2-RA15"
And I set fields
   | ueb     | ja     |
And I set field "mge" to "40" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-15" in row 1 has value "40"
Then field "fzahlabgerufen" from editor "rahmen-EK-15" in row 1 has value "80"
Then field "fzahlabrufoffen" from editor "rahmen-EK-15" in row 1 has value "920"

# (9!)
Given I open an editor "LS1-RA15" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS1-RA15"
And I set field "mge" to "10" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-15" in row 1 has value "40"
Then field "fzahlabgerufen" from editor "rahmen-EK-15" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-EK-15" in row 1 has value "950"

# LS 1 buchen (Menge 10) (10!)
Given I open an editor "LS1-RA15" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS1-RA15"
And I set fields
   | ueb     | ja     |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-15" in row 1 has value "50"
Then field "fzahlabgerufen" from editor "rahmen-EK-15" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-EK-15" in row 1 has value "950"

#----------------------------------------------------------------------------------------------
Scenario: EK - Pruefung der Fortschrittszahlen mit Aenderung in AU und LS, Ueberbelieferung, Buchung, Restmengenstorno
#----------------------------------------------------------------------------------------------

#  RA-EK-16 ------------------------ BE-RA16
#  1000 St.                          30 St. (1!) ---> 100 St. (4!) ---> Restmengenstorno (6!)
#  | Aktion | fzahlabgerufen | fzahlgeliefert |      | Aktion | limge  | lifrg  |
#  | (1)    |  30 St.        |  0 St.         |      | (1)    | 30 St. |  0 St. |
#  | (2)    |  30 St.        |  0 St.         |      | (2)    | 30 St. | 30 St. |
#  | (3)    |  60 St.        | 30 St.         |      | (3)    |  0 St. | 30 St. |
#  | (4)    | 100 St.        | 30 St.         |      | (4)    | 70 St. | 30 St. |
#  | (5)    | 100 St.        | 70 St.         |      | (5)    | 30 St. |  0 St. |
#  | (6)    |  70 St.        | 70 St.         |      | (6)    |  0 St. |  0 St. |
#                                                      /
#                                                     /
#     -----------------------------------------------
#   /
#   \
#      -------------- LS1-RA16 (ungebucht) ----- LS1-RA16 (gebucht)
#     \               30 St. (2!)                40 St. (5!)
#      \
#       \
#         -------------------- LS2-RA16 (gebucht)
#                              30 St. (3!)

# Rahmenauftrag 16 mit Menge 1000
Given I open an editor "rahmen-EK-16" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 16RA        |
   | lief    | 001         |
   | such    | RA-EK-16    |
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "160" in row 1
And I save the current editor

# Bestellung aus Rahmenauftrag 16 mit Menge 30
Given I open an editor "BE-ZU-RA16" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-16"
And I set fields
   | nummer  | 16BE    |
   | such    | BE-RA16 |
And I set field "mge" to "30" in row 1
And I save the current editor

Then field "fzahlabrufoffen" from editor "BE-ZU-RA16" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "BE-ZU-RA16" in row 1 has value "0"
Then field "fzahlgeliefert" from editor "rahmen-EK-16" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-EK-16" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-EK-16" in row 1 has value "970"

# LS 1 ungebucht (2!)
Given I open an editor "LS1-RA16" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "16BE"
And I set fields
   | nummer  | 16LS     |
   | such    | LS1-RA16 |
   | ueb     | nein     |
   | vom     | .        |
And I set field "mge" to "30" in row 1
And I save the current editor

Then field "fzahlabgerufen" from editor "rahmen-EK-16" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-EK-16" in row 1 has value "970"

# LS 2 gebucht (3!)
Given I open an editor "LS2-RA16" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "16BE"
And I set fields
   | nummer  | 16LS2    |
   | such    | LS2-RA16 |
   | ueb     | ja       |
   | vom     | .        |
And I set field "mge" to "30" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-16" in row 1 has value "30"
Then field "fzahlabgerufen" from editor "rahmen-EK-16" in row 1 has value "60"
Then field "fzahlabrufoffen" from editor "rahmen-EK-16" in row 1 has value "940"

# Bestellung auf 100 erhoehen (4!)
Given I open an editor "BE-EK-16" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "16BE"
And I set field "mge" to "100" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-16" in row 1 has value "30"
Then field "fzahlabgerufen" from editor "rahmen-EK-16" in row 1 has value "100"
Then field "fzahlabrufoffen" from editor "rahmen-EK-16" in row 1 has value "900"

# LS 1 buchen (Menge 40) (5!)
Given I open an editor "LS1-RA16" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS1-RA16"
And I set fields
   | ueb     | ja     |
And I set field "mge" to "40" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-16" in row 1 has value "70"
Then field "fzahlabgerufen" from editor "rahmen-EK-16" in row 1 has value "100"
Then field "fzahlabrufoffen" from editor "rahmen-EK-16" in row 1 has value "900"

# Restmengenstorno Bestellung (4!)
Given I open an editor "BE-EK-16" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "16BE"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-16" in row 1 has value "70"
Then field "fzahlabgerufen" from editor "rahmen-EK-16" in row 1 has value "70"
Then field "fzahlabrufoffen" from editor "rahmen-EK-16" in row 1 has value "930"

#----------------------------------------------------------------------------------------------
Scenario: EK - Maximale Rahmenmenge (ev)maxabrufmge wirkt sich auf die Fortschrittszahlen aus
#----------------------------------------------------------------------------------------------

# Rahmenauftrag 17 anlegen
Given I open an editor "rahmen-EK-17" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 17RA     |
   | lief    | 1        |
   | such    | RA-EK-17 |
   | betreff | RAEK17   |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE010   | Stück | 170  | 70    | 200         |
And I save the current editor

# Bestellung aus Rahmenauftrag 17 mit Menge 35
Given I open an editor "BE17-RA17" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-17"
And I set fields
   | nummer  | 17BE      |
   | such    | BE17-RA17 |
And I set field "mge" to "35" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-17" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-EK-17" in row 1 has value "35"
Then field "fzahlabrufoffen" from editor "rahmen-EK-17" in row 1 has value "135"

#----------------------------------------------------------------------------------------------
Scenario: EK - Fortschrittszahlen bei unterschiedlichen Einheiten in den Vorgaengen
#----------------------------------------------------------------------------------------------
# Rahmenauftrag anlegen
Given I open an editor "rahmen-EK-18" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 18RA     |
   | lief    | 1        |
   | such    | RA-EK-18 |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE011   | Stück | 200  | 70    | 200         |
And I save the current editor

# Bestellung aus Rahmenauftrag
Given I open an editor "BE-RA18" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-18"
And I set fields
   | nummer  | 18BE    |
   | such    | BE-RA18 |
And I set field "he" to "kg" in row 1
And I set field "mge" to "100" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-18" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-EK-18" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-EK-18" in row 1 has value "150"

# Lieferschein aus Bestellung (ungebucht)
Given I open an editor "LS-RA18" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "18BE"
And I set fields
   | nummer  | 18LS    |
   | such    | LS-RA18 |
   | ueb     | nein    |
   | vom     | .       |
And I set field "he" to "Stück" in row 1
And I set field "mge" to "60" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-18" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-EK-18" in row 1 has value "60"
Then field "fzahlabrufoffen" from editor "rahmen-EK-18" in row 1 has value "140"

# Lieferschein buchen
Given I open an editor "LS-RA18" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS-RA18"
And I set fields
   | ueb     | ja     |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-18" in row 1 has value "60"
Then field "fzahlabgerufen" from editor "rahmen-EK-18" in row 1 has value "60"
Then field "fzahlabrufoffen" from editor "rahmen-EK-18" in row 1 has value "140"

# 2. Bestellung aus Rahmenauftrag
Given I open an editor "BE2-RA18" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-18"
And I set fields
   | nummer  | 18BE2    |
   | such    | BE2-RA18 |
And I set field "he" to "kg" in row 1
And I set field "mge" to "200" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-18" in row 1 has value "60"
Then field "fzahlabgerufen" from editor "rahmen-EK-18" in row 1 has value "160"
Then field "fzahlabrufoffen" from editor "rahmen-EK-18" in row 1 has value "40"

# Versuch die Einheit im 2. Bestellung aus Rahmenauftrag zu aendern
Given I open an editor "BE2-RA18" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "18BE2"
Then setting field "he" to "Stück" in row 1 throws the exception "1299"
And I set field "mge" to "100" in row 1
And I set field "he" to "Stück" in row 1
And I set field "he" to "kg" in row 1
And I set field "mge" to "200" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Eintrag im Feld Menge und seine Nachwirkungen - Plausi
#----------------------------------------------------------------------------------------------
# Meldung: Menge ueberschreitet die maximale Rahmenmenge.

# LS 1 ueber 201 Stueck: zu hoch
Given I open an editor "LS1-RA17" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE17-RA17"
And I set fields
   | nummer  | 17LS1    |
   | such    | LS1-RA17 |
   | vom     | .        |
   | ueb     | ja       |
Then setting field "mge" to "201" in row 1 throws the exception "1299"
And I set field "mge" to "190" in row 1
And I save the current editor

# Bestellung aus Rahmenauftrag 17 mit Menge 11: zu hoch!
Given I open an editor "2BE17-RA17" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-17"
And I set fields
   | nummer  | 17BE2     |
   | such    | BE17BRA17 |
Then setting field "mge" to "11" in row 1 throws the exception "1299"
And I close the current editor

# Anfrage anlegen - Keine Preisfindung - folglich kein "zrahmen"-Eintrag -
#  keine Pruefung gegen max. Rahmenmenge
Given I open an editor "ANF-ZU-RA17" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
   | lief    | 1        |
   | such    | ANF-RA17 |
And I append rows
   | artikel | he    |
   | TE010   | Stück |
And I set field "mge" to "11" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Rahmenauftragsposition in (ev)zrahmenpos eintragen
#----------------------------------------------------------------------------------------------
# Rahmenauftraege anlegen
Given I open an editor "rahmen-EK-20-1" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 20RA-1    |
   | lief    | 1         |
   | such    | RA-VK-201 |
And I append rows
   | artikel | he    | mge  | preis |
   | TE012   | Stück | 200  | 70    |
And I save the current editor

Given I open an editor "rahmen-EK-20-2" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 20RA-2    |
   | lief    | 1         |
   | such    | RA-VK-202 |
And I append rows
   | artikel | he    | mge  | preis |
   | TE012   | Stück | 200  | 80    |
And I save the current editor

# Besellung mit Variationen von (ev)zrahmen und (ev)zrahmenpos
Given I open an editor "BE-RA20" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 20AU    |
   | such   | BE-RA20 |
   | lief   | 1       |
And I append rows
   | artikel | mge |
   | TE012   | 20  |
Then field "zrahmen" has value "20RA-2" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-20-2" in row 0
And I set field "zrahmen" to "" in row 1
Then field "zrahmenpos" is empty in row 1
And I set field "zrahmen" to "20RA-1" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-20-1" in row 0
And I set field "zrahmenpos" to "" in row 1
Then field "zrahmen" is empty in row 1
And I set field "zrahmenpos" to "pos^id" from editor "rahmen-EK-20-1" in row 1
Then field "zrahmen" has value "20RA-1" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Gueltigkeitszeitraeume pruefen - Plausibilitaeten
#----------------------------------------------------------------------------------------------
# Rahmenauftrag anlegen, Vorgangsdatum leer lassen
Given I open an editor "rahmen-EK-21" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 21RA-EK  |
   | lief    | 1        |
   | such    | RA-EK-21 |
   | vom     |          |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE009   | Stück | 180  | 78    | 200         |
And I set field "zgltvon" to "." in row 1
And I set field "zgltbis" to "+4" in row 1
And I save the current editor

# gueltig von - bis: 02.01.1995 - 06.01.1995
Given I open an editor "rahmen-EK-21" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "21RA-EK"
Then setting field "zgltbis" to "-1" in row 1 throws the exception "8568"
And I close the current editor

# Vorgangsdatum setzen und Eingabe im bis-Feld pruefen
Given I open an editor "rahmen-EK-21" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "21RA-EK"
And I set fields
   | vom     | .       |
And I set field "zgltvon" to "+2" in row 1
Then setting field "zgltbis" to "." in row 1 throws the exception "8568"
And I close the current editor

Given I open an editor "21RA-EK-Kopie" from table "(Purchasing):(BlanketOrder)" with command "COPY" for record from editor "rahmen-EK-21"
Then field "fzahlabrufoffen" from editor "21RA-EK-Kopie" in row 1 has value "180"
Then field "maxabrufmge" from editor "21RA-EK-Kopie" in row 1 has value "0"
Then field "zgltvon" from editor "21RA-EK-Kopie" in row 1 has value ""
Then field "zgltbis" from editor "21RA-EK-Kopie" in row 1 has value ""
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Ist die Rahmenmenge ausgeschoepft?
#----------------------------------------------------------------------------------------------
Given I open an editor "rahmen-EK-22" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 22RAEK   |
   | lief    | 004      |
   | such    | RA-EK-22 |
   | vom     | .        |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE009   | Stück | 22   | 78    | 24          |
And I save the current editor

# Bestellung 1 + Lieferung 1
Given I open an editor "BE1-RA22" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 22BE1    |
   | lief   | 004      |
   | such   | BE1-RA22 |
And I append rows
   | artikel | mge |
   | TE009   | 20  |
And I save the current editor

# LS 1 ueber 20 Stueck
Given I open an editor "LS1-EK-RA22" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "22BE1"
And I set fields
   | such    | LS1-RA22E |
   | ebeleg  | BE1-RA22  |
   | vom     | .         |
   | ueb     | ja        |
And I set field "mge" to "20" in row 1
And I save the current editor

# Bestellung 2 + Lieferung 2
Given I open an editor "BE2-RA22" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 22BE2    |
   | lief   | 004      |
   | such   | BE2-RA22 |
And I append rows
   | artikel | mge |
   | TE009   |  2  |
And I save the current editor

# LS 2 ueber 4 Stueck
Given I open an editor "LS2-EK-RA22" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "22BE2"
And I set fields
   | such    | LS2-RA22E |
   | ebeleg  | BE2-RA22  |
   | vom     | .         |
   | ueb     | ja        |
And I set field "mge" to "4" in row 1
And I save the current editor

# Bestellung 3, zrahmenpos eintragen -> Meldung: Rahmenauftrag ist ausgeschoepft
Given I open an editor "BE3-RA22" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 22BE3    |
   | lief   | 004      |
   | such   | BE3-RA22 |
And I append rows
   | artikel | mge |
   | TE009   |  0  |
And I set field "mge" to "3" in row 1
Then setting field "zrahmenpos" in row 1 to "pos^id" from editor "rahmen-EK-22" in row 1 throws the exception "1909"
And I set field "zrahmenpos" to "" in row 1
And I save the current editor

# LS 3 -> zrahmen/zrahmenpos: Dieser Rahmenauftrag ist ausgeschoepft.
Given I open an editor "LS3-EK-RA22" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "22BE3"
And I set fields
   | such    | LS3-RA22E |
   | vom     | .         |
   | ueb     | ja        |
And I set field "fixpwert" to "false" in row 1
And I set field "mge" to "1" in row 1
Then setting field "zrahmenpos" in row 1 to "pos^id" from editor "rahmen-EK-22" in row 1 throws the exception "1909"
And I close the current editor

# Rahmen eintragen, pruefen ob Meldung kommt
Given I open an editor "LS3-EK-RA22" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "22BE3"
And I set fields
   | such    | LS3-RA22E |
   | ueb     | ja        |
And I set field "fixpwert" to "false" in row 1
And I set field "mge" to "1" in row 1
# Keine passende Rahmenauftragsposition gefunden.
Then setting field "zrahmen" in row 1 to "id" from editor "rahmen-EK-22" in row 0 throws the exception "2438"
And I close the current editor

Given I open an editor "BE3-RA22" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "22BE3"
Then setting field "zrahmen" in row 1 to "id" from editor "rahmen-EK-22" in row 0 throws the exception "2438"
And I close the current editor

# Bestellvorschlag
And I open an editor "BE3_VOR_RA22" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | lief |
   | TE009   | 004  |
And I set field "mge" to "1" in row 1
# Maximale Rahmenmenge ist bereits komplett abgerufen.
Then setting field "zrahmen" in row 1 to "id" from editor "rahmen-EK-22" in row 0 throws the exception "2438"
Then setting field "zrahmenpos" in row 1 to "pos^id" from editor "rahmen-EK-22" in row 0 throws the exception "1909"
And I close the current editor

# Mindestbestand eintragen
# Bestellvorschlag zu Artikel TE009 mit der Dispo generieren
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "TE009"
And I set field "mindest" to "202"
And I save the current editor

And I run Scheduling

And I open an editor "BE4_VOR_RA22" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "TE009"
And I press button "ladetab"
Then field "zrahmen" has value "" in row 1
Then field "mge" has value "202" in row 1
Then setting field "zrahmen" in row 1 to "id" from editor "rahmen-EK-22" in row 0 throws the exception "2438"
Then setting field "zrahmenpos" in row 1 to "pos^id" from editor "rahmen-EK-22" in row 0 throws the exception "1909"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Abrufmenge gegen offene Rahmenauftragsmenge pruefen
#----------------------------------------------------------------------------------------------
# Rahmenauftrag anlegen, Vorgangsdatum leer lassen
Given I open an editor "rahmen-EK-23" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 23EKRA   |
   | lief    | 1        |
   | such    | RA-EK-23 |
   | vom     |          |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE011   | Stück |  50  | 87    | 100         |
And I save the current editor

# Bestellung aus Rahmenauftrag
Given I open an editor "BE-RA23" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-23"
And I set fields
   | nummer  | 23BE    |
   | such    | BE-RA23 |
Then setting field "mge" to "105" in row 1 throws the exception "1299"
And I set field "mge" to "60" in row 1
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-23" in row 1 has value "60"
Then field "fzahlgeliefert" from editor "rahmen-EK-23" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "rahmen-EK-23" in row 1 has value "-10"

# Lieferschein 23 buchen
Given I open an editor "LS-RA23" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE-RA23"
And I set fields
   | ebeleg  | 23EKLS  |
   | such    | LS-RA23 |
   | vom     | .       |
   | tterm   | .       |
   | ueb     | ja      |
Then setting field "mge" to "105" in row 1 throws the exception "1299"
And I set field "mge" to "25" in row 1
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen und LS
Then field "fzahlabgerufen" from editor "rahmen-EK-23" in row 1 has value "60"
Then field "fzahlgeliefert" from editor "rahmen-EK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-EK-23" in row 1 has value "-10"

# 2. Bestellung aus Rahmenauftrag
Given I open an editor "BE-RA23A" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-23"
And I set fields
   | nummer  | 23ABE     |
   | such    | BE-RA23A |
And I set field "mge" to "65" in row 1
Then saving the current editor throws the exception "1050"
And I set field "mge" to "15" in row 1
And I set field "beleg" to "23EKRA"
And I set field "mge" to "50" in row 2
Then saving the current editor throws the exception "1050"
And I set field "mge" to "5" in row 2
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen und LS
Then field "fzahlabgerufen" from editor "rahmen-EK-23" in row 1 has value "80"
Then field "fzahlgeliefert" from editor "rahmen-EK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-EK-23" in row 1 has value "-30"

# Lieferschein 23B
Given I open an editor "LS-RA23B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE-RA23"
And I set fields
   | ebeleg  | 23BEKLS  |
   | such    | LS-RA23B |
   | vom     | .        |
   | tterm   | .        |
And I set field "mge" to "76" in row 1
And I set field "ueb" to "ja"
# Pruefungen schlagen im LS nur zu wenn buchen = ja
Then saving the current editor throws the exception "10937"
And I set field "mge" to "20" in row 1
And I set field "beleg" to "23BE"
And I set field "mge" to "60" in row 2
Then saving the current editor throws the exception "10937"
And I set field "mge" to "5" in row 2
And I set field "ueb" to "nein"
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-23" in row 1 has value "80"
Then field "fzahlgeliefert" from editor "rahmen-EK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-EK-23" in row 1 has value "-30"

# Lieferschein 23B aendern
Given I open an editor "LS-RA23B" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS-RA23B"
And I set field "mge" to "56" in row 2
And I set field "ueb" to "ja"
# Pruefungen schlagen im LS nur zu wenn buchen = ja
Then saving the current editor throws the exception "10937"
And I set field "mge" to "10" in row 2
And I set field "ueb" to "nein"
And I delete row at position 2
And I set field "beleg" to "23BE"
And I set field "mge" to "60" in row 3
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "10937"
And I set field "mge" to "21" in row 3
And I set field "ueb" to "nein"
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-23" in row 1 has value "86"
Then field "fzahlgeliefert" from editor "rahmen-EK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-EK-23" in row 1 has value "-36"

# Rechnung mit Lagerbewegung 23
Given I open an editor "RE-RA23" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE-RA23"
And I set fields
   | ebeleg  | 23EKRE   |
   | such    | RE-RA23  |
   | vom     | .        |
   | tterm   | .        |
   | fakt    | ja       |
   | ueb     | nein     |
And I set field "mge" to "4" in row 1
And I set field "beleg" to "23BE"
And I set field "mge" to "1" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung mit Lagerbewegung aendern
Given I open an editor "RE-RA23" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE-RA23"
And I set field "mge" to "80" in row 1
And I set field "ueb" to "ja"
# Pruefungen schlagen im LS nur zu wenn buchen = ja
Then saving the current editor throws the exception "10937"
And I set field "mge" to "5" in row 1
And I set field "ueb" to "nein"
And I set field "mge" to "77" in row 2
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "10937"
And I set field "mge" to "5" in row 2
And I set field "ueb" to "nein"
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-23" in row 1 has value "96"
Then field "fzahlgeliefert" from editor "rahmen-EK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-EK-23" in row 1 has value "-46"

# Rechnung mit Lagerbewegung ohne Rahmenauftrag buchen
Given I open an editor "RE-RA23" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE-RA23"
And I set field "ueb" to "ja"
And I set field "mge" to "10" in row 1
And I set field "fixpwert" to "nein" in row 1
And I set field "zrahmenpos" to "" in row 1
And I delete row at position 2
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-23" in row 1 has value "86"
Then field "fzahlgeliefert" from editor "rahmen-EK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-EK-23" in row 1 has value "-36"

# Lieferschein aus Bestellung BE-RA23A anlegen
Given I open an editor "LS-RA23A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE-RA23A"
And I set fields
   | ebeleg  | 23AEKLS  |
   | such    | LS-RA23A |
   | vom     | .        |
   | tterm   | .        |
And I set field "mge" to "81" in row 1
And I set field "ueb" to "ja"
# Pruefungen schlagen im LS nur zu wenn buchen = ja
Then saving the current editor throws the exception "10937"
And I set field "mge" to "25" in row 1
And I set field "ueb" to "nein"
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-23" in row 1 has value "96"
Then field "fzahlgeliefert" from editor "rahmen-EK-23" in row 1 has value "25"
Then field "fzahlabrufoffen" from editor "rahmen-EK-23" in row 1 has value "-46"

#----------------------------------------------------------------------------------------------
Scenario: EK - Maximale Rahmenauftragsmenge pruefen - Plausibilitaeten
#----------------------------------------------------------------------------------------------
# Rahmenauftrag anlegen
Given I open an editor "rahmen-EK-24" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 24EKRA   |
   | lief    | 1        |
   | such    | RA-EK-24 |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE011   | Stück | 200  | 88    | 300         |
And I save the current editor

# Bestellung aus Rahmenauftrag
Given I open an editor "BE-RA24" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-24"
And I set fields
   | nummer  | 24BE    |
   | such    | BE-RA24 |
And I set field "mge" to "180" in row 1
And I set field "beleg" to "24EKRA"
And I set field "mge" to "130" in row 2
Then saving the current editor throws the exception "1050"
And I set field "mge" to "100" in row 2
And I save the current editor

# Pruefen fzahl und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-24" in row 1 has value "280"
Then field "fzahlgeliefert" from editor "rahmen-EK-24" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "rahmen-EK-24" in row 1 has value "-80"

# 1. Lieferschein aus Bestellung buchen
Given I open an editor "LS-RA24" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE-RA24"
And I set fields
   | ebeleg  | 24EKLS  |
   | such    | LS-RA24 |
   | vom     | .       |
   | tterm   | .       |
   | ueb     | ja      |
And I set field "mge" to "90" in row 2
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-24" in row 1 has value "280"
Then field "fzahlgeliefert" from editor "rahmen-EK-24" in row 1 has value "90"
Then field "fzahlabrufoffen" from editor "rahmen-EK-24" in row 1 has value "-80"

# 2. Lieferschein aus Bestellung
Given I open an editor "LS-RA24A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE-RA24"
And I set fields
   | ebeleg  | 24AEKLS  |
   | such    | LS-RA24A |
   | vom     | .        |
   | tterm   | .        |
And I set field "mge" to "211" in row 1
And I set field "ueb" to "ja"
# Pruefungen schlagen im LS nur zu wenn buchen = ja
Then saving the current editor throws the exception "10937"
And I set field "mge" to "201" in row 1
And I set field "mge" to "10" in row 2
Then saving the current editor throws the exception "10937"
And I set field "mge" to "9" in row 2
And I set field "ueb" to "nein"
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-24" in row 1 has value "301"
Then field "fzahlgeliefert" from editor "rahmen-EK-24" in row 1 has value "90"
Then field "fzahlabrufoffen" from editor "rahmen-EK-24" in row 1 has value "-101"

# Rahmenauftrag 24B1 anlegen
Given I open an editor "rahmen-EK-24B1" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 24B1EKRA  |
   | lief    | 1         |
   | such    | RA-EK24B1 |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE011   | Stück | 200  | 90    | 200         |
And I save the current editor

# Rahmenauftrag 24B2 anlegen,
Given I open an editor "rahmen-EK-24B2" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 24B2EKRA  |
   | lief    | 1         |
   | such    | RA-EK24B2 |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE011   | Stück | 120  | 91    | 120         |
And I save the current editor

# Bestellung aus Rahmenauftrag
Given I open an editor "BE-RA24B" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK24B1"
And I set fields
   | nummer  | 24BEB     |
   | such    | BE-RA24B  |
And I set field "mge" to "100" in row 1
And I set field "beleg" to "24B2EKRA"
Then setting field "mge" to "121" in row 3 throws the exception "1299"
And I set field "mge" to "60" in row 3
And I save the current editor

# Pruefen fzahl und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-24B1" in row 1 has value "100"
Then field "fzahlgeliefert" from editor "rahmen-EK-24B1" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "rahmen-EK-24B1" in row 1 has value "100"
Then field "fzahlabgerufen" from editor "rahmen-EK-24B2" in row 1 has value "60"
Then field "fzahlgeliefert" from editor "rahmen-EK-24B2" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "rahmen-EK-24B2" in row 1 has value "60"

# 1. Lieferschein aus Bestellung buchen
Given I open an editor "LS-RA24B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE-RA24B"
And I set fields
   | ebeleg  | 24BEKLS  |
   | such    | LS-RA24B |
   | vom     | .        |
   | tterm   | .        |
   | ueb     | ja       |
And I set field "mge" to "50" in row 1
And I set field "mge" to "30" in row 3
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-24B1" in row 1 has value "100"
Then field "fzahlgeliefert" from editor "rahmen-EK-24B1" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-EK-24B1" in row 1 has value "100"
Then field "fzahlabgerufen" from editor "rahmen-EK-24B2" in row 1 has value "60"
Then field "fzahlgeliefert" from editor "rahmen-EK-24B2" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-EK-24B2" in row 1 has value "60"

# 2. Lieferschein aus Bestellung
Given I open an editor "LS-RA24BB" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE-RA24B"
And I set fields
   | ebeleg  | 24BBEKLS  |
   | such    | LS-RA24BB |
   | vom     | .         |
   | tterm   | .         |
And I set field "fixpwert" to "nein" in row 1
And I set field "fixpwert" to "nein" in row 3
And I set field "mge" to "60" in row 3
And I set field "ueb" to "nein"
And I set field "mge" to "80" in row 1
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-24B1" in row 1 has value "130"
Then field "fzahlgeliefert" from editor "rahmen-EK-24B1" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-EK-24B1" in row 1 has value "70"
Then field "fzahlabgerufen" from editor "rahmen-EK-24B2" in row 1 has value "90"
Then field "fzahlgeliefert" from editor "rahmen-EK-24B2" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-EK-24B2" in row 1 has value "30"

# Weitere Bestellung erstellen
Given I open an editor "BE-RA24C" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 24CBE    |
   | lief    | 1        |
   | such    | BE-RA24C |
And I append rows
   | artikel | he    | mge  | preis |
   | TE011   | Stück |  50  | 21    |
And I set field "fixpwert" to "nein" in row 1
And I set field "zrahmenpos" to "pos^id" from editor "rahmen-EK-24B1" in row 1
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-24B1" in row 1 has value "180"
Then field "fzahlgeliefert" from editor "rahmen-EK-24B1" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-EK-24B1" in row 1 has value "20"
Then field "fzahlabgerufen" from editor "rahmen-EK-24B2" in row 1 has value "90"
Then field "fzahlgeliefert" from editor "rahmen-EK-24B2" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-EK-24B2" in row 1 has value "30"

# Bestellung aendern: Offene Menge fuer Rahmenauftrag 24B2 zu gering
Given I open an editor "BE-RA24C" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE-RA24C"
And I set field "fixpwert" to "nein" in row 1
Then setting field "zrahmenpos" in row 1 to "pos^id" from editor "rahmen-EK-24B2" in row 1 throws the exception "1299"
And I set field "mge" to "10" in row 1
And I set field "zrahmenpos" to "pos^id" from editor "rahmen-EK-24B2" in row 1
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-24B1" in row 1 has value "130"
Then field "fzahlgeliefert" from editor "rahmen-EK-24B1" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-EK-24B1" in row 1 has value "70"
Then field "fzahlabgerufen" from editor "rahmen-EK-24B2" in row 1 has value "100"
Then field "fzahlgeliefert" from editor "rahmen-EK-24B2" in row 1 has value "30"
Then field "fzahlabrufoffen" from editor "rahmen-EK-24B2" in row 1 has value "20"

# Bestellvorschlag gegen max. Rahmenmenge pruefen
Given I open an editor "rahmen2-EK-24" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 24RAEK2   |
   | lief    | 004       |
   | such    | RA2-EK-24 |
   | vom     | .         |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE009   | Stück | 202  | 77    | 202         |
And I save the current editor

And I open an editor "BE4_VOR_RA24" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "TE009"
And I press button "ladetab"
And I set field "zrahmen" to "24RAEK2" in row 1
Then field "mge" has value "202" in row 1
Then setting field "mge" to "203" in row 1 throws the exception "1299"
And I save the current editor

Given I open an editor "BE-RA24C" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 24DBE    |
   | lief    | 004      |
   | such    | BE-RA24D |
And I append rows
   | artikel | he    | mge  |
   | TE009   | Stück |  100 |
And I set field "zrahmenpos" to "pos^id" from editor "rahmen2-EK-24" in row 1
And I save the current editor

And I open an editor "BE4_VOR_RA24" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "TE009"
And I press button "ladetab"
And I set field "mge" to "100" in row 1
Then field "zrahmen" has value "24RAEK2" in row 1
And I set field "mge" to "150" in row 1
Then field "zrahmen" is empty in row 1
Then setting field "zrahmen" to "24RAEK2" in row 1 throws the exception "2438"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK -Gueltigkeitsbereiche pruefen - Plausibilitaeten
#----------------------------------------------------------------------------------------------
# 1. Rahmenauftrag 26A anlegen
Given I open an editor "rahmen-EK-26A" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 26AEKRA   |
   | lief    | 1         |
   | such    | RA-EK-26A |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge | zgltvon | zgltbis | lffert      | status |
   | TE009   | Stück |  100  | 18   | 200         |         |         | !dontChange |        |
   | TE010   | Stück |  200  | 48   | 300         |         | +100    | !dontChange |        |
   | TE009   | Stück |  100  | 19   | 200         |         |         | !dontChange |        |
   | TE009   | Stück |  50   | 21   | 0           |         |         | !dontChange |        |
   | TE010   | Stück |  120  | 51   | 0           |         |         | !dontChange |        |
   | TE010   | Stück |  200  | 49   | 0           |         |         | !dontChange |        |
   | LFERT001| Stück |  100  | 53   | 0           | +80     | +150    | TE010       |        |
   | LFERT001| Stück |  300  | 45   | 0           | +80     | +149    | !dontChange | S      |
Then saving the current editor throws the exception "6815"
And I set field "zgltvon" to "+101" in row 5
Then saving the current editor throws the exception "6815"
And I set field "zgltbis" to "+200" in row 5
And I set field "zgltvon" to "+201" in row 6
And I save the current editor

# 2. Rahmenauftrag 26B anlegen
Given I open an editor "rahmen-EK-26B" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 26BEKRA  |
   | lief    | 1        |
   | such    | RA-EK26B |
And I append rows
   | artikel | he    | mge  | preis |
   | TE009   | Stück |  100  | 19   |
   | TE010   | Stück |  200  | 52   |
   | TE010   | Stück |  100  | 53   |
   | TE010   | Stück |  200  | 54   |
And I save the current editor

# 2. Rahmenauftrag 26B aendern
Given I open an editor "rahmen-EK-26B" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA-EK26B"
And I set field "zgltvon" to "+3" in row 1
And I set field "zgltbis" to "+10" in row 2
And I set field "zgltvon" to "+500" in row 4
Then saving the current editor throws the exception "6815"
And I set field "zgltvon" to "+300" in row 3
And I set field "zgltbis" to "+350" in row 3
And I save the current editor

# 3. Rahmenauftrag 26C anlegen
Given I open an editor "rahmen-EK-26C" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 26CEKRA  |
   | lief    | 1        |
   | such    | RA-EK26C |
And I append rows
   | artikel | he    | mge  | preis | zgltvon | zgltbis |
   | TE011   | Stück |  50  | 21    |+50      | +69     |
   | TE011   | Stück |  120 | 51    |+60      | +99     |
Then saving the current editor throws the exception "6815"
And I set field "zgltvon" to "+70" in row 2
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Rahmenauftraege mit Gueltigkeitsbereich haben Vorrang
#----------------------------------------------------------------------------------------------
# 1. Rahmenauftrag 27A mit Gueltigkeit anlegen
Given I open an editor "rahmen-EK-27A" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 27AEKRA   |
   | lief    | 1         |
   | such    | RA-EK-27A |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge | zgltvon | zgltbis |
   | TE011  | Stück |  100  | 56    | 120         |         | +200    |
And I save the current editor

# 2. Rahmenauftrag 27B anlegen
Given I open an editor "rahmen-EK-27B" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 27BEKRA  |
   | lief    | 1        |
   | such    | RA-EK27B |
And I append rows
   | artikel | he    | mge  | preis |
   | TE011   | Stück |  100  | 63   |
And I save the current editor

# Bestellung erstellen
Given I open an editor "BE-RA27A" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 27ABE    |
   | lief    | 1        |
   | such    | BE-RA27A |
And I append rows
   | artikel | he    | mge  |
   | TE011   | Stück |  80  |
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-27A" in row 1 has value "80"
Then field "fzahlabrufoffen" from editor "rahmen-EK-27A" in row 1 has value "20"
Then field "fzahlabgerufen" from editor "rahmen-EK-27B" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "rahmen-EK-27B" in row 1 has value "100"

# 3. Rahmenauftrag 27C mit Gueltigkeitsbereich anlegen
Given I open an editor "rahmen-EK-27C" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 27CEKRA  |
   | lief    | 1        |
   | such    | RA-EK27C |
And I append rows
   | artikel | he    | mge  | preis | zgltvon | zgltbis |
   | TE011   | Stück | 100  | 58    | .       | +50     |
And I save the current editor

# 4. Rahmenauftrag 27D mit unpassendem Gueltigkeitsbereich anlegen
Given I open an editor "rahmen-EK-27D" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 27DEKRA  |
   | lief    | 1        |
   | such    | RA-EK27D |
And I append rows
   | artikel | he    | mge  | preis | zgltvon | zgltbis |
   | TE011   | Stück | 200  | 66    | +200    | +350     |
And I save the current editor

# 5. Rahmenauftrag 27E ohne Gueltigkeitsbereich anlegen
Given I open an editor "rahmen-EK-27E" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 27EEKRA  |
   | lief    | 1        |
   | such    | RA-EK27E |
And I append rows
   | artikel | he    | mge  | preis |
   | TE011   | Stück | 200  | 69    |
And I save the current editor

# Weitere Bestellung erstellen
Given I open an editor "BE-RA27B" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 27BBE    |
   | lief    | 1        |
   | such    | BE-RA27B |
And I append rows
   | artikel | he    | mge  |
   | TE011   | Stück |  50  |
And I save the current editor

# Pruefen fzahlabgerufen und fzahlgeliefert im Rahmen
Then field "fzahlabgerufen" from editor "rahmen-EK-27A" in row 1 has value "80"
Then field "fzahlabrufoffen" from editor "rahmen-EK-27A" in row 1 has value "20"
Then field "fzahlabgerufen" from editor "rahmen-EK-27B" in row 1 has value "0"
Then field "fzahlabrufoffen" from editor "rahmen-EK-27B" in row 1 has value "100"
Then field "fzahlabgerufen" from editor "rahmen-EK-27C" in row 1 has value "50"
Then field "fzahlabrufoffen" from editor "rahmen-EK-27C" in row 1 has value "50"

#Fall 1
#----------------------------------------------------------------------------------------------
Scenario: EK - Rahmenauftrag mit einer Position mit Gueltigkeitsbereich anlegen
#----------------------------------------------------------------------------------------------
Given I open an editor "rahmen-EK-27F1A" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "REUS"
And I set field "such" to "RAEK27F1A"
And I create a new row at the end of the table
And I set field "artikel" to "TE013" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "5555" in row 1
And I set field "zgltvon" to "." in row 1
#And I set field "zgltbis" to "31.12." in row 1
And I save the current editor

# Rahmenauftrag mit einer Positionen ohne Gueltigkeitsbereich anlegen
Given I open an editor "rahmen-EK-271B" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "REUS"
And I set field "such" to "RAEK27F1B"
And I create a new row at the end of the table
And I set field "artikel" to "TE013" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "4444" in row 1
And I save the current editor

#Bestellung anlegen
Given I open an editor "BE-RA27F1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "REUS"
And I set field "such" to "BE-RA27F1"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "TE013" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor
Then field "preis" has value "5555.00" in row 1

#Fall 2
#Rahmenauftrag mit einer Position mit Gueltigkeitsbereich anlegen
Given I open an editor "rahmen-EK-27F2A" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "REUS"
And I set field "such" to "RAEK27F2A"
And I create a new row at the end of the table
And I set field "artikel" to "TE014" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "3333" in row 1
And I set field "zgltvon" to "." in row 1
And I set field "zgltbis" to "31.12." in row 1
And I save the current editor

#Rahmenauftrag mit einer Position mit Gueltigkeitsbereich anlegen
Given I open an editor "rahmen-EK-27F2B" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "REUS"
And I set field "such" to "RAEK27F2B"
And I create a new row at the end of the table
And I set field "artikel" to "TE014" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "2222" in row 1
And I set field "zgltvon" to "." in row 1
And I set field "zgltbis" to "31.03." in row 1
And I save the current editor

#Bestellung anlegen
Given I open an editor "BE-RA27F2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "REUS"
And I set field "such" to "BE-RA27F2"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "TE014" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor
Then field "preis" has value "2222.00" in row 1

#Aendern des Stichtags fuer die Preisfindung in Bestellposition
Given I open an editor "BE-RA27F2" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE-RA27F2"
And I set field "konddat" to "15.8." in row 1
And I set field "fixpwert" to "Nein" in row 1
Then field "preis" has value "3333.00" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Rahmenauftrag Maxwert ueberschreiten erlauben in LS und RE mit LB
#----------------------------------------------------------------------------------------------
# Weiteren Artikel anlegen
Given I open an editor "TE029" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
| such     | TE029            |
| namebspr | Teil029EK        |
| epr      | 12               |
| bsart    | Fremdbeschaffung |
| dispoa   | auftragsbezogen  |
And I save the current editor

# Rahmenauftrag 29 mit max Menge 200 anlegen
Given I open an editor "RA-EK29" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001       |
| such   | RA-EK29   |
And I append rows
| artikel | he    | mge  | preis | maxabrufmge |
| !TE029  | Stück |  10  | 11    | 200         |
And I save the current editor

# Rahmenauftrag fast aufbrauchen
Given I open an editor "RE-29" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
| lief    | 001   |
| such    | RE-29 |
| ebeleg  | RE-29 |
| fakt    | ja    |
| ueb     | ja    |
| vom     | .     |
| tterm   | .     |
| budat   | .     |
And I append rows
| artikel | he    | mge  |
| !TE029  | Stück |  190 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "fzahl" from editor "RA-EK29" in row 1 has value "190"

# Bestellung anlegen - Ueberschreiten der Maxmenge fuehrt zur Fehlermeldung
Given I open an editor "BE-29" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001   |
| such   | BE-29 |
| ebeleg | BE-29 |
| tterm  | .     |
| budat  | .     |
And I append rows
| artikel | he    | mge |
| !TE029  | Stück |  8  |
Then field "zrahmen" is not empty in row 1
And I set field "mge" to "11" in row 1
# Menge ueberschreitet die maximale Rahmenmenge
Then field "zrahmen" is empty in row 1
And I set field "mge" to "8" in row 1
Then field "zrahmen" is not empty in row 1
And I save the current editor

# LS anlegen - Ueberschreiten der Maxmenge fuehrt lediglich zu Hinweis, wenn buchen = nein
Given I open an editor "LS-29" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
| lief   | 001   |
| such   | LS-29 |
| ebeleg | LS-29 |
| vom    | .     |
| tterm  | .     |
And I create a new row at the end of the table
And I set field "artikel" to "!TE029" in row 1
# Preisfindung findet einen Rahmenauftrag.
And I set field "mge" to "2" in row 1
And I save the current editor

Given I open an editor "LS-29U" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS-29"
And I set field "ueb" to "ja"
Then setting field "mge" to "20" in row 1 throws the exception "1299"
And I set field "ueb" to "nein"
And I set field "mge" to "20" in row 1
# Beim LS darf Menge ueberschritten werden, wenn nicht gebucht - auch gespeichert - lediglich Hinweis
And I save the current editor

# Ob LS gebucht oder ungebucht ist, spielt keine Rolle: es wird immer gegen die max. Rahmenmenge geprueft
Given I open an editor "LS-29U" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS-29"
And I set fields
| ueb     | ja    |
# Beim LS darf Menge nicht ueberschritten werden, wenn buchen = ja
# Abrufmenge zu hoch
Then saving the current editor throws the exception "10937"
# Menge auf gueltigen Wert setzen
And I set field "mge" to "2" in row 1
And I save the current editor

# Das Gleiche mit RE + LB
# LS stornieren
Given I open an editor "LS-29STORNO" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS-29"
And I save the current editor

Then field "fzahl" from editor "RA-EK29" in row 1 has value "190"

# RE + LB anlegen - Ueberschreiten der Maxmenge fuehrt lediglich zu Hinweis, wenn buchen = nein
Given I open an editor "RE-29B" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
| lief   | 001    |
| such   | RE-29B |
| ebeleg | RE-29B |
| vom    | .      |
| tterm  | .      |
| budat  | .      |
And I create a new row at the end of the table
And I set field "artikel" to "!TE029" in row 1
# Preisfindung findet einen Rahmenauftrag.
And I set field "mge" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE-29U" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE-29B"
And I set field "ueb" to "ja"
Then setting field "mge" to "20" in row 1 throws the exception "1299"
And I set field "ueb" to "nein"
And I set field "mge" to "20" in row 1
# Bei RE + LB darf Menge ueberschritten werden, wenn nicht gebucht - auch gespeichert - lediglich Hinweis
And I save the current editor

# Ob RE gebucht oder ungebucht ist, spielt keine Rolle: es wird immer gegen die max. Rahmenmenge geprueft
# Aendern RE mit LB und buchen=ja -> Fehlermeldung
Given I open an editor "RE-29U" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE-29B"
And I set fields
| ueb     | ja    |
# Beim RE+LB darf Menge nicht ueberschritten werden, wenn buchen = ja
# Abrufmenge zu hoch
Then saving the current editor throws the exception "10937"
# Menge auf gueltigen Wert setzen
And I set field "mge" to "2" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Vorbelegung Gueltigkeit im Rahmenauftrag
#----------------------------------------------------------------------------------------------
Given I open an editor "RA-EK30" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 001      |
   | such    | RA-EK30  |
   | gltvon  | 03.01.95 |
   | gltbis  | 03.05.95 |
And I append rows
   | artikel    | mge         | preis       |
   | ARTIKELPOS | 300         | 30          |
   | TEXT       | !dontChange | !dontChange |
   | AUBEPOS    | 300         | 30          |
   | DLPOS      | 300         | 30          |
Then table has values
   | zgltvon  | zgltbis  |
   | 03.01.95 | 03.05.95 |
   | 03.01.95 | 03.05.95 |
   | 03.01.95 | 03.05.95 |
   | 03.01.95 | 03.05.95 |
And I set field "gltvon" to "04.01.95"
And I set field "gltbis" to "04.05.95"
And I set field "artikel" to "ARTIKELPOS" in row 1
And I set field "artikel" to "TEXT" in row 2
And I set field "artikel" to "AUBEPOS" in row 3
And I set field "artikel" to "DLPOS" in row 4
Then table has values
   | zgltvon  | zgltbis  |
   | 03.01.95 | 03.05.95 |
   | 03.01.95 | 03.05.95 |
   | 03.01.95 | 03.05.95 |
   | 03.01.95 | 03.05.95 |
And I set field "zgltvon" to "" in row 1
And I set field "zgltvon" to "" in row 2
And I set field "zgltvon" to "" in row 3
And I set field "zgltvon" to "" in row 4
And I set field "artikel" to "ARTIKELPOS" in row 1
And I set field "artikel" to "TEXT" in row 2
And I set field "artikel" to "AUBEPOS" in row 3
And I set field "artikel" to "DLPOS" in row 4
Then table has values
   | zgltvon  | zgltbis  |
   |          | 03.05.95 |
   |          | 03.05.95 |
   |          | 03.05.95 |
   |          | 03.05.95 |
And I set field "zgltbis" to "" in row 1
And I set field "zgltbis" to "" in row 2
And I set field "zgltbis" to "" in row 3
And I set field "zgltbis" to "" in row 4
And I set field "artikel" to "ARTIKELPOS" in row 1
And I set field "artikel" to "TEXT" in row 2
And I set field "artikel" to "AUBEPOS" in row 3
And I set field "artikel" to "DLPOS" in row 4
Then table has values
   | zgltvon  | zgltbis  |
   | 04.01.95 | 04.05.95 |
   | 04.01.95 | 04.05.95 |
   | 04.01.95 | 04.05.95 |
   | 04.01.95 | 04.05.95 |
And I save the current editor

Given I open an editor "RA-EK30" from table "(Purchasing):(BlanketOrder)" with command "COPY" for record "RA-EK30"
Then field "gltvon" has value ""
Then field "gltbis" has value ""
Then table has values
   | zgltvon  | zgltbis  |
   |          |          |
   |          |          |
   |          |          |
   |          |          |
And I close the current editor

Given I set the fake date to "07.01.1995"
Given I open an editor "RA-EK30" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK30"
Then field "gltvon" has value ""
Then field "gltbis" has value ""
Then table has values
   | zgltvon  | zgltbis  |
   |          |          |
   |          |          |
   |          |          |
   |          |          |
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Rahmenauftrag mit sofortiger Abrufmenge - Uebernahme der Werte bei Rahmeneingabe
#----------------------------------------------------------------------------------------------
# Weiteren Artikel anlegen
Given I open an editor "TE031" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
| such     | TE031            |
| namebspr | Teil031          |
| vpr      | 12               |
| bsart    | Fremdbeschaffung |
| dispoa   | auftragsbezogen  |
| bfrist   | 3                |
And I save the current editor

# Rahmenauftrag 31 mit max Menge 50 anlegen
Given I open an editor "RA-VK31" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| kunde   | 001      |
| such    | RA-VK31  |
And I append rows
| artikel | he    | mge  | preis |
| !TE031  | Stück |  500 | 8     |
And I save the current editor

# Rahmenauftrag 31B mit max Menge 100 anlegen
Given I open an editor "RA-VK31B" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| kunde  | 001      |
| such   | RA-VK31B |
And I append rows
| artikel | he    | mge | preis | verfuegbmge | lzeit | lfristkurz |
| !TE031  | Stück | 100 | 10    | 50          | 10    | 5          |
Then setting field "lfristkurz" to "11" in row 1 throws the exception "1913"
Then setting field "lzeit" to "4" in row 1 throws the exception "1913"
And I save the current editor

Given I open an editor "RA-VK31B" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record from editor "RA-VK31B"
And I set field "lfristkurz" to "8" in row 1
And I set field "verfuegbmge" to "0" in row 1
Then setting field "lfristkurz" to "3" in row 1 throws the exception "203"
And I close the current editor

# Rahmenauftrag 31 mit max Menge 200 anlegen
Given I open an editor "RA-VK31C" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| kunde  | 001       |
| such   | RA-VK31C  |
And I append rows
| artikel | he    | mge | preis | verfuegbmge | lzeit | lfristkurz |
| !TE031  | Stück |  10 | 11    | 100         | 20    | 10         |
And I save the current editor

# Auftrag anlegen
Given I open an editor "AU-31" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
| kunde  | 001   |
| such   | AU-31 |
| tterm  | .     |
| budat  | .     |
And I append rows
| artikel | he    | mge |
| !TE031  | Stück |  8  |
Then field "zrahmen" in row 1 has value equal to field "nummer" from editor "RA-VK31C" in row 1
Then field "verfuegbmge" has value "100" in row 1
Then field "lfristkurz" has value "10" in row 1
Then setting field "lfristkurz" to "9" in row 1 throws the exception "203"
Then field "lzeit" has value "20" in row 1
And I save the current editor

# Auftrag aendern, Aenderungen verwerfen
Given I open an editor "AU-31U" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-31"
# zrahmen vorhanden -> lfristkurz und verfuegbmge sind schreibgeschuetzt
Then setting field "verfuegbmge" to "10" in row 1 throws the exception "203"
Then setting field "lfristkurz" to "2" in row 1 throws the exception "203"
And I set field "zrahmen" to "" in row 1
Then field "verfuegbmge" has value "0" in row 1
Then setting field "verfuegbmge" to "10" in row 1 throws the exception "203"
Then setting field "lfristkurz" to "2" in row 1 throws the exception "203"
And I close the current editor

# Auftrag aendern des Rahmenauftrages
Given I open an editor "AU-31U" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU-31"
And I set field "zrahmen" to id from editor "RA-VK31B" in row 1
Then field "zrahmen" in row 1 has value equal to field "nummer" from editor "RA-VK31B" in row 1
# Neue Werte aus dem Rahmen uebernehmen
Then field "verfuegbmge" has value "50" in row 1
Then field "lfristkurz" has value "5" in row 1
Then field "lzeit" has value "10" in row 1
Then setting field "verfuegbmge" to "49" in row 1 throws the exception "203"
And I set field "zrahmen" to "" in row 1
# Werte werden zurueckgesetzt
Then field "verfuegbmge" has value "0" in row 1
Then field "lfristkurz" has value "0" in row 1
Then field "lzeit" has value "3" in row 1
# Nullwerte aus Rahmen nicht ignorieren
And I set field "zrahmen" to id from editor "RA-VK31" in row 1
Then field "verfuegbmge" has value "0" in row 1
Then field "lfristkurz" has value "0" in row 1
Then field "lzeit" has value "3" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Rahmenauftrag mit sofortiger Abrufmenge - Uebernahme der Werte bei Rahmeneingabe
#----------------------------------------------------------------------------------------------
# Rahmenauftrag 31 mit max Menge 50 anlegen
Given I open an editor "RA-EK31" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001      |
| such   | RA-EK31  |
| ebeleg | RA-EK31  |
And I append rows
| artikel | he    | mge  | preis |
| !TE031  | Stück |  500 | 8     |
And I save the current editor

# Rahmenauftrag 31B mit max Menge 100 anlegen
Given I open an editor "RA-EK31B" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001      |
| such   | RA-EK31B |
| ebeleg | RA-EK31B |
And I append rows
| artikel | he    | mge | preis | verfuegbmge | lzeit | lfristkurz |
| !TE031  | Stück | 100 | 10    | 50          | 10    | 5          |
And I save the current editor

# Rahmenauftrag 31 mit max Menge 200 anlegen
Given I open an editor "RA-EK31C" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001       |
| such   | RA-EK31C  |
| ebeleg | RA-EK31C  |
And I append rows
| artikel | he    | mge  | preis | verfuegbmge | lzeit | lfristkurz |
| !TE031  | Stück |  10  | 11    | 100         | 20    | 10         |
And I save the current editor

# Bestellung anlegen
Given I open an editor "BE-31" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001   |
| such   | BE-31 |
| ebeleg | BE-31 |
| tterm  | .     |
| budat  | .     |
And I append rows
| artikel | he    | mge |
| !TE031  | Stück |  8  |
Then field "zrahmen" in row 1 has value equal to field "nummer" from editor "RA-EK31C" in row 1
Then field "verfuegbmge" has value "100" in row 1
Then field "lfristkurz" has value "10" in row 1
Then field "lzeit" has value "20" in row 1
And I save the current editor

# Bestellung aendern des Rahmenauftrages
Given I open an editor "BE-31U" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE-31"
Then field "lzeit" has value "20" in row 1
And I set field "zrahmen" to id from editor "RA-EK31B" in row 1
Then field "zrahmen" in row 1 has value equal to field "nummer" from editor "RA-EK31B" in row 1
# zrahmen vorhanden -> lfristkurz und verfuegbmge sind schreibgeschuetzt
Then setting field "verfuegbmge" to "50" in row 1 throws the exception "203"
Then setting field "lfristkurz" to "5" in row 1 throws the exception "203"
# Neue Werte aus dem Rahmen uebernehmen
Then field "verfuegbmge" has value "50" in row 1
# lfristkurz wird nur im Neumodus neu uebernommen
Then field "lfristkurz" has value "5" in row 1
Then field "lzeit" has value "10" in row 1
# Rahmenauftrag rausloeschen
And I set field "zrahmen" to "" in row 1
# lzeit beim Loeschen wieder aus Artikel holen.
# Ist dieses leer, dann bfrist nehmen.
Then field "lzeit" has value "3" in row 1
Then field "verfuegbmge" has value "0" in row 1
Then field "lfristkurz" has value "0" in row 1
# Nullwerte aus Rahmen ignorieren
And I set field "zrahmen" to id from editor "RA-EK31" in row 1
Then field "verfuegbmge" has value "0" in row 1
Then field "lfristkurz" has value "0" in row 1
Then field "lzeit" has value "0" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - BV Rahmenauftrag mit sofortiger Abrufmenge - Uebernahme der Werte bei Rahmeneingabe
#----------------------------------------------------------------------------------------------
# Weiteren Artikel anlegen
Given I open an editor "TE032" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
| such     | TE032            |
| namebspr | Teil032          |
| vpr      | 12               |
| bsart    | Fremdbeschaffung |
| dispoa   | auftragsbezogen  |
| lief     | 001              |
| bfrist   | 7                |
| vorlauf  | 5                |
And I save the current editor

# Rahmenauftrag 32 mit max Menge 100 anlegen
Given I open an editor "RA-EK32" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001      |
| such   | RA-EK32  |
| ebeleg | RA-EK32  |
And I append rows
| artikel | he    | mge | preis | verfuegbmge | lzeit | lfristkurz | vorlauf |
| !TE032  | Stück | 200 | 6     | 70          | 3     | 2          | 3       |
And I save the current editor

# VK Auftrag mit Verwendung AU-32 anlegen
Given I open an editor "AU-32" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
| kunde  | 1     |
| such   | AU-32 |
| tterm  | .     |
| budat  | .     |
And I append rows
| artikel | he    | mge | verw  |
| !TE032  | Stück |  8  | AU-32 |
Then field "zrahmen" has value "" in row 1
Then field "fzahlabrufoffenicon" has value "" in row 1
And I save the current editor

# Dispo starten
And I run Scheduling

# Angelegter BV pruefen auf vorbelegte Werte aus dem Rahmen, dann zrahmen herausloeschen
Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to id from editor "TE032"
And I press button "ladetab"
Then the table has 1 rows
Then field "verw" has value "AU-32" in row 1
Then field "zrahmen" in row 1 has value equal to field "nummer" from editor "RA-EK32" in row 1
Then field "verfuegbmge" has value "70" in row 1
Then field "lfristkurz" has value "2" in row 1
Then field "lzeit" has value "3" in row 1
# Im Bestellvorschlag wird die Vorlaufzeit aus dem Artikelstamm anstatt der Rahmenauftragsposition genommen
Then field "vorlauf" has value "5" in row 1
And I set field "zrahmen" to "" in row 1
And I set field "fix" to "ja" in row 1
# Werte rausloeschen
Then field "verfuegbmge" has value "0" in row 1
Then field "lfristkurz" has value "0" in row 1
# lzeit beim Loeschen wieder aus Artikel holen
Then field "lzeit" has value "0" in row 1
# Freigeben -> Kein Rahmen in Bestellung
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BE32"
And I set field "zignrahmen" to "ja" in row 1
Then field "verfuegbmge" has value "0" in row 1
Then field "lfristkurz" has value "0" in row 1
Then field "lzeit" has value "0" in row 1
And I close the current editor
And I switch the current editor to editor "BV"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - LFV Rahmenauftrag mit sofortiger Abrufmenge - Uebernahme der Werte bei Rahmeneingabe
#----------------------------------------------------------------------------------------------
# Weiteren Artikel anlegen
Given I open an editor "LF033" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
| such      | LF033            |
| namebspr  | Lohnfertigung033 |
| epr       | 6                |
| bsart     | Lohnfertigung    |
| efrist    | 5                |
| lief      | 001              |
| bfrist    | 4                |
And I save the current editor

# Rahmenauftrag 33 mit max Menge 100 anlegen
Given I open an editor "RA-EK33" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001      |
| such   | RA-EK33  |
| ebeleg | RA-EK33  |
And I append rows
| artikel | he    | mge  | preis | verfuegbmge | lfristkurz | lzeit |
| !LF033  | Stück |  200 | 5     | 70          | 2          | 3     |
And I save the current editor

Given I open an editor "RA-EK33" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record from editor "RA-EK33"
And I set field "lfristkurz" to "2" in row 1
And I set field "verfuegbmge" to "0" in row 1
Then setting field "lfristkurz" to "3" in row 1 throws the exception "203"
And I close the current editor

# VK Auftrag mit Verwendung AU-33 anlegen
Given I open an editor "AU-33" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
| kunde  | 1     |
| such   | AU-33 |
| tterm  | .     |
| budat  | .     |
And I append rows
| artikel | he    | mge | verw  |
| !LF033  | Stück |  8  | AU-33 |
Then field "zrahmen" has value "" in row 1
And I save the current editor

# Dispo starten
And I run Scheduling

# Angelegter LFV pruefen auf vorbelegte Werte aus dem Rahmen, dann zrahmen herausloeschen
Given I open an editor "LFV" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to id from editor "LF033"
And I press button "ladetab"
Then the table has 1 rows
Then field "zrahmen" in row 1 has value equal to field "nummer" from editor "RA-EK33" in row 1
Then field "verfuegbmge" has value "70" in row 1
Then field "lfristkurz" has value "2" in row 1
Then field "lzeit" has value "3" in row 1
Then setting field "lfristkurz" to "2" in row 1 throws the exception "203"
Then setting field "verfuegbmge" to "69" in row 1 throws the exception "203"
Then setting field "lzeit" to "0" in row 1 throws the exception "3866"
Then field "mge" has value "8" in row 1
Then field "trterm" has value "09.01.95" in row 1
# Termine puefen
# Menge gross        -> Lieferzeit lang
And I set field "mge" to "100" in row 1
Then field "tterm" has value "09.01.95" in row 1
Then field "tsterm" has value "03.01.95" in row 1
# Menge klein        -> Lieferzeit kurz
And I set field "rterm" to "" in row 1
And I set field "mge" to "10" in row 1
Then field "tterm" has value "09.01.95" in row 1
Then field "tsterm" has value "03.01.95" in row 1
# Bedarfstermin spaet  -> Lieferzeit lang
And I set field "rterm" to "02.02.95" in row 1
And I set field "mge" to "50" in row 1
Then field "tterm" has value "02.02.95" in row 1
Then field "tsterm" has value "30.01.95" in row 1
# Bedarfstermin frueh -> Lieferzeit kurz
And I set field "rterm" to "08.01.95" in row 1
And I set field "mge" to "50" in row 1
Then field "tterm" has value "05.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
#
And I set field "zrahmen" to "" in row 1
And I set field "fix" to "ja" in row 1
# Werte rausloeschen
Then field "verfuegbmge" has value "0" in row 1
Then field "lfristkurz" has value "0" in row 1
# lzeit beim Loeschen wieder aus Artikel holen
Then field "lzeit" has value "5" in row 1
# Freigeben -> Kein Rahmen in Bestellung
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BE33"
And I set field "zignrahmen" to "ja" in row 1
Then field "verfuegbmge" has value "0" in row 1
Then field "lfristkurz" has value "0" in row 1
Then field "lzeit" has value "5" in row 1
And I close the current editor
And I switch the current editor to editor "LFV"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Maximale Rahmenauftragsmenge bei unterschiedlichen Einheiten in den Vorgaengen pruefen
#----------------------------------------------------------------------------------------------
# Rahmenauftrag anlegen
Given I open an editor "rahmen-EK-34" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 34RA     |
   | lief    | 1        |
   | such    | RA-EK-34 |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE018   | Stück | 100  | 15    | 100         |
And I save the current editor

# Bestellung aus Rahmenauftrag
Given I open an editor "BE-RA34" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK-34"
And I set fields
   | nummer  | 34BE    |
   | such    | BE-RA34 |
   | ebeleg  | BE-RA34 |
   | tterm   | .       |
   | budat   | .       |
And I set field "mge" to "40" in row 1
And I set field "he" to "kg" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-34" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-EK-34" in row 1 has value "80"
Then field "fzahlabrufoffen" from editor "rahmen-EK-34" in row 1 has value "20"

# Einheit in Rahmenauftrag nach Abruf nicht aenderbar
Given I open an editor "RA-EK-34" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA-EK-34"
Then setting field "he" to "Paar" in row 1 throws the exception "203"
And I close the current editor

# Lieferschein aus Bestellung (ungebucht)
Given I open an editor "LS-RA34" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "34BE"
And I set fields
   | such    | LS-RA34 |
   | ebeleg  | LS-RA34 |
   | ueb     | nein    |
   | vom     | .       |
   | tterm   | .       |
And I set field "mge" to "45" in row 1
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-34" in row 1 has value "0"
Then field "fzahlabgerufen" from editor "rahmen-EK-34" in row 1 has value "90"
Then field "fzahlabrufoffen" from editor "rahmen-EK-34" in row 1 has value "10"

# Lieferschein buchen
Given I open an editor "LS-RA34" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS-RA34"
And I set fields
   | ueb     | ja     |
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-34" in row 1 has value "90"
Then field "fzahlabgerufen" from editor "rahmen-EK-34" in row 1 has value "90"
Then field "fzahlabrufoffen" from editor "rahmen-EK-34" in row 1 has value "10"

# 2. Bestellung, Rahmenauftrag kommt aus Preisfindung
Given I open an editor "BE2-RA34" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 34BE2    |
   | lief    | 1        |
   | such    | BE2-RA34 |
   | ebeleg  | BE2-RA34 |
And I append rows
   | artikel | he     | mge  |
   | TE018   | kg     | 10   |
# Rahmen darf nicht gezogen werden
Then field "zrahmen" is empty in row 1
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "34RA" in row 1
And I save the current editor

Given I open an editor "BE2-RA34" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE2-RA34"
Then setting field "mge" to "10" in row 1 throws the exception "1299"
And I set field "he" to "Stück" in row 1
And I set field "mge" to "5" in row 1
And I set field "he" to "kg" in row 1
Then setting field "lehe" to "3" in row 1 throws the exception "1299"
And I set field "lehe" to "1.1" in row 1
And I set field "mge" to "9" in row 1
Then setting field "mge" to "11" in row 1 throws the exception "1299"
And I save the current editor

Then field "fzahlgeliefert" from editor "rahmen-EK-34" in row 1 has value "90"
Then field "fzahlabgerufen" from editor "rahmen-EK-34" in row 1 has value "99.9"
Then field "fzahlabrufoffen" from editor "rahmen-EK-34" in row 1 has value "0.1"

#----------------------------------------------------------------------------------------------
Scenario: EK - Nur relevante Positionen bei Rahmenauftragsfreigabe uebernehmen
#----------------------------------------------------------------------------------------------
Given I open an editor "RA-EK35" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 001      |
   | such    | RA-EK35  |
   | gltvon  | 03.01.95 |
   | gltbis  | 03.02.95 |
And I append rows
   | artikel    | mge         | preis       | maxabrufmge |
   | ARTIKELPOS | 350         | 30          | 400         |
   | TEXT       | !dontChange | !dontChange | !dontChange |
   | AUBEPOS    | 350         | 30          | 400         |
   | DLPOS      | 350         | 30          | 400         |
And I set field "zgltvon" to "" in row 2
And I set field "zgltbis" to "" in row 2
And I save the current editor

Given I set the fake date to "02.01.1995"
Given I open an editor "RA-EK35" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK35"
Then the table has 1 rows
Then table has values
   | artikel    |
   | TEXT       |
And I close the current editor

Given I set the fake date to "02.03.1995"
Given I open an editor "RA-EK35" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK35"
Then the table has 1 rows
Then table has values
   | artikel    |
   | TEXT       |
And I close the current editor

Given I set the fake date to "07.01.1995"
Given I open an editor "RA-EK35" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK35"
Then table has values
   | artikel    |
   | ARTIKELPOS |
   | TEXT       |
   | AUBEPOS    |
   | DLPOS      |
And I close the current editor

Given I open an editor "RA-EK35" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA-EK35"
And I set field "status" to "*" in row 1
And I set field "status" to "*" in row 2
And I set field "zgltvon" to "03.01.95" in row 2
And I set field "zgltbis" to "03.02.95" in row 2
And I save the current editor

Given I open an editor "RA-EK35" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK35"
Then the table has 2 rows
Then table has values
   | artikel    |
   | AUBEPOS    |
   | DLPOS      |
And I close the current editor

Given I open an editor "RA-EK35" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA-EK35"
And I set field "status" to "" in row 1
And I set field "status" to "" in row 2
And I save the current editor

Given I open an editor "RA-EK35" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK35"
And I set fields
   | such    | BE-EK35  |
And I set field "mge" to "200" in row 1
And I set field "mge" to "200" in row 3
And I set field "mge" to "200" in row 4
And I save the current editor

Given I open an editor "RA-EK35" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK35"
Then table has values
   | artikel    |
   | ARTIKELPOS |
   | TEXT       |
   | AUBEPOS    |
   | DLPOS      |
And I set fields
   | such    | BE2-EK35  |
And I set field "mge" to "200" in row 1
And I set field "mge" to "200" in row 3
And I set field "mge" to "200" in row 4
And I save the current editor

Given I open an editor "RA-EK35" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA-EK35"
Then the table has 1 rows
Then table has values
   | artikel    |
   | TEXT       |
And I close the current editor

Given I open an editor "RA-EK35" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA-EK35"
And I set field "maxabrufmge" to "500" in row 1
And I set field "maxabrufmge" to "500" in row 3
And I set field "maxabrufmge" to "500" in row 4
And I save the current editor

Given I open an editor "BE3-EK35" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief | 001      |
   | vom  | 03.03.95 |
And I set field "beleg" to "RA-EK35"
Then the table has 0 rows
And I set field "vom" to "03.02.95"
And I set field "beleg" to "RA-EK35"
Then table has values
   | artikel    |
   | ARTIKELPOS |
   | TEXT       |
   | AUBEPOS    |
   | DLPOS      |
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Liefertermin in Abhaengigkeit der Menge bestimmen
#----------------------------------------------------------------------------------------------
Given I open an editor "rahmen-EK-36A" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 36ARAEK   |
   | lief    | 004       |
   | such    | RA-EK-36A |
   | vom     | .         |
And I append rows
   | artikel | he     | mge  | preis | verfuegbmge | lzeit | lfristkurz |
   | TE009   | Stück  | 300  | 67    | 15          | 5     | 1          |
And I save the current editor

Given I open an editor "rahmen-EK-36B" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 36BRAEK   |
   | lief    | 004       |
   | such    | RA-EK-36B |
   | vom     | .         |
And I append rows
   | artikel | he     | mge  | preis | verfuegbmge | lzeit | lfristkurz |
   | TE009   | Stück  | 300  | 78    | 15          | 20    | 10         |
And I save the current editor

# Bestellung 1
Given I open an editor "BE1-RA36" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 36BE1    |
   | lief   | 004      |
   | such   | BE1-RA36 |
And I append rows
   | artikel | mge |
   | TE009   | 50  |
And I set field "zrahmen" to "RA-EK-36B" in row 1
Then field "verfuegbmge" has value "15" in row 1
Then field "lfristkurz" has value "10" in row 1
Then field "lzeit" has value "20" in row 1
And I set field "mge" to "50" in row 1
# Menge groß         -> Lieferzeit lang
Then field "tterm" has value "31.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
# Menge klein        -> Lieferzeit kurz
And I set field "mge" to "12" in row 1
Then field "tterm" has value "17.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
# Rahmen ignorieren
And I set field "zignrahmen" to "ja" in row 1
Then field "tterm" has value "02.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
# Rahmen wieder beruecksichtigen
And I set field "zignrahmen" to "nein" in row 1
Then field "tterm" has value "17.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
# Anderen Rahmen eintragen
And I set field "zrahmen" to "RA-EK-36A" in row 1
Then field "tterm" has value "03.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
# Zurueck aendern
And I set field "zrahmen" to "RA-EK-36B" in row 1
Then field "tterm" has value "17.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
# Bedarfstermin spaet  -> Lieferzeit lang
And I set field "rterm" to "07.02.95" in row 1
And I set field "mge" to "12" in row 1
Then field "tterm" has value "31.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
# Bedarfstermin frueh -> Lieferzeit kurz
And I set field "rterm" to "20.01.95" in row 1
And I set field "mge" to "12" in row 1
Then field "tterm" has value "17.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
# Termin fixieren
And I set field "mge" to "50" in row 1
And I set field "fixterm" to "ja" in row 1
Then field "tterm" has value "31.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
And I save the current editor

# Bestellung 1 aendern
Given I open an editor "BE1-RA36A" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE1-RA36"
# Menge aendern, Liefertermin unveraendert
And I set field "fixterm" to "nein" in row 1
And I set field "mge" to "10" in row 1
Then field "tterm" has value "31.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
And I save the current editor

# Manueller Bestellvorschlag
And I open an editor "BE3_VOR_RA36" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | lief |
   | TE009   | 004  |
And I set field "zrahmen" to "RA-EK-36B" in row 1
Then field "verfuegbmge" has value "15" in row 1
Then field "lfristkurz" has value "10" in row 1
Then field "lzeit" has value "20" in row 1
# Menge groß         -> Lieferzeit lang
And I set field "mge" to "50" in row 1
Then field "tterm" has value "31.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
# Menge klein        -> Lieferzeit kurz
And I set field "mge" to "12" in row 1
Then field "tterm" has value "17.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
# Bedarfstermin spaet  -> Lieferzeit lang
And I set field "rterm" to "02.02.95" in row 1
And I set field "mge" to "12" in row 1
Then field "tterm" has value "31.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
# Bedarfstermin frueh -> Lieferzeit kurz
And I set field "rterm" to "20.01.95" in row 1
And I set field "mge" to "12" in row 1
Then field "tterm" has value "17.01.95" in row 1
Then field "tsterm" has value "02.01.95" in row 1
And I close the current editor

# Mindestbestand eintragen
# Bestellvorschlag zu Artikel TE009 mit der Dispo generieren
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "TE009"
And I set field "mindest" to "202"
And I save the current editor

And I run Scheduling

And I open an editor "BE4_VOR_RA36" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "TE009"
And I press button "ladetab"
And I set field "zrahmen" to "RA-EK-36B" in row 1
Then field "verfuegbmge" has value "15" in row 1
Then field "lzeit" has value "20" in row 1
Then field "lfristkurz" has value "10" in row 1
Then field "trterm" has value "02.01.95" in row 1
And I set field "trterm" to "10.01.95" in row 1
# Menge gross        -> Lieferzeit lang
And I set field "mge" to "50" in row 1
Then field "tterm" has value "10.01.95" in row 1
Then field "tsterm" has value "12.12.94" in row 1
# Menge klein        -> Lieferzeit kurz
And I set field "mge" to "20" in row 1
Then field "tterm" has value "10.01.95" in row 1
Then field "tsterm" has value "12.12.94" in row 1
# Bedarfstermin spaet  -> Lieferzeit lang
And I set field "rterm" to "02.02.95" in row 1
And I set field "mge" to "12" in row 1
Then field "tterm" has value "02.02.95" in row 1
Then field "tsterm" has value "04.01.95" in row 1
# Bedarfstermin frueh -> Lieferzeit kurz
And I set field "rterm" to "30.01.95" in row 1
And I set field "mge" to "12" in row 1
# Then field "tterm" has value "17.01.95" in row 1
# Then field "tsterm" has value "02.01.95" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Rahmenauftrag und Preisfindung
#----------------------------------------------------------------------------------------------
Given I open an editor "1RA037" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1RA037 |
   | lief   | 1      |
   | vom    | .      |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE037   | Stück | 100  | 37    | 100         |
And I save the current editor

Given I open an editor "1BE037" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE037 |
   | lief   | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge |
   | TE037   | 90  |
And I save the current editor

Given I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | lief | mge |
   | TE037   | 1    | 9   |
   | TE037   | 1    | 9   |
Then field "zrahmen" has value "1RA037" in row 1
Then field "zrahmen" has value "1RA037" in row 2
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "11" in row 1
Then field "zrahmen" is empty in row 1
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I save the current editor

Given I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "TE037"
And I press button "ladetab"
And I set field "mge" to "9" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "11" in row 1
Then field "zrahmen" is empty in row 1
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I save the current editor

Given I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "TE037"
And I press button "ladetab"
And I set field "mfreig" to "true" in row 1
And I press button "freig" to open a subeditor for "2BE037"
And I set fields
   | nummer | 2BE037 |
   | vom    | .      |
And I set field "mge" to "9" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "11" in row 1
Then field "zrahmen" is empty in row 1
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I save the current editor
And I switch the current editor to editor "BEVOR"
And I close the current editor

Given I open an editor "1BE037" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "1BE037"
And I set field "mge" to "85" in row 1
And I save the current editor

Given I open an editor "2BE037" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "2BE037"
And I set field "mge" to "14" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "15" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "16" in row 1
Then field "zrahmen" is empty in row 1
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I save the current editor

Given I open an editor "1LS037" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "2BE037"
And I set fields
   | nummer | 1LS037 |
   | vom    | .      |
And I set field "fixpwert" to "false" in row 1
And I set field "mge" to "14" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "15" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "16" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I save the current editor

Given I open an editor "1LS037" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "1LS037"
And I set field "mge" to "14" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "15" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "16" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "0" in row 1
And I save the current editor

Given I open an editor "2LS037" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 2LS037 |
   | lief   | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge  |
   | TE037   | 9    |
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "11" in row 1
Then field "zrahmen" is empty in row 1
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I save the current editor

Given I open an editor "2LS037" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "2LS037"
And I set field "mge" to "9" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "11" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I save the current editor

Given I open an editor "BEVOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "TE037"
And I press button "ladetab"
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "6" in row 1
Then field "zrahmen" is empty in row 1
And I close the current editor

Given I open an editor "1BE037" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "1BE037"
And I set field "mge" to "85" in row 1
Then field "zrahmen" has value "1RA037" in row 1
And I set field "mge" to "86" in row 1
Then field "zrahmen" is empty in row 1
And I close the current editor

Given I open an editor "2RA037" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 2RA037 |
   | lief   | 1      |
   | vom    | .      |
And I append rows
   | artikel | he    | mge  | preis | maxabrufmge |
   | TE037   | Stück | 100  | 37    | 100         |
   | TE037   | Stück | 100  | 73    | 100         |
And I save the current editor

Given I open an editor "3BE037" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record from editor "2RA037"
And I set fields
   | nummer | 3BE037 |
   | vom    | .      |
And I delete row at position 2
And I set field "mge" to "90" in row 1
And I save the current editor

Given I open an editor "4BE037" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record from editor "2RA037"
And I set fields
   | nummer | 4BE037 |
   | vom    | .      |
And I delete row at position 1
And I set field "mge" to "95" in row 1
And I save the current editor

Given I open an editor "5BE037" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 5BE037 |
   | lief   | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge |
   |  TE037  | 10  |
And I save the current editor

Given I open an editor "5BE037" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "5BE037"
Then field "zrahmen" has value "2RA037" in row 1
And I set field "mge" to "15" in row 1
Then field "zrahmen" is empty in row 1
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "2RA037" in row 1
And I save the current editor

Given I open an editor "6BE037" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 6BE037 |
   | lief   | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge |
   |  TE037  | 5   |
Then field "zrahmen" has value "2RA037" in row 1
And I set field "mge" to "6" in row 1
Then field "zrahmen" is empty in row 1
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "2RA037" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Rahmenauftrag, mehrere Bestellungen, Wert im Skip-Feld (ev)ofverfuegbmge pruefen
#----------------------------------------------------------------------------------------------
# Rahmenauftrag 38 anlegen mit lfristkurz
Given I open an editor "RA-EK-38" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 38EKRA   |
   | lief    | 1        |
   | such    | RA-EK-38 |
   | vom     | .        |
And I append rows
   | artikel | he     | mge  | preis | verfuegbmge | lzeit | lfristkurz |
   | TE009   | Stück  | 380  | 38    | 50          | 10    | 2          |
And I save the current editor

# Bestellung 1 zu RA 38
Given I open an editor "BE038" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record from editor "RA-EK-38"
And I set fields
   | nummer | 1BE038 |
   | such   | BE038  |
   | lief   | 1      |
   | vom    | .      |
Then field "zrahmen" has value "38EKRA" in row 1
And I set field "mge" to "3" in row 1
And I set field "tterm" to "+11" in row 1
And I save the current editor
# Liefertermin - lzeit liegen in der Zukunft
Then field "ofverfuegbmge" from editor "BE038" in row 1 has value "50"
Then field "ofverfuegbmge" from editor "RA-EK-38" in row 1 has value "50"

Given I open an editor "BE038" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE038"
And I set field "tterm" to "+5" in row 1
Then field "verwendlfristkurz" has value "nein" in row 1
# Lieferterminberechnung neu anstossen geht im EK nicht
And I save the current editor
# Liefertermin - lzeit liegen in der Vergangenheit: sofort verfuegbare Menge wird beruecksichtigt
# ToDo: Fraglich ob man das Setzen von lfristkurz auch an Aenderung tterm anbinden soll
Then field "verwendlfristkurz" from editor "BE038" in row 1 has value "nein"
Then field "ofverfuegbmge" from editor "BE038" in row 1 has value "50"
Then field "ofverfuegbmge" from editor "RA-EK-38" in row 1 has value "50"

# Auftrag 2 zu RA 38
Given I open an editor "BE038B" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record from editor "RA-EK-38"
And I set fields
   | nummer | 2BE038 |
   | such   | BE038B |
   | lief   | 1      |
   | vom    | .      |
And I set field "mge" to "11" in row 1
And I save the current editor
# ToDo: Fraglich ob man das Setzen von lfristkurz auch an Aenderung tterm anbinden soll
#Then field "ofverfuegbmge" from editor "RA-EK-38" in row 1 has value "36"
Then field "ofverfuegbmge" from editor "BE038B" in row 1 has value "50"
Then field "ofverfuegbmge" from editor "RA-EK-38" in row 1 has value "50"

#----------------------------------------------------------------------------------------------
Scenario: EK - Rahmenauftrag, mehrere LS offen, manche mit Status Stern, LS altern
# LS altern und so aendert sich ofverfuegbare Menge (Werden wieder verfuegbar). Wochenende, Feiertage werden beruecksichtigt
#----------------------------------------------------------------------------------------------
# Weiteren Artikel anlegen
Given I open an editor "TE020" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
| such     | TE020            |
| namebspr | Teil020          |
| vpr      | 50               |
| bsart    | Fremdbeschaffung |
| dispoa   | auftragsbezogen  |
And I save the current editor

# Rahmenauftrag 039 anlegen mit lfristkurz
Given I open an editor "RA039" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| lief   | 1        |
| such   | RA039    |
| ebeleg | RA039    |
| vom    | .        |
And I append rows
| artikel | he     | mge  | preis | verfuegbmge | lzeit | lfristkurz |
| !TE020  | Stück  | 100  | 38    | 50          | 10    | 2          |
And I save the current editor

Given I open an editor "BE039" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
| lief   | 1       |
| such   | BE039   |
| ebeleg | BE039   |
| vom    | .       |
And I append rows
| artikel | mge | zrahmen |
| !TE020  | 4   | !RA039  |
| !TE020  | 3   | !RA039  |
And I save the current editor
# Liefertermin - lzeit liegt in der Zukunft
Then field "lfristkurz" from editor "BE039" in row 1 has value "2"
Then field "lfristkurz" from editor "BE039" in row 2 has value "2"
Then field "ofverfuegbmge" from editor "BE039" in row 1 has value "43"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "43"

Given I open an editor "BE039" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE039"
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "47"

# Bestellung 2 zu RA039
Given I open an editor "BE039B" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
| lief   | 1          |
| such   | BE039B     |
| ebeleg | BE039B     |
| vom    | .          |
And I append rows
| artikel | mge | zrahmen |
| !TE020  | 47  | !RA039  |
And I save the current editor
Then field "lfristkurz" from editor "BE039B" in row 1 has value "2"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "0"

Given I open an editor "BE039B" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE039B"
And I set field "mge" to "46" in row 1
Then field "lfristkurz" has value "2" in row 1
# Durch Klicken von Ignore Rahmen wird die Lieferterminberechnung angestossen
And I set field "zignrahmen" to "ja" in row 1
Then field "lfristkurz" has value "0" in row 1
And I set field "zignrahmen" to "nein" in row 1
Then field "lfristkurz" has value "2" in row 1
And I save the current editor
Then field "ofverfuegbmge" from editor "BE039B" in row 1 has value "1"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "1"

Given I open an editor "BE039B" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE039B"
And I set field "mge" to "47" in row 1
And I append rows
   | artikel | mge | zrahmen |
   | !TE020  | 1   | !RA039  |
# Passen Sie die Menge oder den Liefertermin an oder deaktivieren Sie die Verwendung der noch abrufbaren Menge.
Then saving the current editor throws the exception "6818"
And I set field "verwendlfristkurz" to "nein" in row 2
And I save the current editor
Then field "lfristkurz" from editor "BE039B" in row 1 has value "2"
Then field "verwendlfristkurz" from editor "BE039B" in row 1 has value "ja"
Then field "verwendlfristkurz" from editor "BE039B" in row 2 has value "nein"
Then field "ofverfuegbmge" from editor "BE039" in row 1 has value "0"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "0"

# BE altert
Given I set the fake date to "04.01.95"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "0"
Given I set the fake date to "13.01.95"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "0"
Given I set the fake date to "19.01.95"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "50"
Given I set the fake date to "22.03.95"
Then field "ofverfuegbmge" from editor "RA039" in row 1 has value "50"

#----------------------------------------------------------------------------------------------
Scenario: EK - Rahmenauftrag, Verfuegbare Menge in Vorgangskette
#              Verschiedene Einheiten, gebuchte und ungebuchte Lieferscheine
#----------------------------------------------------------------------------------------------

# Rahmenauftrag 040 anlegen mit lfristkurz
Given I open an editor "RA040" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001      |
| nummer | 1RA040   |
| such   | RA040    |
| ebeleg | RA040    |
| vom    | .        |
And I append rows
| artikel | he   | mge   | preis | verfuegbmge | lzeit | lfristkurz |
| !TE021  | Paar | 1000  | 35    | 150         | 10    | 2          |
And I save the current editor

Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "150"

Given I open an editor "BE040" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001     |
| such   | BE040   |
| ebeleg | BE040   |
| vom    | .       |
And I append rows
| artikel | mge  | he | zrahmen |
| !TE021  | 12   | kg | RA040   |
Then field "verfuegbmge" has value "30" in row 1
And I save the current editor
# Liefertermin - lzeit liegt in der Zukunft
Then field "lfristkurz" from editor "BE040" in row 1 has value "2"
# in Kg (1 Kg = 10 Stueck; 2 Stueck = 1 Paar
Then field "ofverfuegbmge" from editor "BE040" in row 1 has value "18"
# Paare
Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "90"

# 1. Teillieferung zu Bestellung
Given I open an editor "1LS040" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE040"
And I set fields
   | nummer | 1LS040 |
   | vom    | .      |
And I set field "fixpwert" to "false" in row 1
And I set field "mge" to "10" in row 1
Then field "zrahmen" has value "1RA040" in row 1
Then field "verfuegbmge" has value "30" in row 1
And I save the current editor

Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "90"

# LS direkt anlegen
Given I open an editor "LS040X" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
| lief   | 001    |
| such   | LS040X |
| ebeleg | LS040X |
| vom    | .      |
| tterm  | .      |
And I create a new row at the end of the table
And I set field "artikel" to "!TE021" in row 1
# Preisfindung findet einen Rahmenauftrag.
And I set field "mge" to "62" in row 1
And I set field "he" to "Stück" in row 1
Then field "zrahmen" has value "1RA040" in row 1
Then field "verfuegbmge" has value "300" in row 1
And I set field "tterm" to "." in row 1
And I save the current editor

Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "59"

# Lieferschein LS040X buchen
Given I open an editor "LS040XX" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS040X"
And I set fields
   | ueb     | ja      |
And I save the current editor

Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "59"

# 2. Teillieferung zu Bestellung, Ueberlieferung
Given I open an editor "1LS040B" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE040"
And I set fields
   | nummer | 1LS040B |
   | vom    | .       |
And I set field "fixpwert" to "false" in row 1
And I set field "mge" to "5" in row 1
Then field "zrahmen" has value "1RA040" in row 1
Then field "verfuegbmge" has value "30" in row 1
And I save the current editor

Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "44"

# Bestellung aus Rahmenauftrag erzeugen, Menge groesser als sofort verfuegbare Menge
Given I open an editor "BE040B" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA040"
And I set fields
| such   | BE040B  |
| ebeleg | BE040B  |
| vom    | .       |
And I set field "mge" to "120" in row 1
And I set field "he" to "Stück" in row 1
Then field "verfuegbmge" has value "300" in row 1
And I save the current editor
# Liefertermin - lzeit liegt in der Zukunft
Then field "verwendlfristkurz" from editor "BE040B" in row 1 has value "nein"
# Stueck
Then field "ofverfuegbmge" from editor "BE040B" in row 1 has value "88"
# Paare
Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "44"

Given I open an editor "RE040X" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS040X"
And I set fields
   | ebeleg  | 040REX   |
   | such    | RE040X   |
   | ueb     | ja       |
   | vom     | .        |
   | tterm   | .        |
And I set field "mge" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "ofverfuegbmge" from editor "RA040" in row 1 has value "44"

#----------------------------------------------------------------------------------------------
Scenario: EK - Rahmenauftrag mit lfristkurz und maxabrufmge
#----------------------------------------------------------------------------------------------
# Rahmenauftrag 41 anlegen mit lfristkurz und maxabrufmge
Given I open an editor "RA-EK-41" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 41EKRA   |
   | lief    | 1        |
   | such    | RA-EK-41 |
   | vom     | .        |
And I append rows
   | artikel | he     | mge  | preis | verfuegbmge | lzeit | lfristkurz | maxabrufmge |
   | TE016   | Stück  | 100  | 9     | 5           | 10    | 2          | 120         |
And I save the current editor

# Bestellung 1 zu RA 41
Given I open an editor "BE-EK-41" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 41EKBE   |
   | such   | BE-EK-41 |
   | lief   | 1        |
   | vom    | .        |
And I append rows
   | artikel | mge | tterm |
   | TE016   | 3   |  +2   |
Then field "zrahmen" has value "41EKRA" in row 1
Then field "fzahlabrufoffenicon" has value "icon:ball_green" in row 1
Then field "verwendlfristkurz" has value "ja" in row 1
And I save the current editor

# Liefertermin - lzeit liegen in der Zukunft
Then field "ofverfuegbmge" from editor "BE-EK-41" in row 1 has value "2"
Then field "ofverfuegbmge" from editor "RA-EK-41" in row 1 has value "2"

#----------------------------------------------------------------------------------------------
Scenario: EK - BV mit Rahmenauftrag, Lieferantenwechsel (z.B. Lieferantenauswahl)
#----------------------------------------------------------------------------------------------
# Rahmenauftrag zu Artikel TE042 und Lieferant 004
Given I open an editor "rahmen4-EK-42" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 42RA4EK  |
   | lief    | 004      |
   | such    | RA4EK-42 |
   | vom     | .        |
And I append rows
   | artikel | he | mge | preis |
   | TE042   | kg | 22  | 38    |
And I save the current editor

# Rahmenauftrag zu Artikel TE042 und Lieferant 1
Given I open an editor "rahmen1-EK-42" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | num4    | 42RA1EK  |
   | lief    | 1        |
   | such    | RA1EK-42 |
   | vom     | .        |
And I append rows
   | artikel | he | mge | preis |
   | TE042   | kg | 12  | 37    |
And I save the current editor

# Bestellvorschlag
And I open an editor "BE42_VOR" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | lief |
   | TE042   |   1  |
Then field "preis" has value "39.00" in row 1
And I set field "lief" to "004" in row 1
Then field "preis" has value "40.00" in row 1
#Then field "preis" has value "38.00" in row 1
And I set field "mge" to "1" in row 1
Then field "zrahmen" has value "42RA4EK" in row 1
Then field "preis" has value "38.00" in row 1
And I set field "lief" to "002" in row 1
Then field "zrahmen" has value " " in row 1
Then field "preis" has value "62.00" in row 1
And I set field "lief" to "1" in row 1
Then field "zrahmen" has value "42RA1EK" in row 1
Then field "preis" has value "37.00" in row 1
And I respond with answer "2" to the dialog with id "Lieferantenauswahl"
And I press button "lausw" in row 1
Then field "zrahmen" has value "42RA4EK" in row 1
Then field "preis" has value "38.00" in row 1
And I respond with answer "5" to the dialog with id "Lieferantenauswahl"
And I press button "lausw" in row 1
Then field "zrahmen" has value " " in row 1
Then field "preis" has value "62.00" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag aus Rahmenauftrag freigeben: Feld verwendlfristkurz pruefen
#----------------------------------------------------------------------------------------------
Given I open an editor "rahmen-VK-43" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 43RAVK   |
   | kunde   | 1        |
   | such    | RA-VK-43 |
   | vom     | .        |
And I append rows
   | artikel | he     | mge  | preis | verfuegbmge | lzeit | lfristkurz |
   | TE043   | Stück  | 100  | 43    | 5           | 5     | 2          |
And I save the current editor

# Auftrag aus Rahmenauftrag 43
Given I open an editor "AU-ZU-RA043" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "43RAVK"
And I set fields
   | nummer  | 43AU    |
   | such    | AU-RA43 |
And I set field "mge" to "2" in row 1
Then field "verwendlfristkurz" has value "ja" in row 1
And I save the current editor

Then field "verwendlfristkurz" from editor "AU-ZU-RA043" in row 1 has value "ja"

# 2. Auftrag aus Rahmenauftrag 43
Given I open an editor "AU2-ZU-RA043" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "43RAVK"
And I set fields
   | nummer  | 43AU2    |
   | such    | AU2-RA43 |
And I set field "mge" to "5" in row 1
And I set field "tterm" to "+10" in row 1
Then field "verwendlfristkurz" has value "ja" in row 1
And I save the current editor

Then field "verwendlfristkurz" from editor "AU2-ZU-RA043" in row 1 has value "nein"

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung aus Rahmenauftrag freigeben: Feld verwendlfristkurz pruefen
#----------------------------------------------------------------------------------------------
# Rahmenauftrag 043 anlegen mit lfristkurz
Given I open an editor "RA043" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001      |
| nummer | 1RA043   |
| such   | RA043    |
| ebeleg | RA043    |
| vom    | .        |
And I append rows
| artikel | mge   | preis | verfuegbmge | lzeit | lfristkurz |
| TE043   | 1000  | 35    | 25          | 10    | 2          |
And I save the current editor

Then field "ofverfuegbmge" from editor "RA043" in row 1 has value "25"

# Bestellung aus Rahmenauftrag erzeugen, Menge kleiner groesser als sofort verfuegbare Menge
Given I open an editor "BE043" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "RA043"
And I set fields
| such   | BE043  |
| ebeleg | BE043  |
| vom    | .      |
And I set field "mge" to "11" in row 1
And I save the current editor

Then field "verwendlfristkurz" from editor "BE043" in row 1 has value "ja"

# 1.Bestellvorschlag
And I open an editor "BVOR_RA043" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | lief |
   | TE043   | 001  |
And I set field "mge" to "3" in row 1
Then field "verwendlfristkurz" has value "ja" in row 1
And I save the current editor

# Bestellvorschlag freigeben
And I open an editor "BV1_RA043" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "TE043"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BE043_2"
Then field "verwendlfristkurz" has value "ja" in row 1
And I save the current editor
And I switch the current editor to editor "BV1_RA043"
And I close the current editor

Then field "verwendlfristkurz" from editor "BE043_2" in row 1 has value "ja"

# 2. Bestellvorschlag
And I open an editor "BV2_RA043" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | lief |
   | TE043   | 001  |
And I set field "mge" to "15" in row 1
Then field "verwendlfristkurz" has value "ja" in row 1
And I save the current editor

# Bestellvorschlag freigeben
And I open an editor "BV2_RA043" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "TE043"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BE043_3"
Then field "verwendlfristkurz" has value "ja" in row 1
And I save the current editor
And I switch the current editor to editor "BV2_RA043"
And I close the current editor

Then field "verwendlfristkurz" from editor "BE043_3" in row 1 has value "nein"

# Mindestbestand eintragen
# Bestellvorschlag zu Artikel TE043 mit der Dispo generieren
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "TE043"
And I set field "mindest" to "10"
And I save the current editor

And I run Scheduling

# Dispobestellvorschlag freigeben
And I open an editor "BV3_RA043" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "TE043"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BE043_4"
And I set field "lief" to "001"
Then field "verwendlfristkurz" has value "ja" in row 1
And I save the current editor
And I switch the current editor to editor "BV3_RA043"
And I close the current editor

Then field "verwendlfristkurz" from editor "BE043_4" in row 1 has value "ja"

#----------------------------------------------------------------------------------------------
Scenario: VK - Preisfindung bei Eingabe des Konditionsdatum aufrufen
#----------------------------------------------------------------------------------------------
Given I open an editor "rahmen-VK-44" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
  | nummer  | 44RAVK   |
  | kunde   | 1        |
  | such    | RA-VK-44 |
  | vom     | .        |
And I append rows
  | artikel | he     | mge  | preis | zgltvon | zgltbis |
  | TE044   | Stück  | 100  | 43    |         | +9      |
And I save the current editor

Given I open an editor "rahmen-VK-44B" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
  | nummer  | 44BRAVK   |
  | kunde   | 1         |
  | such    | RA-VK-44B |
  | vom     | .         |
And I append rows
  | artikel | he     | mge  | preis | zgltvon | zgltbis |
  | TE044   | Stück  | 100  | 44    | +10     | +19     |
  | TE044   | Stück  | 100  | 45    | +20     | +100    |
And I save the current editor

# Auftrag
Given I open an editor "AU44" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde  | 1       |
  | nummer | 44AU    |
  | such   | AU-RA44 |
  | tterm  | .       |
  | budat  | .       |
And I append rows
  | artikel | he    | mge |
  | TE044   | Stück | 20  |
# Kein Konditionsdatum, Vorgangsadtum im Gueltigkeitsbereich der 1. Zeile des 1. Rahmenauftrag
Then field "zrahmen" has value "44RAVK" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-44" in row 1
Then field "preis" has value "43.00" in row 1
And I save the current editor

Given I open an editor "AU-ZU-RA044" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU-RA44"
# Konditionsdatum im Gueltigkeitsbereich der 1. Zeile des 2. Rahmenauftrag setzen
And I set field "konddat" to "+12" in row 1
Then field "zrahmen" has value "44BRAVK" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-44B" in row 1
Then field "preis" has value "44.00" in row 1
And I save the current editor

Given I open an editor "AU-ZU-RA044" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU-RA44"
# Konditionsdatum im Gueltigkeitsbereich der 2. Zeile des 2. Rahmenauftrag setzen
And I set field "konddat" to "+25" in row 1
Then field "zrahmen" has value "44BRAVK" in row 1
# Das funktioniert leider nicht, es wird immer Zeile 1 gefunden
# Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-VK-44B" in row 2
Then field "preis" has value "45.00" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Preisfindung bei Eingabe des Konditionsdatum aufrufen
#----------------------------------------------------------------------------------------------
# Rahmenauftrag 044 anlegen
Given I open an editor "rahmen-EK-44" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
  | lief   | 001      |
  | nummer | 44RAEK   |
  | such   | RA-EK-44 |
  | ebeleg | RA-EK-44 |
  | vom    | .        |
And I append rows
  | artikel | mge  | preis | zgltvon | zgltbis |
  | TE044   | 100  | 43    |         | +9      |
And I save the current editor

Given I open an editor "rahmen-EK-44B" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
  | lief   | 001       |
  | nummer  | 44BRAEK   |
  | such    | RA-EK-44B |
  | ebeleg  | RA-EK-44B |
  | vom     | .         |
And I append rows
  | artikel | he     | mge  | preis | zgltvon | zgltbis |
  | TE044   | Stück  | 100  | 44    | +10     | +19     |
  | TE044   | Stück  | 100  | 45    | +20     | +100    |
And I save the current editor

# Bestellung
Given I open an editor "BE44" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
  | lief   | 001     |
  | nummer | 44BE    |
  | such   | BE-RA44 |
  | tterm  | .       |
  | budat  | .       |
And I append rows
  | artikel | he    | mge |
  | TE044   | Stück | 20  |
# Kein Konditionsdatum, Vorgangsadtum im Gueltigkeitsbereich der 1. Zeile des 1. Rahmenauftrag
Then field "zrahmen" has value "44RAEK" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-44" in row 1
Then field "preis" has value "43.00" in row 1
And I save the current editor

Given I open an editor "BE-ZU-RA044" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE-RA44"
# Konditionsdatum im Gueltigkeitsbereich der 1. Zeile des 2. Rahmenauftrag setzen
And I set field "konddat" to "+12" in row 1
Then field "zrahmen" has value "44BRAEK" in row 1
Then field "zrahmenpos^id" in row 1 has value equal to field "pos^id" from editor "rahmen-EK-44B" in row 1
Then field "preis" has value "44.00" in row 1
And I save the current editor

Given I open an editor "BE-ZU-RA044" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE-RA44"
# Konditionsdatum im Gueltigkeitsbereich der 2. Zeile des 2. Rahmenauftrag setzen
And I set field "konddat" to "+25" in row 1
Then field "zrahmen" has value "44BRAEK" in row 1
Then field "preis" has value "45.00" in row 1
And I save the current editor

#--------------------------------------------------------------------------------------------
Scenario: EK - Maximale Rahmenmenge in Rahmenauftrag nachtraeglich verringern
               Menge in Bestellung auf gelieferte Menge verringern
#----------------------------------------------------------------------------------------------

# Rahmenauftrag 45 anlegen
Given I open an editor "RA-EK-45" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001      |
| nummer | 45RAEK   |
| such   | RA-EK-45 |
| ebeleg | RA-EK-45 |
| vom    | .        |
And I append rows
| artikel | he   | mge   | preis | maxabrufmge |
| !TE021  | Paar | 1000  | 35    | 1200        |
And I save the current editor

# Bestellung aus Rahmenauftrag RA045
Given I open an editor "BE45" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record "45RAEK"
And I set fields
   | nummer | 45BE    |
   | such   | BE-RA45 |
   | ebeleg | BE-RA45 |
   | vom    | .       |
And I set field "mge" to "1000" in row 1
And I save the current editor

# 1. Teillieferung zu Bestellung
Given I open an editor "1LS-EK-45" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE45"
And I set fields
   | nummer | 1LSEK45   |
   | such   | LS1-EK-45 |
   | vom    | .         |
   | ueb    | ja        |
And I set field "mge" to "400" in row 1
Then field "zrahmen" has value "45RAEK" in row 1
And I save the current editor

# 2. Teillieferung zu Bestellung
Given I open an editor "2LS-EK-45" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE45"
And I set fields
   | nummer | 2LSEK45   |
   | such   | LS2-EK-45 |
   | vom    | .         |
   | ueb    | ja        |
And I set field "mge" to "500" in row 1
Then field "zrahmen" has value "45RAEK" in row 1
And I save the current editor

# Maximale Abrufmenge in Rahmenauftrag auf abgerufene Menge verringern
Given I open an editor "RA-EK-45UP" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record from editor "RA-EK-45"
And I set field "mge" to "900" in row 1
Then setting field "maxabrufmge" to "900" in row 1 throws the exception "1049"
And I set field "maxabrufmge" to "1000" in row 1
And I save the current editor

# Menge in Bestellung auf gelieferte Menge verringern
Given I open an editor "BE45UP" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE45"
And I set field "mge" to "900" in row 1
And I save the current editor

#--------------------------------------------------------------------------------------------
Scenario: VK - Maximale Rahmenmenge in Rahmenauftrag
               Menge in Bestellung auf gelieferte Menge verringern
#----------------------------------------------------------------------------------------------

# Rahmenauftrag 45 anlegen
Given I open an editor "RA-VK-45" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| kunde  | 001      |
| nummer | 45RAVK   |
| such   | RA-VK-45 |
| vom    | .        |
And I append rows
| artikel | he    | mge  | preis | maxabrufmge |
| !TE014  | Stück | 400  | 35    | 500         |
And I save the current editor

# Auftrag aus Rahmenauftrag RA-VK-45
Given I open an editor "AU45" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "45RAVK"
And I set fields
| nummer | 45AU    |
| such   | AU-RA45 |
| vom    | .       |
And I set field "mge" to "350" in row 1
And I save the current editor

# 1. Teillieferung zu Auftrag
Given I open an editor "1LS-VK-45" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU45"
And I set fields
   | nummer | 45LSVK   |
   | such   | LS1-RA45 |
   | vom    | .        |
   | ueb    | ja       |
And I set field "mge" to "260" in row 1
Then field "zrahmen" has value "45RAVK" in row 1
And I save the current editor

# 2. Auftrag aus Rahmenauftrag RA-VK-45
Given I open an editor "AU45B" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "45RAVK"
And I set fields
| nummer | 45BAU    |
| such   | AU-RA45B |
| vom    | .        |
And I set field "mge" to "40" in row 1
And I save the current editor

# Komplette Lieferung zu Auftrag AU45B
Given I open an editor "1LS-VK-45B" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU45B"
And I set fields
   | nummer | 45BLSVK   |
   | such   | LS1B-RA45 |
   | vom    | .         |
   | ueb    | ja        |
And I set field "mge" to "40" in row 1
Then field "zrahmen" has value "45RAVK" in row 1
And I save the current editor

# Menge in Auftrag erhoehen und dann verringern
Given I open an editor "AU45UP" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU45"
Then setting field "mge" to "465" in row 1 throws the exception "1299"
And I set field "mge" to "450" in row 1
And I set field "mge" to "300" in row 1
And I save the current editor

#--------------------------------------------------------------------------------------------
Scenario: VK - Preisfindung bei (ev)savings = true im Rahmenauftrag
#----------------------------------------------------------------------------------------------

# Rahmenauftrag 46 anlegen
Given I open an editor "RA-VK-46" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| kunde  | 1        |
| nummer | 46RAVK   |
| such   | RA-VK-46 |
| vom    | .        |
And I append rows
| artikel | he    | mge  | preis | savings |
| !TE045  | Stück | 400  | 25    | ja      |
And I save the current editor

# Auftrag aus Rahmenauftrag RA-VK-46
Given I open an editor "AU45" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record from editor "RA-VK-46"
And I set fields
| nummer | 46AU    |
| such   | AU-RA46 |
| vom    | .       |
And I set field "mge" to "100" in row 1
Then field "zrahmen" has value "46RAVK" in row 1
Then field "preis" has value "25.00" in row 1
And I set field "fixpwert" to "false" in row 1
Then field "zrahmen" has value "46RAVK" in row 1
Then field "preis" has value "35.00" in row 1
And I set field "mge" to "110" in row 1
Then field "zrahmen" has value "46RAVK" in row 1
Then field "preis" has value "45.00" in row 1
And I close the current editor

Given I open an editor "AU45" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record from editor "RA-VK-46"
And I set fields
| nummer | 46AU    |
| such   | AU-RA46 |
| vom    | .       |
And I set field "mge" to "100" in row 1
Then field "zrahmen" has value "46RAVK" in row 1
Then field "preis" has value "25.00" in row 1
And I save the current editor

Given I open an editor "AU45" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU45"
And I set field "fixpwert" to "false" in row 1
Then field "zrahmen" has value "46RAVK" in row 1
Then field "preis" has value "35.00" in row 1
And I set field "mge" to "110" in row 1
Then field "zrahmen" has value "46RAVK" in row 1
Then field "preis" has value "45.00" in row 1
And I save the current editor

#--------------------------------------------------------------------------------------------
Scenario: VK - Wechsel des Kunden nach Rahmenauftragsfreigabe
#----------------------------------------------------------------------------------------------

# Rahmenauftraege
Given I open an editor "1RA010" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | KU001  |
   | nummer | 1RA010 |
   | such   | RA010  |
   | vom    | .      |
And I append rows
   | artikel | he    | mge  | preis |
   | TE009   | Stück | 1000 | 20    |
And I save the current editor

Given I open an editor "1RA011" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | KU001  |
   | nummer | 1RA011 |
   | such   | RA011  |
   | vom    | .      |
And I append rows
   | artikel | he    | mge  | preis |
   | TE010   | Stück | 1000 | 30    |
And I save the current editor

Given I open an editor "1RA012" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | KU002  |
   | nummer | 1RA012 |
   | such   | RA012  |
   | vom    | .      |
And I append rows
   | artikel | he    | mge  | preis |
   | TE009   | Stück | 1000 | 40    |
And I save the current editor

Given I open an editor "1RA013" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | KU002  |
   | nummer | 1RA013 |
   | such   | RA013  |
   | vom    | .      |
And I append rows
   | artikel | he    | mge  | preis |
   | TE010   | Stück | 1000 | 50    |
And I save the current editor

# Rahmenauftrag freigeben, Position anfuegen, Position manuell erfassen
Given I open an editor "1AU010" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record from editor "1RA010"
And I set fields
   | nummer | 1AU010 |
   | such   | AU010  |
   | vom    | .      |
And I set field "mge" to "20" in row 1
And I set field "beleg" to "1RA011"
And I delete row at position 2
And I set field "mge" to "30" in row 2
And I create a new row at the end of the table
And I set field "artikel" to "TE009" in row 3
And I set field "mge" to "40" in row 3
Then table has values
   | zrahmen | preis | fixpwert |
   | 1RA010  | 20.00 | ja       |
   | 1RA011  | 30.00 | ja       |
   | 1RA010  | 20.00 | nein     |
And I save the current editor

# Kunde im Auftrag wechseln
Given I open an editor "1AU010" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU010"
And I set field "kunde" to "KK001"
Then table has values
   | zrahmen | preis | fixpwert |
   | 1RA010  | 20.00 | ja       |
   | 1RA011  | 30.00 | ja       |
   | 1RA010  | 20.00 | nein     |
And I set field "kunde" to "KU002"
Then table has values
   | zrahmen | preis | fixpwert |
   |         | 20.00 | ja       |
   |         | 30.00 | ja       |
   | 1RA012  | 40.00 | nein     |
And I set field "fixpwert" to "nein" in row 1
And I set field "fixpwert" to "nein" in row 2
Then table has values
   | zrahmen | preis | fixpwert |
   | 1RA012  | 40.00 | nein     |
   | 1RA013  | 50.00 | nein     |
   | 1RA012  | 40.00 | nein     |
And I close the current editor

Given I open an editor "1AU010" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU010"
And I set field "kunde" to "KU002"
Then table has values
   | zrahmen | preis | fixpwert |
   |         | 20.00 | ja       |
   |         | 30.00 | ja       |
   | 1RA012  | 40.00 | nein     |
And I set field "fixpwert" to "nein" in row 1
And I set field "fixpwert" to "nein" in row 2
Then table has values
   | zrahmen | preis | fixpwert |
   | 1RA012  | 40.00 | nein     |
   | 1RA013  | 50.00 | nein     |
   | 1RA012  | 40.00 | nein     |
And I close the current editor

Given I open an editor "1AU010" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU010"
And I set field "kunde" to "KU002"
And I save the current editor

# Lieferschein buchen und Fortschrittszahlen pruefen
Given I open an editor "1LS010" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU010"
And I set fields
   | nummer | 1LS010 |
   | such   | LS010  |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I save the current editor

Then field "fzahl" from editor "1RA010" in row 1 has value "0"
Then field "fzahl" from editor "1RA011" in row 1 has value "0"
Then field "fzahl" from editor "1RA012" in row 1 has value "40"

#----------------------------------------------------------------------------------------------
Scenario: EK - Aenderung des Lieferanten in einem Lieferschein mit Rahmenauftragsbezug
#----------------------------------------------------------------------------------------------

# Rahmenauftrag anlegen
Given I open an editor "1RA046" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1RA046 |
   | lief    | 1      |
   | such    | RA046  |
And I append rows
   | artikel | he    | mge  | preis |
   | TE046   | Stück | 100  | 40    |
And I save the current editor

# Bestellung
Given I open an editor "1BE046" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE046 |
   | lief    | 1      |
   | such    | BE046  |
And I append rows
   | artikel | he    | mge  |
   | TE046   | Stück | 10   |
Then field "zrahmen" has value "1RA046" in row 1
And I save the current editor

# Lieferschein - (ev)orig muss beim Kundenwechsel erhalten bleiben
Given I open an editor "1LS046" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE046"
And I set fields
   | nummer  | 1LS046 |
   | such    | LS046  |
   | ueb     | ja     |
   | vom     | .      |
And I set field "mge" to "20" in row 1
And I set field "lief" to "001"
Then field "zrahmen" is empty in row 1
Then field "orig^kopf^nummer" has value "1BE046" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - BV Rahmenauftrag mit sofortiger Abrufmenge - Uebernahme der Werte bei Rahmeneingabe
# Dispositionstatus (Warteschlange) wird bei Aenderung der lzeit aktualisiert.
#----------------------------------------------------------------------------------------------
# Weiteren Artikel anlegen
Given I open an editor "TE047" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
| such     | TE047            |
| namebspr | Teil047          |
| vpr      | 12               |
| bsart    | Fremdbeschaffung |
| dispoa   | auftragsbezogen  |
| lief     | 001              |
| bfrist   | 7                |
| efrist   | 10               |
| lief2    | 004              |
| efrist2  | 11               |
| lief3    | 001              |
And I save the current editor

# Rahmenauftrag 46 mit max Menge 200 anlegen fuer den Lieferanten 001
Given I open an editor "RA-EK46" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001      |
| such   | RA-EK46  |
| num4   | 46RA-EK  |
| ebeleg | RA-EK46  |
And I append rows
| artikel | he    | mge | preis | verfuegbmge | lzeit | lfristkurz |
| !TE047  | Stück | 200 | 6     | 70          | 3     | 2          |
And I save the current editor

# Bestellvorschlag fuer Lieferant 001
# Lieferanten wechseln -> Zeiten pruefen
And I open an editor "BE_VOR_RA22" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | lief |
   | TE047   | 001  |
And I set field "mge" to "1" in row 1
Then field "zrahmen" has value "46RA-EK" in row 1
Then field "lzeit" has value "3" in row 1
Then field "lfristkurz" has value "2" in row 1
Then field "verfuegbmge" has value "70" in row 1
# Lieferant wechseln 001 -> 004
And I set field "lief" to "004" in row 1
Then field "lzeit" has value "11" in row 1
Then setting field "zrahmen" to "46RA-EK" throws the exception "1283"
Then field "lfristkurz" has value "0" in row 1
Then field "verfuegbmge" has value "0" in row 1
# Lieferant zurueck zu 001
And I set field "lief" to "001" in row 1
Then field "zrahmen" has value "46RA-EK" in row 1
Then field "lfristkurz" has value "2" in row 1
# Rahmen loeschen
And I set field "zrahmen" to "" in row 1
Then field "lzeit" has value "10" in row 1
Then field "lfristkurz" has value "0" in row 1
Then field "verfuegbmge" has value "0" in row 1
And I close the current editor

# Rahmenauftrag 46 mit max Menge 200 anlegen fuer den Lieferanten 004
Given I open an editor "RA-EK46-4" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
| lief   | 004      |
| such   | RA-EK46_4|
| num4   | 46RA-EK4 |
| ebeleg | RA-EK46_4|
And I append rows
| artikel | he    | mge | preis | verfuegbmge | lzeit | lfristkurz |
| !TE047  | Stück | 200 | 6     | 70          | 4     | 2          |
And I save the current editor

And I run Scheduling

# Bestellvorschlag fuer Lieferant 004: Lieferfrist richtig bestimmt
And I open an editor "BE_VOR_RA22" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | lief |
   | TE047   | 004  |
And I set field "mge" to "1" in row 1
Then field "lzeit" has value "4" in row 1
Then field "zrahmen" has value "46RA-EK4" in row 1
And I save the current editor
# Dispostatus pruefen
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "TE047"
And I press start
Then field "hinweis" has value "Plankarte muss von der Disposition noch aktualisiert werden"
And I close the current editor

And I run Scheduling

And I open an editor "BE_VOR_RA22_U" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record from editor "BE_VOR_RA22"
And I set field "zrahmen" to "" in row 1
Then field "lzeit" has value "11" in row 1
And I save the current editor
# Dispostatus pruefen
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "TE047"
And I press start
Then field "hinweis" has value "Plankarte muss von der Disposition noch aktualisiert werden"
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag aus Angebot nach 14 Tagen
#----------------------------------------------------------------------------------------------
Given I set the fake date to "22.03.95"
Given I open an editor "ANG_RA23" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
   | kunde   | 1        |
   | such    | ANG_RA23 |
Then I create a new row at the end of the table
And I set field "artex" to "TRA10PS" in row 1
And I set field "mge" to "15" in row 1
And I set field "zrahmen" to "03RA" in row 1
And I set field "lzeit" to "20" in row 1
Then field "tterm" has value "21.04.95" in row 1
And I save the current editor

Given I set the fake date to "05.04.95"
Given I open an editor "BE_RA23" from table "(Sales):(Quotation)" with command "RELEASE" for record from editor "ANG_RA23"
And I set field "such" to "AU_RA23"
# Liefertermin wird neu berechnet
Then field "tterm" has value "08.05.95" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung aus Anfrage nach 7 Tagen
#----------------------------------------------------------------------------------------------
Given I set the fake date to "22.03.95"
Given I open an editor "ANF_RA23" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
   | lief    | 1        |
   | such    | ANF_RA23 |
When I create a new row at the end of the table
And I set field "artex" to "TRA10PS" in row 1
And I set field "mge" to "15" in row 1
And I set field "zrahmen" to "01EKRA" in row 1
And I set field "lzeit" to "35" in row 1
Then field "tterm" has value "15.05.95" in row 1
And I save the current editor

Given I set the fake date to "29.03.95"
Given I open an editor "BE_RA23" from table "(Purchasing):(Request)" with command "RELEASE" for record from editor "ANF_RA23"
And I set field "such" to "BE_RA23"
# Liefertermin wird neu berechnet
Then field "tterm" has value "22.05.95" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung aus Anfrage mit Liefertermin in der Vergangenheit
#----------------------------------------------------------------------------------------------
Given I set the fake date to "22.03.95"
Given I open an editor "ANF_RA24" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
   | lief    | 1        |
   | such    | ANF_RA24 |
When I create a new row at the end of the table
And I set field "artex" to "TRA10PS" in row 1
And I set field "mge" to "15" in row 1
And I set field "zrahmen" to "01EKRA" in row 1
And I set field "lzeit" to "10" in row 1
Then field "tterm" has value "05.04.95" in row 1
And I set field "tterm" to "-2" in row 1
Then field "lzeit" has value "0" in row 1
And I save the current editor

Given I open an editor "BE_RA24" from table "(Purchasing):(Request)" with command "RELEASE" for record from editor "ANF_RA24"
And I set field "such" to "BE_RE24"
# Liefertermin beleibt unveraendert
Then field "tterm" has value "20.03.95" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Angebot mit 2 Positionen: eine Alternativposition
#----------------------------------------------------------------------------------------------

# Angebot anlegen
Given I open an editor "ANG-25" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
   | nummer  | 25ANG    |
   | kunde   | 1        |
   | such    | ANG-RA25 |
And I append rows
   | artex    | mge | alternativpos | zrahmen |
   | TRA10PS  | 15  | nein          | 03RA    |
   | TRA20PS  | 15  | ja            | 03RA    |
Then field "zrahmenpos" has value "*" in row 1
Then field "preis" has value "90.00" in row 1
Then field "zrahmenpos" has value "*" in row 2
Then field "preis" has value "100.00" in row 2
And I save the current editor

# Zeitraster Woche anlegen
Given I open an editor "ZeitrasterW" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
    | such          | WOCHE1             |
    | namebspr      | Zeitraster Woche   |
    | zeiteinheit   | Woche              |
    | zefaktor      | 1                  |
And I save the current editor

# Rahmenauftrag aus Angebot
Given I open an editor "RA-ZU-ANG25" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | beleg   | 25ANG  |
   | nummer  | 25RAVK |
# Nur Alternativposition bleibt
And I delete row at position 1
# Gueltigkeitsbereich setzen
And I set field "zgltvon" to "-7" in row 1
And I set field "zgltbis" to "+7" in row 1
# Zeitraster setzen
And I set field "zraster" to "WOCHE1" in row 1
# "Einplanung in die Disposition" ist schreibgeschuetzt
Then field "einplan" is not modifiable in row 1
And I save the current editor
# Rahmenauftrag ist nicht in der Ablage
Then "(Sales):(BlanketOrder)" with the editor id "RA-ZU-ANG25" is not filed

Given I open an editor "RA-ZU-ANG25" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "25RAVK"
And I append rows
   | artex    | mge | zgltvon | zgltbis | zraster | einplan |
   | TRA10PS  | 1   | -14     | +7      | WOCHE1  | ja      |
Then field "alternativpos" is modifiable in row 2
And I save the current editor

# Setze ich "Alternativposition" auf "ja", wird "Einplanung in die Disposition" auf "nein" gesetzt,
# wenn ich die Frage "Rahmenauftragsposition ausplanen?" verneine.
Given I open an editor "RA-ZU-ANG25" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "25RAVK"
Then field "einplan" has value "ja" in row 2
And I respond with answer "nein" to the dialog with id "Rahmenauftragsposition ausplanen"
And I set field "alternativpos" to "ja" in row 2
Then field "alternativpos" has value "nein" in row 2
And I close the current editor


#----------------------------------------------------------------------------------------------
Scenario: EK - Anfrage mit 2 Positionen - eine Alternativposition
#----------------------------------------------------------------------------------------------
# Anfrage anlegen
Given I open an editor "ANF-25" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
   | nummer  | 25ANF    |
   | lief    | 1        |
   | such    | ANF-RA25 |
And I append rows
   | artex    | mge | alternativpos | zrahmen |
   | TRA10PS  | 15  | nein          | 01EKRA  |
   | TRA20PS  | 15  | ja            | 01EKRA  |
Then field "zrahmenpos" has value "*" in row 1
Then field "zrahmenpos" has value "*" in row 2
And I save the current editor

# Rahmenauftrag aus Anfrage
Given I open an editor "RA-ZU-ANF25" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | beleg   | 25ANF  |
   | nummer  | 25RAEK |
# Nur Alternativposition bleibt
And I delete row at position 1
# Gueltigkeitsbereich setzen
And I set field "zgltvon" to "-7" in row 1
And I set field "zgltbis" to "+7" in row 1
# Zeitraster setzen
And I set field "zraster" to "WOCHE1" in row 1
# "Einplanung in die Disposition" ist schreibgeschuetzt
Then field "einplan" is not modifiable in row 1
And I save the current editor
# Rahmenauftrag ist nicht in der Ablage
Then "(Purchasing):(BlanketOrder)" with the editor id "RA-ZU-ANF25" is not filed

Given I open an editor "RA-ZU-ANF25" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "25RAEK"
And I append rows
   | artex    | mge | zgltvon | zgltbis | zraster | einplan |
   | TRA10PS  | 10  | -14     | +7      | WOCHE1  | ja      |
Then field "alternativpos" is modifiable in row 2
And I save the current editor

Given I open an editor "RA-ZU-ANF25" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "25RAEK"
Then field "einplan" has value "ja" in row 2
And I set field "alternativpos" to "ja" in row 2
Then field "einplan" has value "nein" in row 2
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Angebot mit 2 Positionen -> Rahmenauftrag erzeugen -> savings pruefen
#----------------------------------------------------------------------------------------------

# Angebot anlegen
Given I open an editor "ANG-26" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
   | nummer  | 26ANG    |
   | kunde   | 1        |
   | such    | ANG-RA26 |
And I append rows
   | artex   | mge |
   | V1      | 15  |
Then field "savings" has value "ja" in row 1
And I save the current editor

# Rahmenauftrag aus Angebot, savings wird auf "nein" gesetzt
Given I open an editor "RA-ZU-ANG26" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | beleg   | 26ANG  |
   | nummer  | 26RAVK |
Then field "savings" has value "nein" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Uebernahme der Vorlaufzeit aus der Rahmenauftragsposition in Bestellvorschlag
#----------------------------------------------------------------------------------------------

#Artikel mit Beistellung anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "artikelmitbeistellung"
And I set fields
    | such     | Artikelmitbeistellung   |
    | namebspr | Artikel mit Beistellung |
    | lief     | 1                       |
    | efrist   | 10                      |
    | mindest  | 10                      |
    | vorlauf  | 10                      |
    | epr      | 5                       |
And I delete all rows
And I append rows
    | elex | elanzahl | bua                    |
    | E2   | 1        | Lieferantenbeistellung |
And I save the current editor

#Rahmenauftrag anlegen
Given I open an editor "rahmen" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | lief    | 1                             |
    | betreff | Rahmenauftrag mit Beistellung |
And I append rows
    | artex                 | mge | preis | lzeit | vorlauf |
    | artikelmitBeistellung | 100 | 4     | 6     | 3       |
And I save the current editor

#Disposition starten
And I run Scheduling

#Bestellvorschlag aufrufen
Given I open an editor "bestvor" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "artikelmitbeistellung"
And I press button "ladetab"
Then field "zrahmenpos" is not empty in row 1
Then field "lzeit" has value "6" in row 1
# Im Bestellvorschlag wird die Vorlaufzeit fuer ein Beistellteil aus der Rahmenauftragsposition genommen
Then field "vorlauf" has value "3" in row 1
And I close the current editor
