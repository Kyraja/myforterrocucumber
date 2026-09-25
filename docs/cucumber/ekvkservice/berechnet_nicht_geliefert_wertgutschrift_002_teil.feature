# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert_wertgutschrift_002_teil.feature
#  Datum     : 11.01.2025
#  Autor     : wane
#  Verantwortlich : wane
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - Teil-Wertgutschrift
#
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert"; Teilwertgutschrift
Background:
Given I set the fake date to "02.01.2002"

Scenario: Stammdaten


Scenario: Fall_26

#
#     /--- 26RE001
#    /     20St.(x21EUR)
#   /
#  26BE001 ------------ 26RE002 ------ 26WGS001
#  100St. x10EUR        80St.(x26EUR)  80St.(x15EUR)  Aufteilung 20/60
#   \                      \
#    \                      \------------------ 26WGS002
#     \                      \                  50St.(x3EUR)    Aufteilung 20/60
#      \
#       \-------- 26LS001
#        \        40 St.
#         \
#          \-------------------------------------------- 26LS002
#           \                                            60 St.    bucht korekt: 60*9,125EUR
#                                                                  Preis pro St.: ((80*26) - (80*15 + 50*3)) / 80
#
#-- 1 ----- 2 --- 3 ---- 4 ------------ 5 ------ 6 ----- 7 ------> Zeitstrahl


# 1: Bestellung
Given I open an editor "26BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 26BE001 |
   | lief    | 001fa26 |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL26 | 100 | Stück | 10,00 |
And I save the current editor


# 2: Rechnung 26RE001
Given I open an editor "26RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "26BE001"
And I set fields
   | nummer | 26RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
Then field "ngeliefertremge" has value "20" in row 1
Then field "konto" has value "36fall26" in row 1
Then field "vorgangskonto" has value "1ifall26" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "36fall26" in row 1
Then field "kvnum" has value "26BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 26LS001
Given I open an editor "26LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "26BE001"
And I set fields
   | nummer | 26LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "40" in row 1
And I save the current editor


# 4: Rechnung 26RE002
Given I open an editor "26RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "26BE001"
And I set fields
   | nummer | 26RE002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "80" in row 1
And I set field "preis" to "26" in row 1
Then field "ngeliefertremge" has value "60" in row 1
Then field "konto" has value "36fall26" in row 1
Then field "vorgangskonto" has value "1ifall26" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "80" in row 1
Then field "zwischenkonto" has value "36fall26" in row 1
Then field "kvnum" has value "26BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Teilwertgutschrift 26WGS001
Given I open an editor "26WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "26RE002"
And I set fields
   | nummer | 26WGS001 |
   | such   | WGS01F26 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-80" in row 1
And I set field "preis" to "15" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "26BE001" in row 1
And I save the current editor


# 6: Teilwertgutschrift 26WGS002
Given I open an editor "26WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "26RE002"
And I set fields
   | nummer | 26WGS002 |
   | such   | WGS02F26 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-50" in row 1
And I set field "preis" to "3" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "26BE001" in row 1
And I save the current editor


# 7: Lieferschein 26LS002
Given I open an editor "26LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "26BE001"
And I set fields
   | nummer | 26LS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "60" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_27

#
#     /--- 27RE001
#    /     30St.(x21EUR)
#   /
#  27BE001 ------------ 27RE002 ------ 27WGS001
#  100St.(x10EUR)       70St.(x27EUR)  70St.(x15EUR)  Aufteilung 20/50
#   \                      \
#    \                      \------------------ 27WGS002
#     \                      \                  70St.(x12EUR)    Aufteilung 20/50
#      \
#       \-------- 27LS001
#        \        50 St.
#         \
#          \------------------------------------------- 27LS002
#           \                                           50 St.     bucht nicht: korrekt! nichts zu buchen
#
#-- 1 ----- 2 --- 3 ---- 4 ----------- 5 ------ 6 ----- 7 ------> Zeitstrahl


# 1: Bestellung
Given I open an editor "27BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 27BE001 |
   | lief    | 001fa27 |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL27 | 100 | Stück | 10,00 |
And I save the current editor


# 2: Rechnung 27RE001
Given I open an editor "27RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "27BE001"
And I set fields
   | nummer | 27RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "30" in row 1
And I set field "preis" to "21" in row 1
Then field "ngeliefertremge" has value "30" in row 1
Then field "konto" has value "36fall27" in row 1
Then field "vorgangskonto" has value "1ifall27" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "30" in row 1
Then field "zwischenkonto" has value "36fall27" in row 1
Then field "kvnum" has value "27BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 27LS001
Given I open an editor "27LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "27BE001"
And I set fields
   | nummer | 27LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "50" in row 1
And I save the current editor


# 4: Rechnung 27RE002
Given I open an editor "27RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "27BE001"
And I set fields
   | nummer | 27RE002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "70" in row 1
And I set field "preis" to "27" in row 1
Then field "ngeliefertremge" has value "50" in row 1
Then field "konto" has value "36fall27" in row 1
Then field "vorgangskonto" has value "1ifall27" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "70" in row 1
Then field "zwischenkonto" has value "36fall27" in row 1
Then field "kvnum" has value "27BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Teilwertgutschrift 27WGS001
Given I open an editor "27WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "27RE002"
And I set fields
   | nummer | 27WGS001 |
   | such   | WGS01F27 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-70" in row 1
And I set field "preis" to "15" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "27BE001" in row 1
And I save the current editor


# 6: Teilwertgutschrift 27WGS002
Given I open an editor "27WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "27RE002"
And I set fields
   | nummer | 27WGS002 |
   | such   | WGS02F27 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-70" in row 1
And I set field "preis" to "12" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "27BE001" in row 1
And I save the current editor


# 7: Lieferschein 27LS002
Given I open an editor "27LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "27BE001"
And I set fields
   | nummer | 27LS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "50" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_28

#
#     /--- 28LS001 --------------- 28RE001 ------- 28WGS001
#    /     30St.                   30St.(x21EUR)   30St.(x15EUR)  Korrekt: alles vom Bestandskonto
#   /
#  28BE001 ------------ 28RE002 ------------ 28WGS002
#  100St.(x10EUR)       70St.(x28EUR)        70St.(x15EUR)  Aufteilung 20/50
#   \                      \
#    \                      \--------------------------------- 28WGS003
#     \                      \                                 70St.(x12EUR)  Korrekt: alles vom Bestandskonto
#      \
#       \-------- 28LS002
#        \        20 St.
#         \
#          \-------------------------------------------- 28LS003
#           \                                            50 St.  bucht 50x13
#
#-- 1 ----- 2 --- 3 ---- 4 --------- 5 ------ 6 --- 7 -- 8 ---- 9 -------> Zeitstrahl


# 1: Bestellung 28BE001
Given I open an editor "28BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 28BE001 |
   | lief    | 001fa28 |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL28 | 100 | Stück | 10,00 |
And I save the current editor


# 2: Lieferschein 28LS001
Given I open an editor "28LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "28BE001"
And I set fields
   | nummer | 28LS001 |
   | ueb    | ja      |
   | fakt   | ja      |
   | vom    | .       |
And I set field "mge" to "30" in row 1
And I save the current editor


# 3: Lieferschein 28LS002
Given I open an editor "28LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "28BE001"
And I set fields
   | nummer | 28LS002 |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | nein    |
And I set field "mge" to "20" in row 1
And I save the current editor


# 4: Rechnung 28RE002
Given I open an editor "28RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "28BE001"
And I set fields
   | nummer | 28RE002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "70" in row 1
And I set field "preis" to "28" in row 1
Then field "ngeliefertremge" has value "50" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36fall28" in row 1
Then field "vorgangskonto" has value "1ifall28" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "70" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "zwischenkonto" has value "36fall28" in row 1
Then field "kvnum" has value "28BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Rechnung 28RE001
Given I open an editor "28RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "28LS001"
And I set fields
   | nummer | 28RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "30" in row 1
And I set field "preis" to "21" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "remehrberechneticon" has value "" in row 1
Then field "konto" has value "1ifall28" in row 1
Then field "vorgangskonto" has value "1ifall28" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "30" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 6: Teilwertgutschrift 28WGS002
Given I open an editor "28WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "28RE002"
And I set fields
   | nummer | 28WGS002 |
   | such   | WGS02F28 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-70" in row 1
And I set field "preis" to "15" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "28BE001" in row 1
And I save the current editor


# 7: Teilwertgutschrift 28WGS001
Given I open an editor "28WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "28RE001"
And I set fields
   | nummer | 28WGS001 |
   | such   | WGS01F28 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-30" in row 1
And I set field "preis" to "15" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "28BE001" in row 1
And I save the current editor


# 8: Lieferschein 28LS003
Given I open an editor "28LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "28BE001"
And I set fields
   | nummer | 28LS003 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "50" in row 1
And I save the current editor


# 9: Teilwertgutschrift 28WGS003
Given I open an editor "28WGS003" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "28RE002"
And I set fields
   | nummer | 28WGS003 |
   | such   | WGS03F28 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-70" in row 1
And I set field "preis" to "12" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "28BE001" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_29; mit RLS und KGS

#
#           /- 29RE001 --- 29WGS001
#          /   40St.x11EUR 25St.x2EUR   Aufteilung 30/10
#         /        \
#        /          \--------- 29WGS002 ----- 29SWGS02 (wegen 29WGS003 geht nicht)
#       /            \         40St.x1EUR     40St.
#      /
#     /- 29LS001 ----------------------------------- 29RLS001 ------------- 29KGS001
#    /   30St.                                       30St.  \                20St.
#   /                                                        \------------------------\
#  29BE001 --------- 29RE002 ------------ 29WGS003                                     \- 29KGS003
#  100St.x10EUR      60St.x13EUR          60St.x1EUR  Aufteilung 50/10                  \ 10St.
#   \                   \
#    \                   \------------------------------- 29WGS004
#     \                   \                               15St.x3EUR   Aufteilung 50/10
#      \
#       \-------------------------- 29LS002 -------------------- 29RLS002 -------- 29KGS002
#        \                          25 St.                       15 St.            15 St.
#         \
#          \----------------------------------------------------------- 29LS003
#           \                                                           45 St.
#
#-- 1 -- 2 --- 3 --- 4 --- 5 - 6 -- 7 --- 8 - 9 ---- 10 - 11 --- 12 --- 13 - 14 -- 15 --- 16 ----> Zeitstrahl


# FEHLER: die Buchung zu 29RLS002 ist falsch!!! Sie bucht Werte fuer 60St anstatt fuer 15St!!!

# 1: Bestellung 29BE001
Given I open an editor "29BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 29BE001 |
   | lief    | 001fa29 |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL29 | 100 | Stück | 10,00 |
And I save the current editor


# 2: Lieferschein 29LS001
Given I open an editor "29LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "29BE001"
And I set fields
   | nummer | 29LS001 |
   | ueb    | ja      |
   | fakt   | nein    |
   | vom    | .       |
And I set field "mge" to "30" in row 1
And I save the current editor


# 3: Rechnung 29RE001
Given I open an editor "29RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "29BE001"
And I set fields
   | nummer | 29RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "40" in row 1
And I set field "preis" to "11" in row 1
Then field "ngeliefertremge" has value "10" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36fall29" in row 1
Then field "vorgangskonto" has value "1ifall29" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "40" in row 1
Then field "zwischenkonto" has value "36fall29" in row 1
Then field "kvnum" has value "29BE001" in row 1
And I set field "mge" to "30" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "remehrberechneticon" has value "" in row 1
And I set field "mge" to "40" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Rechnung 29RE002
Given I open an editor "29RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "29BE001"
And I set fields
   | nummer | 29RE002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "60" in row 1
And I set field "preis" to "13" in row 1
Then field "ngeliefertremge" has value "60" in row 1
Then field "konto" has value "36fall29" in row 1
Then field "vorgangskonto" has value "1ifall29" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "60" in row 1
Then field "zwischenkonto" has value "36fall29" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "kvnum" has value "29BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 5: Teilwertgutschrift 29WGS001
Given I open an editor "29WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "29RE001"
And I set fields
   | nummer | 29WGS001 |
   | such   | WGS01F29 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-25" in row 1
And I set field "preis" to "2" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "29BE001" in row 1
And I save the current editor


# 6: Teilwertgutschrift 29WGS002
Given I open an editor "29WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "29RE001"
And I set fields
   | nummer | 29WGS002 |
   | such   | WGS02F29 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-40" in row 1
And I set field "preis" to "1" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "29BE001" in row 1
And I save the current editor


# 7: Lieferschein 29LS002
Given I open an editor "29LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "29BE001"
And I set fields
   | nummer | 29LS002 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "25" in row 1
And I save the current editor


# 8: Teilwertgutschrift 29WGS003
Given I open an editor "29WGS003" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "29RE002"
And I set fields
   | nummer | 29WGS003 |
   | such   | WGS03F29 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-60" in row 1
And I set field "preis" to "1" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "29BE001" in row 1
And I save the current editor


# 9: Versuch Teilwertgutschrift 29WGS002 zu stornieren!!!
#
# 3335 TX=de   |Stornieren Sie zuerst dieses Objekt.
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "29WGS002" throws the exception "3335"


# 10: Ruecklieferschein 29RLS001
Given I open an editor "rueck-29RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+29LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 29RLS001         |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-30" in row 1
And I save the current editor
And I close the current editor


# 11: Teilwertgutschrift 29WGS004
Given I open an editor "29WGS004" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "29RE002"
And I set fields
   | nummer | 29WGS004 |
   | such   | WGS04F29 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-15" in row 1
And I set field "preis" to "3" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "29BE001" in row 1
And I save the current editor


# 12: Ruecklieferschein 29RLS002
Given I open an editor "rueck-29RLS002" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+29LS002"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 29RLS002         |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-15" in row 1
And I save the current editor
And I close the current editor


# 13: Lieferschein 29LS003
Given I open an editor "29LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "29BE001"
And I set fields
   | nummer | 29LS003 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "45" in row 1
And I save the current editor


# 14: Kaufmaennische Gutschrift 29KGS001
Given I open an editor "29KGS001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-29RLS001"
And I set fields
   | nummer | 29KGS001 |
   | such   | KGS29a01 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
# TODO: Fehler? hier wird Gesamtmenge zu 29RLS001 nur -10 St. erlaubt - auf 2 KGS aufgeteilt
# And I set field "mge" to "-20" in row 1
And I set field "mge" to "-5" in row 1
# TODO: 43.75 : 5 = 8,75   Richtig???
Then field "pwert" has value "-43.75" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 15: Kaufmaennische Gutschrift 29KGS002
Given I open an editor "29KGS002" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-29RLS002"
And I set fields
   | nummer | 29KGS002 |
   | such   | KGS29a02 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
# TODO: Fehler? hier wird Gesamtmenge zu 29RLS002 nur -5 St. erlaubt
# And I set field "mge" to "-15" in row 1
And I set field "mge" to "-5" in row 1
# TODO: 43.75 : 5 = 8,75   Richtig???
Then field "pwert" has value "-43.75" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 16: Kaufmaennische Gutschrift 29KGS003
Given I open an editor "29KGS003" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-29RLS001"
And I set fields
   | nummer | 29KGS003 |
   | such   | KGS29a03 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
# TODO: Fehler? hier wird Gesamtmenge zu 29RLS001 nur -10 St. erlaubt - auf 2 KGS aufgeteilt
# And I set field "mge" to "-10" in row 1
And I set field "mge" to "-0" in row 1
# TODO: 43.75 : 5 = 8,75   Richtig???
Then field "pwert" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################

Scenario: Fall_30
# Lieferschein vor 2 Wertgutschriften

#
#  30BE001 -------- 30RE001 -------------- 30WGS001
#  10St. x10EUR     5St.(x11EUR)           2St.(x11EUR)  Auteilung 3/2
#   \
#    \------------------- 30RE002 -------------- 30WGS002
#     \                   5St.(x12EUR)           3St.(x12EUR)  komplett von ZW-Konto
#      \
#       \------------------------- 30LS001
#        \                         3 St.
#         \
#          \-------------------------------------------- 30LS002
#           \                                            7 St.   Zur Zeit (07.02.2025) kommt eine DIAG hier
#
#-- 1 ------------- 2 --- 3 ------ 4 ----- 5 --- 6 ----- 7 ----> Zeitstrahl


# 1: Bestellung
Given I open an editor "30BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 30BE001 |
   | lief    | 001fa30 |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL30 | 10  | Stück | 10,00 |
And I save the current editor


# 2: Rechnung 30RE001
Given I open an editor "30RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "30BE001"
And I set fields
   | nummer | 30RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "5" in row 1
And I set field "preis" to "11" in row 1
Then field "ngeliefertremge" has value "5" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36fall30" in row 1
Then field "vorgangskonto" has value "1ifall30" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "5" in row 1
Then field "zwischenkonto" has value "36fall30" in row 1
Then field "kvnum" has value "30BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 3: Rechnung 30RE002
Given I open an editor "30RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "30BE001"
And I set fields
   | nummer | 30RE002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "5" in row 1
And I set field "preis" to "12" in row 1
Then field "ngeliefertremge" has value "5" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36fall30" in row 1
Then field "vorgangskonto" has value "1ifall30" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "5" in row 1
Then field "zwischenkonto" has value "36fall30" in row 1
Then field "kvnum" has value "30BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 4: Lieferschein 30LS001
Given I open an editor "30LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "30BE001"
And I set fields
   | nummer | 30LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "3" in row 1
And I save the current editor


# 5: Teilwertgutschrift 30WGS001
Given I open an editor "30WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "30RE001"
And I set fields
   | nummer | 30WGS001 |
   | such   | WGS01F30 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-2" in row 1
And I set field "preis" to "11" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "30BE001" in row 1
And I save the current editor


# 6: Teilwertgutschrift 30WGS002
Given I open an editor "30WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "30RE002"
And I set fields
   | nummer | 30WGS002 |
   | such   | WGS02F30 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I set field "preis" to "12" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "30BE001" in row 1
And I save the current editor

# Zur Zeit (07.02.2025) kommt eine DIAG hier
# deswegen auskommentiert
#
# # 7: Lieferschein 30LS002
# Given I open an editor "30LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "30BE001"
# And I set fields
#    | nummer | 30LS002 |
#    | ueb    | ja     |
#    | vom    | .      |
# And I set field "mge" to "7" in row 1
# And I save the current editor
# #######################################################################################

Scenario: Fall_31
# Lieferschein vor 2 Teilwertgutschriften zu einer Rechnung
# weiterer Lieferschein und weitere Wertgutschrift
#
#     /--------------------------------------------------------------------------- 31LS003
#    /                                                                             2St
#   /
#  31BE001 ----- 31RE001 ----------- 31WGS001
#  10St. x10EUR  10St.(x10EUR)       2St.(x10EUR)  Aufteilung 3/7
#   \               \
#    \               \-------------------- 31WGS002
#     \               \                    3St.(x10EUR)  Aufteilung 3/7
#      \               \
#       \               \------------------------------------ 31WGS003 ---- 31WG003S (Storno)
#        \               \                                    3St.(x10EUR)
#         \
#          \--------------- 31LS001
#           \               3St.
#            \
#             \------------------------------------- 31LS002
#              \                                     5St.
#
#-- 1 ---------- 2 -------- 3 ------ 4 --- 5 ------- 6 ------ 7 ----------- 8 ---- 9 ------> Zeitstrahl

# 1: Bestellung
Given I open an editor "31BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 31BE001 |
   | lief    | 001fa31 |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL31 | 10  | Stück | 10,00 |
And I save the current editor


# 2: Rechnung 31RE001
Given I open an editor "31RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "31BE001"
And I set fields
   | nummer | 31RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I set field "preis" to "10" in row 1
Then field "ngeliefertremge" has value "10" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36fall31" in row 1
Then field "vorgangskonto" has value "1ifall31" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "10" in row 1
Then field "zwischenkonto" has value "36fall31" in row 1
Then field "kvnum" has value "31BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein 31LS001
Given I open an editor "31LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "31BE001"
And I set fields
   | nummer | 31LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "3" in row 1
And I save the current editor


# 4: Teilwertgutschrift 31WGS001
Given I open an editor "31WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "31RE001"
And I set fields
   | nummer | 31WGS001 |
   | such   | WGS01F31 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-2" in row 1
And I set field "preis" to "10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "31BE001" in row 1
And I save the current editor


# 5: Teilwertgutschrift 31WGS002
Given I open an editor "31WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "31RE001"
And I set fields
   | nummer | 31WGS002 |
   | such   | WGS02F31 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I set field "preis" to "10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "31BE001" in row 1
And I save the current editor


# 6: Lieferschein 31LS002
Given I open an editor "31LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "31BE001"
And I set fields
   | nummer | 31LS002|
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "5" in row 1
And I save the current editor


# 7: Teilwertgutschrift 31WGS003
Given I open an editor "31WGS003" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "31RE001"
And I set fields
   | nummer | 31WGS003 |
   | such   | WGS03F31 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-10" in row 1
And I set field "preis" to "5" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "31BE001" in row 1
And I save the current editor


# 8: Storno Teilwertgutschrift 31WG003S
Given I open an editor "31WG003S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "31WGS003"
And I set field "nummer" to "31WG003S"
And I save the current editor


# 9: Lieferschein 31LS003
Given I open an editor "31LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "31BE001"
And I set fields
   | nummer | 31LS003 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "2" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_32
# Lieferschein nach Teilwertgutschriften zu einer Rechnung
#
#  32BE001 -------- 32RE001 -------- 32WGS001
#  10St. x 10EUR    10St.(x10EUR)    10St.(x2EUR)   von ZW-Konto
#   \
#    \-------------------------------------- 32LS001
#     \                                      4St.
#      \
#       \---------------------------------------- 32LS002
#        \                                        6St.
#
#
#-- 1 -------------- 2 ------------- 3 ----- 4 -- 5 -----> Zeitstrahl

# 1: Bestellung
Given I open an editor "32BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 32BE001 |
   | lief    | 001fa32 |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL32 | 10  | Stück | 10,00 |
And I save the current editor


# 2: Rechnung 32RE001
Given I open an editor "32RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "32BE001"
And I set fields
   | nummer | 32RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I set field "preis" to "10" in row 1
Then field "ngeliefertremge" has value "10" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36fall32" in row 1
Then field "vorgangskonto" has value "1ifall32" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "10" in row 1
Then field "zwischenkonto" has value "36fall32" in row 1
Then field "kvnum" has value "32BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Teilwertgutschrift 32WGS001
Given I open an editor "32WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "32RE001"
And I set fields
   | nummer | 32WGS001 |
   | such   | WGS01F32 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-10" in row 1
And I set field "preis" to "2" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "32BE001" in row 1
And I save the current editor


# 4: Lieferschein 32LS001
Given I open an editor "32LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "32BE001"
And I set fields
   | nummer | 32LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "4" in row 1
And I save the current editor


# 5: Lieferschein 32LS002
Given I open an editor "32LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "32BE001"
And I set fields
   | nummer | 32LS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "6" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_33
# Lieferschein nach 2 Teilwertgutschriften zu 2 Rechnungen
#
#  33BE001 ------- 33RE001 -------- 33WGS001
#  10St. x10EUR    5St.(x10EUR)     2St.(x10EUR)   alles von ZW-Konto
#    \
#     \----------------- 33RE002---------- 33WGS002
#      \                 5St.(x12EUR)      5St.(x12EUR)   alles von ZW-Konto
#       \
#        \------------------------------------------- 33LS001
#         \                                           10St.
#
#-- 1 ------------ 2 --- 3 -------- 4 ---- 5 -------- 6 ------> Zeitstrahl

# 1: Bestellung
Given I open an editor "33BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 33BE001 |
   | lief    | 001fa33 |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL33 | 10  | Stück | 10,00 |
And I save the current editor


# 2: Rechnung 33RE001
Given I open an editor "33RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "33BE001"
And I set fields
   | nummer | 33RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "5" in row 1
And I set field "preis" to "10" in row 1
Then field "ngeliefertremge" has value "5" in row 1
Then field "konto" has value "36fall33" in row 1
Then field "vorgangskonto" has value "1ifall33" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "5" in row 1
Then field "zwischenkonto" has value "36fall33" in row 1
Then field "kvnum" has value "33BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2: Rechnung 33RE002
Given I open an editor "33RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "33BE001"
And I set fields
   | nummer | 33RE002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "5" in row 1
And I set field "preis" to "12" in row 1
Then field "ngeliefertremge" has value "5" in row 1
Then field "konto" has value "36fall33" in row 1
Then field "vorgangskonto" has value "1ifall33" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "5" in row 1
Then field "zwischenkonto" has value "36fall33" in row 1
Then field "kvnum" has value "33BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 4: Teilwertgutschrift 33WGS001
Given I open an editor "33WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "33RE001"
And I set fields
   | nummer | 33WGS001 |
   | such   | WGS01F33 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-2" in row 1
And I set field "preis" to "10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "33BE001" in row 1
And I save the current editor

# 5: Komplettwertgutschrift 33WGS002
Given I open an editor "33WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "33RE002"
And I set fields
   | nummer | 33WGS002 |
   | such   | WGS02F33 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-5" in row 1
And I set field "preis" to "12" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "ja" in row 1
Then field "kvnum" has value "33BE001" in row 1
And I save the current editor


# 6: Lieferschein 33LS001
Given I open an editor "33LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "33BE001"
And I set fields
   | nummer | 33LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_34
# Lieferschein nach 2 Teilwertgutschriften zu einer Rechnung

#  34BE001 ------- 34RE001 -------- 34WGS001
#  10St. x10EUR    10St.(x10EUR)    2St.(x10EUR)  alles von ZW-Konto
#   \                 \
#    \                 \-------------------- 34WGS002
#     \                 \                    3St.(x10EUR)  alles von ZW-Konto
#      \
#       \----------------------------------------- 34LS001
#        \                                         8St. je 5EUR: korrekt
#         \
#          \------------------------------------------- 34LS002
#           \                                           2St. je 5EUR: korrekt
#
#-- 1 ------------ 2 -------------- 3 ------ 4 --- 5 -- 6 ---> Zeitstrahl

# 1: Bestellung
Given I open an editor "34BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 34BE001 |
   | lief    | 001fa34 |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL34 | 10  | Stück | 10,00 |
And I save the current editor


# 2: Rechnung 34RE001
Given I open an editor "34RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "34BE001"
And I set fields
   | nummer | 34RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I set field "preis" to "10" in row 1
Then field "ngeliefertremge" has value "10" in row 1
Then field "konto" has value "36fall34" in row 1
Then field "vorgangskonto" has value "1ifall34" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "10" in row 1
Then field "zwischenkonto" has value "36fall34" in row 1
Then field "kvnum" has value "34BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Teilwertgutschrift 34WGS001
Given I open an editor "34WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "34RE001"
And I set fields
   | nummer | 34WGS001 |
   | such   | WGS01F34 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-2" in row 1
And I set field "preis" to "10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "34BE001" in row 1
And I save the current editor


# 4: Teilwertgutschrift 34WGS002
Given I open an editor "34WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "34RE001"
And I set fields
   | nummer | 34WGS002 |
   | such   | WGS02F34 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I set field "preis" to "10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "34BE001" in row 1
And I save the current editor


# 5: Lieferschein 34LS001
Given I open an editor "34LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "34BE001"
And I set fields
   | nummer | 34LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "8" in row 1
And I save the current editor


# 6: Lieferschein 34LS002
Given I open an editor "34LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "34BE001"
And I set fields
   | nummer | 34LS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "2" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_35
# 2 Lieferscheine nach 2 Teilwertgutschriften zu einer Rechnung

#  35BE001 ------- 35RE001 ------- 35WGS001
#  10St. x10EUR    10St.(x10EUR)   2St.(x10EUR)    alles von ZW-Konto
#   \                 \
#    \                 \----------------------- 35WGS002
#     \                 \                       3St.(x10EUR)  Aufteilung 5/5
#      \
#       \------------------------------- 35LS002
#        \                               5St.
#         \
#          \------------------------------------------ 35LS002
#           \                                          5St.
#
#-- 1 ------------ 2 ------------- 3 --- 4 ---- 5 ---- 6 ----> Zeitstrahl

# 1: Bestellung
Given I open an editor "35BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 35BE001 |
   | lief    | 001fa35 |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL35 | 10  | Stück | 10,00 |
And I save the current editor


# 2: Rechnung 35RE001
Given I open an editor "35RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "35BE001"
And I set fields
   | nummer | 35RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I set field "preis" to "10" in row 1
Then field "ngeliefertremge" has value "10" in row 1
Then field "konto" has value "36fall35" in row 1
Then field "vorgangskonto" has value "1ifall35" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "10" in row 1
Then field "zwischenkonto" has value "36fall35" in row 1
Then field "kvnum" has value "35BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Teilwertgutschrift 35WGS001
Given I open an editor "35WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "35RE001"
And I set fields
   | nummer | 35WGS001 |
   | such   | WGS01F35 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-2" in row 1
And I set field "preis" to "10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "35BE001" in row 1
And I save the current editor

# 4: Lieferschein 35LS001
Given I open an editor "35LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "35BE001"
And I set fields
   | nummer | 36LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "5" in row 1
And I save the current editor

# 5: Teilwertgutschrift 35WGS002
Given I open an editor "35WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "35RE001"
And I set fields
   | nummer | 35WGS002 |
   | such   | WGS02F35 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I set field "preis" to "10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "35BE001" in row 1
And I save the current editor

# 6: Lieferschein 35LS001
Given I open an editor "35LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "35BE001"
And I set fields
   | nummer | 35LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "5" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_36
# 2 Lieferscheine mit Ueberlieferung nach 2 Teilwertgutschriften zu einer Rechnung

#  36BE001 -------- 36RE001 ------- 36WGS001
#  10St. x10EUR     10St.(x10EUR)   2St.(x10EUR)     Alles von ZW-Konto
#   \                  \
#    \                  \----------------- 36WGS002
#     \                  \                 3St.(x10EUR)     Alles von ZW-Konto
#      \
#       \-------------------------------------- 36LS002
#        \                                      5St.
#         \
#          \-------------------------------------------- 36LS002
#           \                                            8St. (Ueberlieferung) - nur 5St. werden von ZW-Konto weggebucht. Korrekt!
#
#
#-- 1 ------------- 2 ------------- 3 ---- 4 -- 5 ------ 6 ----> Zeitstrahl

# 1: Bestellung
Given I open an editor "36BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 36BE001 |
   | lief    | 001fa36 |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL36 | 10  | Stück | 10,00 |
And I save the current editor


# 2: Rechnung 36RE001
Given I open an editor "36RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "36BE001"
And I set fields
   | nummer | 36RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I set field "preis" to "10" in row 1
Then field "ngeliefertremge" has value "10" in row 1
Then field "konto" has value "36fall36" in row 1
Then field "vorgangskonto" has value "1ifall36" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "10" in row 1
Then field "zwischenkonto" has value "36fall36" in row 1
Then field "kvnum" has value "36BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Teilwertgutschrift 36WGS001
Given I open an editor "36WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "36RE001"
And I set fields
   | nummer | 36WGS001 |
   | such   | WGS01F36 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-2" in row 1
And I set field "preis" to "10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "36BE001" in row 1
And I save the current editor


# 4: Teilwertgutschrift 36WGS002
Given I open an editor "36WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "36RE001"
And I set fields
   | nummer | 36WGS002 |
   | such   | WGS02F36 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-3" in row 1
And I set field "preis" to "10" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "36BE001" in row 1
And I save the current editor

# 5: Lieferschein 36LS001
Given I open an editor "36LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "36BE001"
And I set fields
   | nummer | 36LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "5" in row 1
And I save the current editor

# 6: Lieferschein 36LS002
Given I open an editor "36LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "36BE001"
And I set fields
   | nummer | 36LS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "8" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_37
# 2 Lieferscheine, 2 Wertgutschriften und 2 Rücklieferscheine

#
#  37BE001 -------- 37RE001 -------------- 37WGS001
#  10St. x10EUR     10St.(x11EUR)          10St.(x1EUR)
#   \                 \
#    \                 \--------------------------------------------------------- 37WGS002
#     \                                                                           5St.(x1EUR)
#      \
#       \------------------- 37LS001 -------------------- 37RLS001S
#        \                   7 St.(x11EUR)                5 St.(x10EUR)
#         \
#          \------------------------------------------------------------------------------------ 37RLS001S
#           \                                                                                    2 St.(x9EUR) St.
#            \-------------------------------------------------------- 37LS002
#             \                                                        3 St.
#
#
#-- 1 ------------- 2 ----- 3 ------------ 4 ----------- 5 ----------- 6 -------- 7 ------------ 8 -- > Zeitstrahl


# 1: Bestellung
Given I open an editor "37BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 37BE001 |
   | lief    | 001fa37 |
And I append rows
   | artikel    | mge | he    | preis |
   | EK1-FALL37 | 10  | Stück | 10,00 |
And I save the current editor


# 2: Rechnung 37RE001
Given I open an editor "37RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "37BE001"
And I set fields
   | nummer | 37RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I set field "preis" to "11" in row 1
Then field "ngeliefertremge" has value "10" in row 1
Then field "remehrberechneticon" has value "icon:ball_yellow" in row 1
Then field "konto" has value "36fall37" in row 1
Then field "vorgangskonto" has value "1ifall37" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "zwischenkonto" has value "36fall37" in row 1
Then field "kvnum" has value "37BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 3: Lieferschein 37LS001
Given I open an editor "37LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "37BE001"
And I set fields
   | nummer | 37LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "7" in row 1
And I save the current editor

# 4: Teilwertgutschrift 37WGS001
Given I open an editor "37WGS001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "37RE001"
And I set fields
   | nummer | 37WGS001 |
   | such   | WGS01F37 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-10" in row 1
And I set field "preis" to "1" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "37BE001" in row 1
And I save the current editor

# 5: Ruecklieferschein 37RLS001
Given I open an editor "37RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+37LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 37RLS001         |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-5" in row 1
And I save the current editor

# 6: Lieferschein 37LS002
Given I open an editor "37LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "37BE001"
And I set fields
   | nummer | 37LS002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "3" in row 1
And I save the current editor

# 7: Teilwertgutschrift 37WGS002
Given I open an editor "37WGS002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "37RE001"
And I set fields
   | nummer | 37WGS002 |
   | such   | WGS02F37 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-5" in row 1
And I set field "preis" to "1" in row 1
Then field "wertgutschrift" has value "ja"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "kvnum" has value "37BE001" in row 1
And I save the current editor

# 8: Ruecklieferschein 37RLS002
Given I open an editor "37RLS002" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+37LS002"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 37RLS002         |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-2" in row 1
And I save the current editor
# #######################################################################################
