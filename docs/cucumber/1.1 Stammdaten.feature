@0d29b4cf55b8b99b
Feature: 1.1 Stammdaten
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-12-03, Maske: P12:3
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-02-04, Maske: P2:4
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-12-08, Maske: P12:8
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-97-01, Maske: PS97:1
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-96-01, Maske: P96:1
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-08-01, Maske: P8:1
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-39-02, Maske: P39:2
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-12-20, Maske: P12:20
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-05-02, Maske: P5:2
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-12-02, Maske: P12:2
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-97-01, Maske: PS97:1
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-39-01, Maske: P39:1
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-12-21, Maske: P12:21
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-05-02, Maske: P5:2
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-00-01, Maske: P0:1
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-01-01, Maske: P1:1
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-96-02, Maske: P96:2
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-38-01, Maske: P38:1
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-11-01, Maske: P11:1
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-12-28, Maske: P12:28
  # 
  # Stammdaten-Testdefinition aus Confluence.
  # Datenbank: V-02-01, Maske: P2:1

  Scenario: Kurztexte anlegen
    Given I open an editor "Kurztext" from table "12:3" with command "STORE" for search criteria "$,,guid==DEFAULT-12:3-00001"
    And I set fields
      | such  | SNEUTRAL                      |
      | guid  | DEFAULT-12:3-00001            |
      | name  | Sehr geehrte Damen und Herren |
      | name2 | Dear Sir or Madam             |
    And I save the current editor
    Then fields have values
      | such  | SNEUTRAL                      |
      | guid  | DEFAULT-12:3-00001            |
      | name  | Sehr geehrte Damen und Herren |
      | name2 | Dear Sir or Madam             |
    And I close the current editor
    Given I open an editor "Kurztext" from table "12:3" with command "STORE" for search criteria "$,,guid==DEFAULT-12:3-00002"
    And I set fields
      | such  | SSIR               |
      | guid  | DEFAULT-12:3-00002 |
      | name  | Sehr geehrter Herr |
      | name2 | Dear Sir           |
    And I save the current editor
    Then fields have values
      | such  | SSIR               |
      | guid  | DEFAULT-12:3-00002 |
      | name  | Sehr geehrter Herr |
      | name2 | Dear Sir           |
    And I close the current editor

  Scenario: Zusatzposition anlegen
    Given I open an editor "Zusatzposition" from table "2:4" with command "STORE" for search criteria "$,,guid==DEFAULT-2:4-00001"
    And I set fields
      | such   | APACKAGINGCOST    |
      | guid   | DEFAULT-2:4-00001 |
      | name   | Verpackungskosten |
      | name2  | Packaging costs   |
      | vkbez  | Verpackungskosten |
      | vkbez2 | Packaging costs   |
      | vbez   | Verpackungskosten |
      | vbez2  | Packaging costs   |
    And I save the current editor
    Then fields have values
      | such   | APACKAGINGCOST    |
      | guid   | DEFAULT-2:4-00001 |
      | name   | Verpackungskosten |
      | name2  | Packaging costs   |
      | vkbez  | Verpackungskosten |
      | vkbez2 | Packaging costs   |
      | vbez   | Verpackungskosten |
      | vbez2  | Packaging costs   |
    And I close the current editor

  Scenario: Zahlungsbedingungen anlegen
    Given I open an editor "Zahlungsbedingung" from table "12:8" with command "STORE" for search criteria "$,,guid==DEFAULT-12:8-00001"
    And I set fields
      | such  | P30N               |
      | guid  | DEFAULT-12:8-00001 |
      | name  | 30 Tage Netto      |
      | name2 | 30 days net        |
    And I delete all rows
    And I create a new row at the end of the table
    And I set field "frist" to "30" in row 1
    And I save the current editor
    Then fields have values
      | such  | P30N               |
      | guid  | DEFAULT-12:8-00001 |
      | name  | 30 Tage Netto      |
      | name2 | 30 days net        |
    And I close the current editor
    Given I open an editor "Zahlungsbedingung" from table "12:8" with command "STORE" for search criteria "$,,guid==DEFAULT-12:8-00002"
    And I set fields
      | such  | P10.3                                                                                                                                       |
      | guid  | DEFAULT-12:8-00002                                                                                                                          |
      | name  | 3% 10 Tage, 1% 30 Tage, 90 Tage rein netto;Bezüglich der Entgeltminderung verweisen;wir auf unsere Zahlungs- und Konditions-;vereinbarungen |
      | name2 | 3% 10 days, 1% 30 days, 90 days pure net;Please note;our payment and conditions agreement;regarding a remuneration                          |
    And I delete all rows
    And I create a new row at the end of the table
    And I set field "frist" to "10" in row 1
    And I set field "skonto" to "3" in row 1
    And I create a new row at the end of the table
    And I set field "frist" to "30" in row 2
    And I set field "skonto" to "1" in row 2
    And I create a new row at the end of the table
    And I set field "frist" to "90" in row 3
    And I set field "skonto" to "0" in row 3
    And I save the current editor
    Then fields have values
      | such | P10.3              |
      | guid | DEFAULT-12:8-00002 |
    Then the table has 3 rows
    And I close the current editor

  Scenario: Region Land Deutschland anlegen
    Given I open an editor "Region/Land/Wirtschaftsraum" from table "97:1" with command "STORE" for record "72"
    And I set fields
      | such      | DEUTSCHLAND    |
      | rname     | Deutschland    |
      | rname2    | Germany        |
      | typb      | Staat          |
      | kenn      | D              |
      | laspra    | Deutsch        |
      | ueberg    | EUR            |
      | waeh      | EUR            |
      | egkenn    | DE             |
      | iso3      | DEU            |
      | iso2      | DE             |
      | sepaland  | ja             |
      | telnr     | 49             |
      | adrformat | ADRFORM-DE     |
      | ischl     | 4              |
      | steunr    | 2350/200/15977 |
      | ustid     | DE152724403    |
    And I save the current editor
    Then fields have values
      | such   | DEUTSCHLAND |
      | rname  | Deutschland |
      | rname2 | Germany     |
    And I close the current editor

  Scenario: Bank anlegen
    Given I open an editor "Bank" from table "96:1" with command "STORE" for search criteria "$,,guid==DEFAULT-96:1-00001"
    And I set fields
      | such    | B43050001          |
      | guid    | DEFAULT-96:1-00001 |
      | name    | Schnitzer Bank     |
      | iident  | WELADED1BOC        |
      | nident  | 43050001           |
      | bankart | Bank               |
      | nort    | Bochum             |
      | staat   | DEUTSCHLAND        |
      | iso2    | DE                 |
    And I save the current editor
    Then fields have values
      | such   | B43050001          |
      | guid   | DEFAULT-96:1-00001 |
      | name   | Schnitzer Bank     |
      | iident | WELADED1BOC        |
      | nident | 43050001           |
    And I close the current editor

  Scenario: Kostenstellen anlegen
    Given I open an editor "Kostenstelle" from table "5:2" with command "STORE" for search criteria "$,,guid==DEFAULT-5:2-00001"
    And I set fields
      | such      | BETRIEB           |
      | guid      | DEFAULT-5:2-00001 |
      | name      | Gesamtbetrieb     |
      | name2     | Overall operation |
      | kshilfs   | nein              |
      | bebuchbar | nein              |
    And I save the current editor
    Then fields have values
      | such  | BETRIEB           |
      | guid  | DEFAULT-5:2-00001 |
      | name  | Gesamtbetrieb     |
      | name2 | Overall operation |
    And I close the current editor
    Given I open an editor "Kostenstelle" from table "5:2" with command "STORE" for search criteria "$,,guid==DEFAULT-5:2-00002"
    And I set fields
      | such    | CMATERIAL                  |
      | guid    | DEFAULT-5:2-00002          |
      | name    | Allgemeine Materialkosten  |
      | name2   | General material costs     |
      | kshilfs | nein                       |
      | verd    | $,,guid==DEFAULT-5:2-00001 |
    And I save the current editor
    Then fields have values
      | such  | CMATERIAL                 |
      | guid  | DEFAULT-5:2-00002         |
      | name  | Allgemeine Materialkosten |
      | name2 | General material costs    |
    Then field "verd^guid" has value "DEFAULT-5:2-00001"
    And I close the current editor

  Scenario: Abteilung anlegen
    Given I open an editor "Abteilung" from table "8:1" with command "STORE" for search criteria "$,,guid==DEFAULT-8:1-00001"
    And I set fields
      | such     | DOPERATI             |
      | guid     | DEFAULT-8:1-00001    |
      | name     | Abteilung Betrieb    |
      | name2    | Department Operation |
      | kstelle  | 101                  |
      | nschicht | 1                    |
      | azpt     | 8                    |
    And I save the current editor
    Then fields have values
      | such     | DOPERATI             |
      | guid     | DEFAULT-8:1-00001    |
      | name     | Abteilung Betrieb    |
      | name2    | Department Operation |
      | kstelle  | 101                  |
      | nschicht | 1                    |
      | azpt     | 8                    |
    And I close the current editor

  Scenario: Lagergruppe anlegen
    Given I open an editor "Lagergruppe" from table "39:2" with command "STORE" for record "1"
    And I set fields
      | such  | INTGROUP                 |
      | name  | Interne Lagergruppe      |
      | name2 | Internal Warehouse Group |
    And I save the current editor
    Then fields have values
      | such  | INTGROUP                 |
      | name  | Interne Lagergruppe      |
      | name2 | Internal Warehouse Group |
    And I close the current editor

  Scenario: Tagesplan anlegen
    Given I open an editor "Tagesplan" from table "12:20" with command "STORE" for search criteria "$,,guid==DEFAULT-12:20-00001"
    And I set fields
      | such      | TPNORMAL            |
      | guid      | DEFAULT-12:20-00001 |
      | name      | Normalschicht       |
      | name2     | Day Shift           |
      | gleitzeit | nein                |
      | sollzeit  | 8                   |
      | zeitg     | 1                   |
      | ranfzeit  | 8:00                |
      | rkaranf   | 0:15                |
      | rvorlauf  | 1:00                |
      | rendzeit  | 17:00               |
      | rkarend   | 0:00                |
      | rnachlauf | 0:30                |
    And I delete all rows
    And I create a new row at the end of the table
    And I set field "variabel" to "nein" in row 1
    And I set field "pbezahlt" to "ja" in row 1
    And I set field "anfzeit" to "9:00" in row 1
    And I set field "endzeit" to "9:15" in row 1
    And I create a new row at the end of the table
    And I set field "variabel" to "ja" in row 2
    And I set field "pbezahlt" to "nein" in row 2
    And I set field "anfzeit" to "12:00" in row 2
    And I set field "karanf" to "0:00" in row 2
    And I set field "pnachlauf" to "0:00" in row 2
    And I set field "endzeit" to "13:00" in row 2
    And I set field "karend" to "0:00" in row 2
    And I set field "pvorlauf" to "0:00" in row 2
    And I set field "abzug" to "0:00" in row 2
    And I create a new row at the end of the table
    And I set field "variabel" to "nein" in row 3
    And I set field "pbezahlt" to "ja" in row 3
    And I set field "anfzeit" to "15:00" in row 3
    And I set field "endzeit" to "15:15" in row 3
    And I save the current editor
    Then fields have values
      | such  | TPNORMAL            |
      | guid  | DEFAULT-12:20-00001 |
      | name  | Normalschicht       |
      | name2 | Day Shift           |
    Then the table has 3 rows
    And I close the current editor

  Scenario: Rechnungsstellung anlegen
    Given I open an editor "Rechnungsstellung" from table "12:2" with command "STORE" for search criteria "$,,guid==DEFAULT-12:2-00001"
    And I set fields
      | such  | VERPACK            |
      | guid  | DEFAULT-12:2-00001 |
      | name  | Mit Verpackung     |
      | name2 | With packaging     |
    And I delete all rows
    And I create a new row at the end of the table
    And I set field "posex" to "$,,guid==DEFAULT-2:4-00001" in row 1
    And I save the current editor
    Then fields have values
      | such  | VERPACK            |
      | guid  | DEFAULT-12:2-00001 |
      | name  | Mit Verpackung     |
      | name2 | With packaging     |
    And I close the current editor

  Scenario: Region Nordrhein-Westfalen anlegen
    Given I open an editor "Region/Land/Wirtschaftsraum" from table "97:1" with command "STORE" for search criteria "$,,guid==DEFAULT-97:1-00001"
    And I set fields
      | such   | NORDRHEIN-WESTFALEN  |
      | guid   | DEFAULT-97:1-00001   |
      | rname  | Nordrhein-Westfalen  |
      | rname2 | Nordrhein-Westfalen  |
      | typ    | (Region)             |
      | ueberg | 72                   |
      | typb   | Deutsches Bundesland |
      | kenn   | NRW                  |
      | laspra | Deutsch              |
      | ischl  | 05                   |
    And I save the current editor
    Then fields have values
      | such   | NORDRHEIN-WESTFALEN |
      | guid   | DEFAULT-97:1-00001  |
      | rname  | Nordrhein-Westfalen |
      | rname2 | Nordrhein-Westfalen |
    And I close the current editor

  Scenario: Lager anlegen
    Given I open an editor "Lager" from table "39:1" with command "STORE" for search criteria "$,,guid==DEFAULT-39:1-00001"
    And I set fields
      | such     | MAIN               |
      | guid     | DEFAULT-39:1-00001 |
      | name     | Hauptlager         |
      | name2    | Main warehouse     |
      | lgruppe  | 1                  |
      | disporel | ja                 |
      | auslief  | nein               |
      | lnullm   | nein               |
    And I save the current editor
    Then fields have values
      | such            | MAIN               |
      | guid            | DEFAULT-39:1-00001 |
      | name            | Hauptlager         |
      | name2           | Main warehouse     |
      | lgruppe^nummer  | 1                  |
      | disporel        | ja                 |
      | auslief         | nein               |
      | lnullm          | nein               |
    And I close the current editor

  Scenario: Schichtplan anlegen
    Given I open an editor "Schichtplan" from table "12:21" with command "STORE" for search criteria "$,,guid==DEFAULT-12:21-00001"
    And I set fields
      | such  | SNORMAL             |
      | guid  | DEFAULT-12:21-00001 |
      | name  | Normal              |
      | name2 | Normally            |
    And I delete all rows
    And I create a new row at the end of the table
    And I set field "schicht" to "1" in row 1
    And I set field "tplan1" to "$,,guid==DEFAULT-12:20-00001" in row 1
    And I set field "tplan2" to "$,,guid==DEFAULT-12:20-00001" in row 1
    And I set field "tplan3" to "$,,guid==DEFAULT-12:20-00001" in row 1
    And I set field "tplan4" to "$,,guid==DEFAULT-12:20-00001" in row 1
    And I set field "tplan5" to "$,,guid==DEFAULT-12:20-00001" in row 1
    And I set field "tplan6" to "$,,guid==DEFAULT-12:20-00001" in row 1
    And I set field "tplan7" to "$,,guid==DEFAULT-12:20-00001" in row 1
    And I save the current editor
    Then fields have values
      | such  | SNORMAL             |
      | guid  | DEFAULT-12:21-00001 |
      | name  | Normal              |
      | name2 | Normally            |
    And I close the current editor

  Scenario: Lagerplatz anlegen
    Given I open an editor "Lagerplatzkopf" from table "38:1" with command "STORE" for search criteria "$,,guid==DEFAULT-38:1-00001"
    And I set fields
      | such     | SRAW                                              |
      | guid     | DEFAULT-38:1-00001                                |
      | name     | Roh-/Hilfs-/Betriebsstoffe - Kassel               |
      | name2    | Raw Materials, Supplies, and Consumables - Kassel |
      | lager    | $,,guid==DEFAULT-39:1-00001                       |
      | disporel | ja                                                |
      | auslief  | nein                                              |
    And I save the current editor
    Then fields have values
      | such | SRAW                                |
      | guid | DEFAULT-38:1-00001                  |
    Then field "lager^guid" has value "DEFAULT-39:1-00001"
    And I close the current editor

  Scenario: Mitarbeiter anlegen
    Given I open an editor "Mitarbeiter" from table "11:1" with command "STORE" for search criteria "$,,guid==DEFAULT-11:1-00001"
    And I set fields
      | such  | ESCHARN                               |
      | guid  | DEFAULT-11:1-00001                    |
      | name  | Scharn, Martina                       |
      | name2 | Scharn, Martina                       |
      | ans   | Martina Scharn                        |
      | str   | Parkstraße 23                         |
      | plz   | 34119                                 |
      | nort  | Kassel                                |
      | staat | DEUTSCHLAND                           |
      | email | martina.scharn@saba-international.com |
      | kenn  | Cucumber Employee                     |
      | bem   | Einkauf                               |
      | splan | $,,guid==DEFAULT-12:21-00001          |
      | spra  | (German)                              |
      | waehr | EUR                                   |
      | lohn  | 1                                     |
    And I save the current editor
    Then fields have values
      | such  | ESCHARN            |
      | guid  | DEFAULT-11:1-00001 |
      | name  | Scharn, Martina    |
      | name2 | Scharn, Martina    |
    Then field "splan^guid" has value "DEFAULT-12:21-00001"
    And I close the current editor

  Scenario: Warengruppe anlegen
    Given I open an editor "Warengruppe" from table "12:28" with command "STORE" for search criteria "$,,guid==DEFAULT-12:28-00001"
    And I set fields
      | such            | WPURCHASE                                     |
      | guid            | DEFAULT-12:28-00001                           |
      | name            | Einkaufsteile (Preis des Zugangs)             |
      | name2           | Purchased inventory (cost of goods purchased) |
      | befuehr         | ja                                            |
      | lsmpr           | nein                                          |
      | wgkst           | $,,guid==DEFAULT-5:2-00002                    |
      | ekbewverf       | 2                                             |
      | bestausekso     | 10000                                         |
      | eksofuerbeist   | 1                                             |
      | bestgelniber    | 36300                                         |
      | bvaussozug      | 50000                                         |
      | bestausfert     | 10000                                         |
      | fertfuerbeist   | 0                                             |
      | bvausfertzug    | 50000                                         |
      | bvgkausfertzug  | 50000                                         |
      | bveksoinfert    | 50000                                         |
      | bveksoinserv    | 50000                                         |
      | bveksoinvk      | 50000                                         |
      | bveksoinman     | 50000                                         |
      | bveksoinbeist   | 50000                                         |
      | bvfertinfert    | 50000                                         |
      | bvfertinserv    | 50000                                         |
      | bvfertinvk      | 50000                                         |
      | bvfertinman     | 50000                                         |
      | bvfertinbeist   | 50000                                         |
      | bestabohnezu    | 10000                                         |
      | bvabohnezu      | 50000                                         |
      | bestausgelniber | 13700                                         |
      | lohnktr         | 59000                                         |
      | bvausumlager    | 50000                                         |
      | bvausumlagab    | 50000                                         |
      | bvausumlagzu    | 50000                                         |
      | bvausinventab   | 75000                                         |
      | bvausinventzu   | 75000                                         |
      | bewdiff         | 59000                                         |
    And I save the current editor
    Then fields have values
      | such  | WPURCHASE                                     |
      | guid  | DEFAULT-12:28-00001                           |
      | name  | Einkaufsteile (Preis des Zugangs)             |
      | name2 | Purchased inventory (cost of goods purchased) |
    Then field "wgkst^guid" has value "DEFAULT-5:2-00002"
    And I close the current editor

  Scenario: Kunde anlegen
    Given I open an editor "Kundenstamm" from table "0:1" with command "STORE" for search criteria "$,,guid==DEFAULT-0:1-00001"
    And I set fields
      | such     | CRING                       |
      | guid     | DEFAULT-0:1-00001           |
      | name     | Ring AG, 85045 Ingolstadt   |
      | name2    | Ring AG, 85045 Ingolstadt   |
      | ans      | Ring AG                     |
      | str      | Montan - Straße 88          |
      | plz      | 85045                       |
      | nort     | Ingoldstadt                 |
      | staat    | 72                          |
      | tele     | 0841 789 - 0                |
      | urlt     | www.ring-autowerke.de       |
      | anrede   | $,,guid==DEFAULT-12:3-00001 |
      | branche  | Automobilindustrie          |
      | merkmal2 | Messe                       |
      | merkmal3 | Europa                      |
      | gln      | 4007002912345               |
      | spra     | Deutsch                     |
      | waehr    | EUR                         |
      | ustid    | DE700290246                 |
      | frbez    | 78354                       |
      | prg      | DEFAULT-0:1-00001           |
      | rab      | DEFAULT-0:1-00001           |
      | rechnung | $,,guid==DEFAULT-12:2-00001 |
      | zbed     | $,,guid==DEFAULT-12:8-00001 |
    And I save the current editor
    Then fields have values
      | such  | CRING                     |
      | guid  | DEFAULT-0:1-00001         |
      | name  | Ring AG, 85045 Ingolstadt |
      | name2 | Ring AG, 85045 Ingolstadt |
    Then field "anrede^guid" has value "DEFAULT-12:3-00001"
    Then field "rechnung^guid" has value "DEFAULT-12:2-00001"
    Then field "zbed^guid" has value "DEFAULT-12:8-00001"
    And I close the current editor

  Scenario: Lieferant anlegen
    Given I open an editor "Lieferantenstamm" from table "1:1" with command "STORE" for search criteria "$,,guid==DEFAULT-1:1-00001"
    And I set fields
      | such    | SWOLF                       |
      | guid    | DEFAULT-1:1-00001           |
      | name    | Gießerei Wolf GmbH, Bochum  |
      | name2   | Gießerei Wolf GmbH, Bochum  |
      | ans     | Gießerei Wolf GmbH          |
      | str     | Auf den Holln 48            |
      | plz     | 44894                       |
      | nort    | Bochum                      |
      | region  | $,,guid==DEFAULT-97:1-00001 |
      | staat   | 72                          |
      | tele    | +49(0)234/6332901           |
      | urlt    | www.wolf-guss.de            |
      | anrede  | $,,guid==DEFAULT-12:3-00002 |
      | kontakt | Hartmann                    |
      | waehr   | EUR                         |
      | prg     | DEFAULT-1:1-00001           |
      | rab     | DEFAULT-1:1-00001           |
      | zbed    | $,,guid==DEFAULT-12:8-00001 |
    And I save the current editor
    Then fields have values
      | such  | SWOLF                      |
      | guid  | DEFAULT-1:1-00001          |
      | name  | Gießerei Wolf GmbH, Bochum |
      | name2 | Gießerei Wolf GmbH, Bochum |
    Then field "region^guid" has value "DEFAULT-97:1-00001"
    Then field "anrede^guid" has value "DEFAULT-12:3-00002"
    Then field "zbed^guid" has value "DEFAULT-12:8-00001"
    And I close the current editor

  Scenario: Bankverbindung anlegen
    Given I open an editor "Bankverbindung" from table "96:2" with command "STORE" for search criteria "$,,guid==DEFAULT-96:2-00001"
    And I set fields
      | such    | BGIESS                                                     |
      | guid    | DEFAULT-96:2-00001                                         |
      | konto   | $,,guid==DEFAULT-1:1-00001;@gruppe=1:1;@ablageart=(Active) |
      | koinh   | Gießerei Wolf GmbH                                         |
      | bank    | $,,guid==DEFAULT-96:1-00001                                |
      | iban    | DE92 4305 0001 0001 3001 77                                |
      | konum   | 1 300 177                                                  |
      | kowaehr | EUR                                                        |
    And I save the current editor
    Then fields have values
      | such    | BGIESS                      |
      | guid    | DEFAULT-96:2-00001          |
      | koinh   | Gießerei Wolf GmbH          |
      | iban    | DE92 4305 0001 0001 3001 77 |
      | konum   | 1 300 177                   |
      | kowaehr | EUR                         |
    Then field "bank^guid" has value "DEFAULT-96:1-00001"
    And I close the current editor

  Scenario: Lieferant Bankverbindung nachtraeglich setzen
    Given I open an editor "Lieferantenstamm" from table "1:1" with command "UPDATE" for search criteria "$,,guid==DEFAULT-1:1-00001"
    And I set field "bverb" to "$,,guid==DEFAULT-96:2-00001"
    And I save the current editor
    Then field "bverb^guid" has value "DEFAULT-96:2-00001"
    And I close the current editor

  Scenario: Artikel anlegen
    Given I open an editor "Artikelstamm" from table "2:1" with command "STORE" for search criteria "$,,guid==DEFAULT-2:1-00001"
    And I set fields
      | such         | CIMPELLER                          |
      | guid         | DEFAULT-2:1-00001                  |
      | name         | Laufrad Kreiselpumpe 3000          |
      | name2        | Impeller for Centrifugal Pump 3000 |
      | vkbez        | Laufrad Kreiselpumpe 3000          |
      | vkbez2       | Impeller for Centrifugal Pump 3000 |
      | vbez         | Laufrad Kreiselpumpe 3000          |
      | vbez2        | Impeller for Centrifugal Pump 3000 |
      | ebez         | Laufrad Kreiselpumpe 3000          |
      | ebez2        | Impeller for Centrifugal Pump 3000 |
      | vpr          | 40.00                              |
      | vwaehr       | EUR                                |
      | vpe          | Stück                              |
      | vprg         | DEFAULT-2:1-00001                  |
      | vrab         | DEFAULT-2:1-00001                  |
      | skfaehig     | ja                                 |
      | atlasrel     | ja                                 |
      | rerelev      | ja                                 |
      | dispoa       | (RequirementRelated)               |
      | bsart        | (ExternalProcurement)              |
      | earta        | (UsingProducts)                    |
      | mindest      | 100                                |
      | minbsmge     | 5                                  |
      | losgr        | 0                                  |
      | packgr       | 0                                  |
      | lggew        | 0,000                              |
      | dispgr       | 0                                  |
      | rundung      | 1                                  |
      | maxbsmge     | 20                                 |
      | losbild      | 15                                 |
      | bfrist       | 0                                  |
      | fixbfrist    | nein                               |
      | vfolge       | ja                                 |
      | abtlg        | $,,guid==DEFAULT-8:1-00001         |
      | zuplatz      | $,,guid==DEFAULT-38:1-00001        |
      | abplatz      | $,,guid==DEFAULT-38:1-00001        |
      | haltbarkeit  | 0                                  |
      | chimlager    | nein                               |
      | lnullm       | ja                                 |
      | invsperr     | nein                               |
      | vzaehlen     | nein                               |
      | gebvhe       | nein                               |
      | gebvpe       | nein                               |
      | gebehe       | nein                               |
      | gebepe       | nein                               |
      | gebve        | nein                               |
      | gebge        | nein                               |
      | serpflicht   | nein                               |
      | vkartdleist  | (Goods)                            |
      | vbrutto      | nein                               |
      | prov         | DEFAULT-2:1-00001                  |
      | ebetreuer    | $,,guid==DEFAULT-11:1-00001        |
      | ekartdleist  | (Goods)                            |
      | lief         | $,,guid==DEFAULT-1:1-00001         |
      | efrist       | 5                                  |
      | vorlauf      | 5                                  |
      | bstnr        | 855655                             |
      | epr          | 23.00                              |
      | ewaehr       | EUR                                |
      | epe1         | Stück                              |
      | ebrutto      | nein                               |
      | ehe1         | Stück                              |
      | basis        | 0                                  |
      | ibasis       | 0                                  |
      | archivkblatt | nein                               |
      | kbpr         | (PurchasePrice)                    |
      | ekpr         | 0,0000                             |
      | planpr1      | 0,0000                             |
      | planpr2      | 0,0000                             |
      | ekbewverf    | 0                                  |
      | wgruppe      | $,,guid==DEFAULT-12:28-00001       |
    And I save the current editor
    Then fields have values
      | such   | CIMPELLER                          |
      | guid   | DEFAULT-2:1-00001                  |
      | name   | Laufrad Kreiselpumpe 3000          |
      | name2  | Impeller for Centrifugal Pump 3000 |
      | vpr    | 40.00                              |
      | vwaehr | EUR                                |
      | epr    | 23.00                              |
      | ewaehr | EUR                                |
      | bstnr  | 855655                             |
    Then field "abtlg^guid" has value "DEFAULT-8:1-00001"
    Then field "zuplatz^guid" has value "DEFAULT-38:1-00001"
    Then field "abplatz^guid" has value "DEFAULT-38:1-00001"
    Then field "ebetreuer^guid" has value "DEFAULT-11:1-00001"
    Then field "lief^guid" has value "DEFAULT-1:1-00001"
    Then field "wgruppe^guid" has value "DEFAULT-12:28-00001"
    And I close the current editor
