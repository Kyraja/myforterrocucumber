# *****************************************************************************************
#  Name           : eigene_bankverbindungen.feature
#  Verantwortlich : teampss
#  Funktion       : Test der eigenen Bankverbindungen in den Objekten Betriebsdaten,
#                   Kunde, Lieferant und Rechnung
#  Beschreibung   :
#  Testet die Skipfelder und Plausibilitaetspruefungen bei den Bankverbindungsfeldern
#  in den Objekten Betriebsdaten, Kunde, Lieferant und Rechnung.
#
# *****************************************************************************************
#
@persistent
Feature: Test der eigenen Bankverbindungen in den Objekten Betriebsdaten, Kunde, Lieferant und Rechnung
Background:
Given I set the fake date to "02.01.1995"

# -----------------------------------------------------------------------------------------
Scenario: Ein- und Verkaufsrechnung zum Testen der Bankverbindungsfelder anlegen
# -----------------------------------------------------------------------------------------

Given I open an editor "1RE001" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE001 |
	| kunde  | 1      |
   | ueb    | nein   |
   | tterm  | .      |
And I append rows
   | artikel | pwert |
   | TEXT    |   100 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1RE001" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE001 |
	| lief   | 1      |
   | ueb    | nein   |
   | vom    | .      |
And I append rows
   | artikel | pwert |
   | TEXT    |   100 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# -----------------------------------------------------------------------------------------
Scenario Outline: Test der Bankverbindungsfelder in den Objekten Betriebsdaten, Kunde, Lieferant und Rechnung
# -----------------------------------------------------------------------------------------

Given I open an editor "<editor>" from table "<gruppe>" with command "UPDATE" for record "<nummer>"
# Fehler: Ungueltiger Feldwert, weil die Bankverbindung keine IBAN hat (Encode-Bedingung)
Then setting field "eigbverb1" to "EIGENE_BV6" throws the exception "1361"
# Fehler: Ungueltiger Feldwert, weil die Bankverbindung keine Konto der Art "Bankkonto" hat (Encode-Bedingung)
Then setting field "eigbverb1" to "EIGENE_BV7" throws the exception "1361"
And I set field "eigbverb1" to "EIGENE_BV1"
# Fehler: Bankverbindung ist schon vorhanden
Then setting field "eigbverb2" to "EIGENE_BV1" throws the exception "3607"
Then setting field "eigbverb3" to "EIGENE_BV1" throws the exception "3607"
# Fehler: Bankverbindung mit identischer IBAN ist schon vorhanden
Then setting field "eigbverb2" to "EIGENE_BV4" throws the exception "3609"
And I set field "eigbverb2" to "EIGENE_BV3"
# Fehler: Bankverbindung mit identischem Konto ist schon vorhanden
Then setting field "eigbverb3" to "EIGENE_BV5" throws the exception "3608"
And I set field "eigbverb2" to "EIGENE_BV2"
And I set field "eigbverb3" to "EIGENE_BV3"
# Skip-Felder
Then field "eigbverbiban1" has value "DE02 6005 0101 0002 0343 04"
Then field "eigbverbbname1" has value "Deutsche Bausparkasse Badenia"
Then field "eigbverbiban2" has value "DE02 7002 0270 0010 1086 69"
Then field "eigbverbbname2" has value "Stadtsparkasse Muenchen"
Then field "eigbverbiban3" has value "DE02 7001 0080 0030 8768 08"
Then field "eigbverbbname3" has value "Sparkasse Soest"
And I save the current editor

Examples:
| editor        | gruppe                  | nummer |
| betriebsdaten | (Company):(CompanyData) | 1      |
| kunde         | (Customer):(Customer)   | 1      |
| lieferant     | (Vendor):(Vendor)       | 1      |
| ek-rechnung   | (Purchasing):(Invoice)  | 1RE001 |
| vk-rechnung   | (Sales):(Invoice)       | 1RE001 |

# -----------------------------------------------------------------------------------------
Scenario: Vorbelegung der Bankverbindungen in Verkaufsrechnungen
# -----------------------------------------------------------------------------------------

Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "1"
And I set field "eigbverb1" to ""
And I set field "eigbverb2" to ""
And I set field "eigbverb3" to ""
And I save the current editor

Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "004"
And I set field "eigbverb1" to "EIGENE_BV4"
And I save the current editor

Given I open an editor "1RE002" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE002 |
	| kunde  | 1      |
   | ueb    | nein   |
   | tterm  | .      |
And I append rows
   | artikel | pwert |
   | TEXT    |   100 |
# Bankverbindungen kommen aus den Betriebsdaten
Then field "eigbverb1" has value "14610"
Then field "eigbverb2" has value "14611"
Then field "eigbverb3" has value "14612"
And I set field "kunde2" to "004"
# Bankverbindungen kommen aus dem Rechnungskunden
Then field "eigbverb1" has value "14613"
Then field "eigbverb2" is empty
Then field "eigbverb3" is empty
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# -----------------------------------------------------------------------------------------
Scenario: Vorbelegung der Bankverbindungen in Verkaufsrechnungen, Rechnungskunde kommt aus dem Lieferschein
# -----------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS003" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS001 |
	| kunde  | 1      |
	| kunde2 | 004    |
   | ueb    | ja     |
And I append rows
   | artikel | mge   |
   | V1      |   100 |
And I save the current editor

# Rechnung
Given I open an editor "1RE003" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS003"
And I set fields
   | nummer | 3RE001 |
   | ueb    | nein   |
   | tterm  | .      |
Then field "eigbverb1" has value "14613"
Then field "eigbverb2" is empty
Then field "eigbverb3" is empty
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# -----------------------------------------------------------------------------------------
Scenario: Vorbelegung der Bankverbindungen in Einkaufsrechnungen
# -----------------------------------------------------------------------------------------

Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "1"
And I set field "eigbverb1" to ""
And I set field "eigbverb2" to ""
And I set field "eigbverb3" to ""
And I save the current editor

Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "004"
And I set field "eigbverb1" to "EIGENE_BV4"
And I save the current editor

Given I open an editor "1RE002" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE002 |
	| lief   | 1      |
   | ueb    | nein   |
   | vom    | .      |
And I append rows
   | artikel | pwert |
   | TEXT    |   100 |
# Bankverbindungen kommen aus den Betriebsdaten
Then field "eigbverb1" has value "14610"
Then field "eigbverb2" has value "14611"
Then field "eigbverb3" has value "14612"
And I set field "lief2" to "004"
# Bankverbindungen kommen aus dem Rechnungssteller
Then field "eigbverb1" has value "14613"
Then field "eigbverb2" is empty
Then field "eigbverb3" is empty
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# -----------------------------------------------------------------------------------------
Scenario: Vorbelegung der Bankverbindungen in Einkaufsrechnungen, Rechnungssteller kommt aus dem Lieferschein
# -----------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS003" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS001 |
	| lief   | 1      |
	| lief2  | 004    |
   | ueb    | ja     |
   | vom    | .      |
And I append rows
   | artikel | mge   |
   | E2      |   100 |
And I save the current editor

# Rechnung
Given I open an editor "1RE003" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS003"
And I set fields
   | nummer | 3RE001 |
   | ueb    | nein   |
   | vom    | .      |
Then field "eigbverb1" has value "14613"
Then field "eigbverb2" is empty
Then field "eigbverb3" is empty
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# -----------------------------------------------------------------------------------------
Scenario: Bankverbindungen bei Rechnungsstorno nicht aenderbar
# -----------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "1RE004" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE004 |
	| kunde  | 1      |
   | ueb    | ja     |
   | tterm  | .      |
And I append rows
   | artikel | mge   |
   | V1      |   10  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnungsstorno
Given I open an editor "1RE004S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1RE004"
Then field "eigbverb1" is not modifiable
Then field "eigbverb2" is not modifiable
Then field "eigbverb3" is not modifiable
And I close the current editor

# -----------------------------------------------------------------------------------------
Scenario: Bankverbindungen in Wertgutschriften und kaufm. Gutschriften aenderbar
# -----------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS005" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS005 |
	| kunde  | 1      |
   | ueb    | ja     |
And I append rows
   | artikel | mge   |
   | V1      |   100 |
And I save the current editor

# Rechnung
Given I open an editor "1RE005" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS005"
And I set fields
   | nummer | 1RE005 |
   | ueb    | ja     |
   | tterm  | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "1WGS005" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE005"
Then field "eigbverb1" is modifiable
Then field "eigbverb2" is modifiable
Then field "eigbverb3" is modifiable
And I close the current editor

# Ruecklieferung
Given I open an editor "1RLS005" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS005"
And I set fields
   | nummer | 1RLS005 |
   | ueb    | ja      |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Kaufm. Gutschrift
Given I open an editor "1KGS005" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1RLS005"
Then field "eigbverb1" is modifiable
Then field "eigbverb2" is modifiable
Then field "eigbverb3" is modifiable
And I close the current editor
