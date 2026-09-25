# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert_ruecklieferung_002_budat.feature
#  Datum     : 21.02.2025
#  Autor     : wane
#  Verantwortlich : wane
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - Ruecklieferung und budat
#              Das budat ist fuer EK LS/RLS schreibgeschuetzt und wird automatisch beim Buchen auf das
#              aktuelle Tagesdatum gesetzt.
#
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert", Bezug auf "budat"
Background:
Given I set the fake date to "02.01.2002"

Scenario: Stammdaten

# zur Zeit leer -> kann man entfernen



Scenario: Fall_25

#
#  25BE001 -- 25RE001
#  200 St.    200 St.
#    \
#     \------------- 25LS001 --- 25RLS001 --- 25SRLS01
#      \             200 St.     50 St.       50 St.
#
#--- 1 ------ 2 ---- 3 --------- 4 ---------- 5 ------> Zeitstrahl


# 1: Bestellung
Given I open an editor "25BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 25BE001 |
   | lief    | 001fa25 |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL25 | 200 | Stück |
And I save the current editor


Given I set the fake date to "03.01.2002"

# 2: Rechnung
Given I open an editor "25RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "25BE001"
And I set fields
   | nummer | 25RE001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "200" in row 1
Then field "ngeliefertremge" has value "200" in row 1
Then field "konto" has value "36fall25" in row 1
Then field "vorgangskonto" has value "1ifall25" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "200" in row 1
Then field "zwischenkonto" has value "36fall25" in row 1
Then field "kvnum" has value "25BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "05.01.2002"

# 3: Lieferschein
Given I open an editor "25LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "25BE001"
And I set fields
   | nummer | 25LS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "200" in row 1
And I save the current editor

Given I set the fake date to "06.01.2002"

# 4: Ruecklieferschein 25RLS001
Given I open an editor "rueck-25RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+25LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 25RLS001         |
   | rueckligrund | Transportschaden |
   | vom          | .                |
And I set field "mge" to "-50" in row 1
And I save the current editor

Given I set the fake date to "07.01.2002"

Given I open an editor "rueck-25RLS001U" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "rueck-25RLS001"
Then field "budat" has value "06.01.02"
Then field "budat" is not modifiable
And I set fields
   | ueb          | ja               |
# budat auf Tagesdatum setzen
Then field "budat" has value "07.01.02"
And I save the current editor

Given I open an editor "rueck-25RLS001V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "rueck-25RLS001"
# auch nach dem Buchen/Speichern
Then field "budat" has value "07.01.02"
And I close the current editor

Given I set the fake date to "10.01.2002"

# 5: Ruecklieferschein stornieren
Given I open an editor "rls-storno-25SRLS01" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "25RLS001"
And I set field "num4" to "25SRLS01"
And I set field "bem" to "STORNO von RLS 25RLS001"
And I save the current editor
# #######################################################################################

Scenario: Fall_26

#
#  26BE001 ---26RE001 (mit LB) --- 26RLS001 (rerelev=nein)
#  200 St.    200 St.              50 St.
#    \
#     \------------------------------------- 26LS002 (Ersatzlieferung)
#      \                                     50 St.                   -> bucht nicht!!! Bleibt so!
#
#--- 1 ------ 2 ------------------ 3 ------- 4 -------> Zeitstrahl

Given I set the fake date to "10.01.2002"

# 1: Bestellung
Given I open an editor "26BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 26BE001 |
   | lief    | 001fa26 |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL26 | 200 | Stück |
And I save the current editor

Given I set the fake date to "11.01.2002"


# 2: Rechnung mit Lagerbewegung
Given I open an editor "26RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "26BE001"
And I set fields
   | nummer | 26RE001 |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | ja      |
And I set field "mge" to "200" in row 1
Then field "ngeliefertremge" has value "0" in row 1
Then field "konto" has value "1ifall26" in row 1
Then field "vorgangskonto" has value "1ifall26" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "200" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "kvnum" has value "" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "12.01.2002"

# 3: Ruecklieferschein 26RLS001
Given I open an editor "rueck-26RLS001" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+26RE001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 26RLS001         |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-50" in row 1
# fuer Ersatzlieferung
And I set field "rerelev" to "nein" in row 1
And I save the current editor
And I close the current editor

Given I set the fake date to "14.01.2002"

Given I open an editor "rueck-26RLS001-VIEW" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+26RLS001"
Then field "partnervorgang" is empty
# weil Rechnungsrelevant = nein, wird keine Rechnungsbuchung erstellt
Then field "rebu" is empty
And I close the current editor

Given I set the fake date to "16.01.2002"

# 4: Lieferschein: Ersatzlieferung
Given I open an editor "26LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "26BE001"
And I set fields
   | nummer | 26LS002 |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | nein    |
And I set field "mge" to "50" in row 1
And I set field "rerelev" to "nein" in row 1
And I save the current editor
# #######################################################################################

Scenario: Fall_27

#
#     /- 27RE001 -------------------------- 27SRE001
#    /   120 St.                            120 St.
#   /
#  27BE001---- 27LS001---------- 27RLS001 -------------------- 27KGS001
#  200 St.     150 St.           110 St.                       110 St.
#   \
#    \-------------- 27RE002
#     \              80 St.
#      \
#       \----------------- 27LS002
#        \                 50 St.
#         \
#          \---------------------------------------- 27RE003
#           \                                        120 St.
#
#-- 1 -- 2 --- 3 --- 4 --- 5 --- 6 -------- 7 ------ 8 ------- 9 ---> Zeitstrahl


Given I set the fake date to "01.02.2002"

# 1: Bestellung
Given I open an editor "27BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 27BE001 |
   | lief    | 001fa27 |
And I append rows
   | artikel    | mge | he    |
   | EK1-FALL27 | 200 | Stück |
And I save the current editor


# 2: Rechnung
Given I open an editor "27RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "27BE001"
And I set fields
   | nummer | 27RE001 |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | nein    |
And I set field "mge" to "120" in row 1
Then field "ngeliefertremge" has value "120" in row 1
Then field "konto" has value "36fall27" in row 1
Then field "vorgangskonto" has value "1ifall27" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "120" in row 1
Then field "zwischenkonto" has value "36fall27" in row 1
Then field "kvnum" has value "27BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "04.02.2002"

# 3: Lieferschein 27LS001
Given I open an editor "27LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "27BE001"
And I set fields
   | nummer | 27LS001 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "150" in row 1
And I save the current editor

Given I set the fake date to "06.02.2002"

# 4: Rechnung
Given I open an editor "27RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "27BE001"
And I set fields
   | nummer | 27RE002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "80" in row 1
Then field "ngeliefertremge" has value "50" in row 1
Then field "konto" has value "36fall27" in row 1
Then field "vorgangskonto" has value "1ifall27" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "80" in row 1
Then field "zwischenkonto" has value "36fall27" in row 1
Then field "kvnum" has value "27BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "06.02.2002"

# 5: Lieferschein 27LS002
Given I open an editor "27LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "27BE001"
And I set fields
   | nummer | 27LS002 |
   | ueb    | ja      |
   | vom    | .       |
Then field "fakt" has value "nein"
And I set field "mge" to "50" in row 1
And I save the current editor

Given I set the fake date to "08.02.2002"

# 6: Ruecklieferschein 27RLS001
Given I open an editor "rueck-27RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+27LS001"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "fakt" has value "ja"
And I set fields
   | nummer       | 27RLS001         |
   | rueckligrund | Transportschaden |
   | vom          | .                |
   | ueb          | ja               |
And I set field "mge" to "-110" in row 1
Then field "rerelev" has value "ja" in row 1
And I save the current editor
And I close the current editor

Given I set the fake date to "10.02.2002"

# 7: Rechnung stornieren
Given I open an editor "27SRE001" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+27RE001"
And I set field "num4" to "27SRE001"
And I set field "bem" to "STORNO von RE 27RE001"
And I save the current editor

Given I set the fake date to "12.02.2002"

# 8: Rechnung
Given I open an editor "27RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "27BE001"
And I set fields
   | nummer | 27RE003 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "120" in row 1
Then field "ngeliefertremge" has value "110" in row 1
Then field "konto" has value "36fall27" in row 1
Then field "vorgangskonto" has value "1ifall27" in row 1
Then field "fixvorgangskonto" has value "nein" in row 1
Then field "mge" has value "120" in row 1
Then field "zwischenkonto" has value "36fall27" in row 1
Then field "kvnum" has value "27BE001" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "20.02.2002"

# 9: Kaufmaennische Gutschrift 27KGS001
Given I open an editor "27KGS001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rueck-27RLS001"
And I set fields
   | nummer | 27KGS001 |
   | such   | KGS3a001 |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
And I set field "mge" to "-110" in row 1
Then field "pwert" has value "-2970.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# #######################################################################################




# #######################################################################################

