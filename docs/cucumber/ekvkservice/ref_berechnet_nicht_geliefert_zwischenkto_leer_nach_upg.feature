# ***************************************************************************
#  Name      : ref_berechnet_nicht_geliefert_zwischenkto_leer_nach_upg.feature
#  Datum     : 2025
#  Autor     : uo
#  Verantwortlich : uo
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - nach dem Upgrade
#
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert" nach dem Upgrade
Background:
Given I set the fake date to "06.01.2002"

# =====================================================================================

Scenario: Ausgangszustand Warengruppen ohne Zwischenkonto

Given I open an editor "stdwg" from table "(Company):(MaterialGroup)" with command "VIEW" for record "55"
Then field "bestbernigel" has value ""
And I close the current editor

Given I open an editor "stdwg" from table "(Company):(MaterialGroup)" with command "VIEW" for record "56"
Then field "bestbernigel" has value ""
And I close the current editor


Given I open an editor "wg-in-e1" from table "(Part):(Product)" with command "UPDATE" for record "E1"
And I set field "wgruppe" to "56"
And I save the current editor


# =====================================================================================

Scenario: Erfassungsversuch einer Bestellung ohne Zwischenkonto in der STD-WG
# BE-STD-WG-UNGUELTIG-WG-Berechnet, nicht geliefert

#  1535 de      |Standardkontierung, Steuerschlssel oder Buchungskreise fehlerhaft
Given opening an editor from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record "" throws the exception "1535"

# =====================================================================================

Scenario: Std-WG pflegen, danach gültig

Given I open an editor "stdwg-korrigieren" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "55"
And I set field "bestbernigel" to "36301"
And I save the current editor

# =====================================================================================

Scenario: Speichern einer Rechnung ohne Zwischenkonto nach dem Upgrade nun immer noch in einer NICHT-STD-WG
#
#  1BE001 ---1RE001
#  100 St.   100 St.
#
#-- 1 ------ 2 ----- 3 --------- 4 ----- 5 ------> Zeitstrahl

# 1: Bestellung
Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 72858b |
   | lief    | 1 |
And I append rows
   | artikel   | mge | he    |
   | E1        |   1 | Stück |
And I save the current editor


# 2: Rechnung nur erfassen und speichern
Given I open an editor "1RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "72858b"
And I set fields
   | nummer | 72858r  |
   | ueb    | nein    |
   | vom    | .       |

Then field "konto" has value "11100" in row 1
Then field "vorgangskonto" has value "11100" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "zwischenkonto" has value "" in row 1
And I set field "mge" to "1" in row 1
# Hier passiert ein Fehler: leeres Zwischenkonto wird verwendet!!!
Then field "konto" has value "" in row 1
Then field "vorgangskonto" has value "11100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# =====================================================================================

Scenario: Buchen einer EK-Rechnung ohne Zwischenkonto nach dem Upgrade nicht möglich

Given I open an editor "1RE001-buchen-plausi" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "72858r"
And I set field "ueb" to "ja"

Then field "konto" has value "" in row 1
Then field "vorgangskonto" has value "11100" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "zwischenkonto" has value "" in row 1
# And I respond with answer "ja" to the dialog with id "4841"

# Konto Im Einkauf berechneter, noch nicht erhaltener Lagerbestand fehlt in der Warengruppe. Bitte Konto eintragen.
And saving the current editor throws the exception "3735"
