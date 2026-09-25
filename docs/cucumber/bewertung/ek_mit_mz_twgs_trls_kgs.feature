# *****************************************************************************
#  Name           : ek_mit_mz_twgs_trls_kgs.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Darstellung von Geschäftsprozessen mit (TeilwWertgutschriften, Teilrücklieferungen und kfm. Gutschriften
#
#
# *****************************************************************************
@persistent
Feature: ref_ek_mit_mz_twgs_trls_kgs_cu
Background:
Given I set the fake date to "08.02.1995"

# -----------------------------------------------------------------------------------------------------------
Scenario: 01 Stammdaten (Lagerplätze angleichen, Konten anlegen)
#------------------------------------------------------------------------------------------------------------
Given I open an editor "firma" from table "(Company):(ValuationConfiguration)" with command "UPDATE" for record "BEWERT"
And I append rows
  | bewverf | bewab             | bewzu         |
  | 2       | Preis des Zugangs | Vorgangspreis |
And I save the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "e1"
And I set field "abplatz" to "f1"
And I set field "ekbewverf" to "2"
And I save the current editor
And I close the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10100"
And I set field "such" to "K10100"
And I set field "namebspr" to "Rohstoffe"
And I save the current editor

# -----------------------------------------------------------------------------------------------------------
Scenario: 02 BE(m10;p10)-LS(m6=Platz1)(m4=Platz2)-RE(m10;p11)-TWGS(m-8;p11)-TRLS(m-9;p10)-KGS(m-1;p11)
# -----------------------------------------------------------------------------------------------------------
# Bestellung
Given I open an editor "bestellung1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 100BE  |
    | such4    | BE100  |
    | vom      | .      |
    | ebeleg   | BE1    |
    | erfwaehr | dem    |
    | budat    | .      |
And I append rows
| artikel | mge | preis |konto      | ptext      |
| E1      | 10  | 10,00 | 10100     |            |
And I save the current editor
And I close the current editor

Given I set the fake date to "10.02.1995"
Given I open an editor "lieferschein1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "100BE"
And I set fields
    | lief     | 1       |
    | num4     | 100LS   |
    | such4    | LS100   |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | LS      |
    | erfwaehr | dem     |
And I press button "offueb" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge |  verw  |
    |   F3   |  6     | V_1    |
    |   F4   |  4     | V_2    |
And I save the current editor
And I switch the current editor to editor "lieferschein1"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02." until enddate "28.02." with Command Revalue

# EK-Rechnung
Given I set the fake date to "12.02.1995"
Given I open an editor "rechnung1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein1"
And I set fields
    | lief     | 1       |
    | num4     | 100RE   |
    | such4    | RE100   |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | RE1     |
    | budat    | .       |
    | erfwaehr | dem     |
And I press button "offueb" in row 1
And I set field "preis" to "11" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02." until enddate "28.02." with Command Revalue


# Teilwertgutschrift
Given I set the fake date to "14.02.1995"
Given I open an editor "100-wgs1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+100RE"
And I set fields
   | nummer | 100WGS1 |
   | such   | WGS1100 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
# Teilwertgutschrift erstellen
And I set field "mge" to "-8" in row 1
Then the table has 4 rows
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02." until enddate "28.02." with Command Revalue

# Teilruecklieferschein anlegen - wo sind Verwendungen?
Given I set the fake date to "16.02.1995"
Given I open an editor "rls-100" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein1"
And I set field "num4" to "100RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I press button "burueckmzerg"
And I append rows
    | lpsuch | zuomge |
    |   F3   |  -5    |
    |   F4   |  -4    |
And I save the current editor
And I switch the current editor to editor "rls-100"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.02." until enddate "28.02." with Command Revalue

# kfm. Gutschrift
Given I set the fake date to "18.02.1995"
Given I open an editor "kgs-100" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-100"
And I set field "num4" to "100-KGS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
Then table has values
  | art       | mge  | preis         | remge |
  | E1        | -9   |   2.20        | -9    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


