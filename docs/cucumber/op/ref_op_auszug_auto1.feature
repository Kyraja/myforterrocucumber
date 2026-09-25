# *****************************************************************************
#  Name             : ref_op_auszug_auto1.feature
#  Autor            : hc
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Bearbeitung der Bankkontoauszüge (90:1), automatische Zuordnung
#  ref              : ref_op_auszug_auto1_cu
# *******************************************************************************
@persistent
Feature: Bankimport, automatische Zuordnung, Konto-Zuordnung

Background:
Given I set the fake date to "02.01.2022"

# Betroffen:
# - REWE-3667
# - Gutschriften und Belastungen, automatische Zuordnung
# - ZV-Konfig: MUSS-Konto-Zuordnung über Bankverbindung und/oder Verwendungszweck der Zuordnungsmerkmale
#              und/oder über Auftraggebername,
#              und KEINE MUSS- und keine KANN-Zuordnung über den Verwendungszweck der Bankzahlung,
#              d. h. über Beleg, externe belegnummer, Zahlungsreferenz, Kundennummer-Identnummer
#              und Kundenummer-Zuordnungsmerkmale.
#
# Vor der Korrektur : MUSS-Konto-Treffer wird ermittelt aber in der OP-Zuordnung nicht berücksichtigt.
#                     Es werden auch OPs anderer Konten der zugelassenen Konten-Gruppen zugeordner
#                     (in die Tabelle geladen).
#
# Nach der Korrektur: Nur die offenen OPs des MUSS-Konto-Treffers laden.
#
# ---------------------------------------------------------------------------------------------
Scenario: Kunden, Lieferanten und OPs erzeugen, Bankverbindungenund Zuordnungsmerkmale erfassen
# ---------------------------------------------------------------------------------------------
#
Given I open an editor "Kunde-GutBank" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
  | nummer   | 1GutBank    |
  | such     | GUTBANK |
  | zbed     | 200         |
And I save the current editor

Given I open an editor "Kunde-GutZMVerw" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
  | nummer   | 1GutZMV    |
  | such     | GUTZMV |
  | zbed     | 200        |
And I save the current editor

Given I open an editor "Kunde-GutZMAuftr" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
  | nummer   | 1GutZMA    |
  | such     | GUTZMA |
  | zbed     | 200        |
And I save the current editor

Given I open an editor "Kunde-GutSonst" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
  | nummer   | 1GutS |
  | such     | SONST |
  | zbed     | 200   |
And I save the current editor

# ----- Lieferanten erfassen
Given I open an editor "Lieferant-BelBank" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 1BelBank    |
  | such     | BELBANK |
  | zbed     | 200         |
And I save the current editor

Given I open an editor "Lieferant-BelZMVerw" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 1BelZMV |
  | such     | BELZMV |
  | zbed     | 200        |
And I save the current editor

Given I open an editor "Lieferant-BelZMAuftr" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 1BelZMA    |
  | such     | BELZMA |
  | zbed     | 200        |
And I save the current editor

Given I open an editor "Lieferant-BelSonst" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | nummer   | 1BelS    |
  | such     | SONST |
  | zbed     | 200        |
And I save the current editor

# ----- OPs erzeugen (Buchung neu)

Given I open an editor "Buchung-GutBank" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | 1GutBank     |
  | beldat     | 02.01.2022|
  | budat      | 02.01.2022|
And I append rows
  | konto      | ewsbetr     | kstelle     |
  | K 1GutBank | 100.00      | !dontChange |
  | 44000      | !dontChange | 101         |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "Buchung-GutZMAuftr" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | 1GutZMA   |
  | beldat     | 02.01.2022|
  | budat      | 02.01.2022|
And I append rows
  | konto      | ewsbetr     | kstelle     |
  | K 1GutZMA  | 100.00      | !dontChange |
  | 44000      | !dontChange | 101         |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "Buchung-GutZMVerw" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | 1GutZMV   |
  | beldat     | 02.01.2022|
  | budat      | 02.01.2022|
And I append rows
  | konto      | ewsbetr     | kstelle     |
  | K 1GutZMV  | 100.00      | !dontChange |
  | 44000      | !dontChange | 101         |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "Buchung-GutSonst" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | 1GutS     |
  | beldat     | 02.01.2022|
  | budat      | 02.01.2022|
And I append rows
  | konto      | ewsbetr     | kstelle     |
  | K 1GutS    | 100.00      | !dontChange |
  | 44000      | !dontChange | 101         |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "Buchung-BelBank" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | 1BelBank   |
  | beldat     | 02.01.2022 |
  | budat      | 02.01.2022 |
And I append rows
  | konto      | ewhbetr     | kstelle     |
  | L 1BelBank | 100.00      | !dontChange |
  | 54000      | !dontChange | 101         |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "Buchung-BelZMVerw" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | 1BelZMV    |
  | beldat     | 02.01.2022 |
  | budat      | 02.01.2022 |
And I append rows
  | konto     | ewhbetr     | kstelle     |
  | L 1BelZMV | 100.00      | !dontChange |
  | 54000     | !dontChange | 101         |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "Buchung-BelZMAuftr" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | 1BelZMA    |
  | beldat     | 02.01.2022 |
  | budat      | 02.01.2022 |
And I append rows
  | konto     | ewhbetr     | kstelle     |
  | L 1BelZMA | 100.00      | !dontChange |
  | 54000     | !dontChange | 101         |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Given I open an editor "Buchung-BelSonst" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  | beleg      | 1BelS      |
  | beldat     | 02.01.2022 |
  | budat      | 02.01.2022 |
And I append rows
  | konto     | ewhbetr     | kstelle     |
  | L 1BelS   | 100.00      | !dontChange |
  | 54000     | !dontChange | 101         |
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# ----- Bankverbindungen erfassen

Given I open an editor "Bank-BANK-1" from table "96:1" with command "NEW" for record ""
And I set fields
  | nummer   | 1BANK    |
  | such     | BANK     |
  | name     | Bank Bezeichnung |
  | nident   | 14601146 |
And I save the current editor

Given I open an editor "Bankverbindung-KUBankVerb" from table "96:2" with command "NEW" for record ""
And I set fields
  | nummer | 1KUBVerb   |
  | such   | KUBVERB    |
  | konto  | K 1GutBank |
  | koinh  | Kontoinhaber K 1GutBank |
  | bank   | 1BANK      |
  | konum  |            |
  | iban   | DE21500500001234567897 |
And I save the current editor

Given I open an editor "Bankverbindung-LIBankVerb" from table "96:2" with command "NEW" for record ""
And I set fields
  | nummer | 1LIBVerb   |
  | such   | LIBVERB    |
  | konto  | L 1BelBank |
  | koinh  | Kontoinhaber L 1BelBank |
  | bank   | 1BANK      |
  | konum  | 1234567    |
And I save the current editor

# ----- Zuordnungsmerkmale erfassen
#
Given I open an editor "Zurdnungsmerkmal-GutZMVerw" from table "66:5" with command "NEW" for record ""
And I set fields
  | nummer   | 1KUZMV    |
  | such     | KUZMV     |
  | konto    | K 1GutZMV |
  | vzweck   | *GutZMVerw* |
And I save the current editor

Given I open an editor "Zurdnungsmerkmal-GutZMAuftr" from table "66:5" with command "NEW" for record ""
And I set fields
  | nummer | 1KUZMA     |
  | such   | KUZMA      |
  | konto  | K 1GutZMA  |
  | zmname | GutZMAuftr |
And I save the current editor

Given I open an editor "Zurdnungsmerkmal-BelZMVerw" from table "66:5" with command "NEW" for record ""
And I set fields
  | nummer   | 1LIZMV    |
  | such     | LIZMV     |
  | konto    | L 1BelZMV |
  | vzweck   | *BelZMVerw* |
And I save the current editor

Given I open an editor "Zurdnungsmerkmal-BelZMAuftr" from table "66:5" with command "NEW" for record ""
And I set fields
  | nummer | 1LIZMA     |
  | such   | LIZMA      |
  | konto  | L 1BelZMA  |
  | zmname | BelZMAuftr |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Bankkontoauszüge 1 und 3 an den Test anpassen
# ---------------------------------------------------------------------------------------------

Given I'm logged in with password "annette"

Given I open an editor "Bankkontoauszug-1" from table "90:1" with command "UPDATE" for record "1"
And I set field "asaldat" to "31.01.2022"
And I set field "esaldat" to "31.01.2022"
And I modify table
  | !row | tbudat     | tzabuchart | tbubetr | twaehr | tauftrgeb1 | tvzweck1   |
  | 1    | 31.01.2022 | Gutschrift |  100.00 | EUR    |            |            |
  | 2    | 31.01.2022 | Gutschrift |  100.00 | EUR    | GutZMAuftr |            |
  | 3    | 31.01.2022 | Gutschrift |  100.00 | EUR    |            | GutZMVerw  |
#
Then fields have values
  | asaldat   | 31.01.2022 |
  | asalwaehr | EUR        |
  | esaldat   | 31.01.2022 |
  | esalwaehr | EUR        |
  | bkonto    |            |
Then table has values
  | !row | tbudat     | tzabuchart | tbubetr | twaehr | toffen | tkonto | opanzahl | tiban                  | tauftrgeb1 | tvzweck1  |
  | 1    | 31.01.2022 | Gutschrift |  100.00 | EUR    | 100.00 |        | 0        | DE21500500001234567897 |            |           | 
  | 2    | 31.01.2022 | Gutschrift |  100.00 | EUR    | 100.00 |        | 0        |                        | GutZMAuftr |           |
  | 3    | 31.01.2022 | Gutschrift |  100.00 | EUR    | 100.00 |        | 0        |                        |            | GutZMVerw |
And I save the current editor

Given I open an editor "Bankkontoauszug-3" from table "90:1" with command "UPDATE" for record "3"
And I set field "asaldat" to "31.01.2022"
And I set field "esaldat" to "31.01.2022"
And I modify table
  | !row | tbudat     | tzabuchart | tbubetr | twaehr | tbaident | tkonum  | tauftrgeb1 | tvzweck1  |
  | 1    | 31.01.2022 | Belastung  | -100.00 | EUR    | 14601146 | 1234567 |            |           |
  | 2    | 31.01.2022 | Belastung  | -100.00 | EUR    |          |         | BelZMAuftr |           |
  | 3    | 31.01.2022 | Belastung  | -100.00 | EUR    |          |         |            | BelZMVerw |
#
Then fields have values
  | asaldat   | 31.01.2022 |
  | asalwaehr | EUR        |
  | esaldat   | 31.01.2022 |
  | esalwaehr | EUR        |
  | bkonto    |            |
Then table has values
  | !row | tbudat     | tzabuchart | tbubetr | twaehr |  toffen | tkonto | opanzahl | tbaident | tkonum  | tauftrgeb1 | tvzweck1  |
  | 1    | 31.01.2022 | Belastung  | -100.00 | EUR    | -100.00 |        | 0        | 14601146 | 1234567 |            |           | 
  | 2    | 31.01.2022 | Belastung  | -100.00 | EUR    | -100.00 |        | 0        |          |         | BelZMAuftr |           |
  | 3    | 31.01.2022 | Belastung  | -100.00 | EUR    | -100.00 |        | 0        |          |         |            | BelZMVerw |
And I save the current editor

Given I'm logged in with password "sy"

# ---------------------------------------------------------------------------------------------
Scenario Outline: Zuordnungskriterien anlegen
# ---------------------------------------------------------------------------------------------

Given I open an editor "ZKGut" from table "66:10" with command "NEW" for record ""
And I set fields 
  | such          | ZKGut<nr>  |
  | zabuchart     | Gutschrift |
  | zkkunde       | <opku>     |
  | zkbetr        | <betr>     |
  | zkbverb       | <gbverb>   |
  | zkvzweck      | <gvzweck>  |
  | zkauftr       | <gauftr>   |
And I save the current editor
And I close the current editor

Given I open an editor "ZKBel" from table "66:10" with command "NEW" for record ""
And I set fields 
  | such          | ZKBel<nr> |
  | zabuchart     | Belastung |
  | zkkunde       | <opku>    |
  | zklieferant   | <opli>    |
  | zkbverb       | <bbverb>   |
  | zkvzweck      | <bvzweck>  |
  | zkauftr       | <bauftr>   |
  | zkkunzu       | <zkbkunzu> |
And I save the current editor
And I close the current editor

Examples:
|nr|opku|betr|gbverb|gvzweck|gauftr|opli|bbverb|bvzweck|bauftr|zkbkunzu|
| 1|  ja|  ja|  MUSS|       |      |nein|      |       |      |    Kann|
| 2|  ja|  ja|      |       |  MUSS|nein|      |       |      |    Kann|

# ---------------------------------------------------------------------------------------------
Scenario Outline: Zuordnungskriterien anlegen 2
# ---------------------------------------------------------------------------------------------

Given I open an editor "ZKGut" from table "66:10" with command "NEW" for record ""
And I set fields 
  | such          | ZKGut<nr>  |
  | zabuchart     | Gutschrift |
  | zkkunde       | <opku>     |
  | zklieferant   | <opli>     |
  | zkbverb       | <gbverb>   |
  | zkvzweck      | <gvzweck>  |
  | zkauftr       | <gauftr>   |
  | zkkunzu       | <zkgkunzu> |
And I save the current editor
And I close the current editor

Given I open an editor "ZKBel" from table "66:10" with command "NEW" for record ""
And I set fields 
  | such         | ZKBel<nr>  |
  | zabuchart    | Belastung  |
  | zkkunde      | <opku>     |
  | zklieferant  | <opli>     |
  | zkbverb      | <bbverb>   |
  | zkvzweck     | <bvzweck>  |
  | zkauftr      | <bauftr>   |
  | zkkunzu      | <zkbkunzu> |
And I save the current editor
And I close the current editor

Examples:

|nr|opku|gbverb|gvzweck|gauftr|opli|bbverb|bvzweck|bauftr|zkgkunzu|zkbkunzu|
| 3|  ja|      |   MUSS|      |nein|      |       |      |        |    Kann|
| 5|nein|      |       |      |  ja|      |       |  MUSS|    Kann|        |
| 6|nein|      |       |      |  ja|      |   MUSS|      |    Kann|        |

# ---------------------------------------------------------------------------------------------
Scenario: Zuordnungskriterien anlegen 3
# ---------------------------------------------------------------------------------------------

Given I open an editor "ZKGut" from table "66:10" with command "NEW" for record ""
And I set fields 
  | such          | ZKGut4        |
  | zabuchart     | Gutschrift    |
  | zkkunde       | nein          |
  | zklieferant   | ja            |
  | zkbverb       |               |
  | zkvzweck      |               |
  | zkauftr       |               |
  | zkkunzu       | Kann          |
And I save the current editor
And I close the current editor

Given I open an editor "ZKBel" from table "66:10" with command "NEW" for record ""
And I set fields 
  | such        | ZKBel4       |
  | zabuchart   | Belastung    |
  | zklieferant | ja           |
  | zkbetr      | ja           |
  | zkbverb     | MUSS         |
  | zkvzweck    |              |
  | zkauftr     |              |
And I save the current editor
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: ZVKonfig Gutschriften Konto-Zuordnung über Bankverbindung: Muss, Bankkontoauszug 1 zuordnen
# ---------------------------------------------------------------------------------------------

# ----- ZVKonfig anpassen

Given I open an editor "ZVKonfig" from table "66:1" with command "UPDATE" for record "1"
And I set fields
  | zuordkgutschrift | ZKGut1 |
  | zuordkbelastung  | ZKBel1 |
And I save the current editor
And I close the current editor

# ----- Bankkontoauszug 1: automatisch zuordnen

Given I open an editor "Bankkontoauszug-1" from table "90:1" with command "UPDATE" for record "1"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen |   tkonto   | opanzahl |
  | 1    |  100.00 |    0.00 | K 1GutBank | 1        |
  | 2    |  100.00 |  100.00 |            | 0        |
  | 3    |  100.00 |  100.00 |            | 0        |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: ZVKonfig Gutschriften Konto-Zuordnung über Auftraggebername: Muss, Bankkontoauszug 1 zuordnen
# ---------------------------------------------------------------------------------------------

# ----- Bankkontoauszug 1: automatisch zuordnen
Given I open an editor "Bankkontoauszug-1" from table "90:1" with command "UPDATE" for record "1"
#
And I press button "bausschl" to open a subeditor for "Ausschließen"
And I save the current subeditor to switch back to the parent editor
#
And I press button "baufleben" to open a subeditor for "Wiederaufleben"
And I save the current subeditor to switch back to the parent editor
#
And I set fields 
  | zkgutschrift | ZKGut2 |
  | zkbelastung  | ZKBel2 |
#
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen |   tkonto   | opanzahl |
  | 1    |  100.00 |  100.00 |            | 0        |
  | 2    |  100.00 |    0.00 | K 1GutZMA  | 1        |
  | 3    |  100.00 |  100.00 |            | 0        |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: ZVKonfig Gutschriften Konto-Zuordnung über Verwendungszweck: Muss, Bankkontoauszug 1 zuordnen
# ---------------------------------------------------------------------------------------------

# ----- Bankkontoauszug 1: automatisch zuordnen

Given I open an editor "Bankkontoauszug-1" from table "90:1" with command "UPDATE" for record "1"
#
And I press button "bausschl" to open a subeditor for "Ausschließen"
And I save the current subeditor to switch back to the parent editor
#
And I press button "baufleben" to open a subeditor for "Wiederaufleben"
And I save the current subeditor to switch back to the parent editor
#
And I set fields 
  | zkgutschrift | ZKGut3 |
  | zkbelastung  | ZKBel3 |
#
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen |   tkonto   | opanzahl |
  | 1    |  100.00 |  100.00 |            | 0        |
  | 2    |  100.00 |  100.00 |            | 0        |
  | 3    |  100.00 |    0.00 | K 1GutZMV  | 1        |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: ZVKonfig Belastungen Konto-Zuordnung über Bankverbindung: Muss, Bankkontoauszug 3 zuordnen
# ---------------------------------------------------------------------------------------------

# ----- Bankkontoauszug 3: automatisch zuordnen

Given I open an editor "Bankkontoauszug-3" from table "90:1" with command "UPDATE" for record "3"
And I set fields 
#
  | zkgutschrift | ZKGut4 |
  | zkbelastung  | ZKBel4 |
#
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen |   tkonto   | opanzahl |
  | 1    | -100.00 |    0.00 | L 1BelBank | 1        |
  | 2    | -100.00 | -100.00 |            | 0        |
  | 3    | -100.00 | -100.00 |            | 0        |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: ZVKonfig Belastungen Konto-Zuordnung über Auftraggebername: Muss, Bankkontoauszug 3 zuordnen
# ---------------------------------------------------------------------------------------------

# ----- Bankkontoauszug 3: automatisch zuordnen

Given I open an editor "Bankkontoauszug-3" from table "90:1" with command "UPDATE" for record "3"
#
And I press button "bausschl" to open a subeditor for "Ausschließen"
And I save the current subeditor to switch back to the parent editor
And I press button "baufleben" to open a subeditor for "Wiederaufleben"
And I save the current subeditor to switch back to the parent editor
#
And I set fields 
  | zkgutschrift | ZKGut5 |
  | zkbelastung  | ZKBel5 |
#
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen |   tkonto   | opanzahl |
  | 1    | -100.00 | -100.00 |            | 0        |
  | 2    | -100.00 |    0.00 | L 1BelZMA  | 1        |
  | 3    | -100.00 | -100.00 |            | 0        |
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: ZVKonfig Belastungen Konto-Zuordnung über Verwendungszweck: Muss, Bankkontoauszug 3 zuordnen
# ---------------------------------------------------------------------------------------------

# ----- Bankkontoauszug 3: automatisch zuordnen

Given I open an editor "Bankkontoauszug-3" from table "90:1" with command "UPDATE" for record "3"
#
And I press button "bausschl" to open a subeditor for "Ausschließen"
And I save the current subeditor to switch back to the parent editor
And I press button "baufleben" to open a subeditor for "Wiederaufleben"
And I save the current subeditor to switch back to the parent editor
#
And I set fields 
  | zkgutschrift | ZKGut6 |
  | zkbelastung  | ZKBel6 |
#
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# Ergebnisse der Zuordnung in der Tabelle des Bankkontoauszugs prüfen:
Then table has values
  | !row | tbubetr |  toffen |   tkonto   | opanzahl |
  | 1    | -100.00 | -100.00 |            | 0        |
  | 2    | -100.00 | -100.00 |            | 0        |
  | 3    | -100.00 |    0.00 | L 1BelZMV  | 1        |
And I save the current editor
