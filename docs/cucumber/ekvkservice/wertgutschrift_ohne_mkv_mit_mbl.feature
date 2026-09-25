# *****************************************************************************
#  Name           : wertgutschrift_ohne_mkv_mit_mbl.feature
#  Autor          : as
#  Verantwortlich : teampss
#  Funktion       : Testet die Wertgutschrift bei ausgeschalteter
#                   Materialkostenverbuchung und Mischpreis bei Lagerbewegung
#                   in der Warengruppe
# *****************************************************************************
#
@persistent
Feature: Wertgutschriften
Background:
Given I'm logged in with password "annette"
Given I set the fake date to "05.01.1995"
Given I enable the flag 317
Given I enable the flag 39

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN
# ----------------------------------------------------------------------------------------------

# Materialkostenverbuchung ausschalten
Given I open an editor "konfig" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
And I set field "bew" to "nein"
And I save the current editor

# Warengruppe mit Mischpreis bei Lagerbewegung
Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set fields
| nummer  | 60   |
| lsmpr   | ja   |
And I save the current editor

# Kaufteil
Given I open an editor "TE020" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
| such     | TE020            |
| namebspr | Teil 020         |
| bsart    | Fremdbeschaffung |
| dispoa   | auftragsbezogen  |
| vpr      | 10               |
| epr      | 10               |
| wgruppe  | 60               |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung, Lieferschein, Rechnung (aus Lieferschein), Wertgutschrift, Storno Wertgutschrift
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE100" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE100 |
   | lief   | 1      |
   | such   | BE100  |
And I append rows
   | artikel | mge |
   | TE020   | 10  |
And I save the current editor

# Lieferschein
Given I open an editor "LS100" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE100"
And I set fields
   | nummer | 1LS100 |
   | such   | LS100  |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE100" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS100"
And I set fields
   | nummer | 1RE100 |
   | such   | RE100  |
   | ueb    | ja     |
   | vom    | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "WG100" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE100"
And I set fields
   | nummer | 1WG100 |
   | such   | WG100  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Storno Wertgutschrift
Given I open an editor "WG100S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG100"
And I set fields
   | nummer | 1WG100S |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung, Lieferschein, Rechnung (aus Bestellung), Wertgutschrift, Storno Wertgutschrift
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE101" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE101 |
   | lief   | 1      |
   | such   | BE101  |
And I append rows
   | artikel | mge |
   | TE020   | 10  |
And I save the current editor

# Lieferschein
Given I open an editor "LS101" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE101"
And I set fields
   | nummer | 1LS101 |
   | such   | LS101  |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE101" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE101"
And I set fields
   | nummer | 1RE101 |
   | such   | RE101  |
   | ueb    | ja     |
   | vom    | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "WG101" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE101"
And I set fields
   | nummer | 1WG101 |
   | such   | WG101  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Storno Wertgutschrift
Given I open an editor "WG101S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG101"
And I set fields
   | nummer | 1WG101S |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung, Rechnung (mit Lagerbewegung), Wertgutschrift, Storno Wertgutschrift
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE102" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE102 |
   | lief   | 1      |
   | such   | BE102  |
And I append rows
   | artikel | mge |
   | TE020   | 10  |
And I save the current editor

# Rechnung
Given I open an editor "RE102" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE102"
And I set fields
   | nummer | 1RE102 |
   | such   | RE102  |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "WG102" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE102"
And I set fields
   | nummer | 1WG102 |
   | such   | WG102  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Storno Wertgutschrift
Given I open an editor "WG102S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG102"
And I set fields
   | nummer | 1WG102S |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN
# ----------------------------------------------------------------------------------------------

# Materialkostenverbuchung wieder einschalten
Given I open an editor "konfig" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
And I set field "bew" to "ja"
And I respond with answer "ja" to the dialog with id "2539"
And I respond with answer "ja" to the dialog with id "2540"
And I save the current editor
