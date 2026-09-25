# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Umlagern.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Umlagerungen mit Behaeltern
#  ref              : ref_behaelter_umlagern_cu
#  Stammdaten       : VERSAND_BEHAELTER_Stammdaten.feature
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Umlagern.feature
Background:
Given I set the fake date to "02.01.1995"

##################################################################################################################

Scenario: 01 Umlagerungsvorschlag direkt umlagern

And I set StorageQuantity to zero for Product "KLINGEL" on StorageLocation "L2F1" with document "Scenario01"
And I set StorageQuantity to zero for Product "KLINGEL" on StorageLocation "F1" with document "Scenario01"

And I create a Container "behaelter_01" for packaging material "KLT"

# Artikel KLINGEL auf Lagergruppe HONGKONG einkaufen
And  I open an editor "EKLS_01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | vom    | .       |
    | ebeleg | EKLS_01 |
    | ueb    | ja      |
And I delete all rows
And I append rows
    | artikel | mge | !dialogId                                     | !dialogAnswer | exbehnum             | platz | verw          |
    | KLINGEL | 1   | Externe Behälternummer ist bereits vergeben. | nein          | !behaelter_01^nummer | L2F1  | Klingel_Um_01 |
And I save the current editor

And I open an editor "behaelter_01" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_01"
Then field "platz" has value "L2F1"
Then table has values
    | artikel | mge | verw          |
    | KLINGEL | 1   | Klingel_Um_01 |
And I close the current editor

# Umlagerungsvorschlag direkt nach Lagergruppe KARLSRUHE umlagern
Given I open an editor "UmVor_01" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I delete all rows
And I append rows
    | artikel | mge | verw          | behaelter        | mfreig |
    | KLINGEL | 1   | Klingel_Um_01 | !behaelter_01^id | ja     |
And I set fields
    | beleg  | Umlagern_01 |
    | beldat | .           |
And I press button "umbuchen" to open a subeditor for "Umbuchung_01"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

And I open an editor "behaelter_01" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_01"
Then field "platz" has value "F1"
Then table has values
    | artikel | mge | verw          |
    | KLINGEL | 1   | Klingel_Um_01 |
And I close the current editor


Scenario: 02 Umlagerung eines Artikels ueber Freigabe des Umlagerungsvorschlags und Einkaufslieferschein

And I set StorageQuantity to zero for Product "KLINGEL" on StorageLocation "L2F1" with document "Scenario02"
And I set StorageQuantity to zero for Product "KLINGEL" on StorageLocation "F1" with document "Scenario02"

# KLINGEL Beschaffung HONGKONG freigeben
Given I open an editor "Auftrag_02" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | vom   | .         |
    | such  | AUFTRAG02 |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | KLINGEL   | 1     |
And I save the current editor

And I run Scheduling

And I open an editor "BestVor_02" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel   | KLINGEL   |
    | lgruppe   |           |
And I press button "ladetab"
And I set field "mfreig" to "JA" in row !lastRow
And I press button "freig" to open a subeditor for "Bestellung02-1"
And I set fields
    | lief  | KETTLER   |
    | such  | BESTELL02 |
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "EKLS_02" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung02-1"
And I set fields
    | vom    | .       |
    | ebeleg | EKLS_02 |
    | ueb    | ja      |
Then field "platz" has value "L2F1" in row 1
And I modify table
    | !row  | mge    | exbehnum             | packm |
    | 1     | 1      | UMLAGERN_KLINGEL_K2  | KLT   |
And I save the current editor

And I open an editor "behaelter_02" from table "(Container):(ContainerShell)" with command "VIEW" for record "UMLAGERN_KLINGEL_K2"
Then field "platz" has value "L2F1"
Then table has values
    | artikel | mge |
    | KLINGEL | 1   |
And I close the current editor

And I run Scheduling

# Umlagerungsvorschlag KLINGEL nach KA freigeben
Given I open an editor "UmVor_02" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel | KLINGEL     |
    | lgruppe |             |
And I press button "ladetab"
And I modify table
    | !row | mge |  mfreig |
    | 1    | 1   |  ja     |
And I press button "freig" to open a subeditor for "Bestellung02-2"
And I set fields
    | lief | KETTLER    |
    | such | Uml_02     |
And I set field "behaelter" to "!behaelter_02^id" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "EKLS_02Uml" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | beleg  | !Bestellung02-2^id   |
    | vom    | .                    |
    | ebeleg | EKLS_02Uml           |
    | ueb    | ja                   |
Then the table has 1 rows
Then field "platz" has value "F1" in row 1
And I modify table
    | !row   | mge  | behaelter         |
    | 1      | 1    | !behaelter_02^id  |
And I save the current editor

And I open an editor "behaelter_02" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_02"
Then field "platz" has value "F1"
Then table has values
    | artikel | mge |
    | KLINGEL | 1   |
And I close the current editor

And I deliver the SalesOrder "Auftrag_02" with PackingSlip "LS-02"


# Umlagern bei unterschiedlichen Dispoarten
Scenario: 03 Umlagerungsartikel DYNAMO anlegen, unterschiedliche Dispoarten in Artikel und Lagergruppeneigenschaften

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "DYNAMO"
And I set fields
    | such      | DYNAMO                |
    | namebspr  | Dynamo fuer Fahrrad   |
    | lief      | KETTLER               |
    | dispoa    | auftragsbezogen       |
    | umllg     | HONGKONG              |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | dispoa                | bsart             |
    | HONGKONG  | bedarfsbezogen        | Fremdbeschaffung  |
And I save the current subeditor to switch back to the parent editor
And I set fields
    | bsart     | Umlagern  |
    | efrist    | 2         |
    | epr       | 12,50     |
And I save the current editor

#And I set StorageQuantity to zero for Product "DYNAMO" on StorageLocation "L2F1" with document "Scenario03"
#And I set StorageQuantity to zero for Product "DYNAMO" on StorageLocation "F1" with document "Scenario03"

# Auftrag, DYNAMO Beschaffung HONGKONG freigeben
Given I open an editor "Auftrag_03" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde     | RADSHOP   |
    | vom       | .         |
And I delete all rows
And I append rows
    | artikel   | mge       | verw      |
    | DYNAMO    | 100       | dyn_03    |
And I save the current editor

And I run Scheduling

And I open an editor "BestVor_03" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel | DYNAMO      |
    | lgruppe |             |
    | vom     | .           |
And I press button "ladetab"
And I modify table
    | !row | mge | mfreig   |
    | 1    | 100 | ja       |
And I press button "freig" to open a subeditor for "Bestellung03-1"
And I set field "lief" to "KETTLER"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

And  I open an editor "EKLS_03" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to "!Bestellung03-1^nummer"
Then the table has 1 rows
Then field "platz" has value "L2F1" in row 1
And I modify table
    | !row | mge | exbehnum             | packm |
    | 1    | 100 | DYNAMO_UMLAGERN_K3   | KLT   |
And I set fields
    | vom    | .        |
    | ebeleg | EKLS_03  |
    | ueb    | ja       |
And I save the current editor

And I open an editor "behaelter_03" from table "(Container):(ContainerShell)" with command "VIEW" for record "DYNAMO_UMLAGERN_K3"
Then field "platz" has value "L2F1"
Then the table has 1 rows
Then table has values
    | artikel | mge | verw  |
    | DYNAMO  | 100 |       |
And I close the current editor

# Umlagerungsvorschlag DYNAMO nach KA freigeben
Given I open an editor "UmVor_03" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel | DYNAMO      |
    | lgruppe |             |
    | vom     | .           |
And I press button "ladetab"
And I modify table
    | !row | mge | mfreig   |
    | 1    | 100 | ja       |
And I press button "freig" to open a subeditor for "Bestellung03-2"
And I set field "lief" to "KETTLER"
And I set field "behaelter" to "DYNAMO_UMLAGERN_K3" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "EKLS_03Uml" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | beleg  | !Bestellung03-2^id   |
    | vom    | .                    |
    | ebeleg | EKLS_03Uml           |
    | ueb    | ja                   |
Then the table has 1 rows
And I modify table
    | !row   | platz    | mge   | behaelter             |
    | 1      | F1       | 100   | DYNAMO_UMLAGERN_K3    |
And I save the current editor

And I open an editor "behaelter_03" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_03"
Then field "platz" has value "F1"
Then the table has 1 rows
Then table has values
    | artikel | mge | verw   |
    | DYNAMO  | 100 | dyn_03 |
And I close the current editor

And I open an editor "VKLS_03" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | beleg   | !Auftrag_03^nummer  |
    | vom     | .                   |
    | ueb     | ja                  |
And I modify table
    | !row    | mge | behaelter         |
    | 1       | 100 | !behaelter_03^id  |
And I save the current editor


Scenario: 04 direktes Umlagern eines Umlagerungsvorschlags, unterschiedliche Dispoarten Artikel und Lagergruppeneigenschaften

And I set StorageQuantity to zero for Product "DYNAMO" on StorageLocation "L2F1" with document "Scenario04"
And I set StorageQuantity to zero for Product "DYNAMO" on StorageLocation "F1" with document "Scenario04"

# Auftrag, DYNAMO Beschaffung HONGKONG freigeben
Given I open an editor "Auftrag_04" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | RADSHOP   |
    | vom   | .         |
And I delete all rows
And I append rows
    | artikel   | mge   | verw      |
    | DYNAMO    | 100   | dyn_04    |
And I save the current editor

And I run Scheduling

And I open an editor "BestVor_04" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel | DYNAMO  |
    | lgruppe |         |
    | vom     | .       |
And I press button "ladetab"
And I modify table
    | !row | mge | mfreig   |
    | 1    | 100 | ja       |
And I press button "freig" to open a subeditor for "Bestellung04"
And I set field "lief" to "KETTLER"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

And  I open an editor "EKLS_04" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to "!Bestellung04^nummer"
Then the table has 1 rows
Then field "platz" has value "L2F1" in row 1
And I modify table
    | !row | mge | exbehnum             | packm |
    | 1    | 100 | DYNAMO_UMLAGERN_K4   | KLT   |
And I set fields
    | vom    | .        |
    | ebeleg | EKLS_04  |
    | ueb    | ja       |
And I save the current editor

And I open an editor "behaelter_04" from table "(Container):(ContainerShell)" with command "VIEW" for record "DYNAMO_UMLAGERN_K4"
Then field "platz" has value "L2F1"
Then the table has 1 rows
Then table has values
    | artikel | mge | verw   |
    | DYNAMO  | 100 |        |
And I close the current editor

# Umlagerungsvorschlag direkt nach Lagergruppe KARLSRUHE umlagern
Given I open an editor "UmVor_04" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel | DYNAMO      |
    | lgruppe |             |
    | vom     | .           |
    | beleg   | Umlagern_04 |
    | beldat  | .           |
And I press button "ladetab"
And I modify table
    | !row    | mge         | behaelter         | mfreig    |
    | 1       | 100         | !behaelter_04^id  | ja        |
And I press button "umbuchen" to open a subeditor for "Umbuchung_01"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

And I open an editor "behaelter_04" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_04"
Then field "platz" has value "F1"
Then the table has 1 rows
Then table has values
    | artikel | mge | verw   |
    | DYNAMO  | 100 | dyn_04 |
And I close the current editor

And I open an editor "VKLS_04" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | beleg   | !Auftrag_04^nummer   |
    | vom     | .                    |
    | ueb     | ja                   |
And I modify table
    | !row | mge | behaelter         |
    | 1    | 100 | !behaelter_04^id  |
And I save the current editor


Scenario: 05 Einen Artikel umlagern ueber Einkaufslieferschein umplatz

And I create a Container "behaelter_05" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "5" on StorageLocation "F1" with document "L05-ZU" and Container "behaelter_05"

And I switch the current editor to editor "behaelter_05"
Then field "platz" has value "F1"
Then the table has 1 rows
And I close the current editor

# Umlagerungslieferschein buchen
Given I open an editor "EKLS_05" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief    | KETTLER |
    | vom     | .       |
    | ebeleg  | EKLS_05 |
    | ueb     | ja      |
    | umplatz | F1      |
And I modify table
    | !row    | artikel | mge | platz | behaelter        |
    | +1      | SATTEL  | 5   | L2F1  | !behaelter_05^id |
And I save the current editor

And I switch the current editor to editor "behaelter_05"
Then field "platz" has value "L2F1"
Then the table has 1 rows
And I close the current editor


Scenario: 06 Einen Artikel umlagern ueber Einkaufslieferschein bsart=Umlagern

And I create a Container "behaelter_06" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "SATTEL" and quantity "5" on StorageLocation "F1" with document "L06-ZU" and Container "behaelter_06"

And I switch the current editor to editor "behaelter_06"
Then field "platz" has value "F1"
Then the table has 1 rows
And I close the current editor

Given I open an editor "EKLS_06" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | KETTLER  |
    | vom       | .        |
    | ebeleg    | EKLS_06  |
    | ueb       | ja       |
    | bsart     | Umlagern |
And I modify table
    | !row | artikel | mge | platz | behaelter        |
    | +1   | SATTEL  | 5   | L2F1  | !behaelter_06^id |
And I save the current editor

And I switch the current editor to editor "behaelter_06"
Then field "platz" has value "L2F1"
Then the table has 1 rows
And I close the current editor
