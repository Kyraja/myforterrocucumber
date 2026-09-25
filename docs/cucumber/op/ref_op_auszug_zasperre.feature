# *****************************************************************************
#  Name             : ref_op_auszug_zasperre.feature
#  Autor            : hc
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Bearbeitung der Bankkontoauszüge (90:1), Zahlungssperre
#  ref              : ref_op_auszug_zasperre_cu
# *******************************************************************************
@persistent
Feature: Zahlungssperre im Bankimport

Background:
Given I set the fake date to "02.01.2022"

# ---------------------------------------------------------------------------------------------
# IST : Die Zahlungssperre wird im Bankimport nicht berücksichtigt.
#       OPs mit Zahlungssperre können automatisch und manuell zugeordnet, bestätigt und verbucht werden.
#
# SOLL: s. REWE-3330
#
# ---------------------------------------------------------------------------------------------
# Es handelt sich um einen OP mit Zahlungssperre, wenn in diesem OP selbst oder
# im OP-Konto (Zahlungssperre für alle OPs des Kontos) die Zahlungssperre aktiviert ist.
#
# Folgende Fälle der Zahlungssperre werden hier getestet:
# - OP-Konto ohne Zahlungssperre, OP mit Zahlungssperre
# - OP-Konto mit Zahlungssperre, OP mit Zahlungssperre
# - OP-Konto mit Zahlungssperre, OP ohne Zahlungssperre
#
# Im Test verwendete Bankkontoauszüge: 1, 3, 11.
#
# Folgende Bankimport-Funktionalität ist hier betroffen:
# - Automatische Zuordnung nach Beleg und Betrag für Gutschriften und für Belastungen,
# - Manuelle Zuordnung, Selektion der OPs über Beleg,
# - Manuelle Zuordnung, OP-Direkteintrag.
#
# ---------------------------------------------------------------------------------------------
Scenario: Kunden, Lieferanten mit und ohne Zahlungssperre erfassen
# ---------------------------------------------------------------------------------------------
Given I open an editor "KundeOHNESperre" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
  | nummer   | 100                      |
  | such     | KUOHNESP                 |
  | name     | Kunde OHNE Zahlungssperre|
  | zasperre | nein                     |
  | zbed     | 200                      |
And I save the current editor

Given I open an editor "KundeMITSperre" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
  | nummer   | 200                     |
  | such     | KUMITSP                 |
  | name     | Kunde MIT Zahlungssperre|
  | zasperre | ja                      |
  | zbed     | 200                     |
And I save the current editor

Given I open an editor "LieferantMITSperre" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 300                         |
  | such     | LIMITSP                     |
  | name     | Lieferant MIT Zahlungssperre|
  | zasperre | ja                          |
  | zbed     | 200                         |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Zuordnungskonfiguration in ZVKonfig (66:1) anpassen
# ---------------------------------------------------------------------------------------------
#
Given I open an editor "ZKGut" from table "66:10" with command "NEW" for record ""
And I set fields
  | such          |      ZKGut |
  | zabuchart | Gutschrift |
  | zkkunde        | ja         |  # Gutschriften, Kunden OPs berücksichtigen
  | zkbeleg       | Muss       |  # Gutschriften, Muss-Zuordnung über OP-Beleg
  | zkbetr        | ja         |  # Gutschriften, (Muss-)Zuordnung über Betrag
And I save the current editor
And I close the current editor

Given I open an editor "ZK" from table "66:10" with command "NEW" for record ""
And I set fields
  | such          | ZKBel     |
  | zabuchart | Belastung |
  | zklieferant        | ja        |  # Belastungen, Lieferanten OPs berücksichtigen
  | zkbeleg       | Muss      |  # Belastungen, Muss-Zuordnung über OP-Beleg
  | zkbetr        | ja        |  # Belastungen, (Muss-)Zuordnung über Betrag
And I save the current editor
And I close the current editor

# Sonstige Zuordnung-Konfigurationsfelder sind deaktiviert, s. Vorgängertest.

Given I open an editor "ZVKonfig" from table "66:1" with command "UPDATE" for record "1"
And I set fields
| zuordkgutschrift | ZKGut |
| zuordkbelastung  | ZKBel |
And I save the current editor
And I close the current editor

# ---------------------------------------------------------------------------------------------------------------
Scenario: OPs mit Zahlungssperre im Bankkontoauszug 1: automatisch zuordnen, bestätigen und "Buchen"
# ---------------------------------------------------------------------------------------------------------------

# ----- OPs mit und ohne Zahlungssperre erzeugen (Buchung neu)

Given I open an editor "BuchungMITzasperre-1001" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg    | 1001      |
  | beldat   | 02.01.2022|
  | budat    | 02.01.2022|
  | zasperre | true      |
And I append rows
  | konto | ewsbetr     | kstelle     |
  | K 100 | 100.00      | !dontChange |
  | 44000 | !dontChange | 101         |
# Dialog 583: "Buchung o.k.?"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "BuchungMITzasperre-2001" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg    | 2001       |
  | beldat   | 02.01.2022 |
  | budat    | 02.01.2022 |
  | zasperre | true       |
And I append rows
  | konto     | ewsbetr     | kstelle     |
  | K KUMITSP | 200.00      | !dontChange |
  | 44000     | !dontChange | 101         |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "BuchungOHNEzasperre-3001" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg    | 3001       |
  | beldat   | 02.01.2022 |
  | budat    | 02.01.2022 |
  | zasperre | false      |
And I append rows
  | konto     | ewhbetr     | kstelle     |
  | L LIMITSP | 50.00       | !dontChange |
  | 44000     | !dontChange | 101         |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# ----- Daten im Bankkontoauszug 1 an die Verwendung in diesem Test anpassen (Wartung)

Given I'm logged in with password "annette"

Given I open an editor "Bankkontoauszug-1" from table "90:1" with command "UPDATE" for record "1"
#
And I set field "such" to "ZASPERRE"
And I set field "asaldat" to "31.01.2022"
And I set field "esaldat" to "31.01.2022"
And I modify table
  | !row | tbudat     | tvaldat    | tvzweck1 |
  | 1    | 31.01.2022 | 31.01.2022 | Re-Nr.: 1001 vom 02.01.2023 |
  | 2    | 31.01.2022 | 31.01.2022 | Re-Nr.: 2001 vom 02.01.2023 |
  | 3    | 31.01.2022 | 31.01.2022 | Re-Nr.: 3001 vom 02.01.2023 |
#
Then fields have values
  | asaldat   | 31.01.2022 |
  | asalwaehr | EUR        |
  | esaldat   | 31.01.2022 |
  | esalwaehr | EUR        |
  | bkonto    |            |
Then table has values
  | !row | tbudat     | tzabuchart | tbubetr | twaehr | tvzweck1                    | toffen | tkonto | opanzahl |
  | 1    | 31.01.2022 | Gutschrift | 100.00  | EUR    | Re-Nr.: 1001 vom 02.01.2023 | 100.00 |        | 0        |
  | 2    | 31.01.2022 | Gutschrift | 200.00  | EUR    | Re-Nr.: 2001 vom 02.01.2023 | 200.00 |        | 0        |
  | 3    | 31.01.2022 | Belastung  | -50.00  | EUR    | Re-Nr.: 3001 vom 02.01.2023 | -50.00 |        | 0        |
And I save the current editor

Given I'm logged in with password "sy"

# ----- Bankkontoauszug 1: automatisch zuordnen, bestätigen und buchen mit Button "Buchen"

Given I open an editor "Bankkontoauszug-1" from table "90:1" with command "UPDATE" for record "1"
#
And I set field "bkonto" to "18100"
#
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
#
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr | toffen | tkonto | opanzahl |
  | 1    | 100.00  | 0.00   | K 100  | 1        |
  | 2    | 200.00  | 0.00   | K 200  | 1        |
  | 3    | -50.00  | 0.00   | L 300  | 1        |
# Ergebnisse der Zuordnung in der manuellen Zuordnung prüfen:
And I press button "tmanuell" to open a subeditor for "manuelle_zuordnung" in row 1
Then fields have values
  | konto   | K 100  |
  | szabetr | 100.00 |
  | soffen  | 0.00   |
Then table has values
  | !row | zmarke | tkonto | tbeleg | tzabetr |
  | 1    | ja     | K 100  | 1001   | 100.00  |
And I save the current subeditor to switch back to the parent editor
And I press button "tmanuell" to open a subeditor for "manuelle_zuordnung" in row 2
Then fields have values
  | konto   | K 200  |
  | szabetr | 200.00 |
  | soffen  | 0.00   |
Then table has values
  | !row | zmarke | tkonto | tbeleg | tzabetr |
  | 1    | ja     | K 200  | 2001   | 200.00  |
And I save the current subeditor to switch back to the parent editor
And I press button "tmanuell" to open a subeditor for "manuelle_zuordnung" in row 3
Then fields have values
  | konto   | L 300  |
  | szabetr | -50.00 |
  | soffen  | 0.00   |
Then table has values
  | !row | zmarke | tkonto | tbeleg | tzabetr |
  | 1    | ja     | L 300  | 3001   | -50.00  |
And I save the current subeditor to switch back to the parent editor
#
And I press button "bok" to open a subeditor for "Bestätigen"
And I save the current subeditor to switch back to the parent editor
#
And I press button "bbuchen" to open a subeditor for "Buchen"
And I save the current subeditor to switch back to the parent editor
#
And I save the current editor

# --------------------------------------------------------------------------------------------------------------
Scenario: OPs mit Zahlungssperre im Bankkontoauszug 3 automatisch zuordnen, bestätigen und "Offene Posten ausbuchen"
# --------------------------------------------------------------------------------------------------------------

# ----- OPs mit und ohne Zahlungssperre erzeugen (Buchung neu)

Given I open an editor "BuchungMitSperre-1003" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  |beleg     |1003      |
  |beldat    |02.01.2022|
  |budat     |02.01.2022|
  |zasperre  |true      |
And I append rows
  |konto |ewsbetr    | kstelle   |
  |K 100 |100.00     |!dontChange|
  |44000 |!dontChange| 101       |
# Dialog 583: "Buchung o.k.?"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "BuchungMitSperre-2003" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  |beleg     |2003      |
  |beldat    |02.01.2022|
  |budat     |02.01.2022|
  |zasperre  |true      |
And I append rows
  |konto      |ewsbetr|kstelle    |
  |K KUMITSP  |200.00 |!dontChange|
  |44000      |!dontChange|101        |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "BuchungOhneSperre-3003" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  |beleg     |3003      |
  |beldat    |02.01.2022|
  |budat     |02.01.2022|
  |zasperre  |false     |
And I append rows
  |konto      |ewhbetr|kstelle    |
  |L LIMITSP  |50.00  |!dontChange|
  |44000      |!dontChange|101        |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# ----- Daten im Bankkontoauszug 3 an die Verwendung in diesem Test anpassen (Wartung)

Given I'm logged in with password "annette"

Given I open an editor "Bankkontoauszug-3" from table "90:1" with command "UPDATE" for record "3"
#
And I set field "such" to "ZASPERRE"
And I set field "asaldat" to "31.01.2022"
And I set field "esaldat" to "31.01.2022"
And I modify table
  | !row | tbudat     | tvaldat    | tvzweck1 |
  | 1    | 31.01.2022 | 31.01.2022 | Re-Nr.: 1003 vom 02.01.2023 |
  | 2    | 31.01.2022 | 31.01.2022 | Re-Nr.: 2003 vom 02.01.2023 |
  | 3    | 31.01.2022 | 31.01.2022 | Re-Nr.: 3003 vom 02.01.2023 |
#
Then fields have values
  | asaldat   | 31.01.2022 |
  | asalwaehr | EUR        |
  | esaldat   | 31.01.2022 |
  | esalwaehr | EUR        |
  | bkonto    |            |
Then table has values
  | !row | tbudat     | tzabuchart | tbubetr | twaehr | tvzweck1                    | toffen | tkonto | opanzahl |
  | 1    | 31.01.2022 | Gutschrift | 100.00  | EUR    | Re-Nr.: 1003 vom 02.01.2023 | 100.00 |        | 0        |
  | 2    | 31.01.2022 | Gutschrift | 200.00  | EUR    | Re-Nr.: 2003 vom 02.01.2023 | 200.00 |        | 0        |
  | 3    | 31.01.2022 | Belastung  | -50.00  | EUR    | Re-Nr.: 3003 vom 02.01.2023 | -50.00 |        | 0        |
And I save the current editor

Given I'm logged in with password "sy"

# ----- Bankkontoauszug 3: automatisch zuordnen, bestätigen und buchen mit Button "Offene Posten ausbuchen"

Given I open an editor "Bankkontoauszug-3" from table "90:1" with command "UPDATE" for record "3"
#
And I set field "bkonto" to "18100"
#
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
#
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr | toffen | tkonto | opanzahl |
  | 1    | 100.00  | 0.00   | K 100  | 1        |
  | 2    | 200.00  | 0.00   | K 200  | 1        |
  | 3    | -50.00  | 0.00   | L 300  | 1        |
# Ergebnisse der Zuordnung in der manuellen Zuordnung prüfen:
And I press button "tmanuell" to open a subeditor for "manuelle_zuordnung" in row 1
Then fields have values
  | konto   | K 100  |
  | szabetr | 100.00 |
  | soffen  | 0.00   |
Then table has values
  | !row | zmarke | tkonto | tbeleg | tzabetr |
  | 1    | ja     | K 100  | 1003   | 100.00  |
And I save the current subeditor to switch back to the parent editor
And I press button "tmanuell" to open a subeditor for "manuelle_zuordnung" in row 2
Then fields have values
  | konto   | K 200  |
  | szabetr | 200.00 |
  | soffen  | 0.00   |
Then table has values
  | !row | zmarke | tkonto | tbeleg | tzabetr |
  | 1    | ja     | K 200  | 2003   | 200.00  |
And I save the current subeditor to switch back to the parent editor
And I press button "tmanuell" to open a subeditor for "manuelle_zuordnung" in row 3
Then fields have values
  | konto   | L 300  |
  | szabetr | -50.00 |
  | soffen  | 0.00   |
Then table has values
  | !row | zmarke | tkonto | tbeleg | tzabetr |
  | 1    | ja     | L 300  | 3003   | -50.00  |
And I save the current subeditor to switch back to the parent editor
#
And I press button "bok" to open a subeditor for "Bestätigen"
And I save the current subeditor to switch back to the parent editor
#
And I press button "opausbuch" to open a subeditor for "Offene Posten ausbuchen"
And I respond with answer "Ja" to the dialog with id "588"
And I save the current subeditor to switch back to the parent editor
#
And I save the current editor

# -----------------------------------------------------------------------------------------------------------------
Scenario: OPs mit Zahlungssperre im Bankkontoauszug 11: manuell zuordnen, Selektion (Zeile 1-3), direkt (Zeile 4-6)
# -----------------------------------------------------------------------------------------------------------------

# ----- OPs mit und ohne Zahlungssperre erzeugen (Buchung neu)

Given I open an editor "BuchungMitSperre-1011z1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  |beleg     |1011z1    |
  |beldat    |02.01.2022|
  |budat     |02.01.2022|
  |zasperre  |true      |
And I append rows
  |konto |ewsbetr    | kstelle   |
  |K 100 |100.00     |!dontChange|
  |44000 |!dontChange| 101       |
# Dialog 583: "Buchung o.k.?"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
#
Given I open an editor "BuchungMitSperre-2011z2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  |beleg     |2011z2    |
  |beldat    |02.01.2022|
  |budat     |02.01.2022|
  |zasperre  |true      |
And I append rows
  |konto      |ewsbetr|kstelle    |
  |K KUMITSP  |200.00 |!dontChange|
  |44000      |!dontChange|101        |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
#
Given I open an editor "BuchungOhneSperre-3011z3" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  |beleg     |3011z3    |
  |beldat    |02.01.2022|
  |budat     |02.01.2022|
  |zasperre  |false     |
And I append rows
  |konto      |ewhbetr|kstelle    |
  |L LIMITSP  |50.00  |!dontChange|
  |44000      |!dontChange|101        |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "BuchungMitSperre-1011z4" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  |beleg     |1011z4    |
  |beldat    |02.01.2022|
  |budat     |02.01.2022|
  |zasperre  |true      |
And I append rows
  |konto |ewsbetr    | kstelle   |
  |K 100 |100.00     |!dontChange|
  |44000 |!dontChange| 101       |
# Dialog 583: "Buchung o.k.?"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
#
Given I open an editor "BuchungMitSperre-2011z5" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  |beleg     |2011z5    |
  |beldat    |02.01.2022|
  |budat     |02.01.2022|
  |zasperre  |true      |
And I append rows
  |konto      |ewsbetr|kstelle    |
  |K KUMITSP  |200.00 |!dontChange|
  |44000      |!dontChange|101        |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
#
Given I open an editor "BuchungOhneSperre-3011z6" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  |beleg     |3011z6    |
  |beldat    |02.01.2022|
  |budat     |02.01.2022|
  |zasperre  |false     |
And I append rows
  |konto      |ewhbetr|kstelle    |
  |L LIMITSP  |50.00  |!dontChange|
  |44000      |!dontChange|101        |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# ----- Daten in den Zeilen 1-6 im Bankkontoauszug 11 an die Verwendung in diesem Test anpassen (Wartung)

Given I'm logged in with password "annette"

Given I open an editor "Bankkontoauszug-11" from table "90:1" with command "UPDATE" for record "11"
#
And I set field "such" to "ZASPERRE"
And I set field "asaldat" to "31.01.2022"
And I set field "esaldat" to "31.01.2022"
And I modify table
  | !row | tbudat     | tvaldat    | tvzweck1 |
  | 1    | 31.01.2022 | 31.01.2022 | Re-Nr.: 1011-1 vom 02.01.2023 |
  | 2    | 31.01.2022 | 31.01.2022 | Re-Nr.: 2011-2 vom 02.01.2023 |
  | 3    | 31.01.2022 | 31.01.2022 | Re-Nr.: 3011-3 vom 02.01.2023 |
  | 4    | 31.01.2022 | 31.01.2022 | Re-Nr.: 1011-4 vom 02.01.2023 |
  | 5    | 31.01.2022 | 31.01.2022 | Re-Nr.: 2011-5 vom 02.01.2023 |
  | 6    | 31.01.2022 | 31.01.2022 | Re-Nr.: 3011-6 vom 02.01.2023 |
#
Then fields have values
  | asaldat   | 31.01.2022 |
  | asalwaehr | EUR        |
  | esaldat   | 31.01.2022 |
  | esalwaehr | EUR        |
  | bkonto    |            |
Then table has values
  | !row | tbudat     | tzabuchart | tbubetr | twaehr | tvzweck1                      | toffen | tkonto | opanzahl |
  | 1    | 31.01.2022 | Gutschrift | 100.00  | EUR    | Re-Nr.: 1011-1 vom 02.01.2023 | 100.00 |        | 0        |
  | 2    | 31.01.2022 | Gutschrift | 200.00  | EUR    | Re-Nr.: 2011-2 vom 02.01.2023 | 200.00 |        | 0        |
  | 3    | 31.01.2022 | Belastung  | -50.00  | EUR    | Re-Nr.: 3011-3 vom 02.01.2023 | -50.00 |        | 0        |
  | 4    | 31.01.2022 | Gutschrift | 100.00  | EUR    | Re-Nr.: 1011-4 vom 02.01.2023 | 100.00 |        | 0        |
  | 5    | 31.01.2022 | Gutschrift | 200.00  | EUR    | Re-Nr.: 2011-5 vom 02.01.2023 | 200.00 |        | 0        |
  | 6    | 31.01.2022 | Belastung  | -50.00  | EUR    | Re-Nr.: 3011-6 vom 02.01.2023 | -50.00 |        | 0        |
And I save the current editor

Given I'm logged in with password "sy"

# ----- Bankkontoauszug 11: automatisch zuordnen ==> Zuordnungen werden erzeugt, OPs nicht zugeordnet

# Die OPs werden nicht zugeordnet, weil OP-Belege passen nicht zum Verwendungszweck, z.B. "1011-1" und "1011z1".
# OPs werden in diesem Scenario manuell zugeordnet.

Given I open an editor "Bankkontoauszug-11" from table "90:1" with command "UPDATE" for record "11"
#
And I set field "bkonto" to "18100"
#
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
#
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr | toffen | tkonto | opanzahl |
  | 1    | 100.00  | 100.00 |        | 0        |
  | 2    | 200.00  | 200.00 |        | 0        |
  | 3    | -50.00  | -50.00 |        | 0        |
  | 4    | 100.00  | 100.00 |        | 0        |
  | 5    | 200.00  | 200.00 |        | 0        |
  | 6    | -50.00  | -50.00 |        | 0        |
#
And I save the current editor

# ----- Bankkontoauszug 11 Zeile 1-3 manuell zuordnen: OPs in der manuellen Zuordnung selektieren

Given I open an editor "Bankkontoauszug-11" from table "90:1" with command "UPDATE" for record "11"
#
# Bankkontoauszug 11 Zeile 1 ==> in die manuelle Zuordnung wechseln
And I press button "tmanuell" to open a subeditor for "manuelle_zuordnung" in row 1
And I set field "sbeleg" to "1011z1"
And I press button "bladen"
# !!! OP mit Zahlungssperre wurde geladen
And I set field "zmarke" to "ja" in row 1
# !!! Zeile mit einem OP mit Zahlungssperre konnte aktiviert werden
Then fields have values
  | konto   | K 100  |
  | szabetr | 100.00 |
  | soffen  | 0.00   |
Then table has values
  | !row | zmarke | tkonto | tbeleg | tzabetr |
  | 1    | ja     | K 100  | 1011z1 | 100.00  |
And I save the current subeditor to switch back to the parent editor
#
# Bankkontoauszug 11 Zeile 2 ==> in die manuelle Zuordnung wechseln
And I press button "tmanuell" to open a subeditor for "manuelle_zuordnung" in row 2
And I set field "sbeleg" to "2011z2"
And I press button "bladen"
# !!! OP mit Zahlungssperre wurde geladen
And I set field "zmarke" to "ja" in row 1
# !!! Zeile mit einem OP mit Zahlungssperre konnte aktiviert werden
Then fields have values
  | konto   | K 200  |
  | szabetr | 200.00 |
  | soffen  | 0.00   |
Then table has values
  | !row | zmarke | tkonto | tbeleg | tzabetr |
  | 1    | ja     | K 200  | 2011z2 | 200.00  |
And I save the current subeditor to switch back to the parent editor
#
# Bankkontoauszug 11 Zeile 3 ==> in die manuelle Zuordnung wechseln
And I press button "tmanuell" to open a subeditor for "manuelle_zuordnung" in row 3
And I set field "sbeleg" to "3011z3"
And I press button "bladen"
# !!! OP mit Zahlungssperre wurde geladen
And I set field "zmarke" to "ja" in row 1
# !!! Zeile mit einem OP mit Zahlungssperre konnte aktiviert werden
Then fields have values
  | konto   | L 300  |
  | szabetr | -50.00 |
  | soffen  | 0.00   |
Then table has values
  | !row | zmarke | tkonto | tbeleg | tzabetr |
  | 1    | ja     | L 300  | 3011z3 | -50.00  |
And I save the current subeditor to switch back to the parent editor
#
And I save the current editor

# -----------------------------------------------------------------------------------------------------
Scenario: OPs mit Zahlungssperre im Bankkontoauszug 11 Zeile 4-6: manuell zuordnen, OP direkt eintragen
# -----------------------------------------------------------------------------------------------------

Given I open an editor "Bankkontoauszug-11" from table "90:1" with command "UPDATE" for record "11"
#
# Bankkontoauszug 11 Zeile 4 ==> in die manuelle Zuordnung wechseln
And I press button "tmanuell" to open a subeditor for "manuelle_zuordnung" in row 4
And I append rows
  |topz     |
  |OP1011z4 |
# !!! OP mit Zahlungssperre wurde geladen
And I set field "zmarke" to "ja" in row 1
# !!! Zeile mit einem OP mit Zahlungssperre konnte aktiviert werden
Then fields have values
  | konto   | K 100  |
  | szabetr | 100.00 |
  | soffen  | 0.00   |
Then table has values
  | !row | zmarke | tkonto | tbeleg | tzabetr |
  | 1    | ja     | K 100  | 1011z4 | 100.00  |
And I save the current subeditor to switch back to the parent editor
#
# Bankkontoauszug 11 Zeile 5 ==> in die manuelle Zuordnung wechseln
And I press button "tmanuell" to open a subeditor for "manuelle_zuordnung" in row 5
And I append rows
  |topz     |
  |OP2011z5 |
# !!! OP mit Zahlungssperre wurde geladen
And I set field "zmarke" to "ja" in row 1
# !!! Zeile mit einem OP mit Zahlungssperre konnte aktiviert werden
Then fields have values
  | konto   | K 200  |
  | szabetr | 200.00 |
  | soffen  | 0.00   |
Then table has values
  | !row | zmarke | tkonto | tbeleg | tzabetr |
  | 1    | ja     | K 200  | 2011z5 | 200.00  |
And I save the current subeditor to switch back to the parent editor
#
# Bankkontoauszug 11 Zeile 6 ==> in die manuelle Zuordnung wechseln
And I press button "tmanuell" to open a subeditor for "manuelle_zuordnung" in row 6
And I append rows
  |topz     |
  |OP3011z6 |
# !!! OP mit Zahlungssperre wurde geladen
And I set field "zmarke" to "ja" in row 1
# !!! Zeile mit einem OP mit Zahlungssperre konnte aktiviert werden
Then fields have values
  | konto   | L 300  |
  | szabetr | -50.00 |
  | soffen  | 0.00   |
Then table has values
  | !row | zmarke | tkonto | tbeleg | tzabetr |
  | 1    | ja     | L 300  | 3011z6 | -50.00  |
And I save the current subeditor to switch back to the parent editor
#
And I save the current editor
