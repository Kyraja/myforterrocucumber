# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert_edit_002_evbukenn.feature
#  Datum     : 01.07.2025
#  Autor     : wane
#  Verantwortlich : wane
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - EDIT: evbukenn bei LS
#
#
#             Testfaelle bis Fall_12 moeglich
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert"
Background:

Given I set the fake date to "02.01.2002"


Scenario: Vorbereitung

Given I open an editor "kontenrahmen" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "jekkenn" to "EK"
And I set field "jvkkenn" to "VK"
And I save the current editor
And I close the current editor
# #######################################################################################


Scenario: Fall_09

#
#  09BE001 --- 09RE001
#  100 St.     20 St.
#     \
#      \-------------- 09LS001
#       \              10 St.
#        \
#         \----------------------- 09LS002
#          \                       10 St.
#
#-- 1 -------- 2 ----- 3 --------- 4 ---------> Zeitstrahl



# 1: Bestellung
Given I open an editor "09BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 09BE001 |
   | lief    | 001fa9  |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL9 | 100 | Stück |
And I save the current editor


# 2: Rechnung 09RE001
Given I open an editor "09RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "09BE001"
And I set fields
   | nummer | 09RE001 |
   | ueb    | ja      |
   | vom    | .       |
Then field "bukenn" has value "EK"
And I set field "mge" to "20" in row 1
Then field "ngeliefertremge" has value "20" in row 1
Then field "konto" has value "36fall9" in row 1
Then field "vorgangskonto" has value "1ifall9" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "36fall9" in row 1
#
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# 3: Lieferschein 1
Given I open an editor "09LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "09BE001"
And I set fields
   | nummer | 09LS001 |
   | ueb    | ja      |
   | vom    | .       |
Then field "bukenn" has value "EK"
Then field "fakt" has value "nein"
And I set field "mge" to "10" in row 1
And I save the current editor

# Ueberpruefung, ob bukenn in der Buchung angekommen ist
Given I open an editor "buchung1" from table "(Entry):(Entry)" with command "VIEW" for record "$,,@richtung=rückwärts;@maxtreffer=1"
Then field "kenn" has value "EK"
And I close the current editor

# 4: Lieferschein 2
Given I open an editor "09LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "09BE001"
And I set fields
   | nummer | 09LS002 |
   | ueb    | ja      |
   | vom    | .       |
Then field "bukenn" has value "EK"
# das Feld wird geleert
And I set field "bukenn" to ""
Then field "fakt" has value "nein"
And I set field "mge" to "10" in row 1
And I save the current editor

# Ueberpruefung, ob bukenn in der Buchung trotzdem gefuellt wurde
Given I open an editor "buchung2" from table "(Entry):(Entry)" with command "VIEW" for record "$,,@richtung=rückwärts;@maxtreffer=1"
Then field "kenn" has value "DI"
And I close the current editor
# #######################################################################################
