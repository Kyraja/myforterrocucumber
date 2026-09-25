# *****************************************************************************
#  Name           : kundenanlieferung.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Cucumber Tests fuer Kundenanlieferungen
#                   Kundenanlieferungen sind Lieferungen im Verkauf vom Kunden,
#                   z.B. wenn eine Maschine in Zahlung gegeben wird.
#                   Wenn beim Reparaturauftrag, das zu reparierende Teil angeliefert wird.
#                   Wenn Behaelter zurueckkommen.
#                   Die Mengen sind negativ. Es gibt einen Lieferschein mit Lieferscheintyp "Kundenanlieferung".
#                   Hier keine Plausi-Pruefungen, sondern nur Anlegen von Vorgaengen.
#                   Gut als Vorgaengertest.
#
# *****************************************************************************
#
@persistent
Feature: Kundenanlieferung
Background:
Given I set the fake date to "02.01.1995"

@Testdaten
Scenario: Testdaten (Stammdaten) anlegen - Konsignationslagerplatz, Dienstleistung
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

# Dienstleistung REPARIEREN anlegen
Given I open an editor "dienstl" from table "(Part):(Service)" with command "STORE" for record "REPARIEREN"
And I set field "such" to "REPARIEREN"
And I set field "namebspr" to "Reparieren"
And I set field "vpr" to "40.00"
And I save the current editor

Scenario: Artikel mit Seriennummernpflicht anlegen
Given I open an editor "EK01_SNR" from table "(Part):(Product)" with command "STORE" for record "EK01_SNR"
And I set fields
    | such          | EK01_SNR                        |
    | namebspr      | Seriennummernpflichtiges Teil 1 |
    | bsart         | Fremdbeschaffung                |
    | dispoa        | bedarfsbezogen                  |
    | chverfolgung  | Seriennummernverfolgung         |
    | chimlager     | ja                              |
    | lief          | TEST                            |
    | efrist        | 3                               |
    | epr           | 5                               |
    | vpr           | 15                              |
And I save the current editor

Given I open an editor "EK02_SNR" from table "(Part):(Product)" with command "STORE" for record "EK02_SNR"
And I set fields
    | such          | EK02_SNR                        |
    | namebspr      | Seriennummernpflichtiges Teil 2 |
    | bsart         | Fremdbeschaffung                |
    | dispoa        | bedarfsbezogen                  |
    | chverfolgung  | Seriennummernverfolgung         |
    | chimlager     | ja                              |
    | lief          | TEST                            |
    | efrist        | 10                              |
    | epr           | 23                              |
    | vpr           | 30                              |
And I save the current editor

Given I open an editor "EK03_SNR" from table "(Part):(Product)" with command "STORE" for record "EK03_SNR"
And I set fields
    | such          | EK03_SNR                        |
    | namebspr      | Seriennummernpflichtiges Teil 3 |
    | bsart         | Fremdbeschaffung                |
    | dispoa        | bedarfsbezogen                  |
    | chverfolgung  | Seriennummernverfolgung         |
    | chimlager     | ja                              |
    | lief          | TEST                            |
    | efrist        | 12                              |
    | epr           | 12                              |
    | vpr           | 15                              |
And I save the current editor


Given I open an editor "EK04_SNR" from table "(Part):(Product)" with command "STORE" for record "EK04_SNR"
And I set fields
    | such          | EK04_SNR                        |
    | namebspr      | Seriennummernpflichtiges Teil 4 |
    | bsart         | Fremdbeschaffung                |
    | dispoa        | bedarfsbezogen                  |
    | chverfolgung  | Seriennummernverfolgung         |
    | chimlager     | ja                              |
    | lief          | TEST                            |
    | efrist        | 10                              |
    | epr           | 25                              |
    | vpr           | 35                              |
And I save the current editor

Scenario: Seriennummern anlegen
Given I create a Lot "C1-EK01_SNR" for Product "EK01_SNR"
Given I create a Lot "C2-EK01_SNR" for Product "EK01_SNR"
Given I create a Lot "C3-EK01_SNR" for Product "EK01_SNR"
Given I create a Lot "C1-EK02_SNR" for Product "EK02_SNR"
Given I create a Lot "C2-EK02_SNR" for Product "EK02_SNR"
Given I create a Lot "C1-EK03_SNR" for Product "EK03_SNR"
Given I create a Lot "C2-EK03_SNR" for Product "EK03_SNR"
Given I create a Lot "C3-EK03_SNR" for Product "EK03_SNR"
Given I create a Lot "C4-EK03_SNR" for Product "EK03_SNR"
Given I create a Lot "C1-EK04_SNR" for Product "EK04_SNR"
Given I create a Lot "C2-EK04_SNR" for Product "EK04_SNR"

Scenario: Bestand mit Seriennnummer zubuchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR    |
    | buart     | Zugang      |
    | beleg     | LB_EK01_SNR |
    | beldat    | .           |
    | wert      | 1.          |
And I delete all rows
And I append rows
    | mge    | platz2 | tcharge2    |
    | 1      | F1     | C1-EK01_SNR |
    | 1      | F2     | C2-EK01_SNR |
    | 1      | F1     | C3-EK01_SNR |
And I save the current editor

Given I open an editor "Lagerbuchung2" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK02_SNR    |
    | buart     | Zugang      |
    | beleg     | LB_EK02_SNR |
    | beldat    | .           |
    | wert      | 1.          |
And I delete all rows
And I append rows
    | mge    | platz2 | tcharge2    |
    | 1      | F1     | C1-EK02_SNR |
And I save the current editor

Given I open an editor "Lagerbuchung3" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK03_SNR    |
    | buart     | Zugang      |
    | beleg     | LB_EK03_SNR |
    | beldat    | .           |
    | wert      | 12.         |
And I delete all rows
And I append rows
    | mge    | platz2 | tcharge2    |
    | 1      | F1     | C1-EK03_SNR |
    | 1      | F1     | C2-EK03_SNR |
    | 1      | F1     | C3-EK03_SNR |
And I save the current editor

Given I open an editor "Lagerbuchung4" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK04_SNR    |
    | buart     | Zugang      |
    | beleg     | LB_EK04_SNR |
    | beldat    | .           |
    | wert      | 25.         |
And I delete all rows
And I append rows
    | mge    | platz2 | tcharge2    |
    | 1      | F1     | C1-EK04_SNR |
    | 1      | F1     | C2-EK04_SNR |
And I save the current editor

@kundenanlieferung
Scenario: Kundenanlieferung Neu ohne Vorgaenger
Given I open an editor "KundenanlieferungNeu" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "such" to "KANLNEU"
And I set field "lsart" to "Kundenanlieferung"
And I set field "ueb" to "ja"
And I append rows
    | artikel | mge  | preis |platz  | verw |
    | V1      | -10  | 5     |KONSILP| AAA  |
Then field "lsart" has value "Kundenanlieferung"
And I save the current editor

@kundenanlieferung
Scenario: Kundenanlieferung mit Auftrag als Vorgaenger
Given I open an editor "KAnlMixAuftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1         |
   | such  | KANLAUFT1 |
   | vom   | .         |
And I append rows
   | artikel | mge  | preis | platz       |
   | V1      | -20  | 6     | KONSILP     |
   | V2      | 13   | 3     | !dontChange |
And I save the current editor

Given I open an editor "KAnlLSAusAuftrag" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "KAnlMixAuftrag"
And I set fields
   | such | LS2 |
   | ueb  | ja  |
Then field "lsart" has value "Lieferschein"
# Nur positive Positionen sind enthalten
Then the table has 1 rows
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "KAnlAusAuftrag" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lsart | Kundenanlieferung |
   | beleg | KANLAUFT1         |
   | such  | KANLS2            |
   | ueb   | ja                |
Then field "lsart" has value "Kundenanlieferung"
Then field "kunde" has value "1"
Then the table has 1 rows
And I press button "offueb" in row 1
Then field "mge" has value "-20" in row 1
And I save the current editor

# Storno Kundenanlieferung
Given I open an editor "SKAnlAusAuftrag" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "KAnlAusAuftrag"

# Sperre des Auftrages KAnlMixAuftrag ueberpruefen
# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Auftrag laesst sich nicht oeffnen: Sperre wegen Storno Kundenanlieferung
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "KANLAUFT1" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "SKAnlAusAuftrag"
And I save the current editor


Scenario: Kundenanlieferung mit MZs
Given I open an editor "KANLMZ1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | ueb   | ja                |
   | lsart | Kundenanlieferung |
   | kunde | 1                 |
   | such  | KANLMZ1           |
   | vom   | .                 |
And I append rows
   | artikel | mge  | preis | platz   |
   | V1      | -30  | 6     | KONSILP |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "platz" to "KONSILP" in row !lastRow
And I set field "zuomge" to "-10" in row !lastRow
And I set field "verw" to "B10" in row !lastRow
And I create a new row at the end of the table
And I set field "platz" to "KONSILP" in row !lastRow
And I set field "zuomge" to "-20" in row !lastRow
And I set field "verw" to "B20" in row !lastRow
And I save the current editor
And I switch the current editor to editor "KANLMZ1"
And I save the current editor

Given I open an editor "KAnlAuftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1         |
   | such  | KANLMZ2   |
   | vom   | .         |
And I append rows
   | artikel | mge  | preis | platz   |
   | V1      | -5   | 6     | KONSILP |
And I save the current editor

Given I open an editor "KANLMZLS2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lsart | Kundenanlieferung |
   | beleg | KANLMZ2           |
   | such  | KANLMZLS2         |
   | ueb   | ja                |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "platz" to "KONSILP" in row !lastRow
And I set field "zuomge" to "-3" in row !lastRow
And I create a new row at the end of the table
And I set field "platz" to "KONSILP" in row !lastRow
And I set field "zuomge" to "-2" in row !lastRow
And I save the current editor
And I switch the current editor to editor "KANLMZLS2"
And I save the current editor

@kundenanlieferung
Scenario: Storno Kundenanlieferung ohne Vorgaenger
Given I open an editor "KANL" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lsart | Kundenanlieferung |
   | kunde | 1                 |
   | such  | KANL              |
   | ueb   | ja                |
And I append rows
    | artikel | mge  | preis |platz   | verw |
    | V1      | -10  | 5     |KONSILP | CCC  |
And I save the current editor

Given I open an editor "KANLST" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "KANL"
Then field "lsart" has value "Storno-Kundenanlieferung"
And I save the current editor

Given I open an editor "KANLVIEW" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "KANL"
Then field "lsart" has value "Stornierte Kundenanlieferung"
And I close the current editor

@kundenanlieferung
Scenario: Storno Kundenanlieferung mit Auftrag als Vorgaenger
Given I open an editor "KAnlAuftrag3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1         |
   | such  | KANL3     |
   | vom   | .         |
And I append rows
   | artikel | mge  | preis | platz       |
   | V1      | -20  | 6     | KONSILP     |
And I save the current editor

Given I open an editor "KAnlAusAuftrag" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lsart | Kundenanlieferung |
   | beleg | KANL3             |
   | such  | KANLS3            |
   | ueb   | ja                |
Then the table has 1 rows
And I press button "offueb" in row 1
Then field "mge" has value "-20" in row 1
And I save the current editor

Given I open an editor "KANLST3" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "KAnlAusAuftrag"
Then field "lsart" has value "Storno-Kundenanlieferung"
And I save the current editor

Given I open an editor "KANLVIEW" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "KAnlAusAuftrag"
Then field "lsart" has value "Stornierte Kundenanlieferung"
And I close the current editor

@kundenanlieferung
Scenario: Kaufm. Gutschrift auf Kundenanlieferung ohne Vorgaenger
Given I open an editor "KANLLS" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde | 1                 |
   | such  | KANLKGS           |
   | lsart | Kundenanlieferung |
   | ueb   | ja                |
And I append rows
    | artikel | mge  | preis |platz   | verw |
    | V1      | -10  | 5     |KONSILP | DDD  |
And I save the current editor

Given I open an editor "KANLKGS" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "KANLLS"
And I set field "such" to "KANLKGS"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "lsart" has value ""
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Kaufm. Gutschrift auf Kundenanlieferung mit Vorgaenger
Given I create a SalesOrder "KANL2" for Customer "1" with Product "V1" and quantity "-5"

Given I open an editor "KANLLS2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lsart | Kundenanlieferung |
   | beleg | KANL2             |
   | such  | KANLLS2           |
   | ueb   | ja                |
Then the table has 1 rows
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "KANLKGS2" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "KANLLS2"
And I set field "such" to "KANLKGS2"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "lsart" has value ""
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |

# Zweiten Benutzer simulieren
Given I'm logged in with password "me"

# 1. Auftrag laesst sich nicht oeffnen: Sperre wegen KGS aus einer Kundenanliefrung
Then opening an editor from table "(Sales):(SalesOrder)" with command "UPDATE" for record "KANL2" throws a locked object exception

# Wieder in die erste Benutzersitzung wechseln
Given I'm logged in with password "sy"
Given I switch the current editor to editor "KANLKGS2"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "KANLLS3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde | 1                 |
   | such  | KANLLS3           |
   | lsart | Kundenanlieferung |
   | ueb   | ja                |
And I append rows
    | artikel | mge  | preis |platz   | verw        |
    | V1      | -7   | 5     |KONSILP | MN-UML-EIGT |
And I save the current editor

Given I open an editor "REKANL" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "KANLLS3"
And I set field "such" to "REKANL"
Then the table has 1 rows
# Kaufm. Gutschrift ist nach Beleg anfuegen vorbelegt
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

@kundenanlieferung
Scenario: Kaufm. Gutschrift Storno
Given I open an editor "KANLLS4" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde | 1                 |
   | such  | KANLLS4 |
   | lsart | Kundenanlieferung |
   | ueb   | ja                |
And I append rows
    | artikel | mge  | preis |platz   | verw |
    | V1      | -10  | 5     |KONSILP | FFF  |
    | V2      | -2   | 5     |KONSILP |      |
And I save the current editor

# Erstellen der kaufm. Gutschrift
Given I invoice the PackingSlip "KANLLS4" with Invoice "KANLKGS4"

# Keine zu berechnenden Mengen mehr
Given I open an editor "REView" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "KANLLS4"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "lsart" has value ""
Then field "mge" has value "0" in row 1
Then field "mge" has value "0" in row 2
And I close the current editor

# Storno der kaufm. Gutschrift
Given I open an editor "KANLKGSS4" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KANLKGS4"
Then field "vorganga" has value "Storno kaufmännische Gutschrift"
Then field "lsart" has value ""
And I save the current editor

# kaufm. Gutschrift -> Storno kaufm. Gutschrift
Given I open an editor "StornierteKGS" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "KANLKGS4"
Then field "vorganga" has value "Stornierte kaufmännische Gutschrift"
And I close the current editor

# Kopieren eines stornierten Vorgangs (Kaufm. Gutschrift) nicht erlaubt
And opening an editor from table "(Sales):(Invoice)" with command "COPY" for record from editor "StornierteKGS" throws the exception "3565"

# Erneutes erstellen der kaufm. Gutschrift - Mengen konnten wieder berechnet werden
Given I open an editor "KANLKGS4B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "KANLLS4"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "lsart" has value ""
Then field "mge" has value "-10" in row 1
Then field "mge" has value "-2" in row 2
And I close the current editor

@serviceabwicklung
@reparaturauftrag
@kundenanlieferung
Scenario: Reparautrauftrag Prozess mit KuAnl und Ruecklieferschein fuer das Leihgeraet
# Vorbereitung der Daten fuer den Servicefall
# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "Trakt" from table "(Part):(Product)" with command "STORE" for record "TRAKTOR"
And I set field "such" to "TRAKTOR"
And I set field "dispoa" to "auftragsb"
And I set field "bsart" to "Eigenfertigung"
And I set field "serpflicht" to "ja"
And I set field "chimlager" to "ja"
And I save the current editor

# Kundengeraet fertigen
Given I open an editor "kugeraet" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "KUGAE"
And I set field "namebspr" to "KUGAE"
And I set field "artikel" to "TRAKTOR"
And I set field "serprodtyp" to "Kundenger"
And I save the current editor

Given I open an editor "AufTraktor" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "such" to "KUGEAUF"
And I append rows
    | artikel | mge  | serprod |
    | TRAKTOR | 1    | KUGAE   |
And I save the current editor

# Disposition starten
And I run Scheduling
# Fertigungsvorschlaege zu BA freigeben
Given I open an editor "freigeben" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "TRAKTOR"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bisuch" to "KUNDENBA" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "freigeben"
And I close the current editor

# BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "1001"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Lieferschein fuer den Verkauf des Kundengeraets erzeugen und buchen
Given I open an editor "lieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AufTraktor"
And I set field "such" to "AUTRAKTOR"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Leihgeraet fertigen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set field "such" to "LEIH"
And I set field "exnum" to "001"
And I set field "artikel" to "TRAKTOR"
And I save the current editor

# Serviceprodukt fuer das Leihgeraet anlegen
Given I open an editor "leihgeraet" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "LHSP"
And I set field "namebspr" to "LHSP"
And I set field "artikel" to "TRAKTOR"
And I set field "serprodtyp" to "Leihgerät"
And I set field "zuplatzlg" to "F2"
And I set field "abplatzlg" to "F2"
And I set field "charge" to id from editor "charge"
And I save the current editor

# Leihgeraet fertigen und auf Lager legen
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "TRAKTOR" in row 1
And I set field "mge" to "1" in row 1
And I set field "bisuch" to "LEIHBA" in row 1
And I set field "serprod" to "LHSP" in row 1
And I set field "platz" to "F2" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

# BA fuer Leihgeraet rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LEIHBA000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Reparaturauftrag anlegen und abarbeiten
Given I open an editor "REPA" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set fields
  | kunde | 1                 |
  | such  | REPA              |
  | vom   | .                 |
And I create a new row at the end of the table
And I set field "artikel" to "reparie" in row !lastRow
And I set field "mge" to "2" in row !lastRow
And I set field "preis" to "90" in row !lastRow
Then field "gtfall" has value "ja" in row !lastRow
And I set field "gtfall" to "nein" in row !lastRow
And I set field "repverr" to "Pauschalpreis inkl. Ersatzteilkosten" in row !lastRow

# Kundengeraet kommt zum reparieren
And I press button "repzug" to open a subeditor for "ZugaKuAnl"
Then field "lsart" has value "Kundenanlieferung"
Then field "platz" has value "KONSILP" in row 1
Then field "mge" has value "-1" in row 1
Then pressing button "mzsubm" in row 1 throws the exception "1272"
And setting field "mge" to "-2" in row 1 throws the exception "1747"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "REPA"

# Leihgeraet wird zum Kunden geschickt
And I press button "repabgl" to open a subeditor for "AbgLeihG"
Then field "lsart" has value "Lieferschein"
And I set field "such" to "LKD-1"
And I set field "ueb" to "ja"
And I set field "umplatz" to "L3F1"
And I save the current editor
And I switch the current editor to editor "REPA"

# Kundengeraet wird wieder zum Kunden geschickt
And I press button "repabg" to open a subeditor for "AbgKunde"
Then field "lsart" has value "Lieferschein"
And I set field "ueb" to "ja"
Then field "platz" has value "KONSILP" in row 1
And I save the current editor
And I switch the current editor to editor "REPA"

# Leihgeraet kommt wieder vom Kunden (Ruecklieferung)
And I press button "repzugl" to open a subeditor for "ZugLeihG"
Then field "lsart" has value "Lieferschein"
Then field "orig^kopf^such" has value "REPA" in row 1
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor
And I switch the current editor to editor "REPA"

# Abrechnen des Reparaturauftrages - Alles geht in die Ablage
And I press button "reanlegen" to open a subeditor for "RepARech"
And I set field "such" to "REPA"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "mge" in row 1 to "mge" from editor "REPA" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
And I switch the current editor to editor "REPA"
And I save the current editor

Then "(Sales):(RepairOrder)" with the editor id "REPA" is filed

@kundenanlieferung
Scenario: Kundenanlieferung bei Konsignationslagerplatz im Kundenstamm

# Kunde anlegen
Given I open an editor "KU1000" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
	| such    | KD_KONSI    |
	| name    | Kunde Konsi |
	| ans     | Kunde Konsi |
	| nort    | Konsihausen |
	| plz     | 10000       |
	| konsi   | F4          |
And I save the current editor

# Auftrag
Given I open an editor "1AU100" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU100    |
   | kunde  | KD_KONSI  |
   | vom    | .         |
And I append rows
   | artikel | mge  | preis | platz   |
   | V1      | -200 | 100   | KONSILP |
And I save the current editor

# Kundenanlieferung aus Auftrag
Given I open an editor "1LS100" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lsart  | Kundenanlieferung |
   | beleg  | 1AU100            |
   | nummer | 1LS100            |
Then field "umplatz" is empty
Then field "umlgruppe" is empty
Then setting field "umplatz" to "F4" throws the exception "203"
Then setting field "umlgruppe" to "KARLSRUHE" throws the exception "203"
And I set field "mge" to "-100" in row 1
And I save the current editor

# Kundenanlieferung aus Auftrag, Kunde bereits eingetragen
Given I open an editor "2LS100" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | KD_KONSI          |
   | lsart  | Kundenanlieferung |
   | beleg  | 1AU100            |
   | nummer | 2LS100            |
Then field "umplatz" is empty
Then field "umlgruppe" is empty
Then setting field "umplatz" to "F4" throws the exception "203"
Then setting field "umlgruppe" to "KARLSRUHE" throws the exception "203"
And I set field "mge" to "-100" in row 1
And I save the current editor

# Kundenanlieferung ohne Auftrag, Kunde vor Lieferscheinart eingetragen
Given I open an editor "3LS100" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 3LS100            |
   | kunde  | KD_KONSI          |
   | lsart  | Kundenanlieferung |
   | vom    | .                 |
And I append rows
   | artikel | mge  | preis | platz   |
   | V1      | -100 | 100   | KONSILP |
Then field "umplatz" is empty
Then field "umlgruppe" is empty
Then setting field "umplatz" to "F4" throws the exception "203"
Then setting field "umlgruppe" to "KARLSRUHE" throws the exception "203"
And I save the current editor

# Kundenanlieferung ohne Auftrag, Lieferscheinart vor Kunde eingetragen
Given I open an editor "4LS100" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 4LS100            |
   | lsart  | Kundenanlieferung |
   | kunde  | KD_KONSI          |
   | vom    | .                 |
And I append rows
   | artikel | mge  | preis | platz   |
   | V1      | -100 | 100   | KONSILP |
Then field "umplatz" is empty
Then field "umlgruppe" is empty
Then setting field "umplatz" to "F4" throws the exception "203"
Then setting field "umlgruppe" to "KARLSRUHE" throws the exception "203"
And I save the current editor

@kundenanlieferung
Scenario: Kundenanlieferung mit Restmengenstorno

# Auftrag
Given I open an editor "1AU101" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU101 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge  | preis |
   | V1      | -10  | 10    |
And I save the current editor

# Kundenanlieferung aus Auftrag
Given I open an editor "1LS101" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lsart  | Kundenanlieferung |
   | beleg  | 1AU101            |
   | nummer | 1LS101            |
   | ueb    | ja                |
And I press button "offueb" in row 1
And I save the current editor

# Kaufm. Gutschrift mit Restmengenstorno
Given I open an editor "1LS101KGS" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS101"
And I set fields
   | nummer | 1KGS101 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-4" in row 1
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1LS101" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "1LS101" is filed

@kundenanlieferung
Scenario: Kundenanlieferung mit Serviceprodukt aus Serviceauftrag

# Serviceprodukt anlegen
Given I open an editor "SP100" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
   | such       | SP101     |
   | namebspr   | SP101     |
   | artikel    | V1        |
   | serprodtyp | Kundenger |
And I save the current editor

# Serviceauftrag anlegen
Given I open an editor "1SA101" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1SA101 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel | mge  | preis | serprod |
   | E2      | -10  | 10    | SP101   |
And I save the current editor

# Kundenanlieferung aus Serviceauftrag
Given I open an editor "1LS101" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lsart  | Kundenanlieferung |
   | beleg  | 1SA101            |
   | nummer | 1LS101            |
   | ueb    | ja                |
And I press button "offueb" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete all rows
And I append rows
	| zuomge   | platz   | serstlsts               |
	| -2       | KONSILP | wird nicht aktualisiert |
	| -3       | KONSILP | wird nicht aktualisiert |
	| -5       | KONSILP | wird nicht aktualisiert |
And I save the current editor
And I switch the current editor to editor "1LS101"
And I save the current editor

@kundenanlieferung
Scenario: Kundenanlieferung mit Seriennummer

# Kundengeraet
Given I open an editor "kugeraetsn" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "KUGSNR1"
And I set field "namebspr" to "KUGSNR1"
And I set field "artikel" to "EK01_SNR"
And I set field "serprodtyp" to "Kundenger"
And I save the current editor

Given I open an editor "1AU102" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "1AU102"
And I set field "kunde" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "EK01_SNR" in row 1
And I set field "mge" to "1" in row 1
And I set field "charge" to "1" in row 1
And I press button "mzsubm" to open a subeditor for "mzuord" in row 1
And I set field "zuomge" to "1" in row 1
And I set field "serprod" to "KUGSNR1" in row 1
And I save the current editor
And I switch the current editor to editor "1AU102"
And I save the current editor

Given I open an editor "1AU102" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU102"
And I set fields
  | nummer | 1LS102 |
  | fakt   | ja     |
  | vom    | .      |
  | tterm  | .      |
  | ueb    | ja     |
And I set field "mge" to "1" in row 1
And I save the current editor

# Reparaturauftrag anlegen und abarbeiten
Given I open an editor "REPA2" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set fields
  | kunde | 1                 |
  | such  | REPA2             |
  | vom   | .                 |
And I create a new row at the end of the table
And I set field "serprod" to "KUGSNR1" in row 1

# Kundengeraet kommt zum Reparieren
And I press button "repzug" to open a subeditor for "ZugaKuAnl2"
Then field "lsart" has value "Kundenanlieferung"
Then field "platz" has value "KONSILP" in row 1
Then field "mge" has value "-1" in row 1
Then field "charge" has value "1" in row 1
Then field "snerneutverwend" has value "ja" in row 1
Then field "snerneutverwend" is modifiable in row 1
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "REPA2"

# Kundengeraet wird wieder zum Kunden geschickt
And I press button "repabg" to open a subeditor for "AbgKunde2"
Then field "lsart" has value "Lieferschein"
And I set field "ueb" to "ja"
Then field "platz" has value "KONSILP" in row 1
Then field "charge" has value "1" in row 1
Then field "snerneutverwend" has value "ja" in row 1
Then field "snerneutverwend" is modifiable in row 1
And I save the current editor
And I switch the current editor to editor "REPA2"

@kundenanlieferung
Scenario: Kundenanlieferung mit Seriennummer und Fehler wegen Bestand

# Kundengeraet
Given I open an editor "kugeraetsn2" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "KUGSNR2"
And I set field "namebspr" to "KUGSNR2"
And I set field "artikel" to "EK01_SNR"
And I set field "serprodtyp" to "Kundenger"
And I save the current editor

Given I open an editor "1AU103" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "1AU103"
And I set field "kunde" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "EK01_SNR" in row 1
And I set field "mge" to "1" in row 1
And I set field "charge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "mzuord" in row 1
And I set field "zuomge" to "1" in row 1
And I set field "serprod" to "KUGSNR2" in row 1
And I save the current editor
And I switch the current editor to editor "1AU103"
And I save the current editor

Given I open an editor "1AU103" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU103"
And I set fields
  | nummer | 1LS103 |
  | fakt   | ja     |
  | vom    | .      |
  | tterm  | .      |
  | ueb    | ja     |
And I set field "mge" to "1" in row 1
And I save the current editor

# Reparaturauftrag anlegen und abarbeiten
Given I open an editor "REPA3" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set fields
  | kunde | 1                 |
  | such  | REPA3             |
  | vom   | .                 |
And I create a new row at the end of the table
And I set field "serprod" to "KUGSNR2" in row 1

# Kundengeraet kommt zum Reparieren
And I press button "repzug" to open a subeditor for "ZugaKuAnl3"
Then field "lsart" has value "Kundenanlieferung"
Then field "platz" has value "KONSILP" in row 1
Then field "mge" has value "-1" in row 1
And I set field "charge" to "3" in row 1
Then field "snerneutverwend" has value "ja" in row 1
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "3628"
And I set field "charge" to "2" in row 1
And I save the current editor
And I switch the current editor to editor "REPA3"
And I save the current editor

# Umbuchungen
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | EK01_SNR  |
    | buart   | Umbuchung |
    | beleg   | 1UMSNR2   |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | charge1 | charge2 |
    | F2    | F1     | 1   | 2       | 2       |
And I save the current editor

# Kundengeraet wird wieder zum Kunden geschickt
Given I open an editor "REPA3" from table "(Sales):(RepairOrder)" with command "UPDATE" for record "REPA3"
And I press button "repabg" to open a subeditor for "AbgKunde3"
Then field "lsart" has value "Lieferschein"
And I set field "ueb" to "ja"
Then field "platz" has value "KONSILP" in row 1
And I set field "charge" to "2" in row 1
Then field "snerneutverwend" has value "ja" in row 1
And I save the current editor
And I switch the current editor to editor "REPA3"

@kundenanlieferung
Scenario: Kundenanlieferung mit Seriennummer ohne Reparaturauftrag

# Lieferschein ohne Auftrag
Given I open an editor "5LS100" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 5LS100            |
   | kunde  | 1                 |
   | vom    | .                 |
And I append rows
   | artikel  | mge | charge | platz |
   | EK01_SNR | 1   | 3      | F1    |
And I set field "ueb" to "ja"
Then field "snerneutverwend" has value "nein" in row 1
Then field "snerneutverwend" is not modifiable in row 1
And I save the current editor

# Kundenanlieferung ohne Auftrag, Kunde vor Lieferscheinart eingetragen
Given I open an editor "5LS200" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 5LS200            |
   | kunde  | KD_KONSI          |
   | lsart  | Kundenanlieferung |
   | vom    | .                 |
And I append rows
   | artikel  | mge  | charge | platz   |
   | EK01_SNR | -1   | 3      | KONSILP |
Then field "snerneutverwend" has value "ja" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Auslieferung zum Kunden nach Reparatur
Given I open an editor "5LS300" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 5LS300  |
   | kunde  | 1       |
   | vom    | .       |
And I append rows
   | artikel  | mge | charge | platz   |
   | EK01_SNR | 1   | 3      | F1      |
And I set field "ueb" to "ja"
Then field "snerneutverwend" has value "nein" in row 1
Then saving the current editor throws the exception "7044"
And I set field "snerneutverwend" to "ja" in row 1
Then saving the current editor throws the exception "3613"
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Weitere Kundenanlieferung
Given I open an editor "5LS400" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 5LS400            |
   | kunde  | KD_KONSI          |
   | lsart  | Kundenanlieferung |
   | vom    | .                 |
And I append rows
   | artikel  | mge  | charge | platz   |
   | EK01_SNR | -1   | 3      | KONSILP |
Then field "snerneutverwend" has value "ja" in row 1
And I set field "ueb" to "ja"
And I save the current editor

@kundenanlieferung
Scenario: Kundenanlieferung mit Seriennummer und Rechnung mit Warenbewegung

# Lieferschein ohne Auftrag
Given I open an editor "6LS100" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 6LS100            |
   | kunde  | 1                 |
   | vom    | .                 |
And I append rows
   | artikel  | mge | charge | platz |
   | EK02_SNR | 1   | 4      | F1    |
And I set field "ueb" to "ja"
And I save the current editor

# Kundenanlieferung ohne Auftrag, Kunde vor Lieferscheinart eingetragen
Given I open an editor "6LS200" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 6LS200            |
   | kunde  | KD_KONSI          |
   | lsart  | Kundenanlieferung |
   | vom    | .                 |
And I append rows
   | artikel  | mge  | charge | platz   |
   | EK02_SNR | -1   | 4      | KONSILP |
Then field "snerneutverwend" has value "ja" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Rechnung mit Auslieferung zum Kunden nach Reparatur
Given I open an editor "6LRE100" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 6RE100            |
   | kunde  | 1                 |
   | vom    | .                 |
   | tterm  | .                 |
   | fakt   | ja                |
And I append rows
   | artikel  | mge | charge | platz   |
   | EK02_SNR | 1   | 4      | KONSILP |
And I set field "ueb" to "ja"
Then field "snerneutverwend" has value "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
Then saving the current editor throws the exception "7044"
And I set field "snerneutverwend" to "ja" in row 1
And I save the current editor


@kundenanlieferung
Scenario: Kundenanlieferung mit Seriennummer und Mzs

# Lieferschein
Given I open an editor "7LS100" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 7LS100 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel  | mge | platz |
   | EK03_SNR | 2   | F1    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "1" in row 1
And I set field "charge" to "6" in row 1
Then field "snerneutverwend" has value "nein" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "1" in row 2
And I set field "charge" to "7" in row 2
Then field "snerneutverwend" has value "nein" in row 1
And I save the current editor
And I switch the current editor to editor "7LS100"
And I set field "ueb" to "ja"
And I save the current editor

# Kundenanlieferung mit Mzs
Given I open an editor "7LS200" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 7LS200            |
   | kunde  | KD_KONSI          |
   | lsart  | Kundenanlieferung |
   | vom    | .                 |
And I append rows
   | artikel  | mge  | preis | platz   |
   | EK03_SNR | -2   | 13    | KONSILP |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "-1" in row 1
And I set field "charge" to "6" in row 1
And I set field "snerneutverwend" to "ja" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "-1" in row 2
And I set field "charge" to "8" in row 2
And I set field "snerneutverwend" to "ja" in row 2
Then saving the current editor throws the exception "3628"
And I set field "charge" to "7" in row 2
# Kennzeichen "Seriennummer erneut verwendet" wieder setzen, da es bei Aenderung der Charge geleert wurde
And I set field "snerneutverwend" to "ja" in row 2
And I save the current editor
And I switch the current editor to editor "7LS200"
And I set field "ueb" to "ja"
And I save the current editor

# Auslieferung zum Kunden nach Reparatur
Given I open an editor "7LS300" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 7LS300 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel  | mge | preis  | platz   |
   | EK03_SNR | 2   | 14     | KONSILP |
And I set field "ueb" to "ja"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "1" in row 1
And I set field "charge" to "6" in row 1
And I set field "platz" to "KONSILP" in row 1
And I set field "snerneutverwend" to "ja" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "1" in row 2
And I set field "charge" to "9" in row 2
And I set field "platz" to "KONSILP" in row 2
And I set field "snerneutverwend" to "ja" in row 2
Then saving the current editor throws the exception "3613"
And I set field "charge" to "7" in row 2
# Kennzeichen "Seriennummer erneut verwendet" wieder setzen nach Aenderung der Charge
And I set field "snerneutverwend" to "ja" in row 2
And I save the current editor
And I switch the current editor to editor "7LS300"
And I save the current editor



@kundenanlieferung
Scenario: Auftrag mit bereits verwendeteter Seriennummer und Mzs

# Kundenanlieferung mit Mzs
Given I open an editor "8LS100" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 8LS100            |
   | kunde  | KD_KONSI          |
   | lsart  | Kundenanlieferung |
   | vom    | .                 |
And I append rows
   | artikel  | mge  | preis | platz   | charge |
   | EK03_SNR | -1   | 13    | KONSILP | 7      |
   | EK03_SNR | -1   | 14    | KONSILP | 6      |
And I set field "ueb" to "ja"
And I save the current editor


# Seriennummer vom geplanten Abgagslagerplatz abbuchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK03_SNR      |
    | buart     | Umbuchung     |
    | beleg     | LUM1_SNR03    |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | platz2   | charge1 | charge2 |
    | 1      | KONSILP  | F1       | 7       | 7       |
And I save the current editor

# Auftrag
Given I open an editor "8AU100" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 8AU100 |
   | kunde  | 1      |
   | vom    | .      |
And I append rows
   | artikel  | mge | platz   |
   | EK03_SNR | 1   | KONSILP |
   | EK03_SNR | 1   | KONSILP |
Then field "snerneutverwend" has value "nein" in row 1
And I set field "charge" to "7" in row 1
Then saving the current editor throws the exception "7044"
And I set field "snerneutverwend" to "ja" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I set field "zuomge" to "1" in row 1
And I set field "charge" to "6" in row 1
And I set field "platz" to "KONSILP" in row 1
Then saving the current editor throws the exception "7044"
And I set field "snerneutverwend" to "ja" in row 1
And I save the current editor
And I switch the current editor to editor "8AU100"
And I save the current editor

# Auslieferung zum Kunden vom Platz nicht moeglich
Given I open an editor "8LS200N" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "8AU100"
And I set fields
   | nummer | 8LS200 |
   | vom    | .      |
   | ueb    | nein   |
And I set field "mge" to "1" in row 1
Then field "charge" has value "7" in row 1
Then field "snerneutverwend" has value "ja" in row 1
Then field "platz" has value "KONSILP" in row 1
# Seriennummer 7 liegt nicht auf Lagerplatz
Then saving the current editor throws the exception "3613"
And I close the current editor

# Seriennummer auf Abgangslagerplatz zubuchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK03_SNR      |
    | buart     | Umbuchung     |
    | beleg     | LUM2_SNR03    |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | platz2   | charge1 | charge2 |
    | 1      | F1       | KONSILP  | 7       | 7       |
And I save the current editor

# Auslieferung zum Kunden auch fuer Seriennummer 7 moeglich
Given I open an editor "8LS200" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "8AU100"
And I set fields
   | nummer | 8LS200 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "1" in row 1
Then field "charge" has value "7" in row 1
Then field "snerneutverwend" has value "ja" in row 1
Then field "platz" has value "KONSILP" in row 1
And I set field "mge" to "1" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
Then field "zuomge" has value "1" in row 1
Then field "charge" has value "6" in row 1
Then field "snerneutverwend" has value "ja" in row 1
And I close the current editor
And I switch the current editor to editor "8LS200"
And I save the current editor

@kundenanlieferung
Scenario: Kundenanlieferung aus Auftrag mit neutraler Textposition und Restmengenstorno

# Zusatzposition
Given I open an editor "ZP001" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
   | such   | NEUTRAL           |
   | zptyp  | neutrale Position |
   | vpr    | 75                |
And I save the current editor

Given I open an editor "KAnlAuftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1         |
   | nummer | 9AU100    |
   | such   | KANLAUFT2 |
   | vom    | .         |
And I append rows
   | artikel | mge           | preis       | platz       | pwert       |
   | V1      | -5            | 30          | KONSILP     | !dontChange |
   | NEUTRAL | !dontChange   | !dontChange | !dontChange | -75         |
And I save the current editor

Given I open an editor "KAnliefAusAuftrag" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "Kundenanlieferung"
And I set field "beleg" to id from editor "KAnlAuftrag2"
And I set fields
   | nummer | 9LS100    |
   | such   | KANLIEF2  |
And I set field "ueb" to "ja"
Then the table has 2 rows
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

Given I open an editor "KAnlRechnung" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "KAnliefAusAuftrag"
And I set fields
  | nummer | 9RE100    |
  | such   | KANLRECH2 |
  | ueb    | ja        |
  | tterm  | .         |
  | budat  | .         |
Then the table has 2 rows
Then field "mge" has value "-5" in row 1
And I set field "mge" to "-5" in row 1
And I set field "pwert" to "-50" in row 2
And I respond with answer "ja" to the dialog with id "191"
And I set field "status" to "*" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "KAnliefAusAuftrag" is filed

@kundenanlieferung
Scenario: Auftrag und Kundenanlieferung mit Seriennummern ueber Mzs

# Auftrag
Given I open an editor "10AU100" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 10AU100 |
   | kunde  | 1       |
   | vom    | .       |
And I append rows
   | artikel  | mge | platz   |
   | EK04_SNR | 2   | F1      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "1" in row 1
And I set field "charge" to "10" in row 1
And I set field "platz" to "F1" in row 1
Then field "snerneutverwend" has value "nein" in row 1
And I set field "zuomge" to "1" in row 2
And I set field "charge" to "11" in row 2
And I set field "platz" to "F1" in row 2
And I save the current editor
And I switch the current editor to editor "10AU100"
And I save the current editor

# Lieferschein aus Auftrag
Given I open an editor "10LS100" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "10AU100"
And I set fields
   | nummer | 10LS100 |
   | vom    | .       |
   | ueb    | ja      |
And I press button "offueb" in row 1
And I save the current editor

# Kundenanlieferung mit Mzs
Given I open an editor "10LS200" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 10LS200            |
   | kunde  | KD_KONSI           |
   | lsart  | Kundenanlieferung  |
   | vom    | .                  |
And I append rows
   | artikel  | mge |
   | EK04_SNR | -2  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "-1" in row 1
And I set field "charge" to "10" in row 1
And I set field "platz" to " KONSILP" in row 1
And I set field "snerneutverwend" to "ja" in row 1
And I set field "zuomge" to "-1" in row 2
And I set field "charge" to "11" in row 2
And I set field "platz" to " KONSILP" in row 2
# Feld snerneutverwend wird in MZs nicht vorbelegt
Then field "snerneutverwend" has value "nein" in row 2
Then saving the current editor throws the exception "7043"
And I set field "snerneutverwend" to "ja" in row 2
And I save the current editor
And I switch the current editor to editor "10LS200"
And I set field "ueb" to "ja"
And I save the current editor

# Seriennummer vom geplanten Abgagslagerplatz abbuchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK04_SNR      |
    | buart     | Umbuchung     |
    | beleg     | LUM1_SNR04    |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | platz2   | charge1 | charge2 |
    | 1      | KONSILP  | F1       | 10      | 10      |
And I save the current editor

# Auftrag
Given I open an editor "10AU200" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 10AU200 |
   | kunde  | 1       |
   | vom    | .       |
And I append rows
   | artikel  | mge | platz   |
   | EK04_SNR | 2   | KONSILP |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "zuomge" to "1" in row 1
And I set field "charge" to "10" in row 1
And I set field "platz" to "KONSILP" in row 1
Then field "snerneutverwend" has value "nein" in row 1
And I set field "snerneutverwend" to "ja" in row 1
And I set field "zuomge" to "1" in row 2
And I set field "charge" to "10" in row 2
And I set field "platz" to "KONSILP" in row 2
Then field "snerneutverwend" has value "nein" in row 2
And I set field "snerneutverwend" to "ja" in row 2
# Seriennummer 10 zweimal eingetragen
Then saving the current editor throws the exception "7044"
And I set field "charge" to "11" in row 2
# Kennzeichen "Seriennummer erneut verwendet" wieder setzen nach Aenderung der Charge
And I set field "snerneutverwend" to "ja" in row 2
And I save the current editor
And I switch the current editor to editor "10AU200"
And I save the current editor

# Auslieferung zum Kunden vom Platz nicht moeglich
Given I open an editor "10LS300N" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "10AU200"
And I set fields
   | nummer | 10LS300 |
   | vom    | .       |
   | ueb    | nein    |
And I press button "offueb" in row 1
# Seriennummer 10 liegt nicht auf LAGERPLATZ
Then saving the current editor throws the exception "3613"
And I close the current editor

# Seriennummer auf Abgangslagerplatz zubuchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK04_SNR      |
    | buart     | Umbuchung     |
    | beleg     | LUM2_SNR04    |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | platz2   | charge1 | charge2 |
    | 1      | F1       | KONSILP  | 10      | 10      |
And I save the current editor

# Auslieferung zum Kunden auch fuer Seriennummer 10 moeglich
Given I open an editor "10LS300" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "10AU200"
And I set fields
   | nummer | 10LS300 |
   | vom    | .       |
   | ueb    | ja      |
And I press button "offueb" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then field "zuomge" has value "1" in row 1
Then field "charge" has value "10" in row 1
Then field "platz" has value "KONSILP" in row 1
Then field "snerneutverwend" has value "ja" in row 1
Then field "zuomge" has value "1" in row 2
Then field "charge" has value "11" in row 2
Then field "platz" has value "KONSILP" in row 1
Then field "snerneutverwend" has value "ja" in row 2
And I save the current editor
And I switch the current editor to editor "10LS300"
And I save the current editor
