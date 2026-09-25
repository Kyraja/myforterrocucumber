@persistent
Feature: Sperrkonfiguration.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Sperrkonfiguration.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Chargen-/Seriennummernverwaltung
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************

Scenario: SP0 Sperrkonfiguration in Aufzaehlung eintragen

Given I open an editor "Aufzaehlung" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "CHSPERRE"
And I set field "reosofort" to "ja"
And I append rows
    | aufzelem  | aeaktiv  |
    | LOT-LOCK  | ja       |
And I save the current editor


Scenario: SP01 Charge sperren - Gesperrte Zugangscharge kann in Rueckmeldebeleg nicht eingetragen werden

Given I create a work order "SP01" for Product "BG01_CHARGE" with quantity "20" and search word "SP01_"

Given I create a Lot "CH1_SP01" for Product "BG01_CHARGE"

# Charge sperren
Given I open an editor "CH1_SP01" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "CH1_SP01"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

# ungebuchte Rueckmeldung mit gesperrter Charge nicht moeglich
Given I open an editor "RM1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SP01_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "gutmge" to "5" in row 1
# Chargen ist mit "Standard-Chargen-SN-Sperre" gesperrt
And I set field "kcharge" to "CH1_SP01"
Then saving the current editor throws the exception "4806"
And I close the current editor

# Charge entsperren
Given I open an editor "CH1_SP01" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "CH1_SP01"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor

# ungebuchte Rueckmeldung auf ersten Arbeitsschein erstellen
Given I open an editor "RM1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SP01_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "kcharge" to "CH1_SP01"
And I set field "gutmge" to "5" in row 1
And I save the current editor

# Charge sperren
Given I open an editor "CH1_SP01" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "CH1_SP01"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

Given I open an editor "RM1_BUCHEN" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record from editor "RM1"
And I set field "sofort" to "ja"
# Chargen ist mit "Standard-Chargen-SN-Sperre" gesperrt
Then saving the current editor throws the exception "4806"
And I close the current editor

# Charge entsperren
Given I open an editor "CH1_SP01" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "CH1_SP01"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor

Given I open an editor "RM1_BUCHEN" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record from editor "RM1"
And I set field "sofort" to "ja"
And I save the current editor

# Charge sperren
Given I open an editor "CH1_SP01" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "CH1_SP01"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

# Rueckbau auf Arbeitsschein mit gesperrter Charge moeglich
Given I open an editor "RB_RM1" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=SP01_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | mzeit   | 2             |
    | bzeit   | 2             |
    | sofort  | ja            |
    | kcharge | !CH1_SP01^id  |
And I set field "gutmge" to "-1" in row 1
And I save the current editor

# Rueckbau stornieren mit gesperrter Charge moeglich
Given I open an editor "RB_RM1_STORNO" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RB_RM1"
And I save the current editor

# Rueckmeldung stornieren mit gesperrter Charge moeglich
Given I open an editor "RM1_STORNO" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM1_BUCHEN"
And I save the current editor


Scenario: SP02 Charge sperren - gesperrte Abgangscharge kann in EntnahmeMZ nicht eingetragen werden

Given I create a work order "SP02" for Product "BG_M_CHARGE" with quantity "10" and search word "SP02_"

Given I create a Lot "SP02_ZU" for Product "BG_M_CHARGE"
Given I create a Lot "SP02_AB1" for Product "EK01_CHARGE"

# Charge sperren
Given I open an editor "SP02_AB1" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP02_AB1"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

# EntnahmeMZ anlegen, gesperrte Abgangscharge kann nicht eingetragen werden, keine zcharge eintragen
Given I open an editor "SP02" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SP02_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   |
    | +1    | F1     | 10       |
Then setting field "charge" to "!SP02_AB1^id" in row 1 throws the exception "4806"
And I set field "tcharge" to "SP02_AB1" in row 1
Then saving the current editor throws the exception "4806"
And I close the current editor
And I switch the current editor to editor "AFL"
And I close the current editor
And I switch the current editor to editor "SP02"
And I close the current editor

# gesperrte Charge kann auch nicht in der FBU in der EntnahmeMZ eingetragen werden
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | SP02_001      |
    | gmgevorschl   | 2             |
    | charge        | !SP02_ZU^id   |
    | bem           | Entnahme      |
And I press button "stlvblad"
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
# Chargen ist mit "Standard-Chargen-SN-Sperre" gesperrt
Then setting field "charge" to "!SP02_AB1^id" in row 1 throws the exception "4806"
And I set field "tcharge" to "SP02_AB1" in row 1
Then saving the current editor throws the exception "4806"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Charge entsperren
Given I open an editor "SP02_AB1" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP02_AB1"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor

# EntnahmeMZ anlegen, Abgangscharge noch nicht gesperrt, keine zcharge eintragen
Given I open an editor "SP02" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SP02_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        |
    | +1    | F1     | 10       | !SP02_AB1^id  |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "SP02"
And I save the current editor

# Charge sperren
Given I open an editor "SP02_AB1" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP02_AB1"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

# FBU Fehlermeldung, weil Charge gesperrt
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | SP02_001      |
    | gmgevorschl   | 2             |
    | charge        | !SP02_ZU^id   |
    | bem           | Entnahme      |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 2     | ja    |
# Chargen-/Seriennummer im Vorgang oder in MZ zum Vorgang ist gesperrt.
Then saving the current editor throws the exception "3669"
And I close the current editor

# Charge entsperren
Given I open an editor "SP02_AB1" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP02_AB1"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor

# FBU jetzt buchen
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | SP02_001  |
    | gmgevorschl   | 2         |
    | bem           | Entnahme  |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 2     | ja    |
And I save the current editor

# Charge sperren
Given I open an editor "SP02_AB1" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP02_AB1"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

# Materialrueckgabe mit gesperrter Charge moeglich
Given I open an editor "Rueckgabe1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | SP02_001  |
    | gmgevorschl   | -1        |
And I press button "stlvblad"
Then table has values
    | bumge | elex          |
    | -1    | EK01_CHARGE   |
And I set field "rescharge" to "!SP02_AB1^id" in row 1
And I save the current editor


Scenario: SP03 Charge sperren - Gesperrte Zugangscharge kann ueber Feld charge im EK-Lieferschein nicht eingetragen werden

Given I create a PurchaseOrder "EKBE_SP03" for Vendor "LIEFCHA2" with Product "EK02_CHARGE" and quantity "10"

Given I create a Lot "SP03_ZU" for Product "EK02_CHARGE"

# Charge sperren
Given I open an editor "SP03_ZU" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP03_ZU"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

# ungebuchter EK-LS mit gesperrter Charge nicht moeglich
Given I open an editor "EKBE_SP03" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBE_SP03"
And I set fields
    | such   | LS_SP03  |
    | num    | 1LS_SP03 |
    | ebeleg | LS1_SP03 |
    | vom    | .        |
And I set field "mge" to "10" in row 1
# Chargen ist mit "Standard-Chargen-SN-Sperre" gesperrt
#Then setting field "charge" to "!SP03_ZU^id" in row 1 throws the exception "4806"
And I set field "tcharge" to "SP03_ZU" in row 1
Then saving the current editor throws the exception "4806"
And I close the current editor

# Charge entsperren
Given I open an editor "SP03_ZU" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP03_ZU"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor

# ungebuchter EK-LS, Charge noch nicht gesperrt
Given I open an editor "EKBE_SP03" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBE_SP03"
And I set fields
    | such   | LS_SP03  |
    | num    | 1LS_SP03 |
    | ebeleg | LS1_SP03 |
    | vom    | .        |
And I set field "mge" to "10" in row 1
And I set field "charge" to "!SP03_ZU^id" in row 1
And I save the current editor

# Charge sperren
Given I open an editor "SP03_ZU" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP03_ZU"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

# EK-LS kann mit gesperrter Charge nicht gebucht werden
Given I open an editor "LS_SP03" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS_SP03"
And I set field "ueb" to "ja"
# Chargen ist mit "Standard-Chargen-SN-Sperre" gesperrt
Then saving the current editor throws the exception "4806"
And I close the current editor

# Charge entsperren
Given I open an editor "SP03_ZU" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP03_ZU"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor

Given I open an editor "LS_SP03" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS_SP03"
And I set field "ueb" to "ja"
And I save the current editor

# Charge sperren
Given I open an editor "SP03_ZU" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP03_ZU"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

# EK-Lieferschein stornieren mit gesperrter Charge moeglich
Given I open an editor "LS_SP03_STORNO" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS_SP03"
And I save the current editor


Scenario: SP04 Charge sperren - gesperrte Abgangscharge kann ueber Feld charge in VK-Lieferschein nicht eingetragen werden

Given  I create a SalesOrder "AUF_SP04" for Customer "KUNDECH1" with Product "EK02_CHARGE" and quantity "10"

Given I create a Lot "SP04_AB" for Product "EK02_CHARGE"

# Charge sperren
Given I open an editor "SP04_AB" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP04_AB"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

# ungebuchter VK-LS mit gesperrter Charge nicht moeglich
Given I open an editor "AUF_SP04" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AUF_SP04"
And I set fields
    | such   | VKLS_SP04    |
    | vom    | .            |
And I set field "mge" to "10" in row 1
    # Chargen ist mit "Standard-Chargen-SN-Sperre" gesperrt
#Then setting field "charge" to "!SP04_AB^id" in row 1 throws the exception "4806"
And I set field "tcharge" to "SP04_AB" in row 1
Then saving the current editor throws the exception "4806"
And I close the current editor

# Charge entsperren
Given I open an editor "SP04_AB" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP04_AB"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor

# ungebuchter VK-LS, Charge noch nicht gesperrt
Given I open an editor "AUF_SP04" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AUF_SP04"
And I set fields
    | such   | VKLS_SP04    |
    | vom    | .            |
And I set field "mge" to "10" in row 1
And I set field "charge" to "!SP04_AB^id" in row 1
And I save the current editor

# Charge sperren
Given I open an editor "SP04_AB" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP04_AB"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

# VK-LS kann mit gesperrter Charge nicht gebucht werden
Given I open an editor "VKLS_SP04" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKLS_SP04"
And I set field "ueb" to "ja"
# Chargen ist mit "Standard-Chargen-SN-Sperre" gesperrt
Then saving the current editor throws the exception "4806"
And I close the current editor

# VK-LS kann mit gesperrter Charge nicht gebucht werden
Given I open an editor "VKLS_SP04" from table "(Sales):(PackingSlip)" with command "TRANSFER" for record "VKLS_SP04"
# Chargen ist mit "Standard-Chargen-SN-Sperre" gesperrt
Then saving the current editor throws the exception "4806"
And I close the current editor

# Charge entsperren
Given I open an editor "SP04_AB" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP04_AB"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor

Given I open an editor "VKLS_SP04" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKLS_SP04"
And I set field "ueb" to "ja"
And I save the current editor

# Charge sperren
Given I open an editor "SP04_AB" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "SP04_AB"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

# VK-Lieferschein stornieren mit gesperrter Charge moeglich
Given I open an editor "VKLS_SP04_STORNO" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "VKLS_SP04"
And I save the current editor


Scenario: SP05 Charge sperren - Manuelle Lagerbuchung mit gesperrter Charge nicht moeglich

Given I create a Lot "CHA_SP05" for Product "EK03_CHARGE"

# Charge sperren
Given I open an editor "CHA_SP05" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "CHA_SP05"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

# manuelle Lagerbuchung Zugang mit gesperrter Charge nicht moeglich
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK03_CHARGE   |
    | buart     | Zugang        |
    | beleg     | LBU_ZU_SP05   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 1      | F1       |
Then setting field "charge2" to "CHA_SP05" in row 1 throws the exception "4806"
And I close the current editor

# Charge entsperren
Given I open an editor "CHA_SP05" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "CHA_SP05"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK03_CHARGE   |
    | buart     | Zugang        |
    | beleg     | LBU_ZU_SP05   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2       |
    | 1      | F1       | !CHA_SP05^id  |
And I save the current editor

# Charge sperren
Given I open an editor "CHA_SP05" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "CHA_SP05"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

# manuelle Lagerbuchung Abgang mit gesperrter Charge nicht moeglich
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK03_CHARGE   |
    | buart     | Abgang        |
    | beleg     | LBU_AB_SP05   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    |
    | 1      | F1       |
Then setting field "charge1" to "CHA_SP05" in row 1 throws the exception "4806"
And I close the current editor

# Charge entsperren
Given I open an editor "CHA_SP05" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "CHA_SP05"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor

Given I open an editor "LBU_05" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK03_CHARGE   |
    | buart     | Abgang        |
    | beleg     | LBU_AB_SP05   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | charge1       |
    | 1      | F1       | !CHA_SP05^id  |
And I save the current editor

# Charge sperren
Given I open an editor "CHA_SP05" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "CHA_SP05"
And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
And I save the current editor

Given I open an editor "LbuchungStorno" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBU_05"
And I set field "beleg" to "LBU05Storno"
And I save the current editor


# Scenario: SP06 Charge sperren - Rueckmeldung mit ZugangsMZ nicht moeglich, wenn in MZ eine gesperrte Charge enthalten ist, Storno RM moeglich
# 
# Given I create a work order "SP06" for Product "BG01_CHARGE" with quantity "20" and search word "SP06_"
# 
# Given I create a Lot "CH_OK_SP06" for Product "BG01_CHARGE"
# Given I create a Lot "CH_SPERR_SP06" for Product "BG01_CHARGE"
# 
# Given I open an editor "BASP06" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SP06_000"
# And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
# And I modify table
#     | !row  | lpsuch | zuomge   | tcharge       |
#     | +1    | F1     | 3        | CH_OK_SP06    |
#     | +2    | F1     | 17       | CH_SPERR_SP06 |
# And I save the current editor
# And I switch the current editor to editor "BASP06"
# And I save the current editor
# 
# # ungebuchte Rueckmeldung auf ersten Arbeitsschein erstellen
# Given I open an editor "RM1_SP06" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SP06_002;@richtung=rückwärts;@maxordtreffer=1"
# And I set field "gutmge" to "5" in row 1
# And I save the current editor
# 
# # Charge sperren
# Given I open an editor "CH_SPERR_SP06" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "CH_SPERR_SP06"
# And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
# And I save the current editor
# 
# Given I open an editor "RM1_SP06_BUCHEN" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record from editor "RM1_SP06"
# And I set field "sofort" to "ja"
# # Chargen-/Seriennummer im Vorgang oder in MZ zum Vorgang ist gesperrt.
# Then saving the current editor throws the exception "3669"
# And I close the current editor
# 
# Given I open an editor "RM1_SP06_BUCHEN" from table "(Workorder):(CompletionConfirmations)" with command "TRANSFER" for record from editor "RM1_SP06"
# # Chargen-/Seriennummer im Vorgang oder in MZ zum Vorgang ist gesperrt.
# Then saving the current editor throws the exception "3669"
# And I close the current editor
# 
# # Charge entsperren
# Given I open an editor "CH_SPERR_SP06" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "CH_SPERR_SP06"
# And I set field "sperrkonfigurationneu" to ""
# And I save the current editor
# 
# Given I open an editor "RM1_SP06_BUCHEN" from table "(Workorder):(CompletionConfirmations)" with command "TRANSFER" for record from editor "RM1_SP06"
# And I save the current editor
# 
# # Charge sperren
# Given I open an editor "CH_SPERR_SP06" from table "(Lots):(Lots)" with command "UPDATE" for record from editor "CH_SPERR_SP06"
# And I set field "sperrkonfigurationneu" to "Standard-Chargen-SN-Sperre"
# And I save the current editor
# 
# # Rueckbau auf Arbeitsschein mit gesperrter Charge moeglich
# # aber keine Chargenangabe in der MZ moeglich und pro Rueckbau nur 1 Zugangscharge, auch wenn Zugangsbuchung ueber MZ fuer 2 Chargen erfolgt ist
# Given I open an editor "RB_RM1" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=SP06_002;@richtung=rückwärts;@maxordtreffer=1"
# And I set fields
#     | mzeit   | 2                   |
#     | bzeit   | 2                   |
#     | sofort  | ja                  |
#     | kcharge | !CH_SPERR_SP06^id   |
# And I set field "gutmge" to "-4" in row 1
# # 1395 Die zurückzubuchende Menge ist größer als die ursprünglich zurückgemeldete Menge.
# Then saving the current editor throws the exception "1395"
# And I set field "gutmge" to "-1" in row 1
# And I save the current editor
# 
# # Rueckbau auf Arbeitsschein
# Given I open an editor "RB2_RM1" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=SP06_002;@richtung=rückwärts;@maxordtreffer=1"
# And I set fields
#     | mzeit   | 2                   |
#     | bzeit   | 2                   |
#     | sofort  | ja                  |
#     | kcharge | !CH_OK_SP06^id      |
# And I set field "gutmge" to "-3" in row 1
# And I save the current editor
# 
# # Rueckbau stornieren mit gesperrter Charge moeglich
# Given I open an editor "RB_RM1_STORNO" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RB_RM1"
# And I save the current editor
# 
# # Rueckbau stornieren mit gesperrter Charge moeglich
# Given I open an editor "RB2_RM1_STORNO" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RB2_RM1"
# And I save the current editor
# 
# # Rueckmeldung stornieren mit gesperrter Charge moeglich
# Given I open an editor "RM1_SP06_STORNO" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM1_SP06_BUCHEN"
# And I save the current editor
