# *****************************************************************************
#  Name           : vertikales_verrechnen.feature
#  Verantwortlich : teampss
#  Funktion       : Fuehrt vertikale Verrechnungen von Lieferpositionen durch
#                   und dokumentiert anschliessend die Vorgangsmengen.
#
# *****************************************************************************
#

@persistent
Feature: Vertikales Verrechnen von Liefermengen im EK/VK.
Background:
Given I set the fake date to "02.01.1995"

Scenario: Stammdaten

Given I open an editor "A100" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such   | A100             |
   | bsart  | Fremdbeschaffung |
   | dispoa | auftragsbezogen  |
   | vpr    | 100              |
   | lief   | 1                |
   | epr    | 100              |
   | fvhe   | 2                |
   | vhe    | kg               |
And I save the current editor

# -----------------------------------------------------------------------------
#  V E R K A U F
# -----------------------------------------------------------------------------

Scenario: VK: Auftrag -> Lieferschein (vert. verrechnet), Rechnung aus Lieferschein

Given I open an editor "AU001" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU001  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 3   |
   | A100    | Stück | 3   |
   | A100    | Stück | 3   |
And I save the current editor

Given I open an editor "LS001-1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU001"
And I set fields
   | such   | LS001-1 |
   | vom    | .       |
And I set field "mge" to "7" in row 1
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "LS001-1" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS001-1"
And I set field "ueb" to "ja"
And I set field "mge" to "3" in row 1
And I save the current editor

Given I open an editor "LS001-2" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU001"
And I set fields
   | such   | LS001-2 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "1" in row 1
And I save the current editor

Given I open an editor "AU001" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Given I open an editor "LS001-1" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS001-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Given I open an editor "LS001-2" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS001-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Scenario: VK: Auftrag -> Rechnung mit Lagerbewegung (vert. verrechnet)

Given I open an editor "AU002" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU002  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 3   |
   | A100    | Stück | 3   |
   | A100    | Stück | 3   |
And I save the current editor

Given I open an editor "RE002-1" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU002"
And I set fields
   | such   | RE002-1 |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "7" in row 1
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE002-1" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE002-1"
And I set field "ueb" to "ja"
And I set field "mge" to "3" in row 1
And I save the current editor

Given I open an editor "RE002-2" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU002"
And I set fields
   | such   | RE002-2 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "AU002" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Given I open an editor "RE002-1" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE002-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Given I open an editor "RE002-2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE002-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Scenario: VK: Auftrag -> Lieferschein, Rechnung aus Auftrag (vert. verrechnen nicht moeglich)

Given I open an editor "AU003" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU003  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 3   |
   | A100    | Stück | 3   |
   | A100    | Stück | 3   |
And I save the current editor

Given I open an editor "LS003-1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU003"
And I set fields
   | such   | LS003-1 |
   | vom    | .       |
   | fakt   | nein    |
And I set field "mge" to "7" in row 1
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "LS003-1" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS003-1"
And I set field "ueb" to "ja"
And I set field "mge" to "3" in row 1
And I save the current editor

Given I open an editor "LS003-2" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU003"
And I set fields
   | such   | LS003-2 |
   | vom    | .       |
   | ueb    | ja      |
   | fakt   | nein    |
And I set field "mge" to "1" in row 1
And I save the current editor

Given I open an editor "AU003" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU003"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Given I open an editor "LS003-1" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS003-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Given I open an editor "LS003-2" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS003-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

# -----------------------------------------------------------------------------
#  E I N K A U F
# -----------------------------------------------------------------------------

Scenario: EK: Bestellung -> Lieferschein (vert. verrechnet), Rechnung aus Lieferschein

Given I open an editor "BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE001  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 3   |
   | A100    | Stück | 3   |
   | A100    | Stück | 3   |
And I save the current editor

Given I open an editor "LS001-1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE001"
And I set fields
   | such   | LS001-1 |
   | ebeleg | LS001-1 |
   | vom    | .       |
And I set field "mge" to "7" in row 1
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "LS001-1" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS001-1"
And I set field "ueb" to "ja"
And I set field "mge" to "3" in row 1
And I save the current editor

Given I open an editor "LS001-2" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE001"
And I set fields
   | such   | LS001-2 |
   | ebeleg | LS001-2 |
   | vom    | .       |
   | ueb    | ja      |
And I set field "mge" to "1" in row 1
And I save the current editor

Given I open an editor "BE001" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Given I open an editor "LS001-1" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS001-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Given I open an editor "LS001-2" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS001-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Scenario: EK: Bestellung -> Rechnung mit Lagerbewegung (vert. verrechnet)

Given I open an editor "BE002" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE002  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 3   |
   | A100    | Stück | 3   |
   | A100    | Stück | 3   |
And I save the current editor

Given I open an editor "RE002-1" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE002"
And I set fields
   | such   | RE002-1 |
   | ebeleg | RE002-1 |
   | fakt   | ja      |
   | vom    | .       |
   | tterm  | .       |
And I set field "mge" to "7" in row 1
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE002-1" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE002-1"
And I set field "ueb" to "ja"
And I set field "mge" to "3" in row 1
And I save the current editor

Given I open an editor "RE002-2" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE002"
And I set fields
   | such   | RE002-2 |
   | ebeleg | RE002-2 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I set field "mge" to "1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "BE002" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Given I open an editor "RE002-1" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE002-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Given I open an editor "RE002-2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE002-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Scenario: EK: Bestellung -> Lieferschein, Rechnung aus Bestellung (vert. verrechnen nicht moeglich)

Given I open an editor "BE003" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | BE003  |
And I append rows
   | artikel | he    | mge |
   | A100    | Stück | 3   |
   | A100    | Stück | 3   |
   | A100    | Stück | 3   |
And I save the current editor

Given I open an editor "LS003-1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE003"
And I set fields
   | such   | LS003-1 |
   | ebeleg | LS003-1 |
   | vom    | .       |
   | fakt   | nein    |
And I set field "mge" to "7" in row 1
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "LS003-1" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS003-1"
And I set field "ueb" to "ja"
And I set field "mge" to "3" in row 1
And I save the current editor

Given I open an editor "LS003-2" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE003"
And I set fields
   | such   | LS003-2 |
   | ebeleg | LS003-2 |
   | vom    | .       |
   | ueb    | ja      |
   | fakt   | nein    |
And I set field "mge" to "1" in row 1
And I save the current editor

Given I open an editor "BE003" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE003"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Given I open an editor "LS003-1" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS003-1"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Given I open an editor "LS003-2" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS003-2"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "vertikales_verrechnen.out"
And I close the current editor

Scenario: Buchen eines Lieferschein, wenn weiterer ungebuchter Lieferschein vorhanden ist.

#Auftrag mit 2 gleichen Artikelpositionen mit Mengen 10 und 20 anlegen
Given I open an editor "AU004" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1      |
   | such    | AU004  |
And I append rows
    | pnum | artex  | mge         |
    | 1    | v1     | 10          |
    | 2    | v1     | 20          |
And I save the current editor

#Lieferschein 1 erzeugen aber nicht buchen
Given I open an editor "LS004-1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU004"
And I set fields
   | such   | LS004-1 |
And I set field "mge" to "12" in row 1
And I press button "offueb" in row 1
Then field "ofmge" has value "18" in row 2
And I save the current editor

#Lieferschein 2 erzeugen aber nicht buchen
Given I open an editor "LS004-2" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU004"
And I set fields
   | such   | LS004-2 |
And I set field "mge" to "15" in row 1
And I press button "offueb" in row 1
And I save the current editor

#Lieferschein 1 buchen
Given I open an editor "LS004-1B" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS004-1"
And I set field "ueb" to "ja"
And I save the current editor

# Pruefen der offenen Liefer- und Rechnungsmenge im Auftrag
Given I open an editor "AU004V1" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU004"
Then field "limge" has value "0" in row 1
Then field "remge" has value "0" in row 1
Then field "limge" has value "18" in row 2
Then field "remge" has value "18" in row 2
And I close the current editor

#Lieferschein 3 erzeugen aber nicht buchen
Given I open an editor "LS004-3" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU004"
And I set fields
   | such   | LS004-3 |
Then field "fakt" has value "ja"
And I set field "mge" to "3" in row 1
And I press button "offueb" in row 1
And I save the current editor

#Lieferschein 2 buchen
Given I open an editor "LS004-2B" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS004-2"
And I set field "ueb" to "ja"
And I save the current editor

# Pruefen der offenen Liefer- und Rechnungsmenge im Auftrag
Given I open an editor "AU004V1" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU004"
Then field "limge" has value "0" in row 1
Then field "remge" has value "0" in row 1
Then field "limge" has value "3" in row 2
Then field "remge" has value "3" in row 2
And I close the current editor
