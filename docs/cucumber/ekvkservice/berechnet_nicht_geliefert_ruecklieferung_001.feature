# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert_ruecklieferung_001.feature
#  Datum     : 08.12.2024
#  Autor     : wane
#  Verantwortlich : wane
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - Ruecklieferung
#
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert"
Background:
Given I set the fake date to "02.01.2002"

Scenario: Stammdaten



Scenario: Fall_01

#
#  1BE001 -- 1RE001
#  200 St.   200 St.
#    \
#     \------------- 1LS001 ---- 1RLS001 ---- 1SRLS001
#      \             200 St.     50 St.       50 St.
#
#--- 1 ----- 2 ----- 3 --------- 4 ---------- 5 ------> Zeitstrahl


# 1: Bestellung
Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE001 |
   | lief    | 001fa1 |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL1 | 200 | Stück |
And I save the current editor


# 2: Rechnung
Given I open an editor "1RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE001"
And I set fields
   | nummer | 1RE001  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "200" in row 1
Then field "ngeliefertremge" has value "200" in row 1
Then field "konto" has value "36fall1" in row 1
Then field "vorgangskonto" has value "1ifall1" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "200" in row 1
Then field "zwischenkonto" has value "36fall1" in row 1
Then field "kvnum" has value "1BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein
Given I open an editor "1LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE001"
And I set fields
   | nummer | 1LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "200" in row 1
And I save the current editor


# 4: Ruecklieferschein 1RLS001
Given I open an editor "rueck-1RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+1LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 1RLS001          |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-50" in row 1
And I save the current editor
And I close the current editor


# 5: Ruecklieferschein stornieren
Given I open an editor "rls-storno-1SRLS001" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "1RLS001"
And I set field "num4" to "1SRLS001"
And I set field "bem" to "STORNO von RLS 1RLS001"
And I save the current editor
# #######################################################################################

Scenario: Fall_02

#
#  2BE001 ---2RE001 (mit LB) ---- 2RLS001 (rerelev=nein)
#  200 St.   200 St.              50 St.
#    \
#     \------------------------------------- 2LS002 (Ersatzlieferung)
#      \                                     50 St.                   ->  Fehler: bucht nicht!!! Bleibt aber so!
#
#--- 1 ----- 2 ------------------ 3 -------- 4 -------> Zeitstrahl


# 1: Bestellung
Given I open an editor "2BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 2BE001 |
   | lief    | 001fa2 |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL2 | 200 | Stück |
And I save the current editor


# 2: Rechnung mit Lagerbewegung
Given I open an editor "2RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "2BE001"
And I set fields
   | nummer | 2RE001 |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I set field "mge" to "200" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall2" in row 1
Then field "vorgangskonto" has value "1ifall2" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "200" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Ruecklieferschein 2RLS001
Given I open an editor "rueck-2RLS001" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+2RE001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 2RLS001          |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-50" in row 1
# fuer Ersatzlieferung
And I set field "rerelev" to "nein" in row 1
And I save the current editor
And I close the current editor


Given I open an editor "rueck-2RLS001-VIEW" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2RLS001"
Then field "partnervorgang" is empty
# weil Rechnungsrelevant = nein, wird keine Rechnungsbuchung erstellt
Then field "rebu" is empty
And I close the current editor


# 4: Lieferschein: Ersatzlieferung
Given I open an editor "2LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "2BE001"
And I set fields
   | nummer | 2LS002 |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "50" in row 1
And I set field "rerelev" to "nein" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_03

#
#     /- 3RE001 --------------------------- 3SRE001
#    /   120 St.                            120 St.
#   /
#  3BE001----- 3LS001----------- 3RLS001 --------------------- 3KGS001
#  200 St.     150 St.           110 St.                       110 St.
#   \
#    \-------------- 3RE002
#     \              80 St.
#      \
#       \----------------- 3LS002
#        \                 50 St.
#         \
#          \-----------------------------------------3RE003
#           \                                        120 St.
#
#-- 1 -- 2 --- 3 --- 4 --- 5 --- 6 -------- 7 ------ 8 ------- 9 ---> Zeitstrahl


# 1: Bestellung
Given I open an editor "3BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 3BE001 |
   | lief    | 001fa3 |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL3 | 200 | Stück |
And I save the current editor


# 2: Rechnung
Given I open an editor "3RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "3BE001"
And I set fields
   | nummer | 3RE001 |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "120" in row 1
Then field "ngeliefertremge" has value "120" in row 1
Then field "konto" has value "36fall3" in row 1
Then field "vorgangskonto" has value "1ifall3" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "120" in row 1
Then field "zwischenkonto" has value "36fall3" in row 1
Then field "kvnum" has value "3BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 3LS001
Given I open an editor "3LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "3BE001"
And I set fields
   | nummer | 3LS001 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "150" in row 1
And I save the current editor


# 4: Rechnung
Given I open an editor "3RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "3BE001"
And I set fields
   | nummer | 3RE002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "80" in row 1
Then field "ngeliefertremge" has value "50" in row 1
Then field "konto" has value "36fall3" in row 1
Then field "vorgangskonto" has value "1ifall3" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "80" in row 1
Then field "zwischenkonto" has value "36fall3" in row 1
Then field "kvnum" has value "3BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Lieferschein 3LS002
Given I open an editor "3LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "3BE001"
And I set fields
   | nummer | 3LS002 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "50" in row 1
And I save the current editor

# 6: Ruecklieferschein 3RLS001
Given I open an editor "rueck-3RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+3LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 3RLS001          |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-110" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor
And I close the current editor


# 7: Rechnung stornieren
Given I open an editor "3SRE001" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+3RE001"
And I set field "num4" to "3SRE001"
And I set field "bem" to "STORNO von RE 3RE001"
And I save the current editor


# 8: Rechnung
Given I open an editor "3RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "3BE001"
And I set fields
   | nummer | 3RE003 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "120" in row 1
Then field "ngeliefertremge" has value "110" in row 1
Then field "konto" has value "36fall3" in row 1
Then field "vorgangskonto" has value "1ifall3" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "120" in row 1
Then field "zwischenkonto" has value "36fall3" in row 1
Then field "kvnum" has value "3BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 9: Kaufmaennische Gutschrift 3KGS001
Given I open an editor "3KGS001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-3RLS001"
And I set fields
   | nummer | 3KGS001  |
   | such   | KGS3a001 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
And I set field "mge" to "-110" in row 1
Then field "pwert" has value "-330.00" in row 1
Then field "konto" is not modifiable in row 1
Then field "fixkonto" is not modifiable in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################


Scenario: Fall_04

#
#     /- 4RE001 ------------------------------------ 4SRE001 (Versuch)
#    /   120 St.                                     120 St.
#   /
#  4BE001 ---- 4LS001----------- 4RLS001 -- 4KGS001
#  200 St.     150 St.           110 St.    110 St.
#   \
#    \-------------- 4RE002
#     \              80 St.
#      \
#       \----------------- 4LS002
#        \                 50 St.
#
#-- 1 -- 2 --- 3 --- 4 --- 5 --- 6 -------- 7 ------ 8 ---------> Zeitstrahl


# 1: Bestellung
Given I open an editor "4BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 4BE001 |
   | lief    | 001fa4 |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL4 | 200 | Stück |
And I save the current editor


# 2: Rechnung
Given I open an editor "4RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "4BE001"
And I set fields
   | nummer | 4RE001 |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "120" in row 1
Then field "ngeliefertremge" has value "120" in row 1
Then field "konto" has value "36fall4" in row 1
Then field "vorgangskonto" has value "1ifall4" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "120" in row 1
Then field "zwischenkonto" has value "36fall4" in row 1
Then field "kvnum" has value "4BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 4LS001
Given I open an editor "4LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "4BE001"
And I set fields
   | nummer | 4LS001 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "150" in row 1
And I save the current editor


# 4: Rechnung
Given I open an editor "4RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "4BE001"
And I set fields
   | nummer | 4RE002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "80" in row 1
Then field "ngeliefertremge" has value "50" in row 1
Then field "konto" has value "36fall4" in row 1
Then field "vorgangskonto" has value "1ifall4" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "80" in row 1
Then field "zwischenkonto" has value "36fall4" in row 1
Then field "kvnum" has value "4BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Lieferschein 4LS002
Given I open an editor "4LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "4BE001"
And I set fields
   | nummer | 4LS002 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "50" in row 1
And I save the current editor

# 6: Ruecklieferschein 4RLS001
Given I open an editor "rueck-4RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+4LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 4RLS001          |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-110" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor
And I close the current editor


# 7: Kaufmaennische Gutschrift 4KGS001
Given I open an editor "4KGS001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-4RLS001"
And I set fields
   | nummer | 4KGS001  |
   | such   | KGS4a001 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
And I set field "mge" to "-110" in row 1
Then field "pwert" has value "-440.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 8: Rechnung stornieren
# 2006 TX=de   |Diese Rechnung wurde bereits in einer kaufmännischen Gutschrift verrechnet.
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+4RE001" throws the exception "2006"


# 9: Rechnung
Given I open an editor "4RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "4BE001"
And I set fields
   | nummer | 4RE003 |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
Then field "mge" has value "0" in row 1
Then field "konto" has value "1ifall4" in row 1
Then field "vorgangskonto" has value "1ifall4" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "kvnum" has value "" in row 1
#
# die Menge ist 0 -> es wird nicht gespeichert
And I close the current editor
# #######################################################################################

Scenario: Fall_05

#
#     /------- 5LS001 ---------------- 5RLS001 --- 5SRLS001
#    /         200 St.                 110 St.     110 St.
#   /
#  5BE001 ----------- 5RE001
#  200 St. x11EUR     100St. x15EUR
#   \
#    \------------------------- 5RE002
#     \                         100St. x20EUR
#
#--- 1 ------- 2 ---- 3 ------- 4 ---- 5 --------- 6 -----------> Zeitstrahl


# 1: Bestellung 5BE001
Given I open an editor "5BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 5BE001 |
   | lief    | 001fa5 |
And I append rows
   | artikel   | mge | preis | he    |
   | EK1-FALL5 | 200 |    11 | Stück |
And I save the current editor


# 2: Lieferschein 5LS001
Given I open an editor "5LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "5BE001"
Then field "fakt" has value "ja"
And I set fields
   | nummer | 5LS001 |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "200" in row 1
And I save the current editor


# 3: Rechnung
Given I open an editor "5RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "5BE001"
And I set fields
   | nummer | 5RE001 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "100" in row 1
And I set field "preis" to "15" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall5" in row 1
Then field "vorgangskonto" has value "1ifall5" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Rechnung
Given I open an editor "5RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "5BE001"
And I set fields
   | nummer | 5RE002 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "100" in row 1
And I set field "preis" to "20" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall5" in row 1
Then field "vorgangskonto" has value "1ifall5" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Ruecklieferschein 5RLS001
Given I open an editor "rueck-5RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+5LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 5RLS001          |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-110" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor
And I close the current editor


# 6: Ruecklieferschein stornieren
Given I open an editor "rls-storno-5SRLS001" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "5RLS001"
And I set field "num4" to "5SRLS001"
And I set field "bem" to "STORNO von RLS 5RLS001"
And I save the current editor
# #######################################################################################

Scenario: Fall_06

#
#       /---- 6LS001 -- 6RLS001 --------------------- 6SRLS001 (Versuch - mit Fehlermeldung)
#      /      200 St.   90 St.          \             90 St.
#     /                                  \
#    /                                    \------------------- 6KGS001
#   /                                                          90 St.
#  6BE001 --------------------- 6RE001
#  200 St. x13EUR               100St. x15EUR    bucht korrekt aufs Bestandskonto
#   \
#    \--------------------------------------- 6RE002
#     \                                       100St. x 20EUR -> bucht korrekt aufs Bestandskonto 10St + 100St aufs Zwischenkonto
#
#--- 1 ------ 2 ------- 3 ----- 4 ----------- 5 ----- 6 ------ 7 --------> Zeitstrahl


# 1: Bestellung 6BE001
Given I open an editor "6BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 6BE001 |
   | lief    | 001fa6 |
And I append rows
   | artikel   | mge | preis | he    |
   | EK1-FALL6 | 200 |    13 | Stück |
And I save the current editor


# 2: Lieferschein 6LS001
Given I open an editor "6LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "6BE001"
Then field "fakt" has value "ja"
And I set fields
   | nummer | 6LS001 |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "200" in row 1
And I save the current editor


# 3: Ruecklieferschein 6RLS001
Given I open an editor "rueck-6RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+6LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 6RLS001          |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-90" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor
And I close the current editor


# 4: Rechnung
Given I open an editor "6RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "6BE001"
And I set fields
   | nummer | 6RE001 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "100" in row 1
And I set field "preis" to "15" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall6" in row 1
Then field "vorgangskonto" has value "1ifall6" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Rechnung 6RE002
Given I open an editor "6RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "6BE001"
And I set fields
   | nummer | 6RE002 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "100" in row 1
And I set field "preis" to "20" in row 1
Then field "ngeliefertremge" has value "90" in row 1
Then field "konto" has value "36fall6" in row 1
Then field "vorgangskonto" has value "1ifall6" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall6" in row 1
Then field "kvnum" has value "6BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 6: Versuch Ruecklieferschein zu stornieren
# 3335 TX=de   |Stornieren Sie zuerst dieses Objekt.
Then opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "rueck-6RLS001" throws the exception "3335"


# 7: Kaufmaennische Gutschrift 6KGS001
Given I open an editor "6KGS001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-6RLS001"
And I set fields
   | nummer | 6KGS001  |
   | such   | KGS6a001 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
And I set field "mge" to "-90" in row 1
Then field "pwert" has value "-1800.00" in row 1
# Fehler: kvnum muss gefuellt sein!!!
Then field "kvnum" has value "6BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################

Scenario: Fall_07

#
#      /----- 7RE002
#     /       200 St. x10EUR
#    /
#  7LS001 -------------- 7RLS001 ----- 7SRLS001
#  200 St. x7EUR         110St.        110St.
#
#--- 1 ------ 2 -------- 3 ----------- 4 --------> Zeitstrahl


# 1: Lieferschein 7LS001
Given I open an editor "7LS001" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 7LS001 |
   | lief    | 001fa7 |
   | ueb     | ja     |
   | vom     | .      |
Then field "fakt" has value "ja"
And I append rows
   | artikel   | mge | preis | he    |
   | EK1-FALL7 | 200 |     7 | Stück |
And I save the current editor


# 2: Rechnung
Given I open an editor "7RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "7LS001"
And I set fields
   | nummer | 7RE001 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "200" in row 1
And I set field "preis" to "10" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall7" in row 1
Then field "vorgangskonto" has value "1ifall7" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "200" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Ruecklieferschein 7RLS001
Given I open an editor "rueck-7RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+7LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 7RLS001          |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-110" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor
And I close the current editor


# 4: Ruecklieferschein stornieren
Given I open an editor "rls-storno-7SRLS001" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "7RLS001"
And I set field "num4" to "7SRLS001"
And I set field "bem" to "STORNO von RLS 7RLS001"
And I save the current editor
# #######################################################################################

Scenario: Fall_08

#
#           /---- 8RE003
#          /      17 St. x7 EUR
#         /
#        /-- 8RE002
#       /    21 St. x6 EUR
#      /
#     /-8RE001
#    /  49 St. x5 EUR
#   /
#  8BE001 ------------- 8RE004
#  100 St. x8 EUR       13 St. x8 EUR
#   \
#    \----------------------- 8LS001 -- 8RLS001 -- 8KGS001
#     \                       100 St.   52 St.     52 St.
#
#- 1 -- 2 -- 3 -- 4 --- 5 --- 6 ------- 7 -------- 8 ----> Zeitstrahl


# 1: Bestellung 8BE001
Given I open an editor "8BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 8BE001 |
   | lief    | 001fa8 |
And I append rows
   | artikel   | mge | preis | he    |
   | EK1-FALL8 | 100 |     8 | Stück |
And I save the current editor


# 2: Rechnung 8RE001
Given I open an editor "8RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "8BE001"
And I set fields
   | nummer | 8RE001 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "49" in row 1
And I set field "preis" to "5" in row 1
Then field "ngeliefertremge" has value "49" in row 1
Then field "konto" has value "36fall8" in row 1
Then field "vorgangskonto" has value "1ifall8" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "49" in row 1
Then field "kvnum" has value "8BE001" in row 1
Then field "zwischenkonto" has value "36fall8" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Rechnung 8RE002
Given I open an editor "8RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "8BE001"
And I set fields
   | nummer | 8RE002 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "21" in row 1
And I set field "preis" to "6" in row 1
Then field "ngeliefertremge" has value "21" in row 1
Then field "konto" has value "36fall8" in row 1
Then field "vorgangskonto" has value "1ifall8" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "21" in row 1
Then field "kvnum" has value "8BE001" in row 1
Then field "zwischenkonto" has value "36fall8" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Rechnung 8RE003
Given I open an editor "8RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "8BE001"
And I set fields
   | nummer | 8RE003 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "17" in row 1
And I set field "preis" to "7" in row 1
Then field "ngeliefertremge" has value "17" in row 1
Then field "konto" has value "36fall8" in row 1
Then field "vorgangskonto" has value "1ifall8" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "17" in row 1
Then field "kvnum" has value "8BE001" in row 1
Then field "zwischenkonto" has value "36fall8" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Rechnung 8RE004
Given I open an editor "8RE004" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "8BE001"
And I set fields
   | nummer | 8RE004 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "13" in row 1
And I set field "preis" to "8" in row 1
Then field "ngeliefertremge" has value "13" in row 1
Then field "konto" has value "36fall8" in row 1
Then field "vorgangskonto" has value "1ifall8" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "13" in row 1
Then field "kvnum" has value "8BE001" in row 1
Then field "zwischenkonto" has value "36fall8" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 6: Lieferschein 8LS001
Given I open an editor "8LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "8BE001"
Then field "fakt" has value "nein"
And I set fields
   | nummer | 8LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor


# 7: Ruecklieferschein 8RLS001
Given I open an editor "rueck-8RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+8LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 8RLS001          |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-52" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor
And I close the current editor


# 8: Kaufmaennische Gutschrift 8KGS001
Given I open an editor "8KGS001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-8RLS001"
And I set fields
   | nummer | 8KGS001  |
   | such   | KGS8a001 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
Then field "mge" has value "-1" in row 1
Then field "mge" has value "-21" in row 2
Then field "mge" has value "-17" in row 3
Then field "mge" has value "-13" in row 4
Then field "kvnum" has value "8BE001" in row 1
Then field "kvnum" has value "8BE001" in row 2
Then field "kvnum" has value "8BE001" in row 3
Then field "kvnum" has value "8BE001" in row 4
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################

Scenario: Fall_09

#
#  9RE001 (mit LB) -- 9RLS001 -- 9KGS01 -- 9SKGS1
#  100 St. x9 EUR     25 St.     25 St.    25 St.
#                         \
#                          \----------------------- 9SRLS001
#                                                   25 St.
#
#- 1 ---------------- 2 -------- 3 ------- 4 ------ 5 -------> Zeitstrahl
#
#  *LB - Lagerbewegung


# 1: Rechnung 9RE001
Given I open an editor "9RE001" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer  | 9RE001 |
   | lief    | 001fa9 |
   | fakt    | ja     |
   | ueb     | ja     |
   | vom     | .      |
Then field "fakt" has value "ja"
And I append rows
   | artikel   | mge | preis | he    |
   | EK1-FALL9 | 100 |     9 | Stück |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 2: Ruecklieferschein 9RLS001
Given I open an editor "rueck-9RLS01" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "9RE001"
Then field "fakt" has value "ja"
And I set fields
   | nummer | 9RLS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-25" in row 1
Then field "kvnum" has value "" in row 1
And I save the current editor


# 3: Kaufmaennische Gutschrift 9KGS01
Given I open an editor "9KGS01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-9RLS01"
And I set fields
   | nummer | 9KGS01  |
   | such   | KGS9a01 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
Then field "mge" has value "-25" in row 1
Then field "kvnum" has value "9RE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Storno Gutschrift
Given I open an editor "kgs-storno-9SKGS1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+9KGS01"
And I set field "num4" to "9SKGS1"
And I save the current editor


# 5: Storno von Ruecklieferschein 9RLS001
Given I open an editor "kgs-storno-9SRLS001" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "9RLS001"
And I set field "num4" to "9SRLS001"
And I save the current editor
# #######################################################################################

Scenario: Fall_10


# "Bsp 1" aus BW2-2360
#
#                    / ------------ 10RE001
#                   /               10 St. x10EUR
#                  /
# 10BE001 ------ 10LS001 -- 10RLS001 (nicht re-relevant)
# 10St. x10EUR   10St.      2St.
#   \
#    \------------------------------------ 10LS002  (nicht re-relevant)
#     \                                    2St.
#
#- 1 ----------- 2 -------- 3 ----- 4 ---- 5 ----> Zeitstrahl


# 1: Bestellung 10BE001
Given I open an editor "10BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 10BE001 |
   | lief    | 001fa10 |
And I append rows
   | artikel    | mge | preis | he    |
   | EK1-FALL10 |  10 |    10 | Stück |
And I save the current editor


# 2: Lieferschein 10LS001
Given I open an editor "10LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "10BE001"
Then field "fakt" has value "ja"
And I set fields
   | nummer | 10LS001 |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | ja      |
Then field "kvnum" has value "" in row 1
And I set field "mge" to "10" in row 1
Then field "kvnum" has value "" in row 1
And I save the current editor


# 3: Ruecklieferschein 10RLS001
Given I open an editor "rueck-10RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "10LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 10RLS001         |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-2" in row 1
And I set field "rerelev" to "nein" in row 1
And I save the current editor
And I close the current editor


# 4: Rechnung 10RE001
Given I open an editor "10RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "10LS001"
Then field "kvnum" has value "" in row 1
Then field "konto" has value "1ifall10" in row 1
And I set fields
   | nummer | 10RE001 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
Then field "kvnum" has value "" in row 1
And I set field "mge" to "10" in row 1
Then field "kvnum" has value "" in row 1
And I set field "preis" to "10" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall10" in row 1
Then field "vorgangskonto" has value "1ifall10" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "10" in row 1
Then field "kvnum" has value "" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Lieferschein 10LS002
Given I open an editor "10LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "10BE001"
Then field "fakt" has value "ja"
And I set fields
   | nummer | 10LS002 |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | nein    |
And I set field "mge" to "2" in row 1
And I set field "rerelev" to "nein" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_11

# "Bsp 2" aus BW2-2360
#
#                  /------------ 11RE001
#                 /              10 St. x10EUR
#                /
# 11BE001 ---- 11LS001 -- 11RLS001 (re-relevant) -- 11KGS01
# 10St.x10EUR  10 St.     2 St.                     2 St.
#
#- 1 --------- 2 -------- 3 ---- 4 ---------------- 5 ------> Zeitstrahl


# 1: Bestellung 11BE001
Given I open an editor "11BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 11BE001 |
   | lief    | 001fa11 |
And I append rows
   | artikel    | mge | preis | he    |
   | EK1-FALL11 |  10 |    10 | Stück |
And I save the current editor


# 2: Lieferschein 11LS001
Given I open an editor "11LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "11BE001"
Then field "fakt" has value "ja"
And I set fields
   | nummer | 11LS001 |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor


# 3: Ruecklieferschein 11RLS001
Given I open an editor "rueck-11RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "11LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 11RLS001         |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-2" in row 1
# And I set field "rerelev" to "nein" in row 1
And I save the current editor
And I close the current editor


# 4: Rechnung 11RE001
Given I open an editor "11RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "11LS001"
And I set fields
   | nummer | 11RE001 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "10" in row 1
And I set field "preis" to "10" in row 1
Then field "ngeliefertremge" has value "2" in row 1
Then field "konto" has value "36fall11" in row 1
Then field "vorgangskonto" has value "1ifall11" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "10" in row 1
Then field "kvnum" has value "11BE001" in row 1
Then field "zwischenkonto" has value "36fall11" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Kaufmaennische Gutschrift 11KGS01
Given I open an editor "11KGS01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-11RLS001"
And I set fields
   | nummer | 11KGS01  |
   | such   | KGS11a01 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
Then field "mge" has value "-2" in row 1
Then field "kvnum" has value "11BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################



# bis FALL24 hier moeglich
#
# ENDE
# #######################################################################################

