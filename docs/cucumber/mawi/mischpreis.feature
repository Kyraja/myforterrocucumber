@persistent
Feature: mischpreis.feature

# **********************************************************************************
#  Name             : mischpreis.feature
#  Autor            : lschneider
#  Verantwortlich   : ak
#  Kontrolle        : carue
#  Funktion         : Testet das neue Verhalten bei der Mischpreisberechnung
#                     mit Vorgangspreis 0
#
# **********************************************************************************


  Background: 
    And I set the operation language to "Deutsch"
    And I set the fake date to "07.01.95"


  Scenario Outline: Artikel anlegen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>      |
      | namebspr  | <namebspr>  |
      | lief      | <lief>      |
      | efrist    | <efrist>    |
      | vorlauf   | <vorlauf>   |
      | epr       | <epr>       |
    And I delete all rows
    And I append rows
      | elex    | elanzahl    | bua   |
      | <elex>  | <elanzahl>  | <bua> |
    And I save the current editor

  Examples:
    | such      | namebspr                    | lief    | efrist  | vorlauf | epr | elex          | elanzahl  | bua                     |
    | MISCHPR1  | Mischpreis 1                | LIEFER1 | 2       | 2       | 0   |               |           |                         |
    | BEIMISCH1 | Mischpreis mit Beistellung  | K-LIEF  | 3       | 3       | 0   | BEISTELLTEIL  | 1         | Lieferantenbeistellung  |



  Scenario: Fall 1 Bestand=10 mit mpr=0, Zugang=10 mit mpr=10, folgt neuer mpr=5
    Given I set StorageQuantity to zero for Product "MISCHPR1" on StorageLocation "F1" with document "Fall1"
    Given I post a receipt via ManualStockAdjustment for Product "MISCHPR1" and quantity "10" on StorageLocation "F1" with document "mpr1" and price "0"

    Given I post a receipt via ManualStockAdjustment for Product "MISCHPR1" and quantity "10" on StorageLocation "F1" with document "mprneu1" and price "10"

    And I open the infosystem "lj"
    And I set field "beleg" to "mprneu1"
    And I press start
    Then table has values
      | art       | epr      | mpra    | mpr     |
      | MISCHPR1  | 10.0000  | 0.0000  | 5.0000  |
    And I close the current editor


  Scenario: Fall 2 Bestand=10 mit mpr=10, Zugang=10 mit mpr=0, folgt neuer mpr=5
    Given I set StorageQuantity to zero for Product "MISCHPR1" on StorageLocation "F1" with document "Fall2"
    Given I post a receipt via ManualStockAdjustment for Product "MISCHPR1" and quantity "10" on StorageLocation "F1" with document "mpr2" and price "10"

    Given I post a receipt via ManualStockAdjustment for Product "MISCHPR1" and quantity "10" on StorageLocation "F1" with document "mprneu2" and price "0"

    And I open the infosystem "lj"
    And I set field "beleg" to "mprneu2"
    And I press start
    Then table has values
      | art       | epr     | mpra    | mpr     |
      | MISCHPR1  | 0.0000  | 10.0000 | 5.0000  |
    And I close the current editor


  Scenario: Fall 3 Bestand=10 mit mpr=10, Zugang=10 per Lieferschein nicht rechnungsrelevant, folgt neuer mpr=5
    Given I set StorageQuantity to zero for Product "MISCHPR1" on StorageLocation "F1" with document "Fall3"
    Given I post a receipt via ManualStockAdjustment for Product "MISCHPR1" and quantity "10" on StorageLocation "F1" with document "mpr3" and price "10"

    Given I open an editor "LS3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | lief    | LIEFER1 |
      | ebeleg  | LS3     |
      | vom     | .       |
      | ueb     | ja      |
    And I append rows
      | artikel   | mge   | rerelev |
      | MISCHPR1  | 10    | nein    |
    And I save the current editor

    And I open the infosystem "lj"
    And I set field "beleg" to "nummer" from editor "LS3"
    And I press start
    Then table has values
      | art       | epr     | mpra    | mpr     |
      | MISCHPR1  | 0.0000  | 10.0000 | 5.0000  |
    And I close the current editor


  Scenario: Fall 4 Bestand=10 mit mpr=10, Zugang=10 ohne Preis aber mit Beistellung mit mpr=5, folgt neuer mpr=7,5
    # Gemeinkosten im Beistellteil auf 0 setzen
    Given I open an editor "BEISTELLTEIL1" from table "(Part):(Product)" with command "UPDATE" for record "BEISTELLTEIL"
    And I set field "gemein" to "GK0"
    And I save the current editor
    
    # Lagerbestände auf 0 setzen und Lagerzugänge buchen
    Given I set StorageQuantity to zero for Product "BEIMISCH1" on StorageLocation "F1" with document "Fall4"
    Given I set StorageQuantity to zero for Product "BEISTELLTEIL" on StorageLocation "L3F1" with document "Fall4"
    
	Given I post a receipt via ManualStockAdjustment for Product "BEIMISCH1" and quantity "10" on StorageLocation "F1" with document "mpr4" and price "10"
    Given I post a receipt via ManualStockAdjustment for Product "BEISTELLTEIL" and quantity "10" on StorageLocation "L3F1" with document "mprb4" and price "5"

    # Bestellung für BEIMISCH1, Zugang BEISTELLTEIL mpr=5
    Given I create a PurchaseOrder "Bestell4" for Vendor "K-LIEF" with Product "BEIMISCH1" and quantity "10"
    And I run Scheduling

    # Lieferschein BEIMISCH1
    Given I deliver the PurchaseOrder "Bestell4" with PackingSlip "LS4"
    Given I open an editor "Rechnung4" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set field "beleg" to "id" from editor "LS4"
    And I set fields
      | ebeleg  | Rechnung4 |
      | vom     | .         |
      | ueb     | ja        |
    And I modify table
      | !row  | mge | preis |
      | 1     | 10  | 0     |
    And I save the current editor

    And I open the infosystem "lj"
    And I set field "beleg" to "nummer" from editor "Rechnung4"
    And I press start
    Then table has values
       | art           | epr     | mpra    | mpr     |
       | BEIMISCH1     | 0.0000  | 10.0000 | 7.5000  |
    And I close the current editor


  Scenario: Fall 5 Bestand=10 mit mpr=10, Zugang LS=10 mit mpr=0, Abgang=5 mit mpr=10, Rechnung Zugang mpr=0, folgt neuer mpr=3,33
    Given I set StorageQuantity to zero for Product "MISCHPR1" on StorageLocation "F1" with document "Fall5"
    Given I post a receipt via ManualStockAdjustment for Product "MISCHPR1" and quantity "10" on StorageLocation "F1" with document "mpr5" and price "10"

    Given I create a PurchaseOrder "Bestell5" for Vendor "LIEFER1" with Product "MISCHPR1" and quantity "10"
    Given I deliver the PurchaseOrder "Bestell5" with PackingSlip "LS5"

    Given I post an issue via ManualStockAdjustment for Product "MISCHPR1" and quantity "5" on StorageLocation "F1" with document "Abgang5"

    And I open the infosystem "lj"
    And I set field "beleg" to "Abgang5"
    And I press start
    Then table has values
      | art       | epr      | mpra     | mpr     |
      | MISCHPR1  | 10.0000  | 10.0000  | 10.0000 |
    And I close the current editor

    Given I switch the current editor to editor "LS5" with command "INVOICE"
    And I set fields
      | such    | RE5       |
      | ebeleg  | Rechnung5 |
      | vom     | .         |
      | ueb     | ja        |
    And I modify table
    | !row  | mge | preis |
    | 1     | 10  |  0    |
    And I save the current editor

    And I open the infosystem "lj"
    And I set field "beleg" to "nummer" from editor "LS5"
    And I press start
    Then table has values
      | art       | epr     | mpra    | mpr     |
      | MISCHPR1  | 0.0000  | 10.0000 | 3.3333  |
    And I close the current editor



  Scenario: Fall 6 Bestand=10 mit mpr=10, Zugang LS=10 mit mpr=0, Zugang Inventur=10 ohne mpr-Bildung, Rechnung Zugang mpr=0, folgt neuer mpr=6,667
    Given I set StorageQuantity to zero for Product "MISCHPR1" on StorageLocation "F1" with document "Fall6"
    Given I post a receipt via ManualStockAdjustment for Product "MISCHPR1" and quantity "10" on StorageLocation "F1" with document "mpr6" and price "10"

    Given I create a PurchaseOrder "Bestell6" for Vendor "LIEFER1" with Product "MISCHPR1" and quantity "10"
    Given I deliver the PurchaseOrder "Bestell6" with PackingSlip "LS6"

    Given I open an editor "Zaehlliste_MISCHPR1" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
    And I set field "such" to "ZAEHL6"
    And I append rows
      | artikel  | platz    |
      | MISCHPR1 | F1       |
    And I save the current editor

    # Inventur eroeffnen
    Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ZAEHL6" and menu choice "Ja"
    And I save the current editor

    # Zaehlliste bearbeiten
    Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL6"
    #And I respond with answer "@ablage=lebendig;@ordnung=zlsnr,posnr,id;@bereich=ja;.zlsnr=1;end=nein" to the dialog with id ""
    #And I press button "ladeinvo"
    Then the table has 1 rows
    Then I modify table
      | !row | nbest |
      |  1   | 30    |
    And I save the current editor

    # Bestandsabschluss
   Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ZAEHL6" and menu choice "Ja"
    And I save the current editor

    Given I switch the current editor to editor "LS6" with command "INVOICE"
   And I set fields
      | such    | RE6       |
      | ebeleg  | Rechnung6 |
      | vom     | .         |
      | ueb     | ja        |
    And I modify table
      | !row  | mge | preis |
      | 1     | 10  | 0     |
    And I save the current editor

    And I open the infosystem "lj"
    And I set field "beleg" to "nummer" from editor "LS6"
    And I press start
    Then table has values
      | art       | epr     | mpra    | mpr     |
      | MISCHPR1  | 0.0000  | 10.0000 | 6.6667  |
    And I close the current editor


  Scenario: Fall 7 Bestand=10 mit mpr=10, Zugang LS=10 mit mpr=10, Rechnung Zugang mpr=0, folgt neuer mpr=5
    Given I set StorageQuantity to zero for Product "MISCHPR1" on StorageLocation "F1" with document "Fall7"
    Given I post a receipt via ManualStockAdjustment for Product "MISCHPR1" and quantity "10" on StorageLocation "F1" with document "mpr7" and price "10"

    Given I open an editor "LS7" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | such    | LS7     |
      | lief    | LIEFER1 |
      | ebeleg  | LS3     |
      | vom     | .       |
      | ueb     | ja      |
    And I append rows
      | artikel   | mge   | preis  |
      | MISCHPR1  | 10    | 10     |
    And I save the current editor

    Given I switch the current editor to editor "LS7" with command "INVOICE"
    And I set fields
      | such    | RE7       |
      | ebeleg  | Rechnung7 |
      | vom     | .         |
      | budat   | .         |
      | ueb     | ja        |
    And I modify table
      | !row  | mge | preis |
      | 1     | 10  | 0     |
    And I save the current editor

    And I open the infosystem "lj"
    And I set field "beleg" to "nummer" from editor "LS7"
    And I press start
    Then table has values
      | art       | epr     | mpra    | mpr     |
      | MISCHPR1  |  0.0000 | 10.0000 | 5.0000  |
    And I close the current editor


