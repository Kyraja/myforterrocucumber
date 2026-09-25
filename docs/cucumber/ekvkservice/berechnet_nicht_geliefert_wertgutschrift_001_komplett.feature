# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert_wertgutschrift_001_komplett.feature
#  Datum     : 10.01.2025
#  Autor     : wane
#  Verantwortlich : wane
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - 100%-Wertgutschrift
#
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert"; 100%-Wertgutschrift
Background:
Given I set the fake date to "02.01.2002"

Scenario: Stammdaten



Scenario: Fall_01

#
# 1BE001 ------ 1RE001 ----------1WGS001
# 100St.x1EUR   100St. x1,5EUR   100St. x1,5EUR
#    \
#     \---------------- 1LS001
#      \                40 St.
#       \
#        \------------------------------- 1LS002
#         \                               60 St.    hat gar nicht gebucht: kein Fehler; Es gibt keine Werte zu der V-Kette.
#          \
#           \------------------------------------ 1RE002
#            \                                    100 St. x 0.00EUR
#
#-- 1 --------- 2 ----- 3 ------ 4 ------ 5 ----- 6 ------> Zeitstrahl


# 1: Bestellung 1BE001
Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE001 |
   | lief    | 001fa1 |
And I append rows
   | artikel   | mge | he    | preis |
   | EK1-FALL1 | 100 | Stück | 1,00  |
And I save the current editor


# 2: Rechnung 1RE001
Given I open an editor "1RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE001"
And I set fields
   | nummer | 1RE001  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
And I set field "preis" to "1,50" in row 1
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall1" in row 1
Then field "vorgangskonto" has value "1ifall1" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall1" in row 1
Then field "kvnum" has value "1BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 1LS001
Given I open an editor "1LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE001"
And I set fields
   | nummer | 1LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "40" in row 1
And I save the current editor


# 4: Komplettgutschrift 1WGS001
Given I open an editor "1WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE001"
And I set fields
   | nummer | 1WGS001 |
   | such   | WGS01F1 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-100" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "ja" in row 1
Then field "kvnum" has value "1BE001" in row 1
And I save the current editor


# 5: Lieferschein 1LS002
Given I open an editor "1LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE001"
And I set fields
   | nummer | 1LS002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "60" in row 1
And I save the current editor


# 6: Null-Rechnung 1RE002
Given I open an editor "1RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE001"
And I set fields
   | nummer | 1RE002  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
And I set field "preis" to "0,00" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall1" in row 1
Then field "vorgangskonto" has value "1ifall1" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
#And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################

Scenario: Fall_02

#
#      /- 2RE001 --------------- 2WGS001
#     /   50St. x1,5EUR          50St. x1,5EUR   bucht alles von Bestandskonto ab
#    /
#  2BE001 ------- 2RE002 ----------------- 2WGS002
#  100St. x 1EUR  50St. x 2EUR             50St. x 2EUR  bucht 10St von B-konto und 40St vom ZW.-Konto ab
#    \
#     \------------------ 2LS001
#      \                  60 St.
#       \
#        \------------------------------------------- 2LS002
#         \                                           40 St.   hat gar nicht gebucht: kein Fehler; es gibt keine Werte zu der V-Kette.
#          \
#           \----------------------------------------------- 2RE003
#            \                                               100 St. x 0,00EUR
#
#- 1 ----- 2 ---- 3 ----- 4 ----- 5 ------ 6 -------- 7 ---- 8 -------> Zeitstrahl

# 1: Bestellung
Given I open an editor "2BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 2BE001 |
   | lief    | 001fa2 |
And I append rows
   | artikel   | mge | he    | preis |
   | EK1-FALL2 | 100 | Stück | 1,00  |
And I save the current editor


# 2: Rechnung 2RE001
Given I open an editor "2RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "2BE001"
And I set fields
   | nummer | 2RE001  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "50" in row 1
And I set field "preis" to "1,50" in row 1
Then field "ngeliefertremge" has value "50" in row 1
Then field "konto" has value "36fall2" in row 1
Then field "vorgangskonto" has value "1ifall2" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "50" in row 1
Then field "zwischenkonto" has value "36fall2" in row 1
Then field "kvnum" has value "2BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Rechnung 2RE002
Given I open an editor "2RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "2BE001"
And I set fields
   | nummer | 2RE002  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "50" in row 1
And I set field "preis" to "2,00" in row 1
Then field "ngeliefertremge" has value "50" in row 1
Then field "konto" has value "36fall2" in row 1
Then field "vorgangskonto" has value "1ifall2" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "50" in row 1
Then field "zwischenkonto" has value "36fall2" in row 1
Then field "kvnum" has value "2BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Lieferschein 2LS001
Given I open an editor "2LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "2BE001"
And I set fields
   | nummer | 2LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "60" in row 1
And I save the current editor


# 5: Komplettgutschrift 2WGS001
Given I open an editor "2WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE001"
And I set fields
   | nummer | 2WGS001 |
   | such   | WGS01F2 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-50" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "ja" in row 1
And I save the current editor


# 6: Komplettgutschrift 2WGS002
Given I open an editor "2WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE002"
And I set fields
   | nummer | 2WGS002 |
   | such   | WGS02F2 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-50" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "ja" in row 1
Then field "kvnum" has value "2BE001" in row 1
And I save the current editor


# 7: Lieferschein 2LS002
Given I open an editor "2LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "2BE001"
And I set fields
   | nummer | 2LS002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "40" in row 1
And I save the current editor


# 8: Null-Rechnung 2RE003
Given I open an editor "2RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "2BE001"
And I set fields
   | nummer | 2RE003  |
   | ueb    | ja      |
   | vom    | .       |
Then field "mge" has value "100" in row 1
And I set field "preis" to "0,00" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall2" in row 1
Then field "vorgangskonto" has value "1ifall2" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
#And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################

Scenario: Fall_03; keine Ueberberechnung

#
#      /- 3RE001 ----------- 3WGS001
#     /   40St. x1,5EUR      40St. x 1,5EUR  bucht Korrekt - keine Ueberberechnung!
#    /
#  3LS001 ------- 3RE002
#  100St.         60St. x2EUR  bucht Korrekt!
#
#- 1 ----- 2 ---- 3 -------- 4 -------> Zeitstrahl

# 1: Lieferschein 3LS001
Given I open an editor "3LS001" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 3LS001 |
   | lief    | 001fa3 |
   | ueb     | ja     |
   | vom     | .      |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL3 | 100 | Stück |
And I save the current editor


# 2: Rechnung 3RE001
Given I open an editor "3RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "3LS001"
And I set fields
   | nummer | 3RE001  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "50" in row 1
And I set field "preis" to "1,50" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall3" in row 1
Then field "vorgangskonto" has value "1ifall3" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "50" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Rechnung 3RE002
Given I open an editor "3RE002" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "3LS001"
And I set fields
   | nummer | 3RE002  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "50" in row 1
And I set field "preis" to "2,00" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall3" in row 1
Then field "vorgangskonto" has value "1ifall3" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "50" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Komplettgutschrift 3WGS001
Given I open an editor "3WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "3RE001"
And I set fields
   | nummer | 3WGS001 |
   | such   | WGS02F3 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-50" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "ja" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_04

#
#                /-------------------------------------- 4RE003
#               /                                        20St. x0,00EUR
#              /
#      /- 4LS001 -------- 4RE001 ------- 4WGS001
#     /   20St.           20St. x1,5EUR  20St. x1,5EUR   korrekt: alles vom Bestandskonto
#    /
#  4BE001 ------ 4RE002 ------------------------- 4WGS002
#  100St. x1EUR  60St. x2EUR                      60St. x2EUR korrekt: alles vom Bestandskonto
#    \
#     \--------------------------- 4LS002
#      \                           60St.
#       \
#        \----------------------------------------------------- 4RE004
#         \                                                     60St. x0,00 EUR
#          \                                                    20St. x0,00 EUR (Beleg anfuegen: 4BE001)  bucht nicht - keine Werte
#           \
#            \----------------------------------------------------------- 4LS003
#             \                                                           20St.    -> korrekt: bucht nicht!!! keine Werte sind da!
#
#- 1 ---- 2 ---- 3 ------ 4 ------ 5 --- 6 ------ 7 ---- 8 ---- 9 ------- 10 ----> Zeitstrahl

# 1: Bestellung
Given I open an editor "4BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 4BE001 |
   | lief    | 001fa4 |
And I append rows
   | artikel   | mge | he    | preis |
   | EK1-FALL4 | 100 | Stück | 1,00  |
And I save the current editor


# 2: Lieferschein 4LS001
Given I open an editor "4LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "4BE001"
And I set fields
   | nummer | 4LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "20" in row 1
And I save the current editor


# 3: Rechnung 4RE002
Given I open an editor "4RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "4BE001"
And I set fields
   | nummer | 4RE002  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "60" in row 1
And I set field "preis" to "2,00" in row 1
Then field "ngeliefertremge" has value "60" in row 1
Then field "konto" has value "36fall4" in row 1
Then field "vorgangskonto" has value "1ifall4" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "60" in row 1
Then field "zwischenkonto" has value "36fall4" in row 1
Then field "kvnum" has value "4BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Rechnung 4RE001
Given I open an editor "4RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "4LS001"
And I set fields
   | nummer | 4RE001  |
   | ueb    | ja      |
   | vom    | .       |
Then field "mge" has value "20" in row 1
And I set field "preis" to "1,50" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall4" in row 1
Then field "vorgangskonto" has value "1ifall4" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Lieferschein 4LS002
Given I open an editor "4LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "4BE001"
And I set fields
   | nummer | 4LS002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "60" in row 1
And I save the current editor


# 6: Komplettgutschrift 4WGS001
Given I open an editor "4WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "4RE001"
And I set fields
   | nummer | 4WGS001 |
   | such   | WGS01F4 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-20" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "ja" in row 1
And I save the current editor


# 7: Komplettgutschrift 4WGS002
Given I open an editor "4WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "4RE002"
And I set fields
   | nummer | 4WGS002 |
   | such   | WGS02F4 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-60" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "ja" in row 1
And I save the current editor


# 8: Null-Rechnung 4RE003
Given I open an editor "4RE003" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "4LS001"
And I set fields
   | nummer | 4RE003  |
   | ueb    | ja      |
   | vom    | .       |
Then field "mge" has value "20" in row 1
Then field "ofmge" has value "0" in row 1
And I set field "preis" to "0,00" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall4" in row 1
Then field "vorgangskonto" has value "1ifall4" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
#And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 9: Rechnung 4RE004
Given I open an editor "4RE004" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "4BE001"
And I set fields
   | nummer | 4RE004  |
   | ueb    | ja      |
   | vom    | .       |
Then field "mge" has value "60" in row 1
Then field "ofmge" has value "20" in row 1
And I set field "preis" to "0,00" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall4" in row 1
Then field "vorgangskonto" has value "1ifall4" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
# Beleg anfuegen
And I set field "beleg" to "nummer" from editor "4BE001"
And I press button "offueb" in row 2
Then field "mge" has value "20" in row 2
And I set field "preis" to "0,00" in row 2
Then field "ngeliefertremge" has value "0" in row 2
Then field "konto" has value "1ifall4" in row 2
Then field "vorgangskonto" has value "1ifall4" in row 2
Then field "fixvorgangskonto" has value "nein" in row 2
Then field "zwischenkonto" has value "" in row 2
Then field "kvnum" has value "" in row 2
# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 2: Lieferschein 4LS003
Given I open an editor "4LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "4BE001"
And I set fields
   | nummer | 4LS003 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "20" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_05

#
#  5BE001 ------ 5RE001 ---------- 5WGS001 --------- 5SWGS001
#  100St. x1EUR  100St. x1,5EUR    100St. x1,5EUR    100St. x 1,5EUR
#    \
#     \----------------- 5LS001
#      \                 40 St.
#       \
#        \-------------------------------- 5LS002
#         \                                60 St.
#
#-- 1 ---------- 2 ----- 3 ------- 4 ------ 5 ------ 6 ------> Zeitstrahl


# 1: Bestellung 1501
Given I open an editor "5BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 5BE001 |
   | lief    | 001fa5 |
And I append rows
   | artikel   | mge | preis |
   | EK1-FALL5 | 100 | 1,00  |
And I save the current editor


# 2: Rechnung 5RE001
Given I open an editor "5RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "5BE001"
And I set fields
   | nummer | 5RE001  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
And I set field "preis" to "1,50" in row 1
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall5" in row 1
Then field "vorgangskonto" has value "1ifall5" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall5" in row 1
Then field "kvnum" has value "5BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 5LS001
Given I open an editor "5LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "5BE001"
And I set fields
   | nummer | 5LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "40" in row 1
And I save the current editor


# 4: Komplettgutschrift 5WGS001
Given I open an editor "5WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "5RE001"
And I set fields
   | nummer | 5WGS001 |
   | such   | WGS01F5 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-100" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "ja" in row 1
Then field "kvnum" has value "5BE001" in row 1
And I save the current editor


# 5: Lieferschein 5LS002
Given I open an editor "5LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "5BE001"
And I set fields
   | nummer | 5LS002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "60" in row 1
And I save the current editor


# 6: Komplettgutschrift 5WGS001 stornieren
Given I open an editor "wgs-storno-5SWGS001" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+5WGS001"
And I set field "num4" to "5SWGS001"
And I set field "bem" to "STORNO von WGS 5WGS001"
Then field "kvnum" has value "5BE001" in row 1
And I save the current editor

# #######################################################################################

Scenario: Fall_06
# Lieferschein nach Wertgutschrift

#
#  6BE001 ----- 6RE001 --------6WGS001
#  10St. x1EUR  10St. x1,5EUR  10St. x 1,5EUR
#    \
#     \------------------------------------ 6LS001
#                                           5 St.
#
#-- 1 --------- 2 ------------ 3 ---------- 4 ----> Zeitstrahl



# 1: Bestellung 6BE001
Given I open an editor "6BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 6BE001 |
   | lief    | 001fa6 |
And I append rows
   | artikel   | mge | he    | preis |
   | EK1-FALL6 | 10  | Stück | 1,00  |
And I save the current editor


# 2: Rechnung 6RE001
Given I open an editor "6RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "6BE001"
And I set fields
   | nummer | 6RE001  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I set field "preis" to "1,50" in row 1
Then field "ngeliefertremge" has value "10" in row 1
Then field "konto" has value "36fall6" in row 1
Then field "vorgangskonto" has value "1ifall6" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "10" in row 1
Then field "zwischenkonto" has value "36fall6" in row 1
Then field "kvnum" has value "6BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Komplettgutschrift 6WGS001
Given I open an editor "6WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "6RE001"
And I set fields
   | nummer | 6WGS001 |
   | such   | WGS01F6 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "ja" in row 1
Then field "kvnum" has value "6BE001" in row 1
And I save the current editor

# 3: Lieferschein 6LS001
Given I open an editor "6LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "6BE001"
And I set fields
   | nummer | 6LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "5" in row 1
And I save the current editor

# #######################################################################################











# Hinweis: nur bis Fall 25

