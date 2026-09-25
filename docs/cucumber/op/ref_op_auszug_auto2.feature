# *****************************************************************************
#  Name             : ref_op_auszug_auto2.feature
#  Autor            : hc
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Bearbeitung der Bankkontoauszüge (90:1), automatische Zuordnung
#  ref              : ref_op_auszug_auto2_cu
# *******************************************************************************
@persistent
Feature: Bankimport, automatische Zuordnung, Konto-Zuordnung über Zuordnungsmerkmale

Background:
Given I set the fake date to "02.01.2022"

# Betroffen:
# - Gutschriften und Belastungen
# - automatische Konto-Zuordnung über die Zuordnungsmerkmale
# - Erweiterung REWE-3668 MUSS-Konto-Zuordnung über Zuordnungsmerkmale: erster Zuordnungsmerkmal mit
#                         passendem Auftraggebernamen UND passendem Verwendungszweck.
#
# Testfälle:
# 1. ZV-Konfig: MUSS über den Auftraggebernamen
# 2. ZV-Konfig: MUSS über den Verwendungszweck der Zuordnungsmerkmale
# 3. ZV-Konfig: MUSS über den Auftraggebernamen UND MUSS über den Verwendungszweck der Zuordnungsmerkmale

# ---------------------------------------------------------------------------------------------
Scenario: Bankkontoauszug 1: Buchungsdatum anpassen
# ---------------------------------------------------------------------------------------------

Given I'm logged in with password "annette"

Given I open an editor "Bankkontoauszug-1" from table "90:1" with command "UPDATE" for record "1"
And I set field "asaldat" to "31.01.2022"
And I set field "esaldat" to "31.01.2022"
And I modify table
  | !row | tbudat     |
  | 1    | 31.01.2022 |
  | 2    | 31.01.2022 |
  | 3    | 31.01.2022 |
And I save the current editor

Given I'm logged in with password "sy"

# ---------------------------------------------------------------------------------------------
Scenario: Kunden, Lieferanten und Zuordnungsmerkmale erfassen
# ---------------------------------------------------------------------------------------------
Given I open an editor "Kunde-GutZMAuftr" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
  | nummer   | 1GutZMA |
  | such     | GUTZMA  |
  | zbed     | 200     |
And I save the current editor
#
Given I open an editor "Kunde-GutZMVerw" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
  | nummer   | 2GutZMV |
  | such     | GUTZMV  |
  | zbed     | 200     |
And I save the current editor
#
Given I open an editor "Kunde-GutZMAuftrVerw" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
  | nummer   | 3GutZMAV |
  | such     | GUTZMAV  |
  | zbed     | 200      |
And I save the current editor

# ----- Lieferanten erfassen
Given I open an editor "Lieferant-BelZMAuftr" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 1BelZMA |
  | such     | BELZMA  |
  | zbed     | 200     |
And I save the current editor
#
Given I open an editor "Lieferant-BelZMVerw" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 2BelZMV |
  | such     | BELZMV  |
  | zbed     | 200     |
And I save the current editor
#
Given I open an editor "Lieferant-BelZMAuftrVerw" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 3BelZMAV |
  | such     | BELZMAV  |
  | zbed     | 200      |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Zuordnungsmerkmale erfassen
# ---------------------------------------------------------------------------------------------

# ----- Für Zuordnung der Gutschhriften, Konto: Kunde

Given I open an editor "Zurdnungsmerkmal-GutZMAuftr" from table "66:5" with command "NEW" for record ""
And I set fields
  | nummer | 1KUZMA    |
  | such   | KUZM1     |
  | konto  | K 1GutZMA |
  | zmname | Herr Debtor Reference Party |
  | vzweck |           |
And I save the current editor

Given I open an editor "Zurdnungsmerkmal-GutZMVerw" from table "66:5" with command "NEW" for record ""
And I set fields
  | nummer | 2KUZMV    |
  | such   | KUZM2     |
  | konto  | K 2GutZMV |
  | zmname |           |
  | vzweck | Rechnungsnr. 4711* |
And I save the current editor

Given I open an editor "Zurdnungsmerkmal-GutZMAuftrVerw" from table "66:5" with command "NEW" for record ""
And I set fields
  | nummer | 3KUZMAV    |
  | such   | KUZM3      |
  | konto  | K 3GutZMAV |
  | zmname | Herr Debtor Reference Party |
  | vzweck | Rechnungsnr. 4711* |
And I save the current editor

# ----- Für Zuordnung der Belastungen, Konto: Lieferant

Given I open an editor "Zurdnungsmerkmal-BelZMAuftr" from table "66:5" with command "NEW" for record ""
And I set fields
  | nummer | 1LIZMA    |
  | such   | LIZM1     |
  | konto  | L 1BelZMA |
  | zmname | Glaeubigerfirma |
  | vzweck |           |
And I save the current editor

Given I open an editor "Zurdnungsmerkmal-BelZMVerw" from table "66:5" with command "NEW" for record ""
And I set fields
  | nummer | 2LIZMV    |
  | such   | LIZM2     |
  | konto  | L 2BelZMV |
  | zmname |           |
  | vzweck | *Vertragsnummer 3536456345* |
And I save the current editor

Given I open an editor "Zurdnungsmerkmal-BelZMAuftrVerw" from table "66:5" with command "NEW" for record ""
And I set fields
  | nummer | 3LIZMAV    |
  | such   | LIZM3      |
  | konto  | L 3BelZMAV |
  | zmname | Glaeubigerfirma |
  | vzweck | *Vertragsnummer 3536456345* |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Bankkontoauszug 1, Vorbelegung prüfen
# ---------------------------------------------------------------------------------------------

Given I open an editor "Bankkontoauszug-1" from table "90:1" with command "VIEW" for record "1"
Then table has values
  | !row | tzabuchart | tbubetr |  toffen |   tkonto   | opanzahl | tauftrgeb1                  | tvzweck1                                               | tzaref                             |
  | 1    | Gutschrift |  100.00 |  100.00 |            | 0        | Herr Debtor Reference Party | Rechnungsnr. 4711 vom 20.08.2008                       | Ende-zu-Ende-Id des Ueberweisenden |
  | 2    | Gutschrift |  200.00 |  200.00 |            | 0        |                             | Angabe des urspruenglichen Verwendungszweckes          | Urspr. E2E-Id der Hintransaktion   |
  | 3    | Belastung  |  -50.00 |  -50.00 |            | 0        | Glaeubigerfirma             | Telefonrechnung August 2009, Vertragsnummer 3536456345 | E2E-Id vergeben vom Glaeubiger     |
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: MUSS-Zuornung über den Auftraggebernamen
# ---------------------------------------------------------------------------------------------

Given I open an editor "ZKGut" from table "66:10" with command "NEW" for record ""
And I set fields
  | such          | ZKGut1     |
  | zabuchart | Gutschrift |
  | zkkunde        | ja         |
  | zkbverb       |            |
  | zkauftr       | MUSS       |
  | zkvzweck      |            |
And I save the current editor
And I close the current editor

Given I open an editor "ZKBel" from table "66:10" with command "NEW" for record ""
And I set fields
  | such          | ZKBel1    |
  | zabuchart | Belastung |
  | zklieferant        | ja        |
  | zkbverb       |           |
  | zkauftr       | MUSS      |
  | zkvzweck      |           |
And I save the current editor
And I close the current editor

Given I open an editor "ZVKonfig" from table "66:1" with command "UPDATE" for record "1"
And I set fields
  | zuordkgutschrift | ZKGut1 |
  | zuordkbelastung  | ZKBel1 |
And I save the current editor
And I close the current editor

Given I open an editor "Bankkontoauszug-1" from table "90:1" with command "UPDATE" for record "1"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen | tkonto    | opanzahl |
  | 1    |  100.00 |  100.00 | K 1GutZMA | 0        |
  | 2    |  200.00 |  200.00 |           | 0        |
  | 3    |  -50.00 |  -50.00 | L 1BelZMA | 0        |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: MUSS-Zuornung über den Verwendungszweck der Zuordnungsmerkmale
# ---------------------------------------------------------------------------------------------

Given I open an editor "ZKGut" from table "66:10" with command "UPDATE" for record "ZKGut1"
And I set fields
  | zkkunde   | ja   |
  | zkbverb  |      |
  | zkauftr  |      |
  | zkvzweck | MUSS |
And I save the current editor
And I close the current editor

Given I open an editor "ZKBel" from table "66:10" with command "UPDATE" for record "ZKBel1"
And I set fields
  | zklieferant   | ja   |
  | zkbverb  |      |
  | zkauftr  |      |
  | zkvzweck | MUSS |
And I save the current editor
And I close the current editor

Given I open an editor "Bankkontoauszug-1" from table "90:1" with command "UPDATE" for record "1"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen | tkonto    | opanzahl |
  | 1    |  100.00 |  100.00 | K 2GutZMV | 0        |
  | 2    |  200.00 |  200.00 |           | 0        |
  | 3    |  -50.00 |  -50.00 | L 2BelZMV | 0        |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: MUSS-Zuornung über den Auftraggebernamen UND MUSS-Zuordnung über den Verwendungszweck der Zuordnungsmerkmale
# ---------------------------------------------------------------------------------------------

Given I open an editor "ZKGut" from table "66:10" with command "UPDATE" for record "ZKGut1"
And I set fields
  | zkkunde   | ja   |
  | zkbverb  |      |
  | zkauftr  | MUSS |
  | zkvzweck | MUSS |
And I save the current editor
And I close the current editor

Given I open an editor "ZKBel" from table "66:10" with command "UPDATE" for record "ZKBel1"
And I set fields
  | zklieferant   | ja   |
  | zkbverb  |      |
  | zkauftr  | MUSS |
  | zkvzweck | MUSS |
And I save the current editor
And I close the current editor

Given I open an editor "Bankkontoauszug-1" from table "90:1" with command "UPDATE" for record "1"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen | tkonto     | opanzahl |
  | 1    |  100.00 |  100.00 | K 3GutZMAV | 0        |
  | 2    |  200.00 |  200.00 |            | 0        |
  | 3    |  -50.00 |  -50.00 | L 3BelZMAV | 0        |
And I save the current editor
