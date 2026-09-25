# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert_edit_003_buvorschau.feature
#  Datum     : 15.09.2025
#  Autor     : wane
#  Verantwortlich : wane
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - EDIT: Buchungsvorschau in EK RE
#
#
#             Testfaelle bis Fall_15 moeglich
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert"
Background:

Given I set the fake date to "02.01.2002"



Scenario: Fall_13

#
#  13BE001 --- 13RE001 - 13WGS01
#  100 St.     50 St.    10 EUR
#     \
#      \------------------------ 13LS001
#       \                        10 St.
#        \
#         \-------------------------------- 13LS002
#          \                                90 St.
#
#-- 1 -------- 2 ------- 3 ----- 4 -------- 5 -------> Zeitstrahl



# 1: Bestellung
Given I open an editor "13BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 13BE001 |
   | lief    | 001fa13 |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL13 | 100 | Stück |
And I save the current editor
And I close the current editor


# 2: Rechnung 13RE001
Given I open an editor "13RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "13BE001"
And I set fields
   | nummer | 13RE001 |
   | vom    | .       |
Then field "bukenn" has value "EK"
And I set field "mge" to "50" in row 1
Then field "ngeliefertremge" has value "50" in row 1
Then field "konto" has value "36fall13" in row 1
Then field "vorgangskonto" has value "1ifall13" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "50" in row 1
Then field "zwischenkonto" has value "36fall13" in row 1
#
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# unverbuchte Rechnung oeffnen und Buchungsvorschau aufrufen
Given I open an editor "ekrechnung" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "13RE001"
And I press button "buvo" to open a subeditor for "buchungsvorschau"
Then field "konto" has value "L 001fa13" in row 1
Then field "ewhbetr" has value "754.00" in row 1
Then field "konto" has value "36fall13" in row 2
Then field "nummer" is empty
And I close the current editor
And I switch the current editor to editor "ekrechnung"
#jetzt Rechnung buchen
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor

# nochmal gebuchte RE aufrufen und testen, ob Fibu-Buchung ueber Button "buvo" erreichbar ist
Given I open an editor "ekrechnung2" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+13RE001"
And I press button "buvo" to open a subeditor for "buchungsvorschau2"
Then field "konto" has value "L 001fa13" in row 1
Then field "ewhbetr" has value "754.00" in row 1
Then field "konto" has value "36fall13" in row 2
Then field "nummer" is not empty
And I close the current editor
And I switch the current editor to editor "ekrechnung2"
Then field "nummer" is not empty
And I close the current editor

# 3: Wertgutschrift 13WGS01
Given I open an editor "13WGS01" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+13RE001"
And I set fields
   | nummer | 13WGS01 |
   | vom    | .       |
And I set field "mge" to "-20" in row 1
And I set field "pwert" to "-10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "13BE001" in row 1
And I save the current editor

# unverbuchte Rechnung bzw. WGS oeffnen und Buchungsvorschau aufrufen
Given I open an editor "ekwgs01" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "13WGS01"
And I press button "buvo" to open a subeditor for "buchungsvorschau3"
Then field "konto" has value "L 001fa13" in row 1
Then field "ewhbetr" has value "0.00" in row 1
Then field "konto" has value "36fall13" in row 2
Then field "ewhbetr" has value "10.00" in row 2
Then field "nummer" is empty
And I close the current editor
And I switch the current editor to editor "ekwgs01"
#jetzt Rechnung buchen
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor

# 4: Lieferschein 1
Given I open an editor "lief-13LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "13BE001"
And I set fields
   | nummer | 13LS001 |
   | ueb    | ja      |
   | vom    | .       |
Then field "bukenn" has value "EK"
Then field "fakt" has value "nein"
And I set field "mge" to "10" in row 1
And I save the current editor

# 5: Lieferschein 2
Given I open an editor "13LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "13BE001"
And I set fields
   | nummer | 13LS002 |
   | ueb    | ja      |
   | vom    | .       |
Then field "bukenn" has value "EK"
# das Feld wird geleert
And I set field "bukenn" to ""
Then field "fakt" has value "nein"
And I set field "mge" to "90" in row 1
And I save the current editor
# #######################################################################################
