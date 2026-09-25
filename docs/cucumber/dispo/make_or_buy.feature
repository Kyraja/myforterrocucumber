@persistent
Feature: make_or_buy.feature



# **********************************************************************************
#  Name             : make_or_buy.feature
#  Autor            : lschneider
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Testet Plausis und Funktionen rund um make or buy or relocate
#
# **********************************************************************************


  Scenario: Vorbereitung - Bestand BF-BEDARF und BG-UNTERBG auf 0 setzen
    Given I set StorageQuantity to zero for Product "BG-BEDARF" on StorageLocation "F1" with document "Zero1"
    Given I set StorageQuantity to zero for Product "BG-AUFTRAG" on StorageLocation "L3F1" with document "Zero1"
    Given I set StorageQuantity to zero for Product "BG-UNTERBG" on StorageLocation "F1" with document "Zero1"



  Scenario: 01 Für Artikel ohne Lagergruppeneigenschaften kann keine bsart=Umlagern gesetzt werden
    Given I open an editor "Auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KUNDE1"
    And I append rows
      | artikel     | mge | bsart             |
      | V1          | 10  | Umlagern          |
    # Fehlertext: Zyklische Struktur bei Beschaffungsart Umlagern
    Then setting field "umllg" to "HONGKONG" in row 1 throws the exception "4284"
    And I close the current editor


  Scenario: 02 Für Artikel mit Entnahmeart über Stückliste kann bsart im Auftrag nicht gesetzt werden
    Given I open an editor "Auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KUNDE1"
    And I append rows
      | artikel     | mge |
      | SETARTIKEL  | 10  |
    Then field "bsart" is empty in row !lastRow
    Then field "bsart" is not modifiable in row !lastRow
    And I close the current editor


  Scenario: 03 bsart bei Lohnfertiung nicht änderbar, bei Baugruppen basart=Lohnfertigung nicht setzbar
    # Auftrag mit bsart=Eigenfertigung anlegen, U-BG auch bsart=Eigenfertiung
    Given I open an editor "Auftrag3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KUNDE1"
    And I append rows
      | artikel     | mge |
      | BG-UNTERBG  | 10  |
      | BG-LOHNFERT | 10  |
    # bsart=Lohnfertigung darf bei Baugruppen nicht gesetzt werden
    # Fehlermeldung: nicht erlaubt
    And I press button "absteig" to open a subeditor for "AFL_1" in row 1
#   Then setting field "elbsart" to "Lohnfertigung" in row 3 throws the exception "2687"
    And I close the current subeditor to switch back to the parent editor
    # Für bsart=Lohnfertigung kann keine andere bsart ausgewählt werden
    And I press button "absteig" to open a subeditor for "AFL_2" in row 2
    Then field "bsart" is not modifiable in row 3
    And I close the current subeditor to switch back to the parent editor

    # Auftragspositionen löschen
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 2
    And I save the current editor
    And I run Scheduling


   Scenario: 04 Für Varianten einer AFL kann bsart nicht mehr geändert werden
    Given I open an editor "Auftrag4" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KUNDE1"
    And I append rows
    | artikel   | mge | verw      |
    | BG-BEDARF | 10  | variante  |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "dispoa" has value "variantenbezogen"
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    Given I open an editor "Reserv1" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=EK1-BEDARF;vor^verw=variante;@richtung=rückwärts;@maxtreffer=1"
    And I modify table
      | !row  | elex    | elanzahl  |
      | +1    | BG1     | 1         |
    Then the table has 4 rows
    And I press button "absteig" to open a subeditor for "ALF_Stufe2" in row 1
    And I close the current editor
    And I switch the current editor to editor "Reserv1"
    Then field "elex" has value "E1" in row 1
    And I set field "elanzahl" to "5" in row 1
    And I press button "aufsteig" to open a subeditor for ""
    And I close the current editor
    And I switch the current editor to editor "Reserv1"
    And I save the current editor

    # Auftragsposition löschen
    And I switch the current editor to editor "Auftrag4" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor
    And I run Scheduling


  Scenario: 05 Für Artikel mit dispoa=variantenbezogen kann nach einem Speichern des Auftrag die bsart nicht mehr geändert werden
    # Artikel mit dispoa=variantenbezogen erstellen
    Given I open an editor "BG-VARIANTE" from table "(Part):(Product)" with command "STORE" for record "BG-VARIANTE"
    And I set fields
      | such      | BG-VARIANTE             |
      | namebspr  | BG, dispoa=variantenbez |
      | dispoa    | variantenbezogen        |
      | bsart     | Eigenfertigung          |
    And I delete all rows
    And I append rows
      | elex        | elanzahl  |
      | E2          | 1         |
      | A AG-LOHN1  | 1         |
    And I save the current editor

    # Auftrag erstellen
    Given I create a SalesOrder "Auftrag5" for Customer "KUNDE1" with Product "BG-VARIANTE" and quantity "10"

    # bsart kann nun im Auftrag nicht mehr geändert werden
    And I switch the current editor to editor "Auftrag5" with command "UPDATE"
    Then field "bsart" is not modifiable in row 1

    # Auftragsposition löschen
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 06 bsart in der Auftragsposition änderbar, AFL passt sich entsprechend an
    Given I create a SalesOrder "Auftrag6" for Customer "KUNDE1" with Product "BG-BEDARF" and quantity "10"

    Given I switch the current editor to editor "Auftrag6" with command "UPDATE"
    Then field "bsart" is empty in row !lastRow
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then the table has 3 rows
    And I close the current subeditor to switch back to the parent editor
    And I set field "bsart" to "Fremdbeschaffung" in row 1
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then the table has 0 rows
    And I close the current subeditor to switch back to the parent editor
    And I set field "bsart" to "Eigenfertigung" in row 1
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then the table has 3 rows
    And I close the current subeditor to switch back to the parent editor
    And I set field "bsart" to "Umlagern" in row 1
    And I set field "umllg" to "BERLIN" in row 1
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then the table has 1 rows
    Then field "lgruppe" has value "BERLIN" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I set field "bsart" to "" in row 1
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then the table has 3 rows
    And I close the current subeditor to switch back to the parent editor

    # Auftragspositionen löschen
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 07 Abhängig von bsart im Auftrag wird Bestellung, Fertigungsvorschlag oder Umlagerung erzeugt
    # Lagerbestand in BERLIN, um Umbuchung daraus zu bedienen
    Given I post a receipt via ManualStockAdjustment for Product "BG-AUFTRAG" and quantity "10" on StorageLocation "L3F1" with document "BER-ZU1"

    # Auftrag mit drei Positionen anlegen
    Given I open an editor "Auftrag7" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KUNDE1"
    And I append rows
      | artikel     | mge | verw    |
      | BG-AUFTRAG  | 10  | Eigenf  |
      | BG-AUFTRAG  | 10  | Fremdb  |
      | BG-AUFTRAG  | 10  | Umlag   |
    And I save the current editor

    # bsart in den drei Positionen unterschiedlich setzen Eigenfertigung, Fremdbeschaffung und Umlagern
    Given I switch the current editor to editor "Auftrag7" with command "UPDATE"
    And I modify table
      | !row  | bsart             | umllg       |
      | 1     | Eigenfertigung    | !dontChange |
      | 2     | Fremdbeschaffung  | !dontChange |
      | 3     | Umlagern          | BERLIN      |
    And I save the current editor

    And I run Scheduling

    # Bestellvorschlag wurde erzeugt
    Given I open an editor "Bestellvorschläge" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BG-AUFTRAG"
    And I press button "ladetab"
    Then the table has 1 rows
    Then field "verw" has value "Fremdb" in row 1
    And I close the current editor

    # Fertigungsvorschlag wurde erzeugt
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BG-AUFTRAG"
    And I press button "ladetab"
    Then the table has 1 rows
    Then field "verw" has value "Eigenf" in row 1
    And I close the current editor

    # Umlagerungsvorschlag wurde erzeugt
    Given I open an editor "Umlagerungsvor" from table "(Purchasing):(RelocationSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BG-AUFTRAG"
    And I press button "ladetab"
    Then the table has 1 rows
    Then table has values
      | verw    | ablgruppe | lgruppe   |
      | Umlag   | BERLIN    | KARLSRUHE |
    And I close the current editor

    # Auftrag  und Lagerbestand Berlin löschen
    Given I switch the current editor to editor "Auftrag7" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 2
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 3
    And I save the current editor

    Given I set StorageQuantity to zero for Product "BG-AUFTRAG" on StorageLocation "L3F1" with document "Zero2"


  Scenario: 08 bsart von Unterbaugruppen kann geändert werden, FV ist freigegeben
    # Auftrag mit bsart=Eigenfertigung anlegen, U-BG auch bsart=Eigenfertiung
    Given I create a SalesOrder "Auftrag8" for Customer "KUNDE1" with Product "BG-UNTERBG" and quantity "10"

    And I run Scheduling

    # FV für Unterbaugruppe freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-BEDARF"
    And I press button "ladetab"
    Then the table has 1 rows
    And I set field "mfreig" to "ja" in row 1
    And I set field "bisuch" to "UBG" in row 1
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "FV_UBG" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "UBG000"
    And I close the current editor

    # neuer wtterm in FV der Unterbaugruppe setzen, dann bsart im Auftrag der Unterbaugruppe auf Fremdbeschaffung ändern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "banummer" to "!FV_UBG^nummer"
    And I press button "ladetab"
    And I set field "wtterm" to "+300" in row 1
    And I save the current editor

    Given I switch the current editor to editor "Auftrag8" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I set field "elbsart" to "Fremdbeschaffung" in row 3
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    And I run Scheduling

    # Für die Unterbaugruppe wurde ein Bestellvorschlag angelegt
    Given I open the infosystem "PLANKARTE"
    And I set field "kart" to "BG-BEDARF"
    And I press start
    Then the table has 4 rows
    Then table has values
      | art         | vart              | vkopf^nummer      |
      |             | Lager             |                   |
      |             | Fremdbeschaffung  |                   |
      | BG-UNTERBG  | Eigenfertigung    |                   |
      |             | Eigenfertigung    | !FV_UBG^nummer    |
    And I close the current editor

    # Auftrag löschen, BA stornieren und FV löschen
    Given I switch the current editor to editor "Auftrag8" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor

    And I run Scheduling

    And I switch the current editor to editor "FV_UBG" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

    Given I switch the current editor to editor "fvor" with command "UPDATE"
    And I set field "netmge" to "0"
    And I save the current editor

# läuft nicht, da Masterabgleich von vers21 noch nicht gemacht wurde
#  Scenario: 09 Für Artikel mit externer lgruppe in Auftragsposition kann bsart=Umlagern gesetzt werden, auch wenn keine Lagergruppeneigenschaften vorhanden sind
#  # Artikel hat Lagergruppeneigenschaften für Berlin (Eigenfertigung)
#    Given I open an editor "Auftrag9" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
#    And I set field "kunde" to "KUNDE1"
#    And I append rows
#      | artikel     | mge | lgruppe   | bsart             | umllg     | verw      |
#      | BG-AUFTRAG  | 10  | HONGKONG  | Umlagern          | KARLSRUHE | KARLSRUHE |
#      | BG-AUFTRAG  | 10  | HONGKONG  | Umlagern          | BERLIN    | BERLIN    |
#    And I save the current editor
#
#    And I run Scheduling
#
#    # FV für Karlsruhe und Berlin
#    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
#    And I set field "artikel" to "BG-AUFTRAG"
#    And I set field "lgruppe" to ""
#    And I press button "ladetab"
#    Then the table has 2 rows
#    Then table has values
#      | artikel     | netmge  | lgruppe   | verw      |
#      | BG-AUFTRAG  | 10      | KARLSRUHE | KARLSRUHE |
#      | BG-AUFTRAG  | 10      | BERLIN    | BERLIN    |
#    And I close the current editor
#
#    # Umlagerungsvorschläge nach Hongkong in Plankarte
#    Given I open the infosystem "PLANKARTE"
#    And I set field "kart" to "BG-AUFTRAG"
#    And I set field "klgruppe" to "HONGKONG"
#    And I press start
#    Then table has values
#      | zugang  | abgang  | art         | lgruppe     | verw      | vart        | vkopf^id      | !row  |
#      | 10      |         |             | KARLSRUHE   | KARLSRUHE | Umlagerung  | (0,0,0)       | 2     |
#      | 10      |         |             | BERLIN      | BERLIN    | Umlagerung  | (0,0,0)       | 3     |
#      |         | 10      | BG-AUFTRAG  |             | KARLSRUHE | Auftrag     | !Auftrag9^id  | 4     |
#      |         | 10      | BG-AUFTRAG  |             | BERLIN    | Auftrag     | !Auftrag9^id  | 5     |
#    And I close the current editor
#
#    # Auftragspositionen löschen
#    Given I switch the current editor to editor "Auftrag9" with command "UPDATE"
#    And I respond with answer "ja" to the dialog with id "191"
#    And I set field "mge" to "0" in row 1
#    And I respond with answer "ja" to the dialog with id "191"
#    And I set field "mge" to "0" in row 2
#    And I save the current editor


  Scenario: 10 Einer geänderten bsart im Auftrag wird ein neuer Beschaffer zugeordnet, wenn kein passender da ist, erster Beschaffer ist freigegeben
    # Auftrag für Baugruppe mit bsart=Eigenfertigung erstellen
    Given I create a SalesOrder "Auftrag10" for Customer "KUNDE1" with Product "BG-BEDARF" and quantity "10"

    And I run Scheduling

    # Betriebsauftrag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-BEDARF"
    And I press button "ladetab"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "BSART" in row !lastRow
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "FV_BSART" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BSART000"
    And I close the current editor

    # neuer wtterm in FV setzen, dann bsart im Auftrag auf Fremdbeschaffung ändern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-BEDARF"
    And I press button "ladetab"
    And I set field "wtterm" to "+300" in row 1
    And I save the current editor

    Given I switch the current editor to editor "Auftrag10" with command "UPDATE"
    And I set field "bsart" to "Fremdbeschaffung" in row 1
    And I save the current editor

    And I run Scheduling

    # Neuer Beschaffer mit bsart=Fremdbeschaffung ist entstanden
    Given I open the infosystem "PLANKARTE"
    And I set field "kart" to "BG-BEDARF"
    And I press start
    Then the table has 4 rows
    Then table has values
      | art       | vart              | vkopf^nummer      |
      |           | Lager             |                   |
      |           | Fremdbeschaffung  |                   |
      | BG-BEDARF | Auftrag           | !Auftrag10^nummer |
      |           | Eigenfertigung    | !FV_BSART^nummer  |
    And I close the current editor

    # Auftrag löschen, BA stornieren und FV löschen
    Given I switch the current editor to editor "Auftrag10" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor

    And I run Scheduling

    And I switch the current editor to editor "FV_BSART" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

    Given I switch the current editor to editor "fvor" with command "UPDATE"
    And I set field "netmge" to "0"
    And I save the current editor


  Scenario: 11 Einer geänderten bsart im Auftrag wird kein neuer Beschaffer zugeordnet, wenn ein passender da ist, hier Lagerbestand
    # Auftrag für Baugruppe mit bsart=Eigenfertigung erstellen
    Given I create a SalesOrder "Auftrag11" for Customer "KUNDE1" with Product "BG-BEDARF" and quantity "10"

    And I run Scheduling

    # Betriebsauftrag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-BEDARF"
    And I press button "ladetab"
    And I set field "mfreig" to "ja" in row 1
    And I set field "bisuch" to "LAGE" in row 1
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "FV_LAGE" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "LAGE000"
    And I close the current editor

    # neuer wtterm in FV setzen, dann bsart im Auftrag auf Fremdbeschaffung ändern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-BEDARF"
    And I press button "ladetab"
    And I set field "wtterm" to "+300" in row 1
    And I save the current editor

    Given I switch the current editor to editor "Auftrag11" with command "UPDATE"
    And I set field "bsart" to "Fremdbeschaffung" in row 1
    And I save the current editor

    # Lagerbestand für BG-BEDARF zubuchen
    Given I post a receipt via ManualStockAdjustment for Product "BG-BEDARF" and quantity "10" on StorageLocation "F1" with document "Zu11"

    And I run Scheduling

    # Kein neuer Beschaffer, Bedarf bedient sich aus Lagerbestand
    Given I open the infosystem "PLANKARTE"
    And I set field "kart" to "BG-BEDARF"
    And I press start
    Then the table has 3 rows
    Then table has values
      | art       | vart              | vkopf^nummer        | verfueg |
      |           | Lager             |                     | 10      |
      | BG-BEDARF | Auftrag           | !Auftrag11^nummer   | 0       |
      |           | Eigenfertigung    | !FV_LAGE^nummer     | 10      |
    And I close the current editor

    # Auftrag liefern, BA löschen
    And I deliver the SalesOrder "Auftrag11" with PackingSlip "LAUF66"

    And I switch the current editor to editor "FV_LAGE" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"


Scenario: 12 elbsart in IS BSTATUS fuer Setartikelkomponenten aendern

# Setartikel erstellen
Given I open an editor "SETKOMP" from table "(Part):(Product)" with command "STORE" for record "SETKOMP"
And I set fields
    | such      | SETKOMP         |
    | namebspr  | Setkomponente   |
And I save the current editor

Given I open an editor "TAUSCHSET" from table "(Part):(Product)" with command "STORE" for record "TAUSCHSET"
And I set fields
    | such      | TAUSCHSET       |
    | namebspr  | TAUSCHSET       |
    | dispoa    | bedarfsbezogen  |
    | bsart     | Eigenfertigung  |
    | earta     | über Stückliste |
And I delete all rows
And I append rows
    | elex          | anzahl    |
    | BG-BEDARF     | 1         |
    | SETKOMP       | 1         |
And I save the current editor

Given I create a SalesOrder "AUFTR_SET" for Customer "KUNDE1" with Product "TAUSCHSET" and quantity "10"

And I run Scheduling

Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "AUFTR_SET"
Then the table has 5 rows
Then field "elem" has value "SETKOMP" in row 1
Then field "elbsart" has value "" in row 1
And I set field "elbsart" to "Eigenfertigung" in row 1
And I press button "ersetzen" in row 1
And I save the current editor

Given I switch the current editor to editor "AUFTR_SET"
Then field "bsart" is not modifiable in row 1
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then field "elbsart" has value "" in row 1
Then field "elbsart" has value "Eigenfertigung" in row 2
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "AUFTR_SET"
Then field "elem" has value "SETKOMP" in row 1
Then field "elbsart" has value "Eigenfertigung" in row 1
And I set field "elbsart" to "Fremdbeschaffung" in row 1
And I press button "ersetzen" in row 1
Then field "elem" has value "BG-BEDARF" in row 2
Then field "elbsart" has value "" in row 2
And I set field "elbsart" to "Fremdbeschaffung" in row 2
And I press button "ersetzen" in row 2
And I save the current editor

Given I switch the current editor to editor "AUFTR_SET"
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then field "elbsart" has value "Fremdbeschaffung" in row 1
Then field "elbsart" has value "Fremdbeschaffung" in row 2
And I close the current subeditor to switch back to the parent editor
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I save the current editor


Scenario: 13 elbsart in IS BSTATUS fuer Komponenten aendern, mehrstufig

Given I create a SalesOrder "AUFTR_VK1" for Customer "KUNDE1" with Product "BG-UNTERBG" and quantity "10"

And I run Scheduling

Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "AUFTR_VK1"
Then the table has 8 rows
Then table has values
    | !row  | elem          | elbsart           |
    | 1     | BG-UNTERBG    |                   |
    | 3     | BG-BEDARF     |                   |
    | 6     | EK1-BEDARF    |                   |
    | 8     | EK2-BEDARF    |                   |
And I set field "elbsart" to "Fremdbeschaffung" in row 3
And I press button "ersetzen" in row 3
And I save the current editor

Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "AUFTR_VK1"
Then the table has 8 rows
Then table has values
    | !row  | elem          | elbsart           |
    | 1     | BG-UNTERBG    |                   |
    | 3     | BG-BEDARF     | Fremdbeschaffung  |
And I set field "elbsart" to "Eigenfertigung" in row 6
And I press button "ersetzen" in row 6
And I save the current editor

Given I switch the current editor to editor "AUFTR_VK1"
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then table has values
    | !row  | elem          | elbsart           |
    | 1     | EK2-BEDARF    |                   |
    | 3     | BG-BEDARF     | Fremdbeschaffung  |
And I close the current subeditor to switch back to the parent editor
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I save the current editor
