# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert_brutto_netto_001.feature
#  Datum     : 19.02.2025
#  Autor     : wane
#  Verantwortlich : wane
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - Brutto-/Netto-Berechnung
#
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert"; Brutto-/Netto-Berechnung
Background:
Given I set the fake date to "02.01.2002"

Scenario: Stammdaten


Scenario: Fall_01

#
#     /--- 01RE001
#    /     20St.(x21EUR)
#   /
# 01BE001 ------------ 01RE002 ------ 01WGS001
# 100St. x10EUR        80St.(x26EUR)  80St.(x15EUR)  Aufteilung 20/60
#   \                      \
#    \                      \----------------- 01WGS002
#     \                      \                 50St.(x3EUR)    Aufteilung 20/60
#      \
#       \-------- 01LS001
#        \        40 St.
#         \
#          \------------------------------------------- 01LS002
#           \                                           60 St.    bucht korekt: 60*9,125EUR
#                                                                 Preis pro St.: ((80*26) - (80*15 + 50*3)) / 80
#
#-- 1 ----- 2 --- 3 --- 4 ------------ 5 ------ 6 ----- 7 ------> Zeitstrahl


# 1: Bestellung
Given I open an editor "01BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 01BE001 |
   | lief    | 001fa1  |
   | brutto  | ja      |
And I append rows
   | artikel   | mge | he    | preis |
   | EK1-FALL1 | 100 | Stück | 10,00 |
And I save the current editor


# 2: Rechnung 01RE001
Given I open an editor "01RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "01BE001"
And I set fields
   | nummer | 01RE001 |
   | ueb    | ja      |
   | vom    | .       |
Then field "brutto" has value "ja"
#
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
Then field "ngeliefertremge" has value "20" in row 1
Then field "konto" has value "36fall1" in row 1
Then field "vorgangskonto" has value "1ifall1" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "36fall1" in row 1
Then field "kvnum" has value "01BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 01LS001
Given I open an editor "01LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "01BE001"
And I set fields
   | nummer | 01LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "40" in row 1
And I save the current editor


# 4: Rechnung 01RE002
Given I open an editor "01RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "01BE001"
And I set fields
   | nummer | 01RE002 |
   | ueb    | ja      |
   | vom    | .       |
Then field "brutto" has value "ja"
#
And I set field "mge" to "80" in row 1
And I set field "preis" to "26" in row 1
Then field "ngeliefertremge" has value "60" in row 1
Then field "konto" has value "36fall1" in row 1
Then field "vorgangskonto" has value "1ifall1" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "80" in row 1
Then field "zwischenkonto" has value "36fall1" in row 1
Then field "kvnum" has value "01BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Teilwertgutschrift 01WGS001
Given I open an editor "01WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "01RE002"
And I set fields
   | nummer | 01WGS001 |
   | such   | WGS01F01 |
   | ueb    | ja       |
   | vom    | .        |
Then field "brutto" has value "ja"
#
And I set field "mge" to "-80" in row 1
And I set field "preis" to "15" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "01BE001" in row 1
And I save the current editor


# 6: Teilwertgutschrift 01WGS002
Given I open an editor "01WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "01RE002"
And I set fields
   | nummer | 01WGS002 |
   | such   | WGS02F01 |
   | ueb    | ja       |
   | vom    | .        |
Then field "brutto" has value "ja"
#
And I set field "mge" to "-50" in row 1
And I set field "preis" to "3" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "01BE001" in row 1
And I save the current editor


# 7: Lieferschein 01LS002
Given I open an editor "01LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "01BE001"
And I set fields
   | nummer | 01LS002 |
   | ueb    | ja      |
   | vom    | .       |
Then field "brutto" has value "ja"
#
And I set field "mge" to "60" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_02
# 2 Lieferscheine nach 2 Teilwertgutschriften zu einer Rechnung

#  02BE001 ------- 02RE001 ------- 02WGS001
#  10St. x10EUR    10St.(x10EUR)   2St.(x10EUR)    alles von ZW-Konto
#   \                 \
#    \                 \----------------------- 02WGS002
#     \                 \                       3St.(x10EUR)  Aufteilung 5/5
#      \
#       \------------------------------- 02LS002
#        \                               5St.
#         \
#          \------------------------------------------ 02LS002
#           \                                          5St.
#
#-- 1 ------------ 2 ------------- 3 --- 4 ---- 5 ---- 6 ----> Zeitstrahl

# 1: Bestellung
Given I open an editor "02BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 02BE001 |
   | lief    | 001fa2  |
   | brutto  | ja      |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL2  | 10  | Stück | 10,00 |
And I save the current editor


# 2: Rechnung 02RE001
Given I open an editor "02RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "02BE001"
And I set fields
   | nummer | 02RE001 |
   | ueb    | ja      |
   | vom    | .       |
Then field "brutto" has value "ja"
#
And I set field "mge" to "10" in row 1
And I set field "preis" to "10" in row 1
Then field "ngeliefertremge" has value "10" in row 1
Then field "konto" has value "36fall2" in row 1
Then field "vorgangskonto" has value "1ifall2" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "10" in row 1
Then field "zwischenkonto" has value "36fall2" in row 1
Then field "kvnum" has value "02BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Teilwertgutschrift 02WGS001
Given I open an editor "02WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "02RE001"
And I set fields
   | nummer | 02WGS001 |
   | such   | WGS01F01 |
   | ueb    | ja       |
   | vom    | .        |
Then field "brutto" has value "ja"
#
And I set field "mge" to "-2" in row 1
And I set field "preis" to "10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "02BE001" in row 1
And I save the current editor

# 4: Lieferschein 02LS001
Given I open an editor "02LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "02BE001"
And I set fields
   | nummer | 02LS001 |
   | ueb    | ja      |
   | vom    | .       |
Then field "brutto" has value "ja"
#
And I set field "mge" to "5" in row 1
And I save the current editor

# 5: Teilwertgutschrift 02WGS002
Given I open an editor "02WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "02RE001"
And I set fields
   | nummer | 02WGS002 |
   | such   | WGS02F01 |
   | ueb    | ja       |
   | vom    | .        |
Then field "brutto" has value "ja"
#
And I set field "mge" to "-3" in row 1
And I set field "preis" to "10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "02BE001" in row 1
And I save the current editor

# 6: Lieferschein 02LS001
Given I open an editor "02LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "02BE001"
And I set fields
   | nummer | 02LS001 |
   | ueb    | ja      |
   | vom    | .       |
Then field "brutto" has value "ja"
#
And I set field "mge" to "5" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_03
# 2 Lieferscheine mit Ueberlieferung nach 2 Teilwertgutschriften zu einer Rechnung

#  03BE001 -------- 03RE001 ------- 03WGS001
#  10St. x10EUR     10St.(x10EUR)   2St.(x10EUR)     Alles von ZW-Konto
#   \                  \
#    \                  \----------------- 03WGS002
#     \                  \                 3St.(x10EUR)     Alles von ZW-Konto
#      \
#       \-------------------------------------- 03LS002
#        \                                      5St.
#         \
#          \-------------------------------------------- 03LS002
#           \                                            8St. (Ueberlieferung) - nur 5St. werden von ZW-Konto weggebucht. Korrekt!
#
#
#-- 1 ------------- 2 ------------- 3 ---- 4 -- 5 ------ 6 ----> Zeitstrahl

# 1: Bestellung
Given I open an editor "03BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 03BE001 |
   | lief    | 001fa3  |
   | brutto  | ja      |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL3  | 10  | Stück | 10,00 |
And I save the current editor


# 2: Rechnung 03RE001
Given I open an editor "03RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "03BE001"
And I set fields
   | nummer | 03RE001 |
   | ueb    | ja      |
   | vom    | .       |
Then field "brutto" has value "ja"
#
And I set field "mge" to "10" in row 1
And I set field "preis" to "10" in row 1
Then field "ngeliefertremge" has value "10" in row 1
Then field "konto" has value "36fall3" in row 1
Then field "vorgangskonto" has value "1ifall3" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "10" in row 1
Then field "zwischenkonto" has value "36fall3" in row 1
Then field "kvnum" has value "03BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Teilwertgutschrift 03WGS001
Given I open an editor "03WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "03RE001"
And I set fields
   | nummer | 03WGS001 |
   | such   | WGS01F03 |
   | ueb    | ja       |
   | vom    | .        |
Then field "brutto" has value "ja"
#
And I set field "mge" to "-2" in row 1
And I set field "preis" to "10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "03BE001" in row 1
And I save the current editor


# 4: Teilwertgutschrift 03WGS002
Given I open an editor "03WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "03RE001"
And I set fields
   | nummer | 03WGS002 |
   | such   | WGS02F03 |
   | ueb    | ja       |
   | vom    | .        |
Then field "brutto" has value "ja"
#
And I set field "mge" to "-3" in row 1
And I set field "preis" to "10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "03BE001" in row 1
And I save the current editor

# 5: Lieferschein 03LS001
Given I open an editor "03LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "03BE001"
And I set fields
   | nummer | 03LS001 |
   | ueb    | ja      |
   | vom    | .       |
Then field "brutto" has value "ja"
#
And I set field "mge" to "5" in row 1
And I save the current editor

# 6: Lieferschein 03LS002
Given I open an editor "03LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "03BE001"
And I set fields
   | nummer | 03LS002 |
   | ueb    | ja      |
   | vom    | .       |
Then field "brutto" has value "ja"
#
And I set field "mge" to "8" in row 1
And I save the current editor
# #######################################################################################


