@persistent
Feature: versionen_in afl_tauschen.feature

# **********************************************************************************
#  Name             : versionen_in_afl_tauschen.feature
#  Autor            : lschneider
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Testet das Tauschen von Versionen eines Basisartikels in
#                     Auftragsfertigungslisten.
#
# **********************************************************************************

  # Stammdaten fuer den weiteren Testverlauf anlegen

  Scenario: Artikel mit bsart=Umlagern aus Hongkong, dort bsart=Fremdbeschaffung
    Given I open an editor "LGR-EXTERN" from table "(Part):(Product)" with command "STORE" for record "LGR-EXTERN"
    And I set fields
    | such      | LGR-EXTERN                      |
    | namebspr  | bsart=Umlagern aus externer Lgr |
    | dispoa    | auftragsbezogen                 |
    | umllg     | HONGKONG                        |
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I delete all rows
    And I append rows
    | lgruppe   | dispoa          | bsart             | zuplatz | abplatz |
    | HONGKONG  | auftragsbezogen | Fremdbeschaffung  | L2F1    | L2F1    |
    And I save the current subeditor to switch back to the parent editor
    And I set field "bsart" to "Umlagern"
    And I save the current editor

  Scenario Outline: Fremdbeschaffte Artikel, verschiedene Parameter gesetzt
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such        | <such>            |
      | namebspr    | <namebspr>        |
      | dispoa      | <dispoa>          |
      | bsart       | Fremdbeschaffung  |
      | abplatz     | <abplatz>         |
      | gemein      | GK2.14.3          |
      | ekbewverf   | 6                 |
      | wgruppe     | WG-RHB            |
      | erlgrp      | PG-UE             |
      | flme        | <flme>            |
      | fbme        | <fbme>            |
    And I save the current editor
    Examples:
      | such        | namebspr               | dispoa          | abplatz     | flme        | fbme        |
      | EK3-AUFTRAG | EK3-AUFTRAG            | auftragsbezogen | !dontChange | !dontChange | !dontChange |
      | EK4-AUFTRAG | EK4-AUFTRAG            | auftragsbezogen | !dontChange | !dontChange | !dontChange |
      | EK-ABGANG   | EK-ABGANG              | auftragsbezogen | F3          | !dontChange | !dontChange |
      | UMRECHNUNG1 | Umrechnung Fertigung 1 | bedarfsbezogen  | !dontChange | 10          | 10          |
      | UMRECHNUNG2 | Umrechnung Fertigung 2 | bedarfsbezogen  | !dontChange | 20          | 20          |

  Scenario: Basisartikel mit Versionen mit unterschiedlichen Eigenschaften
    Given I open an editor "BASISVERS" from table "(Part):(BaseProduct)" with command "STORE" for record "BASISVERS"
    And I set field "such" to "BASISVERS"
    And I delete all rows
    And I append rows
      | tversion        | tstdvers  | tindex |
      | EK1-BEDARF      | ja        | VN1    |
      | EK2-BEDARF      |           | VN2    |
      | EK1-AUFTRAG     |           | VN3    |
      | EK-AUSLAUF      |           | VN4    |
      | EK-ABGANG       |           | VN5    |
      | BG-BEDARF       |           | VN6    |
      | LGR-EXTERN      |           | VN7    |
    And I save the current editor

  Scenario: Basisartikel mit auftragsbezogenen Versionen
    Given I open an editor "BASISAUF" from table "(Part):(BaseProduct)" with command "STORE" for record "BASISAUF"
    And I set field "such" to "BASISAUF"
    And I delete all rows
    And I append rows
      | tversion        | tstdvers  | tindex |
      | EK3-AUFTRAG     | ja        | VN1    |
      | EK4-AUFTRAG     |           | VN2    |
    And I save the current editor

  Scenario: Basisartikel mit Versionen mit Umrechnung Fertigung
    Given I open an editor "UMRECHNUNG" from table "(Part):(BaseProduct)" with command "STORE" for record "UMRECHNUNG"
    And I set field "such" to "UMRECHNUNG"
    And I delete all rows
    And I append rows
      | tversion        | tstdvers  | tindex |
      | UMRECHNUNG1     | ja        | VN1    |
      | UMRECHNUNG2     |           | VN2    |
    And I save the current editor

  Scenario Outline: Baugruppen mit Basisartikel oder Version des Basisartikels in Stueckliste, Parameter in Fertigungsliste gesetzt
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>            |
      | namebspr  | <namebspr>        |
      | dispoa    | <dispoa>          |
      | bsart     | Eigenfertigung    |
    And I delete all rows
    And I append rows
      | tbasisartikel     | elex      | elanzahl    | amge      | pverlust    | nutzen    | lge     | breite    |
      | <tbasisartikel1>  | <elex1>   | <elanzahl1> | <amge1>   | <pverlust1> | <nutzen1> | <lge1>  | <breite1> |
      |                   | <elex2>   | <elanzahl2> |           |             |           |         |           |
      |                   | <elex3>   |  1          |           |             |           |         |           |
      |                   | <elex4>   |  1          |           |             |           |         |           |
    And I save the current editor

    Examples:
    | such        | namebspr                | dispoa          | tbasisartikel1  | elex1       | elanzahl1 | amge1 | pverlust1 | nutzen1 | lge1        | breite1     | elex2 | elanzahl2 | elex3       | elex4       |
    | BG-BASIS    | Basisartikel in FL      | bedarfsbezogen  | BASISVERS       |             | 1         | 2     | 10        | 2       | !dontChange | !dontChange | E2    | 1         | A AG-LOHN1  | A AG-LOHN2  |
    | BG-VERSION  | Version in FL           | bedarfsbezogen  | BASISVERS       | EK1-BEDARF  | 1         | 2     | 10        | 2       | !dontChange | !dontChange | E2    | 1         | A AG-LOHN1  | A AG-LOHN2  |
    | BG-AUFTRAG  | Version auftragsbez     | auftragsbezogen | BASISAUF        | EK3-AUFTRAG | 1         | 0     | 0         | 0       | !dontChange | !dontChange | E2    | 1         | A AG-LOHN1  | A AG-LOHN2  |
    | BG-RECHNEN  | Umrechnung in Ferigung  | bedarfsbezogen  |                 | UMRECHNUNG1 | 1         | 0     | 0         | 0       | 10          | 10          | E2    | 1         | A AG-LOHN1  | A AG-LOHN2  |
    | BG-VARIANT  | bsart=variantenbezogen  | variantenbezogen|                 | EK3-AUFTRAG | 1         | 0     | 0         | 0       | !dontChange | !dontChange | E2    | 1         | A AG-LOHN1  | A AG-LOHN2  |



  #  Test
  

  Scenario: 01 Version wird in der AFL getauscht und eingeplant, Artikeleigenschaften werden uebernommen oder entsprechend neu gesetzt, FV nicht freigegeben
    # Auftrag erstellen
    Given I open an editor "Auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KUNDE1"
    And I append rows
      | artikel     | mge |
      | BG-BASIS    | 10  |
      | BG-VERSION  | 10  |
    And I save the current editor

    And I run Scheduling

    # BSTATUS BG-BASIS
    Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "Auftrag1"
    Then field "elem" has value "EK1-BEDARF" in row !lastRow
    And I close the current editor

    # BSTATUS BG-VERSION
    Given I open the infosystem ProcurementStatus for position 2 of SalesOrder from editor "Auftrag1"
    Then field "elem" has value "EK1-BEDARF" in row !lastRow
    And I close the current editor

    # AFL im Auftrag aendern
    Given I switch the current editor to editor "Auftrag1" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL_Basis" in row 1
    Then field "basisartikel" has value "BASISVERS" in row 1
    Then field "elex" has value "EK1-BEDARF" in row 1
    # werden uebernommen: Nutzen, Anfahrmenge, Ausschuss
    # kommen aus neuem Artikel: Beschaffungsart, Dispoart, Abgangsplatz
    And I set field "elex" to "EK-ABGANG" in row 1
    Then the table has 4 rows
    Then table has values
      | vorgnachficon | basisartikel  | elex          | dispoa          | pverlust  | amge | nutzen  | platz | !row  |
      |               | BASISVERS     | EK-ABGANG     | auftragsbezogen | 10        | 2    | 2       | F3    | 1     |
    And I save the current subeditor to switch back to the parent editor
    And I press button "absteig" to open a subeditor for "AFL_Version" in row 2
    Then field "basisartikel" has value "BASISVERS" in row 1
    Then field "elex" has value "EK1-BEDARF" in row 1
    # werden uebernommen: Nutzen, Anfahrmenge, Ausschuss
    # kommen aus neuem Artikel: Beschaffungsart, Dispoart
    # Neue Version ist LGR-EXTERN: dispoa=auftragsbezogen, bsart=Umlagern aus HONGKONG
    And I set field "elex" to "LGR-EXTERN" in row 1
    Then the table has 4 rows
    Then table has values
      | vorgnachficon | basisartikel  | elex          | dispoa          |  pverlust  | amge  | nutzen  | !row  |
      |               | BASISVERS     | LGR-EXTERN    | auftragsbezogen |  10        | 2     | 2       | 1     |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

     # Geaenderte Versionen werden eingeplant, Pruefung ueber BSTATUS
    # BSTATUS BG-BASIS
    Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "Auftrag1"
    Then table has values
      | elem      | rmge  | dispoa          | !row      |
      | EK-ABGANG | 7.778 | auftragsbezogen | !lastRow  |
    And I close the current editor

    # BSTATUS BG-VERSION
    Given I open the infosystem ProcurementStatus for position 2 of SalesOrder from editor "Auftrag1"
    Then table has values
      | elem        | rmge  | dispoa          | !row      |
      | LGR-EXTERN  | 7.778 | auftragsbezogen | !lastRow  |
    And I close the current editor

    # Auftrag loeschen
    Given I switch the current editor to editor "Auftrag1" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 2
    And I save the current editor
    And I run Scheduling


  Scenario: 02 Version wird in der AFL getauscht und eingeplant, Artikeleigenschaften werden uebernommen oder entsprechend neu gesetzt, FV freigegeben, nicht bebucht
    # Auftrag erstellen und FVs freigeben
    Given I open an editor "Auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KUNDE1"
    And I append rows
      | artikel     | mge |
      | BG-BASIS    | 10  |
      | BG-VERSION  | 10  |
    And I press button "absteig" to open a subeditor for "afl" in row 1
    Then field "elex" has value "EK1-BEDARF" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I save the current editor

    And I run Scheduling
    
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-BASIS"
    And I press button "ladetab"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "BASIS" in row !lastRow
    And I press button "freig" to open a subeditor for "freigeben1"
    And I close the current subeditor to switch back to the parent editor
    And I set field "artikel" to "BG-VERSION"
    And I press button "ladetab"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "VERS" in row !lastRow
    And I press button "freig" to open a subeditor for "freigeben2"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    # AFL im Auftrag aendern
    Given I switch the current editor to editor "Auftrag2" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL_Basis" in row 1
    Then field "basisartikel" has value "BASISVERS" in row 1
    Then field "elex" has value "EK1-BEDARF" in row 1
    # werden uebernommen: Nutzen, Anfahrmenge, Ausschuss
    # kommen aus neuem Artikel: Beschaffungsart, Dispoart, Abgangsplatz
    And I set field "elex" to "EK-ABGANG" in row 1
    Then the table has 4 rows
    Then table has values
      | vorgnachficon | basisartikel  | elex          | dispoa          | pverlust  | amge | nutzen  | platz | !row  |
      |               | BASISVERS     | EK-ABGANG     | auftragsbezogen | 10        | 2    | 2       | F3    | 1     |
    And I save the current subeditor to switch back to the parent editor
    And I press button "absteig" to open a subeditor for "AFL_Version" in row 2
    Then field "basisartikel" has value "BASISVERS" in row 1
    Then field "elex" has value "EK1-BEDARF" in row 1
    # werden uebernommen: Nutzen, Anfahrmenge, Ausschuss
    # kommen aus neuem Artikel: Beschaffungsart, Dispoart
    # Neue Version ist LGR-EXTERN: dispoa=auftragsbezogen, bsart=Umlagern aus HONGKONG
    And I set field "elex" to "LGR-EXTERN" in row 1
    Then table has values
      | vorgnachficon | basisartikel  | elex          | dispoa          | pverlust  | amge  | nutzen  | !row  |
      |               | BASISVERS     | LGR-EXTERN    | auftragsbezogen | 10        | 2     | 2       | 1     |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    # Geaenderte Versionen werden eingeplant, Pruefung ueber BSTATUS
    # BG-BASIS
    Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "Auftrag2"
    Then table has values
      | elem      | rmge  | dispoa          | !row      |
      | EK-ABGANG | 7.778 | auftragsbezogen | !lastRow  |
    And I close the current editor

    # BG-VERSION
    Given I open the infosystem ProcurementStatus for position 2 of SalesOrder from editor "Auftrag2"
    Then table has values
      | elem        | rmge  | dispoa          | !row      |
      | LGR-EXTERN  | 7.778 | auftragsbezogen | !lastRow  |
    And I close the current editor

    # Auftrag und FV loeschen
    Given I open an editor "BA_BASIS" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BASIS000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

    Given I open an editor "BA_VERSION" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "VERS000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

    Given I switch the current editor to editor "Auftrag2" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 2
    And I save the current editor
    And I run Scheduling


  Scenario: 03 Charge und Materialzuordnung werden beim Tausch von Versionen in der AFL nicht uebernommen
    # Charge anlegen
    Given I create a Lot "Charge1" for Product "EK3-AUFTRAG"
    Given I create a Lot "Charge2" for Product "EK3-AUFTRAG"

    # Auftrag mit Charge und Projekt anlegen
    Given I open an editor "Auftrag3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KUNDE1"
    And I append rows
      | artikel     | mge   | verw      |
      | BG-AUFTRAG  | 10    | position  |
      | BG-AUFTRAG  | 10    | MZ        |
    And I save the current editor

    And I run Scheduling

    # Charge direkt in Zeile in Reservierung fuer Pos. 1, Materialzuordnung fuer Pos. 2
    Given I open an editor "Reserv1" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=EK3-AUFTRAG;vor^verw=position;@richtung=rueckwaerts;@maxtreffer=1"
    Then the table has 4 rows
    And I set field "charge" to "!Charge1" in row 1
    And I save the current editor

    Given I open an editor "Reserv2" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=EK3-AUFTRAG;vor^verw=MZ;@richtung=rueckwaerts;@maxtreffer=1"
    Then the table has 4 rows
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I append rows
      | zuomge  | charge    |
      | 5       | !Charge1  |
      | 5       | !Charge2  |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    And I run Scheduling

    # Version in Reservierung aendern
    Given I open an editor "Reserv1" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=EK3-AUFTRAG;vor^verw=position;@richtung=rueckwaerts;@maxtreffer=1"
    And I set field "elex" to "EK4-AUFTRAG" in row 1
    Then field "charge" is empty in row 1
    And I save the current editor

    Given I open an editor "Reserv2" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=EK3-AUFTRAG;vor^verw=MZ;@richtung=rueckwaerts;@maxtreffer=1"
    And I set field "elex" to "EK4-AUFTRAG" in row 1
    And I save the current editor

    Given I open an editor "Reserv2" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=EK4-AUFTRAG;vor^verw=MZ;@richtung=rueckwaerts;@maxtreffer=1"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    Then the table has 0 rows
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    And I run Scheduling

    # Geaenderte Versionen werden eingeplant, Pruefung ueber BSTATUS
    # BG-AUFTRAG, Position 1
    Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "Auftrag3"
    Then table has values
      | elem        | rmge  | rverw     | !row      |
      | EK4-AUFTRAG | 10    | position  | !lastRow  |
    And I close the current editor

    # BG-AUFTRAG, Position 2
    Given I open the infosystem ProcurementStatus for position 2 of SalesOrder from editor "Auftrag3"
    Then table has values
      | elem        | rmge  | rverw   | !row      |
      | EK4-AUFTRAG | 10    | MZ      | !lastRow  |
    And I close the current editor

    # Auftrag loeschen
    Given I switch the current editor to editor "Auftrag3" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 2
    And I save the current editor
    And I run Scheduling


  Scenario: 04 Im rueckgemeldeten Bereich ist keine aenderung der Version moeglich, elex ist schreibgeschuetzt
    # Auftrag erstellen und FV freigeben
    Given I create a SalesOrder "Auftrag4" for Customer "KUNDE1" with Product "BG-VERSION" and quantity "10"

    And I run Scheduling

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-VERSION"
    And I press button "ladetab"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "RUECKM" in row !lastRow
    And I press button "freig" to open a subeditor for "freigeben1"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    # Rueckmeldung auf ersten Arbeitsschein buchen
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKM001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor

    # AFL im Auftrag aendern
    Given I switch the current editor to editor "Auftrag4" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "elex" is not modifiable in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    # BA abschließen, Auftrag liefern
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKM002"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

    Given I deliver the SalesOrder "Auftrag4" with PackingSlip "LS_4"
    And I run Scheduling


   Scenario: 05 Komponenteneigenschaften bleiben beim aendern der Versionen in der AFL bestehen
    # Auftrag anlegen
    Given I open an editor "Auftrag5" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KUNDE1"
    And I append rows
      | artikel        | mge |
      | BG-KOPPELPROD  | 10  |
      | BG-VERSION     | 10  |
    And I save the current editor
     
    And I run Scheduling
     
    # Im Auftrag Komponenteneigenschaft setzen
    Given I switch the current editor to editor "Auftrag5" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL2" in row 2
    And I set field "kompeig" to "Koppelprodukt" in row 1
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    And I run Scheduling

    # Versionen mit Komponenteneigenschaften in AFL aendern
    Given I switch the current editor to editor "Auftrag5" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL1" in row 1
    And I set field "elex" to "EK2-BEDARF" in row 2
    Then field "kompeig" has value "Koppelprodukt" in row 2
    And I save the current subeditor to switch back to the parent editor
    And I press button "absteig" to open a subeditor for "AFL2" in row 2
    And I set field "elex" to "EK2-BEDARF" in row 1
    Then field "kompeig" has value "Koppelprodukt" in row 1
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    # BSTATUS BG-KOPPELPRODUKT
    Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "Auftrag5"
    Then table has values
      | elem       | kompeig       | !row  |
      | EK2-BEDARF | icon:combine  | 4     |
    And I close the current editor

    # BSTATUS BG-VERSION
    Given I open the infosystem ProcurementStatus for position 2 of SalesOrder from editor "Auftrag5"
    Then table has values
       | elem       | kompeig       | !row      |
       | EK2-BEDARF | icon:combine  | !lastRow  |
    And I close the current editor

    # Auftrag loeschen
    Given I switch the current editor to editor "Auftrag5" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 2
    And I save the current editor
    And I run Scheduling


  Scenario: 06 Im Artikel gesetzte Umrechnung Fertigung wird beim Tausch von Versionen in der AFL aus dem Artikel uebernommen
    # Auftrag erstellen
    Given I create a SalesOrder "Auftrag6" for Customer "KUNDE1" with Product "BG-RECHNEN" and quantity "10"

    And I run Scheduling

    # AFL im Auftrag aendern
    Given I switch the current editor to editor "Auftrag6" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then table has values
      | basisartikel  | elex         | mflme | mfbme | lge | breite  | gmge  |
      | UMRECHNUNG    | UMRECHNUNG1  | 10    | 10    | 10  | 10      | 10    |
    # kommt aus neuem Artikel: Umrechnung Fertigung
    And I set field "elex" to "UMRECHNUNG2" in row 1
    Then table has values
      | basisartikel  | elex          | mflme | mfbme | lge | breite  | gmge | !row  |
      | UMRECHNUNG    | UMRECHNUNG2   | 20    | 20    | 10  | 10      | 2.5  | 1     |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    # Geaenderte Versionen werden eingeplant ohne Dispoanstoß, Pruefung ueber BSTATUS
    # BG-BASIS
    Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "Auftrag6"
    Then table has values
      | elem         | rmge  | !row      |
      | UMRECHNUNG2  | 2.5   | !lastRow  |
    And I close the current editor

    # Auftrag loeschen
    Given I switch the current editor to editor "Auftrag6" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor
    And I run Scheduling


  Scenario: 07 Der Kostensammler wird beim aendern von Versionen in der AFL angepasst
   # Auftrag erstellen und FVs freigeben
   Given I create a SalesOrder "Auftrag7" for Customer "KUNDE1" with Product "BG-VERSION" and quantity "10"

   And I run Scheduling

   Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
   And I set field "artikel" to "BG-VERSION"
   And I press button "ladetab"
   And I set field "mfreig" to "ja" in row !lastRow
   And I set field "bisuch" to "KOST" in row !lastRow
   And I press button "freig" to open a subeditor for "freigeben1"
   And I close the current subeditor to switch back to the parent editor
   And I close the current editor

   # Kostensammler in Reservierung manuell anpassen
   Given I open an editor "Reserv1" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=EK1-BEDARF;@richtung=rueckwaerts;@maxtreffer=1"
   And I press button "buksamml" to open a subeditor for "Kostensammler" in row 1
   And I create a new row at the end of the table
   Then field "elem" has value "EK1-BEDARF" in row 1
   And I set field "ewert" to "11" in row 1
   And I save the current subeditor to switch back to the parent editor
   And I save the current editor

   # Version in Reservierung aendern
   Given I open an editor "Reserv1" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=EK1-BEDARF;@richtung=rueckwaerts;@maxtreffer=1"
   And I set field "elem" to "EK2-BEDARF" in row 1
   And I save the current editor

   # Kostensammler hat sich nach dem Speichern angepasst
   Given I open an editor "Reserv1" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=EK2-BEDARF;@richtung=rueckwaerts;@maxtreffer=1"
   And I press button "buksamml" to open a subeditor for "Kostensammler" in row 1
   Then field "elem" has value "EK2-BEDARF" in row 1
   Then field "ewert" has value "11.0000" in row 1
   And I save the current subeditor to switch back to the parent editor
   And I save the current editor

   # Auftrag und FV loeschen
   Given I open an editor "BA_KOST" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "KOST000"
   And I respond with answer "ja" to the dialog with id "345"
   And I set field "status" to "s"
   And I save the current editor

   Given I switch the current editor to editor "Auftrag7" with command "UPDATE"
   And I respond with answer "ja" to the dialog with id "191"
   And I set field "mge" to "0" in row 1
   And I save the current editor
   And I run Scheduling


  Scenario: 08 Tausch der Version in Unterbaugruppe in AFL, FV freigegeben, nicht bebucht
    # Auftrag erstellen
    Given I create a SalesOrder "Auftrag8" for Customer "KUNDE1" with Product "BG-UNTERBG" and quantity "10"

    And I run Scheduling

    # BSTATUS BG-BASIS
    Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "Auftrag8"
    Then field "elem" has value "EK1-BEDARF" in row 6
    And I close the current editor

    # AFL in der Reservierung der Unterbaugruppe BG-BEDARF aendern
    Given I open an editor "Reserv1" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=EK1-BEDARF;@richtung=rueckwaerts;@maxtreffer=1"
    Then field "bartikel" has value "BG-BEDARF"
    And I set field "elem" to "EK1-AUFTRAG" in row 1
    And I save the current editor

    # Geaenderte Versionen werden eingeplant, Pruefung ueber BSTATUS von BG-UNTERBG
    Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "Auftrag8"
    Then table has values
      | elem         | rmge  | dispoa          | !row  |
      | EK1-AUFTRAG  | 10    | auftragsbezogen | 6     |
    And I close the current editor

    # Auftrag loeschen
    Given I switch the current editor to editor "Auftrag8" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor
    And I run Scheduling


  Scenario: 09 Tausch der Version in Unterbaugruppe in AFL, FV nicht freigegeben
    # Auftrag erstellen und FV fuer Unterbaugruppe freigeben
    Given I create a SalesOrder "Auftrag9" for Customer "KUNDE1" with Product "BG-UNTERBG" and quantity "10"

    And I run Scheduling

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-BEDARF"
    And I press button "ladetab"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "UBG" in row !lastRow
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    # BSTATUS BG-BASIS
    Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "Auftrag9"
    Then field "elem" has value "EK1-BEDARF" in row 6
    And I close the current editor

    # AFL in der Reservierung der Unterbaugruppe BG-BEDARF aendern
    Given I open an editor "Reserv1" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=EK1-BEDARF;@richtung=rueckwaerts;@maxtreffer=1"
    Then field "bartikel" has value "BG-BEDARF"
    And I set field "elem" to "EK1-AUFTRAG" in row 1
    And I save the current editor

    # Geaenderte Versionen werden eingeplant, Pruefung ueber BSTATUS von BG-UNTERBG
    Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "Auftrag9"
    Then table has values
      | elem         | rmge  | dispoa          | !row  |
      | EK1-AUFTRAG  | 10    | auftragsbezogen | 6     |
    And I close the current editor

    # FV stornieren und Auftrag loeschen
    Given I open an editor "BA_KOST" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "UBG000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

    Given I switch the current editor to editor "Auftrag9" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor
    And I run Scheduling
    

    Scenario: 10 Umrechnung Fertigung wird initialisiert beim Tausch von Artikeln in der AFL, Artikel durch Arbeitsgang ersetzen nicht moeglich
      
    # Auftrag erstellen
    Given I create a SalesOrder "Auftrag10" for Customer "KUNDE1" with Product "BG-AUFTRAG" and quantity "10"

    And I run Scheduling

    # in AFL Artikel ohne Umrechnung ersetzen durch Artikel mit Umrechnung, Felder schreibbar
    Given I switch the current editor to editor "Auftrag10" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then table has values
      | basisartikel  | elex         | lge   | lme   | breite | bme     | elanzahl  | mle   |
      | BASISAUF      | EK3-AUFTRAG  |       |       |        |         | 1         | Stück |
      |               | E2           |       |       |        |         | 1         | Stück |
    Then field "lge" is not modifiable in row 2
    Then field "breite" is not modifiable in row 2
    And I set field "elex" to "E1" in row 2   
    Then field "lge" is modifiable in row 2
    Then field "breite" is modifiable in row 2
    And I modify table
        | !row  | lge   | breite    |
        | 2     | 10    | 10        |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor
 
     # in AFL Artikel mit Umrechnung ersetzen durch Artikel ohne Umrechnung, Felder schreibgeschuetzt   
    Given I switch the current editor to editor "Auftrag10" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then table has values
      | basisartikel  | elex         | lge   | lme   | breite | bme     | elanzahl  | mle   |
      | BASISAUF      | EK3-AUFTRAG  |       |       |        |         | 1         | Stück |
      |               | E1           | 10    | cm    | 10     | cm      | 1         |       |
    And I set field "elex" to "E2" in row 2   
    Then field "lge" is not modifiable in row 2
    Then field "breite" is not modifiable in row 2
    Then table has values
      | basisartikel  | elex         | lge   | lme   | breite | bme     | elanzahl  | mle   |
      | BASISAUF      | EK3-AUFTRAG  |       |       |        |         | 1         | Stück |
      |               | E2           |       |       |        |         | 1         | Stück |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor 
    
    # Artikel durch Arbeitsgang ersetzen nicht moeglich
    Given I switch the current editor to editor "Auftrag10" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    # Darf nur durch einen Artikel ersetzt werden.
    Then setting field "elex" to "A AG1" in row 2 throws the exception "1361"   
    And I close the current subeditor to switch back to the parent editor 
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor
    And I run Scheduling
