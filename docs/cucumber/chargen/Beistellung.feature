@persistent
Feature: Chargen_Seriennummern_EKVK_Lager.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Chargen_Seriennummern_EKVK_Lager.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Chargen-/Seriennummernverwaltung
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************

Scenario: BEI01CH EK mit Beistellung - Zugangscharge in der BeistellMZ, Teilmengen buchen - und Test der Icon

Given I create a Lot "ZU1BEI01CH" for Product "KT-BEISTELL"
Given I create a Lot "ZU2BEI01CH" for Product "KT-BEISTELL"
Given I create a Lot "AB1BEI01CH" for Product "EKBEI"
Given I create a Lot "AB2BEI01CH" for Product "EKBEI"
Given I create a Lot "AB3BEI01CH" for Product "EKBEI"

Given I open an editor "BE-BEI01CH" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BEI01CH  |
    | ebeleg | BEI01CH  |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel       | mge |
    | KT-BEISTELL   | 15  |
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge            | zcharge           |
    | +1    | F1     | 3        | !AB1BEI01CH^id    | !ZU1BEI01CH^id    |
    | +2    | F1     | 7        | !AB2BEI01CH^id    | !ZU1BEI01CH^id    |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lieferscheine aus Bestellung des Kaufteils, Zugangscharge in der Position eintragen
# es soll die zugehoerige Abgangscharge aus der MZ genommen werden
Given I open an editor "L1BEI01CH" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BEI01CH"
And I set fields
   | ebeleg | LS1-BEI01CH |
   | such   | L1BEI01CH   |
   | ueb    | ja          |
   | vom    | .           |
And I set field "mge" to "6" in row 1
# Zugangscharge eintragen
And I set field "charge" to "!ZU1BEI01CH^id" in row 1
And I save the current editor

Given I open an editor "L2BEI01CH" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BEI01CH"
And I set fields
   | ebeleg | LS2-BEI01CH |
   | such   | L2BEI01CH   |
   | ueb    | nein        |
   | vom    | .           |
And I set field "mge" to "9" in row 1
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
# Zugangscharge in der MZ fuer das Kaufteil angeben, da 2 unterschiedliche Chargen
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge            |
    |  1    | F1     | 4        | !ZU1BEI01CH^id    |
    | +2    | F2     | 5        | !ZU2BEI01CH^id    |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow" in row 1
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I append rows
    | lpsuch | zuomge   | charge            | zcharge           |
    | F2     | 5        | !AB3BEI01CH^id    | !ZU2BEI01CH^id    |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "BEI01CH" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "+BEI01CH"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I save value from field "id" in row 1
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "chverfobjekt1" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==ZU1BEI01CH;vcharge^exnum==AB1BEI01CH;elex==EKBEI;"
Then field "reserv^id" in row 0 equals saved value
And I close the current editor

Given I open an editor "chverfobjekt2" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==ZU1BEI01CH;vcharge^exnum==AB2BEI01CH;elex==EKBEI;"
Then field "reserv^id" in row 0 equals saved value
And I close the current editor

Given I open an editor "chverfobjekt3" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==ZU2BEI01CH;vcharge^exnum==AB3BEI01CH;elex==EKBEI;"
Then field "reserv^id" in row 0 equals saved value
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!L1BEI01CH^num"
And I press start
Then table has values
    | art           | zmge | amge     | vcharge^id      | vplatz    | ncharge^id        | nplatz    |
    | EKBEI         |      | 3        | !AB1BEI01CH^id  | F1        | !ZU1BEI01CH^id    |           |
    | EKBEI         |      | 3        | !AB2BEI01CH^id  | F1        | !ZU1BEI01CH^id    |           |
    | KT-BEISTELL   | 6    |          | (0,0,0)         |           | !ZU1BEI01CH^id    | F1        |
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!L2BEI01CH^num"
And I press start
Then table has values
    | art           | zmge | amge     | vcharge^id      | vplatz    | ncharge^id        | nplatz    |
    | EKBEI         |      | 4        | !AB2BEI01CH^id  | F1        | !ZU1BEI01CH^id    |           |
    | EKBEI         |      | 5        | !AB3BEI01CH^id  | F2        | !ZU2BEI01CH^id    |           |
    | KT-BEISTELL   | 4    |          | (0,0,0)         |           | !ZU1BEI01CH^id    | F1        |
    | KT-BEISTELL   | 5    |          | (0,0,0)         |           | !ZU2BEI01CH^id    | F2        |
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EKBEI;buarta==Abgang;platz==F1;ebeleg==LS1-BEI01CH;tvcharge==AB1BEI01CH"
Then fields have values
    | artikel       | EKBEI			        |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 3                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
Then field "vcharge^id" has value "!AB1BEI01CH^id" in row 1
Then field "ncharge^id" has value "!ZU1BEI01CH^id" in row 1
Then field "chverfobj^id" has value "!chverfobjekt1^id" in row 1
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EKBEI;buarta==Abgang;platz==F1;ebeleg==LS1-BEI01CH;tvcharge==AB2BEI01CH"
Then fields have values
    | artikel       | EKBEI			        |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 3                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
Then field "vcharge^id" has value "!AB2BEI01CH^id" in row 1
Then field "ncharge^id" has value "!ZU1BEI01CH^id" in row 1
Then field "chverfobj^id" has value "!chverfobjekt2^id" in row 1
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EKBEI;buarta==Abgang;platz==F1;ebeleg==LS2-BEI01CH;tvcharge==AB2BEI01CH"
Then fields have values
    | artikel       | EKBEI			        |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 4                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
Then field "vcharge^id" has value "!AB2BEI01CH^id" in row 1
Then field "ncharge^id" has value "!ZU1BEI01CH^id" in row 1
Then field "chverfobj^id" has value "!chverfobjekt2^id" in row 1
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EKBEI;buarta==Abgang;platz==F2;ebeleg==LS2-BEI01CH;tvcharge==AB3BEI01CH"
Then fields have values
    | artikel       | EKBEI			        |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 5                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
Then field "vcharge^id" has value "!AB3BEI01CH^id" in row 1
Then field "ncharge^id" has value "!ZU2BEI01CH^id" in row 1
Then field "chverfobj^id" has value "!chverfobjekt3^id" in row 1
And I close the current editor


Scenario: BEI02CH EK mit Beistellung - Zugangscharge in der BeistellMZ, Teilmengen buchen, andere Reihenfolge als in MZ

Given I create a Lot "ZU1BEI02CH" for Product "KT-BEISTELL"
Given I create a Lot "ZU2BEI02CH" for Product "KT-BEISTELL"
Given I create a Lot "AB1BEI02CH" for Product "EKBEI"
Given I create a Lot "AB2BEI02CH" for Product "EKBEI"
Given I create a Lot "AB3BEI02CH" for Product "EKBEI"

Given I open an editor "BE-BEI02CH" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BEI02CH  |
    | ebeleg | BEI02CH  |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel       | mge |
    | KT-BEISTELL   | 15  |
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge            | zcharge           |
    | +1    | F1     | 3        | !AB1BEI02CH^id    | !ZU1BEI02CH^id    |
    | +2    | F1     | 7        | !AB2BEI02CH^id    | !ZU1BEI02CH^id    |
    | +3    | F2     | 5        | !AB3BEI02CH^id    | !ZU2BEI02CH^id    |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lieferscheine aus Bestellung des Kaufteils, Zugangscharge in der Position eintragen
# es soll die zugehoerige Abgangscharge aus der MZ genommen werden
Given I open an editor "L1BEI02CH" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BEI02CH"
And I set fields
   | ebeleg | LS1-BEI02CH |
   | such   | L1BEI02CH   |
   | ueb    | ja          |
   | vom    | .           |
And I set field "mge" to "5" in row 1
# Zugangscharge eintragen
And I set field "charge" to "!ZU2BEI02CH^id" in row 1
And I save the current editor

Given I open an editor "L2BEI02CH" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BEI02CH"
And I set fields
   | ebeleg | LS2-BEI02CH |
   | such   | L2BEI02CH   |
   | ueb    | ja          |
   | vom    | .           |
And I set field "mge" to "10" in row 1
# Zugangscharge eintragen
And I set field "charge" to "!ZU1BEI02CH^id" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!L1BEI02CH^num"
And I press start
Then table has values
    | art           | zmge | amge     | vcharge^id      | vplatz    | ncharge^id        | nplatz    |
    | EKBEI         |      | 3        | !AB1BEI02CH^id  | F1        | !ZU1BEI02CH^id    |           |
	| EKBEI         |      | 2        | !AB2BEI02CH^id  | F1        | !ZU1BEI02CH^id    |           |
    | KT-BEISTELL   | 5    |          | (0,0,0)         |           | !ZU2BEI02CH^id    | F1        |
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!L2BEI02CH^num"
And I press start
Then table has values
    | art           | zmge | amge     | vcharge^id      | vplatz    | ncharge^id        | nplatz    |
    | EKBEI         |      | 5        | !AB2BEI02CH^id  | F1        | !ZU1BEI02CH^id    |           |
    | EKBEI         |      | 5        | !AB3BEI02CH^id  | F2        | !ZU2BEI02CH^id    |           |
    | KT-BEISTELL   | 10   |          | (0,0,0)         |           | !ZU1BEI02CH^id    | F1        |
And I close the current editor


## Scenario BEI01 - BEI05 mit Menge 1, damit spaeter auf Seriennummernverfolgung umgestellt werden kann
Scenario: BEI01 EK mit Beistellung - Zugangscharge in der AFL-Zeile des Beistellteils

Given I create a Lot "ZU1BEI01" for Product "KT-BEISTELL"
Given I create a Lot "AB1BEI01" for Product "EKBEI"

Given I open an editor "BE-BEI01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BE-BEI01 |
    | ebeleg | BE-BEI01 |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel       | mge |
    | KT-BEISTELL   |  1  |
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I modify table
    | !row  | charge        | zcharge      |
    | 1     | !AB1BEI01^id  | !ZU1BEI01^id |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lieferscheine aus Bestellung des Kaufteils, gleiche Charge eintragen, wie in der AFL
Given I open an editor "LS1-BEI01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-BEI01"
And I set fields
   | ebeleg | LS1-BEI01 |
   | such   | LS1-BEI01 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "1" in row 1
And I set field "charge" to "!ZU1BEI01^id" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1-BEI01^num"
And I press start
Then table has values
    | art           | zmge | amge     | vcharge^id     | vplatz    | ncharge^id    | nplatz    |
    | EKBEI         |      | 1        | !AB1BEI01^id   | F1        | !ZU1BEI01^id  |           |
    | KT-BEISTELL   | 1    |          | (0,0,0)        |           | !ZU1BEI01^id  | F1        |
And I close the current editor


Scenario: BEI02 EK mit Beistellung - Zugangscharge in der AFL-Zeile des Beistellteils und abweichende Zugangscharge im Vorgang

Given I create a Lot "ZU1BEI02" for Product "KT-BEISTELL"
Given I create a Lot "ZU2BEI02" for Product "KT-BEISTELL"
Given I create a Lot "AB1BEI02" for Product "EKBEI"

Given I open an editor "BE-BEI02" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BE-BEI02 |
    | ebeleg | BE-BEI02 |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel       | mge |
    | KT-BEISTELL   |  1  |
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I modify table
    | !row  | charge        | zcharge       |
    | 1     | !AB1BEI02^id  | !ZU1BEI02^id  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lieferscheine aus Bestellung des Kaufteils, in der Position andere Charge eintragen als in der AFL
Given I open an editor "LS1-BEI02" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-BEI02"
And I set fields
   | ebeleg | LS1-BEI02 |
   | such   | LS1-BEI02 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "1" in row 1
# Zugangscharge passt nicht zur AFL, Abgangscharge wird nicht angegeben => Abgangscharge und Zugangscharge aus AFL werden gebucht
And I set field "charge" to "!ZU2BEI02^id" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1-BEI02^num"
And I press start
Then table has values
    | art           | zmge | amge     | vcharge^id     | vplatz    | ncharge^id     | nplatz    |
    | EKBEI         |      | 1        | !AB1BEI02^id   | F1        | !ZU1BEI02^id   |           |
    | KT-BEISTELL   | 1    |          | (0,0,0)        |           | !ZU2BEI02^id   | F1        |
And I close the current editor


Scenario: BEI03 EK mit Beistellung - Zugangscharge in der BeistellMZ

Given I create a Lot "ZU1BEI03" for Product "KT-BEISTELL"
Given I create a Lot "AB1BEI03" for Product "EKBEI"

Given I open an editor "BE-BEI03" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BE-BEI03 |
    | ebeleg | BE-BEI03 |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel       | mge |
    | KT-BEISTELL   |  1  |
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        | zcharge       |
    | +1    | F1     | 1        | !AB1BEI03^id  | !ZU1BEI03^id  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lieferscheine aus Bestellung des Kaufteils, gleiche Charge eintragen, wie in der MZ
Given I open an editor "LS1-BEI03" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-BEI03"
And I set fields
   | ebeleg | LS1-BEI03 |
   | such   | LS1-BEI03 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "1" in row 1
And I set field "charge" to "!ZU1BEI03^id" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1-BEI03^num"
And I press start
Then table has values
    | art           | zmge | amge     | vcharge^id     | vplatz    | ncharge^id    | nplatz    |
    | EKBEI         |      | 1        | !AB1BEI03^id   | F1        | !ZU1BEI03^id  |           |
    | KT-BEISTELL   | 1    |          | (0,0,0)        |           | !ZU1BEI03^id  | F1        |
And I close the current editor


Scenario: BEI04 EK mit Beistellung - Zugangscharge in der BeistellMZ, abweichende Charge in LS-Position

Given I create a Lot "ZU1BEI04" for Product "KT-BEISTELL"
Given I create a Lot "ZU2BEI04" for Product "KT-BEISTELL"
Given I create a Lot "AB1BEI04" for Product "EKBEI"

Given I open an editor "BE-BEI04" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BE-BEI04 |
    | ebeleg | BE-BEI04 |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel       | mge |
    | KT-BEISTELL   |  1  |
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        | zcharge       |
    | +1    | F1     | 1        | !AB1BEI04^id  | !ZU1BEI04^id  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lieferscheine aus Bestellung des Kaufteils, abweichende Charge eintragen, als in der MZ
Given I open an editor "LS1-BEI04" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-BEI04"
And I set fields
   | ebeleg | LS1-BEI04 |
   | such   | LS1-BEI04 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "1" in row 1
# Zugangscharge passt nicht zur MZ, Abgangscharge wird nicht angegeben, es werden Chargen aus MZ gebucht
And I set field "charge" to "!ZU2BEI04^id" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1-BEI04^num"
And I press start
Then table has values
    | art           | zmge | amge     | vcharge^id     | vplatz    | ncharge^id    | nplatz    |
    | EKBEI         |      | 1        | !AB1BEI04^id   | F1        | !ZU1BEI04^id  |           |
    | KT-BEISTELL   | 1    |          | (0,0,0)        |           | !ZU2BEI04^id  | F1        |
And I close the current editor



Scenario: BEI05 EK mit Beistellung - Zugangscharge in der BeistellMZ und in der MZ des Kaufteils

Given I create a Lot "ZU1BEI05" for Product "KT-BEISTELL"
Given I create a Lot "ZU2BEI05" for Product "KT-BEISTELL"
Given I create a Lot "AB1BEI05" for Product "EKBEI"

Given I open an editor "BE-BEI05" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BE-BEI05 |
    | ebeleg | BE-BEI05 |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel       | mge |
    | KT-BEISTELL   |  1  |
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        | zcharge       |
    | +1    | F1     | 1        | !AB1BEI05^id  | !ZU1BEI05^id  |
And I save the current subeditor to switch back to the parent editor
# MZ fuer das Kaufteil anlegen mit abweichender Zugangscharge
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        |
    | 1     | F2     | 1        | !ZU2BEI05^id  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lieferscheine aus Bestellung des Kaufteils, keine Charge eintragen, soll aus MZ genommen werden
Given I open an editor "LS1-BEI05" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-BEI05"
And I set fields
   | ebeleg | LS1-BEI05 |
   | such   | LS1-BEI05 |
   | ueb    | ja        |
   | vom    | .         |
And I set field "mge" to "1" in row 1
## die Zugangscharge des Kaufteils soll aus der MZ fuer das Fertigteil genommen werden
## dann soll zu dieser Zugangscharge eine passende Abgangscharge in der BeistellMZ gesucht werden
## gibt es keine passende, dann Abbruch mit Fehlermeldung
# 7037 Beistellung wird nicht gebucht, weil die Menge der MZ zu klein und harte Bindung Zugang-Abgang-Charge aufzubauen ist.
#Then saving the current editor throws the exception "7037"
## dann kann man die passende Zugangscharge im Vorgang eintragen und die Abgangscharge wird dann aus der BeistellMZ genommen
#And I set field "charge" to "!ZU1BEI05^id" in row 1
#And I save the current editor
    ## Charge im Vorgang eintragen bringt nichts, die wird ignoriert, es wird die Charge aus der MZ genommen
    ## hier entweder nur den Abbruch testen oder die MZ aendern und dann buchen
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1-BEI05^num"
And I press start
Then table has values
    | art           | zmge | amge     | vcharge^id     | vplatz    | ncharge^id    | nplatz    |
    | EKBEI         |      | 1        | !AB1BEI05^id   | F1        | !ZU1BEI05^id  |           |
    | KT-BEISTELL   | 1    |          | (0,0,0)        |           | !ZU2BEI05^id  | F2        |
And I close the current editor


Scenario: A4F1_BEI EK mit Beistellung - Zugangscharge in der BeistellMZ und in der ZugangsMZ des Kaufteils

Given I create a Lot "ZU1A4F1_BEI" for Product "KT-BEISTELL"
Given I create a Lot "ZU2A4F1_BEI" for Product "KT-BEISTELL"
Given I create a Lot "AB1A4F1_BEI" for Product "EKBEI"
Given I create a Lot "AB2A4F1_BEI" for Product "EKBEI"

Given I open an editor "BE-A4F1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2     |
    | such   | BE-A4F1      |
    | ebeleg | BE-A4F1_BEI  |
    | tterm  | .            |
    | budat  | .            |
And I append rows
    | artikel       | mge |
    | KT-BEISTELL   | 10  |
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge            | zcharge           |
    | +1    | F1     | 3        | !AB1A4F1_BEI^id   | !ZU1A4F1_BEI^id   |
    | +2    | F1     | 2        | !AB2A4F1_BEI^id   |                   |
And I save the current subeditor to switch back to the parent editor
# MZ fuer das Kaufteil anlegen mit abweichender Zugangscharge
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge            |
    | 1     | F2     | 5        | !ZU1A4F1_BEI^id   |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lieferscheine aus Bestellung des Kaufteils, keine Charge eintragen, soll aus MZ genommen werden
Given I open an editor "LS1-A4F1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-A4F1"
And I set fields
   | ebeleg | LS1-A4F1_BEI  |
   | such   | LS1-A4F1      |
   | ueb    | ja            |
   | vom    | .             |
And I set field "mge" to "4" in row 1
# die Zugangscharge des Kaufteils wird aus der MZ fuer das Fertigteil genommen
# zu dieser Zugangscharge werden passende Zeilen mit Abgangscharge in der BeistellMZ gesucht
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1-A4F1^num"
And I press start
Then table has values
    | art           | zmge | amge     | vcharge^id      | vplatz    | ncharge^id         | nplatz    |
    | EKBEI         |      | 3        | !AB1A4F1_BEI^id | F1        | !ZU1A4F1_BEI^id    |           |
    | EKBEI         |      | 1        | !AB2A4F1_BEI^id | F1        | !ZU1A4F1_BEI^id    |           |
    | KT-BEISTELL   | 4    |          | (0,0,0)         |           | !ZU1A4F1_BEI^id    | F2        |
And I close the current editor


Scenario: A4F2_BEI EK mit Beistellung - Zugangscharge in der BeistellMZ und in der ZugangsMZ des Kaufteils

Given I create a Lot "ZU1A4F2_BEI" for Product "KT-BEISTELL"
Given I create a Lot "ZU2A4F2_BEI" for Product "KT-BEISTELL"
Given I create a Lot "AB1A4F2_BEI" for Product "EKBEI"
Given I create a Lot "AB2A4F2_BEI" for Product "EKBEI"

Given I open an editor "BE-A4F2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2     |
    | such   | BE-A4F2      |
    | ebeleg | BE-A4F2_BEI  |
    | tterm  | .            |
    | budat  | .            |
And I append rows
    | artikel       | mge |
    | KT-BEISTELL   | 10  |
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge            | zcharge           |
    | +1    | F1     | 3        | !AB1A4F2_BEI^id   | !ZU2A4F2_BEI^id   |
    | +2    | F1     | 2        | !AB2A4F2_BEI^id   |                   |
And I save the current subeditor to switch back to the parent editor
# MZ fuer das Kaufteil anlegen mit abweichender Zugangscharge
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge            |
    | 1     | F2     | 5        | !ZU1A4F2_BEI^id   |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lieferscheine aus Bestellung des Kaufteils, keine Charge eintragen, soll aus MZ genommen werden
Given I open an editor "LS1-A4F2" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-A4F2"
And I set fields
   | ebeleg | LS1-A4F2_BEI  |
   | such   | LS1-A4F2      |
   | ueb    | ja            |
   | vom    | .             |
And I set field "mge" to "4" in row 1
# die Zugangscharge des Kaufteils wird aus der MZ fuer das Fertigteil genommen
# zu dieser Zugangscharge werden passende Zeilen mit Abgangscharge in der BeistellMZ gesucht, Joker reicht nur fuer 2 Stueck, danach aus BeistellMZ Zeile mit charge und zcharge
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!LS1-A4F2^num"
And I press start
Then table has values
    | art           | zmge | amge     | vcharge^id      | ncharge^id         |
    | EKBEI         |      | 2        | !AB2A4F2_BEI^id | !ZU1A4F2_BEI^id    |
	| EKBEI         |      | 2        | !AB1A4F2_BEI^id | !ZU2A4F2_BEI^id    |
    | KT-BEISTELL   | 4    |          | (0,0,0)         | !ZU1A4F2_BEI^id    |
And I close the current editor


Scenario: BEI06 EK mit Beistellung - ZugangsMZ mit 3 Chargen und BeistellMZ ohne Zugangscharge, Lieferschein komplett buchen

Given I create a Lot "KT1" for Product "KT-BEISTELL"
Given I create a Lot "KT2" for Product "KT-BEISTELL"
Given I create a Lot "KT3" for Product "KT-BEISTELL"
Given I create a Lot "MatCH10" for Product "EKBEI"

Given I open an editor "BE-BEI06" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BEI06    |
    | ebeleg | BEI06    |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel       | mge |
    | KT-BEISTELL   | 3   |
# Zugangscharge in der MZ fuer das Kaufteil angeben, 3 unterschiedliche Chargen
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge    |
    |  1    | F1     | 1        | !KT1^id   |
    | +2    | F1     | 1        | !KT2^id   |
    | +3    | F1     | 1        | !KT3^id   |
And I save the current subeditor to switch back to the parent editor
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge        |
    | +1    | F1     | 3        | !MatCH10^id   |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lieferscheine aus Bestellung, Komplettmenge, Chargen sollen aus den MZ genommen werden
Given I open an editor "L1BEI06" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BEI06"
And I set fields
   | ebeleg | LS1-BEI06 |
   | such   | L1BEI06   |
   | ueb    | ja        |
   | vom    | .         |
And I press button "offueb" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!L1BEI06^num"
And I press start
Then table has values
    | art           | zmge | amge     | vcharge^id  | ncharge^id    |
    | EKBEI         |      | 1        | !MatCH10^id | !KT1^id       |
    | EKBEI         |      | 1        | !MatCH10^id | !KT2^id       |
    | EKBEI         |      | 1        | !MatCH10^id | !KT3^id       |
    | KT-BEISTELL   | 1    |          | (0,0,0)     | !KT1^id       |
    | KT-BEISTELL   | 1    |          | (0,0,0)     | !KT2^id       |
    | KT-BEISTELL   | 1    |          | (0,0,0)     | !KT3^id       |
And I close the current editor


