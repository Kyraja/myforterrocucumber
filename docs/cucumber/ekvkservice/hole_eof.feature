# *****************************************************************************
#  Name           : hole_eof.feature
#  Verantwortlich : teampss
#  Funktion       : Test zu Szenarien, in denen die Hole-Phase im EK/VK mit HOLE_EOF abbricht
#
# *****************************************************************************
#
@persistent
Feature: Test zu Szenarien, in denen die Hole-Phase im EK/VK mit HOLE_EOF abbricht
Background:
Given I set the fake date to "02.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario Outline: Stammdaten - Artikel
# ----------------------------------------------------------------------------------------------

Given I open an editor "artikel" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vpr" to "<vpr>"
And I set field "epr" to "<epr>"
And I set field "bsart" to "<bsart>"
And I set field "dispoa" to "<dispoa>"
And I set field "fvhe" to "<fvhe>"
And I set field "vhe" to "<vhe>"
And I save the current editor

Examples:
| such        | namebspr          | vpr  | epr  | bsart            | dispoa          | fvhe | vhe |
| EK-ARTIKEL  | Einkaufsartikel   | 100  | 100  | Fremdbeschaffung | bedarfsbezogen  | 2    | kg  |
| VK-ARTIKEL  | Verkaufsartikel   | 200  | 200  | Eigenfertigung   | auftragsbezogen | 2    | kg  |

# ----------------------------------------------------------------------------------------------
Scenario Outline: Stammdaten - Dienstleistungen
# ----------------------------------------------------------------------------------------------

Given I open an editor "dienstleistung" from table "(Part):(Service)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vpr" to "<vpr>"
And I set field "epr" to "<epr>"
And I set field "vpe" to "h"
And I set field "vhe" to "h"
And I save the current editor

Examples:
| such        | namebspr  | vpr | epr |
| DL-ANALYSE  | Analyse   | 100 | 100 |

# ----------------------------------------------------------------------------------------------
Scenario: Stammdaten - Konsignationslager
# ----------------------------------------------------------------------------------------------

Given I open an editor "Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "NEW" for record ""
And I set field "such" to "LGKONSI"
And I set field "zkonsilg" to "Ja"
And I save the current editor

Given I open an editor "Lager" from table "(Warehouse):(Warehouse)" with command "NEW" for record ""
And I set field "such" to "LAKONSI"
And I set field "lgruppe" to "LGKONSI"
And I save the current editor

Given I open an editor "Lagerplatz" from table "(Location):(Location)" with command "NEW" for record ""
And I set field "such" to "LPKONSI"
And I set field "lager" to "LAKONSI"
And I save the current editor

# ----------------------------------------------------------------------------------------------
#  E I N K A U F
# ----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung (lirelev = false) -> Lieferung
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE001 |
   | lief   | 1      |
And I append rows
   | artikel    | he    | mge | lirelev |
   | EK-ARTIKEL | Stück | 10  | nein    |
And I save the current editor

# Lieferschein
Given opening an editor from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE001" throws the exception ""
Then message "Lieferung nicht möglich. Es gibt keine Positionen, die geliefert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung (rerelev = false) -> Rechnung
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE002" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE002 |
   | lief   | 1      |
And I append rows
   | artikel    | he    | mge | rerelev |
   | EK-ARTIKEL | Stück | 10  | nein    |
And I save the current editor

# Rechnung
Given opening an editor from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE002" throws the exception ""
Then message "Rechnung nicht möglich. Es gibt keine Positionen, die fakturiert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung -> 1. Lieferung komplett (fakt = nein), (offen/gebucht) -> 2. Lieferung
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE003" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE003 |
   | lief   | 1      |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# 1. Lieferschein (offen)
Given I open an editor "1LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE003"
And I set fields
   | nummer | 1LS003 |
   | vom    | .      |
   | fakt   | nein   |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I save the current editor

# 2. Lieferschein, Maske oeffnet sich. Ueberbelieferung moeglich.
Given I open an editor "2LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE003"
And I close the current editor

# 1. Lieferschein buchen
Given I open an editor "1LS003" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "1LS003"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Lieferschein, nichts mehr lieferbar
Given opening an editor from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE003" throws the exception ""
Then message "Lieferung nicht möglich. Es gibt keine Positionen, die geliefert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung -> Lieferung komplett (fakt = nein) -> 1. Rechnung (offen) -> 2. Rechnung
# ----------------------------------------------------------------------------------------------

# 1. Rechnung
Given I open an editor "1RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE003"
And I set fields
   | nummer | 1RE003 |
   | vom    | .      |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Rechnung
Given opening an editor from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE003" throws the exception ""
Then message "Rechnung nicht möglich. Es gibt keine Positionen, die fakturiert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung -> 1. Rechnung komplett (ohne Lagerbew.) (offen/gebucht) -> 2. Rechnung
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE004" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE004 |
   | lief   | 1      |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# 1. Rechnung (offen)
Given I open an editor "1RE004" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE004"
And I set fields
   | nummer | 1RE004 |
   | vom    | .      |
   | fakt   | nein   |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Rechnung - Maske oeffnet sich, aber nichts fakturierbar
Given I open an editor "2RE004" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE004"
Then field "ofmge" has value "0" in row 1
And I close the current editor

# 1. Rechnung buchen
Given I open an editor "1RE004" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "1RE004"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Rechnung - Maske oeffnet sich, aber nichts fakturierbar
Given I open an editor "2RE004" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE004"
Then field "ofmge" has value "0" in row 1
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein (rerelev = false) -> Rechnung
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS005" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS005 |
   | lief   | 1      |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge | rerelev |
   | EK-ARTIKEL | Stück | 10  | nein    |
And I save the current editor

# Rechnung
Given opening an editor from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS005" throws the exception ""
Then message "Rechnung nicht möglich. Es gibt keine Positionen, die fakturiert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein -> 1. Rechnung (offen) -> 2. Rechnung
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS006" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS006 |
   | lief   | 1      |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# 1. Rechnung (offen)
Given I open an editor "1RE006" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS006"
And I set fields
   | nummer | 1RE006 |
   | vom    | .      |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Rechnung
Given opening an editor from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS006" throws the exception ""
Then message "Rechnung nicht möglich. Es gibt keine Positionen, die fakturiert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein -> 1. Ruecklieferschein (offen/gebucht) -> 2. Ruecklieferschein
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS007" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS007 |
   | lief   | 1      |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# 1. Ruecklieferschein (offen)
Given I open an editor "1RLS007" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS007"
And I set fields
   | nummer | 1RLS007 |
   | vom    | .       |
   | ueb    | nein    |
And I press button "offueb" in row 1
And I save the current editor

# 2. Ruecklieferschein
Given opening an editor from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS007" throws the exception ""
Then message "Rücklieferung nicht möglich. Vorgang wurde bereits komplett zurückgeliefert." was displayed

# 1. Ruecklieferschein buchen
Given I open an editor "1RLS007" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "1RLS007"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Ruecklieferschein
Given opening an editor from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS007" throws the exception ""
Then message "Rücklieferung nicht möglich. Vorgang wurde bereits komplett zurückgeliefert." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Rechnung mit Lagerbewegung -> 1. Ruecklieferschein (offen/gebucht) -> 2. Ruecklieferschein
# ----------------------------------------------------------------------------------------------

# Rechnung mit Lagerbewegung
Given I open an editor "1RE008" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE008 |
   | lief   | 1      |
   | fakt   | ja     |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 1. Ruecklieferschein (offen)
Given I open an editor "1RLS008" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "1RE008"
And I set fields
   | nummer | 1RLS008 |
   | vom    | .       |
   | ueb    | nein    |
And I press button "offueb" in row 1
And I save the current editor

# 2. Ruecklieferschein
Given opening an editor from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "1RE008" throws the exception ""
Then message "Rücklieferung nicht möglich. Vorgang wurde bereits komplett zurückgeliefert." was displayed

# 1. Ruecklieferschein buchen
Given I open an editor "1RLS008" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "1RLS008"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Ruecklieferschein
Given opening an editor from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "1RE008" throws the exception ""
Then message "Rücklieferung nicht möglich. Vorgang wurde bereits komplett zurückgeliefert." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein -> Rechnung -> Ruecklieferschein -> 1. Kaufm. Gutschrift (offen/gebucht) -> 2. Kaufm. Gutschrift
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS009" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS009 |
   | lief   | 1      |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# Rechnung
Given I open an editor "1RE009" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS009"
And I set fields
   | nummer | 1RE009 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein
Given I open an editor "1RLS009" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS009"
And I set fields
   | nummer | 1RLS009 |
   | vom    | .       |
   | ueb    | ja      |
And I press button "offueb" in row 1
And I save the current editor

# 1. Kaufm. Gutschrift (offen)
Given I open an editor "1KGS009" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS009"
And I set fields
   | nummer | 1KGS009 |
   | vom    | .       |
   | ueb    | nein    |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Kaufm. Gutschrift
Given opening an editor from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS009" throws the exception ""
Then message "Gutschrift nicht möglich. Es gibt keine Positionen mehr, die gutgeschrieben werden können." was displayed

# 1. Kaufm. Gutschrift buchen
Given I open an editor "1KGS009" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "1KGS009"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Kaufm. Gutschrift - Maske oeffnet sich, aber nichts gutschreibbar
Given I open an editor "2KGS009" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS009"
# Gutzuschreibende Menge zu hoch
Then setting field "mge" to "-1" in row 1 throws the exception "2022"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein -> Ruecklieferschein -> Kaufm. Gutschrift
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS010" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS010 |
   | lief   | 1      |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# Ruecklieferschein
Given I open an editor "1RLS010" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS010"
And I set fields
   | nummer | 1RLS010 |
   | vom    | .       |
   | ueb    | ja      |
And I press button "offueb" in row 1
And I save the current editor

# Kaufm. Gutschrift - Maske oeffnet sich, aber nichts gutschreibbar
Given I open an editor "1KGS010" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS010"
# Gutzuschreibende Menge zu hoch
Then setting field "mge" to "-1" in row 1 throws the exception "2022"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein -> Rechnung -> 1. Wertgutschrift (komplett) (offen/gebucht) -> 2. Wertgutschrift
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS011" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS011 |
   | lief   | 1      |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# Rechnung
Given I open an editor "1RE011" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS011"
And I set fields
   | nummer | 1RE011 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 1. Wertgutschrift (offen)
Given I open an editor "1WGS011" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE011"
And I set fields
   | nummer | 1WGS011 |
   | vom    | .       |
   | ueb    | nein    |
And I press button "offueb" in row 1
And I save the current editor

# 2. Wertgutschrift
# Wertgutschrift erstellen nicht moeglich. Es existiert ein ungebuchter Vorgang.
Given opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE011" throws the exception "2455"
And I close the current editor

# 1. Wertgutschrift buchen
Given I open an editor "1WGS011" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "1WGS011"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Wertgutschrift
Given opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE011" throws the exception ""
Then message "Gutschrift nicht möglich. Es gibt keine Positionen mehr, die gutgeschrieben werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein -> Rechnung -> 1. Wertgutschrift -> 2. Wertgutschrift (alles gutgeschrieben) -> 3. Wertgutschrift
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS012" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS012 |
   | lief   | 1      |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# Rechnung
Given I open an editor "1RE012" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS012"
And I set fields
   | nummer | 1RE012 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 1. Wertgutschrift
Given I open an editor "1WGS012" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE012"
And I set fields
   | nummer | 1WGS012 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-5" in row 1
And I save the current editor

# 2. Wertgutschrift
Given I open an editor "2WGS012" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE012"
And I set fields
   | nummer | 2WGS012 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "-5" in row 1
And I save the current editor

# 3. Wertgutschrift - Maske oeffnet sich, aber nichts gutschreibbar
Given I open an editor "3WGS012" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE012"
# Zu dieser Position ist nichts mehr gutzuschreiben.
Then setting field "mge" to "-1" in row 1 throws the exception "3227"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Rechnung mit Lagerbewegung -> 1. Wertgutschrift (komplett) (offen/gebucht) -> Rechnungskorrektur -> 2. Wertgutschrift
# ----------------------------------------------------------------------------------------------

# Rechnung mit Lagerbewegung
Given I open an editor "1RE013" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE013 |
   | lief   | 1      |
   | fakt   | ja     |
   | vom    | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 1. Wertgutschrift (offen)
Given I open an editor "1WGS013" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE013"
And I set fields
   | nummer | 1WGS013 |
   | vom    | .       |
   | ueb    | nein    |
And I press button "offueb" in row 1
And I save the current editor

# 2. Wertgutschrift
# Wertgutschrift erstellen nicht moeglich. Es existiert ein ungebuchter Vorgang.
Given opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE013" throws the exception "10362"
And I close the current editor

# 1. Wertgutschrift buchen
Given I open an editor "1WGS013" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "1WGS013"
And I set fields
   | ueb    | ja     |
And I save the current editor

# Rechnungskorrektur
Given I open an editor "2RE013" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE013"
And I set fields
   | nummer | 2RE013 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "burekorrektur"
And I press button "offueb" in row 1
And I save the current editor

# 2. Wertgutschrift
Given opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE013" throws the exception ""
Then message "Gutschrift/Rechnung nicht möglich. Es gibt keine Positionen mehr, die gutgeschrieben/berechnet werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Rahmenauftrag (nicht mehr gueltig) -> Bestellung
# ----------------------------------------------------------------------------------------------

# Rahmenauftrag
Given I open an editor "1RA014" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1RA014 |
   | lief   | 1      |
And I append rows
   | artikel    | he    | mge | zgltvon | zgltbis |
   | EK-ARTIKEL | Stück | 10  | -100    | -10     |
And I save the current editor

# Bestellung
Given opening an editor from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record from editor "1RA014" throws the exception ""
Then message "Freigabe nicht möglich. Es gibt keine Positionen, die freigegeben werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung -> 1. Rechnung komplett (mit Lagerbew.) (offen/gebucht) -> 2. Rechnung
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE015" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE015 |
   | lief   | 1      |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# 1. Rechnung mit Lagerbewegung (offen)
Given I open an editor "1RE015" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE015"
And I set fields
   | nummer | 1RE015 |
   | vom    | .      |
   | fakt   | ja     |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Rechnung - Maske oeffnet sich, aber nichts fakturierbar
Given I open an editor "2RE015" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE015"
Then field "ofmge" has value "0" in row 1
And I close the current editor

# 1. Rechnung buchen
Given I open an editor "1RE015" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "1RE015"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Rechnung - Maske oeffnet sich, aber nichts fakturierbar
Given I open an editor "2RE015" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE015"
Then field "ofmge" has value "0" in row 1
And I close the current editor

# ----------------------------------------------------------------------------------------------
#  V E R K A U F
# ----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------
Scenario: Auftrag (lirelev = false) -> Lieferung
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU001" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU001 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge | lirelev |
   | VK-ARTIKEL | Stück | 10  | nein    |
And I save the current editor

# Lieferschein
Given opening an editor from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU001" throws the exception ""
Then message "Lieferung nicht möglich. Es gibt keine Positionen, die geliefert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Auftrag (rerelev = false) -> Rechnung
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU002" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU002 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge | rerelev |
   | VK-ARTIKEL | Stück | 10  | nein    |
And I save the current editor

# Rechnung
Given opening an editor from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU002" throws the exception ""
Then message "Rechnung nicht möglich. Es gibt keine Positionen, die fakturiert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Auftrag -> 1. Lieferung komplett (fakt = nein), (offen/gebucht) -> 2. Lieferung
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU003" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU003 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge |
   | VK-ARTIKEL | Stück | 10  |
And I save the current editor

# 1. Lieferschein (offen)
Given I open an editor "1LS003" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU003"
And I set fields
   | nummer | 1LS003 |
   | tterm  | .      |
   | fakt   | nein   |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I save the current editor

# 2. Lieferschein, Maske oeffnet sich. Ueberbelieferung moeglich.
Given I open an editor "2LS003" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU003"
And I close the current editor

# 1. Lieferschein buchen
Given I open an editor "1LS003" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "1LS003"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Lieferschein, nichts mehr lieferbar
Given opening an editor from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU003" throws the exception ""
Then message "Lieferung nicht möglich. Es gibt keine Positionen, die geliefert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Auftrag -> Lieferung komplett (fakt = nein) -> 1. Rechnung (offen) -> 2. Rechnung
# ----------------------------------------------------------------------------------------------

# 1. Rechnung
Given I open an editor "1RE003" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU003"
And I set fields
   | nummer | 1RE003 |
   | tterm  | .      |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Rechnung
Given opening an editor from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU003" throws the exception ""
Then message "Rechnung nicht möglich. Es gibt keine Positionen, die fakturiert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Auftrag -> 1. Rechnung komplett (ohne Lagerbew.) (offen/gebucht) -> 2. Rechnung
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU004" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU004 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge |
   | VK-ARTIKEL | Stück | 10  |
And I save the current editor

# 1. Rechnung (offen)
Given I open an editor "1RE004" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU004"
And I set fields
   | nummer | 1RE004 |
   | tterm  | .      |
   | fakt   | nein   |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Rechnung - Maske oeffnet sich, aber nichts fakturierbar
Given I open an editor "2RE004" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU004"
Then field "ofmge" has value "0" in row 1
And I close the current editor

# 1. Rechnung buchen
Given I open an editor "1RE004" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "1RE004"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Rechnung - Maske oeffnet sich, aber nichts fakturierbar
Given I open an editor "2RE004" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU004"
Then field "ofmge" has value "0" in row 1
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein (rerelev = false) -> Rechnung
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS005" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS005 |
   | kunde  | 1      |
   | tterm  | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge | rerelev |
   | VK-ARTIKEL | Stück | 10  | nein    |
And I save the current editor

# Rechnung
Given opening an editor from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS005" throws the exception ""
Then message "Rechnung nicht möglich. Es gibt keine Positionen, die fakturiert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein -> 1. Rechnung (offen) -> 2. Rechnung
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS006" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS006 |
   | kunde  | 1      |
   | tterm  | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | VK-ARTIKEL | Stück | 10  |
And I save the current editor

# 1. Rechnung (offen)
Given I open an editor "1RE006" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS006"
And I set fields
   | nummer | 1RE006 |
   | tterm  | .      |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Rechnung
Given opening an editor from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS006" throws the exception ""
Then message "Rechnung nicht möglich. Es gibt keine Positionen, die fakturiert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein -> 1. Ruecklieferschein (offen/gebucht) -> 2. Ruecklieferschein
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS007" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS007 |
   | kunde  | 1      |
   | tterm  | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | VK-ARTIKEL | Stück | 10  |
And I save the current editor

# 1. Ruecklieferschein (offen)
Given I open an editor "1RLS007" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS007"
And I set fields
   | nummer | 1RLS007 |
   | tterm  | .       |
   | ueb    | nein    |
And I press button "offueb" in row 1
And I save the current editor

# 2. Ruecklieferschein
Given opening an editor from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS007" throws the exception ""
Then message "Rücklieferung nicht möglich. Vorgang wurde bereits komplett zurückgeliefert." was displayed

# 1. Ruecklieferschein buchen
Given I open an editor "1RLS007" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "1RLS007"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Ruecklieferschein
Given opening an editor from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS007" throws the exception ""
Then message "Rücklieferung nicht möglich. Vorgang wurde bereits komplett zurückgeliefert." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Rechnung mit Lagerbewegung -> 1. Ruecklieferschein (offen/gebucht) -> 2. Ruecklieferschein
# ----------------------------------------------------------------------------------------------

# Rechnung mit Lagerbewegung
Given I open an editor "1RE008" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE008 |
   | kunde  | 1      |
   | fakt   | ja     |
   | tterm  | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | VK-ARTIKEL | Stück | 10  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 1. Ruecklieferschein (offen)
Given I open an editor "1RLS008" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "1RE008"
And I set fields
   | nummer | 1RLS008 |
   | tterm  | .       |
   | ueb    | nein    |
And I press button "offueb" in row 1
And I save the current editor

# 2. Ruecklieferschein
Given opening an editor from table "(Sales):(Invoice)" with command "RETURN" for record from editor "1RE008" throws the exception ""
Then message "Rücklieferung nicht möglich. Vorgang wurde bereits komplett zurückgeliefert." was displayed

# 1. Ruecklieferschein buchen
Given I open an editor "1RLS008" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "1RLS008"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Ruecklieferschein
Given opening an editor from table "(Sales):(Invoice)" with command "RETURN" for record from editor "1RE008" throws the exception ""
Then message "Rücklieferung nicht möglich. Vorgang wurde bereits komplett zurückgeliefert." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein -> Rechnung -> Ruecklieferschein -> 1. Kaufm. Gutschrift (offen/gebucht) -> 2. Kaufm. Gutschrift
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS009" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS009 |
   | kunde  | 1      |
   | tterm  | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | VK-ARTIKEL | Stück | 10  |
And I save the current editor

# Rechnung
Given I open an editor "1RE009" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS009"
And I set fields
   | nummer | 1RE009 |
   | tterm  | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein
Given I open an editor "1RLS009" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS009"
And I set fields
   | nummer | 1RLS009 |
   | tterm  | .       |
   | ueb    | ja      |
And I press button "offueb" in row 1
And I save the current editor

# 1. Kaufm. Gutschrift (offen)
Given I open an editor "1KGS009" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1RLS009"
And I set fields
   | nummer | 1KGS009 |
   | tterm  | .       |
   | ueb    | nein    |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Kaufm. Gutschrift
Given opening an editor from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1RLS009" throws the exception ""
Then message "Gutschrift nicht möglich. Es gibt keine Positionen mehr, die gutgeschrieben werden können." was displayed

# 1. Kaufm. Gutschrift buchen
Given I open an editor "1KGS009" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "1KGS009"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Kaufm. Gutschrift - Maske oeffnet sich, aber nichts gutschreibbar
Given I open an editor "2KGS009" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1RLS009"
# Gutzuschreibende Menge zu hoch
Then setting field "mge" to "-1" in row 1 throws the exception "2022"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein -> Ruecklieferschein -> Kaufm. Gutschrift
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS010" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS010 |
   | kunde  | 1      |
   | tterm  | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | VK-ARTIKEL | Stück | 10  |
And I save the current editor

# Ruecklieferschein
Given I open an editor "1RLS010" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS010"
And I set fields
   | nummer | 1RLS010 |
   | tterm  | .       |
   | ueb    | ja      |
And I press button "offueb" in row 1
And I save the current editor

# Kaufm. Gutschrift - Maske oeffnet sich, aber nichts gutschreibbar
Given I open an editor "1KGS010" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1RLS010"
# Gutzuschreibende Menge zu hoch
Then setting field "mge" to "-1" in row 1 throws the exception "2022"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein -> Rechnung -> 1. Wertgutschrift (komplett) (offen/gebucht) -> 2. Wertgutschrift
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS011" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS011 |
   | kunde  | 1      |
   | tterm  | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | VK-ARTIKEL | Stück | 10  |
And I save the current editor

# Rechnung
Given I open an editor "1RE011" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS011"
And I set fields
   | nummer | 1RE011 |
   | tterm  | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 1. Wertgutschrift (offen)
Given I open an editor "1WGS011" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE011"
And I set fields
   | nummer | 1WGS011 |
   | tterm  | .       |
   | ueb    | nein    |
And I press button "offueb" in row 1
And I save the current editor

# 2. Wertgutschrift
# Wertgutschrift erstellen nicht moeglich. Es existiert ein ungebuchter Vorgang.
Given opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE011" throws the exception "2455"
And I close the current editor

# 1. Wertgutschrift buchen
Given I open an editor "1WGS011" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "1WGS011"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Wertgutschrift
Given opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE011" throws the exception ""
Then message "Gutschrift nicht möglich. Es gibt keine Positionen mehr, die gutgeschrieben werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Lieferschein -> Rechnung -> 1. Wertgutschrift -> 2. Wertgutschrift (alles gutgeschrieben) -> 3. Wertgutschrift
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS012" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS012 |
   | kunde  | 1      |
   | tterm  | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | VK-ARTIKEL | Stück | 10  |
And I save the current editor

# Rechnung
Given I open an editor "1RE012" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS012"
And I set fields
   | nummer | 1RE012 |
   | tterm  | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 1. Wertgutschrift
Given I open an editor "1WGS012" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE012"
And I set fields
   | nummer | 1WGS012 |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "-5" in row 1
And I save the current editor

# 2. Wertgutschrift
Given I open an editor "2WGS012" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE012"
And I set fields
   | nummer | 2WGS012 |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "-5" in row 1
And I save the current editor

# 3. Wertgutschrift - Maske oeffnet sich, aber nichts gutschreibbar
Given I open an editor "3WGS012" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE012"
# Zu dieser Position ist nichts mehr gutzuschreiben.
Then setting field "mge" to "-1" in row 1 throws the exception "3227"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Rechnung mit Lagerbewegung -> 1. Wertgutschrift (komplett) (offen/gebucht) -> Rechnungskorrektur -> 2. Wertgutschrift
# ----------------------------------------------------------------------------------------------

# Rechnung mit Lagerbewegung
Given I open an editor "1RE013" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE013 |
   | kunde  | 1      |
   | fakt   | ja     |
   | tterm  | .      |
   | ueb    | ja     |
And I append rows
   | artikel    | he    | mge |
   | VK-ARTIKEL | Stück | 10  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 1. Wertgutschrift (offen)
Given I open an editor "1WGS013" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE013"
And I set fields
   | nummer | 1WGS013 |
   | tterm  | .       |
   | ueb    | nein    |
And I press button "offueb" in row 1
And I save the current editor

# 2. Wertgutschrift
# Wertgutschrift erstellen nicht moeglich. Es existiert ein ungebuchter Vorgang.
Given opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE013" throws the exception "10362"
And I close the current editor

# 1. Wertgutschrift buchen
Given I open an editor "1WGS013" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "1WGS013"
And I set fields
   | ueb    | ja     |
And I save the current editor

# Rechnungskorrektur
Given I open an editor "2RE013" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE013"
And I set fields
   | nummer | 2RE013 |
   | tterm  | .      |
   | ueb    | ja     |
And I press button "burekorrektur"
And I press button "offueb" in row 1
And I save the current editor

# 2. Wertgutschrift
Given opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE013" throws the exception ""
Then message "Gutschrift/Rechnung nicht möglich. Es gibt keine Positionen mehr, die gutgeschrieben/berechnet werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Rahmenauftrag (nicht mehr gueltig) -> Auftrag
# ----------------------------------------------------------------------------------------------

# Rahmenauftrag
Given I open an editor "1RA014" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1RA014 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge | zgltvon | zgltbis |
   | VK-ARTIKEL | Stück | 10  | -100    | -10     |
And I save the current editor

# Auftrag
Given opening an editor from table "(Sales):(BlanketOrder)" with command "RELEASE" for record from editor "1RA014" throws the exception ""
Then message "Freigabe nicht möglich. Es gibt keine Positionen, die freigegeben werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Auftrag (neg. Artikelposition) -> Lieferung
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU015" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU015 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge  |
   | VK-ARTIKEL | Stück | -10  |
And I save the current editor

# Lieferschein - Nicht moeglich, weil neg. Artikelpositionen nur an eine Kundenanlieferung angefuegt werden koennen
Given opening an editor from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU015" throws the exception ""
Then message "Lieferung nicht möglich. Es gibt keine Positionen, die geliefert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Auftrag (neg. Artikelposition) (rerelev = false) -> Kundenanlieferung -> Kaufm. Gutschrift
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU016" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU016 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge  | rerelev |
   | VK-ARTIKEL | Stück | -10  | nein    |
And I save the current editor

# Kundenanlieferung
Given I open an editor "1KAN016" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS016            |
   | kunde  | 1                 |
   | lsart  | Kundenanlieferung |
   | ueb    | ja                |
And I set field "beleg" to "1AU016"
And I press button "offueb" in row 1
And I set field "platz" to "LPKONSI" in row 1
And I save the current editor

# Kaufm. Gutschrift
Given opening an editor from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1KAN016" throws the exception ""
Then message "Gutschrift nicht möglich. Es gibt keine Positionen mehr, die gutgeschrieben werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Kundenanlieferung -> 1. Kaufm. Gutschrift (offen / gebucht) -> 2. Kaufm. Gutschrift
# ----------------------------------------------------------------------------------------------

# Kundenanlieferung
Given I open an editor "1KAN017" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1KAN017           |
   | kunde  | 1                 |
   | lsart  | Kundenanlieferung |
   | ueb    | ja                |
And I append rows
   | artikel    | he    | mge  | platz   |
   | VK-ARTIKEL | Stück | -10  | LPKONSI |
And I save the current editor

# 1. Kaufm. Gutschrift (offen)
Given I open an editor "1KGS017" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1KAN017"
And I set fields
   | nummer | 1KGS017 |
   | tterm  | .       |
   | ueb    | nein    |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Kaufm. Gutschrift
Given opening an editor from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1KAN017" throws the exception ""
Then message "Gutschrift nicht möglich. Es gibt keine Positionen mehr, die gutgeschrieben werden können." was displayed

# 1. Kaufm. Gutschrift buchen
Given I open an editor "1KGS017" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "1KGS017"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Kaufm. Gutschrift - Maske oeffnet sich, aber nichts gutschreibbar
Given I open an editor "2KGS009" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1KAN017"
# Gutzuschreibende Menge zu hoch
Then setting field "mge" to "-1" in row 1 throws the exception "2022"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Auftrag -> 1. Rechnung komplett (mit Lagerbew.) (offen/gebucht) -> 2. Rechnung
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU018" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU018 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge |
   | VK-ARTIKEL | Stück | 10  |
And I save the current editor

# 1. Rechnung mit Lagerbewegung (offen)
Given I open an editor "1RE018" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU018"
And I set fields
   | nummer | 1RE018 |
   | tterm  | .      |
   | fakt   | ja     |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Rechnung - Maske oeffnet sich, aber nichts fakturierbar
Given I open an editor "2RE018" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU018"
Then field "ofmge" has value "0" in row 1
And I close the current editor

# 1. Rechnung buchen
Given I open an editor "1RE018" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "1RE018"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Rechnung - Maske oeffnet sich, aber nichts fakturierbar
Given I open an editor "2RE018" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU018"
Then field "ofmge" has value "0" in row 1
And I close the current editor

# ----------------------------------------------------------------------------------------------
#  S E R V I C E
# ----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------
Scenario: Serviceauftrag (lirelev = false) -> Lieferung
# ----------------------------------------------------------------------------------------------

# Serviceauftrag
Given I open an editor "1SA100" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1SA100 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge | lirelev |
   | VK-ARTIKEL | Stück | 10  | nein    |
And I save the current editor

# Lieferschein
Given opening an editor from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record from editor "1SA100" throws the exception ""
Then message "Lieferung nicht möglich. Es gibt keine Positionen, die geliefert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Serviceauftrag (rerelev = false) -> Rechnung
# ----------------------------------------------------------------------------------------------

# Serviceauftrag
Given I open an editor "1SA101" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1SA101 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge | rerelev |
   | VK-ARTIKEL | Stück | 10  | nein    |
And I save the current editor

# Rechnung
Given opening an editor from table "(Sales):(ServiceOrder)" with command "INVOICE" for record from editor "1SA101" throws the exception ""
Then message "Rechnung nicht möglich. Es gibt keine Positionen, die fakturiert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Serviceauftrag -> 1. Lieferung komplett (fakt = nein), (offen/gebucht) -> 2. Lieferung
# ----------------------------------------------------------------------------------------------

# Serviceauftrag
Given I open an editor "1SA102" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1SA102 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge |
   | VK-ARTIKEL | Stück | 10  |
And I save the current editor

# 1. Lieferschein (offen)
Given I open an editor "1LS102" from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record from editor "1SA102"
And I set fields
   | nummer | 1LS102 |
   | tterm  | .      |
   | fakt   | nein   |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I save the current editor

# 2. Lieferschein, Maske oeffnet sich. Ueberbelieferung moeglich.
Given I open an editor "2LS102" from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record from editor "1SA102"
And I close the current editor

# 1. Lieferschein buchen
Given I open an editor "1LS102" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "1LS102"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Lieferschein, nichts mehr lieferbar
Given opening an editor from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record from editor "1SA102" throws the exception ""
Then message "Lieferung nicht möglich. Es gibt keine Positionen, die geliefert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Serviceauftrag -> Lieferung komplett (fakt = nein) -> 1. Rechnung (offen) -> 2. Rechnung
# ----------------------------------------------------------------------------------------------

# 1. Rechnung
Given I open an editor "1RE102" from table "(Sales):(ServiceOrder)" with command "INVOICE" for record from editor "1SA102"
And I set fields
   | nummer | 1RE102 |
   | tterm  | .      |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Rechnung
Given opening an editor from table "(Sales):(ServiceOrder)" with command "INVOICE" for record from editor "1SA102" throws the exception ""
Then message "Rechnung nicht möglich. Es gibt keine Positionen, die fakturiert werden können." was displayed

# ----------------------------------------------------------------------------------------------
Scenario: Reparaturauftrag (rerelev = false) -> Rechnung
# ----------------------------------------------------------------------------------------------

# Reparaturauftrag
Given I open an editor "1RA103" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1RA103 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge | rerelev |
   | DL-ANALYSE | Stück | 10  | nein    |
And I save the current editor

# Rechnung - Maske oeffnet sich, aber ohne Position
Given I open an editor "1RE103" from table "(Sales):(RepairOrder)" with command "INVOICE" for record from editor "1RA103"
Then the table has 0 rows
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Reparaturauftrag -> 1. Rechnung (offen/gebucht) -> 2. Rechnung
# ----------------------------------------------------------------------------------------------

# Reparaturauftrag
Given I open an editor "1RA104" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1RA104 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge |
   | DL-ANALYSE | Stück | 10  |
And I save the current editor

# 1. Rechnung
Given I open an editor "1RE104" from table "(Sales):(RepairOrder)" with command "INVOICE" for record from editor "1RA104"
And I set fields
   | nummer | 1RE104 |
   | tterm  | .      |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung - Maske oeffnet sich, aber mit offener Menge Null.
Given I open an editor "2RE104" from table "(Sales):(RepairOrder)" with command "INVOICE" for record from editor "1RA104"
Then the table has 1 rows
Then field "ofmge" has value "0" in row 1
And I close the current editor

# 1. Rechnung buchen
Given I open an editor "1RE104" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "1RE104"
And I set fields
   | ueb    | ja     |
And I save the current editor

# Rechnung - Maske oeffnet sich, aber mit offener Menge Null.
Given I open an editor "2RE104" from table "(Sales):(RepairOrder)" with command "INVOICE" for record from editor "1RA104"
Then the table has 1 rows
Then field "ofmge" has value "0" in row 1
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Serviceauftrag -> 1. Rechnung komplett (mit Lagerbew.) (offen/gebucht) -> 2. Rechnung
# ----------------------------------------------------------------------------------------------

# Serviceauftrag
Given I open an editor "1SA105" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1SA105 |
   | kunde  | 1      |
And I append rows
   | artikel    | he    | mge |
   | VK-ARTIKEL | Stück | 10  |
And I save the current editor

# 1. Rechnung mit Lagerbewegung (offen)
Given I open an editor "1RE105" from table "(Sales):(ServiceOrder)" with command "INVOICE" for record from editor "1SA105"
And I set fields
   | nummer | 1RE105 |
   | tterm  | .      |
   | fakt   | ja     |
   | ueb    | nein   |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Rechnung - Maske oeffnet sich, aber nichts fakturierbar
Given I open an editor "2RE105" from table "(Sales):(ServiceOrder)" with command "INVOICE" for record from editor "1SA105"
Then field "ofmge" has value "0" in row 1
And I close the current editor

# 1. Rechnung buchen
Given I open an editor "1RE105" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "1RE105"
And I set fields
   | ueb    | ja     |
And I save the current editor

# 2. Rechnung - Maske oeffnet sich, aber nichts fakturierbar
Given I open an editor "2RE105" from table "(Sales):(ServiceOrder)" with command "INVOICE" for record from editor "1SA105"
Then field "ofmge" has value "0" in row 1
And I close the current editor

