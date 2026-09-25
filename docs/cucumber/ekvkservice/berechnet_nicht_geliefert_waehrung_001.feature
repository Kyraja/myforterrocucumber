# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert_waehrung_001.feature
#  Datum     : 15.02.2025
#  Autor     : wane
#  Verantwortlich : wane
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - Waehrung
#
#              Hinweis: Buchungswaehrung ist immer EUR
#
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert"; Waehrung
Background:
Given I set the fake date to "02.01.2002"

Scenario: Stammdaten


Scenario: Fall_01

#
#     /--- 01RE001
#    /     4St.(x10.00USD)
#   /
#  01BE001 ---------- 01RE002
#  10St.(x10USD)      6St.(x2000000.00TRL)
#   \
#    \------------------------- 01LS001
#     \                         10 St.
#
#-- 1 ---- 2 -------- 3 ------- 4 ------> Zeitstrahl


# 1: Bestellung
Given I open an editor "01BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer   | 01BE001|
   | lief     | 001fa1 |
   | erfwaehr | USD    |
And I append rows
   | artikel   | mge | he    | preis |
   | EK1-FALL1 | 10 | St체ck | 10,00 |
And I save the current editor


# 2: Rechnung 01RE001
Given I open an editor "01RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "01BE001"
And I set fields
   | nummer   | 01RE001 |
   | ueb      | ja      |
   | vom      | .       |
   | erfwaehr | USD     |
And I set field "mge" to "4" in row 1
And I set field "preis" to "10" in row 1
Then field "ngeliefertremge" has value "4" in row 1
Then field "konto" has value "36fall1" in row 1
Then field "vorgangskonto" has value "1ifall1" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "4" in row 1
Then field "zwischenkonto" has value "36fall1" in row 1
Then field "kvnum" has value "01BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Rechnung 01RE002
Given I open an editor "01RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "01BE001"
And I set fields
   | nummer   | 01RE002 |
   | ueb      | ja      |
   | vom      | .       |
   | erfwaehr | TRL     |
And I set field "mge" to "6" in row 1
And I set field "preis" to "2000000.00" in row 1
Then field "ngeliefertremge" has value "6" in row 1
Then field "konto" has value "36fall1" in row 1
Then field "vorgangskonto" has value "1ifall1" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "6" in row 1
Then field "zwischenkonto" has value "36fall1" in row 1
Then field "kvnum" has value "01BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 4: Lieferschein 01LS001
Given I open an editor "01LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "01BE001"
And I set fields
   | nummer | 01LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_02

#
#     /- 02RE001 ---------------- 02WGS001
#    /   4St.(x12USD)             2St.(x4USD)
#   /
#  02BE001 --------------- 02RE002
#  10St.(x10USD)           6St.(x8,93EUR)
#   \
#    \----------- 02LS001 -------------------- 02RLS01 --- 02KGS01
#     \           6 St.                        6St.        6St.
#      \
#       \------------------------------- 02LS002
#        \                               4St.
#
#-- 1 -- 2 ------ 3 ------ 4 ---- 5 ---- 6 --- 7 --------- 8 ---> Zeitstrahl


# 1: Bestellung
Given I open an editor "02BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer   | 02BE001 |
   | lief     | 001fa2  |
   | erfwaehr | USD     |
And I append rows
   | artikel   | mge | he    | preis |
   | EK1-FALL2 | 10 | St체ck | 10,00 |
And I save the current editor


# 2: Rechnung 02RE001
Given I open an editor "02RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "02BE001"
And I set fields
   | nummer   | 02RE001 |
   | ueb      | ja      |
   | vom      | .       |
   | erfwaehr | USD     |
And I set field "mge" to "4" in row 1
And I set field "preis" to "12" in row 1
Then field "ngeliefertremge" has value "4" in row 1
Then field "konto" has value "36fall2" in row 1
Then field "vorgangskonto" has value "1ifall2" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "4" in row 1
Then field "zwischenkonto" has value "36fall2" in row 1
Then field "kvnum" has value "02BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 02LS001
Given I open an editor "02LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "02BE001"
And I set fields
   | nummer | 02LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "6" in row 1
And I save the current editor


# 4: Rechnung 02RE002
Given I open an editor "02RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "02BE001"
And I set fields
   | nummer   | 01RE002 |
   | ueb      | ja      |
   | vom      | .       |
   | erfwaehr | EUR     |
And I set field "mge" to "6" in row 1
And I set field "preis" to "8,93" in row 1
Then field "ngeliefertremge" has value "4" in row 1
Then field "konto" has value "36fall2" in row 1
Then field "vorgangskonto" has value "1ifall2" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "6" in row 1
Then field "zwischenkonto" has value "36fall2" in row 1
Then field "kvnum" has value "02BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Teilwertgutschrift 02WGS001
Given I open an editor "02WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "02RE001"
And I set fields
   | nummer | 02WGS001 |
   | such   | WGS01F02 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-2" in row 1
And I set field "preis" to "4.00" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "02BE001" in row 1
And I save the current editor


# 6: Lieferschein 02LS002
Given I open an editor "02LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "02BE001"
And I set fields
   | nummer | 02LS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "4" in row 1
And I save the current editor


# 7: Ruecklieferschein 2RLS001
Given I open an editor "rueck-2RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+02LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "R체cklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 2RLS001          |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-6" in row 1
And I save the current editor
And I close the current editor


# 8: Kaufmaennische Gutschrift 02KGS01
Given I open an editor "02KGS01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-2RLS001"
And I set fields
   | nummer | 02KGS01  |
   | such   | KGS01F02 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
Then field "erfwaehr" has value "USD"
Then field "mge" has value "-4" in row 1
Then field "konto" has value "36fall2" in row 1
Then field "pwert" has value "-40.00" in row 1
Then field "mge" has value "-2" in row 2
Then field "konto" has value "36fall2" in row 2
Then field "pwert" has value "-15.90" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################

Scenario: Fall_03

#
#     /- 03RE001 -------- 03WGS001
#    /   8St.(x15USD)     2St.(x4USD)
#   /
#  03BE001 -------------------- 03LS002
#  10St.(x10EUR)                6St.
#   \
#    \----------- 03LS001 ---------- 03RLS01 ----- 03SRLS01 (Versuch)
#     \           4 St.              4St.          4St.
#      \                                \
#       \                                \--------------- 03KGS001
#        \                                \               4St.
#         \
#          \-------------------------------- 03RE002
#           \                                2St.(x200000TRL)
#
#-- 1 -- 2 ------ 3 ------ 4 -- 5 -- 6 ----- 7 --- 8 ---- 9 -----> Zeitstrahl


# 1: Bestellung
Given I open an editor "03BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer   | 03BE001 |
   | lief     | 001fa3  |
   | erfwaehr | EUR     |
And I append rows
   | artikel   | mge | he    | preis |
   | EK1-FALL3 | 10 | St체ck | 10,00 |
And I save the current editor


# 2: Rechnung 03RE001
Given I open an editor "03RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "03BE001"
And I set fields
   | nummer   | 03RE001 |
   | ueb      | ja      |
   | vom      | .       |
   | erfwaehr | USD     |
And I set field "mge" to "8" in row 1
And I set field "preis" to "15" in row 1
Then field "ngeliefertremge" has value "8" in row 1
Then field "konto" has value "36fall3" in row 1
Then field "vorgangskonto" has value "1ifall3" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "8" in row 1
Then field "zwischenkonto" has value "36fall3" in row 1
Then field "kvnum" has value "03BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 03LS001
Given I open an editor "03LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "03BE001"
And I set fields
   | nummer | 03LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "4" in row 1
And I save the current editor


# 4: Teilwertgutschrift 03WGS001
Given I open an editor "03WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "03RE001"
And I set fields
   | nummer   | 03WGS001 |
   | such     | WGS01F03 |
   | ueb      | ja       |
   | vom      | .        |
And I set field "mge" to "-2" in row 1
And I set field "preis" to "4.00" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "03BE001" in row 1
And I save the current editor


# 5: Lieferschein 03LS002
Given I open an editor "03LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "03BE001"
And I set fields
   | nummer | 03LS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "6" in row 1
And I save the current editor


# 6: Ruecklieferschein 03RLS001
Given I open an editor "rueck-03RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+03LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "R체cklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 03RLS001         |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-4" in row 1
And I save the current editor
And I close the current editor


# 7: Rechnung 03RE002
Given I open an editor "03RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "03BE001"
And I set fields
   | nummer   | 03RE002 |
   | ueb      | ja      |
   | vom      | .       |
   | erfwaehr | TRL     |
And I set field "mge" to "2" in row 1
# And I set field "preis" to "200000" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall3" in row 1
Then field "vorgangskonto" has value "1ifall3" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "2" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 8: Versuch RLS 03RLS001 zu stornieren
Then opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "03RLS001" throws the exception "1582"


# 9: Kaufmaennische Gutschrift 03KGS001
Given I open an editor "03KGS001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-03RLS001"
And I set fields
   | nummer | 03KGS001 |
   | such   | KGS001F3 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
And I set field "mge" to "-4" in row 1
Then field "pwert" has value "-62.92" in row 1
# Fehler: kvnum muss gefuellt sein!!!
Then field "kvnum" has value "03BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################

Scenario: Fall_04

#
#     /- 04RE001 (mit LB) ---- 04RLS01 --- 04SRLS01
#    /   20St.(x2000000TRL)    10St.       10St.
#   /
#  04BE001 ------------ 04RE003
#  100St.(x10EUR)       35St.(x20CAD)
#   \
#    \-------- 04RE002 ------------- 04WGS001
#     \        15St.(x15USD)         2St.(x4USD)
#      \
#       \-------------------------------------- 04RE004
#        \                                      30St.(x11CHF)
#         \
#          \------------------------------------------ 04LS01
#           \                                          80St.
#
#-- 1 -- 2 --- 3 ------ 4 ---- 5 --- 6 --- 7 -- 8 ---- 9 ----> Zeitstrahl


# 1: Bestellung
Given I open an editor "04BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer   | 04BE001 |
   | lief     | 001fa4  |
   | erfwaehr | EUR     |
And I append rows
   | artikel   | mge | he    | preis |
   | EK1-FALL4 | 100 | St체ck | 10,00 |
And I save the current editor


# 2: Rechnung 04RE001
Given I open an editor "04RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "04BE001"
And I set fields
   | nummer   | 04RE001 |
   | ueb      | ja      |
   | vom      | .       |
   | fakt     | ja      |
   | erfwaehr | TRL     |
And I set field "mge" to "20" in row 1
And I set field "preis" to "2000000" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall4" in row 1
Then field "vorgangskonto" has value "1ifall4" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Rechnung 04RE002
Given I open an editor "04RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "04BE001"
And I set fields
   | nummer   | 04RE002 |
   | ueb      | ja      |
   | vom      | .       |
   | fakt     | nein    |
   | erfwaehr | USD     |
And I set field "mge" to "15" in row 1
And I set field "preis" to "15" in row 1
Then field "ngeliefertremge" has value "15" in row 1
Then field "konto" has value "36fall4" in row 1
Then field "vorgangskonto" has value "1ifall4" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "15" in row 1
Then field "zwischenkonto" has value "36fall4" in row 1
Then field "kvnum" has value "04BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Rechnung 04RE003
Given I open an editor "04RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "04BE001"
And I set fields
   | nummer   | 04RE003 |
   | ueb      | ja      |
   | vom      | .       |
   | erfwaehr | CAD     |
And I set field "mge" to "35" in row 1
And I set field "preis" to "20" in row 1
Then field "ngeliefertremge" has value "35" in row 1
Then field "konto" has value "36fall4" in row 1
Then field "vorgangskonto" has value "1ifall4" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "35" in row 1
Then field "zwischenkonto" has value "36fall4" in row 1
Then field "kvnum" has value "04BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Ruecklieferschein 04RLS01
Given I open an editor "rueck-04RLS01" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+04RE001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "R체cklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 04RLS01          |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-10" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor
And I close the current editor


# # 6: Teilwertgutschrift 04WGS001
# Given I open an editor "04WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "04RE002"
# And I set fields
#    | nummer   | 04WGS001 |
#    | such     | WGS01F04 |
#    | ueb      | ja       |
#    | vom      | .        |
# And I set field "mge" to "-2" in row 1
# And I set field "preis" to "4.00" in row 1
# Then field "wertgutschrift" has value "ja"
# Then field "komplettgutschrift" has value "nein" in row 1
# Then field "kvnum" has value "04BE001" in row 1
# And I save the current editor


# 7: Rechnung 04RE007
Given I open an editor "04RE007" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "04BE001"
And I set fields
   | nummer   | 04RE007 |
   | ueb      | ja      |
   | vom      | .       |
   | erfwaehr | CHF     |
And I set field "mge" to "30" in row 1
And I set field "preis" to "11" in row 1
Then field "ngeliefertremge" has value "30" in row 1
Then field "konto" has value "36fall4" in row 1
Then field "vorgangskonto" has value "1ifall4" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "zwischenkonto" has value "36fall4" in row 1
Then field "kvnum" has value "04BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 8: Ruecklieferschein stornieren
Given I open an editor "rls-storno-04SRLS01" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "04RLS01"
And I set field "num4" to "04SRLS01"
And I set field "bem" to "STORNO von RLS 04RLS001"
And I save the current editor


# 9: Lieferschein 04LS001
Given I open an editor "04LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "04BE001"
And I set fields
   | nummer | 04LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "80" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_05

#
#     /- 05RE001 (mit LB) -- 05WGS01
#    /   20St.(x20CAD)       10St.(x4CAD)
#   /
# 05BE001 ------------ 05RE003
# 100St.(x10EUR)       35St.(x2000000TRL)
#   \
#    \-------- 05RE002 ---------- 05WGS002
#     \        15St.(x15USD)      2St.(x4USD)
#      \
#       \----------------------------- 05RE004
#        \                             30St.(x11CHF)
#         \
#          \------------------------------- 05LS01 -- 05RLS01 --- 05SRLS01
#           \                               80St.     60St.       60St.
#
#- 1 --- 2 --- 3 ----- 4 --- 5 -- 6 -- 7 -- 8 ------- 9 --------- 10 ----> Zeitstrahl


# 1: Bestellung
Given I open an editor "05BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer   | 05BE001 |
   | lief     | 001fa5  |
   | erfwaehr | EUR     |
And I append rows
   | artikel   | mge | he    | preis |
   | EK1-FALL5 | 100 | St체ck | 10,00 |
And I save the current editor


# 2: Rechnung 05RE001
Given I open an editor "05RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "05BE001"
And I set fields
   | nummer   | 05RE001 |
   | ueb      | ja      |
   | vom      | .       |
   | fakt     | ja      |
   | erfwaehr | CAD     |
And I set field "mge" to "20" in row 1
And I set field "preis" to "20" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall5" in row 1
Then field "vorgangskonto" has value "1ifall5" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Rechnung 05RE002
Given I open an editor "05RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "05BE001"
And I set fields
   | nummer   | 05RE002 |
   | ueb      | ja      |
   | vom      | .       |
   | fakt     | nein    |
   | erfwaehr | USD     |
And I set field "mge" to "15" in row 1
And I set field "preis" to "15" in row 1
Then field "ngeliefertremge" has value "15" in row 1
Then field "konto" has value "36fall5" in row 1
Then field "vorgangskonto" has value "1ifall5" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "15" in row 1
Then field "zwischenkonto" has value "36fall5" in row 1
Then field "kvnum" has value "05BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Rechnung 05RE003
Given I open an editor "05RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "05BE001"
And I set fields
   | nummer   | 05RE003 |
   | ueb      | ja      |
   | vom      | .       |
   | erfwaehr | TRL     |
And I set field "mge" to "35" in row 1
And I set field "preis" to "2000000" in row 1
Then field "ngeliefertremge" has value "35" in row 1
Then field "konto" has value "36fall5" in row 1
Then field "vorgangskonto" has value "1ifall5" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "35" in row 1
Then field "zwischenkonto" has value "36fall5" in row 1
Then field "kvnum" has value "05BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Teilwertgutschrift 05WGS01
Given I open an editor "05WGS01" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "05RE001"
And I set fields
   | nummer   | 05WGS01  |
   | such     | WGS01F05 |
   | ueb      | ja       |
   | vom      | .        |
And I set field "mge" to "-10" in row 1
And I set field "preis" to "4.00" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "05BE001" in row 1
And I save the current editor


# 6: Teilwertgutschrift 05WGS02
Given I open an editor "05WGS02" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "05RE001"
And I set fields
   | nummer   | 05WGS02  |
   | such     | WGS02F05 |
   | ueb      | ja       |
   | vom      | .        |
And I set field "mge" to "-2" in row 1
And I set field "preis" to "4.00" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "05BE001" in row 1
And I save the current editor


# 7: Rechnung 05RE004
Given I open an editor "05RE004" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "05BE001"
And I set fields
   | nummer   | 05RE004 |
   | ueb      | ja      |
   | vom      | .       |
   | erfwaehr | CHF     |
And I set field "mge" to "30" in row 1
And I set field "preis" to "11" in row 1
Then field "ngeliefertremge" has value "30" in row 1
Then field "konto" has value "36fall5" in row 1
Then field "vorgangskonto" has value "1ifall5" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "30" in row 1
Then field "zwischenkonto" has value "36fall5" in row 1
Then field "kvnum" has value "05BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 8: Lieferschein 05LS01
Given I open an editor "05LS01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "05BE001"
And I set fields
   | nummer | 05LS01  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "80" in row 1
And I save the current editor


# 9: Ruecklieferschein 05RLS01
Given I open an editor "rueck-005RLS01" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+05LS01"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "R체cklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 05RLS01          |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-70" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor
And I close the current editor


# 10: Ruecklieferschein stornieren
Given I open an editor "rls-storno-05SRLS01" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "05RLS01"
And I set field "num4" to "05SRLS01"
And I set field "bem" to "STORNO von RLS 05RLS01"
And I save the current editor
########################################################################################

Scenario: Fall_06

#
#     /- 06RE001
#    /   100St.(x1.00USD)(Kurs 0,902857)
#   /
# 06BE001 -------------- 06LS01
# 100St.(x1.00USD)       100St.(Kurs 0.892857)
#                           \
#                            \--- 06RLS01 ---------------- 06KGS01
#                             \   40St.(Kurs = 0.892857)   40 St.     --> KGS erzeugt wegen in LS geaenderten Kurs Differenzen
#
#- 1 --- 2 ------------- 3 ------ 4 ---------------------- 5 ----> Zeitstrahl


#  Bestellung 600004 갶er 100 St갷k a 1 USD
#  Rechnung 600004R 100 St 1 USD Kurs 0,902857 = 90,29 EUR
#  Lieferschein 100 St갷k 90,29 EUR Kurs 0.892857
#  R갷klieferschein 40 St갷k Kurs = 0.892857 36,11 EUR (hier wird wohl etwas aus Lieferschein genommen?)
#  KGS 갶er 40 St갷k aus RLS Kurs 0,892857 35,71 USD


# 1: Bestellung
Given I open an editor "06BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer   | 06BE001 |
   | lief     | 001fa6  |
   | erfwaehr | USD     |
And I append rows
   | artikel   | mge | he    | preis |
   | EK1-FALL6 | 100 | St체ck | 1,00  |
And I save the current editor


# 2: Rechnung 06RE001
Given I open an editor "06RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "06BE001"
And I set fields
   | nummer   | 06RE001 |
   | ueb      | ja      |
   | vom      | .       |
   | erfwaehr | USD     |
   | ewekurs  | 0,902857|
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall6" in row 1
Then field "vorgangskonto" has value "1ifall6" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall6" in row 1
Then field "kvnum" has value "06BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 06LS01
Given I open an editor "06LS01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "06BE001"
And I set fields
   | nummer | 06LS01  |
   | ueb    | ja      |
   | vom    | .       |
   | ewekurs| 0.892857|
And I set field "mge" to "100" in row 1
And I save the current editor


# 4: Ruecklieferschein 06RLS01
Given I open an editor "rueck-006RLS01" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+06LS01"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "R체cklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 06RLS01          |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
   | ewekurs      | 0.892857         |
And I set field "mge" to "-40" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor
And I close the current editor


# 5: Kaufmaennische Gutschrift 06KGS01
Given I open an editor "06KGS01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-006RLS01"
And I set fields
   | nummer | 06KGS01 |
   | such   | KGS001F6 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
And I set field "mge" to "-40" in row 1
Then field "pwert" has value "-40.00" in row 1
# Fehler: kvnum muss gefuellt sein!!!
Then field "kvnum" has value "06BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################

Scenario: Fall_07 wie Fall_06, nur hier ist der LI ein Auslaender

#
#     /- 07RE001
#    /   100St.(x1.00USD)(Kurs 0,902857)
#   /
# 07BE001 -------------- 07LS01
# 100St.(x1.00USD)       100St.(Kurs 0.892857)
#                           \
#                            \--- 07RLS01 ---------------- 07KGS01
#                             \   40St.(Kurs = 0.892857)   40 St.     - bucht von Zwischenkonto: korrekt!
#
#- 1 --- 2 ------------- 3 ------ 4 ---------------------- 5 ----> Zeitstrahl


#  Bestellung 600004 갶er 100 St갷k a 1 USD
#  Rechnung 600004R 100 St 1 USD Kurs 0,902857 = 90,29 EUR
#  Lieferschein 100 St갷k 90,29 EUR Kurs 0.892857
#  R갷klieferschein 40 St갷k Kurs = 0.892857 36,11 EUR (hier wird wohl etwas aus Lieferschein genommen?)
#  KGS 갶er 40 St갷k aus RLS Kurs 0,892857 35,71 USD


# 1: Bestellung
Given I open an editor "07BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer   | 07BE001 |
   | lief     | 004fa7  |
   | erfwaehr | USD     |
And I append rows
   | artikel   | mge | he    | preis |
   | EK1-FALL7 | 100 | St체ck | 1,00  |
And I save the current editor


# 2: Rechnung 07RE001
Given I open an editor "07RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "07BE001"
And I set fields
   | nummer   | 07RE001 |
   | ueb      | ja      |
   | vom      | .       |
   | erfwaehr | USD     |
   | ewekurs  | 0,902857|
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall7" in row 1
Then field "vorgangskonto" has value "1afall7" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall7" in row 1
Then field "kvnum" has value "07BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 07LS01
Given I open an editor "07LS01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "07BE001"
And I set fields
   | nummer | 07LS01  |
   | ueb    | ja      |
   | vom    | .       |
   | ewekurs| 0.892857|
And I set field "mge" to "100" in row 1
And I save the current editor


# 4: Ruecklieferschein 07RLS01
Given I open an editor "rueck-007RLS01" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+07LS01"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "R체cklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 07RLS01          |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
   | ewekurs      | 0.892857         |
And I set field "mge" to "-40" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor
And I close the current editor


# 5: Kaufmaennische Gutschrift 07KGS01
Given I open an editor "07KGS01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-007RLS01"
And I set fields
   | nummer | 07KGS01 |
   | such   | KGS001F7 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
And I set field "mge" to "-40" in row 1
Then field "pwert" has value "-40.00" in row 1
Then field "konto" has value "36fall7" in row 1
Then field "vorgangskonto" has value "1afall7" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "kvnum" has value "07BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################










