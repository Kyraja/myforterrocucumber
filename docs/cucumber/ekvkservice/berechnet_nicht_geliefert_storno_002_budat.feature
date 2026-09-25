# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert_storno_002_budat.feature
#  Datum     : 21.02.2025
#  Autor     : wane
#  Verantwortlich : wane
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - STORNO und budat
#
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert"
Background:

Given I set the fake date to "02.01.2002"


Scenario: Fall_25

#
# 25BE001 -- 25RE001
# 100 St.    100 St.
#    \
#     \------------- 25LS001 --- 25SLS001
#      \             100 St.     100 St.
#       \
#        \------------------------------ 25LS002
#         \                              100 St.
#
#-- 1 ------ 2 ----- 3 --------- 4 ----- 5 ------> Zeitstrahl

# 1: Bestellung
Given I open an editor "25BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 25BE001 |
   | lief    | 001fa25 |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL25 | 100 | Stück |
And I save the current editor

Given I set the fake date to "04.01.2002"

# 2: Rechnung
Given I open an editor "25RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "25BE001"
And I set fields
   | nummer | 25RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall25" in row 1
Then field "vorgangskonto" has value "1ifall25" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall25" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "06.01.2002"

# 3: Lieferschein
Given I open an editor "25LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "25BE001"
And I set fields
   | nummer | 25LS001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor


# 3a: Buchungsstorno versuchen
#  Fehler meldung 3537 de      |Storno der Buchung nicht möglich. Bitte Lieferschein stornieren.
Given opening an editor from table "(Entry):(Entry)" with command "REVERSAL" for search criteria "$,,;ursacheref==4 +25LS001;@richtung=rückwärts;@maxtreffer=1" throws the exception "3537"
And I close the current editor

Given I set the fake date to "08.01.2002"

# 4: Lieferschein stornieren
Given I open an editor "ls-storno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+25LS001"
And I set field "num4" to "25SLS001"
And I set field "bem" to "STORNO von LS 25LS001"
Then field "budat" is not modifiable
And I save the current editor

Given I set the fake date to "10.01.2002"

# 5: Buchung zu Storno anschauen
Given I open an editor "Buchung-Storno" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "25SLS001"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 2 rows
Then field "konto" has value "36fall25" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "-2500.00" in row 1
#
Then field "konto" has value "1ifall25" in row 2
And I close the current editor

Given I set the fake date to "12.01.2002"

# 6: Lieferschein -> Rest wird geliefert
Given I open an editor "25LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "25BE001"
And I set fields
   | nummer | 25LS002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "100" in row 1
And I save the current editor


# 7: Buchung anschauen
Given I open an editor "LS-Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "25LS002"
Then field "stornovorlobjekt" is empty
Then the table has 2 rows
Then field "konto" has value "36fall25" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "2500.00" in row 1
#
Then field "konto" has value "1ifall25" in row 2
And I close the current editor
# #######################################################################################

Scenario: Fall_26

#
#      /--- 26LS001 ---- 26RE001
#     /     20 St.       20 St.
#    /
#  26BE001 ------- 26RE002
#  100 St.         35 St.
#    \
#     \-------------------- 26LS002 -------------- 26SLS002
#      \                    50 St.(35 geb.)        50 St.(bucht 50 St.)
#       \
#        \ ------------------------ 26RE003
#         \                         45 St.
#          \
#           \------------------------------ 26LS003
#            \                              30 St.(30 geb.)
#             \
#              \ ----------------------------------------- 26LS004
#               \                                          50 St. (bucht 50 St.): Korrekt
#
#---- 1 --- 2 ---- 3 -- 4 - 5 ----- 6 ----- 7 ---- 8 ----- 9 -----> Zeitstrahl


Given I set the fake date to "01.02.2002"

# 1: Bestellung
Given I open an editor "26BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 26BE001 |
   | lief    | 001fa26 |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL26 | 100 | Stück |
And I save the current editor

Given I set the fake date to "03.02.2002"

# 2: Lieferschein
Given I open an editor "26LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "26BE001"
And I set fields
   | nummer | 26LS001 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "ja"
And I set field "mge" to "20" in row 1
And I save the current editor

Given I set the fake date to "05.02.2002"

# 3: Rechnung 26RE002
Given I open an editor "26RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "26BE001"
And I set fields
   | nummer | 26RE002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "35" in row 1
Then field "ngeliefertremge" has value "35" in row 1
Then field "konto" has value "36fall26" in row 1
Then field "vorgangskonto" has value "1ifall26" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "35" in row 1
Then field "zwischenkonto" has value "36fall26" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "07.02.2002"

# 4: Rechnung 26RE001
Given I open an editor "26RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "26LS001"
And I set fields
   | nummer | 26RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "20" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall26" in row 1
Then field "vorgangskonto" has value "1ifall26" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "07.02.2002"

# 5: Lieferschein
Given I open an editor "26LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "26BE001"
And I set fields
   | nummer | 26LS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "50" in row 1
And I save the current editor

Given I set the fake date to "09.02.2002"

# LS-Buchung anschauen
Given I open an editor "Buchung-001" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "26LS002"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 2 rows
Then field "konto" has value "36fall26" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "910.00" in row 1
#
Then field "konto" has value "1ifall26" in row 2
And I close the current editor

Given I set the fake date to "11.02.2002"

# 6: Rechnung
Given I open an editor "26RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "26BE001"
And I set fields
   | nummer | 26RE003  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "45" in row 1
Then field "ngeliefertremge" has value "30" in row 1
Then field "konto" has value "36fall26" in row 1
Then field "vorgangskonto" has value "1ifall26" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "45" in row 1
Then field "zwischenkonto" has value "36fall26" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "14.02.2002"

# RE-Buchung anschauen
Given I open an editor "Buchung-001" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "26RE003"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 5 rows
Then field "konto" has value "L 001fa26" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "1357.20" in row 1
#
Then field "konto" has value "36fall26" in row 2
Then field "ewsbetr" has value "1170.00" in row 2
Then field "ewhbetr" has value "0.00" in row 2
#
Then field "konto" has value "36fall26" in row 3
Then field "ewsbetr" has value "0.00" in row 3
Then field "ewhbetr" has value "390.00" in row 3
#
Then field "konto" has value "1ifall26" in row 4
Then field "ewsbetr" has value "390.00" in row 4
Then field "ewhbetr" has value "0.00" in row 4
#
Then field "konto" has value "14050" in row 5
Then field "ewsbetr" has value "187.20" in row 5
Then field "ewhbetr" has value "0.00" in row 5
And I close the current editor

Given I set the fake date to "16.02.2002"

# 7: Lieferschein
Given I open an editor "26LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "26BE001"
And I set fields
   | nummer | 26LS003 |
   | ueb    | ja     |
   | vom    | .      |
Then field "fakt" has value "nein"
And I set field "mge" to "30" in row 1
And I save the current editor


# LS-Buchung anschauen
Given I open an editor "Buchung-001" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "26LS003"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 2 rows
Then field "konto" has value "36fall26" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "780.00" in row 1
#
Then field "konto" has value "1ifall26" in row 2
#
And I close the current editor

Given I set the fake date to "18.02.2002"

# 8: Lieferschein stornieren
Given I open an editor "26SLS002" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+26LS002"
And I set field "num4" to "26SLS002"
And I set field "bem" to "STORNO von LS 26LS002"
Then field "budat" is not modifiable
And I save the current editor


# Buchung zu Storno anschauen
# 50 St.(muss 50 buchen!!!)
Given I open an editor "Buchung-Storno" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "26SLS002"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 4 rows
Then field "konto" has value "36fall26" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "-910.00" in row 1
#
Then field "konto" has value "1ifall26" in row 2
#
Then field "konto" has value "36fall26" in row 3
Then field "ewsbetr" has value "0.00" in row 3
Then field "ewhbetr" has value "-390.00" in row 3
#
Then field "konto" has value "1ifall26" in row 4
And I close the current editor

Given I set the fake date to "20.02.2002"

# 9: Lieferschein -> Rest wird geliefert
Given I open an editor "26LS004" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "26BE001"
And I set fields
   | nummer | 26LS004 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "50" in row 1
And I save the current editor


# LS-Buchung anschauen
Given I open an editor "Buchung-001" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "26LS004"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 4 rows
Then field "konto" has value "36fall26" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "910.00" in row 1
#
Then field "konto" has value "1ifall26" in row 2
#
Then field "konto" has value "36fall26" in row 3
Then field "ewsbetr" has value "0.00" in row 3
Then field "ewhbetr" has value "390.00" in row 3
#
Then field "konto" has value "1ifall26" in row 4
And I close the current editor
# #######################################################################################

Scenario: Fall_27

#
#      /--- 27RE001(mit Lagerbewegung)
#     /     20 St.
#    /
#  27BE001 -------- 27LS001(nicht re-relevant) ------ 27SLS001
#  100 St.          5 St.                             5 St. (bucht nicht): Korrekt
#    \
#     \------------------- 27LS002 ----------- 27SLS002
#      \                   20 St.              20 St. (bucht 20St, von Bestand (Haben) auf 36-Konto (Soll)): Korrekt
#       \
#        \ --------------------- 27RE002
#         \                      80 St. (bucht 25 auf Bestand und 55 auf 36-Konto): Korrekt???
#          \
#           \-------------------------- 27LS003
#            \                          55 St. (bucht 55 von 36-Konto auf Bestand): Korrekt
#             \
#              \ --------------------------------------------- 27LS004
#               \                                              25 St.  (bucht 25 St.) -> Fehler!!!! Darf aber nur 20 St. buchen!!! -> 5St zu viel von Zw-Konto abgebucht!!!
#
#---- 1 ----- 2 --- 3 ---- 4 --- 5 ---- 6 ----- 7------ 8 ---- 9 -----> Zeitstrahl


Given I set the fake date to "01.03.2002"

# 1: Bestellung 27BE001
Given I open an editor "27BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 27BE001  |
   | lief    | 001fa27  |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL27 | 100 | Stück |
And I save the current editor


# 2: Rechnung 27RE001
Given I open an editor "27RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "27BE001"
And I set fields
   | nummer | 27RE001 |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | ja      |
And I set field "mge" to "20" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall27" in row 1
Then field "vorgangskonto" has value "1ifall27" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


Given I set the fake date to "04.03.2002"

# 3: Lieferschein 27LS001 (nicht re-relevant)
Given I open an editor "27LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "27BE001"
Then field "fakt" has value "ja"
And I set fields
   | nummer | 27LS001 |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | nein    |
Then field "fakt" has value "nein"
And I set field "mge" to "5" in row 1
And I set field "rerelev" to "nein" in row 1
And I save the current editor

Given I set the fake date to "06.03.2002"

# 4: Lieferschein 27LS002
Given I open an editor "27LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "27BE001"
And I set fields
   | nummer | 27LS002 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "20" in row 1
And I save the current editor

Given I set the fake date to "08.03.2002"

# Rechnung 27RE002
Given I open an editor "27RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "27BE001"
And I set fields
   | nummer | 27RE002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "80" in row 1
Then field "ngeliefertremge" has value "55" in row 1
Then field "konto" has value "36fall27" in row 1
Then field "vorgangskonto" has value "1ifall27" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "80" in row 1
Then field "zwischenkonto" has value "36fall27" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "10.03.2002"

# 5: Lieferschein 27LS003
Given I open an editor "27LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "27BE001"
And I set fields
   | nummer | 27LS003 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "55" in row 1
And I save the current editor

Given I set the fake date to "14.03.2002"

# 6: Lieferschein 27LS002 stornieren
Given I open an editor "27SLS002" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+27LS002"
And I set field "num4" to "27SLS002"
And I set field "bem" to "STORNO von LS 27LS002"
Then field "budat" is not modifiable
And I save the current editor

Given I set the fake date to "16.03.2002"

# 7: Lieferschein 27LS001 stornieren
Given I open an editor "27SLS001" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+27LS001"
And I set field "num4" to "27SLS001"
And I set field "bem" to "STORNO von LS 27LS001"
And I save the current editor

Given I set the fake date to "18.03.2002"

# 8: Lieferschein 27LS004
Given I open an editor "27LS004" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "27BE001"
And I set fields
   | nummer | 27LS004 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "25" in row 1
And I set field "rerelev" to "ja" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_28

#
#      /- 28LS001 ---------------------- 28SLS001
#     /   70 St.                         70 St. (bucht 40St. + 30St.): Korrekt
#    /
#  28BE001 ------ 28RE001
#  100 St.        40 St.
#    \
#     \------------------ 28RE002
#      \                  60 St.
#       \
#        \----------------------- 28LS002
#         \                       30 St.
#          \
#           \ ------------------------------------ 28LS003
#            \                                     70 St. (bucht 30St zu 28RE002 und 40 St zu 28RE001): Korrekt
#
#- 1 ---- 2 ----- 3 ----- 4 ----- 5 ---- 6 ------- 7 ---------> Zeitstrahl


Given I set the fake date to "01.04.2002"

# 1: Bestellung
Given I open an editor "28BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 28BE001 |
   | lief    | 001fa28 |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL28 | 100 | Stück |
And I save the current editor


# 2: Lieferschein
Given I open an editor "28LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "28BE001"
Then field "fakt" has value "ja"
And I set fields
   | nummer | 28LS001 |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | nein    |
Then field "fakt" has value "nein"
And I set field "mge" to "70" in row 1
And I save the current editor

Given I set the fake date to "04.04.2002"

# 3: Rechnung 28RE001
Given I open an editor "28RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "28BE001"
And I set fields
   | nummer | 28RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "40" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall28" in row 1
Then field "vorgangskonto" has value "1ifall28" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "40" in row 1
Then field "zwischenkonto" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "06.04.2002"

# 4: Rechnung 28RE002
Given I open an editor "28RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "28BE001"
And I set fields
   | nummer | 28RE002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "60" in row 1
Then field "ngeliefertremge" has value "30" in row 1
Then field "konto" has value "36fall28" in row 1
Then field "vorgangskonto" has value "1ifall28" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "60" in row 1
Then field "zwischenkonto" has value "36fall28" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "08.04.2002"

# 5: Lieferschein 28LS002
Given I open an editor "28LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "28BE001"
And I set fields
   | nummer | 28LS002 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "30" in row 1
And I save the current editor

Given I set the fake date to "10.04.2002"

# 6: Lieferschein 28LS001 stornieren
Given I open an editor "28SLS001" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+28LS001"
And I set field "num4" to "28SLS001"
And I set field "bem" to "STORNO von LS 28LS001"
Then field "budat" is not modifiable
And I save the current editor

Given I set the fake date to "15.04.2002"

# 7: Lieferschein 28LS003
Given I open an editor "28LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "28BE001"
And I set fields
   | nummer | 28LS003 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "70" in row 1
And I save the current editor
# #######################################################################################




# hier nur bis Fall 39
# #######################################################################################
# ENDE

