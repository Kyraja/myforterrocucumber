# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert_storno_001.feature
#  Datum     : 22.11.2024
#  Autor     : wane
#  Verantwortlich : wane
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - STORNO
#
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert"
Background:
Given I set the fake date to "02.01.2002"

#Scenario: Stammdaten



Scenario: Fall_01

#
#  1BE001 ---1RE001
#  100 St.   100 St.
#    \
#     \------------- 1LS001 ---- 1SLS001
#      \             100 St.     100 St.
#       \
#        \------------------------------ 1LS002
#         \                              100 St.
#
#-- 1 ------ 2 ----- 3 --------- 4 ----- 5 ------> Zeitstrahl

# 1: Bestellung
Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE001 |
   | lief    | 001fa1 |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL1 | 100 | Stück |
And I save the current editor


# 2: Rechnung
Given I open an editor "1RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE001"
And I set fields
   | nummer | 1RE001  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall1" in row 1
Then field "vorgangskonto" has value "1ifall1" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein
Given I open an editor "1LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE001"
And I set fields
   | nummer | 1LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor


# 3a: Buchungsstorno versuchen
#  Fehler meldung 3537 de      |Storno der Buchung nicht möglich. Bitte Lieferschein stornieren.
Given opening an editor from table "(Entry):(Entry)" with command "REVERSAL" for search criteria "$,,;ursacheref==4 +1LS001;@richtung=rückwärts;@maxtreffer=1" throws the exception "3537"
And I close the current editor


# 4: Lieferschein stornieren
Given I open an editor "ls-storno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+1LS001"
And I set field "num4" to "1SLS001"
And I set field "bem" to "STORNO von LS 1LS001"
And I save the current editor


# 5: Buchung zu Storno anschauen
Given I open an editor "Buchung-Storno" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "1SLS001"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 2 rows
Then field "konto" has value "36fall1" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "-100.00" in row 1
#
Then field "konto" has value "1ifall1" in row 2
And I close the current editor


# 6: Lieferschein -> Rest wird geliefert
Given I open an editor "1LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE001"
And I set fields
   | nummer | 1LS002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor


# 7: Buchung anschauen
Given I open an editor "LS-Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "1LS002"
Then field "stornovorlobjekt" is empty
Then the table has 2 rows
Then field "konto" has value "36fall1" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "100.00" in row 1
#
Then field "konto" has value "1ifall1" in row 2
And I close the current editor
# #######################################################################################

Scenario: Fall_02  A

#
#      /--- 2LS001 ---- 2RE001
#     /     20 St.      20 St.
#    /
#  2BE001 ---------2RE002
#  100 St.         35 St.
#    \
#     \-------------------- 2LS002a -------------- 2SLS002a
#      \                    50 St.(35 geb.)        50 St.(bucht 50 St.): Korrekt
#       \
#        \ ------------------------ 2RE003
#         \                         45 St.
#          \
#           \------------------------------ 2LS003
#            \                              30 St.(30 geb.)
#             \
#              \ ----------------------------------------- 2LS002b
#               \                                          50 St. (bucht 50 St.): Korrekt
#
#---- 1 --- 2 ---- 3 -- 4 - 5 ----- 6 ----- 7 ---- 8 ----- 9 -----> Zeitstrahl

# 1: Bestellung
Given I open an editor "2BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 2BE001 |
   | lief    | 001fa2 |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL2 | 100 | Stück |
And I save the current editor


# 2: Lieferschein
Given I open an editor "2LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "2BE001"
And I set fields
   | nummer | 2LS001 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "ja"
And I set field "mge" to "20" in row 1
And I save the current editor


# 3: Rechnung 2RE002
Given I open an editor "2RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "2BE001"
And I set fields
   | nummer | 2RE002  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "35" in row 1
Then field "ngeliefertremge" has value "35" in row 1
Then field "konto" has value "36fall2" in row 1
Then field "vorgangskonto" has value "1ifall2" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "35" in row 1
Then field "zwischenkonto" has value "36fall2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Rechnung 1RE001
Given I open an editor "1RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2LS001"
And I set fields
   | nummer | 2RE001  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "20" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall2" in row 1
Then field "vorgangskonto" has value "1ifall2" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Lieferschein
Given I open an editor "2LS002a" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "2BE001"
And I set fields
   | nummer | 2LS002a |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "50" in row 1
And I save the current editor


# LS-Buchung anschauen
Given I open an editor "Buchung-001" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "2LS002a"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 2 rows
Then field "konto" has value "36fall2" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "70.00" in row 1
#
Then field "konto" has value "1ifall2" in row 2
And I close the current editor


# 6: Rechnung
Given I open an editor "2RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "2BE001"
And I set fields
   | nummer | 2RE003  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "45" in row 1
Then field "ngeliefertremge" has value "30" in row 1
Then field "konto" has value "36fall2" in row 1
Then field "vorgangskonto" has value "1ifall2" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "45" in row 1
Then field "zwischenkonto" has value "36fall2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# RE-Buchung anschauen
Given I open an editor "Buchung-001" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "2RE003"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 5 rows
Then field "konto" has value "L 001fa2" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "104.40" in row 1
#
Then field "konto" has value "36fall2" in row 2
Then field "ewsbetr" has value "90.00" in row 2
Then field "ewhbetr" has value "0.00" in row 2
#
Then field "konto" has value "36fall2" in row 3
Then field "ewsbetr" has value "0.00" in row 3
Then field "ewhbetr" has value "30.00" in row 3
#
Then field "konto" has value "1ifall2" in row 4
Then field "ewsbetr" has value "30.00" in row 4
Then field "ewhbetr" has value "0.00" in row 4
#
Then field "konto" has value "14050" in row 5
Then field "ewsbetr" has value "14.40" in row 5
Then field "ewhbetr" has value "0.00" in row 5
And I close the current editor


# 7: Lieferschein
Given I open an editor "2LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "2BE001"
And I set fields
   | nummer | 2LS003 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "30" in row 1
And I save the current editor


# LS-Buchung anschauen
Given I open an editor "Buchung-001" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "2LS003"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 2 rows
Then field "konto" has value "36fall2" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "60.00" in row 1
#
Then field "konto" has value "1ifall2" in row 2
#
And I close the current editor


# 8: Lieferschein stornieren
Given I open an editor "2SLS002a" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+2LS002a"
And I set field "num4" to "2SLS002a"
And I set field "bem" to "STORNO von LS 2LS002a"
And I save the current editor


# Buchung zu Storno anschauen
# 50 St.(muss 50 buchen!!!)
Given I open an editor "Buchung-Storno" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "2SLS002a"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 4 rows
Then field "konto" has value "36fall2" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "-70.00" in row 1
#
Then field "konto" has value "1ifall2" in row 2
#
Then field "konto" has value "36fall2" in row 3
Then field "ewsbetr" has value "0.00" in row 3
Then field "ewhbetr" has value "-30.00" in row 3
#
Then field "konto" has value "1ifall2" in row 4
And I close the current editor


# 9: Lieferschein -> Rest wird geliefert
Given I open an editor "2LS002b" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "2BE001"
And I set fields
   | nummer | 2LS002b |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "50" in row 1
And I save the current editor


# LS-Buchung anschauen
Given I open an editor "Buchung-001" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "2LS002b"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 4 rows
Then field "konto" has value "36fall2" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "70.00" in row 1
#
Then field "konto" has value "1ifall2" in row 2
#
Then field "konto" has value "36fall2" in row 3
Then field "ewsbetr" has value "0.00" in row 3
Then field "ewhbetr" has value "30.00" in row 3
#
Then field "konto" has value "1ifall2" in row 4
And I close the current editor
# #######################################################################################

Scenario: Fall_03 B

#
#         /--- 3RE001
#        /     20 St.
#       /
#      /------------ 3LS001
#     /              20 St.
#    /
#  3BE001 --------------- 3RE002
#  100 St.                35 St.
#    \
#     \------------------------- 3LS002a ------------ 3SLS002a
#      \                         50 St.               50 St.(bucht 50 St.): Korrekt
#       \
#        \ --------------------------- 3RE003
#         \                            45 St.
#          \
#           \---------------------------------3LS003
#            \                                30 St.
#             \
#              \ ---------------------------------------------- 3LS002b
#               \                                               50 St.
#
#---- 1 ------ 2 --- 3 -- 4 ---- 5 --- 6 ----- 7 ---- 8 ------- 9 -------> Zeitstrahl

# 1: Bestellung
Given I open an editor "3BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 3BE001 |
   | lief    | 001fa3 |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL3 | 100 | Stück |
And I save the current editor


# 2: Rechnung 3RE001
Given I open an editor "3RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "3BE001"
And I set fields
   | nummer | 3RE001  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "20" in row 1
Then field "ngeliefertremge" has value "20" in row 1
Then field "konto" has value "36fall3" in row 1
Then field "vorgangskonto" has value "1ifall3" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "36fall3" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 3LS001
Given I open an editor "3LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "3BE001"
And I set fields
   | nummer | 3LS001 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "20" in row 1
And I save the current editor


# 4: Rechnung 3RE002
Given I open an editor "3RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "3BE001"
And I set fields
   | nummer | 3RE002  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "35" in row 1
Then field "ngeliefertremge" has value "35" in row 1
Then field "konto" has value "36fall3" in row 1
Then field "vorgangskonto" has value "1ifall3" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "35" in row 1
Then field "zwischenkonto" has value "36fall3" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Lieferschein 3LS002a
Given I open an editor "3LS002a" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "3BE001"
And I set fields
   | nummer | 3LS002a |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "50" in row 1
And I save the current editor


# 6: Rechnung 3RE003
Given I open an editor "3RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "3BE001"
And I set fields
   | nummer | 3RE003  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "45" in row 1
Then field "ngeliefertremge" has value "30" in row 1
Then field "konto" has value "36fall3" in row 1
Then field "vorgangskonto" has value "1ifall3" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "45" in row 1
Then field "zwischenkonto" has value "36fall3" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 7: Lieferschein 3LS003
Given I open an editor "3LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "3BE001"
And I set fields
   | nummer | 3LS003 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "30" in row 1
And I save the current editor


# 8: Lieferschein stornieren
Given I open an editor "3SLS002a" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+3LS002a"
And I set field "num4" to "3SLS002a"
And I set field "bem" to "STORNO von LS 3LS002a"
And I save the current editor


# Buchung zu Storno anschauen
# 50 St.(muss 50 buchen!!!)
Given I open an editor "Buchung-Storno3" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "3SLS002a"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 4 rows
Then field "konto" has value "36fall3" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "-105.00" in row 1
#
Then field "konto" has value "1ifall3" in row 2
#
Then field "konto" has value "36fall3" in row 3
Then field "ewsbetr" has value "0.00" in row 3
Then field "ewhbetr" has value "-45.00" in row 3
#
Then field "konto" has value "1ifall3" in row 4
And I close the current editor


# 9: Lieferschein 3LS002b
Given I open an editor "3LS002b" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "3BE001"
And I set fields
   | nummer | 3LS002b |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "50" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_04

#
#
#  4BE001 -- 4RE001 ------- 4SRE001
#  100 St.   80 St.         80 St.
#    \
#     \------------ 4LS001 -------- 4SLS001
#      \            100 St.         100 St.
#       \
#        \---------------------------------- 4RE002
#         \                                  100 St.
#          \
#           \---------------------------------------- 4LS002
#            \                                        100 St.
#
#--- 1 ----- 2 ---- 3 ----- 4 ----- 5 ------ 6 ------ 7 -----> Zeitstrahl

# 1: Bestellung 4BE001
Given I open an editor "4BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 4BE001 |
   | lief    | 001fa4 |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL4 | 100 | Stück |
And I save the current editor


# 2: Rechnung 4RE001
Given I open an editor "4RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "4BE001"
And I set fields
   | nummer | 4RE001  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "80" in row 1
Then field "ngeliefertremge" has value "80" in row 1
Then field "konto" has value "36fall4" in row 1
Then field "vorgangskonto" has value "1ifall4" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "80" in row 1
Then field "zwischenkonto" has value "36fall4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 4LS001
Given I open an editor "4LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "4BE001"
And I set fields
   | nummer | 4LS001 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "100" in row 1
And I save the current editor


# 4: Rechnung stornieren
Given I open an editor "4SRE001" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+4RE001"
And I set field "num4" to "4SRE001"
And I set field "bem" to "STORNO von RE 4RE001"
And I save the current editor


# 5:  stornieren
Given I open an editor "4SLS001" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+4LS001"
And I set field "num4" to "4SLS001"
And I set field "bem" to "STORNO von LS 4LS001"
And I save the current editor


Given I open an editor "4SLS001-VIEW" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+4SLS001"
Then field "partnervorgang" is not empty
Then field "rebu" is empty
And I close the current editor


# 6: Rechnung 4RE002
Given I open an editor "4RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "4BE001"
And I set fields
   | nummer | 4RE002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall4" in row 1
Then field "vorgangskonto" has value "1ifall4" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 7: Lieferschein 4LS002
Given I open an editor "4LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "4BE001"
And I set fields
   | nummer | 4LS002 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "100" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_05

#
#  5BE001 -- 5RE001a ---------- 5SRE001a
#  100 St.   100 St.            100 St.
#    \
#     \--------------- 5LS001 --------- 5SLS001
#      \               50 St.           50 St.
#       \
#        \-------------------------------------- 5RE001b(mit Lagerbewegung)
#         \                                      100 St.
#
#-- 1 ------ 2 ------- 3 ------ 4 ----- 5 ------ 6 -----> Zeitstrahl

# 1: Bestellung 5BE001
Given I open an editor "5BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 5BE001 |
   | lief    | 001fa5 |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL5 | 100 | Stück |
And I save the current editor


# 2: Rechnung 5RE001a
Given I open an editor "5RE001a" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "5BE001"
And I set fields
   | nummer | 5RE001a |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall5" in row 1
Then field "vorgangskonto" has value "1ifall5" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 5LS001
Given I open an editor "5LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "5BE001"
And I set fields
   | nummer | 5LS001 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "50" in row 1
And I save the current editor


# 4: Rechnung stornieren
Given I open an editor "5SRE001a" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+5RE001a"
And I set field "num4" to "5SRE001a"
And I set field "bem" to "STORNO von RE 5RE001a"
And I save the current editor


# 5: Lieferschein stornieren
Given I open an editor "5SLS001" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+5LS001"
And I set field "num4" to "5SLS001"
And I set field "bem" to "STORNO von LS 5LS001"
And I save the current editor


Given I open an editor "5SLS001-VIEW" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+5SLS001"
Then field "partnervorgang" is not empty
Then field "rebu" is empty
And I close the current editor


# 6: Rechnung 5RE001b (mit Lagerbewegung)
Given I open an editor "5RE001b" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "5BE001"
And I set fields
   | nummer | 5RE001b |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | ja      |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall5" in row 1
Then field "vorgangskonto" has value "1ifall5" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################

Scenario: Fall_06

#
#      /--- 6RE001(mit Lagerbewegung)
#     /     20 St.
#    /
#  6BE001 --------- 6LS001(nicht re-relevant) ------- 6SLS001
#  100 St.          5 St.                             5 St. (bucht nicht): Korrekt
#    \
#     \------------------- 6LS002 ------------ 6SLS002
#      \                   20 St.              20 St. (bucht 20St, von Bestand (Haben) auf 36-Konto (Soll)): Korrekt
#       \
#        \ --------------------- 6RE002
#         \                      80 St. (bucht 25 auf Bestand und 55 auf 36-Konto): Korrekt???
#          \
#           \-------------------------- 6LS003
#            \                          55 St. (bucht 55 von 36-Konto auf Bestand): Korrekt
#             \
#              \ --------------------------------------------- 6LS004
#               \                                              25 St.  (bucht 25 St.) -> Fehler!!!! Darf aber nur 20 St. buchen!!! -> 5St zu viel von Zw-Konto abgebucht!!!
#
#---- 1 ----- 2 --- 3 ---- 4 --- 5 ---- 6 ----- 7------ 8 ---- 9 -----> Zeitstrahl


# 1: Bestellung 6BE001
Given I open an editor "6BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 6BE001 |
   | lief    | 001fa6 |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL6 | 100 | Stück |
And I save the current editor


# 2: Rechnung 6RE001
Given I open an editor "6RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "6BE001"
And I set fields
   | nummer | 6RE001 |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I set field "mge" to "20" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall6" in row 1
Then field "vorgangskonto" has value "1ifall6" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 6LS001 (nicht re-relevant)
Given I open an editor "6LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "6BE001"
Then field "fakt" has value "ja"
And I set fields
   | nummer | 6LS001 |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
Then field "fakt" has value "nein"
And I set field "mge" to "5" in row 1
And I set field "rerelev" to "nein" in row 1
And I save the current editor


# 4: Lieferschein 6LS002
Given I open an editor "6LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "6BE001"
And I set fields
   | nummer | 6LS002 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "20" in row 1
And I save the current editor


# Rechnung 6RE002
Given I open an editor "6RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "6BE001"
And I set fields
   | nummer | 6RE002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "80" in row 1
Then field "ngeliefertremge" has value "55" in row 1
Then field "konto" has value "36fall6" in row 1
Then field "vorgangskonto" has value "1ifall6" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "80" in row 1
Then field "zwischenkonto" has value "36fall6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Lieferschein 6LS003
Given I open an editor "6LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "6BE001"
And I set fields
   | nummer | 6LS003 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "55" in row 1
And I save the current editor


# 6: Lieferschein 6LS002 stornieren
Given I open an editor "6SLS002" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+6LS002"
And I set field "num4" to "6SLS002"
And I set field "bem" to "STORNO von LS 6LS002"
And I save the current editor


# 7: Lieferschein 6LS001 stornieren
Given I open an editor "6SLS001" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+6LS001"
And I set field "num4" to "6SLS001"
And I set field "bem" to "STORNO von LS 6LS001"
And I save the current editor


# 8: Lieferschein 6LS004
Given I open an editor "6LS004" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "6BE001"
And I set fields
   | nummer | 6LS004 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "25" in row 1
And I set field "rerelev" to "ja" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_07

#
#      /-- 7RE001 ------------------------- 7SRE001
#     /    70 St.                           70 St./
#    /
#  7BE001 ------ 7RE002
#  100 St.       30 St.
#    \
#     \---------------- 7LS001
#      \                40 St.
#       \
#        \ ------------------- 7LS002
#         \                    50 St.
#          \
#           \------------------------ 7LS003(nicht re-relevant)     ---- Fehler: der Wert von 10St. bleibt auf 36-Konto haengen. Es bleibt so!!!
#            \                        10 St.
#             \
#              \ ---------------------------------- 7RE003
#               \                                   70 St.
#
#--- 1 --- 2 --- 3 ---- 4 ---- 5 ---- 6 --- 7 ----- 8 ------> Zeitstrahl


# 1: Bestellung 7BE001
Given I open an editor "7BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 7BE001 |
   | lief    | 001fa7 |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL7 | 100 | Stück |
And I save the current editor


# 2: Rechnung 7RE001
Given I open an editor "7RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "7BE001"
And I set fields
   | nummer | 7RE001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "70" in row 1
Then field "ngeliefertremge" has value "70" in row 1
Then field "konto" has value "36fall7" in row 1
Then field "vorgangskonto" has value "1ifall7" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "70" in row 1
Then field "zwischenkonto" has value "36fall7" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Rechnung 7RE002
Given I open an editor "7RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "7BE001"
And I set fields
   | nummer | 7RE002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "30" in row 1
Then field "ngeliefertremge" has value "30" in row 1
Then field "konto" has value "36fall7" in row 1
Then field "vorgangskonto" has value "1ifall7" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "30" in row 1
Then field "zwischenkonto" has value "36fall7" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Lieferschein 7LS001
Given I open an editor "7LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "7BE001"
And I set fields
   | nummer | 7LS001 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "40" in row 1
And I save the current editor


# 5: Lieferschein 7LS002
Given I open an editor "7LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "7BE001"
And I set fields
   | nummer | 7LS002 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "50" in row 1
And I save the current editor


# 6: Lieferschein 7LS003 (nicht re-relevant)
Given I open an editor "7LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "7BE001"
And I set fields
   | nummer | 7LS003 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "10" in row 1
And I set field "rerelev" to "nein" in row 1
And I save the current editor


# 7: Rechnung 7RE001 stornieren
Given I open an editor "7SRE001" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+7RE001"
And I set field "num4" to "7SRE001"
And I set field "bem" to "STORNO von RE 7RE001"
And I save the current editor


# 8: Rechnung 7RE003
Given I open an editor "7RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "7BE001"
And I set fields
   | nummer | 7RE003 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "70" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall7" in row 1
Then field "vorgangskonto" has value "1ifall7" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "70" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################

Scenario: Fall_08

#
#      /- 8LS001a ---------------------- 8SLS001a
#     /   70 St.                         70 St. (bucht 40St. + 30St.): Korrekt
#    /
#  8BE001 ------- 8RE001
#  100 St.        40 St.
#    \
#     \------------------ 8RE002
#      \                  60 St.
#       \
#        \----------------------- 8LS002
#         \                       30 St.
#          \
#           \ ------------------------------------ 8LS001b
#            \                                     70 St. (bucht 30St zu 8RE002 und 40 St zu 8RE001): Korrekt
#
#- 1 ---- 2 ----- 3 ----- 4 ----- 5 ---- 6 ------- 7 ---------> Zeitstrahl

# 1: Bestellung
Given I open an editor "8BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 8BE001 |
   | lief    | 001fa8 |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL8 | 100 | Stück |
And I save the current editor


# 2: Lieferschein
Given I open an editor "8LS001a" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "8BE001"
Then field "fakt" has value "ja"
And I set fields
   | nummer | 8LS001a |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | nein    |
Then field "fakt" has value "nein"
And I set field "mge" to "70" in row 1
And I save the current editor


# 3: Rechnung 8RE001
Given I open an editor "8RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "8BE001"
And I set fields
   | nummer | 8RE001  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "40" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall8" in row 1
Then field "vorgangskonto" has value "1ifall8" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "40" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Rechnung 8RE002
Given I open an editor "8RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "8BE001"
And I set fields
   | nummer | 8RE002  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "60" in row 1
Then field "ngeliefertremge" has value "30" in row 1
Then field "konto" has value "36fall8" in row 1
Then field "vorgangskonto" has value "1ifall8" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "60" in row 1
Then field "zwischenkonto" has value "36fall8" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Lieferschein 8LS002
Given I open an editor "8LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "8BE001"
And I set fields
   | nummer | 8LS002 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "30" in row 1
And I save the current editor


# 6: Lieferschein 8LS001a stornieren
Given I open an editor "8SLS001a" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+8LS001a"
And I set field "num4" to "8SLS001a"
And I set field "bem" to "STORNO von LS 8LS001a"
And I save the current editor


# 7: Lieferschein 8LS001b
Given I open an editor "8LS001b" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "8BE001"
And I set fields
   | nummer | 8LS001b |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "70" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_09

#
#      /- 9LS001a ------- 9SLS001a
#     /   100 St.         100 St. (bucht 100St Bestand auf 36-Konto): Korrekt
#    /
#  9BE001 ------- 9RE001
#  100 St.        100 St. (bucht 100St auf Bestand): Korrekt
#    \
#     \ ------------------------- 9LS001b
#      \                          100 St. (bucht 100St von 36-Konto auf Bestand): Korrekt
#
#- 1 ---- 2 ----- 3 ----- 4 ----- 5 ----------> Zeitstrahl

# 1: Bestellung 9BE001
Given I open an editor "9BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 9BE001 |
   | lief    | 001fa9 |
And I append rows
   | artikel   | mge | he    |
   | EK1-FALL9 | 100 | Stück |
And I save the current editor


# 2: Lieferschein
Given I open an editor "9LS001a" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "9BE001"
Then field "fakt" has value "ja"
And I set fields
   | nummer | 9LS001a |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | nein    |
Then field "fakt" has value "nein"
And I set field "mge" to "100" in row 1
And I save the current editor


# 3: Rechnung 9RE001
Given I open an editor "9RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "9BE001"
And I set fields
   | nummer | 9RE001  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall9" in row 1
Then field "vorgangskonto" has value "1ifall9" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Lieferschein 9LS001a stornieren
Given I open an editor "9SLS001a" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+9LS001a"
And I set field "num4" to "9SLS001a"
And I set field "bem" to "STORNO von LS 9LS001a"
And I save the current editor


# 5: Lieferschein 9LS001b
Given I open an editor "9LS001b" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "9BE001"
And I set fields
   | nummer | 9LS001b |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "100" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_10

#
#      /- 10RE001 ------- 10SRE001
#     /   100 St.         100 St.
#    /
#  10BE001 ------ 10LS001
#  100 St.        60 St. (bucht 60St von 36-Konto) Korrekt
#    \
#     \ ------------------------- 10RE002
#      \                          100 St. (bucht 40 St. auf 36-Konto und 60 St. auf Bestandskonto): Korrekt
#       \
#        \ ------------------------------ 10LS002
#         \                               40 St. (bucht 40St von 36-Konto ab): Korrekt
#
#- 1 ---- 2 ----- 3 ----- 4 ----- 5 ----- 6 -------> Zeitstrahl


# 1: Bestellung 10BE001
Given I open an editor "10BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 10BE001 |
   | lief    | 001fa10 |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL10 | 100 | Stück |
And I save the current editor


# 2: Rechnung 10RE001
Given I open an editor "10RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "10BE001"
And I set fields
   | nummer | 10RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall10" in row 1
Then field "vorgangskonto" has value "1ifall10" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 10LS001
Given I open an editor "10LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "10BE001"
And I set fields
   | nummer | 10LS001 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "60" in row 1
And I save the current editor


# 4: Rechnung 10RE001 stornieren
Given I open an editor "10SRE001" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+10RE001"
And I set field "num4" to "10SRE001"
And I set field "bem" to "STORNO von RE 10RE001"
And I save the current editor


# 5: Rechnung 10RE002
Given I open an editor "10RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "10BE001"
And I set fields
   | nummer | 10RE002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "40" in row 1
Then field "konto" has value "36fall10" in row 1
Then field "vorgangskonto" has value "1ifall10" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 6: Lieferschein 10LS002
Given I open an editor "10LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "10BE001"
And I set fields
   | nummer | 10LS002 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "40" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_11

#
#      /- 11RE001 ------- 11SRE001
#     /   60 St.          60 St.
#    /
#  11LS001 ------ 11RE002
#  100 St.        40 St.
#    \
#     \ ------------------------- 11RE003
#      \                          60 St.
#
#- 1 ---- 2 ----- 3 ----- 4 ----- 5 -----------> Zeitstrahl


# 1: Lieferschein 11LS001
Given I open an editor "11LS001" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 11LS001 |
   | lief    | 001fa11 |
   | vom     | .       |
   | ueb     | ja      |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL11 | 100 | Stück |
And I save the current editor


# 2: Rechnung 11RE001
Given I open an editor "11RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "11LS001"
And I set fields
   | nummer | 11RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "60" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall11" in row 1
Then field "vorgangskonto" has value "1ifall11" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "60" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Rechnung 11RE002
Given I open an editor "11RE002" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "11LS001"
And I set fields
   | nummer | 11RE002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "40" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall11" in row 1
Then field "vorgangskonto" has value "1ifall11" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "40" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Rechnung 11RE001 stornieren
Given I open an editor "11SRE001" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+11RE001"
And I set field "num4" to "11SRE001"
And I set field "bem" to "STORNO von RE 11RE001"
#
Then field "kvnum" has value "11LS001" in row 1
Then field "ptext" has value "" in row 1
And I save the current editor

Given I open an editor "11SRE001" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+11SRE001"
Then field "partnervorgang" is not empty
# ??? Then field "rebu" is not empty
Then field "kvnum" has value "11LS001" in row 1
Then field "ptext" has value "" in row 1
And I save the current editor


# 5: Rechnung 11RE003
Given I open an editor "11RE003" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "11LS001"
And I set fields
   | nummer | 11RE003 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "60" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall11" in row 1
Then field "vorgangskonto" has value "1ifall11" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "60" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################

Scenario: Fall_12

#
#  12BE001 -- 12LS001 -- 12RE001 -------------------------- 12SRE001
#  100 St.    100 St.    100 St.                            100 St.
#                \
#                 \---------- 12RLS01 -- 12KGS01 -- 12SKGS1
#                             100 St.    100 St.    100 St.
#
#- 1 -------- 2 -------- 3 -- 4 -------- 5 -------- 6 ----- 7 ----> Zeitstrahl

# Fehler:
# * 12RLS01 bucht nicht, weil "fakt" eingehackt ist! Bei RLS muss "fakt" ignoriert werden!
# * 12KGS01 bucht von Bestandskonto
# * 12SKGS1 und 12SRE001 verwenden falsche KVNUM
#

# 1: Bestellung 12BE001
Given I open an editor "12BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 12BE001 |
   | lief    | 001fa12 |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL12 | 100 | Stück |
And I save the current editor


# 2: Lieferschein 12LS001
Given I open an editor "12LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "12BE001"
And I set fields
   | nummer | 12LS001 |
   | ueb    | ja      |
   | vom    | .       |
   | kenn   | FALL-12 |
Then field "fakt" has value "ja"
And I set field "mge" to "100" in row 1
And I save the current editor


# 3: Rechnung 12RE001
Given I open an editor "12RE001" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "12LS001"
And I set fields
   | nummer | 12RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall12" in row 1
Then field "vorgangskonto" has value "1ifall12" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Ruecklieferschein 12RLS01
Given I open an editor "rls-12RLS01" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+12LS001"
And I set fields
   | nummer | 12RLS01 |
   | ueb    | ja      |
   | vom    | .       |
   | kenn   | FALL-12 Ruecklieferschein |
And I set field "mge" to "-100" in row 1
And I save the current editor


# 5: KGS 12KGS001
Given I open an editor "gutschrift-12KGS01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-12RLS01"
And I set fields
   | nummer | 12KGS01 |
   | ueb    | ja      |
   | vom    | .       |
   | kenn   | FALL-12 KGS |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# 6: Storno Gutschrift
Given I open an editor "kgs-storno-12SKGS1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+12KGS01"
And I set field "num4" to "12SKGS1"
And I save the current editor

Given I open an editor "kgs-storno-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+12SKGS1"
Then field "partnervorgang" is not empty
# ??? Then field "rebu" is not empty
Then field "kvnum" has value "12BE001" in row 1
Then field "ptext" has value "" in row 1
And I save the current editor


# 7: Storno Rechnung
Given I open an editor "re-storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+12RE001"
And I set field "num4" to "12SRE001"
And I save the current editor

Given I open an editor "re-storno-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+12SRE001"
Then field "partnervorgang" is not empty
# ???Then field "rebu" is not empty
Then field "kvnum" has value "12BE001" in row 1
Then field "ptext" has value "" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_13 "echtes" Storno

#     /----------------------------- 13RE02
#    /                               100 St
#   /
#  13BE01 ----- 13RE01 -- 13SRE01
#  100 St.      100 St.   100 St. ("echtes" Storno)
#    \
#     \- 13LS01
#      \ 100 St

#
#-- 1 -- 2 ---- 3 ------- 4 ------> Zeitstrahl

# 1: Bestellung
Given I open an editor "13BE01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 13BE01  |
   | lief    | 001fa13 |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL13 | 100 | Stück |
And I save the current editor


# 3: Lieferschein
Given I open an editor "13LS01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "13BE01"
And I set fields
   | nummer | 13LS01 |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "100" in row 1
And I save the current editor


# 3: Rechnung
Given I open an editor "13RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "13BE01"
And I set fields
   | nummer | 13RE01  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall13" in row 1
Then field "vorgangskonto" has value "1ifall13" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Rechnung stornieren
Given I open an editor "re-storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+13RE01"
And I set field "num4" to "13SRE01"
And I set field "bem" to "STORNO von RE 13RE01, echtes Storno"
And I save the current editor


# 4a: Buchung zu Storno anschauen
Given I open an editor "Buchung-Storno" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "13SRE01"
Then field "stornovorlobjekt" is not empty
Then field "stornoobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "L 001fa13" in row 1
Then field "konto" has value "1ifall13" in row 2
Then field "ewsbetr" has value "-1300.00" in row 2
Then field "ewhbetr" has value "0.00" in row 2
#
Then field "konto" has value "14050" in row 3
And I close the current editor


# 5: Rechnung
Given I open an editor "13RE005" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "13BE01"
And I set fields
   | nummer | 13RE05  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
And I set field "preis" to "14,00" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall13" in row 1
Then field "vorgangskonto" has value "1ifall13" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################

Scenario: Fall_14 Storno von EK RE mit "fakt"=true

#
#  14BE01 ----- 14RE01(fakt=true) -- 14SRE01
#  100 St.      100 St.              100 St. ("echtes" Storno)
#
#-- 1 --------- 2 ------------------ 3 --------> Zeitstrahl

# 1: Bestellung
Given I open an editor "14BE01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 14BE01  |
   | lief    | 001fa14 |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL14 | 100 | Stück |
And I save the current editor


# 2: Rechnung
Given I open an editor "14RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "14BE01"
And I set fields
   | nummer | 14RE01  |
   | ueb    | ja      |
   | fakt   | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall14" in row 1
Then field "vorgangskonto" has value "1ifall14" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Rechnung stornieren
Given I open an editor "re-storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+14RE01"
And I set field "num4" to "14SRE01"
And I set field "bem" to "STORNO von RE 14RE01, echtes Storno"
And I save the current editor


# 3a: Buchung zu Storno anschauen
Given I open an editor "Buchung-Storno" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "14SRE01"
Then field "stornovorlobjekt" is not empty
Then field "stornoobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "L 001fa14" in row 1
Then field "konto" has value "1ifall14" in row 2
Then field "ewsbetr" has value "-1400.00" in row 2
Then field "ewhbetr" has value "0.00" in row 2
#
Then field "konto" has value "14050" in row 3
And I close the current editor
# #######################################################################################


# hier nur bis Fall 24
# #######################################################################################
# ENDE

