# **********************************************************************************
#  Name             : cctransfer.feature
#  Autor            : bschiga
#  Verantwortlich   : bschiga
#  Kontrolle        : cl
#  Funktion         : Testet das Infosystem CCTRANSFER zum Buchen und erfassen von
#                   : Rückmeldungen
#  ref              : ref_fe_cctransfer_cu
#
# **********************************************************************************

@persistent
Feature: cctransfer.feature

Background:
And I set the fake date to "16.01.1995"

Scenario: 01 Stammdaten anlegen

Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
    | chpflicht   | ja  |
And I save the current editor

Given I open an editor "BASIS_FERT" from table "(Part):(BaseProduct)" with command "STORE" for record "BASIS_FERT"
And I set fields
    | such         | BASIS_FERT     |
    | namebspr     | Basisartikel 1 |
    | fbetreuer    | KARL           |
And I save the current editor

Given I open an editor "BASIS_OHNE" from table "(Part):(BaseProduct)" with command "STORE" for record "BASIS_OHNE"
And I set fields
    | such         | BASIS_OHNE                 |
    | namebspr     | Basisartikel ohne Version  |
And I save the current editor

Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set fields
    | such          | BG_VERS01             |
    | namebspr      | BG mit Basisartikel   |
    | bsart         | Eigenfertigung        |
    | basisartikel  | BASIS_FERT            |
    | index         | 01                    |
And I save the current editor

Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set fields
    | such          | BGCHARGE              |
    | namebspr      | BG Chargenverfolgung  |
    | bsart         | Eigenfertigung        |
    | chverfolgung  | Chargenverfolgung     |
    | fbetreuer     | TEST           |
And I save the current editor

Given I open an editor "BG1" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
And I set fields
    | fbetreuer     | KARL           |
And I save the current editor

Given I open an editor "Aufzaehlung" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "ARTIKELSPERRE"
And I set field "reosofort" to "ja"
And I delete all rows
And I append rows
    | aufzelem     | aebez                                |
    | PRODUCTLOCK  | Standard-Artikelsperre               |
    | PRODUCTNOTE  | Standard-Artikelsperre, nur Hinweise |
And I save the current editor


Scenario: 02 Ungebuchte Rueckmeldungen anlegen

Given I create a work order "BA1_BG1" for Product "BG1" with quantity "10" and search word "BA1_BG1_"
Given I create a work order "BA2_BG1" for Product "BG1" with quantity "10" and search word "BA2_BG1_"
Given I create a work order "BA3_BGCHARGE" for Product "BGCHARGE" with quantity "10" and search word "BA3_BGCHARGE_"
Given I create a work order "BA4_BG_VERS01" for Product "BG_VERS01" with quantity "10" and search word "BA4_BG_VERS01_"
Given I create a work order "BA5_V3" for Product "V3" with quantity "10" and search word "BA5_V3_"

#Given I open an editor "BA_CHVERFSTUFE1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "CHVERFSTUFE1_000"
#And I press button "absteig" to open a subeditor for "AFL"
#And I save the current editor
#And I switch the current editor to editor "BA_CHVERFSTUFE1"
#And I save the current editor

# ungebuchte Rueckmeldungen anlegen
Given I open an editor "RM1_BA1_BG1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA1_BG1_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | ma    | KARL  |
    | lgr   | 1     |
    | bzeit | 2     |
    | mzeit | 1     |
And I set field "gutmge" to "3" in row 1
And I save the current editor

# BA fuer externe Lagergruppe
Given I open an editor "BA_EXT" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge | lgruppe  | mfreig | bisuch   |
    | BG1       | 5      | BERLIN   | ja     | BA_EXT_  |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "BA_EXT"
And I save the current editor

Given I open an editor "RM_BA_EXT" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA_EXT_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | ma    | KARL  |
    | lgr   | 1     |
    | bzeit | 1     |
    | mzeit | 2     |
And I set field "gutmge" to "1" in row 1
And I save the current editor


Scenario: 03 Infosystem testen

And I open the infosystem "CCTRANSFER"
Then field "transfer" has value "ja"
Then field "done" has value "nein"
And I press start
Then the table has 2 rows
Then table has values
    | tmark | ticon | thinweis  | trueckmeldung^id  | tag   | tbzeit    | tmzeit    | tlgr  | tgutmge   | artikel   | basisartikel  | typa279     | tkstelle |
    | nein  |       |           | !RM1_BA1_BG1^id   | AG1   | 2         | 1         | 1     | 3         | BG1       |               | Rückmeldung | 101      |
    | nein  |       |           | !RM_BA_EXT^id     | AG1   | 1         | 2         | 1     | 1         | BG1       |               | Rückmeldung | 101      |
And I close the current editor

Given I open an editor "RM1_BA3_BGCHARGE" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA3_BGCHARGE_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | ma    | KARL  |
    | lgr   | 1     |
    | bzeit | 2     |
    | mzeit | 1     |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "RM1_BA5_V3" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA5_V3_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | ma    | KARL  |
    | lgr   | 1     |
    | bzeit | 2     |
    | mzeit | 1     |
And I set field "gutmge" to "2" in row 1
And I save the current editor

And I open the infosystem "CCTRANSFER"
And I press start
Then the table has 4 rows
Then table has values
    | trueckmeldung^id      | tgutmge   | tchzuordnung              | artikel   | basisartikel  | typa279     |
    | !RM1_BA1_BG1^id       | 3         |                           | BG1       |               | Rückmeldung |
    | !RM1_BA3_BGCHARGE^id  | 1         | icon:barcode_cross_red    | BGCHARGE  |               | Rückmeldung |
    | !RM1_BA5_V3^id        | 2         |                           | V3        |               | Rückmeldung |
    | !RM_BA_EXT^id         | 1         |                           | BG1       |               | Rückmeldung |
Then field "tmark" is not modifiable in row 2
And I press button "markieren"
Then field "tmark" has value "ja" in row 1
Then field "tmark" has value "nein" in row 2
Then field "tmark" has value "ja" in row 3
Then field "tmark" has value "ja" in row 4
And I press button "demarkieren"
Then field "tmark" has value "nein" in all rows
And I press button "markieren"
And I set field "tmark" to "nein" in row 3
And I press button "uebertragen"
Then table has values
    | tmark | ticon     | trueckmeldung^id      | tgutmge   | artikel   | basisartikel  | typa279     |
    | nein  | icon:ok   | !RM1_BA1_BG1^id       | 3         | BG1       |               | Rückmeldung |
    | nein  |           | !RM1_BA3_BGCHARGE^id  | 1         | BGCHARGE  |               | Rückmeldung |
    | nein  |           | !RM1_BA5_V3^id        | 2         | V3        |               | Rückmeldung |
    | nein  | icon:ok   | !RM_BA_EXT^id         | 1         | BG1       |               | Rückmeldung |
Then field "thinweis" is empty in row 1
Then field "thinweis" is empty in row 2
Then field "thinweis" is empty in row 3
Then field "thinweis" is empty in row 4
Then field "tmark" is not modifiable in row 1
Then field "tmark" is not modifiable in row 2
Then field "tmark" is modifiable in row 3
Then field "tmark" is not modifiable in row 4
And I press start
Then the table has 2 rows
And I close the current editor

# Artikel sperren, damit nicht gebucht werden kann
Given I open an editor "V3" from table "(Part):(Product)" with command "UPDATE" for record "V3"
And I set fields
    | sperrkonfigurationneu | Standard-Artikelsperre    |
And I save the current editor

And I open the infosystem "CCTRANSFER"
And I press start
Then the table has 2 rows
Then table has values
    | trueckmeldung^id      | tgutmge   | tchzuordnung              | artikel   | basisartikel  | typa279     |
    | !RM1_BA3_BGCHARGE^id  | 1         | icon:barcode_cross_red    | BGCHARGE  |               | Rückmeldung |
    | !RM1_BA5_V3^id        | 2         |                           | V3        |               | Rückmeldung |
And I press button "markieren"
And I press button "uebertragen"
Then table has values
    | tmark | ticon     | trueckmeldung^id      | tgutmge   | tchzuordnung              | artikel   | basisartikel  | typa279     |
    | nein  |           | !RM1_BA3_BGCHARGE^id  | 1         | icon:barcode_cross_red    | BGCHARGE  |               | Rückmeldung |
    | ja    | icon:stop | !RM1_BA5_V3^id        | 2         |                           | V3        |               | Rückmeldung |
Then field "thinweis" is empty in row 1
Then field "thinweis" is not empty in row 2
Then field "tmark" is not modifiable in row 1
Then field "tmark" is modifiable in row 2
And I close the current editor


Scenario: 04 Selektionen pruefen

Given I open an editor "RM1_BA4_BG_VERS01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA4_BG_VERS01_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | ma    | KARL  |
    | lgr   | 1     |
    | bzeit | 2     |
    | mzeit | 1     |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open an editor "RM2_BA_EXT" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA_EXT_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | ma    | KARL  |
    | lgr   | 1     |
    | bzeit | 1     |
    | mzeit | 2     |
And I set field "gutmge" to "3" in row 1
And I save the current editor

And I open the infosystem "CCTRANSFER"
And I press start
Then the table has 4 rows
Then table has values
    | trueckmeldung^id      | tgutmge   | tchzuordnung              | artikel   | basisartikel  | typa279     |
    | !RM1_BA3_BGCHARGE^id  | 1         | icon:barcode_cross_red    | BGCHARGE  |               | Rückmeldung |
    | !RM1_BA4_BG_VERS01^id | 1         |                           | BG_VERS01 | BASIS_FERT    | Rückmeldung |
    | !RM1_BA5_V3^id        | 2         |                           | V3        |               | Rückmeldung |
    | !RM2_BA_EXT^id        | 3         |                           | BG1       |               | Rückmeldung |
And I set field "kartikel" to "BG_VERS01"
Then field "kbasisartikel" has value "BASIS_FERT"
And I press start
Then the table has 1 rows
Then table has values
    | trueckmeldung^id      | tgutmge   | tchzuordnung              | artikel   | basisartikel  | typa279     |
    | !RM1_BA4_BG_VERS01^id | 1         |                           | BG_VERS01 | BASIS_FERT    | Rückmeldung |
And I set field "disponent" to "TEST"
Then the table has 0 rows
And I press start
And I set field "kartikel" to ""
And I set field "kbasisartikel" to ""
And I press start
Then the table has 1 rows
Then table has values
    | trueckmeldung^id      | tgutmge   | tchzuordnung              | artikel   | basisartikel  | typa279     |
    | !RM1_BA3_BGCHARGE^id  | 1         | icon:barcode_cross_red    | BGCHARGE  |               | Rückmeldung |
And I set field "disponent" to ""
And I set field "lgruppe" to "BERLIN"
And I press start
Then the table has 1 rows
Then table has values
    | !RM2_BA_EXT^id        | 3         |                           | BG1       |               | Rückmeldung |
# Feld lgruppe ist gefuellt, wenn auf Modus done umgestellt wird, werden Kopffelder geleert
And I set field "done" to "ja"
Then field "lgruppe" is empty
And I close the current editor
