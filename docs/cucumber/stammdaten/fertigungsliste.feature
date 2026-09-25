@persistent
Feature: fertigungsliste.feature

# **********************************************************************************
#  Name             : fertigungslisten_kalkulation.feature
#  Autor            : lbettendorf
#  Verantwortlich   : drpf
#  Kontrolle        : bheim
#  Funktion         : Testet die Kalkulation bei Artikeln mit Maximalstücklisten
#                     oder mehreren Fertigungslisten
#  ref              : ref_fertigungslisten_cu
#  Stammdaten       : basis_stammdaten.feature
#
# **********************************************************************************


# Tests Maximalstückliste

  Scenario: 01M Artikel mit Maximalstückliste Stammdaten und Kalkulation

    Given I open an editor "MAXIMALSTL" from table "(Part):(Product)" with command "STORE" for record "MAXIMALSTL"
    And I set fields
      | such     | MAXIMALSTL        |
      | namebspr | Maximalstückliste |
      | bsart    | Eigenfertigung    |
      | lief     | K-LIEF            |
      | efrist   | 3                 |
      | epr      | 100               |
    And I delete all rows
    And I append rows
      | elex       | elanzahl    | bua                    |
      | EK2-BEDARF | 1           | !dontChange            |
      | A AG1      | !dontChange | !dontChange            |
      | BG-BEDARF  | 1           | !dontChange            |
      | A AG2      | !dontChange | !dontChange            |
      | BG-BEDARF  | 1           | Lieferantenbeistellung |
    And I save the current editor

# Kalkulation Eigenfertigung und Fremdbeschaffung
    And I switch the current editor to editor "MAXIMALSTL" with command "UPDATE"
    And I press button "kalkul" to open a subeditor for "Kalkulieren"
    And I close the current subeditor to switch back to the parent editor
    And I set field "ibsart" to "Fremdbeschaffung"
    And I press button "kalkul" to open a subeditor for "Kalkulieren"
    And I close the current subeditor to switch back to the parent editor
    And I save the current editor

    Given I open an editor "KBlatt_Eigenfertigung" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,artikel==MAXIMALSTL;bsart==(InhouseProduction);@maxtreffer=1;@richtung=rueckwaerts"
    Then fields have values
      | bsart | Eigenfertigung                 |
      | typ   | Standard Artikelvorkalkulation |
      | hk    | 191.0000                       |
    Then the table has 13 rows
    And I close the current editor

    Given I open an editor "KBlatt_Fremdbeschaffung" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,artikel==MAXIMALSTL;bsart==(ExternalProcurement);@maxtreffer=1;@richtung=rueckwaerts"
    Then fields have values
      | bsart | Fremdbeschaffung               |
      | typ   | Standard Artikelvorkalkulation |
      | hk    | 203.7500                       |
    Then the table has 5 rows
    And I close the current editor


  Scenario: 02M Maximalstückliste wird in Beschaffungsvorgängen aufgelöst

# Bestellvorschlag
    Given I open an editor "Bestvor" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge |
      | MAXIMALSTL | 100 |
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    Then the table has 1 rows
    Then table has values
      | elex      | bua                    |
      | BG-BEDARF | Lieferantenbeistellung |
    And I close the current subeditor to switch back to the parent editor
    And I set field "mge" to "0" in row 1
    And I save the current editor

# Bestellung
    Given I open an editor "Bestell1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "LIEFER1"
    And I append rows
      | artikel    | mge |
      | MAXIMALSTL | 100 |
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    Then the table has 1 rows
    Then table has values
      | elex      | bua                    |
      | BG-BEDARF | Lieferantenbeistellung |
    And I close the current subeditor to switch back to the parent editor
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 03M Maximalstückliste wird in Verkaufsvorgängen aufgelöst

    Given I open an editor "Auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KUNDE1"
    And I append rows
      | artikel    | mge | bsart            |
      | MAXIMALSTL | 100 | !dontChange      |
      | MAXIMALSTL | 100 | Fremdbeschaffung |

# Stücklistenauflösung
    And I press button "absteig" to open a subeditor for "AFL_Eigenfert" in row 1
    Then the table has 4 rows
    Then table has values
      | elex       |
      | EK2-BEDARF |
      | A AG1      |
      | BG-BEDARF  |
      | A AG2      |
    And I close the current subeditor to switch back to the parent editor
    And I press button "absteig" to open a subeditor for "AFL_Fremd" in row 2
    Then the table has 1 rows
    Then table has values
      | elex      | bua                    |
      | BG-BEDARF | Lieferantenbeistellung |
    And I close the current subeditor to switch back to the parent editor
# Kalkulation Eigenfertigung
    And I set field "kalk" to "ja" in row 1
    And I press button "kalkulr" to open a subeditor for "Kalkulieren" in row 0 with dialog "" and answer "1"
    And I close the current subeditor to switch back to the parent editor
    And I press button "kblatt" to open a subeditor for "KBlatt_Eigenfert" in row 1
    Then fields have values
      | bsart | Eigenfertigung         |
      | typ   | Auftragsvorkalkulation |
      | hk    | 56.3600                |
    Then the table has 13 rows
    And I close the current subeditor to switch back to the parent editor
    And I set field "kalk" to "0" in row 1
# Kalkualtion Fremdbeschaffung
    And I set field "kalk" to "ja" in row 2
    And I press button "kalkulr" to open a subeditor for "Kalkulieren" in row 0 with dialog "" and answer "1"
    And I close the current subeditor to switch back to the parent editor
    And I press button "kblatt" to open a subeditor for "KBlatt_Fremd" in row 2
    Then fields have values
      | bsart | Fremdbeschaffung       |
      | typ   | Auftragsvorkalkulation |
      | hk    | 130.9850               |
    Then the table has 5 rows
    And I close the current subeditor to switch back to the parent editor
    And I save the current editor

    And I run Scheduling

# Beschaffungsvorschläge sind angelegt
    Given I open an editor "Bestvor" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MAXIMALSTL"
    And I press button "ladetab"
#Then the table has 1 rows
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then the table has 1 rows
    Then field "elex" has value "BG-BEDARF" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MAXIMALSTL"
    And I press button "ladetab"
#Then the table has 1 rows
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then the table has 4 rows
    Then table has values
      | elex       |
      | EK2-BEDARF |
      | A AG1      |
      | BG-BEDARF  |
      | A AG2      |
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    And I switch the current editor to editor "Auftrag1" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 2
    And I save the current editor


  Scenario: 04M ibsart=Lohnfertigung oder Umlagern bringt Fehler

    Given I open an editor "MAXIMALSTL" from table "(Part):(Product)" with command "UPDATE" for record "MAXIMALSTL"
# Fehler:   2687 de      |nicht erlaubt
    Then setting field "ibsart" to "Lohnfertigung" throws the exception "2687"
    Then setting field "ibsart" to "Umlagern" throws the exception "2687"
    And I close the current editor


  Scenario: 05M Artikel mit Maximalstückliste wird in Einkaufsvorgängen aufgelöst

    Given I open an editor "Bestellung1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "LIEFER1"
    And I append rows
      | artikel    | mge |
      | MAXIMALSTL | 10  |
    And I press button "absteig" to open a subeditor for "afl" in row 1
    Then field "flistestd" has value "STANDARD"
    Then the table has 1 rows
    Then field "bua" has value "Lieferantenbeistellung" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor



# Tests zwei Standardfertigungslisten

  Scenario: 01F Artikel mit zwei Standardfertigungslisten, Stammdaten und Kalkulation

    Given I open an editor "BSARTKALK" from table "(Part):(Product)" with command "STORE" for record "BSARTKALK"
    And I set fields
      | such     | BSARTKALK   |
      | namebspr | bsart in FL |
      | lief     | K-LIEF      |
      | efrist   | 3           |
      | epr      | 50          |
    And I delete all rows
    And I append rows
      | elex      | elanzahl | bua                    |
      | BG-BEDARF | 1        | Lieferantenbeistellung |
    And I save the current editor

    Given I open an editor "FL1-FREMD" via ID from editor "BSARTKALK" from field "flistestd" in row 0 for table "(ProductionList):(ProductionList)" with command "UPDATE"
    Then field "bsart" has value "Fremdbeschaffung"
    And I set field "such" to "FL1-FREMD"
    Then the table has 1 rows
    And I save the current editor

    And I switch the current editor to editor "BSARTKALK"
    And I set field "bsart" to "Eigenfertigung"
    And I delete all rows
    And I append rows
      | elex       | elanzahl    |
      | EK2-BEDARF | 1           |
      | A AG1      | !dontChange |
      | BG-BEDARF  | 1           |
      | A AG2      | !dontChange |
    And I save the current editor

    Given I open an editor "FL1-EIGEN" via ID from editor "BSARTKALK" from field "flistestd" in row 0 for table "(ProductionList):(ProductionList)" with command "UPDATE"
    Then field "bsart" has value "Eigenfertigung"
    Then the table has 4 rows
    And I set field "such" to "FL1-EIGEN"
    And I save the current editor

# Beim Wechsel der bsart wird die entsprechende STL gezogen und kalkuliert
    Given I switch the current editor to editor "BSARTKALK" with command "UPDATE"
    Then field "bsart" has value "Eigenfertigung"
    Then the table has 4 rows
    And I press button "kalkul" to open a subeditor for "Kalkulieren"
    And I close the current subeditor to switch back to the parent editor
    And I set field "bsart" to "Fremdbeschaffung"
    And I press button "kalkul" to open a subeditor for "Kalkulieren"
    And I close the current subeditor to switch back to the parent editor
    And I save the current editor

    Given I open an editor "KBlatt_Eigenfertigung" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,artikel=BSARTKALK;bsart=Eigenfertigung;@maxtreffer=1;@richtung=rueckwaerts"
    Then fields have values
      | bsart | Eigenfertigung                 |
      | typ   | Standard Artikelvorkalkulation |
      | hk    | 191.0000                       |
    Then the table has 13 rows
    And I close the current editor

    Given I open an editor "KBlatt_Fremdbeschaffung" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,artikel=BSARTKALK;bsart=Fremdbeschaffung;@maxtreffer=1;@richtung=rueckwaerts"
    Then fields have values
      | bsart | Fremdbeschaffung               |
      | typ   | Standard Artikelvorkalkulation |
      | hk    | 153.7500                       |
    Then the table has 5 rows
    And I close the current editor


  Scenario: 02F Artikel mit zwei Standard-Fertigungslisten wird in Verkaufsvorgängen aufgelöst und kalkuliert

    Given I open an editor "Auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KUNDE1"
    And I append rows
      | artikel   | mge | bsart            |
      | BSARTKALK | 100 | Eigenfertigung   |
      | BSARTKALK | 100 | Fremdbeschaffung |
# Stücklistenauflösung
    And I press button "absteig" to open a subeditor for "AFL-Eigen" in row 1
    Then the table has 4 rows
    And I close the current subeditor to switch back to the parent editor
    And I press button "absteig" to open a subeditor for "FL-Fremd" in row 2
    Then the table has 1 rows
    And I close the current subeditor to switch back to the parent editor
# Kalkulation Eigenfertigung
    And I set field "kalk" to "ja" in row 1
    And I press button "kalkulr" to open a subeditor for "Kalkulieren" in row 0 with dialog "" and answer "1"
    And I close the current subeditor to switch back to the parent editor
    And I press button "kblatt" to open a subeditor for "KBlatt_Eigenfert" in row 1
    Then fields have values
      | bsart | Eigenfertigung         |
      | typ   | Auftragsvorkalkulation |
      | hk    | 56.3600                |
    Then the table has 13 rows
    And I close the current subeditor to switch back to the parent editor
    And I set field "kalk" to "0" in row 1
# Kalkualtion Fremdbeschaffung
    And I set field "kalk" to "ja" in row 2
    And I press button "kalkulr" to open a subeditor for "Kalkulieren" in row 0 with dialog "" and answer "1"
    And I close the current subeditor to switch back to the parent editor
    And I press button "kblatt" to open a subeditor for "KBlatt_Fremd" in row 2
    Then fields have values
      | bsart | Fremdbeschaffung       |
      | typ   | Auftragsvorkalkulation |
      | hk    | 80.9850                |
    Then the table has 5 rows
    And I close the current subeditor to switch back to the parent editor
    And I save the current editor

    And I run Scheduling

# Beschaffungsvorschläge sind angelegt
    Given I open an editor "Bestvor" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BSARTKALK"
    And I press button "ladetab"
#Then the table has 1 rows
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then the table has 1 rows
    Then table has values
      | elex      | bua                    |
      | BG-BEDARF | Lieferantenbeistellung |
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BSARTKALK"
    And I press button "ladetab"
#Then the table has 1 rows
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then the table has 4 rows
    Then table has values
      | elex       |
      | EK2-BEDARF |
      | A AG1      |
      | BG-BEDARF  |
      | A AG2      |
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    And I switch the current editor to editor "Auftrag2" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 2
    And I save the current editor


  Scenario: 03F Artikel mit zwei Standard-Fertigungslisten wird in Einkaufsvorgängen aufgelöst

    Given I open an editor "Bestellung2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "LIEFER1"
    And I append rows
      | artikel   | mge |
      | BSARTKALK | 10  |
    And I press button "absteig" to open a subeditor for "afl" in row 1
    Then field "flistestd" has value "FL1-FREMD"
    Then the table has 1 rows
    Then field "bua" has value "Lieferantenbeistellung" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor


  Scenario: 04F basrt=Umlagern zwischen externen Lagergruppen und interner und externer Lagerguppe

    Given I open an editor "BSARTKALK" from table "(Part):(Product)" with command "UPDATE" for record "BSARTKALK"
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I append rows
      | lgruppe  | bsart          | umllg       |
      | BERLIN   | Eigenfertigung | !dontChange |
      | HONGKONG | Umlagern       | BERLIN      |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    Given I switch the current editor to editor "BSARTKALK" with command "UPDATE"
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    Then field "flistestd" has value "FL1-EIGEN" in row 1
    Then field "flistestd" has value "FL1-EIGEN" in row 2
    And I press button "kalkul" to open a subeditor for "Kalkulieren" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I press button "kblatt" to open a subeditor for "KBlatt_Fremd" in row 2
    Then fields have values
      | bsart | Eigenfertigung                 |
      | typ   | Standard Artikelvorkalkulation |
      | hk    | 191.0000                       |
    Then the table has 13 rows
    And I close the current subeditor to switch back to the parent editor
    And I press button "kalkul" to open a subeditor for "Kalkulieren" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I press button "kblatt" to open a subeditor for "KBlatt_Fremd" in row 1
    Then fields have values
      | bsart | Umlagern                       |
      | typ   | Standard Artikelvorkalkulation |
      | hk    | 191.0000                       |
    Then the table has 5 rows
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    And I switch the current editor to editor "BSARTKALK"
    And I close the current editor

    Given I open an editor "FL-BERLIN" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I set fields
      | such      | FL-BERLIN      |
      | artikel   | BSARTKALK      |
      | bsart     | Eigenfertigung |
      | flistestd | ja             |
      | lgruppe   | BERLIN         |
    And I append rows
      | elex       | lge         | breite      | elanzahl |
      | E2         | !dontChange | !dontChange | 1        |
      | E3         | !dontChange | !dontChange | 1        |
      | A AG-LOHN1 | 20          | 10          | 1        |
    And I save the current editor

    Given I switch the current editor to editor "BSARTKALK" with command "UPDATE"
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    Then field "flistestd" has value "FL-BERLIN" in row 1
    Then field "flistestd" has value "FL-BERLIN" in row 2
    And I press button "kalkul" to open a subeditor for "Kalkulieren" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I press button "kblatt" to open a subeditor for "KBlatt_Fremd" in row 2
    Then fields have values
      | bsart | Eigenfertigung                 |
      | typ   | Standard Artikelvorkalkulation |
      | hk    | 159.4000                       |
    Then the table has 6 rows
    And I close the current subeditor to switch back to the parent editor
    And I press button "kalkul" to open a subeditor for "Kalkulieren" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I press button "kblatt" to open a subeditor for "KBlatt_Fremd" in row 1
    Then fields have values
      | bsart | Umlagern                       |
      | typ   | Standard Artikelvorkalkulation |
      | hk    | 159.4000                       |
    Then the table has 5 rows
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    And I switch the current editor to editor "BSARTKALK"
    And I close the current editor


  Scenario: 04G Gewichte, Ausschuss Vorkalkulation werden in Kalkulation berücksichtigt

# Gewichte und Ausschuss in Artikeln hinterlegen
    Given I open an editor "EK2-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "EK2-BEDARF"
    And I set field "gewicht" to "5"
    And I save the current editor

    Given I open an editor "EK1-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "EK1-BEDARF"
    And I set field "gewicht" to "2"
    And I save the current editor

    Given I open an editor "BG-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "BG-BEDARF"
    And I set field "vkpverlust" to "10" in row 2
    And I save the current editor

    Given I open an editor "BSARTKALK" from table "(Part):(Product)" with command "UPDATE" for record "BSARTKALK"
    And I set field "ibsart" to "Eigenfertigung"
    And I press button "kalkul" to open a subeditor for "Kalkulieren"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    And I switch the current editor to editor "BSARTKALK"
    And I close the current editor

    Given I open an editor "KBlatt_Eigen4G" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,lgruppe==KARLSRUHE;typ==(StandardPreliminaryCostingOfProduct);artikel==BSARTKALK;bsart==(InhouseProduction);@richtung=rueckwaerts;@maxtreffer=1"
    Then fields have values
      | bsart     | Eigenfertigung |
      | flistestd | FL1-EIGEN      |
      | brgewicht | 7              |
    Then table has values
      | egewicht | ekmge | !row |
      | 5        | 1     | 1    |
      | 2        | 1.11  | 6    |
    And I close the current editor


  Scenario: 05 ArtikelFL darf nur fuer Artikel und ServiceFL nur fuer DL eingetragen werden

    Given I open an editor "FLISTE" from table "(ProductionList):(ServiceProductionList)" with command "COPY" for search criteria "$,,nummer==36"
    And I set field "such" to "DL_KOPIE"
    And I set field "artikel" to ""
    And I save the current editor

    Given I open an editor "FLISTE" from table "(ProductionList):(ProductionList)" with command "COPY" for search criteria "$,,nummer==30"
    And I set field "such" to "ART_KOPIE"
    And I set field "artikel" to ""
    And I save the current editor

    Given I open an editor "Bestellung3" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "LIEFER1"
    And I append rows
      | artikel | mge |
      | BG1     | 10  |
    Then setting field "flistestd" to "DL_KOPIE" in row 1 throws the exception "3922"
    And I close the current editor

    Given I open an editor "Bestellung4" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set field "lief" to "LIEFER1"
    And I append rows
      | artikel    | mge |
      | DL-ANALYSE | 10  |
    Then setting field "flistestd" to "ART_KOPIE" in row 1 throws the exception "3922"
    And I close the current editor
