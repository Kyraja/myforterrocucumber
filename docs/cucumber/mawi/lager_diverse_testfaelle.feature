@persistent
Feature: lager_diverse_testfaelle.feature

# **********************************************************************************
#  Name             : lager_diverse_testfaelle.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : bschiga
#  Funktion         : Diverse einzelne Testfaelle im Bereich Lager
#  Stammdaten       : basis_stammdaten.feature
#
# **********************************************************************************

Background:
Given I set the fake date to "02.01.1995"

# FDA-4147
Scenario: 01 Rundungsdifferenzen bei Beistellteilen lassen korrekte Kleinstmengen an Lager uebrig

Given I open an editor "EK-KT-BEISTELL" from table "(Part):(Product)" with command "STORE" for record "EK-KT-BEISTELL"
And I set fields
    | such     | EK-KT-BEISTELL             |
    | namebspr | Kaufteil mit Beistellung   |
    | bsart    | Fremdbeschaffung           |
And I delete all rows
And I append rows
    | elex          | elanzahl  | bua                       |
    | EK-BEISTELL   | 4,6667    | Lieferantenbeistellung    |
And I save the current editor

Given I set StorageQuantity to zero for Product "EK-BEISTELL" on StorageLocation "F1"

Given I open an editor "BE-01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFER1  |
    | such   | BE-01    |
    | ebeleg | BE-01    |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel       | mge |
    | EK-KT-BEISTELL|  6  |
And I save the current editor

And I run Scheduling

# Bestellvorschlag fuer Beistellteil freigeben
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "EK-BEISTELL"
And I press button "ladetab"
Then field "mge" has value "28" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE-BEI01"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Beistellteil liefern und berechnen
Given I open an editor "LS-BEI01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-BEI01"
And I set fields
   | ebeleg | LS-BEI01  |
   | such   | LS-BEI01  |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "28" in row 1
And I save the current editor

Given I open an editor "RE-BEI01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "LS-BEI01"
And I set fields
   | ebeleg | RE-BEI01  |
   | such   | RE-BEI01  |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "28" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Lieferscheine aus Bestellung des Kaufteils, LS 1 (3 Stück) (im LJ für den Beistellabgang: mge = 14 (3*4,6667=14,0001)
Given I open an editor "LS1-BE-01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-01"
And I set fields
   | ebeleg | LS1-BE-01 |
   | such   | LS1-BE-01 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "3" in row 1
And I save the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-BEISTELL;buarta==Abgang;platz==F1;ebeleg==LS1-BE-01"
Then fields have values
    | artikel       | EK-BEISTELL           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 14                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
And I close the current editor

# LS 2 (1 Stück) im LJ für den Beistellabgang: mge = 4,667 (also 4,6667 gerundet auf 3 Nachkommastellen)
Given I open an editor "LS2-BE-01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-01"
And I set fields
   | ebeleg | LS2-BE-01 |
   | such   | LS2-BE-01 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "1" in row 1
And I save the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-BEISTELL;buarta==Abgang;platz==F1;ebeleg==LS2-BE-01"
Then fields have values
    | artikel       | EK-BEISTELL           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 4.667                 |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
And I close the current editor

# LS 3 (1 Stück) im LJ für den Beistellabgang: mge = 4,667
Given I open an editor "LS3-BE-01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-01"
And I set fields
   | ebeleg | LS3-BE-01 |
   | such   | LS3-BE-01 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "1" in row 1
And I save the current editor

Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-BEISTELL;buarta==Abgang;platz==F1;ebeleg==LS3-BE-01"
Then fields have values
    | artikel       | EK-BEISTELL           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 4.667                 |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
And I close the current editor

# LS 4 (1 Stück) im LJ für den Beistellabgang: mge = 4,667
Given I open an editor "LS4-BE-01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-01"
And I set fields
   | ebeleg | LS4-BE-01 |
   | such   | LS4-BE-01 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "1" in row 1
And I save the current editor

Given I open an editor "JournalAb4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-BEISTELL;buarta==Abgang;platz==F1;ebeleg==LS4-BE-01"
Then fields have values
    | artikel       | EK-BEISTELL           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 4.667                 |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
And I close the current editor

# Platzmengenelement fuer Beistellteil pruefen, es ist eine Kleinstmenge an Lager uebrig geblieben, diese ist aber korrekt
Given I query "artikel,platz,gebmge,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "platz==F1;artikel==EK-BEISTELL"
Then query has values
    | artikel       | platz | gebmge    | bewmge    |
    | EK-BEISTELL   | F1    | -0.001    | -0.001    |
And I close the current editor
