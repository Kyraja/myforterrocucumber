# *****************************************************************************
#  Verantwortlich : uo
# *****************************************************************************
#
@persistent
Feature: Kundenanlieferung
Background:
Given I set the fake date to "05.02.2002"

@Testdaten
Scenario: Testdaten (Stammdaten) anlegen - Konsignationslagerplatz
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

@kundenanlieferung
Scenario: Kundenanlieferung Neu ohne Vorgaenger
Given I open an editor "KundenanlieferungNeu" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "such" to "KANLNEU"
And I set field "lsart" to "Kundenanlieferung"
And I set field "ueb" to "ja"
And I append rows
    | artikel | mge  | preis |platz   | kstelle |
    | V1      | -10  | 5     |KONSILP |100000   |
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
   | artikel | mge  | preis | platz       | kstelle |
   | V1      | -20  | 6     | KONSILP     | 100000  |
   | V2      | 13   | 3     | !dontChange |   101   |
And I save the current editor

Given I open an editor "KAnlLSAusAuftrag" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "KAnlMixAuftrag"
And I set fields
   | such | LS2 |
   | ueb  | ja    |
Then field "lsart" has value "Lieferschein"
# Nur positive Positionen sind enthalten
Then the table has 1 rows
And I press button "offueb" in row 1
Then field "mge" has value "13" in row 1
And I save the current editor

Given I open an editor "KAnlAusAuftrag" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | ueb   | ja                |
   | lsart | Kundenanlieferung |
Then field "lsart" has value "Kundenanlieferung"
Then field "kunde" has value ""
And I set field "beleg" to id from editor "KAnlMixAuftrag"
And I set field "such" to "KANLS2"
Then field "kunde" has value "1"
Then the table has 1 rows
And I press button "offueb" in row 1
Then field "mge" has value "-20" in row 1
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
   | artikel | mge  | preis | platz   | kstelle |
   | V1      | -30  | 6     | KONSILP |   101   |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "platz" to "KONSILP" in row !lastRow
And I set field "zuomge" to "-10" in row !lastRow
And I create a new row at the end of the table
And I set field "platz" to "KONSILP" in row !lastRow
And I set field "zuomge" to "-20" in row !lastRow
And I save the current editor
And I switch the current editor to editor "KANLMZ1"
And I save the current editor

Given I open an editor "KAnlAuftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1         |
   | such  | KANLMZ2   |
   | vom   | .         |
And I append rows
   | artikel | mge  | preis | platz   | kstelle |
   | V1      | -5   | 6     | KONSILP |   101   |
And I save the current editor

Given I open an editor "KANLMZ2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | ueb   | ja                |
   | lsart | Kundenanlieferung |
And I set field "beleg" to id from editor "KAnlAuftrag"
And I set field "such" to "KANLMZ2"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "platz" to "KONSILP" in row !lastRow
And I set field "zuomge" to "-3" in row !lastRow
And I create a new row at the end of the table
And I set field "platz" to "KONSILP" in row !lastRow
And I set field "zuomge" to "-2" in row !lastRow
And I save the current editor
And I switch the current editor to editor "KANLMZ2"
And I save the current editor

@kundenanlieferung
Scenario: Storno Kundenanlieferung ohne Vorgaenger
Given I open an editor "KANL" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde | 1                 |
   | such  | KANL            |
   | lsart | Kundenanlieferung |
   | ueb   | ja                |
And I append rows
    | artikel | mge  | preis |platz   | kstelle |
    | V1      | -10  | 5     |KONSILP | 100000  |  
And I save the current editor

Given I open an editor "KANLST" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "KANL"
Then field "lsart" has value "Storno-Kundenanlieferung"
And I save the current editor

Given I open an editor "KANLVIEW" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "KANL"
Then field "lsart" has value "Stornierte Kundenanlieferung"
And I close the current editor

@kundenanlieferung
Scenario: Storno Kundenalieferung mit Auftrag als Vorgaenger
Given I open an editor "KAnlAuftrag3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1         |
   | such  | KANL3     |
   | vom   | .         |
And I append rows
   | artikel | mge  | preis | platz       | kstelle |
   | V1      | -20  | 6     | KONSILP     | 100000  |
And I save the current editor

Given I open an editor "KAnlAusAuftrag" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lsart | Kundenanlieferung |
And I set field "beleg" to id from editor "KAnlAuftrag3"
And I set field "such" to "KANLS3"
Then the table has 1 rows
And I press button "offueb" in row 1
Then field "mge" has value "-20" in row 1
And I set field "ueb" to "ja"
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
    | artikel | mge  | preis |platz   | kstelle |
    | V1      | -10  | 5     |KONSILP |   101   |
And I save the current editor

Given I open an editor "KANLKGS" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "KANLLS"
And I set field "such" to "KANLKGS"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set fields
  | ueb    | ja |
  | tterm  | .  |
  | budat  | .  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
