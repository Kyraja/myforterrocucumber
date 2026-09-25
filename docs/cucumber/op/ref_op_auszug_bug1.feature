# *****************************************************************************
#  Name             : ref_op_auszug_bug1.feature
#  Autor            : hc
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Bearbeitung der Bankkontoauszüge (90:1), Test zu Bug aus REWE-3579
#  ref              : ref_op_auszug_bug1_cu
# *******************************************************************************
@persistent
Feature: Fehlerkorrekturen und kleine Verbesserungen im Bankimport

Background:
Given I set the fake date to "02.01.2022"

# ---------------------------------------------------------------------------------------------
Scenario: Test zu Bug aus REWE-3579
# ---------------------------------------------------------------------------------------------
#
# Betroffen: Belastungen, automatische Zuordnung über Beleg, externe Belegnummer bzw. Zahlungsreferenz
#            Gutschriften, automatische Zuordnung über Zahlungsreferenz
#
# Fehler aus REWE-3579: passender OP wurde nicht gefunden.
# Ursache:
#   Bei der Überprüfung der min. Länge des Teilstrings des Verwendungszwecks wurde das falsche Feld aus
#   der ZVKonfig verwendet:
#     Fall 1.1: Belastungen Zuordnung über Beleg MUSS              : (zv)gbelmin  statt (zv)bbelmin
#     Fall 1.2: Belastungen Zuordnung über Beleg KANN              : (zv)gbelmin  statt (zv)bbelmin
#     Fall 2.1: Belastungen Zuordnung über externe Belegnummer MUSS: (zv)gebelmin statt (zv)bebelmin
#     Fall 2.2: Belastungen Zuordnung über externe Belegnummer KANN: (zv)gebelmin statt (zv)bebelmin
#     Fall 3.1: Belastungen Zuordnung über Zahlungsreferenz MUSS   : (zv)gebelmin statt (zv)bzarmin
#     Fall 3.2: Belastungen Zuordnung über Zahlungsreferenz KANN   : (zv)gebelmin statt (zv)bzarmin
#     Fall 4.1: Gutschriften Zuordnung über Zahlungsreferenz MUSS  : (zv)gebelmin statt (zv)gzarmin
#     Fall 4.2: Gutschriften Zuordnung über Zahlungsreferenz KANN  : (zv)gebelmin statt (zv)gzarmin
#
# Testdaten:
#             ----------------- OP ---------------    ------- Bankkontoauszug -------
#   Fall      konto      beleg  ebeleg  zareferenz    Nummer  Zeile  Verwendungszweck
#   ---------------------------------------------------------------------------------
#   Fall 1.1  L 3579F1   35791    leer        leer         5      1        35791
#   Fall 1.2    -//-      -//-    -//-        -//-      -//-   -//-         -//-
#   Fall 2.1  L 3579F2  Xbeleg   35792        leer         5      2        35792
#   Fall 2.2    -//-      -//-    -//-        -//-      -//-   -//-         -//-
#   Fall 3.1  L 3579F3  Xbeleg    leer       35793         5      3        35793
#   Fall 3.2    -//-      -//-    -//-        -//-      -//-   -//-         -//-
#   Fall 4.1  K 3579F4  Xbeleg    leer       35794         9      1        35794
#   Fall 4.2    -//-      -//-    -//-        -//-      -//-   -//-         -//-
# ---------------------------------------------------------------------------------------------
#
# ----- Lieferanten und Kunden erfassen
Given I open an editor "Lieferant-3579F1" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 3579F1   |
  | such     | LI3579F1 |
  | zbed     | 200      |
And I save the current editor

Given I open an editor "Lieferant-3579F2" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 3579F2   |
  | such     | LI3579F2 |
  | zbed     | 200      |
And I save the current editor

Given I open an editor "Lieferant-3579F3" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 3579F3   |
  | such     | LI3579F3 |
  | zbed     | 200      |
And I save the current editor

Given I open an editor "Kunde-3579F4" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
  | nummer   | 3579F4   |
  | such     | KU3579F4 |
  | zbed     | 200      |
And I save the current editor

# ----- OPs erzeugen (Buchung neu)

Given I open an editor "Buchung-35791" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | 35791      |
  | ebeleg     | Xebeleg    |
  | beldat     | 02.01.2022 |
  | budat      | 02.01.2022 |
And I append rows
  | konto    | ewhbetr     | kstelle     |
  | L 3579F1 | 76.00       | !dontChange |
  |    54000 | !dontChange | 101         |
# Dialog 583: "Buchung o.k.?"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "Buchung-35792" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | Xbeleg     |
  | ebeleg     | 35792      |
  | beldat     | 02.01.2022 |
  | budat      | 02.01.2022 |
And I append rows
  | konto    | ewhbetr     | kstelle     |
  | L 3579F2 | 80.00       | !dontChange |
  |    54000 | !dontChange | 101         |
# Dialog 583: "Buchung o.k.?"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "Buchung-35793" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | Xbeleg     |
  | zareferenz | 35793      |
  | beldat     | 02.01.2022 |
  | budat      | 02.01.2022 |
And I append rows
  | konto    | ewhbetr     | kstelle     |
  | L 3579F3 | 120.00      | !dontChange |
  |    54000 | !dontChange | 101         |
# Dialog 583: "Buchung o.k.?"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "Buchung-35794" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | Xbeleg    |
  | zareferenz | 35794     |
  | beldat     | 02.01.2022|
  | budat      | 02.01.2022|
And I append rows
  | konto    | ewsbetr     | kstelle     |
  | K 3579F4 | 259595.60   | !dontChange |
  | 44000    | !dontChange | 101         |
# Dialog 583: "Buchung o.k.?"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# ----- Daten im Bankkontoauszug 5 an die Verwendung in diesem Test anpassen (Wartung)

Given I'm logged in with password "annette"

Given I open an editor "Bankkontoauszug-5" from table "90:1" with command "UPDATE" for record "5"
And I set field "asaldat" to "31.01.2022"
And I set field "esaldat" to "31.01.2022"
And I modify table
  | !row | tbudat     | tvaldat    | tvzweck1 | tzaref |
  | 1    | 31.01.2022 | 31.01.2022 | 35791    |        |
  | 2    | 31.01.2022 | 31.01.2022 | 35792    |        |
  | 3    | 31.01.2022 | 31.01.2022 | 35793    |        |
#
Then fields have values
  | asaldat   | 31.01.2022 |
  | asalwaehr | EUR        |
  | esaldat   | 31.01.2022 |
  | esalwaehr | EUR        |
  | bkonto    |            |
Then table has values
  | !row | tbudat     | tzabuchart | tbubetr | twaehr | tvzweck1 |  toffen | tkonto | opanzahl |
  | 1    | 31.01.2022 | Belastung  |  -76.00 | EUR    | 35791    |  -76.00 |        | 0        |
  | 2    | 31.01.2022 | Belastung  |  -80.00 | EUR    | 35792    |  -80.00 |        | 0        |
  | 3    | 31.01.2022 | Belastung  | -120.00 | EUR    | 35793    | -120.00 |        | 0        |
And I save the current editor

Given I'm logged in with password "sy"

# ----- Daten im Bankkontoauszug 9 an die Verwendung in diesem Test anpassen (Wartung)

Given I'm logged in with password "annette"

Given I open an editor "Bankkontoauszug-9" from table "90:1" with command "UPDATE" for record "9"
And I set field "asaldat" to "31.01.2022"
And I set field "esaldat" to "31.01.2022"
And I modify table
  | !row | tbudat     | tvaldat    | tvzweck1 | tzaref |
  | 1    | 31.01.2022 | 31.01.2022 | 35794    |        |
#
Then fields have values
  | asaldat   | 31.01.2022 |
  | asalwaehr | EUR        |
  | esaldat   | 31.01.2022 |
  | esalwaehr | EUR        |
  | bkonto    |            |
Then table has values
  | !row | tbudat     | tzabuchart |   tbubetr | twaehr | tvzweck1 |    toffen | tkonto | opanzahl |
  | 1    | 31.01.2022 | Gutschrift | 259595.60 | EUR    | 35794    | 259595.60 |        | 0        |
And I save the current editor

Given I'm logged in with password "sy"

# ----- Fall 1.1: Belastungen Zuordnung über Beleg MUSS
#
Given I open an editor "ZK" from table "66:10" with command "NEW" for record ""
And I set fields
  | such          | ZKGut1     |
  | zabuchart     | Gutschrift |
  | zkkunde       | nein       |
  | zklieferant   | ja         |
  | zkbeleg       |            |
  | zkebeleg      |            |
  | zkzaref       |            |
# | zkbelmin      | 6          |
  | zkkunzu       | Kann       |
And I save the current editor
And I close the current editor

Given I open an editor "ZK" from table "66:10" with command "NEW" for record ""
And I set fields
  | such          | ZKBel1    |
  | zabuchart     | Belastung |
  | zklieferant   | ja        |
  | zkbeleg       | Muss      |
  | zkebeleg      |           |
  | zkzaref       |           |
And I save the current editor
And I close the current editor

Given I open an editor "ZVKonfig" from table "66:1" with command "UPDATE" for record "1"
And I set fields
  | zuordkgutschrift | ZKGut1 |
  | zuordkbelastung  | ZKBel1 |
And I save the current editor
And I close the current editor

# Bankkontoauszug 5: automatisch zuordnen
Given I open an editor "Bankkontoauszug-5" from table "90:1" with command "UPDATE" for record "5"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen |   tkonto | opanzahl |
  | 1    |  -76.00 |    0.00 | L 3579F1 | 1        |
  | 2    |  -80.00 |  -80.00 |          | 0        |
  | 3    | -120.00 | -120.00 |          | 0        |
And I save the current editor

# ----- Fall 1.2: Belastungen Zuordnung über Beleg KANN
#
Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKGut1"
And I set fields
  | zkkunde  | nein |
  | zkbeleg  |      |
  | zkebeleg |      |
  | zkzaref  |      |
# | zkbelmin | 6    |
  | zkkunzu  | Kann |
And I save the current editor
And I close the current editor

Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKBel1"
And I set fields
  | zklieferant   | ja   |
  | zkbeleg       | Kann |
  | zkebeleg      |      |
  | zkzaref       |      |
And I save the current editor
And I close the current editor

# Bankkontoauszug 5: automatisch zuordnen
Given I open an editor "Bankkontoauszug-5" from table "90:1" with command "UPDATE" for record "5"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen | tkonto   | opanzahl |
  | 1    |  -76.00 |    0.00 | L 3579F1 | 1        |
  | 2    |  -80.00 |  -80.00 |          | 0        |
  | 3    | -120.00 | -120.00 |          | 0        |
And I save the current editor

# ----- Fall 2.1: Belastungen Zuordnung über externe Belegnummer MUSS
#
Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKGut1"
And I set fields
  | zkkunde   | nein |
  | zkbeleg   |      |
  | zkebeleg  |      |
  | zkzaref   |      |
#  | zkebelmin | 6    |
  | zkkunzu   | Kann |
And I save the current editor
And I close the current editor

Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKBel1"
And I set fields
  | zklieferant | ja   |
  | zkbeleg     |      |
  | zkebeleg    | Muss |
  | zkzaref     |      |
And I save the current editor
And I close the current editor

# Bankkontoauszug 5: automatisch zuordnen
Given I open an editor "Bankkontoauszug-5" from table "90:1" with command "UPDATE" for record "5"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen | tkonto   | opanzahl |
  | 1    |  -76.00 |  -76.00 |          | 0        |
  | 2    |  -80.00 |    0.00 | L 3579F2 | 1        |
  | 3    | -120.00 | -120.00 |          | 0        |
And I save the current editor

# ----- Fall 2.2: Belastungen Zuordnung über externe Belegnummer KANN
#
Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKGut1"
And I set fields
  | zkkunde   | nein |
  | zkbeleg   |      |
  | zkebeleg  |      |
  | zkzaref   |      |
# | zkebelmin | 6    |
  | zkkunzu   | Kann |
And I save the current editor
And I close the current editor

Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKBel1"
And I set fields
  | zklieferant | ja   |
  | zkbeleg     |      |
  | zkebeleg    | Kann |
  | zkzaref     |      |
And I save the current editor
And I close the current editor

# Bankkontoauszug 5: automatisch zuordnen
Given I open an editor "Bankkontoauszug-5" from table "90:1" with command "UPDATE" for record "5"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen | tkonto   | opanzahl |
  | 1    |  -76.00 |  -76.00 |          | 0        |
  | 2    |  -80.00 |    0.00 | L 3579F2 | 1        |
  | 3    | -120.00 | -120.00 |          | 0        |
And I save the current editor

# ----- Fall 3.1: Belastungen Zuordnung über Zahlungsreferenz MUSS
#
Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKGut1"
And I set fields
  | zkkunde   | nein |
  | zkbeleg   |      |
  | zkebeleg  |      |
  | zkzaref   |      |
# | zkebelmin | 6    |
  | zkkunzu   | Kann |
And I save the current editor
And I close the current editor

Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKBel1"
And I set fields
  | zklieferant | ja   |
  | zkbeleg     |      |
  | zkebeleg    |      |
  | zkzaref     | Muss |
And I save the current editor
And I close the current editor

# Bankkontoauszug 5: automatisch zuordnen
Given I open an editor "Bankkontoauszug-5" from table "90:1" with command "UPDATE" for record "5"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
Then table has values
  | !row | tbubetr |  toffen | tkonto   | opanzahl |
  | 1    |  -76.00 |  -76.00 |          | 0        |
  | 2    |  -80.00 |  -80.00 |          | 0        |
  | 3    | -120.00 |    0.00 | L 3579F3 | 1        |
And I save the current editor

# ----- Fall 3.2: Belastungen Zuordnung über Zahlungsreferenz KANN
#
Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKGut1"
And I set fields
  | zkkunde   | nein |
  | zkbeleg   |      |
  | zkebeleg  |      |
  | zkzaref   |      |
# | zkebelmin | 6    |
  | zkkunzu   | Kann |
And I save the current editor
And I close the current editor

Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKBel1"
And I set fields
  | zklieferant | ja   |
  | zkbeleg     |      |
  | zkebeleg    |      |
  | zkzaref     | Kann |
And I save the current editor
And I close the current editor

# Bankkontoauszug 5: automatisch zuordnen
Given I open an editor "Bankkontoauszug-5" from table "90:1" with command "UPDATE" for record "5"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
Then table has values
  | !row | tbubetr |  toffen | tkonto   | opanzahl |
  | 1    |  -76.00 |  -76.00 |          | 0        |
  | 2    |  -80.00 |  -80.00 |          | 0        |
  | 3    | -120.00 |    0.00 | L 3579F3 | 1        |
And I save the current editor

# ----- Fall 4.1: Gutschriften Zuordnung über Zahlungsreferenz MUSS
#

Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKGut1"
And I set fields
  | zkkunde   | ja   |
  | zkbeleg   |      |
  | zkebeleg  |      |
  | zkzaref   | Muss |
#  | zkebelmin | 6    |
And I save the current editor
And I close the current editor

Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKBel1"
And I set fields
  | zklieferant  | nein |
  | zkkunde      |   ja |
  | zkbeleg      |      |
  | zkebeleg     |      |
  | zkzaref      |      |
  #
  | zkkunzu      | Kann |
And I save the current editor
And I close the current editor

# Bankkontoauszug 9: automatisch zuordnen
Given I open an editor "Bankkontoauszug-9" from table "90:1" with command "UPDATE" for record "9"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
Then table has values
  | !row |   tbubetr |    toffen |   tkonto | opanzahl |
  | 1    | 259595.60 |      0.00 | K 3579F4 | 1        |
And I save the current editor

# ----- Fall 4.2: Gutschriften Zuordnung über Zahlungsreferenz KANN
#
Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKGut1"
And I set fields
  | zkkunde   | ja   |
  | zkbeleg   |      |
  | zkebeleg  |      |
  | zkzaref   | Kann |
# | zkebelmin | 6    |
And I save the current editor
And I close the current editor

Given I open an editor "ZK" from table "66:10" with command "UPDATE" for record "ZKBel1"
And I set fields
  | zklieferant | nein |
  | zkbeleg     |      |
  | zkebeleg    |      |
  | zkzaref     |      |
#
  | zkkunzu     | Kann |
And I save the current editor
And I close the current editor

# Bankkontoauszug 9: automatisch zuordnen
Given I open an editor "Bankkontoauszug-9" from table "90:1" with command "UPDATE" for record "9"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
Then table has values
  | !row |   tbubetr |    toffen |   tkonto | opanzahl |
  | 1    | 259595.60 |      0.00 | K 3579F4 | 1        |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Test zu Bug aus REWE-3933
# ---------------------------------------------------------------------------------------------
#
# Betroffen: manuelle Zuordnung, Zeile mit OP, Skontobetrag
#
# Fehler aus REWE-3933: fehlende Nachbehandlung für Skontobetrag, wenn Zahlungsbetrag nicht vorbelegt.

# ----- Kunden erfassen
Given I open an editor "Kunde-3933" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
  | nummer   | 3933   |
  | such     | KU3933 |
  | zbed     | 200    |
And I save the current editor

Given I open an editor "Lieferant-3933" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 3933   |
  | such     | LI3933 |
  | zbed     | 200    |
And I save the current editor
# ----- OPs erzeugen (Buchung neu)

Given I open an editor "Buchung-3933F1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | 3933F1    |
  | beldat     | 02.01.2022|
  | budat      | 02.01.2022|
And I append rows
  | konto  | ewsbetr     | kstelle     |
  | K 3933 | 103.00      | !dontChange |
  | 44000  | !dontChange | 101         |
# Dialog 583: "Buchung o.k.?"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "Buchung-3933F2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | 3933F2    |
  | beldat     | 02.01.2022|
  | budat      | 02.01.2022|
And I append rows
  | konto  | ewsbetr     | kstelle     |
  | K 3933 | 210.00      | !dontChange |
  | 44000  | !dontChange | 101         |
# Dialog 583: "Buchung o.k.?"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "Buchung-3933F3" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | 3933F3    |
  | beldat     | 02.01.2022|
  | budat      | 02.01.2022|
And I append rows
  | konto  | ewsbetr     | kstelle     |
  | K 3933 |  -50.00     | !dontChange |
  | 44000  | !dontChange | 101         |
# Dialog 583: "Buchung o.k.?"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# ----- Daten im Bankkontoauszug 1 an die Verwendung in diesem Test anpassen (Wartung)

Given I'm logged in with password "annette"

Given I open an editor "Bankkontoauszug-1" from table "90:1" with command "UPDATE" for record "1"
And I set field "asaldat" to "31.01.2022"
And I set field "esaldat" to "31.01.2022"
And I modify table
  | !row | tbudat     | tvaldat    |
  | 1    | 31.01.2022 | 31.01.2022 |
  | 2    | 31.01.2022 | 31.01.2022 |
  | 3    | 31.01.2022 | 31.01.2022 |
#
Then fields have values
  | asaldat   | 31.01.2022 |
  | asalwaehr | EUR        |
  | esaldat   | 31.01.2022 |
  | esalwaehr | EUR        |
  | bkonto    |            |
Then table has values
  | !row | tbudat     | tzabuchart | tbubetr | twaehr |  toffen | tkonto | opanzahl |
  | 1    | 31.01.2022 | Gutschrift |  100.00 | EUR    |  100.00 |        | 0        |
  | 2    | 31.01.2022 | Gutschrift |  200.00 | EUR    |  200.00 |        | 0        |
  | 3    | 31.01.2022 |  Belastung |  -50.00 | EUR    |  -50.00 |        | 0        |
And I save the current editor

Given I'm logged in with password "sy"

# ----- Daten im Bankkontoauszug 1 bearbeiten

# ZVKonfig: "Offene Posten ausgleiche" deaktivier für Gutschriften und Belastungen
# TODO: Vorbelegung in ZVKonfigprüfen

# Bankkontoauszug 1: automatisch zuordnen
Given I open an editor "Bankkontoauszug-1" from table "90:1" with command "UPDATE" for record "1"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen |   tkonto | opanzahl |
  | 1    |  100.00 |  100.00 |          | 0        |
  | 2    |  200.00 |  200.00 |          | 0        |
  | 3    |  -50.00 |  -50.00 |          | 0        |

# In die manuelle Zuordnung in Zeile 1 wechseln
And I press button "tmanuell" to open a subeditor for "Manuelle Zuordnung" in row 1
# OP laden
And I set fields
  |sbeleg   |3933F1|
And I press button "bladen"
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr |opskrebetr|tzabetr|tsksatz|tskbetr|treoffen |tiwbu|budm|skdm|ezkurs  |
  |1   |nein  |K 3933|3933F1 |EUR   |103.00  |103.00    |0.00   |0      |0.00   |103.00   |EUR  |0.00|0.00|1.000000|
Then fields have values
  |konto  |      |
  |sbubetr|100.00|
  |szabetr|  0.00|
  |soffen |100.00|
# --- Test Skontobetrag: OP-Zuordnung aktivieren (-> tzabetr = 100.00, skbetr = 0.00), tskbetr vorbelegen (-> treoffen = 0.00)
And I set field "zmarke" to "ja" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm  |skdm|ezkurs  |
  |1   |ja    |K 3933|3933F1 |EUR   |103.00 |103.00    |100.00  |0      |0.00   |3.00    |EUR  |100.00|0.00|1.000000|
Then fields have values
  |konto  |K 3933|
  |sbubetr|100.00|
  |szabetr|100.00|
  |soffen |  0.00|
And I set field "tskbetr" to "3" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm  |skdm|ezkurs  |
  |1   |ja    |K 3933|3933F1 |EUR   |103.00 |103.00    |100.00  |   2.91|   3.00|    0.00|EUR  |100.00|3.00|1.000000|
Then fields have values
  |konto  |K 3933|
  |sbubetr|100.00|
  |szabetr|100.00|
  |soffen |  0.00|
# ---
# OP-Zuordnung deaktivieren
And I set field "zmarke" to "nein" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr |opskrebetr|tzabetr|tsksatz|tskbetr|treoffen |tiwbu|budm|skdm|ezkurs  |
  |1   |nein  |K 3933|3933F1 |EUR   |103.00  |103.00    |0.00   |0      |0.00   |103.00   |EUR  |0.00|0.00|1.000000|
Then fields have values
  |konto  |      |
  |sbubetr|100.00|
  |szabetr|  0.00|
  |soffen |100.00|
# OP-Zuordnung aktivieren (-> tzabetr = 100.00, skbetr = 0.00)
And I set field "zmarke" to "ja" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm  |skdm|ezkurs  |
  |1   |ja    |K 3933|3933F1 |EUR   |103.00 |103.00    |100.00  |0      |0.00   |3.00    |EUR  |100.00|0.00|1.000000|
Then fields have values
  |konto  |K 3933|
  |sbubetr|100.00|
  |szabetr|100.00|
  |soffen |  0.00|
# --- Test Skontobetrag: tzabetr auf 0.00 setzen, tskbetr mit 3.00 vorbelegen (-> tzabetr = 100.00, treoffen = 0.00)
And I set field "tzabetr" to "0.00" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm|skdm|ezkurs  |
  |1   |ja    |K 3933|3933F1 |EUR   |103.00 |103.00    |0.00    |0      |0.00   |103.00  |EUR  |0.00|0.00|1.000000|
And I set field "tskbetr" to "3" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm  |skdm|ezkurs  |
  |1   |ja    |K 3933|3933F1 |EUR   |103.00 |103.00    |100.00  |2.91   |3.00   |0.00    |EUR  |100.00|3.00|1.000000|
# ---
Then fields have values
  |konto  |K 3933|
  |sbubetr|100.00|
  |szabetr|100.00|
  |soffen |  0.00|
And I save the current subeditor to switch back to the parent editor

# In die manuelle Zuordnung in Zeile 2 wechseln
And I press button "tmanuell" to open a subeditor for "Manuelle Zuordnung" in row 2
# Manuelle Zuordnung: OP laden
And I set fields
  |sbeleg   |3933F2|
And I press button "bladen"
Then table has values
  |!row|zmarke|tkonto|tbeleg|twaehr|trebetr |opskrebetr|tzabetr|tsksatz|tskbetr|treoffen|tiwbu|budm|skdm|ezkurs  |
  |1   |nein  |K 3933|3933F2|EUR   |210.00  |210.00    |0.00   |0      |0.00   |210.00  |EUR  |0.00|0.00|1.000000|
Then fields have values
  |konto  |      |
  |sbubetr|200.00|
  |szabetr|  0.00|
  |soffen |200.00|
# Manuelle Zuordnung: OP zuordnen
And I set field "zmarke" to "ja" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm  |skdm|ezkurs  |
  |1   |ja    |K 3933|3933F2 |EUR   |210.00 |210.00    |200.00  |0      |0.00   |10.00   |EUR  |200.00|0.00|1.000000|
Then fields have values
  |konto  |K 3933|
  |sbubetr|200.00|
  |szabetr|200.00|
  |soffen |  0.00|
# Manuelle Zuordnung: Skontoprozentsatz vorbelegen
And I set field "tsksatz" to "2" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm  |skdm|ezkurs  |
  |1   |ja    |K 3933|3933F2 |EUR   |210.00 |210.00    |205.80  |2      |4.20   |    0.00|EUR  |205.80|4.20|1.000000|
Then fields have values
  |konto  |K 3933|
  |sbubetr|200.00|
  |szabetr|205.80|
  |soffen | -5.80|
# Manuelle Zuordnung: Skontobetrag mit gleichem Wert 4.20 überschreiben
And I set field "tskbetr" to "4.20" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm  |skdm|ezkurs  |
  |1   |ja    |K 3933|3933F2 |EUR   |210.00 |210.00    |205.80  |2      |4.20   |    0.00|EUR  |205.80|4.20|1.000000|
Then fields have values
  |konto  |K 3933|
  |sbubetr|200.00|
  |szabetr|205.80|
  |soffen | -5.80|
# Test: 
# Manuelle Zuordnung: OP-Zuordnung deaktivieren
And I set field "zmarke" to "nein" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg|twaehr|trebetr |opskrebetr|tzabetr|tsksatz|tskbetr|treoffen|tiwbu|budm|skdm|ezkurs  |
  |1   |nein  |K 3933|3933F2|EUR   |210.00  |210.00    |0.00   |0      |0.00   |210.00  |EUR  |0.00|0.00|1.000000|
Then fields have values
  |konto  |      |
  |sbubetr|200.00|
  |szabetr|  0.00|
  |soffen |200.00|
# Manuelle Zuordnung: OP-Zuordnung aktivieren
And I set field "zmarke" to "ja" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm  |skdm|ezkurs  |
  |1   |ja    |K 3933|3933F2 |EUR   |210.00 |210.00    |200.00  |0      |0.00   |10.00   |EUR  |200.00|0.00|1.000000|
Then fields have values
  |konto  |K 3933|
  |sbubetr|200.00|
  |szabetr|200.00|
  |soffen |  0.00|
# Manuelle Zuordnung: Skontobetrag vorbelegen
And I set field "tskbetr" to "4.20" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm  |skdm|ezkurs  |
  |1   |ja    |K 3933|3933F2 |EUR   |210.00 |210.00    |200.00  |2.06   |4.20   |5.80    |EUR  |200.00|4.20|1.000000|
Then fields have values
  |konto  |K 3933|
  |sbubetr|200.00|
  |szabetr|200.00|
  |soffen |  0.00|
# Test: 
# Manuelle Zuordnung: OP-Zuordnung deaktivieren
And I set field "zmarke" to "nein" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg|twaehr|trebetr |opskrebetr|tzabetr|tsksatz|tskbetr|treoffen|tiwbu|budm|skdm|ezkurs  |
  |1   |nein  |K 3933|3933F2|EUR   |210.00  |210.00    |0.00   |0      |0.00   |210.00  |EUR  |0.00|0.00|1.000000|
Then fields have values
  |konto  |      |
  |sbubetr|200.00|
  |szabetr|  0.00|
  |soffen |200.00|
# Manuelle Zuordnung: OP-Zuordnung aktivieren
And I set field "zmarke" to "ja" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm  |skdm|ezkurs  |
  |1   |ja    |K 3933|3933F2 |EUR   |210.00 |210.00    |200.00  |0      |0.00   |10.00   |EUR  |200.00|0.00|1.000000|
Then fields have values
  |konto  |K 3933|
  |sbubetr|200.00|
  |szabetr|200.00|
  |soffen |  0.00|
# Manuelle Zuordnung: Zahlungsbetrag und Skontobetrag vorbelegen
And I set field "tzabetr" to "100.00" in row 1
And I set field "tskbetr" to "2.10" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm  |skdm|ezkurs  |
  |1   |ja    |K 3933|3933F2 |EUR   |210.00 |210.00    |100.00  |2.06   |2.10   |107.90  |EUR  |100.00|2.10|1.000000|
Then fields have values
  |konto  |K 3933|
  |sbubetr|200.00|
  |szabetr|100.00|
  |soffen |100.00|
# Zurück in den Bankkontoauszug
And I save the current subeditor to switch back to the parent editor

# In die manuelle Zuordnung in Zeile 3 wechseln
And I press button "tmanuell" to open a subeditor for "Manuelle Zuordnung" in row 3
# Manuelle Zuordnung: OP laden
And I set fields
  |sbeleg   |3933F3|
And I press button "bladen"
Then table has values
  |!row|zmarke|tkonto|tbeleg|twaehr|trebetr |opskrebetr|tzabetr|tsksatz|tskbetr|treoffen|tiwbu|budm|skdm|ezkurs  |
  |1   |nein  |K 3933|3933F3|EUR   |-50.00  |-50.00    |0.00   |0      |0.00   |-50.00  |EUR  |0.00|0.00|1.000000|
Then fields have values
  |konto  |      |
  |sbubetr|-50.00|
  |szabetr|  0.00|
  |soffen |-50.00|
# Manuelle Zuordnung: OP zuordnen
And I set field "zmarke" to "ja" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm|skdm|ezkurs  |
  |1   |ja    |K 3933|3933F3 |EUR   |-50.00 |-50.00    |-50.00  |0      |0.00   |0.00    |EUR  |-50.00|0.00|1.000000|
Then fields have values
  |konto  |K 3933|
  |sbubetr|-50.00|
  |szabetr|-50.00|
  |soffen |  0.00|
# Manuelle Zuordnung: Skontobetrag vorbelegen
And I set field "tskbetr" to "-2.10" in row 1
Then table has values
  |!row|zmarke|tkonto|tbeleg |twaehr|trebetr|opskrebetr|tzabetr |tsksatz|tskbetr|treoffen|tiwbu|budm  |skdm |ezkurs  |
  |1   |ja    |K 3933|3933F3 |EUR   |-50.00 |-50.00    |-50.00  |4.03   |-2.10  |2.10    |EUR  |-50.00|-2.10|1.000000|
Then fields have values
  |konto  |K 3933|
  |sbubetr|-50.00|
  |szabetr|-50.00|
  |soffen |  0.00|
And I save the current subeditor to switch back to the parent editor

# Werte in Bankkontoauszug 1 nach Schliessen der manuellen Zuordnung prüfen
Then table has values
  |!row|tbubetr|toffen|tkonto|opanzahl|opsoffen|
  |1   |100.00 |0.00  |K 3933|1       |0.00    |
  |2   |200.00 |100.00|K 3933|1       |107.90  | 
  |3   |-50.00 |0.00  |K 3933|1       |2.10    |

And I save the current editor
