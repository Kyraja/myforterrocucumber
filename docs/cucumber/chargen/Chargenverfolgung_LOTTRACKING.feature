# **********************************************************************************
#  Name             : Chargenverfolgung_LOTTRACKING.feature
#  Autor            : bschiga
#  Verantwortlich   : bschiga
#  Kontrolle        : cl
#  Funktion         : Testet das Infosystem LOTTRACKING zur Chargenverfolgung
#  ref              : ref_la_lottracking_cu
#
# **********************************************************************************

@persistent
Feature: Chargenverfolgung_LOTTRACKING.feature

Background:
And I set the fake date to "16.01.1995"

Scenario: 01 Stammdaten anlegen

Given I open an editor "BG01_CHARGE" from table "(Part):(Product)" with command "COPY" for record "BG01_CHARGE"
And I set fields
    | such          | BG_2ST_CHARGE           |
    | namebspr      | Baugruppe mit 2 Stufen  |
    | bsart         | Eigenfertigung          |
    | chverfolgung  | Chargenverfolgung       |
And I modify table
    | !row  | elex          | elanzahl  |
    | 1     | BG01_CHARGE   | 1         |
And I save the current editor

Given I open an editor "BG01_CHARGE" from table "(Part):(Product)" with command "COPY" for record "BG01_CHARGE"
And I set fields
    | such          | BG_3ST_CHARGE             |
    | namebspr      | Baugruppe mit 3 Stufen    |
    | bsart         | Eigenfertigung            |
    | chverfolgung  | Chargenverfolgung         |
And I modify table
    | !row  | elex          | elanzahl  |
    | 1     | BG_2ST_CHARGE | 1         |
And I delete row at position 4
And I delete row at position 3
And I save the current editor


Scenario: 02 Buchungen, um Chargenverfolgungsobjekte anzulegen, sowie Einkauf Material und Verkauf Baugruppen

Given I create a work order "BA_1STUFE" for Product "BG01_CHARGE" with quantity "50" and search word "CHVERFSTUFE1_"
Given I create a work order "BA_2STUFE" for Product "BG_2ST_CHARGE" with quantity "50" and search word "CHVERFSTUFE2_"
Given I create a work order "BA_3STUFE" for Product "BG_3ST_CHARGE" with quantity "50" and search word "CHVERFSTUFE3_"

Given I create a Lot "CHST1ZU1" for Product "BG01_CHARGE"
Given I create a Lot "CHST1ZU2" for Product "BG01_CHARGE"
Given I create a Lot "CHST2ZU1" for Product "BG_2ST_CHARGE"
Given I create a Lot "CHST2ZU2" for Product "BG_2ST_CHARGE"
Given I create a Lot "CHST3ZU1" for Product "BG_3ST_CHARGE"
Given I create a Lot "CHST3ZU2" for Product "BG_3ST_CHARGE"
Given I create a Lot "CHAB11" for Product "EK01_CHARGE"
Given I create a Lot "CHAB22" for Product "EK02_CHARGE"
Given I create a Lot "CHAB33" for Product "EK02_CHARGE"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_CHARGE   |
    | buart     | Zugang        |
    | beleg     | LBU_001       |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2       |
    | 50     | F1       | !CHAB11^id    |
And I save the current editor

Given I open an editor "EKRE_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | TEST     |
    | such   | EKRE_01  |
    | vom    | .        |
    | ueb    | ja       |
    | ebeleg | EKRE_01  |
And I modify table
    | !row | artikel        | mge | charge      |
    | +1   | EK01_CHARGE    | 20  | !CHAB11^id  |
#And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "EKLS_01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | TEST     |
    | such   | EKLS_01  |
    | ebeleg | EKLS_01  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge | charge      |
    | EK01_CHARGE   | 30  | !CHAB11^id  |
And I save the current editor

Given I open an editor "EKRE_02" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | TEST     |
    | vom    | .        |
    | ueb    | ja       |
    | such   | EKRE_02  |
    | ebeleg | EKRE_02  |
And I modify table
    | !row | artikel        | mge | charge      |
    | +1   | EK02_CHARGE    | 50  | !CHAB22^id  |
    | +2   | EK02_CHARGE    | 50  | !CHAB33^id  |
#And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "BA_CHVERFSTUFE1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "CHVERFSTUFE1_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 50       | CHAB11     |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 50       | CHAB22     |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_CHVERFSTUFE1"
And I save the current editor

# Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM1_CHVERFSTUFE1_002" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=CHVERFSTUFE1_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "CHST1ZU1"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge      | erbtext1 | tcharge     |
    | 1     | 25          | RM1_002  | !dontChange |
And I save the current editor

# Weitere Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM2_CHVERFSTUFE1_002" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=CHVERFSTUFE1_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "CHST1ZU2"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge      | erbtext1 | tcharge     |
    | 1     | 25          | RM2_002  | !dontChange |
And I save the current editor

## Chargenverfolgung pruefen
#Given I open an editor "CHVERF1_1_BG01_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST1ZU1;vcharge^exnum==CHAB11;elex==EK01_CHARGE;"
#And I close the current editor
#
#Given I open an editor "CHVERF1_2_BG01_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST1ZU1;vcharge^exnum==CHAB22;elex==EK02_CHARGE;"
#And I close the current editor
#
#Given I open an editor "CHVERF2_1_BG01_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST1ZU2;vcharge^exnum==CHAB11;elex==EK01_CHARGE;"
#And I close the current editor
#
#Given I open an editor "CHVERF2_2_BG01_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST1ZU2;vcharge^exnum==CHAB22;elex==EK02_CHARGE;"
#And I close the current editor

Given I open an editor "BA_CHVERFSTUFE2" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "CHVERFSTUFE2_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 25       | CHST1ZU1   |
    | +2    | F1     | 25       | CHST1ZU2   |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 50       | CHAB33     |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_CHVERFSTUFE2"
And I save the current editor

# Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM1_CHVERFSTUFE2_002" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=CHVERFSTUFE2_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "CHST2ZU1"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge      | erbtext1    | tcharge     |
    | 1     | 25          | RM1_ST2_002 | !dontChange |
And I save the current editor

# Weitere Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM2_CHVERFSTUFE2_002" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=CHVERFSTUFE2_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "CHST2ZU2"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge      | erbtext1    | tcharge     |
    | 1     | 25          | RM2_ST2_002 | !dontChange |
And I save the current editor

## Chargenverfolgung pruefen
#Given I open an editor "CHVERF1_1_BG_2ST_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST2ZU1;vcharge^exnum==CHST1ZU1;elex==BG01_CHARGE;"
#And I close the current editor
#
#Given I open an editor "CHVERF1_2_BG_2ST_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST2ZU2;vcharge^exnum==CHST1ZU2;elex==BG01_CHARGE;"
#And I close the current editor
#
#Given I open an editor "CHVERF2_1_BG_2ST_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST2ZU1;vcharge^exnum==CHAB33;elex==EK02_CHARGE;"
#And I close the current editor
#
#Given I open an editor "CHVERF2_2_BG_2ST_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST2ZU2;vcharge^exnum==CHAB33;elex==EK02_CHARGE;"
#And I close the current editor

Given I open an editor "BA_CHVERFSTUFE3" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "CHVERFSTUFE3_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 25       | CHST2ZU1   |
    | +2    | F1     | 25       | CHST2ZU2   |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_CHVERFSTUFE3"
And I save the current editor

# Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM1_CHVERFSTUFE3_001" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=CHVERFSTUFE3_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "CHST3ZU1"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge      | erbtext1    | tcharge     |
    | 1     | 25          | RM1_ST3_002 | !dontChange |
And I save the current editor

# Weitere Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM2_CHVERFSTUFE3_001" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=CHVERFSTUFE3_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "CHST3ZU2"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge      | erbtext1    | tcharge     |
    | 1     | 25          | RM2_ST3_002 | !dontChange |
And I save the current editor

## Chargenverfolgung pruefen
#Given I open an editor "CHVERF1_1_BG_3ST_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST3ZU1;vcharge^exnum==CHST2ZU1;elex==BG_2ST_CHARGE;"
#And I close the current editor
#
#Given I open an editor "CHVERF1_2_BG_3ST_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST3ZU2;vcharge^exnum==CHST2ZU2;elex==BG_2ST_CHARGE;"
#And I close the current editor

Given I open an editor "VKLS_01" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde  | TEST     |
    | such   | VKLS_01  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge | charge      |
    | BG_3ST_CHARGE | 10  | CHST3ZU1    |
And I save the current editor

Given I open an editor "VKLS_02" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde  | KUNDECH1 |
    | such   | VKLS_02  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge | charge      |
    | BG_3ST_CHARGE | 10  | CHST3ZU1    |
    | BG_3ST_CHARGE | 5   | CHST3ZU1    |
And I save the current editor


Scenario: 03 Rueckmeldungen externe Lagergruppe

Given I create a Lot "CHBG01AB1_EXT" for Product "BG01_CHARGE"
Given I create a Lot "CHBG01AB2_EXT" for Product "BG01_CHARGE"
Given I create a Lot "CHBGST2ZU1_EXT" for Product "BG_2ST_CHARGE"
Given I create a Lot "CHBGST2ZU2_EXT" for Product "BG_2ST_CHARGE"
Given I create a Lot "CHEK02AB1_EXT" for Product "EK02_CHARGE"

Given I open an editor "EKRE_03" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | TEST     |
    | such   | EKRE_03  |
    | vom    | .        |
    | ueb    | ja       |
    | ebeleg | EKRE_03  |
And I modify table
    | !row | artikel        | mge | platz   | charge            |
    | +1   | EK02_CHARGE    | 150 | L3F1    | !CHEK02AB1_EXT^id |
    | +1   | EK02_CHARGE    | 20  | F1      | !CHEK02AB1_EXT^id |
#And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "BA_EXT" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel       | netmge | lgruppe  | mfreig |
    | BG_2ST_CHARGE | 100    | BERLIN   | ja     |
And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | L3F1   | 50       | CHBG01AB1_EXT |
    | +2    | L3F1   | 50       | CHBG01AB2_EXT |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | L3F1   | 100      | CHEK02AB1_EXT |
And I save the current editor
And I switch the current editor to editor "BA_EXT"
And I set field "bisuch" to "BAEXT01_" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "BA_EXT"
And I save the current editor

# Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM1_BAEXT01_002" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BAEXT01_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "CHBGST2ZU1_EXT"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge      | erbtext1    | tcharge     |
    | 1     | 50          | RM1_EXT_002 | !dontChange |
And I save the current editor

# Weitere Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM2_BAEXT01_002" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BAEXT01_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "CHBGST2ZU2_EXT"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge      | erbtext1    | tcharge     |
    | 1     | 50          | RM2_EXT_002 | !dontChange |
And I save the current editor

## Chargenverfolgung pruefen
#Given I open an editor "CHVERF1_1_BG_2ST_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHBGST2ZU1_EXT;vcharge^exnum==CHBG01AB1_EXT;elex==BG01_CHARGE;"
#And I close the current editor
#
#Given I open an editor "CHVERF1_2_BG_2ST_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHBGST2ZU2_EXT;vcharge^exnum==CHBG01AB2_EXT;elex==BG01_CHARGE;"
#And I close the current editor
#
#Given I open an editor "CHVERF2_1_BG_2ST_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHBGST2ZU1_EXT;vcharge^exnum==CHEK02AB1_EXT;elex==EK02_CHARGE;"
#And I close the current editor
#
#Given I open an editor "CHVERF2_2_BG_2ST_CHARGE" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHBGST2ZU2_EXT;vcharge^exnum==CHEK02AB1_EXT;elex==EK02_CHARGE;"
#And I close the current editor
#
#Given I open an editor "CHBGST2ZU1_EXT" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=CHBGST2ZU1_EXT;@maxtreffer=1;@ablageart=lebendig"
#And I close the current editor
#
#Given I open an editor "CHBGST2ZU2_EXT" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=CHBGST2ZU2_EXT;@maxtreffer=1;@ablageart=lebendig"
#And I close the current editor

Given I open an editor "VKLS_03" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde  | KUNDECH1 |
    | such   | VKLS_03  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge | platz   | charge                |
    | BG_2ST_CHARGE | 10  | L3F1    | !CHBGST2ZU1_EXT^id    |
And I save the current editor

Given I open an editor "VKLS_04" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde  | KUNDECH1 |
    | such   | VKLS_04  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge | platz   | charge                |
    | BG_2ST_CHARGE | 15  | L3F1    | !CHBGST2ZU1_EXT^id    |
And I save the current editor

Given I open an editor "VKLS_05" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde  | KUNDECH1 |
    | such   | VKLS_05  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge | platz   | charge                |
    | BG_2ST_CHARGE | 25  | L3F1    | !CHBGST2ZU1_EXT^id    |
And I save the current editor

Given I open an editor "VKLS_06" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde  | KUNDECH1 |
    | such   | VKLS_06  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge | platz   | charge                |
    | BG_2ST_CHARGE | 40  | L3F1    | !CHBGST2ZU2_EXT^id    |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BG_2ST_CHARGE |
    | buart     | Umbuchung     |
    | beleg     | LBUUM_01      |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | platz2   | charge2               |
    | 10     | L3F1     | F3       | !CHBGST2ZU2_EXT^id    |
And I save the current editor


Scenario: 04 Doppelte externe Chargennummer fuer unterschiedliches Material
# zwei Chargen mit gleicher externer Chargennummer anlegen, um Selektion zu testen

Given I create a work order "BA04" for Product "BG01_CHARGE" with quantity "10" and search word "BA04_"

Given I open an editor "BA04" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA04_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 10       | 1010       |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 10       | 1010      |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA04"
And I save the current editor

# Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM_BA04_002" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA04_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "1010ZU"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge      | erbtext1    | tcharge     |
    | 1     | 10          | RM_BA04_002 | !dontChange |
And I save the current editor


Scenario: 04A Chargenverfolgungsobjekt mit identischer Zugangs- und Abgangscharge manuell anlegen

Given I open an editor "EXNUM1010" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum==1010;artikel==EK01_CHARGE;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "chverf_manuell" from table "(Lots):(LotTracking)" with command "NEW" for record ""
And I set fields
    | such      | MANUELL       |
    | fartikel  | EK01_CHARGE   |
    | ncharge   | !EXNUM1010^id |
    | elex      | EK01_CHARGE   |
    | vcharge   | !EXNUM1010^id |
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "chverfherkunft" has value "manuell"
And I save the current editor


Scenario: 05 Chargenverfolgungsobjekt fuer Umchargieren
# Teilmenge von bereits zugebuchter Charge umchargieren, EK und BG

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BG_2ST_CHARGE |
    | buart     | Umbuchung     |
    | beleg     | LBUUM_05BG    |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | platz2   | charge1               | tcharge2       |
    | 1      | F3       | F2       | !CHBGST2ZU2_EXT^id    | UMCHARGE_01_BG |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK02_CHARGE   |
    | buart     | Umbuchung     |
    | beleg     | LBUUM_05EK    |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | platz2   | charge1            | tcharge2       |
    | 1      | F1       | F2       | !CHEK02AB1_EXT^id  | UMCHARGE_02_EK |
And I save the current editor

# neue Charge weiter verbauen
Given I create a work order "BA_UMCHA" for Product "BG01_CHARGE" with quantity "1" and search word "BA_UMCHA_"

Given I open an editor "BA_UMCHA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA_UMCHA_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 1        | CHA_NEU    |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge           |
    | +1    | F1     | 1        | UMCHARGE_02_EK    |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_UMCHA"
And I save the current editor

Given I open an editor "RM_BA_UMCHA_002" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA_UMCHA_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "tkcharge" to "CHAZU_NEU"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge    |
    | 1     | 1         |
And I save the current editor


Scenario: 06 Chargenverfolgungsobjekte mit Storno und Rueckbau buchen

Given I create a work order "BA_RUECK" for Product "BG01_CHARGE" with quantity "50" and search word "BA_RUECK_"
Given I create a work order "BA_STORNO" for Product "BG01_CHARGE" with quantity "10" and search word "BA_STORNO_"

Given I create a Lot "CHZU1RUECK" for Product "BG01_CHARGE"
Given I create a Lot "CHZU2STORNO" for Product "BG01_CHARGE"
Given I create a Lot "CHAB1RUECK" for Product "EK01_CHARGE"
Given I create a Lot "CHAB2RUECK" for Product "EK02_CHARGE"
Given I create a Lot "CHAB1STORNO" for Product "EK01_CHARGE"
Given I create a Lot "CHAB2STORNO" for Product "EK02_CHARGE"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_CHARGE   |
    | buart     | Zugang        |
    | beleg     | LBU_1_06      |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2           |
    | 50     | F1       | !CHAB1RUECK^id    |
    | 10     | F1       | !CHAB1STORNO^id   |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK02_CHARGE   |
    | buart     | Zugang        |
    | beleg     | LBU_2_06      |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2           |
    | 50     | F1       | !CHAB2RUECK^id    |
    | 10     | F1       | !CHAB2STORNO^id   |
And I save the current editor

Given I open an editor "EKRE_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | TEST     |
    | vom    | .        |
    | ueb    | ja       |
    | ebeleg | EKRE_01  |
And I modify table
    | !row | artikel        | mge | charge          |
    | +1   | EK01_CHARGE    | 50  | !CHAB1RUECK^id  |
    | +2   | EK01_CHARGE    | 10  | !CHAB1STORNO^id |
    | +3   | EK02_CHARGE    | 50  | !CHAB2RUECK^id  |
    | +4   | EK02_CHARGE    | 10  | !CHAB2STORNO^id |
#And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "BA_RUECK" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA_RUECK_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 50       | CHAB1RUECK |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge    |
    | +1    | F1     | 50       | CHAB2RUECK |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_RUECK"
And I save the current editor

# Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM1_BA_RUECK_002" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA_RUECK_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "kcharge" to "CHZU1RUECK"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge      | erbtext1 | tcharge     |
    | 1     | 25          | RM1_002  | !dontChange |
And I save the current editor

# Weitere Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM1_BA_RUECK_002" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA_RUECK_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "kcharge" to "CHZU1RUECK"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge      | erbtext1 | tcharge     |
    | 1     | 10          | RM1_002  | !dontChange |
And I save the current editor

# Rueckbau buchen
Given I open an editor "Rueckbau_AS2" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=BA_RUECK_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | kcharge   | CHZU1RUECK    |
And I set field "gutmge" to "-10" in row 1
And I save the current editor

# restliche Menge Rueckbau buchen
Given I open an editor "Rueckbau_AS2" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=BA_RUECK_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | kcharge   | CHZU1RUECK    |
And I set field "gutmge" to "-15" in row 1
And I save the current editor

# Storno
Given I open an editor "BA_STORNO" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA_STORNO_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 10       | CHAB1STORNO   |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 10       | CHAB2STORNO   |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_STORNO"
And I save the current editor

# Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung
Given I open an editor "RM1_BA_STORNO_002" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA_STORNO_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "kcharge" to "CHZU2STORNO"
And I set field "sofort" to "ja"
And I modify table
    | !row  | gutmge      | tcharge     |
    | 1     | 5           | !dontChange |
And I save the current editor

# Rueckmeldung stornieren
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BA_STORNO_002;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
And I save the current editor


Scenario: IS01 Plausis und Stufen testen im Infosystem

# Chargenverfolgungsobjekte oeffnen, um Zugriff auf Felder zu haben fuer Vergleich im Infosystem
Given I open an editor "CHVERF1_1" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST1ZU1;vcharge^exnum==CHAB11;elex==EK01_CHARGE;"
And I close the current editor

Given I open an editor "CHVERF1_2" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST2ZU1;vcharge^exnum==CHST1ZU1;elex==BG01_CHARGE;"
And I close the current editor

Given I open an editor "CHVERF1_3" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST3ZU1;vcharge^exnum==CHST2ZU1;elex==BG_2ST_CHARGE;"
And I close the current editor

Given I open an editor "CHVERF2_1" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST1ZU2;vcharge^exnum==CHAB11;elex==EK01_CHARGE;"
And I close the current editor

Given I open an editor "CHVERF2_2" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST2ZU2;vcharge^exnum==CHST1ZU2;elex==BG01_CHARGE;"
And I close the current editor

Given I open an editor "CHVERF2_3" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST3ZU2;vcharge^exnum==CHST2ZU2;elex==BG_2ST_CHARGE;"
And I close the current editor

Given I open the infosystem "LOTTRACKING"
## Meldung kann nicht abgefragt werden, ACK anstatt NAK
#Then pressing button "bstart" throws the exception "Bitte Charge/Seriennummer eingeben."
And I press start
Then the table has 0 rows
And I set field "charge" to "CHAB11"
Then field "exnum" has value "CHAB11"
Then field "richtung" has value "vorwärts"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 3 rows
And I set field "richtung" to "vorwärts"
And I set field "lgruppe" to "BERLIN"
And I press start
Then the table has 0 rows
#Then pressing button "bstart" throws the exception "Kein Chargenverfolgungsobjekt zur angegebenen Charge/Seriennummer CHAB11, Lagergruppe BERLIN und Richtung vorwärts auf erster Stufe vorhanden."
And I set field "lgruppe" to ""
And I press start
Then the table has 3 rows
Then table has values
    | tbaumstufe    | aufzu                 | tchverfobj    | tfartikel     | ttncharge | ttvcharge | tlgruppe  |
    | 1             | icon:folder_closed    | !CHVERF1_1^id | BG01_CHARGE   | CHST1ZU1  | CHAB11    | KARLSRUHE |
    | 0             |                       |               |               |           |           |           |
    | 1             | icon:folder_closed    | !CHVERF2_1^id | BG01_CHARGE   | CHST1ZU2  | CHAB11    | KARLSRUHE |
And I press button "auf"
Then the table has 10 rows
Then table has values
    | tbaumstufe    | aufzu                 | tchverfobj    | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_opened    | !CHVERF1_1^id | BG01_CHARGE   | CHST1ZU1  | EK01_CHARGE   | CHAB11    | KARLSRUHE |
    | 2             | icon:folder_opened    | !CHVERF1_2^id | BG_2ST_CHARGE | CHST2ZU1  | BG01_CHARGE   | CHST1ZU1  | KARLSRUHE |
    | 3             | icon:folder_opened    | !CHVERF1_3^id | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
    | 4             |                       |               |               |           | BG_3ST_CHARGE | CHST3ZU1  | KARLSRUHE |
    | 4             |                       |               |               |           | BG_3ST_CHARGE | CHST3ZU1  | KARLSRUHE |
    | 4             |                       |               |               |           | BG_3ST_CHARGE | CHST3ZU1  | KARLSRUHE |
    | 0             |                       |               |               |           |               |           |           |
    | 1             | icon:folder_opened    | !CHVERF2_1^id | BG01_CHARGE   | CHST1ZU2  | EK01_CHARGE   | CHAB11    | KARLSRUHE |
    | 2             | icon:folder_opened    | !CHVERF2_2^id | BG_2ST_CHARGE | CHST2ZU2  | BG01_CHARGE   | CHST1ZU2  | KARLSRUHE |
    | 3             |                       | !CHVERF2_3^id | BG_3ST_CHARGE | CHST3ZU2  | BG_2ST_CHARGE | CHST2ZU2  | KARLSRUHE |
And I press button "zu"
Then the table has 3 rows
Then table has values
    | tbaumstufe    | aufzu                 | tchverfobj    | tfartikel     | ttncharge | ttvcharge | tlgruppe  |
    | 1             | icon:folder_closed    | !CHVERF1_1^id | BG01_CHARGE   | CHST1ZU1  | CHAB11    | KARLSRUHE |
    | 0             |                       |               |               |           |           |           |
    | 1             | icon:folder_closed    | !CHVERF2_1^id | BG01_CHARGE   | CHST1ZU2  | CHAB11    | KARLSRUHE |
And I press button "aufzu" in row 3
Then the table has 4 rows
Then table has values
    | tbaumstufe    | aufzu                 | tchverfobj    | tfartikel     | ttncharge | ttvcharge | tlgruppe  |
    | 1             | icon:folder_closed    | !CHVERF1_1^id | BG01_CHARGE   | CHST1ZU1  | CHAB11    | KARLSRUHE |
    | 0             |                       |               |               |           |           |           |
    | 1             | icon:folder_opened    | !CHVERF2_1^id | BG01_CHARGE   | CHST1ZU2  | CHAB11    | KARLSRUHE |
    | 2             | icon:folder_closed    | !CHVERF2_2^id | BG_2ST_CHARGE | CHST2ZU2  | CHST1ZU2  | KARLSRUHE |
And I press button "aufzu" in row 4
Then the table has 5 rows
Then table has values
    | tbaumstufe    | aufzu                 | tchverfobj    | tfartikel     | ttncharge | ttvcharge | tlgruppe  |
    | 1             | icon:folder_closed    | !CHVERF1_1^id | BG01_CHARGE   | CHST1ZU1  | CHAB11    | KARLSRUHE |
    | 0             |                       |               |               |           |           |           |
    | 1             | icon:folder_opened    | !CHVERF2_1^id | BG01_CHARGE   | CHST1ZU2  | CHAB11    | KARLSRUHE |
    | 2             | icon:folder_opened    | !CHVERF2_2^id | BG_2ST_CHARGE | CHST2ZU2  | CHST1ZU2  | KARLSRUHE |
    | 3             |                       | !CHVERF2_3^id | BG_3ST_CHARGE | CHST3ZU2  | CHST2ZU2  | KARLSRUHE |
And I press button "aufzu" in row 4
Then the table has 4 rows
Then table has values
    | tbaumstufe    | aufzu                 | tchverfobj    | tfartikel     | ttncharge | ttvcharge | tlgruppe  |
    | 1             | icon:folder_closed    | !CHVERF1_1^id | BG01_CHARGE   | CHST1ZU1  | CHAB11    | KARLSRUHE |
    | 0             |                       |               |               |           |           |           |
    | 1             | icon:folder_opened    | !CHVERF2_1^id | BG01_CHARGE   | CHST1ZU2  | CHAB11    | KARLSRUHE |
    | 2             | icon:folder_closed    | !CHVERF2_2^id | BG_2ST_CHARGE | CHST2ZU2  | CHST1ZU2  | KARLSRUHE |
And I close the current editor


Scenario: 07 Rueckbau ohne Chargenverfolgungsobjekte, werden bei Randbewegungen nicht selektiert

Given I create a work order "BA_RUECK_O" for Product "BG02_CHARGE" with quantity "10" and search word "BA_RUECK_O_"

Given I create a Lot "CHZUOHNEAB" for Product "BG02_CHARGE"

# Rueckmeldung auf zweiten Arbeitsschein, Zugangsbuchung mit Zugangscharge aber ohne Abgangscharge
Given I open an editor "RM1_BA_RUECK_O_002" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA_RUECK_O_002;@richtung=rückwärts;@maxordtreffer=1"
And I set field "kcharge" to "CHZUOHNEAB"
And I set field "sofort" to "ja"
And I set field "gutmge" to "8" in row 1
And I save the current editor

# Rueckbau buchen
Given I open an editor "RUECK1_AS2" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=BA_RUECK_O_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | kcharge   | CHZUOHNEAB    |
And I set field "gutmge" to "-5" in row 1
And I save the current editor

# keine chverfobj, RM wird als Randbewegung gefunden, vorwaerts keine Abgaenge und rueckwaerts nur eine Zugangsbuchung, Rueckbau wird nicht selektiert
Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHZUOHNEAB"
Then field "richtung" has value "vorwärts"
And I press start
Then the table has 0 rows
And I set field "charge" to "CHZUOHNEAB"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 1 rows
Then field "detursache" has value "Rückmeldung Fertigung" in row 1
And I close the current editor

# Rueckbau buchen, restliche Menge
Given I open an editor "RUECK2_AS2" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=BA_RUECK_O_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | kcharge   | CHZUOHNEAB    |
And I set field "gutmge" to "-3" in row 1
And I save the current editor

# kein Zugang mehr, da komplette Menge rueckgebaut
Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHZUOHNEAB"
Then field "richtung" has value "vorwärts"
And I press start
Then the table has 0 rows
And I set field "charge" to "CHZUOHNEAB"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 0 rows
And I close the current editor

# Rueckbau stornieren
Given I open an editor "STORNO_RUECK" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RUECK2_AS2"
And I save the current editor

# Rueckbau storniert, Zugang wieder zu sehen
Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHZUOHNEAB"
Then field "richtung" has value "vorwärts"
And I press start
Then the table has 0 rows
And I set field "charge" to "CHZUOHNEAB"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 1 rows
Then field "detursache" has value "Rückmeldung Fertigung" in row 1
And I close the current editor


Scenario: IS02 Storno Fertigungsbelege werden nicht angezeigt

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHAB1STORNO"
Then field "richtung" has value "vorwärts"
And I press start
Then the table has 0 rows
And I set field "charge" to "CHZU2STORNO"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 0 rows
And I close the current editor


Scenario: IS04 Ruecklieferungen und Stornos werden bei Randbewegungen nicht selektiert

Given I open an editor "EKLS_02" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | TEST     |
    | such   | EKLS_02  |
    | ebeleg | EKLS_02  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge | charge      |
    | EK02_CHARGE   | 30  | !CHAB22^id  |
And I save the current editor

Given I open an editor "EKLS_02" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "EKLS_02"
And I save value from field "id" in row 1
And I close the current editor

Given I open an editor "EKRE_02" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+EKRE_02"
And I close the current editor

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHAB22"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 2 rows
Then table has values
    | detursache                | tzbeweg^kopf^such  |
    | Rechnung                  | EKRE_02            |
    | Lieferschein Einkauf      | EKLS_02            |
Then field "tzbeweg^id" in row 2 equals saved value
And I close the current editor

# Teilmenge rueckliefern
Given I open an editor "EKRLS_1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "EKLS_02"
And I set fields
    | such      | RLS_02_1  |
    | ebeleg    | RLS_02_1  |
    | ueb       | ja        |
Then table has values
    | artikel       | charge^such   |
    | EK02_CHARGE   | CHAB22        |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Lieferschein wird weiterhin angezeigt, Ruecklieferschein nicht
Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHAB22"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 2 rows
Then table has values
    | detursache                |
    | Rechnung                  |
    | Lieferschein Einkauf      |
Then field "tzbeweg^id" in row 2 equals saved value
And I close the current editor

# Restmenge rueckliefern
Given I open an editor "EKRLS_2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "EKLS_02"
And I set fields
    | such      | RLS_02_2  |
    | ebeleg    | RLS_02_2  |
    | ueb       | ja        |
Then table has values
    | artikel       | charge^such   |
    | EK02_CHARGE   | CHAB22        |
And I set field "mge" to "-20" in row 1
And I save the current editor

# Lieferschein wird nicht mehr angezeigt, Ruecklieferschein auch nicht
Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHAB22"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 1 rows
Then table has values
    | detursache                |
    | Rechnung                  |
And I close the current editor

Given I open an editor "STORNOEKRLS_2" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "EKRLS_2"
And I save the current editor

# Ruecklieferschein storniert, Lieferschein wird wieder angezeigt
Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHAB22"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 2 rows
Then table has values
    | detursache                |
    | Rechnung                  |
    | Lieferschein Einkauf      |
Then field "tzbeweg^id" in row 2 equals saved value
And I close the current editor

# zweiten Ruecklieferscheine stornieren
Given I open an editor "STORNOEKRLS_1" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "EKRLS_1"
And I save the current editor

# urspruenglichen Lieferschein stornieren (Zugang)
Given I open an editor "STORNOEKLS_02" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "EKLS_02"
And I save the current editor

# Lieferschein wird nicht mehr angezeigt, Ruecklieferschein auch nicht
Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHAB22"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 1 rows
Then table has values
    | detursache                |
    | Rechnung                  |
And I close the current editor


Scenario: IS05 Button Aufklappen wenn es nichts aufzuklappen gibt

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHAB11"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 3 rows
Then table has values
    | aufzu | detursache                |
    |       | Manueller Zugang          |
    |       | Rechnung                  |
    |       | Lieferschein Einkauf      |
And I press button "auf"
Then the table has 3 rows
Then table has values
    | aufzu | detursache                |
    |       | Manueller Zugang          |
    |       | Rechnung                  |
    |       | Lieferschein Einkauf      |
And I close the current editor


Scenario: IS06 Ordnersymbol und aufklappen pruefen, bei einer Zeile mit und einer Zeile ohne Randbewegung

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHBGST2ZU1_EXT"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 3 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge         | ttvcharge     | tlgruppe  |
    | 1             | icon:folder_closed    | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | CHEK02AB1_EXT | BERLIN    |
    | 0             |                       |               |                   |               |           |
    | 1             |                       | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | CHBG01AB1_EXT | BERLIN    |
And I press button "auf"
Then the table has 5 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge         | detursache        | ttvcharge     | tlgruppe  |
    | 1             | icon:folder_opened    | BG_2ST_CHARGE | CHBGST2ZU1_EXT    |                   | CHEK02AB1_EXT | BERLIN    |
    | 2             |                       | EK02_CHARGE   | CHEK02AB1_EXT     | Rechnung          |               | KARLSRUHE |
    | 2             |                       | EK02_CHARGE   | CHEK02AB1_EXT     | Rechnung          |               | BERLIN    |
    | 0             |                       |               |                   | ----------------  |               |           |
    | 1             |                       | BG_2ST_CHARGE | CHBGST2ZU1_EXT    |                   | CHBG01AB1_EXT | BERLIN    |
And I close the current editor


Scenario: IS07 Stufen testen im Infosystem, Alles aufklappen bei Zwischenstufen mit und ohne Randbewegung

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHST3ZU1"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 1 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_closed    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
And I press button "auf"
Then the table has 10 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_opened    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
    | 2             | icon:folder_opened    | BG_2ST_CHARGE | CHST2ZU1  | EK02_CHARGE   | CHAB33    | KARLSRUHE |
    | 3             |                       | EK02_CHARGE   | CHAB33    |               |           | KARLSRUHE |
    | 2             | icon:folder_opened    | BG_2ST_CHARGE | CHST2ZU1  | BG01_CHARGE   | CHST1ZU1  | KARLSRUHE |
    | 3             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU1  | EK01_CHARGE   | CHAB11    | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 3             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU1  | EK02_CHARGE   | CHAB22    | KARLSRUHE |
    | 4             |                       | EK02_CHARGE   | CHAB22    |               |           | KARLSRUHE |
And I press button "zu"
Then the table has 1 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_closed    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
And I press button "aufzu" in row 1
Then the table has 3 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_opened    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
    | 2             | icon:folder_closed    | BG_2ST_CHARGE | CHST2ZU1  | EK02_CHARGE   | CHAB33    | KARLSRUHE |
    | 2             | icon:folder_closed    | BG_2ST_CHARGE | CHST2ZU1  | BG01_CHARGE   | CHST1ZU1  | KARLSRUHE |
And I press button "aufzu" in row 3
Then the table has 5 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_opened    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
    | 2             | icon:folder_closed    | BG_2ST_CHARGE | CHST2ZU1  | EK02_CHARGE   | CHAB33    | KARLSRUHE |
    | 2             | icon:folder_opened    | BG_2ST_CHARGE | CHST2ZU1  | BG01_CHARGE   | CHST1ZU1  | KARLSRUHE |
    | 3             | icon:folder_closed    | BG01_CHARGE   | CHST1ZU1  | EK01_CHARGE   | CHAB11    | KARLSRUHE |
    | 3             | icon:folder_closed    | BG01_CHARGE   | CHST1ZU1  | EK02_CHARGE   | CHAB22    | KARLSRUHE |
And I press button "aufzu" in row 4
Then the table has 8 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_opened    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
    | 2             | icon:folder_closed    | BG_2ST_CHARGE | CHST2ZU1  | EK02_CHARGE   | CHAB33    | KARLSRUHE |
    | 2             | icon:folder_opened    | BG_2ST_CHARGE | CHST2ZU1  | BG01_CHARGE   | CHST1ZU1  | KARLSRUHE |
    | 3             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU1  | EK01_CHARGE   | CHAB11    | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 3             | icon:folder_closed    | BG01_CHARGE   | CHST1ZU1  | EK02_CHARGE   | CHAB22    | KARLSRUHE |
And I press button "aufzu" in row 8
Then the table has 9 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_opened    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
    | 2             | icon:folder_closed    | BG_2ST_CHARGE | CHST2ZU1  | EK02_CHARGE   | CHAB33    | KARLSRUHE |
    | 2             | icon:folder_opened    | BG_2ST_CHARGE | CHST2ZU1  | BG01_CHARGE   | CHST1ZU1  | KARLSRUHE |
    | 3             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU1  | EK01_CHARGE   | CHAB11    | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 3             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU1  | EK02_CHARGE   | CHAB22    | KARLSRUHE |
    | 4             |                       | EK02_CHARGE   | CHAB22    |               |           | KARLSRUHE |
And I press button "aufzu" in row 2
Then the table has 10 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_opened    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
    | 2             | icon:folder_opened    | BG_2ST_CHARGE | CHST2ZU1  | EK02_CHARGE   | CHAB33    | KARLSRUHE |
    | 3             |                       | EK02_CHARGE   | CHAB33    |               |           | KARLSRUHE |
    | 2             | icon:folder_opened    | BG_2ST_CHARGE | CHST2ZU1  | BG01_CHARGE   | CHST1ZU1  | KARLSRUHE |
    | 3             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU1  | EK01_CHARGE   | CHAB11    | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 3             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU1  | EK02_CHARGE   | CHAB22    | KARLSRUHE |
    | 4             |                       | EK02_CHARGE   | CHAB22    |               |           | KARLSRUHE |
And I press button "aufzu" in row 1
Then the table has 1 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_closed    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
And I close the current editor

Given I open an editor "STORNOEKRE_02" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+EKRE_02"
And I save the current editor

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHST3ZU1"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 1 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_closed    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
And I press button "auf"
Then the table has 8 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_opened    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
    | 2             |                       | BG_2ST_CHARGE | CHST2ZU1  | EK02_CHARGE   | CHAB33    | KARLSRUHE |
    | 2             | icon:folder_opened    | BG_2ST_CHARGE | CHST2ZU1  | BG01_CHARGE   | CHST1ZU1  | KARLSRUHE |
    | 3             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU1  | EK01_CHARGE   | CHAB11    | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 3             |                       | BG01_CHARGE   | CHST1ZU1  | EK02_CHARGE   | CHAB22    | KARLSRUHE |
And I press button "zu"
Then the table has 1 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_closed    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
And I press button "aufzu" in row 1
Then the table has 3 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_opened    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
    | 2             |                       | BG_2ST_CHARGE | CHST2ZU1  | EK02_CHARGE   | CHAB33    | KARLSRUHE |
    | 2             | icon:folder_closed    | BG_2ST_CHARGE | CHST2ZU1  | BG01_CHARGE   | CHST1ZU1  | KARLSRUHE |
And I press button "aufzu" in row 3
Then the table has 5 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_opened    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
    | 2             |                       | BG_2ST_CHARGE | CHST2ZU1  | EK02_CHARGE   | CHAB33    | KARLSRUHE |
    | 2             | icon:folder_opened    | BG_2ST_CHARGE | CHST2ZU1  | BG01_CHARGE   | CHST1ZU1  | KARLSRUHE |
    | 3             | icon:folder_closed    | BG01_CHARGE   | CHST1ZU1  | EK01_CHARGE   | CHAB11    | KARLSRUHE |
    | 3             |                       | BG01_CHARGE   | CHST1ZU1  | EK02_CHARGE   | CHAB22    | KARLSRUHE |
And I press button "aufzu" in row 4
Then the table has 8 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_opened    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
    | 2             |                       | BG_2ST_CHARGE | CHST2ZU1  | EK02_CHARGE   | CHAB33    | KARLSRUHE |
    | 2             | icon:folder_opened    | BG_2ST_CHARGE | CHST2ZU1  | BG01_CHARGE   | CHST1ZU1  | KARLSRUHE |
    | 3             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU1  | EK01_CHARGE   | CHAB11    | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 4             |                       | EK01_CHARGE   | CHAB11    |               |           | KARLSRUHE |
    | 3             |                       | BG01_CHARGE   | CHST1ZU1  | EK02_CHARGE   | CHAB22    | KARLSRUHE |
And I press button "aufzu" in row 3
Then the table has 3 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_opened    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
    | 2             |                       | BG_2ST_CHARGE | CHST2ZU1  | EK02_CHARGE   | CHAB33    | KARLSRUHE |
    | 2             | icon:folder_closed    | BG_2ST_CHARGE | CHST2ZU1  | BG01_CHARGE   | CHST1ZU1  | KARLSRUHE |
And I press button "aufzu" in row 1
Then the table has 1 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | telex         | ttvcharge | tlgruppe  |
    | 1             | icon:folder_closed    | BG_3ST_CHARGE | CHST3ZU1  | BG_2ST_CHARGE | CHST2ZU1  | KARLSRUHE |
And I close the current editor


Scenario: IS08 Selektion nach Lagergruppen pruefen, mit und ohne Randbewegung

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHBGST2ZU1_EXT"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 3 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge         | ttvcharge     | tlgruppe  |
    | 1             | icon:folder_closed    | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | CHEK02AB1_EXT | BERLIN    |
    | 0             |                       |               |                   |               |           |
    | 1             |                       | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | CHBG01AB1_EXT | BERLIN    |
And I press button "auf"
Then the table has 5 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge         | detursache        | ttvcharge     | tlgruppe  |
    | 1             | icon:folder_opened    | BG_2ST_CHARGE | CHBGST2ZU1_EXT    |                   | CHEK02AB1_EXT | BERLIN    |
    | 2             |                       | EK02_CHARGE   | CHEK02AB1_EXT     | Rechnung          |               | KARLSRUHE |
    | 2             |                       | EK02_CHARGE   | CHEK02AB1_EXT     | Rechnung          |               | BERLIN    |
    | 0             |                       |               |                   | ----------------  |               |           |
    | 1             |                       | BG_2ST_CHARGE | CHBGST2ZU1_EXT    |                   | CHBG01AB1_EXT | BERLIN    |
And I set field "lgruppe" to "BERLIN"
And I press start
Then the table has 3 rows
And I press button "auf"
Then the table has 4 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge         | detursache        | ttvcharge     | tlgruppe  |
    | 1             | icon:folder_opened    | BG_2ST_CHARGE | CHBGST2ZU1_EXT    |                   | CHEK02AB1_EXT | BERLIN    |
    | 2             |                       | EK02_CHARGE   | CHEK02AB1_EXT     | Rechnung          |               | BERLIN    |
    | 0             |                       |               |                   | ----------------  |               |           |
    | 1             |                       | BG_2ST_CHARGE | CHBGST2ZU1_EXT    |                   | CHBG01AB1_EXT | BERLIN    |
And I set field "lgruppe" to "HONGKONG"
And I press start
Then the table has 0 rows
And I set field "lgruppe" to "KARLSRUHE"
And I press start
# die Zeile mit Lagergruppe KARLSRUHE wird nicht gefunden, weil diese zu Charge CHEK02AB1_EXT gehoert, die aber nur gefunden wird, wenn BERLIN mit selektiert wird
Then the table has 0 rows
And I close the current editor

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHEK02AB1_EXT"
And I set field "richtung" to "vorwärts"
And I press start
Then the table has 5 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge         | ttvcharge     | tlgruppe  |
    | 1             | icon:folder_closed    | EK02_CHARGE   | UMCHARGE_02_EK    | CHEK02AB1_EXT | KARLSRUHE |
    | 0             |                       |               |                   |               |           |
    | 1             | icon:folder_closed    | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | CHEK02AB1_EXT | BERLIN    |
    | 0             |                       |               |                   |               |           |
    | 1             | icon:folder_closed    | BG_2ST_CHARGE | CHBGST2ZU2_EXT    | CHEK02AB1_EXT | BERLIN    |
And I set field "lgruppe" to "BERLIN"
And I press start
Then the table has 3 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge         | ttvcharge     | tlgruppe  |
    | 1             | icon:folder_closed    | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | CHEK02AB1_EXT | BERLIN    |
    | 0             |                       |               |                   |               |           |
    | 1             | icon:folder_closed    | BG_2ST_CHARGE | CHBGST2ZU2_EXT    | CHEK02AB1_EXT | BERLIN    |
And I press button "auf"
Then the table has 7 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge         | telex         | ttvcharge         | tlgruppe  |
    | 1             | icon:folder_opened    | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | EK02_CHARGE   | CHEK02AB1_EXT     | BERLIN    |
    | 2             |                       |               |                   | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | BERLIN    |
    | 2             |                       |               |                   | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | BERLIN    |
    | 2             |                       |               |                   | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | BERLIN    |
    | 0             |                       |               |                   |               |                   |           |
    | 1             | icon:folder_opened    | BG_2ST_CHARGE | CHBGST2ZU2_EXT    | EK02_CHARGE   | CHEK02AB1_EXT     | BERLIN    |
    | 2             |                       |               |                   | BG_2ST_CHARGE | CHBGST2ZU2_EXT    | BERLIN    |
And I set field "lgruppe" to ""
And I press start
And I press button "auf"
Then the table has 10 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge         | telex         | ttvcharge         | tlgruppe  |
    | 1             | icon:folder_opened    | EK02_CHARGE   | UMCHARGE_02_EK    | EK02_CHARGE   | CHEK02AB1_EXT     | KARLSRUHE |
    | 2             |                       | BG01_CHARGE   | CHAZU_NEU         | EK02_CHARGE   | UMCHARGE_02_EK    | KARLSRUHE |
    | 0             |                       |               |                   |               |                   |           |
    | 1             | icon:folder_opened    | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | EK02_CHARGE   | CHEK02AB1_EXT     | BERLIN    |
    | 2             |                       |               |                   | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | BERLIN    |
    | 2             |                       |               |                   | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | BERLIN    |
    | 2             |                       |               |                   | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | BERLIN    |
    | 0             |                       |               |                   |               |                   |           |
    | 1             | icon:folder_opened    | BG_2ST_CHARGE | CHBGST2ZU2_EXT    | EK02_CHARGE   | CHEK02AB1_EXT     | BERLIN    |
    | 2             |                       | BG_2ST_CHARGE | UMCHARGE_01_BG    | BG_2ST_CHARGE | CHBGST2ZU2_EXT    | KARLSRUHE |
And I close the current editor


Scenario: IS09 Zeilenlupe bei Randbewegung, Beleg, Kunde, Lieferant, Lagergruppen

Given I open an editor "EKRE_03" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+EKRE_03"
And I close the current editor

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHBGST2ZU1_EXT"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 3 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge         | ttvcharge     | tlgruppe  |
    | 1             | icon:folder_closed    | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | CHEK02AB1_EXT | BERLIN    |
    | 0             |                       |               |                   |               |           |
    | 1             |                       | BG_2ST_CHARGE | CHBGST2ZU1_EXT    | CHBG01AB1_EXT | BERLIN    |
And I press button "auf"
Then the table has 5 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge         | detursache        | ttvcharge     | tlgruppe  | tbeleg            | tkl   | tlgruppezu | tlgruppeab   |
    | 1             | icon:folder_opened    | BG_2ST_CHARGE | CHBGST2ZU1_EXT    |                   | CHEK02AB1_EXT | BERLIN    |                   |       |            |              |
    | 2             |                       | EK02_CHARGE   | CHEK02AB1_EXT     | Rechnung          |               | KARLSRUHE | !EKRE_03^nummer   | L 1   | KARLSRUHE  |              |
    | 2             |                       | EK02_CHARGE   | CHEK02AB1_EXT     | Rechnung          |               | BERLIN    | !EKRE_03^nummer   | L 1   | BERLIN     |              |
    | 0             |                       |               |                   | ----------------  |               |           |                   |       |            |              |
    | 1             |                       | BG_2ST_CHARGE | CHBGST2ZU1_EXT    |                   | CHBG01AB1_EXT | BERLIN    |                   |       |            |              |
And I close the current editor

Given I open an editor "VKLS_01" from table "(Sales):(PackingSlip)" with command "VIEW" for record "VKLS_01"
And I close the current editor

Given I open an editor "VKLS_02" from table "(Sales):(PackingSlip)" with command "VIEW" for record "VKLS_02"
And I close the current editor

Given I open an editor "EKLS_01" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "EKLS_01"
And I close the current editor

Given I open an editor "EKRE_01" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+EKRE_01"
And I close the current editor

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHST3ZU1"
And I set field "richtung" to "vorwärts"
And I press start
Then the table has 3 rows
Then table has values
    | tbaumstufe    | tfartikel | tncharge  | detursache            | telex         | ttvcharge | tlgruppe  | tbeleg             | tkl       | tlgruppezu | tlgruppeab   |
    | 0             |           |           | Lieferschein Verkauf  | BG_3ST_CHARGE | CHST3ZU1  | KARLSRUHE | !VKLS_01^nummer    | K 1       |            | KARLSRUHE    |
    | 0             |           |           | Lieferschein Verkauf  | BG_3ST_CHARGE | CHST3ZU1  | KARLSRUHE | !VKLS_02^nummer    | K 70001   |            | KARLSRUHE    |
    | 0             |           |           | Lieferschein Verkauf  | BG_3ST_CHARGE | CHST3ZU1  | KARLSRUHE | !VKLS_02^nummer    | K 70001   |            | KARLSRUHE    |
And I set field "richtung" to "rückwärts"
And I press start
And I press button "auf"
Then the table has 8 rows
Then table has values
    | !row  | tbaumstufe    | tfartikel     | ttncharge | detursache            | telex | ttvcharge | tlgruppe  | tbeleg            | tkl       | tlgruppezu | tlgruppeab   |
    | 5     | 4             | EK01_CHARGE   | CHAB11    | Manueller Zugang      |       |           | KARLSRUHE | LBU_001           |           | KARLSRUHE  |              |
    | 6     | 4             | EK01_CHARGE   | CHAB11    | Rechnung              |       |           | KARLSRUHE | !EKRE_01^nummer   | L 1       | KARLSRUHE  |              |
    | 7     | 4             | EK01_CHARGE   | CHAB11    | Lieferschein Einkauf  |       |           | KARLSRUHE | !EKLS_01^nummer   | L 1       | KARLSRUHE  |              |
And I close the current editor


Scenario: IS10 Nur die letzten Stufen anzeigen, verdichtete Anzeige, vorwaerts

# Chargenverfolgungsobjekt oeffnen, um Zugriff zu haben fuer Vergleich im Infosystem
Given I open an editor "CHVERF2_3" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHST3ZU2;vcharge^exnum==CHST2ZU2;elex==BG_2ST_CHARGE;"
And I close the current editor

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHAB11"
Then field "richtung" has value "vorwärts"
And I set field "letzte" to "ja"
And I press start
Then the table has 5 rows
Then table has values
    | tbaumstufe    | aufzu | tchverfobj    | tfartikel     | ttncharge | detursache            | telex         | ttvcharge | tlgruppe  |
    | 4             |       |               |               |           | Lieferschein Verkauf  | BG_3ST_CHARGE | CHST3ZU1  | KARLSRUHE |
    | 4             |       |               |               |           | Lieferschein Verkauf  | BG_3ST_CHARGE | CHST3ZU1  | KARLSRUHE |
    | 4             |       |               |               |           | Lieferschein Verkauf  | BG_3ST_CHARGE | CHST3ZU1  | KARLSRUHE |
    | 0             |       |               |               |           | ----------------      |               |           |           |
    | 3             |       | !CHVERF2_3^id | BG_3ST_CHARGE | CHST3ZU2  |                       | BG_2ST_CHARGE | CHST2ZU2  | KARLSRUHE |
And I close the current editor


Scenario: IS11 Nur die letzten Stufen anzeigen, verdichtete Anzeige, rueckwaerts

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHST3ZU1"
And I set field "letzte" to "ja"
And I set field "richtung" to "rückwärts"
And I press start
Then the table has 5 rows
Then table has values
    | tbaumstufe    | tfartikel     | ttncharge | detursache            | telex         | ttvcharge | tlgruppe  | tbeleg            | tkl       | tlgruppezu | tlgruppeab   |
    | 2             | BG_2ST_CHARGE | CHST2ZU1  |                       | EK02_CHARGE   | CHAB33    | KARLSRUHE |                   |           |            |              |
    | 4             | EK01_CHARGE   | CHAB11    | Manueller Zugang      |               |           | KARLSRUHE | LBU_001           |           | KARLSRUHE  |              |
    | 4             | EK01_CHARGE   | CHAB11    | Rechnung              |               |           | KARLSRUHE | !EKRE_01^nummer   | L 1       | KARLSRUHE  |              |
    | 4             | EK01_CHARGE   | CHAB11    | Lieferschein Einkauf  |               |           | KARLSRUHE | !EKLS_01^nummer   | L 1       | KARLSRUHE  |              |
    | 3             | BG01_CHARGE   | CHST1ZU1  |                       | EK02_CHARGE   | CHAB22    | KARLSRUHE |                   |           |            |              |
And I close the current editor


Scenario: IS12 Nur die letzten Stufen anzeigen, keine weiteren Trennzeilen einfuegen, wenn bereits vorhanden

Given I open the infosystem "LOTTRACKING"
And I set field "exnum" to "1010ZU"
And I set field "richtung" to "rückwärts"
And I press start
Then table has values
    | tbaumstufe    | aufzu | tfartikel     | ttncharge | detursache        | telex         | ttvcharge | tlgruppe  |
    | 1             |       | BG01_CHARGE   | 1010ZU    |                   | EK01_CHARGE   | 1010      | KARLSRUHE |
    | 0             |       |               |           | ----------------  |               |           |           |
    | 1             |       | BG01_CHARGE   | 1010ZU    |                   | EK02_CHARGE   | 1010      | KARLSRUHE |
And I set field "letzte" to "ja"
Then the table has 0 rows
And I press start
# Tabelle bleibt gleich, weil es schon die letzte Stufe ist, es werden aus FOP BFUSS keine weiteren Trennzeilen eingefuegt
Then table has values
    | tbaumstufe    | aufzu | tfartikel     | ttncharge | detursache        | telex         | ttvcharge | tlgruppe  |
    | 1             |       | BG01_CHARGE   | 1010ZU    |                   | EK01_CHARGE   | 1010      | KARLSRUHE |
    | 0             |       |               |           | ----------------  |               |           |           |
    | 1             |       | BG01_CHARGE   | 1010ZU    |                   | EK02_CHARGE   | 1010      | KARLSRUHE |
And I close the current editor


Scenario: IS13 Nur die letzten Stufen anzeigen, wenn es keine Randbewegung aus LJ gibt

Given I open an editor "EKMATCHA" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such          | EKMATCHA          |
    | namebspr      | Rohmaterial       |
    | chverfolgung  | Chargenverfolgung |
And I save the current editor

Given I open an editor "BG1STUFE" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | such          | BG1STUFE          |
    | namebspr      | Baugruppe 1 Stufe |
    | bsart         | Eigenfertigung    |
    | chverfolgung  | Chargenverfolgung |
And I append rows
    | elex          | elanzahl  |
    | EKMATCHA      | 1         |
    | A AG1         | 1         |
And I save the current editor

Given I open an editor "BG2STUFEN" from table "(Part):(Product)" with command "COPY" for record "BG1STUFE"
And I set fields
    | such          | BG2STUFEN         |
    | namebspr      | Baugruppe 2 Stufe |
    | bsart         | Eigenfertigung    |
    | chverfolgung  | Chargenverfolgung |
And I modify table
    | !row  | elex      | elanzahl  |
    | 1     | BG1STUFE  | 1         |
And I save the current editor

Given I open an editor "BG3STUFEN" from table "(Part):(Product)" with command "COPY" for record "BG1STUFE"
And I set fields
    | such          | BG3STUFEN         |
    | namebspr      | Baugruppe 3 Stufe |
    | bsart         | Eigenfertigung    |
    | chverfolgung  | Chargenverfolgung |
And I modify table
    | !row  | elex      | elanzahl  |
    | 1     | BG2STUFEN | 1         |
And I save the current editor

Given I create a work order "BA_BG1ST" for Product "BG1STUFE" with quantity "10" and search word "BA_BG1ST_"
Given I create a work order "BA_BG2ST" for Product "BG2STUFEN" with quantity "10" and search word "BA_BG2ST_"
Given I create a work order "BA_BG3ST" for Product "BG3STUFEN" with quantity "10" and search word "BA_BG3ST_"

Given I create a Lot "CH1EK" for Product "EKMATCHA"
Given I create a Lot "CH3ZU1" for Product "BG1STUFE"
Given I create a Lot "CH4ZU1" for Product "BG1STUFE"
Given I create a Lot "CH5ZU2" for Product "BG2STUFEN"
Given I create a Lot "CH6ZU2" for Product "BG2STUFEN"
Given I create a Lot "CH80ZU3" for Product "BG3STUFEN"
Given I create a Lot "CH81ZU3" for Product "BG3STUFEN"

Given I open an editor "EKLS_01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | TEST     |
    | such   | EKLS_11  |
    | ebeleg | EKLS_11  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel   | mge | charge     |
    | EKMATCHA  | 20  | !CH1EK^id  |
And I save the current editor

Given I open an editor "BA_BG1ST" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA_BG1ST_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge     |
    | +1    | F1     | 10       | !CH1EK^id  |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_BG1ST"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row  | lpsuch | zuomge   | charge     |
    | +1    | F1     | 5        | !CH3ZU1^id |
    | +2    | F1     | 5        | !CH4ZU1^id |
And I save the current editor
And I switch the current editor to editor "BA_BG1ST"
And I save the current editor

Given I open an editor "BA_BG2ST" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA_BG2ST_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge     |
    | +1    | F1     | 5        | !CH3ZU1^id |
    | +2    | F1     | 5        | !CH4ZU1^id |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_BG2ST"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row  | lpsuch | zuomge   | charge     |
    | +1    | F1     | 5        | !CH5ZU2^id |
    | +2    | F1     | 5        | !CH6ZU2^id |
And I save the current editor
And I switch the current editor to editor "BA_BG2ST"
And I save the current editor

Given I open an editor "BA_BG3ST" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA_BG3ST_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge     |
    | +1    | F1     | 10       | !CH5ZU2^id |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_BG3ST"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row  | lpsuch | zuomge   | charge        |
    | +1    | F1     | 5        | !CH80ZU3^id   |
    | +2    | F1     | 5        | !CH81ZU3^id   |
And I save the current editor
And I switch the current editor to editor "BA_BG3ST"
And I save the current editor

# Rueckmeldung, Zugangsbuchung
Given I open an editor "RM1_BA_BG1ST" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA_BG1ST_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "RM1_BA_BG2ST" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA_BG2ST_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "RM1_BA_BG3ST" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA_BG3ST_001;@richtung=rückwärts;@maxordtreffer=1"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CH1EK"
And I set field "letzte" to "ja"
Then field "richtung" has value "vorwärts"
And I press start
Then the table has 4 rows
Then table has values
    | tbaumstufe    | tfartikel     | ttncharge | detursache            | telex         | ttvcharge | tlgruppe  |
    | 3             | BG3STUFEN     | CH80ZU3   |                       | BG2STUFEN     | CH5ZU2    | KARLSRUHE |
    | 3             | BG3STUFEN     | CH81ZU3   |                       | BG2STUFEN     | CH5ZU2    | KARLSRUHE |
    | 0             |               |           | ----------------      |               |           |           |
    | 2             | BG2STUFEN     | CH6ZU2    |                       | BG1STUFE      | CH4ZU1    | KARLSRUHE |
And I close the current editor


Scenario: IS14 Bestand und Icon fuer Zwischenstufen testen im Infosystem

# Bestand zubuchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BG01_CHARGE   |
    | buart     | Zugang        |
    | beleg     | LBU_014       |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  |
    | 5      | F1       | CHST1ZU1  |
    | 5      | F1       | CHST1ZU2  |
And I save the current editor

# Abgaenge buchen fuer Zwischenstufen
Given I open an editor "VKLS_14" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde  | TEST     |
    | such   | VKLS_14  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge | charge      |
    | BG_2ST_CHARGE | 1   | CHST2ZU1    |
    | BG01_CHARGE   | 1   | CHST1ZU2    |
And I save the current editor

Given I open the infosystem "LOTTRACKING"
And I set field "charge" to "CHAB11"
Then field "richtung" has value "vorwärts"
And I set field "lgruppe" to ""
And I press start
Then the table has 3 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | tnchargemge   | tljabgang             | ttvcharge | tvchargemge   | tlgruppe  |
    | 1             | icon:folder_closed    | BG01_CHARGE   | CHST1ZU1  | 5             |                       | CHAB11    | 50            | KARLSRUHE |
    | 0             |                       |               |           | 0             |                       |           | 0             |           |
    | 1             | icon:folder_closed    | BG01_CHARGE   | CHST1ZU2  | 4             | icon:arrow_blue_down  | CHAB11    | 50            | KARLSRUHE |
And I press button "auf"
Then the table has 10 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | tnchargemge   | tljabgang             | telex         | ttvcharge | tvchargemge   | tlgruppe  |
    | 1             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU1  | 5             |                       | EK01_CHARGE   | CHAB11    | 50            | KARLSRUHE |
    | 2             | icon:folder_opened    | BG_2ST_CHARGE | CHST2ZU1  | -1            | icon:arrow_blue_down  | BG01_CHARGE   | CHST1ZU1  | 5             | KARLSRUHE |
    | 3             | icon:folder_opened    | BG_3ST_CHARGE | CHST3ZU1  | 0             |                       | BG_2ST_CHARGE | CHST2ZU1  | -1            | KARLSRUHE |
    | 4             |                       |               |           | 0             |                       | BG_3ST_CHARGE | CHST3ZU1  | 0             | KARLSRUHE |
    | 4             |                       |               |           | 0             |                       | BG_3ST_CHARGE | CHST3ZU1  | 0             | KARLSRUHE |
    | 4             |                       |               |           | 0             |                       | BG_3ST_CHARGE | CHST3ZU1  | 0             | KARLSRUHE |
    | 0             |                       |               |           | 0             |                       |               |           | 0             |           |
    | 1             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU2  | 4             | icon:arrow_blue_down  | EK01_CHARGE   | CHAB11    | 50            | KARLSRUHE |
    | 2             | icon:folder_opened    | BG_2ST_CHARGE | CHST2ZU2  | 0             |                       | BG01_CHARGE   | CHST1ZU2  | 4             | KARLSRUHE |
    | 3             |                       | BG_3ST_CHARGE | CHST3ZU2  | 25            |                       | BG_2ST_CHARGE | CHST2ZU2  | 0             | KARLSRUHE |
And I press button "zu"
Then the table has 3 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | tnchargemge   | tljabgang             | ttvcharge | tvchargemge   | tlgruppe  |
    | 1             | icon:folder_closed    | BG01_CHARGE   | CHST1ZU1  | 5             |                       | CHAB11    | 50            | KARLSRUHE |
    | 0             |                       |               |           | 0             |                       |           | 0             |           |
    | 1             | icon:folder_closed    | BG01_CHARGE   | CHST1ZU2  | 4             | icon:arrow_blue_down  | CHAB11    | 50            | KARLSRUHE |
And I press button "aufzu" in row 3
Then the table has 4 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | tnchargemge   | tljabgang             | ttvcharge | tvchargemge   | tlgruppe  |
    | 1             | icon:folder_closed    | BG01_CHARGE   | CHST1ZU1  | 5             |                       | CHAB11    | 50            | KARLSRUHE |
    | 0             |                       |               |           | 0             |                       |           | 0             |           |
    | 1             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU2  | 4             | icon:arrow_blue_down  | CHAB11    | 50            | KARLSRUHE |
    | 2             | icon:folder_closed    | BG_2ST_CHARGE | CHST2ZU2  | 0             |                       | CHST1ZU2  | 4             | KARLSRUHE |
And I press button "aufzu" in row 4
Then the table has 5 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | tnchargemge   | tljabgang             | ttvcharge | tvchargemge   | tlgruppe  |
    | 1             | icon:folder_closed    | BG01_CHARGE   | CHST1ZU1  | 5             |                       | CHAB11    | 50            | KARLSRUHE |
    | 0             |                       |               |           | 0             |                       |           | 0             |           |
    | 1             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU2  | 4             | icon:arrow_blue_down  | CHAB11    | 50            | KARLSRUHE |
    | 2             | icon:folder_opened    | BG_2ST_CHARGE | CHST2ZU2  | 0             |                       | CHST1ZU2  | 4             | KARLSRUHE |
    | 3             |                       | BG_3ST_CHARGE | CHST3ZU2  | 25            |                       | CHST2ZU2  | 0             | KARLSRUHE |
And I press button "aufzu" in row 4
Then the table has 4 rows
Then table has values
    | tbaumstufe    | aufzu                 | tfartikel     | ttncharge | tnchargemge   | tljabgang             | ttvcharge | tvchargemge   | tlgruppe  |
    | 1             | icon:folder_closed    | BG01_CHARGE   | CHST1ZU1  | 5             |                       | CHAB11    | 50            | KARLSRUHE |
    | 0             |                       |               |           | 0             |                       |           | 0             |           |
    | 1             | icon:folder_opened    | BG01_CHARGE   | CHST1ZU2  | 4             | icon:arrow_blue_down  | CHAB11    | 50            | KARLSRUHE |
    | 2             | icon:folder_closed    | BG_2ST_CHARGE | CHST2ZU2  | 0             |                       | CHST1ZU2  | 4             | KARLSRUHE |
And I close the current editor
