# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert_storno_003_betrag.feature
#  Datum     : 15.07.2025
#  Autor     : wane
#  Verantwortlich : wane
#  Kontrolle :
#
#  Funktion  : zum Zwischenkonto "Berechnet, nicht geliefert" - Buchungsbetrag bei STORNO einer Rechnung
#
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert"; Buchungsbetrag bei STORNO einer Rechnung
Background:
Given I set the fake date to "02.01.2002"


Scenario: Stammdaten anpassen

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "0efall40"
# hier wird Lagereinheit auf 2 Stk gesetzt
And I set fields
   | ehe  | Paar |
   | epe  | Paar |
And I save the current editor
And I close the current editor


Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "0efall41"
# hier wird Lagereinheit auf 6 Stk gesetzt
And I set fields
   | ehe  | Satz |
   | epe  | Satz |
And I save the current editor
And I close the current editor
# #######################################################################################


Scenario: Fall_40

#
#  40BE001 --- 40RE001 -------- 40SRE001
#  100 St.     100 St.
#    \
#     \--------------- 40LS001
#      \               100 St.
#
#-- 1 -------- 2 ----- 3 ------ 4 ---------> Zeitstrahl

# 1: Bestellung
Given I open an editor "40BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 40BE001 |
   | lief    | 001fa40 |
And I append rows
   | artikel    | mge |
   | EK1-FALL40 | 100 |
And I save the current editor


# 2: Rechnung
Given I open an editor "40RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "40BE001"
And I set fields
   | nummer | 40RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall40" in row 1
Then field "vorgangskonto" has value "1ifall40" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall40" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein
Given I open an editor "40LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "40BE001"
And I set fields
   | nummer | 40LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
And I save the current editor


# 4: Rechnung stornieren
Given I open an editor "re-storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+40RE001"
And I set field "num4" to "40SRE001"
And I set field "bem" to "STORNO von RE 40RE001, kein echtes Storno"
And I save the current editor

# 4a: Buchung zu Storno anschauen
Given I open an editor "Buchung-Storno" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "40SRE001"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "L 001fa40" in row 1
Then field "konto" has value "1ifall40" in row 2
Then field "ewsbetr" has value "-4000.00" in row 2
Then field "ewhbetr" has value "0.00" in row 2
#
Then field "konto" has value "14050" in row 3
And I close the current editor
# #######################################################################################


Scenario: Fall_41

#
#  41BE001 --- 41RE001 --------------- 41SRE001
#  100 St.     100 St.
#    \
#     \--------------- 41LS001
#      \               10 St.
#       \
#        \--------------------- 41LS002
#         \                     40 St.
#
#-- 1 -------- 2 ----- 3 ------ 4 ---- 5 -----> Zeitstrahl

# 1: Bestellung
Given I open an editor "41BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 41BE001 |
   | lief    | 001fa41 |
And I append rows
   | artikel    | mge |
   | EK1-FALL41 | 100 |
And I save the current editor


# 2: Rechnung
Given I open an editor "41RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "41BE001"
And I set fields
   | nummer | 41RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "100" in row 1
Then field "ngeliefertremge" has value "100" in row 1
Then field "konto" has value "36fall41" in row 1
Then field "vorgangskonto" has value "1ifall41" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "100" in row 1
Then field "zwischenkonto" has value "36fall41" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 3: Lieferschein
Given I open an editor "41LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "41BE001"
And I set fields
   | nummer | 41LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I save the current editor


# 4: Lieferschein
Given I open an editor "41LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "41BE001"
And I set fields
   | nummer | 41LS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "40" in row 1
And I save the current editor


# 5: Rechnung stornieren -> 50 Stk sind aktuell geliefert
Given I open an editor "re-storno" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+41RE001"
And I set field "num4" to "41SRE001"
And I set field "bem" to "STORNO von RE 41RE001, kein echtes Storno"
And I save the current editor

# 5a: Buchung zu Storno anschauen
Given I open an editor "Buchung-Storno" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "41SRE001"
Then field "stornovorlobjekt" is empty
Then field "stornoobjekt" is empty
Then the table has 4 rows
Then field "konto" has value "L 001fa41" in row 1
Then field "ewsbetr" has value "0.00" in row 1
Then field "ewhbetr" has value "-4756.00" in row 1
#
Then field "konto" has value "1ifall41" in row 2
# die Haelfte von 4100,00 (Zeile 1 - Steuer aus Zeile 4)
Then field "ewsbetr" has value "-2050.00" in row 2
Then field "ewhbetr" has value "0.00" in row 2
#
Then field "konto" has value "36fall41" in row 3
# die Haelfte von 4100,00 (Zeile 1 - Steuer aus Zeile 4)
Then field "ewsbetr" has value "-2050.00" in row 3
Then field "ewhbetr" has value "0.00" in row 3
#
Then field "konto" has value "14050" in row 4
Then field "ewsbetr" has value "-656.00" in row 4
And I close the current editor
# #######################################################################################



# hier nur bis Fall 44
# #######################################################################################
# ENDE

