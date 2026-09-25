# *****************************************************************************
#  Name           : storno.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Cucumber Tests fuer Stornovorgaenge
#                   Testet im Umfeld Storno, z.B. wenn eine Rechnung mit
#                   INTRASTAT Daten storniert wird.
#                   Infosystem INTRASTATZENTRALE wird aufgerufen.
#
# *****************************************************************************
#
@persistent
Feature: EVS-221
Background:
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

@stammdaten
Scenario: Testdaten fuer Storno Tests anlegen
# Intrastat-Relevanz anpassen - Intrastat in Konfiguration aktivieren
Given I open an editor "konfig" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
And I set field "intra" to "ja"
And I save the current editor

# Finanzamtsdaten aktualisieren
Given I open an editor "region" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "Deutschland"
And I set field "finlakenn" to "BADEN-W"
And I set field "steunr" to "12345678901"
And I save the current editor

# Art des Gescaehaefts anlegen
Given I open an editor "artdesge" from table "(Company):(Summary)" with command "STORE" for record "ADG"
And I set field "such" to "adg"
And I set field "namebspr" to "Sonstiges"
And I set field "schl" to "19"
And I save the current editor
Then field "schl" has value "19"

# EU-Kunde anlegen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "EU"
And I set field "such" to "EU"
And I set field "namebspr" to "EU Werkzeugbau, Rastatt"
And I set field "ans" to "Bayram Werkzeugbau GmbH"
And I set field "str" to "Riedstr. 24-28"
And I set field "plz" to "76437"
And I set field "nort" to "Rastatt"
And I set field "staat" to "Frankreich"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@bayram-corp.de"
And I set field "betreuer" to "."
And I set field "ustid" to "FR56454651"
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I set field "gart" to id from editor "artdesge"
And I save the current editor
Then field "name" has value "EU Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

# Warengruppe anlegen
Given I open an editor "warennr" from table "(Company):(Summary)" with command "STORE" for record "WARENNR"
And I set field "such" to "warennr"
And I set field "namebspr" to "Warennummer"
And I set field "ahnum" to "12345678"
And I set field "sme" to "kg"
And I save the current editor
Then field "ahnum" has value "12345678"

# Artikel mit Intrastatdaten anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "traktor10ps"
And I set field "such" to "traktor10ps"
And I set field "namebspr" to "Rasentraktor 10 PS"
And I set field "vkbez" to "Rasentraktor 10 PS"
And I set field "vbez" to "Rasentraktor 10 PS"
And I set field "ebez" to "Rasentraktor 10 PS"
And I set field "vpr" to "10000"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "intrarel" to "ja"
And I set field "ahnum" to id from editor "warennr"
And I set field "urregion" to "Baden-Wuerttemberg"
And I set field "bsregion" to "Hessen"
And I save the current editor
Then field "such" has value "TRAKTOR10PS"
Then field "bsregion" has value "HESSEN"

# Konsignationslagergruppe
Given I open an editor "konsi-lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KONSI"
And I set field "such" to "KONSI"
And I set field "namebspr" to "Konsignationslagergruppe"
And I set field "zkonsilg" to "ja"
And I save the current editor

# Konsignationslager
Given I open an editor "konsi-lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "KONSI"
And I set field "such" to "KONSI"
And I set field "namebspr" to "Konsignationslager"
And I set field "lgruppe" to "KONSI"
And I save the current editor

# Konsignationslagerplatz
Given I open an editor "konsi-lagerplatz" from table "(Location):(Location)" with command "STORE" for record "KONSI"
And I set field "such" to "KONSI"
And I set field "namebspr" to "Konsignationslagerplatz"
And I set field "lager" to "KONSI"
And I save the current editor

# Zusatzposition vom Typ AU/BE anlegen
Given I open an editor "ZUSPOS" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "such" to "ZUSAUBE"
And I set field "namebspr" to "Zusatzposition AU/BE"
And I set field "zptyp" to "AU/BE-Position,BV"
And I set field "vkbez" to "Zusatzposition AU/BE>"
And I set field "vbez" to "Zusatzposition AU/BE"
And I set field "ebez" to "Zusatzposition AU/BE"
And I set field "vpr" to "20"
And I set field "epr" to "10"
And I save the current editor

# Neutrale Position anlegen
Given I open an editor "Neutral_Euro_Zoll" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "such" to "EUROZOLL"
And I set field "namebspr" to "Euro Zoll"
And I set field "namebspr" to "neutrale Position"
And I set field "vpr" to "1"
And I set field "epr" to "2"
And I save the current editor

# Dienstleistung REPARIEREN anlegen
Given I open an editor "dienstl_reparieren" from table "(Part):(Service)" with command "STORE" for record "REPARIEREN"
And I set fields
| such     | REPARIEREN      |
| num2     | 007S-VK         |
| namebspr | Reparieren      |
| vpr      | 4               |
| epr      | 6               |
| dispoa   | auftragsbezogen |
And I save the current editor

@storno
@intrastat
Scenario: RE stornieren > Intrastatrelevanz = false, falls keine Intrastat-Meldung erfolgte
# Aufrag anlegen
Given I open an editor "auftrag-1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Testcase AU221 (Intrastat-Relevanz anpassen)"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1" in row 1
And I save the current editor

# Rechnung zu Auftrag anlegen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-1"
And I set field "num3" to "1-Rech"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I set field "intramge" to "1,6" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung stornieren
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+1-Rech"
And I set field "num3" to "1-Storno"
And I save the current editor

# Pruefung, ob Intrastat-relevant in stornierter Rechnung entfernt ist
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "VIEW" for record "+1-Rech"
Then field "intrarel" has value "nein" in row 1
And I close the current editor

# Pruefung, ob Intrastat-relevant in Storno-Rechnung entfernt ist
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "VIEW" for record "+1-Storno"
Then field "intrarel" has value "nein" in row 1
And I close the current editor

Scenario: RE stornieren, wenn RE bereits an Intrastat gemeldet
# Auftrag anlegen fuer zweiten Fall, wenn Rechnung bereits an Intrastat gemeldet ist
Given I open an editor "auftrag-2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "BEU2"
And I set field "betreff" to "Testcase AU221 (Intrastat-Relevanz anpassen 2)"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1" in row 1
And I save the current editor

# Rechnung zu Auftrag anlegen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to "BEU2"
And I set field "num3" to "2-Rech"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I set field "gewicht" to "11,3" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Intrastatnachricht durchfuehren
Given I open the infosystem "INTRASTATNACHRICHT"
And I set field "kvorgang" to "+2-Rech"
And I press button "bstart"
And I press button "buttonedi"
And I close the current editor

# Intrastatmeldung durchfuehren
Given I open the infosystem "INTRASTATZENTRALE"
And I press button "aktmonat"
And I press button "bstart"
And I set field "tmark" to "ja" in row 1
And I press button "exportieren"
And I close the current editor

# Pruefung, ob Meldung durchgefuehrt wurde
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "VIEW" for record "+2-Rech"
Then field "intra" is not empty
And I close the current editor

# Rechnung stornieren
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+2-Rech"
And I set field "num3" to "2-Storno"
And I save the current editor
And I close the current editor

# Pruefung, ob Intrastat-relevant in stornierter Rechnung geblieben ist
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "VIEW" for record "+2-Rech"
Then field "intra" has value "0"
Then field "intrarel" has value "ja" in row 1
And I close the current editor

# Pruefung, ob Intrastat-relevant in Storno-Rechnung geblieben ist
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "VIEW" for record "+2-Storno"
Then field "intra" has value "1"
Then field "intrarel" has value "ja" in row 1
And I close the current editor

@EVS-1223
Scenario: STORNO LS bei teilweise vorhandenen Rechnungen
# Ermitteln ob Storno erlaubt ist ueber remge, refrg
Given I open an editor "AuftragSto" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde   | 1      |
  | such    | AUFSTO |
And I append rows
  |artikel  | mge    |
  |v1       | 10     |
  |v2       | 20     |
And I save the current editor

Given I open an editor "ReSto" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AuftragSto"
# ohne Lagerbewegung
And I set fields
  | fakt   |    |
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
And I delete row at position 1
And I set field "mge" to "8" in row !lastRow
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "LiSto" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AuftragSto"
And I set field "ueb" to "Ja"
And I delete row at position 1
And I set field "mge" to "8" in row !lastRow
And I save the current editor

Given I open an editor "LiSto2" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AuftragSto"
And I set field "such" to "LISTO"
And I set field "fakt" to ""
And I delete row at position 1
And I set field "mge" to "10" in row !lastRow
And I save the current editor

# Storno des Lieferscheins nicht moeglich, da der Lieferschein noch nicht gebucht ist
And opening an editor from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LiSto2" throws the exception "7058"

# Lieferschein buchen
Given I open an editor "ListoEdit" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LiSto2"
And I set field "ueb" to "Ja"
And I save the current editor

# Storno des Lieferscheins moeglich
Given I open an editor "LiSto3" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LiSto2"
And I save the current editor

@EVS-1223
Scenario: STORNO LS moeglich da remge im Auftrag richtig berechnet wird
# 1. Auftrag wird erstellt: Menge 10
Given I open an editor "AuftragRemge2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde   | 1        |
  | such    | AUFREMGE |
And I append rows
  |artikel  | mge      |
  |v1       | 10       |
And I save the current editor
Then field "remge" has value "10" in row !lastRow

# 2. LS wird aus Auftrag erstellt
Given I open an editor "LieferungRemge2" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AuftragRemge2"
And I set fields
  | ueb   | ja        |
  | such  | LIEREMGE6 |
  | fakt  | nein      |
And I set field "mge" to "10" in row !lastRow
And I save the current editor

# 3. Auftrag wird berrechnet
Given I open an editor "RechnungRemge" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AuftragRemge2"
And I set fields
  | ueb    | ja      |
  | tterm  | .       |
  | budat  | .       |
  | such   | REEMGE4 |
And I set field "mge" to "10" in row !lastRow
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 4. LS wird mit Storno Funktion storniert
Given I open an editor "LieferungRemge2S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LieferungRemge2"
And I save the current editor

@EVS-1223
Scenario: remge zuruecksetzen bei STORNO LS (bei Rechnung aus Lieferschein = nein)
# Zuruecksetzen der remge bei Storno eines Lieferscheins mit Ueberlieferung
# 1. Auftrag wird erstellt: Menge 10
Given I open an editor "AuftragRemge" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde   | 1        |
  | such    | AUFREMGE |
And I append rows
  | artikel | mge      |
  | v1      | 10       |
And I save the current editor
Then field "remge" has value "10" in row !lastRow

# 2. LS wird aus Auftrag erstellt Menge 12
Given I open an editor "LieferungRemge" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AuftragRemge"
And I set fields
  | ueb   | ja       |
  | such  | LIEREMGE |
  | fakt  | nein     |
And I set field "mge" to "12" in row !lastRow
And I save the current editor
Then field "mge" has value equal to field "remge" from editor "AuftragRemge" in row !lastRow

# 3. Zeilenlupe in Auftrag zeigt offene RE Mengen von 12 an (richtig)
Given I open an editor "AuftragRemge" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AuftragRemge"
Then field "remge" has value "12" in row !lastRow
And I close the current editor

# 4. LS wird mit Storno Funktion storniert
Given I open an editor "LiefStorno" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LieferungRemge"
And I save the current editor

# 5. Zeilenlupe in Auftrag zeigt immer noch offene RE Menge mit 12 an
Given I open an editor "AuftragRemge" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AuftragRemge"
Then field "remge" has value "10" in row !lastRow
And I close the current editor

# 6. LS wird mit richtiger Menge von 15 erstellt und gebucht
Given I open an editor "LieferungRemge" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AuftragRemge"
And I set fields
  | ueb  | ja       |
  | such | LIEREMGE |
  | fakt | nein     |
And I set field "mge" to "15" in row !lastRow
And I save the current editor

# 7. Zeilenlupe von Auftrag zeigt nun offene RE Menge von 17 an
Given I open an editor "AuftragRemge" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AuftragRemge"
Then field "remge" has value "15" in row !lastRow
And I close the current editor

@EVS-1223
Scenario: STORNO LS bei Rechnung aus Lieferschein = nein und vielen kleinen RE
# 1. Auftrag wird erstellt: Menge 10
Given I open an editor "AuftragGFVRE" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde   | 1        |
  | such    | AUFGFVRE |
And I append rows
  | artikel | mge      |
  | v1      | 10       |
Then field "remge" has value "10" in row !lastRow
And I save the current editor

# 2 LS werden zum Auftrag erstellt
Given I open an editor "LieferGFVRE" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AuftragGFVRE"
And I set fields
  | ueb   | ja        |
  | such  | LSGFVRE   |
  | fakt  | nein      |
And I set field "mge" to "6" in row !lastRow
And I save the current editor

# remge im Auftrag pruefen
Then field "remge" from editor "AuftragGFVRE" in row !lastRow has value "10"

Given I open an editor "LieferGFVRE2" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AuftragGFVRE"
And I set fields
  | ueb   | ja        |
  | such  | LSGFVRE   |
# Ueberliefert um 2
And I set field "mge" to "6" in row !lastRow
And I save the current editor

# remge im Auftrag pruefen
Then field "remge" from editor "AuftragGFVRE" in row !lastRow has value "12"

# 3 Rechnungen a 4 Stueck zur Position erstellen
Given I open an editor "REGFVRE1" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AuftragGFVRE"
And I set fields
  | such   | REGFVRE |
  | ueb    | ja      |
  | tterm  | .       |
  | budat  | .       |
And I set field "mge" to "4" in row !lastRow
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# remge im Auftrag pruefen
Then field "remge" from editor "AuftragGFVRE" in row !lastRow has value "8"

Given I open an editor "REGFVRE2" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AuftragGFVRE"
And I set fields
  | such   | REGFVRE2 |
  | ueb    | ja       |
  | tterm  | .        |
  | budat  | .        |
And I set field "mge" to "4" in row !lastRow
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# remge im Auftrag pruefen
Then field "remge" from editor "AuftragGFVRE" in row !lastRow has value "4"

Given I open an editor "REGFVRE3" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AuftragGFVRE"
And I set fields
  | such   | REGFVRE3 |
  | ueb    | ja       |
  | tterm  | .        |
  | budat  | .        |
And I set field "mge" to "4" in row !lastRow
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# remge im Auftrag pruefen
Then field "remge" from editor "AuftragGFVRE" in row !lastRow has value "0"

Given I open an editor "REGFVRE3S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "REGFVRE3"
And I save the current editor

# remge im Auftrag pruefen
 Then field "remge" from editor "AuftragGFVRE" in row !lastRow has value "4"

Given I open an editor "REGFVRE2S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "REGFVRE2"
And I save the current editor

# remge im Auftrag pruefen
Then field "remge" from editor "AuftragGFVRE" in row !lastRow has value "8"

# Storno des Lieferscheins 1
Given I open an editor "LieferGFVRE2S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LieferGFVRE2"
And I save the current editor

# remge im Auftrag pruefen
Then field "remge" from editor "AuftragGFVRE" in row !lastRow has value "6"

# Storno des Lieferscheins 2
Given I open an editor "LieferGFVRES" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LieferGFVRE"
And I save the current editor


Scenario: STORNO Kundenanlieferung mit Fakturierung ueber den Auftrag

Given I open an editor "1AU100" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | nummer   | 1AU100 |
  | kunde    | 1      |
And I append rows
  | artikel  | mge    |
  | V1       | -10    |
And I save the current editor

Given I open an editor "1LS100" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | lsart  | Kundenanlieferung |
  | beleg  | !1AU100^id        |
  | nummer | 1LS100            |
  | fakt   | nein              |
  | ueb    | ja                |
  | vom    | .                 |
And I set field "mge" to "-10" in row !lastRow
And I set field "platz" to "KONSI" in row !lastRow
And I save the current editor

Given I open an editor "1RE100" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU100"
And I set fields
  | nummer | 1RE100 |
  | ueb    | ja     |
  | tterm  | .      |
  | budat  | .      |
And I set field "mge" to "-10" in row !lastRow
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Storno des Lieferscheins
Given I open an editor "1LS100S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS100"
And I set field "nummer" to "1LS100S"
And I save the current editor

Scenario: LS mit 0 Rechnung in die Ablage und wiederbeleben
# Beispiel im VK
#
#         RE91  RE912---------> RE912ST   RE913
#         (6)   (!0)            Storno    (4!)
#         /    /0-Rechnung      LS lebt   LS wieder in Ablage
#        /    / LS abgelegt              /
#       /    /                          /
# LS91 ------------------------------------
#

# LS erstellen
Given I open an editor "LS91" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | LS91  |
And I append rows
   | artikel | mge | preis |
   | V1      | 10  |    10 |
And I save the current editor

# Teilrechnung zum LS
Given I open an editor "RE91" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS91"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RE91  |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# remge im LS pruefen
Given I open an editor "LS91V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS91"
Then field "remge" has value "4" in row 1
And I close the current editor

# 0-Rechnung zum LS
Given I open an editor "RE912" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS91"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RE912 |
Then field "mge" has value "4" in row 1
And I set field "mge" to "0" in row 1
# Wollen Sie wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
#And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# remge im LS pruefen
Given I open an editor "LS91V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS91"
Then field "remge" has value "0" in row 1
And I close the current editor

# LS geht in die Ablage
Then "(Sales):(PackingSlip)" with the editor id "LS91" is filed

# Storno 0-Rechnung
Given I open an editor "RE912ST" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE912"
And I save the current editor

# Storno RE pruefen
Given I open an editor "RE912STV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE912ST"
Then the table has 1 rows
Then field "mge" has value "0" in row 1
Then field "status" has value "*" in row 1
And I close the current editor

# remge im LS pruefen
Given I open an editor "LS91V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS91"
Then field "remge" has value "4" in row 1
And I close the current editor

# LS ist wieder lebendig
Then "(Sales):(PackingSlip)" with the editor id "LS91" is not filed

# Teilrechnung zum LS (Rest)
Given I open an editor "RE913" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS91"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RE913 |
Then field "mge" has value "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "LS91" is filed

Scenario: KGS mit 2 Positionen mit einer 0* Position abschliessen (RLS ablegen, wiederbeleben)
# Beispiel im VK
#
#        RE1041 RE1042
#        (50)   (30)
#        /     /
#       /     /
# BE104 --------> LS104 ---> RLS104 --> KGS104-------> KGS104ST
# (100)           (90)       (85) \     (-50)          Storno
#                                  \    (-15!)->0*     RLS wieder offen
#                                   \   RLS -> Ablage
#                                    \
#                                     ----------------------> KGS1042 ---->
#                                      \                       (-50!)        (0*!)
#                                       \                      (-15!) -> -10
#                                        \
#                                         -------------------------------------> KGS1043
#                                                                                (-5!) -> 0*!
#                                                                                   RLS -> Ablage
#

# Bestellung anlegen
Given I create a PurchaseOrder "BE104" for Vendor "1" with Product "E1" and quantity "100" and price "3"

# Berechne (Teil) die Bestellung
Given I open an editor "RE1041" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE104"
And I set fields
   | ebeleg | RE1041 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | RE1041 |
And I set field "mge" to "50" in row 1
And I set field "preis" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Berechne (2. Teil) die Bestellung
Given I open an editor "RE1042" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE104"
And I set fields
   | ebeleg | RE1042 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | RE1042 |
And I set field "mge" to "30" in row 1
And I set field "preis" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Liefere die Bestellung (Teil)
Given I open an editor "LS104" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE104"
And I set fields
   | ebeleg | LS104 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | LS104 |
And I set field "mge" to "90" in row 1
And I save the current editor

# Teil-Ruecklieferung des LS
Given I open an editor "RLS104" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS104"
And I set fields
   | ebeleg | RLS104 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | RLS104 |
And I set field "mge" to "-85" in row 1
And I save the current editor

# remge im RLS pruefen
Given I open an editor "RLS91V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS104"
Then field "remge" has value "-65" in row 1
And I close the current editor

# RLS gutschreiben
Given I open an editor "KGS104" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS104"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then table has values
    | art  | mge | preis | remge | herkunft^kopf^such |
    | E1   | -45 |  4.00 |   -45 | RE1041             |
    | E1   | -20 |  5.00 |   -20 | RE1042             |
And I set fields
   | ebeleg | KGS104 |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | KGS104 |
# 2. Pos mit 0* abschliessen
And I set field "mge" to "0" in row 2
# Wollen Sie wirklich stornieren?#
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# RLS geht in die Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS104" is filed

# remge im RLS pruefen
Given I open an editor "RLS91V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS104"
Then field "remge" has value "0" in row 1
And I close the current editor

# Storno 0-Rechnung
Given I open an editor "RE104ST" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS104"
Then field "intra" has value "0"
And I save the current editor

# RLS kommt aus der Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS104" is not filed

# remge im RLS pruefen
Given I open an editor "RLS91V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS104"
Then field "remge" has value "-65" in row 1
And I close the current editor

# RLS erneut gutschreiben
Given I open an editor "KGS1042" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS104"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then table has values
    | art  | mge | preis | remge | herkunft^kopf^such |
    | E1   | -45 |  4.00 |   -45 | RE1041             |
    | E1   | -20 |  5.00 |   -20 | RE1042             |
# Falsch muesste -15 sein!
#    | E1   | -15 |  5.00 |   -15 | RE1042             |
And I set fields
   | ebeleg | KGS1042 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
   | such   | KGS1042 |
# Nur einen Teil gutschreiben
And I set field "mge" to "-10" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# RLS geht wieder in die Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS104" is not filed

# remge im RLS pruefen
Given I open an editor "RLS91V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS104"
Then field "remge" has value "-10" in row 1
And I close the current editor

# RLS 0 Gutschrift zum Ablegen
Given I open an editor "KGS1043" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS104"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "mge" has value "-10" in row 1
And I set fields
   | ebeleg | KGS1043 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
   | such   | KGS1043 |
And I set field "mge" to "0" in row 1
# Wollen Sie wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

# RLS geht wieder in die Ablage
Then "(Purchasing):(PackingSlip)" with the editor id "RLS104" is filed

# remge im RLS pruefen
Given I open an editor "RLS91V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS104"
Then field "remge" has value "0" in row 1
And I close the current editor

Scenario: Verkauf RE mit Zusatzposition AUBE mit negativer Menge stornieren

# Rechnung mit Warenbewegung anlegen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "num3" to "3-Rech"
And I set field "ueb" to "ja"
And I append rows
  |artikel  | mge   | intrarel |
  | V1      | 20    | nein     |
  | ZUSAUBE | -2    | nein     |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung stornieren
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+3-Rech"
And I set field "num3" to "3-Storno"
And I save the current editor

Scenario: Einkauf RE mit Zusatzposition AUBE mit negativer Menge stornieren

# Bestellung anlegen
Given I open an editor "BE105" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "such" to "BE105"
And I set field "lief" to "1"
And I set field "num4" to "105-Rech"
And I append rows
  |artikel  | mge   | intrarel |
  | V1      | 10    | nein     |
  | ZUSAUBE | -1    | nein     |
And I save the current editor

# Rechnung zur Bestellung
Given I open an editor "RE105" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE105"
And I set fields
   | ebeleg | RE105 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RE105 |
And I set field "mge" to "10" in row 1
And I set field "mge" to "-11" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung stornieren
Given I open an editor "RE105ST" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE105"
And I save the current editor

Scenario: Storno eines Umlagerlieferscheins mit Chargen

# Chargen anlegen
Given I create a Lot "CH-V3-1" for Product "V3"
Given I create a Lot "CH-V3-2" for Product "V3"

# Umlagerungsliefershchein anlegen
Given I open an editor "1LS101" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde   | 1      |
   | nummer  | 1LS101 |
   | vom     | .      |
   | umplatz | L3F1   |
And I append rows
   | artex   | mge |
   | V3      | 10  |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
   | lpsuch | zuomge | charge  | verw      |
   | F1     | 10     | CH-V3-1 | VERW-V3-1 |
And I save the current editor
And I switch the current editor to editor "1LS101"
And I save the current editor

# Umlagerungslieferschein aendern und buchen
Given I open an editor "1LS101" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS101"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "charge" to "CH-V3-2" in row 1
And I set field "verw" to "VERW-V3-2" in row 1
And I save the current editor
And I switch the current editor to editor "1LS101"
And I set field "ueb" to "ja"
And I save the current editor

# Storno des Umlagerungslieferscheins
Given I open an editor "1LS101S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS101"
And I set fields
   | nummer | 1LS101S |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK Bestellung, RE ohne Lagerbewegung buchen, Status-Feld in BE schreibgeschuetzt
#----------------------------------------------------------------------------------------------
# Bestellung anlegen
Given I open an editor "BE106" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1     |
   | such   | BE106 |
   | num4   | 106BE |
And I append rows
  |artikel   | mge         | preis       | rerelev     |
  | E1       | 10          | 9.99        | ja          |
  | EUROZOLL | !dontChange | !dontChange | !dontChange |
  | E1       | 1           | 0.00        | nein        |
And I save the current editor

# Bestellung - Status-Feld pruefen
Given I open an editor "BE106" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE106"
Then field "status" is modifiable in row 1
Then field "status" is modifiable in row 2
Then field "status" is modifiable in row 3
And I close the current editor

# Rechnung zur Bestellung
Given I open an editor "RE106" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE106"
And I set fields
   | ebeleg | RE106EK |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
   | such   | RE106EK |
   | fakt   | nein    |
And I press button "offueb" in row 1
Then field "pwert" has value "2.00" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Bestellung - Status-Feld pruefen
Given I open an editor "BE106" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE106"
Then field "status" is not modifiable in row 1
Then field "status" is modifiable in row 2
Then field "status" is modifiable in row 3
And I set field "mge" to "12" in row 1
Then field "status" is modifiable in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK Auftrag, RE ohne Lagerbewegung buchen, Status-Feld in AU schreibgeschuetzt
#----------------------------------------------------------------------------------------------
# Auftrag anlegen
Given I open an editor "AU106" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | such   | AU106 |
   | num3   | 106AU |
And I append rows
  |artikel   | mge         | preis       | rerelev      |
  | V1       | 10          | 9.99        | ja           |
  | ZUSAUBE  | 2           | 1.11        | ja           |
  | EUROZOLL | !dontChange | !dontChange | !dontChange  |
  | V1       | 1           | 0.00        | nein         |
And I save the current editor

# Auftrag - Status-Feld pruefen
Given I open an editor "AU106" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU106"
Then field "status" is modifiable in row 1
Then field "status" is modifiable in row 2
Then field "status" is modifiable in row 3
Then field "status" is modifiable in row 4
And I close the current editor

# Rechnung zur Auftrag
Given I open an editor "RE106VK" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU106"
And I set fields
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
   | such   | RE106VK |
   | fakt   | nein    |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
Then field "pwert" has value "1.00" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Auftrag - Status-Feld pruefen
Given I open an editor "AU106" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU106"
Then field "status" is not modifiable in row 1
Then field "status" is not modifiable in row 2
Then field "status" is modifiable in row 3
Then field "status" is modifiable in row 4
And I set field "mge" to "12" in row 1
And I set field "mge" to "3" in row 2
Then field "status" is modifiable in row 1
Then field "status" is modifiable in row 2
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Einkauf RE mit Zusatzposition AUBE, Dienstleistung mit negativer Menge stornieren
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE107" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | lief   | 1     |
   | ebeleg | RE107 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RE107 |
And I append rows
  |artikel     | mge | intrarel |
  | E1         |  1  | nein     |
  | ZUSAUBE    | -1  | nein     |
  | REPARIEREN | -1  | nein     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung stornieren
Given I open an editor "RE107ST" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE107"
And I save the current editor
