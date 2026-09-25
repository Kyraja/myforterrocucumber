# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert_edit_001_budat.feature
#  Datum     : 28.06.2025
#  Autor     : wane
#  Verantwortlich : wane
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - EDIT: budat
#
#
#             Testfaelle bis Fall_08 moeglich
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert"
Background:

Given I set the fake date to "02.01.2002"


Scenario: Fall_01

#
# 01BE001 -- 01RE001
# 100 St.    100 St.
#    \
#
#-- 1 ------ 2 ----------> Zeitstrahl

# 1: Bestellung
Given I open an editor "01BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 01BE001 |
   | lief    | 001fa1  |
And I append rows
   | artikel    | mge |
   | EK1-FALL1 | 100 |
And I save the current editor

Given I set the fake date to "04.01.2002"

# 2: Rechnung
Given I open an editor "01RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "01BE001"
And I set fields
   | nummer | 01RE001 |
   | ueb    | ja      |
   | vom    | .       |
#
Then field "budat" has value "04.01.02"
#
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall1" in row 1
Then field "vorgangskonto" has value "1ifall1" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall1" in row 1
#
And I set field "budat" to "05.01.2002"
#
# nichts darf sich aendern!!!
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall1" in row 1
Then field "vorgangskonto" has value "1ifall1" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall1" in row 1
#
And I set field "budat" to "05.02.2002"
#
# nichts darf sich aendern!!!
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall1" in row 1
Then field "vorgangskonto" has value "1ifall1" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall1" in row 1
#
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
# #######################################################################################

Scenario: Fall_02

#
#  02BE001 --- 02LS001 ---- 02RE001
#  100 St.     20 St.       20 St.
#
#---- 1 ------ 2 ---------- 3 -----------> Zeitstrahl


Given I set the fake date to "01.02.2002"

# 1: Bestellung
Given I open an editor "02BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 02BE001 |
   | lief    | 001fa2  |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL2 | 100 | Stück |
And I save the current editor

Given I set the fake date to "03.02.2002"

# 2: Lieferschein
Given I open an editor "02LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "02BE001"
And I set fields
   | nummer | 02LS001 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "ja"
And I set field "mge" to "20" in row 1
And I save the current editor

Given I set the fake date to "05.02.2002"

# 3: Rechnung 02RE001
Given I open an editor "02RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "02LS001"
And I set fields
   | nummer | 02RE001 |
   | ueb    | ja      |
   | vom    | .       |
#
Then field "budat" has value "05.02.02"
#
And I set field "mge" to "20" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall2" in row 1
Then field "vorgangskonto" has value "1ifall2" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "" in row 1
#
And I set field "budat" to "08.02.2002"
#
# nichts darf sich aendern!!!
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall2" in row 1
Then field "vorgangskonto" has value "1ifall2" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "20" in row 1
Then field "zwischenkonto" has value "" in row 1
#
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
# #######################################################################################

